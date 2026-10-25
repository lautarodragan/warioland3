"""Helpers to drive Wario Land 3 inside PyBoy.

Addresses are resolved through the symbol file produced by `make`
(warioland3.sym), so the helpers keep working when code moves around.
"""

from pathlib import Path

from pyboy import PyBoy

ROOT = Path(__file__).resolve().parent.parent
ROM = ROOT / "warioland3.gbc"
SYM = ROOT / "warioland3.sym"

# src/constants/state_constants.asm
ST_TITLE = 0x00
ST_OVERWORLD = 0x01
ST_LEVEL = 0x02
ST_LANGUAGE_SELECTION = 0x0e
ST_DEBUG_MENU = 0x0f

SST_START_MENU = 0x07  # NEW GAME / CONTINUE on the title screen
SST_OVERWORLD_0B = 0x0b  # map is idle and accepts input
SST_LEVEL_UPDATE = 0x03  # UpdateLevel, i.e. normal gameplay

# src/constants/level_constants.asm
THE_STEEP_CANYON_DAY_1 = 0x78


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

    def read(self, symbol):
        return self.pb.memory[self.addr(symbol)]

    def write(self, symbol, value):
        self.pb.memory[self.addr(symbol)] = value

    @property
    def state(self):
        return self.read("wState"), self.read("wSubState")

    # Time and input

    def tick(self, frames=1):
        self.pb.tick(frames, False)
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

    def screenshot(self):
        # Render the current frame; ticks above skip rendering for speed.
        self.pb.tick(1, True)
        self.frame += 1
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

    def enter_level(self, level):
        """Walk to Out of the Woods and enter it, loading `level` instead.

        Only Out of the Woods is unlocked on a new game, so the level index
        is swapped right as InitLevel starts loading it.
        """

        def override_level(_context):
            self.write("wLevel", level)

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
            self.pb.hook_deregister(None, "InitLevel")
        # Let the fade-in finish.
        self.tick(120)
