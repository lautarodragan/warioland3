MizuuoFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update1)
	ld [hld], a
	ld a, LOW(.Update1)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld de, MizuuoFrameset_686e5
	call SetObjectFramesetPtr
	inc l
	ld a, $30
	ld [hli], a
	ld a, $08
	ld [hl], a
	jp MoveObjectLeftByVar2

.Update1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .swim
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor $80
	ld [hl], a
	rlca
	jr c, .turned_right
	ld de, MizuuoFrameset_686e5
	jp SetObjectFramesetPtr

.turned_right
	ld de, MizuuoFrameset_686ea
	jp SetObjectFramesetPtr

.swim
	inc l
	ld a, [hl]
	cp $5f
	jr z, .start_shoot
	dec [hl]
	jr z, .turn_around
	ld a, [wCurObjSubState]
	rlca
	jp c, MoveObjectRight
	jp MoveObjectLeft
.turn_around
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset MizuuoFrameset_68713, MizuuoFrameset_6871e
	call SetObjectFramesetPtr
	ld a, $22
	ld [hli], a
	ld a, $60
	ld [hl], a
	ret

.start_shoot
	dec [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update2)
	ld [hld], a
	ld a, LOW(.Update2)
	ld [hld], a
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset MizuuoFrameset_686ef, MizuuoFrameset_686f8
	call SetObjectFramesetPtr
	ld a, $19
	ld [hli], a
	ret

.Update2:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update3)
	ld [hld], a
	ld a, LOW(.Update3)
	ld [hld], a
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset MizuuoFrameset_686a4, MizuuoFrameset_686b9
	call SetObjectFramesetPtr
	ld a, $5d
	ld [hli], a
	ret

.Update3:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr nz, .reset_state
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr z, .end_shoot
	ld a, [hl]
	cp $24
	ret nz
	play_sfx SFX_07F
	ld a, [wCurObjSubState]
	rlca
	jr c, .shoot_right
	ld bc, ObjParams_MizzouProjectileLeft
	jp CreateObjectAtRelativePos
.shoot_right
	ld bc, ObjParams_MizzouProjectileRight
	jp CreateObjectAtRelativePos
.reset_state
	xor a
	ld [hl], a
.end_shoot
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset MizuuoFrameset_68701, MizuuoFrameset_6870a
	call SetObjectFramesetPtr
	ld a, $19
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update4)
	ld [hld], a
	ld a, LOW(.Update4)
	ld [hld], a
	ret

.Update4:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update1)
	ld [hld], a
	ld a, LOW(.Update1)
	ld [hld], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .resume_facing_right
	ld de, MizuuoFrameset_686e5
	jp SetObjectFramesetPtr

.resume_facing_right
	ld de, MizuuoFrameset_686ea
	jp SetObjectFramesetPtr

MizzouProjectileFunc_Left:
	call MoveObjectLeft_Fast
	jr MizzouProjectileFunc
MizzouProjectileFunc_Right:
	call MoveObjectRight_Fast
MizzouProjectileFunc:
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
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
	jr nz, .burst
	ld a, [wCurObjVar1]
	and a
	jr z, .rising
	call ProcessBlock_Down
	and a
	jr nz, .burst
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .in_water
	ld bc, MizuuoData_60740
	jr .apply_movement
.rising
	ld bc, MizuuoData_60700
.apply_movement
	call ApplyObjYMovement
	ld a, [wCurObjState]
	and a
	jr nz, .burst
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	inc l
	ld a, $01
	ld [hl], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .facing_right
	ld de, MizuuoFrameset_686d8
	jp SetObjectFramesetPtr

.facing_right
	ld de, MizuuoFrameset_686db
	jp SetObjectFramesetPtr

.burst
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, MizuuoFrameset_686de
	call SetObjectFramesetPtr
	ld a, $17
	ld [hli], a
	ret

.in_water
	xor a
	ld [wCurObjFlags], a
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret
