# Treasure graph: what to check in the game

The treasures of the [treasure graph](treasure-graph.html) whose needs are
uncertain, rest on the heuristic alone, or where sources disagree. Each row
says what each source says and what to try in the game. Record the answer in
tools/treasure_requirements.json (as the "about" lines at its top say:
"verified in game by Taro", with a note) and run
python3 tools/treasure_graph.py, which rewrites the graph and this list.

Where the graph's edges come from: game data (level open): 140, guide: 61, game data: 17, verified in game by Taro: 6.

| Treasure | Level, chest | Now needs | Why it's here | What the sources say | Check in the game |
|---|---|---|---|---|---|
| Warp Removal Apparatus (#68) | E7 Forest of Fear, green | Mystery Handle (game data) | sources missing or not conclusive | game data: the Mystery Handle raises a pipe and switches Forest of Fear to variant 3; the green chest is hinted right after it<br>[Super Mario Wiki: Forest of Fear](https://www.mariowiki.com/Forest_of_Fear): the raised pipe is next to the grey chest | Can the green chest of E7 (Warp Removal Apparatus) be reached without the Mystery Handle? Before the Mystery Handle: is there any way to the green key and chest? |
