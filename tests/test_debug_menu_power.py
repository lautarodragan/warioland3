"""The debug menu's POWER page (START from MAIN)."""

from game import SST_DEBUG_MENU_MAIN, SST_DEBUG_POWER_PAGE, ST_DEBUG_MENU, ST_LEVEL

# src/constants/wario_constants.asm
NO_POWER_UP = 0
GRAB_GLOVE = 4
SUPER_JUMP_SLAM_OVERALLS = 6
HIGH_JUMP_BOOTS = 7
SUPER_GRAB_GLOVES = 9

# src/constants/movement_constants.asm
JUMP_VEL_NORMAL = 2
JUMP_VEL_HIGH_JUMP = 3


def open_power_page(game):
    game.open_debug_menu()
    game.menu_press("start")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_POWER_PAGE)


def jump_vel_table(game):
    """Jump with UP held, the High Jump Boots' jump if Wario has them."""
    game.pb.button_press("up")
    game.press("a")
    vel_table = game.read("wJumpVelTable")
    game.pb.button_release("up")
    game.tick(90)  # land
    return vel_table


def test_debug_power_page(game, golden):
    game.new_game_to_overworld()
    game.enter_level()
    game.write("wPowerUpLevel", GRAB_GLOVE)
    assert jump_vel_table(game) == JUMP_VEL_NORMAL

    # The selection starts on the current level. Up to the Grab Glove in
    # colour, the rest in grey, each with its treasure.
    open_power_page(game)
    assert game.read("wDebugPowerCursor") == GRAB_GLOVE
    golden("debug_power_page", game.screenshot())

    # Two columns of five: UP/DOWN within a column, LEFT/RIGHT between
    # them, no wrapping.
    game.menu_press("down")
    assert game.read("wDebugPowerCursor") == GRAB_GLOVE
    game.menu_press("right")
    assert game.read("wDebugPowerCursor") == SUPER_GRAB_GLOVES
    game.menu_press("right")
    game.menu_press("down")
    assert game.read("wDebugPowerCursor") == SUPER_GRAB_GLOVES
    game.menu_press("up", 3)
    assert game.read("wDebugPowerCursor") == SUPER_JUMP_SLAM_OVERALLS
    game.menu_press("up", 2)
    assert game.read("wDebugPowerCursor") == SUPER_JUMP_SLAM_OVERALLS - 1
    game.menu_press("left")
    assert game.read("wDebugPowerCursor") == NO_POWER_UP
    game.menu_press("left")
    game.menu_press("up")
    assert game.read("wDebugPowerCursor") == NO_POWER_UP
    # Moving doesn't apply anything.
    assert game.read("wPowerUpLevel") == GRAB_GLOVE

    # A applies the selection: everything up to the High Jump Boots.
    game.menu_press("right")
    game.menu_press("down", 2)
    assert game.read("wDebugPowerCursor") == HIGH_JUMP_BOOTS
    game.menu_press("a")
    assert game.read("wPowerUpLevel") == HIGH_JUMP_BOOTS
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_POWER_PAGE)
    golden("debug_power_page_boots", game.screenshot())

    # B closes the menu (SELECT too, see test_debug_menu.py): back in the
    # level, with its graphics, and Wario has the boots.
    game.close_debug_menu()
    assert game.state[0] == ST_LEVEL
    golden("debug_power_level", game.screenshot())
    assert jump_vel_table(game) == JUMP_VEL_HIGH_JUMP

    # And loses them when the POWER page sets a lower level. The page
    # starts on the current level again.
    open_power_page(game)
    assert game.read("wDebugPowerCursor") == HIGH_JUMP_BOOTS
    game.menu_press("up")
    assert game.read("wDebugPowerCursor") == SUPER_JUMP_SLAM_OVERALLS
    game.menu_press("a")
    assert game.read("wPowerUpLevel") == SUPER_JUMP_SLAM_OVERALLS
    game.close_debug_menu()
    assert jump_vel_table(game) == JUMP_VEL_NORMAL


def test_debug_set_power(game, golden):
    # The helper the other tests use to set a power-up level through the
    # menu: from MAIN to POWER, select, A, and back to MAIN.
    game.new_game_to_overworld()
    game.enter_level()
    game.open_debug_menu()
    for level in (9, 0, 5, 3):
        game.debug_set_power(level)
        assert game.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_MAIN)
        assert game.read("wPowerUpLevel") == level
