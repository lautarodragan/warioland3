# Naming survey: unnamed labels and proposed names

Research notes for renaming unnamed labels in this disassembly. Nothing in the
code has been changed; every entry below is a proposal for a human to accept
or reject.

## Applied

The high- and medium-confidence proposals of all four passes have been
applied (and the fifth pass, applied as it went) to the code, one commit per batch, each checked by building: every
batch left the ROM byte-identical, and the emulator tests passed.

| Batch | What | Renames |
|---|---|---|
| 1 | Phase 1 RAM: level, save, audio, SRAM/HRAM, `w1d`/`w2d` | 186 |
| 2 | Phase 2 home routines and far targets, `COLLISION_*` (+ `_F`) | 183 |
| 3 | Phase 3 camera, scrolling, rooms, save code, interactions | 123 |
| 3b | `FLOOR_TRANSITION_UP`/`DOWN` swapped (with `.transition_down`) | 4 |
| 4 | Phase 4 Wario states, block functions (multi-block families from each entry's `ld b, $NN`), `UpdateState_Fan*` | 242 |
| 5 | Phase 5 `obj_struct`/`scene_obj_struct` fields, audio offsets, scene Wario gfx | 35 |
| 6 | Phase 6 object state locals (repeats in one routine get an `_<addr>` suffix) | 756 |
| 7 | Second pass: overworld, audio engine, action help (302), `RoomPalsNNN` (146), per-level `...RoomHeaders` (119) | 699 |
| 8 | Third pass: overworld, cutscene rules, boss phases, map-side states, owner-prefix data (1406) | 1998 |
| 9 | Fourth pass 4.0: the comma lists applied as one name (hand `.Rise6`/`.Sink4`, Nobiiru `.Extend5`/`.Retract5`, right hand `.DefeatSink`) and the rest of each list; `Func_ae915` at $ad557 -> `AdvanceStepAtHL_Bank2b1`; the table of unapplied proposals | 86 |
| 10 | Fourth pass 4a/4b: overworld `Func_` (bank2b_1/2, bank20/21/26/27, bank2d, bank56, init) and scene-local `.Func_` (R2 `.StateXX`, wait steps, step legend, sound helpers, `.update_obj`), overworld data of the 4a rows | 1245 |
| 11 | Fourth pass 4c: data labels, descriptive and rules P, S, O, W, U (medium lines only) | 846 |
| 12 | Fourth pass 4d: `UpdateCutsceneObjs_CutTree`, `UpdateTempleSceneObjs_Back`, `wGolfBuildingCourseAttrMap`, bank2d's `.Wait<N>` by frames | 54 |
| 13 | Fourth pass 4e: routines outside the overworld, `BlockFunc_`, `VBlank_`, `Text_`, `UnreferencedLCDFunc_` (the test tools' `187b0`/`187de`/`188ba` block function keys follow) | 112 |
| 14 | RAM mislabels: wrong-bank and wrong-union label uses, the structural RAM rows (path tracers, boss union, `wShotYVel`, palette fade fields, OW animation slots) and scene aliases for borrowed bytes; see "RAM mislabels applied" below | ~90 uses, ~150 new labels |
| 15 | Fifth pass 5a: the remaining address-named routines and `.Func_` locals; the swapped `ObjCheckFloorOrStandingFall` trampoline name | 64 |
| 16 | Fifth pass 5b: the remaining referenced data; literal Jamano frameset and Count Richtertoffen pointers written as labels, the temple's wrong-bank OAM label | 44 |
| 17 | Fifth pass 5c: unreferenced data as `Unreferenced<Owner><Kind>_<addr>`, with corrected owners | 131 |
| 18 | Duplicates merged (changes the ROM): `Func_ac00b`/`ac016` into `UpdateSceneObjAnim_CreditsOAM`, `Func_ac047`/`ac04c` into `LoadSceneObjSpriteWithScroll_CreditsOAM`, `Func_aca6d` into `AdvanceTempleOWStep`, `Func_19246` into `StartMultiBlockBreak`, `Func_19bce` into `ProcessBlockToB` (was `Func_19b5c`). Bank `$20`'s `Func_82c1d`/`82c22`/`82c29`/`82a8d` kept (copies of bank `$2d` routines, reached by `jr` and fallthroughs) and named `WaitOWFunc_Bank20`, `AdvanceOWFunc_Bank20`, `EndOWFunc_Bank20`, `AdvanceOWFunc_UnlockLevel` | 7 merged, 4 named |
| 19 | Sixth pass, RAM: the last address-named RAM labels (scene object scripts, VRAM backup buffers, golf, time attack, envelope, prologue particles) and the cutscene overlay sprites; see "Sixth pass: remaining RAM labels" | 44 |
| 20 | Sixth pass, objects: 49 `OBJSTATE_*` (+3 aliases), 20 `OBJ_INTERACTION_*`, 9 `OBJACTION_*` and the labels named after their numbers; see "Sixth pass: object states and interactions" | 81 |
| 21 | Sixth pass, sound effects: 151 `SFX_*` constants, their sound data labels and the code labels named after their numbers; see "Sixth pass: sound effects" | 151 |
| 22 | Sixth pass, substates and other constants: `SST_*`, audio commands, flags and struct fields, `GRAB_PICK_UP_BLOCKED`, `ROOMTRANSITION_*`, `EVENT_NONE`, `unk` gfx files; see "Sixth pass: substates and other constants" | ~45 |
| 23 | Sound effects named by owner and order (one scene or object each), e.g. `SFX_VOLCANO_ERUPTION_1`..`6` | 40 |
| 24 | Object state, action and interaction literals written as constants (972 lines), object-local aliases for `OBJSTATE_5A`-`5C`; see "Object state literals" | 972 |
| 25 | Sound effects named by ear from recordings: `SFX_TIPTOE_1`..`3`, `SFX_PAGE_TURN`, `SFX_ACTION_B`, `SFX_TURN`, `SFX_PESCE_3_YB_2`, `SFX_TIPTOE_2_B_UNUSED` | 8 |
| 26 | More sound effects named by ear: `SFX_BIG_OCTO_1`/`2`, `SFX_CHOP_TREE` | 3 |

Also fixed: the literal update-function pointers (togeba, seeing eye door)
and data tables addressed by literal (bubble, coin).

Deviations from the rows below: the per-level room tables are
`<Level>...RoomHeaders` (upstream's "room header" term) instead of
`...Rooms`; locals that would repeat within one routine got their address
as a suffix (`.Default_4d7dc`).

**Not applied** (still proposals):
- low-confidence rows and "unclear"/"not named" entries (among them the
  generic `w2d150`..`wd156` scene variables and the `w2d122`..`w2d13f`
  scene task pairs);
- identical routines (`Func_19246`, `Func_82c1d`/`82c22`/`82c29`,
  `Func_ac00b`/`ac016`...): merging them is a separate decision;
- the map-side state entries' frameset-based names, and everything listed
  as pending in Progress.

### RAM mislabels applied (batch 14)

Every case below was checked in the code first. No byte moved: each use
got a label at its own address (a `UNION`/`NEXTU` member, an alias, or a
struct field), the ROM stayed byte-identical and the `.sym` file shows
no address change (only `wPalFade*Current`, which now names offset 5,
see below). Commits on branch `claude/ram-mislabels-dh93t5`.

Wrong-bank uses (code running with WRAM bank 2 using a label of another
bank at the same address):

| Where | Was | Now |
|---|---|---|
| bank2b_1 (after the next-objective text) | `w1d140`, `wDollBoyNoFlashingBarrel` | `wSceneWarioYCoord`, `wSceneWarioXCoord` (`w1d140` removed) |
| `_InitBestTimeList` | `wObj1SubState` | `wCurMapSide` |
| `LoadBGMapsToWRAM` (init.asm) | `wBackupSCY` (bank 3) | `wTilemap`: the first pass took this for a deliberate reuse, but the routine decompresses the attrmap to `wAttrmap` and the tilemap right after, to `wTilemap` (same `$d500` in bank 2) |

Path preview and `$d140` union:

| Was | Now |
|---|---|
| `w2d800`..`w2d860` (`ow_unk_struct`) | `wOWPathTracer1`..`4` (`ow_path_tracer_struct`: sprite bytes, `SpriteState`, `TracerState`, `Counter`, `LineState`, `Coords`), `wOWPathTracers` |
| `wCurOWPathTracer + $0..$8` | `wCurOWPathTracer` fields (`ow_path_tracer_head_struct`); `+ $9` is `wPathPreviewPathsPtr` |
| `wDayNightTransistionSteps`, `wPalFade1Colour1BlueUnk3`, `...3RedUnk3`, `...4GreenUnk3` in `UpdatePathPreviewAnimations` | `wOWPathTracer1`..`4SpriteState` |
| `wd156`, `w2d15e`, `w2d160`, `w2d166`..`w2d17e` in the path preview | `wOWUIObj3`..`8` (the 8 preview sprites, `$d140`-`$d17f`); the `w2d15e`.. labels are gone |
| `wCurOWPathTracer` in the prologue/temple fades | `wPrologueFadeType` |
| `wOWUIObj1*`/`wOWUIObj2YCoord`/`Duration` in the epilogue, the golf building and `MoveSceneWarioLeft` | `wSceneWario*`, `wSceneWarioStateGroup`, `wSceneWarioSFXCounter` |
| `wOWUIObj1*`/`wOWUIObj2*` in the map-side scenes (bank2d), and `wSceneWarioMovementStep` in the east volcano | `wOWSceneShakeState`/`StateCounter`/`Step`/`StepCounter`, `wOWSceneRocksStep`/`Counter`, `wOWSceneRockLauncherStep`/`Counter`, `wOWScenePalFadeStep`/`Counter`/`Index`, `wOWSceneSFXLoopActive`/`Counter` |
| `wOWUIObj1`/`2`, `w2d150`..`wd156` in the freeze-sea scene and `CopyOWTileColumn1`-`3` | `wOWTileColumnCopy1`..`3` (`ow_tile_column_copy_struct`: `Counter`, `ListPtr`, `RowsLeft`, `Dest`, `Source`) |

The `$d800` union of WRAM2 (`wOWSharedRAM`):

| Was | Now |
|---|---|
| `wCollectionRow` written with `$08` (bank27 x10, epilogue) | `wLCDCFlagsToFlip` (and `LCDC_BG_9C00`) |
| `wPalFade7Colour3RedUnk1`/`Sign` (epilogue old man) | `wCurTextBufferPage`/`Line` (existing labels, same address) |
| `wPalFade2Colour2GreenUnk1` (epilogue Wario fall) | `wSceneSubActive` (existing, the prologue's bounce uses it the same way) |
| `wPalFade2Colour4GreenSign`, `wTempleRock5Action`/`Counter` (epilogue) | `wEpilogueMusicBoxFallActive`/`Step`/`Counter` |
| `wTempleMusicBox1`/`3`/`4`/`5*`, `wPlanePart2Counter`, `wPalFade2Colour3GreenUnk1` (bank56) | `wTransformationSparkle1`..`4Step`/`Counter` |
| `wPalFade1` bytes (Cutscene14) | `wCutscene14Obj2`/`3`/`4WobblePtr` |
| `wCollectionLinkStateCounter`/`ScrollMode` (`CutsceneScreenShake`) | `wCutsceneShakeStep`/`Counter` |
| `wColourFadeDiff` in cutscene steps (not in the survey) | `wCutsceneSFXCounter` |
| collection labels and `wColourFadeDiff` (best time list) | `wBestTimeListAutoScroll`/`IdleCounter`/`ScrollStep`/`ScrollCounter`; its `$800`-byte clear starts at `wOWSharedRAM` |
| `wPalFade6Colour2GreenCurrent`/`Target`/`Sign` (golf building) | `wOWGolfBuildingScene`/`Step`/`StepCounter` |

Other:

| Was | Now |
|---|---|
| `colour_part_fade_struct` `Current`, `Unk1`, `Unk2`, `Unk3`/`Unk4` | `Base`, `Accumulator`, `Current`, `ds 2` (as `COLOURFADESTRUCT_*`; `UNK_3`/`UNK_4` became a `const_skip`) |
| `wSceneObj1YCoord` in bank27 | `wCutsceneOverlayType` (a `UNION` with `wSceneObj1`) |
| `w1dc4f` | gone: `wShotYVel` is a `dw` |
| `wGolfPinFlagTiles` in `VBlank_GolfCourseMenu_CourseAttrs` | `wGolfCourseTileMap` |
| boss union: Doll Boy's/Jamano's names in other bosses, `ds $1` | `wJamanoDarkness`, `wMuddeeHitState`, `wPesceFlyActive`/`Hits`/`FightOver`, `wScowlerBlackoutTimer`/`InkTimer`, `wYellowBellyHeadHit`/`HitRequest`/`PumpOut` (the 3d table) |
| `w2d032`..`w2d043`, `w2d046`..`w2d048` | `ow_anim_struct`s: `wOWBigCloud1`..`4Anim`, `wOWSeaAnim`, `wOWSmallCloudsAnim`, `wOWCliffsAnim` |
| `w2dffd`..`w2dfff` | aliases `wEventTreasure3`..`1`, `wMissingTreasureSavedOWLevel`/`Level`/`NumLevels`, `wCollectionCurCell`/`CurTreasure`, `wBestTimeListCurLevel`, `wBGMapsTempBank` |
| `w2d121` (write-only) | `wUnused_2d121` |

All of these are harmless sharing: the bytes were the right bytes, only
the names were another variable's. No case was a real bug (a routine
reading a variable it didn't mean). Not done: the literal pointers into
`Data_9ef82` that Cutscene14 stores in its wobble pointers (ROM labels,
left to the ROM naming work), and the `DrawCutsceneOverlayFrame*` writes
into `wCurSceneObj` bytes.

## Upstream renames since the survey

The survey was written against f205aa3. Merging the upstream disassembly's
August 2026 commits renamed a few of the labels it covers:

- `wca65` is now `wWarioFrame`, `wca66` is `wWarioAttributes` (the entries
  below proposed `wWarioSpriteFrame` / `wWarioSpriteAttributes`), and `wca6c`
  is `wUnused_ca6c`, as proposed.
- The per-level room tables `LevelRooms_xxxxx` are now `LevelHeaders_xxxxx`
  (same address suffixes), and their entries use the `room_header` macro;
  the bulk names proposed for them still apply.
- Also renamed upstream, not in the survey: `UpdateAnimation` ->
  `UpdateWarioAnimation`, `wAnimationEnded`/`wOAMBank`/`wOAMPtr`/
  `wFramesetPtr` -> `wWario*`, `wWarioTransformationProgress` ->
  `wTransformationProgress`, `wUnused_ccef` -> `wUnused_ObjectParity`.

## Progress

- [x] Inventory and plan (this section and the two below)
- [x] Phase 1: WRAM / SRAM / HRAM unnamed variables (all 88 address-named labels; `wUnused_*` left as is)
- [x] Phase 2: home bank (`src/home/`) `Func_` routines (all 72), incl. the bank $18 targets of the `homejp` trampolines, the block-probe family in collisions.asm, and the object Y-velocity tables
- [x] Phase 3: fork focus areas: camera/floor transitions (incl. the swapped `FLOOR_TRANSITION_*` flags), level scrolling, room start, save code, pause tilemap, object interaction handlers `OBJ_INTERACTION_00`-`0B`. Debug menu and owl code have no unnamed labels left. Interaction handlers for `OBJ_INTERACTION_31`+ added afterwards. Not done: most local `.asm_` labels of validate_save.asm.
- [x] Phase 4: rest of the level engine: Wario state helpers (wario_states_1..4.asm, ~95 routines) and block_functions.asm (the multi-block families cover most of its 117 `Func_` + 58 `BlockFunc_`). The `OBJ_INTERACTION_31`+ handlers are in the Phase 3 section; left over in object_interactions.asm: `Func_2126a`, `Func_2168b`, `Func_20b41`.
- [x] Phase 5: `unk` fields in structs and constants (object struct, collision flags, scene objects, scene Wario gfx, grab state; audio `CHANNEL_UNK_*`/`TRACK_UNK*` and palette-fade `Unk1/3` not done)
- [~] Phase 6: object-local `.Func_` states: the 16 objects with full positional state tables (475 labels, mechanical); the other object files' `.Func_` locals (~360) not done (continued in the second pass, 2d)
- [~] Phase 7+: overworld started (the 8 most-referenced routines); action help, data/framesets/OAM/palettes, audio, `w1d`/`w2d` RAM not started (continued in the second pass, 2a-2f)

**Second pass (branch `claude/naming-survey-2-dh93t5`), plan in this order:**

- [x] 2a. `w1dXXX` RAM (36: Hidden Figure, boss union, golf) and `w2dXXX` RAM (138: overworld), all accesses grepped; plus a scan for WRAMX labels used with the wrong WRAM bank (4 finds). Hidden Figure's object code read in full on the way (Phase 6 leftover).
- [~] 2b. Phase 7 overworld: top-level OW states, step/fade/sprite helpers, the map-side object system (bank2d, with a bulk rule for its ~150 state entries) and `Func_ae915` done. Not done: the other `Func_` with 4-8 refs (`Func_b69a6`, `Func_9a78e`, `Func_b7984`, `Func_b71fc`, `Func_b4143`, `Func_85a91`, `Func_9fb53`/`Func_9fb97`, `Func_b7a6d`, `Func_b542e`, `Func_b5114`), the rest of bank20/21/26/27/2b/2d/56 `Func_` (~420), and the scene-local `.Func_` (~1200).
- [x] 2c. Small leftovers: `Func_2126a`, `Func_2168b`, `Func_20b41`; validate_save.asm locals; palette-fade `Unk1/3` (the macro's field names are off by position); audio `CHANNEL_UNK_*`/`TRACK_UNK*`.
- [x] 2d. Phase 6 leftovers: every object file now has rows; 3 literal update-function pointers found on the way; `AnonsterSilkFunc`'s full state table (missed by the first pass) added. Left unnamed on purpose (listed as "not named" in the rows, ~75 labels): the middle fight phases of anonster.asm, muddee.asm, omodonmeka.asm, scowler.asm, yellow_belly.asm, plus a few unclear helpers in bubble/haridama/snake.
- [x] 2e. Audio engine `Func_` routines; action help demos (bulk rule covering all 302 `Func_`, plus the 4 common ones).
- [~] 2f. Bulk data: `RoomPals###` (146 `Pals_`) and `LevelRooms_` (119) generated; framesets/OAM/other palettes/`Data_` only counted, with an owner-prefix rule suggested.

**Third pass (branch `claude/naming-survey-3-dh93t5`), plan in this order.**
Rows go in a new "Third pass" section at the end; existing rows are left
untouched (mistakes found in them go in a "Corrections" note there), and
everything is named by its current master label, since the earlier
proposals are being applied on another branch.

- [x] 3a. Phase 7: the overworld `Func_` with 4-8 references from 2b (`Func_b69a6`, `Func_9a78e`, `Func_b7984`, `Func_b71fc`, `Func_b4143`, `Func_85a91`, `Func_9fb53`/`Func_9fb97`, `Func_b7a6d`, `Func_b542e`, `Func_b5114`).
- [x] 3b. bank27's per-cutscene object updaters (`Func_9f0e0`...): bulk rule. Also bulk rules for the cutscene step tables (`.PlayCutscene`), the wait steps in bank27/bank2d (109 `.WaitN`) and the per-OW-function object init routines in bank2d (45).
- [x] 3c. Boss middle phases left "not named" in 2d: anonster, muddee, omodonmeka, scowler, yellow_belly, and the unclear helpers in bubble/haridama/snake (phase jumptables read in full).
- [x] 3d. Boss union: per-boss names for bytes 0-3 of the `w1d146` union.
- [x] 3e. Data: owner-prefix rule for `Frameset_`/`OAM_`/other `Pals_`/`Data_`, generated where the owner is unambiguous (1406 labels; ~1150 shared ones left).
- [~] 3f. The rest of bank20/21/26/27/2b/2d/56 `Func_` and scene-local `.Func_`, in bulk where a mechanical rule is reliable, then by value. Done: map-side state entries (139, by slot), bank20's map-side loop / temple hint / path preview / scene actions / `UnlockLevel` (~75); bank21's last 3, bank26, part of bank2b_1 (~45); bank27 cutscene set-up (19 by rule + 8).

**Status:** first pass: about 430 table rows (~650 labels) plus 475
mechanical object state names. Second pass (everything under "Second
pass" below): about 330 table rows, roughly 205 high, 100 medium, 12 low
confidence (plus a few "not named" notes); counting the rows that cover
several labels and the bulk rules (action help 302, room palettes 146,
level room tables 119, map-side object states ~150) it covers roughly
1500 labels. Every proposed global name was checked with a script against
`src/` and this file.

**Third pass status:** about 90 table rows (roughly 45 high, 40 medium,
5 low) plus bulk rules; together about 700 code labels (cutscene step
tables 40, updaters 48, wait steps 109, per-OW-function inits 45, cutscene
object inits 19, map-side state entries 139, boss locals ~120, bank20/21/
26/27/2b_1 routines ~150, union bytes) and 1406 data labels by the
owner-prefix rule. All new global names checked by script against `src/`
and the earlier sections.

**Resume at** (in this order):
1. 3f, overworld `Func_` still unnamed: bank2b_2 (~45, prologue internals:
   `Func_ae9d0`/`ae9da`/`ae9e4` move scene object 3 along movement data,
   `Func_ae9ee` plane part 2 actions, `Func_ae2ed`.. the `w2d8b0` steps),
   bank2b_1 (~15 left), bank2d (~20: the per-state map animation handlers
   `Func_b7ac0`.. `Func_b7cb3`, `Func_b4082`, `Func_b4874`), bank56
   (`Func_15848a`, `Func_1580c8`), bank20 leftovers (`Func_812b0`,
   `Func_819c6`, top-bar helpers `Func_824f1`/`8250a`/`82521`/`8269f`).
2. Scene-local `.Func_` (~1200 minus the ~200 covered by the wait and
   `.PlayCutscene` rules): the next mechanical candidates are the 14
   `ret`-only locals (`.DoNothing`) and the set-object-state-then-advance
   steps; otherwise per scene, starting with bank27's cutscene steps.
3. Data not covered by the owner rule (~1150 labels shared by several files
   or routines; Wario framesets used by several states; OAM tables shared
   through object_data.asm), then descriptive names per object/scene.
4. Optional consistency renames noted in passing: `OWCutTree` ->
   `UpdateCutsceneObjs_CutTree`, bank2d's `.Wait1`..`.Wait4` -> frames.

**Fourth pass (branch `claude/naming-survey-4-dh93t5`), plan in this order.**
Rows go in a new "Fourth pass" section at the end; earlier rows are left
untouched (corrections go in notes there). Labels are named by their
current label in `src/` (the first three passes' high/medium proposals are
applied, so this pass works from a fresh grep: at its start `src/` had 240
`Func_`, 1131 `.Func_`, 712 `Frameset_`, 139 `OAM_`, 167 `Pals_`, 68
`Data_` address-named definitions).

- [x] 4a. Overworld `Func_` still address-named: bank2b_2 (47), bank2d (24),
  bank20 (19), bank27 (17), bank2b_1 (12), bank26 (7), init.asm (7),
  bank56 (3), all done together with their data. Also 4.0: leftovers of the
  applied batches (mis-applied comma lists, unapplied rows).
- [x] 4b. Scene-local `.Func_`: done with 4a, scene by scene (the 4a
  tables), with mechanical rules where they hold: R2 scene object state
  tables `.StateXX`/`.None` (70), wait steps `.Wait<N>` (27), cutscene step
  legend (`.ShowItem`, `.WaitThen<Action>`, `.SetObjNState<NN>`,
  `.FadeEvery<N>Frames`, ...; 148), sound helpers (30), `.update_obj` (15),
  tilemap patches (18).
- [x] 4c. Data still address-named: all 987 labels, by rules P (palette
  loaders), S (show routines), O (single owner), W (shared Wario graphics),
  U (unreferenced, by neighbours), plus descriptive names for the overworld
  palettes, object movement tables and shared labels.
- [x] 4d. The optional consistency renames of the third pass (and all of
  bank2d's ordinal `.Wait1`.. locals, 51).
- [x] 4e. Not on the list but still address-named: the other `Func_`
  outside the overworld (clear, credits, game over, golf, title, level,
  ~95), 12 `BlockFunc_`, 14 `VBlank_`, 8 `Text_`, 2 `UnreferencedLCD_`.
- [x] Findings of the fourth pass collected in their own section at the end.

**Fourth pass status:** 2401 labels proposed (1620 high, 637 medium, 144
low) plus the 4.0 table (about 30 rows carried over from earlier passes).
Code labels 1358 (by hand 1050; by rule 308: cutscene step legend 148,
`.StateXX` 70, sound helpers 30, `.Wait<N>` 27, tilemap patches 18,
`.update_obj` 15); data 989 (descriptive 101, P 24, O 444, W 95, S 38, U
287); 4d 54. All new global names checked by script against `src/` and the
earlier sections; locals checked for uniqueness in their scope.

**What is left:** no address-named `Func_`, `.Func_`, `Frameset_`, `OAM_`,
`Pals_`, `Data_`, `BlockFunc_`, `VBlank_` or `Text_` label in `src/` is
without a proposal in one of the four passes (checked by script). Left
open on purpose, with the reason in their rows: the low-confidence names
(the earlier passes' snake/Pneumo locals; in this pass 144, mostly
unreferenced framesets whose owner only comes from their neighbours), the
"not named" notes of the first passes; the duplicates listed in the
findings (`Func_ce3e`, the bank20 copies, `Data_60510`) are named but
would better be merged. The `.asm_` jump labels were not part of this survey.
Next step: replacing the generated `<Owner><Kind>_<addr>` data names
with descriptive ones where wanted.

**RAM mislabels applied** (batch 14, branch `claude/ram-mislabels-dh93t5`):
every wrong-bank and wrong-union case of the four passes and the
structural RAM rows, listed in "RAM mislabels applied" above; one more
wrong-bank use found by re-running the scan (`LoadBGMapsToWRAM`).

**Fourth pass applied** (batches 9-13 in "Applied", branch
`claude/naming-apply-4-dh93t5`): every high and medium name of 4.0, 4a/4b,
4c, 4d and 4e, 2343 renames in all (4.0 86, 4a 1245, 4c 846, 4d 54, 4e
112), including the high/medium exceptions inside low rows
(`HiddenFigureOAM_18c88a`, `SpearheadOAM_18007b`) and the medium/high names
of mixed rows. Not applied: the 144 low names (143 in 4c: the
`UnreferencedXxx (low)` lines and low descriptive rows/exceptions; 1 in 4e:
`BlockFunc_Transition8Door`), and what 4.0 lists as "not carried over"
(low rows and duplicates of earlier passes). No routine or table was
merged and the Cutscene4c `.WaitObj2State03` oddity is left as it is.
Every batch built to a byte-identical ROM and the emulator tests pass.

**Fifth pass (branch `claude/naming-low-dh93t5`)**, rows in "Fifth
pass" at the end, applied as batches 15-17:

- [x] 5a. The 50 `Func_`, 20 `.Func_` and 5 `BlockFunc_` still
  address-named, re-read: 61 named (with `Data_1f894`, read with its
  routine), 14 duplicates left for the merge.
- [x] 5b. Referenced data (OAM, framesets, palettes, movement tables):
  37, plus 7 `Unreferenced...` labels that literal pointers use.
- [x] 5c. Unreferenced data: 131, owners checked against the OAM
  tables' frame counts; 5 fourth-pass owner guesses corrected.

**Fifth pass status:** 239 renames (52 high, 187 medium), every batch
byte-identical, emulator tests pass. Address-named labels left in `src/`
(not counting `.asm_`): the 14 duplicate routines listed in the Fifth
pass section.

## Inventory (master at f205aa3)

Counts are label *definitions* found by a scan of `src/**/*.asm|inc` for
`Prefix_<4-6 hex digits>` and address-named RAM (`wXXXX`, `w3dXXX`, `s0aXXX`,
`hffXX`). Scanner: a throwaway Python script, not committed.

| Category | Count | Where (largest areas) |
|---|---:|---|
| `.asm_xxxxx` local labels | 3861 | level/objects 1730, level 1167, overworld 503, action_help 213, pause 67, golf 62, audio 46 |
| `.Func_xxxxx` local sub-routines (object/scene state functions) | 2078 | overworld 1224 (bank27 441, bank2d 314, bank2b_2 209, bank2b_1 120, bank56 87), level/objects 835 |
| `Frameset_xxxxx` | 1954 | gfx/oam/object_framesets 938, overworld oam_1/oam_2 370, wario1-3 349, credits 100, golf 43 |
| `Func_xxxxx` global routines | 1422 | overworld 596 (bank2d 254, bank27 102, bank20 88, bank2b 99), level 359, action_help 306, home 62, audio 23, level/objects 22, golf 16, clear 14 |
| `Pals_xxxxx` (+3 local) | 348 | data/levels/palettes 146, overworld cutscene palettes 68, overworld palettes 43 |
| `OAM_xxxxx` | 197 | gfx/oam objects1-3 58, wario1-2 31, overworld oam 57 |
| `Data_xxxxx` | 187 | data/object_movements 105, src/level.asm 24, overworld bank21 19 |
| `LevelRooms_xxxxx` | 119 | data/levels (per-level room tables) |
| `BlockFunc_xxxxx` | 58 | engine/level/block_functions.asm |
| `VBlank_xxxxx` | 14 | golf 11, action_help, credits, overworld |
| `Text_xxxxx` | 8 | src/overworld.asm |
| 3-digit `Func_xxx` (home) / `Sfx_xxx` / `VBlank_xxx` / `.asm_xxx` | 10 / 212 / 2 / 25 | home / audio/sfx / ... |
| `.data_` / `.do_` / misc local hex labels | ~12 | overworld |
| `PointerTable_xxxxx`, `UnreferencedLCD_xxxxx`, `Tilemap_xxxxx` | 5 | audio, overworld |
| WRAM `wcXXX`/`wdXXX`/`w3dXXX` | 55 | src/ram/wram.asm |
| WRAM `w1dXXX` / `w2dXXX` (golf / overworld banks) / `w4d000`..`w7d000` | 36 / 138 / 4 | src/ram/wram.asm |
| SRAM `s0aXXX`, `s2a000`, `s3a000` | 25 | src/ram/sram.asm |
| HRAM `hffXX` | 2 | src/ram/hram.asm |
| `wUnused_`/`hUnused_` | 6 | src/ram |
| Identifiers containing `unk`/`Unk`/`UNK` | ~150 distinct | `OBJ_UNK_01/02/1D`, `wCurObjUnk01/02/1d`, `OBJSUBFLAG_UNK_4`, `COLLISION_UNK1..7`, audio `CHANNEL_UNK_*`/`TRACK_UNK*`, scene `*Unk7`, `WarioUnk2..5Gfx`, palette fade `*Unk1/3` |

Most-referenced unnamed routines (references / distinct referencing files):

| Label | Refs | Files | Location |
|---|---:|---:|---|
| `Func_3513` | 136 | 34 | src/home/object_mechanics.asm |
| `Func_b791d` | 127 | 1 | src/engine/overworld/bank2d.asm |
| `Func_352b` | 66 | 30 | src/home/object_mechanics.asm |
| `Func_ae1ce` | 55 | 1 | src/engine/overworld/bank2b_2.asm |
| `Func_9ccf9`, `Func_9f0a5/ae/bc` | 40-43 | 1 | src/engine/overworld/bank27.asm |
| `Func_3407`, `Func_3317`, `Func_33f8`, `Func_3326`, ... (~40 `homejp` trampolines) | 16-38 | 13-25 | src/home/object_mechanics.asm |
| `Func_2022c` | 35 | 1 | src/engine/level/object_interactions.asm |
| `Func_18f32` | 28 | 1 | src/engine/level/block_functions.asm |
| `Func_197b1`, `Func_19741` | 17-18 | 6 | src/engine/level/collisions.asm |

## Plan

Order is by value: how many places a name would clarify, and how close the
code is to what this fork works on.

1. **RAM variables (WRAM/SRAM/HRAM, ~88).** Small, high leverage: every
   routine that touches them reads better. Done by grepping all accesses.
2. **Home bank `Func_` (62) and their far targets.** Home routines are called
   from everywhere. Most of `src/home/object_mechanics.asm` is `homejp`
   trampolines (`Func_3191:: homejp Func_62e8f`) to bank $18 in
   `src/engine/level/update_objects.asm`; each pair is named together
   (`Foo::` in home, `_Foo::` in bank $18, as the existing `ObjState_Fall` /
   `_ObjState_Fall` pair does).
3. **Fork focus areas:** `src/engine/level/camera.asm`,
   `src/home/floor_transition.asm`, room loading (`src/home/load_room.asm`,
   `src/engine/level/start_room.asm`, door/room transitions), save code
   (`src/engine/pause/save/`), debug menu, owl / object interactions
   (`src/engine/level/object_interactions.asm`, `update_objects.asm`,
   `collisions.asm`).
4. **Rest of the level engine:** `wario_states_1..4.asm`, `block_functions.asm`
   (117 `Func_` + 58 `BlockFunc_`), `scroll.asm`, `block_queue.asm`.
5. **`unk` struct fields and constants** (`OBJ_UNK_*`, `OBJSUBFLAG_UNK_4`,
   `COLLISION_UNK*`), once the code that uses them has been read.
6. **Object-local `.Func_` states** (835 in level/objects): named per object
   as `.Walk`, `.Turn`, etc., where the state is clear.
7. **Lower priority:** overworld banks (596 `Func_`, 1224 `.Func_`; mostly
   cutscene/scene scripting), action help demos (306 `Func_`, scripted
   input for the power-up help screens), audio engine, `Data_`/`Pals_`/
   `Frameset_`/`OAM_` (named in bulk from the object or scene that uses them).
   `.asm_` locals only where they clarify a routine already analysed.

## Conventions used for proposals

- Routines: `VerbNoun` in PascalCase (`HandleUpwardsFloorTransition`,
  `SetState_OwlWario`, `UpdateState_BatFlying`); home/far pairs as `Foo` /
  `_Foo`; object states as `ObjState_*`.
- WRAM: `w` + PascalCase noun (`wFloorTransitionTimer`); SRAM `s...`; HRAM `h...`.
- Locals: `.snake_case` (`.got_obj`, `.loop`, `.done`).
- Every proposed name was grepped against `src/` to check it is unused.
- Confidence: **high** = behaviour fully read and the name follows directly;
  **medium** = role clear but details or intent partly inferred;
  **low** = educated guess.

## Findings

### Phase 1: RAM variables

Table columns: current label, definition, proposed name, evidence, confidence.
"Write-only" means every reference in `src/` stores to it and none reads it.

#### WRAM0: level engine

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `wc08a` | src/ram/wram.asm:26 | `wHiddenFigureBaseSCY` | Set from `wCameraSCY+1` at room start (start_room.asm:427) together with `wHiddenFigureSCYShake`; in the Hidden Figure camera config it replaces `wSCY` when computing `wWarioScreenYPos` (camera.asm:355), and hidden_figure.asm `.Func_4d655` resets `wSCY` to it (+`wSCYShake`). The fixed camera Y of the Hidden Figure room. | medium |
| `wc08b` | src/ram/wram.asm:27 | `wHiddenFigureSCX` | Written to `wSCX` instead of the camera's when `wCameraConfigFlags == HIDDEN_FIGURE_CAMCONFIG` (update_level.asm:36, update_objects.asm:46); hidden_figure.asm `Func_4cf87` adds table deltas to it exactly as `Func_4cf70` does to `wHiddenFigureSCYShake`. X counterpart of `wHiddenFigureSCYShake` (which could itself become `wHiddenFigureSCY`). | high |
| `wc08c` | src/ram/wram.asm:28 | `wHiddenFigureBaseSCX` | X counterpart of `wc08a`: copied from `wCameraSCX+1` at room start, used for `wWarioScreenXPos` in the Hidden Figure camera config and to restore `wSCX`. | medium |
| `wc08d` | src/ram/wram.asm:29 | `wHiddenFigureWY` | Initialised to $88 and written to `rWY` in init.asm:54; each frame of the fight `rWY = wc08d + wSCYShake` (update_level.asm:38). The window Y used by the Hidden Figure fight. | high |
| `wc0b3` | src/ram/wram.asm:102 | `wBGMapTileVRAM1QueuePtr` | Big-endian pointer set to `wBGMapTileVRAM1Queue + wBGMapTileQueueSize` and advanced while queueing block attributes in scroll.asm (`.Func_9605`, `.Func_9d4c`, `Func_a79e`, `Func_b182`). VRAM1 twin of `wcce7`. | high |
| `wc0c4` | src/ram/wram.asm:157 | `wRoomObjMapLowerY` | load_room.asm:150: `wRoomLowerYLimit * 16 + $a0` ($ff if it wraps), i.e. the room's lower limit as an SRAM page of `sLevelBlockObjectMap`. start_room.asm `.Func_89e2` spawns an object from the map only if its row is in [`wc0c5`, `wc0c4`). | high |
| `wc0c5` | src/ram/wram.asm:160 | `wRoomObjMapUpperY` | Same, from `wRoomUpperYLimit`. | high |
| `wc0c6` | src/ram/wram.asm:163 | `wRoomObjMapLeftX` | `wRoomLeftXLimit * 8 + $b0`: the room's left limit as a byte offset into the object half of a map row ($b0-$ff, two objects per byte). Compared with `l` in `.Func_89e2`. | high |
| `wc0c7` | src/ram/wram.asm:166 | `wRoomObjMapRightX` | Same, from `wRoomRightXLimit` ($ff on wrap). | high |
| `wc0d0` | src/ram/wram.asm:179 | `wRoomTileMapBank` | load_room_gfx.asm:42 copies `wRoomBlockFunctionTableBank` into it right before `LoadRoomTileMap`, which decompresses `RoomBlockAttributePointers[wRoomTileMap]` from that bank (load_room.asm:220). Sits in the per-room bank list between `wRoomBlockFunctionTableBank` and `wRoomMainTilesBank`. | high |
| `wc0d4` | src/ram/wram.asm:186 | `wCameraYIdleCounter` | camera.asm `LevelScroll_Vertical`: reset to 0 on frames with a `wCameraYDelta`; incremented on frames without one, and the camera re-centres on Wario only from the second such frame (`ret z ; return if wc0d4 == 1`). | medium |
| `wc0d5` | src/ram/wram.asm:189 | `wCameraXIdleCounter` | Same for `LevelScroll_Horizontal` / `wCameraXDelta`. | medium |
| `wc0dc` | src/ram/wram.asm:222 | `wFrontCollisionBlockY` | collisions.asm: `CheckBottomRight/LeftCollision` store `hYPosLo & $f0` (block row of the probed point); `Func_19832` compares it with the row of Wario's collision-box top to decide whether there is a second block above to probe. | medium |
| `wc0e0` | src/ram/wram.asm:233 | `wUnused_c0e0` | Write-only: only zeroed in Wario state setters (wario_states_1.asm:1508, 1565, 1694, 2064; wario_states_2.asm:558). | high |
| `wc0e1` | src/ram/wram.asm:236 | `wWaterCurrentBlockedDir` | Holds a `PAD_*` direction: set by swim-move routines around wario_states_1.asm:5525-5683 and 2163, cleared at the start of every swimming `UpdateState_*`; the water-current handlers (wario_states_1.asm:3940-4147) don't push Wario in a direction whose bit is set. The exact condition the swim code sets it on wasn't traced. | medium |
| `wc18e` | src/ram/wram.asm:305 | `wBlockRedrawQueue` | Ring buffer of 8 big-endian block pointers (bank folded into the high byte, `h + (wBlockPtrBank-1)*$20`). `Func_e31` (home/sprite.asm:160) appends `wBlockPtr`; `Func_bb85` (block_queue.asm:173) takes one entry per frame when no DMA is pending, queues its 2x2 tiles and attributes for VBlank and clears the entry. | high |
| `wc19e` | src/ram/wram.asm:306 | `wBlockRedrawQueueWriteIndex` | Byte offset into `wc18e` where `Func_e31` writes; `+2 & $0f`. | high |
| `wc19f` | src/ram/wram.asm:307 | `wBlockRedrawQueueReadIndex` | Byte offset into `wc18e` that `Func_bb85` reads; `+2 & $0f`. | high |
| `wc1c1` | src/ram/wram.asm:365 | `wObjOverlapFromAbove` | `ProcessInteractions` (object_interactions.asm:78-165): `(Wario bottom) - (obj top)`, kept only when it is the smaller of the two vertical overlaps ($ff otherwise). Picks `INTERACTION_UP/DOWN`; object_interactions.asm:1249 uses it to land on a steppable object. | high |
| `wc1c2` | src/ram/wram.asm:366 | `wObjOverlapFromBelow` | `(obj bottom) - (Wario top)`, same rules. | high |
| `wc1c3` | src/ram/wram.asm:367 | `wObjOverlapFromLeft` | `(Wario right) - (obj left)`; object_interactions.asm:1325 and 2108 push Wario out with `MoveWarioLeft` by this amount. | high |
| `wc1c4` | src/ram/wram.asm:368 | `wObjOverlapFromRight` | `(obj right) - (Wario left)`; used with `MoveWarioRight`. | high |
| `wc1ca` | src/ram/wram.asm:384 | `wHitFloorBlock` | Set TRUE by `BlockFunc_Floor` and `BlockFunc_18262` (one-way floors), cleared before probes in collisions.asm `Func_19a77` and several object collision routines in update_objects.asm (1105, 1312, 2002, ...), which then treat "solid, but a floor block" differently. | medium |
| `wca65` | src/ram/wram.asm:521 | `wWarioSpriteFrame` | `UpdateAnimation` (home/sprite.asm:211) stores the next frame number from Wario's frameset here (`wAnimationFrame` is the offset into the frameset); `DrawWario` copies it to `wCurSpriteFrame`. | high |
| `wca66` | src/ram/wram.asm:524 | `wWarioSpriteAttributes` | Copied to `wCurSpriteAttributes` when drawing Wario (home/sprite.asm:39); only ever cleared (start_room.asm:309). | medium |
| `wca6c` | src/ram/wram.asm:549 | `wUnused_ca6c` (or `wTransitionRoomCoords`) | Write-only: start_room.asm:52 stores `(wWarioYPos hi << 4) \| wWarioXPos hi` (Wario's room-grid cell) on a room transition; start_room.asm:293 clears it. | high |
| `wca94` | src/ram/wram.asm:691 | `wSpikeTouchState` | Read only by `BlockFunc_NonSolidSpike/SolidSpike`: 0 = `SetState_Stung`, 1 = `Func_206eb` (end the transformation, then sting), 2 = spikes are harmless. Set by every transformation setter (2 for Hot/Fat/Bouncy/Zombie..., 1 for Ball o' String/Puffy/...), cleared by `ClearTransformationValues`. Pairs with `wTouchState`/`wStingTouchState`; values could get `SPIKE_TOUCH_*` constants. | high |
| `wcaa1` | src/ram/wram.asm:741 | `wSavedEnemyPals` | 4 palettes. `SaveLevel` copies OB palettes 4-7 of the backup palettes (`w3d280 palette 12`) here before saving Level WRAM; on continuing, start_room.asm:382 copies them back into `wTempPals2 palette 4`. | high |
| `wcce7` | src/ram/wram.asm:793 | `wBGMapTileVRAM0QueuePtr` | Set to `wBGMapTileVRAM0Queue + wBGMapTileQueueSize` (comment at scroll.asm:321) and advanced while queueing block tiles in row_block_queue.asm and scroll.asm. | high |
| `wccec` | src/ram/wram.asm:801 | `wObjectMapBank` | SRAM bank of the object-map entry being processed: set from `wBlockPtrBank` by `Func_d8c`, from the row's bank in start_room.asm:506/541, read by `Func_cf8` for the Y position and to `sramswitch` back in block_queue.asm. | medium |

#### WRAM0: save, VBlank and misc

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `wcedb` | src/ram/wram.asm:889 | `wMultiBlockOriginBank` | Block functions that start a multi-block break (`Func_18f32`, `Func_19086`, `Func_19246`, `Func_193dc` in block_functions.asm) store `wSRAMBank` here, the block pointer in `wcedc` and its value in `wcedf`; `ProcessMultiBlock.ProcessBlocks` (start_room.asm:184-256) walks to the neighbour above/below/left/right of that origin. | medium |
| `wcedc` | src/ram/wram.asm:890 | `wMultiBlockOriginPtr` | See above (big-endian block pointer). | medium |
| `wcede` | src/ram/wram.asm:891 | `wUnused_cede` | Write-only (start_room.asm:182: bit 3 of `wMultiBlockParam`). | high |
| `wcedf` | src/ram/wram.asm:892 | `wUnused_cedf` (or `wMultiBlockOriginBlock`) | Write-only: the origin block's value, stored by the four routines above and never read. | high |
| `wcee4` | src/ram/wram.asm:904 | `wBGUpdateRequest` | Shared by several screens' VBlank functions: bit 7 asks VBlank to draw something once and VBlank clears it (pause/save/vblank.asm:26, title/vblank.asm:13, clear/vblank.asm, language_selection/vblank.asm, credits.asm); the low bits are a per-screen parameter (save-bar tile count in `FillSaveScreenBar`, start-menu box choice $80/$81). | medium |
| `wcee9` | src/ram/wram.asm:911 | `wChecksumAlt1` | `ValidateSaveData.GetMatchingChecksum` stores the best of three stored checksums in `wChecksum` and the other two here and in `wceeb`; callers retry the computed checksum against them when `wChecksumMismatches` is non-zero. | high |
| `wceeb` | src/ram/wram.asm:912 | `wChecksumAlt2` | See above. | high |
| `wceee` | src/ram/wram.asm:921 | `wValidSaves` | Bit flags set by `Func_1f0d60`: bit 0 game data, 1 backup game data, 2 level save (`sWRAMChecksum`), 3/4/5 level backups 1/2/3, 6 level map, 7 backup level map. `Func_1f1246` uses `& $3f`. `VALID_SAVE_*_F` constants would help. | high |
| `wceef` | src/ram/wram.asm:922 | `wRestoredSave` | `Func_1f1246` narrows it from the valid saves to the one with the highest save counter and restores that; `StartRoom_FromLevelStart` tests `and %00111100` ("if from saved level, don't init start level vars"); level init clears it. | medium |
| `wcef1` | src/ram/wram.asm:932 | `wSaveProgress` | `ValidateSaveData` stores the value the three copies `s0a790/s0a7e0/s0afa0` agree on ($ff if none agree). Write-only in practice. | medium |
| `w3d280` | src/ram/wram.asm:2435 | `wBackupPals` | `SaveBackupVRAM` copies `wTempPals1` (16 palettes) here along with the VRAM backup; `LoadBackupVRAM` restores them; `SaveLevel` takes the enemy palettes from it. | high |
| `w3d500` | src/ram/wram.asm:2441 | `wBackupSCY` | Saved/restored with `wSCY` by `SaveBackupVRAM`/`LoadBackupVRAM`. overworld/init.asm:632 also decompresses data into it (that area is reused there). | high |
| `w3d501` | src/ram/wram.asm:2444 | `wBackupSCX` | Same for `wSCX`. | high |
| `w3d50d` | src/ram/wram.asm:2480 | `wUnused_3d50d` | Write-only (title/start_menu.asm:181, action_help/core.asm:247). | high |
| `w3d511` | src/ram/wram.asm:2494 | `wTempTimeAttackScore` | pause/bank7d.asm:74 and clear/bank78.asm:74 copy a level's 2-byte BCD entry of `wLevelTimeAttackScores` here and print its four digits from it. | high |
| `wdc11` | src/ram/wram.asm:1238 | `wGolfHDMADest` | Union alias of `wGolfWarioTilesPtr`. `Func_2c30`'s header (home/load_golf_sprite.asm) says "wdc11 = destination"; written to `rVDMA_DEST_HIGH/LOW`. Set by golf/hole.asm `VBlank_1c9ffa`/`VBlank_1ca056`. | high |
| `w1dc13` | src/ram/wram.asm:1241 | `wGolfHDMALength` | "w1dc13 = length - 1"; written to `rVDMA_LEN`. | high |
| `w2d150`, `w2d151`, `wd152`..`wd156` | src/ram/wram.asm:1972-1992 | (generic) `wOWSceneVar1`..`wOWSceneVar7` | Overworld scratch shared by unrelated cutscenes: a per-scene-object jumptable index in bank56.asm (`.Func_1586a1`...), a step counter in bank2b_2.asm `Func_ae523`, a data pointer (`w2d151`/`wd152`) in bank2d.asm `.Func_b7056`, delays in bank2d.asm `.Func_b59b6`. `wd152` is already aliased `wDebugSceneWarioState`. No single meaning; a neutral name is the honest option. | low |

#### Audio RAM and HRAM

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `w3d008` | src/ram/wram.asm:2309 | `wSFXTempoAccumulator` | audio/engine.asm:94-138: `wSFXTempo` is added to this 16-bit value each frame; SFX channels advance one tick whenever it reaches $4a, which is then subtracted. | high |
| `w3d00d` | src/ram/wram.asm:2316 | `wMusicTempoAccumulator` | Same for `wMusicTempo` (audio/engine.asm:145-186). | high |
| `w3d01a` | src/ram/wram.asm:2349 | `wAudioFrameCycle` | Counts 14..0 and wraps (audio/engine.asm:197-203); `Func_30bfb` increments a track's frequency only when it is 0 (engine.asm:2257). What the effect is for is unclear. | low |
| `w3d025` | src/ram/wram.asm:2382 | `wMusicChannelsDeactivated` | $ff in `DeactivateMusicChannels`, 0 when music starts and in `Func_302e4`; `UpdateMusicFadeOut` returns while it's set ("music channels are deactivated"). | high |
| `hffa0` | src/ram/hram.asm:9 | `hTemp` | First byte of an HRAM union already aliased `hThrownObjInteractionType` / `hIsInWaterOrSandBackup`; used as a scratch byte by load_objects.asm (loop counter), coin.asm, update_objects.asm (a Y velocity: "; y vel") and musical_coin_flags.asm. | medium |
| `hffac` | src/ram/hram.asm:37 | `hAudioTempA` | home/audio.asm: holds `a` across `push_wram BANK("Audio RAM")` in every audio trampoline (`ExecuteAudioMod` and the unreferenced ones). | high |

#### SRAM (src/ram/sram.asm)

The save system keeps a game save plus a backup, and an in-level save ("WRAM"
save: Progress + Level WRAM, the treasure flags and the level objects) in four
copies. Every write is bracketed by a step marker stored three times
(`s0a790/s0a7e0/s0afa0`), each checksum is stored three times (`...Echo1/2`),
and the level's block/object map (SRAM1 + first half of SRAM2) has a backup
copy (SRAM3 + second half of SRAM2). The proposals extend the existing
`sWRAMChecksum`, `sBackup1..3WRAMChecksum`, `...Echo1/2` names. Note the four
level-save copies are written in the order a000, a800, a400, ac00, matching
`sWRAMChecksum`, `sBackup1/2/3WRAMChecksum`.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `s0a000` | sram.asm:3 | `sWRAMCheckVals` | `SaveLevel` writes `CHECKVAL2` ("WAR3") here, followed by the level save data (which starts at `sSaveCounter`), checksum in `sWRAMChecksum`; `ValidateSaveData` checks it with `CheckSaveVals2`; level init (init.asm:28) and home/clear_save.asm clear it. | high |
| (none) at $a004 | sram.asm:6 | add `sWRAMData::` | `sSaveCounter`/`sGeneralData`/`sLevelData` are fields of the level save that starts here; validate_save.asm:344 checksums from `sSaveCounter`. A label would mirror the backups below. | medium |
| `s0a400` | sram.asm:25 | `sBackup2WRAMCheckVals` | Third copy written by `SaveLevel`; checksum in `sBackup2WRAMChecksum`. | high |
| `s0a404` | sram.asm:28 | `sBackup2WRAMData` | The data after it, checksummed with `Func_1f0b5b` against `sBackup2WRAMChecksum` (validate_save.asm:545). | high |
| `s0a790` | sram.asm:33 | `sSaveProgress` | Step marker written before/after each part of a save ($10-$13 game data, $20-$23 backup game data, $30-$83 level save parts, 0 when done); `ValidateSaveData` compares the three copies. | high |
| `s0a79d` | sram.asm:44 | `sLevelMapChecksum` | Result of `CalculateBackupSRAMChecksum1` (SRAM1 + `s2a000`); bit 6 of `wceee`. | high |
| `s0a79f` | sram.asm:47 | `sBackupLevelMapChecksum` | Result of `CalculateBackupSRAMChecksum2` (SRAM3 + `s2b000`), written by `Func_1f14c6`; bit 7 of `wceee`. | high |
| `s0a7e0` | sram.asm:52 | `sSaveProgressEcho1` | Second copy of `s0a790`. | high |
| `s0a7ed` | sram.asm:63 | `sLevelMapChecksumEcho1` | Second copy of `s0a79d`. | high |
| `s0a7ef` | sram.asm:66 | `sBackupLevelMapChecksumEcho1` | Second copy of `s0a79f`. | high |
| `s0a800` | sram.asm:71 | `sBackup1WRAMCheckVals` | Second copy written by `SaveLevel`; checksum in `sBackup1WRAMChecksum`. | high |
| `s0a804` | sram.asm:74 | `sBackup1WRAMData` | Checksummed against `sBackup1WRAMChecksum` (validate_save.asm:417). | high |
| `s0ac00` | sram.asm:87 | `sBackup3WRAMCheckVals` | Fourth copy; `sBackup3WRAMChecksum`. | high |
| `s0ac04` | sram.asm:90 | `sBackup3WRAMData` | Checksummed against `sBackup3WRAMChecksum`. | high |
| `s0afa0` | sram.asm:95 | `sSaveProgressEcho2` | Third copy of `s0a790`. | high |
| `s0afad` | sram.asm:106 | `sLevelMapChecksumEcho2` | Third copy of `s0a79d`. | high |
| `s0afaf` | sram.asm:109 | `sBackupLevelMapChecksumEcho2` | Third copy of `s0a79f`. | high |
| `s0afe0`..`s0aff4` | sram.asm:114-129 | `sSaveCounterCompare1`..`6` | `Func_1f1246` copies the first 4 bytes (save counter) of the 6 saves (game, backup game, level, level backups 1/2/3) here and shifts them left bit by bit to find the highest counter. | medium |
| `s0aff8` | sram.asm:132 | `sSaveCounterCompareBits` | Per-iteration mask of which of those saves shifted out a 1. | medium |
| `s2a000` | sram.asm:145 | `sLevelBlockObjectMap2` | Continuation of `sLevelBlockObjectMap` ($1000 bytes): switch.asm toggles switch blocks in it with the same loop as in SRAM1; part of `CalculateBackupSRAMChecksum1`. | high |
| `s2b000` | sram.asm:148 | `sBackupLevelBlockObjectMap2` | `Func_1f14c6` copies `s2a000` here; `Func_1f1246.Func_1f1420` copies it back. | high |
| `s3a000` | sram.asm:153 | `sBackupLevelBlockObjectMap` | Whole-bank copy of SRAM1 made by `Func_1f14c6` (which loads `hl` with `s0a000`, i.e. $a000, while SRAM1 is mapped: it means `sLevelBlockObjectMap`), copied back by `.Func_1f1420`. | high |

#### Struct fields and flags met along the way

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `OBJ_UNK_01` / `OBJ_UNK_02` (+ `wCurObjUnk01/02`) | src/constants/object_constants.asm:238-239 | `OBJ_MAP_PTR_LO` / `OBJ_MAP_PTR_HI` (`wCurObjMapPtrLo/Hi`) | Pointer to the object's entry in the object map (SRAM bank folded into the high byte, as in `wBlockRedrawQueue`). `DespawnObject` (block_queue.asm:120) reads it to set bit 7 of the map entry; the fork's own comment there says objects spawned outside the map have no entry. update_objects.asm:3986 checks it before calling `DespawnObject`; debug_menu/spawn_object.asm:44 zeroes it. | high |
| `OBJ_UNK_1D` (+ `wCurObjUnk1d`) | object_constants.asm:262 | `OBJ_ACTION_SIDE` | `SetObjAction` (object_interactions.asm:807) stores `wInteractionSide` (the `INTERACTION_*` bits, upper nybble) here next to `OBJ_ACTION`; the action handlers in update_objects.asm (`.Bump`, `.Attack`, `.Wobble`) test `INTERACTION_RIGHT` in it to choose the knock-back direction; togeba.asm/haridama.asm test bit 7 (`INTERACTION_DOWN`). The low nybble is preserved but no use was seen. | high |
| `OBJSUBFLAG_UNK_4` | object_constants.asm:288 | `OBJSUBFLAG_NO_DESPAWN` | update_objects.asm:3976: an object far offscreen is despawned (`DespawnObject`) unless this bit is set. Set by bosses, chests, torches, Sun/Moon, Pesce, Muddee and others, and in object_params.asm substates. | high |

### Phase 2: home bank routines and their far targets

#### Object state trampolines (src/home/object_mechanics.asm -> src/engine/level/update_objects.asm)

Every enemy's state jumptable (positional, $00-$5f, usually without comments;
spearhead.asm, count_richtertoffen.asm and doughnuteer.asm have `; OBJSTATE_*`
comments that pin down which slot each entry is) points at these shared state
handlers. States $00-$2f are "start" states and $30-$5f the matching ongoing
ones (`X_START + $30`). Each home label is a `homejp` to a bank $18 label; the
existing `ObjState_Fall` / `_ObjState_Fall` pair shows the convention, so each
row below names the pair. The `OBJSTATE_*` constants they use can be renamed in
the same pass (column "state").

| Current (home / far) | Where | Proposed (home / far) | Evidence | Conf. |
|---|---|---|---|---|
| `Func_3191` / `Func_62e8f` | object_mechanics.asm:326 / update_objects.asm:3439 | `ObjState_Bounce1LeftStart` / `_ObjState_Bounce1LeftStart` | Table slot `OBJSTATE_20`. Sets `OBJSTATE_50`, duration 4 (1 if heavy), falls into the ongoing handler. | high |
| `Func_31a0` / `Func_62ea5` | :329 / :3455 | `ObjState_Bounce1Left` / `_ObjState_Bounce1Left` | Slot `OBJSTATE_50`: `Func_62ec3` with `Data_602c0` (smallest hop: -2,-1,-1). | high |
| `Func_31af` / `Func_62f76` | :332 / :3592 | `ObjState_Bounce1RightStart` / `_ObjState_Bounce1RightStart` | Slot `OBJSTATE_21`; sets `OBJSTATE_51`. | high |
| `Func_31be` / `Func_62f8c` | :335 / :3608 | `ObjState_Bounce1Right` / `_ObjState_Bounce1Right` | Slot `OBJSTATE_51`; `Func_62faa` with `Data_602c0`. | high |
| `Func_31cd` / `Func_62eaa` | :338 / :3459 | `ObjState_Bounce2LeftStart` / `_ObjState_Bounce2LeftStart` | Slot `OBJSTATE_22`; sets `OBJSTATE_52`, duration 5/2. | high |
| `Func_31dc` / `Func_62ec0` | :341 / :3475 | `ObjState_Bounce2Left` / `_ObjState_Bounce2Left` | Slot `OBJSTATE_52` (and reused for `OBJSTATE_WOBBLE_RIGHT` in every table); `Data_602e0` (-3,-2,-2,-1). | high |
| `Func_31eb` / `Func_62f91` | :344 / :3612 | `ObjState_Bounce2RightStart` / `_ObjState_Bounce2RightStart` | Slot `OBJSTATE_23`. | high |
| `Func_31fa` / `Func_62fa7` | :347 / :3628 | `ObjState_Bounce2Right` / `_ObjState_Bounce2Right` | Slot `OBJSTATE_53` (and `OBJSTATE_WOBBLE_LEFT`). | high |
| `Func_3209` / `Func_62e74` | :350 / :3419 | `ObjState_Bounce3LeftStart` / `_ObjState_Bounce3LeftStart` | Slot `OBJSTATE_24`; sets `OBJSTATE_54`, duration 6/2. | high |
| `Func_3218` / `Func_62e8a` | :353 / :3435 | `ObjState_Bounce3Left` / `_ObjState_Bounce3Left` | Slot `OBJSTATE_54`; `Data_60300` (-4,-3,-3,-2,-1). | high |
| `Func_3227` / `Func_62f5b` | :356 / :3572 | `ObjState_Bounce3RightStart` / `_ObjState_Bounce3RightStart` | Slot `OBJSTATE_25`. | high |
| `Func_3236` / `Func_62f71` | :359 / :3588 | `ObjState_Bounce3Right` / `_ObjState_Bounce3Right` | Slot `OBJSTATE_55`. | high |
| `Func_62ec3` / `Func_62faa` | update_objects.asm:3479 / :3632 | `ObjBounceLeft` / `ObjBounceRight` | Shared bodies: apply the bounce Y-velocity table (+$10 for heavy), move by `OBJ_VAR_2`, probe head (`Func_358b`) and wall (`Func_3513`); on a hit or when the duration runs out go to `OBJSTATE_26`/`27`. | high |
| `Func_3245` / `Func_62c9f` | :362 / :3118 | `ObjState_FallLeftStart` / `_ObjState_FallLeftStart` | Slot `OBJSTATE_26`; sets `OBJSTATE_56`. | high |
| `Func_3254` / `Func_62d7d` | :365 / :3263 | `ObjState_FallRightStart` / `_ObjState_FallRightStart` | Slot `OBJSTATE_27`; sets `OBJSTATE_57`. | high |
| `Func_32cc` / `Func_62ca8` | :389 / :3127 | `ObjState_FallLeft` / `_ObjState_FallLeft` | Slots `OBJSTATE_44` and `OBJSTATE_56`: moves left by `OBJ_VAR_2` while falling with `FallingYVel_Light/Heavy`; landing (`Func_352b`) goes to `Func_62d34`, a wall sends it to `OBJSTATE_15`, water/sand vanishes it. | high |
| `Func_32db` / `Func_62d86` | :392 / :3272 | `ObjState_FallRight` / `_ObjState_FallRight` | Slots `OBJSTATE_45`/`OBJSTATE_57`, mirror image. | high |
| `Func_62d34` / `Func_62e0f` | update_objects.asm:3213 / :3355 | `ObjLandLeft` / `ObjLandRight` | Snap Y to the landing point, slow down on slopes, fall into `Func_62d57`/`Func_62e31`. | medium |
| `Func_62d57` / `Func_62e31` | :3239 / :3380 | `SetObjBounceFromYVel_Left` / `SetObjBounceFromYVel_Right` | Pick the next state from the landing speed in `hffa0` ("; y vel"): <2 stun, 2 bounce 1 (`OBJSTATE_20/21`), 3 bounce 2 (`22/23`), else bounce 3 (`24/25`). | high |
| `Func_32ae` / `Func_62ae5` | :383 / :2872 | `ObjState_BumpSlideLeft` / `_ObjState_BumpSlideLeft` | `_ObjState_BumpRight` jumps here while `OBJ_VAR_2` (speed) is non-zero: moves left, slowing down every 8 (heavy: 4) frames; wall -> stun with `SFX_01A`, no floor under either side (`Func_35a3`) -> `OBJSTATE_14`. Also used directly by 15 objects. | medium |
| `Func_32bd` / `Func_62bce` | :386 / :3003 | `ObjState_BumpSlideRight` / `_ObjState_BumpSlideRight` | Mirror, reached from `_ObjState_BumpLeft`. | medium |
| `Func_3326` / `Func_62840` | :407 / :2419 | `ObjState_AttackedLeft` / `_ObjState_AttackedLeft` | Slot `OBJSTATE_ATTACKED_LEFT`: moves by `OBJ_VAR_2` (x4 with Garlic or better, `wEffectivePowerUp >= GARLIC`) along `Data_60180` (heavy `Data_601a0`). | high |
| `Func_3317` / `Func_62898` | :404 / :2483 | `ObjState_AttackedRight` / `_ObjState_AttackedRight` | Slot `OBJSTATE_ATTACKED_RIGHT`, mirror. | high |
| `Func_6284f` / `Func_628a7` | :2429 / :2493 | `ApplyObjKnockbackRight` / `ApplyObjKnockbackLeft` | Shared bodies: X += / -= `b`, Y from the knock-back table, no actions for a frame. | high |
| `Func_3407` / `Func_6283a` | :452 / :2414 | `ObjState_HitByObjRight` / `_ObjState_HitByObjRight` | Slot `OBJSTATE_59` (start `OBJSTATE_29`): same knock-back without the Garlic boost. `HandleGrabbedObjectCollisions` puts objects hit by a thrown object (and the thrown object itself) in `OBJSTATE_28`/`29`. Suggests `OBJSTATE_28/29/58/59` -> `OBJSTATE_HIT_BY_OBJ_LEFT/RIGHT(_START)`. | medium |
| `Func_33f8` / `Func_62892` | :449 / :2478 | `ObjState_HitByObjLeft` / `_ObjState_HitByObjLeft` | Slot `OBJSTATE_58`. | medium |
| `Func_3335` / `Func_61f54` | :410 / update_objects.asm:1059 | `ObjState_PickedUpLeft` / `_ObjState_PickedUpLeft` | Slot `OBJSTATE_PICKED_UP_LEFT`: follows Wario's `wGrabState` (`.PickUp`, `.GrabIdle` hold above his head, drop when it hits a ceiling). | high |
| `Func_3344` / `Func_620a6` | :413 / :1266 | `ObjState_PickedUpRight` / `_ObjState_PickedUpRight` | Slot `OBJSTATE_PICKED_UP_RIGHT`. | high |
| `Func_3362` / `Func_622bd` | :419 / :1585 | `ObjState_GrabbedLeft` / `_ObjState_GrabbedLeft` | Called from the `OBJSTATE_48` handler when Wario faces left (spearhead.asm:1015); handles `GRAB_IDLE`/`GRAB_CHARGE_THROW`/`GRAB_THROW` (-> `ThrowObject_Left`), releasing to `OBJSTATE_12/14`. | medium |
| `Func_3353` / `Func_621fb` | :416 / :1476 | `ObjState_GrabbedRight` / `_ObjState_GrabbedRight` | Same from `OBJSTATE_49` (spearhead.asm:983), throws right. | medium |
| `Func_3380` / `Func_62382` | :425 / :1696 | `ObjState_GrabbedChargeLeft` / `_ObjState_GrabbedChargeLeft` | Slot `OBJSTATE_4A`: `GRAB_CHARGE_THROW`, `GRAB_THROW_FULLY_CHARGED`, `GRAB_HOLD_FULL_CHARGE` (drops the object if it would be in a wall), `GRAB_THROW` -> `ThrowObject_Left`. | medium |
| `Func_338f` / `Func_6247b` | :428 / :1842 | `ObjState_GrabbedChargeRight` / `_ObjState_GrabbedChargeRight` | Slot `OBJSTATE_4B`. | medium |
| `Func_339e` / `Func_62574` | :431 / :1988 | `ObjState_ThrowLeft` / `_ObjState_ThrowLeft` | Slot `OBJSTATE_4E`, set by `ThrowObject_Left` for a normal throw (full throws go to `OBJSTATE_FULL_THROW_LEFT_START`): thrown-object collision (`COLLISION_THROWN_OBJ`), lands via `Func_62d34`. Suggests `OBJSTATE_4E/4F` -> `OBJSTATE_THROW_LEFT/RIGHT`. | high |
| `Func_33ad` / `Func_62605` | :434 / :2070 | `ObjState_ThrowRight` / `_ObjState_ThrowRight` | Slot `OBJSTATE_4F`. | high |
| `Func_62690` | update_objects.asm:2149 | `ApplyObjThrowYVel` | Y movement for `ObjState_Throw*`: `Data_60080`/`Data_600a0` (light/heavy), or `Data_60100`/`Data_60120` when `b == 1` (thrown holding UP). | high |
| `Func_626da` / `Func_62768` | :2204 / :2284 | `_ObjState_FullThrowLeft` / `_ObjState_FullThrowRight` | Targets of the already named `ObjState_FullThrowLeft/Right`. | high |
| `Func_627f0` | :2360 | `ApplyObjFullThrowYVel` | Same as `Func_62690` for full throws (`Data_600c0`/`600e0`, UP: `Data_60140`/`60160`). | high |
| `Func_3371` / `Func_62926` | :422 / :2576 | `ObjState_Drop` / `_ObjState_Drop` | Slot `OBJSTATE_42` (spearhead `.State12` sets it: `OBJSTATE_12` is what a released object gets). Falls along `Data_60040`/`60060` (a small hop then falling) until it lands. Suggests `OBJSTATE_12/42` -> `OBJSTATE_DROP(_START)`. | medium |
| `Func_32ea` / `Func_628ea` | :395 / :2542 | `ObjCheckFloorOrDrop` / `_ObjCheckFloorOrDrop` | Probes the block under the object (`Func_3543`); if it's free, `OBJSTATE_12`. | high |
| `Func_32f9` / `Func_62908` | :398 / :2559 | `ObjCheckFloorOrStandingFall` / `_ObjCheckFloorOrStandingFall` | Same, but `OBJSTATE_STANDING_FALL_START`. | high |
| `Func_3263` / `Func_6303f` | :368 / :3721 | `ObjState_HopStart` / `_ObjState_HopStart` | Slot `OBJSTATE_1A`: sets `OBJSTATE_1B` (not +$30) for 7 frames. | low |
| `Func_3272` / `Func_63050` | :371 / :3732 | `ObjState_Hop` / `_ObjState_Hop` | Slot `OBJSTATE_1B`: rises along `Data_602a0` (`Func_629a6`) then `OBJSTATE_STANDING_FALL_START`. | low |
| `Func_629a6` | :2658 | `ApplyObjHopYVel` | Y from `Data_602a0`/`Data_602b0` (all negative: upwards). | medium |
| `Func_3281` / `Func_6305f` | :374 / :3740 | `ObjState_StartRandomWobble` / `_ObjState_StartRandomWobble` | Slot `OBJSTATE_1C`: picks `OBJSTATE_WOBBLE_LEFT` or `_RIGHT` from `rDIV`. | medium |
| `Func_3173` / `Func_62e57` | :320 / :3404 | `VanishAndDespawnObject` / `_VanishAndDespawnObject` | Like `VanishObject` (SFX, star sprite via `Func_618b4`) but the update function becomes `Func_4c860`, which despawns the object from the object map when the stars end. | high |
| `Func_618b4` | update_objects.asm:729 | `SetObjStarsSprite` | Tail of `_VanishObject`: star OAM/frameset, 33-frame duration, no collision, Y-8. | medium |
| `Func_4c860` | src/engine/level/objects/stars.asm:1 | `StarsFunc_Despawn` | Counts `OBJ_STATE_DURATION` down, then `DespawnObject`. | high |
| `Func_34fc` / `Func_63209` | :500 / :4083 | `ApplyObjYMovement_Platform` / `_ApplyObjYMovement_Platform` | Applies a Y table at `bc` and, if Wario is standing on the object (`OBJFLAG_STEPPED`), moves him down with it and checks his landing (`Func_19720`). Used by barrel.asm. | medium |
| `Func_3444` / `Func_632ac` | :465 / :4214 | `CountCurObjTransientChildren` / `_CountCurObjTransientChildren` | Counts active `OBJFLAG_TRANSIENT` objects whose `OBJ_UNK_01/02` (map pointer) equals the current object's. Used by omodonmeka.asm. | medium |

#### Block-probe wrappers and collision flags

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `COLLISION_UNK1` | movement_constants.asm:41 | `COLLISION_LANDING` | Set by `Func_19b7b`: centre probe while airborne (`CheckAirborneCollision`) and objects' floor probe while falling (`Func_352b`). `BlockFunc_Floor` is solid for it only in the top 5 px (land on one-way floors); `BlockFunc_WaterSurface` treats it as floor; smash attacks set `wBlockFuncBreakFlag` for it. | medium |
| `COLLISION_UNK2` | :42 | `COLLISION_DOWN_SIDES` | `Func_19b8b`, from `CheckCentreCollision` at the feet's left/right ends; objects use `Func_35a3` to check there's floor at both sides. Floors are solid for it like for `COLLISION_DOWN`. | medium |
| `COLLISION_UNK3` | :43 | `COLLISION_UP_SIDES` | `Func_19b9b` from `CheckUpCollision` at the head's left/right ends, and objects' head probe (`Func_358b`); switches react to it and `COLLISION_UNK5`. | medium |
| `COLLISION_UNK4` | :44 | `COLLISION_SIDE` | `Func_19bc3` from `CheckBottomLeft/RightCollision` (walls) and objects' wall probe `Func_3513` (136 uses, always before `MoveObjectLeft/Right`); `BlockFunc_Solid` doesn't snap Y for it on slopes; cracked blocks break on it when attacking/rolling. | high |
| `COLLISION_UNK5` | :45 | `COLLISION_UP` | `Func_19beb` from `Func_19942`, the head-centre probe (2 px above the collision box). | high |
| `COLLISION_UNK6` | :46 | `COLLISION_LANDING_SIDES` | `Func_19bfb`, `CheckAirborneCollision` at the left/right ends of the feet. | medium |
| `COLLISION_UNK7` | :47 | `COLLISION_ENV` | `ProcessBlock_UNK7` via `UpdateEnvState`, which clears water/ladder/sand/fence/air-current/room-transition state first; block functions only record environment for it (e.g. `BlockFunc_Floor` is free for it). | high |
| `Func_19b51` / `Func_3543` | collisions.asm:698 / object_mechanics.asm:514 | `_ProcessBlock_Down` / `ProcessBlock_Down` | `GetBlockPtr` at `hPos`, `wCollisionPoints = COLLISION_DOWN`, `ProcessBlock`; the home one is the `homecall` wrapper returning the result in `a` (as `ProcessBlockOnLeft`/`_ProcessBlockOnLeft`). | high |
| `Func_19b7b` / `Func_352b` | :734 / :509 | `_ProcessBlock_Landing` / `ProcessBlock_Landing` | Same with `COLLISION_UNK1`. 66 uses. | high |
| `Func_19b8b` / `Func_35a3` | :743 / :534 | `_ProcessBlock_DownSide` / `ProcessBlock_DownSide` | `COLLISION_UNK2`. | high |
| `Func_19b9b` / `Func_358b` | :752 / :529 | `_ProcessBlock_UpSide` / `ProcessBlock_UpSide` | `COLLISION_UNK3`. | high |
| `Func_19bc3` / `Func_3513` | :783 / :504 | `_ProcessBlock_Side` / `ProcessBlock_Side` | `COLLISION_UNK4`. 136 uses of the home one. | high |
| `Func_19beb` | :811 | `ProcessBlock_Up` | `COLLISION_UNK5`. | high |
| `Func_19bfb` | :820 | `ProcessBlock_LandingSide` | `COLLISION_UNK6`. | high |
| `ProcessBlock_UNK7` | :829 | `ProcessBlock_Env` | `COLLISION_UNK7`. | high |
| `Func_19b5c` / `Func_19bce` | :705 / :788 | (merge) `ProcessBlockAtPtr` | Both are `call ProcessBlock / ld b, a / ret`, used as tails by `_ProcessBlockOnLeft/Right`, `Func_19bc3` and `Func_19bd3`. | medium |
| `Func_19bd3` | :793 | `ProcessBlockAbove` | Decrements the row byte of `wBlockPtr`, stepping back an SRAM bank at $a0, then processes that block. | high |
| `Func_19bab` / `Func_19bb7` | :762 / :773 | `UnreferencedProcessBlockOnLeft` / `...OnRight` | Unreferenced variants of `_ProcessBlockOnLeft/Right` without the empty-block check. | medium |

#### Other home routines

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_cc0` | src/home/object_pos.asm:7 | `GetObjectMapPtr` | From `hPos`: `h` = map row page (y block + $a0), `l` = $b0 + x/2 (object half of the row), `b` = which nybble; also stores `wObjectSpawnBlockY/X`. | high |
| `Func_cf8` | :51 | `GetObjectMapPtrPos` | Inverse: object-map pointer (`h`,`l`,`b`, bank `wccec`) -> `hPos` (block centre). Used by start_room.asm `.spawn`. | high |
| `Func_d3e` | :99 | `GetBlockPtrPos` | Block pointer (`hl`, `wBlockPtrBank`) -> `hPos`, `b` = nybble for that column. Used to spawn an object at a block (block_queue.asm). | high |
| `Func_d81` | :140 | `ObjectMapPtrToBlockPtr` | `l = (l - $b0) * 2 + (b ^ 1)`: object-map column back to block column. | high |
| `Func_d8c` | :151 | `BlockPtrToObjectMapPtr` | `l = $b0 + l/2`, `b` = nybble, `wccec = wBlockPtrBank`. | high |
| `Func_e31` | src/home/sprite.asm:161 | `QueueBlockRedraw` | Appends the current block pointer to `wc18e` (see Phase 1); called by block functions after changing a block (9 calls). | high |
| `Func_e2b` | :155 | `QueueBlockRedraw_IfObjOnScreen` | Same, only if the current object is on screen. | high |
| `Func_bb85` | src/engine/level/block_queue.asm:173 | `ProcessBlockRedrawQueue` | Takes one `wc18e` entry per frame and queues its tiles/attributes. | high |
| `Func_ba42` | :3 | `SetObjectMapEntryAndSpawn` | Writes nybble `e` into the object map entry for the block at `hl`, marks it, and spawns that object at the block (`SpawnObject`). | medium |
| `Func_bb2d` | :127 | `ClearObjectMapEntry` | Clears the object nybble (`and $0f`/`and $f0`) of the map entry for the pointer at `hl`. | medium |
| `Func_298d` | src/home/load_room.asm:187 | `LoadRoomBlockTiles` | Copies `RoomBlockTilesPointers[wRoomBlockFunctionTable]` (bank `wRoomBlockFunctionTableBank`) to `wRoomBlockTiles`, `4 * NUM_ROOM_BLOCK_TYPES` bytes. | high |
| `Func_1180` | src/home/floor_transition.asm:51 | `HandleFloorTransition` | Unreferenced ("; unreferenced?" in the source): `HandleDownwards/UpwardsFloorTransition` combined. | high |
| `Func_1762` | src/home/wario_mechanics2.asm:81 | `LimitAirWalkVelocity` | Caps `wWalkVelIndex` at $0c while rising and at $04 while falling (`FALLING_JUMP_VEL_INDEX`); called after walking during jumps in wario_states_1/3/4.asm. | medium |
| `Func_1ae2` | src/home/bg_ob_pals.asm:64 | `UnreferencedFillTempPalsWhite` | Fills `wTempBGPals` and `wTempOBPals` with `PalsWhite`. | high |
| `Func_10fc` | src/home/clear_transformation.asm:62 | `UnreferencedConvertToBCD` | `c` -> `hl` as BCD: adds $9c per hundred and 6 per ten. | high |
| `Func_111e` | :87 | `UnreferencedConvertBCDToBinary` | Inverse (subtracts $9c per hundred, 6 per ten). | high |
| `Func_54e` | src/home/fade.asm:176 | `UnreferencedSlowFadeBGToBlack` | Decrements every RGB component of `wTempBGPals` by 1 per frame for 32 frames (same frame as `FadeBGToWhite`). | medium |
| `Func_7cf` | :679 | `UnreferencedFadePalsToTargetRGB` | Steps all 16 palettes of `wTempPals1` one unit per frame towards `wTargetRed/Green/Blue`. Partly read. | low |
| `Func_fd8` / `Func_3f12` | src/home/audio.asm:22 / audio_functions.asm:13 | `UnreferencedPlayMusic` / `AudioFunc_PlayMusic` | Wraps `PlayMusic` (no same-music check), like the existing `Unreferenced*` audio wrappers. | high |
| `Func_1010` / `Func_3f2a` | audio.asm:55 / audio_functions.asm:29 | `UnreferencedReactivateMusic` / `AudioFunc_ReactivateMusicChannels` | Wraps `Func_302e4`. | high |
| `Func_302e4` | src/audio/engine.asm:518 | `ReactivateMusicChannels` | Clears `w3d025` and sets `CHANFLAGS_ACTIVE` on music channels with `CHANFLAGS_5/6`: undoes `DeactivateMusicChannels`. | high |
| `Func_101e` / `Func_3f30` | audio.asm:62 / audio_functions.asm:33 | `UnreferencedGetActiveChannels` / `AudioFunc_GetActiveChannels` | Wraps `Func_30438`. | high |
| `Func_30438` | src/audio/engine.asm:768 | `_GetActiveChannels` | `d` = active SFX channels, `e` = active music channels >> 4. | high |
| `Func_2c30` | src/home/load_golf_sprite.asm:4 | `StartGolfHDMA` | Header: "hl = source, wdc11 = destination, w1dc13 = length - 1"; writes the `rVDMA_*` registers. | high |
| `Func_2c46` | :17 | `SetGolfBGPals` | Copies 4 palettes from `hl` to BG palettes 0-3 (a second, unreachable entry does the same for OB palettes). One call, in golf/hole.asm. | medium |
| `Func_3c03` | src/home/overworld.asm:345 | `StartOWHDMA` | Writes the 5 bytes at `w2d0b5` to the `rVDMA_*` registers (VRAM1) and clears `wHDMABank`; called from overworld/vblank.asm. | medium |
| `Func_3c35` | :399 | `ApplyOWMovementY` | Shared head of `ApplyOWMovement(_Mirrored)`: advances the step index in byte 7 of the OW object (`; unk7`), adds the step's Y offset, returns the X coord. | high |
| `Func_3c29` | :384 | `StoreOWMovementX` | Shared tail: stores the new X and resets the step index at the `$80` terminator. | medium |
| `Func_3c76` | :471 | `ClearW2d0c0` (unclear) | Zeroes $10 bytes at `w2d0c0`; one caller in overworld/bank20.asm. Name `w2d0c0` first. | low |

#### Wario collision routines (src/engine/level/collisions.asm)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_19741` | :37 | `CheckBottomRightCollision_Break` | Sets `wBlockFuncBreakFlag` then falls into `CheckBottomRightCollision` (17 callers). | high |
| `Func_197b1` | :113 | `CheckBottomLeftCollision_Break` | Same for the left. | high |
| `Func_19706` | :1 | `CheckCarriedWarioRightCollision` | `wBlockFuncWarioFlag` around `Func_19741`; used by cart.asm, zip_line.asm, muddee.asm right after moving Wario with the platform (`MoveWarioRight`). | medium |
| `Func_19713` | :9 | `CheckCarriedWarioLeftCollision` | Same for the left. | medium |
| `Func_19720` | :17 | `CheckCarriedWarioDownCollision` | After a platform moves Wario down (update_objects.asm:4118): airborne collision as Wario; on a hit `TriggerFloorTransition` (which snaps Y), else `TriggerDownwardsFloorTransition`. | medium |
| `Func_19823` | :193 | `ProcessFrontBlockAbove_Break` | When the side probe hits while `wAttackCounter` is set: probes the block above (`Func_19bd3`) with breaking enabled, so a shoulder bash breaks two-block-high walls. | medium |
| `Func_19832` | :202 | `CheckFrontBlockAbove` | When the side probe is free: if Wario's head reaches the next row up (`wc0dc`), probe it; if solid while walking on the ground, nudge Wario 2 px and `CrouchOrSlide` into the gap. | medium |
| `Func_198c7` | :272 | `CheckDownCollisionAtWario` | Clears `wWarioSlopeInteraction`, `get_pos`, `Func_19b51`; first step of `CheckCentreCollision`. | high |
| `Func_19942` | :345 | `CheckUpCentreCollision` | Head-centre probe (2 px above the box, breaking unless Puffy); first step of `CheckUpCollision`. | high |
| `Func_19a77` | :549 | `CheckStandingOnFloorBlocks` | Env probes at both feet; sets `wc1ca` when they're both on one-way floor blocks. Only caller: Zombie Wario landing (wario_states_3.asm:3108), which then slips through. | medium |
| `Func_19acd` | :609 | `UpdateEnvStateAtChest` | `UpdateEnvState` 12 px above Wario's feet; swimming code checks `wWaterInteraction` after it to surface, fan code checks `wIsInAirCurrent`. | medium |
| `Func_19ae4` | :627 | `UpdateEnvStateAboveHead` | 26 px up; fence climbing up checks `wIsNearFence`. | medium |
| `Func_19afb` | :645 | `UpdateEnvStateAtHead` | 24 px up; fence checks while airborne/moving on a fence. | medium |
| `Func_19b12` | :664 | `UpdateEnvStateAtFeet` | `get_pos` + `UpdateEnvState` ("; collision on centre"). | high |

#### Object movement Y-velocity tables (src/data/object_movements.asm)

Named after the existing `FallingYVel_Light/Heavy` and `StandingFallYVel_Light/Heavy`; each heavy table sits right after its light one.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Data_60040` / `Data_60060` | :9 / :13 | `DropYVel_Light` / `DropYVel_Heavy` | `_ObjState_Drop` (`Func_62926`). | medium |
| `Data_60080` / `Data_600a0` | :17 / :21 | `ThrowYVel_Light` / `ThrowYVel_Heavy` | `ApplyObjThrowYVel` (`Func_62690`). | high |
| `Data_600c0` / `Data_600e0` | :25 / :29 | `FullThrowYVel_Light` / `FullThrowYVel_Heavy` | `ApplyObjFullThrowYVel` (`Func_627f0`, `ld b, $40 / add $c0`). | high |
| `Data_60100` / `Data_60120` | :33 / :37 | `ThrowUpYVel_Light` / `ThrowUpYVel_Heavy` | Thrown while holding UP (`OBJ_VAR_2 == 1`). | high |
| `Data_60140` / `Data_60160` | :41 / :45 | `FullThrowUpYVel_Light` / `FullThrowUpYVel_Heavy` | Same for full throws. | high |
| `Data_60180` / `Data_601a0` | :49 / :53 | `AttackedYVel_Light` / `AttackedYVel_Heavy` | `ApplyObjKnockbackLeft/Right`. | high |
| `Data_602a0` / `Data_602b0` | :97 / :100 | `HopYVel_Light` / `HopYVel_Heavy` | `ApplyObjHopYVel` (`Func_629a6`). | medium |
| `Data_602c0` / `Data_602d0` | :103 / :106 | `Bounce1YVel_Light` / `Bounce1YVel_Heavy` | `ObjState_Bounce1*`. | high |
| `Data_602e0` / `Data_602f0` | :109 / :112 | `Bounce2YVel_Light` / `Bounce2YVel_Heavy` | `ObjState_Bounce2*`. | high |
| `Data_60300` / `Data_60310` | :115 / :118 | `Bounce3YVel_Light` / `Bounce3YVel_Heavy` | `ObjState_Bounce3*`. | high |

### Phase 3: fork focus areas

#### Notable finding: `FLOOR_TRANSITION_UP` / `FLOOR_TRANSITION_DOWN` are swapped

src/constants/movement_constants.asm:23-27 and the comment on `wFloorTransitionDir`
("bit 2 set = transitioning downwards, bit 3 set = transitioning upwards") don't
match how the flags are used:

- Floors are numbered 6 (top, `wWarioYPos` < $80) to 1 (bottom) by `GetFloorForYPos`.
- `StartDownwardsFloorTransition` (Wario's floor number decreases, i.e. he went
  down) sets `FLOOR_TRANSITION_UP`; `StartUpwardsFloorTransition` sets
  `FLOOR_TRANSITION_DOWN`.
- update_level.asm:96-130: `FLOOR_TRANSITION_UP` adds 4 to `wCameraYDelta`
  each frame (camera scrolls down), `FLOOR_TRANSITION_DOWN` subtracts 4 (camera
  scrolls up). The local `.transition_up` handles the downward camera move.

Either the two constants (and `.transition_up`) should be swapped, or renamed
after what they do to the camera, e.g. `FLOOR_TRANSITION_SCROLL_DOWN` /
`FLOOR_TRANSITION_SCROLL_UP`. Worth fixing before more camera work (the
fork's `OwlWarioCamera` and floor-by-floor bat camera build on these).
Confidence: high. Not renamed in the tables below to keep entries to labels.

#### Camera and floor transitions

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `.asm_b836` | src/engine/level/camera.asm:231 | `.snap_to_upper_edge` | `ScrollCameraDown`: reached when Wario is above the room's upper limit (or close to it); sets `wCameraSCY` to the upper edge and `wScrollDownEdge = 2`. | high |
| `.asm_b86e` | camera.asm:268 | `.check_scroll_limit` | `ScrollCameraUp`; same role and name as in `ScrollCameraLeft/Right/Down`. | high |
| `.asm_b8ba` | camera.asm:317 | `.check_wario_y` | `ScrollCameraUp`; same role as `.check_wario_y` in `ScrollCameraDown`. | high |
| `.asm_b8cf` | camera.asm:330 | `.got_lower_scroll_adjustment` | `ScrollCameraUp`; mirrors `.got_upper_scroll_adjustment`. | high |
| `.asm_b98f` | camera.asm:459 | `.got_abs_y_offset` | `LevelScroll_Vertical`: `abs(wPrevWarioScreenYPos - wWarioScreenYPos)`. | high |
| `.asm_b9ce` / `.asm_b9ff` | camera.asm:505 / 544 | `.past_cam_spacing_r` / `.past_cam_spacing_l` | Comment "; x pos > cam spacing": speed the scroll up by one. | medium |
| `.asm_ba38` / `.asm_ba3b` | camera.asm:581 / 583 | `.dir_right_idle` / `.got_cam_spacing_idle` | `LevelScroll_Horizontal.no_x_offset`, same pattern as `.dir_right_r`/`.got_cam_spacing_r`. | high |
| `.asm_115b` / `.asm_115f` / `.asm_1161` | src/home/floor_transition.asm (GetFloorForYPos) | `.y_hi_1` / `.y_hi_2` / `.check_half` | `wWarioYPos` high byte 1 -> floors 3/4, 2 -> 1/2, else 5/6; then +1 if the low byte is < $80. | high |
| `.asm_11ba` / `.asm_11bc` | floor_transition.asm (StartDownwardsFloorTransition) | `.to_floor_5` / `.set_timer` | Timer is $68 instead of $80 when the new floor is 5. | high |
| `.asm_8209` | src/engine/level/update_level.asm:133 | `.scroll_vertically` | Both floor-transition paths end here and call `LevelScroll_Vertical`. | high |
| `.asm_8227` | update_level.asm:151 | `.hidden_figure` | Hidden Figure camera config: skips scrolling and the edge update. | high |
| `.asm_8229` | update_level.asm:154 | `.update_level_edges` | Calls `Func_8ed9` and `Func_bb85` with SRAM1 mapped. | high |

#### Level scrolling (src/engine/level/scroll.asm)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_8ed9` | scroll.asm:23 | `UpdateLevelEdges` | Reads `wLevelEdgeUpdateFlags` (whose own comment names `Func_8ed9`), queues the newly visible row/column of tiles and spawns objects there (`SpawnRowEdgeObjects`/`SpawnColEdgeObjects`), clearing each flag. | high |
| `.Func_8f79` | :86 | `.SetLowerEdgeRowPos` | `wBlockPos` = camera Y + $a0 (clamped to $2f8), camera X - $10. | high |
| `.Func_8fb3` | :123 | `.SetUpperEdgeRowPos` | camera Y - $10 (clamped to 0). | high |
| `.Func_8fec` | :158 | `.SetRightEdgeColumnPos` | camera X + $b0 (clamped to $9f8). | high |
| `.Func_9039` | :207 | `.SetLeftEdgeColumnPos` | camera X - $10. | high |
| `.Func_9085` | :255 | `.QueueEdgeRow` | Queues 25 BG-map addresses along a row, then the tiles (`.AddRowBottomTiles`/`.AddRowTopTiles`) and attributes. | high |
| `.Func_9605` | :444 | `.AddRowBottomAttributes` | VRAM1 counterpart of `.AddRowBottomTiles` (`wBGMapTileVRAM1Queue`, `wRoomBlockAttributes`). | high |
| `.Func_9d4c` | :679 | `.AddRowTopAttributes` | VRAM1 counterpart of `.AddRowTopTiles`. | high |
| `Func_a0e2` | :783 | `QueueEdgeColumn` | Column version of `.QueueEdgeRow` (23 tiles). | high |
| `Func_a2aa` / `Func_aca6` | :839 / :1155 | `AddColumnRightTiles` / `AddColumnLeftTiles` | Chosen by `wBlockXPos & 8` (right/left half of the 2x2 block), filling `wBGMapTileVRAM0Queue`. | medium |
| `Func_a79e` / `Func_b182` | :995 / :1306 | `AddColumnRightAttributes` / `AddColumnLeftAttributes` | Same for `wBGMapTileVRAM1Queue`. | medium |

#### Room loading and start (src/engine/level/start_room.asm, src/home/load_room.asm)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_896f` | start_room.asm:476 | `SpawnObjectsInView` | From the camera's block position (`wBlockXPos/YPos`) walks 16 rows x 16 columns of the object map and calls `.Func_89e2` for every non-zero nybble; run after `DrawRoom_FromStart` on a room transition and on a fresh level start. | high |
| `.Func_89e2` | start_room.asm:548 | `.SpawnIfInRoom` | Skips $0f (Wario spawn marker), spawns the object (`SpawnObject`) only if the entry is inside `wc0c4..wc0c7`. | high |
| `.asm_883a` | start_room.asm (StartRoom_FromLevelStart) | `.restore_saved_pals` | Taken when `wceef & %00111100` (continuing a level save): reloads Wario's palette from `wWarioPalsPtr` and the enemy palettes from `wcaa1`. | high |
| `.asm_8861` | start_room.asm | `.load_common_pal` | Loads `Pals_d1fe` into OB palette 2 on both paths. | medium |
| `.asm_88b7` | start_room.asm | `.skip_spawning_objects` | Skips `Func_896f` for a level save (the saved objects are already there). | high |
| `.asm_8917` | start_room.asm | `.from_level_save` | Updates objects once with `wIsFloorTransition` set instead of twice. | medium |
| `.asm_2963` / `.asm_297e` | src/home/load_room.asm:158 / 176 | `.got_lower_limit` / `.got_right_limit` | Store `wc0c4`/`wc0c7` after replacing a wrapped 0 with $ff. | high |

#### Save code (src/engine/pause/save/)

`Func_1f0b5b` is the routine whose address is mentioned in the task description; it pairs with `CalculateWRAMDataChecksum` and `ValidateSaveData.CalculateChecksumAtHL`.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_1f0b5b` | checksum.asm:17 | `CalculateWRAMDataChecksumAtHL` | Same sums as `CalculateWRAMDataChecksum` (Progress + Level WRAM, $11 bytes, Level Objects WRAM) but from `hl`, which callers point at the SRAM copy (`sSaveCounter`, `s0a804`, `s0a404`, `s0ac04`). It switches WRAM banks while reading SRAM, harmlessly, like `.CalculateChecksumAtHL` notes. | high |
| `Func_1f0d60` | validate_save.asm:117 | `ValidateSaveChecksums` | Checks each save's check values and triple-stored checksum against a freshly computed one, setting bits of `wceee` and clearing the check values of bad saves. | high |
| `Func_1f1246` | validate_save.asm:852 | `LoadNewestValidSave` | If no save is valid, resets time-attack and golf scores; otherwise picks the valid save with the highest save counter (bit-serial compare in `s0afe0..s0aff8`) and copies it back into WRAM. | high |
| `.Func_1f13d7` | :1070 | `.LoadGameData` | Copies a game-data save (`sGameData`/`sBackupGameData`) to Progress WRAM and WRAM2. | high |
| `.Func_1f13f2` | :1081 | `.LoadWRAMData` | Copies a level save to Progress + Level WRAM, WRAM2 and Level Objects WRAM. | high |
| `.Func_1f1420` | :1097 | `.RestoreLevelMapFromBackup` | For level backups 2/3: copies `s2b000` -> `s2a000` and SRAM3 -> SRAM1, then rewrites `s0a79d` (+echoes) under step markers $40-$43. | high |
| `Func_1f14c6` | :1175 | `BackupLevelMap` | Copies `s2a000` -> `s2b000` and SRAM1 -> SRAM3, writes `s0a79f` (+echoes) under markers $70-$73; called by `SaveLevel` before the 4th copy. | high |
| `.asm_1f0d0f` | :53 | `.no_valid_save` | `wcef1 = $ff` when no check values match or the three step markers disagree. | high |
| `.asm_1f0d20` | :66 | `.validate` | Calls `Func_1f0d60` and `Func_1f1246`. | high |
| `.asm_1f0dc2` / `.asm_1f0e47` | :175 / :254 | `.game_data_ok` / `.backup_game_data_ok` | Set bit 0 / bit 1 of `wceee`. | high |
| `Func_1f403f` | src/engine/pause/bank7d.asm:36 | `LoadPauseMenuTilemap` | Decompresses `PauseMenuAttrmap/Tilemap` (or the Time Attack ones and prints the level's best time); called from pause_menu_1.asm. | high |
| `.asm_1f4060` | bank7d.asm | `.time_attack` | Time Attack branch of the above. | high |

#### Object interactions (src/engine/level/object_interactions.asm)

The unnamed entries of `ProcessInteractions.table` and their shared helpers.
Renaming the matching `OBJ_INTERACTION_*` constants in the same pass would
make the object data readable.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_2022c` | :338 | `TouchObject` | Rolling -> `AttackObject`; touching from above/below -> `StepOnObject`; otherwise falls into `Func_2023b`. The default for the sting interactions' harmless sides (35 jumps). | high |
| `Func_2023b` | :347 | `BumpIntoObject` | Applies `wTouchState` overrides (attack / vanish / vulnerable), else attack if `wAttackCounter`, else `OBJACTION_BUMP` and `SetState_EnemyBumping` (Flat Wario: `Func_2028a`). | high |
| `Func_2028a` | :392 | `FlatWarioBumpIntoObject` | Faces away from the object and `SetState_FlatFalling` (only while jumping). | high |
| `Func_20602` | :777 | `JumpOffVanishingObject` | Vanishes the object (`OBJACTION_VANISH_TOUCH`) and makes Wario jump (full jump; higher with the High Jump Boots if A is held); with a transformation it only vanishes it. | medium |
| `Func_20670` | :829 | `GetStungByObject` | Rolling (or Garlic vs light objects) attacks instead; applies `wStingTouchState` overrides; else `OBJACTION_06` and `SetState_Stung` (or `Func_206eb` when a transformation is vulnerable). Used by all four sting interactions. | high |
| `Func_206eb` | :895 | `EndTransformationAndSting` | Releases the owl if Owl Wario, `ClearTransformationValues`, `UpdateLevelMusic`, then falls into `SetState_Stung`. Also called by `BlockFunc_NonSolidSpike/SolidSpike` when `wca94 == 1`. | high |
| `Func_207ed` | :1017 | `GetStungByObjectInWater` | Only in water: `wStingTouchState` overrides, else `OBJACTION_06` + `SetState_WaterStung`. Table slot `OBJ_INTERACTION_43`. | high |
| `Func_20899` | :1094 | `PushObjectInWater` | In water: `OBJACTION_WOBBLE` on the object and `StartDive` unless touching it from above. | medium |
| `Func_208f2` | :1134 | `BumpObjectInWater` | In water: `OBJACTION_BUMP` (local `.Bump`), then `StartDive`. | medium |
| `Func_2092d` | :1166 | `VanishTouchedObject` | `ld b, OBJACTION_VANISH_TOUCH / jp SetObjAction`. | high |
| `Func_20939` | :1176 | `BumpOffObject` | Unless `wTouchState` overrides: `OBJACTION_06` and `DoJumpingBump` away from the object (walk gfx, `Frameset_14a76/79`). | high |
| `Func_20932` | :1170 | `AttackOrBumpOffObject` | `AttackObject` if `wAttackCounter`, else `Func_20939`. | high |
| `Func_209ca` | :1233 | `StandOnSolidObject` | Lifts Wario by up to 2 px of `wc1c1`, `OBJACTION_STEP_ON`, `wIsOnSteppableObject`, lands him (`SetState_Idling`/`CrouchOrSlide`/`SetState_GrabIdling`). Used by the treasure chests, `ObjInteraction_Solid`, `ObjInteraction_Omodon`. | high |
| `Func_20a6f` | :1309 | `PushAgainstSolidObject` | Side contact with a solid object: pushes Wario out by `wc1c3`/`wc1c4` unless a wall is there, stops his walk, transformation-specific crashes (Ball o' String, Hot, Ice Skatin'), `DoJumpingBump` if rolling/attacking. | high |
| `Func_20a69` | :1304 | `SetObjAction_0D` | Just `OBJACTION_0D` (which puts the object in `OBJSTATE_19`); used by Food, Zombie Head, Snow. Name the action first. | low |
| `Func_20b6b` | :1411 | `ObjInteraction_Grabbable` | Slot `OBJ_INTERACTION_00`: step on from above, attack when rolling/attacking, pick up (`OBJACTION_PICK_UP`, `WST_PICKING_UP`) when Wario has the Grab Glove and faces it (Super Grab Gloves for heavy objects), else step on. Suggests `OBJ_INTERACTION_00` -> `OBJ_INTERACTION_GRABBABLE`. | high |
| `Func_20d1d` | :1620 | `ObjInteraction_Touch` | Slot `OBJ_INTERACTION_01`: `jp Func_2022c` (like `00` but can't be grabbed). | medium |
| `Func_20d81` | :1672 | `ObjInteraction_WaterBump` | Slot `OBJ_INTERACTION_06`: `Func_20899` vertically, `Func_208f2` sideways. | medium |
| `Func_20d8c` | :1678 | `ObjInteraction_WaterKnockBack` | Slot `OBJ_INTERACTION_07`: in water, stung from above, otherwise `SetState_SwimKnockBack` (or `StartDive` from below). | medium |
| `Func_20deb` | :1718 | `ObjInteraction_WaterFrontSting` | Slot `OBJ_INTERACTION_08`: the `ObjInteraction_FrontSting` logic with the water helpers. | high |
| `Func_20e39` | :1755 | `ObjInteraction_FrontBump` | Slot `OBJ_INTERACTION_09`: touching its front -> `Func_20939`, back -> `Func_2022c`, above/below -> step on. | medium |
| `Func_20e60` | :1774 | `ObjInteraction_BumpOff` | Slot `OBJ_INTERACTION_0A`: `jp Func_20939`. | medium |
| `Func_20e6a` | :1783 | `ObjInteraction_BumpOffNoActions` | Slot `OBJ_INTERACTION_0B`: `Func_20939`, then `OBJACTION_0A` (no actions for 15 frames). | low |

#### Object interactions, continued (`OBJ_INTERACTION_31` and up, src/engine/level/object_interactions.asm)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_21aac` | :3168 | `StandOnOrSmashObject` | From above: with a smash attack (`wIsSmashAttacking == 1`) `Func_20602` + `OBJACTION_SMASH_ATTACK_WALKABLE`, else `Func_209ca`. Used by `ObjInteraction_Walkable` and `Func_21c56`. | high |
| `Func_21abb` | :3177 | `AttackSolidObject` | `OBJACTION_ATTACK`, then `Func_20a6f` (push Wario out). | medium |
| `Func_21af1` | :3208 | `ObjInteraction_SolidBumpable` | Slot `OBJ_INTERACTION_31`: stand on it from above, step on from below, sideways `DoJumpingBump` when attacking else push out. | low |
| `Func_217a9` | :2837 | `DoJumpingBump_Far` | Just `farcall DoJumpingBump`. | medium |
| `Func_2160a` | :2678 | `TurnIntoBouncyWario` | Sets `TRANSFORMATION_BOUNCY_WARIO`, touch states, `wca94 = 1`, `BOUNCY_WARIO_DURATION`, `SetState_BouncyStart` (unless a persistent transformation); used by `ObjInteraction_Bouncy` and `ObjInteraction_DollBoyHammer`. | high |
| `Func_21b3a` | :3242 | `BumpOffObject_NoAction` | `Func_20939`, then clears the object's action (`OBJACTION_NONE`). | medium |
| `Func_21b78` | :3270 | `ObjInteraction_SmashableTop` | Slot `OBJ_INTERACTION_36`: smash attack from above -> `Func_20602` (vanish + jump), otherwise `Func_20939`. | medium |
| `Func_21c56` | :3362 | `ObjInteraction_GrabbableWalkable` | Slot `OBJ_INTERACTION_3B`: from above `Func_21aac`, otherwise `Func_20b6b` (grabbable). | medium |
| `Func_21cc9` | :3416 | `SetObjAction_13` | `OBJACTION_13` (object goes to `OBJSTATE_SPECIAL_3`); after `ObjInteraction_Tadpole`'s drag-down and `Func_21e8a`. Name the action first. | low |
| `Func_21d3b` | :3466 | `ObjInteraction_FrontStingBumpOff` | Slot `OBJ_INTERACTION_46`: front -> `Func_20670` (sting), everything else -> `Func_20e6a` (bump off). | medium |
| `Func_21d64` | :3485 | `ObjInteraction_TopStingBumpOff` | Slot `OBJ_INTERACTION_47`: from above sting, otherwise bump off. | medium |
| `Func_21d6f` | :3491 | `ObjInteraction_BottomStingSmashable` | Slot `OBJ_INTERACTION_48`: from below sting; from above smash -> vanish + jump, else bump off; sideways bump off. | low |
| `Func_21d88` | :3504 | `ObjInteraction_WaterFrontLaunch` | Slot `OBJ_INTERACTION_49`: in water, front -> `Func_21dac`, back -> `Func_208f2`, vertical -> `Func_20899`. | medium |
| `Func_21dac` | :3521 | `LaunchWario` | Faces Wario the object's way and `SetState_Launched` (unless a persistent transformation), `OBJACTION_06`. | high |
| `Func_21e9c` | :3628 | `ObjInteraction_GKTortoise` | Slot `OBJ_INTERACTION_GK_TORTOISE` (the constant is already named): as `TRANSFORMATION_BALL` -> `Func_21e8a`, else `Func_20939`. | high |
| `Func_21e8a` | :3624 | `ShootBallWario` | `SetState_BallShot`, then `Func_21cc9`. | medium |
| `Func_21ea6` | :3634 | `ObjInteraction_FrontPushBumpOff` | Slot `OBJ_INTERACTION_4F`: front -> face away and `Func_20a6f`, otherwise `Func_21b3a`. | low |
| `Func_21ecd` | :3656 | `ObjInteraction_FrontDragDown` | Slot `OBJ_INTERACTION_50`: front -> `SFX_FAT_WALK`, `SetState_DraggedDown` (as `ObjInteraction_Tadpole`), else bump off. | medium |
| `Func_21f01` | :3674 | `ObjInteraction_WaterKnockBackFromAbove` | Slot `OBJ_INTERACTION_51`: from above `SetState_SwimKnockBack` facing right, otherwise `Func_20d8c`. | low |
| `Func_21f28` | :3688 | `ObjInteraction_FrontStingSmashable` | Slot `OBJ_INTERACTION_52`: from above smashable (`Func_21d6f.asm_21d7e`), from below bump off, front sting, back bump off. | low |
| `Func_20fe8` | :1957 | `SetObjAction_06` | `ld b, OBJACTION_06 / jp SetObjAction`. Name the action first (it's what stinging/bumping objects get). | low |

### Phase 4: level engine (Wario states)

All `WST_*` update/set routines are named already; the unnamed ones are their
helpers. Three patterns cover most of them:

1. **Jump/fall entry points.** `SetState_SnowmanAirborne_Jump` and
   `SetState_SnowmanAirborne_Fall` already exist: a `_Jump` entry sets
   `wJumpVelIndex = 0` (and usually plays `SFX_JUMP`), a `_Fall` entry sets
   `FALLING_JUMP_VEL_INDEX`, and both fall through into `SetState_<X>Airborne`.
   Every unnamed routine below that does that gets the same scheme.
2. **Input handlers.** Called once from `UpdateState_<X>`, they start by
   reading `wJoypadPressed/Down` and pick the next state: `Handle<X>Input`.
3. **Airborne movement.** `ApplyJumpVelocity` + walk from input + cap
   `wWalkVelIndex`: `Handle<X>AirborneMovement`.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_1e1e3` | wario_states_1.asm:3639 | `SetState_RollingAirborne_Jump` | `wJumpVelIndex = 0`, `jr SetState_RollingAirborne`. | high |
| `Func_1e174` | wario_states_1.asm:3589 | `SetState_RollingAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, falls into `SetState_RollingAirborne`. | high |
| `Func_1ede9` | wario_states_1.asm:5006 | `SetState_GrabAirborne_Jump` | `SFX_JUMP`, index 0, `JUMP_VEL_HIGH_JUMP` with the High Jump Boots and UP, falls into `SetState_GrabAirborne`. | high |
| `Func_1edd3` | wario_states_1.asm:4994 | `SetState_GrabAirborne_Fall` | `GRAB_IDLE`, `FALLING_JUMP_VEL_INDEX`, `jr SetState_GrabAirborne`. | high |
| `Func_2838a` | wario_states_3.asm:392 | `SetState_HotAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, `JUMP_VEL_NORMAL`, `WST_HOT_AIRBORNE`. | high |
| `Func_28380` | wario_states_3.asm:385 | `SetState_HotAirborne_FallAligned` | Centres `wWarioXPos` on the block (`and $f0 / add 8`), then falls into `Func_2838a`. | medium |
| `Func_28c15` | wario_states_3.asm:1297 | `SetState_BallOStringAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, `JUMP_VEL_HIGH_JUMP`, `WST_BALL_O_STRING_AIRBORNE`. | high |
| `Func_290a1` | wario_states_3.asm:1739 | `SetState_FatAirborne_Jump` | `SFX_JUMP`, index 0, then `SetState_FatAirborne`. | high |
| `Func_290d6` | wario_states_3.asm:1764 | `SetState_FatAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, `wIsSmashAttacking = TRUE` (fat Wario lands with a ground pound). | high |
| `Func_29be1` | wario_states_3.asm:2977 | `SetState_ZombieAirborne_Jump` | Sets the jump frameset and index, falls into `SetState_ZombieAirborne`; called on A from the Zombie input handlers. | medium |
| `Func_29bb9` | wario_states_3.asm:2955 | `SetState_ZombieAirborne_Fall` | Called when there's no floor under Zombie Wario (`UpdateState_ZombieIdling/Walking/Airborne`). | medium |
| `Func_2a675` | wario_states_3.asm:4133 | `SetState_CrazyAirborne_Jump` | Index 0, `jr SetState_CrazyAirborne`. | high |
| `Func_2a67b` | wario_states_3.asm:4138 | `SetState_CrazyAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, falls into `SetState_CrazyAirborne`. | high |
| `Func_2a8ae` | wario_states_3.asm:4371 | `SetState_VampireAirborne_Jump` | `SFX_01D`, index 0, falls into `SetState_VampireAirborne`. | high |
| `Func_2a8a7` | wario_states_3.asm:4366 | `SetState_VampireAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, `jr SetState_VampireAirborne`. | high |
| `Func_2af81` | wario_states_3.asm:5085 | `SetState_OnFireAirborne_Jump` | `SFX_JUMP`, index 0, `JUMP_VEL_NORMAL`, falls into `SetState_OnFireAirborne`. | high |
| `Func_2af75` | wario_states_3.asm:5078 | `SetState_OnFireAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, `JUMP_VEL_HIGH_JUMP`, `jr SetState_OnFireAirborne`. | high |
| `Func_1ed558` | wario_states_4.asm:2226 | `SetState_BlindAirborne_Jump` | `SFX_JUMP`, index 0, `wJumpingUpwards`, falls into `SetState_BlindAirborne`. | high |
| `Func_1ed548` | wario_states_4.asm:2217 | `SetState_BlindAirborne_Fall` | `FALLING_JUMP_VEL_INDEX`, `JUMP_VEL_HIGH_JUMP`, `SetState_BlindAirborne`. | high |
| `Func_2a0b2` | wario_states_3.asm:3522 | `StartBouncyJump` | A held -> `Func_2a0bb`, else `Func_2a0c2`; called from `StepOnObject` (bouncing off an object as Bouncy Wario). | medium |
| `Func_2a0bb` / `Func_2a0c2` | wario_states_3.asm:3528 / 3533 | `StartBouncyJump_High` / `StartBouncyJump_Normal` | Set `JUMP_VEL_BOUNCY_HIGH_JUMP` / `JUMP_VEL_BOUNCY_JUMP`. | high |
| `Func_1ec64d` | wario_states_4.asm:702 | `SetState_ReleasingOwl` | Sets `WST_RELEASING_OWL` and calls `ReleaseOwl`; reached from `UpdateState_OwlSlow/OwlFast` (relevant to the debug owl). | high |
| `Func_2ac7d` | wario_states_3.asm:4776 | `SetState_InBubble` | Sets `WST_IN_BUBBLE`, collision box, gfx; called by `ObjInteraction_Bubble`. | high |
| `Func_1edd24` | wario_states_4.asm:2849 | `SetState_BallBouncing` | Sets `WST_BALL_BOUNCING`; reached from `Func_1edaca`/`Func_1edaf8`. | high |
| `Func_19e89` | wario_states_2.asm:283 | `SetState_CrouchSlipping_KeepCounter` | Second entry of `SetState_CrouchSlipping` that skips resetting `wWarioStateCounter/Cycles`; used from `UpdateState_Slipping` when DOWN is held. | medium |
| `Func_1de3f` | wario_states_1.asm:3261 | `StartThrow` | `UpdateState_ThrowCharging` jumps here when B is released: throw frameset, `GRAB_THROW`, falls into `SetState_Throwing`. | high |
| `Func_1dd78` | wario_states_1.asm:3169 | `DropObjectAndJump` | Clears `wGrabState` and `StartJump_FromInput`; A pressed while picking up / charging a throw. | high |
| `Func_1ec19` | wario_states_1.asm:4799 | `CrouchJump` | Tries the standing collision box (top -27) and starts `StartCrouchJump`; A while crouching. | medium |
| `Func_1ec4b` | wario_states_1.asm:4822 | `StandUpAndAttack` | B while crouching: `SetState_Attacking` if there's room to stand up. | medium |
| `Func_1eb46` | wario_states_1.asm:4704 | `HandleCrouchingInput` | Only caller `UpdateState_Crouching`. | high |
| `Func_1ec6c` | wario_states_1.asm:4835 | `HandleCrouchWalkingInput` | Only caller `UpdateState_CrouchWalking`. | high |
| `Func_1ee88` | wario_states_1.asm:5076 | `HandleGrabIdlingInput` | Only caller `UpdateState_GrabIdling`. | high |
| `Func_1eefc` | wario_states_1.asm:5128 | `HandleGrabWalkingInput` | Only caller `UpdateState_GrabWalking`. | high |
| `Func_1f1a9` | wario_states_1.asm:5462 | `HandleSubmergedInput` | Only caller `UpdateState_Submerged`; B -> `StartUnderwaterThrusting`. | high |
| `Func_1f24c` | wario_states_1.asm:5529 | `HandleSwimming` | D-pad swimming while submerged (dispatches to the four helpers below, loops `SFX_00E`). | medium |
| `Func_1f310` | wario_states_1.asm:5609 | `SwimForward` | Front collision, then moves Wario left/right against `wCurWaterCurrent`. | medium |
| `Func_1f357` | wario_states_1.asm:5649 | `SwimDownForward` | Centre (floor) collision then `Func_1f310`. | low |
| `Func_1f3a7` | wario_states_1.asm:5676 | `SwimDown` | Floor collision, else `MoveWarioDown` (sets `wc0e1 = PAD_DOWN` when blocked). | medium |
| `Func_1f3d9` | wario_states_1.asm:5696 | `SwimUp` | `CheckUpCollision`, `Func_19acd` (surface if out of water), `MoveWarioUp`. | medium |
| `Func_1f825` | wario_states_1.asm:6185 | `HandleSlidingInput` | Only caller `UpdateState_Sliding`. | high |
| `Func_1f6c2` | wario_states_1.asm:6005 | `BlinkWarioPal` | Alternates `WarioInvisiblePal`/default palette every 8 frames; used by `UpdateState_Stung/StungRecovery`. | high |
| `Func_1f863` | wario_states_1.asm:6223 | `MoveWarioUpBySwimVel` | `MoveWarioUp` by `SwimStraightVelTable[de]`; used by the bat flying handler. | medium |
| `Data_1f894` | wario_states_1.asm:6233 | `UnderwaterThrustVelTable` | Indexed in `HandleUnderwaterThrustingInput` like `SwimStraightVelTable`. | low |
| `Func_1e6ea` | wario_states_1.asm:4220 | `SetWarioWalkAnimation` | Walk gfx (`WarioWalkGfx`, `OAM_1426c`) and `Frameset_149b4/149c5` by direction; used by `SetState_SandWalking` and `SetNextGetTreasureState`. | medium |
| `Func_1a12a` / `Func_1a14b` | wario_states_2.asm:563 / 579 | `SetWarioSandJumpAnimation` / `SetWarioSandJumpFrameset` | Tail of `SetState_SandJumping`: airborne gfx/OAM, then `Frameset_15f94/97`; the frameset half is also used by `Func_1b2c0`. | low |
| `Func_1b168` | wario_states_2.asm:2186 | `HandleFenceMovingVerticalInput` | Only caller `UpdateState_FenceMovingVertical`. | high |
| `Func_1b21a` | wario_states_2.asm:2244 | `HandleFenceIdlingInput` | Only caller `UpdateState_FenceIdling`. | high |
| `Func_1b24f` | wario_states_2.asm:2267 | `HandleFenceMovingHorizontalInput` | Only caller `UpdateState_FenceMovingHorizontal`. | high |
| `Func_1b2c0` | wario_states_2.asm:2313 | `HandleSandFallingInput` | Only caller `UpdateState_SandFalling`. | high |
| `Func_1b302` | wario_states_2.asm:2338 | `SinkInSand` | Floor check, else `MoveWarioDown` by 1. | medium |
| `Func_1b322` | wario_states_2.asm:2353 | `HandleSandIdlingInput` | Only caller `UpdateState_SandIdling`. | high |
| `Func_1b333` | wario_states_2.asm:2362 | `HandleSandWalkingInput` | Only caller `UpdateState_SandWalking`. | high |
| `Func_1b480` | wario_states_2.asm:2495 | `HandleLadderIdlingInput` | Only caller `UpdateState_LadderIdling`. | high |
| `Func_28f6d` | wario_states_3.asm:1621 | `HandleFatIdlingInput` | Only caller `UpdateState_FatIdling`. | high |
| `Func_2b239` | wario_states_3.asm:5393 | `HandleFatWalkingInput` | Only caller `UpdateState_FatWalking`. | high |
| `Func_2b10a` | wario_states_3.asm:5265 | `HandleFlatIdlingInput` | Only caller `UpdateState_FlatIdling`. | high |
| `Func_2b11b` | wario_states_3.asm:5274 | `HandleFlatWalkingInput` | Only caller `UpdateState_FlatWalking`. | high |
| `Func_2b34e` | wario_states_3.asm:5517 | `HandleZombieIdlingInput` | Only caller `UpdateState_ZombieIdling`. | high |
| `Func_2b381` | wario_states_3.asm:5542 | `HandleZombieWalkingInput` | Only caller `UpdateState_ZombieWalking`. | high |
| `Func_2b3f9` | wario_states_3.asm:5600 | `HandleCrazyInput` | Only caller `UpdateState_Crazy`. | high |
| `Func_2b42b` | wario_states_3.asm:5630 | `HandleCrazyWalking` | Increments `wWalkVelIndex`, staggers left/right with wall checks and dust (`Func_2b4d0`). | low |
| `Func_2b4d0` | wario_states_3.asm:5703 | `CreateDustParticleAtWario` | `get_pos` + `PARTICLE_DUST` + `CreateParticle`. | high |
| `Func_2b4f3` | wario_states_3.asm:5709 | `HandleVampireIdlingInput` | Only caller `UpdateState_VampireIdling`; B -> `SetState_BatTransforming`. | high |
| `Func_2b509` | wario_states_3.asm:5720 | `HandleVampireWalkingInput` | Only caller `UpdateState_VampireWalking`. | high |
| `Func_2b63b` | wario_states_3.asm:5840 | `HandleBatFlyingInput` | Only caller `UpdateState_BatFlying`; A released -> `SetState_BatFalling`. | high |
| `Func_2ae8a` | wario_states_3.asm:4986 | `HandleOnFireInput` | Only caller `UpdateState_OnFire`. | high |
| `Func_1ede96` | wario_states_4.asm:3210 | `HandleSnowmanWalkingInput` | Only caller `UpdateState_SnowmanWalking`. | high |
| `Func_1edf93` | wario_states_4.asm:3308 | `HandleBlindIdlingInput` | Only caller `UpdateState_BlindIdling`. | high |
| `Func_1edfa4` | wario_states_4.asm:3317 | `HandleBlindWalkingInput` | Only caller `UpdateState_BlindWalking`. | high |
| `Func_1edf47` | wario_states_4.asm:3278 | `HandleFanInput` | Fan lifting/spinning: turns with the D-pad (`SetState_FanTurning`), drifts sideways with wall checks. | medium |
| `Func_1edf2b` | wario_states_4.asm:3269 | `RiseInAirCurrent` | `Func_19acd`; out of the air current -> `SetState_FanSpinning`, else `MoveWarioUp` 1. | medium |
| `Func_1edaca` / `Func_1edaf8` | wario_states_4.asm:2805 / 2827 | `HandleBallInput` / `HandleBallAirborneInput` | D-pad against the facing direction -> `SetState_BallTurning`, else `SetState_BallBouncing`. | low |
| `Func_2af9c` | wario_states_3.asm:5101 | `HandleOnFireAirborneMovement` | `ApplyJumpVelocity`, `HandleWalk`, cap `wWalkVelIndex`; only caller `UpdateState_OnFireAirborne`. | medium |
| `Func_2b027` | wario_states_3.asm:5164 | `HandleHotAirborneMovement` | Same idea for `UpdateState_HotAirborne`. | medium |
| `Func_2b2a4` | wario_states_3.asm:5439 | `HandleFatAirborneMovement` | `UpdateState_FatAirborne`. | medium |
| `Func_2b3dd` | wario_states_3.asm:5581 | `HandleZombieAirborneMovement` | `UpdateState_ZombieAirborne`, `UpdateState_ZombieSlippingThroughFloor`. | medium |
| `Func_2b55c` | wario_states_3.asm:5752 | `HandleVampireAirborneMovement` | `UpdateState_VampireAirborne`. | medium |
| `Func_1edf01` | wario_states_4.asm:3253 | `HandleSnowmanAirborneMovement` | `UpdateState_SnowmanAirborne`. | medium |
| `Func_1ee00f` | wario_states_4.asm:3364 | `HandleBlindAirborneMovement` | `UpdateState_BlindAirborne`. | medium |
| `Func_1ee02e` | wario_states_4.asm:3375 | `HandleBallAirborneMovement` | `UpdateState_BallAirborne`. | medium |
| `Func_2b17a` | wario_states_3.asm:5315 | `WalkFromInput` | `WalkRight`/`WalkLeft` from the D-pad; 13 callers. | high |
| `Func_2b342` | wario_states_3.asm:5509 | `MoveWarioUpSlowly` | `MoveWarioUp` 1 every other frame. | high |
| `Func_2b2c2` | wario_states_3.asm:5455 | `HandlePuffyRising` | Rises (`Func_2b342`), ceiling -> `SetState_PuffyDeflating`, D-pad turning, floor transitions upwards. | medium |
| `Func_2b56f` | wario_states_3.asm:5763 | `HandleInBubble` | Rises every other frame, drifts, pops (`RecoverFromTransformation`) against walls/ceilings. | medium |
| `Func_2ae5c` | wario_states_3.asm:4951 | `IsTransformationEnding` | Carry when `wTransformationDuration` is nearly over. | medium |
| `Func_2ae3b` | wario_states_3.asm:4932 | `BlinkPalIfTransformationEnding` | Calls `Func_2ae5c` and toggles the palette when it returns carry. | medium |
| `Func_2ad6a` | wario_states_3.asm:4860 | `RecoverFromTransformation_Underwater` | `ClearTransformationValues`, 16 invincible frames, `SetState_Submerged`. | medium |
| `Func_2ade4` | wario_states_3.asm:4907 | `RecoverFromTransformation_InWater` | Same but splash + `DiveFromSurface_SkipSplash` (Hot/On Fire Wario falling into water). | medium |
| `Func_1ed09b` | wario_states_4.asm:1742 | `TurnAndRecoverFromTransformation` | Flips `wDirection`, `jp RecoverFromTransformation`. | high |
| `Func_1ede4d` | wario_states_4.asm:3185 | `LeaveRailAndJump` | Ends the rail transformation (`ClearTransformationValues`, default palette) and `StartJump_FromInput`. | medium |
| `Func_1ede69` | wario_states_4.asm:3193 | `LeaveRailAndFall` | Same, then `Func_1e174` (rolling fall). | medium |
| `Func_1ec215` | wario_states_4.asm:235 | `IceSkatinCrashIntoWall` | Steps 3 px back and `SetState_IceSkatinCrash`; also from `Func_20a6f`. | high |
| `Func_28bd5` | wario_states_3.asm:1266 | `BallOStringBounceOffWall` | Flips direction, then `SetState_BallOStringKnockBack`; also from `Func_20a6f`. | medium |
| `Func_2afc5` | wario_states_3.asm:5118 | `HotBounceOffWall` | Flips direction and steps back; from `Func_20a6f` while Hot. | low |

Also noticed: `UpdateStart_FanLifting`, `UpdateStart_FanTurning` and
`UpdateStart_FanRecovering` (wario_states_4.asm:43-46, 1854, 1908, 1991) are
entries of the `WST_FAN_*` update table: almost certainly typos for
`UpdateState_*` (every other entry uses that prefix). High confidence.

### Phase 4: level engine (block functions, src/engine/level/block_functions.asm)

Breakable blocks come in families. Each family has a shared
`<Family>Collision` body and one tiny entry per replacement block
(`ld b, $78`..`$7f`: the block type the broken block turns into), named
`BlockFunc_<Family>_<xx>` (existing: `CrackedBlock`, `NonCrackedBlock`,
`CrackedBlockWithColourCoin`, `EnemyBlock`, `BonfireBlock`, `DoughnutBlock`,
`YarnBlock`). The unnamed families are the *multi-block* ones: when one is
broken they set `wMultiBlockParam` to a direction (1 = right, 2 = left,
3 = down, 4 = up, as decoded in `ProcessMultiBlock.ProcessBlocks`) so the
neighbouring block in that direction breaks next, which is how large
(multi-block) blocks break as a whole. The existing `YarnBlockCollision` is
the "up" member of one such family. Entries that the block tables don't
reference are marked `; unreferenced` in the source; they still follow the
scheme.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_18aa8` (+ entries `BlockFunc_18aa6` $78, `Func_18a9a` $79, `Func_18a9e` $7a, `Func_18aa2` $7b) | :1385 | `SnowballBlockRightCollision` (+ `BlockFunc_SnowballBlockRight_78/79/7a/7b`) | Breaks only for Snowman Wario rolling as a snowball (`wWarioTransformationProgress >= 1`, "; not in snowball"), chain direction 1 (right). | high |
| `Func_18aec` (+ `BlockFunc_18aea` $78, `Func_18ade/18ae2/18ae6` $79-$7b) | :1421 | `SnowballBlockDownCollision` (+ entries) | Same, direction 3 (down). | high |
| `Func_18b2d` (+ `BlockFunc_18b2b` $78, `Func_18b1f` $79, `BlockFunc_18b23` $7a, `Func_18b27` $7b) | :1462 | `SnowballBlockLeftCollision` (+ entries) | Direction 2 (left). | high |
| `Func_18b71` (+ `BlockFunc_18b6f` $78, `Func_18b63` $79, `BlockFunc_18b67` $7a, `Func_18b6b` $7b) | :1504 | `SnowballBlockUpCollision` (+ entries) | Direction 4 (up). | high |
| `Func_18bb5` (+ `BlockFunc_18bb3` $78, `Func_18ba7/18bab/18baf` $79-$7b) | :1547 | `BigSnowballBlockRightCollision` (+ entries) | Same as the snowball family but requires `wWarioTransformationProgress == 3` ("; not big snowball"); direction right. | high |
| `Func_18bf9` (+ `BlockFunc_18bf7` $78, `Func_18beb/18bef/18bf3`) | :1590 | `BigSnowballBlockDownCollision` (+ entries) | Direction down. | high |
| `Func_18c3a` (+ `BlockFunc_18c38` $78, `Func_18c2c` $79, `BlockFunc_18c30` $7a, `Func_18c34` $7b) | :1631 | `BigSnowballBlockLeftCollision` (+ entries) | Direction left. | high |
| `Func_18c7e` (+ `BlockFunc_18c7c` $78, `Func_18c70` $79, `BlockFunc_18c74` $7a, `Func_18c78` $7b) | :1673 | `BigSnowballBlockUpCollision` (+ entries) | Direction up. | high |
| `Func_18e2c` (+ `BlockFunc_18e2a` $78, `BlockFunc_18e0e` $79, `Func_18e12` $7a, `Func_18e16` $7b, `BlockFunc_18e1a` $7c, `Func_18e1e` $7d, `Func_18e22` $7e, `BlockFunc_18e26` $7f) | :1944 | `LargeCrackedBlockRightCollision` (+ `BlockFunc_LargeCrackedBlockRight_78`..`_7f`) | The `CrackedBlockCollision` rules (Robo-Mouse, attack/roll from the side, Head Smash Helmet from below) plus chain direction right. | high |
| `Func_18ec0` (+ 8 entries `BlockFunc_18ebe`, `BlockFunc_18ea2`, `Func_18ea6`, `Func_18eaa`, `BlockFunc_18eae`, `Func_18eb2`, `Func_18eb6`, `Func_18eba`) | :2038 | `LargeCrackedBlockDownCollision` (+ entries) | Direction down. | high |
| `Func_18f7d` (+ `BlockFunc_18f7b`, `BlockFunc_18f5f`, `Func_18f63`, `Func_18f67`, `BlockFunc_18f6b`, `Func_18f6f`, `Func_18f73`, `Func_18f77`) | :2159 | `LargeCrackedBlockLeftCollision` (+ entries) | Direction left; its comment "same as Func_19011 but outputs $02" confirms the family. | high |
| `Func_19011` (+ `BlockFunc_1900f`, `BlockFunc_18ff3`, `Func_18ff7`, `Func_18ffb`, `BlockFunc_18fff`, `Func_19003`, `BlockFunc_19007`, `Func_1900b`) | :2253 | `LargeCrackedBlockUpCollision` (+ entries) | Direction up. | high |
| `Func_190fe` (+ `BlockFunc_190fc`, `Func_190e0`, `BlockFunc_190e4`, `BlockFunc_190e8`, `Func_190ec`, `Func_190f0`, `Func_190f4`, `Func_190f8`) | :2392 | `LargeNonCrackedBlockRightCollision` (+ entries) | The `NonCrackedBlockCollision` rules (Fat Wario, or Garlic and better; Super Jump Slam Overalls for smash attacks) plus chain direction right. | high |
| `Func_191b3` (+ 8 entries from `Func_19195` to `BlockFunc_191b1`) | :2501 | `LargeNonCrackedBlockDownCollision` (+ entries) | Direction down. | high |
| `Func_19291` (+ 8 entries from `Func_19273` to `BlockFunc_1928f`) | :2636 | `LargeNonCrackedBlockLeftCollision` (+ entries) | Direction left. | high |
| `Func_19346` (+ 8 entries from `Func_19328` to `BlockFunc_19344`) | block_functions.asm | `LargeNonCrackedBlockUpCollision` (+ entries) | Direction up. | high |
| `Func_19522` (+ `BlockFunc_19520` $78, `Func_19514` $79, `BlockFunc_19518` $7a, `Func_1951c` $7b) | block_functions.asm | `YarnBlockRightCollision` (+ `BlockFunc_YarnBlockRight_*`) | Ball o' String Wario only, direction right. The existing `YarnBlockCollision` (direction up, entries `BlockFunc_YarnBlock_78/79`) would become `YarnBlockUpCollision`. | high |
| `Func_19560` (+ `BlockFunc_1955e`, `BlockFunc_19552`, `BlockFunc_19556`, `Func_1955a`) | block_functions.asm | `YarnBlockDownCollision` (+ entries) | Direction down. | high |
| `Func_1959b` (+ `BlockFunc_19599`, `BlockFunc_1958d`, `Func_19591`, `Func_19595`) | block_functions.asm | `YarnBlockLeftCollision` (+ entries) | Direction left. | high |
| `Func_19502` (+ entries `Func_194e4`..`Func_19500`, $78-$7f) | :3055 | `SmallYarnBlockCollision` (+ `BlockFunc_SmallYarnBlock_*`) | Single (non-chaining) yarn block: solid unless Ball o' String Wario touches it (`Func_19481`). All 8 entries unreferenced. | medium |
| `Func_195cf` / `Func_195d3` | block_functions.asm | `BlockFunc_YarnBlock_7a` / `BlockFunc_YarnBlock_7b` | Missing members of the existing `YarnBlock` entries ($7a/$7b). | high |
| `Func_18a0f` / `Func_18a17` | :1291 / :1300 | `BlockFunc_CrackedBlockWithColourCoin_7d` / `_7f` | Missing members of the existing family. | high |
| `Func_19467` | block_functions.asm | `BlockFunc_BonfireBlock_7f` | Missing member. | high |
| `Func_194a7`..`Func_194b3` | block_functions.asm | `BlockFunc_DoughnutBlock_7c`..`_7f` | Missing members. | high |
| `Func_18f32` | :2095 | `StartMultiBlockBreak` | Saves the origin (`wcedb/wcedc/wcedf`), turns the block into `b`, `Func_e31`, `BreakBlock`, returns free. Target of every chaining family (28 jumps). | high |
| `Func_19086` | :2310 | `StartMultiBlockBreak_Wario` | Same start, but returns solid/free from Wario's state like the single cracked blocks (passes through when rolling or Fat). | medium |
| `Func_19246` | :2573 | (duplicate of `Func_18f32`) | Same instructions as `Func_18f32`. | medium |
| `Func_193dc` | :2817 | `StartMultiBlockBreak_SolidUnlessRolling` | Same start, ends in `Func_18df1`. | low |
| `Func_18df1` | :1890 | `BreakBlock_SolidUnlessRolling` | Turns the block into `b`, `Func_e31`, `BreakBlock`; free if rolling, else solid. | medium |
| `BlockFunc_182dc` | :448 | `BlockFunc_SolidLadderTop` | `BlockFunc_LadderTop` for Wario, but solid (not a one-way floor) for objects. | medium |
| `Func_182ec` | :460 | `LadderTopCollision` | Env probe -> `LADDER_UNDERNEATH`, any other probe -> floor. | medium |
| `BlockFunc_182fe` / `Func_1831a` | :470 / :483 | `BlockFunc_LadderExit_ReloadObjects` / `LadderExitCollision` | Env probe: `LADDER_COLLISION` plus `ROOMTRANSITION_5` (with/without `ROOMTRANSITIONF_RELOAD_OBJECTS`): a ladder that leads to another room. Name after `ROOMTRANSITION_5` once that is named. | low |
| `Func_18064` / `Func_18078` / `Func_1808c` | :64 / :77 / :89 | `BlockFunc_Result10` / `BlockFunc_Result01` / `BlockFunc_Result00` | Like `BlockFunc_Free` but return `wUnused_c18d` = $10 / $01 / $00. Low value; listed for completeness. | low |
| `BlockFunc_1809f` / `BlockFunc_180b5` | :99 / :111 | `BlockFunc_RightSlopeUpper` / `BlockFunc_RightSlopeLower` | Next to `BlockFunc_RightSlope` in the tables ($1b/$2b next to $23); run `RightSlopeCollision` with the probe moved one block down/up. Which half is which was inferred from the sign only. | low |
| `BlockFunc_18129` / `BlockFunc_1813f` | :202 / :214 | `BlockFunc_LeftSlopeUpper` / `BlockFunc_LeftSlopeLower` | Same for `LeftSlopeCollision`. | low |

### Phase 5: `unk` fields and constants

Already covered above: `OBJ_UNK_01/02` (+`wCurObjUnk01/02`), `OBJ_UNK_1D`
(+`wCurObjUnk1d`), `OBJSUBFLAG_UNK_4`, `COLLISION_UNK1..7`. Additional ones:

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `\1Unk7` field of `scene_obj_struct` (`wSceneObj1..12Unk7`, `wSceneWarioUnk7`, `wCompassObjUnk7`, `wOWUIObj1/2Unk7`) | src/macros/wram.asm:35 | `\1MovementStep` | Byte 7 of the struct: `ApplyOWMovement`'s helper `Func_3c35` (home/overworld.asm) reads and increments it as the index into the relative-movement table ("; unk7"), and `Func_3c29` resets it at the `$80` terminator. The scenes that write it (bank2b_1.asm:3579-3606, bank27.asm:5465) reset it before a new movement. | high |
| `WarioUnk2Gfx` | src/engine/overworld/bank76.asm:253 | `WarioCrashGfx` | Graphics of `SCENEWARIO_GROUP_05`: `SCENEWARIO_ON_FIRE`, `CRASH_LAND_*`, `CRASH_TUMBLE(_END)`, `STUNNED_*`, `LOOK_UP` (src/constants/event_constants.asm:129). | medium |
| `WarioUnk3Gfx` | bank76.asm:256 | `WarioMusicBoxGfx` | `SCENEWARIO_GROUP_06`: `LOOK_MUSIC_BOX`, `PICKUP_MUSIC_BOX`, `HOLD_MUSIC_BOX`, `LOOK_UP_SURPRISED`, `CARRY_SNAP_FINGERS`. | medium |
| `WarioUnk4Gfx` | src/engine/overworld (see `scene_wario_gfx` table, bank2b_1.asm:1482) | `WarioBowGfx` | `SCENEWARIO_GROUP_08`: `JUMP_AND_BOW`, `SNAP_FINGERS`, `SHOW_MUSIC_BOXES_1/5`, `PANIC(_JUMP)`, `BOW`. | low |
| `WarioUnk5Gfx` | (same table, bank2b_1.asm:1483) | `WarioShowMusicBoxesGfx` | `SCENEWARIO_GROUP_19`: `SHOW_MUSIC_BOXES_2/3/4` only. | medium |
| `GRAB_UNK_02` | src/constants/wario_constants.asm:117 | `GRAB_PICK_UP_BLOCKED` | Only set in `_ObjState_PickedUpLeft/Right` (update_objects.asm:1260, 1470) when a light object being lifted would hit the ceiling (`Func_358b` head probe), together with `OBJSTATE_19` for the object. What Wario does in that grab state wasn't traced. | low |

### Phase 6: object state handlers (`.Func_` locals in src/engine/level/objects/)

16 enemies have a full positional state jumptable (93 entries for
`OBJSTATE_00`..`OBJSTATE_5C`, or 96 up to `OBJSTATE_FULL_THROW_RIGHT`) whose
entries are object-local `.Func_xxxxx` labels. The slot fixes what the
handler is for, and three files already name such locals after their slot
(spearhead.asm: `.Walk`, `.TurnAround`, `.StunLeft`, `.FullThrowLeftStart`,
`.State3b`; count_richtertoffen.asm and doughnuteer.asm: `.Default`, `.Land`),
so the same names apply here. Generated mechanically from the tables (475
labels in 16 files), then spot-checked; rules:

- a label used in 4 or more slots is the object's do-nothing/default handler: `.Default`;
- otherwise the name of its (first) slot: `OBJSTATE_TURN_AROUND_START` -> `.TurnAroundStart`;
  a numbered slot gets spearhead's `.StateXX` style (third column) until the
  constant itself is named (see the `OBJSTATE_*` suggestions in Phase 2);
- `.Special1/2/3` (`OBJSTATE_SPECIAL_1..3`) are object-specific
  (spearhead calls them `.Sleep`, `.Angry`, `.WakeUp`) and should be renamed
  after reading each object;
- a `_xxxxx` suffix marks names that would occur twice in one table.

Confidence is medium for the whole table: the slot is certain, but the
object-specific behaviour of each handler wasn't read.
| Object (file, routine) | Proposed local names (label -> name, from its slot) | Numeric-only slots | Conf. |
|---|---|---|---|
| src/engine/level/objects/barrel.asm (`Barrel2Func`) | `.Func_435a6` -> `.Default`, `.Func_435df` -> `.BumpLeftStart`, `.Func_435e7` -> `.BumpRightStart`, `.Func_436cf` -> `.AttackedLeftStart`, `.Func_436c1` -> `.AttackedRightStart`, `.Func_4360b` -> `.PickedUpLeftStart`, `.Func_43624` -> `.PickedUpRightStart`, `.Func_435de` -> `.TurnAroundStart`, `.Func_435c2` -> `.Special3`, `.Func_43689` -> `.FullThrowLeftStart`, `.Func_43697` -> `.FullThrowRightStart` | `.Func_4367c` -> `.State12`, `.Func_435f8` -> `.State14`, `.Func_435fc` -> `.State15`, `.Func_4365c` -> `.State18`, `.Func_4363d` -> `.State19`, `.Func_436a5` -> `.State28`, `.Func_436b3` -> `.State29`, `.Func_4366b` -> `.State48`, `.Func_4364c` -> `.State49` | medium |
| src/engine/level/objects/beam_bot.asm (`BeamBotFunc`) | `.Func_46691` -> `.Default`, `.Func_46748` -> `.Land`, `.Func_46874` -> `.BumpLeftStart`, `.Func_4687c` -> `.BumpRightStart`, `.Func_46a32` -> `.AttackedLeftStart`, `.Func_46a3c` -> `.AttackedRightStart`, `.Func_46a62` -> `.PickedUpLeftStart`, `.Func_46a75` -> `.PickedUpRightStart`, `.Func_469e2` -> `.WobbleLeftStart`, `.Func_469ec` -> `.WobbleRightStart`, `.Func_466cb` -> `.StandingFallStart`, `.Func_46989` -> `.TurnAroundStart`, `.Func_468aa` -> `.StunLeftStart`, `.Func_468dd` -> `.StunRightStart`, `.Func_466e7` -> `.Special1`, `.Func_4672c` -> `.Special2`, `.Func_46769` -> `.Walk`, `.Func_469b2` -> `.TurnAround`, `.Func_468cf` -> `.StunLeft`, `.Func_46902` -> `.StunRight` | `.Func_46945` -> `.State0f`, `.Func_4696e` -> `.State10`, `.Func_46aeb` -> `.State12`, `.Func_46910` -> `.State14`, `.Func_46918` -> `.State15`, `.Func_46ab9` -> `.State18`, `.Func_46a88` -> `.State19`, `.Func_46a28` -> `.State28`, `.Func_46a1e` -> `.State29`, `.Func_46954` -> `.State3f`, `.Func_4697c` -> `.State40`, `.Func_46ada` -> `.State48`, `.Func_46aa9` -> `.State49` | medium |
| src/engine/level/objects/brrr_bear.asm (`BrrrBearFunc`) | `.Func_4811f` -> `.Default`, `.Func_481aa` -> `.Land`, `.Func_482b2` -> `.BumpLeftStart`, `.Func_482ba` -> `.BumpRightStart`, `.Func_48434` -> `.AttackedLeftStart`, `.Func_48458` -> `.AttackedRightStart`, `.Func_4848e` -> `.PickedUpLeftStart`, `.Func_484a1` -> `.PickedUpRightStart`, `.Func_483f5` -> `.WobbleLeftStart`, `.Func_483ff` -> `.WobbleRightStart`, `.Func_480e7` -> `.VanishTouch`, `.Func_48153` -> `.StandingFallStart`, `.Func_483a4` -> `.TurnAroundStart`, `.Func_482e0` -> `.StunLeftStart`, `.Func_48301` -> `.StunRightStart`, `.Func_4816f` -> `.Special1`, `.Func_481ca` -> `.Walk`, `.Func_483c5` -> `.TurnAround`, `.Func_482f3` -> `.StunLeft`, `.Func_48314` -> `.StunRight` | `.Func_48341` -> `.State0f`, `.Func_4836a` -> `.State10`, `.Func_484f3` -> `.State12`, `.Func_48322` -> `.State14`, `.Func_48326` -> `.State15`, `.Func_484d3` -> `.State18`, `.Func_484b4` -> `.State19`, `.Func_4842a` -> `.State28`, `.Func_48420` -> `.State29`, `.Func_48350` -> `.State3f`, `.Func_48399` -> `.State40`, `.Func_484e2` -> `.State48`, `.Func_484c3` -> `.State49` | medium |
| src/engine/level/objects/doughnuteer.asm (`DoughnuteerFunc`) | `.Func_41cdb` -> `.Default`, `.Func_41d36` -> `.Land`, `.Func_41e3a` -> `.BumpLeftStart`, `.Func_41e7c` -> `.BumpRightStart`, `.Func_42034` -> `.AttackedLeftStart`, `.Func_4203e` -> `.AttackedRightStart`, `.Func_42064` -> `.PickedUpLeftStart`, `.Func_42077` -> `.PickedUpRightStart`, `.Func_41fe9` -> `.WobbleLeftStart`, `.Func_41ff3` -> `.WobbleRightStart`, `.Func_41d1a` -> `.StandingFallStart`, `.Func_41fa1` -> `.TurnAroundStart`, `.Func_41ed7` -> `.StunLeftStart`, `.Func_41f02` -> `.StunRightStart`, `.Func_41d56` -> `.Walk`, `.Func_41e53` -> `.BumpLeft`, `.Func_41eae` -> `.BumpRight`, `.Func_41fbd` -> `.TurnAround`, `.Func_41ef4` -> `.StunLeft`, `.Func_41f1f` -> `.StunRight` | `.Func_41f5d` -> `.State0f`, `.Func_41f86` -> `.State10`, `.Func_420e3` -> `.State12`, `.Func_41f2d` -> `.State14`, `.Func_41f35` -> `.State15`, `.Func_420b6` -> `.State18`, `.Func_4208a` -> `.State19`, `.Func_4202a` -> `.State28`, `.Func_42020` -> `.State29`, `.Func_41bae` -> `.State2b`, `.Func_41c8b` -> `.State2c`, `.Func_41f6c` -> `.State3f`, `.Func_41f94` -> `.State40`, `.Func_420d2` -> `.State48`, `.Func_420a6` -> `.State49`, `.Func_41b58` -> `.State5a`, `.Func_41bdc` -> `.State5b`, `.Func_41cc1` -> `.State5c` | medium |
| src/engine/level/objects/fire_bot.asm (`FireBotFunc`) | `.Func_46c42` -> `.Default`, `.Func_46e6f` -> `.Land`, `.Func_46f7c` -> `.BumpLeftStart`, `.Func_46f84` -> `.BumpRightStart`, `.Func_47180` -> `.AttackedLeftStart`, `.Func_4718a` -> `.AttackedRightStart`, `.Func_471b0` -> `.PickedUpLeftStart`, `.Func_471c3` -> `.PickedUpRightStart`, `.Func_470ea` -> `.WobbleLeftStart`, `.Func_470f4` -> `.WobbleRightStart`, `.Func_46c7e` -> `.StandingFallStart`, `.Func_47091` -> `.TurnAroundStart`, `.Func_46fb2` -> `.StunLeftStart`, `.Func_46fe5` -> `.StunRightStart`, `.Func_46ce4` -> `.Special1`, `.Func_46d38` -> `.Special2`, `.Func_46e8d` -> `.Walk`, `.Func_46cc6` -> `.StandingFall`, `.Func_470ba` -> `.TurnAround`, `.Func_46fd7` -> `.StunLeft`, `.Func_4700a` -> `.StunRight` | `.Func_47126` -> `.State0b`, `.Func_4712d` -> `.State0c`, `.Func_4704d` -> `.State0f`, `.Func_47076` -> `.State10`, `.Func_47239` -> `.State12`, `.Func_47018` -> `.State14`, `.Func_47020` -> `.State15`, `.Func_47207` -> `.State18`, `.Func_471d6` -> `.State19`, `.Func_47176` -> `.State28`, `.Func_4716c` -> `.State29`, `.Func_4713e` -> `.State3b`, `.Func_47150` -> `.State3c`, `.Func_4705c` -> `.State3f`, `.Func_47084` -> `.State40`, `.Func_47228` -> `.State48`, `.Func_471f7` -> `.State49`, `.Func_46e1e` -> `.State5a`, `.Func_46e02` -> `.State5b` | medium |
| src/engine/level/objects/hammer_bot.asm (`HammerBotFunc`) | `.Func_4434f` -> `.Default`, `.Func_4446c` -> `.Land`, `.Func_445c1` -> `.BumpLeftStart`, `.Func_445c9` -> `.BumpRightStart`, `.Func_447d5` -> `.AttackedLeftStart`, `.Func_447f9` -> `.AttackedRightStart`, `.Func_44839` -> `.PickedUpLeftStart`, `.Func_4484c` -> `.PickedUpRightStart`, `.Func_4472f` -> `.WobbleLeftStart`, `.Func_44739` -> `.WobbleRightStart`, `.Func_44317` -> `.VanishTouch`, `.Func_4438b` -> `.StandingFallStart`, `.Func_446d6` -> `.TurnAroundStart`, `.Func_445f7` -> `.StunLeftStart`, `.Func_4462a` -> `.StunRightStart`, `.Func_443a7` -> `.Special1`, `.Func_443bf` -> `.Special2`, `.Func_4448c` -> `.Walk`, `.Func_44703` -> `.TurnAround`, `.Func_4461c` -> `.StunLeft`, `.Func_4464f` -> `.StunRight` | `.Func_4476b` -> `.State0b`, `.Func_44778` -> `.State0c`, `.Func_44692` -> `.State0f`, `.Func_446bb` -> `.State10`, `.Func_448c2` -> `.State12`, `.Func_4465d` -> `.State14`, `.Func_44665` -> `.State15`, `.Func_44890` -> `.State18`, `.Func_4485f` -> `.State19`, `.Func_447cb` -> `.State28`, `.Func_447c1` -> `.State29`, `.Func_4479d` -> `.State3b`, `.Func_447af` -> `.State3c`, `.Func_446a1` -> `.State3f`, `.Func_446c9` -> `.State40`, `.Func_448b1` -> `.State48`, `.Func_44880` -> `.State49` | medium |
| src/engine/level/objects/hebarii.asm (`HebariiFunc`) | `.Func_4a26d` -> `.BumpLeftStart`, `.Func_4a277` -> `.BumpRightStart`, `.Func_4a224` -> `.TurnAroundStart` | - | medium |
| src/engine/level/objects/hidden_figure.asm (`HiddenFigureRightHandFunc`) | `.Func_4d7dc` -> `.Default`, `.Func_4d7e6` -> `.Land`, `.Func_4d83a` -> `.Default`, `.Func_4d844` -> `.Default`, `.Func_4d899` -> `.PickedUpLeftStart`, `.Func_4d8b1` -> `.PickedUpRightStart`, `.Func_4d824` -> `.VanishTouch`, `.Func_4d86f` -> `.StunLeftStart`, `.Func_4d876` -> `.StunRightStart`, `.Func_4d750` -> `.Special1`, `.Func_4d73e` -> `.Special2`, `.Func_4d7fd` -> `.Walk`, `.Func_4d87d` -> `.StunLeft`, `.Func_4d88b` -> `.StunRight` | `.Func_4d859` -> `.State14`, `.Func_4d861` -> `.State15`, `.Func_4d8e1` -> `.State18`, `.Func_4d8c9` -> `.State19`, `.Func_4d8f0` -> `.State48`, `.Func_4d8d8` -> `.State49` | medium |
| src/engine/level/objects/mad_scienstein.asm (`MadSciensteinFunc`) | `.Func_44fd9` -> `.Default`, `.Func_45034` -> `.Land`, `.Func_45140` -> `.BumpLeftStart`, `.Func_45186` -> `.BumpRightStart`, `.Func_45342` -> `.AttackedLeftStart`, `.Func_45366` -> `.AttackedRightStart`, `.Func_453a6` -> `.PickedUpLeftStart`, `.Func_453b9` -> `.PickedUpRightStart`, `.Func_452f7` -> `.WobbleLeftStart`, `.Func_45301` -> `.WobbleRightStart`, `.Func_44e18` -> `.VanishTouch`, `.Func_45018` -> `.StandingFallStart`, `.Func_452af` -> `.TurnAroundStart`, `.Func_451e5` -> `.StunLeftStart`, `.Func_45210` -> `.StunRightStart`, `.Func_45054` -> `.Walk`, `.Func_4515d` -> `.BumpLeft`, `.Func_451bc` -> `.BumpRight`, `.Func_452cb` -> `.TurnAround`, `.Func_45202` -> `.StunLeft`, `.Func_4522d` -> `.StunRight` | `.Func_4526b` -> `.State0f`, `.Func_45294` -> `.State10`, `.Func_45425` -> `.State12`, `.Func_4523b` -> `.State14`, `.Func_45243` -> `.State15`, `.Func_453f8` -> `.State18`, `.Func_453cc` -> `.State19`, `.Func_45338` -> `.State28`, `.Func_4532e` -> `.State29`, `.Func_44eaa` -> `.State2b`, `.Func_44f89` -> `.State2c`, `.Func_4527a` -> `.State3f`, `.Func_452a2` -> `.State40`, `.Func_45414` -> `.State48`, `.Func_453e8` -> `.State49`, `.Func_44e50` -> `.State5a`, `.Func_44eda` -> `.State5b`, `.Func_44fbf` -> `.State5c` | medium |
| src/engine/level/objects/para_goom.asm (`ParaGoomFunc`) | `.Func_41567` -> `.Land`, `.Func_416b0` -> `.BumpLeftStart`, `.Func_416b8` -> `.BumpRightStart`, `.Func_419a6` -> `.AttackedLeftStart`, `.Func_419b0` -> `.AttackedRightStart`, `.Func_419d5` -> `.PickedUpLeftStart`, `.Func_419e8` -> `.PickedUpRightStart`, `.Func_41912` -> `.WobbleLeftStart`, `.Func_4191c` -> `.WobbleRightStart`, `.Func_414c0` -> `.StandingFallStart`, `.Func_4188b` -> `.TurnAroundStart`, `.Func_416fb` -> `.StunLeftStart`, `.Func_41731` -> `.StunRightStart`, `.Func_4152f` -> `.Special1`, `.Func_41517` -> `.Special2`, `.Func_41598` -> `.Walk`, `.Func_414fb` -> `.StandingFall`, `.Func_418c4` -> `.TurnAround`, `.Func_41723` -> `.StunLeft`, `.Func_41759` -> `.StunRight`, `.Func_41439` -> `.FullThrowLeftStart`, `.Func_41447` -> `.FullThrowRightStart` | `.Func_41954` -> `.State0b`, `.Func_4195b` -> `.State0c`, `.Func_41904` -> `.State0d`, `.Func_417a2` -> `.State0f`, `.Func_417cb` -> `.State10`, `.Func_41a64` -> `.State12`, `.Func_41767` -> `.State14`, `.Func_4176f` -> `.State15`, `.Func_41a2f` -> `.State18`, `.Func_419fb` -> `.State19`, `.Func_4199c` -> `.State28`, `.Func_41992` -> `.State29`, `.Func_4196c` -> `.State3b`, `.Func_4197f` -> `.State3c`, `.Func_417b1` -> `.State3f`, `.Func_417e8` -> `.State40`, `.Func_41a53` -> `.State48`, `.Func_41a1f` -> `.State49`, `.Func_4181c` -> `.State5a`, `.Func_41830` -> `.State5b`, `.Func_4186f` -> `.State5c` | medium |
| src/engine/level/objects/robo_mouse.asm (`RoboMouseFunc`) | `.Func_48b13` -> `.Default`, `.Func_48b2b` -> `.Land`, `.Func_48a47` -> `.VanishTouch`, `.Func_48b21` -> `.StandingFallStart`, `.Func_48c4d` -> `.TurnAroundStart`, `.Func_489e8` -> `.Activate`, `.Func_48cc6` -> `.Special1`, `.Func_48cd7` -> `.Special2`, `.Func_48b30` -> `.Walk`, `.Func_48c60` -> `.TurnAround` | `.Func_48a17` -> `.State22`, `.Func_48a23` -> `.State23`, `.Func_489ff` -> `.State24`, `.Func_48a0b` -> `.State25`, `.Func_48a2f` -> `.State26`, `.Func_48a3b` -> `.State27`, `.Func_48ae9` -> `.State3a`, `.Func_48a1d` -> `.State52`, `.Func_48a29` -> `.State53`, `.Func_48a05` -> `.State54`, `.Func_48a11` -> `.State55`, `.Func_48a35` -> `.State56`, `.Func_48a41` -> `.State57`, `.Func_489fe` -> `.State5a` | medium |
| src/engine/level/objects/rock.asm (`RockFunc`) | `.Func_4aa27` -> `.BumpLeftStart`, `.Func_4aa2f` -> `.BumpRightStart`, `.Func_4aae3` -> `.AttackedLeftStart`, `.Func_4aadb` -> `.AttackedRightStart`, `.Func_4aa53` -> `.PickedUpLeftStart`, `.Func_4aa66` -> `.PickedUpRightStart`, `.Func_4aa26` -> `.TurnAroundStart`, `.Func_4aa0a` -> `.Special3`, `.Func_4aabb` -> `.FullThrowLeftStart`, `.Func_4aac3` -> `.FullThrowRightStart` | `.Func_4aaae` -> `.State12`, `.Func_4aa40` -> `.State14`, `.Func_4aa44` -> `.State15`, `.Func_4aa93` -> `.State18`, `.Func_4aa79` -> `.State19`, `.Func_4aacb` -> `.State28`, `.Func_4aad3` -> `.State29`, `.Func_4aa9d` -> `.State48`, `.Func_4aa83` -> `.State49` | medium |
| src/engine/level/objects/shoot.asm (`ShootFunc`) | `.Func_56b20` -> `.Default`, `.Func_56b2a` -> `.Land`, `.Func_56bae` -> `.BumpLeftStart`, `.Func_56bb8` -> `.BumpRightStart`, `.Func_56c1b` -> `.AttackedLeftStart`, `.Func_56c3d` -> `.AttackedRightStart`, `.Func_56b96` -> `.VanishTouch`, `.Func_56bd1` -> `.StandingFallStart`, `.Func_56bf1` -> `.StunLeftStart`, `.Func_56bf8` -> `.StunRightStart`, `.Func_56d1c` -> `.Special1`, `.Func_56b47` -> `.Walk`, `.Func_56c49` -> `.AttackedLeft`, `.Func_56bff` -> `.StunLeft`, `.Func_56c0d` -> `.StunRight` | `.Func_56bdb` -> `.State14`, `.Func_56be3` -> `.State15`, `.Func_56af0` -> `.State28` | medium |
| src/engine/level/objects/silky.asm (`SilkyFunc`) | `.Func_42eca` -> `.Land`, `.Func_43126` -> `.BumpLeftStart`, `.Func_43130` -> `.BumpRightStart`, `.Func_431b4` -> `.AttackedLeftStart`, `.Func_431be` -> `.AttackedRightStart`, `.Func_431da` -> `.PickedUpLeftStart`, `.Func_431ed` -> `.PickedUpRightStart`, `.Func_42e7b` -> `.StandingFallStart`, `.Func_430d5` -> `.TurnAroundStart`, `.Func_42fe5` -> `.StunLeftStart`, `.Func_43018` -> `.StunRightStart`, `.Func_42e95` -> `.Special1`, `.Func_42ef8` -> `.Walk`, `.Func_430f6` -> `.TurnAround`, `.Func_4300a` -> `.StunLeft`, `.Func_4303d` -> `.StunRight`, `.Func_42dff` -> `.FullThrowLeftStart`, `.Func_42e1b` -> `.FullThrowRightStart` | `.Func_43162` -> `.State0b`, `.Func_43169` -> `.State0c`, `.Func_43083` -> `.State0f`, `.Func_430ba` -> `.State10`, `.Func_43263` -> `.State12`, `.Func_4304b` -> `.State14`, `.Func_43053` -> `.State15`, `.Func_43231` -> `.State18`, `.Func_43200` -> `.State19`, `.Func_431aa` -> `.State28`, `.Func_431a0` -> `.State29`, `.Func_4317a` -> `.State3b`, `.Func_4318d` -> `.State3c`, `.Func_430a0` -> `.State3f`, `.Func_430c8` -> `.State40`, `.Func_43252` -> `.State48`, `.Func_43221` -> `.State49` | medium |
| src/engine/level/objects/spear_bot.asm (`SpearBotFunc`) | `.Func_45fbf` -> `.Default`, `.Func_461db` -> `.Land`, `.Func_462e3` -> `.BumpLeftStart`, `.Func_462eb` -> `.BumpRightStart`, `.Func_464e7` -> `.AttackedLeftStart`, `.Func_464f1` -> `.AttackedRightStart`, `.Func_46517` -> `.PickedUpLeftStart`, `.Func_4652a` -> `.PickedUpRightStart`, `.Func_46451` -> `.WobbleLeftStart`, `.Func_4645b` -> `.WobbleRightStart`, `.Func_45ffb` -> `.StandingFallStart`, `.Func_463f8` -> `.TurnAroundStart`, `.Func_46319` -> `.StunLeftStart`, `.Func_4634c` -> `.StunRightStart`, `.Func_4605f` -> `.Special1`, `.Func_460a6` -> `.Special2`, `.Func_461fb` -> `.Walk`, `.Func_46043` -> `.StandingFall`, `.Func_46421` -> `.TurnAround`, `.Func_4633e` -> `.StunLeft`, `.Func_46371` -> `.StunRight` | `.Func_4648d` -> `.State0b`, `.Func_46494` -> `.State0c`, `.Func_463b4` -> `.State0f`, `.Func_463dd` -> `.State10`, `.Func_465a0` -> `.State12`, `.Func_4637f` -> `.State14`, `.Func_46387` -> `.State15`, `.Func_4656e` -> `.State18`, `.Func_4653d` -> `.State19`, `.Func_464dd` -> `.State28`, `.Func_464d3` -> `.State29`, `.Func_464a5` -> `.State3b`, `.Func_464b7` -> `.State3c`, `.Func_463c3` -> `.State3f`, `.Func_463eb` -> `.State40`, `.Func_4658f` -> `.State48`, `.Func_4655e` -> `.State49`, `.Func_4618c` -> `.State5a`, `.Func_46170` -> `.State5b` | medium |
| src/engine/level/objects/teruteru.asm (`TeruteruFunc`) | `.Func_44a72` -> `.Default`, `.Func_44a97` -> `.Land`, `.Func_44c3f` -> `.BumpLeftStart`, `.Func_44c49` -> `.BumpRightStart`, `.Func_44c84` -> `.AttackedLeftStart`, `.Func_44c8e` -> `.AttackedRightStart`, `.Func_44caa` -> `.PickedUpLeftStart`, `.Func_44cbd` -> `.PickedUpRightStart`, `.Func_44b61` -> `.StunLeftStart`, `.Func_44b8d` -> `.StunRightStart`, `.Func_44a09` -> `.Special1`, `.Func_44a25` -> `.Special2`, `.Func_44a5d` -> `.Special3`, `.Func_44ac1` -> `.Walk`, `.Func_44b7f` -> `.StunLeft`, `.Func_44bab` -> `.StunRight` | `.Func_449d1` -> `.State0e`, `.Func_44be1` -> `.State0f`, `.Func_44c12` -> `.State10`, `.Func_44d27` -> `.State12`, `.Func_44bb9` -> `.State14`, `.Func_44bc0` -> `.State15`, `.Func_44cff` -> `.State18`, `.Func_44cd0` -> `.State19`, `.Func_44c7a` -> `.State28`, `.Func_44c70` -> `.State29`, `.Func_44bf8` -> `.State3f`, `.Func_44c32` -> `.State40`, `.Func_44d16` -> `.State48`, `.Func_44cef` -> `.State49`, `.Func_44b2d` -> `.State5a`, `.Func_449d7` -> `.State5b` | medium |

### Phase 7 (started): most-referenced overworld routines

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_b791d` | src/engine/overworld/bank2d.asm:8280 | `OWFunc_DoNothing` | Body is a single `ret`; it fills most entries of overworld jumptables (127 references, e.g. bank2d.asm:8334-8346). | high |
| `Func_ae1ce` | src/engine/overworld/bank2b_2.asm:358 | `AdvancePrologueStep` | Clears the step timer `w2d891` and increments the step `w2d890`: the prologue's copy of `AdvanceCutsceneFunc` (bank27.asm:1073, same code on `w2d014`). 55 references. | high |
| `Func_ae1c9` | bank2b_2.asm:352 | `WaitPrologueStep` | Returns until `w2d891 >= c`, then falls into `Func_ae1ce`: the copy of `WaitCutsceneFunc`. | high |
| `Func_ae1c2` | bank2b_2.asm:346 | `AdvancePrologueStepOnWarioState` | Advances only when `wSceneWarioState == b`. | medium |
| `Func_ae1d5` | bank2b_2.asm:363 | `ResetPrologueStepAndNext` | Clears `w2d890/w2d891` and `jp Prologue_Next`. | medium |
| `Func_ad335` / `Func_ad33c` | src/engine/overworld/bank2b_1.asm:2855 / 2861 | `AdvanceSceneStep` / `ResetSceneStep` | Same pattern on `w2d890/w2d891` in bank2b_1's scenes (the reset jumps to `Func_ad016`). Which scene module this is wasn't checked. | low |
| `Func_9ccf9` | src/engine/overworld/bank27.asm:1064 | `SetSceneObjPosAndState` | Header comment: "a = state, d = y coord, e = x coord"; stores the coords at `hl` and calls `SetSceneObjState`. 43 references. | high |
| `Func_9f0d0` | bank27.asm:5899 | `SetSceneObjStateWhenAnimFinished` | Returns unless `wOWAnimationFinished == $ff`; then clears duration/frameset offset and sets the state to `b`. | medium |

## Second pass

Same conventions as above. New names were checked with a script against
`src/` and against everything already in this file (no collisions).

### Phase 1 (cont.): `w1dXXX` RAM

#### Level WRAM1: boss union and the Hidden Figure fight

`w1d14b`..`w1d162` are all Hidden Figure variables (only hidden_figure.asm
touches them; `HiddenFigureFunc` zeroes `w1d14b`..`w1d151`, sets `w1d15a = 4`,
zeroes `w1d15b`..`w1d161` and sets `w1d162 = 2`). The fight is driven by the
body (`HiddenFigureFunc`), which writes an attack number to `w1d14b`; both
hands dispatch on it every frame. Attack values seen: 0 none, 1 left-hand
swipe, 2 right-hand swipe, 3/7/8 grab attacks with both hands (different
movement tables), 4 right-hand slam, 5 left-hand slam, 6 defeat. These would
deserve `HIDDEN_FIGURE_ATTACK_*` constants. "Swipe" and "grab" are chosen from
the interaction types the hands get: a swiping hand is `OBJ_INTERACTION_48`/`52`
(stings, but can be smashed from above), a grabbing hand switches to
`OBJ_INTERACTION_50` (`ObjInteraction_FrontDragDown`, which drags Wario and
puts the hand in `OBJSTATE_SPECIAL_3`).

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `w1d14b` | src/ram/wram.asm:1074 | `wHiddenFigureAttack` | Written only by the body states (`.Func_4cce2` 1, `.Func_4cd45` 2, `.Func_4cc3c` 3/7/8, `.Func_4ccf6` 4, `.Func_4cd59` 5, `.asm_4cda8` 6, 0 at the end of each); `HiddenFigureLeftHandFunc.Func_4d0c7` and `HiddenFigureRightHandFunc.Func_4d3c8` compare it with each value to pick their next update function. The face picks its frameset from it too. | high |
| `w1d14c` | :1077 | `wHiddenFigureLeftHandStunned` | Set to 1 when the swiping left hand is smashed (`OBJSTATE_VANISH_TOUCH`, hidden_figure.asm:1147): the hand becomes grabbable (`OBJ_INTERACTION_00`) and runs the stunned-hand state table. Cleared by `.Func_4d750` once the hand is back at its rest position (`w1d152`). While set, the body skips to the other hand's slam (`.Func_4ccf6`) and waits (`.Func_4cd28`). | high |
| `w1d14d` | :1080 | `wHiddenFigureRightHandStunned` | Same for the right hand (`w1d156`). | high |
| `w1d14e` | :1083 | `wHiddenFigureBodyGrabResult` | Set together with `w1d14f`/`w1d150` by a hand during a grab attack: $80 when the hand caught Wario (`OBJSTATE_SPECIAL_3`, `SFX_0CD`), 10 when the hand was attacked (`OBJSTATE_ATTACKED_*_START`). Body: $80 -> wait $a0 frames then `wAutoMoveState = 0`, else counts down (pauses the attack). The face laughs on $80 (`Func_4ce39`). | medium |
| `w1d14f` | :1086 | `wHiddenFigureLeftHandGrabResult` | Left hand's copy: $80 -> holds Wario at the hand (`.Func_4d379`, Wario's position set from the hand's), else counts down. | medium |
| `w1d150` | :1089 | `wHiddenFigureRightHandGrabResult` | Right hand's copy (`.Func_4d622`). | medium |
| `w1d151` | :1092 | `wHiddenFigureHandsFlinch` | Set to 1 when one hand starts a swipe and when the face is hit; an idle hand that sees it runs `.Func_4d19e`/`.Func_4d49f` (moves along `Data_4c500`, 24 px down and back) and clears it at the end. | medium |
| `w1d152` | :1095 | `wHiddenFigureLeftHandRestPos` | 4 bytes: the left hand's initial `OBJ_Y_POS`/`OBJ_X_POS`, saved by `HiddenFigureLeftHandFunc`; the stunned hand's `.Func_4d750` moves back until its position equals it. | high |
| `w1d156` | :1098 | `wHiddenFigureRightHandRestPos` | Same for the right hand. | high |
| `w1d15a` | :1101 | `wHiddenFigureRemainingHits` | Initialised to 4; the face decrements it when hit (hidden_figure.asm:531), at 0 the fight ends (`.Func_4cf3f`, `stop_music2`, `wAutoMoveState = 2`), at 1 `MUSIC_HIDDEN_FIGURE_BATTLE_2` starts. Palettes switch below 2 (`Func_4cfe0`). Same idea as `wWolfenbossRemainingHits`. | high |
| `w1d15b` | :1104 | `wHiddenFigureRightHandSlamming` | 1 while the right hand does its slam (attack 4, `.Func_4d465`, `Data_4c540`, `DoGroundShake`); the body's `.Func_4cc3c` waits while it is set. | high |
| `w1d15c` | :1107 | `wHiddenFigureLeftHandSlamming` | Same for the left hand (attack 5). | high |
| `w1d15d` | :1110 | `wHiddenFigureHandWasGrabbed` | Set when Wario picks up or grabs a stunned hand (`.Func_4d899`/`.Func_4d8b1`/`.Func_4d8c9`/`.Func_4d8e1`); on landing (`.Func_4d7e6`) the hand waits 1 frame instead of 70 before returning; cleared in `.Func_4d7fd`. | medium |
| `w1d15e` | :1113 | `wHiddenFigureSwipeInterrupted` | Set when a swiping hand gets any state other than `OBJSTATE_VANISH_TOUCH` (bumped rather than smashed); the body then skips its wait and goes straight to a grab attack (`.Func_4cbf5`, `.Func_4cc05`). | medium |
| `w1d15f` | :1116 | `wHiddenFigureDefeatStarted` | Set to 1 by the body when the defeat flashing ends (`.Func_4cdbc` -> `.Func_4ce01`, `SFX_0CF`); the hands in attack 6 wait for it (`.Func_4d37f`/`.Func_4d628`) and then move off. | medium |
| `w1d160` | :1119 | `wHiddenFigureSwipeCount` | Incremented per swipe chosen by `.Func_4cc05`; at 2 it is cleared and a grab attack follows. | high |
| `w1d161` | :1122 | `wHiddenFigureAttackCounter` | Incremented each time an attack is chosen; bit 0 decides between grab attack 8 and 3/7 in `.Func_4cc3c`. | medium |
| `w1d162` | :1125 | `wHiddenFigureGrabsLeft` | Initialised to 2; with one hit left, each grab attack decrements it and repeats the grab until it reaches 0 (then reset to 2). | medium |
| `w1d147` | :1050 | `wJamanoSkullsInPlace` (+ per-boss aliases, see note) | Second byte of the boss union (same address as `wDollBoyFallImmediatelyMiddleBarrel`, `wShootBallState`, `wWolfenbossIgaguriOrKuriActive`). Jamano: each skull increments it when it reaches the screen edge (jamano.asm:792) and decrements it when hit (:860); `Func_55407` darkens the BG palettes as it grows (step kept in `wDollBoyHammerRange`). Pesce uses it as a hit/phase counter (1-3 choose framesets, pesce.asm:75-610), Yellow Belly as an interrupt flag ($3a, yellow_belly.asm:959), Muddee's stinger as "was vanished" (muddee_stinger.asm:21). | medium |
| `w1d149` | :1055 | `wJamanoSkullsInactive` | Jamano only: set to 1 when the skull spawner creates the skulls (jamano.asm:663), cleared when the fight starts (`BOSS_REGULAR`, :87); while set, skulls blink and do nothing (`.Func_553e8`, `.Func_55347`). | medium |
| `w1d140` | :977 | (delete; fix the one user) | Same address as `wFlameBlockCleared`. Its only reference is bank2b_1.asm:1821 in an overworld scene, which runs with WRAM bank 2: that store (and the next one, `ld [wDollBoyNoFlashingBarrel], a`) are really `wSceneWarioYCoord` ($d140) and `wSceneWarioXCoord` ($d141). See "Wrong-bank labels" below. | high |

Note on the boss union: Pesce, Yellow Belly and Jamano also use
`wDollBoyActiveBarrels` / `wDollBoyHammerRange` (bytes 0 and 2 of the union)
for their own purposes (e.g. Jamano's darkness step). Each boss should get
its own `NEXTU` with names for bytes 0-3 instead of borrowing Doll Boy's.

#### Golf RAM

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `w1d800` | src/ram/wram.asm:1134 | `wGolfMode` | 0 = not playing, 1 = Golf Building (building.asm:21), 2 = in-level golf lobby (lobby.asm:8); cleared on exit. `ShowGolfHoleFlagAndPar` lets strokes exceed par only in mode 2; game over on over-par only outside mode 1 (hole.asm:2152). `SaveBackupVRAM` is called only when entering from mode 0. Values would get `GOLF_MODE_*`. | high |
| `w1db00` | :1180 | `wGolfPals` | 8 palettes: `Func_1c87db` copies the selected course's palettes here ("loads ... palettes to w1db00", building.asm:326); loaded with `LoadPalsToTempPals1` and by hole.asm:3202 with `Func_2c46`. | medium |
| `w1db82` | :1186 | `wGolfHoleDataHoleXPos` | 2 bytes of `wGolfHoleData` (between `wGolfPar` and the water spawns); copied into `wGolfHoleHoleXPos` right after loading the hole (hole.asm:208). | high |
| `w1db90` | :1193 | `wGolfStrokeNumberTiles` | 4 tiles: `PrintGolfStrokeNumber` copies the tens/ones digit tiles here; copied to `v1Tiles0 tile $f0` and HDMA'd from here in VBlank (hole.asm:3024). | high |
| `w1dc00` | :1198 | `wGolfBuildingState` (alias) | Already aliased `wGolfLobbyState`/`wGolfHoleState`; in building.asm it is the state of the course menu (`Func_1c882b` jumptable: 0 input, 1 scrolling, 2 reached target SCX, 3 paid). | high |
| `w1dc01` | :1203 | `wGolfNextHoleState` | The `GOLFHOLESTATE_*` to go to after the current bounce/landing: set to `_BOUNCE`, `_WALK`, `_BETWEEN_SHOTS`, `_CLEARED`, `_GAME_OVER`, copied into `wGolfHoleState` on landing (hole.asm:1715). | high |
| `w1dc0b` | :1221 | `wGolfPinFlagAnimCounter` | `.UpdatePinFlagTiles` picks the flag frame from it (thresholds $10/$18) and increments it mod $20. | high |
| `w1dc20` | :1257 | `wGolfOutOfStrokes` | Set TRUE by `SetGolfParaGoomRespawnYPosIfEnoughStrokes` when `wGolfStroke >= wGolfMaxStrokes`; `UpdateGolfParaGoom` returns while it is set. | medium |
| `w1dc21` | :1260 | `wGolfPlaceWarioAtEdge` | Set when Wario starts walking to the ball (`GolfHoleState_Walk`, hole.asm:2249); `UpdateGolfWario` then, if Wario is off screen (`Func_1c8f56`), puts him just outside the left/right screen edge (scroll*4 - 40 / + 680) and clears it. | low |
| `w1dc3e` | :1320 | `wGolfParaGoomBlockX` | 2 bytes: Para-Goom's X / 32, the index into `wGolfTerrainBlocks` (hole.asm:1605); used to snap Para-Goom to the block edge on edge terrain (:1795). | high |
| `w1dc47` | :1346 | `wGolfParaGoomLeftTeeBox` | The existing comment says what it is for; it holds the last landing terrain when it was neither tee box (0) nor OB (hole.asm:1705), so non-zero = Para-Goom has left the tee box. Read for the tee-box ground level (:1625) and Wario's walk (:2253). | medium |
| `w1dc53` | :1386 | `wGolfParaGoomLeftTeeBoxBackup` | Copy of `w1dc47` taken at each shot (hole.asm:915), restored when the shot goes OB (:1786). | medium |
| `w1dc4f` | :1375 | (make `wShotYVel` a `dw`) | High byte of the 16-bit `wShotYVel`: the shot code stores 0 here (`; w1dc4f`), and `UpdateGolfParaGoomYPos` reads/writes `wShotYVel` as a 16-bit value (`dec de`, `Sub16Bit`). | high |
| `w1dc51` | :1381 | `wGolfShotXDecelCounter` | `UpdateGolfParaGoomXPos` increments it and decrements `wShotXVel` every 8th frame; cleared on landing and before a new shot. | high |

`wdc11` (golf) is the one label of the `w1d`/`wdXXX` set named in the first pass.

#### Wrong-bank labels (found while checking `w1d140`)

(Applied in batch 14.)

The overworld runs with WRAM bank 2 mapped, so a WRAMX label from another
bank used in overworld code points at the bank-2 variable at the same
address. A scan of every bank 1/3-7 WRAMX label referenced from
src/engine/overworld found three such uses, and one inside bank 2 itself:

| Where | Written as | Actually | Evidence | Conf. |
|---|---|---|---|---|
| src/engine/overworld/bank2b_1.asm:1821 | `ld [w1d140], a` ($60) | `wSceneWarioYCoord` | Both are $d140 (sym file); the code sets `wSceneWarioStateGroup` and calls `UpdateSceneWario` right after. | high |
| bank2b_1.asm:1823 | `ld [wDollBoyNoFlashingBarrel], a` ($e8) | `wSceneWarioXCoord` | $d141. | high |
| src/engine/overworld/bank56.asm:1215 (`_InitBestTimeList`) | `ld a, [wObj1SubState]` | `wCurMapSide` | Both are $d01a; `rra / and a` picks SCY 0 or $70 from it. | high |
| src/engine/overworld/bank20.asm:1215-1221 (`Func_81714`) | `wDayNightTransistionSteps`, `wPalFade1Colour1BlueUnk3`, `wPalFade1Colour3RedUnk3`, `wPalFade1Colour4GreenUnk3` | byte 6 of `w2d800`/`w2d820`/`w2d840`/`w2d860` | Same `UNION` in "WRAM2 2": these are $d806/$d826/$d846/$d866, i.e. offset 6 (the state) of the four path-tracer structs (see `w2d800` below), and `Func_81714` passes them to the same animation helper as the other preview sprites. | high |

(`w3d500` at overworld/init.asm:632 was already noted in the first pass as a
deliberate reuse of that area.)

### Phase 1 (cont.): `w2dXXX` overworld RAM

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `w2d011` | src/ram/wram.asm:1427 | `wOWIsNight` | 0 = day, 1 = night. Set from `wDayNight` bit 0 on OW init (init.asm:226-255), toggled by `.SwitchDayNight` (bank21.asm:175, 333); every day/night choice reads it: palettes (`_LoadPalsForOWScene`, `_LoadMapSidePals`, level-name palette at bank21.asm:1275), top-bar spell (`ld c, $05 ; night spell`, bank20.asm:3816), and many scene objects in bank2d.asm. | high |
| `w2d013` | :1433 | `wOWStep` | Jumptable index of the overworld main loop (`Func_80e89`, bank20.asm:37) and of every cutscene (`.PlayCutscene` etc. in bank27.asm); `AdvanceCutsceneFunc` clears `w2d014` and increments it. | high |
| `w2d014` | :1436 | `wOWStepCounter` | Frame counter of the current `w2d013` step: incremented every frame before the jumptable, compared by `WaitCutsceneFunc` (`cp c`), cleared on every step change. | high |
| `w2d015` | :1439 | `wUnused_2d015` | Only saved into `w2d018` before `ClearOWWRAM` and restored from it (init.asm:179, 509) together with the OW scene parameters; never otherwise read or written. | medium |
| `w2d018` | :1448 | `wUnused_2d018` (or `wTempUnused_2d015`) | The save slot for `w2d015` above. | medium |
| `w2d02c` | :1495 | `wSavedTransitionParam` | Top bar fully opened: `wTransitionParam` is saved here (bank20.asm:3521) and restored on OW init before `PlayOverworldMusic` (init.asm:443). | medium |
| `w2d031` | :1503 | `wOWCloudUpdateFlags` (write-only) | `UpdateCommonOWAnimations` clears it and sets bit 0 when cloud tiles were copied, bit 1 for sea/small-cloud tiles; nothing reads it (only bank76.asm and the clear in init.asm reference it). Could be `wUnused_2d031`. | high |
| `w2d032`/`w2d033`/`w2d034`, `w2d035`.., `w2d038`.., `w2d03b`.. | :1506-1539 | `wOWBigCloud1Anim`..`wOWBigCloud4Anim` (3 bytes each: duration, counter, frame) | `UpdateCommonOWAnimations` calls `.UpdateBigClouds` with `hl` = each first byte: byte 0 = frame duration (0 = no animation), byte 1 = counter, byte 2 = frame (0-3). `Func_80b54` (init.asm:748) sets the durations ($1e, 4, $24, $24; $04 for cloud 4 in the south). A 3-byte struct macro would fit all six slots. | high |
| `w2d03e`/`w2d03f`/`w2d040` | :1542-1548 | `wOWSeaAnim` | Same layout, `.UpdateSea` (6-frame cycle). Bank2d scenes stop it (`ld [w2d03e], a` = 0, bank2d.asm:895) or change its speed (:3533, :3562). | high |
| `w2d041`/`w2d042`/`w2d043` | :1551-1557 | `wOWSmallCloudsAnim` | Same layout, `.UpdateSmallClouds`. | high |
| `w2d044` | :1560 | `wOWCliffsGfxSrc` | 2 bytes, big-endian: the source of the current cliff frame (`HIGH(OverworldCliffs1Gfx) + frame`), HDMA'd to VRAM1 by `Func_1d8c2c` when non-zero; cleared every frame by `UpdateCommonOWAnimations`. | high |
| `w2d046`/`w2d047`/`w2d048` | :1563-1569 | `wOWCliffsAnim` | Same 3-byte layout for the cliffs (frames 0-3); bank2d.asm:896 stops it. | high |
| `w2d049` | :1572 | `wOWSeaGfxVariant` | High-byte offset added to `OverworldSeaGfx` by `.UpdateSea`/`.UpdateSmallClouds`; 0 normally, 1 during the freeze-sea scene (bank2d.asm:3531, reset at :3568, also :4026, :4183). | medium |
| `w2d062` | :1622 | `wOWFuncStep` | Jumptable index of every `NOWFunc_*` / OW function (bank2d.asm:2446...), and of `UnlockLevel` (bank20.asm:4659); `AdvanceOWFunc` clears `wOWFuncCounter` and increments it. Pairs with the existing `wOWFuncCounter`. | high |
| `w2d065` | :1628 | `wEventUnlockState` | Result of `CheckIfEventIsUnlocked` for the event being prepared (bank20.asm:2732), replaced with $80 when it's newly unlocked; `DrawUnlockedLevels` returns when it is 0 ("conditions not fulfilled"), `InitHighlightLevelScene` acts only on $80, `_InitOWObjects` passes it to the per-side object setup. | medium |
| `w2d068` | :1634 | `wTargetMapSideLevelID` | The level point Wario is walking to: set from the path (bank20.asm:3204, 506), copied into `wMapSideLevelID` on arrival (:442); `HandleBottomBar`/`Func_82041` compare it with `wMapSideLevelID` to know whether he is moving. | medium |
| `w2d069` / `w2d06a` | :1637 / :1640 | `wOWLevelYCoord` / `wOWLevelXCoord` | Coords of the current level point from `GetMapLevelCoords` (`Func_8212c`, bank20.asm:3235); restored into `wOWYCoord1`/`wOWXCoord1` and the Wario sprite. The comments at bank20.asm:3235/3238 say "level x"/"level y", but the first byte feeds `wOWYCoord1`: the comments are swapped. | high |
| `w2d06f` / `w2d070` | :1651 / :1652 | `wOWPathTargetYCoord` / `wOWPathTargetXCoord` | End point of the current path segment; `Func_810fc` turns it into the next waypoint `wOWCoords2` by path shape (the source already documents "wOWYCoord2 = w2d06f", "wOWXCoord2 = w2d070"). | high |
| `w2d072` | :1656 | `wLevelArrowIndex` | Loop index while drawing unlocked-level arrows (`DrawUnlockedLevels`, bank20.asm:2800-2812), compared with `w2d074`. | medium |
| `w2d074` | :1659 | `wNumLevelArrows1` | Count read from the arrow data right after `wLevelArrowDirections1` (bank20.asm:2977). | medium |
| `w2d076` | :1661 | `wNumLevelArrows2` (write-only) | Same for `wLevelArrowDirections2` (0 when that is $ff); never read. | medium |
| `w2d078` | :1667 | `wUnused_2d078` | Write-only (bank20.asm:2729). | high |
| `w2d07c` | :1679 | `wOWNextIsNight` | Day/night value the transition goes to: `wOWIsNight` on init, 1 in `.InitDayToNight`, 0 in `.InitNightToDay`; bank2d.asm `Func_b7cb3` moves scene object 14 depending on it. | low |
| `w2d07d` | :1682 | `wOWDayNightObjMoved` | Cleared with `w2d07c`; `Func_b7cb3` repositions scene object 14 once while it is 0, then increments it. | low |
| `w2d07f` | :1687 | `wHighlightOWTile` | When non-zero, `Func_81feb` ORs palette 7 + `BG_BANK1` into `wAttrToPlaceInOW` (its header comment says so); used as a countdown by `Func_81f21`. Set around drawing newly unlocked arrows/points. | medium |
| `w2d096` | :1725 | `wUnused_2d096` | Write-only (bank20.asm:4268). | high |
| `w2d0a0` | :1730 | `wOWLineFlags` | `Func_821a1` (Bresenham line set-up from `wOWCoords1` to `wOWCoords2`): bit 1 = Y decreases, bit 2 = X decreases (`.CalculateDistance` ORs `c`), bit 0 = X is the major axis. | high |
| `w2d0a1` | :1731 | `wOWLineStepsLeft` | Major-axis distance; `Func_82208` decrements it per step and does nothing at 0; callers wait for it to reach 0 (bank20.asm:428, 1166). | high |
| `w2d0a2` | :1732 | `wOWLineMajorDist` | Major-axis distance, constant during the line. | high |
| `w2d0a3` | :1733 | `wOWLineError` | Error accumulator: += minor distance each step, minus major when it reaches it (then a minor-axis step). | high |
| `w2d0a4` | :1734 | `wOWLineMinorDist` | Minor-axis distance. | high |
| `w2d0a5` / `w2d0a6` | :1735 / :1736 | `wOWLineYStep` / `wOWLineXStep` | +1 / -1 from the flags; added to `wOWYCoord1`/`wOWXCoord1`. The block `w2d0a0`..`w2d0a6` is copied as 7 bytes into/out of each path tracer (bank20.asm:975, 991). | high |
| `w2d0b5` | :1744 | `wHDMAVRAM1` | Second `hdma_config_struct` after `wHDMA`: `Func_3c03` writes its 5 bytes to `rVDMA_*` with VRAM1 selected; checked by overworld/vblank.asm:96; cleared with `wHDMA` (bank20.asm:4363). | medium |
| `w2d0c0` | :1749 | `wUnused_2d0c0` | 16 bytes only ever zeroed (by `Func_3c76`, called from the Temple hint, bank20.asm:260); never read. The first pass proposed `ClearW2d0c0` for `Func_3c76`; it could be `ClearUnused_2d0c0`. | medium |
| `w2d0e0` | :1768 | `wLevelNameFadeState` | 0 idle, 2 fading in (`FadeInLevelName`), 1 faded in, 3 fade out requested: `Func_852e5` acts only on 3 and clears it when done (bank21.asm:1319-1357); the main loop waits for 0 before showing a new name (bank20.asm:159). | high |
| `w2d0e2` / `w2d0e3` | :1774 / :1777 | `wPathPreviewCounter` / `wPathPreviewState` | Holding B on the map (`Func_81477`): `w2d0e3` is the jumptable index (save Wario's position, wait 10 frames, init tracers, run tracers), `w2d0e2` its frame counter (thresholds $14/$28/$2c/$40 spawn and clear the preview sprites); releasing B restores Wario from `w2d88e/f`. Also cleared by bank21.asm:297/337. | medium |
| `w2d0e4` / `w2d0e5` | :1780 / :1783 | `wTempleHintState` / `wTempleHintCounter` | Pressing UP at the Temple (`Func_81077`) switches the main loop to step $0a, whose `Func_8137a` dispatches on `w2d0e4` (fade out name, load the level name of the next treasure via `GetMapSideAndLevelForNextTreasure`, fade in, wait for input) with `w2d0e5` as its timer. | medium |
| `w2d0ee` / `w2d0ef` | :1788 / :1791 | `wBottomBarTimeAttackScore` (2 bytes) | bank26.asm:1314 copies the level's `wLevelTimeAttackScores` entry here; `Func_829a1` draws its four BCD digits in the bottom bar. | high |
| `w2d100` / `w2d101` | :1816 / :1819 | `wOWWarioYCoord` / `wOWWarioXCoord` | Wario's map sprite position: copied from `wOWYCoord1`/`wOWXCoord1` every walking frame (bank20.asm:425, `Func_8115c`), moved directly when exiting the map side (`Func_811cf`), passed to the sprite routine after `w2d107` (bank20.asm:3141). | high |
| `w2d104` | :1824 | `wOWWarioAnimDuration` (2 bytes: duration, frameset offset) | `hl` for `UpdateOWAnimation` in `Func_8208d`; both bytes cleared by `SetOWWarioOAM`. | high |
| `w2d106` | :1827 | `wOWWarioSprite` | `SetOWWarioOAM` stores its `OWWARIO_*` input here; `Func_8208d` draws nothing while it is 0. | high |
| `w2d107` | :1831 | `wOWWarioOAMPtr` | "some sprite pointer": set by `SetOWWarioOAM` (`OAM_aa329`...), read by `Func_8208d`. | high |
| `w2d109` | :1835 | `wOWWarioFramesetPtr` | "some frameset pointer": from `SetOWWarioOAM`'s `.framesets` table. | high |
| `w2d10c` | :1841 | `wOWWarioLastDir` | Last `wLevelArrowDirections1` used to choose Wario's facing sprite (`Func_82041`, bank20.asm:3106). | medium |
| `w2d10d` | :1844 | `wOWWalkSFXCounter` | While walking: `PlaySFX_12A` when 0, incremented, reset at $24 ($12 when running). | medium |
| `w2d10e` | :1847 | `wOWWarioRunCounter` | `Func_8115c`: counts frames with the D-pad held; at 6 sets bit 7, which makes Wario take two line steps per frame and halves the step-SFX period. Cleared when a walk starts. | medium |
| `w2d121`..`w2d13f` | :1861-1945 | `wOWSceneTask1State`/`...Counter`, ... (pairs, see note) | Scratch for bank2d.asm scenes: (state, counter) byte pairs where state 0 = inactive. E.g. the leaf scene uses `w2d12c`/`w2d12d` (leaf 1), `w2d12e`/`w2d12f` (leaf 3), `w2d130`, `w2d132` (`.HandleLeaf1Movement`, bank2d.asm:2693-2990); another uses `w2d122`/`w2d123`, `w2d124`/`w2d125` (:6100-6250), another `w2d134`/`w2d135`, `w2d138`/`w2d139`, `w2d13a`/`w2d13b`, `w2d13c`/`w2d13d`, `w2d13e`/`w2d13f` (:7776-8020). `w2d133` has no direct reference (reached with `inc l`). `w2d121` is write-only (:7476). Meaning depends on the scene, so a neutral numbered pair name is proposed. | low |
| `w2d14c` | :1955 | `wSceneWarioSFXCounter` | Part of the Scene Wario block: step-sound counter (`Func_ac4fa`: SFX_12A at 0, reset at $24) and a per-animation sound flag in the look/turn animations (bank2b_1.asm:1014-1130); cleared when the Scene Wario gfx group changes (:1420). | medium |
| `w2d14e` | :1961 | `wSceneWarioAnimFinished` | `.Sleep` stores `wOWAnimationFinished` here; the prologue waits for $ff (bank2b_2.asm:958). | medium |
| `w2d15e`, `w2d160`, `w2d166`, `w2d16e`, `w2d176`, `w2d17e` | :2000-2017 | define `wOWUIObj3`..`wOWUIObj8` (`scene_obj_struct`, $d150-$d17f) | The B-button path preview animates 8-byte sprites whose state bytes are `wOWUIObj1State`, `wOWUIObj2State`, `wd156`, `w2d15e`, `w2d166`, `w2d16e`, `w2d176`, `w2d17e` (`Func_81714`): i.e. byte 6 of objects at $d140, $d148, $d150, $d158, $d160, ... `.Func_815e5` copies 4 tracer sprites to `w2d160` (+8 each) and `.Func_81609` clears `w2d160 + 6` (+8 each). The current labels cut through those structs. (`w2d150`..`wd156` are also the generic scene vars from the first pass: a `UNION` would show both uses.) | medium |
| `w2d800`, `w2d820`, `w2d840`, `w2d860` (`ow_unk_struct`) | :2051-2054 | `wOWPathTracer1`..`4`, struct `ow_path_tracer_struct` | Four $20-byte tracers for the B-button path preview: `.Func_815b6` indexes them by `a * 32`; `.Func_81576` copies 9 bytes to `w2d880`, 7 to `w2d0a0` (line state) and 8 to `wOWCoords1` and `.Func_81595` copies them back, so the struct is [9-byte tracer][7-byte line][8-byte coords]. Byte 7 = 5 means done (`ld hl, w2d800 + $7` loop). | medium |
| `w2d880` | :2056 | `wCurOWPathTracer` (path preview) / `wPrologueFadeType` (prologue, temple) | Preview: working copy of the current tracer (+0/+1 coords, +6 sprite state, +7 tracer state, +8 counter). In the prologue and temple scenes the same byte is the fade type read by `_PrologueFade` (bank21.asm:750; set to 0/1/3/4 in bank2b_1.asm:2518, 2642, bank2b_2.asm:79, 2696). Needs a `UNION`. | medium |
| `w2d889` | :2059 | `wPathPreviewPathsPtr` | Byte 9 of the tracer area: the pointer from `Func_82111` (`OWLevelPaths`/`OWExitPaths` entry of the current point), read through `w2d880 + $9`. | medium |
| `w2d88b` | :2062 | `wCurOWPathTracerIndex` | Index passed to `.Func_81576`/`.Func_81595` (which tracer is in `w2d880`). | high |
| `w2d88e` / `w2d88f` | :2067 / :2068 | `wOWWarioSavedYCoord` / `wOWWarioSavedXCoord` | `w2d100`/`w2d101` saved when the preview starts and restored when B is released (bank20.asm:817, 863). | high |
| `w2d890` / `w2d891` | :2070 / :2073 | `wSceneStep` / `wSceneStepCounter` | Step and step timer of the bank2b_1/bank2b_2 scenes (temple, prologue): `Func_ae1ce`/`Func_ad335` clear the counter and increment the step (first pass: `AdvancePrologueStep`, `AdvanceSceneStep`). | high |
| `w2d892` / `w2d893` / `w2d894` | :2076-2082 | `wSceneSubStep` / `wSceneSubStepCounter` / `wSceneSubActive` | A second (step, counter) pair for a Scene Wario sub-animation running alongside the main steps: panic running in the temple (`HandleTempleWarioPanic`, bank2b_1.asm:3630-3729), Wario's bounce in the prologue (bank2b_2.asm:1196-1330). `w2d894` = 1 while it runs; the step is set to $80 when finished. | medium |
| `w2d896` / `w2d897` | :2087 / :2090 | `wTempleShakeState` / `wTempleShakeCounter` | `HandleTempleScreenShake` (bank56.asm:16) dispatches on `w2d896` (0 = off) with `w2d897` as its counter; the temple scene sets 1, 2 and $0b (`.StartBigShake`). | high |
| `w2d8a0` / `w2d8a1` | :2095 / :2098 | `wSceneAuxStep` / `wSceneAuxStepCounter` | A third (step, counter) pair: the temple music boxes (`HandleTempleMusicBoxes`, bank2b_1.asm:3105), the plane parts in the prologue (bank2b_2.asm:1463), a bank56 scene (:397). | medium |
| `w2d8b0` / `w2d8b1` | :2134 / :2137 | `wPrologueSubStep` / `wPrologueSubStepCounter` | Inside the `wPlaneParts` `NEXTU`: `Func_ae2dd` (bank2b_2.asm:533) dispatches on `w2d8b0` with `w2d8b1` as counter. | low |
| `w2d8da` / `w2d8dc` | :2144 / :2149 | `wTempleLeftHandMoving` / `wTempleRightHandMoving` | `DoHiddenFigureLeftHandMovement`/`DoHiddenFigureRightHandMovement` return unless set; both set in the reveal scene (bank2b_1.asm:2639). | high |
| `w2da04` | :2163 | `wTempleSceneStep` | Sub-step of the current `wTempleScene`; directly precedes `wTempleSceneCounter`, and `.NextState` does `ld [hld], a / inc [hl] ; w2da04`. | high |
| `w2df00` | :2216 | `wBestTimeDigitTiles` | bank56.asm:1399 builds the tile numbers for a best time (minutes/seconds) here and :1426 writes them to the BG map. | high |
| `w2dffc` | :2219 | `wCheckedEvent` | Loop variable over events in bank20.asm:1308 (`CheckIfEventIsUnlocked` clobbers `a`). | medium |
| `w2dffd` / `w2dffe` / `w2dfff` | :2222-2232 | aliases `wEventTreasure1`/`2`/`3` (+ generic temp) | `LoadEventTreasures` writes the event's three treasures to `w2dfff`, `w2dffe`, `w2dffd` and `CheckIfEventIsUnlocked` checks them. The same bytes are reused as temporaries elsewhere (`ShowMissingTreasureIndicators`: saved `wOWLevel`, level index, level count; collection cells in bank26.asm:330-408; best times in bank56.asm:1378; `wOWExitUnlocked` is already an alias of `w2dfff`). | high (aliases) |
| `w2d801` | :2240 | `wUnused_2d801` | Write-only (overworld/cutscene/init.asm:47). | high |
| `w2d807` | :2248 | `wColourFadeLoopCounter` | Loop counter of `InitColourFadeStructs`, `CopyPalToColourFadeStructs`, `ApplyPalFadeColours` and the day/night step (8 palettes x 4 colours x 3 components). | high |
| `w2d809` | :2254 | `wOWPalTransitionDelay` | `DayNightTransition` returns while `wOWPalTransitionCounter < w2d809` (bank21.asm:78); each step sets it (0, 2, 3). | medium |

Routines met along the way (bank20/bank21/bank76):

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_821a1` | bank20.asm:3313 | `InitOWLineMovement` | Sets `w2d0a0`..`w2d0a6` from `wOWCoords1` -> `wOWCoords2` (see above). | high |
| `Func_82208` | bank20.asm:3384 | `StepOWLineMovement` | One Bresenham step of `wOWCoords1`. | high |
| `Func_82111` | bank20.asm:3213 | `GetCurLevelPathsPtr` | `hl` = `OWLevelPaths` (or `OWExitPaths` for an exit) entry for `wMapSideLevelID` on `wNextMapSide`. | high |
| `Func_852e5` | bank21.asm:1318 | `FadeOutLevelName` | Acts when `w2d0e0 == 3`: blacks out palette 7 colours 1-3 through `wPalConfig1` and clears `w2d0e0` when done. | high |
| `Func_1d8c2c` | bank76.asm:210 | `CopyCommonOWAnimTilesToVRAM` | HDMA from `wTilemap tile $24` (the cloud/sea tiles updated by `UpdateCommonOWAnimations`) to VRAM1, plus the cliff frame from `w2d044`; called from overworld/vblank.asm and bank21.asm. | high |
| `Func_81077` | bank20.asm:244 | `HandleTempleHintInput` | At the Temple (`wMapSideLevelID == 0`, north), UP starts the next-treasure hint (`w2d013 = $0a`). | high |
| `Func_8137a` | bank20.asm:707 | `UpdateTempleHint` | The `w2d0e4` jumptable described above. | medium |
| `Func_81feb` | bank20.asm:3023 | `ApplyHighlightPalToOWTile` | Its header comment: applies palette 7 and bank 1 to `wAttrToPlaceInOW` if `w2d07f`. | high |
| `Func_81714` | bank20.asm:1214 | `UpdatePathPreviewAnimations` | Animates the 12 path-preview sprites (see the wrong-bank table). | medium |
| `Func_81477` | bank20.asm:842 | `HandlePathPreview` | B held: runs the `w2d0e3` jumptable; released: restores Wario. | medium |

### Phase 6 (cont.): objects without a full state table

#### Hidden Figure (src/engine/level/objects/hidden_figure.asm, tables in src/level.asm)

Read in full together with its RAM (see `w1d14b`.. above).

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `HiddenFigureFunc.Func_4cb9e` | hidden_figure.asm:48 | `.Intro` | Waits 20 frames, then `BOSS_HIDDEN_FIGURE` and `UpdateLevelMusic`, and switches to `.Func_4cbc4`. | high |
| `.Func_4cbc4` | :70 | `.Main` | Dispatches on `wCurObjVar1` (the body's attack phase). | high |
| `.Func_4cbf5` (phase 0) | :100 | `.Idle` | Waits its duration (skipped if `w1d15e`), then phase 1. | high |
| `.Func_4cc05` (1) | :113 | `.ChooseAttack` | After 2 swipes or an interrupted one: phase 6 (grab); otherwise phase 2 (left swipe) if Wario's screen X < $58, else 4. | high |
| `.Func_4cce2` (2) / `.Func_4ccf6` (3) | :249 / :264 | `.StartLeftSwipe` / `.LeftSwipe` | Attack 1 for $80 frames; during it the screen shakes (`Func_4cf70` with `Data_4c000`, `Func_4cf87` with `Data_4c080`); if the left hand got stunned -> attack 4 (right slam), phase 9. | high |
| `.Func_4cd45` (4) / `.Func_4cd59` (5) | :310 / :325 | `.StartRightSwipe` / `.RightSwipe` | Mirror (attack 2, `Data_4c100`, then attack 5 / phase $0a). | high |
| `.Func_4cc3c` (6) | :148 | `.StartGrab` | Waits for both slams to end, then attack 3, 7 or 8 (8 when Wario is in the middle of the screen on odd `w1d161`, with $60 frames). | high |
| `.Func_4cc87` (7) | :193 | `.Grab` | Shakes the screen along `Data_4c180`/`4c580`/`4c680`, reacts to `w1d14e`, repeats while `w1d162` allows. | high |
| `.Func_4cbe8` (8) | :89 | `.ReleaseCaughtWario` | After Wario was caught: when the duration ends, `wAutoMoveState = 0`. | low |
| `.Func_4cd28` (9) / `.Func_4cd8b` ($0a) | :292 / :353 | `.WaitLeftHandStunned` / `.WaitRightHandStunned` | Go to the defeat when `w1d15a == 0`; wait until the stunned hand has returned, then phase 6. | high |
| `.asm_4cda8` | :371 | `.defeated` | Attack 6, update function `.Func_4cdbc`. | high |
| `.Func_4cdbc` / `.Func_4ce01` | :383 / :418 | `.Defeated` / `.DefeatedSink` | Flash the palettes for $82 frames (`SFX_0CE` every 64), then `w1d15f = 1` and sink the screen (`wHiddenFigureSCYShake` decrements) until `LVLEND_EPILOGUE`. | high |
| `Func_4ce39` | :446 | `HiddenFigureFace_StartLaugh` | Sets the face's update function to `.Func_4cf55` after 60 frames. | high |
| `HiddenFigureFaceFunc.Func_4ce47` | :457 | `.Main` | Laughs on `w1d14e == $80`; on an attack (`OBJSTATE_28`/`29` = hit by a thrown hand) goes to `.Func_4cf13`; otherwise looks towards Wario (framesets by screen X; "angry" ones while a hand is stunned or at 1 hit left). | high |
| `.Func_4cf13` / `.Func_4cf3f` / `.Func_4cf55` | :560 / :581 / :593 | `.Hit` / `.Defeated` / `.Laugh` | Flash 60 frames then back to `.Main`; last hit: do nothing but play `SFX_0CE`; `SFX_HIDDEN_FIGURE_LAUGH` + laugh frameset. | high |
| `Func_4cf70` | :606 | `ApplyHiddenFigureSCYShakeTable` | Adds the next byte of table `bc` (index `wCurObjVar3`, stops at the `$80` terminator) to `wHiddenFigureSCYShake`. | high |
| `Func_4cf87` | :626 | `ApplyHiddenFigureSCXTable` | Same with `wCurObjVar2` into `wc08b` (`wHiddenFigureSCX`). | high |
| `Func_4cf9e` / `Func_4cfbf` | :646 / :676 | `ApplyCurObjYTable` / `ApplyCurObjXTable` | Same table walk, applied to `OBJ_Y_POS` / `OBJ_X_POS` (16-bit, signed). Used only by the hands. | high |
| `Func_4cfe0` | :706 | `FlashHiddenFigurePals` | Every 16 frames alternates `Pals_4d04b` and the normal palettes. | high |
| `Func_4d005` | :727 | `SetHiddenFigurePals` | `Pals_4d07b` while `w1d15a >= 2`, else `Pals_4d01b`. | high |
| `Pals_4d07b` / `Pals_4d01b` / `Pals_4d04b` | :802 / :740 / :771 | `HiddenFigurePals` / `HiddenFigureLastHitPals` / `HiddenFigureFlashPals` | As selected above (the second has red where the first has grey). | medium |
| `HiddenFigureLeftHandFunc.Func_4d0c7` | :850 | `.Idle` | Dispatches on `w1d14b`: 1 -> `.Func_4d2c8`, 3/7/8 -> `.Func_4d1b1`, 5 -> `.Func_4d164`, 6 -> `.Func_4d37f`, otherwise `.Func_4d19e` if `w1d151`. | high |
| `.Func_4d164` | :937 | `.Slam` | Waits, then `Data_4c540` (falls 50 px), `SFX_063` + `DoGroundShake`, back up; clears `w1d15c`. | high |
| `.Func_4d19e` | :967 | `.Flinch` | `Data_4c500`, clears `w1d151`. | medium |
| `.Func_4d1b1` | :977 | `.Grab` | Grab attack: X/Y tables (`Data_4c380`+`4c400`/`4c600`, or `4c700`+`4c800` for attack 8), interaction 4F then 50 (drag down) at fixed table positions; on `OBJSTATE_SPECIAL_3` (caught Wario) or an attack sets `w1d14e/f/150`. | high |
| `.Func_4d2c8` | :1115 | `.Swipe` | `Data_4c200`/`4c280`, interactions 48/52; smashed (`OBJSTATE_VANISH_TOUCH`) -> stunned (state `OBJSTATE_SPECIAL_2`, update `HiddenFigureRightHandFunc.Func_4d655`, `w1d14c = 1`); any other hit -> `w1d15e = 1`. | high |
| `.asm_4d34c` | :1185 | `.return_to_idle` | Resets interaction, flags and frameset, back to `.Func_4d0c7`. | high |
| `.Func_4d379` | :1212 | `.HoldWario` | No-op while Wario is held. | medium |
| `.Func_4d37f` / `.Func_4d39b` | :1217 / :1234 | `.WaitDefeat` / `.DefeatRise` | Wait for `w1d15f`, then move up every other frame for 32 frames. | medium |
| `HiddenFigureRightHandFunc.Func_4d3c8` .. `.Func_4d644` | :1263-1612 | same names as the left hand (`.Idle`, `.Slam`, `.Flinch`, `.Grab`, `.Swipe`, `.return_to_idle` for `.asm_4d5f5`, `.HoldWario` for `.Func_4d622`, `.WaitDefeat`, `.DefeatSink` for `.Func_4d644`, which moves down) | Mirror image with `w1d14d`, `w1d15b`, `w1d150`, `w1d156`. | high |
| `.Func_4d655` | :1613 | `.Stunned` | Update function of a stunned hand (either hand jumps here): keeps `wSCY/wSCX` at the base values (`wc08a`/`wc08c`), buzzes `SFX_06A`, and runs a full positional state table with the shared `ObjState_*` handlers. | high |

Correction to the Phase 6 table row for `HiddenFigureRightHandFunc`: the
mechanical rule named `.Func_4d83a` and `.Func_4d844` `.Default` (they fill
6 slots each), which would give three `.Default` labels in one routine.
Their code sets `OBJSTATE_WOBBLE_LEFT` ($38) / `OBJSTATE_WOBBLE_RIGHT` ($39)
with `no_actions_for 15`, so: `.Func_4d83a` -> `.WobbleLeftStart`,
`.Func_4d844` -> `.WobbleRightStart`. Also from reading them:
`.Func_4d750` (`.Special1`) -> `.ReturnToRestPos` (moves to `w1d152`/`w1d156`
and clears the stunned flag), `.Func_4d73e` (`.Special2`) ->
`.VanishThenFall` (`SFX_VANISH` while counting down, then `ObjState_Fall`;
low), `.Func_4d7fd` (`.Walk`) -> `.WaitOnFloor` (waits, then
`OBJSTATE_SPECIAL_1`). High except where noted.

Movement tables in src/level.asm (all used only here; "swipe" = attacks 1/2,
"grab" = attacks 3/7/8). Each is a list of signed per-frame deltas ending in `$80`:

| Current | Proposed | Used by | Conf. |
|---|---|---|---|
| `Data_4c000` | `HiddenFigureSwipeSCYShake` | body, both swipes (`Func_4cf70`) | high |
| `Data_4c080` / `Data_4c100` | `HiddenFigureLeftSwipeSCX` / `HiddenFigureRightSwipeSCX` | body (`Func_4cf87`) | high |
| `Data_4c180` / `Data_4c580` / `Data_4c680` | `HiddenFigureGrab1SCYShake` / `HiddenFigureGrab2SCYShake` / `HiddenFigureGrab3SCYShake` | body, attacks 3 / 7 / 8 | high |
| `Data_4c200` / `Data_4c300` | `HiddenFigureLeftHandSwipeX` / `HiddenFigureRightHandSwipeX` | hands | high |
| `Data_4c280` | `HiddenFigureHandSwipeY` | both hands | high |
| `Data_4c380` / `Data_4c480` | `HiddenFigureLeftHandGrabX` / `HiddenFigureRightHandGrabX` | attacks 3 and 7 | high |
| `Data_4c400` / `Data_4c600` | `HiddenFigureHandGrab1Y` / `HiddenFigureHandGrab2Y` | attack 3 / attack 7 | high |
| `Data_4c700` / `Data_4c760` / `Data_4c800` | `HiddenFigureLeftHandGrab3X` / `HiddenFigureRightHandGrab3X` / `HiddenFigureHandGrab3Y` | attack 8 | high |
| `Data_4c500` | `HiddenFigureHandFlinchY` | `.Flinch` | high |
| `Data_4c540` | `HiddenFigureHandSlamY` | `.Slam` | high |

Also: `wHiddenFigureSCYShake` (already named) is used as the Hidden Figure
equivalent of `wc08b`; with the first pass's `wc08b` -> `wHiddenFigureSCX`
it could become `wHiddenFigureSCY`.

### Phase 7 (cont.): overworld routines

The overworld keeps re-implementing the same few helpers per bank. Where the
code is identical the rows say so; merging them is a separate decision, but
the names below are chosen so that the copies read alike.

#### Top-level overworld states (src/engine/overworld/state_table.asm)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_804ec` | overworld/init.asm:161 | `OverworldWaitAPress` | Sub-state 3 (after `InitOverworld` and the fade): advances `wSubState` when A is pressed. | medium |
| `Func_80540` | init.asm:199 | `UpdateOWScene` | Sub-state 7, after `InitOWScene`: runs the scene, map-side objects (`Func_b4a37`), compass, OAM clean-up. | high |
| `Func_805d7` | init.asm:268 | `UpdateMapSide` | Sub-state $0b, after `InitMapSide`: `Func_80e89`, compass, OAM clean-up. | high |
| `Func_80e89` | bank20.asm:21 | `HandleMapSide` | The map-side main loop: D-pad repeat, map/common animations, top and bottom bar, then the `w2d013` jumptable (11 steps: idle input, walking, arriving, exits, Temple hint...). | high |
| `Func_81055` | bank20.asm:238 | `UpdateOWObjsAndWario` | `Func_b4a3d` (map-side objects 1-4), `Func_82041` (Wario), `Func_b4aa9` (objects 5-15): 20 callers, all at the end of a map-side step. | high |
| `Func_82041` | bank20.asm:3081 | `UpdateOWWario` | Walk SFX (`w2d10d`), facing sprite from `wLevelArrowDirections1` (`w2d10c`), then draws (`Func_8208d`). | high |
| `Func_8208d` | bank20.asm:3126 | `DrawOWWario` | Animates `w2d104` with `w2d109` and draws `w2d107` at `w2d100`; nothing when `w2d106 == 0`. | high |
| `Func_80db1` | overworld/cutscene/common.asm:29 | `ReturnFromCutscene` | `jp InitOverworld.after_cutscene`; last sub-state of `SST_OVERWORLD_CUTSCENE`. | high |
| `Func_80e33` | overworld/temple/common.asm:9 | `ExitTempleScene` | Last temple sub-state: B held -> back to the map (`SST_OVERWORLD_08`), otherwise next sub-state (the fight; see `SetFightAgainstAHiddenFigure`). | medium |
| `Func_80e55` / `Func_adbfe` | bank20.asm:5 / bank2b_1.asm:4084 | `UpdateGolfBuilding` / `_UpdateGolfBuilding` | Sub-state after `GolfBuilding` (`SST_OVERWORLD_GOLF_BUILDING`); the far routine updates the building scene and Scene Wario. | high |
| `Func_80e75` / `Func_af13c` | bank20.asm:13 / bank2b_2.asm:2491 | `UpdateEpilogue` / `_UpdateEpilogue` | Sub-state after `InitEpilogue`: epilogue script, its scene objects (`Func_ac074`, `Func_ac080`) and Scene Wario. | high |
| `Func_80e85` | bank20.asm:17 | `FinishEpilogue` | Last epilogue sub-state; only calls `Func_803e6`. | low |
| `Func_803e6` | init.asm:1 | `SaveGameOnReturnFromLevel` | If coming back from a level (`wTransitionParam`, not an exit, bars closed): `SaveGameOrEnterPerfectScreen`. | medium |
| `Func_af01f` | bank2b_2.asm:2390 | `UnreferencedInitEpilogue` | Marked unreferenced; loads the epilogue palettes, font and `EpilogueCrowdAttrmap` with `MUSIC_EPILOGUE`, like `_InitEpilogue`. | medium |

#### Step helpers (`w2d013`/`w2d014`, `w2d062`, `w2d890`/`w2d891`)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_ad011` / `Func_ad016` | bank2b_1.asm:2403 / 2407 | `WaitTempleOWStep` / `AdvanceTempleOWStep` | Same code as `WaitCutsceneFunc` / `AdvanceCutsceneFunc` (wait until `w2d014 >= c`; clear `w2d014`, increment `w2d013`), in the temple bank. | high |
| `Func_aca6d` | bank2b_1.asm:1622 | (duplicate of `Func_ad016`) | Same 5 instructions in the same file. | high |
| `Func_af130` / `Func_af135` | bank2b_2.asm:2478 / 2484 | `WaitEpilogueOWStep` / `AdvanceEpilogueOWStep` | Same code again, used by the epilogue script. | high |
| `Func_82a8d` | bank20.asm:4744 | (duplicate of `AdvanceOWFunc`) | Clears `wOWFuncCounter`, increments `w2d062`; bank20's copy of bank2d's `AdvanceOWFunc` (14 jumps from `UnlockLevel`). | high |
| `Func_81398` | bank20.asm:725 | `AdvanceTempleHint` | Clears `w2d0e5`, increments `w2d0e4`. | high |
| `Func_ad335`, `Func_ad330`, `Func_ad329`, `Func_ad33c` | bank2b_1.asm:2855-2862 | `AdvanceTempleStep`, `WaitTempleStep`, `AdvanceTempleStepOnWarioState`, `ResetTempleStep` | Update to the first-pass row (`AdvanceSceneStep`/`ResetSceneStep`, "which scene module this is wasn't checked"): bank2b_1 holds the temple scenes (`TempleScene`, `HandleTempleWarioPanic`, `HiddenFigureRevealScene`), and these mirror the prologue's `Func_ae1c2`/`Func_ae1c9`/`Func_ae1ce`/`Func_ae1d5` exactly. | high |

#### Palette fades (bank21) and their bank27 wrappers

`FadePalConfig` fades from `wTempBGPals/wTempOBPals` to `wTempPals1/wTempPals2`
(its header). Each routine below is called every frame until done, then
advances the step. The bank27 wrappers are plain `farcall`s, so they take the
name and the bank21 routine gets the `_` prefix, as for home/far pairs.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_84fff` / `Func_9cdbd` | bank21.asm:926 / bank27.asm:1176 | `_CutsceneFadePals` / `CutsceneFadePals` | Fades all 8 BG and 8 OB palettes from the current ones to `wTempPals1/2` (whatever the cutscene put there), then advances `w2d013`. | medium |
| `Func_85046` / `Func_9cd8d` | bank21.asm:962 / bank27.asm:1164 | `_CutsceneFadeToWhite` / `CutsceneFadeToWhite` | Copies BG palettes 1-7 and all OB palettes to the start buffers, fills the targets with $ff, fades. | high |
| `Func_850b9` / `Func_9cd9d` | bank21.asm:1015 / bank27.asm:1168 | `_CutsceneFadeOBToWhite` / `CutsceneFadeOBToWhite` | Same, OB palettes only. | high |
| `Func_850ff` / `Func_9cdad` | bank21.asm:1049 / bank27.asm:1172 | `_CutsceneFadeBGToWhite` / `CutsceneFadeBGToWhite` | Same, BG palettes 1-7 only. | high |
| `Func_85145` / `Func_b588d` | bank21.asm:1083 / bank2d.asm:3471 | `_OWFuncFadePals` / `OWFuncFadePals` | As `Func_84fff` but advances `w2d062` (OW functions). | medium |
| `Func_8518c` / `Func_b587d` | bank21.asm:1118 / bank2d.asm:3467 | `_OWFuncFadeBGPals` / `OWFuncFadeBGPals` | BG only, advances `w2d062`. It writes `OBPI_AUTOINC \| palette 0` into the BG config's index, which is the same value as `BGPI_AUTOINC` ($80), so harmless. | medium |
| `Func_851bc` / `Func_851d1` | bank21.asm:1144 / 1155 | `StepBGPalConfigFade` / `StepOBPalConfigFade` | One slow `FadePalConfig` step on `wPalConfig1` (rBGPI) / `wPalConfig2` (rOBPI); carry while not done. | high |
| `Func_9cd40` / `Func_9cd5a` | bank27.asm:1125 / 1138 | `SetPalConfig1ToTempPals1` / `SetPalConfig2ToTempPals2` | Point the fade configs at all 8 `wTempPals1` BG / `wTempPals2` OB palettes. | high |
| `Func_9cd74` | bank27.asm:1151 | `CopyTempPalsToBGOBPals` | `wTempPals1 -> wTempBGPals`, `wTempPals2 -> wTempOBPals`. | high |
| `Func_9cc87` | bank27.asm:1001 | `ClearBGOBPals_Bank27` | Zeroes `wTempBGPals`/`wTempOBPals`; bank21's unreferenced `Func_84fd5` is the same code (`UnreferencedClearBGOBPals`), next to the existing `ClearTempPals_Bank21`. | high |
| `Func_9cdcd` | bank27.asm:1180 | `CutsceneScreenShake` | Cutscene step: moves `wSCY` by -4, +4, -3, +3, -2, +2, -1, +1 every 6 frames, then `AdvanceCutsceneFunc`. Note it keeps its counters in `wCollectionLinkStateCounter`/`wCollectionScrollMode` (collection-screen union members, unused during cutscenes): they deserve cutscene aliases. | high |
| `Func_9cd16` | bank27.asm:1090 | `ExitCutscene` | Increments `wSubState` and stops SFX; target of all `EndCutscene*`. | high |
| `Func_9ce1f` | bank27.asm:1234 | `PlaySFX_112` | `play_sfx SFX_112 / ret`, as the existing `PlaySFX_12A`. | high |

#### Scene object drawing helpers

`UpdateOWAnimation`/`LoadOWSprite` take the frameset/OAM bank in `b`; each
bank has small wrappers that fix `b`, named here after the bank's section.
Three routines (`SetObjStateIfAnimationIsFinished` in bank2b_1, `Func_9f0d0`
in bank27, `Func_b4a0d` in bank2d) are the same code (bank27/2d take the new
state in `b`, bank2b_1 in `e`).

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_9f0a5` | bank27.asm:5858 | `GetCutsceneObjFrameset` | `a` = state (1-based), `hl` = frameset table, `bc` = state byte: returns `de` = frameset and `hl` = the object's duration field (`bc - 2`). 43 callers, always followed by `Func_9f0ae`. | high |
| `Func_9f0ae` / `Func_9f0b5` | :5867 / :5873 | `UpdateCutsceneObjAnim_OWOAM2` / `UpdateCutsceneObjAnim_ObjFramesets` | `UpdateOWAnimation` with `b = $2f` ("Overworld OAM 2") / `$1a` ("Object Framesets"), returns the state in `a`. | high |
| `Func_9f0bc` / `Func_9f0c1` / `Func_9f0c6` / `Func_9f0cb` | :5880-5895 | `LoadCutsceneObjSprite_OWOAM2` / `_ObjOAM3` / `_ObjOAM1` / `_ObjOAM4` | `LoadOWSprite` with `b = $2f`, `$62`, `$60`, `$63` ("Objects OAM 3/1/4": level object sprites reused in cutscenes). | high |
| `Func_b4a0d` | bank2d.asm:1256 | `SetOWObjStateIfAnimFinished` | Copy of `Func_9f0d0`. | high |
| `Func_ac000` (+ identical `Func_ac00b`, `Func_ac016`) | bank2b_1.asm:3 | `UpdateSceneObjAnim_CreditsOAM` | `hl` = `bc` with bit 1 cleared (state -> duration), `UpdateOWAnimation` with `BANK("Credits OAM")`. Three byte-identical copies. | high |
| `Func_ac021` | :31 | `UnreferencedUpdateSceneObjAnim_ObjFramesets` | Same with "Object Framesets"; marked unreferenced. | high |
| `Func_ac02c` / `Func_ac037` | :40 / :49 | `UpdateSceneObjAnim_TitleGfx` / `UpdateSceneObjAnim_OWOAM1` | Same with "Title Gfx" / "Overworld OAM 1". | high |
| `Func_ac042` (+ identical `Func_ac047`, `Func_ac04c`) / `Func_ac051` | :58 / :70 | `LoadSceneObjSpriteWithScroll_CreditsOAM` / `LoadSceneObjSprite_CreditsOAM` | `LoadOWSprite(WithScroll)` with `BANK("Credits OAM")`. | high |
| `Func_ac409` | bank2b_1.asm:646 | `UpdatePrologueSceneObj` | State dispatcher called for each object by the existing `UpdatePrologueSceneObjects` (and `Func_ac3fd` for objects 8/9). | high |
| `Func_ac3fd` | :640 | `UpdatePrologueSceneObjs8And9` | Calls `Func_ac409` for `wSceneObj8`/`9`. | high |
| `Func_ac0b6` | :123 | `UpdateEpilogueSceneObj` | Same kind of dispatcher, called by `Func_ac074`/`Func_ac080` from `Func_af13c` (the epilogue update). | high |
| `Func_ac074` / `Func_ac080` | :97 / :103 | `UpdateEpilogueSceneObjs_Front` / `UpdateEpilogueSceneObjs_Back` | `wCurSceneObj` + object 1 before Scene Wario, objects 5-13 after him (`Func_af13c`): drawn in front of / behind him. | medium |

#### Map-side object system (bank2d)

Each map side has its own state table for scene objects. `Func_b4a3d`
updates objects 1-4 before Wario, `Func_b4aa9` objects 5-15 after him. Per
side there is the same set of helpers:

| Current (North / East / South / West) | Proposed | Evidence | Conf. |
|---|---|---|---|
| `Func_b4fa2` / `Func_b4b99` / `Func_b4cc2` / `Func_b4dfb` | `UpdateNorthOWObj` / `UpdateEastOWObj` / `UpdateSouthOWObj` / `UpdateWestOWObj` | `bc` = state byte: stores the object pointer (`c & $f8`) in `wCurSceneObjPtr` and dispatches on the state. | high |
| `Func_b4fab` / `Func_b4ba2` / `Func_b4ccb` / `Func_b4e04` | `RunNorthOWObjState` / `RunEastOWObjState` / `RunSouthOWObjState` / `RunWestOWObjState` | The jumptable itself (44 / 36 / 33 / 36 entries); re-entered with the new state after an animation ends. | high |
| `Func_b507c` / `Func_b4c57` / `Func_b4da0` / `Func_b4e4d` | `AnimateNorthOWObj` / `AnimateEastOWObj` / `AnimateSouthOWObj` / `AnimateWestOWObj` | `UpdateCurOWObjAnimation` with `de`, then falls into the draw routine. 20/25/19/18 jumps. | high |
| `Func_b507f` / `Func_b4c5a` / `Func_b4da3` / `Func_b4e50` | `DrawNorthOWObj` / `DrawEastOWObj` / `DrawSouthOWObj` / `DrawWestOWObj` | `LoadCurSceneObjSpriteWithScroll` with `OAM_a8000` / `OAM_a980c` / `OAM_a9161` / `OAM_a884a`. | high |
| `Func_b5085` / `Func_b4c60` / `Func_b4da9` / `Func_b4e56` | `AnimateNorthOWObjOnce` / ... | Animate with `b = 0`, falls into the next row: the object stops (state 0) when its frameset ends. | high |
| `Func_b508a` / `Func_b4c65` / `Func_b4dae` / `Func_b4e5b` | `AnimateNorthOWObjThenSetState` / ... | `Func_b4a0d`: when the animation ends, state `b` and re-dispatch; otherwise draw. | high |
| West, second sprite set: `Func_b4e62`, `Func_b4e65`, `Func_b4e6b` (unreferenced), `Func_b4e70` | `AnimateWestOWObj2`, `DrawWestOWObj2`, `UnreferencedAnimateWestOWObj2Once`, `AnimateWestOWObj2ThenSetState` | Same with `OAM_a8f57`. | high |
| `Func_b4a37` / `Func_b4a3d` / `Func_b4aa9` | `UpdateMapSideOWObjs` / `UpdateMapSideOWObjs_Front` / `UpdateMapSideOWObjs_Back` | See above; `Func_b4a37` calls both. | high |
| `Func_b4000` | `OWObjState_None` | `ret`; state 0 of the four tables (8 slots). Same role as `Func_b791d` (`OWFunc_DoNothing`). | high |

The ~150 one-line state entries of those tables (`ld de, Frameset_xxx / jr
<helper>`, e.g. `Func_b5004`..`Func_b5136`, `Func_b4be9`..`Func_b4cbd`) are
best named after their frameset once the framesets are named (bulk rule:
`<Side>OWObjState_<FramesetName>`), or by slot (`NorthOWObjState_01`) until then.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_854ee` / `Func_b586d` | bank21.asm:1697 / bank2d.asm:3463 | `_ApplyOWTilemapPatches` / `ApplyOWTilemapPatches` | Walks a list of patches: big-endian `wTilemap` address, tiles until $70, attributes (written $300 lower, in `wAttrmap`) until $70; ends at a 0 address (example: `Data_8550b`). | high |
| `Func_b5868` | bank2d.asm:3459 | `ApplyOWTilemapPatchesAndRedraw` | Sets `wOWPendingTileUpdate` then falls into `Func_b586d`. | high |

Also noticed: bank2b_1 (golf building, `Func_adbfe`, :4092; map exits, :4299)
and bank2b_2 (:2926) use fields of the `wPalFade*` structs
(`wPalFade6Colour2GreenCurrent`, `wPalFade6Colour2GreenSign`,
`wPalFade2Colour2GreenUnk1`...) and `wTempleRock5Action` as scratch bytes of
unrelated scenes, as `Func_9cdcd` does with the collection variables: the
`UNION` in "WRAM2 2" would read better with a `NEXTU` of scene scratch names.

### Small leftovers

#### object_interactions.asm

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_2126a` | src/engine/level/object_interactions.asm:2262 | `TurnIntoBallOStringWario` | Used by `ObjInteraction_Silky` (front side), `ObjInteraction_AnonsterWave`/`AnonsterSilk` and :3124: if crouching without room to stand it only touches the object; otherwise `OBJACTION_06`, then (unless invincible / persistent transformation) faces away, `SFX_039`, `TRANSFORMATION_BALL_O_STRING_WARIO`, touch states, `wca94 = 1`, `WST_GETTING_WRAPPED_IN_STRING`. Same shape as `Func_2160a` (`TurnIntoBouncyWario`). | high |
| `Func_2168b` | :2736 | `PushWarioBelowSolidObject` | Touching a solid object from below (`ObjInteraction_Solid`, `ObjInteraction_Stove`, `ObjInteraction_PrinceFroggy`): Flat Wario squished -> `SetState_FlatSquishedLifting`; otherwise moves Wario down by `wc1c2` (max 12 px), dives if that put him in water, and lands (`SetState_Idling`) or falls (`StartFall`) depending on `CheckCentreCollision`. | high |
| `Func_20b41` | :1389 | `BumpOffObjectWithAction12` | Only `ObjInteraction_PrinceFroggy` (sides): `wTouchState` overrides (bump/vulnerable -> `Func_20a6f`, attack, vanish); otherwise `Func_20939` (bump off) and `OBJACTION_12`. | medium |

#### validate_save.asm locals (src/engine/pause/save/validate_save.asm)

Each saved block is checked the same way: compare the computed checksum
with the best stored copy (`.GetMatchingChecksum`), then with the two
alternates if there were mismatches, then set its bit in `wceee`, or clear
its check values. The labels of each block follow one rule:
`.<block>_mismatch` (computed != best copy), `.<block>_check_alt2` (try the
third copy), `.<block>_ok` (set the bit), and `.clear_<block>_check_vals`.
Blocks: `game_data`, `backup_game_data`, `level_map` (`s0a79d`), `level_save`
(`s0a000`), `backup1` (`s0a800`), `backup_level_map` (`s0a79f`), `backup2`
(`s0a400`), `backup3` (`s0ac00`).

| Current | Line | Proposed | Conf. |
|---|---|---|---|
| `.asm_1f0d03` / `.asm_1f0d08` / `.asm_1f0d16` / `.asm_1f0d1b` | 41 / 45 / 58 / 62 | `.progress_all_equal` / `.progress_differs` / `.progress_echos_agree` / `.progress_orig_echo1_agree` (`ValidateSaveData`: which two of the three `s0a790` copies agree) | high |
| `.asm_1f0d9b` / `.asm_1f0daf` | 148 / 162 | `.game_data_mismatch` / `.game_data_check_alt2` | high |
| `.asm_1f0e20` / `.asm_1f0e34` | 227 / 241 | `.backup_game_data_mismatch` / `.backup_game_data_check_alt2` | high |
| `.asm_1f0e6e` / `.asm_1f0e9a` / `.asm_1f0eae` / `.asm_1f0ec1` / `.asm_1f0efd` | 278 / 302 / 314 / 324 / 354 | `.check_level_map` / `.level_map_mismatch` / `.level_map_check_alt2` / `.level_map_ok` / `.level_map_bad` | high |
| `.asm_1f0f00` / `.asm_1f0f14` / `.asm_1f0f27` / `.asm_1f0f2f` | 357 / 368 / 378 / 382 | `.level_save_mismatch` / `.level_save_check_alt2` / `.level_save_ok` / `.clear_level_save_check_vals` | high |
| `.asm_1f0f83` / `.asm_1f0f97` / `.asm_1f0faa` / `.asm_1f0fb2` | 426 / 437 / 447 / 451 | `.backup1_mismatch` / `.backup1_check_alt2` / `.backup1_ok` / `.clear_level_save_and_backup1_check_vals` | high |
| `.asm_1f0fe2` / `.asm_1f100e` / `.asm_1f1022` / `.asm_1f1035` / `.asm_1f1071` | 481 / 504 / 515 / 525 / 554 | `.check_backup_level_map` / `.backup_level_map_mismatch` / `.backup_level_map_check_alt2` / `.backup_level_map_ok` / `.backup_level_map_bad` | high |
| `.asm_1f1074` / `.asm_1f1088` / `.asm_1f109b` / `.asm_1f10a1` | 556 / 567 / 577 / 582 | `.backup2_mismatch` / `.backup2_check_alt2` / `.backup2_ok` / `.clear_backup2_check_vals` | high |
| `.asm_1f10f5` / `.asm_1f1109` / `.asm_1f111c` / `.asm_1f1122` | 626 / 637 / 647 / 652 | `.backup3_mismatch` / `.backup3_check_alt2` / `.backup3_ok` / `.clear_backup2_and_backup3_check_vals` | high |

Behaviour worth knowing (read while naming): the level save and backup 1
are only kept if the level map checksum is good, backups 2/3 only if the
backup level map is good; and only the first valid save of each pair is
validated: a good level save jumps past backup 1 (`jp .asm_1f0fe2`), and a
good backup 2 returns before backup 3 is looked at, so bit 3 / bit 5 of
`wceee` are only set when the first save of the pair is bad. Looks
deliberate (one good copy per map is enough) rather than a bug.

#### Palette fade struct (`colour_part_fade_struct`, src/macros/wram.asm)

The field names of the macro don't match the offsets used by the code and
by `COLOURFADESTRUCT_*` (src/constants/gfx_constants.asm). bank21.asm
(`InitColourFadeStructs`, the day/night step, `ApplyPalFadeColours`) reads
offset 0 as the base colour, 4 as the accumulator and 5 as the current
value, with comments naming the constants; offsets 6/7 are never accessed.

| Offset | Macro field now | `COLOURFADESTRUCT_*` | Proposed field | Conf. |
|---|---|---|---|---|
| 0 | `\1Current` | `BASE` | `\1Base` | high |
| 1-3 | `\1Target`, `\1Sign`, `\1Diff` | same | (keep) | high |
| 4 | `\1Unk1` | `ACCUMULATOR` | `\1Accumulator` | high |
| 5 | `\1Unk2` | `CURRENT` | `\1Current` | high |
| 6, 7 | `\1Unk3`, `\1Unk4` | `UNK_3`, `UNK_4` | padding to 8 bytes (`ds 2`; drop the two constants or call them `_UNUSED_6/7`) | high |

Every current reference to these fields by name (`wPalFade6Colour2GreenCurrent`,
`...Sign`, `wPalFade2Colour2GreenUnk1`, `wPalFade7Colour3RedUnk1`,
`wPalFade1Colour1RedUnk1` in bank27.asm:5806, the `...Unk3` ones in bank20.asm)
is a scene using the bytes as scratch, or the wrong-union case in
`Func_81714` noted above; so the rename changes no real fade code, but those
users need their own labels.

#### Audio struct fields (src/constants/audio_constants.asm, src/audio/engine.asm)

| Current | Proposed | Evidence | Conf. |
|---|---|---|---|
| `CHANNEL_UNK_0A` | `CHANNEL_NOTE_VOLUME` | Note command (`Func_30a1f`): an argument byte < $20 is stored as `x << 3 \| 7`; copied into the track as `TRACK_UNK06` (engine.asm:2070), which scales the track volume with `CHANNEL_UNK_2F` (`.Func_30dc6`). | medium |
| `CHANNEL_UNK_0B` | `CHANNEL_NOTE_DURATION` | Set from the note command's duration (`b`), extended by arguments $20-$23; copied into `TRACK_DURATION` (engine.asm:2073). | high |
| `CHANNEL_UNK_1D` | `CHANNEL_FREQUENCY_OFFSET` | Signed byte added to the pitch product when the frequency is recomputed (`Func_30651`); set by audiocmd_c9 (`AudioCmd_SetChannelUnk1d` -> `AudioCmd_SetChannelFrequencyOffset`). | high |
| `CHANNEL_UNK_1E` | `CHANNEL_UNUSED_1E` | Only written, by audiocmd_ca (`AudioCmd_SetChannelUnk1e`); never read. The init code's comment calls it `CHANNEL_UNK_2E` (engine.asm:670, typo). | high |
| `CHANNEL_UNK_VIBRATO_VALUE` | `CHANNEL_VIBRATO_PHASE` | Accumulates `CHANNEL_VIBRATO_SPEED` every tick ($40 while the delay runs); its folded value becomes `wVibratoValue` (engine.asm:1097-1112). | high |
| `CHANNEL_UNK_24` (word) | `CHANNEL_VIBRATO_FREQ_OFFSET` | `(amplitude stuff) * 8`, compared/stored in `.calculate_vibrato` and added to the frequency unless `CHANNEL_VIBRATO_DISABLED` (engine.asm:1159, 1222). | high |
| `CHANNEL_UNK_26` | `CHANNEL_CALL_DEPTH` | `AudioCmd_Call` adds 2 (max $0a) and stores the return address at `+ $0a + depth` from this field; `AudioCmd_Ret` takes it back. | high |
| `CHANNEL_UNK_29` | `CHANNEL_LOOP_COUNTER` | `AudioCmd_Loop` increments it and jumps until it reaches the argument, then clears it. | high |
| `CHANNEL_UNK_27` / `CHANNEL_UNK_28` | `CHANNEL_RELEASE_VOLUME` / `CHANNEL_RELEASE_LENGTH` | Set by audiocmd_d6/d7 (`AudioCmd_SetChannelUnk27/28`) or together by `Func_309b6`; when a note's envelope runs out (engine.asm:2452-2470) the track volume becomes `CHANNEL_UNK_2F * CHANNEL_UNK_27` and `CHANNEL_UNK_28` is loaded as the remaining count; 0 in any of the three ends the note. | low |
| `CHANNEL_UNK_2F` | `CHANNEL_EFFECTIVE_VOLUME` | `CHANNEL_VOLUME * CHANNEL_VOLUME_MOD`, rounded, capped, `* 4` (engine.asm:1262-1276); multiplied into every track volume. | high |
| `CHANNEL_UNK_30` | `CHANNEL_UNUSED_30` | Only set to $ff by the channel init. | high |
| `CHANNEL_UNK_31` | `CHANNEL_UNUSED_31` | Never referenced. | high |
| `CHANNEL_UNK_32`..`CHANNEL_UNK_3B` | `CHANNEL_CALL_STACK` (10 bytes) | Never referenced by name: the 5 return addresses of `AudioCmd_Call` live at `CHANNEL_UNK_26 + $0c`.. `+ $15`, i.e. $32-$3b. | high |
| `TRACK_UNK02` (+ `wTempTrackUnk02`) | `TRACK_OWNER` (+ `wTempTrackOwner`) | `wNumAudioChannels` (the channel number) with bit 7 set for SFX (engine.asm:2003-2009); second priority key when tracks compete (:2038), bit 7 tested to tell SFX from music (:2170, :2183). | medium |
| `TRACK_UNK03` | `TRACK_NOTE` | The note (pitch + semitone offset, `wSoundEngineParam3`); a channel reuses the track already playing the same note (:2140-2150). | medium |
| `TRACK_UNK06` | `TRACK_NOTE_VOLUME` | Copy of `CHANNEL_UNK_0A`; volume scale. | medium |
| `TRACK_UNK0D` | `TRACK_UNUSED_0D` | Only cleared. | high |
| `TRACK_UNK0E` | `TRACK_FREQUENCY_HI_ADD` | From `wSoundEngineParam4` (the note, or byte 6 of a percussion entry), added to the frequency high byte in `SetFrequency`. Purpose unclear. | low |
| `TRACK_UNK0F`, `TRACK_UNK14`..`TRACK_UNK17` | `TRACK_UNUSED_*` | Never referenced. | high |

#### Notable finding: update-function pointers written as numbers

Three places set `OBJ_UPDATE_FUNCTION` from literal bytes instead of
`HIGH()/LOW()` of a label, so they break as soon as code before them moves
(relevant to this fork, which edits object code). A scan of `src/` for this
pattern found exactly these. **Fixed** as proposed (the ROM stayed
byte-identical, so the labels point exactly where the literals did):

| Where | Literal | Target | Fix | Conf. |
|---|---|---|---|---|
| src/engine/level/objects/togeba.asm:60-63 | `$4e`, `$02` | `TogebaFunc.Func_48e02` (bank $12:$4e02) | `HIGH/LOW(.Func_48e02)`; the label is otherwise unreferenced | high |
| togeba.asm:102-105 | `$4e`, `$3e` | `TogebaFunc.Func_48e3e` ($4e3e) | `HIGH/LOW(.Func_48e3e)`; also otherwise unreferenced | high |
| src/engine/level/objects/seeing_eye_door.asm:94-97 | `$54`, `$f6` | bank $11:$54f6, the unlabeled code right after `jr .Default` (seeing_eye_door.asm:49) that waits until Wario is within $36 px vertically (unless invisible) and then jumps to `.CheckWarioDistance` | add a label there (`.WaitForWario`) and use it; the block looks unreachable in the source but isn't | high |

#### Other objects' `.Func_` locals

Names follow the existing ones in the same files (`.Init`, `.Update` for the
per-frame dispatcher, `.ThrowHead`, ...): states in `.CamelCase`, shared
tails in `.snake_case`.

| File | Proposed (label -> name) | Evidence | Conf. |
|---|---|---|---|
| appleby.asm | `.Func_479e0` -> `.Hidden`; `.Func_47ab0` -> `.HandleHit`; `.Func_47bd3` / `.Func_47bd8` -> `.HopLeft` / `.HopRight` | State 0 of `.Update`: no collision, waits while on screen, then appears (state $5a, collision on). States $01-$29: vanish/attack/thrown reactions, otherwise back to hiding ($2d). The last two move one way while applying `Data_60040` (`DropYVel_Light`), chosen by Wario's side. | medium |
| big_leaf.asm | `.Func_42d0e` -> `.WaitAndDespawn` | Set when the leaf lands in water/sand (splash frameset, `SFX_08F`): counts down, then clears `wCurObjFlags`. | high |
| bird.asm | `.Func_432c2` -> `.Idle`; `.Func_43342` -> `.Special3`; `.Func_43353` -> `.FlyAway`; `.Func_4340b` / `.Func_43427` -> `.BlueBirdWait` / `.BlueBirdLand` | `.Idle` is state 0 (faces Wario when on screen); `.Special3` is state $2f (countdown, `SFX_070`); after being released a normal bird flies off fast (`MoveObjectLeft/Right_Fast`), the blue bird waits, changes frameset, then sets `OBJSTATE_LAND` facing its direction. | medium (low for the blue bird pair) |
| bubble.asm | `.Func_47c88` -> `.Rise` | Moves up 1 px (every other frame on screen), bursts on a ceiling (`Func_358b`, `.set_burst`). `.Func_47d56` (side probes, then turns around) left unnamed: low confidence. | medium |
| falling_snow.asm | spawner: `.Func_49544` -> `.WaitAndSpawn`, `.Func_49566` -> `.ShowWarning`, `.Func_4959d` -> `.HideWarning`; snow: `.Func_495ef` -> `.StartFall`, `.Func_49610` -> `.Fall`, `.Func_49675` -> `.FallBroken`, `.Func_496ae` -> `.WaitAndDespawn` | `FallingSnowSpawnerFunc` spawns `ObjParams_FallingSnow` (`CreateObjectFromCurObjPos`), then moves up 10 px and shows a frameset for $1d frames, then hides and loops. `FallingSnowFunc`: shakes ($20 frames, `SFX_080`), falls until `Func_352b` finds floor (landing frameset, `SFX_0A1`); in state $18 it uses another frameset; then despawns. | medium |
| kushimushi.asm | `KushimushiVerticalFunc.Func_42acf` -> `.Update` | Per-frame state dispatcher, also used by `KushimushiHorizontalFunc`. | high |
| muddee_stinger.asm | `.Func_4ca2a` -> `.Update` | Only update function of the stinger (see `w1d147` above). | high |
| owl.asm | `.Func_492b4` -> `.FlyAway` | After rising: flies left/right with `SFX_FLAP` on a frame until the duration ends; despawns on state $18. | medium |
| water_drop.asm | `.Func_49d83` -> `.Update` | Only update function: states 0, $5a, $5b. | high |
| water_spark.asm | `.Func_4a482` / `.Func_4a49d` -> `.Idle` / `.Spark` | Idle until it gets a state, then 100 frames of the spark frameset with actions disabled, then back. | medium |
| haridama.asm | `.Func_48f28` -> `.Patrol`; `.Func_48fae` -> `.Uncurl`; `.Func_490e8` -> `.UpdateRolling`; `.Func_49184` -> `.RollRight`; `.Func_49199` / `.Func_491b6` -> `.CheckWallLeft` / `.CheckWallRight` | State 0 walks left slowly (turns at walls) and curls (frameset 692c7) when Wario is within $40 px; state $5b restores `OBJ_INTERACTION_HARIDAMA` and state $32 when its timer ends. The two checks are `Func_3513` (side probe) at x-9 / x+8, 8 px up, each used 4 times. `.Func_49094` (head probe + water check) left unnamed. | medium (high for the two checks) |
| octohon.asm | `SmallOctohonFunc`: `.Func_4a4d4` -> `.Start`, `.Func_4a50f` -> `.Update`; second object: `.Func_4a6b9` -> `.Start`, `.Func_4a729` -> `.Update` | Each `.Start` faces Wario, sets a $ac-frame timer and switches to its `.Update`. | medium |
| pillar_platform.asm | `.Func_49cc2` / `.Func_49cce` -> `.Rise` / `.Lower`; `.Func_49ce5` -> `.Update`; `.Func_49d43` -> `.SetLinkedPlatformsState` | One-way platform (`SetOneWayPlatformAction` each frame). On `OBJSTATE_2B` it rises (`MoveObjectUp_Fast` for 9 frames, at most twice); `.Func_49d43` walks all objects with the same `OBJ_UNK_01` and state $20 and writes `c` into them. | medium (low for the last) |
| prince_froggy.asm | `.Func_440c4` / `.Func_440ca` / `.Func_440d0` / `.Func_440d6` -> `.SetHitByObjLeft` / `.SetHitByObjRight` / `.SetAttackedLeft` / `.SetAttackedRight`; `.Func_441dc` -> `.StartTurnAround`; `.Func_44220` -> `.HopAndVanish` | The first four install `Func_33f8`/`Func_3407`/`Func_3326`/`Func_3317` (`ObjState_HitByObjLeft/Right`, `ObjState_AttackedLeft/Right`) as the update function. `.Func_441dc` sets state $43 (`OBJSTATE_TURN_AROUND`) and `OBJ_INTERACTION_PRINCE_FROGGY`. The last hops on `Data_60040`, then `VanishObject2`. | high (medium for the last two) |
| robo_mouse.asm | `.Func_488f7` -> `.Init`; `.Func_4892a` -> `.Update`; `.Func_48cec` -> `.BreakBlocksInFront` | `.Update` is the positional state table of the first pass's row; `.Func_48cec` probes 14 px ahead at two heights with `COLLISION_ROBO_MOUSE_BREAK`. | high (medium for the last) |
| spearhead.asm | `.Func_40478` -> `.set_fall` (tail of `.State14`/`.State15`); `.Func_4057d` -> `.set_wobble_state`; `.Func_405b6` -> `.reset_animation` | Shared tails inside the already-named state handlers. | high |
| tadpole.asm | spawner: `.Func_49e4b` -> `.WaitForWario`, `.Func_49e7f` -> `.WaitAndDespawn`; tadpole: `.Func_49eb3` -> `.WaitOnScreen`, `.Func_49ece` -> `.Appear`, `.Func_49f34` -> `.Update`, `.Func_49fb5` -> `.WaitAndDespawn` | The spawner waits until Wario is to its left and $28-$50 px above, then despawns itself after a timer (`DespawnObject`). The tadpole appears once on screen (`SFX_07F`) and then runs its state dispatcher. | medium |
| togeba.asm | `.Func_48d9b` -> `.SetUpright`; `.Func_48db7` -> `.Upright`; `.Func_48e02` -> `.FlipOver`; `.Func_48e46` -> `.Flipped`; `.Func_48ecc` -> `.FlippedBounce`; `.Func_48e2b` -> `.StartRecover`; `.Func_48e3e` -> `.Recover` | Upright it stings (`OBJ_INTERACTION_FULL_STING`); a ground shake ($10+) flips it (hop on `Data_60760`, then `OBJ_INTERACTION_WALKABLE`); when it can't stand (`Func_352b` at both sides) it starts recovering (16 frames) and becomes upright again. See the literal pointers above. | medium |
| zip_line.asm | `.Func_49356` -> `.Reset`; `.Func_49369` -> `.Idle`; `.Func_493dc` -> `.CarryWario`; `.Func_49405` -> `.WaitThenReset`; `.Func_49412` -> `.DoNothing`; `.Func_49418` -> `.Move`; `.Func_494af` / `.Func_494cb` -> `.move_left` / `.move_right` | `.Move` moves the zip line by `OBJ_VAR_2` in its direction (wall probes with `Func_3513`) and Wario with it (`MoveWarioLeft` + `Func_19713`...); when Wario is no longer `TRANSFORMATION_RAIL`, wait 10 frames and reset. | medium |
| zombie.asm | `.Func_45ce2` -> `.CheckWarioNear`; `.Func_45ddc` -> `.TurnAround` | Wario within 32 px vertically and 48 px horizontally; the other flips `OBJSUBFLAG_HDIR` at 20 frames left and otherwise walks (`Func_3308`). | medium (low for the second) |
| snake.asm | `.Func_49943` -> `.Wait`; `.Func_49957` -> `.Rise`; `.Func_49984` -> `.TurnToLook`; `.Func_499b8` -> `.Look`; `.Func_499f8` -> `.ShootFire`; `.Func_49a57` -> `.EndShooting`; `.Func_49a7c` -> `.StartSinking`; `.Func_49a85` -> `.start_sinking`; `.Func_49aa1` -> `.Sink`; `.Func_49af0` -> `.UpdateFrameset` | Steps of the substate jumptable in `.Update`: wait ($3e frames, `SFX_11A`), rise carrying Wario (`MoveWarioUp` when stepped on), turn and look, spit fire (`ObjParams_SnakeFireLeft/Right`, `SFX_089`), then sink back to the start Y saved in `OBJ_VAR_2` (`SFX_08B`) and wait $78 frames. Being hit also goes to `.start_sinking`. `.Func_49b76` (sets state 0 or $48 from the screen Y) left unnamed. | low-medium |
| hand.asm | `.Func_477b2` -> `.Hidden`; `.Func_477de` -> `.Emerge`; `.Func_477f3`, `.Func_4780e`, `.Func_47825`, `.Func_4783c`, `.Func_47853`, `.Func_4786a` -> `.Rise1`..`.Rise6`; `.Func_47881` -> `.Reach`; `.Func_47896` -> `.Grab`; `.Func_478e1`, `.Func_47903`, `.Func_47925`, `.Func_47947` -> `.Sink1`..`.Sink4`; `.Func_47966` -> `.Retract` | Steps of the `wCurObjVar1` jumptable in `.Update` (the 16th is the existing `.Invisible`). Hidden until its timer ends (reset while Wario is in sand), `SFX_081`; each rise step moves up 4 px with a new frameset; `.Reach` holds 56 frames; `.Grab` waits for Wario to be caught (state $2e, set from $2f); the sink steps move down 2 px and carry Wario (`.ApplyOffsetToWario`); the last one releases him (`wAutoMoveState = 0`). | medium |
| nobiiru.asm | `.Func_4380e` -> `.Update`; `.Func_4382e` -> `.Wait`; `.Func_43876`, `.Func_438a0`, `.Func_438c5`, `.Func_438ea`, `.Func_43910` -> `.Extend1`..`.Extend5`; `.Func_43936` / `.Func_43956` -> `.Bite1` / `.Bite2`; `.Func_4396e`, `.Func_43994`, `.Func_439ba`, `.Func_439e0`, `.Func_43a06` -> `.Retract1`..`.Retract5`; `.Func_43a2c` -> `.RetractEnd` | `.Update` dispatches on `wCurObjVar1`. `.Wait` counts 60 frames then `SFX_079` and starts extending 12 px; each extend step moves 4 px towards its side with a longer frameset and collision box; the two bite frames switch to `OBJ_INTERACTION_0B`; the retract steps mirror the extend ones; the last returns to the start (`.asm_437f7`). | medium |
| sun_moon.asm | `SunFunc`: `.Func_472a6` -> `.Update`, `.Func_4731e` -> `.Idle`, `.Func_47378` / `.Func_47388` -> `.StartTurnRight` / `.TurnRight`, `.Func_4739c` / `.Func_473ac` -> `.StartTurnLeft` / `.TurnLeft`, `.Func_472bb` -> `.Drop`; `MoonFunc`: `.Func_475c7`, `.Func_4763f`, `.Func_47699`/`.Func_476a9`, `.Func_476bd`/`.Func_476cd`, `.Func_475dc` -> the same names | `.Update` dispatches on `wCurObjVar1` (0-5). `.Idle`: when no button is pressed for 50 frames and Wario is within 64 px horizontally and 43 px below, it drops (`var1 = 5`, then `SunMoon_XMovement` + floor probe). The turn pairs end on the frameset `.CheckDirection` uses for facing right (`Frameset_68f6b` / moon `68fd0`) or left (`68f74` / `68fd9`). | medium |
| pneumo.asm | `.Func_4570f` -> `.Float`; `.Func_458c7` -> `.Retreat`; `.Func_4592e` -> `.end_retreat`; `.Func_457bd` -> `.Descend`; `.Func_4585c` -> `.Rise`; `.Func_45893` -> `.Wait`; `.Func_45934` -> `.FollowWarioY`; `.Func_456fe` -> `.set_float`; `.Func_4589d` -> `.start_retreat` | Steps of the substate low nybble in `.Update`. `.Float` bobs along `Data_44000` and moves sideways with wall turns; `.start_retreat` (also on being touched, and when Wario is Puffy) faces away from Wario and moves along `Data_60600` for a while; `.Descend` sinks 2 px a frame until floor or Wario's height; `.Rise` goes up until a ceiling or its timer; `.FollowWarioY` moves towards Wario's Y unless he is Puffy. Roles inferred from movement only. | low |

### Action help demos (src/engine/action_help/)

Each power-up demo in `power_ups/*.asm` is a script: `.StateTable` of
`<X>ActionHelp` dispatches on `wActionHelpState`; slot 0 is
`ActionHelp_Init`/`ActionHelp2_Init` and a few slots are the shared
`ActionHelp(2)_Flash*Input` helpers. Every file follows the same layout
(checked with a script over all 13 files, 302 `Func_`):

- **slot 1**: `ld hl, wTimer / dec [hl] / ret nz`, falling into the next,
  unlisted `Func_` -> `<X>ActionHelp_WaitToStart`;
- **the routine it falls into** (not in the table) sets up the demo scene
  (Wario walking in, objects, D-pad prompt) -> `<X>ActionHelp_Start`;
- **the first `Func_` of the file** (not in the table) is jumped to by the
  last slot: if the demo was opened from a level clear or the title screen
  it exits (`ACTION_HELP_LEVEL_CLEAR_F`: back to the caller,
  `ACTION_HELP_TITLE_SCREEN_F`: `InitWithoutDemoPowerUpReset`), otherwise it
  clears the inputs and restarts at slot 1 -> `<X>ActionHelp_End`;
- **all other slots** are one scripted step each (move Wario/objects,
  show an input, wait on `wTimer`) -> `<X>ActionHelp_Step<slot>` (two hex
  digits) until someone reads them, as for the object states in Phase 6.

`<X>` is the existing routine name: `NoPowerUp`, `GrabGlove`, `Garlic`,
`HeadSmashHelmet`, `HighJumpBoots`, `LeadOveralls`, `PrinceFrogsGloves`,
`SuperGrabGlove`, `SuperJumpSlamOveralls`, `SwimmingFlippers`, `Owl`,
`Rail`, `Vampire`. Confidence: high for `_End`, `_WaitToStart`, `_Start`
(the code is identical in shape in every file), medium for the slot names.

| File | `_End` | `_WaitToStart` | `_Start` | Step slots (`_Step02`..) |
|---|---|---|---|---|
| none.asm | `Func_1f8362` | `Func_1f8395` | `Func_1f839a` | slots 02-20 (29 `Func_`) |
| grab_gloves.asm | `Func_1f9569` | `Func_1f959c` | `Func_1f95a1` | slots 02-24 (33) |
| garlic.asm | `Func_1f9ce7` | `Func_1f9d1a` | `Func_1f9d1f` | slots 02-23 (32) |
| head_smash_helmet.asm | `Func_1f927a` | `Func_1f92ad` | `Func_1f92b2` | slots 02-0c (10) |
| high_jump_boots.asm | `Func_1fa912` | `Func_1fa945` | `Func_1fa94a` | slots 02-18 (22) |
| lead_overalls.asm | `Func_1f8988` | `Func_1f89bb` | `Func_1f89c0` | slots 02-1e (28) |
| prince_frogs_gloves.asm | `Func_1fad42` | `Func_1fad75` | `Func_1fad7a` | slots 02-12 (16) |
| super_grab_gloves.asm | `Func_1fb179` | `Func_1fb1ac` | `Func_1fb1b1` | slots 02-18 (23) |
| super_jump_slam_overalls.asm | `Func_1fa4b2` | `Func_1fa4e5` | `Func_1fa4ea` | slots 02-13 (17) |
| swimming_flippers.asm | `Func_1f8e31` | `Func_1f8e64` | `Func_1f8e69` | slots 02-14 (17) |
| owl.asm | `Func_1e407e` | `Func_1e4095` | `Func_1e409a` | slots 02-0c (10) |
| rail.asm | `Func_1e430d` | `Func_1e4324` | `Func_1e4329` | slots 02-11 (14) |
| vampire.asm | `Func_1e45d7` | `Func_1e45ee` | `Func_1e45f3` | slots 02-10 (12, plus the mislabeled slot 07 below) |

(The `ActionHelp2_*` files, owl/rail/vampire, have no level-clear case in
`_End`: only the title-screen check.)

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `ApplyWaterCurrentMovementb` | src/engine/action_help/power_ups/vampire.asm:162 | `VampireActionHelp_Step07` | Mislabeled: slot 7 of the vampire demo's `.StateTable` (bat flapping, `SFX_FLAP` every 16 frames, moving Wario's sprite); nothing to do with `ApplyWaterCurrentMovement` (wario_states_1.asm:3911), whose name was apparently copied with a stray `b`. | high |
| `Func_1fb6f7` | common1.asm:180 | `HandleActionHelpPowerUpSelection` | Called from `UpdateActionHelp` (core.asm:209) unless opened from a level clear/title screen: D-pad right/left changes `wActionHelpPowerUp` (bounded by `NUM_MAIN_POWER_UPS`), resets `wActionHelpState`, moves the cursor (`wMenuObj1XCoord` +/- $10) and blacks the screen out. | high |
| `Func_1e48bc` | common2.asm:17 | `BlackOutActionHelpBGPals` | Sets `wActionHelpBlackedOut` and loads `Pals_1e4eef` to the BG palettes directly (`LoadActionHelpBGPals`); the next routine, `LoadActionHelpCommonPals`, does the same into `wTempPals1`. | medium |
| `Func_1e4a47` | common2.asm:241 | `LoadActionHelpPowerUpIconPals` | OB palettes 4 and 7 for the power-up icons: black when `wActionHelpPowerUp` is above the obtained level, otherwise from `Pals_1e4f2f`; then draws `OAM_1e6bab`. | medium |
| `Func_1e4b6d` | common2.asm:384 | `UnreferencedLoadActionHelpObjSprite` | No references; draws `OAM_1e6bab` at the object at `hl` (minus `wSCY`). | medium |

### Audio engine routines (src/audio/engine.asm)

Read together with the struct fields above. Command bytes: `DoAudioCommand`
sends $d0-$ff to `Func_30a14`, $b1-$cf through `PointerTable_306d1`, and
anything below $b1 to `Func_3073f`.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `PointerTable_306d1` | engine.asm:1285 | `AudioCommandTable` | Indexed by command - $b1; its entries are commented with the `AUDIOCMD_*` constants. | high |
| `PointerTable_3070f` | :1318 | `AudioSpecialCommandTable` | Second-level table, commented with `AUDIOCMDSPECIAL_*`. | high |
| `Func_30727` | :1332 | `AudioCmd_Special` | Command $cd: reads a sub-command (< $0c, else end) and its argument and jumps through `PointerTable_3070f`. | high |
| `Func_3073f` | :1345 | `AudioCmd_Wait` | Commands below $b1: duration from `Data_3102b` (index command - $80; $80 itself does nothing), stored in `CHANNEL_DURATION` with the command pointer, ending the channel's tick. | medium |
| `Func_30a14` | :1872 | `AudioCmd_Note` | Commands $d0-$ff: duration from `Data_3102b` (index command - $cf), then the note body. | high |
| `Func_30a10` | :1868 | `AudioCmd_NoteNoDuration` | Command $ce: the note body with duration 0. | medium |
| `Func_30a1f` | :1882 | `PlayNote` | Reads the note's arguments (pitch, `CHANNEL_UNK_0A`, duration extension), picks a track by timbre (`SetTrack1..4`) and owner, fills the track from the channel. | high |
| `Data_3102b` | :3009 | `AudioCmdDurations` | The duration table both use (comments "80 \| cf"). | high |
| `Func_30b4d` | :2098 | `AudioCmd_ReleaseNote` | Command $cf: optional pitch argument; finds this channel's track playing that note with no duration left and starts its release (`Func_30be3`). | medium |
| `Func_3098b` | :1765 | `SetChannelSignedProperty` | Stores `arg * 2 - $80` at the channel field `bc` (used for `CHANNEL_UNK_1D`). | high |
| `Func_309ce` / `Func_309eb` | :1820 / :1841 | `SetChannelPropertyHighNybble` / `SetChannelPropertyLowNybble` | Replace the high/low nybble of the field `bc` with the argument. | high |
| `Func_309e8` / `Func_30a03` | :1837 / :1857 | `AudioCmd_SetChannelFadeInEnvelopeLow` / `AudioCmd_SetChannelFadeOutEnvelopeHigh` | Special commands 3 and 4. With them the existing `AudioCmd_SetChannelFadeInEnvelope` (special 2) sets the high nybble and `AudioCmd_SetChannelFadeOutEnvelope` (special 5) the low one; renaming those two `...High`/`...Low` would make the four read as a set. | high |
| `Func_309b6` | :1796 | `AudioMod_Release` | Sets `CHANNEL_UNK_27`/`28` together through `AudioModSetValue_Long`. Name depends on the low-confidence field names above. | low |
| `Func_30547` | :985 | `RefreshChannel` | On frames without a tick, for every channel with `CHANFLAGS_6 \| CHANFLAGS_ACTIVE`: copy its flags and recompute frequency/output/volume (`Func_30651`). | medium |
| `Func_30651` | :1188 | `ApplyChannelUpdates` | Per the `CHANFLAGS_UPDATE_*` bits: frequency = pitch product + `CHANNEL_UNK_1D` + pitch offset + vibrato, SO flags from the two pans, effective volume. | high |
| `Func_30bb0` / `Func_30bc2` | :2161 / :2174 | `TickSFXTrack` / `TickMusicTrack` | Called for every track on SFX / music ticks; act only on active tracks owned by SFX (bit 7 of `TRACK_UNK02`) / music, then fall into `Func_30bd2`. | high |
| `Func_30bd2` | :2187 | `TickTrackDuration` | Stops the track if its channel is gone, otherwise counts `TRACK_DURATION` down and releases the track at 0. | high |
| `Func_30be3` | :2205 | `ReleaseTrack` | Sets `TRACKFLAGS_4 \| TRACKFLAGS_6`, clears `TRACKFLAGS_5` (starts the fade-out), or stops it if already releasing. | medium |
| `Func_30bf2` / `Func_30bf6` | :2216 / :2221 | `StopTrack_FromChannelPtr` / `StopTrack` | Clear `TRACK_FLAGS` and `TurnSoundRegisterOff`; the first rewinds `hl` from the channel pointer field. | high |
| `Func_30bfb` | :2226 | `ProcessTrack` | Every frame for every track: envelopes (fade in/out), frequency, volume; uses `w3d01a`. | medium |

### Bulk data labels

#### `Pals_cXXXX` (src/data/levels/palettes.asm, 146 labels)

`RoomPals::` (src/data/levels/rooms1.asm) lists all 146 in label order, each
commented with its `ROOM_PAL_*` constant (`dw Pals_cc000 ; ROOM_PAL_000` ..
`dw Pals_ce440 ; ROOM_PAL_145`; checked by script: same order, no label used
twice). Rule: `Pals_<addr>` -> `RoomPals<NNN>` with the constant's number
(`Pals_cc000` -> `RoomPals000`, `Pals_ce440` -> `RoomPals145`), as
`BlocksetTiles00` follows `BLOCKSET_00`. High.

#### `LevelRooms_XXXXX` (src/data/levels/rooms1.asm, rooms2.asm, 119 labels)

`LevelRooms::` has one entry per `<LEVEL>_DAY_n` / `<LEVEL>_NIGHT_n`
constant; 54 labels are shared by several entries. Rule: the level in
CamelCase, then `Day`/`Night` (omitted when day and night share the
rooms), then the number or range, then `Rooms`. Generated for all 119
(no collisions with `src/`), high confidence as a mechanical rule:

`LevelRooms_c0d1f` OutOfTheWoodsDay1To2Rooms; `LevelRooms_c0e03` OutOfTheWoodsDay3Rooms; `LevelRooms_c0ee7` OutOfTheWoodsDay4Rooms; `LevelRooms_c0fcb` OutOfTheWoodsNight1To2Rooms; `LevelRooms_c10af` OutOfTheWoodsNight3Rooms; `LevelRooms_c1193` OutOfTheWoodsNight4Rooms; `LevelRooms_c1277` ThePeacefulVillageDay1Rooms; `LevelRooms_c135b` ThePeacefulVillageDay2To4Rooms; `LevelRooms_c143f` ThePeacefulVillageNight1Rooms; `LevelRooms_c1523` ThePeacefulVillageNight2To4Rooms; `LevelRooms_c1607` TheVastPlainDay1To3Rooms; `LevelRooms_c16c3` TheVastPlainDay4Rooms; `LevelRooms_c177f` TheVastPlainNight1To3Rooms; `LevelRooms_c183b` TheVastPlainNight4Rooms; `LevelRooms_c18f7` BankOfTheWildRiverDay1To3Rooms; `LevelRooms_c19d3` BankOfTheWildRiverDay4Rooms; `LevelRooms_c1aaf` BankOfTheWildRiverNight1To3Rooms; `LevelRooms_c1b8b` BankOfTheWildRiverNight4Rooms; `LevelRooms_c1c67` TheTidalCoastDay1To2Rooms; `LevelRooms_c1d2b` TheTidalCoastDay3Rooms; `LevelRooms_c1def` TheTidalCoastDay4Rooms; `LevelRooms_c1eb3` TheTidalCoastNight1To2Rooms; `LevelRooms_c1f77` TheTidalCoastNight3Rooms; `LevelRooms_c203b` TheTidalCoastNight4Rooms; `LevelRooms_c20ff` SeaTurtleRocksDay1Rooms; `LevelRooms_c21c3` SeaTurtleRocksDay2To3Rooms; `LevelRooms_c2287` SeaTurtleRocksDay4Rooms; `LevelRooms_c234b` SeaTurtleRocksNight1Rooms; `LevelRooms_c240f` SeaTurtleRocksNight2To3Rooms; `LevelRooms_c24d3` SeaTurtleRocksNight4Rooms; `LevelRooms_c2597` DesertRuinsDay1To4Rooms; `LevelRooms_c267b` DesertRuinsNight1To4Rooms; `LevelRooms_c275f` TheVolcanosBaseDay1To2Rooms; `LevelRooms_c283b` TheVolcanosBaseDay3To4Rooms; `LevelRooms_c2917` TheVolcanosBaseNight1To2Rooms; `LevelRooms_c29f3` TheVolcanosBaseNight3To4Rooms; `LevelRooms_c2acf` ThePoolOfRainDay1To3Rooms; `LevelRooms_c2b8b` ThePoolOfRainDay4Rooms; `LevelRooms_c2c47` ThePoolOfRainNight1To3Rooms; `LevelRooms_c2d03` ThePoolOfRainNight4Rooms; `LevelRooms_c2dbf` ATownInChaosDay1To3Rooms; `LevelRooms_c2eab` ATownInChaosDay4Rooms; `LevelRooms_c2f97` ATownInChaosNight1To3Rooms; `LevelRooms_c3083` ATownInChaosNight4Rooms; `LevelRooms_c316f` BeneathTheWavesDay1To2Rooms; `LevelRooms_c325b` BeneathTheWavesDay3Rooms; `LevelRooms_c3347` BeneathTheWavesDay4Rooms; `LevelRooms_c3433` BeneathTheWavesNight1To2Rooms; `LevelRooms_c351f` BeneathTheWavesNight3Rooms; `LevelRooms_c360b` BeneathTheWavesNight4Rooms; `LevelRooms_c36f7` TheWestCraterDay1To2Rooms; `LevelRooms_c3783` TheWestCraterDay3Rooms; `LevelRooms_c380f` TheWestCraterDay4Rooms; `LevelRooms_c389b` TheWestCraterNight1To2Rooms; `LevelRooms_c3927` TheWestCraterNight3Rooms; `LevelRooms_c39b3` TheWestCraterNight4Rooms; `LevelRooms_c3a3f` TheGrasslandsDay1Rooms; `LevelRooms_c3b2b` TheGrasslandsDay2Rooms; `LevelRooms_c3c17` TheGrasslandsDay3To4Rooms; `LevelRooms_c4000` TheGrasslandsNight1Rooms; `LevelRooms_c40ec` TheGrasslandsNight2Rooms; `LevelRooms_c41d8` TheGrasslandsNight3To4Rooms; `LevelRooms_c42c4` TheBigBridgeDay1To3Rooms; `LevelRooms_c4360` TheBigBridgeDay4Rooms; `LevelRooms_c43fc` TheBigBridgeNight1To3Rooms; `LevelRooms_c4498` TheBigBridgeNight4Rooms; `LevelRooms_c4534` TowerOfRevivalDay1Rooms; `LevelRooms_c45e8` TowerOfRevivalDay2Rooms; `LevelRooms_c469c` TowerOfRevivalDay3Rooms; `LevelRooms_c4750` TowerOfRevivalDay4Rooms; `LevelRooms_c4804` TowerOfRevivalNight1Rooms; `LevelRooms_c48b8` TowerOfRevivalNight2Rooms; `LevelRooms_c496c` TowerOfRevivalNight3Rooms; `LevelRooms_c4a20` TowerOfRevivalNight4Rooms; `LevelRooms_c4ad4` TheSteepCanyonDay1To3Rooms; `LevelRooms_c4b80` TheSteepCanyonDay4Rooms; `LevelRooms_c4c2c` TheSteepCanyonNight1To3Rooms; `LevelRooms_c4cd8` TheSteepCanyonNight4Rooms; `LevelRooms_c4d84` CaveOfFlames1To2Rooms; `LevelRooms_c4e58` CaveOfFlames3Rooms; `LevelRooms_c4f2c` CaveOfFlames4Rooms; `LevelRooms_c5000` AboveTheCloudsDay1To2Rooms; `LevelRooms_c50c4` AboveTheCloudsDay3To4Rooms; `LevelRooms_c5188` AboveTheCloudsNight1To2Rooms; `LevelRooms_c524c` AboveTheCloudsNight3To4Rooms; `LevelRooms_c5310` TheStagnantSwampDay1To3Rooms; `LevelRooms_c53c4` TheStagnantSwampDay4Rooms; `LevelRooms_c5478` TheStagnantSwampNight1To3Rooms; `LevelRooms_c552c` TheStagnantSwampNight4Rooms; `LevelRooms_c55e0` TheFrigidSeaDay1To2Rooms; `LevelRooms_c56ac` TheFrigidSeaDay3To4Rooms; `LevelRooms_c5778` TheFrigidSeaNight1To2Rooms; `LevelRooms_c5844` TheFrigidSeaNight3To4Rooms; `LevelRooms_c5910` CastleOfIllusionsDay1To3Rooms; `LevelRooms_c59f4` CastleOfIllusionsDay4Rooms; `LevelRooms_c5ad8` CastleOfIllusionsNight1To3Rooms; `LevelRooms_c5bbc` CastleOfIllusionsNight4Rooms; `LevelRooms_c5ca0` TheColossalHoleDay1To3Rooms; `LevelRooms_c5d5c` TheColossalHoleDay4Rooms; `LevelRooms_c5e18` TheColossalHoleNight1To3Rooms; `LevelRooms_c5ed4` TheColossalHoleNight4Rooms; `LevelRooms_c5f90` TheWarpedVoid1Rooms; `LevelRooms_c605c` TheWarpedVoid2To3Rooms; `LevelRooms_c6128` TheWarpedVoid4Rooms; `LevelRooms_c61f4` TheEastCraterDay1Rooms; `LevelRooms_c6298` TheEastCraterDay2Rooms; `LevelRooms_c633c` TheEastCraterDay3Rooms; `LevelRooms_c63e0` TheEastCraterDay4Rooms; `LevelRooms_c6484` TheEastCraterNight1Rooms; `LevelRooms_c6528` TheEastCraterNight2Rooms; `LevelRooms_c65cc` TheEastCraterNight3Rooms; `LevelRooms_c6670` TheEastCraterNight4Rooms; `LevelRooms_c6714` ForestOfFearDay1To2Rooms; `LevelRooms_c67a8` ForestOfFearDay3Rooms; `LevelRooms_c683c` ForestOfFearDay4Rooms; `LevelRooms_c68d0` ForestOfFearNight1To2Rooms; `LevelRooms_c6964` ForestOfFearNight3Rooms; `LevelRooms_c69f8` ForestOfFearNight4Rooms; `LevelRooms_c6a8c` TheTempleRooms

#### Framesets, OAM, other palettes and `Data_`

Counted by script: 1531 of the 1954 `Frameset_`, 130 of 197 `OAM_`, 284 of
345 `Pals_` and 117 of 187 `Data_` are referenced from exactly one file
other than the one defining them (the rest from several files, or only
from their own data file, e.g. inside frameset tables). The biggest
"owners" are overworld scene code (bank27: 149 framesets, 68 palettes, 40
OAM; bank2d: 132 framesets; bank2b_1: 92), Wario's state code
(wario_states_1..4: 221 framesets), `object_params.asm` (54) and the
object files (anonster 35, shoot 35, pesce 34, ...). A safe first bulk step
is an owner prefix that keeps the address (`Frameset_68a00` ->
`ApplebyFrameset_68a00`, `Pals_4d07b` -> `HiddenFigurePals` where read),
leaving descriptive names to the per-object passes (Hidden Figure's tables
above are an example). Medium value; not generated here.
| jamano.asm (`JamanoFunc`) | `.Func_54d7d` -> `.Intro`; `.Func_54daa` -> `.StartFight`; `.Func_54e10` -> `.Main`; `.Func_54e0a` -> `.Frozen`; `.Func_54ee4` -> `.SetVerticalDirToWario`; `.Func_54f55` -> `.TurnToWario`; `.Func_54f9d` -> `.MoveToCentre`; `.Func_5507b` / `.Func_55097` -> `.DefeatPose1` / `.DefeatPose2`; `.Func_550b3` -> `.LoseHat`; `.Func_550db` / `.Func_550ff` -> `.StartFalling` / `.Fall`; `Func_55407.Func_5548b` -> `.AlertJamano` | `.Intro`: waits $ff frames (`MUSIC_BOSS_REVEAL` at $c0). `.StartFight`: `BOSS_REGULAR`, clears `w1d149`, faces Wario. `.Main` blinks and, while the room is dark (`wDollBoyHammerRange` != 0, see `w1d147`), floats around (states $5a/$5b, `Data_60c80`/`Data_60c20`), turning to Wario (`SFX_0BC`); hit in another state it freezes (`.Frozen`, music stopped). When every skull has been knocked away (the darkness step, which follows `w1d147`, back to 0; the skulls settle during the intro) it becomes visible, moves to screen X $58 and plays the defeat: two poses, spawns `ObjParams_JamanoHat` (`JamanoHatFunc` flies up, then `BOSS_DEFEATED`), falls along `Data_60d20`. `.AlertJamano` finds the active Jamano object when the darkness changes. | medium (low for `.Frozen` and `.AlertJamano`) |
| jamano.asm (hat, platform, skulls) | `JamanoHatFunc.Func_55125` -> `.FlyAway`; `HatPlatformFunc.Func_55194` -> `.Update`; `SkullSpawnerFunc.Func_5522c` -> `.Update`; `SkullFunc.Func_5529f` / `.Func_552ba` -> `.Wait` / `.WaitToFly`; `.Func_552d4` -> `.FlyToEdge`; `.Func_5531c` -> `.Settle`; `.Func_55347` -> `.InPlace`; `.Func_55396` / `.Func_553a0` -> `.KnockedRight` / `.KnockedLeft`; `.Func_553e8` -> `.Blink` | The hat flies up while on screen, then despawns and ends the fight. The hat platform is a one-way platform that sinks with Wario on it and rises back. The spawner re-creates missing skulls while `w1d149`/darkness allow (`Func_55407` updates the darkness). A skull waits, flies to its screen edge (`Data_60ce0`/`Data_60d00`), increments `w1d147`, settles, and when attacked (`OBJSTATE_ATTACKED_*_START`) decrements it and is knocked away with `Func_3317`/`Func_3326` (`ObjState_AttackedRight/Left`) while on screen, then deactivates its `JAMANO_SKULL*` bit. `.Blink` toggles visibility while the skulls are inactive. | medium |
| pesce.asm | `StrongWaterCurrentFunc.Func_51d2d` -> `.DoNothing`; `PesceFunc.Func_51e28` -> `.Update`; `.Func_521a5` -> `.FindBait`; `.Func_521d0` -> `.Defeated`; `DragonflySpawnerFunc.Func_52282` / `.Func_5229a` / `.Func_522d9` -> `.Wait` / `.SpawnDragonfly` / `.WaitForFightEnd`; `Dragonfly1Func.Func_52321` / `.Func_5233b` -> `.Descend` / `.Fly`; `Dragonfly2Func.Func_523f2` / `.Func_5240f` / `.Func_523b1` -> `.WaitToAppear` / `.Fly` / `.FlyAway`; `FlySpawnerFunc.Func_52475` / `.Func_52497` / `.Func_524eb` -> `.WaitOnScreen` / `.SpawnFly` / `.WaitForFightEnd`; `FlyFunc.Func_52533` -> `.Update` | Pesce counts hits in `w1d147` (wobble states: +1, a smaller collision box each time, `SFX_0BB`); the third hit switches to `.Defeated` (`OBJ_INTERACTION_51`, music stops): it sinks, swims left to a wall, marks the object map (`Func_ba42`) and sets `wDollBoyHammerRange = 1`. The spawners wait for that byte to end the fight (`BOSS_DEFEATED`, `wSwitchState = $60`) and despawn. `.FindBait` scans for an active object with ID >= `CHEESE` and reads its position. The dragonflies are one-way platforms (carry Wario with `MoveWarioDown`); a fly sets `wDollBoyActiveBarrels` while present so only one is spawned. So Pesce's union bytes are: 0 = fly present, 1 = hits, 2 = fight over (`wPesceFlyActive`, `wPesceHits`, `wPesceFightOver` in a `NEXTU`). | medium |
| yellow_belly.asm (body) | `.Func_5139d` / `.Func_513bf` / `.Func_513d9` -> `.IntroFade1` / `.IntroFade2` / `.IntroFade3`; `.Func_513fb` -> `.StartFight`; `.Func_51419` -> `.RiseAndSpawnHead`; `.Func_514a4` -> `.ShootArrows`; `.asm_5179a` -> `.hit`; `.Func_517ee` -> `.HitFlash` | The intro steps load `Pals_51c81`, `Pals_51c99`, `Pals_51cb1` into OB palettes 4-7 every 30 frames (`SFX_0CA`), then `BOSS_REGULAR`; it rises slowly and creates `ObjParams_YellowBellyHead`. `.ShootArrows` spawns `ObjParams_YellowBellyArrowLeft/Right` at a fixed timer value (`SFX_07C`). Every phase checks `w1d147` first and goes to `.hit` (`DecrementRemainingBossHits`), which flashes `Pals_51ce1`. | medium |
| yellow_belly.asm (body, unclear) | `.Func_51652`, `.Func_515dd`, `.Func_51572`, `.Func_5178c`, `.Func_5184a` | Movement phases; `.Func_515dd`/`.Func_5184a` run while `wDollBoyHammerRange` is set, which `.asm_5154e` sets and Puffy Wario clears; `.Func_51572` plays `SFX_VANISH`/`SFX_0A9`/`SFX_0A5` at fixed counter values; `.Func_5178c` sinks until screen X < $c8. Not named. | - |
| yellow_belly.asm (others) | `PumpFunc.Func_518c6` / `.Func_51947` -> `.Fall` / `.OnFloor`; `YellowBellyArrowFunc.Func_51a7d` / `.Func_51ad9` -> `.FlyLeft` / `.FlyRight`, `.Func_51aaa` / `.Func_51b34` -> `.KnockedAwayRight` / `.KnockedAwayLeft`, `.Func_51b16` -> `.WaitAndDespawn`, `.Func_51b4b` -> `.CheckPastWario`; `YellowBellyHeadFunc.Func_51b7b` -> `.Update`; `YellowBellyPlatformFunc.Func_51c3f` -> `.WaitForDefeat`; `Func_51c77` -> `YellowBellyPlatform_WaitAndDespawn` | The pump falls (`Data_609e0`) until it lands, then reacts to Wario; on `OBJSTATE_VANISH_TOUCH` it sets its state and `w1d147` to $3a (yellow_belly.asm:959), which is what makes the body take a hit. Arrows fly sideways (faster while `wDollBoyHammerRange` is 0), and when hit by a thrown object (`OBJSTATE_28/29`) fly up and away and despawn above Y $40. The platform waits for `OBJSTATE_SPECIAL_3`, then `BOSS_DEFEATED` and despawns after $5a frames (`Func_51c77`). | medium |
| shoot.asm | `ShootFunc.Func_56cdb` -> `.MoveBetweenWalls`; `GKTortoiseFunc`: `.Func_56f27` -> `.Idle` (`GKTORTOISEPHASE_0`), `.Func_56f2e` -> `.Guard` (1), `.Func_56fef` -> `.Phase2`, `.Func_57021` -> `.Phase3`, `.Func_5707b` -> `.KickWarioBall` (4), `.Func_57039` -> `.CatchWarioBall` (5), `.Func_57198` -> `.ThrowShootBall` (6), `.Func_56edd` -> `.Defeated` (8), `.Func_5710f` -> `.CatchShootBall` (9), `.Func_57170` -> `.FindShoot`; `Func_5725b` -> `UnreferencedMoveWarioUpByNegB` | The GK Tortoise phases are its `wCurObjVar1` jumptable (commented with `GKTORTOISEPHASE_*`; `GKTORTOISEPHASE_DUCKING` already has `.Ducking`). Phase 5 places Wario on it at frames 2/4 (`.set_wario_pos_22y`), phase 9 places Shoot the same way (`.set_shoot_pos_22y`), phase 4 ends in the defeat frameset when `wWarioGoals == NUM_WARIO_GOALS_NEEDED`, phase 6 sets `wShootBallState = 1` and releases `wAutoMoveState`, phase 8 waits, marks the object map and sets `BOSS_DEFEATED`. Shoot's `.MoveBetweenWalls` bounces between X 27 and 219 and sets `wShootCanTurnAround`. Names for phases 2/3 left neutral (they wait on frameset offsets and return to phase 1). | medium (low for 4/6) |
| scowler.asm | `ScowlerFunc.Func_54520` -> `.StartFight`; `.Func_5458a` -> `.Main`; `.Func_54542` -> `.CatchWario`; `.Func_5469d` -> `.Fall`; `.Func_5487d` -> `.Recover`; `.Func_5490b` -> `.DefeatedSink`; `.Func_54931` -> `.Defeated`; `FloatingRingSpawnerFunc.Func_54997` / `.Func_549ab` -> `.WaitAndSpawn` / `.DoNothing`; `FloatingRingFunc.Func_549c7` / `.Func_549ee` / `.Func_54a02` / `.Func_54a2d` -> `.Rise` / `.WaitForWario` / `.RiseWithWario` / `.Return`; `InkFunc.Func_54bf8` -> `.WaitAndDespawn`; `Func_54c07` -> `UpdateScowlerInkBlackout` | `.StartFight`: `BOSS_REGULAR`, creates both `ObjParams_ScrowlerTentacle*`. `.CatchWario` keeps Wario at Scowler's position after a room transition was triggered. `.Recover` restores `OBJ_INTERACTION_SCOWLER`. The defeat sinks swaying (`Data_60a80`) for $b4 frames, then `Func_ba42` and `BOSS_DEFEATED`. Floating rings rise, wait to be stepped on, carry Wario up (`MoveWarioUp`) and go back to the Y saved in `OBJ_VAR_2`. `Func_54c07` runs every Scowler frame: while `w1d147` (ink timer) is non-zero it counts up, flashes `Pals_54c9f`/`Pals_54cf7` (`SFX_0B5`/`SFX_0B7`), blacks the screen out at $3c for $ff frames (countdown in `wDollBoyActiveBarrels`, `SFX_0B6`) and restores the palettes at $78 (`SFX_0B8`). Not named: `.Func_546bd`, `.Func_546e0`, `.Func_54770`, `.Func_54806`, `.Func_54853`, `.Func_548c5` (probes and movement in the fight's middle phases), `ScrowlerTentacleFunc.Func_54a97`. | medium |
| muddee.asm | `MuddeeFunc.Func_5564e` -> `.WaitForAmbush`; `.Func_55676` -> `.Appear`; `.Func_55696` -> `.WaitForWarioNear`; `.Func_556f0` -> `.Leap`; `.Func_55711` -> `.Main`; `.Func_55bd8` -> `.PlayBubbleSFX`; `.Func_55c11` -> `.SetFramesetAndDurations`; `.Func_55c1e` -> `.CompareYWithWario`; `.Func_55c2b` -> `.CompareYWithWarioRow`; `.Func_55c3a` -> `.Blink`; `Turtle1Func.Func_55c7d` / `.Func_55c91` / `.Func_55cdd` / `.Func_55cf9` / `.Func_55d18` / `.Func_55d4c` -> `.WaitForWario` / `.CarryWario` / `.StartAmbush` / `.Submerge` / `.WaitForMuddeeDefeat` / `.Resurface`; `TurtleCommonFunc.Func_55d90` / `.Func_55de0` -> `.CarryWario` / `.Idle`; `Func_55e33` -> `PlayTurtleSwimSFX` | Muddee blinks hidden until `wMuddeeAmbushState == 1`, which the first turtle sets when it has carried Wario across (one-way platform, `MoveWarioRight` + `Func_19706`), before submerging; the turtle resurfaces when Muddee's defeat sets the state to 2 (muddee.asm:302, after `Func_ba42` and `stop_music2`) and ends the fight (`BOSS_DEFEATED`). The other turtle carries Wario right until a wall and then stays. `.Main` sets the front interaction ($46/$47) from the animation frame and dispatches on `w1d147`/`wCurObjVar1`; `.SetFramesetAndDurations` writes `de` to the frameset pointer and `c`/`b` to the next two fields; the two compares return carry from the screen Y (the second in 8 px rows, 16 px above Wario). `Func_55e33` plays `SFX_084` on frame 4. Not named: the nine `wCurObjVar1` phases `.Func_55861`..`.Func_55ad9`, `.Func_55ba7`, `.Func_55be7`. | medium |
| omodonmeka.asm | `OmodonmekaFunc.Func_42218` -> `.Update`; `.Func_42199` -> `.Activate`; `.Func_42432` -> `.ResetToIdle`; `.Func_42321` -> `.Hover`; `.Func_423e1` -> `.Fall`; `.Func_42420` -> `.ReturnToStartY` | `.Update` reacts to its state (`OBJSTATE_ACTIVATE` -> `.Activate`, attacked/hit-by-object states) and otherwise dispatches on the substate's low nybble (steps 0-8). Step 0/1 hovers (`Data_604c0`) and watches Wario; step 2 falls along `Data_60500` until `Func_352b` finds floor; step 3 moves up to the Y saved in `OBJ_VAR_1/2` at spawn, then `.ResetToIdle` (step 1, `Frameset_68f0b`). Steps 4-8 (`.Func_4244c`, `.Func_42291`, `.Func_422fc`, `.Func_42261`, `.Func_42369`), the `OmodonmekaWithOmodon*` locals and `Func_42725`..`Func_4279c` (they look for objects sharing `OBJ_UNK_01`, the object-map pointer, i.e. the Omodon that rides it) are not named. | medium |
| anonster.asm | `AnonsterFunc.Func_50024` -> `.StartFight`; `AnonsterSilkFunc` state table (mechanical, Phase 6 rules): `.Func_509ab` -> `.State00`, `.Func_50898` -> `.Default`, `.Func_50a01` / `.Func_50a0b` -> `.AttackedLeftStart` / `.AttackedRightStart`, `.Func_50a1e` / `.Func_50a31` -> `.PickedUpLeftStart` / `.PickedUpRightStart`, `.Func_50a79` -> `.State12`, `.Func_50995` / `.Func_5099d` -> `.State14` / `.State15`, `.Func_50a5e` / `.Func_50a44` -> `.State18` / `.State19`, `.Func_509ef` / `.Func_509dd` -> `.State28` / `.State29`, `.Func_509bb` -> `.State3f`, `.Func_50a68` / `.Func_50a4e` -> `.State48` / `.State49` | `.StartFight` sets `BOSS_REGULAR` when its timer ends. `AnonsterSilkFunc` (anonster.asm:1244) has a 90-entry positional `OBJSTATE_*` table that the first pass's list of 16 objects missed; generated with the same rules. The 20-odd `AnonsterFunc` phases (`.Func_5005e`..`.Func_50705`) and `.Func_508be`/`.Func_508cd` are not named. | medium |

### Addenda

#### More union mislabels (same kind as the wrong-bank table above)

(Applied in batch 14.)

| Where | Written as | Actually | Evidence | Conf. |
|---|---|---|---|---|
| src/engine/overworld/bank2b_2.asm:2423-2427 (`_InitEpilogue` area) | `ld hl, wOWUIObj1YCoord` ($60, then $5c), `ld [wOWUIObj2YCoord], a` ($ff) | `wSceneWarioYCoord` / `wSceneWarioXCoord` / `wSceneWarioStateGroup` = `SCENEWARIO_GROUP_NONE` | `wOWUIObj1/2` share a `UNION` with `wSceneWario` ($d140/$d148 in the sym file), the epilogue update calls `UpdateSceneWario`, and $ff is `SCENEWARIO_GROUP_NONE`. Exactly the bank2b_1.asm:1821 case. The other bank2b_2 reads of `wOWUIObj1YCoord`/`XCoord` (:2633, :2719, :3017, :3091, :3128, :3288) position scene objects relative to it, so they are Scene Wario's coordinates too. | high |
| src/engine/overworld/bank2d.asm:3529-3559, 4016-4043, 4175-4228, 4388-4419 | `wOWUIObj1YCoord` | a scene step/flag byte | Map-side scenes store small step values (1, 4, 5, 0) in it and wait on them (`.Func_b5949`..`.Func_b598c` of the freeze-sea scene, `.Func_b5f50`); nothing there uses it as a coordinate. Needs a scene alias. | medium |

#### Phase 7, one more helper

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_ae915` | src/engine/overworld/bank2b_2.asm:1511 | `AdvanceStepAtHL` | `xor a / ld [hld], a / inc [hl]`: clears the counter at `hl` and increments the step byte before it; used with `w2d8a1` and the `wPlanePart*Counter` fields (12 references). | high |

## Third pass

Same conventions as above. Labels are the current master labels (the
earlier proposals are being applied on another branch, so a row here may
mention a label that an earlier row already renames). New global names were
checked with a script against `src/` and against everything above (no
collisions, no duplicates).

### 3a. Phase 7: overworld routines with 4-8 references

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_b69a6` | src/engine/overworld/bank2d.asm:5906 | `FillPalsWithFlashColour` | Writes the colour $739c (VC build: $294a, `vc_patch FPA_80_BG_Flash_Palette_1_*`) to `b` colours at `hl`. Used by the canyon-thunder scene's lightning flash (`.Func_b5e10`, `.flash2_pal`) and by the flash at bank2d.asm:5893. Note `b` counts colours, so the callers' `ld b, 3 palettes` / `ld b, 4 palettes` are really 24 / 32 colours (palettes 0-5 / all 8): the operands are spelled misleadingly (`.Func_b5e10` copies palette 6 back right after, which only makes sense with 0-5 flashed). | high |
| `Func_85a91` | src/engine/overworld/bank21.asm:1925 | `AddTilemapRowToPtrAtDE` | Adds $20 to the little-endian pointer at `de` and leaves `de` past it; always called twice in a row to move both the destination and the source pointer one tilemap row down. | high |
| `Func_85a68` / `Func_85aa2` / `Func_85acb` | bank21.asm:1896 / 1942 / 1971 | `CopyOWTileColumn1` / `CopyOWTileColumn2` / `CopyOWTileColumn3` | Copy a column of tiles, one per row, from a 32-wide source (attributes $a0 bytes after the tiles) into `wTilemap`, and the attribute $300 bytes lower (`wAttrmap`); row count, destination and source come from the `wOWUIObj1` / `wOWUIObj2` / `w2d150` blocks (borrowed as scratch). Only callers: the freeze-sea scene (`EOWFunc_FreezeSea.Func_b6fae`/`.Func_b6ffe`/`.Func_b7056`, which read the next column from a $80-terminated list every 5 frames and set `wOWPendingTileUpdate`). | medium |
| `Func_b71fc` | bank2d.asm:7170 | `UpdateOWSceneScreenShake` | Called first thing every frame by the map-side scenes with quakes (`NOWFunc_Prologue`, `WOWFunc_Earthquake`, `WOWFunc_VulcanoEruption`, `SOWFunc_Earthquake`, `EOWFunc_Earthquake`, `EOWFunc_VulcanoEruption`). `wOWUIObj1YCoord` is a request/state (0 off; 1 starts the script at step $01, 4 (once step $01 comes round again) and 6 at step $11, 8 at $15, 10 at $1e; each start moves to the next state, which waits for a given step and clears the request), `wOWUIObj1Frame` the current script step and `wOWUIObj1Attributes` its frame counter; `.Func_b7273` runs the script, a 38-entry jumptable of `wSCY`/`wSCX` nudges (+-1, +-2, +-4) held 1 or 3 frames, with `SFX_01F` / `SFX_063` on some steps. Locals: `.Func_b7273` -> `.RunShakeScript`, `.asm_b7304` -> `.next_step`. | medium |
| `wOWUIObj1YCoord` / `wOWUIObj1Frame` / `wOWUIObj1Attributes` in map-side scenes | src/ram/wram.asm | scene aliases `wOWSceneShakeState` / `wOWSceneShakeStep` / `wOWSceneShakeCounter` | See `Func_b71fc`. This explains the Addenda row "bank2d.asm:3529-3559, 4016-4043, 4175-4228, 4388-4419 ... a scene step/flag byte": the scenes request a shake (1, 4) and wait for the state to reach 5 or 0. Correction to that row: lines 3529-3559 are in `NOWFunc_Prologue`, not the freeze-sea scene. | medium |
| `Func_b7984` / `Func_b7a6d` / `Func_b7c18` / `Func_b7b61` | bank2d.asm:8344 / 8480 / 8736 / 8627 | `UpdateNorthOWObjMapAnim` / `UpdateWestOWObjMapAnim` / `UpdateSouthOWObjMapAnim` / `UpdateEastOWObjMapAnim` | Called by the existing `UpdateMapSideOWAnimations` for a fixed set of scene objects per side (`bc` = state byte); each dispatches on the object's state into a per-side table (44 / 36 / 33 / 35 entries) that is `Func_b791d` (`ret`) except for the few states with idle behaviour: the north leaves (`Func_b542e`), the tornado (`Func_b7ab7` -> `UpdateOWTornado`), day/night switches of objects 14/15 (`.Func_b79fa`..`.Func_b7a24`). The east table has 35 entries while `Func_b4ba2` handles 36 states (state $23 would read past it, if one of the two east objects passed here can have it; not checked). | high |
| `Func_b7984.Func_b79fa` / `.Func_b7a08` / `.Func_b7a16` / `.Func_b7a24` | bank2d.asm:8403-8430 | `.Obj15WaitForDay` / `.Obj15WaitForNight` / `.Obj14WaitForDay` / `.Obj14WaitForNight` | States $18/$19 (obj 15) and $1a/$1b (obj 14): when `w2d011` (night) no longer matches, set the transition state ($17/$16, $1b/$1a). `Func_b403e.Func_b4055` sets the same states at init from `w2d011`. | medium |
| `Func_b542e` | bank2d.asm:2818 | `UpdateNorthLeaves` | North map-side states $10-$13 (`Func_b7984`). Two copies of a 6-step loop for scene objects 6 and 7 (`w2d12c`/`w2d12d` and `w2d12e`/`w2d12f`, set up by `Func_b40ff`, the `NOWFUNC_FALL_LEAVES` init): wait $78 frames, state $12, wait $5a, state $13, wait $28, state $10 at Y $38, wait $5a, sink 1 px every 16 frames to Y $48, wait for the frameset to end, state $11 and restart. Locals: `.Func_b5435` / `.Func_b54ba` -> `.UpdateLeaf1` / `.UpdateLeaf2`. | medium |
| `Func_b5114` | bank2d.asm:2380 | `AnimateNorthOWObj2` | North's second sprite set, exactly like the second-pass `AnimateWestOWObj2` family: `UpdateCurOWObjAnimation`, then `LoadCurSceneObjSpriteWithScroll` with `OAM_a9fe2`. Locals: `.asm_b5117` -> `.draw`, `.asm_b5122` -> `.set_state_when_finished` (entered by `Func_b50fb`/`Func_b510a` with the next state in `b`). The 2 instructions between `jp LoadCurSceneObjSpriteWithScroll` and `.asm_b5122` have no label and no reference: the unreferenced "Once" variant (`UnreferencedAnimateWestOWObj2Once` in the second pass). | high |
| `Func_b4143` | bank2d.asm:204 | `InitNOWObjects_Crayon` | Shared tail of the 7 crayon entries of `InitOWObjects_North` (see rule 4 below): if the crayon is newly unlocked (`sla c` carry), places scene objects 5 and 1 and stores `b` (0-3, set by each colour's entry) as object 5's attributes (palette). | high |
| `Func_9a78e` | bank26.asm:652 | `CollectionRowColToCoords` | Replaces the row/column at `de` with the cell's screen Y/X (same tables as `GetCollectionCellCoords`); used for the 7 linked-cell markers. In the caller: `ProcessCollectionLinkState.Func_9a806` -> `.PlaceLinkedCellMarkers`, `.Func_9a8d8` -> `.set_marker_state`. (The caller addresses objects 4-7 as `wSceneObj3End`..`wSceneObj6End`, i.e. "end of the previous object"; `wSceneObj4`.. would read better.) | high |
| `Func_9fb53` | bank27.asm:7475 | `DrawCutsceneOverlay` | When `wSceneObj1YCoord == b`, copies Y/X of the scene object at `de` into the 4 bytes at `hl` (a spare object slot, `wCurSceneObj` or `wCurSceneObjDuration`), sets frame `c`, and draws it with `OAM_bc000` (Overworld OAM 2). The source comment says "b = y coord"; it is compared with `wSceneObj1YCoord`, which cutscenes set to 1/2/3 to choose which overlay frames apply (next row). | high |
| `wSceneObj1YCoord` in bank27 cutscenes | src/ram/wram.asm | cutscene alias `wCutsceneOverlayType` | Written only as 1, 2 or 3 by the cutscene set-up steps (bank27.asm:1629, 2004, 2462, 5584, ...), read only by `Func_9fb53`/`Func_9fb87`. | medium |
| `Func_9fb61` | :7490 | `LoadCutsceneOverlaySprite` | `hl &= ~3`, `LoadCutsceneObjSprite_OWOAM2` (`Func_9f0bc`) with `OAM_bc000`. | high |
| `Func_9fb4c`, `Func_9fb6c`, `Func_9fb75`, `Func_9fb7e`, `Func_9fb87`, `Func_9fb97`, `Func_9fba0` | :7467-7539 | `DrawCutsceneOverlayFrame0` .. `DrawCutsceneOverlayFrame6` (in this order) | Fix the frame (0-6) and type (1 for frames 0-3, 2 for frame 4, 3 for frames 5-6) for `Func_9fb53`; `Func_9fb87` draws frame 4 without copying a position. Frames 0/2 and 1/3 are mirror images and frame 4 is 0+1+2+3 together; the updaters draw frame 0 before the object and frame 1 after it, i.e. behind and in front of it (music boxes, the seed bag). | high |

### 3b. bank27: per-cutscene step tables and object updaters (bulk rules)

Every `CutsceneXXFunc` in bank27.asm (table at bank27.asm:1250, commented
with its `EVENT_*`) is `call .<steps> / jp <updater>`; a few also `call` a
second updater. Cutscene02 (`.PlayCutscene` / `OWCutTree`) and Cutscene03
(`.PlayCutscene`) are already named. Checked by script over all 48 entries.

**Rule 1: step tables.** The local called first is the `w2d013` jumptable
(some run per-frame helpers before the `jumptable`): `.PlayCutscene`, as
in Cutscene02/03. 40 labels (Cutscene0e/11 and 15/49 share one): `Cutscene06Func.Func_9d033`, `Cutscene0aFunc.Func_9d114`, `Cutscene07Func.Func_9d191`, `Cutscene19Func.Func_9d285`, `Cutscene11Func.Func_9d340`, `Cutscene1bFunc.Func_9d44a`, `Cutscene1eFunc.Func_9d56f`, `Cutscene22Func.Func_9d5dd`, `Cutscene27Func.Func_9d664`, `Cutscene09Func.Func_9d6aa`, `Func_9d6f0.Func_9d6f6`, `Cutscene0cFunc.Func_9d834`, `Cutscene18Func.Func_9d86f`, `Cutscene0dFunc.Func_9d8bb`, `Cutscene13Func.Func_9d98b`, `Cutscene49Func.Func_9da37`, `Cutscene04Func.Func_9db09`, `Cutscene24Func.Func_9db9e`, `Cutscene1fFunc.Func_9dc83`, `Cutscene21Func.Func_9dd09`, `Cutscene37Func.Func_9de0d`, `Cutscene38Func.Func_9de4e`, `Cutscene30Func.Func_9df15`, `Cutscene39Func.Func_9dfd3`, `Cutscene3aFunc.Func_9e04c`, `Cutscene3cFunc.Func_9e177`, `Cutscene43Func.Func_9e262`, `Cutscene54Func.Func_9e2d7`, `Cutscene3dFunc.Func_9e350`, `Cutscene4aFunc.Func_9e457`, `Cutscene4cFunc.Func_9e4d8`, `Cutscene4eFunc.Func_9e552`, `Cutscene4fFunc.Func_9e5c0`, `Cutscene51Func.Func_9e674`, `Cutscene56Func.Func_9e703`, `Cutscene57Func.Func_9e7b9`, `Cutscene58Func.Func_9e87a`, `Cutscene55Func.Func_9e965`, `Cutscene44Func.Func_9ead3`, `Cutscene14Func.Func_9ec73`. High.

`Func_9d6f0` (bank27.asm:2495), entered by `Cutscene08/10/17/1d/25Func`
with `b` = 1/3/5/7/9: `MusicBoxCutsceneFunc`. The music box (scene object 2,
state `b`) rises from Y 176 to $62 (`PlaySFX_112` at $88), switches to state
`b+1` and plays that box's tune (`SFX_11E`..`SFX_122`). High.

**Rule 2: object updaters.** The `jp` target animates the cutscene's scene
objects: for each object (state 0 = inactive) `Func_9f0a5` picks the
frameset from a local `.framesets` table, `Func_9f0ae`/`Func_9f0b5`
animates, some states change on animation end (`Func_9f0d0`), and
`Func_9f0bc`..`Func_9f0cb` draws with one OAM table. Name:
`UpdateCutsceneObjs_<Event>`. The extra updaters that draw a level
object's sprite (`Func_9f0b5` + Objects OAM 1/3/4) get
`UpdateCutsceneLevelObj_<Event>` (the object, from the frameset's other
user, in brackets). High for the rule; the event names come from the table.

`Func_9f0e0` UpdateCutsceneObjs_OpenNorthGate; `Func_9f11e` UpdateCutsceneObjs_Rainstorm; `Func_9f146` UpdateCutsceneObjs_RaiseTower; `Func_9f174` UpdateCutsceneObjs_FixElevator; `Func_9f1d8` UpdateCutsceneObjs_RevealCastle; `Func_9f1f3` UpdateCutsceneObjs_FreezeSea (also used by SUMMON_LIGHTNING, which shares the step table, and PURIFY_WATER; medium); `Func_9f225` UpdateCutsceneObjs_SummonSun; `Func_9f244` UpdateCutsceneLevelObj_SummonSun (owl, `SFX_FLAP`); `Func_9f2a2` UpdateCutsceneObjs_ExplodeBombs; `Func_9f2cd` UpdateCutsceneObjs_TreasureMap; `Func_9f2f3` UpdateCutsceneObjs_PlaceCartWheels (draws the cart's level-object sprite only); `Func_9fbfa` UpdateCutsceneObjs_PlantSeeds; `Func_9fc1d` UpdateCutsceneObjs_MusicBox; `Func_9f323` UpdateCutsceneObjs_BlowMist; `Func_9f340` UpdateCutsceneObjs_SummonSnakes; `Func_9f367` UpdateCutsceneObjs_FootStone; `Func_9f38d` UpdateCutsceneObjs_OpenSnakeDoor (blue and golden); `Func_9f3cd` UpdateCutsceneObjs_ExpelTornado; `Func_9f3ee` UpdateCutsceneObjs_OpenTreeMouth; `Func_9f423` UpdateCutsceneObjs_LeavesFall; `Func_9f49c` UpdateCutsceneObjs_MakeWire; `Func_9f508` UpdateCutsceneObjs_TorchForest; `Func_9f547` UpdateCutsceneObjs_RevealWarpedVoid; `Func_9f5a0` UpdateCutsceneObjs_RaiseIceBlocks; `Func_9f607` UpdateCutsceneObjs_RaisePipe; `Func_9f638` UpdateCutsceneObjs_RemoveWarps; `Func_9f6a2` UpdateCutsceneObjs_CollectDemonsBlood; `Func_9f6f8` UpdateCutsceneObjs_PlacePropeller; `Func_9f73b` UpdateCutsceneObjs_CutBaloon; `Func_9f75c` UpdateCutsceneObjs_OpenParaGoomCage; `Func_9f7a2` UpdateCutsceneLevelObj_OpenParaGoomCage (Para-Goom); `Func_9f7bb` UpdateCutsceneObjs_OpenSkyDoor; `Func_9f7dc` UpdateCutsceneObjs_ExtinguishFire; `Func_9f821` UpdateCutsceneLevelObj_ExtinguishFire (fire); `Func_9f857` UpdateCutsceneObjs_PlaceBrick; `Func_9f86a` UpdateCutsceneObjs_SprayIronWall; `Func_9f8da` UpdateCutsceneObjs_MixChemicals; `Func_9f91f` UpdateCutsceneObjs_RevealDarkRoom; `Func_9f991` UpdateCutsceneObjs_SummonMoon; `Func_9f9c1` UpdateCutsceneObjs_OpenCraterHole; `Func_9f9f5` UpdateCutsceneLevelObj_OpenCraterHole (wall crack); `Func_9fa48` UpdateCutsceneObjs_DrillHoles; `Func_9fab4` UpdateCutsceneObjs_FeedOctohon; `Func_9faea` UpdateCutsceneLevelObj_FeedOctohon (Octohon); `Func_9fba9` UpdateCutsceneObjs_VolcanoEruption.

For consistency `OWCutTree` could become `UpdateCutsceneObjs_CutTree`.
Inside each updater, the per-object loop entry (`.asm_9f0e9`,
`.asm_9f121`, ...) reads well as `.loop_obj` and the draw tail as
`.draw`; not listed one by one.

**Rule 3: wait steps.** A step local whose whole body is `ld c, N / jp
WaitCutsceneFunc` (bank27) or `ld a, N / jp WaitOWFunc` (bank2d) is
`.Wait<N>` (frames, decimal), with `_1`, `_2` when a routine has several
with the same N, as Cutscene03's `.Wait30_1`.. already do. bank2d's
existing `.Wait1`..`.Wait4` in `SOWFunc_RaiseTower` number the waits in
order instead; renaming them to frames is optional. Generated by script
(scope = the enclosing global label; no clash with an existing local in
the same scope), 109 labels, high.

bank27 (60):

`Cutscene06Func.Func_9d071` .Wait30; `Cutscene06Func.Func_9d0bc` .Wait100; `Cutscene0aFunc.Func_9d140` .Wait50; `Cutscene0aFunc.Func_9d153` .Wait30; `Cutscene07Func.Func_9d1e4` .Wait50_1; `Cutscene07Func.Func_9d1fc` .Wait30; `Cutscene07Func.Func_9d20c` .Wait40_1; `Cutscene07Func.Func_9d234` .Wait50_2; `Cutscene07Func.Func_9d244` .Wait40_2; `Cutscene07Func.Func_9d264` .Wait50_3; `Cutscene19Func.Func_9d2cc` .Wait90; `Cutscene19Func.Func_9d2e4` .Wait30; `Cutscene19Func.Func_9d2fa` .Wait60; `Cutscene19Func.Func_9d326` .Wait8; `Cutscene11Func.Func_9d3a2` .Wait60; `Cutscene11Func.Func_9d3dc` .Wait30_1; `Cutscene11Func.Func_9d40e` .Wait30_2; `Cutscene1bFunc.Func_9d4ae` .Wait90; `Cutscene1bFunc.Func_9d4b3` .Wait8; `Cutscene1bFunc.Func_9d4b8` .Wait60; `Cutscene1bFunc.Func_9d4ff` .Wait20; `Cutscene1bFunc.Func_9d531` .Wait100; `Cutscene1eFunc.Func_9d589` .Wait15; `Cutscene1eFunc.Func_9d5a1` .Wait60; `Cutscene1eFunc.Func_9d5b9` .Wait70; `Cutscene1eFunc.Func_9d5d2` .Wait30; `Cutscene22Func.Func_9d611` .Wait45; `Cutscene27Func.Func_9d687` .Wait50; `Cutscene27Func.Func_9d69f` .Wait180; `Func_9d6f0.Func_9d733` .Wait30; `Func_9d6f0.Func_9d744` .Wait50; `Func_9d6f0.Func_9d792` .Wait254; `Cutscene18Func.Func_9d8a8` .Wait20; `Cutscene0dFunc.Func_9d8fc` .Wait20; `Cutscene0dFunc.Func_9d909` .Wait60; `Cutscene0dFunc.Func_9d980` .Wait80; `Cutscene13Func.Func_9d9f4` .Wait30; `Cutscene49Func.Func_9da4d` .Wait20; `Cutscene49Func.Func_9dac4` .Wait40; `Cutscene24Func.Func_9dbf8` .Wait40; `Cutscene1fFunc.Func_9dcfe` .Wait40; `Cutscene21Func.Func_9dd9c` .Wait60; `Cutscene37Func.Func_9de33` .Wait40; `Cutscene38Func.Func_9dec8` .Wait120; `Cutscene30Func.Func_9df52` .Wait10; `Cutscene30Func.Func_9df6b` .Wait30; `Cutscene39Func.Func_9e013` .Wait100; `Cutscene3aFunc.Func_9e093` .Wait45; `Cutscene3aFunc.Func_9e103` .Wait80; `Cutscene54Func.Func_9e303` .Wait40; `Cutscene54Func.Func_9e333` .Wait20; `Cutscene4cFunc.Func_9e506` .Wait40; `Cutscene4fFunc.Func_9e605` .Wait45; `Cutscene4fFunc.Func_9e61a` .Wait8; `Cutscene51Func.Func_9e6c0` .Wait45; `Cutscene58Func.Func_9e8b2` .Wait30; `Cutscene55Func.Func_9e9da` .Wait45; `Cutscene55Func.Func_9ea8e` .Wait30; `Cutscene44Func.Func_9eb9a` .Wait60; `Cutscene14Func.Func_9ed77` .Wait30

bank2d (49):

`NOWFunc_Prologue.Func_b59a0` .Wait86; `NOWFunc_Prologue.Func_b59d9` .Wait120; `WOWFunc_Earthquake.Func_b5c8f` .Wait60; `WOWFunc_VulcanoEruption.Func_b5da7` .Wait24; `WOWFunc_VulcanoEruption.Func_b5dd2` .Wait58; `WOWFunc_VulcanoEruption.Func_b5f10` .Wait16; `WOWFunc_RedMusicBox.Func_b60b5` .Wait254; `WOWFunc_RedMusicBox.Func_b60d0` .Wait23; `WOWFunc_RedMusicBox.Func_b60e4` .Wait10; `SOWFunc_CanyonThunder.Func_b67cc` .Wait90; `SOWFunc_CanyonThunder.Func_b681b` .Wait30; `SOWFunc_CanyonThunder.Func_b6831` .Wait7; `SOWFunc_CanyonThunder.Func_b6847` .Wait45; `SOWFunc_Fan.Func_b6a86` .Wait20_1; `SOWFunc_Fan.Func_b6a8b` .Wait20_2; `SOWFunc_Fan.Func_b6aa3` .Wait24; `SOWFunc_Fan.Func_b6acf` .Wait12; `SOWFunc_Earthquake.Func_b6c53` .Wait20; `SOWFunc_Earthquake.Func_b6c58` .Wait60; `SOWFunc_Earthquake.Func_b6c73` .Wait120; `EOWFunc_Explosives.Func_b6d3d` .Wait20_1; `EOWFunc_Explosives.Func_b6d42` .Wait40; `EOWFunc_Explosives.Func_b6d47` .Wait50; `EOWFunc_Explosives.Func_b6d92` .Wait20_2; `EOWFunc_Explosives.Func_b6d97` .Wait10; `EOWFunc_FreezeSea.Func_b6ee5` .Wait60; `EOWFunc_FreezeSea.Func_b6f0c` .Wait14; `EOWFunc_Earthquake.Func_b7138` .Wait20; `EOWFunc_Earthquake.Func_b713d` .Wait40; `EOWFunc_Earthquake.Func_b716b` .Wait10; `EOWFunc_FormCastle.Func_b73c4` .Wait60; `EOWFunc_FormCastle.Func_b73c9` .Wait40_1; `EOWFunc_FormCastle.Func_b73e1` .Wait40_2; `EOWFunc_FormCastle.Func_b742b` .Wait20; `EOWFunc_FormCastle.Func_b74a0` .Wait10; `EOWFunc_VulcanoEruption.Func_b75be` .Wait180; `EOWFunc_VulcanoEruption.Func_b75d8` .Wait56; `EOWFunc_BurnVines.Func_b7803` .Wait40_1; `EOWFunc_BurnVines.Func_b7808` .Wait30_1; `EOWFunc_BurnVines.Func_b7818` .Wait60; `EOWFunc_BurnVines.Func_b7828` .Wait30_2; `EOWFunc_BurnVines.Func_b7838` .Wait90; `EOWFunc_BurnVines.Func_b7847` .Wait40_2; `EOWFunc_ShowWarpedVoid.Func_b786d` .Wait60; `EOWFunc_ShowWarpedVoid.Func_b7872` .Wait160; `EOWFunc_RaisePipe.Func_b78aa` .Wait20; `EOWFunc_RaisePipe.Func_b78af` .Wait60; `EOWFunc_Daytime.Func_b78eb` .Wait60_1; `EOWFunc_Daytime.Func_b78f0` .Wait60_2

**Rule 4: map-side object init per OW function.** `InitOWObjects_North/
West/South/East` (bank2d.asm:18, 374, 594, 869) dispatch on
`wOWSceneActionParam` to one routine per `*OWFUNC_*` constant (comment on
each entry); each places the scene objects for that function's scene
according to `w2d065` in `c` (0 not unlocked, $80 just unlocked). Name:
`Init<side letter>OWObjects_<function>`, mirroring `NOWFunc_CutTree`.
Generated for all 45 entries, high:

`Func_b403e` InitNOWObjects_CutTree; `Func_b408e` InitNOWObjects_OpenGate; `Func_b409c` InitNOWObjects_Garlic; `Func_b40c0` InitNOWObjects_MagicSeed; `Func_b40d9` InitNOWObjects_SummonSnake; `Func_b40ff` InitNOWObjects_FallLeaves; `Func_b4140` InitNOWObjects_MusicBox (blue and gold music box; just `ret`); `Func_b4141` InitNOWObjects_CrayonRed; `Func_b4162` InitNOWObjects_CrayonBrown; `Func_b4166` InitNOWObjects_CrayonYellow; `Func_b416a` InitNOWObjects_CrayonGreen; `Func_b416e` InitNOWObjects_CrayonCyan; `Func_b4172` InitNOWObjects_CrayonBlue; `Func_b4176` InitNOWObjects_CrayonPink; `Func_b417a` InitNOWObjects_BottomBar; `Func_b4247` InitNOWObjects_DayNightSpell; `Func_b42e7` InitNOWObjects_Prologue; `Func_b431f` InitWOWObjects_Rain; `Func_b4351` InitWOWObjects_ClearTornado; `Func_b435f` InitWOWObjects_ElevatorWorking; `Func_b438f` InitWOWObjects_MagicSeed; `Func_b43a8` InitWOWObjects_SummonSnake; `Func_b43dd` InitWOWObjects_Earthquake; `Func_b4448` InitWOWObjects_VulcanoEruption; `Func_b4474` InitWOWObjects_RedMusicBox; `Func_b44b7` InitSOWObjects_SendSeeds; `Func_b44e7` InitSOWObjects_MagicSeed; `Func_b4509` InitSOWObjects_YellowMusicBox; `Func_b4520` InitSOWObjects_CanyonThunder; `Func_b4567` InitSOWObjects_RaiseTower; `Func_b45c8` InitSOWObjects_Fan; `Func_b45f5` InitSOWObjects_SummonSnake; `Func_b461b` InitSOWObjects_Earthquake; `Func_b4637` InitSOWObjects_GreenMusicBox; `Func_b4653` InitSOWObjects_Explosives; `Func_b4665` InitSOWObjects_FullMoon; `Func_b46a0` InitEOWObjects_FreezeSea; `Func_b46d9` InitEOWObjects_Earthquake; `Func_b4712` InitEOWObjects_FormCastle; `Func_b4771` InitEOWObjects_Explosives; `Func_b4792` InitEOWObjects_VulcanoEruption; `Func_b47f7` InitEOWObjects_BurnVines; `Func_b481b` InitEOWObjects_ShowWarpedVoid; `Func_b4832` InitEOWObjects_RaisePipe; `Func_b4873` InitEOWObjects_Daytime.

Also `Func_b4001` (slot 0 of all four tables, `debug_nop`, i.e. an endless
loop) -> `InvalidOWSceneAction`, as `InvalidMusicBoxAction` in bank2b_1. High.

### 3c. Boss middle phases (left "not named" in 2d)

Most of these bosses don't use a phase jumptable: each phase sets the next
`OBJ_UPDATE_FUNCTION` itself, so the chains below were followed from
the start of each file. After `SetObjectFramesetPtr`, `hl` points at
`OBJ_STATE_DURATION`, so `ld [hli], a / ld [hl], b` right after it sets
the duration and `OBJ_VAR_1`. Medium unless noted: the flow is certain,
the words describing it are partly guessed from movement and SFX.

| File | Proposed (label -> name) | Evidence | Conf. |
|---|---|---|---|
| anonster.asm (`AnonsterFunc`), ceiling phase | `.asm_50031` -> `.restart`; `.Func_5005e` -> `.Appear`; `.Func_5007f` -> `.Walk`; `.Func_5016f` -> `.Hover`; `.asm_5018e` -> `.set_shoot_frameset`; `.Func_501c4` / `.Func_50200` / `.Func_5023d` -> `.ShootSilk1` / `.ShootSilk2` / `.ShootSilk3`; `.asm_50266` -> `.end_shooting` | `.Appear` waits, turns visible and clears the state. `.Walk` bobs (`Data_60790`, loop index in `OBJ_VAR_3`) and walks with wall turns (`SFX_0B0`); after two bob cycles with no silk left (`_CountActiveTransientObjects`) it turns to Wario and goes to `.Hover`, which keeps bobbing until index $1f (then shoots) or $4f (then walks again). The shoot phases each create `ObjParams_AnonsterSilk1..3Left/Right` at frame $18 (`SFX_07E`); how many follow each other depends on the hits left in the substate's low nybble (4: one, 3: two, else three). `.restart` (also reached from `.ReturnToCeiling`) resets the walk. | medium |
| anonster.asm, drop attack | `.Func_50282` -> `.StartRise`; `.Func_50293` -> `.RiseToCeiling`; `.Func_502d1` -> `.MoveAboveWario`; `.Func_5034c` -> `.DropOnWario`; `.Func_50397` -> `.Land`; `.Func_5041d` -> `.OnFloor` | Entered from `.Walk` on `OBJSTATE_28/29` (hit by a thrown object): `SFX_0B1`, rise to screen Y 8, wait $3c, run fast towards Wario's X (at most 3 wall turns, `OBJ_VAR_1`), then fall along `Data_607f0` with `OBJ_INTERACTION_48` until `Func_352b` finds floor; land with `SFX_061` + `DoGroundShake`. `.OnFloor` dispatches on the object state: 0 walks towards Wario, or turns and goes to $5b when he is behind; $5b counts down and spits `ObjParams_AnonsterWave*` at $2b (`OBJ_VAR_1` waves); $5c walks (`SFX_0AF`) or, when Wario is Ball o' String, returns to the ceiling; $5a waits after landing; `OBJSTATE_VANISH_TOUCH` from behind is a hit. Locals: `.asm_503e0` -> `.spit_waves`, `.asm_5043b` -> `.reset_to_walk`, `.asm_504b1` -> `.return_to_ceiling`, `.asm_504fe` -> `.walk_towards_wario`, `.asm_5054b` -> `.check_hit_from_behind`. | medium |
| anonster.asm, hit and defeat | `.Func_505be` -> `.Hurt`; `.Func_505f4` / `.Func_50610` -> `.Recover1` / `.Recover2`; `.Func_50635` -> `.ReturnToCeiling`; `.Func_50650` / `.Func_5066c` -> `.StartReturnToCeiling` / `.JumpToCeiling`; `.Func_50689` -> `.Defeated`; `.Func_50705` -> `.DefeatedFall` | A hit (`DecrementRemainingBossHits`, `SFX_VANISH`, `UpdateAnonsterPal`) waits $56 frames (`SFX_0B1`), plays two framesets, then rises along `Data_607e0` (`SFX_0B2`) to screen Y $10 and restarts unless Wario is Ball o' String. The last hit waits $ac frames, marks the object map (`Func_ba42`), sets `BOSS_DEFEATED`, then falls off screen along `Data_60180` moving sideways (`SFX_0A3`). | medium (high for the defeat) |
| anonster.asm (`AnonsterSilkFunc`) | `.Func_508cd` -> `.Update`; `.Func_508be` -> `.WaitAndDestroy`; correction: `.Func_50898` -> `.Dissolve` instead of the mechanical `.Default` (2d row) | `.Update` is the landed silk ball: positional state table (2d row). `.Func_50898` is not a do-nothing default: it plays `SFX_0A1`, switches to `Frameset_6955b` for $1d frames with collision off and then `.Func_508be` clears the flags; it is also used when the ball falls to screen Y $b0-$bf. | high |
| muddee.asm (`MuddeeFunc`), `wCurObjVar1` phases | `.Func_55861` -> `.SwimUp`; `.Func_558d0` -> `.SwimDown`; `.Func_55942` / `.Func_5599c` -> `.SwimLeft` / `.SwimRight`; `.Func_559f6` -> `.WaitThenSink`; `.Func_55a0b` -> `.Sink`; `.Func_55a2b` -> `.MoveUnderWario`; `.Func_55a82` -> `.LeapFromFloor`; `.Func_55ad9` -> `.SwimZigZag` | Phases 0-3 swim up/down until the ceiling/floor or Wario's row (`.CompareYWithWarioRow`), left/right until a wall, then pick the next direction towards Wario (faster below 5 hits: `MoveObject*_Slow` only at 5). Phase 4 (after a hit, once back in the water) waits and sinks 8 px; 5 sinks to the floor; 6 moves along the floor under Wario, then spawns the two stingers (`.asm_556dc` -> `.spawn_stingers`, `SFX_0B2`) and leaps (7, `Data_60d30`, the same jump as `.Leap`); at 3 hits left it continues with 8, otherwise back to 0. Phase 8 moves diagonally, bouncing off walls, floor and ceiling (`SFX_0C1` bubbles), pausing $3c frames after every 3 frameset loops. | medium (low for 8) |
| muddee.asm, the rest | `.Func_55ba7` -> `.DefeatedFall`; `.Func_55be7` -> `.PlaySwimSFX`; `.asm_55774` -> `.hit`; `.asm_557b1` -> `.hurt`; `.asm_55806` -> `.defeated` | `w1d147` = 1 (set by a stinger) is a hit: `SFX_VANISH`, frameset by facing, `DecrementRemainingBossHits`, `w1d147 = 2`; while 2, wait $3c (`SFX_0C0`) then fall (`Data_60d40`) until in water (`w1d147 = 0`, phase 4); at 2 hits left the hit is the last one: `.defeated` sets the frameset, `Func_ba42`, `stop_music2`, `wMuddeeAmbushState = 2` and `.DefeatedFall` (same fall as Anonster's, `SFX_0A3`). `.PlaySwimSFX`: `SFX_085` every 8/16/32 frames by hits left. | medium |
| omodonmeka.asm (`OmodonmekaFunc`), steps 4-8 | `.Func_4244c` -> `.FlyAway`; `.Func_42291` -> `.CarryWarioUp`; `.Func_422fc` -> `.HoldWarioAtTop`; `.Func_42261` -> `.HoldFlatWario`; `.Func_42369` -> `.WatchWario`; `.asm_421dc` / `.asm_421e4` / `.asm_421ec` / `.asm_421f4` -> `.hit_by_obj_left` / `.hit_by_obj_right` / `.attacked_left` / `.attacked_right`; `.asm_42215` -> `.vanish_touch` | `OBJSTATE_ACTIVATE` (`.Activate`) grabs Wario: step 5 (or 7 for Flat Wario). 5 carries him up (`MoveWarioUp`, `HandleUpwardsFloorTransition`, `SFX_087`) to a ceiling or 64 px above the start, 6 holds him there (Wario Y = object + 26) and 7 holds Flat Wario for $18 frames; when `wAutoMoveState` drops to 0 the next frame's state change sends it to step 4, which flies off along `Data_604e0`/`Data_60650` (only Flat Wario lets it come back to its start Y). 8 is entered from `.Hover` when Wario is near and below: `SFX_08C`; directly below -> step 2 (`.Fall`, `SFX_088`), out of range -> step 1. The four `.asm_` set the shared `ObjState_*` trampolines (`Func_33f8`, `Func_3407`, `Func_3326`, `Func_3317`). | medium |
| omodonmeka.asm (`OmodonmekaWithOmodonFunc`) | `.Func_42535` -> `.Idle`; `.Func_42554` -> `.WaitToLower`; `.Func_42559` -> `.StartLowering`; `.Func_4256c` -> `.LowerToOmodon`; `.Func_4261f` -> `.move_to_omodon`; `.Func_426ee` -> `.Rise`; `.Func_42714` -> `.FlyAway` | Steps of the substate low nybble: idle (straight to the bob routine when Wario is Flat), wait $3c, then look for the Omodon sharing its object-map pointer (`OBJ_UNK_01/02`, active+transient flags) in all 8 slots, move down until level with it, set it to state $2d (carried) and rise $32 frames carrying Wario if stepped on; hit states fly away like the plain Omodonmeka. | medium |
| omodonmeka.asm, the Omodon | `Func_4279c` -> `OmodonFunc`; `Func_4279c.Func_427a9` -> `.Update`; `Func_42767` -> `Omodon_Idle`; `Func_42754` -> `Omodon_Landed`; `.asm_427cd` -> `.carried`; `.asm_427fe` -> `.fall`; `.Func_4284d` / `.Func_4286b` -> `.StartPressWario` / `.PressWario` | `Func_4279c` is the update function in `ObjParams_Omodon` and `ObjParams_Omodon1` (object_params.asm:1359, 1376), so it is the Omodon's main routine. State 0: idle (bobbing with Flat Wario, else falls: state $2e, `OBJ_INTERACTION_OMODON`); $2d carried up by the Omodonmeka; $2e falls (`Data_605e0`) until floor, `SFX_063` + `DoGroundShake`, solid, state $2f (`Omodon_Landed`, waits); `OBJSTATE_ACTIVATE` sits on Wario (Y = Wario - 24) while `wAutoMoveState`. `.Func_42894`/`.Func_42935` not named. | medium (high for `OmodonFunc`) |
| omodonmeka.asm, data | `Func_42725` -> `ApplyOmodonHoverBob`; `Data_40000` (src/level.asm:69) -> `OmodonHoverBobYOffsets` | Adds the next byte of `Data_40000` (index `OBJ_VAR_3`, wraps at `$80`) to `OBJ_Y_POS`; the table's comment says so. Used while Wario is Flat. | medium |
| scowler.asm (`ScowlerFunc`) | `.Func_546bd` -> `.MoveUp`; `.Func_546e0` -> `.Stunned`; `.Func_54770` -> `.Vulnerable`; `.Func_54806` -> `.Hit`; `.Func_54853` -> `.HitFloatUp`; `.Func_548c5` -> `.DefeatedRise`; `.asm_545ab` -> `.stun`; `.asm_545d3` -> `.shoot_ink`; `.asm_54737` -> `.check_hit_from_above`; `.asm_547e9` -> `.end_vulnerable`; `.asm_54895` -> `.reset_ink_timer` | `.Main`, state 0: swims sideways with wall turns and moves towards Wario's Y (`.Func_5469d` down, `.MoveUp` up to the water surface); `OBJ_VAR_3` counts down to an ink attack ($48 + 32 per hit left), state $2f spits `ObjParams_InkLeft/Right` at $20. `OBJSTATE_WOBBLE_*_START` stuns it (`SFX_0B3`, `OBJ_INTERACTION_07`): it sinks for $44 frames, then becomes vulnerable (`OBJ_INTERACTION_06`, darts around with `SFX_0AB` for 2 periods); hit again in that state while Wario is above it, it takes a hit (`SFX_0B4`, `DecrementRemainingBossHits`), floats up for $78 frames and recovers; the last hit stops the music, rises to the surface and goes to the existing `.DefeatedSink`. Correction to the 2d row: `.Func_5469d` (proposed `.Fall`) is the "move down until floor" half of the vertical movement, `.MoveDown` matches `.MoveUp`. | medium |
| scowler.asm (`ScrowlerTentacleFunc`) | `.Func_54a97` -> `.FollowScowler`; `.asm_54a7f` -> `.activated` | Finds the active `SCOWLER` object and places itself next to it (offsets by tentacle side and Scowler's facing); Scowler's `OBJ_VAR_1` doubles as a signal: $fd -> `OBJ_INTERACTION_43`, $fe -> `OBJ_INTERACTION_WATER_TELEPORTING`, $ff -> despawn. | medium |
| yellow_belly.asm (body) | `.Func_51652` -> `.Swim`; `.Func_515dd` -> `.GuardPump`; `.Func_51572` -> `.ReleasePump`; `.Func_5178c` -> `.Sink`; `.Func_5184a` -> `.Defeated`; `.asm_51442` -> `.start_shooting`; `.asm_514eb` -> `.end_shooting`; `.asm_5154e` -> `.release_pump` | `.Swim` bobs (`Data_60950`), moves sideways with wall turns and pauses (`OBJ_VAR_1`), freezes while byte 0 of the boss union is set (the head was hit), and starts shooting when Wario has been above it for a while. `OBJSTATE_VANISH_TOUCH` releases the pump: `stop_sfx`, union byte 2 = 1, $a6 frames of `SFX_VANISH`/`SFX_0A9`, `ObjParams_Pump` at $25, palette flashes, rising. While the pump is out it swims to 56 px from the pump (`.GuardPump`) and shoots; Puffy Wario clears the flag. The pump being stomped writes $3a to union byte 1, which every phase checks first (`.hit`). `.Sink`: moves down while its screen X is below $c8 (entered when Wario is above it at the end of a pause). `.Defeated`: flashes `Pals_51ce1`/`Pals_51cb1`, `SFX_0AA`, and at frameset offset $20 despawns and sets the platform's state to $2f (`Func_51c62`). | medium (low for `.Sink`) |
| bubble.asm (`BubbleFunc`) | `.asm_47cf4` -> `.drift`; `.Func_47d56` -> `.drift_right` | Moving left/right (bit 7 of the substate): two wall probes ahead (`Func_3513`); a wall turns it around and sets a $30 pause; otherwise adds the next byte of a drift table to `OBJ_X_POS`. | high |
| haridama.asm | `.Func_49094` -> `.RiseInWater` | State $38 (`OBJSTATE_WOBBLE_LEFT`): moves up slowly while both head probes are clear and it is in water, then switches to `.Func_490e8` (`.UpdateRolling`) with a $64 timer. | medium |
| snake.asm | `.Func_49b76` -> `.SetStateFromScreenY` | Called every frame by `.Rise` and `.Sink`: state $48 while the snake's screen Y is below $10 or in $a0-$bf (at the screen edge), otherwise state 0. | medium |

#### Notable finding: bubble drift tables addressed by literal

`BubbleFunc` reads its drift tables as `ld b, $40 / add $20` and `ld b, $40
/ add $50` (bubble.asm:203-204, 266-267), i.e. the fixed addresses $4020
and $4050 of its bank. Those are `Data_44020` (all 0 / -1) and `Data_44050`
(all 0 / +1) in src/level.asm:96-100, whose only "references" are these
literals, so like the literal update-function pointers they would break as
soon as anything before them in "Object Functions 2" moves. Fix:
`ld b, HIGH(Data_44020) / add LOW(Data_44020)` (as omodonmeka.asm does for
`Data_40000`), ROM unchanged. Names: `Data_44020` -> `BubbleDriftLeftX`,
`Data_44050` -> `BubbleDriftRightX`. High.

#### Possible bug: Scowler's stunned vertical direction

`ScowlerFunc.Func_546e0` (scowler.asm:323-331) ends with

    cp b
    jr nc, .asm_54734
    set 6, [hl]
    .asm_54734
    res 6, [hl]
    ret

so the `set` is always undone and `OBJSUBFLAG_VDIR` is always cleared
when the vulnerable phase starts (`.Func_54770` then starts by moving up).
Probably a missing `ret` after the `set`; harmless in practice. Medium.

### 3d. Boss union: one `NEXTU` per boss

The union after `wWarioGoals` (src/ram/wram.asm:997-1068) has named
members for Doll Boy, Shoot, Wolfenboss, Jamano (byte 0 only) and Muddee
(byte 0 only). Every other use borrows Doll Boy's names or `w1d147`/
`w1d149`. All uses outside doll_boy.asm, shoot.asm and wolfenboss.asm were
grepped (pesce, jamano, muddee, muddee_stinger, scowler, yellow_belly; no
other file touches the union). Proposed `NEXTU` blocks (byte 0, 1, 2, 3):

| Boss | Byte 0 | Byte 1 | Byte 2 | Byte 3 | Evidence | Conf. |
|---|---|---|---|---|---|---|
| Jamano | `wJamanoActiveSkulls` (exists) | `wJamanoSkullsInPlace` (2a) | `wJamanoDarkness` | `wJamanoSkullsInactive` (2a) | Byte 2 is the darkness step that `Func_55407` raises with the skulls in place and that `Func_554bc` reads (1, 2, ...) to pick the BG palettes; the skull spawner stops when bytes 2 and 3 are both 0 (jamano.asm:671-682). | medium |
| Pesce | `wPesceFlyActive` | `wPesceHits` | `wPesceFightOver` | - | As in the 2d pesce row (names proposed there in passing). | medium |
| Muddee | `wMuddeeAmbushState` (exists) | `wMuddeeHitState` | - | - | 0 normal, 1 hit (set by a stinger, muddee_stinger.asm:21), 2 hurt/falling back into the water (see 3c). | medium |
| Scowler | `wScowlerBlackoutTimer` | `wScowlerInkTimer` | - | - | Byte 1: set to 1 when ink touches Wario (`InkFunc`, scowler.asm:1024), counted up by `Func_54c07` to $78 (flash at 2/$3d, blackout at $3c, restore at $78), cleared at the defeat. Byte 0: $ff at the blackout, decremented each frame while non-zero; while it is non-zero byte 1 doesn't advance. | high |
| Yellow Belly | `wYellowBellyHeadHit` | `wYellowBellyHitRequest` | `wYellowBellyPumpOut` | - | Byte 0: the invisible head object sets 1 for $1e frames when it gets a state (also `stop_music2`, `wBossState = 0`), and the body freezes meanwhile. Byte 1: $3a from the pump when stomped (yellow_belly.asm:959); the body takes a hit and clears it. Byte 2: 1 while the pump is out (body phases, arrows fly slower while it is set: yellow_belly.asm:1045-1111). | medium |

With these, `w1d147`, `w1d149` and the `ds $1` between them go away, and
the second-pass row for `w1d147` ("+ per-boss aliases") is covered.

### 3e. Data labels: owner-prefix rule (generated)

Rule (the 2f suggestion, made concrete): a `Frameset_`, `OAM_`, `Pals_` or
`Data_` label whose owner is unambiguous becomes `<Owner><Prefix>_<addr>`,
keeping the address so names stay unique and the change stays mechanical
(`Frameset_68a12` -> `ApplebyFrameset_68a12`). Descriptive names can then
replace them one by one. Labels already given a name in this file (Hidden
Figure's tables and palettes, the room palettes, the object Y-velocity
tables, ...) are left out, and a descriptive name proposed anywhere in this
file wins over the generated one (e.g. `Data_40000` ->
`OmodonHoverBobYOffsets` in 3c rather than `OmodonmekaData_40000`).

Owner, decided by a script over every reference in `src/` (the defining
file itself doesn't count; `src/data/object_params.asm` doesn't count
against an object):

- **object**: all other references are in one file of
  src/engine/level/objects/ (or the label is defined and only used inside
  one): the file name in CamelCase (`brrr_bear.asm` -> `BrrrBear`).
- **cutscene**: all references are inside one bank27 cutscene routine
  (`CutsceneXXFunc` or its updater from 3b): `<Event>Cutscene`
  (`OpenNorthGateCutsceneFrameset_bd348`).
- **mapside**: all references are inside one bank2d map-side state entry;
  the side follows from the entry's address range (East $b4b99-, South
  $b4cc2-, West $b4dfb-, North $b4fa2-$b5147): `<Side>OWObj`
  (`NorthOWObjFrameset_a87e8`). These are the framesets the 2b bulk rule
  `<Side>OWObjState_<FramesetName>` waits for.
- **scene**: all references in one of `UpdateSceneWario`,
  `UpdateTempleSceneObjAnimation`, `Func_ac409` (`UpdatePrologueSceneObj`)
  or `Func_ac0b6` (`UpdateEpilogueSceneObj`) in bank2b_1: `SceneWario`,
  `TempleSceneObj`, `PrologueSceneObj`, `EpilogueSceneObj`.
- **wario**: all references in one named `SetState_X`/`UpdateState_X` of
  wario_states_1..4.asm: `WarioX` (`WarioFatWalkingFrameset_xxxxx`).
  References from still-unnamed `Func_` routines are left out.

Result: 1406 labels (1242 framesets, 58 OAM, 32 palettes, 74 `Data_`); by
owner kind: object 812, cutscene 202, mapside 132, wario 168, scene 92. All
generated names checked against `src/` and this file: no collisions, no
duplicates. Not covered (about 1150): labels referenced from several files
or several routines (e.g. Wario framesets shared by several states, OAM
tables shared through object_data.asm), labels referenced only from their
own data file (inside frameset tables), and owners that are still `Func_`.
High as a mechanical rule (the owner is the only user by construction);
the list, grouped by owner (each label becomes `<Owner><Prefix>_<addr>`):

**cutscene**

- BlowMistCutscene: `Frameset_bdb03`, `OAM_bdabc`
- CollectDemonsBloodCutscene: `Frameset_bebcc`, `Frameset_bebd3`, `Frameset_bebda`, `Frameset_bebdd`, `Frameset_bebe0`, `Frameset_bebe3`, `Frameset_bebec`, `OAM_beafc`
- CutBaloonCutscene: `Frameset_bed39`, `Frameset_bed3c`, `Frameset_bed3f`, `OAM_becdc`, `Pals_b8740`
- DrillHolesCutscene: `Frameset_bf826`, `Frameset_bf829`, `Frameset_bf832`, `Frameset_bf835`, `Frameset_bf83e`, `OAM_bf6f0`, `Pals_b8680`
- ExpelTornadoCutscene: `Frameset_bde60`, `Frameset_bde63`, `Frameset_bde66`, `OAM_bddcf`
- ExplodeBombsCutscene: `Frameset_bd9ec`, `Frameset_bd9f5`, `Frameset_bd9f8`, `Frameset_bd9fb`, `Frameset_bd9fe`, `OAM_bd971`
- ExtinguishFireCutscene: `Frameset_69c13`, `Frameset_bf100`, `Frameset_bf103`, `Frameset_bf110`, `OAM_befd5`, `Pals_b86c0`
- FeedOctohonCutscene: `Frameset_69ba0`, `Frameset_bf923`, `Frameset_bf92a`, `OAM_bf847`
- FixElevatorCutscene: `Frameset_bd5c3`, `Frameset_bd5cc`, `Frameset_bd5d5`, `Frameset_bd5d8`, `Frameset_bd5dd`, `Frameset_bd5e6`, `Frameset_bd605`, `Frameset_bd608`, `Frameset_bd60f`, `Frameset_bd612`, `OAM_bd46f`
- FootStoneCutscene: `Frameset_bdce3`, `OAM_bdc9c`
- FreezeSeaCutscene: `Frameset_bd905`, `Frameset_bd908`, `Frameset_bd90b`, `Frameset_bd90e`, `OAM_bd7a1`
- LeavesFallCutscene: `Frameset_be1b0`, `Frameset_be1c3`, `Frameset_be1fc`, `Frameset_be203`, `OAM_bdfa5`
- MakeWireCutscene: `Frameset_be2b9`, `Frameset_be2c2`, `Frameset_be2d3`, `Frameset_be2d6`, `OAM_be206`
- MixChemicalsCutscene: `Frameset_bf43b`, `Frameset_bf43e`, `Frameset_bf45d`, `OAM_bf2ab`
- MusicBoxCutscene: `Frameset_bcf15`, `Frameset_bcf18`, `Frameset_bcf21`, `Frameset_bcf24`, `Frameset_bcf35`, `Frameset_bcf38`, `Frameset_bcf49`, `Frameset_bcf4c`, `Frameset_bcf6d`, `Frameset_bcf70`, `OAM_bc1f6`
- OpenCraterHoleCutscene: `Frameset_bf6df`, `Frameset_bf6e2`, `Frameset_bf6ed`, `OAM_bf66d`, `Pals_b87c0`
- OpenNorthGateCutscene: `Frameset_bd348`, `Frameset_bd34b`, `Frameset_bd34e`, `Frameset_bd351`, `Frameset_bd354`, `Frameset_bd363`, `Frameset_bd372`, `OAM_bd1fd`
- OpenParaGoomCageCutscene: `Frameset_bee4d`, `Frameset_bee50`, `Frameset_bee55`, `Frameset_bee58`, `Frameset_bee5d`, `Frameset_bee60`, `Frameset_bee6b`, `OAM_bed42`
- OpenSkyDoorCutscene: `Frameset_befbe`, `Frameset_befc1`, `Frameset_befc4`, `OAM_bee6e`
- OpenSnakeDoorCutscene: `Frameset_bdda9`, `Frameset_bddc0`, `Frameset_bddc3`, `Frameset_bddc6`, `Frameset_bddc9`, `Frameset_bddcc`, `OAM_bdce6`
- OpenTreeMouthCutscene: `Frameset_bdf92`, `Frameset_bdf95`, `Frameset_bdfa0`, `OAM_bde69`
- PlaceBrickCutscene: `Frameset_bf154`, `OAM_bf131`, `Pals_b8640`
- PlaceCartWheelsCutscene: `Frameset_691bc`
- PlacePropellerCutscene: `Frameset_becc7`, `Frameset_becca`, `Frameset_becd3`, `OAM_bebef`
- PlantSeedsCutscene: `Frameset_bd1b4`
- RainstormCutscene: `Frameset_bd43a`, `Frameset_bd43d`, `Frameset_bd44a`, `OAM_bd377`
- RaiseIceBlocksCutscene: `Frameset_be8de`, `Frameset_be8e1`, `Frameset_be8ea`, `Frameset_be8ed`, `OAM_be807`, `Pals_b8500`
- RaisePipeCutscene: `Frameset_be9fa`, `Frameset_be9fd`, `OAM_be8fe`
- RaiseTowerCutscene: `Frameset_bd469`, `Frameset_bd46c`, `OAM_bd453`
- RemoveWarpsCutscene: `Frameset_beacc`, `Frameset_beacf`, `Frameset_beae4`, `Frameset_beaed`, `OAM_bea06`, `Pals_b8780`
- RevealCastleCutscene: `Frameset_bd790`, `Frameset_bd793`, `Frameset_bd79c`, `OAM_bd615`
- RevealDarkRoomCutscene: `Frameset_bf5e0`, `OAM_bf460`, `Pals_b8800`, `Pals_b8840`, `Pals_b8880`, `Pals_b9080`
- RevealWarpedVoidCutscene: `Frameset_be7e6`, `Frameset_be7e9`, `Frameset_be802`, `OAM_be3ce`
- SprayIronWallCutscene: `Frameset_bf28c`, `Frameset_bf28f`, `Frameset_bf298`, `Frameset_bf2a5`, `Frameset_bf2a8`, `OAM_bf157`
- SummonMoonCutscene: `Frameset_bf65d`, `Frameset_bf660`, `Frameset_bf665`, `Frameset_bf668`, `OAM_bf611`, `Pals_b8540`, `Pals_b8580`, `Pals_b85c0`, `Pals_b8600`
- SummonSnakesCutscene: `Frameset_bdc5f`, `Frameset_bdc62`, `Frameset_bdc7f`, `OAM_bdb06`
- SummonSunCutscene: `Frameset_bd96b`, `Frameset_bd96e`, `OAM_bd911`, `Pals_b8340`
- TorchForestCutscene: `Frameset_be3c5`, `OAM_be2d9`
- TreasureMapCutscene: `Frameset_bdaa2`, `Frameset_bdab9`, `OAM_bda01`, `Pals_b8100`, `Pals_b8d00`
- VolcanoEruptionCutscene: `Frameset_bd1b7`, `Frameset_bd1ba`, `Frameset_bd1bd`, `Frameset_bd1c0`, `Frameset_bd1c5`, `Frameset_bd1f8`

**mapside**

- EastOWObj: `Frameset_a9e61`, `Frameset_a9e72`, `Frameset_a9e75`, `Frameset_a9e7a`, `Frameset_a9e8c`, `Frameset_a9e91`, `Frameset_a9e94`, `Frameset_a9e99`, `Frameset_a9eaa`, `Frameset_a9eb3`, `Frameset_a9ebc`, `Frameset_a9ec5`, `Frameset_a9ec8`, `Frameset_a9ecd`, `Frameset_a9ed0`, `Frameset_a9ed3`, `Frameset_a9ee0`, `Frameset_a9ee3`, `Frameset_a9eea`, `Frameset_a9ef1`, `Frameset_a9ef6`, `Frameset_a9efd`, `Frameset_a9f02`, `Frameset_a9f0d`, `Frameset_a9f36`, `Frameset_a9f47`, `Frameset_a9f76`, `Frameset_a9fa7`, `Frameset_a9faa`, `Frameset_a9fbb`, `Frameset_a9fc2`, `Frameset_a9fc9`, `Frameset_a9fd0`, `Frameset_a9fdf`
- NorthOWObj: `Frameset_a8590`, `Frameset_a85cd`, `Frameset_a85d0`, `Frameset_a85d3`, `Frameset_a862a`, `Frameset_a862d`, `Frameset_a8636`, `Frameset_a8639`, `Frameset_a8646`, `Frameset_a8653`, `Frameset_a866e`, `Frameset_a867f`, `Frameset_a86da`, `Frameset_a872f`, `Frameset_a8732`, `Frameset_a873d`, `Frameset_a8750`, `Frameset_a8761`, `Frameset_a8764`, `Frameset_a876f`, `Frameset_a877a`, `Frameset_a877d`, `Frameset_a8782`, `Frameset_a8793`, `Frameset_a879a`, `Frameset_a879f`, `Frameset_a87d2`, `Frameset_a87d9`, `Frameset_a87dc`, `Frameset_a87df`, `Frameset_a87e8`, `Frameset_a87f1`, `Frameset_a883b`, `Frameset_aa252`, `Frameset_aa5f5`, `Frameset_aa5f8`, `OAM_a87fa`
- SouthOWObj: `Frameset_a9674`, `Frameset_a967d`, `Frameset_a968d`, `Frameset_a969a`, `Frameset_a96a3`, `Frameset_a96a6`, `Frameset_a96a9`, `Frameset_a96ac`, `Frameset_a96af`, `Frameset_a96b2`, `Frameset_a96bd`, `Frameset_a96c0`, `Frameset_a96d1`, `Frameset_a96d8`, `Frameset_a96e1`, `Frameset_a96ea`, `Frameset_a96ef`, `Frameset_a974a`, `Frameset_a979f`, `Frameset_a97a2`, `Frameset_a97ad`, `Frameset_a97b2`, `Frameset_a97c5`, `Frameset_a97d4`, `Frameset_a97e1`, `Frameset_a97ec`, `Frameset_a97ef`, `Frameset_a97fe`, `Frameset_a9803`
- WestOWObj: `Frameset_a8dd1`, `Frameset_a8de2`, `Frameset_a8de9`, `Frameset_a8df8`, `Frameset_a8e01`, `Frameset_a8e04`, `Frameset_a8e11`, `Frameset_a8e1e`, `Frameset_a8e29`, `Frameset_a8e2c`, `Frameset_a8e5d`, `Frameset_a8e6c`, `Frameset_a8e9d`, `Frameset_a8eac`, `Frameset_a8eb7`, `Frameset_a8ec2`, `Frameset_a8ec7`, `Frameset_a8ed3`, `Frameset_a8eda`, `Frameset_a8ee1`, `Frameset_a8f17`, `Frameset_a8f28`, `Frameset_a8f31`, `Frameset_a8f3a`, `Frameset_a8f47`, `Frameset_a9090`, `Frameset_a90eb`, `Frameset_a9140`, `Frameset_a9143`, `Frameset_a914e`, `OAM_a884a`, `OAM_a8f57`

**object**

- Anonster: `Data_60790`, `Data_607e0`, `Data_607f0`, `Data_60800`, `Data_60830`, `Frameset_693c4`, `Frameset_693d5`, `Frameset_693e6`, `Frameset_693f9`, `Frameset_69402`, `Frameset_69411`, `Frameset_69424`, `Frameset_6942d`, `Frameset_6943c`, `Frameset_69441`, `Frameset_69446`, `Frameset_6944d`, `Frameset_69450`, `Frameset_69463`, `Frameset_69474`, `Frameset_69485`, `Frameset_69496`, `Frameset_694a7`, `Frameset_694b8`, `Frameset_694c9`, `Frameset_694d0`, `Frameset_694d7`, `Frameset_694dc`, `Frameset_694e1`, `Frameset_694f5`, `Frameset_69512`, `Frameset_69519`, `Frameset_6951e`, `Frameset_6953c`, `Frameset_69543`, `Frameset_6954d`, `Frameset_69554`, `Frameset_6955b`, `Frameset_69568`, `Frameset_69573`
- Appleby: `Data_60670`, `Frameset_689e9`, `Frameset_68a09`, `Frameset_68a12`, `Frameset_68a1f`, `Frameset_68a3a`, `Frameset_68a63`
- Barrel: `Data_60a50`, `Frameset_68a66`, `Frameset_68a6f`, `Frameset_68a78`, `Frameset_68a7b`, `Frameset_68a7e`, `Frameset_68a8b`
- BeamBot: `Data_60610`, `Data_60630`, `Frameset_68e77`, `Frameset_68e80`, `Frameset_68e89`, `Frameset_68e96`, `Frameset_68ea3`, `Frameset_68eaa`, `Frameset_68eb1`, `Frameset_68eb4`, `Frameset_68eb7`, `Frameset_68ec0`, `Frameset_68ec9`, `Frameset_68ece`, `Frameset_68ed3`, `Frameset_68eda`, `Frameset_68ef3`, `Frameset_68ef8`
- BigLeaf: `Frameset_68729`, `Frameset_68732`, `Frameset_6873b`
- Bird: `Frameset_687c9`, `Frameset_687ce`, `Frameset_687d3`, `Frameset_687e4`, `Frameset_687f5`, `Frameset_687fa`, `Frameset_687ff`
- BrrrBear: `Frameset_69115`, `Frameset_69126`, `Frameset_69137`, `Frameset_6913a`, `Frameset_6913d`, `Frameset_6914c`, `Frameset_6915b`, `Frameset_69164`, `Frameset_6916e`, `Frameset_69175`, `Frameset_6917c`, `Frameset_69183`, `Frameset_6918e`
- Bubble: `Frameset_690f4`, `Frameset_6910c`
- Cart: `Frameset_69199`, `Frameset_6919e`, `Frameset_691aa`, `Frameset_691b3`
- Chests: `Frameset_68000`, `Frameset_68003`, `Frameset_68060`, `Frameset_681be`, `Frameset_681c3`, `Frameset_681c8`, `Frameset_681cd`
- ClearGate: `Frameset_698a8`, `Frameset_698ab`, `Frameset_698ae`
- CountRichtertoffen: `Data_604b0`, `Frameset_683bc`, `Frameset_683c1`, `Frameset_683c4`, `Frameset_683c7`, `Frameset_683ca`, `Frameset_683d4`, `Frameset_683d9`, `Frameset_683de`, `Frameset_683e1`
- DollBoy: `Data_60860`, `Data_60880`, `Data_60890`, `Data_608a0`, `Data_60ae0`, `Data_60b00`, `Data_60b30`, `Data_60b60`, `Data_60b80`, `Data_60ba0`, `Data_60bd0`, `Data_60c00`, `Frameset_69632`, `Frameset_6963b`, `Frameset_69646`, `Frameset_6964d`, `Frameset_69656`, `Frameset_6965f`, `Frameset_6966a`, `Frameset_69675`, `Frameset_6967a`, `Frameset_6967f`, `Frameset_69695`, `Frameset_6969a`, `Frameset_6969f`, `Frameset_696a8`, `Frameset_696b6`, `Frameset_696b9`
- Doughnuteer: `Frameset_6856b`, `Frameset_68574`, `Frameset_6857d`, `Frameset_68586`, `Frameset_68597`, `Frameset_685a8`, `Frameset_685ad`, `Frameset_685b2`, `Frameset_685bb`, `Frameset_685c4`, `Frameset_685d7`, `Frameset_685f0`, `Frameset_685f7`, `Frameset_685fe`, `Frameset_68605`
- ElectricLamp: `Frameset_68ca0`, `Frameset_68cc4`, `Frameset_68ccd`
- FallingSnow: `Frameset_6958f`, `Frameset_695a6`, `Frameset_695af`, `Frameset_695c0`, `Frameset_695cb`, `Frameset_695d6`, `Frameset_695d9`
- FireBot: `Frameset_6893d`, `Frameset_68946`, `Frameset_6894f`, `Frameset_6895c`, `Frameset_68969`, `Frameset_68976`, `Frameset_68983`, `Frameset_68986`, `Frameset_68989`, `Frameset_68992`, `Frameset_6899b`, `Frameset_689a0`, `Frameset_689a5`, `Frameset_689ac`, `Frameset_689b3`, `Frameset_689be`, `Frameset_689c9`, `Frameset_689d2`, `Frameset_689db`, `Frameset_689e2`
- FlameBlock: `Frameset_695de`, `Frameset_695e7`
- Futamogu: `Frameset_68319`, `Frameset_68336`, `Frameset_68343`, `Frameset_68348`, `Frameset_68351`
- HammerBot: `Frameset_68b17`, `Frameset_68b1c`, `Frameset_68b25`, `Frameset_68b2e`, `Frameset_68b37`, `Frameset_68b40`, `Frameset_68b45`, `Frameset_68b4a`, `Frameset_68b51`, `Frameset_68b58`, `Frameset_68b5b`, `Frameset_68b5e`, `Frameset_68b61`
- Hand: `Frameset_690ab`, `Frameset_690b4`, `Frameset_690b7`, `Frameset_690ba`, `Frameset_690bd`, `Frameset_690c0`, `Frameset_690c3`, `Frameset_690c6`, `Frameset_690c9`, `Frameset_690dc`, `Frameset_690df`, `Frameset_690e2`, `Frameset_690e5`, `Frameset_690e8`, `Frameset_690eb`
- Haridama: `Frameset_6927f`, `Frameset_69290`, `Frameset_692a1`, `Frameset_692aa`, `Frameset_692b3`, `Frameset_692b8`, `Frameset_692bd`, `Frameset_692c2`, `Frameset_692c7`, `Frameset_692ce`, `Frameset_692d5`, `Frameset_692de`
- Hebarii: `Frameset_683e4`, `Frameset_683ed`, `Frameset_683f8`, `Frameset_683fb`, `Frameset_6840d`, `Frameset_68418`, `Frameset_68421`, `Frameset_6842a`, `Frameset_6842d`, `Frameset_68430`
- HiddenFigure: `Frameset_6a06c`, `Frameset_6a071`, `Frameset_6a07a`, `Frameset_6a07f`, `Frameset_6a084`, `Frameset_6a08d`, `Frameset_6a092`, `Frameset_6a097`, `Frameset_6a0b2`, `Frameset_6a0b7`, `Frameset_6a0bc`, `Frameset_6a0c3`, `Frameset_6a0c8`, `Frameset_6a0cf`, `Frameset_6a0d4`, `Frameset_6a0ef`, `Frameset_6a0f2`, `Frameset_6a0fe`, `Frameset_6a119`, `Frameset_6a11c`, `Frameset_6a128`, `Frameset_6a131`, `Frameset_6a13a`, `Frameset_6a145`
- Jamano: `Data_60c20`, `Data_60c80`, `Data_60ce0`, `Data_60d00`, `Data_60d20`, `Frameset_69c1c`, `Frameset_69c40`, `Frameset_69c45`, `Frameset_69c4a`, `Frameset_69c4f`, `Frameset_69c7a`, `Frameset_69c92`, `Frameset_69ca1`, `Frameset_69cd6`, `Frameset_69cdb`, `Frameset_69ce0`, `Frameset_69ce9`, `Frameset_69cec`, `Frameset_69cef`, `Pals_55511`, `Pals_55551`, `Pals_55591`, `Pals_555d1`
- Key: `Frameset_6804f`
- Kobatto: `Frameset_69041`
- Kushimushi: `Frameset_6860c`, `Frameset_68611`, `Frameset_68616`, `Frameset_6861b`, `Frameset_68620`, `Frameset_68625`, `Frameset_6862a`, `Frameset_6862f`, `Frameset_68634`, `Frameset_6863f`, `Frameset_6864a`, `Frameset_68655`, `Frameset_68698`
- MadScienstein: `Frameset_68bb5`, `Frameset_68bbe`, `Frameset_68bc7`, `Frameset_68bcc`, `Frameset_68bd1`, `Frameset_68bda`, `Frameset_68be3`, `Frameset_68be8`, `Frameset_68bed`, `Frameset_68bf6`, `Frameset_68bff`, `Frameset_68c08`, `Frameset_68c11`, `Frameset_68c14`, `Frameset_68c17`, `Frameset_68c1e`, `Frameset_68c25`, `Frameset_68c2c`
- Mizuuo: `Data_60700`, `Data_60740`, `Frameset_686a4`, `Frameset_686b9`, `Frameset_686d8`, `Frameset_686db`, `Frameset_686de`, `Frameset_686e5`, `Frameset_686ea`, `Frameset_686ef`, `Frameset_686f8`, `Frameset_68701`, `Frameset_6870a`, `Frameset_68713`, `Frameset_6871e`
- Muddee: `Data_60d30`, `Data_60d40`, `Frameset_69cf2`, `Frameset_69cfb`, `Frameset_69d04`, `Frameset_69d0d`, `Frameset_69d16`, `Frameset_69d2f`, `Frameset_69d48`, `Frameset_69d4d`, `Frameset_69d52`, `Frameset_69d57`, `Frameset_69d5c`, `Frameset_69d65`, `Frameset_69d6a`, `Frameset_69d73`, `Frameset_69d85`, `Frameset_69d8e`, `Frameset_69da7`, `Frameset_69dc0`, `Pals_55e46`
- MuddeeStinger: `Data_4caed`, `Data_4cb0d`
- MusicalCoin: `Frameset_68036`
- Nobiiru: `Frameset_698b1`, `Frameset_698b4`, `Frameset_698b7`, `Frameset_698ba`, `Frameset_698bd`, `Frameset_698c0`, `Frameset_698c3`, `Frameset_698c6`, `Frameset_698c9`, `Frameset_698cc`, `Frameset_698cf`, `Frameset_698d2`, `Frameset_698d5`, `Frameset_698d8`, `Frameset_698db`, `Frameset_698de`, `Frameset_698e1`, `Frameset_698e4`, `Frameset_698e7`, `Frameset_698ea`, `Frameset_698ed`, `Frameset_698f0`, `Frameset_698f3`, `Frameset_698f6`, `Frameset_698f9`, `Frameset_698fc`, `Frameset_698ff`
- Octohon: `Data_4a5a9`, `Data_60d50`, `Frameset_69b2f`, `Frameset_69b41`, `Frameset_69b4c`, `Frameset_69b57`, `Frameset_69b69`, `Frameset_69b74`, `Frameset_69b7f`, `Frameset_69b88`, `Frameset_69bc3`, `Frameset_69bce`
- Omodonmeka: `Data_40000`, `Data_604e0`, `Data_60500`, `Frameset_68f0b`, `Frameset_68f14`, `Frameset_68f1d`, `Frameset_68f26`, `Frameset_68f2b`, `Frameset_68f34`, `Frameset_68f3d`, `Frameset_68f42`, `Frameset_68f45`, `Frameset_68f50`
- Owl: `Frameset_69318`, `Frameset_6936c`, `Frameset_69377`
- ParaGoom: `Data_60530`, `Frameset_68442`, `Frameset_6844b`, `Frameset_68454`, `Frameset_6845d`, `Frameset_6846e`, `Frameset_6847f`, `Frameset_68490`, `Frameset_684a1`, `Frameset_684aa`, `Frameset_684af`, `Frameset_684b4`, `Frameset_684b7`, `Frameset_684cb`, `Frameset_684d2`, `Frameset_684d9`, `Frameset_684e0`, `Frameset_684e7`, `Frameset_6850a`, `Frameset_6852d`, `Frameset_68546`, `Frameset_6855f`
- Pesce: `Frameset_6990a`, `Frameset_69911`, `Frameset_69918`, `Frameset_6991f`, `Frameset_69926`, `Frameset_6992d`, `Frameset_69934`, `Frameset_6993b`, `Frameset_69942`, `Frameset_69949`, `Frameset_69950`, `Frameset_69957`, `Frameset_6995e`, `Frameset_69965`, `Frameset_6996c`, `Frameset_69973`, `Frameset_6997a`, `Frameset_69981`, `Frameset_69988`, `Frameset_6998f`, `Frameset_69996`, `Frameset_6999d`, `Frameset_699a4`, `Frameset_699ab`, `Frameset_699b2`, `Frameset_699b7`, `Frameset_699bc`, `Frameset_699c1`, `Frameset_699c6`, `Frameset_699cb`, `Frameset_699d0`, `Frameset_699d5`, `Frameset_699da`, `Frameset_699df`, `Frameset_69a15`
- PillarPlatform: `Frameset_6975b`, `Frameset_6975e`
- Pneumo: `Data_44000`, `Data_60600`, `Frameset_68c5c`, `Frameset_68c7f`, `Frameset_68c84`, `Frameset_68c89`, `Frameset_68c8e`
- PrinceFroggy: `Frameset_68ac6`, `Frameset_68add`, `Frameset_68ae6`, `Frameset_68ae9`, `Frameset_68af2`, `Frameset_68b01`
- RoboMouse: `Frameset_691de`, `Frameset_691e5`, `Frameset_691f2`, `Frameset_691fb`, `Frameset_69200`, `Frameset_69205`, `Frameset_6920c`, `Frameset_69213`, `Frameset_69220`, `Frameset_69227`
- Rock: `Frameset_69bfe`, `Frameset_69c01`
- Scowler: `Data_60a60`, `Data_60a70`, `Data_60a80`, `Data_60a90`, `Frameset_69a5f`, `Frameset_69a68`, `Frameset_69a71`, `Frameset_69a7a`, `Frameset_69a95`, `Frameset_69aa8`, `Frameset_69ab3`, `Frameset_69abc`, `Frameset_69ac3`, `Frameset_69af5`, `Frameset_69b03`, `Frameset_69b08`, `Pals_54c87`, `Pals_54c9f`, `Pals_54cb7`, `Pals_54cf7`
- SeeingEyeDoor: `Frameset_68c36`, `Frameset_68c47`, `Frameset_68c4a`, `Frameset_68c50`, `Frameset_68c56`, `Frameset_68c59`
- Shoot: `Data_54000`, `Data_54010`, `Data_60e20`, `Data_60e40`, `Data_60e70`, `Data_60e90`, `Data_60ea0`, `Frameset_69f35`, `Frameset_69f40`, `Frameset_69f54`, `Frameset_69f5d`, `Frameset_69f66`, `Frameset_69f6f`, `Frameset_69f7c`, `Frameset_69f8a`, `Frameset_69f93`, `Frameset_69f9a`, `Frameset_69f9f`, `Frameset_69fa4`, `Frameset_69fa9`, `Frameset_69fba`, `Frameset_69fcf`, `Frameset_69fdc`, `Frameset_69fed`, `Frameset_69ff2`, `Frameset_69ffd`, `Frameset_6a000`, `Frameset_6a00b`, `Frameset_6a00e`, `Frameset_6a017`, `Frameset_6a022`, `Frameset_6a02b`, `Frameset_6a02e`, `Frameset_6a031`, `Frameset_6a034`, `Frameset_6a037`, `Frameset_6a03a`, `Frameset_6a043`, `Frameset_6a046`, `Frameset_6a049`, `Frameset_6a04c`, `Frameset_6a04f`
- Silky: `Frameset_68744`, `Frameset_6874d`, `Frameset_68756`, `Frameset_6875f`, `Frameset_68768`, `Frameset_68771`, `Frameset_6877a`, `Frameset_68783`, `Frameset_6878c`, `Frameset_68795`, `Frameset_6879e`, `Frameset_687a7`, `Frameset_687b0`, `Frameset_687bb`, `Frameset_687c6`
- SmallLeaf: `Frameset_68a9f`, `Frameset_68aa8`, `Frameset_68abb`
- Snake: `Frameset_68804`, `Frameset_6881d`, `Frameset_68836`, `Frameset_6883d`, `Frameset_68844`, `Frameset_6884b`, `Frameset_68852`, `Frameset_6886f`, `Frameset_6888c`, `Frameset_688a9`, `Frameset_688c6`, `Frameset_688e3`, `Frameset_68900`, `Frameset_6891d`
- Spark: `Frameset_69bd9`
- SpearBot: `Frameset_68ddf`, `Frameset_68de8`, `Frameset_68df1`, `Frameset_68df8`, `Frameset_68dff`, `Frameset_68e08`, `Frameset_68e11`, `Frameset_68e14`, `Frameset_68e17`, `Frameset_68e20`, `Frameset_68e29`, `Frameset_68e2e`, `Frameset_68e33`, `Frameset_68e3a`, `Frameset_68e41`, `Frameset_68e4c`, `Frameset_68e57`, `Frameset_68e60`, `Frameset_68e69`, `Frameset_68e70`
- Spearhead: `Data_601c0`, `Data_601e0`, `Frameset_681db`, `Frameset_681e4`, `Frameset_681ed`, `Frameset_681f6`, `Frameset_681ff`, `Frameset_68208`, `Frameset_68213`, `Frameset_6821e`, `Frameset_68229`, `Frameset_68234`, `Frameset_6824f`, `Frameset_6825a`, `Frameset_68265`, `Frameset_6826e`, `Frameset_68277`, `Frameset_6827c`, `Frameset_68287`, `Frameset_68292`, `Frameset_6829b`
- Stove: `Frameset_69615`, `Frameset_69618`, `Frameset_69625`
- SunMoon: `Data_60690`, `Data_606e0`, `Data_606f0`, `Frameset_68f74`, `Frameset_68f8f`, `Frameset_68f9e`, `Frameset_68fb7`, `Frameset_68fc0`, `Frameset_68fc9`, `Frameset_68fd0`, `Frameset_68fd9`, `Frameset_68ff4`, `Frameset_69003`, `Frameset_69024`, `Frameset_6902b`, `Frameset_69036`
- Tadpole: `Data_60a20`, `Data_60a40`, `Frameset_69a1a`, `Frameset_69a1d`, `Frameset_69a26`, `Frameset_69a30`, `Frameset_69a33`, `Frameset_69a3d`
- Teruteru: `Frameset_68b64`, `Frameset_68b6d`, `Frameset_68b76`, `Frameset_68b7d`, `Frameset_68b84`, `Frameset_68b8b`, `Frameset_68b90`, `Frameset_68b99`, `Frameset_68ba2`, `Frameset_68ba5`, `Frameset_68bae`
- Togeba: `Data_60760`, `Frameset_69230`, `Frameset_6924b`, `Frameset_69256`, `Frameset_69263`, `Frameset_6926c`, `Frameset_69275`, `Frameset_6927c`
- Torch: `Frameset_68359`, `Frameset_68360`, `Frameset_68369`
- UnusedFlower: `Frameset_6837a`, `Frameset_68389`, `Frameset_683ac`, `Frameset_683b1`
- WaterDrop: `Frameset_69761`, `Frameset_69772`, `Frameset_69775`
- WaterSpark: `Frameset_69b12`, `Frameset_69b1e`
- Webber: `Data_604a0`, `Frameset_682a4`, `Frameset_682a9`, `Frameset_682b2`, `Frameset_682b7`, `Frameset_682c2`, `Frameset_682c5`, `Frameset_682d1`, `Frameset_682d6`, `Frameset_682db`, `Frameset_682e2`
- Wolfenboss: `Data_60d60`, `Data_60d80`, `Data_60da0`, `Data_60e00`, `Frameset_69dcb`, `Frameset_69dd5`, `Frameset_69dde`, `Frameset_69de7`, `Frameset_69dec`, `Frameset_69df1`, `Frameset_69df6`, `Frameset_69dfb`, `Frameset_69e00`, `Frameset_69e05`, `Frameset_69e0e`, `Frameset_69e1f`, `Frameset_69e39`, `Frameset_69e42`, `Frameset_69e4b`, `Frameset_69e59`, `Frameset_69e60`, `Frameset_69e72`, `Frameset_69e80`, `Frameset_69e85`, `Frameset_69e8e`, `Frameset_69e97`, `Frameset_69ea0`, `Frameset_69ea9`, `Frameset_69eb2`
- Wormwould: `Data_608b0`, `Data_60900`, `Data_60dd0`, `Frameset_696bc`, `Frameset_696c5`, `Frameset_696ce`, `Frameset_696d7`, `Frameset_696e0`, `Frameset_696e5`, `Frameset_696ea`, `Frameset_696f3`, `Frameset_69701`, `Frameset_6970a`, `Frameset_69713`, `Frameset_6971c`, `Frameset_69721`, `Frameset_69726`, `Frameset_6972f`, `Frameset_69734`
- YellowBelly: `Data_60950`, `Data_609e0`, `Data_60a00`, `Data_60a10`, `Frameset_69780`, `Frameset_69789`, `Frameset_69792`, `Frameset_697a1`, `Frameset_697b0`, `Frameset_697bb`, `Frameset_697c6`, `Frameset_697d5`, `Frameset_697e6`, `Frameset_697eb`, `Frameset_69845`, `Frameset_6987f`, `Frameset_69882`, `Frameset_69893`, `Frameset_69896`, `OAM_191940`, `OAM_191f04`, `Pals_51c81`, `Pals_51c99`, `Pals_51cb1`, `Pals_51cc9`, `Pals_51ce1`
- ZipLine: `Frameset_691c4`, `Frameset_691c9`, `Frameset_691d2`, `Frameset_691db`
- Zombie: `Data_60560`, `Data_605a0`, `Frameset_68d1a`, `Frameset_68d1f`, `Frameset_68d24`, `Frameset_68d2b`, `Frameset_68d81`, `Frameset_68d8a`, `Frameset_68d93`, `Frameset_68d9c`, `Frameset_68da5`, `Frameset_68dac`, `Frameset_68dd5`, `Frameset_68dda`

**scene**

- EpilogueSceneObj: `Frameset_15ed91`, `Frameset_15ed94`, `Frameset_15ed97`, `Frameset_15ed9a`, `Frameset_15ed9d`, `Frameset_15eda6`, `Frameset_15edb3`, `Frameset_15edc0`, `Frameset_15edc3`, `Frameset_15edc6`, `Frameset_15ede9`, `Frameset_15edf2`, `Frameset_15ee0f`, `Frameset_15ee1e`, `Frameset_15ee3b`, `Frameset_15ee44`, `Frameset_15ee57`, `Frameset_15ee64`, `Frameset_15ee67`, `Frameset_15ee70`, `Frameset_15ee79`, `Frameset_15ee82`, `Frameset_15ee87`, `Frameset_15ee8a`, `OAM_15e97d`
- PrologueSceneObj: `Frameset_15e741`, `Frameset_15e748`, `Frameset_15e74b`, `Frameset_15e774`, `Frameset_15e77d`, `Frameset_15e780`, `Frameset_15e783`, `Frameset_15e78a`, `Frameset_15e793`, `Frameset_15e7a3`, `Frameset_15e7a6`, `Frameset_15e7b7`, `Frameset_15e7c4`, `Frameset_15e7f0`, `Frameset_15e7f5`, `Frameset_15e7fa`, `Frameset_15e801`, `Frameset_15e80a`, `Frameset_aad0b`
- SceneWario: `Frameset_16b5a`, `Frameset_16b63`, `Frameset_1fc316`, `Frameset_1fc485`, `Frameset_1fc488`, `Frameset_aa6a5`, `Frameset_aa6c2`, `Frameset_aa6c7`, `Frameset_aa6ca`, `Frameset_aa8ec`, `Frameset_aa8f5`, `Frameset_aa902`, `Frameset_aa90d`, `Frameset_aa913`, `Frameset_aa924`, `Frameset_aa931`, `Frameset_aab27`, `Frameset_aab32`, `Frameset_aab3f`, `Frameset_aab42`, `Frameset_aab45`, `Frameset_aacf7`, `Frameset_aacfa`, `Frameset_ab03c`, `Frameset_ab06b`, `Frameset_ab08c`, `Frameset_ab098`, `Frameset_ab09d`, `Frameset_ab0ac`, `Frameset_ab14d`, `Frameset_ab160`, `Frameset_ab163`, `Frameset_d4de4`
- TempleSceneObj: `Frameset_15e88d`, `Frameset_15e890`, `Frameset_15e893`, `Frameset_15e896`, `Frameset_15e899`, `Frameset_15e89c`, `Frameset_15e89f`, `Frameset_15e8a2`, `Frameset_15e8a5`, `Frameset_15e8a8`, `Frameset_15e8ab`, `Frameset_15e8b0`, `Frameset_15e932`, `Frameset_15e95c`, `OAM_15e813`

**wario**

- WarioAirborne: `Frameset_15f8e`, `Frameset_1604e`
- WarioAttacking: `Frameset_1521c`
- WarioAttackingAirborne: `Frameset_1523e`, `Frameset_15249`
- WarioBallAirborne: `Frameset_1dd2f3`, `Frameset_1dd2f6`
- WarioBallOStringKnockBack: `Frameset_17409`, `Frameset_1742a`
- WarioBallShot: `Frameset_1dd27a`, `Frameset_1dd2d1`
- WarioBallStart: `Frameset_1dd313`, `OAM_1dcff1`
- WarioBallTurning: `Frameset_1dd287`, `Frameset_1dd28e`
- WarioBatIdling: `Frameset_1fd45f`
- WarioBatTransforming: `Frameset_1fd40a`
- WarioBouncyAirborne: `Frameset_1fcc75`
- WarioBouncyFloor: `Frameset_1fcc5f`
- WarioBouncyStart: `OAM_1fc95e`
- WarioBouncyUpsideDown: `Frameset_1fcc82`, `Frameset_1fcc85`
- WarioCrazy: `OAM_1fccd5`
- WarioCrazySpinning: `Frameset_14ccc`, `Frameset_14ce1`
- WarioCrazyTurning: `Frameset_1fcfd0`, `Frameset_1fcfd7`
- WarioElectric: `Frameset_17b9e`, `Frameset_17bad`
- WarioElectricStart: `Frameset_17b7c`, `Frameset_17b8d`
- WarioFanLifting: `Frameset_1dc374`, `Frameset_1dc3b8`
- WarioFanRecovering: `Frameset_1dc384`, `Frameset_1dc3c8`
- WarioFanSpinning: `Frameset_1dc393`
- WarioFanStart: `Frameset_1dc37f`, `Frameset_1dc3c3`, `OAM_1dc000`
- WarioFanTurning: `Frameset_1dc389`, `Frameset_1dc38e`
- WarioFatBumping: `Frameset_178fc`, `Frameset_17905`
- WarioFatIdling: `Frameset_1781c`, `Frameset_1781f`
- WarioFatRecovering: `Frameset_17844`, `Frameset_1785b`
- WarioFatTurning: `Frameset_178ea`, `Frameset_178f3`
- WarioFatWalking: `Frameset_17822`, `Frameset_1782b`
- WarioFenceMovingHorizontal: `Frameset_158e7`, `Frameset_158f2`
- WarioFlatAirborne: `Frameset_171bd`
- WarioFlatIdling: `Frameset_1718b`
- WarioFlatSinking: `Frameset_1719a`
- WarioFlatSquishedLifting: `Frameset_1716c`
- WarioFlatWalking: `Frameset_17175`
- WarioGetTreasureLookFront: `Frameset_1fc30d`
- WarioGetTreasureTurnBack: `Frameset_1fc2c4`
- WarioGetTreasureTurnFront: `Frameset_1fc2ab`
- WarioGettingFlatAirborne: `Frameset_1715f`
- WarioGrabAirborne: `Frameset_15fd2`, `Frameset_15fdf`, `Frameset_15fec`, `Frameset_15fef`, `Frameset_16020`, `Frameset_16037`, `Frameset_1605c`, `Frameset_16063`
- WarioHot: `Frameset_16e47`, `Frameset_16e72`, `OAM_16b6c`
- WarioIceSkatin: `Frameset_1fdd94`, `Frameset_1fdd97`
- WarioIceSkatinCrash: `Frameset_1fdd9a`, `Frameset_1fdda7`
- WarioIceSkatinStart: `Frameset_1fdd82`, `Frameset_1fdd8b`, `OAM_1fdb6d`
- WarioLadderScratching: `Frameset_15903`, `Frameset_15924`
- WarioLadderShakeStunned: `Frameset_15948`
- WarioLaunched: `Frameset_1dc8fb`, `Frameset_1dc904`, `Frameset_1dc90d`, `Frameset_1dc926`, `OAM_1dc449`
- WarioMagicRising: `Frameset_1dcfb0`, `OAM_1dcd60`
- WarioPuffyDeflating: `Frameset_1dccee`, `Frameset_1dcd01`, `Frameset_1dcd1e`, `Frameset_1dcd31`
- WarioPuffyInflating: `Frameset_1dccc0`, `Frameset_1dccc9`, `OAM_1dc93f`
- WarioPuffyRising: `Frameset_1dcd4e`, `Frameset_1dcd57`
- WarioPuffyTurning: `Frameset_1dccd8`, `Frameset_1dcce3`
- WarioSleeping: `Frameset_1421c`, `Frameset_14225`, `Frameset_1422e`, `Frameset_14237`, `Frameset_14240`, `Frameset_14249`
- WarioSliding: `Frameset_16708`
- WarioSnowballCrash: `Frameset_1ff981`
- WarioSnowballRolling: `Frameset_1ff938`, `Frameset_1ff945`, `Frameset_1ff963`, `Frameset_1ff970`
- WarioSnowmanBumped: `Frameset_1ff628`, `Frameset_1ff639`
- WarioSnowmanIdle: `Frameset_1ff5f8`, `Frameset_1ff5fb`
- WarioSnowmanTurning: `Frameset_1ff5fe`, `Frameset_1ff605`
- WarioSnowmanWalking: `Frameset_1ff5e6`, `Frameset_1ff5ef`
- WarioSplitHit: `Frameset_1ffd10`, `Frameset_1ffd13`, `Frameset_1ffd16`, `Frameset_1ffd19`, `OAM_1ffa12`
- WarioSplitKnockedBack: `Frameset_1ffc8e`, `Frameset_1ffccf`
- WarioSwallowed: `OAM_1dc3cd`
- WarioThrowCharging: `Frameset_1642c`, `Frameset_16432`
- WarioThrowFullyCharged: `Frameset_16403`, `Frameset_16438`
- WarioThrowingAirborne: `Frameset_15fae`, `Frameset_15fb3`
- WarioTryingSubmerge: `Frameset_155b0`, `Frameset_155b7`
- WarioTurningIntoSnowman: `Frameset_1ff560`, `Frameset_1ff5a3`, `OAM_1feec7`
- WarioTurningInvisible: `Frameset_17e1b`, `Frameset_17e3a`, `OAM_17cf7`
- WarioUnderwaterThrusting: `Frameset_15562`, `Frameset_155be`
- WarioVampireIdling: `Frameset_1fd81c`
- WarioVampireTurning: `Frameset_1fd83a`, `Frameset_1fd841`
- WarioVampireWalking: `Frameset_1fd825`
- WarioZombieIdling: `Frameset_1fc8b6`, `Frameset_1fc8b9`, `OAM_1fc48b`
- WarioZombieKnockBack: `Frameset_1fc92e`, `Frameset_1fc93b`
- WarioZombieLanding: `Frameset_1fc8bc`, `Frameset_1fc8d5`, `Frameset_1fc928`, `Frameset_1fc92b`, `Frameset_1fc948`, `Frameset_1fc953`
- WarioZombieSlippingThroughFloor: `Frameset_1fc8ee`, `Frameset_1fc90b`
- WarioZombieTurning: `Frameset_1fc894`, `Frameset_1fc89d`
- WarioZombieWalking: `Frameset_1fc870`, `Frameset_1fc879`
- WarioZombieWrithing: `Frameset_1fc882`, `Frameset_1fc88b`

### 3f. Remaining overworld routines

#### Map-side object state entries (bulk rule, bank2d)

The 2b rule said to name the ~150 one-line state entries after their
frameset, "or by slot (`NorthOWObjState_01`) until then". By slot,
generated from the four jumptables (`Func_b4fab` North 44 entries,
`Func_b4ba2` East 35, `Func_b4ccb` South 33, `Func_b4e04` West 36), in the
`.State3b` hex style of spearhead.asm: `<Side>OWObjStateXX`. 139 labels
(slot 0 is `Func_b4000`, `OWObjState_None`; `Func_b4e8b` fills West slots 5
and 9 and takes the first). High as a mechanical rule; no collisions.

Correction to 2b and to 3a: the East table has 35 entries, not 36, the
same as `Func_b7b61` (`UpdateEastOWObjMapAnim`), so the "reads past it"
remark in the 3a row doesn't apply.

`Func_b4be9` EastOWObjState01; `Func_b4bee` EastOWObjState02; `Func_b4bf3` EastOWObjState03; `Func_b4bf8` EastOWObjState04; `Func_b4bfd` EastOWObjState05; `Func_b4c02` EastOWObjState06; `Func_b4c07` EastOWObjState07; `Func_b4c0c` EastOWObjState08; `Func_b4c16` EastOWObjState09; `Func_b4c1b` EastOWObjState0a; `Func_b4c25` EastOWObjState0b; `Func_b4c2a` EastOWObjState0c; `Func_b4c2f` EastOWObjState0d; `Func_b4c39` EastOWObjState0e; `Func_b4c3e` EastOWObjState0f; `Func_b4c43` EastOWObjState10; `Func_b4c48` EastOWObjState11; `Func_b4c4d` EastOWObjState12; `Func_b4c52` EastOWObjState13; `Func_b4c6d` EastOWObjState14; `Func_b4c72` EastOWObjState15; `Func_b4c77` EastOWObjState16; `Func_b4c7c` EastOWObjState17; `Func_b4c81` EastOWObjState18; `Func_b4c86` EastOWObjState19; `Func_b4c8b` EastOWObjState1a; `Func_b4c95` EastOWObjState1b; `Func_b4c9f` EastOWObjState1c; `Func_b4ca4` EastOWObjState1d; `Func_b4cae` EastOWObjState1e; `Func_b4cb3` EastOWObjState1f; `Func_b4cb8` EastOWObjState20; `Func_b4cbd` EastOWObjState21; `Func_b4c11` EastOWObjState22; `Func_b5004` NorthOWObjState01; `Func_b5009` NorthOWObjState02; `Func_b500e` NorthOWObjState03; `Func_b5013` NorthOWObjState04; `Func_b5018` NorthOWObjState05; `Func_b501d` NorthOWObjState06; `Func_b5022` NorthOWObjState07; `Func_b5027` NorthOWObjState08; `Func_b5031` NorthOWObjState09; `Func_b5036` NorthOWObjState0a; `Func_b5040` NorthOWObjState0b; `Func_b5045` NorthOWObjState0c; `Func_b504f` NorthOWObjState0d; `Func_b5059` NorthOWObjState0e; `Func_b505e` NorthOWObjState0f; `Func_b5063` NorthOWObjState10; `Func_b5068` NorthOWObjState11; `Func_b506d` NorthOWObjState12; `Func_b5072` NorthOWObjState14; `Func_b5077` NorthOWObjState15; `Func_b5093` NorthOWObjState16; `Func_b509d` NorthOWObjState17; `Func_b50a7` NorthOWObjState18; `Func_b50ac` NorthOWObjState1a; `Func_b50b1` NorthOWObjState1c; `Func_b50b6` NorthOWObjState1d; `Func_b50c0` NorthOWObjState1e; `Func_b50ca` NorthOWObjState1f; `Func_b50cf` NorthOWObjState20; `Func_b50d4` NorthOWObjState21; `Func_b50d9` NorthOWObjState22; `Func_b50de` NorthOWObjState23; `Func_b50ea` NorthOWObjState24; `Func_b50f6` NorthOWObjState25; `Func_b50fb` NorthOWObjState26; `Func_b5105` NorthOWObjState27; `Func_b510a` NorthOWObjState28; `Func_b512a` NorthOWObjState29; `Func_b5130` NorthOWObjState2a; `Func_b5136` NorthOWObjState2b; `Func_b4d0e` SouthOWObjState01; `Func_b4d14` SouthOWObjState02; `Func_b4d1f` SouthOWObjState03; `Func_b4d25` SouthOWObjState04; `Func_b4d2b` SouthOWObjState05; `Func_b4d31` SouthOWObjState06; `Func_b4d3c` SouthOWObjState07; `Func_b4d41` SouthOWObjState08; `Func_b4d4b` SouthOWObjState09; `Func_b4d50` SouthOWObjState0a; `Func_b4d55` SouthOWObjState0b; `Func_b4d5a` SouthOWObjState0c; `Func_b4d5f` SouthOWObjState0d; `Func_b4d64` SouthOWObjState0e; `Func_b4d69` SouthOWObjState0f; `Func_b4d6e` SouthOWObjState10; `Func_b4d73` SouthOWObjState11; `Func_b4d78` SouthOWObjState12; `Func_b4d7d` SouthOWObjState13; `Func_b4d87` SouthOWObjState14; `Func_b4d91` SouthOWObjState15; `Func_b4d96` SouthOWObjState16; `Func_b4d9b` SouthOWObjState17; `Func_b4db6` SouthOWObjState18; `Func_b4dbb` SouthOWObjState19; `Func_b4dc0` SouthOWObjState1a; `Func_b4ddd` SouthOWObjState1b; `Func_b4de2` SouthOWObjState1c; `Func_b4de7` SouthOWObjState1d; `Func_b4df1` SouthOWObjState1e; `Func_b4df6` SouthOWObjState20; `Func_b4e77` WestOWObjState01; `Func_b4e7c` WestOWObjState02; `Func_b4e81` WestOWObjState03; `Func_b4e86` WestOWObjState04; `Func_b4e8b` WestOWObjState05; `Func_b4ea4` WestOWObjState06; `Func_b4ea9` WestOWObjState07; `Func_b4ebd` WestOWObjState08; `Func_b4ec2` WestOWObjState0a; `Func_b4ec8` WestOWObjState0b; `Func_b4ed2` WestOWObjState0c; `Func_b4ed8` WestOWObjState0d; `Func_b4ee3` WestOWObjState0e; `Func_b4ee9` WestOWObjState0f; `Func_b4ef4` WestOWObjState10; `Func_b4eff` WestOWObjState11; `Func_b4f05` WestOWObjState12; `Func_b4f0b` WestOWObjState13; `Func_b4f16` WestOWObjState14; `Func_b4f1c` WestOWObjState15; `Func_b4f22` WestOWObjState16; `Func_b4f28` WestOWObjState17; `Func_b4f2e` WestOWObjState18; `Func_b4f34` WestOWObjState19; `Func_b4f3a` WestOWObjState1a; `Func_b4f40` WestOWObjState1b; `Func_b4f46` WestOWObjState1c; `Func_b4f4c` WestOWObjState1d; `Func_b4f52` WestOWObjState1e; `Func_b4f82` WestOWObjState1f; `Func_b4f8a` WestOWObjState20; `Func_b4f90` WestOWObjState21; `Func_b4f96` WestOWObjState22; `Func_b4f9c` WestOWObjState23

#### bank20: map-side main loop, temple hint, path preview, scene actions

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_80ee7`, `Func_80f0d`, `Func_80f3c`, `Func_80fb8`, `Func_80fd6`, `Func_80ff7`, `Func_810bb`, `Func_8115c`, `Func_811cf`, `Func_81200`, `Func_81346` | bank20.asm:52-699 | `MapSide_Init`, `MapSide_DayNightTransition`, `MapSide_ArriveAtLevel`, `MapSide_LoadLevelName`, `MapSide_FadeInLevelName`, `MapSide_Idle`, `MapSide_StartPath`, `MapSide_Walk`, `MapSide_WalkOffEdge`, `MapSide_ChangeSide`, `MapSide_TempleHint` | The 11 `w2d013` steps of `Func_80e89` (`HandleMapSide`), in table order. Init: current point as target, clears fades; 1: pending day/night switch (`wDayNight` bit 7) or `PlayOverworldMusic`; 2: arrived at a point (loads the level, D-pad already held in an allowed direction starts walking at once; exits go straight to step 6); 3/4: load and fade in the level name; 5: waits for input (A enters the level via `Func_81240`, SELECT opens the bars, B path preview, UP at the Temple, START best times, D-pad walks); 6: sets the path's end point and shape and starts the line; 7: walks (two line steps per frame when running), at the end goes to step 2 or, for an exit, plays `SFX_0EB`; 8: walks off the screen edge; 9: switches `wNextMapSide` and the substate; 10: the temple hint. | high |
| `Func_81034` | :222 | `MapSide_StartWalking` | Fall-through tail of step 5 (also jumped to from step 2): sets the direction, `Func_820e6`, requests the level-name fade-out ($03 in `w2d0e0`), next step. | high |
| `Func_810a9` | :269 | `GetPressedOWDirection` | `wJoypadPressed` D-pad, with up/down taking precedence over left/right; `Func_80f3c.GetDirectionalInput` is the same on `wJoypadDown`. | high |
| `Func_810fc` | :329 | `SetNextPathWaypoint` | Dispatches on the path shape at `bc` (`PATH_*`), sets `wOWCoords2` to the next corner and the shape to the next segment; returns $ff when the path is done. | high |
| `Func_81142` | :387 | `SetOWWarioWalkDirection` | Sets `wLevelArrowDirections1` (which picks Wario's sprite) from the line flags `w2d0a0`. | medium |
| `Func_81240` | :522 | `HandleEnterLevelInput` | A pressed on a level point: `ST_LEVEL`, or `SST_OVERWORLD_1A` at the Temple; carry when taken. | high |
| `Func_820e6` | :3186 | `SetPathFromArrowDirection` | Reads the current point's connections (`Func_82111`) in the direction of `wLevelArrowDirections1` (right/left/up/down) into `w2d068` (target point) and `wOWPathShape`. | high |
| `Func_8139f`, `Func_813ad`, `Func_813b4`, `Func_813ef`, `Func_813f6`, `Func_81413`, `Func_8142d` | :732-811 | `TempleHint_WaitThenFadeOutName`, `TempleHint_WaitNameFadedOut`, `TempleHint_LoadNextTreasureLevelName`, `TempleHint_ResetPalFade`, `TempleHint_FadeInName`, `TempleHint_WaitInput`, `TempleHint_End` | Entries of `Func_8137a`'s table (`UpdateTempleHint`): wait 8 frames and request the fade-out; wait for it; load the name of the level with the next treasure; reset the fade steps; fade in and show scene object 13 (state $1c); wait for B/LEFT/RIGHT/DOWN or the object to finish; then the old name comes back the same way and `TempleHint_End` faces Wario down and resets the steps. | high |
| `Func_814b2`, `Func_814bd`, `Func_814c4`, `Func_814ec`, `Func_8150c` | :874-967 | `PathPreview_SaveWarioPos`, `AdvancePathPreview`, `PathPreview_Wait`, `PathPreview_InitTracers`, `PathPreview_RunTracers` | `Func_81477` (`HandlePathPreview`) table: save Wario's position (into `w2d88e`); the step helper (clears `w2d0e2`, increments `w2d0e3`); after 10 frames put Wario on the level point with the arrows sprite (`SFX_113`); clear the tracers and get the paths pointer; run the 4 tracers (sprites spawned at frames $14/$28, cleared at $2c/$40) until all are done (state 5). Locals of the last: `.Func_81576` / `.Func_81595` -> `.load_tracer` / `.save_tracer`, `.Func_815b6` -> `.get_tracer_ptr`, `.Func_815c1` / `.Func_815e5` -> `.copy_tracer_sprites_1` / `.copy_tracer_sprites_2`, `.Func_81609` -> `.clear_tracer_sprites`. | high |
| `Func_8143d` | :814 | `UnreferencedPathPreviewStep` | Marked unreferenced: runs the init/run tracer steps once with Wario moved to the level point and restored. | low |
| `Func_80de0` | src/engine/overworld/best_times/common.asm:1 | `HandleBestTimesInput` | In time attack mode, START opens `SST_OVERWORLD_BEST_TIMES`; called from `MapSide_Idle`. | high |
| `Func_818ad` | bank20.asm:1487 | `RunOWScene` | Called by `UpdateOWScene` (init.asm:200): a 3-step `w2d013` table, B on the top bar ends the scene. `Func_818e7` -> `RunOWScene_Wait` (4 frames), `Func_818ed` -> `RunOWScene_Next`, `Func_818f6` -> `RunOWScene_DoAction` (until `wOWSceneActionParam` is 0), `Func_81900` -> `RunOWScene_NextParams` (next scene params: same side restarts, other side switches to substate 4, none left ends). | high |
| `Func_81931` | :1548 | `EndOWScene` | Clears the event and scene action; epilogue -> `SST_OVERWORLD_EPILOGUE`, else next substate and `Func_803e6` (save). | high |
| `Func_8195d` | :1570 | `DoOWSceneAction` | Jumptable on `wOWSceneAction` (`UnlockLevel`, `DoOWFunction`, `Func_82c33`); slot 0 `.InvalidAction`. | high |
| `Func_81dce` | :2712 | `InitOWScenesForMapSide` | Called by init.asm:360, 499: for every event, `w2d065` = unlocked/just unlocked, then runs each of its scene params' init routine (`.DoInitFunc`) when it is on the current map side. | high |
| `Func_81e44` | :2787 | `InvalidOWSceneInitAction` | Slot 0 of `.DoInitFunc`, `debug_nop`. | high |
| `Func_82a79`, `Func_82a96`, `Func_82a9b`, `Func_82aae`, `Func_82ad2`, `Func_82aea`, `Func_82b22`, `Func_82b67`, `Func_82b7b`, `Func_82baa` | :4733-4907 | `UnlockLevel_Init`, `UnlockLevel_GetArrows`, `UnlockLevel_WaitHighlight`, `UnlockLevel_ShowArrow1`, `UnlockLevel_HighlightTileAndAdvance`, `UnlockLevel_ShowArrow2`, `UnlockLevel_ShowLevelPoint`, `UnlockLevel_WaitHighlight30`, `UnlockLevel_ShowStar`, `UnlockLevel_End` | Steps of `UnlockLevel` (`w2d062`): get the unlocked level data; the arrows; wait while a highlight is pending (`w2d07f`) then 4 frames; draw the first / second arrow and the new point (`SFX_103`, `w2d07f = 1`, then `Func_81feb` + `Func_81f21`); wait 30; spawn the star sprite at the new point (`SFX_104`) and wait $40; clear the action. | high |
| `Func_82a0a`, `Func_82a26`, `Func_82a2f`, `Func_82a4e`, `Func_82a62` | :4680-4731 | `OWScene_FadeToGrey`, `OWScene_Wait20`, `OWScene_LoadLevelName`, `OWScene_FadeInLevelName`, `OWScene_LoadStarIndicatorPals` | Shared by `UnlockLevel` and `Func_82c33`: grey transition (source comment "fade to grey"); wait 20 frames; load the level name (exits skip the fade-in step); fade it in; after 16 frames `LoadOWStarIndicatorPals`. | high |
| `Func_82c33` | :4981 | `HighlightLevel` | The `HIGHLIGHT_LEVEL` scene action, the same structure as `UnlockLevel`. | high |
| `Func_82bb8` / `Func_82bda` | :4909 / :4926 | `DrawUnlockLevelStar` / `DrawHighlightLevelStar` | Animate and draw `wCurSceneObj` with `Frameset_aa544` / `Frameset_aa555` and `OAM_aa445` during `UNLOCK_LEVEL` / `HIGHLIGHT_LEVEL` (the second clears the state when the animation ends). | medium |
| `Func_82c1d` / `Func_82c22` / `Func_82c29` | :4962-4979 | (duplicates of `WaitOWFunc` / `AdvanceOWFunc` / `EndOWFunc`) | Byte-identical to the bank2d routines (bank2d.asm:3432-3457), like `Func_82a8d` in the second pass. If kept: `WaitOWFunc_Bank20` / `AdvanceOWFunc_Bank20` / `EndOWFunc_Bank20`. | high |
| `Func_82997` / `Func_829a1` | :4617 / :4623 | `DrawBottomBarTimeAttack` / `DrawBottomBarTimeAttackScore` | The second draws the four BCD digits of `w2d0ee`/`w2d0ef` as window sprites; the first adds the button prompt and the 8-coin. | medium / high |

#### bank21, bank26, bank2b_1, bank56

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_84b97` | bank21.asm:231 | `DaytimeTransition` | Only called by `EOWFunc_Daytime` (bank2d.asm:8285): a 7-step `wOWPalTransitionState` table built from `DayNightTransition`'s pieces (`.LoadBaseAndTargetPals`, `.FadeColours`, `.LoadPal1`), sets scene object 7 to state $13 halfway, and ends by clearing `w2d011` (day) and `wDayNight` (unless the bars are open). | medium |
| `Func_84c0d` | bank21.asm:302 | `DayNightSpellTransition` | Only called by `NOWFunc_DayNightSpell.DayNightTransition`: the same kind of table (`.Init` with `VBlank_OWPalTransition`, fades, `.LoadPal1/2`, `.SwitchDayNight`). | medium |
| `Func_84e43` | bank21.asm:711 | `FadeBGAndOBPals` | First call points `wPalConfig1`/`wPalConfig2` at all 8 `wTempBGPals`/`wTempOBPals` palettes; later calls step both (`Func_851d1`, `Func_851bc`) until done, then clear the step counts. Called from bank2b_1 and bank2b_2. | medium |
| `Func_ac9ca` | bank2b_1.asm:1497 | `FadeBGAndOBPalsAndAdvanceStep` | `Func_84e43` until done, then clears `w2d014` and increments `w2d013`. | high |
| `Func_ac9e9` / `Func_ac9e4` / `Func_ac9ec` | :1511 / 1507 / 1515 | `SetPalConfig1FromDE` / `SetPalConfig2FromDE` / `CopyPalConfigFromDE` | Copy 5 bytes from `de` to `wPalConfig1` / `wPalConfig2` / `hl`. | high |
| `Data_ac9f5`, `Data_ac9fa`, `Data_ac9ff`, `Data_aca04` | :1525-1543 | `PalConfig_BGFromTempPals1`, `PalConfig_BGFromTempBGPals`, `PalConfig_OB0FromTempOBPals`, `PalConfig_OBFromTempPals2` | The 5-byte configs those copy (register, index, count, big-endian source); the third has a count of 1. Used by bank2b_2. | high |
| `Func_aca09` | :1545 | `CopyTempPalsToBGOBPals_Bank2b1` | `wTempPals2 -> wTempOBPals`, `wTempPals1 -> wTempBGPals`: bank27's `Func_9cd74` (`CopyTempPalsToBGOBPals`) with the two copies swapped. | high |
| `Func_aca20` / `Func_aca25` / `Func_aca28` | :1557 / 1561 / 1563 | `UnreferencedFillTempPals1White` / `FillTempPals2White` / `Fill4PalsWhite` | Write `PALRGB_WHITE` to 32 colours (4 palettes) at `wTempPals1` / `wTempPals2` / `hl`; the first is marked unreferenced. | high |
| `Func_aca63` / `Func_aca68` | :1611 / 1617 | `MoveSceneWarioLeft` / `UnreferencedMoveSceneWarioRight` | Decrement / increment `wOWUIObj1XCoord`, which shares its address with `wSceneWarioXCoord` ($d141); the only caller is the epilogue (bank2b_2.asm:3064), where the Addenda already found `wOWUIObj1` written for Scene Wario. Another case of that union mislabel. | medium |
| `Func_aca9e`, `Func_acacd`, `Func_acae7`, `Func_acaf3` | :1653-1727 | `PrintTextPageWithHeader`, `WaitAButtonAndClearTextbox`, `PrintTextPageWithoutHeader`, `NextTextPageOrEnd` | Text steps used in the temple and prologue step tables next to the existing `InitTextPrinting` and `LoadCurTextPageBufferPage`: print until the page ends (`wCurTextLine == $80`), then next buffer page and next step; wait for A (except on page 1), hide the arrow (scene object 1) and clear the textbox; when the next page isn't the terminator, show the arrow and go back 3 steps, else next step with carry. | high |
| `Func_ac056` | :74 | `SceneObjState_TextArrow` | State 1 of the three scene object dispatchers (`Func_ac0b6`, `Func_ac409`, `UpdateTempleSceneObjAnimation`): animates `Frameset_76ca` with `OAM_75c3` (title gfx). Scene object 1 gets state 1 from `NextTextPageOrEnd` and 0 when the text continues, so this is the "more text" arrow. | medium |
| `Func_ad445` | :3024 | `HandleTempleMusicBoxScene` | Step $0c of the temple scene: runs `HandleTempleMusicBoxes` and its own `w2d890` table (`.ShowMusicBoxes`, `.SpawnMusicBoxes`, `.LowerHands`, ...), like the existing `HandleTempleShakeScene`. | high |
| `Func_ad557` | :3222 | (duplicate of `Func_ae915`, `AdvanceStepAtHL`) | Same 4 instructions; used by the `temple_music_box_hover` macro. If kept: `AdvanceStepAtHL_Bank2b1`. | high |
| `Func_9a9ec` / `Func_9a9f7` / `Func_9a9fd` | bank26.asm:1004 / 1013 / 1018 | `UpdateSceneObjAnim_Bank26` / `LoadSceneObjSpriteWithScroll_Bank26` / `SetSceneObjStateIfAnimFinished_Bank26` | `UpdateOWAnimation` / `LoadOWSpriteWithScroll` with `b = $26` (the routines' own bank, where the treasure collection's framesets and OAM live), and another copy of `SetObjStateIfAnimationIsFinished`. | high |
| `Func_9aa6c`, `Func_9aa6d`, `Func_9aa72`, `Func_9aa77`, `Func_9aa7c` | :1080-1097 | `TreasureCollectionObjState_None`, `TreasureCollectionObjState01`..`04` | The state table of `AnimateTreasureCollection.Func_9aa4a` (scene objects 1-10); each sets a frameset and jumps to `Func_9aa56`. | high |
| `Func_9aa56` / `Func_9aa59` / `Func_9aa60` | :1065 / 1067 / 1073 | `AnimateTreasureCollectionObj` / `DrawTreasureCollectionObj` / `UnreferencedAnimateTreasureCollectionObjThenSetState` | Animate then draw with `OAM_9ac5d`; the third is marked unreferenced. | high |
| `Func_9aab5` | :1129 | `LoadMapLevelTreasureData` | Called when Wario arrives at a level point (`MapSide_ArriveAtLevel`): the level's treasure IDs, bottom-bar flags and treasure tiles (HDMA from `wTileBuffer`), or the time attack score in that mode. Next to the existing `LoadLevelTreasureData`. | high |
| `Func_9aaf4` | :1160 | `CheckLevelMusicalCoinsForBottomBar` | Sets bit 6 of `wBottomBarFlags` (and resets the compass object) when all musical coins of `wOWLevel` were collected. | medium |
| `Func_9ab1c` | :1187 | `GetCurOWLevelCollectedTreasures` | `GetOWLevelCollectedTreasures` unless the point is the Temple (0) or none ($80). | high |
| `Func_15868e` | bank56.asm:721 | `UpdateNOWPrologueObjs` | Called every frame by `NOWFunc_Prologue` (bank2d.asm:3504): six small state machines (`w2d150`, ...) for the scene objects of that scene. | low |

#### bank27: cutscene set-up

**Rule: `InitCutsceneXX` tails.** 19 of the existing `InitCutsceneXX`
routines (bank27.asm:1-575) end with `jp Func_9xxxx`, a routine that places
the cutscene's scene objects (coordinates, `SetSceneObjState`,
`Func_9ccf9`) and usually draws them once through the cutscene's updater:
`InitCutsceneXXObjs`, keeping the existing numbering. Generated, high:
`Func_9d01a` InitCutscene06Objs; `Func_9d158` InitCutscene07Objs; `Func_9d0e6` InitCutscene0aObjs; `Func_9da0e` InitCutscene15Objs; `Func_9d536` InitCutscene1eObjs; `Func_9db85` InitCutscene24Objs; `Func_9d64b` InitCutscene27Objs; `Func_9dc6a` InitCutscene1fObjs; `Func_9ded4` InitCutscene30Objs; `Func_9e018` InitCutscene3aObjs; `Func_9e2b8` InitCutscene54Objs; `Func_9e438` InitCutscene4aObjs; `Func_9e4ae` InitCutscene4cObjs; `Func_9e5a1` InitCutscene4fObjs; `Func_9e655` InitCutscene51Objs; `Func_9e6ef` InitCutscene56Objs; `Func_9e79a` InitCutscene57Objs; `Func_9e855` InitCutscene58Objs; `Func_9e91a` InitCutscene55Objs.

| Current | Where | Proposed | Evidence | Conf. |
|---|---|---|---|---|
| `Func_9c25f` | bank27.asm:65 | `InitMusicBoxCutscene` | Shared tail of `InitCutscene08/10/17/1d/25` (the five music boxes), entered with that box's OB palettes in `hl`: BG palettes `Pals_b8200`, `LoadCutscenes2Gfx`, BG maps 01/04. | high |
| `Func_9c931` / `Func_9c937` | :609 / 613 | `LoadCutscenes7And5Gfx_Vram0` / `LoadCutscenes7And10Gfx_Vram0` | `LoadCutscenes7Gfx_Vram0` followed by `LoadCutscenes5Gfx_Vram0` / `LoadCutscenes10Gfx_Vram0`, next to the existing `LoadCutscenesNGfx_*` family (where the "5" part is implied, e.g. `LoadCutscenes1Gfx_Vram0` also loads set 5). | high |
| `Func_9c977` / `Func_9c97d` | :625 / 629 | `LoadCutscenes8And5Gfx_Vram1` / `LoadCutscenes8And10Gfx_Vram1` | Same with `LoadCutscenes8Gfx_Vram1`. | high |
| `Func_9cc4f` | :963 | `SetBGPriorityOn6x7Rect_Vram0` | Its header comment: fills a 6x7 attribute rectangle at (0, 5) with `BG_BANK0 \| BG_PRIO`; next to `SetBGPriorityOnTopRows_Vram0`. | high |
| `Func_9ea9e` / `Func_9eab4` | :5329 / 5341 | `MoveCutsceneObj10` / `MoveCutsceneObj11` | Called every frame by Cutscene58 (open crater hole) and Cutscene55 (drill holes): while `wSceneObj12YCoord` / `wSceneObj12XCoord` is non-zero (used as flags, not coordinates), move scene object 10 / 11 along `Data_9ec16` / `Data_9ec41` (`ApplyOWMovement`), then clear the flag and the object's state. | medium |

## Fourth pass

Same conventions as above. Every label is named by its current label in
`src/` (after batches 1-8 of "Applied"). New global names were checked by
script against `src/` and everything above (no collisions, no duplicates);
locals against the other locals of their scope.

### 4.0 Leftovers of the applied batches

A grep of `src/` for address-named labels that this file already names
found two kinds of leftovers.

#### Notable finding: comma lists applied as one name

Rows that map a comma list to a range (`.Func_a`, `.Func_b`, `.Func_c` ->
`.Rise1`..`.Rise3`) were applied by giving the *first* name of the range to
the *last* label of the list and leaving the others unnamed. Four groups
and one "same names as" row are affected; the jumptables (hand.asm:44-60,
nobiiru.asm:40-54) and code were re-read to confirm the order:

| File / scope | Current (wrong) | Should be | Still unnamed -> name | Conf. |
|---|---|---|---|---|
| hand.asm `HandFunc` | `.Rise1` (hand.asm:167, step 7) | `.Rise6` | `.Func_477f3`, `.Func_4780e`, `.Func_47825`, `.Func_4783c`, `.Func_47853` -> `.Rise1`, `.Rise2`, `.Rise3`, `.Rise4`, `.Rise5` | medium (as the 2d row) |
| hand.asm `HandFunc` | `.Sink1` (:290, step 13) | `.Sink4` | `.Func_478e1`, `.Func_47903`, `.Func_47925` -> `.Sink1`, `.Sink2`, `.Sink3` | medium |
| nobiiru.asm | `.Extend1` (:192, step 5) | `.Extend5` | `.Func_43876`, `.Func_438a0`, `.Func_438c5`, `.Func_438ea` -> `.Extend1`, `.Extend2`, `.Extend3`, `.Extend4` | medium |
| nobiiru.asm | `.Retract1` (:327, step 12) | `.Retract5` | `.Func_4396e`, `.Func_43994`, `.Func_439ba`, `.Func_439e0` -> `.Retract1`, `.Retract2`, `.Retract3`, `.Retract4` | medium |
| hidden_figure.asm `HiddenFigureRightHandFunc` | `.Slam` (:1635: waits `wCurObjStateDuration`, `MoveObjectDown` every other frame; set by `.Func_4d628` when `wHiddenFigureDefeatStarted`) | `.DefeatSink` | `.Func_4d465` -> `.Slam` (uses `wHiddenFigureRightHandSlamming`); `.Func_4d49f` -> `.Flinch`; `.Func_4d4b2` -> `.Grab`; `.Func_4d571` -> `.Swipe`; `.asm_4d5f5` -> `.return_to_idle`; `.Func_4d622` -> `.HoldWario`; `.Func_4d628` -> `.WaitDefeat` | high (as the 2a row) |

Rename the wrong ones first (`.Rise1` -> `.Rise6` before `.Func_477f3` ->
`.Rise1`, and so on). The ROM doesn't change either way; only the reading
does (the hand's `.Rise1` is really its last rise step, the right hand's
`.Slam` its defeat).

Same kind of slip: the third-pass row "`Func_ad557` | (duplicate of
`Func_ae915`, `AdvanceStepAtHL`)" was applied as a rename of `Func_ad557`
to `Func_ae915`, the first label in its Proposed column. So bank2b_1.asm:3222
now defines `Func_ae915` at $ad557 (the `temple_music_box_hover` macro jumps
to it), while the real `Func_ae915` is `AdvanceStepAtHL` in bank2b_2. The
label should go back to `Func_ad557`, or take the row's "if kept" name
`AdvanceStepAtHL_Bank2b1`. High.

#### High/medium proposals not applied

Proposals whose new name sat in the Evidence column, after a parenthesis,
or at the end of a bulk list, were skipped. Still valid (code re-checked),
one label per entry so they can be applied mechanically:

| Current | Where | Proposed | From | Conf. |
|---|---|---|---|---|
| `MoonFunc.Func_475c7`, `.Func_4763f`, `.Func_47699`, `.Func_476bd`, `.Func_476a9`, `.Func_476cd`, `.Func_475dc` | sun_moon.asm:550-706 | `.Update`, `.Idle`, `.StartTurnRight`, `.StartTurnLeft`, `.TurnRight`, `.TurnLeft`, `.Drop` | 2d sun_moon row ("the same names"); `.Func_475c7`'s jumptable lists them in the same order as `SunFunc.Update`'s (`.Idle`, `.StartTurnRight`, `.StartTurnLeft`, `.TurnRight`, `.TurnLeft`, `.Drop`). The `.Update` at sun_moon.asm:486 belongs to the routine before `MoonFunc`, so no clash. | medium |
| `Func_9aa6c`, `Func_9aa6d`, `Func_9aa72`, `Func_9aa77`, `Func_9aa7c` | bank26.asm:1080-1097 | `TreasureCollectionObjState_None`, `TreasureCollectionObjState01`, `TreasureCollectionObjState02`, `TreasureCollectionObjState03`, `TreasureCollectionObjState04` | 3f | high |
| `Func_9fb4c`, `Func_9fb6c`, `Func_9fb75`, `Func_9fb7e`, `Func_9fb87`, `Func_9fb97`, `Func_9fba0` | bank27.asm:7467-7541 | `DrawCutsceneOverlayFrame0`, `DrawCutsceneOverlayFrame1`, `DrawCutsceneOverlayFrame2`, `DrawCutsceneOverlayFrame3`, `DrawCutsceneOverlayFrame4`, `DrawCutsceneOverlayFrame5`, `DrawCutsceneOverlayFrame6` | 3a | high |
| `Func_9f1f3` | bank27.asm:6072 | `UpdateCutsceneObjs_FreezeSea` | 3b | medium |
| `Func_9f244` | :6116 | `UpdateCutsceneLevelObj_SummonSun` | 3b | high |
| `Func_9f2f3` | :6224 | `UpdateCutsceneObjs_PlaceCartWheels` | 3b | high |
| `Func_9f38d` | :6308 | `UpdateCutsceneObjs_OpenSnakeDoor` | 3b | high |
| `Func_9f7a2` | :6912 | `UpdateCutsceneLevelObj_OpenParaGoomCage` | 3b | high |
| `Func_9f821` | :6989 | `UpdateCutsceneLevelObj_ExtinguishFire` | 3b | high |
| `Func_9f9f5` | :7267 | `UpdateCutsceneLevelObj_OpenCraterHole` | 3b | high |
| `Func_9faea` | :7406 | `UpdateCutsceneLevelObj_FeedOctohon` | 3b | high |
| `Func_9fba9` | :7541 | `UpdateCutsceneObjs_VolcanoEruption` | 3b | high |
| `Func_9e91a` | :5112 | `InitCutscene55Objs` | 3f | high |
| `Func_b4140` | bank2d.asm:197 | `InitNOWObjects_MusicBox` | 3b rule 4 | high |
| `Func_b4873` | :1137 | `InitEOWObjects_Daytime` | 3b rule 4 | high |
| `Func_818e7`, `Func_818ed`, `Func_818f6`, `Func_81900` | bank20.asm:1506-1525 | `RunOWScene_Wait`, `RunOWScene_Next`, `RunOWScene_DoAction`, `RunOWScene_NextParams` | 3f | high |
| `PathPreview_RunTracers.Func_81576`, `.Func_81595`, `.Func_815b6`, `.Func_815c1`, `.Func_815e5`, `.Func_81609` | bank20.asm | `.load_tracer`, `.save_tracer`, `.get_tracer_ptr`, `.copy_tracer_sprites_1`, `.copy_tracer_sprites_2`, `.clear_tracer_sprites` | 3f | high |
| `ProcessCollectionLinkState.Func_9a806`, `.Func_9a8d8` | bank26.asm:747 | `.PlaceLinkedCellMarkers`, `.set_marker_state` | 3a | high |
| `UpdateOWSceneScreenShake.Func_b7273`, `.asm_b7304` | bank2d.asm | `.RunShakeScript`, `.next_step` | 3a | medium |
| `UpdateNorthLeaves.Func_b5435`, `.Func_b54ba` | bank2d.asm | `.UpdateLeaf1`, `.UpdateLeaf2` | 3a | medium |
| `AnimateNorthOWObj2.asm_b5117`, `.asm_b5122` | bank2d.asm | `.draw`, `.set_state_when_finished` | 3a | high |
| `AnonsterFunc.asm_503e0`, `.asm_5043b`, `.asm_504b1`, `.asm_504fe`, `.asm_5054b` | anonster.asm:544-756 | `.spit_waves`, `.reset_to_walk`, `.return_to_ceiling`, `.walk_towards_wario`, `.check_hit_from_behind` | 3c | medium |
| `MuddeeFunc.asm_556dc` | muddee.asm:107 | `.spawn_stingers` | 3c | medium |
| `Func_84fd5` | bank21.asm:904 | `UnreferencedClearBGOBPals` | 3a, the `Func_9cc87` row | high |
| `MusicBoxCutsceneFunc.Func_9d6f6` | bank27.asm:2499 | `.PlayCutscene` | 3b rule 1, listed under its old scope `Func_9d6f0` | high |

Not carried over on purpose: the low rows (snake.asm "low-medium",
pneumo.asm, `Func_80e85`, `Func_8143d`, `Func_15868e`, ...), the
duplicates (`Func_ac000`/`ac00b`/`ac016`, `Func_ac042`/`ac047`/`ac04c`,
`Func_ac051`, `Func_82a8d`, `Func_82c1d`/`82c22`/`82c29`, `Func_aca6d`,
`Func_19246`, `Func_19b5c`/`19bce`): merging them is still a separate
decision. Their rows above stand.

### 4a. Overworld routines and scene-local `.Func_`

Every overworld file was read routine by routine. Rows are grouped by the
routine that owns the labels; a row lists globals and the locals of one or
more scopes (`Scope`: `.Func_x` -> `.name`). Local names follow the files'
existing style: step and state entries in PascalCase (`.WarioWalkRight`,
`.Wait30`), helpers that are only called or jumped to in snake_case
(`.next`, `.set_fade_type`). A few `.asm_` locals are included where they
are the shared tails of the steps. Confidence is per row, with the
exceptions in brackets.

#### bank2b_2: prologue, plane parts, epilogue

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank2b_2.asm:78 | `Prologue`: `.Func_ae009` -> `.set_fade_type`; `.Func_ae067` -> `.PlaceMusicBox`; `.Func_ae0ab` -> `.load_pals`; `.Func_ae15b` -> `.FadeEvery8Frames`; `.Func_ae164` -> `.SetFadeToTemplePals`; `.Func_ae169` -> `.FadeInTemple`; `.Func_ae181` -> `.NextTextPageOrEnd`; `.Func_ae188` -> `.LookAroundOnPage2`; `.Func_ae196` -> `.WarioNodOnce`; `.Func_ae19e` -> `.ShowArrowAfterLookBack`; `.Func_ae1af` -> `.WaitAButton` | `.PlayCutscene` step locals. `.set_fade_type` is the fall-through tail that stores the `_PrologueFade` type (0 to black, 1 forest, 2 temple, 5 temple palettes 6-7 only, 6 cave; bank21.asm:744-890) in `wCurOWPathTracer` (a borrowed byte, see the RAM notes) and clears the fade steps. `.PlaceMusicBox`: scene object 3 at (120, 195), state 9 (the object that `.MusicBoxRise` later moves). `.load_pals`: 8 BG palettes from `hl` + pal configs. `.FadeEvery8Frames` / `.FadeInTemple` (every 8 frames, every 2 once 8 steps are done). `.LookAroundOnPage2` sets `SCENEWARIO_LOOK_AROUND` on text page 2. `.ShowArrowAfterLookBack` waits for `SCENEWARIO_LOOK_BACK`, then scene object 1 state 1 (`SceneObjState_TextArrow`); `.WaitAButton` hides it and clears the textbox. | high (medium: `.PlaceMusicBox`, `.SetFadeToTemplePals`, `.FadeInTemple`) |
| bank2b_2.asm:372 | `Func_ae1de` -> `Prologue_MusicBoxSparkles`; `Func_ae1de`: `.Func_ae1f5` -> `.Sparkle1`; `.Func_ae215` -> `.Sparkle2` | Step $0d of the prologue, right after `.ShowMusicBoxCloseUp`: wait 20, scene object 4 at (56, 56) state $0e with `SFX_104`, wait 10, object 5 at (120, 48) state $0e, wait 90. State $0e of `UpdatePrologueSceneObj` plays `PrologueSceneObjFrameset_15e7b7` once; the same state is put 8 px above the music box and on Wario later, so "sparkle" is a guess from that use. | medium |
| bank2b_2.asm:462 | `Prologue_WarioEnterCave`: `.Func_ae26c` -> `.start_sparkle`; `.Func_ae272` -> `.WaitSparkle`; `.Func_ae2b8` -> `.StartSparkleLoop` | `.start_sparkle` (at X 50 sets `w2d8b0` = 1), `.WaitSparkle` (until `w2d8b0` is back to 0), `.StartSparkleLoop` (frame $14: `w2d8b0` = 3, the repeating loop; frame $3c next step). | medium |
| bank2b_2.asm:532 | `Func_ae2dd` -> `UpdateMusicBoxSparkle`; `Func_ae2fb` -> `MusicBoxSparkle_None`; `Func_ae2ed` -> `MusicBoxSparkle_Show`; `Func_ae2f5` -> `MusicBoxSparkle_Next`; `Func_ae303` -> `MusicBoxSparkle_WaitThenStop`; `Func_ae2fc` -> `MusicBoxSparkle_Wait`; `Func_ae30e` -> `MusicBoxSparkle_Repeat` | Called every frame by `Prologue_WarioEnterCave`: jumptable on `w2d8b0` with `w2d8b1` as counter. 0 nothing; 1/3 scene object 1 (8 px above the music box) state $0e and next; 2 wait for it to end, then back to 0; 4 wait for it to end, next; 5 wait 20 frames and go back 2 sub-steps (to 3). So 1 = one sparkle, 3 = repeat until the step changes. The six entries are globals. | high (medium: `UpdateMusicBoxSparkle`, `MusicBoxSparkle_Show`) |
| bank2b_2.asm:610 | `Prologue_WarioSuckedIntoMusicBox`: `.Func_ae352` -> `.WaitSparkle`; `.Func_ae35a` -> `.StopMusic`; `.Func_ae37c` -> `.SetMusicBoxState0a`; `.Func_ae3d8` -> `.HideMusicBoxGlow`; `.Func_ae3e2` -> `.SparkleOnWario`; `.Func_ae3fa` -> `.WaitSparkleStopPalCycle`; `.Func_ae407` -> `.StartSuckIn`; `.Func_ae435` -> `.WaitSuckInRemoveWario`; `.Func_ae447` -> `.MoveIntoMusicBox`; `.Func_ae476` -> `.ResetMusicBox`; `.Func_ae488` -> `.ShakeMusicBox`; `.Func_ae4a9` -> `.DropMusicBox`; `.Func_ae4c0` -> `.get_fall_speed`; `.Func_ae4e5` -> `.BounceMusicBox`; `.Func_ae4fe` -> `.get_bounce_offset` | Steps: wait for object 1's sparkle; frame $14 stop the music; wait 30; pick up; music box (object 3) state $0a (frameset `15e7a6`, `SFX_0F3` at its end); hop; `.MusicBoxRise` (existing; object 2 above it gets state $0c, `SFX_0F4`, and `w2d150` = 1 starts `Func_ae523`); wait 120; hide object 2; sparkle on Wario (current object at Wario - 8); wait for it, `w2d150` = $80 stops the palette cycle; `.StartSuckIn`: current object state $15 at Wario - 16 and OB palette 0 to grey 28; `.WaitSuckInRemoveWario`: state $16, then `SCENEWARIO_NONE`; `.MoveIntoMusicBox`: the current object moves up/right to Y 156 (state $17 at 168); `.ResetMusicBox`: object 3 back to state 9, current object off; `.ShakeMusicBox` (X +1, -2, +1); `.DropMusicBox` (falls with the `.data_ae4d1` speeds to Y 195, `SFX_BUMP`); `.BounceMusicBox` (`.data_ae509` offsets until $80). | high (medium: `.WaitSparkle`, `.HideMusicBoxGlow`, `.SparkleOnWario`, `.StartSuckIn`, `.WaitSuckInRemoveWario`, `.MoveIntoMusicBox`, `.ResetMusicBox`) |
| bank2b_2.asm:887 | `Func_ae523` -> `CycleSceneWarioPals` | Called every frame by `Prologue_WarioSuckedIntoMusicBox` and by the epilogue's `.SendWarioHome`: while `w2d150` is non-zero, every 2 frames steps `w2d150` through 1-8 and writes palette 0-7 (`.data_ae54b`) to `wSceneWarioAttributes`; $80 resets the attributes and stops. | high |
| bank2b_2.asm:932 | `Func_ae55c` -> `Prologue_WarioWakeUp`; `Func_ae585` -> `PrologueWakeUp_WaitSleepAnim`; `Func_ae58d` -> `PrologueWakeUp_WakeUp`; `Func_ae599` -> `PrologueWakeUp_PlayGrabSFX`; `Func_ae5a8` -> `PrologueWakeUp_WaitSitIdle`; `Func_ae5b1` -> `PrologueWakeUp_ShowCurObjState14`; `Func_ae5d0` -> `PrologueWakeUp_SitStill`; `Func_ae5dc` -> `PrologueWakeUp_StandUp`; `Func_ae5f0` -> `PrologueWakeUp_Wait60`; `Func_ae5f5` -> `PrologueWakeUp_WalkRight`; `Func_ae5fd` -> `PrologueWakeUp_WalkRightTo80`; `Func_ae60c` -> `PrologueWakeUp_TurnBack`; `Func_ae618` -> `PrologueWakeUp_WaitLookBack`; `Func_ae61d` -> `PrologueWakeUp_PlayTempleMusic`; `Func_ae630` -> `PrologueWakeUp_LookAround`; `Func_ae63c` -> `PrologueWakeUp_Wait30` | Prologue step $17, after `.PrepareTempleScene` (Wario asleep) and the fade: a 15-entry `wSceneStep` table of globals. Wait for the sleep animation, $4b frames then `SCENEWARIO_WAKE_UP`, $14 `SFX_GRAB`, wait `SIT_IDLE`, after 5 frames the current object at Wario + (−1, 9) state $14 (`15e7f5`, looped; not identified), $8c `SIT_STILL`, $10 `IDLE_RIGHT` + `SFX_12A`, wait 60, walk right to X 80, $1e `TURN_BACK_RIGHT`, wait `LOOK_BACK`, $1e `MUSIC_THE_TEMPLE`, $1e `LOOK_AROUND`, wait 30. Names `PrologueWakeUp_<step>`. | high (medium: `PrologueWakeUp_ShowCurObjState14`) |
| bank2b_2.asm:1065 | `Func_ae641` -> `Prologue_WarioJumpAndBow`; `Func_ae652` -> `PrologueBow_WaitLookForward`; `Func_ae657` -> `PrologueBow_JumpAndBow`; `Func_ae663` -> `PrologueBow_WaitLookBack` | Prologue step $1a: wait `SCENEWARIO_LOOK_FORWARD`, `SCENEWARIO_JUMP_AND_BOW` (clears `wSceneWarioMovementStep`, which the bow uses as its land-sound flag), wait `LOOK_BACK`. | high |
| bank2b_2.asm:1093 | `Func_ae668` -> `Prologue_WarioLeaveTemple`; `Func_ae683` -> `PrologueLeave_SnapFingers`; `Func_ae68b` -> `PrologueLeave_SnapSFX`; `Func_ae69c` -> `PrologueLeave_WaitLookBack`; `Func_ae6a1` -> `PrologueLeave_Wait30`; `Func_ae6a6` -> `PrologueLeave_TurnLeft`; `Func_ae6ae` -> `PrologueLeave_WaitIdleLeft`; `Func_ae6b3` -> `PrologueLeave_WalkLeft`; `Func_ae6c1` -> `PrologueLeave_WalkOffScreen`; `Func_ae6ce` -> `PrologueLeave_FinalWait30` | Last prologue step before `Prologue_Finish`: `SNAP_FINGERS`, `SFX_106` at Wario frame $0f, wait `LOOK_BACK`, wait 30, `TURN_BACK_TO_LEFT`, wait `IDLE_LEFT`, after 4 frames `WALK_LEFT` until X $f0, `SCENEWARIO_NONE`, wait 30. | high |
| bank2b_2.asm:1457 | `Func_ae8bb` -> `UpdatePlaneParts`; `Func_ae8bb`: `.Func_ae8d8` -> `.Done`; `.Func_ae8d9` -> `.StartPart1`; `.Func_ae8e8` -> `.StartPart2`; `.Func_ae8f6` -> `.StartPart3`; `.Func_ae904` -> `.StartPart4` | Called every frame by `Prologue_WarioFallFromPlane`: runs the four plane part updaters, and its own `wSceneAuxStep` table starts them one by one every 8 frames (`AdvanceStepAtHL` on `wPlanePartNCounter` moves part N from action 0 to 1); the last entry is a `ret`. | high |
| bank2b_2.asm:1532 | `Func_ae924` -> `UpdatePlanePart1`; `Func_ae924`: `.Func_ae948` -> `.land_sfx_and_next`; `.Func_ae950` -> `.next`; `.Func_ae956` -> `.check_landed`; `.Func_ae969` -> `.wait`; `.Func_ae971` -> `.Place1`; `.Func_ae97e` -> `.Fall1`; `.Func_ae983` -> `.Bounce1`; `.Func_ae989` -> `.Wait8_1`; `.Func_ae98d` -> `.Place2`; `.Func_ae99a` -> `.Fall2`; `.Func_ae99f` -> `.Bounce2`; `.Func_ae9a5` -> `.Wait40`; `.Func_ae9a9` -> `.Place3`; `.Func_ae9b6` -> `.Fall3`; `.Func_ae9bb` -> `.Bounce3`; `.Func_ae9c1` -> `.Wait8_2`; `.Func_ae9c5` -> `.End` | Plane part 1 (scene object 3), `wPlanePart1Action` table (0 = idle). Three times: place the object with a new state (`SetSceneObjCoordAndState`), fall along a movement table until Y $62 (`SFX_006`), finish the table (`SFX_006`), wait (8, 40, 8); then clear the object. The other parts work the same way with their own objects, states and tables; parts 2-4 also drag a second object along (objects 1, 2, 8: state $0f while falling, $10 on landing), and some switch to state $12/$13 between the throws. `Func_ae9e4`/`ae9da`/`ae9d0` are part 1's three movement calls (globals because they sit outside the routine). Locals per part: `.Place<N>`, `.Fall<N>`, `.Bounce<N>`, `.Wait<frames>`, `.SetState<NN>`, `.End`, helpers `.next`, `.land_sfx_and_next`, `.check_landed`, `.wait`, `.move_arc<N>`; "arc N" = `PlanePartArcMovementN` below. | high |
| bank2b_2.asm:1663 | `Func_ae9ee` -> `UpdatePlanePart2`; `Func_ae9ee`: `.Func_aea16` -> `.land_sfx_and_next`; `.Func_aea1e` -> `.next`; `.Func_aea24` -> `.check_landed`; `.Func_aea37` -> `.wait`; `.Func_aea40` -> `.Place1`; `.Func_aea54` -> `.Fall1`; `.Func_aea59` -> `.Bounce1`; `.Func_aea5f` -> `.Wait4`; `.Func_aea63` -> `.SetState12`; `.Func_aea6d` -> `.Wait40`; `.Func_aea71` -> `.Place2`; `.Func_aea7c` -> `.attach_obj1`; `.Func_aea92` -> `.Fall2`; `.Func_aeab9` -> `.Bounce2`; `.Func_aeac0` -> `.Wait8_1`; `.Func_aeac5` -> `.Place3`; `.Func_aead2` -> `.Fall3`; `.Func_aead8` -> `.Bounce3`; `.Func_aeadf` -> `.Wait8_2`; `.Func_aeae4` -> `.End`; `.Func_aeaef` -> `.move_arc1`; `.Func_aeaf9` -> `.move_arc3`; `.Func_aeb03` -> `.move_arc3_2` | Plane part 2 (object 4, trailing object 1). `.move_arc3` and `.move_arc3_2` are identical (`.Fall3` uses the second and, unlike `.Fall2`, doesn't move object 1 with the part, so the trailing object stays where `.Place3` attached it). `.attach_obj1` puts object 1 on the part with state $0f. | high |
| bank2b_2.asm:1831 | `Func_aeb0d` -> `UpdatePlanePart3`; `Func_aeb0d`: `.Func_aeb35` -> `.land_sfx_and_next`; `.Func_aeb3d` -> `.next`; `.Func_aeb43` -> `.check_landed`; `.Func_aeb56` -> `.wait`; `.Func_aeb5f` -> `.Place1`; `.Func_aeb80` -> `.Fall1`; `.Func_aeba7` -> `.Bounce1`; `.Func_aebad` -> `.Wait8_1`; `.Func_aebb1` -> `.Place2`; `.Func_aebbf` -> `.Fall2`; `.Func_aebc5` -> `.Bounce2`; `.Func_aebcc` -> `.Wait4`; `.Func_aebd0` -> `.SetState13`; `.Func_aebdb` -> `.Wait40`; `.Func_aebe0` -> `.Place3`; `.Func_aebee` -> `.Fall3`; `.Func_aebf4` -> `.Bounce3`; `.Func_aebfb` -> `.Wait8_2`; `.Func_aec00` -> `.End`; `.Func_aec0b` -> `.move_arc1`; `.Func_aec0e` -> `.move`; `.Func_aec15` -> `.move_arc3`; `.Func_aec1a` -> `.move_arc2` | Plane part 3 (object 5, trailing object 2). | high |
| bank2b_2.asm:1989 | `Func_aec1f` -> `UpdatePlanePart4`; `Func_ae9e4` -> `MovePlanePart1Arc1`; `Func_ae9da` -> `MovePlanePart1Arc2`; `Func_ae9d0` -> `MovePlanePart1Arc3`; `Func_aec1f`: `.Func_aec3f` -> `.land_sfx_and_next`; `.Func_aec47` -> `.next`; `.Func_aec4d` -> `.check_landed`; `.Func_aec60` -> `.wait`; `.Func_aec69` -> `.Place1`; `.Func_aec76` -> `.Fall1`; `.Func_aec7b` -> `.Bounce1`; `.Func_aec81` -> `.Wait4`; `.Func_aec85` -> `.SetState13`; `.Func_aec8f` -> `.Wait40`; `.Func_aec93` -> `.Place2`; `.Func_aecb4` -> `.Fall2`; `.Func_aecdb` -> `.Bounce2`; `.Func_aece2` -> `.Wait8`; `.Func_aece7` -> `.End`; `.Func_aecf2` -> `.move_arc2`; `.Func_aecf5` -> `.move`; `.Func_aecfc` -> `.move_arc1`; `.Func_aed01` -> `.unreferenced_move_arc3` | Plane part 4 (object 9, trailing object 8). `.Func_aed01` (arc 3) has no reference. | high |
| bank2b_2.asm:2123 | `Data_aed06` -> `PrologueWarioFallMovement`; `Data_aed6d` -> `PlanePartArcMovement1`; `Data_aedba` -> `PlanePartArcMovement2`; `Data_aee09` -> `PlanePartArcMovement3` | (dy, dx) pairs ending in $80 for `ApplyOWMovement`: Wario's three bounces after he falls out of the plane (`Prologue_WarioFallFromPlane.DoBounce`); the epilogue plays it mirrored for Wario and the music box landing in the forest. `Data_aed6d` / `Data_aedba` / `Data_aee09`: the plane parts' arcs (dx up to 6 / 7 / 4 per step, one bounce each). | medium (high: `PrologueWarioFallMovement`) |
| bank2b_2.asm:2499 | `_UpdateEpilogue`: `.Func_af14c` -> `.PlayCutscene`; `.Func_af197` -> `.Wait60`; `.Func_af19c` -> `.InitTransformationScene`; `.Func_af1bd` -> `.load_epilogue_pals`; `.Func_af1db` -> `.load_extra_ob_pals`; `.Func_af1e7` -> `.LoadOldMan1Gfx`; `.Func_af207` -> `.LoadOldMan2Gfx`; `.Func_af215` -> `.LoadCrowdTilemap`; `.Func_af222` -> `.LoadCrowdAttrmap`; `.Func_af230` -> `.RestoreSavedVRAM1Tiles`; `.Func_af23e` -> `.InitCrowdScene`; `.Func_af2ab` -> `.place_obj`; `.Func_af2b5` -> `.copy_8_pals`; `.Func_af2bc` -> `.Wait30`; `.Func_af2c1` -> `.PrintTextAndAnimateOldMan`; `.Func_af2d0` -> `.SetFadeToBlack`; `.Func_af2df` -> `.LoadForestGfx`; `.Func_af2f2` -> `.InitForestScene`; `.Func_af34a` -> `.FadeEvery4Frames`; `.Func_af353` -> `.WaitThenFinish`; `.Pals_af35e` -> `.ExtraOBPals`; `.Func_af376` -> `.SetOldManTalkAnim`; `.asm_af400` -> `.wait_wario_state`; `.asm_af40c` -> `.next_scene_step`; `.asm_af413` -> `.end_scene_steps`; `.Func_af41c` -> `.FadeThenNextSceneStep`; `.Func_af436` -> `.WarioAndMusicBoxLand`; `.Func_af466` -> `.InitLanding`; `.Func_af476` -> `.DropWario`; `.Func_af48a` -> `.DropMusicBox`; `.Func_af49e` -> `.WaitBothLanded`; `.Func_af4ad` -> `.WarioTurnBackLeft`; `.Func_af4b9` -> `.WaitWarioLookBack`; `.Func_af4be` -> `.WarioLookTurnRight`; `.Func_af4ca` -> `.WaitWarioIdleLeft`; `.Func_af4cf` -> `.WarioPickUp`; `.Func_af4e7` -> `.WaitWarioCarryIdle`; `.Func_af4f6` -> `.LiftMusicBox`; `.Func_af528` -> `.WarioCarrySnapFingers`; `.Func_af534` -> `.SnapSFX`; `.Func_af545` -> `.WaitWarioCarryIdle2`; `.Func_af54a` -> `.WarioCarryWalk`; `.Func_af55a` -> `.WalkLeftOffScreen`; `.Func_af574` -> `.Wait60ThenEnd_1`; `.Func_af57b` -> `.UpdateWarioFall`; `.Func_af5b2` -> `.WarioFall_None`; `.Func_af5b3` -> `.WarioFall_Start`; `.Func_af5c5` -> `.WarioFall_Land`; `.Func_af5d5` -> `.WarioFall_Delay4`; `.Func_af5df` -> `.WarioFall_WaitStunned`; `.Func_af5e7` -> `.WarioFall_GetUp`; `.Func_af5fe` -> `.WarioFall_Done`; `.Func_af604` -> `.play_wario_bump_sfx`; `.Func_af60d` -> `.UpdateMusicBoxFall`; `.Func_af639` -> `.MusicBoxFall_None`; `.Func_af63a` -> `.MusicBoxFall_Start`; `.Func_af64c` -> `.MusicBoxFall_Land`; `.Func_af657` -> `.MusicBoxFall_Delay4`; `.Func_af661` -> `.MusicBoxFall_Done`; `.Func_af667` -> `.play_music_box_bump_sfx`; `.Func_af670` -> `.SendWarioHome`; `.Func_af68b` -> `.ShowArrow`; `.Func_af69a` -> `.WaitAButton`; `.Func_af6c1` -> `.StartWarioPalCycle`; `.Func_af6cd` -> `.StopWarioPalCycle`; `.Func_af6ee` -> `.RemoveWario`; `.Func_af6f9` -> `.Wait90`; `.Func_af700` -> `.CurObjFlyUp`; `.Func_af73a` -> `.Wait45ThenEnd`; `.Func_af741` -> `.OldManArrives`; `.Func_af755` -> `.PlaceOldMan`; `.Func_af76c` -> `.OldManWalkRight`; `.Func_af775` -> `.OldManWalkAndScroll`; `.Func_af788` -> `.SetOldManState06`; `.Func_af797` -> `.WaitOldManState0a`; `.Func_af7a0` -> `.Wait60ThenEnd_2`; `.Func_af7a7` -> `.move_old_man_right`; `.Func_af7af` -> `.Transformation`; `.Func_af7ee` -> `.PlayEpilogueMusic`; `.Func_af7fd` -> `.SetObjsPal4`; `.Func_af816` -> `.WaitObj1ThenFlash`; `.Func_af82d` -> `.TransformSpearhead`; `.Func_af843` -> `.ShowHammerBot`; `.Func_af860` -> `.SetObjsPal0`; `.Func_af863` -> `.TransformHammerBot`; `.Func_af871` -> `.ShowDoughnuteer`; `.Func_af88e` -> `.SetObjsPal3`; `.Func_af893` -> `.TransformDoughnuteer`; `.Func_af8a2` -> `.Wait80`; `.Func_af8a9` -> `.ResetObjsPalAndEnd`; `.Func_af8bc` -> `.MoveClouds`; `.Func_af8d0` -> `.move_cloud1`; `.Func_af8dc` -> `.move_cloud2`; `.Func_af8ef` -> `.move_cloud3`; `.Func_af902` -> `.move_cloud4` | All locals of the epilogue (bank2b_2.asm:2491-3610). Main table (`wOWStep`, `.PlayCutscene` after the per-frame `.MoveClouds`): wait 60; `.InitTransformationScene` (object 9 state $18 = a Spearhead, see `UpdateEpilogueSceneObj` states $18-$1a, which draw the Spearhead, Hammer Bot and Doughnuteer level-object framesets); fade; `.Transformation` (runs bank56's `Func_15848a`); fade to black; load the old man's gfx, the crowd tilemap/attrmap and the $50 tiles `_InitEpilogue` saved in `wAttrmap`; `.InitCrowdScene` (SCX 160, Wario at ($60,$5c), four clouds 10-13 in states $1b/$1c); fade in; `.OldManArrives` (object 9 walks in while the screen scrolls); the old man's text (`.PrintTextAndAnimateOldMan` calls `.SetOldManTalkAnim`, which picks object 9's state from the text page/line, per language); `.SendWarioHome` (A, palette cycle on Wario (`Func_ae523`), Wario removed, the current object flies up); fade; `.LoadForestGfx`, `.InitForestScene` (object 9 = the music box at ($3c,$b2) state $13, Wario state $1c); `.WarioAndMusicBoxLand` (both fall in with `Data_aed06` mirrored and bounce, Wario turns round, picks the box up, snaps his fingers and walks off left carrying it); fade out every 4 frames; `.WaitThenFinish`. Sub-tables share `.next_scene_step` (`.asm_af40c`), `.end_scene_steps` (`.asm_af413`), `.wait_wario_state` (`.asm_af400`, via `wOWUIObj1State`) and `.FadeThenNextSceneStep`. The transformation: `.SetObjsPal4`/`0`/`3` set palette 4/0/3 in the attributes of objects 1 and 5-8 (and start bank56's object script), `.WaitObj1ThenFlash` waits for object 1 to reach Y $50 (`SFX_0EB`, white OB palettes), `.TransformSpearhead` etc. In `.SendWarioHome`, `.StopWarioPalCycle` also puts the current object at Wario - 4 in state $11, and `.CurObjFlyUp` moves it up (3 px/frame below Y $50; at Y $40 state $12 and object 9 state $0a) until it leaves at Y $18. Raw numbers are used for `SCENEWARIO_*` states throughout (e.g. `ld a, $05` = `SCENEWARIO_TURN_BACK_LEFT`); the names follow the constants. `.ExtraOBPals` (`.Pals_af35e`): 3 OB palettes loaded into palettes 4-6 at the start and after each transformation. | high (medium: `.InitTransformationScene`, `.PrintTextAndAnimateOldMan`, `.ExtraOBPals`, `.SetOldManTalkAnim`, `.WarioAndMusicBoxLand`, `.DropMusicBox`, `.LiftMusicBox`, `.UpdateMusicBoxFall`, `.SendWarioHome`, `.CurObjFlyUp`, `.OldManArrives`, `.PlaceOldMan`, `.OldManWalkRight`, `.OldManWalkAndScroll`, `.move_old_man_right`, `.Transformation`, `.TransformSpearhead`, `.ShowHammerBot`, `.TransformHammerBot`, `.ShowDoughnuteer`, `.TransformDoughnuteer`, `.MoveClouds`, `.move_cloud1`, `.move_cloud2`, `.move_cloud3`, `.move_cloud4`) |

#### bank2b_1: scene object tables, scene Wario, Hidden Figure reveal, Golf Building

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank2b_1.asm:156 | `UpdateEpilogueSceneObj`: `.asm_ac0f2` -> `.animate_and_draw`; `.asm_ac0f5` -> `.draw`; `.Func_ac1c3` -> `.follow_wario`; `.Func_ac1e9` -> `.PlaySFX08EEvery48Frames`; `.Func_ac207` -> `.PlaySFX11AEvery40Frames` | Bulk rule R2 (scene object state tables, below) for the entries. Helpers: `.animate_and_draw` / `.draw` (`.asm_ac0f2` / `.asm_ac0f5`); `.follow_wario` (state $13: while Scene Wario carries (`CARRY_WALK`) the object bobs 1 px on Wario frames 25/26; during `PICKUP` it is placed relative to Wario on frames 0-2: the music box in Wario's hands); `.PlaySFX08EEvery48Frames` (state $16) and `.PlaySFX11AEvery40Frames` (state $17, on the first frame of each period) next to the existing `.PlaySFXEvery30Frames`. States $18/$19/$1a draw `Frameset_681d2` / `Frameset_68b12` / `Frameset_68562`, the Spearhead, Hammer Bot and Doughnuteer framesets of the level objects, through `UnreferencedUpdateSceneObjAnim_ObjFramesets` (see the finding below). | high (medium: `.follow_wario`) |
| bank2b_1.asm:446 | `Func_ac2b2` -> `UpdateTempleSceneObjs_Front` | Called by `_UpdateTempleScene` before `UpdateSceneWario` for the current object and objects 1-2; the existing `UpdateTempleSceneObjs` (objects 3-15) is called after it, like the epilogue's `UpdateEpilogueSceneObjs_Front` / `_Back`. | high |
| bank2b_1.asm:502 | `UpdateTempleSceneObjAnimation`: `.Func_ac32e` -> `.unreferenced_animate_and_draw_1`; `.Func_ac331` -> `.draw_1`; `.Func_ac337` -> `.animate_once_1`; `.Func_ac343` -> `.animate_and_draw_2`; `.Func_ac346` -> `.draw_2`; `.Func_ac34c` -> `.unreferenced_animate_once_2`; `.Func_ac38e` -> `.animate_and_draw_no_scroll`; `.Func_ac3c1` -> `.animate_and_draw_3`; `.Func_ac3d1` -> `.set_state_if_finished_3` | R2 for the entries. Helpers, by what they draw: `.draw_1` (`OAM_1644a`, credits bank, with scroll) with `.animate_once_1` (state 0 at the end) and the unreferenced `.unreferenced_animate_and_draw_1`; `.draw_2` (`TempleSceneObjOAM_15e813`) with `.animate_and_draw_2` and the unreferenced `.unreferenced_animate_once_2`; `.animate_and_draw_no_scroll` (same OAM, `LoadOWSprite`); `.animate_and_draw_3` (`OAM_18c88a`) with `.set_state_if_finished_3`. | high |
| bank2b_1.asm:674 | `UpdatePrologueSceneObj`: `.Func_ac43b` -> `.animate_and_draw`; `.Func_ac43e` -> `.draw`; `.Func_ac444` -> `.animate_once` | R2 for the entries; helpers `.animate_and_draw` (`OAM_15e44a`), `.draw`, `.animate_once` (next to the existing `.set_new_state_if_finished`). | high |
| bank2b_1.asm:797 | `Func_ac4fa` -> `PlaySceneWarioStepSFX`; `Func_ac515` -> `PlaySceneWarioRunSFX` | Tail of Scene Wario's walk animations (`.WalkLeft`, `.WalkRight`, `.CarryWalk`): `SFX_12A` when `wSceneWarioSFXCounter` is 0, the counter wraps at $24. `Func_ac515`: tail of `.PanicRunLeft/Right`, `SFX_137` every 8 frames. | high |
| bank2b_1.asm:1203 | `UpdateSceneWario`: `.Func_ac7b7` -> `.PlayLandSFXAtFrame7`; `.Func_ac7ff` -> `.PlayLandSFXAtEnd` | `.Func_ac7b7` (in `.JumpAndBow`): `SFX_LAND` at frame 7, once (flag in `wSceneWarioMovementStep`); `.Func_ac7ff` (in `.PanicJump`): `SFX_LAND` when the animation ends. | high |
| bank2b_1.asm:2493 | `HiddenFigureRevealScene`: `.Func_ad0bd` -> `.NextTextPageOrEnd`; `.Func_ad0e4` -> `.SetFadeToDarkness`; `.Func_ad0f6` -> `.FadeEvery16Frames`; `.Func_ad12f` -> `.WaitRocksGone`; `.Func_ad16a` -> `.panic_and_next`; `.Func_ad195` -> `.ShowHiddenFigure`; `.Func_ad1e3` -> `.FadeInHiddenFigure`; `.Func_ad207` -> `.SkipToPage4`; `.Func_ad23a` -> `.CloseMouthThenShowArrow`; `.Func_ad259` -> `.WaitAButtonOpenMouth`; `.Func_ad271` -> `.WaitMouthOpen`; `.Func_ad27a` -> `.PrintTextMoveMouth`; `.Func_ad2f4` -> `.WaitMouthClosedNextPage`; `.Func_ad300` -> `.WarioPanicJump`; `.Func_ad308` -> `.WaitThenShowTextArrow2`; `.Func_ad319` -> `.WaitAButtonThenClearTextbox2` | Unnamed steps of the existing table. `.SetFadeToDarkness`: fade type 3 (`_PrologueFade` `.three`: BG palettes 0-5 and OB palettes 1-7 black); `.FadeEvery16Frames`; `.WaitRocksGone` (sum of `wTempleRocks` sizes is 0, then flips the BG map); `.panic_and_next` (`.Func_ad16a`, shared tail); `.ShowHiddenFigure` (after 30 frames: face = object 7 state $0d, hands = objects 3/4 states $11/$12, hand movement on, fade type 4 = `Pals_db000`); `.FadeInHiddenFigure` (every 8 frames, every 4 after 20 steps); `.SkipToPage4` (`wCurTextBufferPage` = 4); `.CloseMouthThenShowArrow` (frame 40 mouth state $0f, frame 70 next page and the arrow); `.WaitAButtonOpenMouth`; `.WaitMouthOpen` (state $0e); `.PrintTextMoveMouth` (it ends with `AdvanceEpilogueOWStep`, the same 5 instructions as `AdvanceTempleOWStep`); `.WaitMouthClosedNextPage` (state $0d, then `NextTextPageOrEnd`, `dec [hl]` repeats the previous step while pages remain); `.WarioPanicJump`; `.WaitThenShowTextArrow2` / `.WaitAButtonThenClearTextbox2` repeat the named `.WaitThenShowTextArrow` / `.WaitAButtonThenClearTextbox`. | high (medium: `.SetFadeToDarkness`, `.CloseMouthThenShowArrow`, `.WaitMouthClosedNextPage`) |
| bank2b_1.asm:3279 | `Data_ad654` -> `TempleMusicBoxCircleMovement`; `Data_ad939` -> `HiddenFigureHandIdleMovement` | `ApplyOWMovement` table of `HandleTempleMusicBoxNHover.MoveCircle` (the `temple_music_box_hover` macro): the music boxes' hover loop. `Data_ad939`: `DoHiddenFigureLeftHandMovement` / `DoHiddenFigureRightHandMovement` (the right hand mirrored): the hands' idle sway in the reveal scene. | high |
| bank2b_1.asm:3855 | `_GolfBuilding`: `.Func_ada43` -> `.PlaceSceneWario`; `.Func_ada4a` -> `.place_wario_by_map_side` | `.PlaceSceneWario`: with all crayons in the Golf Building itself, Wario faces the door at ($58, $50) (`SCENEWARIO_LOOK_FRONT`, scene 4); otherwise `.place_wario_by_map_side` sets his X and the scene from `.data` by `wNextMapSide` (north: X $90, scene 1; west: X $10, scene 0), and with all crayons the scene goes up by 2. | medium |
| bank2b_1.asm:4091 | `_UpdateGolfBuilding`: `.Func_adc0b` -> `.CheckExit`; `.Func_adc2f` -> `.RunScene`; `.asm_adc43` -> `.next_step`; `.asm_adc4a` -> `.set_scene`; `.Func_adc54` -> `.WalkRightAndExit`; `.Func_adc7e` -> `.WalkLeftAndExit`; `.Func_adca9` -> `.WalkRightToDoor`; `.Func_adcda` -> `.WalkLeftToDoor`; `.Func_add0b` -> `.AtDoor`; `.Func_add21` -> `.WaitLookFront`; `.Func_add2a` -> `.FaceFront`; `.Func_add36` -> `.HandleInput`; `.Func_add8a` -> `.WaitLookBack`; `.Func_add93` -> `.EnterGolf`; `.Func_adda5` -> `.WaitIdleLeft`; `.Func_addae` -> `.StartWalkLeftAndExit`; `.Func_addb7` -> `.WaitIdleRight`; `.Func_addc0` -> `.StartWalkRightAndExit` | `.CheckExit` (B leaves, except at the door; carry when taken) and `.RunScene`, a jumptable on the scene byte (`wPalFade6Colour2GreenCurrent`, see RAM notes). Scenes: 0 `.WalkRightAndExit` (walk right to X $90, disappear, wait 20, exit), 1 `.WalkLeftAndExit` (to $10), 2 `.WalkRightToDoor` / 3 `.WalkLeftToDoor` (to X $50, then `TURN_RIGHT_TO_FRONT` / `TURN_LEFT_TO_FRONT`, scene 4), 4 `.AtDoor`, a step table: wait `LOOK_FRONT`, `.FaceFront` (`IDLE_FRONT` after 16 frames), `.HandleInput` (RIGHT -> west side, `TURN_FRONT_TO_RIGHT`, step 7; LEFT -> north side, step 5; A/UP -> `TURN_FRONT_TO_BACK_RIGHT`, `SFX_12A`, step 3), `.WaitLookBack`, `.EnterGolf` (after 20 frames `LEVEL_GOLF_BUILDING`, next state), `.WaitIdleLeft`, `.StartWalkLeftAndExit` (scene 1), `.WaitIdleRight`, `.StartWalkRightAndExit` (scene 0). Asm locals `.next_step` (`.asm_adc43`), `.set_scene` (`.asm_adc4a`). Raw `SCENEWARIO_*` numbers again ($08 walk right, $34 `TURN_RIGHT_TO_FRONT`, ...). | high |
| bank2b_1.asm:4369 | `Pals_addc9` -> `GolfBuildingGreyPals`; `Pals_ade09` -> `GolfBuildingCrayonPals` | `_GolfBuilding.FillBGPalettes`: `Pals_addc9` is the grey building (8 palettes), and each collected crayon copies some colours from `Pals_ade09` over it (`.FillRed` ... `.FillPink`). | high |

#### Bulk rule R2: scene object state tables

`UpdateEpilogueSceneObj`, `UpdateTempleSceneObjAnimation` and
`UpdatePrologueSceneObj` (bank2b_1) are `ld a, [bc] / jumptable` state
tables like the map-side ones of the third pass: each entry loads a
frameset into `de` and jumps to an animate/draw helper (some switch to
another state when the animation ends, a few also play a sound). Entries
are named by slot in the `.State3b` hex style of spearhead.asm, slot 0
(`ret`) `.None`; slot 1 of all three is the existing
`SceneObjState_TextArrow`. The framesets the states use are not
descriptive yet (`PrologueSceneObjFrameset_15e7b7`), so a better name for
a state has to come from its frameset first. Generated from the tables
(69 labels), high:

`UpdateEpilogueSceneObj.Func_ac11c` .None; `UpdateEpilogueSceneObj.Func_ac11d` .State02; `UpdateEpilogueSceneObj.Func_ac122` .State03; `UpdateEpilogueSceneObj.Func_ac127` .State04; `UpdateEpilogueSceneObj.Func_ac12c` .State05; `UpdateEpilogueSceneObj.Func_ac131` .State06; `UpdateEpilogueSceneObj.Func_ac13c` .State07; `UpdateEpilogueSceneObj.Func_ac141` .State08; `UpdateEpilogueSceneObj.Func_ac15f` .State09; `UpdateEpilogueSceneObj.Func_ac164` .State0a; `UpdateEpilogueSceneObj.Func_ac169` .State0b; `UpdateEpilogueSceneObj.Func_ac174` .State0c; `UpdateEpilogueSceneObj.Func_ac17f` .State0d; `UpdateEpilogueSceneObj.Func_ac18a` .State0e; `UpdateEpilogueSceneObj.Func_ac195` .State0f; `UpdateEpilogueSceneObj.Func_ac1a0` .State10; `UpdateEpilogueSceneObj.Func_ac1ab` .State11; `UpdateEpilogueSceneObj.Func_ac1b1` .State12; `UpdateEpilogueSceneObj.Func_ac1b7` .State13; `UpdateEpilogueSceneObj.Func_ac1d1` .State14; `UpdateEpilogueSceneObj.Func_ac1d7` .State15; `UpdateEpilogueSceneObj.Func_ac1dd` .State16; `UpdateEpilogueSceneObj.Func_ac1fb` .State17; `UpdateEpilogueSceneObj.Func_ac21e` .State18; `UpdateEpilogueSceneObj.Func_ac22c` .State19; `UpdateEpilogueSceneObj.Func_ac23a` .State1a; `UpdateEpilogueSceneObj.Func_ac248` .State1b; `UpdateEpilogueSceneObj.Func_ac24e` .State1c; `UpdateTempleSceneObjAnimation.Func_ac358` .None; `UpdateTempleSceneObjAnimation.Func_ac359` .State02; `UpdateTempleSceneObjAnimation.Func_ac35e` .State03; `UpdateTempleSceneObjAnimation.Func_ac363` .State04; `UpdateTempleSceneObjAnimation.Func_ac368` .State05; `UpdateTempleSceneObjAnimation.Func_ac36d` .State06; `UpdateTempleSceneObjAnimation.Func_ac372` .State07; `UpdateTempleSceneObjAnimation.Func_ac377` .State08; `UpdateTempleSceneObjAnimation.Func_ac37c` .State09; `UpdateTempleSceneObjAnimation.Func_ac381` .State0a; `UpdateTempleSceneObjAnimation.Func_ac38b` .State0b; `UpdateTempleSceneObjAnimation.Func_ac386` .State0c; `UpdateTempleSceneObjAnimation.Func_ac399` .State0d; `UpdateTempleSceneObjAnimation.Func_ac39e` .State0e; `UpdateTempleSceneObjAnimation.Func_ac3a3` .State0f; `UpdateTempleSceneObjAnimation.Func_ac3ad` .State10; `UpdateTempleSceneObjAnimation.Func_ac3b7` .State11; `UpdateTempleSceneObjAnimation.Func_ac3bc` .State12; `UpdatePrologueSceneObj.Func_ac450` .None; `UpdatePrologueSceneObj.Func_ac451` .State02; `UpdatePrologueSceneObj.Func_ac456` .State03; `UpdatePrologueSceneObj.Func_ac45b` .State04; `UpdatePrologueSceneObj.Func_ac460` .State05; `UpdatePrologueSceneObj.Func_ac465` .State06; `UpdatePrologueSceneObj.Func_ac46a` .State07; `UpdatePrologueSceneObj.Func_ac46f` .State08; `UpdatePrologueSceneObj.Func_ac474` .State09; `UpdatePrologueSceneObj.Func_ac479` .State0a; `UpdatePrologueSceneObj.Func_ac48e` .State0b; `UpdatePrologueSceneObj.Func_ac493` .State0c; `UpdatePrologueSceneObj.Func_ac4a8` .State0d; `UpdatePrologueSceneObj.Func_ac4ad` .State0e; `UpdatePrologueSceneObj.Func_ac4b2` .State0f; `UpdatePrologueSceneObj.Func_ac4b7` .State10; `UpdatePrologueSceneObj.Func_ac4bc` .State11; `UpdatePrologueSceneObj.Func_ac4c1` .State12; `UpdatePrologueSceneObj.Func_ac4c7` .State13; `UpdatePrologueSceneObj.Func_ac4cd` .State14; `UpdatePrologueSceneObj.Func_ac4e3` .State15; `UpdatePrologueSceneObj.Func_ac4ee` .State16; `UpdatePrologueSceneObj.Func_ac4f4` .State17

#### bank20: path preview, events, top bar, highlight

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank20.asm:17 | `Func_80e85` -> `SaveGameAfterEpilogue` | Last `SST_OVERWORLD_EPILOGUE` sub-state in `OverworldStateTable` (state_table.asm:52); its only instruction is `call SaveGameOnReturnFromLevel`. Supersedes the second pass's low `FinishEpilogue`. | high |
| bank20.asm:836 | `Func_8143d`: `.Func_8146f` -> `.RunTracerStep` | `.RunTracerStep`: the `wPathPreviewState` jumptable (init/run tracers) of the unreferenced routine. | high |
| bank20.asm:1056 | `PathPreview_RunTracers`: `.Func_81615` -> `.UpdateTracer`; `.Func_81625` -> `.TracerInit`; `.Func_8167f` -> `.TracerGetTarget`; `.Func_816b3` -> `.TracerStartLine`; `.Func_816be` -> `.TracerWalk`; `.Func_816ea` -> `.TracerWait8`; `.Func_816f5` -> `.TracerDone`; `.Func_816f6` -> `.set_tracer_sprite`; `.asm_8167a` -> `.next_tracer_state` | Besides the six carried-over helpers (4.0): `.UpdateTracer` dispatches on tracer byte 7: 0 `.TracerInit` (start 8 px beside Wario in the tracer's direction; active only if that D-pad direction is allowed), 1 `.TracerGetTarget` (next connected level by index, $80 = none -> state 5), 2 `.TracerStartLine`, 3 `.TracerWalk` (line movement, next waypoint, `.set_tracer_sprite` picks sprite 1-4 from the line flags), 4 `.TracerWait8`, 5 `.TracerDone` (`ret`). `.next_tracer_state` = `.asm_8167a`. | high (medium: `.set_tracer_sprite`) |
| bank20.asm:1241 | `UpdatePathPreviewAnimations`: `.Func_8175d` -> `.animate_and_draw` | `.animate_and_draw`: frameset from `.framesets` by state, `OAM_aa0cf`. | high |
| bank20.asm:1302 | `Func_817b1` -> `UnreferencedSetLastEventCutsceneSelectable` | Marked unreferenced. Unless the game is cleared, finds the first locked event from `EVENT_PROLOGUE` up to `EVENT_BLUE_CRAYON`, loads the treasures of the event before it and makes its cutscene the top bar's cutscene button (`wStoredTransitionParam`, `SetCutsceneButtonSelectable_GotTransitionParam`). | medium |
| bank20.asm:1649 | `Func_819c6` -> `IsEventAlreadyUnlocked` | `CheckIfEventIsUnlocked` then `and c`: `c` is cleared by `CheckEventTreasure` when one of the event's treasures is `wLastTransitionParam`, so the result is non-zero only for an event unlocked before the current transition. Used for `wGotSunMedallion` (init.asm:304, 599) and the south map's castle patch (init.asm:710). | medium |
| bank20.asm:2821 | `DrawUnlockedLevels`: `.Func_81e88` -> `.draw_connection` | `.draw_connection`: draws the highlighted arrow(s) to the connected level(s) and the new level point for one entry. | high |
| bank20.asm:2896 | `Func_81f21` -> `PlacePendingOWTiles` | Writes `wHighlightOWTile` entries of (tile, attribute, tilemap pointer) starting at `wTileToPlaceInOW` into the tilemap and attrmap ($300 lower) and sets `wOWPendingTileUpdate`. Called from `UnlockLevel_HighlightTileAndAdvance`. (Here `wHighlightOWTile` is a count, not a flag.) | high |
| bank20.asm:3230 | `Func_8212c` -> `PlaceOWWarioAtCurLevel` | Level point of `wMapSideLevelID` (`GetMapLevelCoords`) into `wOWLevelYCoord`/`XCoord`, then Wario's position = point + the table's offset (`wOWYCoord1`, `wOWWarioYCoord`, ...). Called by `MapSide_Init`, `MapSide_ArriveAtLevel` and `InitMapSideCommon`. | high |
| bank20.asm:3402 | `StepOWLineMovement`: `.Func_82224` -> `.step_minor_axis`; `.Func_8222f` -> `.step_major_axis` | Bresenham step: `.step_minor_axis` when the error passes the major distance, then `.step_major_axis` (bit 0 of `wOWLineFlags` picks Y or X). | high |
| bank20.asm:3836 | `Func_824f1` -> `DrawTopBarSelectionSprite`; `Func_8250a` -> `DrawTopBarNextMapSprite`; `Func_82521` -> `AnimateTopBarSprite`; `Func_82521`: `.Func_82541` -> `.None`; `.Func_8259a` -> `.set_state_if_finished` | `DrawTopBar` = `Func_824f1` + `Func_8250a`: animate (`Func_82521`) and draw (`OAM_a9fe2`) `wOWUIObj1`, the selected button's highlight (X and state from `UpdateTopBar.button_data`), and `wOWUIObj2`, the NEXT MAP indicator (state $0b, $0c flashing). `Func_82521`: a state jumptable with `hl` = duration; the state names come from `.button_data` (`$07` day spell, `$03` cutscene, `$01` collection, `$0d` next map, `$09` prev map, `$05` night spell) and `HandleTopBarSelection.ShowPressedButton`, which adds 1 when the button is pressed; the pressed day/night states switch to the other spell when their animation ends (`.set_state_if_finished`). Slot 0 `.None`. | high (medium: `DrawTopBarSelectionSprite`, `DrawTopBarNextMapSprite`) |
| bank20.asm:4118 | `Func_8269f` -> `WriteTopBarButton`; `Data_826be` -> `TopBarButton_Unselectable`; `Data_826c6` -> `TopBarButton_DayNight`; `Data_826ce` -> `TopBarButton_Cutscene`; `Data_826d6` -> `TopBarButton_Collection`; `Data_826de` -> `TopBarButton_Selected`; `Data_826e6` -> `TopBarButton_CollectionSelected`; `Data_826ee` -> `TopBarButton_Pressed` | Writes a button's 8 bytes: 4 tile IDs as a 2x2 block two rows below `de`, then 4 attributes as a 2x2 block at `de`. The callers pass coordinates in `wAttrmap` rows 19-20, so the tiles land in rows 21-22, and `ApplyTopBarButtonAttributes` / `NOWFunc_DayNightSpell.Func_b57f4` copy rows 21-22 to VRAM0 and rows 19-20 to VRAM1 (BG map row 30): the existing "Attrs" names (`.LoadSelectableAttrs`, `ApplyTopBarButtonAttributes`) cover both. Tables: `Data_826be` non-selectable, `Data_826c6`/`826ce`/`826d6` selectable day-night/cutscene/collection, `Data_826de` selected (day-night and cutscene), `Data_826e6` selected collection, `Data_826ee` pressed; `NOWFunc_DayNightSpell` has local copies (`.visible_button_attr`, ...). | medium |
| bank20.asm:5002 | `HighlightLevel`: `.Func_82c55` -> `.Init`; `.Func_82c8f` -> `.Wait12`; `.Func_82c93` -> `.ShowStar`; `.Func_82cb0` -> `.WaitStarDone`; `.Func_82c51` -> `.Wait30`; `Func_82521`: `.Func_82543` -> `.Collection`; `.Func_82548` -> `.CollectionPressed`; `.Func_8254d` -> `.Cutscene`; `.Func_82552` -> `.CutscenePressed`; `.Func_82557` -> `.NightSpell`; `.Func_8255c` -> `.NightSpellPressed`; `.Func_82567` -> `.DaySpell`; `.Func_8256c` -> `.DaySpellPressed`; `.Func_82577` -> `.PrevMap`; `.Func_8257c` -> `.PrevMapPressed`; `.Func_82581` -> `.NextMapIndicator`; `.Func_82586` -> `.NextMapIndicatorFlash`; `.Func_8258b` -> `.NextMap`; `.Func_82590` -> `.NextMapPressed` | `HIGHLIGHT_LEVEL` steps as in `UnlockLevel_`: `.Init` (level to highlight from the scene param; the Gold Music Box uses 7; on the east side with param 7 and no Mystery Handle the action ends at once), `.Wait12`, the shared `OWScene_*` steps, `.ShowStar` (current object on the level, state 2, `SFX_104`), `.WaitStarDone`, `.Wait30`. | high |

#### bank21, bank26, init.asm

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank21.asm:55 | `DayNightTransition`: `.Func_84a8e` -> `.UnreferencedWait4` | `.Func_84a8e` is marked unreferenced: wait 4 frames, then `.AdvanceTable`. | high |
| bank21.asm:244 | `DaytimeTransition`: `.Func_84bad` -> `.Init`; `.Func_84bb6` -> `.Wait4`; `.Func_84bbf` -> `.Fade1`; `.Func_84bcd` -> `.Wait6`; `.Func_84bd6` -> `.LoadPal1`; `.Func_84be7` -> `.Fade2`; `.Func_84bf6` -> `.End` | The 7 steps of the third pass's `DaytimeTransition`: `.Init` (base/target palettes, delay 3), `.Wait4`, `.Fade1` (until 10 fade steps), `.Wait6`, `.LoadPal1` (and scene object 7 state $13), `.Fade2` (until $16 steps), `.End`. | high |
| bank21.asm:704 | `Data_84e39` -> `GreyOWPalsPointers`; `Pals_852dd` -> `TempleHintLevelNamePals` | `LoadGreyOWPals`: pointers to each side's grey palettes (east has a second one, used while the Blue Book or Magic Wand is missing). `Pals_852dd`: `FadeInLevelName` copies it over palette 7 while the temple hint is shown ("make level name blue"). | high |
| bank21.asm:1726 | `Data_8550b` -> `WOWTilemapPatch_Rain`; `Data_85549` -> `WOWTilemapPatch_Earthquake`; `Data_85536` -> `WOWTilemapPatch_VulcanoEruption`; `Data_8556e` -> `WOWTilemapPatch_RedMusicBox`; `Data_855b2` -> `SOWTilemapPatch_CanyonThunder`; `Data_85579` -> `SOWTilemapPatch_RaiseTower`; `Data_855f9` -> `SOWTilemapPatch_Earthquake`; `Data_8560e` -> `SOWTilemapPatch_GreenMusicBox`; `Data_8561f` -> `SOWTilemapPatch_RevealCastle`; `Data_8563e` -> `EOWTilemapPatch_Earthquake`; `Data_85657` -> `EOWTilemapPatch_FreezeSea`; `Data_85af4` -> `EOWTilemapPatch_FormCastle1`; `Data_85afd` -> `EOWTilemapPatch_FormCastle2`; `Data_85b0a` -> `EOWTilemapPatch_FormCastle3`; `Data_85b1b` -> `EOWTilemapPatch_FormCastle4`; `Data_85b2c` -> `EOWTilemapPatch_FormCastle5`; `Data_85b3d` -> `EOWTilemapPatch_FormCastle6`; `Data_85b48` -> `EOWTilemapPatch_VulcanoEruption` | Rule: the tilemap patches of `_ApplyOWTilemapPatches` (second-pass format) are each used by one map-side function, once by its `Init<side>OWObjects_<function>` (already done: draw the result) and once in the scene: `<side letter>OWTilemapPatch_<function>` with the function name of the third pass's `<side>OWFunc_<function>`. `Data_8561f` is applied by `LoadSouthOWBGMaps` when `EVENT_REVEAL_CASTLE` is done; `Data_85657` by `EOWFunc_FreezeSea`; the six `FormCastle` patches are rows 3-8 of the castle, applied bottom-up by `EOWFunc_FormCastle`. | high |
| bank21.asm:2085 | `Pals_8694d` -> `OWLightningFlashPals1`; `Pals_8698d` -> `OWLightningFlashPals2` | The lightning flash palettes of `WOWFunc_Rain` (`.pals_flash1` / `.pals_flash2`; the second also in `SOWFunc_CanyonThunder`). | medium |
| bank21.asm:2211 | `Pals_869cd` -> `PrologueBGPals`; `Pals_86a0d` -> `PrologueMusicBoxBGPals`; `Pals_86a4d` -> `TempleBGPals`; `Pals_86a8d` -> `PrologueOBPals`; `Pals_86acd` -> `PrologueCaveWarioPal`; `Pals_86ad5` -> `SceneWarioPal`; `Pals_86add` -> `EpilogueBGPals`; `Pals_86b1d` -> `EpilogueOBPals` | Prologue/epilogue palettes, by use in `_PrologueFade` and the scenes: `Pals_869cd` BG of the forest and cave (fade types 1/6, epilogue forest), `Pals_86a0d` BG of the music box close-up, `Pals_86a4d` the temple BG (fade types 2/5, `bank2b_1` temple scene), `Pals_86a8d` the OB palettes, `Pals_86acd` OB palette 0 in the cave (type 6), `Pals_86ad5` OB palette 0 in the temple and on the game over screen (black, white, skin, dark: Wario), `Pals_86add` / `Pals_86b1d` the epilogue BG / OB palettes. | medium (high: `EpilogueBGPals`, `EpilogueOBPals`) |
| bank26.asm:292 | `Func_9a54e` -> `ClearCollectionRAM`; `Func_9a559` -> `ClearCollectionSceneObjs` | Called by `InitTreasureCollection` (bank26.asm:161): zero $800 bytes from `wCollectionRow` and $200 from `wCurSceneObj`. | high |
| bank26.asm:1055 | `AnimateTreasureCollection`: `.Func_9aa4a` -> `.UpdateObj`; `OAM_9ac5d` -> `TreasureCollectionObjOAM`; `Frameset_9ace1` -> `TreasureCollectionObjFrameset1`; `Frameset_9acea` -> `TreasureCollectionObjFrameset2`; `Frameset_9acf3` -> `TreasureCollectionObjFrameset3`; `Frameset_9acfc` -> `TreasureCollectionObjFrameset4`; `Pals_9ad45` -> `TreasureCollectionBGPals`; `Pals_9ad05` -> `TreasureCollectionOBPals` | `.UpdateObj`: the state jumptable of scene objects 1-10 (carried-over `TreasureCollectionObjState*`). Its OAM and the four framesets those states set: `TreasureCollectionObjOAM`, `TreasureCollectionObjFrameset1`..`4`. `Pals_9ad45` / `Pals_9ad05` are loaded as BG / OB palettes by `InitTreasureCollection`. | high |
| init.asm:325 | `InitEastMapSide`: `.Func_80655` -> `.check_red_key_card` | `.check_red_key_card`: when the transition is the Blue Key Card and the Red one isn't collected yet, there is no cutscene to play (`SetStoredTransitionParamAsReturnToMap`). | medium |
| init.asm:331 | `Func_8065e` -> `InitMapSideCommon`; `Func_8086f` -> `InitMapSideForSceneCommon`; `Func_80ae7` -> `LoadWestOWBGMaps`; `Func_80af5` -> `LoadSouthOWBGMaps`; `Func_80b1b` -> `LoadEastOWBGMaps`; `Func_80b54` -> `InitOWAnimations`; `Func_80bd9` -> `ClearBGPriorityBottomLeft` | The common tail of the four `Init<Side>MapSide` routines (init.asm:284-323); `Func_8086f` the common tail of the `InitMapSideForScene_<Side>` ones. `Func_80ae7`/`80af5`/`80b1b`: `LoadBGMapsToWRAM` with the west/south/east map (the south one adds the castle patch). `Func_80b54`: sets the cloud and sea animation durations (`w2d032`.., second pass `wOWBigCloud*Anim`) and clears the counters. `Func_80bd9`: clears `BG_PRIO` at (0, 14) and in a 3x4 rectangle at (0, 15) of `wAttrmap`; called by `InitMapSideCommon` and bank2d.asm:279. | high |

#### bank56: temple rocks, transformation sparkles, prologue particles, best times

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank56.asm:130 | `Func_1580c8` -> `WaitTempleRockRespawn` | The `.Reset` action of the `temple_rock_fall` macro jumps here with `hl` = `wTempleRockNRespawnTime`: when the counter reaches it, the rock spawns again (action 1) if its size is non-zero, otherwise the rock stops. | high |
| bank56.asm:388 | `Func_15848a` -> `UpdateTransformationSparkles`; `Func_15848a`: `.Func_15849a` -> `.UpdateLight`; `.Func_1584a6` -> `.LightIdle`; `.Func_1584ab` -> `.SpawnLight`; `.Func_1584c4` -> `.LowerLight`; `.Func_1584da` -> `.UpdateSparkle1`; `.Func_1584e8` -> `.Sparkle1_WaitLight`; `.Func_1584f4` -> `.Sparkle1_Spawn`; `.Func_15850d` -> `.Sparkle1_Rise`; `.Func_158529` -> `.UpdateSparkle2`; `.Func_15853b` -> `.Sparkle2_WaitLight`; `.Func_158547` -> `.Sparkle2_Wait10`; `.Func_15854d` -> `.Sparkle2_Spawn`; `.Func_158566` -> `.Sparkle2_Rise`; `.Func_158580` -> `.Sparkle2_Repeat`; `.Func_15858c` -> `.UpdateSparkle3`; `.Func_15859a` -> `.Sparkle3_WaitLight`; `.Func_1585a6` -> `.Sparkle3_Spawn`; `.Func_1585bf` -> `.Sparkle3_Rise`; `.Func_1585e1` -> `.UpdateSparkle4`; `.Func_1585f3` -> `.Sparkle4_WaitLight`; `.Func_1585ff` -> `.Sparkle4_Wait8`; `.Func_158605` -> `.Sparkle4_Spawn`; `.Func_15861e` -> `.Sparkle4_Rise`; `.Func_15863e` -> `.Sparkle4_Repeat`; `.Func_15864a` -> `.get_rise_offset_1`; `.Func_15866e` -> `.get_rise_offset_2` | Called every frame by the epilogue's `.Transformation` step (`farcall`). Five small scripts: `.UpdateLight` (`wSceneAuxStep`, started by the epilogue's `.SetObjsPal4`): scene object 1 state $16 appears at Y $18 above object 9 (the creature) and moves down 1 px every 4 frames to Y $58 (the epilogue flashes and transforms when it passes $50); then four `.UpdateSparkleN` for objects 5-8: when object 1 is active, spawn next to it (state $15, $14 after 3 frames) and rise along `.data_1`/`.data_2` (`.get_rise_offset_1/2`); sparkles 2 and 4 wait 10/8 frames first and repeat while object 1 is active, 1 and 3 run once. "Light"/"sparkle" are guesses from the movement (object 1's state also plays `SFX_08E` every 48 frames, `UpdateEpilogueSceneObj.PlaySFX08EEvery48Frames`). The scripts keep their step/counter bytes in `wTempleMusicBox1`.., `wPlanePart2Counter` and `wPalFade2Colour3GreenUnk1`: borrowed labels (RAM notes). | medium (high: `.LightIdle`, `.get_rise_offset_1`, `.get_rise_offset_2`) |
| bank56.asm:721 | `Func_15868e` -> `UpdateNOWPrologueParticles`; `Func_15868e`: `.Func_1586a1` -> `.UpdateObj2`; `.Func_1586b5` -> `.Obj2_None`; `.Func_1586c1` -> `.Obj2_PlaceUpLeft`; `.Func_1586d1` -> `.Obj2_Arc1`; `.Func_1586b6` -> `.Obj2_PlaceCenter`; `.Func_1586dd` -> `.Obj2_Arc2`; `.Func_1586c9` -> `.Obj2_PlaceDownLeft`; `.Func_1586e2` -> `.Obj2_Arc3`; `.Func_1586e7` -> `.Obj2_Loop`; `.Func_158785` -> `.UpdateObj3`; `.Func_158799` -> `.Obj3_None`; `.Func_1587a5` -> `.Obj3_PlaceUpRight`; `.Func_1587b5` -> `.Obj3_Arc1`; `.Func_15879a` -> `.Obj3_PlaceCenter`; `.Func_1587c1` -> `.Obj3_Arc2`; `.Func_1587ad` -> `.Obj3_PlaceDownRight`; `.Func_1587c6` -> `.Obj3_Arc3`; `.Func_1587cb` -> `.Obj3_Loop`; `.Func_1586ed` -> `.UpdateObj5`; `.Func_158701` -> `.Obj5_None`; `.Func_158702` -> `.Obj5_PlaceCenter`; `.Func_158729` -> `.Obj5_Arc2`; `.Func_158715` -> `.Obj5_PlaceDownLeft`; `.Func_15872e` -> `.Obj5_Arc3`; `.Func_15870d` -> `.Obj5_PlaceUpLeft`; `.Func_15871d` -> `.Obj5_Arc1`; `.Func_158733` -> `.Obj5_Loop`; `.Func_1587d1` -> `.UpdateObj8`; `.Func_1587e5` -> `.Obj8_None`; `.Func_1587e6` -> `.Obj8_PlaceCenter`; `.Func_15880d` -> `.Obj8_Arc2`; `.Func_1587f9` -> `.Obj8_PlaceDownRight`; `.Func_158812` -> `.Obj8_Arc3`; `.Func_1587f1` -> `.Obj8_PlaceUpRight`; `.Func_158801` -> `.Obj8_Arc1`; `.Func_158817` -> `.Obj8_Loop`; `.Func_158739` -> `.UpdateObj9`; `.Func_15874d` -> `.Obj9_None`; `.Func_158761` -> `.Obj9_PlaceDownLeft`; `.Func_15877a` -> `.Obj9_Arc3`; `.Func_158759` -> `.Obj9_PlaceUpLeft`; `.Func_158769` -> `.Obj9_Arc1`; `.Func_15874e` -> `.Obj9_PlaceCenter`; `.Func_158775` -> `.Obj9_Arc2`; `.Func_15877f` -> `.Obj9_Loop`; `.Func_15881d` -> `.UpdateObj10`; `.Func_158831` -> `.Obj10_None`; `.Func_158845` -> `.Obj10_PlaceDownRight`; `.Func_15885e` -> `.Obj10_Arc3`; `.Func_158832` -> `.Obj10_PlaceCenter`; `.Func_158859` -> `.Obj10_Arc2`; `.Func_15883d` -> `.Obj10_PlaceUpRight`; `.Func_15884d` -> `.Obj10_Arc1`; `.Func_158863` -> `.Obj10_Loop`; `.Func_158869` -> `.place_center`; `.Func_15887b` -> `.place_up_left`; `.Func_158882` -> `.place_up_right`; `.Func_158889` -> `.place_down_left`; `.Func_158890` -> `.place_down_right`; `Data_158897` -> `NOWPrologueParticleArc1`; `Data_1588de` -> `NOWPrologueParticleArc2`; `Data_158925` -> `NOWPrologueParticleArc3` | Called every frame by `NOWFunc_Prologue` (the third pass's low `UpdateNOWPrologueObjs`). Six identical scripts, one per scene object (2, 3, 5, 8, 9, 10; started one by one by the prologue OW function through `w2d150`, `w2d151`, `wd152`..`wd155`): place the object next to (y $30, x $50) with a random state $29/$2a, move it along one of three arcs (`Data_158897` / `Data_1588de` / `Data_158925`; objects 3, 8 and 10 mirrored), three times, then loop. Locals per object: `.UpdateObjN`, `.ObjN_None` (slot 0, `ret`), `.ObjN_Place<where>`, `.ObjN_Arc<1-3>`, `.ObjN_Loop`; the placement helpers by offset from the centre (`.place_up_left` = (y $2e, x $4e), ...). | high (medium: `UpdateNOWPrologueParticles`, `NOWPrologueParticleArc1`, `NOWPrologueParticleArc2`, `NOWPrologueParticleArc3`) |
| bank56.asm:1243 | `_InitBestTimeList`: `.Func_158a09` -> `.clear_ram`; `_BestTimeList`: `.Func_158ac2` -> `.StopAutoScrollOnInput`; `Pals_158b63` -> `BestTimeListPals` | `.clear_ram`: the same $800-byte clear from `wCollectionRow` as `ClearCollectionRAM`. `_BestTimeList.StopAutoScrollOnInput`: A/B/START/UP/DOWN stops the automatic scroll (which keeps its state in `wCollectionRow`, `wCollectionCol`, `wColourFadeDiff` and `wCollectionLinkStateCounter`, borrowed from the collection). `Pals_158b63`: loaded by `_InitBestTimeList`. | high |

#### bank2d: map-side inits, OW function scenes, map animations

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank2d.asm:57 | `InitNOWObjects_CutTree`: `.Func_b4055` -> `.InitDayNightObjs`; `Func_b4082` -> `PlaceTempleHintObj` | `.InitDayNightObjs` places objects 15 and 14 in their day states $19/$1b, or $18/$1a at night: the states `UpdateNorthOWObjMapAnim`'s `.Obj15WaitForDay` etc. switch. The cut-tree init runs for every north map (its event is the first), so it also places the permanent objects; `Func_b4082` puts object 13 at ($84, $82), the object `TempleHint_FadeInName` shows with state $1c. | high (medium: `PlaceTempleHintObj`) |
| bank2d.asm:984 | `InitEOWObjects_FormCastle`: `.Func_b4757` -> `.InitDayNightObj7` | `.InitDayNightObj7`: object 7 at ($28, $28) in state $12 (night), $13 by day, unless the action is `UNLOCK_LEVEL`; the same states as `EastOWObj7WaitForDay`/`ForNight` below. | medium |
| bank2d.asm:1140 | `Func_b4874` -> `LoadUnfrozenSeaPal`; `Func_b4895` -> `UnreferencedPlaceOWTile` | Copies `.pal` into BG palette 4 (`wTempPals1`): used by `InitEOWObjects_FreezeSea` when the event isn't unlocked; after the freeze `EOWFunc_FreezeSea.load_frozen_sea_pal` copies palette 4 of `Pals_84480` instead (the `call Func_b4874` after its `jr` is unreachable). `Func_b4895`: no reference; like `InitSceneObjParams` but writes a tile and attribute at an OW coordinate (`GetOWCoordInTilemap`). | medium (high: `UnreferencedPlaceOWTile`) |
| bank2d.asm:1827 | `Func_b4dd4` -> `PlaySFX12F`; `Func_b4f58` -> `UpdateWestOWPal5FromObj11`; `Func_b50e1` -> `AnimateNorthOWObj3` | `SFX_12F` when `SouthOWObjState1a`'s animation ends (its only caller). `Func_b4f58`: tail of `WestOWObjState1e`/`1f`: BG palette 5 from `wTempPals1`, or the bright `.pal` while object 11 is active and not on frame $57, plus a palette config. `Func_b50e1`: tail of `NorthOWObjState22`/`23`: animate, draw with `OAM_aa580`, a third north sprite set next to `AnimateNorthOWObj`/`AnimateNorthOWObj2`. | medium (high: `PlaySFX12F`) |
| bank2d.asm:2666 | `NOWFunc_FallLeaves`: `.Func_b5316` -> `.SetObj7State14`; `UpdateNorthLeaves`: `.Func_b544a` -> `.Leaf1_SetState12`; `.Func_b5461` -> `.Leaf1_SetState13`; `.Func_b5471` -> `.Leaf1_Reset`; `.Func_b5486` -> `.Leaf1_Wait90`; `.Func_b548e` -> `.Leaf1_Sink`; `.Func_b549e` -> `.Leaf1_Restart`; `.Func_b54cf` -> `.Leaf2_SetState12`; `.Func_b54e6` -> `.Leaf2_SetState13`; `.Func_b54f6` -> `.Leaf2_Reset`; `.Func_b550b` -> `.Leaf2_Wait90`; `.Func_b5513` -> `.Leaf2_Sink`; `.Func_b5523` -> `.Leaf2_Restart` | `.SetObj7State14`. The two leaf scripts of `UpdateNorthLeaves` follow the third-pass description step by step: `.LeafN_SetState12` (after 120 frames), `.LeafN_SetState13` (90), `.LeafN_Reset` (40, state $10 at Y $38), `.LeafN_Wait90`, `.LeafN_Sink` (1 px every 16 frames to Y $48), `.LeafN_Restart` (frameset frame $46, state $11, back to step 1). | high |
| bank2d.asm:3372 | `NOWFunc_DayNightSpell`: `.Func_b57f4` -> `.copy_top_bar_to_vram`; `.Func_b5827` -> `.write_day_night_button` | `.copy_top_bar_to_vram`: HDMA of `wAttrmap` rows 21-22 (tiles) to VRAM0 and rows 19-20 (attributes) to VRAM1 at BG map row 30. `.write_day_night_button`: `WriteTopBarButton` inlined for (11, 19). | high |
| bank2d.asm:3428 | `Func_b5849` -> `UnreferencedWaitOWFunc4` | Marked unreferenced: `ld a, 4` falling into `WaitOWFunc`. | high |
| bank2d.asm:3524 | `NOWFunc_Prologue`: `.Func_b5949` -> `.StartShake`; `.Func_b5965` -> `.RequestShake4`; `.Func_b5973` -> `.WaitShake5ThenShowObj1`; `.Func_b598c` -> `.WaitShakeEnd`; `.Func_b59a5` -> `.StartObj2Particles`; `.Func_b59ca` -> `.StartObj8Particles`; `.Func_b59c5` -> `.StartObj5Particles`; `.Func_b59d4` -> `.StartObj10Particles`; `.Func_b59cf` -> `.StartObj9Particles`; `.Func_b59b6` -> `.StartObj3Particles`; `.Func_b59de` -> `.StopSFXLoop`; `.Func_b59e5` -> `.PlaySFX08EEvery48Frames` | The north-map half of the prologue. `.StartShake` (after 60 frames: shake request 1 in `wOWUIObj1YCoord`, rough sea, sea animation speed 3 in `w2d03e`), `.RequestShake4` (after 134), `.WaitShake5ThenShowObj1` (object 1 state $2b, `SFX_061`), `.WaitShakeEnd` (sea back to normal), then the six `UpdateNOWPrologueParticles` scripts are started 6 frames apart (`.StartObj2Particles`.. in the order 2, 8, 5, 10, 9, 3; the first also turns on `.PlaySFX08EEvery48Frames` through `wOWUIObj2Attributes`), and `.StopSFXLoop` ends the function. | high (medium: `.StartShake`) |
| bank2d.asm:4014 | `WOWFunc_Earthquake`: `.Func_b5c94` -> `.StartShake`; `.Func_b5cc4` -> `.StopShake`; `.Func_b5d0a` -> `.UpdateFallingRocks`; `.Func_b5d25` -> `.Rock1`; `.Func_b5d34` -> `.Rock2`; `.Func_b5d3e` -> `.Rock3`; `.Func_b5d48` -> `.Rock4`; `.Func_b5d52` -> `.RockWait10`; `.Func_b5d5a` -> `.RocksRestart`; `.asm_b5d2d` -> `.next_rock` | `.StartShake` / `.StopShake` (shake request 1 / 3, objects 11 and 10 to states $17/$19 and $18/$1a, rough / normal sea). `.UpdateFallingRocks` (sub-steps in `wOWUIObj1Duration`/`FramesetOffset`, borrowed): every 10 frames one of objects 13, 15, 14, 12 gets a falling state ($14/$15), and the cycle repeats until `.StopShake`; `.DropRocks` (existing) is the last one. | high (medium: `.UpdateFallingRocks`, `.Rock1`, `.Rock2`, `.Rock3`, `.Rock4`) |
| bank2d.asm:4173 | `WOWFunc_VulcanoEruption`: `.Func_b5dac` -> `.StartShake`; `.Func_b5dd7` -> `.SetObj11State1f`; `.Func_b5dfa` -> `.WaitObj11Disappear`; `.Func_b5e02` -> `.RequestShake4`; `.Func_b5e10` -> `.Flash`; `.Func_b5e73` -> `.EruptAndPatchTiles`; `.Func_b5eb7` -> `.LaunchRock1`; `.Func_b5ec7` -> `.LaunchRock2`; `.Func_b5ed4` -> `.LaunchRock3`; `.Func_b5ee1` -> `.LaunchRock4`; `.Func_b5eee` -> `.LaunchRock5`; `.Func_b5efb` -> `.LaunchRock6`; `.Func_b5f08` -> `.WaitRocksLanded`; `.Func_b5f15` -> `.StartShake2`; `.Func_b5f33` -> `.StopShakeAtStep1b`; `.Func_b5f50` -> `.WaitShakeEnd`; `.Func_b5f58` -> `.UpdateLeftRock`; `.Func_b5f70` -> `.LeftRock_Launch46`; `.Func_b5f89` -> `.LeftRock_Fall`; `.Func_b5f9c` -> `.LeftRock_Launch75`; `.Func_b5fa1` -> `.LeftRock_FallSteep`; `.Func_b5fad` -> `.LeftRock_Launch46Alt`; `.Func_b5fb4` -> `.LeftRock_Launch75Alt`; `.Func_b5fb9` -> `.UpdateRightRock`; `.Func_b5fd1` -> `.RightRock_Launch98`; `.Func_b5fea` -> `.RightRock_Fall`; `.Func_b5ffd` -> `.RightRock_Launch93`; `.Func_b6002` -> `.RightRock_FallSteep`; `.Func_b600e` -> `.RightRock_Launch98Alt`; `.Func_b6015` -> `.RightRock_Launch93Alt`; `.Func_b601a` -> `.UpdateMiddleRock` | Steps: `.StartShake` (as in the earthquake), `.SetObj11State1f` (at (16, $52), with a palette-5 config), `.WaitObj11Disappear`, `.RequestShake4`, `.Flash` (object 10 $1a, normal sea, `FillPalsWithFlashColour` on the BG and OB palettes, `Func_b6055`'s sound on), `.EruptAndPatchTiles` (object 11 $1b, `WOWTilemapPatch_VulcanoEruption`, palettes back), six `.LaunchRockN` (start the left/right rock scripts in `w2d122`/`w2d126` or the middle one `w2d12c`, `SFX_TEMPLE_ROCK`), `.WaitRocksLanded`, `.StartShake2` (request 8), `.StopShakeAtStep1b` (when the shake script reaches step $1b), `.WaitShakeEnd`. Rock scripts: `.UpdateLeftRock` (object 1) / `.UpdateRightRock` (object 3): launch from Y 8 at X 46 or 75 (right: 98 or 93) in state $1c/$1d (`Alt`: $1f/$20), then fall 2 px left/right and 2 (or 4, `Steep`) px down per frame to Y $88; `.UpdateMiddleRock` (object 6). "Rock" from `SFX_TEMPLE_ROCK`; they may be lava bombs. | medium (high: `.StartShake`, `.SetObj11State1f`, `.WaitObj11Disappear`, `.RequestShake4`, `.Flash`, `.StartShake2`, `.StopShakeAtStep1b`, `.WaitShakeEnd`) |
| bank2d.asm:4619 | `Func_b6055` -> `PlayVolcanoRumbleSFX` | Called every frame by both volcano eruptions: while `wOWUIObj2Attributes` is set, `SFX_076` every $1a frames (the same sound the rain scene uses for thunder). | medium |
| bank2d.asm:4649 | `WOWFunc_RedMusicBox`: `.Func_b608a` -> `.PlaySFX076Loop`; `.Func_b60aa` -> `.PlayMusicBoxSFX`; `.Func_b60ba` -> `.SetObj6State20AndPatchTiles`; `.Func_b60d5` -> `.SetObj6State21`; `.Func_b60e9` -> `.SetObj6State22`; `.Func_b60f4` -> `.StopSFXLoop` | `.PlaySFX076Loop` (every $1b frames while object 6's movement byte is set), `.PlayMusicBoxSFX` (`SFX_121`, the tune), `.SetObj6State20AndPatchTiles` (`WOWTilemapPatch_RedMusicBox`), `.SetObj6State21`, `.SetObj6State22`, `.StopSFXLoop`. | high |
| bank2d.asm:4716 | `Data_b6101` -> `FallLeavesLiftMovement`; `Data_b6196` -> `FallLeavesBlowAwayMovement`; `Data_b6239` -> `FallLeavesSplitMovement`; `Data_b6294` -> `CrayonScribbleMovement`; `Data_b6337` -> `OWTornadoMovement`; `Data_b6478` -> `ClearTornadoMovement`; `Data_b64cd` -> `FormCastleObj1Movement` | `ApplyOWMovement` tables: `NOWFunc_FallLeaves.HandleLeaf1/3Movement` lift a leaf (`Data_b6101`), then blow it away (`Data_b6196`) while a second object split off it moves along `Data_b6239`; `Data_b6294` the crayon's scribble (`.Scribble`, bank2d.asm:3087); `Data_b6337` `UpdateOWTornado`; `Data_b6478` `WOWFunc_ClearTornado.ClearTornado`; `Data_b64cd` object 1 in `EOWFunc_FormCastle`. | high (medium: `FallLeavesSplitMovement`, `FormCastleObj1Movement`) |
| bank2d.asm:5623 | `SOWFunc_CanyonThunder`: `.Func_b67c7` -> `.Wait34`; `.Func_b67d1` -> `.Lightning1`; `.Func_b67ec` -> `.FlashWait16`; `.Func_b67f4` -> `.Lightning2`; `.Func_b67f9` -> `.FlashWait54`; `.Func_b6801` -> `.Lightning3`; `.Func_b6810` -> `.WaitFlashDone`; `.Func_b6820` -> `.StartBarrage`; `.Func_b6828` -> `.WaitBarrage`; `.Func_b6971` -> `.FlashWhite`; `.Func_b6836` -> `.SetObj5State0aAndPatchTiles`; `.Func_b684c` -> `.LoadNormalPals`; `.Func_b6968` -> `.FadeEvery2Frames`; `.Func_b6869` -> `.step_flash_from_5`; `.Func_b6879` -> `.step_flash`; `.Func_b68cd` -> `.UpdateBarrage`; `.Func_b68ee` -> `.Barrage_Bolt1`; `.Func_b6919` -> `.Barrage_FlashWait7`; `.Func_b6925` -> `.Barrage_Wait7`; `.Func_b692e` -> `.Barrage_Bolt2`; `.Func_b6938` -> `.Barrage_Bolt3`; `.Func_b6942` -> `.Barrage_Bolt4`; `.Func_b694c` -> `.Barrage_Bolt5`; `.Func_b6960` -> `.Barrage_End` | `.Wait34` is a wait step behind a `vc_hook` line (why rule 3 missed it). Steps: three strikes (`.Lightning1`: object 2 state $12; `.Lightning2`: object 10 $12; `.Lightning3`: object 2 $17 at ($56, $47); each `SFX_124` and a flash) with `.FlashWait16` / `.FlashWait54` / `.WaitFlashDone` stepping the flash; `.StartBarrage`/`.WaitBarrage` run `.UpdateBarrage` (`w2d124`: five more strikes on objects 1/2/10 at fixed places, 7 frames apart); `.FlashWhite`, fade, `.SetObj5State0aAndPatchTiles` (`SOWTilemapPatch_CanyonThunder`), `.LoadNormalPals`, `.FadeEvery2Frames`. `.step_flash` (counter 1 flash palettes `OWLightningFlashPals2`, 5 white, 9 normal) and `.step_flash_from_5` (5 white, 9 flash). The objects are the lightning bolts (`SFX_124`, flashes); medium for that word. | high (medium: `.Lightning1`, `.Lightning2`, `.Lightning3`, `.StartBarrage`, `.WaitBarrage`, `.UpdateBarrage`, `.Barrage_Bolt1`, `.Barrage_Bolt2`, `.Barrage_Bolt3`, `.Barrage_Bolt4`, `.Barrage_Bolt5`) |
| bank2d.asm:5983 | `SOWFunc_RaiseTower`: `.Func_b6a0f` -> `.SettleTower`; `.Func_b6a16` -> `.move_tower_up`; `.Func_b6a2e` -> `.move_tower_up_slowly`; `.Func_b6a4b` -> `.HideObjsAndPatchTiles` | `.SettleTower` (rises slowly with `.move_tower_up_slowly` until Y $48); `.move_tower_up` (up 1 px every other frame, down 1 every 8th: a shaking rise; z at Y $48); `.HideObjsAndPatchTiles` (objects 2 and 3 off, `SOWTilemapPatch_RaiseTower`). | high (medium: `.SettleTower`) |
| bank2d.asm:6064 | `SOWFunc_Fan`: `.Func_b6a90` -> `.StartFan`; `.Func_b6aa8` -> `.StartWind1`; `.Func_b6ab0` -> `.StartWind2`; `.Func_b6abe` -> `.WaitObj9Frame21`; `.Func_b6ad4` -> `.RaiseObj9`; `.Func_b6aea` -> `.WaitWind2Done`; `.Func_b6af2` -> `.UpdateWind1`; `.Func_b6b08` -> `.Wind1_Spawn`; `.Func_b6b22` -> `.Wind1_Drift`; `.Func_b6b3b` -> `.Wind1_End`; `.Func_b6b48` -> `.UpdateWind2`; `.Func_b6b62` -> `.Wind2_Spawn`; `.Func_b6b7c` -> `.Wind2_Drift`; `.Func_b6b95` -> `.Wind2_Hide`; `.Func_b6ba2` -> `.Wind2_WaitFanFrame4a`; `.Func_b6bb8` -> `.Wind2_HideFan` | `.StartFan` (object 8 state $1a, `SFX_12F`), `.StartWind1`/`.StartWind2` (scripts `w2d122`/`w2d124`: three puffs, objects 1/2 in state $18 drift up-right from ($5c, $82) to X $8c, 1 px every 2 frames), `.WaitObj9Frame21` (then object 9 state $11), `.RaiseObj9` (1 px every 8 frames to Y $45), `.WaitWind2Done`; the second script then waits for the fan's frame $4a (state $19) and removes it 24 frames later. "Wind" is a guess from the drift. | medium (high: `.WaitObj9Frame21`, `.RaiseObj9`) |
| bank2d.asm:6346 | `SOWFunc_Earthquake`: `.Func_b6c5d` -> `.StartShake`; `.Func_b6c78` -> `.PatchTilesAndShowSmoke`; `.Func_b6c91` -> `.WaitSmokeGone`; `.Func_b6c97` -> `.ShowSmoke2`; `.Func_b6ca4` -> `.StopShake` | Same shake requests as the other earthquakes; object 2 state $1b is the smoke (`SOWFunc_GreenMusicBox.HideSmoke` waits on the same object/state): `.PatchTilesAndShowSmoke` (`SOWTilemapPatch_Earthquake`, `SFX_061`), `.WaitSmokeGone`, `.ShowSmoke2` (moved by (+2, −2)). | high |
| bank2d.asm:6495 | `EOWFunc_Explosives`: `.Func_b6d5a` -> `.Explode`; `.Func_b6d6d` -> `.WaitExplosionGone`; `.Func_b6d73` -> `.Explode2`; `.Func_b6d83` -> `.Explode3`; `.Func_b6d88` -> `.EastExplode`; `.Func_b6dcd` -> `.FadeOutLevelName`; `.Func_b6d9c` -> `.LoadColossalHoleName`; `.Func_b6daa` -> `.EastExplode2`; `.Func_b6db4` -> `.EastExplode3` | South branch: `.Explode` (object 2 state $1c, `SFX_129`), `.WaitExplosionGone`, `.Explode2` / `.Explode3` (offsets from ($20, $44)); east branch: `.EastExplode` (object 2 state 8), `.FadeOutLevelName`, `.LoadColossalHoleName`, `.EastExplode2` (object 1 $22), `.EastExplode3` (object 2 $22 at ($46, $50)). | high |
| bank2d.asm:6753 | `EOWFunc_FreezeSea`: `.Func_b6eea` -> `.Wait60_2`; `.Func_b6ef4` -> `.PatchSeaTiles`; `.Func_b6f00` -> `.StartObj1Move`; `.Func_b6f11` -> `.StartTileColumns3`; `.Func_b6f23` -> `.StartTileColumns1`; `.Func_b6f3a` -> `.StartTileColumns2`; `.Func_b6f4a` -> `.WaitObj1Done`; `.Func_b6f52` -> `.load_frozen_sea_pal`; `.Func_b6f77` -> `.MoveObj1`; `.Func_b6fae` -> `.UpdateTileColumns1`; `.Func_b6ffe` -> `.UpdateTileColumns2`; `.Func_b7056` -> `.UpdateTileColumns3` | `.Wait60_2` (rule 3; `.Wait60` exists), `.PatchSeaTiles` (`EOWTilemapPatch_FreezeSea` + frozen palette 4), `.StartObj1Move` (stops the sea animation, starts `.MoveObj1`: right 2 px/frame, rising 1 px every 4 frames past X $60, until X $a8), `.StartTileColumns1`..`3` and `.UpdateTileColumns1`..`3`: the three column copiers of the third pass (`CopyOWTileColumn1`..`3`) reading `.data` every 5 frames (the second and third add $140 / $280 to the source), `.WaitObj1Done`. | high (medium: `.load_frozen_sea_pal`) |
| bank2d.asm:7062 | `EOWFunc_Earthquake`: `.Func_b7142` -> `.SetSinkAreaPriority`; `.Func_b7160` -> `.SetObj6State03`; `.Func_b7170` -> `.StartShake`; `.Func_b7188` -> `.SinkObj6_1`; `.Func_b7195` -> `.SinkObj6_2`; `.Func_b71a2` -> `.SinkObj6_3`; `.Func_b71af` -> `.SinkObj6_4`; `.Func_b71bc` -> `.SinkObj6_5`; `.Func_b71c9` -> `.StopShake`; `.Func_b71d9` -> `.SetObj6State05`; `.Func_b71e4` -> `.WaitObj6Frame09`; `.Func_b71ed` -> `.PatchTiles` | `.SetSinkAreaPriority` (BG priority for 4x2 tiles at (2, 10)), `.SetObj6State03`, `.StartShake` (request 1, object 15 $06, object 6 $04), `.SinkObj6_1`..`_5` (object 6 down 1 px after 10, 32, 28, 24, 20 frames), `.StopShake` (request 3, object 15 $07), `.SetObj6State05`, `.WaitObj6Frame09`, `.PatchTiles` (`EOWTilemapPatch_Earthquake`). | high (medium: `.SetSinkAreaPriority`) |
| bank2d.asm:7194 | `UpdateOWSceneScreenShake`: `.Func_b721f` -> `.StartScript01`; `.Func_b721e` -> `.DoNothing`; `.Func_b7231` -> `.WaitStep01ThenStop`; `.Func_b723f` -> `.WaitStep01ThenStart11`; `.Func_b7245` -> `.StartScript11`; `.Func_b7249` -> `.WaitStep11ThenStop`; `.Func_b7257` -> `.StartScript15`; `.Func_b725b` -> `.WaitScriptEnd_1`; `.Func_b7265` -> `.StartScript1e`; `.Func_b7269` -> `.WaitScriptEnd_2`; `.asm_b7221` -> `.start_script`; `.Func_b72f8` -> `.Up1SFX`; `.Func_b72e0` -> `.Hold1`; `.Func_b730b` -> `.Down1`; `.Func_b7300` -> `.Up1`; `.Func_b72e8` -> `.Hold1Loop`; `.Func_b7311` -> `.Up4SFX`; `.Func_b72c8` -> `.Hold3`; `.Func_b7322` -> `.Down4`; `.Func_b72d0` -> `.Hold3Loop`; `.Func_b733b` -> `.Right4SFX`; `.Func_b7343` -> `.Right4`; `.Func_b7379` -> `.Left8`; `.Func_b7387` -> `.Right8`; `.Func_b734c` -> `.Right4End`; `.Func_b7363` -> `.Right1SFX`; `.Func_b7334` -> `.Left2`; `.Func_b735c` -> `.Right2`; `.Func_b7371` -> `.Right1End`; `.Func_b732b` -> `.UnreferencedLeft4`; `.asm_b736b` -> `.right_1` | The request handler (`wOWUIObj1YCoord`, values 1-11) starts the shake script at step $01, $11, $15 or $1e (`.start_script`) and waits for a step or for the end (`.WaitStep01ThenStop`, `.WaitScriptEnd_1`, ...); request 2 is a `ret` (`.DoNothing`). Script steps (`.RunShakeScript`): `.UpN`/`.DownN`/`.LeftN`/`.RightN` move `wSCY`/`wSCX` by N, `SFX` ones also play `SFX_01F`/`SFX_063`, `.Hold1`/`.Hold3` wait 1/3 frames, `.Hold1Loop`/`.Hold3Loop` go back $10/4 steps, `...End` stops the script. `.Func_b732b` (`.UnreferencedLeft4`) has no reference. | high |
| bank2d.asm:7477 | `EOWFunc_FormCastle`: `.Func_b73ce` -> `.SetObj1State10`; `.Func_b73e6` -> `.SetUnusedW2d121`; `.Func_b73ee` -> `.MoveObj1AndFadePals`; `.Func_b741b` -> `.move_obj1`; `.Func_b7430` -> `.SetObj1State11`; `.Func_b743b` -> `.PatchCastle6`; `.Func_b744a` -> `.PatchCastle5`; `.Func_b7459` -> `.PatchCastle4`; `.Func_b7468` -> `.PatchCastle3`; `.Func_b7477` -> `.PatchCastle2`; `.Func_b7486` -> `.PatchCastle1`; `.Func_b7495` -> `.SetObj7State12`; `.Func_b74a5` -> `.HideObj1`; `.Func_b74b0` -> `.FadePalsBack`; `.Func_b74cb` -> `.UpdatePalFade`; `.Func_b7544` -> `.get_fade_delays` | `.SetObj1State10` (`SFX_12E`), `.SetUnusedW2d121` (writes 1 to `w2d121`, which nothing reads), `.MoveObj1AndFadePals` (object 1 along `Data_b64cd`; at movement steps $30/$50 it starts and advances `.UpdatePalFade`), `.SetObj1State11`, `.PatchCastle6`..`1` (the castle rows bottom-up, 5 frames apart), `.SetObj7State12` (the east day/night object), `.HideObj1`, `.FadePalsBack`. `.UpdatePalFade` (`wOWUIObj2YCoord`): fades BG palettes 0-5 from `wTempPals1` to `Pals_84840` and back, with the per-stage delays of `.data` (`.get_fade_delays`). See the finding about `.data` below. | high (medium: `.MoveObj1AndFadePals`, `.FadePalsBack`, `.UpdatePalFade`, `.get_fade_delays`) |
| bank2d.asm:7763 | `EOWFunc_VulcanoEruption`: `.Func_b75b6` -> `.StartRumbleSFX`; `.Func_b75c3` -> `.StartShakeAndRocks`; `.Func_b75d0` -> `.WaitShakeEnd`; `.Func_b75dd` -> `.StartObj10`; `.Func_b75ed` -> `.StartObj13`; `.Func_b75fb` -> `.StartObj14`; `.Func_b7609` -> `.StartObj12`; `.Func_b7617` -> `.StartObj15`; `.Func_b7625` -> `.WaitObj15Done`; `.Func_b762d` -> `.UpdateObj10`; `.Func_b763e` -> `.Obj10_Show`; `.Func_b764e` -> `.Obj10_WaitState0b`; `.Func_b7656` -> `.Obj10_Wait90`; `.Func_b765f` -> `.Obj10_Hide`; `.Func_b766c` -> `.UpdateObj12`; `.Func_b767d` -> `.Obj12_Show`; `.Func_b768b` -> `.Obj12_WaitState0e`; `.Func_b7693` -> `.Obj12_Wait90`; `.Func_b769c` -> `.Obj12_Hide`; `.Func_b76a9` -> `.UpdateObj13`; `.Func_b76ba` -> `.Obj13_Show`; `.Func_b76c8` -> `.Obj13_WaitState0e`; `.Func_b76d0` -> `.Obj13_Wait90`; `.Func_b76d9` -> `.Obj13_Hide`; `.Func_b76e6` -> `.UpdateObj14`; `.Func_b76f5` -> `.Obj14_Show`; `.Func_b7703` -> `.Obj14_Wait90`; `.Func_b770c` -> `.Obj14_Hide`; `.Func_b7719` -> `.UpdateObj15`; `.Func_b7728` -> `.Obj15_Show`; `.Func_b7736` -> `.Obj15_Wait90`; `.Func_b773f` -> `.Obj15_Hide`; `.Func_b774c` -> `.UpdateRockLauncher`; `.Func_b7763` -> `.rock_sfx_and_next`; `.Func_b7772` -> `.LaunchLeftRock1`; `.Func_b777f` -> `.LaunchRightRock`; `.Func_b778c` -> `.LaunchLeftRock2`; `.Func_b77a6` -> `.StopLauncher` | `.StartRumbleSFX`, `.StartShakeAndRocks` (shake request $0a and `.UpdateRockLauncher`, which runs the west scene's left/right rock scripts: `.LaunchLeftRock1`/`.LaunchRightRock`/`.LaunchLeftRock2` every $50/$3c frames, counter in `wSceneWarioMovementStep`, step in `wOWUIObj1State`: borrowed labels; a fourth launch after `.LaunchLeftRock2` is unreachable), `.WaitShakeEnd`, then `.StartObj10`/`13`/`14`/`12`/`15` (`SFX_127` first) start one small script per object: `.ObjN_Show` (state $0a/$0d/$0e), `.ObjN_WaitState..` (where the object changes state itself), `.ObjN_Wait90`, `.ObjN_Hide`; `.WaitObj15Done`. | high (medium: `.UpdateRockLauncher`, `.LaunchLeftRock1`, `.LaunchRightRock`, `.LaunchLeftRock2`) |
| bank2d.asm:8112 | `EOWFunc_BurnVines`: `.Func_b77ce` -> `.PlayObj1StateSFX`; `.Func_b780d` -> `.SetObj1State15`; `.Func_b781d` -> `.SetObj1State16`; `.Func_b782d` -> `.SetObj1State14`; `.Func_b783d` -> `.HideObj9`; `.Func_b784c` -> `.SetObj1State18`; `.Func_b7857` -> `.WaitObj1Disappear` | `.PlayObj1StateSFX`: every 15 frames a sound by object 1's state ($14 `SFX_01E`, $15 `SFX_125`, $16 `SFX_126`). Steps set object 1 to $15, $16, $14, hide object 9 (the vines), $15 again, $18, and wait for it to disappear. | high |
| bank2d.asm:8213 | `EOWFunc_ShowWarpedVoid`: `.Func_b7877` -> `.SetObj5State1b`; `.Func_b788a` -> `.WaitObj5State19`; `EOWFunc_RaisePipe`: `.Func_b78b4` -> `.ShowObj8`; `.Func_b78c4` -> `.PlayRaiseSFX`; `.Func_b78d5` -> `.WaitObj8State1c`; `EOWFunc_Daytime`: `.Func_b78f5` -> `.DaytimeTransition` | `.SetObj5State1b` (`SFX_128`), `.WaitObj5State19`. `EOWFunc_RaisePipe`: `.ShowObj8` (Y $37, state $1d), `.PlayRaiseSFX` (`SFX_FAT_WALK` after 16 frames), `.WaitObj8State1c`. `EOWFunc_Daytime.DaytimeTransition`: like `NOWFunc_DayNightSpell.DayNightTransition`. | high (medium: `.PlayRaiseSFX`) |
| bank2d.asm:8393 | `UpdateNorthOWObjMapAnim`: `.Func_b79de` -> `.Obj3BreakWhenWarioNear`; `.Func_b7a32` -> `.Obj2ReactToWario`; `.Func_b7a5a` -> `.check_wario_near_obj2` | North object 3, state 5: when Wario's target point (`wLevel2`) is 6, state 6 and `SFX_BLOCK_BREAK`. Object 2, state $0e: while Wario stands at point 2 or 7 (no event), it switches to state $0d, otherwise back to $1d after 120 frames (`w2d124`/`w2d125`); `.check_wario_near_obj2` returns z when it should react. The same pattern on the west (object 5, points 1/2, states $10/$13) and south (object 7, points 0/1, states $14/$1d): `WestOWObj5ReactToWario`, `SouthOWObj7ReactToWario` and their `CheckWarioNear...`. Medium: what the objects are isn't known. | medium |
| bank2d.asm:8521 | `Func_b7ab7` -> `WestOWObjUpdateTornado`; `Func_b7ac0` -> `WestOWObj8WaitForNight`; `Func_b7afb` -> `WestOWObj8WaitForDay`; `Func_b7b26` -> `WestOWObj5ReactToWario`; `Func_b7b4e` -> `CheckWarioNearWestOWObj5`; `Func_b7ba9` -> `EastOWObj7WaitForDay`; `Func_b7bc9` -> `EastOWObj7WaitForNight`; `Func_b7be9` -> `EastOWObj7CheckSkip`; `Func_b7c05` -> `EastOWObj5IdleTimer`; `Func_b7c5c` -> `SouthOWObj7ReactToWario`; `Func_b7c84` -> `CheckWarioNearSouthOWObj7`; `Func_b7c97` -> `SouthOWObj15WaitForDay`; `Func_b7ca5` -> `SouthOWObj15WaitForNight`; `Func_b7cb3` -> `MoveSouthOWObj14Diagonally`; `Func_b7cb3`: `.Func_b7cda` -> `.reset_position_once`; `.Func_b7d0d` -> `.set_moved` | West state 2 entry: `UpdateOWTornado` unless the current event is 4. Supersedes the 3a evidence "(`Func_b7ab7` -> `UpdateOWTornado`)", which named the target, not this label. Day/night switches, like the north `.Obj15WaitForDay`: west object 8 (state 6: at night state 8 and object 7 off; at the day transition object 7 state 7; state 8: back to 6), east object 7 (states $12 night / $13 day; `EastOWObj7CheckSkip` hides it during `UNLOCK_LEVEL`/`HIGHLIGHT_LEVEL` and skips during events), south object 15 (states $1e / $1f). `EastOWObj5IdleTimer`: east object 5, state $19 -> $1a every 256 frames. `MoveSouthOWObj14Diagonally` (south object 14, state $20): moves up-right 1 px every 4 frames from ($25, $70), wrapping at X $88; during a day/night transition (`w2d07c`) it is put back once (`w2d07d`) and stops at X $80. | medium (high: `SouthOWObj15WaitForDay`, `SouthOWObj15WaitForNight`) |

#### bank27: cutscene steps and updaters

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| bank27.asm:1382 | `Cutscene03Func`: `.Func_9cf36` -> `.PlaceObjs2And3`; `.Func_9cf59` -> `.MoveObjsTogether`; `.Func_9cf71` -> `.JoinObjsClick`; `.Func_9cf92` -> `.PlaceObj3State05`; `.Func_9cfad` -> `.WaitObj3Disappear`; `.Func_9cfba` -> `.LowerObj2`; `.Func_9cfce` -> `.SetObj2State04Click`; `.Func_9cfea` -> `.PlaceObj3OnObj2`; `.Func_9d001` -> `.WaitObj3State07`; `.Func_9d00a` -> `.PlaySFX10C` | Step legend for all the cutscene rows (bank27): the names say what each step does to the scene objects (`ObjN` = `wSceneObjN`, `CurObj` = `wCurSceneObj`). `.ShowItem` / `.RaiseItem` (`.LowerItem` when it comes down from the top) are the opening of most cutscenes: object 2 placed below (or above) the screen with an overlay type in `wSceneObj1YCoord`, then moved until it stops, `PlaySFX_112` on the way; upstream already names this pair `.ShowAxe` / `.RaiseAxe` in Cutscene02. `.WaitThen<action>` = `ld a, [bc] / cp N / ret c` (wait N frames of the step counter) before the action; `.Wait<Obj>State<NN>` / `Frame<NN>` / `Disappear` wait on an object's state, frame or state 0; `.SetObjNState<NN>`, `.PlaceObjN` (coordinates + state), `.HideObjN` (state 0); a `Click` or `SFX` suffix: the step also plays `SFX_CLICK` or another sound; `.FlipBGMap` writes `LCDC_BG_MAP` to `wCollectionRow`, which is `wLCDCFlagsToFlip` (RAM notes: Cutscene02's `.ShowSpeedLines` does the same through the right label); `.LoadPals` = the cutscene palettes into `wTempPals1/2` for the fade; `.LoadFadePalsN` + `.FadeEveryNFrames`: target palettes, then a fade every N frames. Here: two objects slide together (`.MoveObjsTogether`, object 2 right and object 3 left, every other frame) and join with a click; object 3 shows state 5 (`SFX_106`); object 2 moves down to Y $54 and clicks again; object 3 is put on it. | high |
| bank27.asm:1532 | `Cutscene06Func`: `.Func_9d04b` -> `.BobObj2`; `.Func_9d076` -> `.LiftObj2`; `.Func_9d09c` -> `.PlaceObj2State02`; `.Func_9d0af` -> `.WaitObj2State03`; `.Func_9d0c1` -> `.RaiseObj2Slowly`; `.Func_9d0d3` -> `.play_sfx_023_every_14_frames` | `.BobObj2` (±1 px every 4 frames for $20 frames, `SFX_102` first), `.LiftObj2` (up faster and faster, `SFX_TEMPLE_ROCK`), `.PlaceObj2State02`, `.WaitObj2State03` (also clears `wColourFadeDiff`, then used as a sound counter), `.RaiseObj2Slowly` with `.play_sfx_023_every_14_frames`. | high |
| bank27.asm:1661 | `Cutscene0aFunc`: `.Func_9d126` -> `.RaiseObjsApart`; `.Func_9d133` -> `.move_objs_up_apart`; `.Func_9d145` -> `.MoveObjsOnceSFX` | `.RaiseObjsApart`: every other frame object 2 moves up-left and object 3 up-right (`.move_objs_up_apart`) until Y $63; `.MoveObjsOnceSFX` one more step with `SFX_106`. | high |
| bank27.asm:1751 | `Cutscene07Func`: `.Func_9d1c5` -> `.PlaceObj5Click`; `.Func_9d1e9` -> `.SetObj5State02Click`; `.Func_9d201` -> `.SetObj3State04`; `.Func_9d211` -> `.SetObj2State06`; `.Func_9d21c` -> `.WaitObj2Frame00SFX`; `.Func_9d22c` -> `.WaitObj2FrameNot00`; `.Func_9d239` -> `.SetObj3State05`; `.Func_9d249` -> `.SetObj4State08SFX`; `.Func_9d25c` -> `.WaitObj4Disappear`; `.Func_9d269` -> `.PlaySFX10B`; `.Func_9d274` -> `.RaiseObj2` | Object 5 at (90, 56) clicks (state 1, then 2), objects 3 and 2 change states, object 2's animation loops four times with `SFX_109` each time it is back on frame 0 (`.WaitObj2Frame00SFX` / `.WaitObj2FrameNot00`), object 4 state 8 (`SFX_035`) until it disappears, `SFX_10B`, object 2 moves up off the screen. | high |
| bank27.asm:1876 | `Cutscene19Func`: `.Func_9d2a9` -> `.ShowItem`; `.Func_9d2bc` -> `.RaiseItem`; `.Func_9d2d1` -> `.SetObj2State02SFX`; `.Func_9d2e9` -> `.WaitObj2Frame04SetState03`; `.Func_9d2ff` -> `.LoadPal2_1`; `.asm_9d302` -> `.load_pal2`; `.Func_9d32b` -> `.LoadPal2_2`; `.Func_9d330` -> `.LoadPal2_3`; `.Func_9d335` -> `.LoadPal2_4` | After the item, object 2 state 2 (`SFX_073`) and 3 at its frame 4; then BG palette 2 is replaced 4 times, 8 frames apart, by `Pals_9fc8b`.. (`.LoadPal2_1`..`_4`, shared tail `.load_pal2`): the castle appearing. | high |
| bank27.asm:1987 | `Cutscene11Func`: `.Func_9d36a` -> `.CheckSummonLightning`; `.Func_9d37a` -> `.ShowItem`; `.Func_9d392` -> `.RaiseItem`; `.Func_9d3a7` -> `.LoadResultPals`; `.asm_9d3aa` -> `.load_result_pals`; `.Func_9d3e1` -> `.PlaceObj2State02`; `.Func_9d3f9` -> `.RaiseObj2Fast`; `.Func_9d409` -> `.LoadLightningResultPals`; `.Func_9d413` -> `.PlaceObj2State03`; `.Func_9d426` -> `.MoveObj2UpRight`; `.asm_9d438` -> `.play_sfx_113` | Shared by `EVENT_FREEZE_SEA`/`EVENT_SUMMON_LIGHTNING` (Cutscene0e/11) and, through its updater, `PURIFY_WATER`: `.CheckSummonLightning` jumps to the second half for the lightning. Each half: item, then `.LoadResultPals` / `.LoadLightningResultPals` (`Pals_b8040` / `Pals_b8200` into `wTempPals1`, item hidden, BG map flipped through `wCollectionRow`), and object 2 rises again in another state (`.RaiseObj2Fast` / `.MoveObj2UpRight`, `SFX_113`). | high (medium: `.LoadResultPals`, `.load_result_pals`, `.LoadLightningResultPals`) |
| bank27.asm:2132 | `Cutscene1bFunc`: `.Func_9d46c` -> `.PlaceObjs2And3`; `.Func_9d48f` -> `.MoveObjsTogetherClick`; `.Func_9d4a4` -> `.move_objs_together`; `.Func_9d4bd` -> `.HideObjsLoadSunPals`; `.Func_9d4ec` -> `.PlaceObj5`; `.Func_9d504` -> `.LowerObj5`; `.Func_9d51d` -> `.WaitThenSetObj5State01` | Two objects join (`.MoveObjsTogetherClick`), the screen fades to white, `.HideObjsLoadSunPals` (`SummonSunCutscenePals_b8340` + BG map flip), object 5 comes down slowly (`.LowerObj5`, slower below Y $44) and changes state after 30 frames. | high |
| bank27.asm:2296 | `Cutscene1eFunc`: `.Func_9d58e` -> `.LowerObj3Switch`; `.Func_9d5a6` -> `.SetObj2State01SFX`; `.Func_9d5be` -> `.WaitObj2Frame03`; `.Func_9d5c7` -> `.SetObj2State05` | `.LowerObj3Switch` (object 3 down to Y $3b, `SFX_SWITCH`), `.SetObj2State01SFX` (`SFX_10E`). | high |
| bank27.asm:2352 | `Cutscene22Func`: `.Func_9d5f1` -> `.LoadPals`; `.Func_9d616` -> `.PlaceObj2SFX`; `.Func_9d631` -> `.WaitObj2Frame05SFX`; `.Func_9d642` -> `.WaitObj2State02` | `.LoadPals` (treasure map palettes, BG/OB cleared for the fade), `.PlaceObj2SFX` (`SFX_103`), `.WaitObj2Frame05SFX` (`SFX_107`). | high |
| bank27.asm:2419 | `Cutscene27Func`: `.Func_9d674` -> `.SetObj2State02Click`; `.Func_9d68c` -> `.SetObj2State03Click` | Object 2 (the cart) clicks twice (states 2, 3). | high |
| bank27.asm:2453 | `Cutscene09Func`: `.Func_9d6b6` -> `.ShowItem`; `.Func_9d6ce` -> `.RaiseItem` | Item only. | high |
| bank27.asm:2512 | `MusicBoxCutsceneFunc`: `.Func_9d70c` -> `.ShowMusicBox`; `.Func_9d723` -> `.RaiseMusicBox`; `.Func_9d738` -> `.OpenMusicBox`; `.Func_9d749` -> `.PlayMusicBoxTune` | `.ShowMusicBox` / `.RaiseMusicBox` (the item pattern, state `b`), `.OpenMusicBox` (state + 1: the open box's frameset; medium), `.PlayMusicBoxTune` (`SFX_11E`..`SFX_122` by box). | high (medium: `.OpenMusicBox`) |
| bank27.asm:2684 | `Cutscene0cFunc`: `.Func_9d840` -> `.ShowItem`; `.Func_9d858` -> `.RaiseItem` | Item only (it moves up-left). | high |
| bank27.asm:2721 | `Cutscene18Func`: `.Func_9d87f` -> `.ShowItem`; `.Func_9d897` -> `.RaiseItem`; `.Func_9d8ad` -> `.FlipBGMap` | Item, wait, `.FlipBGMap`. | high |
| bank27.asm:2774 | `Cutscene0dFunc`: `.Func_9d8d9` -> `.ShowItem`; `.Func_9d8ec` -> `.RaiseItem`; `.Func_9d901` -> `.FlipBGMap`; `.Func_9d90e` -> `.PlaceObj3SFX`; `.Func_9d929` -> `.MoveObj3LeftThenShowObj4`; `.Func_9d94c` -> `.MoveObj4LeftThenShowObj3`; `.Func_9d967` -> `.move_obj4_left`; `.Func_9d973` -> `.MoveObj4LeftThenHide` | Item, `.FlipBGMap`, then objects 3 and 4 take turns moving left (object 3 from (88, 64) to X $1c, object 4 from (80, 60) to X $18; `SFX_117` at the start). | high |
| bank27.asm:2891 | `Cutscene13Func`: `.Func_9d9a1` -> `.ShowItem`; `.Func_9d9c5` -> `.RaiseItem`; `.Func_9d9d8` -> `.RaiseObj2Further`; `.Func_9d9e5` -> `.LowerObj3OffScreen`; `.Func_9d9f9` -> `.DropObj2` | Objects 2 and 3 rise together as the item; object 2 goes on up to Y $40 (`.RaiseObj2Further`), object 3 drops off the bottom, then object 2 falls 3 px/frame to Y $b0 (`SFX_061`) and the screen shakes. | high |
| bank27.asm:2992 | `Cutscene49Func`: `.Func_9da52` -> `.PlaceObj2AtTop`; `.Func_9da65` -> `.LowerObj2Click`; `.Func_9da7c` -> `.WaitThenSetObj2State04`; `.Func_9da8b` -> `.WaitObj2State01ThenOpen`; `.Func_9dac9` -> `.SlideDoorsOpen`; `.Func_9daf0` -> `.play_sfx_01f_every_17_frames` | Shared by both snake doors (Cutscene15/49). `.PlaceObj2AtTop`, `.LowerObj2Click` (to Y $45), `.WaitThenSetObj2State04`, `.WaitObj2State01ThenOpen` (while object 2's state-4 animation runs, `SFX_12C` on frame 3; when it is back to state 1: object 2 state 2 and object 3 state 3 on it), `.SlideDoorsOpen` (every 8 frames the window, objects 3/5 and `wSCX` move right and objects 2/4 left until X $40, with `.play_sfx_01f_every_17_frames`). | high (medium: `.WaitObj2State01ThenOpen`, `.SlideDoorsOpen`) |
| bank27.asm:3102 | `Cutscene04Func`: `.Func_9db1b` -> `.ShowItem`; `.Func_9db32` -> `.RaiseItem`; `.Func_9db43` -> `.move_up`; `.Func_9db46` -> `.WaitThenPlaceObj3`; `.Func_9db5d` -> `.RaiseObj3SFX`; `.Func_9db71` -> `.SetObj2State01FlipBGMap` | Item (from Y 128), then object 3 rises the same way (`SFX_113`), `.SetObj2State01FlipBGMap`. | high |
| bank27.asm:3186 | `Cutscene24Func`: `.Func_9dbb2` -> `.WaitThenPlaceObj3`; `.Func_9dbc9` -> `.MoveObj3RightOffScreen`; `.Func_9dbe5` -> `.WaitThenSetObj2State03`; `.Func_9dbfd` -> `.DropObj2`; `.Func_9dc0e` -> `.get_fall_speed`; `.Func_9dc63` -> `.HideObj2` | Object 3 crosses the screen left to right (`SFX_128` at X $30), object 2 changes state and falls with the speeds of `.data_9dc1f` (`.get_fall_speed`) to Y $88. | high |
| bank27.asm:3288 | `Cutscene1fFunc`: `.Func_9dc99` -> `.PlaceObj2`; `.Func_9dcac` -> `.MoveObj2DownRight`; `.Func_9dcca` -> `.WaitThenHideObj2`; `.Func_9dcd5` -> `.WaitThenSetObj3State02`; `.Func_9dce4` -> `.WaitObj3Frame0aSFX`; `.Func_9dcf5` -> `.WaitObj3State03` | Object 2 moves down-right (`SFX_11D`), disappears after 70 frames; object 3 state 2, `SFX_FAT_WALK` at its frame $0a, wait for state 3. | high |
| bank27.asm:3383 | `Cutscene21Func`: `.Func_9dd3f` -> `.move_obj2_up_slowly`; `.Func_9dd4a` -> `.move_obj2_right_slowly`; `.Func_9dd55` -> `.move_obj2_left_slowly`; `.Func_9dd60` -> `.PlaceObjs`; `.Func_9dd80` -> `.SetObj2State01`; `.Func_9dd8b` -> `.MoveObj2UpToObj3`; `.Func_9dda1` -> `.SetObj3State03`; `.Func_9dda9` -> `.MoveObj2RightToObj4`; `.Func_9ddb3` -> `.SetObj4State03`; `.Func_9ddbb` -> `.MoveObj2RightToObj5`; `.Func_9ddc2` -> `.SetObj5State03`; `.Func_9ddca` -> `.MoveObj2RightPastObj5`; `.Func_9ddd8` -> `.MoveObj2LeftToObj5`; `.Func_9dddf` -> `.SetObj5State04`; `.Func_9dde3` -> `.MoveObj2LeftToObj4`; `.Func_9ddea` -> `.SetObj4State04`; `.Func_9ddee` -> `.MoveObj2LeftToObj3`; `.Func_9ddf5` -> `.SetObj3State04`; `.Func_9ddf9` -> `.MoveObj2UpOffScreen`; `.Func_9de00` -> `.HideObj2` | Objects 3/4/5 in a row at X 72/88/104; object 2 moves up to the row, then right along it and back left, and each object it reaches changes state (3, then 4 on the way back); `.move_obj2_up/right/left_slowly` move 1 px every 4 / 2 frames. | high |
| bank27.asm:3536 | `Cutscene37Func`: `.Func_9de1b` -> `.ShowItem`; `.Func_9de38` -> `.RaiseItem` | Item only. | high |
| bank27.asm:3581 | `Cutscene38Func`: `.Func_9de68` -> `.ShowItem`; `.Func_9de87` -> `.RaiseItem`; `.Func_9de92` -> `.SetObj2State02`; `.Func_9de9d` -> `.WaitObj2Frame01SFX`; `.Func_9deae` -> `.WaitObj2Frame05SFX`; `.Func_9debf` -> `.WaitObj2State03`; `.Func_9decd` -> `.HideObj2` | Item (placed with `PlaySFX_112` at once), then object 2 state 2 with `SFX_SWITCH` on frame 1 and `SFX_106` on frame 5. | high |
| bank27.asm:3697 | `Cutscene30Func`: `.Func_9df3c` -> `.LoadPals`; `.Func_9df57` -> `.SetObj2State02`; `.Func_9df62` -> `.WaitObj2State03`; `.Func_9df70` -> `.RaiseObj3AndStartObjs4To6`; `.Func_9dfa6` -> `.RaiseObj5`; `.Func_9dfae` -> `.RaiseObj6`; `.Func_9dfb6` -> `.RaiseObj4` | Object 2 animates three times; then object 3 rises 1 px every 8 frames to Y $20 and starts objects 4, 5, 6 (state 4, `SFX_00F`) as it passes Y $48/$44/$3c; `.RaiseObj4`/`5`/`6` (run every frame) move each started object up 1 px every 2 frames to Y $20 and clear it. | high |
| bank27.asm:3802 | `Cutscene39Func`: `.Func_9dfe3` -> `.PlaceObj2`; `.Func_9dff1` -> `.LowerObj2Click`; `.Func_9e004` -> `.WaitThenSetObj2State02` | Object 2 comes down to Y $50 (click) and changes state. | high |
| bank27.asm:3885 | `Cutscene3aFunc`: `.Func_9e07d` -> `.LoadPals`; `.Func_9e098` -> `.MoveObj2UpRight`; `.Func_9e0b6` -> `.WaitThenPlaceObj3`; `.Func_9e0c8` -> `.WaitThenStartObjs4To7`; `.Func_9e108` -> `.WaitObj4Frame0a`; `.asm_9e10b` -> `.wait_frame_0a`; `.Func_9e112` -> `.SetObj4State04`; `.asm_9e115` -> `.set_state_04`; `.Func_9e11d` -> `.WaitObj4Disappear`; `.asm_9e120` -> `.wait_disappear`; `.Func_9e126` -> `.WaitObj5Frame0a`; `.Func_9e12b` -> `.SetObj5State04`; `.Func_9e130` -> `.WaitObj5Disappear`; `.Func_9e135` -> `.WaitObj6Frame0a`; `.Func_9e13a` -> `.SetObj6State04`; `.Func_9e13f` -> `.WaitObj6Disappear`; `.Func_9e144` -> `.WaitObj7Frame0a`; `.Func_9e149` -> `.SetObj7State04`; `.Func_9e14e` -> `.WaitObj7Disappear`; `.Func_9e153` -> `.PlaySFX080WhileObj7State03` | Object 2 moves up-right (`SFX_SWITCH`), object 3 appears; `.WaitThenStartObjs4To7` flips the BG map, hides 2 and 3, stops the sound and starts objects 4-7 (state 3); then each in turn: wait for frame $0a, state 4, wait until gone (shared tails `.wait_frame_0a`, `.set_state_04`, `.wait_disappear`). `.PlaySFX080WhileObj7State03` runs every frame. | high |
| bank27.asm:4052 | `Cutscene3cFunc`: `.Func_9e18f` -> `.PlaceObjs2And3`; `.Func_9e1a8` -> `.LowerItem`; `.Func_9e1bc` -> `.WaitThenSetObj2State02`; `.Func_9e1cb` -> `.WaitObj2State03`; `.Func_9e1d4` -> `.DropObj3`; `.Func_9e1f4` -> `.get_fall_speed`; `.Func_9e231` -> `.WaitObj3Disappear`; `.Func_9e239` -> `.WaitThenPlaceObj4SFX`; `.Func_9e253` -> `.WaitObj4State07` | `.LowerItem`, object 2 changes state; object 3 falls (`.data_9e205` speeds) to Y $58, state 5 with `SFX_0A1`; then object 4 state 6 (`SFX_074`) until state 7. | high |
| bank27.asm:4159 | `Cutscene43Func`: `.Func_9e272` -> `.PlaceObj2`; `.Func_9e280` -> `.LowerObj2Click`; `.Func_9e297` -> `.WaitThenSetObj2State02`; `.Func_9e2a6` -> `.WaitThenPlaceObj3` | Object 2 comes down (click), changes state; object 3 appears after 45 frames. | high |
| bank27.asm:4225 | `Cutscene54Func`: `.Func_9e2ed` -> `.LoadPals`; `.Func_9e308` -> `.RaiseItem`; `.Func_9e31c` -> `.WaitThenSetObj3State03Click`; `.Func_9e338` -> `.RaiseObj2` | `.RaiseItem` is object 3 here (every other frame, to Y $58); it then clicks to state 3 and object 2 rises to Y $20. | high |
| bank27.asm:4303 | `Cutscene3dFunc`: `.Func_9e376` -> `.PlaceObj2`; `.Func_9e384` -> `.MoveObj2UpLeft`; `.Func_9e391` -> `.WaitThenNextObj2StateSFX`; `.Func_9e3a8` -> `.WaitObj2Disappear`; `.Func_9e3b0` -> `.WaitThenPlaceObj2State03`; `.Func_9e3c2` -> `.WaitThenFlipBGMapPlaceObjs3And4`; `.Func_9e3e4` -> `.WaitThenSetObj4State06`; `.Func_9e3f3` -> `.WaitThenPlaySFX07A`; `.Func_9e402` -> `.WaitObj4State07`; `.Func_9e40b` -> `.WaitThenSetObj3State02`; `.Func_9e41a` -> `.WaitThenPlaySFX0AC`; `.Func_9e429` -> `.LowerObj3` | Object 2 moves up-left to X $44 and goes through its states (`SFX_0C4`) twice; after the BG map flip objects 4 and 3 appear, object 4 changes state (`SFX_07A`), object 3 changes state (`SFX_0AC`) and sinks to Y $80. | high |
| bank27.asm:4438 | `Cutscene4aFunc`: `.Func_9e469` -> `.MoveObj2Left`; `.Func_9e474` -> `.WaitThenSetObj2State03`; `.Func_9e483` -> `.WaitObj2Frame04Click`; `.Func_9e494` -> `.WaitObj2Frame06SFX`; `.Func_9e4a5` -> `.WaitObj2Frame07` | Object 2 moves left to X $56, then state 3 with `SFX_CLICK` on frame 4 and `SFX_132` on frame 6. | high |
| bank27.asm:4508 | `Cutscene4cFunc`: `.Func_9e4f0` -> `.LoadPals`; `.Func_9e50b` -> `.RaiseItem`; `.Func_9e51b` -> `.WaitThenSetObj2State02`; `.Func_9e52a` -> `.WaitObj2State03`; `.Func_9e532` -> `.WaitThenSetObj3State02`; `.Func_9e541` -> `.WaitThenHideObj3` | See the finding about `.Func_9e52a` below: it is meant to wait for object 2's state 3 but has no `ret nz`. | high (medium: `.WaitObj2State03`) |
| bank27.asm:4577 | `Cutscene4eFunc`: `.Func_9e562` -> `.LoadPals`; `.Func_9e578` -> `.WaitThenPlaceObj2`; `.Func_9e58a` -> `.RaiseObj2Click` | Object 2 rises to Y $50 (click). | high |
| bank27.asm:4643 | `Cutscene4fFunc`: `.Func_9e5e2` -> `.LowerItem`; `.Func_9e5f6` -> `.WaitThenSetObj2State02`; `.Func_9e60a` -> `.LowerObj2`; `.Func_9e61f` -> `.RaiseObj2`; `.Func_9e62e` -> `.WaitThenSetObj2State01`; `.Func_9e63d` -> `.WaitThenSetObj3State03`; `.Func_9e64c` -> `.WaitObj3State05` | `.LowerItem`; object 2 bobs down to Y $5c and back twice; object 3 state 3 until 5. | high |
| bank27.asm:4747 | `Cutscene51Func`: `.Func_9e688` -> `.LowerItem`; `.Func_9e69c` -> `.SetObj2State03`; `.Func_9e6a7` -> `.WaitObj2Frame04SFX`; `.Func_9e6b8` -> `.WaitObj2Disappear`; `.Func_9e6c5` -> `.LowerObj3`; `.Func_9e6d7` -> `.play_sfx_01f_every_16_frames` | `.LowerItem`, object 2 state 3 (`SFX_0A1` on frame 4) until gone; object 3 sinks to Y $78 with `.play_sfx_01f_every_16_frames`. | high |
| bank27.asm:4837 | `Cutscene56Func`: `.Func_9e71f` -> `.LoadPals`; `.Func_9e735` -> `.WaitThenPlaceObj2`; `.Func_9e747` -> `.WaitObj2State02`; `.Func_9e750` -> `.WaitObj2State01`; `.Func_9e759` -> `.WaitThenHideObj2FlipBGMap`; `.Func_9e779` -> `.LoadFadePals1`; `.asm_9e77c` -> `.load_fade_target`; `.Func_9e787` -> `.FadeEvery2Frames`; `.Func_9e78e` -> `.LoadFadePals2`; `.Func_9e793` -> `.FadeEvery4Frames` | Object 2 appears (state 1, waits for 2 then 1), `.WaitThenHideObj2FlipBGMap` (also loads `RevealDarkRoomCutscenePals_b8800`), then two fades to `..._b8840` and `..._b8880`. | high |
| bank27.asm:4942 | `Cutscene57Func`: `.Func_9e7d9` -> `.LoadPals`; `.Func_9e7ef` -> `.LowerItem`; `.Func_9e7ff` -> `.WaitThenSetObj2State04`; `.Func_9e80e` -> `.WaitObj2State03SetObj3State02`; `.Func_9e827` -> `.WaitThenSetObj3State01`; `.Func_9e836` -> `.LoadFadePals1`; `.asm_9e839` -> `.load_fade_target`; `.Func_9e844` -> `.FadeEvery2Frames`; `.Func_9e84b` -> `.LoadFadePals2`; `.Func_9e850` -> `.LoadFadePals3` | `.LowerItem`, object 2 state 4; when it reaches 3, object 3 state 2 (`SFX_105`), later 1; three fades (`SummonMoonCutscenePals_b8580`/`b85c0`/`b8600`). | high |
| bank27.asm:5049 | `Cutscene58Func`: `.Func_9e89c` -> `.LoadPals`; `.Func_9e8b7` -> `.RaiseItem`; `.Func_9e8c7` -> `.WaitThenSetObj2State02`; `.Func_9e8d6` -> `.WaitObj2State01StartObjs10And11`; `.asm_9e8dc` -> `.start_objs_10_and_11`; `.Func_9e905` -> `.WaitObj2State01FlipBGMap` | Item; each time object 2 is back in state 1 the two objects 10/11 are thrown out (`.start_objs_10_and_11`: placed, flags in `wSceneObj12YCoord`/`XCoord` for `MoveCutsceneObj10`/`11`, `SFX_132`); the second time also flips the BG map and sets object 3 state 2. | high |
| bank27.asm:5177 | `Cutscene55Func`: `.Func_9e9a3` -> `.LoadPals`; `.Func_9e9b9` -> `.WaitThenPlaceObj2`; `.Func_9e9cb` -> `.MoveObj2Left`; `.Func_9e9df` -> `.LowerObj2Switch`; `.Func_9e9f6` -> `.HideObj3StartObjs10And11`; `.Func_9e9fa` -> `.start_objs_10_and_11`; `.Func_9ea1b` -> `.WaitThenSetObj6State05`; `.Func_9ea2a` -> `.RaiseObj2`; `.Func_9ea39` -> `.MoveObj2RightTo54`; `.asm_9ea3b` -> `.move_obj2_right_to_e`; `.Func_9ea49` -> `.HideObj4StartObjs10And11`; `.asm_9ea52` -> `.shift_objs_10_and_11`; `.Func_9ea61` -> `.WaitThenSetObj7State05`; `.Func_9ea70` -> `.MoveObj2RightTo64`; `.Func_9ea74` -> `.HideObj5StartObjs10And11`; `.Func_9ea7f` -> `.WaitThenSetObj8State05`; `.Func_9ea93` -> `.MoveObj2RightOffScreen` | Three holes (objects 3/4/5 cover them at X $40/$50/$60, objects 6/7/8 are the holes): object 2 comes in from the right, and for each hole: moves down (`SFX_SWITCH`), hides the cover and throws objects 10/11 (shifted $10/$20 for the later holes, `.shift_objs_10_and_11`), the hole gets state 5, object 2 moves back up and right to the next one; at the end it leaves to X $90. `Data_9ec16`/`Data_9ec41` are the paths of objects 10/11 (`MoveCutsceneObj10`/`11`, third pass). | high |
| bank27.asm:5378 | `Cutscene44Func`: `.Func_9eaf7` -> `.PlaceObj2`; `.Func_9eb05` -> `.DropObj2`; `.Func_9eb18` -> `.WaitThenFlipBGMap`; `.Func_9eb24` -> `.PlaceObjs2And3`; `.Func_9eb3d` -> `.LowerObj2Wait80`; `.Func_9eb47` -> `.MoveObj3RightSFX`; `.Func_9eb5c` -> `.WaitThenNudgeObj3Left`; `.Func_9eb68` -> `.WaitThenHideObj2`; `.Func_9eb73` -> `.WaitThenSetObj3State02SFX`; `.Func_9eb8a` -> `.WaitObj3State03`; `.Func_9eb9f` -> `.MoveObj3RightOffScreen`; `.Func_9ebad` -> `.WaitThenPlaySFX08D`; `.Func_9ebbc` -> `.lower_obj2`; `.Func_9ebc7` -> `.move_obj3_right`; `.Func_9ebd3` -> `.get_obj3_speed` | Object 2 drops (to Y $a8), BG map flip; object 2 again in state 2 sinking slowly, object 3 runs in from the left (accelerating with `.data_9ebe6`, `SFX_FAT_WALK`) to X $48, nudges back, object 2 disappears, object 3 state 2 (`SFX_11A`) until 3, then leaves right; `SFX_08D` and a screen shake. | high |
| bank27.asm:5524 | `Data_9ec16` -> `CutsceneObj10Movement`; `Data_9ec41` -> `CutsceneObj11Movement` | `ApplyOWMovement` paths of `MoveCutsceneObj10` / `MoveCutsceneObj11` (third pass), used by Cutscene55 and Cutscene58. | high |
| bank27.asm:5557 | `Cutscene14Func`: `.Func_9ec9b` -> `.ShowItem`; `.Func_9ecef` -> `.RaiseItem`; `.Func_9ed14` -> `.Wait60`; `.Func_9ed1c` -> `.LowerItem`; `.Func_9ed3c` -> `.LowerCurObj`; `.Func_9ed54` -> `.WaitWobbleThenSwitchTable`; `.Func_9ed70` -> `.WaitWobbleLoop`; `.Func_9ed7c` -> `.HideObjs2To4ShowObj5`; `.Func_9ed9c` -> `.Wait120`; `.Func_9eda4` -> `.play_sfx_10f_every_10_frames`; `.Func_9edb7` -> `.SetObj5State05`; `.Func_9edc2` -> `.WaitObj5State06`; `.Func_9edce` -> `.play_obj5_sfx`; `.Func_9edf1` -> `.Wait90`; `.Func_9edf9` -> `.LowerObj5`; `.Func_9ee17` -> `.WaitSFXCounter09`; `.Func_9ee23` -> `.FadeToWhiteWithSFX`; `.Func_9ee2a` -> `.play_fade_sfx`; `.Func_9ee57` -> `.Exit`; `.Func_9ee5b` -> `.WobbleObjs2To4`; `.Func_9ee77` -> `.apply_wobble`; `.Func_9ee92` -> `.store_wobble_ptr` | Item made of objects 2-4 plus the current object, rising together and wobbling (`.WobbleObjs2To4` adds (dy, dx) pairs from three pointers kept in `wPalFade1`.. (borrowed bytes) to objects 4, 3, 2; at a $80 end it restarts the table and returns carry); `.WaitWobbleThenSwitchTable` / `.WaitWobbleLoop`; then object 5 (the eruption?) changes state with sounds by frame (`.play_obj5_sfx`: `SFX_110`/`SFX_111`), moves down to Y $70, and the cutscene fades to white with `SFX_114`/`115`/`116`. See the finding about the literal pointers below: `Data_9ef82` ("unreferenced") is the second wobble table. | high (medium: `.ShowItem`, `.WaitWobbleThenSwitchTable`, `.WobbleObjs2To4`, `.apply_wobble`, `.store_wobble_ptr`) |
| bank27.asm:5853 | `Data_9ef82` -> `VolcanoEruptionCutsceneWobbles` | Marked unreferenced, but `Cutscene14Func.WaitWobbleThenSwitchTable` stores $6f82, $6fe3 and $7044 as wobble pointers: this label and two points $61 bytes apart inside it (three $80-terminated tables). See the finding below. | medium |
| bank27.asm:5987 | `UpdateCutsceneObjs_RaiseTower`: `.Func_9f15e` -> `.update_obj`; `UpdateCutsceneObjs_FixElevator`: `.Func_9f189` -> `.update_obj`; `.Func_9f1b5` -> `.PlaySFX10AAtAnimEnd`; `Func_9f1f3`: `.Func_9f20b` -> `.update_obj`; `UpdateCutsceneObjs_SummonSun`: `.Func_9f22e` -> `.update_obj`; `Func_9f244`: `.Func_9f26b` -> `.PlayFlapSFXAtAnimEnd`; `.Func_9f27f` -> `.PlaySFX011OnFrame01`; `UpdateCutsceneObjs_ExplodeBombs`: `.Func_9f2b1` -> `.update_obj`; `Func_9f2f3`: `.Func_9f30e` -> `.PlaySFX06DAtAnimEnd`; `UpdateCutsceneObjs_SummonSnakes`: `.Func_9f34f` -> `.update_obj`; `UpdateCutsceneObjs_FootStone`: `.Func_9f379` -> `.update_obj`; `UpdateCutsceneObjs_ExpelTornado`: `.Func_9f3d6` -> `.update_obj`; `UpdateCutsceneObjs_OpenTreeMouth`: `.Func_9f3f7` -> `.update_obj`; `.Func_9f414` -> `.PlaySFX131AtAnimEnd`; `UpdateCutsceneObjs_LeavesFall`: `.Func_9f45a` -> `.PlayFatWalkSFXOnFrame07Or08`; `.Func_9f483` -> `.PlaySFX076Every26Frames`; `UpdateCutsceneObjs_MakeWire`: `.Func_9f4b1` -> `.update_obj`; `.Func_9f4d8` -> `.PlaySFX133Every12Frames`; `.Func_9f4f4` -> `.PlaySFX132Every16Frames`; `UpdateCutsceneObjs_TorchForest`: `.Func_9f52e` -> `.PlaySFX01EEvery14Frames`; `UpdateCutsceneObjs_RevealWarpedVoid`: `.Func_9f587` -> `.PlaySFX040Every16Frames`; `UpdateCutsceneObjs_RaiseIceBlocks`: `.Func_9f5bb` -> `.update_obj`; `.Func_9f5e5` -> `.PlaySFX0BAOnFrame03`; `UpdateCutsceneObjs_RaisePipe`: `.Func_9f629` -> `.PlaySFX085AtAnimEnd`; `UpdateCutsceneObjs_RemoveWarps`: `.Func_9f689` -> `.PlaySFX10EEvery72Frames`; `UpdateCutsceneObjs_PlacePropeller`: `.Func_9f701` -> `.update_obj`; `.Func_9f722` -> `.PlaySFX07DEvery12Frames`; `UpdateCutsceneObjs_ExtinguishFire`: `.Func_9f80d` -> `.PlaySFX076Every26Frames`; `Func_9f821`: `.Func_9f843` -> `.PlaySFX01EEvery14Frames`; `UpdateCutsceneObjs_SprayIronWall`: `.Func_9f8a8` -> `.PlaySFX076Every26Frames`; `.Func_9f8c1` -> `.PlaySFX0C4Every10Frames`; `UpdateCutsceneObjs_MixChemicals`: `.Func_9f912` -> `.set_state_when_anim_finished`; `UpdateCutsceneObjs_RevealDarkRoom`: `.Func_9f953` -> `.PlaySFXOnFrames`; `Func_9f9f5`: `.Func_9fa1b` -> `.PlaySFX135Every27Frames`; `.Func_9fa34` -> `.PlaySFX080Every27Frames`; `UpdateCutsceneObjs_DrillHoles`: `.Func_9faa0` -> `.PlayPlane1SFXEvery12Frames`; `UpdateCutsceneObjs_FeedOctohon`: `.Func_9fad6` -> `.PlaySFX08EEvery48Frames`; `Func_9faea`: `.Func_9fb1f` -> `.PlaySFX08FEvery40Frames`; `.Func_9fb38` -> `.PlaySFX083Every40Frames`; `Func_9fba9`: `.Func_9fbc5` -> `.update_obj`; `UpdateCutsceneObjs_PlantSeeds`: `.Func_9fc09` -> `.update_obj2`; `UpdateCutsceneObjs_MusicBox`: `.Func_9fc2c` -> `.update_obj2` | Updater locals (rule from 3b: the per-object entry of the updaters): `.update_obj` (called with `bc` = an object's state), `.update_obj2` for the two updaters that animate object 2 only; sound helpers by what they do: `.PlaySFX<id>AtAnimEnd` (when `wOWAnimationFinished` is $ff), `.PlaySFX<id>Every<N>Frames` (counter in the object's movement byte, or in `wSceneObj4YCoord` for the Octohon), `.PlaySFX<id>OnFrame<NN>` (once per animation loop, flag in the movement byte), `.PlaySFXOnFrames` (frames 2, 4, 5); `.set_state_when_anim_finished` in `UpdateCutsceneObjs_MixChemicals`. | high (medium: `.PlaySFX011OnFrame01`, `.PlayFatWalkSFXOnFrame07Or08`, `.PlaySFXOnFrames`) |
| bank27.asm:7661 | `Pals_9fc8b` -> `RevealCastleCutscenePal2_1`; `Pals_9fc93` -> `RevealCastleCutscenePal2_2`; `Pals_9fc9b` -> `RevealCastleCutscenePal2_3`; `Pals_9fca3` -> `RevealCastleCutscenePal2_4` | The four BG palette 2 steps of `Cutscene19Func` (reveal castle). | high |

### 4c. Data labels left by the 3e owner rule

All 987 `Frameset_`/`OAM_`/`Pals_`/`Data_` labels that are still
address-named and not mentioned anywhere earlier in this file (1083 in
`src/` minus 96 already proposed). Ownership was worked out by script from
every reference in `src/`, as in 3e, with two changes:

- A reference from `src/data/object_params.asm` or `object_data.asm` counts
  for the object whose update function the block names (3e left these out),
  so object OAM tables and treasure/star framesets get an owner.
- References from routines that only borrow another owner's data are
  ignored when there is another owner: the level-object updaters of the
  cutscenes (`UpdateCutsceneLevelObj_*`, `Func_9f2f3`), `UpdateEpilogueSceneObj`
  and `SetObjStarsSprite`.

Owners outside the objects and Wario are areas: the screen directory
(`ActionHelp`, `ClearScreen`, `TimeAttackClearScreen`, `Credits`, `GameOver`,
`GolfHole`, `GolfLobby`, `GolfCourseMenu`, `GolfWario`, `PauseMenu`,
`Perfect`, `Intro`, `StartMenu`, `Title`, `Particle`, `Font`,
`LanguageSelection`, `MusicalCoinScreen`), the cutscene by event
(`<Event>Cutscene`, as in 3e), and for overworld routines the routine's
subject (`TopBar`, `BottomBar`, `OWWario` for `SetOWWarioOAM`,
`PathPreview`, `SceneWario`, `<Side>OWObj`, `<Side>OW<Scene>` for the
`<S>OWFunc_<Scene>` scenes).

Rules, in the order they are tried:

- **Descriptive (table below)**: the overworld palettes, the idle input
  framesets, the object movement tables and the labels shared by several
  owners, each read in the code.
- **P, palette loaders** (high): a `Pals_` label used only as
  `ld hl, Pals_x` followed by `call LoadPalsToTempPals1` or
  `LoadFarPalsToTempPals1` (`wTempPals1`, the BG palettes) or the `...2`
  version (`wTempPals2`, the OB palettes) becomes `<Owner>BGPals` /
  `<Owner>OBPals`. The owner is `X` when the only user is `LoadXPals`
  (existing or proposed: `LoadCreditsCloseUpPals` gives
  `CreditsCloseUpBGPals`), the area otherwise.
- **S, show routines** (medium): every user is `ActionHelp(2)_Show<X>` or
  `ParticleAnim_<X>` for one `X`: `ActionHelp<X><Kind>` /
  `Particle<X><Kind>` (`Frameset_1e6b70` -> `ActionHelpAInputFrameset`,
  `Frameset_d4ba` -> `ParticleSplashFrameset`). When two labels get the same
  name both keep the address (`ParticleBubblesFrameset_d502`).
- **O, single owner** (high, the 3e rule): `<Owner><Kind>_<addr>`.
- **W, shared Wario graphics** (medium): labels used by several Wario states
  (in wario_states_*, object_interactions.asm, block_functions.asm,
  start_room.asm, the debug menu), possibly also by the action help, the
  scene Wario or golf Wario, which only borrow Wario's graphics:
  `Wario<Form><Kind>_<addr>` when one transformation is involved (taken
  from the state names: `Owl`, `Bat`, `Vampire`, `Throw`, ...), plain
  `Wario<Kind>_<addr>` otherwise.
- **U, unreferenced** (medium when the nearest owner-named labels before
  and after it in the same file have the same owner, low when only the one
  before is known): `Unreferenced<Owner><Kind>_<addr>`; plain
  `Unreferenced<Kind>_<addr>` (low) when no neighbour has an owner.

Totals: 987 labels, all proposed. Descriptive 99 (44 high, 40 medium, 13
low, plus Anonster's two local palettes, medium); P 24 high; O 444 high; W 95 medium; S 38 medium; U 287 (157 medium,
130 low). All names checked by script against `src/` and the earlier
sections of this file: no collisions, no duplicates.

Findings from this part: `Data_60320` and `Data_60510` are identical
Y-velocity tables (could be merged); `Data_60ec9` is used by
code in torch.asm that is marked "unreferenced?" (it is Kobatto's table);
`Pals_84940`/`Pals_849c0` (west/east OB palettes) have no reference by
name but are reached by indexing from `Pals_84900`, so they must not be
marked unreferenced.

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| data/overworld/palettes.asm:1 | `Pals_84000` -> `NorthOWDayPals`; `Pals_84040` -> `NorthOWDusk1Pals`; `Pals_84080` -> `NorthOWDusk2Pals`; `Pals_840c0` -> `NorthOWNightPals`; `Pals_84100` -> `NorthOWDawnPals`; `Pals_84140` -> `WestOWDayPals`; `Pals_84180` -> `WestOWDusk1Pals`; `Pals_841c0` -> `WestOWDusk2Pals`; `Pals_84200` -> `WestOWNightPals`; `Pals_84240` -> `WestOWDawnPals`; `Pals_84280` -> `SouthOWDayPals`; `Pals_842c0` -> `SouthOWDusk1Pals`; `Pals_84300` -> `SouthOWDusk2Pals`; `Pals_84340` -> `SouthOWNightPals`; `Pals_84380` -> `SouthOWDawnPals`; `Pals_843c0` -> `EastOWDayPals`; `Pals_84400` -> `EastOWDusk1Pals`; `Pals_84440` -> `EastOWDusk2Pals`; `Pals_84480` -> `EastOWNightPals`; `Pals_844c0` -> `EastOWDawnPals`; `Pals_84500` -> `NorthOWCrayonsDayPals`; `Pals_84540` -> `NorthOWCrayonsDusk1Pals`; `Pals_84580` -> `NorthOWCrayonsDusk2Pals`; `Pals_845c0` -> `NorthOWCrayonsNightPals`; `Pals_84600` -> `NorthOWCrayonsDawnPals`; `Pals_84640` -> `WestOWCrayonsDayPals`; `Pals_84680` -> `WestOWCrayonsDusk1Pals`; `Pals_846c0` -> `WestOWCrayonsDusk2Pals`; `Pals_84700` -> `WestOWCrayonsNightPals`; `Pals_84740` -> `WestOWCrayonsDawnPals` | `OWPals` (bank21.asm:625) holds 4 pointers per map side and day/night, read by `GetOWPals` (`wCurMapSide`, `wOWIsNight`, all-crayons flag for north and west). `DayNightTransition` and `DayNightSpellTransition` fade entry 0 to 1, 1 to 2 and 2 to 3 (`LoadBaseAndTargetOWPals` with `a` = 0, 1, 2; `.LoadBaseAndTargetPals` loads entry 3 first). The day list is day, two dusk steps, night; the night list is night, dawn, day, day. So each side has five sets: `<Side>OWDayPals`, `Dusk1`, `Dusk2`, `NightPals`, `DawnPals`; the north and west versions with all crayons get `Crayons`. Several are also loaded on their own (`FadeInLevelName`, `GetMapSidePalGroup1`, `NOWFunc_BottomBar`, `_LoadMapSidePals`, `_LoadPalsForOWScene`, the rain/thunder/freeze-sea/crayon scenes), which fits the names. | high |
| data/overworld/palettes.asm:1231 | `Pals_84780` -> `NorthOWGreyPals`; `Pals_847c0` -> `WestOWGreyPals`; `Pals_84800` -> `SouthOWGreyPals`; `Pals_84840` -> `EastOWGreyPals`; `Pals_84880` -> `EastOWGreyNoIcePals` | `GreyOWPalsPointers` (`Data_84e39`, proposed in 4a) points at each side's grey palettes; its comment calls the second east one "EAST (no Ice)". `EOWFunc_FormCastle` also loads the east one. | high (medium: `EastOWGreyNoIcePals`) |
| data/overworld/palettes.asm:1471 | `Pals_848c0` -> `UnreferencedOWPals_848c0` | Marked unreferenced in palettes.asm; 4 palettes before `OWStarIndicatorPals`. | medium |
| data/overworld/palettes.asm:1492 | `Pals_848e0` -> `OWStarIndicatorPals` | `LoadOWStarIndicatorPals` copies 2 palettes of it to OB palettes 4-5; `InitHighlightLevelScene` loads it too. | high |
| data/overworld/palettes.asm:1513 | `Pals_84900` -> `NorthOWOBPals`; `Pals_84940` -> `WestOWOBPals`; `Pals_84980` -> `SouthOWOBPals`; `Pals_849c0` -> `EastOWOBPals` | 8 OB palettes per map side, indexed by `wCurMapSide` in `GetMapSidePalGroup2` and in the top bar's `.OpenTopBar` (palettes 4-7). The golf building (north) loads the north set, `SOWFunc_CanyonThunder` the south set (`Pals_84980`). The west and east sets are only reached by indexing. | high |
| data/overworld/palettes.asm:1678 | `Pals_84a00` -> `UnreferencedOWPals_84a00` | Marked unreferenced in palettes.asm. | medium |
| data/overworld/palettes.asm:1699 | `Pals_84a20` -> `TopBarOBPals` | 4 OB palettes copied to OB palettes 4-7 when the top bar is set up (bank20.asm:3505) and by `InitNOWObjects_DayNightSpell`. | medium |
| gfx/oam/action_help.asm:215 | `Frameset_1e6b6d` -> `ActionHelpNoButtonInputFrameset`; `Frameset_1e6b76` -> `ActionHelpNoDPadInputFrameset` | The idle (unpressed) button and D-pad framesets: set by `ActionHelp(2)_ClearButtonsInput` / `_ClearDPadInput` and by `InitActionHelp`. The pressed ones next to them (A, B, each direction) come out of rule S below. | medium |
| data/object_movements.asm:121 | `Data_60320` -> `SmallHopYVel`; `Data_60510` -> `SmallHopYVel2`; `Data_603d0` -> `RiseYVel`; `Data_603e0` -> `QuickFallYVel`; `Data_603f0` -> `DipYVel`; `Data_60490` -> `DropAndStopYVel`; `Data_60540` -> `JumpArcYVel`; `Data_60340` -> `UnreferencedBobYVel_60340`; `Data_60400` -> `UnreferencedBobYVel_60400` | Y-velocity tables in object_movements.asm (signed bytes, $80 ends them), next to the named `HopYVel_*`/`FallingYVel_*`. `Data_60320`: a small rise then a fall, used by the torch embers, the unused flower projectile and `Func_40c19`; `Data_60510` has exactly the same bytes and is used by the Doughnuteer's doughnut (left/right) and the Invisibility Potion (a duplicate table). `Data_603d0`: rise only, -6 slowing to 0 (Count Richtertoffen, Shoot). `Data_603e0`: 1, 1, 2, 2, 3, 3, then 4 (Count Richtertoffen, Falling Snow, Shoot), a faster fall than `FallingYVel_Light`. `Data_603f0`: 1, 2, 3, 2, 1 then 0 (Futamogu, Webber). `Data_60490`: 2 up to 10 then down to 0 (Futamogu, Webber). `Data_60540`: a jump arc, -6 to 0 then down to 4 (doughnut going up, potion drop). Both unreferenced ones are long up-and-down waves. The shape names are low where the use doesn't say more. | medium (low: `DipYVel`, `DropAndStopYVel`, `UnreferencedBobYVel_60340`, `UnreferencedBobYVel_60400`) |
| data/object_movements.asm:401 | `Data_60ec9` -> `KobattoSetMovement`; `Data_60eb0` -> `UnreferencedSetMovement_60eb0`; `Data_6104a` -> `UnreferencedSetMovement_6104a` | Set-movement tables (3 bytes per step, read by `ApplyObjSetMovement`). `Data_60ec9` is Kobatto's (`KobattoFunc` stores it and applies it); torch.asm only uses it in code marked "unreferenced?". The other two are unreferenced. | medium (high: `KobattoSetMovement`) |
| data/overworld/cutscene/palettes.asm:42 | `Pals_b8040` -> `SharedCutsceneBGPals_b8040`; `Pals_b8240` -> `SharedCutsceneBGPals_b8240`; `Pals_b8ac0` -> `MusicBoxCutscenePals_b8ac0`; `OAM_bcfb3` -> `SharedCutsceneOAM_bcfb3` | Data used by several owners, named after the main one or the defining file when no single owner exists. `Pals_b8040`: BG palettes loaded by the set-ups of cutscenes $0a, $0c, $0d, $11, $13, $1b and by `Cutscene11Func`; `Pals_b8240`: BG palettes of cutscenes $03 and $37; `Pals_b8ac0`: `InitMusicBoxCutscene` and `InitCutscene08` (Yellow music box) fall into the same loader. `OAM_bcfb3`: `UpdateCutsceneObjs_VolcanoEruption` (`Func_9fba9`) and `UpdateCutsceneObjs_PlantSeeds`. | medium |
| data/title/palettes.asm:83 | `Pals_5002` -> `TitleScreenBGPals2`; `Pals_5042` -> `TitleScreenOBPals2` | `LoadTitleScreenPals` loads `Pals_4f82`/`Pals_4fc2` (rule P below: `TitleScreenBGPals`/`OBPals`) or, when `wRestoredSave` is set, these two; `IntroSequencePhase3` loads these when the plane animation ends and the title music starts. | medium |
| main.asm:102 | `Pals_db000` -> `HiddenFigureBGPals`; `Pals_db040` -> `HiddenFigureOBPals` | `LoadHiddenFigureGfx` (game_over/load_gfx.asm): 8 BG palettes, then 5 OB palettes into OB palettes 3-7; `_PrologueFade`'s step 4 loads the same two. | high |
| gfx/pals/golf.asm:288 | `Pals_1ca24f` -> `GolfBGPals_1ca24f`; `Pals_1ca34f` -> `GolfOBPals_1ca34f`; `OAM_1cb3e0` -> `GolfCourseMenuOAM_1cb3e0`; `Frameset_d4d1b` -> `GolfWarioFrameset_d4d1b`; `Frameset_d4d5f` -> `GolfWarioFrameset_d4d5f`; `OAM_d49cc` -> `GolfWarioOAM_d49cc` | Golf palettes shared by the course menu (`Func_1c87db`, `Func_1c8586`) and `InitGolfClearCutscene` (BG / OB, from the clear cutscene's loader). `OAM_1cb3e0`: course menu objects and the golf clear cutscene. `Frameset_d4d1b`/`d4d5f`/`OAM_d49cc` (golf data files): golf Wario, also used by the clear screen and the scene Wario. | medium |
| gfx/oam/wario2.asm:458 | `Frameset_1fc473` -> `WarioFrameset_1fc473`; `Frameset_1fc47c` -> `WarioFrameset_1fc47c`; `OAM_1644a` -> `WarioOAM_1644a` | Wario graphics (wario1/2.asm) used only outside the Wario states: golf Wario and the scene Wario; `OAM_1644a` by the rolling/sliding states, the action help and the temple scene. | medium |
| data/overworld/oam_1.asm:5979 | `OAM_aab5c` -> `SceneWarioOAM_aab5c`; `Frameset_aaccb` -> `SceneWarioFrameset_aaccb`; `Frameset_aace2` -> `SceneWarioFrameset_aace2` | Scene Wario sprites that the game over screen (sleeping and waking Wario) and the prologue reuse. | medium |
| data/overworld/oam_1.asm:4524 | `Frameset_aa09d` -> `TopBarFrameset_aa09d`; `Frameset_aa0a3` -> `TopBarFrameset_aa0a3`; `Frameset_aa0bc` -> `TopBarFrameset_aa0bc`; `Frameset_aa0c1` -> `TopBarFrameset_aa0c1` | `AnimateTopBarSprite` (`Func_82521`) and `NorthOWObjState25`-`28`. | medium |
| data/overworld/oam_1.asm:4581 | `OAM_aa0cf` -> `OWOAM_aa0cf`; `OAM_aa580` -> `OWUIOAM_aa580` | Low: shared by `SetOWWarioOAM`, the path preview, `LoadSpriteInsideWindow` and `NorthOWObjState24`; `OAM_aa580` by the bottom bar button prompt, the compass and `AnimateNorthOWObj3`. | low |
| data/credits/oam.asm:1 | `OAM_15e44a` -> `CreditsOAM_15e44a`; `Frameset_15e796` -> `CreditsFrameset_15e796`; `Frameset_15e7ed` -> `CreditsFrameset_15e7ed` | Low: defined in credits/oam.asm; the close-up (`Credits_ShowCloseUp`) and the prologue scene objects share `OAM_15e44a`/`Frameset_15e7ed`; `Frameset_15e796` is the prologue's and the temple scene's. | low |
| data/title/oam.asm:134 | `Frameset_6ce9` -> `StartMenuFrameset_6ce9`; `Frameset_6d1e` -> `StartMenuFrameset_6d1e`; `Frameset_1f1cd4` -> `PauseMenuFrameset_1f1cd4` | Intro and start menu; `Frameset_1f1cd4` pause menu and musical coin screen. | medium |
| data/levels/common/oam.asm:1 | `OAM_d20e` -> `ParticleOAM_d20e`; `Frameset_d49a` -> `ParticleDebrisFrameset`; `OAM_d763` -> `ParticleOwlOAM`; `Frameset_d7b4` -> `ParticleOwlFrameset` | Particles (levels/common/oam.asm): `OAM_d20e` is the OAM of most particles (`ParticleAnim_*`) and two action help demos; the debris and owl framesets are also used by the action help's block debris / owl demos. | medium (high: `ParticleOAM_d20e`) |
| gfx/oam/objects4.asm:831 | `OAM_18c88a` -> `HiddenFigureOAM_18c88a`; `OAM_18007b` -> `SpearheadOAM_18007b`; `OAM_184ab2` -> `MadSciensteinOAM_184ab2`; `OAM_188000` -> `BrrrBearOAM_188000`; `OAM_18c000` -> `TreasureOAM_18c000`; `OAM_190000` -> `AnonsterOAM_190000` | Object OAM banks shared through object_data.asm/object_params.asm. `OAM_18c88a`: Hidden Figure (face and hands), reused by the temple scene. `OAM_18007b`: Spearhead (and `DummyObjectData`, a placeholder, and the epilogue). Low for the rest: `OAM_184ab2` Mad Scienstein and his potion, also the Seeing-Eye Door; `OAM_188000` Brrr Bear and the tadpole spawner; `OAM_18c000` chests, keys, treasures, the musical coin and the stars; `OAM_190000` Anonster's silk, waves and platforms, also the fly/dragonfly spawners and the snowflakes. | low (high: `HiddenFigureOAM_18c88a`; medium: `SpearheadOAM_18007b`) |
| level/objects/anonster.asm:1518 | `UpdateAnonsterPal`: `.Pals_50ab4` -> `.green_pal`; `.Pals_50abc` -> `.red_pal` | The two local palettes copied to OB palette 7 when the low nybble of `wCurObjSubState` is 3 (green body colours) or 2 (red); named by their colours, the meaning of the two sub-states is not clear from this routine. | medium |

**Rule P (palette loaders, high)**, 24 labels

`Pals_1e4f7f` ActionHelpPowerUpOBPals; `Pals_1e0378` ClearScreenBGPals; `Pals_1e03b8` ClearScreenOBPals; `Pals_1604cc` CreditsBGPals; `Pals_16050c` CreditsOBPals; `Pals_16054c` CreditsCloseUpBGPals; `Pals_16058c` CreditsCloseUpOBPals; `Pals_1605cc` CreditsFinalBGPals; `Pals_16060c` CreditsFinalOBPals; `Pals_db509` GameOverBGPals; `Pals_db549` GameOverOBPals; `Pals_1ca18f` GolfHoleOBPals; `Pals_1ca1cf` GolfLobbyBGPals; `Pals_1ca20f` GolfLobbyOBPals; `Pals_d50a4` MusicalCoinScreenBGPals; `Pals_d50e4` MusicalCoinScreenOBPals; `Pals_1f4182` PauseMenuBGPals; `Pals_1f41c2` PauseMenuOBPals; `Pals_dc1fb` PerfectOBPals; `Pals_1e03f8` TimeAttackClearScreenBGPals; `Pals_1e0438` TimeAttackClearScreenOBPals; `Pals_71b0` TimeAttackDescriptionBGPals; `Pals_4f82` TitleScreenBGPals; `Pals_4fc2` TitleScreenOBPals

**Rule O (single owner, high)**, 444 labels

- ActionHelp: `Frameset_1e6b64`, `Frameset_1e6b67`, `Frameset_1e6b6a`, `Frameset_1e6b85`, `Frameset_1e6b8b`, `Frameset_1e6b8e`, `Frameset_1e6b96`, `Frameset_1e6b99`, `Frameset_1e6b9c`, `Frameset_1e6ba2`, `Frameset_1e6ba5`, `Frameset_1e6f4d`, `Frameset_1e6f66`, `Frameset_1e6f6b`, `Frameset_1e6f7d`, `Frameset_1e6fc2`, `OAM_1e697c`, `OAM_1e6f86`, `Pals_1e4e6f`, `Pals_1e4eaf`, `Pals_1e4f6f`, `Pals_1e4fbf`
- Anonster: `Frameset_694ee`, `Frameset_694f8`, `Frameset_69505`, `Frameset_6954a`
- Appleby: `Frameset_68a60`, `OAM_185a1c`
- Barrel: `OAM_181b0f`
- BeamBot: `Frameset_68ee1`, `Frameset_68eea`, `OAM_1845aa`
- BigLeaf: `OAM_180000`, `OAM_1817b4`
- Bird: `OAM_1819e3`
- BlowMistCutscene: `Pals_b8d40`
- BlueMusicBoxCutscene: `Pals_b8b00`
- BottomBar: `Frameset_aa2fb`
- BrrrBear: `Frameset_69169`
- Bubble: `Frameset_69105`, `OAM_185b98`
- Cart: `Frameset_691a7`, `Frameset_691bf`, `OAM_188279`
- Chests: `Frameset_680da`, `Frameset_68113`, `Frameset_6814c`, `Frameset_68185`
- ClearGate: `OAM_181c47`
- ClearScreen: `Frameset_d4d18`, `Frameset_d4d58`, `Frameset_d5045`, `Frameset_d504a`, `Frameset_d504f`, `Frameset_d5054`, `Frameset_d5059`, `Frameset_d505c`, `Frameset_d505f`, `Frameset_d5062`, `Frameset_d5065`, `Frameset_d5068`, `Frameset_d506b`, `Frameset_d5080`, `Frameset_d5095`, `Frameset_d5098`, `Frameset_d509b`, `Frameset_d509e`, `Frameset_d50a1`, `OAM_d4e26`
- Coin: `OAM_180003`
- CollectDemonsBloodCutscene: `Pals_b84c0`
- CountRichtertoffen: `OAM_1809ff`
- Credits: `Frameset_161caf`, `Frameset_161cc4`, `Frameset_161ce5`, `Frameset_161ce8`, `Frameset_161ceb`, `Frameset_161cee`, `OAM_1617e8`
- CutTreeCutscene: `Frameset_bc1e8`, `Frameset_bc1f3`, `OAM_bc122`, `Pals_b8c00`
- DollBoy: `Frameset_69684`, `Frameset_696b1`, `OAM_19105c`
- Doughnuteer: `Frameset_68562`, `Frameset_685ea`, `Frameset_685ed`, `OAM_180ea7`
- ElectricLamp: `Frameset_68c97`, `OAM_184eeb`
- ExpelTornadoCutscene: `Pals_b8ec0`
- ExplodeBombsCutscene: `Pals_b80c0`, `Pals_b8cc0`
- FallingSnow: `Frameset_6957e`, `OAM_1893fe`
- FeedOctohonCutscene: `Pals_b90c0`
- Fire: `Frameset_69c0a`, `OAM_18aba0`
- FireBot: `OAM_184755`
- FixElevatorCutscene: `Pals_b8000`, `Pals_b89c0`
- FlameBlock: `OAM_1895ec`
- Font: `Pals_1f3610`
- FootStoneCutscene: `Pals_b8e00`
- FreezeSeaCutscene: `Pals_b8980`
- Futamogu: `OAM_180564`
- GameOver: `Frameset_dbbf5`, `OAM_dbbd2`
- GoldMusicBoxCutscene: `Pals_b8bc0`
- GolfCourseMenu: `Frameset_1cb598`, `Frameset_1cb59b`, `Frameset_1cb59e`, `Frameset_1cb5a1`, `Frameset_1cb5c3`, `Frameset_1cb5d8`, `Frameset_1cb5db`, `Frameset_1cb5de`, `Frameset_1cb5e1`, `Pals_1ca28f`, `Pals_1ca2cf`, `Pals_1ca30f`
- GolfHole: `Frameset_1c9b87`, `Frameset_1c9b8a`, `Frameset_1caf6f`, `Frameset_1caf81`, `Frameset_1caf84`, `Frameset_1caf87`, `Frameset_1caf8a`, `Frameset_1caf8d`, `Frameset_1cafa0`, `Frameset_1cafb1`, `Frameset_1cafb6`, `Frameset_1cafc7`, `Frameset_1cafe8`, `Frameset_1cb005`, `Frameset_1cb016`, `Frameset_1cb035`, `Frameset_1cb068`, `Frameset_1cb089`, `Frameset_1cb0a4`, `Frameset_1cb0a9`, `Frameset_1cb0c2`, `Frameset_1cb0d7`, `Frameset_1cb0da`, `OAM_1ca6cf`, `Pals_1ca08f`, `Pals_1ca0cf`, `Pals_1ca10f`, `Pals_1ca14f`
- GolfLobby: `Frameset_1cb3b3`, `Frameset_1cb3c4`, `Frameset_1cb3d1`, `Frameset_1cb3d4`, `Frameset_1cb3d7`, `Frameset_1cb5cc`, `Frameset_1cb5cf`, `OAM_1cb2d3`
- GolfWario: `Frameset_1cb285`, `Frameset_1cb2ac`, `Frameset_2da4`, `Frameset_2da7`, `Frameset_2daa`, `Frameset_2dad`, `Frameset_2db0`, `Frameset_2db5`, `OAM_1cb0dd`
- GreenMusicBoxCutscene: `Pals_b8b40`
- HammerBot: `Frameset_68b12`, `OAM_18422f`
- Hand: `OAM_185893`
- Haridama: `OAM_188c7a`
- Hebarii: `Frameset_68408`, `OAM_18a703`
- Intro: `Frameset_6ce6`, `Frameset_6d18`, `Frameset_6d1b`, `Frameset_712c`, `Frameset_713d`, `Frameset_7144`, `Frameset_7165`, `Frameset_7172`, `Frameset_717b`, `Frameset_7184`, `Frameset_718d`, `Frameset_7198`, `Frameset_71a1`, `Frameset_71a4`, `Frameset_71a7`
- Jamano: `Frameset_69c69`, `Frameset_69cc5`, `OAM_19501c`
- Kobatto: `OAM_185788`
- Kushimushi: `OAM_18160c`
- LanguageSelection: `Frameset_76b5`
- LeavesFallCutscene: `Pals_b8280`, `Pals_b8f00`
- MadScienstein: `Frameset_68c33`
- MakeWireCutscene: `Pals_b8300`
- MixChemicalsCutscene: `Pals_b8400`
- Mizuuo: `Frameset_686ce`, `Frameset_686d3`, `OAM_188395`
- Muddee: `OAM_195699`
- MuddeeStinger: `Frameset_68072`
- MusicalCoinScreen: `Frameset_d65f0`, `OAM_d65e1`
- Nobiiru: `OAM_181cd3`
- OWWario: `Frameset_aa25e`, `Frameset_aa405`, `Frameset_aa416`, `Frameset_aa427`, `Frameset_aa438`
- Octohon: `Frameset_69b38`, `Frameset_69b60`, `OAM_18a895`
- Omodonmeka: `OAM_181189`, `OAM_18136c`, `OAM_18154f`
- OpenBlueSnakeDoorCutscene: `Pals_b81c0`, `Pals_b8e80`
- OpenGoldenSnakeDoorCutscene: `Pals_b8180`, `Pals_b8e40`
- OpenNorthGateCutscene: `Pals_b88c0`
- OpenParaGoomCageCutscene: `Pals_b8700`, `Pals_b9000`
- OpenSkyDoorCutscene: `Pals_b83c0`, `Pals_b9040`
- OpenTreeMouthCutscene: `Pals_b82c0`
- Owl: `Frameset_692e7`, `Frameset_69335`, `OAM_188e16`
- ParaGoom: `Frameset_68439`, `Frameset_684ba`, `OAM_180b43`
- Particle: `OAM_d80d`
- PathPreview: `Frameset_aa261`, `Frameset_aa264`, `Frameset_aa267`, `Frameset_aa26a`
- PauseMenu: `Frameset_1f1c4a`, `Frameset_1f1c4d`, `Frameset_1f1c50`, `Frameset_1f1c69`, `Frameset_1f1c74`, `Frameset_1f1c77`, `Frameset_1f1c9c`, `Frameset_1f1c9f`, `Frameset_1f1cb8`, `Frameset_1f1cbb`, `Frameset_1f1ced`, `Frameset_1f1cf0`, `Frameset_1f1cf3`, `Frameset_1f1cf6`, `Frameset_1f1cf9`, `Frameset_1f1d0a`, `Frameset_1f1d1b`, `Frameset_1f1d20`, `Frameset_1f1d41`, `Frameset_1f1d4c`, `OAM_1f156c`, `Pals_1f628c`
- Perfect: `Frameset_dd848`, `OAM_dd710`, `Pals_dc173`, `Pals_dc1b3`, `Pals_dc1cb`, `Pals_dc1e3`
- Pesce: `Frameset_699e4`, `Frameset_69a00`, `OAM_1927d5`
- PillarPlatform: `OAM_18a5ae`
- PlacePropellerCutscene: `Pals_b8440`
- PlantSeedsCutscene: `Pals_b8a80`
- Pneumo: `OAM_184db9`
- PrinceFroggy: `OAM_184000`
- PurifyWaterCutscene: `Pals_b8d80`
- RainstormCutscene: `Pals_b8080`, `Pals_b8900`
- RaisePipeCutscene: `Pals_b8380`, `Pals_b8fc0`
- RaiseTowerCutscene: `Pals_b8a00`
- RedMusicBoxCutscene: `Pals_b8b80`
- RevealCastleCutscene: `Pals_b8140`, `Pals_b8940`
- RevealWarpedVoidCutscene: `Pals_b8f80`
- RoboMouse: `OAM_188555`
- Rock: `OAM_18ab5c`
- SceneWario: `OAM_aa5fe`, `OAM_aa6e7`, `OAM_aa934`, `OAM_aad1e`, `OAM_ab0c5`
- Scowler: `Frameset_69ae3`, `Frameset_69b0d`, `OAM_194895`
- Shoot: `OAM_196583`
- Silky: `OAM_18181e`
- SmallLeaf: `OAM_181be4`
- Snake: `Frameset_6893a`, `OAM_189783`
- SouthOWObj: `Frameset_a9680`
- Spark: `OAM_18ab04`
- SpearBot: `OAM_18440a`
- Spearhead: `Frameset_681d2`
- SprayIronWallCutscene: `Pals_b8480`
- Stars: `Frameset_680a5`, `Frameset_680b6`, `Frameset_680c5`
- StartMenu: `Frameset_6cec`, `Frameset_6cef`, `Frameset_6cf2`, `Frameset_6d05`, `OAM_6b5f`
- Stove: `OAM_1896e1`
- SummonLightningCutscene: `Pals_b8c40`
- SummonSnakesCutscene: `Pals_b8dc0`
- SummonSunCutscene: `Pals_b8c80`
- SunMoon: `Frameset_68fad`, `Frameset_68fb2`, `Frameset_69012`, `Frameset_6901b`, `OAM_1851df`, `OAM_1854a2`
- Tadpole: `OAM_18a642`
- Teruteru: `OAM_18496f`
- Title: `OAM_6d21`
- Togeba: `OAM_188b56`
- TopBar: `Frameset_aa091`, `Frameset_aa094`, `Frameset_aa097`, `Frameset_aa09a`, `Frameset_aa0a9`, `Frameset_aa0ae`, `Frameset_aa0b1`, `Frameset_aa0b4`, `Frameset_aa0b9`, `Frameset_aa0c6`
- Torch: `Frameset_68354`, `OAM_180838`
- TorchForestCutscene: `Pals_b8f40`
- UnusedFlower: `Frameset_6838c`, `Frameset_68395`, `OAM_180916`
- VolcanoEruptionCutscene: `Pals_b8a40`
- WallCrack: `Frameset_6a052`, `Frameset_6a05f`, `OAM_18c806`
- Wario: `Frameset_155a0`, `Frameset_155a3`, `Frameset_15f9a`, `Frameset_15fb8`, `Frameset_15ff2`, `Frameset_1789c`, `Frameset_178c3`, `Frameset_1dd230`, `Frameset_1dd295`, `Frameset_1dd316`, `Frameset_1dd323`, `OAM_1742d`
- WarioBall: `Frameset_1dd26c`, `Frameset_1dd2ee`
- WarioBallOString: `Frameset_173fe`, `Frameset_17414`, `Frameset_1741f`
- WarioBat: `Frameset_1fd434`
- WarioBouncy: `Frameset_1fcc6c`, `Frameset_1fcc98`, `Frameset_1fcca5`, `Frameset_1fccb2`, `Frameset_1fccbf`
- WarioBump: `Frameset_14a6c`, `Frameset_14a71`, `Frameset_14a79`
- WarioCrazy: `Frameset_1fcf6e`, `Frameset_1fcf9f`
- WarioCrouch: `Frameset_14a26`, `Frameset_14a2f`
- WarioFat: `Frameset_17834`, `Frameset_17839`, `Frameset_1783e`, `Frameset_17841`, `Frameset_17872`, `Frameset_17887`
- WarioFlat: `Data_2b664`, `Data_2b68c`, `Frameset_17186`, `Frameset_17190`, `Frameset_17193`, `Frameset_171a3`, `Frameset_171b8`
- WarioGrab: `Frameset_15fa8`, `Frameset_15fab`, `Frameset_163f5`
- WarioHot: `Frameset_16b26`, `Frameset_16b2f`
- WarioInBubble: `Data_2b6b4`, `Frameset_1fdb2c`, `OAM_1fd87c`
- WarioOwl: `Frameset_1fed53`, `Frameset_1fede5`
- WarioRoll: `Frameset_166e6`
- WarioSnowball: `Frameset_1ff92b`, `Frameset_1ff956`, `OAM_1ff64a`
- WarioSnowman: `Frameset_1ff60c`, `Frameset_1ff617`, `Frameset_1ff622`, `Frameset_1ff625`
- WarioSwallowed: `Frameset_1dc40f`, `Frameset_1dc42c`
- WarioThrow: `Frameset_163fe`
- WarioUnderwater: `Frameset_155a6`, `Frameset_155ab`
- WarioZombie: `Frameset_1fc8a6`, `Frameset_1fc8ab`, `Frameset_1fc8b0`, `Frameset_1fc8b3`
- WaterDrop: `OAM_18a5cc`
- WaterSpark: `OAM_18a7fd`
- Webber: `Frameset_682c8`, `OAM_180242`
- WestOWObj: `Frameset_a8eca`, `Frameset_a8ee8`
- Wolfenboss: `Frameset_69e30`, `Frameset_69e50`, `Frameset_69e7b`, `OAM_195e06`
- Wormwould: `Frameset_696f8`, `Frameset_6973d`, `Frameset_69746`, `Frameset_6974d`, `Frameset_69754`, `OAM_194000`
- YellowBelly: `Frameset_69870`, `Frameset_69875`, `Frameset_6987a`, `OAM_19153c`, `OAM_1926dc`
- ZipLine: `OAM_18834a`
- Zombie: `Frameset_68db3`, `Frameset_68dc4`, `OAM_184ffa`

**Rule W (Wario graphics shared by several states, medium)**, 95 labels

- Wario: `Frameset_14252`, `Frameset_1425f`, `Frameset_149c5`, `Frameset_14a38`, `Frameset_14a3b`, `Frameset_14cbe`, `Frameset_14cc5`, `Frameset_14cf6`, `Frameset_14d18`, `Frameset_151e4`, `Frameset_151fd`, `Frameset_1522d`, `Frameset_158d6`, `Frameset_158fd`, `Frameset_15900`, `Frameset_15945`, `Frameset_15f70`, `Frameset_15f7f`, `Frameset_15f91`, `Frameset_15fa1`, `Frameset_15fc5`, `Frameset_16009`, `Frameset_16055`, `OAM_14000`, `OAM_14a82`, `OAM_14d1b`, `OAM_155cc`, `OAM_15955`, `OAM_1606a`, `OAM_1fd031`
- WarioBallOString: `OAM_171c0`
- WarioBat: `Frameset_1fd42c`, `Frameset_1fd46c`, `Frameset_1fd479`
- WarioBlind: `Frameset_15f97`
- WarioBump: `Frameset_15216`, `Frameset_15219`
- WarioCrazy: `Frameset_17ce2`, `OAM_17bbc`
- WarioElectric: `Frameset_17b76`, `Frameset_17b79`, `OAM_1790e`
- WarioFence: `Frameset_14d0b`, `Frameset_14d10`, `Frameset_14d15`
- WarioFlat: `OAM_16e9d`
- WarioGetTreasure: `Frameset_1fc439`, `Frameset_1fc446`, `Frameset_1fc453`, `Frameset_1fc45a`, `Frameset_1fc461`, `Frameset_1fc46a`, `OAM_1fc000`, `OAM_1fc31b`
- WarioGrab: `Frameset_149fe`, `Frameset_14a0f`, `Frameset_14a20`, `Frameset_14a23`, `Frameset_163ec`, `Frameset_1640c`, `Frameset_16415`
- WarioOnFire: `Frameset_16b14`, `Frameset_16b1d`, `Frameset_16b38`, `Frameset_16b49`, `OAM_1673c`
- WarioOwl: `Frameset_1fed7c`, `Frameset_1fed91`, `Frameset_1feda6`, `Frameset_1fedbb`, `Frameset_1fedd0`, `Frameset_1fedfe`, `OAM_1fddb4`
- WarioRail: `Frameset_1feeb4`, `Frameset_1feec4`, `OAM_1fee05`
- WarioRoll: `Frameset_166f7`
- WarioSlid: `Frameset_1671d`
- WarioSwim: `Frameset_15569`, `Frameset_15573`, `Frameset_15576`, `Frameset_1558b`
- WarioThrow: `Frameset_1641e`, `Frameset_16423`, `Frameset_1642f`, `Frameset_16435`, `Frameset_16441`
- WarioUnderwater: `Frameset_1556c`, `Frameset_155c5`, `OAM_15254`
- WarioVampire: `Frameset_1fd439`, `Frameset_1fd82e`, `OAM_1fd498`
- WarioWater: `Frameset_15554`, `Frameset_1555b`

**Rule S (one "show" routine, medium)**, 38 labels

`Frameset_1e6b70` ActionHelpAInputFrameset; `Frameset_1e6b73` ActionHelpBInputFrameset; `Frameset_1e6b79` ActionHelpDUpInputFrameset; `Frameset_1e6b7c` ActionHelpDRightInputFrameset; `Frameset_1e6b7f` ActionHelpDDownInputFrameset; `Frameset_1e6b82` ActionHelpDLeftInputFrameset; `Frameset_1e6b88` ActionHelpSlideFrameset; `Frameset_1e6b93` ActionHelpVerticalBlockPairFrameset; `Frameset_1e6ba8` ActionHelpDRightAndDDownInputFrameset; `Frameset_1e6f36` ActionHelpParaGoomWalkFrameset; `Frameset_1e6f3f` ActionHelpParaGoomThrownFrameset; `Frameset_1e6f48` ActionHelpParaGoomStunFrameset; `Frameset_1e6f55` ActionHelpCountRichtertoffThrownFrameset; `Frameset_1e6f5e` ActionHelpCountRichtertoffStunFrameset; `Frameset_1e6f78` ActionHelpFutamoguAngryFrameset; `Frameset_1e6fcb` ActionHelpRailRotateRightFrameset; `Frameset_d4a5` ActionHelpEnemyVanishFrameset; `Frameset_d4ba` ParticleSplashFrameset; `Frameset_d4c5` ParticleDustFrameset; `Frameset_d4ea` ParticleSmokeSmallFrameset; `Frameset_d4f3` ParticleSmokeLargeFrameset; `Frameset_d502` ParticleBubblesFrameset_d502; `Frameset_d50b` ParticleBubblesFrameset_d50b; `Frameset_d525` ParticleStarsFrameset; `Frameset_d591` ParticleBouncyJumpFrameset; `Frameset_d622` ParticleBubbleBurstFrameset; `Frameset_d6e4` ParticleIceFrameset_d6e4; `Frameset_d6fd` ParticleIceFrameset_d6fd; `Frameset_d75a` ParticleTreasureGlowFrameset; `Frameset_d806` ParticleSnowFrameset; `Frameset_d8e7` ParticleMagic1Frameset; `Frameset_d8f4` ParticleMagic2Frameset; `Frameset_d901` ParticleMagicStopFrameset; `OAM_d532` ParticleBouncyJumpOAM; `OAM_d5ae` ParticleBubbleBurstOAM; `OAM_d62b` ParticleIceOAM; `OAM_d716` ParticleTreasureGlowOAM; `OAM_d7bd` ParticleSnowOAM

**Rule U (unreferenced, owner of the neighbours)**, 287 labels

- Unreferenced (low): `Data_82026`, `Frameset_1c8e21`, `Frameset_bc10d`, `Frameset_bc110`, `Frameset_bc113`, `Frameset_bc116`, `Frameset_bc119`, `Frameset_bc11c`, `Frameset_bc11f`, `Pals_d206`
- UnreferencedActionHelp (medium): `Frameset_1e6b9f`, `Frameset_1e6f52`, `Frameset_1e6f63`
- UnreferencedAnonster (medium): `Frameset_6945d`, `Frameset_69460`, `Frameset_69537`
- UnreferencedAppleby (medium): `Frameset_68a55`
- UnreferencedBarrel (low): `Frameset_68a92`
- UnreferencedBeamBot (low): `Frameset_68efd`, `Frameset_68f04`
- UnreferencedBottomBar (low): `Frameset_aa308`, `Frameset_aa30b`, `Frameset_aa30e`, `Frameset_aa311`, `Frameset_aa314`, `Frameset_aa317`, `Frameset_aa31a`, `Frameset_aa31d`, `Frameset_aa320`, `Frameset_aa323`, `Frameset_aa326`
- UnreferencedChests (low): `Frameset_68065`
- UnreferencedCountRichtertoffen (medium): `Frameset_683cf`
- UnreferencedEastOWObj (medium): `Frameset_a9e81`
- UnreferencedElectricLamp (low): `Frameset_68cde`, `Frameset_68ce7`, `Frameset_68cf0`, `Frameset_68cf7`, `Frameset_68cfe`, `Frameset_68d03`, `Frameset_68d08`, `Frameset_68d11`
- UnreferencedElectricLamp (medium): `Frameset_68ca9`, `Frameset_68cb2`, `Frameset_68cbb`
- UnreferencedFlameBlock (low): `Frameset_69608`
- UnreferencedGolfCourseMenu (medium): `Frameset_1cb5ba`, `Frameset_1cb5bd`, `Frameset_1cb5c0`
- UnreferencedGolfHole (medium): `Frameset_1caf78`
- UnreferencedHiddenFigure (medium): `Frameset_6a09c`, `Frameset_6a0a7`, `Frameset_6a0d7`, `Frameset_6a0da`, `Frameset_6a0dd`, `Frameset_6a0e0`, `Frameset_6a0e3`, `Frameset_6a0e6`, `Frameset_6a0e9`, `Frameset_6a0ec`, `Frameset_6a0f5`, `Frameset_6a0f8`, `Frameset_6a0fb`, `Frameset_6a101`, `Frameset_6a104`, `Frameset_6a107`, `Frameset_6a10a`, `Frameset_6a10d`, `Frameset_6a110`, `Frameset_6a113`, `Frameset_6a116`, `Frameset_6a11f`, `Frameset_6a122`, `Frameset_6a125`
- UnreferencedJamano (medium): `Frameset_69c25`, `Frameset_69c2e`, `Frameset_69c37`, `Frameset_69c58`, `Frameset_69c89`, `Frameset_69caa`, `Frameset_69cb3`, `Frameset_69cbc`
- UnreferencedKobatto (low): `Frameset_69060`
- UnreferencedKushimushi (low): `Frameset_6869b`
- UnreferencedKushimushi (medium): `Frameset_68660`, `Frameset_68667`, `Frameset_6866e`, `Frameset_68675`, `Frameset_6867c`, `Frameset_68683`, `Frameset_6868a`, `Frameset_68691`
- UnreferencedMizuuo (medium): `Data_60720`
- UnreferencedMuddee (medium): `Frameset_69d7c`
- UnreferencedMuddeeStinger (low): `Frameset_6807f`, `Frameset_6808e`
- UnreferencedNorthOWObj (low): `Frameset_aa255`, `Frameset_aa258`, `Frameset_aa25b`, `Frameset_aa5fb`
- UnreferencedOWUI (low): `Frameset_aa5e9`, `Frameset_aa5ec`, `Frameset_aa5ef`, `Frameset_aa5f2`
- UnreferencedOctohon (low): `Frameset_69b91`
- UnreferencedOwl (low): `Frameset_69382`, `Frameset_6938d`, `Frameset_69398`, `Frameset_693a3`, `Frameset_693ae`, `Frameset_693b9`
- UnreferencedOwl (medium): `Frameset_69340`, `Frameset_6934b`, `Frameset_69356`, `Frameset_69363`
- UnreferencedParticle (low): `Frameset_d4ce`, `Frameset_d4d5`, `Frameset_d4dc`, `Frameset_d4e3`
- UnreferencedParticleBubbles (low): `Frameset_d514`, `Frameset_d519`, `Frameset_d51c`, `Frameset_d51f`, `Frameset_d522`
- UnreferencedPathPreview (low): `Frameset_aa26d`, `Frameset_aa270`, `Frameset_aa2a9`, `Frameset_aa2b2`
- UnreferencedPesce (medium): `Frameset_699e9`, `Frameset_699ee`, `Frameset_699f7`, `Frameset_69a03`, `Frameset_69a06`, `Frameset_69a09`, `Frameset_69a0c`, `Frameset_69a0f`, `Frameset_69a12`
- UnreferencedPneumo (medium): `Frameset_68c6d`, `Frameset_68c76`
- UnreferencedSceneWario (low): `Frameset_d4e23`
- UnreferencedSceneWario (medium): `Frameset_aa910`, `Frameset_ab095`
- UnreferencedScowler (medium): `Frameset_69acc`, `Frameset_69aec`, `Frameset_69afc`
- UnreferencedSeeingEyeDoor (medium): `Frameset_68c4d`, `Frameset_68c53`
- UnreferencedShoot (medium): `Frameset_69f4b`, `Frameset_69f81`, `Frameset_69fae`, `Frameset_69fb3`
- UnreferencedSpark (low): `Frameset_69be2`, `Frameset_69bf5`
- UnreferencedSpearhead (low): `Data_601f0`
- UnreferencedSpearhead (medium): `Data_601d0`, `Frameset_6823d`, `Frameset_68246`
- UnreferencedSunMoon (medium): `Frameset_68f7d`, `Frameset_68f86`, `Frameset_68fe2`, `Frameset_68feb`
- UnreferencedTadpole (low): `Frameset_69a42`, `Frameset_69a47`, `Frameset_69a4c`, `Frameset_69a51`, `Frameset_69a58`
- UnreferencedTadpole (medium): `Frameset_69a20`, `Frameset_69a23`, `Frameset_69a2b`, `Frameset_69a38`
- UnreferencedTempleSceneObj (low): `Frameset_15e95f`, `Frameset_15e962`, `Frameset_15e965`, `Frameset_15e968`, `Frameset_15e96b`, `Frameset_15e974`
- UnreferencedTempleSceneObj (medium): `Frameset_15e8b9`, `Frameset_15e8be`, `Frameset_15e8c3`, `Frameset_15e8cc`, `Frameset_15e8d1`, `Frameset_15e8d6`, `Frameset_15e8db`, `Frameset_15e8e6`, `Frameset_15e8f1`, `Frameset_15e8f6`, `Frameset_15e8fb`, `Frameset_15e902`, `Frameset_15e909`, `Frameset_15e910`, `Frameset_15e917`, `Frameset_15e91a`, `Frameset_15e91d`, `Frameset_15e920`, `Frameset_15e923`, `Frameset_15e926`, `Frameset_15e929`, `Frameset_15e92c`, `Frameset_15e92f`, `Frameset_15e935`, `Frameset_15e938`, `Frameset_15e93b`, `Frameset_15e93e`, `Frameset_15e941`, `Frameset_15e944`, `Frameset_15e947`, `Frameset_15e94a`, `Frameset_15e94d`, `Frameset_15e950`, `Frameset_15e953`, `Frameset_15e956`, `Frameset_15e959`
- UnreferencedTopBar (medium): `Frameset_aa0a0`, `Frameset_aa0a6`
- UnreferencedUnusedFlower (medium): `Frameset_6839e`, `Frameset_683a3`
- UnreferencedWario (low): `Frameset_149d6`, `Frameset_149d9`, `Frameset_149dc`, `Frameset_149ed`, `Frameset_14a3e`, `Frameset_14a4f`, `Frameset_14a60`, `Frameset_14a63`, `Frameset_14a66`, `Frameset_14a69`, `Frameset_1dd23b`, `Frameset_1dd2a0`
- UnreferencedWarioBall (low): `Frameset_1dd26f`
- UnreferencedWarioBallAirborne (low): `Frameset_1dd2f9`, `Frameset_1dd306`
- UnreferencedWarioBallShot (low): `Frameset_1dd2dc`, `Frameset_1dd2e9`
- UnreferencedWarioBat (medium): `Frameset_1fd431`
- UnreferencedWarioBatTransforming (low): `Frameset_1fd429`
- UnreferencedWarioBouncy (low): `Frameset_1fcccc`
- UnreferencedWarioBump (low): `Frameset_14a7c`, `Frameset_14a7f`
- UnreferencedWarioCrazyTurning (low): `Frameset_1fcfde`, `Frameset_1fcfef`, `Frameset_1fd000`
- UnreferencedWarioPuffyInflating (low): `Frameset_1dccd2`, `Frameset_1dccd5`
- UnreferencedWarioRail (medium): `Frameset_1feebd`
- UnreferencedWarioSlid (low): `Frameset_16732`, `Frameset_16737`
- UnreferencedWarioSnowballCrash (low): `Frameset_1ff988`, `Frameset_1ff9cd`
- UnreferencedWarioTurningInvisible (low): `Frameset_17e59`, `Frameset_17e78`
- UnreferencedWarioVampire (low): `Frameset_1fd45c`, `Frameset_1fd837`
- UnreferencedWarioVampireTurning (low): `Frameset_1fd848`, `Frameset_1fd851`, `Frameset_1fd85a`, `Frameset_1fd85d`, `Frameset_1fd860`, `Frameset_1fd869`, `Frameset_1fd872`, `Frameset_1fd877`
- UnreferencedWaterSpark (medium): `Frameset_69b1b`
- UnreferencedWestOWObj (medium): `Frameset_a8f54`
- UnreferencedWolfenboss (low): `Frameset_69ec3`, `Frameset_69ed6`, `Frameset_69ee9`, `Frameset_69efc`, `Frameset_69f0f`, `Frameset_69f22`
- UnreferencedWolfenboss (medium): `Frameset_69dd0`, `Frameset_69e69`
- UnreferencedYellowBelly (low): `Frameset_698a5`
- UnreferencedYellowBelly (medium): `Frameset_697f0`, `Frameset_697f9`, `Frameset_69802`, `Frameset_69811`, `Frameset_69820`, `Frameset_6982b`, `Frameset_69836`, `Frameset_69866`, `Frameset_6986b`
- UnreferencedZombie (medium): `Frameset_68d32`, `Frameset_68d3f`, `Frameset_68d48`, `Frameset_68d51`, `Frameset_68d58`, `Frameset_68d5f`, `Frameset_68d70`

### 4d. Optional consistency renames

Not needed for meaning; they make existing names follow the rules used
elsewhere.

| Current | Proposed | Why | Conf. |
|---|---|---|---|
| `OWCutTree` (bank27.asm:7631) | `UpdateCutsceneObjs_CutTree` | It is Cutscene02's object updater (`jp OWCutTree` at the end of its step table), the only one not named `UpdateCutsceneObjs_<Event>` (3b). | high |
| `UpdateTempleSceneObjs` (bank2b_1.asm:454) | `UpdateTempleSceneObjs_Back` | Pairs with the 4a proposal `UpdateTempleSceneObjs_Front` (`Func_ac2b2`), as the epilogue's `UpdateEpilogueSceneObjs_Front` / `_Back`. | high |
| `wGoldBuildingCourseAttrMap` (wram.asm:1180) | `wGolfBuildingCourseAttrMap` | Typo ("Gold" for "Golf"); used in golf/hole.asm:3181 and golf/building/building.asm:472. | high |

**bank2d waits by frames.** bank2d's map-side scenes number their wait
steps in order (`.Wait1`, `.Wait2`, ...) in 24 scenes, not only
`SOWFunc_RaiseTower`, while the other bank2d scenes, bank27 and the 3b
rule 3 name them by frames. All 88 `.Wait<N>` locals of bank2d are
`ld a, N / jp WaitOWFunc`, so rule 3 applies as is:
`.Wait<N>`, with `_1`, `_2` when a scene has several waits of the same
length (`SOWFunc_RaiseTower`: `.Wait1` 30, `.Wait2` 45, `.Wait3` and
`.Wait4` 40 frames -> `.Wait30`, `.Wait45`, `.Wait40_1`, `.Wait40_2`). 51
labels change (the other 37 already give their frame count); generated by
script, medium only because the ordinal names are not wrong:

`NOWFunc_CutTree.Wait1` .Wait4_1; `NOWFunc_CutTree.Wait2` .Wait4_2; `NOWFunc_OpenGate.Wait1` .Wait4_1; `NOWFunc_OpenGate.Wait2` .Wait4_2; `NOWFunc_MagicSeed.Wait1` .Wait20; `NOWFunc_MagicSeed.Wait2` .Wait30; `NOWFunc_SummonSnake.Wait1` .Wait8; `NOWFunc_FallLeaves.Wait1` .Wait20; `NOWFunc_FallLeaves.Wait2` .Wait8; `NOWFunc_FallLeaves.Wait3` .Wait40; `NOWFunc_PlayMusicBox.Wait1` .Wait20; `NOWFunc_PlayMusicBox.Wait2` .Wait254; `NOWFunc_Crayon.Wait1` .Wait20_1; `NOWFunc_Crayon.Wait2` .Wait4; `NOWFunc_Crayon.Wait3` .Wait10; `NOWFunc_Crayon.Wait4` .Wait20_2; `NOWFunc_BottomBar.Wait1` .Wait40; `NOWFunc_BottomBar.Wait2` .Wait45; `NOWFunc_BottomBar.Wait3` .Wait10; `NOWFunc_BottomBar.Wait4` .Wait60; `NOWFunc_DayNightSpell.Wait1` .Wait30; `NOWFunc_DayNightSpell.Wait2` .Wait40; `NOWFunc_DayNightSpell.Wait3` .Wait60; `WOWFunc_Rain.Wait1` .Wait180; `WOWFunc_Rain.Wait2` .Wait120; `WOWFunc_Rain.Wait3` .Wait60; `WOWFunc_ClearTornado.Wait1` .Wait20; `WOWFunc_ElevatorWorking.Wait1` .Wait20; `WOWFunc_ElevatorWorking.Wait2` .Wait200; `WOWFunc_MagicSeed.Wait1` .Wait20; `WOWFunc_MagicSeed.Wait2` .Wait30; `WOWFunc_SummonSnake.Wait1` .Wait8; `WOWFunc_Earthquake.Wait1` .Wait20; `WOWFunc_VulcanoEruption.Wait1` .Wait60; `WOWFunc_RedMusicBox.Wait1` .Wait20; `SOWFunc_SendSeeds.Wait1` .Wait30; `SOWFunc_SendSeeds.Wait2` .Wait10; `SOWFunc_MagicSeed.Wait1` .Wait20; `SOWFunc_MagicSeed.Wait2` .Wait30; `SOWFunc_YellowMusicBox.Wait1` .Wait20; `SOWFunc_YellowMusicBox.Wait2` .Wait40; `SOWFunc_RaiseTower.Wait1` .Wait30; `SOWFunc_RaiseTower.Wait2` .Wait45; `SOWFunc_RaiseTower.Wait3` .Wait40_1; `SOWFunc_RaiseTower.Wait4` .Wait40_2; `SOWFunc_SummonSnake.Wait1` .Wait20; `SOWFunc_GreenMusicBox.Wait1` .Wait20; `SOWFunc_GreenMusicBox.Wait2` .Wait40; `SOWFunc_FullMoon.Wait1` .Wait40; `SOWFunc_FullMoon.Wait2` .Wait30; `SOWFunc_FullMoon.Wait3` .Wait60

### 4e. Other address-named routines (outside the overworld)

Not on the resume list, but a grep of `src/` still found them: clear screens, credits, game over, golf, title, the level engine (block functions, Wario-state helpers, objects), audio and action help locals, plus the `VBlank_`, `Text_` and `UnreferencedLCD_` labels of the inventory. All read; same conventions.

| Where | Current -> proposed | Evidence | Conf. |
|---|---|---|---|
| title/start_menu.asm:174 | `Func_4628` -> `ReturnToOverworld`; `EpilogueStateTable`: `.Func_473c` -> `.ReturnToOverworld` | `farcall`ed by the epilogue state table, the musical coin screen's exit and all ten action-help screens: clears the animated-tile settings and `wUnused_3d50d`, sets bit 7 of `wDayNight` (redraw on entry) and falls into `StartOverworldState`. `EpilogueStateTable.Func_473c` is the epilogue's last sub-state, only that `farcall`. | high |
| home/overworld.asm:471 | `Func_3c76` -> `ClearUnused_2d0c0` | Zeroes the 16 bytes of `wUnused_2d0c0` (the second pass's suggestion, now that the RAM label is applied). | high |
| title/intro_animation.asm:102 | `Func_4d45` -> `ScrollIntroClouds` | Called by the three intro phases: moves menu objects 4 and 5 (the two `Frameset_71a1`/`71a4` sprites placed at Y 16 and 8 near the top) right, one every frame and one every other frame, until X 176 (with conditions on the intro sub-state). Clouds is a guess. | medium |
| clear/bank78.asm:8 | `Func_1e000d` -> `LoadTimeAttackClearScreenPals`; `Func_1e0045` -> `LoadTreasureClearScreenBGMaps`; `Func_1e005f` -> `LoadTimeAttackClearScreenBGMaps`; `Func_1e015b` -> `InitTreasureClearScreenObjs`; `Func_1e028a` -> `InitTimeAttackClearScreenObjs`; `Func_d434c` -> `UpdateTimeAttackClearScreen` | Clear screen (bank78): the time attack version of `LoadClearScreenPals`; `Func_1e0045` / `Func_1e005f` the treasure / time attack BG maps (the second also works out `wTimeAttackResult` (`.GetResult`) and writes the best time and, when the run finished, the level time into the map); `Func_1e015b` / `Func_1e028a` place the screen's sprites (power-up icon, Clear Wario, the treasure or keys, record sprite) and start the music. `Func_d434c` is `SST_CLEAR_TIME_ATTACK`'s update, next to `UpdateClearScreen`. | high (medium: `InitTreasureClearScreenObjs`, `InitTimeAttackClearScreenObjs`) |
| clear/musical_coins.asm:62 | `Func_d4472` -> `MusicalCoinScreen_CountCoins`; `Func_d4507` -> `MusicalCoinScreen_MovePencil`; `Func_d454c` -> `MusicalCoinScreen_ColourLevel`; `Func_d45e1` -> `MusicalCoinScreen_GoToExit`; `Func_d464e` -> `LoadMusicalCoinScreenPals`; `Func_d465b` -> `LoadMusicalCoinScreenGfx`; `Func_d4668` -> `LoadMusicalCoinScreenBGMaps`; `Func_d47f1` -> `ColourMusicalCoinLevels` | The three update sub-states of `SST_CLEAR_MUSICAL_COINS` (clear/state_table.asm) after `InitMusicalCoinScreen`: count the coins up (`SFX_REGULAR_COIN`, a digit every 4 frames); if all 8 were collected the pencil comes in (`DoPencilMovement`) and scribbles (`DoPencilScribbling`), colouring the level's cell at frame 20 (`MusicalCoinLevelBGPals`) and playing `SFX_MUSICAL_COIN`; `Func_d45e1` sets the exit timer and `SST_CLEAR_EXIT`. `Func_d464e`/`d465b`/`d4668` load its palettes, gfx and maps (the gfx and maps are the golf menu's: `GolfMenuGfx`, `GolfMenuTilemap`/`Attrmap`). `Func_d47f1` gives the cells of the levels with the musical coin flag set their palette. | high |
| credits/credits.asm:209 | `Func_160190` -> `Credits_MoveMusicBox`; `Func_16026c` -> `Credits_ShowCloseUp`; `Func_1602ee` -> `Credits_LoadFinalPals`; `Func_160318` -> `Credits_FadeIn`; `Func_160365` -> `Credits_WaitEnd`; `Func_1603be` -> `LoadCreditsCloseUpPals`; `Func_1603cb` -> `LoadCreditsFinalPals`; `Func_16041f` -> `LoadCreditsBGMaps`; `VBlank_160439` -> `VBlank_Credits` | Credits sub-states after `ShowCredits` (credits/state_table.asm): the music box moves to the centre and plays its winding animation (menu object 1 is the key) 3 times; `Func_16026c` switches to the close-up (`Frameset_15e7ed` with the prologue's `OAM_15e44a`, `LoadCreditsCloseUpPals`, window on); `Func_1602ee` loads the final palettes; `Func_160318` fades in every 16 frames while object 1 moves to Y $80; `Func_160365` waits (with `TRANSITION_EPILOGUE_PERFECT`: a button or 180 frames go to `SetPerfectState`). `VBlank_160439` is installed by `InitCredits`. | high (medium: `Credits_MoveMusicBox`, `Credits_ShowCloseUp`, `Credits_LoadFinalPals`, `Credits_FadeIn`) |
| game_over/core.asm:152 | `UpdateGameOverScreen`: `.Func_db3db` -> `.PlaySnoreSFX`; `Func_db3e4` -> `WaitGameOverWarioAnim`; `Func_db4cf` -> `LoadGameOverBGMaps`; `Func_db4e9` -> `LoadGameOverSpriteWithScroll` | `.PlaySnoreSFX` when the sleeping Wario's animation loops. `Func_db3e4`: the next sub-state, waits for the wake-up animation (A pressed) to end. `Func_db4cf`: BG maps. `Func_db4e9`: like `LoadGameOverSprite` but subtracts `wSCY` (the screen shakes at the start), with `OAM_dbbd2`. | high (medium: `WaitGameOverWarioAnim`) |
| golf/building/building.asm:1 | `Func_1c8586` -> `InitGolfCourseMenu`; `Func_1c8604` -> `LoadGolfCourseMenuScreen`; `Func_1c86dd` -> `UpdateGolfCourseMenu`; `Func_1c86f8` -> `DrawGolfCourseMenuObjs`; `Func_1c87db` -> `LoadGolfCourseAttrsAndPals`; `Func_1c882b` -> `HandleGolfCourseMenu`; `Func_1c8837` -> `GolfCourseMenu_Input`; `Func_1c88dc` -> `GolfCourseMenu_Scroll`; `Func_1c8907` -> `GolfCourseMenu_EndScroll`; `Func_1c8911` -> `GolfCourseMenu_PayCoins` | The golf course menu inside the Golf Building (golf/building/state_table.asm); "course menu" because `UpdateGolfBuilding` is already the overworld scene's name. `Func_1c87db` (comment: "loads attribute map to wGolfCourseTileMap and palettes to wGolfPals"); `Func_1c882b` the `wGolfBuildingState` jumptable of the second pass (0 input, 1 scrolling, 2 reached target SCX, 3 paid) and its four entries; `Func_1c8911` takes the 50 coins one by one (`SFX_12B`) and picks the course's first hole. | high |
| golf/hole.asm:2 | `Func_1c8957` -> `UnreferencedGolfHoleStateTable`; `Func_1c8fb7` -> `UnreferencedGolfHoleState_DoNothing`; `Func_1c9cf9` -> `SetGolfHoleVBlankFunc`; `Func_1c9fae` -> `SetGolfCourseMenuVBlankFunc`; `Func_1c9fbd` -> `SetGolfCoinDigitSprites` | Marked unreferenced: a sub-state table for a golf hole (`FastFadeToWhite`, `InitGolfHole`, ...), whose last entry `Func_1c8fb7` is a `ret`. `Func_1c9cf9` picks the LCDC value from `wGolfDisplayMode` and then the VBlank function by `wGolfVBlankMode`; `Func_1c9fae` the same for the course menu, after `Func_1c9fbd` writes the three coin digits into OAM sprites 0-2. | high |
| golf/hole.asm:2883 | `VBlank_1c9d1d` -> `VBlank_GolfHole_PinFlag`; `VBlank_1c9e8d` -> `VBlank_GolfHole_SetAttr`; `VBlank_1c9eb3` -> `VBlank_GolfHole_WarioTiles`; `VBlank_1c9ef1` -> `VBlank_GolfHole_StrokeNumber`; `VBlank_1c9f36` -> `VBlank_GolfLobby_Coins`; `VBlank_1c9f7a` -> `VBlank_GolfLobby_WarioTiles`; `VBlank_1c9fe1` -> `VBlank_GolfCourseMenu`; `VBlank_1c9ffa` -> `VBlank_GolfCourseMenu_ScrollAttrs`; `VBlank_1ca033` -> `VBlank_GolfCourseMenu_Pals`; `VBlank_1ca056` -> `VBlank_GolfCourseMenu_CourseAttrs`; `VBlank_1c84e0` -> `VBlank_GolfLobbyScroll`; `VBlank_1fb6b7` -> `VBlank_ActionHelp`; `_InitBestTimeList`: `.VBlank_158a14` -> `.VBlank_BestTimeList` | Golf VBlank functions, named by what they transfer: pin flag tiles (and SCX/WX/LCDC), one attribute byte, Wario's tiles, the stroke number tiles (`VBlank_GolfHole_*`); coin digits and Wario's tiles in the lobby; the course menu's plain one, the scrolling attrmap, the palettes and the course attributes. `VBlank_1ca056` reads `wGolfPinFlagTiles`, which is `wGolfCourseTileMap` (same address in the golf union): it should use the course label. `VBlank_1c84e0` (lobby set-up), `VBlank_1fb6b7` (`InitActionHelp`: pending DMA transfers), and bank56's `.VBlank_158a14` (best time list) follow the existing `VBlank_<screen>` names. | high (medium: `VBlank_GolfHole_SetAttr`, `VBlank_GolfLobbyScroll`) |
| level/block_functions.asm:392 | `BlockFunc_18262` -> `BlockFunc_ObjectFloor`; `Func_18624` -> `BlockFunc_Door_NoReload`; `Func_1864e` -> `BlockFunc_MinigameDoor_NoReload`; `BlockFunc_18727` -> `BlockFunc_UnderwaterDoor_NoReload`; `Func_18755` -> `BlockFunc_Transition8Door`; `BlockFunc_187b0` -> `BlockFunc_RoomExit_ReloadObjects`; `Func_187c7` -> `BlockFunc_RoomExit`; `BlockFunc_187de` -> `BlockFunc_WaterRoomExit_ReloadObjects`; `Func_187f5` -> `BlockFunc_WaterRoomExit`; `BlockFunc_18868` -> `BlockFunc_VampireWarioBarrier`; `BlockFunc_188ba` -> `BlockFunc_ObjectWall`; `BlockFunc_189f1` -> `BlockFunc_WarioFloor`; `Func_19423` -> `BreakBlockHitByThrownObj` | Block functions left address-named. `BlockFunc_18262`: free for Wario; for objects it sets `wHitFloorBlock` and is solid from above and on the down sides, or in its top 5 px (the second pass called these "one-way floors"). Doors without `ROOMTRANSITIONF_RELOAD_OBJECTS` next to the named ones: `Func_18624` (unreferenced, `ROOMTRANSITION_DOOR`), `Func_1864e` (unreferenced, `ROOMTRANSITION_GOLF`), `BlockFunc_18727` (underwater). `Func_18755` (unreferenced): UP in a block, normal or Invisible Wario, gives `ROOMTRANSITION_8` with door, reload and delay flags; `ROOMTRANSITION_4/5/8` only matter to `StartRoom_FromTransition` as "not golf, not teleport", so the type name is low. `BlockFunc_187b0` / `Func_187c7` (unreferenced): touching the block (env probe) is `ROOMTRANSITION_4`, with / without reload; `BlockFunc_187de` / `Func_187f5` the same in water; cf. the first pass's `BlockFunc_LadderExit_ReloadObjects`. `BlockFunc_18868`: free unless Wario is Vampire Wario; then solid, and pushes him out to the nearer block edge when he is inside. `BlockFunc_188ba`: solid for objects, free for Wario; `BlockFunc_189f1`: free for objects, a floor for Wario. `Func_19423`: the tail when `wBlockFuncSpecialCollision` is `COLLISION_THROWN_OBJ` (enemy blocks and two other families): replace the block (`b`, keeping bit 7), redraw and break it (only `SFX_BLOCK_BREAK` off screen). | medium (low: `BlockFunc_Transition8Door`; high: `BlockFunc_ObjectWall`) |
| level/collisions.asm:536 | `CheckAirborneCollision`: `.Func_19a53` -> `.process_landing_block` | `.process_landing_block`: clears the slope interaction, sets the break flag while smash attacking, and runs `_ProcessBlock_Landing` at the probe. | high |
| level/get_bg_ptr.asm:101 | `Func_8eac` -> `UnreferencedGetPackedNybble` | Marked unreferenced: the nybble `l / 2` of the table at `hl + $b0` (high nybble for even `l`). | medium |
| level/object_interactions.asm:1777 | `Func_20e63` -> `AttackOrBumpOffNoActions` | Used by one interaction (object_interactions.asm:3598): attack the object while `wAttackCounter` is running, else fall into `Func_20e6a` (first pass, low: `ObjInteraction_BumpOffNoActions`). | medium |
| level/objects/mad_scienstein.asm:1105 | `Func_45453` -> `InvisibilityPotion_CheckFloor`; `Func_40c19` -> `UnreferencedTorchEmberFunc_FollowWario`; `Func_56326` -> `ClearObjAndSetObjMapEntry7` | The Invisibility Potion (in mad_scienstein.asm): if its landing probe finds floor, snap Y and destroy it (`DestroyInvisibilityPotion`). `Func_40c19` (torch.asm, marked "unreferenced?"): an ember that moves towards Wario's X and falls (`Data_60320`). `Func_56326` (wolfenboss.asm): clear the object's flags and set its object map entry to 7 (`SetObjectMapEntryAndSpawn`), at the defeat and at the end of `.Disappear`. | medium (high: `InvisibilityPotion_CheckFloor`) |
| level/particles.asm:978 | `Func_ce3e` -> `GetBlockPtrBottomCentrePos` | `CreateParticleInBlock`'s first call: block pointer (`hl` in SRAM, `wBlockPtrBank`) to `hPos` at the block's bottom centre (+16, +8). Home's `GetBlockPtrPos` (first pass) does the same conversion to the top-left corner and also returns the column nybble. | high |
| level/wario_states_3.asm:1026 | `UpdateState_FlatSinking`: `.Func_2899a` -> `.CreateBubbles`; `Func_289c5` -> `SetState_FlatStretchingUnderwater`; `Func_2926a` -> `SetState_FatSinking`; `Func_29317` -> `CreateFatSinkingBubbles`; `Func_2a0c7` -> `StartBouncyJump_Common`; `Func_2a2e7` -> `StartBouncyLastBounce`; `Func_2abc1` -> `SetBatTurningFrameset`; `Func_2b1cc` -> `MoveWarioForwardBy2` | Wario-state helpers in the style of the first pass: `.CreateBubbles` (`PARTICLE_BUBBLES` above Wario every 16 frames), `Func_289c5` (`WST_FLAT_STRETCHING_UNDERWATER`), `Func_2926a` (splash, `WST_FAT_SINKING`), `Func_29317` (the fat version of the bubbles, by direction), `Func_2a0c7` (common tail of `StartBouncyJump_High`/`_Normal`: clears `wJumpVelIndex`, falls into `SetState_BouncyAirborne`), `Func_2a2e7` (when the bouncy transformation runs out: touch states, palette, the last-bounce frameset by direction, `SetState_BouncyLastBounce`), `Func_2abc1` (bat turning frameset by direction, from `UpdateState_BatFlying`/`SetState_BatFalling` when `wIsTurning`), `Func_2b1cc` (Ball o' String knock-back: 2 px in `wDirection`, moved back on a wall). | high (medium: `StartBouncyJump_Common`, `MoveWarioForwardBy2`) |
| audio/engine.asm:2542 | `ProcessTrack`: `.Func_30dc6` -> `.SetVolumeFromNoteVolume`; `.Func_30deb` -> `.SetVolumeWithFadeOut`; `.Func_30e1b` -> `.CheckWaveVolumeChange` | `.SetVolumeFromNoteVolume`: `TRACK_VOLUME` = note volume x the channel's effective volume; `.SetVolumeWithFadeOut`: the same also scaled by the fade-out envelope; `.CheckWaveVolumeChange`: on sound 3, a change in the level bits sets `CHANFLAGS_UPDATE_VOLUME`. | high |
| action_help/common2.asm:149 | `LoadActionHelpBGMaps`: `.Func_1e499c` -> `.draw_locked_slot`; `GrabGloveActionHelp_Step19`: `.Func_1f9a25` -> `.show_debris_and_pillar` | `.draw_locked_slot`: the power-up slots above the obtained level get tiles $64/$65/$74/$75 with palette 7. `GrabGloveActionHelp_Step19.show_debris_and_pillar`: block debris, object 5 moved to object 6, the overhead pillar. | medium |
| level/objects/omodonmeka.asm:1131 | `OmodonFunc`: `.Func_42894` -> `.pass_stepped_flag_to_omodonmeka`; `.Func_42935` -> `.check_omodonmeka_linked` | The two object searches the second pass left "not named": `.check_omodonmeka_linked` looks through the 8 slots for an active, non-transient object with the same object-map pointer (flags & $41 = $01) and sets the substate to $10 if there is one (0 if not); `.pass_stepped_flag_to_omodonmeka` finds the active, on-screen, non-transient one (flags & $43 = $03) and copies this object's `OBJFLAG_STEPPED` into it (so stepping on the Omodon counts for the Omodonmeka carrying it), then checks a state of $3a. | medium |
| bank20.asm:4202 | `UnreferencedLCD_82729` -> `UnreferencedLCDFunc_SetBGMap1`; `UnreferencedLCD_82754` -> `UnreferencedLCDFunc_Reti` | Both marked unreferenced: copy an LCD (STAT) handler to `wLCDFunc`. The first switches to BG map 1 in the next HBlank (and writes `a` = 2 to `rSCY`/`rSCX`, which looks like leftover code); the second is a bare `reti`. | medium (high: `UnreferencedLCDFunc_Reti`) |
| overworld.asm:139 | `Text_b2107` -> `TextJP_HiddenFigureHeadFor_Unused`; `Text_b231c` -> `TextEN_HiddenFigureHeadFor_Unused`; `Text_b2411` -> `TextJP_HiddenFigureReplenishPower_Unused`; `Text_b2533` -> `TextEN_HiddenFigureReplenishPower_Unused`; `Text_b37e6` -> `TextJP_HiddenFigureAreYouAware_Unused`; `Text_b39f0` -> `TextEN_HiddenFigureAreYouAware_Unused`; `Text_15e212` -> `TextJP_OldManThankYou_Unused`; `Text_15e437` -> `TextEN_OldManThankYou_Unused` | Unreferenced short filler string after each text tilemap in "Hidden Figure Text 1/2" and "OW BG Maps 2" (the same bytes each time): named after the text they follow. | medium |
| perfect/core.asm:123 | `Func_dc101` -> `LoadPerfectCyclePals0`; `Func_dc10d` -> `LoadPerfectCyclePals1`; `Func_dc119` -> `LoadPerfectCyclePals2`; `Func_dc125` -> `LoadPerfectCyclePals3`; `Func_dc13e` -> `LoadPerfectBGMaps`; `Func_dc158` -> `LoadPerfectSprite` | Perfect screen: the update cycles BG palettes 5-7 every 8 frames through `Pals_dc173` palettes 5-7 (`Func_dc101`), `Pals_dc1b3`, `Pals_dc1cb` and `Pals_dc1e3` (the other three); `Func_dc13e` loads the BG maps, `Func_dc158` draws a sprite with `OAM_dd710`. | high |
| home/fade.asm:818 | `VBlank_88d` -> `VBlank_StorePals`; `VBlank_8bf` -> `VBlank_LoadPalsFromWRAM` | Home fade helpers: `VBlank_88d` backs up `wVBlankFunc` and installs a function that stores the current BG/OB palettes into WRAM (`StoreBGPals`/`StoreOBPals`); `VBlank_8bf` installs one that loads them from WRAM every frame (`LoadBGPalettesFromWRAM`/`LoadOBPalettesFromWRAM`). Used at the start of every fade routine in fade.asm. | high |
| bank20.asm:611 | `Func_812b0` -> `UnreferencedGetMapSideLastLevel` | Marked unreferenced (bank20.asm:611; the third pass left it open): returns in `c` the byte for `wNextMapSide` from `.data` = 6, 5, 5, 6 for north, west, south, east, which is the index of the last level on each side (`NUM_<SIDE>_LEVELS` - 1: 7, 6, 6, 7 levels). | medium |

### Findings of the fourth pass (not renames)

Collected here so they are not lost in the tables. Each is backed by the
lines given; none is fixed (this pass changes no code).

**RAM labels used under the wrong union member** (same address, other
meaning; candidates for scene-specific aliases like the 3b ones):
(all applied in batch 14, see "RAM mislabels applied"; the typo was
already fixed in 4d)

- `wCollectionRow` (= `wLCDCFlagsToFlip`, $d800) is written with $08 to
  flip the BG map: ten times in bank27 and in the epilogue's
  `_InitEpilogue`.
- `wPalFade7Colour3RedUnk1` / `wPalFade7Colour3RedSign` are used as
  `wCurTextBufferPage` / `wCurTextBufferLine` (bank2b_2.asm:2790-2848).
- `wCurOWPathTracer` holds the `_PrologueFade` type (bank21.asm).
- `wPalFade6Colour2Green*` hold the golf building scene's state, step and
  counter.
- The epilogue uses `wPalFade2Colour2GreenUnk1`, `wPalFade2Colour4GreenSign`
  and `wTempleRock5Action`/`Counter`; bank56 borrows `wTempleMusicBox*`,
  `wPlanePart2Counter` and `wPalFade2Colour3GreenUnk1`; Cutscene14 keeps
  pointers in `wPalFade1`; the best time list's autoscroll uses the
  collection labels; the east volcano scene uses `wSceneWarioMovementStep`
  and `wOWUIObj1State`.
- `VBlank_1ca056` reads `wGolfPinFlagTiles`, which is `wGolfCourseTileMap`
  in the golf union.
- `w2d121` is written but never read.
- Typo: `wGoldBuildingCourseAttrMap` (4d).

**Mislabeled "unreferenced"**:

- `Data_9ef82` is marked unreferenced, but Cutscene14 uses literal pointers
  into that data ($6e99, $6ee7, $6f33, $6f82, $6fe3, $7044). Fixed: they are
  `VolcanoEruptionWobbleLoop` (with `_Obj3Start`/`_Obj4Start`) and
  `VolcanoEruptionWobbleOnce_Obj2`..`4`, written with `LOW()`/`HIGH()`.
- `UnreferencedUpdateSceneObjAnim_ObjFramesets` is referenced
  (bank2b_1.asm:345, 352, 359).
- `Data_60ec9` (Kobatto's set movement) is also used from torch.asm code
  marked "unreferenced?" (4c).
- `Pals_84940`/`Pals_849c0` have no reference by name but are reached by
  indexing from `Pals_84900` (4c).

**Possible bugs or oddities**:

- Cutscene4c `.Func_9e52a` (bank27.asm:4541) compares `wSceneObj2State`
  with 3 and then advances unconditionally: a `ret nz` seems to be missing,
  so the compare does nothing.
- The `.data` table in `EOWFunc_FormCastle` has trailing bytes that decode
  as code.
- Plane part 2's `.Fall3` doesn't move the trailing object;
  `.move_arc3_2` duplicates another helper.
- In 4.0: two comma-list rows of the applied batches were applied as one
  name, and the "`Func_ad557` (duplicate of `Func_ae915`)" row was applied
  as a rename, so bank2b_1.asm:3222 defines `Func_ae915` at $ad557.

**Duplicates**: `Func_ce3e` vs home's `GetBlockPtrPos` (other corner of the
block); the bank20 duplicate routines (4a); `Data_60320` and `Data_60510`
(identical Y-velocity tables, 4c).

**Raw values**: raw `SCENEWARIO_*` numbers in the epilogue and the golf
building; the musical coin screen loads the golf menu's gfx and maps
(`GolfMenuGfx`, `GolfMenuTilemap`/`Attrmap`).

## Fifth pass

The address-named labels the four passes left (244 at the start of this
pass: 50 `Func_`, 20 `.Func_`, 5 `BlockFunc_`, 137 `Frameset_`, 17 `OAM_`,
5 `Pals_`, 10 `Data_`; `.asm_` jump labels not counted), mostly the low
rows. Each was checked again in the code: who references it (by name,
through a table, by a literal address or an index), what it does or
holds. Unlike the earlier passes, this one was applied as it went
(batches 15-17), so the tables use the names as they were in `src/`
before it.

Unreferenced data is named `Unreferenced<Owner><Kind>_<addr>` when the
owner shows in the data: a frameset's frame indices must fit the owner's
OAM table (checked against the `.frame_N` count in the symbol file), and
the framesets around it must be that owner's. Where the indices or the
sequence point to another owner than the fourth pass's neighbour guess,
the row says "Corrects". Literal addresses were searched for every
unreferenced data label (`$xxxx` and `ld r, $hi` / `ld r, $lo` pairs):
the hits are in the notes below.

239 renames: 230 address-named labels; 6 Jamano framesets and 1 movement
table that were named `Unreferenced...` but are used through literal
pointers; and the 2 swapped trampoline names. 52 high, 187 medium.

**Left as they are: 14 duplicate routines**, for the separate merge
decision: `Func_19246` (= `StartMultiBlockBreak`), `Func_19b5c` / `Func_19bce`
(both `call ProcessBlock / ld b, a / ret`), `Func_82a8d`, `Func_82c1d` /
`Func_82c22` / `Func_82c29` (bank20 copies of bank2d's `AdvanceOWFunc`,
`WaitOWFunc`, `EndOWFunc`), `Func_ac000` / `Func_ac00b` / `Func_ac016`
(identical credits-bank animation helpers), `Func_ac042` / `Func_ac047` /
`Func_ac04c` (identical `LoadOWSpriteWithScroll` wrappers), `Func_aca6d`
(= `AdvanceTempleOWStep`). `Func_ac051`, grouped with them before, has no twin and
is named.

### 5a. Routines (batch 15)

| Old | New | Evidence | Conf. |
|---|---|---|---|
| `Func_18064` | `BlockFunc_SlopeEnd` | Tail of `RightSlopeCollision`/`LeftSlopeCollision` (`jp Func_18064`): like `BlockFunc_Free`, but stores $10 in `wUnused_c18d` (free = 0, solid = 0/1). | medium |
| `Func_18078` | `UnreferencedBlockFunc_Result01` | No references; `BlockFunc_Free` with result $01 in `wUnused_c18d`, which nothing reads. | medium |
| `Func_1808c` | `BlockFunc_FreeEnvInteraction` | Tail of `BlockFunc_Ladder`, `LadderTopCollision`, `BlockFunc_Fence` after they set `wLadderInteraction`/`wIsNearFence`. Same effect as `BlockFunc_Free` (not byte-identical: one extra `xor a`). | medium |
| `BlockFunc_1809f` | `BlockFunc_AboveRightSlope` | Block tables put it one row (8 entries) above `BlockFunc_RightSlope` ($1b over $23); on `COLLISION_DOWN` it adds $10 to Y and runs `RightSlopeCollision`, i.e. treats the hit as the slope below. | high |
| `BlockFunc_180b5` | `BlockFunc_BelowRightSlope` | One row below `BlockFunc_RightSlope` ($2b under $23); subtracts $10 from Y and runs `RightSlopeCollision`; solid for `WST_ATTACKING_AIRBORNE`. | high |
| `BlockFunc_18129` | `BlockFunc_AboveLeftSlope` | Same as `BlockFunc_AboveRightSlope` for `LeftSlopeCollision` ($1c over $24). | high |
| `BlockFunc_1813f` | `BlockFunc_BelowLeftSlope` | Same as `BlockFunc_BelowRightSlope` for `LeftSlopeCollision` ($2c under $24). | high |
| `BlockFunc_182fe` | `BlockFunc_LadderRoomExit_ReloadObjects` | Ladder (`LADDER_COLLISION`) plus room transition `ROOMTRANSITION_5 | ROOMTRANSITIONF_RELOAD_OBJECTS`, like `BlockFunc_RoomExit_ReloadObjects` does with `ROOMTRANSITION_4`. | medium |
| `Func_1831a` | `UnreferencedBlockFunc_LadderRoomExit` | No references; the same without `ROOMTRANSITIONF_RELOAD_OBJECTS` (pairs like `BlockFunc_RoomExit`). | medium |
| `Func_18755` | `UnreferencedBlockFunc_Transition8Door` | No references; Up while touching (`COLLISION_ENV`) sets `ROOMTRANSITION_8 | ROOMTRANSITIONF_DOOR | ...RELOAD_OBJECTS | ...DELAY`, the door pattern of the neighbouring block functions. | medium |
| `Func_193dc` | `StartMultiBlockBreak_SolidUnlessRolling` | Stores the multi-block origin (`wMultiBlockOriginBank`/`Ptr`) like `StartMultiBlockBreak_Wario`, sets `wIsFloorTransition`, then `jp BreakBlock_SolidUnlessRolling`. | medium |
| `Func_19481` | `BreakBlock_Free` | Writes `b` to the block, `QueueBlockRedraw`, `BreakBlock`, `jp BlockFunc_Free`; the `BlockFunc_Free` twin of `BreakBlock_SolidUnlessRolling`. Used by `BonfireBlockCollision` and the yarn block. | high |
| `Func_20a69` | `SetObjAction_0D` | `ld b, OBJACTION_0D / call SetObjAction`; used by Food (when Wario can't eat it) and others. Named after the action, which is itself unnamed. | medium |
| `Func_20e6a` | `ObjInteraction_BumpOffAction0A` | Slot `OBJ_INTERACTION_0B`: `BumpOffObject`, then `OBJACTION_0A` unless `wTouchState`. Also the bump-off tail of `ObjInteraction_FrontStingBumpOff`/`TopStingBumpOff` and others (20 jumps). | medium |
| `Func_20fe8` | `UnreferencedSetObjAction_06` | No references; `ld b, OBJACTION_06 / jp SetObjAction`. | medium |
| `Func_21af1` | `ObjInteraction_SolidPlatform` | Slot `OBJ_INTERACTION_31` (Barrel 1, Hat Platform, GK Tortoise Platform): `ObjInteraction_Solid` except that from below it is `StepOnObject` instead of pushing Wario down. | medium |
| `Func_21cc9` | `SetObjAction_13` | `ld b, OBJACTION_13 / call SetObjAction`; tail of the drag-down interactions and `ShootBallWario`. | medium |
| `Func_21d6f` | `ObjInteraction_BottomStingSmashableTop` | Slot `OBJ_INTERACTION_48` (Anonster, Hidden Figure): from above smash-vanish (`JumpOffVanishingObject`) when smash attacking, from below `GetStungByObject`, otherwise `ObjInteraction_BumpOffAction0A`. | medium |
| `Func_21ea6` | `ObjInteraction_FrontPushBumpOff` | Slot `OBJ_INTERACTION_4F` (Hidden Figure): touching its front turns Wario away and `PushAgainstSolidObject`, otherwise `BumpOffObject_NoAction`. | medium |
| `Func_21f01` | `ObjInteraction_WaterKnockBackTopRight` | Slot `OBJ_INTERACTION_51` (Pesce, Strong Water Current): from above `SetState_SwimKnockBack` towards the right, otherwise `ObjInteraction_WaterKnockBack`. | medium |
| `Func_21f28` | `ObjInteraction_FrontStingSmashableTop` | Slot `OBJ_INTERACTION_52` (Hidden Figure): from above as `ObjInteraction_BottomStingSmashableTop`, from below bump off, front sting, back bump off. | medium |
| `.Func_4cbe8` | `.HoldCaughtWario` | `HiddenFigureFunc.Main` state 8, set by `.Grab` when `wHiddenFigureBodyGrabResult` is $80 (Wario caught) with a duration of $a0; when it runs out, clears `wAutoMoveState`. | medium |
| `Func_55407` | `UpdateJamanoDarkness` | Moves the darkness step (`wDollBoyHammerRange`, a Jamano union byte) up or down with `wJamanoSkullsInPlace`, alerts Jamano and loads `JamanoPals_*` (or black) into the BG palettes. | high |
| `Func_554bc` | `SetJamanoDarknessFrameset` | Writes a Jamano frameset pointer (by darkness step and facing bit 7) to the object at `hl`/`e`; the pointers were literals (`ld b, $5c / ld c, $xx`), now written with the frameset labels. | high |
| `.Func_456fe` | `.set_float` | `PneumoFunc` substates (low nybble, `.substate_table`): sets `PneumoFrameset_68c5c` and substate 1; target of every state's exit. | medium |
| `.Func_4570f` | `.Float` | Substates 0/1: bobs along `PneumoData_44000`; when Wario is below and close, every 64 frames goes to substate 6; at the table's end swoops (substate 3) if Wario is in range. | medium |
| `.Func_458c7` | `.Retreat` | Substate 2: rises along `PneumoData_60600` and moves sideways fast until its timer (27) ends. | medium |
| `.Func_4592e` | `.end_retreat` | End of `.Retreat`: clears the variable and `.set_float`. | medium |
| `.Func_457bd` | `.SwoopDown` | Substate 3: after its delay, sinks 2 px a frame (counting in var 1) while moving sideways, until the floor or Wario's height, then substate 4. | medium |
| `.Func_4585c` | `.Rise` | Substate 4: rises 2 px a frame back by var 1, moving sideways, until a ceiling or the timer; then `.set_float`. | medium |
| `.Func_45893` | `.UnusedMoveSideways` | Substate 5: moves sideways until its timer ends; nothing sets substate 5. | medium |
| `.Func_45934` | `.MoveToWarioY` | Substate 6: moves up/down towards Wario's Y (unless Puffy), `.start_retreat` on a ceiling. | medium |
| `.Func_4589d` | `.start_retreat` | Sets substate 2 facing away from Wario, `PneumoFrameset_68c8e`, timer 27; also when hit/touched. | medium |
| `.Func_49943` | `.Wait` | `SnakeFunc.Update` substates 0/1: count down, then substate 2 (timer $3e, `SFX_11A`). | medium |
| `.Func_49957` | `.Rise` | Substate 2: rises (carrying Wario with `MoveWarioUp` when stepped on) until the timer ends. | medium |
| `.Func_49984` | `.WaitAfterRise` | Substate 3: waits $53 frames, then on the right animation frame switches to `SnakeFrameset_68852`/`688c6` (substate 4). | medium |
| `.Func_499b8` | `.PrepareFire` | Substate 4: plays `SFX_08A`, waits $31 frames, then switches to the shooting frameset (substate 5). | medium |
| `.Func_499f8` | `.ShootFire` | Substate 5: spawns `ObjParams_SnakeFireLeft/Right` (`SFX_089`) when a slot is free. | medium |
| `.Func_49a57` | `.EndShooting` | Substate 6: count down, then substate 7 with `SnakeFrameset_688a9`/`6891d`. | medium |
| `.Func_49a7c` | `.StartSinking` | Substate 7: count down, then falls into `.start_sinking`. | medium |
| `.Func_49a85` | `.start_sinking` | Sets substate 8 and the idle frameset; also the target when hit. | medium |
| `.Func_49aa1` | `.Sink` | Substate 8: sinks (`SFX_08B`, carrying Wario down when stepped on) to the start Y in var 2, then waits $78 frames (substate 1). | medium |
| `.Func_49af0` | `.TurnToWario` | Called every frame by `.Update`: when Wario is within $28 px vertically, turns to face him (turn frameset for $14 frames), then restores the frameset. | medium |
| `Func_51c62` | `SetObjMapEntry7_YellowBelly` | `SetObjectMapEntryAndSpawn` with `e = 7` for the current object (as `ClearObjAndSetObjMapEntry7` in wolfenboss.asm), at the end of Yellow Belly's defeat. | medium |
| `Func_6303f` | `_ObjState_HopStart` | Slot `OBJSTATE_1A` (via the home trampoline): `OBJSTATE_1B`, var 3 = 0, duration 7. | medium |
| `Func_63050` | `_ObjState_Hop` | Slot `OBJSTATE_1B`: `ApplyObjHopYVel` while the duration runs, then `OBJSTATE_STANDING_FALL_START`. | medium |
| `Func_3263` | `ObjState_HopStart` | Home trampoline of `_ObjState_HopStart`; the `OBJSTATE_1A` entry of Count Richtertoffen's and Spearhead's tables. | medium |
| `Func_3272` | `ObjState_Hop` | Home trampoline of `_ObjState_Hop`; their `OBJSTATE_1B` entry. | medium |
| `Func_3308` | `ObjCheckFloorOrStandingFall` | `homejp _ObjCheckFloorOrStandingFall`. The label of that name was on the trampoline before it, which jumps to `ApplyObjHopYVel` (see the note below). | high |
| `ObjCheckFloorOrStandingFall`, `ApplyObjHopYVel` | `ApplyObjHopYVel`, `_ApplyObjHopYVel` | The home trampoline that does `homejp ApplyObjHopYVel` takes that name, and the bank routine the usual `_` prefix (applied first, so `Func_3308` could take the freed name). | high |
| `Func_1f357` | `SwimLeft` | Underwater D-pad left in `UpdateState_Swimming`: faces left (`WarioSwimFrameset_15576`) or `SwimForward`; the right-hand twin is the local `.asm_1f2c0`. | high |
| `Data_1f894` | `SwimDiagonalVertVelTable` | Vertical speed for swimming up/down while also holding left/right (`wSwimmingDirectionInput`); `SwimDiagonalVelTable` is the horizontal one. | high |
| `Func_2afc5` | `OnFireBounceOffWall` | On Fire Wario hitting a wall: turns around, steps back 3 px, sets the on-fire frameset; also from object_interactions.asm's `.hot` case, next to `BallOStringBounceOffWall`. | high |
| `Func_2b42b` | `UpdateCrazyWalk` | Called from `HandleCrazyInput`: advances `wWalkVelIndex` and staggers Crazy Wario 1-2 px with wall checks and dust particles. | medium |
| `Func_1edaca` | `LandFromBallStart` | End of `UpdateState_BallStart` (and `SetState_BallStart` when grounded): `SetState_BallTurning` if pushing against the facing, else `SetState_BallBouncing`. | medium |
| `Func_1edaf8` | `LandFromBallAirborne` | The same after `UpdateState_BallAirborne` lands, with the airborne framesets. | medium |
| `Func_1a12a` | `SetWarioSandAirborneAnimation` | Tail of `SetState_SandFalling`/`SetState_SandJumping`: airborne gfx and `WarioOAM_15955`, then the frameset. | medium |
| `Func_1a14b` | `SetWarioSandAirborneFrameset` | Sets `WarioAirborneFrameset_15f94`/`WarioBlindFrameset_15f97` by direction; also when turning in sand. | medium |
| `Func_8143d` | `UnreferencedPathPreviewFromLevel` | No references; runs one path preview step (`.RunTracerStep`) from the current level's coordinates, saving and restoring Wario's. | medium |
| `Func_1c8f56` | `IsGolfXPosOnScreen` | Returns TRUE when `de` is within -$20..+$b0 of `wGolfXScroll` (its comment); used to put golf Wario at the edge when he is off screen. | medium |
| `Func_7cf` | `UnreferencedFadeToTargetRGB` | No references; for $20 frames, raises every colour component of the palettes in `wTempPals1` (and the $c1xx copy) by one towards `wTargetRed/Green/Blue`, then restores the VBlank function. | medium |
| `Func_309b6` | `AudioMod_Release` | `AUDIOMOD_UNK` (now `AUDIOMOD_RELEASE`) slot of `AudioModFunctionTable`: `AudioModSetValue_Long` on `CHANNEL_RELEASE_VOLUME` and the next byte, `CHANNEL_RELEASE_LENGTH` (the field names are now settled). | high |
| `Func_ac051` | `LoadSceneObjSprite_CreditsOAM` | `ld b, BANK("Credits OAM") / jp LoadOWSprite`; unlike its neighbours it has no duplicate. | high |

### 5b. Referenced data and literal pointers (batch 16)

| Old | New | Evidence | Conf. |
|---|---|---|---|
| `OAM_1426c` | `WarioWalkOAM_1426c` | Always loaded with `WarioWalkGfx` (walk, grab, crouch, bump framesets follow it). | high |
| `Frameset_149b4` | `WarioWalkFrameset_149b4` | Left walk in `SetWarioWalkAnimation` (`WarioFrameset_149c5` is the right one). | high |
| `Frameset_14a76` | `WarioBumpFrameset_14a76` | `BumpOffObject`'s frameset for one side, next to `WarioBumpFrameset_14a79`. | high |
| `Frameset_15f94` | `WarioAirborneFrameset_15f94` | Frame 15 of `WarioOAM_15955` (airborne gfx), facing left; `WarioBlindFrameset_15f97` faces right. | high |
| `Frameset_68a00` | `ApplebyFrameset_68a00` | Only user: `ApplebyFunc.Hidden` (appear). | high |
| `Frameset_68f6b` | `SunMoonFrameset_68f6b` | Only user: sun_moon.asm (`SunFunc`). | high |
| `OAM_15e44a` | `PrologueSceneObjOAM_15e44a` | The prologue scene objects' OAM (`UpdatePrologueSceneObj.draw`); the `PrologueSceneObjFrameset_*` follow it. Also the temple scene (`UpdateTempleSceneObjAnimation.draw_1`, see the mislabel note) and the credits music box close-up. | medium |
| `Frameset_15e796` | `PrologueSceneObjFrameset_15e796` | In the prologue frameset run, used by `UpdatePrologueSceneObj.State11` and the temple's `.State02`. | medium |
| `Frameset_15e7ed` | `PrologueSceneObjFrameset_15e7ed` | `UpdatePrologueSceneObj.State0d` and the credits close-up (music box). | medium |
| `Pals_d1fe` | `ParticlePals_d1fe` | Loaded into OB palette 2 on every room start; `ParticleOAM_d20e`, right after it, draws most tiles with palette 2. | medium |
| `Data_603f0` | `SmashedYVel` | Futamogu and Webber, when ground-smashed without `SUPER_JUMP_SLAM_OVERALLS`: pushed down 9 px. | medium |
| `Data_60490` | `SuperSmashedYVel` | The same with Super Jump Slam Overalls: 65 px. | medium |
| `Data_604c0` | `HoverYVel` | Looped (`ApplyObjYMovement_Loop`) +5/-5 px bob over 32 frames: Omodonmeka, Pesce, Wolfenboss, Teruteru. | medium |
| `Data_605e0` | `DelayedFallYVel` | 12 frames still, then accelerating to 5 px/frame: Stove `.Fall`, Omodon `.fall`. | medium |
| `Data_60650` | `JitterXVel` | Applied with `ApplyObjXMovement_Loop` (X, not Y): 1 px left/right jitter over 32 frames (Omodonmeka, Wolfenboss). | medium |
| `Pals_b8200` | `SharedCutsceneBGPals_b8200` | BG palettes (`LoadFarPalsToTempPals1`) of many cutscenes (20 uses), next to `SharedCutsceneBGPals_b8040`/`b8240`. | high |
| `OAM_a8000` | `NorthOWObjOAM_a8000` | `DrawNorthOWObj`; the `NorthOWObjFrameset_*` follow it. | high |
| `OAM_a9161` | `SouthOWObjOAM_a9161` | `DrawSouthOWObj`, `SouthOWObjState1a`; `SouthOWObjFrameset_*` follow. | high |
| `OAM_a980c` | `EastOWObjOAM_a980c` | `DrawEastOWObj`; `EastOWObjFrameset_*` follow. | high |
| `OAM_a9fe2` | `TopBarOAM_a9fe2` | Top bar sprites (`DrawTopBarSelectionSprite`...) and `AnimateNorthOWObj2` with `TopBarFrameset_*`, which follow it. | high |
| `OAM_aa0cf` | `OWUIOAM_aa0cf` | Overworld UI sheet: treasure icons 0-3 and empty slot 9 (`DrawBottomBar`), arrows 4 (`SetOWWarioOAM`), path tracers 5-8, digits 30-39 (`DrawBottomBarTimeAttackScore`), via `LoadSpriteInsideWindow`; also `NorthOWObjState24`. | medium |
| `OAM_aa329` | `OWWarioOAM_aa329` | `SetOWWarioOAM` for the four directions; `OWWarioFrameset_aa405`.. follow. | high |
| `OAM_aa445` | `LevelStarOAM_aa445` | `DrawUnlockLevelStar` / `DrawHighlightLevelStar`. | high |
| `Frameset_aa544` | `UnlockLevelStarFrameset_aa544` | `DrawUnlockLevelStar`. | high |
| `Frameset_aa555` | `HighlightLevelStarFrameset_aa555` | `DrawHighlightLevelStar`. | high |
| `OAM_aa580` | `CompassOAM_aa580` | `LoadCompassSprite` (frames 0-3, one per map side, from `SetCompassSprite`); frames 4-6 are the bottom bar button prompts (`DrawBottomBarButtonPrompt`), also drawn by `AnimateNorthOWObj3`. | medium |
| `OAM_bc000` | `CutsceneOverlayOAM_bc000` | `LoadCutsceneOverlaySprite` / `DrawCutsceneOverlayFrame0`-`6`. | high |
| `OAM_75c3` | `LanguageSelectionOAM_75c3` | Loaded by language_selection/load_oam.asm (`LanguageSelectionFrameset_76b5`); frames 1-4 are also the text arrow. | medium |
| `Frameset_76ca` | `TextArrowFrameset_76ca` | `SceneObjState_TextArrow`. | high |
| `OAM_1e6bab` | `ActionHelpEnemyOAM_1e6bab` | The action help demos' enemies: Para-Goom, Count Richtertoffen, Futamogu framesets follow it (`ActionHelpParaGoomWalkFrameset`...). | medium |
| `Pals_1e4eef` | `ActionHelpBlackedOutBGPals` | `BlackOutActionHelpBGPals` (sets `wActionHelpBlackedOut`) and `LoadActionHelpCommonPals`: mostly black. | high |
| `Pals_1e4f2f` | `ActionHelpOBPals` | `LoadActionHelpOBPals`, main power-up palettes, power-up icon palettes 4 and 7. | high |
| `OAM_184ab2` | `MadSciensteinOAM_184ab2` | Mad Scienstein, his Invisibility Potions (`MadSciensteinFrameset_68c33`) and the Seeing-Eye Door. | medium |
| `OAM_188000` | `BrrrBearOAM_188000` | Brrr Bear and the Tadpole Spawner. | medium |
| `OAM_18c000` | `ChestsOAM_18c000` | Chests (the `ChestsFrameset_*` at the start of object_framesets.asm), keys, treasures, the musical coin, stars (`SetObjStarsSprite`), Muddee's stinger. | medium |
| `OAM_190000` | `AnonsterOAM_190000` | Anonster's silk, waves and silk platforms; also the fly/dragonfly spawners and Brrr Bear's snowflakes. | medium |
| `UnreferencedJamanoFrameset_69c25` | `JamanoFrameset_69c25` | Referenced by literal pointer in `SetJamanoDarknessFrameset` (`ld b, $5c / ld c, $25`), now written as `HIGH`/`LOW` of the label. | high |
| `UnreferencedJamanoFrameset_69c2e` | `JamanoFrameset_69c2e` | Same ($5c2e). | high |
| `UnreferencedJamanoFrameset_69c37` | `JamanoFrameset_69c37` | Same ($5c37). | high |
| `UnreferencedJamanoFrameset_69caa` | `JamanoFrameset_69caa` | Same ($5caa). | high |
| `UnreferencedJamanoFrameset_69cb3` | `JamanoFrameset_69cb3` | Same ($5cb3). | high |
| `UnreferencedJamanoFrameset_69cbc` | `JamanoFrameset_69cbc` | Same ($5cbc). | high |
| `UnreferencedSpearheadData_601d0` | `CountRichtertoffenData_601d0` | Count Richtertoffen's picked-up offsets (left): `.PickedUpLeftStart` stores $41d0 in `OBJ_VAR_3`/`OBJ_VAR_2` as literals, the way Spearhead stores `SpearheadData_601c0`; now `HIGH`/`LOW` of the label. | high |
| `Data_601f0` | `CountRichtertoffenData_601f0` | Same for `.PickedUpRightStart` ($41f0); the first row is used, the rest of the table is not. | high |

### 5c. Unreferenced data (batch 17)

| Old | New | Evidence | Conf. |
|---|---|---|---|
| `Frameset_149d6` | `UnreferencedWarioWalkFrameset_149d6` | Follows `WarioWalkOAM_1426c` among its framesets; frame indices fit its 64 frames. Frame 2, a single frame of the left walk (`WarioWalkFrameset_149b4`). | medium |
| `Frameset_149d9` | `UnreferencedWarioWalkFrameset_149d9` | Follows `WarioWalkOAM_1426c` among its framesets; frame indices fit its 64 frames. Frame 6, of the right walk. | medium |
| `Frameset_149dc`, `Frameset_149ed`, `Frameset_14a3e`, `Frameset_14a4f`, `Frameset_14a60`, `Frameset_14a63`, `Frameset_14a66`, `Frameset_14a69` | `UnreferencedWarioFrameset_149dc`, `UnreferencedWarioFrameset_149ed`, `UnreferencedWarioFrameset_14a3e`, `UnreferencedWarioFrameset_14a4f`, `UnreferencedWarioFrameset_14a60`, `UnreferencedWarioFrameset_14a63`, `UnreferencedWarioFrameset_14a66`, `UnreferencedWarioFrameset_14a69` | Follows `WarioWalkOAM_1426c` among its framesets; frame indices fit its 64 frames. Frames 8-23 and 40-55, used by no referenced frameset. | medium |
| `Frameset_14a7c` | `UnreferencedWarioBumpFrameset_14a7c` | Follows `WarioWalkOAM_1426c` among its framesets; frame indices fit its 64 frames. Single frame 60, continuing `WarioBumpFrameset_14a76`/`14a79` (58/59). | medium |
| `Frameset_14a7f` | `UnreferencedWarioBumpFrameset_14a7f` | Follows `WarioWalkOAM_1426c` among its framesets; frame indices fit its 64 frames. Single frame 61. | medium |
| `Frameset_16732`, `Frameset_16737` | `UnreferencedWarioSlidFrameset_16732`, `UnreferencedWarioSlidFrameset_16737` | After `WarioSlidFrameset_1671d`, before the next OAM; indices fit `WarioOAM_1644a` (28 frames). | medium |
| `Frameset_17e59`, `Frameset_17e78` | `UnreferencedWarioTurningInvisibleFrameset_17e59`, `UnreferencedWarioTurningInvisibleFrameset_17e78` | After `WarioTurningInvisibleFrameset_17e3a`, end of the file; indices fit `WarioTurningInvisibleOAM_17cf7` (12 frames). | medium |
| `Frameset_1fcccc` | `UnreferencedWarioBouncyFrameset_1fcccc` | After `WarioBouncyFrameset_1fccbf`; fits `WarioBouncyStartOAM_1fc95e` (27 frames). | medium |
| `Frameset_1fcfde`, `Frameset_1fcfef`, `Frameset_1fd000` | `UnreferencedWarioCrazyFrameset_1fcfde`, `UnreferencedWarioCrazyFrameset_1fcfef`, `UnreferencedWarioCrazyFrameset_1fd000` | After `WarioCrazyTurningFrameset_1fcfd7`; fits `WarioCrazyOAM_1fccd5` (19 frames). | medium |
| `Frameset_1fd429`, `Frameset_1fd45c` | `UnreferencedWarioBatFrameset_1fd429`, `UnreferencedWarioBatFrameset_1fd45c` | Among the `WarioBat*` framesets after `WarioOAM_1fd031` (31 frames). | medium |
| `Frameset_1fd837`, `Frameset_1fd848`, `Frameset_1fd851`, `Frameset_1fd85a`, `Frameset_1fd85d`, `Frameset_1fd860`, `Frameset_1fd869`, `Frameset_1fd872`, `Frameset_1fd877` | `UnreferencedWarioVampireFrameset_1fd837`, `UnreferencedWarioVampireFrameset_1fd848`, `UnreferencedWarioVampireFrameset_1fd851`, `UnreferencedWarioVampireFrameset_1fd85a`, `UnreferencedWarioVampireFrameset_1fd85d`, `UnreferencedWarioVampireFrameset_1fd860`, `UnreferencedWarioVampireFrameset_1fd869`, `UnreferencedWarioVampireFrameset_1fd872`, `UnreferencedWarioVampireFrameset_1fd877` | Among the `WarioVampire*` framesets; fits `WarioVampireOAM_1fd498` (28 frames). | medium |
| `Frameset_1ff988`, `Frameset_1ff9cd` | `UnreferencedWarioSnowballFrameset_1ff988`, `UnreferencedWarioSnowballFrameset_1ff9cd` | After `WarioSnowballCrashFrameset_1ff981`; fits `WarioSnowballOAM_1ff64a` (23 frames). | medium |
| `Frameset_1dccd2`, `Frameset_1dccd5` | `UnreferencedWarioPuffyFrameset_1dccd2`, `UnreferencedWarioPuffyFrameset_1dccd5` | Between `WarioPuffyInflatingFrameset_1dccc9` and `WarioPuffyTurningFrameset_1dccd8`; fits `WarioPuffyInflatingOAM_1dc93f` (27 frames). | medium |
| `Frameset_1dd23b`, `Frameset_1dd26f`, `Frameset_1dd2a0`, `Frameset_1dd2dc`, `Frameset_1dd2e9`, `Frameset_1dd2f9`, `Frameset_1dd306` | `UnreferencedWarioBallFrameset_1dd23b`, `UnreferencedWarioBallFrameset_1dd26f`, `UnreferencedWarioBallFrameset_1dd2a0`, `UnreferencedWarioBallFrameset_1dd2dc`, `UnreferencedWarioBallFrameset_1dd2e9`, `UnreferencedWarioBallFrameset_1dd2f9`, `UnreferencedWarioBallFrameset_1dd306` | Among the `WarioBall*` framesets; fits `WarioBallStartOAM_1dcff1` (25 frames). | medium |
| `Frameset_d4e23` | `UnreferencedGolfWarioFrameset_d4e23` | data/golf/framesets.asm follows data/golf/oam.asm (`GolfWarioOAM_d49cc`, 28 frames); frame 9. | medium |
| `Frameset_1c8e21` | `UnreferencedGolfParaGoomFrameset_1c8e21` | Right after `UpdateGolfParaGoom`'s frameset table; frames 35 and 32 are Para-Goom frames of `GolfHoleFrameset_1cafb6` (28-35). | medium |
| `Frameset_d4ce`, `Frameset_d4d5`, `Frameset_d4dc`, `Frameset_d4e3`, `Frameset_d514`, `Frameset_d519`, `Frameset_d51c`, `Frameset_d51f`, `Frameset_d522` | `UnreferencedParticleFrameset_d4ce`, `UnreferencedParticleFrameset_d4d5`, `UnreferencedParticleFrameset_d4dc`, `UnreferencedParticleFrameset_d4e3`, `UnreferencedParticleFrameset_d514`, `UnreferencedParticleFrameset_d519`, `UnreferencedParticleFrameset_d51c`, `UnreferencedParticleFrameset_d51f`, `UnreferencedParticleFrameset_d522` | Among the `Particle*Frameset`s; indices fit `ParticleOAM_d20e` (60 frames). | medium |
| `Pals_d206` | `UnreferencedParticlePals_d206` | Right after `ParticlePals_d1fe`, same first colour, before `ParticleOAM_d20e`. | medium |
| `Frameset_15e95f`, `Frameset_15e962`, `Frameset_15e965`, `Frameset_15e968`, `Frameset_15e96b`, `Frameset_15e974` | `UnreferencedTempleSceneObjFrameset_15e95f`, `UnreferencedTempleSceneObjFrameset_15e962`, `UnreferencedTempleSceneObjFrameset_15e965`, `UnreferencedTempleSceneObjFrameset_15e968`, `UnreferencedTempleSceneObjFrameset_15e96b`, `UnreferencedTempleSceneObjFrameset_15e974` | End of the temple scene object framesets (`TempleSceneObjFrameset_15e95c`), whose indices (up to 52) are frames of `HiddenFigureOAM_18c88a` (54), drawn by `UpdateTempleSceneObjAnimation.animate_and_draw_3`, not of `TempleSceneObjOAM_15e813` (10). | medium |
| `Frameset_aa255`, `Frameset_aa258`, `Frameset_aa25b` | `UnreferencedOWUIFrameset_aa255`, `UnreferencedOWUIFrameset_aa258`, `UnreferencedOWUIFrameset_aa25b` | Follows `OWUIOAM_aa0cf`; frames 1-3 are the red/green/blue treasure icons of `DrawBottomBar` (frame 0, grey, is `NorthOWObjFrameset_aa252`). | medium |
| `Frameset_aa26d` | `UnreferencedOWUIFrameset_aa26d` | Frame 9 of `OWUIOAM_aa0cf`: the empty treasure slot of `DrawBottomBar`. | medium |
| `Frameset_aa270`, `Frameset_aa2a9`, `Frameset_aa2b2` | `UnreferencedOWUIFrameset_aa270`, `UnreferencedOWUIFrameset_aa2a9`, `UnreferencedOWUIFrameset_aa2b2` | Between the path preview and bottom bar framesets of `OWUIOAM_aa0cf`; animations of frames 10-23, which nothing else uses. | medium |
| `Frameset_aa308`, `Frameset_aa30b`, `Frameset_aa30e`, `Frameset_aa311`, `Frameset_aa314`, `Frameset_aa317`, `Frameset_aa31a`, `Frameset_aa31d`, `Frameset_aa320`, `Frameset_aa323` | `UnreferencedOWUIDigitFrameset_aa308`, `UnreferencedOWUIDigitFrameset_aa30b`, `UnreferencedOWUIDigitFrameset_aa30e`, `UnreferencedOWUIDigitFrameset_aa311`, `UnreferencedOWUIDigitFrameset_aa314`, `UnreferencedOWUIDigitFrameset_aa317`, `UnreferencedOWUIDigitFrameset_aa31a`, `UnreferencedOWUIDigitFrameset_aa31d`, `UnreferencedOWUIDigitFrameset_aa320`, `UnreferencedOWUIDigitFrameset_aa323` | Frames 30-39 of `OWUIOAM_aa0cf`, the digits drawn by `DrawBottomBarTimeAttackScore` (`$1e` + digit), one frameset each. | medium |
| `Frameset_aa326` | `UnreferencedOWUIFrameset_aa326` | Frame 40 of `OWUIOAM_aa0cf`, after the digits. | medium |
| `Frameset_aa5e9`, `Frameset_aa5ec`, `Frameset_aa5ef`, `Frameset_aa5f2` | `UnreferencedCompassFrameset_aa5e9`, `UnreferencedCompassFrameset_aa5ec`, `UnreferencedCompassFrameset_aa5ef`, `UnreferencedCompassFrameset_aa5f2` | Follows `CompassOAM_aa580`; frames 0-3, the compass for each map side. | medium |
| `Frameset_aa5fb` | `UnreferencedNorthOWObjFrameset_aa5fb` | Frame 6 of `CompassOAM_aa580`, after `NorthOWObjFrameset_aa5f5`/`aa5f8` (frames 4, 5). | medium |
| `Frameset_bc10d`, `Frameset_bc110`, `Frameset_bc113`, `Frameset_bc116`, `Frameset_bc119`, `Frameset_bc11c`, `Frameset_bc11f` | `UnreferencedCutsceneOverlayFrameset_bc10d`, `UnreferencedCutsceneOverlayFrameset_bc110`, `UnreferencedCutsceneOverlayFrameset_bc113`, `UnreferencedCutsceneOverlayFrameset_bc116`, `UnreferencedCutsceneOverlayFrameset_bc119`, `UnreferencedCutsceneOverlayFrameset_bc11c`, `UnreferencedCutsceneOverlayFrameset_bc11f` | Right after `CutsceneOverlayOAM_bc000`, one frameset per each of its 7 frames (the overlay is drawn frame by frame, without framesets). | high |
| `Data_82026` | `UnreferencedCompassCoords` | Right after `SetCompassSprite.coords` (`$14, $14`): three more y/x pairs, as for the other map sides; the routine only copies the first pair. | medium |
| `Data_60340` | `UnreferencedWaveYVel_60340` | Y-velocity table among the object movement tables ($80-terminated), a long down-up wave. | medium |
| `Data_60400` | `UnreferencedWaveYVel_60400` | Same, starting upwards. | medium |
| `Frameset_68065` | `UnreferencedChestsFrameset_68065` | Among the `ChestsOAM_18c000` framesets (chests, key, stinger, stars); frames 18-23, used by no other frameset. | medium |
| `Frameset_6807f`, `Frameset_6808e` | `UnreferencedStarsFrameset_6807f`, `UnreferencedStarsFrameset_6808e` | Frames 30-36 of `ChestsOAM_18c000`, the stars' frames (`StarsFrameset_680a5` uses 30-33, 37-40), not the stinger's (24-29). Corrects the fourth pass's `UnreferencedMuddeeStinger`. | medium |
| `Frameset_6869b` | `UnreferencedKushimushiFrameset_6869b` | After `KushimushiFrameset_68698` (frame 24); frames 25-27 fit `KushimushiOAM_18160c` (28). | medium |
| `Frameset_68a92` | `UnreferencedBarrelFrameset_68a92` | After the Barrel framesets; frames 4, 10-14 fit `BarrelOAM_181b0f` (15). | medium |
| `Frameset_68cde`, `Frameset_68ce7`, `Frameset_68cf0`, `Frameset_68cf7`, `Frameset_68cfe`, `Frameset_68d03`, `Frameset_68d08`, `Frameset_68d11` | `UnreferencedZombieFrameset_68cde`, `UnreferencedZombieFrameset_68ce7`, `UnreferencedZombieFrameset_68cf0`, `UnreferencedZombieFrameset_68cf7`, `UnreferencedZombieFrameset_68cfe`, `UnreferencedZombieFrameset_68d03`, `UnreferencedZombieFrameset_68d08`, `UnreferencedZombieFrameset_68d11` | Before the Zombie framesets; indices up to 24 exceed `ElectricLampOAM_184eeb` (21 frames) and fit `ZombieOAM_184ffa` (31), and they pair on frames 0/4, Zombie's two facings (`ZombieFrameset_68d24`). Corrects the fourth pass's `UnreferencedElectricLamp`. | medium |
| `Frameset_68efd`, `Frameset_68f04` | `UnreferencedBeamBotFrameset_68efd`, `UnreferencedBeamBotFrameset_68f04` | Same frames as `BeamBotFrameset_68ea3` / `68eaa` (11,10,0 / 13,12,3). | high |
| `Frameset_69060` | `UnreferencedHandFrameset_69060` | Strings Hand sequences together: 11,12,13,10 (as `HandFrameset_690ab`), 0-6, then `HandFrameset_690c9`'s 7,8,9,19,20,8,7,21,22; Kobatto has only 9 frames. Corrects the fourth pass's `UnreferencedKobatto`. | high |
| `Frameset_69382`, `Frameset_6938d`, `Frameset_69398`, `Frameset_693a3`, `Frameset_693ae`, `Frameset_693b9` | `UnreferencedOwlFrameset_69382`, `UnreferencedOwlFrameset_6938d`, `UnreferencedOwlFrameset_69398`, `UnreferencedOwlFrameset_693a3`, `UnreferencedOwlFrameset_693ae`, `UnreferencedOwlFrameset_693b9` | After `OwlFrameset_69377`; frames 29-55 fit `OwlOAM_188e16` (56). | medium |
| `Frameset_69608` | `UnreferencedFlameBlockFrameset_69608` | After the Flame Block framesets; frames 2/3 of `FlameBlockOAM_1895ec`. | medium |
| `Frameset_698a5` | `UnreferencedClearGateFrameset_698a5` | Frame 0 for 100 frames, the same shape as the next `ClearGateFrameset_698a8`/`698ab` (frames 1, 2). Corrects `UnreferencedYellowBelly`. | medium |
| `Frameset_69a42`, `Frameset_69a47`, `Frameset_69a4c`, `Frameset_69a51`, `Frameset_69a58` | `UnreferencedTadpoleFrameset_69a42`, `UnreferencedTadpoleFrameset_69a47`, `UnreferencedTadpoleFrameset_69a4c`, `UnreferencedTadpoleFrameset_69a51`, `UnreferencedTadpoleFrameset_69a58` | After `TadpoleFrameset_69a3d`; frames 8-14 fit `TadpoleOAM_18a642` (15). | medium |
| `Frameset_69b91` | `UnreferencedOctohonFrameset_69b91` | After the Octohon framesets; frames 0/9 are Octohon's facings (`OctohonFrameset_69b2f`/`69b57`). | medium |
| `Frameset_69be2`, `Frameset_69bf5` | `UnreferencedSparkFrameset_69be2`, `UnreferencedSparkFrameset_69bf5` | After `SparkFrameset_69bd9`; frames up to 7 fit `SparkOAM_18ab04` (8), not Rock's (4). | medium |
| `Frameset_69ec3`, `Frameset_69ed6`, `Frameset_69ee9`, `Frameset_69efc`, `Frameset_69f0f`, `Frameset_69f22` | `UnreferencedShootFrameset_69ec3`, `UnreferencedShootFrameset_69ed6`, `UnreferencedShootFrameset_69ee9`, `UnreferencedShootFrameset_69efc`, `UnreferencedShootFrameset_69f0f`, `UnreferencedShootFrameset_69f22` | Walk cycles 0-8 and 9-17, Shoot's left/right frame sets (`ShootFrameset_6a022`.. `6a04f`, facings 0/9 in `ShootFrameset_69f35`); Wolfenboss faces with 0/2. Directly before the Shoot framesets. Corrects `UnreferencedWolfenboss`. | medium |
### Findings of the fifth pass

**Wrong names fixed (ROM unchanged):**

- The home trampolines `ObjCheckFloorOrStandingFall` and `Func_3308` had
  their names one label off: the label called `ObjCheckFloorOrStandingFall`
  did `homejp ApplyObjHopYVel`, and `Func_3308` did
  `homejp _ObjCheckFloorOrStandingFall`. Now the first is
  `ApplyObjHopYVel` (the bank routine became `_ApplyObjHopYVel`, the usual
  home/bank pair) and `Func_3308` is `ObjCheckFloorOrStandingFall`. The
  nine objects that `jp nz` to the first one after a 7-frame duration
  (`.State40` in count_richtertoffen.asm and others) are doing the hop,
  like `_ObjState_Hop`.
- `UpdateTempleSceneObjAnimation.draw_1` named `WarioOAM_1644a` (bank $05),
  but `Func_ac042` loads from the Credits OAM bank, where $644a is the
  prologue scene object OAM (`PrologueSceneObjOAM_15e44a`). A scan of every
  `ld de, X` before a fixed-bank sprite or animation wrapper found no other
  case.

**Mislabeled "unreferenced" (literal pointers, now labels):**

- `SetJamanoDarknessFrameset` (was `Func_554bc`) loads its eight frameset
  pointers as `ld b, $5c / ld c, $xx`; six of the framesets were
  `UnreferencedJamanoFrameset_*`.
- Count Richtertoffen's `.PickedUpLeftStart` / `.PickedUpRightStart` store
  $41d0 / $41f0 in `OBJ_VAR_3`/`OBJ_VAR_2`, the picked-up offset tables
  that were `UnreferencedSpearheadData_601d0` and `Data_601f0`.

**Fourth-pass owner guesses corrected** (5c): `Frameset_69060` (Hand, not
Kobatto), `Frameset_68cde`..`68d11` (Zombie, not Electric Lamp),
`Frameset_69ec3`..`69f22` (Shoot, not Wolfenboss), `Frameset_6807f` /
`6808e` (stars, not Muddee's stinger), `Frameset_698a5` (Clear Gate, not
Yellow Belly). The temple's framesets, called `TempleSceneObjFrameset_*`,
index `HiddenFigureOAM_18c88a`, not `TempleSceneObjOAM_15e813`.

**Oddities, not changed:**

- Pneumo's substate 5 (`.UnusedMoveSideways`) is in its jumptable but
  nothing sets it.
- `wDollBoyHammerRange` is Jamano's darkness step, and
  `wDollBoyActiveBarrels` is used by Omodonmeka and Pesce: more union
  mislabels for the RAM work.
- `SwimDiagonalVelTable` holds the same bytes as `SwimStraightVelTable`.
- `SetCompassSprite` copies only the first y/x pair; the three after it
  (`UnreferencedCompassCoords`) are the same values.
- `BlockFunc_FreeEnvInteraction` behaves like `BlockFunc_Free` (an extra
  `xor a`), and the result values the block functions store in
  `wUnused_c18d` ($00, $01, $10) are never read.
- The constants `AUDIOMOD_UNK`, `OBJSTATE_1A`/`1B` and `OBJ_INTERACTION_31`,
  `48`, `4F`, `51`, `52` could now take names from their handlers
  (release, hop start/hop, solid platform...).

## Sixth pass: remaining RAM labels

Branch `claude/ram-rest-dh93t5`. Every address-named label in `src/ram/`
is gone (a grep for `w[0-9]?[0-9a-f]{3,5}` finds nothing in `src/`). No
address moved: the ROM is byte-identical and the `.sym` file only gains
labels (struct fields now also name the unreferenced bytes `$d128`,
`$d131`, `$d136`, `$d137`) and loses the old ones. `wd156` had no use left
(batch 14 moved its readers to `wOWUIObj3`); its `ds $2` stays unlabelled.

| Old | New | Evidence |
|---|---|---|
| `w1dc21` | `wGolfWarioSnapToEdge` | Set by `GolfHoleState_Walk` (golf/hole.asm:2249). `UpdateGolfWario` (hole.asm:680-728): while Wario is off screen (`IsGolfXPosOnScreen`) and it is set, it clears it and puts him at scroll - 10 px or scroll + 170 px depending on `wGolfWarioDir`, i.e. just outside the edge he walks in from; once he is on screen it is cleared. |
| `w2d07c` | `wOWIsNightTarget` | `wOWIsNight` on init (overworld/init.asm:256), 1 in `.InitDayToNight`, 0 in `.InitNightToDay` (bank21.asm:23, :203), both before `.SwitchDayNight` changes `wOWIsNight`. Read only by `MoveSouthOWObj14Diagonally` (bank2d.asm:8833) to pick the object's day or night path. |
| `w2d07d` | `wSouthOWObj14MoveStarted` | Cleared with the above (init.asm:258, bank21.asm:25, :204); `MoveSouthOWObj14Diagonally` (bank2d.asm:8841-8886) resets the object's position once (night path) or just sets it (day path) the first time it runs after a change. |
| `w2d0ee` / `w2d0ef` | `wOWLevelTimeAttackScore` = `wOWLevelTimeAttackMinutes` / `wOWLevelTimeAttackSeconds` | `GetLevelTimeAttackScore` (bank26.asm:1306) copies `wOWLevel`'s entry of `wLevelTimeAttackScores` (minutes byte, seconds byte, BCD, as commented there); `DrawBottomBarTimeAttackScore` (bank20.asm:4623) draws the two pairs of digits with a gap between them. |
| `w2d122`..`w2d13f` | `wSceneObjScripts`: `wSceneObj1Script`..`wSceneObj15Script` (`scene_obj_script_struct`: `Step`, `Counter`) | Pair N belongs to `wSceneObjN` in every scene that uses one: the volcano's left/right/middle rocks are objects 1/3/6 with pairs 1/3/6 (bank2d.asm:4424-4620), the fan's two winds objects 1/2 with pairs 1/2 (:6121), the leaves objects 6/7/8/9 with pairs 6/7/8/9 (:2690-2990, `InitNOWObjects_FallLeaves`), the final scene's objects 10/12/13/14/15 with pairs 10/12/13/14/15 (:7833-8035), the map objects that react to Wario (north object 2, west object 5, south object 7, :8442, :8590, :8774) and `EastOWObj5IdleTimer` (:8724) with their own pairs, the rain clouds (object 15) with pair 15 (:3668), `EOWFunc_BurnVines` object 1 with pair 1 (:8112). The first byte is a 1-based jumptable index (0 = inactive) and the second a counter, cleared when the step advances (`xor a / ld [hld], a / inc [hl]`). Exceptions, which the names don't cover: `.MoveObj1` (:6836) keeps its step in `wSceneObj1MovementStep` and counts in `wSceneObj1ScriptStep`; `SOWFunc_MagicSeed`'s `.MoveSeeds` (:5408) uses the `Counter` bytes of objects 2-4 as on/off flag plus curve index; `SOWFunc_CanyonThunder`'s `.UpdateBarrage` (:5782) runs in object 2's pair but moves objects 1, 2 and 10. |
| `w2d150` / `w2d151` (bank2b_2) | `wSceneWarioPalCycleStep` / `wSceneWarioPalCycleCounter` | `CycleSceneWarioPals` (bank2b_2.asm:887): 0 = off, 1-8 the palette written to `wSceneWarioAttributes` every 2 frames, $80 = reset and stop; started/stopped by the prologue (:683, :714) and the epilogue (:3278, :3286). |
| `w2d150`, `w2d151`, `wd152`..`wd155` (bank2d, bank56) | `wNOWPrologueObj2ParticleStep`, `...Obj3...`, `...Obj5...`, `...Obj8...`, `...Obj9...`, `...Obj10ParticleStep` | `UpdateNOWPrologueParticles` (bank56.asm:721-1051): one jumptable index per scene object 2/3/5/8/9/10 (place, arc along `NOWPrologueParticleArc1`-`3`, loop); started one by one by `NOWFunc_Prologue` (bank2d.asm:3580-3607). The two uses are a nested `UNION` inside the `wSceneWario` branch; `wDebugSceneWarioState` (bank2b_1.asm:1322) keeps its own branch at `$d152`. |
| `w2d8b0` / `w2d8b1` | `wMusicBoxSparkleStep` / `wMusicBoxSparkleCounter` | `UpdateMusicBoxSparkle` (bank2b_2.asm:532) dispatches on the first, counts in the second; set by `Prologue_WarioEnterCave` (`.start_sparkle`, `.StartSparkleLoop`) and cleared at :125. |
| `w3d01a` | `wEnvelopeFrameCycle` | Counts 14..0 and wraps once per audio frame (audio/engine.asm:197-203). `ProcessTrack` (:2257) increments the track's envelope tick (`TRACK_FREQUENCY` low byte, compared with the envelope length at :2337 and :2432) twice when it is 0, else once: 16 ticks per 15 frames, i.e. 64 Hz at 60 fps, the hardware envelope's rate. |
| `w4d000`..`w7d000` | `wBackupV0Tiles0`, `wBackupV0Tiles2`, `wBackupV1Tiles0`, `wBackupV1Tiles2` | `SaveBackupVRAM` / `LoadBackupVRAM` (home/backup_vram.asm) copy `v0Tiles0`, `v0Tiles2`..`v0End` (with the BG maps), `v1Tiles0` and `v1Tiles2`..`v1End` to/from them; nothing else uses WRAM banks 4-7. Named after the VRAM labels, next to `wBackupSCY`/`wBackupPals`. |
| `wCurSceneObj` in `DrawCutsceneOverlay*` and Cutscene14 | `wCutsceneOverlaySprite1` / `wCutsceneOverlaySprite2` (`sprite_oam_struct`, a `UNION` with `wCurSceneObj`) | `DrawCutsceneOverlay` (bank27.asm:7487) writes Y, X, frame and attributes into the first 4 bytes of `wCurSceneObj` (frames 0 and 5) or the last 4 (`wCurSceneObjDuration`, frames 1, 2, 3, 6); `DrawCutsceneOverlayFrame4` only sets the frame of the first and draws it where it is. Cutscene14 places and moves that first sprite (bank27.asm:5583-5651) right before setting `wCutsceneOverlayType` to 2. |

Left as they are:

- `wUnused_2d121` (`$d121`, just before pair 1): written by
  `EOWFunc_FormCastle` (bank2d.asm:7490), never read; nothing shows it is a
  pair 0.
- Cutscene14's local `.LowerCurObj` now lowers `wCutsceneOverlaySprite1`; a
  ROM local label, left to the ROM naming work.
- What the prologue particles and the south map's object 14 look like isn't
  known, so the names say what the code does with them, not what they are.

## Sixth pass: object states and interactions

The numbered `OBJSTATE_*`, `OBJ_INTERACTION_*` and `OBJACTION_*` values
in `src/constants/object_constants.asm`. The 18 objects with a full
state jumptable (`ld a, [wCurObjState] / jumptable`, 93-96 entries) were
read side by side: for each slot, which handler the objects put there,
and who writes the value (the shared `ObjState_*` code in
`update_objects.asm`, `DoObjectAction`, the objects themselves). The
pattern the named states already showed holds for the new ones: a state
below $30 sets up and moves on, usually to the same state $30 higher.
Interactions take the name of the `ObjInteraction_*` handler in the
table at `object_interactions.asm:214`. Actions are named after what
sets them and the state `DoObjectAction` gives the object. The build was
byte-identical after each batch.

`U` = `src/engine/level/update_objects.asm`, `I` =
`src/engine/level/object_interactions.asm`, `obj/` =
`src/engine/level/objects/`. Line numbers are in the renamed files.

**Object states** (49 named, plus 3 aliases)

| Old | New | Evidence |
|-----|-----|----------|
| `OBJSTATE_00` | `OBJSTATE_DEFAULT` | `.Default` in 15 of 18 tables; written at spawn (`load_objects.asm:251`) and after recovering (`obj/spearhead.asm:724`); `.Default` re-inits the interaction and goes to `OBJSTATE_FALL` (`obj/spearhead.asm:279`). |
| `OBJSTATE_0B` / `0C` / `0D` / `0E` | `OBJSTATE_HIT_WARIO_RIGHT_START` / `_LEFT_START` / `_UP_START` / `_DOWN_START` | `DoObjectAction.HitWario` (`U:689`) picks one from the `INTERACTION_*` side bits stored with `OBJACTION_HIT_WARIO` (down/up/right/left, `U:699-715`). The objects slide away from Wario, then turn round (`obj/spearhead.asm:851-890`; the same in Fire Bot, Hammer Bot, Para-Goom, Silky and Spear Bot). |
| `OBJSTATE_3B` / `3C` | `OBJSTATE_HIT_WARIO_RIGHT` / `_LEFT` | Set by `.State0b`/`.State0c` (`obj/spearhead.asm:851`); `ObjState_BumpSlideRight`/`Left`, then `OBJSTATE_TURN_AROUND_START` (`:867`). |
| `OBJSTATE_0F` / `3F` | `OBJSTATE_STUNNED_START` / `OBJSTATE_STUNNED` | Lying stunned and grabbable (`OBJ_INTERACTION_GRABBABLE`) for 100 frames (`obj/spearhead.asm:689`). Entered when the stun slide stops (`:614`) and when a dropped object lands (`U:2725`). It is not `OBJSTATE_STUN_LEFT`, which is the slide before it. |
| `OBJSTATE_10` / `40` | `OBJSTATE_RECOVER_START` / `OBJSTATE_RECOVER` | Comes after `OBJSTATE_STUNNED` times out: a 7-frame hop (`ApplyObjHopYVel`), then `OBJSTATE_DEFAULT` (`obj/spearhead.asm:711-726`). |
| `OBJSTATE_12` / `42` | `OBJSTATE_DROP_START` / `OBJSTATE_DROP` | Set by `ObjCheckFloorOrDrop` (`U:2634`) and when a held object is released standing (`U:1582`). `.State12` sets `OBJSTATE_DROP` (`obj/spearhead.asm:1022`), which `ObjState_Drop` handles in all 17 tables; it lands in `OBJSTATE_STUNNED`. |
| `OBJSTATE_14` / `15`, `44` / `45` | `OBJSTATE_FALL_LEFT_START` / `_RIGHT_START`, `OBJSTATE_FALL_LEFT` / `_RIGHT` | `.State14` sets the frameset, the x speed and `OBJSTATE_FALL_LEFT` (`obj/spearhead.asm:651`), which `ObjState_FallLeft` handles (17 tables). Set when a held object is put down while crouching (`U:1658`, `:1577`) or hits a wall (`U:1207`), when an object slides off a ledge (`U:3026`), and when a falling object hits a wall (`U:3283`, which reverses it). |
| `OBJSTATE_26` / `27`, `56` / `57` | `OBJSTATE_BOUNCE_FALL_LEFT_START` / `_RIGHT_START`, `OBJSTATE_BOUNCE_FALL_LEFT` / `_RIGHT` | Only set when a bounce's rise ends or hits a wall (`ObjBounceLeft`, `U:3638`, `:3645`; the right side at `:3787` and `:3794`, which was a raw `$26`). The slot handler `ObjState_FallLeftStart` (15 tables) keeps the frameset, sets `OBJSTATE_BOUNCE_FALL_LEFT` (`U:3197`) and then runs the same `ObjState_FallLeft`. The routine names are kept. |
| `OBJSTATE_18` / `19`, `48` / `49` | `OBJSTATE_GRABBED_LEFT_START` / `_RIGHT_START`, `OBJSTATE_GRABBED_LEFT` / `_RIGHT` | Set at the end of a pick-up (`U:1212`, `:1419`). `.State18` sets `OBJSTATE_GRABBED_LEFT` and the grabbed flag; `.State48` calls `ObjState_GrabbedLeft` while `wDirection` is `DIRECTION_LEFT` and otherwise switches to `.State19` (`obj/spearhead.asm:958-1020`). |
| `OBJSTATE_4A` / `4B` | `OBJSTATE_GRABBED_CHARGE_LEFT` / `_RIGHT` | Set on `GRAB_CHARGE_THROW` in `ObjState_GrabbedLeft` (`U:1696`); slot handler `ObjState_GrabbedChargeLeft` (16 tables). |
| `OBJSTATE_4E` / `4F` | `OBJSTATE_THROW_LEFT` / `_RIGHT` | Set by `ThrowObject_Left` (`U:1897`); slot handler `ObjState_ThrowLeft` (16 tables). |
| `OBJSTATE_1A` / `1B` | `OBJSTATE_HOP_START` / `OBJSTATE_HOP` | Slot handlers `ObjState_HopStart` / `ObjState_Hop` (12 tables); `HopStart` sets `OBJSTATE_HOP` (`U:3800`). These two are $01 apart, not $30. |
| `OBJSTATE_1C` | `OBJSTATE_RANDOM_WOBBLE_START` | Slot handler `ObjState_StartRandomWobble` (12 tables), where `rDIV` picks `OBJSTATE_WOBBLE_LEFT` or `RIGHT` (`U:3819`). Stunned objects set it when the ground shakes (`obj/spearhead.asm:700`). |
| `OBJSTATE_20`-`25`, `50`-`55` | `OBJSTATE_BOUNCE_1_LEFT_START` ... `OBJSTATE_BOUNCE_3_RIGHT_START`, `OBJSTATE_BOUNCE_1_LEFT` ... `OBJSTATE_BOUNCE_3_RIGHT` | Slot handlers `ObjState_Bounce{1,2,3}{Left,Right}[Start]` (14-16 tables); `SetObjBounceFromYVel_Left` picks bounce 1, 2 or 3 from the landing speed (`U:3318-3340`). |
| `OBJSTATE_28` / `29`, `58` / `59` | `OBJSTATE_HIT_BY_OBJ_LEFT_START` / `_RIGHT_START`, `OBJSTATE_HIT_BY_OBJ_LEFT` / `_RIGHT` | `HandleGrabbedObjectCollisions` (`U:914-955`) gives these to a thrown object and to the object it hits. `.State28` sets `OBJSTATE_HIT_BY_OBJ_LEFT` (`obj/spearhead.asm:900`), whose handler `ObjState_HitByObjLeft` knocks the object left (`U:2557`). |
| `OBJSTATE_3A` | `OBJSTATE_RESIST_VANISH` | What Stove, Futamogu and Robo Mouse do on `OBJSTATE_VANISH_TOUCH` instead of vanishing (`obj/stove.asm:87-95`, `obj/futamogu.asm:173`, `obj/robo_mouse.asm:196-226`); it is $0a + $30. |
| - | `OBJSTATE_TRIGGERED` (= `GRABBED_LEFT_START`) | Set by `DoObjectAction.Trigger` (`U:719`) for `OBJACTION_TRIGGER`. Keys, chests and musical coins wait for it (`obj/key.asm:25`, `obj/chests.asm:54`, `obj/musical_coin.asm:25`); the owl, Appleby and the doughnuts compare against a raw `$18`. |
| - | `OBJSTATE_NO_EFFECT` (= `GRABBED_RIGHT_START`) | Set by `DoObjectAction.NoEffect` (`U:756`) for `OBJACTION_NO_EFFECT`; the doughnuts restart on `$19` (`obj/doughnuteer.asm:1042`). |
| - | `OBJSTATE_COIN_INIT` (= `GRABBED_RIGHT_START`) | Coins spawn in `$19`, the slot of `CoinFunc`'s `.Init` (`obj/coin.asm:161`, `data/object_params.asm:1424`, `:1439`). |

**Object interactions** (20 named)

| Old | New | Handler (`I:`) |
|-----|-----|----------------|
| `OBJ_INTERACTION_00` | `OBJ_INTERACTION_GRABBABLE` | `ObjInteraction_Grabbable` :1411 |
| `OBJ_INTERACTION_01` | `OBJ_INTERACTION_TOUCH` | `ObjInteraction_Touch` :1620 (`TouchObject`) |
| `OBJ_INTERACTION_06` | `OBJ_INTERACTION_WATER_BUMP` | `ObjInteraction_WaterBump` :1672 |
| `OBJ_INTERACTION_07` | `OBJ_INTERACTION_WATER_KNOCK_BACK` | `ObjInteraction_WaterKnockBack` :1678 |
| `OBJ_INTERACTION_08` | `OBJ_INTERACTION_WATER_FRONT_STING` | `ObjInteraction_WaterFrontSting` :1718 |
| `OBJ_INTERACTION_09` | `OBJ_INTERACTION_FRONT_BUMP` | `ObjInteraction_FrontBump` :1755 |
| `OBJ_INTERACTION_0A` | `OBJ_INTERACTION_BUMP_OFF` | `ObjInteraction_BumpOff` :1774 |
| `OBJ_INTERACTION_0B` | `OBJ_INTERACTION_BUMP_OFF_PAUSE` | `ObjInteraction_BumpOffPause` :1783 (bump off, then `OBJACTION_PAUSE`) |
| `OBJ_INTERACTION_31` | `OBJ_INTERACTION_SOLID_PLATFORM` | `ObjInteraction_SolidPlatform` :3208 |
| `OBJ_INTERACTION_36` | `OBJ_INTERACTION_SMASHABLE_TOP` | `ObjInteraction_SmashableTop` :3270 |
| `OBJ_INTERACTION_3B` | `OBJ_INTERACTION_GRABBABLE_WALKABLE` | `ObjInteraction_GrabbableWalkable` :3362 |
| `OBJ_INTERACTION_43` | `OBJ_INTERACTION_WATER_FULL_STING` | `GetStungByObjectInWater` :1017, the water version of the `GetStungByObject` that `FULL_STING` uses |
| `OBJ_INTERACTION_46` | `OBJ_INTERACTION_FRONT_STING_BUMP_OFF` | `ObjInteraction_FrontStingBumpOff` :3466 |
| `OBJ_INTERACTION_47` | `OBJ_INTERACTION_TOP_STING_BUMP_OFF` | `ObjInteraction_TopStingBumpOff` :3485 |
| `OBJ_INTERACTION_48` | `OBJ_INTERACTION_BOTTOM_STING_SMASHABLE_TOP` | `ObjInteraction_BottomStingSmashableTop` :3491 |
| `OBJ_INTERACTION_49` | `OBJ_INTERACTION_WATER_FRONT_LAUNCH` | `ObjInteraction_WaterFrontLaunch` :3504 |
| `OBJ_INTERACTION_4F` | `OBJ_INTERACTION_FRONT_PUSH_BUMP_OFF` | `ObjInteraction_FrontPushBumpOff` :3634 |
| `OBJ_INTERACTION_50` | `OBJ_INTERACTION_FRONT_DRAG_DOWN` | `ObjInteraction_FrontDragDown` :3656 |
| `OBJ_INTERACTION_51` | `OBJ_INTERACTION_WATER_KNOCK_BACK_TOP_RIGHT` | `ObjInteraction_WaterKnockBackTopRight` :3674 |
| `OBJ_INTERACTION_52` | `OBJ_INTERACTION_FRONT_STING_SMASHABLE_TOP` | `ObjInteraction_FrontStingSmashableTop` :3688 |

**Object actions** (9 named)

| Old | New | Evidence |
|-----|-----|----------|
| `OBJACTION_06` | `OBJACTION_HIT_WARIO` | Set when the object stings Wario (`GetStungByObject`, `I:885`), bumps him off (`BumpOffObject`, `I:1180`), or burns, shocks or transforms him (Fire, Electric, Food, Zombie Head, Beam, Shoot...). Gives `OBJSTATE_HIT_WARIO_*` (`U:689`). |
| `OBJACTION_07` | `OBJACTION_TRIGGER` | Set by `TriggerObjInteraction` (`I:1299`) for keys, treasure, coins, food, the potion, the owl, snow, bubbles and ice. Gives `OBJSTATE_TRIGGERED` (`U:719`). |
| `OBJACTION_0A` | `OBJACTION_PAUSE` | `.Pause` (`U:735`) only blocks actions for 15 frames. |
| `OBJACTION_0C` | `OBJACTION_PICK_UP_WARIO` | Set by `ObjInteraction_Omodonmeka` (`I:2134`), which then sets `WST_PICKED_UP`. |
| `OBJACTION_0D` | `OBJACTION_NO_EFFECT` | Set by `SetObjAction_NoEffect` (`I:1304`) for Food, Zombie Head and Snow when Wario is crouching, invincible or already transformed. Gives `OBJSTATE_NO_EFFECT`. |
| `OBJACTION_0E` | `OBJACTION_LIGHT_TORCH` | Only set by `ObjInteraction_UnlitTorch` (`I:3149`), and only for Hot Wario. |
| `OBJACTION_11` | `OBJACTION_SWALLOW` | Only set by `ObjInteraction_Pesce` (`I:3343`), together with `SetState_Swallowed`. |
| `OBJACTION_12` | `OBJACTION_HIT_WARIO_SHORT` | `.HitWarioShort` (`U:686`) is `.HitWario` with 7 frames of no actions instead of 15. Only Prince Froggy uses it (`BumpOffObject_HitWarioShort`, `I:1389`). |
| `OBJACTION_13` | `OBJACTION_SPECIAL_3` | Gives `OBJSTATE_SPECIAL_3` (`U:594`). It is used both for dragging Wario down (Hand, `FRONT_DRAG_DOWN`) and for shooting ball Wario (`ShootBallWario`, `I:3624`), so it is named after the state. |

Labels that carried those numbers were renamed too: `SetObjAction_0D` ->
`SetObjAction_NoEffect`, `SetObjAction_13` -> `SetObjAction_Special3`,
`BumpOffObjectWithAction12` -> `BumpOffObject_HitWarioShort`,
`UnreferencedSetObjAction_06` -> `UnreferencedSetObjAction_HitWario`,
`ObjInteraction_BumpOffAction0A` -> `ObjInteraction_BumpOffPause`, and
`DoObjectAction`'s `.Action06` ... `.Action13` -> `.HitWario`, `.Trigger`,
`.Pause`, `.PickUpWario`, `.NoEffect`, `.LightTorch`, `.Swallow`,
`.HitWarioShort`, `.Special3`. `book/src/debug-owl.md` was updated to match.

**Left numbered:**

- `OBJSTATE_1D`, `1E`, `1F`, `3D`, `3E` are unused: every table has
  `.Default`, `.Vanish` or `.Destroy` in their slots and nothing writes
  them. (By the pattern, `3D`/`3E` would be `HIT_WARIO_UP`/`DOWN`, but no
  object uses them.)
- `OBJSTATE_2B`, `2C`, `5A`, `5B`, `5C`, `5D` are object-specific, with
  different meanings in different objects:
  - `2B`/`2C` lead to `5B`/`5C` only in Doughnuteer and Mad Scienstein
    (`obj/doughnuteer.asm:169`, `:302`).
  - `5B` is also Teruteru's follow-up to `HIT_WARIO_DOWN`
    (`obj/teruteru.asm:136`) and Fire Bot's follow-up to `HIT_WARIO_RIGHT`.
  - More than a dozen objects write a raw `5A`: Robo Mouse's `.Activate`,
    Scowler's `.activated`, Omodonmeka's `.StartPressWario` and Count
    Richtertoffen after `.Flatten`, but also Appleby, Jamano, the Seeing-Eye
    Door and others. `5A` may mean "after `OBJSTATE_ACTIVATE`", but that is
    not shown for all of them.
- There are no `OBJSUBFLAG_UNK_*` constants. `GRAB_*` is left to the
  substates work.

**Oddities, not changed:**

- The routine in slots `$26`/`$56` is called `ObjState_FallLeftStart`, but
  the plain fall-left states are `$14`/`$44`. Both reach `ObjState_FallLeft`.
- `_ObjState_PickedUpLeft` ends in `OBJSTATE_GRABBED_RIGHT_START` and
  `PickedUpRight` ends in `GRABBED_LEFT_START` (`U:1212`, `:1419`);
  `.State18`/`.State19` then switch to the right one using `wDirection`.
- The `OBJSTATE_WOBBLE_LEFT`/`RIGHT` slots hold `ObjState_Bounce2Right`/`Left`,
  and `ObjState_HitByObjRight` and `ObjState_AttackedLeft` move the object
  right. In those older names, left/right is the side that was hit, not
  the direction of motion.
- `ObjInteraction_TopSting` stings on `INTERACTION_UP` and steps on
  `INTERACTION_DOWN`, and `ObjInteraction_BottomSting` does the reverse,
  while `Walkable` and `SolidPlatform` stand on `INTERACTION_UP`. Checked
  afterwards: the names are right. `INTERACTION_UP` is Wario touching the
  object's top (where `Walkable` lets him stand), so `TopSting` stings from
  above and lets him step on its underside, and `BottomSting` the reverse.
  Kushimushi, on its thread, switches to `TOP_STING` at one turn and
  `BOTTOM_STING` at the other; Para-Goom's spiky form is `TOP_STING`.
- Many objects still used raw state literals (`cp $18`, `ld a, $3b`,
  `ld a, $5a`...); see "Object state literals" below, which converted them.

## Sixth pass: sound effects

266 of the 312 `SFX_` constants (src/constants/sound_constants.asm) were
named by number. Every use goes through the `play_sfx`/`play_sfx_rept`
macros (src/macros/audio.asm); nothing computes an SFX ID or reads one
from a table, so the callers below are all the uses. Each sound was named
after the event that plays it, or after its most characteristic caller
when several unrelated places share it (the others are listed). The
audio data labels were renamed to match (`Sfx_00e` -> `Sfx_Swim`,
`Sfx_00e_Ch1` -> `Sfx_Swim_Ch1`, ... in src/audio/sfx/sfx1.asm, sfx2.asm
and the `SoundHeaders` table), and so were the code labels that carried a
sound number: `PlaySFX_112` -> `PlayItemRaiseSFX`, `PlaySFX_12A` ->
`PlayStepSFX`, and local labels such as `.PlaySFX076Every26Frames` ->
`.PlayThunderSFXEvery26Frames` or `.play_sfx_01f_every_17_frames` ->
`.play_sfx_rumble_every_17_frames`. The ROM is byte-identical.

Caller paths are relative to src/engine/ and give line numbers in
origin/master at the time of the pass (the renames did not move lines).

| Old | New | Evidence |
|---|---|---|
| `SFX_006` | `SFX_PLANE_DEBRIS_LAND` | The plane wreckage pieces hitting the ground in the prologue/epilogue plane scenes (`.land_sfx_and_next`, `.check_landed` at y=$62). Callers: overworld/bank2b_2.asm:1556, overworld/bank2b_2.asm:1566, overworld/bank2b_2.asm:1689, overworld/bank2b_2.asm:1698, +7 more. |
| `SFX_00E` | `SFX_SWIM` | Swimming stroke loop in `HandleSwimming`; the flippers/Frog's gloves action help screens use it the same way. Callers: level/wario_states_1.asm:5536, action_help/power_ups/swimming_flippers.asm:189, action_help/power_ups/swimming_flippers.asm:208, action_help/power_ups/swimming_flippers.asm:235, +13 more. |
| `SFX_00F` | `SFX_UNDERWATER_THRUST` | `UpdateState_UnderwaterThrusting` loop (every 15 frames); also a golf Para-Goom frame and Cutscene30. Callers: level/wario_states_1.asm:2035, golf/hole.asm:559, action_help/power_ups/swimming_flippers.asm:304, action_help/power_ups/swimming_flippers.asm:372, +4 more. |
| `SFX_014` | `SFX_STOMP` | Wario stepping on an object (`StepOnObject`, `PushObjectInWater`, then `OBJACTION_WOBBLE`), bosses' `.VanishTouch`, and the magic seed/crayon hitting the ground on the map. Callers: level/object_interactions.asm:722, level/object_interactions.asm:752, level/object_interactions.asm:1122, level/objects/count_richtertoffen.asm:131, +10 more. |
| `SFX_016` | `SFX_THROWN_OBJECT_HIT` | `HandleGrabbedObjectCollisions`: a thrown object hits another object; also Wormwould's rolling rock hitting. Callers: level/update_objects.asm:1039, level/update_objects.asm:1061, level/update_objects.asm:1088, level/objects/wormwould.asm:586. |
| `SFX_017` | `SFX_ATTACK_HIT` | `AttackObject` (any attack on an object); also golf hit, Zombie, Skull, Doll Boy barrel. Callers: level/object_interactions.asm:484, level/objects/zombie.asm:282, level/objects/jamano.asm:859, level/objects/doll_boy.asm:1016, +3 more. |
| `SFX_01A` | `SFX_OBJECT_HIT_WALL` | A held/sliding object hits a wall (`_ObjState_Grabbed*`/`PickedUp*` drop, `_ObjState_BumpSlide*` -> stun); also Shoot/Kuri turning at the walls, a tree falling on the map. Callers: level/update_objects.asm:1201, level/update_objects.asm:1408, level/update_objects.asm:1652, level/update_objects.asm:1763, +7 more. |
| `SFX_01B` | `SFX_FLATTEN` | Setting `TRANSFORMATION_FLAT_WARIO` (being crushed flat) in `SetState_FlatAirborne`. Callers: level/wario_states_3.asm:497. |
| `SFX_01D` | `SFX_FLAT_JUMP` | `SetState_FlatJumping`; also `SetState_VampireAirborne_Jump`. Callers: level/wario_states_3.asm:723, level/wario_states_3.asm:4372. |
| `SFX_01E` | `SFX_FIRE` | `UpdateState_OnFire`; also torch/fire/vine-burning cutscenes. Callers: level/wario_states_3.asm:99, overworld/bank27.asm:6572, overworld/bank27.asm:7032, overworld/bank2d.asm:8129. |
| `SFX_01F` | `SFX_RUMBLE` | Looping rumble: `UpdateState_Hot`, temple screen shake, `UpdateOWSceneScreenShake`, Hidden Figure's defeat sink, golf clear cutscene. Callers: level/wario_states_3.asm:293, level/objects/hidden_figure.asm:426, golf/lobby.asm:660, overworld/bank56.asm:64, +5 more. |
| `SFX_020` | `SFX_FLAT_FALL` | `UpdateState_FlatFalling`. Callers: level/wario_states_3.asm:951. |
| `SFX_022` | `SFX_BURNT` | Hot Wario becoming `WST_BURNT`. Callers: level/wario_states_3.asm:341. |
| `SFX_023` | `SFX_BUBBLE_FLOAT` | `UpdateState_InBubble` loop (every 14 frames); also intro plane and Cutscene06 with the same period. Callers: level/wario_states_3.asm:4846, title/intro.asm:512, overworld/bank27.asm:1624. |
| `SFX_024` | `SFX_FAT_LAND` | Fat Wario landing (`UpdateState_FatAirborne`, with ground shake); also Snowman Wario landing. Callers: level/wario_states_3.asm:1884, level/wario_states_4.asm:1202. |
| `SFX_025` | `SFX_PUFFY_INFLATE` | `SetState_PuffyInflating`. Callers: level/wario_states_3.asm:2500. |
| `SFX_027` | `SFX_PUFFY_DEFLATE` | `SetState_PuffyDeflating`. Callers: level/wario_states_3.asm:2689. |
| `SFX_028` | `SFX_ZOMBIE_TRANSFORM` | `ObjInteraction_ZombieHead` before setting `TRANSFORMATION_ZOMBIE_WARIO`; also `ObjInteraction_Ice` before `TRANSFORMATION_ICE_SKATIN`. Callers: level/object_interactions.asm:2648, level/object_interactions.asm:2950. |
| `SFX_02A` | `SFX_ZOMBIE_LAND` | `SetState_ZombieLanding`. Callers: level/wario_states_3.asm:3089. |
| `SFX_02B` | `SFX_BOUNCY_BOUNCE` | `SetState_BouncyAirborne`. Callers: level/wario_states_3.asm:3546. |
| `SFX_02C` | `SFX_THROW_CHARGE` | `SetState_ThrowCharging` and the action help throw. Callers: level/wario_states_1.asm:3063, action_help/common1.asm:876. |
| `SFX_02E` | `SFX_ICE_SKATIN_CRASH` | `SetState_IceSkatinCrash`. Callers: level/wario_states_4.asm:295. |
| `SFX_034` | `SFX_SHOOT_KICK_WARIO` | Shoot sending Wario off as the ball (`.shoot_wario`, `wAutoMoveState`). Callers: level/objects/shoot.asm:552. |
| `SFX_035` | `SFX_CHEST_OPEN` | `ChestFunc.Open`; also Cutscene07. Callers: level/objects/chests.asm:76, overworld/bank27.asm:1827. |
| `SFX_039` | `SFX_BALL_O_STRING_TRANSFORM` | `TurnIntoBallOStringWario`. Callers: level/object_interactions.asm:2300. |
| `SFX_03A` | `SFX_EAT_FOOD` | `ObjInteraction_Food` (turns Wario fat); also the musical coin screen after counting and when the pencil moves. Callers: level/object_interactions.asm:2413, clear/musical_coins.asm:113, clear/musical_coins.asm:151. |
| `SFX_03C` | `SFX_BALL_O_STRING_BOUNCE` | `UpdateState_BallOStringKnockBack`: hitting a wall and turning round. Callers: level/wario_states_3.asm:1402. |
| `SFX_03D` | `SFX_STRING_UNWRAP` | `UpdateState_GettingUnwrappedInString`. Callers: level/wario_states_3.asm:1441. |
| `SFX_03E` | `SFX_GET_TREASURE_OPEN` | `UpdateState_GetTreasureTurnBack` -> `WST_GET_TREASURE_OPEN`. Callers: level/wario_states_2.asm:1473. |
| `SFX_03F` | `SFX_INVISIBLE_TRANSFORM` | `SetState_TurningInvisible`. Callers: level/wario_states_3.asm:2400. |
| `SFX_040` | `SFX_ELECTRIC_SHOCK` | `ObjInteraction_Electric`; also Scowler's tentacle activating and the warped-void reveal cutscene. Callers: level/object_interactions.asm:2522, level/objects/scowler.asm:86, level/objects/scowler.asm:800, overworld/bank27.asm:6626. |
| `SFX_041` | `SFX_ELECTRIC_LAND` | `UpdateState_Electric`: the last bounce after a shock. Callers: level/wario_states_3.asm:2312. |
| `SFX_042` | `SFX_CRAZY_SPIN` | `SetState_CrazySpinning`. Callers: level/wario_states_3.asm:3868. |
| `SFX_043` | `SFX_CRAZY_DIZZY` | `SetState_Crazy` and the end of the spin (`WST_CRAZY_DIZZY`). Callers: level/wario_states_3.asm:3972, level/wario_states_3.asm:4018. |
| `SFX_044` | `SFX_SPLIT_LAND` | `UpdateState_SplitKnockedBack` landing. Callers: level/wario_states_4.asm:1666. |
| `SFX_045` | `SFX_VAMPIRE_TRANSFORM` | `SetState_VampireTransforming` (+ action help). Callers: level/wario_states_3.asm:4570, action_help/common2.asm:788. |
| `SFX_046` | `SFX_BAT_TRANSFORM` | `SetState_BatTransforming` (+ action help). Callers: level/wario_states_3.asm:4436, action_help/power_ups/vampire.asm:143. |
| `SFX_047` | `SFX_SNOWMAN_TRANSFORM` | `SetState_TurningIntoSnowman`. Callers: level/wario_states_4.asm:801. |
| `SFX_048` | `SFX_LAUNCH_CRASH` | `UpdateState_Launched` -> `WST_LAUCH_CRASH`. Callers: level/wario_states_4.asm:2542. |
| `SFX_049` | `SFX_HAMMER_HIT` | Hammer Bot's hammer hit (with stars), Doll Boy hitting Wario, Doll Boy's hammer. Callers: level/objects/hammer_bot.asm:784, level/objects/doll_boy.asm:707, level/objects/doll_boy.asm:1151. |
| `SFX_04C` | `SFX_LAUNCHED` | `UpdateState_Launched` loop. Callers: level/wario_states_4.asm:2521. |
| `SFX_061` | `SFX_EARTHQUAKE` | Big impacts with `DoGroundShake` (Igaguri, Anonster, `DollBoyGroundShake`) and the map earthquakes (`WOWFunc_Earthquake`, `SOWFunc_Earthquake`, prologue); also intro, Cutscene13, game over. Callers: level/objects/wolfenboss.asm:942, level/objects/anonster.asm:540, level/objects/doll_boy.asm:1276, title/intro.asm:649, +5 more. |
| `SFX_063` | `SFX_SLAM` | Stove landing, Omodon falling and the Hidden Figure hand slam (all with `DoGroundShake`); also `UpdateOWSceneScreenShake` right shakes. Callers: level/objects/stove.asm:60, level/objects/omodonmeka.asm:1074, level/objects/hidden_figure.asm:990, level/objects/hidden_figure.asm:1403, +2 more. |
| `SFX_065` | `SFX_GOLF_BUNKER` | Golf ball landing in a bunker (`UpdateGolfParaGoomYPos.bunker`). Callers: golf/hole.asm:1767. |
| `SFX_066` | `SFX_BALL_BOUNCE` | `SetState_BallAirborne` and `UpdateState_BallThrown` (`WST_BALL_SENT_UPWARDS`); also a Count Richtertoffen state. Callers: level/wario_states_4.asm:2875, level/wario_states_4.asm:3087, level/objects/count_richtertoffen.asm:295. |
| `SFX_067` | `SFX_ENEMY_THROW` | Enemies throwing: Appleby's apple, Doughnuteer, Mad Scienstein (on-screen only), GK Tortoise/Shoot ball, Igaguri. Callers: level/objects/shoot.asm:1590, level/objects/shoot.asm:1627, level/objects/shoot.asm:1727, level/objects/shoot.asm:1813, +4 more. |
| `SFX_068` | `SFX_SUN_SHOOT` | Sun shooting (`SunFunc`, at duration 52, then `.shoot_left/right`). Callers: level/objects/sun_moon.asm:97. |
| `SFX_069` | `SFX_BUBBLE_SPAWN` | `BubbleHoleFunc.create_bubble`. Callers: level/objects/bubble.asm:36. |
| `SFX_06A` | `SFX_WHIRR` | Repeating buzz every 8/16 frames: electric lamp charging, Shoot, Kuri, Doll Boy's barrel, Hidden Figure's stunned hand. Callers: level/objects/shoot.asm:856, level/objects/electric_lamp.asm:39, level/objects/wolfenboss.asm:1095, level/objects/doll_boy.asm:979, +1 more. |
| `SFX_06B` | `SFX_ELECTRIC_LAMP_DISCHARGE` | `ElectricLampFunc` switching to `.Discharged` (spawns the spark); also `IgaguriFunc` every 8 frames. Callers: level/objects/electric_lamp.asm:49, level/objects/wolfenboss.asm:759. |
| `SFX_06C` | `SFX_ELECTRIC_SPARK` | `ElectricLampSparkFunc`. Callers: level/objects/electric_lamp.asm:101. |
| `SFX_06D` | `SFX_CART_ROLL` | `CartFunc.Moving`/`CartVariableFunc.Moving`; also the cart wheels cutscene. Callers: level/objects/cart.asm:43, level/objects/cart.asm:175, overworld/bank27.asm:6254. |
| `SFX_06E` | `SFX_MOON_SHOOT` | Moon shooting stars (`MoonFunc`, `ObjParams_MoonStar*`). Callers: level/objects/sun_moon.asm:592. |
| `SFX_06F` | `SFX_BIRD_ALERT` | Bird seeing Wario in range (sets `OBJSTATE_SPECIAL_3`). Callers: level/objects/bird.asm:113. |
| `SFX_070` | `SFX_BIRD_TAKE_OFF` | Bird at the end of `.Special3`, before `.FlyAway`. Callers: level/objects/bird.asm:130. |
| `SFX_072` | `SFX_BUBBLE_POP` | `BubbleFunc.set_burst`. Callers: level/objects/bubble.asm:79. |
| `SFX_073` | `SFX_FLAME` | Torch flame/ember (`FlameBlockTorchUpdate`, `TorchFunc.create_ember`), Fire Bot; also golf OB and Cutscene19. Callers: level/objects/torch.asm:9, level/objects/torch.asm:49, level/objects/torch.asm:147, level/objects/fire_bot.asm:271, +2 more. |
| `SFX_074` | `SFX_ZOMBIE_RISE` | Zombie rising out of the ground (`.Rising`); also Cutscene3c. Callers: level/objects/zombie.asm:210, overworld/bank27.asm:4136. |
| `SFX_075` | `SFX_HEAVY_STEP` | Count Richtertoffen landing (with ground shake) and Shoot's walk step. Callers: level/objects/count_richtertoffen.asm:425, level/objects/shoot.asm:833. |
| `SFX_076` | `SFX_THUNDER` | `WOWFunc_Rain.PlayThunderSFX`, `PlayVolcanoRumbleSFX`, red music box, and cutscenes (leaves fall, extinguish fire, iron wall). Callers: overworld/bank27.asm:6470, overworld/bank27.asm:6998, overworld/bank27.asm:7095, overworld/bank2d.asm:3677, +2 more. |
| `SFX_078` | `SFX_STOVE_RATTLE` | Stove rattling every 8 frames while being attacked. Callers: level/objects/stove.asm:114, level/objects/stove.asm:155. |
| `SFX_079` | `SFX_NOBIIRU_EXTEND` | `NobiiruFunc.Wait` -> `.Extend1`. Callers: level/objects/nobiiru.asm:62. |
| `SFX_07A` | `SFX_SEEING_EYE_DOOR_LOOK` | Seeing-Eye Door's eye changing frameset as Wario moves. Callers: level/objects/seeing_eye_door.asm:157, level/objects/seeing_eye_door.asm:176, level/objects/seeing_eye_door.asm:189, level/objects/seeing_eye_door.asm:204, +2 more. |
| `SFX_07C` | `SFX_BEAM` | Beam Bot's beams, Yellow Belly, Wolfenboss's magic spiral. Callers: level/objects/yellow_belly.asm:222, level/objects/beam_bot.asm:783, level/objects/beam_bot.asm:805, level/objects/wolfenboss.asm:610. |
| `SFX_07D` | `SFX_FAN_SPIN` | Fan states (`UpdateState_Fan*`), `UpdateState_MagicRising`, Beam Bot, propeller cutscene. Callers: level/wario_states_4.asm:1818, level/wario_states_4.asm:1866, level/wario_states_4.asm:1920, level/wario_states_4.asm:1959, +3 more. |
| `SFX_07E` | `SFX_ENEMY_SHOOT` | Enemies shooting a projectile at a fixed state time: Brrr Bear, Scowler ink, Anonster silk/waves. Callers: level/objects/brrr_bear.asm:219, level/objects/scowler.asm:138, level/objects/anonster.asm:258, level/objects/anonster.asm:287, +2 more. |
| `SFX_080` | `SFX_FALLING_SNOW_DROP` | `FallingSnowFunc` switching to `.StartFall`; also Cutscene3a and the crater-hole cutscene. Callers: level/objects/falling_snow.asm:107, overworld/bank27.asm:4031, overworld/bank27.asm:7327. |
| `SFX_081` | `SFX_HAND_APPEAR` | `HandFunc.Hidden`: the hand coming out of the sand. Callers: level/objects/hand.asm:79. |
| `SFX_082` | `SFX_TELEPORT` | `PlayTeleportingSFX`. Callers: level/wario_states_2.asm:508. |
| `SFX_083` | `SFX_SMALL_SPLASH` | Robo Mouse splash particle, Muddee in water; also feed-Octohon cutscene. Callers: level/objects/robo_mouse.asm:261, level/objects/muddee.asm:261, overworld/bank27.asm:7476. |
| `SFX_084` | `SFX_TURTLE_SWIM` | `PlayTurtleSwimSFX`. Callers: level/objects/muddee.asm:1165. |
| `SFX_085` | `SFX_MUDDEE_SWIM` | `MuddeeFunc.PlaySwimSFX`; also raise-pipe cutscene. Callers: level/objects/muddee.asm:839, overworld/bank27.asm:6711. |
| `SFX_086` | `SFX_BARREL_JUMP` | `Barrel1Func.Update2` before the hop movement (`BarrelData_60a50`). Callers: level/objects/barrel.asm:58. |
| `SFX_087` | `SFX_OMODONMEKA_LIFT` | Omodonmeka lifting Wario (`MoveWarioUp` every 8 frames). Callers: level/objects/omodonmeka.asm:234. |
| `SFX_089` | `SFX_SNAKE_SPIT_FIRE` | Snake spawning `ObjParams_SnakeFire*`. Callers: level/objects/snake.asm:248. |
| `SFX_08A` | `SFX_SNAKE_PREPARE_FIRE` | Snake `.PrepareFire` / `.ShootFire` animation frame. Callers: level/objects/snake.asm:184, level/objects/snake.asm:226. |
| `SFX_08B` | `SFX_SNAKE_SINK` | Snake `.Sink`. Callers: level/objects/snake.asm:326. |
| `SFX_08C` | `SFX_RAIL_HUM` | Zip line hum, Rail action help, Omodonmeka hovering (`.WatchWario`). Callers: level/objects/zip_line.asm:268, level/objects/omodonmeka.asm:297, level/objects/omodonmeka.asm:303, action_help/power_ups/rail.asm:146, +3 more. |
| `SFX_08E` | `SFX_SPARKLE` | `CoinFunc.ColourCoin` (a spawned coin turning out a colour coin); also leaves falling and epilogue/prologue/feed-Octohon twinkles. Callers: level/objects/coin.asm:63, overworld/bank2b_1.asm:292, overworld/bank27.asm:7415, overworld/bank2d.asm:2675, +2 more. |
| `SFX_0A1` | `SFX_WATER_DROP` | `WaterDropFunc`, falling snow landing, Anonster silk dissolving, golf rough, cutscene drops. Callers: level/objects/falling_snow.asm:174, level/objects/water_drop.asm:36, level/objects/anonster.asm:1219, golf/hole.asm:1763, +2 more. |
| `SFX_0A3` | `SFX_BOSS_DEFEAT_FALL` | Bosses starting the defeat fall: Shoot, Jamano, Wormwould, Wolfenboss, Anonster, Doll Boy, Muddee. Callers: level/objects/shoot.asm:1176, level/objects/jamano.asm:511, level/objects/wormwould.asm:526, level/objects/wolfenboss.asm:526, +3 more. |
| `SFX_0A4` | `SFX_DOLL_BOY_STUNNED` | `DollBoyFunc.set_stunned`. Callers: level/objects/doll_boy.asm:347. |
| `SFX_0A5` | `SFX_YELLOW_BELLY_SPAWN_PUMP` | Yellow Belly spawning `ObjParams_Pump`. Callers: level/objects/yellow_belly.asm:319. |
| `SFX_0A7` | `SFX_WORMWOULD_HURT` | `WormwouldFunc.hurt` and `.set_defeated`. Callers: level/objects/wormwould.asm:359, level/objects/wormwould.asm:436. |
| `SFX_0A9` | `SFX_BOSS_DEFEATED` | Boss defeat hit: `ShootFunc.set_defeated`, Yellow Belly (stops music), Wolfenboss hurt animation. Callers: level/objects/shoot.asm:1141, level/objects/yellow_belly.asm:314, level/objects/yellow_belly.asm:656, level/objects/wolfenboss.asm:264. |
| `SFX_0AA` | `SFX_WOLFENBOSS_SMOKE` | Wolfenboss smoke entrance/exit (`.SmokeEntrance`, `.SmokeExit`); also Yellow Belly. Callers: level/objects/yellow_belly.asm:743, level/objects/wolfenboss.asm:96, level/objects/wolfenboss.asm:202. |
| `SFX_0AC` | `SFX_SCOWLER_DEFEATED` | Scowler `.DefeatedRise` -> `.DefeatedSink`; also Cutscene3d. Callers: level/objects/scowler.asm:589, overworld/bank27.asm:4398. |
| `SFX_0AF` | `SFX_ANONSTER_WALK` | Anonster walking towards Wario (every 16 frames). Callers: level/objects/anonster.asm:711. |
| `SFX_0B3` | `SFX_SCOWLER_STUNNED` | Scowler -> `.Stunned`. Callers: level/objects/scowler.asm:129. |
| `SFX_0B4` | `SFX_SCOWLER_STOMPED` | Scowler `.check_hit_from_above`. Callers: level/objects/scowler.asm:339. |
| `SFX_0B6` | `SFX_SCOWLER_BLACKOUT` | `UpdateScowlerInkBlackout` starting `wScowlerBlackoutTimer`. Callers: level/objects/scowler.asm:1079. |
| `SFX_0BA` | `SFX_PUMP` | `PumpFunc`; also raise-ice-blocks cutscene. Callers: level/objects/yellow_belly.asm:968, overworld/bank27.asm:6678. |
| `SFX_0BB` | `SFX_PESCE_HIT` | Pesce being hit (`wPesceHits` incremented). Callers: level/objects/pesce.asm:74. |
| `SFX_0BC` | `SFX_JAMANO_TURN` | Jamano turning to face Wario. Callers: level/objects/jamano.asm:328. |
| `SFX_0BD` | `SFX_JAMANO_DEFEAT_POSE` | Jamano reaching the centre -> `.DefeatPose1`. Callers: level/objects/jamano.asm:353. |
| `SFX_0BE` | `SFX_PESCE_FLY` | `FlyFunc` init (Pesce's fly, drops `ObjParams_Cheese`). Callers: level/objects/pesce.asm:1163. |
| `SFX_0C0` | `SFX_MUDDEE_HURT` | `MuddeeFunc.hurt`. Callers: level/objects/muddee.asm:227. |
| `SFX_0C1` | `SFX_MUDDEE_BUBBLE` | `MuddeeFunc.PlayBubbleSFX`. Callers: level/objects/muddee.asm:813. |
| `SFX_0C2` | `SFX_MAGIC_SPIRAL_GROW` | `MagicSpiralFunc` -> `.Grow`. Callers: level/objects/wolfenboss.asm:577. |
| `SFX_0C3` | `SFX_WOLFENBOSS_HOVER` | `WolfenbossFunc.do_movement` hover (every 32 frames). Callers: level/objects/wolfenboss.asm:408. |
| `SFX_0C6` | `SFX_SHOOT_TAUNT` | `ShootFunc.Taunt`. Callers: level/objects/shoot.asm:110. |
| `SFX_0C7` | `SFX_SHOOT_GOAL` | Shoot goal (`wWarioGoals`, `.no_goal_increment`). Callers: level/objects/shoot.asm:568, level/objects/shoot.asm:1044. |
| `SFX_0C8` | `SFX_SHOOT_JUMP` | `ShootFunc.set_jumping_up`. Callers: level/objects/shoot.asm:275. |
| `SFX_0CA` | `SFX_BOSS_APPEAR` | Boss intros: Yellow Belly `.IntroFade1`, Muddee's turtle ambush. Callers: level/objects/yellow_belly.asm:48, level/objects/muddee.asm:956. |
| `SFX_0CD` | `SFX_HIDDEN_FIGURE_GRAB` | Hidden Figure hand catching Wario (`OBJSTATE_SPECIAL_3`, `wHiddenFigureBodyGrabResult = $80`). Callers: level/objects/hidden_figure.asm:1052. |
| `SFX_0CE` | `SFX_HIDDEN_FIGURE_HIT` | Hidden Figure face `.Hit`/`.Defeated` and the body's defeat flashing. Callers: level/objects/hidden_figure.asm:415, level/objects/hidden_figure.asm:566, level/objects/hidden_figure.asm:590. |
| `SFX_0CF` | `SFX_HIDDEN_FIGURE_DEFEATED` | `HiddenFigureFunc.Defeated` (`wHiddenFigureDefeatStarted = 1`). Callers: level/objects/hidden_figure.asm:409. |
| `SFX_0E2` | `SFX_MENU_SCROLL` | Menu cursor scrolling: pause menu, start menu (`.play_scrolling_sfx`), golf course menu, action help, language select, top bar, treasure collection. Callers: pause/pause_menu_2.asm:178, golf/building/building.asm:464, title/start_menu_selection.asm:61, action_help/common1.asm:262, +3 more. |
| `SFX_0E4` | `SFX_PAUSE` | `UpdateLevel.pause`; golf SELECT. Callers: level/update_level.asm:314, golf/hole.asm:889. |
| `SFX_0E5` | `SFX_ERROR` | Refused input: START while blind/boss (`UpdateLevel.no_pause`), not enough coins (golf), `.cant_scroll` (collection); also golf overlay text, bat idling. Callers: level/update_level.asm:310, level/wario_states_3.asm:4566, golf/hole.asm:562, golf/hole.asm:1917, +4 more. |
| `SFX_0E6` | `SFX_ENTER_DOOR` | `EnterDoor`; golf lobby up. Callers: level/block_functions.asm:866, golf/lobby.asm:279. |
| `SFX_0E7` | `SFX_MENU_CANCEL` | Pause menu B (`.Return`), golf pause cancel. Callers: pause/pause_menu_2.asm:220, golf/hole.asm:2732. |
| `SFX_0E8` | `SFX_GOLF_MISS` | Golf `.missed_1` (`GOLF_WARIO_MISSING`). Callers: golf/hole.asm:1418. |
| `SFX_0E9` | `SFX_MENU_OPEN` | Top bar opening after the bottom bar closes, `NOWFunc_DayNightSpell.StartOpenTopBar`; golf A. Callers: golf/hole.asm:898, overworld/bank20.asm:3469, overworld/bank2d.asm:3267. |
| `SFX_0EA` | `SFX_MENU_CLOSE` | Top bar closing with B/SELECT; golf power gauge at maximum. Callers: golf/hole.asm:1149, golf/hole.asm:1318, overworld/bank20.asm:3536. |
| `SFX_0EC` | `SFX_ACTION_HELP_BUTTON` | Action help flashing the D-pad/A/B button graphics. Callers: action_help/common1.asm:15, action_help/common1.asm:43, action_help/common1.asm:71, action_help/common1.asm:99. |
| `SFX_0ED` | `SFX_GOLF_CHARGE_SHOT` | `GolfHoleState_StartShot.ChargeShot`. Callers: golf/hole.asm:1391. |
| `SFX_0EF` | `SFX_GOLF_HOLE_IN` | `UpdateGolfParaGoomYPos.hole`. Callers: golf/hole.asm:1773. |
| `SFX_0FA` | `SFX_SUCCESS` | All flame-block torches lit (`wNumLitTorches == NUM_FLAME_BLOCK_TORCHES`); golf course record (`GOLF_WARIO_CLEARED`). Callers: level/objects/torch.asm:32, golf/hole.asm:2592. |
| `SFX_102` | `SFX_TREE_FALL` | `NOWFunc_CutTree.SetTreeFall`; also Cutscene06. Callers: overworld/bank27.asm:1552, overworld/bank2d.asm:2469. |
| `SFX_103` | `SFX_PATH_ARROW` | `UnlockLevel_ShowArrow1/2`; also Cutscene22. Callers: overworld/bank20.asm:4780, overworld/bank20.asm:4817, overworld/bank27.asm:2379. |
| `SFX_104` | `SFX_LEVEL_STAR` | `UnlockLevel_ShowStar`, `HighlightLevel.ShowStar`, prologue music box sparkles. Callers: overworld/bank20.asm:4898, overworld/bank20.asm:5050, overworld/bank2b_2.asm:400. |
| `SFX_105` | `SFX_GONG` | `SOWFunc_FullMoon.PlayGongSFX`; also Cutscene57. Callers: overworld/bank27.asm:4982, overworld/bank2d.asm:6594. |
| `SFX_106` | `SFX_EMOTE` | Exclamation/emote over Wario (`ShowExclamationMark`, `ShowEmote`, `SnapSFX`) and cutscenes 03/0a/38. Callers: overworld/bank2b_1.asm:3437, overworld/bank27.asm:1439, overworld/bank27.asm:1687, overworld/bank27.asm:3622, +4 more. |
| `SFX_107` | `SFX_HAMMER_BOT_WALK` | `HammerBotFunc.Walk`/`.Special2` (every 16/32 frames); also Cutscene22. Callers: level/objects/hammer_bot.asm:220, level/objects/hammer_bot.asm:342, overworld/bank27.asm:2386. |
| `SFX_108` | `SFX_GATE_OPEN` | `NOWFunc_OpenGate.OpenDoor`. Callers: overworld/bank2d.asm:2506. |
| `SFX_10A` | `SFX_FIX_ELEVATOR` | `UpdateCutsceneObjs_FixElevator` at animation end. Callers: overworld/bank27.asm:6053. |
| `SFX_112` | `SFX_ITEM_RAISE` | `.RaiseItem` steps of the item cutscenes (via `PlaySFX_112`, now `PlayItemRaiseSFX`). Callers: overworld/bank27.asm:1235. |
| `SFX_118` | `SFX_FLUTE` | `*OWFunc_SummonSnake.PlayFluteSFX`. Callers: overworld/bank2d.asm:2597, overworld/bank2d.asm:3953, overworld/bank2d.asm:6285. |
| `SFX_119` | `SFX_ITEM_FALL` | `*OWFunc_MagicSeed.PlayFallSFX`, `NOWFunc_Crayon.PlayFallSFX`, intro. Callers: title/intro.asm:570, overworld/bank2d.asm:2537, overworld/bank2d.asm:3047, overworld/bank2d.asm:3894, +1 more. |
| `SFX_11A` | `SFX_BEANSTALK_GROW` | `*OWFunc_MagicSeed.GrowStalk`; also Wormwould, Snake, full moon, epilogue, Cutscene44. Callers: level/objects/wormwould.asm:141, level/objects/snake.asm:105, overworld/bank2b_1.asm:314, overworld/bank27.asm:5461, +4 more. |
| `SFX_11B` | `SFX_TOWER_RISE` | `SOWFunc_RaiseTower.StartDust`. Callers: overworld/bank2d.asm:5957. |
| `SFX_11C` | `SFX_SEA_FREEZE` | `EOWFunc_FreezeSea`. Callers: overworld/bank2d.asm:6782. |
| `SFX_11D` | `SFX_TORNADO` | `WOWFunc_ClearTornado`, `UpdateOWTornado`, Cutscene1f. Callers: overworld/bank27.asm:3313, overworld/bank2d.asm:3818, overworld/bank2d.asm:3847. |
| `SFX_11E` | `SFX_YELLOW_MUSIC_BOX` | Yellow music box (`SOWFunc_YellowMusicBox`, `MusicBoxCutsceneFunc` case 1). Callers: overworld/bank27.asm:2566, overworld/bank2d.asm:5579. |
| `SFX_11F` | `SFX_BLUE_MUSIC_BOX` | Blue music box (`NOWFunc_PlayMusicBox` non-gold = `NOWFUNC_BLUE_MUSIC_BOX`, `MusicBoxCutsceneFunc` case 3). Callers: overworld/bank27.asm:2569, overworld/bank2d.asm:3010. |
| `SFX_120` | `SFX_GREEN_MUSIC_BOX` | Green music box (`SOWFunc_GreenMusicBox`, case 5). Callers: overworld/bank27.asm:2572, overworld/bank2d.asm:6420. |
| `SFX_121` | `SFX_RED_MUSIC_BOX` | Red music box (`WOWFunc_RedMusicBox`, case 7). Callers: overworld/bank27.asm:2575, overworld/bank2d.asm:4669. |
| `SFX_122` | `SFX_GOLD_MUSIC_BOX` | Gold music box (`NOWFunc_PlayMusicBox.gold_music_box`, case 9). Callers: overworld/bank27.asm:2578, overworld/bank2d.asm:3013. |
| `SFX_123` | `SFX_BRIDGE_LOWER` | `SOWFunc_YellowMusicBox.LowerBridge`. Callers: overworld/bank2d.asm:5587. |
| `SFX_124` | `SFX_LIGHTNING` | `SOWFunc_CanyonThunder`. Callers: overworld/bank2d.asm:5641, overworld/bank2d.asm:5818. |
| `SFX_127` | `SFX_VOLCANO_ERUPTION` | `EOWFunc_VulcanoEruption`. Callers: overworld/bank2d.asm:7790. |
| `SFX_128` | `SFX_WARPED_VOID_APPEAR` | `EOWFunc_ShowWarpedVoid`; also Cutscene24. Callers: overworld/bank27.asm:3211, overworld/bank2d.asm:8217. |
| `SFX_129` | `SFX_EXPLOSION` | `SOWFunc_GreenMusicBox.BlowUpCave`, `EOWFunc_Explosives`, zip line. Callers: level/objects/zip_line.asm:215, overworld/bank2d.asm:6433, overworld/bank2d.asm:6500. |
| `SFX_12A` | `SFX_STEP` | Map Wario walking (`wOWWalkSFXCounter`, via `PlaySFX_12A`, now `PlayStepSFX`), `PlaySceneWarioStepSFX`, prologue/epilogue get-up steps, golf building. Callers: overworld/bank20.asm:3078, overworld/bank2b_1.asm:775, overworld/bank2b_1.asm:4289, overworld/bank2b_2.asm:1013, +2 more. |
| `SFX_12B` | `SFX_PAY_COINS` | `GolfCourseMenu_PayCoins`. Callers: golf/building/building.asm:518. |
| `SFX_12D` | `SFX_CRAYON_SCRIBBLE` | `NOWFunc_Crayon.play_scribble_sfx`. Callers: overworld/bank2d.asm:3097. |
| `SFX_12E` | `SFX_CASTLE_FORM` | `EOWFunc_FormCastle`. Callers: overworld/bank2d.asm:7481. |
| `SFX_130` | `SFX_TEXT_PRINT` | `PrintText` per character. Callers: overworld/bank2b_1.asm:2279. |
| `SFX_131` | `SFX_TREE_MOUTH_OPEN` | `UpdateCutsceneObjs_OpenTreeMouth` at animation end. Callers: overworld/bank27.asm:6398. |
| `SFX_137` | `SFX_SCENE_WARIO_RUN` | `PlaySceneWarioRunSFX`. Callers: overworld/bank2b_1.asm:794. |

**Left numbered (56 with callers):** the callers do not show what the
sound stands for (an animation frame, a cutscene step or a boss state
with no clearer meaning), so these keep their numbers:

- `SFX_011`: overworld/bank2b_1.asm:1107 (`UpdateSceneWario.look_up_play_tiptoe_1`), overworld/bank27.asm:6186 (`UpdateCutsceneLevelObj_SummonSun.wait_frame_01`), overworld/bank27.asm:7212 (`UpdateCutsceneObjs_RevealDarkRoom.play_tiptoe_1`)
- `SFX_064`: level/objects/zombie.asm:375 (`ZombieFunc.asm_45d1d`)
- `SFX_07B`: level/objects/seeing_eye_door.asm:169 (`SeeingEyeDoorFunc.asm_455ba`), level/objects/seeing_eye_door.asm:211 (`SeeingEyeDoorFunc.asm_4561e`)
- `SFX_07F`: level/objects/tadpole.asm:105 (`TadpoleFunc.asm_49ee2`), level/objects/mizuuo.asm:110 (`MizuuoFunc.Update3`), overworld/bank2d.asm:5405 (`SOWFunc_SendSeeds.PlayFlyingSFX`), overworld/bank2d.asm:5448 (`SOWFunc_SendSeeds.start_seed1`), overworld/bank2d.asm:5467 (`SOWFunc_SendSeeds.start_seed3`)
- `SFX_088`: level/objects/omodonmeka.asm:361 (`OmodonmekaFunc.asm_423b8`)
- `SFX_08D`: level/objects/shoot.asm:630 (`ShootFunc.MoveLeftOrRight`), level/objects/shoot.asm:639 (`ShootFunc.moving_right`), level/objects/octohon.asm:270 (`BigOctohonFunc.asm_4a6f3`), overworld/bank27.asm:5490 (`Cutscene44Func.WaitThenPlaySFX08D`)
- `SFX_08F`: level/objects/big_leaf.asm:208 (`BigLeaf2Func.asm_42ccd`), overworld/bank27.asm:7460 (`UpdateCutsceneLevelObj_FeedOctohon.PlaySFX08FEvery40Frames`)
- `SFX_0A2`: level/objects/doll_boy.asm:229 (`DollBoyFunc.spawn_hammer`), level/objects/doll_boy.asm:623 (`DollBoyFunc.handle_walk_movement`)
- `SFX_0A6`: level/objects/wormwould.asm:212 (`WormwouldFunc.after_attack`)
- `SFX_0A8`: level/objects/yellow_belly.asm:553 (`YellowBellyBodyFunc.asm_51704`)
- `SFX_0AB`: level/objects/scowler.asm:377 (`ScowlerFunc.asm_54782`)
- `SFX_0AD`: level/objects/pesce.asm:560 (`PesceFunc.asm_52108`)
- `SFX_0AE`: level/objects/pesce.asm:274 (`PesceFunc.asm_51efc`)
- `SFX_0B0`: level/objects/anonster.asm:155 (`AnonsterFunc.asm_50118`)
- `SFX_0B1`: level/objects/anonster.asm:343 (`AnonsterFunc.StartRise`), level/objects/anonster.asm:817 (`AnonsterFunc.Hurt`), level/objects/anonster.asm:924 (`AnonsterFunc.Defeated`)
- `SFX_0B2`: level/objects/anonster.asm:865 (`AnonsterFunc.Recover2`), level/objects/muddee.asm:108 (`MuddeeFunc.spawn_stingers`)
- `SFX_0B5`: level/objects/scowler.asm:1071 (`UpdateScowlerInkBlackout.asm_54c31`)
- `SFX_0B7`: level/objects/shoot.asm:842 (`ShootFunc.Walk`), level/objects/scowler.asm:1068 (`UpdateScowlerInkBlackout.asm_54c27`)
- `SFX_0B8`: level/objects/scowler.asm:1090 (`UpdateScowlerInkBlackout.asm_54c5f`)
- `SFX_0B9`: level/objects/yellow_belly.asm:677 (`YellowBellyBodyFunc.asm_5180a`), level/objects/pesce.asm:253 (`PesceFunc.asm_51ed4`)
- `SFX_0BF`: level/objects/jamano.asm:881 (`SkullFunc.asm_553a8`)
- `SFX_0C4`: level/objects/wolfenboss.asm:991 (`IgaguriFunc.asm_564ce`), overworld/bank27.asm:4328 (`Cutscene3dFunc.WaitThenNextObj2StateSFX`), overworld/bank27.asm:7111 (`UpdateCutsceneObjs_SprayIronWall.play_sfx_0c4`)
- `SFX_0C5`: level/objects/wolfenboss.asm:975 (`IgaguriFunc.asm_564b1`)
- `SFX_0C9`: level/objects/shoot.asm:135 (`ShootFunc.asm_566a9`)
- `SFX_0CB`: level/objects/hidden_figure.asm:1213 (`HiddenFigureLeftHandFunc.asm_4d333`), level/objects/hidden_figure.asm:1581 (`HiddenFigureRightHandFunc.asm_4d5dc`)
- `SFX_0D0`: level/objects/hidden_figure.asm:1490 (`HiddenFigureRightHandFunc.asm_4d52d`), level/objects/hidden_figure.asm:1504 (`HiddenFigureRightHandFunc.asm_4d540`)
- `SFX_0D1`: level/objects/hidden_figure.asm:1479 (`HiddenFigureRightHandFunc.asm_4d50b`)
- `SFX_0EB`: overworld/bank20.asm:452 (`MapSide_Walk.walked_to_exit`), overworld/bank26.asm:512 (`HandleTreasureCollectionInput.page_turned`), overworld/bank26.asm:618 (`HandleTreasureCollectionInput.change_page`), overworld/bank2b_2.asm:3473 (`_UpdateEpilogue.WaitObj1ThenFlash`)
- `SFX_0EE`: golf/hole.asm:1999 (`GolfHoleState_SpecialTerrain.asm_1c9743`)
- `SFX_0F0`: golf/hole.asm:1968 (`GolfHoleState_SpecialTerrain.asm_1c9708`)
- `SFX_0F1`: overworld/bank2b_1.asm:1011 (`UpdateSceneWario.look_play_sfx`), overworld/bank27.asm:7215 (`UpdateCutsceneObjs_RevealDarkRoom.play_tiptoe_2`)
- `SFX_0F2`: overworld/bank2b_1.asm:1101 (`UpdateSceneWario.look_up_play_tiptoe_3`)
- `SFX_0F3`: overworld/bank2b_1.asm:703 (`UpdatePrologueSceneObj.State0a`)
- `SFX_0F4`: overworld/bank2b_1.asm:716 (`UpdatePrologueSceneObj.State0c`)
- `SFX_101`: level/objects/yellow_belly.asm:529 (`YellowBellyBodyFunc.asm_516ec`), level/objects/wolfenboss.asm:791 (`IgaguriFunc.done_grow`), overworld/bank27.asm:2663 (`Cutscene02Func.ShowCut`)
- `SFX_109`: overworld/bank27.asm:1800 (`Cutscene07Func.WaitObj2Frame00SFX`)
- `SFX_10B`: overworld/bank27.asm:1841 (`Cutscene07Func.PlaySFX10B`)
- `SFX_10C`: overworld/bank27.asm:1497 (`Cutscene03Func.PlaySFX10C`)
- `SFX_10E`: overworld/bank27.asm:2313 (`Cutscene1eFunc.SetObj2State01SFX`), overworld/bank27.asm:6769 (`UpdateCutsceneObjs_RemoveWarps.play_sfx_10e`)
- `SFX_10F`: overworld/bank27.asm:5715 (`Cutscene14Func.play_sfx_10f_every_10_frames`)
- `SFX_110`: overworld/bank27.asm:5742 (`Cutscene14Func.play_obj5_sfx`)
- `SFX_111`: overworld/bank27.asm:5745 (`Cutscene14Func.play_eruption_3_sfx`)
- `SFX_113`: overworld/bank20.asm:263 (`HandleTempleHintInput.show_hint`), overworld/bank20.asm:894 (`PathPreview_Wait`), overworld/bank27.asm:2105 (`Cutscene11Func.play_sfx_113`), overworld/bank27.asm:3147 (`Cutscene04Func.RaiseObj3SFX`), overworld/bank2d.asm:3183 (`NOWFunc_BottomBar.RaiseBBtnIndicator`), overworld/bank2d.asm:3210 (`NOWFunc_BottomBar.StartOpenBottomBar`)
- `SFX_114`: overworld/bank27.asm:5796 (`Cutscene14Func.play_eruption_4_sfx`)
- `SFX_115`: overworld/bank27.asm:5799 (`Cutscene14Func.play_eruption_5_sfx`)
- `SFX_116`: overworld/bank27.asm:5802 (`Cutscene14Func.play_eruption_6_sfx`)
- `SFX_117`: overworld/bank27.asm:2815 (`Cutscene0dFunc.PlaceObj3SFX`)
- `SFX_125`: overworld/bank2d.asm:8132 (`EOWFunc_BurnVines.burn_vines_1_sfx`)
- `SFX_126`: overworld/bank2d.asm:8135 (`EOWFunc_BurnVines.burn_vines_2_sfx`)
- `SFX_12C`: overworld/bank27.asm:3033 (`Cutscene49Func.WaitObj2State01ThenOpen`)
- `SFX_12F`: overworld/bank2d.asm:1828 (`PlaySFX12F`), overworld/bank2d.asm:6068 (`SOWFunc_Fan.StartFan`)
- `SFX_132`: overworld/bank27.asm:4466 (`Cutscene4aFunc.WaitObj2Frame06SFX`), overworld/bank27.asm:5102 (`Cutscene58Func.start_objs_10_and_11`), overworld/bank27.asm:6533 (`UpdateCutsceneObjs_MakeWire.PlaySFX132Every16Frames`)
- `SFX_133`: overworld/bank27.asm:6516 (`UpdateCutsceneObjs_MakeWire.PlaySFX133Every12Frames`)
- `SFX_134`: game_over/core.asm:76 (`UpdateGameOverScreen`)
- `SFX_135`: overworld/bank27.asm:7312 (`UpdateCutsceneLevelObj_OpenCraterHole.PlaySFX135Every27Frames`)
- `SFX_138`: overworld/bank2b_1.asm:200 (`UpdateEpilogueSceneObj.PlaySFXEvery30Frames`)

**Named afterwards by owner and order** (batch 23): sounds that only one
scene or object plays get its name, numbered in the order they play (or by
position in the code, for objects) when it plays several:
`SFX_VOLCANO_ERUPTION_1`..`6` (`10F`, `110`, `111`, `114`, `115`, `116`),
`SFX_FIX_ELEVATOR_1`/`2` (`109`/`10B`), `SFX_OPEN_NORTH_GATE` (`10C`),
`SFX_SUMMON_SNAKES` (`117`), `SFX_OPEN_GOLDEN_SNAKE_DOOR` (`12C`),
`SFX_MAKE_WIRE` (`133`), `SFX_OPEN_CRATER_HOLE` (`135`),
`SFX_BURN_VINES_1`/`2` (`125`/`126`), `SFX_GAME_OVER` (`134`),
`SFX_EPILOGUE_OBJ` (`138`), `SFX_PROLOGUE_1`/`2` (`0F3`/`0F4`),
`SFX_GOLF_SPECIAL_TERRAIN_1`/`2` (`0F0`/`0EE`), `SFX_ZOMBIE` (`064`),
`SFX_OMODONMEKA` (`088`), `SFX_WORMWOULD_ATTACK` (`0A6`), `SFX_DOLL_BOY`
(`0A2`), `SFX_SEEING_EYE_DOOR` (`07B`), `SFX_YELLOW_BELLY` (`0A8`),
`SFX_SCOWLER` (`0AB`), `SFX_SCOWLER_INK_1`/`2` (`0B5`/`0B8`),
`SFX_PESCE_1`/`2` (`0AE`/`0AD`), `SFX_ANONSTER_1`/`2` (`0B0`/`0B1`),
`SFX_JAMANO_SKULL` (`0BF`), `SFX_IGAGURI` (`0C5`), `SFX_SHOOT` (`0C9`),
`SFX_HIDDEN_FIGURE_HAND_1`..`3` (`0CB`, `0D0`, `0D1`). Their sound data
labels follow (`Sfx_VolcanoEruption1`, ...). Still numbered: the 15 shared
by unrelated callers (`011`, `07F`, `08D`, `08F`, `0B2`, `0B7`, `0B9`,
`0C4`, `0EB`, `0F1`, `101`, `10E`, `113`, `12F`, `132`) and `0F2`.

**Named by ear** (batch 25, by Taro, from recordings of each sound):
`SFX_TIPTOE_1`/`2`/`3` (`011`, `0F1`, `0F2`; "tiptoe" is Taro's own name
for these little steps in the scenes), `SFX_PAGE_TURN` (`0EB`),
`SFX_ACTION_B` (`113`, the B button indicator and other UI that appears),
`SFX_TURN` (`132`), `SFX_PESCE_3_YB_2` (`0B9`, shared by Pesce, where it
plays when Pesce lets Wario go in the water, and Yellow Belly, at the end
of a palette flash; it sounds close to the swim sound), and
`SFX_TIPTOE_2_B_UNUSED` (`136`: the same notes, tempo and envelope as
`SFX_TIPTOE_2`, on the second square channel, `CHAN6`, instead of the
first; nothing plays it). Then `SFX_BIG_OCTO_1`/`2` (`08D`/`08F`, Big Octohon and the feed Octohon
cutscene; `08D` also plays for Shoot, `08F` for Big Leaf 2) and
`SFX_CHOP_TREE` (`101`, the cut tree cutscene; also Yellow Belly and
Igaguri). Still numbered: `07F`, `0B2`, `0B7`, `0C4`, `10E`, `12F`.

**Unused, left numbered:** `SFX_136` has its own sound data (`Sfx_136`) but
nothing plays it; its constant comment now says "(unused)". The 58
constants already marked "(unused)" (`SFX_04D`-`SFX_060`,
`SFX_090`-`SFX_0A0`, `SFX_0D2`-`SFX_0E0`, `SFX_0FB`-`SFX_100`) are
`filler_sounds` slots in `SoundHeaders` that point at
`Music_OutOfTheWoodsDay`: there is no sound behind them to name.

Names with the least support (one caller whose meaning is read from the
state it sets): `SFX_BIRD_ALERT`, `SFX_BIRD_TAKE_OFF`, `SFX_BARREL_JUMP`,
`SFX_SCOWLER_STOMPED`, `SFX_JAMANO_DEFEAT_POSE`, `SFX_BOSS_APPEAR`,
`SFX_WHIRR` (a neutral name for a periodic buzz shared by five objects)
and `SFX_EAT_FOOD` (also played twice on the musical coin screen).

## Sixth pass: substates and other constants

This pass covers the numbered and `UNK` constants that the SFX, object
state/interaction and RAM passes don't, plus every identifier in `src/`
still containing `unk`. Each change went in as it was made (three commits),
so the tables show the names as they were before this pass. The ROM stays
byte-identical.

### Substates

Each substate constant names the first entry of a group in its state
table. Raw `wSubState` values were replaced only where the state table
shows which entry they pick.

| Old | New | Evidence | Conf. |
|---|---|---|---|
| `SST_OVERWORLD_08` | `SST_OVERWORLD_MAP_SIDE` | overworld/state_table.asm:15: `FadeBGToWhite_Normal`, then `InitMapSide`, `DarkenBGToPal_Normal`, `UpdateMapSide`. The collection, best times, golf building and temple scenes set it when they exit (bank26.asm:463, bank56.asm:1295, bank2b_1.asm:2081, :4072). | high |
| `SST_OVERWORLD_09` | `SST_OVERWORLD_INIT_MAP_SIDE` | state_table.asm:16 `InitMapSide`. init.asm:97 sets it to show the map without a scene. | high |
| `SST_OVERWORLD_0B` | `SST_OVERWORLD_UPDATE_MAP_SIDE` | state_table.asm:18 `UpdateMapSide`. tests/game.py waits for it as "map is idle and accepts input". | high |
| `SST_OVERWORLD_1A` | `SST_OVERWORLD_TEMPLE` | state_table.asm:37: fade, `InitTempleScene`, `UpdateTempleScene`. `HandleEnterLevelInput` sets it at the Temple (bank20.asm:549). | high |
| `SST_OVERWORLD_1E` | `SST_OVERWORLD_TO_GOLF_BUILDING` | state_table.asm:41 `ExitTempleScene`, followed by a fade and `GolfBuilding` (`SST_OVERWORLD_GOLF_BUILDING`, $20). Only `MapSide_ChangeSide` sets it (bank20.asm:518). The temple scene never reaches it: it sets `SST_OVERWORLD_MAP_SIDE` (bank2b_1.asm:2081) or goes to `ST_LEVEL`. | medium |
| `SST_PAUSE_18` | `SST_PAUSE_SAVE_AND_CONTINUE` | pause/state_table.asm:33: `InitSaveScreenAndBackupVRAM` .. `Save` .. `TransitionAfterSave` (pause/save/save.asm:587: map, epilogue or game over). `SaveGameOrEnterPerfectScreen` sets it (home/update_level_music.asm:23). | high |
| `SST_PAUSE_28` | `SST_PAUSE_SAVE_AND_RESET` | pause/state_table.asm:51: the same save sequence, ending in `ResetAfterSave` (`jp Init`, save.asm:627). The perfect screen sets it (perfect/core.asm:112). | high |
| `$04`, `$05` (title) | `SST_TITLE_INTRO_PHASE2`, `SST_TITLE_INTRO_PHASE3` | title/state_table.asm:15-16. `ScrollIntroClouds` compares against them (title/intro_animation.asm:112-130). | high |
| `$04` (overworld) | `SST_OVERWORLD_FADE_TO_OW_SCENE` | state_table.asm:9: the `SlowFadeToWhite` before `InitOWScene`. Set when the next scene is on another map side (bank20.asm:1544). | high |
| `$08`, `$0c` (overworld) | `SST_OVERWORLD_MAP_SIDE`, `SST_OVERWORLD_COLLECTION` | bank26.asm:463/514/619, bank2b_1.asm:4072, bank56.asm:1295. | high |
| `$02` (level) | `SST_LEVEL_FADE_IN` | level/state_table.asm:7 `SlowFadeFromWhite`. `StartRoom_FromTransition` returns to it (level/start_room.asm:140). | high |
| `$04`, `$08` (golf building) | `SST_GOLF_BUILDING_HOLE`, `SST_GOLF_BUILDING_EXIT` | golf/building/state_table.asm:9 (fade, `InitGolfHole`) and :13 (`ReturnToMap`). Used in golf/building/building.asm:221/422/532 and golf/hole.asm:2560 (the next hole of a course). They have the same values as `SST_GOLF_HOLE` and `SST_GOLF_EXIT`, so `HandleGolfHole` works in both states. | high |
| `$08` (golf, hole.asm:2524) | `SST_GOLF_EXIT` | Minigame already cleared: back to the level. | high |
| `$03` (perfect) | `SST_PERFECT_UPDATE` | perfect/state_table.asm:8 `UpdatePerfectScreen`; perfect/core.asm:65-67. | high |

### Audio

| Old | New | Evidence | Conf. |
|---|---|---|---|
| `AUDIOCMD_UNK_C9` / macro `audiocmd_c9` | `AUDIOCMD_FREQUENCY_OFFSET` / `frequency_offset` | The handler `AudioCmd_SetChannelFrequencyOffset` (audio/engine.asm:1757) stores the signed argument in `CHANNEL_FREQUENCY_OFFSET` and sets `CHANFLAGS_UPDATE_FREQUENCY`. | high |
| `AUDIOCMD_UNK_CA` / macro `audiocmd_ca` | `AUDIOCMD_SET_UNUSED_1E` / `set_unused_1e` | The handler `AudioCmd_SetChannelUnused1e` (engine.asm:1778) stores into `CHANNEL_UNUSED_1E`, which nothing reads. No sound uses either command. | high |
| `AUDIOMOD_UNK` | `AUDIOMOD_RELEASE` | Table entry `AudioMod_Release` (engine.asm:1796): `AudioModSetValue_Long` (:901) writes params 1 and 2 to `CHANNEL_RELEASE_VOLUME` and `CHANNEL_RELEASE_LENGTH`. | high |
| `TRACK_UNK0E` | `TRACK_FREQUENCY_NOTE` | Set to pitch + semitone offset, or to the percussion entry's sixth byte (engine.asm:1933-1941, :2093). `SetFrequency` adds the high byte of `CHANNEL_FREQUENCY` to it and passes the result to `GetNoteFrequency` (:2731). | high |
| `CHANFLAGS_5` | `CHANFLAGS_LOADED` | Set by `LoadChannelWithSound` (engine.asm:585). `InitChannel` replaces it with `CHANFLAGS_6`. | high |
| `CHANFLAGS_6` | `CHANFLAGS_INITIALISED` | Set by `InitChannel` (:624). `UpdateChannel` (:996) keeps calling `InitChannel` until it is set. `RefreshChannel` (:985) and `ProcessTrack` both require it. | high |
| `TRACKFLAGS_7` | `TRACKFLAGS_ACTIVE` | `TickSFXTrack`, `TickMusicTrack` and `ProcessTrack` return when it is clear (:2161, :2226). `StopTrack` zeroes the flags. | high |
| `TRACKFLAGS_5` | `TRACKFLAGS_HELD` | Set when a note starts (:2052). Cleared by `ReleaseTrack` (:2212) and in the release phase (:2483). Note-off only matches tracks that have it set (:2137). | medium |
| `TRACKFLAGS_6` | `TRACKFLAGS_START_ENVELOPE` | Set at note start and by `ReleaseTrack`. `ProcessTrack` clears it (:2276) and sets up either the fade-in envelope (when `HELD` is set) or the fade-out one. | medium |
| `channel_struct` fields `Unk0a`..`Unk3b` | `NoteVolume`, `NoteDuration`, `PitchOffsetMod`, `VolumeMod`, `PitchOffset`, `PitchOffsetMult`, `PitchProduct`, `FrequencyOffset`, `Unused1e`, `VibratoAmplitudeMod`, `VibratoFreqOffset`, `CallDepth`, `ReleaseVolume`, `ReleaseLength`, `LoopCounter`, `EffectiveVolume`, `Unused30`, `Unused31`, `CallStack` (ds 10) | The offsets match the `CHANNEL_*` constants (macros/wram.asm). No code uses the `wChannelN*` labels. The struct size is unchanged ($3c). | high |
| `track_struct` fields `Unk02`, `Unk03`, `Unk06`, `Unk0d`..`Unk0f`, `Unk14`..`Unk17` | `Owner`, `Note`, `NoteVolume`, `Unused0d`, `FrequencyNote`, `Unused0f`, `Unused14`..`Unused17` | The offsets match the `TRACK_*` constants. | high |
| comment `CHANNEL_UNK_2E` | `CHANNEL_UNUSED_1E` | engine.asm:670 initialises offset $1e, right after `CHANNEL_FREQUENCY_OFFSET`. | high |
| sound header byte 3 "unknown" | "unused" | `GetSound` skips it (`inc hl`, engine.asm:567). | high |

`TickTrackDuration` compared the flags of the track's channel against
`TRACKFLAGS_6 | TRACKFLAGS_7`. It now uses
`CHANFLAGS_INITIALISED | CHANFLAGS_ACTIVE`, which has the same value
(engine.asm:2195).

### Other constants and identifiers

| Old | New | Evidence | Conf. |
|---|---|---|---|
| `GRAB_UNK_02` | `GRAB_PICK_UP_BLOCKED` | Set when the object being picked up hits a block at the side or above (level/update_objects.asm:1339, :1549, after `ProcessBlock_Side`/`ProcessBlock_UpSide`). `UpdateState_PickingUp` then goes straight to grab idling (wario_states_1.asm:2706-2708, where a raw `cp $02` was replaced). | high |
| `ROOMTRANSITION_4` | `ROOMTRANSITION_ROOM_EXIT` | Only `BlockFunc_RoomExit*` and `BlockFunc_WaterRoomExit*` set it (block_functions.asm:1014-1047). | medium |
| `ROOMTRANSITION_5` | `ROOMTRANSITION_LADDER` | Only the ladder room exits set it (block_functions.asm:479, :492). | medium |
| `ROOMTRANSITION_8` / `UnreferencedBlockFunc_Transition8Door` | `ROOMTRANSITION_UNUSED_DOOR` / `UnreferencedBlockFunc_UnusedDoor` | Only that unreferenced block function sets it, together with the door flags (block_functions.asm:978). | medium |
| `EVENT_00` / `.event_00` | `EVENT_NONE` / `.event_none` | `GetEventWithTreasure` and `CheckIfTreasureUnlocksEvent` return it when no event matches (overworld/bank20.asm:1465-1484, :1624). Its cutscene entries are `.InvalidCutscene` and `NoInitCutscene`. | high |
| `SCENEWARIO_GROUP_19` | `SCENEWARIO_GROUP_09` | It is the tenth group: `SetSceneWarioState` counts `b` up through the groups in order (bank2b_1.asm:1343-1382). The other groups are numbered 00-08 and 10-13. | high |
| `gfx/wario/unk2.png`, `unk3.png`, `unk5.png` | `crash.png`, `music_box.png`, `show_music_boxes.png` | The files of `WarioCrashGfx`, `WarioMusicBoxGfx` and `WarioShowMusicBoxesGfx` (overworld/bank76.asm:253-266). | high |
| `DebugUnknownTextGfx` / `gfx/debug_unknown_text.png` | `UnreferencedDebugTreasureTextGfx` / `gfx/debug_treasure_text.png` | Nothing references it. The tiles spell "Debug", "GET takara", "ALL GET", "takara zukan". | medium |
| comments `unk7`, `unk6`, `unk01`, `unk02` | scene obj `MovementStep`, `state`, map ptr lo/hi, `OBJ_MAP_PTR_HI`, `OBJ_ID` | home/overworld.asm:396/405 and bank2b_1.asm:193 (offset 7 of a `scene_obj_struct`); bank2d.asm:1265 (offset 6); block_functions.asm:3232 (`wCurObjMapPtrLo` + 0/1); block_queue.asm:87; home/object_mechanics.asm:6 (`UpdateObjSprite` gets `l` = `wObjNId`, and bits 4-6 pick the OAM bank); doll_boy.asm:1057. | high |

### Left

- `WarioUnk4Gfx` / `gfx/wario/unk4.png` (`SCENEWARIO_GROUP_09`): its
  animations are `JUMP_AND_BOW`, `SNAP_FINGERS`, `SHOW_MUSIC_BOXES_1`/`_5`,
  `PANIC_JUMP`, `PANIC` and `BOW`, used by the prologue and temple scenes.
  No single theme covers them, so the sheet has no name yet.
- `CHANFLAGS_3`, `TRACKFLAGS_0`..`TRACKFLAGS_3`: no code uses them by name.
  Raw bit tests weren't checked.
- `TRACKFLAGS_4`: set at note start and on release, cleared after the first
  fade-in step (engine.asm:2362). Combined with `HELD` it selects the
  envelope phase in `ProcessTrack`. The individual phases weren't worked
  out.
- `ow_coord`'s `\3`/`\4` "unknown 1/2" (data/overworld/level_coordinates.asm)
  are comments, not identifiers.
- Found but not changed: `ExitTempleScene` (overworld/temple/common.asm:9)
  is the routine for `SST_OVERWORLD_TO_GOLF_BUILDING`, which only
  `MapSide_ChangeSide` sets. The label is probably wrong, and so is its row
  in the second-pass table ("the fight"). Renaming labels is outside this
  pass.

## Object state literals

The raw numbers that are object states, actions or interaction types
were replaced by the constants from the sixth pass: 972 lines, 886
states, 75 actions and 11 interaction types. A small register tracker
found them: it follows `a`-`e`, `hl` and `de` through each file, merges
the values at labels and jumps, and marks a literal when it reaches
`wCurObjState`/`OBJ_STATE`, `wCurObjAction`/`OBJ_ACTION` or the
interaction type field, or when `cp` compares it with a value loaded from
one of them. Every hit was checked by hand. Literals on positions,
timers, frame durations and grab results next to state code were left
alone. The ROM was byte-identical after every batch.

- Actions: `$81`/`$8f`/`$9f` and `N | (1 << 7)` became
  `no_actions_for 1`/`15`/`31` (also `7` and `2` in `DoObjectAction` and
  `load_objects.asm`).
- Interactions: `and $7f` became `INTERACTION_MASK` (Brrr Bear, Robo
  Mouse), and Muddee's `cp $48`/`$47` and Robo Mouse's `cp $0b` became
  `OBJ_INTERACTION_*`.
- `$18`/`$19`: Appleby and the doughnuts compare against
  `OBJSTATE_TRIGGERED` (eaten) and `OBJSTATE_NO_EFFECT` (restart); the
  invisibility potion, the owl and falling snow against
  `OBJSTATE_TRIGGERED`. No grabbable object had a raw `$18`/`$19`.
- After `and $fe` (which keeps only the left variant of a LEFT/RIGHT
  pair), the `cp` uses the LEFT name with `; or ..._RIGHT`, as
  `update_objects.asm` already did.
- `data/object_params.asm`: the 98 `db $00 ; state` are
  `OBJSTATE_DEFAULT`; Fly and Tadpole start in `OBJSTATE_5A`.

**By file** (lines; `obj/` = `src/engine/level/objects/`): `data/object_params.asm` 100,
`update_objects.asm` 16, `load_objects.asm` 1; `obj/` mad_scienstein 60,
doughnuteer 58, hammer_bot 51, para_goom 49, fire_bot 46, spear_bot 46,
brrr_bear 43, silky 42, beam_bot 40, teruteru 32, prince_froggy 26,
robo_mouse 25, shoot 25, hidden_figure 24, anonster 22, omodonmeka 21,
haridama 19, doll_boy 18, appleby 16, tadpole 15, barrel 14, kushimushi
14, rock 14, wormwould 14, yellow_belly 14, bird 12, jamano 12, hand 10,
scowler 8, pesce 7, pneumo 7, water_drop 6, wolfenboss 6, octohon 5,
snake 5, small_leaf 4, zombie 4, count_richtertoffen 3, hebarii 3,
spearhead 3, big_leaf 2, muddee 2, pillar_platform 2, coin 1 (an
action), falling_snow 1, muddee_stinger 1, owl 1, togeba 1, water_spark 1.

**Object-local aliases** (defined at the top of each object file), where
the branch labels show what the state does:

| Alias | Value | Evidence |
|-------|-------|----------|
| `OBJSTATE_DOLLBOY_JUMP_DOWN` / `_JUMP_UP` | `5A` / `5B` | `.WalkingPhase` jumps to `.jump_platform_below` / `.jump_platform_above`; set by the "jump to platform below/above" code. |
| `OBJSTATE_DOLLBOY_STUNNED` | `5C` | Set by `.set_stunned`, handled by `.update_stunned`. |
| `OBJSTATE_WORMWOULD_SHOOT_ROCK_HIGH` / `_LOW` / `_BURROW` | `5A` / `5B` / `5C` | `.Main` jumps to `.shoot_rock_high` / `.shoot_rock_low` / `.burrowing`; `5C` is set by `.set_burrowing` and `.hurt`. |
| `OBJSTATE_OMODON_PRESS_WARIO` | `5A` | `OmodonFunc.Update`: set by `.StartPressWario` (from `OBJSTATE_ACTIVATE`), handled by `.PressWario`. |
| `OBJSTATE_ANONSTER_SPIT_WAVES` | `5B` | `.OnFloor` jumps to `.spit_waves`. Anonster's `5A` and `5C` stay numbered. |
| `OBJSTATE_HARIDAMA_UNCURL` | `5B` | `.Update` jumps to `.Uncurl`. Haridama's `5A` stays numbered. |

The other `2B`, `2C`, `5A`-`5C` uses (Doughnuteer, Mad Scienstein,
Para-Goom, Fire Bot, Spear Bot, Teruteru, Jamano, Appleby, Pesce/Fly,
Water Drop, Robo Mouse, Scowler, Prince Froggy, Pillar Platform) use the
numbered constants, because their handlers don't have descriptive
labels yet. No object writes `1D`-`1F`, `3D`, `3E` or `5D`.

**Left raw:**

- `obj/coin.asm`: 37 state literals (31 in the code, 6 `move_coin`
  arguments). `CoinFunc` has its own 27-entry table (`.Move1Start` ...
  `.State18`, `.Init`, `.StartMovement`) that doesn't follow the shared
  meanings: `$0c` is `.FallLeftStart`, not `HIT_WARIO_LEFT_START`, so the
  shared names would be wrong. Only `$18` (`OBJSTATE_TRIGGERED`, collected)
  and `$19` (`OBJSTATE_COIN_INIT`) have names that fit. Naming the coin
  states is a separate job.
- The 23 `and $fe` masks on a state: they are bit masks, not states.
- Scene object states (`wCurSceneObjState`, intro and overworld scenes)
  are a different system and were not touched.

**Findings:**

- Pillar Platform compares its state with `OBJSTATE_2B`
  (`obj/pillar_platform.asm:78`, which sends it to `.Rise`), but nothing
  sets `$2b` on it: the only writers of `$2b` are Doughnuteer and Mad
  Scienstein, and only on themselves. The branch looks unreachable.
- Yellow Belly's pump (`PumpFunc.OnFloor`) stores `OBJSTATE_RESIST_VANISH`
  into `wYellowBellyHitRequest` too (`obj/yellow_belly.asm:957-959`). That
  variable is only tested for zero, so the state value doubles as a
  "hit" flag.
- `5A` is also the spawn state of Fly and Tadpole (`data/object_params.asm`).
  Fly then goes through `5A`, `5B` and `5C` as its own sequence
  (`obj/pesce.asm:1170`), and Tadpole's `.Update` never checks for `5A`.
  So `5A` doesn't mean the same thing in every object.
