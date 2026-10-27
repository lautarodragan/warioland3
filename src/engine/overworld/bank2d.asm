OWObjState_None:
	ret

InvalidOWSceneAction:
	debug_nop

_InitOWObjects:
	ld a, [wEventUnlockState]
	ld c, a
	ld a, [wOWSceneMapSide]
	jumptable

	dw InitOWObjects_North ; NORTH
	dw InitOWObjects_West  ; WEST
	dw InitOWObjects_South ; SOUTH
	dw InitOWObjects_East  ; EAST

InitOWObjects_North:
	ld a, [wOWSceneActionParam]
	jumptable

	dw InvalidOWSceneAction
	dw InitNOWObjects_CutTree ; NOWFUNC_CUT_TREE
	dw InitNOWObjects_OpenGate ; NOWFUNC_OPEN_GATE
	dw InitNOWObjects_Garlic ; NOWFUNC_GARLIC
	dw InitNOWObjects_MagicSeed ; NOWFUNC_MAGIC_SEED
	dw InitNOWObjects_SummonSnake ; NOWFUNC_SUMMON_SNAKE
	dw InitNOWObjects_FallLeaves ; NOWFUNC_FALL_LEAVES
	dw InitNOWObjects_MusicBox ; NOWFUNC_BLUE_MUSIC_BOX
	dw InitNOWObjects_MusicBox ; NOWFUNC_GOLD_MUSIC_BOX
	dw InitNOWObjects_CrayonRed ; NOWFUNC_CRAYON_RED
	dw InitNOWObjects_CrayonBrown ; NOWFUNC_CRAYON_BROWN
	dw InitNOWObjects_CrayonYellow ; NOWFUNC_CRAYON_YELLOW
	dw InitNOWObjects_CrayonGreen ; NOWFUNC_CRAYON_GREEN
	dw InitNOWObjects_CrayonCyan ; NOWFUNC_CRAYON_CYAN
	dw InitNOWObjects_CrayonBlue ; NOWFUNC_CRAYON_BLUE
	dw InitNOWObjects_CrayonPink ; NOWFUNC_CRAYON_PINK
	dw InitNOWObjects_BottomBar ; NOWFUNC_BOTTOM_BAR
	dw InitNOWObjects_DayNightSpell ; NOWFUNC_DAY_NIGHT_SPELL
	dw InitNOWObjects_Prologue ; NOWFUNC_PROLOGUE

InitNOWObjects_CutTree:
	dec c
	jr z, .asm_b404f
	ld hl, wSceneObj8
	ld de, .data
	call InitSceneObjParams
	jr .asm_b404f

.data
	db $44, $30, $01

.asm_b404f
	call .InitDayNightObjs
	jp PlaceTempleHintObj

.InitDayNightObjs:
	ld a, [wCurEvent]
	and a
	ret nz
	ld hl, wSceneObj15
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj14
	ld de, .data_2
	call InitSceneObjParams

	ld a, [wOWIsNight]
	and a
	ret z
	ld a, $18
	ld [wSceneObj15State], a
	ld a, $1a
	ld [wSceneObj14State], a
	ret

.data_1
	db $56, $1c, $19
.data_2
	db $36, $50, $1b

PlaceTempleHintObj:
	ld hl, wSceneObj13
	ld de, .data
	jp InitSceneObjParams

.data
	db $84, $82, $00

InitNOWObjects_OpenGate:
	dec c
	ret z
	ld hl, wSceneObj10
	ld de, .data
	jp InitSceneObjParams

.data
	db $40, $80, $03

InitNOWObjects_Garlic:
	ld a, GREEN_MUSIC_BOX
	call IsTreasureCollected
	ret nz
	ld a, [wCurEvent]
	and a
	jr nz, .asm_b40b4
	ld a, [wNextMapSide]
	and a
	jr nz, .asm_b40b4
	ld a, [wMapSideLevelID]
	cp OWNORTH_SEA_TURTLE_ROCKS
	ret z
.asm_b40b4
	ld hl, wSceneObj3
	ld de, .data
	jp InitSceneObjParams

.data
	db $66, $74, $05

InitNOWObjects_MagicSeed:
	ld a, c
	and a
	ret z
	ld hl, wSceneObj4
	ld de, .data_2
	cp $80
	jr nz, .asm_b40d0
	ld de, .data_1
.asm_b40d0
	jp InitSceneObjParams

.data_1
	db $00, $68, $07
.data_2
	db $4c, $66, $0b

InitNOWObjects_SummonSnake:
	ld a, c
	and a
	ret z
	dec c
	jr z, .asm_b40f0
	ld hl, wSceneObj1
	ld de, .data_1
	call InitSceneObjParams
	call .asm_b40f0
	xor a
	ld [wSceneObj2State], a
	ret

.asm_b40f0
	ld hl, wSceneObj2
	ld de, .data_2
	jp InitSceneObjParams

.data_1
	db $51, SCREEN_WIDTH_PX, $0f
.data_2
	db $59, $2d, $1d

InitNOWObjects_FallLeaves:
	ld a, c
	and a
	ret z
	sla c
	jr c, .asm_b4128
	ld a, $01
	ld [w2d12c], a
	ld hl, wSceneObj6
	ld de, .data_1
	call InitSceneObjParams
	ld a, $04
	ld [w2d12e], a
	ld hl, wSceneObj7
	ld de, .data_2
	jp InitSceneObjParams

.data_1
	db $48, $14, $11
.data_2
	db $38, $0f, $10

.asm_b4128
	ld hl, wSceneObj6
	ld de, .data_3
	call InitSceneObjParams
	ld hl, wSceneObj7
	ld de, .data_4
	jp InitSceneObjParams

.data_3
	db $38, $15, $14
.data_4
	db $41, $19, $14

InitNOWObjects_MusicBox:
	ret

InitNOWObjects_CrayonRed:
	ld b, $00
;	fallthrough

InitNOWObjects_Crayon:
	sla c
	ret nc
	ld hl, wSceneObj5
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj5Attributes
	ld [hl], b
	ld hl, wSceneObj1
	ld de, .data_2
	jp InitSceneObjParams

.data_1
	db $00, $70, $1f
.data_2
	db $00, $70, $21

InitNOWObjects_CrayonBrown:
	ld b, $00
	jr InitNOWObjects_Crayon

InitNOWObjects_CrayonYellow:
	ld b, $02
	jr InitNOWObjects_Crayon

InitNOWObjects_CrayonGreen:
	ld b, $03
	jr InitNOWObjects_Crayon

InitNOWObjects_CrayonCyan:
	ld b, $03
	jr InitNOWObjects_Crayon

InitNOWObjects_CrayonBlue:
	ld b, $02
	jr InitNOWObjects_Crayon

InitNOWObjects_CrayonPink:
	ld b, $01
	jr InitNOWObjects_Crayon

InitNOWObjects_BottomBar:
	ld a, $80
	cp c
	ret nz

	ld hl, wSceneObj1
	ld de, .data_1
	call InitSceneObjParams

	ld hl, wSceneObj5
	ld de, .data_2
	call InitSceneObjParams

	ld hl, wSceneObj8
	ld de, .data_3
	call InitSceneObjParams

	ld hl, wSceneObj9
	ld de, .data_4
	call InitSceneObjParams

	ld hl, wSceneObj10
	ld de, .data_5
	call InitSceneObjParams

	ld hl, wSceneObj5Attributes
	set 2, [hl]
	ld hl, wSceneObj8Attributes
	set 2, [hl]
	ld hl, wSceneObj9Attributes
	set 2, [hl]
	ld hl, wSceneObj10Attributes
	set 2, [hl]

	farcall ClearBGPriorityBottomLeft
	farcall VBlank_Overworld

	decompress_tilemap OverworldBottomBarTreasuresTilemap, v0BGMap1
	decompress_attrmap OverworldBottomBarTreasuresAttrmap, v1BGMap1

	xor a
	ld [wWX], a
	ldh [rWX], a
	ld a, SCREEN_HEIGHT_PX
	ld [wWY], a
	ldh [rWY], a
	xor a ; BOTBAR_CLOSED
	ld [wBottomBarAction], a

	; copy empty treasure gfx
	ld hl, TreasureGfx
	ld de, v0Tiles1 tile $10
	ld c, 4 tiles
	ld b, BANK(TreasureGfx)
	jp CopyFarBytes

.data_1
	db $a0, $08, $22
.data_2
	db $a8, $18, $24
.data_3
	db $a8, $34, $24
.data_4
	db $a8, $50, $24
.data_5
	db $a8, $6c, $24

InitNOWObjects_DayNightSpell:
	ld a, $80
	cp c
	ret nz

	decompress_attrmap OverworldTopBarDayNightAttrmap, v1BGMap0, 29
	decompress_tilemap OverworldTopBarDayNightTilemap, v0BGMap0, 29

	hlbgcoord 0, 30
	debgcoord 0, 21, wAttrmap
	ld b, 2 * TILEMAP_WIDTH
	call CopyHLToDE

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	hlbgcoord 0, 30
	debgcoord 0, 19, wAttrmap
	ld b, 2 * TILEMAP_WIDTH
	call CopyHLToDE
	xor a
	ldh [rVBK], a

	ld hl, TopBarOBPals
	ld de, wTempPals2 palette 4
	ld c, 4 palettes
	ld b, BANK(TopBarOBPals)
	call CopyFarBytes

	ld hl, wSceneObj5
	ld de, .data
	call InitSceneObjParams

	farcall VBlank_Overworld
	farcall DrawCoinCount

	xor a
	ld [wSceneObj6State], a
	ld [wSceneObj7State], a
	ld [wSceneObj2State], a
	ret

.data
	db $00, $60, $00

InitNOWObjects_Prologue:
	ld a, [wTransitionParam]
	cp TRANSITION_EPILOGUE_NOT_PERFECT
	jr z, .continue
	cp TRANSITION_EPILOGUE_PERFECT
	jr z, .continue
	ret
.continue
	xor a
	ld hl, wSceneObj1
	ld bc, 15 * 8
	call WriteAToHL_BCTimes
	ld hl, wSceneObj1
	ld de, .data
	jp InitSceneObjParams
.data
	db $28, $50, 00

InitOWObjects_West:
	ld a, [wOWSceneActionParam]
	jumptable

	dw InvalidOWSceneAction
	dw InitWOWObjects_Rain ; WOWFUNC_RAIN
	dw InitWOWObjects_ClearTornado ; WOWFUNC_CLEAR_TORNADO
	dw InitWOWObjects_ElevatorWorking ; WOWFUNC_ELEVATOR_WORKING
	dw InitWOWObjects_MagicSeed ; WOWFUNC_MAGIC_SEED
	dw InitWOWObjects_SummonSnake ; WOWFUNC_SUMMON_SNAKE
	dw InitWOWObjects_Earthquake ; WOWFUNC_EARTHQUAKE
	dw InitWOWObjects_VulcanoEruption ; WOWFUNC_VULCANO_ERUPTION
	dw InitWOWObjects_RedMusicBox ; WOWFUNC_RED_MUSIC_BOX

InitWOWObjects_Rain:
	ld a, c
	cp $80
	jr z, .asm_b4339
	and a
	ret z
	ld hl, WOWTilemapPatch_Rain
	farcall _ApplyOWTilemapPatches
	ret
.asm_b4339
	ld hl, wSceneObj15
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj14
	ld de, .data_2
	jp InitSceneObjParams

.data_1
	db $56, $5c, $00
.data_2
	db $3a, $5c, $03

InitWOWObjects_ClearTornado:
	dec c
	ret z
	ld hl, wSceneObj1
	ld de, .data
	jp InitSceneObjParams
.data
	db $44, $28, $02

InitWOWObjects_ElevatorWorking:
	ld hl, wSceneObj8
	ld de, .data_1
	call InitSceneObjParams
	ld a, [wEventUnlockState]
	add a
	ret z
	ld a, [wCurEvent]
	and a
	ret nz
	ld hl, wSceneObj7
	ld de, .data_2
	call InitSceneObjParams
	ld a, [wOWIsNight]
	and a
	ld a, $06
	jr z, .asm_b4385
	ld a, $08
.asm_b4385
	ld [wSceneObj8State], a
	ret

.data_1
	db $3b, $80, $09
.data_2
	db $3b, $80, $00

InitWOWObjects_MagicSeed:
	ld a, c
	and a
	ret z
	ld hl, wSceneObj4
	ld de, .data_2
	cp $80
	jr nz, .asm_b439f
	ld de, .data_1
.asm_b439f
	jp InitSceneObjParams

.data_1
	db $00, $68, $0a
.data_2
	db $5b, $60, $0e

InitWOWObjects_SummonSnake:
	ld a, c
	and a
	ret z
	dec c
	jr z, .asm_b43ce
	ld hl, wSceneObj1
	ld de, .data_1
	call InitSceneObjParams
	call .asm_b43ce
	xor a
	ld [wSceneObj5State], a
	hlbgcoord 16, 5, wAttrmap
	res B_BG_PRIO, [hl]
	hlbgcoord 16, 6, wAttrmap
	res B_BG_PRIO, [hl]
	hlbgcoord  0, 7, wAttrmap
	res B_BG_PRIO, [hl]
	ret
.asm_b43ce
	ld hl, wSceneObj5
	ld de, .data_2
	jp InitSceneObjParams

.data_1
	db $32, SCREEN_WIDTH_PX, $12
.data_2
	db $3a, $2e, $13

InitWOWObjects_Earthquake:
	ld a, c
	and a
	ret z
	dec a
	jr nz, .asm_b43e9
	ld hl, WOWTilemapPatch_Earthquake
	jp ApplyOWTilemapPatches
.asm_b43e9
	ld hl, wSceneObj11
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj12
	ld de, .data_2
	call InitSceneObjParams
	ld hl, wSceneObj13
	ld de, .data_3
	call InitSceneObjParams
	ld hl, wSceneObj14
	ld de, .data_4
	call InitSceneObjParams
	ld hl, wSceneObj15
	ld de, .data_5
	call InitSceneObjParams
	ld hl, wSceneObj10
	ld de, .data_6
	call InitSceneObjParams

	ld hl, .pal
	ld de, wTempPals2 palette 2
	ld b, 1 palettes
	call CopyHLToDE

	jp LoadOverworldRocksGfx

.data_1
	db $10, $54, $18
.data_2
	db $3c, $4b, $00
.data_3
	db $3c, $51, $00
.data_4
	db $3c, $57, $00
.data_5
	db $3c, $5d, $00
.data_6
	db $52, $5c, $00

	db $00 ; unused

.pal
	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 25,  8, 31
	rgb  5,  5,  7

InitWOWObjects_VulcanoEruption:
	ld a, c
	and a
	ret z
	sla a
	jr c, .asm_b4455
.asm_b444f
	ld hl, WOWTilemapPatch_VulcanoEruption
	jp ApplyOWTilemapPatches
.asm_b4455
	ld a, [wOWSceneActionParam]
	ld b, a
	ld a, [wTempUnlockableConnectionID]
	cp b
	jr nz, .asm_b444f
	ld hl, wSceneObj11
	ld de, InitWOWObjects_Earthquake.data_1
	call InitSceneObjParams
	ld hl, wSceneObj10
	ld de, InitWOWObjects_Earthquake.data_6
	call InitSceneObjParams
	jp LoadOverworld4Gfx

InitWOWObjects_RedMusicBox:
	ld a, c
	and a
	ret z
	call LoadOverworld3Gfx
	ld hl, wSceneObj6
	ld de, .data
	call InitSceneObjParams
	ld a, [wEventUnlockState]
	add a
	jr z, .asm_b448f
	ld hl, WOWTilemapPatch_RedMusicBox
	jp ApplyOWTilemapPatches
.asm_b448f
	xor a
	ld [wSceneObj6State], a
	ld hl, wSceneObj6YCoord
	inc [hl]
	ret

.data
	db $78, $3c, $23

InitOWObjects_South:
	ld a, [wOWSceneActionParam]
	jumptable

	dw InvalidOWSceneAction
	dw InitSOWObjects_SendSeeds ; SOWFUNC_SEND_SEEDS
	dw InitSOWObjects_MagicSeed ; SOWFUNC_MAGIC_SEED
	dw InitSOWObjects_YellowMusicBox ; SOWFUNC_YELLOW_MUSIC_BOX
	dw InitSOWObjects_CanyonThunder ; SOWFUNC_CANYON_THUNDER
	dw InitSOWObjects_RaiseTower ; SOWFUNC_RAISE_TOWER
	dw InitSOWObjects_Fan ; SOWFUNC_FAN
	dw InitSOWObjects_SummonSnake ; SOWFUNC_SUMMON_SNAKE
	dw InitSOWObjects_Earthquake ; SOWFUNC_EARTHQUAKE
	dw InitSOWObjects_GreenMusicBox ; SOWFUNC_GREEN_MUSIC_BOX
	dw InitSOWObjects_Explosives ; SOWFUNC_EXPLOSIVES
	dw InitSOWObjects_FullMoon ; SOWFUNC_FULL_MOON

InitSOWObjects_SendSeeds:
	ld a, $80
	cp c
	ret nz
	ld a, [wOWSceneActionParam]
	ld hl, wTempUnlockableConnectionID
	cp [hl]
	ret nz
	ld hl, wSceneObj2
	ld de, .data_2
	call InitSceneObjParams
	ld hl, wSceneObj3
	ld de, .data_3
	call InitSceneObjParams
	ld hl, wSceneObj4
	ld de, .data_1
	jp InitSceneObjParams

.data_1
	db $38, $4c, $00
.data_2
	db $38, $44, $00
.data_3
	db $38, $54, $00

InitSOWObjects_MagicSeed:
	ld a, c
	and a
	ret z
	ld hl, wSceneObj4
	ld de, .data_2
	cp $80
	jr nz, .asm_b4500
	ld a, [wOWSceneActionParam]
	ld b, a
	ld a, [wTempUnlockableConnectionID]
	cp b
	ret nz
	ld de, .data_1
.asm_b4500
	jp InitSceneObjParams

.data_1
	db $00, $16, $05
.data_2
	db $56, $1a, $01

InitSOWObjects_YellowMusicBox:
	ld hl, wSceneObj6
	ld de, .data
	call InitSceneObjParams
	ld a, [wEventUnlockState]
	dec a
	ret nz
	ld hl, wSceneObj6State
	inc [hl]
	inc [hl]
	ret

.data
	db $3d, $31, $07

InitSOWObjects_CanyonThunder:
	ld a, $80
	cp c
	jr z, .asm_b4542
	dec c
	ret nz
	ld hl, SOWTilemapPatch_CanyonThunder
	farcall _ApplyOWTilemapPatches
.asm_b4539
	ld hl, wSceneObj5
	ld de, .data_3
	jp InitSceneObjParams
.asm_b4542
	ld hl, wSceneObj2
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj10
	ld de, .data_2
	call InitSceneObjParams
	call .asm_b4539
	xor a
	ld [wSceneObj5State], a
	jp LoadOverworldThunderGfx

.data_1
	db $48, $38, $00
.data_2
	db $3d, $2f, $00
.data_3
	db $68, $44, $0a

InitSOWObjects_RaiseTower:
	ld a, c
	dec a
	jr z, .asm_b459a
	sla c
	ret nc

	ld hl, wSceneObj2
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj3
	ld de, .data_2
	call InitSceneObjParams

	ld b, 3
	ld de, TILEMAP_WIDTH - 1
	hlbgcoord 14, 9, wAttrmap
.loop
	set B_BG_PRIO, [hl]
	inc hl
	set B_BG_PRIO, [hl]
	add hl, de
	dec b
	jr nz, .loop
	jp LoadOverworldTowerGfx

.data_1
	db $49, $78, $00
.data_2
	db $50, $78, $0c

.asm_b459a
	ld hl, SOWTilemapPatch_RaiseTower
	farcall _ApplyOWTilemapPatches
	ld a, [wCurEvent]
	and a
	ret nz
	ld hl, wSceneObj15
	ld de, .data_3
	call InitSceneObjParams
	ld a, [wOWIsNight]
	and a
	ret z
	ld a, $1e
	ld [wSceneObj15State], a
	ret

.data_3
	db $29, $78, $1f

InitSOWObjects_Fan:
	ld a, c
	and a
	jr z, .asm_b45e3
	dec a
	ret z
	ld hl, wSceneObj1
	ld de, .data_2
	call InitSceneObjParams
	ld hl, wSceneObj8
	ld de, .data_3
	call InitSceneObjParams
	call LoadOverworldFanGfx
.asm_b45e3
	ld hl, wSceneObj9
	ld de, .data_1
	jp InitSceneObjParams

.data_1
	db $4d, $8a, $10
.data_2
	db $5c, $82, $00
.data_3
	db $64, $78, $19

InitSOWObjects_SummonSnake:
	ld a, c
	and a
	ret z
	dec c
	jr z, .asm_b460c
	ld hl, wSceneObj1
	ld de, .data_1
	call InitSceneObjParams
	call .asm_b460c
	xor a
	ld [wSceneObj7State], a
	ret
.asm_b460c
	ld hl, wSceneObj7
	ld de, .data_2
	jp InitSceneObjParams

.data_1
	db $37, SCREEN_WIDTH_PX, $16
.data_2
	db $3f, $10, $1d

InitSOWObjects_Earthquake:
	ld a, c
	and a
	ret z
	sla c
	jr c, .asm_b4628
	ld hl, SOWTilemapPatch_Earthquake
	jp ApplyOWTilemapPatches
.asm_b4628
	ld hl, wSceneObj2
	ld de, .data
	call InitSceneObjParams
	jp LoadOverworldThunderGfx

.data
	db $5f, $3d, $00

InitSOWObjects_GreenMusicBox:
	ld a, c
	and a
	ret z
	sla c
	jr c, .asm_b4644
	ld hl, SOWTilemapPatch_GreenMusicBox
	jp ApplyOWTilemapPatches
.asm_b4644
	ld hl, wSceneObj2
	ld de, .data
	call InitSceneObjParams
	jp LoadOverworldThunderGfx

.data
	db $20, $48, $00

InitSOWObjects_Explosives:
	sla c
	ret nc
	ld hl, wSceneObj2
	ld de, .data
	call InitSceneObjParams
	jp LoadOverworldExplosion1Gfx

.data
	db $20, $44, $00

InitSOWObjects_FullMoon:
	xor a
	cp c
	ret z
	ld hl, wSceneObj14
	ld de, .data
	call InitSceneObjParams
	ld a, $80
	cp c
	ret z
	ld a, [wOWIsNight]
	and a
	ret z
	ld a, $80
	ld [wSceneObj14XCoord], a
	ld a, $15
	ld [wSceneObj14YCoord], a
	ret

.data
	db $25, $70, $20

InitOWObjects_East:
	ld a, [wOWSceneActionParam]
	jumptable

	dw InvalidOWSceneAction
	dw InitEOWObjects_FreezeSea ; EOWFUNC_FREEZE_SEA
	dw InitEOWObjects_Earthquake ; EOWFUNC_EARTHQUAKE
	dw InitEOWObjects_FormCastle ; EOWFUNC_FORM_CASTLE
	dw InitEOWObjects_Explosives ; EOWFUNC_EXPLOSIVES
	dw InitEOWObjects_VulcanoEruption ; EOWFUNC_VULCANO_ERUPTION
	dw InitEOWObjects_BurnVines ; EOWFUNC_BURN_VINES
	dw InitEOWObjects_ShowWarpedVoid ; EOWFUNC_SHOW_WARPED_VOID
	dw InitEOWObjects_RaisePipe ; EOWFUNC_RAISE_PIPE
	dw InitEOWObjects_Daytime ; EOWFUNC_DAYTIME

InitEOWObjects_FreezeSea:
	ld a, c
	add a
	call z, LoadUnfrozenSeaPal
	ld a, $80
	cp c
	jr z, .asm_b46cd
	dec c
	ret nz

	xor a
	ld [wOWSeaAnimDuration], a
	ld [wOWCliffsAnimDuration], a

	hlbgcoord 15, 10, OWSceneFreezeSeaTilemap
	debgcoord 15, 10, wTilemap
	ld c, $91
	ld b, BANK(OWSceneFreezeSeaTilemap)
	call CopyFarBytes
	hlbgcoord 15,  0, OWSceneFreezeSeaAttrmap
	debgcoord 15, 10, wAttrmap
	ld c, $91
	ld b, BANK(OWSceneFreezeSeaAttrmap)
	jp CopyFarBytes

.asm_b46cd
	ld hl, wSceneObj1
	ld de, .data
	jp InitSceneObjParams

.data
	db $64, $e8, $01

InitEOWObjects_Earthquake:
	ld a, c
	and a
	jr z, .asm_b46e7
	cp $80
	jr z, .asm_b46f0
	ld hl, EOWTilemapPatch_Earthquake
	jp ApplyOWTilemapPatches
