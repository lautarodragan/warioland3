"""Debug menu (SELECT during a level), inputs only.

GOLF is left out: it reloads the room and is known to soft-lock sometimes.
"""

from game import ST_DEBUG_MENU, ST_LEVEL

# Debug menu rows, top to bottom (wDebugMenuCursor)
CURSOR_FORM = 0
CURSOR_POWER = 1
CURSOR_INVNBL = 2

# src/constants/wario_constants.asm
TRANSFORMATION_NONE = 0x00
TRANSFORMATION_FAT_WARIO = 0x04 | 0x80  # | TRANSFORMATIONF_SUPER_SMASH
TRANSFORMATION_INVISIBLE_WARIO = 0x06


def test_debug_menu(game, golden):
    game.new_game_to_overworld()
    game.enter_level()
    assert game.read("wPowerUpLevel") == 0
    assert game.read("wTransformation") == TRANSFORMATION_NONE

    game.open_debug_menu()
    assert game.read("wDebugMenuCursor") == CURSOR_FORM
    golden("debug_menu_open", game.screenshot())

    # FORM: NONE -> HOT -> FLAT -> STRNG -> FAT. Forms apply right away.
    game.menu_press("right", 4)
    assert game.read("wTransformation") == TRANSFORMATION_FAT_WARIO
    golden("debug_menu_fat", game.screenshot())

    game.close_debug_menu()
    assert game.read("wTransformation") == TRANSFORMATION_FAT_WARIO
    golden("debug_fat_wario", game.screenshot())

    # SELECT while transformed turns Wario back to normal instead of
    # opening the menu.
    game.press("select", wait=60)
    assert game.state[0] == ST_LEVEL
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    golden("debug_form_cancelled", game.screenshot())

    game.open_debug_menu()
    assert game.state[0] == ST_DEBUG_MENU

    game.menu_press("down")
    assert game.read("wDebugMenuCursor") == CURSOR_POWER
    game.menu_press("right", 3)
    assert game.read("wPowerUpLevel") == 3
    game.menu_press("left")
    assert game.read("wPowerUpLevel") == 2

    game.menu_press("down")
    assert game.read("wDebugMenuCursor") == CURSOR_INVNBL
    game.menu_press("right")
    assert game.read("wTransformation") == TRANSFORMATION_INVISIBLE_WARIO
    golden("debug_menu_power_invisible", game.screenshot())

    game.close_debug_menu()
    assert game.read("wTransformation") == TRANSFORMATION_INVISIBLE_WARIO
    assert game.read("wPowerUpLevel") == 2
    golden("debug_invisible_wario", game.screenshot())
