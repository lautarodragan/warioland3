AnonsterFunc:
	ld a, TRUE
	ld [wIsBossBattle], a
	ld a, 27
	ld [wCurObjVar2], a
	call MoveObjectUpByVar2
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
	ld a, $28
	ld [wCurObjStateDuration], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartFight)
	ld [hld], a
	ld a, LOW(.StartFight)
	ld [hld], a
.StartFight:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic

.restart
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset AnonsterFrameset_693c4, AnonsterFrameset_693d5
	call SetObjectFramesetPtr
	ld a, $50
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Appear)
	ld [hld], a
	ld a, LOW(.Appear)
	ld [hld], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $08
	ld [hld], a
	ld a, $f7
	ld [hld], a
	ld a, $fc
	ld [hld], a
	ld a, $e3
	ld [hld], a
	res 7, [hl]
	ret

.Appear:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Walk)
	ld [hld], a
	ld a, LOW(.Walk)
	ld [hld], a
	ld l, OBJ_STATE
	xor a
	ld [hld], a
	dec l
	ld [hld], a
	ld [hld], a
	dec l
	ld [hld], a
	ret

.Walk:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjState
	ld a, [hld]
	and $fe
	cp $28
	jr nz, .asm_500a8
	ld a, [hld]
	rlca
	ld_obj_frameset AnonsterFrameset_6943c, AnonsterFrameset_69441
	call SetObjectFramesetPtr
	xor a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartRise)
	ld [hld], a
	ld a, LOW(.StartRise)
	ld [hld], a
	ret

.asm_500a8
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ld bc, AnonsterData_60790
	call ApplyObjYMovement_Loop
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_500cd
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_500c7
	ld de, AnonsterFrameset_693c4
	jp SetObjectFramesetPtr
.asm_500c7
	ld de, AnonsterFrameset_693d5
	jp SetObjectFramesetPtr
.asm_500cd
	ld l, OBJ_VAR_3
	ld a, [hld]
	cp $4f
	jr nz, .asm_50118
	inc [hl]
	ld a, [hl]
	cp $02
	jr c, .asm_50118
	farcall _CountActiveTransientObjects
	ld a, e
	and a
	jr nz, .asm_50118
	xor a
	ld [hli], a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Hover)
	ld [hld], a
	ld a, LOW(.Hover)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_50110
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, AnonsterFrameset_693e6
	jp SetObjectFramesetPtr
.asm_50110
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, AnonsterFrameset_69411
	jp SetObjectFramesetPtr
.asm_50118
	inc l
	ld a, [hl]
	dec a
	play_sfx z, SFX_0B0
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_5014e
	ld a, [hli]
	sub $11
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
	ld de, AnonsterFrameset_69446
	jr .asm_50162
.asm_5014e
	ld a, [hli]
	add $10
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
	ld de, AnonsterFrameset_69512
.asm_50162
	call SetObjectFramesetPtr
	ld a, $0a
	ld [hli], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.Hover:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjVar3]
	cp $1f
	jr z, .asm_50185
	cp $4f
	jr z, .asm_501a3
.asm_5017f
	ld bc, AnonsterData_60790
	jp ApplyObjYMovement_Loop
.asm_50185
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.ShootSilk1)
	ld [hld], a
	ld a, LOW(.ShootSilk1)
	ld [hld], a

.set_shoot_frameset
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset AnonsterFrameset_693f9, AnonsterFrameset_69424
	call SetObjectFramesetPtr
	ld a, $20
	ld [hli], a
	ret

.asm_501a3
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Walk)
	ld [hld], a
	ld a, LOW(.Walk)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hld]
	rlca
	jr c, .asm_501b9
	xor a
	ld [hld], a
	ld de, AnonsterFrameset_693c4
	jr .asm_501be
.asm_501b9
	xor a
	ld [hld], a
	ld de, AnonsterFrameset_693d5
.asm_501be
	call SetObjectFramesetPtr
	xor a
	ld [hl], a
	ret

.ShootSilk1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_501ed
	ld a, [hl]
	cp $18
	ret nz
	play_sfx SFX_ENEMY_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_501e7
	ld bc, ObjParams_AnonsterSilk1Left
	jp CreateObjectAtRelativePos
.asm_501e7
	ld bc, ObjParams_AnonsterSilk1Right
	jp CreateObjectAtRelativePos
.asm_501ed
	ld a, [wCurObjSubState]
	and $0f
	cp $04
	jr z, .end_shooting
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ShootSilk2)
	ld [hld], a
	ld a, LOW(.ShootSilk2)
	ld [hld], a
	jr .set_shoot_frameset
.ShootSilk2:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_50229
	ld a, [hl]
	cp $18
	ret nz
	play_sfx SFX_ENEMY_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_50223
	ld bc, ObjParams_AnonsterSilk2Left
	jp CreateObjectAtRelativePos
.asm_50223
	ld bc, ObjParams_AnonsterSilk2Right
	jp CreateObjectAtRelativePos
.asm_50229
	ld a, [wCurObjSubState]
	and $0f
	cp $03
	jr z, .end_shooting
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ShootSilk3)
	ld [hld], a
	ld a, LOW(.ShootSilk3)
	ld [hld], a
	jp .set_shoot_frameset
.ShootSilk3:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_shooting
	ld a, [hl]
	cp $18
	ret nz
	play_sfx SFX_ENEMY_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_50260
	ld bc, ObjParams_AnonsterSilk3Left
	jp CreateObjectAtRelativePos
.asm_50260
	ld bc, ObjParams_AnonsterSilk3Right
	jp CreateObjectAtRelativePos
.end_shooting
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Hover)
	ld [hld], a
	ld a, LOW(.Hover)
	ld [hld], a
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset AnonsterFrameset_69402, AnonsterFrameset_6942d
	call SetObjectFramesetPtr
	jp .asm_5017f

.StartRise:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.RiseToCeiling)
	ld [hld], a
	ld a, LOW(.RiseToCeiling)
	ld [hld], a
	play_sfx SFX_0B1
.RiseToCeiling:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_502ae
	dec [hl]
	ret nz
	inc l
	ld a, $03
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.MoveAboveWario)
	ld [hld], a
	ld a, LOW(.MoveAboveWario)
	ld [hld], a
	ret

.asm_502ae
	ld a, [wCurObjScreenYPos]
	cp $08
	jp nc, MoveObjectUp_Slow
	ld a, $3c
	ld [wCurObjStateDuration], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_502ce
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_502ce
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.MoveAboveWario:
	ld a, [wWarioScreenXPos]
	and $fe
	ld b, a
	ld a, [wCurObjScreenXPos]
	and $fe
	cp b
	jr z, .asm_50321
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_50305
	ld a, [hli]
	sub $11
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Fast
	jr .asm_50316
.asm_50305
	ld a, [hli]
	add $10
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Fast
.asm_50316
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ld l, OBJ_VAR_1
	dec [hl]
	ret nz
.asm_50321
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	xor a
	ld [wCurObjVar3], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DropOnWario)
	ld [hld], a
	ld a, LOW(.DropOnWario)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_48 | HEAVY_OBJ
	ld [hli], a
	ld a, $e8
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $f4
	ld [hli], a
	ld a, $0b
	ld [hli], a
	ld de, AnonsterFrameset_6944d
	jp SetObjectFramesetPtr

.DropOnWario:
	ld a, [wCurObjScreenYPos]
	cp $50
	jr c, .asm_50368
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
	and a
	jr nz, .asm_5036e
.asm_50368
	ld bc, AnonsterData_607f0
	jp ApplyObjYMovement
.asm_5036e
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Land)
	ld [hld], a
	ld a, LOW(.Land)
	ld [hld], a
	ld de, AnonsterFrameset_69450
	call SetObjectFramesetPtr
	ld a, $20
	ld [hli], a
.asm_50388
	ld l, OBJ_COLLBOX_TOP
	ld a, $f0
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $f0
	ld [hli], a
	ld a, $0f
	ld [hli], a
	ret

.Land:
	ld hl, wCurObjStateDuration
	dec [hl]
	ld a, [hl]
	cp $18
	jr z, .asm_503d3
	and a
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.OnFloor)
	ld [hld], a
	ld a, LOW(.OnFloor)
	ld [hld], a
	ld l, OBJ_STATE
	ld a, $5a
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_503c4
	res 7, [hl]
	ld de, AnonsterFrameset_694d0
	jr .asm_503c9
.asm_503c4
	set 7, [hl]
	ld de, AnonsterFrameset_694c9
.asm_503c9
	call SetObjectFramesetPtr
	ld a, $07
	ld [hli], a
	ld a, $02
	ld [hl], a
	ret

.asm_503d3
	play_sfx SFX_EARTHQUAKE
	ld b, $18
	jp DoGroundShake

.spit_waves
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr z, .asm_50403
	ld a, [hl]
	cp $2b
	ret nz
	play_sfx SFX_ENEMY_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_503fd
	ld bc, ObjParams_AnonsterWaveLeft
	jp CreateObjectAtRelativePos
.asm_503fd
	ld bc, ObjParams_AnonsterWaveRight
	jp CreateObjectAtRelativePos
.asm_50403
	inc l
	dec [hl]
	jp z, .return_to_ceiling
	ld l, OBJ_STATE
	ld a, $5c
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_50417
	ld de, AnonsterFrameset_69485
	jp SetObjectFramesetPtr
.asm_50417
	ld de, AnonsterFrameset_69496
	jp SetObjectFramesetPtr

.OnFloor:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_5046b
	cp $5b
	jr z, .spit_waves
	cp $5c
	jr z, .asm_504aa
	cp $5a
	jr z, .asm_50437
	cp $0a
	jp z, .check_hit_from_behind
	jr .reset_to_walk
.asm_50437
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
.reset_to_walk
	ld l, OBJ_COLLBOX_RIGHT
	ld a, [wCurObjSubState]
	rlca
	jr c, .asm_5044d
	ld de, AnonsterFrameset_69485
	ld a, $10
	ld [hld], a
	ld a, $f8
	jr .asm_50455
.asm_5044d
	ld de, AnonsterFrameset_69496
	ld a, $07
	ld [hld], a
	ld a, $ef
.asm_50455
	ld [hld], a
	ld a, $00
	ld [hld], a
	ld a, $f0
	ld [hld], a
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_48
	ld [hli], a
	call SetObjectFramesetPtr
	xor a
	ld [hl], a
	ld [wCurObjState], a
	ret

.asm_5046b
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .asm_5047f
	dec [hl]
	jr z, .reset_to_walk
	ld a, [hl]
	cp $07
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.asm_5047f
	ld a, [wGlobalCounter]
	rra
	ret c
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wCurObjScreenXPos]
	sub b
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .asm_50499
	jr c, .walk_towards_wario
	ld de, AnonsterFrameset_69463
	jr .asm_5049e
.asm_50499
	jr nc, .walk_towards_wario
	ld de, AnonsterFrameset_69474
.asm_5049e
	call SetObjectFramesetPtr
	ld a, $5d
	ld [hli], a
	ld a, $5b
	ld [wCurObjState], a
	ret

.asm_504aa
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr nz, .asm_504d0

.return_to_ceiling
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset AnonsterFrameset_69554, AnonsterFrameset_6954d
	call SetObjectFramesetPtr
	ld a, $07
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartReturnToCeiling)
	ld [hld], a
	ld a, LOW(.StartReturnToCeiling)
	ld [hld], a
	jp .asm_50388

.asm_504d0
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .asm_504e5
	dec [hl]
	jp z, .reset_to_walk
	ld a, [hl]
	cp $07
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.asm_504e5
	ld l, OBJ_FRAME_DURATION
	ld a, [hl]
	cp $03
	jr c, .asm_504ef
	sub $03
	ld [hl], a
.asm_504ef
	ld a, [wGlobalCounter]
	and %1111
	play_sfx z, SFX_ANONSTER_WALK
.walk_towards_wario
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .asm_50527
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $14
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
	ld de, AnonsterFrameset_69573
	jr .asm_50544
.asm_50527
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	add $17
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Down
	and a
	jp nz, MoveObjectRight
	ld de, AnonsterFrameset_69568
