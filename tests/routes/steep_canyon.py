"""Inputs for The Steep Canyon, mostly its second variant (day), the one N5's
Foot of Stone unlocks, with POWER 9 from the debug menu. Starts the frame the
level becomes playable (see test_steep_canyon.py for the setup). Steps are
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
    ("down+b", 60), ("left+b", 60), ("", 10), ("left+up+a", 35), ("", 15),
    ("up", 90),
    ("down+b", 60), ("right+b", 60), ("right+a", 12), ("", 20),
]

# Ground-pound so the Togeba below leaps up, jump onto it while it floats
# down, and from it onto the ladder up through the ceiling.
TOGEBA_TO_LADDER = [
    ("left", 20), ("a", 20), ("down", 40), ("left+up+a", 35), ("", 15),
    ("left+up+a", 35), ("", 15), ("left+up+a", 35), ("", 15), ("up", 90),
]

# Into the pipe at the top of the shaft, out into the owl room.
TO_OWL_ROOM = [
    ("left+b", 12), ("", 10), ("left+up", 30), ("left+b", 12), ("", 10),
    ("left+up+a", 35), ("", 15), ("right+b", 120), ("left+up+a", 35), ("", 15),
]

# Bump the sleeping owl awake and grab it as it takes off.
GRAB_OWL = [
    ("right+b", 120), ("left+up+a", 35), ("", 15),
]


# The first variant's start room (THE_STEEP_CANYON_DAY_1, no treasures), from
# the frame the level becomes playable, for the debug owl.

# Left, away from the fire bot, before spawning the owl.
START_ROOM_AWAY_FROM_FIRE_BOT = [("left", 40), ("", 20)]

# Dash at the spawned owl to wake it, and jump to grab it as it flies off.
START_ROOM_GRAB_DEBUG_OWL = [("right+b", 120), ("a", 35), ("", 15)]

# Up and then left, into the room's upper left corner. Found with
# tests/tools/route_search.py --keep wTransformation=0x0e. (B during the grab
# doesn't let go, and holding it after isn't a new press.)
START_ROOM_OWL_FLIGHT = [("up+b", 60), ("", 30), ("left", 30), ("", 60)]


# The fourth variant (THE_STEEP_CANYON_DAY_4, which N8's Rust Spray picks),
# with POWER 9, from the frame the level becomes playable.

# Swim right across the water hands' pool (diving under the pillar in the
# middle), climb out at the far end, and dash through the cracked column.
TO_CRACKED_COLUMN = [
    ("right+b", 120), ("right+b", 120), ("right+b", 120), ("right+b", 100),
    ("down", 30), ("right+b", 120), ("right+b", 120), ("right+b", 120),
    ("right+b", 120), ("right+b", 120),
    ("up+b", 60), ("right+b", 60), ("right+b", 12), ("", 10),
    ("right+up+a", 35), ("", 15), ("right+b", 120), ("", 40),
]

# The debug owl, spawned right after the column: bump it awake, back off while
# it takes off, then jump into it from below.
COLUMN_GRAB_DEBUG_OWL = [
    ("right+b", 20), ("", 40), ("right", 18), ("right+a", 35), ("", 15),
]

# Fly right, through the room transition past the column (down into the room
# below), and on.
COLUMN_FLY_TO_NEXT_ROOM = [("", 30), ("right", 150)]
