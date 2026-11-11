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

; The menu has three pages, cycled with START: MAIN, POWER and TREASURE.
; Each is a substate (SST_DEBUG_MENU_MAIN, SST_DEBUG_POWER_PAGE,
; SST_DEBUG_TREASURE_PAGE) with its own map; see tools/debug_menu_bgmap.py.

; MAIN's rows, in wDebugMenuCursor order
	const_def
	const DEBUG_MENU_FORM
	const DEBUG_MENU_GOLF
	const DEBUG_MENU_OWL
	const DEBUG_MENU_BARREL
DEF DEBUG_MENU_ITEMS EQU const_value

; where the cursor and the values go (the rest of the screen, labels
; included, is in debug_menu.tilemap: see tools/debug_menu_bgmap.py)
DEF DEBUG_MENU_CURSOR_X EQU 2
DEF DEBUG_MENU_VALUE_X  EQU 11
DEF DEBUG_MENU_FORM_Y   EQU 7
DEF DEBUG_MENU_GOLF_Y   EQU 9
DEF DEBUG_MENU_OWL_Y    EQU 11
DEF DEBUG_MENU_BARREL_Y EQU 13
; the selected FORM row shows ◀ value ▶
DEF DEBUG_MENU_LEFT_ARROW_X  EQU DEBUG_MENU_VALUE_X - 1
DEF DEBUG_MENU_FORM_RIGHT_ARROW_X EQU DEBUG_MENU_VALUE_X + 5 ; after the widest name
; font tiles the arrows are loaded into (blank in the font)
DEF DEBUG_MENU_LEFT_ARROW  EQU $5e
DEF DEBUG_MENU_RIGHT_ARROW EQU $5f
DEF DEBUG_MENU_BLANK EQU $7f ; all colour 3, like the maps' empty cells
; inside the frame, the width of the TREASURE page's level name
DEF DEBUG_MENU_INSIDE_X     EQU 2
DEF DEBUG_MENU_INSIDE_WIDTH EQU 16

; The page indicator under the title, MAIN POWER TREASURE in a small font,
; is DEBUG_MENU_PAGES_TILES font tiles from DEBUG_MENU_PAGES_TILE (over the
; font's "c", "d"..., unused by the menu), in all three maps. Each page
; loads its own version of them, the page's name in yellow
; (gfx/debug_menu_pages.png, one row of tiles per page).
DEF DEBUG_MENU_PAGES_TILE  EQU $62
DEF DEBUG_MENU_PAGES_TILES EQU 12

; The POWER page: the ten power-up levels in two columns of five, each an
; icon cell (2x2 tiles) with the power-up's treasure in it, as two sprites,
; and its name on two lines to its right.
; Shared with tools/debug_menu_bgmap.py, which draws the names and cells.
DEF DEBUG_POWER_TOP_Y     EQU 5
DEF DEBUG_POWER_ICON_X    EQU 2
DEF DEBUG_POWER_COL_WIDTH EQU 8
DEF DEBUG_POWER_ROWS      EQU 5
DEF DEBUG_POWER_NAME_WIDTH EQU 6
; the icon cells' tiles (POWER and TREASURE), over the font's "a" and "b"
; (unused by the menu); the map flips them for the four corners
DEF DEBUG_POWER_CELL          EQU $60
DEF DEBUG_POWER_CELL_SELECTED EQU $61
DEF DEBUG_POWER_PAL_DIM EQU 0 ; OB palette for treasures not owned

; The TREASURE page: a level's code between ◀ ▶, its name centred on the
; two rows below, a blank row, and its four treasures in a column, each an icon cell
; and two lines, its colour and OPEN or CLOSED. Shared with
; tools/debug_menu_bgmap.py.
DEF DEBUG_TREASURE_CODE_X EQU 9
DEF DEBUG_TREASURE_CODE_Y EQU 4
DEF DEBUG_TREASURE_NAME_Y EQU 5
DEF DEBUG_TREASURE_ICON_X EQU 6
DEF DEBUG_TREASURE_TOP_Y  EQU 8
; The treasures' sprite tiles, after the POWER page's (VRAM0 $8000-$827f):
; two sets of four treasures, $8280-$837f and $8380-$847f. A new level's
; treasures go into the set not shown, a treasure per V-Blank, and then the
; sprites switch to it.
DEF DEBUG_TREASURE_OBJ_TILE EQU NUM_DEBUG_POWERS * NUM_TREASURE_TILES
DEF DEBUG_TREASURE_OBJ_SET  EQU NUM_LEVEL_TREASURES * NUM_TREASURE_TILES

; Strings for menu values (temple charmap)
; level codes, 2 bytes per level, in level order
DebugLevelCodes:
	db "N1N2N3N4N5N6"
	db "W1W2W3W4W5W6"
	db "S1S2S3S4S5S6"
	db "E1E2E3E4E5E6E7"
DebugMenuStrOn:     db "ON "              ; 3 bytes
DebugMenuStrOff:    db "OFF"              ; 3 bytes
DebugMenuStrOk:     db "OK "              ; 3 bytes
DebugMenuStrNo:     db "NO "              ; 3 bytes
DebugMenuStrOpen:   db "OPEN  "           ; 6 bytes, chests
DebugMenuStrClosed: db "CLOSED"           ; 6 bytes

SETCHARMAP main

_DebugMenuStateTable::
	ld a, [wSubState]
	jumptable
	dw InitDebugMenu
	dw UpdateDebugMenu        ; SST_DEBUG_MENU_MAIN
	dw UpdateDebugPowerPage   ; SST_DEBUG_POWER_PAGE
	dw UpdateDebugTreasurePage ; SST_DEBUG_TREASURE_PAGE

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
	; SetState_OnFire_ResetStateCounter loads WarioHotGfx, WarioOnFireOAM_1673c,
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
	; Flat wario uses slide GFX + WarioFlatOAM_16e9d (SetState_FlatIdling doesn't load GFX)
	ld a, BANK(WarioSlideGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSlideGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSlideGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioFlatOAM_16e9d)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioFlatOAM_16e9d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioFlatOAM_16e9d)
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
	ld a, BANK(WarioBallOStringOAM_171c0)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioBallOStringOAM_171c0)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioBallOStringOAM_171c0)
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
	ld a, BANK(WarioOAM_1742d)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_1742d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1742d)
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
	ld a, BANK(WarioElectricOAM_1790e)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioElectricOAM_1790e)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioElectricOAM_1790e)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .elec_right
	ld a, HIGH(WarioElectricFrameset_17b79)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricFrameset_17b79)
	ld [wWarioFramesetPtr + 1], a
	jr .elec_anim
