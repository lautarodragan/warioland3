_PerfectStateTable::
	ld a, [wSubState]
	jumptable

	dw FastFadeBGToWhite
	dw InitPerfectScreen
	dw DarkenBGToPal_Fast
	dw UpdatePerfectScreen ; SST_PERFECT_UPDATE
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
