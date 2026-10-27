OwlActionHelp:
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
	ld a, [wObjAnimWasReset]
	ld [wMenuObj4AnimationEnded], a

	ld hl, wActionHelpWarioFramesetPtr + 1
	ld a, [wActionHelpWarioOAMBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim

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
	dw OwlActionHelp_WaitToStart
	dw OwlActionHelp_Step02
	dw OwlActionHelp_Step03
	dw OwlActionHelp_Step04
	dw OwlActionHelp_Step05
	dw OwlActionHelp_Step06
	dw OwlActionHelp_Step07
	dw OwlActionHelp_Step08
	dw ActionHelp2_FlashBInput
	dw OwlActionHelp_Step0A
	dw OwlActionHelp_Step0B
	dw OwlActionHelp_Step0C

OwlActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset

.restart_action_help
	call ActionHelp2_ClearDPadInput
	call ActionHelp2_ClearButtonsInput
	ld a, $1
	ld [wActionHelpState], a
	jr OwlActionHelp_Start

OwlActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
OwlActionHelp_Start:
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
	ld a, $c0
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(Frameset_1fed7c)
	ld [hli], a
	ld a, LOW(Frameset_1fed7c)
	ld [hli], a
	xor a
	ld [hl], a
	ld [wSFXTimer], a
	ld a, HIGH(OAM_1fddb4)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(OAM_1fddb4)
	ld [wActionHelpWarioOAMPtr + 1], a
	ld a, BANK(OAM_1fddb4)
	ld [wActionHelpWarioOAMBank], a

	ld hl, wMenuObj4
	farcall ActionHelp_HideBlockDebris
	call LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step02:
	play_sfx_rept 32, SFX_FLAP

	ld a, [wActionHelpCounter]
	and %1
	ret nz
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [hl]
	cp $60
	ret nc

	call ActionHelp2_ShowDUpInput
	call ActionHelp_ShowWarioHangVertical

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step03:
	play_sfx_rept 32, SFX_FLAP

	ld a, [wActionHelpCounter]
	and %1
	ret nz

	ld hl, wActionHelpWario
	dec [hl]
	ld a, [hl]
	cp $34
	jr z, .asm_1e4162
	cp $20
	ret nc

	ld hl, wActionHelpState
	inc [hl]
	ret

.asm_1e4162
	jp ActionHelp2_ClearDPadInput

OwlActionHelp_Step04:
	play_sfx_rept 32, SFX_FLAP

	ld a, [wActionHelpCounter]
	and %1
	ret nz
	ld hl, wActionHelpWario
	inc [hl]
	ld a, [hl]
	cp $38
	ret c

	call ActionHelp2_ShowDLeftInput
	call ActionHelp_ShowWarioHangHorizontal

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step05:
	play_sfx_rept 32, SFX_FLAP

	ld a, [wActionHelpCounter]
	and %1
	ret nz
	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [hl]
	cp $5c
	jr z, .asm_1e41c6
	cp $10
	ret nc

	call ActionHelp_ShowWarioHangOwlRight

	ld hl, wActionHelpState
	inc [hl]
	ret

.asm_1e41c6
	jp ActionHelp2_ClearDPadInput

OwlActionHelp_Step06:
	play_sfx_rept 32, SFX_FLAP

	ld a, [wActionHelpCounter]
	and %1
	ret nz
	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld a, [hl]
	cp $60
	ret c

	xor a
	ld [wSFXTimer], a
	call ActionHelp2_ShowDLeftInput
	call ActionHelp_ShowWarioOwlMoveHang

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step07:
	play_sfx_rept 16, SFX_FLAP

	ld hl, wActionHelpWarioXCoord
	dec [hl]
	ld a, [hl]
	cp $20
	ret nc

	call ActionHelp2_ShowDRightInput
	call ActionHelp_ShowWarioOwlMoveHangRight

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step08:
	play_sfx_rept 16, SFX_FLAP

	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld a, [hl]
	cp $80
	ret c

	call ActionHelp2_ClearDPadInput
	call ActionHelp_ShowWarioHangDrop
	call ActionHelp_ShowOwlFlyUp

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step0A:
	ld hl, wMenuObj4YCoord
	dec [hl]
	dec [hl]
	ld hl, wActionHelpWario
	inc [hl]
	ld a, [hl]
	cp $40
	ret c

	call ActionHelp2_ClearButtonsInput
	call ActionHelp2_ShowWarioIdle
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step0B:
	ld hl, wMenuObj4YCoord
	dec [hl]
	dec [hl]
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp2_ShowDRightInput
	call ActionHelp2_ShowWarioWalk

	ld hl, wActionHelpState
	inc [hl]
	ret

OwlActionHelp_Step0C:
	ld hl, wActionHelpWarioXCoord
	inc [hl]
	ld a, [hl]
	cp $b0
	ret c
	jp OwlActionHelp_End
