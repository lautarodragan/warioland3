SETCHARMAP temple

; Form table: 6 bytes per entry
;   [0]     transformation byte
;   [1-5]   5-char display name
DebugFormTable:
	db TRANSFORMATION_NONE,                "NONE "
	db TRANSFORMATION_HOT_WARIO,           "HOT  "
	db TRANSFORMATION_FLAT_WARIO,          "FLAT "
	db TRANSFORMATION_BALL_O_STRING_WARIO, "STRNG"
	db TRANSFORMATION_FAT_WARIO,           "FAT  "
	db TRANSFORMATION_ELECTRIC,            "ELEC "
	db TRANSFORMATION_PUFFY_WARIO,         "PUFFY"
	db TRANSFORMATION_ZOMBIE_WARIO,        "ZOMBI"
	db TRANSFORMATION_BOUNCY_WARIO,        "BUNCY"
	db TRANSFORMATION_CRAZY_WARIO,         "CRAZY"
	db TRANSFORMATION_VAMPIRE_WARIO,       "VAMPI"
	db TRANSFORMATION_SNOWMAN_WARIO,       "SNWMN"
	db TRANSFORMATION_INVISIBLE_WARIO,     "INVIS"

DEF NUM_DEBUG_FORMS  EQU 13
DEF NUM_DEBUG_POWERS EQU 10

; menu items, in wDebugMenuCursor order
	const_def
	const DEBUG_MENU_FORM
	const DEBUG_MENU_POWER
	const DEBUG_MENU_GOLF
	const DEBUG_MENU_OWL
	const DEBUG_MENU_TREASURE
DEF DEBUG_MENU_ITEMS EQU const_value

; where the cursor and the values go (the rest of the screen, labels
; included, is in debug_menu.tilemap: see tools/debug_menu_bgmap.py)
DEF DEBUG_MENU_CURSOR_X EQU 2
DEF DEBUG_MENU_VALUE_X  EQU 11
DEF DEBUG_MENU_FORM_Y     EQU 5
DEF DEBUG_MENU_POWER_Y    EQU 7
DEF DEBUG_MENU_GOLF_Y     EQU 9
DEF DEBUG_MENU_OWL_Y      EQU 11
DEF DEBUG_MENU_TREASURE_Y EQU 13
DEF DEBUG_MENU_TREASURE_VALUE_X EQU 5 ; on the row below its label

; Strings for menu values (temple charmap)
; level codes, 2 bytes per level, in level order
DebugLevelCodes:
	db "N1N2N3N4N5N6"
	db "W1W2W3W4W5W6"
	db "S1S2S3S4S5S6"
	db "E1E2E3E4E5E6E7"
; treasure colours, 3 bytes each, in LevelTreasureIDs order
DebugTreasureColours: db "GRYREDGRNBLU"
DebugMenuStrOn:     db "ON "              ; 3 bytes
DebugMenuStrOff:    db "OFF"              ; 3 bytes
DebugMenuStrOk:     db "OK "              ; 3 bytes
DebugMenuStrNo:     db "NO "              ; 3 bytes

SETCHARMAP main

_DebugMenuStateTable::
	ld a, [wSubState]
	jumptable
	dw InitDebugMenu
	dw UpdateDebugMenu

; -----------------------------------------------------------------------
; Copy B bytes from [DE] to [HL+]
; -----------------------------------------------------------------------
DebugMenu_DrawString:
.loop
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ret

; -----------------------------------------------------------------------
; Apply the currently selected form.
; Calls the appropriate game SetState_* function after setting up all
; required wario state vars (transformation, touch states, GFX, OAM).
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_ApplyForm:
	ld a, [wDebugMenuFormIdx]
	jumptable
	dw .form_none
	dw .form_hot
	dw .form_flat
	dw .form_string
	dw .form_fat
	dw .form_electric
	dw .form_puffy
	dw .form_zombie
	dw .form_bouncy
	dw .form_crazy
	dw .form_vampire
	dw .form_snowman
	dw .form_invisible

; NONE: restore normal Wario state without playing the in-game recovery SFX
.form_none:
	call ClearTransformationValues
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, [wJumpVelTable]
	and a
	jr nz, .form_none_fall
	farcall SetState_Idling
	ret
.form_none_fall:
	farcall StartFall
	ret

