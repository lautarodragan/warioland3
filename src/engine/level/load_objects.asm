LoadObjectGroupData::
; fills wObjDataPointers with Dummy Object
	ld hl, wObjDataPointers
	ld bc, DummyObjectData
	ld e, $10
.loop_1
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	dec e
	jr nz, .loop_1

	ld a, [wObjectGroup]
	cp OBJECT_GROUP_HIDDEN_FIGURE
	jp z, LoadHiddenFigureData

	ld d, $00
	ld e, a
	sla e
	rl d
	sla e
	rl d ; *4
	ld hl, ObjectGroups
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]

	push hl
	ld h, a
	ld l, c
	ld de, wChestObjDataPtr
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a ; wKeyObjDataPtr
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a ; wMusicalCoinObjDataPtr
	inc e
	ld a, [hli]
	ld [de], a
	ld de, wTempPals2 palette 3
	ld b, 1 palettes
	call CopyHLToDE_Short
	pop hl

	ld a, [hli]
	ld c, a
	ld h, [hl]
	ld l, c
	ld a, BANK("VRAM1")
	ldh [rVBK], a
	ld a, [hli]
	ldh [hTemp], a

	; enemy slot 1
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld h, a
	ld l, c
	ld bc, v1Tiles0
	ldh a, [hTemp]
	ld e, BANK("Enemy Gfx 1 Slot 1")
	add e
	ldh [hCallFuncBank], a
	hcall Decompress
	pop hl

	; enemy slot 2
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld h, a
	ld l, c
	ld bc, v1Tiles0 tile $40
	ldh a, [hTemp]
	ld e, BANK("Enemy Gfx 1 Slot 2")
	add e
	ldh [hCallFuncBank], a
	hcall Decompress
	pop hl

	; enemy slot 3
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld h, a
	ld l, c
	ld bc, v1Tiles1
	ldh a, [hTemp]
	ld e, BANK("Enemy Gfx 1 Slot 3")
	add e
	ldh [hCallFuncBank], a
	hcall Decompress
	pop hl

	; enemy slot 4
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld h, a
	ld l, c
	ld bc, v1Tiles1 tile $40
	ldh a, [hTemp]
	ld e, BANK("Enemy Gfx 1 Slot 4")
	add e
	ldh [hCallFuncBank], a
	hcall Decompress
	pop hl

	xor a ; VRAM0
	ldh [rVBK], a

	ld a, 13
	ldh [hTemp], a
	ld de, wObjDataPtr01
.loop_2
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	inc a
	jr z, .copy_pals
	ld a, c
	ld [de], a
	inc e
	ld a, b
	ld [de], a
	inc e
	ldh a, [hTemp]
	dec a
	ldh [hTemp], a
	jr nz, .loop_2

.copy_pals
	jp LoadObjPals

; input:
; - de = block
; - c = entry in wObjDataPointers
SpawnObject:
	ldh a, [hXPosHi]
	cp $0a
	ret nc

	ld h, HIGH(wObj1)
FOR n, 1, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n})
	ld a, [hli]
	rra
	jr nc, .got_obj
ENDR
	ret

.got_obj
	; bit 7 set means it's not spawned in
	ld a, [de]
	rlca
	ret nc
	; not spawned, unset bit 7
	rrca
	and $7f
	ld [de], a

	ld [hl], e ; OBJ_MAP_PTR_LO
	inc l
	ld a, [wObjectMapBank]
	dec a
	add a ; *2
	add a ; *4
	add a ; *8
	add a ; *16
	add a ; *32
	add d
	ld [hli], a ; OBJ_MAP_PTR_HI
	ldh a, [hYPosLo]
	ld [hli], a ; OBJ_Y_POS
	ldh a, [hYPosHi]
	ld [hli], a
	ldh a, [hXPosLo]
	ld [hli], a ; OBJ_X_POS
	ldh a, [hXPosHi]
	ld [hli], a

	push hl
	ld hl, wObjDataPointers
	dec c
	sla c ; *2
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de

	ld a, [hli]
	ld [de], a ; OBJ_ID
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_INTERACTION_TYPE
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_COLLBOX_TOP
	inc e
	xor a
	ld [de], a ; OBJ_COLLBOX_BOTTOM

	ld a, e
	add OBJ_FRAME - OBJ_COLLBOX_BOTTOM
	ld e, a
	xor a
	ld [de], a ; OBJ_FRAME
	inc e
	ld a, [hli] ; OBJ_OAM_PTR
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a

	ld a, e
	add OBJ_FRAME_DURATION - (OBJ_OAM_PTR + 1)
	ld e, a
	ld a, $7f
	ld [de], a ; OBJ_FRAME_DURATION

	ld a, e
	add OBJ_SUBSTATE - OBJ_FRAME_DURATION
	ld e, a
	ld a, $1 | OBJSUBFLAG_UNINITIALISED
	ld [de], a ; OBJ_SUBSTATE
	inc e
	xor a ; OBJSTATE_DEFAULT
	ld [de], a ; OBJ_STATE
	inc e
	ld a, no_actions_for 2
	ld [de], a ; OBJ_ACTION
	inc e
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_UPDATE_FUNCTION
	inc e
	ld a, [hli]
	ld [de], a

	ld a, e
	sub (OBJ_UPDATE_FUNCTION + 1) - OBJ_FLAGS
	ld e, a
	ld a, [hl]
	or OBJFLAG_ACTIVE | OBJFLAG_INVISIBLE
	ld [de], a ; OBJ_FLAGS
	ret

DespawnAllObjects:
	ld h, HIGH(wObjects)
FOR n, 0, NUM_OBJECTS
	ld l, LOW(wObjects) + OBJ_STRUCT_LENGTH * n
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr nc, .skip_{u:n} ; skip if OBJFLAG_ACTIVE not set
	rla
	rla
	rla
	jr nc, .despawn_{u:n} ; jump if OBJFLAG_TRANSIENT not set
	xor a
	ld [hl], a
	jr .skip_{u:n}
.despawn_{u:n}
	inc l
	inc l
	farcall DespawnObject
.skip_{u:n}
ENDR
	ret

; bc = object creation data
_CreateObjectFromCurObjPos::
	ld h, HIGH(wObj1Flags)
FOR n, 1, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n}Flags)
	ld a, [hl]
	rra
	jr nc, .got_obj_slot ; OBJFLAG_ACTIVE not set
ENDR
	ret

.got_obj_slot
	ld a, OBJFLAG_ACTIVE | OBJFLAG_TRANSIENT
	ld [hli], a
	ld a, [wCurObjMapPtrLo]
	ld [hli], a
	ld a, [wCurObjMapPtrHi]
	ld [hli], a
	ld a, [wCurObjYPos + 0]
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	ld [hli], a
	ld a, [wCurObjXPos + 0]
	ld [hli], a
	ld a, [wCurObjXPos + 1]
	jr CreateObject_GotPos

_CreateObjectAtRelativePos::
	ld h, HIGH(wObj1Flags)
FOR n, 1, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n}Flags)
	ld a, [hl]
	rra
	jr nc, .got_obj_slot ; OBJFLAG_ACTIVE not set
ENDR
	ret

.got_obj_slot
	ld a, OBJFLAG_ACTIVE | OBJFLAG_TRANSIENT
	ld [hli], a
	ld a, [wCurObjMapPtrLo]
	ld [hli], a
	ld a, [wCurObjMapPtrHi]
	ld [hli], a
	ld a, [wCurObjYPos + 0]
	ld e, a
	ld a, [bc]
	rla
	jr c, .negative_y
	rra
	add e
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	jr nc, .got_hi_y
	inc a
	jr .got_hi_y
.negative_y
	rra
	add e
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	jr c, .got_hi_y
	dec a
.got_hi_y
	ld [hli], a
	inc bc
	ld a, [wCurObjXPos]
	ld e, a
	ld a, [bc]
	rla
	jr c, .negative_x
	rra
	add e
	ld [hli], a
	ld a, [wCurObjXPos + 1]
	jr nc, .got_hi_x
	inc a
	jr .got_hi_x
.negative_x
	rra
	add e
	ld [hli], a
	ld a, [wCurObjXPos + 1]
	jr c, .got_hi_x
	dec a
.got_hi_x
	inc bc
CreateObject_GotPos:
	ld [hli], a
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld a, [hli]
	ld [de], a ; OBJ_ID
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_INTERACTION_TYPE
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_COLLBOX_TOP
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_COLLBOX_BOTTOM
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_COLLBOX_LEFT
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_COLLBOX_RIGHT
	inc e
	inc e
	inc e
	inc e
	ld a, [hli] ; OBJ_OAM_PTR
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli] ; OBJ_FRAMESET_PTR
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	xor a
	ld [de], a ; OBJ_FRAME_DURATION
	inc e
	ld [de], a ; OBJ_FRAMESET_OFFSET
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_STATE_DURATION
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_VAR_1
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_VAR_2
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_VAR_3
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_SUBSTATE
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_STATE
	inc e
	xor a ; OBJACTION_NONE
	ld [de], a ; OBJ_ACTION
	inc e
	inc e
	ld a, [hli]
	ld [de], a ; OBJ_UPDATE_FUNCTION
	inc e
	ld a, [hli]
	ld [de], a
	ld a, e
	sub (OBJ_UPDATE_FUNCTION + 1) - OBJ_FLAGS
	ld e, a
	ld a, [hl] ; OBJ_FLAGS
	or OBJFLAG_ACTIVE | OBJFLAG_TRANSIENT
	ld [de], a
	ret

LoadHiddenFigureData:
	ld hl, .pointers
	ld a, $d
	ldh [hTemp], a
	ld de, wObjDataPtr01
.loop
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	inc a
	ret z
	ld a, c
	ld [de], a
	inc e
	ld a, b
	ld [de], a
	inc e
	ldh a, [hTemp]
	dec a
	ldh [hTemp], a
	jr nz, .loop
	ret

.pointers
	dw HiddenFigureData
	dw NULL

INCLUDE "data/object_data.asm"
INCLUDE "data/object_params.asm"

CommonObjects_Grey:
	dw GreyChestData
	dw GreyKeyData
	dw MusicalCoinData

	rgb  0, 22, 16
	rgb 28, 28, 28
	rgb 15, 15, 15
	rgb  0,  0,  0

CommonObjects_Red:
	dw RedChestData
	dw RedKeyData
	dw MusicalCoinData

	rgb  0, 22, 16
	rgb 31, 24, 24
	rgb 23,  0,  0
	rgb  7,  0,  0

CommonObjects_Green:
	dw GreenChestData
	dw GreenKeyData
	dw MusicalCoinData

	rgb  0, 22, 16
	rgb 24, 31, 21
	rgb  0, 16,  0
	rgb  0,  2,  0

CommonObjects_Blue:
	dw BlueChestData
	dw BlueKeyData
	dw MusicalCoinData

	rgb  0, 22, 16
	rgb 19, 31, 31
	rgb  0, 12, 31
	rgb  0,  0,  7

CommonObjects_Special:
	dw GreyChestData
	dw GreyKeyData
	dw MusicalCoinData

	rgb 31, 31, 31
	rgb  0, 27, 31
	rgb 31,  0, 12
	rgb  5,  0,  0

