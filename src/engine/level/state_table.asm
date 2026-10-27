_LevelStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitLevel
	dw SlowFadeFromWhite ; SST_LEVEL_FADE_IN
	dw UpdateLevel
	dw DoorTransition
	dw SlowFadeToWhite
	dw StartRoom_FromTransition

	dw ProcessMultiBlock ; SST_LEVEL_MULTI_BLOCK

	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
