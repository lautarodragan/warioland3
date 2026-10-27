FallingSnowSpawnerFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitAndSpawn)
	ld [hld], a
	ld a, LOW(.WaitAndSpawn)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, $1e
	ld [wCurObjStateDuration], a
	ret

.WaitAndSpawn:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $56
	ld [hli], a
	xor a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ShowWarning)
	ld [hld], a
	ld a, LOW(.ShowWarning)
	ld [hld], a
	ld bc, ObjParams_FallingSnow
	jp CreateObjectFromCurObjPos

.ShowWarning:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $0a
	ld [wCurObjVar2], a
	call MoveObjectUpByVar2
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.HideWarning)
	ld [hld], a
	ld a, LOW(.HideWarning)
	ld [hld], a
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld de, Frameset_695c0
	call SetObjectFramesetPtr
	ld a, $1d
	ld [hli], a
	ldh a, [rDIV]
	rra
	ret nc
	ld a, $01
	ld [hl], a
	jp MoveObjectLeftByVar2

.HideWarning:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $3c
	ld [hli], a
	ld a, [hl]
	and a
	jr z, .asm_495b1
	call MoveObjectRightByVar2
.asm_495b1
	call MoveObjectDownByVar2
	ld hl, wCurObjFlags
	set OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitAndSpawn)
	ld [hld], a
	ld a, LOW(.WaitAndSpawn)
	ld [hld], a
	ret

FallingSnowFunc:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, Frameset_6958f
	call SetObjectFramesetPtr
	ld a, $20
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartFall)
	ld [hld], a
	ld a, LOW(.StartFall)
	ld [hld], a
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	play_sfx SFX_080
	ret

.StartFall:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, Frameset_695a6
	call SetObjectFramesetPtr
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Fall)
	ld [hld], a
	ld a, LOW(.Fall)
	ld [hld], a
	ld l, OBJ_Y_POS
	ld a, [hl]
	add $08
	ld [hli], a
	ret nc
	inc [hl]
	ret

.Fall:
	ld a, [wCurObjState]
	and a
	jr z, .asm_49625
	cp $18
	jr z, .asm_49666
	ld de, Frameset_695cb
	call SetObjectFramesetPtr
	ld a, $11
	ld [hli], a
	jr .asm_49650
.asm_49625
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
	ld bc, Data_603e0
	jp z, ApplyObjYMovement
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld de, Frameset_695af
	call SetObjectFramesetPtr
	ld a, $2d
	ld [hli], a
.asm_49650
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitAndDespawn)
	ld [hld], a
	ld a, LOW(.WaitAndDespawn)
	ld [hld], a
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	play_sfx SFX_0A1
	ret

.asm_49666
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.FallBroken)
	ld [hld], a
	ld a, LOW(.FallBroken)
	ld [hld], a
	ld de, Frameset_695d6
	jp SetObjectFramesetPtr

.FallBroken:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
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
	ld bc, Data_603e0
	jp z, ApplyObjYMovement
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld de, Frameset_695d9
	call SetObjectFramesetPtr
	ld a, $07
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitAndDespawn)
	ld [hld], a
	ld a, LOW(.WaitAndDespawn)
	ld [hld], a
	ret

.WaitAndDespawn:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret
