_HandleTempleShakeAndRocks:
	call HandleTempleScreenShake
	call HandleTempleRock1Fall
	call HandleTempleRock2Fall
	call HandleTempleRock3Fall
	call HandleTempleRock4Fall
	call HandleTempleRock5Fall
	call HandleTempleRock6Fall
	call HandleTempleRock7Bounce
	call HandleTempleRock8Bounce
	call HandleTempleRock9Bounce
	call HandleTempleRock10Bounce
	ret

HandleTempleScreenShake:
	ld hl, wTempleShakeState
	ld a, [hli]
	and a
	ret z
	inc [hl] ; wTempleShakeCounter
	ld b, h
	ld c, l
	dec a
	jumptable

	dw .Init
	dw .Next
	dw .SlowScrollLeftWithSFX
	dw .SlowScrollRight
	dw .SlowScrollLeft
	dw .SlowScrollRight
	dw .SlowScrollLeft
	dw .SlowScrollRight
	dw .SlowScrollLeft
	dw .SlowScrollRightAndReset
	dw .Next
	dw .SlowScrollLeft
	dw .FastScrollRightWithSFX
	dw .FastScrollLeft
	dw .FastScrollRight
	dw .FastScrollLeft
	dw .FastScrollRight
	dw .FastScrollLeft
	dw .FastScrollRight
	dw .FastScrollLeftAndReset

.Init:
	ld hl, wTempleShakeCounter
	xor a
	ld [hld], a
	ld [hl], a
	ld [wSCX], a
	ld [wSCY], a
	ret

.Next:
	ld hl, wTempleShakeCounter
	xor a
	ld [hld], a
	inc [hl]
	ret

.SlowScrollLeftWithSFX:
	play_sfx SFX_01F
.SlowScrollLeft:
	ld a, [bc]
	cp 2
	ret c
	ld hl, wSCX
	dec [hl]
	jr .Next

.SlowScrollRight:
	ld a, [bc]
	cp 2
	ret c
	ld hl, wSCX
	inc [hl]
	jr .Next

.SlowScrollRightAndReset:
	ld a, [bc]
	cp 2
	ret c
	ld hl, wSCX
	inc [hl]
	ld hl, wTempleShakeCounter
	xor a
	ld [hld], a
	ld a, [hl] ; wTempleShakeState
	sub $07
	ld [hl], a
	ret

.FastScrollRightWithSFX:
	play_sfx SFX_01F
.FastScrollRight:
	ld a, [bc]
	cp 2
	ret c
	ld hl, wSCX
	inc [hl]
	inc [hl]
	jr .Next

.FastScrollLeft:
	ld a, [bc]
	cp 2
	ret c
	ld hl, wSCX
	dec [hl]
	dec [hl]
	jr .Next

.FastScrollLeftAndReset:
	ld a, [bc]
	cp 2
	ret c
	ld hl, wSCX
	dec [hl]
	dec [hl]
	ld hl, wTempleShakeCounter
	xor a
	ld [hld], a
	ld a, [hl]
	sub $07
	ld [hl], a
	ret

WaitTempleRockRespawn:
	ld a, [bc]
	cp [hl]
	ret c
	dec l
	ld a, [hld] ; size
	and a
	jr z, .asm_1580d6
	dec l
	ld a, $01
	ld [hl], a ; action
	jr StubTempleRockFunc
.asm_1580d6
	ld [hld], a ; counter
	ld [hl], a  ; action
StubTempleRockFunc:
	ret

SetTempleRockSize_WithLarge:
	cp TEMPLE_ROCK_SIZE_LARGE
	ld a, $9
	jr c, .set_state
	ld b, a
	ld a, c ; random seed
	and %11
	cp %11
	jr nz, .ok
	dec a
.ok
	; either 0, 1 or 2
	add b
.set_state
	jp SetSceneObjState

SetTempleRockSize_WithoutLarge:
	cp TEMPLE_ROCK_SIZE_LARGE
	ld a, $9
	jr c, .set_state
	ld b, a
	ld a, c
	and %1
	; either 0 or 1
	add b
.set_state
	jp SetSceneObjState

SpawnRock_Top:
	xor a
SpawnRock:
	ld [hli], a ; y
	ld a, d
	bit 3, c
	jr z, .got_x_coord
	ld a, e
.got_x_coord
	ld [hl], a ; x
	ret

SpawnRock_Bottom:
	ld a, $60
	jr SpawnRock

PlayFallingRockSFX:
	play_sfx SFX_TEMPLE_ROCK
	ret

