#!/usr/bin/env python3
"""Generate the debug menu's background map: src/data/bgmaps/debug_menu.tilemap
and debug_menu.attrmap (32x32, like the other bgmaps).

    python3 tools/debug_menu_bgmap.py

The frame is made of pause menu pieces, read from the pause menu's own maps:
its gem columns, the checkered top of its title band, and the ornate yellow
frame around its treasure display. Their tiles go into VRAM1 (the debug menu
loads PauseMenuGfx there), so their attributes get the VRAM1 bit; the text is
the font in VRAM0. Fixed text (title, labels) is in the map; debug_menu.asm
draws the cursor, the values and the selected row's ◀ ▶ arrows.

Palettes (DebugMenuPals): 1-4 are the pause menu's, for its pieces; the font
draws its glyphs in colour 0 on colour 3, so each text palette is a text
colour on the colour of what's behind it:
  0: title, yellow on dark blue     5: labels, white on dark red
                                    6: cursor and values, yellow on dark red
"""

from pathlib import Path

BGMAPS = Path(__file__).resolve().parent.parent / "src/data/bgmaps"
WIDTH, HEIGHT = 32, 32
VRAM1 = 1 << 3

# The temple charmap (src/charmaps.asm)
CHARS = {":": 0x00, " ": 0x7E, "▼": 0x5D}
CHARS.update({str(d): 0x30 + d for d in range(10)})
CHARS.update({chr(ord("A") + i): 0x40 + i for i in range(26)})
BLANK = 0x7F  # all colour 3: a flat cell of the text's background

PAL_TITLE, PAL_LABEL, PAL_VALUE = 0, 5, 6

# Rows and columns, shared with debug_menu.asm (DEBUG_MENU_*)
ITEM_ROWS = {"FORM": 5, "POWER": 7, "GOLF": 9, "OWL": 11, "TREASURE": 13}
CURSOR_COL, LABEL_COL, VALUE_COL = 2, 3, 11
TREASURE_VALUE_ROW, TREASURE_VALUE_COL = 14, 5

pause_tiles = (BGMAPS / "pause_menu.tilemap").read_bytes()
pause_attrs = (BGMAPS / "pause_menu.attrmap").read_bytes()


def pause(row, col):
    """The pause menu's map cell at (row, col), for VRAM1."""
    i = row * WIDTH + col
    return pause_tiles[i], pause_attrs[i] | VRAM1


tiles = bytearray([BLANK] * WIDTH * HEIGHT)
attrs = bytearray(WIDTH * HEIGHT)


def put(row, col, cell):
    tiles[row * WIDTH + col], attrs[row * WIDTH + col] = cell


def text(row, col, string, pal):
    for i, char in enumerate(string):
        put(row, col + i, (CHARS[char], pal))


def blank(row, col0, col1, pal):
    for col in range(col0, col1 + 1):
        put(row, col, (BLANK, pal))


for row in range(18):
    # gems, alternating colours like the pause menu's
    put(row, 0, pause(row % 2, 0))
    put(row, 19, pause(row % 2, 19))

    if row == 0:  # checkered top of the title band
        put(row, 1, pause(0, 1))
        for col in range(2, 18):
            put(row, col, pause(0, 2))
        put(row, 18, pause(0, 18))
    elif row in (1, 2):  # title band
        put(row, 1, pause(1, 1))
        blank(row, 2, 17, PAL_TITLE)
        put(row, 18, pause(1, 18))
    else:  # the yellow frame (rows 8-12 of the pause menu), and inside it
        frame_row = 8 if row == 3 else 12 if row == 17 else 9
        put(row, 1, pause(frame_row, 1))
        put(row, 18, pause(frame_row, 18))
        if row in (3, 17):
            for col in range(2, 18):
                put(row, col, pause(frame_row, 2))
        else:
            blank(row, 2, 17, PAL_LABEL)

text(1, 5, "DEBUG MENU", PAL_TITLE)
for label, row in ITEM_ROWS.items():
    put(row, CURSOR_COL, (CHARS[" "], PAL_VALUE))
    text(row, LABEL_COL, label, PAL_LABEL)
    blank(row, VALUE_COL, 17, PAL_VALUE)
blank(TREASURE_VALUE_ROW, TREASURE_VALUE_COL, 17, PAL_VALUE)
for label in ("FORM", "POWER"):  # their ◀, left of the value
    put(ITEM_ROWS[label], VALUE_COL - 1, (BLANK, PAL_VALUE))

(BGMAPS / "debug_menu.tilemap").write_bytes(tiles)
(BGMAPS / "debug_menu.attrmap").write_bytes(attrs)
