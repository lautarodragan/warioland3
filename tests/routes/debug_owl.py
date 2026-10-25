"""Inputs around the debug menu's owl, for levels without one (see
tests/test_owl_levels.py). Steps are (buttons, frames) for Game.play.
Found with throwaway grid searches over these macros, then checked by eye.
"""

# Starts right after closing the debug menu, with an owl just spawned 24px to
# Wario's right, by day: bump it (it wakes up and flies up), step back under
# it, wait for it to come round, and jump into it. It works in every start
# room whose object group has no owl but The Grasslands', whose Hebariis sting
# Wario first.
GRAB_SPAWNED_OWL = [("right", 12), ("left", 8), ("", 80), ("right+a", 35), ("", 15)]

# Starts holding the owl: a short flight, one way and the other.
SHORT_FLIGHT = [("up", 60), ("right", 60), ("left", 90), ("down", 30), ("", 30)]

# The Steep Canyon (day), from the start of the level: into the water to the
# right, where Wario floats at the surface (no power-ups).
STEEP_CANYON_INTO_THE_WATER = [("right", 50), ("", 90)]

# Starts at the surface right after spawning the owl in the water next to
# Wario: swim into it, wait for it to fly up, then jump out of the water into
# it (the second jump gets it).
STEEP_CANYON_GRAB_FROM_THE_WATER = [
    ("right", 20), ("left", 10), ("", 60), ("a", 35), ("", 15), ("right+a", 35),
]

# Holding the owl above the water: back left and down, into it.
STEEP_CANYON_FLY_INTO_THE_WATER = [("", 15), ("left", 30), ("down", 60), ("", 30)]

# Beneath the Waves (day) with POWER 9 (the Swimming Flippers), from the start
# of the level: off the platform and down into the deep water to its right.
BENEATH_THE_WAVES_DIVE = [("right", 150), ("down+right", 30), ("down", 150)]

# Starts underwater right after spawning the owl next to Wario: swim into it,
# keep down while it flies up (it stays underwater), then float up into it.
BENEATH_THE_WAVES_GRAB_UNDERWATER = [
    ("down+right", 20), ("down", 70), ("up", 60), ("", 60), ("", 60),
]
