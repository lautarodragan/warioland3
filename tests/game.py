"""Helpers to drive Wario Land 3 inside PyBoy.

Addresses are resolved through the symbol file produced by `make`
(warioland3.sym), so the helpers keep working when code moves around.
"""

import io
from pathlib import Path

from pyboy import PyBoy

ROOT = Path(__file__).resolve().parent.parent
ROM = ROOT / "warioland3.gbc"
SYM = ROOT / "warioland3.sym"

# src/constants/state_constants.asm
ST_TITLE = 0x00
ST_OVERWORLD = 0x01
ST_LEVEL = 0x02
ST_CLEAR = 0x03
ST_PAUSE_MENU = 0x04
ST_LANGUAGE_SELECTION = 0x0e
ST_DEBUG_MENU = 0x0f

SST_START_MENU = 0x07  # NEW GAME / CONTINUE on the title screen
SST_OVERWORLD_0B = 0x0b  # map is idle and accepts input
SST_LEVEL_UPDATE = 0x03  # UpdateLevel, i.e. normal gameplay
SST_DEBUG_MENU_UPDATE = 0x01  # UpdateDebugMenu, accepting input

# src/constants/object_constants.asm
OBJFLAG_ACTIVE = 1 << 0
OBJFLAG_TRANSIENT = 1 << 6
OWL = 0x29

# src/constants/level_constants.asm
OUT_OF_THE_WOODS_DAY_1 = 0x00
THE_STEEP_CANYON_DAY_1 = 0x78
THE_COLOSSAL_HOLE_DAY_1 = 0xa8
# Map levels (wOWLevel): LEVEL_* constants, (first variant / 8) + 1
LEVEL_OUT_OF_THE_WOODS = 1
LEVEL_THE_STEEP_CANYON = 16
LEVEL_THE_COLOSSAL_HOLE = 22

# src/constants/menu_constants.asm
PAUSEMENU_SAVE = 1
PAUSEMENU_TO_MAP = 3


class TimeoutError(AssertionError):
    pass


class Game:
    def __init__(self):
        self.pb = PyBoy(
            str(ROM),
            symbols=str(SYM),
            window="null",
            sound_emulated=False,
        )
        self.pb.set_emulation_speed(0)
        self.frame = 0

    def close(self):
        # Don't write a .ram save next to the ROM.
        self.pb.stop(save=False)

    # Memory

    def addr(self, symbol):
        _bank, addr = self.pb.symbol_lookup(symbol)
        return addr

    def _location(self, symbol):
        bank, addr = self.pb.symbol_lookup(symbol)
        if 0xD000 <= addr < 0xE000:
            # Switchable WRAM: go through the symbol's bank rather than
            # whichever one happens to be mapped right now.
            return bank, addr
        return addr

    def read(self, symbol):
        return self.pb.memory[self._location(symbol)]

    def write(self, symbol, value):
        self.pb.memory[self._location(symbol)] = value

    @property
    def state(self):
        return self.read("wState"), self.read("wSubState")

    # Time and input

    def tick(self, frames=1):
        # Rendering only draws the last frame, so it's cheap, and it keeps
        # the screen current: screenshot() then never has to advance time,
        # which would throw recorded routes off.
        self.pb.tick(frames, True)
        self.frame += frames

    def press(self, button, frames=4, wait=0):
        """Hold `button` for `frames` frames, then idle for `wait` frames."""
        self.pb.button(button, frames)
        self.tick(frames + wait)

    def wait_until(self, cond, timeout=60 * 60, what="condition"):
        for _ in range(timeout):
            if cond():
                return
            self.tick()
        raise TimeoutError(f"timed out waiting for {what}; state={self.state}")

    def press_until(self, button, cond, interval=30, timeout=60 * 120, what="condition"):
        """Keep tapping `button` every `interval` frames until `cond()` holds."""
        elapsed = 0
        while not cond():
            if elapsed >= timeout:
                raise TimeoutError(f"timed out waiting for {what}; state={self.state}")
            self.pb.button(button, 4)
            for _ in range(interval):
                self.tick()
                elapsed += 1
                if cond():
                    return

    def play(self, steps, on_frame=None):
        """Replay (buttons, frames) steps, e.g. from tests/routes/.

        Buttons are released and one idle frame runs after each step, so
        every step starts from a clean joypad state. `on_frame`, if given,
        is called after every frame.
        """
        for buttons, frames in steps:
            buttons = buttons.split("+") if buttons else []
            for button in buttons:
                self.pb.button_press(button)
            self._tick_watched(frames, on_frame)
            for button in buttons:
                self.pb.button_release(button)
            self._tick_watched(1, on_frame)

    def _tick_watched(self, frames, on_frame):
        if on_frame is None:
            self.tick(frames)
            return
        for _ in range(frames):
            self.tick()
            on_frame()

    def wario_pos(self):
        """Wario's (y, x) in level pixels; y is his feet."""
        mem, addr = self.pb.memory, self.addr
        y = mem[addr("wWarioYPos")] << 8 | mem[addr("wWarioYPos") + 1]
        x = mem[addr("wWarioXPos")] << 8 | mem[addr("wWarioXPos") + 1]
        return y, x

    def wario_block(self):
        y, x = self.wario_pos()
        return y // 16, x // 16

    def block_func(self, row, col):
        """The block function (e.g. "BlockFunc_Solid") of a cell, read from
        the game's memory: the level's block map in SRAM, decoded with the
        current room's block function table. Only cells of the current room
        are meaningful, but those are always right, unlike the disassembly's
        level data read by tools/level_map.py, which gets some rooms wrong
        (The Above the Clouds' start room, for one)."""
        mem = self.pb.memory
        bank, addr = self.pb.symbol_lookup("sLevelBlockObjectMap")
        # Rows are 160 blocks, each in its own 256-byte page; 32 per bank.
        block = mem[bank + row // 32, addr + (row % 32) * 256 + col] & 0x7F
        table = self.addr("wBlockFunctionTable") + 2 * block
        return self._block_func_names()[mem[table] | mem[table + 1] << 8]

    def _block_func_names(self):
        if not hasattr(self, "_block_funcs"):
            self._block_funcs = {}
            for line in SYM.read_text().splitlines():
                addr, _, name = line.partition(" ")
                if name.startswith("BlockFunc_"):
                    self._block_funcs[int(addr.split(":")[1], 16)] = name
        return self._block_funcs

    def snapshot(self):
        """The whole emulator state, to restore() and try something else."""
        f = io.BytesIO()
        self.pb.save_state(f)
        return f.getvalue()

    def restore(self, snapshot):
        self.pb.load_state(io.BytesIO(snapshot))

    def screenshot(self):
        return self.pb.screen.image.convert("RGB")

    # Game flow

    def new_game_to_overworld(self):
        """Title screen -> NEW GAME -> English -> intro -> idle on the map."""
        self.press_until(
            "start",
            lambda: self.state == (ST_TITLE, SST_START_MENU),
            what="title menu",
        )
        self.tick(30)
        self.press_until(
            "a",
            lambda: self.read("wState") == ST_LANGUAGE_SELECTION,
            what="language selection",
        )
        self.press_until(
            "a", lambda: self.read("wState") == ST_OVERWORLD, what="overworld"
        )
        # Advance through the intro cutscene and the hidden figure's
        # dialogue. The game autosaves and then leaves the map idle.
        self.press_until(
            "a",
            lambda: self.state == (ST_OVERWORLD, SST_OVERWORLD_0B),
            what="idle overworld",
        )
        self.tick(60)

    def enter_level(self, level=OUT_OF_THE_WOODS_DAY_1):
        """Walk to Out of the Woods and enter it.

        Only Out of the Woods is unlocked on a new game, so for any other
        `level` the level index is swapped right as InitLevel starts loading
        it. Entering Out of the Woods itself writes no RAM.
        """

        def override_level(_context):
            self.write("wLevel", level)

        override = level != OUT_OF_THE_WOODS_DAY_1
        if override:
            self.pb.hook_register(None, "InitLevel", override_level, None)
        try:
            self.press("left", wait=120)
            self.press("a")
            self.wait_until(
                lambda: self.read("wState") == ST_LEVEL, what="level state"
            )
            self.wait_until(
                lambda: self.read("wLevel") == level
                and self.state == (ST_LEVEL, SST_LEVEL_UPDATE),
                what="level to finish loading",
            )
        finally:
            if override:
                self.pb.hook_deregister(None, "InitLevel")
        # Let the fade-in finish.
        self.tick(120)

    def enter_level_from_map(self, map_level):
        """Enter a level from the map, choosing it as the map level.

        Unlike enter_level, SelectLevel still runs on it, so the level's
        variant follows the treasures collected, as in normal play.
        """

        def override_map_level(_context):
            self.write("wOWLevel", map_level)

        self.pb.hook_register(None, "SelectLevel", override_map_level, None)
        try:
            # Right after returning to the map, the first A doesn't enter.
            self.press_until(
                "a", lambda: self.read("wState") == ST_LEVEL, interval=60, what="level"
            )
            self.wait_until(
                lambda: self.state == (ST_LEVEL, SST_LEVEL_UPDATE),
                what="level to finish loading",
            )
        finally:
            self.pb.hook_deregister(None, "SelectLevel")
        self.tick(120)

    def return_to_map(self):
        """Leave the level from the pause menu's TO MAP option."""
        self.press("start")
        self.wait_until(lambda: self.state[0] == ST_PAUSE_MENU, what="pause menu")
        self.tick(60)
        self.press_until(
            "right",
            lambda: self.read("wPauseMenuSelection") & 0x0F == PAUSEMENU_TO_MAP,
            what="TO MAP",
        )
        self.press_until(
            "a",
            lambda: self.state == (ST_OVERWORLD, SST_OVERWORLD_0B),
            what="map after leaving the level",
        )
        self.tick(60)

    def save_and_continue(self):
        """Save from the pause menu (which resets the game), then CONTINUE
        from the title screen, back into the level where it was saved."""
        self.press("start")
        self.wait_until(lambda: self.state[0] == ST_PAUSE_MENU, what="pause menu")
        self.tick(60)
        self.press_until(
            "right",
            lambda: self.read("wPauseMenuSelection") & 0x0F == PAUSEMENU_SAVE,
            what="SAVE",
        )
        self.press("a")
        self.wait_until(lambda: self.state[0] == ST_TITLE, timeout=60 * 30, what="reset")
        self.press_until(
            "start",
            lambda: self.state == (ST_TITLE, SST_START_MENU),
            what="title menu",
        )
        self.tick(30)
        self.press_until("a", lambda: self.state[0] == ST_LEVEL, what="level")
        self.wait_until(
            lambda: self.state == (ST_LEVEL, SST_LEVEL_UPDATE),
            what="level to finish loading",
        )
        self.tick(120)

    def open_debug_menu(self):
        self.press("select")
        self.wait_until(
            lambda: self.state == (ST_DEBUG_MENU, SST_DEBUG_MENU_UPDATE),
            what="debug menu",
        )
        self.tick(30)

    def close_debug_menu(self):
        self.press("b")
        self.wait_until(
            lambda: self.state == (ST_LEVEL, SST_LEVEL_UPDATE),
            what="level after debug menu",
        )
        self.tick(60)

    def menu_press(self, button, times=1):
        """Tap a button in a menu, giving each tap time to register."""
        for _ in range(times):
            self.press(button, wait=10)

    def treasure_collected(self, treasure):
        bank, addr = self.pb.symbol_lookup("wTreasuresCollected")
        return bool(self.pb.memory[bank, addr + treasure // 8] & (1 << (treasure % 8)))

    def num_collected_treasures(self):
        # BCD: byte 1 lo nybble = hundreds, byte 2 = tens and ones
        addr = self.addr("wNumCollectedTreasures")
        hundreds = self.pb.memory[addr] & 0x0F
        tens_ones = self.pb.memory[addr + 1]
        return hundreds * 100 + (tens_ones >> 4) * 10 + (tens_ones & 0x0F)

    def objects(self):
        """Active level objects, as (slot, flags, id) tuples."""
        out = []
        for n in range(1, 9):
            flags = self.read(f"wObj{n}Flags")
            if flags & OBJFLAG_ACTIVE:
                out.append((n, flags, self.read(f"wObj{n}Id")))
        return out
