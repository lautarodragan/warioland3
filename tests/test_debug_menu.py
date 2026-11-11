"""Debug menu (SELECT during a level), inputs only.

GOLF has its own tests, in test_debug_menu_golf.py, and the POWER page in
test_debug_menu_power.py.
"""

from game import (
    SST_DEBUG_MENU_MAIN,
    SST_DEBUG_POWER_PAGE,
    SST_DEBUG_TREASURE_PAGE,
    ST_DEBUG_MENU,
    ST_LEVEL,
    SST_LEVEL_UPDATE,
)

# MAIN's rows, top to bottom (wDebugMenuCursor)
CURSOR_FORM = 0
CURSOR_GOLF = 1
CURSOR_OWL = 2
CURSOR_BARREL = 3
MUSIC_PAUSE_MENU = 0x25
OWL_STATUS_SPAWNED = 1

THE_TEMPLE = 0xC8  # src/constants/level_constants.asm
LCDC_WIN_ON = 1 << 5  # hardware.inc

# src/constants/treasure_constants.asm, the TREASURE page's picks
# (wDebugMenuTreasureIdx: level * 4 + colour)
FOOT_OF_STONE = 0x3F  # N5 The Tidal Coast, red chest
N5_RED = 4 * 4 + 1
N5_BLUE = 4 * 4 + 3
E3_BLUE = 20 * 4 + 3  # Castle of Illusions, a name on two lines
E7_BLUE = 24 * 4 + 3
ANIMATED_TILES = range(0x9700, 0x9780)  # VRAM1, restarted when the menu closes

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

    # Invisibility is a form too, the last one: LEFT from NONE wraps to it.
    game.menu_press("left")
    assert game.read("wTransformation") == TRANSFORMATION_INVISIBLE_WARIO
    golden("debug_menu_invisible", game.screenshot())

    game.close_debug_menu()
    assert game.read("wTransformation") == TRANSFORMATION_INVISIBLE_WARIO
    golden("debug_invisible_wario", game.screenshot())


def test_debug_menu_pages(game, golden):
    # START cycles MAIN -> POWER -> TREASURE -> MAIN, each page keeping its
    # selection while the menu is open; the menu opens on MAIN.
    game.new_game_to_overworld()
    game.enter_level()
    game.open_debug_menu()
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_MAIN)
    game.menu_press("down", CURSOR_OWL)

    game.menu_press("start")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_POWER_PAGE)
    assert game.read("wDebugPowerCursor") == 0  # the current level
    golden("debug_page_power", game.screenshot())
    game.menu_press("right")  # moves, doesn't apply
    game.menu_press("down", 2)

    game.menu_press("start")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_TREASURE_PAGE)
    assert game.read("wDebugMenuTreasureIdx") == 0  # this level's grey
    golden("debug_page_treasure", game.screenshot())
    game.menu_press("down")

    game.menu_press("start")
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_MAIN)
    assert game.read("wDebugMenuCursor") == CURSOR_OWL
    golden("debug_page_main", game.screenshot())

    game.menu_press("start")
    assert game.read("wDebugPowerCursor") == 7
    assert game.read("wPowerUpLevel") == 0
    game.menu_press("start")
    assert game.read("wDebugMenuTreasureIdx") == 1

    # Closing from a page and opening again: MAIN, cursor on FORM.
    game.close_debug_menu()
    game.open_debug_menu()
    assert game.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_MAIN)
    assert game.read("wDebugMenuCursor") == CURSOR_FORM


def vram(game):
    """VRAM, both banks, without the room's animated tiles."""
    out = []
    for bank in (0, 1):
        data = bytes(game.pb.memory[bank, 0x8000:0x9FFF]) + bytes([game.pb.memory[bank, 0x9FFF]])
        if bank == 1:
            data = bytes(0 if 0x8000 + i in ANIMATED_TILES else b for i, b in enumerate(data))
        out.append(data)
    return out


def temp_pals(game):
    """wTempPals1 and wTempPals2: the 8 BG and 8 OB palettes."""
    start = game.addr("wTempPals1")
    return bytes(game.pb.memory[start : start + 16 * 8])


def test_debug_menu_closes_from_every_page(game, golden):
    # B and SELECT close the menu from any page, and the level gets its
    # graphics back: VRAM as it was (but for the animated tiles, which
    # start again), and the palettes.
    game.new_game_to_overworld()
    game.enter_level()
    for page in (SST_DEBUG_MENU_MAIN, SST_DEBUG_POWER_PAGE, SST_DEBUG_TREASURE_PAGE):
        for button in ("b", "select"):
            before = vram(game)
            ob_pals = temp_pals(game)
            game.open_debug_menu()
            game.debug_menu_page(page)
            game.press(button)
            game.wait_until(
                lambda: game.state == (ST_LEVEL, SST_LEVEL_UPDATE),
                what=f"level after {button} on page {page}",
            )
            assert vram(game) == before, (page, button)
            assert temp_pals(game) == ob_pals, (page, button)
            game.tick(60)
    golden("debug_menu_closed_from_treasure", game.screenshot())


def test_debug_menu_treasure(game, golden):
    game.new_game_to_overworld()
    game.enter_level()
    assert not game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 0

    game.open_debug_menu()
    game.debug_menu_page(SST_DEBUG_TREASURE_PAGE)
    # Starts on this level's grey treasure (N1). RIGHT goes to the next
    # level, DOWN to the next treasure.
    assert game.read("wDebugMenuTreasureIdx") == 0
    game.menu_press("right", 4)
    game.menu_press("down")
    assert game.read("wDebugMenuTreasureIdx") == N5_RED
    golden("debug_treasure_n5_red", game.screenshot())

    game.menu_press("a")
    assert game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 1
    # A again takes it back, and again gives it.
    game.menu_press("a")
    assert not game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 0
    game.menu_press("a")

    # Two of N5's four: in their colours, the others in grey.
    game.menu_press("down", 2)
    assert game.read("wDebugMenuTreasureIdx") == N5_BLUE
    game.menu_press("down")  # no wrapping
    assert game.read("wDebugMenuTreasureIdx") == N5_BLUE
    game.menu_press("a")
    assert game.num_collected_treasures() == 2
    golden("debug_treasure_n5_mixed", game.screenshot())

    # LEFT from N1 wraps to E7, keeping the colour.
    game.menu_press("left", 5)
    assert game.read("wDebugMenuTreasureIdx") == E7_BLUE
    game.menu_press("left", 4)
    assert game.read("wDebugMenuTreasureIdx") == E3_BLUE
    golden("debug_treasure_e3", game.screenshot())
    game.menu_press("right", 5)
    assert game.read("wDebugMenuTreasureIdx") == 3  # N1 BLU

    # The treasures stay with the menu closed, and the level is intact.
    game.close_debug_menu()
    assert game.treasure_collected(FOOT_OF_STONE)
    assert game.num_collected_treasures() == 2
    golden("debug_treasure_closed", game.screenshot())


def test_debug_menu_controls(game, golden):
    # The pause menu's music while it's open; OWL and GOLF apply with A
    # (LEFT/RIGHT do nothing there); SELECT closes it, like B.
    game.new_game_to_overworld()
    game.enter_level()
    music = []
    game.pb.hook_register(
        None,
        "PlayNewMusic_SetNoise",
        lambda _: music.append(game.pb.register_file.B << 8 | game.pb.register_file.C),
        None,
    )
    game.open_debug_menu()
    assert music == [MUSIC_PAUSE_MENU]

    # FORM shows ◀ ▶ around the value while selected, and only FORM has
    # them.
    game.menu_press("down", CURSOR_GOLF)
    golden("debug_menu_golf_selected", game.screenshot())

    game.menu_press("down", CURSOR_OWL - CURSOR_GOLF)
    game.menu_press("right")
    game.menu_press("left")
    assert game.read("wDebugMenuOwlStatus") == 0
    game.menu_press("up", CURSOR_OWL - CURSOR_GOLF)
    game.menu_press("right")
    assert not game.read("wIsMinigameCleared")
    game.menu_press("down", CURSOR_OWL - CURSOR_GOLF)
    game.menu_press("a")
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED

    # Pages don't change the music.
    game.menu_press("start", 3)
    assert music == [MUSIC_PAUSE_MENU]

    game.press("select")
    game.wait_until(lambda: game.state[0] == ST_LEVEL, what="level after SELECT")
    game.tick(60)
    assert game.state[0] == ST_LEVEL
    assert music[-1] != MUSIC_PAUSE_MENU  # the level's music again


def test_debug_menu_keeps_the_temple_window(game, golden):
    # The Temple's battle draws the arena floor with the window, which the
    # level turns on in rLCDC. The menu used to close with LCDC_DEFAULT
    # (window off): no floor, and the view looked shifted.
    game.new_game_to_overworld()
    game.enter_level(THE_TEMPLE)
    game.tick(120)
    lcdc = game.pb.memory[0xFF40]
    assert lcdc & LCDC_WIN_ON
    game.open_debug_menu()
    game.close_debug_menu()
    game.tick(30)
    assert game.pb.memory[0xFF40] == lcdc
    golden("debug_menu_closed_in_the_temple", game.screenshot())
