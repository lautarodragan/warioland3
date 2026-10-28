StrongWaterCurrentFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DoNothing)
	ld [hld], a
	ld a, LOW(.DoNothing)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0f
	ld [hld], a
	ld a, $f0
	ld [hld], a
	ld a, $fe
	ld [hl], a
	ld de, PesceFrameset_69965
	call SetObjectFramesetPtr
	ld a, $2a
	ld [wCurObjVar2], a
	call MoveObjectDownByVar2
	ld a, $69
	ld [wCurObjVar2], a
	jp MoveObjectLeftByVar2

.DoNothing:
	ret

PesceFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0f
	ld [hld], a
	ld a, $f0
	ld [hld], a
	ld a, $fe
	ld [hl], a
	ld de, PesceFrameset_6990a
	call SetObjectFramesetPtr
	xor a
	ld [wPesceHits], a
	ld [wPesceFightOver], a
	ld [hli], a
	ld [hli], a
	ld a, $0a
	ld [hli], a
	xor a
	ld [hl], a
	call MoveObjectDownByVar2
	ld a, $3c
	ld [wCurObjVar2], a
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic
	ld a, TRUE
	ld [wIsBossBattle], a
	ret

.hit
	xor a
	ld [hl], a
	ld [wCurObjStateDuration], a
	play_sfx SFX_PESCE_HIT
	ld hl, wPesceHits
	inc [hl]
	ld a, [hl]
	cp $01
	jr z, .hit_1
	cp $02
	jr z, .hit_2
	cp $03
	jr z, .hit_3
	xor a
	ld [hl], a
	ld a, $f2
	jr .set_collbox_top
.hit_1
	ld a, $ef
	jr .set_collbox_top
.hit_2
	ld a, $eb
.set_collbox_top
	ld [wCurObjCollBoxTop], a
	jp .back_to_swim
.hit_3
	ld a, $e6
	ld [wCurObjCollBoxTop], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Defeated)
	ld [hld], a
	ld a, LOW(.Defeated)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_KNOCK_BACK_TOP_RIGHT
	ld [hld], a
	stop_music2
	jp .back_to_swim

.catch_wario
	stop_music2
	play_sfx SFX_FAT_WALK
	xor a
	ld [hl], a
	ld l, OBJ_Y_POS
	ld a, [hli]
	add $04
	ld [wWarioYPos + 1], a
	ld a, [hli]
	adc $00
	ld [wWarioYPos + 0], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .catch_facing_right
	ld a, [hli]
	sub $14
	ld [wWarioXPos + 1], a
	ld a, [hl]
	sbc $00
	ld [wWarioXPos + 0], a
	ld de, PesceFrameset_6992d
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld a, $03
	ld [hl], a
	ret
.catch_facing_right
	ld a, [hli]
	ld [wWarioXPos + 1], a
	ld a, [hl]
	ld [wWarioXPos + 0], a
	ld de, PesceFrameset_69a15
	call SetObjectFramesetPtr
	ld a, $0d
	ld [hli], a
	ld a, $02
	ld [hl], a
	ld a, TRUE
	ld [wIsTurning], a
	ret

.Update:
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_STATE
	ld a, [hl]
	and a
	jr z, .dispatch_phase
	cp OBJSTATE_ACTIVATE
	jr z, .catch_wario
	and $fe
	cp OBJSTATE_WOBBLE_LEFT_START ; or OBJSTATE_WOBBLE_RIGHT_START
	jp z, .hit
	xor a
	ld [hl], a
.dispatch_phase
	ld l, OBJ_VAR_1
	ld a, [hl]
	and a
	jp z, .swim
	cp $01
	jp z, .lunge
	cp $02
	jr z, .turn_with_wario
	cp $03
	jr z, .drag_wario_down
	cp $04
	jr z, .idle
	cp $05
	jr z, .eat_bait
	ret
.eat_bait
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jp nz, .swim_forward
.back_to_swim
	xor a
	ld [wCurObjVar1], a
	jp .set_swim_frameset
