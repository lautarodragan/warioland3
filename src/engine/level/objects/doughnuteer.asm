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
	jr c, .asm_41b65
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_41b65
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $1a
	jr z, .asm_41b8e
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $2b
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41b84
	ld de, DoughnuteerFrameset_685fe
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.asm_41b84
	ld de, DoughnuteerFrameset_68605
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.asm_41b8e
	dec [hl]
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	play_sfx nz, SFX_067
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_41ba8
	ld bc, ObjParams_DoughnutLeft
	jr .asm_41bab

.asm_41ba8
	ld bc, ObjParams_DoughnutRight
.asm_41bab
	jp CreateObjectAtRelativePos

.State2b:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .asm_41bcf
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $5b
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41bc9
	ld de, DoughnuteerFrameset_68574
	jp SetObjectFramesetPtr
.asm_41bc9
	ld de, DoughnuteerFrameset_6857d
	jp SetObjectFramesetPtr
.asm_41bcf
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_41bd9
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_41bd9
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State5b:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_41be9
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_41be9
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
	jr nz, .asm_41c04
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_41c04
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_41c4e
	ld a, [hl]
	and $0f
	sub $06
	jr nc, .asm_41c21
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_41c3f
.asm_41c21
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
.asm_41c3f
	ld a, $2c
	ld [wCurObjState], a
	ld de, DoughnuteerFrameset_685fe
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.asm_41c4e
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .asm_41c5e
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_41c7c
.asm_41c5e
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
.asm_41c7c
	ld a, $2c
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
	jr z, .asm_41cb4
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_STATE
	ld a, $5c
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41caa
	ld de, DoughnuteerFrameset_685c4
	call SetObjectFramesetPtr
	ld a, $37
	ld [hli], a
	ret

.asm_41caa
	ld de, DoughnuteerFrameset_685d7
	call SetObjectFramesetPtr
	ld a, $37
	ld [hli], a
	ret

.asm_41cb4
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_41cbe
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_41cbe
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.State5c:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_41cce
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_41cce
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
	ld a, $30
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_41d0e
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_68562
	call SetObjectFramesetPtr
	ret

.asm_41d0e
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_6856b
	call SetObjectFramesetPtr
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41d2d
	xor a
	ld [hld], a
	ld de, DoughnuteerFrameset_68562
	call SetObjectFramesetPtr
	ret

.asm_41d2d
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
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_41d4f
	ld de, DoughnuteerFrameset_68562
	call SetObjectFramesetPtr
	ret

.asm_41d4f
	ld de, DoughnuteerFrameset_6856b
	call SetObjectFramesetPtr
	ret

.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_41d63
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_41d63
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $20
	jr c, .asm_41d77
	cp $e0
	jr c, .asm_41daa
.asm_41d77
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $c0
	jr nc, .asm_41d99
	cp $40
	jr nc, .asm_41daa
	ld a, [hli]
	rlca
	jr c, .asm_41d95
	ld de, DoughnuteerFrameset_68586
	jr .asm_41da0

.asm_41d95
	ld a, $13
	ld [hl], a
	ret

.asm_41d99
	ld a, [hli]
	rlca
	jr nc, .asm_41d95
	ld de, DoughnuteerFrameset_68597
.asm_41da0
	ld a, $5a
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, $33
	ld [hli], a
	ret

.asm_41daa
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
	jr nz, .asm_41dc5
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_41dc5
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_41e06
	ld a, [hl]
	and $0f
	sub $06
	jr nc, .asm_41de2
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_41e00
.asm_41de2
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
.asm_41e00
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_41e06
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .asm_41e16
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_41e34
.asm_41e16
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
.asm_41e34
	ld a, $13
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld a, [wCurObjFrame]
	cp $24
	jr nc, .asm_41e45
	cp $06
	jr nc, .asm_41e4b
.asm_41e45
	ld bc, ObjParams_DoughnutUpLeft
	call CreateObjectAtRelativePos
