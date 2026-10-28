WaterSparkFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld de, WaterSparkFrameset_69b1e
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $fd
	ld [hl], a
	ret

.Idle:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	ret z
	xor a
	ld [hl], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Spark)
	ld [hld], a
	ld a, LOW(.Spark)
	ld [hld], a
	ld de, WaterSparkFrameset_69b12
	call SetObjectFramesetPtr
	ld a, 100
	ld [hli], a
	ret

.Spark:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld de, WaterSparkFrameset_69b1e
	jp SetObjectFramesetPtr
