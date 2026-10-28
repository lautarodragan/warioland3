_CreditsStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitCredits
	dw SlowFadeFromWhite
	dw ShowCredits
	dw Credits_MoveMusicBox
	dw Credits_ShowCloseUp
	dw Credits_LoadFinalPals
	dw Credits_FadeIn
	dw Credits_WaitEnd
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
