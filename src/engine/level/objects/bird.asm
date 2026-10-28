BirdFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Init)
	ld [hld], a
	ld a, LOW(.Init)
	ld [hld], a
	ret

.Init:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $fa
	ld [hl], a
	xor a
	ld [wCurObjStateDuration], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, BirdFrameset_687d3
	call SetObjectFramesetPtr
	ret

.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, BirdFrameset_687e4
	call SetObjectFramesetPtr
	ret

.Idle:
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .check_wario_y
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .turn_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, BirdFrameset_687e4
	call SetObjectFramesetPtr
	jr .check_wario_y

.turn_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, BirdFrameset_687d3
	call SetObjectFramesetPtr
.check_wario_y
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
	jr c, .in_y_range
	cp $e8
	ret c
.in_y_range
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	ld b, a
	jr c, .wario_to_right
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .turn_around
	ld a, b
	cp $70
	ret nc
	ld de, BirdFrameset_687c9
	call SetObjectFramesetPtr
	jr .take_off

.wario_to_right
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr z, .turn_around
	ld a, b
	cp $90
	ret c
	ld de, BirdFrameset_687ce
	call SetObjectFramesetPtr
.take_off
	ld a, $23
	ld [hli], a
	ld a, OBJSTATE_SPECIAL_3
	ld [wCurObjState], a
	play_sfx SFX_BIRD_ALERT
	ret

.turn_around
	ld de, BirdFrameset_687ff
	call SetObjectFramesetPtr
	ld a, $0c
	ld [hli], a
	ret

.Special3:
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .fly
	dec [hl]
	ret nz
	play_sfx SFX_BIRD_TAKE_OFF
	ret

.FlyAway:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
.fly
	ld a, [wCurObjSubState]
	rlca
	jp c, MoveObjectRight_Fast
	jp MoveObjectLeft_Fast

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jp z, .Idle
	cp OBJSTATE_SPECIAL_3
	jr z, .Special3
	cp OBJSTATE_HIT_WARIO_RIGHT_START
	jr z, .hit_wario_right
	cp OBJSTATE_HIT_WARIO_LEFT_START
	jr z, .hit_wario_left
	cp OBJSTATE_VANISH_TOUCH
	jr z, .vanish
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


.hit_wario_right
	ld bc, ObjParams_BirdStars1
	jr .hit_wario

.hit_wario_left
	ld bc, ObjParams_BirdStars2
.hit_wario
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	bit OBJFLAG_NO_COLLISION_F, [hl]
	jr z, .spawn_stars
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr z, .set_hit_by_obj_right
	jr .set_hit_by_obj_left

.spawn_stars
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, [wCurObjId]
	cp BLUE_BIRD
	jr z, .blue_bird
	ld a, HIGH(.FlyAway)
	ld [hld], a
	ld a, LOW(.FlyAway)
	ld [hld], a
	jp CreateObjectAtRelativePos
.blue_bird
	ld a, HIGH(.BlueBirdWait)
	ld [hld], a
	ld a, LOW(.BlueBirdWait)
	ld [hld], a
	ld a, $14
	ld [wCurObjStateDuration], a
	ret

.vanish
	jp VanishAndDespawnObject

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
	ld l, OBJ_VAR_2
	ld a, b
	ld [hli], a
	xor a
	ld [hli], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [hl]
	rlca
	jr c, .knocked_back_facing_right
	ld de, BirdFrameset_687f5
	jp SetObjectFramesetPtr
.knocked_back_facing_right
	ld de, BirdFrameset_687fa
	jp SetObjectFramesetPtr

.BlueBirdWait:
	ld hl, wCurObjAction
	ld a, no_actions_for 1
	ld [hld], a
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, BirdFrameset_687ff
	call SetObjectFramesetPtr
	ld a, $0c
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.BlueBirdLand)
	ld [hld], a
	ld a, LOW(.BlueBirdLand)
	ld [hld], a
	ret

.BlueBirdLand:
	ld hl, wCurObjAction
	ld a, no_actions_for 1
	ld [hld], a
	ld a, [hl]
	and a
	jp nz, .Special3
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld l, OBJ_STATE
	ld a, OBJSTATE_LAND
	ld [hld], a
	ld a, [hl]
	rlca
	jr c, .land_facing_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, BirdFrameset_687ce
	call SetObjectFramesetPtr
	ret

.land_facing_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, BirdFrameset_687c9
	call SetObjectFramesetPtr
	ret
