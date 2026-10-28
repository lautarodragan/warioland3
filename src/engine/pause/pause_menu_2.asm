LoadPauseMenuSprite::
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
	ld hl, PauseMenuOAM_1f156c
	call LoadSprite
	ret

PrintNumberMusicCoins:
	ld a, [wNumMusicalCoins]
	add a ; *2
	add $a0
	ldcoord_a 7, 15, v0BGMap1
	inc a
	ldcoord_a 7, 16, v0BGMap1
	ret

DrawLevelObjectsAfterLevelReturn::
	farcall VBlank_Level
	farcall SetTileQueueProcessingFunctions

	push_wram BANK("Level Objects WRAM")
	farcall DrawObjects_WithPriority
	pop_wram

	call DrawWario

	push_wram BANK("Level Objects WRAM")
	farcall DrawObjects_NoPriority
	pop_wram

	ret

HandlePauseMenuInput:
	ld a, [wPauseMenuSelection]
	bit PAUSEMENUF_B_PAD_SELECT, a
	ret nz
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, .Return

	ld a, [wPauseMenuSelection]
	cp PAUSEMENU_SAVE
	jr z, .save_selected
	cp PAUSEMENU_ACTION_HELP
	jr z, .action_help_selected
	cp PAUSEMENU_TO_MAP
	jr z, .to_map_selected

	; PAUSEMENU_RETURN
	ld a, [wJoypadPressed]
	bit B_PAD_RIGHT, a
	jr nz, .return_d_right
	bit B_PAD_A, a
	ret z
	jp .Return
.return_d_right
	ld a, [wGameModeFlags]
	bit MODE_TIME_ATTACK_F, a
	jr nz, .highlight_action_help_button
	jr .highlight_save_button

.save_selected
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jp nz, .highlight_return_button
	bit B_PAD_RIGHT, a
	jr nz, .highlight_action_help_button
	bit B_PAD_A, a
	ret z
	jp .Save

.action_help_selected
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr nz, .action_help_d_left
	bit B_PAD_RIGHT, a
	jr nz, .highlight_to_map_button
	bit B_PAD_A, a
	ret z
	jp .ActionHelp
.action_help_d_left
	ld a, [wGameModeFlags]
	bit MODE_TIME_ATTACK_F, a
	jp nz, .highlight_return_button
	jr .highlight_save_button

.to_map_selected
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr nz, .highlight_action_help_button
	bit B_PAD_A, a
	ret z
	jp .ToMap

.highlight_save_button
	ld a, PAUSEMENU_SAVE
	ld [wPauseMenuSelection], a
	ld hl, wMenuObj2
	ld a, $40
	ld [hli], a
	ld a, $40
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PauseMenuFrameset_1f1c9c)
	ld [hli], a
	ld a, LOW(PauseMenuFrameset_1f1c9c)
	ld [hl], a
	jr .play_sfx

.highlight_action_help_button
	ld a, PAUSEMENU_ACTION_HELP
	ld [wPauseMenuSelection], a
	ld hl, wMenuObj2
	ld a, $38
	ld [hli], a
	ld a, $60
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	jr z, .owl_1
	cp TRANSFORMATION_RAIL
	jr z, .rail_1
	cp TRANSFORMATION_VAMPIRE_WARIO
	jr z, .vampire_1
	ld bc, PauseMenuFrameset_1f1c50
	jr .got_frameset_1
.owl_1
	ld bc, PauseMenuFrameset_1f1cf9
	jr .got_frameset_1
.rail_1
	ld bc, PauseMenuFrameset_1f1d1b
	jr .got_frameset_1
.vampire_1
	ld bc, PauseMenuFrameset_1f1d41
.got_frameset_1
	ld a, b
	ld [hli], a
	ld a, c
	ld [hl], a
	jr .play_sfx

.highlight_to_map_button
	ld a, PAUSEMENU_TO_MAP
	ld [wPauseMenuSelection], a
	ld hl, wMenuObj2
	ld a, $40
	ld [hli], a
	ld a, $80
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PauseMenuFrameset_1f1c74)
	ld [hli], a
	ld a, LOW(PauseMenuFrameset_1f1c74)
	ld [hl], a

.play_sfx
	play_sfx SFX_MENU_SCROLL
	ret

.highlight_return_button
	ld a, PAUSEMENU_RETURN
	ld [wPauseMenuSelection], a
	ld hl, wMenuObj2
	ld a, $38
	ld [hli], a
	ld a, $20
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PauseMenuFrameset_1f1cb8)
	ld [hli], a
	ld a, LOW(PauseMenuFrameset_1f1cb8)
	ld [hl], a
	jr .play_sfx

.Return:
	ld a, PAUSEMENU_RETURN
	ld [wPauseMenuSelection], a
	ld hl, wMenuObj2
	ld a, $38
	ld [hli], a
	ld a, $20
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PauseMenuFrameset_1f1cbb)
	ld [hli], a
	ld a, LOW(PauseMenuFrameset_1f1cbb)
	ld [hl], a

	ld hl, wPauseMenuSelection
	set PAUSEMENUF_B_PAD_SELECT, [hl]
	play_sfx SFX_MENU_CANCEL
	ret

.Save:
	ld hl, wMenuObj2FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PauseMenuFrameset_1f1c9f)
	ld [hli], a
	ld a, LOW(PauseMenuFrameset_1f1c9f)
	ld [hl], a
	jr .do_selection

.ActionHelp:
	ld hl, wMenuObj2FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	jr z, .owl_2
	cp TRANSFORMATION_RAIL
	jr z, .rail_2
	cp TRANSFORMATION_VAMPIRE_WARIO
	jr z, .vampire_2
	ld bc, PauseMenuFrameset_1f1c69
	jr .got_frameset_2
.owl_2
	ld bc, PauseMenuFrameset_1f1d0a
	jr .got_frameset_2
.rail_2
	ld bc, PauseMenuFrameset_1f1d20
	jr .got_frameset_2
.vampire_2
	ld bc, PauseMenuFrameset_1f1d4c
.got_frameset_2
	ld a, b
	ld [hli], a
	ld a, c
	ld [hl], a
	jr .do_selection

.ToMap:
	ld hl, wMenuObj2FramesetOffset
	xor a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(PauseMenuFrameset_1f1c77)
	ld [hli], a
	ld a, LOW(PauseMenuFrameset_1f1c77)
	ld [hl], a
	jr .do_selection ; useless jump

.do_selection
	ld hl, wPauseMenuSelection
	set PAUSEMENUF_B_PAD_SELECT, [hl]
	play_sfx SFX_SELECTION
	ret