ObjectGroups:
	table_width 4
	dw CommonObjects_Grey,    ObjectGroup_Empty               ; OBJECT_GROUP_EMPTY
	dw CommonObjects_Green,   ObjectGroup_Shared1             ; OBJECT_GROUP_SHARED_1
	dw CommonObjects_Red,     ObjectGroup_Shared2             ; OBJECT_GROUP_SHARED_2
	dw CommonObjects_Green,   ObjectGroup_Shared3             ; OBJECT_GROUP_SHARED_3
	dw CommonObjects_Green,   ObjectGroup_OutOfTheWoods6      ; OBJECT_GROUP_OUT_OF_THE_WOODS_6
	dw CommonObjects_Green,   ObjectGroup_OutOfTheWoods4      ; OBJECT_GROUP_OUT_OF_THE_WOODS_4
	dw CommonObjects_Green,   ObjectGroup_OutOfTheWoods7      ; OBJECT_GROUP_OUT_OF_THE_WOODS_7
	dw CommonObjects_Blue,    ObjectGroup_Shared4             ; OBJECT_GROUP_SHARED_4
	dw CommonObjects_Grey,    ObjectGroup_Shared5             ; OBJECT_GROUP_SHARED_5
	dw CommonObjects_Grey,    ObjectGroup_OutOfTheWoods1      ; OBJECT_GROUP_OUT_OF_THE_WOODS_1
	dw CommonObjects_Grey,    ObjectGroup_Shared6             ; OBJECT_GROUP_SHARED_6
	dw CommonObjects_Grey,    ObjectGroup_Shared7             ; OBJECT_GROUP_SHARED_7
	dw CommonObjects_Grey,    ObjectGroup_TheVastPlain1       ; OBJECT_GROUP_THE_VAST_PLAIN_1
	dw CommonObjects_Red,     ObjectGroup_Shared5             ; OBJECT_GROUP_SHARED_8
	dw CommonObjects_Red,     ObjectGroup_Shared9             ; OBJECT_GROUP_SHARED_9
	dw CommonObjects_Green,   ObjectGroup_Shared10            ; OBJECT_GROUP_SHARED_10
	dw CommonObjects_Grey,    ObjectGroup_BeneathTheWaves1    ; OBJECT_GROUP_BENEATH_THE_WAVES_1
	dw CommonObjects_Grey,    ObjectGroup_Shared11            ; OBJECT_GROUP_SHARED_11
	dw CommonObjects_Grey,    ObjectGroup_TheTidalCoast1      ; OBJECT_GROUP_THE_TIDAL_COAST_1
	dw CommonObjects_Grey,    ObjectGroup_Shared12            ; OBJECT_GROUP_SHARED_12
	dw CommonObjects_Grey,    ObjectGroup_Shared2             ; OBJECT_GROUP_OUT_OF_THE_WOODS_2
	dw CommonObjects_Green,   ObjectGroup_TheVastPlain2       ; OBJECT_GROUP_THE_VAST_PLAIN_2
	dw CommonObjects_Green,   ObjectGroup_Shared2             ; OBJECT_GROUP_SHARED_13
	dw CommonObjects_Grey,    ObjectGroup_DesertRuins1        ; OBJECT_GROUP_DESERT_RUINS_1
	dw CommonObjects_Blue,    ObjectGroup_Shared14            ; OBJECT_GROUP_SHARED_14
	dw CommonObjects_Blue,    ObjectGroup_Shared15            ; OBJECT_GROUP_SHARED_15
	dw CommonObjects_Green,   ObjectGroup_Shared15            ; OBJECT_GROUP_SHARED_16
	dw CommonObjects_Red,     ObjectGroup_TheWestCrater2      ; OBJECT_GROUP_THE_WEST_CRATER_2
	dw CommonObjects_Blue,    ObjectGroup_ThePeacefulVillage4 ; OBJECT_GROUP_THE_PEACEFUL_VILLAGE_4
	dw CommonObjects_Green,   ObjectGroup_Shared17            ; OBJECT_GROUP_SHARED_17
	dw CommonObjects_Grey,    ObjectGroup_BeneathTheWaves4    ; OBJECT_GROUP_BENEATH_THE_WAVES_4
	dw CommonObjects_Grey,    ObjectGroup_TheColossalHole1    ; OBJECT_GROUP_THE_COLOSSAL_HOLE_1
	dw CommonObjects_Grey,    ObjectGroup_TheColossalHole3    ; OBJECT_GROUP_THE_COLOSSAL_HOLE_3
	dw CommonObjects_Grey,    ObjectGroup_Shared18            ; OBJECT_GROUP_SHARED_18
	dw CommonObjects_Red,     ObjectGroup_ThePeacefulVillage4 ; OBJECT_GROUP_THE_STAGNANT_SWAMP_1
	dw CommonObjects_Green,   ObjectGroup_Shared19            ; OBJECT_GROUP_SHARED_19
	dw CommonObjects_Blue,    ObjectGroup_OutOfTheWoods3      ; OBJECT_GROUP_OUT_OF_THE_WOODS_3
	dw CommonObjects_Red,     ObjectGroup_Shared20            ; OBJECT_GROUP_SHARED_20
	dw CommonObjects_Grey,    ObjectGroup_Shared20            ; OBJECT_GROUP_TOWER_OF_REVIVAL_1
	dw CommonObjects_Grey,    ObjectGroup_Shared1             ; OBJECT_GROUP_UNUSED_039
	dw CommonObjects_Blue,    ObjectGroup_Shared19            ; OBJECT_GROUP_SHARED_21
	dw CommonObjects_Red,     ObjectGroup_TheColossalHole5    ; OBJECT_GROUP_THE_COLOSSAL_HOLE_5
	dw CommonObjects_Green,   ObjectGroup_CastleOfIllusions2  ; OBJECT_GROUP_CASTLE_OF_ILLUSIONS_2
	dw CommonObjects_Blue,    ObjectGroup_CastleOfIllusions2  ; OBJECT_GROUP_FOREST_OF_FEAR_2
	dw CommonObjects_Grey,    ObjectGroup_TheVolcanosBase2    ; OBJECT_GROUP_THE_VOLCANOS_BASE_2
	dw CommonObjects_Green,   ObjectGroup_Shared14            ; OBJECT_GROUP_BENEATH_THE_WAVES_3
	dw CommonObjects_Blue,    ObjectGroup_BeneathTheWaves4    ; OBJECT_GROUP_UNUSED_046
	dw CommonObjects_Red,     ObjectGroup_Shared7             ; OBJECT_GROUP_BENEATH_THE_WAVES_6
	dw CommonObjects_Blue,    ObjectGroup_TheVastPlain3       ; OBJECT_GROUP_THE_VAST_PLAIN_3
	dw CommonObjects_Grey,    ObjectGroup_TheGrasslands3      ; OBJECT_GROUP_THE_GRASSLANDS_3
	dw CommonObjects_Red,     ObjectGroup_Shared17            ; OBJECT_GROUP_CASTLE_OF_ILLUSIONS_5
	dw CommonObjects_Blue,    ObjectGroup_CastleOfIllusions3  ; OBJECT_GROUP_CASTLE_OF_ILLUSIONS_3
	dw CommonObjects_Grey,    ObjectGroup_ThePoolOfRain1      ; OBJECT_GROUP_THE_POOL_OF_RAIN_1
	dw CommonObjects_Grey,    ObjectGroup_ThePeacefulVillage1 ; OBJECT_GROUP_THE_PEACEFUL_VILLAGE_1
	dw CommonObjects_Grey,    ObjectGroup_ThePeacefulVillage5 ; OBJECT_GROUP_THE_PEACEFUL_VILLAGE_5
	dw CommonObjects_Blue,    ObjectGroup_DesertRuins2        ; OBJECT_GROUP_DESERT_RUINS_2
	dw CommonObjects_Green,   ObjectGroup_TheVastPlain4       ; OBJECT_GROUP_THE_VAST_PLAIN_4
	dw CommonObjects_Green,   ObjectGroup_ATownInChaos3       ; OBJECT_GROUP_A_TOWN_IN_CHAOS_3
	dw CommonObjects_Red,     ObjectGroup_ThePeacefulVillage2 ; OBJECT_GROUP_THE_PEACEFUL_VILLAGE_2
	dw CommonObjects_Grey,    ObjectGroup_TheVolcanosBase3    ; OBJECT_GROUP_THE_VOLCANOS_BASE_3
	dw CommonObjects_Green,   ObjectGroup_Shared22            ; OBJECT_GROUP_SHARED_22
	dw CommonObjects_Grey,    ObjectGroup_DesertRuins3        ; OBJECT_GROUP_DESERT_RUINS_3
	dw CommonObjects_Blue,    ObjectGroup_TheBigBridge2       ; OBJECT_GROUP_THE_BIG_BRIDGE_2
	dw CommonObjects_Blue,    ObjectGroup_SeaTurtleRocks3     ; OBJECT_GROUP_SEA_TURTLE_ROCKS_3
	dw CommonObjects_Red,     ObjectGroup_SeaTurtleRocks1     ; OBJECT_GROUP_SEA_TURTLE_ROCKS_1
	dw CommonObjects_Red,     ObjectGroup_TheVolcanosBase1    ; OBJECT_GROUP_THE_VOLCANOS_BASE_1
	dw CommonObjects_Red,     ObjectGroup_TheVolcanosBase1    ; OBJECT_GROUP_UNUSED_066
	dw CommonObjects_Red,     ObjectGroup_TheVolcanosBase4    ; OBJECT_GROUP_THE_VOLCANOS_BASE_4
	dw CommonObjects_Grey,    ObjectGroup_Shared23            ; OBJECT_GROUP_SHARED_23
	dw CommonObjects_Grey,    ObjectGroup_BankOfTheWildRiver3 ; OBJECT_GROUP_BANK_OF_THE_WILD_RIVER_3
	dw CommonObjects_Grey,    ObjectGroup_Shared24            ; OBJECT_GROUP_SHARED_24
	dw CommonObjects_Grey,    ObjectGroup_ATownInChaos2       ; OBJECT_GROUP_A_TOWN_IN_CHAOS_2
	dw CommonObjects_Red,     ObjectGroup_TheGrasslands5      ; OBJECT_GROUP_THE_GRASSLANDS_5
	dw CommonObjects_Grey,    ObjectGroup_TheBigBridge1       ; OBJECT_GROUP_THE_BIG_BRIDGE_1
	dw CommonObjects_Blue,    ObjectGroup_BankOfTheWildRiver2 ; OBJECT_GROUP_BANK_OF_THE_WILD_RIVER_2
	dw CommonObjects_Blue,    ObjectGroup_Shared9             ; OBJECT_GROUP_THE_POOL_OF_RAIN_4
	dw CommonObjects_Red,     ObjectGroup_OutOfTheWoods1      ; OBJECT_GROUP_THE_POOL_OF_RAIN_2
	dw CommonObjects_Grey,    ObjectGroup_TowerOfRevival3     ; OBJECT_GROUP_TOWER_OF_REVIVAL_3
	dw CommonObjects_Blue,    ObjectGroup_TheStagnantSwamp3   ; OBJECT_GROUP_THE_STAGNANT_SWAMP_3
	dw CommonObjects_Green,   ObjectGroup_TheColossalHole4    ; OBJECT_GROUP_THE_COLOSSAL_HOLE_4
	dw CommonObjects_Green,   ObjectGroup_TheGrasslands2      ; OBJECT_GROUP_THE_GRASSLANDS_2
	dw CommonObjects_Red,     ObjectGroup_BeneathTheWaves4    ; OBJECT_GROUP_THE_BIG_BRIDGE_4
	dw CommonObjects_Grey,    ObjectGroup_TheEastCrater1      ; OBJECT_GROUP_THE_EAST_CRATER_1
	dw CommonObjects_Red,     ObjectGroup_TheEastCrater4      ; OBJECT_GROUP_THE_EAST_CRATER_4
	dw CommonObjects_Green,   ObjectGroup_TheEastCrater3      ; OBJECT_GROUP_THE_EAST_CRATER_3
	dw CommonObjects_Blue,    ObjectGroup_TheEastCrater2      ; OBJECT_GROUP_THE_EAST_CRATER_2
	dw CommonObjects_Grey,    ObjectGroup_SeaTurtleRocks2     ; OBJECT_GROUP_SEA_TURTLE_ROCKS_2
	dw CommonObjects_Green,   ObjectGroup_TheBigBridge1       ; OBJECT_GROUP_THE_PEACEFUL_VILLAGE_3
	dw CommonObjects_Grey,    ObjectGroup_BankOfTheWildRiver1 ; OBJECT_GROUP_BANK_OF_THE_WILD_RIVER_1
	dw CommonObjects_Blue,    ObjectGroup_Shared25            ; OBJECT_GROUP_SHARED_25
	dw CommonObjects_Blue,    ObjectGroup_Shared26            ; OBJECT_GROUP_SHARED_26
	dw CommonObjects_Green,   ObjectGroup_Shared12            ; OBJECT_GROUP_THE_TIDAL_COAST_2
	dw CommonObjects_Blue,    ObjectGroup_Shared6             ; OBJECT_GROUP_SHARED_27
	dw CommonObjects_Red,     ObjectGroup_Shared14            ; OBJECT_GROUP_THE_TIDAL_COAST_3
	dw CommonObjects_Grey,    ObjectGroup_TheSteepCanyon1     ; OBJECT_GROUP_THE_STEEP_CANYON_1
	dw CommonObjects_Green,   ObjectGroup_TheSteepCanyon2     ; OBJECT_GROUP_THE_STEEP_CANYON_2
	dw CommonObjects_Grey,    ObjectGroup_TheFrigidSea1       ; OBJECT_GROUP_THE_FRIGID_SEA_1
	dw CommonObjects_Blue,    ObjectGroup_Shared28            ; OBJECT_GROUP_SHARED_28
	dw CommonObjects_Blue,    ObjectGroup_TheWestCrater1      ; OBJECT_GROUP_THE_WEST_CRATER_1
	dw CommonObjects_Blue,    ObjectGroup_TheGrasslands6      ; OBJECT_GROUP_THE_GRASSLANDS_6
	dw CommonObjects_Blue,    ObjectGroup_TheGrasslands4      ; OBJECT_GROUP_THE_GRASSLANDS_4
	dw CommonObjects_Grey,    ObjectGroup_Shared29            ; OBJECT_GROUP_SHARED_29
	dw CommonObjects_Green,   ObjectGroup_TheStagnantSwamp4   ; OBJECT_GROUP_THE_STAGNANT_SWAMP_4
	dw CommonObjects_Blue,    ObjectGroup_Shared2             ; OBJECT_GROUP_UNUSED_103
	dw CommonObjects_Blue,    ObjectGroup_Shared30            ; OBJECT_GROUP_SHARED_30
	dw CommonObjects_Blue,    ObjectGroup_TheColossalHole2    ; OBJECT_GROUP_THE_COLOSSAL_HOLE_2
	dw CommonObjects_Blue,    ObjectGroup_Shared31            ; OBJECT_GROUP_SHARED_31
	dw CommonObjects_Red,     ObjectGroup_TheStagnantSwamp2   ; OBJECT_GROUP_THE_STAGNANT_SWAMP_2
	dw CommonObjects_Green,   ObjectGroup_ThePoolOfRain3      ; OBJECT_GROUP_THE_POOL_OF_RAIN_3
	dw CommonObjects_Green,   ObjectGroup_TheWarpedVoid2      ; OBJECT_GROUP_THE_WARPED_VOID_2
	dw CommonObjects_Blue,    ObjectGroup_TheWarpedVoid1      ; OBJECT_GROUP_THE_WARPED_VOID_1
	dw CommonObjects_Red,     ObjectGroup_ATownInChaos5       ; OBJECT_GROUP_A_TOWN_IN_CHAOS_5
	dw CommonObjects_Red,     ObjectGroup_TheGrasslands1      ; OBJECT_GROUP_THE_GRASSLANDS_1
	dw CommonObjects_Grey,    ObjectGroup_Shared32            ; OBJECT_GROUP_SHARED_32
	dw CommonObjects_Blue,    ObjectGroup_OutOfTheWoods5      ; OBJECT_GROUP_OUT_OF_THE_WOODS_5
	dw CommonObjects_Blue,    ObjectGroup_TowerOfRevival2     ; OBJECT_GROUP_TOWER_OF_REVIVAL_2
	dw CommonObjects_Grey,    ObjectGroup_CastleOfIllusions1  ; OBJECT_GROUP_CASTLE_OF_ILLUSIONS_1
	dw CommonObjects_Green,   ObjectGroup_TowerOfRevival4     ; OBJECT_GROUP_TOWER_OF_REVIVAL_4
	dw CommonObjects_Red,     ObjectGroup_Shared32            ; OBJECT_GROUP_THE_FRIGID_SEA_3
	dw CommonObjects_Green,   ObjectGroup_CaveOfFlames4       ; OBJECT_GROUP_CAVE_OF_FLAMES_4
	dw CommonObjects_Red,     ObjectGroup_Shared28            ; OBJECT_GROUP_THE_FRIGID_SEA_2
	dw CommonObjects_Red,     ObjectGroup_ATownInChaos1       ; OBJECT_GROUP_A_TOWN_IN_CHAOS_1
	dw CommonObjects_Green,   ObjectGroup_TheBigBridge5       ; OBJECT_GROUP_THE_BIG_BRIDGE_5
	dw CommonObjects_Green,   ObjectGroup_TheBigBridge3       ; OBJECT_GROUP_THE_BIG_BRIDGE_3
	dw CommonObjects_Grey,    ObjectGroup_CaveOfFlames1       ; OBJECT_GROUP_CAVE_OF_FLAMES_1
	dw CommonObjects_Grey,    ObjectGroup_AboveTheClouds1     ; OBJECT_GROUP_ABOVE_THE_CLOUDS_1
	dw CommonObjects_Blue,    ObjectGroup_AboveTheClouds1     ; OBJECT_GROUP_ABOVE_THE_CLOUDS_2
	dw CommonObjects_Grey,    ObjectGroup_Shared31            ; OBJECT_GROUP_SHARED_33
	dw CommonObjects_Red,     ObjectGroup_AboveTheClouds4     ; OBJECT_GROUP_ABOVE_THE_CLOUDS_4
	dw CommonObjects_Green,   ObjectGroup_Shared34            ; OBJECT_GROUP_SHARED_34
	dw CommonObjects_Grey,    ObjectGroup_AboveTheClouds3     ; OBJECT_GROUP_ABOVE_THE_CLOUDS_3
	dw CommonObjects_Blue,    ObjectGroup_AboveTheClouds5     ; OBJECT_GROUP_ABOVE_THE_CLOUDS_5
	dw CommonObjects_Green,   ObjectGroup_TheColossalHole6    ; OBJECT_GROUP_THE_COLOSSAL_HOLE_6
	dw CommonObjects_Blue,    ObjectGroup_BeneathTheWaves5    ; OBJECT_GROUP_BENEATH_THE_WAVES_5
	dw CommonObjects_Blue,    ObjectGroup_CaveOfFlames3       ; OBJECT_GROUP_CAVE_OF_FLAMES_3
	dw CommonObjects_Blue,    ObjectGroup_CaveOfFlames2       ; OBJECT_GROUP_CAVE_OF_FLAMES_2
	dw CommonObjects_Grey,    ObjectGroup_TheWestCrater3      ; OBJECT_GROUP_THE_WEST_CRATER_3
	dw CommonObjects_Red,     ObjectGroup_TheEastCrater5      ; OBJECT_GROUP_THE_EAST_CRATER_5
	dw CommonObjects_Grey,    ObjectGroup_TheEastCrater6      ; OBJECT_GROUP_THE_EAST_CRATER_6
	dw CommonObjects_Green,   ObjectGroup_BankOfTheWildRiver4 ; OBJECT_GROUP_BANK_OF_THE_WILD_RIVER_4
	dw CommonObjects_Grey,    ObjectGroup_CastleOfIllusions4  ; OBJECT_GROUP_CASTLE_OF_ILLUSIONS_4
	dw CommonObjects_Grey,    ObjectGroup_CastleOfIllusions6  ; OBJECT_GROUP_CASTLE_OF_ILLUSIONS_6
	dw CommonObjects_Red,     ObjectGroup_BeneathTheWaves2    ; OBJECT_GROUP_BENEATH_THE_WAVES_2
	dw CommonObjects_Green,   ObjectGroup_TheColossalHole5    ; OBJECT_GROUP_FOREST_OF_FEAR_3
	dw CommonObjects_Red,     ObjectGroup_CastleOfIllusions2  ; OBJECT_GROUP_FOREST_OF_FEAR_1
	dw CommonObjects_Special, ObjectGroup_ATownInChaos4       ; OBJECT_GROUP_A_TOWN_IN_CHAOS_4
	assert_table_length NUM_OBJECT_GROUPS

INCLUDE "data/object_groups.asm"
