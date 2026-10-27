# Graphics and memory map

Where things live: VRAM and palettes during a level, the WRAM, SRAM and
HRAM banks, and the ROM's banks. Addresses are from `warioland3.map` and
`warioland3.sym`, which `make` writes next to the ROM.

## VRAM during a level

The level runs with `LCDC_DEFAULT` (`src/constants/misc_constants.asm`):
background and 8×16 sprites on, window off, background tiles addressed from
`$8800` (tiles `$00`-`$7f` at `$9000`, `$80`-`$ff` at `$8800`). The Temple
also turns the window on, at `$9c00`, for the hidden figure.

| Range | VRAM0 | VRAM1 |
|---|---|---|
| `$8000`-`$87ff` | Wario's current graphics, 128 tiles (`LoadWarioGfx`, by DMA in V-Blank) | enemy slots 1 and 2 |
| `$8800`-`$8fff` | `LevelsCommonGfx` (`LoadLevelCommonGfxAndTreasures`), with the level's treasures at `$8900`-`$89ff`; also background tiles `$80`-`$ff` | enemy slots 3 and 4 |
| `$9000`-`$97ff` | room main tiles (`LoadRoomMainTiles`): background tiles `$00`-`$7f` | room special tiles (`LoadRoomSpecialTiles`); the room's animated tiles overwrite `$9700`-`$977f` |
| `$9800`-`$9bff` | BG map 0: the level, one sector's worth (32×32 tiles) | BG map 0 attributes |
| `$9c00`-`$9fff` | BG map 1: The Temple's window | BG map 1 attributes |

Notes:

- The four enemy slots are 64 tiles each; which object uses which is up to
  the room's object group (see [Objects](objects.md#object-groups)).
- `UpdateRoomAnimatedTiles` copies 8 tiles to VRAM1 `$9700`, one of four
  frames of the room's animated tiles group (`AnimatedTilesGfx`, bank `$34`),
  every `wAnimatedTilesFrameDuration` frames.
- A block is 2×2 tiles: `wRoomBlockTiles` (WRAM0 `$c600`) has the 4 tile
  numbers of each of the 128 block types, `wRoomBlockAttributes` (WRAM bank 3,
  `$d300`) their 4 attributes. The attribute's VRAM bank bit picks main
  (VRAM0) or special (VRAM1) tiles.
- Menus that cover the level (pause, debug menu, golf) save all of VRAM to
  WRAM banks 4-7 first (`SaveBackupVRAM`) and restore it on the way back
  (`LoadBackupVRAM`, `src/home/backup_vram.asm`).

## Palettes

The game keeps target palettes in WRAM0: `wTempPals1` (`$c000`, the 8 BG
palettes) and `wTempPals2` (`$c040`, the 8 object palettes). The fades in
`src/home/fade.asm` step every colour of both towards or away from white in
`wTempBGPals`/`wTempOBPals` and write them to the hardware from a temporary
V-Blank handler.

| Palette | Set by |
|---|---|
| BG 0-7 | `LoadRoomPalettes`: the room's `ROOM_PAL_*` from `RoomPals` (`Level Palettes`, bank `$33`). A palette cycle (`wRoomPalCycle`) rewrites all 8 from a sequence of `RoomPals` entries (`UpdateRoomAnimatedPals`) |
| OBJ 0-1 | Wario (`wWarioPalsPtr`): `WarioDefaultPal` at level start, other palettes for some transformations (`SetWarioPal`) |
| OBJ 2 | `Pals_d1fe`, set at level start |
| OBJ 3 | the chest, key and musical coin colour from the object group's common objects |
| OBJ 4-7 | the four enemy slots, from the object group |

A restored save takes palettes 4-7 from `wSavedEnemyPals`.

## WRAM

The CGB has 8 WRAM banks of 4 KB; `$c000`-`$cfff` is always bank 0 and
`$d000`-`$dfff` is the bank in `rWBK` (0 selects bank 1).

| Bank | Range | What |
|---|---|---|
| 0 | `$c000` | palettes, `wState`/`wSubState` (`$c09b`), general variables |
| 0 | `$c200`-`$c3ff` | `wVBlankFunc`: the V-Blank handler and the VRAM0 half of the tile queue code |
| 0 | `$c400` | `wLCDFunc`, the LCD interrupt handler |
| 0 | `$c600` | `wRoomBlockTiles` |
| 0 | `$c800`-`$c9ff` | `wVBlankFuncExtended`: the VRAM1 half of the tile queue code |
| 0 | `$ca00` | progress: `wLevel`, `wDayNight`, `wPowerUpLevel`, ... |
| 0 | `$ca5b` | level and Wario: `wWarioYPos`, `wWarioState`, `wTransformation`, `wCameraSCY`, ... |
| 0 | `$cc00` | `wVirtualOAM`, `wParticles` (`$cca0`), `wBlockFunctionTable` (`$cd00`), the tile queues (`$ce01`) |
| 0 | `$cf00`-`$cfff` | the stack |
| 1 | `$d000` | `wObjects` (8 slots), `wCurObj` (`$d100`), `wObjDataPointers` (`$d120`), other object variables |
| 1 | `$d800` | golf |
| 2 | `$d000` | `wTreasuresCollected` and other game progress, the overworld's variables, `wTileBuffer` (`$dc00`) |
| 3 | `$d000` | the audio engine's variables |
| 3 | `$d280` | "GFX RAM": `wBackupPals`, `wRoomBlockAttributes`, door transition and menu variables |
| 4-7 | `$d000`-`$dfff` | `SaveBackupVRAM`'s copy of VRAM: VRAM0 `$8000`, VRAM0 `$9000`, VRAM1 `$8000`, VRAM1 `$9000` |

