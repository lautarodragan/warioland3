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
	jr c, .asm_466c0
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e77
	jp SetObjectFramesetPtr
.asm_466c0
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e80
	jp SetObjectFramesetPtr
.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_466de
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e77
	call SetObjectFramesetPtr
	ret

.asm_466de
	xor a
	ld [hld], a
	ld de, BeamBotFrameset_68e80
	call SetObjectFramesetPtr
	ret
.Special1:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_466f8
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_466f8
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_46714
	ld a, [hl]
	cp $19
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_4670e
	ld bc, ObjParams_BeamLeft
	jp CreateObjectAtRelativePos
.asm_4670e
	ld bc, ObjParams_BeamRight
	jp CreateObjectAtRelativePos
.asm_46714
	ld l, OBJ_STATE
	ld a, $2e
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
	jr c, .asm_4673d
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_4673d
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $13
	ld [wCurObjState], a
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
	ld_obj_frameset BeamBotFrameset_68e77, BeamBotFrameset_68e80
	call SetObjectFramesetPtr
	ld a, 100
	ld [hli], a
	ret
.Walk:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_4677a
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_4677a
	ld a, [wTransformation]
	cp TRANSFORMATION_SPLIT
	jr z, .asm_467cf
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .asm_467cf
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $1c
	jr c, .asm_4679c
	cp $e4
	jr c, .asm_467cf
.asm_4679c
	ld hl, wCurObjSubState
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $b8
	jr nc, .asm_467be
	cp $48
	jr nc, .asm_467cf
	ld a, [hli]
	rlca
	jr c, .asm_467ba
	ld de, BeamBotFrameset_68e89
	jr .asm_467c5
.asm_467ba
	ld a, $13
	ld [hl], a
	ret

.asm_467be
	ld a, [hli]
	rlca
	jr nc, .asm_467ba
	ld de, BeamBotFrameset_68e96
.asm_467c5
	ld a, $2d
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, 41
	ld [hli], a
	ret

.asm_467cf
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
	jr nz, .asm_467ea
	ld a, $11
	ld [wCurObjState], a
	ret

.asm_467ea
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_4682b
	ld a, [hl]
	and $0f
	sub $06
	jr nc, .asm_46807
	call ProcessBlockOnLeft
	and $0f
	jr z, .asm_4685f
.asm_46807
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
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_4682b
	ld a, [hl]
	and $0f
	add $05
	cp $10
	jr c, .asm_4683b
	call ProcessBlockOnRight
	and $0f
	jr z, .asm_4685f
.asm_4683b
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
	ld a, $13
	ld [wCurObjState], a
	ret

.asm_4685f
	ld a, [wGlobalCounter]
	rra
	jr c, .asm_46869
	ld hl, wCurObjFrameDuration
	inc [hl]
.asm_46869
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $13
	ld [wCurObjState], a
	ret
.BumpLeftStart:
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_46882
.BumpRightStart:
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_46882
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
	or OBJ_INTERACTION_01
	ld [hld], a
	ret
.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
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
	jr .asm_4691e
.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_4691e
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
	jr c, .asm_46961
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_46961
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
	or OBJ_INTERACTION_01
	ld [hld], a
	ret
.TurnAround:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_469c3
	ldh a, [rDIV]
	rra
	ld a, $04
	rla
	ld [wCurObjState], a
	ret

.asm_469c3
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $06
	jr z, .asm_469d5
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld a, $01
	ld [wCurObjState], a
	ret

.asm_469d5
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_469df
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_469df
	res OBJSUBFLAG_HDIR_F, [hl]
	ret
.WobbleLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_469f4
.WobbleRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_469f4
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
	or OBJ_INTERACTION_00
	ld [hld], a
	ret
.State29:
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_46a44
.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_46a44
.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $02
	jr .asm_46a44
.AttackedRightStart:
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $02
.asm_46a44
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
	jr c, .asm_46a5c
	ld de, BeamBotFrameset_68ec9
	jp SetObjectFramesetPtr
.asm_46a5c
	ld de, BeamBotFrameset_68ece
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
	ld a, $48
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

BeamFunc_Left:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_07C
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
	play_sfx SFX_07C
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
	play_sfx SFX_07D
.apply_movement
	jp ApplyObjXMovement
