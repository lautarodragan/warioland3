Prologue_Delay:
	ld a, [wOWStepCounter]
	cp c
	ret c
;	fallthrough

Prologue_Next:
	ld hl, wOWStepCounter
	xor a
	ld [hld], a
	inc [hl] ; wOWStep
	ret

Prologue_Finish:
	ld hl, wSubState
	inc [hl]
	ret

Prologue:
	call .PlayCutscene
	call UpdatePrologueSceneObjects
	call UpdateSceneWario
	call UpdatePrologueSceneObjs8And9
	ret

.PlayCutscene:
	ld a, [wOWStep]
	jumptable

	dw Prologue_Next
	dw .Wait60
	dw .SetFadeInFromBlack
	dw PrologueFade
	dw Prologue_WarioFallFromPlane
	dw .ScrollRight40Pixels
	dw Prologue_WarioWalkToCaveEntrance
	dw .SetFadeToBlack
	dw PrologueFade
	dw .PrepareCaveScene1
	dw PrologueFade
	dw Prologue_WarioEnterCave
	dw .ShowMusicBoxCloseUp
	dw Prologue_MusicBoxSparkles
	dw .PrepareCaveScene2
	dw Prologue_WarioSuckedIntoMusicBox
	dw .SetFadeToBlack
	dw PrologueFade
	dw .LoadTempleTilemap
	dw .LoadTempleAttrmap
	dw .LoadTempleGfx
	dw .PrepareTempleScene
	dw .FadeEvery8Frames
	dw Prologue_WarioWakeUp
	dw .SetFadeToTemplePals
	dw .FadeInTemple
	dw Prologue_WarioJumpAndBow
	dw InitTextPrinting
	dw PrintTextPageWithHeader
	dw .Wait30
	dw LoadCurTextPageBufferPage
	dw WaitAButtonAndClearTextbox
	dw PrintTextPageWithoutHeader
	dw .NextTextPageOrEnd
	dw .WarioNodOnce
	dw .ShowArrowAfterLookBack
	dw .WaitAButton
	dw Prologue_WarioLeaveTemple
	dw Prologue_Finish

.Wait60:
	ld c, 60
	jp Prologue_Delay

.SetFadeInFromBlack:
	ld a, $01
;	fallthrough

.set_fade_type:
	ld [w2d880], a
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	jp Prologue_Next

.ScrollRight40Pixels:
	ld hl, wSCX
	inc [hl]
	ld a, [hl]
	cp 40
	ret nz
	jp Prologue_Next

.SetFadeToBlack:
	ld a, $00
	jr .set_fade_type

.PrepareCaveScene1:
	; set scroll to (0, 112)
	ld a, 112
	ld [wSCY], a
	xor a
	ld [wSCX], a

	; set Wario's coordinates to (240, 208)
	ld hl, wSceneWarioYCoord
	ld a, 208
	ld [hli], a ; y
	ld a, 240
	ld [hl], a ; x
	xor a ; SCENEWARIO_NONE
	call SetSceneWarioState

	call .PlaceMusicBox

	; set Obj1 and Obj2's coordinates to (120, 187)
	ld hl, wSceneObj1
	ld a, 187
	ld [hli], a ; y
	ld [wSceneObj2YCoord], a
	ld a, 120
	ld [hl], a ; x
	ld [wSceneObj2XCoord], a

	xor a
	ld [wMusicBoxSparkleStep], a
	ld hl, wSceneObj1State
	call SetSceneObjState

	play_music2 MUSIC_MUSIC_BOX_CAVE

	ld a, $06
	jr .set_fade_type

.PlaceMusicBox:
	; set Obj3's coordinates to (120, 195)
	ld hl, wSceneObj3YCoord
	ld a, 195
	ld [hli], a
	ld a, 120
	ld [hl], a

	ld hl, wSceneObj3State
	ld a, $09
	call SetSceneObjState
	ret

.ShowMusicBoxCloseUp:
	; set scroll to (0, 0)
	xor a
	ld [wSCY], a
	ld [wSCX], a

	; setting BG map to $9c00 shows Music Box scene
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a

	; set Obj8's position to (80, 80)
	ld a, 80
	ld hl, wSceneObj8
	ld [hli], a
	ld [hl], a
	ld a, $0d
	ld hl, wSceneObj8State
	call SetSceneObjState

	; deactivate Obj3
	xor a
	ld hl, wSceneObj3State
	call SetSceneObjState

	ld hl, PrologueOBPals
	ld de, wTempOBPals
	ld c, 1 palettes
	ld b, BANK(PrologueOBPals)
	call CopyFarBytes
	ld hl, PrologueMusicBoxBGPals
	;	fallthrough

.load_pals:
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(PrologueMusicBoxBGPals)
	call CopyFarBytes

	ld de, PalConfig_BGFromTempPals1
	call SetPalConfig1FromDE
	ld de, PalConfig_OB0FromTempOBPals
	call SetPalConfig2FromDE
	jp Prologue_Next

.PrepareCaveScene2:
	; set scroll to (0, 112)
	ld a, 112
	ld [wSCY], a
	xor a
	ld [wSCX], a

	; setting BG map to $9800 shows cave scene
	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a

	ld a, SCENEWARIO_HOLD_MUSIC_BOX
	call SetSceneWarioState
	call .PlaceMusicBox

	ld a, $0e
	ld hl, wSceneObj1State
	call SetSceneObjState

	; deactivate Obj8
	xor a
	ld hl, wSceneObj8State
	call SetSceneObjState

	ld hl, wTempPals2
	ld de, wTempOBPals
	ld b, 1 palettes
	call CopyHLToDE
	ld hl, PrologueBGPals
	jr .load_pals

.LoadTempleTilemap:
	xor a
	ld [wHDMADestVRAMBank], a
	ld de, TempleTilemap
	ld b, HIGH(v0BGMap0) - $80
	ld c, 18 dma_rows
.configure_hdma_transfer:
	ld a, BANK(TempleTilemap)
	ld [wHDMABank], a
	ld hl, wHDMA
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a
	ld [hli], a
	ld a, c
	ld [hl], a
	jp Prologue_Next

.LoadTempleAttrmap:
	ld a, BANK("VRAM1")
	ld [wHDMADestVRAMBank], a
	ld de, TempleAttrmap
	ld b, HIGH(v0BGMap0) - $80
	ld c, 18 dma_rows
	jr .configure_hdma_transfer

.LoadTempleGfx:
	xor a
	ld [wHDMADestVRAMBank], a
	ld de, TempleGfx
	ld b, HIGH(v0Tiles2) - $80
	ld c, $80 dma_tiles
	jr .configure_hdma_transfer

.PrepareTempleScene:
	; set scroll to (0, 0)
	xor a
	ld [wSCY], a
	ld [wSCX], a

	ld a, LCDC_BG_MAP
	ld [wLCDCFlagsToFlip], a

	; place sleeping Wario at (64, 96)
	ld hl, wSceneWarioYCoord
	ld a, 96
	ld [hli], a
	ld a, 64
	ld [hl], a
	ld a, SCENEWARIO_SLEEP
	call SetSceneWarioState
	play_sfx SFX_SNORE
	ld a, $05
	jp .set_fade_type

.FadeEvery8Frames:
	ld a, [wOWStepCounter]
	and $07
	ret nz
	jp PrologueFade

.SetFadeToTemplePals:
	ld a, $02
	jp .set_fade_type

.FadeInTemple:
	ld c, $07
	ld a, [wPalConfig1TotalSteps]
	cp $08
	jr c, .fade_on_interval
	ld c, $01
.fade_on_interval
	ld a, [wOWStepCounter]
	and c
	ret nz
	jp PrologueFade

.Wait30:
	ld c, 30
	jp Prologue_Delay

.NextTextPageOrEnd:
	call NextTextPageOrEnd
	call .LookAroundOnPage2
	ret

.LookAroundOnPage2:
	ld a, [wCurTextBufferPage]
	cp $02
	jr z, .look_around
	ret
.look_around
	ld a, SCENEWARIO_LOOK_AROUND
	call SetSceneWarioState
	ret

.WarioNodOnce:
	ld a, SCENEWARIO_NOD_ONCE
	call SetSceneWarioState
	jp Prologue_Next

.ShowArrowAfterLookBack:
	ld a, [wSceneWarioState]
	cp SCENEWARIO_LOOK_BACK
	ret nz
	ld hl, wSceneObj1State
	ld a, $01
	call SetSceneObjState
	jp Prologue_Next

.WaitAButton:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	ret z
	ld hl, wSceneObj1State
	xor a
	call SetSceneObjState
	call ClearTextbox
	jp Prologue_Next

AdvancePrologueStepOnWarioState:
	ld a, [wSceneWarioState]
	cp b
	ret nz
	jr AdvancePrologueStep

WaitPrologueStep:
	ld a, [wSceneStepCounter]
	cp c
	ret c
;	fallthrough

AdvancePrologueStep:
	ld hl, wSceneStepCounter
	xor a
	ld [hld], a
	inc [hl] ; wSceneStep
	ret

ResetPrologueStepAndNext:
	xor a
	ld hl, wSceneStep
	ld [hli], a
	ld [hl], a ; wSceneStepCounter
	jp Prologue_Next

Prologue_MusicBoxSparkles:
	ld hl, wSceneStepCounter
	inc [hl]
	dec l
	ld a, [hl] ; wSceneStep
	jumptable

	dw .Wait20
	dw .Sparkle1
	dw .Wait10
	dw .Sparkle2
	dw .Wait90
	dw ResetPrologueStepAndNext

.Wait20:
	ld c, 20
	jr WaitPrologueStep

.Sparkle1:
	; set Obj4's position to (56, 56)
	ld hl, wSceneObj4
	ld a, 56
	ld [hli], a ; y
	ld a, 56
	ld [hl], a ; x
	ld a, $0e
	ld hl, wSceneObj4State
	call SetSceneObjState
	play_sfx SFX_LEVEL_STAR
	jp AdvancePrologueStep

.Wait10:
	ld c, 10
	jr WaitPrologueStep

.Sparkle2:
	; set Obj5's position to (120, 48)
	ld hl, wSceneObj5
	ld a, 48
	ld [hli], a ; y
	ld a, 120
	ld [hl], a ; x
	ld a, $0e
	ld hl, wSceneObj5State
	call SetSceneObjState
	jp AdvancePrologueStep

.Wait90:
	ld c, 90
	jr WaitPrologueStep

Prologue_WarioEnterCave:
	call UpdateMusicBoxSparkle
	ld hl, wSceneStepCounter
	inc [hl]
	dec l
	ld a, [hl] ; wSceneStep
	jumptable

	dw .WarioWalkRight
	dw .WarioMoveRightTo64
	dw .WaitSparkle
	dw .ShowEmote
	dw .WaitEmoteAnimation
	dw .Wait26
	dw .WarioWalkRight
	dw .WarioMoveRightTo102
	dw .StartSparkleLoop
	dw .WarioLookMusicBox
	dw .WarioHoldMusicBox
	dw .Wait60
	dw ResetPrologueStepAndNext

.WarioWalkRight:
	ld a, SCENEWARIO_WALK_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

.WarioMoveRightTo64:
	call ApplySceneWarioMovementRight
	cp 50
	jr z, .start_sparkle
	cp 64
	ret nz
	ld [hl], a
.wario_idle_right
	ld a, SCENEWARIO_IDLE_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

.start_sparkle:
	ld a, $01
	ld [wMusicBoxSparkleStep], a
	ret

.WaitSparkle:
	ld a, [wMusicBoxSparkleStep]
	and a
	ret nz
	jp AdvancePrologueStep

.ShowEmote:
	ld a, [wSceneStepCounter]
	cp $16
	ret c
	ld hl, wCurSceneObj
	ld a, [wSceneWarioYCoord]
	sub 24
	ld [hli], a ; y
	ld a, [wSceneWarioXCoord]
	add 16
	ld [hl], a ; x
	ld a, $11
	ld hl, wCurSceneObjState
	call SetSceneObjState
	play_sfx SFX_EMOTE
	jp AdvancePrologueStep

.WaitEmoteAnimation:
	ld a, [wCurSceneObjState]
	and a
	ret nz
	jp AdvancePrologueStep

.Wait26:
	ld c, 26
	jp WaitPrologueStep

.WarioMoveRightTo102:
	call ApplySceneWarioMovementRight
	cp 102
	ret nz
	ld [hl], a
	jr .wario_idle_right

.StartSparkleLoop:
	ld a, [wSceneStepCounter]
	cp $14
	jr z, .loop_sparkle
	cp $3c
	ret c
	jp AdvancePrologueStep
.loop_sparkle
	ld a, $03
	ld [wMusicBoxSparkleStep], a
	ret

.WarioLookMusicBox:
	ld a, SCENEWARIO_LOOK_MUSIC_BOX
	call SetSceneWarioState
	jp AdvancePrologueStep

.WarioHoldMusicBox:
	ld b, SCENEWARIO_HOLD_MUSIC_BOX
	jp AdvancePrologueStepOnWarioState

.Wait60:
	ld c, 60
	jp WaitPrologueStep

UpdateMusicBoxSparkle:
	ld a, [wMusicBoxSparkleStep]
	jumptable
	dw MusicBoxSparkle_None
	dw MusicBoxSparkle_Show
	dw MusicBoxSparkle_WaitThenStop
	dw MusicBoxSparkle_Show
	dw MusicBoxSparkle_Wait
	dw MusicBoxSparkle_Repeat

MusicBoxSparkle_Show:
	ld a, $0e
	ld hl, wSceneObj1State
	call SetSceneObjState
MusicBoxSparkle_Next:
	ld hl, wMusicBoxSparkleCounter
	xor a
	ld [hld], a
	inc [hl] ; wMusicBoxSparkleStep
MusicBoxSparkle_None:
	ret

MusicBoxSparkle_Wait:
	ld a, [wSceneObj1State]
	and a
	ret nz
	jr MusicBoxSparkle_Next

MusicBoxSparkle_WaitThenStop:
	ld a, [wSceneObj1State]
	and a
	ret nz
	ld hl, wMusicBoxSparkleStep
	ld [hli], a
	ld [hl], a
	ret

MusicBoxSparkle_Repeat:
	ld hl, wMusicBoxSparkleCounter
	inc [hl]
	ld a, [hl]
	cp $14
	ret c
	ld hl, wMusicBoxSparkleStep
	dec [hl]
	dec [hl]
	ret

Prologue_WarioSuckedIntoMusicBox:
	call CycleSceneWarioPals
	ld hl, wSceneStepCounter
	inc [hl]
	dec l
	ld a, [hl] ; wSceneStep
	jumptable
	dw .WaitSparkle
	dw .StopMusic
	dw .Wait30
	dw .WarioPickupMusicBox
	dw .SetMusicBoxState0a
	dw .WarioShortHopBack
	dw .MusicBoxRise
	dw .Wait120_1
	dw .HideMusicBoxGlow
	dw .SparkleOnWario
	dw .WaitSparkleStopPalCycle
	dw .StartSuckIn
	dw .WaitSuckInRemoveWario
	dw .Wait60
	dw .MoveIntoMusicBox
	dw .ResetMusicBox
	dw .ShakeMusicBox
	dw .Wait40
	dw .DropMusicBox
	dw .BounceMusicBox
	dw .Wait120
	dw ResetPrologueStepAndNext

.WaitSparkle:
	ld a, [wSceneObj1State]
	and a
	ret nz
	jp AdvancePrologueStep

.StopMusic:
	ld a, [wSceneStepCounter]
	cp $14
	ret c
	stop_music2
	jp AdvancePrologueStep

.Wait30:
	ld c, 30
	jp WaitPrologueStep

.WarioPickupMusicBox:
	ld a, SCENEWARIO_PICKUP_MUSIC_BOX
	call SetSceneWarioState
	jp AdvancePrologueStep

.SetMusicBoxState0a:
	ld a, [wSceneStepCounter]
	cp $08
	ret nc
	ld hl, wSceneObj3State
	ld a, $0a
	call SetSceneObjState
	jp AdvancePrologueStep

.WarioShortHopBack:
	ld hl, wSceneWario
	ld a, [wSceneStepCounter]
	cp $01
	jr z, .hop_up
	cp $05
	jr z, .hop_down
	cp $30
	ret c
	jp AdvancePrologueStep
.hop_up
	dec [hl] ; y
	inc l
	dec [hl] ; x
	ret
.hop_down
	inc [hl] ; y
	inc l
	dec [hl] ; x
	ret

.MusicBoxRise:
	ld a, [wSceneStepCounter]
	and $07
	ret nz
	ld hl, wSceneObj3YCoord
	dec [hl]
	ld a, [hl]
	ld b, a
	sub 8
	ld [wSceneObj2YCoord], a
	ld a, b
	cp 180
	jr z, .at_y_180
	cp 165
	ret nz
	jp AdvancePrologueStep
.at_y_180
	ld hl, wSceneObj2State
	ld a, $0c
	call SetSceneObjState
	ld a, $01
	ld [w2d150], a
	ret

.Wait120_1:
	ld c, 120
	jp WaitPrologueStep

.HideMusicBoxGlow:
	xor a
	ld hl, wSceneObj2State
	call SetSceneObjState
	jp AdvancePrologueStep

.SparkleOnWario:
	; place obj at (Wario_x, Wario_y - 8)
	ld hl, wCurSceneObj
	ld a, [wSceneWarioYCoord]
	sub 8
	ld [hli], a
	ld a, [wSceneWarioXCoord]
	ld [hl], a
	ld a, $0e
	ld hl, wCurSceneObjState
	call SetSceneObjState
	jp AdvancePrologueStep

.WaitSparkleStopPalCycle:
	ld a, [wCurSceneObjState]
	and a
	ret nz
	ld a, $80
	ld [w2d150], a
	jp AdvancePrologueStep

.StartSuckIn:
	ld hl, wCurSceneObj
	ld a, [wSceneWarioYCoord]
	sub 16
	ld [hli], a
	ld a, [wSceneWarioXCoord]
	add 2
	ld [hl], a
	ld a, $15
	ld hl, wCurSceneObjState
	call SetSceneObjState

	; sets OB palette 0 to all (28, 28, 28)
	ld hl, wTempOBPals
	ld b, PAL_COLORS
.loop_set_pal
	ld a, LOW(palred 28 + palgreen 28 + palblue 28)
	ld [hli], a
	ld a, HIGH(palred 28 + palgreen 28 + palblue 28)
	ld [hli], a
	dec b
	jr nz, .loop_set_pal

	ld de, PalConfig_OB0FromTempOBPals
	call SetPalConfig2FromDE
	jp AdvancePrologueStep

.WaitSuckInRemoveWario:
	ld a, [wCurSceneObjState]
	cp $16
	ret nz
	xor a ; SCENEWARIO_NONE
	call SetSceneWarioState
	jp AdvancePrologueStep

.Wait60:
	ld c, 60
	jp WaitPrologueStep

.MoveIntoMusicBox:
	ld hl, wCurSceneObj
	ld a, [hli] ; y
	cp 181
	jr c, .above_181
	ld a, [wSceneStepCounter]
	ld b, a
	and $03
	ret nz
	bit 2, b
	jr z, .move_up
	inc [hl] ; x
.move_up
	dec l
	dec [hl] ; y
	ret

.above_181
	inc [hl] ; x
	dec l
	dec [hl] ; y
	dec [hl]
	ld a, [hl]
	cp 168
	jr z, .at_y_168
	cp 156
	ret nz
	jp AdvancePrologueStep
.at_y_168
	ld a, $17
	ld hl, wCurSceneObjState
	call SetSceneObjState
	ret

.ResetMusicBox:
	ld a, $09
	ld hl, wSceneObj3State
	call SetSceneObjState
	xor a
	ld hl, wCurSceneObjState
	call SetSceneObjState
	jp AdvancePrologueStep

.ShakeMusicBox:
	ld a, [wSceneStepCounter]
	srl a
	ret c
	ld hl, wSceneObj3XCoord
	cp $01
	jr z, .IncreaseX
	cp $02
	jr z, .DecreaseX
	call .IncreaseX
	jp AdvancePrologueStep
.IncreaseX
	inc [hl]
	ret
.DecreaseX
	dec [hl]
	dec [hl]
	ret

.Wait40:
	ld c, 40
	jp WaitPrologueStep

.DropMusicBox:
	ld hl, wSceneStepCounter
	call .get_fall_speed
	ld hl, wSceneObj3YCoord
	add [hl]
	ld [hl], a
	cp 195
	ret c
	ld a, 195
	ld [hl], a
	call .PlayBumpSFX
	jp AdvancePrologueStep

.get_fall_speed:
	ld a, [hl]
	cp $14
	jr c, .got_fall_index
	ld a, $10
	ld [hl], a
.got_fall_index
	ld e, a
	ld d, $00
	ld hl, .data_ae4d1
	add hl, de
	ld a, [hl]
	ret

.data_ae4d1
	db 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 2, 2, 2

.BounceMusicBox:
	ld hl, wSceneStepCounter
	call .get_bounce_offset
	and a
	ret z
	ld hl, wSceneObj3YCoord
	add [hl]
	ld [hl], a
	cp 195
	call z, .PlayBumpSFX
	ld a, $80
	cp b
	ret nz
	jp AdvancePrologueStep

.get_bounce_offset:
	ld a, [hl]
	ld e, a
	ld d, $00
	ld hl, .data_ae509
	add hl, de
	ld a, [hli]
	ld b, [hl]
	ret
.data_ae509
	db 0, -2, 0, 0, 1, 0, 1, 0, -1, 0, 1, $80

.PlayBumpSFX:
	play_sfx SFX_BUMP
	ret

.Wait120:
	ld c, 120
	jp WaitPrologueStep

CycleSceneWarioPals:
	ld hl, w2d150
	ld a, [hl]
	and a
	ret z
	cp $80
	jr z, .stop
	ld hl, w2d151
	inc [hl]
	ld a, [hl]
	cp $02
	ret c
	xor a
	ld [hld], a ; w2d151
	ld c, [hl] ; w2d150
	inc [hl]
	ld a, [hl]
	cp $09
	jr c, .set_attributes
	ld [hl], $01
.set_attributes
	ld hl, .data_ae54b
	ld b, $00
	add hl, bc
	ld a, [hl]
	ld [wSceneWarioAttributes], a
	ret

.data_ae54b
	db $0
	db $0
	db $1
	db $2
	db $3
	db $4
	db $5
	db $6
	db $7

.stop
	xor a
	ld [wSceneWarioAttributes], a
	ld [w2d150], a
	ret

Prologue_WarioWakeUp:
	ld hl, wSceneStepCounter
	inc [hl]
	ld c, l
	ld b, h
	dec l
	ld a, [hl] ; wSceneStep
	jumptable
	dw PrologueWakeUp_WaitSleepAnim
	dw PrologueWakeUp_WakeUp
	dw PrologueWakeUp_PlayGrabSFX
	dw PrologueWakeUp_WaitSitIdle
	dw PrologueWakeUp_ShowCurObjState14
	dw PrologueWakeUp_SitStill
	dw PrologueWakeUp_StandUp
	dw PrologueWakeUp_Wait60
	dw PrologueWakeUp_WalkRight
	dw PrologueWakeUp_WalkRightTo80
	dw PrologueWakeUp_TurnBack
	dw PrologueWakeUp_WaitLookBack
	dw PrologueWakeUp_PlayTempleMusic
	dw PrologueWakeUp_LookAround
	dw PrologueWakeUp_Wait30
	dw ResetPrologueStepAndNext

PrologueWakeUp_WaitSleepAnim:
	ld a, [wSceneWarioAnimFinished]
	inc a
	ret nz
	jp AdvancePrologueStep

PrologueWakeUp_WakeUp:
	ld a, [bc]
	cp $4b
	ret c
	ld a, SCENEWARIO_WAKE_UP
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueWakeUp_PlayGrabSFX:
	ld a, [bc]
	cp $14
	ret c
	play_sfx SFX_GRAB
	jp AdvancePrologueStep

PrologueWakeUp_WaitSitIdle:
	ld a, [wSceneWarioState]
	cp SCENEWARIO_SIT_IDLE
	ret nz
	jp AdvancePrologueStep

PrologueWakeUp_ShowCurObjState14:
	ld a, [bc]
	cp $05
	ret c
	ld a, [wSceneWarioYCoord]
	sub $01
	ld [wCurSceneObjYCoord], a
	ld a, [wSceneWarioXCoord]
	add $09
	ld [wCurSceneObjXCoord], a
	ld a, $14
	ld hl, wCurSceneObjState
	call SetSceneObjState
	jp AdvancePrologueStep

PrologueWakeUp_SitStill:
	ld a, [bc]
	cp $8c
	ret c
	ld a, SCENEWARIO_SIT_STILL
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueWakeUp_StandUp:
	ld a, [bc]
	cp $10
	ret c
	ld a, SCENEWARIO_IDLE_RIGHT
	call SetSceneWarioState
	play_sfx SFX_STEP
	jp AdvancePrologueStep

PrologueWakeUp_Wait60:
	ld c, 60
	jp WaitPrologueStep

PrologueWakeUp_WalkRight:
	ld a, SCENEWARIO_WALK_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueWakeUp_WalkRightTo80:
	call ApplySceneWarioMovementRight
	cp $50
	ret nz
	ld [hl], a
	ld a, SCENEWARIO_IDLE_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueWakeUp_TurnBack:
	ld a, [bc]
	cp $1e
	ret c
	ld a, SCENEWARIO_TURN_BACK_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueWakeUp_WaitLookBack:
	ld b, SCENEWARIO_LOOK_BACK
	jp AdvancePrologueStepOnWarioState

PrologueWakeUp_PlayTempleMusic:
	ld a, [bc]
	cp $1e
	ret c
	play_music2 MUSIC_THE_TEMPLE
	jp AdvancePrologueStep

PrologueWakeUp_LookAround:
	ld a, [bc]
	cp $1e
	ret c
	ld a, SCENEWARIO_LOOK_AROUND
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueWakeUp_Wait30:
	ld c, 30
	jp WaitPrologueStep

Prologue_WarioJumpAndBow:
	ld hl, wSceneStepCounter
	inc [hl]
	ld c, l
	ld b, h
	dec l
	ld a, [hl] ; wSceneStep
	jumptable
	dw PrologueBow_WaitLookForward
	dw PrologueBow_JumpAndBow
	dw PrologueBow_WaitLookBack
	dw ResetPrologueStepAndNext

PrologueBow_WaitLookForward:
	ld b, SCENEWARIO_LOOK_FORWARD
	jp AdvancePrologueStepOnWarioState

PrologueBow_JumpAndBow:
	ld a, SCENEWARIO_JUMP_AND_BOW
	call SetSceneWarioState
	xor a
	ld [wSceneWarioUnk7], a
	jp AdvancePrologueStep

PrologueBow_WaitLookBack:
	ld b, SCENEWARIO_LOOK_BACK
	jp AdvancePrologueStepOnWarioState

Prologue_WarioLeaveTemple:
	ld hl, wSceneStepCounter
	inc [hl]
	dec l
	ld a, [hl] ; wSceneStep
	jumptable
	dw PrologueLeave_SnapFingers
	dw PrologueLeave_SnapSFX
	dw PrologueLeave_WaitLookBack
	dw PrologueLeave_Wait30
	dw PrologueLeave_TurnLeft
	dw PrologueLeave_WaitIdleLeft
	dw PrologueLeave_WalkLeft
	dw PrologueLeave_WalkOffScreen
	dw PrologueLeave_FinalWait30
	dw ResetPrologueStepAndNext

PrologueLeave_SnapFingers:
	ld a, SCENEWARIO_SNAP_FINGERS
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueLeave_SnapSFX:
	ld a, [wSceneWarioFrame]
	cp $0f
	ret nz
	play_sfx SFX_EMOTE
	jp AdvancePrologueStep

PrologueLeave_WaitLookBack:
	ld b, SCENEWARIO_LOOK_BACK
	jp AdvancePrologueStepOnWarioState

PrologueLeave_Wait30:
	ld c, 30
	jp WaitPrologueStep

PrologueLeave_TurnLeft:
	ld a, SCENEWARIO_TURN_BACK_TO_LEFT
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueLeave_WaitIdleLeft:
	ld b, SCENEWARIO_IDLE_LEFT
	jp AdvancePrologueStepOnWarioState

PrologueLeave_WalkLeft:
	ld a, [wSceneStepCounter]
	cp $04
	ret c
	ld a, SCENEWARIO_WALK_LEFT
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueLeave_WalkOffScreen:
	call ApplySceneWarioMovementLeft
	cp $f0
	ret nz
	xor a ; SCENEWARIO_NONE
	call SetSceneWarioState
	jp AdvancePrologueStep

PrologueLeave_FinalWait30:
	ld c, 30
	jp WaitPrologueStep

Prologue_WarioFallFromPlane:
	call UpdatePlaneParts
	ld hl, wSceneStepCounter
	inc [hl]
	dec l
	ld a, [hl] ; wSceneStep
	jumptable
	dw .Wait74
	dw .ShowWarioFall
	dw .WarioBounce
	dw .Wait60
	dw .WarioTurnRight
	dw .WarioLookBack
	dw .Wait38
	dw .WarioLookAround
	dw .WarioIdleRight
	dw .Wait46
	dw ResetPrologueStepAndNext

.Wait74:
	ld c, 74
	jp WaitPrologueStep

.ShowWarioFall:
	; set Wario's coordinates to (240, 60)
	ld hl, wSceneWarioYCoord
	ld a, 60
	ld [hli], a
	ld a, 240
	ld [hl], a

	ld a, SCENEWARIO_ON_FIRE
	call SetSceneWarioState

	play_sfx SFX_THROW

	xor a
	ld [w2d894], a
	ld [wSceneSubStep], a
	jp AdvancePrologueStep

.WarioBounce:
	call .DoBounce
	ld a, [wSceneSubStep]
	cp $80
	ret nz
	jp AdvancePrologueStep

.DoBounce:
	ld a, [w2d894]
	and a
	jr z, .sub_steps
	ld a, [wSceneStepCounter]
	and $03
	jr z, .sub_steps
	ld de, PrologueWarioFallMovement
	ld hl, wSceneWario
	call ApplyOWMovement
	jr nz, .sub_steps
	xor a
	ld [w2d894], a
.sub_steps
	ld a, [wSceneSubStep]
	and a
	jr z, .sub_start
	dec a
	jr z, .land_stunned
	dec a
	jr z, .sub_wait4
	dec a
	jr z, .tumble_end
	dec a
	jr z, .crash_land_with_bump
	dec a
	jr z, .sub_wait4
	dec a
	jr z, .crash_land
	dec a
	jr z, .wait_stunned
	dec a
	jr z, .get_up
	dec a
	jp z, .sub_done
	ret

.sub_start
	ld a, $01
	ld [w2d894], a
.next_sub_step
	ld hl, wSceneSubStep
	inc [hl]
	xor a
	ld [wSceneSubStepCounter], a
	ret

.land_stunned
	ld a, [wSceneWarioYCoord]
	cp 96
	ret nz
	ld a, SCENEWARIO_STUNNED_RIGHT
	call SetSceneWarioState
	call .PlayBumpSfx
.place_bump_obj
	ld hl, wCurSceneObj
	ld a, [wSceneWarioYCoord]
	ld [hli], a
	ld a, [wSceneWarioXCoord]
	ld [hl], a
	ld a, $10
	ld hl, wCurSceneObjState
	call SetSceneObjState
	jr .next_sub_step

.sub_wait4
	ld hl, wSceneSubStepCounter
	inc [hl]
	ld a, [hl]
	cp $04
	ret c
	jr .next_sub_step

.tumble_end
	ld a, SCENEWARIO_CRASH_TUMBLE_END
	call SetSceneWarioState
	jr .next_sub_step

.crash_land_with_bump
	ld a, [wSceneWarioYCoord]
	cp 96
	ret nz
	ld a, SCENEWARIO_CRASH_LAND_RIGHT
	call SetSceneWarioState
	call .PlayBumpSfx
	jr .place_bump_obj

.crash_land
	ld a, [wSceneWarioYCoord]
	cp 96
	ret nz
	ld a, SCENEWARIO_CRASH_LAND_RIGHT
	call SetSceneWarioState
	call .PlayBumpSfx
	jr .next_sub_step

