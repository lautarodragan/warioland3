; The debug menu's TREASURE page (SELECT from POWER). A level's code and
; name, and its four treasures in a 2x2 grid (grey red / green blue), each
; its icon with its chest, open if Wario has it. The icons are sprites like
; the POWER page's, with the same palettes: in the treasure's colours if
; owned, in grey if not. The chests are the pause menu's sprites.
;
; LEFT/RIGHT change the level (wrapping), UP/DOWN pick a treasure in
; reading order (no wrapping), A gives
; or takes it, SELECT goes back to LEVEL, B or START closes the menu.
; wDebugMenuTreasureIdx is the pick, level * 4 + colour (the
; LevelTreasureIDs layout); the page starts on the current level.

SETCHARMAP temple

; Each line of a level's name: the column it starts at, from the inside of
; the frame's left edge (centred), its length and its characters.
MACRO debug_level_name_line
	ASSERT CHARLEN(\1) <= DEBUG_MENU_INSIDE_WIDTH, \1
	db (DEBUG_MENU_INSIDE_WIDTH - CHARLEN(\1)) / 2, CHARLEN(\1)
	IF CHARLEN(\1)
		db \1
	ENDC
ENDM

; A level's name on two lines (the second one can be "")
MACRO debug_level_name
	debug_level_name_line \1
	debug_level_name_line \2
ENDM

; in level order, like DebugLevelCodes
DebugLevelNames:
	debug_level_name "OUT OF THE WOODS", ""
	debug_level_name "THE PEACEFUL", "VILLAGE"
	debug_level_name "THE VAST PLAIN", ""
	debug_level_name "BANK OF THE", "WILD RIVER"
	debug_level_name "THE TIDAL COAST", ""
	debug_level_name "SEA TURTLE ROCKS", ""
	debug_level_name "DESERT RUINS", ""
	debug_level_name "THE VOLCANO'S", "BASE"
	debug_level_name "THE POOL OF RAIN", ""
	debug_level_name "A TOWN IN CHAOS", ""
	debug_level_name "BENEATH THE", "WAVES"
	debug_level_name "THE WEST CRATER", ""
	debug_level_name "THE GRASSLANDS", ""
	debug_level_name "THE BIG BRIDGE", ""
	debug_level_name "TOWER OF REVIVAL", ""
	debug_level_name "THE STEEP CANYON", ""
	debug_level_name "CAVE OF FLAMES", ""
	debug_level_name "ABOVE THE CLOUDS", ""
	debug_level_name "THE STAGNANT", "SWAMP"
	debug_level_name "THE FRIGID SEA", ""
	debug_level_name "CASTLE OF", "ILLUSIONS"
	debug_level_name "THE COLOSSAL", "HOLE"
	debug_level_name "THE WARPED VOID", ""
	debug_level_name "THE EAST CRATER", ""
	debug_level_name "FOREST OF FEAR", ""

SETCHARMAP main

; -----------------------------------------------------------------------
; input: a = level * 4 + colour; output: a = that treasure's ID
; Clobbers: H, L
; -----------------------------------------------------------------------
DebugMenu_TreasureIDAt:
	add LOW(LevelTreasureIDs_WithoutTemple)
	ld l, a
	adc HIGH(LevelTreasureIDs_WithoutTemple)
	sub l
	ld h, a
	ld a, [hl]
	ret

; output: a = the picked treasure's ID
; Clobbers: H, L
DebugMenu_GetTreasureID:
	ld a, [wDebugMenuTreasureIdx]
	jr DebugMenu_TreasureIDAt

; output: a = the picked level's treasure c's ID
; Clobbers: H, L
DebugMenu_GetLevelTreasureID:
	ld a, [wDebugMenuTreasureIdx]
	and %11111100
	or c
	jr DebugMenu_TreasureIDAt

; -----------------------------------------------------------------------
; input: a = treasure ID; output: carry set if collected
; Clobbers: A, B, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_IsCollected:
	ld b, a
	push_wram BANK(wTreasuresCollected)
	ld a, b
	call IsTreasureCollected
	ld b, a ; TRUE if collected
	pop_wram
	ld a, b
	and a ; clears carry
	ret z
	scf
	ret

