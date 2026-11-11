; The debug menu's POWER page (SELECT from LEVEL). The ten power-up levels
; (NONE and the nine power-ups, see wario_constants.asm), each with Action
; Help's icon (Wario's face for NONE), the ones owned in their colour and
; the others in grey, and Action Help's cursor on the selected one. The
; D-pad moves the selection, A sets wPowerUpLevel to it, SELECT goes on to
; the TREASURE page, B or START closes the menu.
;
; The icons are sprites (two 8x16 each), in Action Help's palettes for them
; (picked with PowerUpOBPals), on white cells. Their tiles and the cursor's
; (DebugMenuPowerGfx, which tools/debug_menu_bgmap.py takes from Action
; Help's graphics) are copied into VRAM0 $8000-$827f when the menu opens.
; That part of the font is never shown by the BG (which uses the
; $8800-$97ff tiles). All 8 BG palettes are the menu's: palette 7 is the
; cells'.

; Action Help's icons, 4 tiles each (the left column first), and its
; cursor's two frames, 2 tiles each
DebugMenuPowerGfx: INCBIN "gfx/debug_menu_power.2bpp"
.end
	ASSERT DebugMenuPowerGfx.end - DebugMenuPowerGfx == (NUM_DEBUG_POWERS * 4 + 4) tiles

; each level's cell: its BG map address, and its sprites' OAM Y and X
DebugPowerCells:
FOR I, NUM_DEBUG_POWERS
	DEF _X = DEBUG_POWER_ICON_X + (I / DEBUG_POWER_ROWS) * DEBUG_POWER_COL_WIDTH
	DEF _Y = DEBUG_POWER_TOP_Y + (I % DEBUG_POWER_ROWS) * 2
	dwcoord _X, _Y
	db _Y * TILE_HEIGHT + OAM_Y_OFS, _X * TILE_WIDTH + OAM_X_OFS
ENDR
	PURGE _X, _Y

; In palette 7: the TREASURE page's icon cell's corner, white with a dark
; red margin (the background's colour, so neighbouring cells stay apart; the
; map flips it for the other corners), and DEBUG_POWER_WHITE, white, under
; the POWER page's icons.
DebugPowerCellTiles:
	dw `33333333
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000
	dw `30000000

	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000

; OB palette DEBUG_POWER_PAL_DIM: a light grey version of the treasures, for
; the TREASURE page's treasures not owned (colour 0 is transparent)
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
; The POWER page's icons' tiles from tile 0 (VRAM0 $8000), and its cursor's
; at DEBUG_POWER_CURSOR_TILE, loaded with the menu's other tiles when it
; opens. The LCD must be off.
; -----------------------------------------------------------------------
DebugMenu_LoadPowerTiles:
	ld hl, DebugMenuPowerGfx
	ld de, v0Tiles0
	ld bc, NUM_DEBUG_POWERS * 4 tiles
	call CopyHLToDE_BC
	ld de, v0Tiles0 tile DEBUG_POWER_CURSOR_TILE
	ld bc, 4 tiles
	jp CopyHLToDE_BC

; OB palette DEBUG_POWER_PAL_ICON_DIM: the POWER page's icons not owned, in
; grey with Action Help's black outline (colour 0 is transparent)
DebugPowerIconDimPal:
	rgb 31, 31, 31
	rgb 25, 25, 25
	rgb 16, 16, 16
	rgb  0,  0,  0

; -----------------------------------------------------------------------
; The POWER page's OB palettes, into wTempPals2 (the page shows them with
; its sprites, DebugMenu_NextPage): the icons' dim grey, Action Help's cursor's
; two colours (its OB palettes 7 and 4) and its icons' colours (its BG
; palettes 4-7, OBPAL_POWER_UP_*).
; -----------------------------------------------------------------------
DebugMenu_LoadPowerPals:
	ld hl, DebugPowerIconDimPal
	ld de, wTempPals2 palette DEBUG_POWER_PAL_ICON_DIM
	ld b, 1 palettes
	call CopyHLToDE
	ld a, BANK(ActionHelpOBPals)
	ldh [hCallFuncBank], a
	ld hl, ActionHelpOBPals palette 7
	ld de, wTempPals2 palette DEBUG_POWER_PAL_CURSOR
	ld b, 1 palettes
	hcall CopyHLToDE
	ld a, BANK(ActionHelpOBPals)
	ldh [hCallFuncBank], a
	ld hl, ActionHelpOBPals palette 4
	ld de, wTempPals2 palette (DEBUG_POWER_PAL_CURSOR + 1)
	ld b, 1 palettes
	hcall CopyHLToDE
	ld a, BANK(ActionHelpPals_1e4e6f)
	ldh [hCallFuncBank], a
	ld hl, ActionHelpPals_1e4e6f palette OBPAL_POWER_UP_YELLOW
	ld de, wTempPals2 palette OBPAL_POWER_UP_YELLOW
	ld b, 4 palettes
	ASSERT OBPAL_POWER_UP_YELLOW == 4 && OBPAL_POWER_UP_BLUE == 7
	hcall CopyHLToDE
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
	jp DebugMenu_EndVRAMWrite

