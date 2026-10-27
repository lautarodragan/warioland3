# Debug Menu OWL Feature — Notes

Attempted feature: add an **OWL** entry to the debug menu that spawns a
carryable owl object next to Wario. The feature was reverted because
grabbing the spawned owl caused permanent, level-wide graphics/collision
corruption that persisted across level exits. Root cause was never fully
confirmed; notes below capture what was tried and what was learned.

> **Update (second attempt): root cause found and fixed.** See
> [Resolution](#resolution) at the end. The OWL entry is back, with
> emulator tests in `tests/test_owl.py`.

---

## Files involved

| File | Role |
|------|------|
| `src/engine/debug_menu/debug_menu.asm` | Spawn logic + menu entry |
| `src/engine/level/objects/owl.asm` | `OwlFunc` / `OwlFunc.Sleep` update function |
| `src/engine/level/object_interactions.asm` | `ObjInteraction_Owl` — called when Wario grabs/touches owl |
| `src/engine/level/wario_states_4.asm` | Wario state that runs while carrying owl |
| `src/ram/wram.asm` | Temporarily added `wDebugOwlActive` flag (later removed) |

---

## What was implemented

### `DebugMenu_SpawnOwl` (debug_menu.asm)

Finds the first free slot in `wObj1`–`wObj8` (WRAM bank 1 / `wObjects`),
zeroes it with `WriteAToHL_BCTimes`, then manually fills:

- `OBJ_FLAGS` = `OBJFLAG_ACTIVE | OBJFLAG_PRIORITY`
- `OBJ_Y_POS` / `OBJ_X_POS` — Wario's position + 24px right.
  **Byte-order gotcha**: `wWarioYPos`/`wWarioXPos` are big-endian (Hi
  byte first), but `OBJ_Y_POS`/`OBJ_X_POS` in the struct are
  little-endian (Lo byte first). Swapping these bytes took a fix cycle.
- `OBJ_ID` = `OWL`
- `OBJ_INTERACTION_TYPE` = `OBJ_INTERACTION_OWL`
- Collision box (`OBJ_COLLBOX_*`) matching daytime sleeping owl values
- `OBJ_UPDATE_FUNCTION` — see below
- `OBJSUBFLAG_UNINITIALISED` set so the object system calls init on the
  first frame (sets up the right OAM pointer, etc.)

Must call `push_wram BANK("Level Objects WRAM")` / `pop_wram` around all
`wObjects` access since it lives in WRAM bank 1.

### OWL menu row

Added as row 13 (cursor index 4). Left/Right both call
`DebugMenu_SpawnOwl`. The yellow footer band was moved from rows 13-14
to 15-16 to make room.

---

## The corruption bug

**Symptom**: After grabbing the debug owl and walking through a wall
(horizontal movement only, no vertical input), tile graphics and collision
data become permanently corrupted. Persists after exiting the level and
returning to the overworld. Pause menu still works; game is otherwise
broken.

### Hypothesis 1 — camera mode (wrong)

Non-owl levels use `CAM_FREE=0`; `LevelScroll_Vertical` is skipped, so
`wCameraYDelta` might not be consumed. Fix: force `CAM_FREE` when
`ObjInteraction_Owl` activates.

**Disproved**: bug also reproduced inside real owl levels (which already
use `CAM_FREE`), and with purely horizontal movement (no
`wCameraYDelta` change).

### Hypothesis 2 — `wDebugOwlActive` flag (wrong)

Added a flag to skip `LoadWarioGfx` while the debug owl was active, to
avoid a DMA overwriting Wario's sprite tiles. Removed after it was
confirmed not to be the root cause.

### Hypothesis 3 — `DoObjectAction` / `OwlFunc.Sleep` wake-up (implemented, still broken)

Flow:
1. `ObjInteraction_Owl` → `Func_20a63` → `SetObjAction(OBJACTION_07)` on the
   owl object.
2. Next frame: `DoObjectAction` handles `.Action07` → sets
   `OBJ_STATE = OBJSTATE_18 ($18)`.
3. `OwlFunc.Sleep` checks `wCurObjState`: nonzero → wakes the owl, calls
   `MoveObjectUp`, changes interaction type, starts fly sequence.
4. Flying owl shifts `wCameraYDelta` even with no player vertical input.

Fix: replace the owl's `OBJ_UPDATE_FUNCTION` with `DebugOwlFunc` (a
bare `ret`) so the state machine is never entered.

**Still broken** according to user testing. Bug was deprioritised before
root cause was confirmed.

---

## Key engine facts useful for a future attempt

- **`ObjInteraction_Owl`** (`object_interactions.asm`) is called every
  frame Wario is in the carrying state. It calls `Func_20a63` which calls
  `SetObjAction(OBJACTION_07)` on the held object — this sets
  `OBJ_ACTION = OBJACTION_07`, `OBJ_STATE = 0`, then next frame
  `DoObjectAction` runs `.Action07` which sets `OBJ_STATE = OBJSTATE_18`.
- **`OwlFunc.Sleep`** (`objects/owl.asm:35`) returns early only when
  `wCurObjState == 0`. Any nonzero state triggers the wake-up and full
  fly sequence. If using `OwlFunc.Sleep` as the update function, the owl
  _will_ wake every time it is grabbed.
- **`LoadWarioGfx`** DMAes 2048 bytes (128 tiles) to `v0Tiles0`
  ($8000–$87FF). It fires during the V-Blank of the frame after
  `ObjInteraction_Owl` sets `wIsDMATransferPending`. This replaces
  whatever was in VRAM0 tile page 0 — relevant if the owl's own tiles
  live there.
- **WRAM bank 1** ("Level Objects WRAM") holds `wObjects`. Always
  `push_wram` / `pop_wram` around access from debug menu code.
- **`OwlFunc::`** needed to be exported (`::`) to be referenced from the
  debug menu bank. After the revert it is back to a local label (`:`).

---

## Resolution

Found with the emulator tests (PyBoy, `tests/test_owl.py`), by comparing the
spawned owl against a real one in The Colossal Hole.

### The corruption: `DespawnObject` writing to `$0000`

Once Wario grabs an owl, the owl object despawns (from then on it's drawn as
part of Owl Wario): `OwlFunc`'s `.despawn` calls `DespawnObject`, which sets
bit 7 of the object's entry in the level's object map, at the address in
`OBJ_UNK_02:OBJ_UNK_01`. Objects spawned from the map have that pointer into
SRAM; the debug owl had it zeroed, so `DespawnObject` wrote
`[$0000] | $80` to `$0000`. On MBC5 that's the RAM enable register, and any
value other than `$0A` switches cartridge RAM off. The level's block and
object maps live in SRAM, so from then on every collision and tile read
returned garbage: walking through walls, broken graphics, and since it's
the cartridge state, it outlived the level.

None of the earlier hypotheses (camera mode, `LoadWarioGfx`, the owl's wake
up) were it; replacing the update function with a bare `ret` didn't help
because the despawn happens on Wario's side of the grab.

Fix: `DespawnObject` treats `OBJ_UNK_02 == 0` as "no map entry" and only
clears the object, the same convention the offscreen-despawn path in
`update_objects.asm` already follows.

### Broken graphics in non-owl levels

Every owl object group loads `OwlGfx` into enemy graphics slot 1, and the
owl's OAM always points at slot 1. In a room whose group doesn't have the
owl, slot 1 holds some other enemy, so a spawned owl drew garbage. The new
spawn (`_DebugSpawnObject`, Object Loading bank) only spawns objects the
current room's object group has, using that group's data.

In rooms whose group has no owl, `_DebugSpawnOwlFromROM` spawns one from
`OwlData` instead, and the menu loads `OwlGfx` into slot 1 (VRAM1 `$8000`)
and the owl palette into object palette 4 when it closes. That has to happen
in `DebugMenu_Exit` after `LoadBackupVRAM`, while the LCD is still off: the
menu backs up all of VRAM and the palettes on entry and restores them on
exit, so anything written earlier would be overwritten. The menu shows `NO`
only when every object slot is taken.

