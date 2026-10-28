; wJamanoActiveSkulls flags
DEF JAMANO_SKULL1 EQU 1 << 0
DEF JAMANO_SKULL2 EQU 1 << 1
DEF JAMANO_SKULL3 EQU 1 << 2
DEF JAMANO_SKULL4 EQU 1 << 3

JamanoFunc:
	ld a, TRUE
	ld [wIsBossBattle], a
	stop_music2
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Intro)
	ld [hld], a
	ld a, LOW(.Intro)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $03
	ld [hld], a
	ld a, $fc
	ld [hld], a
	ld a, $06
	ld [hl], a
	ld de, JamanoFrameset_69ce9
	call SetObjectFramesetPtr
	ld a, $ff
	ld [hli], a
	ld a, $08
	ld [wCurObjVar2], a
	call MoveObjectLeftByVar2
	ld a, $04
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.Intro:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $c0
	jr nz, .intro_count_down
	play_music2 MUSIC_BOSS_REVEAL
.intro_count_down
	dec [hl]
	ret nz
	ld de, JamanoFrameset_69cdb
	call SetObjectFramesetPtr
	ld a, $ff
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartFight)
	ld [hld], a
	ld a, LOW(.StartFight)
	ld [hld], a
	ret

.StartFight:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $30
	jr nz, .start_count_down
	stop_music2
.start_count_down
	dec [hl]
	ret nz
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic
	ld hl, wCurObjFlags
	set 7, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	xor a
	ld l, OBJ_STATE_DURATION
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [wJamanoSkullsInactive], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res 7, [hl]
	inc l
	ld a, OBJSTATE_5A
	ld [hl], a
	ld de, JamanoFrameset_69c1c
	jp SetObjectFramesetPtr
.face_right
	set 7, [hl]
	inc l
	ld a, OBJSTATE_5B
	ld [hl], a
	ld de, JamanoFrameset_69ca1
	jp SetObjectFramesetPtr

.Frozen:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.Main:
	ld hl, wCurObjFlags
	ld a, [wGlobalCounter]
	rra
	jr c, .flicker_on
	res 4, [hl]
	ret
.flicker_on
	set 4, [hl]
	ld a, [wDollBoyHammerRange]
	and a
	jr nz, .still_dark
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.MoveToCentre)
	ld [hld], a
	ld a, LOW(.MoveToCentre)
	ld [hld], a
	ld l, OBJ_FLAGS
	res OBJFLAG_INVISIBLE_F, [hl]
	ld de, JamanoFrameset_69ce0
	call SetObjectFramesetPtr
	ld a, $a0
	ld [hli], a
	stop_music2
	ret
.still_dark
	ld l, OBJ_STATE
	ld a, [hld]
	cp OBJSTATE_5A
	jr z, .move_left
	cp OBJSTATE_5B
	jr z, .move_right
	bit 7, [hl]
	jr nz, .freeze_facing_right
	ld de, JamanoFrameset_69c92
	jr .freeze
.freeze_facing_right
	ld de, JamanoFrameset_69c7a
.freeze
	ld l, OBJ_FLAGS
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Frozen)
	ld [hld], a
	ld a, LOW(.Frozen)
	ld [hld], a
	stop_music2
	jp SetObjectFramesetPtr
.move_left
	call .TurnToWario
	ld a, [wCurObjVar2]
	dec a
	jr nz, .check_wall_left
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .reverse_to_right
.check_wall_left
	ld l, OBJ_Y_POS
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	sub $08
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .drift_left
.reverse_to_right
	ld a, OBJSTATE_5B
	ld [wCurObjState], a
	jr .vertical_move
.drift_left
	ld bc, JamanoData_60c80
	call ApplyObjXMovement_Loop
	jr .vertical_move
.move_right
	call .TurnToWario
	ld a, [wCurObjVar2]
	dec a
	jr nz, .check_wall_right
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr z, .reverse_to_left
.check_wall_right
	ld l, OBJ_Y_POS
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	add $08
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .drift_right
.reverse_to_left
	ld a, OBJSTATE_5A
	ld [wCurObjState], a
	jr .vertical_move
