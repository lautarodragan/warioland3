TadpoleSpawnerFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitForWario)
	ld [hld], a
	ld a, LOW(.WaitForWario)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, 180
	ld [wCurObjStateDuration], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret

.WaitForWario:
	ld a, $81
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	ret c
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	sub b
	cp $50
	ret nc
	cp $28
	ret c
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitAndDespawn)
	ld [hld], a
	ld a, LOW(.WaitAndDespawn)
	ld [hld], a
	ld bc, ObjParams_Tadpole
	jp CreateObjectAtRelativePos

.WaitAndDespawn:
	ld a, $81
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_MAP_PTR_HI
	farcall DespawnObject
	ret

TadpoleFunc:
	ld a, $81
	ld [wCurObjAction], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitOnScreen)
	ld [hld], a
	ld a, LOW(.WaitOnScreen)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_INVISIBLE_F, [hl]
	ret

.WaitOnScreen:
	ld a, $81
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Appear)
	ld [hld], a
	ld a, LOW(.Appear)
	ld [hld], a
	ld de, TadpoleFrameset_69a33
	jp SetObjectFramesetPtr

.Appear:
	ld a, $81
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .start_swim
	dec [hl]
	ret nz
	ld de, TadpoleFrameset_69a3d
	jp SetObjectFramesetPtr
.start_swim
	ld de, TadpoleFrameset_69a1a
	call SetObjectFramesetPtr
	ld a, $20
	ld [hli], a
	xor a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	play_sfx SFX_07F
	ret

.hit_wario
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(ObjState_HitByObjRight)
	ld [hld], a
	ld a, LOW(ObjState_HitByObjRight)
	ld [hl], a
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld a, $01
	ld [hl], a
	ret

.hit_from_left
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .set_hit
.hit_from_right
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
.set_hit
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld [hl], b
	ld a, $81
	ld [wCurObjAction], a
	ld de, TadpoleFrameset_69a30
	jp SetObjectFramesetPtr

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .move
	cp OBJSTATE_HIT_WARIO_RIGHT_START
	jr z, .hit_wario
	cp OBJSTATE_WOBBLE_LEFT_START
	jr z, .hit_from_right
	cp OBJSTATE_WOBBLE_RIGHT_START
	jr z, .hit_from_left
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .hit_from_left
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .hit_from_right
	cp OBJSTATE_VANISH_TOUCH
	jp z, VanishAndDespawnObject
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .hit_from_right
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .hit_from_left
	xor a
	ld [hl], a
.move
	ld l, OBJ_VAR_1
	ld a, [hl]
	and a
	jr z, .jump_up
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
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .splash
	ld bc, TadpoleData_60a40
	call ApplyObjYMovement
	jp MoveObjectLeft_Fast

.splash
	ld de, TadpoleFrameset_69a26
	call SetObjectFramesetPtr
	ld a, $09
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitAndDespawn)
	ld [hld], a
	ld a, LOW(.WaitAndDespawn)
	ld [hld], a
	ret

.jump_up
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .start_falling
	dec [hl]
	ld bc, TadpoleData_60a20
	call ApplyObjYMovement
	jp MoveObjectLeft_Fast

.start_falling
	xor a
	ld [wCurObjVar3], a
	inc a
	ld [wCurObjVar1], a
	ld de, TadpoleFrameset_69a1d
	jp SetObjectFramesetPtr

.WaitAndDespawn:
	ld a, $81
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret
