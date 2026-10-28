HighJumpBootsActionHelp:
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
	ld a, [wObjAnimWasReset]
	ld [wActionHelpWarioAnimationEnded], a

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
	dw HighJumpBootsActionHelp_WaitToStart
	dw HighJumpBootsActionHelp_Step02
	dw ActionHelp_FlashDUpInput
	dw HighJumpBootsActionHelp_Step04
	dw HighJumpBootsActionHelp_Step05
	dw HighJumpBootsActionHelp_Step06
	dw HighJumpBootsActionHelp_Step07
	dw HighJumpBootsActionHelp_Step08
	dw HighJumpBootsActionHelp_Step09
	dw HighJumpBootsActionHelp_Step0A
	dw HighJumpBootsActionHelp_Step0B
	dw HighJumpBootsActionHelp_Step0C
	dw HighJumpBootsActionHelp_Step0D
	dw HighJumpBootsActionHelp_Step0E
	dw HighJumpBootsActionHelp_Step0F
	dw HighJumpBootsActionHelp_Step10
	dw HighJumpBootsActionHelp_Step11
	dw HighJumpBootsActionHelp_Step12
	dw HighJumpBootsActionHelp_Step13
	dw HighJumpBootsActionHelp_Step14
	dw HighJumpBootsActionHelp_Step15
	dw HighJumpBootsActionHelp_Step16
	dw HighJumpBootsActionHelp_Step17
	dw HighJumpBootsActionHelp_Step18

HighJumpBootsActionHelp_End:
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
	jr HighJumpBootsActionHelp_Start

HighJumpBootsActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
HighJumpBootsActionHelp_Start:
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
	ld a, HIGH(ActionHelpFrameset_1e6b99)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b99)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a

	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step02:
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld a, [hl]
	cp $58
	ret nc

	call ActionHelp_ShowWarioIdle

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step04:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $30
	ret c

	ld [hl], $00
	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step05:
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_HighJump
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c

	call ActionHelp_ClearButtonsInput
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step06:
	ld hl, wMenuObj5XCoord
	dec [hl]
	dec [hl]
	ld hl, wActionHelpWarioVar
	ld a, [hl]
	inc [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_HighJump
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $10
	ret c

	ld a, $10
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step07:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowWarioJump
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step08:
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .got_vel_index
	ld [hl], $27
	ld a, [hl]
.got_vel_index
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_HighJump
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $40
	ret c

	ld a, $40
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step09:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $68
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step0A:
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
	ld a, [wActionHelpWarioYCoord]
	cp $34
	ret c

	call ActionHelp_ShowDLeftInput
	call ActionHelp_ShowParaGoomStun
	call ActionHelp_ShowWarioJumpLeft
	xor a
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step0B:
	ld hl, wMenuObj5XCoord
	ld a, [hl]
	cp $3c
	jr nc, .skip_inc
	inc [hl]
	ld hl, wMenuObj4XCoord
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
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c

	call ActionHelp_ClearButtonsInput
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step0C:
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
	cp $10
	ret c

	ld a, $10
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step0D:
	call ActionHelp_ClearDPadInput
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowAInput
	call ActionHelp_ShowDRightAndDDownInput
	call ActionHelp_ShowWarioJump
	call ActionHelp_ShowWarioSmashAttack
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step0E:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .got_vel_index
	ld [hl], $27
	ld a, [hl]
.got_vel_index
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $34
	ret c

	ld a, $30
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ShowDLeftInput
	call ActionHelp_ShowObj4EnemyVanish
	call ActionHelp_ShowWarioJumpLeft
	xor a
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step0F:
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld hl, wMenuObj5XCoord
	inc [hl]
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

	call ActionHelp_ClearButtonsInput
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step10:
	ld hl, wMenuObj4XCoord
	inc [hl]
	inc [hl]
	ld hl, wMenuObj5XCoord
	inc [hl]
	inc [hl]
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
	cp $10
	ret c

	ld a, $10
	ld [wActionHelpWarioYCoord], a
	ld a, $0e
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step11:
	ld a, [wMenuObj4AnimationEnded]
	and a
	jr z, .update_jump
	ld hl, wMenuObj4
	call ActionHelp_HideBlockDebris
.update_jump
	ld hl, wMenuObj5XCoord
	inc [hl]
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .got_vel_index
	ld [hl], $27
	ld a, [hl]
.got_vel_index
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
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step12:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step13:
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
	jr z, .at_apex
	ret c
	ld a, [wActionHelpWarioYCoord]
	cp $40
	ret c
	call ActionHelp_ShowAInput
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioLand

	ld hl, wActionHelpState
	inc [hl]
	ret

.at_apex
	call ActionHelp_ClearButtonsInput
	ret

HighJumpBootsActionHelp_Step14:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z

	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step15:
	ld hl, wMenuObj5XCoord
	dec [hl]
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_HighJump
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c

	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step16:
	ld hl, wMenuObj5XCoord
	dec [hl]
	dec [hl]
	ld hl, wActionHelpWarioVar
	ld a, [hl]
	inc [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_HighJump
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $10
	ret c

	ld a, $10
	ld [wActionHelpWarioYCoord], a
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowWarioIdle
	xor a
	ld [wActionHelpWarioVar], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step17:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowAInput
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

HighJumpBootsActionHelp_Step18:
	ld hl, wMenuObj5XCoord
	dec [hl]
	dec [hl]
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	cp $28
	jr c, .got_vel_index
	ld [hl], $27
	ld a, [hl]
.got_vel_index
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	add $20
	cp $60
	ret c
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	jp HighJumpBootsActionHelp_End
