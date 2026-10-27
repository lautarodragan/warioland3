SECTION "SRAM0", SRAM

sWRAMCheckVals:: ; a000
	ds $4

sSaveCounter:: ; a004
	ds $4

sGeneralData:: ; a008
	ds $57

sLevelData:: ; a05f
	ds $6f

	ds $2b2

sCheckVals:: ; a380
	ds $4

sGameData:: ; a384
	ds $6c

	ds $10

sBackup2WRAMCheckVals:: ; a400
	ds $4

sBackup2WRAMData:: ; a404
	ds $4

	ds $388

sSaveProgress:: ; a790
	ds $1

sGameDataChecksum::       dw ; a791
sBackupGameDataChecksum:: dw ; a793

sWRAMChecksum::        dw ; a795
sBackup1WRAMChecksum:: dw ; a797
sBackup2WRAMChecksum:: dw ; a799
sBackup3WRAMChecksum:: dw ; a79b

sLevelMapChecksum:: ; a79d
	ds $2

sBackupLevelMapChecksum:: ; a79f
	ds $2

	ds $3f

sSaveProgressEcho1:: ; a7e0
	ds $1

sGameDataChecksumEcho1::       dw ; a7e1
sBackupGameDataChecksumEcho1:: dw ; a7e3

sWRAMChecksumEcho1::        dw ; a7e5
sBackup1WRAMChecksumEcho1:: dw ; a7e7
sBackup2WRAMChecksumEcho1:: dw ; a7e9
sBackup3WRAMChecksumEcho1:: dw ; a7eb

sLevelMapChecksumEcho1:: ; a7ed
	ds $2

sBackupLevelMapChecksumEcho1:: ; a7ef
	ds $2

	ds $f

sBackup1WRAMCheckVals:: ; a800
	ds $4

sBackup1WRAMData:: ; a804
	ds $4

	ds $378

sBackupCheckVals:: ; ab80
	ds $4

sBackupGameData:: ; ab84
	ds $6c

	ds $10

sBackup3WRAMCheckVals:: ; ac00
	ds $4

sBackup3WRAMData:: ; ac04
	ds $4

	ds $398

sSaveProgressEcho2:: ; afa0
	ds $1

sGameDataChecksumEcho2::       dw ; afa1
sBackupGameDataChecksumEcho2:: dw ; afa3

sWRAMChecksumEcho2::        dw ; afa5
sBackup1WRAMChecksumEcho2:: dw ; afa7
sBackup2WRAMChecksumEcho2:: dw ; afa9
sBackup3WRAMChecksumEcho2:: dw ; afab

sLevelMapChecksumEcho2:: ; afad
	ds $2

sBackupLevelMapChecksumEcho2:: ; afaf
	ds $2

	ds $2f

sSaveCounterCompare1:: ; afe0
	ds $4

sSaveCounterCompare2:: ; afe4
	ds $4

sSaveCounterCompare3:: ; afe8
	ds $4

sSaveCounterCompare4:: ; afec
	ds $4

sSaveCounterCompare5:: ; aff0
	ds $4

sSaveCounterCompare6:: ; aff4
	ds $4

sSaveCounterCompareBits:: ; aff8
	ds $1

SECTION "SRAM1", SRAM

; map is separated into LEVEL_WIDTH wide rows of blocks
; followed by (LEVEL_WIDTH / 2) wide rows of objects
; these are interleaved with each other for each row
sLevelBlockObjectMap:: ; a000
	ds $2000

SECTION "SRAM2", SRAM

sLevelBlockObjectMap2:: ; a000
	ds $1000

sBackupLevelBlockObjectMap2:: ; b000
	ds $1000

SECTION "SRAM3", SRAM

sBackupLevelBlockObjectMap:: ; a000
	ds $2000