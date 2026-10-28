SeeingEyeDoorFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.CheckWarioDistance)
	ld [hld], a
	ld a, LOW(.CheckWarioDistance)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, 24
	ld [wCurObjVar2], a
	call MoveObjectDownByVar2
	ld de, SeeingEyeDoorFrameset_68c47
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $02
	ld [hld], a
	ld a, $fd
	ld [hld], a
	ld a, $17
	ld [hl], a
	ret

.CheckWarioDistance:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Default)
	ld [hld], a
	ld a, LOW(.Default)
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .wario_to_right
	ld a, $5a
	ld de, SeeingEyeDoorFrameset_68c47
	jr .set_look_dir
.wario_to_right
	ld a, $2e
	ld de, SeeingEyeDoorFrameset_68c59
.set_look_dir
	ld [wCurObjVar1], a
	call SetObjectFramesetPtr
	jr .Default

	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	ret z
	ld a, [wCurObjScreenYPos]
	sub $19
	ld b, a
	ld a, [wWarioScreenYPos]
	sub b
	cp $36
	ret nc
	jr .CheckWarioDistance

.set_look_around
	ld a, [wCurObjVar1]
	cp $2e
	jr z, .set_wait_for_wario
	cp $5a
	jr z, .set_wait_for_wario
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	ld_obj_frameset SeeingEyeDoorFrameset_68c4a, SeeingEyeDoorFrameset_68c56
	call SetObjectFramesetPtr
	ld a, 8
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.LookAround)
	ld [hld], a
	ld a, LOW(.LookAround)
	ld [hld], a
	ret

.LookAround:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
.set_wait_for_wario
	ld de, SeeingEyeDoorFrameset_68c36
	call SetObjectFramesetPtr
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, $54
	ld [hld], a
	ld a, $f6
	ld [hld], a
	ret

.Default:
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jr z, .set_look_around
	ld a, [wCurObjScreenYPos]
	sub $19
	ld b, a
	ld a, [wWarioScreenYPos]
	sub b
	cp $36
	jr nc, .set_look_around
	ld a, [wWarioScreenXPos]
	ld d, a
	ld a, [wCurObjScreenXPos]
	ld e, a
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .check_look_dir
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
.check_look_dir
	ld l, OBJ_VAR_1
	ld a, [hl]
	cp $5c
	jr z, .looking_center
	cp $2d
	jr z, .looking_right
	cp $2e
	jr z, .looking_far_right
	cp $5b
	jr z, .looking_left
	cp $5a
	jp z, .looking_far_left
	ret

.looking_center
	ld a, e
	add $17
	cp d
	jr c, .look_right
	ld a, e
	sub $18
	cp d
	ret c
	ld a, $5b
	ld de, SeeingEyeDoorFrameset_68c4a
	jr .set_look
.look_right
	ld a, $2d
	ld de, SeeingEyeDoorFrameset_68c56
.set_look
	ld [hl], a
	play_sfx SFX_SEEING_EYE_DOOR_LOOK
	jp SetObjectFramesetPtr

.looking_right
	ld a, e
	add $46
	cp d
	jr c, .look_far_right
	ld a, e
	add $17
	cp d
	ret c
	play_sfx SFX_SEEING_EYE_DOOR
	ld a, $5c
	ld [hl], a
	ld de, SeeingEyeDoorFrameset_68c50
	jp SetObjectFramesetPtr

.look_far_right
	play_sfx SFX_SEEING_EYE_DOOR_LOOK
	ld a, $2e
	ld [hl], a
	ld de, SeeingEyeDoorFrameset_68c59
	jp SetObjectFramesetPtr

.looking_far_right
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, e
	add $46
	cp d
	ret c
	play_sfx SFX_SEEING_EYE_DOOR_LOOK
	ld a, $2d
	ld [hl], a
	ld de, SeeingEyeDoorFrameset_68c56
	jp SetObjectFramesetPtr

.looking_left
	ld a, e
	sub $18
	cp d
	jr c, .look_center_from_left
	ld a, e
	sub $47
	cp d
	ret c
	play_sfx SFX_SEEING_EYE_DOOR_LOOK
	ld a, $5a
	ld [hl], a
	ld de, SeeingEyeDoorFrameset_68c47
	jp SetObjectFramesetPtr

.look_center_from_left
	play_sfx SFX_SEEING_EYE_DOOR
	ld a, $5c
	ld [hl], a
	ld de, SeeingEyeDoorFrameset_68c50
	jp SetObjectFramesetPtr

.looking_far_left
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, e
	sub $47
	cp d
	ret nc
	play_sfx SFX_SEEING_EYE_DOOR_LOOK
	ld a, $5b
	ld [hl], a
	ld de, SeeingEyeDoorFrameset_68c4a
	jp SetObjectFramesetPtr
