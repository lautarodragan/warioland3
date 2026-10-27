# Game states and the main loop

The game is one loop that runs once per frame and dispatches on two bytes:
`wState`, the screen the game is in (title, map, level, pause menu...), and
`wSubState`, the step within it. This page covers the loop, V-Blank, how
code reaches other banks, and the substates a level goes through.

## Startup

`Start` (`src/home/start.asm`) records whether the console is a CGB in
`hCGB` and falls into `Init`, which is also where every reset jumps to.
`Init`:

- clears the stack, WRAM, OAM, most of HRAM and both BG maps;
- switches the CPU to double speed (`EnableDoubleSpeed`);
- copies `PushOAM` to HRAM as `hTransferVirtualOAM` (OAM DMA has to run
  from HRAM) and sets up `hCallFunc` (see [Far calls](#far-calls-and-banks));
- points `wVBlankFunc` at a `ret` (`VBlank_Ret`), enables the V-Blank
  interrupt and cartridge RAM, and checks the save (`ValidateSaveData`);
- sets the first state: `InitGameState` on a CGB, `ST_GB_INCOMPATIBLE`
  otherwise;
- starts the audio engine and enters the loop.

## The main loop

`InitWithoutDemoPowerUpReset.GameLoop`, in `src/home/start.asm`:

| Step | What |
|---|---|
| 1 | `UpdateJoypad` |
| 2 | A+B+SELECT+START held: stop the sound and `jp Init`, unless `wResetDisabled` is set |
| 3 | `MainStateTable`: run the current state for one frame |
| 4 | `UpdateRoomAnimatedTiles` if `wRoomAnimatedTilesEnabled`, `UpdateRoomAnimatedPals` if `wRoomAnimatedPalsEnabled` |
| 5 | set `wEnableVBlankFunc`, `halt`, and wait until `wVBlankFuncExecuted` |
| 6 | increment `wGlobalCounter`, clear both V-Blank flags |
| 7 | `HandleSound`: start the queued SFX and music (`hSFXID`, `hMusicID`), then `UpdateAudio` |

The animated tiles and palettes of step 4 are copied to VRAM outside V-Blank,
a few bytes per H-Blank (`wait_not_hblank`/`wait_hblank`), and only when `rLY`
shows there are enough lines left before V-Blank (20 for the tiles, 8 for the
palettes); otherwise they wait for the next frame.

## V-Blank

The interrupt vector at `$0040` jumps to `VBlank` (`src/home/header.asm`).
It does nothing unless `wEnableVBlankFunc` is set, which only happens in
step 5, after the frame's work is done. Then it saves the ROM, SRAM, WRAM
and VRAM banks, calls `wVBlankFunc`, restores the banks and sets
`wVBlankFuncExecuted`. So a frame whose work runs past V-Blank simply waits
for the next one.

`wVBlankFunc` is code in WRAM0 (`$c200`, `$200` bytes). Each state installs
its own handler by copying a short stub there: `VBlank_Level`
(`src/engine/level/vblank.asm`) copies `jp LevelVBlankFunc`. Code that needs
a different handler for a while (the fades in `src/home/fade.asm`,
`DoorTransition`) saves the 3-byte jump in `wBackupVBlankFunc` and puts it
back afterwards.

`LevelVBlankFunc` (`src/home/level_vblank.asm`) does one of two things:

- **Normally**: applies `wSCY` (plus `wSCYShake`) and `wSCX`, copies virtual
  OAM (`wVirtualOAM`, `$cc00`) with `hTransferVirtualOAM`, and writes the
  queued background tiles (see below).
- **When `wIsDMATransferPending` is set**: starts the general purpose VRAM
  DMA described by `wPendingDMA*` instead, applies the scroll and OAM, and
  empties the tile queue without writing it. `LoadWarioGfx` uses this to copy
  Wario's 128 tiles (2 KB) whenever his graphics change.

### The tile queue

Background tiles that change during play (new columns and rows as the camera
moves, redrawn blocks) are queued as BG map addresses in
`wBGMapAddressQueue`, with tile numbers in `wBGMapTileVRAM0Queue` and
attributes in `wBGMapTileVRAM1Queue`. Before V-Blank,
`SetTileQueueProcessingFunctions` writes an unrolled copy loop for exactly
that many entries into `wVBlankFunc + $10` (VRAM0) and
`wVBlankFuncExtended` (VRAM1): seven instructions per tile, generated as
opcodes (`$2a`, `$57`, ...), ending in a `jp` to `ProcessLevelTileQueue_VRAM1`
and then `ClearLevelTileQueue`. This self-modifying code is why
`wVBlankFunc` is `$200` bytes.

## Far calls and banks

Code in one ROM bank reaches another through `hCallFunc`, a small routine in
HRAM (`src/home/hcall.asm`) that saves `wROMBank`, switches to
`hCallFuncBank`, calls `hCallFuncPointer` and switches back. The macros in
`src/macros/code.asm`:

| Macro | What |
|---|---|
| `farcall Label` | set `hCallFuncBank` to `BANK(Label)` and `hcall` it |
| `hcall Label` | call through `hCallFunc` with whatever bank is in `hCallFuncBank` |
| `bankswitch` | write `a` to `wROMBank` and the MBC5 ROM bank register |
| `sramswitch` | write `a` to `wSRAMBank` and the MBC5 RAM bank register |
| `push_wram n` / `pop_wram` | switch `rWBK` to WRAM bank n and back, through the stack |
| `jumptable` | `rst JumpTable`: jump to entry `a` of the `dw` table that follows |

Always switch banks with these: `wROMBank` and `wSRAMBank` are what V-Blank
and `hCallFunc` restore. The object code expects WRAM bank 1 ("Level Objects
WRAM"), so calls into it are wrapped in `push_wram BANK("Level Objects WRAM")`.

## States

`MainStateTable` (`src/engine/main_state_table.asm`, bank `$01`) jumps on
`wState`. Most entries are short wrappers that switch the WRAM bank if needed
and `farcall` the state's own table, which jumps on `wSubState`
(`LevelStateTable` in `src/engine/level/common.asm` farcalls
`_LevelStateTable` in bank `$02`).

| `wState` | Constant | Entry | File |
|---|---|---|---|
| `$00` | `ST_TITLE` | `TitleStateTable` | `src/engine/title/state_table.asm` |
| `$01` | `ST_OVERWORLD` | `HandleOverworld` | `src/engine/overworld/common.asm` |
| `$02` | `ST_LEVEL` | `LevelStateTable` | `src/engine/level/common.asm` |
| `$03` | `ST_CLEAR` | `ClearScreenStateTable` | `src/engine/clear/common.asm` |
| `$04` | `ST_PAUSE_MENU` | `PauseMenuStateTable` | `src/engine/pause/common.asm` |
| `$05` | `ST_GOLF` | `GolfStateTable` | `src/engine/golf/common.asm` |
| `$06` | `ST_EPILOGUE` | `EpilogueStateTable` | `src/engine/overworld/epilogue/state_table.asm` |
| `$07` | `ST_ACTION_HELP` | `ActionHelpStateTable` | `src/engine/action_help/common.asm` |
| `$08` | `ST_COLLECT_KEY` | `CollectKeyDelay` | `src/engine/level/key_delay.asm` |
| `$09` | `ST_CREDITS` | `CreditsStateTable` | `src/engine/credits/common.asm` |
| `$0a` | `ST_GOLF_BUILDING` | `GolfBuildingStateTable` | `src/engine/golf_building/common.asm` |
| `$0b` | `ST_GB_INCOMPATIBLE` | `GBIncompatibleStateTable` | `src/engine/gb_incompatible/state_table.asm` |
| `$0c` | `ST_GAME_OVER` | `GameOverStateTable` | `src/engine/game_over/common.asm` |
| `$0d` | `ST_PERFECT` | `PerfectStateTable` | `src/engine/perfect/common.asm` |
| `$0e` | `ST_LANGUAGE_SELECTION` | `LanguageSelectionStateTable` | `src/engine/language_selection/state_table.asm` |
| `$0f` | `ST_DEBUG_MENU` | `DebugMenuStateTable` | `src/engine/pause/common.asm` (this fork, see [The debug menu](debug-menu.md)) |
| `$10`, `$11` | `ST_UNUSED_10/11` | `InvalidState` | resets the game |

`ST_COLLECT_KEY` isn't a screen: `CollectKeyDelay` counts 100 frames in
`wTimer` and goes back to `ST_LEVEL`, freezing the level meanwhile.

A substate routine usually advances with `inc [hl]` on `wSubState`. States
that interrupt a level (pause, debug menu, golf) save the level's substate
in `wPendingSubState`; `ReturnToPendingLevelState` (`src/home/return_level.asm`)
restores it.

## A level's substates

`_LevelStateTable` (`src/engine/level/state_table.asm`):

| `wSubState` | Routine | What |
|---|---|---|
| 0 | `SlowFadeToWhite` | fade out the map |
| 1 | `InitLevel` | LCD off, load the level and its first room, LCD on |
| 2 | `SlowFadeFromWhite` | fade in |
| 3 | `UpdateLevel` | normal play, once per frame |
| 4 | `DoorTransition` | the closing-square door effect |
| 5 | `SlowFadeToWhite` | fade out the room |
| 6 | `StartRoom_FromTransition` | LCD off, load the next room, LCD on, back to 2 |
| 7 | `ProcessMultiBlock` (`SST_LEVEL_MULTI_BLOCK`) | break a group of blocks, back to `wPendingSubState` |
| 8-15 | `DebugReset` | resets the game |

The flow:

```text
0 fade out -> 1 InitLevel -> 2 fade in -> 3 UpdateLevel
3 -> 4 door effect -> 5 fade out -> 6 next room -> 2      (doors)
3 -> 5 fade out -> 6 next room -> 2                        (pipes, exits, ladders...)
3 -> 7 multi-block -> 3
```

`TriggerRoomTransition` (`src/home/room_transition.asm`) chooses between the
first two: with `ROOMTRANSITIONF_DOOR` in `wRoomTransitionParam` it adds 1 to
`wSubState` (door effect), otherwise 2 (straight to the fade). Room
transitions are described in [Levels, rooms and doors](levels-and-rooms.md).

`SlowFadeToWhite` sets `FADE_SPEED_SLOW` (the smallest colour step, until its
counter reaches 33) and `FastFadeBGToWhite` sets `FADE_SPEED_FAST` (until 10).
Until this fork renamed them, their names had the speeds backwards. See
`src/home/fade.asm`.

### One frame of `UpdateLevel`

`UpdateLevel` (`src/engine/level/update_level.asm`) has three versions of the
frame, one per camera type (see [Camera and scrolling](camera.md)). They do
the same work in the same order:

1. `UpdateParticles`
2. `UpdateWarioStates` (skipped during a floor transition), then copy the
   camera position (`wCameraSCY`/`wCameraSCX`) to `wSCY`/`wSCX`
3. `UpdateObjects`
4. `SetWarioScreenPos`
5. `ProcessInteractions`: Wario against each object
6. draw: `DrawObjects_WithPriority`, `DrawWario`, `DrawObjects_NoPriority`,
   `ClearUnusedVirtualOAM`
7. the camera: floor transition step, `LevelScroll_Vertical`,
   `LevelScroll_Horizontal`
8. `UpdateLevelEdges` and `ProcessBlockRedrawQueue` fill the tile queue,
   `SetTileQueueProcessingFunctions` turns it into V-Blank code
9. end of level, multi-block, `TickLevelTime`, then START (pause) and, in this
   fork, SELECT (debug menu)

In the floor-transition version, step 5 runs with WRAM bank 1 pushed; the
other two versions call `ProcessInteractions` without `push_wram`. That works
because the level runs with `rWBK` at 0, which selects bank 1 anyway.

Step 9 checks `wLevelEndScreen`: when it's set (and bit 7 is clear), the
level ends. `LVLEND_GAME_OVER` and `LVLEND_EPILOGUE` go to `ST_EPILOGUE`
with a transition parameter; anything else goes to `ST_CLEAR`
(`SST_CLEAR_TIME_ATTACK` in time attack). A non-zero `wMultiBlockParam`
switches to substate 7 for one frame. START opens the pause menu, except
when Wario is blind (`TRANSFORMATION_BLIND`) or in a boss battle
(`wIsBossBattle`); then it plays `SFX_ERROR`. Pause and debug menu are only
checked when no floor or room transition is pending.

## Leaving and re-entering a level

| From | To | How |
|---|---|---|
| map | level | `HandleOverworld` sees `wState == ST_LEVEL`, calls `SelectLevel` to pick the variant |
| level | pause menu / debug menu | `UpdateLevel` saves `wSubState` in `wPendingSubState` |
| pause menu / debug menu | level | `ReturnToPendingLevelState` |
| level | golf | `StartRoom_FromTransition` with `ROOMTRANSITION_GOLF`, saves `wPendingSubState`, `ST_GOLF` |
| golf | level | `ReturnToLevelFromGolf`: restores VRAM (`LoadBackupVRAM`), turns `wRoomTransitionParam` into `ROOMTRANSITION_DOOR` and returns to the pending substate, `StartRoom_FromTransition`, which reloads the room |
| pause menu | map | the map option: `ReturnToMapFromLevel` (sets bit 7 of `wDayNight`, see [Levels, rooms and doors](levels-and-rooms.md#day-and-night)) |
| clear screen | map | the clear screen's own code (`src/engine/clear/`), with `TRANSITION_RETURN_TO_MAP` |