.drift_right
	ld bc, JamanoData_60c20
	call ApplyObjXMovement_Loop
	jr .vertical_move

.SetVerticalDirToWario:
	ld hl, wCurObjSubState
	ld a, [wWarioScreenYPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenYPos]
	add $2a
	cp b
	jr nc, .wario_above
	set 6, [hl]
	ret
.wario_above
	res 6, [hl]
	ret

.vertical_move
	ld a, [wCurObjVar3]
	dec a
	jr nz, .check_vertical_bounds
	call .SetVerticalDirToWario
.check_vertical_bounds
	ld a, [wCurObjScreenYPos]
	ld hl, wCurObjSubState
	bit 6, [hl]
	jr nz, .moving_down
	cp $28
	jr nc, .move_up
	set 6, [hl]
	xor a
	ld [wCurObjVar3], a
	jr .move_down
.move_up
	ld bc, JamanoData_60c80
	jp ApplyObjYMovement_Loop
.moving_down
	cp $98
	jr nc, .start_moving_up
	cp $7c
	jr c, .move_down
	cp $80
	jr nc, .move_down
	ld l, OBJ_Y_POS
	ld a, [hli]
	add $0a
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
	jr z, .move_down
	ld hl, wCurObjSubState
.start_moving_up
	res 6, [hl]
	xor a
	ld [wCurObjVar3], a
	jr .move_up
.move_down
	ld bc, JamanoData_60c20
	jp ApplyObjYMovement_Loop

.TurnToWario:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_wario_side
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	ld e, $13
	call SetJamanoDarknessFrameset
	xor a
	ld [wCurObjFrameDuration], a
	ld [wCurObjFramesetOffset], a
	ret
.check_wario_side
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	ld a, [hl]
	jr c, .wario_to_right
	rlca
	ret nc
	res 7, [hl]
	ld de, JamanoFrameset_69c7a
	jr .start_turn
.wario_to_right
	rlca
	ret c
	set 7, [hl]
	ld de, JamanoFrameset_69c92
.start_turn
	call SetObjectFramesetPtr
	ld a, $14
	ld [hl], a
	play_sfx SFX_JAMANO_TURN
	ret

.MoveToCentre:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_centre
	dec [hl]
	jr .move_horizontal
.check_centre
	ld a, [wCurObjScreenXPos]
	cp $58
	jr nz, .move_horizontal
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatPose1)
	ld [hld], a
	ld a, LOW(.DefeatPose1)
	ld [hld], a
	ld de, JamanoFrameset_69c40
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	play_sfx SFX_JAMANO_DEFEAT_POSE
	ret
.move_horizontal
	ld a, [wCurObjState]
	cp OBJSTATE_5A
	jr z, .centre_move_left
	cp OBJSTATE_5B
	jr z, .centre_move_right
	ret
.centre_move_left
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	sub $08
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .centre_step_left
	play_sfx SFX_BUMP
	ld a, OBJSTATE_5B
	ld [wCurObjState], a
	jr .centre_move_vertical
.centre_step_left
	call MoveObjectLeft
	jr .centre_move_vertical
.centre_move_right
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	add $08
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .centre_step_right
	play_sfx SFX_BUMP
	ld a, OBJSTATE_5A
	ld [wCurObjState], a
	jr .centre_move_vertical
.centre_step_right
	call MoveObjectRight
.centre_move_vertical
	ld a, [wCurObjScreenYPos]
	ld hl, wCurObjSubState
	bit 6, [hl]
	jr nz, .centre_moving_down
	cp $30
	jp nc, MoveObjectUp
	set 6, [hl]
	play_sfx SFX_BUMP
	jp MoveObjectDown
.centre_moving_down
	cp $7c
	jp c, MoveObjectDown
	ld l, OBJ_Y_POS
	ld a, [hli]
	add $0a
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
	play_sfx SFX_BUMP
	jp MoveObjectUp

.DefeatPose1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatPose2)
	ld [hld], a
	ld a, LOW(.DefeatPose2)
	ld [hld], a
	ld de, JamanoFrameset_69c45
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ret

.DefeatPose2:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.LoseHat)
	ld [hld], a
	ld a, LOW(.LoseHat)
	ld [hld], a
	ld de, JamanoFrameset_69c4a
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ret

