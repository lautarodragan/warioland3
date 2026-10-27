# Emulator tests

`tests/` drives the built ROM in [PyBoy](https://github.com/Baekalfen/PyBoy)
(pinned in `tests/requirements.txt`) and compares screenshots against goldens
in `tests/goldens/`. The whole suite takes about two minutes.

```nu
pip install -r tests/requirements.txt
make test                                     # or: cd tests; python -m pytest -q
python3 -m pytest tests --update-goldens      # accept new screenshots
```

Every run writes its screenshots (and a `.diff.png` on mismatch) to
`tests/output/`. Only accept new goldens after looking at them.

## The `Game` helper

`tests/game.py` wraps PyBoy with what the tests need:

- `read`/`write` by symbol name (from `warioland3.sym`), `state` as
  `(wState, wSubState)`, `wario_pos`/`wario_block`, `objects()`.
- `press`, `press_until`, `wait_until`, `tick`, and `play(steps)`, which replays
  a list of `(buttons, frames)` steps, releasing every button and running one
  idle frame after each step.
- Flows: `new_game_to_overworld`, `enter_level`, `enter_level_from_map`,
  `return_to_map`, `save_and_continue`, `open_debug_menu`, `menu_press`,
  `close_debug_menu`.
- `snapshot`/`restore` for branching from a saved emulator state.
- PyBoy hooks on symbols (`pb.hook_register(None, "Symbol", fn, None)`) to
  override a value at the right moment, e.g. the level a map entry loads.

## Test files

- `test_out_of_the_woods.py` plays N1 from a new game: grabs the grey key, opens
  the grey chest, and checks the key/treasure flags, the clear screen and the
  treasure count. It only presses buttons; no RAM is written.
- `test_debug_menu.py` opens the debug menu and exercises FORM, POWER and
  INVIS, the controls (SELECT closes, A applies, LEFT/RIGHT do nothing on OWL and
  GOLF) and the music, checking the RAM each one changes, and gives and takes a
  treasure with TREASURE.
- `test_debug_menu_golf.py` toggles GOLF in every level's start room (and The
  Temple), checking that play carries on in the same place, and raises and
  lowers The Vast Plain's clear gate next to Wario, checking it lands where the
  game's own room load puts it.
- `test_steep_canyon.py` unlocks The Steep Canyon's secret door with TREASURE and
  plays to its owl room: a real owl to grab and a debug owl to spawn. With the
  Rust Spray, it also breaks the cracked column at the end of the start room and
  flies a debug owl into the room past it.
- `test_owl.py` grabs the real owl in The Colossal Hole (the reference for the
  debug owl), and spawns, grabs and flies the debug owl there and in The Steep
  Canyon's start room, which loads no owl graphics.
- `test_owl_cases.py` covers the debug owl around a flight: letting go, going
  offscreen, leaving the level while holding it, night, spawning against a wall,
  and filling every object slot.
- `test_owl_levels.py` takes the debug owl to levels without owls: start rooms,
  night, floor-by-floor cameras, water, full object slots, a boss battle (where
  it's refused), saving and continuing, and the top of a room.
- `test_owl_free_slot.py` checks where the debug owl's graphics go in rooms
  without an owl: an enemy graphics slot the room doesn't use, or one the room
  lends when it uses all four (see [The debug owl](debug-owl.md)).
- `test_vampire.py` flies Vampire Wario's bat up and down a floor in a room whose
  camera moves a floor at a time.
- `test_pathfind.py` tests the path finder below.

## Routes and tools

Level routes live in `tests/routes/` as lists of `(buttons, frames)` steps.

- `tests/tools/route_search.py` searches for routes.
  `route_search.py --plan LEVEL` uses the path finder's distance field as its
  heuristic, which is how the whole of Out of the Woods can be found from just
  "key, then chest".
- `tests/tools/level_map.py` prints a level as ASCII: solid blocks, ladders,
  doors, objects.
- `tests/tools/pathfind.py` builds a movement graph from the same data and runs
  A* over it, through doors and pipes. The graph follows Wario's power-ups (jump
  height, swimming, ground pounds that turn Togebas into platforms) and the
  treasures held, which pick the level's variant.

## Why goldens drift

Enemies take their randomness from the `DIV` register, which counts CPU cycles.
Any change that adds or removes cycles before a level runs, even in the debug
menu with the screen off, shifts when the code reads `DIV`. Enemies then
behave a little differently and level screenshots change by a few pixels,
or a route stops working (a jump lands a few frames off).

When that happens:

1. Look at the changed goldens side by side with the old ones. Only accept them
   if the difference is drift (an enemy or coin animation a frame off), not a
   real change.
2. When a route breaks, replay it step by step on the old and new ROMs, find the
   first step where Wario's block differs, and adjust that step. Prefer a fix
   that works over a wide window (for example, a wait that works anywhere from 2
   to 38 frames) to one that works for a single exact frame.
