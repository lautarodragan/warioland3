# Wario

Wario is not an object: he has his own variables in WRAM0, his own state
machine, his own graphics loading and drawing. This page covers his states,
how he collides with blocks, transformations and power-ups.

## Position and movement

`wWarioYPos` and `wWarioXPos` are 16-bit level coordinates stored high byte
first (objects store theirs low byte first). Y is the bottom of his feet.
Movement goes through `MoveWarioRight`/`Left`/`Up`/`Down`
(`src/home/move_wario.asm`), which also add the distance to
`wCameraXDelta`/`wCameraYDelta`, the input of the camera code
([Camera and scrolling](camera.md)). `MoveWarioUp_WithoutCameraOffset` and
`MoveWarioDown_WithoutCameraOffset` move him without telling the camera.

`SetWarioScreenPos` (`src/engine/level/camera.asm`) computes
`wWarioScreenYPos`/`XPos` (OAM coordinates, with the `+16`/`+8` offsets)
from the position and `wSCY`/`wSCX`.

## States

`wWarioState` holds a `WST_*` constant (`src/constants/wario_constants.asm`).
`UpdateWarioStates` (`src/engine/level/wario_states_1.asm`) counts down
`wCoinCooldown`, runs `HandleGroundShake` and `HandleInvincibility`, then
jumps to the state's update routine in one of four tables:

| States | Table | File | Bank |
|---|---|---|---|
| `$00`-`$2f` | `UpdateWarioStates_Group1` | `wario_states_1.asm` | `$07` |
| `$30`-`$5f` | `UpdateWarioStates_Group2` | `wario_states_2.asm` | `$06` |
| `$60`-`$af` | `UpdateWarioStates_Group3` | `wario_states_3.asm` | `$0a` |
| `$b0`-`$f2` | `UpdateWarioStates_Group4` | `wario_states_4.asm` | `$7b` |

| Group | Contents |
|---|---|
| 1 | normal movement: idling, walking, jumping (`WST_AIRBORNE`), attacking, crouching, swimming, stung, pipes, grabbing and throwing, rolling, entering doors |
| 2 | slipping, sand, ladders, teleporting, getting a treasure, sleeping, fences |
| 3 | transformations: on fire and hot, flat, ball o' string, fat, electric, invisible, puffy, zombie, bouncy, crazy, vampire and bat, bubble |
| 4 | more transformations: ice skating, owl, rail, snowman, split, fan, blind, swallowed and launched, magic, ball |

Unused state numbers (`WST_UNUSED_*`) point to `InvalidWarioStateReset`.
`UpdateLevel` sets `wBlockFuncWarioFlag` while it runs the states, and skips
them entirely during a floor transition.

### Entering a state

Each state has a `SetState_*` routine that sets `wWarioState`, clears the
counters the state uses (`wFrameDuration`, `wAnimationFrame`,
`wWarioStateCounter`, `wJumpVelIndex`...), sets Wario's collision box and
loads his graphics and animation. `SetState_Idling`, for example:

- collision box: `wCollisionBoxTop` -27, `wCollisionBoxBottom` -1,
  `wCollisionBoxLeft` -9, `wCollisionBoxRight` 9 (relative to his position);
- graphics: `wDMASourceBank`/`wDMASourcePtr` = `WarioIdleGfx`, then
  `LoadWarioGfx`;
- OAM: `wWarioOAMBank`/`wWarioOAMPtr` = `WarioOAM_14000`;
- frameset: `wWarioFramesetPtr`, one per direction.