.LoseHat:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartFalling)
	ld [hld], a
	ld a, LOW(.StartFalling)
	ld [hld], a
	ld de, JamanoFrameset_69c4f
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	inc l
	ld a, $0f
	ld [hl], a
	call MoveObjectUpByVar2
	ld bc, ObjParams_JamanoHat
	jp CreateObjectAtRelativePos

.StartFalling:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Fall)
	ld [hld], a
	ld a, LOW(.Fall)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $f0
	ld [hld], a
	xor a
	ld [hld], a
	ld [hl], a
	play_sfx SFX_BOSS_DEFEAT_FALL
	ret

.Fall:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, JamanoData_60d20
	jp ApplyObjYMovement

JamanoHatFunc:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $3c
	ld [hl], a
	ld a, $03
	ld [wCurObjVar2], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.FlyAway)
	ld [hld], a
	ld a, LOW(.FlyAway)
	ld [hld], a
	ret

.FlyAway:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jp nz, MoveObjectUpByVar2
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ld hl, wCurObjUnk02
	ld e, $06
	farcall SetObjectMapEntryAndSpawn
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ret

HatPlatformFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $05
	ld [hld], a
	ld a, $fa
	ld [hld], a
	ld a, $00
	ld [hl], a
	ld de, JamanoFrameset_69cef
	call SetObjectFramesetPtr
	xor a
	ld [hli], a
	ld [wCurObjState], a
	inc a
	ld [hl], a
	ld a, $08
	ld [wCurObjVar2], a
	call MoveObjectLeftByVar2
	ld a, $5a
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.Update:
	call SetOneWayPlatformAction
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld hl, wCurObjVar1
	ld a, [hld]
	and a
	jr z, .raise
	inc [hl]
	ld a, [hli]
	cp $30
	jr z, .stop_lowering
	ld a, [wCurObjState]
	and a
	jr nz, .stop_lowering
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectDown
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	call MoveWarioDown
	call HandleDownwardsFloorTransition
	jp MoveObjectDown
.stop_lowering
	xor a
	ld [hl], a
	ld [wCurObjState], a
	ret
.raise
	dec [hl]
	jr z, .raised
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectUp
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	call MoveWarioUp
	call HandleUpwardsFloorTransition
	jp MoveObjectUp
.raised
	inc l
	ld a, $01
	ld [hl], a
	ret

SkullSpawnerFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, $08
	ld [wCurObjVar2], a
	call MoveObjectLeftByVar2
	ld a, $14
	ld [wCurObjVar2], a
	call MoveObjectUpByVar2
	ld bc, ObjParams_Skull1
	call CreateObjectAtRelativePos
	ld bc, ObjParams_Skull2
	call CreateObjectAtRelativePos
	ld bc, ObjParams_Skull3
	call CreateObjectAtRelativePos
	ld bc, ObjParams_Skull4
	call CreateObjectAtRelativePos
	ld a, JAMANO_SKULL1 | JAMANO_SKULL2 | JAMANO_SKULL3 | JAMANO_SKULL4
	ld [wJamanoActiveSkulls], a
	xor a
	ld [w1d147], a
	ld [wDollBoyHammerRange], a
	ld a, $01
	ld [wJamanoSkullsInactive], a
	ret

.Update:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wJamanoSkullsInactive]
	and a
	jr nz, .active
	ld a, [wDollBoyHammerRange]
	and a
	jr nz, .active
	xor a
	ld [wCurObjFlags], a
	ld hl, wCurObjUnk02
	ld e, $07
	farcall SetObjectMapEntryAndSpawn
	ret
.active
	call UpdateJamanoDarkness

	ld hl, wJamanoActiveSkulls
	ld a, [hl]
	rra
	jr nc, .spawn_skull_1
	rra
	jr nc, .spawn_skull_2
	rra
	jr nc, .spawn_skull_3
	rra
	ret c
; spawn skull 4
	set 3, [hl]
	ld bc, ObjParams_Skull4
	jp CreateObjectAtRelativePos
.spawn_skull_1
	set 0, [hl]
	ld bc, ObjParams_Skull1
	jp CreateObjectAtRelativePos
.spawn_skull_2
	set 1, [hl]
	ld bc, ObjParams_Skull2
	jp CreateObjectAtRelativePos
.spawn_skull_3
	set 2, [hl]
	ld bc, ObjParams_Skull3
	jp CreateObjectAtRelativePos

SkullFunc:
	call .Blink
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Wait)
	ld [hld], a
	ld a, LOW(.Wait)
	ld [hld], a
	ret

.Wait:
	call .Blink
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitToFly)
	ld [hld], a
	ld a, LOW(.WaitToFly)
	ld [hld], a
	ret

.WaitToFly:
	call .Blink
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjVar1
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.FlyToEdge)
	ld [hld], a
	ld a, LOW(.FlyToEdge)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ret

.FlyToEdge:
	call .Blink
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjId]
	ld b, a
	cp SKULL3
	ld a, [wCurObjScreenXPos]
	jr nc, .fly_right
	cp $10
	jr z, .at_edge
	call MoveObjectLeft
	ld a, b
	rra
	jr c, .odd_skull_arc
.even_skull_arc
	ld bc, JamanoData_60ce0
	jp ApplyObjYMovement
.fly_right
	cp SCREEN_WIDTH_PX
	jr z, .at_edge
	call MoveObjectRight
	ld a, b
	rra
	jr nc, .even_skull_arc
.odd_skull_arc
	ld bc, JamanoData_60d00
	jp ApplyObjYMovement
.at_edge
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Settle)
	ld [hld], a
	ld a, LOW(.Settle)
	ld [hld], a
	ld a, $27
	ld [wCurObjStateDuration], a
	ld hl, w1d147
	inc [hl]
	ret

.Settle:
	call .Blink
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .settled
	dec [hl]
	ret
.settled
	ld a, [wCurObjFramesetOffset]
	cp $02
	ret nz
	ld l, OBJ_FLAGS
	res 7, [hl]
	res 4, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.InPlace)
	ld [hld], a
	ld a, LOW(.InPlace)
	ld [hld], a
	ld de, JamanoFrameset_69cd6
	jp SetObjectFramesetPtr

.InPlace:
	ld a, [wJamanoSkullsInactive]
	and a
	jr z, .active
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	jp .Blink
.active
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld a, [wCurObjState]
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .knocked_left
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .knocked_right
	ret
.knocked_right
	ld a, HIGH(.KnockedRight)
	ld c, LOW(.KnockedRight)
	jr .set_knocked
.knocked_left
	ld a, HIGH(.KnockedLeft)
	ld c, LOW(.KnockedLeft)
.set_knocked
	ld hl, wCurObjUpdateFunction + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	inc a
	ld [hl], a
	ld de, JamanoFrameset_69cec
	call SetObjectFramesetPtr
	ld a, $ff
	ld [hli], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	play_sfx SFX_ATTACK_HIT
	ld hl, w1d147
	dec [hl]
	ret

.KnockedRight:
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jp nz, ObjState_AttackedRight
	jr .offscreen_count_down

.KnockedLeft:
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jp nz, ObjState_AttackedLeft

.offscreen_count_down
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $f7
	play_sfx z, SFX_JAMANO_SKULL
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a

	ld a, [wCurObjId]
	cp SKULL1
	jr z, .deactivate_skull_1
	cp SKULL2
	jr z, .deactivate_skull_2
	cp SKULL3
	jr z, .deactivate_skull_3
; deactivate skull 4
	ld b, $ff ^ JAMANO_SKULL4
	jr .got_skull_mask
.deactivate_skull_1
	ld b, $ff ^ JAMANO_SKULL1
	jr .got_skull_mask
.deactivate_skull_2
	ld b, $ff ^ JAMANO_SKULL2
	jr .got_skull_mask
.deactivate_skull_3
	ld b, $ff ^ JAMANO_SKULL3
.got_skull_mask
	ld a, [wJamanoActiveSkulls]
	and b
	ld [wJamanoActiveSkulls], a
	ret

.Blink:
	ld a, [wJamanoSkullsInactive]
	and a
	jr nz, .flicker
	ld a, [wDollBoyHammerRange]
	and a
	jr z, .despawn
