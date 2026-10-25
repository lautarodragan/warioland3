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
.got_data
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

; Like _DebugSpawnObject, but spawns an owl from its ROM data, for rooms
; whose object group has no owl. Its OAM always uses enemy graphics slot 1
; and object palette 4, so the caller has to load the owl's graphics and
; palette there (LoadOwlGfx).
; Needs WRAM bank "Level Objects WRAM".
; output:
; - b = TRUE if spawned, FALSE otherwise (no free object slot)
_DebugSpawnOwlFromROM::
	ld b, FALSE
	ld de, OwlData
	jr _DebugSpawnObject.got_data

; Loads the owl's graphics into enemy graphics slot 1 and its palette into
; object palette 4, where its OAM (and Owl Wario's) expects them. Whatever
; enemy the room keeps in slot 1 draws with them until the room is reloaded.
; The LCD must be off.
LoadOwlGfx::
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, OwlGfx
	ld bc, v1Tiles0
	ld a, BANK(OwlGfx)
	ldh [hCallFuncBank], a
	hcall Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, .pal
	ld de, wTempPals2 palette 4
	ld b, 1 palettes
	jp CopyHLToDE_Short

.pal
INCLUDE "gfx/pals/owl.pal"

; Owl Wario draws the owl he holds from slot 1, so a room he flies into has to
; have the owl's graphics there, even if its object group has no owl (only the
; debug menu's owl gets him into such a room).
; Called by LoadObjectGroupData, after the group's graphics and palettes.
; Needs WRAM bank "Level Objects WRAM".
LoadOwlGfxForOwlWario:
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	ret nz
	ld hl, wObjDataPtr01
.loop
	ld a, l
	cp LOW(wObjDataPointersEnd)
	jr z, LoadOwlGfx
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de] ; OBJ_ID
	cp OWL
	ret z ; the group has the owl, and so its graphics
	jr .loop
