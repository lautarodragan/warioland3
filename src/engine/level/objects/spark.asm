SparkFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld de, SparkFrameset_69bd9
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ld a, $01
	ld [hl], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $02
	ld [hld], a
	ld a, $fc
	ld [hld], a
	ld a, $fb
	ld [hl], a
	ret

.Update:
	ld a, [wGlobalCounter]
	rra
	ret c
	ld hl, wCurObjVar1
	ld a, [hld]
	and a
	jr z, .move_left_or_down
	dec [hl]
	jr z, .switch_to_left_or_down
	ld a, [wCurObjId]
	cp SPARK_HORIZONTAL
	jp z, MoveObjectRight
	jp MoveObjectUp
.switch_to_left_or_down
	ld a, $50
	ld [hli], a
	xor a
	ld [hl], a
	ret
.move_left_or_down
	dec [hl]
	jr z, .switch_to_right_or_up
	ld a, [wCurObjId]
	cp SPARK_HORIZONTAL
	jp z, MoveObjectLeft
	jp MoveObjectDown
.switch_to_right_or_up
	ld a, $50
	ld [hli], a
	ld a, $01
	ld [hl], a
	ret
