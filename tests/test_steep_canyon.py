"""The Steep Canyon towards its owl, unlocked with the debug menu's TREASURE.

The owl room is only reachable through a secret door that opens once Wario
has N5's Foot of Stone: with it, SelectLevel loads the level's second
variant. Getting there also needs the Swimming Flippers and the High Jump
Boots, so the debug menu's POWER goes to 9 too.
"""

from game import LEVEL_OUT_OF_THE_WOODS, LEVEL_THE_STEEP_CANYON
from routes.steep_canyon import TO_CORRIDOR, TO_SHAFT, UP_THE_SHAFT

THE_STEEP_CANYON_DAY_2 = 0x79
FOOT_OF_STONE = 0x3F
CURSOR_POWER = 1
CURSOR_TREASURE = 5
N5_RED = 4 * 4 + 1  # TREASURE row index: level * 4 + colour


def test_steep_canyon_to_the_shaft(game, golden):
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
