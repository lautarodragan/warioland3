; Action Help's edit mode (this fork). SELECT on Action Help (opened from the
; pause menu) turns it on and off. In it, the power-up bar shows every
; power-up's icon, the ones Wario has in their colours and the others in
; grey (instead of "?"), and A sets the power-up level to the selected one:
; Wario has every power-up up to it, as with the debug menu's POWER page. B
; and START still close Action Help; A doesn't, in the mode. The D-pad
; picks a power-up as usual.
;
; The grey is BG palette 3, the bar's brown, which the demo's floor shares:
; in the mode it's grey too (ActionHelpEditPal), which also shows the mode
; is on. LoadActionHelpBGPals keeps it grey when the demo's palettes are
; loaded again.

DEF ACTION_HELP_BAR_Y        EQU 16 ; the power-up bar's first BG map row
DEF ACTION_HELP_LOCKED_TILE  EQU $64 ; the "?" box, 4 tiles like an icon
DEF ACTION_HELP_PAL_OWNED    EQU 3 ; the bar's brown, grey in the mode
DEF ACTION_HELP_PAL_LOCKED   EQU 7 ; the "?" boxes'

; -----------------------------------------------------------------------
; Action Help's input for the mode (UpdateActionHelp), when it shows a main
; power-up from the pause menu: SELECT, and A in the mode.
; output: a = the buttons that close Action Help
; -----------------------------------------------------------------------
ActionHelpEdit_HandleInput:
	ld a, [wPowerUpLevel]
	and ACTION_HELP_TITLE_SCREEN | ACTION_HELP_LEVEL_CLEAR
	jr nz, .closing_buttons
	ld a, [wActionHelpPowerUp]
	cp NUM_MAIN_POWER_UPS
	jr nc, .closing_buttons
	ld a, [wJoypadPressed]
	bit B_PAD_SELECT, a
	jr z, .no_select
	ld a, [wActionHelpEditMode]
	xor TRUE
	ld [wActionHelpEditMode], a
	call ActionHelpEdit_SetPal
	call ActionHelpEdit_DrawBar
	play_sfx SFX_MENU_SCROLL
	jr .closing_buttons
.no_select
	ld a, [wActionHelpEditMode]
	and a
	jr z, .closing_buttons
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .closing_buttons
	; A: Wario's power-up level is the selected one
	ld a, [wPowerUpLevel]
	and ~POWER_UP_MASK
	ld b, a
	ld a, [wActionHelpPowerUp]
	or b
	ld [wPowerUpLevel], a
	call ActionHelpEdit_DrawBar
	play_sfx SFX_SELECTION
.closing_buttons
	ld a, [wActionHelpEditMode]
	and a
	ld a, PAD_B | PAD_START
	ret nz
	ld a, PAD_A | PAD_B | PAD_START
	ret

; -----------------------------------------------------------------------
; BG palette 3, in wTempPals1 and the hardware: grey in the mode, else the
; bar's brown (the same in ActionHelpBlackedOutBGPals, between demos)
; -----------------------------------------------------------------------
ActionHelpEdit_SetPal:
	ld hl, ActionHelpPals_1e4e6f palette ACTION_HELP_PAL_OWNED
	ld a, [wActionHelpEditMode]
	and a
	jr z, .got_pal
	ld hl, ActionHelpEditPal
.got_pal
	ld de, wTempPals1 palette ACTION_HELP_PAL_OWNED
	ld b, 1 palettes
	ld a, BANK(ActionHelpEditPal)
	ASSERT BANK(ActionHelpEditPal) == BANK(ActionHelpPals_1e4e6f)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE
	call ActionHelpEdit_StartVRAMWrite
	ld a, BGPI_AUTOINC | palette ACTION_HELP_PAL_OWNED
	ldh [rBGPI], a
	ld hl, wTempPals1 palette ACTION_HELP_PAL_OWNED
	ld c, LOW(rBGPD)
REPT PAL_SIZE
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	ei
	ret

; -----------------------------------------------------------------------
; The power-up bar, the 10 slots' tiles and palettes, in a V-Blank. Out of
; the mode, as the game draws it: the power-ups Wario has in brown, the
; selected one in its colour, the others "?". In the mode: every icon, the
; ones Wario has in their colours, the others in grey.
; -----------------------------------------------------------------------
ActionHelpEdit_DrawBar:
	call ActionHelpEdit_StartVRAMWrite
	ld hl, v0BGMap1 + ACTION_HELP_BAR_Y * TILEMAP_WIDTH
	ld c, 0 ; slot
.loop
	push hl
	; b = its palette
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	cp c
	jr c, .locked
	; owned: its colour in the mode or if selected, else brown
	ld a, [wActionHelpEditMode]
	and a
	jr nz, .colour
	ld a, [wActionHelpPowerUp]
	cp c
	ld b, ACTION_HELP_PAL_OWNED
	jr nz, .got_pal
.colour
	push hl
	ld b, 0
	ld hl, PowerUpOBPals
	add hl, bc
	ld b, [hl]
	pop hl
	jr .got_pal
.locked
	ld b, ACTION_HELP_PAL_LOCKED
	ld a, [wActionHelpEditMode]
	and a
	jr z, .got_pal
	ld b, ACTION_HELP_PAL_OWNED ; grey in the mode
.got_pal
	; a = its top left tile: its icon, or "?" if locked out of the mode
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	cp c
	jr nc, .icon
	ld a, [wActionHelpEditMode]
	and a
	ld a, ACTION_HELP_LOCKED_TILE
	jr z, .got_tile
.icon
	; icons 0-7: $40 + 2 * slot; 8 and 9: $60 + 2 * (slot - 8)
	ld a, c
	add a
	add $40
	cp $50
	jr c, .got_tile
	add $60 - $50
.got_tile
	; tiles: top left, top right, and 16 tiles on below
	ld d, a
	xor a ; VRAM0
	ldh [rVBK], a
	ld a, d
	ld [hli], a
	inc a
	ld [hld], a
	ld de, TILEMAP_WIDTH
	add hl, de
	add $10 - 1
	ld [hli], a
	inc a
	ld [hld], a
	; attributes
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld a, b
	ld [hli], a
	ld [hld], a
	ld de, -TILEMAP_WIDTH
	add hl, de
	ld [hli], a
	ld [hl], a
	pop hl
	inc l
	inc l
	inc c
	ld a, c
	cp NUM_MAIN_POWER_UPS
	jr nz, .loop
	xor a
	ldh [rVBK], a
	ei
	ret

; -----------------------------------------------------------------------
; Wait for the start of the next V-Blank with interrupts off, to write VRAM
; with the LCD on; ei when done, in the same V-Blank.
; Clobbers: A
; -----------------------------------------------------------------------
ActionHelpEdit_StartVRAMWrite:
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