.wait_stunned
	ld a, [wSceneWarioState]
	cp SCENEWARIO_STUNNED_RIGHT
	ret nz
	ld hl, wSceneSubStep
	inc [hl]
	xor a
	ld [wSceneSubStepCounter], a
	ret

.get_up
	ld hl, wSceneSubStepCounter
	inc [hl]
	ld a, [hl]
	cp $3e
	ret c
	ld a, SCENEWARIO_IDLE_RIGHT
	call SetSceneWarioState
	play_sfx SFX_STEP
	ld hl, wSceneSubStep
	inc [hl]
	xor a
	ld [wSceneSubStepCounter], a
	ret

.sub_done
	ld a, $80
	ld [wSceneSubStep], a
	ret

.PlayBumpSfx:
	play_sfx SFX_BUMP
	ret

.Wait60:
	ld c, 60
	jp WaitPrologueStep

.WarioTurnRight:
	ld a, SCENEWARIO_TURN_BACK_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

.WarioLookBack:
	ld b, SCENEWARIO_LOOK_BACK
	jp AdvancePrologueStepOnWarioState

.Wait38:
	ld c, 38
	jp WaitPrologueStep

.WarioLookAround:
	ld a, SCENEWARIO_LOOK_AROUND_THEN_TURN
	call SetSceneWarioState
	jp AdvancePrologueStep

.WarioIdleRight:
	ld b, SCENEWARIO_IDLE_RIGHT
	jp AdvancePrologueStepOnWarioState

.Wait46:
	ld c, 46
	jp WaitPrologueStep

Prologue_WarioWalkToCaveEntrance:
	ld hl, wSceneStepCounter
	inc [hl]
	dec l
	ld a, [hl]
	jumptable
	dw .Wait60_1
	dw .WarioWalkRight
	dw .WarioMoveRightTo120
	dw .Wait60_2
	dw .WarioLookUp
	dw .WarioIdleRight
	dw .ShowEmote
	dw .WaitEmoteAnimation
	dw .Wait40_1
	dw .WarioWalkRight
	dw .WarioMoveRightTo208
	dw .Wait40_2
	dw ResetPrologueStepAndNext

.Wait60_1:
	ld c, 60
	jp WaitPrologueStep

.WarioMoveRightTo120:
	call ApplySceneWarioMovementRight
	cp 120
	ret nz ; if != 120 keep walking
	ld [hl], a
	ld a, SCENEWARIO_IDLE_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

.Wait60_2:
	ld c, 60
	jp WaitPrologueStep

.WarioLookUp:
	ld a, SCENEWARIO_LOOK_UP
	call SetSceneWarioState
	jp AdvancePrologueStep

.WarioIdleRight:
	ld b, SCENEWARIO_IDLE_RIGHT
	jp AdvancePrologueStepOnWarioState

.ShowEmote:
	; place emote on position (Wario_x + 16, Wario_y - 24)
	ld hl, wCurSceneObj
	ld a, [wSceneWarioYCoord]
	sub 24
	ld [hli], a ; y
	ld a, [wSceneWarioXCoord]
	add 16
	ld [hl], a ; x

	ld a, $11
	ld hl, wCurSceneObjState
	call SetSceneObjState
	play_sfx SFX_EMOTE
	jp AdvancePrologueStep

.WaitEmoteAnimation:
	ld a, [wCurSceneObjState]
	and a
	ret nz
	jp AdvancePrologueStep

.Wait40_1:
	ld c, 40
	jp WaitPrologueStep

.WarioWalkRight:
	ld a, SCENEWARIO_WALK_RIGHT
	call SetSceneWarioState
	jp AdvancePrologueStep

.WarioMoveRightTo208:
	call ApplySceneWarioMovementRight
	cp 208
	ret nz
	ld [hl], a
	xor a ; SCENEWARIO_NONE
	call SetSceneWarioState
	jp AdvancePrologueStep

.Wait40_2:
	ld c, 40
	jp WaitPrologueStep

UpdatePlaneParts:
	call UpdatePlanePart1
	call UpdatePlanePart2
	call UpdatePlanePart3
	call UpdatePlanePart4

	ld hl, wSceneAuxStepCounter
	inc [hl]
	dec l
	ld a, [hl] ; wSceneAuxStep
	jumptable
	dw .StartPart1
	dw .StartPart2
	dw .StartPart3
	dw .StartPart4
	dw .Done

.Done:
	ret

.StartPart1:
	ld a, [wSceneAuxStepCounter]
	cp $08
	ret c
	ld hl, wPlanePart1Counter
	call AdvanceStepAtHL
	jp .advance_aux_step

.StartPart2:
	ld a, [wSceneAuxStepCounter]
	cp $08
	ret c
	ld hl, wPlanePart2Counter
	call AdvanceStepAtHL
	jr .advance_aux_step

.StartPart3:
	ld a, [wSceneAuxStepCounter]
	cp $08
	ret c
	ld hl, wPlanePart3Counter
	call AdvanceStepAtHL
	jr .advance_aux_step

.StartPart4:
	ld a, [wSceneAuxStepCounter]
	cp $08
	ret c
	ld hl, wPlanePart4Counter
	call AdvanceStepAtHL
	jr .advance_aux_step ; unnecessary jump
.advance_aux_step
	ld hl, wSceneAuxStepCounter

AdvanceStepAtHL:
	xor a
	ld [hld], a
	inc [hl]
	ret

; input:
; - d = y coordinate
; - e = x coordinate
; - c = new state
; - hl = obj pointer
SetSceneObjCoordAndState:
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	set 2, l
	ld a, c
	call SetSceneObjState
	ret

UpdatePlanePart1:
	ld hl, wPlanePart1Counter
	inc [hl]
	dec l
	ld a, [hl] ; wPlanePart1Action
	and a
	ret z
	dec a
	jumptable
	dw .Place1
	dw .Fall1
	dw .Bounce1
	dw .Wait8_1
	dw .Place2
	dw .Fall2
	dw .Bounce2
	dw .Wait40
	dw .Place3
	dw .Fall3
	dw .Bounce3
	dw .Wait8_2
	dw .End

.land_sfx_and_next:
	play_sfx SFX_PLANE_DEBRIS_LAND

.next:
	ld hl, wPlanePart1Counter
	jp AdvanceStepAtHL

.check_landed:
	ld a, [wSceneObj3YCoord]
	cp $62
	ret nz
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart1Action
	inc [hl]
	ret

.wait:
	ld hl, wPlanePart1Counter
	ld a, [hl]
	cp c
	ret c
	jr AdvanceStepAtHL

.Place1:
	ld hl, wSceneObj3
	lb de, 46, 240
	ld c, $06
	call SetSceneObjCoordAndState
	jr .next

.Fall1:
	call MovePlanePart1Arc3
	jr .check_landed

.Bounce1:
	call MovePlanePart1Arc3
	ret nz
	jr .land_sfx_and_next

.Wait8_1:
	ld c, $08
	jr .wait

.Place2:
	ld hl, wSceneObj3
	lb de, 77, 224
	ld c, $05
	call SetSceneObjCoordAndState
	jr .next

.Fall2:
	call MovePlanePart1Arc2
	jr .check_landed

.Bounce2:
	call MovePlanePart1Arc2
	ret nz
	jr .land_sfx_and_next

.Wait40:
	ld c, $28
	jr .wait

.Place3:
	ld hl, wSceneObj3
	lb de, 62, 240
	ld c, $04
	call SetSceneObjCoordAndState
	jr .next

.Fall3:
	call MovePlanePart1Arc1
	jr .check_landed

.Bounce3:
	call MovePlanePart1Arc1
	ret nz
	jr .land_sfx_and_next

.Wait8_2:
	ld c, $08
	jr .wait

.End:
	xor a
	ld [wPlanePart1Action], a
	ld hl, wSceneObj3State
	call SetSceneObjState
	ret

MovePlanePart1Arc3:
	ld de, PlanePartArcMovement3
	ld hl, wSceneObj3
	call ApplyOWMovement
	ret

MovePlanePart1Arc2:
	ld de, PlanePartArcMovement2
	ld hl, wSceneObj3
	call ApplyOWMovement
	ret

MovePlanePart1Arc1:
	ld de, PlanePartArcMovement1
	ld hl, wSceneObj3
	call ApplyOWMovement
	ret

UpdatePlanePart2:
	ld hl, wPlanePart2Counter
	inc [hl]
	dec l
	ld a, [hl] ; wPlanePart2Action
	and a
	ret z
	dec a
	jumptable
	dw .Place1
	dw .Fall1
	dw .Bounce1
	dw .Wait4
	dw .SetState12
	dw .Wait40
	dw .Place2
	dw .Fall2
	dw .Bounce2
	dw .Wait8_1
	dw .Place3
	dw .Fall3
	dw .Bounce3
	dw .Wait8_2
	dw .End

.land_sfx_and_next:
	play_sfx SFX_PLANE_DEBRIS_LAND
.next:
	ld hl, wPlanePart2Counter
	jp AdvanceStepAtHL

.check_landed:
	ld a, [wSceneObj4YCoord]
	cp $62
	ret nz
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart2Action
	inc [hl]
	ret

.wait:
	ld hl, wPlanePart2Counter
	ld a, [hl]
	cp c
	ret c
	jp AdvanceStepAtHL

.Place1:
	ld hl, wSceneObj4
	lb de, 62, 240
	ld c, $02
	call SetSceneObjCoordAndState
	xor a
	ld hl, wSceneObj1State
	call SetSceneObjState
	jr .next

.Fall1:
	call .move_arc1
	jr .follow_obj4

.Bounce1:
	call .move_arc1
	ret nz
	jr .land_sfx_and_next

.Wait4:
	ld c, $04
	jr .wait

.SetState12:
	ld a, $12
	ld hl, wSceneObj4State
	call SetSceneObjState
	jr .next

.Wait40:
	ld c, $28
	jr .wait

.Place2:
	ld hl, wSceneObj4
	lb de, 46, 224
	ld c, $08
	call SetSceneObjCoordAndState

.attach_obj1:
	ld a, [wSceneObj4YCoord]
	ld [wSceneObj1YCoord], a
	ld a, [wSceneObj4XCoord]
	ld [wSceneObj1XCoord], a
	ld a, $0f
	ld hl, wSceneObj1State
	call SetSceneObjState
	jr .next

.Fall2:
	call .move_arc3

.follow_obj4
	ld a, [wSceneObj4XCoord]
	ld [wSceneObj1XCoord], a
	ld a, [wSceneObj4YCoord]
	ld [wSceneObj1YCoord], a
	cp $62
	ret nz
	ld a, $10
	ld hl, wSceneObj1State
	call SetSceneObjState
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart2Action
	inc [hl]
	ret

.Bounce2:
	call .move_arc3
	ret nz
	jp .land_sfx_and_next

.Wait8_1:
	ld c, $08
	jp .wait

.Place3:
	ld hl, wSceneObj4
	lb de, 46, 244
	ld c, $04
	call SetSceneObjCoordAndState
	jr .attach_obj1

.Fall3:
	call .move_arc3_2
	jp .check_landed

.Bounce3:
	call .move_arc3_2
	ret nz
	jp .land_sfx_and_next

.Wait8_2:
	ld c, $08
	jp .wait

.End:
	xor a
	ld [wPlanePart2Action], a
	ld hl, wSceneObj4State
	call SetSceneObjState
	ret

.move_arc1:
	ld de, PlanePartArcMovement1
	ld hl, wSceneObj4
	call ApplyOWMovement
	ret

.move_arc3:
	ld de, PlanePartArcMovement3
	ld hl, wSceneObj4
	call ApplyOWMovement
	ret

.move_arc3_2:
	ld de, PlanePartArcMovement3
	ld hl, wSceneObj4
	call ApplyOWMovement
	ret

UpdatePlanePart3:
	ld hl, wPlanePart3Counter
	inc [hl]
	dec l
	ld a, [hl] ; wPlanePart3Action
	and a
	ret z
	dec a
	jumptable
	dw .Place1
	dw .Fall1
	dw .Bounce1
	dw .Wait8_1
	dw .Place2
	dw .Fall2
	dw .Bounce2
	dw .Wait4
	dw .SetState13
	dw .Wait40
	dw .Place3
	dw .Fall3
	dw .Bounce3
	dw .Wait8_2
	dw .End

.land_sfx_and_next:
	play_sfx SFX_PLANE_DEBRIS_LAND
.next:
	ld hl, wPlanePart3Counter
	jp AdvanceStepAtHL

.check_landed:
	ld a, [wSceneObj5YCoord]
	cp $62
	ret nz
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart3Action
	inc [hl]
	ret

.wait:
	ld hl, wPlanePart3Counter
	ld a, [hl]
	cp c
	ret c
	jp AdvanceStepAtHL

.Place1:
	ld hl, wSceneObj5
	lb de, 62, 224
	ld c, $03
	call SetSceneObjCoordAndState
	ld a, [wSceneObj5YCoord]
	ld [wSceneObj2YCoord], a
	ld a, [wSceneObj5XCoord]
	ld [wSceneObj2XCoord], a
	ld a, $0f
	ld hl, wSceneObj2State
	call SetSceneObjState
	jr .next

.Fall1:
	call .move_arc1
	ld a, [wSceneObj5XCoord]
	ld [wSceneObj2XCoord], a
	ld a, [wSceneObj5YCoord]
	ld [wSceneObj2YCoord], a
	cp $62
	ret nz
	ld a, $10
	ld hl, wSceneObj2State
	call SetSceneObjState
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart3Action
	inc [hl]
	ret

.Bounce1:
	call .move_arc1
	ret nz
	jr .land_sfx_and_next

.Wait8_1:
	ld c, $08
	jr .wait

.Place2:
	ld hl, wSceneObj5
	lb de, 46, 240
	ld c, $07
	call SetSceneObjCoordAndState
	jp .next

.Fall2:
	call .move_arc3
	jp .check_landed

.Bounce2:
	call .move_arc3
	ret nz
	jp .land_sfx_and_next

.Wait4:
	ld c, $04
	jr .wait

.SetState13:
	ld a, $13
	ld hl, wSceneObj5State
	call SetSceneObjState
	jp .next

.Wait40:
	ld c, $28
	jp .wait

.Place3:
	ld hl, wSceneObj5
	lb de, 77, 248
	ld c, $05
	call SetSceneObjCoordAndState
	jp .next

.Fall3:
	call .move_arc2
	jp .check_landed

.Bounce3:
	call .move_arc2
	ret nz
	jp .land_sfx_and_next

.Wait8_2:
	ld c, $08
	jp .wait

.End:
	xor a
	ld [wPlanePart3Action], a
	ld hl, wSceneObj5State
	call SetSceneObjState
	ret

.move_arc1:
	ld de, PlanePartArcMovement1
.move:
	ld hl, wSceneObj5
	call ApplyOWMovement
	ret

.move_arc3:
	ld de, PlanePartArcMovement3
	jr .move

.move_arc2:
	ld de, PlanePartArcMovement2
	jr .move

UpdatePlanePart4:
	ld hl, wPlanePart4Counter
	inc [hl]
	dec l
	ld a, [hl] ; wPlanePart4Action
	and a
	ret z
	dec a
	jumptable
	dw .Place1
	dw .Fall1
	dw .Bounce1
	dw .Wait4
	dw .SetState13
	dw .Wait40
	dw .Place2
	dw .Fall2
	dw .Bounce2
	dw .Wait8
	dw .End

.land_sfx_and_next:
	play_sfx SFX_PLANE_DEBRIS_LAND
.next:
	ld hl, wPlanePart4Counter
	jp AdvanceStepAtHL

.check_landed:
	ld a, [wSceneObj9YCoord]
	cp $62
	ret nz
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart4Action
	inc [hl]
	ret

.wait:
	ld hl, wPlanePart4Counter
	ld a, [hl]
	cp c
	ret c
	jp AdvanceStepAtHL

.Place1:
	ld hl, wSceneObj9
	lb de, 77, 240
	ld c, $07
	call SetSceneObjCoordAndState
	jr .next

.Fall1:
	call .move_arc2
	jr .check_landed

.Bounce1:
	call .move_arc2
	ret nz
	jr .land_sfx_and_next

.Wait4:
	ld c, $04
	jr .wait

.SetState13:
	ld a, $13
	ld hl, wSceneObj9State
	call SetSceneObjState
	jr .next

.Wait40:
	ld c, $28
	jr .wait

.Place2:
	ld hl, wSceneObj9
	lb de, 62, 240
	ld c, $08
	call SetSceneObjCoordAndState
	ld a, [wSceneObj9YCoord]
	ld [wSceneObj8YCoord], a
	ld a, [wSceneObj9XCoord]
	ld [wSceneObj8XCoord], a
	ld a, $0f
	ld hl, wSceneObj8State
	call SetSceneObjState
	jr .next

.Fall2:
	call .move_arc1
	ld a, [wSceneObj9XCoord]
	ld [wSceneObj8XCoord], a
	ld a, [wSceneObj9YCoord]
	ld [wSceneObj8YCoord], a
	cp $62
	ret nz
	ld a, $10
	ld hl, wSceneObj8State
	call SetSceneObjState
	play_sfx SFX_PLANE_DEBRIS_LAND
	ld hl, wPlanePart4Action
	inc [hl]
	ret

.Bounce2:
	call .move_arc1
	ret nz
	jp .land_sfx_and_next

.Wait8:
	ld c, $08
	jp .wait

.End:
	xor a
	ld [wPlanePart4Action], a
	ld hl, wSceneObj9State
	call SetSceneObjState
	ret

.move_arc2:
	ld de, PlanePartArcMovement2
.move:
	ld hl, wSceneObj9
	call ApplyOWMovement
	ret

.move_arc1:
	ld de, PlanePartArcMovement1
	jr .move

.unreferenced_move_arc3:
	ld de, PlanePartArcMovement3
	jr .move

PrologueWarioFallMovement:
	db  0, 0
	db  0, 0
	db  0, 1
	db  0, 0
	db  0, 1
	db  0, 1
	db -1, 2
	db  0, 2
	db  0, 2
	db  1, 3
	db  0, 4
	db  1, 5
	db  2, 5
	db  2, 4
	db  3, 5
	db  2, 3
	db  2, 2
	db  2, 2
	db  2, 3
	db  3, 2
	db  2, 2
	db  3, 1
	db  3, 2
	db  3, 1
	db  3, 1
	db  3, 1
	db  0, 0
	db -3, 1
	db -3, 2
	db -2, 1
	db -3, 3
	db -1, 2
	db -2, 3
	db  0, 3
	db  0, 3
	db  1, 3
	db  2, 2
	db  2, 2
	db  2, 2
	db  2, 2
	db  2, 2
	db  3, 1
	db  0, 0
	db -2, 2
	db -2, 2
	db -2, 2
	db  0, 3
	db  0, 3
	db  2, 2
	db  2, 2
	db  2, 1
	db $80

PlanePartArcMovement1:
	db  0, 0
	db  0, 0
	db  0, 1
	db  0, 1
	db  0, 1
	db  0, 2
	db  0, 2
	db  0, 3
	db  0, 4
	db  1, 6
	db  2, 6
	db  2, 6
	db  3, 6
	db  2, 3
	db  2, 4
	db  3, 3
	db  2, 3
	db  3, 3
	db  3, 3
	db  3, 3
	db  3, 2
	db  4, 3
	db  3, 2
	db  0, 0
	db -2, 2
	db -3, 1
	db -2, 2
	db -2, 3
	db -1, 2
	db -1, 3
	db  0, 3
	db  0, 3
	db  1, 3
	db  1, 2
	db  2, 3
	db  2, 2
	db  3, 1
	db  2, 2
	db $80

PlanePartArcMovement2:
	db  0, 0
	db  0, 0
	db  0, 1
	db  0, 1
	db -1, 1
	db  0, 2
	db  0, 2
	db  0, 3
	db  0, 3
	db  0, 5
	db  1, 6
	db  1, 7
	db  1, 7
	db  2, 7
	db  1, 4
	db  1, 5
	db  1, 4
	db  2, 5
	db  1, 4
	db  2, 5
	db  2, 4
	db  2, 5
	db  2, 4
	db  3, 4
	db  0, 0
	db -1, 2
	db -2, 3
	db -1, 2
	db -2, 3
	db -1, 2
	db -1, 3
	db  0, 3
	db  0, 3
	db  1, 3
	db  1, 2
	db  2, 3
	db  1, 2
	db  2, 3
	db  1, 2
	db $80

PlanePartArcMovement3:
	db  0, 0
	db  0, 0
	db  0, 0
	db  0, 1
	db  0, 1
	db  0, 1
	db  1, 1
	db  0, 2
	db  1, 2
	db  2, 3
	db  2, 3
	db  2, 3
	db  4, 4
	db  4, 3
	db  3, 2
	db  3, 2
	db  3, 2
	db  4, 1
	db  3, 2
	db  4, 2
	db  4, 1
	db  4, 1
	db  4, 1
	db  4, 1
	db  0, 0
	db -2, 2
	db -3, 2
	db -2, 1
	db -2, 2
	db -2, 2
	db -2, 2
	db -1, 3
	db  1, 3
	db  2, 2
	db  2, 2
	db  2, 2
	db  2, 1
	db  3, 2
	db  2, 2
	db $80

