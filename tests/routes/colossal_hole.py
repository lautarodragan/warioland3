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
