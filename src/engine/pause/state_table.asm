_PauseMenuStateTable::
	ld a, [wSubState]
	jumptable

	dw FastFadeBGToWhite
	dw InitPauseMenu
	dw DarkenBGToPal_Fast
	dw UpdatePauseMenu

	dw FastFadeBGToWhite
	dw ExitPauseMenu
	dw DarkenBGToPal_Fast
	dw ReturnToPendingLevelState

	dw FastFadeBGToWhite ; SST_PAUSE_MENU_SAVE
	dw InitSaveScreen
	dw DarkenBGToPal_Fast
	dw FillSaveScreenBar
	dw FastFadeBGToWhite
	dw SaveLevel
	dw DarkenBGToPal_Fast
	dw HandleSaveCompleteBox
	dw ResetAfterPauseMenuSave

	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset

	dw FastFadeBGToWhite ; SST_PAUSE_SAVE_AND_CONTINUE
	dw InitSaveScreenAndBackupVRAM
	dw DarkenBGToPal_Fast
	dw FillSaveScreenBar
	dw FastFadeBGToWhite
	dw Save
	dw DarkenBGToPal_Fast
	dw HandleSaveCompleteBox
	dw FastFadeBGToWhite
	dw TransitionAfterSave

	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset

	dw FastFadeBGToWhite
	dw InitSaveScreenAndBackupVRAM
	dw DarkenBGToPal_Fast
	dw FillSaveScreenBar
	dw FastFadeBGToWhite
	dw Save
	dw DarkenBGToPal_Fast
	dw HandleSaveCompleteBox
	dw FastFadeBGToWhite
	dw ResetAfterSave

	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
