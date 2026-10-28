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
	ld a, OBJSTATE_WALK
	ld [wCurObjState], a
	ret

.Update:
	ld a, [wCurObjState]
	jumptable

	dw .Destroy
	dw .Destroy
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .AttackedLeftStart
	dw .AttackedRightStart
	dw .PickedUpLeftStart
	dw .PickedUpRightStart
	dw .BumpLeftStart
	dw .BumpRightStart
	dw VanishAndDespawnObject
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .State12
	dw .TurnAroundStart
	dw .State14
	dw .State15
	dw .Destroy
	dw .Destroy
	dw .State18
	dw .State19
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
	dw .State28
	dw .State29
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Destroy
	dw .Special3
	dw .Destroy
	dw .TurnAroundStart
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
	dw .State48
	dw .State49
	dw ObjState_GrabbedChargeLeft
	dw ObjState_GrabbedChargeRight
	dw .FullThrowLeftStart
	dw .FullThrowRightStart
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
	ld a, OBJSTATE_SPECIAL_3
	ld [wCurObjState], a
	ld de, RockFrameset_69c01
	call SetObjectFramesetPtr
	ld a, $19
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_TEMPLE_ROCK

.Special3:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_MAP_PTR_HI
	farcall DespawnObject
	ret

.TurnAroundStart:
	ret

.BumpLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_LEFT
	ld [hld], a
	jr .set_bump
.BumpRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_BUMP_RIGHT
	ld [hld], a
.set_bump
	ld a, $0c
	ld [wCurObjStateDuration], a
	ld a, $01
	ld [wCurObjVar2], a
	ret
.State14:
	ld a, OBJSTATE_FALL_LEFT
	jr .set_fall
.State15:
	ld a, OBJSTATE_FALL_RIGHT
.set_fall
	ld [wCurObjState], a
	xor a
	ld [wCurObjVar3], a
	ld a, $02
	ld [wCurObjVar2], a
	ret
.PickedUpLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_PICKED_UP_LEFT
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $c0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpLeft
.PickedUpRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_PICKED_UP_RIGHT
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $e0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpRight

.State19:
	ld a, OBJSTATE_GRABBED_RIGHT
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	set OBJFLAG_GRABBED_F, [hl]
.State49:
	ld a, [wDirection]
	and a
	jp nz, ObjState_GrabbedRight
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	jr .State18

.State18:
	ld a, OBJSTATE_GRABBED_LEFT
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	set OBJFLAG_GRABBED_F, [hl]
.State48:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	ld hl, wCurObjSubState
	ld a, [hl]
	xor $80
	ld [hl], a
	jp .State19

.State12:
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_DROP
	ld [hld], a
	dec l
	xor a
	ld [hl], a
	ret

.FullThrowLeftStart:
	ld a, OBJSTATE_FULL_THROW_LEFT
	ld [wCurObjState], a
	jp ObjState_FullThrowLeft

.FullThrowRightStart:
	ld a, OBJSTATE_FULL_THROW_RIGHT
	ld [wCurObjState], a
	jp ObjState_FullThrowRight

.State28:
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .set_update_func
.State29:
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .set_update_func
.AttackedRightStart:
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
	jr .set_update_func
.AttackedLeftStart:
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
.set_update_func
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
