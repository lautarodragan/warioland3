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
there the owl borrows one, which no active object draws from: its objects
aren't spawned while the owl is around, and its graphics, palette and
object data are given back once the owl is gone.
"""

import re

from game import OUT_OF_THE_WOODS_DAY_1, ROOT
from routes.debug_owl import GRAB_SPAWNED_OWL
from routes.desert_ruins import LET_GO, OWL_FLIGHT_TO_SPEARHEAD, START_ROOM_GRAB_DEBUG_OWL
from test_owl import (
    CURSOR_OWL,
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
APPLEBY = 0x1D
WST_RELEASING_OWL = 0xBB
TRANSFORMATION_NONE = 0x00
PAL_SIZE = 8
# src/constants/object_constants.asm
OWL_SLOT_BORROWED = 1 << 0
OWL_SLOT_RESTORE_MASK = 0b111
OWL_SLOT_NUM_CHUNKS = 4


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


def obj_data_ptrs(game):
    """wObjDataPtr01-13: the room's object data, by object map index."""
    base = game.addr("wObjDataPtr01")
    mem = game.pb.memory
    return [mem[1, base + 2 * n] | mem[1, base + 2 * n + 1] << 8 for n in range(13)]


def ob_pal(game, pal):
    """Object palette 0-7 in wTempPals2."""
    start = game.addr("wTempPals2") + pal * PAL_SIZE
    return bytes(game.pb.memory[start : start + PAL_SIZE])


def vblank_target(game):
    """Where the jump in wVBlankFunc goes (LevelVBlankFunc in levels)."""
    addr = game.addr("wVBlankFunc")
    return game.pb.memory[addr + 1] | game.pb.memory[addr + 2] << 8


def out_of_the_woods_room(game):
    """Out of the Woods' start room as the level loads it: every slot's
    graphics, object palettes 4-7 and object data pointers."""
    return (
        [slot_tiles(game, slot) for slot in range(1, 5)],
        [ob_pal(game, pal) for pal in range(4, 8)],
        obj_data_ptrs(game),
    )


def assert_slot_given_back(game, room):
    tiles, pals, ptrs = room
    assert game.read("wOwlTileOffset") == 0
    assert game.read("wOwlSlotRestore") == 0
    assert [slot_tiles(game, slot) for slot in range(1, 5)] == tiles
    assert [ob_pal(game, pal) for pal in range(4, 8)] == pals
    assert obj_data_ptrs(game) == ptrs
    assert vblank_target(game) == game.addr("LevelVBlankFunc")


def borrow_slot_in_out_of_the_woods(game):
    """Spawns the owl in Out of the Woods' start room (object group 010:
    spearheads, Applebys, Futamogus and torches, all four slots used). The
    spearhead in slot 1 is active, the Applebys of slot 2 aren't: the owl
    borrows slot 2."""
    game.new_game_to_overworld()
    game.enter_level(OUT_OF_THE_WOODS_DAY_1)
    room = out_of_the_woods_room(game)
    assert any(obj_id == SPEARHEAD for _, _, obj_id in game.objects())
    assert not any(obj_id == APPLEBY for _, _, obj_id in game.objects())
    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    assert game.read("wOwlTileOffset") == 0x40 | OWL_SLOT_BORROWED
    assert owl_tiles_in_slot(game, 2)
    tiles, _, ptrs = room
    assert slot_tiles(game, 1) == tiles[0]
    # Applebys aren't spawned while the owl is around: their entry is
    # replaced, everything else is as it was.
    refused = obj_data_ptrs(game)
    assert refused[1] == game.addr("RefusedObjectData")
    assert refused[:1] + refused[2:] == ptrs[:1] + ptrs[2:]
    return room


def grab_and_let_go_in_out_of_the_woods(game):
    game.play([("right+b", 120), ("a", 35), ("", 15)])
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert spawned_owls(game) == []
    game.play([("up", 30), ("right", 30), ("b", 4)])
    assert game.read("wWarioState") == WST_RELEASING_OWL


def test_debug_owl_borrows_an_idle_slot(game, golden):
    room = borrow_slot_in_out_of_the_woods(game)
    # From slot 2 in palette 5 (2 for its eyes and beak).
    assert sprites_in_slot(game, 2) == {2, 5}
    golden("out_of_the_woods_debug_owl", game.screenshot())

    game.play([("right+b", 120), ("a", 35), ("", 15)])
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert spawned_owls(game) == []
    assert sprites_in_slot(game, 2) >= {0, 5}
    golden("out_of_the_woods_debug_owl_grabbed", game.screenshot())

    # Let go: the owl flies off (from slot 2 too), and once it's gone the
    # slot's graphics and palette are copied back with the LCD on, and the
    # Applebys can spawn again.
    game.play([("up", 30), ("right", 30), ("b", 4)])
    assert game.read("wWarioState") == WST_RELEASING_OWL
    assert owl_tiles_in_slot(game, 2)
    restoring = False
    for _ in range(90):
        game.tick()
        if game.read("wOwlSlotRestore") & OWL_SLOT_RESTORE_MASK:
            restoring = True
            assert vblank_target(game) == game.addr("OwlSlotRestoreVBlankFunc")
        if game.read("wOwlTileOffset") == 0:
            break
    assert restoring
    assert_slot_given_back(game, room)


def test_owl_slot_given_back_after_select(game):
    # SELECT turns Owl Wario back into Wario, owl and all, without the owl
    # flying off.
    room = borrow_slot_in_out_of_the_woods(game)
    game.play([("right+b", 120), ("a", 35), ("", 15)])
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    game.press("select", wait=10)
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    assert_slot_given_back(game, room)


def open_menu_while_giving_back(game):
    grab_and_let_go_in_out_of_the_woods(game)
    game.wait_until(
        lambda: game.read("wOwlSlotRestore") & OWL_SLOT_RESTORE_MASK, timeout=120, what="restore"
    )
    game.open_debug_menu()
    # Opened before the last of the slot's chunks was copied back.
    assert 1 <= game.read("wOwlSlotRestore") & OWL_SLOT_RESTORE_MASK <= OWL_SLOT_NUM_CHUNKS
    assert game.read("wOwlTileOffset") == 0x40 | OWL_SLOT_BORROWED


def test_owl_slot_given_back_across_the_menu(game):
    room = borrow_slot_in_out_of_the_woods(game)
    open_menu_while_giving_back(game)
    # The menu has its own V-Blank function; after it, the level's goes
    # through OwlSlotRestoreVBlankFunc again until the slot's back.
    game.close_debug_menu()
    assert_slot_given_back(game, room)


def test_new_owl_takes_the_slot_over(game):
    room = borrow_slot_in_out_of_the_woods(game)
    open_menu_while_giving_back(game)
    # A new owl while the slot is being given back keeps it: the owl's
    # graphics go there again, over what was copied back, and the Applebys
    # are refused again.
    game.menu_press("down", CURSOR_OWL)
    game.menu_press("a")
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert game.read("wOwlTileOffset") == 0x40 | OWL_SLOT_BORROWED
    assert game.read("wOwlSlotRestore") == 0
    assert owl_tiles_in_slot(game, 2)
    assert obj_data_ptrs(game)[1] == game.addr("RefusedObjectData")
    assert vblank_target(game) == game.addr("LevelVBlankFunc")
    # Grab it and let go: the slot's given back as it was when the first owl
    # borrowed it.
    game.play(GRAB_SPAWNED_OWL)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    game.play([("up", 30), ("b", 4), ("", 60)])
    assert_slot_given_back(game, room)


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
    oam_slots["ClearGateOAM_181c47"] = set()

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
