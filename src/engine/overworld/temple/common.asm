InitTempleScene:
	farcall _InitTempleScene
	ret

UpdateTempleScene:
	farcall _UpdateTempleScene
	ret

Func_80e33:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr nz, .b_btn
	ld hl, wSubState
	inc [hl]
	ret
.b_btn
	ld a, SST_OVERWORLD_MAP_SIDE
	ld [wSubState], a
	ret