.asm_b46e7
	ld hl, wSceneObj6
	ld de, .data_1
	jp InitSceneObjParams

.asm_b46f0
	call .asm_b46e7
	ld hl, wSceneObj15
	ld de, .data_2
	call InitSceneObjParams

	hlbgcoord 3, 10, wAttrmap
	ld b, 4
	call SetBGMapBytesPriority
	hlbgcoord 3, 11, wAttrmap
	ld b, 4
	jp SetBGMapBytesPriority

.data_1
	db $55, $28, $02
.data_2
	db $10, $5c, $07

InitEOWObjects_FormCastle:
	ld a, c
	and a
	ret z
	call .InitDayNightObj7
	ld a, $80
	cp c
	jr z, .asm_b4741

	ld hl, EOWTilemapPatch_FormCastle1
	call ApplyOWTilemapPatches
	ld hl, EOWTilemapPatch_FormCastle2
	call ApplyOWTilemapPatches
	ld hl, EOWTilemapPatch_FormCastle3
	call ApplyOWTilemapPatches
	ld hl, EOWTilemapPatch_FormCastle4
	call ApplyOWTilemapPatches
	ld hl, EOWTilemapPatch_FormCastle5
	call ApplyOWTilemapPatches
	ld hl, EOWTilemapPatch_FormCastle6
	jp ApplyOWTilemapPatches

.asm_b4741
	ld hl, wSceneObj1
	ld de, .data_1
	call InitSceneObjParams
	xor a
	ld [wSceneObj7State], a
	jp LoadOverworldExplosion2Gfx

.data_1
	db $3f, $1c, $00

.data_2
	db $28, $28, $12

.InitDayNightObj7:
	ld a, [wTempOWSceneAction]
	cp UNLOCK_LEVEL
	ret z
	ld hl, wSceneObj7
	ld de, .data_2
	call InitSceneObjParams
	ld a, [wOWIsNight]
	and a
	ret nz
	ld a, $13
	ld [wSceneObj7State], a
	ret

InitEOWObjects_Explosives:
	sla c
	ret nc
	ld hl, wSceneObj2
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj1
	ld de, .data_2
	call InitSceneObjParams
	call LoadOverworldExplosion3Gfx
	jp LoadOverworldSmokeGfx

.data_1
	db $54, $22, $00
.data_2
	db $4C, $48, $00

InitEOWObjects_VulcanoEruption:
	ld a, c
	and a
	ret z
	sla c
	jr nc, .asm_b47dc
	ld a, [wOWSceneActionParam]
	ld b, a
	ld a, [wTempUnlockableConnectionID]
	cp b
	jr nz, .asm_b47dc

	ld hl, wSceneObj10
	ld de, .data_1
	call InitSceneObjParams
	ld hl, wSceneObj12
	ld de, .data_3
	call InitSceneObjParams
	ld hl, wSceneObj13
	ld de, .data_4
	call InitSceneObjParams
	ld hl, wSceneObj14
	ld de, .data_5
	call InitSceneObjParams
	ld hl, wSceneObj15
	ld de, .data_6
	call InitSceneObjParams
	ld hl, wSceneObj11
	ld de, .data_7
	call InitSceneObjParams

	call LoadOverworldFireGfx

.asm_b47dc
	ld hl, EOWTilemapPatch_VulcanoEruption
	jp ApplyOWTilemapPatches

.data_1
	db $54, $78, $09
.data_2 ; unused
	db $3a, $70, $09
.data_3
	db $58, $44, $0c
.data_4
	db $44, $3c, $0c
.data_5
	db $3d, $45, $0f
.data_6
	db $3e, $74, $0f
.data_7
	db $10, $5c, $1e

InitEOWObjects_BurnVines:
	ld a, c
	dec c
	ret z
	and a
	jr z, .asm_b480c
	call .asm_b480c
	ld hl, wSceneObj1
	ld de, .data_2
	call InitSceneObjParams
	jp LoadOverworldTorchGfx
.asm_b480c
	ld hl, wSceneObj9
	ld de, .data_1
	jp InitSceneObjParams

.data_1
	db $45, $87, $17
.data_2
	db $45, $87, $00

InitEOWObjects_ShowWarpedVoid:
	ld a, c
	and a
	ret z
	ld hl, wSceneObj5
	ld de, .data
	call InitSceneObjParams
	sla c
	ret nc
	xor a
	ld [wSceneObj5State], a
	ret

.data
	db $60, $88, $19

InitEOWObjects_RaisePipe:
	ld a, c
	and a
	ret z
	dec c
	jr z, .asm_b4864
	call .asm_b4864
	ld a, [wSceneObj8YCoord]
	add $08
	ld [wSceneObj8YCoord], a
	ld hl, wSceneObj2
	ld de, .data_2
	call InitSceneObjParams
	hlbgcoord 14, 7, wAttrmap
	ld b, 3
	call SetBGMapBytesPriority
	hlbgcoord 14, 8, wAttrmap
	ld b, 3
	call SetBGMapBytesPriority
	hlbgcoord 14, 9, wAttrmap
	ld b, 2
	jp SetBGMapBytesPriority

.asm_b4864
	ld hl, wSceneObj8
	ld de, .data_1
	jp InitSceneObjParams

.data_1
	db $37, $7c, $1c
.data_2
	db $40, $7c, $21

InitEOWObjects_Daytime:
	ret

LoadUnfrozenSeaPal:
	ld hl, .pal
	ld de, wTempPals1 palette 4
	ld b, 1 palettes
	jp CopyHLToDE

.pal
	rgb 16, 14, 23
	rgb  0, 10, 18
	rgb  0,  0,  0
	rgb  3,  0,  3

; sets the coords and state
; of SceneObj in hl, with params in de
InitSceneObjParams:
	ld a, [de]
	ld [hli], a ; y
	inc de
	ld a, [de]
	ld [hli], a ; x
	inc l
	inc l
	xor a
	ld [hli], a ; duration
	ld [hli], a ; frameset offset
	inc de
	ld a, [de]
	ld [hl], a ; state
	ret

; unreferenced
UnreferencedPlaceOWTile:
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hld], a
	call GetOWCoordInTilemap
	inc de
	ld a, [de]
	ld [hl], a
	dec h
	dec h
	dec h
	inc de
	ld a, [de]
	ld [hl], a
	ret

; sets the priority bit of b bytes
; starting from hl in BGMap
SetBGMapBytesPriority:
.loop
	set B_BG_PRIO, [hl]
	inc hl
	dec b
	jr nz, .loop
	ret

LoadOverworld3Gfx:
	decompress_tiles0 Overworld3Gfx, v0Tiles0
	ret

LoadOverworld4Gfx:
	decompress_tiles0 Overworld4Gfx, v0Tiles0
	ret

LoadOverworldRocksGfx:
	decompress_tiles0 OverworldRocksGfx, v0Tiles0, $58
	ret

LoadOverworldTowerGfx:
	decompress_tiles0 OverworldTowerGfx, v0Tiles0, $60
	ret

LoadOverworldFanGfx:
	decompress_tiles0 OverworldFanGfx, v0Tiles0, $60
	ret

LoadOverworldExplosion1Gfx:
	decompress_tiles0 OverworldExplosion1Gfx, v0Tiles0
	ret

LoadOverworldThunderGfx:
	decompress_tiles0 OverworldThunderGfx, v0Tiles0
	ret

LoadOverworldExplosion2Gfx:
	decompress_tiles0 OverworldExplosion2Gfx, v0Tiles0
	ret

LoadOverworldTorchGfx:
	decompress_tiles0 OverworldTorchGfx, v0Tiles0, $40
	ret

LoadOverworldFireGfx::
	decompress_tiles0 OverworldFireGfx, v0Tiles0
	ret

LoadOverworldExplosion3Gfx:
	decompress_tiles0 OverworldExplosion3Gfx, v0Tiles0
	ret

LoadOverworldSmokeGfx:
	decompress_tiles0 OverworldSmokeGfx, v0Tiles0, $32
	ret

UpdateCurOWObjAnimation:
	ld b, $2a
	ld a, [wCurSceneObjPtr + 0]
	ld l, a
	set 2, l
	ld a, [wCurSceneObjPtr + 1]
	ld h, a
	jp UpdateOWAnimation

SetOWObjStateIfAnimFinished:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	set 2, l
	xor a
	ld [hli], a ; duration
	ld [hli], a ; frameset offset
	ld a, b
	ld [hl], a ; unk6
	ld b, h
	ld c, l
	ret

LoadCurSceneObjSpriteWithScroll:
	ld b, $2a
	ld a, [wCurSceneObjPtr + 0]
	ld l, a
	ld a, [wCurSceneObjPtr + 1]
	ld h, a
	jp LoadOWSpriteWithScroll

LoadCurSceneObjSprite:
	ld b, $2a
	ld a, [wCurSceneObjPtr + 0]
	ld l, a
	ld a, [wCurSceneObjPtr + 1]
	ld h, a
	jp LoadOWSprite

UpdateMapSideOWObjs:
	call UpdateMapSideOWObjs_Front
	jp UpdateMapSideOWObjs_Back

UpdateMapSideOWObjs_Front:
	ld a, [wCurMapSide]
	jumptable

	dw .North ; NORTH
	dw .West  ; WEST
	dw .South ; SOUTH
	dw .East  ; EAST

.North:
	ld bc, wSceneObj1State
	call UpdateNorthOWObj
	ld bc, wSceneObj2State
	call UpdateNorthOWObj
	ld bc, wSceneObj3State
	call UpdateNorthOWObj
	ld bc, wSceneObj4State
	jp UpdateNorthOWObj

.West:
	ld bc, wSceneObj1State
	call UpdateWestOWObj
	ld bc, wSceneObj2State
	call UpdateWestOWObj
	ld bc, wSceneObj3State
	call UpdateWestOWObj
	ld bc, wSceneObj4State
	jp UpdateWestOWObj

.South:
	ld bc, wSceneObj1State
	call UpdateSouthOWObj
	ld bc, wSceneObj2State
	call UpdateSouthOWObj
	ld bc, wSceneObj3State
	call UpdateSouthOWObj
	ld bc, wSceneObj4State
	jp UpdateSouthOWObj

.East:
	ld bc, wSceneObj1State
	call UpdateEastOWObj
	ld bc, wSceneObj2State
	call UpdateEastOWObj
	ld bc, wSceneObj3State
	call UpdateEastOWObj
	ld bc, wSceneObj4State
	jp UpdateEastOWObj

UpdateMapSideOWObjs_Back:
	ld a, [wCurMapSide]
	jumptable

	dw .North ; NORTH
	dw .West  ; WEST
	dw .South ; SOUTH
	dw .East  ; EAST

.North:
	ld bc, wSceneObj5State
	call UpdateNorthOWObj
	ld bc, wSceneObj6State
	call UpdateNorthOWObj
	ld bc, wSceneObj7State
	call UpdateNorthOWObj
	ld bc, wSceneObj8State
	call UpdateNorthOWObj
	ld bc, wSceneObj9State
	call UpdateNorthOWObj
	ld bc, wSceneObj10State
	call UpdateNorthOWObj
	ld bc, wSceneObj13State
	call UpdateNorthOWObj
	ld bc, wSceneObj14State
	call UpdateNorthOWObj
	ld bc, wSceneObj15State
	jp UpdateNorthOWObj

.West:
	ld bc, wSceneObj5State
	call UpdateWestOWObj
	ld bc, wSceneObj6State
	call UpdateWestOWObj
	ld bc, wSceneObj7State
	call UpdateWestOWObj
	ld bc, wSceneObj8State
	call UpdateWestOWObj
	ld bc, wSceneObj10State
	call UpdateWestOWObj
	ld bc, wSceneObj11State
	call UpdateWestOWObj
	ld bc, wSceneObj12State
	call UpdateWestOWObj
	ld bc, wSceneObj13State
	call UpdateWestOWObj
	ld bc, wSceneObj14State
	call UpdateWestOWObj
	ld bc, wSceneObj15State
	jp UpdateWestOWObj

.South:
	ld bc, wSceneObj5State
	call UpdateSouthOWObj
	ld bc, wSceneObj6State
	call UpdateSouthOWObj
	ld bc, wSceneObj7State
	call UpdateSouthOWObj
	ld bc, wSceneObj8State
	call UpdateSouthOWObj
	ld bc, wSceneObj9State
	call UpdateSouthOWObj
	ld bc, wSceneObj10State
	call UpdateSouthOWObj
	ld bc, wSceneObj14State
	call UpdateSouthOWObj
	ld bc, wSceneObj15State
	jp UpdateSouthOWObj

.East:
	ld bc, wSceneObj5State
	call UpdateEastOWObj
	ld bc, wSceneObj6State
	call UpdateEastOWObj
	ld bc, wSceneObj7State
	call UpdateEastOWObj
	ld bc, wSceneObj8State
	call UpdateEastOWObj
	ld bc, wSceneObj9State
	call UpdateEastOWObj
	ld bc, wSceneObj10State
	call UpdateEastOWObj
	ld bc, wSceneObj11State
	call UpdateEastOWObj
	ld bc, wSceneObj12State
	call UpdateEastOWObj
	ld bc, wSceneObj13State
	call UpdateEastOWObj
	ld bc, wSceneObj14State
	call UpdateEastOWObj
	ld bc, wSceneObj15State
	jp UpdateEastOWObj

UpdateEastOWObj:
	ld a, c
	and $f8
	ld hl, wCurSceneObjPtr
	ld [hli], a
	ld [hl], b
	ld a, [bc]
;	fallthrough

RunEastOWObjState:
	jumptable

	dw OWObjState_None
	dw EastOWObjState01
	dw EastOWObjState02
	dw EastOWObjState03
	dw EastOWObjState04
	dw EastOWObjState05
	dw EastOWObjState06
	dw EastOWObjState07
	dw EastOWObjState08
	dw EastOWObjState09
	dw EastOWObjState0a
	dw EastOWObjState0b
	dw EastOWObjState0c
	dw EastOWObjState0d
	dw EastOWObjState0e
	dw EastOWObjState0f
	dw EastOWObjState10
	dw EastOWObjState11
	dw EastOWObjState12
	dw EastOWObjState13
	dw EastOWObjState14
	dw EastOWObjState15
	dw EastOWObjState16
	dw EastOWObjState17
	dw EastOWObjState18
	dw EastOWObjState19
	dw EastOWObjState1a
	dw EastOWObjState1b
	dw EastOWObjState1c
	dw EastOWObjState1d
	dw EastOWObjState1e
	dw EastOWObjState1f
	dw EastOWObjState20
	dw EastOWObjState21
	dw EastOWObjState22

EastOWObjState01:
	ld de, EastOWObjFrameset_a9e61
	jr AnimateEastOWObj

EastOWObjState02:
	ld de, EastOWObjFrameset_a9e72
	jr AnimateEastOWObj

EastOWObjState03:
	ld de, EastOWObjFrameset_a9e75
	jr AnimateEastOWObj

EastOWObjState04:
	ld de, EastOWObjFrameset_a9e94
	jr AnimateEastOWObj

EastOWObjState05:
	ld de, EastOWObjFrameset_a9e7a
	jr AnimateEastOWObjOnce

EastOWObjState06:
	ld de, EastOWObjFrameset_a9e8c
	jr AnimateEastOWObj

EastOWObjState07:
	ld de, EastOWObjFrameset_a9e91
	jr AnimateEastOWObj

EastOWObjState08:
	ld de, EastOWObjFrameset_a9fd0
	jr AnimateEastOWObjOnce

EastOWObjState22:
	ld de, EastOWObjFrameset_a9e99
	jr AnimateEastOWObjOnce

EastOWObjState09:
	ld de, EastOWObjFrameset_a9ed3
	jr AnimateEastOWObj

EastOWObjState0a:
	ld de, EastOWObjFrameset_a9eea
	call UpdateCurOWObjAnimation
	ld b, $0b
	jr AnimateEastOWObjThenSetState

EastOWObjState0b:
	ld de, EastOWObjFrameset_a9ef1
	jr AnimateEastOWObj

EastOWObjState0c:
	ld de, EastOWObjFrameset_a9ee3
	jr AnimateEastOWObj

EastOWObjState0d:
	ld de, EastOWObjFrameset_a9ef6
	call UpdateCurOWObjAnimation
	ld b, $0e
	jr AnimateEastOWObjThenSetState

EastOWObjState0e:
	ld de, EastOWObjFrameset_a9efd
	jr AnimateEastOWObj

EastOWObjState0f:
	ld de, EastOWObjFrameset_a9ee0
	jr AnimateEastOWObj

EastOWObjState10:
	ld de, EastOWObjFrameset_a9f02
	jr AnimateEastOWObj

EastOWObjState11:
	ld de, EastOWObjFrameset_a9f0d
	jr AnimateEastOWObj

EastOWObjState12:
	ld de, EastOWObjFrameset_a9ecd
	jr AnimateEastOWObj

EastOWObjState13:
	ld de, EastOWObjFrameset_a9ed0
	jr AnimateEastOWObj ; useless jump

AnimateEastOWObj:
	call UpdateCurOWObjAnimation
;	fallthrough
DrawEastOWObj:
	ld de, EastOWObjOAM_a980c
	jp LoadCurSceneObjSpriteWithScroll

AnimateEastOWObjOnce:
	call UpdateCurOWObjAnimation
	ld b, $00
;	fallthrough

AnimateEastOWObjThenSetState:
	call SetOWObjStateIfAnimFinished
	jp z, RunEastOWObjState
	jr DrawEastOWObj

EastOWObjState14:
	ld de, EastOWObjFrameset_a9eaa
	jr AnimateEastOWObj

EastOWObjState15:
	ld de, EastOWObjFrameset_a9eb3
	jr AnimateEastOWObj

EastOWObjState16:
	ld de, EastOWObjFrameset_a9ebc
	jr AnimateEastOWObj

EastOWObjState17:
	ld de, EastOWObjFrameset_a9ec5
	jr AnimateEastOWObj

EastOWObjState18:
	ld de, EastOWObjFrameset_a9ec8
	jr AnimateEastOWObjOnce

EastOWObjState19:
	ld de, EastOWObjFrameset_a9f36
	jr AnimateEastOWObj

EastOWObjState1a:
	ld de, EastOWObjFrameset_a9f47
	call UpdateCurOWObjAnimation
	ld b, $1b
	jr AnimateEastOWObjThenSetState

EastOWObjState1b:
	ld de, EastOWObjFrameset_a9f76
	call UpdateCurOWObjAnimation
	ld b, $19
	jr AnimateEastOWObjThenSetState

EastOWObjState1c:
	ld de, EastOWObjFrameset_a9fa7
	jr AnimateEastOWObj

EastOWObjState1d:
	ld de, EastOWObjFrameset_a9faa
	call UpdateCurOWObjAnimation
	ld b, $1c
	jr AnimateEastOWObjThenSetState

EastOWObjState1e:
	ld de, EastOWObjFrameset_a9fc9
	jr AnimateEastOWObj

EastOWObjState1f:
	ld de, EastOWObjFrameset_a9fbb
	jr AnimateEastOWObj

EastOWObjState20:
	ld de, EastOWObjFrameset_a9fc2
	jr AnimateEastOWObj

EastOWObjState21:
	ld de, EastOWObjFrameset_a9fdf
	jr AnimateEastOWObj

UpdateSouthOWObj:
	ld a, c
	and $f8
	ld hl, wCurSceneObjPtr
	ld [hli], a
	ld [hl], b
	ld a, [bc]
;	fallthrough

RunSouthOWObjState:
	jumptable

	dw OWObjState_None
	dw SouthOWObjState01
	dw SouthOWObjState02
	dw SouthOWObjState03
	dw SouthOWObjState04
	dw SouthOWObjState05
	dw SouthOWObjState06
	dw SouthOWObjState07
	dw SouthOWObjState08
	dw SouthOWObjState09
	dw SouthOWObjState0a
	dw SouthOWObjState0b
	dw SouthOWObjState0c
	dw SouthOWObjState0d
	dw SouthOWObjState0e
	dw SouthOWObjState0f
	dw SouthOWObjState10
	dw SouthOWObjState11
	dw SouthOWObjState12
	dw SouthOWObjState13
	dw SouthOWObjState14
	dw SouthOWObjState15
	dw SouthOWObjState16
	dw SouthOWObjState17
	dw SouthOWObjState18
	dw SouthOWObjState19
	dw SouthOWObjState1a
	dw SouthOWObjState1b
	dw SouthOWObjState1c
	dw SouthOWObjState1d
	dw SouthOWObjState1e
	dw OWObjState_None
	dw SouthOWObjState20

SouthOWObjState01:
	ld de, SouthOWObjFrameset_a96c0
	jp AnimateSouthOWObj

SouthOWObjState02:
	ld de, SouthOWObjFrameset_a968d
	call UpdateCurOWObjAnimation
	ld b, $01
	jp AnimateSouthOWObjThenSetState

SouthOWObjState03:
	ld de, SouthOWObjFrameset_a967d
	jp AnimateSouthOWObj

SouthOWObjState04:
	ld de, SouthOWObjFrameset_a9680
	jp AnimateSouthOWObj

SouthOWObjState05:
	ld de, SouthOWObjFrameset_a9674
	jp AnimateSouthOWObj

SouthOWObjState06:
	ld de, SouthOWObjFrameset_a9680
	call UpdateCurOWObjAnimation
	ld b, $03
	jp AnimateSouthOWObjThenSetState

SouthOWObjState07:
	ld de, SouthOWObjFrameset_a96af
	jr AnimateSouthOWObj

SouthOWObjState08:
	ld de, SouthOWObjFrameset_a96b2
	call UpdateCurOWObjAnimation
	ld b, $09
	jr AnimateSouthOWObjThenSetState

SouthOWObjState09:
	ld de, SouthOWObjFrameset_a96bd
	jr AnimateSouthOWObj

SouthOWObjState0a:
	ld de, SouthOWObjFrameset_a96d1
	jr AnimateSouthOWObj

SouthOWObjState0b:
	ld de, SouthOWObjFrameset_a969a
	jr AnimateSouthOWObj

SouthOWObjState0c:
	ld de, SouthOWObjFrameset_a96a3
	jr AnimateSouthOWObj

SouthOWObjState0d:
	ld de, SouthOWObjFrameset_a96a6
	jr AnimateSouthOWObj

SouthOWObjState0e:
	ld de, SouthOWObjFrameset_a96a9
	jr AnimateSouthOWObj

SouthOWObjState0f:
	ld de, SouthOWObjFrameset_a96ac
	jr AnimateSouthOWObj

SouthOWObjState10:
	ld de, SouthOWObjFrameset_a96d8
	jr AnimateSouthOWObj

SouthOWObjState11:
	ld de, SouthOWObjFrameset_a96e1
	jr AnimateSouthOWObjOnce

SouthOWObjState12:
	ld de, SouthOWObjFrameset_a96ea
	jr AnimateSouthOWObjOnce

SouthOWObjState13:
	ld de, SouthOWObjFrameset_a96ef
	call UpdateCurOWObjAnimation
	ld b, $15
	jr AnimateSouthOWObjThenSetState

SouthOWObjState14:
	ld de, SouthOWObjFrameset_a974a
	call UpdateCurOWObjAnimation
	ld b, $15
	jr AnimateSouthOWObjThenSetState

SouthOWObjState15:
	ld de, SouthOWObjFrameset_a979f
	jr AnimateSouthOWObj

SouthOWObjState16:
	ld de, SouthOWObjFrameset_a97a2
	jr AnimateSouthOWObj

SouthOWObjState17:
	ld de, SouthOWObjFrameset_a97ad
	jr AnimateSouthOWObjOnce

AnimateSouthOWObj:
	call UpdateCurOWObjAnimation
;	fallthrough

DrawSouthOWObj:
	ld de, SouthOWObjOAM_a9161
	jp LoadCurSceneObjSpriteWithScroll
;	fallthrough

AnimateSouthOWObjOnce:
	call UpdateCurOWObjAnimation
	ld b, $00
;	fallthrough

AnimateSouthOWObjThenSetState:
	call SetOWObjStateIfAnimFinished
	jp z, RunSouthOWObjState
	jr DrawSouthOWObj

SouthOWObjState18:
	ld de, SouthOWObjFrameset_a97e1
	jr AnimateSouthOWObj

SouthOWObjState19:
	ld de, SouthOWObjFrameset_a97ec
	jr AnimateSouthOWObj

SouthOWObjState1a:
	ld de, SouthOWObjFrameset_a97d4
	call UpdateCurOWObjAnimation
	ld a, [wOWAnimationFinished]
	cp $ff
	call z, PlaySFX12F
	ld de, SouthOWObjOAM_a9161
	jp LoadCurSceneObjSpriteWithScroll

PlaySFX12F:
	play_sfx SFX_12F
	ret

