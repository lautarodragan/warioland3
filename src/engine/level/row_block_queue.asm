; queues up all the tiles related to the
; row in wBlockYPos in wBGMapTileVRAM0Queue
; input:
; - hl = SRAM pointer to start of row
QueueBlockTilesAlongRow_OddColumn:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM0Queue)
	ld [wBGMapTileVRAM0QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM0Queue)
	add b
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [wBlockYPos + 1]
	and $08
	jr nz, .odd_row
	ld b, $10
.loop
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank
	dec b
	jr nz, .loop
	ret

.odd_row
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .first_done
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.first_done
	ld b, $10
.loop_odd
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank_odd
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank_odd
	dec b
	jr nz, .loop_odd
	ret

; queues up all the attributes related to the
; row in wBlockYPos in wBGMapTileVRAM1Queue
; input:
; - hl = SRAM pointer to start of row
QueueBlockAttributesAlongRow_OddColumn:
	push_wram BANK("GFX RAM")
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM1Queue)
	ld [wBGMapTileVRAM1QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM1Queue)
	add b
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row
	ld b, $10
.loop
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank
	dec b
	jr nz, .loop
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

.odd_row
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wBGMapTileVRAM1Queue
	add hl, de
	inc l
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl

	inc h
	ld a, h
	cp $c0
	jr nz, .first_done
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.first_done
	ld b, $10
.loop_odd
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank_odd
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank_odd
	dec b
	jr nz, .loop_odd
	pop_wram
	ret

; queues up all the tiles related to the
; row in wBlockYPos in wBGMapTileVRAM0Queue
; input:
; - hl = SRAM pointer to start of row
QueueBlockTilesAlongRow_EvenColumn:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM0Queue)
	ld [wBGMapTileVRAM0QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM0Queue)
	add b
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row
	ld b, $10
.loop
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank
	dec b
	jr nz, .loop
	ret

.odd_row
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .first_done
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.first_done
	ld b, $10
.loop_odd
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank_odd
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank_odd
	dec b
	jr nz, .loop_odd
	ret

; queues up all the attributes related to the
; row in wBlockYPos in wBGMapTileVRAM1Queue
; input:
; - hl = SRAM pointer to start of row
QueueBlockAttributesAlongRow_EvenColumn:
	push_wram BANK("GFX RAM")
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM1Queue)
	ld [wBGMapTileVRAM1QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM1Queue)
	add b
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row
	ld b, $10
.loop
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank
	dec b
	jr nz, .loop
	pop_wram
	ret

.odd_row
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .first_done
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.first_done
	ld b, $10
.loop_odd
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp $c0
	jr nz, .same_bank_odd
	ld h, $a0
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank_odd
	dec b
	jr nz, .loop_odd
	pop_wram
	ret
