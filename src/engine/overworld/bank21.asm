DayNightTransition:
	ld hl, wOWPalTransitionCounter
	inc [hl]
	ld a, [wOWIsNight]
	and a
	jp nz, .NightToDayTable

; Day to Night table
	ld a, [wOWPalTransitionState]
	jumptable

	dw .InitDayToNight
	dw .FadeColours
	dw .LoadPal1_Day
	dw .FadePal1ToPal2_Day
	dw .LoadPal2
	dw .FadeColours
	dw .SwitchDayNight

.InitDayToNight:
	call .LoadBaseAndTargetPals
	ld a, $01
	ld [wOWIsNightTarget], a
	xor a
	ld [wSouthOWObj14MoveStarted], a
	xor a
	ld [wOWPalTransitionDelay], a
	ret

.LoadBaseAndTargetPals:
	di
	call VBlank_OWPalTransition
	ei

	; load the very last pal to buffer
	ld a, $03
	call GetOWPals
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE

	xor a
	call LoadBaseAndTargetOWPals

.AdvanceTable:
	xor a
	ld hl, wOWPalTransitionCounter
	ld [hld], a
	inc [hl] ; wOWPalTransitionState
	ret

.UnreferencedWait4: ; unreferenced
	ld a, [wOWPalTransitionCounter]
	cp $04
	ret c
	jp .AdvanceTable

.FadeColours:
	ld a, [wSubState]
	cp SST_OVERWORLD_0B
	jr nz, .no_skip

	; if B button is pressed
	; or any of the allowed D-pad directions
	; then skip the day/night transition
	ld a, [wJoypadPressed]
	ld b, a
	bit B_PAD_B, b
	jp nz, SkipDayNightTransition
	ld a, [wOWAllowedDPadInput]
	and b
	jp nz, SkipDayNightTransition

.no_skip
	ld hl, wOWPalTransitionDelay
	ld a, [wOWPalTransitionCounter]
	cp [hl]
	ret c

	xor a
	ld [wOWPalTransitionCounter], a
	ld a, 8 * PAL_COLORS * 3
	ld [wColourFadeLoopCounter], a

	ld hl, wFadePals + COLOURFADESTRUCT_SIGN
.loop
	; first we check whether to increase or decrease value
	; in case it's already at target colour, skip
	ld a, [hli] ; COLOURFADESTRUCT_SIGN
	and a
	jr z, .skip
	ld b, 1
	dec a
	jr z, .got_step
	ld b, -1
	dec a
	jr z, .got_step
	debug_nop
.got_step
	; add diff to the accumulator, if this value exceeds DAYNIGHT_TRANSITION_STEPS,
	; we apply the step to the current value
	; this makes it so that base colour gets to targer colour
	; at most in DAYNIGHT_TRANSITION_STEPS number of steps
	ld a, b
	ld [wColourFadeStep], a
	ld a, [hli] ; COLOURFADESTRUCT_DIFF
	ld [wColourFadeDiff], a
	ld b, a
	ld a, [hl] ; COLOURFADESTRUCT_ACCUMULATOR
	ld [wColourFadeAccumulator], a
	add b
	cp DAYNIGHT_TRANSITION_STEPS
	jr c, .dont_apply_step
	sub DAYNIGHT_TRANSITION_STEPS
	ld [hl], a ; COLOURFADESTRUCT_ACCUMULATOR
	inc l
	ld a, [wColourFadeStep]
	add [hl] ; COLOURFADESTRUCT_CURRENT
	ld [hl], a
	ld bc, (COLOURFADESTRUCT_LENGTH + COLOURFADESTRUCT_SIGN) - COLOURFADESTRUCT_CURRENT
	add hl, bc
	jr .next
.dont_apply_step
	ld [hl], a ; COLOURFADESTRUCT_ACCUMULATOR
	ld bc, (COLOURFADESTRUCT_LENGTH + COLOURFADESTRUCT_SIGN) - COLOURFADESTRUCT_ACCUMULATOR
	add hl, bc
	jr .next

.skip
	ld bc, (COLOURFADESTRUCT_LENGTH + COLOURFADESTRUCT_SIGN) - COLOURFADESTRUCT_DIFF
	add hl, bc
.next
	ld a, [wColourFadeLoopCounter]
	dec a
	ld [wColourFadeLoopCounter], a
	and a
	jr nz, .loop

	call ApplyPalFadeColours

	ld a, [wDayNightTransistionSteps]
	dec a
	ld [wDayNightTransistionSteps], a
	and a
	ret nz
	jp .AdvanceTable

.LoadPal1_Day:
	call .LoadPal1
	ret

.LoadPal1:
	ld a, $01
	call LoadBaseAndTargetOWPals
	jp .AdvanceTable

.FadePal1ToPal2_Day:
	call .FadeColours
	ld a, [wDayNightTransistionSteps]
	cp 12
	ret nz
	xor a
	ld [wOWPalTransitionDelay], a
	ret

.LoadPal2:
	ld a, $02
	call LoadBaseAndTargetOWPals
	jp .AdvanceTable

.SwitchDayNight:
	ld a, [wOWIsNight]
	xor $1
	ld [wOWIsNight], a
	ld hl, wDayNight
	srl [hl]
	rra
	rl [hl]
	res 7, [hl]
	call PlayOverworldMusic
	xor a
	ld [wPathPreviewState], a
	ld [wOWPalTransitionState], a
	ld [wOWPalTransitionCounter], a
	ret

.NightToDayTable:
	ld a, [wOWPalTransitionState]
	jumptable

	dw .InitNightToDay
	dw .FadeDayToPal1
	dw .LoadPal1_Night
	dw .FadePal1ToPal2_Night
	dw .SwitchDayNight

.InitNightToDay:
	call .LoadBaseAndTargetPals
	xor a
	ld [wOWIsNightTarget], a
	ld [wSouthOWObj14MoveStarted], a
	xor a
	ld [wOWPalTransitionDelay], a
	ret

.FadeDayToPal1:
	call .FadeColours
	ld a, [wDayNightTransistionSteps]
	cp 10
	ret nz
	xor a
	ld [wOWPalTransitionDelay], a
	ret

.LoadPal1_Night:
	call .LoadPal1
	ret

.FadePal1ToPal2_Night:
	call .FadeColours
	ld a, [wDayNightTransistionSteps]
	cp $16
	ret nz
	xor a
	ld [wOWPalTransitionDelay], a
	ret

DaytimeTransition:
	ld hl, wOWPalTransitionCounter
	inc [hl]
	ld a, [wOWPalTransitionState]
	jumptable
	dw .Init
	dw .Wait4
	dw .Fade1
	dw .Wait6
	dw .LoadPal1
	dw .Fade2
	dw .End

.Init:
	call DayNightTransition.LoadBaseAndTargetPals
	ld a, $03
	ld [wOWPalTransitionDelay], a
	ret

.Wait4:
	ld a, [wOWPalTransitionCounter]
	cp $04
	ret c
	jp DayNightTransition.AdvanceTable

.Fade1:
	call DayNightTransition.FadeColours
	ld a, [wDayNightTransistionSteps]
	cp $0a
	ret nz
	xor a
	ld [wOWPalTransitionDelay], a
	ret

.Wait6:
	ld a, [wOWPalTransitionCounter]
	cp $06
	ret c
	jp DayNightTransition.AdvanceTable

.LoadPal1:
	call DayNightTransition.LoadPal1
	ld a, $02
	ld [wOWPalTransitionDelay], a
	ld a, $13
	ld hl, wSceneObj7State
	call SetSceneObjState
	ret

