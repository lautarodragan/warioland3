DoughnuteerFunc:
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
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	jp .Default

.Update:
	ld a, [wCurObjState]
	jumptable

	dw .Default
	dw .Land
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .AttackedLeftStart
	dw .AttackedRightStart
	dw .PickedUpLeftStart
	dw .PickedUpRightStart
	dw .WobbleLeftStart
	dw .WobbleRightStart
	dw VanishObject2
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .State0f
	dw .State10
	dw .StandingFallStart
	dw .State12
	dw .TurnAroundStart
	dw .State14
	dw .State15
	dw .StunLeftStart
	dw .StunRightStart
	dw .State18
	dw .State19
	dw ObjState_HopStart
	dw ObjState_Hop
	dw ObjState_StartRandomWobble
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_Bounce1LeftStart
	dw ObjState_Bounce1RightStart
	dw ObjState_Bounce2LeftStart
	dw ObjState_Bounce2RightStart
	dw ObjState_Bounce3LeftStart
	dw ObjState_Bounce3RightStart
	dw ObjState_FallLeftStart
	dw ObjState_FallRightStart
	dw .State28
	dw .State29
	dw .Default
	dw .State2b
	dw .State2c
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_Fall
	dw .Walk
	dw .BumpLeft
	dw .BumpRight
	dw ObjState_AttackedLeft
	dw ObjState_AttackedRight
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw ObjState_Bounce2Right
	dw ObjState_Bounce2Left
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .State3f
	dw .State40
	dw ObjState_StandingFall
	dw ObjState_Drop
	dw .TurnAround
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .StunLeft
	dw .StunRight
	dw .State48
	dw .State49
	dw ObjState_GrabbedChargeLeft
	dw ObjState_GrabbedChargeRight
	dw ObjState_FullThrowLeft
	dw ObjState_FullThrowRight
	dw ObjState_ThrowLeft
	dw ObjState_ThrowRight
	dw ObjState_Bounce1Left
	dw ObjState_Bounce1Right
	dw ObjState_Bounce2Left
	dw ObjState_Bounce2Right
	dw ObjState_Bounce3Left
	dw ObjState_Bounce3Right
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw ObjState_HitByObjLeft
	dw ObjState_HitByObjRight
	dw .State5a
	dw .State5b
	dw .State5c

.State5a:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .throwing
	ld a, OBJSTATE_HOP_START
	ld [wCurObjState], a
	ret

.throwing
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $1a
	jr z, .throw_doughnut
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, OBJSTATE_2B
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .start_turn_facing_right
	ld de, DoughnuteerFrameset_685fe
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.start_turn_facing_right
	ld de, DoughnuteerFrameset_68605
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.throw_doughnut
	dec [hl]
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	play_sfx nz, SFX_ENEMY_THROW
	ld a, [wCurObjSubState]
	rlca
	jr c, .doughnut_right
	ld bc, ObjParams_DoughnutLeft
	jr .spawn_doughnut

.doughnut_right
	ld bc, ObjParams_DoughnutRight
.spawn_doughnut
	jp CreateObjectAtRelativePos

.State2b:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .after_throw_flip
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, OBJSTATE_5B
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .flee_facing_right
	ld de, DoughnuteerFrameset_68574
	jp SetObjectFramesetPtr
.flee_facing_right
	ld de, DoughnuteerFrameset_6857d
	jp SetObjectFramesetPtr
.after_throw_flip
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .after_throw_face_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.after_throw_face_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State5b:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .fleeing
	ld a, OBJSTATE_RANDOM_WOBBLE_START
	ld [wCurObjState], a
	ret

.fleeing
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
	jr nz, .flee_on_floor
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
	ret

.flee_on_floor
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .flee_right
	ld a, [hl]
	and $0f
	sub $06
	jr nc, .flee_check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jr z, .flee_stop_left
.flee_check_wall_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $06
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
.flee_stop_left
	ld a, OBJSTATE_2C
	ld [wCurObjState], a
	ld de, DoughnuteerFrameset_685fe
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.flee_right
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .flee_check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .flee_stop_right
.flee_check_wall_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $05
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
.flee_stop_right
	ld a, OBJSTATE_2C
	ld [wCurObjState], a
	ld de, DoughnuteerFrameset_68605
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.State2c:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .after_flee_flip
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, OBJSTATE_5C
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .wait_facing_right
	ld de, DoughnuteerFrameset_685c4
	call SetObjectFramesetPtr
	ld a, $37
	ld [hli], a
	ret

.wait_facing_right
	ld de, DoughnuteerFrameset_685d7
	call SetObjectFramesetPtr
	ld a, $37
	ld [hli], a
	ret

.after_flee_flip
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .after_flee_face_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.after_flee_face_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State5c:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .wait_count_down
	ld a, OBJSTATE_RANDOM_WOBBLE_START
	ld [wCurObjState], a
	ret

.wait_count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, OBJSTATE_LAND
	ld [wCurObjState], a
	ret

.Default:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld a, $ff
	ld [hl], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_FALL
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_68562
	call SetObjectFramesetPtr
	ret

.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_6856b
	call SetObjectFramesetPtr
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STANDING_FALL
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .standing_fall_right
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_68562
	call SetObjectFramesetPtr
	ret

.standing_fall_right
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_6856b
	call SetObjectFramesetPtr
	ret

.Land:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_WALK
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .land_facing_right
	ld de, DoughnuteerFrameset_68562
	call SetObjectFramesetPtr
	ret

.land_facing_right
	ld de, DoughnuteerFrameset_6856b
	call SetObjectFramesetPtr
	ret

.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .walking
	ld a, OBJSTATE_HOP_START
	ld [wCurObjState], a
	ret

.walking
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $20
	jr c, .in_y_range
	cp $e0
	jr c, .walk_on
.in_y_range
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $c0
	jr nc, .wario_to_right
	cp $40
	jr nc, .walk_on
	ld a, [hli]
	rlca
	jr c, .turn_to_wario
	ld de, DoughnuteerFrameset_68586
	jr .start_throw

.turn_to_wario
	ld a, OBJSTATE_TURN_AROUND_START
	ld [hl], a
	ret

.wario_to_right
	ld a, [hli]
	rlca
	jr nc, .turn_to_wario
	ld de, DoughnuteerFrameset_68597
.start_throw
	ld a, OBJSTATE_5A
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, $33
	ld [hli], a
	ret

.walk_on
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
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
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
	sub $06
	jr nc, .walk_check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jr z, .turn_at_edge_left
.walk_check_wall_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $06
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Slow
.turn_at_edge_left
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.walk_right
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .walk_check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .turn_at_edge_right
.walk_check_wall_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $05
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Slow
.turn_at_edge_right
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld a, [wCurObjFrame]
	cp $24
	jr nc, .drop_doughnut_left
	cp $06
	jr nc, .set_bump_left
.drop_doughnut_left
	ld bc, ObjParams_DoughnutUpLeft
	call CreateObjectAtRelativePos
.set_bump_left
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	jr .set_bump

.BumpLeft:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpLeft
	dec l
	dec l
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hli]
	rlca
	jr c, .bumped_flee_right
	ld a, OBJSTATE_2B
	ld [hl], a
	ld de, DoughnuteerFrameset_685fe
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.bumped_flee_right
	ld a, OBJSTATE_5B
	ld [hl], a
	ld de, DoughnuteerFrameset_6857d
	call SetObjectFramesetPtr
	ret

.BumpRightStart:
	ld a, [wCurObjFrame]
	cp $24
	jr nc, .drop_doughnut_right
	cp $06
	jr nc, .set_bump_right
.drop_doughnut_right
	ld bc, ObjParams_DoughnutUpRight
	call CreateObjectAtRelativePos
.set_bump_right
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_RIGHT
	ld [hld], a
.set_bump
	ld a, [hld]
	rlca
	jr c, .bump_facing_right
	ld de, DoughnuteerFrameset_685a8
	call SetObjectFramesetPtr
	jr .set_bump_duration

.bump_facing_right
	ld de, DoughnuteerFrameset_685ad
	call SetObjectFramesetPtr
.set_bump_duration
	ld a, $0c
	ld [hld], a
	ld a, $02
	ld [wCurObjVar2], a
	ret

.BumpRight:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpRight
	dec l
	dec l
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hli]
	rlca
	jr c, .bumped_turn_to_flee
	ld a, OBJSTATE_5B
	ld [hl], a
	ld de, DoughnuteerFrameset_68574
	call SetObjectFramesetPtr
	ret

.bumped_turn_to_flee
	ld a, OBJSTATE_2B
	ld [hl], a
	ld de, DoughnuteerFrameset_68605
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.StunLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset DoughnuteerFrameset_685b2, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
.StunLeft:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_RIGHT
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset DoughnuteerFrameset_685b2, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
.StunRight:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL_LEFT
	ld [hld], a
	jr .set_fall

.State15:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL_RIGHT
	ld [hld], a
.set_fall
	ld a, [hld]
	rlca
	jr c, .fall_facing_right
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .set_fall_vars

