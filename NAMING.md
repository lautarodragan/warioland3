# Naming survey: unnamed labels and proposed names

Research notes for renaming unnamed labels in this disassembly. Nothing in the
code has been changed; every entry below is a proposal for a human to accept
or reject.

## Progress

- [x] Inventory and plan (this section and the two below)
- [x] Phase 1: WRAM / SRAM / HRAM unnamed variables (all 88 address-named labels; `wUnused_*` left as is)
- [x] Phase 2: home bank (`src/home/`) `Func_` routines (all 72), incl. the bank $18 targets of the `homejp` trampolines, the block-probe family in collisions.asm, and the object Y-velocity tables
- [x] Phase 3: fork focus areas: camera/floor transitions (incl. the swapped `FLOOR_TRANSITION_*` flags), level scrolling, room start, save code, pause tilemap, object interaction handlers `OBJ_INTERACTION_00`-`0B`. Debug menu and owl code have no unnamed labels left. Not done in this phase: interaction handlers `Func_21xxx` (`OBJ_INTERACTION_31` and up) and the remaining local `.asm_` labels of validate_save.asm.
- [ ] Phase 4: rest of the level engine (`src/engine/level/*.asm`, block functions)
- [ ] Phase 5: `unk` fields in structs and constants
- [ ] Phase 6: object-local `.Func_` states in `src/engine/level/objects/`
- [ ] Phase 7+: overworld, action help, data/framesets/OAM/palettes, audio

**Resume at:** Phase 4 (rest of the level engine: wario_states_*.asm, block_functions.asm).

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
| `Func_20939` | :1170 | `BumpOffObject` | Unless `wTouchState` overrides: `OBJACTION_06` and `DoJumpingBump` away from the object (walk gfx, `Frameset_14a76/79`). | high |
| `Func_20932` | :1166 | `AttackOrBumpOffObject` | `AttackObject` if `wAttackCounter`, else `Func_20939`. | high |
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
