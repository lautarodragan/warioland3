YellowBellyBodyFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.IntroFade1)
	ld [hld], a
	ld a, LOW(.IntroFade1)
	ld [hld], a
	ld de, YellowBellyFrameset_69780
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [hl]
	and $f0
	or $04
	ld [hl], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld a, $0a
	ld [hl], a
	xor a
	ld [wDollBoyActiveBarrels], a
	ld [w1d147], a
	ld [wDollBoyHammerRange], a
	ld a, TRUE
	ld [wIsBossBattle], a
	stop_music2
	ret

.IntroFade1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.IntroFade2)
	ld [hld], a
	ld a, LOW(.IntroFade2)
	ld [hld], a
	play_sfx SFX_BOSS_APPEAR
	ld hl, YellowBellyPals_51c81
	jr .set_pals

.IntroFade2:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.IntroFade3)
	ld [hld], a
	ld a, LOW(.IntroFade3)
	ld [hld], a
	ld hl, YellowBellyPals_51c99
	jr .set_pals
.IntroFade3:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartFight)
	ld [hld], a
	ld a, LOW(.StartFight)
	ld [hld], a
	ld hl, YellowBellyPals_51cb1
.set_pals
	ld de, wTempPals2 palette 4
	ld c, 4
	ld b, 3
	jp CopyAndApplyOBPals

.StartFight:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $20
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.RiseAndSpawnHead)
	ld [hld], a
	ld a, LOW(.RiseAndSpawnHead)
	ld [hld], a
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic
	ret

.RiseAndSpawnHead:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectUp_Slow
	ld b, $03
	ldh a, [rDIV]
	and $01
	add b
	ld [hli], a
	xor a
	ld [hli], a
	ld a, $01
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Swim)
	ld [hld], a
	ld a, LOW(.Swim)
	ld [hld], a
	ld bc, ObjParams_YellowBellyHead
	jp CreateObjectFromCurObjPos

.start_shooting
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ShootArrows)
	ld [hld], a
	ld a, LOW(.ShootArrows)
	ld [hld], a
	ld a, [wDollBoyHammerRange]
	and a
	jr z, .aim_at_wario
	xor a
	ld [wCurObjVar1], a
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .shoot_right
	jr .shoot_left
.aim_at_wario
	ld l, OBJ_X_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, [wWarioXPos + 0]
	ld b, a
	ld a, [wWarioXPos + 1]
	ld c, a
	ld a, b
	cp d
	jr c, .wario_to_left
	jr nz, .wario_to_right
	ld a, c
	cp e
	jr c, .wario_to_left
.wario_to_right
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .shoot_right
	ld de, YellowBellyFrameset_697b0
	jr .turn_to_wario
.shoot_right
	ld de, YellowBellyFrameset_697a1
	jr .set_shoot_frameset
.wario_to_left
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr z, .shoot_left
	ld de, YellowBellyFrameset_697bb
.turn_to_wario
	call SetObjectFramesetPtr
	inc l
	ld a, $44
	ld [hl], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_VDIR | OBJSUBFLAG_HDIR
	ld [hl], a
	ret
.shoot_left
	ld de, YellowBellyFrameset_69792
.set_shoot_frameset
	call SetObjectFramesetPtr
	ld a, $62
	ld [hli], a
	ret

.ShootArrows:
	ld a, [w1d147]
	and a
	jp nz, .hit
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .shooting
	dec [hl]
	ret nz
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .after_turn_right
	ld de, YellowBellyFrameset_69792
	jr .set_after_turn_frameset
.after_turn_right
	ld de, YellowBellyFrameset_697a1
.set_after_turn_frameset
	call SetObjectFramesetPtr
	ld a, $62
	ld [hli], a
	ret
.shooting
	dec l
	dec [hl]
	jr z, .end_shooting
	ld a, [hl]
	cp $2f
	ret nz
	play_sfx SFX_BEAM
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .arrow_right
	ld bc, ObjParams_YellowBellyArrowLeft
	jp CreateObjectAtRelativePos
.arrow_right
	ld bc, ObjParams_YellowBellyArrowRight
	jp CreateObjectAtRelativePos
