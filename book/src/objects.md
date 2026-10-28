# Objects

Enemies, chests, keys, coins, platforms and most other things that move in a
level are objects. There are 8 object slots; objects come from the level's
object map as the camera reaches them, or are created by other objects. Each
room's object group decides which objects can appear and loads their
graphics into four slots in VRAM bank 1.

Code: `src/engine/level/load_objects.asm` (groups, spawning, creating),
`src/engine/level/update_objects.asm` (updating, drawing, generic states),
`src/engine/level/object_interactions.asm` (Wario against objects),
`src/engine/level/objects/` (one file per object), data in `src/data/`.

## Slots and the object struct

`wObjects` (`$d000`, WRAM bank 1, "Level Objects WRAM") holds `NUM_OBJECTS`
= 8 structs of `OBJ_STRUCT_LENGTH` = `$20` bytes (`wObj1`-`wObj8`), so all
slots fit in one page. `wCurObj` (`$d100`) is a working copy: `UpdateObject`
copies a slot there, runs it, and copies it back. Update functions read and
write `wCurObj...`, often as `ld l, OBJ_...` with `h` already pointing at
`wCurObj`.

| Offset | Field | What |
|---|---|---|
| `$00` | `OBJ_FLAGS` | see below |
| `$01` | `OBJ_MAP_PTR_LO`/`_HI` | the block this object spawned from, for `DespawnObject` (in this fork, `_HI` 0 means none) |
| `$03` | `OBJ_Y_POS` | level position, **low byte first** (Wario's is high byte first) |
| `$05` | `OBJ_X_POS` | same |
| `$07` | `OBJ_ID` | object type; the high nibble also picks banks (below) |
| `$08` | `OBJ_INTERACTION_TYPE` | what touching it does to Wario; bit 7 is `HEAVY_OBJ` |
| `$09` | `OBJ_COLLBOX_TOP`/`BOTTOM`/`LEFT`/`RIGHT` | collision box, relative to the position |
| `$0d` | `OBJ_SCREEN_Y_POS`/`OBJ_SCREEN_X_POS` | computed every frame from the camera |
| `$0f` | `OBJ_FRAME` | current OAM frame |
| `$10` | `OBJ_OAM_PTR` | the object's OAM frame table |
| `$12` | `OBJ_FRAMESET_PTR` | current frameset |
| `$14` | `OBJ_FRAME_DURATION`, `OBJ_FRAMESET_OFFSET` | animation position |
| `$16` | `OBJ_STATE_DURATION`, `OBJ_VAR_1`-`3` | free for the object's code |
| `$1a` | `OBJ_SUBSTATE` | low nibble plus flags (below) |
| `$1b` | `OBJ_STATE` | set by actions (below) and by the object itself |
| `$1c` | `OBJ_ACTION`, `OBJ_ACTION_SIDE` | what Wario did to it this frame, and from which side |
| `$1e` | `OBJ_UPDATE_FUNCTION` | called every frame |

`OBJ_FLAGS`:

| Bit | Flag | What |
|---|---|---|
| 0 | `OBJFLAG_ACTIVE` | slot in use |
| 1 | `OBJFLAG_ON_SCREEN` | set by `CheckObjectOnScreen`; only these are drawn and interact |
| 2 | `OBJFLAG_GRABBED` | held by Wario |
| 3 | `OBJFLAG_NO_COLLISION` | |
| 4 | `OBJFLAG_INVISIBLE` | not drawn; `SpawnObject` sets it, init code usually clears it |
| 5 | `OBJFLAG_STEPPED` | Wario stands on it; cleared by `UpdateObject` every frame |
| 6 | `OBJFLAG_TRANSIENT` | created by another object, not from the map |
| 7 | `OBJFLAG_PRIORITY` | drawn in front of Wario (see [Drawing](#drawing)) |

`OBJ_SUBSTATE` has `OBJSUBFLAG_NO_DESPAWN` (bit 4), `OBJSUBFLAG_UNINITIALISED`
(bit 5), `OBJSUBFLAG_VDIR`/`HDIR` (bits 6, 7: facing). Its low nibble also
matters when the object goes off screen (see [Despawning](#despawning)).

## Object data and banks

An object starts from an `object_data` entry (`src/data/object_data.asm`):
ID, interaction type, collision box top, OAM pointer, update function, flags.
The ID's high nibble is the bank offset of both its code and its OAM data:

| ID high nibble | Update function bank | OAM bank |
|---|---|---|
| 0-5 | `$10`-`$15` (`Object Functions 1`-`6`) | `$60`-`$65` (`Objects OAM 1`-`6`) |
| 8 | `$18` (`Object Functions 7`: dummy, coin) | `$60` |

`UpdateObject` calls the update function in bank `(OBJ_ID >> 4) |
BANK("Object Functions 1")`; `UpdateObjSprite` reads OAM from bank
`((OBJ_ID >> 4) & 7) | BANK("Objects OAM 1")`. The macro asserts that both
labels are in matching banks. All object framesets are in bank `$1a`
(`Object Framesets`). In The Temple, `UpdateObjects_Temple` always uses
`Object Functions 4`, where the hidden figure is.

IDs are not unique: several objects can share one (`GREY_CHEST` through
`BLUE_CHEST` are all `$31`; see the comment at the top of
`src/constants/object_constants.asm`), so the ID alone doesn't always say
which object it is. The debug menu's GOLF, for example, finds clear gates by
their update function (`ClearGateFunc.Update`).

## Object groups

Each room header names an object group (`wObjectGroup`).
`LoadObjectGroupData` (`load_objects.asm`) reads `ObjectGroups`: one entry
per `OBJECT_GROUP_*` constant (146 of them), pairing a common-objects set
with one of the 118 `ObjectGroupN` lists (`src/data/object_groups.asm`). It:

1. resets `wOwlTileOffset` (this fork, see [The debug owl](debug-owl.md))
   and fills all 16 `wObjDataPointers` with `DummyObjectData`;
2. from the common-objects set (`CommonObjects_Grey`, `_Red`, `_Green`,
   `_Blue`, `_Special`): the chest, key and musical coin data
   (`wChestObjDataPtr`, `wKeyObjDataPtr`, `wMusicalCoinObjDataPtr`) and
   object palette 3, their colour;
3. from the group: a GFX bank offset (0, or 4 for the ten boss groups, which
   reads from `Enemy Gfx 2 Slot 1`-`4`, banks `$6c`-`$6f`, instead of
   `Enemy Gfx 1`, `$68`-`$6b`), four compressed graphics sets, decompressed
   into the four enemy slots, then up to 13 object data pointers into
   `wObjDataPtr01`-`13` (a `NULL` ends the list early), then four palettes
   for object palettes 4-7 (`LoadObjPals`).

| Slot | VRAM1 tiles | Palette |
|---|---|---|
| 1 | `$8000`-`$83ff` (tiles `$00`-`$3f`) | 4 |
| 2 | `$8400`-`$87ff` (`$40`-`$7f`) | 5 |
| 3 | `$8800`-`$8bff` (`$80`-`$bf`) | 6 |
| 4 | `$8c00`-`$8fff` (`$c0`-`$ff`) | 7 |

Entry n of the list is usually the object whose graphics are in slot n;
entries past the fourth are variants (other directions, for example). The
slot and palette aren't stored anywhere at run time: each object's OAM data
has its tiles, VRAM bank and palette baked in. An object only looks right in
a group that put its graphics in the slot its OAM data expects. The
[debug owl](debug-owl.md#using-a-free-enemy-graphics-slot) page has more on
this, including how to tell an unused slot.

`OBJECT_GROUP_HIDDEN_FIGURE` (`$f0`) is special: `LoadHiddenFigureData` only
sets one pointer and loads no graphics.

## The object map

The object map (see [Levels, rooms and doors](levels-and-rooms.md#object-nibbles))
says which object is on which block: nibble n means entry n-1 of
`wObjDataPointers`. Together with bit 7 of the block byte it decides when an
object exists:

| Event | Code | Effect on the map |
|---|---|---|
| spawn | `SpawnObject` | needs bit 7 of the block set; clears it |
| despawn | `DespawnObject` (`src/engine/level/block_queue.asm`) | sets bit 7 again: the object respawns when it comes into view |
| freed | clearing `OBJ_FLAGS` (`StarsFunc`, for example) | nothing: bit 7 stays clear, the object stays gone until `ReloadLevelObjects` |
| removed | `ClearObjectMapEntry` | clears the nibble: gone until the level is loaded again |

`ReloadLevelObjects`, run by room transitions with
`ROOMTRANSITIONF_RELOAD_OBJECTS`, sets bit 7 back on every block that has it
in the ROM map.

## Spawning

`SpawnObject` (`load_objects.asm`) takes the block pointer in `de` and the
object map value in `c`. It returns without spawning if the X position is
past the level's 10 sectors (`hXPosHi >= $0a`), if all slots are taken, or if
the block's bit 7 is clear. Otherwise it fills the first free slot from the
object data: position, ID, interaction type, collision box top (the other
sides start at 0 and are set by the object's init), OAM pointer, update
function, `OBJ_FRAME_DURATION = $7f`, `OBJ_SUBSTATE = 1 |
OBJSUBFLAG_UNINITIALISED`, a 2-frame action cooldown, and flags from the
data plus `OBJFLAG_ACTIVE | OBJFLAG_INVISIBLE`. The update function first
runs as the object's init (it sees `OBJSUBFLAG_UNINITIALISED`), then usually
replaces itself with a `.Update` routine.

Spawning happens:

- when a room is drawn: `SpawnObjectsInView` (`start_room.asm`) scans the
  16×16 blocks from `wBlockXPos`/`wBlockYPos`, skipping objects outside the
  room's limits;
- when the camera reveals a new column or row: `UpdateLevelEdges`
  (`scroll.asm`) calls `SpawnRowEdgeObjects` (12 blocks down a column, after
  a horizontal scroll) or `SpawnColEdgeObjects` (13 blocks along a row, after
  a vertical scroll), in `src/engine/level/spawn_edge.asm`.

Objects can create other objects (projectiles, coins, parts):
`_CreateObjectFromCurObjPos` and `_CreateObjectAtRelativePos` take a longer
creation record (full collision box, frameset, variables, state) and set
`OBJFLAG_TRANSIENT`. They copy the creator's map pointer.

## Despawning

`CheckObjectOnScreen` (`update_objects.asm`) runs for every object every
frame. It sets or clears `OBJFLAG_ON_SCREEN` with a margin around the screen,
and despawns the object once it's further away: more than 92 px above the
camera's top edge, or more than 111 px beyond the bottom, left or right
edge, or at a negative coordinate. Objects with `OBJSUBFLAG_NO_DESPAWN`
stay. For the others, if the low nibble of `OBJ_SUBSTATE` is 0 the slot is
just cleared, otherwise `DespawnObject` marks the map so it comes back.
`_VanishObject` clears that nibble, so a vanished object doesn't come back.

On a room transition, `DespawnAllObjects` despawns every map object
(`DespawnObject`) and simply clears transient ones.

## Each frame

`UpdateObjects` (called from `UpdateLevel` with WRAM bank 1) first sets
`wEffectivePowerUp` (the power-up level, or `SUPER_JUMP_SLAM_OVERALLS` while
a transformation with `TRANSFORMATIONF_SUPER_SMASH` is on), runs
`HandleGrabbedObjectCollisions`, then `UpdateObject` for each active slot
(`src/engine/level/update_objects.asm`):

1. copy the slot to `wCurObj`;
2. `DoObjectAction`: turn `OBJ_ACTION` into a state (below);
3. call `OBJ_UPDATE_FUNCTION` in its bank;
4. `UpdateObjectAnimation`: step the frameset;
5. `CheckObjectOnScreen`;
6. compute the screen position from `wSCY`/`wSCX`;
7. copy back, clearing `OBJFLAG_STEPPED`.

While `wIsFloorTransition` is set it skips `HandleGrabbedObjectCollisions`
and runs `UpdateObjectDuringFloorTransition` instead, which only calls the update
function for objects that still have `OBJSUBFLAG_UNINITIALISED` set (that
check's comment used to say the opposite), and calls `UpdateObjectFrame` instead of
`UpdateObjectAnimation`, which doesn't advance the animation.

### Actions

Wario's side of an interaction doesn't change the object directly: it calls
`SetObjAction`, which writes an `OBJACTION_*` and the side to the object's
`OBJ_ACTION`/`OBJ_ACTION_SIDE`. The next frame, `DoObjectAction` turns it
into an `OBJ_STATE` (`OBJACTION_BUMP` → `OBJSTATE_BUMP_LEFT_START` or
`_RIGHT_START`, `OBJACTION_ATTACK` → `OBJSTATE_ATTACKED_...`, and so on) and
sets `OBJ_ACTION` to `no_actions_for 15`: bit 7 (`NO_ACTIONS`) plus a counter
that `DoObjectAction` decrements each frame. While `OBJ_ACTION` isn't 0,
`ProcessInteractions` skips the object. The object's update function then
reacts to `wCurObjState`, often through the shared state routines in
`update_objects.asm` (`_ObjState_Fall...`, `_ObjState_Bump...`,
`_ObjState_Grabbed...`, `_ObjState_Throw...`).

## Interactions with Wario

`ProcessInteractions` (`object_interactions.asm`) does nothing while Wario is
intangible (`wIsIntangible`), during a floor transition or while
`wAutoMoveState` is set. Otherwise, for each active, on-screen object with no
pending action, it compares Wario's collision box (`wCollisionBox*`, relative
to his screen position) with the object's, in screen coordinates. If they
overlap it works out the side of contact (`wInteractionSide`:
`INTERACTION_LEFT`/`RIGHT`/`UP`/`DOWN`, from the smallest overlap) and jumps
on `OBJ_INTERACTION_TYPE & INTERACTION_MASK` to an `ObjInteraction_*`
routine: stings, bumps, walkable tops, keys, treasures, coins, fire and the
other transformations, and so on. Those decide what happens to Wario (a new
state, a transformation, damage) and to the object (`SetObjAction`).

## Drawing

After the objects and interactions, `UpdateLevel` draws:

1. `DrawObjects_WithPriority`: objects that are active, on screen, not
   invisible **and have** `OBJFLAG_PRIORITY`
2. `DrawWario`
3. `DrawObjects_NoPriority`: the same, **without** `OBJFLAG_PRIORITY`
4. `ClearUnusedVirtualOAM`

On the Game Boy, sprites earlier in OAM win, so objects with
`OBJFLAG_PRIORITY` are drawn in front of Wario. (The two routines' names
were swapped until this fork fixed them.)

`UpdateObjSprite` (`src/home/object_mechanics.asm`) looks up the current
frame in the object's OAM table (`dw` per frame) and copies its sprites to
`wVirtualOAM`: four bytes each (y and x relative to the object's screen
position, tile, attributes), until a `$80` byte or until virtual OAM is full.
Framesets are pairs of frame and duration, ended by `$ff`, which restarts
the frameset.

## Particles

Small effects (dust, splashes, the released owl) are particles, not objects:
`MAX_NUM_PARTICLES` = 4 in `wParticles`, updated by `UpdateParticles`
(`src/engine/level/particles.asm`, bank `$03`) at the start of each frame.
