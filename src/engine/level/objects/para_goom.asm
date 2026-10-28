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
	ld a, OBJSTATE_FULL_THROW_LEFT
	ld [wCurObjState], a
	ld de, ParaGoomFrameset_684a1
	call SetObjectFramesetPtr
	jp ObjState_FullThrowLeft

.FullThrowRightStart:
	ld a, OBJSTATE_FULL_THROW_RIGHT
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
	or OBJ_INTERACTION_TOUCH
	ld [hli], a
	ld a, $f4
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
	jr c, .asm_4148d
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
	jr .asm_414a0

.asm_4148d
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
.asm_414a0
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
	ld a, OBJSTATE_STANDING_FALL
	ld [hld], a
	xor a
	ld [wCurObjStateDuration], a
	jr .asm_41505

.StandingFallStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STANDING_FALL
	ld [hld], a
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr z, .asm_414e4
	ld a, [hld]
	rlca
	jr c, .asm_414d8
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_684e7
	jr .asm_414dd

.asm_414d8
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_6850a
.asm_414dd
	call SetObjectFramesetPtr
	ld a, $38
	ld [hld], a
	ret

.asm_414e4
	ld a, [hld]
	rlca
	jr c, .asm_414ef
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_6852d
	jr .asm_414f4

.asm_414ef
	xor a
	ld [hld], a
	ld de, ParaGoomFrameset_68546
.asm_414f4
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
.asm_41505
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
	jr c, .asm_41528
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_41528
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	jr .asm_41570

.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_41540
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_41540
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
.asm_41545
	ld l, OBJ_STATE
	ld a, OBJSTATE_WALK
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
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
.asm_41570
	ld l, OBJ_STATE
	ld a, OBJSTATE_WALK
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41586
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f6
	ld [hld], a
	ld de, ParaGoomFrameset_68439
	jr .asm_41591

.asm_41586
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $09
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld de, ParaGoomFrameset_68442
.asm_41591
	call SetObjectFramesetPtr
	ld a, $0a
	ld [hli], a
	ret

.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_415a9
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_415a9
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_415bb
	dec [hl]
	ret nz
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_STING
	ld [hld], a
	ret

.asm_415bb
	inc l
	inc [hl]
	jr nz, .asm_41611
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr nz, .asm_415e9
	ld l, OBJ_STATE
	ld a, OBJSTATE_SPECIAL_2
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
	or OBJ_INTERACTION_TOUCH
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ret

.asm_415e9
	ld l, OBJ_STATE
	ld a, OBJSTATE_SPECIAL_1
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
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ret

.asm_41611
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
	jr nz, .asm_4162c
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
	ret

.asm_4162c
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_41677
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hl]
	and $0f
	sub b
	jr nc, .asm_4164e
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_41671
.asm_4164e
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
.asm_41671
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.asm_41677
	ld a, [wCurObjCollBoxRight]
	ld b, a
	ld a, [hl]
	and $0f
	add b
	cp $10
	jr c, .asm_4168a
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_416aa
.asm_4168a
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
.asm_416aa
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	jr .asm_416be

.BumpRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_RIGHT
	ld [hld], a
.asm_416be
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr z, .asm_416ed
	ld a, [hld]
	rlca
	ld_obj_frameset ParaGoomFrameset_68439, ParaGoomFrameset_68442
.asm_416d1
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
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ret

.asm_416ed
	ld a, [hld]
	rlca
	jr c, .asm_416f6
	ld de, ParaGoomFrameset_6844b
	jr .asm_416d1

.asm_416f6
	ld de, ParaGoomFrameset_68454
	jr .asm_416d1

.StunLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_LEFT
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
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_RIGHT
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
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL_LEFT
	ld [hld], a
	jr .asm_41775

.State15:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL_RIGHT
	ld [hld], a
.asm_41775
	ld a, [hld]
	rlca
	jr c, .asm_41781
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .asm_41787

.asm_41781
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.asm_41787
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
	ld a, OBJSTATE_STUNNED
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_417be
	ld a, OBJSTATE_RANDOM_WOBBLE_START
	ld [wCurObjState], a
	ret

.asm_417be
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
	jr z, .asm_4180d
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
	jr nz, .asm_4180d
	ld bc, ParaGoomData_60530
	jp ApplyObjYMovement
.asm_4180d
	ld a, OBJSTATE_5A
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
	ld a, OBJSTATE_5B
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
	jr nz, .asm_41857
	ld a, [wIsInWaterOrSand]
	and a
	ret z
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	ret

.asm_41857
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_5C
	ld [hld], a
	ld de, ParaGoomFrameset_6855f
	call SetObjectFramesetPtr
	ld a, $0a
	ld [hli], a
	ret

.State5c:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_41880
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_41880
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, OBJSTATE_DEFAULT
	ld [wCurObjState], a
	ret

.TurnAroundStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_TURN_AROUND
	ld [hld], a
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jr z, .asm_418ae
	ld a, [hld]
	rlca
	jr c, .asm_418a4
	ld de, ParaGoomFrameset_684cb
	call SetObjectFramesetPtr
	jr .asm_418aa

.asm_418a4
	ld de, ParaGoomFrameset_684d2
	call SetObjectFramesetPtr
.asm_418aa
	ld a, $44
	ld [hli], a
	ret

.asm_418ae
	ld a, [hld]
	rlca
	jr c, .asm_418ba
	ld de, ParaGoomFrameset_684d9
	call SetObjectFramesetPtr
	jr .asm_418c0

.asm_418ba
	ld de, ParaGoomFrameset_684e0
	call SetObjectFramesetPtr
.asm_418c0
	ld a, $44
	ld [hli], a
	ret

.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_418d5
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_418d5
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $27
	jr z, .asm_418ef
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, [wCurObjCollBoxTop]
	cp $ef
	jp z, .asm_41545
	ld a, OBJSTATE_LAND
	ld [wCurObjState], a
	ret

.asm_418ef
	dec [hl]
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_41901
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_41901
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
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_LEFT
	jr .asm_41924

.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_RIGHT
.asm_41924
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41931
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .asm_41937

.asm_41931
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.asm_41937
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
	ld a, OBJSTATE_HIT_WARIO_RIGHT
	ld [wCurObjState], a
	jr .asm_41960

.State0c:
	ld a, OBJSTATE_HIT_WARIO_LEFT
	ld [wCurObjState], a
.asm_41960
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
	jr .asm_419b8

.State28:
	ld hl, wCurObjState
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT
	ld [hld], a
	ld b, $02
	jr .asm_419b8

.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_LEFT
	ld [hld], a
	ld b, $02
	jr .asm_419b8

.AttackedRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_RIGHT
	ld [hld], a
	ld b, $02
.asm_419b8
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
	jr c, .asm_419cf
	ld de, ParaGoomFrameset_684aa
	jp SetObjectFramesetPtr
.asm_419cf
	ld de, ParaGoomFrameset_684af
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
	jr c, .asm_41a0d
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .asm_41a13

.asm_41a0d
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.asm_41a13
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
	jr c, .asm_41a41
	ld de, ParaGoomFrameset_684aa
	call SetObjectFramesetPtr
	jr .asm_41a47

.asm_41a41
	ld de, ParaGoomFrameset_684af
	call SetObjectFramesetPtr
.asm_41a47
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
	ld [hli], a
	ld a, $f4
	ld [hl], a
	ret
