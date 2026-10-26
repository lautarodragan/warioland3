"""Vampire Wario's bat, from the debug menu's FORM, in a room with floor
transitions.

Bats only fly in rooms with a free camera in the original game, so the bat
never asked for floor transitions: in Out of the Woods' start room it flew
up out of the screen, with the camera left on the floor below.
"""

from game import OUT_OF_THE_WOODS_DAY_1
from test_owl import never_in_solid_blocks

FORM_VAMPIRE = 10  # DebugFormTable index (the FORM row is the first one)
TRANSFORMATION_VAMPIRE_WARIO = 0x4B
WST_BAT_IDLING = 0xA1
OAM_Y_OFS = 16
SCREEN_HEIGHT = 144
BAT_HEIGHT = 16


def test_bat_floor_transitions(game, golden):
    game.new_game_to_overworld()
    game.enter_level(OUT_OF_THE_WOODS_DAY_1)
    game.open_debug_menu()
    game.menu_press("right", FORM_VAMPIRE)
    game.close_debug_menu()
    assert game.read("wTransformation") == TRANSFORMATION_VAMPIRE_WARIO
    game.play([("b", 4), ("", 60)])  # turn into a bat
    assert game.read("wFloor") == 1
    in_bounds = never_in_solid_blocks(game, "OUT_OF_THE_WOODS_DAY_1")

    def visible():
        in_bounds()
        if game.read("wFloorTransitionDir") == 0:
            feet = game.read("wWarioScreenYPos") - OAM_Y_OFS
            assert BAT_HEIGHT <= feet <= SCREEN_HEIGHT, game.wario_pos()

    # Flapping up into the second floor: the camera follows a floor up.
    game.play([("a", 20)] * 8, on_frame=visible)
    assert game.read("wFloor") == 2
    golden("bat_floor_up", game.screenshot())

    # Falling back down to the ground, and the camera with it.
    game.play([("", 120)], on_frame=visible)
    assert game.read("wFloor") == 1
    assert game.read("wWarioState") == WST_BAT_IDLING
    golden("bat_floor_down", game.screenshot())
