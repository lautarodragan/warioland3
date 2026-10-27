RailActionHelp:
	call .StateTable

	ld a, [wActionHelpBlackedOut]
	and a
	jr nz, .done
	ld a, [wActionHelpFrozen]
	and a
	jr nz, .action_help_frozen

	ld hl, wMenuObj4FramesetPtr + 1
	ld a, [wMenuObj4FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld hl, wActionHelpWarioFramesetPtr + 1
	ld a, [wActionHelpWarioOAMBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wActionHelpWarioAnimationEnded], a

.action_help_frozen
	ld hl, wActionHelpWario
	call LoadActionHelpWarioSprite_FromBank
	ld hl, wMenuObj4
	call LoadActionHelpSprite_Far
.done
	ret

.StateTable:
	ld a, [wActionHelpState]
	jumptable

	dw ActionHelp2_Init
	dw RailActionHelp_WaitToStart
	dw RailActionHelp_Step02
	dw RailActionHelp_Step03
	dw ActionHelp2_FlashBInput
	dw RailActionHelp_Step05
	dw RailActionHelp_Step06
	dw RailActionHelp_Step07
	dw RailActionHelp_Step08
	dw RailActionHelp_Step09
	dw RailActionHelp_Step0A
	dw RailActionHelp_Step0B
	dw ActionHelp2_FlashAInput
	dw RailActionHelp_Step0D
	dw RailActionHelp_Step0E
	dw RailActionHelp_Step0F
	dw RailActionHelp_Step10
	dw RailActionHelp_Step11

RailActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset

.restart_action_help
	call ActionHelp2_ClearDPadInput
	call ActionHelp2_ClearButtonsInput
	ld a, $1
	ld [wActionHelpState], a
	jr RailActionHelp_Start

RailActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
RailActionHelp_Start:
	ld a, BANK(WarioHangGfx)
	ld [wPendingDMASourceBank], a
	ld a, HIGH(WarioHangGfx)
	ld [wPendingDMASourcePtr + 0], a
	ld a, LOW(WarioHangGfx)
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
	ld a, $38
	ld [hli], a
	ld a, $50
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioRailFrameset_1feeb4)
	ld [hli], a
	ld a, LOW(WarioRailFrameset_1feeb4)
	ld [hli], a
	xor a
	ld [hl], a
	ld [wSFXTimer], a
	ld a, HIGH(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMPtr + 1], a
	ld a, BANK(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMBank], a

	ld hl, wMenuObj4
	ld a, $20
	ld [hli], a
	ld a, $4c
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6fc2)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6fc2)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e6f86)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e6f86)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e6f86)
	ld [hli], a
	xor a
	ld [hl], a

	call LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step02:
	play_sfx_rept 30, SFX_08C

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $1c
	ret nc

	call ActionHelp_ShowRailRotateRight

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step03:
	play_sfx_rept 30, SFX_08C

	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld a, [hl]
	cp $4c
	ret c

	stop_sfx
	call ActionHelp2_ShowWarioJump
	ld a, $18
	ld [wActionHelpWarioVar], a

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step05:
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld hl, wActionHelpWarioVar
	ld a, [hl]
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
	call ActionHelp2_ClearButtonsInput
	call ActionHelp2_ShowWarioIdle

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step06:
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld a, [hl]
	cp $7c
	ret c

	call ActionHelp_ShowRailRotateLeft

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step07:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $4c
	ret nc

	call ActionHelp2_ShowAInput
	call ActionHelp2_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step08:
	ld hl, wActionHelpWarioVar
	ld a, [hl]
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $38
	ret nc

	ld a, $38
	ld [wActionHelpWarioYCoord], a
	xor a
	ld [wActionHelpWarioVar], a
	ld [wSFXTimer], a
	call ActionHelp2_ClearButtonsInput
	call ActionHelp_ShowWarioHangStopped

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step09:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z

	call ActionHelp_ShowWarioHangRailRight

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step0A:
	play_sfx_rept 30, SFX_08C

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $1c
	ret nc

	call ActionHelp_ShowRailRotateRight

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step0B:
	play_sfx_rept 30, SFX_08C

	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld a, [hl]
	cp $4c
	ret c

	stop_sfx
	call ActionHelp2_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step0D:
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld hl, wActionHelpWarioVar
	ld a, [hl]
	cp $27
	jr z, .asm_1e44fc
	inc [hl]
	ld a, [hl]
.asm_1e44fc
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
	call ActionHelp2_ClearButtonsInput
	call ActionHelp2_ShowWarioIdle

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step0E:
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld a, [hl]
	cp $7c
	ret c

	call ActionHelp_ShowRailRotateLeft

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step0F:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $4c
	ret nc

	call ActionHelp2_ShowAInput
	call ActionHelp2_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step10:
	ld hl, wActionHelpWarioVar
	ld a, [hl]
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $38
	ret nc

	ld a, $38
	ld [wActionHelpWarioYCoord], a
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp2_ClearButtonsInput
	call ActionHelp_ShowWarioHangStopped

	ld hl, wActionHelpState
	inc [hl]
	ret

RailActionHelp_Step11:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z
	jp RailActionHelp_End
