"""Action Help's edit mode (src/engine/action_help/edit_mode.asm): SELECT
turns it on and off, A sets the power-up level to the selected one."""

from game import ST_LEVEL

ST_PAUSE_MENU = 0x04
ST_ACTION_HELP = 0x07

GRAB_GLOVE = 4
HIGH_JUMP_BOOTS = 7

BAR = 0x9C00 + 16 * 32  # v0BGMap1, the power-up bar's first row
LOCKED_TILE = 0x64  # the "?" box
PAL_OWNED, PAL_LOCKED = 3, 7  # brown (grey in the mode), the "?" boxes'
PAL_RED, PAL_BLUE = 5, 7  # OBPAL_POWER_UP_*: GRAB_GLOVE's, HIGH_JUMP_BOOTS'


def bar(game):
    """Each slot's top left tile and palette."""
    mem = game.pb.memory
    return [(mem[0, BAR + 2 * i], mem[1, BAR + 2 * i] & 7) for i in range(10)]


def icon_tile(slot):
    return 0x40 + 2 * slot if slot < 8 else 0x60 + 2 * (slot - 8)


def open_action_help(game, power):
    game.new_game_to_overworld()
    game.enter_level()
    game.write("wPowerUpLevel", power)
    game.press("start", wait=60)
    assert game.state[0] == ST_PAUSE_MENU
    game.press("right", wait=20)  # RETURN, SAVE, ACTION HELP
    game.press("right", wait=20)
    game.press("a", wait=150)
    assert game.state[0] == ST_ACTION_HELP


def test_action_help_edit_mode(game, golden):
    open_action_help(game, GRAB_GLOVE)
    assert game.read("wActionHelpPowerUp") == GRAB_GLOVE
    normal = bar(game)
    assert normal[:4] == [(icon_tile(i), PAL_OWNED) for i in range(4)]
    assert normal[4] == (icon_tile(4), PAL_RED)  # selected
    assert normal[5:] == [(LOCKED_TILE, PAL_LOCKED)] * 5

    # SELECT: every icon, the owned ones in their colours, the others grey
    game.press("select", wait=30)
    assert game.read("wActionHelpEditMode") == 1
    edit = bar(game)
    assert [tile for tile, _ in edit] == [icon_tile(i) for i in range(10)]
    assert all(pal != PAL_OWNED for _, pal in edit[:5])
    assert all(pal == PAL_OWNED for _, pal in edit[5:])
    golden("action_help_edit_mode", game.screenshot())

    # A on the High Jump Boots: the power-up level, without closing
    for _ in range(3):
        game.press("right", wait=20)
    assert game.read("wActionHelpPowerUp") == HIGH_JUMP_BOOTS
    game.press("a", wait=30)
    assert game.read("wPowerUpLevel") == HIGH_JUMP_BOOTS
    assert game.state[0] == ST_ACTION_HELP
    assert bar(game)[HIGH_JUMP_BOOTS] == (icon_tile(HIGH_JUMP_BOOTS), PAL_BLUE)
    assert bar(game)[8] == (icon_tile(8), PAL_OWNED)

    # SELECT again: the game's bar, now up to the boots; A closes again
    game.press("select", wait=30)
    assert game.read("wActionHelpEditMode") == 0
    assert bar(game) == (
        [(icon_tile(i), PAL_OWNED) for i in range(7)]
        + [(icon_tile(7), PAL_BLUE)]
        + [(LOCKED_TILE, PAL_LOCKED)] * 2
    )
    game.press("a", wait=60)
    assert game.state[0] == ST_PAUSE_MENU
    game.press("a", wait=120)  # RETURN
    game.wait_until(lambda: game.state[0] == ST_LEVEL, what="the level")
    assert game.read("wPowerUpLevel") == HIGH_JUMP_BOOTS
