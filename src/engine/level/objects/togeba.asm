TogebaFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0b
	ld [hld], a
	ld a, $f4
	ld [hld], a
.SetUpright:
	ld de, TogebaFrameset_69230
	call SetObjectFramesetPtr
	xor a
	ld [hl], a
	ld [wCurObjState], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Upright)
	ld [hld], a
	ld a, LOW(.Upright)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FULL_STING
	ld [hld], a
	ret

.Upright:
	ld a, [wGroundShakeCounter]
	cp $10
	jr nc, .start_flip_over
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr nz, .count_down
	ld l, OBJ_STATE
	ld a, [hl]
	and a
	ret z
	xor a
	ld [hl], a
	ld de, TogebaFrameset_6924b
	call SetObjectFramesetPtr
	ld a, $16
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret

.count_down
	dec [hl]
	ret nz
	ld de, TogebaFrameset_69230
	call SetObjectFramesetPtr
	ret

.start_flip_over
	ld hl, wCurObjUpdateFunction + 1
	ld a, $4e
	ld [hld], a
	ld a, $02
	ld [hld], a
	ld de, TogebaFrameset_69256
	call SetObjectFramesetPtr
	ld a, $30
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hld], a
	xor a
	ld [wCurObjVar3], a
	ret

.FlipOver:
	ld bc, TogebaData_60760
	call ApplyObjYMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Flipped)
	ld [hld], a
	ld a, LOW(.Flipped)
	ld [hld], a
	ld de, TogebaFrameset_69263
	call SetObjectFramesetPtr
	xor a
	ld [wCurObjVar3], a
	ld [wCurObjState], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WALKABLE
	ld [hld], a
	ret

.StartRecover:
	ld hl, wCurObjUpdateFunction + 1
	ld a, $4e
	ld [hld], a
	ld a, $3e
	ld [hld], a
	ld de, TogebaFrameset_69275
	call SetObjectFramesetPtr
	ld a, $10
	ld [hli], a
	ret

.Recover:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	jp .SetUpright

.Flipped:
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	sub $0c
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .StartRecover
	ld hl, wCurObjXPos
	ld a, [hli]
	add $0b
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .StartRecover
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_state
	dec [hl]
	jr nz, .check_state
	ld de, TogebaFrameset_69263
	call SetObjectFramesetPtr
.check_state
	ld l, OBJ_STATE
	ld a, [hl]
	and a
	jr z, .sink
	cp $0a
	jr nz, .hit
	xor a
	ld [hl], a
	ld de, TogebaFrameset_6926c
	call SetObjectFramesetPtr
	ld a, $1b
	ld [hli], a
	jr .sink
.hit
	xor a
	ld [hl], a
	ld de, TogebaFrameset_6927c
	call SetObjectFramesetPtr
	ld a, $0a
	ld [hli], a
	ld a, [wCurObjUnk1d]
	rla
	jr nc, .sink
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.FlippedBounce)
	ld [hld], a
	ld a, LOW(.FlippedBounce)
	ld [hld], a
	ret

.sink
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectDown
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	call MoveWarioDown
	call HandleDownwardsFloorTransition
	jp MoveObjectDown

.FlippedBounce:
	call MoveObjectUp_Fast
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Flipped)
	ld [hld], a
	ld a, LOW(.Flipped)
	ld [hld], a
	ld de, TogebaFrameset_69263
	call SetObjectFramesetPtr
	ret