.end_shooting
	ld a, [wDollBoyHammerRange]
	and a
	jr nz, .start_guard_pump
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Swim)
	ld [hld], a
	ld a, LOW(.Swim)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld l, OBJ_STATE_DURATION
	ld b, $03
	ldh a, [rDIV]
	and $01
	add b
	ld [hli], a
	inc l
	ld a, $01
	ld [hli], a
	ld [hli], a
	xor a
	ld [wCurObjState], a
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .swim_facing_right
	ld de, YellowBellyFrameset_697e6
	jp SetObjectFramesetPtr
.swim_facing_right
	ld de, YellowBellyFrameset_697eb
	jp SetObjectFramesetPtr
.start_guard_pump
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.GuardPump)
	ld [hld], a
	ld a, LOW(.GuardPump)
	ld [hld], a
	ld l, OBJ_STATE_DURATION
	ld a, $03
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a
	ld a, $02
	ld [hli], a
	xor a
	ld [wCurObjState], a
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .guard_facing_right
	ld de, YellowBellyFrameset_69780
	jp SetObjectFramesetPtr
.guard_facing_right
	ld de, YellowBellyFrameset_69789
	jp SetObjectFramesetPtr

.release_pump
	stop_sfx
	ld a, $01
	ld [wDollBoyHammerRange], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.ReleasePump)
	ld [hld], a
	ld a, LOW(.ReleasePump)
	ld [hld], a
	ld l, OBJ_FLAGS
	res OBJFLAG_PRIORITY_F, [hl]
	ld a, $a6
	ld [wCurObjVar1], a
	ld de, YellowBellyFrameset_697c6
	jp SetObjectFramesetPtr

.ReleasePump:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjVar1]
	cp $a6
	jr nz, .check_defeat_sfx
	play_sfx SFX_VANISH
	jr .reload_timer
.check_defeat_sfx
	cp $88
	jr nz, .check_spawn_pump
	play_sfx SFX_BOSS_DEFEATED
	jr .reload_timer
.check_spawn_pump
	cp $25
	jr nz, .check_rise
	play_sfx SFX_YELLOW_BELLY_SPAWN_PUMP
	ld bc, ObjParams_Pump
	call CreateObjectFromCurObjPos
.reload_timer
	ld a, [wCurObjVar1]
.check_rise
	cp $92
	jr nc, .count_down
	ld a, [wCurObjScreenYPos]
	cp $39
	call nc, MoveObjectUp
.count_down
	ld hl, wCurObjVar1
	dec [hl]
	jp z, .end_shooting
	ld a, [hl]
	cp $37
	ret c
	jr z, .normal_pals
	and $0f
	jr z, .normal_pals
	cp $08
	ret nz
	ld hl, YellowBellyPals_51cc9
	jr .apply_flash_pals
.normal_pals
	ld hl, YellowBellyPals_51cb1
.apply_flash_pals
	ld de, wTempPals2 palette 4
	ld c, 4
	ld b, 3
	jp CopyAndApplyOBPals

.GuardPump:
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr nz, .guard
	xor a
	ld [wDollBoyHammerRange], a
	jp .end_shooting
.guard
	ld a, [w1d147]
	and a
	jp nz, .hit
	ld a, [wDollBoyHammerRange]
	and a
	jp z, .end_shooting
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.find_pump_loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp PUMP
	jr nz, .find_pump_next
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .found_pump
.find_pump_next
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .find_pump_loop
.found_pump
	inc l
	inc l
	inc l
	inc l
	ld a, [hli]
	and $fe
	ld e, a
	ld d, [hl]
	ld hl, wCurObjXPos
	ld a, [hli]
	and $fe
	ld c, a
	ld b, [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .target_right
	ld a, c
	sub $38
	ld c, a
	ld a, b
	sbc $00
	ld b, a
	jr .compare_target
.target_right
	ld a, c
	add $38
	ld c, a
	ld a, b
	adc $00
	ld b, a
.compare_target
	ld a, e
	cp c
	jr nz, .move_to_pump
	ld a, d
	cp b
	jp z, .start_shooting
.move_to_pump
	ld a, $02
	ld [wCurObjVar2], a
	jr .check_state

.Swim:
	ld a, [wDollBoyActiveBarrels]
	and a
	jr z, .check_hit
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	xor a
	ld [wCurObjState], a
	ret
.check_hit
	ld a, [w1d147]
	and a
	jp nz, .hit
	ld hl, wCurObjVar1
	ld a, [hli]
	and a
	jr nz, .bob
	inc l
	ld a, [hl]
	dec a
	jr nz, .bob
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	sub b
	jr c, .bob
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Sink)
	ld [hld], a
	ld a, LOW(.Sink)
	ld [hld], a
	ret
.bob
	ld bc, YellowBellyData_60950
	call ApplyObjYMovement_Loop
.check_state
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .turn_timer
	cp $0a
	jp z, .release_pump
	xor a
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	ld c, a
	ld a, [hl]
	rlca
	jr c, .check_facing_right
	ld a, c
	cp b
	jr c, .speed_up
	jr .reverse
.check_facing_right
	ld a, b
	cp c
	jr c, .speed_up
.reverse
	ld a, [hl]
	xor $80
	ld [hl], a
.speed_up
	ld a, $02
	ld [wCurObjVar2], a
.turn_timer
	ld l, OBJ_VAR_1
	ld a, [hl]
	and a
	jr z, .swim_move
	dec [hl]
	ret nz
	ld a, [wGlobalCounter]
	rra
	jr c, .end_turn
	dec l
	ld a, [hl]
	cp $02
	jr c, .end_turn
	dec [hl]
.end_turn
	ld l, OBJ_SUBSTATE
	ld a, [wDollBoyHammerRange]
	dec a
	jr z, .pump_out_frameset
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .swim_frameset_right
	ld de, YellowBellyFrameset_697e6
	jp SetObjectFramesetPtr
.swim_frameset_right
	ld de, YellowBellyFrameset_697eb
	jp SetObjectFramesetPtr
.pump_out_frameset
	play_sfx SFX_CHOP_TREE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .pump_out_frameset_right
	ld de, YellowBellyFrameset_69780
	jp SetObjectFramesetPtr
.pump_out_frameset_right
	ld de, YellowBellyFrameset_69789
	jp SetObjectFramesetPtr
.swim_move
	ld l, OBJ_VAR_3
	ld a, [hl]
	dec a
	jr nz, .move_horizontal
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .move_horizontal
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	sub b
	jr nc, .move_horizontal
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jp z, .start_shooting
	play_sfx SFX_YELLOW_BELLY
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
	sub $18
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeftByVar2
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .flip
	ld de, YellowBellyFrameset_697b0
	jr .turn_at_wall
.move_right
	ld a, [hli]
	add $18
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRightByVar2
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr z, .flip
	ld de, YellowBellyFrameset_697bb
.turn_at_wall
	call SetObjectFramesetPtr
	inc l
	ld a, $44
	ld [hl], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_VDIR | OBJSUBFLAG_HDIR
	jr .set_direction
.flip
	ld a, [hl]
	xor $80
.set_direction
	ld [hl], a
	ld a, $01
	ld [wCurObjVar2], a
	ret

.Sink:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjScreenXPos]
	cp $c8
	ret nc
	jp MoveObjectDown

.hit
	xor a
	ld [w1d147], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.HitFlash)
	ld [hld], a
	ld a, LOW(.HitFlash)
	ld [hld], a
	call DecrementRemainingBossHits
	ld a, [hl]
	and $0f
	dec a
	jr z, .last_hit
	ld de, YellowBellyFrameset_697d5
	call SetObjectFramesetPtr
	ld a, $64
	ld [hli], a
	ld a, $01
	ld [hl], a
	ret
.last_hit
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Defeated)
	ld [hld], a
	ld a, LOW(.Defeated)
	ld [hld], a
	ld de, YellowBellyFrameset_69845
	call SetObjectFramesetPtr
	ld a, $65
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hli], a
	play_sfx SFX_BOSS_DEFEATED
	stop_music2
	ret

.HitFlash:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .flash_done
	dec [hl]
	jr z, .end_flash
	ld a, [hl]
	and $0f
	jr z, .hit_normal_pals
	cp $08
	ret nz
	ld hl, YellowBellyPals_51ce1
	jr .apply_hit_pals
.end_flash
	play_sfx SFX_PESCE_3_YB_2
.hit_normal_pals
	ld hl, YellowBellyPals_51cb1
.apply_hit_pals
	ld de, wTempPals2 palette 4
	ld c, 4
	ld b, 3
	jp CopyAndApplyOBPals
.flash_done
	dec l
	ld a, [hld]
	cp $10
	ret nz
	ld a, [hld]
	and a
	ret nz
	xor a
	ld [wCurObjVar1], a
	call .end_shooting
	ld a, [wCurObjSubState]
	and $0f
	cp $03
	jr z, .head_oam_3
	cp $02
	jr z, .head_oam_2
	ret
.head_oam_3
	ld de, OAM_191940
	jr .set_oam
.head_oam_2
	ld de, YellowBellyOAM_191f04
.set_oam
	ld l, OBJ_OAM_PTR
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

.Defeated:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .defeat_anim
	dec [hl]
	jr z, .defeat_normal_pals
	ld a, [hl]
	and $0f
	jr z, .defeat_normal_pals
	cp $08
	ret nz
	ld hl, YellowBellyPals_51ce1
	jr .apply_defeat_pals
.defeat_normal_pals
	ld hl, YellowBellyPals_51cb1
.apply_defeat_pals
	ld de, wTempPals2 palette 4
	ld c, 4
	ld b, 3
	jp CopyAndApplyOBPals
.defeat_anim
	dec l
	ld a, [hld]
	cp $14
	jr nz, .check_defeat_end
	ld a, [hld]
	and a
	play_sfx z, SFX_WOLFENBOSS_SMOKE
.check_defeat_end
	ld l, OBJ_FRAMESET_OFFSET
	ld a, [hld]
	cp $20
	ret nz
	ld a, [hld]
	and a
	ret nz
	xor a
	ld [wCurObjFlags], a
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.find_platform_loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp YELLOW_BELLY_PLATFORM
	jr nz, .find_platform_next
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .found_platform
.find_platform_next
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .find_platform_loop
.found_platform
	ld a, l
	add $1a
	ld l, a
	ld a, $2f
	ld [hl], a
	jp SetObjMapEntry7_YellowBelly

PumpFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Fall)
	ld [hld], a
	ld a, LOW(.Fall)
	ld [hld], a
	ld a, [wGlobalCounter]
	ld [wCurObjVar1], a
.Fall:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld bc, YellowBellyData_609e0
	call ApplyObjYMovement
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .check_floor
	dec [hl]
	jr .drift
.check_floor
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
	jr nz, .landed
.drift
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjVar1]
	rra
	jr c, .drift_right
	ld a, [hli]
	sub $06
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	jp MoveObjectLeft_Slow
.drift_right
	ld a, [hli]
	add $05
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	ret nz
	jp MoveObjectRight_Slow
.landed
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld de, YellowBellyFrameset_6987f
	call SetObjectFramesetPtr
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.OnFloor)
	ld [hld], a
	ld a, LOW(.OnFloor)
	ld [hld], a
	xor a
	ld [wCurObjState], a
	ld l, OBJ_FLAGS
	res OBJFLAG_PRIORITY_F, [hl]
	ret

.OnFloor:
	ld hl, wCurObjState
	ld a, [hl]
	cp $31
	jr z, .walk
	cp $0a
	jp z, .pressed
	cp $3a
	jp z, .pressed_wait
	cp $58
	jp z, .knocked
	and $fe
	ret z
	cp $28
	jp z, .start_knocked
	ld a, $31
	ld [hld], a
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .wario_to_right
	set OBJSUBFLAG_HDIR_F, [hl]
	jr .start_walk
.wario_to_right
	res OBJSUBFLAG_HDIR_F, [hl]
.start_walk
	xor a
	ld [wCurObjVar2], a
	ld a, $3c
	ld [wCurObjStateDuration], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret
.walk
	ld hl, wCurObjStateDuration
	dec [hl]
	jr nz, .walk_move
	xor a
	ld [wCurObjState], a
	ret
.walk_move
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .walk_right
	ld a, [hli]
	sub $06
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .blocked_left
.move_left
	ld bc, YellowBellyData_60a00
	jp ApplyObjXMovement
.blocked_left
	ld hl, wCurObjSubState
	set 7, [hl]
	jr .move_right
.walk_right
	ld a, [hli]
	add $05
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jr nz, .blocked_right
.move_right
	ld bc, YellowBellyData_60a10
	jp ApplyObjXMovement
.blocked_right
	ld hl, wCurObjSubState
	res 7, [hl]
	jr .move_left