.asm_50544
	call SetObjectFramesetPtr
	ld a, $0e
	ld [hli], a
	ret

.check_hit_from_behind
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	sub b
	dec l
	bit 7, [hl]
	jr nz, .asm_50561
	jr c, .asm_50564
	jp .reset_to_walk
.asm_50561
	jp c, .reset_to_walk
.asm_50564
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_0B
	ld [hld], a
	play_sfx SFX_VANISH
	call DecrementRemainingBossHits
	ld a, [hld]
	rlca
	ld_obj_frameset AnonsterFrameset_694a7, AnonsterFrameset_694b8
	call SetObjectFramesetPtr
	ld a, [wCurObjSubState]
	and $0f
	dec a
	jr z, .asm_505a0
	ld a, $56
	ld [hl], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Hurt)
	ld [hld], a
	ld a, LOW(.Hurt)
	ld [hld], a
	jp UpdateAnonsterPal
.asm_505a0
	ld a, $ac
	ld [hl], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAG_HDIR
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Defeated)
	ld [hld], a
	ld a, LOW(.Defeated)
	ld [hld], a
	stop_music2
	ret

.Hurt:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $4e
	play_sfx z, SFX_0B1
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset AnonsterFrameset_6953c, AnonsterFrameset_69543
	call SetObjectFramesetPtr
	ld a, $0e
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Recover1)
	ld [hld], a
	ld a, LOW(.Recover1)
	ld [hld], a
	jp .asm_50388

.Recover1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, AnonsterFrameset_6951e
	call SetObjectFramesetPtr
	ld a, $33
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Recover2)
	ld [hld], a
	ld a, LOW(.Recover2)
	ld [hld], a
	ret

.Recover2:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, AnonsterFrameset_69519
	call SetObjectFramesetPtr
	xor a
	ld [wCurObjVar3], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ReturnToCeiling)
	ld [hld], a
	ld a, LOW(.ReturnToCeiling)
	ld [hld], a
	play_sfx SFX_0B2
	ret

.ReturnToCeiling:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjScreenYPos]
	cp $10
	jr c, .asm_50647
	ld bc, AnonsterData_607e0
	jp ApplyObjYMovement
.asm_50647
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jp nz, .restart
	ret

.StartReturnToCeiling:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, AnonsterFrameset_694e1
	call SetObjectFramesetPtr
	ld a, $2d
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.JumpToCeiling)
	ld [hld], a
	ld a, LOW(.JumpToCeiling)
	ld [hld], a
	ret

.JumpToCeiling:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, AnonsterFrameset_6944d
	call SetObjectFramesetPtr
	xor a
	ld [wCurObjVar3], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ReturnToCeiling)
	ld [hld], a
	ld a, LOW(.ReturnToCeiling)
	ld [hld], a
	ret

.Defeated:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_506f5
	cp $a4
	play_sfx z, SFX_0B1
	dec [hl]
	ret nz
	ld hl, wCurObjMapPtrHi
	ld e, $05
	farcall SetObjectMapEntryAndSpawn
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset AnonsterFrameset_694d7, AnonsterFrameset_694dc
	call SetObjectFramesetPtr
	ld l, OBJ_STATE
	ld a, $48
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_506eb
	res OBJSUBFLAG_HDIR_F, [hl]
	jr .asm_506ed
.asm_506eb
	set OBJSUBFLAG_HDIR_F, [hl]
.asm_506ed
	dec l
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ret

.asm_506f5
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatedFall)
	ld [hld], a
	ld a, LOW(.DefeatedFall)
	ld [hld], a
	play_sfx SFX_BOSS_DEFEAT_FALL
.DefeatedFall:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, AttackedYVel_Light
	call ApplyObjYMovement
	ld a, [wCurObjSubState]
	rlca
	jp nc, MoveObjectRight
	jp MoveObjectLeft

SilkPlatformsFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.CreatePlatform1)
	ld [hld], a
	ld a, LOW(.CreatePlatform1)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld a, $28
	ld [wCurObjStateDuration], a
	jr .asm_50746

