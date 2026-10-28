PillarPlatform2Func:
	ld b, $02
	ld hl, wCurObjYPos
	ld a, [hl]
	sub $10
	ld [hli], a
	jr nc, PillarPlatformFunc
	dec [hl]
	jr PillarPlatformFunc
PillarPlatform3Func:
	ld b, $00
	ld hl, wCurObjYPos
	ld a, [hl]
	add $10
	ld [hli], a
	jr nc, PillarPlatformFunc
	inc [hl]
	jr PillarPlatformFunc
PillarPlatform1Func:
	ld b, $01
PillarPlatformFunc:
	ld a, b
	ld [wCurObjVar1], a
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $00
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $f4
	ld [hl], a
	ld a, [wDayNight]
	rra
	jr c, .night
	ld de, PillarPlatformFrameset_6975b
	jp SetObjectFramesetPtr

.night
	ld de, PillarPlatformFrameset_6975e
	jp SetObjectFramesetPtr

.Rise:
	call SetOneWayPlatformAction
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectUp_Fast
	jr .stop_moving
.Lower:
	call SetOneWayPlatformAction
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectDown_Fast
.stop_moving
	xor a
	ld [wCurObjState], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ret

.Update:
	call SetOneWayPlatformAction
	ld hl, wCurObjState
	ld a, [hl]
	and a
	ret z
	cp $2b
	jr z, .raise_requested
	cp $0a
	jr z, .lower_requested
	xor a
	ld [hl], a
	ret

.raise_requested
	ld l, OBJ_VAR_1
	ld a, [hl]
	cp $02
	jr c, .start_rise
	xor a
	ld [wCurObjState], a
	ret

.start_rise
	inc [hl]
	dec l
	ld a, $09
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Rise)
	ld [hld], a
	ld a, LOW(.Rise)
	ld [hld], a
	ret

.lower_requested
	ld l, OBJ_VAR_1
	ld a, [hl]
	and a
	jr nz, .start_lower
	ld [wCurObjState], a
	ret

.start_lower
	dec [hl]
	dec l
	ld a, $09
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Lower)
	ld [hld], a
	ld a, LOW(.Lower)
	ld [hld], a
	ld a, [wCurObjUnk01]
	add $03
	ld e, a
	ld c, $2b
	ld a, $00
	ld b, $00
	call .SetLinkedPlatformsState
	ld a, [wCurObjUnk01]
	sub $03
	ld e, a
	ld a, $00
	ld b, $00
.SetLinkedPlatformsState:
	ld h, HIGH(wObjects)
.loop
	ld l, OBJ_MAP_PTR_LO
	add l
	ld l, a
	ld a, [hl]
	cp e
	jr nz, .next_obj
	ld a, l
	add $06
	ld l, a
	ld a, [hl]
	cp $20
	jr nz, .next_obj
	ld a, l
	add $14
	ld l, a
	ld [hl], c
.next_obj
	ld a, b
	cp $e0
	ret z
	add $20
	ld b, a
	jr .loop
