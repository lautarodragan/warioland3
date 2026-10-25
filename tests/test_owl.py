"""Owls, real and (eventually) spawned from the debug menu.

The Colossal Hole's start room loads the owl's object group (031) and has
an owl sleeping a few blocks in, so it's both the reference for how a real
owl looks and behaves and the place to spawn one where its graphics are
loaded. The Steep Canyon start room doesn't load owl graphics (its owl is
deep in the level), which makes it the case to check spawning against later.
"""

from game import OBJFLAG_TRANSIENT, OWL, THE_COLOSSAL_HOLE_DAY_1, THE_STEEP_CANYON_DAY_1
from routes.colossal_hole import TO_SLEEPING_OWL, WAKE_AND_GRAB_DEBUG_OWL, WAKE_AND_GRAB_OWL

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


def test_debug_owl_spawn_without_owl_graphics(game, golden):
    # The Steep Canyon start room doesn't load the owl object group, so
    # there's no owl data (or graphics) to spawn from.
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_FAILED
    golden("debug_menu_owl_failed", game.screenshot())

    game.close_debug_menu()
    assert spawned_owls(game) == []


def wario_block(game):
    mem, addr = game.pb.memory, game.addr
    y = mem[addr("wWarioYPos")] << 8 | mem[addr("wWarioYPos") + 1]
    x = mem[addr("wWarioXPos")] << 8 | mem[addr("wWarioXPos") + 1]
    return y // 16, x // 16


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
    row, col = wario_block(game)
    assert row == 26 and col < 24
    golden("colossal_hole_debug_owl_flight", game.screenshot())