.Fade2:
	call DayNightTransition.FadeColours
	ld a, [wDayNightTransistionSteps]
	cp $16
	ret nz
	ld a, $03
	ld [wOWPalTransitionDelay], a
	ret

.End:
	ld a, [wOWBarsState]
	and a
	jr nz, .asm_84bff
	ld [wDayNight], a ; $0
.asm_84bff
	xor a
	ld [wOWIsNight], a
	ld [wPathPreviewState], a
	ld [wOWPalTransitionState], a
	ld [wOWPalTransitionCounter], a
	ret

DayNightSpellTransition:
	ld hl, wOWPalTransitionCounter
	inc [hl]
	ld a, [wOWPalTransitionState]
	jumptable
	dw .Init
	dw .FadeColours
	dw .LoadPal1
	dw .FadeColours
	dw .LoadPal2
	dw .FadeColours
	dw .SwitchDayNight

.Init:
	di
	call VBlank_OWPalTransition
	ei
	xor a
	call LoadBaseAndTargetOWPals
	jp DayNightTransition.AdvanceTable

.FadeColours:
	jp DayNightTransition.FadeColours

.LoadPal1:
	jp DayNightTransition.LoadPal1

.LoadPal2:
	jp DayNightTransition.LoadPal2

.SwitchDayNight:
	ld a, [wOWIsNight]
	xor $01
	ld [wOWIsNight], a
	xor a
	ld [wPathPreviewState], a
	ld [wOWPalTransitionState], a
	ld [wOWPalTransitionCounter], a
	ret

LoadBaseAndTargetOWPals:
	call GetOWPals
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	; fill in the target colours
	push de
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wFadePals + COLOURFADESTRUCT_TARGET
	call CopyPalToColourFadeStructs
	pop de

	; fill in the base colours
	push de
	ld hl, wFadePals + COLOURFADESTRUCT_BASE
	call CopyPalToColourFadeStructs
	call InitColourFadeStructs
	pop hl

	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE

	ld a, DAYNIGHT_TRANSITION_STEPS
	ld [wDayNightTransistionSteps], a
	xor a
	ld [wOWPalTransitionDelay], a
	ret

GetOWPals:
	add a ; *2
	ld c, a
	call .CheckCrayons
	swap a ; *$10
	ld e, a
	ld d, $00
	ld a, [wOWIsNight]
	swap a
	rrca ; day/night shift
	or e ; crayon shift
	or c ; input shift
	ld e, a
	ld hl, OWPals
	add hl, de
	ret

.CheckCrayons:
	ld a, [wCrayonFlags]
	and ALL_CRAYONS
	cp ALL_CRAYONS
	ld a, [wCurMapSide]
	ret nz ; exit if not all crayons
	and a
	jr z, .north
	cp WEST
	jr z, .west
	ret
.north
	ld a, $4
	ret
.west
	ld a, $5
	ret

InitColourFadeStructs:
	ld a, 8 * PAL_COLORS * 3
	ld [wColourFadeLoopCounter], a
	ld hl, wFadePals
.loop
	ld a, [hli] ; COLOURFADESTRUCT_BASE
	ld b, a
	ld e, a
	ld a, [hli] ; COLOURFADESTRUCT_TARGET
	cp b
	jr z, .equal
	ld d, $01 ; increase
	jr nc, .larger
; smaller
	; switch a with b
	ld d, a
	ld a, b
	ld b, d
	ld d, $02 ; decrease
.larger
	sub b
	ld b, a ; difference
	ld a, d
	ld [hli], a ; COLOURFADESTRUCT_SIGN
	ld a, b
	ld [hli], a ; COLOURFADESTRUCT_DIFF
	ld [hli], a ; COLOURFADESTRUCT_ACCUMULATOR
	ld [hl], e ; COLOURFADESTRUCT_CURRENT
	jr .next

.equal
	xor a
	ld [hli], a ; COLOURFADESTRUCT_SIGN
	ld [hli], a ; COLOURFADESTRUCT_DIFF
	ld [hli], a ; COLOURFADESTRUCT_ACCUMULATOR
	ld [hl], e  ; COLOURFADESTRUCT_CURRENT

.next
	ld bc, (COLOURFADESTRUCT_LENGTH + COLOURFADESTRUCT_BASE) - COLOURFADESTRUCT_CURRENT
	add hl, bc
	ld a, [wColourFadeLoopCounter]
	dec a
	ld [wColourFadeLoopCounter], a
	ret z
	jr .loop

; writes red/blue/green colour values
; from the pal in de to hl
; in intervals of 8 bytes between them
CopyPalToColourFadeStructs:
	ld a, 8 * PAL_COLORS
	ld [wColourFadeLoopCounter], a
.loop
	ld a, [de]
	and %11111
	ld [hl], a ; red
	ld bc, COLOURFADESTRUCT_LENGTH
	add hl, bc
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	ld a, c
	srl b
	rra
	srl b
	rra
	rra
	rra
	rra
	and %11111
	ld [hl], a ; green
	ld a, b
	ld bc, COLOURFADESTRUCT_LENGTH
	add hl, bc
	and %11111
	ld [hl], a ; blue
	inc de
	ld bc, COLOURFADESTRUCT_LENGTH
	add hl, bc

	ld a, [wColourFadeLoopCounter]
	dec a
	ld [wColourFadeLoopCounter], a
	and a
	jr nz, .loop
	ret

ApplyPalFadeColours:
	ld hl, wFadePals + COLOURFADESTRUCT_CURRENT
	ld de, wTempBGPals
	ld a, 8 * PAL_COLORS
	ld [wColourFadeLoopCounter], a
.loop
	ld a, [hl] ; red
	ld bc, COLOURFADESTRUCT_LENGTH
	add hl, bc
	ld b, a
	ld a, [hl] ; green
	ld c, a
	rrca
	rrca
	rrca
	and %11100000
	or b
	ld [de], a
	inc de
	ld a, c
	ld bc, COLOURFADESTRUCT_LENGTH
	add hl, bc
	rlca
	rlca
	rlca
	ld c, a
	ld a, [hl] ; blue
	sla c
	rla
	sla c
	rla
	and %1111111
	ld [de], a

	ld a, [wColourFadeLoopCounter]
	dec a
	ld [wColourFadeLoopCounter], a
	and a
	ret z
	inc de
	ld bc, COLOURFADESTRUCT_LENGTH
	add hl, bc
	jr .loop

SkipDayNightTransition:
	; apply target pals immediately
	ld hl, wTempPals1
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE

	xor a
	ld [wDayNightTransistionSteps], a
	ld [wOWPalTransitionCounter], a
	ld b, $06
	ld a, [wOWIsNight]
	and a
	jr z, .day
	ld b, $04
.day
	ld a, b
	ld [wOWPalTransitionState], a
	ret

; used for both Day/Night transition
; and for grey transition
VBlank_OWPalTransition:
	ld hl, .Func
	ld de, wVBlankFunc
	ld b, .end - .Func
	call CopyHLToDE
	ret

.Func:
	ld a, $02
	ldh [rWBK], a
	ld a, [wSCY]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a
	ld a, [wWY]
	ldh [rWY], a
	ld a, [wWX]
	add WX_OFS
	ldh [rWX], a

	ld b, BANK(CopyCommonOWAnimTilesToVRAM)
	ld a, [wROMBank]
	push af
	ld a, b
	bankswitch
	call CopyCommonOWAnimTilesToVRAM
	pop af
	bankswitch

	ld hl, wTempBGPals
	ld c, LOW(rBGPI)
	ld a, BGPI_AUTOINC | palette 0
	ld [$ff00+c], a
	inc c
	ld b, 8 ; num pals
