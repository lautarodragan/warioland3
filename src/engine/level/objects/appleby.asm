ApplebyFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, ApplebyFrameset_689e9
	call SetObjectFramesetPtr
	ld a, 5
	ld [hli], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 7
	ld [hld], a
	ld a, -8
	ld [hld], a
	ld a, -1
	ld [hld], a
	ret

.Hidden:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, ApplebyFrameset_68a00
	call SetObjectFramesetPtr
	ld a, 29
	ld [hli], a
	ld a, OBJSTATE_5A
	ld [wCurObjState], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .Hidden
	cp OBJSTATE_ACTIVATE
	jp c, .HandleHit
	cp OBJSTATE_5A
	jr z, .emerging
	cp OBJSTATE_5B
	jr z, .watching
	cp OBJSTATE_5C
	jr z, .throwing
	cp OBJSTATE_SPECIAL_1
	jr z, .hiding
	ret

.emerging
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, ApplebyFrameset_68a12
	call SetObjectFramesetPtr
	ld a, OBJSTATE_5B
	ld [wCurObjState], a
	ret

.hiding
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, ApplebyFrameset_689e9
	call SetObjectFramesetPtr
	ld a, 60
	ld [hli], a
	xor a
	ld [wCurObjState], a
	ret

.throwing
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	cp $46
	jr nz, .count_down
	ld a, [wCurObjSubState]
	rlca
	jr c, .throw_right
	ld bc, ObjParams_AppleLeft
	jr .spawn_apple
.throw_right
	ld bc, ObjParams_AppleRight
.spawn_apple
	call CreateObjectAtRelativePos
	ld hl, wCurObjStateDuration
.count_down
	dec [hl]
	ret nz
	ld l, OBJ_STATE
	jr .start_hiding
.watching
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .check_wario
	dec [hl]
	ret

.check_wario
	ld l, OBJ_SUBSTATE
	ld c, $2a
	ld a, [wCurObjScreenYPos]
	add c
	ld b, a
	ld a, [wWarioScreenYPos]
	add c
	sub b
	cp $04
	ret c
	cp $46
	ret nc
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $40
	jr nc, .check_wario_right
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, ApplebyFrameset_68a1f
	jr .start_throw
.check_wario_right
	cp $c0
	ret c
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, ApplebyFrameset_68a3a
.start_throw
	call SetObjectFramesetPtr
	ld a, 122
	ld [hli], a
	ld a, OBJSTATE_5C
	ld [wCurObjState], a
	ret

.HandleHit:
	cp OBJSTATE_VANISH_TOUCH
	jr z, .vanish
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .set_attacked_left
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .set_attacked_right
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .set_hit_by_obj_left
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .set_hit_by_obj_right
.start_hiding
	ld a, OBJSTATE_SPECIAL_1
	ld [hl], a
	ld de, ApplebyFrameset_68a09
	call SetObjectFramesetPtr
	ld a, 29
	ld [hli], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret

.vanish
	jp VanishObject
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
	ld de, ApplebyFrameset_68a63
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], b
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

AppleFunc_Left:
	ld a, HIGH(AppleFunc.Update1_Left)
	ld b, LOW(AppleFunc.Update1_Left)
	jr AppleFunc
AppleFunc_Right:
	ld a, HIGH(AppleFunc.Update1_Right)
	ld b, LOW(AppleFunc.Update1_Right)
AppleFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld [hld], a
	ld [hl], b
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_ENEMY_THROW
	ret

.Update1_Left:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(AppleFunc.Update2_Left)
	ld [hld], a
	ld a, LOW(AppleFunc.Update2_Left)
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	sub b
	ret c
	cp $10
	ret c
	ld l, OBJ_VAR_1
	ld a, $01
	ld [hli], a
	ld a, $02
	ld [hl], a
	ret

.Update1_Right:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(AppleFunc.Update2_Right)
	ld [hld], a
	ld a, LOW(AppleFunc.Update2_Right)
	ld [hld], a
	ld a, [wCurObjScreenXPos]
	add $2a
	ld b, a
	ld a, [wWarioScreenXPos]
	add $2a
	sub b
	ret c
	cp $10
	ret c
	ld l, OBJ_VAR_1
	ld a, $01
	ld [hli], a
	ld a, $02
	ld [hl], a
	ret

.Update2_Left:
	ld hl, wCurObjVar1
	ld a, [hli]
	jr nz, .move_left
	ld a, [wGlobalCounter]
	rra
	jr c, .check_state
.move_left
	ld b, [hl]
	ld l, OBJ_X_POS
	ld a, [hl]
	sub b
	ld [hli], a
	jr nc, .check_state
	dec [hl]
	jr .check_state
.Update2_Right:
	ld hl, wCurObjVar1
	ld a, [hli]
	and a
	jr nz, .move_right
	ld a, [wGlobalCounter]
	rra
	jr nc, .check_state
.move_right
	ld b, [hl]
	ld l, OBJ_X_POS
	ld a, [hl]
	add b
	ld [hli], a
	jr nc, .check_state
	inc [hl]
.check_state
	ld a, [wCurObjState]
	cp OBJSTATE_TRIGGERED
	jr z, .destroy
	cp OBJSTATE_NO_EFFECT
	jr z, .hop_away
	ld bc, ApplebyData_60670
	jp ApplyObjYMovement
.destroy
	xor a
	ld [wCurObjFlags], a
	ret

.hop_away
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .wario_to_right
	ld bc, .HopRight
	jr .set_hop
.wario_to_right
	ld bc, .HopLeft
.set_hop
	ld hl, wCurObjUpdateFunction + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	xor a
	ld [wCurObjVar3], a
	ret

.HopLeft:
	call MoveObjectLeft
	jr .apply_hop
.HopRight:
	call MoveObjectRight
.apply_hop
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, DropYVel_Light
	jp ApplyObjYMovement
