"""The debug menu's page switches, with the LCD on.

A switch used to turn the LCD off to load the next page, which a Game Boy
Color shows as a white frame (PyBoy doesn't). Now the page on screen is
copied to BG map 1 and shown with the window while the next one is drawn
in BG map 0 under it, and every VRAM, palette and OAM write is in a V-Blank
(see "Switching pages" in book/src/debug-menu.md). These tests check every
frame of each switch, and where the PPU is when the writes happen.
"""

from PIL import ImageChops

from game import (
    SST_DEBUG_LEVEL_PAGE,
    SST_DEBUG_POWER_PAGE,
    SST_DEBUG_TREASURE_PAGE,
    ST_DEBUG_MENU,
)

LCDC = 0xFF40
STAT = 0xFF41
LY = 0xFF44
LCDC_ON = 1 << 7
LY_VBLANK = 144
STAT_MODE_VBLANK = 1

# The menu's routines that write VRAM, the palettes or OAM (the debug menu's,
# and the home ones it calls for that). With the LCD on, each must run in a
# V-Blank: they're called between DebugMenu_StartVRAMWrite and
# DebugMenu_EndVRAMWrite.
VRAM_WRITERS = [
    "DebugMenu_CopyToWindowMap",
    "DebugMenu_LoadPageMap",
    "DebugMenu_GDMA",
    "DebugMenu_DrawItems1",
    "DebugMenu_DrawItems2",
    "DebugMenu_DrawPowerCell",
    "DebugMenu_DrawCell",
    "DebugMenu_DrawTreasureCell",
    "DebugMenu_DrawLevel",
    "ApplyTempPals2ToOBPals",
    "DebugMenu_EndVRAMWrite",  # the end of each write
]

# How many frames a switch may take (DebugMenu_NextPage)
MAX_SWITCH_FRAMES = 14


class PPUWatch:
    """Hooks on the VRAM writers, recording LY and the STAT mode whenever
    one starts with the LCD on, and calls to DisableLCD."""

    def __init__(self, game):
        self.game = game
        self.calls = []
        self.lcd_off = 0
        for name in VRAM_WRITERS:
            game.pb.hook_register(None, name, self._hook, name)
        game.pb.hook_register(None, "DisableLCD", self._lcd_off, None)

    def _hook(self, name):
        mem = self.game.pb.memory
        if mem[LCDC] & LCDC_ON:
            self.calls.append((name, mem[LY], mem[STAT] & 3))

    def _lcd_off(self, _):
        self.lcd_off += 1

    def check(self):
        assert self.calls, "no VRAM writes seen"
        for name, ly, mode in self.calls:
            assert LY_VBLANK <= ly <= 153 and mode == STAT_MODE_VBLANK, (name, ly, mode)
        assert self.lcd_off == 0

    def latest_end(self):
        return max(ly for name, ly, _ in self.calls if name == "DebugMenu_EndVRAMWrite")


def same(a, b):
    return ImageChops.difference(a, b).getbbox() is None


def switch_frames(game):
    """SELECT, and every frame after it until the switch is surely over."""
    game.pb.button("select", 4)
    frames = []
    for _ in range(40):
        game.tick()
        frames.append(game.screenshot())
    return frames


def test_debug_menu_page_switches_have_no_flash(game, golden):
    game.new_game_to_overworld()
    game.enter_level()
    game.open_debug_menu()
    game.menu_press("down")  # a cursor that isn't the map's default
    watch = PPUWatch(game)
    pages = [SST_DEBUG_POWER_PAGE, SST_DEBUG_TREASURE_PAGE, SST_DEBUG_LEVEL_PAGE]
    names = ["power", "treasure", "level"]
    for page, name in zip(pages, names):
        old = game.screenshot()
        frames = switch_frames(game)
        new = frames[-1]
        assert game.state == (ST_DEBUG_MENU, page)
        assert not same(old, new)
        # Every frame is the old page or the new one: no blank, white or
        # half-drawn frame. The old one stays until the new one is ready.
        kinds = "".join("o" if same(f, old) else "n" if same(f, new) else "x" for f in frames)
        assert "x" not in kinds, (name, kinds)
        switched = kinds.index("n")
        assert kinds == "o" * switched + "n" * (len(kinds) - switched), (name, kinds)
        assert switched <= MAX_SWITCH_FRAMES, (name, kinds)
        golden(f"debug_switch_to_{name}", new)
    watch.check()
    # how far into V-Blank the longest write got (153 is its last line)
    assert watch.latest_end() <= 152


def test_debug_menu_vram_writes_in_vblank(game, golden):
    # The other in-menu changes are drawn in V-Blank too: FORM, the cursor,
    # the POWER selection, the TREASURE page's level, treasure and A.
    game.new_game_to_overworld()
    game.enter_level()
    game.open_debug_menu()
    watch = PPUWatch(game)
    game.menu_press("right")
    game.menu_press("down", 3)
    game.menu_press("up", 3)
    game.debug_next_page()
    game.menu_press("right")
    game.menu_press("down")
    game.debug_next_page()
    game.menu_press("right", 2)
    game.menu_press("left")
    game.menu_press("down")
    game.menu_press("a")
    game.menu_press("a")
    watch.check()
