OmodonmekaFunc:
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
	ld a, $fd
	ld [hld], a
	ld a, $f3
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld l, OBJ_VAR_1
	ld a, [wCurObjYPos + 0]
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	ld [hli], a
	jp .ResetToIdle

.Activate:
	xor a
	ld [hl], a
	ld de, OmodonmekaFrameset_68f14
	call SetObjectFramesetPtr
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr nz, .asm_421b1
	ld a, $18
	ld [hli], a
	ld e, $07
	ld d, $07
	jr .asm_421b5
.asm_421b1
	ld e, $05
	ld d, $1a
.asm_421b5
	ld l, OBJ_Y_POS
	ld a, [wWarioYPos + 1]
	sub d
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc $00
	ld [hli], a
	ld a, [hli]
	sub $08
	ld [wWarioXPos + 1], a
	ld a, [hl]
	sbc $00
	ld [wWarioXPos + 0], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $f0
	or e
	ld [hl], a
	ld a, $f9
	ld [wCurObjCollBoxBottom], a
	jr .asm_42249

.hit_by_obj_left
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .asm_421fa
.hit_by_obj_right
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .asm_421fa
.attacked_left
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
	jr .asm_421fa
.attacked_right
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
.asm_421fa
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld de, OmodonmekaFrameset_68f3d
	call SetObjectFramesetPtr
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $3a
	ld [wCurObjState], a
	ret

.vanish_touch
	jp VanishAndDespawnObject

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_42249
	cp $2a
	jp z, .Activate
	cp $04
	jr z, .attacked_left
	cp $05
	jr z, .attacked_right
	cp $28
	jr z, .hit_by_obj_left
	cp $29
	jr z, .hit_by_obj_right
	cp $0a
	jr z, .vanish_touch
	xor a
	ld [hld], a
	ld a, [hl]
	and $f0
	or $04
	ld [hld], a
	xor a
	ld [hld], a
	ld [hld], a
	ld de, OmodonmekaFrameset_68f34
	call SetObjectFramesetPtr
.asm_42249
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $0f
	jumptable

	dw .Hover
	dw .Hover
	dw .Fall
	dw .ReturnToStartY
	dw .FlyAway
	dw .CarryWarioUp
	dw .HoldWarioAtTop
	dw .HoldFlatWario
	dw .WatchWario

.HoldFlatWario:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wAutoMoveState]
	and a
	jr nz, .asm_42271
	inc a
	ld [wCurObjState], a
	ret

.asm_42271
	ld hl, wCurObjStateDuration
	dec [hl]
	ld a, [hl]
	cp $10
	jr nz, .asm_4227e
	ld e, $0e
	jr .asm_42283

.asm_4227e
	cp $07
	ret nz
	ld e, $16
.asm_42283
	ld l, OBJ_Y_POS
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc $00
	ld [hli], a
	ret

.CarryWarioUp:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wAutoMoveState]
	and a
	jr nz, .asm_422a1
	inc a
	ld [wCurObjState], a
	ret

.asm_422a1
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $1d
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
	jr nz, .asm_422d0
	ld hl, wCurObjVar1
	ld a, [hli]
	sub $40
	ld e, a
	ld a, [hl]
	sbc $00
	ld d, a
	ld l, OBJ_Y_POS + 1
	ld a, [hld]
	cp d
	jr nz, .asm_422e2
	ld a, [hl]
	cp e
	jr nz, .asm_422e2
.asm_422d0
	ld hl, wCurObjSubState
	ld a, [hl]
	and $f0
	or $06
	ld [hld], a
	xor a
	ld [hl], a
	ld de, OmodonmekaFrameset_68f14
	call SetObjectFramesetPtr
	ret

.asm_422e2
	ld a, [wGlobalCounter]
	and %111
	play_sfx z, SFX_087

	ld b, $01
	call MoveWarioUp
	call HandleUpwardsFloorTransition
	jp MoveObjectUp
.HoldWarioAtTop:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wAutoMoveState]
	and a
	jr nz, .asm_4230c
	inc a
	ld [wCurObjState], a
	ret

.asm_4230c
	ld bc, Data_604c0
	call ApplyObjYMovement_Loop
	ld l, OBJ_Y_POS
	ld a, [hli]
	add $1a
	ld [wWarioYPos + 1], a
	ld a, [hli]
	adc $00
	ld [wWarioYPos + 0], a
	ret

.Hover:
	ld bc, Data_604c0
	call ApplyObjYMovement_Loop
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	ret z
	ld c, $2a
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $22
	sub b
	cp $28
	jr c, .asm_42347
	cp $d8
	ret c
.asm_42347
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	ret nc
	ld de, OmodonmekaFrameset_68f1d
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $f0
	or $08
	ld [hld], a
	play_sfx SFX_08C
	ret

.WatchWario:
	ld a, [wGlobalCounter]
	and %11111
	play_sfx z, SFX_08C

	ld bc, Data_604c0
	call ApplyObjYMovement_Loop
	ld c, $2a
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $22
	sub b
	cp $10
	jr c, .asm_423b8
	cp $f0
	jr nc, .asm_423b8
	cp $28
	jr c, .asm_423ab
	cp $d8
	jr nc, .asm_423ab
.asm_4239b
	ld hl, wCurObjSubState
	ld a, [hl]
	and $f0
	or $01
	ld [hld], a
	ld de, OmodonmekaFrameset_68f0b
	call SetObjectFramesetPtr
	ret

.asm_423ab
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	jr nc, .asm_4239b
	ret

.asm_423b8
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	ret nc
	ld de, OmodonmekaFrameset_68f2b
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $f0
	or $02
	ld [hld], a
	xor a
	ld [hl], a
	ld a, $00
	ld [wCurObjCollBoxBottom], a
	play_sfx SFX_088
	ret

.Fall:
	ld bc, OmodonmekaData_60500
	call ApplyObjYMovement
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
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_01
	ld [hld], a
	ld a, $f9
	ld [wCurObjCollBoxBottom], a
	ld de, OmodonmekaFrameset_68f14
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $f0
	or $03
	ld [hld], a
	ret

.ReturnToStartY:
	ld hl, wCurObjVar1
	ld e, [hl]
	inc l
	ld d, [hl]
	ld l, OBJ_Y_POS + 1
	ld a, [hld]
	cp d
	jp nz, MoveObjectUp
	ld a, [hl]
	cp e
	jp nz, MoveObjectUp

.ResetToIdle:
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $1
	ld [hld], a
	xor a
	ld [hl], a
	ld de, OmodonmekaFrameset_68f0b
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_OMODONMEKA
	ld [hld], a
	ret

.FlyAway:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, OmodonmekaData_604e0
	call ApplyObjYMovement
	ld bc, Data_60650
	call ApplyObjXMovement_Loop
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	ret nz
	ld hl, wCurObjVar1
	ld e, [hl]
	inc l
	ld d, [hl]
	ld l, OBJ_Y_POS + 1
	ld a, [hld]
	cp d
	ret nz
	ld a, [hl]
	cp e
	ret nz
	ld a, $f9
	ld [wCurObjCollBoxBottom], a
	jr .ResetToIdle

OmodonmekaWithOmodon1Func:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(OmodonmekaWithOmodonFunc)
	ld [hld], a
	ld a, LOW(OmodonmekaWithOmodonFunc)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $fd
	ld [hld], a
	ld a, $f3
	ld [hld], a
	ld a, $f9
	ld [hld], a
	call CountCurObjTransientChildren
	ld a, e
	and a
	jp nz, OmodonmekaWithOmodonFunc.StartLowering
	ld bc, ObjParams_Omodon1
	call CreateObjectAtRelativePos
	ld de, OmodonmekaFrameset_68f14
	call SetObjectFramesetPtr
	ld a, $00
	ld [hli], a
	ld [wCurObjVar3], a
	jp OmodonmekaWithOmodonFunc.Idle

OmodonmekaWithOmodon2Func:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(OmodonmekaWithOmodonFunc)
	ld [hld], a
	ld a, LOW(OmodonmekaWithOmodonFunc)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $fd
	ld [hld], a
	ld a, $f3
	ld [hld], a
	ld a, $f9
	ld [hld], a
	call CountCurObjTransientChildren
	ld a, e
	and a
	jp nz, OmodonmekaWithOmodonFunc.StartLowering
	ld bc, ObjParams_Omodon2
	call CreateObjectAtRelativePos
	ld de, OmodonmekaFrameset_68f14
	call SetObjectFramesetPtr
	ld a, $00
	ld [hli], a
	ld [wCurObjVar3], a
	jp OmodonmekaWithOmodonFunc.Idle