This fork also uses unused parts of WRAM bank 3 (`$d600`, "Owl Slot WRAM")
and bank 1 (`$d700`) for the [debug owl](debug-owl.md).

### Shared bytes and `UNION`s

Many variables share their bytes with others that are never live at the
same time; `src/ram/wram.asm` writes each sharing as a `UNION`, with one
`NEXTU` per user, so that every routine reads the name of its own
variable. The largest ones:

- bank 2 `$d140`-`$d17f`: Scene Wario (`wSceneWario`), the path preview's
  sprites (`wOWUIObj1`-`8`), the map-side scenes' scratch (`wOWSceneShake*`,
  `wOWSceneSFXLoop*`, ...) and the freeze-sea tile column copies
  (`wOWTileColumnCopy1`-`3`);
- bank 2 `$d800`-`$dfff` (`wOWSharedRAM`): the path tracers
  (`wOWPathTracer1`-`4`) and the scene/temple/text variables after them,
  the palette fade structs (`wFadePals`), the collection screen, and a
  `NEXTU` each for the best time list, the cutscenes and the golf
  building scene;
- bank 1 after `wWarioGoals`: one `NEXTU` per boss;
- bank 1 `$d900`: the golf course menu's tilemap / the pin flag tiles.

Because the bank in `rWBK` decides which variable an address means, a
label from another WRAMX bank in code that runs with a different bank
mapped is a mislabel (the overworld runs with bank 2, levels with bank 1).
A few were fixed this way, for example `LoadBGMapsToWRAM`'s tilemap,
which was written to the bank 3 label `wBackupSCY` but is `wTilemap`.

## SRAM

32 KB of battery-backed RAM in four 8 KB banks, mapped at `$a000`. Writing
`$0a` to `$0000`-`$1fff` enables it; any other value disables it (see the
[debug owl](debug-owl.md#the-corruption-despawnobject-writing-to-0000) for
what that does to a level).

| Bank | What |
|---|---|
| 0 | the save: check values, counters, game data and its backups, checksums (`src/ram/sram.asm`) |
| 1 | `sLevelBlockObjectMap`: level map rows 0-31 |
| 2 | `sLevelBlockObjectMap2`: rows 32-47 (`$a000`-`$afff`), then `sBackupLevelBlockObjectMap2` |
| 3 | `sBackupLevelBlockObjectMap` |

The level map's layout is in
[Levels, rooms and doors](levels-and-rooms.md#the-level-map-in-sram).

## HRAM

`$ff80`-`$ff96` is `hCallFunc` (the far call routine, with `hCallFuncBank`
and `hCallFuncPointer` inside it, see
[Game states](game-states.md#far-calls-and-banks)). The rest
(`src/ram/hram.asm`) has `hTransferVirtualOAM` (the OAM DMA routine),
`hPos` (`hYPosHi`, `hYPosLo`, `hXPosHi`, `hXPosLo`, the position block and
object lookups work on), temporaries, `hSFXID`/`hMusicID`, `hCGB` and
`hDemoPowerUp`.

## ROM

2 MB, 128 banks of 16 KB, MBC5 with RAM and battery (`rgbfix` in the
`Makefile`). `src/layout.link` places every section in its bank;
`warioland3.map` lists each bank's sections, labels and free space. In
rough groups:

| Banks | What |
|---|---|
| `$00` | home: interrupt vectors, `Start`, the main loop, V-Blank, shared routines (`src/home/`) |
| `$01` | `MainStateTable`, title, language selection, common state code |
| `$02` | "Level Engine": the level's substates, `UpdateLevel`, rooms, camera, scrolling |
| `$03` | `LevelsCommonGfx`, Wario's palettes, particles, the debug menu (this fork) |
| `$04`, `$09`, `$0b`, `$7a` | Wario's graphics |
| `$05`, `$7f`, `$77` | Wario's OAM and framesets |
| `$06`, `$07`, `$0a`, `$7b` | Wario's states; `$06` also has the block functions and collision |
| `$08` | object interactions, row block queue |
| `$0c`-`$0f` | audio engine, music, SFX |
| `$10`-`$15`, `$18` | object update functions (`$18` also `UpdateObjects`) |
| `$19` | object loading, object data, object groups |
| `$1a` | object framesets |
| `$20`-`$2f` | overworld, cutscenes and their graphics |
| `$30`, `$31` | level map pointers, room headers and room data |
| `$32`, `$50` | block function tables |
| `$33` | level palettes |
| `$34` | animated tiles |
| `$35`-`$37` | clear screen, game over, perfect |
| `$38`-`$49` | "Level Data 1"-"18": compressed block and object maps, blocksets |
| `$4e`, `$4f` | room special tiles |
| `$51`-`$55` | room main tiles |
| `$56`-`$58` | overworld code, credits |
| `$60`-`$65` | object OAM |
| `$68`-`$6f` | enemy graphics, four banks per set of slots |
| `$70`-`$72` | golf |
| `$76`, `$78` | overworld and clear screen code |
| `$79`, `$7e` | Action Help |
| `$7c`, `$7d` | pause menu, font |

Banks `$16`-`$17`, `$1b`-`$1f`, `$4a`-`$4d`, `$59`-`$5f`, `$66`-`$67` and
`$73`-`$75` are empty. Some banks are full to the last byte (`$27`, the
cutscenes, among others); see
[Changing the code safely](working-with-the-code.md#full-banks).
