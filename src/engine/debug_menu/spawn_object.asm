; Debug menu helper, kept in the Object Loading bank next to SpawnObject and
; the object data it reads.

DEF DEBUG_SPAWN_X_OFFSET EQU 24 ; pixels to Wario's right

; Spawns the object whose data is at bc (e.g. OwlData) next to Wario, if the
; current room's object group has it (so its OAM, palette and graphics slot
; are the ones the room loaded). Does nothing if the group doesn't have it,
; or if every object slot is taken.
; It looks the object up by its data pointer, not its ID: IDs aren't unique
; (OWL and FALLING_SNOW_SPAWNER are both $29).
; The object has no object map entry: it vanishes when it goes offscreen
; or the room is left, instead of being written back into the map.
; Needs WRAM bank "Level Objects WRAM".
; input:
; - bc = the object's data (in the object data bank)
; output:
; - b = TRUE if spawned, FALSE otherwise
_DebugSpawnObject::
	ld hl, wObjDataPtr01
	ASSERT HIGH(wObjDataPtr01) == HIGH(wObjDataPointersEnd)
.find_data
	ld a, l
	cp LOW(wObjDataPointersEnd)
	jr z, .not_found
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	cp b
	jr nz, .find_data
	ld a, e
	cp c
	jr nz, .find_data
	ld b, FALSE
.got_data
	ld h, HIGH(wObj1)
FOR n, 1, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n})
	ld a, [hli]
	rra
	jr nc, .got_obj ; OBJFLAG_ACTIVE not set
ENDR
	ret

.not_found
	ld b, FALSE
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

