"""The treasure collection's edit mode (src/engine/overworld/collection_edit.asm):
SELECT turns it on and off, A gives or takes the selected treasure."""

from game import ST_OVERWORLD

SST_OVERWORLD_COLLECTION = 0x0C  # its fade and init (src/constants/state_constants.asm)
SST_OVERWORLD_COLLECTION_UPDATE = 0x0F  # _TreasureCollection, taking input

# the first page's first two treasures (cells 0 and 1)
YELLOW_MUSIC_BOX = 1
BLUE_MUSIC_BOX = 2

COLLECTION_CELL_TILE = 0xA0  # cell 0's treasure tiles, 4 per cell
COLLECTION_CHEST_TILE = 0xFC
CELL_1_TOP_LEFT = 0x9C00 + 5 * 32 + 6  # v0BGMap1, ApplyPageTreasuresPals


def open_collection(game):
    """From the map, the way the top bar's collection button goes."""
    game.new_game_to_overworld()
    game.tick(30)
    game.write("wSubState", SST_OVERWORLD_COLLECTION)
    game.wait_until(
        lambda: game.state == (ST_OVERWORLD, SST_OVERWORLD_COLLECTION_UPDATE),
        what="the collection",
    )
    game.tick(60)


def cell_1(game):
    """Cell 1's top left tile and palette, in VRAM."""
    mem = game.pb.memory
    return mem[0, CELL_1_TOP_LEFT], mem[1, CELL_1_TOP_LEFT] & 7


def test_collection_edit_mode(game, golden):
    open_collection(game)
    assert game.read("wCollectionEditMode") == 0
    game.press("right", wait=10)
    assert game.read("wCollectionCell") == 1
    assert cell_1(game) == (COLLECTION_CHEST_TILE, 4)  # a closed chest

    # SELECT: the treasures not owned show, in grey (palette 0)
    game.press("select", wait=30)
    assert game.read("wCollectionEditMode") == 1
    assert cell_1(game) == (COLLECTION_CELL_TILE + 4, 0)
    golden("collection_edit_mode", game.screenshot())

    # A gives the selected treasure: in its colours, counted
    game.press("a", wait=30)
    assert game.treasure_collected(BLUE_MUSIC_BOX)
    assert not game.treasure_collected(YELLOW_MUSIC_BOX)
    assert game.num_collected_treasures() == 1
    assert cell_1(game)[1] != 0
    golden("collection_edit_given", game.screenshot())

    # A again takes it back
    game.press("a", wait=30)
    assert not game.treasure_collected(BLUE_MUSIC_BOX)
    assert game.num_collected_treasures() == 0
    assert cell_1(game) == (COLLECTION_CELL_TILE + 4, 0)
    game.press("a", wait=30)

    # a page turned keeps the mode: past the last column, and back
    for _ in range(4):  # columns 2 to 4, then the next page
        game.press("right", wait=10)
    game.wait_until(lambda: game.read("wCollectionPage") == 1, what="page 2")
    game.wait_until(
        lambda: game.state == (ST_OVERWORLD, SST_OVERWORLD_COLLECTION_UPDATE), what="page 2's init"
    )
    game.tick(60)
    assert game.read("wCollectionEditMode") == 1
    game.press("left", wait=10)
    game.wait_until(
        lambda: game.read("wCollectionPage") == 0
        and game.state == (ST_OVERWORLD, SST_OVERWORLD_COLLECTION_UPDATE),
        what="page 1 again",
    )
    game.tick(60)
    assert game.read("wCollectionEditMode") == 1
    assert cell_1(game)[1] != 0  # still owned

    # SELECT again: the normal screen, the owned treasure in its colours and
    # the others as chests; A doesn't give anything there
    game.press("select", wait=30)
    assert game.read("wCollectionEditMode") == 0
    assert cell_1(game)[0] == COLLECTION_CELL_TILE + 4
    game.press("left", wait=10)
    game.press("a", wait=30)
    assert not game.treasure_collected(YELLOW_MUSIC_BOX)
    golden("collection_normal_after_edit", game.screenshot())
