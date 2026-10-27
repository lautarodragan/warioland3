_GolfStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitGolfLobby
	dw SlowFadeFromWhite
	dw HandleGolfLobby

	dw SlowFadeToWhite ; SST_GOLF_HOLE
	dw InitGolfHole
	dw SlowFadeFromWhite
	dw HandleGolfHole

	dw SlowFadeToWhite ; SST_GOLF_EXIT
	dw ReturnToLevelFromGolf

	dw SlowFadeToWhite ; SST_GOLF_CLEAR
	dw InitGolfClearCutscene
	dw SlowFadeFromWhite
	dw UpdateGolfClearCutscene
