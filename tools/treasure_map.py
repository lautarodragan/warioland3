#!/usr/bin/env python3
"""Draw the treasure map: in which order the game hints the 100 treasures,
and what each one opens.

    python3 tools/treasure_map.py            # rewrite the page's tables and the SVG
    python3 tools/treasure_map.py --check    # exit 1 if they're out of date
    python3 tools/treasure_map.py --dump     # print the extracted data

Everything comes from the disassembly (paths below are under src/):

- order: EventTreasures (engine/overworld/bank20.asm). The Temple hint
  (GetNextTreasureToCollect) walks this table from the last treasure it
  pointed at to the next one not collected yet, so the table's order is the
  game's own intended order. Before the game is cleared it only points up to
  EVENT_GOLD_MUSIC_BOX (GetMapSideAndLevelForNextTreasure).
- treasure -> event: EventTreasures too; an event needs all its treasures
  (CheckIfEventIsUnlocked).
- event -> map: OWSceneParams (bank20.asm): UNLOCK_LEVEL opens a path,
  resolved with UnlockableConnections (data/overworld/unlockable_connections.asm);
  HIGHLIGHT_LEVEL flashes a level that changed; DO_OW_FUNC / SPECIAL_ACTION
  play a map animation. CutsceneInitFunctions (engine/overworld/cutscene/init.asm)
  says which events have a cutscene. The map sides that can be visited
  follow SetNextPrevMapButtonsSelectable.CheckAccessibleMapSides.
- treasure -> level variant: LevelTreasureRequirements
  (data/levels/treasure_requirements.asm), read by SelectLevel; the script
  works out the variant SelectLevel picks for each level after every event.
- where each treasure is: LevelTreasureIDs (data/levels/level_treasures.asm),
  four per level in chest colour order grey, red, green, blue.
- power-ups: the power-up levels in constants/wario_constants.asm, whose
  treasures are the same names with _T (SetTreasureTransitionParam).

What the data does not say: what a chest needs to be reached inside its
level (a power-up, a variant, day or night). That's level layout.

The page's generated parts sit between `<!-- begin: name -->` and
`<!-- end: name -->` comments in book/src/treasure-map.md.
"""

import argparse
import math
import re
import sys
from html import escape
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src"
PAGE = ROOT / "book" / "src" / "treasure-map.md"
SVG = ROOT / "book" / "src" / "images" / "treasure-map.svg"

SIDES = ["NORTH", "WEST", "SOUTH", "EAST"]
SIDE_LETTER = {"NORTH": "N", "WEST": "W", "SOUTH": "S", "EAST": "E"}
COLOURS = ["grey", "red", "green", "blue"]

# Plain words for the events that do something on the map. The effects
# (which paths open, which levels change) come from the data; these are
# only the captions.
EVENT_WORDS = {
    "EVENT_CUT_TREE": "cuts down the tree",
    "EVENT_OPEN_NORTH_GATE": "opens the north gate",
    "EVENT_EXPEL_TORNADO": "drives the tornado away",
    "EVENT_RAINSTORM": "brings a rainstorm",
    "EVENT_FIX_ELEVATOR": "fixes the elevator",
    "EVENT_PLANT_SEEDS": "plants the magic seeds",
    "EVENT_RAISE_TOWER": "raises the tower",
    "EVENT_BLOW_MIST": "blows the mist away",
    "EVENT_SUMMON_SNAKES": "summons the snakes",
    "EVENT_FREEZE_SEA": "freezes the sea",
    "EVENT_SUMMON_LIGHTNING": "summons lightning",
    "EVENT_FOOT_STONE": "an earthquake",
    "EVENT_VOLCANO_ERUPTION": "the volcano erupts",
    "EVENT_OPEN_BLUE_SNAKE_DOOR": "opens the blue snake door",
    "EVENT_PURIFY_WATER": "purifies the water",
    "EVENT_REVEAL_CASTLE": "makes the castle appear",
    "EVENT_SUMMON_SUN": "brings daytime to the east side",
    "EVENT_EXPLODE_BOMBS": "sets off the explosives",
    "EVENT_LEAVES_FALL": "makes the leaves fall",
    "EVENT_MAKE_WIRE": "makes a wire",
    "EVENT_TREASURE_MAP": "reads the treasure map",
    "EVENT_OPEN_TREE_MOUTH": "opens the tree's mouth",
    "EVENT_PLACE_CART_WHEELS": "puts the wheels on the cart",
    "EVENT_RAISE_ICE_BLOCKS": "raises the ice blocks",
    "EVENT_TORCH_FOREST": "burns the vines",
    "EVENT_REVEAL_WARPED_VOID": "reveals the Warped Void",
    "EVENT_RAISE_PIPE": "raises a pipe",
    "EVENT_REMOVE_WARPS": "removes the warps",
    "EVENT_OPEN_PARAGOOM_CAGE": "opens the Paragoom cage",
    "EVENT_PLACE_PROPELLER": "fits the propeller",
    "EVENT_FEED_OCTOHON": "feeds the Octohon",
    "EVENT_OPEN_GOLDEN_SNAKE_DOOR": "opens the golden snake door",
    "EVENT_OPEN_SKY_DOOR": "opens the door to the sky",
    "EVENT_EXTINGUISH_FIRE": "puts out the fire",
    "EVENT_PLACE_BRICK": "puts the brick back",
    "EVENT_SPRAY_IRON_WALL": "rusts the iron wall",
    "EVENT_MIX_CHEMICALS": "mixes the chemicals",
    "EVENT_CUT_BALOON": "cuts the balloon loose",
    "EVENT_DRILL_HOLES": "drills holes",
    "EVENT_REVEAL_DARK_ROOM": "lights up the dark room",
    "EVENT_SUMMON_MOON": "brings the full moon",
    "EVENT_OPEN_CRATER_HOLE": "opens the crater hole",
}

TREASURE_WORDS = {
    "PRINCE_FROGS_GLOVES": "Prince Frog's Gloves",
    "DEMONS_BLOOD": "Demon's Blood",
    "TOP_HALF_OF_SCROLL": "Top Half of Scroll",
    "BOTTOM_HALF_OF_SCROLL": "Bottom Half of Scroll",
    "EYE_OF_THE_STORM": "Eye of the Storm",
    "FOOT_OF_STONE": "Foot of Stone",
    "DAY_OR_NIGHT_SPELL": "Day or Night Spell",
    "SUPER_JUMP_SLAM_OVERALLS": "Super Jump Slam Overalls",
    "UFO": "UFO",
}

LEVEL_WORDS = {"THE_VOLCANOS_BASE": "The Volcano's Base"}

SMALL = {"of", "the", "in", "a", "or", "to"}


def title(words):
    out = []
    for i, w in enumerate(words.lower().split("_")):
        out.append(w if i and w in SMALL else w.capitalize())
    return " ".join(out)


def read(path):
    return (SRC / path).read_text()


def strip(line):
    return line.split(";")[0].strip()


def block(text, label):
    """Lines after `label` up to the next label at the same level."""
    m = re.search(rf"^{re.escape(label)}:{{0,2}}[ \t]*(;.*)?$", text, re.M)
    if not m:
        raise SystemExit(f"label {label} not found")
    out = []
    for line in text[m.end():].splitlines()[1:]:
        if re.match(r"^\w+:", line) or (label.startswith(".") and re.match(r"^\.\w+:?\s*$", line)):
            break
        out.append(line)
    return out


def const_values(text, stop=None):
    """name -> value for every `const` in text (up to `stop`), following const_def."""
    out, value = {}, 0
    for line in text.splitlines():
        if stop and stop in line:
            break
        line = strip(line)
        m = re.match(r"const_def\b\s*(\S+)?", line)
        if m:
            value = int(m.group(1).replace("$", "0x"), 0) if m.group(1) else 0
            continue
        m = re.match(r"const (\w+)$", line)
        if m:
            out[m.group(1)] = value
            value += 1
    return out


