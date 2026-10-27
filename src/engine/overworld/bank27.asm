InitCutscene02:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(CutTreeCutscenePals_b8c00)
	ld hl, CutTreeCutscenePals_b8c00
	call LoadFarPalsToTempPals2
	call LoadCutscenes1Gfx_Vram0
	call LoadCutsceneBGMaps01
	jp LoadCutsceneBGMaps02

InitCutscene03:
	ld b, BANK(SharedCutsceneBGPals_b8240)
	ld hl, SharedCutsceneBGPals_b8240
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenNorthGateCutscenePals_b88c0)
	ld hl, OpenNorthGateCutscenePals_b88c0
	call LoadFarPalsToTempPals2
	call LoadCutscenes3Gfx
	jp LoadCutsceneBGMaps07

InitCutscene04:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(ExpelTornadoCutscenePals_b8ec0)
	ld hl, ExpelTornadoCutscenePals_b8ec0
	call LoadFarPalsToTempPals2
	call LoadCutscenes8Gfx_Vram0
	call LoadCutsceneBGMaps01
	jp LoadCutsceneBGMaps02

InitCutscene06:
	call LoadCutscenes3Gfx

	decompress_attrmap Cutscene08Attrmap, v1BGMap0
	decompress_tilemap Cutscene08Tilemap, v0BGMap0

	ld b, BANK(RainstormCutscenePals_b8080)
	ld hl, RainstormCutscenePals_b8080
	call LoadFarPalsToTempPals1
	ld b, BANK(RainstormCutscenePals_b8900)
	ld hl, RainstormCutscenePals_b8900
	call LoadFarPalsToTempPals2
	jp InitCutscene06Objs

InitCutscene07:
	call LoadCutscenes1Gfx_Vram0

	decompress_attrmap Cutscene06Attrmap, v1BGMap0
	decompress_tilemap Cutscene06Tilemap, v0BGMap0

	ld b, BANK(FixElevatorCutscenePals_b8000)
	ld hl, FixElevatorCutscenePals_b8000
	call LoadFarPalsToTempPals1
	ld b, BANK(FixElevatorCutscenePals_b89c0)
	ld hl, FixElevatorCutscenePals_b89c0
	call LoadFarPalsToTempPals2
	jp InitCutscene07Objs

InitCutscene08:
	ld hl, MusicBoxCutscenePals_b8ac0
;	fallthrough

InitMusicBoxCutscene:
	ld b, BANK(MusicBoxCutscenePals_b8ac0)
	call LoadFarPalsToTempPals2
	ld hl, SharedCutsceneBGPals_b8200
	ld b, BANK(SharedCutsceneBGPals_b8200)
	call LoadFarPalsToTempPals1

	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	call LoadCutscenes2Gfx
	call LoadCutsceneBGMaps01
	jp LoadCutsceneBGMaps04

InitCutscene10:
	ld hl, BlueMusicBoxCutscenePals_b8b00
	jr InitMusicBoxCutscene

InitCutscene1d:
	ld hl, RedMusicBoxCutscenePals_b8b80
	jr InitMusicBoxCutscene

InitCutscene17:
	ld hl, GreenMusicBoxCutscenePals_b8b40
	jr InitMusicBoxCutscene

InitCutscene25:
	ld hl, GoldMusicBoxCutscenePals_b8bc0
	jr InitMusicBoxCutscene

InitCutscene09:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(PlantSeedsCutscenePals_b8a80)
	ld hl, PlantSeedsCutscenePals_b8a80
	call LoadFarPalsToTempPals2
	call LoadCutscenes2Gfx
	jp LoadCutsceneBGMaps03

InitCutscene0a:
	ld b, BANK(SharedCutsceneBGPals_b8040)
	ld hl, SharedCutsceneBGPals_b8040
	call LoadFarPalsToTempPals1
	ld b, BANK(RaiseTowerCutscenePals_b8a00)
	ld hl, RaiseTowerCutscenePals_b8a00
	call LoadFarPalsToTempPals2
	call LoadCutscenes1Gfx_Vram0
	call LoadCutsceneBGMaps03
	jp InitCutscene0aObjs

InitCutscene0c:
	ld b, BANK(SharedCutsceneBGPals_b8040)
	ld hl, SharedCutsceneBGPals_b8040
	call LoadFarPalsToTempPals1
	ld b, BANK(BlowMistCutscenePals_b8d40)
	ld hl, BlowMistCutscenePals_b8d40
	call LoadFarPalsToTempPals2
	call LoadCutscenes4Gfx
	jp LoadCutsceneBGMaps03

InitCutscene0d:
	ld b, BANK(SharedCutsceneBGPals_b8040)
	ld hl, SharedCutsceneBGPals_b8040
	call LoadFarPalsToTempPals1
	ld b, BANK(SummonSnakesCutscenePals_b8dc0)
	ld hl, SummonSnakesCutscenePals_b8dc0
	call LoadFarPalsToTempPals2
	call LoadCutscenes4Gfx
	call LoadCutsceneBGMaps01
	jp LoadCutsceneBGMaps02

InitCutscene0e:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(FreezeSeaCutscenePals_b8980)
	ld hl, FreezeSeaCutscenePals_b8980
	call LoadFarPalsToTempPals2
	call LoadCutscenes1Gfx_Vram0
	call LoadCutsceneBGMaps03
	jp LoadCutsceneBGMaps21

InitCutscene11:
	ld b, BANK(SharedCutsceneBGPals_b8040)
	ld hl, SharedCutsceneBGPals_b8040
	call LoadFarPalsToTempPals1
	ld b, BANK(SummonLightningCutscenePals_b8c40)
	ld hl, SummonLightningCutscenePals_b8c40
	call LoadFarPalsToTempPals2
	call LoadCutscenes1Gfx_Vram0
	call LoadCutsceneBGMaps03
	jp LoadCutsceneBGMaps21

InitCutscene13:
	ld b, BANK(SharedCutsceneBGPals_b8040)
	ld hl, SharedCutsceneBGPals_b8040
	call LoadFarPalsToTempPals1
	ld b, BANK(FootStoneCutscenePals_b8e00)
	ld hl, FootStoneCutscenePals_b8e00
	call LoadFarPalsToTempPals2
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	call LoadCutscenes4Gfx
	jp LoadCutsceneBGMaps05

InitCutscene14:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(VolcanoEruptionCutscenePals_b8a40)
	ld hl, VolcanoEruptionCutscenePals_b8a40
	call LoadFarPalsToTempPals2
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	call LoadCutscenes2Gfx
	call LoadCutsceneBGMaps01
	jp LoadCutsceneBGMaps05

InitCutscene15:
	ld b, BANK(OpenBlueSnakeDoorCutscenePals_b81c0)
	ld hl, OpenBlueSnakeDoorCutscenePals_b81c0
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenBlueSnakeDoorCutscenePals_b8e80)
	ld hl, OpenBlueSnakeDoorCutscenePals_b8e80
	call LoadFarPalsToTempPals2
.asm_9c367
	ld a, LCDC_WINDOW
	ld [wLCDCFlagsToFlip], a
	ld a, $28
	ldh [rWY], a
	ld [wCutsceneWY], a
	ld a, 80 + WX_OFS
	ldh [rWX], a
	ld [wCutsceneWX], a
	call LoadCutscenes2Gfx
	call LoadCutsceneBGMaps14
	call LoadCutsceneBGMaps13
	jp InitCutscene15Objs

InitCutscene19:
	ld b, BANK(RevealCastleCutscenePals_b8140)
	ld hl, RevealCastleCutscenePals_b8140
	call LoadFarPalsToTempPals1
	ld b, BANK(RevealCastleCutscenePals_b8940)
	ld hl, RevealCastleCutscenePals_b8940
	call LoadFarPalsToTempPals2
	call LoadCutscenes4Gfx
	jp LoadCutsceneBGMaps12

InitCutscene1b:
	call LoadCutscenes4Gfx

	decompress_tiles1 OwlGfx, v1Tiles0

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld b, BANK(LevelMainTiles28)
	ld hl, LevelMainTiles28
	call LoadFarTiles
	xor a
	ldh [rVBK], a

	call LoadCutsceneBGMaps03

	decompress_attrmap Cutscene33Attrmap, v1BGMap1
	decompress_tilemap Cutscene33Tilemap, v0BGMap1

	ld b, BANK(SharedCutsceneBGPals_b8040)
	ld hl, SharedCutsceneBGPals_b8040
	call LoadFarPalsToTempPals1
	ld b, BANK(SummonSunCutscenePals_b8c80)
	ld hl, SummonSunCutscenePals_b8c80
	call LoadFarPalsToTempPals2
	jp SetBGPriorityOnTopRows_BGMap1

InitCutscene1e:
	ld b, BANK(ExplodeBombsCutscenePals_b80c0)
	ld hl, ExplodeBombsCutscenePals_b80c0
	call LoadFarPalsToTempPals1
	ld b, BANK(ExplodeBombsCutscenePals_b8cc0)
	ld hl, ExplodeBombsCutscenePals_b8cc0
	call LoadFarPalsToTempPals2

	call LoadCutscenes3Gfx

	decompress_attrmap Cutscene09Attrmap, v1BGMap0
	decompress_tilemap Cutscene09Tilemap, v0BGMap0

	jp InitCutscene1eObjs

InitCutscene22:
	call LoadCutscenes3Gfx

	decompress_attrmap Cutscene10Attrmap, v1BGMap0
	decompress_tilemap Cutscene10Tilemap, v0BGMap0

	jp ClearTempPals_Bank27

InitCutscene24:
	ld b, BANK(OpenTreeMouthCutscenePals_b82c0)
	ld hl, OpenTreeMouthCutscenePals_b82c0
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenTreeMouthCutscenePals_b82c0)
	ld hl, OpenTreeMouthCutscenePals_b82c0
	call LoadFarPalsToTempPals2
	call LoadCutscenes8Gfx_Vram0
	call LoadCutsceneBGMaps28
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld b, BANK(SpecialTiles0)
	ld hl, SpecialTiles0
	call LoadFarTiles
	xor a
	ldh [rVBK], a
	jp InitCutscene24Objs

InitCutscene27:
	ld b, BANK(LevelMainTiles14)
	ld hl, LevelMainTiles14
	call LoadFarTiles
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld b, BANK(SpecialTiles1)
	ld hl, SpecialTiles1
	call LoadFarTiles
	xor a
	ldh [rVBK], a

	decompress_attrmap Cutscene11Attrmap, v1BGMap0
	decompress_tilemap Cutscene11Tilemap, v0BGMap0

	ld hl, RoomPals023
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(RoomPals023)
	call CopyFarBytes

	decompress_tiles1 CartGfx, v0Tiles1

	ld hl, .palette
	ld de, wTempPals2 palette 6
	ld b, 1 palettes
	call CopyHLToDE

	jp InitCutscene27Objs

.palette
	rgb  0, 25,  0
	rgb 31, 31, 25
	rgb  8,  8, 31
	rgb  3,  0,  0

InitCutscene18:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(PurifyWaterCutscenePals_b8d80)
	ld hl, PurifyWaterCutscenePals_b8d80
	call LoadFarPalsToTempPals2
	call LoadCutscenes1Gfx_Vram0
	call LoadCutsceneBGMaps01
	jp LoadCutsceneBGMaps02

InitCutscene49:
	ld b, BANK(OpenGoldenSnakeDoorCutscenePals_b8180)
	ld hl, OpenGoldenSnakeDoorCutscenePals_b8180
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenGoldenSnakeDoorCutscenePals_b8e40)
	ld hl, OpenGoldenSnakeDoorCutscenePals_b8e40
	call LoadFarPalsToTempPals2
	jp InitCutscene15.asm_9c367

InitCutscene1f:
	ld b, BANK(LeavesFallCutscenePals_b8280)
	ld hl, LeavesFallCutscenePals_b8280
	call LoadFarPalsToTempPals1
	ld b, BANK(LeavesFallCutscenePals_b8f00)
	ld hl, LeavesFallCutscenePals_b8f00
	call LoadFarPalsToTempPals2
	call LoadCutscenes7And5Gfx_Vram0
	call LoadCutsceneBGMaps16
	call SetBGPriorityOnTopRows_Vram0
	call SetBGPriorityOn6x7Rect_Vram0
	jp InitCutscene1fObjs

InitCutscene21:
	ld b, BANK(MakeWireCutscenePals_b8300)
	ld hl, MakeWireCutscenePals_b8300
	call LoadFarPalsToTempPals1
	ld b, BANK(MakeWireCutscenePals_b8300)
	ld hl, MakeWireCutscenePals_b8300
	call LoadFarPalsToTempPals2
	call LoadCutscenes8And5Gfx_Vram1
	ld b, BANK(LevelMainTiles22)
	ld hl, LevelMainTiles22
	call LoadFarTiles
	jp LoadCutsceneBGMaps31

InitCutscene37:
	ld b, BANK(SharedCutsceneBGPals_b8240)
	ld hl, SharedCutsceneBGPals_b8240
	call LoadFarPalsToTempPals1
	ld b, BANK(TorchForestCutscenePals_b8f40)
	ld hl, TorchForestCutscenePals_b8f40
	call LoadFarPalsToTempPals2
	call LoadCutscenes4Gfx
	jp LoadCutsceneBGMaps12

InitCutscene38:
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(RevealWarpedVoidCutscenePals_b8f80)
	ld hl, RevealWarpedVoidCutscenePals_b8f80
	call LoadFarPalsToTempPals2
	call LoadCutscenes7And5Gfx_Vram0
	jp LoadCutsceneBGMaps03

InitCutscene30:
	ld b, BANK(LevelMainTiles7)
	ld hl, LevelMainTiles7
	call LoadFarTiles
	call LoadCutscenes8And5Gfx_Vram1
	call LoadCutsceneBGMaps26
	call ClearTempPals_Bank27
	jp InitCutscene30Objs

InitCutscene39:
	ld b, BANK(RaisePipeCutscenePals_b8380)
	ld hl, RaisePipeCutscenePals_b8380
	call LoadFarPalsToTempPals1
	ld b, BANK(RaisePipeCutscenePals_b8fc0)
	ld hl, RaisePipeCutscenePals_b8fc0
	call LoadFarPalsToTempPals2
	jp LoadCutsceneBGMaps15

InitCutscene3a:
	call ClearTempPals_Bank27
	call LoadCutscenes9Gfx_Vram1
	ld b, BANK(LevelMainTiles30)
	ld hl, LevelMainTiles30
	call LoadFarTiles
	call LoadCutsceneBGMaps37
	call LoadCutsceneBGMaps38
	jp InitCutscene3aObjs

InitCutscene3c:
	ld b, BANK(CollectDemonsBloodCutscenePals_b84c0)
	ld hl, CollectDemonsBloodCutscenePals_b84c0
	call LoadFarPalsToTempPals1
	ld b, BANK(CollectDemonsBloodCutscenePals_b84c0)
	ld hl, CollectDemonsBloodCutscenePals_b84c0
	call LoadFarPalsToTempPals2
	call LoadCutscenes8And5Gfx_Vram1
	ld b, BANK(LevelMainTiles31)
	ld hl, LevelMainTiles31
	call LoadFarTiles
	call LoadCutsceneBGMaps23
	jp SetBGPriorityOnTopRows_Vram1

InitCutscene43:
	ld b, BANK(PlacePropellerCutscenePals_b8440)
	ld hl, PlacePropellerCutscenePals_b8440
	call LoadFarPalsToTempPals1
	ld b, BANK(PlacePropellerCutscenePals_b8440)
	ld hl, PlacePropellerCutscenePals_b8440
	call LoadFarPalsToTempPals2
	ld b, BANK(LevelMainTiles36)
	ld hl, LevelMainTiles36
	call LoadFarTiles
	jp LoadCutsceneBGMaps20

InitCutscene54:
	call LoadCutscenes9Gfx_Vram1
	ld b, BANK(LevelMainTiles24)
	ld hl, LevelMainTiles24
	call LoadFarTiles
	call LoadCutsceneBGMaps36
	call ClearTempPals_Bank27
	jp InitCutscene54Objs

InitCutscene3d:
	ld b, BANK(OpenParaGoomCageCutscenePals_b8700)
	ld hl, OpenParaGoomCageCutscenePals_b8700
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenParaGoomCageCutscenePals_b9000)
	ld hl, OpenParaGoomCageCutscenePals_b9000
	call LoadFarPalsToTempPals2
	call LoadCutscenes9Gfx_Vram0

	decompress_tiles1 ParaGoomGfx, v1Tiles0, $40

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld b, BANK(LevelMainTiles30)
	ld hl, LevelMainTiles30
	call LoadFarTiles
	xor a
	ldh [rVBK], a
	call LoadCutsceneBGMaps34
	jp LoadCutsceneBGMaps35

InitCutscene4a:
	ld b, BANK(OpenSkyDoorCutscenePals_b83c0)
	ld hl, OpenSkyDoorCutscenePals_b83c0
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenSkyDoorCutscenePals_b9040)
	ld hl, OpenSkyDoorCutscenePals_b9040
	call LoadFarPalsToTempPals2
	call LoadCutscenes7And10Gfx_Vram0
	call LoadCutsceneBGMaps17
	jp InitCutscene4aObjs

InitCutscene4c:
	call ClearTempPals_Bank27
	call LoadCutscenes8Gfx_Vram0

	decompress_tiles1 FireGfx, v1Tiles1

	call LoadLevelMainTiles29_Vram1
	call LoadCutsceneBGMaps32
	jp InitCutscene4cObjs

InitCutscene4e:
	call ClearTempPals_Bank27
	call LoadCutscenes1Gfx_Vram1
	ld b, BANK(LevelMainTiles27)
	ld hl, LevelMainTiles27
	call LoadFarTiles
	jp LoadCutsceneBGMaps30

InitCutscene4f:
	ld b, BANK(SprayIronWallCutscenePals_b8480)
	ld hl, SprayIronWallCutscenePals_b8480
	call LoadFarPalsToTempPals1
	ld b, BANK(SprayIronWallCutscenePals_b8480)
	ld hl, SprayIronWallCutscenePals_b8480
	call LoadFarPalsToTempPals2
	ld b, BANK(LevelMainTiles23)
	ld hl, LevelMainTiles23
	call LoadFarTiles
	call LoadCutsceneBGMaps22
	jp InitCutscene4fObjs

InitCutscene51:
	ld b, BANK(MixChemicalsCutscenePals_b8400)
	ld hl, MixChemicalsCutscenePals_b8400
	call LoadFarPalsToTempPals1
	ld b, BANK(MixChemicalsCutscenePals_b8400)
	ld hl, MixChemicalsCutscenePals_b8400
	call LoadFarPalsToTempPals2
	call LoadCutscenes7And5Gfx_Vram0
	call LoadCutsceneBGMaps18
	call LoadCutsceneBGMaps19
	call SetBGPriorityOnTopRows_Vram0
	jp InitCutscene51Objs

InitCutscene56:
	call ClearTempPals_Bank27
	ld b, BANK(LevelMainTiles11)
	ld hl, LevelMainTiles11
	call LoadFarTiles
	call LoadCutscenes8And10Gfx_Vram1
	call LoadCutsceneBGMaps24
	call LoadCutsceneBGMaps25
	jp InitCutscene56Objs

InitCutscene57:
	call ClearTempPals_Bank27
	call LoadCutscenes7And10Gfx_Vram0
	call LoadCutsceneBGMaps29
	call SetBGPriorityOnTopRows_Vram0
	jp InitCutscene57Objs

InitCutscene58:
	call ClearTempPals_Bank27
	call LoadCutscenes9Gfx_Vram0

	decompress_tiles1 WallCrackGfx, v1Tiles1

	call LoadLevelMainTiles29_Vram1
	call LoadCutsceneBGMaps39
	call LoadCutsceneBGMaps040
	jp InitCutscene58Objs

InitCutscene55:
	call ClearTempPals_Bank27
	call LoadLevelMainTiles29_Vram0
	call LoadCutscenes7Gfx_Vram1
	call LoadCutsceneBGMaps27
	jp InitCutscene55Objs

InitCutscene44:
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	ld b, BANK(SharedCutsceneBGPals_b8200)
	ld hl, SharedCutsceneBGPals_b8200
	call LoadFarPalsToTempPals1
	ld b, BANK(FeedOctohonCutscenePals_b90c0)
	ld hl, FeedOctohonCutscenePals_b90c0
	call LoadFarPalsToTempPals2
	call LoadCutscenes7And5Gfx_Vram0

	decompress_tiles1 OctohonGfx, v1Tiles1, $40

	call LoadCutsceneBGMaps01
	call LoadCutsceneBGMaps04
	call SetBGPriorityOnTopRows_BGMap1
	call SetBGPriorityOnTopRows_Vram0
	call SetBGPriorityOn6x7Rect_Vram0
	ret

LoadCutscenes1Gfx_Vram0:
	decompress_tiles0 Cutscenes1Gfx, v0Tiles0
	jr LoadCutscenes5Gfx_Vram0

LoadCutscenes1Gfx_Vram1:
	decompress_tiles1 Cutscenes1Gfx, v1Tiles0
	jr LoadCutscenes5Gfx_Vram1

LoadCutscenes2Gfx:
	decompress_tiles0 Cutscenes2Gfx, v0Tiles0
	jp LoadCutscenes5Gfx_Vram0 ; can be jr

LoadCutscenes3Gfx:
	decompress_tiles0 Cutscenes3Gfx, v0Tiles0
	jp LoadCutscenes5Gfx_Vram0 ; can be jr

LoadCutscenes4Gfx:
	decompress_tiles0 Cutscenes4Gfx, v0Tiles0
	jp LoadCutscenes5Gfx_Vram0 ; unnecessary jump

LoadCutscenes5Gfx_Vram0:
	decompress_tiles0 Cutscenes5Gfx, v0Tiles2
	ret

LoadCutscenes5Gfx_Vram1:
	decompress_tiles1 Cutscenes5Gfx, v1Tiles2
	ret

LoadCutscenes7Gfx_Vram1:
	decompress_tiles1 Cutscenes7Gfx, v1Tiles0
	jp LoadCutscenes5Gfx_Vram1

LoadCutscenes7And5Gfx_Vram0:
	call LoadCutscenes7Gfx_Vram0
	jp LoadCutscenes5Gfx_Vram0

LoadCutscenes7And10Gfx_Vram0:
	call LoadCutscenes7Gfx_Vram0
	jp LoadCutscenes10Gfx_Vram0

LoadCutscenes7Gfx_Vram0:
	decompress_tiles0 Cutscenes7Gfx, v0Tiles0
	ret

LoadCutscenes8Gfx_Vram0:
	decompress_tiles0 Cutscenes8Gfx, v0Tiles0
	jp LoadCutscenes5Gfx_Vram0

LoadCutscenes8And5Gfx_Vram1:
	call LoadCutscenes8Gfx_Vram1
	jp LoadCutscenes5Gfx_Vram1

LoadCutscenes8And10Gfx_Vram1:
	call LoadCutscenes8Gfx_Vram1
	jp LoadCutscenes10Gfx_Vram1

LoadCutscenes8Gfx_Vram1:
	decompress_tiles1 Cutscenes8Gfx, v1Tiles0
	ret

LoadCutscenes9Gfx_Vram1:
	decompress_tiles1 Cutscenes9Gfx, v1Tiles0
	jp LoadCutscenes10Gfx_Vram1

LoadCutscenes9Gfx_Vram0:
	decompress_tiles0 Cutscenes9Gfx, v0Tiles0
	jp LoadCutscenes10Gfx_Vram0

LoadCutscenes10Gfx_Vram1:
	decompress_tiles1 Cutscenes10Gfx, v1Tiles2
	ret

LoadCutscenes10Gfx_Vram0:
	decompress_tiles0 Cutscenes10Gfx, v0Tiles2
	ret

LoadLevelMainTiles29_Vram1:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld b, BANK(LevelMainTiles29)
	ld hl, LevelMainTiles29
	call LoadFarTiles
	xor a
	ldh [rVBK], a
	ret

LoadLevelMainTiles29_Vram0:
	ld b, BANK(LevelMainTiles29)
	ld hl, LevelMainTiles29
	call LoadFarTiles
	ret

LoadCutsceneAttrmap0:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
;	fallthrough
LoadCutsceneTilemap0:
	ld bc, v0BGMap0
;	fallthrough

LoadCutsceneBGMap:
	ld a, BANK("Cutscene BG Maps")
	ld [wTempBank], a
	ld a, [wTempBank] ; unnecessary
	ldh [hCallFuncBank], a
	hcall Decompress
	xor a
	ldh [rVBK], a
	ret

LoadCutsceneAttrmap1:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
;	fallthrough
LoadCutsceneTilemap1:
	ld bc, v0BGMap1
	jr LoadCutsceneBGMap

LoadCutsceneBGMaps01:
	ld hl, Cutscene01Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene01Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps03:
	ld hl, Cutscene03Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene03Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps07:
	ld hl, Cutscene07Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene07Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps12:
	ld hl, Cutscene12Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene12Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps13:
	ld hl, Cutscene13Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene13Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps15:
	ld hl, Cutscene15Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene15Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps16:
	ld hl, Cutscene16Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene16Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps17:
	ld hl, Cutscene17Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene17Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps18:
	ld hl, Cutscene18Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene18Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps20:
	ld hl, Cutscene20Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene20Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps22:
	ld hl, Cutscene22Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene22Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps23:
	ld hl, Cutscene23Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene23Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps24:
	ld hl, Cutscene24Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene24Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps26:
	ld hl, Cutscene26Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene26Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps27:
	ld hl, Cutscene27Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene27Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps28:
	ld hl, Cutscene28Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene28Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps29:
	ld hl, Cutscene29Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene29Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps30:
	ld hl, Cutscene30Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene30Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps31:
	ld hl, Cutscene31Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene31Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps32:
	ld hl, Cutscene32Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene32Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps34:
	ld hl, Cutscene34Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene34Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps36:
	ld hl, Cutscene36Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene36Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps37:
	ld hl, Cutscene37Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene37Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps39:
	ld hl, Cutscene39Attrmap
	call LoadCutsceneAttrmap0
	ld hl, Cutscene39Tilemap
	call LoadCutsceneTilemap0
	ret

LoadCutsceneBGMaps02:
	ld hl, Cutscene02Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene02Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps04:
	ld hl, Cutscene04Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene04Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps05:
	ld hl, Cutscene05Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene05Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps14:
	ld hl, Cutscene14Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene14Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps19:
	ld hl, Cutscene19Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene19Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps21:
	ld hl, Cutscene21Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene21Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps25:
	ld hl, Cutscene25Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene25Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps35:
	ld hl, Cutscene35Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene35Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps38:
	ld hl, Cutscene38Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene38Tilemap
	call LoadCutsceneTilemap1
	ret

LoadCutsceneBGMaps040:
	ld hl, Cutscene40Attrmap
	call LoadCutsceneAttrmap1
	ld hl, Cutscene40Tilemap
	call LoadCutsceneTilemap1
	ret

SetBGPriorityOnTopRows_Vram1:
	ld d, BG_BANK1 | BG_PRIO
	jr SetBGPriorityOnTopRows
SetBGPriorityOnTopRows_Vram0:
	ld d, BG_BANK0 | BG_PRIO
;	fallthrough
SetBGPriorityOnTopRows:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	hlbgcoord 0, 0, v1BGMap0
	ld bc, 5 * TILEMAP_WIDTH
	ld a, d
	call WriteAToHL_BCTimes
	xor a
	ldh [rVBK], a
	ret

SetBGPriorityOnTopRows_BGMap1:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	hlbgcoord 0, 0, v1BGMap1
	ld bc, 5 * TILEMAP_WIDTH
	ld a, BG_BANK0 | BG_PRIO
	call WriteAToHL_BCTimes
	xor a
	ldh [rVBK], a
	ret

; fills 6x7 rectangle in attribute map at coordinate 0, 5
; sets those tiles to use vram0 tiles and with priority
SetBGPriorityOn6x7Rect_Vram0:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld d, BG_BANK0 | BG_PRIO
	hlbgcoord 0, 5
	ld e, 7 ; num rows
.loop_outer
	ld b, 6 ; num cols
	ld a, d
.loop_inner
	ld [hli], a
	dec b
	jr nz, .loop_inner
	dec e
	jr z, .done
	ld a, TILEMAP_WIDTH - 6
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	jr .loop_outer
.done
	xor a
	ldh [rVBK], a
	ret

ClearTempPals_Bank27:
	xor a
	ld hl, wTempPals1
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	xor a
	ld hl, wTempPals2
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	ret

ClearBGOBPals_Bank27:
	xor a
	ld hl, wTempBGPals
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	xor a
	ld hl, wTempOBPals
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	ret

VBlank_Cutscene:
	ld hl, .Func
	ld de, wVBlankFunc
	ld b, .end - .Func
	call CopyHLToDE
	ret

.Func:
	ld a, BANK("WRAM2")
	ldh [rWBK], a
	ld a, [wSCY]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a
	ld a, [wCutsceneWY]
	ldh [rWY], a
	ld a, [wCutsceneWX]
	ldh [rWX], a

	ld a, [wLCDCFlagsToFlip]
	and a
	jr z, .skip_lcd_flip
	ld hl, rLCDC
	xor [hl]
	ld [hl], a
	xor a
	ld [wLCDCFlagsToFlip], a

.skip_lcd_flip
	ld b, BANK(ApplyPalConfig1)
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	ld a, [wPalConfig1Register]
	and a
	call nz, ApplyPalConfig1
	ld a, [wPalConfig2]
	and a
	call nz, ApplyPalConfig2
	pop af
	bankswitch

	xor a
	ldh [rVBK], a
	ld a, HIGH(wVirtualOAM)
	jp hTransferVirtualOAM
.end

; a = state
; d = y coord
; e = x coord
SetSceneObjPosAndState:
	ld [hl], d
	inc l
	ld [hl], e
	inc l
	set 2, l
	call SetSceneObjState
	ret

AdvanceCutsceneFunc:
	ld hl, wOWStepCounter
	xor a
	ld [hld], a
	inc [hl]
	ret

WaitCutsceneFunc:
	ld a, [wOWStepCounter]
	cp c
	ret c
	jr AdvanceCutsceneFunc

StartCutsceneDelay:
	ld c, 30
	jp WaitCutsceneFunc

ExitCutscene:
	ld hl, wSubState
	inc [hl]
	stop_sfx
	ret

EndCutsceneDelay_20Frames:
	ld e, 20
;	fallthrough
EndCutscene:
	ld a, [wOWStepCounter]
	cp e
	ret c
	jr ExitCutscene

EndCutsceneDelay_40Frames:
	ld e, 40
	jr EndCutscene

EndCutsceneDelay_60Frames:
	ld e, 60
	jr EndCutscene

EndCutsceneDelay_80Frames:
	ld e, 80
	jr EndCutscene

EndCutsceneDelay_100Frames:
	ld e, 100
	jr EndCutscene

EndCutsceneDelay_120Frames:
	ld e, 120
	jr EndCutscene

SetPalConfig1ToTempPals1:
	ld a, HIGH(wTempPals1)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempPals1)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8
	ld [wPalConfig1Number], a
	ld a, LOW(rBGPI)
	ld [wPalConfig1Register], a
	ret

SetPalConfig2ToTempPals2:
	ld a, HIGH(wTempPals2)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempPals2)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8
	ld [wPalConfig2Number], a
	ld a, LOW(rOBPI)
	ld [wPalConfig2Register], a
	ret

CopyTempPalsToBGOBPals:
	push hl
	ld hl, wTempPals2
	ld de, wTempOBPals
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, wTempPals1
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE
	pop hl
	ret

CutsceneFadeToWhite:
	farcall _CutsceneFadeToWhite
	ret

CutsceneFadeOBToWhite:
	farcall _CutsceneFadeOBToWhite
	ret

CutsceneFadeBGToWhite:
	farcall _CutsceneFadeBGToWhite
	ret

CutsceneFadePals:
	farcall _CutsceneFadePals
	ret

CutsceneScreenShake:
	ld hl, wCutsceneShakeCounter
	inc [hl]
	ld a, [wCutsceneShakeStep]
	ld c, $fc
	and a
	jr z, .asm_9cdfb
	ld c, $04
	dec a
	jr z, .asm_9cdfb
	ld c, $fd
	dec a
	jr z, .asm_9cdfb
	ld c, $03
	dec a
	jr z, .asm_9cdfb
	ld c, $fe
	dec a
	jr z, .asm_9cdfb
	ld c, $02
	dec a
	jr z, .asm_9cdfb
	ld c, $ff
	dec a
	jr z, .asm_9cdfb
	ld c, $01
	jr .asm_9ce0c
.asm_9cdfb
	ld a, [hl]
	cp $06
	ret c
	ld hl, wSCY
	ld a, c
	add [hl]
	ld [hl], a
	ld hl, wCutsceneShakeCounter
	xor a
	ld [hld], a
	inc [hl]
	ret
.asm_9ce0c
	ld a, [hl]
	cp $06
	ret c
	ld hl, wSCY
	ld a, c
	add [hl]
	ld [hl], a
	ld hl, wCutsceneShakeCounter
	xor a
	ld [hld], a
	ld [hl], a
	jp AdvanceCutsceneFunc

PlayItemRaiseSFX:
	play_sfx SFX_ITEM_RAISE
	ret

DoCutsceneFunc:
	call ProcessDPadRepeat
	ld hl, wOWStepCounter
	inc [hl]
	ld b, h
	ld c, l

	ld a, [wEventWithCutscene]
	cp NUM_EVENTS
	jp nc, .OutOfBoundsCutscene
	jumptable

.table
	table_width 2
	dw .InvalidCutscene ; EVENT_00
	dw PrologueFunc ; EVENT_PROLOGUE
	dw Cutscene02Func ; EVENT_CUT_TREE
	dw Cutscene03Func ; EVENT_OPEN_NORTH_GATE
	dw Cutscene04Func ; EVENT_EXPEL_TORNADO
	dw .InvalidCutscene ; EVENT_LEAD_OVERALLS
	dw Cutscene06Func ; EVENT_RAINSTORM
	dw Cutscene07Func ; EVENT_FIX_ELEVATOR
	dw Cutscene08Func ; EVENT_YELLOW_MUSIC_BOX
	dw Cutscene09Func ; EVENT_PLANT_SEEDS
	dw Cutscene0aFunc ; EVENT_RAISE_TOWER
	dw .InvalidCutscene ; EVENT_SWIMMING_FLIPPERS
	dw Cutscene0cFunc ; EVENT_BLOW_MIST
	dw Cutscene0dFunc ; EVENT_SUMMON_SNAKES
	dw Cutscene0eFunc ; EVENT_FREEZE_SEA
	dw .InvalidCutscene ; EVENT_HEAD_SMASH_HELMET
	dw Cutscene10Func ; EVENT_BLUE_MUSIC_BOX
	dw Cutscene11Func ; EVENT_SUMMON_LIGHTNING
	dw .InvalidCutscene ; EVENT_GRAB_GLOVE
	dw Cutscene13Func ; EVENT_FOOT_STONE
	dw Cutscene14Func ; EVENT_VOLCANO_ERUPTION
	dw Cutscene15Func ; EVENT_OPEN_BLUE_SNAKE_DOOR
	dw .InvalidCutscene ; EVENT_GARLIC
	dw Cutscene17Func ; EVENT_GREEN_MUSIC_BOX
	dw Cutscene18Func ; EVENT_PURIFY_WATER
	dw Cutscene19Func ; EVENT_REVEAL_CASTLE
	dw .InvalidCutscene ; EVENT_SUPER_JUMP_SLAM_OVERALLS
	dw Cutscene1bFunc ; EVENT_SUMMON_SUN
	dw .InvalidCutscene ; EVENT_HIGH_JUMP_BOOTS
	dw Cutscene1dFunc ; EVENT_RED_MUSIC_BOX
	dw Cutscene1eFunc ; EVENT_EXPLODE_BOMBS
	dw Cutscene1fFunc ; EVENT_LEAVES_FALL
	dw .InvalidCutscene ; EVENT_PRINCE_FROGS_GLOVES
	dw Cutscene21Func ; EVENT_MAKE_WIRE
	dw Cutscene22Func ; EVENT_TREASURE_MAP
	dw .InvalidCutscene ; EVENT_SUPER_GRAB_GLOVES
	dw Cutscene24Func ; EVENT_OPEN_TREE_MOUTH
	dw Cutscene25Func ; EVENT_GOLD_MUSIC_BOX
	dw .InvalidCutscene ; EVENT_BLUE_CRAYON
	dw Cutscene27Func ; EVENT_PLACE_CART_WHEELS
	dw .InvalidCutscene ; EVENT_COLLECT_BLUE_GEM
	dw .InvalidCutscene ; EVENT_CYAN_CRAYON
	dw .InvalidCutscene ; EVENT_COLLECT_GOBLET
	dw .InvalidCutscene ; EVENT_COLLECT_CROWN
	dw .InvalidCutscene ; EVENT_PINK_CRAYON
	dw .InvalidCutscene ; EVENT_COLLECT_TEAPOT
	dw .InvalidCutscene ; EVENT_COLLECT_POCKET_PET
	dw .InvalidCutscene ; EVENT_MAGNIFYING_GLASS
	dw Cutscene30Func ; EVENT_RAISE_ICE_BLOCKS
	dw .InvalidCutscene ; EVENT_COLLECT_ROCKET
	dw .InvalidCutscene ; EVENT_YELLOW_CRAYON
	dw .InvalidCutscene ; EVENT_UNUSED_33
	dw .InvalidCutscene ; EVENT_COLLECT_SABER
	dw .InvalidCutscene ; EVENT_DAY_OR_NIGHT_SPELL
	dw .InvalidCutscene ; EVENT_COLLECT_UFO
	dw Cutscene37Func ; EVENT_TORCH_FOREST
	dw Cutscene38Func ; EVENT_REVEAL_WARPED_VOID
	dw Cutscene39Func ; EVENT_RAISE_PIPE
	dw Cutscene3aFunc ; EVENT_REMOVE_WARPS
	dw .InvalidCutscene ; EVENT_BROWN_CRAYON
	dw Cutscene3cFunc ; EVENT_COLLECT_DEMONS_BLOOD
	dw Cutscene3dFunc ; EVENT_OPEN_PARAGOOM_CAGE
	dw .InvalidCutscene ; EVENT_COLLECT_HEART_CREST
	dw .InvalidCutscene ; EVENT_COLLECT_MINICAR
	dw .InvalidCutscene ; EVENT_COLLECT_LOCOMOTIVE
	dw .InvalidCutscene ; EVENT_COLLECT_TELEPHONE
	dw .InvalidCutscene ; EVENT_RED_CRAYON
	dw Cutscene43Func ; EVENT_PLACE_PROPELLER
	dw Cutscene44Func ; EVENT_FEED_OCTOHON
	dw .InvalidCutscene ; EVENT_COLLECT_GREEN_GEM
	dw .InvalidCutscene ; EVENT_UNUSED_46
	dw .InvalidCutscene ; EVENT_UNUSED_47
	dw .InvalidCutscene ; EVENT_COLLECT_FIGHTER_MANNEQUIN
	dw Cutscene49Func ; EVENT_OPEN_GOLDEN_SNAKE_DOOR
	dw Cutscene4aFunc ; EVENT_OPEN_SKY_DOOR
	dw .InvalidCutscene ; EVENT_GREEN_CRAYON
	dw Cutscene4cFunc ; EVENT_EXTINGUISH_FIRE
	dw .InvalidCutscene ; EVENT_COLLECT_DIAMONDS_CREST
	dw Cutscene4eFunc ; EVENT_PLACE_BRICK
	dw Cutscene4fFunc ; EVENT_SPRAY_IRON_WALL
	dw .InvalidCutscene ; EVENT_COLLECT_SPADES_CREST
	dw Cutscene51Func ; EVENT_MIX_CHEMICALS
	dw .InvalidCutscene ; EVENT_COLLECT_RED_GEM
	dw .InvalidCutscene ; EVENT_COLLECT_CLUBS_CREST
	dw Cutscene54Func ; EVENT_CUT_BALOON
	dw Cutscene55Func ; EVENT_DRILL_HOLES
	dw Cutscene56Func ; EVENT_REVEAL_DARK_ROOM
	dw Cutscene57Func ; EVENT_SUMMON_MOON
	dw Cutscene58Func ; EVENT_OPEN_CRATER_HOLE
	dw .InvalidCutscene ; EVENT_COLLECT_EARTHEN_FIGURE
	dw .InvalidCutscene ; EVENT_EPILOGUE
	assert_table_length NUM_EVENTS

.OutOfBoundsCutscene:
	debug_nop

.InvalidCutscene:
	debug_nop

PrologueFunc:
	farcall Prologue
	ret

Cutscene03Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_OpenNorthGate

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObjs2And3
	dw .MoveObjsTogether
	dw .Wait30_1
	dw .JoinObjsClick
	dw .Wait30_2
	dw .PlaceObj3State05
	dw .WaitObj3Disappear
	dw .Wait60_1
	dw .LowerObj2
	dw .Wait60_2
	dw .SetObj2State04Click
	dw .Wait30_3
	dw .PlaceObj3OnObj2
	dw .WaitObj3State07
	dw .PlaySFX10C
	dw .Wait30_4
	dw CutsceneFadeToWhite
	dw EndCutsceneDelay_40Frames

.PlaceObjs2And3:
	ld hl, wSceneObj2
	ld a, 59 ; y
	ld [hli], a
	ld [hl], 40 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj3
	ld a, 59 ; y
	ld [hli], a
	ld [hl], 120 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObjsTogether:
	ld a, [bc]
	bit 0, a
	ret nz
	ld hl, wSceneObj3XCoord
	dec [hl]
	ld hl, wSceneObj2XCoord
	inc [hl]
	ld a, [hl]
	cp 79
	ret nz
	jp AdvanceCutsceneFunc

.Wait30_1:
	ld c, 30
	jp WaitCutsceneFunc

.JoinObjsClick:
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, 80
	ld [wSceneObj2XCoord], a
	xor a
	ld [wSceneObj3State], a
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait30_2:
	ld c, 30
	jp WaitCutsceneFunc

.PlaceObj3State05:
	ld hl, wSceneObj3YCoord
	ld a, 59 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $05
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_EMOTE
	jp AdvanceCutsceneFunc

.WaitObj3Disappear:
	ld a, [wSceneObj3State]
	and a
	ret nz
	jp AdvanceCutsceneFunc

.Wait60_1:
	ld c, 60
	jp WaitCutsceneFunc

.LowerObj2:
	ld a, [bc]
	bit 0, a
	ret z
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $54
	ret nz
	jp AdvanceCutsceneFunc

.Wait60_2:
	ld c, 60
	jp WaitCutsceneFunc

.SetObj2State04Click:
	ld a, $04
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj2XCoord
	inc [hl]
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait30_3:
	ld c, 30
	jp WaitCutsceneFunc

.PlaceObj3OnObj2:
	ld a, [wSceneObj2YCoord]
	ld [wSceneObj3YCoord], a
	ld a, [wSceneObj2XCoord]
	ld [wSceneObj3XCoord], a
	ld a, $06
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj3State07:
	ld a, [wSceneObj3State]
	cp $07
	ret nz
	jp AdvanceCutsceneFunc

.PlaySFX10C:
	play_sfx SFX_10C
	jp AdvanceCutsceneFunc

.Wait30_4:
	ld c, 30
	jp WaitCutsceneFunc

InitCutscene06Objs:
	ld hl, wSceneObj2
	ld a, 72 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp UpdateCutsceneObjs_Rainstorm

Cutscene06Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_Rainstorm

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .BobObj2
	dw .Wait30
	dw .LiftObj2
	dw .Wait30
	dw .PlaceObj2State02
	dw .WaitObj2State03
	dw .Wait100
	dw .RaiseObj2Slowly
	dw EndCutsceneDelay_40Frames

.BobObj2:
	ld a, [bc]
	cp $01
	jr z, .asm_9d068
	ld b, a
	and $03
	ret nz
	ld a, $ff
	bit 2, b
	jr nz, .asm_9d05c
	ld a, $01
.asm_9d05c
	ld hl, wSceneObj2YCoord
	add [hl]
	ld [hl], a
	ld a, b
	cp $20
	ret c
	jp AdvanceCutsceneFunc
.asm_9d068
	play_sfx SFX_TREE_FALL
	ret

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.LiftObj2:
	ld a, [bc]
	cp $01
	jr z, .asm_9d093
	ld b, $ff
	cp $08
	jr c, .asm_9d087
	dec b
	cp $10
	jr c, .asm_9d087
	dec b
.asm_9d087
	ld a, b
	ld hl, wSceneObj2YCoord
	add [hl]
	ld [hl], a
	cp $20
	ret nc
	jp AdvanceCutsceneFunc
.asm_9d093
	play_sfx SFX_TEMPLE_ROCK
	ret

.PlaceObj2State02:
	ld hl, wSceneObj2YCoord
	ld a, 64 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2State03:
	ld a, [wSceneObj2State]
	cp $03
	ret nz
	xor a
	ld [wCutsceneSFXCounter], a
	jp AdvanceCutsceneFunc

.Wait100:
	ld c, 100
	jp WaitCutsceneFunc

.RaiseObj2Slowly:
	call .play_sfx_bubble_float_every_14_frames
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $28
	ret nz
	jp AdvanceCutsceneFunc

.play_sfx_bubble_float_every_14_frames:
	ld hl, wCutsceneSFXCounter
	inc [hl]
	ld a, [hl]
	cp $0e
	ret c
	xor a
	ld [hl], a
	play_sfx SFX_BUBBLE_FLOAT
	ret

InitCutscene0aObjs:
	ld a, $03
	ld [wCutsceneOverlayType], a
	ld hl, wSceneObj2
	ld a, 130 ; y
	ld [hli], a
	ld [hl], 113 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj3
	ld a, 130 ; y
	ld [hli], a
	ld [hl], 47 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp UpdateCutsceneObjs_RaiseTower

Cutscene0aFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RaiseTower

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .RaiseObjsApart
	dw .Wait50
	dw .MoveObjsOnceSFX
	dw .Wait30
	dw CutsceneFadeToWhite
	dw EndCutsceneDelay_20Frames

.RaiseObjsApart:
	ld a, [bc]
	bit 0, a
	ret z
	call .move_objs_up_apart
	cp $63
	ret nz
	jp AdvanceCutsceneFunc

.move_objs_up_apart:
	ld hl, wSceneObj2YCoord
	ld a, [hl]
	dec a
	ld [hli], a
	dec [hl]
	ld hl, wSceneObj3YCoord
	ld [hli], a
	inc [hl]
	ret

.Wait50:
	ld c, 50
	jp WaitCutsceneFunc

.MoveObjsOnceSFX:
	call .move_objs_up_apart
	play_sfx SFX_EMOTE
	jp AdvanceCutsceneFunc
.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

InitCutscene07Objs:
	ld hl, wSceneObj2
	ld a, 88 ; y
	ld [hli], a
	ld [hl], 84 ; x
	ld a, $09
	ld hl, wSceneObj2State
	call SetSceneObjState

	ld hl, wSceneObj3
	ld a, 67 ; y
	ld [hli], a
	ld [hl], 64 ; x
	ld a, $03
	ld hl, wSceneObj3State
	call SetSceneObjState

	ld hl, wSceneObj4
	ld a, 88 ; y
	ld [hli], a
	ld [hl], 84 ; x
	ld a, $0a
	ld hl, wSceneObj4State
	call SetSceneObjState
	jp UpdateCutsceneObjs_FixElevator

Cutscene07Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_FixElevator

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObj5Click
	dw .Wait50_1
	dw .SetObj5State02Click
	dw .Wait30
	dw .SetObj3State04
	dw .Wait40_1
	dw .SetObj2State06
	dw .WaitObj2Frame00SFX
	dw .WaitObj2FrameNot00
	dw .WaitObj2Frame00SFX
	dw .WaitObj2FrameNot00
	dw .WaitObj2Frame00SFX
	dw .WaitObj2FrameNot00
	dw .WaitObj2Frame00SFX
	dw .Wait50_2
	dw .SetObj3State05
	dw .Wait40_2
	dw .SetObj4State08SFX
	dw .WaitObj4Disappear
	dw .Wait50_3
	dw .PlaySFX10B
	dw .RaiseObj2
	dw EndCutsceneDelay_60Frames

.PlaceObj5Click:
	ld a, [bc]
	cp $14
	ret c
	ld hl, wSceneObj5
	ld a, 90 ; y
	ld [hli], a
	ld [hl], 56 ; x
	ld a, $01
	ld hl, wSceneObj5State
	call SetSceneObjState
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait50_1:
	ld c, 50
	jp WaitCutsceneFunc

.SetObj5State02Click:
	ld a, $02
	ld hl, wSceneObj5State
	call SetSceneObjState
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.SetObj3State04:
	ld a, $04
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait40_1:
	ld c, 40
	jp WaitCutsceneFunc

.SetObj2State06:
	ld a, $06
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2Frame00SFX:
	ld a, [wSceneObj2Frame]
	and a
	ret nz
	play_sfx SFX_109
	jp AdvanceCutsceneFunc

.WaitObj2FrameNot00:
	ld a, [wSceneObj2Frame]
	and a
	ret z
	jp AdvanceCutsceneFunc

.Wait50_2:
	ld c, 50
	jp WaitCutsceneFunc

.SetObj3State05:
	ld a, $05
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait40_2:
	ld c, 40
	jp WaitCutsceneFunc

.SetObj4State08SFX:
	ld a, $08
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_CHEST_OPEN
	jp AdvanceCutsceneFunc

.WaitObj4Disappear:
	ld a, [wSceneObj4State]
	and a
	ret nz
	jp AdvanceCutsceneFunc

.Wait50_3:
	ld c, 50
	jp WaitCutsceneFunc

.PlaySFX10B:
	play_sfx SFX_10B
	jp AdvanceCutsceneFunc

.RaiseObj2:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $18
	ret nc
	jp AdvanceCutsceneFunc

Cutscene19Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RevealCastle

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .Wait90
	dw .SetObj2State02SFX
	dw .Wait30
	dw .WaitObj2Frame04SetState03
	dw .Wait60
	dw .LoadPal2_1
	dw .Wait8
	dw .LoadPal2_2
	dw .Wait8
	dw .LoadPal2_3
	dw .Wait8
	dw .LoadPal2_4
	dw EndCutsceneDelay_60Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, SCREEN_HEIGHT_PX
	ld [hli], a
	ld [hl], $50
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $86
	jp z, PlayItemRaiseSFX
	cp $60
	ret nz
	jp AdvanceCutsceneFunc

.Wait90:
	ld c, 90
	jp WaitCutsceneFunc

.SetObj2State02SFX:
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_FLAME
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.WaitObj2Frame04SetState03:
	ld a, [wSceneObj2Frame]
	cp $04
	ret nz
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.LoadPal2_1:
	ld hl, RevealCastleCutscenePal2_1
.load_pal2
	ld de, wTempPals1 palette 2
	ld b, 1 palettes
	call CopyHLToDE
	ld a, HIGH(wTempPals1 palette 2)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempPals1 palette 2)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 2
	ld [wPalConfig1Index], a
	ld a, 1
	ld [wPalConfig1Number], a
	ld a, LOW(rBGPI)
	ld [wPalConfig1Register], a
	jp AdvanceCutsceneFunc

.Wait8:
	ld c, 8
	jp WaitCutsceneFunc

.LoadPal2_2:
	ld hl, RevealCastleCutscenePal2_2
	jr .load_pal2

.LoadPal2_3:
	ld hl, RevealCastleCutscenePal2_3
	jr .load_pal2

.LoadPal2_4:
	ld hl, RevealCastleCutscenePal2_4
	jr .load_pal2

Cutscene0eFunc:
Cutscene11Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_FreezeSea

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .CheckSummonLightning
	dw .ShowItem
	dw .RaiseItem
	dw .Wait60
	dw .LoadResultPals
	dw .Wait30_1
	dw .PlaceObj2State02
	dw .RaiseObj2Fast
	dw EndCutsceneDelay_60Frames

	dw .ShowItem
	dw .RaiseItem
	dw .Wait60
	dw .LoadLightningResultPals
	dw .Wait30_1
	dw .Wait30_2
	dw .PlaceObj2State03
	dw .MoveObj2UpRight
	dw EndCutsceneDelay_60Frames

.CheckSummonLightning:
	ld a, [wEventWithCutscene]
	cp EVENT_SUMMON_LIGHTNING
	jp nz, AdvanceCutsceneFunc
	ld a, $09
	ld [wOWStep], a
	jp AdvanceCutsceneFunc

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 172 ; y
	ld [hli], a
	ld [hl], 88 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $01
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $92
	jp z, PlayItemRaiseSFX
	cp $6c
	ret nz
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.LoadResultPals:
	ld hl, SharedCutsceneBGPals_b8040
.load_result_pals
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(SharedCutsceneBGPals_b8040) ; aka BANK(SharedCutsceneBGPals_b8200)
	call CopyFarBytes
	xor a
	ld [wCutsceneOverlayType], a
	ld [wSceneObj2State], a
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a

	ld a, HIGH(wTempPals1)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempPals1)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8
	ld [wPalConfig1Number], a
	ld a, LOW(rBGPI)
	ld [wPalConfig1Register], a
	jp AdvanceCutsceneFunc

.Wait30_1:
	ld c, 30
	jp WaitCutsceneFunc

.PlaceObj2State02:
	ld hl, wSceneObj2YCoord
	ld a, 176 ; y
	ld [hli], a
	ld [hl], 50 ; x
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $03
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseObj2Fast:
	ld hl, wSceneObj2YCoord
	dec [hl]
	dec [hl]
	ld a, [hl]
	cp $74
	jr z, .play_sfx_113
	cp $68
	ret nz
	jp AdvanceCutsceneFunc

.LoadLightningResultPals:
	ld hl, SharedCutsceneBGPals_b8200
	jr .load_result_pals

.Wait30_2:
	ld c, 30
	jp WaitCutsceneFunc

.PlaceObj2State03:
	ld hl, wSceneObj2YCoord
	ld a, 164 ; y
	ld [hli], a
	ld [hl], 240 ; x
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObj2UpRight:
	ld hl, wSceneObj2YCoord
	dec [hl]
	dec [hl]
	ld a, [hli]
	inc [hl]
	inc [hl]
	cp $70
	jr z, .play_sfx_113
	cp $64
	ret nz
	jp AdvanceCutsceneFunc

.play_sfx_113
	play_sfx SFX_113
	ret

Cutscene1bFunc:
	call .PlayCutscene
	call UpdateCutsceneObjs_SummonSun
	jp UpdateCutsceneLevelObj_SummonSun

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObjs2And3
	dw .MoveObjsTogetherClick
	dw .Wait90
	dw CutsceneFadeOBToWhite
	dw .Wait8
	dw CutsceneFadeBGToWhite
	dw .Wait60
	dw .HideObjsLoadSunPals
	dw .PlaceObj5
	dw .Wait20
	dw .LowerObj5
	dw .WaitThenSetObj5State01
	dw .Wait100
	dw EndCutsceneDelay_120Frames

.PlaceObjs2And3:
	ld hl, wSceneObj2YCoord
	ld a, 50 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj3YCoord
	ld a, 130 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObjsTogetherClick:
	ld a, [bc]
	bit 0, a
	ret z
	call .move_objs_together
	cp $5a
	ret nz
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.move_objs_together:
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	ld hl, wSceneObj3YCoord
	dec [hl]
	ret

.Wait90:
	ld c, 90
	jp WaitCutsceneFunc

.Wait8:
	ld c, 8
	jp WaitCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.HideObjsLoadSunPals:
	xor a
	ld [wSceneObj2State], a
	ld [wSceneObj3State], a

	ld b, BANK(SummonSunCutscenePals_b8340)
	ld c, 8 palettes
	ld hl, SummonSunCutscenePals_b8340
	ld de, wTempPals1
	call CopyFarBytes
	call SetPalConfig1ToTempPals1

	ld b, BANK(SummonSunCutscenePals_b8340)
	ld c, 8 palettes
	ld hl, SummonSunCutscenePals_b8340
	ld de, wTempPals2
	call CopyFarBytes
	call SetPalConfig2ToTempPals2

	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	jp AdvanceCutsceneFunc

.PlaceObj5:
	ld hl, wSceneObj5
	ld a, 32 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $02
	ld hl, wSceneObj5State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait20:
	ld c, 20
	jp WaitCutsceneFunc

.LowerObj5:
	ld b, $03
	ld hl, wSceneObj5
	ld a, [hl]
	cp $44
	jr c, .asm_9d510
	ld b, $07
.asm_9d510
	ld a, [wOWStepCounter]
	and b
	ret nz
	inc [hl]
	ld a, [hl]
	cp $4e
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj5State01:
	ld a, [bc]
	cp $1e
	ret c
	ld a, $01
	ld hl, wSceneObj5State
	call SetSceneObjState
	ld hl, wSceneObj5
	add [hl]
	ld [hl], a
	jp AdvanceCutsceneFunc

.Wait100:
	ld c, 100
	jp WaitCutsceneFunc

InitCutscene1eObjs:
	ld hl, wSceneObj2
	ld a, 83 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $04
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj3YCoord
	ld a, 54 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	ld hl, wSceneObj4YCoord
	ld a, 83 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $03
	ld hl, wSceneObj4State
	call SetSceneObjState
	jp UpdateCutsceneObjs_ExplodeBombs

Cutscene1eFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_ExplodeBombs

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .Wait15
	dw .LowerObj3Switch
	dw .Wait60
	dw .SetObj2State01SFX
	dw .Wait70
	dw .WaitObj2Frame03
	dw .SetObj2State05
	dw .Wait30
	dw CutsceneFadeToWhite
	dw ExitCutscene

.Wait15:
	ld c, 15
	jp WaitCutsceneFunc

.LowerObj3Switch:
	ld hl, wSceneObj3YCoord
	inc [hl]
	ld a, [hl]
	cp $3b
	ret nz
	play_sfx SFX_SWITCH
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.SetObj2State01SFX:
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_10E
	jp AdvanceCutsceneFunc

.Wait70:
	ld c, 70
	jp WaitCutsceneFunc

.WaitObj2Frame03:
	ld a, [wSceneObj2Frame]
	cp $03
	ret nz
	jp AdvanceCutsceneFunc

.SetObj2State05:
	ld a, $05
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

Cutscene22Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_TreasureMap

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .Wait45
	dw .PlaceObj2SFX
	dw .WaitObj2Frame05SFX
	dw .WaitObj2State02
	dw EndCutsceneDelay_20Frames

.LoadPals:
	ld hl, TreasureMapCutscenePals_b8100
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(TreasureMapCutscenePals_b8100)
	call CopyFarBytes

	ld hl, TreasureMapCutscenePals_b8d00
	ld de, wTempPals2
	ld c, 8 palettes
	ld b, BANK(TreasureMapCutscenePals_b8d00)
	call CopyFarBytes
	call ClearBGOBPals_Bank27
	jp AdvanceCutsceneFunc

.Wait45:
	ld c, 45
	jp WaitCutsceneFunc

.PlaceObj2SFX:
	ld hl, wSceneObj2YCoord
	ld a, 76 ; y
	ld [hli], a
	ld [hl], 83 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_PATH_ARROW
	jp AdvanceCutsceneFunc

.WaitObj2Frame05SFX:
	ld a, [wSceneObj2Frame]
	cp $05
	ret nz
	play_sfx SFX_HAMMER_BOT_WALK
	jp AdvanceCutsceneFunc

.WaitObj2State02:
	ld a, [wSceneObj2State]
	cp $02
	ret nz
	jp AdvanceCutsceneFunc

InitCutscene27Objs:
	ld hl, wSceneObj2
	ld a, 86 ; y
	ld [hli], a
	ld [hl], 88 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp UpdateCutsceneObjs_PlaceCartWheels

Cutscene27Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_PlaceCartWheels

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .SetObj2State02Click
	dw .Wait50
	dw .SetObj2State03Click
	dw .Wait180
	dw ExitCutscene

.SetObj2State02Click:
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait50:
	ld c, 50
	jp WaitCutsceneFunc

.SetObj2State03Click:
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait180:
	ld c, 180
	jp WaitCutsceneFunc

Cutscene09Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_PlantSeeds

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw EndCutsceneDelay_60Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 176 ; y
	ld [hli], a
	ld [hl], 74 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $01
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $88
	jp z, PlayItemRaiseSFX
	cp $62
	ret nz
	jp AdvanceCutsceneFunc

Cutscene08Func:
	ld b, $01
	jr MusicBoxCutsceneFunc

Cutscene10Func:
	ld b, $03
	jr MusicBoxCutsceneFunc

Cutscene17Func:
	ld b, $05
	jr MusicBoxCutsceneFunc

Cutscene1dFunc:
	ld b, $07
	jr MusicBoxCutsceneFunc

Cutscene25Func:
	ld b, $09
;	fallthrough

MusicBoxCutsceneFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_MusicBox

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowMusicBox
	dw .RaiseMusicBox
	dw .Wait30
	dw .OpenMusicBox
	dw .Wait50
	dw .PlayMusicBoxTune
	dw .Wait254
	dw EndCutsceneDelay_80Frames

.ShowMusicBox:
	ld hl, wSceneObj2YCoord
	ld a, 176 ; y
	ld [hli], a
	ld [hl], 74 ; x
	ld a, b
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $01
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseMusicBox:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $88
	jp z, PlayItemRaiseSFX
	cp $62
	ret nz
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.OpenMusicBox:
	ld hl, wSceneObj2State
	ld a, [hl]
	ld b, a
	inc a
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait50:
	ld c, 50
	jp WaitCutsceneFunc

.PlayMusicBoxTune:
	call AdvanceCutsceneFunc
	ld a, [wSceneObj2State]
	dec a
	cp $01
	jr z, .asm_9d765
	cp $03
	jr z, .asm_9d76e
	cp $05
	jr z, .asm_9d777
	cp $07
	jr z, .asm_9d780
	cp $09
	jr z, .asm_9d789
	ret
.asm_9d765
	play_sfx SFX_YELLOW_MUSIC_BOX
	ret
.asm_9d76e
	play_sfx SFX_BLUE_MUSIC_BOX
	ret
.asm_9d777
	play_sfx SFX_GREEN_MUSIC_BOX
	ret
.asm_9d780
	play_sfx SFX_RED_MUSIC_BOX
	ret
.asm_9d789
	play_sfx SFX_GOLD_MUSIC_BOX
	ret

.Wait254:
	ld c, 254
	jp WaitCutsceneFunc

Cutscene02Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_CutTree

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowAxe
	dw .RaiseAxe
	dw .Wait30
	dw .ShowSpeedLines
	dw .Wait60
	dw .HideAxe
	dw .Wait16
	dw .ShowCut
	dw .WaitCutAnimation
	dw EndCutsceneDelay_40Frames

.ShowAxe:
	ld hl, wSceneObj2
	ld a, SCREEN_HEIGHT_PX
	ld [hli], a
	ld [hl], $6c
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $03
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseAxe:
	ld hl, wSceneObj2
	dec [hl]
	ld a, [hl]
	inc l
	dec [hl]
	cp $86
	jp z, PlayItemRaiseSFX
	cp $60
	ret nz
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.ShowSpeedLines:
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.HideAxe:
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	xor a
	ld hl, wSceneObj2State
	call SetSceneObjState
	xor a
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.Wait16:
	ld c, 16
	jp WaitCutsceneFunc

.ShowCut:
	ld hl, wSceneObj2
	ld a, 96 ; y
	ld [hli], a
	ld [hl], 66 ; x
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_101
	jp AdvanceCutsceneFunc

.WaitCutAnimation:
	ld a, [wSceneObj2State]
	and a
	ret nz
	jp AdvanceCutsceneFunc

Cutscene0cFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_BlowMist

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw EndCutsceneDelay_60Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 164 ; y
	ld [hli], a
	ld [hl], 120 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $03
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hli]
	dec [hl]
	cp $8a
	jp z, PlayItemRaiseSFX
	cp $64
	ret nz
	jp AdvanceCutsceneFunc

Cutscene18Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_FreezeSea

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .Wait20
	dw .FlipBGMap
	dw EndCutsceneDelay_60Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 164 ; y
	ld [hli], a
	ld [hl], 112 ; x
	ld a, $04
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $03
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hli]
	dec [hl]
	cp $8a
	jp z, PlayItemRaiseSFX
	cp $64
	ret nz
	jp AdvanceCutsceneFunc

.Wait20:
	ld c, 20
	jp WaitCutsceneFunc

.FlipBGMap:
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	jp AdvanceCutsceneFunc

Cutscene0dFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_SummonSnakes

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .Wait20
	dw .FlipBGMap
	dw .Wait60
	dw .PlaceObj3SFX
	dw .MoveObj3LeftThenShowObj4
	dw .MoveObj4LeftThenShowObj3
	dw .MoveObj3LeftThenShowObj4
	dw .MoveObj4LeftThenHide
	dw .Wait80
	dw EndCutsceneDelay_20Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 156 ; y
	ld [hli], a
	ld [hl], 72 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $7a
	jp z, PlayItemRaiseSFX
	cp $54
	ret nz
	jp AdvanceCutsceneFunc

.Wait20:
	ld c, 20
	jp WaitCutsceneFunc

.FlipBGMap:
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.PlaceObj3SFX:
	ld hl, wSceneObj3YCoord
	ld a, 88 ; y
	ld [hli], a
	ld [hl], 64 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_117
	jp AdvanceCutsceneFunc

.MoveObj3LeftThenShowObj4:
	ld a, [bc]
	bit 0, a
	ret z
	ld hl, wSceneObj3XCoord
	dec [hl]
	ld a, [hl]
	cp $1c
	ret nz
	xor a
	ld [wSceneObj3State], a
	ld hl, wSceneObj4YCoord
	ld a, 80 ; y
	ld [hli], a
	ld [hl], 60 ; x
	ld a, $03
	ld hl, wSceneObj4State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObj4LeftThenShowObj3:
	call .move_obj4_left
	ret nz
	xor a
	ld [wSceneObj4State], a
	ld hl, wSceneObj3YCoord
	ld a, 88 ; y
	ld [hli], a
	ld [hl], 64 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.move_obj4_left:
	ld a, [bc]
	bit 0, a
	ret nz
	ld hl, wSceneObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $18
	ret

.MoveObj4LeftThenHide:
	call .move_obj4_left
	cp $18
	ret nz
	xor a
	ld [wSceneObj4State], a
	jp AdvanceCutsceneFunc

.Wait80:
	ld c, 80
	jp WaitCutsceneFunc

Cutscene13Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_FootStone

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .RaiseObj2Further
	dw .LowerObj3OffScreen
	dw .Wait30
	dw .DropObj2
	dw CutsceneScreenShake
	dw EndCutsceneDelay_40Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 176 ; y
	ld [hli], a
	ld [hl], 72 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, [wSceneObj2YCoord]
	ld [wSceneObj3YCoord], a
	ld a, [wSceneObj2XCoord]
	ld [wSceneObj3XCoord], a
	ld a, $01
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	ld [wSceneObj3YCoord], a
	cp $86
	jp z, PlayItemRaiseSFX
	cp $60
	ret nz
	jp AdvanceCutsceneFunc

.RaiseObj2Further:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $40
	ret nc
	ld [hl], $40
	jp AdvanceCutsceneFunc

.LowerObj3OffScreen:
	ld a, [bc]
	bit 0, a
	ret z
	ld hl, wSceneObj3YCoord
	inc [hl]
	ld a, [hl]
	cp SCREEN_HEIGHT_PX
	ret nz
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.DropObj2:
	ld hl, wSceneObj2YCoord
	inc [hl]
	inc [hl]
	inc [hl]
	ld a, [hl]
	cp $b0
	ret c
	play_sfx SFX_EARTHQUAKE
	jp AdvanceCutsceneFunc

InitCutscene15Objs:
	ld a, $05
	ld hl, wSceneObj4State
	call SetSceneObjState
	ld hl, wSceneObj4
	ld a, 96 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $06
	ld hl, wSceneObj5State
	call SetSceneObjState
	ld hl, wSceneObj5
	ld a, 96 ; y
	ld [hli], a
	ld [hl], 80 ; x
	jp UpdateCutsceneObjs_OpenSnakeDoor

Cutscene15Func:
Cutscene49Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_OpenSnakeDoor

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .Wait20
	dw .PlaceObj2AtTop
	dw .LowerObj2Click
	dw .WaitThenSetObj2State04
	dw .WaitObj2State01ThenOpen
	dw .Wait40
	dw .SlideDoorsOpen
	dw EndCutsceneDelay_40Frames

.Wait20:
	ld c, 20
	jp WaitCutsceneFunc

.PlaceObj2AtTop:
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj2YCoord
	ld a, 0 ; y
	ld [hli], a
	ld [hl], 80 ; x
	jp AdvanceCutsceneFunc

.LowerObj2Click:
	ld a, [bc]
	bit 0, a
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $45
	ret nz
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State04:
	ld a, [bc]
	cp $14
	ret c
	ld a, $04
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2State01ThenOpen:
	ld a, [wSceneObj2State]
	cp $01
	jr z, .asm_9daa6
	ld a, [wSceneObj2Frame]
	cp $03
	ret nz
	ld a, [wSceneObj2Duration]
	and a
	ret nz
	play_sfx SFX_12C
	ret
.asm_9daa6
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $03
	ld hl, wSceneObj3State
	call SetSceneObjState
	ld hl, wSceneObj2YCoord
	ld a, [hli]
	ld [wSceneObj3YCoord], a
	ld a, [hl]
	ld [wSceneObj3XCoord], a
	jp AdvanceCutsceneFunc

.Wait40:
	ld c, 40
	jp WaitCutsceneFunc

.SlideDoorsOpen:
	call .play_sfx_rumble_every_17_frames
	ld a, [bc]
	and $07
	ret nz
	ld hl, wCutsceneWX
	inc [hl]
	ld hl, wSceneObj5XCoord
	inc [hl]
	ld hl, wSceneObj3XCoord
	inc [hl]
	ld hl, wSCX
	inc [hl]
	ld hl, wSceneObj4XCoord
	dec [hl]
	ld a, [hl]
	ld hl, wSceneObj2XCoord
	dec [hl]
	ld a, [hl]
	cp $40
	ret nz
	jp AdvanceCutsceneFunc

.play_sfx_rumble_every_17_frames:
	ld hl, wSceneObj4MovementStep
	inc [hl]
	ld a, [hl]
	cp $11
	ret c
	xor a
	ld [hl], a
	play_sfx SFX_RUMBLE
	ret

Cutscene04Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_ExpelTornado

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .WaitThenPlaceObj3
	dw .RaiseObj3SFX
	dw .SetObj2State01FlipBGMap
	dw EndCutsceneDelay_60Frames

.ShowItem:
	ld a, [bc]
	cp $14
	ret c
	ld hl, wSceneObj2YCoord
	ld a, 128 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2
	call .move_up
	cp $70
	jp z, PlayItemRaiseSFX
	cp $4a
	ret nz
	jp AdvanceCutsceneFunc

.move_up:
	dec [hl]
	ld a, [hl]
	ret

.WaitThenPlaceObj3:
	ld a, [bc]
	cp $32
	ret c
	ld hl, wSceneObj3YCoord
	ld a, 128 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $03
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.RaiseObj3SFX:
	ld hl, wSceneObj3
	call .move_up
	cp $4a
	ret nz
	play_sfx SFX_113
	jp AdvanceCutsceneFunc

.SetObj2State01FlipBGMap:
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	xor a
	ld [wSceneObj3State], a
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	jp AdvanceCutsceneFunc

InitCutscene24Objs:
	ld hl, wSceneObj2
	ld a, 104 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp UpdateCutsceneObjs_OpenTreeMouth

Cutscene24Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_OpenTreeMouth

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .WaitThenPlaceObj3
	dw .MoveObj3RightOffScreen
	dw .WaitThenSetObj2State03
	dw .Wait40
	dw .DropObj2
	dw .HideObj2
	dw EndCutsceneDelay_40Frames

.WaitThenPlaceObj3:
	ld a, [bc]
	cp $28
	ret c
	ld hl, wSceneObj3YCoord
	ld a, 70 ; y
	ld [hli], a
	ld [hl], 16 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObj3RightOffScreen:
	ld hl, wSceneObj3XCoord
	inc [hl]
	ld a, [hl]
	cp $30
	jr z, .asm_9dbdc
	cp SCREEN_WIDTH_PX
	ret nz
	xor a
	ld [wSceneObj3State], a
	jp AdvanceCutsceneFunc
.asm_9dbdc
	play_sfx SFX_WARPED_VOID_APPEAR
	ret

.WaitThenSetObj2State03:
	ld a, [bc]
	cp $46
	ret c
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait40:
	ld c, 40
	jp WaitCutsceneFunc

.DropObj2:
	ld hl, wOWStepCounter
	call .get_fall_speed
	ld hl, wSceneObj2YCoord
	add [hl]
	ld [hl], a
	cp $88
	ret c
	jp AdvanceCutsceneFunc

.get_fall_speed:
	ld a, [hl]
	cp $44
	jr c, .asm_9dc16
	ld a, $40
	ld [hl], a
.asm_9dc16
	ld e, a
	ld d, $00
	ld hl, .data_9dc1f
	add hl, de
	ld a, [hl]
	ret

.data_9dc1f
	db $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $01, $01, $01

.HideObj2:
	xor a
	ld [wSceneObj2State], a
	jp AdvanceCutsceneFunc

InitCutscene1fObjs:
	ld hl, wSceneObj3
	ld a, 96 ; y
	ld [hli], a
	ld [hl], 112 ; x
	ld a, $04
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp UpdateCutsceneObjs_LeavesFall

Cutscene1fFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_LeavesFall

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObj2
	dw .MoveObj2DownRight
	dw .WaitThenHideObj2
	dw .WaitThenSetObj3State02
	dw .WaitObj3Frame0aSFX
	dw .WaitObj3State03
	dw .Wait40
	dw EndCutsceneDelay_120Frames

.PlaceObj2:
	ld hl, wSceneObj2YCoord
	ld a, 36 ; y
	ld [hli], a
	ld [hl], 42 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObj2DownRight:
	ld a, [bc]
	bit 0, a
	ret z
	ld hl, wSceneObj2YCoord
	inc [hl]
	inc l
	inc [hl]
	ld a, [hl]
	cp $2e
	jr z, .asm_9dcc1
	cp $4a
	ret nz
	jp AdvanceCutsceneFunc
.asm_9dcc1
	play_sfx SFX_TORNADO
	ret

.WaitThenHideObj2:
	ld a, [bc]
	cp $46
	ret c
	xor a
	ld [wSceneObj2State], a
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State02:
	ld a, [bc]
	cp $1e
	ret c
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj3Frame0aSFX:
	ld a, [wSceneObj3Frame]
	cp $0a
	ret nz
	play_sfx SFX_FAT_WALK
	jp AdvanceCutsceneFunc

.WaitObj3State03:
	ld a, [wSceneObj3State]
	cp $03
	ret nz
	jp AdvanceCutsceneFunc

.Wait40:
	ld c, 40
	jp WaitCutsceneFunc

Cutscene21Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_MakeWire

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObjs
	dw .MoveObj2UpToObj3
	dw .Wait60
	dw .SetObj3State03
	dw .MoveObj2RightToObj4
	dw .Wait60
	dw .SetObj4State03
	dw .MoveObj2RightToObj5
	dw .Wait60
	dw .SetObj5State03
	dw .MoveObj2RightPastObj5
	dw .MoveObj2LeftToObj5
	dw .Wait60
	dw .SetObj5State04
	dw .MoveObj2LeftToObj4
	dw .Wait60
	dw .SetObj4State04
	dw .MoveObj2LeftToObj3
	dw .Wait60
	dw .SetObj3State04
	dw .SetObj2State01
	dw .MoveObj2UpOffScreen
	dw .HideObj2
	dw EndCutsceneDelay_40Frames

.move_obj2_up_slowly:
	ld hl, wSceneObj2YCoord
	ld a, [bc]
	and $03
	jr nz, .asm_9dd48
	dec [hl]

.asm_9dd48
	ld a, [hl]
	ret

.move_obj2_right_slowly:
	ld hl, wSceneObj2XCoord
	ld a, [bc]
	bit 0, a
	jr z, .asm_9dd48
	inc [hl]
	jr .asm_9dd48

.move_obj2_left_slowly:
	ld hl, wSceneObj2XCoord
	ld a, [bc]
	bit 0, a
	jr z, .asm_9dd48
	dec [hl]
	jr .asm_9dd48

.PlaceObjs:
	ld hl, wSceneObj3YCoord
	ld a, 72 ; y
	ld [hli], a
	ld [hl], 72 ; x
	ld hl, wSceneObj4YCoord
	ld a, 72 ; y
	ld [hli], a
	ld [hl], 88 ; x
	ld hl, wSceneObj5YCoord
	ld a, 72 ; y
	ld [hli], a
	ld [hl], 104 ; x
	ld hl, wSceneObj2YCoord
	ld a, 128 ; y
	ld [hli], a
	ld [hl], 72 ; x

.SetObj2State01:
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObj2UpToObj3:
	call .move_obj2_up_slowly
	cp $48
	ret nz
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.SetObj3State03:
	ld a, $03
.asm_9dda3
	ld [wSceneObj3State], a
	jp AdvanceCutsceneFunc

.MoveObj2RightToObj4:
	call .move_obj2_right_slowly
	ld b, $58
.asm_9ddae
	cp b
	ret nz
	jp AdvanceCutsceneFunc

.SetObj4State03:
	ld a, $03
.asm_9ddb5
	ld [wSceneObj4State], a
	jp AdvanceCutsceneFunc

.MoveObj2RightToObj5:
	call .move_obj2_right_slowly
	ld b, $68
	jr .asm_9ddae

.SetObj5State03:
	ld a, $03
.asm_9ddc4
	ld [wSceneObj5State], a
	jp AdvanceCutsceneFunc

.MoveObj2RightPastObj5:
	call .move_obj2_right_slowly
	cp $88
	ret nz
	ld a, $38
	ld [wSceneObj2YCoord], a
	jp AdvanceCutsceneFunc

.MoveObj2LeftToObj5:
	call .move_obj2_left_slowly
	ld b, $68
	jr .asm_9ddae

.SetObj5State04:
	ld a, $04
	jr .asm_9ddc4

.MoveObj2LeftToObj4:
	call .move_obj2_left_slowly
	ld b, $58
	jr .asm_9ddae

.SetObj4State04:
	ld a, $04
	jr .asm_9ddb5

.MoveObj2LeftToObj3:
	call .move_obj2_left_slowly
	ld b, $48
	jr .asm_9ddae

.SetObj3State04:
	ld a, $04
	jr .asm_9dda3

.MoveObj2UpOffScreen:
	call .move_obj2_up_slowly
	ld b, $20
	jr .asm_9ddae

.HideObj2:
	xor a
	ld [wSceneObj2State], a
	jp AdvanceCutsceneFunc

Cutscene37Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_TorchForest

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .Wait40
	dw .RaiseItem
	dw EndCutsceneDelay_100Frames

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 192 ; y
	ld [hli], a
	ld [hl], 50 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $03
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.Wait40:
	ld c, 40
	jp WaitCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $8e
	jp z, PlayItemRaiseSFX
	cp $68
	ret nz
	jp AdvanceCutsceneFunc

Cutscene38Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RevealWarpedVoid

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .SetObj2State02
	dw .WaitObj2Frame01SFX
	dw .WaitObj2Frame05SFX
	dw .WaitObj2State03
	dw .Wait120
	dw CutsceneFadeToWhite
	dw .HideObj2
	dw EndCutsceneDelay_40Frames

.ShowItem:
	ld a, [bc]
	cp $1e
	ret c
	ld hl, wSceneObj2YCoord
	ld a, 152 ; y
	ld [hli], a
	ld [hl], 72 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld a, $01
	ld [wCutsceneOverlayType], a
	call PlayItemRaiseSFX
	jp AdvanceCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $78
	ret nz
	jp AdvanceCutsceneFunc

.SetObj2State02:
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2Frame01SFX:
	ld a, [wSceneObj2Frame]
	cp $01
	ret nz
	play_sfx SFX_SWITCH
	jp AdvanceCutsceneFunc

.WaitObj2Frame05SFX:
	ld a, [wSceneObj2Frame]
	cp $05
	ret nz
	play_sfx SFX_EMOTE
	jp AdvanceCutsceneFunc

.WaitObj2State03:
	ld a, [wSceneObj2State]
	cp $03
	ret nz
	jp AdvanceCutsceneFunc

.Wait120:
	ld c, 120
	jp WaitCutsceneFunc

.HideObj2:
	xor a
	ld [wSceneObj2State], a
	jp AdvanceCutsceneFunc

InitCutscene30Objs:
	ld hl, wSceneObj2
	ld a, 88 ; y
	ld [hli], a
	ld [hl], 98 ; x
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState

	ld hl, wSceneObj3
	ld a, 88 ; y
	ld [hli], a
	ld [hl], 70 ; x
	ld a, $01
	ld hl, wSceneObj3State
	call SetSceneObjState

	ld hl, wSceneObj4
	ld a, 72 ; y
	ld [hli], a
	ld [hl], 82 ; x
	ld hl, wSceneObj5
	ld a, 68 ; y
	ld [hli], a
	ld [hl], 70 ; x
	ld hl, wSceneObj6
	ld a, 60 ; y
	ld [hli], a
	ld [hl], 52 ; x

	jp UpdateCutsceneObjs_RaiseIceBlocks

Cutscene30Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RaiseIceBlocks

.PlayCutscene:
	call .RaiseObj4
	call .RaiseObj5
	call .RaiseObj6

	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .Wait10
	dw .SetObj2State02
	dw .WaitObj2State03
	dw .SetObj2State02
	dw .WaitObj2State03
	dw .SetObj2State02
	dw .WaitObj2State03
	dw .Wait30
	dw .RaiseObj3AndStartObjs4To6
	dw EndCutsceneDelay_20Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(RaiseIceBlocksCutscenePals_b8500)
	ld hl, RaiseIceBlocksCutscenePals_b8500
	call LoadFarPalsToTempPals1
	ld b, BANK(RaiseIceBlocksCutscenePals_b8500)
	ld hl, RaiseIceBlocksCutscenePals_b8500
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.Wait10:
	ld c, 10
	jp WaitCutsceneFunc

.SetObj2State02:
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2State03:
	ld a, [wSceneObj2State]
	cp $03
	ret nz
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.RaiseObj3AndStartObjs4To6:
	ld a, [wOWStepCounter]
	and $07
	ret nz
	ld hl, wSceneObj3YCoord
	dec [hl]
	ld a, [hl]
	cp $48
	jr z, .asm_9df8d
	cp $44
	jr z, .asm_9df9c
	cp $3c
	jr z, .asm_9dfa1
	cp $20
	ret nz
	jp AdvanceCutsceneFunc

.asm_9df8d
	ld hl, wSceneObj4State
.asm_9df90
	ld a, $04
	ld [hl], a
	play_sfx SFX_UNDERWATER_THRUST
	ret

.asm_9df9c
	ld hl, wSceneObj5State
	jr .asm_9df90

.asm_9dfa1
	ld hl, wSceneObj6State
	jr .asm_9df90

.RaiseObj5:
	ld de, wSceneObj5State
	ld hl, wSceneObj5
	jr .asm_9dfbc

.RaiseObj6:
	ld de, wSceneObj6State
	ld hl, wSceneObj6
	jr .asm_9dfbc

.RaiseObj4:
	ld de, wSceneObj4State
	ld hl, wSceneObj4
.asm_9dfbc
	ld a, [de]
	and a
	ret z
	ld a, [wOWStepCounter]
	and $01
	ret nz
	dec [hl]
	ld a, [hl]
	cp $20
	ret nz
	xor a
	ld [de], a
	ret

Cutscene39Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RaisePipe

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObj2
	dw .LowerObj2Click
	dw .WaitThenSetObj2State02
	dw .Wait100
	dw EndCutsceneDelay_40Frames

.PlaceObj2:
	ld hl, wSceneObj2
	lb de, $18, $54
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.LowerObj2Click:
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $50
	ret nz
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State02:
	ld a, [bc]
	cp $2d
	ret c
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait100:
	ld c, 100
	jp WaitCutsceneFunc

InitCutscene3aObjs:
	ld hl, wSceneObj2
	lb de, $54, $46
	ld a, $01
	call SetSceneObjPosAndState

	ld hl, wSceneObj4
	ld a, 80 ; y
	ld [hli], a
	ld [hl], 56 ; x
	ld hl, wSceneObj5
	ld a, 80 ; y
	ld [hli], a
	ld [hl], 72 ; x
	ld hl, wSceneObj6
	ld a, 80 ; y
	ld [hli], a
	ld [hl], 88 ; x
	ld hl, wSceneObj7
	ld a, 80 ; y
	ld [hli], a
	ld [hl], 104 ; x
	jp UpdateCutsceneObjs_RemoveWarps

Cutscene3aFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RemoveWarps

.PlayCutscene:
	call .PlayFallingSnowDropSFXWhileObj7State03
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .Wait45
	dw .MoveObj2UpRight
	dw .WaitThenPlaceObj3
	dw .WaitThenStartObjs4To7
	dw .Wait80
	dw .WaitObj4Frame0a
	dw .SetObj4State04
	dw .WaitObj4Disappear
	dw .WaitObj5Frame0a
	dw .SetObj5State04
	dw .WaitObj5Disappear
	dw .WaitObj6Frame0a
	dw .SetObj6State04
	dw .WaitObj6Disappear
	dw .WaitObj7Frame0a
	dw .SetObj7State04
	dw .WaitObj7Disappear
	dw EndCutsceneDelay_60Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(RemoveWarpsCutscenePals_b8780)
	ld hl, RemoveWarpsCutscenePals_b8780
	call LoadFarPalsToTempPals1
	ld b, BANK(RemoveWarpsCutscenePals_b8780)
	ld hl, RemoveWarpsCutscenePals_b8780
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.Wait45:
	ld c, 45
	jp WaitCutsceneFunc

.MoveObj2UpRight:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2YCoord
	dec [hl]
	dec [hl]
	ld a, [hli]
	inc [hl]
	cp $50
	jr z, .asm_9e0ad
	cp $4c
	ret nz
	jp AdvanceCutsceneFunc
.asm_9e0ad
	play_sfx SFX_SWITCH
	ret

.WaitThenPlaceObj3:
	ld a, [bc]
	cp $2d
	ret c
	ld hl, wSceneObj3
	lb de, $3d, $52
	ld a, $02
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.WaitThenStartObjs4To7:
	ld a, [bc]
	cp $8c
	ret c
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	xor a
	ld [wSceneObj3State], a
	ld [wSceneObj2State], a

	stop_sfx

	ld a, $03
	ld hl, wSceneObj4State
	call SetSceneObjState
	ld a, $03
	ld hl, wSceneObj5State
	call SetSceneObjState
	ld a, $03
	ld hl, wSceneObj6State
	call SetSceneObjState
	ld a, $03
	ld hl, wSceneObj7State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait80:
	ld c, 80
	jp WaitCutsceneFunc

.WaitObj4Frame0a:
	ld hl, wSceneObj4Frame
.wait_frame_0a
	ld a, [hl]
	cp $0a
	ret nz
	jp AdvanceCutsceneFunc

.SetObj4State04:
	ld hl, wSceneObj4State
.set_state_04
	ld a, $04
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj4Disappear:
	ld hl, wSceneObj4State
.wait_disappear
	ld a, [hl]
	and a
	ret nz
	jp AdvanceCutsceneFunc

.WaitObj5Frame0a:
	ld hl, wSceneObj5Frame
	jr .wait_frame_0a

.SetObj5State04:
	ld hl, wSceneObj5State
	jr .set_state_04

.WaitObj5Disappear:
	ld hl, wSceneObj5State
	jr .wait_disappear

.WaitObj6Frame0a:
	ld hl, wSceneObj6Frame
	jr .wait_frame_0a

.SetObj6State04:
	ld hl, wSceneObj6State
	jr .set_state_04

.WaitObj6Disappear:
	ld hl, wSceneObj6State
	jr .wait_disappear

.WaitObj7Frame0a:
	ld hl, wSceneObj7Frame
	jr .wait_frame_0a

.SetObj7State04:
	ld hl, wSceneObj7State
	jr .set_state_04

.WaitObj7Disappear:
	ld hl, wSceneObj7State
	jr .wait_disappear

.PlayFallingSnowDropSFXWhileObj7State03:
	ld a, [wSceneObj7State]
	cp $03
	ret nz
	ld hl, wSceneObj7MovementStep
	inc [hl]
	ld a, [hl]
	cp $01
	jr z, .asm_9e168
	cp $1b
	ret c
	xor a
	ld [hl], a
	ret
.asm_9e168
	play_sfx SFX_FALLING_SNOW_DROP
	ret

Cutscene3cFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_CollectDemonsBlood

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObjs2And3
	dw .LowerItem
	dw .WaitThenSetObj2State02
	dw .WaitObj2State03
	dw .DropObj3
	dw .WaitObj3Disappear
	dw .WaitThenPlaceObj4SFX
	dw .WaitObj4State07
	dw EndCutsceneDelay_40Frames

.PlaceObjs2And3:
	ld hl, wSceneObj2
	lb de, $20, $42
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $3e, $50
	ld a, $00
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.LowerItem:
	ld a, [bc]
	and $01
	ret z
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $27
	jp z, PlayItemRaiseSFX
	cp $3a
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State02:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2State03:
	ld a, [wSceneObj2State]
	cp $03
	ret nz
	jp AdvanceCutsceneFunc

.DropObj3:
	call .get_fall_speed
	ld hl, wSceneObj3YCoord
	add [hl]
	ld [hl], a
	cp $58
	ret c
	ld [hl], $58
	ld a, $05
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_WATER_DROP
	jp AdvanceCutsceneFunc

.get_fall_speed:
	ld a, [bc]
	cp $2c
	jr c, .asm_9e1fc
	ld a, $28
	ld [bc], a
.asm_9e1fc
	ld c, a
	ld b, $00
	ld hl, .data_9e205
	add hl, bc
	ld a, [hl]
	ret

.data_9e205
	db $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $01, $01, $01, $00, $01, $01, $01, $00, $01, $01, $01, $01, $01, $01, $01, $01, $02, $02, $02, $02

.WaitObj3Disappear:
	ld a, [wSceneObj3State]
	and a
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenPlaceObj4SFX:
	ld a, [bc]
	cp $3c
	ret c
	ld hl, wSceneObj4
	lb de, $58, $50
	ld a, $06
	call SetSceneObjPosAndState
	play_sfx SFX_ZOMBIE_RISE
	jp AdvanceCutsceneFunc

.WaitObj4State07:
	ld a, [wSceneObj4State]
	cp $07
	ret nz
	jp AdvanceCutsceneFunc

Cutscene43Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_PlacePropeller

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObj2
	dw .LowerObj2Click
	dw .WaitThenSetObj2State02
	dw .WaitThenPlaceObj3
	dw EndCutsceneDelay_120Frames

.PlaceObj2:
	ld hl, wSceneObj2
	lb de, $20, $50
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.LowerObj2Click:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $50
	ret nz
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State02:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitThenPlaceObj3:
	ld a, [bc]
	cp $2d
	ret c
	ld hl, wSceneObj3
	lb de, $48, $50
	ld a, $03
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

InitCutscene54Objs:
	ld hl, wSceneObj2
	lb de, $58, $50
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $70, $50
	ld a, $02
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_CutBaloon

Cutscene54Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_CutBaloon

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .Wait40
	dw .RaiseItem
	dw .WaitThenSetObj3State03Click
	dw .Wait20
	dw .RaiseObj2
	dw EndCutsceneDelay_20Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(CutBaloonCutscenePals_b8740)
	ld hl, CutBaloonCutscenePals_b8740
	call LoadFarPalsToTempPals1
	ld b, BANK(CutBaloonCutscenePals_b8740)
	ld hl, CutBaloonCutscenePals_b8740
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.Wait40:
	ld c, 40
	jp WaitCutsceneFunc

.RaiseItem:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj3YCoord
	dec [hl]
	ld a, [hl]
	cp $6b
	jp z, PlayItemRaiseSFX
	cp $58
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State03Click:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $03
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.Wait20:
	ld c, 20
	jp WaitCutsceneFunc

.RaiseObj2:
	ld a, [bc]
	and $03
	ret z
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $20
	ret nz
	jp AdvanceCutsceneFunc

Cutscene3dFunc:
	call .PlayCutscene
	call UpdateCutsceneLevelObj_OpenParaGoomCage
	jp UpdateCutsceneObjs_OpenParaGoomCage

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObj2
	dw .MoveObj2UpLeft
	dw .WaitThenNextObj2StateSFX
	dw .WaitObj2Disappear
	dw .WaitThenPlaceObj2State03
	dw .MoveObj2UpLeft
	dw .WaitThenNextObj2StateSFX
	dw .WaitObj2Disappear
	dw .WaitThenFlipBGMapPlaceObjs3And4
	dw .WaitThenSetObj4State06
	dw .WaitThenPlaySeeingEyeDoorLookSFX
	dw .WaitObj4State07
	dw .WaitThenSetObj3State02
	dw .WaitThenPlayScowlerDefeatedSFX
	dw .LowerObj3
	dw EndCutsceneDelay_20Frames

.PlaceObj2:
	ld hl, wSceneObj2
	lb de, $6c, $78
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.MoveObj2UpLeft:
	ld hl, wSceneObj2YCoord
	dec [hl]
	inc l
	dec [hl]
	ld a, [hl]
	cp $44
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenNextObj2StateSFX:
	ld a, [bc]
	cp $1e
	ret c
	ld hl, wSceneObj2State
	ld a, [hl]
	inc a
	call SetSceneObjState
	play_sfx SFX_0C4
	jp AdvanceCutsceneFunc

.WaitObj2Disappear:
	ld a, [wSceneObj2State]
	and a
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenPlaceObj2State03:
	ld a, [bc]
	cp $0a
	ret c
	ld hl, wSceneObj2
	lb de, $84, $78
	ld a, $03
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.WaitThenFlipBGMapPlaceObjs3And4:
	ld a, [bc]
	cp $3c
	ret c
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	ld hl, wSceneObj4
	lb de, $50, $50
	ld a, $05
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $40, $50
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.WaitThenSetObj4State06:
	ld a, [bc]
	cp $5a
	ret c
	ld a, $06
	ld hl, wSceneObj4State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitThenPlaySeeingEyeDoorLookSFX:
	ld a, [bc]
	cp $04
	ret c
	play_sfx SFX_SEEING_EYE_DOOR_LOOK
	jp AdvanceCutsceneFunc

.WaitObj4State07:
	ld a, [wSceneObj4State]
	cp $07
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State02:
	ld a, [bc]
	cp $08
	ret c
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitThenPlayScowlerDefeatedSFX:
	ld a, [bc]
	cp $14
	ret c
	play_sfx SFX_SCOWLER_DEFEATED
	jp AdvanceCutsceneFunc

.LowerObj3:
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj3YCoord
	inc [hl]
	ld a, [hl]
	cp $80
	ret nz
	jp AdvanceCutsceneFunc

InitCutscene4aObjs:
	ld hl, wSceneObj2
	lb de, $40, $b0
	ld a, $02
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $44, $50
	ld a, $01
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_OpenSkyDoor

Cutscene4aFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_OpenSkyDoor

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .MoveObj2Left
	dw .WaitThenSetObj2State03
	dw .WaitObj2Frame04Click
	dw .WaitObj2Frame06SFX
	dw .WaitObj2Frame07
	dw EndCutsceneDelay_40Frames

.MoveObj2Left:
	ld hl, wSceneObj2XCoord
	dec [hl]
	ld a, [hl]
	cp $56
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State03:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2Frame04Click:
	ld a, [wSceneObj2Frame]
	cp $04
	ret nz
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

.WaitObj2Frame06SFX:
	ld a, [wSceneObj2Frame]
	cp $06
	ret nz
	play_sfx SFX_132
	jp AdvanceCutsceneFunc

.WaitObj2Frame07:
	ld a, [wSceneObj2Frame]
	cp $07
	ret nz
	jp AdvanceCutsceneFunc

InitCutscene4cObjs:
	ld hl, wSceneObj2
	lb de, $80, $40
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $50, $5c
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj3Attributes
	set 1, [hl]
	call UpdateCutsceneObjs_ExtinguishFire
	jp UpdateCutsceneLevelObj_ExtinguishFire

Cutscene4cFunc:
	call .PlayCutscene
	call UpdateCutsceneObjs_ExtinguishFire
	jp UpdateCutsceneLevelObj_ExtinguishFire

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .Wait40
	dw .RaiseItem
	dw .WaitThenSetObj2State02
	dw .WaitObj2State03
	dw .WaitThenSetObj3State02
	dw .WaitThenHideObj3
	dw EndCutsceneDelay_60Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(ExtinguishFireCutscenePals_b86c0)
	ld hl, ExtinguishFireCutscenePals_b86c0
	call LoadFarPalsToTempPals1
	ld b, BANK(ExtinguishFireCutscenePals_b86c0)
	ld hl, ExtinguishFireCutscenePals_b86c0
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.Wait40:
	ld c, 40
	jp WaitCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $7e
	jp z, PlayItemRaiseSFX
	cp $58
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State02:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jr .advance ; was jp AdvanceCutsceneFunc: frees a byte for the ret nz below

.WaitObj2State03:
	ld a, [wSceneObj2State]
	cp $03
	; fix: the original lacks this ret nz, so it always advanced and the fire
	; went out about 6 frames early (state 2 is a 6-frame animation)
	ret nz
.advance
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State02:
	ld a, [bc]
	cp $64
	ret c
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitThenHideObj3:
	ld a, [bc]
	cp $3c
	ret c
	xor a
	ld [wSceneObj3State], a
	jp AdvanceCutsceneFunc

Cutscene4eFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_PlaceBrick

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .WaitThenPlaceObj2
	dw .RaiseObj2Click
	dw EndCutsceneDelay_80Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(PlaceBrickCutscenePals_b8640)
	ld hl, PlaceBrickCutscenePals_b8640
	call LoadFarPalsToTempPals1
	ld b, BANK(PlaceBrickCutscenePals_b8640)
	ld hl, PlaceBrickCutscenePals_b8640
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.WaitThenPlaceObj2:
	ld a, [bc]
	cp $14
	ret c
	ld hl, wSceneObj2
	lb de, $78, $50
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.RaiseObj2Click:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $50
	ret nz
	play_sfx SFX_CLICK
	jp AdvanceCutsceneFunc

InitCutscene4fObjs:
	ld hl, wSceneObj2
	lb de, $20, $4c
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $50, $60
	ld a, $04
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_SprayIronWall

Cutscene4fFunc:
	call .PlayCutscene
	jp UpdateCutsceneObjs_SprayIronWall

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LowerItem
	dw .WaitThenSetObj2State02
	dw .Wait45
	dw .LowerObj2
	dw .Wait8
	dw .RaiseObj2
	dw .Wait8
	dw .LowerObj2
	dw .Wait8
	dw .RaiseObj2
	dw .WaitThenSetObj2State01
	dw .WaitThenSetObj3State03
	dw .WaitObj3State05
	dw EndCutsceneDelay_40Frames

.LowerItem:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $31
	jp z, PlayItemRaiseSFX
	cp $44
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State02:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait45:
	ld c, 45
	jp WaitCutsceneFunc

.LowerObj2:
	ld d, $5c
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp d
	ret nz
	jp AdvanceCutsceneFunc

.Wait8:
	ld c, 8
	jp WaitCutsceneFunc

.RaiseObj2:
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $44
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State01:
	ld a, [bc]
	cp $1e
	ret c
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State03:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $03
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj3State05:
	ld a, [wSceneObj3State]
	cp $05
	ret nz
	jp AdvanceCutsceneFunc

InitCutscene51Objs:
	ld hl, wSceneObj2
	lb de, $40, $58
	ld a, $02
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $58, $58
	ld a, $01
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_MixChemicals

Cutscene51Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_MixChemicals

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LowerItem
	dw .SetObj2State03
	dw .WaitObj2Frame04SFX
	dw .WaitObj2Disappear
	dw .Wait45
	dw .LowerObj3
	dw EndCutsceneDelay_60Frames

.LowerItem:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $45
	jp z, PlayItemRaiseSFX
	cp $58
	ret nz
	jp AdvanceCutsceneFunc

.SetObj2State03:
	ld a, $03
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2Frame04SFX:
	ld a, [wSceneObj2Frame]
	cp $04
	ret nz
	play_sfx SFX_WATER_DROP
	jp AdvanceCutsceneFunc

.WaitObj2Disappear:
	ld a, [wSceneObj2State]
	and a
	ret nz
	jp AdvanceCutsceneFunc

.Wait45:
	ld c, 45
	jp WaitCutsceneFunc

.LowerObj3:
	call .play_sfx_rumble_every_16_frames
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj3YCoord
	inc [hl]
	ld a, [hl]
	cp $78
	ret nz
	jp AdvanceCutsceneFunc

.play_sfx_rumble_every_16_frames:
	ld hl, wSceneObj3MovementStep
	inc [hl]
	ld a, [hl]
	cp $01
	jr z, .asm_9e6e6
	cp $10
	ret c
	xor a
	ld [hl], a
	ret
.asm_9e6e6
	play_sfx SFX_RUMBLE
	ret

InitCutscene56Objs:
	ld hl, wSceneObj2
	lb de, $56, $50
	ld a, $01
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_RevealDarkRoom

Cutscene56Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_RevealDarkRoom

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .WaitThenPlaceObj2
	dw .WaitObj2State02
	dw .WaitObj2State01
	dw .WaitThenHideObj2FlipBGMap
	dw .LoadFadePals1
	dw .FadeEvery2Frames
	dw .LoadFadePals2
	dw .FadeEvery4Frames
	dw ExitCutscene

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(RevealDarkRoomCutscenePals_b9080)
	ld hl, RevealDarkRoomCutscenePals_b9080
	call LoadFarPalsToTempPals1
	ld b, BANK(RevealDarkRoomCutscenePals_b9080)
	ld hl, RevealDarkRoomCutscenePals_b9080
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.WaitThenPlaceObj2:
	ld a, [bc]
	cp $2d
	ret c
	ld hl, wSceneObj2
	lb de, $56, $50
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.WaitObj2State02:
	ld a, [wSceneObj2State]
	cp $02
	ret nz
	jp AdvanceCutsceneFunc

.WaitObj2State01:
	ld a, [wSceneObj2State]
	cp $01
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenHideObj2FlipBGMap:
	ld a, [bc]
	cp $14
	ret c
	xor a
	ld [wSceneObj2State], a
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	ld b, BANK(RevealDarkRoomCutscenePals_b8800)
	ld c, 8 palettes
	ld hl, RevealDarkRoomCutscenePals_b8800
	ld de, wTempPals1
	call CopyFarBytes
	call SetPalConfig1ToTempPals1
	jp AdvanceCutsceneFunc

.LoadFadePals1:
	ld hl, RevealDarkRoomCutscenePals_b8840
.load_fade_target
	call CopyTempPalsToBGOBPals
	ld b, BANK(RevealDarkRoomCutscenePals_b8840) ; aka BANK(RevealDarkRoomCutscenePals_b8880)
	call LoadFarPalsToTempPals1
	jp AdvanceCutsceneFunc

.FadeEvery2Frames:
	ld a, [bc]
	and $01
	ret nz
	jp CutsceneFadePals

.LoadFadePals2:
	ld hl, RevealDarkRoomCutscenePals_b8880
	jr .load_fade_target

.FadeEvery4Frames:
	ld a, [bc]
	and $03
	ret nz
	jp CutsceneFadePals

InitCutscene57Objs:
	ld hl, wSceneObj3
	lb de, $4e, $54
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj2
	lb de, $10, $48
	ld a, $03
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_SummonMoon

Cutscene57Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_SummonMoon

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .LowerItem
	dw .WaitThenSetObj2State04
	dw .WaitObj2State03SetObj3State02
	dw .WaitThenSetObj3State01
	dw .LoadFadePals1
	dw .FadeEvery2Frames
	dw .LoadFadePals2
	dw .FadeEvery2Frames
	dw .LoadFadePals3
	dw .FadeEvery2Frames
	dw ExitCutscene

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(SummonMoonCutscenePals_b8540)
	ld hl, SummonMoonCutscenePals_b8540
	call LoadFarPalsToTempPals1
	ld b, BANK(SummonMoonCutscenePals_b8540)
	ld hl, SummonMoonCutscenePals_b8540
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.LowerItem:
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $2c
	jp z, PlayItemRaiseSFX
	cp $52
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State04:
	ld a, [bc]
	cp $32
	ret c
	ld a, $04
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2State03SetObj3State02:
	ld a, [wSceneObj2State]
	cp $03
	ret nz
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_GONG
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State01:
	ld a, [bc]
	cp $30
	ret c
	ld a, $01
	ld hl, wSceneObj3State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.LoadFadePals1:
	ld hl, SummonMoonCutscenePals_b8580
.load_fade_target
	call CopyTempPalsToBGOBPals
	ld b, BANK(SummonMoonCutscenePals_b8580) ; aka BANK(SummonMoonCutscenePals_b85c0) and BANK(SummonMoonCutscenePals_b8600)
	call LoadFarPalsToTempPals1
	jp AdvanceCutsceneFunc

.FadeEvery2Frames:
	ld a, [bc]
	and $01
	ret nz
	jp CutsceneFadePals

.LoadFadePals2:
	ld hl, SummonMoonCutscenePals_b85c0
	jr .load_fade_target

.LoadFadePals3:
	ld hl, SummonMoonCutscenePals_b8600
	jr .load_fade_target

InitCutscene58Objs:
	ld hl, wSceneObj2
	lb de, SCREEN_HEIGHT_PX, $48
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $48, $58
	ld a, $01
	call SetSceneObjPosAndState
	call UpdateCutsceneObjs_OpenCraterHole
	jp UpdateCutsceneLevelObj_OpenCraterHole

Cutscene58Func:
	call .PlayCutscene
	call UpdateCutsceneObjs_OpenCraterHole
	jp UpdateCutsceneLevelObj_OpenCraterHole

.PlayCutscene:
	push bc
	call MoveCutsceneObj10
	call MoveCutsceneObj11
	pop bc

	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .Wait30
	dw .RaiseItem
	dw .Wait30
	dw .WaitThenSetObj2State02
	dw .WaitObj2State01StartObjs10And11
	dw .WaitThenSetObj2State02
	dw .WaitObj2State01FlipBGMap
	dw EndCutsceneDelay_120Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(OpenCraterHoleCutscenePals_b87c0)
	ld hl, OpenCraterHoleCutscenePals_b87c0
	call LoadFarPalsToTempPals1
	ld b, BANK(OpenCraterHoleCutscenePals_b87c0)
	ld hl, OpenCraterHoleCutscenePals_b87c0
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.RaiseItem:
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $76
	jp z, PlayItemRaiseSFX
	cp $50
	ret nz
	jp AdvanceCutsceneFunc

.WaitThenSetObj2State02:
	ld a, [bc]
	cp $1a
	ret c
	ld a, $02
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj2State01StartObjs10And11:
	ld a, [wSceneObj2State]
	cp $01
	ret nz
.start_objs_10_and_11
	ld hl, wSceneObj10
	lb de, $48, $54
	ld a, $03
	call SetSceneObjPosAndState
	ld hl, wSceneObj11
	lb de, $44, $58
	ld a, $03
	call SetSceneObjPosAndState
	ld a, $01
	ld [wSceneObj12YCoord], a
	ld [wSceneObj12XCoord], a
	play_sfx SFX_132
	jp AdvanceCutsceneFunc

.WaitObj2State01FlipBGMap:
	ld a, [wSceneObj2State]
	cp $01
	ret nz
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	jr .start_objs_10_and_11

InitCutscene55Objs:
	ld hl, wSceneObj3
	lb de, $58, $40
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj4
	lb de, $58, $50
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj5
	lb de, $58, $60
	ld a, $01
	call SetSceneObjPosAndState
	ld hl, wSceneObj6
	lb de, $58, $40
	ld a, $04
	call SetSceneObjPosAndState
	ld hl, wSceneObj7
	lb de, $58, $50
	ld a, $04
	call SetSceneObjPosAndState
	ld hl, wSceneObj8
	lb de, $58, $60
	ld a, $04
	call SetSceneObjPosAndState
	jp UpdateCutsceneObjs_DrillHoles

Cutscene55Func:
	call .PlayCutscene
	jp UpdateCutsceneObjs_DrillHoles

.PlayCutscene:
	push bc
	call MoveCutsceneObj10
	call MoveCutsceneObj11
	pop bc

	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .LoadPals
	dw CutsceneFadePals
	dw .WaitThenPlaceObj2
	dw .MoveObj2Left
	dw .Wait45
	dw .LowerObj2Switch
	dw .HideObj3StartObjs10And11
	dw .WaitThenSetObj6State05
	dw .RaiseObj2
	dw .MoveObj2RightTo54
	dw .Wait45
	dw .LowerObj2Switch
	dw .HideObj4StartObjs10And11
	dw .WaitThenSetObj7State05
	dw .RaiseObj2
	dw .MoveObj2RightTo64
	dw .Wait45
	dw .LowerObj2Switch
	dw .HideObj5StartObjs10And11
	dw .WaitThenSetObj8State05
	dw .RaiseObj2
	dw .Wait30
	dw .MoveObj2RightOffScreen
	dw EndCutsceneDelay_40Frames

.LoadPals:
	call ClearBGOBPals_Bank27
	ld b, BANK(DrillHolesCutscenePals_b8680)
	ld hl, DrillHolesCutscenePals_b8680
	call LoadFarPalsToTempPals1
	ld b, BANK(DrillHolesCutscenePals_b8680)
	ld hl, DrillHolesCutscenePals_b8680
	call LoadFarPalsToTempPals2
	jp AdvanceCutsceneFunc

.WaitThenPlaceObj2:
	ld a, [bc]
	cp $28
	ret c
	ld hl, wSceneObj2
	lb de, $46, $90
	ld a, $02
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.MoveObj2Left:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2XCoord
	dec [hl]
	ld a, [hl]
	cp $44
	ret nz
	jp AdvanceCutsceneFunc

.Wait45:
	ld c, 45
	jp WaitCutsceneFunc

.LowerObj2Switch:
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $4e
	ret nz
	play_sfx SFX_SWITCH
	jp AdvanceCutsceneFunc

.HideObj3StartObjs10And11:
	xor a
	ld [wSceneObj3State], a
.start_objs_10_and_11:
	ld hl, wSceneObj10
	lb de, $4c, $40
	ld a, $03
	call SetSceneObjPosAndState
	ld hl, wSceneObj11
	lb de, $4c, $48
	ld a, $03
	call SetSceneObjPosAndState
	ld a, $01
	ld [wSceneObj12YCoord], a
	ld [wSceneObj12XCoord], a
	jp AdvanceCutsceneFunc

.WaitThenSetObj6State05:
	ld a, [bc]
	cp $14
	ret c
	ld a, $05
	ld hl, wSceneObj6State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.RaiseObj2:
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld a, [hl]
	cp $46
	ret nz
	jp AdvanceCutsceneFunc

.MoveObj2RightTo54:
	ld e, $54
.move_obj2_right_to_e
	ld a, [bc]
	and $03
	ret nz
	ld hl, wSceneObj2XCoord
	inc [hl]
	ld a, [hl]
	cp e
	ret nz
	jp AdvanceCutsceneFunc

.HideObj4StartObjs10And11:
	xor a
	ld [wSceneObj4State], a
	call .start_objs_10_and_11
	ld b, $10
.shift_objs_10_and_11
	ld a, [wSceneObj10XCoord]
	add b
	ld [wSceneObj10XCoord], a
	ld a, [wSceneObj11XCoord]
	add b
	ld [wSceneObj11XCoord], a
	ret

.WaitThenSetObj7State05:
	ld a, [bc]
	cp $14
	ret c
	ld a, $05
	ld hl, wSceneObj7State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.MoveObj2RightTo64:
	ld e, $64
	jr .move_obj2_right_to_e

.HideObj5StartObjs10And11:
	xor a
	ld [wSceneObj5State], a
	call .start_objs_10_and_11
	ld b, $20
	jr .shift_objs_10_and_11

.WaitThenSetObj8State05:
	ld a, [bc]
	cp $14
	ret c
	ld a, $05
	ld hl, wSceneObj8State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.MoveObj2RightOffScreen:
	ld hl, wSceneObj2XCoord
	inc [hl]
	ld a, [hl]
	cp $90
	ret nz
	jp AdvanceCutsceneFunc

MoveCutsceneObj10:
	ld a, [wSceneObj12YCoord]
	and a
	ret z
	ld de, CutsceneObj10Movement
	ld hl, wSceneObj10
	call ApplyOWMovement
	ret nz
	ld [wSceneObj12YCoord], a
	ld [wSceneObj10State], a
	ret

MoveCutsceneObj11:
	ld a, [wSceneObj12XCoord]
	and a
	ret z
	ld de, CutsceneObj11Movement
	ld hl, wSceneObj11
	call ApplyOWMovement
	ret nz
	ld [wSceneObj12XCoord], a
	ld [wSceneObj11State], a
	ret

Cutscene44Func:
	call .PlayCutscene
	call UpdateCutsceneObjs_FeedOctohon
	jp UpdateCutsceneLevelObj_FeedOctohon

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .PlaceObj2
	dw .DropObj2
	dw .WaitThenFlipBGMap
	dw .PlaceObjs2And3
	dw .LowerObj2Wait80
	dw .MoveObj3RightSFX
	dw .WaitThenNudgeObj3Left
	dw .WaitThenHideObj2
	dw .WaitThenSetObj3State02SFX
	dw .WaitObj3State03
	dw .Wait60
	dw .MoveObj3RightOffScreen
	dw .WaitThenPlaySFX08D
	dw CutsceneScreenShake
	dw EndCutsceneDelay_60Frames

.PlaceObj2:
	ld hl, wSceneObj2
	lb de, $20, $4c
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.DropObj2:
	ld a, [bc]
	and $01
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld a, [hl]
	cp $a8
	ret nz
	xor a
	ld [wSceneObj2State], a
	jp AdvanceCutsceneFunc

.WaitThenFlipBGMap:
	ld a, [bc]
	cp $1e
	ret c
	ld a, LCDC_BG_9C00
	ld [wLCDCFlagsToFlip], a
	jp AdvanceCutsceneFunc

.PlaceObjs2And3:
	ld hl, wSceneObj2
	lb de, $20, $50
	ld a, $02
	call SetSceneObjPosAndState
	ld hl, wSceneObj3
	lb de, $48, $20
	ld a, $01
	call SetSceneObjPosAndState
	jp AdvanceCutsceneFunc

.LowerObj2Wait80:
	ld a, [bc]
	cp $50
	call z, AdvanceCutsceneFunc
	call .lower_obj2
	ret

.MoveObj3RightSFX:
	call .lower_obj2
	call .move_obj3_right
	ld a, [hl]
	cp $48
	ret nz
	play_sfx SFX_FAT_WALK
	jp AdvanceCutsceneFunc

.WaitThenNudgeObj3Left:
	ld a, [bc]
	cp $02
	ret c
	ld hl, wSceneObj3XCoord
	dec [hl]
	dec [hl]
	jp AdvanceCutsceneFunc

.WaitThenHideObj2:
	ld a, [bc]
	cp $06
	ret c
	xor a
	ld [wSceneObj2State], a
	jp AdvanceCutsceneFunc

.WaitThenSetObj3State02SFX:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	play_sfx SFX_BEANSTALK_GROW
	jp AdvanceCutsceneFunc

.WaitObj3State03:
	ld a, [wSceneObj3State]
	cp $03
	ret nz
	xor a
	ld [wSceneObj3MovementStep], a
	ld [wSceneObj4YCoord], a
	jp AdvanceCutsceneFunc

.Wait60:
	ld c, 60
	jp WaitCutsceneFunc

.MoveObj3RightOffScreen:
	call .move_obj3_right
	ld a, [hl]
	cp $88
	ret nz
	xor a
	ld [wSceneObj3State], a
	jp AdvanceCutsceneFunc

.WaitThenPlaySFX08D:
	ld a, [bc]
	cp $2d
	ret c
	play_sfx SFX_08D
	jp AdvanceCutsceneFunc

.lower_obj2:
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ret

.move_obj3_right:
	ld hl, wSceneObj3MovementStep
	call .get_obj3_speed
	ld hl, wSceneObj3XCoord
	add [hl]
	ld [hl], a
	ret

.get_obj3_speed:
	ld a, [hl]
	inc [hl]
	cp $30
	jr c, .asm_9ebdd
	xor a
	ld [hl], a
	jr .get_obj3_speed
.asm_9ebdd
	ld c, a
	ld b, $00
	ld hl, .data_9ebe6
	add hl, bc
	ld a, [hl]
	ret

.data_9ebe6
	db 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1

CutsceneObj10Movement:
	db  0,  0, -2,  0, -2, -1, -3,  0, -2, -1, -2, -1, -2, -1, -2, -1, -1, -1, -1, -2,  0, -3,  1, -1,  2, -2,  6, -4,  6, -3,  6, -2,  7, -2,  6, -2,  7, -2,  6, -2,  7, -1, $80

CutsceneObj11Movement:
	db  0,  0, -1,  1, -2,  1, -1,  1, -1,  1, -1,  1, -1,  1,  0,  2,  1,  1,  1,  2,  1,  0,  2,  1,  1,  1,  5,  2,  5,  1,  6,  1,  5,  1,  6,  0,  5,  1,  6,  0,  5,  0, $80

Cutscene14Func:
	call .PlayCutscene
	call UpdateCutsceneObjs_VolcanoEruption
	ret

.PlayCutscene:
	ld a, [wOWStep]
	jumptable
	dw StartCutsceneDelay
	dw .ShowItem
	dw .RaiseItem
	dw .Wait60
	dw .LowerItem
	dw .LowerCurObj
	dw .WaitWobbleThenSwitchTable
	dw .WaitWobbleLoop
	dw .Wait30
	dw .HideObjs2To4ShowObj5
	dw .Wait120
	dw .SetObj5State05
	dw .WaitObj5State06
	dw .Wait90
	dw .LowerObj5
	dw .WaitSFXCounter09
	dw .FadeToWhiteWithSFX
	dw .Exit

.ShowItem:
	ld hl, wSceneObj2YCoord
	ld a, 120 ; y
	ld [hli], a
	ld [hl], 82 ; x
	ld a, $01
	ld hl, wSceneObj2State
	call SetSceneObjState
	ld hl, wSceneObj3YCoord
	ld a, 145 ; y
	ld [hli], a
	ld [hl], 68 ; x
	ld a, $02
	ld hl, wSceneObj3State
	call SetSceneObjState
	ld hl, wSceneObj4YCoord
	ld a, 145 ; y
	ld [hli], a
	ld [hl], 96 ; x
	ld a, $03
	ld hl, wSceneObj4State
	call SetSceneObjState
	ld hl, wCurSceneObj
	ld a, $bc
	ld [hli], a
	ld [hl], $50
	ld a, $02
	ld [wCutsceneOverlayType], a
	ld hl, wCutscene14Obj2WobblePtr
	ld [hl], LOW(VolcanoEruptionWobbleLoop)
	inc l
	ld [hl], HIGH(VolcanoEruptionWobbleLoop)
	inc l
	ld [hl], LOW(VolcanoEruptionWobbleLoop_Obj3Start)
	inc l
	ld [hl], HIGH(VolcanoEruptionWobbleLoop_Obj3Start)
	inc l
	ld [hl], LOW(VolcanoEruptionWobbleLoop_Obj4Start)
	inc l
	ld [hl], HIGH(VolcanoEruptionWobbleLoop_Obj4Start)
	jp AdvanceCutsceneFunc

.RaiseItem:
	call .WobbleObjs2To4
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld hl, wSceneObj2YCoord
	dec [hl]
	ld hl, wSceneObj3YCoord
	dec [hl]
	ld hl, wSceneObj4YCoord
	dec [hl]
	ld hl, wCurSceneObj
	dec [hl]
	ld a, [hl]
	cp $87
	jp z, PlayItemRaiseSFX
	cp $74
	ret nz
	jp AdvanceCutsceneFunc

.Wait60:
	call .WobbleObjs2To4
	ld c, 60
	jp WaitCutsceneFunc

.LowerItem:
	call .WobbleObjs2To4
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wSceneObj2YCoord
	inc [hl]
	ld hl, wSceneObj3YCoord
	inc [hl]
	ld hl, wSceneObj4YCoord
	inc [hl]
	ld hl, wCurSceneObj
	inc [hl]
	ld a, [hl]
	cp $82
	ret nz
	jp AdvanceCutsceneFunc

.LowerCurObj:
	call .WobbleObjs2To4
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wCurSceneObj
	inc [hl]
	ld a, [hl]
	cp $92
	ret nz
	xor a
	ld [wCutsceneOverlayType], a
	jp AdvanceCutsceneFunc

.WaitWobbleThenSwitchTable:
	call .WobbleObjs2To4
	ret nc
	ld hl, wCutscene14Obj2WobblePtr
	ld a, LOW(VolcanoEruptionWobbleOnce_Obj2)
	ld [hli], a
	ld a, HIGH(VolcanoEruptionWobbleOnce_Obj2)
	ld [hli], a
	ld a, LOW(VolcanoEruptionWobbleOnce_Obj3)
	ld [hli], a
	ld a, HIGH(VolcanoEruptionWobbleOnce_Obj3)
	ld [hli], a
	ld a, LOW(VolcanoEruptionWobbleOnce_Obj4)
	ld [hli], a
	ld a, HIGH(VolcanoEruptionWobbleOnce_Obj4)
	ld [hli], a
	jp AdvanceCutsceneFunc

.WaitWobbleLoop:
	call .WobbleObjs2To4
	ret nc
	jp AdvanceCutsceneFunc

.Wait30:
	ld c, 30
	jp WaitCutsceneFunc

.HideObjs2To4ShowObj5:
	ld hl, wSceneObj5
	ld a, 76 ; y
	ld [hli], a
	ld [hl], 80 ; x
	ld a, $04
	ld hl, wSceneObj5State
	call SetSceneObjState
	xor a
	ld [wSceneObj2State], a
	ld [wSceneObj3State], a
	ld [wSceneObj4State], a
	ld [wCutsceneSFXCounter], a
	jp AdvanceCutsceneFunc

.Wait120:
	call .play_sfx_10f_every_10_frames
	ld c, 120
	jp WaitCutsceneFunc

.play_sfx_10f_every_10_frames:
	ld hl, wCutsceneSFXCounter
	inc [hl]
	ld a, [hl]
	cp $0a
	ret c
	xor a
	ld [hl], a
	play_sfx SFX_10F
	ret

.SetObj5State05:
	ld a, $05
	ld hl, wSceneObj5State
	call SetSceneObjState
	jp AdvanceCutsceneFunc

.WaitObj5State06:
	call .play_obj5_sfx
	ld a, [wSceneObj5State]
	cp $06
	ret nz
	jp AdvanceCutsceneFunc

.play_obj5_sfx:
	ld hl, wCutsceneSFXCounter
	inc [hl]
	ld a, [hl]
	cp $0a
	ret c
	xor a
	ld [hl], a
	ld a, [wSceneObj5Frame]
	cp $09
	jr nc, .asm_9ede8
	play_sfx SFX_110
	ret
.asm_9ede8
	play_sfx SFX_111
	ret

.Wait90:
	call .play_obj5_sfx
	ld c, 90
	jp WaitCutsceneFunc

.LowerObj5:
	call .play_obj5_sfx
	ld a, [wOWStepCounter]
	ld b, $01
	cp $08
	jr c, .asm_9ee0b
	inc b
	cp $10
	jr c, .asm_9ee0b
	inc b
.asm_9ee0b
	ld a, b
	ld hl, wSceneObj5
	add [hl]
	ld [hl], a
	cp $70
	ret c
	jp AdvanceCutsceneFunc

.WaitSFXCounter09:
	call .play_obj5_sfx
	ld a, [wCutsceneSFXCounter]
	cp $09
	ret nz
	jp AdvanceCutsceneFunc

.FadeToWhiteWithSFX:
	call .play_fade_sfx
	call CutsceneFadeToWhite
	ret

.play_fade_sfx:
	ld hl, wCutsceneSFXCounter
	inc [hl]
	ld a, [hl]
	cp $0a
	jr z, .asm_9ee3c
	cp $14
	jr z, .asm_9ee45
	cp $1e
	jr z, .asm_9ee4e
	ret
.asm_9ee3c
	play_sfx SFX_114
	ret
.asm_9ee45
	play_sfx SFX_115
	ret
.asm_9ee4e
	play_sfx SFX_116
	ret

.Exit:
	call ExitCutscene
	ret

.WobbleObjs2To4:
	ld bc, wCutscene14Obj4WobblePtr
	ld hl, wSceneObj4
	call .apply_wobble
	ld bc, wCutscene14Obj3WobblePtr
	ld hl, wSceneObj3
	call .apply_wobble
	ld bc, wCutscene14Obj2WobblePtr
	ld hl, wSceneObj2
	call .apply_wobble
	ret

.apply_wobble:
	ld a, [bc]
	ld e, a
	inc c
	ld a, [bc]
	ld d, a
	dec c
	ld a, [de]
	add [hl]
	ld [hli], a
	inc de
	ld a, [de]
	add [hl]
	ld [hl], a
	inc de
	ld a, [de]
	cp $80
	jr nz, .store_wobble_ptr
	ld de, VolcanoEruptionWobbleLoop
	call .store_wobble_ptr
	scf
	ret

.store_wobble_ptr:
	ld a, e
	ld [bc], a
	inc c
	ld a, d
	ld [bc], a
	and a
	ret

; y, x steps for the volcano eruption's objects 2-4, looped (.apply_wobble
; goes back to the start at $80). Each object starts at its own point.
VolcanoEruptionWobbleLoop:
	db  0, -1,  0, -1,  0, -1,  0, -1,  1, -1,  0, -1,  0, -1,  0,  0,  1, -1,  0, -1,  1,  0,  0, -1,  1,  0,  0, -1,  1, -1,  1,  0,  0, -1,  1,  0,  0, -1,  1,  0,  1, -1,  0,  0,  1,  0,  1,  0,  1, -1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  1,  1,  0,  1,  0,  0,  0,  1,  1,  1,  0
VolcanoEruptionWobbleLoop_Obj3Start:
	db  0,  1,  1,  0,  0,  1,  1,  0,  1,  1,  0,  1,  1,  0,  0,  1,  1,  0,  0,  1,  1,  1,  0,  0,  0,  1,  0,  1,  1,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1, -1,  1,  0,  1,  0,  1,  0,  0, -1,  1,  0,  1, -1,  0,  0,  1, -1,  0,  0,  1, -1,  1, -1,  0,  0,  1, -1,  0,  0,  1
VolcanoEruptionWobbleLoop_Obj4Start:
	db -1,  0, -1,  1,  0,  0, -1,  0, -1,  0, -1,  1, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, -1, -1,  0, -1,  0,  0,  0, -1, -1, -1,  0,  0, -1, -1,  0,  0, -1, -1,  0, -1, -1,  0, -1, -1,  0,  0, -1, -1,  0,  0, -1, -1, -1,  0,  0,  0, -1,  0, -1, -1, -1,  0, -1,  0, -1,  0, -1,  0, -1, $80

; played once each after .WaitWobbleThenSwitchTable, then back to the loop
VolcanoEruptionWobbleOnce_Obj2:
	db  0,  0,  0, -1,  0,  0,  0, -1,  0,  0,  1, -1,  0,  0,  0, -1,  0,  0,  1, -1,  0,  0,  1, -1,  0,  0,  0,  0,  1, -1,  0,  0,  1,  0,  0,  0,  1, -1,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  1,  1,  0,  0,  1,  0,  0,  0,  1,  1,  0,  0,  0,  0,  1,  1,  0,  0,  1,  1,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0, $80
VolcanoEruptionWobbleOnce_Obj3:
	db  0,  1,  1,  0,  0,  1,  1,  0,  0,  0,  0,  1,  1,  0,  0,  1,  0,  0,  0,  1,  0,  0,  1,  1,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  1,  0,  0,  0,  1, -1,  0,  0,  1,  0,  0,  0,  1,  0,  0, -1,  1,  0,  0,  0,  0, -1,  1,  0,  0, -1,  1,  0,  0, -1,  0,  0,  0, -1,  1,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0,  0, -1, -1,  0,  0,  0, $80
VolcanoEruptionWobbleOnce_Obj4:
	db -1,  0,  0,  0, -1,  1,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0, -1,  0,  0,  0, -1, -1,  0,  0, -1,  0,  0,  0, -1, -1,  0,  0,  0,  0, -1, -1,  0,  0,  0,  0, -1, -1,  0,  0,  0,  0,  0,  0,  0, -1, -1,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  0,  0,  0, -1,  1,  0,  0, -1,  0,  0,  0,  0,  1, -1,  0,  0,  0,  0,  1, -1,  0, -1,  1,  0, $80

GetCutsceneObjFrameset:
	dec a
	call GetPointerFromTableDE
	dec c
	dec c
	ld l, c
	ld h, b
	ret

UpdateCutsceneObjAnim_OWOAM2:
	ld b, $2f
	call UpdateOWAnimation
	ld a, [bc]
	ret

UpdateCutsceneObjAnim_ObjFramesets:
	ld b, $1a
	call UpdateOWAnimation
	ld a, [bc]
	ret

; de = OAM
LoadCutsceneObjSprite_OWOAM2:
	ld b, $2f
	jp LoadOWSprite

; de = OAM
_ObjOAM3:
	ld b, $62
	jp LoadOWSprite

; de = OAM
_ObjOAM1:
	ld b, $60
	jp LoadOWSprite

; de = OAM
_ObjOAM4:
	ld b, $63
	jp LoadOWSprite

SetSceneObjStateWhenAnimFinished:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	set 2, l
	xor a
	ld [hli], a ; duration
	ld [hli], a ; frameset offset
	ld a, b
	ld [hl], a ; state
	ld b, h
	ld c, l
	ret

UpdateCutsceneObjs_OpenNorthGate:
	ld bc, wSceneObj3State
	call .asm_9f0e9
	ld bc, wSceneObj2State
.asm_9f0e9
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $05
	jr z, .asm_9f103
	cp $06
	jr z, .asm_9f107
.asm_9f0fd
	ld de, OpenNorthGateCutsceneOAM_bd1fd
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f103
	ld b, $00
	jr .asm_9f109
.asm_9f107
	ld b, $07
.asm_9f109
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f0e9
	jr .asm_9f0fd

.framesets
	dw OpenNorthGateCutsceneFrameset_bd348
	dw OpenNorthGateCutsceneFrameset_bd34b
	dw OpenNorthGateCutsceneFrameset_bd34e
	dw OpenNorthGateCutsceneFrameset_bd351
	dw OpenNorthGateCutsceneFrameset_bd354
	dw OpenNorthGateCutsceneFrameset_bd363
	dw OpenNorthGateCutsceneFrameset_bd372

UpdateCutsceneObjs_Rainstorm:
	ld bc, wSceneObj2State
.asm_9f121
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f137

.asm_9f131
	ld de, RainstormCutsceneOAM_bd377
	jp LoadCutsceneObjSprite_OWOAM2

.asm_9f137
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f121 ; ?? this will never happen
	jr .asm_9f131

.framesets
	dw RainstormCutsceneFrameset_bd43a
	dw RainstormCutsceneFrameset_bd43d
	dw RainstormCutsceneFrameset_bd44a

UpdateCutsceneObjs_RaiseTower:
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
	call .update_obj
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame5
	ld de, wSceneObj3
	jp DrawCutsceneOverlayFrame6

.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, RaiseTowerCutsceneOAM_bd453
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw RaiseTowerCutsceneFrameset_bd469
	dw RaiseTowerCutsceneFrameset_bd46c

UpdateCutsceneObjs_FixElevator:
	ld bc, wSceneObj4State
	call .update_obj
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
	call .update_obj
	ld bc, wSceneObj5State
;	fallthrough

.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $06
	jr z, .asm_9f1a8
	cp $08
	jr z, .asm_9f1ac
	cp $05
	call z, .PlayFixElevatorSFXAtAnimEnd
.asm_9f1a2
	ld de, FixElevatorCutsceneOAM_bd46f
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f1a8
	ld b, $07
	jr .asm_9f1ae
.asm_9f1ac
	ld b, $00
.asm_9f1ae
	call SetSceneObjStateWhenAnimFinished
	jr z, .update_obj
	jr .asm_9f1a2

.PlayFixElevatorSFXAtAnimEnd:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	play_sfx SFX_FIX_ELEVATOR
	ret

.framesets
	dw FixElevatorCutsceneFrameset_bd5c3
	dw FixElevatorCutsceneFrameset_bd5cc
	dw FixElevatorCutsceneFrameset_bd5d5
	dw FixElevatorCutsceneFrameset_bd5d8
	dw FixElevatorCutsceneFrameset_bd5dd
	dw FixElevatorCutsceneFrameset_bd5e6
	dw FixElevatorCutsceneFrameset_bd605
	dw FixElevatorCutsceneFrameset_bd608
	dw FixElevatorCutsceneFrameset_bd60f
	dw FixElevatorCutsceneFrameset_bd612

UpdateCutsceneObjs_RevealCastle:
	ld bc, wSceneObj2State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, RevealCastleCutsceneOAM_bd615
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw RevealCastleCutsceneFrameset_bd790
	dw RevealCastleCutsceneFrameset_bd793
	dw RevealCastleCutsceneFrameset_bd79c

UpdateCutsceneObjs_FreezeSea:
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame2
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame5
	ld bc, wSceneObj2State
	call .update_obj
	ld de, wSceneObj2
	jp DrawCutsceneOverlayFrame3

.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, FreezeSeaCutsceneOAM_bd7a1
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw FreezeSeaCutsceneFrameset_bd905
	dw FreezeSeaCutsceneFrameset_bd908
	dw FreezeSeaCutsceneFrameset_bd90b
	dw FreezeSeaCutsceneFrameset_bd90e

UpdateCutsceneObjs_SummonSun:
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, SummonSunCutsceneOAM_bd911
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw SummonSunCutsceneFrameset_bd96b
	dw SummonSunCutsceneFrameset_bd96e

UpdateCutsceneLevelObj_SummonSun:
	ld bc, wSceneObj5State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_ObjFramesets
	cp $02
	jr z, .asm_9f266
	cp $01
	jr z, .asm_9f27a
.asm_9f25b
	ld de, OwlOAM_188e16
	call _ObjOAM3
	ret

.framesets
	dw OwlFrameset_692e7
	dw OwlFrameset_69335

.asm_9f266
	call .PlayFlapSFXAtAnimEnd
	jr .asm_9f25b

.PlayFlapSFXAtAnimEnd:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	play_sfx SFX_FLAP
	ret

.asm_9f27a
	call .PlaySFX011OnFrame01
	jr .asm_9f25b

.PlaySFX011OnFrame01:
	ld d, h
	ld e, l
	set 1, e
	ld a, [de]
	ld c, a
	set 0, e
	set 2, e
	ld a, [de]
	and a
	ld a, $01
	jr nz, .asm_9f295
	cp c
	ret z
	ld a, $01
	ld [de], a
	ret
.asm_9f295
	cp c
	ret nz
	xor a
	ld [de], a
	play_sfx SFX_011
	ret

UpdateCutsceneObjs_ExplodeBombs:
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj4State
	call .update_obj
	ld bc, wSceneObj3State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, ExplodeBombsCutsceneOAM_bd971
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw ExplodeBombsCutsceneFrameset_bd9ec
	dw ExplodeBombsCutsceneFrameset_bd9f5
	dw ExplodeBombsCutsceneFrameset_bd9f8
	dw ExplodeBombsCutsceneFrameset_bd9fb
	dw ExplodeBombsCutsceneFrameset_bd9fe

UpdateCutsceneObjs_TreasureMap:
	ld bc, wSceneObj2State
.asm_9f2d0
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $01
	jr z, .asm_9f2e6
.asm_9f2e0
	ld de, TreasureMapCutsceneOAM_bda01
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f2e6
	ld b, $02
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f2d0
	jr .asm_9f2e0

.framesets
	dw TreasureMapCutsceneFrameset_bdaa2
	dw TreasureMapCutsceneFrameset_bdab9

UpdateCutsceneObjs_PlaceCartWheels:
	ld bc, wSceneObj2State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_ObjFramesets
	cp $03
	call z, .PlayCartRollSFXAtAnimEnd
	ld de, CartOAM_188279
	call _ObjOAM3
	ret

.PlayCartRollSFXAtAnimEnd:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	play_sfx SFX_CART_ROLL
	ret

.framesets
	dw CartFrameset_691a7
	dw PlaceCartWheelsCutsceneFrameset_691bc
	dw CartFrameset_691bf

UpdateCutsceneObjs_BlowMist:
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame5
	ld bc, wSceneObj2State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, BlowMistCutsceneOAM_bdabc
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw BlowMistCutsceneFrameset_bdb03

UpdateCutsceneObjs_SummonSnakes:
	ld bc, wSceneObj3State
	call .update_obj
	ld bc, wSceneObj4State
	call .update_obj
	ld bc, wSceneObj2State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, SummonSnakesCutsceneOAM_bdb06
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw SummonSnakesCutsceneFrameset_bdc5f
	dw SummonSnakesCutsceneFrameset_bdc62
	dw SummonSnakesCutsceneFrameset_bdc7f

UpdateCutsceneObjs_FootStone:
	ld de, wSceneObj3
	call DrawCutsceneOverlayFrame0
	ld bc, wSceneObj2State
	call .update_obj
	ld de, wSceneObj3
	jp DrawCutsceneOverlayFrame1

.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, FootStoneCutsceneOAM_bdc9c
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw FootStoneCutsceneFrameset_bdce3

UpdateCutsceneObjs_OpenSnakeDoor:
	ld bc, wSceneObj2State
	call .asm_9f3a2
	ld bc, wSceneObj3State
	call .asm_9f3a2
	ld bc, wSceneObj4State
	call .asm_9f3a2
	ld bc, wSceneObj5State
.asm_9f3a2
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $04
	jr z, .asm_9f3b8
.asm_9f3b2
	ld de, OpenSnakeDoorCutsceneOAM_bdce6
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f3b8
	ld b, $01
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f3a2
	jr .asm_9f3b2

.framesets
	dw OpenSnakeDoorCutsceneFrameset_bddcc
	dw OpenSnakeDoorCutsceneFrameset_bddc3
	dw OpenSnakeDoorCutsceneFrameset_bddc6
	dw OpenSnakeDoorCutsceneFrameset_bdda9
	dw OpenSnakeDoorCutsceneFrameset_bddc0
	dw OpenSnakeDoorCutsceneFrameset_bddc9

UpdateCutsceneObjs_ExpelTornado:
	ld bc, wSceneObj3State
	call .update_obj
	ld bc, wSceneObj2State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, ExpelTornadoCutsceneOAM_bddcf
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw ExpelTornadoCutsceneFrameset_bde60
	dw ExpelTornadoCutsceneFrameset_bde63
	dw ExpelTornadoCutsceneFrameset_bde66

UpdateCutsceneObjs_OpenTreeMouth:
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $03
	call z, .PlayTreeMouthOpenSFXAtAnimEnd
	ld de, OpenTreeMouthCutsceneOAM_bde69
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw OpenTreeMouthCutsceneFrameset_bdf92
	dw OpenTreeMouthCutsceneFrameset_bdf95
	dw OpenTreeMouthCutsceneFrameset_bdfa0

.PlayTreeMouthOpenSFXAtAnimEnd:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	play_sfx SFX_TREE_MOUTH_OPEN
	ret

UpdateCutsceneObjs_LeavesFall:
	ld bc, wSceneObj2State
	call .asm_9f42c
	ld bc, wSceneObj3State
.asm_9f42c
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f446
	cp $03
	jr z, .asm_9f47e
.asm_9f440
	ld de, LeavesFallCutsceneOAM_bdfa5
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f446
	call .PlayFatWalkSFXOnFrame07Or08
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f42c
	jr .asm_9f440

.framesets
	dw LeavesFallCutsceneFrameset_be1b0
	dw LeavesFallCutsceneFrameset_be1c3
	dw LeavesFallCutsceneFrameset_be1fc
	dw LeavesFallCutsceneFrameset_be203

.PlayFatWalkSFXOnFrame07Or08:
	ld a, [wSceneObj3Frame]
	ld c, a
	ld a, [wSceneObj3MovementStep]
	ld b, a
	and a
	jr z, .asm_9f46b
	ld a, $08
	cp c
	ret nz
	jr .asm_9f46f
.asm_9f46b
	ld a, $07
	cp c
	ret nz
.asm_9f46f
	ld a, b
	xor $1
	ld [wSceneObj3MovementStep], a
	play_sfx SFX_FAT_WALK
	ret
.asm_9f47e
	call .PlayThunderSFXEvery26Frames
	jr .asm_9f440

.PlayThunderSFXEvery26Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f493
	cp $1a
	ret c
	xor a
	ld [de], a
	ret
.asm_9f493
	play_sfx SFX_THUNDER
	ret

UpdateCutsceneObjs_MakeWire:
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
	call .update_obj
	ld bc, wSceneObj4State
	call .update_obj
	ld bc, wSceneObj5State

.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $01
	jr z, .asm_9f4d3
	cp $02
	jr z, .asm_9f4ec
.asm_9f4c5
	ld de, MakeWireCutsceneOAM_be206
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw MakeWireCutsceneFrameset_be2b9
	dw MakeWireCutsceneFrameset_be2c2
	dw MakeWireCutsceneFrameset_be2d3
	dw MakeWireCutsceneFrameset_be2d6

.asm_9f4d3
	call .PlaySFX133Every12Frames
	jr .asm_9f4c5

.PlaySFX133Every12Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $0c
	ret c
	xor a
	ld [de], a
	play_sfx SFX_133
	ret

.asm_9f4ec
	call .PlaySFX133Every12Frames
	call .PlaySFX132Every16Frames
	jr .asm_9f4c5

.PlaySFX132Every16Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $10
	ret c
	xor a
	ld [de], a
	play_sfx SFX_132
	ret

UpdateCutsceneObjs_TorchForest:
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame5
	ld bc, wSceneObj2State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $01
	jr z, .asm_9f529
.asm_9f521
	ld de, TorchForestCutsceneOAM_be2d9
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw TorchForestCutsceneFrameset_be3c5

.asm_9f529
	call .PlayFireSFXEvery14Frames
	jr .asm_9f521

.PlayFireSFXEvery14Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f53e
	cp $0e
	ret c
	xor a
	ld [de], a
	ret
.asm_9f53e
	play_sfx SFX_FIRE
	ret

UpdateCutsceneObjs_RevealWarpedVoid:
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame0
	ld bc, wSceneObj2State
	call .asm_9f559
	ld de, wSceneObj2
	jp DrawCutsceneOverlayFrame1

.asm_9f559
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f573
	cp $03
	jr z, .asm_9f582
.asm_9f56d
	ld de, RevealWarpedVoidCutsceneOAM_be3ce
	jp LoadCutsceneObjSprite_OWOAM2

.asm_9f573
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f559
	jr .asm_9f56d

.framesets
	dw RevealWarpedVoidCutsceneFrameset_be7e6
	dw RevealWarpedVoidCutsceneFrameset_be7e9
	dw RevealWarpedVoidCutsceneFrameset_be802

.asm_9f582
	call .PlayElectricShockSFXEvery16Frames
	jr .asm_9f56d

.PlayElectricShockSFXEvery16Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f597
	cp $10
	ret c
	xor a
	ld [de], a
	ret
.asm_9f597
	play_sfx SFX_ELECTRIC_SHOCK
	ret

UpdateCutsceneObjs_RaiseIceBlocks:
	ld bc, wSceneObj4State
	call .update_obj
	ld bc, wSceneObj6State
	call .update_obj
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
	call .update_obj
	ld bc, wSceneObj5State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f5d1
.asm_9f5cb
	ld de, RaiseIceBlocksCutsceneOAM_be807
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f5d1
	call .PlayPumpSFXOnFrame03
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .update_obj
	jr .asm_9f5cb

.framesets
	dw RaiseIceBlocksCutsceneFrameset_be8de
	dw RaiseIceBlocksCutsceneFrameset_be8e1
	dw RaiseIceBlocksCutsceneFrameset_be8ea
	dw RaiseIceBlocksCutsceneFrameset_be8ed

.PlayPumpSFXOnFrame03:
	ld a, [wSceneObj2Frame]
	ld c, a
	ld a, [wSceneObj2MovementStep]
	ld b, a
	and a
	ld a, $03
	jr z, .asm_9f5f6
	cp c
	ret z
	jr .asm_9f600
.asm_9f5f6
	cp c
	ret nz
	play_sfx SFX_PUMP
.asm_9f600
	ld a, b
	xor $1
	ld [wSceneObj2MovementStep], a
	ret

UpdateCutsceneObjs_RaisePipe:
	ld bc, wSceneObj2State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f624
.asm_9f61a
	ld de, RaisePipeCutsceneOAM_be8fe
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw RaisePipeCutsceneFrameset_be9fa
	dw RaisePipeCutsceneFrameset_be9fd

.asm_9f624
	call .PlayMuddeeSwimSFXAtAnimEnd
	jr .asm_9f61a

.PlayMuddeeSwimSFXAtAnimEnd:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	play_sfx SFX_MUDDEE_SWIM
	ret

UpdateCutsceneObjs_RemoveWarps:
	ld bc, wSceneObj2State
	call .asm_9f659
	ld bc, wSceneObj3State
	call .asm_9f659
	ld bc, wSceneObj4State
	call .asm_9f659
	ld bc, wSceneObj5State
	call .asm_9f659
	ld bc, wSceneObj6State
	call .asm_9f659
	ld bc, wSceneObj7State
.asm_9f659
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $04
	jr z, .asm_9f673
	cp $02
	jr z, .asm_9f684
.asm_9f66d
	ld de, RemoveWarpsCutsceneOAM_bea06
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f673
	ld b, $00
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f659
	jr .asm_9f66d

.framesets
	dw RemoveWarpsCutsceneFrameset_beacc
	dw RemoveWarpsCutsceneFrameset_beacf
	dw RemoveWarpsCutsceneFrameset_beae4
	dw RemoveWarpsCutsceneFrameset_beaed

.asm_9f684
	call .PlaySFX10EEvery72Frames
	jr .asm_9f66d

.PlaySFX10EEvery72Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f699
	cp $48
	ret c
	xor a
	ld [de], a
	ret
.asm_9f699
	play_sfx SFX_10E
	ret

UpdateCutsceneObjs_CollectDemonsBlood:
	ld bc, wSceneObj4State
	call .asm_9f6b1
	ld bc, wSceneObj2State
	call .asm_9f6b1
	ld bc, wSceneObj3State
.asm_9f6b1
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f6cf
	cp $05
	jr z, .asm_9f6dd
	cp $06
	jr z, .asm_9f6e1
.asm_9f6c9
	ld de, CollectDemonsBloodCutsceneOAM_beafc
	jp LoadCutsceneObjSprite_OWOAM2

.asm_9f6cf
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr nz, .asm_9f6c9
	ld a, $04
	ld [wSceneObj3State], a
	jr .asm_9f6b1
.asm_9f6dd
	ld b, $00
	jr .asm_9f6e3
.asm_9f6e1
	ld b, $07
.asm_9f6e3
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f6b1
	jr .asm_9f6c9

.framesets
	dw CollectDemonsBloodCutsceneFrameset_bebda
	dw CollectDemonsBloodCutsceneFrameset_bebcc
	dw CollectDemonsBloodCutsceneFrameset_bebdd
	dw CollectDemonsBloodCutsceneFrameset_bebe0
	dw CollectDemonsBloodCutsceneFrameset_bebd3
	dw CollectDemonsBloodCutsceneFrameset_bebe3
	dw CollectDemonsBloodCutsceneFrameset_bebec

UpdateCutsceneObjs_PlacePropeller:
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
.update_obj:
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f71d
.asm_9f711
	ld de, PlacePropellerCutsceneOAM_bebef
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw PlacePropellerCutsceneFrameset_becc7
	dw PlacePropellerCutsceneFrameset_becca
	dw PlacePropellerCutsceneFrameset_becd3

.asm_9f71d
	call .PlayFanSpinSFXEvery12Frames
	jr .asm_9f711

.PlayFanSpinSFXEvery12Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f732
	cp $0c
	ret c
	xor a
	ld [de], a
	ret
.asm_9f732
	play_sfx SFX_FAN_SPIN
	ret

UpdateCutsceneObjs_CutBaloon:
	ld bc, wSceneObj2State
	call .asm_9f744
	ld bc, wSceneObj3State
.asm_9f744
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, CutBaloonCutsceneOAM_becdc
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw CutBaloonCutsceneFrameset_bed39
	dw CutBaloonCutsceneFrameset_bed3c
	dw CutBaloonCutsceneFrameset_bed3f

UpdateCutsceneObjs_OpenParaGoomCage:
	ld bc, wSceneObj2State
	call .asm_9f765
	ld bc, wSceneObj4State
.asm_9f765
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f783
	cp $04
	jr z, .asm_9f787
	cp $06
	jr z, .asm_9f78b
.asm_9f77d
	ld de, OpenParaGoomCageCutsceneOAM_bed42
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f783
	ld b, $00
	jr .asm_9f78d
.asm_9f787
	ld b, $00
	jr .asm_9f78d
.asm_9f78b
	ld b, $07
.asm_9f78d
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f765
	jr .asm_9f77d

.framesets
	dw OpenParaGoomCageCutsceneFrameset_bee4d
	dw OpenParaGoomCageCutsceneFrameset_bee50
	dw OpenParaGoomCageCutsceneFrameset_bee55
	dw OpenParaGoomCageCutsceneFrameset_bee58
	dw OpenParaGoomCageCutsceneFrameset_bee5d
	dw OpenParaGoomCageCutsceneFrameset_bee60
	dw OpenParaGoomCageCutsceneFrameset_bee6b

UpdateCutsceneLevelObj_OpenParaGoomCage:
	ld bc, wSceneObj3State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_ObjFramesets
	ld de, ParaGoomOAM_180b43
	jp _ObjOAM1

.framesets
	dw ParaGoomFrameset_68439
	dw ParaGoomFrameset_684ba

UpdateCutsceneObjs_OpenSkyDoor:
	ld bc, wSceneObj2State
	call .asm_9f7c4
	ld bc, wSceneObj3State
.asm_9f7c4
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, OpenSkyDoorCutsceneOAM_bee6e
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw OpenSkyDoorCutsceneFrameset_befbe
	dw OpenSkyDoorCutsceneFrameset_befc1
	dw OpenSkyDoorCutsceneFrameset_befc4

UpdateCutsceneObjs_ExtinguishFire:
	ld bc, wSceneObj2State
.asm_9f7df
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f7f9
	cp $03
	jr z, .asm_9f808
.asm_9f7f3
	ld de, ExtinguishFireCutsceneOAM_befd5
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f7f9
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f7df
	jr .asm_9f7f3

.framesets
	dw ExtinguishFireCutsceneFrameset_bf100
	dw ExtinguishFireCutsceneFrameset_bf103
	dw ExtinguishFireCutsceneFrameset_bf110

.asm_9f808
	call .PlayThunderSFXEvery26Frames
	jr .asm_9f7f3

.PlayThunderSFXEvery26Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $1a
	ret c
	xor a
	ld [de], a
	play_sfx SFX_THUNDER
	ret

UpdateCutsceneLevelObj_ExtinguishFire:
	ld bc, wSceneObj3State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_ObjFramesets
	cp $01
	jr z, .asm_9f83e
.asm_9f834
	ld de, FireOAM_18aba0
	jp _ObjOAM3

.framesets
	dw FireFrameset_69c0a
	dw ExtinguishFireCutsceneFrameset_69c13

.asm_9f83e
	call .PlayFireSFXEvery14Frames
	jr .asm_9f834

.PlayFireSFXEvery14Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $0e
	ret c
	xor a
	ld [de], a
	play_sfx SFX_FIRE
	ret

UpdateCutsceneObjs_PlaceBrick:
	ld hl, wSceneObj2State
	ld a, [hld]
	and a
	ret z
	dec l
	ld de, PlaceBrickCutsceneFrameset_bf154
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, PlaceBrickCutsceneOAM_bf131
	jp LoadCutsceneObjSprite_OWOAM2

UpdateCutsceneObjs_SprayIronWall:
	ld bc, wSceneObj2State
	call .asm_9f873
	ld bc, wSceneObj3State
.asm_9f873
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f8a3
	cp $03
	jr z, .asm_9f88d
.asm_9f887
	ld de, SprayIronWallCutsceneOAM_bf157
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f88d
	call .PlaySFX0C4Every10Frames
	ld b, $05
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f873
	jr .asm_9f887

.framesets
	dw SprayIronWallCutsceneFrameset_bf28c
	dw SprayIronWallCutsceneFrameset_bf28f
	dw SprayIronWallCutsceneFrameset_bf298
	dw SprayIronWallCutsceneFrameset_bf2a5
	dw SprayIronWallCutsceneFrameset_bf2a8

.asm_9f8a3
	call .PlayThunderSFXEvery26Frames
	jr .asm_9f887

.PlayThunderSFXEvery26Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f8b8
	cp $1a
	ret c
	xor a
	ld [de], a
	ret
.asm_9f8b8
	play_sfx SFX_THUNDER
	ret

.PlaySFX0C4Every10Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $01
	jr z, .asm_9f8d1
	cp $0a
	ret c
	xor a
	ld [de], a
	ret
.asm_9f8d1
	play_sfx SFX_0C4
	ret

UpdateCutsceneObjs_MixChemicals:
	ld bc, wSceneObj2State
	call .asm_9f8e3
	ld bc, wSceneObj3State
.asm_9f8e3
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $03
	jr z, .asm_9f8f9
	.asm_9f8f3
	ld de, MixChemicalsCutsceneOAM_bf2ab
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f8f9
	ld b, $00
	call .set_state_when_anim_finished
	ld hl, wSceneObj2MovementStep
	ld a, [hl]
	and a
	ret nz
	ld a, [wSceneObj2Frame]
	cp $07
	ret nz
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a
	ld [hl], $01
	ret

.set_state_when_anim_finished:
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f8e3
	jr .asm_9f8f3

.framesets
	dw MixChemicalsCutsceneFrameset_bf43b
	dw MixChemicalsCutsceneFrameset_bf45d
	dw MixChemicalsCutsceneFrameset_bf43e

UpdateCutsceneObjs_RevealDarkRoom:
	ld bc, wSceneObj2State
.asm_9f922
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $01
	jr z, .asm_9f93c
	cp $02
	jr z, .asm_9f943
.asm_9f936
	ld de, RevealDarkRoomCutsceneOAM_bf460
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f93c
	call .PlaySFXOnFrames
	ld b, $02
	jr .asm_9f948
.asm_9f943
	call .PlaySFXOnFrames
	ld b, $01
.asm_9f948
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f922
	jr .asm_9f936

.framesets
	dw RevealDarkRoomCutsceneFrameset_bf5e0
	dw RevealDarkRoomCutsceneFrameset_bf5e0

.PlaySFXOnFrames:
	ld a, [wSceneObj2Frame]
	ld c, a
	ld a, [wSceneObj2MovementStep]
	ld b, a
	and a
	jr z, .asm_9f96a
	ld a, c
	cp $02
	ret z
	cp $04
	ret z
	cp $05
	ret z
	jr .asm_9f98a
.asm_9f96a
	ld a, c
	cp $02
	jr z, .asm_9f978
	cp $04
	jr z, .asm_9f982
	cp $05
	jr z, .asm_9f982
	ret nz
.asm_9f978
	play_sfx SFX_011
	jr .asm_9f98a
.asm_9f982
	play_sfx SFX_0F1
.asm_9f98a
	ld a, b
	xor $01
	ld [wSceneObj2MovementStep], a
	ret

UpdateCutsceneObjs_SummonMoon:
	ld bc, wSceneObj2State
	call .asm_9f99a
	ld bc, wSceneObj3State
.asm_9f99a
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $04
	jr z, .asm_9f9b0
.asm_9f9aa
	ld de, SummonMoonCutsceneOAM_bf611
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f9b0
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f99a
	jr .asm_9f9aa

.framesets
	dw SummonMoonCutsceneFrameset_bf65d
	dw SummonMoonCutsceneFrameset_bf660
	dw SummonMoonCutsceneFrameset_bf665
	dw SummonMoonCutsceneFrameset_bf668

UpdateCutsceneObjs_OpenCraterHole:
	ld bc, wSceneObj11State
	call .asm_9f9d0
	ld bc, wSceneObj10State
	call .asm_9f9d0
	ld bc, wSceneObj2State
.asm_9f9d0
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9f9e6
.asm_9f9e0
	ld de, OpenCraterHoleCutsceneOAM_bf66d
	jp LoadCutsceneObjSprite_OWOAM2
.asm_9f9e6
	ld b, $01
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9f9d0
	jr .asm_9f9e0

.framesets
	dw OpenCraterHoleCutsceneFrameset_bf6df
	dw OpenCraterHoleCutsceneFrameset_bf6e2
	dw OpenCraterHoleCutsceneFrameset_bf6ed

UpdateCutsceneLevelObj_OpenCraterHole:
	ld bc, wSceneObj3State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_ObjFramesets
	cp $01
	jr z, .asm_9fa16
	cp $02
	jr z, .asm_9fa2f
.asm_9fa0c
	ld de, WallCrackOAM_18c806
	jp _ObjOAM4

.framesets
	dw WallCrackFrameset_6a052
	dw WallCrackFrameset_6a05f

.asm_9fa16
	call .PlaySFX135Every27Frames
	jr .asm_9fa0c

.PlaySFX135Every27Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $1b
	ret c
	xor a
	ld [de], a
	play_sfx SFX_135
	ret
.asm_9fa2f
	call .PlayFallingSnowDropSFXEvery27Frames
	jr .asm_9fa0c

.PlayFallingSnowDropSFXEvery27Frames:
	ld de, wSceneObj3MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $1b
	ret c
	xor a
	ld [de], a
	play_sfx SFX_FALLING_SNOW_DROP
	ret

UpdateCutsceneObjs_DrillHoles:
	ld bc, wSceneObj10State
	call .asm_9fa7b
	ld bc, wSceneObj11State
	call .asm_9fa7b
	ld bc, wSceneObj2State
	call .asm_9fa7b
	ld bc, wSceneObj3State
	call .asm_9fa7b
	ld bc, wSceneObj4State
	call .asm_9fa7b
	ld bc, wSceneObj5State
	call .asm_9fa7b
	ld bc, wSceneObj6State
	call .asm_9fa7b
	ld bc, wSceneObj7State
	call .asm_9fa7b
	ld bc, wSceneObj8State
.asm_9fa7b
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $02
	jr z, .asm_9fa9b
.asm_9fa8b
	ld de, DrillHolesCutsceneOAM_bf6f0
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw DrillHolesCutsceneFrameset_bf826
	dw DrillHolesCutsceneFrameset_bf829
	dw DrillHolesCutsceneFrameset_bf832
	dw DrillHolesCutsceneFrameset_bf835
	dw DrillHolesCutsceneFrameset_bf83e

.asm_9fa9b
	call .PlayPlane1SFXEvery12Frames
	jr .asm_9fa8b

.PlayPlane1SFXEvery12Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $0c
	ret c
	xor a
	ld [de], a
	play_sfx SFX_PLANE1
	ret

UpdateCutsceneObjs_FeedOctohon:
	ld bc, wSceneObj2State
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	cp $01
	jr z, .asm_9fad1
.asm_9fac7
	ld de, FeedOctohonCutsceneOAM_bf847
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw FeedOctohonCutsceneFrameset_bf923
	dw FeedOctohonCutsceneFrameset_bf92a

.asm_9fad1
	call .PlaySparkleSFXEvery48Frames
	jr .asm_9fac7

.PlaySparkleSFXEvery48Frames:
	ld de, wSceneObj2MovementStep
	ld a, [de]
	inc a
	ld [de], a
	cp $30
	ret c
	xor a
	ld [de], a
	play_sfx SFX_SPARKLE
	ret

UpdateCutsceneLevelObj_FeedOctohon:
	ld bc, wSceneObj3State
.asm_9faed
	ld a, [bc]
	and a
	ret z
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_ObjFramesets
	cp $01
	jr z, .asm_9fb1a
	cp $03
	jr z, .asm_9fb33
	cp $02
	jr z, .asm_9fb0b
.asm_9fb05
	ld de, OctohonOAM_18a895
	jp _ObjOAM3
.asm_9fb0b
	ld b, $03
	call SetSceneObjStateWhenAnimFinished
	jr z, .asm_9faed
	jr .asm_9fb05

.framesets
	dw OctohonFrameset_69b38
	dw FeedOctohonCutsceneFrameset_69ba0
	dw OctohonFrameset_69b60

.asm_9fb1a
	call .PlaySFX08FEvery40Frames
	jr .asm_9fb05

.PlaySFX08FEvery40Frames:
	ld de, wSceneObj4YCoord
	ld a, [de]
	inc a
	ld [de], a
	cp $28
	ret c
	xor a
	ld [de], a
	play_sfx SFX_08F
	ret

.asm_9fb33
	call .PlaySmallSplashSFXEvery40Frames
	jr .asm_9fb05

.PlaySmallSplashSFXEvery40Frames:
	ld de, wSceneObj4YCoord
	ld a, [de]
	inc a
	ld [de], a
	cp $28
	ret c
	xor a
	ld [de], a
	play_sfx SFX_SMALL_SPLASH
	ret

DrawCutsceneOverlayFrame0:
	ld c, $00
	ld hl, wCurSceneObj
	ld b, $01
;	fallthrough

; b = wCutsceneOverlayType to draw for
; c = frame
DrawCutsceneOverlay:
	ld a, [wCutsceneOverlayType]
	cp b
	ret nz
	ld a, [de]
	ld [hli], a ; y
	inc e
	ld a, [de]
	ld [hli], a ; x
	ld a, c
	ld [hli], a ; frame
	xor a
	ld [hl], a ; attributes
;	fallthrough

LoadCutsceneOverlaySprite:
	ld de, CutsceneOverlayOAM_bc000
	ld a, $fc
	and l
	ld l, a
	call LoadCutsceneObjSprite_OWOAM2
	ret

DrawCutsceneOverlayFrame1:
	ld c, $01
	ld hl, wCurSceneObjDuration
	ld b, $01
	jr DrawCutsceneOverlay

DrawCutsceneOverlayFrame2:
	ld c, 2
	ld hl, wCurSceneObjDuration
	ld b, $01
	jr DrawCutsceneOverlay

DrawCutsceneOverlayFrame3:
	ld c, 3
	ld hl, wCurSceneObjDuration
	ld b, $01
	jr DrawCutsceneOverlay

DrawCutsceneOverlayFrame4:
	ld a, [wCutsceneOverlayType]
	cp $02
	ret nz
	ld hl, wCurSceneObjFrame
	ld a, $04
	ld [hli], a
	xor a
	ld [hl], a
	jr LoadCutsceneOverlaySprite

; de = scene obj
DrawCutsceneOverlayFrame5:
	ld hl, wCurSceneObj
	ld c, 5
	ld b, $03
	jr DrawCutsceneOverlay

; de = scene obj
DrawCutsceneOverlayFrame6:
	ld hl, wCurSceneObjDuration
	ld c, 6
	ld b, $03
	jr DrawCutsceneOverlay

UpdateCutsceneObjs_VolcanoEruption:
	call DrawCutsceneOverlayFrame4
	ld bc, wSceneObj4State
	call .update_obj
	ld bc, wSceneObj2State
	call .update_obj
	ld bc, wSceneObj3State
	call .update_obj
	ld bc, wSceneObj5State
	call .update_obj
	ret

.update_obj:
	ld a, [bc]
	and a
	ret z
	cp $05
	jr z, .asm_9fbdc
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
.asm_9fbd5
	ld de, SharedCutsceneOAM_bcfb3
	call LoadCutsceneObjSprite_OWOAM2
	ret
.asm_9fbdc
	ld hl, .framesets
	call GetCutsceneObjFrameset
	call UpdateCutsceneObjAnim_OWOAM2
	ld b, $06
	call SetSceneObjStateWhenAnimFinished
	jr z, .update_obj
	jr .asm_9fbd5

.framesets
	dw VolcanoEruptionCutsceneFrameset_bd1b7
	dw VolcanoEruptionCutsceneFrameset_bd1ba
	dw VolcanoEruptionCutsceneFrameset_bd1bd
	dw VolcanoEruptionCutsceneFrameset_bd1c0
	dw VolcanoEruptionCutsceneFrameset_bd1c5
	dw VolcanoEruptionCutsceneFrameset_bd1f8

UpdateCutsceneObjs_PlantSeeds:
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame0
	call .update_obj2
	ld de, wSceneObj2
	jp DrawCutsceneOverlayFrame1

.update_obj2:
	ld a, [wSceneObj2State]
	and a
	ret z
	ld de, PlantSeedsCutsceneFrameset_bd1b4
	ld hl, wSceneObj2Duration
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, SharedCutsceneOAM_bcfb3
	jp LoadCutsceneObjSprite_OWOAM2

UpdateCutsceneObjs_MusicBox:
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame0
	call .update_obj2
	ld de, wSceneObj2
	jp DrawCutsceneOverlayFrame1

.update_obj2:
	ld a, [wSceneObj2State]
	and a
	ret z
	dec a
	ld hl, .framesets
	call GetPointerFromTableDE
	ld hl, wSceneObj2Duration
	call UpdateCutsceneObjAnim_OWOAM2
	ld de, MusicBoxCutsceneOAM_bc1f6
	jp LoadCutsceneObjSprite_OWOAM2

.framesets
	dw MusicBoxCutsceneFrameset_bcf15
	dw MusicBoxCutsceneFrameset_bcf18
	dw MusicBoxCutsceneFrameset_bcf21
	dw MusicBoxCutsceneFrameset_bcf24
	dw MusicBoxCutsceneFrameset_bcf35
	dw MusicBoxCutsceneFrameset_bcf38
	dw MusicBoxCutsceneFrameset_bcf49
	dw MusicBoxCutsceneFrameset_bcf4c
	dw MusicBoxCutsceneFrameset_bcf6d
	dw MusicBoxCutsceneFrameset_bcf70

UpdateCutsceneObjs_CutTree:
.start
	ld de, wSceneObj2
	call DrawCutsceneOverlayFrame5
	ld hl, wSceneObj2State
	ld a, [hld]
	and a
	ret z
	dec l
	ld b, BANK("Overworld OAM 2")
	dec a
	jr z, .one
	dec a
	jr z, .two
	; invalid value
	debug_nop
.one
	ld de, CutTreeCutsceneFrameset_bc1f3
	call UpdateOWAnimation
	jr .asm_9fc85
.two
	ld de, CutTreeCutsceneFrameset_bc1e8
	call UpdateOWAnimation
	ld b, $00
	call SetSceneObjStateWhenAnimFinished
	jr z, .start
.asm_9fc85
	ld de, CutTreeCutsceneOAM_bc122
	jp LoadCutsceneObjSprite_OWOAM2

RevealCastleCutscenePal2_1:
	rgb  6,  7, 16
	rgb  2,  5, 17
	rgb  0,  4, 14
	rgb  0,  0, 11

RevealCastleCutscenePal2_2:
	rgb 12, 15, 22
	rgb  4,  9, 21
	rgb  0,  5, 18
	rgb  0,  0, 11

RevealCastleCutscenePal2_3:
	rgb 16, 21, 26
	rgb  6, 15, 27
	rgb  0,  6, 21
	rgb  0,  0, 11

RevealCastleCutscenePal2_4:
	rgb 21, 28, 31
	rgb  8, 19, 31
	rgb  0,  7, 23
	rgb  0,  0, 11

	ds $355, $00
