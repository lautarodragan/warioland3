# Treasure graph: what to check in the game

The treasures of the [treasure graph](treasure-graph.html) whose needs are
uncertain, rest on the heuristic alone, or where sources disagree. Each row
says what each source says and what to try in the game. Record the answer in
tools/treasure_requirements.json (as the "about" lines at its top say:
"verified in game by Taro", with a note) and run
python3 tools/treasure_graph.py, which rewrites the graph and this list.

Where the graph's edges come from: game data (level open): 140, guide: 63, game data: 19, verified in game by Taro: 3.

| Treasure | Level, chest | Now needs | Why it's here | What the sources say | Check in the game |
|---|---|---|---|---|---|
| Blue Gem (#51) | W2 The Volcano's Base, red | Truck Wheel (guide), Flute (game data) | sources missing or not conclusive | [Super Mario Wiki: The Volcano's Base](https://www.mariowiki.com/The_Volcano%27s_Base): the carts run once the Truck Wheel is fitted; the ride ends at a platform with a door and a snake pot<br>game data: the cart checks TRUCK_WHEEL itself (CartVariableFunc); the Flute switches The Volcano's Base to variant 3, new room headers | Can the red chest of W2 (Blue Gem) be reached without the Truck Wheel? Can the red chest of W2 (Blue Gem) be reached without the Flute? With the Truck Wheel but before the Flute (and before the Foot of Stone): does the cart reach the red key and chest? |
| Crown (#54) | W2 The Volcano's Base, green | Truck Wheel (guide), Flute (game data) | sources missing or not conclusive | [Super Mario Wiki: The Volcano's Base](https://www.mariowiki.com/The_Volcano%27s_Base): the Crown's key and chest are in the upper part of the mountain, reached with the carts<br>game data: as for the Blue Gem | Can the green chest of W2 (Crown) be reached without the Truck Wheel? Can the green chest of W2 (Crown) be reached without the Flute? With the Truck Wheel but before the Flute (and before the Foot of Stone): does the cart reach the green key and chest? |
| Warp Removal Apparatus (#68) | E7 Forest of Fear, green | Mystery Handle (game data) | sources missing or not conclusive | game data: the Mystery Handle raises a pipe and switches Forest of Fear to variant 3; the green chest is hinted right after it<br>[Super Mario Wiki: Forest of Fear](https://www.mariowiki.com/Forest_of_Fear): the raised pipe is next to the grey chest | Can the green chest of E7 (Warp Removal Apparatus) be reached without the Mystery Handle? Before the Mystery Handle: is there any way to the green key and chest? |
