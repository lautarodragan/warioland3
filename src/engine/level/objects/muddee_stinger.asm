MuddeeStingerFunc:
	ld hl, wCurObjFlags
	set OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_SUBSTATE
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ret

.Update:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wCurObjState]
	cp $0a
	jr nz, .check_hit
	ld a, $01
	ld [w1d147], a
.check_hit
	ld a, [w1d147]
	and a
	jr z, .find_muddee
	xor a
	ld [wCurObjFlags], a
	ret
.find_muddee
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp MUDDEE
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr c, .found_muddee
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_muddee
	ld a, l
	add $0f
	ld l, a
	ld c, [hl]
	ld a, l
	sub $0c
	ld l, a
	ld a, [wCurObjId]
	cp MUDDEE_STINGER2
	jr z, .stinger2
	ld de, MuddeeStingerData_4caed
	jr .got_offsets
.stinger2
	ld de, MuddeeStingerData_4cb0d
.got_offsets
	ld a, c
	cp $10
	jr c, .apply_offset
	ld a, [hli]
	ld [wCurObjYPos + 0], a
	ld a, [hli]
	ld [wCurObjYPos + 1], a
	ld a, [hli]
	ld [wCurObjXPos + 0], a
	ld a, [hl]
	ld [wCurObjXPos + 1], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret
.apply_offset
	add a
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	ld a, [de]
	ld c, a
	cp $80
	jr nc, .negative_y
	ld a, [hli]
	add c
	ld [wCurObjYPos + 0], a
	jr nc, .same_y_hi
	ld a, [hl]
	inc a
	ld [wCurObjYPos + 1], a
	jr .x_offset
.negative_y
	ld a, [hli]
	add c
	ld [wCurObjYPos + 0], a
	jr c, .same_y_hi
	ld a, [hl]
	dec a
	ld [wCurObjYPos + 1], a
	jr .x_offset
.same_y_hi
	ld a, [hl]
	ld [wCurObjYPos + 1], a
.x_offset
	inc l
	inc de
	ld a, [de]
	ld c, a
	cp $80
	jr nc, .negative_x
	ld a, [hli]
	add c
	ld [wCurObjXPos + 0], a
	jr nc, .same_x_hi
	ld a, [hl]
	inc a
	ld [wCurObjXPos + 1], a
	ret
.negative_x
	ld a, [hli]
	add c
	ld [wCurObjXPos + 0], a
	jr c, .same_x_hi
	ld a, [hl]
	dec a
	ld [wCurObjXPos + 1], a
	ret
.same_x_hi
	ld a, [hl]
	ld [wCurObjXPos + 1], a
	ret

MuddeeStingerData_4caed:
	db  25,   0
	db  23,  -5
	db  23,   5
	db   8,  18
	db  14,  18
	db   2,  18
	db -13,   0
	db -11,  -5
	db -11,   5
	db   8, -19
	db  14, -19
	db   2, -19
	db  18,   9
	db  -5,   9
	db  -5, -10
	db  18, -10

MuddeeStingerData_4cb0d:
	db  -7,   0
	db  -6,  -5
	db  -6,   5
	db   7, -12
	db  13, -10
	db   1, -10
	db  21,   0
	db  19,  -5
	db  19,   5
	db   7,  11
	db  13,   9
	db   1,   9
	db  -1, -11
	db  16, -11
	db  16,  10
	db  -1,  10
