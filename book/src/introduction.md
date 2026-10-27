# Introduction

This book is about working on the code of
[lautarodragan/warioland3](https://github.com/lautarodragan/warioland3), a fork
of [ElectroDeoxys/warioland3](https://github.com/ElectroDeoxys/warioland3), the
Wario Land 3 (Game Boy Color) disassembly. It's written for people and AI agents
who want to read or change the code. If you only want to play, the
[README](https://github.com/lautarodragan/warioland3#readme) has the patch and
how to apply it.

The fork adds an in-game debug menu (SELECT during a level) with FORM, POWER,
GOLF, OWL and TREASURE entries, a few quality-of-life changes (holding B to keep
swimming or flying as a bat), emulator tests that play the game, and names for
most of the labels the disassembly still had as addresses.

## Where things are

| Path | What |
|---|---|
| `src/` | The disassembly. `src/layout.link` places sections in banks. |
| `src/engine/debug_menu/` | The debug menu, its object spawning and the clear gate mover. |
| `src/engine/level/` | The level engine: Wario's states, objects, rooms, the camera. |
| `src/engine/overworld/` | The map, its scenes and cutscenes. |
| `tests/` | PyBoy emulator tests, golden screenshots, level routes and tools. |
| `tools/` | Build tools (`make_ips.py`, `debug_menu_bgmap.py`, graphics tools). |
| `book/` | This book. |

## Conventions

- Labels named after their address (`Func_9e52a`, `Data_60320`) are labels
  nobody has named yet. The [naming survey](naming-survey.md) proposes names for
  almost all of them, and most are applied (see
  [Naming the disassembly](renames.md)).
- A comment starting with `; bug,` marks a bug in the original game, left as it
  is. `; fix:` marks one this fork fixed (see
  [Original game bugs](original-game-bugs.md)).
- Changes that only rename or comment must leave the ROM byte-identical; see
  [Changing the code safely](working-with-the-code.md).

## Keeping this book up to date

The book is built with [mdBook](https://rust-lang.github.io/mdBook/) from
`book/` and published to GitHub Pages by `.github/workflows/book.yml` whenever
`book/` changes on master. To preview it locally, run `mdbook serve book`.
When a change to the code makes a page wrong, fix the page in the same commit.
