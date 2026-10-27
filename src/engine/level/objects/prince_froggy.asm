GreyPrinceFroggyFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(PrinceFroggyFunc.Update_Sitting)
	ld [hld], a
	ld a, LOW(PrinceFroggyFunc.Update_Sitting)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $03
	ld [hld], a
	ld a, $ec
	ld [hld], a
	ld a, $00
	ld [hld], a
	ld l, OBJ_STATE
	jp PrinceFroggyFunc.StartTurnAround

RedPrinceFroggyFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(PrinceFroggyFunc.Update_Stuck)
	ld [hld], a
	ld a, LOW(PrinceFroggyFunc.Update_Stuck)
	ld [hld], a
	ld de, PrinceFroggyFrameset_68ac6
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $03
	ld [hld], a
	ld a, $ec
	ld [hld], a
	ld a, $00
	ld [hld], a
	ret

PrinceFroggyFunc:
.SetHitByObjLeft:
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	jr .asm_440da
.SetHitByObjRight:
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	jr .asm_440da
.SetAttackedLeft:
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	jr .asm_440da
.SetAttackedRight:
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
.asm_440da
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	ld [hld], a
	xor a
	ld [hld], a
	ld a, $01
	ld [hld], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld de, PrinceFroggyFrameset_68ae6
	jp SetObjectFramesetPtr

.Update_Stuck:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr nz, .asm_44113
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, .asm_44185
	res OBJFLAG_STEPPED_F, [hl]
	ld a, $5a
	ld [wCurObjState], a
	ld de, PrinceFroggyFrameset_68add
	call SetObjectFramesetPtr
	ld a, 111
	ld [hli], a
	ret

.asm_44113
	cp $1b
	jp z, ObjState_Hop
	cp $41
	jp z, ObjState_StandingFall
	cp $13
	jr z, .asm_44144
	cp $11
	jr z, .asm_44151
	cp $5a
	jr z, .asm_44158
	cp $3b
	jr z, .asm_44161
	cp $28
	jr z, .SetHitByObjLeft
	cp $29
	jr z, .SetHitByObjRight
	cp $04
	jr z, .SetAttackedLeft
	cp $05
	jr z, .SetAttackedRight
	cp $0a
	jp z, .asm_4420a
	jr .asm_44172

.asm_44144
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update_Sitting)
	ld [hld], a
	ld a, LOW(.Update_Sitting)
	ld [hld], a
	ld l, OBJ_STATE
	jp .StartTurnAround

.asm_44151
	ld a, $41
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ret

.asm_44158
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jr z, .asm_44166
	res OBJFLAG_STEPPED_F, [hl]
	ret

.asm_44161
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr nz, .asm_44185
.asm_44166
	xor a
	ld [wCurObjState], a
	ld de, PrinceFroggyFrameset_68ac6
	call SetObjectFramesetPtr
	jr .asm_44185
.asm_44172
	ld a, $3b
	ld [wCurObjState], a
	ld de, PrinceFroggyFrameset_68af2
	call SetObjectFramesetPtr
	ld a, 40
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret

.asm_44185
	ld a, [wGroundShakeCounter]
	cp $10
	ret c
	ld l, OBJ_STATE
	ld a, $1b
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld de, PrinceFroggyFrameset_68ae6
	call SetObjectFramesetPtr
	ld a, 13
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hli], a
	ret

.Update_Sitting:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_44185
	cp $11
	jr z, .asm_44151
	cp $1b
	jp z, ObjState_Hop
	cp $41
	jp z, ObjState_StandingFall
	cp $28
	jp z, .SetHitByObjLeft
	cp $29
	jp z, .SetHitByObjRight
	cp $04
	jp z, .SetAttackedLeft
	cp $05
	jp z, .SetAttackedRight
	cp $13
	jr z, .StartTurnAround
	cp $43
	jr z, .asm_441f8
	cp $0a
	jr z, .asm_4420a
	xor a
	ld [hl], a
.StartTurnAround:
	ld a, $43
	ld [hl], a
	ld de, PrinceFroggyFrameset_68b01
	call SetObjectFramesetPtr
	ld a, 73
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_PRINCE_FROGGY
	ld [hli], a
	ld a, $e6
	ld [hl], a
	ret

.asm_441f8
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr nz, .asm_44185
	xor a
	ld [wCurObjState], a
	ld de, PrinceFroggyFrameset_68ae9
	call SetObjectFramesetPtr
	jp .asm_44185

.asm_4420a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.HopAndVanish)
	ld [hld], a
	ld a, LOW(.HopAndVanish)
	ld [hld], a
	ld de, PrinceFroggyFrameset_68ae6
	call SetObjectFramesetPtr
	ld a, 16
	ld [hli], a
	xor a
	ld [wCurObjVar3], a
	ret

.HopAndVanish:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, DropYVel_Light
	call ApplyObjYMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $08
	ld [wCurObjVar2], a
	call MoveObjectLeftByVar2
	jp VanishObject2
