VBlank_Overworld:
	ld hl, .Func
	ld de, wVBlankFunc
	ld b, .end - .Func
	call CopyHLToDE
	ret

.Func:
	ld a, BANK("WRAM2")
	ldh [rWBK], a
	ld a, [wSCY]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a
	ld a, [wWY]
	ldh [rWY], a
	ld a, [wWX]
	add WX_OFS
	ldh [rWX], a

	ld b, BANK(CopyCommonOWAnimTilesToVRAM)
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	call CopyCommonOWAnimTilesToVRAM
	pop af
	bankswitch

	ld hl, wPalConfig1
	ld a, [hl]
	and a
	jr z, .hdma
	ld c, a
	xor a
	ld [hli], a
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
.loop_pals
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	dec b
	jr nz, .loop_pals

.hdma
	ld a, [wHDMABank]
	ld b, a
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	ld hl, wHDMA
	ld a, [hl]
	and a
	jr z, .hdma_vram1
	ld b, [hl]
	xor a
	ld [hli], a
	ld a, b
	ld c, LOW(rVDMA_SRC_HIGH)
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a

.hdma_vram1
	ld hl, wHDMAVRAM1
	ld a, [hl]
	and a
	jr z, .done
	ld b, a
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	xor a
	ld [hli], a
	ld a, b
	ld c, LOW(rVDMA_SRC_HIGH)
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
	ld a, [hli]
	inc c
	ld [$ff00+c], a
.done
	pop af
	bankswitch
	xor a
	ldh [rVBK], a

	ld a, HIGH(wVirtualOAM)
	jp hTransferVirtualOAM
.end

VBlank_OWScene:
	ld hl, .Func
	ld de, wVBlankFunc
	ld b, .end - .Func
	call CopyHLToDE
	ret

.Func:
	ld a, $02
	ldh [rWBK], a
	ld a, [wSCY]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a

	ld a, [wOWPendingTileUpdate]
	and a
	jr z, .skip_update_tiles
	ld c, LOW(rVDMA_SRC_HIGH)
	ld a, HIGH(wTilemap)
	ld [$ff00+c], a ; rVDMA_SRC_HIGH
	inc c
	xor a ; LOW(wTilemap)
	ld [$ff00+c], a ; rVDMA_SRC_LOW
	inc c
	ld a, HIGH(v0BGMap0) - $80
	ld [$ff00+c], a ; rVDMA_DEST_HIGH
	inc c
	xor a ; LOW(v0BGMap0)
	ld [$ff00+c], a
	inc c
	ld a, 15 dma_rows
	ld [$ff00+c], a

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld c, LOW(rVDMA_SRC_HIGH)
	ld a, HIGH(wAttrmap)
	ld [$ff00+c], a ; rVDMA_SRC_HIGH
	inc c
	xor a ; LOW(wAttrmap)
	ld [$ff00+c], a ; rVDMA_SRC_LOW
	inc c
	ld a, HIGH(v1BGMap0) - $80
	ld [$ff00+c], a ; rVDMA_DEST_HIGH
	inc c
	xor a ; LOW(v1BGMap0)
	ld [$ff00+c], a
	inc c
	ld a, 15 dma_rows
	ld [$ff00+c], a
	xor a
	ld [wOWPendingTileUpdate], a

.skip_update_tiles
	ld a, [wHDMABank]
	and a
	jr z, .no_hdma
	ld b, a
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	call StartOWHDMA
	pop af
	bankswitch

.no_hdma
	xor a
	ldh [rVBK], a
	ld b, BANK(CopyCommonOWAnimTilesToVRAM)
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	call CopyCommonOWAnimTilesToVRAM
	pop af
	bankswitch

	ld b, BANK(ApplyPalConfig1)
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	ld a, [wPalConfig1Register]
	and a
	call nz, ApplyPalConfig1
	ld a, [wPalConfig2]
	and a
	call nz, ApplyPalConfig2
	pop af
	bankswitch

	ld a, HIGH(wVirtualOAM)
	jp hTransferVirtualOAM
.end
