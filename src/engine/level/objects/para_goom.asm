ParaGoomFunc:
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
	dw .State0b
	dw .State0c
	dw .State0d
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
	dw .State3b
	dw .State3c
	dw .Default
	dw .Default
	dw .State3f
	dw .State40
	dw .StandingFall
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
	dw .State5a
	dw .State5b
	dw .State5c
	dw .Default
	dw ObjState_FullThrowLeft
	dw ObjState_FullThrowRight

.FullThrowLeftStart:
	ld a, $5e
	ld [wCurObjState], a
	ld de, ParaGoomFrameset_684a1
	call SetObjectFramesetPtr
	jp ObjState_FullThrowLeft

.FullThrowRightStart:
	ld a, $5f
	ld [wCurObjState], a
	ld de, ParaGoomFrameset_684a1
	call SetObjectFramesetPtr
	jp ObjState_FullThrowRight

.Default:
	xor a
	ld [wCurObjVar1], a
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ld l, OBJ_STATE
	ld a, $30
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJFLAG_PRIORITY_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_68439
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f6
	ld [hld], a
	jr .check_floor

.face_right
	set OBJFLAG_PRIORITY_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_68442
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $09
	ld [hld], a
	ld a, $f9
	ld [hld], a
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
	call ProcessBlock_Landing
	and a
	ret nz
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	xor a
	ld [wCurObjStateDuration], a
	jr .extend_propeller

.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr z, .propeller_standing_fall
	ld a, [hld]
	rlca
	jr c, .standing_fall_right
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_684e7
	jr .set_standing_fall_frameset

.standing_fall_right
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_6850a
.set_standing_fall_frameset
	call SetObjectFramesetPtr
	ld a, $38
	ld [hld], a
	ret

.propeller_standing_fall
	ld a, [hld]
	rlca
	jr c, .propeller_fall_right
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_6852d
	jr .set_propeller_fall_frameset

.propeller_fall_right
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_68546
.set_propeller_fall_frameset
	call SetObjectFramesetPtr
	ld a, $29
	ld [hld], a
	ret

.StandingFall:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jp z, .State5b
	dec [hl]
	ret nz
.extend_propeller
	ld de, ParaGoomFrameset_684ba
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOP_STING
	ld [hli], a
	ld a, $ef
	ld [hl], a
	ret

.Special2:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .retract_count_down
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.retract_count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	jr .walk_without_propeller

.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .extend_count_down
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.extend_count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
.walk_with_propeller
	ld l, OBJ_STATE
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_6844b, ParaGoomFrameset_68454
	call SetObjectFramesetPtr
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOP_STING
	ld [hli], a
	ld a, $ef
	ld [hl], a
	ret

.Land:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
.walk_without_propeller
	ld l, OBJ_STATE
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .walk_facing_right
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f6
	ld [hld], a
	ld de, ParaGoomFrameset_68439
	jr .set_walk_frameset

.walk_facing_right
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $09
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld de, ParaGoomFrameset_68442
.set_walk_frameset
	call SetObjectFramesetPtr
	ld a, $0a
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
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .propeller_timer
	dec [hl]
	ret nz
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_STING
	ld [hld], a
	ret

.propeller_timer
	inc l
	inc [hl]
	jr nz, .walk_on
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr nz, .start_extend
	ld l, OBJ_STATE
	ld a, $2e
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_6846e, ParaGoomFrameset_68490
	call SetObjectFramesetPtr
	ld a, $a3
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ret

.start_extend
	ld l, OBJ_STATE
	ld a, $2d
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_6845d, ParaGoomFrameset_6847f
	call SetObjectFramesetPtr
	ld a, $a3
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld a, $11
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
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hl]
	and $0f
	sub b
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
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Slow
.turn_at_edge_left
	ld a, $13
	ld [wCurObjState], a
	ret

.walk_right
	ld a, [wCurObjCollBoxRight]
	ld b, a
	ld a, [hl]
	and $0f
	add b
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
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Slow
.turn_at_edge_right
	ld a, $13
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .set_bump

.BumpRightStart:
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.set_bump
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr z, .propeller_bump
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_68439, ParaGoomFrameset_68442
.set_bump_frameset
	call SetObjectFramesetPtr
	ld a, $0c
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
	or OBJ_INTERACTION_01
	ld [hld], a
	ret

.propeller_bump
	ld a, [hld]
	rlca
	jr c, .propeller_bump_right
	ld de, ParaGoomFrameset_6844b
	jr .set_bump_frameset

.propeller_bump_right
	ld de, ParaGoomFrameset_68454
	jr .set_bump_frameset

.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_684aa, ParaGoomFrameset_684af
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
	ld [hli], a
	ld a, $f4
	ld [hl], a
.StunLeft:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld a, $0f
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, $47
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_684aa, ParaGoomFrameset_684af
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
	ld [hli], a
	ld a, $f4
	ld [hl], a
.StunRight:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld a, $0f
	ld [wCurObjState], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, $44
	ld [hld], a
	jr .set_fall

.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.set_fall
	ld a, [hld]
	rlca
	jr c, .fall_facing_right
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .set_fall_vars

.fall_facing_right
	ld de, ParaGoomFrameset_684af
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
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ret

.State0f:
	ld a, $3f
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .count_down
	ld a, $1c
	ld [wCurObjState], a
	ret

.count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrDrop
	ld a, $10
	ld [wCurObjState], a
	ret

.State10:
	ld hl, wCurObjState
	ld a, $40
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_684b4
	call SetObjectFramesetPtr
	ld a, $08
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOP_STING
	ld [hli], a
	ld a, $ef
	ld [hl], a
.State40:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .start_hover
	ld l, OBJ_Y_POS
	ld a, [hli]
	sub $08
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and $0f
	jr nz, .start_hover
	ld bc, ParaGoomData_60530
	jp ApplyObjYMovement
.start_hover
	ld a, $5a
	ld [wCurObjState], a
	ld de, ParaGoomFrameset_684b7
	call SetObjectFramesetPtr
	ld a, $04
	ld [hli], a
	ret

.State5a:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_STATE
	ld a, $5b
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_684ba
	call SetObjectFramesetPtr
	ret

.State5b:
	call MoveObjectDown_Slow
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
	ld [wObjSlopeInteraction], a
	call ProcessBlock_Landing
	and a
	jr nz, .landed
	ld a, [wIsInWaterOrSand]
	and a
	ret z
	ld a, $0a
	ld [wCurObjState], a
	ret

.landed
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_STATE
	ld a, $5c
	ld [hld], a
	ld de, ParaGoomFrameset_6855f
	call SetObjectFramesetPtr
	ld a, $0a
	ld [hli], a
	ret

.State5c:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .land_count_down
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.land_count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $00
	ld [wCurObjState], a
	ret

.TurnAroundStart:
	ld hl, wCurObjState
	ld a, $43
	ld [hld], a
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr z, .propeller_turn
	ld a, [hld]
	rlca
	jr c, .turn_facing_right
	ld de, ParaGoomFrameset_684cb
	call SetObjectFramesetPtr
	jr .set_turn_duration

.turn_facing_right
	ld de, ParaGoomFrameset_684d2
	call SetObjectFramesetPtr
.set_turn_duration
	ld a, $44
	ld [hli], a
	ret

.propeller_turn
	ld a, [hld]
	rlca
	jr c, .propeller_turn_right
	ld de, ParaGoomFrameset_684d9
	call SetObjectFramesetPtr
	jr .set_propeller_turn_duration

.propeller_turn_right
	ld de, ParaGoomFrameset_684e0
	call SetObjectFramesetPtr
.set_propeller_turn_duration
	ld a, $44
	ld [hli], a
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
	cp $27
	jr z, .flip_direction
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jp z, .walk_with_propeller
	ld a, $01
	ld [wCurObjState], a
	ret

.flip_direction
	dec [hl]
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .face_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.face_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State0d:
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .WobbleRightStart
.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .set_wobble

.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.set_wobble
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .wobble_facing_right
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .set_wobble_vars

.wobble_facing_right
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.set_wobble_vars
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
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ret

.State0b:
	ld a, $3b
	ld [wCurObjState], a
	jr .set_hit_wario

.State0c:
	ld a, $3c
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
	ld a, $13
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
	ld a, $13
	ld [wCurObjState], a
	ret

.State29:
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .set_knocked_back

.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .set_knocked_back

.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $02
	jr .set_knocked_back

.AttackedRightStart:
	ld hl, wCurObjState
	ld a, $35
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
	ld [hl], b
	ld a, c
	rlca
	jr c, .knocked_back_facing_right
	ld de, ParaGoomFrameset_684aa
	jp SetObjectFramesetPtr
.knocked_back_facing_right
	ld de, ParaGoomFrameset_684af
	jp SetObjectFramesetPtr
.PickedUpLeftStart:
	ld hl, wCurObjState
	ld a, $36
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
	ld a, $37
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
	ld a, $49
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .grabbed_right_facing_right
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .set_grabbed_right

.grabbed_right_facing_right
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.set_grabbed_right
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
	ld a, $48
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .grabbed_left_facing_right
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .set_grabbed_left

.grabbed_left_facing_right
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.set_grabbed_left
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
	ld a, $42
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ret
