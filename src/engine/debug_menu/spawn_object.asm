; Debug menu helper, kept in the Object Loading bank next to SpawnObject and
; the object data it reads.

DEF DEBUG_SPAWN_X_OFFSET EQU 24 ; pixels to Wario's right

; Spawns the object with ID c next to Wario, using the current room's object
; group data for it (so its OAM, palette and graphics slot are the ones the
; room loaded). Does nothing if the group has no such object, or if every
; object slot is taken.
; The object has no object map entry: it vanishes when it goes offscreen
; or the room is left, instead of being written back into the map.
; Needs WRAM bank "Level Objects WRAM".
; input:
; - c = object ID
; output:
; - b = TRUE if spawned, FALSE otherwise
_DebugSpawnObject::
	ld b, FALSE
	ld hl, wObjDataPtr01
	ASSERT HIGH(wObjDataPtr01) == HIGH(wObjDataPointersEnd)
.find_data
	ld a, l
	cp LOW(wObjDataPointersEnd)
	ret z
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de] ; OBJ_ID
	cp c
	jr nz, .find_data

	ld h, HIGH(wObj1)
FOR n, 1, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n})
	ld a, [hli]
	rra
	jr nc, .got_obj ; OBJFLAG_ACTIVE not set
ENDR
	ret

.got_obj
	xor a
	ld [hli], a ; OBJ_UNK_01
	ld [hli], a ; OBJ_UNK_02
	ld a, [wWarioYPos + 1]
	ld [hli], a ; OBJ_Y_POS
	ld a, [wWarioYPos + 0]
	ld [hli], a
	ld a, [wWarioXPos + 1]
	add DEBUG_SPAWN_X_OFFSET
	ld [hli], a ; OBJ_X_POS
	ld a, [wWarioXPos + 0]
	adc 0
	ld [hli], a

	push hl
	ld h, d
	ld l, e
	pop de
	call SpawnObject.copy_data
	; de = OBJ_FLAGS
	ld a, [de]
	or OBJFLAG_TRANSIENT
	ld [de], a
	ld b, TRUE
	ret