.loop_pals
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	dec b
	jr nz, .loop_pals
	xor a
	ldh [rVBK], a
	ld a, HIGH(wVirtualOAM)
	jp hTransferVirtualOAM
.end

OWPals:
; North
	; day
	dw NorthOWDayPals
	dw NorthOWDusk1Pals
	dw NorthOWDusk2Pals
	dw NorthOWNightPals

	; night
	dw NorthOWNightPals
	dw NorthOWDawnPals
	dw NorthOWDayPals
	dw NorthOWDayPals

; West
	; day
	dw WestOWDayPals
	dw WestOWDusk1Pals
	dw WestOWDusk2Pals
	dw WestOWNightPals

	; night
	dw WestOWNightPals
	dw WestOWDawnPals
	dw WestOWDayPals
	dw WestOWDayPals

; South
	; day
	dw SouthOWDayPals
	dw SouthOWDusk1Pals
	dw SouthOWDusk2Pals
	dw SouthOWNightPals

	; night
	dw SouthOWNightPals
	dw SouthOWDawnPals
	dw SouthOWDayPals
	dw SouthOWDayPals

; East
	; day
	dw EastOWDayPals
	dw EastOWDusk1Pals
	dw EastOWDusk2Pals
	dw EastOWNightPals

	; night
	dw EastOWNightPals
	dw EastOWDawnPals
	dw EastOWDayPals
	dw EastOWDayPals

; North (all crayons)
	; day
	dw NorthOWCrayonsDayPals
	dw NorthOWCrayonsDusk1Pals
	dw NorthOWCrayonsDusk2Pals
	dw NorthOWCrayonsNightPals

	; night
	dw NorthOWCrayonsNightPals
	dw NorthOWCrayonsDawnPals
	dw NorthOWCrayonsDayPals
	dw NorthOWCrayonsDayPals

; West (all crayons)
	; day
	dw WestOWCrayonsDayPals
	dw WestOWCrayonsDusk1Pals
	dw WestOWCrayonsDusk2Pals
	dw WestOWCrayonsNightPals

	; night
	dw WestOWCrayonsNightPals
	dw WestOWCrayonsDawnPals
	dw WestOWCrayonsDayPals
	dw WestOWCrayonsDayPals

GreyOWPalsPointers:
	dw NorthOWGreyPals ; NORTH
	dw WestOWGreyPals ; WEST
	dw SouthOWGreyPals ; SOUTH
	dw EastOWGreyPals ; EAST
	dw EastOWGreyNoIcePals ; EAST (no Ice)

FadeBGAndOBPals:
	ld a, [wPalConfig1TotalSteps]
	cp $01
	jr nc, .asm_84e77
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, HIGH(wTempBGPals)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8
	ld [wPalConfig1Number], a

	ld a, HIGH(wTempOBPals)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempOBPals)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8
	ld [wPalConfig2Number], a
	ret

.asm_84e77
	call StepOBPalConfigFade
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	ret

_PrologueFade:
	ld a, [wPalConfig1TotalSteps]
	cp 1
	jp nc, .do_fade ; >= 1
; init fade
	ld a, [wPrologueFadeType]
	and a
	jr z, .zero
	dec a
	jr z, .one
	dec a
	jp z, .two
	dec a
	jp z, .three
	dec a
	jp z, .four
	dec a
	jp z, .five
	dec a
	jp z, .six

.set_pal_configs
	ld a, HIGH(wTempBGPals)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8 ; number of pals
	ld [wPalConfig1Number], a

	ld a, HIGH(wTempOBPals)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempOBPals)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8 ; number of pals
	ld [wPalConfig2Number], a

	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ret

.do_fade
	call StepOBPalConfigFade
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	ld hl, wOWStepCounter
	ld [hld], a
	inc [hl]
	ret

.zero
	call .CopyPalsToBGAndOBPals
	call ClearTempPals_Bank21
	jr .set_pal_configs

.one
	call .CopyPalsToBGAndOBPals
	ld hl, PrologueBGPals
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, PrologueOBPals
	ld de, wTempPals2
	ld b, 8 palettes
	call CopyHLToDE
	jr .set_pal_configs

.six
	call .CopyPalsToBGAndOBPals
	ld hl, PrologueBGPals
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, PrologueOBPals
	ld de, wTempPals2
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, PrologueCaveWarioPal
	ld de, wTempPals2
	ld b, 1 palettes
	call CopyHLToDE
	jp .set_pal_configs

.two
	call .CopyPalsToBGAndOBPals
	ld hl, TempleBGPals
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, PrologueOBPals
	ld de, wTempPals2
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, SceneWarioPal
	ld de, wTempPals2
	ld b, 1 palettes
	call CopyHLToDE
	jp .set_pal_configs

.three
	call .CopyPalsToBGAndOBPals
	xor a
	ld hl, wTempPals1
	ld bc, 6 palettes
	call WriteAToHL_BCTimes
	xor a
	ld hl, wTempPals2 palette 1
	ld bc, 7 palettes
	call WriteAToHL_BCTimes
	jp .set_pal_configs

.four
	call .CopyPalsToBGAndOBPals
	ld hl, HiddenFigureBGPals
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(HiddenFigureBGPals)
	call CopyFarBytes
	ld hl, HiddenFigureOBPals
	ld de, wTempPals2 palette 3
	ld c, 5 palettes
	ld b, BANK(HiddenFigureOBPals)
	call CopyFarBytes
	jp .set_pal_configs

.five
	call .CopyPalsToBGAndOBPals
	ld hl, TempleBGPals palette 6
	ld de, wTempPals1 palette 6
	ld b, 2 palettes
	call CopyHLToDE
	ld hl, PrologueOBPals
	ld de, wTempPals2
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, SceneWarioPal
	ld de, wTempPals2
	ld b, 1 palettes
	call CopyHLToDE
	jp .set_pal_configs

.CopyPalsToBGAndOBPals:
	ld hl, wTempPals1
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE
	ld hl, wTempPals2
	ld de, wTempOBPals
	ld b, 8 palettes
	call CopyHLToDE
	ret

; unreferenced
UnreferencedClearBGOBPals:
	xor a
	ld hl, wTempBGPals
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	xor a
	ld hl, wTempOBPals
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	ret

ClearTempPals_Bank21:
	xor a
	ld hl, wTempPals1
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	xor a
	ld hl, wTempPals2
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	ret

_CutsceneFadePals:
	ld a, [wPalConfig1TotalSteps]
	cp $01
	jr nc, .asm_85033
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, HIGH(wTempBGPals)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8
	ld [wPalConfig1Number], a

	ld a, HIGH(wTempOBPals)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempOBPals)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8
	ld [wPalConfig2Number], a
	ret

.asm_85033
	call StepOBPalConfigFade
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

_CutsceneFadeToWhite:
	ld a, [wPalConfig1TotalSteps]
	cp 1
	jr nc, .asm_850a6

	ld hl, wTempPals1 palette 1
	ld de, wTempBGPals palette 1
	ld b, 7 palettes
	call CopyHLToDE
	ld a, $ff
	ld hl, wTempPals1 palette 1
	ld bc, 7 palettes
	call WriteAToHL_BCTimes
	ld hl, wTempPals2
	ld de, wTempOBPals
	ld b, 8 palettes
	call CopyHLToDE
	ld a, $ff
	ld hl, wTempPals2
	ld bc, 8 palettes
	call WriteAToHL_BCTimes

	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, HIGH(wTempBGPals palette 1)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals palette 1)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 1
	ld [wPalConfig1Index], a
	ld a, 7
	ld [wPalConfig1Number], a
	ld a, HIGH(wTempOBPals)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempOBPals)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8
	ld [wPalConfig2Number], a
	ret

