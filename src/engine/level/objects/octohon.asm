SmallOctohonFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Start)
	ld [hld], a
	ld a, LOW(.Start)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $00
	ld [hld], a
	ld a, $00
	ld [hld], a
	ld a, $00
	ld [hl], a
	ret

.Start:
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	ld de, OctohonFrameset_69b2f
	ld b, $00
	jr .set_update
.face_right
	ld de, OctohonFrameset_69b38
	ld b, $01
.set_update
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
.start_swim
	ld hl, wCurObjStateDuration
	ld a, $ac
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a
	ld [hl], a
	ldh a, [rDIV]
	rra
	jr nc, .got_flags
	ld l, OBJ_FLAGS
	ld a, [hl]
	xor $80
	ld [hl], a
.got_flags
	jp SetObjectFramesetPtr

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .phase_left
	cp $01
	jr z, .phase_right
	xor a
	ld [hl], a
.phase_left
	dec l
	ld a, [hl]
	and a
	jr z, .left_phase_over
	dec [hl]
	jr nz, .check_wall
	ld de, OctohonFrameset_69b41
	call SetObjectFramesetPtr
	jr .check_wall
.left_phase_over
	ld l, OBJ_VAR_2
	ld a, [hl]
	cp $ee
	jr nz, .check_wall
	ld de, OctohonFrameset_69b38
	ld b, $01
	jr .start_swim
.phase_right
	dec l
	ld a, [hl]
	and a
	jr z, .right_phase_over
	dec [hl]
	jr nz, .check_wall
	ld de, OctohonFrameset_69b4c
	call SetObjectFramesetPtr
	jr .check_wall
.right_phase_over
	ld l, OBJ_VAR_2
	ld a, [hl]
	cp $ee
	jr nz, .check_wall
	ld de, OctohonFrameset_69b2f
	ld b, $00
	jr .start_swim
.check_wall
	ld a, [wCurObjVar2]
	and a
	jr z, .move_x
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .move_x
	ld hl, wCurObjVar2
	inc [hl]
	ret

.move_x
	ld de, OctohonData_4a5a9
	ld hl, wCurObjVar2
	ld a, [hl]
	ld b, d
	ld c, e
	add c
	ld c, a
	jr nc, .no_carry
	inc b
.no_carry
	ld a, [bc]
	cp $80
	jr nz, .got_offset
	xor a
	ld [hl], a
	ld b, d
	ld c, e
	ld a, [bc]
.got_offset
	inc [hl]
	ld b, a
	dec l
	ld a, [hl]
	and a
	ld l, OBJ_X_POS
	ld a, [hl]
	jr nz, .move_right
	sub b
	ld [hli], a
	ret nc
	dec [hl]
	ret

.move_right
	add b
	ld [hli], a
	ret nc
	inc [hl]
	ret

OctohonData_4a5a9:
	db $02, $01, $01, $01, $01, $01, $00, $01
	db $00, $01, $00, $01, $00, $01, $00, $01
	db $01, $00, $01, $00, $00, $01, $00, $00
	db $01, $00, $01, $00, $01, $00, $01, $00
	db $00, $01, $00, $01, $00, $01, $00, $00
	db $01, $00, $00, $01, $00, $00, $01, $00
	db $00, $01, $00, $00, $00, $01, $00, $00
	db $00, $01, $00, $00, $00, $00, $01, $00
	db $00, $00, $00, $01, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $00, $01, $00
	db $00, $00, $00, $00, $00, $01, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $01, $00
	db $00, $00, $00, $00, $00, $00, $00, $00
	db $02, $01, $01, $01, $01, $01, $00, $01
	db $00, $01, $00, $01, $00, $01, $00, $01
	db $01, $00, $01, $00, $00, $01, $00, $00
	db $01, $00, $01, $00, $01, $00, $01, $00
	db $00, $01, $00, $01, $00, $01, $00, $00
	db $01, $00, $00, $01, $00, $00, $01, $00
	db $00, $01, $00, $01, $00, $01, $00, $01
	db $00, $01, $00, $01, $00, $00, $01, $00
	db $01, $00, $01, $00, $01, $00, $01, $00
	db $00, $01, $00, $00, $01, $00, $00, $01
	db $00, $00, $00, $01, $00, $00, $00, $01
	db $00, $00, $00, $01, $00, $00, $00, $00
	db $01, $00, $00, $00, $00, $01, $00, $00
	db $00, $00, $00, $01, $00, $00, $00, $00
	db $80

BigOctohonFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Start)
	ld [hld], a
	ld a, LOW(.Start)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $08
	ld [hld], a
	ld a, $f7
	ld [hld], a
	ld a, $08
	ld [hl], a
	ret

