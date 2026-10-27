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
    "Fence": "|", "RoomExit_ReloadObjects": "W", "WaterRoomExit_ReloadObjects": "W",
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


class Level:
    """A level's block functions and objects, as 2D arrays.

    funcs[row][col] is the block function name (e.g. "BlockFunc_Solid"), or
    None outside every room; objects[row][col] is the object map value (0 for
    none). rooms[i] is the room table entry for sector index i (row * 10 +
    col): a dict with the destination sector and the room's sector limits,
    or None.
    """

    def __init__(self, level):
        rooms = read("data/levels/rooms1.asm", "data/levels/rooms2.asm")
        table = re.search(rf"dw (\w+) ; {level}\n", rooms).group(1)
        body = rooms[rooms.index(f"{table}:"):]
        entries = re.findall(r"^\tdw (\.room_\d+|NULL)", body, re.M)[:30]
        room_headers = {}
        for name, rest in re.findall(r"^(\.room_\d+)\n\troom_header\s+(.*)$", body, re.M):
            if name not in room_headers:
                room_headers[name] = [x.strip() for x in rest.split(",")]
        self.rooms = []
        sector_room = {}
        sector_group = {}
        for entry in entries:
            if entry == "NULL" or entry not in room_headers:
                self.rooms.append(None)
                continue
            x, y, ylo, yhi, xlo, xhi = map(int, room_headers[entry][:6])
            room_id = room_headers[entry][-1]
            group = room_headers[entry][7]
            self.rooms.append(
                dict(dest=(x, y), rows=(ylo, yhi), cols=(xlo, xhi), room_id=room_id, object_group=group)
            )
            for sy in range(ylo, yhi):
                for sx in range(xlo, xhi):
                    sector_room.setdefault((sx, sy), room_id)
                    sector_group.setdefault((sx, sy), group)
        self.sector_group = sector_group

        # OBJECT_GROUP_xxx -> ObjectGroupN -> object data names, in order:
        # object map value v is the group's (v - 4)th object.
        group_labels = dict(
            (const, label)
            for label, const in re.findall(
                r"dw CommonObjects_\w+,\s+(ObjectGroup\w+)\s+; (OBJECT_GROUP_\w+)",
                read("engine/level/load_objects.asm"),
            )
        )
        group_objects = {
            label: [m for line in lines for m in re.findall(r"dw (\w+Data)\b", line)]
            for label, lines in labelled_blocks(read("data/object_groups.asm"), r"ObjectGroup\w+").items()
        }
        self.group_objects = {const: group_objects.get(label, []) for const, label in group_labels.items()}

        # ROOM_xxx -> BLOCK_FUNCTION_TABLE_xx -> BlockFunctionTablexx
        room_defs = dict(
            re.findall(r"^\.room_data_(\d+)\n\troom (BLOCK_FUNCTION_TABLE_\w+),", read("data/levels/rooms1.asm"), re.M)
        )
        func_tables = labelled_blocks(
            read("data/levels/function_tables1.asm", "data/levels/function_tables2.asm"),
            r"BlockFunctionTable\w+",
        )
        func_tables = {
            k: [m for line in v for m in re.findall(r"dw (BlockFunc_\w+)", line)]
            for k, v in func_tables.items()
        }

        headers = read("data/levels/level_maps.asm")
        header = re.search(rf"dw (\.\w+) +; {level}\n", headers).group(1)
        block_map = re.search(rf"^{re.escape(header)}\n\tdab (\w+)BlockMap", headers, re.M).group(1)
        level_asm = read("level.asm")
        path = re.search(rf"^{block_map}BlockMap:\s+INCBIN \"(.*)\.rle\"", level_asm, re.M).group(1)
        blocks = (SRC / path).read_bytes()
        obj_path = re.search(rf"^{block_map}ObjectMap:\s+INCBIN \"(.*)\.rle\"", level_asm, re.M).group(1)
        objects = (SRC / obj_path).read_bytes()

        self.funcs = []
        self.objects = []
        for r in range(LEVEL_HEIGHT):
            funcs_row, objects_row = [], []
            for c in range(LEVEL_WIDTH):
                n = r * LEVEL_WIDTH + c
                room_id = sector_room.get((c // 16, r // 16))
                if room_id is None:
                    funcs_row.append(None)
                else:
                    table_const = room_defs[room_id.removeprefix("ROOM_")]
                    funcs = func_tables["BlockFunctionTable" + table_const.removeprefix("BLOCK_FUNCTION_TABLE_")]
                    funcs_row.append(funcs[blocks[n] & 0x7F])
                byte = objects[n // 2]
                objects_row.append(byte >> 4 if n % 2 == 0 else byte & 0x0F)
            self.funcs.append(funcs_row)
            self.objects.append(objects_row)

    def object_name(self, r, c):
        """The object data at a cell (e.g. "TogebaData"), or None."""
        v = self.objects[r][c]
        if v < 4 or v == 0xF:
            return None
        objects = self.group_objects.get(self.sector_group.get((c // 16, r // 16)), [])
        return objects[v - 4] if v - 4 < len(objects) else None

    def char(self, r, c):
        func = self.funcs[r][c]
        block = "." if func is None else legend_char(func)
        o = self.objects[r][c]
        # Object $f sits on doors and the like; don't let it hide them.
        if o and not (o == 0xF and block != " "):
            block = {1: "C", 2: "K", 3: "M"}.get(o, f"{o:x}")
        return block


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("level", help="e.g. OUT_OF_THE_WOODS_DAY_1")
    parser.add_argument("--rows", default="0:48")
    parser.add_argument("--cols", default="0:160")
    args = parser.parse_args()

    level = Level(args.level)
    r0, r1 = map(int, args.rows.split(":"))
    c0, c1 = map(int, args.cols.split(":"))
    print("     " + "".join(str(c // 10 % 10) if c % 10 == 0 else " " for c in range(c0, c1)))
    for r in range(r0, r1):
        print(f"{r:3d}  " + "".join(level.char(r, c) for c in range(c0, c1)))


if __name__ == "__main__":
    main()
