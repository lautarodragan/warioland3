LoadActionHelpPalsWithWater:
	xor a
	ld [wActionHelpBlackedOut], a
	ld hl, ActionHelpPals_1e4e6f
	call LoadActionHelpBGPals
	call LoadActionHelpOBPals
	ret

LoadActionHelpPalsWithoutWater:
	xor a
	ld [wActionHelpBlackedOut], a
	ld hl, ActionHelpPals_1e4eaf
	call LoadActionHelpBGPals
	call LoadActionHelpOBPals
	ret

BlackOutActionHelpBGPals:
	ld a, TRUE
	ld [wActionHelpBlackedOut], a
	ld hl, ActionHelpBlackedOutBGPals
	call LoadActionHelpBGPals
	ret

LoadActionHelpCommonPals:
	ld a, TRUE
	ld [wActionHelpBlackedOut], a
	ld hl, ActionHelpBlackedOutBGPals
	call LoadPalsToTempPals1
	ret

LoadActionHelpPowerUpPals:
	ld a, [wActionHelpPowerUp]
	and POWER_UP_MASK
	cp NUM_MAIN_POWER_UPS
	jr c, .main_power_up

; special power-up
	ld hl, ActionHelpPowerUpOBPals
	call LoadPalsToTempPals2
	ld a, [wActionHelpPowerUp]
	cp POWER_UP_VAMPIRE
	ret nz
	ld hl, ActionHelpPals_1e4fbf
	ld de, wTempPals2
	ld b, 2 palettes
	call CopyHLToDE_Short
	ret

.main_power_up
	ld hl, ActionHelpOBPals
	call LoadPalsToTempPals2
	ld a, [wActionHelpPowerUp]
	cp GARLIC
	ret c
	ld hl, ActionHelpPals_1e4f6f
	ld de, wTempPals2
	ld b, 2 palettes
	call CopyHLToDE_Short
	ret

LoadActionHelpGfx:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, ActionHelpObjects1Gfx
	ld a, [wActionHelpPowerUp]
	and POWER_UP_MASK
	cp NUM_MAIN_POWER_UPS
	jr c, .got_tiles
	ld hl, ActionHelpObjects2Gfx
.got_tiles
	ld bc, v1Tiles0
	call Decompress

	xor a
	ldh [rVBK], a
	ld hl, ActionHelpHUDGfx
	ld bc, v0Tiles0
	call Decompress
	ret

LoadActionHelpBGMaps:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, ActionHelpAttrmap
	ld bc, v1BGMap1
	call Decompress
	xor a
	ldh [rVBK], a
	ld hl, ActionHelpTilemap
	ld bc, v0BGMap1
	call Decompress

	ld a, [wActionHelpPowerUp]
	and POWER_UP_MASK
	cp NUM_MAIN_POWER_UPS
	jr nc, .special_power_up
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	jr z, .draw_locked_slots
	ld c, a

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	hlbgcoord 0, 16, v1BGMap1
	ld de, TILEMAP_WIDTH
	ld b, $00
.loop_unlocked_slots
	push hl
	ld a, $03
	ld [hli], a
	ld [hld], a
	add hl, de
	ld [hli], a
	ld [hl], a
	pop hl
	inc l
	inc l
	inc b
	ld a, b
	cp c
	jr c, .loop_unlocked_slots

.draw_locked_slots
	xor a
	ldh [rVBK], a
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	ld b, a
	ld a, $09
	sub b
	ret z
	ld b, a
	hlbgcoord 18, 16, v0BGMap1
.loop_locked_slots
	push hl
	call .draw_locked_slot
	pop hl
	dec hl
	dec hl
	dec b
	jr nz, .loop_locked_slots
	ret

.special_power_up
	ld b, $0a
	hlbgcoord 18, 16, v0BGMap1
	jr .loop_locked_slots

.draw_locked_slot:
	ld de, TILEMAP_WIDTH
	push hl
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld a, $07
	ld [hli], a
	ld [hld], a
	add hl, de
	ld [hli], a
	ld [hl], a
	pop hl
	xor a
	ldh [rVBK], a
	ld a, $64
	ld [hli], a
	inc a
	ld [hld], a
	add hl, de
	ld a, $74
	ld [hli], a
	inc a
	ld [hl], a
	ret

LoadActionHelpBGPals:
	push hl
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE_Short
	pop hl

	ld a, BGPI_AUTOINC | palette 0
	ldh [rBGPI], a
	ld b, 8
	ld c, LOW(rBGPD)

.loop_copy_bg_pals
	wait_not_hblank
	wait_hblank
REPT 1 palettes
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_copy_bg_pals
	ret

LoadActionHelpOBPals:
	ld hl, ActionHelpOBPals
	ld a, [wActionHelpPowerUp]
	cp NUM_MAIN_POWER_UPS
	ret nc ; quit if is a special Power-Up
	ld b, a
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	cp b
	jr nc, .has_power_up
	; doesn't have Power-Up,
	; so black out some OB pals
	xor a
	ld hl, wTempPals2
	ld b, 2 palettes
	call WriteAToHL_BTimes
	ld hl, wTempPals2 palette 3
	ld b, 5 palettes
	call WriteAToHL_BTimes
	ld hl, wTempPals2
	jr .apply_palettes
.has_power_up
	push hl
	ld de, wTempPals2
	ld b, 8 palettes
	call CopyHLToDE_Short
	pop hl

.apply_palettes
	ld a, OBPI_AUTOINC | palette 0
	ldh [rOBPI], a
	ld b, 8
	ld c, LOW(rOBPD)
.loop_copy_ob_pals
	wait_not_hblank
	wait_hblank
REPT 1 palettes
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_copy_ob_pals
	ret

LoadActionHelpPowerUpIconPals:
	ld hl, ActionHelpOBPals palette 4
	ld a, [wActionHelpPowerUp]
	cp NUM_MAIN_POWER_UPS
	ret nc

	ld b, a
	ld a, [wPowerUpLevel]
	and POWER_UP_MASK
	cp b
	jr nc, .unlocked
	xor a
	ld hl, wTempPals2 palette 4
	ld b, 1 palettes
	call WriteAToHL_BTimes
	ld hl, wTempPals2 palette 7
	ld b, 1 palettes
	call WriteAToHL_BTimes
	ld hl, wTempPals2 palette 4
	jr .load_pals
.unlocked
	push hl
	ld de, wTempPals2 palette 4
	ld b, 1 palettes
	call CopyHLToDE_Short
	ld hl, ActionHelpOBPals palette 7
	ld de, wTempPals2 palette 7
	ld b, 1 palettes
	call CopyHLToDE_Short
	pop hl

.load_pals
	ld a, OBPI_AUTOINC | palette 4
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
	ld b, 4
.loop_copy_pals
	wait_not_hblank
	wait_hblank
REPT PAL_SIZE
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_copy_pals
	ret

LoadActionHelpWarioSprite:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	sub b
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld a, [wActionHelpWarioOAMPtr + 0]
	ld h, a
	ld a, [wActionHelpWarioOAMPtr + 1]
	ld l, a
	farcall $05, LoadSprite
	ret

LoadActionHelpWarioSprite_FromBank:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	sub b
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld a, [wActionHelpWarioOAMPtr + 0]
	ld h, a
	ld a, [wActionHelpWarioOAMPtr + 1]
	ld l, a
	ld a, [wActionHelpWarioOAMBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall LoadSprite
	ret

LoadActionHelpSprite_Far:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	sub b
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hli]
	ld [wCurSpriteAttributes], a
	inc l
	inc l
	inc l
	inc l
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld [wTempBank], a
	ld h, d
	ld l, e
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall LoadSprite
	ret

