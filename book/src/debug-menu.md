# The debug menu

SELECT during a level opens the menu, unless Wario is transformed or rolling:
then SELECT turns him back to normal first, and a second SELECT opens it.

The menu has three pages. SELECT goes to the next one, LEVEL → POWER →
TREASURE → LEVEL; B or START closes the menu from any page, START like
leaving the pause menu. It always opens on LEVEL. While it stays open each
page keeps its selection (LEVEL's cursor, POWER's selection, TREASURE's level
and treasure); opening it again starts over: LEVEL on FORM, POWER on the
current power-up level, TREASURE on the current level's grey treasure.

| Button | Effect, on any page |
|---|---|
| SELECT | the next page |
| B, START | closes the menu |

Pages switch on the press: the SELECT that opens the menu doesn't also switch
the page (the menu's first frame comes after it), and holding SELECT switches
once. The START that closes the menu doesn't pause the game either.

| Page | Shows | Controls |
|---|---|---|
| LEVEL | FORM, GOLF, OWL, BARREL | UP/DOWN pick a row; LEFT/RIGHT on FORM; A on the others |
| [POWER](#the-power-page) | the ten power-up levels with their treasures | D-pad picks one, A sets it |
| [TREASURE](#the-treasure-page) | a level and its four treasures | LEFT/RIGHT the level, UP/DOWN the treasure, A gives or takes it |

LEVEL's rows:

| Row | Control | Effect |
|---|---|---|
| FORM | LEFT/RIGHT | 12 states: NONE, HOT, FLAT, STRNG, FAT, PUFFY, ZOMBI, BUNCY, VAMPI, SNWMN, INVIS, ROLL ([FORM's list](#forms-list)) |
| GOLF | A | gives or takes the current area's golf win |
| OWL | A | spawns a sleeping owl next to Wario ([The debug owl](debug-owl.md)) |
| BARREL | A | spawns a grabbable barrel next to Wario ([The barrel](debug-owl.md#the-barrel-and-other-objects)) |

FORM shows ◀ ▶ around the value while it's selected; the TREASURE page always
shows them around the level, which LEFT/RIGHT change. The menu plays the pause
menu's music and gives the level's back when it closes.

Under the title, on every page, a page indicator reads LEVEL POWER TREASURE in a
small font, the current page in the title's yellow and the others dim (see
[The page indicator](#the-page-indicator)). The title is DEBUG MENU on all
three pages: the indicator names the page.

Until the pages, POWER and TREASURE were rows of the menu: LEFT/RIGHT on POWER
stepped through the levels and A opened the POWER screen (B or SELECT went back
to the menu); TREASURE picked a treasure with LEFT/RIGHT (`N5 RED`). The POWER
screen is now the POWER page, and B or START there closes the menu like on
any page. The pages were first cycled with START, B or SELECT closing the
menu, and LEVEL was called MAIN.

## FORM's list

`DebugFormTable` has an entry per form, 7 bytes: the transformation
(`wTransformation`), flags, and the 5-letter name. LEFT/RIGHT step through the
entries, wrapping, and skip the ones flagged `DEBUG_FORM_HIDDEN`
(`DebugMenu_StepForm`); each applies right away (`DebugMenu_ApplyForm`, a
routine per entry, in table order).

| Index | Name | Form | |
|---|---|---|---|
| 0 | NONE | normal Wario | |
| 1 | HOT | `TRANSFORMATION_HOT_WARIO` | |
| 2 | FLAT | `TRANSFORMATION_FLAT_WARIO` | |
| 3 | STRNG | `TRANSFORMATION_BALL_O_STRING_WARIO` | |
| 4 | FAT | `TRANSFORMATION_FAT_WARIO` | |
| 5 | ELEC | `TRANSFORMATION_ELECTRIC`, zapped Wario | hidden |
| 6 | PUFFY | `TRANSFORMATION_PUFFY_WARIO` | |
| 7 | ZOMBI | `TRANSFORMATION_ZOMBIE_WARIO` | |
| 8 | BUNCY | `TRANSFORMATION_BOUNCY_WARIO` | |
| 9 | CRAZY | `TRANSFORMATION_CRAZY_WARIO`, dizzy Wario | hidden |
| 10 | VAMPI | `TRANSFORMATION_VAMPIRE_WARIO` | |
| 11 | SNWMN | `TRANSFORMATION_SNOWMAN_WARIO` | |
| 12 | INVIS | `TRANSFORMATION_INVISIBLE_WARIO` | |
| 13 | ROLL | rolling Wario: `WST_ROLLING`, not a transformation | |

ELEC is the electric shock (`TOUCH_VANISH`, `WST_ELECTRIC_START`, then
`WST_ELECTRIC_DIZZY`): zapped Wario. CRAZY is the one that spins Wario round
and leaves him dizzy (`SetState_CrazySpinning`, `WST_CRAZY_DIZZY`,
`SFX_CRAZY_DIZZY`): dizzy Wario. Hidden forms keep their entries and their code;
FORM still shows one when Wario has it as the menu opens (it starts on the
first entry with his transformation), and LEFT/RIGHT go on from there. The
flag is in ROM for now: an option to show or hide some forms could test a WRAM
mask as well in `DebugMenu_StepForm`.

ROLL is the game's roll, what a slide down a slope turns into: Wario rolls in
the way he faces until he hits a wall (and bumps off it, back on his feet),
breaking blocks, and A hops. It isn't a transformation (`wTransformation`
stays NONE); `wIsRolling` is 2 while he rolls (1 while he slides).
`.form_roll` loads the slide's graphics, as `SetState_Sliding` does before
the roll, and calls `SetState_Rolling`, or `SetState_RollingAirborne_Fall` in
the air. So that SELECT turns him back like it does a transformed Wario,
`UpdateLevel` cancels a roll (or a slide) too, clearing `wIsRolling`, and the
menu opens with the next SELECT. `DebugMenu_ApplyForm` also clears
`wIsRolling` before any form: a walking Wario with it set still breaks blocks
like a rolling one.

## Files

| File | What |
|---|---|
| `src/engine/debug_menu/debug_menu.asm` | the menu: state table, the pages (`DebugMenu_ShowFirstPage`, `DebugMenu_NextPage`, `DebugMenu_LoadPage`), LEVEL's input and drawing, FORM/GOLF, the OWL/BARREL spawn entry point (`DebugMenu_SpawnObject`) |
| `src/engine/debug_menu/power_screen.asm` | the POWER page (`DebugMenu_LoadPowerPage`, `UpdateDebugPowerPage`), the icon cells and treasure palettes the TREASURE page shares, and `DebugMenu_SetPowerLevel` |
| `src/engine/debug_menu/treasure_page.asm` | the TREASURE page (`DebugMenu_LoadTreasurePage`, `UpdateDebugTreasurePage`), the level names, `DebugMenu_ToggleTreasure` |
| `src/engine/debug_menu/spawn_object.asm` | `_DebugSpawnObject` and the helpers for objects spawned where their graphics aren't (`_DebugSpawnObjectOfKind`, `SetDebugGfxSlot`, `LoadDebugObjGfx`...), kept in the "Object Loading" section next to `SpawnObject` |
| `src/engine/debug_menu/clear_gates.asm` | `_DebugMoveClearGates`, for GOLF |
| `src/debug_menu.asm` | the "Debug Menu" section, placed by `src/layout.link` |
| `src/engine/level/update_level.asm` | the SELECT trigger (`UpdateLevel.open_debug_menu`, and `UpdateLevel.cancel_form` for forms and rolls) |
| `tools/debug_menu_bgmap.py` | generates the three pages' maps, `src/data/bgmaps/debug_level.tilemap`, `debug_power.tilemap` and `debug_treasure.tilemap` (and their `.attrmap`), and the page indicator, `src/gfx/debug_menu_pages.png` |

## Opening and closing

The menu is a game state of its own, `ST_DEBUG_MENU` (`$0f`, which was an unused
slot). `UpdateLevel` checks for SELECT only when no room transition is pending
(`wRoomTransitionParam` is 0). It stops the music, saves the level's substate
in `wPendingSubState` and switches `wState`.

`InitDebugMenu` saves `rLCDC`, `rWY` and `rWX` (in `wDebugMenuLevelLCDC`,
`wDebugMenuLevelWY` and `wDebugMenuLevelWX`), turns the LCD off, saves the
level's VRAM (`SaveBackupVRAM`) and its animated tile state, sets each page's
selection, finds the current form, loads the tiles all pages use
(`DebugMenu_LoadTiles`), shows LEVEL (`DebugMenu_ShowFirstPage`, which turns
the LCD on) and plays `MUSIC_PAUSE_MENU`.

Each page is a substate: `SST_DEBUG_LEVEL_PAGE` (1), `SST_DEBUG_POWER_PAGE` (2)
and `SST_DEBUG_TREASURE_PAGE` (3), in SELECT's order. `DebugMenu_NextPage` goes
to the next one with the LCD on (see [Switching pages](#switching-pages)). B
or START on any page jumps to `DebugMenu_Exit`.

`DebugMenu_Exit` does the reverse: it redraws the level's objects, restores
VRAM, loads the graphics of the owl or barrel the menu spawned in a room
without them (`wDebugMenuGfxPending`, a bit per kind), reapplies Wario's palette
(FORM may have changed it), restores the animated tiles and the level music, turns the LCD back on with
the level's own `rLCDC` (and `rWY` and `rWX`, which page switches change), and
returns to the saved substate with `ReturnToPendingLevelState`.

Opening and closing still turn the LCD off, like the game's pause menu does:
saving and restoring the level's 16 KB of VRAM takes several frames, and the
screen changes completely anyway. On a Game Boy Color that's a white frame or
two as the menu opens and closes, as with the pause menu.

Restoring the level's `rLCDC` matters in The Temple: its battle draws the
arena floor with the window layer, which only that level turns on. The menu
used to close with `LCDC_DEFAULT` (window off), so the floor disappeared. The
pause menu does the same, but the game doesn't let you pause in boss battles,
so the original never shows it.

## Drawing

The menu uses the pause menu's graphics (its gems, title band and the yellow
frame around its treasures), loaded into VRAM bank 1 next to the font in VRAM
bank 0. Pause menu tiles have attribute bit 3 (the VRAM bank) set.

The background map comes from `tools/debug_menu_bgmap.py`, which copies the
pause menu's pieces from its own maps and writes the fixed text (title and
labels). Run it again after changing the layout:

```nu
python3 tools/debug_menu_bgmap.py
```

LEVEL's four rows are two map rows apart, FORM on row 7 to BARREL on row 13:
three blank rows above them and three below, centred in the frame (rows 4-16).
They used to start on row 4, with POWER and TREASURE between and below them.

```text
  DEBUG MENU                 (row 1)
  LEVEL  POWER  TREASURE     (row 2, small font)
  +----------------------+   (row 3, the frame)
   ▼FORM      ◀NONE ▶        (row 7)
    GOLF       OFF           (row 9)
    OWL        OK            (row 11)
    BARREL                   (row 13)
  +----------------------+   (row 17)
```

The code draws only what changes: the cursor, the values and the selected row's
arrows. OWL and BARREL show `OK` or `NO` for the last try
(`DebugMenu_DrawSpawnStatus`). The arrows are two tiles defined in `debug_menu.asm`
(`DebugMenuArrowTiles`, written as 2bpp backtick literals). They are copied
over font tiles `$5e`/`$5f` when the menu opens. With the LCD on, a change is
drawn in V-Blank: `DebugMenu_StartVRAMWrite` waits for the start of the next
one with interrupts off, and `DebugMenu_EndVRAMWrite` turns them back on when
it's done. It also runs the sound for that frame (`HandleSound`, which the main
loop runs once a frame), so that the music keeps its tempo through changes that
take several V-Blanks.

The font draws its glyphs in colour 0 on colour 3, so each text palette is a
text colour on the colour of what's behind it. Palettes 1-4 are the pause
menu's; 0 is the title (yellow on dark blue, and colour 1 a dim lavender for the
page indicator); 5 is the labels (white on dark red); 6 is the cursor and
values (yellow on dark red); 7 is the POWER and TREASURE pages' icon cells.

The row and column constants (`DEBUG_MENU_*`, `DEBUG_POWER_*`,
`DEBUG_TREASURE_*`) are shared by `debug_menu.asm` and the generator script;
change both together.

### The page indicator

The title band's second row (row 2, blank before the pages) shows LEVEL POWER
TREASURE in a small font: letters 5 pixels high with 1-pixel strokes, like the
menu font, 3 pixels wide (W wider) with a pixel between them. The font is in
`tools/debug_menu_bgmap.py` (`SMALL_FONT`, drawn as text), with only the 11
letters the names need. The letters are packed: they don't keep to 8-pixel
cells, so a tile holds parts of two or three of them, and the three names fit
in 12 tiles, centred in the band.

The script draws the strip three times, one for each page, into
`src/gfx/debug_menu_pages.png` (96×24, a row of 12 tiles per page): the page's
name in colour 0 (the title's yellow), the others in colour 1 (dim), on colour
3 (the band's dark blue). All three maps show tiles `$62`-`$6d` there
(`DEBUG_MENU_PAGES_TILE`, over the font's `c`-`n`, unused by the menu), in
palette 0, and `DebugMenu_LoadPagesGfx` copies the page's row of tiles over
them (192 bytes; `DebugMenuPagesGfx` is 576 bytes for the three). A palette per word
was not possible: all 8 BG palettes are taken, and the words share tiles.

### VRAM and palettes, page by page

| | LEVEL | POWER | TREASURE |
|---|---|---|---|
| BG map | `debug_level` | `debug_power` | `debug_treasure` |
| BG tiles (VRAM0 `$9000`-`$97ff`) | font, arrows `$5e`/`$5f`, indicator `$62`-`$6d` | the same, and the icon cells `$60`/`$61` | the same as POWER |
| BG tiles (VRAM1) | pause menu graphics | same | same |
| Sprite tiles (VRAM0 `$8000`-`$87ff`) | none shown | `$8000`-`$827f`: the 10 power-up treasures | `$8280`-`$837f` or `$8380`-`$847f`: the level's 4 treasures |
| BG palettes | 0-6 | 0-7 | 0-7 |
| OB palettes | none | 0 (grey) and 4-7 (`TreasurePals`) | the same |
| Sprites | none | 20 | 8 |

The tiles that don't change are loaded once, when the menu opens
(`DebugMenu_LoadTiles`): the font, the arrows, the icon cells, the pause menu's
graphics and the POWER page's treasures. `$8000`-`$87ff` is the start of the
font, which the BG never shows (it uses `$8800`-`$97ff`), so sprites can have
it. The two pages' sprite tiles don't overlap, so going from one to the other
reloads nothing but the TREASURE page's four treasures. The OB palettes are
written to `wTempPals2` each time the POWER or TREASURE page is shown, because
FORM changes Wario's palettes, which are the same OB palettes.

Closing the menu from any page restores VRAM, `wTempPals1`/`wTempPals2` and OAM
from the level's backup (`LoadBackupVRAM`, `DrawLevelObjectsAfterLevelReturn`),
so no page leaves anything behind. `test_debug_menu_closes_from_every_page`
checks that VRAM and the palettes are as they were, from each page with B and
with START; the only difference allowed is the room's animated tiles (VRAM1
`$9700`-`$977f`), which start over when the menu closes.

### Switching pages

A page switch used to turn the LCD off to load the next page. A Game Boy Color
shows a disabled LCD as white, so on hardware every switch flashed white
(PyBoy doesn't show it). Now the LCD stays on, and the switch hides the
drawing behind the window instead of a blank screen: the screen shows the old
page until, in one V-Blank, it shows the new one. No frame is blank or
half-drawn.

The window shows BG map 1 (`$9c00`), unused by the pages, which are drawn in BG
map 0. When the menu opens (LCD off), `DebugMenu_ShowFirstPage` also loads the
LEVEL page's map into BG map 1: the title band and the frame, rows 0-3 and 17,
are the same on every page and stay there. `DebugMenu_NextPage` then:

1. Copies the page on screen to BG map 1, rows 4-16 (`DEBUG_MENU_SWAP_TOP` to
   `DEBUG_MENU_SWAP_BOTTOM`), the part that differs between pages:
   `DebugMenu_CopyToWindowMap`, the tiles in one V-Blank and the attributes in
   the next. At the end of the second it puts the window at the top left
   (`rWY` 0, `rWX` 7) and turns it on (`LCDC_WIN_ON | LCDC_WIN_9C00`): the
   screen looks the same, now from BG map 1.
2. Draws the next page in BG map 0, under the window (`DebugMenu_LoadPage`):
   its map, by GDMA from ROM (`DebugMenu_LoadPageMap`), then its values, the OB
   palettes and the TREASURE page's sprite tiles, each part in a V-Blank of its
   own, and its sprites in `wVirtualOAM`.
3. In one V-Blank: the page indicator's tiles (GDMA), the sprites (OAM DMA) and
   the window off. The next page shows from the next frame on.

The window and the BG show the same pixels (the scroll is 0, and the window's
`rWX` 7 is the screen's left edge), and the sprites don't change until step 3,
so nothing shows mid-switch. The old page's sprites over the window keep their
tiles and palettes: the POWER and TREASURE pages' sprite tiles don't overlap,
and their OB palettes are the same.

The maps are in ROM uncompressed, the screen's 18 rows of each 32-wide map
(`DebugLevelTilemap`... 576 bytes each, 3456 for the six, aligned to 16 bytes
for GDMA), instead of compressed: `Decompress` writes VRAM as it goes, which
only works with the LCD off, and decompressing into WRAM first would need 2 KB
of it free while the menu is open (the level's VRAM backup takes banks 4-7).
The Debug Menu bank has the room.

#### Timing

The game runs in double speed: a CPU M-cycle is 2 dots, a line 456 dots, and
V-Blank (lines 144-153) 4560 dots. Every VRAM, palette and OAM write in the
menu with the LCD on is between `DebugMenu_StartVRAMWrite`, which returns at
the start of line 144 (it polls `rLY` with interrupts off, so no interrupt
handler delays it), and `DebugMenu_EndVRAMWrite`, and each of these writes fits
in its V-Blank:

| V-Blank | Work | Cost |
|---|---|---|
| copy, tiles | 13 rows × 20 bytes, unrolled (`ld a, [hli]`, `ld [de], a`, `inc e`: 5 M-cycles a byte) | about 2900 dots |
| copy, attributes | the same, and `rWY`, `rWX`, `rLCDC` | about 2900 dots |
| map | GDMA, 2 × 36 blocks of 16 bytes; GDMA takes 32 dots a block in either speed | about 2300 dots |
| values | LEVEL's in two V-Blanks (as before); a POWER cell; TREASURE's code and name, then its statuses and cell | under 2000 dots each |
| OB palettes | 64 bytes (`ApplyTempPals2ToOBPals`) | about 1000 dots |
| TREASURE tiles | 4 V-Blanks, a treasure (64 bytes) each, as for a level change | |
| show | GDMA, 12 blocks (the indicator), OAM DMA, `rLCDC` | about 1100 dots |

A switch takes 6 frames to POWER or LEVEL and 11 to TREASURE (PyBoy), the
old page showing meanwhile. The main loop doesn't run then (`DebugMenu_NextPage`
waits for each V-Blank itself), so its V-Blank handler, which copies
`wVirtualOAM` to OAM, doesn't either; `DebugMenu_EndVRAMWrite` runs the sound.

`tests/test_debug_menu_pages.py` checks it in PyBoy. It hooks every routine that
writes VRAM, the palettes or OAM, and `DebugMenu_EndVRAMWrite`, and checks
that whenever one runs with the LCD on, `rLY` is 144-153 and `rSTAT` is in mode
1; the latest any write ends is line 151 (the attribute copy), two lines before
the end of V-Blank. `DisableLCD` must not run. And it takes every frame of
each switch and checks each is the old page or the new one, the old ones
first. (PyBoy doesn't block VRAM writes in mode 3, nor take time for a GDMA:
the timing above is worked out from the hardware's, and the PyBoy figures for
the CPU copies match it.)

## GOLF and the room reload

The golf win (`wIsMinigameCleared`) only does one thing in a level: it raises
the clear gates, the "MINI GAME CLEAR" signs that block a passage.
`ClearGateFunc` raises a gate 32 pixels when the gate is set up while the flag
is on. The only other reader is the golf building, which uses it to skip the
CLEAR screen. GOLF flips the flag and moves the gates that are already set up
(objects whose update function is `ClearGateFunc.Update`) up or down 32
pixels. Gates that spawn later read the flag themselves. Nothing is reloaded.
Lowering a gate while Wario stands under it traps him, but he can jump out.

GOLF used to reload the room instead: it set
`wRoomTransitionParam = ROOMTRANSITION_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS`
and left through the level's fade-out. That reset the game to the title screen
in most rooms. Why:

- `StartRoom_FromTransition` doesn't reload the room Wario is in. It treats his
  position as a door. `GetNextLevelRoomID` turns his position into a sector
  (16×16 blocks, `y_hi * 10 + x_hi`). The level's room table, indexed by sector,
  gives the room *a door in that sector leads to*. `LoadRoom` takes that room's
  header, and `SetWarioPositionToSpawn` moves Wario to its spawn block.
- Coming back from golf, Wario stands in the golf building's door. That sector's
  room is the room he left, with a spawn block at the door, so it works.
- No door in the sector (most start rooms): the entry is `$ffff`, and
  `LoadRoom`'s `debug_assert_not $ff` jumps to `Init`, which resets the game. That
  was 21 of the 25 day-1 start rooms.
- A door in the sector: Wario is sent to that door's room (The Volcano's Base,
  The Colossal Hole, The Warped Void). These were most likely the soft-locks
  people saw.

## The TREASURE page

The TREASURE page gives or takes any level's treasure. It shows a level, its
code between ◀ ▶ and its name on the two rows below (centred, split in two
where it's too long, e.g. THE VOLCANO'S / BASE), and the level's four
treasures in a column, grey, red, green and blue: each its icon in an icon
cell like the POWER page's, its colour and OPEN or CLOSED, like the chest. The
icons are in the treasure's own colours when Wario has it, in grey when he
doesn't.

```text
        ◀ N5 ▶
   THE TIDAL COAST

      [icon] GREY
             CLOSED
      [icon] RED
             OPEN
      [icon] GREEN
             CLOSED
      [icon] BLUE
             OPEN
```

| Button | Effect |
|---|---|
| LEFT/RIGHT | the previous or next level, wrapping (E7 and N1), on the same colour |
| UP/DOWN | the treasure (no wrapping) |
| A | gives or takes the selected treasure (`DebugMenu_ToggleTreasure`) |

The page starts on the current level's grey treasure (N1's in The Temple and
the golf building, which have none). `wDebugMenuTreasureIdx` is the pick, level
× 4 + colour, the layout of `LevelTreasureIDs_WithoutTemple`. Treasures that
open new paths (N5's Foot of Stone opening a secret door in S4, for example)
take effect the next time Wario enters a level from the map, because
`SelectLevel` picks the level's variant then, as in the real game.

The level names are in `src/engine/debug_menu/treasure_page.asm` (`DebugLevelNames`), each line with
its column and length worked out by a macro. Changing the level redraws the
code and the name in one V-Blank and the four statuses in the next. The icons
come from two sets of sprite tiles (from `DEBUG_TREASURE_OBJ_TILE`, 16 tiles
each): the new level's treasures go into the set not on screen, one treasure
(64 bytes) per V-Blank, and then the sprites switch to it
(`wDebugTreasureObjTile`), so the icons never show half-loaded tiles. A level
change takes six frames, with the LCD on, the music running on
(`DebugMenu_EndVRAMWrite`).

## The POWER page

The POWER page has the ten power-up levels: NONE and the nine power-ups, each
with the treasure that gives it (NONE has the game's closed chest, treasure 0)
and a short name on two lines. The levels are cumulative: level N means every
power-up up to N, so the ones up to `wPowerUpLevel` are in their colours and
the others in grey.

```text
  [chest] NONE         [garlic] GARLIC
  [lead]  LEAD         [slam]   SLAM
          OVRALL                OVRALL
  [flip]  SWIM         [boots]  JUMP
          FLIPPR                BOOTS
  [helm]  SMASH        [frog]   FROG
          HELMET                GLOVES
  [glove] GRAB         [super]  SUPER
          GLOVE                 GRAB
```

| Button | Effect |
|---|---|
| UP/DOWN | moves within a column (no wrapping) |
| LEFT/RIGHT | moves to the other column, same row |
| A | sets `wPowerUpLevel` to the selection (`DebugMenu_SetPowerLevel`) |

The selection starts on the current level when the menu opens. The selected
cell gets a yellow frame and its name turns yellow. Setting `wPowerUpLevel` is
all it takes: the game reads it whenever it checks a power-up (the jump with
the High Jump Boots, swimming, grabbing...), nothing caches it.

It was the POWER screen, opened with A on the menu's POWER row (whose LEFT/RIGHT
also stepped through the levels) and left with B or SELECT. As a page it shows
the same thing.

### Icons

The icons are sprites, two 8×16 each (the treasure graphics are interleaved
for that, like the collection screen's): all 8 BG palettes are taken by the
frame and the text, and each treasure colour needs its own palette. The
TREASURE page's icons work the same way.

- Tiles: the 10 treasures' tiles (4 each, uncompressed `TreasureGfx` in bank
  `$26`, indexed by treasure ID, copied by `DebugMenu_CopyTreasureTiles`) at
  VRAM0 `$8000`-`$827f`. The icon cells' two tiles (`DebugPowerCellTiles`) go
  over the font's `a` and `b` (`$60`, `$61`), which the menu doesn't use.
- OB palettes: the treasures' own (`TreasurePals`, OB palettes 4-7, the
  `OBPAL_TREASURE_*` that `TreasureOBPals` picks for each treasure, like the
  collection and pause screens), and a light grey one in palette 0 for the
  ones not owned (`DebugMenu_LoadTreasurePals`).
- BG palette 7: the icon cells, white behind the sprites (whose colour 0 is
  transparent; the treasure palettes' colour 0 is the same white), a 1-pixel
  dark red margin so neighbouring cells stay apart, and the selected cell's
  yellow frame. The map flips one corner tile for the four corners.

`DebugMenu_BuildPowerOAM` writes the 20 sprites to `wVirtualOAM`
(`DebugMenu_BuildTreasureOAM` the TREASURE page's 8); A rebuilds them and the
V-Blank handler copies them.
