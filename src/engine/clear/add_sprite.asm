LoadClearScreenSprite:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	add OAM_Y_OFS
	sub b
	ld [wCurSprite], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld hl, ClearScreenOAM_d4e26
	call LoadSprite
	ret

LoadClearScreenWarioSprite:
	ld a, [wSCY]
	ld b, a
	ld a, [hli]
	add OAM_Y_OFS
	sub b
	ld [wCurSprite], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld hl, GolfWarioOAM_d49cc
	call LoadSprite
	ret
