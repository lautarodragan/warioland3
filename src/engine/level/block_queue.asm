; input:
; - e = ?
SetObjectMapEntryAndSpawn:
	push_wram BANK("Level Objects WRAM")
	ld a, [wSRAMBank]
	push af
	ld a, $01
	sramswitch
	push de
	push hl
	ld c, $01
	ld a, [hld]
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank
	inc c
	sub $20
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank
	inc c
	sub $20
.got_bank
	ld l, [hl]
	ld h, a
	ld a, c
	ld [wBlockPtrBank], a
	call BlockPtrToObjectMapPtr
	ld a, [wObjectMapBank]
	sramswitch
	bit 0, b
	jr z, .set_low_nybble
	swap e
	ld a, [hl]
	and $0f
	jr .write_entry
.set_low_nybble
	ld a, [hl]
	and $f0
.write_entry
	or e
	ld [hl], a
	pop hl

	push_wram BANK("Level Objects WRAM")
	ld a, [wSRAMBank]
	push af
	ld a, $01
	sramswitch
	ld c, $01
	ld a, [hld]
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank_again
	inc c
	sub $20
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank_again
	inc c
	sub $20
.got_bank_again
	ld d, a
	ld a, [hld]
	ld e, a
	ld a, c
	sramswitch
	ld a, [de]
	or $80
	ld [de], a
	pop af
	sramswitch
	pop_wram

	ld a, c
	ld [wBlockPtrBank], a
	ld h, d
	ld l, e
	call GetBlockPtrPos
	pop de

	ld c, e
	ld d, h
	ld e, l
	farcall SpawnObject
	pop af
	sramswitch
	pop_wram
	ret

; hl = obj map ptr hi (OBJ_MAP_PTR_HI)
DespawnObject:
	push_wram BANK("Level Objects WRAM")
	ld a, [hl] ; OBJ_MAP_PTR_HI
	and a
	jr z, .no_map_entry
	ld a, [wSRAMBank]
	push af
	ld a, BANK("SRAM1")
	sramswitch
	ld c, $01
	ld a, [hld] ; OBJ_MAP_PTR_HI
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank
	inc c
	sub $20
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank
	inc c
	sub $20
.got_bank
	ld d, a
	ld a, [hld] ; OBJ_MAP_PTR_LO
	ld e, a
	xor a
	ld [hl], a
	ld a, c
	sramswitch
	ld a, [de]
	or $80
	ld [de], a
	pop af
	sramswitch
	pop_wram
	ret

.no_map_entry
; objects spawned outside the object map (from the debug menu) have no
; entry to mark as despawned; marking "$0000" would write to the MBC's
; RAM enable register and switch off SRAM, where the level's blocks live
	dec l
	dec l
	ld [hl], a ; OBJ_FLAGS
	pop_wram
	ret

ClearObjectMapEntry:
	push_wram BANK("Level Objects WRAM")
	ld a, [wSRAMBank]
	push af
	ld a, $01
	sramswitch
	ld c, $01
	ld a, [hld]
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank
	inc c
	sub $20
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_bank
	inc c
	sub $20
.got_bank
	ld l, [hl]
	ld h, a
	ld a, c
	ld [wBlockPtrBank], a
	call BlockPtrToObjectMapPtr
	ld a, [wObjectMapBank]
	sramswitch
	bit 0, b
	jr z, .clear_low_nybble
	ld a, [hl]
	and $0f
	ld [hl], a
	pop af
	sramswitch
	pop_wram
	ret

.clear_low_nybble
	ld a, [hl]
	and $f0
	ld [hl], a
	pop af
	sramswitch
	pop_wram
	ret

ProcessBlockRedrawQueue:
	ld a, [wIsDMATransferPending]
	and a
	ret nz ; exit if DMA pending

	ld b, BANK("SRAM1")
	ld a, [wBlockRedrawQueueReadIndex]
	ld e, a
	ld d, $00
	ld hl, wBlockRedrawQueue
	add hl, de
	ld a, [hli]
	and a
	ret z ; nothing to do

	ld l, [hl]
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_sram_bank
	inc b ; BANK("SRAM2")
	sub HIGH(SIZEOF(SRAM))
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr c, .got_sram_bank
	inc b ; BANK("SRAM3")
	sub HIGH(SIZEOF(SRAM))
.got_sram_bank
	ld h, a
	ld a, b
	ld [wBlockPtrBank], a
	sramswitch
	push hl
	call GetBlockPtrBGMapAddress
	ld a, [wBGMapAddressQueueSize]
	ld b, a
	ld de, wBGMapAddressQueue
	ld a, e
	add b
	ld e, a

	; each block is 2x2 tiles
	; current address points to the top-left corner tile

	; top-left tile
	ld a, h
	ld [de], a
	inc e
	ld a, l
	ld [de], a
	inc e

	; top-right tile
	ld a, h
	ld [de], a
	inc e
	ld a, l
	and $e0
	ld c, a
	ld a, l
	inc a
	and $1f
	add c
	ld [de], a
	inc e

	; bottom-left tile
	ld bc, TILEMAP_WIDTH
	add hl, bc
	ld a, h
	and $fb
	ld h, a
	ld [de], a
	inc e
	ld a, l
	ld [de], a
	inc e

	; bottom-right tile
	ld a, h
	ld [de], a
	inc e
	ld a, l
	and $e0
	ld c, a
	ld a, l
	inc a
	and $1f
	add c
	ld [de], a

	ld a, [wBGMapAddressQueueSize]
	add $2 * 4
	ld [wBGMapAddressQueueSize], a
	pop hl

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push_wram $03
	push de
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileQueueSize]
	ld e, a
	ld d, HIGH(wBGMapTileVRAM0Queue)
	ld a, LOW(wBGMapTileVRAM0Queue)
	add e
	ld e, a ; wBGMapTileVRAM0Queue + wBGMapTileQueueSize
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop de

	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileQueueSize]
	ld e, a
	ld d, HIGH(wBGMapTileVRAM1Queue)
	ld a, LOW(wBGMapTileVRAM1Queue)
	add e
	ld e, a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a

	ld a, [wBGMapTileQueueSize]
	add 4
	ld [wBGMapTileQueueSize], a

	ld a, [wBlockRedrawQueueReadIndex]
	ld e, a
	ld d, $00
	ld hl, wBlockRedrawQueue
	add hl, de
	xor a
	ld [hli], a
	ld [hl], a
	ld a, e
	add 2
	and $0f
	ld [wBlockRedrawQueueReadIndex], a
	pop_wram
	ret