.elec_right:
	ld a, HIGH(WarioElectricFrameset_17b76)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricFrameset_17b76)
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
; OWL and BARREL: spawn an owl or a barrel next to Wario (from the room's
; object group if it has one, otherwise from ROM, see
; _DebugSpawnObjectOfKind), and record the outcome in the row's status
; (1 = spawned, 2 = not: no free object slot, a boss battle, or the other
; one's graphics are in use).
; input:
; - e = DEBUG_GFX_* kind
; - hl = wDebugMenuOwlStatus or wDebugMenuBarrelStatus
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_SpawnObject:
	push hl
	call .Spawn
	pop hl
	ld [hl], a
	ret

; output: a = status
.Spawn:
	; Bosses keep their own graphics in the enemy slots, the owl's included
	; (it would overwrite part of the boss): no owl or barrel in a boss
	; battle.
	ld a, [wIsBossBattle]
	and a
	ld a, 2
	ret nz
	push de
	push_wram BANK("Level Objects WRAM")
	farcall _DebugSpawnObjectOfKind
	pop_wram
	pop de
	ld a, b
	and a
	ld a, 2
	ret z
	ld a, c
	and a
	jr z, .spawned
	; wDebugMenuGfxPending |= 1 << kind
	inc e
	xor a
	scf
.kind_bit
	rla
	dec e
	jr nz, .kind_bit
	ld hl, wDebugMenuGfxPending
	or [hl]
	ld [hl], a
.spawned
	ld a, 1
	ret

; -----------------------------------------------------------------------
; GOLF: toggle the current area's golf win. It only decides whether the
; clear gates are open, so the gates already in the room are moved to
; match (see _DebugMoveClearGates) instead of reloading the room.
; -----------------------------------------------------------------------
DebugMenu_ToggleGolf:
	ld a, [wIsMinigameCleared]
	xor TRUE
	ld [wIsMinigameCleared], a
	push_wram BANK("Level Objects WRAM")
	farcall _DebugMoveClearGates
	pop_wram
	ret

; -----------------------------------------------------------------------
; Draw the cursor and the values of MAIN (LCD must be off or in VBlank);
; the rest is in debug_menu.tilemap
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
; Write ◀ to hl and ▶ b cells to its right if item c is selected, spaces
; otherwise: LEFT/RIGHT change that row's value.
; Clobbers: A, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawArrows:
	ld a, [wDebugMenuCursor]
	cp c
	ld de, DEBUG_MENU_LEFT_ARROW | DEBUG_MENU_RIGHT_ARROW << 8
	jr z, .got_chars
	ld de, $7e7e ; spaces
.got_chars
	ld [hl], e
	ld a, l
	add b
	ld l, a
	ld [hl], d
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
	ld c, DEBUG_MENU_FORM
	ld b, DEBUG_MENU_FORM_RIGHT_ARROW_X - DEBUG_MENU_LEFT_ARROW_X
	hlbgcoord DEBUG_MENU_LEFT_ARROW_X, DEBUG_MENU_FORM_Y
	call DebugMenu_DrawArrows

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
	; OWL and BARREL: A spawns one, the value shows whether the last try
	; worked
	ld c, DEBUG_MENU_OWL
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_OWL_Y
	call DebugMenu_DrawCursor
	ld a, [wDebugMenuOwlStatus]
	hlbgcoord DEBUG_MENU_VALUE_X, DEBUG_MENU_OWL_Y
	call DebugMenu_DrawSpawnStatus
	ld c, DEBUG_MENU_BARREL
	hlbgcoord DEBUG_MENU_CURSOR_X, DEBUG_MENU_BARREL_Y
	call DebugMenu_DrawCursor
	ld a, [wDebugMenuBarrelStatus]
	hlbgcoord DEBUG_MENU_VALUE_X, DEBUG_MENU_BARREL_Y
;	fallthrough

; Write a spawn status (OWL, BARREL) to hl: nothing for 0 (no try yet), OK
; for 1, NO for 2.
; Clobbers: A, B, D, E, H, L
DebugMenu_DrawSpawnStatus:
	and a
	ret z
	dec a
	ld de, DebugMenuStrOk
	jr z, .draw
	ld de, DebugMenuStrNo
.draw
	ld b, 3
	jp DebugMenu_DrawString

; -----------------------------------------------------------------------
; Load the tiles all the pages use, once: the font in VRAM0 with the arrows,
; the icon cells and the POWER page's treasures, and the pause menu's
; graphics in VRAM1 (for the frame). The LCD must be off.
; -----------------------------------------------------------------------
DebugMenu_LoadTiles:
	farcall LoadFontTiles
	ld hl, DebugMenuArrowTiles
	ld de, v0Tiles2 tile DEBUG_MENU_LEFT_ARROW
	ld b, 2 tiles
	call CopyHLToDE_Short
	ld hl, DebugPowerCellTiles
	ld de, v0Tiles2 tile DEBUG_POWER_CELL
	ld b, 2 tiles
	call CopyHLToDE
	call DebugMenu_LoadPowerTiles
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld hl, PauseMenuGfx
	ld bc, v1Tiles0
	ld a, BANK(PauseMenuGfx)
	ldh [hCallFuncBank], a
	hcall Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	ret

; -----------------------------------------------------------------------
; START: the next page (MAIN after TREASURE)
; -----------------------------------------------------------------------
DebugMenu_NextPage:
	ld a, [wSubState]
	inc a
	cp SST_DEBUG_TREASURE_PAGE + 1
	jr c, DebugMenu_ShowPage
	ld a, SST_DEBUG_MENU_MAIN
;	fallthrough

; -----------------------------------------------------------------------
; Switch to page a (SST_DEBUG_MENU_MAIN, SST_DEBUG_POWER_PAGE or
; SST_DEBUG_TREASURE_PAGE): its map, values and sprites, and the page
; indicator's version for it. The LCD is off meanwhile.
; -----------------------------------------------------------------------
DebugMenu_ShowPage:
	ld [wSubState], a
	call DisableLCD
	call ClearVirtualOAM

	; the page indicator: this page's row of DebugMenuPagesGfx
	ld a, [wSubState]
	sub SST_DEBUG_MENU_MAIN
	ld hl, DebugMenuPagesGfx
	ld de, DEBUG_MENU_PAGES_TILES tiles
	jr z, .got_pages_gfx
.next_pages_gfx
	add hl, de
	dec a
	jr nz, .next_pages_gfx
.got_pages_gfx
	ld de, v0Tiles2 tile DEBUG_MENU_PAGES_TILE
	ld b, DEBUG_MENU_PAGES_TILES tiles
	call CopyHLToDE

	call .Load
	call ApplyTempPals1ToBGPals
	ld a, HIGH(wVirtualOAM)
	call hTransferVirtualOAM
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	ret

.Load:
	ld a, [wSubState]
	sub SST_DEBUG_MENU_MAIN
	jumptable
	dw DebugMenu_LoadMainPage
	dw DebugMenu_LoadPowerPage
	dw DebugMenu_LoadTreasurePage

DebugMenu_LoadMainPage:
	ld hl, DebugMenuTilemap
	ld de, DebugMenuAttrmap
	call DebugMenu_LoadMap
	jp DebugMenu_DrawAll

; Load a page's map (tilemap hl, attrmap de) and the menu's BG palettes
; into wTempPals1. The LCD must be off.
DebugMenu_LoadMap:
	ld bc, v0BGMap0
	push de
	call Decompress
	pop hl
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld bc, v1BGMap0
	call Decompress
	xor a ; VRAM0
	ldh [rVBK], a
	ld hl, DebugMenuPals
	ld de, wTempPals1
	ld b, 8 palettes
	jp CopyHLToDE_Short

; -----------------------------------------------------------------------
; Wait for the start of the next V-Blank with interrupts off, to write
; VRAM with the LCD on; the caller turns interrupts back on (ei) when done.
; Returns right away (interrupts off too) if the LCD is off.
; Clobbers: A
; -----------------------------------------------------------------------
DebugMenu_StartVRAMWrite:
	di
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	ret z
.wait_not_vblank
	ldh a, [rLY]
	cp LY_VBLANK
	jr nc, .wait_not_vblank
.wait_vblank
	ldh a, [rLY]
	cp LY_VBLANK
	jr c, .wait_vblank
	ret

; ◀ and ▶, in the font's style (glyph in colour 0 on colour 3), like its ▼
DebugMenuArrowTiles:
	dw `33333333
	dw `33330333
	dw `33300333
	dw `33000333
	dw `30000333
	dw `33000333
	dw `33300333
	dw `33330333

	dw `33333333
	dw `30333333
	dw `30033333
	dw `30003333
	dw `30000333
	dw `30003333
	dw `30033333
	dw `30333333

DebugMenuTilemap: INCBIN "data/bgmaps/debug_menu.tilemap.rle"
DebugMenuAttrmap: INCBIN "data/bgmaps/debug_menu.attrmap.rle"

; The page indicator, one row of DEBUG_MENU_PAGES_TILES tiles per page
; (tools/debug_menu_bgmap.py draws it): the page's name in colour 0 (the
; title's yellow), the others in colour 1 (dim), on colour 3
DebugMenuPagesGfx: INCBIN "gfx/debug_menu_pages.2bpp"
.end
	ASSERT DebugMenuPagesGfx.end - DebugMenuPagesGfx == 3 * DEBUG_MENU_PAGES_TILES tiles

; The font draws its glyphs in colour 0 on colour 3: the text palettes are a
; text colour on the colour of what's behind it.
DebugMenuPals:
	; 0: title, yellow on the title band's dark blue; colour 1 is the page
	; indicator's other pages
	rgb 31, 31,  0
	rgb 15, 14, 27
	rgb 10, 10, 10
	rgb  7,  2, 23
	; 1-4: the pause menu's (PauseMenuBGPals), for its gems, the checkered
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
	; 7: the POWER and TREASURE pages' icon cells: white (behind the
	; treasure sprites, whose colour 0 is the treasure palettes' white), the
	; selected one's yellow frame, and the margin in the frame's dark red
	rgb 31, 31, 31
	rgb 31, 27,  0
	rgb 26, 11,  1
	rgb 11,  0,  1

; -----------------------------------------------------------------------
; Substate 0: initialise debug menu display
; -----------------------------------------------------------------------
InitDebugMenu:
	ldh a, [rLCDC]
	ld [wDebugMenuLevelLCDC], a
	call DisableLCD
	call SaveBackupVRAM

	; Save animated tile state (GFX RAM already active from wrapper)
	ld a, [wAnimatedTilesFrameDuration]
	ld [wTempAnimatedTilesFrameDuration], a
	ld a, [wAnimatedTilesGfx]
	ld [wTempAnimatedTilesGroup], a

	; Each page's selection, kept while the menu is open: MAIN's cursor on
	; FORM, POWER's on the current power-up level, TREASURE's on this
	; level's grey treasure
	xor a
	ld [wDebugMenuCursor], a
	ld [wDebugMenuOwlStatus], a
	ld [wDebugMenuBarrelStatus], a
	ld [wDebugMenuGfxPending], a
	call DebugMenu_GetPowerLevel
	cp NUM_DEBUG_POWERS
	jr c, .got_power_cursor
	xor a
.got_power_cursor
	ld [wDebugPowerCursor], a
	ld a, [wLevel]
	srl a ; levels are 8 apart, treasures 4 apart
	and %11111100
	cp NUM_LEVELS * NUM_LEVEL_TREASURES
	jr c, .got_treasure_idx
	xor a ; the temple and the golf building have none
.got_treasure_idx
	ld [wDebugMenuTreasureIdx], a
	ld a, DEBUG_TREASURE_OBJ_TILE
	ld [wDebugTreasureObjTile], a

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

	call DebugMenu_LoadTiles
	call VBlank_PauseMenu
	xor a
	ldh [rSCY], a
	ldh [rSCX], a
	ld [wSCY], a
	ld [wSCX], a

	; MAIN, and the LCD on
	ld a, SST_DEBUG_MENU_MAIN
	call DebugMenu_ShowPage

	; the pause menu's music (DebugMenu_Exit gives the level's back)
	play_music MUSIC_PAUSE_MENU
	ret

