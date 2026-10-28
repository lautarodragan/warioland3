SunFunc:
	ld de, SunMoonFrameset_68f6b
	call SetObjectFramesetPtr
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.CheckDirection)
	ld [hld], a
	ld a, LOW(.CheckDirection)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 7
	ld [hld], a
	ld a, -8
	ld [hld], a
	ld a, -4
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret

.CheckDirection:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, SunMoonFrameset_68f74
	jr .set_frameset
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, SunMoonFrameset_68f6b
.set_frameset
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a ; state duration
	xor a
	ld [hli], a ; var1
	inc a ; 1
	ld [hl], a ; var2
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjVar1]
	jumptable

	dw .Idle
	dw .StartTurnRight
	dw .StartTurnLeft
	dw .TurnRight
	dw .TurnLeft
	dw .Drop

.Drop:
	call SunMoon_XMovement
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr z, .fall
	ld a, [wHitFloorBlock]
	and a
	jr z, .count_down
.fall
	ld bc, SunMoonData_60690
	call ApplyObjYMovement
.count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_drop
	ld a, [hl]
	cp 52
	ret nz
	play_sfx SFX_SUN_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .shoot_right
; shoot left
	ld bc, ObjParams_SunFlameLeft
	jp CreateObjectAtRelativePos
.shoot_right
	ld bc, ObjParams_SunFlameRight
	jp CreateObjectAtRelativePos

.end_drop
	ld a, 50
	ld [hli], a
	xor a
	ld [hl], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .end_drop_facing_right
	ld de, SunMoonFrameset_68f74
	jp SetObjectFramesetPtr
.end_drop_facing_right
	ld de, SunMoonFrameset_68f6b
	jp SetObjectFramesetPtr

.Idle:
	call SunMoon_GeneralMovement
	ld a, [wJoypadPressed]
	and $ff ^ (PAD_SELECT | PAD_START)
	jr z, .check_duration
	; reset duration
	ld a, 50
	ld [wCurObjStateDuration], a
.check_duration
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_wario_near
	dec [hl]
	ret

.check_wario_near
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	sub b
	cp 64
	jr c, .in_x_range
	cp -64
	ret c
.in_x_range
	ld a, [wCurObjScreenYPos]
	add $2a
	ld b, a
	ld a, [wWarioScreenYPos]
	add $2a
	sub b
	cp 43
	ret nc
	ld l, OBJ_STATE_DURATION
	ld a, 82
	ld [hli], a
	ld a, $05
	ld [hli], a ; var1
	inc l
	xor a
	ld [hli], a
	ld a, [hld]
	rlca
	jr c, .drop_facing_right
	ld de, SunMoonFrameset_68f9e
	jp SetObjectFramesetPtr
.drop_facing_right
	ld de, SunMoonFrameset_68f8f
	jp SetObjectFramesetPtr

.StartTurnRight:
	call SunMoon_GeneralMovement
	ld de, SunMoonFrameset_68fc0
	call SetObjectFramesetPtr
	ld a, 35
	ld [hli], a
	ld a, $03
	ld [hl], a ; var1
	ret

.TurnRight:
	call SunMoon_GeneralMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, SunMoonFrameset_68f6b
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a
	xor a
	ld [hl], a
	ret

.StartTurnLeft:
	call SunMoon_GeneralMovement
	ld de, SunMoonFrameset_68fb7
	call SetObjectFramesetPtr
	ld a, 35
	ld [hli], a
	ld a, $04
	ld [hl], a
	ret

.TurnLeft:
	call SunMoon_GeneralMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, SunMoonFrameset_68f74
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a
	xor a
	ld [hl], a
	ret

SunMoon_GeneralMovement:
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr nz, .on_screen
	ld a, 2
	ld [wCurObjVar2], a
.on_screen
	ld l, OBJ_X_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	ld b, a
	ld a, [wWarioXPos + 1]
	ld c, a
	ld a, b
	cp d
	jr c, .wario_to_left
	jr nz, .wario_to_right
	ld a, c
	cp e
	jr c, .wario_to_left

.wario_to_right
	ld hl, 32
	add hl, de
	ld a, b
	cp h
	jr c, .close_right
	jr nz, .move_right
	ld a, c
	cp l
	jr nc, .move_right
.close_right
	ld a, 1
	ld [wCurObjVar2], a
	jr .face_right
.move_right
	call SunMoon_MoveRight
.face_right
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .move_vertical
	set OBJSUBFLAG_HDIR_F, [hl]
	ld a, $01
	ld [wCurObjVar1], a
	jr .move_vertical

.wario_to_left
	ld hl, -32
	add hl, de
	ld a, b
	cp h
	jr c, .move_left
	jr nz, .close_left
	ld a, c
	cp l
	jr c, .move_left
.close_left
	ld a, 1
	ld [wCurObjVar2], a
	jr .face_left
.move_left
	call SunMoon_MoveLeft
.face_left
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr z, .move_vertical
	res OBJSUBFLAG_HDIR_F, [hl]
	ld a, $02
	ld [wCurObjVar1], a

.move_vertical
	ld l, OBJ_Y_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $2a
	add hl, de
	ld a, [wWarioYPos + 0]
	ld b, a
	ld a, [wWarioYPos + 1]
	ld c, a
	ld a, b
	cp h
	jp c, SunMoon_MoveUp
	jp nz, SunMoon_MoveDown
	ld a, c
	cp l
	ret z
	jp c, SunMoon_MoveUp
	jp SunMoon_MoveDown

SunMoon_XMovement:
	; moves quicker when outside screen
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .outside_screen
	ld a, 1
	jr .got_vel
.outside_screen
	ld a, 2