.turn_with_wario
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld l, OBJ_X_POS
	ld a, [hli]
	sub $14
	ld [wWarioXPos + 1], a
	ld a, [hl]
	sbc $00
	ld [wWarioXPos + 0], a
	ld de, PesceFrameset_6992d
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld a, $03
	ld [hl], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_HDIR_F, [hl]
	ret
.idle
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret
.drag_wario_down
	ld a, [wGlobalCounter]
	and %1011111
	play_sfx z, SFX_WATER_SURFACE
	ld l, OBJ_STATE_DURATION
	ld a, [hl]
	and a
	jr z, .sink_with_wario
	dec [hl]
	ret
.sink_with_wario
	ld l, OBJ_Y_POS
	ld a, [hli]
	add $06
	ldh [hYPosLo], a
	ld a, [hli]
	adc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .release_wario
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld b, $01
	call MoveWarioDown
	jp MoveObjectDown
.release_wario
	xor a
	ld [wAutoMoveState], a
	play_sfx SFX_PESCE_3_YB_2
	ld hl, wCurObjVar1
	ld a, $04
	ld [hli], a
	ld [hl], a
	call MoveObjectUpByVar2
	ld a, [wCurObjSubState]
	rlca
	jr c, .release_facing_right
	ld de, PesceFrameset_6990a
	jp SetObjectFramesetPtr
.release_facing_right
	ld de, PesceFrameset_69942
	jp SetObjectFramesetPtr

.lunge
	ld a, [wCurObjFramesetOffset]
	cp $02
	jr nz, .lunge_rise
	ld a, [wCurObjFrameDuration]
	cp $01
	play_sfx z, SFX_PESCE_1
.lunge_rise
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
	jr z, .swim_forward
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wCurObjScreenYPos]
	cp b
	jr c, .swim_forward
	ld a, [wGlobalCounter]
	and %11
	jr nz, .swim_forward
	ld hl, wCurObjVar3
	inc [hl]
	call MoveObjectUp
.swim_forward
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .swim_forward_right
	ld a, [hli]
	sub $10
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft
	jr .lunge_timer
.swim_forward_right
	ld a, [hli]
	add $0f
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight
.lunge_timer
	ld hl, wCurObjVar2
	dec [hl]
	ret nz
	ld a, $3c
	ld [hld], a
	xor a
	ld [hl], a
	jp .turn_around

.swim
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .swim_patrol
	dec [hl]
	ret nz
	jp .set_swim_frameset
.swim_patrol
	ld l, OBJ_VAR_3
	ld a, [hl]
	and a
	jr z, .check_wario
	ld a, [wGlobalCounter]
	rra
	jr c, .swim_horizontally
	dec [hl]
	call MoveObjectDown
.swim_horizontally
	ld a, [wCurObjSubState]
	rlca
	jr nc, .look_for_bait_left
	jr .look_for_bait_right
.check_wario
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	ld c, a
	ld a, [wCurObjSubState]
	rlca
	jr c, .check_wario_right_side
	ld a, [wWaterInteraction]
	and a
	jr z, .look_for_bait_left
	ld a, c
	cp b
	jp nc, .start_lunge
.look_for_bait_left
	call .FindBait
	ld a, d
	cp $d0
	jr z, .swim_left
	ld c, $2a
	add c
	ld d, a
	ld a, [wCurObjScreenYPos]
	add c
	cp d
	jr c, .swim_left
	sub d
	cp $18
	jr nc, .swim_left
	ld a, e
	add c
	ld e, a
	ld a, [wCurObjScreenXPos]
	add $0a
	sub e
	cp $30
	jp c, .start_eat_bait
.swim_left
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $10
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Slow
	jr .turn_timer
.check_wario_right_side
	ld a, [wWaterInteraction]
	and a
	jr z, .look_for_bait_right
	ld a, c
	cp b
	jp c, .start_lunge
.look_for_bait_right
	call .FindBait
	ld a, d
	cp $d0
	jr z, .swim_right
	ld c, $2a
	add c
	ld d, a
	ld a, [wCurObjScreenYPos]
	add c
	cp d
	jr c, .swim_right
	sub d
	cp $18
	jr nc, .swim_right
	ld a, [wCurObjScreenXPos]
	add $4a
	ld b, a
	ld a, e
	add c
	sub b
	cp $30
	jp c, .start_eat_bait
.swim_right
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $0f
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectRight_Slow
.turn_timer
	ld hl, wCurObjVar2
	dec [hl]
	ret nz
	ld a, $3c
	ld [hl], a
.turn_around
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ld b, a
	ld a, [wPesceHits]
	cp $01
	jr z, .turn_hits_1
	cp $02
	jr z, .turn_hits_2
	cp $03
	jr z, .turn_hits_3
	xor a
	ld [wPesceHits], a
	ld c, $17
	sla b
	jr c, .turn_hits_0_right
	ld de, PesceFrameset_69981
	jr .set_turn_frameset
.turn_hits_0_right
	ld de, PesceFrameset_6997a
	jr .set_turn_frameset
.turn_hits_1
	ld c, $1b
	sla b
	jr c, .turn_hits_1_right
	ld de, PesceFrameset_6998f
	jr .set_turn_frameset
.turn_hits_1_right
	ld de, PesceFrameset_69988
	jr .set_turn_frameset
.turn_hits_2
	ld c, $1f
	sla b
	jr c, .turn_hits_2_right
	ld de, PesceFrameset_6999d
	jr .set_turn_frameset
.turn_hits_2_right
	ld de, PesceFrameset_69996
	jr .set_turn_frameset
.turn_hits_3
	ld c, $25
	sla b
	ld_obj_frameset PesceFrameset_699ab, PesceFrameset_699a4
.set_turn_frameset
	call SetObjectFramesetPtr
	ld [hl], c
	ret

.start_lunge
	ld a, $01
	ld [wCurObjVar1], a
	ld a, [wCurObjSubState]
	ld b, a
	ld a, [wPesceHits]
	cp $01
	jr z, .lunge_hits_1
	cp $02
	jr z, .lunge_hits_2
	xor a
	ld [wPesceHits], a
	sla b
	jr c, .lunge_hits_0_right
	ld de, PesceFrameset_69911
	jr .set_lunge_frameset
.lunge_hits_0_right
	ld de, PesceFrameset_69949
	jr .set_lunge_frameset
.lunge_hits_1
	sla b
	jr c, .lunge_hits_1_right
	ld de, PesceFrameset_69934
	jr .set_lunge_frameset
.lunge_hits_1_right
	ld de, PesceFrameset_6996c
	jr .set_lunge_frameset
.lunge_hits_2
	sla b
	ld_obj_frameset PesceFrameset_6993b, PesceFrameset_69973
.set_lunge_frameset
	jp SetObjectFramesetPtr

.start_eat_bait
	play_sfx SFX_PESCE_2
	ld a, [wCurObjSubState]
	ld b, a
	ld a, [wPesceHits]
	cp $01
	jr z, .bite_hits_1
	cp $02
	jr z, .bite_hits_2
	xor a
	ld [wPesceHits], a
	sla b
	jr c, .bite_hits_0_right
	ld de, PesceFrameset_699b2
	jr .set_bite_frameset
.bite_hits_0_right
	ld de, PesceFrameset_699c1
	jr .set_bite_frameset
.bite_hits_1
	sla b
	jr c, .bite_hits_1_right
	ld de, PesceFrameset_699b7
	jr .set_bite_frameset
.bite_hits_1_right
	ld de, PesceFrameset_699c6
	jr .set_bite_frameset
.bite_hits_2
	sla b
	ld_obj_frameset PesceFrameset_699bc, PesceFrameset_699cb
.set_bite_frameset
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld a, $05
	ld [hl], a
	ret

