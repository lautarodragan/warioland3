#!/usr/bin/env python3
"""Generate the debug menu's background maps (32x32, like the other bgmaps),
one per page, and the page indicator's graphics:

    src/data/bgmaps/debug_level.tilemap/.attrmap     LEVEL
    src/data/bgmaps/debug_power.tilemap/.attrmap     POWER
    src/data/bgmaps/debug_treasure.tilemap/.attrmap  TREASURE
    src/gfx/debug_menu_pages.png                     the page indicator

    python3 tools/debug_menu_bgmap.py

The frame is made of pause menu pieces, read from the pause menu's own maps:
its gem columns, the checkered top of its title band, and the ornate yellow
frame around its treasure display. Their tiles go into VRAM1 (the debug menu
loads PauseMenuGfx there), so their attributes get the VRAM1 bit; the text is
the font in VRAM0. Fixed text (title, labels) is in the map; debug_menu.asm
draws the cursor, the values and the ◀ ▶ arrows.

Palettes (DebugMenuPals): 1-4 are the pause menu's, for its pieces; the font
draws its glyphs in colour 0 on colour 3, so each text palette is a text
colour on the colour of what's behind it:
  0: title, yellow on dark blue; colour 1 is the page indicator's dim words
                                    5: labels, white on dark red
                                    6: cursor and values, yellow on dark red
  7: the POWER and TREASURE pages' icon cells (two tiles loaded over the
     font's "a" and "b", flipped for the four corners): white, with a yellow
     frame around the selected one. The icons themselves are sprites.

Every page has the title band: "DEBUG MENU", and under it the page
indicator, LEVEL POWER TREASURE in a small font (below), the current page in
the title's yellow and the others dim. All three maps show the same tiles
there (font tiles DEBUG_MENU_PAGES_TILE...); debug_menu.asm loads the
current page's version of them, one row of debug_menu_pages.png.

The POWER page lists the ten power-up levels in two columns of five: an
icon cell (2x2) and a two-line name, white, or yellow when selected
(debug_menu.asm redraws the selection). The TREASURE page has a level
(code and name, drawn by debug_menu.asm) and its four treasures in a
column, each a cell and two lines: its colour and OPEN or CLOSED.
"""

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BGMAPS = ROOT / "src/data/bgmaps"
PAGES_PNG = ROOT / "src/gfx/debug_menu_pages.png"
WIDTH, HEIGHT = 32, 32
VRAM1 = 1 << 3

# The temple charmap (src/charmaps.asm)
CHARS = {":": 0x00, " ": 0x7E, "▼": 0x5D}
CHARS.update({str(d): 0x30 + d for d in range(10)})
CHARS.update({chr(ord("A") + i): 0x40 + i for i in range(26)})
BLANK = 0x7F  # all colour 3: a flat cell of the text's background

PAL_TITLE, PAL_LABEL, PAL_VALUE, PAL_CELL = 0, 5, 6, 7
X_FLIP, Y_FLIP = 1 << 5, 1 << 6

# Inside the frame: rows 4-16, columns 2-17
INSIDE_LEFT, INSIDE_RIGHT = 2, 17

# LEVEL, shared with debug_menu.asm (DEBUG_MENU_*): the four rows, two map
# rows apart, centred in the frame (three blank rows above and below)
ITEM_ROWS = {"FORM": 7, "GOLF": 9, "OWL": 11, "BARREL": 13}
CURSOR_COL, LABEL_COL, VALUE_COL = 2, 3, 11

# The icon cells, POWER and TREASURE
LEFT_ARROW, RIGHT_ARROW = 0x5E, 0x5F  # DEBUG_MENU_*_ARROW, loaded over the font
CELL = 0x60  # over the font's "a"; the selected one (0x61) is over "b"
NAME_WIDTH = 6  # DEBUG_POWER_NAME_WIDTH: the two lines right of a cell

# POWER, shared with debug_menu.asm (DEBUG_POWER_*)
POWER_TOP_ROW, POWER_ICON_COL, POWER_COL_WIDTH, POWER_ROWS = 5, 2, 8, 5
# Two lines of up to 6 characters each, in power-up level order
POWER_NAMES = [
    ("NONE", ""),
    ("LEAD", "OVRALL"),  # Lead Overalls
    ("SWIM", "FLIPPR"),  # Swimming Flippers
    ("SMASH", "HELMET"),  # Head Smash Helmet
    ("GRAB", "GLOVE"),  # Grab Glove
    ("GARLIC", ""),  # Garlic
    ("SLAM", "OVRALL"),  # Super Jump Slam Overalls
    ("JUMP", "BOOTS"),  # High Jump Boots
    ("FROG", "GLOVES"),  # Prince Frog's Gloves
    ("SUPER", "GRAB"),  # Super Grab Gloves
]

# TREASURE, shared with debug_menu.asm (DEBUG_TREASURE_*): the level code
# between ◀ ▶ (centred, the arrows always shown: LEFT/RIGHT change the
# level), its name on the two rows below (debug_menu.asm centres each line),
# a blank row, and the four treasures, a cell and two lines each
TREASURE_CODE_ROW, TREASURE_CODE_COL = 4, 9
TREASURE_NAME_ROW = 5
TREASURE_TOP_ROW, TREASURE_ICON_COL = 8, 6
TREASURE_COLOURS = ["GREY", "RED", "GREEN", "BLUE"]

# The page indicator: font tiles DEBUG_MENU_PAGES_TILE on (over the font's
# "c", "d"..., unused by the menu), row 2 of the title band
PAGES = ["LEVEL", "POWER", "TREASURE"]
PAGES_ROW = 2
PAGES_TILE = 0x62
PAGES_TOP = 1  # pixel row of the letters in their tiles
PAGES_GAP = 11  # pixels between words

