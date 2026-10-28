; hl = source
; wGolfHDMADest = destination
; wGolfHDMALength = length - 1
StartGolfHDMA::
	ld a, h
	ldh [rVDMA_SRC_HIGH], a
	ld a, l
	ldh [rVDMA_SRC_LOW], a
	ld a, [wGolfHDMADest + 0]
	ldh [rVDMA_DEST_HIGH], a
	ld a, [wGolfHDMADest + 1]
	ldh [rVDMA_DEST_LOW], a
	ld a, [wGolfHDMALength]
	ldh [rVDMA_LEN], a
	ret

SetGolfBGPals::
	ld de, rBGPI
	ld c, 4
	jr .asm_2c52

	ld de, rOBPI
	ld c, 4

.asm_2c52
	ld a, $80
	ld [de], a
	inc e
.loop
REPT $10
	ld a, [hli]
	ld [de], a
ENDR
	dec c
	jr nz, .loop
	ret

; hl = golf object duration
; de = frameset
; outputs in c whether animation finished
UpdateGolfObjectAnimation::
	ld c, $00
	ld a, [hl] ; duration
	sub $1
	ld [hli], a
	ret nc ; not finished yet
	ld a, [hli] ; frameset offset
	add e
	ld c, a
	ld a, d
	adc $00
	ld b, a
	ld a, [bc]
	cp $ff
	jr z, .finished_animation
	inc bc
	ld [hld], a ; frame
	ld a, [hl]
	add $2
	ld [hld], a
	ld a, [bc]
	ld [hl], a ; duration
	ld c, FALSE
	ret

.finished_animation
	ld a, [hl] ; last frame
	ld [wGolfAnimLastFrame], a
	ld a, [de]
	ld [hld], a ; frame
	inc de
	ld a, $2
	ld [hld], a
	ld a, [de]
	ld [hl], a
	ld c, TRUE
	ret

; hl = golf object sprite
; wGolfOAMPtr = oam pointer
LoadGolfSprite::
	ld a, [hli]
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld a, [wGolfOAMPtr + 0]
	ld h, a
	ld a, [wGolfOAMPtr + 1]
	ld l, a
	call LoadSprite
	ret

; updates Golf Wario sprite, given its state
; and which direction it is facing
UpdateGolfWarioAnimation::
	ld hl, .OAMBanks
	ld a, [wGolfWarioState]
	ld b, $00
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wTempBank], a

	ld a, [wGolfWarioDir]
	and a
	jr z, .dir_right
; dir left
	ld a, c
	add NUM_GOLF_WARIO_STATES
	ld c, a
.dir_right
	ld hl, .OAMTable
	ld b, $00
	sla c
	add hl, bc
	ld a, [hli]
	ld [wGolfOAMPtr + 1], a
	ld a, [hl]
	ld [wGolfOAMPtr + 0], a

	ld hl, .Framesets
	add hl, bc
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld a, [wROMBank]
	push af
	ld a, [wTempBank]
	bankswitch
	ld hl, wGolfWarioDuration
	call UpdateGolfObjectAnimation
	ld a, c
	ld [wHasGolfWarioAnimationFinished], a
	pop af
	bankswitch

	ld a, [wHasGolfWarioAnimationFinished]
	and a
	call nz, HoldGolfWarioLastFrame
	ld a, [wGolfWarioCurrentFrame]
	ld [wGolfWarioFrame], a
	ld a, [wROMBank]
	push af
	ld a, [wTempBank]
	bankswitch
	ld hl, wGolfWarioSprite
	call LoadGolfSprite
	pop af
	bankswitch
	ret

.OAMBanks:
	db BANK(OAM_14000)
	db BANK(WarioWalkOAM_1426c)
	db BANK(WarioOAM_14d1b)
	db BANK(WarioOAM_14d1b)
	db BANK(WarioOAM_14d1b)
	db BANK(GolfWarioOAM_1cb0dd)
	db BANK(GolfWarioOAM_d49cc)
	db BANK(GolfWarioOAM_d49cc)
	db BANK(GolfWarioOAM_d49cc)
	db BANK(GolfWarioOAM_d49cc)
	db BANK(WarioOAM_14a82)
	db BANK(WarioGetTreasureOAM_1fc31b)

.OAMTable:
	; facing right
	dw OAM_14000
	dw WarioWalkOAM_1426c
	dw WarioOAM_14d1b
	dw WarioOAM_14d1b
	dw WarioOAM_14d1b
	dw GolfWarioOAM_1cb0dd
	dw GolfWarioOAM_d49cc
	dw GolfWarioOAM_d49cc
	dw GolfWarioOAM_d49cc
	dw GolfWarioOAM_d49cc
	dw WarioOAM_14a82
	dw WarioGetTreasureOAM_1fc31b

	; facing left
	dw OAM_14000
	dw WarioWalkOAM_1426c
	dw WarioOAM_14d1b
	dw WarioOAM_14d1b
	dw WarioOAM_14d1b
	dw GolfWarioOAM_1cb0dd
	dw GolfWarioOAM_d49cc
	dw GolfWarioOAM_d49cc
	dw GolfWarioOAM_d49cc
	dw GolfWarioOAM_d49cc
	dw WarioOAM_14a82
	dw WarioGetTreasureOAM_1fc31b

.Framesets:
	; facing right
	dw WarioFrameset_1425f
	dw WarioFrameset_149c5
	dw WarioFrameset_151fd
	dw GolfWarioFrameset_2da4
	dw GolfWarioFrameset_2da7
	dw GolfWarioFrameset_1cb285
	dw GolfWarioFrameset_d4d1b
	dw GolfWarioFrameset_d4d5f
	dw GolfWarioFrameset_2db0
	dw GolfWarioFrameset_2db5
	dw WarioFrameset_14cf6
	dw WarioFrameset_1fc47c

	; facing left
	dw WarioFrameset_14252
	dw WarioWalkFrameset_149b4
	dw WarioFrameset_151e4
	dw GolfWarioFrameset_2daa
	dw GolfWarioFrameset_2dad
	dw GolfWarioFrameset_1cb2ac
	dw GolfWarioFrameset_d4d1b
	dw GolfWarioFrameset_d4d5f
	dw GolfWarioFrameset_2db0
	dw GolfWarioFrameset_2db5
	dw WarioFrameset_14cf6
	dw WarioFrameset_1fc473

GolfWarioFrameset_2da4:
	db   8,  1
	db $ff

GolfWarioFrameset_2da7:
	db   9, 15
	db $ff

GolfWarioFrameset_2daa:
	db   0,  1
	db $ff

GolfWarioFrameset_2dad:
	db   1, 15
	db $ff

GolfWarioFrameset_2db0:
	db   0, 15
	db   1, 15
	db $ff

GolfWarioFrameset_2db5:
	db   9,  8
	db $ff
