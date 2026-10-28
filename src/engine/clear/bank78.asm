LoadClearScreenPals:
	ld hl, ClearScreenBGPals
	call LoadPalsToTempPals1
	ld hl, ClearScreenOBPals
	call LoadPalsToTempPals2
	ret

LoadTimeAttackClearScreenPals:
	ld hl, TimeAttackClearScreenBGPals
	call LoadPalsToTempPals1
	ld hl, TimeAttackClearScreenOBPals
	call LoadPalsToTempPals2
	ret

LoadClearScreenGfx:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, ClearScreen2Gfx
	ld bc, v0Tiles0
	call Decompress

	xor a
	ldh [rVBK], a
	ld hl, ClearScreen1Gfx
	ld bc, v0Tiles1
	call Decompress

	ld hl, WarioClearGfx
	ld de, v0Tiles0
	ld bc, $80 tiles
	ld a, BANK(WarioClearGfx)
	ld [wTempBank], a
	call FarCopyHLToDE_BC
	ret

LoadTreasureClearScreenBGMaps:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, ClearScreenTreasureAttrmap
	ld bc, v1BGMap0
	call Decompress

	xor a
	ldh [rVBK], a
	ld hl, ClearScreenTreasureTilemap
	ld bc, v0BGMap0
	call Decompress
	ret

LoadTimeAttackClearScreenBGMaps:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, ClearScreenTimeAttackAttrmap
	ld bc, v0BGMap0
	call Decompress

	xor a
	ldh [rVBK], a
	ld hl, ClearScreenTimeAttackTilemap
	ld bc, v0BGMap0
	call Decompress

	call .GetResult
	ld a, [wLevel]
	srl a
	srl a
	srl a
	add a
	ld e, a
	ld d, $00
	ld hl, wLevelTimeAttackScores
	add hl, de
	ld a, [hli]
	ld [wTempTimeAttackScore + 0], a
	ld a, [hl]
	ld [wTempTimeAttackScore + 1], a
	hlbgcoord 10, 7
	ld bc, -TILEMAP_WIDTH
	ld de, TILEMAP_WIDTH
	ld a, [wTempTimeAttackScore + 0]
	swap a
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc
	ld a, [wTempTimeAttackScore + 0]
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc
	inc l
	ld a, [wTempTimeAttackScore + 1]
	swap a
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc
	ld a, [wTempTimeAttackScore + 1]
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc ; unnecessary

	ld a, [wTimeAttackResult]
	and a
	ret z
	hlbgcoord 10, 10
	ld bc, -TILEMAP_WIDTH
	ld de, TILEMAP_WIDTH
	ld a, [wLevelTime + 0]
	swap a
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc
	ld a, [wLevelTime + 0]
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc
	inc l
	ld a, [wLevelTime + 1]
	swap a
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hli], a
	add hl, bc
	ld a, [wLevelTime + 1]
	and $0f
	add a
	add $a0
	ld [hl], a
	add hl, de
	inc a
	ld [hl], a
	ret

.GetResult:
	xor a ; TIME_ATTACK_NOT_COMPLETED
	ld [wTimeAttackResult], a
	ld a, [wKeyAndTreasureFlags]
	and KEYS_MASK
	cp GREY_KEY | RED_KEY | GREEN_KEY | BLUE_KEY
	ret nz
	ld a, TIME_ATTACK_NO_HIGH_SCORE
	ld [wTimeAttackResult], a
	ld a, [wLevel]
	srl a
	srl a
	srl a
	add a ; *2
	ld e, a
	ld d, $00
	ld hl, wLevelTimeAttackScores
	add hl, de
	ld a, [wLevelTime + 0]
	cp [hl]
	jr c, .new_high_score
	ret nz
	inc hl
	ld a, [wLevelTime + 1]
	cp [hl]
	ret nc
	dec hl
.new_high_score
	ld a, [wLevelTime + 0]
	ld [hli], a
	ld a, [wLevelTime + 1]
	ld [hl], a
	ld a, TIME_ATTACK_GOT_HIGH_SCORE
	ld [wTimeAttackResult], a
	ret

InitTreasureClearScreenObjs:
	ld a, [wPowerUpLevel]
	and ACTION_HELP_LEVEL_CLEAR
	jr z, .no_power_up
	ld hl, wMenuObj8
	ld a, $53
	ld [hli], a
	ld a, $24
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d506b)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d506b)
	ld [hl], a

.no_power_up
	ld hl, wClearScreenWario
	ld a, $76
	ld [hli], a
	ld a, $34
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wClearScreenWarioVar], a
	ld a, [wTransitionParam]
	cp TRANSITION_RETURN_TO_MAP
	jr z, .returning_to_map
	ld a, HIGH(ClearScreenFrameset_d4d18)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d4d18)
	ld [hl], a
	jr .got_wario_frameset
.returning_to_map
	ld a, HIGH(ClearScreenFrameset_d4d58)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d4d58)
	ld [hl], a

