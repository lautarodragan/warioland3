"""The block-graph path finder (tools/pathfind.py), on level data alone."""

from tools.pathfind import Graph, level_variant


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


def test_steep_canyon_foot_of_stone_variant():
    # With N5's Foot of Stone, The Steep Canyon loads its second variant,
    # whose secret door in the start room leads to a long water corridor;
    # swimming right through it reaches a pipe up into a vertical shaft.
    graph = Graph("THE_STEEP_CANYON_DAY_2", power=9)
    start, corridor, shaft = (26, 21), (36, 18), (45, 5)
    assert transitions(graph, start, corridor) == [("door", corridor)]
    assert transitions(graph, corridor, shaft) == [("up pipe", shaft)]
    # The distance field reaches across the one-block underwater tunnel
    # (swimming nodes are one block tall).
    assert graph.distance_field(shaft).get(corridor) is not None

    # Without the Swimming Flippers there's no getting through the water.
    assert Graph("THE_STEEP_CANYON_DAY_2", power=1).astar(corridor, shaft)[0] is None


def test_treasures_pick_the_level_variant():
    # As SelectLevel does, from LevelTreasureRequirements.
    assert level_variant("THE_STEEP_CANYON") == "THE_STEEP_CANYON_DAY_1"
    assert level_variant("THE_STEEP_CANYON", ["FOOT_OF_STONE"]) == "THE_STEEP_CANYON_DAY_2"
    assert level_variant("THE_STEEP_CANYON", ["FOOT_OF_STONE", "RUST_SPRAY"]) == "THE_STEEP_CANYON_DAY_4"
    # Out of the Woods' third variant needs two treasures.
    assert level_variant("OUT_OF_THE_WOODS", ["POUCH"]) == "OUT_OF_THE_WOODS_DAY_1"
    assert level_variant("OUT_OF_THE_WOODS", ["POUCH", "EYE_OF_THE_STORM"], night=True) == "OUT_OF_THE_WOODS_NIGHT_3"


def test_steep_canyon_needs_the_foot_of_stone():
    # Without the treasure, the start room is closed: the corridor is
    # reached only through the second variant's secret door.
    start, corridor = (26, 21), (36, 18)
    assert Graph("THE_STEEP_CANYON", power=9).astar(start, corridor)[0] is None
    with_foot = Graph("THE_STEEP_CANYON", power=9, treasures=["FOOT_OF_STONE"])
    assert with_foot.astar(start, corridor)[0] is not None


def test_steep_canyon_owl_room():
    # From the start to the owl: the secret door, the water corridor, the
    # pipe up into the shaft, a Togeba to ride up to the ladder (after a
    # ground pound), and the pipe at the top into the owl room.
    start, owl = (26, 21), (46, 120)
    graph = Graph("THE_STEEP_CANYON", power=9, treasures=["FOOT_OF_STONE"])
    assert [move for move, _ in transitions(graph, start, owl)] == ["door", "up pipe", "up pipe"]
    # The Togeba only jumps for a ground pound, which needs the Super Jump
    # Slam Overalls (and the ladder's too high without the High Jump Boots).
    weaker = Graph("THE_STEEP_CANYON", power=5, treasures=["FOOT_OF_STONE"])
    assert weaker.astar(start, owl)[0] is None
