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
	ld a, no_actions_for 1
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
	ld a, no_actions_for 1
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
	ld a, no_actions_for 1
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
	ld a, no_actions_for 1
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
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_49ee2
	dec [hl]
	ret nz
	ld de, TadpoleFrameset_69a3d
	jp SetObjectFramesetPtr
.asm_49ee2
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

.asm_49efe
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

.asm_49f0e
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .asm_49f1c
.asm_49f16
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
.asm_49f1c
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld [hl], b
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld de, TadpoleFrameset_69a30
	jp SetObjectFramesetPtr

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_49f5e
	cp OBJSTATE_HIT_WARIO_RIGHT_START
	jr z, .asm_49efe
	cp OBJSTATE_WOBBLE_LEFT_START
	jr z, .asm_49f16
	cp OBJSTATE_WOBBLE_RIGHT_START
	jr z, .asm_49f0e
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START
	jr z, .asm_49f0e
	cp OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .asm_49f16
	cp OBJSTATE_VANISH_TOUCH
	jp z, VanishAndDespawnObject
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .asm_49f16
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .asm_49f0e
	xor a
	ld [hl], a
.asm_49f5e
	ld l, OBJ_VAR_1
	ld a, [hl]
	and a
	jr z, .asm_49f97
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
	jr nz, .asm_49f85
	ld bc, TadpoleData_60a40
	call ApplyObjYMovement
	jp MoveObjectLeft_Fast

.asm_49f85
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

.asm_49f97
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .asm_49fa7
	dec [hl]
	ld bc, TadpoleData_60a20
	call ApplyObjYMovement
	jp MoveObjectLeft_Fast

.asm_49fa7
	xor a
	ld [wCurObjVar3], a
	inc a
	ld [wCurObjVar1], a
	ld de, TadpoleFrameset_69a1d
	jp SetObjectFramesetPtr

.WaitAndDespawn:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret
