SETCHARMAP temple

; FORM's list, in LEFT/RIGHT order: 7 bytes per entry
;   [0]     transformation byte (wTransformation)
;   [1]     flags: DEBUG_FORM_HIDDEN to leave it out of LEFT/RIGHT
;   [2-6]   5-char display name
; A hidden form keeps its entry and its code in DebugMenu_ApplyForm: the
; menu still shows it when Wario has it as the menu opens, and LEFT/RIGHT
; skip it. (A later option could show or hide some of them.)
DEF DEBUG_FORM_HIDDEN EQU 1 << 0
DEF DEBUG_FORM_ENTRY_SIZE EQU 7
DEF DEBUG_FORM_NAME EQU 2 ; the name's offset in an entry

MACRO debug_form ; transformation, name[, DEBUG_FORM_HIDDEN]
	ASSERT CHARLEN(\2) == 5, \2
	db \1
	IF _NARG > 2
		db \3
	ELSE
		db 0
	ENDC
	db \2
ENDM

DebugFormTable:
	table_width DEBUG_FORM_ENTRY_SIZE
	debug_form TRANSFORMATION_NONE,                "NONE "
	debug_form TRANSFORMATION_HOT_WARIO,           "HOT  "
	debug_form TRANSFORMATION_FLAT_WARIO,          "FLAT "
	debug_form TRANSFORMATION_BALL_O_STRING_WARIO, "STRNG"
	debug_form TRANSFORMATION_FAT_WARIO,           "FAT  "
	debug_form TRANSFORMATION_ELECTRIC,            "ELEC ", DEBUG_FORM_HIDDEN ; zapped Wario
	debug_form TRANSFORMATION_PUFFY_WARIO,         "PUFFY"
	debug_form TRANSFORMATION_ZOMBIE_WARIO,        "ZOMBI"
	debug_form TRANSFORMATION_BOUNCY_WARIO,        "BUNCY"
	debug_form TRANSFORMATION_CRAZY_WARIO,         "CRAZY", DEBUG_FORM_HIDDEN ; dizzy Wario
	debug_form TRANSFORMATION_VAMPIRE_WARIO,       "VAMPI"
	debug_form TRANSFORMATION_SNOWMAN_WARIO,       "SNWMN"
	debug_form TRANSFORMATION_INVISIBLE_WARIO,     "INVIS"
	; Rolling isn't a transformation: wTransformation stays NONE and
	; wIsRolling says he rolls (see .form_roll)
	debug_form TRANSFORMATION_NONE,                "ROLL "
DEF NUM_DEBUG_FORMS EQU 14
	assert_table_length NUM_DEBUG_FORMS
DEF DEBUG_FORM_NONE EQU 0
DEF DEBUG_FORM_ROLL EQU NUM_DEBUG_FORMS - 1
DEF NUM_DEBUG_POWERS EQU 10

; The menu has three pages, cycled with SELECT: LEVEL, POWER and TREASURE.
; Each is a substate (SST_DEBUG_LEVEL_PAGE, SST_DEBUG_POWER_PAGE,
; SST_DEBUG_TREASURE_PAGE) with its own map; see tools/debug_menu_bgmap.py.

; LEVEL's rows, in wDebugMenuCursor order
	const_def
	const DEBUG_MENU_FORM
	const DEBUG_MENU_GOLF
	const DEBUG_MENU_OWL
	const DEBUG_MENU_BARREL
DEF DEBUG_MENU_ITEMS EQU const_value

; where the cursor and the values go (the rest of the screen, labels
; included, is in debug_level.tilemap: see tools/debug_menu_bgmap.py)
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

; The page indicator under the title, LEVEL POWER TREASURE in a small font,
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
; The page's frame has a plain top edge, and the code is drawn a few pixels
; higher than the font's rows, half on that edge's row: font tiles from
; DEBUG_TREASURE_CODE_TILE on (over the font's "o", "p"..., unused by the
; menu) hold the edge, its corner and ◀ ▶ (DEBUG_TREASURE_CODE_FIXED tiles,
; loaded once), then the picked level's letter and digit, a top and a
; bottom tile each, which the map always shows: debug_menu.asm only loads
; their tiles (DebugMenuCodeGfx).
DEF DEBUG_TREASURE_CODE_TILE  EQU $6e
DEF DEBUG_TREASURE_CODE_FIXED EQU 6
DEF DEBUG_TREASURE_CODE_TILES EQU DEBUG_TREASURE_CODE_TILE + DEBUG_TREASURE_CODE_FIXED
; in DebugMenuCodeGfx, after the fixed tiles: N, W, S and E, then 1 to 7
DEF DEBUG_CODE_GFX_LETTERS EQU DEBUG_TREASURE_CODE_FIXED
DEF DEBUG_CODE_GFX_DIGITS  EQU DEBUG_CODE_GFX_LETTERS + 4 * 2
DEF DEBUG_TREASURE_NAME_Y EQU 5
DEF DEBUG_TREASURE_ICON_X EQU 6
DEF DEBUG_TREASURE_TOP_Y  EQU 8
; The treasures' sprite tiles, after the POWER page's (VRAM0 $8000-$827f):
; two sets of four treasures, $8280-$837f and $8380-$847f. A new level's
; treasures go into the set not shown, a treasure per V-Blank, and then the
; sprites switch to it.
DEF DEBUG_TREASURE_OBJ_TILE EQU NUM_DEBUG_POWERS * NUM_TREASURE_TILES
DEF DEBUG_TREASURE_OBJ_SET  EQU NUM_LEVEL_TREASURES * NUM_TREASURE_TILES

; A level's code, as its letter's and its digit's tiles in DebugMenuCodeGfx
MACRO debug_level_code
	ASSERT STRFIND("NWSE", "\1") != -1
	db DEBUG_CODE_GFX_LETTERS + 2 * STRFIND("NWSE", "\1")
	db DEBUG_CODE_GFX_DIGITS + 2 * (\2 - 1)
ENDM

; in level order
DebugLevelCodes:
	FOR N, 1, 7
		debug_level_code N, N
	ENDR
	FOR N, 1, 7
		debug_level_code W, N
	ENDR
	FOR N, 1, 7
		debug_level_code S, N
	ENDR
	FOR N, 1, 8
		debug_level_code E, N
	ENDR
	ASSERT @ - DebugLevelCodes == NUM_LEVELS * 2

; Strings for menu values (temple charmap)
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
	dw UpdateDebugLevelPage    ; SST_DEBUG_LEVEL_PAGE
	dw UpdateDebugPowerPage    ; SST_DEBUG_POWER_PAGE
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
	; out of a roll (ROLL, or a roll of the game's): the forms below don't
	; all reset it, and a walking Wario with wIsRolling set still breaks
	; blocks like a rolling one
	xor a
	ld [wIsRolling], a
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
	dw .form_roll
	ASSERT DEBUG_FORM_ROLL == NUM_DEBUG_FORMS - 1

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

; ROLL: not a transformation but the game's roll (WST_ROLLING, what a
; slide down a slope turns into): wTransformation is NONE and wIsRolling
; is set. He rolls on until he hits a wall, A hops, and SELECT in the
; level stops it like a form (UpdateLevel). In the air, the airborne roll,
; which lands into the roll.
.form_roll:
	call ClearTransformationValues
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	xor a
	ld [wGrabState], a
	ld [wIsCrouching], a
	ld [wIsSmashAttacking], a
	ld [wAttackCounter], a
	ld [wWalkVelIndex], a
	ld a, [wJumpVelTable]
	and a
	jr nz, .form_roll_airborne
	; SetState_Rolling doesn't load the graphics: the slide's, which come
	; before it in the game (SetState_Sliding)
	ld a, BANK(WarioSlideGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSlideGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSlideGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_1644a)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_1644a)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1644a)
	ld [wWarioOAMPtr + 1], a
	farcall SetState_Rolling
	ret
.form_roll_airborne:
	; loads them itself
	farcall SetState_RollingAirborne_Fall
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
; input: a = a FORM index; output: hl = its DebugFormTable entry
; Clobbers: B, C
; -----------------------------------------------------------------------
DebugMenu_GetFormEntry:
	ld c, a
	ld b, 0
	ld h, b
	ld l, c
	add hl, hl
	add hl, bc ; 3 * idx
	add hl, hl
	add hl, bc ; 7 * idx
	ASSERT DEBUG_FORM_ENTRY_SIZE == 7
	ld bc, DebugFormTable
	add hl, bc
	ret

; -----------------------------------------------------------------------
; The next (b = 1) or previous (b = -1) FORM in the list from
; wDebugMenuFormIdx, wrapping and skipping the hidden ones, into
; wDebugMenuFormIdx. NONE is never hidden, so there's always one.
; Clobbers: A, B, C, H, L
; -----------------------------------------------------------------------
DebugMenu_StepForm:
	ld a, [wDebugMenuFormIdx]
.next
	add b
	cp NUM_DEBUG_FORMS
	jr c, .got_idx
	; past either end: 0 if it went up, the last one if it went down
	bit 7, b
	ld a, 0
	jr z, .got_idx
	ld a, NUM_DEBUG_FORMS - 1
.got_idx
	ld [wDebugMenuFormIdx], a
	push bc
	call DebugMenu_GetFormEntry
	pop bc
	inc hl
	ASSERT DEBUG_FORM_NAME == 2 ; the flags at 1
	ld a, [hl]
	and DEBUG_FORM_HIDDEN
	ld a, [wDebugMenuFormIdx]
	jr nz, .next
	ret

; -----------------------------------------------------------------------
; Draw the cursor and the values of LEVEL, the rest being in
; debug_level.tilemap. With the LCD on, in two V-Blanks.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_DrawAll:
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawItems1
	call DebugMenu_EndVRAMWrite
	call DebugMenu_StartVRAMWrite
	call DebugMenu_DrawItems2
	jp DebugMenu_EndVRAMWrite

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
	; de = the form's name
	ld a, [wDebugMenuFormIdx]
	call DebugMenu_GetFormEntry
	ld de, DEBUG_FORM_NAME
	add hl, de
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
	ld hl, DebugMenuCodeGfx
	ld de, v0Tiles2 tile DEBUG_TREASURE_CODE_TILE
	ld b, DEBUG_TREASURE_CODE_FIXED tiles
	call CopyHLToDE ; crosses $9700
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
; Pages are switched with the LCD on: turning it off shows a white frame
; on a Game Boy Color. BG map 1 ($9c00) is the window's, which covers the
; whole screen while the next page is drawn in BG map 0 under it:
;
; 1. The page on screen is copied to BG map 1, the part of it that differs
;    from page to page (DEBUG_MENU_SWAP_TOP to DEBUG_MENU_SWAP_BOTTOM, the
;    frame's top edge included: the TREASURE page's is plain; the rest, the
;    title band and the frame's sides and bottom, is the same on every page
;    and was put there when the menu opened), in two V-Blanks, one per VRAM
;    bank.
;    At the end of the second one the window goes on, showing the same
;    picture.
; 2. The next page is drawn in BG map 0, under the window: its map (GDMA,
;    one V-Blank), its values, OB palettes and sprite tiles, each in a
;    V-Blank of its own (DebugMenu_LoadPage).
; 3. In one V-Blank, the page indicator's tiles (GDMA), the sprites (OAM
;    DMA) and the window off: the next page shows all at once.
;
; Every write to VRAM, OAM or the palettes is between
; DebugMenu_StartVRAMWrite (the start of a V-Blank) and
; DebugMenu_EndVRAMWrite, and fits in that V-Blank: see
; book/src/debug-menu.md, "Switching pages".
; -----------------------------------------------------------------------

; the rows the pages don't share
DEF DEBUG_MENU_SWAP_TOP    EQU 3
DEF DEBUG_MENU_SWAP_BOTTOM EQU 16

; -----------------------------------------------------------------------
; SELECT: the next page (LEVEL after TREASURE)
; -----------------------------------------------------------------------
DebugMenu_NextPage:
	ld a, [wSubState]
	inc a
	cp SST_DEBUG_TREASURE_PAGE + 1
	jr c, .got_page
	ld a, SST_DEBUG_LEVEL_PAGE
.got_page
	ld [wSubState], a

	; 1. the page on screen, in the window
	call DebugMenu_StartVRAMWrite
	xor a ; VRAM0
	call DebugMenu_CopyToWindowMap
	call DebugMenu_EndVRAMWrite
	call DebugMenu_StartVRAMWrite
	ld a, BANK("VRAM1")
	call DebugMenu_CopyToWindowMap
	xor a
	ldh [rWY], a
	ld a, WX_OFS
	ldh [rWX], a
	ld a, LCDC_DEFAULT | LCDC_WIN_ON | LCDC_WIN_9C00
	ldh [rLCDC], a
	call DebugMenu_EndVRAMWrite

	; 2. the next page under it
	call DebugMenu_LoadPage

	; 3. and on screen
	call DebugMenu_StartVRAMWrite
	call DebugMenu_LoadPagesGfx
	ld a, HIGH(wVirtualOAM)
	call hTransferVirtualOAM
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	jp DebugMenu_EndVRAMWrite

; -----------------------------------------------------------------------
; Copy BG map 0's rows DEBUG_MENU_SWAP_TOP to DEBUG_MENU_SWAP_BOTTOM, the
; screen's columns, to BG map 1, in VRAM bank a. In a V-Blank: 14 rows of
; 20 bytes, each byte 5 M-cycles (10 dots in double speed), about 3100
; dots of the V-Blank's 4560.
; Clobbers: A, B, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_CopyToWindowMap:
	ldh [rVBK], a
	ld hl, v0BGMap0 + DEBUG_MENU_SWAP_TOP * TILEMAP_WIDTH
	ld de, v0BGMap1 + DEBUG_MENU_SWAP_TOP * TILEMAP_WIDTH
	ld b, DEBUG_MENU_SWAP_BOTTOM - DEBUG_MENU_SWAP_TOP + 1
.row
	REPT SCREEN_WIDTH
		ld a, [hli]
		ld [de], a
		inc e ; a row doesn't cross a 256-byte page
	ENDR
	ld a, l
	add TILEMAP_WIDTH - SCREEN_WIDTH
	ld l, a
	jr nc, .no_carry_hl
	inc h
.no_carry_hl
	ld a, e
	add TILEMAP_WIDTH - SCREEN_WIDTH
	ld e, a
	jr nc, .no_carry_de
	inc d
.no_carry_de
	dec b
	jr nz, .row
	xor a ; VRAM0
	ldh [rVBK], a
	ret

; -----------------------------------------------------------------------
; Show the LEVEL page as the menu opens, with the LCD off, and turn it on.
; BG map 1 gets the same map, for the title band and the frame that page
; switches keep there (see DebugMenu_NextPage).
; -----------------------------------------------------------------------
DebugMenu_ShowFirstPage:
	ld a, SST_DEBUG_LEVEL_PAGE
	ld [wSubState], a
	ld hl, DebugMenuPals
	ld de, wTempPals1
	ld b, 8 palettes
	call CopyHLToDE_Short
	call ApplyTempPals1ToBGPals
	ld de, v0BGMap1
	call DebugMenu_LoadPageMap
	call DebugMenu_LoadPage
	call DebugMenu_LoadPagesGfx
	ld a, HIGH(wVirtualOAM)
	call hTransferVirtualOAM
	ld a, LCDC_DEFAULT
	ldh [rLCDC], a
	ret

; -----------------------------------------------------------------------
; Draw page wSubState in BG map 0 (its map, values, OB palettes, sprite
; tiles) and its sprites in wVirtualOAM, for the caller to transfer. With
; the LCD on, a V-Blank for each part.
; -----------------------------------------------------------------------
DebugMenu_LoadPage:
	call ClearVirtualOAM
	call DebugMenu_StartVRAMWrite
	ld de, v0BGMap0
	call DebugMenu_LoadPageMap
	call DebugMenu_EndVRAMWrite
	ld a, [wSubState]
	sub SST_DEBUG_LEVEL_PAGE
	jumptable
	dw DebugMenu_DrawAll ; LEVEL: only its values
	dw DebugMenu_LoadPowerPage
	dw DebugMenu_LoadTreasurePage

; -----------------------------------------------------------------------
; Page wSubState's map (the screen's 18 rows, tiles and attributes) to BG
; map de (v0BGMap0 or v0BGMap1), by GDMA: 2 x 36 blocks of 16 bytes, 32
; dots each (in either speed), about 2300 dots. The LCD off or in a
; V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_LoadPageMap:
	ld a, [wSubState]
	sub SST_DEBUG_LEVEL_PAGE
	add a
	add a ; 4 bytes per page
	ld c, a
	ld b, 0
	ld hl, DebugMenuPageMaps
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a ; the tilemap
	push hl
	ld h, b
	ld l, c
	push de
	ld c, DEBUG_MENU_MAP_SIZE / 16
	call DebugMenu_GDMA
	pop de
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a ; the attrmap
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld c, DEBUG_MENU_MAP_SIZE / 16
	call DebugMenu_GDMA
	xor a ; VRAM0
	ldh [rVBK], a
	ret

; -----------------------------------------------------------------------
; Page wSubState's page indicator (its row of DebugMenuPagesGfx) to the
; indicator's tiles, by GDMA (12 blocks, about 400 dots). The LCD off or
; in a V-Blank.
; Clobbers: A, B, C, D, E, H, L
; -----------------------------------------------------------------------
DebugMenu_LoadPagesGfx:
	ld a, [wSubState]
	sub SST_DEBUG_LEVEL_PAGE
	ld hl, DebugMenuPagesGfx
	ld de, DEBUG_MENU_PAGES_TILES tiles
	jr z, .got_pages_gfx
.next_pages_gfx
	add hl, de
	dec a
	jr nz, .next_pages_gfx
.got_pages_gfx
	ld de, v0Tiles2 tile DEBUG_MENU_PAGES_TILE
	ld c, DEBUG_MENU_PAGES_TILES
;	fallthrough

; -----------------------------------------------------------------------
; GDMA c blocks of 16 bytes (1-128) from hl to de, in the current VRAM
; bank, both 16-byte aligned. The CPU waits until it's done. The LCD off or
; in a V-Blank.
; Clobbers: A
; -----------------------------------------------------------------------
DebugMenu_GDMA:
	ld a, h
	ldh [rVDMA_SRC_HIGH], a
	ld a, l
	ldh [rVDMA_SRC_LOW], a
	ld a, d
	ldh [rVDMA_DEST_HIGH], a
	ld a, e
	ldh [rVDMA_DEST_LOW], a
	ld a, c
	dec a
	ASSERT VDMA_LEN_MODE_GENERAL == 0
	ldh [rVDMA_LEN], a
	ret

; -----------------------------------------------------------------------
; Wait for the start of the next V-Blank with interrupts off, to write
; VRAM with the LCD on; DebugMenu_EndVRAMWrite when done (in the same
; V-Blank). Returns right away (interrupts off too) if the LCD is off.
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
.in_vblank ; (for the tests)
	ret

; -----------------------------------------------------------------------
; The end of a write that DebugMenu_StartVRAMWrite started: interrupts
; back on, and with the LCD on, the sound's update for the frame it took
; (the main loop's HandleSound), so that the music keeps its tempo
; through writes that take several frames.
; Preserves all registers.
; -----------------------------------------------------------------------
DebugMenu_EndVRAMWrite:
	ei
	push af
	ldh a, [rLCDC]
	bit B_LCDC_ENABLE, a
	jr z, .done
	push bc
	push de
	push hl
	ld a, BANK(DebugMenu_EndVRAMWrite)
	ldh [hCallFuncBank], a
	hcall HandleSound
	pop hl
	pop de
	pop bc
.done
	pop af
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

; The pages' maps, the screen's 18 rows of the 32x32 maps that
; tools/debug_menu_bgmap.py writes, uncompressed and 16-byte aligned for
; GDMA (DebugMenu_LoadPageMap)
DEF DEBUG_MENU_MAP_SIZE EQU SCREEN_HEIGHT * TILEMAP_WIDTH
	ALIGN 4
DebugLevelTilemap:    INCBIN "data/bgmaps/debug_level.tilemap", 0, DEBUG_MENU_MAP_SIZE
DebugLevelAttrmap:    INCBIN "data/bgmaps/debug_level.attrmap", 0, DEBUG_MENU_MAP_SIZE
DebugPowerTilemap:    INCBIN "data/bgmaps/debug_power.tilemap", 0, DEBUG_MENU_MAP_SIZE
DebugPowerAttrmap:    INCBIN "data/bgmaps/debug_power.attrmap", 0, DEBUG_MENU_MAP_SIZE
DebugTreasureTilemap: INCBIN "data/bgmaps/debug_treasure.tilemap", 0, DEBUG_MENU_MAP_SIZE
DebugTreasureAttrmap: INCBIN "data/bgmaps/debug_treasure.attrmap", 0, DEBUG_MENU_MAP_SIZE

; The page indicator, one row of DEBUG_MENU_PAGES_TILES tiles per page
; (tools/debug_menu_bgmap.py draws it): the page's name in colour 0 (the
; title's yellow), the others in colour 1 (dim), on colour 3. Aligned like
; the maps, which are a multiple of 16 bytes.
DebugMenuPagesGfx: INCBIN "gfx/debug_menu_pages.2bpp"
.end
	ASSERT DebugMenuPagesGfx.end - DebugMenuPagesGfx == 3 * DEBUG_MENU_PAGES_TILES tiles

; The TREASURE page's top edge and level code (tools/debug_menu_bgmap.py
; draws them; see DEBUG_TREASURE_CODE_TILE), in the frame's palette, after
; the page indicator, so 16-byte aligned too
DebugMenuCodeGfx: INCBIN "gfx/debug_menu_code.2bpp"
.end
	ASSERT DebugMenuCodeGfx.end - DebugMenuCodeGfx == (DEBUG_CODE_GFX_DIGITS + 7 * 2) tiles
	ASSERT DEBUG_MENU_MAP_SIZE % 16 == 0

; each page's map, in page order
DebugMenuPageMaps:
	dw DebugLevelTilemap, DebugLevelAttrmap
	dw DebugPowerTilemap, DebugPowerAttrmap
	dw DebugTreasureTilemap, DebugTreasureAttrmap

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
	; page switches move the window (DebugMenu_NextPage)
	ldh a, [rWY]
	ld [wDebugMenuLevelWY], a
	ldh a, [rWX]
	ld [wDebugMenuLevelWX], a
	call DisableLCD
	call SaveBackupVRAM

	; Save animated tile state (GFX RAM already active from wrapper)
	ld a, [wAnimatedTilesFrameDuration]
	ld [wTempAnimatedTilesFrameDuration], a
	ld a, [wAnimatedTilesGfx]
	ld [wTempAnimatedTilesGroup], a

	; Each page's selection, kept while the menu is open: LEVEL's cursor on
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

	; FORM starts on Wario's form: the first entry with his transformation,
	; hidden or not (NONE if none has it). Not ROLL: SELECT stops a roll
	; instead of opening the menu (UpdateLevel).
	ld a, [wTransformation]
	ld b, a
	ld hl, DebugFormTable
	ld c, 0
.find_form
	ld a, [hl]
	cp b
	jr z, .got_form
	ld a, l
	add DEBUG_FORM_ENTRY_SIZE
	ld l, a
	jr nc, .no_carry
	inc h
.no_carry
	inc c
	ld a, c
	cp NUM_DEBUG_FORMS
	jr c, .find_form
	ld c, DEBUG_FORM_NONE
.got_form
	ld a, c
	ld [wDebugMenuFormIdx], a

	call DebugMenu_LoadTiles
	call VBlank_PauseMenu
	xor a
	ldh [rSCY], a
	ldh [rSCX], a
	ld [wSCY], a
	ld [wSCX], a

	; LEVEL, and the LCD on
	call DebugMenu_ShowFirstPage

	; the pause menu's music (DebugMenu_Exit gives the level's back)
	play_music MUSIC_PAUSE_MENU
	ret

; -----------------------------------------------------------------------
; SST_DEBUG_LEVEL_PAGE: LEVEL's input
; -----------------------------------------------------------------------
UpdateDebugLevelPage:
	ld a, [wJoypadPressed]
	ld b, a                ; save joypad

	; B or START: exit; SELECT: the next page
	and PAD_B | PAD_START
	jp nz, DebugMenu_Exit
	bit B_PAD_SELECT, b
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
	ld b, 1
	call DebugMenu_StepForm
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
	ld b, -1
	call DebugMenu_StepForm
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
	jp DebugMenu_DrawAll

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
	ld a, [wDebugMenuLevelWY]
	ldh [rWY], a
	ld a, [wDebugMenuLevelWX]
	ldh [rWX], a
	ld a, [wDebugMenuLevelLCDC]
	ldh [rLCDC], a

	jp ReturnToPendingLevelState
