"""The debug owl in levels without owls: "the debug owl can be used in any
level".

A survey of every level's start room (day and night) found these cases
worth keeping as tests; the rest behave like the ones here. See book/src/debug-owl.md.
"""

import pytest

from game import OWL, THE_STEEP_CANYON_DAY_1
from routes.debug_owl import (
    BENEATH_THE_WAVES_DIVE,
    BENEATH_THE_WAVES_GRAB_UNDERWATER,
    GRAB_SPAWNED_OWL,
    SHORT_FLIGHT,
    STEEP_CANYON_FLY_INTO_THE_WATER,
    STEEP_CANYON_GRAB_FROM_THE_WATER,
    STEEP_CANYON_INTO_THE_WATER,
    VAST_PLAIN_TO_TOP_COIN,
)
from test_owl import (
    CURSOR_OWL,
    OWL_STATUS_FAILED,
    OWL_STATUS_SPAWNED,
    TRANSFORMATION_OWL_WARIO,
    WST_GRABBING_OWL,
    WST_OWL_SLOW,
    never_in_solid_blocks,
    owl_tiles_in_slot,
    owl_tiles_where_expected,
    spawn_owl,
    spawned_owls,
)
from test_owl_cases import NUM_OBJECTS, TRANSFORMATION_NONE, WST_RELEASING_OWL, owl_position

# src/constants/level_constants.asm
OUT_OF_THE_WOODS_DAY_1 = 0x00
THE_POOL_OF_RAIN_DAY_1 = 0x40
THE_VAST_PLAIN_NIGHT_1 = 0x14
BENEATH_THE_WAVES_DAY_1 = 0x50
THE_GRASSLANDS_DAY_1 = 0x60
ABOVE_THE_CLOUDS_DAY_1 = 0x88
THE_STAGNANT_SWAMP_NIGHT_1 = 0x94
CASTLE_OF_ILLUSIONS_DAY_1 = 0xA0
THE_WARPED_VOID_DAY_1 = 0xB0
THE_EAST_CRATER_DAY_1 = 0xB8
THE_TEMPLE = 0xC8
# src/constants/wario_constants.asm
WST_OWL_FAST = 0xBA
APPLEBY = 0x1D
WST_SWIMMING_STATES = range(0x0A, 0x12)  # WST_DIVING .. WST_TRYING_SUBMERGE
CURSOR_POWER = 1
SCREEN_HEIGHT = 144
OAM_Y_OFS = 16  # wWarioScreenYPos is in OAM coordinates
OWL_WARIO_HEIGHT = 60  # from his feet to the top of the owl
OWL_WARIO_BODY_HEIGHT = 32  # without the owl


def spawn_and_close(game):
    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    assert owl_tiles_where_expected(game)


def wario_on_screen(game):
    feet = game.read("wWarioScreenYPos") - OAM_Y_OFS
    return 0 < feet <= SCREEN_HEIGHT


@pytest.mark.parametrize(
    "name, level",
    [
        # Its start room is one the level data (tools/level_map.py) gets
        # wrong: never_in_solid_blocks reads the game's own blocks now.
        ("above_the_clouds", ABOVE_THE_CLOUDS_DAY_1),
        # Light sources and zombies; left out of the earlier rounds.
        ("castle_of_illusions", CASTLE_OF_ILLUSIONS_DAY_1),
        # Three seed shooters, and floor transitions instead of a free camera.
        ("pool_of_rain", THE_POOL_OF_RAIN_DAY_1),
        ("warped_void", THE_WARPED_VOID_DAY_1),
        # No objects at all in the start room.
        ("east_crater", THE_EAST_CRATER_DAY_1),
    ],
)
def test_debug_owl_in_level_without_owl(game, golden, name, level):
    game.new_game_to_overworld()
    game.enter_level(level)
    assert OWL not in [obj_id for _, _, obj_id in game.objects()]
    assert not any(owl_tiles_in_slot(game, slot) for slot in range(1, 5))

    spawn_and_close(game)
    golden(f"any_level_{name}_spawned", game.screenshot())

    in_bounds = never_in_solid_blocks(game, name)
    game.play(GRAB_SPAWNED_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert spawned_owls(game) == []

    game.play(SHORT_FLIGHT, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") in (WST_OWL_SLOW, WST_OWL_FAST)
    assert owl_tiles_where_expected(game)
    assert wario_on_screen(game)
    golden(f"any_level_{name}_flight", game.screenshot())


def test_debug_owl_at_night_without_owl(game, golden):
    # Leaving a level switches to night. At night the owl takes off as soon
    # as it's spawned, with the night palettes all around it.
    game.new_game_to_overworld()
    game.enter_level()
    game.return_to_map()
    game.enter_level(THE_STAGNANT_SWAMP_NIGHT_1)
    y, _ = game.wario_pos()

    spawn_and_close(game)
    (slot,) = spawned_owls(game)
    owl_y, _ = owl_position(game, slot)
    assert owl_y < y  # already flying
    golden("any_level_night_spawned", game.screenshot())

    in_bounds = never_in_solid_blocks(game, "THE_STAGNANT_SWAMP_NIGHT_1")
    game.play(GRAB_SPAWNED_OWL + SHORT_FLIGHT, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("any_level_night_flight", game.screenshot())


def owl_wario_on_screen(game):
    """Owl Wario is on screen, and the owl he holds too unless the camera is
    at the room's top edge (it can't go higher, so the owl can be above it
    while Wario reaches what's at the very top)."""
    feet = game.read("wWarioScreenYPos") - OAM_Y_OFS
    if not OWL_WARIO_BODY_HEIGHT <= feet <= SCREEN_HEIGHT:
        return False
    bank, addr = game.pb.symbol_lookup("wCameraSCY")
    camera_y = game.pb.memory[addr] << 8 | game.pb.memory[addr + 1]
    at_room_top = camera_y <= game.read("wRoomUpperYLimit") << 8
    return at_room_top or feet >= OWL_WARIO_HEIGHT


def test_debug_owl_floor_transitions(game, golden):
    # Out of the Woods' start room has no free camera: it moves a floor
    # (128 pixels) at a time, when Wario goes past one. Real owls only fly
    # in free camera rooms. There's no floor position where Owl Wario, 60
    # pixels tall with the owl, always fits on the 144 pixel screen, so the
    # camera follows him instead, and goes back to his floor's position
    # once he lets go.
    game.new_game_to_overworld()
    game.enter_level(OUT_OF_THE_WOODS_DAY_1)
    spawn_and_close(game)
    in_bounds = never_in_solid_blocks(game, "OUT_OF_THE_WOODS_DAY_1")
    game.play(GRAB_SPAWNED_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wFloor") == 1
    floor_1_scy = 104  # where the camera rests on the first floor

    def visible():
        in_bounds()
        assert owl_wario_on_screen(game), game.wario_pos()

    # Up into the second floor: the camera follows him, owl and all, and
    # wFloor follows his feet. The owl's graphics are in slot 2, which the
    # room lends while it's around (see test_owl_free_slot.py), so the
    # Appleby up here isn't spawned (it would draw with the owl's tiles).
    game.play([("up", 120)], on_frame=visible)
    assert game.read("wFloor") == 2
    assert game.read("wOwlTileOffset") == 0x41
    assert not any(obj_id == APPLEBY for _, _, obj_id in game.objects())
    golden("any_level_floor_up", game.screenshot())

    # As high as he goes: the room's ceiling. Across and back, and down to
    # the ground.
    game.play([("up", 120), ("right", 150), ("left", 150)], on_frame=visible)
    assert game.wario_block() == (34, 3)
    game.play([("down", 200)], on_frame=visible)
    assert game.read("wFloor") == 1
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("any_level_floor_down", game.screenshot())

    # Letting go, the camera goes back to where the floor has it, and once
    # the owl has flown off, the slot is given back.
    game.play([("b", 4), ("", 60)], on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    assert game.read("wOwlCameraDisplaced") == 0
    assert game.read("wSCY") == floor_1_scy
    game.wait_until(lambda: game.read("wOwlTileOffset") == 0, timeout=120, what="slot given back")
    assert not any(owl_tiles_in_slot(game, slot) for slot in range(1, 5))


def test_debug_owl_reaches_the_top_of_the_room(game, golden):
    # The Vast Plain's start room has a musical coin in its top row and no
    # ceiling above it but the top of the level. Owl Wario has to reach it,
    # and not fly out of the level: the room's top edge stops his body, while
    # the owl he holds can go above the screen (the camera stops there).
    game.new_game_to_overworld()
    game.enter_level(THE_VAST_PLAIN_NIGHT_1)
    spawn_and_close(game)
    in_bounds = never_in_solid_blocks(game)
    game.play(GRAB_SPAWNED_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wNumMusicalCoins") == 0

    def visible():
        in_bounds()
        assert owl_wario_on_screen(game), game.wario_pos()

    game.play(VAST_PLAIN_TO_TOP_COIN, on_frame=visible)
    assert game.read("wNumMusicalCoins") == 1
    assert game.wario_block()[0] == 2  # feet two blocks below the top
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("any_level_top_of_room_coin", game.screenshot())


def test_debug_owl_in_and_out_of_water(game, golden):
    # Spawned next to Wario floating at the surface, the owl sits in the
    # water until he swims into it. He can jump out of the water into it, and
    # flying back into the water makes him let go, as a real owl would.
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)
    game.play(STEEP_CANYON_INTO_THE_WATER)
    assert game.read("wWarioState") in WST_SWIMMING_STATES

    spawn_and_close(game)
    golden("any_level_water_spawned", game.screenshot())

    game.play(STEEP_CANYON_GRAB_FROM_THE_WATER)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("any_level_water_grabbed", game.screenshot())

    states = []

    def record():
        state = game.read("wWarioState")
        if state not in states:
            states.append(state)

    game.play(STEEP_CANYON_FLY_INTO_THE_WATER, on_frame=record)
    assert WST_RELEASING_OWL in states
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    assert game.read("wWarioState") in WST_SWIMMING_STATES
    golden("any_level_water_let_go", game.screenshot())


def test_debug_owl_underwater(game, golden):
    # Deep underwater, a woken owl stays underwater, and Wario can swim up
    # into it and grab it. He hangs on for a moment, then lets go: Owl Wario
    # can't be in water. (The fish next to him keeps its own tiles: the
    # owl's went into a graphics slot the room doesn't use.)
    game.new_game_to_overworld()
    game.enter_level(BENEATH_THE_WAVES_DAY_1)
    game.open_debug_menu()
    game.menu_press("down", CURSOR_POWER)
    game.menu_press("right", 9)
    game.close_debug_menu()
    game.play(BENEATH_THE_WAVES_DIVE)
    assert game.read("wWarioState") in WST_SWIMMING_STATES

    spawn_and_close(game)
    golden("any_level_underwater_spawned", game.screenshot())

    game.play(BENEATH_THE_WAVES_GRAB_UNDERWATER)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_GRABBING_OWL
    golden("any_level_underwater_grabbed", game.screenshot())

    game.play([("", 90)])
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    assert game.read("wWarioState") in WST_SWIMMING_STATES


def test_debug_owl_fills_slots_without_owl(game, golden):
    # The Grasslands' start room has three Hebariis and their projectiles, and
    # a musical coin: six objects, room for two owls.
    game.new_game_to_overworld()
    game.enter_level(THE_GRASSLANDS_DAY_1)
    assert len(game.objects()) == NUM_OBJECTS - 2

    game.open_debug_menu()
    game.menu_press("down", CURSOR_OWL)
    statuses = []
    for _ in range(3):
        game.menu_press("a")
        statuses.append(game.read("wDebugMenuOwlStatus"))
    assert statuses == [OWL_STATUS_SPAWNED] * 2 + [OWL_STATUS_FAILED]
    assert len(game.objects()) == NUM_OBJECTS

    game.close_debug_menu()
    assert len(spawned_owls(game)) == 2
    assert owl_tiles_where_expected(game)
    game.tick(60)
    assert len(spawned_owls(game)) == 2
    golden("any_level_slots_full", game.screenshot())


def test_debug_owl_refused_in_boss_battle(game, golden):
    # The Temple is a boss battle from the start. Bosses keep their own
    # graphics in the enemy slots: the owl's would overwrite part of the
    # boss (here, its face and hands), so the menu says NO.
    game.new_game_to_overworld()
    game.enter_level(THE_TEMPLE)
    assert game.read("wIsBossBattle")
    slot_1 = bytes(game.pb.memory[1, 0x8000:0x8800])

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_FAILED
    golden("any_level_boss_menu", game.screenshot())

    game.close_debug_menu()
    assert spawned_owls(game) == []
    assert bytes(game.pb.memory[1, 0x8000:0x8800]) == slot_1


def test_debug_owl_saved_and_continued(game, golden):
    # Saving keeps the level's objects, the spawned owl among them, and
    # continuing loads the room's graphics from its object group again:
    # the owl's have to be loaded back too (into a free slot, if there's
    # one), or it draws with the tiles of whichever enemy is in that slot.
    game.new_game_to_overworld()
    game.enter_level(OUT_OF_THE_WOODS_DAY_1)
    spawn_and_close(game)

    game.save_and_continue()
    assert game.read("wLevel") == OUT_OF_THE_WOODS_DAY_1
    assert len(spawned_owls(game)) == 1
    assert owl_tiles_where_expected(game)
    golden("any_level_saved_owl", game.screenshot())

    game.play(GRAB_SPAWNED_OWL)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("any_level_saved_owl_grabbed", game.screenshot())
