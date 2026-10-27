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
	ld a, $30
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_4437f
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, HammerBotFrameset_68b12
	call SetObjectFramesetPtr
	ret

.asm_4437f
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, HammerBotFrameset_68b17
	call SetObjectFramesetPtr
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_4439e
	xor a
	ld [hld], a
	ld de, HammerBotFrameset_68b12
	call SetObjectFramesetPtr
	ret

.asm_4439e
	xor a
	ld [hld], a
	ld de, HammerBotFrameset_68b17
	call SetObjectFramesetPtr
	ret

.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_443b4
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_443b4
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $2e
	ld [wCurObjState], a
	ret

.Special2:
	ld a, [wGlobalCounter]
	ld b, a
	and $0f
	play_sfx z, SFX_HAMMER_BOT_WALK
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_443dc
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_443dc
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
	jr nz, .asm_443f7
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_443f7
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_44438
	ld a, [hl]
	and $0f
	sub $10
	jr nc, .asm_44414
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_44432
.asm_44414
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
.asm_44432
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_44438
	ld a, [hl]
	and $0f
	add $0f
	cp $10
	jr c, .asm_44448
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_44466
.asm_44448
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
.asm_44466
	ld a, $13
	ld [wCurObjState], a
	ret

.Land:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ld l, OBJ_STATE
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_44485
	ld de, HammerBotFrameset_68b12
	call SetObjectFramesetPtr
	ret

.asm_44485
	ld de, HammerBotFrameset_68b17
	call SetObjectFramesetPtr
	ret

.Walk:
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .asm_444a3
	ld a, [wGlobalCounter]
	ld b, a
	and $1f
	play_sfx z, SFX_HAMMER_BOT_WALK
.asm_444a3
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_444b0
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_444b0
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
	jr nz, .asm_444cb
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_444cb
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld c, $2a
	ld a, [wCurObjSubState]
	rlca
	jp c, .asm_4454e
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
	jr c, .asm_444ef
	cp $e8
	jr c, .asm_4451c
.asm_444ef
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $40
	jr nc, .asm_4451c
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
	ld a, $2d
	ld [hld], a
	ret

.asm_4451c
	ld a, [hl]
	and $0f
	sub $08
	jr nc, .asm_4452a
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_44548
.asm_4452a
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
.asm_44548
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_4454e
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
	jr c, .asm_44560
	cp $e8
	jr c, .asm_4458d
.asm_44560
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $c0
	jr c, .asm_4458d
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
	ld a, $2d
	ld [hld], a
	ret

.asm_4458d
	ld a, [hl]
	and $0f
	add $07
	cp $10
	jr c, .asm_4459d
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_445bb
.asm_4459d
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
.asm_445bb
	ld a, $13
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_445cf
.BumpRightStart:
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_445cf
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
	ld a, $46
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
	ld a, $0f
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, $47
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
	ld a, $0f
	ld [wCurObjState], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, $44
	ld [hld], a
	jr .asm_4466b
.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_4466b
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
	ld a, $3f
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_446ae
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_446ae
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
	ld a, $07
	ld [wCurObjStateDuration], a
.State40:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ApplyObjHopYVel
	ld a, $00
	ld [wCurObjState], a
	ret

.TurnAroundStart:
	ld hl, wCurObjState
	ld a, $43
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
	jr c, .asm_44710
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_44710
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $09
	jr z, .asm_44722
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.asm_44722
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_4472c
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_4472c
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_44741

.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_44741
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
	ld a, $3b
	ld [wCurObjState], a
	ld bc, ObjParams_StarsLeft
	ld de, HammerBotFrameset_68b5e
	jr .asm_44783
.State0c:
	ld a, $3c
	ld [wCurObjState], a
	ld bc, ObjParams_StarsRight
	ld de, HammerBotFrameset_68b61
.asm_44783
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
	ld a, $13
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
	ld a, $13
	ld [wCurObjState], a
	ret

.State29:
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_4481b

.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_4481b

.AttackedLeftStart:
	ld a, [wTransformation]
	and a
	jr nz, .asm_447ef
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr nc, .asm_447ef
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .asm_447ef
	ld a, $08
	ld [wCurObjState], a
	ret

.asm_447ef
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $01
	jr .asm_4481b

.AttackedRightStart:
	ld a, [wTransformation]
	and a
	jr nz, .asm_44813
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr nc, .asm_44813
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .asm_44813
	ld a, $09
	ld [wCurObjState], a
	ret

.asm_44813
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $01
.asm_4481b
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
	jr c, .asm_44833
	ld de, HammerBotFrameset_68b40
	jp SetObjectFramesetPtr
.asm_44833
	ld de, HammerBotFrameset_68b45
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
	ld a, $48
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
	ld [hld], a
	ret