.asm_850a6
	call StepOBPalConfigFade
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

_CutsceneFadeOBToWhite:
	ld a, [wPalConfig2TotalSteps]
	cp $01
	jr nc, .asm_850ef
	ld hl, wTempPals2
	ld de, wTempOBPals
	ld b, 8 palettes
	call CopyHLToDE
	ld a, $ff
	ld hl, wTempPals2
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	ld hl, wPalConfig2TotalSteps
	inc [hl]
	ld a, HIGH(wTempOBPals)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempOBPals)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8
	ld [wPalConfig2Number], a
	ret

.asm_850ef
	call StepOBPalConfigFade
	ret c
	xor a
	ld [wPalConfig2TotalSteps], a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

_CutsceneFadeBGToWhite:
	ld a, [wPalConfig1TotalSteps]
	cp $01
	jr nc, .asm_85135
	ld hl, wTempPals1 palette 1
	ld de, wTempBGPals palette 1
	ld b, 7 palettes
	call CopyHLToDE
	ld a, $ff
	ld hl, wTempPals1 palette 1
	ld bc, 7 palettes
	call WriteAToHL_BCTimes
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, HIGH(wTempBGPals palette 1)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals palette 1)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 1
	ld [wPalConfig1Index], a
	ld a, 7
	ld [wPalConfig1Number], a
	ret

.asm_85135
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

_OWFuncFadePals:
	ld a, [wPalConfig1TotalSteps]
	cp $01
	jr nc, .asm_85179
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, HIGH(wTempBGPals)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals)
	ld [wPalConfig1SourceLo], a
	ld a, BGPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8
	ld [wPalConfig1Number], a
	ld a, HIGH(wTempOBPals)
	ld [wPalConfig2SourceHi], a
	ld a, LOW(wTempOBPals)
	ld [wPalConfig2SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig2Index], a
	ld a, 8
	ld [wPalConfig2Number], a
	ret

.asm_85179
	call StepOBPalConfigFade
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wOWFuncCounter], a
	ld hl, wOWFuncStep
	inc [hl]
	ret

_OWFuncFadeBGPals:
	ld a, [wPalConfig1TotalSteps]
	cp $01
	jr nc, .fade
	ld a, HIGH(wTempBGPals)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals)
	ld [wPalConfig1SourceLo], a
	ld a, OBPI_AUTOINC | palette 0
	ld [wPalConfig1Index], a
	ld a, 8
	ld [wPalConfig1Number], a
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ret

.fade
	call StepBGPalConfigFade
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wOWFuncCounter], a
	ld hl, wOWFuncStep
	inc [hl]
	ret

StepBGPalConfigFade:
	ld a, LOW(rBGPI)
	ld [wPalConfig1Register], a
	xor a
	ld [wPalConfigToFade], a
	ld a, 1 ; slow fade
	ld [wPalFadeRepeat], a
	ld hl, wPalConfig1TotalSteps
	call FadePalConfig
	ret

StepOBPalConfigFade:
	ld a, LOW(rOBPI)
	ld [wPalConfig2Register], a
	ld a, 1
	ld [wPalConfigToFade], a
	ld a, 1
	ld [wPalFadeRepeat], a
	ld hl, wPalConfig2TotalSteps
	call FadePalConfig
	ret

OWGreyTransition:
	ld hl, wOWPalTransitionCounter
	inc [hl]
	ld a, [wOWPalTransitionState]
	jumptable
	dw .Start
	dw DayNightTransition.FadeColours
	dw .Finish

.Start:
	ld de, wTempPals1 + COLOURFADESTRUCT_BASE
	ld hl, wFadePals
	call CopyPalToColourFadeStructs
	ld hl, wTempPals1
	ld de, wTempBGPals
	ld b, 8 palettes
	call CopyHLToDE

	call LoadGreyOWPals
	ld hl, wFadePals + COLOURFADESTRUCT_TARGET
	ld de, wTempPals1
	call CopyPalToColourFadeStructs
	call InitColourFadeStructs

	ld a, DAYNIGHT_TRANSITION_STEPS
	ld [wDayNightTransistionSteps], a
	xor a
	ld [wOWPalTransitionDelay], a
	di
	call VBlank_OWPalTransition
	ei
	jp DayNightTransition.AdvanceTable

.Finish:
	xor a
	ld [wPathPreviewState], a
	ld [wOWPalTransitionState], a
	ld [wOWPalTransitionCounter], a
	ret

LoadGreyOWPals:
	ld a, [wCurMapSide]
	ld b, a
	add a ; *2
	ld e, a
	ld d, $00
	ld hl, GreyOWPalsPointers
	add hl, de
	ld a, EAST
	cp b
	call z, .GetEastMapNoIcePalette
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE
	xor a
	ld hl, wTempPals1 palette 7 color 1
	ld bc, $6
	call WriteAToHL_BCTimes
	ret

; if Blue Book or Trident have not been collected
; then advance to the next palette
.GetEastMapNoIcePalette:
	push hl
	ld a, BLUE_BOOK
	call IsTreasureCollected
	jr z, .next_pal
	ld a, MAGIC_WAND
	call IsTreasureCollected
	jr z, .next_pal
	pop hl
	ret
.next_pal
	pop hl
	inc hl
	inc hl
	ret

FadeInLevelName:
	ld a, [wPalConfig1TotalSteps]
	cp 1
	jr nc, .do_fade
; init fade
	ld a, $02
	ld [wLevelNameFadeState], a

	ld hl, wTempPals1 palette 7
	ld de, wTempBGPals palette 7
	ld b, 1 palettes
	call CopyHLToDE

	ld a, [wTempleHintState]
	and a
	jr z, .load_day_night_pal

	; make level name blue
	ld hl, TempleHintLevelNamePals color 1
	ld de, wTempPals1 palette 7 color 1
	ld b, $6
	call CopyHLToDE
	jr .set_pal_config

.load_day_night_pal
; level name pal during the day is white
; and during the night is yellow
	ld hl, NorthOWDayPals palette 7 ; day
	ld a, [wOWIsNight]
	and a
	jr z, .got_pal
	ld hl, NorthOWNightPals palette 7 ; night
.got_pal
	ld de, wTempPals1 palette 7
	ld b, 1 palettes
	call CopyHLToDE

.set_pal_config
	ld a, HIGH(wTempBGPals palette 7)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals palette 7)
	ld [wPalConfig1SourceLo], a
	ld a, OBPI_AUTOINC | palette 7
	ld [wPalConfig1Index], a
	ld a, 1
	ld [wPalConfig1Number], a
	ld hl, wPalConfig1TotalSteps
	inc [hl]
	scf
	jr .return

.do_fade
	call FadeBGPalConfig
	jr c, .return
	; finished fade
	ld a, 0
	ld [wPalConfig1TotalSteps], a
	inc a ; $1
	ld [wLevelNameFadeState], a
.return
	; shift carry flag to c
	ld c, $00
	rl c
	ret

TempleHintLevelNamePals:
	rgb 31, 31, 31
	rgb  8, 31, 31
	rgb 14, 14, 14
	rgb  0,  0,  0

