_GolfBuildingStateTable::
	ld a, [wSubState]
	jumptable

	dw FastFadeToWhite
	dw InitGolfCourseMenu
	dw SlowFadeFromWhite
	dw UpdateGolfCourseMenu
	dw FastFadeToWhite
	dw InitGolfHole
	dw SlowFadeFromWhite
	dw HandleGolfHole
	dw ReturnToMap
