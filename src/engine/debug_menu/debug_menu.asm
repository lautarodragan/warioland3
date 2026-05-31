SETCHARMAP temple

; Form table: 1 byte transformation value + 5-char name per entry
DebugFormTable:
	db TRANSFORMATION_NONE,                "NONE "
	db TRANSFORMATION_HOT_WARIO,           "HOT  "
	db TRANSFORMATION_FLAT_WARIO,          "FLAT "
	db TRANSFORMATION_BALL_O_STRING_WARIO, "STRNG"
	db TRANSFORMATION_FAT_WARIO,           "FAT  "
	db TRANSFORMATION_ELECTRIC,            "ELEC "
	db TRANSFORMATION_PUFFY_WARIO,         "PUFFY"
	db TRANSFORMATION_ZOMBIE_WARIO,        "ZOMBI"
	db TRANSFORMATION_BOUNCY_WARIO,        "BUNCY"
	db TRANSFORMATION_CRAZY_WARIO,         "CRAZY"
	db TRANSFORMATION_VAMPIRE_WARIO,       "VAMPI"
	db TRANSFORMATION_SNOWMAN_WARIO,       "SNWMN"

DEF NUM_DEBUG_FORMS  EQU 12
DEF NUM_DEBUG_POWERS EQU 10
DEF DEBUG_MENU_ITEMS EQU 3

; Strings for menu labels (temple charmap)
DebugMenuStrHeader: db "DEBUG MENU"       ; 10 bytes, drawn at row 1 col 3
DebugMenuStrPower:  db "POWER   :"        ; 9 bytes  (cols 1-9, row 3)
DebugMenuStrForm:   db "FORM    :"        ; 9 bytes  (cols 1-9, row 5)
DebugMenuStrInvnbl: db "INVNBL  :"        ; 9 bytes  (cols 1-9, row 7)
DebugMenuStrOn:     db "ON "              ; 3 bytes
DebugMenuStrOff:    db "OFF"              ; 3 bytes
DebugMenuStrInstr:  db " A:CYCLE  B:EXIT" ; 16 bytes (row 15)

SETCHARMAP main

_DebugMenuStateTable::
	ld a, [wSubState]
	jumptable
	dw InitDebugMenu
	dw UpdateDebugMenu

; -----------------------------------------------------------------------
; Copy B bytes from [DE] to [HL+]
; -----------------------------------------------------------------------
DebugMenu_DrawString:
.loop
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; Apply the currently selected form to wTransformation/wTransformationDuration
; Clobbers: A, B, C, HL
; -----------------------------------------------------------------------
DebugMenu_ApplyForm:
	ld a, [wDebugMenuFormIdx]
	ld b, a     ; B = idx
	add a       ; 2*idx
	add a       ; 4*idx
	add b       ; 5*idx
	add b       ; 6*idx  (each entry = 6 bytes)
	ld c, a
	ld b, 0
	ld hl, DebugFormTable
	add hl, bc
	ld a, [hl]
	ld [wTransformation], a
	; Set maximum duration for timed transforms (big-endian)
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	ret

; -----------------------------------------------------------------------
; Draw the full debug menu to v0BGMap0 (LCD must be off or in VBlank)
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawAll:
	; Header "DEBUG MENU" at row 1, col 3
	hlbgcoord 3, 1
	ld de, DebugMenuStrHeader
	ld b, 10
	call DebugMenu_DrawString

	; POWER row (row 3)
	ld a, [wDebugMenuCursor]
	and a                  ; cursor == 0?
	ld a, $5d              ; ▼
	jr z, .cursor_power
	ld a, $7e              ; space
.cursor_power:
	ldcoord_a 0, 3
	hlbgcoord 1, 3
	ld de, DebugMenuStrPower
	ld b, 9
	call DebugMenu_DrawString
	ld a, [wPowerUpLevel]
	add $30                ; digit in temple charmap ($30-$39)
	ldcoord_a 10, 3

	; FORM row (row 5)
	ld a, [wDebugMenuCursor]
	cp 1
	ld a, $5d              ; ▼
	jr z, .cursor_form
	ld a, $7e              ; space
.cursor_form:
	ldcoord_a 0, 5
	hlbgcoord 1, 5
	ld de, DebugMenuStrForm
	ld b, 9
	call DebugMenu_DrawString
	; Compute DE = &DebugFormTable[formIdx].name (skip transform byte)
	ld a, [wDebugMenuFormIdx]
	ld b, a
	add a       ; 2*idx
	add a       ; 4*idx
	add b       ; 5*idx
	add b       ; 6*idx
	ld c, a
	ld b, 0
	ld hl, DebugFormTable + 1  ; +1: skip transformation byte of entry 0
	add hl, bc
	ld d, h
	ld e, l
	hlbgcoord 10, 5
	ld b, 5
	call DebugMenu_DrawString

	; INVNBL row (row 7)
	ld a, [wDebugMenuCursor]
	cp 2
	ld a, $5d              ; ▼
	jr z, .cursor_invnbl
	ld a, $7e              ; space
.cursor_invnbl:
	ldcoord_a 0, 7
	hlbgcoord 1, 7
	ld de, DebugMenuStrInvnbl
	ld b, 9
	call DebugMenu_DrawString
	ld a, [wInvincibleCounter]
	and a
	jr z, .invnbl_off
	ld de, DebugMenuStrOn
	ld b, 3
	jr .draw_invnbl_val
.invnbl_off:
	ld de, DebugMenuStrOff
	ld b, 3
