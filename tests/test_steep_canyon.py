"""The Steep Canyon towards its owl, unlocked with the debug menu's TREASURE.

The owl room is only reachable through a secret door that opens once Wario
has N5's Foot of Stone: with it, SelectLevel loads the level's second
variant. Getting there also needs the Swimming Flippers and the High Jump
Boots, so the debug menu's POWER goes to 9 too.
"""

from game import LEVEL_OUT_OF_THE_WOODS, LEVEL_THE_STEEP_CANYON
from routes.steep_canyon import (
    COLUMN_FLY_TO_NEXT_ROOM,
    COLUMN_GRAB_DEBUG_OWL,
    GRAB_OWL,
    TO_CRACKED_COLUMN,
    TO_CORRIDOR,
    TO_OWL_ROOM,
    TO_SHAFT,
    TOGEBA_TO_LADDER,
    UP_THE_SHAFT,
)
from test_owl import (
    OWL_STATUS_SPAWNED,
    TRANSFORMATION_OWL_WARIO,
    WST_OWL_SLOW,
    never_in_solid_blocks,
    owl_tiles_in_slot_1,
    spawn_owl,
    spawned_owls,
)

THE_STEEP_CANYON_DAY_2 = 0x79
THE_STEEP_CANYON_DAY_4 = 0x7B
FOOT_OF_STONE = 0x3F
RUST_SPRAY = 0x2D
CURSOR_POWER = 1
CURSOR_TREASURE = 5
N5_RED = 4 * 4 + 1  # TREASURE row index: level * 4 + colour
N8_BLUE = 20 * 4 + 3  # LEVEL_CASTLE_OF_ILLUSIONS
NUM_TREASURE_ROWS = 25 * 4


def test_steep_canyon_to_the_owl(game, golden):
    game.new_game_to_overworld()
    game.enter_level()

    game.open_debug_menu()
    game.menu_press("down", CURSOR_POWER)
    game.menu_press("right", 9)
    game.menu_press("down", CURSOR_TREASURE - CURSOR_POWER)
    game.menu_press("right", N5_RED)
    game.menu_press("a")
    game.close_debug_menu()
    assert game.treasure_collected(FOOT_OF_STONE)
    assert game.read("wPowerUpLevel") == 9

    # Leaving a level switches between day and night: leave twice to enter
    # the day variant.
    game.return_to_map()
    game.enter_level_from_map(LEVEL_OUT_OF_THE_WOODS)
    game.return_to_map()
    game.enter_level_from_map(LEVEL_THE_STEEP_CANYON)
    assert game.read("wLevel") == THE_STEEP_CANYON_DAY_2
    golden("steep_canyon_foot_of_stone_start", game.screenshot())

    game.play(TO_CORRIDOR)
    assert game.wario_block() == (37, 18)
    golden("steep_canyon_corridor", game.screenshot())

    game.play(TO_SHAFT)
    assert game.wario_block() == (46, 5)
    golden("steep_canyon_shaft", game.screenshot())

    game.play(UP_THE_SHAFT)
    assert game.wario_block() == (30, 10)
    golden("steep_canyon_shaft_halfway", game.screenshot())

    # The Togeba below jumps when the ground shakes, and floating back down
    # it's a platform: the only way up to the ladder.
    game.play(TOGEBA_TO_LADDER)
    assert game.wario_block() == (22, 6)
    golden("steep_canyon_shaft_top", game.screenshot())

    game.play(TO_OWL_ROOM)
    assert game.wario_block() == (45, 122)
    golden("steep_canyon_owl_room", game.screenshot())
    in_owl_room = game.snapshot()

    # The real owl.
    in_bounds = never_in_solid_blocks(game, "THE_STEEP_CANYON_DAY_2")
    game.play(GRAB_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    game.play([("", 60)], on_frame=in_bounds)
    assert game.read("wWarioState") == WST_OWL_SLOW
    golden("steep_canyon_owl_flight", game.screenshot())

    # A debug owl, spawned in the room the real one lives in.
    game.restore(in_owl_room)
    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    golden("steep_canyon_debug_owl", game.screenshot())


def test_steep_canyon_debug_owl_to_next_room(game, golden):
    # The Rust Spray picks the fourth variant, where the column at the right
    # end of the start room is cracked. Past it, a room transition leads down
    # into the next room, whose object group has no owl.
    game.new_game_to_overworld()
    game.enter_level()
    game.open_debug_menu()
    game.menu_press("down", CURSOR_POWER)
    game.menu_press("right", 9)
    game.menu_press("down", CURSOR_TREASURE - CURSOR_POWER)
    game.menu_press("left", NUM_TREASURE_ROWS - N8_BLUE)  # wraps around
    game.menu_press("a")
    game.close_debug_menu()
    assert game.treasure_collected(RUST_SPRAY)

    game.return_to_map()
    game.enter_level_from_map(LEVEL_OUT_OF_THE_WOODS)
    game.return_to_map()
    game.enter_level_from_map(LEVEL_THE_STEEP_CANYON)
    assert game.read("wLevel") == THE_STEEP_CANYON_DAY_4

    game.play(TO_CRACKED_COLUMN)
    assert game.wario_block() == (27, 107)
    golden("steep_canyon_column_broken", game.screenshot())

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    golden("steep_canyon_column_debug_owl", game.screenshot())

    in_bounds = never_in_solid_blocks(game, "THE_STEEP_CANYON_DAY_4")
    game.play(COLUMN_GRAB_DEBUG_OWL, on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    golden("steep_canyon_column_debug_owl_grabbed", game.screenshot())

    # The owl doesn't despawn: Wario holds it, as part of Owl Wario, into the
    # next room. That room's group puts another enemy in slot 1, so Owl
    # Wario's owl used to draw with that enemy's tiles; now the owl's
    # graphics are loaded there too.
    room = game.read("wLevelRoomID")
    game.play(COLUMN_FLY_TO_NEXT_ROOM, on_frame=in_bounds)
    assert game.read("wLevelRoomID") != room
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert owl_tiles_in_slot_1(game)
    golden("steep_canyon_debug_owl_next_room", game.screenshot())