.CreatePlatform3:
	ld bc, ObjParams_SilkPlatform3
	ld de, .Wait
	jr .asm_50746
.CreatePlatform2:
	ld bc, ObjParams_SilkPlatform2
	ld de, .CreatePlatform3
	jr .asm_50746
.CreatePlatform1:
	ld bc, ObjParams_SilkPlatform1
	ld de, .CreatePlatform2
.asm_50746
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $32
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, d
	ld [hld], a
	ld a, e
	ld [hld], a
	jp CreateObjectAtRelativePos

.Wait:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, 2
	ld [wCurObjFrameDuration], a
	ret

SilkPlatformFunc:
	call SetOneWayPlatformAction
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	jp MoveObjectDown_Slow

AnonsterSilkFunc:
.FloatLeft:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_507f7
	call MoveObjectLeft_Fast
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $05
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .asm_507ae
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.FloatRight)
	ld [hld], a
	ld a, LOW(.FloatRight)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_507ae
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .asm_50849
	jp .asm_50855

.FloatRight:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_507f7
	call MoveObjectRight_Fast
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $04
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr z, .asm_507ed
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.FloatLeft)
	ld [hld], a
	ld a, LOW(.FloatLeft)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.asm_507ed
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .asm_50849
	jp .asm_50855
.asm_507f7
	ld a, [wCurObjScreenYPos]
	cp $b0
	jr c, .asm_50803
	xor a
	ld [wCurObjFlags], a
	ret

.asm_50803
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr nc, .asm_5082a
	ld bc, AnonsterData_60800
	call ApplyObjXMovement_Loop
	ld l, OBJ_X_POS
	ld a, [hli]
	sub $05
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	jr .asm_5083c
.asm_5082a
	ld bc, AnonsterData_60830
	call ApplyObjXMovement_Loop
	ld l, OBJ_X_POS
	ld a, [hli]
	add $04
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
.asm_5083c
	call ProcessBlock_Side
	and a
	jr nz, .asm_5084e
	ld a, [wCurObjVar2]
	cp $2e
	jr nz, .asm_50855
.asm_50849
	ldh a, [rDIV]
	rra
	jr c, .asm_50855
.asm_5084e
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
.asm_50855
	ld a, [wCurObjState]
	and a
	jr z, .asm_50861
	cp $0b
	jr c, .Dissolve
	jr .destroy
.asm_50861
	ld a, [wGlobalCounter]
	and %11
	ret nz
	call MoveObjectDown
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
	and a
	ret z
	ld de, AnonsterFrameset_694f5
	call SetObjectFramesetPtr
	ld a, $64
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_00
	ld [hld], a
	ret

.Dissolve:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitAndDestroy)
	ld [hld], a
	ld a, LOW(.WaitAndDestroy)
	ld [hld], a
	ld de, AnonsterFrameset_6955b
	call SetObjectFramesetPtr
	ld a, $1d
	ld [hli], a
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_WATER_DROP
	ret

.WaitAndDestroy:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz

.destroy
	xor a
	ld [wCurObjFlags], a
	ret

.Update:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld a, [wCurObjScreenYPos]
	cp $b0
	jr c, .asm_508dd
	cp $c0
	jr c, .Dissolve
.asm_508dd
	ld a, [wCurObjState]
	jumptable

	dw .State00
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .AttackedLeftStart
	dw .AttackedRightStart
	dw .PickedUpLeftStart
	dw .PickedUpRightStart
	dw .Dissolve
	dw .Dissolve
	dw VanishObject2
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .State00
	dw .Dissolve
	dw .Dissolve
	dw .State12
	dw .Dissolve
	dw .State14
	dw .State15
	dw .Dissolve
	dw .Dissolve
	dw .State18
	dw .State19
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw ObjState_FallLeftStart
	dw ObjState_FallRightStart
	dw .State28
	dw .State29
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw ObjState_Fall
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw ObjState_AttackedLeft
	dw ObjState_AttackedRight
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw ObjState_Bounce2Right
	dw ObjState_Bounce2Left
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .Dissolve
	dw .State3f
	dw .Dissolve
	dw .Dissolve
	dw ObjState_Drop
	dw .Dissolve
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .Dissolve
	dw .Dissolve
	dw .State48
	dw .State49
	dw ObjState_GrabbedChargeLeft
	dw ObjState_GrabbedChargeRight
	dw ObjState_FullThrowLeft
	dw ObjState_FullThrowRight
	dw ObjState_ThrowLeft
	dw ObjState_ThrowRight
	dw ObjState_Bounce1Left
	dw ObjState_Bounce1Right
	dw ObjState_Bounce2Left
	dw ObjState_Bounce2Right
	dw ObjState_Bounce3Left
	dw ObjState_Bounce3Right
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw ObjState_HitByObjLeft
	dw ObjState_HitByObjRight

