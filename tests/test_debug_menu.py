"""Debug menu (SELECT during a level), inputs only.

GOLF is left out: it reloads the room and is known to soft-lock sometimes.
"""

from game import ST_DEBUG_MENU, ST_LEVEL

# Debug menu rows, top to bottom (wDebugMenuCursor)
CURSOR_FORM = 0
CURSOR_POWER = 1
CURSOR_INVNBL = 2
CURSOR_TREASURE = 5

# src/constants/treasure_constants.asm
FOOT_OF_STONE = 0x3F  # N5 The Tidal Coast, red chest

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


def test_debug_menu_treasure(game, golden):
    game.new_game_to_overworld()
    game.enter_level()
    assert not game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 0

    game.open_debug_menu()
    game.menu_press("down", CURSOR_TREASURE)
    assert game.read("wDebugMenuCursor") == CURSOR_TREASURE
    # Starts on this level's grey treasure (N1); N5 RED is 4 levels on.
    assert game.read("wDebugMenuTreasureIdx") == 0
    game.menu_press("right", 4 * 4 + 1)
    golden("debug_menu_treasure_n5_red", game.screenshot())

    game.menu_press("a")
    assert game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 1
    golden("debug_menu_treasure_n5_red_on", game.screenshot())

    # A again takes it back.
    game.menu_press("a")
    assert not game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 0

    # LEFT from the first treasure wraps to the last one (E7 BLU).
    game.menu_press("left", 4 * 4 + 1 + 1)
    assert game.read("wDebugMenuTreasureIdx") == 25 * 4 - 1