.got_wario_frameset
	ld hl, wMenuObj1
	ld a, [wLevelEndScreen]
	cp LVLEND_GREY_TREASURE
	jr z, .grey
	cp LVLEND_RED_TREASURE
	jr z, .red
	cp LVLEND_GREEN_TREASURE
	jr z, .green
	cp LVLEND_BLUE_TREASURE
	jr z, .blue
; no treasure
	play_music MUSIC_LEVEL_CLEAR_NO_TREASURE
	jr .no_treasure
.grey
	ld de, .GreyTreasureParams
	jr .got_treasure_params
.red
	ld de, .RedTreasureParams
	jr .got_treasure_params
.green
	ld de, .GreenTreasureParams
	jr .got_treasure_params
.blue
	ld de, .BlueTreasureParams
.got_treasure_params
	ld a, [de]
	ld [hli], a ; y
	inc de
	ld a, [de]
	ld [hli], a ; x
	xor a
	ld [hli], a ; frame
	ld [hli], a ; attributes
	ld [hli], a ; frameset offset
	ld [hli], a ; duration
	inc de
	ld a, [de]
	ld [hli], a ; frameset pointer
	inc de      ;
	ld a, [de]  ;
	ld [hl], a  ;

	play_music MUSIC_LEVEL_CLEAR_GOT_TREASURE

.no_treasure
	stop_sfx

	ld hl, wMenuObj2
	ld a, $28
	ld [hli], a
	ld a, $30
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5059)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5059)
	ld [hl], a
	ld a, [wNumMusicBoxes]
	and a
	jp z, .no_music_boxes
	dec a
	jr z, .one_music_box
	dec a
	jr z, .two_music_boxes
	dec a
	jr z, .three_music_boxes
	dec a
	jr z, .four_music_boxes

	ld hl, wMenuObj3
	ld a, $79
	ld [hli], a
	ld a, $84
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5068)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5068)
	ld [hl], a

.four_music_boxes
	ld hl, wMenuObj4
	ld a, $8d
	ld [hli], a
	ld a, $7f
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5065)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5065)
	ld [hl], a

.three_music_boxes
	ld hl, wMenuObj5
	ld a, $8c
	ld [hli], a
	ld a, $69
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5062)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5062)
	ld [hl], a

.two_music_boxes
	ld hl, wMenuObj6
	ld a, $79
	ld [hli], a
	ld a, $62
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d505f)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d505f)
	ld [hl], a

.one_music_box
	ld hl, wMenuObj7
	ld a, $67
	ld [hli], a
	ld a, $74
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d505c)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d505c)
	ld [hl], a
.no_music_boxes
	ret

.GreyTreasureParams:
	db $38 ; y
	db $20 ; x
	bigdw ClearScreenFrameset_d5045 ; frameset

.RedTreasureParams:
	db $38 ; y
	db $40 ; x
	bigdw ClearScreenFrameset_d504a ; frameset

.GreenTreasureParams:
	db $38 ; y
	db $60 ; x
	bigdw ClearScreenFrameset_d504f ; frameset

.BlueTreasureParams:
	db $38 ; y
	db $80 ; x
	bigdw ClearScreenFrameset_d5054 ; frameset

InitTimeAttackClearScreenObjs:
	ld a, [wTimeAttackResult]
	cp TIME_ATTACK_GOT_HIGH_SCORE
	jr nz, .init_wario
	ld hl, wMenuObj8
	ld a, $60
	ld [hli], a
	ld a, $1c
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5080)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5080)
	ld [hl], a

.init_wario
	ld hl, wClearScreenWario
	ld a, SCREEN_HEIGHT_PX
	ld [hli], a
	ld a, $2c
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wActionHelpWarioVar], a
	ld a, [wTimeAttackResult]
	cp TIME_ATTACK_GOT_HIGH_SCORE
	jr nz, .no_high_score
	play_music MUSIC_LEVEL_CLEAR_GOT_TREASURE
	ld a, HIGH(ClearScreenFrameset_d4d18)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d4d18)
	ld [hl], a
	jr .got_wario_frameset
.no_high_score
	play_music MUSIC_LEVEL_CLEAR_NO_TREASURE
	ld a, HIGH(ClearScreenFrameset_d4d58)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d4d58)
	ld [hl], a
.got_wario_frameset
	stop_sfx

	ld hl, wMenuObj2
	ld a, $28
	ld [hli], a
	ld a, $30
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5059)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5059)
	ld [hl], a

	ld hl, wMenuObj3
	ld a, $44
	ld [hli], a
	ld a, $28
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d50a1)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d50a1)
	ld [hl], a

	ld a, [wKeyAndTreasureFlags]
	bit GREY_KEY_F, a
	jr z, .red_key
	ld hl, wMenuObj4
	ld a, $7c
	ld [hli], a
	ld a, $5c
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5095)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5095)
	ld [hl], a

.red_key
	ld a, [wKeyAndTreasureFlags]
	bit RED_KEY_F, a
	jr z, .green_key
	ld hl, wMenuObj5
	ld a, $7c
	ld [hli], a
	ld a, $74
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d5098)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d5098)
	ld [hl], a

.green_key
	ld a, [wKeyAndTreasureFlags]
	bit GREEN_KEY_F, a
	jr z, .blue_key
	ld hl, wMenuObj6
	ld a, $8e
	ld [hli], a
	ld a, $5c
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d509b)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d509b)
	ld [hl], a

.blue_key
	ld a, [wKeyAndTreasureFlags]
	bit BLUE_KEY_F, a
	jr z, .done
	ld hl, wMenuObj7
	ld a, $8e
	ld [hli], a
	ld a, $74
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ClearScreenFrameset_d509e)
	ld [hli], a
	ld a, LOW(ClearScreenFrameset_d509e)
	ld [hl], a
.done
	ret

ClearScreenBGPals:
	rgb 24, 30, 31
	rgb 11, 24, 31
	rgb  0,  9, 25
	rgb  0,  0,  0

	rgb 31, 31,  7
	rgb 11, 24, 31
	rgb  0,  9, 25
	rgb  0,  0,  0

	rgb 31, 23, 28
	rgb  8,  0, 16
	rgb 27,  3, 31
	rgb  0,  0,  0

	rgb 24, 30, 31
	rgb 11, 24, 31
	rgb 31, 31,  7
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 21, 10,  1
	rgb 14,  3,  1
	rgb  5,  0,  0

	rgb 31, 31, 31
	rgb 30, 15,  2
	rgb 26,  0,  0
	rgb  7,  0,  0

	rgb 31, 31, 31
	rgb 16, 16, 16
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 20,  0
	rgb  0, 19, 31
	rgb  0,  0,  0

ClearScreenOBPals:
	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 15, 10
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 11, 24, 31
	rgb 14, 11, 26
	rgb 16,  0, 24

	rgb 31, 31, 31
	rgb  2, 31, 31
	rgb  6,  6, 31
	rgb  0,  0,  7

	rgb  0, 22, 16
	rgb 31, 23,  4
	rgb 31, 13,  4
	rgb 31,  0,  2

	rgb 31, 31, 31
	rgb 31, 31,  0
	rgb 19, 16,  0
	rgb  5,  4,  0

	rgb 31, 31, 31
	rgb 31, 19, 23
	rgb 27,  0,  6
	rgb  7,  0,  0

	rgb 31, 31, 31
	rgb 22, 31, 20
	rgb  0, 21,  0
	rgb  0,  2,  0

	rgb 31, 31, 27
	rgb 21, 21, 19
	rgb 10, 10,  8
	rgb  0,  0,  0

TimeAttackClearScreenBGPals:
	rgb 31, 27, 16
	rgb 31, 15,  2
	rgb 25,  3,  0
	rgb  0,  0,  0

	rgb 31, 31,  7
	rgb 31, 15,  2
	rgb 25,  3,  0
	rgb  0,  0,  0

	rgb 17, 31, 24
	rgb  0,  8,  6
	rgb  1, 23, 20
	rgb  0,  0,  0

	rgb 31, 27, 16
	rgb 31, 15,  2
	rgb 31, 31,  7
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 21, 10,  1
	rgb 14,  3,  1
	rgb  5,  0,  0

	rgb  0,  0, 12
	rgb 30, 31, 31
	rgb  8, 20, 31
	rgb  7,  0,  0

	rgb 31, 31, 31
	rgb 16, 16, 16
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 20,  0
	rgb  0, 19, 31
	rgb  0,  0,  0

TimeAttackClearScreenOBPals:
	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 15, 10
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 11, 24, 31
	rgb 14, 11, 26
	rgb 16,  0, 24

	rgb  0, 22, 16
	rgb 19, 31, 31
	rgb  0, 12, 31
	rgb  0,  0,  7

	rgb  0, 22, 16
	rgb 31, 23,  4
	rgb 31, 13,  4
	rgb 31,  0,  2

	rgb  0, 22, 16
	rgb 28, 28, 28
	rgb 15, 15, 15
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 24, 24
	rgb 23,  0,  0
	rgb  7,  0,  0

	rgb  0, 22, 16
	rgb 24, 31, 21
	rgb  0, 16,  0
	rgb  0,  2,  0

	rgb  0, 22, 16
	rgb 31, 31,  0
	rgb 31, 17,  0
	rgb 31,  0,  0

ClearScreen1Gfx:
INCBIN "gfx/pause/clear_screen1.2bpp.rle"

ClearScreen2Gfx:
INCBIN "gfx/pause/clear_screen2.2bpp.rle"

ClearScreenTreasureTilemap: INCBIN "data/bgmaps/clear_screen_treasure.tilemap.rle"
ClearScreenTreasureAttrmap: INCBIN "data/bgmaps/clear_screen_treasure.attrmap.rle"

ClearScreenTimeAttackTilemap: INCBIN "data/bgmaps/clear_screen_time_attack.tilemap.rle"
ClearScreenTimeAttackAttrmap: INCBIN "data/bgmaps/clear_screen_time_attack.attrmap.rle"
