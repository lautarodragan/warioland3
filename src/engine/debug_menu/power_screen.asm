; The debug menu's POWER page (START from MAIN). The ten power-up levels
; (NONE and the nine power-ups, see wario_constants.asm), each with its
; treasure's graphics and palette, the ones owned in colour and the others
; in grey. The D-pad moves the selection, A sets wPowerUpLevel to it, START
; goes on to the TREASURE page, B or SELECT closes the menu.
;
; The icons are sprites (two 8x16 each), with the treasures' own OB palettes
; (TreasurePals, picked with TreasureOBPals like the collection screen does),
; their tiles copied from TreasureGfx into VRAM0 $8000-$827f when the menu
; opens. That part of the font is never shown by the BG (which uses the
; $8800-$97ff tiles). All 8 BG palettes are the menu's: palette 7 is the
; icon cells'. The TREASURE page uses the same cells, palettes and dim grey.

; treasure shown for each power-up level
DebugPowerTreasures:
	table_width 1
	db TREASURE_NONE              ; NO_POWER_UP (the game's closed chest)
	db LEAD_OVERALLS_T            ; LEAD_OVERALLS
	db SWIMMING_FLIPPERS_T        ; SWIMMING_FLIPPERS
	db HEAD_SMASH_HELMET_T        ; HEAD_SMASH_HELMET
	db GRAB_GLOVE_T               ; GRAB_GLOVE
	db GARLIC_T                   ; GARLIC
	db SUPER_JUMP_SLAM_OVERALLS_T ; SUPER_JUMP_SLAM_OVERALLS
	db HIGH_JUMP_BOOTS_T          ; HIGH_JUMP_BOOTS
	db PRINCE_FROGS_GLOVES_T      ; PRINCE_FROGS_GLOVES
	db SUPER_GRAB_GLOVES_T        ; SUPER_GRAB_GLOVES
	assert_table_length NUM_DEBUG_POWERS

; each level's cell: its BG map address, and its sprites' OAM Y and X
DebugPowerCells:
FOR I, NUM_DEBUG_POWERS
	DEF _X = DEBUG_POWER_ICON_X + (I / DEBUG_POWER_ROWS) * DEBUG_POWER_COL_WIDTH
	DEF _Y = DEBUG_POWER_TOP_Y + (I % DEBUG_POWER_ROWS) * 2
	dwcoord _X, _Y
	db _Y * TILE_HEIGHT + OAM_Y_OFS, _X * TILE_WIDTH + OAM_X_OFS
ENDR
	PURGE _X, _Y

; The icon cells' corner, in palette 7: white, a dark red margin (the
; background's colour, so neighbouring cells stay apart), and for the
; selected cell a yellow frame. The map flips it for the other corners.
DebugPowerCellTiles:
	dw `33333333
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000

	dw `33333333
	dw `31111111
	dw `31111111
	dw `31100000
	dw `31100000
	dw `31100000
	dw `31100000
	dw `31100000

; OB palette DEBUG_POWER_PAL_DIM: a light grey version of the treasures, for
; the power-ups not owned (colour 0 is transparent)
DebugPowerDimPal:
	rgb 31, 31, 31
	rgb 25, 25, 25
	rgb 18, 18, 18
	rgb 11, 11, 11

; output: a = wPowerUpLevel, without the Action Help flags
DebugMenu_GetPowerLevel:
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	ret

; Sets the power-up level to a (0-9): Wario has every power-up up to it.
; The game reads wPowerUpLevel whenever it needs a power-up, so that's all.
DebugMenu_SetPowerLevel:
	ld [wPowerUpLevel], a
	ret

; -----------------------------------------------------------------------
; The ten power-ups' treasure tiles, 4 per level from tile 0 (VRAM0 $8000),
; loaded with the menu's other tiles when it opens. The LCD must be off.
; -----------------------------------------------------------------------
DebugMenu_LoadPowerTiles:
	ld de, v0Tiles0
	ld c, 0
.loop
	push bc
	ld b, 0
	ld hl, DebugPowerTreasures
	add hl, bc
	ld a, [hl]
	call DebugMenu_CopyTreasureTiles
	pop bc
	inc c
	ld a, c
	cp NUM_DEBUG_POWERS
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; Copy treasure a's tiles (TreasureGfx, in its bank) to de, which ends up
; past them. With the LCD on, at the start of a V-Blank.
; Clobbers: A, B, H, L
; -----------------------------------------------------------------------
DebugMenu_CopyTreasureTiles:
	ld l, a
	ld h, 0
	REPT 6 ; * NUM_TREASURE_TILES tiles
		add hl, hl
	ENDR
	ASSERT NUM_TREASURE_TILES tiles == 1 << 6
	ld a, LOW(TreasureGfx)
	add l
	ld l, a
	ld a, HIGH(TreasureGfx)
	adc h
	ld h, a
	call DebugMenu_StartVRAMWrite
	ld b, NUM_TREASURE_TILES tiles
	ld a, BANK(TreasureGfx)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE
	ei
	ret

; -----------------------------------------------------------------------
; The OB palettes of the POWER and TREASURE pages, into wTempPals2 and the
; hardware: the dim grey, and the treasures' (OBPAL_TREASURE_*). Loaded
; with each of these pages: FORM changes Wario's, in the same palettes.
; -----------------------------------------------------------------------
DebugMenu_LoadTreasurePals:
	ld hl, DebugPowerDimPal
	ld de, wTempPals2 palette DEBUG_POWER_PAL_DIM
	ld b, 1 palettes
	call CopyHLToDE
	ld hl, TreasurePals
	ld de, wTempPals2 palette OBPAL_TREASURE_YELLOW
	ld b, 4 palettes
	ld a, BANK(TreasurePals)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE
	jp ApplyTempPals2ToOBPals

; -----------------------------------------------------------------------
; Load the POWER page (DebugMenu_ShowPage, the LCD off)
; -----------------------------------------------------------------------
DebugMenu_LoadPowerPage:
	call DebugMenu_LoadTreasurePals
	ld hl, DebugPowerTilemap
	ld de, DebugPowerAttrmap
	call DebugMenu_LoadMap
	ld a, [wDebugPowerCursor]
	ld c, DEBUG_POWER_CELL_SELECTED
	call DebugMenu_DrawPowerCell
	jp DebugMenu_BuildPowerOAM

; -----------------------------------------------------------------------
; The icons' sprites, two per level: the treasure's palette for the levels
; owned (up to wPowerUpLevel), the dim one for the others.
; -----------------------------------------------------------------------
DebugMenu_BuildPowerOAM:
	ld de, wVirtualOAM
	ld hl, DebugPowerCells
	ld c, 0
.loop
	inc hl
	inc hl ; skip the BG map address
	ld a, [hli] ; y
	ld [de], a
	inc e
	ld a, [hli] ; x
	ld [de], a
	inc e
	ld a, c ; tile: 4 per level, the left column first
	add a
	add a
	ld [de], a
	inc e
	push hl
	push bc
	call DebugMenu_GetPowerLevel
	cp c
	ld a, DEBUG_POWER_PAL_DIM
	jr c, .got_pal ; level < c: not owned
	; a = TreasureOBPals[treasure], from its bank
	ld b, 0
	ld hl, DebugPowerTreasures
	add hl, bc
	ld c, [hl]
	ld hl, TreasureOBPals
	add hl, bc
	ld b, 1
	ld a, BANK(TreasureOBPals)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE ; straight into the attributes
	dec e
	ld a, [de]
.got_pal
	ld [de], a
	inc e
	pop bc
	pop hl
	; the right half: 8 pixels right, 2 tiles on, same attributes
	ld b, a
	dec hl
	dec hl
	ld a, [hli] ; y
	ld [de], a
	inc e
	ld a, [hli] ; x
	add TILE_WIDTH
	ld [de], a
	inc e
	ld a, c
	add a
	add a
	add 2
	ld [de], a
	inc e
	ld a, b
	ld [de], a
	inc e
	inc c
	ld a, c
	cp NUM_DEBUG_POWERS
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; Draw level a's cell with tile c (DEBUG_POWER_CELL or _SELECTED), and its
; name in yellow (selected) or white. The LCD must be off or in V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawPowerCell:
	add a
	add a ; 4 bytes per cell
	ld e, a
	ld d, 0
	ld hl, DebugPowerCells
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
;	fallthrough

; -----------------------------------------------------------------------
; Draw an icon cell at hl (its top left corner in the BG map) with tile c
; (DEBUG_POWER_CELL or _SELECTED), and the two lines of text to its right in
; yellow (selected) or white. The LCD must be off or in V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawCell:
	ld a, c
	ld [hli], a
	ld [hl], a
	ld de, TILEMAP_WIDTH
	add hl, de
	ld [hld], a
	ld [hl], a
	; the text's palette, on the two rows right of the cell
	cp DEBUG_POWER_CELL_SELECTED
	ld b, 6 ; cursor and values, yellow
	jr z, .got_pal
	ld b, 5 ; labels, white
.got_pal
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld de, -TILEMAP_WIDTH + 2
	add hl, de
	call .Line
	ld de, TILEMAP_WIDTH - DEBUG_POWER_NAME_WIDTH
	add hl, de
	call .Line
	xor a ; VRAM0
	ldh [rVBK], a
	ret

.Line:
	ld a, b
	ld c, DEBUG_POWER_NAME_WIDTH
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; SST_DEBUG_POWER_PAGE: the POWER page's input
; -----------------------------------------------------------------------
UpdateDebugPowerPage:
	ld a, [wJoypadPressed]
	ld b, a
	and PAD_B | PAD_SELECT
	jp nz, DebugMenu_Exit
	bit B_PAD_START, b
	jp nz, DebugMenu_NextPage
	bit B_PAD_A, b
	jr nz, .apply

	; the D-pad: UP/DOWN within a column, LEFT/RIGHT between the columns
	ld a, [wDebugPowerCursor]
	ld c, a ; the selection as it was
	bit B_PAD_UP, b
	jr z, .not_up
	; not on a column's first row
	cp DEBUG_POWER_ROWS
	jr z, .not_up
	and a
	jr z, .not_up
	dec a
.not_up
	bit B_PAD_DOWN, b
	jr z, .not_down
	cp DEBUG_POWER_ROWS - 1
	jr z, .not_down
	cp NUM_DEBUG_POWERS - 1
	jr z, .not_down
	inc a
.not_down
	bit B_PAD_LEFT, b
	jr z, .not_left
	cp DEBUG_POWER_ROWS
	jr c, .not_left
	sub DEBUG_POWER_ROWS
.not_left
	bit B_PAD_RIGHT, b
	jr z, .not_right
	cp DEBUG_POWER_ROWS
	jr nc, .not_right
	add DEBUG_POWER_ROWS
.not_right
	cp c
	ret z
	ld [wDebugPowerCursor], a

	; redraw the two cells during V-Blank (LCD on)
	push af
	call DebugMenu_StartVRAMWrite
	ld a, c
	ld c, DEBUG_POWER_CELL
	call DebugMenu_DrawPowerCell
	pop af
	ld c, DEBUG_POWER_CELL_SELECTED
	call DebugMenu_DrawPowerCell
	ei
	ret

.apply
	ld a, [wDebugPowerCursor]
	call DebugMenu_SetPowerLevel
	; the sprites are copied to OAM at the next V-Blank
	jp DebugMenu_BuildPowerOAM

DebugPowerTilemap: INCBIN "data/bgmaps/debug_power.tilemap.rle"
DebugPowerAttrmap: INCBIN "data/bgmaps/debug_power.attrmap.rle"
