ValidateSaveData::
	ld a, [wSRAMBank]
	push af
	ld a, BANK("SRAM0")
	sramswitch

	ld hl, sCheckVals
	call CheckSaveVals1
	jr nc, .checkvals_ok
	ld hl, sWRAMCheckVals
	call CheckSaveVals2
	jr nc, .checkvals_ok
	ld hl, sBackup2WRAMCheckVals
	call CheckSaveVals2
	jr nc, .checkvals_ok

	ld hl, sBackupCheckVals
	call CheckSaveVals1
	jr nc, .checkvals_ok
	ld hl, sBackup1WRAMCheckVals
	call CheckSaveVals2
	jr nc, .checkvals_ok
	ld hl, sBackup3WRAMCheckVals
	call CheckSaveVals2
	jr nc, .checkvals_ok
	jp .no_valid_save

.checkvals_ok
	ld a, [sSaveProgress]
	ld b, a
	ld a, [sSaveProgressEcho1]
	ld c, a
	ld a, [sSaveProgressEcho2]
	ld d, a
	cp b ; sSaveProgressEcho2 == sSaveProgress?
	jr nz, .progress_differs
	cp c ; sSaveProgressEcho2 == sSaveProgressEcho1?
	jr z, .progress_all_equal ; both branches are the same
	ld [wSaveProgress], a
	jr .validate
.progress_all_equal
	ld [wSaveProgress], a
	jr .validate

.progress_differs
	; sSaveProgress != sSaveProgressEcho2
	cp c ; sSaveProgressEcho2 == sSaveProgressEcho1?
	jr z, .progress_echos_agree
	ld a, b
	cp c ; sSaveProgress == sSaveProgressEcho1?
	jr z, .progress_orig_echo1_agree

.no_valid_save
	ld a, $ff
	ld [wSaveProgress], a
	jr .validate

.progress_echos_agree
	ld [wSaveProgress], a
	jr .validate

.progress_orig_echo1_agree
	ld [wSaveProgress], a
	jr .validate ; useless jump

.validate
	call ValidateSaveChecksums
	call LoadNewestValidSave
	pop af
	sramswitch
	ret

; returns carry if bytes in [hl] are not:
; $77 $61 $72 $33
CheckSaveVals1:
	ld a, [hli]
	cp CHECKVAL1_1
	jr nz, .set_carry
	ld a, [hli]
	cp CHECKVAL1_2
	jr nz, .set_carry
	ld a, [hli]
	cp CHECKVAL1_3
	jr nz, .set_carry
	ld a, [hli]
	cp CHECKVAL1_4
	jr nz, .set_carry
	scf
	ccf
	ret
.set_carry
	scf
	ret

; returns carry if bytes in [hl] are not:
; $57 $41 $52 $33
CheckSaveVals2:
	ld a, [hli]
	cp CHECKVAL2_1
	jr nz, .set_carry
	ld a, [hli]
	cp CHECKVAL2_2
	jr nz, .set_carry
	ld a, [hli]
	cp CHECKVAL2_3
	jr nz, .set_carry
	ld a, [hli]
	cp CHECKVAL2_4
	jr nz, .set_carry
	scf
	ccf
	ret
.set_carry
	scf
	ret