.pressed
	ld a, $3a
	ld [hl], a
	ld [w1d147], a
	xor a
	ld [wDollBoyHammerRange], a
	ld de, YellowBellyFrameset_69882
	call SetObjectFramesetPtr
	ld a, $1d
	ld [hli], a
	xor a
	ld [wCurObjVar3], a
	play_sfx SFX_PUMP
	ret

.pressed_wait
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .drop
	dec [hl]
	ret
.drop
	ld bc, DropYVel_Light
	jp ApplyObjYMovement

.start_knocked
	ld a, $58
	ld [hl], a
	xor a
	ld [wDollBoyHammerRange], a
.knocked
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjScreenYPos]
	cp $48
	jr nc, .follow_arrow
	xor a
	ld [wCurObjFlags], a
	ret

.follow_arrow
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp YELLOW_BELLY_ARROW_LEFT ; YELLOW_BELLY_ARROW_RIGHT
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .found_arrow
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_arrow
	inc l
	inc l
	ld a, [hli]
	add $08
	ld [wCurObjYPos + 0], a
	ld a, [hli]
	adc $00
	ld [wCurObjYPos + 1], a
	ld a, [hli]
	ld [wCurObjXPos + 0], a
	ld a, [hl]
	ld [wCurObjXPos + 1], a
	ret

YellowBellyArrowFunc:
.Left:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.FlyLeft)
	ld [hld], a
	ld a, LOW(.FlyLeft)
	ld [hld], a
	ld a, [wDollBoyHammerRange]
	and a
	jr z, .FlyLeft
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
	ld a, $02
	ld [wCurObjVar2], a
.FlyLeft:
	call .CheckPastWario
	ld a, [wCurObjState]
	cp $28
	jr z, .knocked_right
	cp $29
	jr z, .knocked_right
	and a
	jr nz, .hit_wario
	call MoveObjectDownByVar2
	ld a, [wDollBoyHammerRange]
	and a
	jp z, MoveObjectLeftByVar2
	jp MoveObjectLeft
.knocked_right
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.KnockedAwayRight)
	ld [hld], a
	ld a, LOW(.KnockedAwayRight)
	ld [hld], a
	ld a, $04
	ld [wCurObjVar2], a
	ret
.KnockedAwayRight:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjScreenYPos]
	cp $40
	jr nc, .fly_away_right
	xor a
	ld [wCurObjFlags], a
	ret
.fly_away_right
	call MoveObjectUpByVar2
	jp MoveObjectRight_Fast

.Right:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.FlyRight)
	ld [hld], a
	ld a, LOW(.FlyRight)
	ld [hld], a
	ld a, [wDollBoyHammerRange]
	and a
	jr z, .FlyRight
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
	ld a, $02
	ld [wCurObjVar2], a
.FlyRight:
	call .CheckPastWario
	ld a, [wCurObjState]
	cp $28
	jr z, .knocked_left
	cp $29
	jr z, .knocked_left
	and a
	jr nz, .hit_wario
	call MoveObjectDownByVar2
	ld a, [wDollBoyHammerRange]
	and a
	jp z, MoveObjectRightByVar2
	jp MoveObjectRight
.hit_wario
	ld a, $1e
	ld [wCurObjStateDuration], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitAndDespawn)
	ld [hld], a
	ld a, LOW(.WaitAndDespawn)
	ld [hld], a
	stop_music2
	xor a
	ld [wBossState], a
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
.knocked_left
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.KnockedAwayLeft)
	ld [hld], a
	ld a, LOW(.KnockedAwayLeft)
	ld [hld], a
	ld a, $04
	ld [wCurObjVar2], a
	ret

.KnockedAwayLeft:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjScreenYPos]
	cp $40
	jr nc, .fly_away_left
	xor a
	ld [wCurObjFlags], a
	ret
.fly_away_left
	call MoveObjectUpByVar2
	jp MoveObjectLeft_Fast

.CheckPastWario:
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	cp b
	jr nc, .past_wario
	ld a, [wCurObjSubState]
	rlca
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wCurObjScreenXPos]
	jr c, .flying_right
	cp b
	jr c, .past_wario
	ret
.flying_right
	cp b
	ret c
.past_wario
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

YellowBellyHeadFunc:
	ld hl, wCurObjFlags
	set OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
