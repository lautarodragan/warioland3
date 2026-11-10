"""The debug menu's BARREL: the grabbable barrel (BARREL2), spawned next to
Wario in any room.

Barrel object groups put its graphics in enemy graphics slot 4, and its OAM
data draws from slot 4's tiles in palette 7. In a room without them the
barrel goes through the same machinery as the debug owl (book/src/debug-owl.md,
"The barrel"): its graphics go into a slot the room's group doesn't use, or
one it borrows and gives back once the barrel is gone, and its sprites are
moved there as they're drawn.

The Big Bridge's start room (object group 073) has barrels: the reference
for what the barrel's tiles, palette and sprites look like.
"""

from game import OUT_OF_THE_WOODS_DAY_1, ROOT
from routes.debug_barrel import GRAB_AND_CARRY, THROW
from test_owl import (
    OWL_STATUS_FAILED,
    SLOT_TILES,
    never_in_solid_blocks,
    owl_tiles_in_slot,
    slot_tiles,
    spawn_owl,
    vram1_sprites,
)
from test_owl_free_slot import (
    APPLEBY,
    DESERT_RUINS_DAY_1,
    DEBUG_GFX_BORROWED,
    assert_slot_given_back,
    ob_pal,
    obj_data_ptrs,
    out_of_the_woods_room,
)

BARREL2 = 0x05
CURSOR_POWER = 1
CURSOR_BARREL = 4
BARREL_STATUS_SPAWNED = 1
BARREL_STATUS_FAILED = 2
GRAB_GLOVE = 4
DEBUG_GFX_BARREL = 1 << 1  # wDebugGfxSlot's kind bits
WST_GRAB_IDLING = 0x1F
WST_GRAB_WALKING = 0x20
OBJFLAG_GRABBED = 1 << 2

THE_BIG_BRIDGE_DAY_1 = 0x68
ABOVE_THE_CLOUDS_DAY_1 = 0x88
THE_TEMPLE = 0xC8

BARREL_GFX = (ROOT / "src/gfx/enemies/barrel.2bpp").read_bytes()
BARREL_TILES = 0xC0  # slot 4, where its OAM data draws from
BARREL_PAL = 7


def barrel_pal_rgb(game, pal):
    """Object palette `pal` as the four colours the game wrote to the LCD
    (rOBPD), not just wTempPals2."""
    obpi = game.pb.memory[0xFF6A]
    colours = []
    for n in range(4):
        game.pb.memory[0xFF6A] = pal * 8 + n * 2  # rOBPI
        lo = game.pb.memory[0xFF6B]
        game.pb.memory[0xFF6A] = pal * 8 + n * 2 + 1
        colours.append(lo | game.pb.memory[0xFF6B] << 8)
    game.pb.memory[0xFF6A] = obpi
    return colours


def barrels(game):
    return [slot for slot, _, obj_id in game.objects() if obj_id == BARREL2]


def barrel_sprites(game, tiles, pal):
    """The visible VRAM1 sprites drawn from the barrel's slot (`tiles` is its
    first tile), as (tile from the slot's start, palette)."""
    return sorted(
        (tile - tiles, p) for tile, p in vram1_sprites(game) if tiles <= tile < tiles + SLOT_TILES
    )


def sram_enabled(game):
    # Cartridge RAM reads $ff while it's switched off (what DespawnObject
    # writing to $0000 used to do, see the debug owl's page).
    return any(game.pb.memory[0xA000 + i] != 0xFF for i in range(0x100))


def spawn_barrel(game, power=None):
    """Opens the menu, optionally sets POWER, and presses A on BARREL."""
    game.open_debug_menu()
    if power is not None:
        game.menu_press("down", CURSOR_POWER)
        game.menu_press("right", power)
        assert game.read("wPowerUpLevel") == power
        game.menu_press("down", CURSOR_BARREL - CURSOR_POWER)
    else:
        game.menu_press("down", CURSOR_BARREL)
    assert game.read("wDebugMenuCursor") == CURSOR_BARREL
    game.menu_press("a")


def native_barrel(game):
    """The Big Bridge, from the map: the barrel's graphics and its palette,
    as the level loads them, with a barrel spawned."""
    game.enter_level(THE_BIG_BRIDGE_DAY_1)
    spawn_barrel(game)
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_SPAWNED
    game.close_debug_menu()
    return slot_tiles(game, 4), barrel_pal_rgb(game, BARREL_PAL)


def test_barrel_in_room_with_barrels(game, golden):
    # The group has the barrel: it's spawned from the group's data and drawn
    # with the group's graphics, nothing loaded or moved.
    game.new_game_to_overworld()
    tiles, pal = native_barrel(game)
    assert len(barrels(game)) == 1
    assert game.read("wDebugGfxSlot") == 0
    assert tiles == BARREL_GFX
    assert barrel_sprites(game, BARREL_TILES, BARREL_PAL) == [(0, 7), (2, 7)]
    golden("big_bridge_debug_barrel", game.screenshot())


def test_barrel_in_free_slot(game, golden):
    # Desert Ruins' start room (group 023) leaves slots 2 and 4 unused: the
    # barrel's graphics go into slot 2, its palette into palette 5, and its
    # sprites are moved there. Tiles, colours and sprites are the real
    # barrel's (The Big Bridge's).
    game.new_game_to_overworld()
    on_the_map = game.snapshot()
    tiles, pal = native_barrel(game)
    game.restore(on_the_map)
    game.enter_level(DESERT_RUINS_DAY_1)
    spearhead = slot_tiles(game, 1)
    spawn_barrel(game)
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_SPAWNED
    golden("debug_menu_barrel_spawned", game.screenshot())
    game.close_debug_menu()

    assert len(barrels(game)) == 1
    assert game.read("wDebugGfxSlot") == 0x40 | DEBUG_GFX_BARREL
    assert slot_tiles(game, 2) == tiles
    assert slot_tiles(game, 1) == spearhead
    assert barrel_pal_rgb(game, 5) == pal
    assert barrel_sprites(game, 0x40, 5) == [(0, 5), (2, 5)]
    assert barrel_sprites(game, BARREL_TILES, BARREL_PAL) == []
    golden("desert_ruins_debug_barrel", game.screenshot())


def test_barrel_grab_carry_throw(game, golden):
    # With the Grab Glove: Wario picks it up, carries it over his head (drawn
    # from slot 2 all along) and throws it; it flies off and vanishes. The
    # spawned barrel has no object map entry, and cartridge RAM (the level's
    # block map) stays on.
    game.new_game_to_overworld()
    game.enter_level(DESERT_RUINS_DAY_1)
    spawn_barrel(game, power=GRAB_GLOVE)
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_SPAWNED
    game.close_debug_menu()
    in_bounds = never_in_solid_blocks(game, "DESERT_RUINS_DAY_1")

    game.play(GRAB_AND_CARRY, on_frame=in_bounds)
    assert game.read("wWarioState") in (WST_GRAB_IDLING, WST_GRAB_WALKING)
    [slot] = barrels(game)
    assert game.read(f"wObj{slot}Flags") & OBJFLAG_GRABBED
    assert barrel_sprites(game, 0x40, 5) == [(0, 5), (2, 5)]
    golden("desert_ruins_debug_barrel_carried", game.screenshot())

    game.play(THROW, on_frame=in_bounds)
    assert game.read("wWarioState") not in (WST_GRAB_IDLING, WST_GRAB_WALKING)
    game.wait_until(lambda: barrels(game) == [], timeout=120, what="barrel gone")
    assert sram_enabled(game)
    # Walking on, through the room's blocks as the game reads them.
    game.play([("right", 60), ("left", 90)], on_frame=in_bounds)
    assert sram_enabled(game)
    golden("desert_ruins_debug_barrel_thrown", game.screenshot())


def test_barrel_borrows_an_idle_slot(game, golden):
    # Out of the Woods' start room (group 010) uses all four slots. The
    # spearhead of slot 1 is active, the Applebys of slot 2 aren't: the barrel
    # borrows slot 2, and Applebys aren't spawned while it's around. Thrown at
    # the spearhead, it breaks (its breaking frames drawn from slot 2 too),
    # and once it's gone the slot, its palette and the object data are given
    # back exactly as the room loaded them.
    game.new_game_to_overworld()
    game.enter_level(OUT_OF_THE_WOODS_DAY_1)
    room = out_of_the_woods_room(game)
    spawn_barrel(game, power=GRAB_GLOVE)
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_SPAWNED
    game.close_debug_menu()
    assert game.read("wDebugGfxSlot") == 0x40 | DEBUG_GFX_BARREL | DEBUG_GFX_BORROWED
    assert slot_tiles(game, 2) == BARREL_GFX
    assert slot_tiles(game, 1) == room[0][0]
    ptrs = obj_data_ptrs(game)
    assert ptrs[1] == game.addr("RefusedObjectData")
    assert ptrs[:1] + ptrs[2:] == room[2][:1] + room[2][2:]
    assert not any(obj_id == APPLEBY for _, _, obj_id in game.objects())
    golden("out_of_the_woods_debug_barrel", game.screenshot())

    game.play(GRAB_AND_CARRY)
    [slot] = barrels(game)
    assert game.read(f"wObj{slot}Flags") & OBJFLAG_GRABBED
    game.play([("b", 4)])
    broken = False
    for _ in range(60):
        game.tick()
        sprites = barrel_sprites(game, 0x40, 5)
        if any(tile >= 0x0C for tile, _ in sprites):  # frames 7-14: breaking
            broken = True
            assert {p for _, p in sprites} == {5}
            golden("out_of_the_woods_debug_barrel_breaking", game.screenshot())
            break
    assert broken
    game.wait_until(lambda: game.read("wDebugGfxSlot") == 0, timeout=60, what="slot back")
    assert barrels(game) == []
    assert_slot_given_back(game, room)
    assert sram_enabled(game)


def test_barrel_and_owl(game, golden):
    # Only one kind's graphics can be out of their own slot at a time. In
    # Desert Ruins the owl takes slot 2; a barrel then is refused (NO) while
    # the owl is around.
    game.new_game_to_overworld()
    game.enter_level(DESERT_RUINS_DAY_1)
    spawn_owl(game)
    game.menu_press("down")
    game.menu_press("a")
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_FAILED
    golden("debug_menu_barrel_refused_owl", game.screenshot())
    game.close_debug_menu()
    assert barrels(game) == []
    assert game.read("wDebugGfxSlot") == 0x40
    assert owl_tiles_in_slot(game, 2)


def test_barrel_with_owl_in_slot_1(game, golden):
    # Above the Clouds' start room (group 125) leaves slots 1 and 3 unused.
    # The owl takes slot 1, its own (nothing to move), so the barrel can come
    # too, in slot 3: both spawned in the same visit to the menu, both drawn
    # right.
    game.new_game_to_overworld()
    game.enter_level(ABOVE_THE_CLOUDS_DAY_1)
    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == 1
    game.menu_press("down")
    game.menu_press("a")
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_SPAWNED
    game.close_debug_menu()
    assert game.read("wDebugGfxSlot") == 0x80 | DEBUG_GFX_BARREL
    assert owl_tiles_in_slot(game, 1)
    assert slot_tiles(game, 3) == BARREL_GFX
    assert barrel_sprites(game, 0x80, 6) == [(0, 6), (2, 6)]
    assert 4 in {p for tile, p in vram1_sprites(game) if tile < SLOT_TILES}  # the owl


def test_barrel_next_to_owl_in_slot_1(game, golden):
    # The same, the barrel spawned on a second visit to the menu, a few steps
    # to the left (so that the owl doesn't hide it). The other way round, a
    # barrel first, the owl is refused while the barrel is around.
    game.new_game_to_overworld()
    game.enter_level(ABOVE_THE_CLOUDS_DAY_1)
    spawn_owl(game)
    game.close_debug_menu()
    game.play([("left+a", 20), ("left", 10), ("", 40)])
    spawn_barrel(game)
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_SPAWNED
    game.close_debug_menu()
    assert game.read("wDebugGfxSlot") == 0x80 | DEBUG_GFX_BARREL
    assert owl_tiles_in_slot(game, 1)
    assert slot_tiles(game, 3) == BARREL_GFX
    assert barrel_sprites(game, 0x80, 6) == [(0, 6), (2, 6)]
    assert 4 in {p for tile, p in vram1_sprites(game) if tile < SLOT_TILES}
    golden("above_the_clouds_debug_owl_and_barrel", game.screenshot())

    game.open_debug_menu()
    game.menu_press("down", CURSOR_BARREL - 1)
    game.menu_press("a")
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_FAILED


def test_barrel_refused_in_boss_battle(game, golden):
    # The Temple is a boss battle from the start, and bosses keep their
    # graphics in the enemy slots: NO, like the owl.
    game.new_game_to_overworld()
    game.enter_level(THE_TEMPLE)
    assert game.read("wIsBossBattle")
    vram = bytes(game.pb.memory[1, 0x8000:0x9000])
    spawn_barrel(game)
    assert game.read("wDebugMenuBarrelStatus") == BARREL_STATUS_FAILED
    golden("debug_menu_barrel_boss", game.screenshot())
    game.close_debug_menu()
    assert barrels(game) == []
    assert bytes(game.pb.memory[1, 0x8000:0x9000]) == vram
    assert game.read("wDebugGfxSlot") == 0


def test_barrel_saved_and_continued(game, golden):
    # Saving keeps the spawned barrel; continuing loads the room's graphics
    # from its group again, and the barrel's back into the free slot.
    game.new_game_to_overworld()
    game.enter_level(DESERT_RUINS_DAY_1)
    spawn_barrel(game)
    game.close_debug_menu()
    game.save_and_continue()
    assert len(barrels(game)) == 1
    assert game.read("wDebugGfxSlot") == 0x40 | DEBUG_GFX_BARREL
    assert slot_tiles(game, 2) == BARREL_GFX
    assert barrel_sprites(game, 0x40, 5) == [(0, 5), (2, 5)]
    golden("desert_ruins_debug_barrel_saved", game.screenshot())