; \1 = rock number
; \2 = scene object to use
; \3 = whether can be large or not
; \4 = x coordinate 1
; \5 = x coordinate 2
; \6 = max y coordinate
MACRO temple_rock_fall
	ld hl, wTempleRock\1
	ld a, [hli] ; action
	inc [hl] ; counter
	ld b, h
	ld c, l
	jumptable

	dw StubTempleRockFunc
	dw .Spawn
	dw .Update
	dw .Reset

.Spawn:
	ldh a, [rDIV]
	ld c, a
	ld hl, \2
	lb de, \4, \5
	call SpawnRock_Top
	ld a, [wTempleRock\1Size]
	ld hl, \2State
IF (\3) == TRUE
	call SetTempleRockSize_WithLarge
ELSE
	call SetTempleRockSize_WithoutLarge
ENDC
.Next:
	ld hl, wTempleRock\1Counter
	xor a
	ld [hld], a
	inc [hl] ; action
	ret

.Update:
	call GetRockYVel
	ld hl, \2YCoord
	add [hl]
	ld [hl], a
	cp \6
	ret c
	xor a
	ld [\2State], a

	ld c, %111111
	ld a, [wTempleRock\1Size]
	cp TEMPLE_ROCK_SIZE_LARGE
	jr nz, .not_large
	ld c, %11111
.not_large
	ldh a, [rDIV]
	and c
	ld [wTempleRock\1RespawnTime], a
	call PlayFallingRockSFX
	jr .Next

.Reset:
	ld hl, wTempleRock\1RespawnTime
	jp WaitTempleRockRespawn
ENDM

HandleTempleRock1Fall:
	temple_rock_fall 1, wSceneObj12, TRUE,   32,  48,  96
HandleTempleRock3Fall:
	temple_rock_fall 3, wSceneObj14, FALSE,  40,  56,  96
HandleTempleRock5Fall:
	temple_rock_fall 5, wSceneObj1,  FALSE,  16,  64, 160
HandleTempleRock2Fall:
	temple_rock_fall 2, wSceneObj13, TRUE,  112, 128,  96
HandleTempleRock4Fall:
	temple_rock_fall 4, wSceneObj15, FALSE, 104, 120,  96
HandleTempleRock6Fall:
	temple_rock_fall 6, wSceneObj2,  FALSE,  96, 144, 160

GetRockYVel:
	ld a, [bc]
	cp $2c
	jr c, .no_cap
	ld a, $28
	ld [bc], a
.no_cap
	ld e, a
	ld d, $00
	ld hl, .y_vel_table
	add hl, de
	ld a, [hl]
	ret

.y_vel_table
	db $01, $00, $01, $00, $01, $00, $01, $00
	db $01, $01, $01, $01, $01, $01, $01, $01
	db $02, $01, $02, $01, $02, $01, $02, $01
	db $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02
	db $03, $03, $03, $03

; \1 = rock number
; \2 = scene object to use
; \3 = whether a fast bounce or not
; \4 = which direction to go
; \5 = x coordinate 1
; \6 = x coordinate 2
MACRO temple_rock_bounce
	ld a, [wTempleRock\1Action]
	jumptable

	dw StubTempleRockFunc
	dw .Spawn
	dw .Update
	dw .Reset

.Spawn:
	ldh a, [rDIV]
	ld c, a
	ld hl, \2
	lb de, \5, \6
	call SpawnRock_Bottom
	ld a, [wTempleRock\1Size]
	ld hl, \2State
	call SetTempleRockSize_WithoutLarge
	call PlayFallingRockSFX
.Next:
	ld hl, wTempleRock\1Counter
	xor a
	ld [hld], a
	inc [hl]
	ret

.Update:
	IF (\3) == TRUE
		IF (\4) == DIRECTION_LEFT
			REPT 2
				ld hl, \2
				call BounceTempleRockLeft
				jr z, .Next
			ENDR
		ELSE ; (\4) == DIRECTION_RIGHT
			REPT 2
				ld hl, \2
				call BounceTempleRockRight
				jr z, .Next
			ENDR
		ENDC
		ret
	ELSE ; (\3) == FALSE
		ld de, NOWPrologueParticleArc1
		ld hl, \2

		IF (\4) == DIRECTION_LEFT
			call ApplyOWMovement
		ELSE ; (\4) == DIRECTION_RIGHT
			call ApplyOWMovement_Mirrored
		ENDC

		ret nz
		jr .Next
	ENDC

.Reset:
	ld a, [wTempleRock\1Size]
	and a
	jr z, .set_action
	ld a, $1 ; spawn
.set_action
	ld [wTempleRock\1Action], a
	xor a
	ld [\2State], a
	ret
ENDM

HandleTempleRock7Bounce:
	temple_rock_bounce  7, wSceneObj8,  FALSE, DIRECTION_LEFT,   32,  40
HandleTempleRock8Bounce:
	temple_rock_bounce  8, wSceneObj9,  FALSE, DIRECTION_RIGHT, 120, 128
HandleTempleRock9Bounce:
	temple_rock_bounce  9, wSceneObj10, TRUE,  DIRECTION_LEFT,   24,  32
HandleTempleRock10Bounce:
	temple_rock_bounce 10, wSceneObj11, TRUE,  DIRECTION_RIGHT, 128, 136

BounceTempleRockRight:
	ld de, NOWPrologueParticleArc2
	jp ApplyOWMovement_Mirrored

BounceTempleRockLeft:
	ld de, NOWPrologueParticleArc2
	jp ApplyOWMovement

UpdateTransformationSparkles:
	call .UpdateLight
	call .UpdateSparkle1
	call .UpdateSparkle2
	call .UpdateSparkle3
	call .UpdateSparkle4
	ret

.UpdateLight:
	ld hl, wSceneAuxStep
	ld a, [hli]
	inc [hl]
	jumptable
	dw .LightIdle
	dw .SpawnLight
	dw .LowerLight

.LightIdle:
	xor a
	ld [wSceneAuxStepCounter], a
	ret

.SpawnLight:
	ld hl, wSceneObj1YCoord
	ld a, $18
	ld [hli], a
	ld a, [wSceneObj9XCoord]
	ld [hl], a
	ld a, $16
	ld hl, wSceneObj1State
	call SetSceneObjState
	ld hl, wSceneAuxStepCounter
	xor a
	ld [hld], a
	inc [hl]
	ret

.LowerLight:
	ld a, [wSceneAuxStepCounter]
	and $03
	ret nz
	ld hl, wSceneObj1YCoord
	inc [hl]
	ld a, [hl]
	cp $58
	ret nz
	xor a
	ld [wSceneObj1State], a
	ld [wSceneAuxStep], a
	ret

.UpdateSparkle1:
	ld hl, wTempleMusicBox1
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .Sparkle1_WaitLight
	dw .Sparkle1_Spawn
	dw .Sparkle1_Rise

.Sparkle1_WaitLight:
	ld a, [wSceneObj1State]
	and a
	ret z
.asm_1584ed
	ld hl, wTempleMusicBox1Counter
	xor a
	ld [hld], a
	inc [hl]
	ret

.Sparkle1_Spawn:
	ld hl, wSceneObj5
	ld a, [wSceneObj1YCoord]
	sub $08
	ld [hli], a
	ld a, [wSceneObj1XCoord]
	sub $03
	ld [hl], a
	ld a, $15
	ld hl, wSceneObj5State
	call SetSceneObjState
	jr .asm_1584ed

.Sparkle1_Rise:
	call .get_rise_offset_1
	jr z, .asm_158521
	ld hl, wSceneObj5
	add [hl]
	ld [hl], a
	ld a, [bc]
	cp $03
	ret nz
	ld a, $14
	ld [wSceneObj5State], a
	ret
.asm_158521
	xor a
	ld [wSceneObj5State], a
	ld [wTempleMusicBox1], a
	ret

.UpdateSparkle2:
	ld hl, wPlanePart2Counter
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .Sparkle2_WaitLight
	dw .Sparkle2_Wait10
	dw .Sparkle2_Spawn
	dw .Sparkle2_Rise
	dw .Sparkle2_Repeat

.Sparkle2_WaitLight:
	ld a, [wSceneObj1State]
	and a
	ret z
.asm_158540
	ld hl, wTempleMusicBox3
	xor a
	ld [hld], a
	inc [hl]
	ret

.Sparkle2_Wait10:
	ld a, [bc]
	cp $0a
	ret c
	jr .asm_158540

.Sparkle2_Spawn:
	ld hl, wSceneObj6
	ld a, [wSceneObj1YCoord]
	sub $08
	ld [hli], a
	ld a, [wSceneObj1XCoord]
	add $03
	ld [hl], a
	ld a, $15
	ld hl, wSceneObj6State
	call SetSceneObjState
	jr .asm_158540

.Sparkle2_Rise:
	call .get_rise_offset_1
	jr z, .asm_15857a
	ld hl, wSceneObj6
	add [hl]
	ld [hl], a
	ld a, [bc]
	cp $03
	ret nz
	ld a, $14
	ld [wSceneObj6State], a
	ret
.asm_15857a
	xor a
	ld [wSceneObj6State], a
	jr .asm_158540

.Sparkle2_Repeat:
	ld a, [wSceneObj1State]
	and a
	jr z, .asm_158588
	ld a, $02
.asm_158588
	ld [wPlanePart2Counter], a
	ret