.Start:
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	ld hl, wCurObjSubState
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, OctohonFrameset_69b57
	jr .set_update
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, OctohonFrameset_69b60
.set_update
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
.start_swim
	ld hl, wCurObjStateDuration
	ld a, $ac
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
	jp SetObjectFramesetPtr

.hit_wario_right
	ld de, OctohonFrameset_69b69
	jr .set_hit_wario
.hit_wario_left
	ld de, OctohonFrameset_69b74
.set_hit_wario
	xor a
	ld [hl], a
	call SetObjectFramesetPtr
	ld a, $43
	ld [hli], a
	ld a, $04
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_BUMP
	ld [hld], a
	play_sfx SFX_BIG_OCTO_1
	ret

.hurt
	xor a
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset OctohonFrameset_69b7f, OctohonFrameset_69b88
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld a, $03
	ld [hl], a
	ret

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .dispatch_phase
	cp OBJSTATE_HIT_WARIO_RIGHT_START
	jr z, .hit_wario_right
	cp OBJSTATE_HIT_WARIO_LEFT_START
	jr z, .hit_wario_left
	cp OBJSTATE_VANISH_TOUCH
	jp z, VanishAndDespawnObject
	jr .hurt
.dispatch_phase
	ld l, OBJ_VAR_1
	ld a, [hl]
	and a
	jr z, .swim
	cp $01
	jr z, .charge
	cp $02
	jr z, .recoil_wait
	cp $03
	jr z, .dash_after_hit
	cp $04
	jr z, .recoil
	ret
.dash_after_hit
	dec l
	dec [hl]
	jr nz, .charge_move
	ld a, [wCurObjSubState]
	rlca
	jr c, .dash_end_facing_right
	ld de, OctohonFrameset_69b57
	jp .start_swim
.dash_end_facing_right
	ld de, OctohonFrameset_69b60
	jp .start_swim
.recoil
	ld bc, OctohonData_60d50
	call ApplyObjXMovement
	ld l, OBJ_VAR_1
.recoil_wait
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	dec l
	dec [hl]
	ret nz
	jp .turn_around
.charge
	dec l
	ld a, [hl]
	and a
	jr z, .charge_move_start
	dec [hl]
	ret
.charge_move_start
	ld a, $02
	ld [wCurObjFrameDuration], a
.charge_move
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .charge_right
	ld a, [hli]
	sub $06
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Fast
	jp .hit_wario_right
.charge_right
	ld a, [hli]
	add $06
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Fast
	jp .hit_wario_left
.swim
	dec l
	ld a, [hl]
	and a
	jp z, .wait_turn
	dec [hl]
	jr z, .set_turn_frameset
	ld c, $2a
	ld a, [wWarioScreenYPos]
	add c
	ld b, a
	ld a, [wCurObjScreenYPos]
	add c
	sub b
	cp $14
	jr c, .in_y_range
	cp $ec
	jr c, .swim_move
.in_y_range
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .facing_right
	cp $40
	jr nc, .swim_move
	ld de, OctohonFrameset_69bc3
	jr .start_charge
.facing_right
	cp $c0
	jr c, .swim_move
	ld de, OctohonFrameset_69bce
.start_charge
	call SetObjectFramesetPtr
	ld a, $24
	ld [hli], a
	ld a, $01
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_FRONT_LAUNCH
	ld [hld], a
	ret
.set_turn_frameset
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset OctohonFrameset_69b69, OctohonFrameset_69b74
	call SetObjectFramesetPtr
.swim_move
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .swim_right
	ld a, [hli]
	sub $06
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .move_x
	jr .blocked
.swim_right
	ld a, [hli]
	add $06
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .move_x
.blocked
	ld hl, wCurObjVar2
	inc [hl]
	ret

.wait_turn
	ld l, OBJ_VAR_2
	ld a, [hl]
	cp $ee
	jr nz, .swim_move
.turn_around
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor $80
	ld [hl], a
	rlca
	jr c, .turn_to_right
	ld de, OctohonFrameset_69b57
	jp .start_swim
.turn_to_right
	ld de, OctohonFrameset_69b60
	jp .start_swim
.move_x
	ld de, OctohonData_4a5a9
	ld hl, wCurObjVar2
	ld a, [hl]
	ld b, d
	ld c, e
	add c
	ld c, a
	jr nc, .no_carry
	inc b
.no_carry
	ld a, [bc]
	cp $80
	jr nz, .got_offset
	xor a
	ld [hl], a
	ld b, d
	ld c, e
	ld a, [bc]
.got_offset
	inc [hl]
	ld b, a
	ld a, [wCurObjSubState]
	rlca
	ld l, OBJ_X_POS
	ld a, [hl]
	jr c, .move_right
	sub b
	ld [hli], a
	ret nc
	dec [hl]
	ret
.move_right
	add b
	ld [hli], a
	ret nc
	inc [hl]
	ret
