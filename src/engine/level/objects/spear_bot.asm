SpearBotFunc:
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
	dw .Default

.Default:
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
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
	jr c, .asm_45fef
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, SpearBotFrameset_68ddf
	call SetObjectFramesetPtr
	ret

.asm_45fef
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, SpearBotFrameset_68de8
	call SetObjectFramesetPtr
	ret
.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_46024
	xor a
	ld [hld], a
	ld l, OBJ_COLLBOX_LEFT
	ld a, [hl]
	cp $f6
	jr nz, .asm_4601b
	ld a, $fa
	ld [hl], a
	ld de, SpearBotFrameset_68e69
	call SetObjectFramesetPtr
	ld a, 14
	ld [hli], a
	ret

.asm_4601b
	ld de, SpearBotFrameset_68ddf
	call SetObjectFramesetPtr
	xor a
	ld [hl], a
	ret

.asm_46024
	xor a
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, [hl]
	cp $09
	jr nz, .asm_4603a
	ld a, $05
	ld [hl], a
	ld de, SpearBotFrameset_68e70
	call SetObjectFramesetPtr
	ld a, 14
	ld [hli], a
	ret

.asm_4603a
	ld de, SpearBotFrameset_68de8
	call SetObjectFramesetPtr
	xor a
	ld [hl], a
	ret
.StandingFall:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jp z, ObjState_StandingFall
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_46059
	ld de, SpearBotFrameset_68ddf
	jp SetObjectFramesetPtr
.asm_46059
	ld de, SpearBotFrameset_68de8
	jp SetObjectFramesetPtr
.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_46070
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_46070
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_STATE
	ld a, $2e
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_4608b
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $f6
	ld [hld], a
	ld de, SpearBotFrameset_68e57
	jr .asm_46096
.asm_4608b
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $09
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld de, SpearBotFrameset_68e60
.asm_46096
	call SetObjectFramesetPtr
	inc l
	ld a, $02
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_STING
	ld [hld], a
	ret
.Special2:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_460b7
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_460b7
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
	jr nz, .asm_460d2
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_460d2
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_4611d
	ld a, [hl]
	and $0f
	sub $06
	jr nc, .asm_460ef
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_4610d
.asm_460ef
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
.asm_4610d
	ld a, [wCurObjVar1]
	and a
	jr z, .asm_46118
	ld de, SpearBotFrameset_68e41
	jr .asm_46154
.asm_46118
	ld de, SpearBotFrameset_68dff
	jr .asm_46164
.asm_4611d
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .asm_4612d
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_4614b
.asm_4612d
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
.asm_4614b
	ld a, [wCurObjVar1]
	and a
	jr z, .asm_46161
	ld de, SpearBotFrameset_68e4c
.asm_46154
	call SetObjectFramesetPtr
	ld a, 36
	ld [hli], a
	dec [hl]
	ld a, $5a
	ld [wCurObjState], a
	ret

.asm_46161
	ld de, SpearBotFrameset_68e08
.asm_46164
	call SetObjectFramesetPtr
	ld a, 38
	ld [hli], a
	ld a, $5b
	ld [wCurObjState], a
	ret
.State5b:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_46181
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_46181
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $13
	ld [wCurObjState], a
	ret
.State5a:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_4619d
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_4619d
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $0f
	jr z, .asm_461be
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $2e
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_461b8
	ld de, SpearBotFrameset_68e57
	jp SetObjectFramesetPtr
.asm_461b8
	ld de, SpearBotFrameset_68e60
	jp SetObjectFramesetPtr
.asm_461be
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_461d0
	set OBJSUBFLAG_HDIR_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $09
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ret

.asm_461d0
	res OBJSUBFLAG_HDIR_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $f6
	ld [hld], a
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
	jr c, .asm_461f4
	ld de, SpearBotFrameset_68ddf
	call SetObjectFramesetPtr
	ret

.asm_461f4
	ld de, SpearBotFrameset_68de8
	call SetObjectFramesetPtr
	ret
.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_4620c
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_4620c
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $18
	jr c, .asm_46220
	cp $e8
	jr c, .asm_46253
.asm_46220
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $c0
	jr nc, .asm_46242
	cp $40
	jr nc, .asm_46253
	ld a, [hli]
	rlca
	jr c, .asm_4623e
	ld de, SpearBotFrameset_68df1
	jr .asm_46249
.asm_4623e
	ld a, $13
	ld [hl], a
	ret

.asm_46242
	ld a, [hli]
	rlca
	jr nc, .asm_4623e
	ld de, SpearBotFrameset_68df8
.asm_46249
	ld a, $2d
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ret

.asm_46253
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
	jr nz, .asm_4626e
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_4626e
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_462af
	ld a, [hl]
	and $0f
	sub $06
	jr nc, .asm_4628b
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_462a9
.asm_4628b
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
.asm_462a9
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_462af
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .asm_462bf
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_462dd
.asm_462bf
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
.asm_462dd
	ld a, $13
	ld [wCurObjState], a
	ret
.BumpLeftStart:
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_462f1
.BumpRightStart:
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_462f1
	ld a, [hld]
	rlca
	ld_obj_frameset SpearBotFrameset_68e11, SpearBotFrameset_68e14
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
	or OBJ_INTERACTION_01
	ld [hld], a
	ret
.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset SpearBotFrameset_68e17, SpearBotFrameset_68e20
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	ld_obj_frameset SpearBotFrameset_68e17, SpearBotFrameset_68e20
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
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
	jr .asm_4638d
.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_4638d
	ld a, [hld]
	rlca
	ld_obj_frameset SpearBotFrameset_68e17, SpearBotFrameset_68e20
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
	jr c, .asm_463d0
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_463d0
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
	ld_obj_frameset SpearBotFrameset_68e33, SpearBotFrameset_68e3a
	call SetObjectFramesetPtr
	ld a, 26
	ld [hli], a
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
.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_46432
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_46432
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $09
	jr z, .asm_46444
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.asm_46444
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_4644e
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_4644e
	res OBJSUBFLAG_HDIR_F, [hl]
	ret
.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_46463
.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_46463
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset SpearBotFrameset_68e17, SpearBotFrameset_68e20
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
	or OBJ_INTERACTION_00
	ld [hld], a
	ret
.State0b:
	ld a, $3b
	ld [wCurObjState], a
	jr .asm_46499
.State0c:
	ld a, $3c
	ld [wCurObjState], a
.asm_46499
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
	ld de, SpearBotFrameset_68dff
	jr .asm_464c7
.State3c:
	ld hl, wCurObjFrameDuration
	xor a
	ld [hli], a
	ld [hli], a
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld de, SpearBotFrameset_68e08
.asm_464c7
	call SetObjectFramesetPtr
	ld a, 38
	ld [hli], a
	ld a, $5b
	ld [wCurObjState], a
	ret
.State29:
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_464f9
.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_464f9
.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $02
	jr .asm_464f9
.AttackedRightStart:
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $02
.asm_464f9
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
	jr c, .asm_46511
	ld de, SpearBotFrameset_68e29
	jp SetObjectFramesetPtr
.asm_46511
	ld de, SpearBotFrameset_68e2e
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
	ld_obj_frameset SpearBotFrameset_68e17, SpearBotFrameset_68e20
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
	ld a, $48
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset SpearBotFrameset_68e17, SpearBotFrameset_68e20
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