SouthOWObjState1b:
	ld de, SouthOWObjFrameset_a97c5
	jr AnimateSouthOWObjOnce

SouthOWObjState1c:
	ld de, SouthOWObjFrameset_a97ef
	jr AnimateSouthOWObjOnce

SouthOWObjState1d:
	ld de, SouthOWObjFrameset_a97b2
	call UpdateCurOWObjAnimation
	ld b, $15
	jr AnimateSouthOWObjThenSetState

SouthOWObjState1e:
	ld de, SouthOWObjFrameset_a97fe
	jr AnimateSouthOWObj

SouthOWObjState20:
	ld de, SouthOWObjFrameset_a9803
	jr AnimateSouthOWObj

UpdateWestOWObj:
	ld a, c
	and $f8
	ld hl, wCurSceneObjPtr
	ld [hli], a
	ld [hl], b
	ld a, [bc]
;	fallthrough

RunWestOWObjState:
	jumptable

	dw OWObjState_None
	dw WestOWObjState01
	dw WestOWObjState02
	dw WestOWObjState03
	dw WestOWObjState04
	dw WestOWObjState05
	dw WestOWObjState06
	dw WestOWObjState07
	dw WestOWObjState08
	dw WestOWObjState05
	dw WestOWObjState0a
	dw WestOWObjState0b
	dw WestOWObjState0c
	dw WestOWObjState0d
	dw WestOWObjState0e
	dw WestOWObjState0f
	dw WestOWObjState10
	dw WestOWObjState11
	dw WestOWObjState12
	dw WestOWObjState13
	dw WestOWObjState14
	dw WestOWObjState15
	dw WestOWObjState16
	dw WestOWObjState17
	dw WestOWObjState18
	dw WestOWObjState19
	dw WestOWObjState1a
	dw WestOWObjState1b
	dw WestOWObjState1c
	dw WestOWObjState1d
	dw WestOWObjState1e
	dw WestOWObjState1f
	dw WestOWObjState20
	dw WestOWObjState21
	dw WestOWObjState22
	dw WestOWObjState23

AnimateWestOWObj:
	call UpdateCurOWObjAnimation
;	fallthrough

DrawWestOWObj:
	ld de, WestOWObjOAM_a884a
	jp LoadCurSceneObjSpriteWithScroll

AnimateWestOWObjOnce:
	call UpdateCurOWObjAnimation
	ld b, $00
;	fallthrough

AnimateWestOWObjThenSetState:
	call SetOWObjStateIfAnimFinished
	jr z, RunWestOWObjState
	jr DrawWestOWObj

AnimateWestOWObj2:
	call UpdateCurOWObjAnimation
;	fallthrough

DrawWestOWObj2:
	ld de, WestOWObjOAM_a8f57
	jp LoadCurSceneObjSpriteWithScroll

; unreferenced
UnreferencedAnimateWestOWObj2Once:
	call UpdateCurOWObjAnimation
	ld b, $00
;	fallthrough

AnimateWestOWObj2ThenSetState:
	call SetOWObjStateIfAnimFinished
	jr z, RunWestOWObjState
	jr DrawWestOWObj2

WestOWObjState01:
	ld de, WestOWObjFrameset_a8de9
	jr AnimateWestOWObjOnce

WestOWObjState02:
	ld de, WestOWObjFrameset_a8de2
	jr AnimateWestOWObj

WestOWObjState03:
	ld de, WestOWObjFrameset_a8dd1
	jr AnimateWestOWObj

WestOWObjState04:
	ld de, WestOWObjFrameset_a8e1e
	jr AnimateWestOWObjOnce

WestOWObjState05:
	push bc
	ld de, WestOWObjFrameset_a8e29
	call UpdateCurOWObjAnimation
	pop hl
	ld a, [wOWIsNight]
	and a
	ld b, $00
	jr z, .asm_b4e9d
	ld b, $06
.asm_b4e9d
	set 0, l
	res 2, l
	ld [hl], b
	jr DrawWestOWObj

WestOWObjState06:
	ld de, WestOWObjFrameset_a8e2c
	jr AnimateWestOWObj

WestOWObjState07:
	ld de, WestOWObjFrameset_a8e5d
	call AnimateWestOWObjOnce
	ld a, [wSceneObj7State]
	and a
	ret nz
	ld [wSceneObj8Duration], a
	ld a, $08
	ld [wSceneObj8State], a
	ret

WestOWObjState08:
	ld de, WestOWObjFrameset_a8e6c
	jr AnimateWestOWObj

WestOWObjState0a:
	ld de, WestOWObjFrameset_a8df8
	jp AnimateWestOWObj

WestOWObjState0b:
	ld de, WestOWObjFrameset_a8e04
	call UpdateCurOWObjAnimation
	ld b, $0c
	jr AnimateWestOWObjThenSetState

WestOWObjState0c:
	ld de, WestOWObjFrameset_a8e01
	jp AnimateWestOWObj

WestOWObjState0d:
	ld de, WestOWObjFrameset_a8e11
	call UpdateCurOWObjAnimation
	ld b, $0e
	jp AnimateWestOWObjThenSetState

WestOWObjState0e:
	ld de, WestOWObjFrameset_a8f17
	jp AnimateWestOWObj

WestOWObjState0f:
	ld de, WestOWObjFrameset_a9090
	call UpdateCurOWObjAnimation
	ld b, $11
	jp AnimateWestOWObj2ThenSetState

WestOWObjState10:
	ld de, WestOWObjFrameset_a90eb
	call UpdateCurOWObjAnimation
	ld b, $11
	jp AnimateWestOWObj2ThenSetState

WestOWObjState11:
	ld de, WestOWObjFrameset_a9140
	jp AnimateWestOWObj2

WestOWObjState12:
	ld de, WestOWObjFrameset_a9143
	jp AnimateWestOWObj2

WestOWObjState13:
	ld de, WestOWObjFrameset_a914e
	call UpdateCurOWObjAnimation
	ld b, $11
	jp AnimateWestOWObj2ThenSetState

WestOWObjState14:
	ld de, WestOWObjFrameset_a8e9d
	jp AnimateWestOWObjOnce

WestOWObjState15:
	ld de, WestOWObjFrameset_a8eac
	jp AnimateWestOWObjOnce

WestOWObjState16:
	ld de, WestOWObjFrameset_a8eb7
	jp AnimateWestOWObjOnce

WestOWObjState17:
	ld de, WestOWObjFrameset_a8ec2
	jp AnimateWestOWObj

WestOWObjState18:
	ld de, WestOWObjFrameset_a8ec7
	jp AnimateWestOWObj

WestOWObjState19:
	ld de, WestOWObjFrameset_a8eca
	jp AnimateWestOWObj

WestOWObjState1a:
	ld de, WestOWObjFrameset_a8eca
	jp AnimateWestOWObjOnce

WestOWObjState1b:
	ld de, WestOWObjFrameset_a8ed3
	jp AnimateWestOWObj

WestOWObjState1c:
	ld de, WestOWObjFrameset_a8eda
	jp AnimateWestOWObj

WestOWObjState1d:
	ld de, WestOWObjFrameset_a8ee1
	jp AnimateWestOWObj

WestOWObjState1e:
	ld de, WestOWObjFrameset_a8ee8
	call AnimateWestOWObj
;	fallthrough

UpdateWestOWPal5FromObj11:
	ld hl, wTempPals1 palette 5
	ld a, [wSceneObj11Frame]
	cp $57
	jr z, .asm_b4f6b
	ld a, [wSceneObj11State]
	and a
	jr z, .asm_b4f6b
	ld hl, .pal
.asm_b4f6b
	ld de, wTempBGPals palette 5
	ld b, 1 palettes
	call CopyHLToDE
	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hl], a
	ret

.pal
	rgb 12, 29,  0
	rgb 31, 31, 31
	rgb 31, 26,  2
	rgb 31,  0, 10

WestOWObjState1f:
	ld de, WestOWObjFrameset_a8ee8
	call AnimateWestOWObjOnce
	jr UpdateWestOWPal5FromObj11

WestOWObjState20:
	ld de, WestOWObjFrameset_a8f28
	jp AnimateWestOWObj

WestOWObjState21:
	ld de, WestOWObjFrameset_a8f31
	jp AnimateWestOWObj

WestOWObjState22:
	ld de, WestOWObjFrameset_a8f47
	jp AnimateWestOWObj

WestOWObjState23:
	ld de, WestOWObjFrameset_a8f3a
	jp AnimateWestOWObj

UpdateNorthOWObj:
	ld a, c
	and $f8
	ld hl, wCurSceneObjPtr
	ld [hli], a
	ld [hl], b
	ld a, [bc]
;	fallthrough

RunNorthOWObjState:
	jumptable

	dw OWObjState_None
	dw NorthOWObjState01
	dw NorthOWObjState02
	dw NorthOWObjState03
	dw NorthOWObjState04
	dw NorthOWObjState05
	dw NorthOWObjState06
	dw NorthOWObjState07
	dw NorthOWObjState08
	dw NorthOWObjState09
	dw NorthOWObjState0a
	dw NorthOWObjState0b
	dw NorthOWObjState0c
	dw NorthOWObjState0d
	dw NorthOWObjState0e
	dw NorthOWObjState0f
	dw NorthOWObjState10
	dw NorthOWObjState11
	dw NorthOWObjState12
	dw OWObjState_None
	dw NorthOWObjState14
	dw NorthOWObjState15
	dw NorthOWObjState16
	dw NorthOWObjState17
	dw NorthOWObjState18
	dw OWObjState_None
	dw NorthOWObjState1a
	dw OWObjState_None
	dw NorthOWObjState1c
	dw NorthOWObjState1d
	dw NorthOWObjState1e
	dw NorthOWObjState1f
	dw NorthOWObjState20
	dw NorthOWObjState21
	dw NorthOWObjState22
	dw NorthOWObjState23
	dw NorthOWObjState24
	dw NorthOWObjState25
	dw NorthOWObjState26
	dw NorthOWObjState27
	dw NorthOWObjState28
	dw NorthOWObjState29
	dw NorthOWObjState2a
	dw NorthOWObjState2b

NorthOWObjState01:
	ld de, NorthOWObjFrameset_a85cd
	jr AnimateNorthOWObj

NorthOWObjState02:
	ld de, NorthOWObjFrameset_a8590
	jr AnimateNorthOWObjOnce

NorthOWObjState03:
	ld de, NorthOWObjFrameset_a85d0
	jr AnimateNorthOWObj

NorthOWObjState04:
	ld de, NorthOWObjFrameset_a85d3
	jr AnimateNorthOWObjOnce

NorthOWObjState05:
	ld de, NorthOWObjFrameset_a862a
	jr AnimateNorthOWObj

NorthOWObjState06:
	ld de, NorthOWObjFrameset_a8653
	jr AnimateNorthOWObjOnce

NorthOWObjState07:
	ld de, NorthOWObjFrameset_a862d
	jr AnimateNorthOWObj

NorthOWObjState08:
	ld de, NorthOWObjFrameset_a8639
	call UpdateCurOWObjAnimation
	ld b, $09
	jr AnimateNorthOWObjThenSetState

NorthOWObjState09:
	ld de, NorthOWObjFrameset_a8636
	jr AnimateNorthOWObj

NorthOWObjState0a:
	ld de, NorthOWObjFrameset_a8646
	call UpdateCurOWObjAnimation
	ld b, $0b
	jr AnimateNorthOWObjThenSetState

NorthOWObjState0b:
	ld de, NorthOWObjFrameset_a866e
	jr AnimateNorthOWObj

NorthOWObjState0c:
	ld de, NorthOWObjFrameset_a867f
	call UpdateCurOWObjAnimation
	ld b, $0e
	jr AnimateNorthOWObjThenSetState

NorthOWObjState0d:
	ld de, NorthOWObjFrameset_a86da
	call UpdateCurOWObjAnimation
	ld b, $0e
	jr AnimateNorthOWObjThenSetState

NorthOWObjState0e:
	ld de, NorthOWObjFrameset_a872f
	jr AnimateNorthOWObj

NorthOWObjState0f:
	ld de, NorthOWObjFrameset_a8732
	jr AnimateNorthOWObj

NorthOWObjState10:
	ld de, NorthOWObjFrameset_a8750
	jr AnimateNorthOWObj

NorthOWObjState11:
	ld de, NorthOWObjFrameset_a8761
	jr AnimateNorthOWObj

NorthOWObjState12:
	ld de, NorthOWObjFrameset_a879a
	jr AnimateNorthOWObj

NorthOWObjState14:
	ld de, NorthOWObjFrameset_a8764
	jr AnimateNorthOWObj

NorthOWObjState15:
	ld de, NorthOWObjFrameset_a876f
	jr AnimateNorthOWObj

AnimateNorthOWObj:
	call UpdateCurOWObjAnimation
;	fallthrough

DrawNorthOWObj:
	ld de, NorthOWObjOAM_a8000
	jp LoadCurSceneObjSpriteWithScroll

AnimateNorthOWObjOnce:
	call UpdateCurOWObjAnimation
	ld b, $00
;	fallthrough

AnimateNorthOWObjThenSetState:
	call SetOWObjStateIfAnimFinished
	jp z, RunNorthOWObjState
	jp DrawNorthOWObj

NorthOWObjState16:
	ld de, NorthOWObjFrameset_a8782
	call UpdateCurOWObjAnimation
	ld b, $18
	jr AnimateNorthOWObjThenSetState

NorthOWObjState17:
	ld de, NorthOWObjFrameset_a8793
	call UpdateCurOWObjAnimation
	ld b, $19
	jr AnimateNorthOWObjThenSetState

NorthOWObjState18:
	ld de, NorthOWObjFrameset_a877a
	jr AnimateNorthOWObj

NorthOWObjState1a:
	ld de, NorthOWObjFrameset_a877d
	jr AnimateNorthOWObj

NorthOWObjState1c:
	ld de, NorthOWObjFrameset_a879f
	jr AnimateNorthOWObjOnce

NorthOWObjState1d:
	ld de, NorthOWObjFrameset_a873d
	call UpdateCurOWObjAnimation
	ld b, $0e
	jr AnimateNorthOWObjThenSetState

NorthOWObjState1e:
	ld de, NorthOWObjFrameset_a87d2
	call UpdateCurOWObjAnimation
	ld b, $20
	jr AnimateNorthOWObjThenSetState

NorthOWObjState1f:
	ld de, NorthOWObjFrameset_a87d9
	jr AnimateNorthOWObj

NorthOWObjState20:
	ld de, NorthOWObjFrameset_a87dc
	jr AnimateNorthOWObj

NorthOWObjState21:
	ld de, NorthOWObjFrameset_a87df
	jr AnimateNorthOWObj

NorthOWObjState22:
	ld de, NorthOWObjFrameset_aa5f5
	jr AnimateNorthOWObj3

NorthOWObjState23:
	ld de, NorthOWObjFrameset_aa5f8
;	fallthrough

AnimateNorthOWObj3:
	call UpdateCurOWObjAnimation
	ld de, CompassOAM_aa580
	jp LoadCurSceneObjSpriteWithScroll

NorthOWObjState24:
	ld de, NorthOWObjFrameset_aa252
	call UpdateCurOWObjAnimation
	ld de, OWUIOAM_aa0cf
	jp LoadCurSceneObjSpriteWithScroll

NorthOWObjState25:
	ld de, TopBarFrameset_aa0a3
	jr AnimateNorthOWObj2

NorthOWObjState26:
	ld de, TopBarFrameset_aa0c1
	call UpdateCurOWObjAnimation
	ld b, $27
	jr AnimateNorthOWObj2.set_state_when_finished

NorthOWObjState27:
	ld de, TopBarFrameset_aa09d
	jr AnimateNorthOWObj2

NorthOWObjState28:
	ld de, TopBarFrameset_aa0bc
	call UpdateCurOWObjAnimation
	ld b, $25
	jr AnimateNorthOWObj2.set_state_when_finished

AnimateNorthOWObj2:
	call UpdateCurOWObjAnimation
.draw
	ld de, TopBarOAM_a9fe2
	jp LoadCurSceneObjSpriteWithScroll

	call UpdateCurOWObjAnimation
	ld b, $00
.set_state_when_finished
	call SetOWObjStateIfAnimFinished
	jp z, RunNorthOWObjState
	jr .draw

NorthOWObjState29:
	ld de, NorthOWObjFrameset_a87e8
	jp AnimateNorthOWObj

NorthOWObjState2a:
	ld de, NorthOWObjFrameset_a87f1
	jp AnimateNorthOWObj

NorthOWObjState2b:
	ld de, NorthOWObjFrameset_a883b
	call UpdateCurOWObjAnimation
	ld b, $00
	call SetOWObjStateIfAnimFinished
	jp z, RunNorthOWObjState
	ld de, NorthOWObjOAM_a87fa
	jp LoadCurSceneObjSprite

_DoOWFunction:
	ld hl, wOWFuncCounter
	inc [hl]
	ld a, [wCurMapSide]
	jumptable

	dw NorthOWFunctions ; NORTH
	dw WestOWFunctions  ; WEST
	dw SouthOWFunctions ; SOUTH
	dw EastOWFunctions  ; EAST

NorthOWFunctions:
	ld a, [wOWSceneActionParam]
	dec a
	jumptable

	dw NOWFunc_CutTree       ; NOWFUNC_CUT_TREE
	dw NOWFunc_OpenGate      ; NOWFUNC_OPEN_GATE
	dw NOWFunc_Garlic        ; NOWFUNC_GARLIC
	dw NOWFunc_MagicSeed     ; NOWFUNC_MAGIC_SEED
	dw NOWFunc_SummonSnake   ; NOWFUNC_SUMMON_SNAKE
	dw NOWFunc_FallLeaves    ; NOWFUNC_FALL_LEAVES
	dw NOWFunc_PlayMusicBox  ; NOWFUNC_BLUE_MUSIC_BOX
	dw NOWFunc_PlayMusicBox  ; NOWFUNC_GOLD_MUSIC_BOX
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_RED
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_BROWN
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_YELLOW
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_GREEN
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_CYAN
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_BLUE
	dw NOWFunc_Crayon        ; NOWFUNC_CRAYON_PINK
	dw NOWFunc_BottomBar     ; NOWFUNC_BOTTOM_BAR
	dw NOWFunc_DayNightSpell ; NOWFUNC_DAY_NIGHT_SPELL
	dw NOWFunc_Prologue      ; NOWFUNC_PROLOGUE

NOWFunc_CutTree:
	ld a, [wOWFuncStep]
	jumptable

	dw AdvanceOWFunc
	dw .Wait4_1
	dw .SetTreeFall
	dw .WaitFall
	dw .WaitDisappear
	dw .Wait4_2
	dw EndOWFunc

.Wait4_1:
	ld a, 4
	jp WaitOWFunc

.Wait4_2:
	ld a, 4
	jp WaitOWFunc

.SetTreeFall:
	ld a, $02
	ld hl, wSceneObj8State
	call SetSceneObjState
	play_sfx SFX_TREE_FALL
	jp AdvanceOWFunc

.WaitFall:
	ld a, [wSceneObj8Frame]
	cp $07
	ret nz
	play_sfx SFX_OBJECT_HIT_WALL
	jp AdvanceOWFunc

.WaitDisappear:
	ld hl, wSceneObj8State
	jp WaitOWObjDisappear

NOWFunc_OpenGate:
	ld a, [wOWFuncStep]
	jumptable

	dw AdvanceOWFunc
	dw .Wait4_1
	dw .OpenDoor
	dw .WaitAnim
	dw .Wait4_2
	dw EndOWFunc

.Wait4_1:
	ld a, $04
	jp WaitOWFunc

.Wait4_2:
	ld a, $04
	jp WaitOWFunc

.OpenDoor:
	ld a, $04
	ld hl, wSceneObj10State
	call SetSceneObjState
	play_sfx SFX_GATE_OPEN
	jp AdvanceOWFunc

.WaitAnim:
	ld hl, wSceneObj10State
	jp WaitOWObjDisappear

NOWFunc_Garlic:
	jp EndOWFunc

NOWFunc_MagicSeed:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .PlayFallSFX
	dw .SeedFall
	dw .WaitSeedFall
	dw .Wait30
	dw .GrowStalk
	dw .WaitGrowStalk
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.PlayFallSFX:
	play_sfx SFX_ITEM_FALL
	jp AdvanceOWFunc

.SeedFall:
	ld hl, wOWFuncCounter
	call GetSceneFallingYOffset
	ld hl, wSceneObj4YCoord
	add [hl]
	ld [hl], a
	cp $4c
	ret c
	ld a, $08
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_STOMP
	jp AdvanceOWFunc

.WaitSeedFall:
	ld hl, wSceneObj4State
	ld b, $09
	jp WaitOWObjState

.Wait30:
	ld a, 30
	jp WaitOWFunc

.GrowStalk:
	ld a, $0a
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_BEANSTALK_GROW
	jp AdvanceOWFunc

.WaitGrowStalk:
	ld hl, wSceneObj4State
	ld b, $0b
	jp WaitOWObjState

NOWFunc_SummonSnake:
	call .MoveNotes
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait8
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .PlayFluteSFX
	dw .WaitNotesAndShowSnake
	dw .WaitSnakeComeOut
	dw .WaitSnakeComeIn
	dw EndOWFunc

.Wait8:
	ld a, 8
	jp WaitOWFunc

.PlayFluteSFX:
	ld a, $01
	ld [wSceneObj1MovementStep], a
	play_sfx SFX_FLUTE
	jp AdvanceOWFunc

.WaitNotesAndShowSnake:
	ld hl, wSceneObj1XCoord
	ld a, $25
	cp [hl]
	ret nz
	ld a, $0c
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_TEMPLE_ROCK
	jp AdvanceOWFunc

.WaitSnakeComeOut:
	ld a, [wSceneObj2Frame]
	cp $37
	ret nz
	jp AdvanceOWFunc

.WaitSnakeComeIn:
	ld a, [wSceneObj2Frame]
	cp $35
	ret nz
	jp AdvanceOWFunc

.MoveNotes:
	ld a, [wSceneObj1MovementStep]
	and a
	ret z
	ld hl, wSceneObj1XCoord
	dec [hl]
	ld a, [hl]
	add $18
	cp $f0
	ret c
	xor a
	ld [wSceneObj1MovementStep], a
	ret

NOWFunc_FallLeaves:
	call .HandleLeaf1Movement
	call .HandleLeaf3Movement
	call .HandleLeaf2Movement
	call .HandleLeaf4Movement

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .SetObj7State14
	dw .StartLeaf1MovementAndPlaySFX
	dw .Wait8
	dw .StartLeaf3Movement
	dw .WaitLeafMovement
	dw .Wait40
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.SetObj7State14:
	ld a, $14
	ld hl, wSceneObj7State
	call SetSceneObjState
	jp AdvanceOWFunc

.StartLeaf1MovementAndPlaySFX:
	ld a, $01
	ld [w2d12c], a
	play_sfx SFX_SPARKLE
	jp AdvanceOWFunc

.Wait8:
	ld a, 8
	jp WaitOWFunc

.StartLeaf3Movement:
	ld a, $01
	ld [w2d12e], a
	jp AdvanceOWFunc

.WaitLeafMovement:
	ld a, [w2d12e]
	and a
	ret nz
	jp AdvanceOWFunc

.HandleLeaf1Movement:
	ld hl, w2d12c
	ld a, [hli]
	and a
	ret z
	dec a
	jr z, .lift_leaf1
	dec a
	jp z, .blow_away_leaf1
	ret
.lift_leaf1
	ld de, FallLeavesLiftMovement
	ld hl, wSceneObj6
	call ApplyOWMovement
	ret nz ; hasn't finished movement

	ld hl, w2d12c
	inc [hl]
	ld a, $15
	ld hl, wSceneObj6State
	call SetSceneObjState
	ld a, $15
	ld hl, wSceneObj8State
	call SetSceneObjState
	ld a, $01
	ld [w2d130], a
	ld a, [wSceneObj6XCoord]
	dec a
	dec a
	ld [wSceneObj6XCoord], a
	ld a, [wSceneObj6YCoord]
	ld [wSceneObj8YCoord], a
	ld a, [wSceneObj6XCoord]
	inc a
	inc a
	inc a
	inc a
	inc a
	inc a
	ld [wSceneObj8XCoord], a
	ret

.blow_away_leaf1
	ld de, FallLeavesBlowAwayMovement
	ld hl, wSceneObj6
	call ApplyOWMovement
	ret nz
	xor a
	ld [w2d12c], a
	ret

.HandleLeaf2Movement:
	ld hl, w2d130
	ld a, [hli]
	and a
	ret z
	ld de, FallLeavesSplitMovement
	ld hl, wSceneObj8
	call ApplyOWMovement
	ret nz
	xor a
	ld [w2d130], a
	ret

.HandleLeaf3Movement:
	ld hl, w2d12e
	ld a, [hli]
	and a
	ret z
	dec a
	jr z, .lift_leaf3
	dec a
	jp z, .blow_away_leaf3
	ret
.lift_leaf3
	ld de, FallLeavesLiftMovement
	ld hl, wSceneObj7
	call ApplyOWMovement
	ret nz
	ld hl, w2d12e
	inc [hl]
	ld a, $15
	ld hl, wSceneObj7State
	call SetSceneObjState
	ld a, $15
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld a, $01
	ld [w2d132], a
	ld a, [wSceneObj7XCoord]
	dec a
	dec a
	ld [wSceneObj7XCoord], a
	ld a, [wSceneObj7YCoord]
	ld [wSceneObj9YCoord], a
	ld a, [wSceneObj7XCoord]
REPT 6
	inc a
ENDR
	ld [wSceneObj9XCoord], a
	play_sfx SFX_SPARKLE
	ret

.blow_away_leaf3
	ld de, FallLeavesBlowAwayMovement
	ld hl, wSceneObj7
	call ApplyOWMovement
	ret nz
	xor a
	ld [w2d12e], a
	ret

.HandleLeaf4Movement:
	ld hl, w2d132
	ld a, [hli]
	and a
	ret z
	ld de, FallLeavesSplitMovement
	ld hl, wSceneObj9
	call ApplyOWMovement
	ret nz
	xor a
	ld [w2d132], a
	ret

UpdateNorthLeaves:
	call .UpdateLeaf1
	call .UpdateLeaf2
	ret

.UpdateLeaf1:
	ld hl, w2d12c
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Leaf1_SetState12
	dw .Leaf1_SetState13
	dw .Leaf1_Reset
	dw .Leaf1_Wait90
	dw .Leaf1_Sink
	dw .Leaf1_Restart

.Leaf1_SetState12:
	ld a, [w2d12d]
	cp $78
	ret c
	ld a, $12
	ld hl, wSceneObj6State
	call SetSceneObjState
.asm_b5458
	ld hl, w2d12c
	inc [hl]
	xor a
	ld [w2d12d], a
	ret

.Leaf1_SetState13:
	ld a, [w2d12d]
	cp $5a
	ret c
	ld a, $13
	ld hl, wSceneObj6State
	call SetSceneObjState
	jr .asm_b5458

.Leaf1_Reset:
	ld a, [w2d12d]
	cp $28
	ret c
	ld a, $10
	ld hl, wSceneObj6State
	call SetSceneObjState
	ld a, $38
	ld [wSceneObj6YCoord], a
	jr .asm_b5458

.Leaf1_Wait90:
	ld a, [w2d12d]
	cp $5a
	ret c
	jr .asm_b5458

.Leaf1_Sink:
	ld a, [w2d12d]
	and $0f
	ret nz
	ld hl, wSceneObj6
	inc [hl]
	ld a, [hl]
	cp $48
	ret nz
	jr .asm_b5458

.Leaf1_Restart:
	ld hl, wSceneObj6Frame
	ld a, [hld]
	cp $46
	ret nz
	dec l
	ld a, [hl]
	and a
	ret z
	ld a, $11
	ld hl, wSceneObj6State
	call SetSceneObjState
	ld a, $01
	ld hl, w2d12c
	ld [hli], a
	xor a
	ld [hl], a
	ret

.UpdateLeaf2:
	ld hl, w2d12e
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Leaf2_SetState12
	dw .Leaf2_SetState13
	dw .Leaf2_Reset
	dw .Leaf2_Wait90
	dw .Leaf2_Sink
	dw .Leaf2_Restart

.Leaf2_SetState12:
	ld a, [w2d12f]
	cp $78
	ret c
	ld a, $12
	ld hl, wSceneObj7State
	call SetSceneObjState
.asm_b54dd
	ld hl, w2d12e
	inc [hl]
	xor a
	ld [w2d12f], a
	ret

.Leaf2_SetState13:
	ld a, [w2d12f]
	cp $5a
	ret c
	ld a, $13
	ld hl, wSceneObj7State
	call SetSceneObjState
	jr .asm_b54dd

.Leaf2_Reset:
	ld a, [w2d12f]
	cp $28
	ret c
	ld a, $10
	ld hl, wSceneObj7State
	call SetSceneObjState
	ld a, $38
	ld [wSceneObj7YCoord], a
	jr .asm_b54dd

.Leaf2_Wait90:
	ld a, [w2d12f]
	cp $5a
	ret c
	jr .asm_b54dd

.Leaf2_Sink:
	ld a, [w2d12f]
	and $0f
	ret nz
	ld hl, wSceneObj7
	inc [hl]
	ld a, [hl]
	cp $48
	ret nz
	jr .asm_b54dd

.Leaf2_Restart:
	ld hl, wSceneObj7Frame
	ld a, [hld]
	cp $46
	ret nz
	dec l
	ld a, [hl]
	and a
	ret z
	ld a, $11
	ld hl, wSceneObj7State
	call SetSceneObjState
	ld a, $01
	ld hl, w2d12e
	ld [hli], a
	xor a
	ld [hl], a
	ret

NOWFunc_PlayMusicBox:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw .PlayMusicBox
	dw .Wait254
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.PlayMusicBox:
	ld a, [wOWSceneActionParam]
	cp NOWFUNC_GOLD_MUSIC_BOX
	jr z, .gold_music_box
	play_sfx SFX_BLUE_MUSIC_BOX
	jp AdvanceOWFunc
.gold_music_box
	play_sfx SFX_GOLD_MUSIC_BOX
	jp AdvanceOWFunc

.Wait254:
	ld a, 254
	jp WaitOWFunc

NOWFunc_Crayon:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20_1
	dw .PlayFallSFX
	dw .CrayonFall
	dw .Wait4
	dw .CrayonLift
	dw .WaitCrayonLift
	dw .Wait10
	dw .Scribble
	dw .AdvanceIfCollectedAllCrayons
	dw .LoadNewOWPal
	dw .FadePal
	dw .Wait20_2
	dw EndOWFunc

.Wait20_1:
	ld a, 20
	jp WaitOWFunc

.Wait20_2:
	ld a, 20
	jp WaitOWFunc

.PlayFallSFX:
	play_sfx SFX_ITEM_FALL
	jp AdvanceOWFunc

.CrayonFall:
	ld hl, wOWFuncCounter
	call GetSceneFallingYOffset
	ld hl, wSceneObj5YCoord
	add [hl]
	ld [hl], a
	ld c, a
	add -6
	ld [wSceneObj1YCoord], a
	ld a, c
	cp $40
	ret c
	xor a
	ld [wSceneObj1State], a
	play_sfx SFX_STOMP
	jp AdvanceOWFunc

.Wait4:
	ld a, 4
	jp WaitOWFunc

.CrayonLift:
	ld a, $1e
	ld hl, wSceneObj5State
	call SetSceneObjState
	jp AdvanceOWFunc

.WaitCrayonLift:
	ld b, $20
	ld hl, wSceneObj5State
	jp WaitOWObjState

.Wait10:
	ld a, 10
	jp WaitOWFunc

.Scribble:
	ld de, CrayonScribbleMovement
	ld hl, wSceneObj5
	call ApplyOWMovement
	ld a, [wSceneObj5MovementStep]
	cp $0a
	jr z, .play_scribble_sfx
	and a
	ret nz
	jp AdvanceOWFunc
.play_scribble_sfx
	play_sfx SFX_CRAYON_SCRIBBLE
	ret

.AdvanceIfCollectedAllCrayons:
	ld a, [wCrayonFlags]
	and ALL_CRAYONS
	cp ALL_CRAYONS
	jp z, AdvanceOWFunc
	ld a, $0c
	ld [wOWFuncStep], a
	xor a
	ld [wOWFuncCounter], a
	ret

.LoadNewOWPal:
	ld hl, wTempPals1
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, NorthOWCrayonsDayPals
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(NorthOWCrayonsDayPals)
	call CopyFarBytes
	xor a
	ld [wPalConfig1TotalSteps], a
	jp AdvanceOWFunc

.FadePal:
	ld a, [wOWFuncCounter]
	and 7
	ret nz
	call OWFuncFadeBGPals
	ret

NOWFunc_BottomBar:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait40
	dw .LoadBottomBarPal
	dw .RaiseBBtnIndicator
	dw .Wait45
	dw .BlinkBBtnIndicator
	dw .StartOpenBottomBar
	dw .Wait10
	dw .OpenBottomBar
	dw .Wait60
	dw EndOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.LoadBottomBarPal:
	ld hl, NorthOWDayPals palette 7
	ld de, wTempPals1 palette 7
	ld b, BANK(NorthOWDayPals)
	ld c, 1 palettes
	call CopyFarBytes
	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	ld a, BGPI_AUTOINC | palette 7
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, HIGH(wTempPals1 palette 7)
	ld [hli], a
	ld a, LOW(wTempPals1 palette 7)
	ld [hli], a
	jp AdvanceOWFunc

.RaiseBBtnIndicator:
	ld a, [wOWFuncCounter]
	and $1
	ret nz
	ld hl, wSceneObj1
	dec [hl]
	ld a, [hl]
	cp $94
	ret nz
	play_sfx SFX_113
	jp AdvanceOWFunc

.Wait45:
	ld a, 45
	jp WaitOWFunc

.BlinkBBtnIndicator:
	ld a, [wOWFuncCounter]
	ld b, a
	bit 3, a
	ld a, $22
	jr z, .asm_b56b5
	ld a, $23
.asm_b56b5
	ld [wSceneObj1State], a
	ld a, 47
	cp b
	ret nc
	jp AdvanceOWFunc

.StartOpenBottomBar:
	ld a, [wOWFuncCounter]
	cp 45
	ret c
	ld a, $23
	ld [wSceneObj1State], a
	play_sfx SFX_113
	jp AdvanceOWFunc

.Wait10:
	ld a, 10
	jp WaitOWFunc

.OpenBottomBar:
	ld hl, wWY
	dec [hl]
	ld a, [hl]
	ld hl, wSceneObj1
	dec [hl]
	ld hl, wSceneObj5YCoord
	dec [hl]
	ld hl, wSceneObj8YCoord
	dec [hl]
	ld hl, wSceneObj9YCoord
	dec [hl]
	ld hl, wSceneObj10YCoord
	dec [hl]
	cp $78
	ret nz
	jp AdvanceOWFunc

NOWFunc_DayNightSpell:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait30
	dw WaitOWSceneLevelNameFadeIn
	dw .StartOpenTopBar
	dw .OpenTopBar
	dw .Wait40
	dw .SetButtonVisible
	dw .SetButtonInvisible
	dw .SetButtonVisible
	dw .SetButtonInvisible
	dw .SetButtonVisible
	dw .WaitAndPressDayButton
	dw .WaitDayButtonPress
	dw .DayNightTransition
	dw .WaitAndPressNightButton
	dw .WaitNightButtonPress
	dw .DayNightTransition
	dw .Wait60
	dw EndOWFunc

.Wait30:
	ld a, 30
	jp WaitOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.StartOpenTopBar:
	play_sfx SFX_MENU_OPEN
	call AdvanceOWFunc
;	fallthrough
.OpenTopBar:
	ld a, [wSCY]
	dec a
	dec a
	ld [wSCY], a
	cp $ec
	ret nz
	jp AdvanceOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.SetButtonVisible:
	ld a, [wOWFuncCounter]
	cp 20
	ret c
	ld a, $25
	ld hl, wSceneObj5State
	call SetSceneObjState
.show_visible_button
	ld hl, .visible_button_attr

.apply_attribute
	call .write_day_night_button
	call .copy_top_bar_to_vram
	jp AdvanceOWFunc

.SetButtonInvisible:
	ld a, [wOWFuncCounter]
	cp 20
	ret c
	ld a, $00
	ld hl, wSceneObj5State
	call SetSceneObjState
	ld hl, .invisible_button_attr
	jr .apply_attribute

.WaitAndPressDayButton:
	ld a, [wOWFuncCounter]
	cp 60
	ret c
	ld a, $26
	ld hl, wSceneObj5State
	call SetSceneObjState
.play_sfx_and_press_button
	play_sfx SFX_SELECTION
	ld hl, .pressed_button_attr
	jr .apply_attribute

.WaitDayButtonPress:
	ld a, [wSceneObj5Frame]
	cp $04
	ret nz
	jr .show_visible_button

.DayNightTransition:
	farcall DayNightSpellTransition
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	di
	farcall VBlank_Overworld
	ei
	jp AdvanceOWFunc

.WaitAndPressNightButton:
	ld a, [wOWFuncCounter]
	cp 60
	ret c
	ld a, $28
	ld hl, wSceneObj5State
	call SetSceneObjState
	jr .play_sfx_and_press_button

.WaitNightButtonPress:
	ld a, [wSceneObj5Frame]
	cp $06
	ret nz
	jp .show_visible_button

.visible_button_attr
	db $34, $35
	db $36, $37

	db $7 | BG_BANK1, $7 | BG_BANK1
	db $7 | BG_BANK1, $7 | BG_BANK1

.invisible_button_attr
	db $3e, $3e
	db $3f, $3f

	db $7 | BG_BANK1, $7 | BG_BANK1 | BG_XFLIP
	db $7 | BG_BANK1, $7 | BG_BANK1 | BG_XFLIP

.pressed_button_attr
	db $48, $49
	db $4a, $4b

	db $7 | BG_BANK1, $7 | BG_BANK1
	db $7 | BG_BANK1, $7 | BG_BANK1

.copy_top_bar_to_vram:
	ld a, HIGH(wAttrmap + 0 + 21 * TILEMAP_WIDTH)
	ld [wHDMASourceHi], a
	ld a, LOW(wAttrmap + 0 + 21 * TILEMAP_WIDTH)
	ld [wHDMASourceLo], a
	ld a, HIGH(v0BGMap0 + 0 + 30 * TILEMAP_WIDTH) - $80
	ld [wHDMADestHi], a
	ld a, LOW(v0BGMap0 + 0 + 30 * TILEMAP_WIDTH)
	ld [wHDMADestLo], a
	ld a, 2 dma_rows
	ld [wHDMAMode], a

	ld a, HIGH(wAttrmap + 0 + 19 * TILEMAP_WIDTH)
	ld [wHDMAVRAM1SourceHi], a
	ld a, LOW(wAttrmap + 0 + 19 * TILEMAP_WIDTH)
	ld [wHDMAVRAM1SourceLo], a
	ld a, HIGH(v0BGMap0 + 0 + 30 * TILEMAP_WIDTH) - $80
	ld [wHDMAVRAM1DestHi], a
	ld a, LOW(v0BGMap0 + 0 + 30 * TILEMAP_WIDTH)
	ld [wHDMAVRAM1DestLo], a
	ld a, 2 dma_rows
	ld [wHDMAVRAM1Mode], a
	ret

.write_day_night_button:
	debgcoord 11, 19, wAttrmap
	push de
	ld a, e
	add 2 * TILEMAP_WIDTH
	ld e, a
	ld a, $00
	adc d
	ld d, a
	; debgcoord 11, 21, wAttrmap
	ld c, 2
.loop
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	dec e
	ld a, e
	add TILEMAP_WIDTH
	ld e, a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	dec c
	ret z
	pop de
	jr .loop

; unreferenced
UnreferencedWaitOWFunc4:
	ld a, 4
;	fallthrough

WaitOWFunc:
	ld hl, wOWFuncCounter
	cp [hl]
	ret nc
AdvanceOWFunc:
	xor a
	ld hl, wOWFuncCounter
	ld [hli], a
	inc [hl]
	ret

WaitOWObjDisappear:
	ld b, $00
WaitOWObjState:
	ld a, [hl]
	cp b
	ret nz
	jr AdvanceOWFunc

EndOWFunc:
	xor a
	ld [wOWSceneActionParam], a
	ld hl, wOWFuncCounter
	ld [hli], a
	ld [hl], a ; wOWFuncStep
	ret

ApplyOWTilemapPatchesAndRedraw:
	ld a, TRUE
	ld [wOWPendingTileUpdate], a
;	fallthrough
ApplyOWTilemapPatches:
	farcall _ApplyOWTilemapPatches
	ret

OWFuncFadeBGPals:
	farcall _OWFuncFadeBGPals
	ret

OWFuncFadePals:
	farcall _OWFuncFadePals
	ret

GetSceneFallingYOffset:
	ld a, [hl]
	cp .yoffsets_end - .yoffsets
	jr c, .no_carry
	ld a, (.yoffsets_end - .yoffsets) - $4
	ld [hl], a
.no_carry
	ld e, a
	ld d, $00
	ld hl, .yoffsets
	add hl, de
	ld a, [hl]
	ret

.yoffsets
	db 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
	db 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
	db 0, 1, 0, 1, 0, 1, 0, 1, 0, 1
	db 0, 1, 0, 1, 1, 0, 1, 1, 0, 1
	db 1, 0, 1, 1, 0, 1, 1, 0, 1, 1
	db 0, 1, 1, 0, 1, 1, 0, 1, 1, 0
	db 1, 1, 0, 1, 1, 1, 0, 1, 1, 1
	db 0, 1, 1, 1, 0, 1, 1, 1, 0, 1
	db 1, 1, 0, 1, 1, 1, 0, 1, 1, 1
	db 0, 1, 1, 1, 1, 1, 1, 1, 1, 1
.yoffsets_end

NOWFunc_Prologue:
	call UpdateOWSceneScreenShake
	farcall UpdateNOWPrologueParticles
	call .PlaySparkleSFXEvery48Frames
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .StartShake
	dw .RequestShake4
	dw .WaitShake5ThenShowObj1
	dw .WaitShakeEnd
	dw .Wait86
	dw .StartObj2Particles
	dw .StartObj8Particles
	dw .StartObj5Particles
	dw .StartObj10Particles
	dw .StartObj9Particles
	dw .StartObj3Particles
	dw .Wait120
	dw .Wait120
	dw .StopSFXLoop

.StartShake:
	ld a, [wOWFuncCounter]
	cp 60
	ret c
	ld a, $01
	ld [wOWSceneShakeState], a
	ld a, $01
	ld [wOWSeaGfxVariant], a
	ld a, $03
	ld hl, wOWSeaAnim
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	jp AdvanceOWFunc

.RequestShake4:
	ld a, [wOWFuncCounter]
	cp 134
	ret c
	ld a, $04
	ld [wOWSceneShakeState], a
	jp AdvanceOWFunc

.WaitShake5ThenShowObj1:
	ld a, [wOWSceneShakeState]
	cp $05
	ret nz
	ld a, $2b
	ld hl, wSceneObj1State
	call SetSceneObjState
	play_sfx SFX_EARTHQUAKE
	jp AdvanceOWFunc

.WaitShakeEnd:
	ld a, [wOWSceneShakeState]
	and a
	ret nz
	ld hl, wOWSeaAnim
	ld a, $0e
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [wOWSeaGfxVariant], a
	jp AdvanceOWFunc

.Wait86:
	ld a, 86
	jp WaitOWFunc

.StartObj2Particles:
	ld a, [wOWFuncCounter]
	cp 6
	ret c
	ld a, $01
	ld [w2d150], a
	ld [wOWSceneSFXLoopActive], a
	jp AdvanceOWFunc

.StartObj3Particles:
	ld hl, w2d151
.asm_b59b9
	ld a, [wOWFuncCounter]
	cp 6
	ret c
	ld a, $01
	ld [hl], a
	jp AdvanceOWFunc

.StartObj5Particles:
	ld hl, wd152
	jr .asm_b59b9

.StartObj8Particles:
	ld hl, wd153
	jr .asm_b59b9

.StartObj9Particles:
	ld hl, wd154
	jr .asm_b59b9

.StartObj10Particles:
	ld hl, wd155
	jr .asm_b59b9

.Wait120:
	ld a, 120
	jp WaitOWFunc

.StopSFXLoop:
	xor a
	ld [wOWSceneSFXLoopActive], a
	jp EndOWFunc

.PlaySparkleSFXEvery48Frames:
	ld a, [wOWSceneSFXLoopActive]
	and a
	ret z
	ld hl, wOWSceneSFXLoopCounter
	inc [hl]
	ld a, [hl]
	cp $01
	jr z, .asm_b59f9
	cp $30
	ret c
	xor a
	ld [hl], a
	ret
.asm_b59f9
	play_sfx SFX_SPARKLE
	ret

WestOWFunctions:
	ld a, [wOWSceneActionParam]
	dec a
	jumptable
	dw WOWFunc_Rain            ; WOWFUNC_RAIN
	dw WOWFunc_ClearTornado    ; WOWFUNC_CLEAR_TORNADO
	dw WOWFunc_ElevatorWorking ; WOWFUNC_ELEVATOR_WORKING
	dw WOWFunc_MagicSeed       ; WOWFUNC_MAGIC_SEED
	dw WOWFunc_SummonSnake     ; WOWFUNC_SUMMON_SNAKE
	dw WOWFunc_Earthquake      ; WOWFUNC_EARTHQUAKE
	dw WOWFunc_VulcanoEruption ; WOWFUNC_VULCANO_ERUPTION
	dw WOWFunc_RedMusicBox     ; WOWFUNC_RED_MUSIC_BOX

WOWFunc_Rain:
	call .UpdatePals
	call .PlayThunderSFX

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .InitPalConfig
	dw .Wait180
	dw .ShowRainClouds
	dw .WaitRainClouds
	dw .FillPool
	dw .Wait120
	dw .WaitRainAndHideClouds
	dw .WaitCloudsDisappear
	dw .Wait60
	dw EndOWFunc

.PlayThunderSFX:
	ld hl, w2d13f
	ld a, [hl]
	and a
	ret z
	inc [hl]
	ld a, [hl]
	cp $1b
	ret c
	play_sfx SFX_THUNDER
	ld a, $01
	ld [hl], a
	ret

.Wait60:
	ld a, 60
	jp WaitOWFunc

.InitPalConfig:
	ld a, $5a
	ld [wPalConfig1TotalSteps], a
	ld a, $01
	ld [w2d13f], a
	jp AdvanceOWFunc

.Wait180:
	ld a, 180
	jp WaitOWFunc

.ShowRainClouds:
	ld a, $01
	ld hl, wSceneObj15State
	call SetSceneObjState
	jp AdvanceOWFunc

.WaitRainClouds:
	ld a, [wSceneObj15Frame]
	cp $0e
	ret nz
	jp AdvanceOWFunc

.FillPool:
	ld a, [wOWFuncCounter]
	cp 2
	ret c
	ld hl, WOWTilemapPatch_Rain
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.Wait120:
	ld a, 120
	jp WaitOWFunc

.WaitRainAndHideClouds:
	ld hl, wPalConfig1TotalSteps
	ld a, [hl]
	cp $3c
	ret c
	xor a
	ld [hl], a
	ld [w2d13f], a
	ld a, $04
	ld hl, wSceneObj14State
	call SetSceneObjState
	jp AdvanceOWFunc

.WaitCloudsDisappear:
	ld hl, wSceneObj14State
	jp WaitOWObjDisappear

.UpdatePals:
	ld a, [wPalConfig1TotalSteps]
	and a
	ret z
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, [hl]
	cp $09
	jr z, .pals_flash2
	cp $12
	jr z, .pals_flash1
	cp $16
	jr z, .pals_flash2
	cp $1a
	jr z, .pals_flash1
	cp $1e
	jr z, .pals_flash2
	cp $22
	jr z, .pals_flash1
	cp $26
	jr z, .pals_flash2
	cp $29
	jr z, .pals_flash1
	cp $2c
	jr z, .pals_regular
	cp $82
	ret c
	ld a, $01
	ld [hl], a
	ret

.pals_flash1
	ld hl, OWLightningFlashPals1
	jr .apply_pals
.pals_flash2
	ld hl, OWLightningFlashPals2
	jr .apply_pals
.pals_regular
	ld hl, WestOWDayPals
.apply_pals
	ld de, wTempPals1
	ld b, BANK(WestOWDayPals)
	ld c, 8 palettes
	call CopyFarBytes
	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	ld a, BGPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 1 palettes
	ld [hli], a
	ld a, HIGH(wTempPals1)
	ld [hli], a
	ld a, LOW(wTempPals1)
	ld [hli], a
	ret

WOWFunc_ClearTornado:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .ShowTornado
	dw .ClearTornado
	dw .HideTornado
	dw .Wait20
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.ShowTornado:
	call UpdateOWTornado
	ld a, [wSceneObj1MovementStep]
	cp $01
	jr z, .play_tornado_sfx
	and a
	ret nz
	jp AdvanceOWFunc
.play_tornado_sfx
	play_sfx SFX_TORNADO
	ret

.ClearTornado:
	ld de, ClearTornadoMovement
	ld hl, wSceneObj1
	call ApplyOWMovement
	ret nz
	jp AdvanceOWFunc

.HideTornado:
	ld a, $00
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

UpdateOWTornado:
	ld de, OWTornadoMovement
	ld hl, wSceneObj1
	call ApplyOWMovement
	ret nz
	; only play SFX if not playing a scene...
	ld a, [wCurEvent]
	and a
	ret nz
	; ...and if no bars are open
	ld a, [wOWBarsState]
	and a
	ret nz
	play_sfx SFX_TORNADO
	ret

WOWFunc_ElevatorWorking:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw .SetElevatorWorking
	dw .Wait200
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.SetElevatorWorking:
	ld a, $06
	ld hl, wSceneObj8State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait200:
	ld a, 200
	jp WaitOWFunc

WOWFunc_MagicSeed:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .PlayFallSFX
	dw .SeedFall
	dw .WaitSeedFall
	dw .Wait30
	dw .GrowStalk
	dw .WaitGrowStalk
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.PlayFallSFX:
	play_sfx SFX_ITEM_FALL
	jp AdvanceOWFunc

.SeedFall:
	ld hl, wOWFuncCounter
	call GetSceneFallingYOffset
	ld hl, wSceneObj4YCoord
	add [hl]
	ld [hl], a
	cp $5b
	ret c
	ld a, $0b
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_STOMP
	jp AdvanceOWFunc

.WaitSeedFall:
	ld hl, wSceneObj4State
	ld b, $0c
	jp WaitOWObjState

.Wait30:
	ld a, 30
	jp WaitOWFunc

.GrowStalk:
	ld a, $0d
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_BEANSTALK_GROW
	jp AdvanceOWFunc

.WaitGrowStalk:
	ld hl, wSceneObj4State
	ld b, $0e
	jp WaitOWObjState

WOWFunc_SummonSnake:
	call .MoveNotes
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait8
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .PlayFluteSFX
	dw .WaitNotesAndShowSnake
	dw .WaitSnakeComeOut
	dw EndOWFunc

.Wait8:
	ld a, 8
	jp WaitOWFunc

.PlayFluteSFX:
	ld a, $01
	ld [wSceneObj1MovementStep], a
	play_sfx SFX_FLUTE
	jp AdvanceOWFunc

.WaitNotesAndShowSnake:
	ld hl, wSceneObj1XCoord
	ld a, $26
	cp [hl]
	ret nz
	ld a, $0f
	ld hl, wSceneObj5State
	call SetSceneObjState
	play_sfx SFX_TEMPLE_ROCK
	jp AdvanceOWFunc

.WaitSnakeComeOut:
	ld a, [wSceneObj5Frame]
	cp $0a
	ret nz
	jp AdvanceOWFunc

.MoveNotes:
	ld a, [wSceneObj1MovementStep]
	and a
	ret z
	ld hl, wSceneObj1XCoord
	dec [hl]
	ld a, [hl]
	add $18
	cp $f0
	ret c
	xor a
	ld [wSceneObj1MovementStep], a
	ret

WOWFunc_Earthquake:
	call UpdateOWSceneScreenShake
	call .UpdateFallingRocks

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .StartShake
	dw .WaitShake
	dw .StopShake
	dw .WaitPostShake
	dw .DropRocks
	dw .Wait60
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.StartShake:
	ld a, $01
	ld [wOWSceneShakeState], a
	ld a, $01
	ld [wOWSceneRocksStep], a
	ld a, $17
	ld hl, wSceneObj11State
	call SetSceneObjState
	ld a, $19
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld a, $01
	ld [wOWSeaGfxVariant], a
	ld a, $03
	ld hl, wOWSeaAnim
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	jp AdvanceOWFunc

.WaitShake:
	ld a, 120
	jp WaitOWFunc

.StopShake:
	xor a
	ld [wOWSceneRocksStep], a
	ld a, $03
	ld [wOWSceneShakeState], a
	ld a, $18
	ld hl, wSceneObj11State
	call SetSceneObjState
	ld a, $1a
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld hl, wOWSeaAnim
	ld a, $0e
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [wOWSeaGfxVariant], a
	jp AdvanceOWFunc

.WaitPostShake:
	ld a, 60
	jp WaitOWFunc

.DropRocks:
	ld a, $16
	ld hl, wSceneObj13State
	call SetSceneObjState
	ld hl, WOWTilemapPatch_Earthquake
	call ApplyOWTilemapPatchesAndRedraw
	play_sfx SFX_EARTHQUAKE
	jp AdvanceOWFunc

.UpdateFallingRocks:
	ld hl, wOWSceneRocksStep
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Rock1
	dw .RockWait10
	dw .Rock2
	dw .RockWait10
	dw .Rock3
	dw .RockWait10
	dw .Rock4
	dw .RockWait10
	dw .RocksRestart

.Rock1:
	ld a, $14
	ld hl, wSceneObj13State
	call SetSceneObjState
.next_rock
	xor a
	ld hl, wOWSceneRocksCounter
	ld [hld], a
	inc [hl]
	ret

.Rock2:
	ld a, $15
	ld hl, wSceneObj15State
	call SetSceneObjState
	jr .next_rock

.Rock3:
	ld a, $14
	ld hl, wSceneObj14State
	call SetSceneObjState
	jr .next_rock

.Rock4:
	ld a, $15
	ld hl, wSceneObj12State
	call SetSceneObjState
	jr .next_rock

.RockWait10:
	ld a, [wOWSceneRocksCounter]
	cp $0a
	ret c
	jr .next_rock

.RocksRestart:
	ld a, $01
	ld hl, wOWSceneRocksStep
	ld [hli], a
	xor a
	ld [hl], a
	ret

WOWFunc_VulcanoEruption:
	call UpdateOWSceneScreenShake
	call .UpdateLeftRock
	call .UpdateRightRock
	call .UpdateMiddleRock
	call PlayVolcanoRumbleSFX

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait60
	dw .StartShake
	dw .Wait58
	dw .SetObj11State1f
	dw .WaitObj11Disappear
	dw .RequestShake4
	dw .Flash
	dw .EruptAndPatchTiles
	dw .LaunchRock1
	dw .LaunchRock2
	dw .LaunchRock3
	dw .LaunchRock4
	dw .LaunchRock5
	dw .LaunchRock6
	dw .WaitRocksLanded
	dw .Wait16
	dw .StartShake2
	dw .StopShakeAtStep1b
	dw .WaitShakeEnd
	dw .Wait24
	dw EndOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.Wait24:
	ld a, 24
	jp WaitOWFunc

.StartShake:
	ld a, $01
	ld [wOWSceneShakeState], a
	ld a, $17
	ld hl, wSceneObj11State
	call SetSceneObjState
	ld a, $19
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld a, $01
	ld [wOWSeaGfxVariant], a
	ld a, $03
	ld hl, wOWSeaAnim
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	jp AdvanceOWFunc

.Wait58:
	ld a, 58
	jp WaitOWFunc

.SetObj11State1f:
	ld a, $1f
	ld hl, wSceneObj11State
	call SetSceneObjState
	ld hl, wSceneObj11
	ld a, $10
	ld [hli], a
	ld a, $52
	ld [hl], a

	ld hl, wPalConfig1Index
	ld a, BGPI_AUTOINC | palette 5
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, $c1
	ld [hli], a
	ld a, $28
	ld [hli], a
	jp AdvanceOWFunc

.WaitObj11Disappear:
	ld a, [wSceneObj11State]
	and a
	ret nz
	jp AdvanceOWFunc

.RequestShake4:
	ld a, [wOWFuncCounter]
	cp 6
	ret c
	ld a, $04
	ld [wOWSceneShakeState], a
	jp AdvanceOWFunc

.Flash:
	ld a, $1a
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld hl, wOWSeaAnim
	ld a, $0e
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [wOWSeaGfxVariant], a

	ld hl, wTempBGPals palette 0
	ld b, 3 palettes
	call FillPalsWithFlashColour

	ld hl, wTempPals1 palette 6
	ld de, wTempBGPals palette 6
	ld b, 1 palettes
	call CopyHLToDE

	ld hl, wTempBGPals palette 7
	ld b, 4
	call FillPalsWithFlashColour

	ld hl, wTempOBPals palette 0
	ld b, 4 palettes
	call FillPalsWithFlashColour

	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	ld a, BGPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 1 palettes
	ld [hli], a
	ld a, HIGH(wTempBGPals)
	ld [hli], a
	ld a, LOW(wTempBGPals)
	ld [hli], a

	ld hl, wPalConfig2
	ld a, LOW(rOBPI)
	ld [hli], a
	ld a, OBPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 1 palettes
	ld [hli], a
	ld a, HIGH(wTempOBPals)
	ld [hli], a
	ld a, LOW(wTempOBPals)
	ld [hli], a

	ld a, $01
	ld [wOWSceneSFXLoopActive], a
	jp AdvanceOWFunc

.EruptAndPatchTiles:
	ld a, [wOWFuncCounter]
	cp 8
	ret c
	ld a, $1b
	ld hl, wSceneObj11State
	call SetSceneObjState
	ld hl, wSceneObj11
	ld a, $10
	ld [hli], a
	ld a, $54
	ld [hl], a
	ld hl, WOWTilemapPatch_VulcanoEruption
	call ApplyOWTilemapPatchesAndRedraw

	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	ld a, BGPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 1 palettes
	ld [hli], a
	ld a, HIGH(wTempPals1)
	ld [hli], a
	ld a, LOW(wTempPals1)
	ld [hli], a

	ld hl, wPalConfig2
	ld a, LOW(rOBPI)
	ld [hli], a
	ld a, OBPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 1 palettes
	ld [hli], a
	ld a, HIGH(wTempPals2)
	ld [hli], a
	ld a, LOW(wTempPals2)
	ld [hli], a

	jp AdvanceOWFunc

.LaunchRock1:
	ld a, $03
	ld [w2d126], a
.asm_b5ebc
	play_sfx SFX_TEMPLE_ROCK
	jp AdvanceOWFunc

.LaunchRock2:
	ld a, [wOWFuncCounter]
	cp 12
	ret c
	ld a, $03
	ld [w2d122], a
	jr .asm_b5ebc

.LaunchRock3:
	ld a, [wOWFuncCounter]
	cp 36
	ret c
	ld a, $01
	ld [w2d12c], a
	jr .asm_b5ebc

.LaunchRock4:
	ld a, [wOWFuncCounter]
	cp 12
	ret c
	ld a, $03
	ld [w2d126], a
	jr .asm_b5ebc

.LaunchRock5:
	ld a, [wOWFuncCounter]
	cp 20
	ret c
	ld a, $03
	ld [w2d122], a
	jr .asm_b5ebc

.LaunchRock6:
	ld a, [wOWFuncCounter]
	cp 38
	ret c
	ld a, $01
	ld [w2d126], a
	jr .asm_b5ebc

.WaitRocksLanded:
	ld a, [w2d126]
	and a
	ret nz
	jp AdvanceOWFunc

.Wait16:
	ld a, 16
	jp WaitOWFunc

.StartShake2:
	ld a, $08
	ld [wOWSceneShakeState], a
	ld a, $19
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld a, $01
	ld [wOWSeaGfxVariant], a
	ld a, $03
	ld hl, wOWSeaAnim
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	jp AdvanceOWFunc

.StopShakeAtStep1b:
	ld a, [wOWSceneShakeStep]
	cp $1b
	ret nz
	ld a, $1a
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld hl, wOWSeaAnim
	ld a, $0e
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [wOWSeaGfxVariant], a
	jp AdvanceOWFunc

.WaitShakeEnd:
	ld a, [wOWSceneShakeState]
	and a
	ret nz
	jp AdvanceOWFunc

.UpdateLeftRock:
	ld hl, w2d122
	ld a, [hl]
	and a
	ret z
	dec a
	jumptable
	dw .LeftRock_Launch46
	dw .LeftRock_Fall
	dw .LeftRock_Launch75
	dw .LeftRock_FallSteep
	dw .LeftRock_Launch46Alt
	dw .LeftRock_Fall
	dw .LeftRock_Launch75Alt
	dw .LeftRock_FallSteep

.LeftRock_Launch46:
	lb de, 8, 46
.asm_b5f73
	ld b, $1c
.asm_b5f75
	ld hl, wSceneObj1
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	set 2, l
	ld a, b
	call SetSceneObjState
	xor a
	ld hl, w2d123
	ld [hld], a
	inc [hl]
	ret

.LeftRock_Fall:
	ld hl, wSceneObj1XCoord
	dec [hl]
	dec [hl]
	dec l
	inc [hl]
	inc [hl]
.asm_b5f91
	ld a, [hl]
	cp $88
	ret c
	xor a
	ld hl, w2d123
	ld [hld], a
	ld [hl], a
	ret

.LeftRock_Launch75:
	lb de, 8, 75
	jr .asm_b5f73

.LeftRock_FallSteep:
	ld hl, wSceneObj1XCoord
	dec [hl]
	dec [hl]
	dec l
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	jr .asm_b5f91

.LeftRock_Launch46Alt:
	lb de, 8, 46
.asm_b5fb0
	ld b, $1f
	jr .asm_b5f75

.LeftRock_Launch75Alt:
	lb de, 8, 75
	jr .asm_b5fb0

.UpdateRightRock:
	ld hl, w2d126
	ld a, [hl]
	and a
	ret z
	dec a
	jumptable
	dw .RightRock_Launch98
	dw .RightRock_Fall
	dw .RightRock_Launch93
	dw .RightRock_FallSteep
	dw .RightRock_Launch98Alt
	dw .RightRock_Fall
	dw .RightRock_Launch93Alt
	dw .RightRock_FallSteep

.RightRock_Launch98:
	lb de, 8, 98
.asm_b5fd4
	ld b, $1d
.asm_b5fd6
	ld hl, wSceneObj3YCoord
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	set 2, l
	ld a, b
	call SetSceneObjState
	xor a
	ld hl, w2d127
	ld [hld], a
	inc [hl]
	ret

.RightRock_Fall:
	ld hl, wSceneObj3XCoord
	inc [hl]
	inc [hl]
	dec l
	inc [hl]
	inc [hl]
.asm_b5ff2
	ld a, [hl]
	cp $88
	ret c
	xor a
	ld hl, w2d127
	ld [hld], a
	ld [hl], a
	ret

.RightRock_Launch93:
	lb de, 8, 93
	jr .asm_b5fd4

.RightRock_FallSteep:
	ld hl, wSceneObj3XCoord
	inc [hl]
	inc [hl]
	dec l
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	jr .asm_b5ff2

.RightRock_Launch98Alt:
	lb de, 8, 98
.asm_b6011
	ld b, $20
	jr .asm_b5fd6

.RightRock_Launch93Alt:
	lb de, 8, 93
	jr .asm_b6011

.UpdateMiddleRock:
	ld hl, w2d12c
	ld a, [hl]
	and a
	ret z
	dec a
	jr z, .asm_b6027
	dec a
	jr z, .asm_b603f
	ret
.asm_b6027
	ld hl, wSceneObj6
	ld a, $08
	ld [hli], a
	ld a, $2e
	ld [hl], a
	ld a, $1c
	ld hl, wSceneObj6State
	call SetSceneObjState
	xor a
	ld hl, w2d12d
	ld [hld], a
	inc [hl]
	ret
.asm_b603f
	ld hl, wSceneObj6YCoord
	inc [hl]
	inc [hl]
	ld b, [hl]
	ld hl, wSceneObj6XCoord
	dec [hl]
	dec [hl]
	ld a, b
	cp $88
	ret c
	xor a
	ld hl, w2d12d
	ld [hld], a
	ld [hl], a
	ret

PlayVolcanoRumbleSFX:
	ld a, [wOWSceneSFXLoopActive]
	and a
	ret z
	ld hl, wOWSceneSFXLoopCounter
	inc [hl]
	ld a, [hl]
	cp $1a
	ret c
	xor a
	ld [hl], a
	play_sfx SFX_THUNDER
	ret

WOWFunc_RedMusicBox:
	call .PlayThunderSFXLoop
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw .PlayMusicBoxSFX
	dw .Wait254
	dw .SetObj6State20AndPatchTiles
	dw .Wait23
	dw .SetObj6State21
	dw .Wait10
	dw .SetObj6State22
	dw .StopSFXLoop
	dw EndOWFunc

.PlayThunderSFXLoop:
	ld hl, wSceneObj6MovementStep
	ld a, [hl]
	and a
	ret z
	cp $01
	play_sfx z, SFX_THUNDER
	inc [hl]
	ld a, [hl]
	cp $1b
	ret c
	ld a, $01
	ld [hl], a
	ret

.Wait20:
	ld a, 20
	jp WaitOWFunc

.PlayMusicBoxSFX:
	play_sfx SFX_RED_MUSIC_BOX
	jp AdvanceOWFunc

.Wait254:
	ld a, 254
	jp WaitOWFunc

.SetObj6State20AndPatchTiles:
	ld a, $20
	ld hl, wSceneObj6State
	call SetSceneObjState
	ld hl, WOWTilemapPatch_RedMusicBox
	call ApplyOWTilemapPatchesAndRedraw
	ld a, $01
	ld [wSceneObj6MovementStep], a
	jp AdvanceOWFunc

.Wait23:
	ld a, 23
	jp WaitOWFunc

.SetObj6State21:
	ld a, $21
	ld hl, wSceneObj6State
	call SetSceneObjState
	ld hl, wSceneObj6
	dec [hl]
	jp AdvanceOWFunc

.Wait10:
	ld a, 10
	jp WaitOWFunc

.SetObj6State22:
	ld a, $22
	ld hl, wSceneObj6State
	call SetSceneObjState
	jp AdvanceOWFunc

.StopSFXLoop:
	ld a, [wOWFuncCounter]
	cp 106
	ret c
	xor a
	ld [wSceneObj6MovementStep], a
	jp AdvanceOWFunc

FallLeavesLiftMovement:
	db  0,  0
	db -2,  0
	db -1,  0
	db -2,  0
	db -1,  0
	db -1,  0
	db -1,  0
	db -1,  0
	db  0,  0
	db -1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  1,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  1,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db $80

FallLeavesBlowAwayMovement:
	db  0,  0
	db  1,  0
	db  0,  0
	db  1, -1
	db  0,  0
	db  1,  0
	db  0,  0
	db  1,  0
	db  0, -1
	db  1,  0
	db  0,  0
	db  1,  0
	db  0, -1
	db  1,  0
	db  0,  0
	db  1, -1
	db  0,  0
	db  1,  0
	db  0, -1
	db  1,  0
	db  0,  0
	db  1, -1
	db  0,  0
	db  1,  0
	db  0, -1
	db  0,  0
	db  1, -1
	db  0,  0
	db  1,  0
	db  0, -1
	db  0,  0
	db  1, -1
	db  0,  0
	db  1, -1
	db  0,  0
	db  1, -1
	db  0,  0
	db  1, -1
	db  0, -1
	db  0,  0
	db  1, -1
	db  0, -1
	db  1, -1
	db  0,  0
	db  1, -1
	db  0, -1
	db  0,  0
	db  1, -1
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  1, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0, -1
	db  1,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db $80

FallLeavesSplitMovement:
	db  0,  0
	db  1, -1
	db  0, -1
	db  1,  0
	db  0, -1
	db  1, -1
	db  0, -1
	db  1, -1
	db  0, -1
	db  0, -1
	db  1, -1
	db  0,  0
	db  1, -1
	db  0, -1
	db  0, -1
	db  1, -1
	db  0, -1
	db  0, -1
	db  1, -1
	db  0, -2
	db  0, -1
	db  1, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0,  0
	db  0, -1
	db  1, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db $80

CrayonScribbleMovement:
	db  0,  0
	db  0,  0
	db -1,  1
	db -1,  1
	db -1,  0
	db -1,  1
	db -1,  1
	db -1,  1
	db -1,  0
	db -1,  1
	db -1,  1
	db  0,  1
	db -1,  1
	db  1,  0
	db  2, -1
	db  1,  0
	db  1, -1
	db  2,  0
	db  1, -1
	db  1,  0
	db  1, -1
	db  2,  0
	db  1, -1
	db  1,  1
	db -1,  2
	db -2,  2
	db -2,  2
	db -2,  1
	db -2,  2
	db -1,  2
	db -2,  2
	db -2,  1
	db -2,  2
	db -2,  2
	db -1,  2
	db  2,  0
	db  1, -1
	db  2, -1
	db  2, -1
	db  1, -1
	db  2,  0
	db  2, -1
	db  1, -1
	db  2, -1
	db  2, -1
	db  1, -1
	db  2,  0
	db -1,  2
	db -2,  1
	db -2,  2
	db -2,  2
	db -1,  1
	db -2,  2
	db -2,  1
	db -2,  2
	db -1,  1
	db -2,  2
	db -1,  2
	db  1,  1
	db  2,  0
	db  1,  0
	db  2,  0
	db  2, -1
	db  1,  0
	db  2,  0
	db  1,  0
	db  2, -1
	db  1,  0
	db  1,  1
	db -3,  2
	db -2,  1
	db -3,  2
	db -3,  1
	db -3,  2
	db -3,  1
	db -3,  1
	db -3,  2
	db -2,  1
	db -3,  1
	db -3,  2
	db -3,  1
	db $80

OWTornadoMovement:
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db -1,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db -1,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db -1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db -1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db -1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db -1,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  1,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  1,  0
	db  0,  0
	db  0,  1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  1,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0,  0
	db  0, -1
	db  1,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db $80

ClearTornadoMovement:
	db -1, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db  0, -1
	db  0, -1
	db -1, -1
	db  0,  0
	db -1, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db -1, -1
	db -1, -1
	db -1, -1
	db  0, -1
	db -1, -1
	db -1,  0
	db -1, -1
	db -1, -1
	db -1, -1
	db -1,  0
	db -1, -1
	db -1, -1
	db -1,  0
	db -1, -1
	db -1, -1
	db -1,  0
	db -1, -1
	db -1,  0
	db $80

FormCastleObj1Movement:
	db  0,  0
	db  0,  0
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db -1,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db -1,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db  0,  1
	db -1,  1
	db -1, -1
	db  0, -2
	db -1, -1
	db  0, -2
	db -1, -1
	db  0, -2
	db  0, -1
	db -1, -2
	db  0, -1
	db  0, -2
	db -1, -1
	db  0, -2
	db -1, -1
	db  0, -1
	db  0, -2
	db -1, -1
	db  0, -2
	db -1, -1
	db  0, -2
	db -1, -1
	db -1,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db -1,  2
	db  0,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db  0,  2
	db  0,  1
	db  0,  2
	db -1,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db  0,  2
	db -1,  1
	db -1, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db  0, -1
	db -1, -2
	db  0, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db  0, -1
	db -1, -2
	db  0, -1
	db  0, -1
	db -1, -1
	db  0, -1
	db  0, -2
	db -1, -1
	db  0, -1
	db  0, -1
	db -1, -1
	db -1,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db  0,  1
	db  0,  2
	db  0,  2
	db  0,  1
	db -1,  2
	db  0,  1
	db -1,  0
	db  0,  0
	db  0, -1
	db -1,  0
	db  0, -1
	db  0, -1
	db -1,  0
	db  0, -1
	db  0,  0
	db  0, -1
	db -1, -1
	db  0,  0
	db  0, -1
	db  0,  0
	db -1, -1
	db  0, -1
	db  0,  0
	db  0, -1
	db -1,  0
	db  0, -1
	db $80

SouthOWFunctions:
	ld a, [wOWSceneActionParam]
	dec a
	jumptable
	dw SOWFunc_SendSeeds      ; SOWFUNC_SEND_SEEDS
	dw SOWFunc_MagicSeed      ; SOWFUNC_MAGIC_SEED
	dw SOWFunc_YellowMusicBox ; SOWFUNC_YELLOW_MUSIC_BOX
	dw SOWFunc_CanyonThunder  ; SOWFUNC_CANYON_THUNDER
	dw SOWFunc_RaiseTower     ; SOWFUNC_RAISE_TOWER
	dw SOWFunc_Fan            ; SOWFUNC_FAN
	dw SOWFunc_SummonSnake    ; SOWFUNC_SUMMON_SNAKE
	dw SOWFunc_Earthquake     ; SOWFUNC_EARTHQUAKE
	dw SOWFunc_GreenMusicBox  ; SOWFUNC_GREEN_MUSIC_BOX
	dw SOWFunc_Explosives     ; SOWFUNC_EXPLOSIVES
	dw SOWFunc_FullMoon       ; SOWFUNC_FULL_MOON

SOWFunc_SendSeeds:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait30
	dw .ShowSeed1
	dw .WaitShowSeed
	dw .ShowSeed2
	dw .WaitShowSeed
	dw .ShowSeed3
	dw .WaitShowSeed
	dw .PlayFlyingSFX
	dw .MoveSeeds
	dw .Wait10
	dw EndOWFunc

.Wait30:
	ld a, 30
	jp WaitOWFunc

