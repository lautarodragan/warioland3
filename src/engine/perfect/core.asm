InitPerfectScreen:
	call DisableLCD
	call FillBGMap0_With7f
	call ClearVirtualOAM

	call LoadPerfectPals
	call LoadPerfectGfx
	call LoadPerfectBGMaps
	call VBlank_Perfect

	xor a
	ldh [rSCX], a
	ld [wSCX], a
	ldh [rSCY], a
	ld [wSCY], a

	ld hl, wMenuObj1
	ld a, $23
	ld [hli], a
	ld a, $2b
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PerfectFrameset_dd848)
	ld [hli], a
	ld a, LOW(PerfectFrameset_dd848)
	ld [hl], a
	call UpdateObjAnim

	ld hl, wMenuObj1
	call LoadPerfectSprite

	play_music MUSIC_PERFECT

	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	xor a
	ld [wTimer], a
	ld [wGameOverWarioVar], a
	ld hl, wSubState
	inc [hl]
	ret

UpdatePerfectScreen:
	ld hl, wMenuObj1FramesetPtr + 1
	call UpdateObjAnim
	ld hl, wMenuObj1
	call LoadPerfectSprite
	call ClearUnusedVirtualOAM
	ld hl, wTimer
	ld a, [hl]
	and a
	jr z, .timer_done
	dec [hl]
	jr nz, .check_input
.timer_done
	ld a, [wGlobalCounter]
	and %111
	jr nz, .check_input
	call SlowFadeInScreen
	ld a, [wSubState]
	cp $03
	jr z, .check_input
	ld a, $03
	ld [wSubState], a
	ld hl, wGameOverWarioVar
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .hold_pals1
	dec a
	jr z, .load_pals2
	dec a
	jr z, .load_pals3
	dec a
	jr z, .load_pals2
	dec a
	jr z, .load_pals1
	ld [hl], $00
	call LoadPerfectCyclePals0
	jr .check_input
.hold_pals1
	ld a, 240
	ld [wTimer], a
.load_pals1
	call LoadPerfectCyclePals1
	jr .check_input
.load_pals2
	call LoadPerfectCyclePals2
	jr .check_input
.load_pals3
	call LoadPerfectCyclePals3

.check_input
	ld a, [wGameModeFlags]
	bit MODE_TIME_ATTACK_F, a
	ret nz
	ld a, [wJoypadPressed]
	and a
	ret z
	xor a
	ld [wFadeSpeed], a
	ld [wPalFadeCounter], a
	ld [wUnused_c186], a
	ld hl, wGameModeFlags
	set MODE_TIME_ATTACK_F, [hl]
	ld a, ST_PAUSE_MENU
	ld [wState], a
	ld a, SST_PAUSE_SAVE_AND_RESET
	ld [wSubState], a
	ret

LoadPerfectPals:
	ld hl, PerfectPals_dc173
	call LoadPalsToTempPals1
	ld hl, PerfectOBPals
	call LoadPalsToTempPals2
	ret

LoadPerfectCyclePals0:
	ld hl, PerfectPals_dc173 palette 5
	ld de, wTempPals1 palette 5
	ld b, 3 palettes
	call CopyHLToDE_Short
	ret

LoadPerfectCyclePals1:
	ld hl, PerfectPals_dc1b3
	ld de, wTempPals1 palette 5
	ld b, 3 palettes
	call CopyHLToDE_Short
	ret

LoadPerfectCyclePals2:
	ld hl, PerfectPals_dc1cb
	ld de, wTempPals1 palette 5
	ld b, 3 palettes
	call CopyHLToDE_Short
	ret

LoadPerfectCyclePals3:
	ld hl, PerfectPals_dc1e3
	ld de, wTempPals1 palette 5
	ld b, 3 palettes
	call CopyHLToDE_Short
	ret

LoadPerfectGfx:
	xor a
	ldh [rVBK], a
	ld hl, PerfectGfx
	ld bc, v0Tiles0
	call Decompress
	ret

LoadPerfectBGMaps:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, PerfectAttrmap
	ld bc, v0BGMap0
	call Decompress
	xor a
	ldh [rVBK], a
	ld hl, PerfectTilemap
	ld bc, v0BGMap0
	call Decompress
	ret

LoadPerfectSprite:
	ld a, [hli]
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld hl, PerfectOAM_dd710
	call LoadSprite
	ret
