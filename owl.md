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

### Trade-off

Slot 1 and palette 4 belong to one of the room's own enemies (Prince Froggy
in The Steep Canyon's start room, a spear fish in the room below the cracked
column), which draws with the owl's tiles while they're loaded. After a
spawn, the next room change fixes it, and the spawned owl is gone by then.
After flying into a room, it lasts until the room is reloaded. Hitting that
enemy releases the owl as usual. A cleaner fix would pick a slot the room
doesn't use, but the owl's OAM and Owl Wario's frames hardcode slot 1's
tiles.