.UpdateSparkle3:
	ld hl, wTempleMusicBox4
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .Sparkle3_WaitLight
	dw .Sparkle3_Spawn
	dw .Sparkle3_Rise

.Sparkle3_WaitLight:
	ld a, [wSceneObj1State]
	and a
	ret z
.asm_15859f
	ld hl, wTempleMusicBox4Counter
	xor a
	ld [hld], a
	inc [hl]
	ret

.Sparkle3_Spawn:
	ld hl, wSceneObj7
	ld a, [wSceneObj1YCoord]
	sub $06
	ld [hli], a
	ld a, [wSceneObj1XCoord]
	sub $04
	ld [hl], a
	ld a, $15
	ld hl, wSceneObj7State
	call SetSceneObjState
	jr .asm_15859f

.Sparkle3_Rise:
	call .get_rise_offset_2
	jr z, .asm_1585d9
	ld hl, wSceneObj7
	add [hl]
	ld [hli], a
	ld a, [bc]
	and $01
	jr z, .asm_1585cf
	dec [hl]
.asm_1585cf
	ld a, [bc]
	cp $03
	ret nz
	ld a, $14
	ld [wSceneObj7State], a
	ret
.asm_1585d9
	xor a
	ld [wSceneObj7State], a
	ld [wTempleMusicBox4], a
	ret

.UpdateSparkle4:
	ld hl, wTempleMusicBox5Counter
	ld a, [hli]
	inc [hl]
	ld b, h
	ld c, l
	jumptable
	dw .Sparkle4_WaitLight
	dw .Sparkle4_Wait8
	dw .Sparkle4_Spawn
	dw .Sparkle4_Rise
	dw .Sparkle4_Repeat

.Sparkle4_WaitLight:
	ld a, [wSceneObj1State]
	and a
	ret z
.asm_1585f8
	ld hl, wPalFade2Colour3GreenUnk1
	xor a
	ld [hld], a
	inc [hl]
	ret

.Sparkle4_Wait8:
	ld a, [bc]
	cp $08
	ret c
	jr .asm_1585f8

.Sparkle4_Spawn:
	ld hl, wSceneObj8
	ld a, [wSceneObj1YCoord]
	sub $10
	ld [hli], a
	ld a, [wSceneObj1XCoord]
	add $06
	ld [hl], a
	ld a, $15
	ld hl, wSceneObj8State
	call SetSceneObjState
	jr .asm_1585f8

.Sparkle4_Rise:
	call .get_rise_offset_2
	jr z, .asm_158638
	ld hl, wSceneObj8
	add [hl]
	ld [hli], a
	ld a, [bc]
	and $01
	jr z, .asm_15862e
	inc [hl]
.asm_15862e
	ld a, [bc]
	cp $03
	ret nz
	ld a, $14
	ld [wSceneObj8State], a
	ret
.asm_158638
	xor a
	ld [wSceneObj8State], a
	jr .asm_1585f8

.Sparkle4_Repeat:
	ld a, [wSceneObj1State]
	and a
	jr z, .asm_158646
	ld a, $02
.asm_158646
	ld [wTempleMusicBox5Counter], a
	ret

.get_rise_offset_1:
	ld hl, .data_1
	ld a, [bc]
	ld e, a
	ld d, $00
	ld hl, .data_1 ; redundant
	add hl, de
	ld a, [hl]
	cp $80
	ret

.data_1
	db -1, -1, -1, -1, -2, -1, -2, -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, $80

.get_rise_offset_2:
	ld hl, .data_2
	ld a, [bc]
	ld e, a
	ld d, $00
	ld hl, .data_2 ; redundant
	add hl, de
	ld a, [hl]
	cp $80
	ret

.data_2
	db -1, -1, -1, -1, -2, -1, -2, -1, -2, -2, -2, -2, -2, -2, -2, -2, $80

UpdateNOWPrologueParticles:
	call .UpdateObj2
	call .UpdateObj3
	call .UpdateObj5
	call .UpdateObj8
	call .UpdateObj9
	call .UpdateObj10
	ret

.UpdateObj2:
	ld a, [w2d150]
	jumptable
	dw .Obj2_None
	dw .Obj2_PlaceUpLeft
	dw .Obj2_Arc1
	dw .Obj2_PlaceCenter
	dw .Obj2_Arc2
	dw .Obj2_PlaceDownLeft
	dw .Obj2_Arc3
	dw .Obj2_Loop

.Obj2_None:
	ret

.Obj2_PlaceCenter:
	ld hl, wSceneObj2
	call .place_center
.asm_1586bc
	ld hl, w2d150
	inc [hl]
	ret

