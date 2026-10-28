SaveBackupVRAM::
	push_wram BANK("GFX RAM")
	ld a, [wSCY]
	ld [wBackupSCY], a
	ld a, [wSCX]
	ld [wBackupSCX], a
	ld hl, wTempPals1
	ld de, wBackupPals
	ld b, 16 palettes
	call CopyHLToDE
	pop_wram

	xor a ; VRAM0
	ldh [rVBK], a
	push_wram BANK("WRAM4")
	ld hl, v0Tiles0
	ld de, wBackupV0Tiles0
	ld bc, v0Tiles2 - v0Tiles0
	call CopyHLToDE_BC
	pop_wram

	push_wram BANK("WRAM5")
	ld hl, v0Tiles2
	ld de, wBackupV0Tiles2
	ld bc, v0End - v0Tiles2
	call CopyHLToDE_BC
	pop_wram

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	push_wram BANK("WRAM6")
	ld hl, v1Tiles0
	ld de, wBackupV1Tiles0
	ld bc, v1Tiles2 - v1Tiles0
	call CopyHLToDE_BC
	pop_wram

	push_wram BANK("WRAM7")
	ld hl, v1Tiles2
	ld de, wBackupV1Tiles2
	ld bc, v1End - v1Tiles2
	call CopyHLToDE_BC
	pop_wram

	xor a ; VRAM0
	ldh [rVBK], a
	ret

LoadBackupVRAM::
	push_wram $03
	ld a, [wBackupSCY]
	ld [wSCY], a
	ld a, [wBackupSCX]
	ld [wSCX], a
	ld hl, wBackupPals
	ld de, wTempPals1
	ld b, 16 palettes
	call CopyHLToDE
	pop_wram
	xor a
	ldh [rVBK], a

	push_wram BANK("WRAM4")
	ld hl, wBackupV0Tiles0
	ld de, v0Tiles0
	ld bc, $1000
	call CopyHLToDE_BC
	pop_wram

	push_wram BANK("WRAM5")
	ld hl, wBackupV0Tiles2
	ld de, v0Tiles2
	ld bc, $1000
	call CopyHLToDE_BC
	pop_wram

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	push_wram BANK("WRAM6")
	ld hl, wBackupV1Tiles0
	ld de, v1Tiles0
	ld bc, $1000
	call CopyHLToDE_BC
	pop_wram

	push_wram BANK("WRAM7")
	ld hl, wBackupV1Tiles2
	ld de, v1Tiles2
	ld bc, $1000
	call CopyHLToDE_BC
	pop_wram
	xor a
	ldh [rVBK], a
	ret
