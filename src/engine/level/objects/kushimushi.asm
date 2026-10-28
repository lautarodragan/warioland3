KushimushiVerticalFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, KushimushiFrameset_6861b
	call SetObjectFramesetPtr
	ld a, $60
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 3
	ld [hld], a
	ld a, -4
	ld [hld], a
	ld a, -3
	ld [hl], a
	ret

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .move_vertical
	cp OBJSTATE_HIT_WARIO_DOWN_START
	jr z, .pause_after_hit_vertical
	cp OBJSTATE_HIT_WARIO_UP_START
	jr z, .pause_after_hit_vertical
	cp OBJSTATE_VANISH_TOUCH
	jp z, VanishObject2
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .set_hit_by_obj_left
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .set_hit_by_obj_right
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .set_attacked_left
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .set_attacked_right
	rra
	jr nc, .set_hit_by_obj_right
	jr .set_hit_by_obj_left

.pause_after_hit_vertical
	xor a
	ld [hl], a
	ld l, OBJ_VAR_2
	ld a, $3c
	ld [hld], a
	ld a, [hl]
	and a
	jr z, .pause_moving_down
	ld de, KushimushiFrameset_6862a
	jp SetObjectFramesetPtr
.pause_moving_down
	ld de, KushimushiFrameset_6862f
	jp SetObjectFramesetPtr
.set_hit_by_obj_left
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .set_knocked_back

.set_hit_by_obj_right
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .set_knocked_back

.set_attacked_right
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
	jr .set_knocked_back

.set_attacked_left
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
.set_knocked_back
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $f0
	ld [hld], a
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld de, KushimushiFrameset_68698
	jp SetObjectFramesetPtr

.move_vertical
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jr z, .step_vertical
	dec [hl]
	ld a, 2
	ld [wCurObjFrameDuration], a
	ret

.step_vertical
	ld a, [wGlobalCounter]
	rra
	ret c
	ld l, OBJ_VAR_1
	ld a, [hld]
	and a
	jr z, .move_down
	cp $01
	jr z, .turn_around_up
	cp $02
	jr z, .move_up
	cp $03
	jr z, .turn_around_down
	ret

.move_down
	dec [hl] ; OBJ_STATE_DURATION
	jp nz, MoveObjectDown
	ld de, KushimushiFrameset_6863f
	ld b, $1
	ld c, OBJ_INTERACTION_TOUCH
	ld a, 22
	jr .set_vertical_phase
.turn_around_up
	dec [hl] ; OBJ_STATE_DURATION
	ret nz
	ld de, KushimushiFrameset_68616
	ld b, $2
	ld c, OBJ_INTERACTION_TOP_STING
	ld a, 96
	jr .set_vertical_phase
.move_up
	dec [hl] ; OBJ_STATE_DURATION
	jp nz, MoveObjectUp
	ld de, KushimushiFrameset_68634
	ld b, $3
	ld c, OBJ_INTERACTION_TOUCH
	ld a, 22
	jr .set_vertical_phase
.turn_around_down
	dec [hl] ; OBJ_STATE_DURATION
	ret nz
	ld de, KushimushiFrameset_6861b
	ld b, $0
	ld c, OBJ_INTERACTION_BOTTOM_STING
	ld a, 96
.set_vertical_phase
	ld [hli], a ; OBJ_STATE_DURATION
	ld [hl], b ; OBJ_VAR_1
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or c
	ld [hl], a
	jp SetObjectFramesetPtr

.Update_42acf:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .move_horizontal
	cp OBJSTATE_HIT_WARIO_RIGHT_START
	jr z, .pause_after_hit_horizontal
	cp OBJSTATE_HIT_WARIO_LEFT_START
	jr z, .pause_after_hit_horizontal
	cp OBJSTATE_VANISH_TOUCH
	jp z, VanishObject2
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jp z, .set_hit_by_obj_left
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jp z, .set_hit_by_obj_right
	cp OBJSTATE_ATTACKED_LEFT_START
	jp z, .set_attacked_left
	cp OBJSTATE_ATTACKED_RIGHT_START
	jp z, .set_attacked_right
	rra
	jp nc, .set_hit_by_obj_right
	jp .set_hit_by_obj_left
.pause_after_hit_horizontal
	xor a
	ld [hl], a
	ld l, OBJ_VAR_2
	ld a, $3c
	ld [hld], a
	ld a, [hl]
	and a
	jr z, .pause_moving_right
	ld de, KushimushiFrameset_68620
	jp SetObjectFramesetPtr
.pause_moving_right
	ld de, KushimushiFrameset_68625
	jp SetObjectFramesetPtr
.move_horizontal
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jr z, .step_horizontal
	dec [hl]
	ret

.step_horizontal
	ld a, [wGlobalCounter]
	rra
	ret c
	ld l, OBJ_VAR_1
	ld a, [hld]
	and a
	jr z, .move_right
	cp $01
	jr z, .turn_around_left
	cp $02
	jr z, .move_left
	cp $03
	jr z, .turn_around_right
	ret

.move_right
	dec [hl] ; OBJ_STATE_DURATION
	jp nz, MoveObjectRight
	ld de, KushimushiFrameset_68655
	ld b, $1
	ld c, OBJ_INTERACTION_TOUCH
	ld a, 22
	jr .set_horizontal_phase
.turn_around_left
	dec [hl] ; OBJ_STATE_DURATION
	ret nz
	ld de, KushimushiFrameset_6860c
	ld b, $2
	ld c, OBJ_INTERACTION_FRONT_STING
	jr .flip_direction
.move_left
	dec [hl] ; OBJ_STATE_DURATION
	jp nz, MoveObjectLeft
	ld de, KushimushiFrameset_6864a
	ld b, $3
	ld c, OBJ_INTERACTION_TOUCH
	ld a, 22
	jr .set_horizontal_phase
.turn_around_right
	dec [hl] ; OBJ_STATE_DURATION
	ret nz
	ld de, KushimushiFrameset_68611
	ld b, $0
	ld c, OBJ_INTERACTION_FRONT_STING
.flip_direction
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ld l, OBJ_STATE_DURATION
	ld a, 96
.set_horizontal_phase
	ld [hli], a ; OBJ_STATE_DURATION
	ld [hl], b ; OBJ_VAR_1
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or c
	ld [hl], a
	jp SetObjectFramesetPtr

KushimushiHorizontalFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(KushimushiVerticalFunc.Update_42acf)
	ld [hld], a
	ld a, LOW(KushimushiVerticalFunc.Update_42acf)
	ld [hld], a
	ld de, KushimushiFrameset_68611
	call SetObjectFramesetPtr
	ld a, $60
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_HDIR_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 4
	ld [hld], a
	ld a, -5
	ld [hld], a
	ld a, -4
	ld [hl], a
	ret