; Spawns an object the debug menu can put anywhere (DEBUG_GFX_* kinds: the
; owl, the barrel) next to Wario. If the room's object group has it, it's
; spawned from the group's data (_DebugSpawnObject, looked up by its data
; pointer: object IDs aren't unique). Otherwise from its ROM data, and if
; the group loads its graphics anyway, in the slot its OAM data draws from
; (the barrel's, with Barrel1Data), they're used as they are. Otherwise its
; graphics go into an enemy graphics slot the group doesn't use, or one it
; lends until the object's gone, set in wDebugGfxSlot (SetDebugGfxSlot); the
; caller has to load them there (LoadDebugObjGfx).
; Only one kind's graphics can be elsewhere at a time: while another kind's
; object is still around (IsDebugGfxObjAround), this one isn't spawned. (The
; owl in slot 1, its own slot, isn't elsewhere: SetDebugGfxSlot keeps slot 1
; for it.)
; Needs WRAM bank "Level Objects WRAM".
; input:
; - e = DEBUG_GFX_* kind
; output:
; - b = TRUE if spawned, FALSE otherwise (no free object slot, or another
;   kind's graphics are elsewhere)
; - c = TRUE if its graphics have to be loaded
_DebugSpawnObjectOfKind::
	sla e ; kind * 2, as in wDebugGfxSlot (DEBUG_GFX_KIND_MASK)
	call GetDebugGfxKindData
	ld a, [hli]
	ld c, a
	ld b, [hl] ; object data
	push de
	call _DebugSpawnObject
	pop de
	ld c, FALSE
	ld a, b
	and a
	ret nz ; the group has it
	push de
	call IsDebugGfxKindNative
	pop de
	jr nc, .elsewhere
	call .spawn
	ld c, FALSE
	ret

.elsewhere
	ld a, [wDebugGfxSlot]
	and a
	jr z, .spawn_elsewhere
	and DEBUG_GFX_KIND_MASK
	cp e
	jr z, .spawn_elsewhere
	push de
	call IsDebugGfxObjAround
	pop de
	ld bc, FALSE << 8 | FALSE
	ret z ; another kind's object has the slot
.spawn_elsewhere
	push de
	call .spawn
	pop de
	ld a, b
	and a
	ld c, a
	ret z
	call SetDebugGfxSlot
	ld bc, TRUE << 8 | TRUE
	ret

; input: e = kind * 2
.spawn
	call GetDebugGfxKindData
	ld a, [hli]
	ld e, a
	ld d, [hl] ; object data
	ld b, FALSE
	jp _DebugSpawnObject.got_data

; input:
; - e = kind * 2
; output:
; - hl = its entry in DebugGfxKindData
GetDebugGfxKindData:
	ld a, e
	add a
	add a ; * DEBUG_GFX_KIND_DATA_LENGTH
	add LOW(DebugGfxKindData)
	ld l, a
	adc HIGH(DebugGfxKindData)
	sub l
	ld h, a
	ret

; By DEBUG_GFX_* kind, like DebugGfxKinds (home bank)
DebugGfxKindData:
	; object data, graphics, their bank, palette, padding
	dw OwlData
	dw OwlGfx
	db BANK(OwlGfx)
	dw .owl_pal
	db 0
DEF DEBUG_GFX_KIND_DATA_LENGTH EQU @ - DebugGfxKindData
	ASSERT DEBUG_GFX_KIND_DATA_LENGTH == 8

	dw Barrel2Data
	dw BarrelGfx
	db BANK(BarrelGfx)
	dw .barrel_pal
	db 0
	ASSERT @ - DebugGfxKindData == NUM_DEBUG_GFX_KINDS * DEBUG_GFX_KIND_DATA_LENGTH

.owl_pal
INCLUDE "gfx/pals/owl.pal"
.barrel_pal
INCLUDE "gfx/pals/barrel.pal"

; Whether the room's object group loads a kind's graphics into the slot its
; OAM data draws from (and the debug menu hasn't borrowed that slot).
; input:
; - e = kind * 2
; output:
; - carry if it does
IsDebugGfxKindNative:
	call GetDebugGfxKindData
	inc hl
	inc hl
	ld a, [hli]
	ld c, a
	ld b, [hl] ; its graphics
	push de
	call GetDebugGfxKindEntry
	inc de
	ld a, [de]
	pop de
	ld d, a ; tile offset of its slot
	ld a, [wDebugGfxSlot]
	bit DEBUG_GFX_BORROWED_F, a
	jr z, .not_borrowed
	and DEBUG_GFX_SLOT_MASK
	cp d
	ret z ; no carry: borrowed
.not_borrowed
	push de
	call GetObjectGroupLists
	pop de
	ccf
	ret nc ; a boss
	ld a, d
	swap a
	rrca ; slot * 2
	add l
	ld l, a
	adc h
	sub l
	ld h, a
	ld a, [hli]
	cp c
	jr nz, .no
	ld a, [hl]
	cp b
	jr nz, .no
	scf
	ret
.no
	and a
	ret

; output:
; - hl = the room's object group's graphics list (4 pointers), followed by
;   its object list
; - carry if it's a boss's group or The Temple's hidden figure (no lists
;   to go by)
GetObjectGroupLists:
	ld a, [wObjectGroup]
	cp OBJECT_GROUP_HIDDEN_FIGURE
	jr z, .boss
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
	ret z
.boss
	scf
	ret

; Sets wDebugGfxSlot to the first enemy graphics slot the room's object
; group doesn't use, for a kind of object. If it uses all four, the object
; borrows one of them (DEBUG_GFX_BORROWED): the first no active object draws
; from, or slot 1. The slot's graphics and palette are saved when the
; object's are loaded (LoadDebugObjGfx), its objects aren't spawned meanwhile
; (RefuseBorrowedSlotObjects), and it's given back once the object's gone
; (UpdateBorrowedDebugGfxSlot). Bosses and The Temple's hidden figure always
; lend slot 1, and keep spawning their parts.
; Groups load graphics into all four slots, and their object lists are
; positional: entry n is the object whose graphics are in slot n. A slot is
; unused when its entry is DummyObjectData or the list ends before it, and
; the group loads the slot's filler graphics there (the ones in ObjectGroup_Empty,
; the empty group). The filler check rules out the bosses and the multi-slot
; enemies (like Sun1/Sun2), whose short lists leave entries out of slots they
; do use.
; An owl in slot 1, the one its OAM data draws from, is wDebugGfxSlot 0, as
; when nothing's elsewhere: while an owl is around, another kind keeps off
; slot 1.
; Needs WRAM bank "Level Objects WRAM".
; input:
; - e = kind * 2
SetDebugGfxSlot:
	ld a, [wDebugGfxSlot]
	bit DEBUG_GFX_BORROWED_F, a
	jr z, .find
	; A slot is borrowed already. Its object is still around (the same kind),
	; or the slot is being given back: keep it, and give it back later.
	and ~DEBUG_GFX_KIND_MASK
	or e
	ld [wDebugGfxSlot], a
	ld hl, wDebugGfxSlotRestore
	ld a, [hl]
	and DEBUG_GFX_RESTORE_MASK
	ret z ; still around
	xor [hl]
	ld [hl], a
	jp RefuseBorrowedSlotObjects ; again

.find
	ld a, e
	ld [wDebugGfxSlot], a ; the kind; its slot is ORed in
	; slots kept for the owl (bit n for slot n + 1)
	ASSERT DEBUG_GFX_OWL == 0
	and a
	jr z, .got_kept_slots ; a = 0
	ld e, DEBUG_GFX_OWL * 2
	call GetDebugGfxKindEntry
	call IsKindAround
	ld a, 0
	jr nz, .got_kept_slots
	inc a ; slot 1
.got_kept_slots
	ldh [hTemp], a

	call GetObjectGroupLists
	jp c, .borrow_slot_1 ; a boss: they use all four slots
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
	ld a, c
	and a
	jr nz, .check_filler
	ldh a, [hTemp]
	and a
	jr nz, .next ; slot 1 is kept for the owl
.check_filler
	push hl
	ld a, c
	swap a
	rrca ; slot * 2
	add LOW(ObjectGroup_Empty + 1)
	ld l, a
	adc HIGH(ObjectGroup_Empty + 1)
	sub l
	ld h, a ; slot's filler graphics in ObjectGroup_Empty
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
	ld hl, wDebugGfxSlot
	ld a, c
	or [hl]
	ld [hl], a
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
; keep to its slot), and not one kept for the owl; if there's none, the
; first one not kept.
	ldh a, [hTemp]
	ld b, a ; slots in use, bit n for slot n + 1
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
	; not the new object itself: its frames draw from the slot its graphics
	; aren't in
	call IsDebugGfxObj
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
	; all are in use: slot 1, or 2 if slot 1 is kept
	ldh a, [hTemp]
	and a
	jr z, .got_slot
	ld c, $40
.got_slot
	ld a, c
	call .borrow
	jr RefuseBorrowedSlotObjects

.borrow_slot_1
	xor a
.borrow
	or DEBUG_GFX_BORROWED
	ld hl, wDebugGfxSlot
	or [hl]
	ld [hl], a
	ld a, DEBUG_GFX_SAVE_PENDING
	ld [wDebugGfxSlotRestore], a
	ret

; While the owl has a slot borrowed, the room's objects that draw from it
; aren't spawned, so that none draws with the owl's tiles: their entries in
; wObjDataPtr01-13 (whose first frame draws from the slot) point to
; RefusedObjectData, which leaves them in the object map. UpdateBorrowedDebugGfxSlot
; puts the entries back (wDebugGfxSlotObjDataBackup) once the owl's gone; from
; then on they're spawned again as Wario comes across them.
; Objects already active keep drawing from the slot until they're gone:
; SetDebugGfxSlot borrows a slot none uses, if it can.
; Needs WRAM bank "Level Objects WRAM".
RefuseBorrowedSlotObjects:
	ld hl, wObjDataPtr01
	ld de, wDebugGfxSlotObjDataBackup
	ld b, wObjDataPointersEnd - wObjDataPtr01
	ASSERT wObjDataPointersEnd - wObjDataPtr01 == 13 * 2
	call CopyHLToDE_Short
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_SLOT_MASK
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

