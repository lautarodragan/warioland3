NoPowerUpActionHelp:
	call .StateTable

	ld a, [wActionHelpBlackedOut]
	and a
	jp nz, .done
	ld a, [wActionHelpFrozen]
	and a
	jr nz, .action_help_frozen

	ld hl, wMenuObj5FramesetPtr + 1
	ld a, [wMenuObj5FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj5AnimationEnded], a
	ld hl, wMenuObj5
	farcall LoadActionHelpSprite_Far

	ld hl, wMenuObj4FramesetPtr + 1
	ld a, [wMenuObj4FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj4AnimationEnded], a

	ld hl, wActionHelpWarioFramesetPtr + 1
	farcall $05, UpdateObjAnim

.action_help_frozen
	ld hl, wMenuObj4
	farcall LoadActionHelpSprite_Far
	ld hl, wActionHelpWario
	farcall LoadActionHelpWarioSprite
.done
	ret

.StateTable:
	ld a, [wActionHelpState]
	jumptable

	dw ActionHelp_Init
	dw NoPowerUpActionHelp_WaitToStart
	dw NoPowerUpActionHelp_Step02
	dw NoPowerUpActionHelp_Step03
	dw NoPowerUpActionHelp_Step04
	dw NoPowerUpActionHelp_Step05
	dw ActionHelp_FlashBInput
	dw NoPowerUpActionHelp_Step07
	dw NoPowerUpActionHelp_Step08
	dw NoPowerUpActionHelp_Step09
	dw NoPowerUpActionHelp_Step0A
	dw NoPowerUpActionHelp_Step0B
	dw NoPowerUpActionHelp_Step0C
	dw NoPowerUpActionHelp_Step0D
	dw NoPowerUpActionHelp_Step0E
	dw NoPowerUpActionHelp_Step0F
	dw NoPowerUpActionHelp_Step10
	dw NoPowerUpActionHelp_Step11
	dw NoPowerUpActionHelp_Step12
	dw NoPowerUpActionHelp_Step13
	dw NoPowerUpActionHelp_Step14
	dw NoPowerUpActionHelp_Step15
	dw NoPowerUpActionHelp_Step16
	dw NoPowerUpActionHelp_Step17
	dw ActionHelp_FlashDDownInput
	dw NoPowerUpActionHelp_Step19
	dw NoPowerUpActionHelp_Step1A
	dw NoPowerUpActionHelp_Step1B
	dw NoPowerUpActionHelp_Step1C
	dw NoPowerUpActionHelp_Step1D
	dw NoPowerUpActionHelp_Step1E
	dw NoPowerUpActionHelp_Step1F
	dw NoPowerUpActionHelp_Step20

NoPowerUpActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_LEVEL_CLEAR_F, a
	jr nz, .asm_1f8370
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset

.asm_1f8370
	and POWER_UP_MASK
	ld [wPowerUpLevel], a
	farcall Func_4628
	call ResumeNormalVolume
	ret

.restart_action_help
	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	ld a, $1
	ld [wActionHelpState], a
	jr NoPowerUpActionHelp_Start

NoPowerUpActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
NoPowerUpActionHelp_Start:
	call ActionHelp_ShowInitialWarioWalk
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowParaGoomWalk
	call ActionHelp_HideObj5BlockDebris
	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step02:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step03:
	ld hl, wActionHelpWarioVar
	inc [hl]

	; set jumping y coordinate
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a

	ld a, [wActionHelpWarioVar]
	cp $18
	jr c, .move_paragoom
	ld a, [wActionHelpWarioYCoord]
	cp $34
	jr c, .move_paragoom
	jr .step_on_paragoom
.move_paragoom
	; don't move Para-Goom if it's already at Wario's x pos
	ld hl, wMenuObj4XCoord
	ld a, [wActionHelpWarioXCoord]
	cp [hl]
	ret z
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [wActionHelpWarioXCoord]
	cp [hl]
	ret c
	ld a, [wActionHelpWarioXCoord]
	ld [hl], a
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ClearDPadInput
	ret