.Obj2_PlaceUpLeft:
	ld hl, wSceneObj2
	call .place_up_left
	jr .asm_1586bc

.Obj2_PlaceDownLeft:
	ld hl, wSceneObj2
	call .place_down_left
	jr .asm_1586bc

.Obj2_Arc1:
	ld de, NOWPrologueParticleArc1
.asm_1586d4
	ld hl, wSceneObj2
	call ApplyOWMovement
	ret nz
	jr .asm_1586bc

.Obj2_Arc2:
	ld de, NOWPrologueParticleArc2
	jr .asm_1586d4

.Obj2_Arc3:
	ld de, NOWPrologueParticleArc3
	jr .asm_1586d4

.Obj2_Loop:
	ld a, $01
	ld [w2d150], a
	ret

.UpdateObj5:
	ld a, [wd152]
	jumptable
	dw .Obj5_None
	dw .Obj5_PlaceCenter
	dw .Obj5_Arc2
	dw .Obj5_PlaceDownLeft
	dw .Obj5_Arc3
	dw .Obj5_PlaceUpLeft
	dw .Obj5_Arc1
	dw .Obj5_Loop

.Obj5_None:
	ret

.Obj5_PlaceCenter:
	ld hl, wSceneObj5
	call .place_center
.asm_158708
	ld hl, wd152
	inc [hl]
	ret

.Obj5_PlaceUpLeft:
	ld hl, wSceneObj5
	call .place_up_left
	jr .asm_158708

.Obj5_PlaceDownLeft:
	ld hl, wSceneObj5
	call .place_down_left
	jr .asm_158708

.Obj5_Arc1:
	ld de, NOWPrologueParticleArc1
.asm_158720
	ld hl, wSceneObj5
	call ApplyOWMovement
	ret nz
	jr .asm_158708

.Obj5_Arc2:
	ld de, NOWPrologueParticleArc2
	jr .asm_158720

.Obj5_Arc3:
	ld de, NOWPrologueParticleArc3
	jr .asm_158720

.Obj5_Loop:
	ld a, $01
	ld [wd152], a
	ret

.UpdateObj9:
	ld a, [wd154]
	jumptable
	dw .Obj9_None
	dw .Obj9_PlaceDownLeft
	dw .Obj9_Arc3
	dw .Obj9_PlaceUpLeft
	dw .Obj9_Arc1
	dw .Obj9_PlaceCenter
	dw .Obj9_Arc2
	dw .Obj9_Loop

.Obj9_None:
	ret

.Obj9_PlaceCenter:
	ld hl, wSceneObj9
	call .place_center
.asm_158754
	ld hl, wd154
	inc [hl]
	ret

.Obj9_PlaceUpLeft:
	ld hl, wSceneObj9
	call .place_up_left
	jr .asm_158754

.Obj9_PlaceDownLeft:
	ld hl, wSceneObj9
	call .place_down_left
	jr .asm_158754

.Obj9_Arc1:
	ld de, NOWPrologueParticleArc1
.asm_15876c
	ld hl, wSceneObj9
	call ApplyOWMovement
	ret nz
	jr .asm_158754

.Obj9_Arc2:
	ld de, NOWPrologueParticleArc2
	jr .asm_15876c

.Obj9_Arc3:
	ld de, NOWPrologueParticleArc3
	jr .asm_15876c

.Obj9_Loop:
	ld a, $01
	ld [wd154], a
	ret

.UpdateObj3:
	ld a, [w2d151]
	jumptable
	dw .Obj3_None
	dw .Obj3_PlaceUpRight
	dw .Obj3_Arc1
	dw .Obj3_PlaceCenter
	dw .Obj3_Arc2
	dw .Obj3_PlaceDownRight
	dw .Obj3_Arc3
	dw .Obj3_Loop

.Obj3_None:
	ret

.Obj3_PlaceCenter:
	ld hl, wSceneObj3
	call .place_center
.asm_1587a0
	ld hl, w2d151
	inc [hl]
	ret

.Obj3_PlaceUpRight:
	ld hl, wSceneObj3
	call .place_up_right
	jr .asm_1587a0

.Obj3_PlaceDownRight:
	ld hl, wSceneObj3
	call .place_down_right
	jr .asm_1587a0

.Obj3_Arc1:
	ld de, NOWPrologueParticleArc1
.asm_1587b8
	ld hl, wSceneObj3
	call ApplyOWMovement_Mirrored
	ret nz
	jr .asm_1587a0

.Obj3_Arc2:
	ld de, NOWPrologueParticleArc2
	jr .asm_1587b8

.Obj3_Arc3:
	ld de, NOWPrologueParticleArc3
	jr .asm_1587b8