; -----------------------------------------------------------------------
; A: give or take the picked treasure. Level variants that need it change
; the next time a level is entered from the map.
; Clobbers: A, B, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_ToggleTreasure:
	call DebugMenu_GetTreasureID
	ld b, a
	push_wram BANK(wTreasuresCollected)
	ld a, b
	call IsTreasureCollected
	; hl = byte in wTreasuresCollected, d = the treasure's bit
	ld a, [hl]
	xor d
	ld [hl], a
	pop_wram
	farcall UpdateNumCollectedTreasures
	ret

; -----------------------------------------------------------------------
; Load the TREASURE page, its map already in BG map 0 (DebugMenu_LoadPage):
; the code and name in a V-Blank, the selected cell in the next one, the
; icons' tiles in four more
; -----------------------------------------------------------------------
DebugMenu_LoadTreasurePage:
	call DebugMenu_LoadTreasurePals
	call DebugMenu_GetLevelName
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawLevel
	call DebugMenu_EndVRAMWrite
	call DebugMenu_StartVRAMWrite
	ld a, [wDebugMenuTreasureIdx]
	and %11
	ld c, DEBUG_POWER_CELL_SELECTED
	call DebugMenu_DrawTreasureCell
	call DebugMenu_EndVRAMWrite
	call DebugMenu_LoadTreasureTiles
	jp DebugMenu_BuildTreasureOAM

; -----------------------------------------------------------------------
; output: de = the picked level's name in DebugLevelNames
; Clobbers: A, C
; -----------------------------------------------------------------------
DebugMenu_GetLevelName:
	ld a, [wDebugMenuTreasureIdx]
	srl a
	srl a
	ld c, a ; level
	inc c
	ld de, DebugLevelNames
.next
	dec c
	ret z
	call .SkipLine
	call .SkipLine
	jr .next

.SkipLine:
	inc de
	ld a, [de] ; length
	inc de
	add e
	ld e, a
	ret nc
	inc d
	ret

; -----------------------------------------------------------------------
; Draw the picked level's code (its letter's and digit's tiles, by GDMA)
; and its name (de, from DebugMenu_GetLevelName). The LCD must be off or in
; V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawLevel:
	push de
	ld a, [wDebugMenuTreasureIdx]
	srl a
	srl a ; level
	add a ; 2 bytes per code
	ld e, a
	ld d, 0
	ld hl, DebugLevelCodes
	add hl, de
	ld a, [hli]
	push hl
	ld de, v0Tiles2 tile DEBUG_TREASURE_CODE_TILES
	call .CopyHalves
	pop hl
	ld a, [hl]
	ld de, v0Tiles2 tile (DEBUG_TREASURE_CODE_TILES + 2)
	call .CopyHalves
	pop de
	hlbgcoord DEBUG_MENU_INSIDE_X, DEBUG_TREASURE_NAME_Y
	call .Line
	hlbgcoord DEBUG_MENU_INSIDE_X, DEBUG_TREASURE_NAME_Y + 1
	ASSERT LOW((DEBUG_TREASURE_NAME_Y + 1) * TILEMAP_WIDTH + DEBUG_MENU_INSIDE_X) + DEBUG_MENU_INSIDE_WIDTH < $100
.Line:
	; clear the line, then the name from its column on
	push hl
	ld a, DEBUG_MENU_BLANK
	ld b, DEBUG_MENU_INSIDE_WIDTH
.clear
	ld [hli], a
	dec b
	jr nz, .clear
	pop hl
	ld a, [de] ; column
	inc de
	add l
	ld l, a
	ld a, [de] ; length
	inc de
	and a
	ret z
	ld b, a
	jp DebugMenu_DrawString

; tile a of DebugMenuCodeGfx and the next one (a top and a bottom half) to de
.CopyHalves:
	ld l, a
	ld h, 0
	REPT 4 ; tiles
		add hl, hl
	ENDR
	ld bc, DebugMenuCodeGfx
	add hl, bc
	ld c, 2
	jp DebugMenu_GDMA

