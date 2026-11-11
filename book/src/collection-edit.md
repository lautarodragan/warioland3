# The treasure collection's edit mode

On the treasure collection screen (the map's top bar), SELECT turns an edit
mode on and off. In it:

- the chests not opened show their treasure instead, in grey;
- the treasures Wario has stay in their colours;
- A gives or takes the selected treasure (the count at the top follows);
- the D-pad works as usual, and moving past a page's edge turns the page,
  which keeps the mode. A + LEFT/RIGHT doesn't turn pages here, since A is
  taken.

SELECT again goes back to the normal screen. Opening the collection from the
map always starts without the edit mode. As with the debug menu's TREASURE
page, treasures that open new paths take effect the next time Wario enters a
level from the map.

## How it works

The code is in `src/engine/overworld/collection_edit.asm`, in the collection's
own bank, with a few hooks in `src/engine/overworld/bank26.asm`:
`HandleTreasureCollectionInput` (SELECT, and A in the mode) and
`_InitTreasureCollection` (the mode across page turns, cleared when the
collection opens). The flag is `wCollectionEditMode`, in WRAM0: the
collection's own RAM is cleared each time a page is drawn.

The screen's BG is built in `wTilemap` and `wAttrmap` and copied to BG map 1
when a page is drawn. `ApplyPageTreasuresPals` gives each cell its treasure's
palette if Wario has it, or the chest's tiles (`$fc`-`$ff`) and palette 4.
`CollectionEdit_SetCell` does the same for one cell, and in the edit mode
keeps the treasure's tiles (`$a0` + 4 × the cell) in BG palette 0 instead.

All 8 BG palettes are taken, so the grey is palette 0, the scroll's: in the
edit mode its two blues turn grey (`CollectionEditPal`), and the scroll's grid
with them, which also shows that the mode is on.

A change on screen is made in `wTilemap` and `wAttrmap`, then copied to VRAM
in a V-Blank (`CollectionEdit_StartVRAMWrite`, which waits for one with
interrupts off), the two map rows of a row of cells at a time
(`CollectionEdit_CopyCellRows`, 128 bytes, about 1300 M-cycles of the
V-Blank's 2280 in double speed). Turning the mode on or off redraws the
palette and the four rows of cells, a V-Blank each; A redraws the cell's row
and the count.

`tests/test_treasure_collection.py` checks the mode, giving and taking a
treasure, a page turn in the mode, and the normal screen after it.