ValidateSaveChecksums:
	xor a
	ld [wValidSaves], a
	ld hl, sCheckVals
	call CheckSaveVals1
	jr c, .clear_check_vals

	ld a, [sGameDataChecksum + 0]
	ld b, a
	ld a, [sGameDataChecksum + 1]
	ld c, a
	ld a, [sGameDataChecksumEcho1 + 0]
	ld d, a
	ld a, [sGameDataChecksumEcho1 + 1]
	ld e, a
	ld a, [sGameDataChecksumEcho2 + 0]
	ld h, a
	ld a, [sGameDataChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	ld hl, sGameData
	call .CalculateChecksumAtHL
	ld a, [wChecksum + 0]
	cp d
	jr nz, .game_data_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .game_data_mismatch
	jr .game_data_ok

.game_data_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .clear_check_vals
	; there's at least 1 mismatch, check if
	; it's equal to calculated checksum
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .game_data_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .game_data_check_alt2
	jr .game_data_ok

.game_data_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .clear_check_vals
	; there are 2 mismatches, check if next one
	; is equal to calculated checksum
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .clear_check_vals
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .clear_check_vals

.game_data_ok
	ld hl, sGameData ; useless
	ld hl, wValidSaves
	set 0, [hl]
	jr .check_backup_check_vals

.clear_check_vals
	ld a, $10
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

.check_backup_check_vals
	ld hl, sBackupCheckVals
	call CheckSaveVals1
	jr c, .clear_backup_check_vals
	ld a, [sBackupGameDataChecksum + 0]
	ld b, a
	ld a, [sBackupGameDataChecksum + 1]
	ld c, a
	ld a, [sBackupGameDataChecksumEcho1 + 0]
	ld d, a
	ld a, [sBackupGameDataChecksumEcho1 + 1]
	ld e, a
	ld a, [sBackupGameDataChecksumEcho2 + 0]
	ld h, a
	ld a, [sBackupGameDataChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	ld hl, sBackupGameData
	call .CalculateChecksumAtHL
	ld a, [wChecksum + 0]
	cp d
	jr nz, .backup_game_data_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .backup_game_data_mismatch
	jr .backup_game_data_ok

.backup_game_data_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .clear_backup_check_vals
	; there's at least 1 mismatch, check if
	; it's equal to calculated checksum
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .backup_game_data_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .backup_game_data_check_alt2
	jr .backup_game_data_ok

.backup_game_data_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .clear_backup_check_vals
	; there are 2 mismatches, check if next one
	; is equal to calculated checksum
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .clear_backup_check_vals
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .clear_backup_check_vals

.backup_game_data_ok
	ld hl, sBackupGameData ; useless
	ld hl, wValidSaves
	set 1, [hl]
	jr .check_level_map

.clear_backup_check_vals
	ld a, $20
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sBackupCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

.check_level_map
	ld a, [sLevelMapChecksum + 0]
	ld b, a
	ld a, [sLevelMapChecksum + 1]
	ld c, a
	ld a, [sLevelMapChecksumEcho1 + 0]
	ld d, a
	ld a, [sLevelMapChecksumEcho1 + 1]
	ld e, a
	ld a, [sLevelMapChecksumEcho2 + 0]
	ld h, a
	ld a, [sLevelMapChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	call CalculateBackupSRAMChecksum1
	ld a, [wChecksum + 0]
	cp d
	jr nz, .level_map_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .level_map_mismatch
	jr .level_map_ok

.level_map_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .level_map_bad
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .level_map_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .level_map_check_alt2
	jr .level_map_ok

.level_map_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .level_map_bad
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .level_map_bad
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .level_map_bad
.level_map_ok
	ld hl, wValidSaves
	set 6, [hl]
	ld hl, sWRAMCheckVals
	call CheckSaveVals2
	jr c, .clear_level_save_check_vals
	ld a, [sWRAMChecksum + 0]
	ld b, a
	ld a, [sWRAMChecksum + 1]
	ld c, a
	ld a, [sWRAMChecksumEcho1 + 0]
	ld d, a
	ld a, [sWRAMChecksumEcho1 + 1]
	ld e, a
	ld a, [sWRAMChecksumEcho2 + 0]
	ld h, a
	ld a, [sWRAMChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	ld hl, sSaveCounter
	call CalculateWRAMDataChecksumAtHL
	ld a, [wChecksum + 0]
	cp d
	jr nz, .level_save_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .level_save_mismatch
	jr .level_save_ok

.level_map_bad
	jp .clear_level_save_and_backup1_check_vals

.level_save_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .clear_level_save_check_vals
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .level_save_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .level_save_check_alt2
	jr .level_save_ok
.level_save_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .clear_level_save_check_vals
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .clear_level_save_check_vals
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .clear_level_save_check_vals
.level_save_ok
	ld hl, wValidSaves
	set 2, [hl]
	jp .check_backup_level_map
.clear_level_save_check_vals
	ld a, $30
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sWRAMCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	ld hl, sBackup1WRAMCheckVals
	call CheckSaveVals2
	jr c, .clear_level_save_and_backup1_check_vals
	ld a, [sBackup1WRAMChecksum + 0]
	ld b, a
	ld a, [sBackup1WRAMChecksum + 1]
	ld c, a
	ld a, [sBackup1WRAMChecksumEcho1 + 0]
	ld d, a
	ld a, [sBackup1WRAMChecksumEcho1 + 1]
	ld e, a
	ld a, [sBackup1WRAMChecksumEcho2 + 0]
	ld h, a
	ld a, [sBackup1WRAMChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	ld hl, sBackup1WRAMData
	call CalculateWRAMDataChecksumAtHL
	ld a, [wChecksum + 0]
	cp d
	jr nz, .backup1_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .backup1_mismatch
	jr .backup1_ok
.backup1_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .clear_level_save_and_backup1_check_vals
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .backup1_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .backup1_check_alt2
	jr .backup1_ok
.backup1_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .clear_level_save_and_backup1_check_vals
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .clear_level_save_and_backup1_check_vals
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .clear_level_save_and_backup1_check_vals
.backup1_ok
	ld hl, wValidSaves
	set 3, [hl]
	jp .check_backup_level_map
.clear_level_save_and_backup1_check_vals
	ld a, $30
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sWRAMCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	ld a, $50
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sBackup1WRAMCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

.check_backup_level_map
	ld a, [sBackupLevelMapChecksum + 0]
	ld b, a
	ld a, [sBackupLevelMapChecksum + 1]
	ld c, a
	ld a, [sBackupLevelMapChecksumEcho1 + 0]
	ld d, a
	ld a, [sBackupLevelMapChecksumEcho1 + 1]
	ld e, a
	ld a, [sBackupLevelMapChecksumEcho2 + 0]
	ld h, a
	ld a, [sBackupLevelMapChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	call CalculateBackupSRAMChecksum2
	ld a, [wChecksum + 0]
	cp d
	jr nz, .backup_level_map_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .backup_level_map_mismatch
	jr .backup_level_map_ok
.backup_level_map_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .backup_level_map_bad
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .backup_level_map_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .backup_level_map_check_alt2
	jr .backup_level_map_ok
.backup_level_map_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .backup_level_map_bad
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .backup_level_map_bad
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .backup_level_map_bad
.backup_level_map_ok
	ld hl, wValidSaves
	set 7, [hl]
	ld hl, sBackup2WRAMCheckVals
	call CheckSaveVals2
	jr c, .clear_backup2_check_vals
	ld a, [sBackup2WRAMChecksum + 0]
	ld b, a
	ld a, [sBackup2WRAMChecksum + 1]
	ld c, a
	ld a, [sBackup2WRAMChecksumEcho1 + 0]
	ld d, a
	ld a, [sBackup2WRAMChecksumEcho1 + 1]
	ld e, a
	ld a, [sBackup2WRAMChecksumEcho2 + 0]
	ld h, a
	ld a, [sBackup2WRAMChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	ld hl, sBackup2WRAMData
	call CalculateWRAMDataChecksumAtHL
	ld a, [wChecksum + 0]
	cp d
	jr nz, .backup2_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .backup2_mismatch
	jr .backup2_ok
.backup_level_map_bad
	jp .clear_backup2_and_backup3_check_vals
.backup2_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .clear_backup2_check_vals
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .backup2_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .backup2_check_alt2
	jr .backup2_ok
.backup2_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .clear_backup2_check_vals
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .clear_backup2_check_vals
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .clear_backup2_check_vals
.backup2_ok
	ld hl, wValidSaves
	set 4, [hl]
	ret

.clear_backup2_check_vals
	ld a, $60
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sBackup2WRAMCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	ld hl, sBackup3WRAMCheckVals
	call CheckSaveVals2
	jr c, .clear_backup2_and_backup3_check_vals
	ld a, [sBackup3WRAMChecksum + 0]
	ld b, a
	ld a, [sBackup3WRAMChecksum + 1]
	ld c, a
	ld a, [sBackup3WRAMChecksumEcho1 + 0]
	ld d, a
	ld a, [sBackup3WRAMChecksumEcho1 + 1]
	ld e, a
	ld a, [sBackup3WRAMChecksumEcho2 + 0]
	ld h, a
	ld a, [sBackup3WRAMChecksumEcho2 + 1]
	ld l, a
	call .GetMatchingChecksum

	ld hl, sBackup3WRAMData
	call CalculateWRAMDataChecksumAtHL
	ld a, [wChecksum + 0]
	cp d
	jr nz, .backup3_mismatch
	ld a, [wChecksum + 1]
	cp e
	jr nz, .backup3_mismatch
	jr .backup3_ok
.backup3_mismatch
	ld a, [wChecksumMismatches]
	and a
	jr z, .clear_backup2_and_backup3_check_vals
	ld a, [wChecksumAlt1 + 0]
	cp d
	jr nz, .backup3_check_alt2
	ld a, [wChecksumAlt1 + 1]
	cp e
	jr nz, .backup3_check_alt2
	jr .backup3_ok
.backup3_check_alt2
	ld a, [wChecksumMismatches]
	cp MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	jr nz, .clear_backup2_and_backup3_check_vals
	ld a, [wChecksumAlt2 + 0]
	cp d
	jr nz, .clear_backup2_and_backup3_check_vals
	ld a, [wChecksumAlt2 + 1]
	cp e
	jr nz, .clear_backup2_and_backup3_check_vals
.backup3_ok
	ld hl, wValidSaves
	set 5, [hl]
	ret

.clear_backup2_and_backup3_check_vals
	ld a, $60
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sBackup2WRAMCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	ld a, $80
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	xor a
	ld hl, sBackup3WRAMCheckVals
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	ret

; input:
; - bc = checksum
; - de = checksum echo 1
; - hl = checksum echo 2
; output:
; - wChecksum = best option for checksum value
.GetMatchingChecksum:
	ld a, h
	cp b
	jr nz, .echo2_not_equal
	cp d
	jr z, .all_high_bytes_equal
	ld a, c
	cp l
	jr nz, .none_equal
	jr .only_echo2_equal

.echo2_not_equal
	cp d
	jr z, .check_lower_echos
	ld a, b
	cp d
	jr z, .check_lower_echo1
	jr .none_equal

.check_lower_echos
	ld a, e
	cp l
	jr nz, .none_equal
	jr .only_echos_equal

.check_lower_echo1
	ld a, c
	cp e
	jr nz, .none_equal
	jr .only_echo1_equal

.all_high_bytes_equal
	ld a, l
	cp c
	jr nz, .check_echos_equality
	cp e
	jr z, .all_equal
	jr .only_echo2_equal

.check_echos_equality
	cp e
	jr z, .only_echos_equal
	ld a, c
	cp e
	jr z, .only_echo1_equal

.none_equal
	; none of the checksums match,
	; we'll use main checksum value for wChecksum
	ld a, MISMATCH_ORIG | MISMATCH_ECHO1 | MISMATCH_ECHO2
	ld [wChecksumMismatches], a

	; wChecksum <- checksum
	; wChecksumAlt1 <- checksum echo 1
	; wChecksumAlt2 <- checksum echo 2
	ld a, b
	ld [wChecksum + 0], a
	ld a, d
	ld [wChecksumAlt1 + 0], a
	ld a, h
	ld [wChecksumAlt2 + 0], a
	ld a, c
	ld [wChecksum + 1], a
	ld a, e
	ld [wChecksumAlt1 + 1], a
	ld a, l
	ld [wChecksumAlt2 + 1], a
	ret

.only_echo1_equal
	; only echo1 matches, so we'll,
	; that value for wChecksum
	ld a, MISMATCH_ECHO2
	ld [wChecksumMismatches], a

	; wChecksum & wChecksumAlt2 <- checksum
	; wChecksumAlt1 <- checksum echo 2
	ld a, b
	ld [wChecksum + 0], a
	ld [wChecksumAlt2 + 0], a
	ld a, h
	ld [wChecksumAlt1 + 0], a
	ld a, c
	ld [wChecksum + 1], a
	ld [wChecksumAlt2 + 1], a
	ld a, l
	ld [wChecksumAlt1 + 1], a
	ret

.only_echo2_equal
	; only echo2 matches, so we'll,
	; that value for wChecksum
	ld a, MISMATCH_ECHO1
	ld [wChecksumMismatches], a

	; wChecksum & wChecksumAlt2 <- checksum
	; wChecksumAlt1 <- checksum echo 1
	ld a, b
	ld [wChecksum + 0], a
	ld [wChecksumAlt2 + 0], a
	ld a, d
	ld [wChecksumAlt1 + 0], a
	ld a, c
	ld [wChecksum + 1], a
	ld [wChecksumAlt2 + 1], a
	ld a, e
	ld [wChecksumAlt1 + 1], a
	ret

.only_echos_equal
	; only the echos match together,
	; use that for wChecksum
	ld a, MISMATCH_ORIG
	ld [wChecksumMismatches], a

	; wChecksum & wChecksumAlt2 <- checksum echo 1
	; wChecksumAlt1 <- checksum
	ld a, d
	ld [wChecksum + 0], a
	ld [wChecksumAlt2 + 0], a
	ld a, b
	ld [wChecksumAlt1 + 0], a
	ld a, e
	ld [wChecksum + 1], a
	ld [wChecksumAlt2 + 1], a
	ld a, c
	ld [wChecksumAlt1 + 1], a
	ret

.all_equal
	; all checksums match, use that value for wChecksum
	xor a
	ld [wChecksumMismatches], a

	; wChecksum & wChecksumAlt2 & wChecksumAlt1 <- checksum
	ld a, b
	ld [wChecksum + 0], a
	ld [wChecksumAlt1 + 0], a
	ld [wChecksumAlt2 + 0], a
	ld a, c
	ld [wChecksum + 1], a
	ld [wChecksumAlt1 + 1], a
	ld [wChecksumAlt2 + 1], a
	ret

; calculates checksum of data
; starting at [hl], with length $5b + $11 = $6c
; input:
; - hl = pointer to data to start calculation
; output:
; - de = checksum result
.CalculateChecksumAtHL:
	ld de, 0 ; accumulator
	ld b, SIZEOF("Progress WRAM")
	call CalculateChecksum
	; this changes WRAM bank,
	; but this routine is never called
	; to calculate Checksums of WRAM data
	push_wram $02
	ld b, $11
	call CalculateChecksum
	pop_wram
	ret

; output:
; - de = checksum result
CalculateGameDataChecksum:
	ld de, 0 ; accumulator
	ld hl, STARTOF("Progress WRAM")
	ld b, SIZEOF("Progress WRAM")
	call CalculateChecksum
	push_wram BANK("WRAM2")
	ld hl, wTreasuresCollected
	ld b, (wOWLevel - wTreasuresCollected) + 2
	call CalculateChecksum
	pop_wram
	ret

LoadNewestValidSave:
	xor a
	ld [wRestoredSave], a
	ld a, [wValidSaves]
	and $3f
	jr nz, .asm_1f1266
.asm_1f1251
	ld hl, wLevelTimeAttackScores
	ld b, 2 * NUM_LEVELS
	ld a, (10 << $4) | 10
	call WriteAToHL_BTimes
	ld hl, wGolfBestScores
	ld b, $4
	ld a, (10 << $4) | 10
	call WriteAToHL_BTimes
	ret

.asm_1f1266
	ld b, a
	ld a, $3f
	and b
	ld [wRestoredSave], a
	ld bc, $600
.asm_1f1270
	rrca
	jr nc, .asm_1f1274
	inc c
.asm_1f1274
	dec b
	jr nz, .asm_1f1270
	ld a, c
	dec a
	jp z, .asm_1f1389

	ld hl, sGameData
	ld de, sSaveCounterCompare1
	ld b, $4
	call CopyHLToDE

	ld hl, sBackupGameData
	ld de, sSaveCounterCompare2
	ld b, $4
	call CopyHLToDE

	ld hl, sSaveCounter
	ld de, sSaveCounterCompare3
	ld b, $4
	call CopyHLToDE

	ld hl, sBackup1WRAMData
	ld de, sSaveCounterCompare4
	ld b, $4
	call CopyHLToDE

	ld hl, sBackup2WRAMData
	ld de, sSaveCounterCompare5
	ld b, $4
	call CopyHLToDE

	ld hl, sBackup3WRAMData
	ld de, sSaveCounterCompare6
	ld b, $4
	call CopyHLToDE

	ld e, $21
.asm_1f12c0
	dec e
	jp z, .asm_1f1389
	xor a
	ld [sSaveCounterCompareBits], a
	ld a, [wRestoredSave]
	bit 0, a
	jr z, .asm_1f12e4
	ld hl, sSaveCounterCompare1 + $3
	sla [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	jr nc, .asm_1f12e4
	ld hl, sSaveCounterCompareBits
	set 0, [hl]
.asm_1f12e4
	ld a, [wRestoredSave]
	bit 1, a
	jr z, .asm_1f1300
	ld hl, sSaveCounterCompare2 + $3
	sla [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	jr nc, .asm_1f1300
	ld hl, sSaveCounterCompareBits
	set 1, [hl]
.asm_1f1300
	ld a, [wRestoredSave]
	bit 2, a
	jr z, .asm_1f131c
	ld hl, sSaveCounterCompare3 + $3
	sla [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	jr nc, .asm_1f131c
	ld hl, sSaveCounterCompareBits
	set 2, [hl]
.asm_1f131c
	ld a, [wRestoredSave]
	bit 3, a
	jr z, .asm_1f1338
	ld hl, sSaveCounterCompare4 + $3
	sla [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	jr nc, .asm_1f1338
	ld hl, sSaveCounterCompareBits
	set 3, [hl]
.asm_1f1338
	ld a, [wRestoredSave]
	bit 4, a
	jr z, .asm_1f1354
	ld hl, sSaveCounterCompare5 + $3
	sla [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	jr nc, .asm_1f1354
	ld hl, sSaveCounterCompareBits
	set 4, [hl]
.asm_1f1354
	ld a, [wRestoredSave]
	bit 5, a
	jr z, .asm_1f1370
	ld hl, sSaveCounterCompare6 + $3
	sla [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	dec l
	rl [hl]
	jr nc, .asm_1f1370
	ld hl, sSaveCounterCompareBits
	set 5, [hl]

.asm_1f1370
	ld a, [sSaveCounterCompareBits]
	and a
	jp z, .asm_1f12c0
	ld [wRestoredSave], a
	ld bc, $600
.asm_1f137d
	rrca
	jr nc, .asm_1f1381
	inc c
.asm_1f1381
	dec b
	jr nz, .asm_1f137d
	ld a, c
	dec a
	jp nz, .asm_1f12c0
.asm_1f1389
	ld a, [wRestoredSave]
	bit 0, a
	jr nz, .asm_1f13a7
	bit 1, a
	jr nz, .asm_1f13ae
	bit 2, a
	jr nz, .asm_1f13b5
	bit 3, a
	jr nz, .asm_1f13bc
	bit 4, a
	jr nz, .asm_1f13c3
	bit 5, a
	jr nz, .asm_1f13cd
	jp .asm_1f1251
.asm_1f13a7
	ld hl, sGameData
	call .LoadGameData
	ret
.asm_1f13ae
	ld hl, sBackupGameData
	call .LoadGameData
	ret
.asm_1f13b5
	ld hl, sSaveCounter
	call .LoadWRAMData
	ret
.asm_1f13bc
	ld hl, sBackup1WRAMData
	call .LoadWRAMData
	ret
.asm_1f13c3
	ld hl, sBackup2WRAMData
	call .LoadWRAMData
	call .RestoreLevelMapFromBackup
	ret
.asm_1f13cd
	ld hl, sBackup3WRAMData
	call .LoadWRAMData
	call .RestoreLevelMapFromBackup
	ret

.LoadGameData:
	ld de, STARTOF("Progress WRAM")
	ld b, $5b
	call CopyHLToDE
	push_wram BANK("WRAM2")
	ld de, $d000
	ld b, $11
	call CopyHLToDE
	pop_wram
	ret

.LoadWRAMData:
	ld de, wSaveCounter
	ld b, SIZEOF("Progress WRAM") + SIZEOF("Level WRAM")
	call CopyHLToDE
	push_wram BANK("WRAM2")
	ld de, $d000
	ld b, $11
	call CopyHLToDE
	pop_wram
	push_wram BANK("Level Objects WRAM")
	ld de, STARTOF("Level Objects WRAM")
	ld bc, SIZEOF("Level Objects WRAM")
	call CopyHLToDE_BC
	pop_wram
	ret

.RestoreLevelMapFromBackup:
	ld a, $40
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	ld a, [wSRAMBank]
	push af
	ld a, BANK("SRAM2")
	sramswitch
	ld hl, sBackupLevelBlockObjectMap2
	ld de, sLevelBlockObjectMap2
	ld bc, $1000
	call CopyHLToDE_BC
	pop af
	sramswitch

; copy whole SRAM3 to SRAM1
	ld hl, sBackupLevelBlockObjectMap
	ld bc, $2000
.loop
	ld a, [wSRAMBank]
	push af
	ld a, BANK("SRAM3")
	sramswitch
	ld d, [hl]
	ld a, [wSRAMBank]
	push af
	ld a, BANK("SRAM1")
	sramswitch
	ld a, d
	ld [hli], a
	pop af
	sramswitch
	pop af
	sramswitch
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop

	ld a, $41
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	call CalculateBackupSRAMChecksum1
	ld a, d
	ld [sLevelMapChecksum + 0], a
	ld a, e
	ld [sLevelMapChecksum + 1], a

	ld a, $42
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	ld a, d
	ld [sLevelMapChecksumEcho1 + 0], a
	ld a, e
	ld [sLevelMapChecksumEcho1 + 1], a

	ld a, $43
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a

	ld a, d
	ld [sLevelMapChecksumEcho2 + 0], a
	ld a, e
	ld [sLevelMapChecksumEcho2 + 1], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	ret

BackupLevelMap:
	ld a, $70
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	ld a, [wSRAMBank]
	push af
	ld a, $02
	sramswitch
	ld hl, sLevelBlockObjectMap2
	ld de, sBackupLevelBlockObjectMap2
	ld bc, $1000
	call CopyHLToDE_BC
	pop af
	sramswitch

	ld hl, sWRAMCheckVals
	ld bc, $2000
.loop
	ld a, [wSRAMBank]
	push af
	ld a, $01
	sramswitch
	ld d, [hl]
	ld a, [wSRAMBank]
	push af
	ld a, $03
	sramswitch
	ld a, d
	ld [hli], a
	pop af
	sramswitch
	pop af
	sramswitch
	dec c
	jr nz, .loop
	dec b
	jr nz, .loop

	ld a, $71
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	call CalculateBackupSRAMChecksum2
	ld a, d
	ld [sBackupLevelMapChecksum + 0], a
	ld a, e
	ld [sBackupLevelMapChecksum + 1], a
	ld a, $72
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	ld a, d
	ld [sBackupLevelMapChecksumEcho1 + 0], a
	ld a, e
	ld [sBackupLevelMapChecksumEcho1 + 1], a
	ld a, $73
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	ld a, d
	ld [sBackupLevelMapChecksumEcho2 + 0], a
	ld a, e
	ld [sBackupLevelMapChecksumEcho2 + 1], a

	xor a
	ld [sSaveProgress], a
	ld [sSaveProgressEcho1], a
	ld [sSaveProgressEcho2], a
	ret
