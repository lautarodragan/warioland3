GBIncompatibleStateTable::
	ld a, [wSubState]
	jumptable

	dw  SlowFadeToWhite
	dw  GBIncompatible
	dw  SlowFadeFromWhite
	dw  ExitGBIncompatible

	dw  DebugReset
	dw  DebugReset
	dw  DebugReset
	dw  DebugReset
