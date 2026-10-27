# Camera and scrolling

The camera is the level position of the screen's top-left corner. Each room
says how it moves (its camera configuration) and where it stops (the room's
limits). This page covers both, plus floor transitions and how new
background columns and rows are drawn.

Code: `src/engine/level/camera.asm` (scrolling), `src/engine/level/start_room.asm`
(`SetInitialCameraScroll`, `ApplyInitialCameraScroll`),
`src/home/floor_transition.asm` and `src/home/wario_mechanics1.asm` (floor
transitions), `src/engine/level/update_level.asm` (per frame),
`src/engine/level/scroll.asm` (new columns and rows).

## Position

`wCameraSCY` and `wCameraSCX` are 16-bit, high byte first. The BG map is
256×256 pixels, exactly one sector, so only the low bytes reach the hardware:
`UpdateLevel` copies them to `wSCY`/`wSCX`, and the level's V-Blank writes
those to `rSCY`/`rSCX` (adding `wSCYShake` for ground shakes).

The camera moves when Wario does: `MoveWarioRight` and friends add his
movement to `wCameraXDelta`/`wCameraYDelta`, and `LevelScroll_Horizontal`/
`LevelScroll_Vertical` turn those into camera movement and clear them.

## Camera configurations

The room header's camera byte goes to `wCameraConfigFlags`. Its low four bits
(`CAM_SCROLLING_MASK`) choose the camera; `UpdateLevel` has a separate
version of the frame for each:

| Value | Constant | Horizontal | Vertical | Room headers |
|---|---|---|---|---|
| `$01` | `CAM_FREE` | follows Wario | follows Wario | 1489 |
| `$08` | `CAM_TRANSITIONS` | follows Wario | a floor at a time | 477 |
| `$0c` | `CAM_XSCROLL2` with `CAM_TRANSITIONS` | fixed | a floor at a time | 25 |
| `$00` | `CAM_YSCROLL` | fixed | follows Wario | 19 |

(Counts are of the 2010 `room_header` lines in `src/data/levels/rooms1.asm`
and `rooms2.asm`; `CAM_XSCROLL1` is never used.) With a fixed horizontal
camera, `SetInitialCameraScroll` puts it at Wario's sector plus `$30` pixels,
the middle 160 pixels of the 256-pixel sector. The Temple's fight uses
`HIDDEN_FIGURE_CAMCONFIG` (`$0c` plus both side borders), which `UpdateLevel`
and `SetWarioScreenPos` check for to apply the hidden figure's own scroll
and shake.

The high four bits are borders: `CAM_BORDER_RIGHT`, `_LEFT`, `_UP`, `_DOWN`
keep the camera 32 pixels (`CAMERA_BORDER_*`) further in from that edge of
the room, hiding the outermost two blocks.

## Room limits

The room's limits (`wRoomUpperYLimit`, `wRoomLowerYLimit`,
`wRoomLeftXLimit`, `wRoomRightXLimit`, in sectors, from the room header)
bound the camera in the `ScrollCamera*` routines:

| Edge | Camera stops at | With border |
|---|---|---|
| left | the left limit's sector start | 32 px further right |
| right | 160 px before the right limit (the screen's right edge on the room's edge) | 32 px further left |
| top | the upper limit's sector start | 32 px further down |
| bottom | 152 px before the lower limit, so the bottom 8 px of the room never show | 32 px further up |

When a `ScrollCamera*` routine clamps, it sets `wScrollRightEdge` (or
`wScrollLeftEdge`, `wScrollUpEdge`, `wScrollDownEdge`), and the scroll
routine then doesn't ask for a new column or row.

## Following Wario

In both directions the camera aims to keep Wario at a fixed screen position:

- horizontally at `wCamRightSpacing` or `wCamLeftSpacing` (by his facing),
  both set to `$58` by `LoadRoom`: OAM x 88, the middle of the screen;
- vertically at `wPrevWarioScreenYPos`, set to `$70` by `LoadRoom` (his feet
  96 px from the top). Despite the name it's a target, not the previous
  position; only floor transitions change it.

`LevelScroll_Horizontal`: when Wario moved this frame, scroll by the same
amount, plus or minus 1 pixel to close in on the target. When he didn't, drift
1 pixel per frame towards it (not on the first idle frame, and not while Flat
Wario is jumping).