.Obj3_Loop:
	ld a, $01
	ld [w2d151], a
	ret

.UpdateObj8:
	ld a, [wd153]
	jumptable
	dw .Obj8_None
	dw .Obj8_PlaceCenter
	dw .Obj8_Arc2
	dw .Obj8_PlaceDownRight
	dw .Obj8_Arc3
	dw .Obj8_PlaceUpRight
	dw .Obj8_Arc1
	dw .Obj8_Loop

.Obj8_None:
	ret

.Obj8_PlaceCenter:
	ld hl, wSceneObj8
	call .place_center
.asm_1587ec
	ld hl, wd153
	inc [hl]
	ret

.Obj8_PlaceUpRight:
	ld hl, wSceneObj8
	call .place_up_right
	jr .asm_1587ec

.Obj8_PlaceDownRight:
	ld hl, wSceneObj8
	call .place_down_right
	jr .asm_1587ec

.Obj8_Arc1:
	ld de, NOWPrologueParticleArc1
.asm_158804
	ld hl, wSceneObj8
	call ApplyOWMovement_Mirrored
	ret nz
	jr .asm_1587ec

.Obj8_Arc2:
	ld de, NOWPrologueParticleArc2
	jr .asm_158804

.Obj8_Arc3:
	ld de, NOWPrologueParticleArc3
	jr .asm_158804

.Obj8_Loop:
	ld a, $01
	ld [wd153], a
	ret

.UpdateObj10:
	ld a, [wd155]
	jumptable
	dw .Obj10_None
	dw .Obj10_PlaceDownRight
	dw .Obj10_Arc3
	dw .Obj10_PlaceCenter
	dw .Obj10_Arc2
	dw .Obj10_PlaceUpRight
	dw .Obj10_Arc1
	dw .Obj10_Loop

.Obj10_None:
	ret

.Obj10_PlaceCenter:
	ld hl, wSceneObj10
	call .place_center
.asm_158838
	ld hl, wd155
	inc [hl]
	ret

.Obj10_PlaceUpRight:
	ld hl, wSceneObj10
	call .place_up_right
	jr .asm_158838

.Obj10_PlaceDownRight:
	ld hl, wSceneObj10
	call .place_down_right
	jr .asm_158838

.Obj10_Arc1:
	ld de, NOWPrologueParticleArc1
.asm_158850
	ld hl, wSceneObj10
	call ApplyOWMovement_Mirrored
	ret nz
	jr .asm_158838

.Obj10_Arc2:
	ld de, NOWPrologueParticleArc2
	jr .asm_158850

.Obj10_Arc3:
	ld de, NOWPrologueParticleArc3
	jr .asm_158850

.Obj10_Loop:
	ld a, $01
	ld [wd155], a
	ret

.place_center:
	ld a, $30
	ld [hli], a ; y
	ld a, $50
.asm_15886e
	ld [hli], a ; x
	set 2, l
	ldh a, [rDIV]
	and $01
	ld b, $29
	add b
	jp SetSceneObjState

.place_up_left:
	ld a, $2e
	ld [hli], a ; y
	ld a, $4e
	jr .asm_15886e

.place_up_right:
	ld a, $2e
	ld [hli], a ; y
	ld a, $52
	jr .asm_15886e

.place_down_left:
	ld a, $31
	ld [hli], a ; y
	ld a, $4f
	jr .asm_15886e

.place_down_right:
	ld a, $31
	ld [hli], a ; y
	ld a, $51
	jr .asm_15886e

NOWPrologueParticleArc1:
	db  0,  0
	db -2,  0
	db -2, -1
	db -1,  0
	db -2, -1
	db -2, -1
	db -1, -1
	db -2, -1
	db -1, -1
	db -2, -1
	db -1, -1
	db -2, -2
	db -1, -1
	db -1, -1
	db -1, -2
	db -2, -1
	db -1, -2
	db -1, -1
	db -1, -2
	db -1, -1
	db -2, -2
	db -1, -2
	db -1, -2
	db -1, -1
	db -1, -2
	db -1, -2
	db  0, -2
	db -1, -2
	db -1, -2
	db  0, -2
	db -1, -2
	db  0, -2
	db -1, -2
	db  0, -2
	db  0, -2
	db $80

NOWPrologueParticleArc2:
    db  0,  0
	db -1,  0
	db -2,  0
	db -1,  0
	db -2, -1
	db -1,  0
	db -2,  0
	db -1,  0
	db -1,  0
	db -2, -1
	db -1,  0
	db -2,  0
	db -1, -1
	db -1,  0
	db -2,  0
	db -1,  0
	db -2, -1
	db -1,  0
	db -1,  0
	db -1,  0
	db -1, -1
	db -1,  0
	db -1,  0
	db  0,  0
	db -1, -1
	db -1,  0
	db -1,  0
	db -1,  0
	db -1, -1
	db -1,  0
	db -1,  0
	db -1, -1
	db  0,  0
	db -1,  0
	db -1, -1
	db $80

NOWPrologueParticleArc3:
	db  0,  0
	db -1,  0
	db -2, -1
	db -1, -1
	db -2,  0
	db -1, -1
	db -2, -1
	db -1,  0
	db -1, -1
	db -2, -1
	db -1, -1
	db -1, -1
	db -2,  0
	db -1, -1
	db -1, -1
	db -2, -1
	db -1, -1
	db -1, -1
	db -1, -1
	db -1, -1
	db -1,  0
	db -1, -1
	db -1, -1
	db -1, -1
	db -1, -1
	db -1, -1
	db -1, -1
	db  0, -1
	db -1,  0
	db -1, -1
	db -1, -1
	db  0, -2
	db -1, -1
	db -1, -1
	db  0, -1
	db $80

_InitBestTimeList:
	call DisableLCD
	call FillBGMap0_With7f
	call ClearVirtualOAM

	play_music2 MUSIC_TREASURE_COLLECTION

	xor a
	ldh [rSCX], a
	ld [wSCX], a
	ld a, [wObj1SubState]
	rra
	and a
	jr z, .asm_158990
	ld a, $70
.asm_158990
	ldh [rSCY], a
	ld [wSCY], a

	ld a, $02
	ldh [rWBK], a
	call .VBlank_BestTimeList
	call .clear_ram

	ld hl, BestTimeListPals
	call LoadPalsToTempPals1

	decompress_tiles0 BestTimeListGfx, v0Tiles1, $20
	decompress_attrmap BestTimeListAttrmap, v1BGMap0
	decompress_tilemap BestTimeListTilemap, v0BGMap0

	call PrintBestTimes
	ld a, LCDC_BG_ON | LCDC_OBJ_ON | LCDC_ON
	ldh [rLCDC], a
	ld hl, wSubState
	inc [hl]
	ret

.clear_ram:
	ld hl, wCollectionRow
	ld bc, $800
	xor a
	call WriteAToHL_BCTimes
	ret

.VBlank_BestTimeList:
	ld hl, .func
	ld de, wVBlankFunc
	ld b, .func_end - .func
	call CopyHLToDE
	ret

.func
	ld a, $02
	ldh [rWBK], a
	ld a, [wSCY]
	ldh [rSCY], a
	ld a, [wSCX]
	ldh [rSCX], a
	xor a
	ldh [rVBK], a
	ld a, HIGH(wVirtualOAM)
	jp hTransferVirtualOAM
.func_end

_BestTimeList:
	ld a, [wCollectionRow]
	and a
	jr nz, .asm_158a76
	ld hl, wSCY
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr nz, .d_up
	bit B_PAD_DOWN, a
	jr nz, .d_down

	; no input
	ld hl, wCollectionCol
	inc [hl]
	ld a, [hl]
	and a
	jr nz, .asm_158a5a
	ld hl, wCollectionRow
	inc [hl]
	xor a
	ld [wColourFadeDiff], a
.asm_158a5a
	ld a, [wJoypadPressed]
	and PAD_B | PAD_START
	ret z
	ld a, $08
	ld [wSubState], a
	ret
.d_up
	ld a, [hl]
	and a
	ret z
	dec [hl]
.asm_158a6a
	xor a
	ld [wCollectionCol], a
	ret
.d_down
	ld a, [hl]
	cp $70
	ret z
	inc [hl]
	jr .asm_158a6a
.asm_158a76
	call .StopAutoScrollOnInput
	ret c
	ld a, [wColourFadeDiff]
	and a
	jr z, .asm_158a8c
	dec a
	jr z, .asm_158a9f
	dec a
	jr z, .asm_158aa9
	dec a
	jr z, .asm_158ab2
	debug_nop

.asm_158a8c
	ld hl, wSCY
	ld a, [hl]
	cp $70
	jr nc, .asm_158a96
	inc [hl]
	ret
.asm_158a96
	xor a
	ld [wCollectionLinkStateCounter], a
	ld hl, wColourFadeDiff
	inc [hl]
	ret

.asm_158a9f
	ld hl, wCollectionLinkStateCounter
	inc [hl]
	ld a, [hl]
	cp $b4
	ret c
	jr .asm_158a96
.asm_158aa9
	ld hl, wSCY
	ld a, [hl]
	and a
	jr z, .asm_158a96
	dec [hl]
	ret

