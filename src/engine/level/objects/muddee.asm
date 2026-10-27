MuddeeFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitForAmbush)
	ld [hld], a
	ld a, LOW(.WaitForAmbush)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $05
	ld [hl], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld a, $07
	ld [hl], a
	ld de, MuddeeFrameset_69d73
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld a, $70
	ld [wCurObjVar2], a
	call MoveObjectRightByVar2
	ld a, $04
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.WaitForAmbush:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call .Blink
	ld a, [wMuddeeAmbushState]
	dec a
	ret nz
	ld a, TRUE
	ld [wIsBossBattle], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Appear)
	ld [hld], a
	ld a, LOW(.Appear)
	ld [hld], a
	ld hl, MuddeePals_55e46
	ld de, wTempPals2 palette 6
	ld c, 6
	ld b, 1
	jp CopyAndApplyOBPals

.Appear:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call .Blink
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitForWarioNear)
	ld [hld], a
	ld a, LOW(.WaitForWarioNear)
	ld [hld], a
	ld de, MuddeeFrameset_69d85
	call SetObjectFramesetPtr
	xor a
	ld [wCurObjVar3], a
	ret

.WaitForWarioNear:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call .Blink
	ld a, [wWarioXPos + 0]
	cp $09
	jr c, .asm_556ab
	ld a, [wWarioXPos + 1]
	cp $40
	ret nc
.asm_556ab
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	sub b
	cp $48
	ret c
	cp $96
	ret nc
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Leap)
	ld [hld], a
	ld a, LOW(.Leap)
	ld [hld], a
	ld de, MuddeeFrameset_69cf2
	call SetObjectFramesetPtr
	xor a
	ld [wCurObjVar3], a
	ld l, OBJ_FLAGS
	res OBJFLAG_INVISIBLE_F, [hl]
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wJamanoSkullsInPlace], a
.spawn_stingers
	play_sfx SFX_0B2
	ld bc, ObjParams_MuddeeStinger1
	call CreateObjectFromCurObjPos
	ld bc, ObjParams_MuddeeStinger2
	jp CreateObjectFromCurObjPos

.Leap:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjVar3]
	cp $0e
	jr z, .asm_55702
	ld bc, MuddeeData_60d30
	jp ApplyObjYMovement
.asm_55702
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld a, $01
	ld [wCurObjVar1], a
	ret

.Main:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjSubState
	ld a, [wCurObjFrame]
	cp $10
	jr nc, .asm_55734
	cp $0c
	jr nc, .asm_5573b
	cp $09
	jr nc, .asm_5573f
	cp $06
	jr nc, .asm_55743
	cp $03
	jr nc, .asm_55747
	ld b, $48
	jr .asm_5574b
.asm_55734
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	jr .asm_55752
.asm_5573b
	ld b, $0b
	jr .asm_5574b
.asm_5573f
	res 7, [hl]
	jr .asm_55749
.asm_55743
	ld b, $47
	jr .asm_5574b
.asm_55747
	set 7, [hl]
.asm_55749
	ld b, $46
.asm_5574b
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or b
	ld [hl], a
.asm_55752
	ld a, [wJamanoSkullsInPlace]
	and a
	jr z, .asm_5575e
	cp $02
	jr z, .hurt
	jr .hit
.asm_5575e
	ld a, [wCurObjVar1]
	jumptable
	dw .SwimUp
	dw .SwimDown
	dw .SwimLeft
	dw .SwimRight
	dw .WaitThenSink
	dw .Sink
	dw .MoveUnderWario
	dw .LeapFromFloor
	dw .SwimZigZag

.hit
	play_sfx SFX_VANISH
	ld a, $02
	ld [wJamanoSkullsInPlace], a
	ld a, [wCurObjInteractionType]
	cp $48
	jr z, .asm_5579c
	cp $47
	jr z, .asm_557a1
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .asm_55797
	ld de, MuddeeFrameset_69d57
	jr .asm_557a4
.asm_55797
	ld de, MuddeeFrameset_69d52
	jr .asm_557a4
.asm_5579c
	ld de, MuddeeFrameset_69d48
	jr .asm_557a4
.asm_557a1
	ld de, MuddeeFrameset_69d4d
.asm_557a4
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	xor a
	ld [wCurObjVar3], a
	jp DecrementRemainingBossHits
.hurt
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .asm_557cf
	cp $28
	play_sfx z, SFX_0C0
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	and $0f
	cp $02
	ret nz
	jr .defeated
.asm_557cf
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .in_water
	ld bc, MuddeeData_60d40
	jp ApplyObjYMovement

.in_water
	xor a
	ld [wJamanoSkullsInPlace], a
	ld de, MuddeeFrameset_69dc0
	call SetObjectFramesetPtr
	ld a, $2c
	ld [hli], a
	ld a, $04
	ld [hl], a
	play_sfx SFX_083
	ret

.defeated
	ld de, MuddeeFrameset_69d6a
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ld a, $14
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatedFall)
	ld [hld], a
	ld a, LOW(.DefeatedFall)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $80
	ld [hl], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr nc, .asm_55832
	res 7, [hl]
	jr .asm_55834
.asm_55832
	set 7, [hl]
.asm_55834
	dec l
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld hl, wCurObjMapPtrHi
	ld e, $07
	farcall SetObjectMapEntryAndSpawn
	stop_music2
	ld a, 2
	ld [wMuddeeAmbushState], a
	ret

.SwimUp:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_55870
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69d04
	jp SetObjectFramesetPtr
.asm_55870
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $1c
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jr nz, .asm_5589e
	call .CompareYWithWarioRow
	jr z, .asm_5589e
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectUp
	jp MoveObjectUp_Slow
.asm_5589e
	ld hl, wCurObjXPos
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .asm_558c1
	jr nz, .asm_558b2
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .asm_558c1
.asm_558b2
	ld a, $03
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d2f
	ld c, $0e
	ld b, $7d
	jp .SetFramesetAndDurations
.asm_558c1
	ld a, $02
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d16
	ld c, $0e
	ld b, $7d
	jp .SetFramesetAndDurations

.SwimDown:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_558df
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69cf2
	jp SetObjectFramesetPtr
.asm_558df
	ld hl, wCurObjYPos
	ld a, [hli]
	add $30
	ldh [hYPosLo], a
	ld a, [hli]
	adc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .asm_55910
	call .CompareYWithWarioRow
	jr z, .asm_55910
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectDown
	jp MoveObjectDown_Slow
.asm_55910
	ld hl, wCurObjXPos
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .asm_55933
	jr nz, .asm_55924
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .asm_55933
.asm_55924
	ld a, $03
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d16
	ld c, $02
	ld b, $7d
	jp .SetFramesetAndDurations
.asm_55933
	ld a, $02
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d2f
	ld c, $02
	ld b, $7d
	jp .SetFramesetAndDurations

.SwimLeft:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_55951
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69d0d
	jp SetObjectFramesetPtr
.asm_55951
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	sub $18
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .asm_5597a
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectLeft
	jp MoveObjectLeft_Slow
.asm_5597a
	call .CompareYWithWario
	jr c, .asm_5598d
	xor a
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d2f
	ld c, $08
	ld b, $7d
	jp .SetFramesetAndDurations
.asm_5598d
	ld a, $01
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d16
	ld c, $14
	ld b, $7d
	jp .SetFramesetAndDurations

.SwimRight:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_559ab
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69cfb
	jp SetObjectFramesetPtr
.asm_559ab
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	add $18
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .asm_559d4
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectRight
	jp MoveObjectRight_Slow
.asm_559d4
	call .CompareYWithWario
	jr c, .asm_559e7
	xor a
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d16
	ld c, $08
	ld b, $7d
	jp .SetFramesetAndDurations
.asm_559e7
	ld a, $01
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d2f
	ld c, $14
	ld b, $7d
	jp .SetFramesetAndDurations

.WaitThenSink:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69d85
	call SetObjectFramesetPtr
	inc l
	ld a, $05
	ld [hli], a
	ld a, $08
	ld [hl], a
	jp MoveObjectDownByVar2

.Sink:
	ld hl, wCurObjYPos
	ld a, [hli]
	add $12
	ldh [hYPosLo], a
	ld a, [hli]
	adc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	jp z, MoveObjectDown
	ld a, $06
	ld [wCurObjVar1], a
	ret

.MoveUnderWario:
	ld hl, wCurObjXPos
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $40
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .asm_55a60
	jr nz, .asm_55a4e
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .asm_55a60
	jr z, .asm_55a72
.asm_55a4e
	ld a, [hli]
	add $08
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	jp MoveObjectRight_Slow
.asm_55a60
	ld a, [hli]
	sub $08
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	jp MoveObjectLeft_Slow
.asm_55a72
	ld de, MuddeeFrameset_69d04
	call SetObjectFramesetPtr
	inc l
	ld a, $07
	ld [hli], a
	inc l
	xor a
	ld [hl], a
	jp .spawn_stingers

.LeapFromFloor:
	ld hl, wCurObjVar3
	ld a, [hli]
	cp $0e
	jr z, .asm_55a90
	ld bc, MuddeeData_60d30
	jp ApplyObjYMovement
.asm_55a90
	ld a, [hl]
	and $0f
	cp $03
	jr z, .asm_55a9c
	xor a
	ld [wCurObjVar1], a
	ret
.asm_55a9c
	ld l, OBJ_STATE_DURATION
	xor a
	ld [hli], a
	ld a, $08
	ld [hl], a
.asm_55aa3
	ld l, OBJ_X_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .asm_55abd
	jr nz, .asm_55ab6
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .asm_55abd
.asm_55ab6
	ld de, MuddeeFrameset_69da7
	ld a, $01
	jr .asm_55ac1
.asm_55abd
	ld de, MuddeeFrameset_69d8e
	xor a
.asm_55ac1
	ld [wCurObjVar2], a
	xor a
	ld [wCurObjVar3], a
	call .CompareYWithWario
	ld l, OBJ_SUBSTATE
	jr c, .asm_55ad4
	res 6, [hl]
	jp SetObjectFramesetPtr
.asm_55ad4
	set 6, [hl]
	jp SetObjectFramesetPtr

.SwimZigZag:
	ld hl, wCurObjVar3
	ld a, [hl]
	inc a
	jr z, .asm_55b00
	ld l, OBJ_FRAME_DURATION
	ld a, [hli]
	and a
	jr nz, .asm_55b00
	ld a, [hl]
	cp $18
	jr nz, .asm_55b00
	ld l, OBJ_VAR_3
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, .asm_55b00
	ld a, $ff
	ld [hl], a
	ld de, MuddeeFrameset_69cf2
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hl], a
	ret
.asm_55b00
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .asm_55b10
	dec [hl]
	ret nz
	ld l, OBJ_VAR_3
	ld a, [hl]
	inc a
	ret nz
	ld [hl], a
	jr .asm_55aa3
.asm_55b10
	call .PlayBubbleSFX
	ld a, [wCurObjVar2]
	rra
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	jr c, .asm_55b37
	ld a, [hli]
	sub $18
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .asm_55b4c
	call MoveObjectLeft_Slow
	jr .asm_55b58
.asm_55b37
	ld a, [hli]
	add $18
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .asm_55b4c
	call MoveObjectRight_Slow
	jr .asm_55b58
.asm_55b4c
	ld hl, wCurObjVar2
	ld a, [hl]
	xor $01
	ld [hl], a
	ld l, OBJ_STATE_DURATION
	ld a, $28
	ld [hl], a
.asm_55b58
	ld hl, wCurObjSubState
	bit 6, [hl]
	jr nz, .asm_55b7b
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $1c
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jr nz, .asm_55b9a
	jp MoveObjectUp_Slow
.asm_55b7b
	ld hl, wCurObjYPos
	ld a, [hli]
	add $30
	ldh [hYPosLo], a
	ld a, [hli]
	adc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .asm_55b9a
	jp MoveObjectDown_Slow
.asm_55b9a
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_VDIR
	ld [hl], a
	ld a, $28
	ld [wCurObjStateDuration], a
	ret

.DefeatedFall:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .asm_55bb6
	dec [hl]
	jr .asm_55bc6
.asm_55bb6
	dec l
	ld a, [hl]
	and a
	jr z, .asm_55bc6
	dec [hl]
	ret nz
	play_sfx SFX_0A3
	ret
.asm_55bc6
	ld bc, AttackedYVel_Light
	call ApplyObjYMovement
	ld a, [wCurObjSubState]
	rlca
	jp nc, MoveObjectRight
	jp MoveObjectLeft

	; unreachable
	dec [hl]
	ret

.PlayBubbleSFX:
	ld a, [wGlobalCounter]
	and %1111
	ret nz
	play_sfx SFX_0C1
	ret

.PlaySwimSFX:
	ld a, [wGlobalCounter]
	ld b, a
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jr nz, .asm_55bfa
	ld a, b
	and $1f
	ret nz
	jr .asm_55c08
.asm_55bfa
	cp $04
	jr nz, .asm_55c04
	ld a, b
	and $0f
	ret nz
	jr .asm_55c08
.asm_55c04
	ld a, b
	and $07
	ret nz
.asm_55c08
	play_sfx SFX_085
	ret

.SetFramesetAndDurations:
	ld hl, wCurObjFramesetPtr
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	ret

.CompareYWithWario:
	ld a, [wWarioScreenYPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenYPos]
	add $2a
	cp b
	ret

.CompareYWithWarioRow:
	ld a, [wWarioScreenYPos]
	sub $10
	and $f8
	ld b, a
	ld a, [wCurObjScreenYPos]
	and $f8
	cp b
	ret

.Blink:
	ld hl, wCurObjFlags
	ld a, [wGlobalCounter]
	and %11
	jr z, .asm_55c47
	res 4, [hl]
	ret
.asm_55c47
	set 4, [hl]
	ret

Turtle1Func:
	xor a
	ld [wMuddeeAmbushState], a
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitForWario)
	ld [hld], a
	ld a, LOW(.WaitForWario)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0a
	ld [hld], a
	ld a, $f5
	ld [hld], a
	ld a, $04
	ld [hl], a
	ld de, MuddeeFrameset_69d5c
	call SetObjectFramesetPtr
	ld a, $a0
	ld [hli], a
	ld a, $10
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.WaitForWario:
	call SetOneWayPlatformAction
	ld hl, wCurObjFlags
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.CarryWario)
	ld [hld], a
	ld a, LOW(.CarryWario)
	ld [hld], a
	ret

.CarryWario:
	call SetOneWayPlatformAction
	call PlayTurtleSwimSFX
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_55cc3
	call MoveObjectRight
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	farcall CheckCarriedWarioRightCollision
	ld a, b
	and a
	ret nz
	ld b, $01
	jp MoveWarioRight
.asm_55cc3
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartAmbush)
	ld [hld], a
	ld a, LOW(.StartAmbush)
	ld [hld], a
	ld de, MuddeeFrameset_69d65
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	play_sfx SFX_0CA
	ret

.StartAmbush:
	call SetOneWayPlatformAction
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $28
	ld [hli], a
	ld a, $40
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Submerge)
	ld [hld], a
	ld a, LOW(.Submerge)
	ld [hld], a
	ld a, 1
	ld [wMuddeeAmbushState], a
	ret

.Submerge:
	call SetOneWayPlatformAction
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_55d05
	dec [hl]
	ret
.asm_55d05
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	inc l
	dec [hl]
	jp nz, MoveObjectDown
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitForMuddeeDefeat)
	ld [hld], a
	ld a, LOW(.WaitForMuddeeDefeat)
	ld [hld], a
	ret

.WaitForMuddeeDefeat:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wMuddeeAmbushState]
	cp 2
	ret nz
	ld de, MuddeeFrameset_69d5c
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld a, $40
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Resurface)
	ld [hld], a
	ld a, LOW(.Resurface)
	ld [hld], a
	ld hl, wCurObjMapPtrHi
	ld e, $06
	farcall SetObjectMapEntryAndSpawn
	ret

.Resurface:
	call SetOneWayPlatformAction
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_55d6a
	dec [hl]
	ret nz
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ret
.asm_55d6a
	inc l
	dec [hl]
	jp nz, MoveObjectUp
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(TurtleCommonFunc)
	ld [hld], a
	ld a, LOW(TurtleCommonFunc)
	ld [hld], a
	ld l, OBJ_FLAGS
	res 5, [hl]
	ret

TurtleCommonFunc:
	call SetOneWayPlatformAction
	ld hl, wCurObjFlags
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.CarryWario)
	ld [hld], a
	ld a, LOW(.CarryWario)
	ld [hld], a
	ret

.CarryWario:
	call SetOneWayPlatformAction
	call PlayTurtleSwimSFX
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	add $30
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .asm_55dd6
	call MoveObjectRight
	ld hl, wCurObjFlags
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	farcall CheckCarriedWarioRightCollision
	ld a, b
	and a
	ret nz
	ld b, $01
	jp MoveWarioRight
.asm_55dd6
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ret

.Idle:
	call SetOneWayPlatformAction
	ret

Turtle2Func:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(TurtleCommonFunc)
	ld [hld], a
	ld a, LOW(TurtleCommonFunc)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0a
	ld [hld], a
	ld a, $f5
	ld [hld], a
	ld a, $04
	ld [hl], a
	ld de, MuddeeFrameset_69d5c
	call SetObjectFramesetPtr
	ld a, $10
	ld [wCurObjVar2], a
	call MoveObjectUpByVar2

	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.asm_55e14
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp TURTLE1
	jr nz, .asm_55e25
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr c, .asm_55e2e
.asm_55e25
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .asm_55e14
.asm_55e2e
	xor a
	ld [wCurObjFlags], a
	ret

PlayTurtleSwimSFX:
	ld hl, wCurObjFrameDuration
	ld a, [hli]
	and a
	ret nz
	ld a, [hl]
	cp $04
	ret nz
	play_sfx SFX_084
	ret

MuddeePals_55e46:
	rgb 28, 28, 28
	rgb 31,  7,  6
	rgb 31, 31,  9
	rgb 10, 10, 10
