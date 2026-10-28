SilkyFunc:
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
	dw .BumpLeftStart
	dw .BumpRightStart
	dw VanishObject2
	dw .State0b
	dw .State0c
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
	dw .Default
	dw .Default
	dw .Special1
	dw .Default
	dw .Default
	dw ObjState_Fall
	dw .Walk
	dw ObjState_BumpLeft
	dw ObjState_BumpRight
	dw ObjState_AttackedLeft
	dw ObjState_AttackedRight
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw ObjState_Bounce2Right
	dw ObjState_Bounce2Left
	dw .Default
	dw .State3b
	dw .State3c
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
	dw .FullThrowLeftStart
	dw .FullThrowRightStart
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
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_FullThrowLeft
	dw ObjState_FullThrowRight

.FullThrowLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_FULL_THROW_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .full_throw_left_facing_right
	ld de, SilkyFrameset_6879e
	call SetObjectFramesetPtr
	jp ObjState_FullThrowLeft
.full_throw_left_facing_right
	ld de, SilkyFrameset_687a7
	call SetObjectFramesetPtr
	jp ObjState_FullThrowLeft

.FullThrowRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_FULL_THROW_RIGHT
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .full_throw_right_facing_right
	ld de, SilkyFrameset_6879e
	call SetObjectFramesetPtr
	jp ObjState_FullThrowRight
.full_throw_right_facing_right
	ld de, SilkyFrameset_687a7
	call SetObjectFramesetPtr
	jp ObjState_FullThrowRight

.Default:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
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
	ld de, SilkyFrameset_68744
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ret

.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, SilkyFrameset_6874d
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f9
	ld [hld], a
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
	ld de, SilkyFrameset_68744
	jp SetObjectFramesetPtr
.standing_fall_right
	xor a
	ld [hld], a
	ld de, SilkyFrameset_6874d
	jp SetObjectFramesetPtr
.Special1:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jp z, .walk_on
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .count_down
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.count_down
	dec [hl]
	ret nz
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_SILKY
	ld [hld], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .attack_facing_right
	ld de, SilkyFrameset_68756
	jp SetObjectFramesetPtr
.attack_facing_right
	ld de, SilkyFrameset_6875f
	jp SetObjectFramesetPtr

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
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld de, SilkyFrameset_68744
	jp SetObjectFramesetPtr
.land_facing_right
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld de, SilkyFrameset_6874d
	jp SetObjectFramesetPtr

.Walk:
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr z, .walk_on
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $0f
	jr c, .in_y_range
	cp $f1
	jr c, .walk_on
.in_y_range
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	cp b
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr c, .wario_to_right
	jr nz, .turn_to_wario
	ld de, SilkyFrameset_687b0
	jr .start_attack

.wario_to_right
	jr z, .turn_to_wario
	ld de, SilkyFrameset_687bb
	jr .start_attack

.turn_to_wario
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.start_attack
	call SetObjectFramesetPtr
	ld a, $23
	ld [hli], a
	ld a, OBJSTATE_SPECIAL_1
	ld [wCurObjState], a
	ret

.walk_on
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .check_floor
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.check_floor
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
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
	ret

.on_floor
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
	sub $08
	jr nc, .check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jr z, .turn_at_edge_left
.check_wall_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
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
	add $07
	cp $10
	jr c, .check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .turn_at_edge_right
.check_wall_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
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
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Slow
.turn_at_edge_right
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.StunLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset SilkyFrameset_6877a, SilkyFrameset_68783
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld_obj_frameset SilkyFrameset_6877a, SilkyFrameset_68783
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld de, SilkyFrameset_6877a
	call SetObjectFramesetPtr
	jr .set_fall_vars

.fall_facing_right
	ld de, SilkyFrameset_68783
	call SetObjectFramesetPtr
.set_fall_vars
	inc l
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
	ret

.State0f:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUNNED
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset SilkyFrameset_6877a, SilkyFrameset_68783
	call SetObjectFramesetPtr
	ld a, $64
	ld [hli], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .stunned_count_down
	ld a, OBJSTATE_RANDOM_WOBBLE_START
	ld [wCurObjState], a
	ret

.stunned_count_down
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
	ld_obj_frameset SilkyFrameset_68768, SilkyFrameset_68771
	call SetObjectFramesetPtr
	ld a, $23
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ret

.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .turning
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.turning
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, [wCurObjSubState]
	rlca
	jr c, .turn_left
	ld hl, wCurObjState
	ld a, OBJSTATE_LAND
	ld [hld], a
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.turn_left
	ld hl, wCurObjState
	ld a, OBJSTATE_LAND
	ld [hld], a
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.BumpLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_LEFT
	jr .set_wobble

.BumpRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_RIGHT
.set_wobble
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset SilkyFrameset_6878c, SilkyFrameset_68795
	call SetObjectFramesetPtr
	ld a, $04
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
	ret

.State0b:
	ld a, OBJSTATE_HIT_WARIO_RIGHT
	ld [wCurObjState], a
	jr .set_hit_wario

.State0c:
	ld a, OBJSTATE_HIT_WARIO_LEFT
	ld [wCurObjState], a
.set_hit_wario
	ld hl, wCurObjFrameDuration
	xor a
	ld [hli], a
	ld [hli], a
	ld a, $02
	ld [wCurObjVar2], a
	ret

.State3b:
	ld hl, wCurObjFrameDuration
	xor a
	ld [hli], a
	ld [hli], a
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.State3c:
	ld hl, wCurObjFrameDuration
	xor a
	ld [hli], a
	ld [hli], a
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
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
	ld a, [hl]
	and $f0
	ld [hld], a
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld de, SilkyFrameset_687c6
	call SetObjectFramesetPtr
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

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
	ld_obj_frameset SilkyFrameset_6877a, SilkyFrameset_68783
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld_obj_frameset SilkyFrameset_6877a, SilkyFrameset_68783
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld a, $9f
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
