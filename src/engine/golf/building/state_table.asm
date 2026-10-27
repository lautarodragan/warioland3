_GolfBuildingStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitGolfCourseMenu
	dw SlowFadeFromWhite
	dw UpdateGolfCourseMenu
	dw SlowFadeToWhite
	dw InitGolfHole
	dw SlowFadeFromWhite
	dw HandleGolfHole
	dw ReturnToMap