LoadActionHelpSprite:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	sub b
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld hl, ActionHelpOAM_1e697c
	call LoadSprite
	ret

; unreferenced
UnreferencedLoadActionHelpObjSprite:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	sub b
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld hl, ActionHelpEnemyOAM_1e6bab
	call LoadSprite
	ret

ActionHelp2_Init:
	farcall ActionHelp_Init
	ret

ActionHelp2_FlashBInput:
	farcall ActionHelp_FlashBInput
	ret

ActionHelp2_FlashAInput:
	farcall ActionHelp_FlashAInput
	ret

ActionHelp2_ClearDPadInput:
	xor a
	ld hl, wMenuObj2FramesetOffset
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpNoDPadInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpNoDPadInputFrameset)
	ld [hl], a
	ret

ActionHelp2_ShowDLeftInput:
	xor a
	ld hl, wMenuObj2FramesetOffset
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpDLeftInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpDLeftInputFrameset)
	ld [hl], a
	ret

ActionHelp2_ShowDRightInput:
	xor a
	ld hl, wMenuObj2FramesetOffset
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpDRightInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpDRightInputFrameset)
	ld [hl], a
	ret

ActionHelp2_ShowDUpInput:
	xor a
	ld hl, wMenuObj2FramesetOffset
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpDUpInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpDUpInputFrameset)
	ld [hl], a
	ret

ActionHelp2_ClearButtonsInput:
	ld hl, wMenuObj3FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpNoButtonInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpNoButtonInputFrameset)
	ld [hl], a
	ret

ActionHelp2_ShowAInput:
	xor a
	ld hl, wMenuObj3FramesetOffset
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpAInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpAInputFrameset)
	ld [hl], a
	ret

ActionHelp2_ShowBInput:
	xor a
	ld hl, wMenuObj3FramesetOffset
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpBInputFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpBInputFrameset)
	ld [hl], a
	ret

ActionHelp_ShowWarioHangVertical:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioOwlFrameset_1fedd0)
	ld [hli], a
	ld a, LOW(WarioOwlFrameset_1fedd0)
	ld [hl], a
	ret

ActionHelp_ShowWarioHangHorizontal:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioOwlFrameset_1fed7c)
	ld [hli], a
	ld a, LOW(WarioOwlFrameset_1fed7c)
	ld [hl], a
	ret

ActionHelp_ShowWarioHangOwlRight:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioOwlFrameset_1fed91)
	ld [hli], a
	ld a, LOW(WarioOwlFrameset_1fed91)
	ld [hl], a
	ret

ActionHelp_ShowWarioOwlMoveHang:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioOwlFrameset_1feda6)
	ld [hli], a
	ld a, LOW(WarioOwlFrameset_1feda6)
	ld [hl], a
	ret

ActionHelp_ShowWarioOwlMoveHangRight:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioOwlFrameset_1fedbb)
	ld [hli], a
	ld a, LOW(WarioOwlFrameset_1fedbb)
	ld [hl], a
	ret

ActionHelp_ShowWarioHangDrop:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioOwlFrameset_1fedfe)
	ld [hli], a
	ld a, LOW(WarioOwlFrameset_1fedfe)
	ld [hl], a
	ret

ActionHelp2_ShowWarioIdle:
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

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioFrameset_1425f)
	ld [hli], a
	ld a, LOW(WarioFrameset_1425f)
	ld [hl], a
	ld a, HIGH(OAM_14000)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(OAM_14000)
	ld [wActionHelpWarioOAMPtr + 1], a
	ld a, BANK(OAM_14000)
	ld [wActionHelpWarioOAMBank], a
	ret

ActionHelp2_ShowWarioWalk:
	ld a, BANK(WarioWalkGfx)
	ld [wPendingDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wPendingDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
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

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioFrameset_149c5)
	ld [hli], a
	ld a, LOW(WarioFrameset_149c5)
	ld [hli], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wActionHelpWarioOAMPtr + 1], a
	ret

