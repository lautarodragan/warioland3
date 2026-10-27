SuperJumpSlamOverallsActionHelp:
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
	ld hl, wMenuObj5
	farcall LoadActionHelpSprite_Far
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
	dw SuperJumpSlamOverallsActionHelp_WaitToStart
	dw SuperJumpSlamOverallsActionHelp_Step02
	dw SuperJumpSlamOverallsActionHelp_Step03
	dw ActionHelp_FlashDDownInput
	dw SuperJumpSlamOverallsActionHelp_Step05
	dw SuperJumpSlamOverallsActionHelp_Step06
	dw SuperJumpSlamOverallsActionHelp_Step07
	dw SuperJumpSlamOverallsActionHelp_Step08
	dw SuperJumpSlamOverallsActionHelp_Step09
	dw SuperJumpSlamOverallsActionHelp_Step0A
	dw SuperJumpSlamOverallsActionHelp_Step0B
	dw SuperJumpSlamOverallsActionHelp_Step0C
	dw SuperJumpSlamOverallsActionHelp_Step0D
	dw SuperJumpSlamOverallsActionHelp_Step0E
	dw SuperJumpSlamOverallsActionHelp_Step0F
	dw SuperJumpSlamOverallsActionHelp_Step10
	dw SuperJumpSlamOverallsActionHelp_Step11
	dw SuperJumpSlamOverallsActionHelp_Step12
	dw SuperJumpSlamOverallsActionHelp_Step13

SuperJumpSlamOverallsActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_LEVEL_CLEAR_F, a
	jr nz, .asm_1fa4c0
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset
.asm_1fa4c0
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
	jr SuperJumpSlamOverallsActionHelp_Start

SuperJumpSlamOverallsActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
SuperJumpSlamOverallsActionHelp_Start:
	call ActionHelp_ShowInitialWarioWalk
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowParaGoomWalk

	ld hl, wMenuObj5
	ld a, $40
	ld [hli], a
	ld a, $e8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6f4d)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6f4d)
	ld [hli], a
	ld a, HIGH(OAM_1e6bab)
	ld [hli], a
	ld a, LOW(OAM_1e6bab)
	ld [hli], a
	ld a, BANK(OAM_1e6bab)
	ld [hli], a
	xor a
	ld [hl], a

	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step02:
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld a, [hl]
	cp $90
	ret nc
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa53a
	dec [hl]
.asm_1fa53a
	ld a, [hl]
	cp $a0
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step03:
	ld hl, wMenuObj4XCoord
	dec [hl]
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
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step05:
	ld hl, wMenuObj4XCoord
	dec [hl]
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
	call ActionHelp_ShowWarioGroundShake
	call ActionHelp_ShowParaGoomStun
	ld a, $0a
	ld [wActionHelpWarioVar], a
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step06:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wMenuObj4YCoord]
	add [hl]
	ld [wMenuObj4YCoord], a
	cp $40
	jr nc, .asm_1fa5c1
	jr .asm_1fa5cb
.asm_1fa5c1
	ld a, $26
	ld [wActionHelpWarioVar], a
	ld a, $40
	ld [wMenuObj4YCoord], a
.asm_1fa5cb
	ld hl, wTimer
	dec [hl]
	jr z, .asm_1fa5f3
	ld a, [hl]
	cp $05
	jr nz, .asm_1fa5dc
	call ActionHelp_ShowWarioIdle
	call ActionHelp_ClearDPadInput
.asm_1fa5dc
	ld hl, wSCY
	ld a, [wTimer]
	and $03
	cp $03
	jr z, .asm_1fa5ed
	cp $01
	jr z, .asm_1fa5f0
	ret

.asm_1fa5ed
	inc [hl]
	inc [hl]
	ret

.asm_1fa5f0
	dec [hl]
	dec [hl]
	ret

.asm_1fa5f3
	call ActionHelp_ShowWarioJump
	call ActionHelp_ShowAInput
	xor a
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step07:
	ld a, [wMenuObj5XCoord]
	cp $40
	jr z, .asm_1fa624
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld a, [hl]
	cp $40
	jr nz, .asm_1fa624
	call ActionHelp_ClearButtonsInput
	call ActionHelp_ShowDDownInput
	call ActionHelp_ShowWarioSmashAttack
	ld a, $18
	ld [wActionHelpWarioVar], a
.asm_1fa624
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
	ld a, [wActionHelpWarioYCoord]
	cp $30
	ret c

	ld a, $0a
	ld [wActionHelpWarioVar], a
	ld hl, wMenuObj5FramesetOffset
	call ActionHelp_ShowEnemyVanish

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step08:
	ld hl, wMenuObj4XCoord
	ld a, [hl]
	cp $40
	jr z, .asm_1fa666
	dec [hl]
	ld a, [hl]
	cp $40
	jr nz, .asm_1fa666
	ld a, $18
	ld [wActionHelpWarioVar], a
.asm_1fa666
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
	ld a, [wActionHelpWarioYCoord]
	cp $34
	ret c

	ld a, $0a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ClearDPadInput
	call ActionHelp_HideObj5BlockDebris
	call ActionHelp_ShowObj4EnemyVanish

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step09:
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
	call ActionHelp_ShowWarioIdle

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step0A:
	ld a, [wMenuObj4AnimationEnded]
	and a
	ret z

	call ActionHelp_ShowVerticalBlockPair
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step0B:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and $01
	jr z, .asm_1fa6de
	dec [hl]
.asm_1fa6de
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step0C:
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
	jr z, .asm_1fa70c
	dec [hl]
.asm_1fa70c
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

SuperJumpSlamOverallsActionHelp_Step0D:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step0E:
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

SuperJumpSlamOverallsActionHelp_Step0F:
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
	call ActionHelp_ShowSingleSolidBlock
	ld b, $10
	call ActionHelp_ShowBlockDebrisWithYOffset

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step10:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .asm_1fa7a2
	ld [hl], $27
	ld a, [hl]
.asm_1fa7a2
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
	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld hl, wMenuObj4
	call ActionHelp_HideBlockDebris
	call ActionHelp_ShowWarioGroundShake
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step11:
	ld a, [wMenuObj5AnimationEnded]
	and a
	jr z, .asm_1fa7d9
	call ActionHelp_HideObj5BlockDebris
.asm_1fa7d9
	ld hl, wTimer
	dec [hl]
	jr z, .asm_1fa801
	ld a, [hl]
	cp $05
	jr nz, .asm_1fa7ea
	call ActionHelp_ShowWarioJump
	call ActionHelp_ClearDPadInput
.asm_1fa7ea
	ld hl, wSCY
	ld a, [wTimer]
	and $03
	cp $03
	jr z, .asm_1fa7fb
	cp $01
	jr z, .asm_1fa7fe
	ret
.asm_1fa7fb
	inc [hl]
	inc [hl]
	ret
.asm_1fa7fe
	dec [hl]
	dec [hl]
	ret
.asm_1fa801
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step12:
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
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperJumpSlamOverallsActionHelp_Step13:
	ld hl, wTimer
	dec [hl]
	ret nz
	jp SuperJumpSlamOverallsActionHelp_End