; HOT: bump-type transformation (kills with touch)
.form_hot:
	ld a, TRANSFORMATION_HOT_WARIO
	ld [wTransformation], a
	ld a, 1
	ld [wTransformationProgress], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	ld a, HIGH(HOT_WARIO_DURATION)
	ld [wTransformationDuration], a
	ld a, LOW(HOT_WARIO_DURATION)
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	; SetState_OnFire_ResetStateCounter loads WarioHotGfx, OAM_1673c,
	; sets WarioOnFirePal, WST_ON_FIRE, collision box, clears state vars
	farcall SetState_OnFire_ResetStateCounter
	ret

; FLAT: slide GFX, different collision box
.form_flat:
	ld a, TRANSFORMATION_FLAT_WARIO
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	; Flat wario uses slide GFX + OAM_16e9d (SetState_FlatIdling doesn't load GFX)
	ld a, BANK(WarioSlideGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSlideGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSlideGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_16e9d)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_16e9d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_16e9d)
	ld [wWarioOAMPtr + 1], a
	farcall SetState_FlatIdling
	ret

; BALL-O-STRING: attack-type, rolls fast
.form_string:
	ld a, TRANSFORMATION_BALL_O_STRING_WARIO
	ld [wTransformation], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioStringPal
	call SetWarioPal
	; SetState_BallOString doesn't load GFX, so load here
	ld a, BANK(WarioStringGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioStringGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioStringGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_171c0)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_171c0)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_171c0)
	ld [wWarioOAMPtr + 1], a
	farcall SetState_BallOString
	ret

; FAT: bump-type, SetState_FatIdling sets wTouchState/wSpikeTouchState itself
.form_fat:
	ld a, TRANSFORMATION_FAT_WARIO
	ld [wTransformation], a
	ld a, HIGH(FAT_WARIO_DURATION)
	ld [wTransformationDuration], a
	ld a, LOW(FAT_WARIO_DURATION)
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	; SetState_FatIdling doesn't load GFX, so load here
	ld a, BANK(WarioFatGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioFatGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioFatGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_1742d)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_1742d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_1742d)
	ld [wWarioOAMPtr + 1], a
	; SetState_FatIdling sets wTouchState=ATTACK, wStingTouchState=ATTACK, wSpikeTouchState=$01,
	; and standard collision box
	farcall SetState_FatIdling
	ret

; ELECTRIC: vanish-type (touches make enemies disappear), inline full setup
.form_electric:
	ld a, TRANSFORMATION_ELECTRIC
	ld [wTransformation], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wInvisibleFrame], a
	ld a, WST_ELECTRIC_START
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	call UpdateLevelMusic
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld hl, WarioElectricPal
	call SetWarioPal
	ld a, BANK(WarioElectricGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioElectricGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioElectricGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_1790e)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_1790e)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_1790e)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .elec_right
	ld a, HIGH(Frameset_17b79)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(Frameset_17b79)
	ld [wWarioFramesetPtr + 1], a
	jr .elec_anim
.elec_right:
	ld a, HIGH(Frameset_17b76)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(Frameset_17b76)
	ld [wWarioFramesetPtr + 1], a
.elec_anim:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

; PUFFY: SetState_PuffyInflating sets wTransformation/wTouchState/wSpikeTouchState/GFX itself
.form_puffy:
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_PuffyInflating
	ret

; ZOMBIE: SetState_ZombieIdling sets wTouchState/wSpikeTouchState/GFX/OAM itself
.form_zombie:
	ld a, TRANSFORMATION_ZOMBIE_WARIO
	ld [wTransformation], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_ZombieIdling
	ret

; BOUNCY: SetState_BouncyStart loads GFX/OAM/palette itself
.form_bouncy:
	ld a, TRANSFORMATION_BOUNCY_WARIO
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_BouncyStart
	ret

; CRAZY: SetState_CrazySpinning loads GFX/OAM itself; mirror wDirection to wObjDirection
.form_crazy:
	ld a, TRANSFORMATION_CRAZY_WARIO
	ld [wTransformation], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	; SetState_CrazySpinning copies wObjDirection → wDirection; mirror current direction
	ld a, [wDirection]
	ld [wObjDirection], a
	farcall SetState_CrazySpinning
	ret

