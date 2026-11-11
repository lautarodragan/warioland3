#!/usr/bin/env python3
"""Generate the debug menu's background maps (32x32, like the other bgmaps),
one per page, and the page indicator's graphics:

    src/data/bgmaps/debug_level.tilemap/.attrmap     LEVEL
    src/data/bgmaps/debug_power.tilemap/.attrmap     POWER
    src/data/bgmaps/debug_treasure.tilemap/.attrmap  TREASURE
    src/gfx/debug_menu_pages.png                     the page indicator
    src/gfx/debug_menu_code.png                      the plain frame and TREASURE's level code
    src/gfx/debug_menu_power.png                     POWER's icons and cursor

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
(code and name, drawn by debug_menu.asm) and its four treasures in a 2x2
grid, each a cell with its chest (a sprite) right of it.

The TREASURE page's frame is plain, without the yellow band and its orange
triangles (only its lines, then the inside's dark red), and its level code (◀ N1 ▶) is drawn 2-3 pixels
higher than the font's rows, so that it's centred between that edge and the
level's name. Those tiles are in debug_menu_code.png, drawn in the frame's
palette (its yellow is the values' yellow, its colour 2 the inside's dark
red): the top edge and corner, the side, the bottom edge and corner, ◀ and
▶ (top and bottom halves), the box behind a chest (its left half), then the
top and bottom halves of N, W, S and E and of 1 to 7, for debug_menu.asm
to load the picked level's (DEBUG_TREASURE_CODE_*).
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
CELL = 0x60  # over the font's "a"
WHITE = 0x61  # over "b": all colour 0, behind POWER's icons
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
# and the four treasures in a 2x2 grid (grey red / green blue), each an icon
# cell with its chest right of it (a sprite, debug_menu.asm)
TREASURE_CODE_ROW, TREASURE_CODE_COL = 4, 9
TREASURE_NAME_ROW = 5
TREASURE_GRID_ROW, TREASURE_GRID_COL = 9, 5  # the top left cell
TREASURE_GRID_DROW, TREASURE_GRID_DCOL = 4, 6

# TREASURE's top edge and level code (debug_menu_code.png), font tiles from
# CODE_TILE on (over the font's "o", "p"..., unused by the menu), in the
# frame's palette (DEBUG_TREASURE_* in debug_menu.asm)
CODE_PNG = ROOT / "src/gfx/debug_menu_code.png"
PAL_FRAME = 4
CODE_TILE = 0x6E
EDGE, CORNER, SIDE, BOTTOM, BOTTOM_CORNER = range(CODE_TILE, CODE_TILE + 5)
ARROW_TILES = CODE_TILE + 5  # ◀ top, bottom, ▶ top, bottom
CHEST_BOX = CODE_TILE + 9  # the left half's top and bottom, mirrored for the right
CODE_TILES = CODE_TILE + 11  # the letter's top and bottom, the digit's
assert CODE_TILES + 4 <= CHARS[" "]
FRAME_YELLOW, FRAME_DARK_RED, FRAME_BLACK = 0, 2, 3
# the glyph rows the code ends up on, counted from the top of its row: the
# letters' (font rows 0-6) and the arrows' and digits' (rows 1-7) at -2 to 4
LETTER_SHIFT, DIGIT_SHIFT = 2, 3
CODE_LETTERS = "NWSE"
# DebugMenuArrowTiles' ◀ and ▶ (0 is the glyph)
ARROWS = [
    ["33333333", "33330333", "33300333", "33000333", "30000333", "33000333", "33300333", "33330333"],
    ["33333333", "30333333", "30033333", "30003333", "30000333", "30003333", "30033333", "30333333"],
]

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


def read_tiles(path):
    """A 2bpp-style greyscale PNG as tiles: lists of 8 rows of colour
    indices (white is 0)."""
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import png

    width, height, rows, info = png.Reader(filename=str(path)).asDirect()
    top = (1 << info["bitdepth"]) - 1
    pixels = [[(top - v) * 3 // top for v in row] for row in rows]
    return [
        [pixels[ty * 8 + y][tx * 8 : tx * 8 + 8] for y in range(8)]
        for ty in range(height // 8)
        for tx in range(width // 8)
    ]


def code_tiles():
    """debug_menu_code.png's tiles, in order (see the docstring)."""
    pause_gfx = read_tiles(ROOT / "src/gfx/pause/pause_menu.png")
    font = read_tiles(ROOT / "src/gfx/font.png")
    top_edge = pause_gfx[0x100 + pause(8, 2)[0]]
    corner = pause_gfx[0x100 + pause(8, 1)[0]]
    side = pause_gfx[0x100 + pause(9, 1)[0]]
    bottom = pause_gfx[0x100 + pause(12, 2)[0]]
    bottom_corner = pause_gfx[0x100 + pause(12, 1)[0]]
    fill = [FRAME_DARK_RED] * 8
    # each piece's lines (the outer half), then the inside instead of the band
    side = [row[:4] + [FRAME_DARK_RED] * 4 for row in side]
    edge = top_edge[:4] + [fill] * 4
    corner = corner[:4] + [side[0]] * 4
    bottom = [fill] * 4 + bottom[4:]
    bottom_corner = [side[0]] * 4 + bottom_corner[4:]

    def halves(glyph, shift):
        """glyph (font colours: 0 on 3) shift pixels up, as a top half (under
        the edge's lines) and a bottom half"""
        top = edge[:3] + [fill] * 5
        bottom = [fill] * 8
        out = [list(row) for row in top + bottom]
        for y, row in enumerate(glyph):
            for x, c in enumerate(row):
                if c == 0:
                    out[8 + y - shift][x] = FRAME_YELLOW
        return [out[:8], out[8:]]

    tiles = [edge, corner, side, bottom, bottom_corner]
    arrows = []
    for arrow in ARROWS:
        arrows += halves([[int(c) for c in row] for row in arrow], DIGIT_SHIFT)
    tiles += arrows

    # The box behind each chest, as in the pause menu (its tiles $6e, $f9,
    # $0c under the chests' sprites): black, a pixel in from the 16x16 cell,
    # with four yellow dots between the lid and the body. Left half; the map
    # mirrors it.
    box = [[FRAME_DARK_RED] * 8 for _ in range(16)]
    for y in range(1, 15):
        for x in range(1, 8):
            box[y][x] = FRAME_BLACK
    box[4][6] = box[6][4] = FRAME_YELLOW
    tiles += [box[:8], box[8:]]
    for letter in CODE_LETTERS:
        tiles += halves(font[0x100 + CHARS[letter]], LETTER_SHIFT)
    for digit in "1234567":
        tiles += halves(font[0x100 + CHARS[digit]], DIGIT_SHIFT)
    return tiles


