; The treasure collection's edit mode (this fork). SELECT on the collection
; screen turns it on and off. In it, the chests not opened show their
; treasure in grey instead (BG palette 0, whose blues turn grey: the
; scroll's grid with it, which shows the mode is on), the treasures owned
; stay in their colours, and A gives or takes the selected treasure. The
; D-pad works as usual (A + LEFT/RIGHT doesn't turn pages: moving past the
; page's edge does). Pages turned keep the mode; opening the collection
; from the map starts without it.
;
; The collection's BG is drawn from wTilemap and wAttrmap: a change is made
; there and then copied to VRAM in a V-Blank (CollectionEdit_StartVRAMWrite),
; a cell's two rows of the map at a time.

; cell 0's treasure tiles (4 per cell: top left, bottom left, top right,
; bottom right), and the chest's
DEF COLLECTION_CELL_TILE  EQU $a0
DEF COLLECTION_CHEST_TILE EQU $fc
DEF COLLECTION_CHEST_PAL  EQU 4
DEF COLLECTION_EDIT_PAL   EQU 0 ; the scroll's, grey in the edit mode
; a row of cells' first BG map row, and the map rows between two rows of
; cells (see ApplyPageTreasuresPals.lo_map_addresses)
DEF COLLECTION_CELLS_TOP_Y EQU 5
DEF COLLECTION_CELLS_DY    EQU 3

; BG palette 0 in the edit mode: the scroll's white and black, its blues grey
CollectionEditPal:
	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 11, 11, 11
	rgb  0,  0,  0

; -----------------------------------------------------------------------
; Cell wCollectionCurCell (treasure wCollectionCurTreasure) in wTilemap and
; wAttrmap: the treasure in its colours if owned, else its chest, or in the
; edit mode the treasure in grey.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
CollectionEdit_SetCell:
	ld a, [wCollectionCurTreasure]
	call IsTreasureCollected
	jr nz, .collected
	ld a, [wCollectionEditMode]
	and a
	jr nz, .edit_mode
	lb bc, COLLECTION_CHEST_TILE, COLLECTION_CHEST_PAL
	jr .got_tiles
.edit_mode
	call .TreasureTiles
	ld c, COLLECTION_EDIT_PAL
	jr .got_tiles
.collected
	ld a, [wCollectionCurTreasure]
	ld e, a
	ld d, 0
	ld hl, TreasureOBPals
	add hl, de
	ld c, [hl]
	call .TreasureTiles
.got_tiles
	push bc
	call ApplyPageTreasuresPals.GetAttrmapAddress ; de: top row, hl: bottom
	pop bc
	ld a, b
	ld [de], a ; top left
	inc a
	ld [hli], a ; bottom left
	inc a
	inc e
	ld [de], a ; top right
	inc a
	ld [hld], a ; bottom right
	dec e
	; the attributes, in wAttrmap
	ASSERT LOW(wTilemap - wAttrmap) == 0
	ld a, d
	sub HIGH(wTilemap - wAttrmap)
	ld d, a
	ld a, h
	sub HIGH(wTilemap - wAttrmap)
	ld h, a
	ld a, c
	ld [de], a
	ld [hli], a
	inc e
	ld [de], a
	ld [hl], a
	ret

.TreasureTiles:
	ld a, [wCollectionCurCell]
	add a
	add a
	add COLLECTION_CELL_TILE
	ld b, a
	ret

; -----------------------------------------------------------------------
; All the page's cells in wTilemap and wAttrmap (CollectionEdit_SetCell)
; -----------------------------------------------------------------------
CollectionEdit_SetPage:
	xor a
	ld [wCollectionCurCell], a
	; the page's first treasure: page * NUM_COLLECTION_CELLS + 1
	ASSERT NUM_COLLECTION_CELLS == 20
	ld a, [wCollectionPage]
	add a
	add a
	ld b, a
	add a
	add a
	add b
	inc a
	ld [wCollectionCurTreasure], a
.loop
	call CollectionEdit_SetCell
	ld hl, wCollectionCurCell
	inc [hl]
	ld a, [hli]
	inc [hl] ; wCollectionCurTreasure
	cp NUM_COLLECTION_CELLS
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; BG palette 0 in wTempPals1: the scroll's, or in the edit mode its grey
; -----------------------------------------------------------------------
CollectionEdit_SetPals:
	ld hl, TreasureCollectionBGPals
	ld a, [wCollectionEditMode]
	and a
	jr z, .got_pal
	ld hl, CollectionEditPal
.got_pal
	ld de, wTempPals1
	ld b, 1 palettes
	jp CopyHLToDE

; -----------------------------------------------------------------------
; SELECT: the edit mode on or off. The palette and the four rows of cells
; are redrawn, a V-Blank each.
; -----------------------------------------------------------------------
CollectionEdit_ToggleMode:
	ld a, [wCollectionEditMode]
	xor TRUE
	ld [wCollectionEditMode], a
	play_sfx SFX_MENU_SCROLL
	call CollectionEdit_SetPals
	call CollectionEdit_SetPage
	call CollectionEdit_StartVRAMWrite
	ld a, BGPI_AUTOINC | palette COLLECTION_EDIT_PAL
	ldh [rBGPI], a
	ld hl, wTempPals1 palette COLLECTION_EDIT_PAL
	ld c, LOW(rBGPD)
REPT PAL_SIZE
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	ei
	ld a, COLLECTION_CELLS_TOP_Y
.loop_rows
	push af
	call CollectionEdit_CopyCellRows
	pop af
	add COLLECTION_CELLS_DY
	cp COLLECTION_CELLS_TOP_Y + 4 * COLLECTION_CELLS_DY
	jr nz, .loop_rows
	ret

; -----------------------------------------------------------------------
; A in the edit mode: give or take the selected treasure, and redraw its
; cell and the count
; -----------------------------------------------------------------------
CollectionEdit_ToggleTreasure:
	ld a, [wCollectionCell]
	ld [wCollectionCurCell], a
	ld b, a
	ASSERT NUM_COLLECTION_CELLS == 20
	ld a, [wCollectionPage]
	add a
	add a
	ld c, a
	add a
	add a
	add c
	inc a
	add b
	ld [wCollectionCurTreasure], a
	call IsTreasureCollected
	; hl = its byte in wTreasuresCollected, d = its bit
	ld a, [hl]
	xor d
	ld [hl], a
	play_sfx SFX_MENU_SCROLL
	farcall UpdateNumCollectedTreasures
	call CollectionEdit_SetCell
	; the cell's rows: COLLECTION_CELLS_TOP_Y + its row * COLLECTION_CELLS_DY
	ld a, [wCollectionCurCell]
	ld b, COLLECTION_CELLS_TOP_Y - COLLECTION_CELLS_DY
.loop_row
	ld c, a
	ld a, b
	add COLLECTION_CELLS_DY
	ld b, a
	ld a, c
	sub NUM_COLLECTION_COLS
	jr nc, .loop_row
	ld a, b
	call CollectionEdit_CopyCellRows
	; the count, at the top
	call CollectionEdit_StartVRAMWrite
	hlbgcoord 2, 1, v0BGMap1
	farcall PrintNumCollectedTreasures
	ei
	ret

; -----------------------------------------------------------------------
; Copy BG map rows a and a + 1 (tiles and attributes) from wTilemap and
; wAttrmap to VRAM, in a V-Blank: 2 x 64 bytes, about 1300 M-cycles of the
; V-Blank's 2280 (double speed)
; -----------------------------------------------------------------------
CollectionEdit_CopyCellRows:
	; bc = a * TILEMAP_WIDTH
	ld l, a
	ld h, 0
	REPT 5
		add hl, hl
	ENDR
	ASSERT TILEMAP_WIDTH == 1 << 5
	ld b, h
	ld c, l
	call CollectionEdit_StartVRAMWrite
	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, wTilemap
	call .Copy
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, wAttrmap
	call .Copy
	xor a
	ldh [rVBK], a
	ei
	ret

.Copy:
	push bc
	add hl, bc
	push hl
	ld hl, v0BGMap1
	add hl, bc
	ld d, h
	ld e, l
	pop hl
	ld b, 2 * TILEMAP_WIDTH
.loop
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	pop bc
	ret

; -----------------------------------------------------------------------
; Wait for the start of the next V-Blank, with interrupts off, to write
; VRAM with the LCD on: ei when done, in the same V-Blank (the V-Blank
; interrupt, pending, then runs in it too)
; Clobbers: A
; -----------------------------------------------------------------------
CollectionEdit_StartVRAMWrite:
	di
.wait_not_vblank
	ldh a, [rLY]
	cp LY_VBLANK
	jr nc, .wait_not_vblank
.wait_vblank
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .wait_vblank
	ret
