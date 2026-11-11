"""The debug menu's POWER screen (A on the POWER row)."""

from game import ST_DEBUG_MENU, ST_LEVEL, SST_DEBUG_MENU_UPDATE

SST_DEBUG_POWER_SCREEN = 0x02  # src/constants/state_constants.asm
CURSOR_POWER = 1

# src/constants/wario_constants.asm
NO_POWER_UP = 0
GRAB_GLOVE = 4
SUPER_JUMP_SLAM_OVERALLS = 6
HIGH_JUMP_BOOTS = 7
SUPER_GRAB_GLOVES = 9

# src/constants/movement_constants.asm
JUMP_VEL_NORMAL = 2
JUMP_VEL_HIGH_JUMP = 3


def open_power_screen(game):
    game.menu_press("a")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_POWER_SCREEN)


def jump_vel_table(game):
    """Jump with UP held, the High Jump Boots' jump if Wario has them."""
    game.pb.button_press("up")
    game.press("a")
    vel_table = game.read("wJumpVelTable")
    game.pb.button_release("up")
    game.tick(90)  # land
    return vel_table


def test_debug_power_screen(game, golden):
    game.new_game_to_overworld()
    game.enter_level()
    assert jump_vel_table(game) == JUMP_VEL_NORMAL

    game.open_debug_menu()
    game.menu_press("down")
    # LEFT/RIGHT still step through the levels on the main screen; the
    # value is the top power-up's name.
    game.menu_press("right", GRAB_GLOVE)
    assert game.read("wPowerUpLevel") == GRAB_GLOVE
    golden("debug_menu_power_grab", game.screenshot())

    # The selection starts on the current level. Up to the Grab Glove in
    # colour, the rest in grey, each with its treasure.
    open_power_screen(game)
    assert game.read("wDebugPowerCursor") == GRAB_GLOVE
    golden("debug_power_screen", game.screenshot())

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
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_POWER_SCREEN)
    golden("debug_power_screen_boots", game.screenshot())

    # B goes back to the main screen, on POWER.
    game.menu_press("b")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_UPDATE)
    assert game.read("wDebugMenuCursor") == CURSOR_POWER
    golden("debug_menu_power_boots", game.screenshot())

    # So does SELECT.
    open_power_screen(game)
    game.menu_press("select")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_UPDATE)
    assert game.read("wDebugMenuCursor") == CURSOR_POWER

    # Back in the level, with its graphics, and Wario has the boots.
    game.close_debug_menu()
    assert game.state[0] == ST_LEVEL
    golden("debug_power_level", game.screenshot())
    assert jump_vel_table(game) == JUMP_VEL_HIGH_JUMP

    # And loses them when the POWER screen sets a lower level.
    game.open_debug_menu()
    game.menu_press("down")
    open_power_screen(game)
    game.menu_press("up")
    assert game.read("wDebugPowerCursor") == SUPER_JUMP_SLAM_OVERALLS
    game.menu_press("a")
    assert game.read("wPowerUpLevel") == SUPER_JUMP_SLAM_OVERALLS
    game.menu_press("b")
    game.close_debug_menu()
    assert jump_vel_table(game) == JUMP_VEL_NORMAL
