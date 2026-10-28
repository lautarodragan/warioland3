RockFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, RockFrameset_69bfe
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $00
	ld [hl], a
	ld a, $31
	ld [wCurObjState], a
	ret

.Update:
	ld a, [wCurObjState]
	jumptable

	dw .Destroy
	dw .Destroy
	dw .Func_4aa27
	dw .Func_4aa2f
	dw .Func_4aae3
	dw .Func_4aadb
	dw .Func_4aa53
	dw .Func_4aa66
	dw .Func_4aa27
	dw .Func_4aa2f
	dw VanishAndDespawnObject
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Func_4aaae
	dw .Func_4aa26
	dw .Func_4aa40
	dw .Func_4aa44
	dw .Destroy
	dw .Destroy
	dw .Func_4aa93
	dw .Func_4aa79
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Func_4aacb
	dw .Func_4aad3
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Func_4aa0a
	dw .Destroy
	dw .Func_4aa26
	dw ObjState_BumpLeft
	dw ObjState_BumpRight
	dw .Destroy
	dw .Destroy
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw ObjState_Drop
	dw .Destroy
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .Destroy
	dw .Destroy
	dw .Func_4aa9d
	dw .Func_4aa83
	dw ObjState_GrabbedChargeLeft
	dw ObjState_GrabbedChargeRight
	dw .Func_4aabb
	dw .Func_4aac3
	dw ObjState_ThrowLeft
	dw ObjState_ThrowRight
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw ObjState_FullThrowLeft
	dw ObjState_FullThrowRight

.Destroy:
	ld a, $2f
	ld [wCurObjState], a
	ld de, RockFrameset_69c01
	call SetObjectFramesetPtr
	ld a, $19
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_TEMPLE_ROCK

.Func_4aa0a:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_MAP_PTR_HI
	farcall DespawnObject
	ret

.Func_4aa26:
	ret

.Func_4aa27:
	ld hl, wCurObjState
	ld a, $32
	ld [hld], a
	jr .asm_4aa35
.Func_4aa2f:
	ld hl, wCurObjState
	ld a, $33
	ld [hld], a
.asm_4aa35
	ld a, $0c
	ld [wCurObjStateDuration], a
	ld a, $01
	ld [wCurObjVar2], a
	ret
.Func_4aa40:
	ld a, $44
	jr .asm_4aa46
.Func_4aa44:
	ld a, $45
.asm_4aa46
	ld [wCurObjState], a
	xor a
	ld [wCurObjVar3], a
	ld a, $02
	ld [wCurObjVar2], a
	ret
.Func_4aa53:
	ld hl, wCurObjState
	ld a, $36
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $c0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpLeft
.Func_4aa66:
	ld hl, wCurObjState
	ld a, $37
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $e0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpRight

.Func_4aa79:
	ld a, $49
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	set OBJFLAG_GRABBED_F, [hl]
.Func_4aa83:
	ld a, [wDirection]
	and a
	jp nz, ObjState_GrabbedRight
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	jr .Func_4aa93

.Func_4aa93:
	ld a, $48
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	set OBJFLAG_GRABBED_F, [hl]
.Func_4aa9d:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	jp .Func_4aa79

.Func_4aaae:
	ld hl, wCurObjAction
	ld a, $9f
	ld [hld], a
	ld a, $42
	ld [hld], a
	dec l
	xor a
	ld [hl], a
	ret

.Func_4aabb:
	ld a, $5e
	ld [wCurObjState], a
	jp ObjState_FullThrowLeft

.Func_4aac3:
	ld a, $5f
	ld [wCurObjState], a
	jp ObjState_FullThrowRight

.Func_4aacb:
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .asm_4aae9
.Func_4aad3:
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .asm_4aae9
.Func_4aadb:
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
	jr .asm_4aae9
.Func_4aae3:
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
.asm_4aae9
	ld hl, wCurObjUpdateFunction + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld [hl], b
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret
