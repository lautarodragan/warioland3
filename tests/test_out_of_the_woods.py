"""Play through Out of the Woods (N1) from a new game, inputs only."""

from game import ST_CLEAR, ST_OVERWORLD, SST_OVERWORLD_0B
from routes.out_of_the_woods import TO_GREY_CHEST, TO_GREY_KEY

# wKeyAndTreasureFlags bits, src/constants/level_constants.asm
GREY_KEY = 1 << 0
GREY_TREASURE = 1 << 4


def test_out_of_the_woods(game, golden):
    game.new_game_to_overworld()
    assert game.num_collected_treasures() == 0

    game.enter_level()
    assert game.read("wKeyAndTreasureFlags") == 0

    game.play(TO_GREY_KEY)
    assert game.read("wKeyAndTreasureFlags") == GREY_KEY
    golden("out_of_the_woods_grey_key", game.screenshot())

    game.play(TO_GREY_CHEST)
    assert game.read("wKeyAndTreasureFlags") == GREY_KEY | GREY_TREASURE

    game.wait_until(lambda: game.read("wState") == ST_CLEAR, what="clear screen")
    game.tick(300)
    golden("out_of_the_woods_clear", game.screenshot())

    # The clear screen hands back to the map, which shows the newly opened
    # levels and autosaves.
    game.press_until(
        "a", lambda: game.read("wState") == ST_OVERWORLD, what="overworld"
    )
    game.wait_until(
        lambda: game.state == (ST_OVERWORLD, SST_OVERWORLD_0B),
        timeout=60 * 120,
        what="idle overworld",
    )
    game.tick(60)
    assert game.num_collected_treasures() == 1
    golden("out_of_the_woods_overworld_after", game.screenshot())
