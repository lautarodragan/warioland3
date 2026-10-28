Barrel1Func:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update1)
	ld [hld], a
	ld a, LOW(.Update1)
	ld [hld], a
	ld de, BarrelFrameset_68a7b
	call SetObjectFramesetPtr
	ld a, $0a
	ld [hli], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $f7
	ld [hl], a
	ret

.Update1:
	ld hl, wCurObjFlags
	bit OBJFLAG_STEPPED_F, [hl]
	jr z, .not_stepped
	res OBJFLAG_STEPPED_F, [hl]
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld de, BarrelFrameset_68a7e
	call SetObjectFramesetPtr
	ld a, $11
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update2)
	ld [hld], a
	ld a, LOW(.Update2)
	ld [hld], a
	xor a
	ld [wCurObjVar3], a
	ret

.not_stepped
	ld a, $0a
	ld [wCurObjStateDuration], a
	ret

.Update2:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .jump
	dec [hl]
	ret nz
	play_sfx SFX_BARREL_JUMP
	ret

.jump
	ld bc, BarrelData_60a50
	jp ApplyObjYMovement_Platform

Barrel2Func:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld de, BarrelFrameset_68a78
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

	dw .Default
	dw .Default
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .AttackedLeftStart
	dw .AttackedRightStart
	dw .PickedUpLeftStart
	dw .PickedUpRightStart
	dw .BumpLeftStart
	dw .BumpRightStart
	dw VanishAndDespawnObject
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .State12
	dw .TurnAroundStart
	dw .State14
	dw .State15
	dw .Default
	dw .Default
	dw .State18
	dw .State19
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .State28
	dw .State29
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Special3
	dw .Default
	dw .TurnAroundStart
	dw ObjState_BumpLeft
	dw ObjState_BumpRight
	dw .Default
	dw .Default
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_Drop
	dw .Default
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .Default
	dw .Default
	dw .State48
	dw .State49
	dw ObjState_GrabbedChargeLeft
	dw ObjState_GrabbedChargeRight
	dw .FullThrowLeftStart
	dw .FullThrowRightStart
	dw ObjState_ThrowLeft
	dw ObjState_ThrowRight
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_FullThrowLeft
	dw ObjState_FullThrowRight

.Default:
	ld a, OBJSTATE_SPECIAL_3
	ld [wCurObjState], a
	ld de, BarrelFrameset_68a8b
	call SetObjectFramesetPtr
	ld a, $0e
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
	ld a, $02
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
	ld de, BarrelFrameset_68a78
	call SetObjectFramesetPtr
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
	ld de, BarrelFrameset_68a78
	call SetObjectFramesetPtr
	jp ObjState_PickedUpRight

.State19:
	ld a, OBJSTATE_GRABBED_RIGHT
	ld [wCurObjState], a
	ld de, BarrelFrameset_68a78
	call SetObjectFramesetPtr
	ld l, OBJ_FLAGS
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
	ld de, BarrelFrameset_68a78
	call SetObjectFramesetPtr
	ld l, OBJ_FLAGS
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
	ld de, BarrelFrameset_68a6f
	call SetObjectFramesetPtr
	jp ObjState_FullThrowLeft
.FullThrowRightStart:
	ld a, OBJSTATE_FULL_THROW_RIGHT
	ld [wCurObjState], a
	ld de, BarrelFrameset_68a66
	call SetObjectFramesetPtr
	jp ObjState_FullThrowRight
.State28:
	ld de, BarrelFrameset_68a6f
	call SetObjectFramesetPtr
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
	ld b, $02
	jr .set_update_func

.State29:
	ld de, BarrelFrameset_68a66
	call SetObjectFramesetPtr
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	ld b, $02
	jr .set_update_func

.AttackedRightStart:
	ld de, BarrelFrameset_68a6f
	call SetObjectFramesetPtr
	ld a, HIGH(ObjState_AttackedRight)
	ld c, LOW(ObjState_AttackedRight)
	ld b, $02
	jr .set_update_func

.AttackedLeftStart:
	ld de, BarrelFrameset_68a66
	call SetObjectFramesetPtr
	ld a, HIGH(ObjState_AttackedLeft)
	ld c, LOW(ObjState_AttackedLeft)
	ld b, $02
.set_update_func
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld [hl], b
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret
