LeadOverallsActionHelp:
	call .StateTable

	ld a, [wActionHelpBlackedOut]
	and a
	jp nz, .done
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

	ld hl, wActionHelpWarioFramesetPtr + 1
	farcall $5, UpdateObjAnim

.action_help_frozen
	ld hl, wMenuObj4
	farcall LoadActionHelpSprite_Far

	ld hl, wActionHelpWario
	farcall LoadActionHelpWarioSprite

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

.done
	ret

.StateTable:
	ld a, [wActionHelpState]
	jumptable

	dw ActionHelp_Init
	dw LeadOverallsActionHelp_WaitToStart
	dw LeadOverallsActionHelp_Step02
	dw LeadOverallsActionHelp_Step03
	dw ActionHelp_FlashDDownInput
	dw LeadOverallsActionHelp_Step05
	dw LeadOverallsActionHelp_Step06
	dw LeadOverallsActionHelp_Step07
	dw LeadOverallsActionHelp_Step08
	dw LeadOverallsActionHelp_Step09
	dw LeadOverallsActionHelp_Step0A
	dw LeadOverallsActionHelp_Step0B
	dw LeadOverallsActionHelp_Step0C
	dw LeadOverallsActionHelp_Step0D
	dw LeadOverallsActionHelp_Step0E
	dw LeadOverallsActionHelp_Step0F
	dw LeadOverallsActionHelp_Step10
	dw LeadOverallsActionHelp_Step11
	dw LeadOverallsActionHelp_Step12
	dw LeadOverallsActionHelp_Step13
	dw LeadOverallsActionHelp_Step14
	dw LeadOverallsActionHelp_Step15
	dw LeadOverallsActionHelp_Step16
	dw LeadOverallsActionHelp_Step17
	dw LeadOverallsActionHelp_Step18
	dw LeadOverallsActionHelp_Step19
	dw LeadOverallsActionHelp_Step1A
	dw LeadOverallsActionHelp_Step1B
	dw LeadOverallsActionHelp_Step1C
	dw LeadOverallsActionHelp_Step1D
	dw LeadOverallsActionHelp_Step1E

LeadOverallsActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_LEVEL_CLEAR_F, a
	jr nz, .return_to_overworld
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset

.return_to_overworld
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
	jr LeadOverallsActionHelp_Start

LeadOverallsActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
LeadOverallsActionHelp_Start:
	call ActionHelp_ShowInitialWarioWalk
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowParaGoomWalk
	call ActionHelp_HideObj5BlockDebris
	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step02:
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

LeadOverallsActionHelp_Step03:
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
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [wActionHelpWarioXCoord]
	cp [hl]
	ret c

	call ActionHelp_ShowWarioSmashAttack
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step05:
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
	cp $34
	ret c
	ld a, $34
	ld [wActionHelpWarioYCoord], a
	ld a, $0a
	ld [wActionHelpWarioVar], a

	call ActionHelp_ShowObj4EnemyVanish

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step06:
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
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	xor a
	ld [wActionHelpWarioVar], a

	call ActionHelp_ShowWarioGroundPound

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step07:
	ld a, [wMenuObj4AnimationEnded]
	and a
	ret z

	call ActionHelp_ShowVerticalBlockPair
	call ActionHelp_ShowWarioIdle
	call ActionHelp_ClearDPadInput
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step08:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step09:
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

LeadOverallsActionHelp_Step0A:
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
	jr z, .skip_dec
	dec [hl]
.skip_dec
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

LeadOverallsActionHelp_Step0B:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step0C:
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
	cp $0c
	ret nc

	ld a, $18
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioSmashAttack
	call ActionHelp_ShowDDownInput
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step0D:
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
	cp $20
	ret c
	ld a, $20
	ld [wActionHelpWarioYCoord], a

	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioGroundPound
	call ActionHelp_ShowSingleSolidBlock
	ld b, $10
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step0E:
	ld hl, wTimer
	dec [hl]
	ret nz

	ld a, $18
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioSmashAttack
	call ActionHelp_HideObj5BlockDebris

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step0F:
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
	cp $30
	ret c
	ld a, $30
	ld [wActionHelpWarioYCoord], a

	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioGroundPound
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step10:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioIdle
	call ActionHelp_ClearDPadInput
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step11:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step12:
	ld hl, wActionHelpWarioVar
	ld a, [hl]
	cp $27
	jr z, .skip_inc
	inc [hl]
.skip_inc
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
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [wActionHelpWarioYCoord]
	cp $40
	ret c
	ld a, $40
	ld [wActionHelpWarioYCoord], a

	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	; Futamogu sprite
	ld hl, wMenuObj4
	ld a, $50
	ld [hli], a
	ld a, $c0
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6f66)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6f66)
	ld [hli], a
	ld a, HIGH(ActionHelpEnemyOAM_1e6bab)
	ld [hli], a
	ld a, LOW(ActionHelpEnemyOAM_1e6bab)
	ld [hli], a
	ld a, BANK(ActionHelpEnemyOAM_1e6bab)
	ld [hli], a
	xor a
	ld [hl], a

	ld hl, wMenuObj5
	ld a, $40
	ld [hli], a
	ld a, $b8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6b8b)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b8b)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a
	xor a
	ld [hl], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step13:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	add -$8
	ld [wMenuObj5XCoord], a
	cp $40
	ret nc

	call ActionHelp_ShowWarioIdle
	call ActionHelp_ShowFutamoguAngry
	call ActionHelp_ClearDPadInput
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step14:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump
	call ActionHelp_ShowFutamoguHappy

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step15:
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
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c

	call ActionHelp_ShowWarioSmashAttack
	call ActionHelp_ShowDDownInput
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step16:
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
	ld a, $40
	ld [wActionHelpWarioYCoord], a

	call ActionHelp_ShowWarioGroundPound

	; show Futamogu dropping
	ld a, [wMenuObj4YCoord]
	add $04
	ld [wMenuObj4YCoord], a
	ld hl, wMenuObj4FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6f7d)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6f7d)
	ld [hli], a
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step17:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioSmashAttack

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step18:
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
	cp $44
	ret c
	ld a, $44
	ld [wActionHelpWarioYCoord], a

	call ActionHelp_ShowWarioGroundPound

	ld a, [wMenuObj4YCoord]
	add $4
	ld [wMenuObj4YCoord], a
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step19:
	ld hl, wTimer
	dec [hl]
	ret nz

	ld a, $18
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioIdle
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step1A:
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
	cp $48
	ret c
	ld a, $48
	ld [wActionHelpWarioYCoord], a
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step1B:
	ld hl, wTimer
	dec [hl]
	ret nz

	; show Futamogu climbing
	ld hl, wMenuObj4FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6f6b)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6f6b)

	ld [hli], a
	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step1C:
	ld hl, wMenuObj4YCoord
	dec [hl]
	ld hl, wActionHelpWarioYCoord
	dec [hl]
	ld a, [hl]
	cp $40
	ret nz

	call ActionHelp_ShowWarioIdle
	call ActionHelp_ShowFutamoguAngry
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step1D:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowFutamoguHappy

	ld hl, wActionHelpState
	inc [hl]
	ret

LeadOverallsActionHelp_Step1E:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	add -$8
	ld [wMenuObj5XCoord], a
	cp $f0
	ret c
	jp LeadOverallsActionHelp_End
