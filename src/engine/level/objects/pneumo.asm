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

.hit_wario_below
	xor a
	ld [hld], a
	jp .start_retreat

.touched
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
	jr z, .hit_wario_below
	cp OBJSTATE_VANISH_TOUCH
	jr z, .vanish
	cp OBJSTATE_ATTACKED_LEFT_START
	jr c, .touched
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .set_hit_by_obj_left
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .set_hit_by_obj_right
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .set_attacked_left
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .set_attacked_right
	rra
	jr nc, .set_hit_by_obj_right
	jr .set_hit_by_obj_left

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

.vanish
	jp VanishAndDespawnObject

.set_hit_by_obj_left
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .set_knocked_back
.set_hit_by_obj_right
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .set_knocked_back
.set_attacked_left
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
	jr .set_knocked_back
.set_attacked_right
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
.set_knocked_back
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
	jr c, .bob
	cp $61
	jr nc, .bob
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .bob
	ld a, [wGlobalCounter]
	and %111111
	jr nz, .bob
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $06
	ld [hld], a
	ret

.bob
	ld hl, wCurObjVar3
	ld a, [hl]
	ld d, HIGH(PneumoData_44000)
.read_bob_offset
	add LOW(PneumoData_44000)
	ld e, a
	ld a, [de]
	cp $80
	jr nz, .apply_bob_offset
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .restart_bob
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $b0
	jr c, .restart_bob
	cp $ec
	jr nc, .restart_bob
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $60
	jr nc, .check_wario_right
	cp $10
	ld a, $01
	jr nc, .swoop_left
	dec a
.swoop_left
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, PneumoFrameset_68c7f
	ld c, $03
	jr .start_swoop
.check_wario_right
	cp SCREEN_WIDTH_PX
	jr c, .restart_bob
	cp $f0
	ld a, $01
	jr c, .swoop_right
	dec a
.swoop_right
	ld l, OBJ_SUBSTATE
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, PneumoFrameset_68c84
	ld c, $03
	jr .start_swoop
.restart_bob
	xor a
	ld [hl], a
	jr .read_bob_offset
.apply_bob_offset
	inc [hl]
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .bob_up
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret

.bob_up
	add c
	ld [hli], a
	ret c
	dec [hl]
	ret

.start_swoop
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
	jr z, .swoop
	dec [hl]
	ret

.swoop
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
	jr z, .no_floor
	ld a, [wHitFloorBlock]
	and a
	jr z, .start_rise
	jr .check_wario_below
.no_floor
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .start_rise
.check_wario_below
	ld c, $2a
	ld a, [wCurObjScreenYPos]
	add c
	ld b, a
	ld a, [wWarioScreenYPos]
	add c
	sub b
	cp $14
	jr c, .start_rise
	cp $80
	jr c, .move_down
.start_rise
	ld hl, wCurObjSubState
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $04
	ld [hl], a
	ld a, 255
	ld [wCurObjStateDuration], a
	ret

.move_down
	ld hl, wCurObjVar1
	inc [hl]
	ld l, OBJ_Y_POS
	ld a, [hl]
	add 2
	ld [hli], a
	jr nc, .move_horizontal
	inc [hl]
.move_horizontal
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .move_right
	ld a, [hli]
	sub 8
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .reverse
	jp MoveObjectLeftByVar2

.move_right
	ld a, [hli]
	add 7
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRightByVar2
.reverse
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
	jp nz, .move_horizontal
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jp z, .set_float
	dec [hl]
	ld l, OBJ_Y_POS
	ld a, [hl]
	sub 2
	ld [hli], a
	jp nc, .move_horizontal
	dec [hl]
	jp .move_horizontal

.UnusedMoveSideways:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, .move_horizontal
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
	jr c, .retreat_left
	set OBJSUBFLAG_HDIR_F, [hl]
	jr .set_retreat
.retreat_left
	res OBJSUBFLAG_HDIR_F, [hl]
.set_retreat
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
	jr nz, .retreat_horizontal
	ld bc, PneumoData_60600
	call ApplyObjYMovement
.retreat_horizontal
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .retreat_right
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

.retreat_right
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
	jr z, .compare_y_lo
	jr c, .move_down_to_wario
.move_up_to_wario
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
.compare_y_lo
	ld a, [wCurObjYPos + 0]
	and $fc
	cp e
	jp z, .set_float
	jr nc, .move_up_to_wario
.move_down_to_wario
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
	jr z, .check_water
	ld a, [wHitFloorBlock]
	and a
	jp nz, MoveObjectDown_Slow
	jp .set_float
.check_water
	ld a, [wIsInWaterOrSand]
	and a
	jp z, MoveObjectDown
	jp .set_float