### Flying into another room

A spawned owl that isn't held is transient: like any object, it's despawned
when Wario leaves the room, and it doesn't come back. A held owl is no
object at all, but part of Owl Wario, so he keeps it through room
transitions (`test_steep_canyon_debug_owl_to_next_room`: past The Steep
Canyon's cracked column, down into the room below).

Owl Wario draws the owl he holds from enemy graphics slot 1 too, though, and
a room change loads the new room's object group into the slots. In a room
whose group has no owl, he flew on holding the new slot-1 enemy's tiles,
in its colours. Now `LoadObjectGroupData` ends with `LoadOwlGfxForOwlWario`,
which loads the owl's graphics and palette (`LoadOwlGfx`, also used by the
debug menu) when Wario is Owl Wario and the group has no owl. In rooms whose
group has the owl (all the ones a real owl is grabbed in, at least), it does
nothing.

### Rooms that use all four slots

Slot 1 and palette 4 used to be simply taken from one of the room's own
enemies (a spearhead in the room below The Steep Canyon's cracked column),
which drew with the owl's tiles until the room was reloaded. Now the owl
goes into a slot the room doesn't use if there is one (next section), and
otherwise borrows one and gives it back
([Borrowing a slot](#borrowing-a-slot-when-all-four-are-used)).

### Using a free enemy graphics slot

**How the owl's sprites get their tiles and palettes.** Nothing applies a
per-object tile base or palette at draw time. Object OAM data
(`frame_oam y, x, tile, attributes`) has the tile numbers, VRAM bank and
palette baked in: `UpdateObjSprite` copies tile and attributes into virtual
OAM as they are, and `LoadSprite` (Wario, particles) only XORs the
attributes with `wCurSpriteAttributes` (for flipping). The owl's object OAM
(`OAM_188e16`), Owl Wario's frames (`OAM_1fddb4`, "Wario OAM 2", Wario's own
tiles in VRAM0 plus the owl's in VRAM1) and the released owl (`OAM_d763`,
`PARTICLE_OWL`) all use VRAM1 tiles `$00`-`$3f` (slot 1) with palette 4,
plus palettes 2 or 0 for a few parts (eyes and beak, feet), which aren't
enemy slot palettes and stay as they are.

**How to tell a slot is unused.** Every object group decompresses four
graphics sets, unused slots included, and its object list is positional:
entry n is the object whose graphics are in slot n (entries past the fourth
are variants, like `NobiiruLeft`/`NobiiruRight`). Empty slots get
`DummyObjectData` in the list, or the list ends (`NULL`) before them, and
graphics from `ObjectGroup0`, the empty group: `SpearheadGfx`, `WebberGfx`,
`FutamoguGfx`, `TorchGfx` for slots 1-4. The entry alone isn't enough:
bosses and enemies made of several slots (`Sun1`/`Sun2`, `RoboMouse1`/`2`)
have short lists with entries missing for slots they draw from. So
`SetOwlTileOffset` (Object Loading bank, next to the debug spawn) takes the
first slot whose entry is `DummyObjectData` or past the end **and** whose
graphics are that slot's filler from `ObjectGroup0`; bosses (groups with a
GFX bank offset) and The Temple's hidden figure always get slot 1.
`test_free_slot_rule_matches_oam_data` checks that rule against every
group: no object in a group has OAM drawing from a slot the rule calls
unused (the clear gates' shared table, whose frames per slot
`ClearGate1-3Func` choose, aside). 78 of the 118 groups leave at least one
slot free.

**Design.** `wOwlTileOffset` (WRAM0) says where the owl's graphics are, as a
tile offset: `$00` for slot 1 / palette 4 (the default, and always the case
in rooms whose group has the owl), `$40`/`$80`/`$c0` for slots 2-4 / palettes
5-7 (plus a flag for a borrowed slot, see below). `LoadObjectGroupData` resets it to `$00` on every room load. It's set
by `_DebugSpawnOwlFromROM` (after a spawn in a room without the owl) and by
`LoadOwlGfxForOwlWario` (Owl Wario flying into such a room), and
`LoadOwlGfx` loads the owl's graphics and palette at that offset.

The owl's OAM data stays as it is; its sprites are moved to the slot after
they're written to virtual OAM, by `RelocateOwlSprites` (home bank): for each
VRAM1 sprite from a given virtual OAM offset to the end, add the offset to
the tile, and turn palette 4 into the slot's. It's called only when
`wOwlTileOffset` isn't 0, from the three places that draw the owl:

1. the spawned owl object: `DrawObjects_NoPriority`/`_WithPriority` switch
   to `DrawObjects_OwlElsewhere`, the same loop over the objects but
   relocating the sprites `UpdateObjSprite` wrote for an `OWL` object;
2. and 4. Owl Wario holding it, in this room or one he flew into:
   `DrawWario` relocates his sprites when he's Owl Wario (his own sprites
   use VRAM0 and are left alone; other forms' frames, like the bubble's, use
   VRAM1 and aren't the owl, hence the check);
3. the released owl: `ParticleAnim_Owl` relocates the particle's sprites.

**Why this and not something else.** Copies of the OAM data for each slot
would need no code at draw time, but Owl Wario's frames alone are almost 4 KB
(times three slots), the object's 1.5 KB, and they'd have to be switched in
wherever the game sets those OAM pointers. An offset applied in
`UpdateObjSprite`/`LoadSprite` would cost every sprite of every object, every
frame. Here the cost when nothing is relocated is one check in each of the
two object draw loops and `DrawWario`, and one in `ParticleAnim_Owl` (owl
particles only).

Those few cycles still shift when the CPU reads `DIV`, which enemies use for
randomness, so some enemies behave differently than before (in Out of the
Woods' test playthrough Wario now ends with 3 coins instead of 1). The room
load and the first draw of a room happen with the LCD off, so any cycle
added there moves the LCD's frame timing against `DIV`; that can't be
avoided without also skipping the relocation for that first frame.

**Tests.** `tests/test_owl_free_slot.py` spawns the owl in Desert Ruins'
start room (group 023: spearheads in slot 1, hands in slot 3, slots 2 and 4
free) and checks that the owl's tiles land in slot 2 with slot 1 untouched,
that the sprites on screen draw the owl from slot 2 in palette 5 and the
spearhead from slot 1 in palette 4, through the spawn, the grab, the flight
to a spearhead and letting go; plus borrowing a slot in Out of the Woods
(below). The Steep Canyon tests cover both cases: its start room leaves slot
2 free, the room below the cracked column uses all four slots.

### Borrowing a slot when all four are used

40 of the 118 object groups use all four enemy graphics slots (Out of the
Woods' start room, the room below The Steep Canyon's cracked column, The
Stagnant Swamp's zip line room...). There the owl's graphics have to go over
some enemy's. Before this, slot 1's enemy drew with the owl's tiles (and
palette) from the spawn until the next room load: during the flight, and
after the owl was gone.

**What was measured.** Frame by frame, on the build before this and this
one (a throwaway script over the test routes, not committed): a "glitch
frame" is one where an active object other than the owl, flagged on screen
(`OBJFLAG_ON_SCREEN`), has a current frame drawing VRAM1 tiles from a slot
that holds the owl's tiles; "visible" when its screen position is also
inside the screen.

| Route (Out of the Woods' start room) | before | after |
|---|---|---|
| `test_debug_owl_floor_transitions`, then 600 frames walking after letting go (1631 frames) | 457 glitch frames, 6 visible | 0 |
| the old fallback test's grab, a flight, letting go, 300 frames walking (844 frames) | 403, 183 visible (the spearhead) | 0 |

The owl's tiles stay loaded for the whole of both routes before; now they're
gone about 40 frames after the owl flies off (1028 and 466 frames).

**Options looked at.**

- *Free tiles elsewhere: no.* The owl's object OAM (`OAM_188e16`) uses all 32
  8x16 tile pairs of its slot (64 tiles), Owl Wario's frames (`OAM_1fddb4`)
  25 pairs (50 tiles: `$08`-`$09` and `$10`-`$3f`), the released owl
  (`OAM_d763`) 6 pairs. Sprites can only use `$8000`-`$8fff` of either VRAM
  bank. VRAM0 `$8000`-`$87ff` is Wario's: `LoadWarioGfx` DMAs all 128 tiles
  on every form change, and Owl Wario's own tiles go up to `$58`. VRAM0
  `$8800`-`$8fff` is `LevelsCommonGfx` (HUD, particles, coins; it's also the
  background's tiles `$80`-`$ff`), 114 of its 128 tiles drawn. VRAM1
  `$8000`-`$8fff` is the four slots. There's no range of 50 free tiles, let
  alone 64.
- *Borrow a slot nothing active draws from: yes.* `SetOwlTileOffset` looks
  at every active object's current frame (`GetObjFrameSlots`, home bank: the
  object's OAM data, in the bank its ID picks, as `UpdateObjSprite` reads
  it) and takes the first slot none draws from, or slot 1. A first version
  went by the group's object list instead (entry n is slot n's object: a
  slot was idle if no active object had that entry's ID). That's wrong for
  groups like The Stagnant Swamp's zip lines (group 033, five zip line
  entries in a group whose graphics are RoboMouse's and Spear-Bot's), where
  it took the zip lines' own slot and they drew as owl pieces
  (`test_debug_owl_at_night_without_owl` caught it). In Out of the Woods'
  start room the spearhead (slot 1) is active when the owl is spawned, so it
  goes into slot 2, the Applebys'. When Owl Wario flies into such a room
  nothing is active yet, so it's slot 1, as before.
- *An enemy of that slot spawning while the owl is around: refused (put
  off).* Choosing a slot alone only moves the problem: in Out of the Woods the
  glitch went from the spearhead to an Appleby that came into view on the
  second floor (573 glitch frames instead of 457 on the first route).
  Putting such spawns off costs nothing when there's no owl:
  `RefuseBorrowedSlotObjects` replaces the slot's objects' entries in
  `wObjDataPtr01`-`13` (those whose first frame draws from the slot) with
  `RefusedObjectData`, whose update function despawns it before it's drawn
  and leaves it in the object map (`DespawnObject`), like an object that went
  offscreen. Once the owl is gone the entries are put back
  (`wOwlSlotObjDataBackup`, in an unused part of WRAM bank 1), and those
  objects spawn again as Wario comes across them, the way the game spawns
  everything. Accepting the glitch was the alternative; refusing means one
  kind of enemy is missing while the debug owl is around, which seems the
  better deal for a cheat. A check in `SpawnObject` would have cost cycles in
  every spawn of the original game. Objects already active keep the slot's
  tiles until they go, which is why the slot choice prefers an idle slot.
  Bosses (the menu refuses the owl in boss battles) keep spawning their
  parts.
- *Give the slot back once the owl is gone: yes.* "Gone" is: no active owl
  object, Wario isn't Owl Wario, and no owl particle (the released owl flying
  off). `LoadOwlGfx` saves the slot's 64 tiles and its palette
  (`wOwlSlotTilesBackup`, an unused part of WRAM bank 3) before loading the
  owl's, while the LCD is off anyway. Giving them back happens with the LCD
  on: the level's V-Blank function is redirected to
  `OwlSlotRestoreVBlankFunc` (home bank, in the same page as
  `LevelVBlankFunc`, so that only the low byte of the jump in `wVBlankFunc`
  changes and a V-Blank can't catch it half written), which copies 256 bytes
  per V-Blank with a general purpose DMA (four V-Blanks), then the palette,
  clears `wOwlTileOffset` and puts the jump back. Why 256 bytes: V-Blank is
  4560 dots; a GDMA takes 32 dots per 16 bytes (512 for 256 bytes), and the
  level's own V-Blank work can take about 2600 dots (OAM DMA, and up to 52
  background tiles per VRAM bank from its tile queue, about 22 dots each in
  double speed). 1 KB at once (2048 dots) could overrun V-Blank with a full
  queue; Wario's own 2 KB DMA skips the queue that frame, which isn't an
  option here. If Wario's graphics are pending (`wIsDMATransferPending`),
  the chunk waits for the next V-Blank. Decompressing the slot's graphics
  again instead of saving them would need the buffer anyway, plus a frame's
  worth of CPU right then.

**How the state is kept.** `wOwlTileOffset` gets a flag, `OWL_SLOT_BORROWED`
(bit 0: a borrowed slot 1 reads `$01`, so the existing `wOwlTileOffset != 0`
checks in the draw loops take the owl's path, and there's no new check where
there's no owl; `RelocateOwlSprites` and `LoadOwlGfx` mask it off).
`wOwlSlotRestore` (WRAM0, from the padding after `wOwlCameraDisplaced`) has
`OWL_SLOT_SAVE_PENDING` until `LoadOwlGfx` has saved the slot, and the count
of chunks given back. `LoadObjectGroupData` already clears `wOwlTileOffset`
on every room load, which ends a borrow (the new room's graphics and object
data are loaded anyway); the redirected V-Blank function checks the flag and
puts the jump back by itself. `UpdateBorrowedOwlSlot` (Update Objects bank)
runs once a frame from `DrawObjects_NoPriority`'s owl path: it sees the owl
go, starts giving the slot back, and redirects the V-Blank function again
after a menu or the pause menu (they install their own, then
`LevelVBlankFunc` again, and back up and restore VRAM, so the chunks copied
so far survive). A new owl spawned while the slot is being given back takes
it over (`SetOwlTileOffset`): same slot, its objects refused again, the
backup kept, and `LoadOwlGfx` writes the owl's tiles over what was copied
back.

**Cost.** Nothing is added where there's no debug owl: the new code runs only
behind the existing `wOwlTileOffset` checks or from the debug menu's owl
paths. About 570 bytes of ROM (212 in the home bank), 1 byte of WRAM0, and
$426 bytes in unused parts of WRAM banks 1 and 3 (no code addresses them,
and they stay empty through a playthrough of Out of the Woods). While a slot
is borrowed, about 150 cycles a frame for the "gone" check; at the end, a
512 dot DMA in four V-Blanks.

**Timing.** Some of the new work happens with the LCD off (the menu's exit
draws the level's objects once, `LoadOwlGfx` saves 1 KB), which moves the
frame timing against `DIV` after a debug owl spawn, even into a free slot:
in `test_steep_canyon_debug_owl_to_next_room`, `DIV` reads one higher at the
same frame from the menu's exit on, so a coin comes out where it didn't
(`steep_canyon_column_debug_owl_grabbed`), and loading the room below the
column, with the slot saved, takes a frame longer (Owl Wario is a frame
behind in `steep_canyon_debug_owl_next_room`). Tests without a debug owl
are unchanged.

**Tests.** In `tests/test_owl_free_slot.py`:
`test_debug_owl_borrows_an_idle_slot` (Out of the Woods: slot 2 borrowed
because the spearhead is active, Applebys refused, the owl drawn from slot
2, and after letting go every slot's tiles, palettes 4-7, `wObjDataPtr01`-`13`
and the V-Blank jump exactly as the room loaded them),
`test_owl_slot_given_back_after_select` (SELECT turns Owl Wario back into
Wario, with no owl flying off), `test_owl_slot_given_back_across_the_menu`
(the debug menu opened halfway through giving it back) and
`test_new_owl_takes_the_slot_over` (a new owl spawned then, grabbed and let
go). `test_debug_owl_floor_transitions` checks that the Appleby on the
second floor isn't spawned while Owl Wario is up there (and that the
spearhead at the bottom right is drawn right, where it was owl pieces), and
that the slot's given back after he lets go;
`test_steep_canyon_debug_owl_to_next_room` that the room below the cracked
column lends slot 1 and refuses its spearheads.

**Left as it is.** Objects active when the owl borrows a slot they draw
from (all four slots in use by active objects: slot 1) keep the owl's tiles
until they go; objects that other objects spawn (projectiles) aren't
refused; and the enemies on screen when Owl Wario flies into such a room
are refused at once and only come back when Wario passes their spot again.

### Any level

`tests/test_owl_levels.py` came out of a survey of every level's start room,
by day and by night (spawn, grab, a short flight, with Wario's position
checked against the game's own blocks every frame), plus water, a boss,
saving and full object slots. Spawning, the owl's graphics and grabbing
worked everywhere; these didn't:

- **Rooms without a free camera.** Real owls only fly in rooms whose camera
  follows Wario freely. Most rooms instead move the camera a floor (128
  pixels) at a time, when Wario's movement code calls for a floor transition;
  Owl Wario's never did, so in Out of the Woods' start room he flew off the
  top of the screen (his sprites wrapping round to the bottom) with the
  camera left behind. Making him do floor transitions wasn't enough: the
  camera rests 24 pixels above a floor's top, so the screen shows from there
  to 120 pixels below it, and Owl Wario is 60 pixels tall with the owl. With
  his feet in a floor's top 36 pixels the owl was above the screen, and
  there's no floor position where he always fits.

  So in those rooms the camera follows Owl Wario instead (`OwlWarioCamera`,
  camera.asm, called from UpdateLevel when no floor transition is going on):
  it scrolls up to 4 pixels a frame to keep him and the owl 8 pixels inside
  the screen, and keeps `wFloor` on his feet. `wOwlCameraDisplaced` marks
  that it moved; once he's let go, the camera scrolls back to where floor
  transitions put it for his floor ($18 pixels above the floor's top,
  stopping at the room's edges) and the flag clears, so the original
  game, where it's never set, isn't affected. A new room clears it too.
  The room's top edge is also a ceiling for Owl Wario
  (`OwlWarioRoomTopCollision`, wario_states_4.asm): real owls only fly in
  rooms with ceilings of their own, but in The Vast Plain's start room, with
  nothing above him, he flew out of the top of the level. It stops Wario's
  body (`OWL_WARIO_BODY_HEIGHT`), not the owl: the camera can't go above the
  room, so near the top the owl he holds is above the screen. A first
  version stopped him where the owl still showed, but then he couldn't
  reach the musical coin in that room's top row
  (`test_debug_owl_reaches_the_top_of_the_room`).

  Vampire Wario's bat had the same problem (an old known bug of the debug
  menu's FORM): bats only fly in free camera rooms in the original game, so
  their states never did floor transitions. The bat is small, so the usual
  ones are enough: up a floor while it flaps up
  (`HandleUpwardsFloorTransition`), and, as for any fall, down a floor while
  falling and to the landing floor when it lands (`test_vampire.py`).
- **Boss battles.** The Temple (and every boss room) keeps the boss's
  graphics in the enemy slots; the owl's went over Rudy's face and hands.
  The menu now says `NO` while `wIsBossBattle` is set.
- **Saving.** Saving from the pause menu keeps the level's objects, so a
  spawned owl comes back on CONTINUE, but the room's graphics are loaded
  from its object group again, and the owl drew with the tiles of the
  room's slot 1 enemy. `LoadOwlGfxForOwlWario` now also loads the owl's
  graphics (into a free slot, if there is one) when an owl object is active (that only happens after a
  CONTINUE: objects are cleared before every other room load). Saving as
  Owl Wario already worked.

And one in the tests: `never_in_solid_blocks` read the level data the way
`tools/level_map.py` does, which gets some rooms wrong (Above the Clouds'
start room: solid where the game has free space, so it flagged a normal
jump). It now reads the block map in SRAM and the current room's block
function table (`Game.block_func`).

Water works like it should: spawned in water, the owl sits there until
Wario swims into it; he can jump out of the water into it, and flying into
water makes him let go. Deep underwater (with the flippers) he can even grab
it, hangs on for a moment, and lets go.

Not fixed: The Grasslands' start room is fine, but its Hebariis keep
stinging Wario before he can grab the owl, so the test only fills its object
slots. Also seen, not investigated: after opening and closing the debug menu
in the Temple's boss battle (owl or not), the arena's floor isn't drawn and
the view is shifted. That's the debug menu itself, not the owl.
