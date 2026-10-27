MadSciensteinFunc:
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
	play_sfx SFX_014
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jp nc, .WobbleLeftStart
	jp .WobbleRightStart

.State5a:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_44e5d
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_44e5d
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $18
	jr z, .asm_44e86
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $2b
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_44e7c
	ld de, MadSciensteinFrameset_68c25
	call SetObjectFramesetPtr
	ld a, 28
	ld [hli], a
	ret

.asm_44e7c
	ld de, MadSciensteinFrameset_68c2c
	call SetObjectFramesetPtr
	ld a, 28
	ld [hli], a
	ret

.asm_44e86
	dec [hl]
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	play_sfx nz, SFX_067

	ld l, OBJ_STATE
	ld a, $5a
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_44ea4
	ld bc, ObjParams_InvisibilityPotionLeft
	jp CreateObjectAtRelativePos
.asm_44ea4
	ld bc, ObjParams_InvisibilityPotionRight
	jp CreateObjectAtRelativePos

.State2b:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .asm_44ecd
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $5b
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_44ec6
	ld de, MadSciensteinFrameset_68bd1
	call SetObjectFramesetPtr
	ret

.asm_44ec6
	ld de, MadSciensteinFrameset_68bda
	call SetObjectFramesetPtr
	ret

.asm_44ecd
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_44ed7
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_44ed7
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State5b:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_44ee7
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_44ee7
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
	jr nz, .asm_44f02
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_44f02
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_44f4c
	ld a, [hl]
	and $0f
	sub $07
	jr nc, .asm_44f1f
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_44f3d
.asm_44f1f
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $07
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
.asm_44f3d
	ld a, $2c
	ld [wCurObjState], a
	ld de, MadSciensteinFrameset_68c25
	call SetObjectFramesetPtr
	ld a, 28
	ld [hli], a
	ret

.asm_44f4c
	ld a, [hl]
	and $0f
	add $06
	cp $10
	jr c, .asm_44f5c
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_44f7a
.asm_44f5c
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $06
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
.asm_44f7a
	ld a, $2c
	ld [wCurObjState], a
	ld de, MadSciensteinFrameset_68c2c
	call SetObjectFramesetPtr
	ld a, 28
	ld [hli], a
	ret

.State2c:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .asm_44fb2
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $5c
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_44fa8
	ld de, MadSciensteinFrameset_68bff
	call SetObjectFramesetPtr
	ld a, 63
	ld [hli], a
	ret

.asm_44fa8
	ld de, MadSciensteinFrameset_68c08
	call SetObjectFramesetPtr
	ld a, 63
	ld [hli], a
	ret

.asm_44fb2
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_44fbc
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_44fbc
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State5c:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_44fcc
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_44fcc
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.Default:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $ff
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
	jr c, .asm_4500c
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, MadSciensteinFrameset_68bb5
	call SetObjectFramesetPtr
	ret

.asm_4500c
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, MadSciensteinFrameset_68bbe
	call SetObjectFramesetPtr
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_4502b
	xor a
	ld [hld], a
	ld de, MadSciensteinFrameset_68bb5
	call SetObjectFramesetPtr
	ret

.asm_4502b
	xor a
	ld [hld], a
	ld de, MadSciensteinFrameset_68bbe
	call SetObjectFramesetPtr
	ret

.Land:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
	ld l, OBJ_STATE
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_4504d
	ld de, MadSciensteinFrameset_68bb5
	call SetObjectFramesetPtr
	ret

.asm_4504d
	ld de, MadSciensteinFrameset_68bbe
	call SetObjectFramesetPtr
	ret

.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_45061
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_45061
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $20
	jr c, .asm_45075
	cp $e0
	jr c, .asm_450b0
.asm_45075
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $c0
	jr nc, .asm_4509f
	cp $40
	jr nc, .asm_450b0
	ld a, [hli]
	rlca
	jr c, .asm_4509b
	ld a, $5a
	ld [hl], a
	ld de, MadSciensteinFrameset_68bed
	call SetObjectFramesetPtr
	ld a, 63
	ld [hli], a
	ret

.asm_4509b
	ld a, $13
	ld [hl], a
	ret

.asm_4509f
	ld a, [hli]
	rlca
	jr nc, .asm_4509b
	ld a, $5a
	ld [hl], a
	ld de, MadSciensteinFrameset_68bf6
	call SetObjectFramesetPtr
	ld a, 63
	ld [hli], a
	ret

.asm_450b0
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
	jr nz, .asm_450cb
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_450cb
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_4510c
	ld a, [hl]
	and $0f
	sub $07
	jr nc, .asm_450e8
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_45106
.asm_450e8
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $07
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Slow
.asm_45106
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_4510c
	ld a, [hl]
	and $0f
	add $06
	cp $10
	jr c, .asm_4511c
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_4513a
.asm_4511c
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $06
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Slow
.asm_4513a
	ld a, $13
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld a, [wCurObjFrame]
	cp $19
	jr nc, .asm_45155
	cp $14
	jr nc, .asm_4514f
	cp $06
	jr nc, .asm_45155
.asm_4514f
	ld bc, ObjParams_InvisibilityPotionDropLeft
	call CreateObjectAtRelativePos