.State14:
	ld hl, wCurObjState
	ld a, $44
	ld [hld], a
	jr .asm_509a3
.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_509a3
	ld l, OBJ_VAR_2
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ret

.State00:
	ld a, $3f
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld a, $78
	ld [wCurObjStateDuration], a
	ret

.State3f:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .destroy
	ld a, [hl]
	cp $3c
	jp nc, ObjCheckFloorOrDrop
	ld l, OBJ_FLAGS
	ld a, [wGlobalCounter]
	and %111
	cp $04
	jr c, .asm_509d8
	res OBJFLAG_INVISIBLE_F, [hl]
	jp ObjCheckFloorOrDrop
.asm_509d8
	set OBJFLAG_INVISIBLE_F, [hl]
	jp ObjCheckFloorOrDrop

.State29:
	ld a, [wCurObjScreenYPos]
	cp $50
	jp c, VanishObject2
	ld hl, wCurObjState
	ld a, $59
	ld [hld], a
	ld b, $02
	jr .asm_50a13

.State28:
	ld a, [wCurObjScreenYPos]
	cp $50
	jp c, VanishObject2
	ld hl, wCurObjState
	ld a, $58
	ld [hld], a
	ld b, $02
	jr .asm_50a13

.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, $34
	ld [hld], a
	ld b, $02
	jr .asm_50a13

.AttackedRightStart:
	ld hl, wCurObjState
	ld a, $35
	ld [hld], a
	ld b, $02
.asm_50a13
	dec l
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.PickedUpLeftStart:
	ld hl, wCurObjState
	ld a, $36
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $c0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpLeft

.PickedUpRightStart:
	ld hl, wCurObjState
	ld a, $37
	ld [hld], a
	dec l
	ld a, $41
	ld [hld], a
	ld a, $e0
	ld [hld], a
	ld a, $01
	ld [hld], a
	jp ObjState_PickedUpRight

.State19:
	ld hl, wCurObjState
	ld a, $49
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
.State49:
	ld a, [wDirection]
	and a
	jp nz, ObjState_GrabbedRight
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	jr .State18
.State18:
	ld hl, wCurObjState
	ld a, $48
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
.State48:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	jp .State19
.State12:
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, $42
	ld [hld], a ; OBJ_STATE
	dec l
	xor a
	ld [hld], a
	ret

AnonsteWaveLFunc_Left:
	call MoveObjectLeft_Fast
	jr AnonsteWaveFunc
AnonsterWaveFunc_Right:
	call MoveObjectRight_Fast
AnonsteWaveFunc:
	ld a, [wCurObjState]
	and a
	jp nz, AnonsterSilkFunc.destroy
	ret

UpdateAnonsterPal:
	ld a, [wCurObjSubState]
	and $0f
	cp $03
	jr nz, .asm_50aa4
	ld hl, .green_pal
	jr .got_pal
.asm_50aa4
	cp $02
	ret nz
	ld hl, .red_pal
.got_pal
	ld de, wTempPals2 palette 7
	ld c, 7
	ld b, 1
	jp CopyAndApplyOBPals

.green_pal:
	rgb  0, 20, 12
	rgb  0, 31,  5
	rgb  0, 11,  0
	rgb  1,  0,  0

.red_pal:
	rgb  0, 20, 12
	rgb 31,  0,  0
	rgb 14,  0,  0
	rgb  1,  0,  0