.Update:
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr nz, .check_hit
	ld a, no_actions_for 1
	ld [wCurObjAction], a
.check_hit
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .hit_timer
	xor a
	ld [hl], a
	ld a, $1e
	ld [wCurObjStateDuration], a
	ld a, $01
	ld [wDollBoyActiveBarrels], a
	stop_music2
	xor a
	ld [wBossState], a
.hit_timer
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .find_body
	dec [hl]
	jr nz, .find_body
	xor a
	ld [wDollBoyActiveBarrels], a
.find_body
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp YELLOW_BELLY_BODY
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .found_body
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_body
	inc l
	inc l
	ld a, [hli]
	add $10
	ld [wCurObjYPos + 0], a
	ld a, [hli]
	adc $00
	ld [wCurObjYPos + 1], a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld a, l
	add OBJ_VAR_1 - (OBJ_X_POS + 1)
	ld l, a
	ld a, [hli] ; OBJ_VAR_1
	and a
	jr z, .follow
	inc a
	jr z, .despawn
	ld a, no_actions_for 1
	ld [wCurObjAction], a
.follow
	inc l
	inc l
	bit OBJSUBFLAG_VDIR_F, [hl]
	ld hl, wCurObjXPos
	ld a, e
	jr nz, .follow_right
	sub $08
	ld [hli], a
	ld a, d
	sbc $00
	ld [hl], a
	ret
.follow_right
	add $08
	ld [hli], a
	ld a, d
	adc $00
	ld [hl], a
	ret
.despawn
	xor a
	ld [wCurObjFlags], a
	ret

YellowBellyPlatformFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set 3, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitForDefeat)
	ld [hld], a
	ld a, LOW(.WaitForDefeat)
	ld [hld], a
	ld de, YellowBellyFrameset_69893
	call SetObjectFramesetPtr
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $07
	ld [hld], a
	ld a, $f8
	ld [hld], a
	ld a, $f6
	ld [hl], a
	ret

.WaitForDefeat:
	ld a, [wCurObjState]
	cp $2f
	ret nz
	ld de, YellowBellyFrameset_69896
	call SetObjectFramesetPtr
	ld a, $5a
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(YellowBellyPlatform_WaitAndDespawn)
	ld [hld], a
	ld a, LOW(YellowBellyPlatform_WaitAndDespawn)
	ld [hld], a
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
;	fallthrough

SetObjMapEntry7_YellowBelly:
	ld hl, wCurObjUnk02
	ld e, $07
	farcall SetObjectMapEntryAndSpawn
	ret

YellowBellyPlatform_WaitAndDespawn:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ret

YellowBellyPals_51c81:
	rgb  0, 25,  1
	rgb  8,  8,  7
	rgb  9,  5,  0
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb  8,  8,  7
	rgb  0,  5,  9
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb  4,  2,  0
	rgb  9,  5,  0
	rgb  0,  0,  0

YellowBellyPals_51c99:
	rgb  0, 25,  1
	rgb 17, 17, 17
	rgb 20, 10,  0
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb 17, 17, 17
	rgb  0, 10, 20
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb 11,  5,  0
	rgb 20, 10,  0
	rgb  0,  0,  0

YellowBellyPals_51cb1:
	rgb  0, 25,  1
	rgb 31, 31, 28
	rgb 31, 15,  0
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb 31, 31, 28
	rgb  0, 17, 31
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb 17,  5,  0
	rgb 31, 15,  0
	rgb  0,  0,  0

YellowBellyPals_51cc9:
	rgb  0, 25,  1
	rgb 31, 15, 15
	rgb  0, 15, 31
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb 15, 31, 15
	rgb 30, 30,  0
	rgb  0,  0,  0

	rgb  0, 25,  1
	rgb  0,  5, 17
	rgb  0, 15, 31
	rgb  0,  0,  0

YellowBellyPals_51ce1:
	rgb  0, 25,  1
	rgb 31, 31, 31
	rgb 17, 31, 17
	rgb 31,  0,  0

	rgb  0, 25,  1
	rgb 31, 31, 31
	rgb 31, 31, 15
	rgb 31,  0,  0

	rgb  0, 25,  1
	rgb  0, 25,  0
	rgb 17, 31, 17
	rgb 31,  0,  0
