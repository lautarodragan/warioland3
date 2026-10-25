"""Owls, real and (eventually) spawned from the debug menu.

The Colossal Hole's start room loads the owl's object group (031) and has
an owl sleeping a few blocks in, so it's both the reference for how a real
owl looks and behaves and the place to spawn one where its graphics are
loaded. The Steep Canyon start room doesn't load owl graphics (its owl is
deep in the level), which makes it the case to check spawning against later.
"""

from game import THE_COLOSSAL_HOLE_DAY_1, THE_STEEP_CANYON_DAY_1
from routes.colossal_hole import TO_SLEEPING_OWL, WAKE_AND_GRAB_OWL

# src/constants/wario_constants.asm
TRANSFORMATION_OWL_WARIO = 0x0E
WST_GRABBING_OWL = 0xB8
WST_OWL_SLOW = 0xB9


def test_steep_canyon_before_owl_spawn(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)
    golden("steep_canyon_before_owl", game.screenshot())


def test_real_owl(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_COLOSSAL_HOLE_DAY_1)

    game.play(TO_SLEEPING_OWL)
    golden("colossal_hole_sleeping_owl", game.screenshot())

    game.play(WAKE_AND_GRAB_OWL)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_GRABBING_OWL
    golden("colossal_hole_owl_grabbed", game.screenshot())

    # Holding on, the owl carries Wario up.
    game.tick(120)
    assert game.read("wTransformation") == TRANSFORMATION_OWL_WARIO
    assert game.read("wWarioState") == WST_OWL_SLOW
    golden("colossal_hole_owl_flight", game.screenshot())
