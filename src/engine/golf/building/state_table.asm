_GolfBuildingStateTable::
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitGolfCourseMenu
	dw SlowFadeFromWhite
	dw UpdateGolfCourseMenu
	dw SlowFadeToWhite ; SST_GOLF_BUILDING_HOLE
	dw InitGolfHole
	dw SlowFadeFromWhite
	dw HandleGolfHole
	dw ReturnToMap ; SST_GOLF_BUILDING_EXIT
