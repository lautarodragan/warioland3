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
	ld [hli], a ; OBJ_MAP_PTR_LO
	ld [hli], a ; OBJ_MAP_PTR_HI
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
; the group doesn't use, or one it lends until the owl's gone, set in
; wOwlTileOffset (SetOwlTileOffset); the caller has to load them there
; (LoadOwlGfx).
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
; group doesn't use. If it uses all four, the owl borrows one of them
; (OWL_SLOT_BORROWED): the first no active object draws from, or slot 1.
; The slot's graphics and palette are saved when the owl's are loaded
; (LoadOwlGfx), its objects aren't spawned meanwhile
; (RefuseBorrowedSlotObjects), and it's given back once the owl's gone
; (UpdateBorrowedOwlSlot). Bosses and The Temple's hidden figure always lend
; slot 1, and keep spawning their parts.
; Groups load graphics into all four slots, and their object lists are
; positional: entry n is the object whose graphics are in slot n. A slot is
; unused when its entry is DummyObjectData or the list ends before it, and
; the group loads the slot's filler graphics there (the ones in ObjectGroup0,
; the empty group). The filler check rules out the bosses and the multi-slot
; enemies (like Sun1/Sun2), whose short lists leave entries out of slots they
; do use.
; Needs WRAM bank "Level Objects WRAM".
SetOwlTileOffset:
	ld a, [wOwlTileOffset]
	bit OWL_SLOT_BORROWED_F, a
	jr z, .find
	; Another owl has borrowed a slot already. It's still around, or the
	; slot is being given back: keep it, and give it back later.
	ld hl, wOwlSlotRestore
	ld a, [hl]
	and OWL_SLOT_RESTORE_MASK
	ret z ; still around
	xor [hl]
	ld [hl], a
	jp RefuseBorrowedSlotObjects ; again

.find
	ld a, [wObjectGroup]
	cp OBJECT_GROUP_HIDDEN_FIGURE
	jp z, .borrow_slot_1
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
	jp nz, .borrow_slot_1 ; a boss: they use all four slots
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
	ld [wOwlTileOffset], a
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

; All four slots are used. Borrow the first one no active object draws
; from now, going by the current frame of each (an object's frames normally
; keep to its slot); if there's none, slot 1.
	ld b, 0 ; slots in use, bit n for slot n + 1
	ASSERT LOW(wObj1) == 0 && NUM_OBJECTS * OBJ_STRUCT_LENGTH == $100
	ld hl, wObj1
.loop_objs
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr nc, .next_obj ; OBJFLAG_ACTIVE not set
	push hl
	ld a, l
	add OBJ_ID
	ld l, a
	ld a, [hl]
	cp OWL
	call nz, GetObjFrameSlots
	pop hl
.next_obj
	ld a, l
	add OBJ_STRUCT_LENGTH
	ld l, a
	jr nc, .loop_objs
	ld c, $00 ; slot's tile offset
.loop_slots
	rr b
	jr nc, .got_slot
	ld a, c
	add $40
	ld c, a
	jr nz, .loop_slots
.got_slot
	ld a, c ; $00 (slot 1) if all are in use
	call .borrow
	jr RefuseBorrowedSlotObjects

.borrow_slot_1
	xor a
.borrow
	or OWL_SLOT_BORROWED
	ld [wOwlTileOffset], a
	ld a, OWL_SLOT_SAVE_PENDING
	ld [wOwlSlotRestore], a
	ret

; While the owl has a slot borrowed, the room's objects that draw from it
; aren't spawned, so that none draws with the owl's tiles: their entries in
; wObjDataPtr01-13 (whose first frame draws from the slot) point to
; RefusedObjectData, which leaves them in the object map. UpdateBorrowedOwlSlot
; puts the entries back (wOwlSlotObjDataBackup) once the owl's gone; from
; then on they're spawned again as Wario comes across them.
; Objects already active keep drawing from the slot until they're gone:
; SetOwlTileOffset borrows a slot none uses, if it can.
; Needs WRAM bank "Level Objects WRAM".
RefuseBorrowedSlotObjects:
	ld hl, wObjDataPtr01
	ld de, wOwlSlotObjDataBackup
	ld b, wObjDataPointersEnd - wObjDataPtr01
	ASSERT wObjDataPointersEnd - wObjDataPtr01 == 13 * 2
	call CopyHLToDE_Short
	ld a, [wOwlTileOffset]
	and OWL_SLOT_MASK
	rlca
	rlca
	inc a
	ld b, a
	xor a
	scf
.slot_bit
	rla
	dec b
	jr nz, .slot_bit
	ld c, a ; the slot's bit, as GetOAMFrameSlots has it
	ld hl, wObjDataPtr01
.loop
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	cp HIGH(DummyObjectData)
	jr nz, .check_slots
	ld a, e
	cp LOW(DummyObjectData)
	jr z, .next
.check_slots
	push hl
	push bc
	ld a, [de] ; ID
	inc de
	inc de
	inc de
	push af
	ld a, [de] ; OAM pointer
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	pop af
	ld b, 0
	ld e, 0 ; frame 0
	call GetOAMFrameSlots
	ld a, b
	pop bc
	pop hl
	and c
	jr z, .next
	dec hl
	ld a, HIGH(RefusedObjectData)
	ld [hld], a
	ld a, LOW(RefusedObjectData)
	ld [hli], a
	inc hl
.next
	ld a, l
	cp LOW(wObjDataPointersEnd)
	jr nz, .loop
	ret

; Loads the owl's graphics into the enemy graphics slot in wOwlTileOffset
; and its palette into that slot's object palette. A slot borrowed from the
; room's enemies is saved first, to be given back.
; The LCD must be off.
LoadOwlGfx::
	ld a, [wOwlTileOffset]
	bit OWL_SLOT_BORROWED_F, a
	jr z, .load
	ld hl, wOwlSlotRestore
	bit OWL_SLOT_SAVE_PENDING_F, [hl]
	jr z, .load
	res OWL_SLOT_SAVE_PENDING_F, [hl]
	push_wram BANK(wOwlSlotTilesBackup)
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	call .GetSlot
	ld h, a
	ld l, LOW(v1Tiles0)
	ld de, wOwlSlotTilesBackup
	ld bc, $40 tiles
	call CopyHLToDE_BC
	xor a ; VRAM0
	ldh [rVBK], a
	call .GetPal
	ld h, d
	ld l, e
	ld de, wOwlSlotPalBackup
	ld b, 1 palettes
	call CopyHLToDE_Short
	pop_wram

.load
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	call .GetSlot
	ld b, a
	ld c, LOW(v1Tiles0) ; v1Tiles0 tile wOwlTileOffset
	ld hl, OwlGfx
	ld a, BANK(OwlGfx)
	ldh [hCallFuncBank], a
	hcall Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	call .GetPal
	ld hl, .pal
	ld b, 1 palettes
	jp CopyHLToDE_Short

; output: a = HIGH of the slot's first tile
.GetSlot:
	ld a, [wOwlTileOffset]
	and OWL_SLOT_MASK
	swap a
	or HIGH(v1Tiles0)
	ret

; output: de = the slot's palette in wTempPals2
.GetPal:
	ld a, [wOwlTileOffset]
	and OWL_SLOT_MASK
	rrca
	rrca
	rrca ; slot * 1 palettes
	add LOW(wTempPals2 palette 4)
	ld e, a
	ld d, HIGH(wTempPals2 palette 4)
	ret

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
	jp LoadOwlGfx
