"""Print a level as ASCII, from the disassembly's level data.

    python3 tests/tools/level_map.py THE_STEEP_CANYON_DAY_1 [--rows 16:48] [--cols 0:160]

Each block is drawn from the block function table of the room its sector
belongs to. Sectors are 16x16 blocks; the level room table is indexed by
sector (row * 10 + col), its entries naming the room a door in that sector
leads to. Objects from the object map are drawn on top (C = chest,
K = key, M = musical coin, other objects as hex digits: their index in the
room's object group, from 4).
"""

import argparse
import re
from pathlib import Path

SRC = Path(__file__).resolve().parents[2] / "src"
LEVEL_WIDTH = 160
LEVEL_HEIGHT = 48

LEGEND = {
    "Solid": "#", "SlipperySolid": "#", "Free": " ", "Floor": "=",
    "SlipperyFloor": "=", "Ladder": "H", "LadderTop": "T", "Door": "D",
    "TreasureDoor": "D", "MinigameDoor": "G", "UnderwaterDoor": "D",
    "Water": "~", "WaterSurface": "~", "NonSubmersibleWater": "~",
    "Fence": "|", "187b0": "W", "187de": "W",
    "LeftSlope": "/", "RightSlope": "\\", "Fire": "^",
    "NonSolidSpike": "^", "SolidSpike": "^", "WaterSpike": "^",
}


def legend_char(func):
    name = func.removeprefix("BlockFunc_")
    if name in LEGEND:
        return LEGEND[name]
    if "Cracked" in name:
        return "%"
    if "Pipe" in name:
        return "P"
    if "Block" in name:
        return "B"
    return "?"


def read(*paths):
    return "".join((SRC / p).read_text() for p in paths)


def labelled_blocks(text, label_re):
    """Map each matching label to the lines below it, until the next label."""
    out, cur = {}, None
    for line in text.splitlines():
        m = re.match(r"^(\.?\w+):?\s*(;.*)?$", line)
        if m and not line.startswith((" ", "\t")):
            cur = m.group(1) if re.fullmatch(label_re, m.group(1)) else None
            if cur:
                out[cur] = []
            continue
        if cur:
            out[cur].append(line)
    return out


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("level", help="e.g. OUT_OF_THE_WOODS_DAY_1")
    parser.add_argument("--rows", default="0:48")
    parser.add_argument("--cols", default="0:160")
    args = parser.parse_args()

    rooms = read("data/levels/rooms1.asm", "data/levels/rooms2.asm")
    table = re.search(rf"dw (\w+) ; {args.level}\n", rooms).group(1)
    body = rooms[rooms.index(f"{table}:"):]
    entries = re.findall(r"^\tdw (\.room_\d+|NULL)", body, re.M)[:30]
    room_data = {}
    for name, rest in re.findall(r"^(\.room_\d+)\n\troom_data\s+(.*)$", body, re.M):
        if name not in room_data:
            room_data[name] = [x.strip() for x in rest.split(",")]
    sector_room = {}
    for entry in entries:
        if entry == "NULL" or entry not in room_data:
            continue
        x, y, ylo, yhi, xlo, xhi = map(int, room_data[entry][:6])
        room_id = room_data[entry][-1]
        for sy in range(ylo, yhi):
            for sx in range(xlo, xhi):
                sector_room.setdefault((sx, sy), room_id)

    # ROOM_xxx -> BLOCK_FUNCTION_TABLE_xx -> BlockFunctionTablexx
    room_defs = dict(
        re.findall(r"^\.room_(\d+)\n\troom (BLOCK_FUNCTION_TABLE_\w+),", read("data/levels/rooms1.asm"), re.M)
    )
    func_tables = labelled_blocks(
        read("data/levels/function_tables1.asm", "data/levels/function_tables2.asm"),
        r"BlockFunctionTable\w+",
    )
    func_tables = {
        k: [m for line in v for m in re.findall(r"dw (BlockFunc_\w+)", line)]
        for k, v in func_tables.items()
    }

    headers = read("data/levels/level_headers.asm")
    header = re.search(rf"dw (\.\w+) +; {args.level}\n", headers).group(1)
    block_map = re.search(rf"^{re.escape(header)}\n\tdab (\w+)BlockMap", headers, re.M).group(1)
    level_asm = read("level.asm")
    path = re.search(rf"^{block_map}BlockMap:\s+INCBIN \"(.*)\.rle\"", level_asm, re.M).group(1)
    blocks = (SRC / path).read_bytes()
    obj_path = re.search(rf"^{block_map}ObjectMap:\s+INCBIN \"(.*)\.rle\"", level_asm, re.M).group(1)
    objects = (SRC / obj_path).read_bytes()

    def obj(n):
        byte = objects[n // 2]
        return byte >> 4 if n % 2 == 0 else byte & 0x0F

    r0, r1 = map(int, args.rows.split(":"))
    c0, c1 = map(int, args.cols.split(":"))
    print("     " + "".join(str(c // 10 % 10) if c % 10 == 0 else " " for c in range(c0, c1)))
    for r in range(r0, r1):
        line = []
        for c in range(c0, c1):
            n = r * LEVEL_WIDTH + c
            room_id = sector_room.get((c // 16, r // 16))
            if room_id is None:
                block = "."
            else:
                table_const = room_defs[room_id.removeprefix("ROOM_")]
                funcs = func_tables["BlockFunctionTable" + table_const.removeprefix("BLOCK_FUNCTION_TABLE_")]
                block = legend_char(funcs[blocks[n] & 0x7F])
            o = obj(n)
            # Object $f sits on doors and the like; don't let it hide them.
            if o and not (o == 0xF and block != " "):
                block = {1: "C", 2: "K", 3: "M"}.get(o, f"{o:x}")
            line.append(block)
        print(f"{r:3d}  " + "".join(line))


if __name__ == "__main__":
    main()
