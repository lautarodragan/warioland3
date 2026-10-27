TeruteruFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Init)
	ld [hld], a
	ld a, LOW(.Init)
	ld [hld], a
	ret

.Init:
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr z, .asm_448ed
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
.asm_448ed
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
	jp .Default

.Update:
	ld hl, wCurObjFlags
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr nz, .asm_44911
	set OBJFLAG_INVISIBLE_F, [hl]
	jr .asm_44913
.asm_44911
	res OBJFLAG_INVISIBLE_F, [hl]
.asm_44913
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
	dw .BumpLeftStart
	dw .BumpRightStart
	dw VanishObject2
	dw .Default
	dw .Default
	dw .Default
	dw .State0e
	dw .State0f
	dw .State10
	dw .Default
	dw .State12
	dw .Default
	dw .State14
	dw .State15
	dw .StunLeftStart
	dw .StunRightStart
	dw .State18
	dw .State19
	dw Func_3263
	dw Func_3272
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
	dw .Special3
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
	dw .Default
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

.State0e:
	ld a, $5b
	ld [wCurObjState], a
	ret

.State5b:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr nz, .asm_449ff
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_Y_POS
	ld a, [wWarioYPos + 1]
	sub $0c
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc $00
	ld [hli], a
	ld a, [wWarioXPos + 1]
	ld [hli], a
	ld a, [wWarioXPos + 0]
	ld [hli], a
	ret

.asm_449ff
	ld a, [wDirection]
	and a
	jp z, .BumpLeftStart
	jp .BumpRightStart

.Special1:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $2e
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68b8b
	call SetObjectFramesetPtr
	ld a, 40
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TERUTERU
	ld [hli], a
	ret

.Special2:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_44a46
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr z, .asm_44a43
	jr c, .asm_44a40
	call MoveObjectLeft
	jr .asm_44a43
.asm_44a40
	call MoveObjectRight
.asm_44a43
	jp MoveObjectDown_Fast
.asm_44a46
	ld a, $2f
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68bae
	call SetObjectFramesetPtr
	ld a, 80
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hli], a
	ret

.Special3:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $3c
	jr nz, .asm_44a6b
	ld de, TeruteruFrameset_68b90
	call SetObjectFramesetPtr
.asm_44a6b
	dec [hl]
	jp nz, MoveObjectUp
	jp .asm_44b4c

.Default:
	ld hl, wCurObjCollBoxRight
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $f1
	ld [hld], a
	ld a, $ec
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_44a95
	res OBJSUBFLAG_HDIR_F, [hl]
	jr .Land
.asm_44a95
	set OBJSUBFLAG_HDIR_F, [hl]
.Land:
	ld hl, wCurObjState
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset TeruteruFrameset_68b64, TeruteruFrameset_68b6d
	xor a
	ld [hld], a
	call SetObjectFramesetPtr
	inc l
	ld a, $32
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hli], a
	ld a, $ec
	ld [hli], a
	ld a, $f1
	ld [hl], a
	ret

.Walk:
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr z, .asm_44afd
	ld c, $2a
	ld a, [wCurObjScreenYPos]
	add c
	ld b, a
	ld a, [wWarioScreenYPos]
	add c
	sub b
	cp $18
	jr c, .asm_44afd
	cp $80
	jr nc, .asm_44afd
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $e8
	jr nc, .asm_44aee
	cp $18
	jr nc, .asm_44afd
.asm_44aee
	ld a, $2d
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68b84
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ret

.asm_44afd
	ld bc, Data_604c0
	call ApplyObjYMovement_Loop
	ld hl, wCurObjVar1
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_44b17
	dec [hl]
	ld a, [hl]
	and a
	jp nz, MoveObjectLeft
	ld de, TeruteruFrameset_68b76
	jr .asm_44b21
.asm_44b17
	inc [hl]
	ld a, [hl]
	cp $64
	jp nz, MoveObjectRight
	ld de, TeruteruFrameset_68b7d
.asm_44b21
	call SetObjectFramesetPtr
	ld a, 26
	ld [hli], a
	ld a, $5a
	ld [wCurObjState], a
	ret

.State5a:
	ld bc, Data_604c0
	call ApplyObjYMovement_Loop
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $09
	jr z, .asm_44b3f
	dec [hl]
	jr z, .asm_44b4c
	ret

.asm_44b3f
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .asm_44b49
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_44b49
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_44b4c
	ld l, OBJ_STATE
	ld a, $31
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_44b5b
	ld de, TeruteruFrameset_68b64
	jp SetObjectFramesetPtr
.asm_44b5b
	ld de, TeruteruFrameset_68b6d
	jp SetObjectFramesetPtr

.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
	ld [hld], a
	call DecrementRemainingBossHits
	ld a, [hl]
	and $0f
	dec a
	jp z, VanishObject2
	ld de, TeruteruFrameset_68ba5
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
	call DecrementRemainingBossHits
	ld a, [hl]
	and $0f
	dec a
	jp z, VanishObject2
	ld de, TeruteruFrameset_68ba5
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
	ld a, $44
	ld [wCurObjState], a
	jr .asm_44bc5
.State15:
	ld a, $45
	ld [wCurObjState], a
.asm_44bc5
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_VAR_2
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_00
	ld [hli], a
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ret

.State0f:
	ld a, $3f
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $08
	ld [hl], a
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .asm_44c05
	ld a, $1c
	ld [wCurObjState], a
	ret

.asm_44c05
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
	ld de, TeruteruFrameset_68b99
	call SetObjectFramesetPtr
	ld a, 80
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hli], a
	ld a, $ec
	ld [hli], a
	ld a, $f1
	ld [hl], a
.State40:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectUp
	ld a, $00
	ld [wCurObjState], a
	ret

.BumpLeftStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $38
	jr .asm_44c51
.BumpRightStart:
	ld hl, wCurObjAction
	ld a, $8f
	ld [hld], a
	ld a, $39
.asm_44c51
	ld [hld], a
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld a, 4
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
	ld [hli], a
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ret

.State29:
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_44c96
.State28:
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_44c96
.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $02
	jr .asm_44c96
.AttackedRightStart:
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $02
.asm_44c96
	ld a, [hl]
	and $f0
	ld [hld], a
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld de, TeruteruFrameset_68ba2
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
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_TOP
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $08
	ld [hl], a
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
	ld a, $48
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_TOP
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
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