; -----------------------------------------------------------------------
; Draw treasure a's cell (the picked level's, in the grid) with tile c
; (DEBUG_POWER_CELL or _SELECTED). The LCD must be off or in V-Blank.
; Clobbers: A, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawTreasureCell:
	ld hl, DEBUG_TREASURE_GRID_Y * TILEMAP_WIDTH + DEBUG_TREASURE_GRID_X + v0BGMap0
	ld de, DEBUG_TREASURE_GRID_DX
	bit 0, a
	jr z, .left
	add hl, de
.left
	ld de, DEBUG_TREASURE_GRID_DY * TILEMAP_WIDTH
	bit 1, a
	jr z, .top
	add hl, de
.top
	ld a, c
	ld [hli], a
	ld [hl], a
	ld de, TILEMAP_WIDTH
	add hl, de
	ld [hld], a
	ld [hl], a
	ret

; Each treasure's icon position in the grid (OAM y, x), in reading order
DebugTreasureGridPos:
	FOR I, 4
		db (DEBUG_TREASURE_GRID_Y + I / 2 * DEBUG_TREASURE_GRID_DY) * TILE_HEIGHT + OAM_Y_OFS
		db (DEBUG_TREASURE_GRID_X + I % 2 * DEBUG_TREASURE_GRID_DX) * TILE_WIDTH + OAM_X_OFS
	ENDR

; output: hl = treasure c's position in DebugTreasureGridPos
; Clobbers: A
DebugMenu_GetTreasureGridPos:
	ld a, c
	add a
	add LOW(DebugTreasureGridPos)
	ld l, a
	adc HIGH(DebugTreasureGridPos)
	sub l
	ld h, a
	ret

; -----------------------------------------------------------------------
; Copy the picked level's four treasures' tiles to the set at
; wDebugTreasureObjTile. With the LCD on, a treasure per V-Blank.
; -----------------------------------------------------------------------
DebugMenu_LoadTreasureTiles:
	; de = v0Tiles0 tile [wDebugTreasureObjTile]
	ld a, [wDebugTreasureObjTile]
	ld e, a
	ld d, 0
	REPT 4 ; tiles
		sla e
		rl d
	ENDR
	ASSERT HIGH(v0Tiles0) == $80
	set 7, d
	ld c, 0
.loop
	push bc
	call DebugMenu_GetLevelTreasureID
	call DebugMenu_CopyTreasureTiles
	pop bc
	inc c
	ld a, c
	cp NUM_LEVEL_TREASURES
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; The icons' sprites, two per treasure: the treasure's palette if owned,
; the dim one if not. Then the chests', two each, right of the cells.
; -----------------------------------------------------------------------
DebugMenu_BuildTreasureOAM:
	ld de, wVirtualOAM
	ld c, 0
.loop
	call DebugMenu_GetTreasureGridPos
	ld a, [hli]
	ld [de], a ; y
	inc e
	ld a, [hl]
	ld [de], a ; x
	inc e
	ld a, c ; tile: 4 per treasure, the left column first
	add a
	add a
	ld b, a
	ld a, [wDebugTreasureObjTile]
	add b
	ld [de], a
	inc e
	push bc
	call DebugMenu_GetLevelTreasureID
	ld c, a
	push de
	call DebugMenu_IsCollected
	pop de
	ld a, DEBUG_POWER_PAL_DIM
	jr nc, .got_pal ; not owned
	; a = TreasureOBPals[treasure], from its bank
	ld b, 0
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
	; the right half: 8 pixels right, 2 tiles on, same attributes
	ld b, a
	ld h, d
	ld a, e
	sub OBJ_SIZE
	ld l, a
	ld a, [hli] ; y
	ld [de], a
	inc e
	ld a, [hli] ; x
	add TILE_WIDTH
	ld [de], a
	inc e
	ld a, [hli] ; tile
	add 2
	ld [de], a
	inc e
	ld a, b
	ld [de], a
	inc e
	inc c
	ld a, c
	cp NUM_LEVEL_TREASURES
	jr nz, .loop

	ld c, 0
.chest_loop
	push de
	call DebugMenu_GetLevelTreasureID
	call DebugMenu_IsCollected
	pop de
	sbc a ; $ff if owned
	and DEBUG_CHEST_OPEN
	ld b, a
	bit 0, c
	jr z, .grey_green
	ld a, DEBUG_CHEST_RED_BLUE
	add b
	ld b, a
.grey_green
	call DebugMenu_GetTreasureGridPos
	ld a, [hli]
	ld [de], a ; y
	inc e
	ld a, [hl]
	add 2 * TILE_WIDTH ; right of the cell
	ld [de], a ; x
	inc e
	ld a, DEBUG_CHEST_TILE
	add b
	ld [de], a
	inc e
	ld a, c
	cp 2
	ld a, DEBUG_CHEST_PAL_GREY_RED | OAM_BANK1
	jr c, .got_chest_pal
	ld a, DEBUG_CHEST_PAL_GREEN_BLUE | OAM_BANK1
.got_chest_pal
	ld [de], a
	inc e
	; the right half: the same tile, mirrored, 8 pixels right
	ld h, d
	ld a, e
	sub OBJ_SIZE
	ld l, a
	ld a, [hli] ; y
	ld [de], a
	inc e
	ld a, [hli] ; x
	add TILE_WIDTH
	ld [de], a
	inc e
	ld a, [hli] ; tile
	ld [de], a
	inc e
	ld a, [hl]
	or OAM_XFLIP
	ld [de], a
	inc e
	inc c
	ld a, c
	cp NUM_LEVEL_TREASURES
	jr nz, .chest_loop
	ret

; -----------------------------------------------------------------------
; SST_DEBUG_TREASURE_PAGE: the TREASURE page's input
; -----------------------------------------------------------------------
UpdateDebugTreasurePage:
	ld a, [wJoypadPressed]
	ld b, a
	and PAD_B | PAD_START
	jp nz, DebugMenu_Exit
	bit B_PAD_SELECT, b
	jp nz, DebugMenu_NextPage
	bit B_PAD_A, b
	jr nz, .toggle
	ld a, [wDebugMenuTreasureIdx]
	bit B_PAD_RIGHT, b
	jr nz, .next_level
	bit B_PAD_LEFT, b
	jr nz, .previous_level

	; UP/DOWN: the treasure, no wrapping
	ld c, a ; the pick as it was
	and %11
	bit B_PAD_UP, b
	jr z, .not_up
	and a
	jr z, .not_up
	dec a
.not_up
	bit B_PAD_DOWN, b
	jr z, .not_down
	cp NUM_LEVEL_TREASURES - 1
	jr z, .not_down
	inc a
.not_down
	ld b, a
	ld a, c
	and %11111100
	or b
	cp c
	ret z
	ld [wDebugMenuTreasureIdx], a

	; redraw the two cells during V-Blank (LCD on)
	push bc
	call DebugMenu_StartVRAMWrite
	pop bc
	push bc
	ld a, c
	and %11
	ld c, DEBUG_POWER_CELL
	call DebugMenu_DrawTreasureCell
	pop bc
	ld a, b
	ld c, DEBUG_POWER_CELL_SELECTED
	call DebugMenu_DrawTreasureCell
	jp DebugMenu_EndVRAMWrite

.next_level
	add NUM_LEVEL_TREASURES
	cp NUM_LEVELS * NUM_LEVEL_TREASURES
	jr c, .got_level
	sub NUM_LEVELS * NUM_LEVEL_TREASURES
	jr .got_level
.previous_level
	sub NUM_LEVEL_TREASURES
	jr nc, .got_level
	add NUM_LEVELS * NUM_LEVEL_TREASURES
.got_level
	ld [wDebugMenuTreasureIdx], a
	; the code and name in a V-Blank
	call DebugMenu_GetLevelName
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawLevel
	call DebugMenu_EndVRAMWrite
	; the icons: the new level's tiles into the other set, then the sprites
	; switch to it (the V-Blank handler copies them to OAM)
	ASSERT DEBUG_TREASURE_OBJ_TILE & DEBUG_TREASURE_OBJ_SET == 0
	ld a, [wDebugTreasureObjTile]
	xor DEBUG_TREASURE_OBJ_SET
	ld [wDebugTreasureObjTile], a
	call DebugMenu_LoadTreasureTiles
	jp DebugMenu_BuildTreasureOAM

.toggle
	; the icon's palette and the chest change: only the sprites
	call DebugMenu_ToggleTreasure
	jp DebugMenu_BuildTreasureOAM