; VAMPIRE: set state, wTouchState, palette; SetState_VampireIdling loads GFX/OAM
.form_vampire:
	ld a, TRANSFORMATION_VAMPIRE_WARIO
	ld [wTransformation], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	ld hl, WarioVampirePal
	call SetWarioPal
	; Reset collision box (SetState_VampireIdling doesn't set it)
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	; SetState_VampireIdling sets wWarioOAMPtr but not wWarioOAMBank; set it here since
	; we bypass the normal VampireTransforming → VampireIdling path.
	ld a, BANK("Wario OAM 2")
	ld [wWarioOAMBank], a
	farcall SetState_VampireIdling
	ret

; SNOWMAN: SetState_TurningIntoSnowman does full GFX/OAM/palette setup
.form_snowman:
	ld a, TRANSFORMATION_SNOWMAN_WARIO
	ld [wTransformation], a
	xor a
	ld [wTransformationProgress], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	ld a, $FF
	ld [wTransformationDuration], a
	ld [wTransformationDuration + 1], a
	farcall SetState_TurningIntoSnowman
	ret

; INVIS: what UpdateState_TurningInvisible does when the potion animation
; ends (another form, NONE included, turns it off)
.form_invisible:
	ld a, TRANSFORMATION_INVISIBLE_WARIO
	ld [wTransformation], a
	xor a
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld [wSpikeTouchState], a
	ld [wIsIntangible], a
	call UpdateLevelMusic
	ld a, [wJumpVelTable]
	and a
	jr nz, .form_invisible_fall
	farcall SetState_Idling
	ret
.form_invisible_fall:
	farcall StartFall
	ret

; -----------------------------------------------------------------------
; Spawn an owl next to Wario (from the room's object group if it has one,
; otherwise from ROM), and record the outcome in wDebugMenuOwlStatus
; (1 = spawned, 2 = not: no free object slot, or a boss battle).
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_SpawnOwl:
	; Bosses keep their own graphics in the enemy slots, the owl's included
	; (it would overwrite part of the boss): no owl in a boss battle.
	ld a, [wIsBossBattle]
	and a
	ld a, 2
	jr nz, .got_status
	push_wram BANK("Level Objects WRAM")
	ld c, OWL
	farcall _DebugSpawnObject
	pop_wram
	ld a, b
	and a
	jr nz, .spawned
	; This room's object group has no owl: spawn one from ROM, and load its
	; graphics when the menu closes (VRAM is restored then), into an enemy
	; graphics slot the group doesn't use (slot 1 if it uses all four).
	push_wram BANK("Level Objects WRAM")
	farcall _DebugSpawnOwlFromROM
	pop_wram
	ld a, b
	and a
	ld a, 2
	jr z, .got_status
	ld a, TRUE
	ld [wDebugMenuOwlGfxPending], a
.spawned
	ld a, 1
.got_status
	ld [wDebugMenuOwlStatus], a
	ret

; -----------------------------------------------------------------------
; Treasure picked on the TREASURE row (wDebugMenuTreasureIdx = level * 4 +
; colour, the LevelTreasureIDs layout).
; output: a = treasure ID
; -----------------------------------------------------------------------
DebugMenu_GetTreasureID:
	ld a, [wDebugMenuTreasureIdx]
	ld e, a
	ld d, 0
	ld hl, LevelTreasureIDs_WithoutTemple
	add hl, de
	ld a, [hl]
	ret

; output: carry set if the picked treasure is collected
; Clobbers: A, B, D, E, H, L
DebugMenu_IsTreasureCollected:
	call DebugMenu_GetTreasureID
	ld b, a
	push_wram BANK(wTreasuresCollected)
	ld a, b
	call IsTreasureCollected
	ld b, a ; TRUE if collected
	pop_wram
	ld a, b
	and a ; clears carry
	ret z
	scf
	ret

; Gives or takes the picked treasure. Level variants that need it change
; the next time a level is entered from the map.
; Clobbers: A, B, D, E, H, L
DebugMenu_ToggleTreasure:
	call DebugMenu_GetTreasureID
	ld b, a
	push_wram BANK(wTreasuresCollected)
	ld a, b
	call IsTreasureCollected
	; hl = byte in wTreasuresCollected, d = the treasure's bit
	ld a, [hl]
	xor d
	ld [hl], a
	pop_wram
	farcall UpdateNumCollectedTreasures
	ret

; -----------------------------------------------------------------------
; Draw the cursor and the values (LCD must be off or in VBlank); the rest is
; in debug_menu.tilemap
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawAll:
	call DebugMenu_DrawItems1
	jp DebugMenu_DrawItems2

; -----------------------------------------------------------------------
; Write the cursor (▼) to hl if item c is selected, a space otherwise.
; Clobbers: A
; -----------------------------------------------------------------------
DebugMenu_DrawCursor:
	ld a, [wDebugMenuCursor]
	cp c
	ld a, $5d ; ▼
	jr z, .got_char
	ld a, $7e ; space
.got_char
	ld [hl], a
	ret

; -----------------------------------------------------------------------
; The items, in two halves: redrawing all of them takes longer than one
; V-Blank, and VRAM can't be written while the LCD draws.
; -----------------------------------------------------------------------
DebugMenu_DrawItems1:
	; FORM: the form's name
	ld c, DEBUG_MENU_FORM
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_FORM_Y
	call DebugMenu_DrawCursor
	; de = &DebugFormTable[formIdx].name (entries are 6 bytes, name at +1)
	ld a, [wDebugMenuFormIdx]
	add a ; 2*idx
	ld c, a
	add a ; 4*idx
	add c ; 6*idx
	ld c, a
	ld b, 0
	ld hl, DebugFormTable + 1 ; +1: skip transform byte
	add hl, bc
	ld d, h
	ld e, l
	hlbgcoord DEBUG_MENU_VALUE_X, DEBUG_MENU_FORM_Y
	ld b, 5
	call DebugMenu_DrawString

	; POWER: a digit
	ld c, DEBUG_MENU_POWER
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_POWER_Y
	call DebugMenu_DrawCursor
	ld a, [wPowerUpLevel]
	add $30 ; digit in temple charmap ($30-$39)
	ldcoord_a DEBUG_MENU_VALUE_X, DEBUG_MENU_POWER_Y

	; GOLF: ON or OFF
	ld c, DEBUG_MENU_GOLF
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_GOLF_Y
	call DebugMenu_DrawCursor
	ld a, [wIsMinigameCleared]
	and a
	ld de, DebugMenuStrOn
	jr nz, .draw_golf_val
	ld de, DebugMenuStrOff
.draw_golf_val
	hlbgcoord DEBUG_MENU_VALUE_X, DEBUG_MENU_GOLF_Y
	ld b, 3
	jp DebugMenu_DrawString

DebugMenu_DrawItems2:
	; OWL: LEFT/RIGHT spawns an owl, the value shows whether the last try
	; worked
	ld c, DEBUG_MENU_OWL
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_OWL_Y
	call DebugMenu_DrawCursor
	ld a, [wDebugMenuOwlStatus]
	and a
	jr z, .owl_status_done
	dec a
	ld de, DebugMenuStrOk
	jr z, .draw_owl_status
	ld de, DebugMenuStrNo
.draw_owl_status
	ld b, 3
	hlbgcoord DEBUG_MENU_VALUE_X, DEBUG_MENU_OWL_Y
	call DebugMenu_DrawString
.owl_status_done

	; TREASURE: LEFT/RIGHT picks a level's treasure, A gives or takes it.
	; Shows e.g. "N5 RED ON", on the row below the label.
	ld c, DEBUG_MENU_TREASURE
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_TREASURE_Y
	call DebugMenu_DrawCursor
	ld a, [wDebugMenuTreasureIdx]
	srl a
	srl a ; level
	add a ; 2 bytes per code
	ld e, a
	ld d, 0
	ld hl, DebugLevelCodes
	add hl, de
	ld d, h
	ld e, l
	hlbgcoord DEBUG_MENU_TREASURE_VALUE_X, DEBUG_MENU_TREASURE_Y + 1
	ld b, 2
	call DebugMenu_DrawString
	ld a, $7e ; space
	ld [hli], a
	ld a, [wDebugMenuTreasureIdx]
	and %11 ; colour
	ld c, a
	add a
	add c ; 3 bytes per colour
	ld e, a
	ld d, 0
	push hl
	ld hl, DebugTreasureColours
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld b, 3
	call DebugMenu_DrawString
	ld a, $7e ; space
	ld [hli], a
	push hl
	call DebugMenu_IsTreasureCollected
	pop hl
	ld de, DebugMenuStrOn
	jr c, .draw_treasure_status
	ld de, DebugMenuStrOff
.draw_treasure_status
	ld b, 3
	jp DebugMenu_DrawString

; -----------------------------------------------------------------------
; Load the menu's screen: the font in VRAM0, the pause menu's graphics in
; VRAM1 (for the frame), the map and the palettes. See
; tools/debug_menu_bgmap.py for the layout. The LCD must be off.
; -----------------------------------------------------------------------
DebugMenu_LoadScreen:
	farcall LoadFontTiles
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, PauseMenuGfx
	ld bc, v1Tiles0
	ld a, BANK(PauseMenuGfx)
	ldh [hCallFuncBank], a
	hcall Decompress
	ld hl, DebugMenuAttrmap
	ld bc, v1BGMap0
	call Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, DebugMenuTilemap
	ld bc, v0BGMap0
	call Decompress
	ld hl, DebugMenuPals
	ld de, wTempPals1
	ld b, 8 palettes
	jp CopyHLToDE_Short

DebugMenuTilemap: INCBIN "data/bgmaps/debug_menu.tilemap.rle"
DebugMenuAttrmap: INCBIN "data/bgmaps/debug_menu.attrmap.rle"

; The font draws its glyphs in colour 0 on colour 3: the text palettes are a
; text colour on the colour of what's behind it.
DebugMenuPals:
	; 0: title, yellow on the title band's dark blue
	rgb 31, 31,  0
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  7,  2, 23
	; 1-4: the pause menu's (Pals_1f4182), for its gems, the checkered
	; band and the yellow frame
	rgb 27, 31, 18
	rgb 16, 26,  8
	rgb  4, 18,  2
	rgb  0, 14,  0

	rgb 31, 17, 17
	rgb 29, 14, 12
	rgb 27,  7,  5
	rgb 10,  2,  0

	rgb 31, 31, 31
	rgb  9, 10, 31
	rgb  7,  2, 23
	rgb  0,  0,  0

	rgb 31, 27,  0
	rgb 26, 11,  1
	rgb 11,  0,  1
	rgb  0,  0,  0
	; 5: labels, white on the frame's dark red
	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb 11,  0,  1
	; 6: cursor and values, yellow on dark red
	rgb 31, 27,  0
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb 11,  0,  1
	; 7: instructions, white on dark blue
	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  7,  2, 23

; -----------------------------------------------------------------------
; Substate 0: initialise debug menu display
; -----------------------------------------------------------------------
InitDebugMenu:
	call DisableLCD
	call SaveBackupVRAM

	; Save animated tile state (GFX RAM already active from wrapper)
	ld a, [wAnimatedTilesFrameDuration]
	ld [wTempAnimatedTilesFrameDuration], a
	ld a, [wAnimatedTilesGfx]
	ld [wTempAnimatedTilesGroup], a

	; Init cursor to first item; keep wDebugMenuFormIdx in sync with
	; wTransformation so the display starts on the current form
	xor a
	ld [wDebugMenuCursor], a
	ld [wDebugMenuOwlStatus], a
	ld [wDebugMenuOwlGfxPending], a
	; Start the treasure row on this level's grey treasure
	ld a, [wLevel]
	srl a ; levels are 8 apart, treasures 4 apart
	and %11111100
	cp NUM_LEVELS * 4
	jr c, .got_treasure_idx
	xor a ; the temple and the golf building have none
.got_treasure_idx
	ld [wDebugMenuTreasureIdx], a

	; Determine starting form index from current wTransformation
	ld a, [wTransformation]
	ld b, a                ; B = current transformation byte
	xor a
	ld [wDebugMenuFormIdx], a  ; default: NONE (idx 0)
	ld hl, DebugFormTable
	ld c, NUM_DEBUG_FORMS
.find_form:
	ld a, [hli]            ; load transform byte from table entry [0]
	cp b
	jr z, .form_found
	; skip remaining 5 bytes of this entry (5-char name)
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	dec c
	jr nz, .find_form
	jr .form_init_done
.form_found:
	; index = NUM_DEBUG_FORMS - C
	ld a, NUM_DEBUG_FORMS
	sub c
	ld [wDebugMenuFormIdx], a
.form_init_done:

	call ClearVirtualOAM
	call DebugMenu_LoadScreen
	call ApplyTempPals1ToBGPals

	call DebugMenu_DrawAll

	call VBlank_PauseMenu
	xor a
	ldh [rSCY], a
	ldh [rSCX], a
	ld [wSCY], a
	ld [wSCX], a

	ld a, LCDC_DEFAULT
	ldh [rLCDC], a

	ld hl, wSubState
	inc [hl]
	ret

; -----------------------------------------------------------------------
; Substate 1: update debug menu (handle input, apply changes, draw)
; -----------------------------------------------------------------------
UpdateDebugMenu:
	ld a, [wJoypadPressed]
	ld b, a                ; save joypad

	; B button → exit
	bit B_PAD_B, a
	jp nz, .exit

	; Check for any actionable input
	ld a, b
	and PAD_UP | PAD_DOWN | PAD_LEFT | PAD_RIGHT | PAD_A
	ret z                  ; nothing pressed, done

	; Determine if anything changed (used to trigger redraw)
	ld c, 0                ; C = changed flag

	; UP: move cursor up
	ld a, b
	bit B_PAD_UP, a
	jr z, .not_up
	ld a, [wDebugMenuCursor]
	and a
	jr z, .not_up          ; already at top
	dec a
	ld [wDebugMenuCursor], a
	ld c, 1
.not_up:

	; DOWN: move cursor down
	ld a, b
	bit B_PAD_DOWN, a
	jr z, .not_down
	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_ITEMS - 1
	jr z, .not_down        ; already at bottom
	inc a
	ld [wDebugMenuCursor], a
	ld c, 1
.not_down:

	; RIGHT: cycle value forward
	ld a, b
	bit B_PAD_RIGHT, a
	jr z, .not_right

	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_FORM
	jr z, .change_form_fwd
	cp DEBUG_MENU_POWER
	jr z, .change_power_fwd
	cp DEBUG_MENU_OWL
	jr z, .spawn_owl_r
	cp DEBUG_MENU_TREASURE
	jr z, .treasure_fwd
	; else DEBUG_MENU_GOLF: toggle golf win
	ld a, [wIsMinigameCleared]
	xor TRUE
	ld [wIsMinigameCleared], a
	ld a, ROOMTRANSITION_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	ld c, 1
	jr .not_right
.spawn_owl_r:
	call DebugMenu_SpawnOwl
	ld c, 1
	jr .not_right
.treasure_fwd:
	ld a, [wDebugMenuTreasureIdx]
	inc a
	cp NUM_LEVELS * 4
	jr c, .treasure_fwd_ok
	xor a
.treasure_fwd_ok:
	ld [wDebugMenuTreasureIdx], a
	ld c, 1
	jr .not_right

.change_power_fwd:
	ld a, [wPowerUpLevel]
	inc a
	cp NUM_DEBUG_POWERS
	jr c, .power_fwd_ok
	xor a
.power_fwd_ok:
	ld [wPowerUpLevel], a
	ld c, 1
	jr .not_right

.change_form_fwd:
	ld a, [wDebugMenuFormIdx]
	inc a
	cp NUM_DEBUG_FORMS
	jr c, .form_fwd_ok
	xor a
.form_fwd_ok:
	ld [wDebugMenuFormIdx], a
	call DebugMenu_ApplyForm
	ld c, 1
.not_right:

	; LEFT: cycle value backward
	; Reload joypad in case DebugMenu_ApplyForm clobbered b
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr z, .not_left

	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_FORM
	jr z, .change_form_bwd
	cp DEBUG_MENU_POWER
	jr z, .change_power_bwd
	cp DEBUG_MENU_OWL
	jr z, .spawn_owl_l
	cp DEBUG_MENU_TREASURE
	jr z, .treasure_bwd
	; else DEBUG_MENU_GOLF: toggle golf win (same as right)
	ld a, [wIsMinigameCleared]
	xor TRUE
	ld [wIsMinigameCleared], a
	ld a, ROOMTRANSITION_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	ld c, 1
	jr .check_redraw
.spawn_owl_l:
	call DebugMenu_SpawnOwl
	ld c, 1
	jr .check_redraw
.treasure_bwd:
	ld a, [wDebugMenuTreasureIdx]
	and a
	jr nz, .treasure_bwd_ok
	ld a, NUM_LEVELS * 4
.treasure_bwd_ok:
	dec a
	ld [wDebugMenuTreasureIdx], a
	ld c, 1
	jr .check_redraw

.change_power_bwd:
	ld a, [wPowerUpLevel]
	and a
	jr z, .power_bwd_wrap
	dec a
	jr .power_bwd_ok
.power_bwd_wrap:
	ld a, NUM_DEBUG_POWERS - 1
.power_bwd_ok:
	ld [wPowerUpLevel], a
	ld c, 1
	jr .check_redraw

.change_form_bwd:
	ld a, [wDebugMenuFormIdx]
	and a
	jr z, .form_bwd_wrap
	dec a
	jr .form_bwd_ok
.form_bwd_wrap:
	ld a, NUM_DEBUG_FORMS - 1
.form_bwd_ok:
	ld [wDebugMenuFormIdx], a
	call DebugMenu_ApplyForm
	ld c, 1
	jr .check_redraw

.not_left:
	; A: give or take the selected treasure
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .check_redraw
	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_TREASURE
	jr nz, .check_redraw
	call DebugMenu_ToggleTreasure
	ld c, 1

.check_redraw:
	ld a, c
	and a
	ret z                  ; nothing changed

	; Redraw during V-Blank (LCD stays on, no flash), half the rows in each
	; of two V-Blanks
	di
	call DebugMenu_WaitVBlank
	call DebugMenu_DrawItems1
.wait_vblank_end:
	ldh a, [rLY]
	cp LY_VBLANK
	jr nc, .wait_vblank_end
	call DebugMenu_WaitVBlank
	call DebugMenu_DrawItems2
	ei
	ret

.exit:
	jp DebugMenu_Exit

DebugMenu_WaitVBlank:
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, DebugMenu_WaitVBlank
	ret

; -----------------------------------------------------------------------
; Exit: restore level state
; -----------------------------------------------------------------------
DebugMenu_Exit:
	call DisableLCD
	call ClearVirtualOAM
	farcall DrawLevelObjectsAfterLevelReturn
	call LoadBackupVRAM
	ld a, [wDebugMenuOwlGfxPending]
	and a
	jr z, .owl_gfx_done
	farcall LoadOwlGfx
.owl_gfx_done
	xor a
	ld [wDebugMenuOwlGfxPending], a

	; wTempPals2 is now back to the pre-menu snapshot. Re-apply the current
	; Wario palette from wWarioPalsPtr, in case FORM changed it.
	; hcall handles the ROM bank switch safely from ROMX: it saves/restores the
	; Debug Menu bank internally and reads [hl] with Wario Palettes bank active.
	ld a, [wWarioPalsPtr + 0]
	ld h, a
	ld a, [wWarioPalsPtr + 1]
	ld l, a
	ld de, wTempPals2
	ld b, 2 palettes
	ld a, BANK("Wario Palettes")
	ldh [hCallFuncBank], a
	hcall CopyHLToDE_Short

	xor a
	ld [wUnused_IsPaused], a
	; Restore animated tile state (GFX RAM still active from wrapper)
	ld a, [wTempAnimatedTilesFrameDuration]
	ld [wAnimatedTilesFrameDuration], a
	ld a, [wTempAnimatedTilesGroup]
	ld [wAnimatedTilesGfx], a
	xor a
	ld [wAnimatedTilesFrameCount], a
	ld [wAnimatedTilesFrame], a
	ld a, TRUE
	ld [wRoomAnimatedTilesEnabled], a

	call ApplyTempPals1ToBGPals
	call ApplyTempPals2ToOBPals
	call UpdateLevelMusic
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a

	; If a room reload is pending (e.g. golf win toggled), skip directly to
	; FastFadeToWhite (substate 5) so StartRoom_FromTransition fires immediately.
	; UpdateState_Idling doesn't check wRoomTransitionParam, so returning to
	; UpdateLevel (substate 3) would leave the transition param unprocessed.
	ld a, [wRoomTransitionParam]
	and a
	jr z, .no_pending_reload
	ld a, ST_LEVEL
	ld [wState], a
	ld a, 5    ; FastFadeToWhite → StartRoom_FromTransition
	ld [wSubState], a
	ret
.no_pending_reload:
	jp ReturnToPendingLevelState