OmodonmekaWithOmodonFunc:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_42525
	cp $04
	jp z, OmodonmekaFunc.attacked_left
	cp $05
	jp z, OmodonmekaFunc.attacked_right
	cp $28
	jp z, OmodonmekaFunc.hit_by_obj_left
	cp $29
	jp z, OmodonmekaFunc.hit_by_obj_right
	cp $0a
	jp z, OmodonmekaFunc.vanish_touch
	ld a, $3a
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld [hld], a
	ld de, OmodonmekaFrameset_68f34
	call SetObjectFramesetPtr
	ld a, $02
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.FlyAway)
	ld [hld], a
	ld a, LOW(.FlyAway)
	ld [hld], a
	jp .FlyAway

.asm_42525
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $0f
	jumptable

	dw .Idle
	dw .Idle
	dw .WaitToLower
	dw .LowerToOmodon
	dw .Rise

.Idle:
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jp z, ApplyOmodonHoverBob
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $2
	ld [hld], a
	ld de, OmodonmekaFrameset_68f26
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_STEPPED_F, [hl]
	ret

.WaitToLower:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
.StartLowering:
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $3
	ld [hld], a
	ld de, OmodonmekaFrameset_68f2b
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ret

.LowerToOmodon:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $28
	jp nz, .asm_42635
	ld l, OBJ_MAP_PTR_LO
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld d, $41
	ld h, HIGH(wObj1)
	ld l, OBJ_FLAGS
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_42592
	ld a, [hli]
	cp c
	jr nz, .asm_42592
	ld a, [hl]
	cp b
	jr nz, .asm_42592
	ld l, OBJ_SCREEN_Y_POS
	jp .move_to_omodon
.asm_42592
	ld l, $20
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_425a6
	ld a, [hli]
	cp c
	jr nz, .asm_425a6
	ld a, [hl]
	cp b
	jr nz, .asm_425a6
	ld l, $2d
	jp .move_to_omodon
.asm_425a6
	ld l, $40
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_425ba
	ld a, [hli]
	cp c
	jr nz, .asm_425ba
	ld a, [hl]
	cp b
	jr nz, .asm_425ba
	ld l, $4d
	jp .move_to_omodon
.asm_425ba
	ld l, $60
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_425ce
	ld a, [hli]
	cp c
	jr nz, .asm_425ce
	ld a, [hl]
	cp b
	jr nz, .asm_425ce
	ld l, $6d
	jp .move_to_omodon
.asm_425ce
	ld l, $80
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_425e2
	ld a, [hli]
	cp c
	jr nz, .asm_425e2
	ld a, [hl]
	cp b
	jr nz, .asm_425e2
	ld l, $8d
	jp .move_to_omodon
.asm_425e2
	ld l, $a0
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_425f6
	ld a, [hli]
	cp c
	jr nz, .asm_425f6
	ld a, [hl]
	cp b
	jr nz, .asm_425f6
	ld l, $ad
	jp .move_to_omodon
.asm_425f6
	ld l, $c0
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_4260a
	ld a, [hli]
	cp c
	jr nz, .asm_4260a
	ld a, [hl]
	cp b
	jr nz, .asm_4260a
	ld l, $cd
	jp .move_to_omodon
.asm_4260a
	ld l, $e0
	ld a, [hli]
	and d
	cp d
	jr nz, .asm_4261e
	ld a, [hli]
	cp c
	jr nz, .asm_4261e
	ld a, [hl]
	cp b
	jr nz, .asm_4261e
	ld l, $ed
	jp .move_to_omodon
.asm_4261e
	ret

.move_to_omodon:
	ld a, [wCurObjScreenYPos]
	ld c, a
	ld a, [hl]
	sub $10
	cp c
	jr z, .asm_42632
	ld a, [hl]
	sub $0f
	cp c
	jr z, .asm_42632
	jp MoveObjectDown
.asm_42632
	ld hl, wCurObjStateDuration
.asm_42635
	dec [hl]
	ret nz
	ld hl, wCurObjSubState
	ld a, [hl]
	and $f0
	or $04
	ld [hld], a
	ld de, OmodonmekaFrameset_68f14
	call SetObjectFramesetPtr
	ld a, $32
	ld [hli], a
	ld hl, wCurObjMapPtrLo
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld b, $41
	ld h, HIGH(wObj1)
	ld l, OBJ_FLAGS
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_42662
	ld a, [hli]
	cp e
	jr nz, .asm_42662
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_42662
	ld l, $20
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_42671
	ld a, [hli]
	cp e
	jr nz, .asm_42671
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_42671
	ld l, $40
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_42680
	ld a, [hli]
	cp e
	jr nz, .asm_42680
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_42680
	ld l, $60
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_4268f
	ld a, [hli]
	cp e
	jr nz, .asm_4268f
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_4268f
	ld l, $80
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_4269e
	ld a, [hli]
	cp e
	jr nz, .asm_4269e
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_4269e
	ld l, $a0
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_426ad
	ld a, [hli]
	cp e
	jr nz, .asm_426ad
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_426ad
	ld l, $c0
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_426bc
	ld a, [hli]
	cp e
	jr nz, .asm_426bc
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_426bc
	ld l, $e0
	ld a, [hli]
	and b
	cp b
	jr nz, .asm_426cb
	ld a, [hli]
	cp e
	jr nz, .asm_426cb
	ld a, [hli]
	cp d
	jr z, .asm_426cc
.asm_426cb
	ret

.asm_426cc
	ld a, l
	add $18
	ld l, a
	ld a, $2d
	ld [hld], a
	ld a, l
	sub $04
	ld l, a
	ld a, $33
	ld [hld], a
	xor a
	ld [hld], a
	ld [hld], a
	ld a, $4f
	ld [hld], a
	ld a, $42
	ld [hld], a
	ld a, l
	sub $07
	ld l, a
	ld a, $10
	ld [hli], a
	dec [hl]
	inc l
	inc [hl]
	ret

.Rise:
	ld hl, wCurObjFlags
	bit OBJFLAG_STEPPED_F, [hl]
	jr z, .asm_42702
	ld a, [wGlobalCounter]
	rra
	ret c
	ld b, $01
	call MoveWarioUp
	call HandleUpwardsFloorTransition
.asm_42702
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jp nz, MoveObjectUp
	ld hl, wCurObjSubState
	ld a, [hl]
	and $f0
	or $01
	ld [hld], a
	xor a
	ld [hld], a
	ret

.FlyAway:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, OmodonmekaData_604e0
	call ApplyObjYMovement
	ld bc, Data_60650
	jp ApplyObjXMovement_Loop

ApplyOmodonHoverBob:
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(OmodonHoverBobYOffsets)
	add LOW(OmodonHoverBobYOffsets)
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .asm_42740
	ld a, c
	sub $3f
	ld c, a
	ld a, [bc]
	ld c, $01
	ld [hl], c
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr .apply_y_offset
.asm_42740
	inc [hl]
.apply_y_offset
	and a
	ret z
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret

.negative
	add c
	ld [hli], a
	ret c
	dec [hl]
	ret

Omodon_Landed:
	ld hl, wCurObjFlags
	res OBJFLAG_STEPPED_F, [hl]
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld de, OmodonmekaFrameset_68f50
	call SetObjectFramesetPtr
	ret

Omodon_Idle:
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr nz, .asm_4277f
	call ApplyOmodonHoverBob
	call OmodonFunc.Func_42894
	ld hl, wCurObjFlags
	res OBJFLAG_STEPPED_F, [hl]
	ret

.asm_4277f
	ld hl, wCurObjState
	ld a, $2e
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld de, OmodonmekaFrameset_68f42
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_OMODON
	ld [hld], a
	ld l, OBJ_COLLBOX_LEFT
	inc [hl]
	inc l
	dec [hl]
	ret

OmodonFunc:
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
.Update:
	call .Func_42935
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, Omodon_Idle
	cp $2d
	jr z, .carried
	cp $2e
	jr z, .fall
	cp $2f
	jr z, Omodon_Landed
	cp $2a
	jp z, .StartPressWario
	cp $5a
	jp z, .PressWario
	xor a
	ld [hl], a
	jr Omodon_Idle
.carried
	call .Func_42894
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $33
	jr nz, .asm_427da
	dec [hl]
	ret

.asm_427da
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jr z, .asm_427e5
	ld a, [wGlobalCounter]
	rra
	ret c
.asm_427e5
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jp nz, MoveObjectUp
	ld de, OmodonmekaFrameset_68f50
	call SetObjectFramesetPtr
	ld l, OBJ_STATE
	xor a
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld a, $0b
	ld [wCurObjCollBoxBottom], a
	ret

.fall
	ld bc, Data_605e0
	call ApplyObjYMovement
	ld hl, wCurObjYPos
	ld a, [hli]
	add $0f
	ldh [hYPosLo], a
	ld a, [hli]
	adc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	ret z
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	sub $0f
	ld [hli], a
	ldh a, [hYPosHi]
	sbc $00
	ld [hl], a
	play_sfx SFX_063
	ld b, $18
	call DoGroundShake
	ld de, OmodonmekaFrameset_68f45
	call SetObjectFramesetPtr
.asm_4283c
	ld a, $1c
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_SOLID
	ld [hld], a
	ld a, $2f
	ld [wCurObjState], a
	ret

.StartPressWario:
	ld de, OmodonmekaFrameset_68f45
	call SetObjectFramesetPtr
	ld a, $14
	ld [hli], a
	ld a, $5a
	ld [wCurObjState], a
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub $18
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc $00
	ld [hli], a
	ret

.PressWario:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $14
	jr nz, .asm_42889
	ld a, [wAutoMoveState]
	and a
	jp nz, MoveObjectDown_Fast
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub $18
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc $00
	ld [hli], a
.asm_42889
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld a, no_actions_for 31
	ld [wCurObjAction], a
	jr .asm_4283c


.Func_42894:
	ld hl, wCurObjMapPtrLo
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld d, $43
	ld e, $03
	ld h, HIGH(wObj1)
	ld l, OBJ_FLAGS
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_428af
	ld a, [hli]
	cp c
	jr nz, .asm_428af
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_428af
	ld l, $20
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_428be
	ld a, [hli]
	cp c
	jr nz, .asm_428be
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_428be
	ld l, $40
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_428cd
	ld a, [hli]
	cp c
	jr nz, .asm_428cd
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_428cd
	ld l, $60
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_428dc
	ld a, [hli]
	cp c
	jr nz, .asm_428dc
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_428dc
	ld l, $80
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_428eb
	ld a, [hli]
	cp c
	jr nz, .asm_428eb
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_428eb
	ld l, $a0
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_428fa
	ld a, [hli]
	cp c
	jr nz, .asm_428fa
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_428fa
	ld l, $c0
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_42909
	ld a, [hli]
	cp c
	jr nz, .asm_42909
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_42909
	ld l, $e0
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_42918
	ld a, [hli]
	cp c
	jr nz, .asm_42918
	ld a, [hld]
	cp b
	jr z, .asm_42919
.asm_42918
	ret

.asm_42919
	ld a, [wCurObjFlags]
	rlca
	rlca
	ld e, a
	dec l
	ld a, [hl]
	rla
	rla
	rla
	sla e
	rra
	rra
	rra
	ld [hl], a
	ld a, l
	add $1b
	ld l, a
	ld a, [hl]
	cp $3a
	ret nz
	jp Omodon_Idle.asm_4277f

.Func_42935:
	ld hl, wCurObjMapPtrLo
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld d, $41
	ld e, $01
	ld h, HIGH(wObj1)
	ld l, OBJ_FLAGS
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_42950
	ld a, [hli]
	cp c
	jr nz, .asm_42950
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_42950
	ld l, $20
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_4295f
	ld a, [hli]
	cp c
	jr nz, .asm_4295f
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_4295f
	ld l, $40
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_4296e
	ld a, [hli]
	cp c
	jr nz, .asm_4296e
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_4296e
	ld l, $60
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_4297d
	ld a, [hli]
	cp c
	jr nz, .asm_4297d
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_4297d
	ld l, $80
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_4298c
	ld a, [hli]
	cp c
	jr nz, .asm_4298c
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_4298c
	ld l, $a0
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_4299b
	ld a, [hli]
	cp c
	jr nz, .asm_4299b
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_4299b
	ld l, $c0
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_429aa
	ld a, [hli]
	cp c
	jr nz, .asm_429aa
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_429aa
	ld l, $e0
	ld a, [hli]
	and d
	cp e
	jr nz, .asm_429b9
	ld a, [hli]
	cp c
	jr nz, .asm_429b9
	ld a, [hld]
	cp b
	jr z, .asm_429be
.asm_429b9
	xor a
	ld [wCurObjSubState], a
	ret

.asm_429be
	ld a, $10
	ld [wCurObjSubState], a
	ret
