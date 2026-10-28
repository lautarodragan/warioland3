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
	jr z, .asm_47a1e
	cp OBJSTATE_5B
	jr z, .asm_47a6b
	cp OBJSTATE_5C
	jr z, .asm_47a4a
	cp OBJSTATE_SPECIAL_1
	jr z, .asm_47a33
	ret

.asm_47a1e
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, ApplebyFrameset_68a12
	call SetObjectFramesetPtr
	ld a, 91
	ld [wCurObjState], a
	ret

.asm_47a33
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

.asm_47a4a
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	cp $46
	jr nz, .asm_47a65
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_47a5c
	ld bc, ObjParams_AppleLeft
	jr .asm_47a5f
.asm_47a5c
	ld bc, ObjParams_AppleRight
.asm_47a5f
	call CreateObjectAtRelativePos
	ld hl, wCurObjStateDuration
.asm_47a65
	dec [hl]
	ret nz
	ld l, OBJ_STATE
	jr .asm_47ac4
.asm_47a6b
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .asm_47a73
	dec [hl]
	ret

.asm_47a73
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
	jr nc, .asm_47a9c
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, ApplebyFrameset_68a1f
	jr .asm_47aa4
.asm_47a9c
	cp $c0
	ret c
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, ApplebyFrameset_68a3a
.asm_47aa4
	call SetObjectFramesetPtr
	ld a, 122
	ld [hli], a
	ld a, OBJSTATE_5C
	ld [wCurObjState], a
	ret

.HandleHit:
	cp OBJSTATE_VANISH_TOUCH
	jr z, .asm_47ad5
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .asm_47ae8
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .asm_47af0
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .asm_47ad8
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .asm_47ae0
.asm_47ac4
	ld a, OBJSTATE_SPECIAL_1
	ld [hl], a
	ld de, ApplebyFrameset_68a09
	call SetObjectFramesetPtr
	ld a, 29
	ld [hli], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret

.asm_47ad5
	jp VanishObject
.asm_47ad8
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .asm_47af6
.asm_47ae0
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .asm_47af6
.asm_47ae8
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
	jr .asm_47af6
.asm_47af0
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
.asm_47af6
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
	jr nz, .asm_47b7b
	ld a, [wGlobalCounter]
	rra
	jr c, .asm_47b9c
.asm_47b7b
	ld b, [hl]
	ld l, OBJ_X_POS
	ld a, [hl]
	sub b
	ld [hli], a
	jr nc, .asm_47b9c
	dec [hl]
	jr .asm_47b9c
.Update2_Right:
	ld hl, wCurObjVar1
	ld a, [hli]
	and a
	jr nz, .asm_47b93
	ld a, [wGlobalCounter]
	rra
	jr nc, .asm_47b9c
.asm_47b93
	ld b, [hl]
	ld l, OBJ_X_POS
	ld a, [hl]
	add b
	ld [hli], a
	jr nc, .asm_47b9c
	inc [hl]
.asm_47b9c
	ld a, [wCurObjState]
	cp OBJSTATE_TRIGGERED
	jr z, .destroy
	cp OBJSTATE_NO_EFFECT
	jr z, .asm_47bb2
	ld bc, ApplebyData_60670
	jp ApplyObjYMovement
.destroy
	xor a
	ld [wCurObjFlags], a
	ret

.asm_47bb2
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_47bc5
	ld bc, .HopRight
	jr .asm_47bc8
.asm_47bc5
	ld bc, .HopLeft
.asm_47bc8
	ld hl, wCurObjUpdateFunction + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	xor a
	ld [wCurObjVar3], a
	ret

.HopLeft:
	call MoveObjectLeft
	jr .asm_47bdb
.HopRight:
	call MoveObjectRight
.asm_47bdb
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, DropYVel_Light
	jp ApplyObjYMovement
