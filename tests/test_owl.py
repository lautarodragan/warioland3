"""Debug menu owl spawning, exercised in the real game.

The Steep Canyon is one of the levels that has owls (object group 095,
room 10), so that's where we spawn one.
"""

from game import THE_STEEP_CANYON_DAY_1


def test_steep_canyon_before_owl_spawn(game, golden):
    game.new_game_to_overworld()
    game.enter_level(THE_STEEP_CANYON_DAY_1)
    golden("steep_canyon_before_owl", game.screenshot())
