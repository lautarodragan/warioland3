"""The debug owl's graphics in an enemy graphics slot the room doesn't use.

Owl object groups put the owl's graphics in slot 1, and the owl's sprites
(its object, Owl Wario's frames, the owl flying off when let go) all use
slot 1's tiles and palette 4. In a room without the owl, slot 1 belongs to
one of the room's enemies, so the debug owl puts its graphics in a slot the
room's group leaves unused, if any, and its sprites are moved there as
they're drawn. See owl.md.

Desert Ruins' start room (object group 023) has spearheads in slot 1 and
hands in slot 3, and leaves slots 2 and 4 unused: the owl goes into slot 2,
with palette 5. Out of the Woods' start room (010) uses all four slots, so
there the owl falls back to slot 1.
"""

import re

from game import OUT_OF_THE_WOODS_DAY_1, ROOT
from routes.desert_ruins import LET_GO, OWL_FLIGHT_TO_SPEARHEAD, START_ROOM_GRAB_DEBUG_OWL
from test_owl import (
    OWL_STATUS_SPAWNED,
    TRANSFORMATION_OWL_WARIO,
    WST_GRABBING_OWL,
    never_in_solid_blocks,
    owl_tiles_in_slot,
    slot_tiles,
    spawn_owl,
    spawned_owls,
    sprites_in_slot,
)

SRC = ROOT / "src"
DESERT_RUINS_DAY_1 = 0x30
SPEARHEAD = 0x00
WST_RELEASING_OWL = 0xBB


def spawn_owl_in_desert_ruins(game):
    game.new_game_to_overworld()
    game.enter_level(DESERT_RUINS_DAY_1)
    spearhead = slot_tiles(game, 1)
    assert not any(owl_tiles_in_slot(game, slot) for slot in range(1, 5))
    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    return spearhead


def test_desert_ruins_debug_owl_in_free_slot(game, golden):
    spearhead = spawn_owl_in_desert_ruins(game)
    assert game.read("wOwlTileOffset") == 0x40
    assert owl_tiles_in_slot(game, 2)
    assert slot_tiles(game, 1) == spearhead
    # The sleeping owl, from slot 2 in palette 5 (2 for its eyes and beak);
    # nothing on screen draws from slot 1.
    assert sprites_in_slot(game, 2) == {2, 5}
    assert sprites_in_slot(game, 1) == set()
    golden("desert_ruins_debug_owl", game.screenshot())


def test_desert_ruins_owl_wario_in_free_slot(game, golden):
    spearhead = spawn_owl_in_desert_ruins(game)
    in_bounds = never_in_solid_blocks(game, "DESERT_RUINS_DAY_1")

    game.play(START_ROOM_GRAB_DEBUG_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_GRABBING_OWL
    assert spawned_owls(game) == []
    # Owl Wario's owl, moved from slot 1 (palette 0 is its feet).
    assert sprites_in_slot(game, 2) == {0, 5}
    assert sprites_in_slot(game, 1) == set()
    golden("desert_ruins_debug_owl_grabbed", game.screenshot())

    # Over to a spearhead: the room's slot-1 enemy, drawn from slot 1 in
    # palette 4 as usual, next to Owl Wario.
    game.play(OWL_FLIGHT_TO_SPEARHEAD, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert any(obj_id == SPEARHEAD for _, flags, obj_id in game.objects() if flags & 2)
    assert sprites_in_slot(game, 1) == {4}
    assert sprites_in_slot(game, 2) == {0, 5}
    assert slot_tiles(game, 1) == spearhead
    golden("desert_ruins_owl_wario_and_spearhead", game.screenshot())


def test_desert_ruins_let_go_in_free_slot(game, golden):
    spawn_owl_in_desert_ruins(game)
    in_bounds = never_in_solid_blocks(game, "DESERT_RUINS_DAY_1")
    game.play(START_ROOM_GRAB_DEBUG_OWL + OWL_FLIGHT_TO_SPEARHEAD, on_frame=in_bounds)

    # The owl flies off as a particle, from slot 2 too.
    game.play(LET_GO, on_frame=in_bounds)
    assert game.read("wWarioState") == WST_RELEASING_OWL
    assert sprites_in_slot(game, 2) == {0, 5}
    assert sprites_in_slot(game, 1) == {4}
    golden("desert_ruins_debug_owl_let_go", game.screenshot())


def test_debug_owl_falls_back_to_slot_1(game, golden):
    game.new_game_to_overworld()
    game.enter_level(OUT_OF_THE_WOODS_DAY_1)
    assert not owl_tiles_in_slot(game, 1)
    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    assert game.read("wOwlTileOffset") == 0
    assert owl_tiles_in_slot(game, 1)
    golden("out_of_the_woods_debug_owl", game.screenshot())

    game.play([("right+b", 120), ("a", 35), ("", 15)])
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert spawned_owls(game) == []
    assert sprites_in_slot(game, 1) >= {0, 4}
    golden("out_of_the_woods_debug_owl_grabbed", game.screenshot())


def test_free_slot_rule_matches_oam_data():
    """SetOwlTileOffset's rule for an unused slot, checked against which
    VRAM1 tiles each group's objects' OAM tables draw: a slot is unused when
    the group's object list has DummyObjectData for it (or ends before it)
    and the group loads the slot's filler graphics, ObjectGroup0's. No object
    of the group may draw from a slot the rule calls unused."""
    oam_data = {
        name: oam
        for name, oam in re.findall(
            r"^(\w+Data):\s+object_data\s+\w+,\s+(\w+),",
            (SRC / "data/object_data.asm").read_text(),
            re.M,
        )
    }
    oam_slots, label = {}, None
    for path in sorted((SRC / "gfx/oam").glob("objects*.asm")):
        for line in path.read_text().splitlines():
            if m := re.match(r"^(\w+)::?$", line):
                label = m.group(1)
            elif m := re.match(r"\s+frame_oam\s+-?\d+,\s*-?\d+,\s*\$(\w+),(.*OAM_BANK1)", line):
                oam_slots.setdefault(label, set()).add(int(m.group(1), 16) // 0x40 + 1)
    # The clear gates share one OAM table with frames for each of slots 2-4,
    # and ClearGate1-3Func pick the frames of their own slot.
    oam_slots["OAM_181c47"] = set()

    groups = {}
    for block in re.split(r"\n(?=ObjectGroup\w+:)", (SRC / "data/object_groups.asm").read_text()):
        if m := re.match(r"(ObjectGroup\w+):\n\tdb \$(\w+)", block):
            pointers = re.findall(r"dw (\w+)", block)
            objects = pointers[4 : pointers.index("NULL")]
            groups[m.group(1)] = (int(m.group(2), 16), pointers[:4], objects)
    filler = groups["ObjectGroup0"][1]
    num_free = 0
    for name, (bank_offset, gfx, objects) in groups.items():
        if bank_offset:  # bosses: SetOwlTileOffset picks slot 1
            continue
        used = set().union(
            *(oam_slots.get(oam_data[obj], set()) for obj in objects if obj != "DummyObjectData")
        )
        for slot in range(1, 5):
            entry = objects[slot - 1] if slot <= len(objects) else "DummyObjectData"
            if entry == "DummyObjectData" and gfx[slot - 1] == filler[slot - 1]:
                num_free += 1
                assert slot not in used, f"{name} draws from slot {slot}"
    assert num_free > 100
