"""The block-graph path finder (tools/pathfind.py), on level data alone."""

from tools.pathfind import Graph


def transitions(graph, start, goal):
    path, moves = graph.astar(start, goal)
    assert path is not None, f"no path from {start} to {goal}"
    return [(move, node) for node, move in zip(path[1:], moves) if move in ("door", "walk-in", "up pipe", "down pipe")]


def test_out_of_the_woods_key_and_chest():
    # The route the playthrough test takes, found from the level data: the
    # walk-in door near the start leads to the key's section; the walk-in
    # below the key, then the door at the top of the level, lead to the
    # chest room.
    graph = Graph("OUT_OF_THE_WOODS_DAY_1")
    start, key, chest = (46, 3), (10, 152), (20, 13)
    assert transitions(graph, start, key) == [("walk-in", (29, 114))]
    assert transitions(graph, key, chest) == [("walk-in", (14, 50)), ("door", (30, 3))]


def test_spawn_markers_match_observed_arrivals():
    # Where Wario appeared after transitions in the emulator.
    graph = Graph("OUT_OF_THE_WOODS_DAY_1")
    assert graph.sector_spawn(7, 1) == (29, 114)
    assert graph.sector_spawn(3, 2) == (43, 50)
    assert graph.sector_spawn(0, 1) == (30, 3)
