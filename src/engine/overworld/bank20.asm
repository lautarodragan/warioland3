GolfBuilding:
	farcall _GolfBuilding
	ret

UpdateGolfBuilding:
	farcall _UpdateGolfBuilding
	ret

InitEpilogue:
	farcall _InitEpilogue
	ret

UpdateEpilogue:
	farcall _UpdateEpilogue
	ret

SaveGameAfterEpilogue:
	call SaveGameOnReturnFromLevel
	ret

HandleMapSide:
	call ProcessDPadRepeat
	farcall UpdateMapSideOWAnimations
	farcall UpdateCommonOWAnimations

	call UpdateTopBar
	ld a, [wOWBarsState]
	and a
	jp nz, UpdateOWObjsAndWario

	call HandleBottomBar
	call DrawBottomBar

	farcall FadeOutLevelName
	ld hl, wOWStepCounter
	inc [hl]
	ld a, [wOWStep]
	jumptable

	dw MapSide_Init
	dw MapSide_DayNightTransition
	dw MapSide_ArriveAtLevel
	dw MapSide_LoadLevelName
	dw MapSide_FadeInLevelName
	dw MapSide_Idle
	dw MapSide_StartPath
	dw MapSide_Walk
	dw MapSide_WalkOffEdge
	dw MapSide_ChangeSide
	dw MapSide_TempleHint

MapSide_Init:
	call PlaceOWWarioAtCurLevel
	call GetOWAllowedDPadInput
	ld a, [wMapSideLevelID]
	ld [wLevel2], a
	ld [wTargetMapSideLevelID], a
	xor a
	ld [wPalConfig1TotalSteps], a
	ld [wLevelNameFadeState], a
	ld [wOWPalTransitionState], a
	call UpdateOWObjsAndWario
	ld hl, wOWStepCounter
	xor a
	ld [hl], a
	ld hl, wOWStep
	inc [hl]
	ret

MapSide_DayNightTransition:
	ld a, [wDayNight]
	bit 7, a
	jr nz, .transition
	call PlayOverworldMusic
	call UpdateOWObjsAndWario
	ld hl, wOWStep
	inc [hl]
	ret
.transition
	farcall DayNightTransition
	call UpdateOWObjsAndWario
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	di
	call VBlank_Overworld
	ei
	ret

MapSide_ArriveAtLevel:
	xor a
	ld [wMagnifyingGlassCounter], a
	call PlaceOWWarioAtCurLevel
	call GetOWAllowedDPadInput
	ld c, $00
	ld b, $00
	ld a, [wMapSideLevelID]
	set B_PAD_LEFT, c
	cp OW_EXIT_RIGHT
	jr z, .is_exit
	ld c, b
	set B_PAD_RIGHT, c
	cp OW_EXIT_LEFT
	jr z, .is_exit

	call LoadMapLevelFromLevelIndex
	farcall LoadMapLevelTreasureData

	xor a
	ld [wOWStepCounter], a
	call .GetDirectionalInput
	ld b, a
	ld a, [wOWAllowedDPadInput]
	and b
	and a
	jr z, .not_allowed
	ld hl, wOWStep
	ld [hl], $05
	jp MapSide_StartWalking

.not_allowed
	call UpdateOWObjsAndWario
	xor a
	ld [wLevelArrowDirections1], a
	ld [wOWWarioRunCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

.is_exit
	ld a, c
	ld [wLevelArrowDirections1], a
	call SetPathFromArrowDirection
	call UpdateOWObjsAndWario
	xor a
	ld [wOWStepCounter], a
	ld a, $06
	ld [wOWStep], a
	ret

.GetDirectionalInput:
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	ld b, a
	rla
	jr c, .up_down ; down
	rla
	jr c, .up_down ; up
; right/left
	ld a, b
	ret
.up_down
	ld a, PAD_UP | PAD_DOWN
	and b
	ret

MapSide_LoadLevelName:
	call UpdateOWObjsAndWario
	ld a, [wLevelNameFadeState]
	and a
	ret nz
	call LoadLevelNameIfValid
	ld hl, wOWStep
	inc [hl]
	ret

LoadLevelNameIfValid:
	ld a, [wNextMapSide]
	ld b, a
	ld a, [wMapSideLevelID]
	ld d, a
	cp $08
	ret nc
	jp LoadLevelName

MapSide_FadeInLevelName:
	call UpdateOWObjsAndWario
	ld a, [wMapSideLevelID]
	cp OW_EXITS
	jr nc, .next_step
	farcall FadeInLevelName
	srl c
	ret c
.next_step
	ld hl, wOWStep
	inc [hl]
	ret

MapSide_Idle:
	call HandleEnterLevelInput
	jr c, UpdateOWObjsAndWario
	ld a, [wOWPalTransitionState]
	and a
	jr nz, UpdateOWObjsAndWario
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr nz, .check_other_input
	ld a, [wJoypadPressed]
	bit B_PAD_SELECT, a
	jr z, .check_other_input
	ld hl, wOWBarsState
	inc [hl]
	jr UpdateOWObjsAndWario

.check_other_input
	call HandlePathPreview
	ld a, [wPathPreviewState]
	and a
	jr nz, UpdateOWObjsAndWario
	call HandleTempleHintInput
	jr c, UpdateOWObjsAndWario
	call HandleBestTimesInput
	jr c, UpdateOWObjsAndWario
	call GetPressedOWDirection
	ld b, a
	ld a, [wOWAllowedDPadInput]
	and b
	and a
	jr z, UpdateOWObjsAndWario
;	fallthrough

MapSide_StartWalking:
	ld [wLevelArrowDirections1], a
	call SetPathFromArrowDirection
	ld a, [wTargetMapSideLevelID]
	ld [wLevel2], a
	ld a, $03
	ld [wLevelNameFadeState], a
	xor a
	ld [wPalConfig1TotalSteps], a
	call UpdateOWObjsAndWario
	xor a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

UpdateOWObjsAndWario:
	farcall UpdateMapSideOWObjs_Front
	call UpdateOWWario
	farcall UpdateMapSideOWObjs_Back
	ret

HandleTempleHintInput:
	ld hl, wMapSideLevelID
	ld a, [wNextMapSide]
	or [hl]
	ret nz
	; OW position is in The Temple
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	ret z
	ld a, [wNextTreasure]
	cp TREASURES_END
	jr nz, .show_hint
	ld a, [wGameModeFlags]
	bit MODE_GAME_CLEARED_F, a
	ret nz
.show_hint
	call ClearUnused_2d0c0
	ld a, OWWARIO_UP
	call SetOWWarioOAM
	play_sfx SFX_ACTION_B
	ld a, $0a
	ld [wOWStep], a
	scf
	ret

GetPressedOWDirection:
	ld a, [wJoypadPressed]
	and PAD_CTRL_PAD
	ld b, a
	rla
	jr c, .up_down
	rla
	jr c, .up_down
	ld a, b
	ret
.up_down
	ld a, PAD_UP | PAD_DOWN
	and b
	ret

MapSide_StartPath:
	ld a, [wOWYCoord1]
	ld [wOWYCoord2], a
	ld a, [wOWXCoord1]
	ld [wOWXCoord2], a

	ld a, [wTargetMapSideLevelID]
	call GetMapLevelCoords
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	add b
	ld [wOWPathTargetYCoord], a
	ld a, [hli]
	add c
	ld [wOWPathTargetXCoord], a

	ld bc, wOWPathShape
	call SetNextPathWaypoint
	call InitOWLineMovement
	call UpdateOWObjsAndWario
	xor a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

; a = map side level index
GetMapLevelCoords:
	add a ; *2
	ld c, a
	ld a, [wCurMapSide]
	ld hl, MapLevelCoords
	call GetCthWordFromAthTable
	ret

; input:
; - bc = ?
; - [wOWPathTargetYCoord] = ?
; - [wOWPathTargetXCoord] = ?
; output:
; - [wOWYCoord2] = ?
; - [wOWXCoord2] = ?
SetNextPathWaypoint:
	ld a, [bc]
	jumptable
	table_width 2
	dw .PathNone    ; PATH_NONE
	dw .PathBeeline ; PATH_BEELINE
	dw .PathYThenX  ; PATH_Y_THEN_X
	dw .PathXThenY  ; PATH_X_THEN_Y
	dw .PathSShape  ; PATH_S_SHAPE
	assert_table_length NUM_PATH_SHAPES

.PathNone:
	inc c
	ld a, $ff
	ld [bc], a
	ret

; sets:
; wOWYCoord2 = wOWPathTargetYCoord
; wOWXCoord2 = wOWPathTargetXCoord
.PathBeeline:
	ld a, [wOWPathTargetYCoord]
	ld [wOWYCoord2], a
	ld a, [wOWPathTargetXCoord]
	ld [wOWXCoord2], a
	xor a
	ld [bc], a
	ret

; sets wOWYCoord2 = wOWPathTargetYCoord
.PathYThenX:
	ld a, [wOWPathTargetYCoord]
	ld [wOWYCoord2], a
	ld a, $01
	ld [bc], a
	ret

; sets wOWXCoord2 = wOWPathTargetXCoord
.PathXThenY:
	ld a, [wOWPathTargetXCoord]
	ld [wOWXCoord2], a
	ld a, $01
	ld [bc], a
	ret

; sets wOWXCoord2 = (wOWPathTargetXCoord - wOWXCoord1) / 2 + wOWXCoord1
.PathSShape:
	ld a, [wOWXCoord1]
	ld e, a
	ld a, [wOWPathTargetXCoord]
	sub e
	sra a
	add e
	ld [wOWXCoord2], a
	ld a, $02
	ld [bc], a
	ret

SetOWWarioWalkDirection:
	ld hl, wOWLineFlags
	bit 0, [hl]
	jr nz, .horizontal
	ld a, $40
	bit 1, [hl]
	jr z, .rotate_dir
	jr .done
.horizontal
	ld a, $10
	bit 2, [hl]
	jr z, .done
.rotate_dir
	rlca
.done
	ld [wLevelArrowDirections1], a
	ret

MapSide_Walk:
	call StepOWLineMovement
	ld hl, wOWWarioRunCounter
	bit 7, [hl]
	jr nz, .run_step

	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	jr z, .check_running
	inc [hl]
	ld a, [hl]
	cp $06
	jr c, .check_running
	set 7, [hl]
.check_running
	bit 7, [hl]
.run_step
	call nz, StepOWLineMovement

	ld a, [wOWYCoord1]
	ld [wOWWarioYCoord], a
	ld a, [wOWXCoord1]
	ld [wOWWarioXCoord], a
	ld a, [wOWLineStepsLeft]
	and a
	jr nz, .update_objs
	ld bc, wOWPathShape
	call SetNextPathWaypoint
	cp $ff
	jr z, .path_done
	call InitOWLineMovement
	call SetOWWarioWalkDirection
.update_objs
	call UpdateOWObjsAndWario
	ret

.path_done
	ld a, [wTargetMapSideLevelID]
	ld [wMapSideLevelID], a
	cp OW_EXITS
	jr nc, .walked_to_exit
	ld a, $02
	ld [wOWStep], a
	jr .update_objs

.walked_to_exit
	stop_music2
	play_sfx SFX_PAGE_TURN

	xor a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	jr .update_objs

MapSide_WalkOffEdge:
	ld a, [wOWStepCounter]
	cp $02
	jr c, .update_objs
	xor a
	ld [hl], a
	ld a, [wMapSideLevelID]
	ld b, $01
	ld c, $a8
	cp OW_EXIT_RIGHT
	jr z, .is_exit
	ld b, $ff
	ld c, $f0
	cp OW_EXIT_LEFT
	jr z, .is_exit
	debug_nop
.is_exit
	ld a, [wOWWarioXCoord]
	add b
	ld [wOWWarioXCoord], a
	cp c
	jr nz, .update_objs
	ld hl, wOWStep
	inc [hl]
.update_objs
	call UpdateOWObjsAndWario
	ret

MapSide_ChangeSide:
	call UpdateOWObjsAndWario
	ld a, [wMapSideLevelID]
	ld b, 1
	cp OW_EXIT_RIGHT
	jr z, .is_exit
	ld b, -1
	cp OW_EXIT_LEFT
	jr z, .is_exit
	debug_nop
.is_exit
	ld a, [wNextMapSide]
	add b
	and $3
	ld [wNextMapSide], a
	ld a, [wMapSideLevelID]
	add b
	ld [wMapSideLevelID], a
	ld [wTargetMapSideLevelID], a
	ld a, [wNextMapSide]
	bit 1, a
	jr nz, .map_side ; south or east?
	add b
	bit 1, a
	jr nz, .golf_building
.map_side
	ld a, SST_OVERWORLD_MAP_SIDE
	ld [wSubState], a
	ret
.golf_building
	ld a, SST_OVERWORLD_TO_GOLF_BUILDING
	ld [wSubState], a
	ret

HandleEnterLevelInput:
	ld a, [wOWPalTransitionState]
	and a
	jr nz, .no_carry
	ld a, [wOWLevel]
	cp $80
	jr z, .no_carry
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .no_carry
	call LoadMapLevelFromLevelIndex
	ld a, [wOWLevel]
	and a
	jr z, .temple
	xor a
	ld [wSubState], a
	ld hl, wState
	inc [hl] ; ST_LEVEL
	scf
	ret

.no_carry
	and a
	ret

.temple
	play_sfx SFX_SELECTION
	ld a, SST_OVERWORLD_TEMPLE
	ld [wSubState], a
	scf
	ret

; input:
; - b = LEVEL_* constant
; output:
; - d = map side level index
; - b and c = map side
GetMapLevelID:
; loop until a larger value than b is found
	ld hl, MapSideInitialLevels
	ld c, -1
.loop
	ld e, [hl]
	inc hl
	inc c
	ld a, [hl]
	dec a
	cp b
	jr c, .loop
; next calculate the difference
; from the previous entry in list
	ld a, b
	sub e
	ld d, a ; difference
	ld b, c ; list index
	ret

; converts the level index in wMapSideLevelID
; to a valid OW level value corresponding
; to the map side in wNextMapSide
LoadMapLevelFromLevelIndex:
	ld a, [wNextMapSide]
	ld c, a
	and a
	jr z, .north
.get_ow_level
	ld b, $00
	ld hl, MapSideInitialLevels
	add hl, bc
	ld a, [wMapSideLevelID]
	add [hl]
	ld [wOWLevel], a
	ret

.north
	ld a, [wMapSideLevelID]
	cp OWNORTH_JUNCTION
	jr c, .get_ow_level
	ld a, $80
	ld [wOWLevel], a
	ret

MapSideInitialLevels:
	db LEVEL_THE_TEMPLE         ; NORTH
	db LEVEL_DESERT_RUINS       ; WEST
	db LEVEL_THE_GRASSLANDS     ; SOUTH
	db LEVEL_THE_STAGNANT_SWAMP ; EAST

; unreferenced
UnreferencedGetMapSideLastLevel:
	ld hl, .data
	ld a, [wNextMapSide]
	ld b, $00
	ld c, a
	add hl, bc
	ld c, [hl]
	ret

.data
	db $06 ; NORTH
	db $05 ; WEST
	db $05 ; SOUTH
	db $06 ; EAST

; when game is cleared, show indicators on level
; where some treasures are still missing
ShowMissingTreasureIndicators:
	ld a, [wMissingTreasureIndicatorsEnabled]
	and a
	ret z ; game not cleared OR all treasures collected
	ld a, [wOWLevel]
	ld [w2dffd], a
	ld a, [wCurMapSide]
	ld c, a
	ld b, $00
	ld hl, MapSideInitialLevels
	add hl, bc
	ld a, [hl]
	ld [wOWLevel], a

	ld a, [wNextMapSide]
	ld b, NUM_WEST_LEVELS
	dec a
	jr z, .got_level_count ; west
	ld b, NUM_SOUTH_LEVELS
	dec a
	jr z, .got_level_count ; south
	ld b, NUM_EAST_LEVELS
	dec a
	jr z, .got_level_count ; east
	ld b, NUM_NORTH_LEVELS
.got_level_count
	ld a, b
	ld [w2dfff], a
	xor a
	ld [w2dffe], a

	; if in North, skip The Temple
	ld a, [wOWLevel]
	and a
	jr z, .skip_level
.loop_levels
	farcall GetOWLevelCollectedTreasures
	ld a, [wKeyAndTreasureFlags]
	and TREASURES_MASK
	xor TREASURES_MASK
	; nz means at least 1 treasure missing
	call nz, .PlaceTreasureMissingIndicator
.skip_level
	ld a, [wOWLevel]
	inc a
	ld [wOWLevel], a
	ld hl, w2dffe
	inc [hl]
	ld a, [hli]
	cp [hl] ; w2dfff
	jr nz, .loop_levels
	ld a, [w2dffd]
	ld [wOWLevel], a
	ret

.PlaceTreasureMissingIndicator:
	ld a, [w2dffe]
	call GetMapLevelCoords
	ld a, [hli]
	ld [wOWYCoord1], a
	ld a, [hl]
	ld [wOWXCoord1], a
	ld hl, wOWCoords1
	call GetOWCoordInTilemap
	ld [hl], $7b ; tile index
	dec h
	dec h
	dec h
	ld [hl], $0d ; attribute
	ret

MapSide_TempleHint:
	farcall FadeOutLevelName
	call UpdateTempleHint
	farcall UpdateMapSideOWObjs_Front
	call DrawOWWario
	farcall UpdateMapSideOWObjs_Back
	ret

UpdateTempleHint:
	ld hl, wTempleHintCounter
	inc [hl]
	ld a, [wTempleHintState]
	jumptable

	dw AdvanceTempleHint
	dw TempleHint_WaitThenFadeOutName
	dw TempleHint_WaitNameFadedOut
	dw TempleHint_LoadNextTreasureLevelName
	dw TempleHint_ResetPalFade
	dw TempleHint_FadeInName
	dw TempleHint_ResetPalFade
	dw TempleHint_WaitInput
	dw TempleHint_WaitThenFadeOutName
	dw TempleHint_WaitNameFadedOut
	dw TempleHint_End

AdvanceTempleHint:
	xor a
	ld hl, wTempleHintCounter
	ld [hld], a
	inc [hl] ; wTempleHintState
	ret

TempleHint_WaitThenFadeOutName:
	ld hl, wTempleHintCounter
	ld a, [hl]
	cp $08
	ret c
	ld a, $03
	ld [wLevelNameFadeState], a
	jr AdvanceTempleHint

TempleHint_WaitNameFadedOut:
	ld a, [wLevelNameFadeState]
	and a
	ret nz
	jr AdvanceTempleHint

TempleHint_LoadNextTreasureLevelName:
	call GetMapSideAndLevelForNextTreasure
	call LoadLevelName
	jr AdvanceTempleHint

GetMapSideAndLevelForNextTreasure:
	ld a, [wNextTreasure]
	cp TREASURES_END
	jr z, .no_more_treasures
	ld b, a
	call GetEventWithTreasure
	ld a, EVENT_GOLD_MUSIC_BOX
	cp c
	jr nc, .get_level
	ld a, [wGameModeFlags]
	bit MODE_GAME_CLEARED_F, a
	jr nz, .get_level
.no_more_treasures
	ld b, NORTH
	ld d, OWNORTH_THE_TEMPLE
	ret
.get_level
	ld a, [wNextTreasure]
	ld c, a
	farcall GetLevelThatContainsTreasure
	call GetMapLevelID
	ret

TempleHint_ResetPalFade:
	xor a
	ld [wPalConfig1TotalSteps], a
	jp AdvanceTempleHint

TempleHint_FadeInName:
	farcall FadeInLevelName
	srl c
	ret c
	ld a, $1c
	ld hl, wSceneObj13State
	call SetSceneObjState
	jp AdvanceTempleHint

TempleHint_WaitInput:
	ld a, [wJoypadPressed]
	and PAD_B | PAD_RIGHT | PAD_LEFT | PAD_DOWN
	jr nz, .close_hint
	ld hl, wSceneObj13State
	ld a, [hl]
	and a
	jp z, AdvanceTempleHint
	ret
.close_hint
	xor a
	ld hl, wSceneObj13State
	call SetSceneObjState
	jp AdvanceTempleHint

TempleHint_End:
	ld a, OWWARIO_DOWN
	call SetOWWarioOAM
	xor a
	ld [wOWStep], a
	ld [wOWStepCounter], a
	ld [wTempleHintState], a
	ret

; unreferenced
UnreferencedPathPreviewFromLevel:
	ld hl, wOWWarioSavedYCoord
	ld a, [wOWWarioYCoord]
	ld [hli], a ; wOWWarioSavedYCoord
	ld a, [wOWWarioXCoord]
	ld [hl], a ; wOWWarioSavedXCoord
	ld a, [wOWLevelYCoord]
	ld [wOWYCoord1], a
	ld [wOWWarioYCoord], a
	ld a, [wOWLevelXCoord]
	ld [wOWXCoord1], a
	ld [wOWWarioXCoord], a
	call .RunTracerStep
	ld hl, wOWWarioSavedYCoord
	ld a, [hli] ; wOWWarioSavedYCoord
	ld [wOWYCoord1], a
	ld [wOWWarioYCoord], a
	ld a, [hl] ; wOWWarioSavedXCoord
	ld [wOWXCoord1], a
	ld [wOWWarioXCoord], a
	ret

.RunTracerStep:
	ld a, [wPathPreviewState]
	jumptable
	dw PathPreview_InitTracers
	dw PathPreview_RunTracers

HandlePathPreview:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr z, .no_b_btn
	ld hl, wPathPreviewCounter
	inc [hl]
	ld a, [wPathPreviewState]
	jumptable
	dw PathPreview_SaveWarioPos
	dw PathPreview_Wait
	dw PathPreview_InitTracers
	dw PathPreview_RunTracers

.no_b_btn
	ld a, [wPathPreviewState]
	and a
	ret z
	ld a, OWWARIO_DOWN
	ld hl, wOWWarioSprite
	cp [hl]
	call nz, SetOWWarioOAM
	ld hl, wOWWarioSavedYCoord
	ld a, [hli] ; wOWWarioSavedYCoord
	ld [wOWYCoord1], a
	ld [wOWWarioYCoord], a
	ld a, [hl] ; wOWWarioSavedXCoord
	ld [wOWXCoord1], a
	ld [wOWWarioXCoord], a
	xor a
	ld [wPathPreviewState], a
	ret

PathPreview_SaveWarioPos:
	ld hl, wOWWarioSavedYCoord
	ld a, [wOWWarioYCoord]
	ld [hli], a ; wOWWarioSavedYCoord
	ld a, [wOWWarioXCoord]
	ld [hl], a ; wOWWarioSavedXCoord
;	fallthrough

AdvancePathPreview:
	xor a
	ld hl, wPathPreviewCounter
	ld [hli], a
	inc [hl] ; wPathPreviewState
	ret

PathPreview_Wait:
	ld b, $0a
	ld a, [wPathPreviewCounter]
	cp b
	ret c
	play_sfx SFX_ACTION_B
	ld a, [wOWLevelYCoord]
	ld [wOWYCoord1], a
	ld [wOWWarioYCoord], a
	ld a, [wOWLevelXCoord]
	ld [wOWXCoord1], a
	ld [wOWWarioXCoord], a
	ld a, OWWARIO_ARROWS
	call SetOWWarioOAM
	jr AdvancePathPreview

PathPreview_InitTracers:
	xor a
	ld hl, w2d800
	ld bc, $8e
	call WriteAToHL_BCTimes
	ld hl, wOWUIObj1
	ld bc, $40
	call WriteAToHL_BCTimes
	call GetCurLevelPathsPtr
	ld a, l
	ld [wPathPreviewPathsPtr + 0], a
	ld a, h
	ld [wPathPreviewPathsPtr + 1], a
	jr AdvancePathPreview

PathPreview_RunTracers:
	ld a, $00
	call .load_tracer
	call .UpdateTracer
	call .save_tracer
	ld a, $01
	call .load_tracer
	call .UpdateTracer
	call .save_tracer
	ld a, $02
	call .load_tracer
	call .UpdateTracer
	call .save_tracer
	ld a, $03
	call .load_tracer
	call .UpdateTracer
	call .save_tracer

	ld a, [wPathPreviewCounter]
	cp $14
	call z, .copy_tracer_sprites_1
	ld a, [wPathPreviewCounter]
	cp $28
	call z, .copy_tracer_sprites_2
	ld a, [wPathPreviewCounter]
	cp $2c
	ld hl, wOWUIObj1State
	call z, .clear_tracer_sprites
	ld a, [wPathPreviewCounter]
	cp $40
	ld hl, w2d160 + $6
	call z, .clear_tracer_sprites
	call UpdatePathPreviewAnimations

	ld hl, w2d800 + $7
	ld c, $04
.loop
	ld a, [hl]
	cp $05
	ret nz
	ld de, $20
	add hl, de
	dec c
	jr nz, .loop

	ld hl, wPathPreviewState
	dec [hl]
	ret

.load_tracer:
	ld [wCurOWPathTracerIndex], a
	call .get_tracer_ptr
	ld de, w2d880
	ld b, $9
	call CopyHLToDE
	ld de, wOWLineFlags
	ld b, $7
	call CopyHLToDE
	ld de, wOWCoords1
	ld b, $8
	call CopyHLToDE
	ret

.save_tracer:
	ld a, [wCurOWPathTracerIndex]
	call .get_tracer_ptr
	ld e, l
	ld d, h
	ld hl, w2d880
	ld b, $9
	call CopyHLToDE
	ld hl, wOWLineFlags
	ld b, $07
	call CopyHLToDE
	ld hl, wOWCoords1
	ld b, $08
	call CopyHLToDE
	ret

; input:
; - a = index
; output:
; - hl = w2d800 struct
.get_tracer_ptr:
	rlca
	swap a ; *32
	ld e, a
	ld d, $00
	ld hl, w2d800
	add hl, de
	ret

.copy_tracer_sprites_1:
	ld hl, w2d800
	ld de, wOWUIObj1
	ld b, $08
	call CopyHLToDE
	ld hl, wOWPathTracer2
	ld b, $08
	call CopyHLToDE
	ld hl, wOWPathTracer3
	ld b, $08
	call CopyHLToDE
	ld hl, wOWPathTracer4
	ld b, $08
	call CopyHLToDE
	ret

.copy_tracer_sprites_2:
	ld hl, w2d800
	ld de, w2d160
	ld b, $08
	call CopyHLToDE
	ld hl, wOWPathTracer2
	ld b, $08
	call CopyHLToDE
	ld hl, wOWPathTracer3
	ld b, $08
	call CopyHLToDE
	ld hl, wOWPathTracer4
	ld b, $08
	call CopyHLToDE
	ret

.clear_tracer_sprites:
	ld de, $8
	xor a
	ld [hl], a
	add hl, de
	ld [hl], a
	add hl, de
	ld [hl], a
	add hl, de
	ld [hl], a
	ret

.UpdateTracer:
	ld a, [w2d880 + $7]
	jumptable
	dw .TracerInit ; $0
	dw .TracerGetTarget ; $1
	dw .TracerStartLine ; $2
	dw .TracerWalk ; $3
	dw .TracerWait8 ; $4
	dw .TracerDone ; $5

.TracerInit:
	ld a, [wOWWarioYCoord]
	ld d, a
	ld a, [wOWWarioXCoord]
	ld e, a
	ld b, $08
	ld a, [wCurOWPathTracerIndex]
	inc a
	bit 1, a
	jr z, .got_offset_sign
	ld b, $f8
.got_offset_sign
	cp $03
	jr nc, .offset_y
	ld a, e
	add b
	ld e, a
	jr .set_tracer_pos
.offset_y
	ld a, d
	add b
	ld d, a
.set_tracer_pos
	ld a, d
	ld [w2d880 + $0], a
	ld [wOWYCoord1], a
	ld [wOWYCoord2], a
	ld [wOWPathTargetYCoord], a
	ld a, e
	ld [w2d880 + $1], a
	ld [wOWXCoord1], a
	ld [wOWXCoord2], a
	ld [wOWPathTargetXCoord], a
	ld hl, w2d880 + $4
	xor a
	ld [hli], a
	ld [hli], a
	ld a, [wCurOWPathTracerIndex]
	inc a
	ld b, a
	ld c, a
	ld a, [wOWAllowedDPadInput]
	swap a
.loop_shift_dpad
	rrca
	dec b
	jr nz, .loop_shift_dpad
	ld a, $00
	jr nc, .set_allowed
	ld a, c
.set_allowed
	ld [hl], a
.next_tracer_state
	ld hl, w2d880 + $7
	inc [hl]
	ret

.TracerGetTarget:
	ld a, [w2d880 + $6]
	and a
	jr z, .tracer_done
	ld hl, w2d880 + $9
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCurOWPathTracerIndex]
	ld e, a
	ld d, $00
	add hl, de
	ld b, [hl]
	ld de, $4
	add hl, de
	ld a, [hl]
	ld [wOWPathShape], a
	ld a, b
	cp $80
	jr z, .tracer_done
	call GetMapLevelCoords
	ld a, [hli]
	ld [wOWPathTargetYCoord], a
	ld a, [hl]
	ld [wOWPathTargetXCoord], a
	jr .next_tracer_state
.tracer_done
	ld a, $05
	ld [w2d880 + $7], a
	ret

.TracerStartLine:
	ld bc, wOWPathShape
	call SetNextPathWaypoint
	call InitOWLineMovement
	jr .next_tracer_state

.TracerWalk:
	call StepOWLineMovement
	ld a, [wOWYCoord1]
	ld [w2d880 + $0], a
	ld a, [wOWXCoord1]
	ld [w2d880 + $1], a
	ld a, [wOWLineStepsLeft]
	and a
	ret nz
	ld bc, wOWPathShape
	call SetNextPathWaypoint
	cp $ff
	jr z, .end_of_path
	call InitOWLineMovement
	call .set_tracer_sprite
	ret
.end_of_path
	xor a
	ld [w2d880 + $8], a
	jp .next_tracer_state

.TracerWait8:
	ld hl, w2d880 + $8
	inc [hl]
	ld a, [hl]
	cp $08
	ret c
	jp .next_tracer_state

.TracerDone:
	ret

.set_tracer_sprite:
	ld hl, wOWLineFlags
	bit 0, [hl]
	jr nz, .horizontal
	ld a, $03
	bit 1, [hl]
	jr z, .inc_sprite_state
	jr .set_sprite_state
.horizontal
	ld a, $01
	bit 2, [hl]
	jr z, .set_sprite_state
.inc_sprite_state
	inc a
.set_sprite_state
	ld hl, w2d880 + $6
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a
	ret

UpdatePathPreviewAnimations:
	ld hl, wDayNightTransistionSteps
	call .animate_and_draw
	ld hl, wPalFade1Colour1BlueUnk3
	call .animate_and_draw
	ld hl, wPalFade1Colour3RedUnk3
	call .animate_and_draw
	ld hl, wPalFade1Colour4GreenUnk3
	call .animate_and_draw
	ld hl, wOWUIObj1State
	call .animate_and_draw
	ld hl, wOWUIObj2State
	call .animate_and_draw
	ld hl, wd156
	call .animate_and_draw
	ld hl, w2d15e
	call .animate_and_draw
	ld hl, wOWUIObj5State
	call .animate_and_draw
	ld hl, w2d16e
	call .animate_and_draw
	ld hl, wOWUIObj7State
	call .animate_and_draw
	ld hl, w2d17e
	call .animate_and_draw
	ret

.animate_and_draw:
	ld a, [hld]
	and a
	ret z
	ld bc, .framesets
	dec a
	add a
	add c
	ld c, a
	ld a, $00
	adc b
	ld b, a
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec l
	ld b, $2a
	call UpdateOWAnimation
	ld a, $f8
	and l
	ld l, a
	ld de, OWUIOAM_aa0cf
	ld b, BANK(OWUIOAM_aa0cf)
	call LoadOWSpriteWithScroll
	ret

.framesets
	dw PathPreviewFrameset_aa26a
	dw PathPreviewFrameset_aa267
	dw PathPreviewFrameset_aa261
	dw PathPreviewFrameset_aa264

SetDayNightSpellSelectable:
	ld a, DAY_OR_NIGHT_SPELL
	call IsTreasureCollected
	ret z
	ld a, [wCurMapSide]
	cp EAST
	jr nz, .set_selectable
	ld a, [wGotSunMedallion]
	and a
	ret z
.set_selectable
	ld hl, wTopBarSelectableButtons
	set TOPBAR_DAY_NIGHT_F, [hl]
	ret

SetCutsceneButtonSelectable:
	ld a, [wStoredTransitionParam]
	cp TRANSITION_RETURN_TO_MAP
	ret z ; no playable cutscene
SetCutsceneButtonSelectable_GotTransitionParam:
	and a
	ret z ; invalid param for cutscene
	ld hl, wTopBarSelectableButtons
	set TOPBAR_CUTSCENE_F, [hl]
	ret

; unreferenced
UnreferencedSetLastEventCutsceneSelectable:
	ld a, [wGameModeFlags]
	bit MODE_GAME_CLEARED_F, a
	ret nz
	ld a, EVENT_PROLOGUE
.loop
	ld [wCheckedEvent], a
	call CheckIfEventIsUnlocked
	ld a, [wCheckedEvent]
	jr z, .got_event
	inc a
	ld b, EVENT_BLUE_CRAYON
	cp b
	jr c, .loop
	ld a, b
.got_event
	dec a
	call LoadEventTreasures
	ld a, [w2dfff]
	ld [wStoredTransitionParam], a
	jr SetCutsceneButtonSelectable_GotTransitionParam

SetNextPrevMapButtonsSelectable:
	call .CheckAccessibleMapSides
	call GetAccessibleMapFlags
	ld hl, wTopBarSelectableButtons
	or [hl]
	ld [hl], a
	ret

.CheckAccessibleMapSides:
	; check west side accessible
	ld a, EVENT_OPEN_NORTH_GATE
	call CheckIfEventIsUnlocked
	rlca
	rlca
	rlca
	ld hl, wAccessibleMapSides
	or [hl]
	ld [hl], a

	; check south side accessible
	ld a, EVENT_FIX_ELEVATOR
	call CheckIfEventIsUnlocked
	rlca
	rlca
	ld hl, wAccessibleMapSides
	or [hl]
	ld [hl], a

	; check east side accessible
	ld a, EVENT_BLOW_MIST
	call CheckIfEventIsUnlocked
	rlca
	ld hl, wAccessibleMapSides
	or [hl]
	ld [hl], a

	; check north side accessible
	ld a, EVENT_TORCH_FOREST
	call CheckIfEventIsUnlocked
	ld hl, wAccessibleMapSides
	or [hl]
	ld [hl], a
	and $1
	swap a
	or [hl]
	ld [hl], a
	ret

GetAccessibleMapFlags:
	ld a, [wAccessibleMapSides]
	ld b, a
	ld a, [wCurMapSide]
.loop
	sub 1
	jr c, .done
	sla b
	jr .loop
.done
	ld a, b
	and TOPBAR_NEXT_MAP | TOPBAR_PREV_MAP
	ret

UpdateNextPrevMapButtonsSelectable:
	ld a, [wOWBarsState]
	and a
	ret z
	ld a, [wTopBarSelection]
	and TOPBAR_NEXT_MAP | TOPBAR_PREV_MAP
	ret z
	ld c, a
	call GetAccessibleMapFlags
	and c
	ret nz
	ld hl, wTopBarSelection
	bit TOPBAR_NEXT_MAP_F, [hl]
	jr nz, .set_prev
; set next
	res TOPBAR_PREV_MAP_F, [hl]
	set TOPBAR_NEXT_MAP_F, [hl]
	ret
.set_prev
	res TOPBAR_NEXT_MAP_F, [hl]
	set TOPBAR_PREV_MAP_F, [hl]
	ret

GetNextTreasureToCollect:
	ld a, [wNextTreasure]
	call IsTreasureCollected
	ld hl, wNextTreasure
	jr nz, .collected
	ld a, [wTransitionParam]
	and a
	ret z
	cp TRANSITION_RETURN_TO_MAP
	ret z
	cp TRANSITION_EPILOGUE_NOT_PERFECT
	ret z
	cp TRANSITION_EPILOGUE_PERFECT
	ret z
	cp TRANSITION_GAME_OVER
	ret z
	inc a
	jr z, .check_collected ; == TRANSITION_NEW_GAME
	dec a
.check_collected
	cp [hl]
	ret nz
.collected

	ld b, [hl]
	call GetEventWithTreasure
; loop until a treasure
; that hasn't been collected
; is found in the table
.next_treasure
	ld a, [hl]
	cp INVALID_TREASURE
	jr z, .check_end
	push hl
	call IsTreasureCollected
	pop hl
	jr z, .not_collected
.check_end
	ld a, [hli]
	cp TREASURES_END
	jr z, .all_collected
	jr .next_treasure
.not_collected
	ld a, [hl]
	ld [wNextTreasure], a
	ret
.all_collected
	ld a, TREASURES_END
	ld [wNextTreasure], a
	ret

; input:
; - b = * constant
; output:
; - c = EVENT_* constant
GetEventWithTreasure:
	ld c, EVENT_NONE
	ld hl, EventTreasures
.loop
	ld a, [hli]
	cp TREASURES_END
	jr z, .not_found
	cp b
	jr z, .found
	ld a, [hli]
	cp b
	jr z, .found
	ld a, [hli]
	cp b
	jr z, .found
	inc c
	jr .loop
.found
	ret
.not_found
	ld c, EVENT_NONE
	ret

RunOWScene:
	farcall UpdateCommonOWAnimations
	farcall UpdateMapSideOWAnimations

	ld a, [wOWBarsState]
	and a
	jr z, .no_top_bar
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, EndOWScene
.no_top_bar
	ld hl, wOWStepCounter
	inc [hl]
	ld a, [wOWStep]
	jumptable
	dw RunOWScene_Wait
	dw RunOWScene_DoAction
	dw RunOWScene_NextParams

RunOWScene_Wait:
	ld a, [wOWStepCounter]
	cp $04
	ret c

RunOWScene_Next:
	xor a
	ld [wOWStepCounter], a
	ld hl, wOWStep
	inc [hl]
	ret

RunOWScene_DoAction:
	call DoOWSceneAction
	ld a, [wOWSceneActionParam]
	and a
	ret nz
	jr RunOWScene_Next

RunOWScene_NextParams:
	ld a, [wOWStepCounter]
	cp $04
	ret c
	ld hl, wOWSceneParamsPtr
	call GetByteFromPointerInHL
	call GetOWSceneParams_GotPtr
	jr z, EndOWScene
	ld a, [wCurMapSide]
	ld b, a
	ld a, [wOWSceneMapSide]
	cp b
	jr nz, .other_map_side
	xor a
	ld [wOWStepCounter], a
	ld [wOWStep], a
	ret
.other_map_side
	stop_sfx
	ld a, SST_OVERWORLD_FADE_TO_OW_SCENE
	ld [wSubState], a
	ret

EndOWScene:
	stop_sfx

	ld a, [wCurEvent]
	ld b, a
	xor a
	ld [wLastTransitionParam], a
	ld [wCurEvent], a
	ld [wOWSceneAction], a
	ld [wTempOWSceneAction], a
	ld a, EVENT_EPILOGUE
	cp b
	jr z, .epilogue
	ld hl, wSubState
	inc [hl]
	call SaveGameOnReturnFromLevel
	ret
.epilogue
	ld a, SST_OVERWORLD_EPILOGUE
	ld [wSubState], a
	ret

DoOWSceneAction:
	ld a, [wOWSceneAction]
	jumptable

	dw .InvalidAction
	dw UnlockLevel ; UNLOCK_LEVEL
	dw DoOWFunction ; DO_OW_FUNC
	dw HighlightLevel ; HIGHLIGHT_LEVEL
	dw DoOWFunction ; SPECIAL_ACTION

.InvalidAction:
	debug_nop

DoOWFunction:
	farcall _DoOWFunction
	ret

; input:
; - [wLastTransitionParam] = treasure that was just collected
; output
; - nz if there's an event unlocked
; - wCurEvent = EVENT_* constant of unlocked event
CheckIfTreasureUnlocksEvent:
	ld a, [wLastTransitionParam]
	ld b, a
	xor a
	ld c, a ; EVENT_NONE
	ld [wCurEvent], a

	ld hl, EventTreasures
.loop
	ld a, [hli]
	cp TREASURES_END
	jr z, .no_event_unlocked
	cp b
	jr z, .found
	ld a, [hli]
	cp b
	jr z, .found
	ld a, [hli]
	cp b
	jr z, .found
	inc c
	jr .loop

.found
	ld a, c
	ld [wCurEvent], a
	call CheckIfEventIsUnlocked
	jr z, .no_event_unlocked
	; unlocked this event
	ret

.no_event_unlocked
	xor a ; EVENT_NONE
	ld [wCurEvent], a
	ret

; input:
; - a = EVENT_* constant
; output:
; - a = TRUE and no carry if all treasures
; for the input event have been collected
; - a = FALSE and carry set otherwise
CheckIfEventIsUnlocked:
	call LoadEventTreasures
	ld c, TRUE
	ld a, [w2dffd]
	call CheckEventTreasure
	ret c
	ld a, [w2dffe]
	call CheckEventTreasure
	ret c
	ld a, [w2dfff]
	call CheckEventTreasure
	ret

; input:
; - a = EVENT_* constant
IsEventAlreadyUnlocked:
	call CheckIfEventIsUnlocked
	and c
	ret

; returns carry and 0 in a if treasure in a
; is different from wLastTransitionParam
; and has not been collected
; else return no carry and $01 in a
CheckEventTreasure:
	cp INVALID_TREASURE
	jr z, .no_carry
	ld hl, wLastTransitionParam
	cp [hl]
	jr z, .equal
	call IsTreasureCollected
	jr nz, .no_carry
	xor a ; FALSE
	scf
	ret
.equal
	ld c, FALSE
.no_carry
	ld a, TRUE
	and a
	ret

; input:
; - a = EVENT_* constant
LoadEventTreasures:
	ld c, a
	add a
	add c ; *3
	ld e, a
	ld d, $00
	rl d
	ld hl, EventTreasures
	add hl, de
	ld de, w2dfff
	ld a, [hli]
	ld [de], a ; w2dfff
	ld a, [hli]
	dec e
	ld [de], a ; w2dffe
	ld a, [hl]
	dec e
	ld [de], a ; w2dffd
	ret

EventTreasures:
	table_width 3

; EVENT_NONE
	db INVALID_TREASURE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PROLOGUE
	db TREASURE_NONE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_CUT_TREE
	db AXE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_OPEN_NORTH_GATE
	db BLUE_TABLET
	db GREEN_TABLET
	db INVALID_TREASURE

; EVENT_EXPEL_TORNADO
	db TOP_HALF_OF_SCROLL
	db BOTTOM_HALF_OF_SCROLL
	db INVALID_TREASURE

; EVENT_LEAD_OVERALLS
	db LEAD_OVERALLS_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_RAINSTORM
	db JAR
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_FIX_ELEVATOR
	db GEAR_1
	db GEAR_2
	db INVALID_TREASURE

; EVENT_YELLOW_MUSIC_BOX
	db YELLOW_MUSIC_BOX
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PLANT_SEEDS
	db MAGIC_SEEDS
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_RAISE_TOWER
	db SKULL_RING_RED
	db SKULL_RING_BLUE
	db INVALID_TREASURE

; EVENT_SWIMMING_FLIPPERS
	db SWIMMING_FLIPPERS_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_BLOW_MIST
	db ORNAMENTAL_FAN
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_SUMMON_SNAKES
	db FLUTE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_FREEZE_SEA
	db BLUE_BOOK
	db MAGIC_WAND
	db INVALID_TREASURE

; EVENT_HEAD_SMASH_HELMET
	db HEAD_SMASH_HELMET_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_BLUE_MUSIC_BOX
	db BLUE_MUSIC_BOX
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_SUMMON_LIGHTNING
	db TRIDENT
	db YELLOW_BOOK
	db INVALID_TREASURE

; EVENT_GRAB_GLOVE
	db GRAB_GLOVE_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_FOOT_STONE
	db FOOT_OF_STONE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_VOLCANO_ERUPTION
	db TUSK_BLUE
	db TUSK_RED
	db GREEN_FLOWER

; EVENT_OPEN_BLUE_SNAKE_DOOR
	db RIGHT_GLASS_EYE
	db LEFT_GLASS_EYE
	db INVALID_TREASURE

; EVENT_GARLIC
	db GARLIC_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_GREEN_MUSIC_BOX
	db GREEN_MUSIC_BOX
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PURIFY_WATER
	db SCEPTER
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_REVEAL_CASTLE
	db LANTERN
	db MAGICAL_FLAME
	db INVALID_TREASURE

; EVENT_SUPER_JUMP_SLAM_OVERALLS
	db SUPER_JUMP_SLAM_OVERALLS_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_SUMMON_SUN
	db SUN_MEDALLION_TOP
	db SUN_MEDALLION_BOTTOM
	db INVALID_TREASURE

; EVENT_HIGH_JUMP_BOOTS
	db HIGH_JUMP_BOOTS_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_RED_MUSIC_BOX
	db RED_MUSIC_BOX
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_EXPLODE_BOMBS
	db EXPLOSIVE_PLUNGER_BOX
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_LEAVES_FALL
	db POUCH
	db EYE_OF_THE_STORM
	db INVALID_TREASURE

; EVENT_PRINCE_FROGS_GLOVES
	db PRINCE_FROGS_GLOVES_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_MAKE_WIRE
	db STATUE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_TREASURE_MAP
	db TREASURE_MAP
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_SUPER_GRAB_GLOVES
	db SUPER_GRAB_GLOVES_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_OPEN_TREE_MOUTH
	db GOLD_MAGIC
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_GOLD_MUSIC_BOX
	db GOLD_MUSIC_BOX
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_BLUE_CRAYON
	db CRAYON_BLUE_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PLACE_CART_WHEELS
	db TRUCK_WHEEL
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_BLUE_GEM
	db BLUE_GEM
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_CYAN_CRAYON
	db CRAYON_CYAN_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_GOBLET
	db GOBLET
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_CROWN
	db CROWN
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PINK_CRAYON
	db CRAYON_PINK_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_TEAPOT
	db TEAPOT
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_POCKET_PET
	db POCKET_PET
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_MAGNIFYING_GLASS
	db MAGNIFYING_GLASS
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_RAISE_ICE_BLOCKS
	db AIR_PUMP
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_ROCKET
	db ROCKET
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_YELLOW_CRAYON
	db CRAYON_YELLOW_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_UNUSED_33
	db INVALID_TREASURE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_SABER
	db SABER
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_DAY_OR_NIGHT_SPELL
	db DAY_OR_NIGHT_SPELL
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_UFO
	db UFO
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_TORCH_FOREST
	db TORCH_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_REVEAL_WARPED_VOID
	db WARP_COMPACT
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_RAISE_PIPE
	db MYSTERY_HANDLE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_REMOVE_WARPS
	db WARP_REMOVAL_APPARATUS
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_BROWN_CRAYON
	db CRAYON_BROWN_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_DEMONS_BLOOD
	db DEMONS_BLOOD
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_OPEN_PARAGOOM_CAGE
	db KEY_CARD_RED
	db KEY_CARD_BLUE
	db INVALID_TREASURE

; EVENT_COLLECT_HEART_CREST
	db HEART_CREST
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_MINICAR
	db MINICAR
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_LOCOMOTIVE
	db LOCOMOTIVE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_TELEPHONE
	db TELEPHONE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_RED_CRAYON
	db CRAYON_RED_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PLACE_PROPELLER
	db ELECTRIC_FAN_PROPELLER
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_FEED_OCTOHON
	db SAPLING_OF_GROWTH
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_GREEN_GEM
	db GREEN_GEM
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_UNUSED_46
	db INVALID_TREASURE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_UNUSED_47
	db INVALID_TREASURE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_FIGHTER_MANNEQUIN
	db FIGHTER_MANNEQUIN
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_OPEN_GOLDEN_SNAKE_DOOR
	db GOLDEN_LEFT_EYE
	db GOLDEN_RIGHT_EYE
	db INVALID_TREASURE

; EVENT_OPEN_SKY_DOOR
	db SKY_KEY
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_GREEN_CRAYON
	db CRAYON_GREEN_T
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_EXTINGUISH_FIRE
	db FIRE_DRENCHER
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_DIAMONDS_CREST
	db DIAMONDS_CREST
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_PLACE_BRICK
	db CASTLE_BRICK
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_SPRAY_IRON_WALL
	db RUST_SPRAY
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_SPADES_CREST
	db SPADES_CREST
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_MIX_CHEMICALS
	db RED_CHEMICAL
	db BLUE_CHEMICAL
	db INVALID_TREASURE

; EVENT_COLLECT_RED_GEM
	db RED_GEM
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_CLUBS_CREST
	db CLUBS_CREST
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_CUT_BALOON
	db SCISSORS
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_DRILL_HOLES
	db JACKHAMMER
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_REVEAL_DARK_ROOM
	db NIGHT_VISION_SCOPE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_SUMMON_MOON
	db FULL_MOON_GONG
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_OPEN_CRATER_HOLE
	db PICK_AXE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_COLLECT_EARTHEN_FIGURE
	db EARTHEN_FIGURE
	db INVALID_TREASURE
	db INVALID_TREASURE

; EVENT_EPILOGUE
	db INVALID_TREASURE
	db INVALID_TREASURE
	db INVALID_TREASURE

	assert_table_length NUM_EVENTS

	db TREASURES_END

; input:
; - a = EVENT_* constant
; output:
; - z set if scene finished
GetOWSceneParams:
	ld hl, OWSceneParams
	call GetPointerFromTableHL
GetOWSceneParams_GotPtr:
	ld a, [hli]
	ld [wOWSceneAction], a
	cp $80
	ret z ; finished
	ld a, [hli]
	ld [wOWSceneMapSide], a ; map side
	ld a, [hli]
	ld [wOWSceneActionParam], a
	ld a, l
	ld [wOWSceneParamsPtr + 0], a
	ld a, h
	ld [wOWSceneParamsPtr + 1], a
	ret

; \1 = map side
; \2 = level index
MACRO ow_highlight_level
	db HIGHLIGHT_LEVEL
	db \1
	IF \1 == NORTH
		db \2
	ELSE
		db (\2) + 1
	ENDC
ENDM

; \1 = map side
; \2 = connection
MACRO ow_unlock_level
	db UNLOCK_LEVEL, \1, \2
ENDM

; \1 = map side
; \2 = func index
MACRO ow_func
	db DO_OW_FUNC, \1, \2
ENDM

MACRO ow_scene_end
	db $80
ENDM

OWSceneParams:
	table_width 2
	dw .event_none                      ; EVENT_NONE
	dw .event_prologue                  ; EVENT_PROLOGUE
	dw .event_cut_tree                  ; EVENT_CUT_TREE
	dw .event_open_north_gate           ; EVENT_OPEN_NORTH_GATE
	dw .event_expel_tornado             ; EVENT_EXPEL_TORNADO
	dw .event_lead_overalls             ; EVENT_LEAD_OVERALLS
	dw .event_rainstorm                 ; EVENT_RAINSTORM
	dw .event_fix_elevator              ; EVENT_FIX_ELEVATOR
	dw .event_yellow_music_box          ; EVENT_YELLOW_MUSIC_BOX
	dw .event_plant_seeds               ; EVENT_PLANT_SEEDS
	dw .event_raise_tower               ; EVENT_RAISE_TOWER
	dw .event_swimming_flippers         ; EVENT_SWIMMING_FLIPPERS
	dw .event_blow_mist                 ; EVENT_BLOW_MIST
	dw .event_summon_snakes             ; EVENT_SUMMON_SNAKES
	dw .event_freeze_sea                ; EVENT_FREEZE_SEA
	dw .event_head_smash_helmet         ; EVENT_HEAD_SMASH_HELMET
	dw .event_blue_music_box            ; EVENT_BLUE_MUSIC_BOX
	dw .event_summon_lightning          ; EVENT_SUMMON_LIGHTNING
	dw .event_grab_glove                ; EVENT_GRAB_GLOVE
	dw .event_foot_stone                ; EVENT_FOOT_STONE
	dw .event_volcano_eruption          ; EVENT_VOLCANO_ERUPTION
	dw .event_open_blue_snake_door      ; EVENT_OPEN_BLUE_SNAKE_DOOR
	dw .event_garlic                    ; EVENT_GARLIC
	dw .event_green_music_box           ; EVENT_GREEN_MUSIC_BOX
	dw .event_purify_water              ; EVENT_PURIFY_WATER
	dw .event_reveal_castle             ; EVENT_REVEAL_CASTLE
	dw .event_super_jump_slam_overalls  ; EVENT_SUPER_JUMP_SLAM_OVERALLS
	dw .event_summon_sun                ; EVENT_SUMMON_SUN
	dw .event_high_jump_boots           ; EVENT_HIGH_JUMP_BOOTS
	dw .event_red_music_box             ; EVENT_RED_MUSIC_BOX
	dw .event_explode_bombs             ; EVENT_EXPLODE_BOMBS
	dw .event_leaves_fall               ; EVENT_LEAVES_FALL
	dw .event_prince_frogs_gloves       ; EVENT_PRINCE_FROGS_GLOVES
	dw .event_make_wire                 ; EVENT_MAKE_WIRE
	dw .event_treasure_map              ; EVENT_TREASURE_MAP
	dw .event_super_grab_gloves         ; EVENT_SUPER_GRAB_GLOVES
	dw .event_open_tree_mouth           ; EVENT_OPEN_TREE_MOUTH
	dw .event_gold_music_box            ; EVENT_GOLD_MUSIC_BOX
	dw .event_blue_crayon               ; EVENT_BLUE_CRAYON
	dw .event_place_cart_wheels         ; EVENT_PLACE_CART_WHEELS
	dw .event_collect_blue_gem          ; EVENT_COLLECT_BLUE_GEM
	dw .event_cyan_crayon               ; EVENT_CYAN_CRAYON
	dw .event_collect_goblet            ; EVENT_COLLECT_GOBLET
	dw .event_collect_crown             ; EVENT_COLLECT_CROWN
	dw .event_pink_crayon               ; EVENT_PINK_CRAYON
	dw .event_collect_teapot            ; EVENT_COLLECT_TEAPOT
	dw .event_collect_pocket_pet        ; EVENT_COLLECT_POCKET_PET
	dw .event_magnifying_glass          ; EVENT_MAGNIFYING_GLASS
	dw .event_raise_ice_blocks          ; EVENT_RAISE_ICE_BLOCKS
	dw .event_collect_rocket            ; EVENT_COLLECT_ROCKET
	dw .event_yellow_crayon             ; EVENT_YELLOW_CRAYON
	dw .event_unused_33                 ; EVENT_UNUSED_33
	dw .event_collect_saber             ; EVENT_COLLECT_SABER
	dw .event_day_or_night_spell        ; EVENT_DAY_OR_NIGHT_SPELL
	dw .event_collect_ufo               ; EVENT_COLLECT_UFO
	dw .event_torch_forest              ; EVENT_TORCH_FOREST
	dw .event_reveal_warped_void        ; EVENT_REVEAL_WARPED_VOID
	dw .event_raise_pipe                ; EVENT_RAISE_PIPE
	dw .event_remove_warps              ; EVENT_REMOVE_WARPS
	dw .event_brown_crayon              ; EVENT_BROWN_CRAYON
	dw .event_collect_demons_blood      ; EVENT_COLLECT_DEMONS_BLOOD
	dw .event_open_paragoom_cage        ; EVENT_OPEN_PARAGOOM_CAGE
	dw .event_collect_heart_crest       ; EVENT_COLLECT_HEART_CREST
	dw .event_collect_minicar           ; EVENT_COLLECT_MINICAR
	dw .event_collect_locomotive        ; EVENT_COLLECT_LOCOMOTIVE
	dw .event_collect_telephone         ; EVENT_COLLECT_TELEPHONE
	dw .event_red_crayon                ; EVENT_RED_CRAYON
	dw .event_place_propeller           ; EVENT_PLACE_PROPELLER
	dw .event_feed_octohon              ; EVENT_FEED_OCTOHON
	dw .event_collect_green_gem         ; EVENT_COLLECT_GREEN_GEM
	dw .event_unused_46                 ; EVENT_UNUSED_46
	dw .event_unused_47                 ; EVENT_UNUSED_47
	dw .event_collect_fighter_mannequin ; EVENT_COLLECT_FIGHTER_MANNEQUIN
	dw .event_open_golden_snake_door    ; EVENT_OPEN_GOLDEN_SNAKE_DOOR
	dw .event_open_sky_door             ; EVENT_OPEN_SKY_DOOR
	dw .event_green_crayon              ; EVENT_GREEN_CRAYON
	dw .event_extinguish_fire           ; EVENT_EXTINGUISH_FIRE
	dw .event_collect_diamonds_crest    ; EVENT_COLLECT_DIAMONDS_CREST
	dw .event_place_brick               ; EVENT_PLACE_BRICK
	dw .event_spray_iron_wall           ; EVENT_SPRAY_IRON_WALL
	dw .event_collect_spades_crest      ; EVENT_COLLECT_SPADES_CREST
	dw .event_mix_chemicals             ; EVENT_MIX_CHEMICALS
	dw .event_collect_red_gem           ; EVENT_COLLECT_RED_GEM
	dw .event_collect_clubs_crest       ; EVENT_COLLECT_CLUBS_CREST
	dw .event_cut_baloon                ; EVENT_CUT_BALOON
	dw .event_drill_holes               ; EVENT_DRILL_HOLES
	dw .event_reveal_dark_room          ; EVENT_REVEAL_DARK_ROOM
	dw .event_summon_moon               ; EVENT_SUMMON_MOON
	dw .event_open_crater_hole          ; EVENT_OPEN_CRATER_HOLE
	dw .event_collect_earthen_figure    ; EVENT_COLLECT_EARTHEN_FIGURE
	dw .event_epilogue                  ; EVENT_EPILOGUE
	assert_table_length NUM_EVENTS

.event_none
	ow_scene_end

.event_prologue
	ow_unlock_level NORTH, NORTHCONN_1
	ow_scene_end

.event_cut_tree
	ow_func NORTH, NOWFUNC_CUT_TREE
	ow_unlock_level NORTH, NORTHCONN_2
	ow_unlock_level NORTH, NORTHCONN_3
	ow_scene_end

.event_open_north_gate
	ow_func NORTH, NOWFUNC_OPEN_GATE
	ow_unlock_level NORTH, NORTHCONN_7
	ow_unlock_level WEST, WESTCONN_7
	ow_scene_end

.event_expel_tornado
	ow_func WEST, WOWFUNC_CLEAR_TORNADO
	ow_unlock_level WEST, WESTCONN_1
	ow_scene_end

.event_lead_overalls
	ow_highlight_level NORTH, OWNORTH_OUT_OF_THE_WOODS
	ow_highlight_level NORTH, OWNORTH_THE_VAST_PLAIN
	ow_scene_end

.event_rainstorm
	ow_func WEST, WOWFUNC_RAIN
	ow_unlock_level WEST, WESTCONN_2
	ow_unlock_level WEST, WESTCONN_3
	ow_scene_end

.event_fix_elevator
	ow_func WEST, WOWFUNC_ELEVATOR_WORKING
	ow_unlock_level WEST, WESTCONN_6
	ow_unlock_level SOUTH, SOUTHCONN_7
	ow_scene_end

.event_yellow_music_box
	ow_func SOUTH, SOWFUNC_YELLOW_MUSIC_BOX
	ow_unlock_level SOUTH, SOUTHCONN_1
	ow_scene_end

.event_plant_seeds
	ow_func SOUTH, SOWFUNC_SEND_SEEDS
	ow_func NORTH, NOWFUNC_MAGIC_SEED
	ow_func WEST, WOWFUNC_MAGIC_SEED
	ow_func SOUTH, SOWFUNC_MAGIC_SEED
	ow_scene_end

.event_raise_tower
	ow_func SOUTH, SOWFUNC_RAISE_TOWER
	ow_unlock_level SOUTH, SOUTHCONN_2
	ow_scene_end

.event_swimming_flippers
	ow_highlight_level WEST, OWWEST_THE_POOL_OF_RAIN
	ow_highlight_level SOUTH, OWSOUTH_THE_BIG_BRIDGE
	ow_scene_end

.event_blow_mist
	ow_func SOUTH, SOWFUNC_FAN
	ow_unlock_level SOUTH, SOUTHCONN_6
	ow_unlock_level EAST, EASTCONN_8
	ow_scene_end

.event_summon_snakes
	ow_func SOUTH, SOWFUNC_SUMMON_SNAKE
	ow_func WEST, WOWFUNC_SUMMON_SNAKE
	ow_func NORTH, NOWFUNC_SUMMON_SNAKE
	ow_scene_end

.event_freeze_sea
	ow_func EAST, EOWFUNC_FREEZE_SEA
	ow_unlock_level EAST, EASTCONN_1
	ow_scene_end

.event_head_smash_helmet
	ow_highlight_level WEST, OWWEST_A_TOWN_IN_CHAOS
	ow_highlight_level WEST, OWWEST_DESERT_RUINS
	ow_scene_end

.event_blue_music_box
	ow_func NORTH, NOWFUNC_BLUE_MUSIC_BOX
	ow_unlock_level NORTH, NORTHCONN_4
	ow_unlock_level NORTH, NORTHCONN_5
	ow_scene_end

.event_summon_lightning
	ow_func SOUTH, SOWFUNC_CANYON_THUNDER
	ow_unlock_level SOUTH, SOUTHCONN_3
	ow_scene_end

.event_grab_glove
	ow_highlight_level NORTH, OWNORTH_THE_TIDAL_COAST
	ow_highlight_level EAST, OWEAST_THE_FRIGID_SEA
	ow_highlight_level SOUTH, OWSOUTH_THE_BIG_BRIDGE
	ow_scene_end

.event_foot_stone
	ow_func WEST, WOWFUNC_EARTHQUAKE
	ow_func SOUTH, SOWFUNC_EARTHQUAKE
	ow_func EAST, EOWFUNC_EARTHQUAKE
	ow_scene_end

.event_volcano_eruption
	ow_func WEST, WOWFUNC_VULCANO_ERUPTION
	ow_func EAST, EOWFUNC_VULCANO_ERUPTION
	ow_unlock_level WEST, WESTCONN_4
	ow_unlock_level EAST, SOUTHCONN_3
	ow_scene_end

.event_open_blue_snake_door
	ow_highlight_level SOUTH, OWSOUTH_TOWER_OF_REVIVAL
	ow_scene_end

.event_garlic
	ow_func NORTH, NOWFUNC_GARLIC
	ow_highlight_level NORTH, OWNORTH_BANK_OF_THE_WILD_RIVER
	ow_highlight_level EAST, OWEAST_THE_COLOSSAL_HOLE
	ow_unlock_level NORTH, NORTHCONN_6
	ow_scene_end

.event_green_music_box
	ow_func SOUTH, SOWFUNC_GREEN_MUSIC_BOX
	ow_unlock_level SOUTH, SOUTHCONN_4
	ow_scene_end

.event_purify_water
	ow_highlight_level SOUTH, OWSOUTH_THE_BIG_BRIDGE
	ow_highlight_level EAST, OWEAST_THE_FRIGID_SEA
	ow_highlight_level NORTH, OWNORTH_SEA_TURTLE_ROCKS
	ow_scene_end

.event_reveal_castle
	ow_func EAST, EOWFUNC_FORM_CASTLE
	ow_unlock_level EAST, EASTCONN_2
	ow_scene_end

.event_super_jump_slam_overalls
	ow_highlight_level NORTH, OWNORTH_SEA_TURTLE_ROCKS
	ow_highlight_level WEST, OWWEST_THE_WEST_CRATER
	ow_highlight_level WEST, OWWEST_DESERT_RUINS
	ow_highlight_level NORTH, OWNORTH_THE_PEACEFUL_VILLAGE
	ow_scene_end

.event_summon_sun
	ow_func EAST, EOWFUNC_DAYTIME
	ow_highlight_level EAST, OWEAST_THE_COLOSSAL_HOLE
	ow_highlight_level EAST, OWEAST_THE_FRIGID_SEA
	ow_highlight_level EAST, OWEAST_CASTLE_OF_ILLUSIONS
	ow_scene_end

.event_high_jump_boots
	ow_highlight_level SOUTH, OWSOUTH_THE_GRASSLANDS
	ow_highlight_level EAST, OWEAST_THE_STAGNANT_SWAMP
	ow_highlight_level SOUTH, OWSOUTH_CAVE_OF_FLAMES
	ow_scene_end

.event_red_music_box
	ow_func WEST, WOWFUNC_RED_MUSIC_BOX
	ow_unlock_level WEST, WESTCONN_5
	ow_scene_end

.event_explode_bombs
	ow_func SOUTH, SOWFUNC_EXPLOSIVES
	ow_func EAST, EOWFUNC_EXPLOSIVES
	ow_scene_end

.event_leaves_fall
	ow_func NORTH, NOWFUNC_FALL_LEAVES
	ow_scene_end

.event_prince_frogs_gloves
	ow_highlight_level NORTH, OWNORTH_BANK_OF_THE_WILD_RIVER
	ow_highlight_level SOUTH, OWSOUTH_THE_STEEP_CANYON
	ow_highlight_level WEST, OWWEST_BENEATH_THE_WAVES
	ow_scene_end

.event_make_wire
	ow_highlight_level SOUTH, OWSOUTH_TOWER_OF_REVIVAL
	ow_highlight_level NORTH, OWNORTH_THE_TIDAL_COAST
	ow_scene_end

.event_treasure_map
	ow_unlock_level EAST, EASTCONN_6
	ow_scene_end

.event_super_grab_gloves
	ow_highlight_level WEST, OWWEST_A_TOWN_IN_CHAOS
	ow_highlight_level EAST, OWEAST_CASTLE_OF_ILLUSIONS
	ow_highlight_level EAST, OWEAST_FOREST_OF_FEAR
	ow_scene_end

.event_open_tree_mouth
	ow_highlight_level NORTH, OWNORTH_OUT_OF_THE_WOODS
	ow_scene_end

.event_gold_music_box
	ow_func NORTH, NOWFUNC_GOLD_MUSIC_BOX
	ow_highlight_level NORTH, OWNORTH_THE_TEMPLE
	ow_scene_end

.event_blue_crayon
	db SPECIAL_ACTION, NORTH, $09
	ow_scene_end

.event_place_cart_wheels
	ow_highlight_level WEST, OWWEST_THE_VOLCANOS_BASE
	ow_scene_end

.event_collect_blue_gem
	ow_scene_end

.event_cyan_crayon
	db SPECIAL_ACTION, NORTH, $0a
	ow_scene_end

.event_collect_goblet
	ow_scene_end

.event_collect_crown
	ow_scene_end

.event_pink_crayon
	db SPECIAL_ACTION, NORTH, $0b
	ow_scene_end

.event_collect_teapot
	ow_scene_end

.event_collect_pocket_pet
	ow_scene_end

.event_magnifying_glass
	db SPECIAL_ACTION, NORTH, $10
	ow_scene_end

.event_raise_ice_blocks
	ow_highlight_level NORTH, OWNORTH_BANK_OF_THE_WILD_RIVER
	ow_highlight_level WEST, OWWEST_THE_POOL_OF_RAIN
	ow_scene_end

.event_collect_rocket
	ow_scene_end

.event_yellow_crayon
	db SPECIAL_ACTION, NORTH, $0c
	ow_scene_end

.event_unused_33
	ow_scene_end

.event_collect_saber
	ow_scene_end

.event_day_or_night_spell
	db SPECIAL_ACTION, NORTH, $11
	ow_scene_end

.event_collect_ufo
	ow_scene_end

.event_torch_forest
	ow_func EAST, EOWFUNC_BURN_VINES
	ow_unlock_level EAST, EASTCONN_5
	ow_unlock_level EAST, EASTCONN_7
	ow_unlock_level NORTH, $08
	ow_scene_end

.event_reveal_warped_void
	ow_func EAST, EOWFUNC_SHOW_WARPED_VOID
	ow_unlock_level EAST, SOUTHCONN_4
	ow_scene_end

.event_raise_pipe
	ow_func EAST, EOWFUNC_RAISE_PIPE
	ow_scene_end

.event_remove_warps
	ow_highlight_level EAST, OWEAST_THE_WARPED_VOID
	ow_scene_end

.event_brown_crayon
	db SPECIAL_ACTION, NORTH, $0d
	ow_scene_end

.event_collect_demons_blood
	ow_highlight_level EAST, OWEAST_FOREST_OF_FEAR
	ow_scene_end

.event_open_paragoom_cage
	ow_highlight_level EAST, OWEAST_THE_WARPED_VOID
	ow_scene_end

.event_collect_heart_crest
	ow_scene_end

.event_collect_minicar
	ow_scene_end

.event_collect_locomotive
	ow_scene_end

.event_collect_telephone
	ow_scene_end

.event_red_crayon
	db SPECIAL_ACTION, NORTH, $0e
	ow_scene_end

.event_place_propeller
	ow_highlight_level WEST, OWWEST_A_TOWN_IN_CHAOS
	ow_scene_end

.event_feed_octohon
	ow_highlight_level NORTH, OWNORTH_THE_TIDAL_COAST
	ow_highlight_level WEST, OWWEST_BENEATH_THE_WAVES
	ow_scene_end

.event_collect_green_gem
	ow_scene_end

.event_unused_46
	ow_scene_end

.event_unused_47
	ow_scene_end

.event_collect_fighter_mannequin
	ow_scene_end

.event_open_golden_snake_door
	ow_highlight_level SOUTH, OWSOUTH_TOWER_OF_REVIVAL
	ow_scene_end

.event_open_sky_door
	ow_unlock_level SOUTH, SOUTHCONN_5
	ow_scene_end

.event_green_crayon
	db SPECIAL_ACTION, NORTH, $0f
	ow_scene_end

.event_extinguish_fire
	ow_highlight_level WEST, OWWEST_THE_WEST_CRATER
	ow_highlight_level EAST, OWEAST_THE_EAST_CRATER
	ow_scene_end

.event_collect_diamonds_crest
	ow_scene_end

.event_place_brick
	ow_highlight_level EAST, OWEAST_CASTLE_OF_ILLUSIONS
	ow_scene_end

.event_spray_iron_wall
	ow_highlight_level WEST, OWWEST_THE_WEST_CRATER
	ow_highlight_level SOUTH, OWSOUTH_THE_STEEP_CANYON
	ow_highlight_level SOUTH, OWSOUTH_CAVE_OF_FLAMES
	ow_scene_end

.event_collect_spades_crest
	ow_scene_end

.event_mix_chemicals
	ow_highlight_level NORTH, OWNORTH_THE_VAST_PLAIN
	ow_highlight_level WEST, OWWEST_BENEATH_THE_WAVES
	ow_scene_end

.event_collect_red_gem
	ow_scene_end

.event_collect_clubs_crest
	ow_scene_end

.event_cut_baloon
	ow_highlight_level SOUTH, OWSOUTH_ABOVE_THE_CLOUDS
	ow_scene_end

.event_drill_holes
	ow_highlight_level EAST, OWEAST_THE_EAST_CRATER
	ow_scene_end

.event_reveal_dark_room
	ow_highlight_level NORTH, OWNORTH_SEA_TURTLE_ROCKS
	ow_scene_end

.event_summon_moon
	ow_func SOUTH, SOWFUNC_FULL_MOON
	ow_highlight_level SOUTH, OWSOUTH_ABOVE_THE_CLOUDS
	ow_scene_end

.event_open_crater_hole
	ow_highlight_level EAST, OWEAST_THE_EAST_CRATER
	ow_scene_end

.event_collect_earthen_figure
	ow_scene_end

.event_epilogue
	ow_func NORTH, NOWFUNC_PROLOGUE
	ow_scene_end

InitOWScenesForMapSide:
	ld a, EVENT_PROLOGUE
	ld [wTempEvent], a
	ld a, [wLastTransitionParam]
	ld c, a
	dec c
	and a
	jr z, .set_last_transition
	cp TRANSITION_NEW_GAME
	jr nz, .loop_cutscenes
	ld c, $00
.set_last_transition
	ld a, c
	ld [wLastTransitionParam], a

.loop_cutscenes
	xor a
	ld [wUnused_2d078], a
	ld a, [wTempEvent]
	call CheckIfEventIsUnlocked
	ld [wEventUnlockState], a
	and a
	jr z, .prepare_scene
	dec c
	jr z, .prepare_scene
	ld a, $80
	ld [wEventUnlockState], a
.prepare_scene
	call .PrepareScene
	ld a, [wTempEvent]
	inc a
	cp NUM_EVENTS
	jr z, .break
	ld [wTempEvent], a
	jr .loop_cutscenes
.break
	ld a, [wLastTransitionParam]
	inc a
	ret nz
	; TRANSITION_NEW_GAME
	ld [wLastTransitionParam], a ; = 0
	ret

; run through all scene params of this cutscene
; and initialise everything that is needed
; for this side of the map
.PrepareScene:
	ld a, [wTempEvent]
	call GetOWSceneParams
	ret z ; finished
.loop
	ld a, [wOWSceneMapSide]
	ld b, a
	ld a, [wCurMapSide]
	cp b
	jr nz, .diff_side
	; same side
	call .DoInitFunc
.diff_side
	ld hl, wOWSceneParamsPtr
	call GetByteFromPointerInHL
	call GetOWSceneParams_GotPtr
	ret z ; finished
	jr .loop

.DoInitFunc:
	ld a, [wOWSceneAction]
	jumptable

	dw InvalidOWSceneInitAction
	dw DrawUnlockedLevels      ; UNLOCK_LEVEL
	dw InitOWObjects           ; DO_OW_FUNC
	dw InitHighlightLevelScene ; HIGHLIGHT_LEVEL
	dw InitOWObjects           ; SPECIAL_ACTION

InvalidOWSceneInitAction:
	debug_nop

InitOWObjects:
	farcall _InitOWObjects
	ret

DrawUnlockedLevels:
	ld a, [wEventUnlockState]
	add a
	ret z ; conditions not fulfilled

	xor a
	ld [wLevelArrowIndex], a
	call GetUnlockedOWLevelData
	call GetUnlockedLevelArrows
.loop
	call .draw_connection
	ld hl, wLevelArrowIndex
	inc [hl]
	ld a, [wNumLevelArrows1]
	cp [hl]
	jr nz, .loop

	xor a
	ld [wLevelArrowIndex], a
	xor a ; unnecessary
	ld [wOWTilemapPtr + 0], a
	ld [wOWTilemapPtr + 1], a
	ld [wAttrToPlaceInOW], a
	ld [wTileToPlaceInOW], a
	ld [wOWPathShape], a
	ret

.draw_connection:
	call IsLeftExitOrJunction
	jr z, .second_connection
	ld a, [wLevelArrowDirections1]
	ld hl, wAttrToPlaceInOW
	call ShowLevelArrowInOW
	ld a, [wLevelArrowDirections1]
	call GetConnectedLevel1ArrowCoord
	call GetConnectedLevel1CoordsInTilemap
	ld a, TRUE
	ld [wHighlightOWTile], a
	push hl
	call ApplyHighlightPalToOWTile
	pop hl
	ld a, [wTileToPlaceInOW]
	ld [hl], a
	dec h
	dec h
	dec h
	ld a, [wAttrToPlaceInOW]
	ld [hl], a
	xor a ; FALSE
	ld [wHighlightOWTile], a
	ld a, [wLevel2]
	cp OW_EXIT_RIGHT
	ret z

.second_connection
	ld a, [wOWXCoord2]
	ld [wOWXCoord1], a
	ld a, [wOWYCoord2]
	ld [wOWYCoord1], a
	ld a, [wLevelArrowDirections2]
	ld [wLevelArrowDirections1], a
	ld a, [wLevelArrowDirections1]
	ld hl, wAttrToPlaceInOW
	call ShowLevelArrowInOW
	ld a, [wLevelArrowDirections1]
	call GetConnectedLevel1ArrowCoord
	call GetConnectedLevel1CoordsInTilemap
	ld a, TRUE
	ld [wHighlightOWTile], a
	push hl
	call ApplyHighlightPalToOWTile
	pop hl
	ld a, [wTileToPlaceInOW]
	ld [hl], a
	dec h
	dec h
	dec h
	ld a, [wAttrToPlaceInOW]
	ld [hl], a
	xor a ; FALSE
	ld [wHighlightOWTile], a

	ld hl, wAttrToPlaceInOW
	call ShowLevelPointInOW
	ld hl, wOWCoords2
	call GetOWCoordInTilemap
	ld a, TRUE
	ld [wHighlightOWTile], a
	push hl
	call ApplyHighlightPalToOWTile
	pop hl
	ld a, [wTileToPlaceInOW]
	ld [hl], a
	dec h
	dec h
	dec h
	ld a, [wAttrToPlaceInOW]
	ld [hl], a
	xor a ; FALSE
	ld [wHighlightOWTile], a
	ret

PlacePendingOWTiles:
	ld a, [wHighlightOWTile]
	and a
	jr z, .skip
	ld de, wTileToPlaceInOW
.loop
	ld a, [de] ; wTileToPlaceInOW
	ld c, a
	inc e
	ld a, [de] ; wAttrToPlaceInOW
	ld b, a
	inc e
	ld a, [de] ; wOWTilemapPtr
	ld l, a
	inc e
	ld a, [de]
	ld h, a
	ld [hl], c
	dec h
	dec h
	dec h
	ld [hl], b
	inc e
	ld a, [wHighlightOWTile]
	dec a
	ld [wHighlightOWTile], a
	and a
	jr nz, .loop
	ld a, TRUE
	ld [wOWPendingTileUpdate], a
.skip
	ret

GetUnlockedOWLevelData:
	ld hl, wOWSceneMapSide
	ld a, [hli]
	ld c, [hl] ; wOWSceneActionParam
	ld hl, UnlockableConnections
	call GetCthWordFromAthTable
	ld a, [hli]
	ld [wLevel1], a
	ld a, [hl]
	ld [wLevel2], a

	ld hl, wOWSceneMapSide
	ld a, [hli]
	ld c, [hl] ; wOWSceneActionParam
	ld hl, UnlockableLevelArrows
	call GetCthWordFromAthTable
	ld a, [hli]
	ld [wUnlockedLevelArrowsPtr + 0], a
	ld a, [hl]
	ld [wUnlockedLevelArrowsPtr + 1], a

	ld a, [wLevel1]
	call GetMapLevelCoords
	ld a, [hli]
	ld [wOWLevelYCoord], a
	ld [wOWYCoord1], a
	ld a, [hl]
	ld [wOWLevelXCoord], a
	ld [wOWXCoord1], a

	ld a, [wLevel2]
	call GetMapLevelCoords
	ld a, [hli]
	ld [wOWYCoord2], a
	ld a, [hl]
	ld [wOWXCoord2], a
	ret

GetUnlockedLevelArrows:
	ld a, [wUnlockedLevelArrowsPtr + 0]
	ld l, a
	ld a, [wUnlockedLevelArrowsPtr + 1]
	ld h, a
	ld a, [wOWPathShape]
	call AddOffsetInPointerTable
	ld a, [hli]
	ld [wLevelArrowDirections1], a
	ld a, [hli]
	ld [wNumLevelArrows1], a
	ld a, [hli]
	ld [wLevelArrowDirections2], a
	cp $ff
	ld a, [hl]
	jr nz, .set_num_arrows
	xor a
.set_num_arrows
	ld [wNumLevelArrows2], a
	ret

	ret ; stray ret

GetConnectedLevel1ArrowCoord:
	ld b, a
	ld a, $8
	ld hl, wOWXCoord1
	bit B_PAD_RIGHT, b
	jr nz, .right_down
	bit B_PAD_LEFT, b
	jr nz, .left_up
	ld hl, wOWYCoord1
	bit B_PAD_UP, b
	jr nz, .left_up
	bit B_PAD_DOWN, b
	jr nz, .right_down
	ret
.left_up
	cpl
	inc a ; -$8
.right_down
	add [hl]
	ld [hl], a
	ret

GetConnectedLevel1CoordsInTilemap:
	ld a, [wOWTilemapPtr + 0]
	ld [wTempOWTilemapPtr + 0], a
	ld a, [wOWTilemapPtr + 1]
	ld [wTempOWTilemapPtr + 1], a
	ld hl, wOWCoords1
	call GetOWCoordInTilemap
	ret

; applies palette 7 and bank1 bit to wAttrToPlaceInOW
; if wHighlightOWTile is TRUE
ApplyHighlightPalToOWTile:
	ld a, [wHighlightOWTile]
	and a
	ret z

	; this load to hl and a is never used
	ld a, [wOWTilemapPtr + 1]
	ld h, a
	ld a, [wOWTilemapPtr + 0]
	ld l, a
	ld a, [hl]

	call .GetTilePalIndex
	ld a, [wAttrToPlaceInOW]
	and $ff ^ BG_PALMASK
	or c ; always $7
	or BG_BANK1
	ld [wAttrToPlaceInOW], a

	ld a, [wHighlightOWTile]
	dec a
	ret z
	debug_nop

.GetTilePalIndex:
	ld c, $7
	ret

SetCompassSprite:
	ld a, [wCurMapSide]
	ld c, a
	ld hl, .coords
	ld de, wCompassObj
	ld b, 2
	call CopyHLToDE
	ld a, c
	ld [de], a
	ret

.coords
	; y, x
	db $14, $14

; unreferenced
UnreferencedCompassCoords:
	db $14, $14, $14, $14, $14, $14

LoadCompassSprite:
	ld hl, wCompassObj
	ld de, CompassOAM_aa580
	ld b, BANK(CompassOAM_aa580)
	call LoadOWSpriteWithScroll
	ret

PlayStepSFX:
	play_sfx SFX_STEP
	ret

UpdateOWWario:
	ld a, [wMapSideLevelID]
	ld c, a
	ld a, [wTargetMapSideLevelID]
	cp c
	jr z, .reset_sfx_counter
	ld hl, wOWWalkSFXCounter
	ld a, [hl]
	and a
	call z, PlayStepSFX
	inc [hl]
	ld a, [wOWWarioRunCounter]
	rlca
	ld c, $24
	jr nc, .check_sfx_counter
	srl c
	srl c
.check_sfx_counter
	ld a, [hl]
	cp c
	jr c, .check_direction
.reset_sfx_counter
	xor a
	ld [wOWWalkSFXCounter], a
.check_direction
	ld a, [wOWWarioLastDir]
	ld b, a
	ld a, [wLevelArrowDirections1]
	cp b
	jr z, DrawOWWario
	ld [wOWWarioLastDir], a
	ld c, OWWARIO_UP
	bit 6, a
	jr nz, .set_oam
	ld c, OWWARIO_RIGHT
	bit 4, a
	jr nz, .set_oam
	ld c, OWWARIO_LEFT
	bit 5, a
	jr nz, .set_oam
	ld c, OWWARIO_DOWN
.set_oam
	ld a, c
	call SetOWWarioOAM
;	fallthrough
DrawOWWario:
	ld a, [wOWWarioSprite]
	and a
	ret z
	ld hl, wOWWarioFramesetPtr
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wOWWarioAnimDuration
	ld b, $2a
	call UpdateOWAnimation
	ld hl, wOWWarioOAMPtr
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wOWWarioYCoord
	ld b, $2a
	call LoadOWSpriteWithScroll
	ret

; input:
; - a = OWWARIO_* constant
SetOWWarioOAM:
	ld [wOWWarioSprite], a
	and a
	ret z
	ld bc, OWWarioOAM_aa329
	cp $05
	jr c, .got_oam
	ld bc, OWUIOAM_aa0cf
.got_oam
	dec a
	add a ; *2
	ld e, a
	ld d, $00
	ld hl, .framesets
	add hl, de
	ld de, wOWWarioFramesetPtr
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	ld hl, wOWWarioOAMPtr
	ld [hl], c
	inc l
	ld [hl], b
	ld hl, wOWWarioAnimDuration
	xor a
	ld [hli], a
	ld [hl], a
	ret

.framesets
	dw OWWarioFrameset_aa405
	dw OWWarioFrameset_aa416
	dw OWWarioFrameset_aa427
	dw OWWarioFrameset_aa438
	dw OWWarioFrameset_aa25e

SetPathFromArrowDirection:
	call GetCurLevelPathsPtr
	ld a, [wLevelArrowDirections1]
	swap a
	rrca
	jr c, .got_direction ; right
	inc hl
	rrca
	jr c, .got_direction ; left
	inc hl
	rrca
	jr c, .got_direction ; up
	inc hl
	rrca
	jr c, .got_direction ; down
	debug_nop
.got_direction
	ld a, [hl]
	ld [wTargetMapSideLevelID], a
	ld de, $4
	add hl, de
	ld a, [hl]
	ld [wOWPathShape], a
	xor a
	ld [wLevelArrowIndex], a
	ret

GetCurLevelPathsPtr:
	ld a, [wMapSideLevelID]
	cp OW_EXITS
	jr c, .level
	sub OW_EXIT_RIGHT
	ld hl, OWExitPaths
	jr .got_table
.level
	ld hl, OWLevelPaths
.got_table
	add a
	add a ; *4
	ld c, a
	ld a, [wNextMapSide]
	call GetCthWordFromAthTable
	ret

PlaceOWWarioAtCurLevel:
	ld a, [wMapSideLevelID]
	ld [wLevel1], a
	call GetMapLevelCoords
	ld a, [hli]
	ld [wOWLevelYCoord], a ; level x
	ld b, a
	ld a, [hli]
	ld [wOWLevelXCoord], a ; level y
	ld c, a
	ld a, [hli]
	add b
	ld [wOWYCoord1], a
	ld [wOWWarioYCoord], a
	ld a, [hl]
	add c
	ld [wOWXCoord1], a
	ld [wOWWarioXCoord], a
	ret

; writes to wOWAllowedDPadInput the allowed
; d-pad inputs in the current OW position
GetOWAllowedDPadInput:
	ld a, [wMapSideLevelID]
	cp OWNORTH_JUNCTION
	jr z, .junction
	ld hl, wOWLevelYCoord
	call GetOWCoordInTilemap
	ld c, $00

	inc hl
	ld b, PAD_RIGHT
	call .CheckAllowedDirection

	dec hl
	dec hl
	ld b, PAD_LEFT
	call .CheckAllowedDirection

	inc hl
	ld de, -TILEMAP_WIDTH
	add hl, de
	ld b, PAD_UP
	call .CheckAllowedDirection

	ld de, 2 * TILEMAP_WIDTH
	add hl, de
	ld b, PAD_DOWN
	call .CheckAllowedDirection

	ld a, c
	ld [wOWAllowedDPadInput], a
	ret

.CheckAllowedDirection:
	ld a, [hl]
	cp $02
	jr z, .check
	cp $01
	jr z, .check
	ret

.check
	ld e, l
	ld d, h
	dec d
	dec d
	dec d
	ld a, [de] ; wAttrmap
	bit B_BG_BANK1, a
	ret z ; not an arrow
	ld a, c
	or b
	ld c, a
	ret

.junction
	ld a, PAD_RIGHT | PAD_UP | PAD_DOWN
	ld [wOWAllowedDPadInput], a
	ret

; input:
; - wOW1Coords and wOW2Coords
InitOWLineMovement:
	xor a
	ld [wOWLineFlags], a

	; y coordinates
	ld c, $02
	ld hl, wOWYCoord1
	ld de, wOWYCoord2
	call .CalculateDistance
	ld [wOWYDistance], a

	; x coordinates
	ld c, $04
	ld hl, wOWXCoord1
	ld de, wOWXCoord2
	call .CalculateDistance
	ld [wOWXDistance], a

	ld a, [wOWLineFlags]
	ld b, a

	ld hl, wOWYDistance
	ld a, [hli]
	cp [hl] ; wOWXDistance
	jr nc, .got_major_axis
	ld a, [hld] ; wOWXDistance
	set 0, b
.got_major_axis
	; a  = max(wOWYDistance, wOWXDistance)
	; hl = min(wOWYDistance, wOWXDistance)
	ld [wOWLineStepsLeft], a
	ld [wOWLineMajorDist], a
	ld a, [hl]
	ld [wOWLineError], a
	ld [wOWLineMinorDist], a
	ld a, b
	ld [wOWLineFlags], a

	lb de, 1, 1
	ld hl, wOWLineFlags
	bit 1, [hl]
	jr z, .got_y_step
	ld d, -1
.got_y_step
	bit 2, [hl]
	jr z, .got_x_step
	ld e, -1
.got_x_step
	ld hl, wOWLineYStep
	ld [hl], d
	inc l
	ld [hl], e ; wOWLineXStep
	ret

; output |[hl] - [de]| in a, and,
; if [hl] > [de], 'or' c with wOWLineFlags
.CalculateDistance:
	ld b, [hl]
	ld a, [de]
	sub b
	ret nc ; exit if [hl] <= [de]
	cpl
	inc a
	ld b, a ; = difference between [hl] and [de]
	ld a, c
	ld hl, wOWLineFlags
	or [hl]
	ld [hl], a
	ld a, b
	ret

StepOWLineMovement:
	ld hl, wOWLineStepsLeft
	ld a, [hl]
	and a
	ret z
	dec a
	ld [hl], a
	ld a, [wOWLineMajorDist]
	ld d, a
	ld hl, wOWLineError
	ld a, [wOWLineMinorDist]
	add [hl]
	ld [hl], a
	cp d
	call nc, .step_minor_axis
	call .step_major_axis
	ret

.step_minor_axis:
	sub d
	ld [hl], a
	ld a, [wOWLineFlags]
	and $1
	xor $1
	jr .step_axis
.step_major_axis:
	ld a, [wOWLineFlags]
	and $1
.step_axis
	ld hl, wOWYCoord1
	ld de, wOWLineYStep
	jr z, .got_axis
	inc e
	inc l
.got_axis
	ld a, [de]
	add [hl]
	ld [hl], a
	ret

UpdateTopBar:
	ld hl, wOWBarsStateCounter
	inc [hl]
	ld a, [wOWBarsState]
	and a
	ret z
	dec a
	jumptable

	dw .StartCloseBottomBar     ; OWBARS_START_CLOSE_BOT
	dw .HandleBottomBarClose    ; OWBARS_HANDLE_CLOSE_BOT
	dw .OpenTopBar              ; OWBARS_OPEN_TOP
	dw .HandleInput             ; OWBARS_INPUT_TOP
	dw .CloseTopBar             ; OWBARS_CLOSE_TOP

	dw .Cutscene                ; OWBARS_EVENT
	dw .Collection              ; OWBARS_COLLECTION
	dw .NextMap                 ; OWBARS_NEXT_MAP

	dw .DayNight                ; OWBARS_DAY_NIGHT
	dw .DelayDayNightTransition ; OWBARS_DAY_NIGHT_DELAY
	dw .DoDayNightTransition    ; OWBARS_DAY_NIGHT_TRANSITION

.StartCloseBottomBar:
	; mark bottom bar as closing
	call DrawBottomBar
	ld a, BOTBAR_CLOSING
	ld [wBottomBarAction], a
	xor a
	ld [wBottomBarState], a
	ld [wMagnifyingGlassCounter], a

	ld hl, wOWBarsState
	inc [hl]
	ret

.HandleBottomBarClose:
	; wait until bottom bar is fully closed
	call HandleBottomBar
	call DrawBottomBar
	ld a, [wBottomBarAction]
	and a
	ret nz

	; bottom bar was closed
	play_sfx SFX_MENU_OPEN

	; init top bar flags
	xor a
	set TOPBAR_COLLECTION_F, a
	ld [wTopBarSelection], a

	call .InitTopBarButtons
	call ApplyTopBarButtonAttributes

	ld a, LOW(rOBPI)
	ld [wPalConfig1Register], a
	ld a, HIGH(wTempPals2 palette 4)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempPals2 palette 4)
	ld [wPalConfig1SourceLo], a
	ld a, OBPI_AUTOINC | palette 4
	ld [wPalConfig1Index], a
	ld a, 4 ; number of pals
	ld [wPalConfig1Number], a

	ld hl, wOWBarsState
	inc [hl]
	ret

.InitTopBarButtons:
	call ShowTopBarSelectedButton
	call LoadTopBarButtonAttributes

	xor a
	ld [wOWUIObj1YCoord], a
	ld [wOWUIObj2YCoord], a
	ld a, $1c
	ld [wOWUIObj2XCoord], a
	call DrawTopBar

	ld hl, TopBarOBPals
	ld de, wTempPals2 palette 4
	ld c, 4 palettes
	ld b, BANK(TopBarOBPals)
	call CopyFarBytes
	ret

.OpenTopBar:
	ld a, [wSCY]
	dec a
	dec a
	ld [wSCY], a
	cp $ec
	jr nz, .still_opening
	; fully open, advance state
	ld a, [wTransitionParam]
	ld [wSavedTransitionParam], a
	ld hl, wOWBarsState
	inc [hl]
.still_opening
	call DrawTopBar
	ret

.HandleInput:
	call HandleTopBarSelection
	jr c, .done_input
	call HandleTopBarDPad
	jr c, .done_input
	ld a, [wJoypadPressed]
	and PAD_B | PAD_SELECT
	jr z, .done_input
	play_sfx SFX_MENU_CLOSE
	ld hl, wOWBarsState
	inc [hl]
.done_input
	jp DrawTopBar

.CloseTopBar:
	ld a, [wSCY]
	inc a
	inc a
	ld [wSCY], a
	cp $04
	jr nz, .still_closing

	xor a
	ld [wOWStep], a
	ld [wOWBarsState], a ; OWBARS_NONE
	ld hl, NorthOWOBPals palette 4
	ld de, 8 palettes
	ld a, [wCurMapSide]
	inc a
.loop
	dec a
	jr z, .got_pal
	add hl, de
	jr .loop
.got_pal
	ld de, wTempPals2 palette 4
	ld c, 4 palettes
	ld b, BANK(NorthOWOBPals)
	call CopyFarBytes
	ld a, LOW(rOBPI)
	ld [wPalConfig1Register], a
	ld a, HIGH(wTempPals2 palette 4)
	ld [wPalConfig1SourceHi], a
	ld a, LOW(wTempPals2 palette 4)
	ld [wPalConfig1SourceLo], a
	ld a, OBPI_AUTOINC | palette 4
	ld [wPalConfig1Index], a
	ld a, 4 ; number of pals
	ld [wPalConfig1Number], a

.still_closing
	call DrawTopBar
	ret

.Cutscene:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .skip_cutscene_wait
	ld a, [wOWBarsStateCounter]
	cp 30
	jr c, .wait_cutscene
.skip_cutscene_wait
	ld a, [wStoredTransitionParam]
	ld [wTransitionParam], a
	xor a
	ld [wSubState], a
	xor a
	ld hl, wOWBarsStateCounter
	ld [hld], a
	ld a, OWBARS_INPUT_TOP
	ld [hl], a ; wOWBarsState
.wait_cutscene
	call DrawTopBar
	ret

.Collection:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .skip_collection_wait
	ld a, [wOWBarsStateCounter]
	cp 30
	jr c, .wait_collection
.skip_collection_wait
	xor a
	ld hl, wOWBarsStateCounter
	ld [hld], a
	ld a, OWBARS_INPUT_TOP
	ld [hl], a ; wOWBarsState
	ld a, SST_OVERWORLD_COLLECTION
	ld [wSubState], a
.wait_collection
	call DrawTopBar
	ret

.NextMap:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .skip_next_map_wait
	ld a, [wOWBarsStateCounter]
	cp 30
	jr c, .wait_next_map
.skip_next_map_wait
	xor a
	ld hl, wOWBarsStateCounter
	ld [hld], a
	ld a, OWBARS_INPUT_TOP
	ld [hl], a ; wOWBarsState
	ld a, [wOWUIObj1State]
	ld b, 1
	cp $0a
	jr nz, .prev_map
	ld b, -1
.prev_map
	ld hl, wNextMapSide
	ld a, b
	add [hl]
	and $3 ; wrap around
	ld [hl], a
	call .GetNextLevelIndex

	stop_music2

	xor a
	ld [wOWStep], a
	ld [wOWStepCounter], a
	ld a, SST_OVERWORLD_MAP_SIDE
	ld [wSubState], a

.wait_next_map
	call DrawTopBar
	ret

.GetNextLevelIndex:
	ld hl, .Indices
	call AddOffsetInPointerTable
	dec b
	jr z, .got_index
	inc hl
.got_index
	ld a, [hl]
	ld [wMapSideLevelID], a
	ld [wTargetMapSideLevelID], a
	ret

.Indices:
	; left, right
	db OWNORTH_THE_PEACEFUL_VILLAGE, OWNORTH_THE_VAST_PLAIN   ; NORTH
	db OWWEST_DESERT_RUINS,          OWWEST_A_TOWN_IN_CHAOS   ; WEST
	db OWSOUTH_THE_GRASSLANDS,       OWSOUTH_TOWER_OF_REVIVAL ; SOUTH
	db OWEAST_THE_STAGNANT_SWAMP,    OWEAST_FOREST_OF_FEAR    ; EAST

.DayNight:
	call DrawTopBar
	ld a, [wOWUIObj1Frame]
	cp $04
	jr z, .do_spell
	cp $06
	ret nz
.do_spell
	call DoDayNightSpell
	call LoadTopBarButtonAttributes
	call ApplyTopBarButtonAttributes
	ld hl, wOWBarsState
	inc [hl]
	ret

.DelayDayNightTransition:
	ld a, [wOWUIObj1State]
	cp $05
	jr z, .start_transition
	cp $07
	jr nz, .skip_transition
.start_transition
	ld hl, wOWBarsState
	inc [hl]
.skip_transition
	call DrawTopBar
	ret

.DoDayNightTransition:
	farcall DayNightTransition
	ld a, [wOWPalTransitionState]
	and a
	jr nz, .still_transitioning

	di
	call VBlank_Overworld
	ei

	ld a, OWBARS_INPUT_TOP
	ld [wOWBarsState], a
.still_transitioning
	call DrawTopBar
	ret

HandleTopBarDPad:
	xor a
	ld a, [wTopBarSelection]
	ld b, a
	ld hl, wTopBarSelection
	ld a, [wJoypadPressed]
	ld c, a
	ld a, [wTopBarSelectableButtons]
	ld d, a
	bit B_PAD_RIGHT, c
	jr nz, .d_right
	bit B_PAD_LEFT, c
	jr nz, .d_left
	ret

.d_right
	; find the first item to the right
	; that can be selectable
	ld a, d
	rrc b
	ret c
	and b
	jr z, .d_right

.got_selection
	ld [hl], b
	call ShowTopBarSelectedButton
	call LoadTopBarButtonAttributes
	call ApplyTopBarButtonAttributes
	play_sfx SFX_MENU_SCROLL
	scf
	ret

.d_left
	; find the first item to the left
	; that can be selectable
	ld a, d
	sla b
	bit (TOPBAR_PREV_MAP_F + 1), b
	ret nz
	and b
	jr z, .d_left
	jr .got_selection

ShowTopBarSelectedButton:
	ld a, [wTopBarSelection]
	ld c, $00
	bit TOPBAR_DAY_NIGHT_F, a
	jr nz, .day_night
	inc c
	bit TOPBAR_CUTSCENE_F, a
	jr nz, .got_selection
	inc c
	bit TOPBAR_COLLECTION_F, a
	jr nz, .got_selection
	inc c
	bit TOPBAR_NEXT_MAP_F, a
	jr nz, .got_selection
	inc c
	bit TOPBAR_PREV_MAP_F, a ; unnecessary
.got_selection
	ld a, c
	add a ; *2
	ld e, a
	ld d, $00
	ld hl, .button_data
	add hl, de
	ld a, [hli]
	ld [wOWUIObj1XCoord], a
	ld a, [hl]
	ld hl, wOWUIObj1State
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a ; FramesetOffset

	; if either Next Map or Prev Map are selected
	; then show the NEXT MAP indicator
	ld c, $00
	ld a, [wTopBarSelection]
	and TOPBAR_NEXT_MAP | TOPBAR_PREV_MAP
	jr z, .no_next_map
	ld c, $0b ; NEXT MAP indicator
.no_next_map
	ld a, c
	ld hl, wOWUIObj2State
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a ; wOWUIObj2Duration
	ret

.day_night
	ld a, [wOWIsNight]
	and a
	jr z, .got_selection
	ld c, $05 ; night spell
	jr .got_selection

.button_data
; x coord, state
	db $60, $07 ; Day Spell
	db $50, $03 ; Cutscene
	db $40, $01 ; Collection
	db $2c, $0d ; Next Map
	db $0c, $09 ; Prev Map
	db $60, $05 ; Night Spell

DrawTopBar:
	call DrawTopBarSelectionSprite
	call DrawTopBarNextMapSprite
	ret

DrawTopBarSelectionSprite:
	xor a
	ld [wOWAnimationFinished], a
	ld a, [wOWUIObj1State]
	ld hl, wOWUIObj1Duration
	call AnimateTopBarSprite
	ld b, BANK(TopBarOAM_a9fe2)
	ld de, TopBarOAM_a9fe2
	ld hl, wOWUIObj1
	call LoadOWSpriteWithScroll
	ret

DrawTopBarNextMapSprite:
	ld a, [wOWUIObj2State]
	and a
	ret z
	ld hl, wOWUIObj2Duration
	call AnimateTopBarSprite
	ld b, BANK(TopBarOAM_a9fe2)
	ld de, TopBarOAM_a9fe2
	ld hl, wOWUIObj2
	call LoadOWSpriteWithScroll
	ret

AnimateTopBarSprite:
	push hl
	jumptable

	dw .None
	dw .Collection
	dw .CollectionPressed
	dw .Cutscene
	dw .CutscenePressed
	dw .NightSpell
	dw .NightSpellPressed
	dw .DaySpell
	dw .DaySpellPressed
	dw .PrevMap
	dw .PrevMapPressed
	dw .NextMapIndicator
	dw .NextMapIndicatorFlash
	dw .NextMap
	dw .NextMapPressed

.None:
	pop hl
	ret

.Collection:
	ld de, TopBarFrameset_aa091
	jr .UpdateAnimation_PopHL

.CollectionPressed:
	ld de, TopBarFrameset_aa094
	jr .UpdateAnimation_PopHL

.Cutscene:
	ld de, TopBarFrameset_aa097
	jr .UpdateAnimation_PopHL

.CutscenePressed:
	ld de, TopBarFrameset_aa09a
	jr .UpdateAnimation_PopHL

.NightSpell:
	ld de, TopBarFrameset_aa09d
	jr .UpdateAnimation_PopHL

.NightSpellPressed:
	ld de, TopBarFrameset_aa0bc
	pop hl
	call .UpdateAnimation
	ld b, $07
	jr .set_state_if_finished

.DaySpell:
	ld de, TopBarFrameset_aa0a3
	jr .UpdateAnimation_PopHL

.DaySpellPressed:
	ld de, TopBarFrameset_aa0c1
	pop hl
	call .UpdateAnimation
	ld b, $05
	jr .set_state_if_finished

.PrevMap:
	ld de, TopBarFrameset_aa0a9
	jr .UpdateAnimation_PopHL

.PrevMapPressed:
	ld de, TopBarFrameset_aa0ae
	jr .UpdateAnimation_PopHL

.NextMapIndicator:
	ld de, TopBarFrameset_aa0b1
	jr .UpdateAnimation_PopHL

.NextMapIndicatorFlash:
	ld de, TopBarFrameset_aa0c6
	jr .UpdateAnimation_PopHL

.NextMap:
	ld de, TopBarFrameset_aa0b4
	jr .UpdateAnimation_PopHL

.NextMapPressed:
	ld de, TopBarFrameset_aa0b9
;	fallthrough

.UpdateAnimation_PopHL:
	pop hl
;	fallthrough
.UpdateAnimation:
	ld b, $2a
	call UpdateOWAnimation
	ret

.set_state_if_finished:
	ld a, [wOWAnimationFinished]
	cp $ff
	ret nz
	set 2, l
	ld d, h
	ld e, l
	xor a
	ld [de], a
	inc e
	ld [de], a
	inc e
	ld a, b
	ld [de], a
	call AnimateTopBarSprite
	ret

; waits for A button, then executes
; the function that is currently selected
; return carry set if selection was done
HandleTopBarSelection:
	xor a ; reset carry flag
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	ret z ; no A button

	ld a, [wTopBarSelection]
	bit TOPBAR_DAY_NIGHT_F, a
	jr nz, .DayNight
	bit TOPBAR_CUTSCENE_F, a
	jr nz, .Cutscene
	bit TOPBAR_COLLECTION_F, a
	jr nz, .Collection
	bit TOPBAR_NEXT_MAP_F, a
	jr nz, .NextMap
	bit TOPBAR_PREV_MAP_F, a
	jr nz, .PrevMap
	xor a
	ret

.DayNight:
	call .ShowPressedButton
	debgcoord 11, 19, wAttrmap
	call .ApplyPressedButtonAttrs
	ld a, OWBARS_DAY_NIGHT
	ld [wOWBarsState], a

.play_selection_sfx
	play_sfx SFX_SELECTION
	scf
	ret

.Cutscene:
	ld a, [wStoredTransitionParam]
	and a
	ret z
	call .ShowPressedButton
	debgcoord 9, 19, wAttrmap
	call .ApplyPressedButtonAttrs
	ld a, OWBARS_EVENT
	ld [wOWBarsState], a
	xor a
	ld [wOWBarsStateCounter], a
	jr .play_selection_sfx

.Collection:
	call .ShowPressedButton
	debgcoord 7, 19, wAttrmap
	call .ApplyPressedButtonAttrs
	ld a, OWBARS_COLLECTION
	ld [wOWBarsState], a
	xor a
	ld [wOWBarsStateCounter], a
	ld a, FALSE
	ld [wIsCollectionOpen], a
	jr .play_selection_sfx

.NextMap:
	call .ShowPressedButton
	call .ShowNextMapIndicatorFlash
	ld a, OWBARS_NEXT_MAP
	ld [wOWBarsState], a
	xor a
	ld [wOWBarsStateCounter], a
	jr .play_selection_sfx

.PrevMap:
	call .ShowPressedButton
	call .ShowNextMapIndicatorFlash
	ld a, OWBARS_NEXT_MAP
	ld [wOWBarsState], a
	xor a
	ld [wOWBarsStateCounter], a
	jr .play_selection_sfx

.ShowNextMapIndicatorFlash:
	ld hl, wOWUIObj2State
	jr .adv_obj_state
.ShowPressedButton:
	ld hl, wOWUIObj1State
.adv_obj_state
	ld a, [hl]
	inc a
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a
	ret

.ApplyPressedButtonAttrs:
	ld hl, TopBarButton_Pressed
	call WriteTopBarButton
	call ApplyTopBarButtonAttributes
	ret

LoadTopBarButtonAttributes:
	ld a, [wTopBarSelectableButtons]
	ld b, a

	; Day/Night Spell
	ld hl, TopBarButton_DayNight
	debgcoord 11, 19, wAttrmap
	call .LoadSelectableAttrs

	; Cutscene
	ld hl, TopBarButton_Cutscene
	debgcoord 9, 19, wAttrmap
	call .LoadSelectableAttrs

	; Collection
	ld hl, TopBarButton_Collection
	debgcoord 7, 19, wAttrmap
	call .LoadSelectableAttrs

	ld a, [wTopBarSelection]
	ld b, a

	; Day/Night Spell
	ld hl, TopBarButton_Selected
	debgcoord 11, 19, wAttrmap
	call .LoadSelectedAttrs

	; Cutscene
	ld hl, TopBarButton_Selected
	debgcoord 9, 19, wAttrmap
	call .LoadSelectedAttrs

	; Collection
	ld hl, TopBarButton_CollectionSelected
	debgcoord 7, 19, wAttrmap
	call .LoadSelectedAttrs ; can be fallthrough
	ret

.LoadSelectedAttrs:
	srl b
	ret nc
	jr WriteTopBarButton

.LoadSelectableAttrs:
	srl b
	jr c, WriteTopBarButton
	ld hl, TopBarButton_Unselectable ; non-selectable
;	fallthrough

WriteTopBarButton:
; loops twice, once for de + (2 * TILEMAP_WIDTH)
; and then for the original de
	push de
	ld a, e
	add 2 * TILEMAP_WIDTH
	ld e, a
	ld a, $00
	adc d
	ld d, a
	ld c, 2
.loop
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	dec e
	ld a, e
	add TILEMAP_WIDTH
	ld e, a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	dec c
	ret z
	pop de
	jr .loop

TopBarButton_Unselectable:
	db $3c, $3c, $3d, $3d
	db $0f, $2f, $0f, $2f

TopBarButton_DayNight:
	db $3e, $3e, $3f, $3f
	db $0f, $2f, $0f, $2f

TopBarButton_Cutscene:
	db $3a, $3a, $3b, $3b
	db $0f, $2f, $0f, $2f

TopBarButton_Collection:
	db $38, $38, $39, $39
	db $0f, $2f, $0f, $2f

TopBarButton_Selected:
	db $34, $35, $36, $37
	db $0f, $0f, $0f, $0f

TopBarButton_CollectionSelected:
	db $30, $31, $32, $33
	db $0f, $0f, $0f, $0f

TopBarButton_Pressed:
	db $48, $49, $4a, $4b
	db $0f, $0f, $0f, $0f

ApplyTopBarButtonAttributes:
	ld a, HIGH(wAttrmap tile $2a)
	ld [wHDMASourceHi], a
	ld a, LOW(wAttrmap tile $2a)
	ld [wHDMASourceLo], a
	ld a, $1b
	ld [wHDMADestHi], a
	ld a, $c0
	ld [wHDMADestLo], a
	ld a, $4 dma_tiles
	ld [wHDMAMode], a

	ld a, HIGH(wAttrmap tile $26)
	ld [wHDMAVRAM1SourceHi], a
	ld a, LOW(wAttrmap tile $26)
	ld [wHDMAVRAM1SourceLo], a
	ld a, $1b
	ld [wHDMAVRAM1DestHi], a
	ld a, $c0
	ld [wHDMAVRAM1DestLo], a
	ld a, $4 dma_tiles
	ld [wHDMAVRAM1Mode], a
	ret

; unreferenced
UnreferencedLCDFunc_SetBGMap1:
	ld hl, .func
	ld de, wLCDFunc
	ld b, .func_end - .func
	call CopyHLToDE
	ret

.func
LOAD UNION "LCD Function", WRAM0
	push af
	push bc
	push de
	push hl
	ld a, $02
	ldh [rWBK], a
	wait_hblank
	ld hl, rLCDC
	set B_LCDC_BG_MAP, [hl] ; use BGMap1
	ldh [rSCY], a
	ldh [rSCX], a
	xor a
	ldh [rWBK], a
	pop hl
	pop de
	pop bc
	pop af
	reti
ENDL
.func_end

; unreferenced
UnreferencedLCDFunc_Reti:
	ld hl, .func
	ld de, wLCDFunc
	ld b, .func_end - .func
	call CopyHLToDE
	ret

.func
LOAD UNION "LCD Function", WRAM0
	reti
ENDL
.func_end

HandleBottomBar:
	ld a, [wMapSideLevelID]
	ld c, a
	ld a, [wTargetMapSideLevelID]
	cp c
	jr nz, .walking
	ld a, [wBottomBarAction]
	cp BOTBAR_CLOSING
	jp z, .CloseBottomBar
	cp BOTBAR_OPENING
	jp z, .OpenBottomBar
	call .CheckBottomBarPossible
	ret c
	ld a, [wBottomBarAction]
	cp BOTBAR_OPENED
	jr z, .HandleOpenedBottomBar
	cp BOTBAR_CLOSED
	jr z, .HandleClosedBottomBar
	ret

.walking
	xor a
	ld [wUnused_2d096], a
	ld a, [wBottomBarAction]
	and a
	ret z ; is closed already
	cp BOTBAR_CLOSING
	jp z, .CloseBottomBar

	ld a, BOTBAR_CLOSING
	ld [wBottomBarAction], a
	xor a
	ld [wBottomBarState], a
	ld [wMagnifyingGlassCounter], a
	ret

; returns carry if opening
; the bottom bar is not possible
.CheckBottomBarPossible:
	ld a, [wOWLevel]
	add a
	; if it's either $00 (the Temple) or $80 (Junction)
	; then this will set z flag
	jr z, .set_carry
	ld a, [wOWStep]
	cp $05
	jr nz, .set_carry
	and a
	ret
.set_carry
	scf
	ret

.HandleClosedBottomBar:
	ld a, [wHasMagnifyingGlass]
	and a
	ret z ; no magnifying glass, exit
	ld hl, wMagnifyingGlassCounter
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr nz, .b_btn_down
	; reset counter
	xor a
	ld [hl], a
	ret
.b_btn_down
	inc [hl]
	ld a, [hl]
	cp 10
	ret c
	ld a, BOTBAR_OPENING
	ld [wBottomBarAction], a
	xor a
	ld [wBottomBarState], a
	ret

.HandleOpenedBottomBar:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	ret nz ; B button still pressed

	; no longer pressing B,
	; begin closing bar
	ld hl, wBottomBarFlags
	res 4, [hl]
	ld a, BOTBAR_CLOSING
	ld [wBottomBarAction], a
	xor a
	ld [wBottomBarState], a
	ret

.OpenBottomBar:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr z, .no_b_btn
	ld a, [wBottomBarState]
	jumptable

	dw .InitBar
	dw .OpenWindow
	dw .SetVisibleTreasures
	dw .SetBottomBarAsOpen

.no_b_btn
	ld hl, wBottomBarFlags
	res 4, [hl]
	ld a, BOTBAR_CLOSING
	ld [wBottomBarAction], a
	xor a
	ld [wBottomBarState], a
	ret

.InitBar:
	ld hl, wBottomBarFlags
	set 4, [hl]
	xor a
	ld [wHDMA], a
	ld [wHDMAVRAM1], a
	ld hl, wBottomBarState
	inc [hl]
	ret

.OpenWindow:
	ld hl, wWY
	ld b, [hl]
	ld a, $78
	cp b
	jr nc, .cap_min_wy
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	dec [hl]
	ret
.cap_min_wy
	ld [hl], a
	xor a
	ld [wMagnifyingGlassCounter], a
	ld hl, wBottomBarState
	inc [hl]
	ret

.SetVisibleTreasures:
	ld hl, wMagnifyingGlassCounter
	inc [hl]
	ld a, [hl]
	cp $03
	ret c
	xor a
	ld [hl], a

; here, we use the divider register to
; determine which treasure gfx to load
; so that they appear in "random" time intervals
	ld hl, wBottomBarFlags
.loop_outer ; loop until we set a bit that is unset
	ldh a, [rDIV]
	and $0f
	inc a
	ld c, $00
	scf
.loop_inner
	rl c
	dec a
	jr nz, .loop_inner
	; make it so the set bit is
	; in the bottom nybble
	ld a, $0f
	and c
	jr nz, .bottom_nybble_bit
	swap c
.bottom_nybble_bit
	ld a, c
	and [hl]
	jr nz, .loop_outer ; loop if is already set

	ld a, c
	or [hl]
	ld [hl], a
	and $0f
	cp $0f
	ret nz ; exit if still some unset bits
	; all set, advance
	ld hl, wBottomBarState
	inc [hl]
	ret

.SetBottomBarAsOpen:
	ld a, BOTBAR_OPENED
	ld [wBottomBarAction], a
	xor a
	ld [wBottomBarState], a
	ld hl, wBottomBarFlags
	bit 6, [hl]
	ret z
	set 7, [hl]
	ret

.CloseBottomBar:
	ld a, [wBottomBarState]
	jumptable

	dw .CloseWindow
	dw .DeinitBar

.CloseWindow:
	ld hl, wWY
	ld a, [hl]
	cp SCREEN_HEIGHT_PX
	jr nc, .cap_max_wy
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	inc [hl]
	ret
.cap_max_wy
	ld [hl], SCREEN_HEIGHT_PX
	ld hl, wBottomBarState
	inc [hl]
	ret

.DeinitBar:
	ld hl, wBottomBarFlags
	ld a, $1 << 6
	and [hl]
	ld [hl], a
	xor a
	ld [wCompassObjState], a
	ld [wCompassObjUnk7], a
	xor a ; unnecessary
	ld [wBottomBarAction], a
	xor a ; unnecessary
	ld [wBottomBarState], a
	ld [wMagnifyingGlassCounter], a
	ret

DrawBottomBar:
	ld a, [wGameModeFlags]
	bit MODE_TIME_ATTACK_F, a
	jp nz, DrawBottomBarTimeAttack

	ld a, [wLevelGreyTreasurePal]
	ld c, a
	ld e, $00
	ld a, [wBottomBarFlags]
	bit 0, a
	jr nz, .has_grey
	ld e, $09
	ld c, $00
.has_grey
	ld d, $20
	call LoadSpriteInsideWindow_Low

	ld a, [wLevelRedTreasurePal]
	ld c, a
	ld e, $01
	ld a, [wBottomBarFlags]
	bit 1, a
	jr nz, .has_red
	ld e, $09
	ld c, $00
.has_red
	ld d, $3c
	call LoadSpriteInsideWindow_Low

	ld a, [wLevelGreenTreasurePal]
	ld c, a
	ld e, $02
	ld a, [wBottomBarFlags]
	bit 2, a
	jr nz, .has_green
	ld e, $09
	ld c, $00
.has_green
	ld d, $58
	call LoadSpriteInsideWindow_Low

	ld a, [wLevelBlueTreasurePal]
	ld c, a
	ld e, $03
	ld a, [wBottomBarFlags]
	bit 3, a
	jr nz, .has_blue
	ld e, $09
	ld c, $00
.has_blue
	ld d, $74
	call LoadSpriteInsideWindow_Low

	call DrawBottomBarButtonPrompt
	call DrawBottomBar8Coin
	ret

LoadSpriteInsideWindow_High:
	ld b, $20
	jr LoadSpriteInsideWindow

LoadSpriteInsideWindow_Low:
	ld b, $24
;	fallthrough

; b = y coord
; d = x coord
; e = tile ID
; c = attributes
LoadSpriteInsideWindow:
	ld a, [wWY]
	add b
	ld [wCurSpriteYCoord], a
	ld a, [wWX]
	add d
	ld [wCurSpriteXCoord], a
	ld a, e
	ld [wCurSpriteFrame], a
	ld a, c
	ld [wCurSpriteAttributes], a
	ld hl, OWUIOAM_aa0cf
	ld b, BANK(OWUIOAM_aa0cf)
	call LoadOWSpriteWithScroll_GotParams
	ret

DrawBottomBar8Coin:
	ld a, [wBottomBarFlags]
	bit 7, a
	ret z
	ld hl, wCompassObjState
	ld de, BottomBarFrameset_aa2fb
	ld b, BANK(BottomBarFrameset_aa2fb)
	call UpdateOWAnimation
	ld d, $90
	ld hl, wCompassObjDuration
	ld a, [hli]
	ld e, a
	ld c, $00
	jr LoadSpriteInsideWindow_Low

DrawBottomBarButtonPrompt:
	ld a, [wHasMagnifyingGlass]
	and a
	ret z
	ld b, $04
	ld a, [wOWLevel]
	add a
	jr nz, .valid_level
	; wOWLevel == $00 or $80
	ld b, $06
	jr .got_tile
.valid_level
	ld a, [wBottomBarFlags]
	bit 4, a
	jr z, .got_tile
	ld b, $05
.got_tile
	ld a, b
	ld [wCurSpriteFrame], a
	ld a, [wWY]
	add $10
	ld [wCurSpriteYCoord], a
	ld a, [wWX]
	add $10
	ld [wCurSpriteXCoord], a
	ld a, $00
	ld [wCurSpriteAttributes], a
	ld hl, CompassOAM_aa580
	ld b, BANK(CompassOAM_aa580)
	call LoadOWSpriteWithScroll_GotParams
	ret

DrawBottomBarTimeAttack:
	call DrawBottomBarTimeAttackScore
	call DrawBottomBarButtonPrompt
	call DrawBottomBar8Coin
	ret

DrawBottomBarTimeAttackScore:
	ld a, [w2d0ee]
	and $f0
	swap a ; top nybble
	add $1e
	ld e, a
	ld c, $00
	ld d, $50
	call LoadSpriteInsideWindow_High
	ld a, [w2d0ee]
	and $0f ; bottom nybble
	add $1e
	ld e, a
	ld c, $00
	ld d, $58
	call LoadSpriteInsideWindow_High
	ld a, [w2d0ef]
	and $f0
	swap a ; top nybble
	add $1e
	ld e, a
	ld c, $00
	ld d, $68
	call LoadSpriteInsideWindow_High
	ld a, [w2d0ef]
	and $0f ; bottom nybbles
	add $1e
	ld e, a
	ld c, $00
	ld d, $70
	call LoadSpriteInsideWindow_High
	ret

UnlockLevel:
	ld hl, wOWFuncCounter
	inc [hl]
	ld a, [wOWFuncStep]
	jumptable

	dw UnlockLevel_Init
	dw OWScene_FadeToGrey
	dw OWScene_Wait20
	dw OWScene_LoadLevelName
	dw OWScene_FadeInLevelName
	dw OWScene_LoadStarIndicatorPals
	dw UnlockLevel_GetArrows
	dw UnlockLevel_WaitHighlight
	dw UnlockLevel_ShowArrow1
	dw UnlockLevel_WaitHighlight
	dw UnlockLevel_ShowArrow2
	dw UnlockLevel_WaitHighlight
	dw UnlockLevel_ShowLevelPoint
	dw UnlockLevel_WaitHighlight30
	dw UnlockLevel_ShowStar
	dw UnlockLevel_End

; fade to grey
OWScene_FadeToGrey:
	farcall OWGreyTransition
	ld a, [wOWPalTransitionState]
	and a
	ret nz
	; done fading
	di
	call VBlank_OWScene
	ei
	jp AdvanceOWFunc_UnlockLevel

OWScene_Wait20:
	ld a, 20
	ld hl, wOWFuncCounter
	cp [hl]
	ret nc
	jr AdvanceOWFunc_UnlockLevel

OWScene_LoadLevelName:
	ld a, [wOWSceneMapSide]
	ld b, a ; map side
	ld a, [wLevel2]
	ld d, a ; map side level index
	cp OW_EXITS
	jr nc, .is_exit
	call LoadLevelName
	xor a
	ld [wPalConfig1TotalSteps], a
	jr AdvanceOWFunc_UnlockLevel

.is_exit
	; skip name fade in
	ld a, $2
	ld hl, wOWFuncStep
	add [hl]
	ld [hld], a
	xor a
	ld [hl], a ; wOWFuncCounter
	ret

OWScene_FadeInLevelName:
	farcall FadeInLevelName
	srl c
	ret c
	jr AdvanceOWFunc_UnlockLevel

OWScene_LoadStarIndicatorPals:
	ld a, [wOWFuncCounter]
	cp 16
	ret c
	farcall LoadOWStarIndicatorPals
	jr AdvanceOWFunc_UnlockLevel

UnlockLevel_Init:
	call GetUnlockedOWLevelData
	xor a
	ld [wOWPathShape], a
	ld [wLevelArrowIndex], a
	xor a
	ld hl, wCurSceneObj
	ld bc, $8
	call WriteAToHL_BCTimes
;	fallthrough

AdvanceOWFunc_UnlockLevel:
	xor a
	ld [wOWFuncCounter], a
	ld hl, wOWFuncStep
	inc [hl]
	ret

UnlockLevel_GetArrows:
	call GetUnlockedLevelArrows
	jr AdvanceOWFunc_UnlockLevel

UnlockLevel_WaitHighlight:
	ld a, [wHighlightOWTile]
	and a
	jr z, .wait
	xor a
	ld [wOWFuncCounter], a
	ret
.wait
	ld a, [wOWFuncCounter]
	cp 4
	ret c
	jr AdvanceOWFunc_UnlockLevel

UnlockLevel_ShowArrow1:
	call IsLeftExitOrJunction
	jr z, AdvanceOWFunc_UnlockLevel
	ld a, [wLevelArrowDirections1]
	call GetConnectedLevel1ArrowCoord
	call GetConnectedLevel1CoordsInTilemap
	ld a, [wLevelArrowDirections1]
	ld hl, wAttrToPlaceInOW
	call ShowLevelArrowInOW
	ld a, TRUE
	ld [wHighlightOWTile], a
	play_sfx SFX_PATH_ARROW
UnlockLevel_HighlightTileAndAdvance:
	call ApplyHighlightPalToOWTile
	call PlacePendingOWTiles
	jr AdvanceOWFunc_UnlockLevel

; return z if 1st connected level is left exit
; or if it is North's map side junction
IsLeftExitOrJunction:
	ld a, [wLevel1]
	cp OW_EXIT_LEFT
	ret z ; is left exit
	ld c, a
	ld a, [wOWSceneMapSide]
	and a
	ret nz ; not North
	ld a, OWNORTH_JUNCTION
	cp c
	ret

UnlockLevel_ShowArrow2:
	ld a, [wLevel2]
	cp OW_EXIT_RIGHT
	jr z, AdvanceOWFunc_UnlockLevel
	ld a, [wOWXCoord2]
	ld [wOWXCoord1], a
	ld a, [wOWYCoord2]
	ld [wOWYCoord1], a
	ld a, [wLevelArrowDirections2]
	ld [wLevelArrowDirections1], a
	call GetConnectedLevel1ArrowCoord
	call GetConnectedLevel1CoordsInTilemap
	ld a, [wLevelArrowDirections1]
	ld hl, wAttrToPlaceInOW
	call ShowLevelArrowInOW
	ld a, $01
	ld [wHighlightOWTile], a
	play_sfx SFX_PATH_ARROW
	jp UnlockLevel_HighlightTileAndAdvance

UnlockLevel_ShowLevelPoint:
	ld a, [wLevel2]
	cp OW_EXIT_RIGHT
	jp z, AdvanceOWFunc_UnlockLevel
	ld hl, wOWCoords2
	call GetOWCoordInTilemap
	ld hl, wAttrToPlaceInOW
	call ShowLevelPointInOW
	ld a, $01
	ld [wHighlightOWTile], a
	jp UnlockLevel_HighlightTileAndAdvance

ShowLevelPointInOW:
	ld b, a
	xor a
	ld [hld], a ; attribute
	ld a, $00 ; unnecessary
	ld [hl], a ; tile
	ret

ShowLevelArrowInOW:
	ld b, a
	xor a
	ld [hl], a ; attribute
	bit B_PAD_RIGHT, b
	jr nz, .right
	bit B_PAD_LEFT, b
	jr nz, .left
	bit B_PAD_UP, b
	jr nz, .up
	bit B_PAD_DOWN, b
	jr nz, .down
	ret
.left
	set 5, [hl] ; x-flip
.right
	dec l
	ld a, $02 ; horizontal arrow
	ld [hl], a ; tile
	ret
.down
	set 6, [hl] ; y-flip
.up
	dec l
	ld a, $01 ; vertical arrow
	ld [hl], a ; tile
	ret

UnlockLevel_WaitHighlight30:
	ld a, [wHighlightOWTile]
	and a
	jr z, .wait
	xor a
	ld [wOWFuncCounter], a
	ret
.wait
	ld a, [wOWFuncCounter]
	cp 30
	ret c
	jp AdvanceOWFunc_UnlockLevel

UnlockLevel_ShowStar:
	ld a, [wOWFuncCounter]
	cp $01
	jr z, .spawn_star
	cp $40
	ret c
	jp AdvanceOWFunc_UnlockLevel
.spawn_star
	ld a, [wLevel2]
	cp OW_EXITS
	jp nc, AdvanceOWFunc_UnlockLevel
	ld a, [wOWYCoord2]
	ld [wCurSceneObjYCoord], a
	ld a, [wOWXCoord2]
	ld [wCurSceneObjXCoord], a
	ld a, $01
	ld [wCurSceneObjState], a
	play_sfx SFX_LEVEL_STAR
	ret

UnlockLevel_End:
	ld a, [wOWFuncCounter]
	cp 30
	ret c
	xor a
	ld [wOWSceneActionParam], a
	ld [wOWFuncStep], a
	ret

DrawUnlockLevelStar:
	ld a, [wOWSceneAction]
	cp UNLOCK_LEVEL
	ret nz
	ld a, [wCurSceneObjState]
	and a
	ret z
	ld de, UnlockLevelStarFrameset_aa544
	ld hl, wCurSceneObjDuration
	ld b, BANK(UnlockLevelStarFrameset_aa544)
	call UpdateOWAnimation
	ld hl, wCurSceneObj
	ld de, LevelStarOAM_aa445
	ld b, BANK(LevelStarOAM_aa445)
	call LoadOWSpriteWithScroll
	ret

DrawHighlightLevelStar:
	ld a, [wOWSceneAction]
	cp HIGHLIGHT_LEVEL
	ret nz
	ld a, [wCurSceneObjState]
	and a
	ret z
	ld hl, wCurSceneObjDuration
	ld de, HighlightLevelStarFrameset_aa555
	ld b, BANK(HighlightLevelStarFrameset_aa555)
	call UpdateOWAnimation
	ld a, [wOWAnimationFinished]
	cp $ff
	jr z, .finished
	ld hl, wCurSceneObj
	ld de, LevelStarOAM_aa445
	ld b, BANK(LevelStarOAM_aa445)
	call LoadOWSpriteWithScroll
	ret
.finished
	ld hl, wCurSceneObjState
	xor a
	ld [hl], a
	ret

InitHighlightLevelScene:
	ld a, [wEventUnlockState]
	cp $80
	ret nz
	ld hl, OWStarIndicatorPals
	ld de, wTempPals2 palette 4
	ld c, 2 palettes
	ld b, BANK(OWStarIndicatorPals)
	call CopyFarBytes
	ret

WaitOWFunc_Bank20:
	ld hl, wOWFuncCounter
	cp [hl]
	ret nc
AdvanceOWFunc_Bank20:
	xor a
	ld hl, wOWFuncCounter
	ld [hli], a
	inc [hl] ; wOWFuncStep
	ret

EndOWFunc_Bank20:
	xor a
	ld [wOWSceneActionParam], a
	ld hl, wOWFuncCounter
	ld [hli], a
	ld [hl], a ; wOWFuncStep
	ret

HighlightLevel:
	ld hl, wOWFuncCounter
	inc [hl]
	ld a, [wOWFuncStep]
	jumptable
	dw .Init
	dw .Wait12
	dw OWScene_FadeToGrey
	dw OWScene_Wait20
	dw OWScene_LoadLevelName
	dw OWScene_FadeInLevelName
	dw OWScene_LoadStarIndicatorPals
	dw .ShowStar
	dw .WaitStarDone
	dw .Wait30
	dw EndOWFunc_Bank20

.Wait30:
	ld a, 30
	jr WaitOWFunc_Bank20

.Init:
	ld a, [wCurMapSide]
	sub 1
	ccf
	; carry set if not North
	ld a, [wOWSceneActionParam]
	sbc 0
	ld [wLevel2], a
	ld a, [wCurEvent]
	cp EVENT_GOLD_MUSIC_BOX
	jr z, .gold_music_box
	cp EVENT_SUPER_GRAB_GLOVES
	jr z, .super_grab_gloves
.next
	jp AdvanceOWFunc_Bank20

.gold_music_box
	ld a, $07
	ld [wOWSceneActionParam], a
	jr .next

.super_grab_gloves
	ld a, [wCurMapSide]
	cp EAST
	jr nz, .next
	ld a, [wOWSceneActionParam]
	cp $07
	jr nz, .next
	ld a, MYSTERY_HANDLE
	call IsTreasureCollected
	jr nz, .next
	jr EndOWFunc_Bank20

.Wait12:
	ld a, 12
	jr WaitOWFunc_Bank20

.ShowStar:
	ld a, [wLevel2]
	ld c, a
	ld de, wCurSceneObj
	call SetObjPositionToLevelCoords
	ld a, $02
	ld hl, wCurSceneObjState
	call SetSceneObjState
	play_sfx SFX_LEVEL_STAR
	jp AdvanceOWFunc_Bank20

.WaitStarDone:
	ld a, [wCurSceneObjState]
	and a
	ret nz
	jp AdvanceOWFunc_Bank20
