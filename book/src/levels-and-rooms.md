# Levels, rooms and doors

A level is one big map of blocks, decompressed into cartridge RAM when the
level starts. Rooms are rectangles of that map; doors, pipes and exits move
Wario between them. This page covers how a level is chosen, how its map is
stored, and how rooms are found and loaded.

## Terms

| Term | What | Size |
|---|---|---|
| block | one cell of the level map, drawn as 2×2 tiles | 16×16 px |
| sector | 16×16 blocks; also exactly one BG map (32×32 tiles) | 256×256 px |
| level map | 10×3 sectors | 160×48 blocks, 2560×768 px |
| room | a rectangle of sectors with its own graphics, objects and camera | |
| floor | a horizontal band of the level, for floor-by-floor cameras ([Camera and scrolling](camera.md)) | 128 px |
| level | `wLevel`: one variant of a map level, day or night | |
| map level | `wOWLevel`: the place on the map (`LEVEL_*` constants) | |

Positions are 16-bit pixel coordinates: `wWarioYPos`/`wWarioXPos` (big
endian, high byte first; Y is Wario's feet). The high byte of a coordinate
is the sector, the high nibble of the low byte the block within it.

## Level variants

Every map level has eight levels: four variants by day, then the same four by
night. `SelectLevel` (`src/engine/overworld/level_select.asm`) picks one
when Wario enters from the map:

```text
wLevel = (wOWLevel - 1) * 8 + variant + 4 * night
```

- **variant** (variants 1-4, added as 0-3): `LevelTreasureRequirements`
  (`src/data/levels/treasure_requirements.asm`) lists, per map level, two
  treasures for variant 4, two for 3 and two for 2. The first pair that's
  collected (`IsTreasureCollected`) wins; `TREASURE_NONE` fills the unused
  half of a pair. With none, it's variant 1.
- **night**: bit 0 of `wDayNight`.

`THE_TEMPLE` (`$c8`, 25 × 8) and `GOLF_BUILDING` (`$ff`) are set directly.
Since the variant is only chosen here, a treasure that opens a new path takes
effect the next time Wario enters from the map (see
[The debug menu](debug-menu.md#treasures)).

Variants share data wherever they can: `LevelHeaders`
(`src/data/levels/rooms1.asm`) and `LevelBlockAndObjectMaps`
(`src/data/levels/level_maps.asm`) have one entry per `wLevel`, and many
point to the same room list or map (`OutOfTheWoodsDay1To2RoomHeaders`,
`.the_vast_plain_1`).

### Day and night

Besides the variant, a few objects check `wDayNight` themselves (the
spearhead, the owl, the pillar platform, in `src/engine/level/objects/`).
Leaving a level through the pause menu's map option goes through
`ReturnToMapFromLevel`, which sets
bit 7 of `wDayNight` (the comment in `src/ram/wram.asm` calls it "trigger
day/night transition"); the map's init code (`src/engine/overworld/init.asm`)
acts on it, calling `SwitchDayNight` (`src/engine/overworld/day_night.asm`),
which flips bit 4. How bits 0, 4 and 7 combine on the map side isn't covered
here.

## The level map in SRAM

`LoadLevelBlockMapAndObjects` (`src/home/load_level.asm`) decompresses the
level's block map and object map (`dab` block map, then `dw` object map, in
the same bank: `Level Data 1`-`18`, banks `$38`-`$49`) into SRAM:

- each row of 160 blocks takes one 256-byte page;
- rows 0-31 are `sLevelBlockObjectMap` in SRAM bank 1, rows 32-47
  `sLevelBlockObjectMap2` in the first half of SRAM bank 2;
- in each page, bytes `$00`-`$9f` are the row's blocks and `$b0`-`$ff` its
  objects, one nibble per block (even columns in the high nibble).

`GetBlockPtr` (`src/home/decompress_level_data.asm`) turns a position into a
block pointer and SRAM bank; `GetObjectMapPtr` (`src/home/object_pos.asm`)
does the same for the object nibble. The rest of SRAM bank 2 and SRAM bank 3
hold backup copies the save code checks (`sBackupLevelBlockObjectMap`,
`sBackupLevelBlockObjectMap2`).

Both maps use the same run-length format (`DecompressLevelBlockMap`): a byte
`n` below `$80` repeats the next byte `n` times, a byte `$80 | n` copies the
next `n` bytes, `$00` ends.

### Block bytes

| Bits | What |
|---|---|
| 0-6 | block type `$00`-`$7f`: indexes the room's block function table (`wBlockFunctionTable`), tiles (`wRoomBlockTiles`) and attributes (`wRoomBlockAttributes`) |
| 7 | set: an object on this block is waiting to spawn |

Bit 7 comes from the compressed map. `SpawnObject` clears it when the object
spawns and `DespawnObject` sets it again; see [Objects](objects.md#the-object-map).
Code that changes a block keeps bit 7 (`StartMultiBlockBreak` does
`and $80 | or b`).

### Object nibbles

| Value | What |
|---|---|
| 0 | nothing |
| 1-14 | object: entry n-1 of `wObjDataPointers` (chest, key, musical coin, then `wObjDataPtr01`-`11`) |
| 15 | Wario's spawn point (`SetWarioPositionToSpawn`) |

## Sectors and the room table

`GetNextLevelRoomID` (`src/engine/level/scroll.asm`) turns a position into a
sector number, `y_hi * 10 + x_hi`, and stores it in `wLevelRoomID`. Each
level's room list (`LevelHeaders` → `...RoomHeaders`) has 30 entries, one per
sector. **The entry for a sector is the room you arrive in when you leave
through a door, pipe or exit in that sector**, not the room the sector
belongs to. Sectors with no way out have `NULL` (`$ffff`), and `LoadRoom`
resets the game on it (`debug_assert_not $ff`).

Entry 0 doubles as the level's first room: `StartRoom_FromLevelStart` sets
`wLevelRoomID` to 0. That room needn't be in sector 0 (Out of the Woods'
first room spawns Wario in sector 20, at the bottom left), but a door in
sector 0 would have to lead to it.

The room lists of levels before `THE_GRASSLANDS_NIGHT_1` are in `Rooms 1`
(bank `$30`, with `LevelHeaders`), the rest in `Rooms 2` (bank `$31`);
`LoadRoom` picks the bank by comparing `wLevel`.

## Room headers

`room_header` (`src/macros/data.asm`) packs a room into 8 bytes:

| Argument | Stored as | Read into |
|---|---|---|
| spawn sector x, y | one byte, y in the high nibble | `wWarioSpawnPos` |
| upper, lower y limit | one byte | `wRoomUpperYLimit`, `wRoomLowerYLimit` |
| left, right x limit | one byte | `wRoomLeftXLimit`, `wRoomRightXLimit` |
| camera configuration | `CAM_*` flags | `wCameraConfigFlags` |
| object group | `OBJECT_GROUP_*` | `wObjectGroup` |
| animated tiles group | `ANIMATED_TILES_GROUP_*` | `wAnimatedTilesGroup` |
| initial palette cycle | `ROOM_PALCYCLE_*` | `wRoomPalCycle` |
| room graphics | `ROOM_*` | `wRoom` |

Limits are in sectors; the upper and left limits are inclusive, the lower
and right ones exclusive. Out of the Woods' first room is
`room_header 0, 2, 2, 3, 0, 2, ...`: spawn search in sector (x 0, y 2),
rows of sector 2 only, sectors 0 and 1 across. `LoadRoom` also turns the
limits into object map bounds (`wRoomObjMapUpperY`... `wRoomObjMapRightX`)
so objects outside the room never spawn.

### Room graphics

`wRoom` indexes `RoomBlockAndGfxData`; each `room` entry
(`src/data/levels/rooms1.asm`) names five things, loaded by `LoadRoomGfx`
(`src/engine/level/load_room_gfx.asm`):

| Field | Loaded by | Into |
|---|---|---|
| block function table | `LoadBlockFunctionTable` | `wBlockFunctionTable` (128 pointers); tables 0-62 in bank `$32`, the rest in bank `$50` |
| blockset | `LoadRoomBlockTiles`, `LoadRoomTileMap` | `wRoomBlockTiles` (4 tile numbers per block), `wRoomBlockAttributes` (4 attributes per block, WRAM bank 3) |
| main tiles | `LoadRoomMainTiles` | VRAM0 `$9000`-`$97ff`, from `Room Main Tiles 1`-`5` |
| special tiles | `LoadRoomSpecialTiles` | VRAM1 `$9000`-`$97ff`, from `Room Special Tiles 1`-`2` |
| palettes | `LoadRoomPalettes` | `wTempPals1` (all 8 BG palettes), from `Level Palettes` |

`LoadRoomBlockTiles` looks the tiles up with the function table's index, not
the blockset's, and takes the blockset's bank from the function table index
too (`/ 6 + BANK("Level Data 1")`). In the data the two indexes are always
equal, so it makes no difference, but a new room needs them to match.

`LoadRoom` (`src/home/load_room.asm`) also loads the object group
(`LoadObjectGroupData`: enemy graphics and palettes, see
[Objects](objects.md#object-groups)), the animated tiles group
(`InitRoomAnimatedTiles`) and the palette cycle (`InitRoomAnimatedPals`).

### Index names

The indices above (`ROOM_*`, `ROOM_PAL_*`, `OBJECT_GROUP_*`, `BLOCKSET_*`,
`BLOCK_FUNCTION_TABLE_*`, `MAIN_TILES_*`, `ANIMATED_TILES_GROUP_*`,
`ANIMATED_TILES_GFX_*`, `ROOM_PALCYCLE_*`) are named after the level whose
rooms use them, found by walking every level variant's room headers:
`<FAMILY>_<LEVEL>_<n>`, with `n` counting the level's indices of that family
in order of first use and left out when the level has only one
(`ROOM_PAL_OUT_OF_THE_WOODS_1`, `MAIN_TILES_THE_TEMPLE`). Rooms used only by
day or only by night variants end in `_DAY` or `_NIGHT`, and the two copies
of a room share its number (`ROOM_OUT_OF_THE_WOODS_3_DAY`,
`ROOM_OUT_OF_THE_WOODS_3_NIGHT`). Indices several levels use are
`<FAMILY>_SHARED_<n>`, with the levels in a comment next to the constant,
unless they have something plain in common: `_CRATERS` (only the two
craters), `ROOM_PALCYCLE_NONE` and `ANIMATED_TILES_GROUP_NONE` (duration 0,
never run), `ANIMATED_TILES_GROUP_WATER`. Indices no room uses are
`<FAMILY>_UNUSED_<old index>`. Data labels and files follow the constant
(`RoomPals_OutOfTheWoods1`, `blockset_tiles_out_of_the_woods_1.bin`). The
full rule, counts and lists are in the [naming survey](naming-survey.md#room-data-indices).

## Starting a level

`InitLevel` (`src/engine/level/init.asm`), with the LCD off:

1. `LoadLevelCommonGfxAndTreasures`: `LevelsCommonGfx` to VRAM0 `$8800`,
   the level's treasures over part of it
2. `StartRoom_FromLevelStart` (`src/engine/level/start_room.asm`):
   - clears the level variables and objects (`InitObjectVars_FromLevelStart`),
     unless a save is being restored (`wRestoredSave`)
   - `LoadLevelBlockMapAndObjects`, then `LoadRoom` for `wLevelRoomID` 0
   - `SetWarioPositionToSpawn`, Wario idle facing right, his palettes
   - camera (`SetInitialCameraScroll`, `ApplyInitialCameraScroll`),
     `VBlank_Level`
   - `DrawRoom_FromStart` draws the whole BG map, `SpawnObjectsInView`
     spawns the objects in it
   - `UpdateObjects` twice, then draws objects and Wario
3. `UpdateLevelMusic`, LCD on (in The Temple also the window, for the hidden
   figure)

## Room transitions

A transition starts when something sets `wRoomTransitionParam`, usually a
block function as Wario touches a block:

| Type | Set by |
|---|---|
| `ROOMTRANSITION_PIPE` | `EnterPipeDown`, `EnterPipeUp` (`src/engine/level/block_functions.asm`) |
| `ROOMTRANSITION_DOOR` | `BlockFunc_Door`; also `ReturnToLevelFromGolf` |
| `ROOMTRANSITION_GOLF` | `BlockFunc_MinigameDoor` |
| `ROOMTRANSITION_ROOM_EXIT` | room exits (`BlockFunc_RoomExit`, `BlockFunc_WaterRoomExit`) |
| `ROOMTRANSITION_LADDER` | ladder blocks (`BlockFunc_LadderRoomExit_ReloadObjects`) |
| `ROOMTRANSITION_UNDERWATER_DOOR` | underwater doors (UP in deep water) |
| `ROOMTRANSITION_TELEPORT` | `ObjInteraction_WaterTeleporting`, `ObjInteraction_Jamano` |
| `ROOMTRANSITION_UNUSED_DOOR` | only `UnreferencedBlockFunc_UnusedDoor` |

Flags in the high bits: `ROOMTRANSITIONF_DOOR` plays the door effect,
`ROOMTRANSITIONF_RELOAD_OBJECTS` resets the level's objects (below),
`ROOMTRANSITIONF_DELAY` holds the transition until Wario's animation clears
the flag (the pipe states do it after 32 frames of sinking into the pipe).

`UpdateEnvState` (`src/engine/level/collisions.asm`) clears
`wRoomTransitionParam` before checking the blocks around Wario, and Wario's
state code calls `TriggerRoomTransition` when it's set. That function clears
grabbing, palette cycling, water currents and the boss flags, makes Wario
intangible and moves to substate 4 or 5 (see [Game states](game-states.md#a-levels-substates)).

### `StartRoom_FromTransition`

With the LCD off:

1. `ROOMTRANSITION_GOLF`: save the substate and switch to `ST_GOLF`, nothing
   else.
2. Despawn all objects (`DespawnAllObjects`, `InitObjectVars_FromTransition`).
3. `ROOMTRANSITION_TELEPORT`: set the high bytes of Wario's position to
   y 1, x 0, so the next room is sector 10's (the low bytes are kept).
4. Move Wario 16 px up, then `GetNextLevelRoomID` from his position.
5. Reset the floor transition, camera deltas and ground shake, `LoadRoom`.
6. `SetWarioPositionToSpawn`, set the camera.
7. `ROOMTRANSITIONF_RELOAD_OBJECTS`: `ReloadLevelObjects`.
8. `UpdateSwitchableBlocks` (`src/engine/level/switch.asm`): if the switch
   changed, swap blocks `$60`-`$67` and `$68`-`$6f` across the map.
9. Draw the room, spawn the objects in view, update objects twice, draw.
10. Substate 2 (fade in), LCD on.

Wario's position isn't changed by the door itself: the room is found from
the sector he's standing in when he goes through. For what happens when that
isn't a door's sector, see
[GOLF and the room reload](debug-menu.md#golf-and-the-room-reload).

### Finding the spawn point

`SetWarioPositionToSpawn` starts at the top-left block of the room's spawn
sector and scans the object map 16 blocks across, row by row downwards
(crossing into SRAM bank 2 if needed, with no limit), until it finds a nibble
of 15. Wario's position becomes that block's. So the spawn sector only says
which column of sectors to search, and from which row. In rooms with floor
transitions it also sets `wFloor` (`UpdateFloor`).

### Reloading objects

`ReloadLevelObjects` (`src/home/load_level.asm`) decompresses the level's
block map again, but only ORs bit 7 of each byte into the map in SRAM. Every
block that had an object in the ROM map gets its "waiting to spawn" bit back,
so objects that went away without being marked come back: for example
those that vanished through `_VanishObject`, whose `StarsFunc` frees the
slot without touching the map. The object map itself isn't touched: an
object whose nibble was cleared (`ClearObjectMapEntry`, which
`MusicalCoinFunc` calls when the coin goes away) stays gone until the level
is entered again.

## Multi-block breaks

Some blocks are parts of bigger ones: large cracked blocks and snowball
blocks (`BlockFunc_LargeCrackedBlock...`, `BlockFunc_SnowballBlock...`).
Breaking one calls `StartMultiBlockBreak`, which records the block in
`wMultiBlockOrigin*`, and the block function sets `wMultiBlockParam` to a
direction. At the end of the frame `UpdateLevel`
switches to substate 7, `ProcessMultiBlock` (`start_room.asm`), which keeps
calling `ProcessBlock` on the neighbour in that direction until the block
functions stop setting a new one, then returns to the saved substate.
