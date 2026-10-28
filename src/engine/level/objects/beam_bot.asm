BeamBotFunc:
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
	dw .Default
	dw .Default
	dw .Special1
	dw .Special2
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
	dw .Default
	dw .Default
	dw .Default

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
	ld de, BeamBotFrameset_68e77
	jp SetObjectFramesetPtr
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e80
	jp SetObjectFramesetPtr
.StandingFallStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STANDING_FALL
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .standing_fall_right
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e77
	call SetObjectFramesetPtr
	ret

.standing_fall_right
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e80
	call SetObjectFramesetPtr
	ret
.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .shooting
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.shooting
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_shoot
	ld a, [hl]
	cp $19
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .beam_right
	ld bc, ObjParams_BeamLeft
	jp CreateObjectAtRelativePos
.beam_right
	ld bc, ObjParams_BeamRight
	jp CreateObjectAtRelativePos
.end_shoot
	ld l, OBJ_STATE
	ld a, OBJSTATE_SPECIAL_2
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset BeamBotFrameset_68ea3, BeamBotFrameset_68eaa
	call SetObjectFramesetPtr
	ld a, 50
	ld [hli], a
	ret
.Special2:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .after_shot
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.after_shot
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
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
	ld_obj_frameset BeamBotFrameset_68e77, BeamBotFrameset_68e80
	call SetObjectFramesetPtr
	ld a, 100
	ld [hli], a
	ret
.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .walking
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.walking
	ld a, [wTransformation]
	cp TRANSFORMATION_SPLIT
	jr z, .walk_on
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .walk_on
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $1c
	jr c, .in_y_range
	cp $e4
	jr c, .walk_on
.in_y_range
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $b8
	jr nc, .wario_to_right
	cp $48
	jr nc, .walk_on
	ld a, [hli]
	rlca
	jr c, .turn_to_wario
	ld de, BeamBotFrameset_68e89
	jr .start_shoot
.turn_to_wario
	ld a, OBJSTATE_TURN_AROUND_START
	ld [hl], a
	ret

.wario_to_right
	ld a, [hli]
	rlca
	jr nc, .turn_to_wario
	ld de, BeamBotFrameset_68e96
.start_shoot
	ld a, OBJSTATE_SPECIAL_1
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, 41
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
	sub $06
	jr nc, .check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jr z, .at_ledge
.check_wall_left
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
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.walk_right
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .at_ledge
.check_wall_right
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
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.at_ledge
	ld a, [wGlobalCounter]
	rra
	jr c, .ledge_count_down
	ld hl, wCurObjFrameDuration
	inc [hl]
.ledge_count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret
.BumpLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	jr .set_bump
.BumpRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_RIGHT
	ld [hld], a
.set_bump
	ld a, [hld]
	rlca
	ld_obj_frameset BeamBotFrameset_68eb1, BeamBotFrameset_68eb4
	call SetObjectFramesetPtr
	ld a, 12
	ld [hld], a
	ld a, $02
	ld [wCurObjVar2], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ret
.StunLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset BeamBotFrameset_68eb7, BeamBotFrameset_68ec0
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
	ld_obj_frameset BeamBotFrameset_68eb7, BeamBotFrameset_68ec0
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
	ld_obj_frameset BeamBotFrameset_68eb7, BeamBotFrameset_68ec0
	call SetObjectFramesetPtr
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
	ld_obj_frameset BeamBotFrameset_68ed3, BeamBotFrameset_68eda
	call SetObjectFramesetPtr
	ld a, 17
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld a, [hl]
	cp $06
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
	ld_obj_frameset BeamBotFrameset_68eb7, BeamBotFrameset_68ec0
	call SetObjectFramesetPtr
	ld a, 4
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
	ld de, BeamBotFrameset_68ec9
	jp SetObjectFramesetPtr
.knocked_back_facing_right
	ld de, BeamBotFrameset_68ece
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
	ld_obj_frameset BeamBotFrameset_68eb7, BeamBotFrameset_68ec0
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
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	jr .State18
.State18:
	ld hl, wCurObjState
	ld a, OBJSTATE_GRABBED_LEFT
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset BeamBotFrameset_68eb7, BeamBotFrameset_68ec0
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
	xor OBJSUBFLAG_HDIR
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

BeamFunc_Left:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_BEAM
.Update:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .ok
	dec [hl]
	jr nz, .ok
	ld de, BeamBotFrameset_68ef3
	call SetObjectFramesetPtr
.ok
	ld bc, BeamBotData_60610
	jr BeamFunc

BeamFunc_Right:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_BEAM
.Update:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .ok
	dec [hl]
	jr nz, .ok
	ld de, BeamBotFrameset_68ef8
	call SetObjectFramesetPtr
.ok
	ld bc, BeamBotData_60630
;	fallthrough

BeamFunc:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .apply_movement
	xor a
	ld [hl], a
	play_sfx SFX_FAN_SPIN
.apply_movement
	jp ApplyObjXMovement