class Data:
    def __init__(self):
        tc = const_values(read("constants/treasure_constants.asm"), stop="NUM_TREASURES")
        self.treasures = [n for n, v in sorted(tc.items(), key=lambda x: x[1]) if v >= 1]
        assert len(self.treasures) == 100, len(self.treasures)

        ec = const_values(read("constants/event_constants.asm"), stop="NUM_EVENTS")
        self.events = [n for n, _ in sorted(ec.items(), key=lambda x: x[1])]

        oc = const_values(read("constants/overworld_constants.asm"))
        self.oc = oc
        # map level index -> level constant, per side
        self.ow = {}
        for side in SIDES:
            prefix = f"OW{side}_"
            self.ow[side] = {v: n[len(prefix):] for n, v in oc.items() if n.startswith(prefix)}

        # levels and codes: N1..N6 (index 0 on the north side is the Temple),
        # W1..W6, S1..S6, E1..E7
        self.level_side, self.level_code, self.level_index = {}, {}, {}
        for side in SIDES:
            for i, name in sorted(self.ow[side].items()):
                if name == "JUNCTION":
                    continue
                n = i if side == "NORTH" else i + 1
                self.level_side[name] = side
                self.level_index[name] = i
                self.level_code[name] = "T" if name == "THE_TEMPLE" else f"{SIDE_LETTER[side]}{n}"

        # power-ups: constants/wario_constants.asm
        wc = const_values(read("constants/wario_constants.asm"), stop="NUM_MAIN_POWER_UPS")
        self.power = {f"{n}_T": v for n, v in wc.items() if v > 0}

        # LevelTreasureIDs: level -> four treasures, grey/red/green/blue
        lt = read("data/levels/level_treasures.asm")
        self.level_treasures = {}
        for name, body in re.findall(r"; LEVEL_(\w+)\n((?:\tdb \w+ ; \w+\n)+)", lt):
            self.level_treasures[name] = re.findall(r"db (\w+) ;", body)
        self.where = {}
        for level, ts in self.level_treasures.items():
            for colour, t in zip(COLOURS, ts):
                if t != "TREASURE_DUMMY":
                    self.where[t] = (level, colour)
        assert len(self.where) == 100

        # LevelTreasureRequirements: level -> {variant: (t1, t2)}
        tr = read("data/levels/treasure_requirements.asm")
        self.variants = {}
        for name, body in re.findall(r"; LEVEL_(\w+)\n((?:\tdb .*\n)+)", tr):
            for a, b, v in re.findall(r"db (\w+),\s*(\w+) ; variant (\d)", body):
                if a != "TREASURE_NONE" or b != "TREASURE_NONE":
                    self.variants.setdefault(name, {})[int(v)] = tuple(t for t in (a, b) if t != "TREASURE_NONE")

        bank20 = read("engine/overworld/bank20.asm")
        # EventTreasures
        rows = [strip(l).split()[1] for l in block(bank20, "EventTreasures") if strip(l).startswith("db ")]
        assert rows[-1] == "TREASURES_END"
        self.event_treasures = {
            ev: [t for t in rows[3 * i:3 * i + 3] if t not in ("INVALID_TREASURE", "TREASURE_NONE")]
            for i, ev in enumerate(self.events)
        }
        # the hint's cut-off before the game is cleared
        f = "\n".join(block(bank20, "GetMapSideAndLevelForNextTreasure"))
        self.hint_last = re.search(r"ld a, (EVENT_\w+)\n\tcp c", f).group(1)
        # accessible map sides
        f = "\n".join(block(bank20, "SetNextPrevMapButtonsSelectable"))
        self.side_events = [(side.upper(), ev) for side, ev in
                           re.findall(r"check (\w+) side accessible\n\tld a, (EVENT_\w+)", f)]

        # OWSceneParams
        conns = {}
        uc = read("data/overworld/unlockable_connections.asm")
        for side in SIDES:
            lines = block(uc, "." + side.capitalize())
            pairs = [re.findall(r"\w+", strip(l)[3:]) for l in lines if strip(l).startswith("db ")]
            conns[side] = pairs  # index 0 is the $ff, $ff filler
        self.conns = conns
        # OWLevelPaths (data/overworld/paths.asm): each map level's
        # neighbours, to route a connection through the north junction
        paths = read("data/overworld/paths.asm")
        self.neighbours = {}
        for side in SIDES:
            body = "\n".join(block(paths, "." + side.capitalize()))
            for name, row in re.findall(r"; OW\w+?_(\w+)\n\tdb ([^\n]+)", body):
                if row.startswith("PATH"):
                    continue
                self.neighbours[(side, name)] = {
                    t.split("_", 1)[1] for t in re.findall(r"OW(?:NORTH|WEST|SOUTH|EAST)_\w+", row)
                }
        labels = re.findall(r"dw (\.event_\w+)\s+; (EVENT_\w+)", "\n".join(block(bank20, "OWSceneParams")))
        self.scenes = {}
        for label, ev in labels:
            acts = []
            for l in block(bank20, label):
                l = strip(l)
                m = re.match(r"ow_unlock_level\s+(\w+),\s*(\S+)", l)
                if m:
                    side = m.group(1)
                    i = int(m.group(2)[1:], 16) if m.group(2).startswith("$") else int(m.group(2).split("_")[-1])
                    a, b = conns[side][i]
                    acts.append(("unlock", side, a, b, m.group(2)))
                m = re.match(r"ow_highlight_level\s+(\w+),\s*(\w+)", l)
                if m:
                    side = m.group(1)
                    acts.append(("highlight", side, self.ow[side][oc[m.group(2)]]))
                m = re.match(r"ow_func\s+(\w+),\s*(\w+)", l)
                if m:
                    acts.append(("func", m.group(1), m.group(2)))
                m = re.match(r"db SPECIAL_ACTION,\s*(\w+),\s*(\S+)", l)
                if m:
                    acts.append(("special", m.group(1), m.group(2)))
            self.scenes[ev] = acts

        ci = read("engine/overworld/cutscene/init.asm")
        self.cutscene = {
            ev: func != "NoInitCutscene"
            for func, ev in re.findall(r"dw (\w+)\s*; (EVENT_\w+)", "\n".join(block(ci, "CutsceneInitFunctions")))
        }

        self.order = [t for ev in self.events for t in self.event_treasures[ev]]
        assert sorted(self.order) == sorted(self.treasures), "EventTreasures doesn't list each treasure once"

    # names

    def level_name(self, level):
        return LEVEL_WORDS.get(level) or title(level)

    def treasure_name(self, t):
        base = t[:-2] if t.endswith("_T") else t
        if base.startswith("CRAYON_"):
            return f"{title(base[7:])} Crayon"
        return TREASURE_WORDS.get(base) or title(base)

    def code(self, level):
        return self.level_code[level]

    def label(self, level):
        return f"{self.code(level)} {self.level_name(level)}"


