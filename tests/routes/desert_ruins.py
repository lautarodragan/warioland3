"""Inputs for Desert Ruins (W1, day), from the frame the level becomes
playable on a new game (Game.enter_level(DESERT_RUINS_DAY_1)), for the debug
owl. Steps are (buttons, frames) for Game.play.
"""

# Dash at the owl spawned to Wario's right to wake it, wait under it while it
# flies up, and jump to grab it.
START_ROOM_GRAB_DEBUG_OWL = [("right+b", 50), ("", 60), ("a", 35), ("", 15)]

# Fly left over the hands' quicksand pits, to the spearhead on the far side.
OWL_FLIGHT_TO_SPEARHEAD = [("left", 60), ("left", 60), ("left", 60)]

# B lets go of the owl, which flies off up the screen.
LET_GO = [("b", 4), ("", 6)]
