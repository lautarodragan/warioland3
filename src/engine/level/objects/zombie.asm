ZombieFunc:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Init)
	ld [hld], a
	ld a, LOW(.Init)
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 3
	ld [hld], a
	ld a, -4
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	xor a
	ld [wCurObjStateDuration], a
	ret

.Init:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.OnUnderground)
	ld [hld], a
	ld a, LOW(.OnUnderground)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .set_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld a, $17
	ld [wCurObjFrame], a
	ret
.set_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld a, $18
	ld [wCurObjFrame], a
	ret

.OnUnderground:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Down
	and a
	jr nz, .on_floor
	xor a
	ld [wCurObjFlags], a
	ret
.on_floor
	ld hl, wCurObjXPos
	ld a, [wCurObjSubState]
	rlca
	jr c, .crawl_right
	ld a, [hl]
	and $0f
	sub 4
	jr nc, .check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jp z, .turn_around
.check_wall_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	sub 4
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .turn_around
	call MoveObjectLeft
	jr .check_rise_delay
.turn_around
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.crawl_right
	ld a, [hl]
	and $0f
	add 3
	cp 16
	jr c, .check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .turn_around
.check_wall_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	add 3
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .turn_around
	call MoveObjectRight
.check_rise_delay
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_wario_near
	dec [hl]
	ret
.check_wario_near
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp 24
	jr c, .in_y_range
	cp -24
	ret c
.in_y_range
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp -32
	ret nc
	cp 32
	ret c
	cp -64
	jr nc, .in_x_range
	cp 64
	ret nc
.in_x_range
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.StartRise)
	ld [hld], a
	ld a, LOW(.StartRise)
	ld [hld], a
	ld a, 20
	ld [wCurObjStateDuration], a
	ret

.StartRise:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, ZombieFrameset_68d93
	jr .set_rise_frameset
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, ZombieFrameset_68d9c
.set_rise_frameset
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a ; state duration
	ld l, OBJ_FLAGS
	res OBJFLAG_INVISIBLE_F, [hl]
	res OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Rising)
	ld [hld], a
	ld a, LOW(.Rising)
	ld [hld], a
	play_sfx SFX_ZOMBIE_RISE
	ret

.Rising:
	ld a, [wTransformation]
	cp TRANSFORMATION_ZOMBIE_WARIO
	jr nz, .rise
	ld a, no_actions_for 1
	ld [wCurObjAction], a
.rise
	ld hl, wCurObjStateDuration
	dec [hl]
	ld a, [hl]
	cp 12
	jr z, .coll_box_low
	cp 6
	jr z, .coll_box_mid
	and a
	ret nz
; coll box high
	ld a, -24
	ld [wCurObjCollBoxTop], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.OnSurface)
	ld [hld], a
	ld a, LOW(.OnSurface)
	ld [hld], a
	xor a
	ld [wCurObjState], a
	jr .set_walk
.coll_box_low
	ld a, -12
	ld [wCurObjCollBoxTop], a
	ret
.coll_box_mid
	ld a, -18
	ld [wCurObjCollBoxTop], a
	ret

.OnSurface:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .substate_table
	ld a, [wTransformation]
	cp TRANSFORMATION_ZOMBIE_WARIO
	jr nz, .not_zombie_wario
	ld a, [hl]
	cp OBJSTATE_VANISH_TOUCH
	jr nz, .clear_state
.hit
	dec l
	ld a, [hl]
	and $0f
	cp $3
	jr z, .hit_while_throwing
	ld de, ZombieFrameset_68d1a
	jr .set_hit_frameset
.hit_while_throwing
	ld de, ZombieFrameset_68d1f
.set_hit_frameset
	call SetObjectFramesetPtr

.knock_back
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	ld [hld], a
	xor a
	ld [hld], a
	ld a, $02
	ld [hld], a
	play_sfx SFX_ATTACK_HIT
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .knock_left
	ld bc, ObjState_HitByObjRight
	jr .set_knock_back
.knock_left
	ld bc, ObjState_HitByObjLeft
.set_knock_back
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	ret

.not_zombie_wario
	ld a, [hl]
	cp OBJSTATE_VANISH_TOUCH
	jp z, VanishAndDespawnObject
	jr .hit
.clear_state
	xor a
	ld [hl], a
.substate_table
	ld a, [wCurObjSubState]
	and $0f
	jumptable

	dw .CheckWarioNear
	dw .CheckWarioNear
	dw .TurnAround
	dw .ThrowHead

.set_walk
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $01
	ld [hl], a
	rlca
	jr c, .walk_facing_right
	ld de, ZombieFrameset_68d81
	jp SetObjectFramesetPtr
.walk_facing_right
	ld de, ZombieFrameset_68d8a
	jp SetObjectFramesetPtr

.CheckWarioNear:
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp 32
	jr c, .near_y
	cp -32
	jr c, .walk
.near_y
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp -48
	jr nc, .wario_to_right
	cp 48
	jr nc, .walk
	ld a, [hl]
	rlca
	jp c, .turn_from_right
	ld de, ZombieFrameset_68da5
	jr .start_throw
.wario_to_right
	ld a, [hl]
	rlca
	jp nc, .turn_from_left
	ld de, ZombieFrameset_68dac
.start_throw
	rrca
	and OBJSUBFLAGS_MASK
	or $3
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a
	play_sfx SFX_ZOMBIE
	ret

.walk
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Down
	and a
	jr nz, .walk_on_floor
	ld a, $30
	ld [wCurObjStateDuration], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Headless)
	ld [hld], a
	ld a, LOW(.Headless)
	ld [hld], a
	ret

.walk_on_floor
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .walk_right
	ld a, [hl]
	and $0f
	sub $04
	jr nc, .walk_check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jp z, .turn_from_left
.walk_check_wall_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $04
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Fast
	jr .turn_from_left
.walk_right
	ld a, [hl]
	and $0f
	add $03
	cp $10
	jr c, .walk_check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .turn_from_right
.walk_check_wall_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $03
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Fast
	jr .turn_from_right
.turn_from_right
	ld de, ZombieFrameset_68d2b
	jr .start_turn
.turn_from_left
	ld de, ZombieFrameset_68d24
.start_turn
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $2
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, 32
	ld [hli], a
	ret

.TurnAround:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp 20
	jr z, .flip_direction
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	jp .set_walk
.flip_direction
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .face_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ret
.face_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.ThrowHead:
	ld hl, wCurObjStateDuration
	dec [hl]
	ld a, [hl]
	cp 16
	jr z, .throw_head
	and a
	ret nz
	ld a, 48
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Headless)
	ld [hld], a
	ld a, LOW(.Headless)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret
.throw_head
	ld a, [wCurObjSubState]
	rlca
	jr c, .throw_right
	ld bc, ObjParams_ZombieHeadLeft
	jp CreateObjectAtRelativePos
.throw_right
	ld bc, ObjParams_ZombieHeadRight
	jp CreateObjectAtRelativePos

.Headless:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ld l, OBJ_FLAGS
	jr z, .go_underground
	; flicker
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld a, [hl]
	xor OBJFLAG_INVISIBLE
	ld [hl], a
	ret
.go_underground
	ld hl, wCurObjFlags
	set OBJFLAG_INVISIBLE_F, [hl]
	xor a
	ld [wCurObjState], a
	ld a, 100
	ld [wCurObjStateDuration], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.OnUnderground)
	ld [hld], a
	ld a, LOW(.OnUnderground)
	ld [hld], a
	ret

ZombieHeadFunc_Left:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr nz, .count_down
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr nz, .move
	xor a
	ld [hl], a
	ret
.count_down
	dec [hl]
	jr nz, .move
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ld de, ZombieFrameset_68dda
	call SetObjectFramesetPtr
.move
	ld bc, ZombieData_605a0
	jr ZombieHeadFunc

ZombieHeadFunc_Right:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr nz, .count_down
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr nz, .move
	xor a
	ld [hl], a
	ret
.count_down
	dec [hl]
	jr nz, .move
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ld de, ZombieFrameset_68dd5
	call SetObjectFramesetPtr
.move
	ld bc, ZombieData_60560
;	fallthrough

ZombieHeadFunc:
	call ApplyObjXMovement
	ld hl, wCurObjState
	ld a, [hld]
	and a
	ret z
	cp OBJSTATE_HIT_WARIO_RIGHT_START
	jp c, ZombieFunc.knock_back
	cp OBJSTATE_STUNNED_START
	jp nc, ZombieFunc.knock_back
	ld a, [hld]
	rlca
	ld_obj_frameset ZombieFrameset_68dd5, ZombieFrameset_68dda
	call SetObjectFramesetPtr
	ld a, 40
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Flicker)
	ld [hld], a
	ld a, LOW(.Flicker)
	ld [hld], a
	ret

.Flicker:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ld l, OBJ_FLAGS
	jr z, .destroy
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld a, [hl]
	xor OBJFLAG_INVISIBLE
	ld [hl], a
	ret
.destroy
	xor a
	ld [hl], a
	ret
