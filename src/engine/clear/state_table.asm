_ClearScreenStateTable::
	ld a, [wSubState]
	jumptable

	dw FastFadeToWhite
	dw InitClearScreen
	dw SlowFadeFromWhite
	dw UpdateClearScreen

	dw SlowFadeBGToWhite ; SST_CLEAR_TIME_ATTACK
	dw InitTimeAttackClearScreen
	dw DarkenBGToPal_Fast
	dw UpdateTimeAttackClearScreen

	dw SlowFadeBGToWhite ; SST_CLEAR_MUSICAL_COINS
	dw InitMusicalCoinScreen
	dw DarkenBGToPal_Fast
	dw MusicalCoinScreen_CountCoins
	dw MusicalCoinScreen_MovePencil
	dw MusicalCoinScreen_ColourLevel
	dw ExitClearScreen ; SST_CLEAR_EXIT
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
