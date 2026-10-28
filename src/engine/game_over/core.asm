InitGameOverScreen:
	call DisableLCD
	call FillBGMap0_With7f
	call ClearVirtualOAM

	call LoadGameOverPals
	call LoadGameOverGfx
	call LoadGameOverBGMaps
	call VBlank_GameOver

	xor a
	ldh [rSCX], a
	ld [wSCX], a
	ld a, $60
	ldh [rSCY], a
	ld [wSCY], a

	ld hl, wGameOverWario
	ld a, $80
	ld [hli], a ; y
	ld a, $50
	ld [hli], a ; x
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wGameOverWarioVar], a
	ld [wSFXTimer], a
	ld a, HIGH(SceneWarioFrameset_aaccb)
	ld [hli], a ; frameset pointer
	ld a, LOW(SceneWarioFrameset_aaccb)
	ld [hl], a
	farcall BANK(SceneWarioFrameset_aaccb), UpdateObjAnim
	ld hl, wGameOverWario
	call LoadGameOverSprite

	ld hl, wMenuObj1
	ld a, $18
	ld [hli], a ; y
	ld a, $18
	ld [hli], a ; x
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(GameOverFrameset_dbbf5)
	ld [hli], a ; frameset pointer
	ld a, LOW(GameOverFrameset_dbbf5)
	ld [hl], a
	call UpdateObjAnim
	ld hl, wMenuObj1
	call LoadGameOverSpriteWithScroll

	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	ld a, 64
	ld [wTimer], a
	ld hl, wSubState
	inc [hl]
	ret

UpdateGameOverScreen:
	ld a, [wGameOverWarioVar]
	dec a
	jr z, .scroll_in
	dec a
	jr z, .shake
	dec a
	jr z, .wait_input
	ld hl, wTimer
	dec [hl]
	jp nz, .update_wario

	play_sfx SFX_GAME_OVER
	ld hl, wGameOverWarioVar
	inc [hl]
	jr .update_wario

.scroll_in
	ld hl, wSCY
	dec [hl]
	dec [hl]
	dec [hl]
	jr nz, .update_wario
	play_sfx SFX_EARTHQUAKE
	play_music MUSIC_GOLF_GAME_OVER
	ld a, 6
	ld [wTimer], a
	ld hl, wGameOverWarioVar
	inc [hl]
	jr .update_wario

.shake
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wTimer
	dec [hl]
	ld a, [hl]
	and $01
	jr z, .shake_up
	ld hl, wSCY
	inc [hl]
	inc [hl]
	jr .update_wario
.shake_up
	ld hl, wSCY
	dec [hl]
	dec [hl]
	ld a, [wTimer]
	and a
	jr nz, .update_wario
	play_music MUSIC_GAME_OVER
	ld hl, wGameOverWarioVar
	inc [hl]
	jr .update_wario

.wait_input
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .update_wario
	play_sfx SFX_SELECTION
	ld hl, wGameOverWarioFramesetOffset
	xor a
	ld [hli], a
	ld [hli], a ; duration
	ld a, HIGH(SceneWarioFrameset_aace2)
	ld [hli], a ; frameset pointer
	ld a, LOW(SceneWarioFrameset_aace2)
	ld [hl], a
	ld hl, wSubState
	inc [hl]
.update_wario
	ld hl, wGameOverWarioFramesetPtr + 1
	farcall BANK(SceneWarioFrameset_aace2), UpdateObjAnim

	ld a, [wObjAnimWasReset]
	ld [wGameOverWarioAnimationEnded], a
	and a
	call nz, .PlaySnoreSFX
	ld hl, wGameOverWario
	call LoadGameOverSprite
	ld hl, wMenuObj1FramesetPtr + 1
	call UpdateObjAnim
	ld hl, wMenuObj1
	call LoadGameOverSpriteWithScroll
	call ClearUnusedVirtualOAM
	ret

.PlaySnoreSFX:
	play_sfx SFX_SNORE
	ret

WaitGameOverWarioAnim:
	ld hl, wGameOverWarioFramesetPtr + 1
	farcall BANK(SceneWarioFrameset_aaccb), UpdateObjAnim

	ld a, [wObjAnimWasReset]
	ld [wGameOverWarioAnimationEnded], a
	ld hl, wGameOverWario
	call LoadGameOverSprite
	ld hl, wMenuObj1FramesetPtr + 1
	call UpdateObjAnim
	ld hl, wMenuObj1
	call LoadGameOverSpriteWithScroll
	call ClearUnusedVirtualOAM
	ld a, [wGameOverWarioAnimationEnded]
	and a
	ret z
	ld hl, wSubState
	inc [hl]
	ret

GameOverReset:
	jp Init
