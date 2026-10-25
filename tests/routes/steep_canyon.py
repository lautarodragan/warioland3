"""Inputs for The Steep Canyon's second variant (day), the one N5's Foot of
Stone unlocks, with POWER 9 from the debug menu. Starts the frame the level
becomes playable (see test_steep_canyon.py for the setup). Steps are
(buttons, frames) for Game.play. Found with tests/tools/route_search.py
--plan, plus a hand-added jump into the pipe at the end of the corridor.
"""

# Across the water hands' pool to the secret door, into the water corridor.
TO_CORRIDOR = [
    ("right+a", 35), ("", 15), ("a", 12), ("", 20), ("right+b", 120),
    ("right+b", 120), ("right+b", 120), ("right+b", 12), ("", 10),
    ("right+up+a", 35), ("", 15), ("right+up+a", 35), ("", 15),
    ("right+b", 12), ("", 10), ("up+b", 60), ("right+b", 120), ("right+b", 60),
    ("left+b", 12), ("", 10), ("up+a", 35), ("", 15), ("left+up+a", 35),
    ("", 15), ("left+b", 12), ("", 10), ("left+up+a", 35), ("", 15), ("", 30),
    ("up", 6), ("", 150),
]

# Swim right through the corridor and its underwater tunnel, then jump up into
# the pipe to the vertical shaft.
TO_SHAFT = [
    ("right+b", 120), ("right+b", 120), ("right+b", 120), ("right+b", 120),
    ("right+b", 120), ("down", 30), ("right+b", 120), ("right+b", 60),
    ("up+b", 60), ("a", 35), ("", 15), ("up+a", 30), ("up", 30), ("", 200),
]

# Up the lower half of the shaft to the one-way floor halfway up.
UP_THE_SHAFT = [
    ("left+b", 12), ("", 10), ("up+a", 35), ("", 15), ("up+a", 35), ("", 15),
    ("down+b", 60), ("right+up", 30), ("right+b", 12), ("", 10),
    ("left+b", 12), ("", 10), ("right+b", 60), ("up", 90), ("up", 90),
    ("down+b", 60), ("left+b", 60), ("left+up+a", 35), ("", 15), ("up", 90),
    ("down+b", 60), ("right+b", 60), ("right+a", 12), ("", 20),
]
