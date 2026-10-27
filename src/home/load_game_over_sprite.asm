LoadGameOverSprite::
	ld a, [hli]
	add OAM_Y_OFS
	ld [wCurSpriteYCoord], a
	ld a, [hli]
	add OAM_X_OFS
	ld [wCurSpriteXCoord], a
	ld a, [hli]
	ld [wCurSpriteFrame], a
	ld a, [hl]
	ld [wCurSpriteAttributes], a
	ld a, [wROMBank]
	push af
	ld a, BANK(SceneWarioOAM_aab5c)
	bankswitch
	ld hl, SceneWarioOAM_aab5c
	call LoadSprite
	pop af
	bankswitch
	ret
