HammerBotFunc:
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
	dw .VanishTouch
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

.VanishTouch:
	ld a, [wCurObjAction]
	and a
	jp z, VanishObject2
	ld a, [wTransformation]
	and a
	jp nz, VanishObject2
	ld a, [wEffectivePowerUp]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp nc, VanishObject2
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jp z, VanishObject2
	play_sfx SFX_STOMP
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jp nc, .WobbleLeftStart
	jp .WobbleRightStart

.Default:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld de, HammerBotFrameset_68b12
	call SetObjectFramesetPtr
	ret

.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, HammerBotFrameset_68b17
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
	ld de, HammerBotFrameset_68b12
	call SetObjectFramesetPtr
	ret

.standing_fall_right
	xor a
	ld [hld], a
	ld de, HammerBotFrameset_68b17
	call SetObjectFramesetPtr
	ret

.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .wind_up
	ld a, OBJSTATE_HOP_START
	ld [wCurObjState], a
	ret

.wind_up
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, OBJSTATE_SPECIAL_2
	ld [wCurObjState], a
	ret

.Special2:
	ld a, [wGlobalCounter]
	ld b, a
	and $0f
	play_sfx z, SFX_HAMMER_BOT_WALK
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .charge
	ld a, OBJSTATE_HOP_START
	ld [wCurObjState], a
	ret

.charge
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
	jr nz, .charge_on_floor
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
	ret

.charge_on_floor
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .charge_right
	ld a, [hl]
	and $0f
	sub $10
	jr nc, .charge_check_wall_left
	call ProcessBlockOnLeft
	and $0f
	jr z, .charge_turn_at_edge_left
.charge_check_wall_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $10
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
.charge_turn_at_edge_left
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.charge_right
	ld a, [hl]
	and $0f
	add $0f
	cp $10
	jr c, .charge_check_wall_right
	call ProcessBlockOnRight
	and $0f
	jr z, .charge_turn_at_edge_right
.charge_check_wall_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $0f
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
.charge_turn_at_edge_right
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
	jr c, .land_facing_right
	ld de, HammerBotFrameset_68b12
	call SetObjectFramesetPtr
	ret

.land_facing_right
	ld de, HammerBotFrameset_68b17
	call SetObjectFramesetPtr
	ret

.Walk:
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .check_shake
	ld a, [wGlobalCounter]
	ld b, a
	and $1f
	play_sfx z, SFX_HAMMER_BOT_WALK
.check_shake
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .walking
	ld a, OBJSTATE_HOP_START
	ld [wCurObjState], a
	ret

.walking
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
	ld c, $2a
	ld a, [wCurObjSubState]
	rlca
	jp c, .facing_right
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
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
	ld de, HammerBotFrameset_68b1c
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f0
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BOUNCY
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_SPECIAL_1
	ld [hld], a
	ret

.walk_left
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

.facing_right
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
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
	ld de, HammerBotFrameset_68b25
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0f
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BOUNCY
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_SPECIAL_1
	ld [hld], a
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
	ld_obj_frameset HammerBotFrameset_68b58, HammerBotFrameset_68b5b
	call SetObjectFramesetPtr
	ld a, 12
	ld [hld], a
	ld a, $02
	ld [wCurObjVar2], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld_obj_frameset HammerBotFrameset_68b2e, HammerBotFrameset_68b37
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld_obj_frameset HammerBotFrameset_68b2e, HammerBotFrameset_68b37
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld_obj_frameset HammerBotFrameset_68b2e, HammerBotFrameset_68b37
	call SetObjectFramesetPtr
	inc l
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld_obj_frameset HammerBotFrameset_68b4a, HammerBotFrameset_68b51
	call SetObjectFramesetPtr
	ld a, 26
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
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
	cp $09
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
	ld_obj_frameset HammerBotFrameset_68b2e, HammerBotFrameset_68b37
	call SetObjectFramesetPtr
	ld a, 4
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld bc, ObjParams_StarsLeft
	ld de, HammerBotFrameset_68b5e
	jr .hit_wario
.State0c:
	ld a, OBJSTATE_HIT_WARIO_LEFT
	ld [wCurObjState], a
	ld bc, ObjParams_StarsRight
	ld de, HammerBotFrameset_68b61
.hit_wario
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ld a, $02
	ld [wCurObjVar2], a
	ld l, OBJ_FLAGS
	res OBJFLAG_PRIORITY_F, [hl]
	play_sfx SFX_HAMMER_HIT
	jp CreateObjectAtRelativePos

.State3b:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.State3c:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
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
	ld a, [wTransformation]
	and a
	jr nz, .attacked_left
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr nc, .attacked_left
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .attacked_left
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [wCurObjState], a
	ret

.attacked_left
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_LEFT
	ld [hld], a
	ld b, $01
	jr .set_knocked_back

.AttackedRightStart:
	ld a, [wTransformation]
	and a
	jr nz, .attacked_right
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr nc, .attacked_right
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .attacked_right
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [wCurObjState], a
	ret

.attacked_right
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_RIGHT
	ld [hld], a
	ld b, $01
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
	ld de, HammerBotFrameset_68b40
	jp SetObjectFramesetPtr
.knocked_back_facing_right
	ld de, HammerBotFrameset_68b45
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
	ld_obj_frameset HammerBotFrameset_68b2e, HammerBotFrameset_68b37
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
	ld_obj_frameset HammerBotFrameset_68b2e, HammerBotFrameset_68b37
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
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
