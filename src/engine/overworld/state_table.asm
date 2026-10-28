OverworldStateTable::
	ld a, [wSubState]
	jumptable

	dw FastFadeToWhite
	dw InitOverworld
	dw SlowFadeFromWhite
	dw Func_804ec
	dw FastFadeToWhite

	dw InitOWScene          ; SST_OVERWORLD_OW_SCENE
	dw SlowFadeFromWhite
	dw Func_80540

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_MAP_SIDE
	dw InitMapSide          ; SST_OVERWORLD_INIT_MAP_SIDE
	dw DarkenBGToPal_Normal
	dw Func_805d7           ; SST_OVERWORLD_UPDATE_MAP_SIDE

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_COLLECTION
	dw InitTreasureCollection
	dw DarkenBGToPal_Normal
	dw TreasureCollection
	dw FadeBGToWhite_Normal

	dw InitCutscene           ; SST_OVERWORLD_CUTSCENE
	dw DarkenBGToPal_Normal
	dw UpdateCutscene
	dw FadeBGToWhite_Normal
	dw Func_80db1

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_BEST_TIMES
	dw InitBestTimeList
	dw DarkenBGToPal_Normal
	dw BestTimeList

	dw FadeBGToWhite_Normal ; SST_OVERWORLD_TEMPLE
	dw InitTempleScene
	dw DarkenBGToPal_Normal
	dw UpdateTempleScene
	dw Func_80e33

	dw FadeBGToWhite_Normal
	dw GolfBuilding           ; SST_OVERWORLD_GOLF_BUILDING
	dw DarkenBGToPal_Normal
	dw Func_80e55

	dw FastFadeToWhite ; SST_OVERWORLD_EPILOGUE
	dw InitEpilogue
	dw SlowFadeFromWhite
	dw Func_80e75
	dw Func_80e85