; -----------------------------------------------------------------------
; SST_DEBUG_MENU_MAIN: MAIN's input
; -----------------------------------------------------------------------
UpdateDebugMenu:
	ld a, [wJoypadPressed]
	ld b, a                ; save joypad

	; B or SELECT: exit; START: the next page
	and PAD_B | PAD_SELECT
	jp nz, DebugMenu_Exit
	bit B_PAD_START, b
	jp nz, DebugMenu_NextPage

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

	; RIGHT: next form (only FORM takes LEFT/RIGHT)
	ld a, b
	bit B_PAD_RIGHT, a
	jr z, .not_right
	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_FORM
	jr nz, .not_right
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

	; LEFT: previous form
	; Reload joypad in case DebugMenu_ApplyForm clobbered b
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr z, .not_left
	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_FORM
	jr nz, .not_left
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
	; A: spawn an owl or a barrel, or toggle the golf win
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .check_redraw
	ld a, [wDebugMenuCursor]
	cp DEBUG_MENU_OWL
	jr z, .spawn_owl
	cp DEBUG_MENU_BARREL
	jr z, .spawn_barrel
	cp DEBUG_MENU_GOLF
	jr nz, .check_redraw
	call DebugMenu_ToggleGolf
	ld c, 1
	jr .check_redraw
.spawn_owl
	ld e, DEBUG_GFX_OWL
	ld hl, wDebugMenuOwlStatus
	jr .spawn
.spawn_barrel
	ld e, DEBUG_GFX_BARREL
	ld hl, wDebugMenuBarrelStatus
.spawn
	call DebugMenu_SpawnObject
	ld c, 1

.check_redraw:
	ld a, c
	and a
	ret z                  ; nothing changed

	; Redraw during V-Blank (LCD stays on, no flash), half the rows in each
	; of two V-Blanks
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawItems1
	ei
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawItems2
	ei
	ret

; Load the graphics of the owls and barrels spawned in rooms without them
; (wDebugMenuGfxPending), with the LCD off and after VRAM is restored.
; wDebugGfxSlot has the last kind spawned. An owl spawned before a barrel in
; the same visit went into slot 1, its own, which wDebugGfxSlot then no
; longer says (only one kind can be elsewhere, see _DebugSpawnObjectOfKind).
DebugMenu_LoadGfx:
	ASSERT DEBUG_GFX_OWL == 0
	bit DEBUG_GFX_OWL, a
	jr z, .load
	ld a, [wDebugGfxSlot]
	and DEBUG_GFX_KIND_MASK
	jr z, .load ; the owl's
	ld a, [wDebugGfxSlot]
	push af
	xor a ; the owl, in slot 1
	ld [wDebugGfxSlot], a
	farcall LoadDebugObjGfx
	pop af
	ld [wDebugGfxSlot], a
.load
	farcall LoadDebugObjGfx
	ret

; -----------------------------------------------------------------------
; Exit: restore level state
; -----------------------------------------------------------------------
DebugMenu_Exit:
	call DisableLCD
	call ClearVirtualOAM
	farcall DrawLevelObjectsAfterLevelReturn
	call LoadBackupVRAM
	ld a, [wDebugMenuGfxPending]
	and a
	jr z, .gfx_done
	call DebugMenu_LoadGfx
.gfx_done
	xor a
	ld [wDebugMenuGfxPending], a

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
	ld a, [wDebugMenuLevelLCDC]
	ldh [rLCDC], a

	jp ReturnToPendingLevelState
