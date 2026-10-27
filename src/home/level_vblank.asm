; Level V-Blank function while a slot the debug menu's owl borrowed is given
; back (UpdateBorrowedOwlSlot): copies the next chunk of its graphics from
; wOwlSlotTilesBackup to VRAM1, with a general purpose DMA, before the level's
; own V-Blank work. When they're all back, also its palette, and sets the
; jump in wVBlankFunc back to LevelVBlankFunc.
; Each chunk takes about an eighth of V-Blank. If Wario's graphics are being
; copied (wIsDMATransferPending), they take this V-Blank, and the chunk waits.
OwlSlotRestoreVBlankFunc::
	ld a, [wOwlTileOffset]
	bit OWL_SLOT_BORROWED_F, a
	jr z, .unhook
	ld a, [wOwlSlotRestore]
	and OWL_SLOT_RESTORE_MASK
	jr z, .unhook ; a new owl took the slot over
	ld b, a ; 1 + chunk
	ld a, [wIsDMATransferPending]
	and a
	jr nz, LevelVBlankFunc

	ldh a, [rWBK]
	push af
	ld a, BANK(wOwlSlotTilesBackup)
	ldh [rWBK], a
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ASSERT LOW(wOwlSlotTilesBackup) == 0 && OWL_SLOT_CHUNK_SIZE == $100
	ld c, LOW(rVDMA_SRC_HIGH)
	ld a, b
	add HIGH(wOwlSlotTilesBackup) - 1
	ld [$ff00+c], a ; rVDMA_SRC_HIGH
	inc c
	xor a
	ld [$ff00+c], a ; rVDMA_SRC_LOW
	inc c
	ld a, [wOwlTileOffset]
	and OWL_SLOT_MASK
	swap a
	add b
	add HIGH(v1Tiles0) - 1
	ld [$ff00+c], a ; rVDMA_DEST_HIGH
	inc c
	xor a
	ld [$ff00+c], a ; rVDMA_DEST_LOW
	inc c
	ld a, OWL_SLOT_CHUNK_SIZE / 16 - 1 ; general purpose DMA
	ld [$ff00+c], a ; rVDMA_LEN
	xor a ; VRAM0
	ldh [rVBK], a

	ld a, b
	cp OWL_SLOT_NUM_CHUNKS
	jr z, .last_chunk
	ld hl, wOwlSlotRestore
	inc [hl]
	pop af
	ldh [rWBK], a
	jr LevelVBlankFunc

.last_chunk
	ld a, [wOwlTileOffset]
	and OWL_SLOT_MASK
	rrca
	rrca
	rrca ; slot * 1 palettes
	add LOW(wTempPals2 palette 4)
	ld e, a
	ASSERT HIGH(wTempPals2) == HIGH(wTempPals2 + 8 palettes - 1)
	ld d, HIGH(wTempPals2 palette 4)
	sub LOW(wTempPals2)
	or OBPI_AUTOINC
	ldh [rOBPI], a
	ld hl, wOwlSlotPalBackup
	ld c, LOW(rOBPD)
	ld b, 1 palettes
.loop_pal
	ld a, [hli]
	ld [de], a
	inc e
	ld [$ff00+c], a
	dec b
	jr nz, .loop_pal
	pop af
	ldh [rWBK], a
	xor a
	ld [wOwlTileOffset], a
	ld [wOwlSlotRestore], a
.unhook
	ld a, LOW(LevelVBlankFunc)
	ld [wVBlankFunc + 1], a
;	fallthrough

; this function is called during level V-Blank
LevelVBlankFunc::
	ld a, [wIsDMATransferPending]
	and a
	jr nz, .dma_transfer

	xor a ; SRAM0
	ld [rRAMB + $100], a

	; apply scroll X and Y, including shake effect
	ld hl, wSCYShake
	ld a, [wSCY]
	add [hl]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a

	; push OAM
	ld a, HIGH(wVirtualOAM)
	call hTransferVirtualOAM

; write tiles in wBGMapTileVRAM0Queue to the
; corresponding addresses in wBGMapAddressQueue
; this takes care of both VRAM0 and VRAM1
; since afterwards we got a jump to ProcessLevelTileQueue_VRAM1
	ld hl, wBGMapAddressQueue
	ld bc, wBGMapTileVRAM0Queue
	jp wVBlankFunc + $10

.dma_transfer
	ld hl, wPendingDMASourceBank
	ld a, [hli]
	ld [rROMB0 + $100], a
	ld c, LOW(rVDMA_SRC_HIGH)
	ld a, [hli] ; wPendingDMASourcePtr
	ld [$ff00+c], a ; rVDMA_SRC_HIGH
	inc c
	ld a, [hli]
	ld [$ff00+c], a ; rVDMA_SRC_LOW
	ld a, [hli] ; wPendingDMADestinationBank
	ldh [rVBK], a
	inc c
	ld a, [hli] ; wPendingDMADestinationPtr
	ld [$ff00+c], a ; rVDMA_DEST_HIGH
	inc c
	ld a, [hli]
	ld [$ff00+c], a ; rVDMA_DEST_LOW
	inc c
	ld a, [hl] ; wPendingDMALength
	ld [$ff00+c], a ; rVDMA_LEN

	xor a
	ld [wIsDMATransferPending], a

	; apply scroll X and Y, including shake effect
	ld hl, wSCYShake
	ld a, [wSCY]
	add [hl]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a

	; push OAM
	ld a, HIGH(wVirtualOAM)
	call hTransferVirtualOAM

	xor a
	ld [wBGMapTileQueueSize], a
	ld [wBGMapAddressQueueSize], a
	ret

; called within level VBlank
ProcessLevelTileQueue_VRAM1::
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, wBGMapAddressQueue
	ld bc, wBGMapTileVRAM1Queue
	jp wVBlankFuncExtended

ClearLevelTileQueue::
	xor a
	ld [wBGMapTileQueueSize], a
	ld [wBGMapAddressQueueSize], a
	ret