.asm_45155
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_451a1

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
	jr c, .asm_4517c
	ld a, $2b
	ld [hl], a
	ld de, MadSciensteinFrameset_68c25
	call SetObjectFramesetPtr
	ld a, 28
	ld [hli], a
	ret

.asm_4517c
	ld a, $5b
	ld [hl], a
	ld de, MadSciensteinFrameset_68bda
	call SetObjectFramesetPtr
	ret

.BumpRightStart:
	ld a, [wCurObjFrame]
	cp $19
	jr nc, .asm_4519b
	cp $14
	jr nc, .asm_45195
	cp $06
	jr nc, .asm_4519b
.asm_45195
	ld bc, ObjParams_InvisibilityPotionDropRight
	call CreateObjectAtRelativePos
.asm_4519b
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_451a1
	ld a, [hld]
	rlca
	jr c, .asm_451ad
	ld de, MadSciensteinFrameset_68bc7
	call SetObjectFramesetPtr
	jr .asm_451b3
.asm_451ad
	ld de, MadSciensteinFrameset_68bcc
	call SetObjectFramesetPtr
.asm_451b3
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
	jr c, .asm_451d8
	ld a, $5b
	ld [hl], a
	ld de, MadSciensteinFrameset_68bd1
	call SetObjectFramesetPtr
	ret

.asm_451d8
	ld a, $2b
	ld [hl], a
	ld de, MadSciensteinFrameset_68c2c
	call SetObjectFramesetPtr
	ld a, 28
	ld [hli], a
	ret

.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset MadSciensteinFrameset_68be3, MadSciensteinFrameset_68be8
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_00
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
	ld_obj_frameset MadSciensteinFrameset_68be3, MadSciensteinFrameset_68be8
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_00
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
	jr .asm_45249

.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_45249
	ld a, [hld]
	rlca
	jr c, .asm_45255
	ld de, MadSciensteinFrameset_68be3
	call SetObjectFramesetPtr
	jr .asm_4525b
.asm_45255
	ld de, MadSciensteinFrameset_68be8
	call SetObjectFramesetPtr
.asm_4525b
	inc l
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_00
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
	jr c, .asm_45287
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_45287
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
	jr c, .asm_452c1
	ld de, MadSciensteinFrameset_68c17
	call SetObjectFramesetPtr
	jr .asm_452c7
.asm_452c1
	ld de, MadSciensteinFrameset_68c1e
	call SetObjectFramesetPtr
.asm_452c7
	ld a, $1c
	ld [hli], a
	ret

.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_452d8
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_452d8
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .asm_452ea
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.asm_452ea
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_452f4
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_452f4
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_45309
.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_45309
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_45316
	ld de, MadSciensteinFrameset_68be3
	call SetObjectFramesetPtr
	jr .asm_4531c
.asm_45316
	ld de, MadSciensteinFrameset_68be8
	call SetObjectFramesetPtr
.asm_4531c
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
	or OBJ_INTERACTION_00
	ld [hld], a
	ret

.State29:
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_45388

.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_45388

.AttackedLeftStart:
	ld a, [wTransformation]
	and a
	jr nz, .asm_4535c
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr nc, .asm_4535c
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .asm_4535c
	ld a, $08
	ld [wCurObjState], a
	ret

.asm_4535c
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $01
	jr .asm_45388

.AttackedRightStart:
	ld a, [wTransformation]
	and a
	jr nz, .asm_45380
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr nc, .asm_45380
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .asm_45380
	ld a, $09
	ld [wCurObjState], a
	ret

.asm_45380
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $01
.asm_45388
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
	jr c, .asm_453a0
	ld de, MadSciensteinFrameset_68c11
	jp SetObjectFramesetPtr
.asm_453a0
	ld de, MadSciensteinFrameset_68c14
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
	jr c, .asm_453de
	ld de, MadSciensteinFrameset_68be3
	call SetObjectFramesetPtr
	jr .asm_453e4
.asm_453de
	ld de, MadSciensteinFrameset_68be8
	call SetObjectFramesetPtr
.asm_453e4
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
	jr c, .asm_4540a
	ld de, MadSciensteinFrameset_68be3
	call SetObjectFramesetPtr
	jr .asm_45410
.asm_4540a
	ld de, MadSciensteinFrameset_68be8
	call SetObjectFramesetPtr
.asm_45410
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
	or OBJ_INTERACTION_00
	ld [hld], a
	ret

InvisibilityPotionFunc_Left:
	call MoveObjectLeft_Fast
	jr InvisibilityPotionFunc
InvisibilityPotionFunc_Right:
	call MoveObjectRight_Fast
InvisibilityPotionFunc:
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wCurObjState]
	cp $18
	jr z, DestroyInvisibilityPotion
	ld bc, SmallHopYVel2
	jp ApplyObjYMovement

InvisibilityPotion_CheckFloor:
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
	ret z
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
DestroyInvisibilityPotion:
	farcall VanishObject_NoSFX
	ret

InvisibilityPotionFunc_Drop:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	dec l
	ld a, $8f
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]

.Update:
	ld a, [wCurObjState]
	cp $18
	jr z, DestroyInvisibilityPotion
	ld bc, JumpArcYVel
	call ApplyObjYMovement
	jr InvisibilityPotion_CheckFloor
