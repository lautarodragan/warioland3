"""Path finding over a level's blocks: a movement graph plus A*.

    python3 tests/tools/pathfind.py OUT_OF_THE_WOODS_DAY_1 46:3 10:152

prints a path (in blocks) between two cells, and which moves it uses.

Wario is modelled as one block wide and two tall. A node is the block his
lower half is in; he stands there when the block below supports him. Edges:
walking, falling, jump arcs (up to JUMP_HEIGHT blocks up and JUMP_REACH
across), ladders, swimming, bashing through cracked blocks, and doors,
pipes and walk-in transitions. A transition in sector S leads to the room
table's destination sector for S, where Wario appears below the first $f
(spawn) object in that sector, as SetWarioPositionToSpawn does.

The model is approximate; route_search.py uses distance_field() as its
heuristic and lets the emulator decide what's actually possible.
"""

import argparse
import heapq
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from level_map import LEVEL_HEIGHT, LEVEL_WIDTH, SRC, Level  # noqa: E402

# Measured in the emulator: a jump rises 2.25 blocks, 3.25 with the High
# Jump Boots (POWER 7+) and UP held. Peak after about 1.4 blocks walking,
# 2.25-3.25 running.
JUMP_HEIGHT = 2
JUMP_HEIGHT_HIGH_JUMP_BOOTS = 3
JUMP_REACH = 5

# src/constants/wario_constants.asm
SWIMMING_FLIPPERS = 2
GARLIC = 5
SUPER_JUMP_SLAM_OVERALLS = 6
HIGH_JUMP_BOOTS = 7

SOLID, FLOOR, FREE, LADDER, WATER, HAZARD = range(6)

SLOPES = {"LeftSlope", "RightSlope", "1809f", "180b5", "18129", "1813f"}
DOORS = {"Door"}  # TreasureDoor exits the level, it's no room transition
WALK_INS = {"187b0", "187de"}

# Measured: a ground pound sends Togeba 5 blocks up, and it's walkable for
# about two seconds while it floats back down.
TOGEBA_RISE = 5

# Costs, roughly in frames-per-block-ish units.
COST_WALK = 1
COST_FALL = 1
COST_JUMP = 2
COST_LADDER = 2
COST_SWIM = 3
COST_BASH = 4
COST_TRANSITION = 8


def classify(func):
    if func is None:
        return SOLID
    name = func.removeprefix("BlockFunc_")
    if name in ("Free", "188ba", "TreasureDoor") or name in DOORS or name in WALK_INS:
        return FREE
    if name in ("Floor", "SlipperyFloor", "LadderTop") or name in SLOPES or "Cloud" in name:
        return FLOOR
    if name == "Ladder":
        return LADDER
    if "Water" in name or "Current" in name:
        return HAZARD if "Spike" in name else WATER
    if "Spike" in name or name == "Fire":
        return HAZARD
    if name.startswith(("Solid", "SlipperySolid", "SmallGap")) or "Block" in name:
        return SOLID
    if "Pipe" in name:
        return SOLID
    return FREE  # unknown functions: assume passable, the emulator will tell


def level_variant(level, treasures=(), night=False):
    """The variant of `level` (e.g. "THE_STEEP_CANYON") that SelectLevel
    loads with `treasures` collected (treasure constant names): the first of
    variants 4, 3 and 2 whose two required treasures are both held, else 1.
    """
    text = (SRC / "data/levels/treasure_requirements.asm").read_text()
    block = text[text.index(f"; LEVEL_{level}\n"):].split("\n\n")[0]
    held = set(treasures) | {"TREASURE_NONE"}
    variant = 1
    for line in block.splitlines()[1:]:
        m = re.match(r"\s*db (\w+),\s*(\w+) ; variant (\d)", line)
        if m and m.group(1) in held and m.group(2) in held:
            variant = int(m.group(3))
            break
    return f"{level}_{'NIGHT' if night else 'DAY'}_{variant}"