FadeOutLevelName:
	ld a, [wLevelNameFadeState]
	xor $03
	ret nz
	ld a, [wBottomBarAction]
	and a
	ret nz
	ld a, [wPalConfig1TotalSteps]
	cp 1
	jr nc, .asm_85325

	ld hl, wTempPals1 palette 7 color 1
	ld de, wTempBGPals palette 7 color 1
	ld b, $6
	call CopyHLToDE

	xor a
	ld hl, wTempPals1 palette 7 color 1
	ld bc, $6
	call WriteAToHL_BCTimes

	ld hl, wPalConfig1TotalSteps
	inc [hl]
	ld a, HIGH(wTempBGPals palette 7)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempBGPals palette 7)
	ld [wPalConfig1SourceLo], a
	ld a, OBPI_AUTOINC | palette 7
	ld [wPalConfig1Index], a
	ld a, 1
	ld [wPalConfig1Number], a
	ret

.asm_85325
	call FadeBGPalConfig
	ret c
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wLevelNameFadeState], a
	ret

FadeBGPalConfig:
	ld a, LOW(rBGPI)
	ld [wPalConfig1Register], a
	xor a
	ld [wPalConfigToFade], a
	ld b, 4 ; fast fade
	ld a, [wCurEvent]
	and a
	jr z, .fast_fade
	ld b, 1 ; slow fade
.fast_fade
	ld a, b
	ld [wPalFadeRepeat], a
	ld hl, wPalConfig1TotalSteps
	call FadePalConfig
	ret

; fades pal in wPalConfig
; from wTempBGPals/wTempOBPals to wTempPals1/wTempPals2
; return carry if total steps hasn't reached $20
FadePalConfig:
	push hl
	ld a, [hl]
	ld [wCurPalTotalSteps], a
.loop
	ld a, [wPalConfigToFade]
	ld hl, wPalConfig1Number
	and a
	jr z, .got_config
	ld hl, wPalConfig2Number
.got_config
	ld a, [hli] ; number of pals
	rlca
	rlca ; *4
	ld b, a
	ld a, [hli] ; source hi
	dec a
	ld d, a
	ld e, [hl] ; source lo
	ld hl, wTargetRGB
.loop_colours
	ld a, [de]
	and %00011111
	ld [hli], a ; wTargetRed
	ld a, [de]
	and %11100000
	rrca
	rrca
	rrca
	rrca
	rrca
	ld [hl], a
	inc e
	ld a, [de]
	and %00000011
	rlca
	rlca
	rlca
	or [hl]
	ld [hli], a ; wTargetGreen
	ld a, [de]
	and %01111100
	rrca
	rrca
	ld [hli], a ; wTargetBlue
	dec e

	ld d, HIGH(wTempBGPals) ; aka HIGH(wTempOBPals)
	ld a, [de]
	and %00011111
	ld [hli], a ; wCurRed
	ld a, [de]
	and %11100000
	rrca
	rrca
	rrca
	rrca
	rrca
	ld [hl], a
	inc e
	ld a, [de]
	and %00000011
	rlca
	rlca
	rlca
	or [hl]
	ld [hli], a ; wCurGreen
	ld a, [de]
	and %01111100
	rrca
	rrca
	ld [hl], a ; wCurBlue

	ld a, [wTargetBlue]
	ld c, a
	ld a, [hl] ; wCurBlue
	cp c
	jr z, .got_blue
	jr nc, .dec_blue
	inc [hl]
	jr .got_blue
.dec_blue
	dec [hl]
.got_blue
	dec l
	ld a, [wTargetGreen]
	ld c, a
	ld a, [hl] ; wCurGreen
	cp c
	jr z, .got_green
	jr nc, .dec_green
	inc [hl]
	jr .got_green
.dec_green
	dec [hl]
.got_green
	dec l
	ld a, [wTargetRed]
	ld c, a
	ld a, [hl] ; wCurRed
	cp c
	jr z, .got_red
	jr nc, .dec_red
	inc [hl]
	jr .got_red
.dec_red
	dec [hl]
.got_red
	ld a, [hli] ; wCurRed
	ld c, a
	ld a, [hl] ; wCurGreen
	and %111
	rlca
	rlca
	rlca
	rlca
	rlca
	or c
	dec e
	ld [de], a
	ld a, [hli]
	and %11000
	rrca
	rrca
	rrca
	ld c, a
	ld a, [hld] ; wCurBlue
	rlca
	rlca
	or c
	inc e
	ld [de], a

	inc e
	ld d, HIGH(wTempPals1)
	ld hl, wTargetRGB
	dec b
	jp nz, .loop_colours

	ld hl, wCurPalTotalSteps
	inc [hl]
	ld a, [wPalFadeRepeat]
	dec a
	ld [wPalFadeRepeat], a
	jp nz, .loop

	ld a, [hl]
	pop hl
	ld [hl], a
	cp $20
	ret

_LoadPalsForOWScene:
	call GetMapSidePalGroup1
	call .GetCrayonPal
	ld a, [wOWIsNight]
	and a
	jr z, .day
	ld de, 24 palettes
	add hl, de
.day
	call LoadPalsToTempPals1

	call GetMapSidePalGroup2
	call LoadPalsToTempPals2

	; load grey pals if it's a map exit unlock
	ld a, [wOWExitUnlocked]
	and a
	ret z ; not exit
	call LoadGreyOWPals
	ret

; if it's North or West and all crayons have been collected
; get the correct palette for this map side
.GetCrayonPal:
	ld a, [wCrayonFlags]
	and ALL_CRAYONS
	cp ALL_CRAYONS
	ret nz

; got all crayons
	ld a, [wCurMapSide]
	and a
	jr z, .north
	dec a
	jr z, .west
	ret

.north
	ld a, [wLastTransitionParam]
	cp CRAYON_RED_T
	jr c, .not_crayon
	cp CRAYON_PINK_T + 1
	ret c
.not_crayon
	ld hl, NorthOWCrayonsDayPals
	ret
.west
	ld hl, WestOWCrayonsDayPals
	ret

LoadOWStarIndicatorPals:
	ld hl, OWStarIndicatorPals
	ld de, wTempPals2 palette 4
	ld b, 2 palettes
	call CopyHLToDE
	ld a, HIGH(wTempPals2 palette 4)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempPals2 palette 4)
	ld [wPalConfig1SourceLo], a
	ld a, OBPI_AUTOINC | palette 4
	ld [wPalConfig1Index], a
	ld a, 2
	ld [wPalConfig1Number], a
	ld a, LOW(rOBPI)
	ld [wPalConfig1Register], a
	ret

_LoadMapSidePals:
	call GetMapSidePalGroup1
	call .UpdatePalsIfGotAllCrayons
	ld a, [wOWIsNight]
	and a
	jr z, .load_pals
	ld de, 24 palettes
	add hl, de
.load_pals
	call LoadPalsToTempPals1
	call GetMapSidePalGroup2
	call LoadPalsToTempPals2
	ret

; for North and West side, update pals if all the
; crayons were collected, to change Golf Building's colour
.UpdatePalsIfGotAllCrayons:
	ld a, [wCrayonFlags]
	and ALL_CRAYONS
	cp ALL_CRAYONS
	ret nz

; got all crayons
	ld a, [wCurMapSide]
	and a
	jr z, .north
	dec a
	jr z, .west
	ret
.north
	ld hl, NorthOWCrayonsDayPals
	ret
.west
	ld hl, WestOWCrayonsDayPals
	ret

GetMapSidePalGroup1:
	ld hl, NorthOWDayPals
	ld de, 40 palettes
	ld a, [wCurMapSide]
	inc a
.loop
	dec a
	ret z
	add hl, de
	jr .loop

GetMapSidePalGroup2:
	ld hl, NorthOWOBPals
	ld de, 8 palettes
	ld a, [wCurMapSide]
	inc a
.loop
	dec a
	ret z
	add hl, de
	jr .loop

ApplyPalConfig2:
	ld hl, wPalConfig2
	jr ApplyPalConfig_Bank21

ApplyPalConfig1:
	ld hl, wPalConfig1
;	fallthrough

ApplyPalConfig_Bank21:
	ld c, [hl]
	xor a
	ld [hli], a
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld l, [hl]
	ld h, a
.loop
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	ld a, [hli]
	ld [$ff00+c], a
	dec b
	jr nz, .loop
	ret

_ApplyOWTilemapPatches:
.start
	ld a, [hli]
	and a
	ret z
	ld e, a
	ld c, a
	ld a, [hli]
	ld d, a
	ld b, a
.loop_1
	ld a, [hli]
	cp $70
	jr z, .next
	ld [de], a
	inc de
	jr .loop_1
.next
	dec b
	dec b
	dec b
.loop_2
	ld a, [hli]
	cp $70
	jr z, .start
	ld [bc], a
	inc bc
	jr .loop_2

WOWTilemapPatch_Rain:
	dwcoord 9, 8, wTilemap
	db $6d, $6e, $6e, $6e, $79, $70
	db $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0 | BG_XFLIP, $0 | BG_BANK0, $70

	dwcoord 9, 9, wTilemap
	db $6c, $7c, $7c, $7c, $6c, $70
	db $0 | BG_BANK0, $1 | BG_BANK1, $1 | BG_BANK1, $1 | BG_BANK1, $0 | BG_BANK0 | BG_XFLIP, $70

	dwcoord 9, 10, wTilemap
	db $7d, $7e, $7e, $7e, $7d, $70
	db $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0 | BG_XFLIP, $0 | BG_BANK0 | BG_XFLIP, $70

	db $00 ; end

WOWTilemapPatch_VulcanoEruption:
	dwcoord 7, 1, wTilemap
	db $c4, $75, $76, $75, $7f, $77, $c4, $70
	db $1 | BG_BANK1, $5 | BG_BANK1, $5 | BG_BANK1, $5 | BG_BANK1 | BG_XFLIP, $5 | BG_BANK1, $5 | BG_BANK1, $1 | BG_BANK1 | BG_XFLIP, $70

	db $00 ; end

WOWTilemapPatch_Earthquake:
	dwcoord 8, 4, wTilemap
	db $56, $57, $45, $46, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $70

	dwcoord 8, 5, wTilemap
	db $58, $59, $5a, $5b, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $70

	dwcoord 8, 6, wTilemap
	db $5c, $5d, $5e, $5f, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $70

	db $00 ; end

WOWTilemapPatch_RedMusicBox:
	dwcoord 6, 14, wTilemap
	db $7e, $7e, $7e, $70
	db $4 | BG_BANK1, $4 | BG_BANK1, $4 | BG_BANK1, $70

	db $00 ; end

SOWTilemapPatch_RaiseTower:
	dwcoord 14, 2, wTilemap
	db $20, $21, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $70

	dwcoord 14, 3, wTilemap
	db $30, $31, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $70

	dwcoord 14, 4, wTilemap
	db $22, $23, $70
	db $5 | BG_BANK0, $5 | BG_BANK0, $70

	dwcoord 14, 5, wTilemap
	db $32, $33, $70
	db $5 | BG_BANK0, $5 | BG_BANK0, $70

	dwcoord 14, 6, wTilemap
	db $24, $25, $70
	db $5 | BG_BANK0, $5 | BG_BANK0, $70

	dwcoord 14, 7, wTilemap
	db $34, $35, $70
	db $5 | BG_BANK0, $5 | BG_BANK0, $70

	dwcoord 14, 8, wTilemap
	db $26, $27, $70
	db $5 | BG_BANK0, $5 | BG_BANK0, $70

	db $00 ; end

SOWTilemapPatch_CanyonThunder:
	dwcoord 5, 6, wTilemap
	db $00, $70
	db $0 | BG_BANK0, $70

	dwcoord 5, 7, wTilemap
	db $0d, $0e, $0f, $04, $70
	db $3 | BG_BANK0, $3 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $70

	dwcoord 6, 8, wTilemap
	db $00, $02, $12, $13, $70
	db $7 | BG_BANK1, $7 | BG_BANK1, $3 | BG_BANK0, $3 | BG_BANK0, $70

	dwcoord 7, 9, wTilemap
	db $14, $15, $16, $70
	db $3 | BG_BANK0, $3 | BG_BANK0, $3 | BG_BANK0, $70

	dwcoord 7, 10, wTilemap
	db $17, $18, $19, $70
	db $3 | BG_BANK0, $3 | BG_BANK0, $3 | BG_BANK0, $70

	dwcoord 7, 11, wTilemap
	db $1a, $1b, $1c, $70
	db $3 | BG_BANK0, $3 | BG_BANK0, $3 | BG_BANK0, $70

	dwcoord 7, 12, wTilemap
	db $1d, $1e, $1f, $70
	db $3 | BG_BANK0, $3 | BG_BANK0, $3 | BG_BANK0, $70

	db $00 ; end

SOWTilemapPatch_Earthquake:
	dwcoord 5, 10, wTilemap
	db $19, $3e, $3f, $70
	db $2 | BG_BANK1, $3 | BG_BANK0, $3 | BG_BANK0, $70

	dwcoord 5, 11, wTilemap
	db $3d, $4e, $4f, $70
	db $3 | BG_BANK0, $3 | BG_BANK0, $3 | BG_BANK0, $70

	db $00 ; end

SOWTilemapPatch_GreenMusicBox:
	dwcoord 8, 2, wTilemap
	db $48, $49, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $70

	dwcoord 8, 3, wTilemap
	db $58, $59, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $70

	db $00 ; end

SOWTilemapPatch_RevealCastle:
	dwcoord 16, 3, wTilemap
	db $51, $5f, $53, $70
	db $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $70

	dwcoord 16, 4, wTilemap
	db $5c, $5d, $5e, $70
	db $1 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $70

	dwcoord 16, 5, wTilemap
	db $d9, $79, $7a, $70
	db $1 | BG_BANK1 | BG_XFLIP, $0 | BG_BANK0, $0 | BG_BANK0, $70

	db $00 ; end

EOWTilemapPatch_Earthquake:
	dwcoord 3, 9, wTilemap
	db $6c, $6d, $6e, $6f, $70
	db $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $70

	dwcoord 3, 10, wTilemap
	db $7c, $7d, $7e, $7f, $70
	db $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $0 | BG_BANK0, $70

	db $00 ; end

EOWTilemapPatch_FreezeSea:
	dwcoord 1, 13, wTilemap
	db $f7, $f6, $f9, $f8, $f8, $f8, $f9, $f9, $f9, $40, $41, $42, $43, $2c, $2d, $f8, $f9, $f6, $70
	db $2 | BG_BANK1 | BG_XFLIP, $2 | BG_BANK1 | BG_XFLIP, $2 | BG_BANK1 | BG_XFLIP, $2 | BG_BANK1 | BG_XFLIP, $2 | BG_BANK1, $2 | BG_BANK1 | BG_XFLIP, $2 | BG_BANK1, $2 | BG_BANK1 | BG_XFLIP, $2 | BG_BANK1, $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $1 | BG_BANK0, $2 | BG_BANK0, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $70

	dwcoord 1, 14, wTilemap
	db $78, $79, $78, $79, $78, $79, $78, $79, $78, $50, $51, $52, $53, $3c, $3d, $79, $78, $79, $70
	db $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK0, $2 | BG_BANK0, $2 | BG_BANK0, $2 | BG_BANK0, $2 | BG_BANK0, $2 | BG_BANK0, $2 | BG_BANK1, $2 | BG_BANK1, $2 | BG_BANK1, $70

	db $00 ; end