def save_code_png(tiles):
    save_tiles_png(CODE_PNG, tiles)


# Action Help's power-up icons (src/gfx/misc/action_help_hud.png, as its BG
# tiles $40-$75 show them: 16x16 with a black outline, NONE is Wario's face)
# and its cursor (its OAM frames 14 and 15, tiles $a0 and $a2), as sprite
# tiles for POWER: 4 per icon, the left column first (8x16 sprites).
POWER_PNG = ROOT / "src/gfx/debug_menu_power.png"


def power_tiles():
    hud = read_tiles(ROOT / "src/gfx/misc/action_help_hud.png")
    tiles = []
    for i in range(10):
        # BG tile ids under $80 are $9000 on, the PNG's tiles $100 on
        top = 0x100 + (0x40 + 2 * i if i < 8 else 0x60 + 2 * (i - 8))
        tiles += [hud[top], hud[top + 16], hud[top + 1], hud[top + 17]]
    tiles += hud[0xA0:0xA4]  # the cursor's two frames, 8x16 each
    return tiles


def save_tiles_png(path, tiles):
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import png

    grey = {0: 255, 1: 170, 2: 85, 3: 0}
    rows = [[grey[c] for c in tile[y]] for tile in tiles for y in range(8)]
    with open(path, "wb") as f:
        png.Writer(8, len(rows), greyscale=True).write(f, rows)


def plain_frame():
    """The frame without the yellow band and its triangles: its lines, then
    the inside's dark red (debug_menu_code.png's pieces)."""
    for row, (corner, edge) in [(3, (CORNER, EDGE)), (17, (BOTTOM_CORNER, BOTTOM))]:
        put(row, 1, (corner, PAL_FRAME))
        put(row, 18, (corner, PAL_FRAME | X_FLIP))
        for col in range(2, 18):
            put(row, col, (edge, PAL_FRAME))
    for row in range(4, 17):
        put(row, 1, (SIDE, PAL_FRAME))
        put(row, 18, (SIDE, PAL_FRAME | X_FLIP))


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


def cell(row, col, lines, tile=None):
    """An icon cell at (row, col) and two lines of text right of it: the
    cell tile flipped for the corners, or one tile all over."""
    if tile is None:
        put(row, col, (CELL, PAL_CELL))
        put(row, col + 1, (CELL, PAL_CELL | X_FLIP))
        put(row + 1, col, (CELL, PAL_CELL | Y_FLIP))
        put(row + 1, col + 1, (CELL, PAL_CELL | X_FLIP | Y_FLIP))
    else:
        for dy in range(2):
            for dx in range(2):
                put(row + dy, col + dx, (tile, PAL_CELL))
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

# POWER: the plain frame, and white cells under Action Help's icons
new_map()
frame(first, last)
plain_frame()
for i, lines in enumerate(POWER_NAMES):
    row = POWER_TOP_ROW + (i % POWER_ROWS) * 2
    col = POWER_ICON_COL + (i // POWER_ROWS) * POWER_COL_WIDTH
    cell(row, col, lines, WHITE)
save("debug_power")

save_code_png(code_tiles())
save_tiles_png(POWER_PNG, power_tiles())

# TREASURE: the plain frame, and the code's tiles on its top edge and under it
new_map()
frame(first, last)
plain_frame()
for col, tile in [
    (TREASURE_CODE_COL - 2, ARROW_TILES),
    (TREASURE_CODE_COL, CODE_TILES),
    (TREASURE_CODE_COL + 1, CODE_TILES + 2),
    (TREASURE_CODE_COL + 3, ARROW_TILES + 2),
]:
    put(TREASURE_CODE_ROW - 1, col, (tile, PAL_FRAME))
    put(TREASURE_CODE_ROW, col, (tile + 1, PAL_FRAME))
for i in range(4):
    row = TREASURE_GRID_ROW + i // 2 * TREASURE_GRID_DROW
    col = TREASURE_GRID_COL + i % 2 * TREASURE_GRID_DCOL
    cell(row, col, ())
    # the chest's box, right of the cell (debug_menu.asm draws the chest)
    for dy in range(2):
        put(row + dy, col + 2, (CHEST_BOX + dy, PAL_FRAME))
        put(row + dy, col + 3, (CHEST_BOX + dy, PAL_FRAME | X_FLIP))
save("debug_treasure")