class Graph:
    def __init__(self, level_name, power=0, treasures=()):
        """`level_name` is a variant (THE_STEEP_CANYON_DAY_2) or a level
        (THE_STEEP_CANYON), whose variant then follows `treasures`.
        `power` is Wario's power-up level (wPowerUpLevel): it decides how
        high he jumps and whether he can swim."""
        if not re.search(r"_(DAY|NIGHT)_\d$", level_name):
            level_name = level_variant(level_name, treasures)
        self.level_name = level_name
        self.level = Level(level_name)
        self.jump_height = JUMP_HEIGHT_HIGH_JUMP_BOOTS if power >= HIGH_JUMP_BOOTS else JUMP_HEIGHT
        self.can_swim = power >= SWIMMING_FLIPPERS
        lv = self.level
        self.kind = [[classify(lv.funcs[r][c]) for c in range(LEVEL_WIDTH)] for r in range(LEVEL_HEIGHT)]
        self.name = [
            [(f or "").removeprefix("BlockFunc_") for f in row] for row in lv.funcs
        ]
        # Cells a Togeba can carry Wario's feet in: after a ground pound
        # (Super Jump Slam Overalls) it leaps up and is a platform on its
        # way down.
        self.platforms = set()
        if power >= SUPER_JUMP_SLAM_OVERALLS:
            for r in range(LEVEL_HEIGHT):
                for c in range(LEVEL_WIDTH):
                    if (lv.object_name(r, c) or "").startswith("Togeba"):
                        for k in range(1, TOGEBA_RISE + 1):
                            for dc in (-1, 0, 1):
                                self.platforms.add((r - k, c + dc))

    # Cell predicates

    def k(self, r, c):
        if 0 <= r < LEVEL_HEIGHT and 0 <= c < LEVEL_WIDTH:
            return self.kind[r][c]
        return SOLID

    def open(self, r, c):
        """Wario's body can be in this cell."""
        return self.k(r, c) in (FREE, FLOOR, LADDER, WATER)

    def fits(self, r, c):
        return self.open(r, c) and self.open(r - 1, c)

    def supported(self, r, c):
        below = self.k(r + 1, c)
        return (
            below in (SOLID, FLOOR)
            or self.k(r, c) == LADDER
            or below == LADDER
            or (r + 1, c) in self.platforms
        )

    def in_water(self, r, c):
        return self.k(r, c) == WATER and self.can_swim

    def breakable(self, r, c):
        return "Cracked" in self.name[r][c] if 0 <= r < LEVEL_HEIGHT and 0 <= c < LEVEL_WIDTH else False

    def fall(self, r, c):
        """Where Wario lands falling from (r, c), or None (pit, hazard)."""
        while r < LEVEL_HEIGHT - 1:
            if self.in_water(r, c):
                return (r, c)
            if not self.fits(r, c) or self.k(r, c) == HAZARD:
                return None
            if self.supported(r, c):
                return (r, c)
            r += 1
        return None

    def fall_drifting(self, r, c, dc, steps):
        """Fall from (r, c) moving one column per row, for up to `steps`
        columns, then straight down."""
        for _ in range(steps):
            if self.supported(r, c) or self.in_water(r, c):
                return (r, c)
            if not (self.fits(r + 1, c + dc) and self.fits(r, c + dc)):
                break
            r, c = r + 1, c + dc
        return self.fall(r, c)

    def sector_spawn(self, sx, sy):
        for r in range(sy * 16, sy * 16 + 16):
            for c in range(sx * 16, sx * 16 + 16):
                if self.level.objects[r][c] == 0xF:
                    # Pipe exits put the marker in the floor: Wario rises out.
                    while r > 0 and not self.fits(r, c):
                        r -= 1
                    return self.fall(r, c) or (r, c)
        return None

    def transition(self, r, c):
        """Destination of a transition entered from body cell (r, c)."""
        index = (r // 16) * 10 + c // 16
        if index >= len(self.level.rooms) or self.level.rooms[index] is None:
            return None
        sx, sy = self.level.rooms[index]["dest"]
        return self.sector_spawn(sx, sy)

    # Edges

    def neighbours(self, node):
        r, c = node
        out = []
        standing = self.supported(r, c)
        water = self.in_water(r, c)

        def add(target, cost, move):
            if target is not None and target != node:
                out.append((target, cost, move))

        # Walk / fall sideways, or bash through cracked blocks.
        for dc, move in ((-1, "left"), (1, "right")):
            if water and self.in_water(r, c + dc):
                # Swimming Wario is horizontal: one free block is enough.
                add((r, c + dc), COST_SWIM, f"swim {move}")
            elif standing or water:
                if self.fits(r, c + dc):
                    add(self.fall(r, c + dc), COST_WALK, move)
                    # Walking off a ledge keeps some sideways momentum.
                    if not self.supported(r, c + dc):
                        add(self.fall_drifting(r, c + dc, dc, 2), COST_WALK + 1, f"{move} off ledge")
                elif standing and self.breakable(r, c + dc) and self.open(r - 1, c + dc) or (
                    standing and self.breakable(r, c + dc) and self.breakable(r - 1, c + dc)
                ):
                    add((r, c + dc), COST_BASH, f"bash {move}")

        # Fall (a node in mid air only falls).
        if not standing and not water:
            add(self.fall(r + 1, c), COST_FALL, "fall")

        # Jumps: rise straight up, then move across at the peak, then fall.
        if standing or (water and not self.in_water(r - 1, c)):
            # h = 0 is a flat hop, e.g. under a ceiling too low to jump in:
            # Wario is shorter than his two-block box.
            for h in range(0, self.jump_height + 1):
                top = r - h
                # FLOOR blocks are one-way: they don't stop a jump.
                if not self.fits(top, c):
                    break
                add(self.fall(top, c), COST_JUMP + h, f"jump up {h}")
                for dc_sign, move in ((-1, "left"), (1, "right")):
                    for d in range(1, JUMP_REACH + 1):
                        cc = c + dc_sign * d
                        if not self.fits(top, cc):
                            break
                        add(self.fall(top, cc), COST_JUMP + h + d, f"jump {move} {h}/{d}")
                        # ...or keep drifting sideways on the way down.
                        landing = self.fall_drifting(top, cc, dc_sign, JUMP_REACH - d)
                        add(landing, COST_JUMP + h + d + 1, f"jump {move} {h}/{d}+")

        # Ladders.
        if self.k(r, c) == LADDER or self.k(r - 1, c) == LADDER:
            if self.fits(r - 1, c):
                add((r - 1, c), COST_LADDER, "climb up")
        if self.k(r + 1, c) == LADDER or self.name[r + 1][c] == "LadderTop" if r + 1 < LEVEL_HEIGHT else False:
            add((r + 1, c), COST_LADDER, "climb down")

        # Swimming.
        if water:
            for dr, move in ((-1, "swim up"), (1, "swim down")):
                if self.in_water(r + dr, c):
                    add((r + dr, c), COST_SWIM, move)

        # Transitions: doors (UP while standing), walk-ins (just touch),
        # pipes (UP below an up pipe, DOWN on a down pipe).
        names = (self.name[r][c], self.name[r - 1][c] if r else "")
        if standing and any(n in DOORS for n in names):
            add(self.transition(r, c), COST_TRANSITION, "door")
        for cc in (c - 1, c, c + 1):
            if 0 <= cc < LEVEL_WIDTH and (
                self.name[r][cc] in WALK_INS or (r and self.name[r - 1][cc] in WALK_INS)
            ):
                add(self.transition(r, cc), COST_TRANSITION, "walk-in")
                break
        # Up pipes can be in the ceiling a jump above Wario's head.
        for k in range(2, 2 + self.jump_height + 1):
            if r - k < 0:
                break
            if self.name[r - k][c].startswith("UpPipe"):
                if standing or water or k == 2:
                    add(self.transition(r - k, c), COST_TRANSITION + k, "up pipe")
                break
            if not self.open(r - k, c):
                break
        if r + 1 < LEVEL_HEIGHT and self.name[r + 1][c].startswith("DownPipe"):
            add(self.transition(r + 1, c), COST_TRANSITION, "down pipe")
        return out

    # Search

    def astar(self, start, goal):
        def h(n):
            return abs(n[0] - goal[0]) + abs(n[1] - goal[1])

        frontier = [(h(start), 0, start)]
        came = {start: None}
        cost = {start: 0}
        while frontier:
            _, g, node = heapq.heappop(frontier)
            if node == goal:
                path = []
                while node is not None:
                    path.append(node)
                    node = came[node] and came[node][0]
                path.reverse()
                return path, [came[n][1] for n in path[1:]]
            if g > cost[node]:
                continue
            for nxt, step, move in self.neighbours(node):
                ng = g + step
                if ng < cost.get(nxt, 1 << 30):
                    cost[nxt] = ng
                    came[nxt] = (node, move)
                    heapq.heappush(frontier, (ng + h(nxt), ng, nxt))
        return None, None

    def distance_field(self, goal):
        """Cost to reach `goal` from every node that can (reverse Dijkstra)."""
        reverse = {}
        # Every node any move can reach, starting from every cell Wario can
        # stand or swim in, and the edges into each.
        todo = [
            (r, c)
            for r in range(LEVEL_HEIGHT)
            for c in range(LEVEL_WIDTH)
            if self.fits(r, c) or self.in_water(r, c)
        ]
        seen = set(todo)
        while todo:
            node = todo.pop()
            for nxt, step, _ in self.neighbours(node):
                reverse.setdefault(nxt, []).append((node, step))
                if nxt not in seen:
                    seen.add(nxt)
                    todo.append(nxt)
        dist = {goal: 0}
        frontier = [(0, goal)]
        while frontier:
            d, node = heapq.heappop(frontier)
            if d > dist[node]:
                continue
            for prev, step in reverse.get(node, ()):
                nd = d + step
                if nd < dist.get(prev, 1 << 30):
                    dist[prev] = nd
                    heapq.heappush(frontier, (nd, prev))
        return dist

    def node_for(self, r, c):
        """The node for a body cell, e.g. mid-jump: where Wario would land."""
        if self.fits(r, c) and (self.supported(r, c) or self.in_water(r, c)):
            return (r, c)
        return self.fall(r, c)


def parse_cell(s):
    r, c = s.split(":")
    return int(r), int(c)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("level")
    parser.add_argument("start", type=parse_cell, help="ROW:COL of Wario's lower body")
    parser.add_argument("goal", type=parse_cell)
    parser.add_argument("--power", type=int, default=0, help="wPowerUpLevel, 0-9")
    parser.add_argument(
        "--treasures", nargs="*", default=[],
        help="treasures held (e.g. FOOT_OF_STONE), to pick the level variant",
    )
    args = parser.parse_args()

    graph = Graph(args.level, args.power, args.treasures)
    print(f"variant: {graph.level_name}")
    start = graph.node_for(*args.start) or args.start
    goal = graph.node_for(*args.goal) or args.goal
    path, moves = graph.astar(start, goal)
    if path is None:
        print(f"no path from {start} to {goal}")
        sys.exit(1)
    print(f"{len(path)} nodes from {start} to {goal}")
    last = None
    for node, move in zip(path[1:], moves):
        kind = move.split()[0]
        if kind != last or kind in ("door", "walk-in", "up", "down"):
            print(f"  {move:16} -> {node}")
        last = kind


if __name__ == "__main__":
    main()
