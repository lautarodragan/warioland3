OverworldStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitOverworld
	dw SlowFadeFromWhite
	dw OverworldWaitAPress
	dw SlowFadeToWhite

	dw InitOWScene          ; SST_OVERWORLD_OW_SCENE
	dw SlowFadeFromWhite
	dw UpdateOWScene

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_MAP_SIDE
	dw InitMapSide          ; SST_OVERWORLD_INIT_MAP_SIDE
	dw DarkenBGToPal_Normal
	dw UpdateMapSide           ; SST_OVERWORLD_UPDATE_MAP_SIDE

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_COLLECTION
	dw InitTreasureCollection
	dw DarkenBGToPal_Normal
	dw TreasureCollection
	dw FadeBGToWhite_Normal

	dw InitCutscene           ; SST_OVERWORLD_CUTSCENE
	dw DarkenBGToPal_Normal
	dw UpdateCutscene
	dw FadeBGToWhite_Normal
	dw ReturnFromCutscene

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_BEST_TIMES
	dw InitBestTimeList
	dw DarkenBGToPal_Normal
	dw BestTimeList

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_TEMPLE
	dw InitTempleScene
	dw DarkenBGToPal_Normal
	dw UpdateTempleScene
	dw EnterGolfBuildingUnlessB

	dw FadeBGToWhite_Normal
	dw GolfBuilding           ; SST_OVERWORLD_GOLF_BUILDING
	dw DarkenBGToPal_Normal
	dw UpdateGolfBuilding

	dw SlowFadeToWhite ; SST_OVERWORLD_EPILOGUE
	dw InitEpilogue
	dw SlowFadeFromWhite
	dw UpdateEpilogue
	dw SaveGameAfterEpilogue
