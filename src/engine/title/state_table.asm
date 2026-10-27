TitleStateTable::
	push_wram BANK("GFX RAM")
	call .jump
	pop_wram
	ret

.jump
	ld a, [wSubState]
	jumptable

	dw SlowFadeToWhite
	dw InitIntroSequence
	dw SlowFadeFromWhite
	dw IntroSequencePhase1
	dw IntroSequencePhase2 ; SST_TITLE_INTRO_PHASE2
	dw IntroSequencePhase3 ; SST_TITLE_INTRO_PHASE3
	dw EndIntroSequence

	dw StartMenu ; SST_START_MENU
	dw FastFadeBGToWhite
	dw InitTimeAttackDescription
	dw TimeAttackDescription

	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
	dw DebugReset
