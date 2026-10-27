InitTempleScene:
	farcall _InitTempleScene
	ret

UpdateTempleScene:
	farcall _UpdateTempleScene
	ret

ExitTempleScene:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr nz, .b_btn
	ld hl, wSubState
	inc [hl]
	ret
.b_btn
	ld a, SST_OVERWORLD_08
	ld [wSubState], a
	ret
