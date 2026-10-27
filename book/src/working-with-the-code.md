# Changing the code safely

Lessons from this fork's changes, for anyone (human or AI) about to edit the
disassembly.

## Renames and comments must not change the ROM

A rename, a comment, or moving code between files without moving it in the ROM
must leave the ROM byte-identical. Check it:

```nu
make; cp warioland3.gbc /tmp/base.gbc       # before the change
# ...change...
rm src/*.o; make; cmp warioland3.gbc /tmp/base.gbc
```

`cmp` printing nothing means identical. `cmp -l` lists every differing byte,
which is the quickest way to see that a real change touched only what it meant
to (for example: a few bytes of code, one jump table entry, and the header
checksum at `$14e`/`$14f`).

## Label renames

A label name can appear in places a plain search-and-replace misses or
overmatches:

- Local labels (`.foo`) may be written with their routine in front
  (`Routine.foo`), including routine names that end in a digit.
- Struct macros build labels from a base name (`w2d0b5SourceHi`).
- Flag constants come with a bit-number twin (`FOO` and `FOO_F`).
- The tests look RAM and routines up by name in `warioland3.sym`, and some test
  tools key on label names. Search `tests/` and `tools/` too.
- Two locals in the same routine can't share a name.

[Naming the disassembly](renames.md) describes the tooling used for the big
renames.

## Addresses written as numbers

Some code in the original disassembly referred to data or code by a number
instead of a label: update-function pointers written as `dw $xxxx`, or
tables read with `ld hl, $xxxx`. Code like that breaks as soon as anything
before the target moves. This fork replaced the known cases with labels
(Togeba, the seeing eye door, Bubble, coin, Omodon). If a change that should be
harmless breaks a far-away object, look for one of these first.

## Full banks

Some banks have no free space. Bank `$27` (cutscenes) is full to the last byte,
so even a one-byte fix there needs a byte saved nearby, for example by turning
a `jp` to a nearby target into a two-byte `jr`. `warioland3.map` lists each
bank's sections and free space (`EMPTY`/`SLACK`).

When adding code to a bank whose layout matters (code that other code reaches
by address), put it at the end of the section so nothing before it moves. The
debug menu's clear gate mover is included last in "Object Functions 1" for
that reason.

## Cycles change enemy behaviour

Enemies use `DIV` for randomness, so any change that runs a different number of
cycles before a level runs makes enemies behave a little differently. See
[Why goldens drift](testing.md#why-goldens-drift).

## Proving a change in the emulator

Many questions about the code can be answered by playing it. A quick
standalone script can load the ROM with PyBoy, use a hook to force a state (for
example, set `wCurEvent` when `CheckIfEventHasCutscene` runs, so a new game plays
any cutscene), then log RAM every frame. Compare the log from the old ROM with
the log from the new one. [Original game bugs](original-game-bugs.md) has an
example.
