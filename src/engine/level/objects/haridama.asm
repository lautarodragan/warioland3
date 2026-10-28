; Haridama's own state (see HaridamaFunc.Update)
DEF OBJSTATE_HARIDAMA_UNCURL EQU OBJSTATE_5B

HaridamaFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Init)
	ld [hld], a
	ld a, LOW(.Init)
	ld [hld], a
	ret

.Init:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld a, $fd
	ld [hl], a
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
	ld de, HaridamaFrameset_6927f
	jp SetObjectFramesetPtr
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, HaridamaFrameset_69290
	jp SetObjectFramesetPtr

.Patrol:
	ld c, $2a
	ld a, [wCurObjSubState]
	rlca
	jr c, .patrol_right
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $08
	jr c, .in_y_range_left
	cp $e8
	jr c, .walk_left
.in_y_range_left
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $40
	jr nc, .walk_left
	ld de, HaridamaFrameset_692c7
	jr .start_uncurl
.walk_left
	call .CheckWallLeft
	jp z, MoveObjectLeft_Slow
	ld de, HaridamaFrameset_692a1
	jr .start_turn
.patrol_right
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $08
	jr c, .in_y_range_right
	cp $e8
	jr c, .walk_right
.in_y_range_right
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $c0
	jr c, .walk_right
	ld de, HaridamaFrameset_692ce
	jr .start_uncurl
.walk_right
	call .CheckWallRight
	jp z, MoveObjectRight_Slow
	ld de, HaridamaFrameset_692aa
.start_turn
	call SetObjectFramesetPtr
	ld a, $1b
	ld [hli], a
	ld a, OBJSTATE_5A
	ld [wCurObjState], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_BUMP
	ld [hld], a
	ret

.start_uncurl
	call SetObjectFramesetPtr
	ld a, $12
	ld [hli], a
	ld a, OBJSTATE_HARIDAMA_UNCURL
	ld [wCurObjState], a
	ret

.Uncurl:
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_HARIDAMA
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .uncurled_facing_right
	ld de, HaridamaFrameset_692bd
	jp SetObjectFramesetPtr

.uncurled_facing_right
	ld de, HaridamaFrameset_692c2
	jp SetObjectFramesetPtr

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jp z, .Patrol
	cp OBJSTATE_5A
	jr z, .turning
	cp OBJSTATE_HARIDAMA_UNCURL
	jr z, .Uncurl
	cp OBJSTATE_BUMP_LEFT_START
	jr z, .bumped_from_left
	cp OBJSTATE_BUMP_RIGHT_START
	jr z, .bumped_from_right
	and $fe
	cp OBJSTATE_WOBBLE_LEFT_START ; or OBJSTATE_WOBBLE_RIGHT_START
	jr z, .wobbled
	cp OBJSTATE_BUMP_LEFT
	jr z, .roll
	cp OBJSTATE_WOBBLE_LEFT
	jp z, .RiseInWater
.turn_around
	ld a, [wCurObjSubState]
	rlca
	jr c, .turn_from_right
	ld de, HaridamaFrameset_692a1
	jr .start_turn
.turn_from_right
	ld de, HaridamaFrameset_692aa
	jr .start_turn
.bumped_from_right
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .turn_around
	ld de, HaridamaFrameset_692b3
	jp SetObjectFramesetPtr

.bumped_from_left
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	jr nc, .turn_around
	ld de, HaridamaFrameset_692b8
	jp SetObjectFramesetPtr

.roll
	ld a, [wCurObjSubState]
	rlca
	jr c, .roll_right
	call .CheckWallLeft
	jp z, MoveObjectLeft_Fast
	ld de, HaridamaFrameset_692a1
	jp .start_turn
.roll_right
	call .CheckWallRight
	jp z, MoveObjectRight_Fast
	ld de, HaridamaFrameset_692aa
	jp .start_turn
.turning
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	cp $0d
	jr nz, .count_down
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

.count_down
	dec [hl]
	ret nz
.reset_to_patrol
	ld hl, wCurObjState
	xor a
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .patrol_facing_right
	ld de, HaridamaFrameset_6927f
	jp SetObjectFramesetPtr

.patrol_facing_right
	ld de, HaridamaFrameset_69290
	jp SetObjectFramesetPtr

.wobbled
	ld l, OBJ_ACTION_SIDE
	bit 7, [hl]
	jr nz, .hit_from_below
	ld l, OBJ_SUBSTATE
	ld a, [hli]
	rlca
	jr c, .bumped_from_left
	jr .bumped_from_right
.hit_from_below
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_BUMP
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_WOBBLE_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .hit_from_below_facing_right
	ld de, HaridamaFrameset_692d5
	jp SetObjectFramesetPtr

.hit_from_below_facing_right
	ld de, HaridamaFrameset_692de
	jp SetObjectFramesetPtr

.RiseInWater:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $11
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $08
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jr nz, .start_rolling
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .start_rolling
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $11
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $07
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jp z, MoveObjectUp_Slow
.start_rolling
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.UpdateRolling)
	ld [hld], a
	ld a, LOW(.UpdateRolling)
	ld [hld], a
	ld a, $64
	ld [wCurObjStateDuration], a
	xor a
	ld [wCurObjState], a
	ret

.UpdateRolling:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .rolling
	cp OBJSTATE_BUMP_LEFT
	jr z, .knocked_left
	cp OBJSTATE_BUMP_RIGHT
	jp z, .RollRight
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr nc, .knock_right
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	res OBJSUBFLAG_HDIR_F, [hl]
	jr .set_knock_timer
.knock_right
	ld a, OBJSTATE_BUMP_RIGHT
	ld [hld], a
	set OBJSUBFLAG_HDIR_F, [hl]
.set_knock_timer
	ld a, $3c
	ld [wCurObjVar1], a
	ret

.rolling
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr z, .end_rolling
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .rolling_right
	call .CheckWallLeft
	jp z, MoveObjectLeft
	jr .turn_around_rolling
.rolling_right
	call .CheckWallRight
	jp z, MoveObjectRight
.turn_around_rolling
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	ret

.end_rolling
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	ld a, [wCurObjFrame]
	jr c, .end_rolling_facing_right
	cp $1a
	jp c, .reset_to_patrol
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, HaridamaFrameset_692aa
	jp .start_turn
.end_rolling_facing_right
	cp $1a
	jp nc, .reset_to_patrol
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, HaridamaFrameset_692a1
	jp .start_turn
.knocked_left
	ld hl, wCurObjVar1
	dec [hl]
	jr z, .stop_knock
	call .CheckWallLeft
	jp z, MoveObjectLeft
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_RIGHT
	ld [hld], a
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.stop_knock
	xor a
	ld [wCurObjState], a
	ret

.RollRight:
	ld hl, wCurObjVar1
	dec [hl]
	jr z, .stop_knock
	call .CheckWallRight
	jp z, MoveObjectRight
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.CheckWallLeft:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $08
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $09
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	ret

.CheckWallRight:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $08
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $08
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	ret