.step_on_paragoom
	play_sfx SFX_014
	ld a, $0a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowParaGoomStun

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step04:
	ld hl, wActionHelpWarioVar
	inc [hl]

	; set jumping y coordinate
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	cp $40
	jr nc, .land_wario

	ld hl, wMenuObj4XCoord
	inc [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_inc
	inc [hl]
.skip_inc
	ret

.land_wario
	ld a, $40
	ld [wMenuObj4YCoord], a
	ld a, [wActionHelpWarioYCoord]
	cp $40
	ret c
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step05:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioAttack
	ld a, $30
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step07:
	play_sfx_rept 6, SFX_ATTACK

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $4c
	ret nc

	play_sfx SFX_017
	call ActionHelp_ClearButtonsInput
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step08:
	ld hl, wMenuObj4XCoord
	inc [hl]
	inc [hl]

	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .asm_1f84e8
	ld a, $27
	ld [hl], a
.asm_1f84e8
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	cp $80
	ret c

	; load cracked and solid blocks
	ld hl, wMenuObj4
	ld a, $40
	ld [hli], a
	ld a, $e8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6ba5)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6ba5)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a

	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step09:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $78
	ret nc

	call ActionHelp_ShowBInput
	call ActionHelp_ShowWarioAttack
	ld a, $30
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step0A:
	play_sfx_rept 6, SFX_ATTACK

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $60
	ret nc

	ld hl, wMenuObj5
	lb bc, $0, $10
	call ActionHelp_ShowBlockDebris
	call ActionHelp_ShowSingleSolidBlock
	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioAttack
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step0B:
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $40
	ret c

	xor a
	ld [wActionHelpWarioVar], a
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_HideObj5BlockDebris
	call ActionHelp_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step0C:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step0D:
	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld a, [hl]
	cp $40
	ret c

	call ActionHelp_ShowBInput
	call ActionHelp_ShowWarioAttack
	ld a, $30
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step0E:
	play_sfx_rept 6, SFX_ATTACK

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec_x
	ld hl, wMenuObj4XCoord
	dec [hl]
.skip_dec_x
	ld a, [hl]
	cp $50
	ret nc

	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioAttack

	play_sfx SFX_BUMP
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step0F:
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $40
	ret c

	xor a
	ld [wActionHelpWarioVar], a
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_HideObj5BlockDebris
	call ActionHelp_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step10:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step11:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1f8690
	inc [hl]
	ld a, [hl]
	cp $40
	ret c
.asm_1f8690
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $58
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	sub $40
	cp $1c
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step12:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1f86be
	inc [hl]
.asm_1f86be
	ld hl, wActionHelpWarioEnd
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $40
	jr nc, .asm_1f86da
	ld hl, wMenuObj4XCoord
	dec [hl]
	ret

.asm_1f86da
	xor a
	ld [wActionHelpWarioEnd], a
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step13:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $e8
	ret c

	call ActionHelp_ShowSlide
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step14:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1f8715
	inc [hl]
	ld a, [hl]
	cp $40
	ret c
.asm_1f8715
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .asm_1f8721
	dec [hl]
.asm_1f8721
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step15:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a

	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dex
	dec [hl]
.skip_dex
	ld a, [wActionHelpWarioXCoord]
	cp [hl]
	ret c

	ld a, [hl]
	ld [wActionHelpWarioXCoord], a
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpWarioYCoord
	ld a, [hl]
	cp $20
	ret c
	ld [hl], $20
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioIdle
	call ActionHelp_ClearButtonsInput
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step16:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step17:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $39
	ret nc
	cp $30
	jr c, .slide
	ld hl, wActionHelpWarioYCoord
	inc [hl]
	ret
.slide
	call ActionHelp_ShowWarioSlide

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step19:
	ld hl, wActionHelpWarioYCoord
	ld a, [hl]
	cp $40
	jr nc, .skip_inc
	inc [hl]
.skip_inc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $18
	ret nc

	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowWarioRoll

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step1A:
	ld hl, wActionHelpWarioYCoord
	ld a, [hl]
	cp $40
	jr nc, .skip_inc
	inc [hl]
.skip_inc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $d8
	ret nz
	call ActionHelp_ShowSingleSolidBlock

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step1B:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $50
	ret nc

	call ActionHelp_ShowWarioBump
	play_sfx SFX_BUMP ; unnecessary
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step1C:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c
	ld a, [wActionHelpWarioYCoord]
	cp $40
	ret c

	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step1D:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step1E:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1f8856
	inc [hl]
	ld a, [hl]
.asm_1f8856
	ld b, a
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	sub b
	cp $1c
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step1F:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .skip_inc
	inc [hl]
.skip_inc
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $40
	jr nc, .asm_1f8890
	ld hl, wMenuObj4XCoord
	dec [hl]
	ret

.asm_1f8890
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $40
	ld [wActionHelpWarioYCoord], a

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

NoPowerUpActionHelp_Step20:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $e8
	ret c
	jp NoPowerUpActionHelp_End
