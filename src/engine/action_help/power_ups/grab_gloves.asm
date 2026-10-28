GrabGloveActionHelp:
	call .StateTable

	ld a, [wActionHelpBlackedOut]
	and a
	jp nz, .done

	ld hl, wMenuObj5FramesetPtr + 1
	ld a, [wMenuObj5FramesetBank]
	ld [wTempBank], a
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall UpdateObjAnim
	ld a, [wObjAnimWasReset]
	ld [wMenuObj5AnimationEnded], a
	ld hl, wMenuObj5YCoord
	farcall LoadActionHelpSprite_Far

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
	ld hl, wMenuObj4
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
	dw GrabGloveActionHelp_WaitToStart
	dw GrabGloveActionHelp_Step02
	dw GrabGloveActionHelp_Step03
	dw GrabGloveActionHelp_Step04
	dw GrabGloveActionHelp_Step05
	dw GrabGloveActionHelp_Step06
	dw GrabGloveActionHelp_Step07
	dw GrabGloveActionHelp_Step08
	dw ActionHelp_FlashBInput
	dw GrabGloveActionHelp_Step0A
	dw GrabGloveActionHelp_Step0B
	dw GrabGloveActionHelp_Step0C
	dw GrabGloveActionHelp_Step0D
	dw GrabGloveActionHelp_Step0E
	dw GrabGloveActionHelp_Step0F
	dw ActionHelp_FlashDUpInput
	dw GrabGloveActionHelp_Step11
	dw GrabGloveActionHelp_Step12
	dw GrabGloveActionHelp_Step13
	dw GrabGloveActionHelp_Step14
	dw GrabGloveActionHelp_Step15
	dw GrabGloveActionHelp_Step16
	dw GrabGloveActionHelp_Step17
	dw GrabGloveActionHelp_Step18
	dw GrabGloveActionHelp_Step19
	dw GrabGloveActionHelp_Step1A
	dw GrabGloveActionHelp_Step1B
	dw GrabGloveActionHelp_Step1C
	dw GrabGloveActionHelp_Step1D
	dw GrabGloveActionHelp_Step1E
	dw GrabGloveActionHelp_Step1F
	dw GrabGloveActionHelp_Step20
	dw GrabGloveActionHelp_Step21
	dw GrabGloveActionHelp_Step22
	dw GrabGloveActionHelp_Step23
	dw GrabGloveActionHelp_Step24

GrabGloveActionHelp_End:
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
	ld a, $1
	ld [wActionHelpState], a
	jr GrabGloveActionHelp_Start

GrabGloveActionHelp_WaitToStart:
	ld hl, wTimer
	dec [hl]
	ret nz
