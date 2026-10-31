# History of the fork

What was done, in order, with what each step taught. The commits and pull
requests on GitHub have the details. The work was done by Taro with Claude
(Claude Code), Taro mostly in the role of QA: playing, finding what was wrong,
and deciding what to do.

## The debug menu (June 2026)

The first version of the menu (PR #1) had FORM, POWER, GOLF and INVNBL rows on
a plain font screen, with its own game state, `ST_DEBUG_MENU`. Two
quality-of-life changes came with it: holding A or B keeps Wario swimming
(`HandleUnderwaterThrustingInput` restarts the stroke), and holding A keeps
Vampire Wario flying as a bat (`UpdateState_BatIdling`). A transformed Wario pressing SELECT turns
back to normal instead of opening the menu.

GOLF reloaded the room so the golf win would take effect. That turned out to be
the cause of the "soft-locks" reported later (see October).

## Emulator tests (October 2026)

PR #2 added PyBoy tests: a new game played through N1 by pressing buttons only,
and the debug menu checked through RAM, with golden screenshots, run in CI.
Every feature after this came with tests, and several bugs below were found
by them.

## The debug owl

An earlier attempt at an OWL row had been reverted: grabbing the spawned owl
corrupted the level's graphics and collisions for good. The tests made the
cause findable by comparing the spawned owl with a real one in The Colossal
Hole. `DespawnObject` wrote through a null object map pointer to `$0000`, which
on MBC5 is a RAM-enable register, so it turned cartridge RAM off. The full
story is in [The debug owl](debug-owl.md).

After that, step by step (PRs #3 to #9):

- Rooms without owls. The owl's graphics go into an enemy graphics slot the
  room doesn't use.
- Flying the owl into the next room, as with the real one.
- Night, where real owls take off right away.
- Boss battles (refused), saving and continuing, and full object slots.
- Cameras that move a floor at a time: they now follow Owl Wario, and Vampire
  Wario's bat too. In the original game neither ever flew in such rooms, so
  those cameras never had to follow them.
- A path finder and route search for the tests (`tests/tools/`). It knows Wario's
  power-ups and treasures, so a test can reach a level's owl room by searching
  for a route instead of writing it by hand.

Later:

- Owl Wario's room-top ceiling stops his body, not the owl he holds, so he
  can reach coins at the top of a room.
- In rooms whose enemies use all four graphics slots, the owl borrows a slot
  no active enemy uses and gives it back once it's gone.

## The TREASURE row

PR #4 added TREASURE: give or take any level's treasure. It was needed to
reach The Steep Canyon's owl room, which only opens with N5's Foot of Stone.

## Menu redesign

The menu was redrawn with the pause menu's graphics (PR #10), and INVIS became a
FORM, as it is in the game. Later: SELECT also closes it, it plays the pause
menu's music, OWL and GOLF apply with A, FORM and POWER show ◀ ▶ on the selected
row, and treasures read OPEN/CLOSED.

## GOLF without the room reload

Toggling GOLF reset the game to the title screen in 21 of 25 start rooms, and
sent Wario to another room in others. Reloading "the room Wario is in" really
loads the room of a door in his sector, and most sectors have none. Since the
golf win only raises the clear gates, GOLF now moves those gates directly. See
[GOLF and the room reload](debug-menu.md#golf-and-the-room-reload).

## Naming the disassembly

A survey of every label still named after its address ran in four passes, and
its high- and medium-confidence proposals were applied in 13 batches: about
6,500 renames, every batch checked to leave the ROM byte-identical. Along the
way:

- `FLOOR_TRANSITION_UP` and `FLOOR_TRANSITION_DOWN` turned out to be swapped.
- Several code pointers and data tables written as numbers were turned into
  labels.

See [Naming the disassembly](renames.md).

## Upstream merges

The upstream disassembly's August 2026 commits were merged, with their own
renames (`LevelRooms_` to `LevelHeaders_`, `wca65` to `wWarioFrame`, ...)
reconciled with the survey.

## Original game bugs

The naming survey found a step in the extinguish-fire cutscene that was meant to
wait and never did. It's harmless (the fire goes out 6 frames early). It's
fixed here, as a demonstration. See
[Original game bugs](original-game-bugs.md).
