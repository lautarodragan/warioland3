PneumoFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, PneumoFrameset_68c5c
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	dec l
	xor a
	ld [hld], a
	dec l
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld a, $02
	ld [hld], a
	ret

.asm_45672
	xor a
	ld [hld], a
	jp .start_retreat

.asm_45677
	xor a
	ld [hld], a
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jp z, .start_retreat
	ld a, [hl]
	and $0f
	cp $01
	jp z, .start_retreat
	jr .substate_table

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .substate_table
	cp OBJSTATE_HIT_WARIO_DOWN_START
	jr z, .asm_45672
	cp OBJSTATE_VANISH_TOUCH
	jr z, .asm_456c7
	cp OBJSTATE_ATTACKED_LEFT_START
	jr c, .asm_45677
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .asm_456ca
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .asm_456d2
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .asm_456da
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .asm_456e2
	rra
	jr nc, .asm_456d2
	jr .asm_456ca

.substate_table
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $0f
	jumptable

	dw .Float
	dw .Float
	dw .Retreat
	dw .SwoopDown
	dw .Rise
	dw .UnusedMoveSideways
	dw .MoveToWarioY

.asm_456c7
	jp VanishAndDespawnObject

.asm_456ca
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .asm_456e8
.asm_456d2
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .asm_456e8
.asm_456da
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
	jr .asm_456e8
.asm_456e2
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
.asm_456e8
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld de, PneumoFrameset_68c89
	call SetObjectFramesetPtr
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.set_float:
	ld de, PneumoFrameset_68c5c
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $01
	ld [hld], a
	xor a
	ld [hld], a
	ret

.Float:
	ld a, [wCurObjScreenYPos]
	add $2a
	ld b, a
	ld a, [wWarioScreenYPos]
	add $2a
	cp b
	jr c, .asm_45739
	cp $61
	jr nc, .asm_45739
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .asm_45739
	ld a, [wGlobalCounter]
	and %111111
	jr nz, .asm_45739
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $06
	ld [hld], a
	ret

.asm_45739
	ld hl, wCurObjVar3
	ld a, [hl]
	ld d, HIGH(PneumoData_44000)
.asm_4573f
	add LOW(PneumoData_44000)
	ld e, a
	ld a, [de]
	cp $80
	jr nz, .asm_4579c
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .asm_45798
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $b0
	jr c, .asm_45798
	cp $ec
	jr nc, .asm_45798
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $60
	jr nc, .asm_45782
	cp $10
	ld a, $01
	jr nc, .asm_45777
	dec a
.asm_45777
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, PneumoFrameset_68c7f
	ld c, $03
	jr .asm_457ae
.asm_45782
	cp SCREEN_WIDTH_PX
	jr c, .asm_45798
	cp $f0
	ld a, $01
	jr c, .asm_4578d
	dec a
.asm_4578d
	ld l, OBJ_SUBSTATE
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, PneumoFrameset_68c84
	ld c, $03
	jr .asm_457ae
.asm_45798
	xor a
	ld [hl], a
	jr .asm_4573f
.asm_4579c
	inc [hl]
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .asm_457a9
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret

.asm_457a9
	add c
	ld [hli], a
	ret c
	dec [hl]
	ret

.asm_457ae
	ld [wCurObjVar2], a
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or c
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, 1
	ld [hli], a
	ret

.SwoopDown:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_457c6
	dec [hl]
	ret

.asm_457c6
	xor a
	ld [wHitFloorBlock], a
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
	jr z, .asm_457e7
	ld a, [wHitFloorBlock]
	and a
	jr z, .asm_45801
	jr .asm_457ed
.asm_457e7
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .asm_45801
.asm_457ed
	ld c, $2a
	ld a, [wCurObjScreenYPos]
	add c
	ld b, a
	ld a, [wWarioScreenYPos]
	add c
	sub b
	cp $14
	jr c, .asm_45801
	cp $80
	jr c, .asm_45810
.asm_45801
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $04
	ld [hl], a
	ld a, 255
	ld [wCurObjStateDuration], a
	ret

.asm_45810
	ld hl, wCurObjVar1
	inc [hl]
	ld l, OBJ_Y_POS
	ld a, [hl]
	add 2
	ld [hli], a
	jr nc, .asm_4581d
	inc [hl]
.asm_4581d
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_45843
	ld a, [hli]
	sub 8
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .asm_45854
	jp MoveObjectLeftByVar2

.asm_45843
	ld a, [hli]
	add 7
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRightByVar2
.asm_45854
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.Rise:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .set_float
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 16
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jp nz, .asm_4581d
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jp z, .set_float
	dec [hl]
	ld l, OBJ_Y_POS
	ld a, [hl]
	sub 2
	ld [hli], a
	jp nc, .asm_4581d
	dec [hl]
	jp .asm_4581d

.UnusedMoveSideways:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, .asm_4581d
	jp .set_float

.start_retreat:
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $02
	ld [hl], a
	ld c, $2a
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	jr c, .asm_458b8
	set OBJSUBFLAG_HDIR_F, [hl]
	jr .asm_458ba
.asm_458b8
	res OBJSUBFLAG_HDIR_F, [hl]
.asm_458ba
	dec l
	xor a
	ld [hld], a
	ld de, PneumoFrameset_68c8e
	call SetObjectFramesetPtr
	ld a, 27
	ld [hli], a
	ret

.Retreat:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .end_retreat
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 16
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jr nz, .asm_458ed
	ld bc, PneumoData_60600
	call ApplyObjYMovement
.asm_458ed
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_45917
	ld a, [hli]
	sub 8
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Fast
	ld hl, wCurObjSubState
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_45917
	ld a, [hli]
	add 7
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Fast
	ld hl, wCurObjSubState
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.end_retreat:
	inc l
	xor a
	ld [hl], a
	jp .set_float

.MoveToWarioY:
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jp z, .set_float
	ld a, [wWarioYPos + 0]
	ld h, a
	ld a, [wWarioYPos + 1]
	and $fc
	ld l, a
	ld de, hXPosLoBackup
	add hl, de
	ld d, h
	ld e, l
	ld a, [wCurObjYPos + 1]
	cp d
	jr z, .asm_45971
	jr c, .asm_4597c
.asm_45954
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 16
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jp nz, .start_retreat
	jp MoveObjectUp
.asm_45971
	ld a, [wCurObjYPos + 0]
	and $fc
	cp e
	jp z, .set_float
	jr nc, .asm_45954
.asm_4597c
	xor a
	ld [wHitFloorBlock], a
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
	jr z, .asm_4599f
	ld a, [wHitFloorBlock]
	and a
	jp nz, MoveObjectDown_Slow
	jp .set_float
.asm_4599f
	ld a, [wIsInWaterOrSand]
	and a
	jp z, MoveObjectDown
	jp .set_float
