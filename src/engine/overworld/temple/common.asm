InitTempleScene:
	farcall _InitTempleScene
	ret

UpdateTempleScene:
	farcall _UpdateTempleScene
	ret

; from MapSide_ChangeSide (SST_OVERWORLD_TO_GOLF_BUILDING): on to the golf
; building, or back to the map side if B is held
EnterGolfBuildingUnlessB:
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
