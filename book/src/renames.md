# Naming the disassembly

When this work started, the disassembly still had thousands of labels named
after their address: `Func_9e52a`, `w2d0b5`, `Data_60320`, `.Func_4d7dc`.
Such a name tells you where the code is, not what it does, so every reader has
to work that out again. This page describes how most of them got real names
without breaking anything. The proposals themselves are in the
[naming survey](naming-survey.md).

## Survey first, code later

Naming and renaming were separate steps:

1. **Survey.** The labels were listed, grouped by area, and each group was read
   in the code. Each proposal is a table row with the current name, the
   proposed name, the evidence (what the code does with it, with file and line)
   and a confidence: high, medium or low. Nothing in the code changed during the
   survey, so it could be reviewed as a document.
2. **Apply.** The high- and medium-confidence proposals were applied in
   batches, one commit each.

The survey ran in five passes:

| Pass | Covered |
|---|---|
| 1 | Phases 1-7: RAM, home bank routines, the fork's focus areas (camera, scrolling, rooms, saving, object interactions), Wario's states and block functions, `unk` struct fields, object state handlers, the start of the overworld |
| 2 | The `w1d`/`w2d` RAM, the overworld's states and helpers, the Hidden Figure, action help demos, the audio engine, bulk rules for room palettes and room tables |
| 3 | The rest of the overworld, cutscene rules, boss phases, owner-prefix names for framesets, OAM, palettes and data |
| 4 | Leftovers of the applied batches, the remaining scene locals, all remaining data labels, consistency renames, routines outside the overworld |
| 5 | The low-confidence leftovers, re-read and applied as it went: routines, referenced data, unreferenced framesets with owners checked against their OAM tables |

When labels came in large families, rules replaced hand naming. For example,
a frameset used by a single object is named `<Owner>Frameset_<addr>`, a
cutscene step that waits N frames is `.Wait<N>`, and a palette loader's data is
`<Owner>BGPals`/`OBPals`. Each rule is stated in the survey together with what
it covers.

## Applying

The renames were applied by scripts that read the survey's tables and replaced
whole identifiers in `src/`, `tests/` and `tools/`. What the scripts had to get
right:

- Locals match after their routine name (`Routine.local`) or on their own, never
  inside another identifier. This includes routine names ending in a digit; an
  early version missed those and left a few labels unrenamed.
- Labels built by struct macros from a base name (`w2d0b5SourceHi`) rename with
  their base.
- A renamed flag constant takes its `_F` bit-number twin along.
- Two locals in one routine can't get the same name. Repeats got their address
  as a suffix (`.Default_4d7dc`).
- New names must not collide with existing labels or constants. The script
  stops and reports a collision instead of applying it.
- Arrows inside a table's evidence column are not renames. Only the
  current/proposed columns, or explicit `old -> new` lists, are read.

## Verifying

Every batch was checked the same way:

1. Build a baseline ROM before the batch.
2. Apply the renames, delete the object files (`rm src/*.o`, so no stale macro
   expansion survives) and build.
3. `cmp` the new ROM against the baseline. A pure rename must be byte-identical.
   Any difference means something was renamed that shouldn't have been, or a
   literal address was hiding somewhere.
4. Run the emulator tests, which look symbols up by name.

Two kinds of real fixes came out of this, each committed separately and
checked to change only what it meant to:

- **Swapped constants.** `FLOOR_TRANSITION_UP` and `FLOOR_TRANSITION_DOWN`
  were swapped: when Wario went down a floor, the code set the flag called
  UP. Swapping the names left the ROM identical and made the code readable.
- **Numbers instead of labels.** Some update-function pointers (Togeba, the
  seeing eye door), data tables (Bubble, coin, Omodon, Count Richtertoffen's
  picked-up offsets) and Jamano's darkness framesets were written as
  literal addresses. They pointed at the right place only as long as nothing
  moved. They are labels now.

## Results

17 batches: about 6,800 label renames, plus the RAM mislabel fixes (batch 14). Then, as a change to the ROM, batch 18 merged the duplicate routines that could be merged. The batches are listed in the survey's
[Applied](naming-survey.md#applied) section.

Still named after their address, on purpose:

- Nothing in `src/` is named `Func_`/`Data_`/`Frameset_`/`OAM_`/`Pals_` after
  its address any more. The `.asm_` jump labels were never part of the
  survey.
- Duplicates that stay on purpose: bank `$20`'s copies of bank `$2d`'s
  `WaitOWFunc`/`AdvanceOWFunc`/`EndOWFunc` (`*_Bank20`, plus
  `AdvanceOWFunc_UnlockLevel`), which are in another bank and reached by `jr`
  and fallthroughs; `SmallHopYVel`/`SmallHopYVel2`; `SwimDiagonalVelTable`,
  which has the same bytes as `SwimStraightVelTable`;
  `GetBlockPtrBottomCentrePos`, close to `GetBlockPtrPos`.
- No RAM label is named after its address any more either: the last ones
  (`w2d150`.., the `w2d122`..`w2d13f` pairs, the VRAM backup buffers...)
  were named in the sixth pass (see the naming survey), after the
  structural RAM changes and wrong-union labels of batch 14.

## Doing more of this

- Add proposals to the survey with evidence and a confidence, then apply them
  as a batch, checking the ROM is byte-identical.
- Prefer names that say what the code does in the game ("raise the
  extinguisher") over what it does to memory ("increment byte").
- Use the names the rest of the code already uses for the same thing
  (upstream's "room header", for example), even when you would have picked
  another word.
