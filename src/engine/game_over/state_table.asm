_GameOverStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitGameOverScreen
	dw SlowFadeFromWhite
	dw UpdateGameOverScreen
	dw WaitGameOverWarioAnim
	dw SlowFadeToWhite
	dw GameOverReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