`LoadWarioGfx` (`src/home/load_wario_gfx.asm`) doesn't copy anything itself:
it fills `wPendingDMA*` (128 tiles to VRAM0 `$8000`) and sets
`wIsDMATransferPending`, and the next V-Blank does the copy with a general
purpose DMA (see [Game states](game-states.md#v-blank)). Wario's graphics are
in `Wario Gfx 1`-`4` (banks `$04`, `$09`, `$0b`, `$7a`), his OAM in
`Wario OAM 1`-`3` (`$05`, `$7f`, `$77`).

`UpdateWarioAnimation` (hcall'd in the `Wario OAM 1` bank) steps the
frameset; `DrawWario` (`src/home/sprite.asm`) writes his sprites to virtual
OAM, applying `wWarioAttributes` (flipping). He's skipped on frames where
`wInvisibleFrame` says so: `HandleInvincibility` toggles it while
`wInvincibleCounter` runs (the blinking after damage), and Invisible Wario
uses it as a frame counter, showing only some frames.

## Blocks and collision

What a block does is decided by the room's block function table:
`ProcessBlock` (`src/engine/level/block_functions.asm`) reads the block at
`wBlockPtrBank:wBlockPtr`, doubles it (bit 7, the object flag, falls off) and
jumps to that entry of `wBlockFunctionTable`. The tables
(`src/data/levels/function_tables1.asm`, `function_tables2.asm`) map each of
the 128 block types to a `BlockFunc_*` routine: `BlockFunc_Free`,
`BlockFunc_Solid`, `BlockFunc_Floor`, `BlockFunc_LadderTop`, water, doors,
breakable blocks of each strength, and so on.

A block function reads these to decide what to do:

| Variable | What |
|---|---|
| `wBlockFuncWarioFlag` | TRUE when Wario is asking; FALSE for objects (thrown objects, falling enemies), where most special blocks act as plain free or solid |
| `wCollisionPoints` | which check this is: `COLLISION_DOWN`, `COLLISION_SIDE`, `COLLISION_UP`, `COLLISION_LANDING`, `COLLISION_ENV` (what Wario is standing in), ... |
| `wBlockFuncBreakFlag` | set by checks that may break blocks (`CheckFrontCollision`, the `..._Break` variants) |
| `wTransformation`, `wPowerUpLevel`, `wWarioState`, `wJoypadPressed` | for blocks that depend on them (doors need UP and an idle-like state) |

It answers in `a` (`BlockFunc_Free` returns 0, `BlockFunc_Solid` usually
1, special blocks other values) and can
also change Wario's state, set `wRoomTransitionParam`, set
`wWaterInteraction`/`wLadderInteraction`, break the block
(`QueueBlockRedraw`, `BreakBlock`) or start a multi-block break.

Wario's side: the routines in `src/engine/level/collisions.asm`
(`CheckFrontCollision`, `CheckBottomRightCollision`, `CheckUpCollision`,
`CheckAirborneCollision`, `CheckStandingOnFloorBlocks`...) turn his position
and collision box into a point in `hPos`, find the block (`GetBlockPtr`),
set `wCollisionPoints` and call `ProcessBlock`. `UpdateEnvState` clears the
water, ladder, sand, fence, air current and room transition variables and
checks the block he's in with `COLLISION_ENV`; that's how doors, ladders,
water and exits are noticed. Collision results are mostly returned in `b`.

## Transformations

`wTransformation` holds a transformation ID (`TRANSFORMATION_*_ID`, `$00`-`$16`)
plus two flags:

| Flag | Bit | What |
|---|---|---|
| `TRANSFORMATIONF_PERSISTENT` | 6 | the interaction routines check it and don't start another transformation while it's set (`ObjInteraction_Fire` just touches the object instead) |
| `TRANSFORMATIONF_SUPER_SMASH` | 7 | while set, `UpdateObjects` counts Wario as having the Super Jump Slam Overalls (`wEffectivePowerUp`), which some objects check; it's the only use by name |

| Transformation | Flags |
|---|---|
| Hot Wario, Ball o' String | persistent, super smash |
| Fat, Electric | super smash |
| Flat, Zombie, Vampire, Bubble, Ice Skatin', Snowman, Split, Blind, Launched, Magic, Ball | persistent |
| Invisible, Puffy, Bouncy, Crazy, Owl, Rail, Fan | none |

A transformation starts in an `ObjInteraction_*` routine or a block function.
`ObjInteraction_Fire` is typical: it sets `wTransformation`,
`wTransformationProgress`, the touch states (`wTouchState`,
`wStingTouchState`, `wSpikeTouchState`) and `wTransformationDuration`
(`HOT_WARIO_DURATION`), calls `UpdateLevelMusic` (transformations have their
own music) and enters the transformation's first state. The states then run
the transformation and end it with `ClearTransformationValues`
(`src/home/clear_transformation.asm`), which zeroes all of those. Pressing
SELECT while transformed does the same in this fork (`UpdateLevel`).

## Power-ups

`wPowerUpLevel` is one number, 0-9, not a set of flags: each power-up
includes the ones before it.

| Level | Constant |
|---|---|
| 0 | `NO_POWER_UP` |
| 1 | `LEAD_OVERALLS` |
| 2 | `SWIMMING_FLIPPERS` |
| 3 | `HEAD_SMASH_HELMET` |
| 4 | `GRAB_GLOVE` |
| 5 | `GARLIC` |
| 6 | `SUPER_JUMP_SLAM_OVERALLS` |
| 7 | `HIGH_JUMP_BOOTS` |
| 8 | `PRINCE_FROGS_GLOVES` |
| 9 | `SUPER_GRAB_GLOVES` |

Code checks it with a compare: `StartJump` only considers the high jump if
`wPowerUpLevel` is at least `HIGH_JUMP_BOOTS`; block functions and objects do
the same for their power-up. It's raised when a power-up treasure is
collected (`src/engine/clear/treasure_transition.asm`), together with
`ACTION_HELP_LEVEL_CLEAR` in bit 7; bit 6 is `ACTION_HELP_TITLE_SCREEN`. The
Action Help screens read those bits and mask the level with `POWER_UP_MASK`.
`POWER_UP_OWL`, `POWER_UP_RAIL` and `POWER_UP_VAMPIRE` (`$a`-`$c`) exist
only for Action Help.
