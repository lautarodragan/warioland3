"""Debug menu GOLF: auto-win the current area's golf minigame.

wIsMinigameCleared only decides whether the clear gates (the "MINI GAME
CLEAR" signs that block a passage) are raised, so GOLF moves the gates in
the room instead of reloading it. It used to reload the room as if Wario
had come through a door where he stood: the room it loaded was the one a
door in Wario's sector leads to, so most rooms reset the game (no door
there: a NULL room) and others sent Wario to another room.
"""

from game import ST_DEBUG_MENU, ST_LEVEL, SST_LEVEL_UPDATE
from test_debug_menu import CURSOR_GOLF

# src/constants/level_constants.asm: <LEVEL>_DAY_1 is level index * 8
DAY_1_LEVELS = [n * 8 for n in range(25)]
THE_TEMPLE = 0xC8
THE_VAST_PLAIN_DAY_1 = 0x10

# src/constants/level_constants.asm
ROOMTRANSITION_DOOR = 2
ROOMTRANSITIONF_RELOAD_OBJECTS = 1 << 6
SST_LEVEL_FAST_FADE_TO_WHITE = 5  # then StartRoom_FromTransition

GATE_RAISE = 32  # pixels, ClearGateFunc


def toggle_golf(game, toggle=True):
    """Open the menu and toggle GOLF; with toggle=False, the same inputs
    and frames without the toggle."""
    game.open_debug_menu()
    game.menu_press("down", CURSOR_GOLF)
    assert game.read("wDebugMenuCursor") == CURSOR_GOLF
    cleared = game.read("wIsMinigameCleared")
    if toggle:
        game.menu_press("right")
    else:
        game.tick(4 + 10)
    assert game.read("wIsMinigameCleared") == (cleared ^ toggle)


def close_and_watch(game, frames=120):
    """Close the menu, returning every state the game went through."""
    game.press("b")
    states = []
    for _ in range(frames):
        game.tick()
        if not states or states[-1] != game.state:
            states.append(game.state)
    return states


def room(game):
    return game.read("wLevelRoomID"), game.read("wCameraConfigFlags")


def gates(game):
    """Y positions of the clear gates that are set up, by object slot."""
    update = game.addr("ClearGateFunc.Update")
    out = {}
    for n in range(1, 9):
        if not game.read(f"wObj{n}Flags") & 1:
            continue
        bank, addr = game.pb.symbol_lookup(f"wObj{n}UpdateFunction")
        if game.pb.memory[bank, addr] | game.pb.memory[bank, addr + 1] << 8 != update:
            continue
        bank, addr = game.pb.symbol_lookup(f"wObj{n}YPos")
        out[n] = game.pb.memory[bank, addr] | game.pb.memory[bank, addr + 1] << 8
    return out


def door_to(game, sector):
    """Load the room a door in `sector` leads to, as the game does after a
    door: Wario's position picks the sector, and StartRoom_FromTransition
    loads that sector's room (what GOLF used to do from wherever Wario
    stood)."""
    for symbol, hi in (("wWarioYPos", sector // 10), ("wWarioXPos", sector % 10)):
        addr = game.addr(symbol)
        game.pb.memory[addr] = hi
        game.pb.memory[addr + 1] = 0x80
    game.write("wRoomTransitionParam", ROOMTRANSITION_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS)
    game.write("wSubState", SST_LEVEL_FAST_FADE_TO_WHITE)
    game.wait_until(lambda: game.state == (ST_LEVEL, SST_LEVEL_UPDATE), what="room")
    game.tick(60)


def test_golf_start_rooms(game, golden):
    # Every level's start room (and The Temple, a boss battle): GOLF flips
    # the flag and play carries on where it was. Out of the Woods used to
    # reset the game, The Volcano's Base to send Wario into a room of
    # water, and so on.
    game.new_game_to_overworld()
    base = game.snapshot()
    for level in DAY_1_LEVELS + [THE_TEMPLE]:
        game.restore(base)
        game.enter_level(level)
        entered = game.snapshot()
        # Where Wario ends up without GOLF (enemies push him around in
        # some start rooms).
        toggle_golf(game, toggle=False)
        close_and_watch(game)
        expected = game.wario_pos(), room(game)

        game.restore(entered)
        toggle_golf(game)
        if level == 0:
            golden("debug_menu_golf_on", game.screenshot())
        states = close_and_watch(game)
        # Straight back to play: no fade, room load or reset.
        assert [s for s in states if s[0] != ST_DEBUG_MENU] == [
            (ST_LEVEL, SST_LEVEL_UPDATE)
        ], (level, states)
        assert (game.wario_pos(), room(game)) == expected, level
        assert game.read("wIsMinigameCleared"), level
        if level == 0:
            golden("debug_golf_out_of_the_woods", game.screenshot())


def test_golf_raises_and_lowers_gate(game, golden):
    # The Vast Plain: the room behind the golf building, Wario right next
    # to its gate.
    game.new_game_to_overworld()
    game.enter_level(THE_VAST_PLAIN_DAY_1)
    door_to(game, 10)
    closed = gates(game)
    assert len(closed) == 1
    golden("debug_golf_gate_closed", game.screenshot())
    snap = game.snapshot()

    toggle_golf(game)
    game.close_debug_menu()
    raised = gates(game)
    assert raised == {n: y - GATE_RAISE for n, y in closed.items()}
    golden("debug_golf_gate_raised", game.screenshot())

    # Where the game itself puts it: loading the room with the flag set.
    game.restore(snap)
    game.write("wIsMinigameCleared", 1)
    door_to(game, 10)
    assert gates(game) == raised

    # And back down when GOLF is turned off again.
    game.restore(snap)
    toggle_golf(game)
    game.close_debug_menu()
    toggle_golf(game)
    game.close_debug_menu()
    assert not game.read("wIsMinigameCleared")
    assert gates(game) == closed
    golden("debug_golf_gate_closed_again", game.screenshot())


def test_golf_gate_spawned_later(game):
    # Gates that aren't set up yet read the flag themselves when they
    # spawn: GOLF in The Vast Plain's start room, then into the gate's room.
    game.new_game_to_overworld()
    game.enter_level(THE_VAST_PLAIN_DAY_1)
    toggle_golf(game)
    game.close_debug_menu()
    door_to(game, 10)
    snap = game.snapshot()
    raised = gates(game)

    game.restore(snap)
    game.write("wIsMinigameCleared", 0)
    door_to(game, 10)
    assert raised == {n: y - GATE_RAISE for n, y in gates(game).items()}
