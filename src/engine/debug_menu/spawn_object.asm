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
; whose object group has no owl. Its graphics go into an enemy graphics slot
; the group doesn't use (slot 1 if it uses all four), set in wOwlTileOffset;
; the caller has to load them there (LoadOwlGfx).
; Needs WRAM bank "Level Objects WRAM".
; output:
; - b = TRUE if spawned, FALSE otherwise (no free object slot)
_DebugSpawnOwlFromROM::
	ld b, FALSE
	ld de, OwlData
	call _DebugSpawnObject.got_data
	ld a, b
	and a
	ret z
	call SetOwlTileOffset
	ld b, TRUE
	ret

; Sets wOwlTileOffset to the first enemy graphics slot the room's object
; group doesn't use, or to slot 1 if it uses all four.
; Groups load graphics into all four slots, and their object lists are
; positional: entry n is the object whose graphics are in slot n. A slot is
; unused when its entry is DummyObjectData or the list ends before it, and
; the group loads the slot's filler graphics there (the ones in ObjectGroup0,
; the empty group). The filler check rules out the bosses and the multi-slot
; enemies (like Sun1/Sun2), whose short lists leave entries out of slots they
; do use.
SetOwlTileOffset:
	call .find
	ld [wOwlTileOffset], a
	ret

.find
	ld a, [wObjectGroup]
	cp OBJECT_GROUP_HIDDEN_FIGURE
	jr z, .slot_1
	ld l, a
	ld h, 0
	add hl, hl
	add hl, hl ; *4
	ld de, ObjectGroups + 2
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli] ; GFX bank offset
	and a
	jr nz, .slot_1 ; a boss: they use all four slots
	ld d, h
	ld e, l ; graphics list
	ld bc, 4 * 2
	add hl, bc ; object list
	ld c, $00 ; slot's tile offset
.loop
	ld a, [hli]
	ld b, [hl]
	inc hl
	inc b
	jr nz, .got_object
	; end of the list (NULL): stay on it for the slots after this one
	dec hl
	dec hl
	jr .no_object
.got_object
	dec b
	cp LOW(DummyObjectData)
	jr nz, .next
	ld a, b
	cp HIGH(DummyObjectData)
	jr nz, .next
.no_object
	push hl
	ld a, c
	swap a
	rrca ; slot * 2
	add LOW(ObjectGroup0 + 1)
	ld l, a
	adc HIGH(ObjectGroup0 + 1)
	sub l
	ld h, a ; slot's filler graphics in ObjectGroup0
	ld a, [de]
	cp [hl]
	jr nz, .not_filler
	inc de
	inc hl
	ld a, [de]
	dec de
	cp [hl]
	jr nz, .not_filler
	pop hl
	ld a, c
	ret

.not_filler
	pop hl
.next
	inc de
	inc de
	ld a, c
	add $40
	ld c, a
	jr nz, .loop
.slot_1
	xor a
	ret

; Loads the owl's graphics into the enemy graphics slot in wOwlTileOffset
; and its palette into that slot's object palette. With slot 1, whatever
; enemy the room keeps there draws with them until the room is reloaded.
; The LCD must be off.
LoadOwlGfx::
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld a, [wOwlTileOffset]
	swap a
	or HIGH(v1Tiles0)
	ld b, a
	ld c, LOW(v1Tiles0) ; v1Tiles0 tile wOwlTileOffset
	ld hl, OwlGfx
	ld a, BANK(OwlGfx)
	ldh [hCallFuncBank], a
	hcall Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	ld a, [wOwlTileOffset]
	rrca
	rrca
	rrca ; slot * 1 palettes
	add LOW(wTempPals2 palette 4)
	ld e, a
	ld d, HIGH(wTempPals2 palette 4)
	ld hl, .pal
	ld b, 1 palettes
	jp CopyHLToDE_Short

.pal
INCLUDE "gfx/pals/owl.pal"

; Owl Wario draws the owl he holds from his own frames, so a room he flies
; into has to have the owl's graphics, even if its object group has no owl
; (only the debug menu's owl gets him into such a room). They go into a slot
; the group doesn't use, if any.
; The same goes for a debug menu owl in a level resumed from a save: saving
; keeps the objects, and the room's graphics are loaded from its group again.
; Called by LoadObjectGroupData, after the group's graphics and palettes.
; Needs WRAM bank "Level Objects WRAM".
LoadOwlGfxForOwlWario:
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	jr z, .check_group
	; Is there an owl object? (Only after resuming a save: objects are
	; cleared before a room is loaded otherwise.)
	ASSERT LOW(wObj1) == 0 && NUM_OBJECTS * OBJ_STRUCT_LENGTH == $100
	ld hl, wObj1 + OBJ_ID
.loop_objs
	ld a, [hl]
	cp OWL
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID
	ld e, a
	ld d, h
	ld a, [de] ; OBJ_FLAGS
	rra
	jr c, .check_group ; OBJFLAG_ACTIVE set
.next_obj
	ld a, l
	add OBJ_STRUCT_LENGTH
	ld l, a
	jr nc, .loop_objs
	ret

.check_group
	ld hl, wObjDataPtr01
.loop
	ld a, l
	cp LOW(wObjDataPointersEnd)
	jr z, .no_owl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de] ; OBJ_ID
	cp OWL
	ret z ; the group has the owl, and so its graphics
	jr .loop

.no_owl
	call SetOwlTileOffset
	jr LoadOwlGfx