.asm_41e4b
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_41e93

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
	jr c, .asm_41e72
	ld a, $2b
	ld [hl], a
	ld de, DoughnuteerFrameset_685fe
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.asm_41e72
	ld a, $5b
	ld [hl], a
	ld de, DoughnuteerFrameset_6857d
	call SetObjectFramesetPtr
	ret

.BumpRightStart:
	ld a, [wCurObjFrame]
	cp $24
	jr nc, .asm_41e87
	cp $06
	jr nc, .asm_41e8d
.asm_41e87
	ld bc, ObjParams_DoughnutUpRight
	call CreateObjectAtRelativePos
.asm_41e8d
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_41e93
	ld a, [hld]
	rlca
	jr c, .asm_41e9f
	ld de, DoughnuteerFrameset_685a8
	call SetObjectFramesetPtr
	jr .asm_41ea5

.asm_41e9f
	ld de, DoughnuteerFrameset_685ad
	call SetObjectFramesetPtr
.asm_41ea5
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
	jr c, .asm_41eca
	ld a, $5b
	ld [hl], a
	ld de, DoughnuteerFrameset_68574
	call SetObjectFramesetPtr
	ret

.asm_41eca
	ld a, $2b
	ld [hl], a
	ld de, DoughnuteerFrameset_68605
	call SetObjectFramesetPtr
	ld a, $1a
	ld [hli], a
	ret

.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
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
	ld a, $0f
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, $47
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
	ld a, $0f
	ld [wCurObjState], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, $44
	ld [hld], a
	jr .asm_41f3b

.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_41f3b
	ld a, [hld]
	rlca
	jr c, .asm_41f47
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .asm_41f4d

.asm_41f47
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.asm_41f4d
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
	jr c, .asm_41f79
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_41f79
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
	jr c, .asm_41fb3
	ld de, DoughnuteerFrameset_685f0
	call SetObjectFramesetPtr
	jr .asm_41fb9

.asm_41fb3
	ld de, DoughnuteerFrameset_685f7
	call SetObjectFramesetPtr
.asm_41fb9
	ld a, $1a
	ld [hli], a
	ret

.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_41fca
	ld a, $1a
	ld [wCurObjState], a
	ret

.asm_41fca
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $08
	jr z, .asm_41fdc
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.asm_41fdc
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_41fe6
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_41fe6
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_41ffb

.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_41ffb
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_42008
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .asm_4200e

.asm_42008
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.asm_4200e
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
	jr .asm_42046

.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_42046

.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $02
	jr .asm_42046

.AttackedRightStart:
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $02
.asm_42046
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
	jr c, .asm_4205e
	ld de, DoughnuteerFrameset_685b2
	jp SetObjectFramesetPtr
.asm_4205e
	ld de, DoughnuteerFrameset_685bb
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
	jr c, .asm_4209c
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .asm_420a2

.asm_4209c
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.asm_420a2
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
	jr c, .asm_420c8
	ld de, DoughnuteerFrameset_685b2
	call SetObjectFramesetPtr
	jr .asm_420ce

.asm_420c8
	ld de, DoughnuteerFrameset_685bb
	call SetObjectFramesetPtr
.asm_420ce
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

DoughnutFunc_Left:
	call MoveObjectLeft_Fast
	jr DoughnutFunc_LeftRight
DoughnutFunc_Right:
	call MoveObjectRight_Fast
DoughnutFunc_LeftRight:
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wCurObjState]
	cp $18
	jr z, DoughnutFunc_Destroy
	cp $19
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
	ld a, $8f
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
.Update:
	ld a, [wCurObjState]
	cp $18
	jr z, DoughnutFunc_Destroy
	cp $19
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
	jr c, .asm_4214f
	ld bc, .Update_Right
	jr .asm_42152
.asm_4214f
	ld bc, .Update_Left
.asm_42152
	ld hl, wCurObjUpdateFunction + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	xor a
	ld [wCurObjVar3], a
	ret
.Update_Left:
	call MoveObjectLeft
	jr .asm_42165
.Update_Right:
	call MoveObjectRight
.asm_42165
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, DropYVel_Light
	jp ApplyObjYMovement