.flicker
	ld hl, wCurObjFlags
	ld a, [wGlobalCounter]
	rra
	jr nc, .hide
	res 4, [hl]
	ret
.hide
	set 4, [hl]
	ret
.despawn
	ld [wCurObjFlags], a
	ret

UpdateJamanoDarkness:
	ld a, [w1d147]
	ld b, a
	ld hl, wDollBoyHammerRange
	ld a, [hl]
	and a
	jr z, .darkness_0
	cp $01
	jr z, .darkness_1
	cp $02
	jr z, .darkness_2
	cp $03
	jr z, .darkness_3
	ld a, b
	cp $03
	ret nz
	dec [hl]
	call .AlertJamano
	ld hl, JamanoPals_555d1
	jr .set_pals
.darkness_0
	ld a, b
	cp $01
	ret nz
	inc [hl]
	call .AlertJamano
	ld hl, JamanoPals_55551
	jr .set_pals
.darkness_1
	ld a, b
	cp $02
	jr nz, .darkness_1_lighten
	inc [hl]
	call .AlertJamano
	ld hl, JamanoPals_55591
	jr .set_pals
.darkness_1_lighten
	and a
	ret nz
	dec [hl]
	ld hl, JamanoPals_55511
	jr .set_pals
.darkness_2
	ld a, b
	cp $03
	jr nz, .darkness_2_lighten
	inc [hl]
	call .AlertJamano
	ld hl, JamanoPals_555d1
	jr .set_pals
.darkness_2_lighten
	cp $01
	ret nz
	dec [hl]
	call .AlertJamano
	ld hl, JamanoPals_55551
	jr .set_pals
.darkness_3
	ld a, b
	cp $04
	jr nz, .darkness_3_lighten
	inc [hl]
	call .AlertJamano
	ld c, 0
	ld b, 8
	jp BlackOutBGPals
.darkness_3_lighten
	cp $02
	ret nz
	dec [hl]
	call .AlertJamano
	ld hl, JamanoPals_55591
	jr .set_pals ; unnecessary jr
.set_pals
	ld c, 0
	ld b, 8
	jp SetBGPals

.AlertJamano:
	ld a, [wJamanoSkullsInactive]
	and a
	ret nz
	xor a
	ld b, a
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp JAMANO
	jr nz, .next_obj
	ld a, l
	sub $07
	ld l, a
	ld a, [hl]
	rra
	jr c, .found_jamano
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_jamano
	ld a, l
	add $16
	ld l, a
	ld a, [hld]
	and a
	ret nz
	dec l
	dec l
	ld e, l
	ld a, l
	add $07
	ld l, a
;	fallthrough

SetJamanoDarknessFrameset:
	ld a, [wDollBoyHammerRange]
	cp $01
	jr z, .darkness_1
	cp $02
	jr z, .darkness_2
	cp $03
	jr z, .darkness_3
	cp $04
	ret nz
	bit 7, [hl]
	jr nz, .darkness_4_facing_right
	ld b, $5c
	ld c, $1c
	jr .set_frameset
.darkness_4_facing_right
	ld b, $5c
	ld c, $a1
	jr .set_frameset
.darkness_1
	bit 7, [hl]
	jr nz, .darkness_1_facing_right
	ld b, $5c
	ld c, $37
	jr .set_frameset
.darkness_1_facing_right
	ld b, $5c
	ld c, $bc
	jr .set_frameset
.darkness_2
	bit 7, [hl]
	jr nz, .darkness_2_facing_right
	ld b, $5c
	ld c, $2e
	jr .set_frameset
.darkness_2_facing_right
	ld b, $5c
	ld c, $b3
	jr .set_frameset
.darkness_3
	bit 7, [hl]
	jr nz, .darkness_3_facing_right
	ld b, $5c
	ld c, $25
	jr .set_frameset
.darkness_3_facing_right
	ld b, $5c
	ld c, $aa
.set_frameset
	ld l, e
	ld a, b
	ld [hld], a
	ld [hl], c
	ret