.fall_facing_right
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.set_fall_vars
	inc l
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
	ret

.State0f:
	ld a, OBJSTATE_STUNNED
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .count_down
	ld a, OBJSTATE_RANDOM_WOBBLE_START
	ld [wCurObjState], a
	ret

.count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrDrop
	ld a, OBJSTATE_RECOVER_START
	ld [wCurObjState], a
	ret

.State10:
	ld hl, wCurObjState
	ld a, OBJSTATE_RECOVER
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld a, $07
	ld [wCurObjStateDuration], a
.State40:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ApplyObjHopYVel
	ld a, OBJSTATE_DEFAULT
	ld [wCurObjState], a
	ret

.TurnAroundStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_TURN_AROUND
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .turn_facing_right
	ld de, DoughnuteerFrameset_685f0
	call SetObjectFramesetPtr
	jr .set_turn_duration

.turn_facing_right
	ld de, DoughnuteerFrameset_685f7
	call SetObjectFramesetPtr
.set_turn_duration
	ld a, $1a
	ld [hli], a
	ret

.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .turning
	ld a, OBJSTATE_HOP_START
	ld [wCurObjState], a
	ret

.turning
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .flip_direction
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, OBJSTATE_LAND
	ld [wCurObjState], a
	ret

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

.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_LEFT
	jr .set_wobble

.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_RIGHT
.set_wobble
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .wobble_facing_right
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .set_wobble_vars

.wobble_facing_right
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.set_wobble_vars
	ld a, $04
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
	ret

.State29:
	ld hl, wCurObjState
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT
	ld [hld], a
	ld b, $02
	jr .set_knocked_back

.State28:
	ld hl, wCurObjState
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT
	ld [hld], a
	ld b, $02
	jr .set_knocked_back

.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_LEFT
	ld [hld], a
	ld b, $02
	jr .set_knocked_back

.AttackedRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_RIGHT
	ld [hld], a
	ld b, $02
.set_knocked_back
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [hl]
	and $f0
	ld [hld], a
	ld c, a
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, c
	rlca
	jr c, .knocked_back_facing_right
	ld de, DoughnuteerFrameset_685b2
	jp SetObjectFramesetPtr
.knocked_back_facing_right
	ld de, DoughnuteerFrameset_685bb
	jp SetObjectFramesetPtr
.PickedUpLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_PICKED_UP_LEFT
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $c0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpLeft
.PickedUpRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_PICKED_UP_RIGHT
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $e0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpRight

.State19:
	ld hl, wCurObjState
	ld a, OBJSTATE_GRABBED_RIGHT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .grabbed_right_facing_right
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .set_grabbed_right

.grabbed_right_facing_right
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.set_grabbed_right
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
.State49:
	ld a, [wDirection]
	and a
	jp nz, ObjState_GrabbedRight
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	jr .State18

.State18:
	ld hl, wCurObjState
	ld a, OBJSTATE_GRABBED_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .grabbed_left_facing_right
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .set_grabbed_left

.grabbed_left_facing_right
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.set_grabbed_left
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
.State48:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	jp .State19

.State12:
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_DROP
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
	ret

DoughnutFunc_Left:
	call MoveObjectLeft_Fast
	jr DoughnutFunc_LeftRight
DoughnutFunc_Right:
	call MoveObjectRight_Fast
DoughnutFunc_LeftRight:
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wCurObjState]
	cp OBJSTATE_TRIGGERED
	jr z, DoughnutFunc_Destroy
	cp OBJSTATE_NO_EFFECT
	jr z, DoughnutFunc
	ld bc, SmallHopYVel2
	jp ApplyObjYMovement
DoughnutFunc_Up:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	dec l
	ld a, no_actions_for 15
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
.Update:
	ld a, [wCurObjState]
	cp OBJSTATE_TRIGGERED
	jr z, DoughnutFunc_Destroy
	cp OBJSTATE_NO_EFFECT
	jr z, DoughnutFunc
	ld bc, JumpArcYVel
	jp ApplyObjYMovement
DoughnutFunc_Destroy:
	xor a
	ld [wCurObjFlags], a
	ret
DoughnutFunc:
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .wario_to_right
	ld bc, .Update_Right
	jr .set_update
.wario_to_right
	ld bc, .Update_Left
.set_update
	ld hl, wCurObjUpdateFunction + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	xor a
	ld [wCurObjVar3], a
	ret
.Update_Left:
	call MoveObjectLeft
	jr .fall
.Update_Right:
	call MoveObjectRight
.fall
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, DropYVel_Light
	jp ApplyObjYMovement
