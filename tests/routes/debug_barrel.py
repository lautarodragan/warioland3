"""Inputs around the debug menu's barrel (see tests/test_barrel.py). Steps are
(buttons, frames) for Game.play. Found by stepping through them frame by
frame, then checked by eye.
"""

# Starts right after closing the debug menu, with a barrel just spawned 24px
# to Wario's right and the Grab Glove (POWER 4): walk into it, which picks it
# up, and on with it over his head.
GRAB_AND_CARRY = [("right", 40), ("", 10)]

# Holding the barrel: throw it (a tap of B), and give it time to fly, break
# against what it hits, and vanish.
THROW = [("b", 4), ("", 10)]
