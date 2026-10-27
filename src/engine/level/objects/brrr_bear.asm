BrrrBearFunc:
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
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $08
	ld [hld], a
	ld a, $f7
	ld [hld], a
	ld a, $f9
	ld [hl], a
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

.VanishTouch:
	ld a, [wCurObjAction]
	and a
	jp z, VanishObject2
	ld a, [wTransformation]
	and a
	jp nz, VanishObject2
	ld a, [wEffectivePowerUp]
	cp $06
	jp nc, VanishObject2
	ld a, [wCurObjInteractionType]
	and $7f
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

.Default:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
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
	jr c, .asm_48147
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, BrrrBearFrameset_69115
	call SetObjectFramesetPtr
	ret
.asm_48147
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, BrrrBearFrameset_69126
	call SetObjectFramesetPtr
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_48166
	xor a
	ld [hld], a
	ld de, BrrrBearFrameset_69115
	call SetObjectFramesetPtr
	ret

.asm_48166
	xor a
	ld [hld], a
	ld de, BrrrBearFrameset_69126
	call SetObjectFramesetPtr
	ret

.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_48180
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_48180
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_481a4
	ld a, [hl]
	cp $22
	ret nz
	play_sfx SFX_07E
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_4819e
	ld bc, ObjParams_SnowflakeLeft
	jp CreateObjectAtRelativePos
.asm_4819e
	ld bc, ObjParams_SnowflakeRight
	jp CreateObjectAtRelativePos
.asm_481a4
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
	jr c, .asm_481c3
	ld de, BrrrBearFrameset_69115
	call SetObjectFramesetPtr
	ret

.asm_481c3
	ld de, BrrrBearFrameset_69126
	call SetObjectFramesetPtr
	ret

.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_481db
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_481db
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
	jr c, .asm_481ef
	cp $e8
	jr c, .asm_48222
.asm_481ef
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $b8
	jr nc, .asm_48211
	cp $48
	jr nc, .asm_48222
	ld a, [hli]
	rlca
	jr c, .asm_4820d
	ld de, BrrrBearFrameset_6913d
	jr .asm_48218
.asm_4820d
	ld a, $13
	ld [hl], a
	ret

.asm_48211
	ld a, [hli]
	rlca
	jr nc, .asm_4820d
	ld de, BrrrBearFrameset_6914c
.asm_48218
	ld a, $2d
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, $39
	ld [hli], a
	ret

.asm_48222
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
	jr nz, .asm_4823d
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_4823d
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_4827e
	ld a, [hl]
	and $0f
	sub $08
	jr nc, .asm_4825a
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_48278
.asm_4825a
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
.asm_48278
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_4827e
	ld a, [hl]
	and $0f
	add $07
	cp $10
	jr c, .asm_4828e
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_482ac
.asm_4828e
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
.asm_482ac
	ld a, $13
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_482c0
.BumpRightStart:
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_482c0
	ld a, [hld]
	rlca
	ld_obj_frameset BrrrBearFrameset_69137, BrrrBearFrameset_6913a
	call SetObjectFramesetPtr
	ld a, $0c
	ld [hld], a
	ld a, $02
	ld [wCurObjVar2], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ret

.StunLeftStart:
	ld a, $46
	ld [wCurObjState], a
	ld de, BrrrBearFrameset_6915b
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
	ld a, $0f
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld a, $47
	ld [wCurObjState], a
	ld de, BrrrBearFrameset_6915b
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
	ld a, $0f
	ld [wCurObjState], a
	ret

.State14:
	ld a, $44
	jr .asm_48328
.State15:
	ld a, $45
.asm_48328
	ld [wCurObjState], a
	ld de, BrrrBearFrameset_6915b
	call SetObjectFramesetPtr
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
	ld a, $3f
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_4835d
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_4835d
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
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_48385
	ld de, BrrrBearFrameset_69183
	res OBJSUBFLAG_HDIR_F, [hl]
	jr .asm_4838a
.asm_48385
	ld de, BrrrBearFrameset_6918e
	set OBJSUBFLAG_HDIR_F, [hl]
.asm_4838a
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hld], a
	ret

.State40:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $01
	ld [wCurObjState], a
	ret

.TurnAroundStart:
	ld hl, wCurObjState
	ld a, $43
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset BrrrBearFrameset_69175, BrrrBearFrameset_6917c
	call SetObjectFramesetPtr
	ld a, $16
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
	jr c, .asm_483d6
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_483d6
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $06
	jr z, .asm_483e8
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.asm_483e8
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_483f2
	set OBJSUBFLAG_HDIR_F, [hl]
	ret
.asm_483f2
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_48407

.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_48407
	ld [hld], a
	ld de, BrrrBearFrameset_6915b
	call SetObjectFramesetPtr
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
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_4847a
.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_4847a
.AttackedLeftStart:
	ld a, [wTransformation]
	and a
	jr nz, .asm_4844e
	ld a, [wEffectivePowerUp]
	cp $05
	jr nc, .asm_4844e
	ld a, [wCurObjInteractionType]
	and $7f
	jr z, .asm_4844e
	ld a, $08
	ld [wCurObjState], a
	ret

.asm_4844e
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $01
	jr .asm_4847a
.AttackedRightStart:
	ld a, [wTransformation]
	and a
	jr nz, .asm_48472
	ld a, [wEffectivePowerUp]
	cp $05
	jr nc, .asm_48472
	ld a, [wCurObjInteractionType]
	and $7f
	jr z, .asm_48472
	ld a, $09
	ld [wCurObjState], a
	ret

.asm_48472
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $01
.asm_4847a
	ld a, [hl]
	and $f0
	ld [hld], a
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld de, BrrrBearFrameset_69164
	call SetObjectFramesetPtr
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

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
	ld a, $49
	ld [wCurObjState], a
	ld de, BrrrBearFrameset_6915b
	call SetObjectFramesetPtr
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
	ld a, $48
	ld [wCurObjState], a
	ld de, BrrrBearFrameset_6915b
	call SetObjectFramesetPtr
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
	ld [hld], a
	ret

SnowflakeFunc_Left:
	call MoveObjectLeft_Fast
	jr SnowflakeFunc
SnowflakeFunc_Right:
	call MoveObjectRight_Fast
SnowflakeFunc:
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wCurObjState]
	and a
	ret z
	ld de, BrrrBearFrameset_6916e
	call SetObjectFramesetPtr
	ld a, $0c
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret
