; clears some SRAM stuff
ClearSaveData::
	xor a
	ld hl, sCheckVals
	ld b, $8
	call WriteAToHL_BTimes

	ld hl, sBackupCheckVals
	ld b, $8
	call WriteAToHL_BTimes

	ld hl, sWRAMCheckVals
	ld b, $8
	call WriteAToHL_BTimes

	ld hl, sBackup1WRAMCheckVals
	ld b, $8
	call WriteAToHL_BTimes

	ld hl, sBackup2WRAMCheckVals
	ld b, $8
	call WriteAToHL_BTimes

	ld hl, sBackup3WRAMCheckVals
	ld b, $8
	call WriteAToHL_BTimes

	ld a, $00
	ldh [hUnused_fffd], a
	jp Init
