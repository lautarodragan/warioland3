ScowlerFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartFight)
	ld [hld], a
	ld a, LOW(.StartFight)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [hl]
	and $f0
	or $04
	ld [hld], a
	and $0f
	swap a
	add a
	add $48
	ld [hl], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $08
	ld [hld], a
	ld a, $f7
	ld [hld], a
	ld a, $f8
	ld [hl], a
	ld de, ScowlerFrameset_69a5f
	call SetObjectFramesetPtr
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wDollBoyActiveBarrels], a
	ld [w1d147], a
	ret

.StartFight:
	ld a, TRUE
	ld [wIsBossBattle], a
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld bc, ObjParams_ScrowlerTentacleRight
	call CreateObjectFromCurObjPos
	ld bc, ObjParams_ScrowlerTentacleLeft
	jp CreateObjectFromCurObjPos

.CatchWario:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	ld de, ScowlerFrameset_69b03
	call SetObjectFramesetPtr
	ld l, OBJ_Y_POS
	ld a, [hli]
	ld [wWarioYPos + 1], a
	ld a, [hli]
	ld [wWarioYPos + 0], a
	ld a, [hli]
	ld [wWarioXPos + 1], a
	ld a, [hl]
	ld [wWarioXPos + 0], a
	ret

.start_catch_wario
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.CatchWario)
	ld [hld], a
	ld a, LOW(.CatchWario)
	ld [hld], a
	ld a, $1e
	ld [wCurObjStateDuration], a
	ret

.activated
	ld a, $5a
	ld [hl], a
	play_sfx SFX_ELECTRIC_SHOCK
	stop_music2
	ret

.Main:
	call UpdateScowlerInkBlackout
	ld hl, wCurObjState
	ld a, [hl]
	cp $2a
	jr z, .activated
	ld b, a
	ld a, [wRoomTransitionParam]
	and a
	jr nz, .start_catch_wario
	ld a, b
	and a
	jr z, .default
	cp $2f
	jr z, .shoot_ink
	and $fe
	cp $08
	jr z, .stun
	ret
.stun
	ld de, ScowlerFrameset_69a95
	call SetObjectFramesetPtr
	ld a, $44
	ld [hli], a
	ld a, $fd
	ld [hli], a
	inc l
	xor a
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_KNOCK_BACK
	ld [hld], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Stunned)
	ld [hld], a
	ld a, LOW(.Stunned)
	ld [hld], a
	play_sfx SFX_SCOWLER_STUNNED
	ret
.shoot_ink
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .reset_ink_timer
	ld a, [hl]
	cp $20
	ret nz
	play_sfx SFX_ENEMY_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .ink_right
	ld bc, ObjParams_InkLeft
	jp CreateObjectAtRelativePos
.ink_right
	ld bc, ObjParams_InkRight
	jp CreateObjectAtRelativePos
.default
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .check_shoot_ink
	dec [hl]
	jp nz, .track_wario_y
	ld a, [wCurObjSubState]
	rlca
	jr c, .end_turn_right
	ld de, ScowlerFrameset_69a5f
	jp SetObjectFramesetPtr
.end_turn_right
	ld de, ScowlerFrameset_69a68
	jp SetObjectFramesetPtr
.check_shoot_ink
	ld a, [w1d147]
	and a
	jr nz, .swim
	ld l, OBJ_VAR_3
	dec [hl]
	jr nz, .swim
	inc l
	ld a, [hld]
	and $0f
	swap a
	add a
	add $48
	ld [hl], a
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	cp b
	jr c, .swim
	ld a, $2f
	ld [wCurObjState], a
	ld de, ScowlerFrameset_69a7a
	call SetObjectFramesetPtr
	ld a, $48
	ld [hli], a
	ld a, $fe
	ld [hl], a
	ret
.swim
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .swim_right
	ld a, [hli]
	sub $11
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
	jr .turn_around
.swim_right
	ld a, [hli]
	add $10
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
.turn_around
	ld de, ScowlerFrameset_69a71
	call SetObjectFramesetPtr
	inc l
	ld a, $2b
	ld [hl], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.track_wario_y
	ld a, [wWarioScreenYPos]
	and $fe
	ld b, a
	ld a, [wCurObjScreenYPos]
	and $fe
	cp b
	ret z
	jr nc, .MoveUp

.MoveDown:
	ld hl, wCurObjYPos
	ld a, [hli]
	add $05
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
	ld hl, wCurObjSubState
	res OBJSUBFLAG_VDIR_F, [hl]
	ret

.MoveUp:
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $2c
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	ld a, [wIsInWaterOrSand]
	and a
	jp nz, MoveObjectUp
	ld hl, wCurObjSubState
	set OBJSUBFLAG_VDIR_F, [hl]
	ret

.Stunned:
	call UpdateScowlerInkBlackout
	ld hl, wCurObjYPos
	ld a, [hli]
	add $05
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
	ld bc, ScowlerData_60a60
	call z, ApplyObjYMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, ScowlerFrameset_69ab3
	call SetObjectFramesetPtr
	ld a, $ff
	ld [hli], a
	ld a, $fc
	ld [hli], a
	ld a, $02
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_BUMP
	ld [hld], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Vulnerable)
	ld [hld], a
	ld a, LOW(.Vulnerable)
	ld [hld], a
	ld l, OBJ_STATE
	xor a
	ld [hld], a
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	cp b
	jr nc, .reset_vdir
	set 6, [hl]
.reset_vdir
	res 6, [hl]
	ret

.check_hit_from_above
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	cp b
	jr nc, .not_from_above
	play_sfx SFX_SCOWLER_STOMPED
	ld de, ScowlerFrameset_69abc
	call SetObjectFramesetPtr
	ld a, $1e
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Hit)
	ld [hld], a
	ld a, LOW(.Hit)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_KNOCK_BACK
	ld [hld], a
	jp DecrementRemainingBossHits
.not_from_above
	xor a
	ld [hld], a
	set 6, [hl]
	ld a, $02
	ld [wCurObjVar2], a
	jr .vulnerable_swim

.Vulnerable:
	call UpdateScowlerInkBlackout
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .vulnerable_swim
	and $fe
	cp $08
	jr z, .check_hit_from_above
	xor a
	ld [hl], a
.vulnerable_swim
	ld a, [wGlobalCounter]
	and %111
	play_sfx z, SFX_SCOWLER
	ld hl, wCurObjStateDuration
	dec [hl]
	jr nz, .move_vertical
	ld l, OBJ_VAR_2
	dec [hl]
	jr z, .end_vulnerable
.move_vertical
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr z, .move_up
	call .MoveDown
	jr .move_horizontal
.move_up
	call .MoveUp
.move_horizontal
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .move_right
	ld a, [hli]
	sub $11
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
	jr .reverse
.move_right
	ld a, [hli]
	add $10
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
.reverse
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret
.end_vulnerable
	ld de, ScowlerFrameset_69aa8
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ld a, $fe
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_KNOCK_BACK
	ld [hld], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Recover)
	ld [hld], a
	ld a, LOW(.Recover)
	ld [hld], a
	ret

.Hit:
	call UpdateScowlerInkBlackout
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_VAR_3
	xor a
	ld [hli], a
	ld a, [hl]
	and $0f
	dec a
	jr z, .last_hit
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.HitFloatUp)
	ld [hld], a
	ld a, LOW(.HitFloatUp)
	ld [hld], a
	ld de, ScowlerFrameset_69b08
	call SetObjectFramesetPtr
	ld a, $78
	ld [hli], a
	ret
.last_hit
	ld a, [hl]
	and $80
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatedRise)
	ld [hld], a
	ld a, LOW(.DefeatedRise)
	ld [hld], a
	ld de, ScowlerFrameset_69ac3
	call SetObjectFramesetPtr
	inc l
	ld a, $ff
	ld [hli], a
	ld a, $14
	ld [hl], a
	call MoveObjectUpByVar2
	stop_music2
	ret

.HitFloatUp:
	call UpdateScowlerInkBlackout
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_vulnerable
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $2c
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	ld a, [wIsInWaterOrSand]
	and a
	ret z
	ld bc, ScowlerData_60a70
	jp ApplyObjYMovement

.Recover:
	call UpdateScowlerInkBlackout
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_SCOWLER
	ld [hld], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a

.reset_ink_timer
	ld l, OBJ_SUBSTATE
	ld a, [hld]
	and $0f
	swap a
	add a
	add $48
	ld [hl], a
	ld l, OBJ_STATE
	xor a
	ld [wCurObjVar1], a
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res 7, [hl]
	ld de, ScowlerFrameset_69a5f
	jp SetObjectFramesetPtr
.face_right
	set 7, [hl]
	ld de, ScowlerFrameset_69a68
	jp SetObjectFramesetPtr

.DefeatedRise:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call UpdateScowlerInkBlackout
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $18
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	ld a, [wIsInWaterOrSand]
	and a
	ld bc, ScowlerData_60a70
	jp nz, ApplyObjYMovement
	ld hl, wCurObjStateDuration
	ld a, $0f
	ld [hli], a
	inc l
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatedSink)
	ld [hld], a
	ld a, LOW(.DefeatedSink)
	ld [hld], a
	play_sfx SFX_SCOWLER_DEFEATED
	ret

.DefeatedSink:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call UpdateScowlerInkBlackout
	call MoveObjectDown_Slow
	ld bc, ScowlerData_60a80
	call ApplyObjXMovement
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $b4
	ld [hl], a
	xor a
	ld [wCurObjVar2], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Defeated)
	ld [hld], a
	ld a, LOW(.Defeated)
	ld [hld], a
	ret

.Defeated:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call UpdateScowlerInkBlackout
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .sink
	dec [hl]
	jr nz, .sink
	ld hl, wCurObjUnk02
	ld e, $05
	farcall SetObjectMapEntryAndSpawn
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ld hl, w1d147
	ld a, [hl]
	and a
	jr z, .sink
	xor a
	ld [hl], a
	ld hl, ScowlerPals_54c87
	call WriteScowlerOBPals
	ld hl, ScowlerPals_54cb7
	call WriteScowlerBGPals
.sink
	call MoveObjectDown_Slow
	ld bc, ScowlerData_60a90
	jp ApplyObjXMovement_Loop

FloatingRingSpawnerFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitAndSpawn)
	ld [hld], a
	ld a, LOW(.WaitAndSpawn)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld a, $40
	ld [wCurObjStateDuration], a
	jr .DoNothing

.WaitAndSpawn:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr nz, .DoNothing
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DoNothing)
	ld [hld], a
	ld a, LOW(.DoNothing)
	ld [hld], a
	ld bc, ObjParams_FloatingRing
	call CreateObjectAtRelativePos
;	fallthrough

.DoNothing:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

FloatingRingFunc:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Rise)
	ld [hld], a
	ld a, LOW(.Rise)
	ld [hld], a
	jp MoveObjectLeftByVar2

.Rise:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wGlobalCounter]
	rra
	ret c
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectUp
	ld a, $3c
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitForWario)
	ld [hld], a
	ld a, LOW(.WaitForWario)
	ld [hld], a
	ld l, OBJ_Y_POS
	ld a, [hli]
	ld [wCurObjVar2], a
	ld a, [hl]
	ld [wCurObjVar3], a
	ret

.WaitForWario:
	call SetOneWayPlatformAction
	ld hl, wCurObjFlags
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.RiseWithWario)
	ld [hld], a
	ld a, LOW(.RiseWithWario)
	ld [hld], a
	ret

.RiseWithWario:
	call SetOneWayPlatformAction
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_rise
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectUp
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	call MoveWarioUp
	call HandleUpwardsFloorTransition
	jp MoveObjectUp
.end_rise
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Return)
	ld [hld], a
	ld a, LOW(.Return)
	ld [hld], a
	ret

.Return:
	call SetOneWayPlatformAction
	ld hl, wCurObjVar2
	ld b, [hl]
	ld a, [wCurObjYPos + 0]
	cp b
	jr nz, .sink_back
	inc l
	ld b, [hl]
	ld a, [wCurObjYPos + 1]
	cp b
	jr z, .at_start
.sink_back
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectDown_Slow
	res 5, [hl]
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld b, $01
	call MoveWarioDown
	call HandleDownwardsFloorTransition
	jp MoveObjectDown
.at_start
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.RiseWithWario)
	ld [hld], a
	ld a, LOW(.RiseWithWario)
	ld [hld], a
	ld a, $3c
	ld [wCurObjStateDuration], a
	ret

ScrowlerTentacleFunc:
	ld hl, wCurObjFlags
	set 4, [hl]
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.FollowScowler)
	ld [hld], a
	ld a, LOW(.FollowScowler)
	ld [hld], a
	ret

.activated
	ld a, $5a
	ld [hl], a
	play_sfx SFX_ELECTRIC_SHOCK
	stop_music2
	ret

.FollowScowler:
	ld hl, wCurObjState
	ld a, [hl]
	cp $2a
	jr z, .activated
	ld a, [wRoomTransitionParam]
	and a
	ret nz
	xor a
	ld [hl], a
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp SCOWLER
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .found_scowler
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_scowler
	inc l
	inc l
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, l
	add OBJ_VAR_1 - (OBJ_X_POS + 1)
	ld l, a
	ld a, [hli] ; OBJ_VAR_1
	and a
	jr z, .scowler_swimming
	cp $fc
	jr z, .scowler_vulnerable
	cp $fd
	jr z, .scowler_stunned
	cp $fe
	jr z, .scowler_shooting
	cp $ff
	jr z, .scowler_defeated
	ld a, [wCurObjId]
	cp SCROWLER_TENTACLE_RIGHT
	jr z, .attach_facing_right
	jr .attach_facing_left
.scowler_stunned
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_FULL_STING
	ld [hli], a
	ld a, $fd
	ld [hli], a
	ld a, $02
	ld [hli], a
	ret
.scowler_vulnerable
	ld a, [wCurObjId]
	cp SCROWLER_TENTACLE_RIGHT
	jr z, .attach_facing_right
	jr .attach_facing_left
.scowler_shooting
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_TELEPORTING
	ld [hli], a
	ld a, $f6
	ld [hli], a
	ld a, $fe
	ld [hli], a
	ret
.scowler_defeated
	xor a
	ld [wCurObjFlags], a
	ret
.scowler_swimming
	inc l
	inc l
	bit 7, [hl] ; OBJ_SUBSTATE
	jr nz, .attach_facing_right
.attach_facing_left
	ld hl, wCurObjYPos
	ld a, [wCurObjId]
	cp SCROWLER_TENTACLE_RIGHT
	jr z, .right_tentacle_facing_left
	ld a, c
	sub $0b
	ld [hli], a
	ld a, b
	sbc $00
	ld [hli], a
	ld a, e
	add $0f
	ld [hli], a
	ld a, d
	adc $00
	ld [hli], a
	ret
.right_tentacle_facing_left
	ld a, c
	sub $04
	ld [hli], a
	ld a, b
	sbc $00
	ld [hli], a
	ld a, e
	sub $17
	ld [hli], a
	ld a, d
	sbc $00
	ld [hli], a
	ret
.attach_facing_right
	ld hl, wCurObjYPos
	ld a, [wCurObjId]
	cp SCROWLER_TENTACLE_RIGHT
	jr z, .right_tentacle_facing_right
	ld a, c
	sub $04
	ld [hli], a
	ld a, b
	sbc $00
	ld [hli], a
	ld a, e
	add $16
	ld [hli], a
	ld a, d
	adc $00
	ld [hli], a
	ret
.right_tentacle_facing_right
	ld a, c
	sub $0b
	ld [hli], a
	ld a, b
	sbc $00
	ld [hli], a
	ld a, e
	sub $10
	ld [hli], a
	ld a, d
	sbc $00
	ld [hli], a
	ret

InkFunc:
.Left:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .drift_to_wario
	dec [hl]
	call MoveObjectLeft_Slow
	jr .rise
.Right:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .drift_to_wario
	dec [hl]
	call MoveObjectRight_Slow
	jr .rise
.drift_to_wario
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .drift_right
	call MoveObjectLeft_Slow
	jr .rise
.drift_right
	call MoveObjectRight_Slow
.rise
	ld a, [wCurObjState]
	and a
	jr nz, .hit_wario
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $10
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .dissolve
	ld a, [wGlobalCounter]
	and %11
	ret nz
	jp MoveObjectUp
.hit_wario
	ld a, $01
	ld [w1d147], a
.dissolve
	ld de, ScowlerFrameset_69af5
	call SetObjectFramesetPtr
	ld a, $19
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitAndDespawn)
	ld [hld], a
	ld a, LOW(.WaitAndDespawn)
	ld [hld], a
	ret

.WaitAndDespawn:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret

UpdateScowlerInkBlackout:
	ld hl, w1d147
	ld a, [hl]
	and a
	ret z
	ld b, a
	ld a, [wDollBoyActiveBarrels]
	and a
	jr nz, .blackout_count_down
	inc [hl]
	ld a, b
	cp $02
	jr z, .start_ink
	cp $3c
	jr z, .blackout
	cp $3d
	jr z, .ink_again
	cp $78
	jr z, .end_ink
	ret
.ink_again
	play_sfx SFX_0B7
	jr .ink_pals
.start_ink
	play_sfx SFX_SCOWLER_INK_1
.ink_pals
	ld hl, ScowlerPals_54c9f
	call WriteScowlerOBPals
	ld hl, ScowlerPals_54cf7
	jr WriteScowlerBGPals

.blackout
	play_sfx SFX_SCOWLER_BLACKOUT
	ld a, $ff
	ld [wDollBoyActiveBarrels], a
	ld c, 5
	ld b, 3
	call BlackOutOBPals
	ld c, 0
	ld b, 8
	jp BlackOutBGPals

.end_ink
	play_sfx SFX_SCOWLER_INK_2
	xor a
	ld [hl], a
	ld hl, ScowlerPals_54c87
	call WriteScowlerOBPals
	ld hl, ScowlerPals_54cb7
	jr WriteScowlerBGPals
.blackout_count_down
	ld hl, wDollBoyActiveBarrels
	dec [hl]
	ret

WriteScowlerOBPals:
	ld c, 5
	ld b, 3
	jp SetOBPals

WriteScowlerBGPals:
	ld c, 0
	ld b, 8
	jp SetBGPals

ScowlerPals_54c87:
	rgb  0, 20,  0
	rgb 31, 27,  0
	rgb  0, 17, 31
	rgb  0,  0,  0

	rgb  0, 20,  0
	rgb 31, 27,  0
	rgb 29,  1, 29
	rgb  0,  0,  0

	rgb  0, 20,  0
	rgb 31, 31, 20
	rgb  0, 28,  0
	rgb  0,  0,  0

ScowlerPals_54c9f:
	rgb  0, 10,  0
	rgb 31, 13,  0
	rgb 16, 24, 15
	rgb  0,  0,  0

	rgb  0, 10,  0
	rgb 31, 13,  0
	rgb 30, 16, 14
	rgb  0,  0,  0

	rgb  0, 10,  0
	rgb 31, 15, 10
	rgb  0, 14,  0
	rgb  0,  0,  0

ScowlerPals_54cb7:
	rgb  1, 11, 23
	rgb  2,  8, 19
	rgb  0,  6, 15
	rgb  0,  3, 10

	rgb 31, 31, 31
	rgb 19, 22, 25
	rgb  5,  9, 13
	rgb  0,  0,  0

	rgb 14,  4, 12
	rgb  7, 16,  7
	rgb  2, 10,  3
	rgb  0,  0,  0

	rgb 16,  4, 14
	rgb 11,  2,  9
	rgb  8,  0,  6
	rgb  6,  0,  3

	rgb 11,  2,  9
	rgb 17, 23, 30
	rgb  1, 11, 23
	rgb  0,  1, 12

	rgb 30, 20, 29
	rgb 23,  2, 22
	rgb 12,  0, 10
	rgb  0,  0,  0

	rgb 27, 29, 31
	rgb 29, 15, 21
	rgb  9,  0,  2
	rgb  0,  0,  4

	rgb 29, 15, 21
	rgb 22,  2,  5
	rgb 10,  0,  6
	rgb  2,  0,  0

ScowlerPals_54cf7:
	rgb  1,  5, 13
	rgb  0,  3,  8
	rgb  0,  1,  5
	rgb  0,  0,  0

	rgb 14, 17, 19
	rgb  6,  8, 10
	rgb  0,  2,  4
	rgb  0,  0,  0

	rgb 10,  0, 10
	rgb  0,  8,  1
	rgb  0,  4,  0
	rgb  0,  0,  0

	rgb  8,  0,  6
	rgb  6,  0,  3
	rgb  5,  0,  3
	rgb  2,  0,  0

	rgb  6,  0,  3
	rgb  3,  9, 15
	rgb  0,  3,  8
	rgb  0,  0,  4

	rgb 17,  9, 17
	rgb 10,  0, 10
	rgb  4,  0,  4
	rgb  0,  0,  0

	rgb 27, 29, 31
	rgb 21,  8, 13
	rgb  4,  0,  0
	rgb  0,  0,  4

	rgb 21,  8, 13
	rgb 12,  0,  0
	rgb  4,  0,  0
	rgb  2,  0,  0
