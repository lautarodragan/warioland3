SETCHARMAP temple

; Form table: 6 bytes per entry
;   [0]     transformation byte
;   [1-5]   5-char display name
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
DEF DEBUG_MENU_ITEMS EQU 4

; Strings for menu labels (temple charmap)
DebugMenuStrHeader: db "DEBUG MENU"       ; 10 bytes, drawn at row 1 col 3
DebugMenuStrPower:  db "POWER   :"        ; 9 bytes  (cols 1-9, row 3)
DebugMenuStrForm:   db "FORM    :"        ; 9 bytes  (cols 1-9, row 5)
DebugMenuStrInvnbl: db "INVNBL  :"        ; 9 bytes  (cols 1-9, row 7)
DebugMenuStrGolf:   db "GOLF    :"        ; 9 bytes  (cols 1-9, row 9)
DebugMenuStrOn:     db "ON "              ; 3 bytes
DebugMenuStrOff:    db "OFF"              ; 3 bytes
DebugMenuStrInstr:  db "LR:CYCLE  B:EXIT" ; 16 bytes (row 15)

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
; Apply the currently selected form.
; Calls the appropriate game SetState_* function after setting up all
; required wario state vars (transformation, touch states, GFX, OAM).
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_ApplyForm:
	ld a, [wDebugMenuFormIdx]
	jumptable
	dw .form_none
	dw .form_hot
	dw .form_flat
	dw .form_string
	dw .form_fat
	dw .form_electric
	dw .form_puffy
	dw .form_zombie
	dw .form_bouncy
	dw .form_crazy
	dw .form_vampire
	dw .form_snowman

; NONE: restore normal Wario state without playing the in-game recovery SFX
.form_none:
	call ClearTransformationValues
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, [wJumpVelTable]
	and a
	jr nz, .form_none_fall
	farcall SetState_Idling
	ret
.form_none_fall:
	farcall StartFall
	ret

; HOT: bump-type transformation (kills with touch)
.form_hot:
	ld a, TRANSFORMATION_HOT_WARIO
	ld [wTransformation], a
	ld a, 1
	ld [wWarioTransformationProgress], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	; SetState_OnFire_ResetStateCounter loads WarioHotGfx, OAM_1673c,
	; sets WarioOnFirePal, WST_ON_FIRE, collision box, clears state vars
	farcall SetState_OnFire_ResetStateCounter
	ret

; FLAT: slide GFX, different collision box
.form_flat:
	ld a, TRANSFORMATION_FLAT_WARIO
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	; Flat wario uses slide GFX + OAM_16e9d (SetState_FlatIdling doesn't load GFX)
	ld a, BANK(WarioSlideGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSlideGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSlideGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_16e9d)
	ld [wOAMBank], a
	ld a, HIGH(OAM_16e9d)
	ld [wOAMPtr + 0], a
	ld a, LOW(OAM_16e9d)
	ld [wOAMPtr + 1], a
	farcall SetState_FlatIdling
	ret

; BALL-O-STRING: attack-type, rolls fast
.form_string:
	ld a, TRANSFORMATION_BALL_O_STRING_WARIO
	ld [wTransformation], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioStringPal
	call SetWarioPal
	; SetState_BallOString doesn't load GFX, so load here
	ld a, BANK(WarioStringGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioStringGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioStringGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_171c0)
	ld [wOAMBank], a
	ld a, HIGH(OAM_171c0)
	ld [wOAMPtr + 0], a
	ld a, LOW(OAM_171c0)
	ld [wOAMPtr + 1], a
	farcall SetState_BallOString
	ret

; FAT: bump-type, SetState_FatIdling sets wTouchState/wca94 itself
.form_fat:
	ld a, TRANSFORMATION_FAT_WARIO
	ld [wTransformation], a
	ld a, HIGH(FAT_WARIO_DURATION)
	ld [wTransformationDuration], a
	ld a, LOW(FAT_WARIO_DURATION)
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	; SetState_FatIdling doesn't load GFX, so load here
	ld a, BANK(WarioFatGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioFatGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioFatGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_1742d)
	ld [wOAMBank], a
	ld a, HIGH(OAM_1742d)
	ld [wOAMPtr + 0], a
	ld a, LOW(OAM_1742d)
	ld [wOAMPtr + 1], a
	; SetState_FatIdling sets wTouchState=ATTACK, wStingTouchState=ATTACK, wca94=$01,
	; and standard collision box
	farcall SetState_FatIdling
	ret

; ELECTRIC: vanish-type (touches make enemies disappear), inline full setup
.form_electric:
	ld a, TRANSFORMATION_ELECTRIC
	ld [wTransformation], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wInvisibleFrame], a
	ld a, WST_ELECTRIC_START
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	call UpdateLevelMusic
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld hl, WarioElectricPal
	call SetWarioPal
	ld a, BANK(WarioElectricGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioElectricGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioElectricGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_1790e)
	ld [wOAMBank], a
	ld a, HIGH(OAM_1790e)
	ld [wOAMPtr + 0], a
	ld a, LOW(OAM_1790e)
	ld [wOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .elec_right
	ld a, HIGH(Frameset_17b79)
	ld [wFramesetPtr + 0], a
	ld a, LOW(Frameset_17b79)
	ld [wFramesetPtr + 1], a
	jr .elec_anim
.elec_right:
	ld a, HIGH(Frameset_17b76)
	ld [wFramesetPtr + 0], a
	ld a, LOW(Frameset_17b76)
	ld [wFramesetPtr + 1], a
.elec_anim:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateAnimation
	ret

; PUFFY: SetState_PuffyInflating sets wTransformation/wTouchState/wca94/GFX itself
.form_puffy:
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_PuffyInflating
	ret

; ZOMBIE: SetState_ZombieIdling sets wTouchState/wca94/GFX/OAM itself
.form_zombie:
	ld a, TRANSFORMATION_ZOMBIE_WARIO
	ld [wTransformation], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_ZombieIdling
	ret

; BOUNCY: SetState_BouncyStart loads GFX/OAM/palette itself
.form_bouncy:
	ld a, TRANSFORMATION_BOUNCY_WARIO
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_BouncyStart
	ret

; CRAZY: SetState_CrazySpinning loads GFX/OAM itself; mirror wDirection to wObjDirection
.form_crazy:
	ld a, TRANSFORMATION_CRAZY_WARIO
	ld [wTransformation], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	; SetState_CrazySpinning copies wObjDirection → wDirection; mirror current direction
	ld a, [wDirection]
	ld [wObjDirection], a
	farcall SetState_CrazySpinning
	ret

; VAMPIRE: set state, wTouchState, palette; SetState_VampireIdling loads GFX/OAM
.form_vampire:
	ld a, TRANSFORMATION_VAMPIRE_WARIO
	ld [wTransformation], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioVampirePal
	call SetWarioPal
	; Reset collision box (SetState_VampireIdling doesn't set it)
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	; SetState_VampireIdling sets wOAMPtr but not wOAMBank; set it here since
	; we bypass the normal VampireTransforming → VampireIdling path.
	ld a, BANK("Wario OAM 2")
	ld [wOAMBank], a
	farcall SetState_VampireIdling
	ret

; SNOWMAN: SetState_TurningIntoSnowman does full GFX/OAM/palette setup
.form_snowman:
	ld a, TRANSFORMATION_SNOWMAN_WARIO
	ld [wTransformation], a
	xor a
	ld [wWarioTransformationProgress], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wca94], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_TurningIntoSnowman
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
	; Compute DE = &DebugFormTable[formIdx].name  (entries are 6 bytes, name at +1)
	ld a, [wDebugMenuFormIdx]
	add a       ; 2*idx
	ld c, a    ; save 2*idx
	add a       ; 4*idx
	add c       ; 6*idx
	ld c, a
	ld b, 0
	ld hl, DebugFormTable + 1  ; +1: skip transform byte
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

	; GOLF row (row 9)
	ld a, [wDebugMenuCursor]
	cp 3
	ld a, $5d              ; ▼
	jr z, .cursor_golf
	ld a, $7e              ; space
.cursor_golf:
	ldcoord_a 0, 9
	hlbgcoord 1, 9
	ld de, DebugMenuStrGolf
	ld b, 9
	call DebugMenu_DrawString
	ld a, [wIsMinigameCleared]
	and a
	jr z, .golf_off
	ld de, DebugMenuStrOn
	ld b, 3
	jr .draw_golf_val
.golf_off:
	ld de, DebugMenuStrOff
	ld b, 3
.draw_golf_val:
	hlbgcoord 10, 9
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
	ld a, [hli]            ; load transform byte from table entry [0]
	cp b
	jr z, .form_found
	; skip remaining 5 bytes of this entry (5-char name)
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .find_form
	jr .form_init_done
.form_found:
	; index = NUM_DEBUG_FORMS - C
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
	jp nz, .exit

	; Check for any actionable input
	ld a, b
	and PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT
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

	; RIGHT: cycle value forward
	ld a, b
	bit B_PAD_RIGHT, a
	jr z, .not_right

	ld a, [wDebugMenuCursor]
	and a
	jr z, .change_power_fwd
	cp 1
	jr z, .change_form_fwd
	cp 2
	jr z, .toggle_invnbl_r
	; else cursor 3: toggle golf win
	ld a, [wIsMinigameCleared]
	xor TRUE
	ld [wIsMinigameCleared], a
	ld a, ROOMTRANSITION_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	ld c, 1
	jr .not_right
.toggle_invnbl_r:
	ld a, [wInvincibleCounter]
	and a
	ld a, $FF
	jr z, .set_invnbl_r
	xor a
.set_invnbl_r:
	ld [wInvincibleCounter], a
	ld c, 1
	jr .not_right

.change_power_fwd:
	ld a, [wPowerUpLevel]
	inc a
	cp NUM_DEBUG_POWERS
	jr c, .power_fwd_ok
	xor a
.power_fwd_ok:
	ld [wPowerUpLevel], a
	ld c, 1
	jr .not_right

.change_form_fwd:
	ld a, [wDebugMenuFormIdx]
	inc a
	cp NUM_DEBUG_FORMS
	jr c, .form_fwd_ok
	xor a
.form_fwd_ok:
	ld [wDebugMenuFormIdx], a
	call DebugMenu_ApplyForm
	ld c, 1
.not_right:

	; LEFT: cycle value backward
	; Reload joypad in case DebugMenu_ApplyForm clobbered b
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr z, .check_redraw

	ld a, [wDebugMenuCursor]
	and a
	jr z, .change_power_bwd
	cp 1
	jr z, .change_form_bwd
	cp 2
	jr z, .toggle_invnbl_l
	; else cursor 3: toggle golf win (same as right)
	ld a, [wIsMinigameCleared]
	xor TRUE
	ld [wIsMinigameCleared], a
	ld a, ROOMTRANSITION_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	ld c, 1
	jr .check_redraw
.toggle_invnbl_l:
	ld a, [wInvincibleCounter]
	and a
	ld a, $FF
	jr z, .set_invnbl_l
	xor a
.set_invnbl_l:
	ld [wInvincibleCounter], a
	ld c, 1
	jr .check_redraw

.change_power_bwd:
	ld a, [wPowerUpLevel]
	and a
	jr z, .power_bwd_wrap
	dec a
	jr .power_bwd_ok
.power_bwd_wrap:
	ld a, NUM_DEBUG_POWERS - 1
.power_bwd_ok:
	ld [wPowerUpLevel], a
	ld c, 1
	jr .check_redraw

.change_form_bwd:
	ld a, [wDebugMenuFormIdx]
	and a
	jr z, .form_bwd_wrap
	dec a
	jr .form_bwd_ok
.form_bwd_wrap:
	ld a, NUM_DEBUG_FORMS - 1
.form_bwd_ok:
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

	; wTempPals2 is now back to the pre-menu snapshot. InitDebugMenu also called
	; LoadFontPals which had previously overwritten wTempPals2 with font palettes.
	; Re-apply the current Wario palette from wWarioPalsPtr (unaffected by both).
	; hcall handles the ROM bank switch safely from ROMX: it saves/restores the
	; Debug Menu bank internally and reads [hl] with Wario Palettes bank active.
	ld a, [wWarioPalsPtr + 0]
	ld h, a
	ld a, [wWarioPalsPtr + 1]
	ld l, a
	ld de, wTempPals2
	ld b, 2 palettes
	ld a, BANK("Wario Palettes")
	ldh [hCallFuncBank], a
	hcall CopyHLToDE_Short

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

	; If a room reload is pending (e.g. golf win toggled), skip directly to
	; FastFadeToWhite (substate 5) so StartRoom_FromTransition fires immediately.
	; UpdateState_Idling doesn't check wRoomTransitionParam, so returning to
	; UpdateLevel (substate 3) would leave the transition param unprocessed.
	ld a, [wRoomTransitionParam]
	and a
	jr z, .no_pending_reload
	ld a, ST_LEVEL
	ld [wState], a
	ld a, 5    ; FastFadeToWhite → StartRoom_FromTransition
	ld [wSubState], a
	ret
.no_pending_reload:
	jp ReturnToPendingLevelState
