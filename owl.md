# Debug Menu OWL Feature — Notes

Attempted feature: add an **OWL** entry to the debug menu that spawns a
carryable owl object next to Wario. The feature was reverted because
grabbing the spawned owl caused permanent, level-wide graphics/collision
corruption that persisted across level exits. Root cause was never fully
confirmed; notes below capture what was tried and what was learned.

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
