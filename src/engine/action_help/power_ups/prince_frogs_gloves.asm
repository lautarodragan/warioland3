PrinceFrogsGlovesActionHelp:
	call .StateTable
	ld a, [wActionHelpBlackedOut]
	and a
	jr nz, .done
	ld a, [wActionHelpFrozen]
	and a
	jr nz, .action_help_frozen
	ld hl, wActionHelpWarioFramesetPtr + 1
	farcall $05, UpdateObjAnim
.action_help_frozen
	ld hl, wActionHelpWario
	farcall LoadActionHelpWarioSprite
.done
	ret

.StateTable:
	ld a, [wActionHelpState]
	jumptable

	dw ActionHelp_Init
	dw PrinceFrogsGlovesActionHelp_WaitToStart
	dw PrinceFrogsGlovesActionHelp_Step02
	dw PrinceFrogsGlovesActionHelp_Step03
	dw PrinceFrogsGlovesActionHelp_Step04
	dw PrinceFrogsGlovesActionHelp_Step05
	dw PrinceFrogsGlovesActionHelp_Step06
	dw PrinceFrogsGlovesActionHelp_Step07
	dw PrinceFrogsGlovesActionHelp_Step08
	dw PrinceFrogsGlovesActionHelp_Step09
	dw ActionHelp_FlashBInput
	dw PrinceFrogsGlovesActionHelp_Step0B
	dw PrinceFrogsGlovesActionHelp_Step0C
	dw PrinceFrogsGlovesActionHelp_Step0D
	dw PrinceFrogsGlovesActionHelp_Step0E
	dw PrinceFrogsGlovesActionHelp_Step0F
	dw PrinceFrogsGlovesActionHelp_Step10
	dw PrinceFrogsGlovesActionHelp_Step11
	dw PrinceFrogsGlovesActionHelp_Step12

PrinceFrogsGlovesActionHelp_End:
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
	ld a, $01
	ld [wActionHelpState], a
	jr PrinceFrogsGlovesActionHelp_Start

PrinceFrogsGlovesActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
PrinceFrogsGlovesActionHelp_Start:
	ld a, BANK(WarioIdleGfx)
	ld [wPendingDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wPendingDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wPendingDMASourcePtr + 1], a
	ld a, HIGH(v0Tiles0)
	ld [wPendingDMADestinationPtr + 0], a
	ld a, LOW(v0Tiles0)
	ld [wPendingDMADestinationPtr + 1], a
	ld a, BANK("VRAM0")
	ld [wPendingDMADestinationBank], a
	ld a, $80 dma_tiles
	ld [wPendingDMALength], a
	ld a, TRUE
	ld [wIsDMATransferPending], a

	ld hl, wActionHelpWario
	ld a, $40
	ld [hli], a
	ld a, $18
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioFrameset_1425f)
	ld [hli], a
	ld a, LOW(WarioFrameset_1425f)
	ld [hli], a
	xor a
	ld [hl], a
	ld a, HIGH(WarioOAM_14000)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_14000)
	ld [wActionHelpWarioOAMPtr + 1], a

	ld a, 6
	ld [wAnimatedTilesFrameDuration], a
	ld a, ANIMATED_TILES_GFX_WATER
	ld [wAnimatedTilesGfx], a
	ld a, TRUE
	ld [wRoomAnimatedTilesEnabled], a
	ld a, $30
	ld [wTimer], a
	farcall LoadActionHelpPalsWithWater

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step02:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step03:
	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld a, [hl]
	cp $2c
	ret c

	call ActionHelp_ShowWarioJump
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step04:
	ld hl, wActionHelpWarioXCoord
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
	cp $50
	ret c

	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioSwim
	call ActionHelp_ClearDPadInput
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step05:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowDDownInput
	call ActionHelp_ShowWarioSubmerge

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step06:
	play_sfx_rept 37, SFX_SWIM

	ld a, [wActionHelpCounter]
	and %11
	ret nz
	ld hl, wActionHelpWarioYCoord
	inc [hl]
	ld a, [hl]
	cp $58
	ret c

	call ActionHelp_ShowDRightInput
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step07:
	play_sfx_rept 37, SFX_SWIM

	ld hl, wTimer
	ld a, [hl]
	and a
	jr z, .timer_expired
	dec [hl]
	ret

