"""Find inputs that move Wario to a block, through a door, or onto a flag.

Beam search over short input "macros" (jumps, walks, bashes, climbs, door
entries) from a starting point, keeping the runs that end closest to the
target block. Runs where Wario gets stung are dropped, since enemy hits
throw him around. The result is a list of (buttons, frames) steps for
Game.play; routes in tests/routes/ were built by chaining searches like:

    python3 tests/tools/route_search.py --prefix so_far.json \\
        --target 10 152 --flag 0x01 > next.json

Starts from a new game entering Out of the Woods; --level loads another
level instead (see Game.enter_level). Block coordinates are (row, col) in
16x16 px blocks; sectors are 16x16 blocks, numbered row * 10 + col, which
is how level room tables index doors.
"""

import argparse
import io
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from game import OUT_OF_THE_WOODS_DAY_1, ST_LEVEL, SST_LEVEL_UPDATE, Game  # noqa: E402

MACROS = [
    [("a", 35), ("", 15)],
    [("right+a", 35), ("", 15)],
    [("left+a", 35), ("", 15)],
    [("a", 12), ("", 20)],
    [("right+a", 12), ("", 20)],
    [("left+a", 12), ("", 20)],
    [("right", 20)],
    [("left", 20)],
    [("right", 8), ("", 10)],
    [("left", 8), ("", 10)],
    [("right+b", 12), ("", 10)],
    [("left+b", 12), ("", 10)],
    # Swimming (this ROM auto-swims while B is held).
    [("right+b", 60)],
    [("right+b", 120)],
    [("left+b", 60)],
    [("up+b", 60)],
    [("down+b", 60)],
    [("down", 30)],
    [("up", 30)],
    [("up", 90)],
    [("left+up", 30)],
    [("right+up", 30)],
    # Waiting, e.g. for an enemy to move out of the way.
    [("", 30)],
    [("", 90)],
    # Doors only open for an idle Wario.
    [("", 30), ("up", 6), ("", 150)],
    [("", 60), ("up", 6), ("", 150)],
]

WST_STUNG = 0x15
WST_STUNG_RECOVERY = 0x16


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--prefix", help="JSON steps to play before searching")
    parser.add_argument("--level", type=lambda s: int(s, 0), default=OUT_OF_THE_WOODS_DAY_1)
    parser.add_argument("--target", type=int, nargs=2, required=True, metavar=("ROW", "COL"))
    goal = parser.add_mutually_exclusive_group()
    goal.add_argument("--flag", type=lambda s: int(s, 0), help="stop once wKeyAndTreasureFlags & FLAG")
    goal.add_argument("--sector", type=int, help="stop once Wario is playable in this sector")
    goal.add_argument("--ram", metavar="SYMBOL=VALUE", help="stop once a RAM symbol holds VALUE")
    parser.add_argument(
        "--keep", metavar="SYMBOL=VALUE", action="append", default=[],
        help="drop runs where a RAM symbol stops holding VALUE (repeatable)",
    )
    parser.add_argument(
        "--plan", metavar="LEVEL_NAME",
        help="score runs by path-finding cost to the target over this level's "
        "block graph (tools/pathfind.py) instead of straight-line distance",
    )
    parser.add_argument("--depth", type=int, default=40)
    parser.add_argument("--beam", type=int, default=24)
    args = parser.parse_args()

    game = Game()
    game.new_game_to_overworld()
    game.enter_level(args.level)
    if args.prefix:
        game.play(json.load(open(args.prefix)))

    target_y = args.target[0] * 16 + 8
    target_x = args.target[1] * 16 + 8

    def position():
        mem, addr = game.pb.memory, game.addr
        y = mem[addr("wWarioYPos")] << 8 | mem[addr("wWarioYPos") + 1]
        x = mem[addr("wWarioXPos")] << 8 | mem[addr("wWarioXPos") + 1]
        return y, x

    field = graph = None
    if args.plan:
        from pathfind import Graph

        graph = Graph(args.plan)
        goal = graph.node_for(*args.target) or tuple(args.target)
        field = graph.distance_field(goal)
        print(f"planning to {goal}: {len(field)} nodes can reach it", file=sys.stderr)

    def distance():
        y, x = position()
        straight = abs(y - target_y) * 1.5 + abs(x - target_x)
        if field is None:
            return straight
        node = graph.node_for((y - 1) // 16, x // 16)
        cost = field.get(node)
        if cost is None:
            return 1 << 20  # somewhere the plan says the target can't be reached from
        # Path cost decides; straight-line distance only breaks ties.
        return cost * 16 + straight * 0.1

    def reached():
        if args.flag is not None:
            return game.read("wKeyAndTreasureFlags") & args.flag
        if args.ram is not None:
            symbol, value = args.ram.split("=")
            return game.read(symbol) == int(value, 0)
        if args.sector is not None:
            y, x = position()
            return (
                (y // 256) * 10 + x // 256 == args.sector
                and game.state == (ST_LEVEL, SST_LEVEL_UPDATE)
            )
        return distance() < 16

    keep = [(symbol, int(value, 0)) for symbol, value in (k.split("=") for k in args.keep)]

    def invariants_hold():
        return all(game.read(symbol) == value for symbol, value in keep)

    def object_positions():
        mem, out = game.pb.memory, []
        for n in range(1, 9):
            if game.read(f"wObj{n}Flags") & 1:
                bank, addr = game.pb.symbol_lookup(f"wObj{n}XPos")
                out.append((mem[bank, addr + 1] << 8 | mem[bank, addr]) // 16)
        return tuple(out)

    def save():
        f = io.BytesIO()
        game.pb.save_state(f)
        return f.getvalue()

    frontier = [(distance(), [], save())]
    best = frontier[0]
    seen = set()
    for depth in range(args.depth):
        candidates = []
        for _, steps, state in frontier:
            for macro in MACROS:
                game.pb.load_state(io.BytesIO(state))
                game.play(macro)
                if reached():
                    print(f"reached at depth {depth}, position {position()}", file=sys.stderr)
                    json.dump(steps + macro, sys.stdout)
                    return
                y, x = position()
                wario_state = game.read("wWarioState")
                # Enemies are part of the state: waiting for one to move
                # is progress even if Wario stays put.
                key = (y // 4, x // 4, wario_state, object_positions())
                if (
                    key in seen
                    or not invariants_hold()
                    or game.read("wState") != ST_LEVEL
                    or wario_state in (WST_STUNG, WST_STUNG_RECOVERY)
                ):
                    continue
                seen.add(key)
                candidates.append((distance(), steps + macro, save()))
        candidates.sort(key=lambda c: c[0])
        frontier = candidates[: args.beam]
        if not frontier:
            break
        best = min(best, frontier[0], key=lambda c: c[0])
        print(f"depth {depth}: best distance {frontier[0][0]:.0f}", file=sys.stderr)

    print(f"goal not reached; closest distance {best[0]:.0f}", file=sys.stderr)
    json.dump(best[1], sys.stdout)
    sys.exit(1)


if __name__ == "__main__":
    main()
