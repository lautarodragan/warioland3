# The debug menu

SELECT during a level opens the menu, unless Wario is transformed: then SELECT
turns him back to normal first, and a second SELECT opens it.

| Row | Control | Effect |
|---|---|---|
| FORM | LEFT/RIGHT | 13 states: NONE, HOT, FLAT, STRNG, FAT, ELEC, PUFFY, ZOMBI, BUNCY, CRAZY, VAMPI, SNWMN, INVIS |
| POWER | LEFT/RIGHT | power-up level 0-9 |
| GOLF | A | gives or takes the current area's golf win |
| OWL | A | spawns a sleeping owl next to Wario ([The debug owl](debug-owl.md)) |
| TREASURE | LEFT/RIGHT to pick, A to apply | gives or takes any level's treasure; shows OPEN or CLOSED, like the chest |

UP/DOWN moves the cursor; B or SELECT closes the menu. FORM and POWER show
◀ ▶ around the value, only on the selected row. The menu plays the pause
menu's music and gives the level's back when it closes.

## Files

| File | What |
|---|---|
| `src/engine/debug_menu/debug_menu.asm` | the menu: state table, input, drawing, FORM/POWER/GOLF/TREASURE, owl spawn entry point |
| `src/engine/debug_menu/spawn_object.asm` | `_DebugSpawnObject` and the owl's spawn helpers, kept in the "Object Loading" section next to `SpawnObject` |
| `src/engine/debug_menu/clear_gates.asm` | `_DebugMoveClearGates`, for GOLF |
| `src/debug_menu.asm` | the "Debug Menu" section, placed by `src/layout.link` |
| `src/engine/level/update_level.asm` | the SELECT trigger (`UpdateLevel.open_debug_menu`) |
| `tools/debug_menu_bgmap.py` | generates `src/data/bgmaps/debug_menu.tilemap`/`.attrmap` |

## Opening and closing

The menu is a game state of its own, `ST_DEBUG_MENU` (`$0f`, which was an unused
slot). `UpdateLevel` checks for SELECT only when no room transition is pending
(`wRoomTransitionParam` is 0). It stops the music, saves the level's substate
in `wPendingSubState` and switches `wState`.

`InitDebugMenu` saves `rLCDC` (in `wDebugMenuLevelLCDC`), turns the LCD off, saves the level's VRAM (`SaveBackupVRAM`)
and its animated tile state, finds the current form's row, loads the screen,
turns the LCD on and plays `MUSIC_PAUSE_MENU`.

`DebugMenu_Exit` does the reverse: it redraws the level's objects, restores
VRAM, loads the owl's graphics if the menu spawned one, reapplies Wario's palette
(FORM may have changed it), restores the animated tiles and the level music, turns the LCD back on with
the level's own `rLCDC`, and returns to the saved substate with
`ReturnToPendingLevelState`.

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

The code draws only what changes: the cursor, the values and the selected row's
arrows. The arrows are two tiles defined in `debug_menu.asm`
(`DebugMenuArrowTiles`, written as 2bpp backtick literals). They are copied
over font tiles `$5e`/`$5f` when the screen loads.

The font draws its glyphs in colour 0 on colour 3, so each text palette is a
text colour on the colour of what's behind it. Palettes 1-4 are the pause
menu's; 0 is the title (yellow on dark blue); 5 is the labels (white on dark
red); 6 is the cursor and values (yellow on dark red).

The row and column constants (`DEBUG_MENU_*_Y`, `DEBUG_MENU_VALUE_X`, ...) are
shared by `debug_menu.asm` and the generator script; change both together.

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

## Treasures

The TREASURE row starts on the current level's grey treasure. Treasures that
open new paths (N5's Foot of Stone opening a secret door in S4, for example)
take effect the next time Wario enters a level from the map, because
`SelectLevel` picks the level's variant then, as in the real game.