; -----------------------------------------------------------------------
; The TREASURE page's OB palettes, into wTempPals2 (the page shows them
; with its sprites, DebugMenu_NextPage): the dim grey, the treasures'
; (OBPAL_TREASURE_*), and the TREASURE page's chests' (DEBUG_CHEST_PAL_*)
; and cursor's (DEBUG_CURSOR_PAL). Loaded with the page: FORM changes
; Wario's, in the same palettes.
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
	ld hl, TreasureCollectionOBPals
	ld de, wTempPals2 palette DEBUG_CURSOR_PAL
	ld b, 1 palettes
	ld a, BANK(TreasureCollectionOBPals)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE
	ld hl, PauseMenuOBPals palette 3
	ld de, wTempPals2 palette DEBUG_CHEST_PAL_GREY_RED
	ld b, 2 palettes
	ASSERT DEBUG_CHEST_PAL_GREEN_BLUE == DEBUG_CHEST_PAL_GREY_RED + 1
	ld a, BANK(PauseMenuOBPals)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE
	ret

; -----------------------------------------------------------------------
; Load the POWER page, its map already in BG map 0 (DebugMenu_LoadPage)
; -----------------------------------------------------------------------
DebugMenu_LoadPowerPage:
	call DebugMenu_LoadPowerPals
	call DebugMenu_StartVRAMWrite
	ld a, [wDebugPowerCursor]
	ld c, TRUE ; selected
	call DebugMenu_DrawPowerCell
	call DebugMenu_EndVRAMWrite
	xor a
	ld [wDebugPowerCursorAnim], a
	jp DebugMenu_BuildPowerOAM

; -----------------------------------------------------------------------
; The icons' sprites, two per level: the power-up's palette for the levels
; owned (up to wPowerUpLevel), the dim one for the others, after the
; cursor's two (sprites earlier in OAM are drawn over later ones: the
; cursor goes over the icons' black outlines). Then the cursor's.
; -----------------------------------------------------------------------
DebugMenu_BuildPowerOAM:
	ld de, wVirtualOAM + 2 * OBJ_SIZE ; after the cursor's
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
	ld a, DEBUG_POWER_PAL_ICON_DIM
	jr c, .got_pal ; level < c: not owned
	; a = PowerUpOBPals[level], from its bank
	ld b, 0
	ld hl, PowerUpOBPals
	add hl, bc
	ld b, 1
	ld a, BANK(PowerUpOBPals)
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
;	fallthrough

; -----------------------------------------------------------------------
; Action Help's cursor on the selected level's icon: a 16x16 frame, a tile
; and its mirror image, in one of its two frames (wDebugPowerCursorAnim:
; the first DEBUG_POWER_CURSOR_FRAME_DURATION frames its OAM frame 14, red,
; then 15, yellow)
; Clobbers: A, B, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_BuildPowerCursorOAM:
	ld a, [wDebugPowerCursor]
	add a
	add a ; 4 bytes per cell
	ld e, a
	ld d, 0
	ld hl, DebugPowerCells + 2 ; its OAM Y and X
	add hl, de
	ld d, [hl] ; y
	inc hl
	ld e, [hl] ; x
	ld a, [wDebugPowerCursorAnim]
	cp DEBUG_POWER_CURSOR_FRAME_DURATION
	ld b, DEBUG_POWER_CURSOR_TILE
	ld c, DEBUG_POWER_PAL_CURSOR
	jr c, .got_frame
	ld b, DEBUG_POWER_CURSOR_TILE + 2
	ld c, DEBUG_POWER_PAL_CURSOR + 1
.got_frame
	ld hl, wVirtualOAM + DEBUG_POWER_CURSOR_OAM * OBJ_SIZE
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, e
	add TILE_WIDTH
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	or OAM_XFLIP
	ld [hli], a
	ret

; the cursor's animation, every frame
DebugMenu_AnimatePowerCursor:
	ld hl, wDebugPowerCursorAnim
	ld a, [hl]
	inc a
	cp DEBUG_POWER_CURSOR_ANIM_LENGTH
	jr c, .got_frame
	xor a
.got_frame
	ld [hl], a
	jr DebugMenu_BuildPowerCursorOAM

; -----------------------------------------------------------------------
; Draw level a's name in yellow if c is TRUE (selected), else in white. The
; LCD must be off or in V-Blank.
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
; The two lines of text right of an icon cell at hl (its top left corner in
; the BG map) in yellow if c is TRUE (selected), else in white. The LCD must
; be off or in V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawCell:
	ld a, c
	and a
	ld b, 6 ; cursor and values, yellow
	jr nz, .got_pal
	ld b, 5 ; labels, white
.got_pal
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	inc l
	inc l ; right of the cell
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
	and PAD_B | PAD_START
	jp nz, DebugMenu_Exit
	bit B_PAD_SELECT, b
	jp nz, DebugMenu_NextPage
	; the cursor's animation: not on a frame that leaves the page, whose
	; sprites stay as they are until the next page shows
	push bc
	call DebugMenu_AnimatePowerCursor
	pop bc
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
	ld c, FALSE
	call DebugMenu_DrawPowerCell
	pop af
	ld c, TRUE
	call DebugMenu_DrawPowerCell
	call DebugMenu_EndVRAMWrite
	; the cursor moves (the V-Blank handler copies the sprites to OAM)
	jp DebugMenu_BuildPowerCursorOAM

.apply
	ld a, [wDebugPowerCursor]
	call DebugMenu_SetPowerLevel
	; the sprites are copied to OAM at the next V-Blank
	jp DebugMenu_BuildPowerOAM