.draw_invnbl_val:
	hlbgcoord 10, 7
	call DebugMenu_DrawString

	; Instructions row (row 15)
	hlbgcoord 1, 15
	ld de, DebugMenuStrInstr
	ld b, 16
	call DebugMenu_DrawString

	ret

; -----------------------------------------------------------------------
; Substate 0: initialise debug menu display
; -----------------------------------------------------------------------
InitDebugMenu:
	call DisableLCD
	call SaveBackupVRAM

	; Save animated tile state (GFX RAM already active from wrapper)
	ld a, [wAnimatedTilesFrameDuration]
	ld [wTempAnimatedTilesFrameDuration], a
	ld a, [wAnimatedTilesGfx]
	ld [wTempAnimatedTilesGroup], a

	; Init cursor to first item; keep wDebugMenuFormIdx in sync with
	; wTransformation so the display starts on the current form
	xor a
	ld [wDebugMenuCursor], a

	; Determine starting form index from current wTransformation
	ld a, [wTransformation]
	ld b, a                ; B = current transformation byte
	xor a
	ld [wDebugMenuFormIdx], a  ; default: NONE (idx 0)
	ld hl, DebugFormTable
	ld c, NUM_DEBUG_FORMS
.find_form:
	ld a, [hli]            ; load transform byte from table
	cp b
	jr z, .form_found
	; skip 5-byte name
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .find_form
	jr .form_init_done
.form_found:
	; HL points one past the matching transform byte
	; index = (NUM_DEBUG_FORMS - C)
	ld a, NUM_DEBUG_FORMS
	sub c
	ld [wDebugMenuFormIdx], a
.form_init_done:

	call FillBGMap0_With7f
	call ClearVirtualOAM
	farcall LoadFontTiles
	farcall LoadFontPals
	call ApplyTempPals1ToBGPals

	call DebugMenu_DrawAll

	call VBlank_PauseMenu
	xor a
	ldh [rSCY], a
	ldh [rSCX], a
	ld [wSCY], a
	ld [wSCX], a

	ld a, LCDC_DEFAULT
	ldh [rLCDC], a

	ld hl, wSubState
	inc [hl]
	ret

; -----------------------------------------------------------------------
; Substate 1: update debug menu (handle input, apply changes, draw)
; -----------------------------------------------------------------------
UpdateDebugMenu:
	ld a, [wJoypadPressed]
	ld b, a                ; save joypad

	; B button → exit
	bit B_PAD_B, a
	jr nz, .exit

	; Check for any actionable input
	ld a, b
	and PAD_UP | PAD_DOWN | PAD_A
	ret z                  ; nothing pressed, done

	; Determine if anything changed (used to trigger redraw)
	ld c, 0                ; C = changed flag

	; UP: move cursor up
	ld a, b
	bit B_PAD_UP, a
	jr z, .not_up
	ld a, [wDebugMenuCursor]
	and a
	jr z, .not_up          ; already at top
	dec a
	ld [wDebugMenuCursor], a
	ld c, 1
.not_up:

	; DOWN: move cursor down
	ld a, b
	bit B_PAD_DOWN, a
	jr z, .not_down
	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_ITEMS - 1
	jr z, .not_down        ; already at bottom
	inc a
	ld [wDebugMenuCursor], a
	ld c, 1
.not_down:

	; A: cycle value of selected item
	ld a, b
	bit B_PAD_A, a
	jr z, .check_redraw

	ld a, [wDebugMenuCursor]
	and a
	jr z, .change_power
	cp 1
	jr z, .change_form
	; else: toggle invincible
	ld a, [wInvincibleCounter]
	and a
	ld a, $FF
	jr z, .set_invnbl
	xor a
.set_invnbl:
	ld [wInvincibleCounter], a
	ld c, 1
	jr .check_redraw

.change_power:
	ld a, [wPowerUpLevel]
	inc a
	cp NUM_DEBUG_POWERS
	jr c, .power_ok
	xor a
.power_ok:
	ld [wPowerUpLevel], a
	ld c, 1
	jr .check_redraw

.change_form:
	ld a, [wDebugMenuFormIdx]
	inc a
	cp NUM_DEBUG_FORMS
	jr c, .form_ok
	xor a
.form_ok:
	ld [wDebugMenuFormIdx], a
	call DebugMenu_ApplyForm
	ld c, 1

.check_redraw:
	ld a, c
	and a
	ret z                  ; nothing changed

	; Redraw with LCD off
	call DisableLCD
	call DebugMenu_DrawAll
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	ret

.exit:
	jp DebugMenu_Exit

; -----------------------------------------------------------------------
; Exit: restore level state
; -----------------------------------------------------------------------
DebugMenu_Exit:
	call DisableLCD
	call ClearVirtualOAM
	farcall DrawLevelObjectsAfterLevelReturn
	call LoadBackupVRAM

	xor a
	ld [wUnused_IsPaused], a
	; Restore animated tile state (GFX RAM still active from wrapper)
	ld a, [wTempAnimatedTilesFrameDuration]
	ld [wAnimatedTilesFrameDuration], a
	ld a, [wTempAnimatedTilesGroup]
	ld [wAnimatedTilesGfx], a
	xor a
	ld [wAnimatedTilesFrameCount], a
	ld [wAnimatedTilesFrame], a
	ld a, TRUE
	ld [wRoomAnimatedTilesEnabled], a

	call ApplyTempPals1ToBGPals
	call ApplyTempPals2ToOBPals
	call UpdateLevelMusic
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	jp ReturnToPendingLevelState
