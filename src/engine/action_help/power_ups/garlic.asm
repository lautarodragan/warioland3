GarlicActionHelp:
	call .StateTable

	ld a, [wActionHelpBlackedOut]
	and a
	jp nz, .done

	ld hl, wMenuObj5FramesetPtr + 1
	ld a, [wMenuObj5FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj5AnimationEnded], a
	ld hl, wMenuObj5YCoord
	farcall LoadActionHelpSprite_Far

	ld hl, wMenuObj7FramesetPtr + 1
	ld a, [wMenuObj7FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj7AnimationEnded], a
	ld hl, wMenuObj7
	farcall LoadActionHelpSprite_Far

	ld a, [wActionHelpFrozen]
	and a
	jr nz, .action_help_frozen

	ld hl, wMenuObj4FramesetPtr + 1
	ld a, [wMenuObj4FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj4AnimationEnded], a

	ld hl, wMenuObj6FramesetPtr + 1
	ld a, [wMenuObj6FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim

	ld hl, wActionHelpWarioFramesetPtr + 1
	farcall $05, UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wActionHelpWarioAnimationEnded], a

.action_help_frozen
	ld hl, wMenuObj4
	farcall LoadActionHelpSprite_Far
	ld hl, wMenuObj6
	farcall LoadActionHelpSprite_Far
	ld hl, wActionHelpWario
	farcall LoadActionHelpWarioSprite
.done
	ret

.StateTable:
	ld a, [wActionHelpState]
	jumptable

	dw ActionHelp_Init
	dw GarlicActionHelp_WaitToStart
	dw GarlicActionHelp_Step02
	dw ActionHelp_FlashBInput
	dw GarlicActionHelp_Step04
	dw GarlicActionHelp_Step05
	dw GarlicActionHelp_Step06
	dw GarlicActionHelp_Step07
	dw GarlicActionHelp_Step08
	dw GarlicActionHelp_Step09
	dw GarlicActionHelp_Step0A
	dw GarlicActionHelp_Step0B
	dw GarlicActionHelp_Step0C
	dw GarlicActionHelp_Step0D
	dw GarlicActionHelp_Step0E
	dw GarlicActionHelp_Step0F
	dw GarlicActionHelp_Step10
	dw GarlicActionHelp_Step11
	dw GarlicActionHelp_Step12
	dw GarlicActionHelp_Step13
	dw GarlicActionHelp_Step14
	dw GarlicActionHelp_Step15
	dw GarlicActionHelp_Step16
	dw ActionHelp_FlashDDownInput
	dw GarlicActionHelp_Step18
	dw GarlicActionHelp_Step19
	dw GarlicActionHelp_Step1A
	dw GarlicActionHelp_Step1B
	dw GarlicActionHelp_Step1C
	dw GarlicActionHelp_Step1D
	dw GarlicActionHelp_Step1E
	dw GarlicActionHelp_Step1F
	dw GarlicActionHelp_Step20
	dw GarlicActionHelp_Step21
	dw GarlicActionHelp_Step22
	dw GarlicActionHelp_Step23

GarlicActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_LEVEL_CLEAR_F, a
	jr nz, .asm_1f9cf5
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset

.asm_1f9cf5
	and POWER_UP_MASK
	ld [wPowerUpLevel], a
	farcall ReturnToOverworld
	call ResumeNormalVolume
	ret

.restart_action_help
	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	ld a, $1
	ld [wActionHelpState], a
	jr GarlicActionHelp_Start

GarlicActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
GarlicActionHelp_Start:
	call ActionHelp_ShowInitialWarioWalk
	call ActionHelp_ShowDRightInput

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
	ld a, HIGH(ActionHelpFrameset_1e6b9c)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b9c)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a
	xor a
	ld [hl], a

	call ActionHelp_HideObj5BlockDebris

	ld hl, wMenuObj6
	ld a, $40
	ld [hli], a
	ld a, $f8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6b9c)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b9c)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a

	ld hl, wMenuObj7
	call ActionHelp_HideBlockDebris

	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step02:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp_ShowWarioAttack
	ld a, $30
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step04:
	play_sfx_rept 6, SFX_ATTACK_POWERED_UP

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1f9dcd
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
.asm_1f9dcd
	ld a, [hl]
	cp $50
	ret nc
	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj7
	lb bc, $10, $00
	call ActionHelp_ShowBlockDebris
	ld a, [wMenuObj6XCoord]
	ld [wMenuObj4XCoord], a

	ld hl, wMenuObj6
	ld a, $40
	ld [hli], a
	ld a, $f8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6b96)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b96)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step05:
	play_sfx_rept 6, SFX_ATTACK_POWERED_UP

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1f9e2e
	dec [hl]
