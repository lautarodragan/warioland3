; draws Wario on screen unless he's invisible
DrawWario::
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jr nz, .invincible
; show Wario if wInvisibleFrame
; has upper 4 bits set and bit 2 unset
	ld hl, wInvisibleFrame
	inc [hl]
	ld a, [hl]
	and %11110010
	cp %11110000
	jr z, .show_wario
	ret

.invincible
; show Wario if wInvisibleFrame is 0
	ld a, [wInvisibleFrame]
	and a
	ret nz

.show_wario
	ld a, [wWarioOAMBank]
	ld [wTempBank], a
	ld a, [wROMBank]
	push af
	ld a, [wTempBank]
	bankswitch
	ld a, [wWarioOAMPtr + 0]
	ld h, a
	ld a, [wWarioOAMPtr + 1]
	ld l, a
	ld a, [wWarioScreenYPos]
	ld [wCurSpriteYCoord], a
	ld a, [wWarioScreenXPos]
	ld [wCurSpriteXCoord], a
	ld a, [wWarioFrame]
	ld [wCurSpriteFrame], a
	ld a, [wWarioAttributes]
	ld [wCurSpriteAttributes], a
	ld a, [wDebugGfxSlot]
	and a
	jr nz, .debug_gfx
	call LoadSprite
	pop af
	bankswitch
	ret

.debug_gfx
	; Owl Wario's frames draw the owl from slot 1's tiles
	ld a, [wVirtualOAMByteSize]
	push af
	call LoadSprite
	pop af
	ld l, a
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	jr nz, .done
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_KIND_MASK
	ASSERT DEBUG_GFX_OWL == 0
	call z, RelocateDebugObjSprites ; the owl's graphics are elsewhere
.done
	pop af
	bankswitch
	ret

; The objects whose graphics the debug menu can put in an enemy graphics slot
; (wDebugGfxSlot), by DEBUG_GFX_* kind: the object's ID, and the tile offset
; of the slot its OAM data draws from (its palette is that slot's: 4-7).
DebugGfxKinds::
	db OWL,     $00 ; DEBUG_GFX_OWL: slot 1, palette 4
	db BARREL2, $c0 ; DEBUG_GFX_BARREL: slot 4, palette 7
.end
	ASSERT DebugGfxKinds.end - DebugGfxKinds == NUM_DEBUG_GFX_KINDS * 2

; output:
; - a = ID of the object whose graphics are in wDebugGfxSlot
; - de = its entry in DebugGfxKinds
GetDebugGfxObjID::
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_KIND_MASK
	add LOW(DebugGfxKinds)
	ld e, a
	adc HIGH(DebugGfxKinds)
	sub e
	ld d, a
	ld a, [de]
	ret

; Moves the sprites of the object whose graphics are in wDebugGfxSlot from
; the enemy graphics slot its OAM data draws from (DebugGfxKinds: slot 1 for
; the owl, 4 for the barrel) to where its graphics are: from virtual OAM byte
; offset l to the end, VRAM1 tiles move by the difference and that slot's
; object palette becomes the slot's. Every VRAM1 sprite in that range has to
; be the object's (Wario's own sprites are in VRAM0, so Owl Wario's frames
; qualify).
RelocateDebugObjSprites::
	call GetDebugGfxObjID
	inc de
	ld a, [de]
	ld b, a ; tile offset of the object's own slot
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_SLOT_MASK
	ld c, a
	sub b
	ld d, a ; how far its tiles move
	ld a, c
	rlca
	rlca
	add 4
	ld e, a ; slot 1-4 -> palette 4-7
	ld a, b
	rlca
	rlca
	add 4
	ld b, a ; the object's own palette
	ld h, HIGH(wVirtualOAM)
	ld a, [wVirtualOAMByteSize]
	ld c, a
.loop
	ld a, l
	cp c
	ret nc
	inc l
	inc l
	inc l
	ld a, [hl] ; SPRITEOAMSTRUCT_ATTRIBUTES
	bit B_OAM_BANK1, a
	jr z, .next
	and OAM_PALETTE
	cp b
	jr nz, .tile
	ld a, [hl]
	and ~OAM_PALETTE
	or e
	ld [hl], a
.tile
	dec l
	ld a, [hl] ; SPRITEOAMSTRUCT_TILE_ID
	add d
	ld [hli], a
.next
	inc l
	jr .loop

; Whether the object whose graphics are in wDebugGfxSlot is still around
; (IsObjAround).
; Needs WRAM bank "Level Objects WRAM".
; output:
; - z if it is, nz if it's gone
IsDebugGfxObjAround::
	call GetDebugGfxObjID
;	fallthrough

; Whether an object is around: an active object with its ID, and for the
; owl also Owl Wario or the owl flying off (PARTICLE_OWL).
; Needs WRAM bank "Level Objects WRAM".
; input:
; - a = object ID
; output:
; - z if it is, nz if it's gone
IsObjAround::
	ld c, a
	cp OWL
	jr nz, .objects
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	ret z
FOR n, 0, MAX_NUM_PARTICLES
	ld a, [wParticle{u:n} + PARTICLE_STRUCT_ID]
	cp PARTICLE_OWL
	ret z
ENDR
.objects
	ASSERT LOW(wObj1) == 0 && NUM_OBJECTS * OBJ_STRUCT_LENGTH == $100
	ld hl, wObj1
.loop_objs
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr nc, .next_obj ; OBJFLAG_ACTIVE not set
	ld a, l
	add OBJ_ID
	ld e, a
	ld d, h
	ld a, [de]
	cp c
	ret z
.next_obj
	ld a, l
	add OBJ_STRUCT_LENGTH
	ld l, a
	jr nc, .loop_objs
	or 1 ; nz: gone
	ret

; Adds to b the enemy graphics slots (bit n for slot n + 1) that the
; current frame of an object draws from (its VRAM1 sprites), going through
; its OAM data like UpdateObjSprite.
; input:
; - hl = OBJ_ID of the object (WRAM bank "Level Objects WRAM")
GetObjFrameSlots::
	ld a, l
	add OBJ_FRAME - OBJ_ID
	ld e, a
	ld d, h
	ld a, [de] ; OBJ_FRAME
	add a ; *2
	ld c, a
	inc e
	ld a, [de] ; OBJ_OAM_PTR
	push af
	inc e
	ld a, [de]
	ld d, a
	ld a, [hl] ; OBJ_ID
	ld h, d
	pop de
	ld l, d
	ld e, c
;	fallthrough

; Adds to b the enemy graphics slots (bit n for slot n + 1) that a frame of
; an object's OAM data draws from.
; input:
; - a = object ID (which picks the OAM data's bank)
; - hl = OAM data
; - e = frame * 2
GetOAMFrameSlots::
	push af
	ld a, [wROMBank]
	ld c, a
	pop af
	push bc
	swap a
	and %111
	or BANK("Objects OAM 1")
	bankswitch
	ld d, $00
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ld a, c
	push af ; ROM bank
.loop
	ld a, [hli] ; y
	cp $80
	jr z, .done
	inc hl ; x
	ld a, [hli] ; tile
	ld c, a
	ld a, [hli] ; attributes
	bit B_OAM_BANK1, a
	jr z, .loop
	ld a, c
	rlca
	rlca
	and %11
	inc a
	ld c, a ; slot
	xor a
	scf
.shift
	rla
	dec c
	jr nz, .shift
	or b
	ld b, a
	jr .loop
.done
	pop af
	bankswitch
	ret

; hl = OAM data pointer
; given an OAM pointer and a frame index in wCurSpriteFrame
; goes through each tile element and adds them to virtual OAM
LoadSprite::
	ld a, [wCurSpriteFrame]
	ld d, $00
	add a
	ld e, a
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]

	ld hl, wCurSpriteXCoord
	ld a, [hld]
	ld c, a    ; wCurSpriteXCoord
	ld a, [hld]
	ld b, a    ; wCurSpriteYCoord
	ld l, [hl] ; wVirtualOAMByteSize
	ld h, HIGH(wVirtualOAM)
.loop
	ld a, l
	cp OAM_SIZE
	ret nc
	ld a, [de]
	cp $80
	ret z ; finished

	ld a, [de] ; SPRITEOAMSTRUCT_YCOORD
	add b
	ld [hli], a
	inc de
	ld a, [de] ; SPRITEOAMSTRUCT_XCOORD
	add c
	ld [hli], a
	inc de
	ld a, [de] ; SPRITEOAMSTRUCT_TILE_ID
	ld [hli], a
	inc de
	push hl
	ld hl, wCurSpriteAttributes
	ld a, [de] ; SPRITEOAMSTRUCT_ATTRIBUTES
	xor [hl]
	pop hl
	ld [hli], a
	ld a, l
	ld [wVirtualOAMByteSize], a
	inc de
	jr .loop

QueueBlockRedraw_IfObjOnScreen::
	ld a, [wCurObjFlags]
	bit OBJFLAG_ON_SCREEN_F, a
	ret z
;	fallthrough

QueueBlockRedraw::
	ld a, [wBlockPtrBank]
	dec a
	add a
	add a
	add a
	add a
	add a
	add h ; = h + (wBlockPtrBank - 1) * $20
	ld b, a
	ld c, l
	ld hl, wBlockRedrawQueue
	ld a, [wBlockRedrawQueueWriteIndex]
	ld e, a
	ld d, $00
	add hl, de
	ld a, b
	ld [hli], a
	ld [hl], c
	ld a, e
	add 2
	and $0f
	ld [wBlockRedrawQueueWriteIndex], a
	ret

UpdateWarioAnimation::
	ld a, [wWarioFramesetPtr + 0]
	ld d, a
	ld a, [wWarioFramesetPtr + 1]
	ld e, a

	xor a ; FALSE
	ld [wWarioAnimationEnded], a
	ld hl, wFrameDuration
	ld a, [hl]
	sub 1
	ld [hli], a
	ret nc ; return if duration hasn't elapsed yet

	ld a, [hl] ; wAnimationFrame
	add e
	ld c, a
	ld a, d
	adc 0
	ld b, a
	ld a, [bc]
	cp $ff
	jr z, .finished

; next frame
	ld [wWarioFrame], a
	ld a, [hl] ; wAnimationFrame
	add 2
	ld [hld], a
	inc bc
	ld a, [bc]
	ld [hl], a ; wFrameDuration
	ret

.finished
	xor a
	ld [hld], a ; wAnimationFrame
	ld [hl], a ; wFrameDuration
	ld a, TRUE
	ld [wWarioAnimationEnded], a
	ret