OWSceneFreezeSeaTilemap: INCBIN "data/bgmaps/overworld/ow_scene_freeze_sea.tilemap"
OWSceneFreezeSeaAttrmap: INCBIN "data/bgmaps/overworld/ow_scene_freeze_sea.attrmap"

Tilemap_85928: INCBIN "data/bgmaps/map_85928.tilemap" ; unreferenced

CopyOWTileColumn1:
.asm_85a68
	ld hl, wOWTileColumnCopy1Dest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [bc]
	ld [de], a
	ld hl, $a0
	add hl, bc
	dec d
	dec d
	dec d
	ld a, [hl]
	ld [de], a
	ld a, [wOWTileColumnCopy1RowsLeft]
	dec a
	ld [wOWTileColumnCopy1RowsLeft], a
	ret z
	ld de, wOWTileColumnCopy1Dest
	call AddTilemapRowToPtrAtDE
	call AddTilemapRowToPtrAtDE
	jr .asm_85a68

AddTilemapRowToPtrAtDE:
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	dec de
	ld bc, $20
	add hl, bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ret

CopyOWTileColumn2:
.asm_85aa2
	ld hl, wOWTileColumnCopy2Dest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [bc]
	ld [de], a
	ld hl, $a0
	add hl, bc
	dec d
	dec d
	dec d
	ld a, [hl]
	ld [de], a
	ld a, [wOWTileColumnCopy2RowsLeft]
	dec a
	ld [wOWTileColumnCopy2RowsLeft], a
	ret z
	ld de, wOWTileColumnCopy2Dest
	call AddTilemapRowToPtrAtDE
	call AddTilemapRowToPtrAtDE
	jr .asm_85aa2

CopyOWTileColumn3:
.asm_85acb
	ld hl, wOWTileColumnCopy3Dest
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [bc]
	ld [de], a
	ld hl, $a0
	add hl, bc
	dec d
	dec d
	dec d
	ld a, [hl]
	ld [de], a
	ld a, [wOWTileColumnCopy3RowsLeft]
	dec a
	ld [wOWTileColumnCopy3RowsLeft], a
	ret z
	ld de, wOWTileColumnCopy3Dest
	call AddTilemapRowToPtrAtDE
	call AddTilemapRowToPtrAtDE
	jr .asm_85acb

EOWTilemapPatch_FormCastle1:
	dwcoord 4, 3, wTilemap
	db $44, $45, $70
	db $01, $01, $70

	db $00 ; end

EOWTilemapPatch_FormCastle2:
	dwcoord 3, 4, wTilemap
	db $46, $47, $48, $49, $70
	db $01, $01, $01, $01, $70

	db $00 ; end

EOWTilemapPatch_FormCastle3:
	dwcoord 2, 5, wTilemap
	db $54, $55, $56, $57, $58, $59, $70
	db $01, $01, $01, $03, $03, $01, $70

	db $00 ; end

EOWTilemapPatch_FormCastle4:
	dwcoord 2, 6, wTilemap
	db $4a, $4b, $4c, $4d, $4e, $4f, $70
	db $01, $01, $01, $03, $03, $03, $70

	db $00 ; end

EOWTilemapPatch_FormCastle5:
	dwcoord 2, 7, wTilemap
	db $5a, $5b, $5c, $5d, $5e, $5f, $70
	db $03, $03, $01, $03, $03, $03, $70

	db $00 ; end

EOWTilemapPatch_FormCastle6:
	dwcoord 4, 8, wTilemap
	db $3e, $3f, $01, $70
	db $03, $03, $20, $70

	db $00 ; end

EOWTilemapPatch_VulcanoEruption:
	dwcoord 8, 1, wTilemap
	db $c4, $75, $76, $75, $7f, $77, $c4, $70
	db $09, $0d, $0d, $2d, $0d, $0d, $29, $70

	dwcoord 8, 7, wTilemap
	db $20, $21, $22, $22, $22, $21, $20, $70
	db $03, $03, $03, $03, $23, $23, $23, $70

	dwcoord 8, 8, wTilemap
	db $23, $24, $25, $25, $25, $24, $23, $70
	db $03, $03, $03, $03, $23, $23, $23, $70

	dwcoord 8, 9, wTilemap
	db $33, $34, $35, $35, $35, $34, $33, $70
	db $02, $02, $02, $02, $22, $22, $22, $70

	db $00 ; end

OverworldTopBarTilemap:INCBIN "data/bgmaps/overworld/top_bar.tilemap.rle"
OverworldTopBarAttrmap:INCBIN "data/bgmaps/overworld/top_bar.attrmap.rle"

OverworldNorthTilemap:INCBIN "data/bgmaps/overworld/north.tilemap.rle"
OverworldNorthAttrmap:INCBIN "data/bgmaps/overworld/north.attrmap.rle"

OverworldTopBarDayNightTilemap:INCBIN "data/bgmaps/overworld/top_bar_day_night.tilemap.rle"
OverworldTopBarDayNightAttrmap:INCBIN "data/bgmaps/overworld/top_bar_day_night.attrmap.rle"

OverworldWestTilemap:INCBIN "data/bgmaps/overworld/west.tilemap.rle"
OverworldWestAttrmap:INCBIN "data/bgmaps/overworld/west.attrmap.rle"

OverworldSouthTilemap:INCBIN "data/bgmaps/overworld/south.tilemap.rle"
OverworldSouthAttrmap:INCBIN "data/bgmaps/overworld/south.attrmap.rle"

OverworldEastTilemap:INCBIN "data/bgmaps/overworld/east.tilemap.rle"
OverworldEastAttrmap:INCBIN "data/bgmaps/overworld/east.attrmap.rle"

OverworldBottomBarTreasuresTilemap:INCBIN "data/bgmaps/overworld/bottom_bar_treasures.tilemap.rle"
OverworldBottomBarTreasuresAttrmap:INCBIN "data/bgmaps/overworld/bottom_bar_treasures.attrmap.rle"

OverworldBottomBarTimeAttackTilemap:INCBIN "data/bgmaps/overworld/bottom_bar_time_attack.tilemap.rle"
OverworldBottomBarTimeAttackAttrmap:INCBIN "data/bgmaps/overworld/bottom_bar_time_attack.attrmap.rle"

OWLightningFlashPals1:
	rgb 31, 31, 31
	rgb 12, 29,  0
	rgb  9, 12, 12
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 14, 14, 14
	rgb 11,  3,  7
	rgb  0,  0,  0

	rgb 14, 14, 14
	rgb 12, 29,  0
	rgb  0,  2,  2
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 12, 29,  0
	rgb  8,  3,  2
	rgb  0,  2,  2

	rgb 31, 31, 31
	rgb  0,  9,  3
	rgb  3,  0,  3
	rgb  0,  0,  0

	rgb 12, 29,  0
	rgb 14, 14, 14
	rgb 17,  3, 14
	rgb  5,  3,  5

	rgb 31, 31, 31
	rgb 31, 26,  2
	rgb 27, 12,  0
	rgb  7,  5,  3

	rgb 31, 31, 31
	rgb 31, 31, 31
	rgb 14, 14, 14
	rgb  0,  0,  0

