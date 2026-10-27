# Original game bugs

Bugs in the original game that the disassembly marks. They are left as they
are unless this page says otherwise, so the ROM stays as close to the original
as the fork's features allow.

| Where | Comment | Status |
|---|---|---|
| `src/engine/overworld/bank27.asm`, `Cutscene4cFunc.WaitObj2State03` | missing `ret nz` | fixed |
| `src/engine/level/objects/shoot.asm` | `; bug, this expects x position in register a` | left |
| `src/engine/pause/save/checksum.asm` | `; buggy, doesn't loop properly` | left |
| `src/engine/overworld/bank26.asm` | `; bug, fallthrough` | left |

To find more, search for `; bug` in `src/`.

## The extinguish-fire cutscene

The naming survey found this one: Cutscene4c, the cutscene of
`EVENT_EXTINGUISH_FIRE`, has a step that compares and then ignores the result.

### How cutscenes run

A cutscene is a jump table of steps (`.PlayCutscene`), indexed by `wOWStep`.
Each frame runs the current step. A step that is done calls
`AdvanceCutsceneFunc`, which moves to the next step and resets the frame
counter `wOWStepCounter`. A step that isn't done returns, and runs again on the
next frame.

The scene has two objects: object 2 is a fire extinguisher, object 3 is the
fire. The steps after the extinguisher rises:

1. Wait 60 frames, then set the extinguisher to state 2, a short animation. When
   the animation ends, its update routine sets it to state 3 on its own.
2. **Wait for the extinguisher's state 3.** This is the bug:
   ```asm
   .WaitObj2State03:
   	ld a, [wSceneObj2State]
   	cp $03
   	jp AdvanceCutsceneFunc   ; advances whatever the comparison said
   ```
   `cp` sets the Z flag, but nothing reads it. The other waiting steps return
   there while they're not done (`ret c`). Without that, this step advances on
   its first frame.
3. Wait 100 frames, then set the fire to state 2: it goes out.
4. Wait 60 frames, then hide the fire.

### Impact

State 2 is a 6-frame animation (`ExtinguishFireCutsceneFrameset_bf103`: six
frames of one frame each). So the 100-frame wait of step 3 starts 6 frames
early, and the fire goes out 6 frames (0.1 s) earlier than the script meant.
Nothing else changes: the extinguisher reaches state 3 long before the fire
reacts. Nobody would notice.

### The fix

The fix is the missing `ret nz`. Bank `$27` has no free byte, so the step
before (step 1 above) ends with a `jr` to this step's `jp` instead of a `jp`
of its own, which saves the byte:

```asm
	call SetSceneObjState
	jr .advance ; was jp AdvanceCutsceneFunc: frees a byte for the ret nz below

.WaitObj2State03:
	ld a, [wSceneObj2State]
	cp $03
	ret nz
.advance
	jp AdvanceCutsceneFunc
```

The ROM changes in those 8 bytes, the step's entry in the jump table (the label
moved back one byte), and the header checksum.

### Checked in the emulator

A PyBoy script set `wCurEvent` to `EVENT_EXTINGUISH_FIRE` when
`CheckIfEventHasCutscene` ran during a new game, so the game played this
cutscene instead of the prologue. The script logged `wOWStep` and both
objects' states every frame:

| | Original | Fixed |
|---|---|---|
| Extinguisher to state 2 | frame 262 | frame 262 |
| Next step | 263 (no wait) | 268 (waits for state 3) |
| Fire goes out | 363 | 369 |
| Cutscene ends | 510 | 516 |

The same technique (a hook to force a state, a per-frame log, two ROMs side
by side) works for checking any small change to a scripted sequence.