_InitEpilogue:
	call DisableLCD
	call FillBGMap0_With7f
	call ClearVirtualOAM
	stop_music2

	ld a, $02
	ldh [rWBK], a
	xor a
	ldh [rSCX], a
	ld [wSCX], a
	ldh [rSCY], a
	ld [wSCY], a

	call VBlank_PrologueEpilogue
	call ClearGeneralSceneRAM
	call ClearSceneObjsRAM

	xor a
	ld hl, wTempPals1
	ld bc, 8 palettes
	call WriteAToHL_BCTimes
	xor a
	ld hl, wTempPals2
	ld bc, 8 palettes
	call WriteAToHL_BCTimes

	decompress_tiles0 EpilogueGfx, v0Tiles0
	decompress_tiles1 FontGfx, v1Tiles0

	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, v0Tiles1
	ld de, wAttrmap
	ld bc, $50 tiles
	call CopyHLToDE_BC
	ld hl, EpilogueStarGfx
	ld de, v1Tiles1 tile $40
	ld c, $00 ; aka $100 bytes
	ld b, BANK(EpilogueStarGfx)
	call CopyFarBytes
	xor a
	ldh [rVBK], a

	decompress_tiles1 SpearheadGfx, v1Tiles0
	decompress_tiles1 HammerBotGfx, v1Tiles0, $40
	decompress_tiles1 DoughnuteerGfx, v1Tiles1

	decompress_attrmap EpilogueTransformationAttrmap, v1BGMap0
	decompress_tilemap EpilogueTransformationTilemap, v0BGMap0
	decompress_attrmap PrologueAttrmap, v1BGMap1
	decompress_tilemap PrologueTilemap, v0BGMap1

	call FillClearedTextBuffer
	ld a, [wLanguage]
	and a
	ld hl, TextJP_OldManThankYou ; japanese
	jr z, .got_text
	ld hl, TextEN_OldManThankYou ; english
.got_text
	ld a, BANK(TextJP_OldManThankYou) ; aka BANK(TextEN_OldManThankYou)
	ld [wTempBank], a
	ld bc, wTextBuffer
	ld a, [wTempBank]
	ldh [hCallFuncBank], a
	hcall Decompress

	xor a
	ld [wOWStep], a
	ld [wOWStepCounter], a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a

	ld a, [wCollectionRow]
	ld b, a
	and a
	ld a, LCDC_BG_ON | LCDC_OBJ_ON | LCDC_OBJ_16 | LCDC_WIN_9C00 | LCDC_ON
	jr z, .set_lcdc
	xor b
.set_lcdc
	ldh [rLCDC], a
	xor a
	ld [wCollectionRow], a
	ld hl, wSubState
	inc [hl]
	ret

; unreferenced
UnreferencedInitEpilogue:
	call DisableLCD
	call FillBGMap0_With7f
	call ClearVirtualOAM

	play_music2 MUSIC_EPILOGUE

	ld a, $02
	ldh [rWBK], a
	ld a, SCREEN_WIDTH_PX
	ldh [rSCX], a
	ld [wSCX], a
	xor a
	ldh [rSCY], a
	ld [wSCY], a

	ld hl, EpilogueBGPals
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(EpilogueBGPals)
	call CopyFarBytes
	ld hl, EpilogueOBPals
	ld de, wTempPals2
	ld c, 8 palettes
	ld b, BANK(EpilogueOBPals)
	call CopyFarBytes

	decompress_tiles1 FontGfx, v1Tiles0

	; attempting to decompress uncompressed data
	decompress_attrmap EpilogueCrowdAttrmap, v1BGMap0
	decompress_tilemap EpilogueCrowdTilemap, v0BGMap0

	ld hl, wOWUIObj1YCoord
	ld a, $60
	ld [hli], a
	ld [hl], $5c
	ld a, $ff
	ld [wOWUIObj2YCoord], a

	ld a, $0c
	call SetSceneWarioState
	ld hl, wSceneObj10
	ld a, $30
	ld [hli], a
	ld [hl], $00
	ld a, $1b
	ld hl, wSceneObj10State
	call SetSceneObjState
	ld hl, wSceneObj11
	ld a, $35
	ld [hli], a
	ld [hl], $20
	ld a, $1c
	ld hl, wSceneObj11State
	call SetSceneObjState
	ld hl, wSceneObj12
	ld a, $32
	ld [hli], a
	ld [hl], $70
	ld a, $1b
	ld hl, wSceneObj12State
	call SetSceneObjState
	ld hl, wSceneObj13
	ld a, $38
	ld [hli], a
	ld [hl], $c0
	ld a, $1c
	ld hl, wSceneObj13State
	call SetSceneObjState

	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	ld [wSceneStep], a
	ld [wSceneStepCounter], a
	ld a, [wCollectionRow]
	ld b, a
	and a
	ld a, LCDC_BG_ON | LCDC_OBJ_ON | LCDC_OBJ_16 | LCDC_WIN_9C00 | LCDC_ON
	jr z, .set_lcdc
	xor b
.set_lcdc
	ldh [rLCDC], a
	xor a
	ld [wCollectionRow], a
	jp AdvanceEpilogueOWStep

WaitEpilogueOWStep:
	ld a, [wOWStepCounter]
	cp c
	ret c
;	fallthrough

AdvanceEpilogueOWStep:
	ld hl, wOWStepCounter
	xor a
	ld [hld], a
	inc [hl]
	ret

_UpdateEpilogue:
	call .PlayCutscene
	call UpdateEpilogueSceneObjs_Front
	call UpdateSceneWario
	call UpdateEpilogueSceneObjs_Back
	call ClearUnusedVirtualOAM
	ret

.PlayCutscene:
	call .MoveClouds

	ld hl, wOWStepCounter
	inc [hl]
	ld a, [wOWStep]
	jumptable
	dw AdvanceEpilogueOWStep
	dw .Wait60
	dw .InitTransformationScene
	dw FadeBGAndOBPalsAndAdvanceStep
	dw .Transformation
	dw .SetFadeToBlack
	dw PrologueFade
	dw .LoadOldMan1Gfx
	dw .LoadOldMan2Gfx
	dw .LoadCrowdTilemap
	dw .LoadCrowdAttrmap
	dw .RestoreSavedVRAM1Tiles
	dw .InitCrowdScene
	dw FadeBGAndOBPalsAndAdvanceStep
	dw .OldManArrives
	dw InitTextPrinting
	dw PrintTextPageWithHeader
	dw .Wait30
	dw LoadCurTextPageBufferPage
	dw WaitAButtonAndClearTextbox
	dw .PrintTextAndAnimateOldMan
	dw NextTextPageOrEnd
	dw .SendWarioHome
	dw .SetFadeToBlack
	dw PrologueFade
	dw .LoadForestGfx
	dw .InitForestScene
	dw FadeBGAndOBPalsAndAdvanceStep
	dw .WarioAndMusicBoxLand
	dw .SetFadeToBlack
	dw .FadeEvery4Frames
	dw .WaitThenFinish

.Wait60:
	ld c, $3c
	jp WaitEpilogueOWStep
.InitTransformationScene:
	ld hl, wSceneObj9
	ld a, $60
	ld [hli], a
	ld a, $50
	ld [hl], a
	ld a, $18
	ld hl, wSceneObj9State
	call SetSceneObjState
	call .load_epilogue_pals
	call .load_extra_ob_pals
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	jp AdvanceEpilogueOWStep
.load_epilogue_pals:
	call CopyTempPalsToBGOBPals_Bank2b1
	ld hl, EpilogueBGPals
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(EpilogueBGPals)
	call CopyFarBytes
	ld hl, EpilogueOBPals
	ld de, wTempPals2
	ld c, 8 palettes
	ld b, BANK(EpilogueOBPals)
	call CopyFarBytes
	ret
.load_extra_ob_pals:
	ld hl, .ExtraOBPals
	ld de, wTempPals2 palette 4
	ld b, 3 palettes
	call CopyHLToDE
	ret
.LoadOldMan1Gfx:
	xor a
	ld [wHDMADestVRAMBank], a
	ld de, OldMan1Gfx
	ld b, HIGH(v0Tiles1) - $80
	ld c, $40 dma_tiles
.set_hdma_bank
	ld a, BANK(OldMan1Gfx)
	ld [wHDMABank], a
.set_hdma
	ld hl, wHDMA
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a
	ld [hli], a
	ld a, c
	ld [hl], a
	jp AdvanceEpilogueOWStep
.LoadOldMan2Gfx:
	ld a, BANK("VRAM1")
	ld [wHDMADestVRAMBank], a
	ld de, OldMan2Gfx
	ld b, HIGH(v1Tiles0) - $80
	ld c, $80 dma_tiles
	jr .set_hdma_bank
.LoadCrowdTilemap:
	xor a
	ld [wHDMADestVRAMBank], a
	ld de, EpilogueCrowdTilemap
	ld b, HIGH(v0BGMap0) - $80
	ld c, 18 dma_rows
	jr .set_hdma_bank
.LoadCrowdAttrmap:
	ld a, BANK("VRAM1")
	ld [wHDMADestVRAMBank], a
	ld de, EpilogueCrowdAttrmap
	ld b, HIGH(v1BGMap0) - $80
	ld c, 18 dma_rows
	jr .set_hdma_bank
.RestoreSavedVRAM1Tiles:
	ld a, BANK("VRAM1")
	ld [wHDMADestVRAMBank], a
	ld de, wAttrmap
	ld b, HIGH(v1Tiles1) - $80
	ld c, $50 dma_tiles
	jr .set_hdma_bank
.InitCrowdScene:
	ld a, SCREEN_WIDTH_PX
	ldh [rSCX], a
	ld [wSCX], a
	xor a
	ldh [rSCY], a
	ld [wSCY], a
	ld hl, wOWUIObj1YCoord
	ld a, $60
	ld [hli], a
	ld [hl], $5c
	ld a, $ff
	ld [wOWUIObj2YCoord], a
	ld a, $0c
	call SetSceneWarioState

	ld hl, wSceneObj10
	lb de, $30, $00
	ld b, $1b
	call .place_obj
	ld hl, wSceneObj11
	lb de, $35, $20
	ld b, $1c
	call .place_obj
	ld hl, wSceneObj12
	lb de, $32, $70
	ld b, $1b
	call .place_obj
	ld hl, wSceneObj13
	lb de, $38, $c0
	ld b, $1c
	call .place_obj

	ld hl, EpilogueBGPals
	ld de, wTempPals1
	call .copy_8_pals
	ld hl, EpilogueOBPals
	ld de, wTempPals2
	call .copy_8_pals

	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	ld [wSceneStep], a
	ld [wSceneStepCounter], a
	jp AdvanceEpilogueOWStep
.place_obj:
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	set 2, l
	ld a, b
	jp SetSceneObjState
.copy_8_pals:
	ld c, 8 palettes
	ld b, BANK(EpilogueBGPals) ; aka BANK(EpilogueOBPals)
	jp CopyFarBytes
.Wait30:
	ld c, $1e
	jp WaitEpilogueOWStep
.PrintTextAndAnimateOldMan:
	call PrintTextWithoutHeader
	call .SetOldManTalkAnim
	ld a, [wCurTextLine]
	cp $80
	ret nz
	jp AdvanceEpilogueOWStep
.SetFadeToBlack:
	ld a, $00
	ld [w2d880], a
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	jp AdvanceEpilogueOWStep
.LoadForestGfx:
	xor a
	ld [wHDMADestVRAMBank], a
	ld de, PrologueBackgroundGfx
	ld b, HIGH(v0Tiles2) - $80
	ld c, $80 dma_tiles
	ld a, BANK(PrologueBackgroundGfx)
	ld [wHDMABank], a
	jp .set_hdma
.InitForestScene:
	ld hl, wSceneObj9
	ld a, $3c
	ld [hli], a
	ld a, $b2
	ld [hl], a
	ld a, $13
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld hl, wOWUIObj1YCoord
	ld a, $3c
	ld [hli], a
	ld a, $c8
	ld [hl], a
	ld a, $1c
	call SetSceneWarioState
	xor a
	ld [wSceneObj10State], a
	ld [wSceneObj11State], a
	ld [wSceneObj12State], a
	ld [wSceneObj13State], a
	ld a, LCDC_BG_9C00
	ld [wCollectionRow], a
	call CopyTempPalsToBGOBPals_Bank2b1
	ld hl, PrologueBGPals
	ld de, wTempPals1
	ld c, 8 palettes
	ld b, BANK(PrologueBGPals)
	call CopyFarBytes
	ld hl, EpilogueOBPals
	ld de, wTempPals2
	ld c, 8 palettes
	ld b, BANK(EpilogueOBPals)
	call CopyFarBytes
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wPalConfig2TotalSteps], a
	jp AdvanceEpilogueOWStep

.FadeEvery4Frames:
	ld a, [wOWStepCounter]
	and $03
	ret nz
	jp PrologueFade

.WaitThenFinish:
	ld a, [wOWStepCounter]
	cp $3c
	ret c
	ld hl, wSubState
	inc [hl]
	ret

.ExtraOBPals:
	rgb  0, 25,  0
	rgb 31, 31, 29
	rgb  5, 26, 26
	rgb  0,  0,  3

	rgb 31, 31, 31
	rgb 31, 31, 10
	rgb  0, 10, 31
	rgb  0,  0,  3

	rgb 31, 31, 31
	rgb 31, 31, 26
	rgb 31,  5,  5
	rgb  0,  0,  3

.SetOldManTalkAnim:
	ld a, [wPendingCharDest]
	and a
	ret z
	ld a, [wCurTextLinePos]
	cp 1
	ret nz
	ld a, [wLanguage]
	and a
	jr nz, .english
; japanese
	ld a, [wCurTextBufferPage]
	cp $01
	jr z, .anim_10_line_1
	cp $04
	jr z, .anim_0c_line_1
	cp $05
	jr z, .anim_0d_line_2
	cp $07
	jr z, .anim_0e_line_2
	cp $0a
	jr z, .anim_10_line_2
	cp $0b
	jr z, .anim_0c_line_3
	jr .default_anim_on_line_1
.english
	ld a, [wCurTextBufferPage]
	cp $01
	jr z, .anim_10_line_1
	cp $04
	jr z, .anim_0c_line_1
	cp $05
	jr z, .anim_0d_line_1
	cp $08
	jr z, .anim_0e_line_2
	cp $0b
	jr z, .anim_10_line_1
	cp $0c
	jr z, .anim_0c_line_1
.default_anim_on_line_1
	ld a, [wCurTextBufferLine]
	cp $01
	ret nz
	ld a, $0b
	ld hl, wSceneObj9State
	call SetSceneObjState
	ret
.anim_10_line_1
	ld b, $10
.anim_on_line_1
	ld a, $01
	ld hl, wCurTextBufferLine
	cp [hl]
	ret nz
.set_anim
	ld a, b
	ld hl, wSceneObj9State
	jp SetSceneObjState
.anim_0c_line_1
	ld b, $0c
	jr .anim_on_line_1
.anim_0d_line_1
	ld b, $0d
	jr .anim_on_line_1
.anim_0d_line_2
	ld b, $0d
.anim_on_line_2
	ld a, $02
.anim_on_line_a
	ld hl, wCurTextBufferLine
	cp [hl]
	jr nz, .default_anim_on_line_1
	jr .set_anim
.anim_0e_line_2
	ld b, $0e
	jr .anim_on_line_2
.anim_10_line_2
	ld b, $10
	jr .anim_on_line_2
.anim_0c_line_3
	ld b, $0c
	ld a, $03
	jr .anim_on_line_a

.wait_wario_state
	ld a, [wOWUIObj1State]
	cp b
	ret nz
	jr .next_scene_step

	ld a, [wSceneStepCounter]
	cp c
	ret c

.next_scene_step
	ld hl, wSceneStepCounter
	xor a
	ld [hld], a
	inc [hl]
	ret

.end_scene_steps
	xor a
	ld hl, wSceneStep
	ld [hli], a
	ld [hl], a
	jp AdvanceEpilogueOWStep

.FadeThenNextSceneStep:
	farcall FadeBGAndOBPals
	ld a, [wPalConfig1TotalSteps]
	and a
	ret nz
	ld hl, wSceneStepCounter
	ld [hld], a
	inc [hl]
	ret

.WarioAndMusicBoxLand:
	call .UpdateMusicBoxFall
	call .UpdateWarioFall
	ld hl, wSceneStep
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .InitLanding
	dw .DropWario
	dw .DropMusicBox
	dw .WaitBothLanded
	dw .WarioTurnBackLeft
	dw .WaitWarioLookBack
	dw .WarioLookTurnRight
	dw .WaitWarioIdleLeft
	dw .WarioPickUp
	dw .WaitWarioCarryIdle
	dw .LiftMusicBox
	dw .WarioCarrySnapFingers
	dw .SnapSFX
	dw .WaitWarioCarryIdle2
	dw .WarioCarryWalk
	dw .WalkLeftOffScreen
	dw .Wait60ThenEnd_1

.InitLanding:
	xor a
	ld [wPalFade2Colour2GreenUnk1], a
	ld [wSceneSubStep], a
	ld [wTempleRock5Action], a
	ld [wPalFade2Colour4GreenSign], a
	jp .next_scene_step

.DropWario:
	ld a, [bc]
	cp $40
	ret c
	ld a, $01
	ld [wSceneSubStep], a
	play_sfx SFX_THROW
	jp .next_scene_step

.DropMusicBox:
	ld a, [bc]
	cp $56
	ret c
	ld a, $01
	ld [wTempleRock5Action], a
	play_sfx SFX_THROW
	jp .next_scene_step

.WaitBothLanded:
	ld a, [wSceneSubStep]
	cp $80
	ret nz
	ld a, [wTempleRock5Action]
	cp $80
	ret nz
	jp .next_scene_step

.WarioTurnBackLeft:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $05
	call SetSceneWarioState
	jp .next_scene_step

.WaitWarioLookBack:
	ld b, $02
	jp .wait_wario_state

.WarioLookTurnRight:
	ld a, [bc]
	cp $28
	ret c
	ld a, $14
	call SetSceneWarioState
	jp .next_scene_step

.WaitWarioIdleLeft:
	ld b, $0c
	jp .wait_wario_state

.WarioPickUp:
	ld a, [bc]
	cp $2d
	ret c
	ld a, $0b
	call SetSceneWarioState
	xor a
	ld [wSceneObj9Unk7], a
	play_sfx SFX_GRAB
	jp .next_scene_step

.WaitWarioCarryIdle:
	ld a, [wSceneObj9Unk7]
	cp $80
	ret nz
	ld a, [wOWUIObj1State]
	cp $0a
	ret nz
	jp .next_scene_step

.LiftMusicBox:
	ld a, [wSceneStepCounter]
	cp $04
	jr z, .lift_step_4
	cp $06
	jr z, .lift_step_6
	cp $07
	jr z, .lift_step_7
	ret
.lift_step_4
	ld d, $df
	ld e, $fa
.place_music_box_on_wario
	ld hl, wSceneObj9
	ld a, [wOWUIObj1YCoord]
	add d
	ld [hli], a
	ld a, [wOWUIObj1XCoord]
	add e
	ld [hl], a
	ret
.lift_step_6
	ld d, $e0
	ld e, $fb
	jr .place_music_box_on_wario
.lift_step_7
	ld d, $e2
	ld e, $fc
	call .place_music_box_on_wario
	jp .next_scene_step

.WarioCarrySnapFingers:
	ld a, [bc]
	cp $32
	ret c
	ld a, $21
	call SetSceneWarioState
	jp .next_scene_step

.SnapSFX:
	ld a, [wOWUIObj1Frame]
	cp $0b
	ret nz
	play_sfx SFX_EMOTE
	jp .next_scene_step

.WaitWarioCarryIdle2:
	ld b, $0a
	jp .wait_wario_state

.WarioCarryWalk:
	ld a, [bc]
	cp $32
	ret c
	ld a, $09
	call SetSceneWarioState
	xor a
	ld [wSceneObj9Unk7], a
	jp .next_scene_step

.WalkLeftOffScreen:
	call MoveSceneWarioLeft
	ld a, [wOWUIObj1XCoord]
	ld b, a
	sub $04
	ld [wSceneObj9XCoord], a
	ld a, $f0
	cp b
	ret nz
	xor a
	ld [wOWUIObj1State], a
	ld [wSceneObj9State], a
	jp .next_scene_step

.Wait60ThenEnd_1:
	ld a, [bc]
	cp $3c
	ret c
	jp .end_scene_steps

.UpdateWarioFall:
	ld a, [wPalFade2Colour2GreenUnk1]
	and a
	jr z, .wario_fall_step
	ld a, [wSceneStepCounter]
	and $03
	jr z, .wario_fall_step
	ld de, PrologueWarioFallMovement
	ld hl, wOWUIObj1YCoord
	call ApplyOWMovement_Mirrored
	jr nz, .wario_fall_step
	xor a
	ld [wPalFade2Colour2GreenUnk1], a
.wario_fall_step
	ld a, [wSceneSubStep]
	cp $80
	ret z
	jumptable
	dw .WarioFall_None
	dw .WarioFall_Start
	dw .WarioFall_Land
	dw .WarioFall_Delay4
	dw .WarioFall_Land
	dw .WarioFall_Delay4
	dw .WarioFall_Land
	dw .WarioFall_WaitStunned
	dw .WarioFall_GetUp
	dw .WarioFall_Done

.WarioFall_None:
	ret

.WarioFall_Start:
	ld a, $01
	ld [wPalFade2Colour2GreenUnk1], a
	xor a
	ld [wSceneWarioUnk7], a
.next_wario_fall_step
	ld hl, wSceneSubStep
	inc [hl]
	xor a
	ld [wSceneSubStepCounter], a
	ret

.WarioFall_Land:
	ld a, [wOWUIObj1YCoord]
	cp $60
	ret nz
	ld a, $1b
	call SetSceneWarioState
	call .play_wario_bump_sfx
	jr .next_wario_fall_step

