"""Inputs for Out of the Woods (N1, day), starting the frame the level
becomes playable on a new game.

Each step is (buttons, frames): hold `buttons` ("+"-separated, "" for none)
for `frames` frames, then release them and idle for one frame (see
Game.play). Found with tests/tools/route_search.py, then checked by eye.
"""

# Right through the forest, through the walk-in door at the bottom of the
# hill, then up the ledges to the key.
TO_GREY_KEY = [
    ("", 10), ("right", 30), ("right+a", 20), ("right", 20), ("right+a", 20),
    ("right", 20), ("right+a", 20), ("right", 60), ("right+a", 30),
    ("right", 10), ("right+a", 30), ("right", 60), ("right+b", 10),
    ("right", 40), ("right+b", 10), ("right", 40), ("right+b", 10),
    ("right", 40), ("right+b", 10), ("right", 40), ("right+b", 12), ("", 10),
    ("a", 35), ("", 15), ("right+b", 12), ("", 10), ("a", 35), ("", 15),
    ("right+b", 12), ("", 10), ("right+b", 12), ("", 10), ("a", 35), ("", 15),
    ("right+b", 12), ("", 10), ("a", 35), ("", 15), ("right+a", 35), ("", 15),
    ("right+a", 35), ("", 15), ("left+a", 35), ("", 15), ("right", 20),
    ("right+a", 35), ("", 15), ("left+a", 12), ("", 20), ("right+a", 35),
    ("", 15), ("right+b", 12), ("", 10), ("left+a", 35), ("", 15),
    ("right+a", 12), ("", 20), ("left+a", 35), ("", 15), ("left+a", 35),
    ("", 15), ("", 120),
]

# Through the walk-in door below the key, through the door at the top of the
# level, up the ladder, and open the chest.
TO_GREY_CHEST = [
    ("right+a", 35), ("", 15), ("left", 20), ("left", 20), ("", 30), ("up", 6),
    ("", 150), ("right+b", 12), ("", 10), ("right", 20), ("right+b", 12),
    ("", 10), ("", 30), ("up", 6), ("", 150), ("right+a", 35), ("", 15),
    ("right+b", 12), ("", 10), ("right+a", 35), ("", 15), ("right+a", 35),
    ("", 15), ("right+a", 35), ("", 15), ("down", 30), ("down", 30), ("a", 12),
    ("", 20), ("a", 35), ("", 15), ("a", 35), ("", 15), ("left", 20), ("", 30),
    ("up", 6), ("", 150), ("right+a", 35), ("", 15), ("right+a", 35), ("", 15),
    ("right+a", 35), ("", 15), ("left+a", 35), ("", 15), ("left+a", 12),
    ("", 20), ("left+b", 12), ("", 10), ("a", 12), ("", 20), ("left", 60),
    ("a", 30), ("", 30), ("up", 150), ("right+a", 35), ("", 15),
    ("right+up", 30), ("right+a", 35), ("", 15),
]