; Loads the graphics of the object in wDebugGfxSlot into the enemy graphics
; slot there, and its palette into that slot's object palette. A slot
; borrowed from the room's enemies is saved first, to be given back.
; The LCD must be off.
LoadDebugObjGfx::
	ld a, [wDebugGfxSlot]
	bit DEBUG_GFX_BORROWED_F, a
	jr z, .load
	ld hl, wDebugGfxSlotRestore
	bit DEBUG_GFX_SAVE_PENDING_F, [hl]
	jr z, .load
	res DEBUG_GFX_SAVE_PENDING_F, [hl]
	push_wram BANK(wDebugGfxSlotTilesBackup)
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	call .GetSlot
	ld h, a
	ld l, LOW(v1Tiles0)
	ld de, wDebugGfxSlotTilesBackup
	ld bc, $40 tiles
	call CopyHLToDE_BC
	xor a ; VRAM0
	ldh [rVBK], a
	call .GetPal
	ld h, d
	ld l, e
	ld de, wDebugGfxSlotPalBackup
	ld b, 1 palettes
	call CopyHLToDE_Short
	pop_wram

.load
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_KIND_MASK
	ld e, a
	call GetDebugGfxKindData
	inc hl
	inc hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a ; graphics
	ld a, [hli]
	ldh [hCallFuncBank], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl ; palette
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	call .GetSlot
	ld b, a
	ld c, LOW(v1Tiles0) ; the slot's first tile
	ld h, d
	ld l, e
	hcall Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	call .GetPal
	pop hl
	ld b, 1 palettes
	jp CopyHLToDE_Short

; output: a = HIGH of the slot's first tile
.GetSlot:
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_SLOT_MASK
	swap a
	or HIGH(v1Tiles0)
	ret

; output: de = the slot's palette in wTempPals2
.GetPal:
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_SLOT_MASK
	rrca
	rrca
	rrca ; slot * 1 palettes
	add LOW(wTempPals2 palette 4)
	ld e, a
	ld d, HIGH(wTempPals2 palette 4)
	ret

; Owl Wario draws the owl he holds from his own frames, so a room he flies
; into has to have the owl's graphics, even if its object group has no owl
; (only the debug menu's owl gets him into such a room). They go into a slot
; the group doesn't use, if any.
; The same goes for a debug menu owl or barrel in a level resumed from a
; save: saving keeps the objects, and the room's graphics are loaded from its
; group again. The owl's first, so that an owl and a barrel get the slots they
; had (the owl slot 1, then the barrel another one).
; Called by LoadObjectGroupData, after the group's graphics and palettes.
; Without Owl Wario or active objects (every room load but a CONTINUE's:
; objects are cleared before the others), this takes as many cycles as the
; owl-only version did: it runs with the LCD off, and would move the frame
; timing against DIV, which enemies use for randomness.
; Needs WRAM bank "Level Objects WRAM".
LoadDebugObjGfxForRoom:
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	jr z, .found
	; Are there active objects? (Only after resuming a save.)
	ASSERT LOW(wObj1) == 0 && NUM_OBJECTS * OBJ_STRUCT_LENGTH == $100
	ld hl, wObj1
.loop_objs
	ld a, [hl] ; OBJ_FLAGS
	rra
	nop
	nop ; 14 cycles a round, like the owl-only version's loop
	jr c, .found
	ld a, l
	add OBJ_STRUCT_LENGTH
	ld l, a
	jr nc, .loop_objs
	ret

.found
	ld e, 0 ; kind * 2
.loop_kinds
	push de
	call .LoadKind
	pop de
	inc e
	inc e
	ld a, e
	cp NUM_DEBUG_GFX_KINDS * 2
	jr nz, .loop_kinds
	ret

; Loads a kind's graphics if one of its objects is around and the group
; doesn't have them, unless another kind's are elsewhere already.
; input:
; - e = kind * 2
.LoadKind:
	push de
	call GetDebugGfxKindEntry
	call IsKindAround
	pop de
	ret nz
	ld a, [wDebugGfxSlot]
	and a
	jr z, .check_group
	and DEBUG_GFX_KIND_MASK
	cp e
	ret nz
.check_group
	push de
	call IsDebugGfxKindNative
	pop de
	ret c ; the group has its graphics
	call SetDebugGfxSlot
	jp LoadDebugObjGfx
