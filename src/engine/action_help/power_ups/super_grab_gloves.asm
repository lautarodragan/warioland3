SuperGrabGloveActionHelp:
	call .StateTable

	ld a, [wActionHelpBlackedOut]
	and a
	jp nz, .done
	ld a, [wActionHelpFrozen]
	and a
	jr nz, .action_help_frozen

	ld hl, wMenuObj4FramesetPtr + 1
	ld a, [wMenuObj4FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj4AnimationEnded], a

	ld hl, wActionHelpWarioFramesetPtr + 1
	farcall $5, UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wActionHelpWarioAnimationEnded], a

.action_help_frozen
	ld hl, wMenuObj4YCoord
	farcall LoadActionHelpSprite_Far
	ld hl, wActionHelpWario
	farcall LoadActionHelpWarioSprite

	ld hl, wMenuObj6FramesetPtr + 1
	ld a, [wMenuObj6FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld hl, wMenuObj6
	farcall LoadActionHelpSprite_Far
.done
	ret

.StateTable:
	ld a, [wActionHelpState]
	jumptable

	dw ActionHelp_Init
	dw SuperGrabGloveActionHelp_WaitToStart
	dw SuperGrabGloveActionHelp_Step02
	dw SuperGrabGloveActionHelp_Step03
	dw SuperGrabGloveActionHelp_Step04
	dw SuperGrabGloveActionHelp_Step05
	dw SuperGrabGloveActionHelp_Step06
	dw SuperGrabGloveActionHelp_Step07
	dw SuperGrabGloveActionHelp_Step08
	dw SuperGrabGloveActionHelp_Step09
	dw SuperGrabGloveActionHelp_Step0A
	dw SuperGrabGloveActionHelp_Step0B
	dw SuperGrabGloveActionHelp_Step0C
	dw SuperGrabGloveActionHelp_Step0D
	dw SuperGrabGloveActionHelp_Step0E
	dw SuperGrabGloveActionHelp_Step0F
	dw SuperGrabGloveActionHelp_Step10
	dw SuperGrabGloveActionHelp_Step11
	dw SuperGrabGloveActionHelp_Step12
	dw SuperGrabGloveActionHelp_Step13
	dw SuperGrabGloveActionHelp_Step14
	dw SuperGrabGloveActionHelp_Step15
	dw SuperGrabGloveActionHelp_Step16
	dw SuperGrabGloveActionHelp_Step17
	dw SuperGrabGloveActionHelp_Step18

SuperGrabGloveActionHelp_End:
	ld a, [wPowerUpLevel]
	bit ACTION_HELP_LEVEL_CLEAR_F, a
	jr nz, .return_to_overworld
	bit ACTION_HELP_TITLE_SCREEN_F, a
	jr z, .restart_action_help
	jp InitWithoutDemoPowerUpReset

.return_to_overworld
	and POWER_UP_MASK
	ld [wPowerUpLevel], a
	farcall ReturnToOverworld
	call ResumeNormalVolume
	ret

.restart_action_help
	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	ld a, $01
	ld [wActionHelpState], a
	jr SuperGrabGloveActionHelp_Start

SuperGrabGloveActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
SuperGrabGloveActionHelp_Start:
	call ActionHelp_ShowInitialWarioWalk
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowCountRichtertoffIdle
	call ActionHelp_ShowCountRichtertoffStun
	call ActionHelp_ShowOverheadPillar
	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step02:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioSlowGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step03:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $07
	jr z, .lift_to_waist
	cp $0d
	jr z, .lift_to_chest
	cp $0f
	jr z, .lift_overhead
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr nz, .begin_grab
	ret

.lift_to_waist
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $04
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_to_chest
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $14
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

.begin_grab
	ld [hl], $30
	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step04:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioBeginThrow
	call ActionHelp_ShowBInput
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step05:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioThrow
	call ActionHelp_ShowCountRichtertoffThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step06:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_richtertoff
	call ActionHelp_ShowWarioIdle
.move_richtertoff
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $10
	jr nc, .bounce
	ld a, [wMenuObj4XCoord]
	add $02
	ld [wMenuObj4XCoord], a
	ld a, [hl]
	cp $03
	ret c
	ld hl, wMenuObj4YCoord
	cp $06
	jr c, .fall_1px
	cp $0a
	jr c, .fall_2px
	jr .fall_fast

.fall_2px
	inc [hl]
.fall_1px
	inc [hl]
	ret

.fall_fast
	ld a, [hl]
	add $03
	ld [hl], a
	cp $40
	ret c
	ld [hl], $40
	ld a, $10
	ld [wTimer], a
	ret

.bounce
	ld a, [wMenuObj4XCoord]
	add $01
	ld [wMenuObj4XCoord], a
	ld a, [hl]
	ld hl, wMenuObj4YCoord
	cp $12
	jr c, .rise_3px
	cp $14
	jr c, .rise_2px
	cp $15
	jr c, .rise_1px
	cp $16
	jr c, .skip_ahead
	cp $27
	jr c, .fall_1px
	jr .land
.rise_3px
	dec [hl]
.rise_2px
	dec [hl]
.rise_1px
	dec [hl]
	ret

.skip_ahead
	ld a, $20
	ld [wTimer], a
	ret

.land
	ld a, [hl]
	add $02
	ld [hl], a
	cp $40
	ret c

	ld [hl], $40
	call ActionHelp_ShowWarioIdle
	call ActionHelp_ShowCountRichtertoffStun
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step07:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step08:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioSlowGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step09:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $07
	jr z, .lift_to_waist
	cp $0d
	jr z, .lift_to_chest
	cp $0f
	jr z, .lift_overhead
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr nz, .begin_grab
	ret

.lift_to_waist
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $04
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_to_chest
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $14
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

.begin_grab
	ld [hl], $30
	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step0A:
	ld hl, wTimer
	dec [hl]
	ret nz

	ld [hl], $20
	call ActionHelp_ShowDUpInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step0B:
	ld hl, wTimer
	dec [hl]
	ret nz

	ld [hl], $30
	call ActionHelp_ShowWarioBeginThrow
	call ActionHelp_ShowBInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step0C:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioThrow
	call ActionHelp_ShowCountRichtertoffThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step0D:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_richtertoff
	call ActionHelp_ShowWarioIdle
.move_richtertoff
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $30
	jr nc, .bounce
	ld a, [wMenuObj4XCoord]
	add $01
	ld [wMenuObj4XCoord], a
	ld a, [hl]
	ld hl, wMenuObj4YCoord
	cp $07
	jr c, .rise_4px
	cp $0d
	jr c, .rise_3px
	cp $0f
	jr c, .rise_2px
	cp $11
	jr c, .rise_1px
	cp $14
	ret c
	cp $17
	jr c, .fall_1px
	cp $1a
	jr c, .fall_2px
	cp $1d
	jr c, .fall_3px
	jr .fall_fast
.rise_4px
	dec [hl]
.rise_3px
	dec [hl]
.rise_2px
	dec [hl]
.rise_1px
	dec [hl]
	ret

.fall_3px
	inc [hl]
.fall_2px
	inc [hl]
.fall_1px
	inc [hl]
	ret

.fall_fast
	ld a, [hl]
	add $04
	ld [hl], a
	cp $40
	ret c
	ld [hl], $40
	ld a, $30
	ld [wTimer], a
	ret

.bounce
	ld a, [hl]
	ld hl, wMenuObj4YCoord
	cp $32
	jr c, .bounce_rise_3px
	cp $34
	jr c, .bounce_rise_2px
	cp $35
	jr c, .bounce_rise_1px
	cp $36
	jr c, .skip_ahead
	cp $47
	jr c, .fall_1px
	jr .land

.bounce_rise_3px
	dec [hl]
.bounce_rise_2px
	dec [hl]
.bounce_rise_1px
	dec [hl]
	ret

.skip_ahead
	ld a, $40
	ld [wTimer], a
	ret

.land
	ld a, [hl]
	add $02
	ld [hl], a
	cp $40
	ret c

	ld [hl], $40
	call ActionHelp_ShowWarioIdle
	call ActionHelp_ShowCountRichtertoffStun
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step0E:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step0F:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioSlowGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step10:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $07
	jr z, .lift_to_waist
	cp $0d
	jr z, .lift_to_chest
	cp $0f
	jr z, .lift_overhead
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr nz, .begin_grab
	ret

.lift_to_waist
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $04
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_to_chest
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $14
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWarioYCoord
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

.begin_grab
	ld [hl], $30
	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step11:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioGrabWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step12:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld a, [hl]
	cp $80
	ret nc

	call ActionHelp_ShowWarioBeginThrow
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowBInput
	ld a, $50
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step13:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioChargeThrow

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step14:
	play_sfx_rept 30, SFX_FULLY_CHARGED_THROW

	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z

	call ActionHelp_ShowWarioFullyChargedGrab
	ld a, [wMenuObj4XCoord]
	sub $08
	ld [wMenuObj4XCoord], a
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step15:
	play_sfx_rept 30, SFX_FULLY_CHARGED_THROW

	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioFullyChargedThrow
	call ActionHelp_ShowCountRichtertoffThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step16:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_richtertoff
	call ActionHelp_ShowWarioIdle
.move_richtertoff
	ld a, [wMenuObj6XCoord]
	sub $10
	ld b, a
	ld a, [wMenuObj4XCoord]
	add $04
	ld [wMenuObj4XCoord], a
	cp b
	ret c

	call ActionHelp_ShowWarioIdle
	call ActionHelp_ShowObj4EnemyVanish

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step17:
	ld a, [wMenuObj4AnimationEnded]
	and a
	ret z
	ld a, $e8
	ld [wMenuObj4XCoord], a
	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

SuperGrabGloveActionHelp_Step18:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $e8
	ret c
	jp SuperGrabGloveActionHelp_End