`LevelScroll_Vertical`: when Wario moved, scroll by the same amount, plus 1
if he's past the target. When he didn't, and he's not in water, jumping or on
a ladder: if he's 8 or more pixels off, scroll 7 pixels per frame towards the
target; on a slope (`wWarioSlopeInteraction`), any offset is corrected at
once.

`SetInitialCameraScroll` places the camera when a room starts: horizontally
relative to Wario's facing spacing, vertically 96 px above him (`$60`), then
clamped to the limits. In rooms with floor transitions, if no vertical limit
applied, the vertical position is then replaced by the floor's resting
position (below).
`ApplyInitialCameraScroll` writes it to the scroll registers and sets
`wBlockXPos`/`wBlockYPos`, the top-left of the area `DrawRoom_FromStart`
draws.

## Floors and floor transitions

The level's 768 pixels of height are six floors of 128 pixels,
numbered from the bottom up (`GetFloorForYPos`):

| Floor | Y range |
|---|---|
| 6 | `$000`-`$07f` |
| 5 | `$080`-`$0ff` |
| 4 | `$100`-`$17f` |
| 3 | `$180`-`$1ff` |
| 2 | `$200`-`$27f` |
| 1 | `$280`-`$2ff` |

In rooms with `CAM_TRANSITIONS`, `wFloor` is the floor the camera shows. It
rests 24 pixels above the floor's top (`SetInitialCameraScroll`: `$e8` into
the sector above for a floor in a sector's upper half, `$68` for one in the
lower half), clamped by the room's limits. The screen then shows from there
to 120 pixels below the floor's top.

Wario's movement code (and some objects that carry him) starts transitions:
`HandleDownwardsFloorTransition`/`HandleUpwardsFloorTransition`
(`src/home/floor_transition.asm`) and the near duplicates
`TriggerDownwardsFloorTransition`/`TriggerFloorTransition`
(`src/home/wario_mechanics1.asm`) compare `wFloor` with Wario's floor and call
`StartDownwardsFloorTransition` or `StartUpwardsFloorTransition`. These set
`wFloor`, `wFloorTransitionDir`, `wIsFloorTransition` and
`wFloorTransitionTimer`: 128 pixels, or 104 (`$68`) going down to floor 5,
since floor 6's resting position would be above the level and is clamped to
0. They play
`SFX_PIPE_EXIT`.

While `wFloorTransitionDir` is set, `UpdateLevel` moves the camera 4 pixels
per frame (through `wCameraYDelta` and `LevelScroll_Vertical`) until the timer
runs out, or, going down, until the camera hits the room's bottom edge.
Meanwhile:

- Wario's state isn't updated (he's frozen in place);
- objects only run their init (`UpdateObjectDuringFloorTransition`, see
  [Objects](objects.md#each-frame));
- `ProcessInteractions` does nothing;
- no pausing or debug menu, and no horizontal scrolling.

In a frame where Wario's graphics are being copied (`wIsDMATransferPending`)
the transition step is skipped and `UpdateLevel` runs the normal
horizontal camera code instead.

## Drawing new columns and rows

The BG map holds 32×32 tiles and the screen shows 20×18, so the game draws
the level into the BG map just ahead of the camera. When a `ScrollCamera*`
routine moves without hitting a limit, the scroll routine sets a bit in
`wLevelEdgeUpdateFlags`. `UpdateLevelEdges` (`scroll.asm`) then:

- for horizontal moves, `QueueEdgeColumn`: 23 tiles down the new column
  (left or right half of the blocks, `AddColumnRightTiles`/`...Left...`),
  tiles and attributes, into the tile queue;
- for vertical moves, the matching row;
- spawns the objects on the new column or row (`SpawnRowEdgeObjects`,
  `SpawnColEdgeObjects`, see [Objects](objects.md#spawning)).

The queue is written to VRAM in the next V-Blank (see
[Game states](game-states.md#the-tile-queue)). A V-Blank that copies Wario's
graphics drops the queue instead. Whether this ever leaves a stale column on
screen wasn't checked in depth: in a 1200-frame run of walking and jumping
through Out of the Woods' first room, 13 of the 55 V-Blanks that copied
Wario's graphics dropped a queued column, with no glitch visible at the end.