.set_swim_frameset
	ld a, [wCurObjSubState]
	ld b, a
	ld a, [wPesceHits]
	cp $01
	jr z, .swim_hits_1
	cp $02
	jr z, .swim_hits_2
	cp $03
	jr z, .swim_hits_3
	xor a
	ld [wPesceHits], a
	sla b
	jr c, .swim_hits_0_right
	ld de, PesceFrameset_6990a
	jr .apply_swim_frameset
.swim_hits_0_right
	ld de, PesceFrameset_69942
	jr .apply_swim_frameset
.swim_hits_1
	sla b
	jr c, .swim_hits_1_right
	ld de, PesceFrameset_69918
	jr .apply_swim_frameset
.swim_hits_1_right
	ld de, PesceFrameset_69950
	jr .apply_swim_frameset
.swim_hits_2
	sla b
	jr c, .swim_hits_2_right
	ld de, PesceFrameset_6991f
	jr .apply_swim_frameset
.swim_hits_2_right
	ld de, PesceFrameset_69957
	jr .apply_swim_frameset
.swim_hits_3
	sla b
	ld_obj_frameset PesceFrameset_69926, PesceFrameset_6995e
.apply_swim_frameset
	jp SetObjectFramesetPtr

.FindBait:
	xor a
	ld b, a
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp CHEESE
	jr c, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hl]
	rra
	jr c, .found_bait
.next_obj
	ld a, b
	cp LOW(wObj8)
	jr z, .no_bait
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.found_bait
	ld a, l
	add $0d
	ld l, a
	ld a, [hli]
	ld d, a
	ld e, [hl]
	ret
.no_bait
	ld d, $d0
	ld e, d
	ret

.Defeated:
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .defeated_sink
	cp $01
	jr z, .defeated_wait
	cp $02
	jr z, .defeated_swim_away
	cp $03
	jr z, .despawn
	ret
.despawn
	xor a
	ld [wCurObjFlags], a
	ret
.defeated_swim_away
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $30
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, MoveObjectLeft_Slow
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_WATER_KNOCK_BACK_TOP_RIGHT
	ld [hli], a
	ld a, $03
	ld [wCurObjVar1], a
	ld hl, wCurObjMapPtrHi
	ld e, $07
	farcall SetObjectMapEntryAndSpawn
	ld a, $01
	ld [wPesceFightOver], a
	ret
.defeated_wait
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	inc l
	ld a, $02
	ld [hl], a
	ld de, PesceFrameset_6995e
	jp SetObjectFramesetPtr
.defeated_sink
	ld l, OBJ_Y_POS
	ld a, [hli]
	add $06
	ldh [hYPosLo], a
	ld a, [hli]
	adc $00
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Landing
	and a
	jp z, MoveObjectDown_Slow
	ld a, [wCurObjSubState]
	rlca
	jr c, .defeated_landed_facing_right
	ld de, PesceFrameset_699a4
	call SetObjectFramesetPtr
	ld a, $25
	ld [hli], a
	ld a, $01
	ld [hl], a
	ret
.defeated_landed_facing_right
	ld a, $02
	ld [wCurObjVar1], a
	ret

DragonflySpawnerFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Wait)
	ld [hld], a
	ld a, LOW(.Wait)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, $3c
	ld [wCurObjStateDuration], a
	ret

.Wait:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.SpawnDragonfly)
	ld [hld], a
	ld a, LOW(.SpawnDragonfly)
	ld [hld], a
	ret

.SpawnDragonfly:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wPesceHits]
	cp $03
	jr z, .start_wait_fight_end
	xor a
	ld b, a
	ld h, HIGH(wObj1)
.loop
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp DRAGONFLY1
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	ret c
.next_obj
	ld a, b
	cp LOW(wObj8)
	jr z, .spawn_dragonfly
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop
.spawn_dragonfly
	ld bc, ObjParams_Dragonfly1
	jp CreateObjectAtRelativePos

.start_wait_fight_end
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitForFightEnd)
	ld [hld], a
	ld a, LOW(.WaitForFightEnd)
	ld [hld], a
	ret