.Wait10:
	ld a, 10
	jp WaitOWFunc

.ShowSeed1:
	ld hl, wSceneObj4State
.asm_b6606
	ld a, $06
	call SetSceneObjState
	play_sfx SFX_TEMPLE_ROCK
	jp AdvanceOWFunc

.WaitShowSeed:
	ld a, 30
	jp WaitOWFunc

.ShowSeed2:
	ld hl, wSceneObj2State
	jr .asm_b6606

.ShowSeed3:
	ld a, $01
	ld [w2d125], a
	ld hl, wSceneObj3State
	jr .asm_b6606

.PlayFlyingSFX:
	play_sfx SFX_07F
	jp AdvanceOWFunc

.MoveSeeds:
	ld a, [w2d125]
	and a
	call nz, .MoveSeed2
	ld a, [w2d129]
	and a
	call nz, .MoveSeed1
	ld a, [w2d127]
	and a
	call nz, .MoveSeed3
	ld hl, wSceneObj3XCoord
	ld a, [hl]
	cp $f0
	ret c
	xor a
	ld [w2d127], a
	jp AdvanceOWFunc

.MoveSeed2:
	ld hl, w2d125
	call .GetXOffset
	cpl
	inc a ; = -a
	ld hl, wSceneObj2XCoord
	add [hl]
	ld [hld], a
	dec [hl]
	dec [hl]
	dec [hl]
	ld a, [hl]
	cp $1a
	jr z, .asm_b6675
	cp $f0
	ret c
	xor a
	ld [w2d125], a
	ret
.asm_b6675
	ld a, $01
	ld [w2d129], a
	play_sfx SFX_07F
	ret

.MoveSeed1:
	ld hl, wSceneObj4YCoord
	dec [hl]
	dec [hl]
	dec [hl]
	ld a, [hl]
	cp $1a
	jr z, .asm_b6696
	cp $f0
	ret c
	xor a
	ld [w2d129], a
	ret
.asm_b6696
	ld a, $01
	ld [w2d127], a
	play_sfx SFX_07F
	ret

.MoveSeed3:
	ld hl, w2d127
	call .GetXOffset
	ld hl, wSceneObj3XCoord
	add [hl]
	ld [hld], a
	dec [hl]
	dec [hl]
	dec [hl]
	ret

.GetXOffset:
	ld a, [hl]
	cp $18
	jr nc, .no_carry
	inc [hl]
.no_carry
	ld c, a
	ld b, $00
	ld hl, .x_offsets
	add hl, bc
	ld a, [hl]
	ret

.x_offsets
	db 0, 1, 0, 0, 1, 1, 0, 1
	db 1, 1, 1, 1, 1, 2, 2, 2
	db 4, 6, 8, 8, 8, 8, 8, 8

SOWFunc_MagicSeed:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .PlayFallSFX
	dw .SeedFall
	dw .WaitSeedFall
	dw .Wait30
	dw .GrowStalk
	dw .WaitGrowStalk
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.PlayFallSFX:
	play_sfx SFX_ITEM_FALL
	jp AdvanceOWFunc

.SeedFall:
	ld hl, wOWFuncCounter
	call GetSceneFallingYOffset
	ld hl, wSceneObj4YCoord
	add [hl]
	ld [hl], a
	cp $56
	ret c
	ld a, $06
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_STOMP
	jp AdvanceOWFunc

.WaitSeedFall:
	ld hl, wSceneObj4State
	ld b, $03
	jp WaitOWObjState

.Wait30:
	ld a, 30
	jp WaitOWFunc

.GrowStalk:
	ld a, $02
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_BEANSTALK_GROW
	jp AdvanceOWFunc

.WaitGrowStalk:
	ld hl, wSceneObj4State
	ld b, $01
	jp WaitOWObjState

SOWFunc_YellowMusicBox:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw .PlayMusicBoxSFX
	dw .WaitMusic
	dw .LowerBridge
	dw .ShowLoweredBridge
	dw .Wait40
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.PlayMusicBoxSFX:
	play_sfx SFX_YELLOW_MUSIC_BOX
	jp AdvanceOWFunc

.WaitMusic:
	ld a, 254
	jp WaitOWFunc

.LowerBridge:
	play_sfx SFX_BRIDGE_LOWER
	ld a, $08
	ld hl, wSceneObj6State
	call SetSceneObjState
	jp AdvanceOWFunc

.ShowLoweredBridge:
	ld hl, wSceneObj6State
	ld b, $09
	jp WaitOWObjState

SOWFunc_CanyonThunder:
	call .UpdateBarrage
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait34
	dw .Lightning1
	dw .FlashWait16
	dw .Lightning2
	dw .FlashWait54
	dw .Lightning3
	dw .WaitFlashDone
	dw .Wait30
	dw .StartBarrage
	dw .WaitBarrage
	dw .Wait7
	dw .FlashWhite
	dw OWFuncFadePals
	dw .SetObj5State0aAndPatchTiles
	dw .Wait45
	dw .LoadNormalPals
	dw .FadeEvery2Frames
	dw .Wait90
	dw EndOWFunc

.Wait34:
	vc_hook Canyon_thunder_motion_blur_begin
	ld a, 34
	jp WaitOWFunc

.Wait90:
	ld a, 90
	jp WaitOWFunc

.Lightning1:
	ld hl, wSceneObj2State
.asm_b67d4
	ld a, $12
.asm_b67d6
	call SetSceneObjState
	ld a, $01
	ld [wPalConfig1TotalSteps], a
	call .step_flash
	play_sfx SFX_LIGHTNING
	jp AdvanceOWFunc

.FlashWait16:
	call .step_flash
	ld a, 16
	jp WaitOWFunc

.Lightning2:
	ld hl, wSceneObj10State
	jr .asm_b67d4

.FlashWait54:
	call .step_flash
	ld a, 54
	jp WaitOWFunc

.Lightning3:
	ld hl, wSceneObj2YCoord
	ld a, $56
	ld [hli], a
	ld [hl], $47
	ld hl, wSceneObj2State
	ld a, $17
	jr .asm_b67d6

.WaitFlashDone:
	call .step_flash
	ld a, [wPalConfig1TotalSteps]
	and a
	ret nz
	jp AdvanceOWFunc

.Wait30:
	ld a, 30
	jp WaitOWFunc

.StartBarrage:
	ld a, $01
	ld [w2d124], a
	jp AdvanceOWFunc

.WaitBarrage:
	ld a, [w2d124]
	cp $07
	ret c
	jp AdvanceOWFunc

.Wait7:
	ld a, 7
	jp WaitOWFunc

.SetObj5State0aAndPatchTiles:
	vc_hook Canyon_thunder_motion_blur_end
	ld a, $0a
	ld hl, wSceneObj5State
	call SetSceneObjState
	ld hl, SOWTilemapPatch_CanyonThunder
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.Wait45:
	ld a, 45
	jp WaitOWFunc

.LoadNormalPals:
	ld hl, SouthOWDayPals
	ld de, wTempPals1
	ld b, BANK(SouthOWDayPals)
	ld c, 8 palettes
	call CopyFarBytes
	ld hl, SouthOWOBPals
	ld de, wTempPals2
	ld b, BANK(SouthOWOBPals)
	ld c, 8 palettes
	call CopyFarBytes
	jp AdvanceOWFunc

.step_flash_from_5:
	ld hl, wPalConfig1TotalSteps
	ld a, [hl]
	and a
	ret z
	inc [hl]
	cp $05
	jr z, .flash2_pal
	cp $09
	jr z, .flash1_pal
	ret

.step_flash:
	ld hl, wPalConfig1TotalSteps
	ld a, [hl]
	and a
	ret z
	inc [hl]
	cp $01
	jr z, .flash1_pal
	cp $05
	jr z, .flash2_pal
	cp $09
	jr z, .asm_b6892
	ret
.flash1_pal
	ld hl, OWLightningFlashPals2
	jr .got_pal
.asm_b6892
	xor a
	ld [hl], a
	ld a, [wOWFuncStep]
	cp $07
	jr z, .flash1_pal
	ld hl, SouthOWDayPals
.got_pal
	ld de, wTempBGPals
	ld b, BANK(SouthOWDayPals) ; aka BANK(OWLightningFlashPals2)
	ld c, 8 palettes
	call CopyFarBytes
.apply_pals
	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	ld a, BGPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 1 palettes
	ld [hli], a
	ld a, HIGH(wTempBGPals)
	ld [hli], a
	ld a, LOW(wTempBGPals)
	ld [hli], a
	ret

.flash2_pal
	ld hl, wTempBGPals palette 0
	ld b, 3 palettes
	call FillPalsWithFlashColour
	ld hl, wTempBGPals palette 7
	ld b, 4
	call FillPalsWithFlashColour
	jr .apply_pals

.UpdateBarrage:
	ld a, [w2d124]
	and a
	ret z
	ld hl, w2d125
	inc [hl]
	dec a
	jumptable
	dw .Barrage_Bolt1
	dw .Barrage_FlashWait7
	dw .Barrage_Bolt2
	dw .Barrage_FlashWait7
	dw .Barrage_Bolt3
	dw .Barrage_FlashWait7
	dw .Barrage_Bolt4
	dw .Barrage_FlashWait7
	dw .Barrage_Bolt5
	dw .Barrage_Wait7
	dw .Barrage_End

.Barrage_Bolt1:
	ld hl, wSceneObj2
	lb de, $50, $38
	ld c, $17
.asm_b68f6
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	set 2, l
	ld a, c
	call SetSceneObjState
	ld a, $01
	ld [wPalConfig1TotalSteps], a
	call .step_flash_from_5
.asm_b6908
	play_sfx SFX_LIGHTNING
.asm_b6910
	ld hl, w2d124
	inc [hl]
	xor a
	ld [w2d125], a
	ret

.Barrage_FlashWait7:
	call .step_flash_from_5
	ld a, $07
	ld hl, w2d125
	cp [hl]
	ret nc
	jr .asm_b6910

.Barrage_Wait7:
	ld a, $07
	ld hl, w2d125
	cp [hl]
	ret nc
	jr .asm_b6910

.Barrage_Bolt2:
	ld hl, wSceneObj1
	lb de, $48, $46
	ld c, $12
	jr .asm_b68f6

.Barrage_Bolt3:
	ld hl, wSceneObj2
	lb de, $42, $2e
	ld c, $17
	jr .asm_b68f6

.Barrage_Bolt4:
	ld hl, wSceneObj1
	lb de, $3e, $38
	ld c, $12
	jr .asm_b68f6

.Barrage_Bolt5:
	ld hl, wSceneObj10
	lb de, $3b, $1f
	ld c, $12
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	set 2, l
	ld a, c
	call SetSceneObjState
	jr .asm_b6908

.Barrage_End:
	xor a
	ld [w2d124], a
	ld [w2d125], a
	ret

.FadeEvery2Frames:
	ld a, [wOWFuncCounter]
	bit 0, a
	ret z
	jp OWFuncFadePals

.FlashWhite:
	ld hl, wTempPals1
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, wTempPals2
	ld de, wTempOBPals
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, wTempPals1
	ld b, 3 palettes
	call FillPalsWithFlashColour
	ld hl, wTempPals1 palette 7
	ld b, 4
	call FillPalsWithFlashColour
	ld hl, wTempPals2
	ld b, 4 palettes
	call FillPalsWithFlashColour
	xor a
	ld [wPalConfig1TotalSteps], a
	jp AdvanceOWFunc

FillPalsWithFlashColour:
.asm_b69a6
	vc_patch FPA_80_BG_Flash_Palette_1_0
	IF DEF(_VC)
		ld a, $4a
	ELSE
		ld a, $9c
	ENDC
	vc_patch_end
	ld [hli], a
	vc_patch FPA_80_BG_Flash_Palette_1_1
	IF DEF(_VC)
		ld a, $29
	ELSE
		ld a, $73
	ENDC
	vc_patch_end
	ld [hli], a
	dec b
	jr nz, .asm_b69a6
	ret

SOWFunc_RaiseTower:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait30
	dw .StartDust
	dw .Wait45
	dw .RaiseTower
	dw .RaiseTower
	dw .RaiseTower
	dw .FinishRaiseTower
	dw .SettleTower
	dw .Wait40_1
	dw .HideObjsAndPatchTiles
	dw .Wait40_2
	dw EndOWFunc

.Wait30:
	ld a, 30
	jp WaitOWFunc

.Wait40_2:
	ld a, 40
	jp WaitOWFunc

.StartDust:
	ld a, $0b
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_TOWER_RISE
	jp AdvanceOWFunc

.Wait45:
	ld a, 45
	jp WaitOWFunc

.RaiseTower:
	call .move_tower_up
	ret nz
	ld hl, wSceneObj3YCoord
	ld a, $10
	add [hl]
	ld [hl], a
	ld hl, wSceneObj3State
	ld a, [hl]
	inc a
	call SetSceneObjState
	jp AdvanceOWFunc

.FinishRaiseTower:
	call .move_tower_up
	cp $50
	ret nz
	jp AdvanceOWFunc

.SettleTower:
	call .move_tower_up_slowly
	ret nz
	jp AdvanceOWFunc

.move_tower_up:
	ld a, [wGlobalCounter]
	and %111
	jr z, .asm_b6a28
	and $01
	ret nz
	ld hl, wSceneObj3YCoord
	dec [hl]
	ld a, [hl]
	cp $48
	ret
.asm_b6a28
	ld hl, wSceneObj3YCoord
	ld a, [hl]
	inc [hl]
	ret

.move_tower_up_slowly:
	ld a, [wGlobalCounter]
	and %1111
	jr z, .asm_b6a40
	and $03
	ret nz
	ld hl, wSceneObj3YCoord
	dec [hl]
	ld a, [hl]
	cp $48
	ret

.asm_b6a40
	ld hl, wSceneObj3YCoord
	ld a, [hl]
	inc [hl]
	ret

.Wait40_1:
	ld a, 40
	jp WaitOWFunc

.HideObjsAndPatchTiles:
	ld a, $00
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $00
	ld hl, wSceneObj3State
	call SetSceneObjState
	ld hl, SOWTilemapPatch_RaiseTower
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

SOWFunc_Fan:
	call .UpdateWind1
	call .UpdateWind2
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20_1
	dw .StartFan
	dw .Wait24
	dw .StartWind1
	dw .StartWind2
	dw .WaitObj9Frame21
	dw .Wait12
	dw .RaiseObj9
	dw .WaitWind2Done
	dw .Wait20_2
	dw EndOWFunc

.Wait20_1:
	ld a, 20
	jp WaitOWFunc

.Wait20_2:
	ld a, 20
	jp WaitOWFunc

.StartFan:
	ld a, $1a
	ld hl, wSceneObj8State
	call SetSceneObjState
	play_sfx SFX_12F
	jp AdvanceOWFunc

.Wait24:
	ld a, 24
	jp WaitOWFunc

.StartWind1:
	ld a, $01
	ld [w2d122], a
	jp AdvanceOWFunc

.StartWind2:
	ld a, [wOWFuncCounter]
	cp $0a
	ret nz
	ld a, $01
	ld [w2d124], a
	jp AdvanceOWFunc

.WaitObj9Frame21:
	ld a, [wSceneObj9Frame]
	cp $21
	ret nz
	ld a, $11
	ld hl, wSceneObj9State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait12:
	ld a, 12
	jp WaitOWFunc

.RaiseObj9:
	ld hl, wOWFuncCounter
	ld a, [hl]
	cp $08
	ret nz
	xor a
	ld [hl], a
	ld a, [wSceneObj9YCoord]
	dec a
	ld [wSceneObj9YCoord], a
	cp $45
	ret nz
	jp AdvanceOWFunc

.WaitWind2Done:
	ld a, [w2d124]
	and a
	ret nz
	jp AdvanceOWFunc

.UpdateWind1:
	ld hl, w2d122
	ld a, [hl]
	and a
	ret z
	dec a
	jumptable
	dw .Wind1_Spawn
	dw .Wind1_Drift
	dw .Wind1_Spawn
	dw .Wind1_Drift
	dw .Wind1_Spawn
	dw .Wind1_Drift
	dw .Wind1_End

.Wind1_Spawn:
	ld a, $18
	ld hl, wSceneObj1State
	call SetSceneObjState
	ld hl, wSceneObj1YCoord
	ld a, $5c
	ld [hli], a
	ld a, $82
	ld [hl], a
	ld hl, w2d122
	inc [hl]
	xor a
	ld [w2d123], a
	ret

.Wind1_Drift:
	ld hl, w2d123
	inc [hl]
	ld a, [hl]
	cp $02
	ret nz
	xor a
	ld [hl], a
	ld hl, wSceneObj1YCoord
	dec [hl]
	inc l
	inc [hl]
	ld a, [hl]
	cp $8c
	ret nz
	ld hl, w2d122
	inc [hl]
	ret

.Wind1_End:
	ld a, $00
	ld hl, wSceneObj1State
	call SetSceneObjState
	xor a
	ld [w2d122], a
	ret

.UpdateWind2:
	ld hl, w2d124
	ld a, [hl]
	and a
	ret z
	dec a
	jumptable
	dw .Wind2_Spawn
	dw .Wind2_Drift
	dw .Wind2_Spawn
	dw .Wind2_Drift
	dw .Wind2_Spawn
	dw .Wind2_Drift
	dw .Wind2_Hide
	dw .Wind2_WaitFanFrame4a
	dw .Wind2_HideFan

.Wind2_Spawn:
	ld a, $18
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj2YCoord
	ld a, $5c
	ld [hli], a
	ld a, $82
	ld [hl], a
	ld hl, w2d124
	inc [hl]
	xor a
	ld [w2d125], a
	ret

.Wind2_Drift:
	ld hl, w2d125
	inc [hl]
	ld a, [hl]
	cp $02
	ret nz
	xor a
	ld [hl], a
	ld hl, wSceneObj2YCoord
	dec [hl]
	inc l
	inc [hl]
	ld a, [hl]
	cp $8c
	ret nz
	ld hl, w2d124
	inc [hl]
	ret

.Wind2_Hide:
	ld a, $00
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, w2d124
	inc [hl]
	ret

.Wind2_WaitFanFrame4a:
	ld a, [wSceneObj8Frame]
	cp $4a
	ret nz
	ld a, $19
	ld hl, wSceneObj8State
	call SetSceneObjState
	ld hl, w2d124
	inc [hl]
	inc l
	xor a
	ld [hl], a
	ret

.Wind2_HideFan:
	ld hl, w2d125
	inc [hl]
	ld a, [hl]
	cp $18
	ret nz
	ld a, $00
	ld hl, wSceneObj8State
	call SetSceneObjState
	xor a
	ld [w2d124], a
	ret

SOWFunc_SummonSnake:
	call .MoveNotes
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .PlayFluteSFX
	dw .WaitNotesAndShowSnake
	dw .WaitSnakeComeOut
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.PlayFluteSFX:
	ld a, $01
	ld [wSceneObj7MovementStep], a
	play_sfx SFX_FLUTE
	jp AdvanceOWFunc

.WaitNotesAndShowSnake:
	ld hl, wSceneObj1XCoord
	ld a, $08
	cp [hl]
	ret nz
	ld a, $13
	ld hl, wSceneObj7State
	call SetSceneObjState
	play_sfx SFX_TEMPLE_ROCK
	jp AdvanceOWFunc

.WaitSnakeComeOut:
	ld a, [wSceneObj7Frame]
	cp $31
	ret nz
	jp AdvanceOWFunc

.MoveNotes:
	ld a, [wSceneObj7MovementStep]
	and a
	ret z
	ld hl, wSceneObj1XCoord
	dec [hl]
	ld a, [hl]
	add $18
	cp $f0
	ret c
	xor a
	ld [wSceneObj7MovementStep], a
	ret

SOWFunc_Earthquake:
	call UpdateOWSceneScreenShake

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .StartShake
	dw .Wait120
	dw .PatchTilesAndShowSmoke
	dw .WaitSmokeGone
	dw .ShowSmoke2
	dw .StopShake
	dw .Wait60
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.StartShake:
	ld a, $01
	ld [wOWSceneShakeState], a
	ld a, $01
	ld [wOWSeaGfxVariant], a
	ld a, $03
	ld hl, wOWSeaAnim
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	jp AdvanceOWFunc

.Wait120:
	ld a, 120
	jp WaitOWFunc

.PatchTilesAndShowSmoke:
	ld hl, SOWTilemapPatch_Earthquake
	call ApplyOWTilemapPatchesAndRedraw
	play_sfx SFX_EARTHQUAKE
.asm_b6c86
	ld a, $1b
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceOWFunc

.WaitSmokeGone:
	ld hl, wSceneObj2State
	jp WaitOWObjDisappear

.ShowSmoke2:
	ld hl, wSceneObj2YCoord
	ld a, $02
	add [hl]
	ld [hli], a
	ld a, $fe
	add [hl]
	ld [hl], a
	jr .asm_b6c86

.StopShake:
	ld a, $03
	ld [wOWSceneShakeState], a
	ld hl, wOWSeaAnim
	ld a, $0e
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [wOWSeaGfxVariant], a
	jp AdvanceOWFunc

SOWFunc_GreenMusicBox:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw .PlayMusicBoxSFX
	dw .WaitMusic
	dw .BlowUpCave
	dw .HideSmoke
	dw .Wait40
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.PlayMusicBoxSFX:
	play_sfx SFX_GREEN_MUSIC_BOX
	jp AdvanceOWFunc

.WaitMusic:
	ld a, 254
	jp WaitOWFunc

.BlowUpCave:
	ld hl, SOWTilemapPatch_GreenMusicBox
	call ApplyOWTilemapPatchesAndRedraw
	ld a, $1b
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_EXPLOSION
	jp AdvanceOWFunc

.HideSmoke:
	ld hl, wSceneObj2State
	jp WaitOWObjDisappear

SOWFunc_Explosives:
EOWFunc_Explosives:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20_1
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .CheckMapSide

	; SOUTH
	dw .Explode
	dw .WaitExplosionGone
	dw .Explode2
	dw .WaitExplosionGone
	dw .Explode3
	dw .WaitExplosionGone
	dw .Wait40
	dw EndOWFunc

	; EAST
	dw .EastExplode
	dw .WaitExplosionGone
	dw .Wait20_2
	dw .FadeOutLevelName
	dw .Wait10
	dw .LoadColossalHoleName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .EastExplode2
	dw .EastExplode3
	dw .Wait50
	dw EndOWFunc

.Wait20_1:
	ld a, 20
	jp WaitOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.Wait50:
	ld a, 50
	jp WaitOWFunc

.CheckMapSide:
	ld a, [wCurMapSide]
	cp SOUTH
	jp z, AdvanceOWFunc
	ld a, $0e
	ld [wOWFuncStep], a
	ret

.Explode:
	ld a, $1c
	ld hl, wSceneObj2State
	call SetSceneObjState
.asm_b6d62
	play_sfx SFX_EXPLOSION
	jp AdvanceOWFunc

.WaitExplosionGone:
	ld hl, wSceneObj2State
	jp WaitOWObjDisappear

.Explode2:
	lb de, -5, 4
.asm_b6d76
	ld hl, wSceneObj2YCoord
	ld a, $20
	add d
	ld [hli], a
	ld a, $44
	add e
	ld [hl], a
	jr .Explode

.Explode3:
	lb de, 3, 5
	jr .asm_b6d76

.EastExplode:
	ld a, $08
	ld hl, wSceneObj2State
	call SetSceneObjState
	jr .asm_b6d62

.Wait20_2:
	ld a, 20
	jp WaitOWFunc

.Wait10:
	ld a, 10
	jp WaitOWFunc

.LoadColossalHoleName:
	ld b, EAST
	ld d, OWEAST_THE_COLOSSAL_HOLE
	call LoadLevelName
	xor a
	ld [wPalConfig1TotalSteps], a
	jp AdvanceOWFunc

.EastExplode2:
	ld a, $22
	ld hl, wSceneObj1State
	call SetSceneObjState
	jr .asm_b6d62

.EastExplode3:
	ld a, [wOWFuncCounter]
	cp $14
	ret c
	ld hl, wSceneObj2YCoord
	ld a, $46
	ld [hli], a
	ld a, $50
	ld [hl], a
	ld a, $22
	ld hl, wSceneObj2State
	call SetSceneObjState
	jr .asm_b6d62

.FadeOutLevelName:
	ld a, $03
	ld [wLevelNameFadeState], a
	farcall FadeOutLevelName
	ld a, [wLevelNameFadeState]
	and a
	ret nz
	jp AdvanceOWFunc

SOWFunc_FullMoon:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait40
	dw .PlayGongSFX
	dw .Wait30
	dw .MoveMoon
	dw .Wait60
	dw EndOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.PlayGongSFX:
	play_sfx SFX_GONG
	jp AdvanceOWFunc