GrabGloveActionHelp_Start:
	call ActionHelp_ShowInitialWarioWalk
	call ActionHelp_ShowDRightInput
	call ActionHelp_ShowParaGoomWalk
	call ActionHelp_HideObj5BlockDebris

	ld hl, wMenuObj6
	ld a, $40
	ld [hli], a
	ld a, $e8
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, HIGH(ActionHelpFrameset_1e6b6a)
	ld [hli], a
	ld a, LOW(ActionHelpFrameset_1e6b6a)
	ld [hli], a
	ld a, HIGH(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, LOW(ActionHelpOAM_1e697c)
	ld [hli], a
	ld a, BANK(ActionHelpOAM_1e697c)
	ld [hli], a

	farcall LoadActionHelpPalsWithoutWater

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step02:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $70
	ret nc

	call ActionHelp_ShowAInput
	call ActionHelp_ShowWarioJump

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step03:
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a

	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [wActionHelpWarioVar]
	cp $18
	ret c
	ld a, [wActionHelpWarioYCoord]
	cp $36
	ret c

	call ActionHelp_ClearDPadInput
	call ActionHelp_ClearButtonsInput
	play_sfx SFX_STOMP
	ld a, $0a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowParaGoomStun

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step04:
	ld hl, wMenuObj4XCoord
	inc [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_inc
	inc [hl]
.skip_inc
	ld hl, wActionHelpWarioVar
	inc [hl]
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	ld a, [wMenuObj4YCoord]
	add [hl]
	cp $40
	jr nc, .skip_paragoom_y
	ld [wMenuObj4YCoord], a

.skip_paragoom_y
	ld a, [wActionHelpWarioYCoord]
	add [hl]
	ld [wActionHelpWarioYCoord], a
	cp $40
	ret c
	ld a, $40
	ld [wActionHelpWarioYCoord], a
	ld [wMenuObj4YCoord], a
	xor a
	ld [wActionHelpWarioVar], a
	call ActionHelp_ShowWarioIdle
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step05:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step06:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step07:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $03
	jr z, .lift_to_chest
	cp $06
	jr z, .lift_overhead
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z
	ld [hl], $30
	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

.lift_to_chest
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $0c
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

GrabGloveActionHelp_Step08:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioBeginThrow

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step0A:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $30
	ret c
	ld [hl], $00

	call ActionHelp_ShowWarioThrow
	call ActionHelp_ShowParaGoomThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step0B:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_paragoom
	call ActionHelp_ShowWarioIdle
.move_paragoom
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
	call ActionHelp_ShowParaGoomStun
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step0C:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step0D:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step0E:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $03
	jr z, .lift_to_chest
	cp $06
	jr z, .lift_overhead
	jr .wait_grab_anim
.lift_to_chest
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $0c
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

.wait_grab_anim
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z
	ld [hl], $30
	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step0F:
	ld hl, wTimer
	dec [hl]
	ret nz
	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step11:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $01
	jr z, .begin_throw
	cp $30
	ret c
	ld [hl], $00

	call ActionHelp_ShowWarioThrow
	call ActionHelp_ShowParaGoomThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

.begin_throw
	call ActionHelp_ShowWarioBeginThrow
	call ActionHelp_ShowBInput
	ret

GrabGloveActionHelp_Step12:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_paragoom
	call ActionHelp_ShowWarioIdle
.move_paragoom
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
	call ActionHelp_ShowParaGoomStun
	ld a, $30
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step13:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step14:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step15:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $03
	jr z, .lift_to_chest
	cp $06
	jr z, .lift_overhead
	jr .wait_grab_anim
.lift_to_chest
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $0c
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

.wait_grab_anim
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z
	ld [hl], $30

	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step16:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioGrabWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step17:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $5c
	ret nc

	call ActionHelp_ShowWarioBeginThrow
	call ActionHelp_ClearDPadInput
	call ActionHelp_ShowBInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step18:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $30
	ret c
	ld [hl], $00

	call ActionHelp_ShowWarioThrow
	call ActionHelp_ShowParaGoomThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step19:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_paragoom
	call ActionHelp_ShowWarioIdle
.move_paragoom
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $10
	jr nc, .bounce
	ld a, [wMenuObj6XCoord]
	ld b, a
	ld a, [wMenuObj4XCoord]
	add $02
	ld [wMenuObj4XCoord], a
	cp b
	push hl
	call nc, .show_debris_and_pillar
	pop hl
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
	call ActionHelp_ShowParaGoomStun
	ld a, $20
	ld [wTimer], a

	ld hl, wActionHelpState
	inc [hl]
	ret

.show_debris_and_pillar:
	ld b, $00
	call ActionHelp_ShowBlockDebrisWithYOffset
	ld a, [wMenuObj6]
	ld [wMenuObj5YCoord], a
	ld a, [wMenuObj6XCoord]
	ld [wMenuObj5XCoord], a
	call ActionHelp_ShowOverheadPillar
	ret

GrabGloveActionHelp_Step1A:
	ld a, [wMenuObj5AnimationEnded]
	and a
	jr z, .countdown
	call ActionHelp_HideObj5BlockDebris
.countdown
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step1B:
	ld hl, wMenuObj4XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
	ld a, [hl]
	cp $48
	ret nc

	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $05
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	call ActionHelp_ShowWarioGrab
	call ActionHelp_ClearDPadInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step1C:
	ld hl, wTimer
	inc [hl]
	ld a, [hl]
	cp $03
	jr z, .lift_to_chest
	cp $06
	jr z, .lift_overhead
	jr .wait_grab_anim
.lift_to_chest
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $0c
	ld [de], a
	inc de
	ld a, [hl]
	add $10
	ld [de], a
	ret

.lift_overhead
	ld hl, wActionHelpWario
	ld de, wMenuObj4YCoord
	ld a, [hli]
	sub $1c
	ld [de], a
	inc de
	ld a, [hl]
	add $06
	ld [de], a
	ret

.wait_grab_anim
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	ret z
	ld [hl], $30
	call ActionHelp_ShowWarioBeginGrab

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step1D:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioGrabWalk
	call ActionHelp_ShowDRightInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step1E:
	ld hl, wMenuObj6XCoord
	dec [hl]
	ld a, [wActionHelpCounter]
	and %1
	jr z, .skip_dec
	dec [hl]
.skip_dec
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

GrabGloveActionHelp_Step1F:
	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioChargeThrow

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step20:
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

GrabGloveActionHelp_Step21:
	play_sfx_rept 30, SFX_FULLY_CHARGED_THROW

	ld hl, wTimer
	dec [hl]
	ret nz

	call ActionHelp_ShowWarioFullyChargedThrow
	call ActionHelp_ShowParaGoomThrown
	call ActionHelp_ClearButtonsInput

	ld hl, wActionHelpState
	inc [hl]
	ret

GrabGloveActionHelp_Step22:
	ld a, [wActionHelpWarioAnimationEnded]
	and a
	jr z, .move_paragoom
	call ActionHelp_ShowWarioIdle
.move_paragoom
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

GrabGloveActionHelp_Step23:
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

GrabGloveActionHelp_Step24:
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
	jp GrabGloveActionHelp_End
