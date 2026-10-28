WaterDropFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $04
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld a, $ff
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	jp .reset_drop

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .default
	cp $5a
	jr z, .splash
	cp $5b
	jr z, .return_to_start
.set_splash
	ld a, $5a
	ld [hl], a
	ld de, WaterDropFrameset_69775
	call SetObjectFramesetPtr
	ld a, $18
	ld [hli], a
	play_sfx SFX_WATER_DROP
.splash
	ld a, $81
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld l, OBJ_FLAGS
	set OBJFLAG_INVISIBLE_F, [hl]
	ld a, $5b
	ld [wCurObjState], a
	ld a, $3c
	ld [wCurObjStateDuration], a
.return_to_start
	ld a, $81
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	ld e, a
	and a
	jr z, .move_back_up
	dec [hl]
.move_back_up
	inc l
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld l, OBJ_Y_POS
	ld a, [hli]
	cp c
	jp nz, MoveObjectUp
	ld a, [hl]
	cp b
	jp nz, MoveObjectUp
	ld a, e
	and a
	ret nz
.reset_drop
	ld de, WaterDropFrameset_69761
	call SetObjectFramesetPtr
	ld a, $41
	ld [hli], a
	ld a, [wCurObjYPos + 0]
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	ld [hli], a
	xor a
	ld [hli], a
	inc l
	ld [hl], a
	ld l, OBJ_FLAGS
	res OBJFLAG_INVISIBLE_F, [hl]
	ret

.default
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .fall
	dec [hl]
	ret nz
	ld de, WaterDropFrameset_69772
	jp SetObjectFramesetPtr

.fall
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .landed
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .landed
	ld bc, FallingYVel_Light
	jp ApplyObjYMovement

.landed
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_STATE
	jp .set_splash