.WarioFall_Delay4:
	ld hl, wSceneSubStepCounter
	inc [hl]
	ld a, [hl]
	cp $04
	ret c
	jr .next_wario_fall_step

.WarioFall_WaitStunned:
	ld a, [wOWUIObj1State]
	cp $1c
	ret nz
	jr .next_wario_fall_step

.WarioFall_GetUp:
	ld hl, wSceneSubStepCounter
	inc [hl]
	ld a, [hl]
	cp $42
	ret c
	ld a, $0c
	call SetSceneWarioState
	play_sfx SFX_STEP
	jr .next_wario_fall_step

.WarioFall_Done:
	ld a, $80
	ld [wSceneSubStep], a
	ret

.play_wario_bump_sfx:
	play_sfx SFX_BUMP
	ret

.UpdateMusicBoxFall:
	ld a, [wPalFade2Colour4GreenSign]
	and a
	jr z, .music_box_fall_step
	ld hl, wSceneObj9
	ld de, PrologueWarioFallMovement
	call ApplyOWMovement_Mirrored
	jr nz, .music_box_fall_step
	xor a
	ld [wPalFade2Colour4GreenSign], a
.music_box_fall_step
	ld a, [wTempleRock5Action]
	cp $80
	ret z
	jumptable
	dw .MusicBoxFall_None
	dw .MusicBoxFall_Start
	dw .MusicBoxFall_Land
	dw .MusicBoxFall_Delay4
	dw .MusicBoxFall_Land
	dw .MusicBoxFall_Delay4
	dw .MusicBoxFall_Land
	dw .MusicBoxFall_Done

.MusicBoxFall_None:
	ret

.MusicBoxFall_Start:
	ld a, $01
	ld [wPalFade2Colour4GreenSign], a
	xor a
	ld [wSceneObj9Unk7], a
.next_music_box_fall_step
	ld hl, wTempleRock5Action
	inc [hl]
	xor a
	ld [wTempleRock5Counter], a
	ret

.MusicBoxFall_Land:
	ld a, [wSceneObj9YCoord]
	cp $60
	ret nz
	call .play_music_box_bump_sfx
	jr .next_music_box_fall_step

.MusicBoxFall_Delay4:
	ld hl, wTempleRock5Counter
	inc [hl]
	ld a, [hl]
	cp $04
	ret c
	jr .next_music_box_fall_step

.MusicBoxFall_Done:
	ld a, $80
	ld [wTempleRock5Action], a
	ret

.play_music_box_bump_sfx:
	play_sfx SFX_BUMP
	ret

.SendWarioHome:
	call CycleSceneWarioPals
	ld hl, wSceneStep
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .ShowArrow
	dw .WaitAButton
	dw .StartWarioPalCycle
	dw .StopWarioPalCycle
	dw .RemoveWario
	dw .Wait90
	dw .CurObjFlyUp
	dw .Wait45ThenEnd

.ShowArrow:
	ld a, [bc]
	cp $1e
	ret c
	ld a, $01
	ld hl, wSceneObj1State
	call SetSceneObjState
	jp .next_scene_step

.WaitAButton:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	ret z
	xor a
	ld hl, wSceneObj1State
	call SetSceneObjState
	stop_music2
	call ClearTextbox
	ld a, $0f
	ld hl, wSceneObj9State
	call SetSceneObjState
	jp .next_scene_step

.StartWarioPalCycle:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $01
	ld [w2d150], a
	jp .next_scene_step

.StopWarioPalCycle:
	ld a, [bc]
	cp $28
	ret c
	ld a, $80
	ld [w2d150], a
	ld hl, wCurSceneObj
	ld a, [wOWUIObj1YCoord]
	sub $04
	ld [hli], a
	ld a, [wOWUIObj1XCoord]
	ld [hl], a
	ld a, $11
	ld hl, wCurSceneObjState
	call SetSceneObjState
	jp .next_scene_step

.RemoveWario:
	ld a, [bc]
	cp $14
	ret c
	xor a
	call SetSceneWarioState
	jp .next_scene_step

.Wait90:
	ld a, [bc]
	cp $5a
	ret c
	jp .next_scene_step

.CurObjFlyUp:
	ld hl, wCurSceneObj
	ld a, [hl]
	cp $50
	jr c, .fly_up_fast
	ld a, [wSceneStepCounter]
	ld b, a
	and $03
	ret nz
	dec [hl]
	ret
.fly_up_fast
	dec [hl]
	dec [hl]
	dec [hl]
	ld a, [hl]
	cp $18
	jr c, .flown_away
	cp $40
	ret nc
	ld a, [wCurSceneObjState]
	cp $12
	ret z
	ld a, $12
	ld hl, wCurSceneObjState
	call SetSceneObjState
	ld a, $0a
	ld hl, wSceneObj9State
	call SetSceneObjState
	ret
.flown_away
	xor a
	ld [wCurSceneObjState], a
	jp AdvancePrologueStep

.Wait45ThenEnd:
	ld a, [bc]
	cp $2d
	ret c
	jp .end_scene_steps

.OldManArrives:
	ld hl, wSceneStep
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .PlaceOldMan
	dw .OldManWalkRight
	dw .OldManWalkAndScroll
	dw .SetOldManState06
	dw .WaitOldManState0a
	dw .Wait60ThenEnd_2

.PlaceOldMan:
	ld a, [bc]
	cp $3c
	ret c
	ld a, $08
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld hl, wSceneObj9
	ld a, $60
	ld [hli], a
	ld [hl], $80
	jp .next_scene_step

.OldManWalkRight:
	call .move_old_man_right
	cp $e0
	ret nz
	jp .next_scene_step

.OldManWalkAndScroll:
	call .move_old_man_right
	ld hl, wSCX
	inc [hl]
	ret nz
	ld a, $09
	ld hl, wSceneObj9State
	call SetSceneObjState
	jp .next_scene_step

.SetOldManState06:
	ld a, [bc]
	cp $1e
	ret c
	ld a, $06
	ld hl, wSceneObj9State
	call SetSceneObjState
	jp .next_scene_step

.WaitOldManState0a:
	ld a, [wSceneObj9State]
	cp $0a
	ret nz
	jp .next_scene_step

.Wait60ThenEnd_2:
	ld a, [bc]
	cp $3c
	ret c
	jp .end_scene_steps

.move_old_man_right:
	ld hl, wSceneObj9XCoord
	inc [hl]
	ld a, [hl]
	and $fe
	ret

.Transformation:
	farcall UpdateTransformationSparkles
	ld hl, wSceneStep
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .PlayEpilogueMusic
	dw .SetObjsPal4
	dw .WaitObj1ThenFlash
	dw .FadeThenNextSceneStep
	dw .TransformSpearhead
	dw .FadeThenNextSceneStep
	dw .ShowHammerBot
	dw .SetObjsPal0
	dw .WaitObj1ThenFlash
	dw .FadeThenNextSceneStep
	dw .TransformHammerBot
	dw .FadeThenNextSceneStep
	dw .ShowDoughnuteer
	dw .SetObjsPal3
	dw .WaitObj1ThenFlash
	dw .FadeThenNextSceneStep
	dw .TransformDoughnuteer
	dw .FadeThenNextSceneStep
	dw .Wait80
	dw .ResetObjsPalAndEnd

.PlayEpilogueMusic:
	play_music2 MUSIC_EPILOGUE
	jp .next_scene_step

.SetObjsPal4:
	ld a, $04
.set_objs_pal
	ld [wSceneObj5Attributes], a
	ld [wSceneObj6Attributes], a
	ld [wSceneObj7Attributes], a
	ld [wSceneObj8Attributes], a
	ld [wSceneObj1Attributes], a
	ld a, $01
	ld [wSceneAuxStep], a
	jp .next_scene_step

.WaitObj1ThenFlash:
	ld a, [wSceneObj1YCoord]
	cp $50
	ret c
	play_sfx SFX_PAGE_TURN
	call CopyTempPalsToBGOBPals_Bank2b1
	call FillTempPals2White
	jp .next_scene_step

.TransformSpearhead:
	ld a, $02
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld hl, wSceneObj9XCoord
	dec [hl]
.transformed
	xor a
	ld [wSceneObj1State], a
	call .load_epilogue_pals
	jp .next_scene_step

.ShowHammerBot:
	ld a, [bc]
	cp $50
	ret c
	ld a, $19
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld a, $48
	ld [wSceneObj9XCoord], a
	call .load_extra_ob_pals
	ld de, PalConfig_OBFromTempPals2
	call SetPalConfig2FromDE
	jp .next_scene_step

.SetObjsPal0:
	xor a
	jr .set_objs_pal

.TransformHammerBot:
	ld a, $03
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld hl, wSceneObj9XCoord
	dec [hl]
	jr .transformed

.ShowDoughnuteer:
	ld a, [bc]
	cp $50
	ret c
	ld a, $1a
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld a, $58
	ld [wSceneObj9XCoord], a
	call .load_extra_ob_pals
	ld de, PalConfig_OBFromTempPals2
	call SetPalConfig2FromDE
	jp .next_scene_step

.SetObjsPal3:
	ld a, $03
	jp .set_objs_pal

.TransformDoughnuteer:
	ld a, $04
	ld hl, wSceneObj9State
	call SetSceneObjState
	ld hl, wSceneObj9XCoord
	dec [hl]
	dec [hl]
	jr .transformed

.Wait80:
	ld a, [bc]
	cp $50
	ret c
	jp .next_scene_step

.ResetObjsPalAndEnd:
	xor a
	ld [wSceneObj5Attributes], a
	ld [wSceneObj6Attributes], a
	ld [wSceneObj7Attributes], a
	ld [wSceneObj8Attributes], a
	ld [wSceneObj1Attributes], a
	jp .end_scene_steps

.MoveClouds:
	ld hl, wSceneObj10State
	ld a, [hl]
	cp $1b
	ret nz
	call .move_cloud1
	call .move_cloud2
	call .move_cloud3
	call .move_cloud4
	ret

.move_cloud1:
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld a, $07
	xor l
	ld l, a
	inc [hl]
	ret

.move_cloud2:
	ld hl, wSceneObj11State
	ld a, [hl]
	cp $1c
	ret nz
	ld a, [wGlobalCounter]
	and %111
	ret nz
	ld a, $07
	xor l
	ld l, a
	inc [hl]
	ret

.move_cloud3:
	ld hl, wSceneObj12State
	ld a, [hl]
	cp $1b
	ret nz
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld a, $07
	xor l
	ld l, a
	inc [hl]
	ret

.move_cloud4:
	ld hl, wSceneObj13State
	ld a, [hl]
	cp $1c
	ret nz
	ld a, [wGlobalCounter]
	and %111
	ret nz
	ld a, $07
	xor l
	ld l, a
	inc [hl]
	ret

	ds $6eb, $00
