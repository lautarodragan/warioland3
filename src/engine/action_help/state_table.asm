_ActionHelpStateTable::
	ld a, [wSubState]
	jumptable

	dw FastFadeBGToWhite
	dw InitActionHelp
	dw DarkenBGToPal_Fast
	dw UpdateActionHelp
	dw FastFadeBGToWhite
	dw ReturnToPauseMenuFromActionHelp
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