.timer_expired
	ld a, [wActionHelpCounter]
	and $01
	ret nz
	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld a, [hl]
	cp $6c
	ret c
	call ActionHelp_ShowDDownInput
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step08:
	play_sfx_rept 37, SFX_SWIM

	ld hl, wTimer
	ld a, [hl]
	and a
	jr z, .timer_expired
	dec [hl]
	ret
.timer_expired
	ld a, [wActionHelpCounter]
	and %11
	ret nz
	ld hl, wActionHelpWarioYCoord
	inc [hl]
	ld a, [hl]
	cp $60
	ret c

	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step09:
	play_sfx_rept 37, SFX_SWIM

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [hl]
	cp $50
	ret nc

	ld [hl], $50
	call ActionHelp_ShowWarioUnderwaterStopped

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step0B:
	play_sfx_rept 15, SFX_UNDERWATER_THRUST

	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $58
	jr c, .move_right
	ld a, [wActionHelpCounter]
	and $01
	ret nz
.move_right
	inc [hl]
	ld a, [hl]
	cp $6c
	ret c

	call ActionHelp_ShowWarioSubmerge
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step0C:
	play_sfx_rept 37, SFX_SWIM

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [hl]
	cp $34
	ret nc

	ld [hl], $34
	call ActionHelp_ShowWarioUnderwaterStopped
	call ActionHelp_ShowBInput

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step0D:
	play_sfx_rept 15, SFX_UNDERWATER_THRUST

	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $3c
	jr c, .move_right
	ld a, [wActionHelpCounter]
	and $01
	ret nz
.move_right
	inc [hl]
	ld a, [hl]
	cp $4c
	ret c

	call ActionHelp_ClearButtonsInput
	ld a, $0c
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step0E:
	play_sfx_rept 15, SFX_UNDERWATER_THRUST

	ld hl, wTimer
	ld a, [hl]
	and a
	jr z, .timer_expired
	dec [hl]
	ret nz
	call ActionHelp_ShowWarioUnderwaterStopped
	call ActionHelp_ShowBInput
.timer_expired
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $58
	jr c, .move_right
	ld a, [wActionHelpCounter]
	and $01
	ret nz
.move_right
	inc [hl]
	ld a, [hl]
	cp $6c
	ret c

	call ActionHelp_ShowWarioSubmerge
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step0F:
	play_sfx_rept 37, SFX_SWIM

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [hl]
	cp $34
	ret nc

	ld [hl], $34
	call ActionHelp_ShowDUpInput
	ld a, $10
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step10:
	play_sfx_rept 37, SFX_SWIM

	ld hl, wTimer
	ld a, [hl]
	and a
	jr z, .timer_expired
	dec [hl]
	ret
.timer_expired
	ld a, [wActionHelpCounter]
	and %11
	ret nz
	ld hl, wActionHelpWario
	dec [hl]
	ld a, [hl]
	cp $50
	ret nc

	call ActionHelp_ShowWarioSwimLeft
	call ActionHelp_ClearDPadInput
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step11:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioJumpLeft
	call ActionHelp_ShowDLeftInput
	call ActionHelp_ShowAInput
	xor a
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

PrinceFrogsGlovesActionHelp_Step12:
	ld hl, wActionHelpWarioXCoord
	ld a, [hl]
	cp $18
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
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c
	ld a, [wActionHelpWarioYCoord]
	cp $40
	ret c
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	xor a
	ld [wActionHelpWarioVar], a
	jp PrinceFrogsGlovesActionHelp_End
