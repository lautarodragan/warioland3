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
	jr c, .wario_close
	ld a, [wWarioXPos + 1]
	cp $40
	ret nc
.wario_close
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
	ld [w1d147], a
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
	jr z, .end_leap
	ld bc, MuddeeData_60d30
	jp ApplyObjYMovement
.end_leap
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
	jr nc, .no_interaction_change
	cp $0c
	jr nc, .bump_off_frames
	cp $09
	jr nc, .sting_front_left
	cp $06
	jr nc, .sting_up
	cp $03
	jr nc, .sting_front_right
	ld b, $48
	jr .set_interaction
.no_interaction_change
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	jr .check_hit
.bump_off_frames
	ld b, $0b
	jr .set_interaction
.sting_front_left
	res 7, [hl]
	jr .sting_front
.sting_up
	ld b, $47
	jr .set_interaction
.sting_front_right
	set 7, [hl]
.sting_front
	ld b, $46
.set_interaction
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or b
	ld [hl], a
.check_hit
	ld a, [w1d147]
	and a
	jr z, .dispatch
	cp $02
	jr z, .hurt
	jr .hit
.dispatch
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
	ld [w1d147], a
	ld a, [wCurObjInteractionType]
	cp OBJ_INTERACTION_BOTTOM_STING_SMASHABLE_TOP
	jr z, .hit_on_top
	cp OBJ_INTERACTION_TOP_STING_BUMP_OFF
	jr z, .hit_while_top_sting
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .hit_facing_right
	ld de, MuddeeFrameset_69d57
	jr .set_hit_frameset
.hit_facing_right
	ld de, MuddeeFrameset_69d52
	jr .set_hit_frameset
.hit_on_top
	ld de, MuddeeFrameset_69d48
	jr .set_hit_frameset
.hit_while_top_sting
	ld de, MuddeeFrameset_69d4d
.set_hit_frameset
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
	jr z, .fall_to_water
	cp $28
	play_sfx z, SFX_MUDDEE_HURT
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	and $0f
	cp $02
	ret nz
	jr .defeated
.fall_to_water
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
	ld [w1d147], a
	ld de, MuddeeFrameset_69dc0
	call SetObjectFramesetPtr
	ld a, $2c
	ld [hli], a
	ld a, $04
	ld [hl], a
	play_sfx SFX_SMALL_SPLASH
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
	jr nc, .defeated_face_right
	res 7, [hl]
	jr .defeated_got_direction
.defeated_face_right
	set 7, [hl]
.defeated_got_direction
	dec l
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld hl, wCurObjUnk02
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
	jr z, .swim_up
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69d04
	jp SetObjectFramesetPtr
.swim_up
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
	jr nz, .end_swim_up
	call .CompareYWithWarioRow
	jr z, .end_swim_up
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectUp
	jp MoveObjectUp_Slow
.end_swim_up
	ld hl, wCurObjXPos
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .end_up_swim_left
	jr nz, .end_up_swim_right
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .end_up_swim_left
.end_up_swim_right
	ld a, $03
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d2f
	ld c, $0e
	ld b, $7d
	jp .SetFramesetAndDurations
.end_up_swim_left
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
	jr z, .swim_down
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69cf2
	jp SetObjectFramesetPtr
.swim_down
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
	jr nz, .end_swim_down
	call .CompareYWithWarioRow
	jr z, .end_swim_down
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectDown
	jp MoveObjectDown_Slow
.end_swim_down
	ld hl, wCurObjXPos
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .end_down_swim_left
	jr nz, .end_down_swim_right
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .end_down_swim_left
.end_down_swim_right
	ld a, $03
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d16
	ld c, $02
	ld b, $7d
	jp .SetFramesetAndDurations
.end_down_swim_left
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
	jr z, .swim_left
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69d0d
	jp SetObjectFramesetPtr
.swim_left
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
	jr nz, .end_swim_left
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectLeft
	jp MoveObjectLeft_Slow
.end_swim_left
	call .CompareYWithWario
	jr c, .end_left_swim_down
	xor a
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d2f
	ld c, $08
	ld b, $7d
	jp .SetFramesetAndDurations
.end_left_swim_down
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
	jr z, .swim_right
	dec [hl]
	ret nz
	ld de, MuddeeFrameset_69cfb
	jp SetObjectFramesetPtr
.swim_right
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
	jr nz, .end_swim_right
	call .PlaySwimSFX
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jp nz, MoveObjectRight
	jp MoveObjectRight_Slow
.end_swim_right
	call .CompareYWithWario
	jr c, .end_right_swim_down
	xor a
	ld [wCurObjVar1], a
	ld de, MuddeeFrameset_69d16
	ld c, $08
	ld b, $7d
	jp .SetFramesetAndDurations
.end_right_swim_down
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
	jr c, .move_left_under
	jr nz, .move_right_under
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .move_left_under
	jr z, .under_wario
.move_right_under
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
.move_left_under
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
.under_wario
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
	jr z, .leap_done
	ld bc, MuddeeData_60d30
	jp ApplyObjYMovement
.leap_done
	ld a, [hl]
	and $0f
	cp $03
	jr z, .start_zigzag
	xor a
	ld [wCurObjVar1], a
	ret
.start_zigzag
	ld l, OBJ_STATE_DURATION
	xor a
	ld [hli], a
	ld a, $08
	ld [hl], a
.aim_zigzag
	ld l, OBJ_X_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .aim_left
	jr nz, .aim_right
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .aim_left
.aim_right
	ld de, MuddeeFrameset_69da7
	ld a, $01
	jr .set_aim
.aim_left
	ld de, MuddeeFrameset_69d8e
	xor a
.set_aim
	ld [wCurObjVar2], a
	xor a
	ld [wCurObjVar3], a
	call .CompareYWithWario
	ld l, OBJ_SUBSTATE
	jr c, .aim_down
	res 6, [hl]
	jp SetObjectFramesetPtr
.aim_down
	set 6, [hl]
	jp SetObjectFramesetPtr

.SwimZigZag:
	ld hl, wCurObjVar3
	ld a, [hl]
	inc a
	jr z, .zigzag_timer
	ld l, OBJ_FRAME_DURATION
	ld a, [hli]
	and a
	jr nz, .zigzag_timer
	ld a, [hl]
	cp $18
	jr nz, .zigzag_timer
	ld l, OBJ_VAR_3
	inc [hl]
	ld a, [hl]
	cp $03
	jr nz, .zigzag_timer
	ld a, $ff
	ld [hl], a
	ld de, MuddeeFrameset_69cf2
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hl], a
	ret
.zigzag_timer
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .zigzag_move
	dec [hl]
	ret nz
	ld l, OBJ_VAR_3
	ld a, [hl]
	inc a
	ret nz
	ld [hl], a
	jr .aim_zigzag
.zigzag_move
	call .PlayBubbleSFX
	ld a, [wCurObjVar2]
	rra
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	jr c, .zigzag_move_right
	ld a, [hli]
	sub $18
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .zigzag_reverse_x
	call MoveObjectLeft_Slow
	jr .zigzag_vertical
.zigzag_move_right
	ld a, [hli]
	add $18
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .zigzag_reverse_x
	call MoveObjectRight_Slow
	jr .zigzag_vertical
.zigzag_reverse_x
	ld hl, wCurObjVar2
	ld a, [hl]
	xor $01
	ld [hl], a
	ld l, OBJ_STATE_DURATION
	ld a, $28
	ld [hl], a
.zigzag_vertical
	ld hl, wCurObjSubState
	bit 6, [hl]
	jr nz, .zigzag_move_down
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
	jr nz, .zigzag_reverse_y
	jp MoveObjectUp_Slow
.zigzag_move_down
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
	jr nz, .zigzag_reverse_y
	jp MoveObjectDown_Slow
.zigzag_reverse_y
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
	jr z, .wait_fall
	dec [hl]
	jr .fall
.wait_fall
	dec l
	ld a, [hl]
	and a
	jr z, .fall
	dec [hl]
	ret nz
	play_sfx SFX_BOSS_DEFEAT_FALL
	ret
.fall
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
	play_sfx SFX_MUDDEE_BUBBLE
	ret

.PlaySwimSFX:
	ld a, [wGlobalCounter]
	ld b, a
	ld a, [wCurObjSubState]
	and $0f
	cp $05
	jr nz, .not_slow
	ld a, b
	and $1f
	ret nz
	jr .play_sfx
.not_slow
	cp $04
	jr nz, .fast
	ld a, b
	and $0f
	ret nz
	jr .play_sfx
.fast
	ld a, b
	and $07
	ret nz
.play_sfx
	play_sfx SFX_MUDDEE_SWIM
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
	jr z, .hide
	res 4, [hl]
	ret
.hide
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
	jr z, .arrived
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
.arrived
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartAmbush)
	ld [hld], a
	ld a, LOW(.StartAmbush)
	ld [hld], a
	ld de, MuddeeFrameset_69d65
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	play_sfx SFX_BOSS_APPEAR
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
	jr z, .sink
	dec [hl]
	ret
.sink
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
	ld hl, wCurObjUnk02
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
	jr z, .rise
	dec [hl]
	ret nz
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ret
.rise
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
	jr nz, .blocked
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
.blocked
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
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp TURTLE1
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr c, .found_turtle1
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_turtle1
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
	play_sfx SFX_TURTLE_SWIM
	ret

MuddeePals_55e46:
	rgb 28, 28, 28
	rgb 31,  7,  6
	rgb 31, 31,  9
	rgb 10, 10, 10