.asm_1f9e2e
	ld a, [hl]
	cp $50
	ret nc

	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj7
	lb bc, $10, $00
	call ActionHelp_ShowBlockDebris

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
	ld a, HIGH(ActionHelpFrameset_1e6b96)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b96)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step06:
	play_sfx_rept 6, SFX_ATTACK_POWERED_UP

	ld a, [wMenuObj5AnimationEnded]
	and a
	jr z, .asm_1f9e88
	call ActionHelp_HideObj5BlockDebris
	ld hl, wMenuObj7
	call ActionHelp_HideBlockDebris
.asm_1f9e88
	ld hl, wActionHelpWarioVar
	dec [hl]
	ret nz

	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step07:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp_ShowBInput
	call ActionHelp_ShowWarioAttack
	ld a, $30
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step08:
	play_sfx_rept 6, SFX_ATTACK_POWERED_UP

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1f9eed
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
.asm_1f9eed
	ld a, [hl]
	cp $50
	ret nc

	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj7
	lb bc, $10, $00
	call ActionHelp_ShowBlockDebris

	ld a, [wMenuObj6XCoord]
	ld [wMenuObj4XCoord], a
	ld hl, wMenuObj6
	ld a, $a0
	ld [hli], a
	ld a, $f8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6ba2)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6ba2)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a

	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioAttack
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step09:
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1f9f41
	dec [hl]
.asm_1f9f41
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
	ld hl, wMenuObj7
	call ActionHelp_HideBlockDebris
	call ActionHelp_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step0A:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step0B:
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

GarlicActionHelp_Step0C:
	play_sfx_rept 6, SFX_ATTACK_POWERED_UP

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1f9fcc
	ld hl, wMenuObj4XCoord
	dec [hl]
.asm_1f9fcc
	ld a, [hl]
	cp $50
	ret nc

	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj7
	lb bc, $10, $00
	call ActionHelp_ShowBlockDebris
	call ActionHelp_ShowCountRichtertoffIdle
	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioAttack
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step0D:
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa000
	dec [hl]
.asm_1fa000
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
	ld hl, wMenuObj7
	call ActionHelp_HideBlockDebris
	call ActionHelp_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step0E:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step0F:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1fa052
	inc [hl]
	ld a, [hl]
	cp $40
	ret c
.asm_1fa052
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa05e
	dec [hl]
.asm_1fa05e
	ld a, [hl]
	cp $58
	ret nc

	call ActionHelp_ShowBInput
	call ActionHelp_ShowWarioAttack
	ld a, $30
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step10:
	play_sfx_rept 6, SFX_ATTACK_POWERED_UP

	ld hl, wActionHelpWarioVar
	dec [hl]
	ld a, [hl]
	cp $2b
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa0a0
	ld hl, wMenuObj4XCoord
	dec [hl]
.asm_1fa0a0
	ld a, [hl]
	cp $50
	ret nc

	play_sfx SFX_ATTACK_HIT
	call ActionHelp_ShowCountRichtertoffStun
	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioAttack
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step11:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .asm_1fa0ce
	ld a, $27
	ld [hl], a
.asm_1fa0ce
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioVar]
	cp $18
	jr nc, .asm_1fa0fc
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	ld hl, wMenuObj4XCoord
	inc [hl]
	inc [hl]
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa0fb
	dec [hl]
.asm_1fa0fb
	ret

.asm_1fa0fc
	ld a, [wActionHelpWarioYCoord]
	cp $40
	jr z, .asm_1fa122
	add [hl]
	ld [wActionHelpWarioYCoord], a
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	ld hl, wMenuObj4XCoord
	inc [hl]
	inc [hl]
	ld a, [wActionHelpWarioYCoord]
	cp $40
	ret c
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ShowWarioIdle
	ret

.asm_1fa122
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	ld hl, wMenuObj4XCoord
	inc [hl]
	inc [hl]
	ld a, [wMenuObj4YCoord]
	cp $80
	ret c

	call ActionHelp_ShowSlide
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step12:
	ld hl, wTimer
	dec [hl]
	ret nz
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step13:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1fa162
	inc [hl]
	ld a, [hl]
	cp $40
	ret c
.asm_1fa162
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa16e
	dec [hl]
.asm_1fa16e
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step14:
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
	and $01
	jr z, .asm_1fa19c
	dec [hl]
.asm_1fa19c
	ld a, [wActionHelpWarioXCoord]
	cp [hl]
	ret c

	ld a, [hl]
	ld [wActionHelpWarioXCoord], a
	call ActionHelp_ClearDPadInput
	ld hl, wActionHelpWario
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

GarlicActionHelp_Step15:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step16:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $39
	ret nc
	cp $30
	jr c, .asm_1fa1e6
	ld hl, wActionHelpWario
	inc [hl]
	ret

.asm_1fa1e6
	call ActionHelp_ShowWarioSlide

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step18:
	ld hl, wActionHelpWario
	ld a, [hl]
	cp $40
	jr nc, .asm_1fa1f7
	inc [hl]
.asm_1fa1f7
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

GarlicActionHelp_Step19:
	ld hl, wActionHelpWario
	ld a, [hl]
	cp $40
	jr nc, .asm_1fa213
	inc [hl]
.asm_1fa213
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $d8
	ret nz

	call ActionHelp_ShowCountRichtertoffIdle

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step1A:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa22f
	dec [hl]
.asm_1fa22f
	ld a, [hl]
	cp $50
	ret nc

	play_sfx SFX_BUMP
	call ActionHelp_ShowCountRichtertoffStun
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step1B:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .asm_1fa254
	ld a, $27
	ld [hl], a
.asm_1fa254
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	ld hl, wMenuObj4XCoord
	inc [hl]
	inc [hl]
	ld a, [wMenuObj4YCoord]
	cp $80
	ret c

	ld hl, wMenuObj4
	ld a, $40
	ld [hli], a
	ld a, $d8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6b64)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b64)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, $40
	ld [wMenuObj6], a
	xor a
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step1C:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa2af
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
.asm_1fa2af
	ld a, [hl]
	and $fe
	cp $48
	jr z, .asm_1fa2b7
	ret

.asm_1fa2b7
	ld [hl], $48
	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj6
	ld de, wMenuObj4YCoord
	ld b, $0b
	call CopyHLToDE
	ld hl, wMenuObj6
	call ActionHelp_HideBlockDebris

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step1D:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa2e0
	dec [hl]
.asm_1fa2e0
	ld a, [hl]
	and $fe
	cp $58
	jr z, .asm_1fa2ec
	cp $48
	jr z, .asm_1fa2f7
	ret

.asm_1fa2ec
	ld [hl], $58
	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	call ActionHelp_ShowSingleSolidBlock
	ret

.asm_1fa2f7
	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj4
	ld a, $50
	ld [hli], a
	ld a, $e8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6b85)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b85)
	ld [hli], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step1E:
	ld a, [wMenuObj5AnimationEnded]
	and a
	jr z, .asm_1fa31e
	call ActionHelp_HideObj5BlockDebris
.asm_1fa31e
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa32a
	dec [hl]
.asm_1fa32a
	ld a, [hl]
	cp $50
	ret nc
	call ActionHelp_ShowWarioBump
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step1F:
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
	and $01
	jr z, .asm_1fa35a
	dec [hl]
.asm_1fa35a
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

GarlicActionHelp_Step20:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step21:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1fa396
	inc [hl]
	ld a, [hl]
.asm_1fa396
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

GarlicActionHelp_Step22:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1fa3b4
	inc [hl]
.asm_1fa3b4
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
	jr nc, .asm_1fa3d0
	ld hl, wMenuObj4XCoord
	dec [hl]
	ret

.asm_1fa3d0
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GarlicActionHelp_Step23:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $e8
	ret c
	jp GarlicActionHelp_End
