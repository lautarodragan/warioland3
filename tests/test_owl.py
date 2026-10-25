"""Owls, real and (eventually) spawned from the debug menu.

The Colossal Hole's start room loads the owl's object group (031) and has
an owl sleeping a few blocks in, so it's both the reference for how a real
owl looks and behaves and the place to spawn one where its graphics are
loaded. The Steep Canyon start room doesn't load owl graphics (its owl is
deep in the level), so there the debug menu loads them itself, into enemy
graphics slot 2, which the room doesn't use (test_owl_free_slot.py has more
on that).
"""

from game import ROOT, OBJFLAG_TRANSIENT, OWL, THE_COLOSSAL_HOLE_DAY_1, THE_STEEP_CANYON_DAY_1
from routes.colossal_hole import (
    DEBUG_MENU_SPAWN_OWL,
    GRAB_DEBUG_OWL_PAST_ROBOT,
    TO_SLEEPING_OWL,
    WAKE_AND_GRAB_DEBUG_OWL,
    WAKE_AND_GRAB_OWL,
)
from routes.steep_canyon import (
    START_ROOM_AWAY_FROM_FIRE_BOT,
    START_ROOM_GRAB_DEBUG_OWL,
    START_ROOM_OWL_FLIGHT,
)
from tools.level_map import Level
from tools.pathfind import SOLID, classify

# src/constants/wario_constants.asm
TRANSFORMATION_OWL_WARIO = 0x0E
WST_GRABBING_OWL = 0xB8
WST_OWL_SLOW = 0xB9

CURSOR_OWL = 4
OWL_STATUS_SPAWNED = 1
OWL_STATUS_FAILED = 2


def spawned_owls(game):
    return [
        slot
        for slot, flags, obj_id in game.objects()
        if obj_id == OWL and flags & OBJFLAG_TRANSIENT
    ]


def spawn_owl(game):
    game.open_debug_menu()
    game.menu_press("down", CURSOR_OWL)
    assert game.read("wDebugMenuCursor") == CURSOR_OWL
    game.menu_press("right")


def test_steep_canyon_before_owl_spawn(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)
    golden("steep_canyon_before_owl", game.screenshot())


def test_real_owl(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)

    game.play(TO_SLEEPING_OWL)
    golden("colossal_hole_sleeping_owl", game.screenshot())

    game.play(WAKE_AND_GRAB_OWL)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_GRABBING_OWL
    golden("colossal_hole_owl_grabbed", game.screenshot())

    # Holding on, the owl carries Wario up.
    game.tick(120)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_OWL_SLOW
    golden("colossal_hole_owl_flight", game.screenshot())


def test_debug_owl_spawn_in_owl_room(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)
    assert spawned_owls(game) == []

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    golden("debug_menu_owl_spawned", game.screenshot())

    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    golden("colossal_hole_debug_owl", game.screenshot())


OWL_GFX = (ROOT / "src/gfx/enemies/owl.2bpp").read_bytes()
SLOT_TILES = 0x40  # tiles per enemy graphics slot


def slot_tiles(game, slot):
    """The bytes of enemy graphics slot 1-4 (VRAM1 from $8000, $40 tiles
    each)."""
    start = 0x8000 + (slot - 1) * SLOT_TILES * 16
    return bytes(game.pb.memory[1, start : start + SLOT_TILES * 16])


def owl_tiles_in_slot(game, slot):
    """Whether enemy graphics slot 1-4 holds the owl's tiles."""
    return slot_tiles(game, slot) == OWL_GFX


def vram1_sprites(game):
    """The visible sprites in OAM drawn from VRAM1 (the enemy graphics), as
    (tile, palette) pairs."""
    sprites = []
    for n in range(40):
        y, x, tile, attr = (game.pb.memory[0xFE00 + 4 * n + i] for i in range(4))
        if 0 < y < 160 and 0 < x < 168 and attr & 0x08:
            sprites.append((tile, attr & 0x07))
    return sprites


def sprites_in_slot(game, slot):
    """The palettes of the visible sprites drawn from a slot's tiles."""
    lo = (slot - 1) * SLOT_TILES
    return {pal for tile, pal in vram1_sprites(game) if lo <= tile < lo + SLOT_TILES}


def test_debug_owl_spawn_in_room_without_owl(game, golden):
    # The Steep Canyon has an owl, but its start room's object group (094)
    # has none: the owl is spawned from its ROM data instead, and its
    # graphics and palette are loaded when the menu closes. Slot 1 has Prince
    # Froggy, but the group leaves slot 2 unused, so they go there (and its
    # palette, 5), and the owl's sprites are moved there as they're drawn.
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)
    prince_froggy = slot_tiles(game, 1)
    assert not any(owl_tiles_in_slot(game, slot) for slot in range(1, 5))

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    golden("debug_menu_owl_spawned_no_owl_room", game.screenshot())

    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    assert game.read("wOwlTileOffset") == 0x40
    assert owl_tiles_in_slot(game, 2)
    assert slot_tiles(game, 1) == prince_froggy
    # Palette 2 is the owl's eyes and beak, as with the real owl.
    assert sprites_in_slot(game, 2) == {2, 5}
    assert sprites_in_slot(game, 1) == set()
    golden("steep_canyon_start_debug_owl", game.screenshot())


def test_debug_owl_grab_and_fly_in_room_without_owl(game, golden):
    # Away from the fire bot first: it burns Wario if he lingers near it.
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)
    game.play(START_ROOM_AWAY_FROM_FIRE_BOT)
    spawn_owl(game)
    game.close_debug_menu()
    in_bounds = never_in_solid_blocks(game, "THE_STEEP_CANYON_DAY_1")

    game.play(START_ROOM_GRAB_DEBUG_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert spawned_owls(game) == []
    assert sprites_in_slot(game, 2) == {0, 5}  # Owl Wario's owl, in slot 2
    golden("steep_canyon_start_debug_owl_grabbed", game.screenshot())

    game.play(START_ROOM_OWL_FLIGHT, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_OWL_SLOW
    assert game.wario_block() == (18, 20)
    golden("steep_canyon_start_debug_owl_flight", game.screenshot())


def test_debug_owl_grab_and_fly(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)
    spawn_owl(game)
    game.close_debug_menu()

    game.play(WAKE_AND_GRAB_DEBUG_OWL)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_GRABBING_OWL
    golden("colossal_hole_debug_owl_grabbed", game.screenshot())

    # Flying right, the wall at column 24 has to stop Wario, as it does with
    # the real owl. Grabbing the spawned owl used to switch off cartridge
    # RAM (where the level's blocks live), after which Wario flew through
    # walls and the level's graphics broke.
    game.tick(60)
    game.play([("right", 240)])
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    row, col = game.wario_block()
    assert row == 26 and col < 24
    golden("colossal_hole_debug_owl_flight", game.screenshot())


def never_in_solid_blocks(game, level_name):
    """on_frame check: Wario's body is never inside a solid block (one-way
    floors, ladders and the like he can pass through). This reads the level
    data, so cracked blocks count as free: they may have been broken."""
    level = Level(level_name)

    def check():
        y, x = game.wario_pos()
        row, col = (y - 8) // 16, x // 16  # middle of his body, not his feet
        func = level.funcs[row][col]
        assert classify(func) != SOLID or func is None or "Cracked" in func, (
            f"Wario at {(y, x)} is inside {func} at block {(row, col)}"
        )

    return check


def grab_debug_owl_past_robot(game):
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)
    game.play(TO_SLEEPING_OWL + [("", 60)] + DEBUG_MENU_SPAWN_OWL)
    assert len(spawned_owls(game)) == 1
    game.play(GRAB_DEBUG_OWL_PAST_ROBOT + [("", 60)])
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    # It's the spawned owl that got grabbed, not the real one on the ledge.
    assert spawned_owls(game) == []


def test_debug_owl_stops_at_wall(game, golden):
    grab_debug_owl_past_robot(game)
    in_bounds = never_in_solid_blocks(game, "THE_COLOSSAL_HOLE_DAY_1")

    game.play([("right", 90)], on_frame=in_bounds)
    assert game.wario_block() == (26, 29)  # against the wall at column 30
    y, x = game.wario_pos()

    # Holding right longer doesn't push Wario into the wall.
    game.play([("right", 120)], on_frame=in_bounds)
    assert game.wario_pos() == (y, x)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("colossal_hole_debug_owl_at_wall", game.screenshot())


def test_debug_owl_flies_out_across_rooms(game, golden):
    # The camera scrolling new parts of the level in, and room transitions,
    # are where carrying a spawned owl used to crash or corrupt graphics.
    grab_debug_owl_past_robot(game)
    in_bounds = never_in_solid_blocks(game, "THE_COLOSSAL_HOLE_DAY_1")

    # Down to the bottom of the start area, then right: under the wall and
    # across the big shaft to the wall on its far side.
    game.play([("right", 90), ("down", 40), ("right", 300)], on_frame=in_bounds)
    assert game.wario_block() == (28, 47)
    golden("colossal_hole_debug_owl_shaft", game.screenshot())

    # Down the shaft, through the transition at its bottom, into the room
    # in sector (5, 0) at the top of the level.
    game.play([("down", 300)], on_frame=in_bounds)
    assert game.wario_block() == (8, 88)
    golden("colossal_hole_debug_owl_new_room", game.screenshot())

    game.play([("right", 600)], on_frame=in_bounds)
    assert game.wario_block() == (8, 95)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("colossal_hole_debug_owl_far_right", game.screenshot())