.Wait30:
	ld a, 30
	jp WaitOWFunc

.MoveMoon:
	ld a, [wGlobalCounter]
	and %111
	ret nz
	ld hl, wSceneObj14
	dec [hl]
	inc l
	inc [hl]
	ld a, [hl]
	cp $7b
	jr z, .asm_b6e2c
	cp $80
	ret nz
	jp AdvanceOWFunc
.asm_b6e2c
	play_sfx SFX_BEANSTALK_GROW
	ret

LoadOWSceneLevelName:
	ld a, [wCurMapSide]
	ld b, a
	add a
	ld e, a
	ld d, $00
	ld hl, .MapSidePointers
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wOWSceneActionParam]
	dec a
	ld e, a
	add hl, de
	ld d, [hl]
	ld a, b
	and a
	jr z, .is_north
	; levels that are not in the north
	; have their value incremented by 1
	dec d
.is_north
	call LoadLevelName
	xor a
	ld [wPalConfig1TotalSteps], a
	jp AdvanceOWFunc

.MapSidePointers:
	dw .North
	dw .West
	dw .South
	dw .East

.North:
	db $00 ; NOWFUNC_CUT_TREE
	db $00 ; NOWFUNC_OPEN_GATE
	db $00 ; NOWFUNC_GARLIC
	db OWNORTH_THE_VAST_PLAIN ; NOWFUNC_MAGIC_SEED
	db OWNORTH_THE_PEACEFUL_VILLAGE ; NOWFUNC_SUMMON_SNAKE
	db OWNORTH_OUT_OF_THE_WOODS ; NOWFUNC_FALL_LEAVES
	db $00 ; NOWFUNC_BLUE_MUSIC_BOX
	db $00 ; NOWFUNC_GOLD_MUSIC_BOX
	db $00 ; NOWFUNC_CRAYON_RED
	db $00 ; NOWFUNC_CRAYON_BROWN
	db $00 ; NOWFUNC_CRAYON_YELLOW
	db $00 ; NOWFUNC_CRAYON_GREEN
	db $00 ; NOWFUNC_CRAYON_CYAN
	db $00 ; NOWFUNC_CRAYON_BLUE
	db $00 ; NOWFUNC_CRAYON_PINK
	db $00 ; NOWFUNC_BOTTOM_BAR

.West:
	db $00 ; WOWFUNC_RAIN
	db $00 ; WOWFUNC_CLEAR_TORNADO
	db $00 ; WOWFUNC_ELEVATOR_WORKING
	db OWWEST_THE_POOL_OF_RAIN + 1 ; WOWFUNC_MAGIC_SEED
	db OWWEST_THE_VOLCANOS_BASE + 1 ; WOWFUNC_SUMMON_SNAKE
	db OWWEST_THE_VOLCANOS_BASE + 1 ; WOWFUNC_EARTHQUAKE
	db $00 ; WOWFUNC_VULCANO_ERUPTION
	db $00 ; WOWFUNC_RED_MUSIC_BOX

.South:
	db $00 ; SOWFUNC_SEND_SEEDS
	db OWSOUTH_THE_GRASSLANDS + 1 ; SOWFUNC_MAGIC_SEED
	db $00 ; SOWFUNC_YELLOW_MUSIC_BOX
	db $00 ; SOWFUNC_CANYON_THUNDER
	db $00 ; SOWFUNC_RAISE_TOWER
	db $00 ; SOWFUNC_FAN
	db OWSOUTH_THE_GRASSLANDS + 1 ; SOWFUNC_SUMMON_SNAKE
	db OWSOUTH_THE_STEEP_CANYON + 1 ; SOWFUNC_EARTHQUAKE
	db $00 ; SOWFUNC_GREEN_MUSIC_BOX
	db OWSOUTH_CAVE_OF_FLAMES + 1 ; SOWFUNC_EXPLOSIVES
	db $00 ; SOWFUNC_FULL_MOON

.East:
	db $00 ; EOWFUNC_FREEZE_SEA
	db OWEAST_THE_STAGNANT_SWAMP + 1 ; EOWFUNC_EARTHQUAKE
	db $00 ; EOWFUNC_FORM_CASTLE
	db OWEAST_THE_STAGNANT_SWAMP + 1 ; EOWFUNC_EXPLOSIVES
	db $00 ; EOWFUNC_VULCANO_ERUPTION
	db $00 ; EOWFUNC_BURN_VINES
	db $00 ; EOWFUNC_SHOW_WARPED_VOID
	db OWEAST_FOREST_OF_FEAR + 1 ; EOWFUNC_RAISE_PIPE
	db $00 ; EOWFUNC_DAYTIME

WaitOWSceneLevelNameFadeIn:
	farcall FadeInLevelName
	srl c
	ret c ; not done
	jp AdvanceOWFunc

WaitOWScene16Frames:
	ld a, 16
	jp WaitOWFunc

EastOWFunctions:
	ld a, [wOWSceneActionParam]
	dec a
	jumptable
	dw EOWFunc_FreezeSea       ; EOWFUNC_FREEZE_SEA
	dw EOWFunc_Earthquake      ; EOWFUNC_EARTHQUAKE
	dw EOWFunc_FormCastle      ; EOWFUNC_FORM_CASTLE
	dw EOWFunc_Explosives      ; EOWFUNC_EXPLOSIVES
	dw EOWFunc_VulcanoEruption ; EOWFUNC_VULCANO_ERUPTION
	dw EOWFunc_BurnVines       ; EOWFUNC_BURN_VINES
	dw EOWFunc_ShowWarpedVoid  ; EOWFUNC_SHOW_WARPED_VOID
	dw EOWFunc_RaisePipe       ; EOWFUNC_RAISE_PIPE
	dw EOWFunc_Daytime         ; EOWFUNC_DAYTIME

EOWFunc_FreezeSea:
	call .MoveObj1
	call .UpdateTileColumns1
	call .UpdateTileColumns3
	call .UpdateTileColumns2

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait60
	dw .PatchSeaTiles
	dw .StartObj1Move
	dw .Wait14
	dw .StartTileColumns3
	dw .StartTileColumns1
	dw .StartTileColumns2
	dw .WaitObj1Done
	dw .Wait60_2
	dw EndOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.Wait60_2:
	ld a, 60
	jp WaitOWFunc

; unreachable
	ld a, 2
	jp WaitOWFunc

.PatchSeaTiles:
	ld hl, EOWTilemapPatch_FreezeSea
	call ApplyOWTilemapPatchesAndRedraw
	call .load_frozen_sea_pal
	jp AdvanceOWFunc

.StartObj1Move:
	xor a
	ld [wOWCliffsAnimDuration], a
	ld a, $01
	ld [wSceneObj1MovementStep], a
	jp AdvanceOWFunc

.Wait14:
	ld a, 14
	jp WaitOWFunc

.StartTileColumns3:
	ld a, $01
	ld [wOWTileColumnCopy3Counter], a
	ld hl, wOWTileColumnCopy3ListPtr
	play_sfx SFX_SEA_FREEZE
	jr .asm_b6f31

.StartTileColumns1:
	ld a, [wOWFuncCounter]
	cp $04
	ret nz
	ld a, $01
	ld [wOWTileColumnCopy1Counter], a
	ld hl, wOWTileColumnCopy1ListPtr
.asm_b6f31
	ld de, .data
	ld [hl], e
	inc l
	ld [hl], d
	jp AdvanceOWFunc

.StartTileColumns2:
	ld a, [wOWFuncCounter]
	cp $04
	ret nz
	ld a, $01
	ld [wOWTileColumnCopy2Counter], a
	ld hl, wOWTileColumnCopy2ListPtr
	jr .asm_b6f31

.WaitObj1Done:
	ld a, [wSceneObj1MovementStep]
	and a
	ret nz
	jp AdvanceOWFunc

.load_frozen_sea_pal:
	ld hl, EastOWNightPals palette 4
	ld de, wTempPals1 palette 4
	ld c, 1 palettes
	ld b, BANK(EastOWNightPals)
	call CopyFarBytes
	jr .asm_b6f64
	call LoadUnfrozenSeaPal
.asm_b6f64
	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	ld a, BGPI_AUTOINC | palette 4
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, HIGH(wTempPals1 palette 4)
	ld [hli], a
	ld a, LOW(wTempPals1 palette 4)
	ld [hli], a
	ret

.MoveObj1:
	ld a, [wSceneObj1MovementStep]
	and a
	ret z
	dec a
	jr z, .asm_b6f83
	dec a
	jr z, .asm_b6f8c
	ret
.asm_b6f83
	xor a
	ld [w2d122], a
	ld hl, wSceneObj1MovementStep
	inc [hl]
	ret
.asm_b6f8c
	ld hl, w2d122
	inc [hl]
	ld c, [hl]
	ld hl, wSceneObj1XCoord
	inc [hl]
	inc [hl]
	ld a, [hl]
	add $18
	cp $c0
	jr nc, .asm_b6fa9
	cp $78
	ret c
	ld a, c
	and $03
	ret nz
	ld hl, wSceneObj1YCoord
	dec [hl]
	ret
.asm_b6fa9
	xor a
	ld [wSceneObj1MovementStep], a
	ret

.UpdateTileColumns1:
	ld a, [wOWTileColumnCopy1Counter]
	and a
	ret z
	ld hl, wOWTileColumnCopy1Counter
	inc [hl]
	ld a, [hl]
	cp $05
	ret c
	ld a, $01
	ld [hli], a
	ld hl, wOWTileColumnCopy1ListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	cp $80
	jr z, .asm_b6ff9
	ld [wOWTileColumnCopy1RowsLeft], a
	ld a, [hli]
	ld [wOWTileColumnCopy1Dest], a
	ld a, [hli]
	ld [wOWTileColumnCopy1Dest + 1], a
	ld a, [hli]
	ld [wOWTileColumnCopy1Source], a
	ld a, [hli]
	ld [wOWTileColumnCopy1Source + 1], a
	ld a, l
	ld [wOWTileColumnCopy1ListPtr], a
	ld a, h
	ld [wOWTileColumnCopy1ListPtr + 1], a
	farcall CopyOWTileColumn1
	ld a, TRUE
	ld [wOWPendingTileUpdate], a
	ret
.asm_b6ff9
	xor a
	ld [wOWTileColumnCopy1Counter], a
	ret

.UpdateTileColumns2:
	ld a, [wOWTileColumnCopy2Counter]
	and a
	ret z
	ld hl, wOWTileColumnCopy2Counter
	inc [hl]
	ld a, [hl]
	cp $05
	ret c
	ld a, $01
	ld [hli], a
	ld hl, wOWTileColumnCopy2ListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	cp $80
	jr z, .asm_b7051
	ld [wOWTileColumnCopy2RowsLeft], a
	ld a, [hli]
	ld [wOWTileColumnCopy2Dest], a
	ld a, [hli]
	ld [wOWTileColumnCopy2Dest + 1], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, l
	ld [wOWTileColumnCopy2ListPtr], a
	ld a, h
	ld [wOWTileColumnCopy2ListPtr + 1], a
	ld hl, $140
	add hl, de
	ld a, l
	ld [wOWTileColumnCopy2Source], a
	ld a, h
	ld [wOWTileColumnCopy2Source + 1], a
	farcall CopyOWTileColumn2
	ld a, TRUE
	ld [wOWPendingTileUpdate], a
	ret
.asm_b7051
	xor a
	ld [wOWTileColumnCopy2Counter], a
	ret

.UpdateTileColumns3:
	ld a, [wOWTileColumnCopy3Counter]
	and a
	ret z
	ld hl, wOWTileColumnCopy3Counter
	inc [hl]
	ld a, [hl]
	cp $05
	ret c
	ld a, $01
	ld [hli], a
	ld hl, wOWTileColumnCopy3ListPtr
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	cp $80
	jr z, .asm_b70a9
	ld [wOWTileColumnCopy3RowsLeft], a
	ld a, [hli]
	ld [wOWTileColumnCopy3Dest], a
	ld a, [hli]
	ld [wOWTileColumnCopy3Dest + 1], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, l
	ld [wOWTileColumnCopy3ListPtr], a
	ld a, h
	ld [wOWTileColumnCopy3ListPtr + 1], a
	ld hl, $280
	add hl, de
	ld a, l
	ld [wOWTileColumnCopy3Source], a
	ld a, h
	ld [wOWTileColumnCopy3Source + 1], a
	farcall CopyOWTileColumn3
	ld a, TRUE
	ld [wOWPendingTileUpdate], a
	ret
.asm_b70a9
	xor a
	ld [wOWTileColumnCopy3Counter], a
	ret

.data
	db $04, $61, $d6, $c9, $56
	db $04, $62, $d6, $ca, $56
	db $04, $63, $d6, $cb, $56
	db $04, $64, $d6, $cc, $56
	db $04, $65, $d6, $cd, $56
	db $04, $66, $d6, $ce, $56
	db $04, $67, $d6, $cf, $56
	db $04, $68, $d6, $d0, $56
	db $04, $69, $d6, $d1, $56
	db $04, $6a, $d6, $d2, $56
	db $04, $6b, $d6, $d3, $56
	db $04, $6c, $d6, $d4, $56
	db $04, $6d, $d6, $d5, $56
	db $04, $6e, $d6, $d6, $56
	db $05, $4f, $d6, $b7, $56
	db $05, $50, $d6, $b8, $56
	db $05, $51, $d6, $b9, $56
	db $05, $52, $d6, $ba, $56
	db $80 ; end

EOWFunc_Earthquake:
	call UpdateOWSceneScreenShake

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .SetSinkAreaPriority
	dw .SetObj6State03
	dw .Wait10
	dw .StartShake
	dw .SinkObj6_1
	dw .SinkObj6_2
	dw .SinkObj6_3
	dw .SinkObj6_4
	dw .SinkObj6_5
	dw .StopShake
	dw .SetObj6State05
	dw .WaitObj6Frame09
	dw .PatchTiles
	dw .Wait40
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait40:
	ld a, 40
	jp WaitOWFunc

.SetSinkAreaPriority:
	ld b, $04
	hlbgcoord 2, 10, wAttrmap
.asm_b7147
	set B_BG_PRIO, [hl]
	inc hl
	dec b
	jr nz, .asm_b7147
	ld b, $04
	hlbgcoord 2, 11, wAttrmap
.asm_b7152
	set B_BG_PRIO, [hl]
	inc hl
	dec b
	jr nz, .asm_b7152
	ld a, TRUE
	ld [wOWPendingTileUpdate], a
	jp AdvanceOWFunc

.SetObj6State03:
	ld a, $03
	ld hl, wSceneObj6State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait10:
	ld a, 10
	jp WaitOWFunc

.StartShake:
	ld a, $01
	ld [wOWSceneShakeState], a
	ld a, $06
	ld hl, wSceneObj15State
	call SetSceneObjState
	ld a, $04
	ld hl, wSceneObj6State
	call SetSceneObjState
	jp AdvanceOWFunc

.SinkObj6_1:
	ld a, [wOWFuncCounter]
	cp $0a
	ret c
	ld hl, wSceneObj6YCoord
	inc [hl]
	jp AdvanceOWFunc

.SinkObj6_2:
	ld a, [wOWFuncCounter]
	cp $20
	ret c
	ld hl, wSceneObj6YCoord
	inc [hl]
	jp AdvanceOWFunc

.SinkObj6_3:
	ld a, [wOWFuncCounter]
	cp $1c
	ret c
	ld hl, wSceneObj6YCoord
	inc [hl]
	jp AdvanceOWFunc

.SinkObj6_4:
	ld a, [wOWFuncCounter]
	cp $18
	ret c
	ld hl, wSceneObj6YCoord
	inc [hl]
	jp AdvanceOWFunc

.SinkObj6_5:
	ld a, [wOWFuncCounter]
	cp $14
	ret c
	ld hl, wSceneObj6YCoord
	inc [hl]
	jp AdvanceOWFunc

.StopShake:
	ld a, $03
	ld [wOWSceneShakeState], a
	ld a, $07
	ld hl, wSceneObj15State
	call SetSceneObjState
	jp AdvanceOWFunc

.SetObj6State05:
	ld a, $05
	ld hl, wSceneObj6State
	call SetSceneObjState
	jp AdvanceOWFunc

.WaitObj6Frame09:
	ld a, [wSceneObj6Frame]
	cp $09
	ret nz
	jp AdvanceOWFunc

.PatchTiles:
	ld a, [wOWFuncCounter]
	cp $09
	ret c
	ld hl, EOWTilemapPatch_Earthquake
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

UpdateOWSceneScreenShake:
	call .RunShakeScript
	ld hl, wOWSceneShakeState
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .StartScript01
	dw .DoNothing
	dw .WaitStep01ThenStop
	dw .WaitStep01ThenStart11
	dw .WaitStep11ThenStop
	dw .StartScript11
	dw .WaitStep11ThenStop
	dw .StartScript15
	dw .WaitScriptEnd_1
	dw .StartScript1e
	dw .WaitScriptEnd_2

.DoNothing:
	ret

.StartScript01:
	ld a, $01
.start_script
	ld [wOWSceneShakeStep], a
	xor a
	ld [wOWSceneShakeStepCounter], a
	ld hl, wOWSceneShakeState
	inc [hl]
	xor a
	ld [wOWSceneShakeStateCounter], a
	ret

.WaitStep01ThenStop:
	ld a, [wOWSceneShakeStep]
	cp $01
	ret nz
	xor a
	ld [wOWSceneShakeStep], a
	ld [wOWSceneShakeState], a
	ret

.WaitStep01ThenStart11:
	ld a, [wOWSceneShakeStep]
	cp $01
	ret nz
.StartScript11:
	ld a, $11
	jr .start_script

.WaitStep11ThenStop:
	ld a, [wOWSceneShakeStep]
	cp $11
	ret nz
	xor a
	ld [wOWSceneShakeStep], a
	ld [wOWSceneShakeState], a
	ret

.StartScript15:
	ld a, $15
	jr .start_script

.WaitScriptEnd_1:
	ld a, [wOWSceneShakeStep]
	and a
	ret nz
	xor a
	ld [wOWSceneShakeState], a
	ret

.StartScript1e:
	ld a, $1e
	jr .start_script

.WaitScriptEnd_2:
	ld a, [wOWSceneShakeStep]
	and a
	ret nz
	xor a
	ld [wOWSceneShakeState], a
	ret

.RunShakeScript:
	ld hl, wOWSceneShakeStep
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Up1SFX
	dw .Hold1
	dw .Down1
	dw .Hold1
	dw .Up1
	dw .Hold1
	dw .Down1
	dw .Hold1
	dw .Up1
	dw .Hold1
	dw .Down1
	dw .Hold1
	dw .Up1
	dw .Hold1
	dw .Down1
	dw .Hold1Loop
	dw .Up4SFX
	dw .Hold3
	dw .Down4
	dw .Hold3Loop
	dw .Right4SFX
	dw .Hold3
	dw .Left8
	dw .Hold3
	dw .Right8
	dw .Hold3
	dw .Left8
	dw .Hold3
	dw .Right4End
	dw .Right1SFX
	dw .Hold3
	dw .Left2
	dw .Hold3
	dw .Right2
	dw .Hold3
	dw .Left2
	dw .Hold3
	dw .Right1End

.Hold3:
	ld a, [wOWSceneShakeStepCounter]
	cp $03
	ret c
	jr .next_step
.Hold3Loop:
	ld a, [wOWSceneShakeStepCounter]
	cp $03
	ret c
	ld a, [wOWSceneShakeStep]
	sub $04
	ld [wOWSceneShakeStep], a
	jr .next_step
.Hold1:
	ld a, [wOWSceneShakeStepCounter]
	cp $01
	ret c
	jr .next_step
.Hold1Loop:
	ld a, [wOWSceneShakeStepCounter]
	cp $01
	ret c
	ld a, [wOWSceneShakeStep]
	sub $10
	ld [wOWSceneShakeStep], a
	jr .next_step
.Up1SFX:
	play_sfx SFX_RUMBLE
.Up1:
	ld hl, wSCY
	dec [hl]
.next_step
	xor a
	ld hl, wOWSceneShakeStepCounter
	ld [hld], a
	inc [hl]
	ret

.Down1:
	ld hl, wSCY
	inc [hl]
	jr .next_step

.Up4SFX:
	ld hl, wSCY
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	play_sfx SFX_RUMBLE
	jr .next_step

.Down4:
	ld hl, wSCY
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	jr .next_step

.UnreferencedLeft4:
	ld hl, wSCX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	jr .next_step

.Left2:
	ld hl, wSCX
	dec [hl]
	dec [hl]
	jr .next_step

.Right4SFX:
	play_sfx SFX_SLAM
.Right4:
	ld hl, wSCX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	jr .next_step

.Right4End:
	call .Right4
	xor a
	ld [wOWSceneShakeStep], a
	ret

; unreachable
	ld hl, wSCX
	inc [hl]
	inc [hl]
	inc [hl]
	jr .next_step

.Right2:
	ld hl, wSCX
	inc [hl]
	inc [hl]
	jr .next_step

.Right1SFX:
	play_sfx SFX_SLAM
.right_1
	ld hl, wSCX
	inc [hl]
	jr .next_step

.Right1End:
	call .right_1
	xor a
	ld [wOWSceneShakeStep], a
	ret

.Left8:
	ld hl, wSCX
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	jp .next_step

.Right8:
	ld hl, wSCX
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	jp .next_step

EOWFunc_FormCastle:
	call .UpdatePalFade

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait60
	dw .SetObj1State10
	dw .Wait40_2
	dw .SetUnusedW2d121
	dw .MoveObj1AndFadePals
	dw .Wait20
	dw .SetObj1State11
	dw .PatchCastle6
	dw .PatchCastle5
	dw .PatchCastle4
	dw .PatchCastle3
	dw .PatchCastle2
	dw .PatchCastle1
	dw .SetObj7State12
	dw .Wait10
	dw .HideObj1
	dw .FadePalsBack
	dw .Wait40_1
	dw EndOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.Wait40_1:
	ld a, 40
	jp WaitOWFunc

.SetObj1State10:
	ld a, $10
	ld hl, wSceneObj1State
	call SetSceneObjState
	play_sfx SFX_CASTLE_FORM
	jp AdvanceOWFunc

.Wait40_2:
	ld a, 40
	jp WaitOWFunc

.SetUnusedW2d121:
	ld a, $01
	ld [wUnused_2d121], a
	jp AdvanceOWFunc

.MoveObj1AndFadePals:
	call .move_obj1
	ld a, [wSceneObj1MovementStep]
	cp $30
	jr z, .asm_b7404
	cp $50
	jr z, .asm_b7410
	and a
	ret nz
	call .asm_b7410
	jp AdvanceOWFunc
.asm_b7404
	ld a, [wOWFuncCounter]
	and $03
	ret z
	ld a, $01
	ld [wOWScenePalFadeStep], a
	ret

.asm_b7410
	ld a, [wOWFuncCounter]
	and $03
	ret z
	ld hl, wOWScenePalFadeIndex
	inc [hl]
	ret

.move_obj1:
	ld a, [wOWFuncCounter]
	and $03
	ret z
	ld de, FormCastleObj1Movement
	ld hl, wSceneObj1YCoord
	call ApplyOWMovement
	ret

.Wait20:
	ld a, 20
	jp WaitOWFunc

.SetObj1State11:
	ld a, $11
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

.PatchCastle6:
	ld a, [wOWFuncCounter]
	cp $28
	ret c
	ld hl, EOWTilemapPatch_FormCastle6
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.PatchCastle5:
	ld a, [wOWFuncCounter]
	cp $05
	ret c
	ld hl, EOWTilemapPatch_FormCastle5
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.PatchCastle4:
	ld a, [wOWFuncCounter]
	cp $05
	ret c
	ld hl, EOWTilemapPatch_FormCastle4
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.PatchCastle3:
	ld a, [wOWFuncCounter]
	cp $05
	ret c
	ld hl, EOWTilemapPatch_FormCastle3
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.PatchCastle2:
	ld a, [wOWFuncCounter]
	cp $05
	ret c
	ld hl, EOWTilemapPatch_FormCastle2
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.PatchCastle1:
	ld a, [wOWFuncCounter]
	cp $05
	ret c
	ld hl, EOWTilemapPatch_FormCastle1
	call ApplyOWTilemapPatchesAndRedraw
	jp AdvanceOWFunc

.SetObj7State12:
	ld a, $12
	ld hl, wSceneObj7State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait10:
	ld a, 10
	jp WaitOWFunc

.HideObj1:
	ld a, $00
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

.FadePalsBack:
	ld a, [wOWFuncCounter]
	cp $0a
	jr z, .asm_b74c6
	cp $14
	jr z, .asm_b74c6
	cp $21
	ret nz
	ld a, $04
	ld [wOWScenePalFadeStep], a
	jp AdvanceOWFunc
.asm_b74c6
	ld hl, wOWScenePalFadeIndex
	dec [hl]
	ret

.UpdatePalFade:
	ld hl, wOWScenePalFadeStep
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jr z, .asm_b74df
	dec a
	jr z, .asm_b7511
	dec a
	jr z, .asm_b7522
	dec a
	jr z, .asm_b7539
	ret
.asm_b74df
	ld hl, wPalConfig1Index
	ld a, BGPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 6
	ld [hli], a
	ld a, HIGH(wTempBGPals)
	ld [hli], a
	ld a, LOW(wTempBGPals)
	ld [hli], a

	ld hl, wPalConfig2Index
	ld a, BGPI_AUTOINC | palette 0
	ld [hli], a
	ld a, 6
	ld [hli], a
	ld a, HIGH(wTempPals1)
	ld [hli], a
	ld a, LOW(wTempPals1)
	ld [hli], a

	ld hl, EastOWGreyPals
	ld de, wTempBGPals
	ld c, 6 palettes
	ld b, BANK(EastOWGreyPals)
	call CopyFarBytes

.asm_b750a
	xor a
	ld hl, wOWScenePalFadeCounter
	ld [hld], a
	inc [hl]
	ret

.asm_b7511
	call .get_fade_delays
	ld b, [hl]
	ld a, [wOWScenePalFadeCounter]
	cp b
	ret c
	ld hl, wPalConfig1
	ld a, LOW(rBGPI)
	ld [hli], a
	jr .asm_b750a
.asm_b7522
	call .get_fade_delays
	inc hl
	ld b, [hl]
	ld a, [wOWScenePalFadeCounter]
	cp b
	ret c
	ld hl, wPalConfig2
	ld a, LOW(rBGPI)
	ld [hli], a
	xor a
	ld hl, wOWScenePalFadeCounter
	ld [hld], a
	dec [hl]
	ret

.asm_b7539
	ld hl, wPalConfig2
	ld a, LOW(rBGPI)
	ld [hli], a
	xor a
	ld [wOWScenePalFadeStep], a
	ret

.get_fade_delays:
	ld a, [wOWScenePalFadeIndex]
	add a
	ld e, a
	ld d, $00
	ld hl, .data
	add hl, de
	ret

.data
	db $05, $02
	db $03, $02
	db $02, $01
	db $fa, $49
	db $d1, $fe
	db $03, $d8
	db $21, $d0
	db $d0, $3e
	db $68, $22
	db $18, $a6
	db $fa, $49
	db $d1, $fe
	db $02, $d8
	db $21, $d0
	db $d0, $3e
	db $68, $22
	db $18, $98
	db $fa, $49
	db $d1, $fe
	db $01, $d8
	db $21, $d6
	db $d0, $3e
	db $68, $22
	db $18, $b2

EOWFunc_VulcanoEruption:
	call .UpdateRockLauncher
	call UpdateOWSceneScreenShake
	call .UpdateObj10
	call .UpdateObj12
	call .UpdateObj13
	call .UpdateObj14
	call .UpdateObj15
	call PlayVolcanoRumbleSFX

	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .StartRumbleSFX
	dw .StartShakeAndRocks
	dw .WaitShakeEnd
	dw .Wait56
	dw .StartObj10
	dw .StartObj13
	dw .StartObj14
	dw .StartObj12
	dw .StartObj15
	dw .WaitObj15Done
	dw .Wait180
	dw EndOWFunc

.StartRumbleSFX:
	ld a, $01
	ld [wOWSceneSFXLoopActive], a
	jp AdvanceOWFunc

.Wait180:
	ld a, 180
	jp WaitOWFunc

.StartShakeAndRocks:
	ld a, $0a
	ld [wOWSceneShakeState], a
	ld a, $01
	ld [wOWSceneRockLauncherStep], a
	jp AdvanceOWFunc

.WaitShakeEnd:
	ld a, [wOWSceneShakeState]
	and a
	ret nz
	jp AdvanceOWFunc

.Wait56:
	ld a, 56
	jp WaitOWFunc

.StartObj10:
	play_sfx SFX_VOLCANO_ERUPTION
	ld a, $01
	ld [w2d134], a
	jp AdvanceOWFunc

.StartObj13:
	ld a, [wOWFuncCounter]
	cp $08
	ret c
	ld a, $01
	ld [w2d13a], a
	jp AdvanceOWFunc

.StartObj14:
	ld a, [wOWFuncCounter]
	cp $3c
	ret c
	ld a, $01
	ld [w2d13c], a
	jp AdvanceOWFunc

.StartObj12:
	ld a, [wOWFuncCounter]
	cp $08
	ret c
	ld a, $01
	ld [w2d138], a
	jp AdvanceOWFunc

.StartObj15:
	ld a, [wOWFuncCounter]
	cp $08
	ret c
	ld a, $01
	ld [w2d13e], a
	jp AdvanceOWFunc

.WaitObj15Done:
	ld a, [w2d13e]
	and a
	ret nz
	jp AdvanceOWFunc

.UpdateObj10:
	ld hl, w2d134
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Obj10_Show
	dw .Obj10_WaitState0b
	dw .Obj10_Wait90
	dw .Obj10_Hide

.Obj10_Show:
	ld a, $0a
	ld hl, wSceneObj10State
	call SetSceneObjState
.asm_b7646
	ld hl, w2d134
.asm_b7649
	inc [hl]
	inc l
	xor a
	ld [hl], a
	ret

.Obj10_WaitState0b:
	ld a, [wSceneObj10State]
	cp $0b
	ret nz
	jr .asm_b7646

.Obj10_Wait90:
	ld a, $5a
	ld hl, w2d135
	cp [hl]
	ret nc
	jr .asm_b7646

.Obj10_Hide:
	ld a, $00
	ld hl, wSceneObj10State
	call SetSceneObjState
	xor a
	ld [w2d134], a
	ret

.UpdateObj12:
	ld hl, w2d138
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Obj12_Show
	dw .Obj12_WaitState0e
	dw .Obj12_Wait90
	dw .Obj12_Hide

.Obj12_Show:
	ld a, $0d
	ld hl, wSceneObj12State
	call SetSceneObjState
.asm_b7685
	ld hl, w2d138
	jp .asm_b7649

.Obj12_WaitState0e:
	ld a, [wSceneObj12State]
	cp $0e
	ret nz
	jr .asm_b7685

.Obj12_Wait90:
	ld a, $5a
	ld hl, w2d139
	cp [hl]
	ret nc
	jr .asm_b7685

.Obj12_Hide:
	ld a, $00
	ld hl, wSceneObj12State
	call SetSceneObjState
	xor a
	ld [w2d138], a
	ret

.UpdateObj13:
	ld hl, w2d13a
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Obj13_Show
	dw .Obj13_WaitState0e
	dw .Obj13_Wait90
	dw .Obj13_Hide

.Obj13_Show:
	ld a, $0d
	ld hl, wSceneObj13State
	call SetSceneObjState
.asm_b76c2
	ld hl, w2d13a
	jp .asm_b7649

.Obj13_WaitState0e:
	ld a, [wSceneObj13State]
	cp $0e
	ret nz
	jr .asm_b76c2

.Obj13_Wait90:
	ld a, $5a
	ld hl, w2d13b
	cp [hl]
	ret nc
	jr .asm_b76c2

.Obj13_Hide:
	ld a, $00
	ld hl, wSceneObj13State
	call SetSceneObjState
	xor a
	ld [w2d13a], a
	ret

.UpdateObj14:
	ld hl, w2d13c
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Obj14_Show
	dw .Obj14_Wait90
	dw .Obj14_Hide

.Obj14_Show:
	ld a, $0e
	ld hl, wSceneObj14State
	call SetSceneObjState
.asm_b76fd
	ld hl, w2d13c
	jp .asm_b7649

.Obj14_Wait90:
	ld a, $5a
	ld hl, w2d13d
	cp [hl]
	ret nc
	jr .asm_b76fd

.Obj14_Hide:
	ld a, $00
	ld hl, wSceneObj14State
	call SetSceneObjState
	xor a
	ld [w2d13c], a
	ret

.UpdateObj15:
	ld hl, w2d13e
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .Obj15_Show
	dw .Obj15_Wait90
	dw .Obj15_Hide

.Obj15_Show:
	ld a, $0e
	ld hl, wSceneObj15State
	call SetSceneObjState
.asm_b7730
	ld hl, w2d13e
	jp .asm_b7649

.Obj15_Wait90:
	ld a, $5a
	ld hl, w2d13f
	cp [hl]
	ret nc
	jr .asm_b7730

.Obj15_Hide:
	ld a, $00
	ld hl, wSceneObj15State
	call SetSceneObjState
	xor a
	ld [w2d13e], a
	ret

.UpdateRockLauncher:
	call WOWFunc_VulcanoEruption.UpdateLeftRock
	call WOWFunc_VulcanoEruption.UpdateRightRock
	ld hl, wOWSceneRockLauncherStep
	ld a, [hli]
	and a
	ret z
	inc [hl]
	dec a
	jumptable
	dw .LaunchLeftRock1
	dw .LaunchRightRock
	dw .LaunchLeftRock2
	dw .StopLauncher

.rock_sfx_and_next:
	play_sfx SFX_TEMPLE_ROCK
	ld hl, wOWSceneRockLauncherCounter
	xor a
	ld [hld], a
	inc [hl]
	ret

.LaunchLeftRock1:
	ld a, [wOWSceneRockLauncherCounter]
	cp $50
	ret c
	ld a, $05
	ld [w2d122], a
	jr .rock_sfx_and_next

.LaunchRightRock:
	ld a, [wOWSceneRockLauncherCounter]
	cp $3c
	ret c
	ld a, $07
	ld [w2d126], a
	jr .rock_sfx_and_next

.LaunchLeftRock2:
	ld a, [wOWSceneRockLauncherCounter]
	cp $50
	ret c
	ld a, $07
	ld [w2d122], a
	jr .rock_sfx_and_next

; unreachable
	ld a, [wOWSceneRockLauncherCounter]
	cp $3c
	ret c
	ld a, $05
	ld [w2d126], a
	jr .rock_sfx_and_next
.StopLauncher:
	xor a
	ld [wOWSceneRockLauncherStep], a
	ret

EOWFunc_BurnVines:
	call .PlayObj1StateSFX
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait40_1
	dw .SetObj1State15
	dw .Wait60
	dw .SetObj1State16
	dw .Wait30_2
	dw .SetObj1State14
	dw .Wait90
	dw .HideObj9
	dw .Wait40_2
	dw .SetObj1State18
	dw .WaitObj1Disappear
	dw .Wait30_1
	dw EndOWFunc

.PlayObj1StateSFX:
	ld hl, w2d123
	inc [hl]
	ld a, [hl]
	cp $0f
	ret c
	xor a
	ld [hl], a
	ld a, [wSceneObj1State]
	cp $15
	jr z, .asm_b77fa
	cp $16
	jr z, .asm_b77f1
	cp $14
	jr z, .asm_b77e8
	ret
.asm_b77e8
	play_sfx SFX_FIRE
	ret
.asm_b77f1
	play_sfx SFX_125
	ret
.asm_b77fa
	play_sfx SFX_126
	ret

.Wait40_1:
	ld a, 40
	jp WaitOWFunc

.Wait30_1:
	ld a, 30
	jp WaitOWFunc
.SetObj1State15:
	ld a, $15
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.SetObj1State16:
	ld a, $16
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait30_2:
	ld a, 30
	jp WaitOWFunc

.SetObj1State14:
	ld a, $14
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

.Wait90:
	ld a, 90
	jp WaitOWFunc

.HideObj9:
	ld a, $00
	ld hl, wSceneObj9State
	call SetSceneObjState
	jr .SetObj1State15

.Wait40_2:
	ld a, 40
	jp WaitOWFunc

.SetObj1State18:
	ld a, $18
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp AdvanceOWFunc

.WaitObj1Disappear:
	ld hl, wSceneObj1State
	jp WaitOWObjDisappear

EOWFunc_ShowWarpedVoid:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait60
	dw .SetObj5State1b
	dw .WaitObj5State19
	dw .Wait160
	dw EndOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.Wait160:
	ld a, 160
	jp WaitOWFunc

.SetObj5State1b:
	ld a, $1b
	ld hl, wSceneObj5State
	call SetSceneObjState
	play_sfx SFX_WARPED_VOID_APPEAR
	jp AdvanceOWFunc

.WaitObj5State19:
	ld hl, wSceneObj5State
	ld b, $19
	jp WaitOWObjState

EOWFunc_RaisePipe:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait20
	dw LoadOWSceneLevelName
	dw WaitOWSceneLevelNameFadeIn
	dw WaitOWScene16Frames
	dw .ShowObj8
	dw .PlayRaiseSFX
	dw .WaitObj8State1c
	dw .Wait60
	dw EndOWFunc

.Wait20:
	ld a, 20
	jp WaitOWFunc

.Wait60:
	ld a, 60
	jp WaitOWFunc

.ShowObj8:
	ld a, $37
	ld [wSceneObj8], a
	ld a, $1d
	ld hl, wSceneObj8State
	call SetSceneObjState
	jp AdvanceOWFunc

.PlayRaiseSFX:
	ld a, [wOWFuncCounter]
	cp $10
	ret c
	play_sfx SFX_FAT_WALK
	jp AdvanceOWFunc

.WaitObj8State1c:
	ld b, $1c
	ld hl, wSceneObj8State
	jp WaitOWObjState

EOWFunc_Daytime:
	ld a, [wOWFuncStep]
	jumptable
	dw AdvanceOWFunc
	dw .Wait60_1
	dw .DaytimeTransition
	dw .Wait60_2
	dw EndOWFunc

.Wait60_1:
	ld a, 60
	jp WaitOWFunc

.Wait60_2:
	ld a, 60
	jp WaitOWFunc

.DaytimeTransition:
	farcall DaytimeTransition
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	di
	farcall VBlank_OWScene
	ei
	jp AdvanceOWFunc

OWFunc_DoNothing:
	ret

UpdateMapSideOWAnimations:
	ld a, [wCurMapSide]
	jumptable

	dw .North ; NORTH
	dw .West  ; WEST
	dw .South ; SOUTH
	dw .East  ; EAST

.North:
	ld bc, wSceneObj2State
	call UpdateNorthOWObjMapAnim
	ld bc, wSceneObj3State
	call UpdateNorthOWObjMapAnim
	ld bc, wSceneObj6State
	call UpdateNorthOWObjMapAnim
	ld bc, wSceneObj7State
	call UpdateNorthOWObjMapAnim
	ld bc, wSceneObj14State
	call UpdateNorthOWObjMapAnim
	ld bc, wSceneObj15State
	jp UpdateNorthOWObjMapAnim

.West:
	ld bc, wSceneObj1State
	call UpdateWestOWObjMapAnim
	ld bc, wSceneObj7State
	call UpdateWestOWObjMapAnim
	ld bc, wSceneObj8State
	call UpdateWestOWObjMapAnim
	ld bc, wSceneObj5State
	jp UpdateWestOWObjMapAnim

.South:
	ld bc, wSceneObj7State
	call UpdateSouthOWObjMapAnim
	ld bc, wSceneObj14State
	call UpdateSouthOWObjMapAnim
	ld bc, wSceneObj15State
	jp UpdateSouthOWObjMapAnim

.East:
	ld bc, wSceneObj5State
	call UpdateEastOWObjMapAnim
	ld bc, wSceneObj7State
	jp UpdateEastOWObjMapAnim

UpdateNorthOWObjMapAnim:
	ld a, [bc]
	jumptable

	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw .Obj3BreakWhenWarioNear
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw .Obj2ReactToWario
	dw OWFunc_DoNothing
	dw UpdateNorthLeaves
	dw UpdateNorthLeaves
	dw UpdateNorthLeaves
	dw UpdateNorthLeaves
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw .Obj15WaitForDay
	dw .Obj15WaitForNight
	dw .Obj14WaitForDay
	dw .Obj14WaitForNight
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing

.Obj3BreakWhenWarioNear:
	ld a, [wCurEvent]
	and a
	ret nz
	ld a, [wLevel2]
	cp $06
	ret nz
	ld a, $06
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_BLOCK_BREAK
	ret

.Obj15WaitForDay:
	ld a, [wOWIsNight]
	and a
	ret nz
	ld a, $17
	ld hl, wSceneObj15State
	call SetSceneObjState
	ret

.Obj15WaitForNight:
	ld a, [wOWIsNight]
	and a
	ret z
	ld a, $16
	ld hl, wSceneObj15State
	call SetSceneObjState
	ret

.Obj14WaitForDay:
	ld a, [wOWIsNight]
	and a
	ret nz
	ld a, $1b
	ld hl, wSceneObj14State
	call SetSceneObjState
	ret

.Obj14WaitForNight:
	ld a, [wOWIsNight]
	and a
	ret z
	ld a, $1a
	ld hl, wSceneObj14State
	call SetSceneObjState
	ret

.Obj2ReactToWario:
	call .check_wario_near_obj2
	ld hl, w2d125
	jr z, .asm_b7a3f
	inc [hl]
	ld a, [hl]
	cp $78
	ret c

.asm_b7a3f
	xor a
	ld [hl], a
	ld [w2d124], a
	call .check_wario_near_obj2
	ld b, $1d
	jr nz, .asm_b7a52
	ld a, $01
	ld [w2d124], a
	ld b, $0d
.asm_b7a52
	ld a, b
	ld hl, wSceneObj2State
	call SetSceneObjState
	ret

.check_wario_near_obj2:
	ld a, [wCurEvent]
	and a
	ret nz
	ld a, [w2d124]
	and a
	ret nz
	ld a, [wMapSideLevelID]
	cp $02
	ret z
	cp $07
	ret

UpdateWestOWObjMapAnim:
	ld a, [bc]
	jumptable

	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw WestOWObjUpdateTornado
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw WestOWObj8WaitForNight
	dw OWFunc_DoNothing
	dw WestOWObj8WaitForDay
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw WestOWObj5ReactToWario
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing

WestOWObjUpdateTornado:
	ld a, [wCurEvent]
	cp $04
	ret z
	jp UpdateOWTornado

WestOWObj8WaitForNight:
	ld a, [wCurEvent]
	and a
	ret nz
	ld hl, wSceneObj8MovementStep
	ld a, [hl]
	and a
	jr nz, .asm_b7ad7
	ld a, [wSceneObj7State]
	and a
	ret nz
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	inc [hl]
.asm_b7ad7
	ld a, [wOWIsNight]
	and a
	jr nz, .asm_b7af0
	ld a, [wOWPalTransitionState]
	cp $02
	ret nz
	ld a, $07
.asm_b7ae5
	ld hl, wSceneObj7State
	call SetSceneObjState
	xor a
	ld [wSceneObj8MovementStep], a
	ret
.asm_b7af0
	ld a, $08
	ld [wSceneObj8State], a
	xor a
	ld [wSceneObj8Duration], a
	jr .asm_b7ae5

WestOWObj8WaitForDay:
	ld a, [wCurEvent]
	and a
	ret nz
	ld hl, wSceneObj8MovementStep
	ld a, [hl]
	and a
	jr nz, .asm_b7b0d
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	inc [hl]
.asm_b7b0d
	ld a, [wOWIsNight]
	and a
	jr z, .asm_b7b19
	ld a, [wOWPalTransitionState]
	cp $02
	ret nz
.asm_b7b19
	ld a, $06
	ld [wSceneObj8State], a
	xor a
	ld [wSceneObj8Duration], a
	ld [wSceneObj8MovementStep], a
	ret

WestOWObj5ReactToWario:
	call CheckWarioNearWestOWObj5
	ld hl, w2d12b
	jr z, .asm_b7b33
	inc [hl]
	ld a, [hl]
	cp $78
	ret c
.asm_b7b33
	xor a
	ld [hl], a
	ld [w2d12a], a
	call CheckWarioNearWestOWObj5
	ld b, $13
	jr nz, .asm_b7b46
	ld a, $01
	ld [w2d12a], a
	ld b, $10
.asm_b7b46
	ld a, b
	ld hl, wSceneObj5State
	call SetSceneObjState
	ret

CheckWarioNearWestOWObj5:
	ld a, [wCurEvent]
	and a
	ret nz
	ld a, [w2d12a]
	and a
	ret nz
	ld a, [wMapSideLevelID]
	cp $01
	ret z
	cp $02
	ret

UpdateEastOWObjMapAnim:
	ld a, [bc]
	jumptable

	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw EastOWObj7WaitForDay
	dw EastOWObj7WaitForNight
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw EastOWObj5IdleTimer
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing

EastOWObj7WaitForDay:
	call EastOWObj7CheckSkip
	ret nz
	ld a, [wOWIsNight]
	and a
	jr z, .asm_b7bc2
	ld a, [wOWPalTransitionState]
	cp $02
	ret nz
.asm_b7bb9
	ld a, $13
	ld hl, wSceneObj7State
	call SetSceneObjState
	ret
.asm_b7bc2
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	jr .asm_b7bb9

EastOWObj7WaitForNight:
	call EastOWObj7CheckSkip
	ret nz
	ld a, [wOWIsNight]
	and a
	jr nz, .asm_b7be2
	ld a, [wOWPalTransitionState]
	cp $02
	ret nz
.asm_b7bd9
	ld a, $12
	ld hl, wSceneObj7State
	call SetSceneObjState
	ret
.asm_b7be2
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	jr .asm_b7bd9

EastOWObj7CheckSkip:
	ld a, [wOWSceneAction]
	cp UNLOCK_LEVEL
	jr z, .asm_b7bf9
	cp HIGHLIGHT_LEVEL
	jr z, .asm_b7bf9
	ld a, [wCurEvent]
	and a
	ret
.asm_b7bf9
	ld a, $00
	ld hl, wSceneObj7State
	call SetSceneObjState
	ld a, $01
	and a
	ret

EastOWObj5IdleTimer:
	ld a, [wCurEvent]
	and a
	ret nz
	ld hl, w2d12b
	inc [hl]
	ret nz
	ld a, $1a
	ld hl, wSceneObj5State
	call SetSceneObjState
	ret

UpdateSouthOWObjMapAnim:
	ld a, [bc]
	jumptable

	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw SouthOWObj7ReactToWario
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw OWFunc_DoNothing
	dw SouthOWObj15WaitForDay
	dw SouthOWObj15WaitForNight
	dw MoveSouthOWObj14Diagonally

SouthOWObj7ReactToWario:
	call CheckWarioNearSouthOWObj7
	ld hl, w2d12f
	jr z, .asm_b7c69
	inc [hl]
	ld a, [hl]
	cp $78
	ret c
.asm_b7c69
	xor a
	ld [hl], a
	ld [w2d12e], a
	call CheckWarioNearSouthOWObj7
	ld b, $1d
	jr nz, .asm_b7c7c
	ld a, $01
	ld [w2d12e], a
	ld b, $14
.asm_b7c7c
	ld a, b
	ld hl, wSceneObj7State
	call SetSceneObjState
	ret

CheckWarioNearSouthOWObj7:
	ld a, [wCurEvent]
	and a
	ret nz
	ld a, [w2d12e]
	and a
	ret nz
	ld a, [wMapSideLevelID]
	cp $00
	ret z
	cp $01
	ret

SouthOWObj15WaitForDay:
	ld a, [wOWIsNight]
	and a
	ret nz
	ld a, $1f
	ld hl, wSceneObj15State
	call SetSceneObjState
	ret

SouthOWObj15WaitForNight:
	ld a, [wOWIsNight]
	and a
	ret z
	ld a, $1e
	ld hl, wSceneObj15State
	call SetSceneObjState
	ret

MoveSouthOWObj14Diagonally:
	ld a, [wCurEvent]
	and a
	ret nz
	ld a, [w2d07c]
	and a
	jr z, .asm_b7ce7
	jr .asm_b7cc0 ; unnecessary jump
.asm_b7cc0
	ld a, [wSceneObj14XCoord]
	cp $80
	ret z
	ld a, [w2d07d]
	and a
	call z, .reset_position_once
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wSceneObj14YCoord
	dec [hl]
	inc l
	inc [hl]
	ret

.reset_position_once:
	ld hl, w2d07d
	inc [hl]
	ld hl, wSceneObj14YCoord
	ld [hl], $25
	inc l
	ld [hl], $70
	ret

.asm_b7ce7
	ld a, [wSceneObj14XCoord]
	cp $70
	ret z
	ld a, [w2d07d]
	and a
	call z, .set_moved
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wSceneObj14YCoord
	dec [hl]
	inc l
	inc [hl]
	ld a, [hl]
	cp $88
	ret nz
	ld hl, wSceneObj14YCoord
	ld [hl], $25
	inc l
	ld [hl], $70
	ret

.set_moved:
	ld hl, w2d07d
	inc [hl]
	ret
