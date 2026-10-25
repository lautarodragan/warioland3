"""The debug owl in the situations around a grab and a flight.

Wario can't die in Wario Land 3 (there are no lives), so there's no
"dying while holding the owl" case.
"""

from game import (
    LEVEL_THE_COLOSSAL_HOLE,
    OWL,
    ST_LEVEL,
    ST_OVERWORLD,
    THE_COLOSSAL_HOLE_DAY_1,
)
from test_owl import (
    CURSOR_OWL,
    OWL_STATUS_FAILED,
    OWL_STATUS_SPAWNED,
    TRANSFORMATION_OWL_WARIO,
    grab_debug_owl_past_robot,
    never_in_solid_blocks,
    spawn_owl,
    spawned_owls,
)

THE_COLOSSAL_HOLE_NIGHT_1 = 0xAC
NUM_OBJECTS = 8
TRANSFORMATION_NONE = 0x00
# src/constants/wario_constants.asm
WST_RELEASING_OWL = 0xBB
WST_FALLING_FROM_OWL = 0xBC
SPAWN_X_OFFSET = 24  # DEBUG_SPAWN_X_OFFSET


def owl_position(game, slot):
    mem = game.pb.memory
    bank, addr = game.pb.symbol_lookup(f"wObj{slot}YPos")
    y = mem[bank, addr] | mem[bank, addr + 1] << 8
    bank, addr = game.pb.symbol_lookup(f"wObj{slot}XPos")
    x = mem[bank, addr] | mem[bank, addr + 1] << 8
    return y, x


def test_debug_owl_let_go(game, golden):
    grab_debug_owl_past_robot(game)
    in_bounds = never_in_solid_blocks(game, "THE_COLOSSAL_HOLE_DAY_1")
    game.play([("right", 40)], on_frame=in_bounds)

    # B lets go: the owl flies off (as a particle, it's no object anymore)
    # and Wario falls to the ground, back to normal.
    states = []

    def record():
        in_bounds()
        state = game.read("wWarioState")
        if state not in states:
            states.append(state)

    game.play([("b", 4), ("", 150)], on_frame=record)
    assert states[:2] == [WST_RELEASING_OWL, WST_FALLING_FROM_OWL]
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    assert game.wario_block() == (28, 29)
    golden("debug_owl_let_go", game.screenshot())

    # Walls still stop him on foot.
    game.play([("left", 120)], on_frame=in_bounds)


def test_debug_owl_offscreen(game, golden):
    # A spawned owl has no object map entry: going offscreen has to remove
    # it cleanly, without marking the map, and it must not come back.
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)
    spawn_owl(game)
    game.close_debug_menu()
    assert len(spawned_owls(game)) == 1
    in_bounds = never_in_solid_blocks(game, "THE_COLOSSAL_HOLE_DAY_1")

    # Dash right, past the robot, far enough for the owl to go.
    game.play([("right+b", 356)], on_frame=in_bounds)
    assert spawned_owls(game) == []
    assert game.wario_block() == (28, 32)

    # Back where it was: the real owl on the ledge respawns from the map,
    # the spawned one doesn't.
    game.play([("", 30), ("left", 240)], on_frame=in_bounds)
    assert game.wario_block() == (28, 20)
    assert spawned_owls(game) == []
    assert [obj_id for _, _, obj_id in game.objects()].count(OWL) == 1
    golden("debug_owl_offscreen_back", game.screenshot())


def test_debug_owl_leave_level_holding_it(game, golden):
    grab_debug_owl_past_robot(game)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO

    game.return_to_map()
    assert game.state[0] == ST_OVERWORLD
    golden("debug_owl_left_level_map", game.screenshot())

    # The next level starts with plain Wario. (Leaving switched to night.)
    game.enter_level_from_map(LEVEL_THE_COLOSSAL_HOLE)
    assert game.read("wLevel") == THE_COLOSSAL_HOLE_NIGHT_1
    assert game.read("wTransformation") == TRANSFORMATION_NONE
    in_bounds = never_in_solid_blocks(game, "THE_COLOSSAL_HOLE_NIGHT_1")
    game.play([("right", 60), ("left", 60)], on_frame=in_bounds)
    assert game.state[0] == ST_LEVEL
    golden("debug_owl_left_level_back", game.screenshot())


def test_debug_owl_at_night(game, golden):
    # At night owls don't sleep: like the real one, the spawned owl flies up
    # right away and patrols, ready to be grabbed from below.
    game.new_game_to_overworld()
    game.enter_level()
    game.return_to_map()
    game.enter_level_from_map(LEVEL_THE_COLOSSAL_HOLE)
    assert game.read("wLevel") == THE_COLOSSAL_HOLE_NIGHT_1
    y, x = game.wario_pos()

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    (slot,) = spawned_owls(game)
    owl_y, _ = owl_position(game, slot)
    assert owl_y < y  # already flying
    golden("debug_owl_night", game.screenshot())

    in_bounds = never_in_solid_blocks(game, "THE_COLOSSAL_HOLE_NIGHT_1")
    game.play([("a", 35), ("", 15)], on_frame=in_bounds)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert spawned_owls(game) == []
    game.play([("", 60)], on_frame=in_bounds)
    golden("debug_owl_night_flight", game.screenshot())


def test_debug_owl_against_a_wall(game, golden):
    # Spawned 24px to Wario's right, the owl can overlap a wall, here the
    # block at (26, 24). Owls never collide with terrain (real ones fly
    # through it too: they only use MoveObjectUp/Left/Right), so this is
    # harmless: it just sits there, and the game goes on.
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)
    game.play([("right", 60), ("", 20)])
    y, x = game.wario_pos()

    spawn_owl(game)
    assert game.read("wDebugMenuOwlStatus") == OWL_STATUS_SPAWNED
    game.close_debug_menu()
    (slot,) = spawned_owls(game)
    assert owl_position(game, slot) == (y, x + SPAWN_X_OFFSET)
    owl_y, owl_x = owl_position(game, slot)
    assert (owl_x + 6) // 16 == 24 and (owl_y - 20) // 16 == 26  # top right in the wall

    game.tick(120)
    assert owl_position(game, slot) == (owl_y, owl_x)
    assert game.state[0] == ST_LEVEL
    golden("debug_owl_against_wall", game.screenshot())


def test_debug_owl_fills_object_slots(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)
    free = NUM_OBJECTS - len(game.objects())

    game.open_debug_menu()
    game.menu_press("down", CURSOR_OWL)
    statuses = []
    for _ in range(free + 2):
        game.menu_press("right")
        statuses.append(game.read("wDebugMenuOwlStatus"))
    # One owl per free slot, then NO.
    assert statuses == [OWL_STATUS_SPAWNED] * free + [OWL_STATUS_FAILED] * 2
    assert len(game.objects()) == NUM_OBJECTS
    golden("debug_menu_owl_slots_full", game.screenshot())

    game.close_debug_menu()
    assert len(spawned_owls(game)) == free
    game.tick(120)
    assert game.state[0] == ST_LEVEL
    golden("debug_owl_slots_full", game.screenshot())