ActionHelp2_ShowWarioJump:
	ld a, BANK(WarioAirborneGfx)
	ld [wPendingDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wPendingDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
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

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioBlindFrameset_15f97)
	ld [hli], a
	ld a, LOW(WarioBlindFrameset_15f97)
	ld [hli], a
	xor a
	ld [hl], a
	ld a, HIGH(OAM_15955)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(OAM_15955)
	ld [wActionHelpWarioOAMPtr + 1], a
	ld a, BANK(OAM_15955)
	ld [wActionHelpWarioOAMBank], a
	ret

ActionHelp_ShowWarioHangStopped:
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

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioRailFrameset_1feec4)
	ld [hli], a
	ld a, LOW(WarioRailFrameset_1feec4)
	ld [hli], a
	xor a
	ld [hl], a
	ld a, HIGH(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMPtr + 1], a
	ld a, BANK(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMBank], a
	ret

ActionHelp_ShowWarioHangRailRight:
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

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioRailFrameset_1feeb4)
	ld [hli], a
	ld a, LOW(WarioRailFrameset_1feeb4)
	ld [hli], a
	xor a
	ld [hl], a
	ld a, HIGH(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMPtr + 1], a
	ld a, BANK(WarioRailOAM_1fee05)
	ld [wActionHelpWarioOAMBank], a
	ret

ActionHelp_ShowWarioBatTransform:
	ld a, BANK(WarioBatGfx)
	ld [wPendingDMASourceBank], a
	ld a, HIGH(WarioBatGfx)
	ld [wPendingDMASourcePtr + 0], a
	ld a, LOW(WarioBatGfx)
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

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioBatFrameset_1fd479)
	ld [hli], a
	ld a, LOW(WarioBatFrameset_1fd479)
	ld [hl], a
	ld a, HIGH(WarioOAM_1fd031)
	ld [wActionHelpWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1fd031)
	ld [wActionHelpWarioOAMPtr + 1], a
	ret

ActionHelp_ShowWarioBatRight:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld [wSFXTimer], a
	ld a, HIGH(WarioBatFrameset_1fd46c)
	ld [hli], a
	ld a, LOW(WarioBatFrameset_1fd46c)
	ld [hl], a
	ret

ActionHelp_ShowWarioBatLeft:
	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld [wSFXTimer], a
	ld a, HIGH(WarioBatFrameset_1fd42c)
	ld [hli], a
	ld a, LOW(WarioBatFrameset_1fd42c)
	ld [hl], a
	ret

ActionHelp_ShowWarioVampireTransform:
	play_sfx SFX_VAMPIRE_TRANSFORM

	ld hl, wActionHelpWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(WarioVampireFrameset_1fd439)
	ld [hli], a
	ld a, LOW(WarioVampireFrameset_1fd439)
	ld [hl], a
	ret

ActionHelp_ShowRailRotateRight:
	ld hl, wMenuObj4FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpRailRotateRightFrameset)
	ld [hli], a
	ld a, LOW(ActionHelpRailRotateRightFrameset)
	ld [hli], a
	ret

ActionHelp_ShowRailRotateLeft:
	ld hl, wMenuObj4FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6fc2)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6fc2)
	ld [hli], a
	ret

ActionHelp_ShowOwlFlyUp:
	ld hl, wMenuObj4
	ld a, [wActionHelpWarioYCoord]
	sub $20
	ld [hli], a
	ld a, [wActionHelpWarioXCoord]
	sub $08
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ParticleOwlFrameset)
	ld [hli], a
	ld a, LOW(ParticleOwlFrameset)
	ld [hli], a
	ld a, HIGH(ParticleOwlOAM)
	ld [hli], a
	ld a, LOW(ParticleOwlOAM)
	ld [hli], a
	ld a, BANK(ParticleOwlOAM)
	ld [hli], a
	xor a
	ld [hl], a
	ret
