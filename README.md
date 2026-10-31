# Wario Land 3 + Debug/Cheat Menu

<img src="wario-debug-menu.png" />

## What

A "Debug Menu" (more like a "Cheat Menu", really), inspired by Metroid Fusion's debug menu.

Accessible via SELECT during level play.
The menu allows cycling through:
- FORM: 13 transformation states (NONE/HOT/FLAT/STRNG/FAT/ELEC/PUFFY/ZOMBI/BUNCY/CRAZY/VAMPI/SNWMN/INVIS). Invisibility is one of them, as in the game.
- POWER: power-up level 0-9
- GOLF: press A to auto-win the current area's golf minigame (or take the win back). All a golf win does in the level is raise the "MINI GAME CLEAR" gates, so the gates already in the room go up (or down) right away, and the ones further on spawn that way. Wario stays where he is: nothing is reloaded. (If you close a gate on Wario, jump out of it.) See [GOLF and the room reload](https://lautarodragan.github.io/warioland3/debug-menu.html#golf-and-the-room-reload) for how it used to work and why it reset the game.
- OWL: press A to spawn a sleeping owl next to Wario, in any level. It can be woken, grabbed and flown like a real owl. In rooms whose enemy set has no owl, its graphics go into a graphics slot the set doesn't use, or, if it uses all four, into one the room lends while the owl is around: one no enemy on screen is using, whose enemies don't appear meanwhile, and which gets its graphics back once the owl is gone. Wario can fly holding it into other rooms, as with the real one. Shows NO when there's no free object slot, and in boss battles.
- TREASURE: pick any level's treasure with LEFT/RIGHT (e.g. `N5 RED`) and press A to give it to Wario or take it back; it shows OPEN or CLOSED, like the treasure's chest. Treasures that open new paths (like N5's Foot of Stone opening a secret door in S4) take effect the next time you enter a level from the map, as in the real game.

Navigate with UP/DOWN. FORM, POWER and TREASURE cycle with LEFT/RIGHT (FORM and POWER show ◀ ▶ on the selected row); GOLF, OWL and TREASURE apply with A. Exit with B or SELECT. The menu plays the pause menu's music. How it works is in the [book](https://lautarodragan.github.io/warioland3/debug-menu.html).

Other features:
- Auto swim while holding down A or B rather than having to continuously press it
- Auto fly as Vampire Wario's bat while holding down A, same as autoswim
- Pressing SELECT while in a FORM will automatically turn you back into normal Wario first. Press SELECT again to open the DEBUG menu. This applies whenever you're in a non-normal form, regardless of whether you activated it via the DEBUG MENU or through normal gameplay.

## Why

For fun! This is more a cheating menu than a debug menu, really. I played Wario Land 3 probably over 20 times, through and through. I still don't get tired of it. This is just another way to play it.

## How to Play

It also builds the following patch:

- CGBAW8A0.155.patch `sha1: b98b89fa4c72b5837fd414d31259126145738634`

To assemble, download RGBDS (https://github.com/gbdev/rgbds/releases) and extract it to /usr/local/bin. Run `make` in your shell. The build output will be "warioland3.gbc".

## Patching

To generate the patch yourself:

```sh
make ips
```

This builds the modified ROM, reconstructs the *original* ROM from the pre-debug-menu commit (verifying it against that commit's `rom.sha1`), diffs the two, and writes `warioland3-debug-menu.ips`. No extra dependencies beyond RGBDS and Python 3 — the IPS is produced by `tools/make_ips.py`.

To **play the patch**, apply `warioland3-debug-menu.ips` to a Wario Land 3 ROM whose SHA1 is `bb7877309834441fd03adb7fa65738e5d5b2d7ba`, using any IPS patcher ([Floating IPS / flips](https://github.com/Alcaro/Flips), or a web tool like [rompatcher.js](https://www.marcrobledo.com/RomPatcher.js/)).

Pre-built patches are published on the [Releases](../../releases) page. Pushing a `v*` tag triggers the `release` workflow, which builds the patch and uploads it to a new release automatically.

## Tests

`tests/` drives the built ROM in [PyBoy](https://github.com/Baekalfen/PyBoy) and compares screenshots against goldens in `tests/goldens/`.

```nu
pip install -r tests/requirements.txt
make test
# after checking tests/output/*.png by eye, accept them as the new goldens:
python3 -m pytest tests --update-goldens
```

What each test covers, the route tools and why goldens drift are in the [book](https://lautarodragan.github.io/warioland3/testing.html).

## Technical documentation

The [book](https://lautarodragan.github.io/warioland3/) (sources in `book/`) is for people and AIs working on the code: building, the tests, how to change the code safely, how the debug menu and the debug owl work, the naming survey, and what was done in this fork.

## Where

Tested with [gearboy](https://github.com/drhelius/Gearboy), and played through-and-through on a real Gameboy Color with an EverDrive. The game can be played completely, without issues.

### Known Bugs

- OWL: in rooms whose enemy set has no owl and uses all four graphics slots, one kind of enemy doesn't appear while the debug owl is around (it comes back once the owl is gone), and enemies of that kind already there when it's spawned draw with the owl's graphics until they go (the owl picks a kind none of the active enemies is, when there is one). See [The debug owl](https://lautarodragan.github.io/warioland3/debug-owl.html) for this, and the bug that broke the first attempt.

## How

This was entire vibe-coded. I do have 23 years of experience writing code, but I don't know ASM, and learning it to implement such features in a GB game isn't a top priority of mine. I did read parts of the implementation out of curiosity, ask Claude questions about it, made small changes to see what would happen, and read the first part of [gb-asm-tutorial](https://gbdev.io/gb-asm-tutorial/index.html) (highly recommended resource! extremely friendly — way friendlier than the usual learning resources for programming, in general).

I also did some debugging with Gearboy's debugging options.

My role as more QA than programmer. 

Here's the whole conversation with Claude that I had to make these changes: https://claude.ai/code/session_01F8cyT2Vr9JeFoMFFZrHiwx. I think there's value in it, which is why I'm sharing it publicly. Seeing what the AI did was a way of learning, to me, and might be, too, to GB development newbies.

## Origin

This is a fork of [ElectroDeoxys/warioland3](https://github.com/ElectroDeoxys/warioland3).

## Links

- [gbdev.io/gb-asm-tutorial](https://gbdev.io/gb-asm-tutorial/index.html)
- [rgbds.gbdev.io/docs](https://rgbds.gbdev.io/docs/v1.0.1)

