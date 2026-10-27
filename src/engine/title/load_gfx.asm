LoadTitleScreenPals:
	ld a, [wRestoredSave]
	and a
	jr nz, .asm_492a
	ld hl, TitleScreenBGPals
	call LoadPalsToTempPals1
	ld hl, TitleScreenOBPals
	call LoadPalsToTempPals2
	ret

.asm_492a
	ld hl, TitleScreenBGPals2
	call LoadPalsToTempPals1
	ld hl, TitleScreenOBPals2
	call LoadPalsToTempPals2
	ret

LoadTitleScreenTiles:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, PlaneGfx
	ld bc, v1Tiles0
	call Decompress

	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, TitleScreenGfx
	ld bc, v0Tiles0
	call Decompress
	ret

LoadTitleScreenTileMap:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, TitleScreenAttrmap
	ld bc, v1BGMap0
	call Decompress

	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, TitleScreenTilemap
	ld bc, v0BGMap0
	call Decompress
	ret

LoadTimeAttackDescriptionPals:
	ld hl, TimeAttackDescriptionBGPals
	call LoadPalsToTempPals1
	ret

LoadTimeAttackDescriptionTiles:
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	farcall LoadFontTiles

	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, PrologueBackgroundGfx
	ld de, v0Tiles2
	ld bc, $80 tiles
	ld a, BANK(PrologueBackgroundGfx)
	ldh [hCallFuncBank], a
	hcall CopyHLToDE_BC
	ret

LoadTimeAttackText:
	ld a, [wLanguage]
	and a
	jr nz, .english

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, TimeAttack2JPTextMap
	ld bc, v1BGMap0
	call Decompress

	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, TimeAttack1JPTextMap
	ld bc, v0BGMap0
	call Decompress
	ret

.english
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, TimeAttack2ENTextMap
	ld bc, v1BGMap0
	call Decompress

	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, TimeAttack1ENTextMap
	ld bc, v0BGMap0
	call Decompress
	ret