.asm_158ab2
	ld hl, wCollectionLinkStateCounter
	inc [hl]
	ld a, [hl]
	cp $b4
	ret c
	xor a
	ld [wCollectionLinkStateCounter], a
	ld [wColourFadeDiff], a
	ret

.StopAutoScrollOnInput:
	ld a, [wJoypadPressed]
	and PAD_A | PAD_B | PAD_START | PAD_UP | PAD_DOWN
	ret z
	xor a
	ld [wCollectionRow], a
	scf
	ret

PrintBestTimes:
	xor a ; LEVEL_OUT_OF_THE_WOODS
	ld [w2dfff], a
.loop_levels
	call .PrintLevelTime
	ld hl, w2dfff
	inc [hl]
	ld a, NUM_LEVELS - 1
	cp [hl]
	ret c
	jr .loop_levels

.PrintLevelTime:
	ld a, [w2dfff]
	ld hl, wLevelTimeAttackScores
	add a
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld d, a    ; minutes
	ld e, [hl] ; seconds
	ld b, 2
	ld hl, wBestTimeDigitTiles
.loop_get_tiles
	and $f0
	swap a
	add a
	add $a0
	ld [hli], a
	ld a, d
	and $0f
	add a
	add $a0 ; 0 digit
	ld [hli], a
	dec b
	jr z, .write_tiles
	ld a, $b6 ; colon
	ld [hli], a
	ld d, e
	ld a, e
	jr .loop_get_tiles

.write_tiles
	ld a, [w2dfff]
	ld hl, .bg_map_address_table
	call GetPointerFromTableDE
	ld b, $00
.loop_write_bg_map
	ld c, 5 ; num tiles wide
	ld hl, wBestTimeDigitTiles
.loop_write_tiles
	ld a, [hli]
	add b
	ld [de], a
	inc e
	dec c
	jr nz, .loop_write_tiles
	inc b
	ld a, b
	cp 2
	ret z
	ld a, TILEMAP_WIDTH - $5
	add e
	ld e, a
	ld a, d
	adc $00
	ld d, a
	jr .loop_write_bg_map

.bg_map_address_table
	table_width 2
	dwcoord  4,  3 ; LEVEL_OUT_OF_THE_WOODS
	dwcoord  4,  5 ; LEVEL_THE_PEACEFUL_VILLAGE
	dwcoord  4,  7 ; LEVEL_THE_VAST_PLAIN
	dwcoord  4,  9 ; LEVEL_BANK_OF_THE_WILD_RIVER
	dwcoord  4, 11 ; LEVEL_THE_TIDAL_COAST
	dwcoord  4, 13 ; LEVEL_SEA_TURTLE_ROCKS
	dwcoord 14,  3 ; LEVEL_DESERT_RUINS
	dwcoord 14,  5 ; LEVEL_THE_VOLCANOS_BASE
	dwcoord 14,  7 ; LEVEL_THE_POOL_OF_RAIN
	dwcoord 14,  9 ; LEVEL_A_TOWN_IN_CHAOS
	dwcoord 14, 11 ; LEVEL_BENEATH_THE_WAVES
	dwcoord 14, 13 ; LEVEL_THE_WEST_CRATER
	dwcoord  4, 17 ; LEVEL_THE_GRASSLANDS
	dwcoord  4, 19 ; LEVEL_THE_BIG_BRIDGE
	dwcoord  4, 21 ; LEVEL_TOWER_OF_REVIVAL
	dwcoord  4, 23 ; LEVEL_THE_STEEP_CANYON
	dwcoord  4, 25 ; LEVEL_CAVE_OF_FLAMES
	dwcoord  4, 27 ; LEVEL_ABOVE_THE_CLOUDS
	dwcoord 14, 17 ; LEVEL_THE_STAGNANT_SWAMP
	dwcoord 14, 19 ; LEVEL_THE_FRIGID_SEA
	dwcoord 14, 21 ; LEVEL_CASTLE_OF_ILLUSIONS
	dwcoord 14, 23 ; LEVEL_THE_COLOSSAL_HOLE
	dwcoord 14, 25 ; LEVEL_THE_WARPED_VOID
	dwcoord 14, 27 ; LEVEL_THE_EAST_CRATER
	dwcoord 14, 29 ; LEVEL_FOREST_OF_FEAR
	assert_table_length NUM_LEVELS

BestTimeListPals:
	rgb 31, 31, 31
	rgb 31, 20,  0
	rgb 29,  0,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 31,  5
	rgb  0, 10, 25
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 31, 15
	rgb 29,  0,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 31, 31,  5
	rgb  0,  4, 14
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb 21, 21, 21
	rgb 10, 10, 10
	rgb  0,  0,  0