OWLightningFlashPals2:
	vc_patch FPA_80_BG_Flash_Palette_0
	IF DEF(_VC)
		rgb 11, 11, 11
        rgb 11, 11, 11
        rgb  0,  0,  0
        rgb  0,  0,  0

        rgb 11, 11, 11
        rgb  6,  6,  7
        rgb  3,  0,  0
        rgb  0,  0,  0

        rgb  6,  6,  7
        rgb 11, 11, 11
        rgb  0,  2,  2
        rgb  0,  0,  0

        rgb 11, 11, 11
        rgb 11, 11, 11
        rgb  4,  0,  1
        rgb  0,  2,  2

        rgb 11, 11, 11
        rgb  0,  0,  0
        rgb  3,  0,  3
        rgb  0,  0,  0

        rgb 11, 11, 11
        rgb  6,  6,  7
        rgb  8,  3,  2
        rgb  0,  0,  0

        rgb 11, 11, 11
        rgb 31, 26,  2
        rgb 27, 12,  0
        rgb  7,  5,  3

        rgb 11, 11, 11
        rgb 11, 11, 11
        rgb 11, 11, 11
        rgb  0,  0,  0
	ELSE
		rgb 31, 31, 31
		rgb 31, 31, 31
		rgb  0,  0,  0
		rgb  0,  0,  0

		rgb 31, 31, 31
		rgb  6,  6,  7
		rgb  3,  0,  0
		rgb  0,  0,  0

		rgb  6,  6,  7
		rgb 31, 31, 31
		rgb  0,  2,  2
		rgb  0,  0,  0

		rgb 14, 14, 14
		rgb 31, 31, 31
		rgb  4,  0,  1
		rgb  0,  2,  2

		rgb 14, 14, 14
		rgb  0,  0,  0
		rgb  3,  0,  3
		rgb  0,  0,  0

		rgb 31, 31, 31
		rgb  6,  6,  7
		rgb  8,  3,  2
		rgb  0,  0,  0

		rgb 31, 31, 31
		rgb 31, 26,  2
		rgb 27, 12,  0
		rgb  7,  5,  3

		rgb 31, 31, 31
		rgb 31, 31, 31
		rgb 14, 14, 14
		rgb  0,  0,  0
	ENDC
	vc_patch_end

PrologueBGPals:
	rgb 31, 31, 31
	rgb  9,  4,  0
	rgb  8, 23, 31
	rgb  0,  3,  0

	rgb 12,  6,  0
	rgb 26, 28, 16
	rgb  0, 16,  6
	rgb  0,  5,  0

	rgb 12,  6,  0
	rgb 25, 14,  0
	rgb  0,  3,  0
	rgb  0,  5,  6

	rgb 13, 25, 31
	rgb  9,  4,  0
	rgb  0, 13, 18
	rgb  0,  5,  6

	rgb  8, 23, 31
	rgb 23,  3, 27
	rgb 12,  1, 14
	rgb  0,  0,  0

	rgb  3, 20, 30
	rgb  0, 21, 10
	rgb  0,  9,  4
	rgb  0,  3,  0

	rgb  0,  0,  0
	rgb 15,  5,  0
	rgb  0,  0,  0
	rgb  7,  3,  0

	rgb  9, 19,  9
	rgb  5, 10,  5
	rgb  2,  4,  2
	rgb  0,  0,  0

PrologueMusicBoxBGPals:
	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb  2, 31, 31
	rgb 31,  0,  0

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 26,  2
	rgb 31,  0,  0

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31,  0,  0
	rgb 14,  0,  0

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb  2, 31, 31
	rgb 25,  8, 31

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 12, 29,  0
	rgb  0,  9,  3

	rgb  0,  5, 31
	rgb 31, 31, 31
	rgb 12, 29,  0
	rgb 17,  3,  0

	rgb  0,  0,  0
	rgb 31,  0,  0
	rgb 12, 29,  0
	rgb  0,  9,  3

	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb  2, 31, 31
	rgb 31,  0,  0

TempleBGPals:
	rgb 11, 12,  7
	rgb  5,  6,  3
	rgb  2,  3,  1
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0,  3,  1
	rgb  0,  2,  1
	rgb  0,  0,  0

	rgb  0, 12, 12
	rgb  0,  7,  7
	rgb  0,  4,  4
	rgb  0,  0,  0

	rgb 16, 13, 22
	rgb 12,  6, 16
	rgb  4,  0, 12
	rgb  0,  0,  0

	rgb 15, 12, 20
	rgb  9,  6, 16
	rgb  0,  0, 12
	rgb  0,  0,  0

	rgb 10, 13, 21
	rgb  4,  6, 16
	rgb  0,  0, 12
	rgb  0,  0,  0

	rgb 31, 19, 23
	rgb 21,  8, 17
	rgb 12,  2,  6
	rgb  0,  0,  0

	rgb 27, 23, 11
	rgb 22, 13,  2
	rgb 13,  6,  1
	rgb  5,  2,  0

PrologueOBPals:
	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 15, 10
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 13, 18, 30
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 27,  2
	rgb 27,  0,  2
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 27,  0,  2
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb  2, 12, 31
	rgb  0, 21,  0

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 27,  1
	rgb 18,  8,  0

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 27,  2
	rgb  0, 15, 21

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 20,  2, 31
	rgb  0,  0,  0

PrologueCaveWarioPal:
	rgb  0,  0,  0
	rgb 28, 31, 26
	rgb 31, 11,  8
	rgb  7,  2, 20

SceneWarioPal::
	rgb  0,  0,  0
	rgb 31, 31, 31
	rgb 31, 15, 10
	rgb  3,  3,  3

EpilogueBGPals:
	rgb 15, 28, 31
	rgb  5, 27, 19
	rgb  0, 17, 22
	rgb  5, 10, 10

	rgb 31, 31, 31
	rgb 25, 14,  0
	rgb 12,  6,  0
	rgb  0,  0,  0

	rgb 12,  6,  0
	rgb 26, 28, 16
	rgb  0, 16,  6
	rgb  0,  4,  0

	rgb  5, 10, 10
	rgb 31, 29, 12
	rgb  0, 23, 12
	rgb  1,  6,  6

	rgb 15, 28, 31
	rgb 31, 28, 11
	rgb 23, 14,  0
	rgb  7,  6,  1

	rgb  5, 10, 10
	rgb 31, 23, 28
	rgb 23,  8, 18
	rgb  9,  2,  1

	rgb 15, 28, 31
	rgb  3, 22, 31
	rgb  3,  8,  8
	rgb  0,  4,  6

	rgb 15, 28, 31
	rgb 31, 31,  7
	rgb 31, 17,  9
	rgb  5,  5,  0

EpilogueOBPals:
	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 15, 10
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb  8, 23, 31
	rgb  0,  0,  0

	rgb  0, 22, 16
	rgb 31, 15, 10
	rgb 30, 31, 16
	rgb  9,  0,  0

	rgb  0, 22, 16
	rgb 31, 31,  7
	rgb  0, 21, 10
	rgb  0,  2,  0

	rgb  0, 22, 16
	rgb 31, 28, 11
	rgb 24, 14,  0
	rgb  5,  4,  0

	rgb  0, 22, 16
	rgb 31, 23, 28
	rgb 23,  5, 18
	rgb  7,  0,  0

	rgb  0, 22, 16
	rgb 31, 19, 10
	rgb 16,  5, 23
	rgb  1,  2,  6

	rgb  0, 22, 16
	rgb 31, 31, 31
	rgb 31, 30,  0
	rgb  0,  0,  0
