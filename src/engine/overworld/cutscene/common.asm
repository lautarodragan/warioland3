InitCutscene:
	farcall _InitCutscene
	ret

UpdateCutscene:
	call .SkipCutsceneIfAble
	farcall DoCutsceneFunc
	call ClearUnusedVirtualOAM
	ret

.SkipCutsceneIfAble:
	ld a, [wOWBarsState]
	and a
	ret z
	; was a cutscene triggered from the Top Bar
	ld a, [wOWStep]
	cp $01
	ret c
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	ret z
	; b btn pressed
	pop hl ; skip rest of UpdateCutscene
	ld hl, wSubState
	inc [hl]
	stop_sfx
	ret

ReturnFromCutscene:
	jp InitOverworld.after_cutscene