# The small font: 5 pixels high, 1-pixel strokes like the menu font, only
# the letters the page names need. Letters are 3 pixels wide (W needs
# more) with a pixel between them, so they share tiles.
SMALL_FONT = {
    "A": [".#.", "#.#", "###", "#.#", "#.#"],
    "E": ["###", "#..", "##.", "#..", "###"],
    "L": ["#..", "#..", "#..", "#..", "###"],
    "O": [".#.", "#.#", "#.#", "#.#", ".#."],
    "P": ["##.", "#.#", "##.", "#..", "#.."],
    "R": ["##.", "#.#", "##.", "#.#", "#.#"],
    "S": [".##", "#..", ".#.", "..#", "##."],
    "T": ["###", ".#.", ".#.", ".#.", ".#."],
    "U": ["#.#", "#.#", "#.#", "#.#", "###"],
    "V": ["#.#", "#.#", "#.#", "#.#", ".#."],
    "W": ["#...#", "#...#", "#.#.#", "##.##", "#...#"],
}
# colour indices (the PNG's greys: 0 is white, 3 black)
INK_CURRENT, INK_DIM, PAPER = 0, 1, 3

pause_tiles = (BGMAPS / "pause_menu.tilemap").read_bytes()
pause_attrs = (BGMAPS / "pause_menu.attrmap").read_bytes()


def pause(row, col):
    """The pause menu's map cell at (row, col), for VRAM1."""
    i = row * WIDTH + col
    return pause_tiles[i], pause_attrs[i] | VRAM1


def new_map():
    global tiles, attrs
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


def word_width(word):
    return sum(len(SMALL_FONT[c][0]) for c in word) + len(word) - 1


def pages_strip():
    """The page indicator: for each page, a row of pixels (lists of colour
    indices) across the title band, and the first and last tile columns
    with letters in them."""
    band = (INSIDE_RIGHT - INSIDE_LEFT + 1) * 8
    width = sum(word_width(w) for w in PAGES) + PAGES_GAP * (len(PAGES) - 1)
    left = (band - width) // 2
    strips = []
    for current in range(len(PAGES)):
        pixels = [[PAPER] * band for _ in range(8)]
        x = left
        for i, word in enumerate(PAGES):
            ink = INK_CURRENT if i == current else INK_DIM
            for char in word:
                glyph = SMALL_FONT[char]
                for y, line in enumerate(glyph):
                    for dx, bit in enumerate(line):
                        if bit == "#":
                            pixels[PAGES_TOP + y][x + dx] = ink
                x += len(glyph[0]) + 1
            x += PAGES_GAP - 1
        strips.append(pixels)
    first, last = left // 8, (left + width - 1) // 8
    return strips, first, last


def save_pages_png(strips, first, last):
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import png

    grey = {0: 255, 1: 170, 2: 85, 3: 0}
    rows = []
    for pixels in strips:
        for line in pixels:
            rows.append([grey[c] for c in line[first * 8 : (last + 1) * 8]])
    with open(PAGES_PNG, "wb") as f:
        png.Writer((last - first + 1) * 8, len(rows), greyscale=True).write(f, rows)


def frame(first, last):
    """The pause menu style frame the pages share, with the title band."""
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
    for i in range(last - first + 1):
        put(PAGES_ROW, INSIDE_LEFT + first + i, (PAGES_TILE + i, PAL_TITLE))


def cell(row, col, lines):
    """An icon cell at (row, col) and two lines of text right of it."""
    put(row, col, (CELL, PAL_CELL))
    put(row, col + 1, (CELL, PAL_CELL | X_FLIP))
    put(row + 1, col, (CELL, PAL_CELL | Y_FLIP))
    put(row + 1, col + 1, (CELL, PAL_CELL | X_FLIP | Y_FLIP))
    for line, string in enumerate(lines):
        assert len(string) <= NAME_WIDTH, string
        text(row + line, col + 2, string, PAL_LABEL)


def save(name):
    (BGMAPS / f"{name}.tilemap").write_bytes(tiles)
    (BGMAPS / f"{name}.attrmap").write_bytes(attrs)


strips, first, last = pages_strip()
save_pages_png(strips, first, last)
print(f"page indicator: {last - first + 1} tiles (DEBUG_MENU_PAGES_TILES)")

# LEVEL
new_map()
frame(first, last)
for label, row in ITEM_ROWS.items():
    put(row, CURSOR_COL, (CHARS[" "], PAL_VALUE))
    text(row, LABEL_COL, label, PAL_LABEL)
    blank(row, VALUE_COL, 17, PAL_VALUE)
put(ITEM_ROWS["FORM"], VALUE_COL - 1, (BLANK, PAL_VALUE))  # its ◀
save("debug_level")

# POWER
new_map()
frame(first, last)
for i, lines in enumerate(POWER_NAMES):
    row = POWER_TOP_ROW + (i % POWER_ROWS) * 2
    col = POWER_ICON_COL + (i // POWER_ROWS) * POWER_COL_WIDTH
    cell(row, col, lines)
save("debug_power")

# TREASURE
new_map()
frame(first, last)
blank(TREASURE_CODE_ROW, TREASURE_CODE_COL - 2, TREASURE_CODE_COL + 3, PAL_VALUE)
put(TREASURE_CODE_ROW, TREASURE_CODE_COL - 2, (LEFT_ARROW, PAL_VALUE))
put(TREASURE_CODE_ROW, TREASURE_CODE_COL + 3, (RIGHT_ARROW, PAL_VALUE))
for i, colour in enumerate(TREASURE_COLOURS):
    cell(TREASURE_TOP_ROW + i * 2, TREASURE_ICON_COL, (colour, ""))
save("debug_treasure")