.got_vel
	ld [wCurObjVar2], a

	ld l, OBJ_X_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	ld b, a
	ld a, [wWarioXPos + 1]
	ld c, a
	ld a, b
	cp d
	jr c, .going_left
	jr nz, .going_right
	ld a, c
	cp e
	jr c, .going_left
.going_right
	ld hl, 32
	add hl, de
	ld a, b
	cp h
	ret c
	jp nz, SunMoon_MoveRight
	ld a, c
	cp l
	ret c
	jp SunMoon_MoveRight
.going_left
	ld hl, -32
	add hl, de
	ld a, b
	cp h
	jp c, SunMoon_MoveLeft
	ret nz
	ld a, c
	cp l
	ret nc
	jp SunMoon_MoveLeft

SunMoon_MoveRight:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 6
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	add 12
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 20
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	jp MoveObjectRightByVar2

SunMoon_MoveLeft:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 6
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	sub 12
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 20
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	jp MoveObjectLeftByVar2

SunMoon_MoveDown:
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr z, .move_down
	ld a, [wHitFloorBlock]
	and a
	ret z
.move_down
	jp MoveObjectDownByVar2

SunMoon_MoveUp:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 24
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	ret nz
	jp MoveObjectUpByVar2

SunFlameFunc_Left:
	ld bc, SunMoonData_606e0
	jr SunFlameFunc
SunFlameFunc_Right:
	ld bc, SunMoonData_606f0
SunFlameFunc:
	call ApplyObjXMovement
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wCurObjState]
	and a
	ret z
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, SunMoonFrameset_68fc9
	call SetObjectFramesetPtr
	ld a, 14
	ld [hli], a
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret

MoonFunc:
	ld de, SunMoonFrameset_68fd0
	call SetObjectFramesetPtr
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.CheckDirection)
	ld [hld], a
	ld a, LOW(.CheckDirection)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 7
	ld [hld], a
	ld a, -8
	ld [hld], a
	ld a, -4
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret

.CheckDirection:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, SunMoonFrameset_68fd9
	jr .set_frameset
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, SunMoonFrameset_68fd0
.set_frameset
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a ; state duration
	xor a
	ld [hli], a ; var1
	inc a ; 1
	ld [hl], a ; var2
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjVar1]
	jumptable

	dw .Idle
	dw .StartTurnRight
	dw .StartTurnLeft
	dw .TurnRight
	dw .TurnLeft
	dw .Drop

.Drop:
	call SunMoon_XMovement
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr z, .fall
	ld a, [wHitFloorBlock]
	and a
	jr z, .count_down
.fall
	ld bc, SunMoonData_60690
	call ApplyObjYMovement
.count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_drop
	ld a, [hl]
	cp 52
	ret nz
	play_sfx SFX_MOON_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .shoot_right
; shoot left
	ld bc, ObjParams_MoonStarLeft
	jp CreateObjectAtRelativePos
.shoot_right
	ld bc, ObjParams_MoonStarRight
	jp CreateObjectAtRelativePos

.end_drop
	ld a, 50
	ld [hli], a
	xor a
	ld [hl], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .end_drop_facing_right
	ld de, SunMoonFrameset_68fd9
	jp SetObjectFramesetPtr
.end_drop_facing_right
	ld de, SunMoonFrameset_68fd0
	jp SetObjectFramesetPtr

.Idle:
	call SunMoon_GeneralMovement
	ld a, [wJoypadPressed]
	and $ff ^ (PAD_SELECT | PAD_START)
	jr z, .check_duration
	; reset duration
	ld a, 50
	ld [wCurObjStateDuration], a
.check_duration
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_wario_near
	dec [hl]
	ret

.check_wario_near
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	sub b
	cp 64
	jr c, .in_x_range
	cp -64
	ret c
.in_x_range
	ld a, [wCurObjScreenYPos]
	add $2a
	ld b, a
	ld a, [wWarioScreenYPos]
	add $2a
	sub b
	cp 43
	ret nc
	ld l, OBJ_STATE_DURATION
	ld a, 82
	ld [hli], a
	ld a, $05
	ld [hli], a ; var1
	inc l
	xor a
	ld [hli], a
	ld a, [hld]
	rlca
	jr c, .drop_facing_right
	ld de, SunMoonFrameset_69003
	jp SetObjectFramesetPtr
.drop_facing_right
	ld de, SunMoonFrameset_68ff4
	jp SetObjectFramesetPtr

.StartTurnRight:
	call SunMoon_GeneralMovement
	ld de, SunMoonFrameset_69036
	call SetObjectFramesetPtr
	ld a, 40
	ld [hli], a
	ld a, $03
	ld [hl], a ; var1
	ret

.TurnRight:
	call SunMoon_GeneralMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, SunMoonFrameset_68fd0
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a
	xor a
	ld [hl], a
	ret

.StartTurnLeft:
	call SunMoon_GeneralMovement
	ld de, SunMoonFrameset_6902b
	call SetObjectFramesetPtr
	ld a, 40
	ld [hli], a
	ld a, $04
	ld [hl], a
	ret

.TurnLeft:
	call SunMoon_GeneralMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, SunMoonFrameset_68fd9
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a
	xor a
	ld [hl], a
	ret

MoonStarFunc_Left:
	ld bc, SunMoonData_606e0
	jr MoonStarFunc
MoonStarFunc_Right:
	ld bc, SunMoonData_606f0
MoonStarFunc:
	call ApplyObjXMovement
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wCurObjState]
	and a
	ret z
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, SunMoonFrameset_69024
	call SetObjectFramesetPtr
	ld a, 14
	ld [hli], a
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret
