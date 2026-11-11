; The debug menu's TREASURE page (START from POWER). A level's code and
; name, and its four treasures (grey, red, green, blue), each with its icon,
; its colour and OPEN or CLOSED, like the chest. The icons are sprites like
; the POWER page's, with the same palettes: in the treasure's colours if
; owned, in grey if not.
;
; LEFT/RIGHT change the level (wrapping), UP/DOWN pick a treasure, A gives
; or takes it, START goes back to MAIN, B or SELECT closes the menu.
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
; Load the TREASURE page (DebugMenu_ShowPage, the LCD off)
; -----------------------------------------------------------------------
DebugMenu_LoadTreasurePage:
	call DebugMenu_LoadTreasurePals
	ld hl, DebugTreasureTilemap
	ld de, DebugTreasureAttrmap
	call DebugMenu_LoadMap
	call DebugMenu_GetLevelName
	call DebugMenu_DrawLevel
	call DebugMenu_DrawTreasureStatuses
	ld a, [wDebugMenuTreasureIdx]
	and %11
	ld c, DEBUG_POWER_CELL_SELECTED
	call DebugMenu_DrawTreasureCell
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
; Draw the picked level's code and its name (de, from
; DebugMenu_GetLevelName). The LCD must be off or in V-Blank.
; Clobbers: A, B, D, E, H, L
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
	ld d, h
	ld e, l
	hlbgcoord DEBUG_TREASURE_CODE_X, DEBUG_TREASURE_CODE_Y
	ld b, 2
	call DebugMenu_DrawString
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

; -----------------------------------------------------------------------
; Draw OPEN or CLOSED for the picked level's four treasures (all) or
; treasure c (DebugMenu_DrawTreasureStatus), under its colour. The LCD must
; be off or in V-Blank.
; Clobbers: A, B, D, E, H, L (and C for all four)
; -----------------------------------------------------------------------
DebugMenu_DrawTreasureStatuses:
	ld c, 0
.loop
	call DebugMenu_DrawTreasureStatus
	inc c
	ld a, c
	cp NUM_LEVEL_TREASURES
	jr nz, .loop
	ret

DebugMenu_DrawTreasureStatus:
	call DebugMenu_GetLevelTreasureID
	call DebugMenu_IsCollected
	ld de, DebugMenuStrOpen
	jr c, .got_status
	ld de, DebugMenuStrClosed
.got_status
	; hl = the second line right of treasure c's cell, 2 map rows apart
	ld a, c
	swap a
	add a
	add a ; * 2 * TILEMAP_WIDTH
	ld l, a
	ld h, 0
	push bc
	ld bc, (DEBUG_TREASURE_TOP_Y + 1) * TILEMAP_WIDTH + DEBUG_TREASURE_ICON_X + 2 + v0BGMap0
	add hl, bc
	pop bc
	ld b, DEBUG_POWER_NAME_WIDTH
	jp DebugMenu_DrawString

; -----------------------------------------------------------------------
; Draw treasure a's cell (the picked level's) with tile c, and its colour
; and status in yellow (DEBUG_POWER_CELL_SELECTED) or white. The LCD must
; be off or in V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawTreasureCell:
	swap a
	add a
	add a ; * 2 * TILEMAP_WIDTH
	ld l, a
	ld h, 0
	ld de, DEBUG_TREASURE_TOP_Y * TILEMAP_WIDTH + DEBUG_TREASURE_ICON_X + v0BGMap0
	add hl, de
	jp DebugMenu_DrawCell

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
; the dim one if not.
; -----------------------------------------------------------------------
DebugMenu_BuildTreasureOAM:
	ld de, wVirtualOAM
	ld c, 0
.loop
	ld a, c
	swap a ; 16 pixels (2 map rows) apart
	add DEBUG_TREASURE_TOP_Y * TILE_HEIGHT + OAM_Y_OFS
	ld [de], a ; y
	inc e
	ld a, DEBUG_TREASURE_ICON_X * TILE_WIDTH + OAM_X_OFS
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
	ret

; -----------------------------------------------------------------------
; SST_DEBUG_TREASURE_PAGE: the TREASURE page's input
; -----------------------------------------------------------------------
UpdateDebugTreasurePage:
	ld a, [wJoypadPressed]
	ld b, a
	and PAD_B | PAD_SELECT
	jp nz, DebugMenu_Exit
	bit B_PAD_START, b
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
	ei
	ret

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
	; the code and name in a V-Blank, the statuses in the next one
	call DebugMenu_GetLevelName
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawLevel
	ei
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawTreasureStatuses
	ei
	; the icons: the new level's tiles into the other set, then the sprites
	; switch to it (the V-Blank handler copies them to OAM)
	ASSERT DEBUG_TREASURE_OBJ_TILE & DEBUG_TREASURE_OBJ_SET == 0
	ld a, [wDebugTreasureObjTile]
	xor DEBUG_TREASURE_OBJ_SET
	ld [wDebugTreasureObjTile], a
	call DebugMenu_LoadTreasureTiles
	jp DebugMenu_BuildTreasureOAM

.toggle
	call DebugMenu_ToggleTreasure
	ld a, [wDebugMenuTreasureIdx]
	and %11
	ld c, a
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawTreasureStatus
	ei
	jp DebugMenu_BuildTreasureOAM

DebugTreasureTilemap: INCBIN "data/bgmaps/debug_treasure.tilemap.rle"
DebugTreasureAttrmap: INCBIN "data/bgmaps/debug_treasure.attrmap.rle"