JamanoPals_55511:
	rgb 10,  6,  0
	rgb 31, 31,  8
	rgb 25, 16,  0
	rgb  0,  0,  0

	rgb  4, 22, 21
	rgb  0, 11,  9
	rgb  0,  8,  6
	rgb  0,  6,  4

	rgb 11,  7,  0
	rgb 13, 18, 25
	rgb  6,  6, 13
	rgb  0,  0,  0

	rgb 19, 18,  7
	rgb 14, 12,  1
	rgb  9,  7,  0
	rgb  8,  4, 13

	rgb  0,  6,  4
	rgb 16, 10,  0
	rgb 11,  7,  0
	rgb  9,  5,  0

	rgb 31, 23, 29
	rgb 25,  4, 23
	rgb 13,  0, 10
	rgb  0,  0,  0

	rgb 21, 17, 11
	rgb 14,  7,  3
	rgb  7,  4,  3
	rgb  0,  0,  0

	rgb 24, 26, 17
	rgb  8, 13,  4
	rgb  5,  7,  1
	rgb  0,  0,  0

JamanoPals_55551:
	rgb  8,  4,  0
	rgb 31, 31,  8
	rgb 25, 16,  0
	rgb  0,  0,  0

	rgb  4, 18, 17
	rgb  0,  9,  7
	rgb  0,  6,  4
	rgb  0,  5,  2

	rgb  9,  5,  0
	rgb 10, 15, 22
	rgb  4,  4, 11
	rgb  0,  0,  0

	rgb 16, 15,  5
	rgb 12, 10,  1
	rgb  7,  5,  0
	rgb  6,  1, 11

	rgb  0,  5,  3
	rgb 14,  8,  0
	rgb  9,  5,  0
	rgb  7,  3,  0

	rgb 27, 19, 25
	rgb 21,  2, 19
	rgb 10,  0,  7
	rgb  0,  0,  0

	rgb 18, 14,  8
	rgb 11,  5,  1
	rgb  5,  2,  0
	rgb  0,  0,  0

	rgb 24, 26, 17
	rgb  8, 13,  4
	rgb  5,  7,  1
	rgb  0,  0,  0

JamanoPals_55591:
	rgb  7,  2,  0
	rgb 31, 31,  8
	rgb 25, 16,  0
	rgb  0,  0,  0

	rgb  1, 14, 13
	rgb  0,  7,  5
	rgb  0,  4,  2
	rgb  0,  3,  0

	rgb  7,  3,  0
	rgb  7, 12, 19
	rgb  2,  2,  8
	rgb  0,  0,  0

	rgb 13, 12,  2
	rgb  9,  7,  0
	rgb  5,  3,  0
	rgb  3,  0,  8

	rgb  0,  4,  2
	rgb 11,  5,  0
	rgb  8,  3,  0
	rgb  5,  1,  0

	rgb 24, 11, 22
	rgb 17,  0, 15
	rgb  7,  0,  5
	rgb  0,  0,  0

	rgb 15, 11,  5
	rgb  9,  3,  0
	rgb  4,  0,  0
	rgb  0,  0,  0

	rgb 24, 26, 17
	rgb  8, 13,  4
	rgb  5,  7,  1
	rgb  0,  0,  0

JamanoPals_555d1:
	rgb  3,  0,  0
	rgb 31, 31,  8
	rgb 25, 16,  0
	rgb  0,  0,  0

	rgb  0, 10,  8
	rgb  0,  5,  3
	rgb  0,  2,  0
	rgb  0,  3,  0

	rgb  4,  1,  0
	rgb  3,  7, 13
	rgb  0,  0,  5
	rgb  0,  0,  0

	rgb  9,  8,  0
	rgb  5,  4,  0
	rgb  2,  1,  0
	rgb  1,  0,  4

	rgb  0,  2,  0
	rgb  7,  3,  0
	rgb  5,  0,  0
	rgb  5,  1,  0

	rgb 19,  5, 17
	rgb 12,  0, 11
	rgb  4,  0,  2
	rgb  0,  0,  0

	rgb 11,  7,  1
	rgb  6,  1,  0
	rgb  1,  0,  0
	rgb  0,  0,  0

	rgb 24, 26, 17
	rgb  8, 13,  4
	rgb  5,  7,  1
	rgb  0,  0,  0
