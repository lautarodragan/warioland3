"""Inputs for The Colossal Hole (day), starting the frame the level becomes
playable. Steps are (buttons, frames) for Game.play. Found with
tests/tools/route_search.py.

The start room loads object group 031, which has an owl sleeping on a ledge
a few blocks to the right.
"""

# Dash right until the sleeping owl is on screen.
TO_SLEEPING_OWL = [("right+b", 120)]

# Climb onto the owl's ledge and bump the owl awake, then jump up and grab
# it from below as it flies up.
WAKE_AND_GRAB_OWL = [
    ("right+up", 30), ("right+a", 35), ("", 15), ("right+b", 60), ("a", 35),
]

# From the start, with an owl just spawned from the debug menu 24px to
# Wario's right: bash it awake, then jump up and grab it.
WAKE_AND_GRAB_DEBUG_OWL = [('right+b', 120), ('left+up', 30), ('left+b', 12), ('', 10), ('right+a', 35), ('', 15)]

# SELECT, down to OWL, RIGHT to spawn an owl next to Wario, B to close.
DEBUG_MENU_SPAWN_OWL = [('select', 4), ('', 90), ('down', 4), ('', 10), ('down', 4), ('', 10), ('down', 4), ('', 10), ('down', 4), ('', 10), ('right', 4), ('', 10), ('b', 4), ('', 90)]

# From TO_SLEEPING_OWL plus a second's wait and DEBUG_MENU_SPAWN_OWL, i.e.
# past the robot guarding the start pocket: grab the spawned owl.
GRAB_DEBUG_OWL_PAST_ROBOT = [('right+b', 120), ('left', 20), ('a', 35), ('', 15)]