.WaitForFightEnd:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wPesceFightOver]
	and a
	ret z
	xor a
	ld [wCurObjFlags], a
	ld hl, wCurObjMapPtrHi
	ld e, $08
	farcall SetObjectMapEntryAndSpawn
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ld a, $01
	ld [wSwitchStateUpdated], a
	ld a, $60
	ld [wSwitchState], a
	ret

Dragonfly1Func:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Descend)
	ld [hld], a
	ld a, LOW(.Descend)
	ld [hld], a
	ret

.Descend:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectDown_Fast
	ld a, $70
	ld [hli], a
	xor a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Fly)
	ld [hld], a
	ld a, LOW(.Fly)
	ld [hld], a
	ret

.Fly:
	call SetOneWayPlatformAction
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .fly
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .end_turn_right
	ld de, PesceFrameset_699d0
	jp SetObjectFramesetPtr
.end_turn_right
	ld de, PesceFrameset_699d5
	jp SetObjectFramesetPtr
.fly
	ld a, [wPesceHits]
	cp $03
	jr z, .fly_away
	dec l
	dec [hl]
	jr z, .turn_around
	ld a, [wCurObjSubState]
	rlca
	jr c, .fly_right
	call MoveObjectLeft
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	jp MoveWarioLeft
.fly_right
	call MoveObjectRight
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	jp MoveWarioRight
.turn_around
	ld a, $70
	ld [hli], a
	ld a, $11
	ld [hl], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	rlca
	jr c, .turned_right
	ld de, PesceFrameset_699df
	jp SetObjectFramesetPtr
.turned_right
	ld de, PesceFrameset_699da
	jp SetObjectFramesetPtr
.fly_away
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.FlyAway)
	ld [hld], a
	ld a, LOW(.FlyAway)
	ld [hld], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.FlyAway:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjSubState]
	rlca
	jp c, MoveObjectRight_Fast
	jp MoveObjectLeft_Fast

Dragonfly2Func:
	ld de, PesceFrameset_699d0
	call SetObjectFramesetPtr
	ld a, $28
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.WaitToAppear)
	ld [hld], a
	ld a, LOW(.WaitToAppear)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $f9
	ld [hl], a
	ld a, $40
	ld [wCurObjVar2], a
	call MoveObjectLeftByVar2
	ld a, $50
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.WaitToAppear:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $50
	ld [hli], a
	xor a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Fly)
	ld [hld], a
	ld a, LOW(.Fly)
	ld [hld], a
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ret

.Fly:
	call SetOneWayPlatformAction
	ld a, [wGlobalCounter]
	rra
	ret nc
	ld hl, wCurObjVar1
	ld a, [hl]
	and a
	jr z, .fly_down
	cp $01
	jr z, .fly_up
	ret
.fly_down
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr z, .start_up
	call MoveObjectDown
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	call MoveWarioDown
	jp HandleDownwardsFloorTransition
.start_up
	ld a, $50
	ld [hli], a
	ld a, $01
	ld [hl], a
	ret
.fly_up
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jr z, .start_down
	call MoveObjectUp
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	ld b, $01
	call MoveWarioUp
	jp HandleUpwardsFloorTransition
.start_down
	ld a, $50
	ld [hli], a
	xor a
	ld [hl], a
	ret

FlySpawnerFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitOnScreen)
	ld [hld], a
	ld a, LOW(.WaitOnScreen)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, $c8
	ld [wCurObjStateDuration], a
	ret

.WaitOnScreen:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wCurObjScreenYPos]
	cp $a0
	ret nc
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.SpawnFly)
	ld [hld], a
	ld a, LOW(.SpawnFly)
	ld [hld], a
	xor a
	ld [wPesceFlyActive], a
	ret

.SpawnFly:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wPesceHits]
	cp $03
	jr z, .start_wait_fight_end
	ld a, [wPesceFlyActive]
	and a
	ret nz
	ld a, [wTransformation]
	and a
	ret nz
	ld a, [wAutoMoveState]
	and a
	jr nz, .deactivate

	xor a ; LOW(wObj1)
	ld b, a
	ld h, HIGH(wObj1)
.loop_objs
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp FLY
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	ret c
.next_obj
	ld a, b
	cp LOW(wObj8)
	jr z, .spawn_fly
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop_objs
.spawn_fly
	ld bc, ObjParams_Fly
	jp CreateObjectAtRelativePos
.start_wait_fight_end
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.WaitForFightEnd)
	ld [hld], a
	ld a, LOW(.WaitForFightEnd)
	ld [hld], a
	ret
.deactivate
	xor a
	ld [wCurObjFlags], a
	ret

.WaitForFightEnd:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, [wPesceFightOver]
	and a
	ret z
	ld hl, wCurObjMapPtrHi
	ld e, $09
	farcall SetObjectMapEntryAndSpawn
	xor a
	ld [wCurObjFlags], a
	ret

FlyFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, $03
	ld [wPesceFlyActive], a
	play_sfx SFX_PESCE_FLY
	ld bc, ObjParams_Cheese
	jp CreateObjectFromCurObjPos

.Update:
	ld hl, wCurObjState
	ld a, [hl]
	cp OBJSTATE_5A
	jr z, .descend
	cp OBJSTATE_5B
	jr z, .hover_left
	cp OBJSTATE_5C
	jr z, .fly_up_away
	jr .hit
.descend
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_STATE_DURATION
	dec [hl]
	jp nz, MoveObjectDown
	ld a, $70
	ld [hl], a
	ld a, OBJSTATE_5B
	ld [wCurObjState], a
	ld a, $01
	ld [wPesceFlyActive], a
	ret
.hover_left
	ld bc, HoverYVel
	call ApplyObjYMovement_Loop
	ld a, [wPesceFlyActive]
	and a
	jr z, .move_left
	ld a, [wGlobalCounter]
	rra
	ret nc
.move_left
	call MoveObjectLeft
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, OBJSTATE_5C
	ld [wCurObjState], a
	ret
.fly_up_away
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jp nz, MoveObjectUp
	xor a
	ld [wCurObjFlags], a
	ld [wPesceFlyActive], a
	ret
.hit
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .knock_left
	ld a, HIGH(ObjState_HitByObjRight)
	ld c, LOW(ObjState_HitByObjRight)
	jr .set_knock_back
.knock_left
	ld a, HIGH(ObjState_HitByObjLeft)
	ld c, LOW(ObjState_HitByObjLeft)
.set_knock_back
	ld hl, wCurObjUpdateFunction + 1
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_3
	xor a
	ld [hld], a
	ld a, $01
	ld [hl], a
	ld hl, wPesceFlyActive
	ld a, [hl]
	and a
	ret z
	ld a, $02
	ld [hl], a
	ret

CheeseFunc:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjState]
	and a
	jr nz, .fly_gone
	ld a, [wPesceFlyActive]
	and a
	jr z, .despawn
	cp $02
	jr z, .drop
	cp $03
	jr nz, .find_fly_obj
	ld a, no_actions_for 1
	ld [wCurObjAction], a

.find_fly_obj
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop_objs
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp FLY
	jr nz, .next_obj
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .adjust_coord
.next_obj
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop_objs
.adjust_coord
	inc l
	inc l
	ld a, [hli] ; OBJ_Y_POS
	add $0b
	ld [wCurObjYPos + 0], a
	ld a, [hli]
	adc $00
	ld [wCurObjYPos + 1], a
	ld a, [hli] ; OBJ_X_POS
	ld [wCurObjXPos + 0], a
	ld a, [hl]
	ld [wCurObjXPos + 1], a
	ret

.drop
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
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jp nz, MoveObjectDown_Fast
.fly_gone
	xor a
	ld [wPesceFlyActive], a
.despawn
	xor a
	ld [wCurObjFlags], a
	ret

.in_water
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .fly_gone
	call MoveObjectDown_Slow
	ld l, OBJ_STATE_DURATION
	dec [hl]
	ret nz
	ld a, $18
	ld [hl], a
	ld b, PARTICLE_BUBBLES
	farcall CreateParticle
	ret