def endpoint(d, side, name):
    """A connection end as a graph node."""
    if name == "OW_EXIT_RIGHT":
        return ("exit", side, SIDES[(SIDES.index(side) + 1) % 4])
    if name == "OW_EXIT_LEFT":
        return ("exit", SIDES[(SIDES.index(side) - 1) % 4], side)
    level = d.ow[side][d.oc[name]]
    return ("junction", side) if level == "JUNCTION" else ("level", level)


def connection_edges(d, side, a, b):
    """An unlocked connection as graph edges. OWLevelPaths has no direct path
    between Out of the Woods and The Peaceful Village: both go through the
    junction, which NORTHCONN_3 then links to The Vast Plain."""
    ea, eb = endpoint(d, side, a), endpoint(d, side, b)
    if ea[0] == eb[0] == "level":
        na = d.neighbours.get((side, ea[1]), set())
        if eb[1] not in na:
            for j in na:
                if j == "JUNCTION" and eb[1] in d.neighbours.get((side, j), set()):
                    return [(ea, ("junction", side)), (("junction", side), eb)]
    return [(ea, eb)]


def reachable(d, edges):
    start = ("level", "THE_TEMPLE")
    seen, todo = {start}, [start]
    while todo:
        n = todo.pop()
        for a, b in edges:
            for x, y in ((a, b), (b, a)):
                if x == n and y not in seen:
                    seen.add(y)
                    todo.append(y)
    return {n[1] for n in seen if n[0] == "level"}


def side_order(d, levels):
    return sorted(levels, key=lambda l: (SIDES.index(d.level_side[l]), d.level_index[l]))


def select_variant(d, level, held):
    """SelectLevel: the first of variants 4, 3 and 2 whose treasures are all held, else 1."""
    for v in (4, 3, 2):
        need = d.variants.get(level, {}).get(v)
        if need and set(need) <= held:
            return v
    return 1


def analyse(d):
    """Walk EventTreasures in order, collecting each event's treasures, and
    record what each event does to the map. Returns the steps (one per
    event with treasures, plus the prologue) and a list of problems: a
    treasure hinted before its level can be reached, power-ups out of
    order. Also sets d.skipped_variants: the variants SelectLevel never
    picks in this order."""
    held, edges = set(), []
    is_open = reachable(d, edges)
    selected = {level: 1 for level in d.variants}
    seen_variants = {level: {1} for level in d.variants}
    steps, problems = [], []
    for ev in d.events:
        ts = d.event_treasures[ev]
        if not ts and ev != "EVENT_PROLOGUE":
            continue
        for t in ts:
            level = d.where[t][0]
            if level not in is_open:
                problems.append(f"{t} is hinted before its level {d.label(level)} can be reached")
        held |= set(ts)
        paths, highlights, funcs = [], [], []
        for act in d.scenes[ev]:
            if act[0] == "unlock":
                _, side, a, b, raw = act
                edges.extend(connection_edges(d, side, a, b))
                paths.append((side, a, b, raw))
            elif act[0] == "highlight":
                highlights.append(act[2])
            else:
                funcs.append(act)
        now_open = reachable(d, edges)
        new_levels = side_order(d, now_open - is_open)
        is_open = now_open
        # the variant SelectLevel now picks for each level; a level opened
        # by this same event starts in it, nothing changes there
        variants = []
        for level in d.variants:
            v = select_variant(d, level, held)
            if v != selected[level]:
                variants.append((level, v))
                selected[level] = v
            seen_variants[level].add(v)
        # plus the levels the map flashes: all are variant changes but the
        # Truck Wheel's, which works through the cart object instead
        # (CartVariableFunc checks the treasure itself)
        changed = side_order(d, ({l for l, _ in variants} | set(highlights)) - set(new_levels) - {"THE_TEMPLE"})
        steps.append(dict(
            event=ev, treasures=ts, new_levels=new_levels, paths=paths, highlights=highlights,
            funcs=funcs, variants=variants, changed=changed,
            cutscene=d.cutscene.get(ev, False),
            main=d.events.index(ev) <= d.events.index(d.hint_last),
            side=next((side for side, e in d.side_events if e == ev), None),
        ))
    # variants SelectLevel never picks when the treasures come in this order
    d.skipped_variants = {
        level: sorted(set(vs) - seen_variants[level]) for level, vs in d.variants.items() if set(vs) - seen_variants[level]
    }
    powers = [d.power[t] for t in d.order if t in d.power]
    if powers != sorted(powers):
        problems.append(f"the hint gives the power-ups out of order: {powers}")
    return steps, problems


def stages(d, steps):
    """The hinted steps split into stages, each ending with the event that
    makes the next map side reachable (CheckAccessibleMapSides), then the
    steps after the Gold Music Box."""
    out, cur, reached = [], [], "north"
    for s in steps:
        if s["main"] and s["event"] != "EVENT_PROLOGUE":
            cur.append(s)
            if s["side"]:
                out.append((f"Stage {len(out) + 1}: {reached} side, until the {s['side'].lower()} side opens", cur))
                reached, cur = s["side"].lower(), []
    out.append((f"Stage {len(out) + 1}: all four sides, up to the Gold Music Box", cur))
    out.append(("After the Gold Music Box: the rest, hinted once the game is cleared",
                [s for s in steps if not s["main"]]))
    return out


def effects(d, s):
    """What an event does, as (kind, text) pieces."""
    out = []
    ev = s["event"]
    if ev in EVENT_WORDS:
        out.append(("action", EVENT_WORDS[ev]))
    if s["new_levels"]:
        text = "opens " + ", ".join(d.code(l) for l in s["new_levels"])
        out.append(("opens", text))
    if s["side"] == "NORTH":
        out.append(("side", "on to the north side"))
    elif s["side"]:
        out.append(("side", f"{s['side'].lower()} side"))
    if "THE_TEMPLE" in s["highlights"]:
        out.append(("opens", "lights up the Temple"))
    if s["changed"]:
        out.append(("changes", "changes " + ", ".join(d.code(l) for l in s["changed"])))
    if ev == "EVENT_DAY_OR_NIGHT_SPELL":
        out.append(("note", "day/night button on the map"))
    return out


def effect_text(d, s, long=False):
    parts = []
    for kind, text in effects(d, s):
        if long and kind == "opens" and s["new_levels"] and text.startswith("opens "):
            text = "opens " + ", ".join(d.label(l) for l in s["new_levels"])
        if kind == "side":
            text = f"({text})" if text.startswith("on to") else f"({text} reachable)"
        parts.append(text)
    out = ", ".join(parts).replace(", (", " (") or "opens nothing"
    if s["cutscene"]:
        out += "; cutscene"
    return out


def tag(d, t):
    if t in d.power:
        return f"power-up {d.power[t]}"
    if t.endswith("_MUSIC_BOX"):
        return "music box"
    return ""


# ---------------------------------------------------------------- markdown

def numbering(steps):
    pos, n = {}, 0
    for s in steps:
        for t in s["treasures"]:
            n += 1
            pos[t] = n
    return pos


def md_treasure(d, t):
    level, colour = d.where[t]
    name = d.treasure_name(t)
    if tag(d, t):
        return f"**{name}** ({d.code(level)} {colour}, {tag(d, t)})"
    return f"{name} ({d.code(level)} {colour})"


def md_sequence(d, steps, which):
    pos = numbering(steps)
    out = []
    for title_, ss in stages(d, steps):
        if (which == "after") != title_.startswith("After"):
            continue
        if which == "main":
            out.append(f"### {title_}\n")
        out.append("| # | Treasure (level, chest) | Then |")
        out.append("|---|---|---|")
        for s in ss:
            ts = s["treasures"]
            nums = str(pos[ts[0]]) if len(ts) == 1 else f"{pos[ts[0]]}-{pos[ts[-1]]}"
            out.append(f"| {nums} | {' + '.join(md_treasure(d, t) for t in ts)} | {effect_text(d, s, long=True)} |")
        out.append("")
    return "\n".join(out)


def md_levels(d, steps):
    """Per level: who opens it, its four chests with their place in the
    order, and which treasures switch its variants."""
    pos = numbering(steps)
    opened_by = {l: s for s in steps for l in s["new_levels"]}
    out = [
        "| Level | Opened by | Grey | Red | Green | Blue | Variant 2 / 3 / 4 needs |",
        "|---|---|---|---|---|---|---|",
    ]
    for side in SIDES:
        for _, level in sorted(d.ow[side].items()):
            if level in ("JUNCTION", "THE_TEMPLE"):
                continue
            s = opened_by[level]
            by = "the start" if s["event"] == "EVENT_PROLOGUE" else " + ".join(
                f"{d.treasure_name(t)} ({pos[t]})" for t in s["treasures"])
            cells = []
            for t in d.level_treasures[level]:
                cells.append(f"{pos[t]} {d.treasure_name(t)}" + (f" ({tag(d, t)})" if tag(d, t) else ""))
            vs = d.variants.get(level, {})
            variants = " / ".join(" + ".join(d.treasure_name(t) for t in vs[v]) if v in vs else "-" for v in (2, 3, 4))
            skipped = d.skipped_variants.get(level)
            if skipped:
                variants += f" (variant {', '.join(map(str, skipped))} never picked in this order)"
            out.append(f"| {d.label(level)} | {by} | " + " | ".join(cells) + f" | {variants} |")
    return "\n".join(out) + "\n"


# ---------------------------------------------------------------- SVG

CHEST = {"grey": "#a3acb6", "red": "#f0645c", "green": "#4cc55f", "blue": "#5b9cf2"}
INK = {
    "bg": "#16191e", "band": "#2b313a", "title": "#f2f5f8", "text": "#e3e8ee", "dim": "#98a2ad",
    "chip_text": "#0d1117", "gold": "#ffd34d", "opens": "#7ee2b8", "changes": "#d9b3ff", "note": "#98a2ad",
}
FONT = 13
CHAR_W = 7.9  # rough width of a character at FONT px in Verdana / DejaVu Sans
BOLD = 1.1


def text_w(s, size=FONT):
    return len(s) * CHAR_W * size / FONT


def svg(d, steps):
    """A vertical timeline, one row per event in hint order, grouped by
    stage: the treasures it needs (a chip in the chest's colour with the
    level code), then what it opens. On a dark panel of its own, so it
    reads the same in every mdBook theme."""
    pos = numbering(steps)
    ROW, BAND = 28, 30
    x_num, x_chips = 16, 66

    def chips(s):
        out, x = [], x_chips
        for k, t in enumerate(s["treasures"]):
            if k:
                out.append(("plus", x + 1))
                x += 16
            name = d.treasure_name(t)
            out.append(("chip", x, t, name))
            x += 40 + (text_w(name) * BOLD + 22 if tag(d, t) else text_w(name) + 8)
        return out, x

    layout = []
    for title_, ss in stages(d, steps):
        shown = ss
        hidden = []
        if title_.startswith("After"):
            shown = [s for s in ss if effects(d, s)]
            hidden = [s for s in ss if not effects(d, s)]
        layout.append(("band", title_))
        for s in shown:
            layout.append(("row", s))
        if hidden:
            n = sum(len(s["treasures"]) for s in hidden)
            layout.append(("note", f"and {n} more that open nothing: crayons, gems, crests and other collectibles "
                                   f"(numbers {', '.join(str(pos[s['treasures'][0]]) for s in hidden[:3])}...)"))
        layout.append(("gap", None))

    x_effect = max(chips(s)[1] for kind, s in layout if kind == "row") + 26
    W = int(max(x_effect + text_w(effect_svg_text(d, s)) for kind, s in layout if kind == "row") + 24)
    W = max(W, 900)

    o = []
    y = 124
    body = []
    for kind, item in layout:
        if kind == "band":
            y += 8
            body.append(f'<rect x="8" y="{y - 19}" width="{W - 16}" height="26" rx="5" fill="{INK["band"]}"/>')
            body.append(f'<text x="16" y="{y}" font-weight="bold" fill="{INK["title"]}">{escape(item)}</text>')
            y += BAND
        elif kind == "note":
            body.append(f'<text x="{x_chips}" y="{y}" fill="{INK["dim"]}" font-style="italic">{escape(item)}</text>')
            y += ROW
        elif kind == "gap":
            y += 4
        else:
            s = item
            ts = s["treasures"]
            nums = str(pos[ts[0]]) if len(ts) == 1 else f"{pos[ts[0]]}-{pos[ts[-1]]}"
            body.append(f'<text x="{x_num}" y="{y}" fill="{INK["dim"]}">{nums}</text>')
            for c in chips(s)[0]:
                if c[0] == "plus":
                    body.append(f'<text x="{c[1]}" y="{y}" fill="{INK["dim"]}">+</text>')
                    continue
                _, x, t, name = c
                level, colour = d.where[t]
                body.append(f'<rect x="{x:.0f}" y="{y - 15}" width="34" height="20" rx="4" fill="{CHEST[colour]}"/>')
                body.append(f'<text x="{x + 17:.0f}" y="{y}" text-anchor="middle" font-weight="bold" '
                            f'fill="{INK["chip_text"]}">{d.code(level)}</text>')
                special = t in d.power or t.endswith("_MUSIC_BOX")
                fill = INK["gold"] if special else INK["text"]
                weight = ' font-weight="bold"' if special else ""
                body.append(f'<text x="{x + 40:.0f}" y="{y}" fill="{fill}"{weight}>{escape(name)}</text>')
                if special:
                    body.append(icon(t in d.power, x + 40 + text_w(name) * BOLD + 9, y - 5))
            body.append(f'<text x="{x_effect - 20}" y="{y}" fill="{INK["dim"]}">→</text>')
            body.append(f'<text x="{x_effect}" y="{y}">{effect_svg_spans(d, s)}</text>')
            y += ROW
    H = y + 6

    o.append(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}" '
             f'font-family="Verdana, DejaVu Sans, Arial, sans-serif" font-size="{FONT}">')
    o.append("<title>Wario Land 3 treasure map: the treasures in the order the Temple hint asks for them, "
             "and what each one opens</title>")
    o.append(f'<rect width="{W}" height="{H}" rx="10" fill="{INK["bg"]}"/>')
    o.append(f'<text x="16" y="30" font-size="18" font-weight="bold" fill="{INK["title"]}">'
             'Wario Land 3: the treasure map</text>')
    o.append(f'<text x="16" y="52" fill="{INK["dim"]}">The 100 treasures in the order the Temple hint asks for '
             'them (EventTreasures), and what each opens. Generated by tools/treasure_map.py.</text>')
    x = 16
    legend = []
    for c in COLOURS:
        legend.append(f'<rect x="{x}" y="64" width="34" height="20" rx="4" fill="{CHEST[c]}"/>')
        legend.append(f'<text x="{x + 17}" y="79" text-anchor="middle" font-weight="bold" '
                      f'fill="{INK["chip_text"]}">N1</text>')
        legend.append(f'<text x="{x + 40}" y="79" fill="{INK["text"]}">{c}</text>')
        x += 40 + text_w(c) + 16
    legend.append(f'<text x="{x:.0f}" y="79" fill="{INK["dim"]}">= the chest\'s colour + the level it is in</text>')
    x, ly = 16, 103
    for fill, weight, words in (
        (INK["gold"], ' font-weight="bold"', "power-up"),
        (INK["gold"], ' font-weight="bold"', "music box"),
        (INK["opens"], ' font-weight="bold"', "opens: new level"),
        (INK["changes"], "", "changes: new variant"),
        (INK["dim"], "", "▶ cutscene"),
    ):
        if words in ("power-up", "music box"):
            legend.append(icon(words == "power-up", x + 6, ly - 5))
            x += 16
        legend.append(f'<text x="{x:.0f}" y="{ly}" fill="{fill}"{weight}>{escape(words)}</text>')
        x += text_w(words) + 24
    o.extend(legend)
    o.extend(body)
    o.append("</svg>")
    return "\n".join(o) + "\n"


def icon(power, cx, cy):
    """A star for a power-up, a quaver for a music box: drawn, so they don't
    depend on the reader's fonts."""
    if power:
        pts = []
        for k in range(10):
            r = 6.5 if k % 2 == 0 else 2.8
            a = math.pi / 2 + k * math.pi / 5
            pts.append(f"{cx + r * math.cos(a):.1f},{cy - r * math.sin(a):.1f}")
        return f'<polygon points="{" ".join(pts)}" fill="{INK["gold"]}"/>'
    return (f'<g fill="{INK["gold"]}" stroke="{INK["gold"]}"><ellipse cx="{cx - 2:.1f}" cy="{cy + 4:.1f}" rx="3.6" ry="2.7" '
            f'transform="rotate(-20 {cx - 2:.1f} {cy + 4:.1f})"/><line x1="{cx + 1.3:.1f}" y1="{cy + 3.5:.1f}" '
            f'x2="{cx + 1.3:.1f}" y2="{cy - 7:.1f}" stroke-width="1.4"/><path d="M{cx + 1.3:.1f},{cy - 7:.1f} '
            f'q4,2 4,6" fill="none" stroke-width="1.4"/></g>')


def effect_pieces(d, s):
    pieces = []
    for kind, text in effects(d, s):
        if kind == "side":
            text = f"({text})"
        pieces.append((kind, text))
    if s["cutscene"]:
        pieces.append(("cutscene", "▶"))
    if not pieces:
        pieces.append(("none", "opens nothing"))
    return pieces


def effect_svg_text(d, s):
    return "  ".join(t for _, t in effect_pieces(d, s))


def effect_svg_spans(d, s):
    style = {
        "action": (INK["text"], ""), "opens": (INK["opens"], ' font-weight="bold"'),
        "side": (INK["opens"], ""), "changes": (INK["changes"], ""), "note": (INK["note"], ' font-style="italic"'),
        "cutscene": (INK["dim"], ""), "none": (INK["dim"], ' font-style="italic"'),
    }
    out = []
    for k, (kind, text) in enumerate(effect_pieces(d, s)):
        fill, extra = style[kind]
        lead = "" if k == 0 else ("  " if kind != "side" else " ")
        out.append(f'<tspan fill="{fill}"{extra} xml:space="preserve">{escape(lead + text)}</tspan>')
    return "".join(out)


# ---------------------------------------------------------------- page

def replace_block(text, name, body):
    pat = re.compile(rf"(<!-- begin: {name} -->\n).*?(<!-- end: {name} -->)", re.S)
    if not pat.search(text):
        raise SystemExit(f"{PAGE.relative_to(ROOT)}: no <!-- begin: {name} --> ... <!-- end: {name} --> block")
    return pat.sub(lambda m: m.group(1) + body + m.group(2), text)


def dump(d, steps, problems):
    pos = numbering(steps)
    for s in steps:
        ts = " + ".join(f"{pos[t]} {d.treasure_name(t)} [{d.code(d.where[t][0])} {d.where[t][1]}]" for t in s["treasures"])
        print("*" if s["main"] else " ", s["event"], ts, "->", effect_text(d, s, long=True),
              "| highlights:", " ".join(d.code(l) for l in s["highlights"]),
              "| map functions:", " ".join(f[2] for f in s["funcs"]))
    for p in problems:
        print("PROBLEM:", p)


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--check", action="store_true", help="only check that the page and the SVG are up to date")
    parser.add_argument("--dump", action="store_true", help="print the extracted data")
    args = parser.parse_args()

    d = Data()
    steps, problems = analyse(d)
    if args.dump:
        dump(d, steps, problems)
        return 1 if problems else 0
    for p in problems:
        print("problem:", p)
    page = PAGE.read_text()
    new_page = replace_block(page, "sequence", md_sequence(d, steps, "main"))
    new_page = replace_block(new_page, "after", md_sequence(d, steps, "after"))
    new_page = replace_block(new_page, "levels", md_levels(d, steps))
    new_svg = svg(d, steps)
    if args.check:
        stale = [p for p, new in ((PAGE, new_page), (SVG, new_svg)) if not p.exists() or p.read_text() != new]
        for p in stale:
            print(f"{p.relative_to(ROOT)} is out of date: run python3 tools/treasure_map.py")
        return 1 if stale or problems else 0
    PAGE.write_text(new_page)
    SVG.write_text(new_svg)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
