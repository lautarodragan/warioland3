UpdateWarioStates:
	ld hl, wCoinCooldown
	ld a, [hl]
	and a
	jr z, .no_coin_cooldown
	dec [hl]
.no_coin_cooldown
	call HandleGroundShake
	call HandleInvincibility

	ld a, [wWarioState]
	cp WARIO_STATES_GROUP_1 ; WST_SLIPPING
	jr c, UpdateWarioStates_Group1
	cp WARIO_STATES_GROUP_2 ; WST_ON_FIRE
	jr c, .group_2
	cp WARIO_STATES_GROUP_3 ; WST_ICE_SKATIN_START
	jr c, .group_3
	farcall UpdateWarioStates_Group4
	ret
.group_3
	farcall UpdateWarioStates_Group3
	ret
.group_2
	farcall UpdateWarioStates_Group2
	ret

UpdateWarioStates_Group1:
	jumptable

	dw UpdateState_Idling              ; WST_IDLING
	dw UpdateState_Walking             ; WST_WALKING
	dw UpdateState_Turning             ; WST_TURNING
	dw InvalidWarioStateReset          ; WST_UNUSED_03
	dw UpdateState_Airborne            ; WST_AIRBORNE
	dw UpdateState_Landing             ; WST_LANDING
	dw UpdateState_CrouchSliding       ; WST_CROUCH_SLIDING
	dw UpdateState_Attacking           ; WST_ATTACKING
	dw UpdateState_AttackingAirborne   ; WST_ATTACKING_AIRBORNE
	dw UpdateState_Bumping             ; WST_BUMPING
	dw UpdateState_Diving              ; WST_DIVING
	dw UpdateState_Submerged           ; WST_SUBMERGED
	dw UpdateState_WaterSurfaceIdling  ; WST_WATER_SURFACE_IDLING
	dw UpdateState_WaterSurfaceMoving  ; WST_WATER_SURFACE_MOVING
	dw UpdateState_UnderwaterThrusting ; WST_UNDERWATER_THRUSTING
	dw UpdateState_SwimKnockBack       ; WST_SWIM_KNOCK_BACK
	dw UpdateState_WaterStung          ; WST_WATER_STUNG
	dw UpdateState_TryingSubmerge      ; WST_TRYING_SUBMERGE
	dw UpdateState_Crouching           ; WST_CROUCHING
	dw UpdateState_CrouchWalking       ; WST_CROUCH_WALKING
	dw UpdateState_CrouchAirborne      ; WST_CROUCH_AIRBORNE
	dw UpdateState_Stung               ; WST_STUNG
	dw UpdateState_StungRecovery       ; WST_STUNG_RECOVERY
	dw UpdateState_PipeGoingDown       ; WST_PIPE_GOING_DOWN
	dw UpdateState_PipeGoingUp         ; WST_PIPE_GOING_UP
	dw UpdateState_EnemyBumping        ; WST_ENEMY_BUMPING
	dw UpdateState_SmashAttacking      ; WST_SMASH_ATTACKING
	dw InvalidWarioStateReset          ; WST_UNUSED_1B
	dw InvalidWarioStateReset          ; WST_UNUSED_1C
	dw InvalidWarioStateReset          ; WST_UNUSED_1D
	dw UpdateState_PickingUp           ; WST_PICKING_UP
	dw UpdateState_GrabIdling          ; WST_GRAB_IDLING
	dw UpdateState_GrabWalking         ; WST_GRAB_WALKING
	dw UpdateState_GrabAirborne        ; WST_GRAB_AIRBORNE
	dw UpdateState_ThrowCharging       ; WST_THROW_CHARGING
	dw UpdateState_ThrowFullyCharged   ; WST_THROW_FULLY_CHARGED
	dw UpdateState_Throwing            ; WST_THROWING
	dw UpdateState_ThrowingAirborne    ; WST_THROWING_AIRBORNE
	dw UpdateState_GrabSmashAttacking  ; WST_GRAB_SMASH_ATTACKING
	dw UpdateState_Sliding             ; WST_SLIDING
	dw UpdateState_Rolling             ; WST_ROLLING
	dw UpdateState_RollingAirborne     ; WST_ROLLING_AIRBORNE
	dw UpdateState_PickedUp            ; WST_PICKED_UP
	dw UpdateState_GroundShakeStunned  ; WST_GROUND_SHAKE_STUNNED
	dw UpdateState_EnteringDoor        ; WST_ENTERING_DOOR
	dw InvalidWarioStateReset          ; WST_UNUSED_2D
	dw InvalidWarioStateReset          ; WST_UNUSED_2E
	dw InvalidWarioStateReset          ; WST_UNUSED_2F
	dw InvalidWarioStateReset
	dw InvalidWarioStateReset
	dw InvalidWarioStateReset
	dw InvalidWarioStateReset

UpdateState_Idling:
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_IDLING
	ret nz ; not idling
	ld a, b
	and a
	jp z, StartFall

	update_pos_y
	ld a, [wWarioState]
	cp WST_IDLING
	ret nz ; not idling

	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr z, .not_pressing_down
; pressing down, handle what state to change to
	farcall UpdateEnvStateAtFeet
	ld a, [wWarioState]
	cp WST_IDLING
	ret nz ; not idling
	ld a, [wLadderInteraction]
	cp LADDER_UNDERNEATH
	jp nz, CrouchOrSlide
	; start climbing down ladder
	farcall SetState_LadderClimbing
	ret

.not_pressing_down
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wLadderInteraction]
	and a
	jr z, .skip_ladder
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .skip_ladder
	; start climbing up ladder
	farcall SetState_LadderClimbing
	ret

.skip_ladder
	ld a, [wIsNearFence]
	and a
	jr z, .handle_input
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .handle_input
	farcall SetState_FenceMovingVertical
	ret

.handle_input
	ld a, [wWarioState]
	cp WST_IDLING
	ret nz ; not idling
	call HandleInput_Idling
	ld a, [wWarioState]
	cp WST_IDLING
	ret nz ; not idling

; still idling, increment idle counter
	ld a, [wIsOnSteppableObject]
	and a
	ret nz ; unless Wario is on steppable object
	ld a, [wWarioStateCounter]
	add 1
	ld [wWarioStateCounter], a
	ld a, [wWarioStateCycles]
	adc 0
	ld [wWarioStateCycles], a
; if the idle cycles reaches a certain value
; then change the state to sleeping
	cp NUM_SLEEPING_IDLE_CYCLES
	ret c
	farcall SetState_Sleeping
	ret

UpdateState_Walking:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 36
	ld [wSFXLoopCounter], a
	play_sfx SFX_WALK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	jr z, .handle_input
	get_pos
	ld b, PARTICLE_DUST
	farcall CreateParticle

.handle_input
	call HandleInput_Walking
	ld a, [wWarioState]
	cp WST_WALKING
	ret nz ; return if not walking anymore

	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_WALKING
	ret nz ; return if not walking anymore

	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_WALKING
	ret nz ; return if not walking anymore
	ld a, b
	and a
	jp z, StartFall

	update_pos_y
	ret

UpdateState_Turning:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, StartJump_FromInput
	bit B_PAD_B, a
	jp nz, SetState_Attacking
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z ; continue animation
	; change state to either walking or idling
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_Walking_ResetWalkVel
	jp SetState_Idling

StartJump_FromWaterSurface:
	play_sfx SFX_SPLASH
	ld a, $01
	ld [wJumpVelIndex], a
	ld a, TRUE
	ld [wJumpingUpwards], a
	ld a, TRUE
	ld [wDoFullJump], a
	jr StartJump

StartJump_FromSand:
	xor a
	ld [wJumpVelIndex], a
	ld a, TRUE
	ld [wJumpingUpwards], a
	ld a, TRUE
	ld [wDoFullJump], a

	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	ld a, JUMP_VEL_KNOCK_BACK
	jr c, .got_jump_vel_table
	ld hl, wJoypadDown
	bit B_PAD_UP, [hl]
	jr z, .got_jump_vel_table
	ld a, JUMP_VEL_NORMAL
.got_jump_vel_table
	ld [wJumpVelTable], a
	jr SetState_Airborne

StartFall::
	xor a ; FALSE
	ld [wJumpingUpwards], a
StartFall_SkipResetJumpUpwards:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr StartJump

StartJump_FromInput:
	play_sfx SFX_JUMP
	xor a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld a, TRUE
	ld [wJumpingUpwards], a
;	fallthrough

StartJump:
	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	ld a, JUMP_VEL_NORMAL
	jr c, .got_jump_vel_table
	ld hl, wJoypadDown
	bit B_PAD_UP, [hl]
	jr z, .got_jump_vel_table
	ld a, JUMP_VEL_HIGH_JUMP
.got_jump_vel_table
	ld [wJumpVelTable], a
;	fallthrough

SetState_Airborne:
	xor a
	ld [wWarioSlopeInteraction], a

	ld a, WST_AIRBORNE
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsCrouching], a
	ld [wAttackCounter], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioAirborneFrameset_15f94)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAirborneFrameset_15f94)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBlindFrameset_15f97)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBlindFrameset_15f97)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wIsOnSteppableObject]
	and a
	ret z
	ld b, 2
	call MoveWarioUp
	ret

UpdateState_Airborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr c, .handle_input

; falling
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .not_in_sand
	farcall SetState_SandFalling
	ret

.not_in_sand
	ld a, [wLadderInteraction]
	and a
	jr z, .no_ladder
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .no_ladder
	farcall SetState_LadderClimbing
	ret

.no_ladder
	ld a, [wWarioState]
	cp WST_AIRBORNE
	ret nz ; not airborne anymore

	farcall UpdateEnvStateAtHead
	ld a, [wIsNearFence]
	and a
	jr z, .handle_input
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .handle_input
	farcall SetState_FenceMovingVertical
	ret

.handle_input
	ld a, [wWarioState]
	cp WST_AIRBORNE
	ret nz ; not airborne anymore
	call HandleInput_Airborne
	ld a, [wWarioState]
	cp WST_AIRBORNE
	ret nz ; not airborne anymore

	ld a, [wPowerUpLevel]
	cp LEAD_OVERALLS
	jr c, .continue
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .check_still_smash_attacking
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr c, .continue

	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr z, .continue
	ld a, TRUE
	ld [wIsSmashAttacking], a
.set_smash_attack
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .smash_attack_right
	jr .smash_attack_left

.check_still_smash_attacking
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .continue
	xor a ; FALSE
	ld [wIsSmashAttacking], a
	jr .no_smash_attack
.continue
	ld a, [wIsTurning]
	and a
	jr z, .update_animation
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .set_smash_attack

.no_smash_attack
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioAirborneFrameset_15f94)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAirborneFrameset_15f94)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioBlindFrameset_15f97)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBlindFrameset_15f97)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.smash_attack_left
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr nc, .super_smash_left
	ld a, HIGH(WarioAirborneFrameset_15f8e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAirborneFrameset_15f8e)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.super_smash_left
	ld a, HIGH(WarioAirborneFrameset_1604e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAirborneFrameset_1604e)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.smash_attack_right
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr nc, .super_smash_right
	ld a, HIGH(WarioFrameset_15f91)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f91)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.super_smash_right
	ld a, HIGH(WarioFrameset_16055)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_16055)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_AIRBORNE
	ret nz ; not airborne anymore
	ld a, [wJumpCollision]
	and a
	jp nz, StartFall_SkipResetJumpUpwards

	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a
	ret

.falling
	farcall CheckAirborneCollision
	ld a, [wWarioState]
	cp WST_AIRBORNE
	ret nz ; not airborne anymore
	ld a, b
	and a
	jr nz, .land
	jp TriggerDownwardsFloorTransition
.land
	update_pos_y
	get_pos
	ld b, PARTICLE_DUST
	farcall CreateParticle

	ld a, [wJumpVelIndex]
	cp MAX_JUMP_VEL_INDEX
	jr c, DoSoftLand
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, DoHardLand
;	fallthrough

DoSoftLand:
	call TriggerFloorTransition_SkipUpdateYPos

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a

	ld a, [wIsSmashAttacking]
	and a
	jr z, .not_smash_attacking
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, DoGroundPound
	jp DoWarioGroundShake

.not_smash_attacking
	ld a, [wJoypadDown]
	and PAD_DOWN
	jp nz, CrouchOrSlide
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr z, .no_collision_on_top
	jp CrouchOrSlide
.no_collision_on_top
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_Walking
	jp SetState_Idling

DoHardLand:
	call TriggerFloorTransition_SkipUpdateYPos

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWalkVelIndex], a

	ld a, [wIsSmashAttacking]
	and a
	jr z, .not_smash_attacking
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, DoGroundPound
	jr DoWarioGroundShake

.not_smash_attacking
	ld a, [wJoypadDown]
	and PAD_DOWN
	jp nz, CrouchOrSlide

	play_sfx SFX_LAND
	ld a, WST_LANDING
	ld [wWarioState], a
	ld a, BANK(WarioOAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15f9a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f9a)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_15fa1)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15fa1)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

DoWarioGroundShake:
	ld a, [wGroundShakeCounter]
	and a
	jr nz, .already_shaking
	ld a, 32
	ld [wGroundShakeCounter], a
	ld a, TRUE
	ld [wIsWarioGroundShaking], a
.already_shaking
	ld a, [wFloorTransitionDir]
	and a
	play_sfx z, SFX_GROUND_SHAKE

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15fb8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15fb8)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_15fc5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15fc5)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jr SetState_SmashAttacking

DoGroundPound:
	play_sfx SFX_GROUND_POUND
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15ff2)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15ff2)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_16009)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_16009)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
;	fallthrough

SetState_SmashAttacking:
	ld a, $81
	ld [wIsSmashAttacking], a
	ld a, WST_SMASH_ATTACKING
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ret

UpdateState_Landing:
	ld a, [wJoypadPressed]
	and PAD_RIGHT | PAD_LEFT
	jr nz, .walk
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	jr nz, .end_land
	ret
.walk
	jp SetState_Walking_ResetWalkVel

.end_land
	ld a, [wJumpingUpwards]
	and a
	jr nz, .jumping_upwards
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr nz, .jump
.jumping_upwards
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .jump
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jp nz, CrouchOrSlide
	jp SetState_Idling

.jump
	; do a high jump if have High Jump Boots
	call StartJump_FromInput
	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	ret c
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a
	ret

SetState_CrouchSliding:
	xor a
	ld [wSFXLoopCounter], a
	ld [wAttackCounter], a
	play_sfx SFX_SLIDE
	ld a, WST_CROUCH_SLIDING
	ld [wWarioState], a
	ld a, TRUE
	ld [wIsCrouching], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	cp DIRECTION_RIGHT
	jr z, .dir_right
; dir left
	ld a, HIGH(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_CrouchSliding:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_CROUCH_SLIDING
	ret nz ; not crouch sliding anymore

	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, .try_jump

	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_CROUCH_SLIDING
	ret nz ; not crouch sliding anymore
	ld a, b
	and a
	jp z, StartCrouchFall
	ld a, [wWarioSlopeInteraction]
	and a
	jr z, .no_slope
	update_pos_y
	jp SetState_Sliding

.no_slope
	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_CROUCH_SLIDING
	ret nz ; not crouch sliding anymore
	ld a, b
	and a
	jp nz, .end_slide

; if Wario has Garlic power-up, then slide further
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [wPowerUpLevel]
	cp GARLIC
	jr nc, .has_garlic
	ld a, [hl]
	cp $14
	jr c, .slide_fast
	cp $24
	jr c, .slide_slow
	cp $28
	jr c, .slide_slower
	jp z, .end_slide
	ret

.has_garlic
	ld a, [hl]
	cp $1e
	jr c, .slide_fast
	cp $36
	jr c, .slide_slow
	cp $3c
	jr c, .slide_slower
	jr z, .end_slide
	ret

.slide_fast
	ld b, 2
	ld a, [wDirection]
	and a
	jr nz, .add_x_offset
.sub_x_offset
	call MoveWarioLeft
	ret
.add_x_offset
	call MoveWarioRight
	ret
.slide_slow
	ld b, 1
	ld a, [wDirection]
	and a
	jr nz, .add_x_offset
	jr .sub_x_offset
.slide_slower
	ld a, [wGlobalCounter]
	and %1
	ret z
	ld b, 1
	ld a, [wDirection]
	and a
	jr nz, .add_x_offset
	jr .sub_x_offset

.try_jump
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_CROUCH_SLIDING
	ret nz ; not crouch sliding anymore
	ld a, b
	and a
	jr nz, .no_jump
	ld a, -15
	ld [wCollisionBoxTop], a
	jp StartCrouchJump
.no_jump
	ld a, -15
	ld [wCollisionBoxTop], a
	ret

.end_slide
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .crouching
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_CROUCH_SLIDING
	ret nz ; not crouch sliding anymore
	ld a, b
	and a
	jp z, SetState_Idling
.crouching
	ld a, -15
	ld [wCollisionBoxTop], a
	jp CrouchOrSlide

UpdateState_Attacking:
	ld a, [wPowerUpLevel]
	cp GARLIC
	jr nc, .powered_up
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_SFX_01
	ld a, 6
	ld [wSFXLoopCounter], a
	play_sfx SFX_ATTACK
.skip_SFX_01
	jr .skip_SFX_02

.powered_up
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_SFX_02
	ld a, 6
	ld [wSFXLoopCounter], a
	play_sfx SFX_ATTACK_POWERED_UP

.skip_SFX_02
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleInput_Attacking
	ld a, [wWarioState]
	cp WST_ATTACKING
	ret nz ; not attacking anymore
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_ATTACKING
	ret nz ; not attacking anymore

	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_ATTACKING
	ret nz ; not attacking anymore
	ld a, b
	and $0f
	jp nz, .bump

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, StartFallingAirborneAttack

	ld a, [wWarioState]
	cp WST_ATTACKING
	ret nz ; not attacking anymore
	ld a, [wAttackCounter]
	cp CHARGE_ATTACK_COUNTER
	jr nc, .check_collision
	ld a, [wDirection]
	and a
	jr nz, .dir_right
; dir left
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	ld a, [wWalkVelIndex]
	cp $14
	jr c, .got_walk_vel_left
	ld a, $10
	ld [wWalkVelIndex], a
.got_walk_vel_left
	jr .check_collision
.dir_right
	call ApplyWalkVelocity_Right
	call MoveWarioRight
	ld a, [wWalkVelIndex]
	cp $14
	jr c, .check_collision
	ld a, $10
	ld [wWalkVelIndex], a

.check_collision
	farcall CheckCentreCollision
	update_pos_y
	ld a, [wWarioState]
	cp WST_ATTACKING
	ret nz ; not attacking anymore
	ld hl, wAttackCounter
	dec [hl]
	ret nz
	call IsOnSlipperyGround
	jr z, .not_slippery
	farcall SetState_Slipping
	ret
.not_slippery
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_Walking_ResetWalkVel
	jp SetState_Idling

.bump
	jp DoBumpWithSmallBackOffset

DoBumpWithBigBackOffset:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld b, 3
	call MoveWarioRight
	jr .done_x_offset
.dir_right
	ld b, 3
	call MoveWarioLeft
.done_x_offset
	jr DoBumpOrJumpingBump

DoBumpWithSmallBackOffset:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld b, 2
	call MoveWarioRight
	jr DoBumpOrJumpingBump
.dir_right
	ld b, 2
	call MoveWarioLeft
;	fallthrough

DoBumpOrJumpingBump:
	play_sfx SFX_BUMP
	ld a, [wJumpVelTable]
	and a
	jr nz, .fall
	ld a, 10
	jr .got_jump_vel
.fall
	ld a, FALLING_JUMP_VEL_INDEX
.got_jump_vel
	ld [wJumpVelIndex], a
	jr SetState_Bumping

DoJumpingBump:
	play_sfx SFX_BUMP
;	fallthrough

DoJumpingBump_NoSFX:
	ld a, 10
	ld [wJumpVelIndex], a
;	fallthrough

SetState_Bumping:
	ld a, WST_BUMPING
	ld [wWarioState], a
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wAttackCounter], a
	ld a, [wIsRolling]
	and a
	jp nz, .rolling

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBumpFrameset_15219)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_15219)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jr .done_left
.dir_right
	ld a, HIGH(WarioBumpFrameset_15216)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_15216)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
.done_right
	ret
.done_left
	ret

.rolling
	xor a
	ld [wIsRolling], a
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .rolling_dir_right
	call .done_left
	ld a, HIGH(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 1], a
	jr .rolling_got_frameset
.rolling_dir_right
	call .done_right
	ld a, HIGH(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 1], a
.rolling_got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr z, .done
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
.done
	ret

StartFallingAirborneAttack:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr SetState_AttackingAirborne

StartJumpingAirborneAttack:
	xor a
	ld [wJumpVelIndex], a
	ld a, TRUE
	ld [wJumpingUpwards], a
SetState_AttackingAirborne:
	xor a
	ld [wWarioSlopeInteraction], a
	ld a, WST_ATTACKING_AIRBORNE
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	ld a, JUMP_VEL_NORMAL
	jr c, .got_jump_vel_table
	inc a ; JUMP_VEL_HIGH_JUMP
.got_jump_vel_table
	ld [wJumpVelTable], a

	ld a, [wPowerUpLevel]
	cp GARLIC
	jr nc, .powered_up
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBumpFrameset_15216)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_15216)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBumpFrameset_15219)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_15219)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.powered_up
	ld a, [wDirection]
	and a
	jr nz, .powered_up_dir_right
	ld a, HIGH(WarioAttackingAirborneFrameset_1523e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAttackingAirborneFrameset_1523e)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.powered_up_dir_right
	ld a, HIGH(WarioAttackingAirborneFrameset_15249)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAttackingAirborneFrameset_15249)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wIsOnSteppableObject]
	and a
	ret z
	call UpdateState_AttackingAirborne ; can be fallthrough
	ret

UpdateState_AttackingAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret

.no_sand
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	ret nz ; not attacking airborne anymore
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 6
	ld [wSFXLoopCounter], a
	play_sfx SFX_ATTACK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleAttackingAirborneMovement
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	ret nz ; not attacking airborne anymore

	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	ret nz ; not attacking airborne anymore
	ld a, b
	and $0f
	jr nz, .bump

	ld a, [wAttackCounter]
	dec a
	jr z, .check_turn
	ld [wAttackCounter], a
.check_turn
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld a, [wJoypadPressed]
	bit B_PAD_RIGHT, a
	jr z, .no_turn
.cancel_attack
	xor a
	ld [wAttackCounter], a
	jp StartFall
.facing_right
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr nz, .cancel_attack

.no_turn
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	ret nz ; not attacking airborne anymore

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	ret nc
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	ret nz ; not attacking airborne anymore
	jp SetState_Idling

.bump
	jp DoBumpWithSmallBackOffset

UpdateState_Bumping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret

.no_sand
	ld a, [wWarioState]
	cp WST_BUMPING
	ret nz ; not bumping anymore
	call HandleBumpMovement
	ld a, [wWarioState]
	cp WST_BUMPING
	ret nz ; not bumping anymore

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_BUMPING
	ret nz ; not bumping anymore

	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .skip_floor_transition
	jp TriggerDownwardsFloorTransition
.skip_floor_transition
	update_pos_y
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	ld a, [wWarioState]
	cp WST_BUMPING
	ret nz ; not bumping anymore
	jp DoSoftLand

DiveFromSurface:
	xor a
	ld [wGrabState], a
	get_pos

	ldh a, [hYPosLo]
	and $f0
	ldh [hYPosLo], a

	ld b, PARTICLE_SPLASH
	farcall CreateParticle
	play_sfx SFX_SPLASH
;	fallthrough

DiveFromSurface_SkipSplash:
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, BANK(WarioUnderwaterOAM_15254)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioUnderwaterOAM_15254)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioUnderwaterOAM_15254)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_155a0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_155a0)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_155a3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_155a3)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jr SetState_Diving

StartDive:
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwimFrameset_15569)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15569)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSwimFrameset_15573)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15573)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
;	fallthrough

SetState_Diving:
	ld a, WST_DIVING
	ld [wWarioState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld [wAttackCounter], a
	ld [wIsRolling], a
	ld [wSwimVelIndex], a
	ld [wIsCrouching], a
	ld [wUnused_c0e0], a

	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, BANK(WarioSwimGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSwimGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSwimGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ret

UpdateState_Diving:
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_DIVING
	ret nz ; not diving anymore

	ld a, b
	and a
	jr nz, .submerge
	call HandleDivingHorizontalMovement
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp 10
	jr c, .fast
	cp 14
	jr c, .slow
	jr SetState_Submerged
.fast
	ld b, 2
	jr .descend
.slow
	ld b, 1
.descend
	call MoveWarioDown

	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .submerge
	ret

.submerge
	update_pos_y
;	fallthrough

SetState_Submerged:
	ld a, WST_SUBMERGED
	ld [wWarioState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wSwimVelIndex], a
	ld [wUnused_c0e0], a
	ld [wSwimmingDirectionInput], a

	ld a, BANK(WarioSwimGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSwimGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSwimGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioUnderwaterOAM_15254)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioUnderwaterOAM_15254)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioUnderwaterOAM_15254)
	ld [wWarioOAMPtr + 1], a

	ld a, [wPowerUpLevel]
	cp SWIMMING_FLIPPERS
	jr c, .cannot_swim_underwater
	ld a, [wWaterInteraction]
	cp NON_SUBMERSIBLE_WATER
	jr z, .cannot_swim_underwater

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwimFrameset_15576)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15576)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSwimFrameset_1558b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_1558b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

.cannot_swim_underwater
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .cannot_swim_dir_right
	ld a, HIGH(WarioFrameset_155a0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_155a0)
	ld [wWarioFramesetPtr + 1], a
	jr .cannot_swim_got_frameset
.cannot_swim_dir_right
	ld a, HIGH(WarioFrameset_155a3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_155a3)
	ld [wWarioFramesetPtr + 1], a
.cannot_swim_got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Submerged:
	xor a
	ld [wWaterCurrentBlockedDir], a
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_SUBMERGED
	ret nz
	call ApplyWaterCurrentMovement
	call HandleSubmergedInput
	ret

SurfaceFromUnderwater:
	xor a
	ld [wSFXLoopCounter], a
	ld [wWaterSurfaceFloatingCounter], a
	ld a, BANK(WarioSwimGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSwimGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSwimGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioUnderwaterOAM_15254)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioUnderwaterOAM_15254)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioUnderwaterOAM_15254)
	ld [wWarioOAMPtr + 1], a
;	fallthrough

SetState_WaterSurfaceIdling:
	ld a, WST_WATER_SURFACE_IDLING
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wSwimVelIndex], a
	ld [wUnused_c0e0], a
	ld [wSwimmingDirectionInput], a
	ld a, [wWaterInteraction]
	and a
	jr nz, .got_water_interaction
	ld a, SUBMERSIBLE_WATER
	ld [wWaterInteraction], a

.got_water_interaction
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioWaterFrameset_15554)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWaterFrameset_15554)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioWaterFrameset_1555b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWaterFrameset_1555b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_WaterSurfaceIdling:
	xor a
	ld [wWaterCurrentBlockedDir], a
	farcall CheckTopBlockInteraction
	ld a, [wWarioState]
	cp WST_WATER_SURFACE_IDLING
	ret nz ; not water idling anymore

	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 28
	ld [wSFXLoopCounter], a
	play_sfx SFX_WATER_SURFACE
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleWaterSurfaceFloatingMovement
	call HandleWaterSurfaceInput
	ld a, [wWarioState]
	cp WST_WATER_SURFACE_IDLING
	ret nz ; not water idling anymore

	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr nz, SetState_WaterSurfaceMoving
	call ApplyWaterCurrentMovement
	ret

SetState_WaterSurfaceMoving:
	ld a, WST_WATER_SURFACE_MOVING
	ld [wWarioState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wSwimVelIndex], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioWaterFrameset_15554)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWaterFrameset_15554)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioWaterFrameset_1555b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWaterFrameset_1555b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_WaterSurfaceMoving:
	xor a
	ld [wWaterCurrentBlockedDir], a
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 28
	ld [wSFXLoopCounter], a
	play_sfx SFX_WATER_SURFACE
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleWaterSurfaceFloatingMovement
	call ApplyWaterCurrentMovement
	call .HandleDirectionalInput
	call HandleWaterSurfaceInput
	ret

.HandleDirectionalInput:
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_WaterSurfaceIdling

.d_right
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioWaterFrameset_1555b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWaterFrameset_1555b)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.facing_right
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	; current overrides player input
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_RIGHT | CURRENT_LEFT
	ret nz
	; no left/right current
	call ApplyWalkVelocity_Right
	call MoveWarioRight

.done_moving
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .done
	ld a, $00
	ld [wWalkVelIndex], a
.done
	ret

.d_left
	ld a, [wDirection]
	and a
	jr z, .facing_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioWaterFrameset_15554)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWaterFrameset_15554)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.facing_left
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	; current overrides player input
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_RIGHT | CURRENT_LEFT
	ret nz
	; no left/right current
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .done_moving

HandleWaterSurfaceFloatingMovement:
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wWaterSurfaceFloatingCounter
	inc [hl]
	ld a, [hl]
	cp 7
	jr nc, .go_up
; go down
	ld b, 1
	call MoveWarioDown_WithoutCameraOffset
	ret
.go_up
	cp 12
	jr c, .sub_y_offset
	xor a
	ld [hl], a
.sub_y_offset
	ld b, 1
	call MoveWarioUp_WithoutCameraOffset
	ret

StartUpwardsUnderwaterThrusting:
	ld a, PAD_UP
	ld [wSwimmingDirectionInput], a
	jr SetState_UnderwaterThrusting

StartUnderwaterThrusting:
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	ld [wSwimmingDirectionInput], a
;	fallthrough

SetState_UnderwaterThrusting:
	ld a, WST_UNDERWATER_THRUSTING
	ld [wWarioState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wSwimVelIndex], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wSwimmingDirectionInput]
	and a
	jr z, .no_input
	ld a, [wSwimmingDirectionInput] ; unnecessary
	bit B_PAD_LEFT, a
	jr nz, .thrust_left
	bit B_PAD_RIGHT, a
	jr nz, .thrust_right
	ld a, [wDirection]
	and a
	jr nz, .thrust_right
.thrust_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	jr c, .weak_thrust_left
	ld a, HIGH(WarioUnderwaterThrustingFrameset_15562)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioUnderwaterThrustingFrameset_15562)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.weak_thrust_left
	ld a, HIGH(WarioUnderwaterThrustingFrameset_155be)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioUnderwaterThrustingFrameset_155be)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.thrust_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	jr c, .weak_thrust_right
	ld a, HIGH(WarioUnderwaterFrameset_1556c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioUnderwaterFrameset_1556c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.weak_thrust_right
	ld a, HIGH(WarioUnderwaterFrameset_155c5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioUnderwaterFrameset_155c5)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

.no_input
	ld a, [wDirection]
	cp DIRECTION_RIGHT
	jr z, .facing_right
	ld a, PAD_LEFT
	ld [wSwimmingDirectionInput], a
	jr .thrust_left
.facing_right
	ld a, PAD_RIGHT
	ld [wSwimmingDirectionInput], a
	jr .thrust_right

UpdateState_UnderwaterThrusting:
	xor a
	ld [wWaterCurrentBlockedDir], a
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_UNDERWATER_THRUSTING
	ret nz ; not underwater thrusting anymore

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 15
	ld [wSFXLoopCounter], a
	play_sfx SFX_UNDERWATER_THRUST
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleUnderwaterThrustingInput
	ld a, [wWarioState]
	cp WST_UNDERWATER_THRUSTING
	ret nz ; not underwater thrusting anymore

	call ApplyWaterCurrentMovement
	ret

SetState_SwimKnockBack_SwitchDirection:
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
;	fallthrough

SetState_SwimKnockBack:
	play_sfx SFX_BUMP
	ld a, WST_SWIM_KNOCK_BACK
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wSwimVelIndex], a
	ld [wSwimmingDirectionInput], a
	ld [wUnused_c0e0], a
	ld a, BANK(WarioSwimGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSwimGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSwimGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwimFrameset_15573)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15573)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSwimFrameset_15569)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15569)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SwimKnockBack:
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .stop
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $04
	jr c, .fast
	cp $08
	jr c, .slow
	jr .stop
.fast
	ld b, $02
	jr .move
.slow
	ld b, $01
.move
	ld a, [wDirection]
	and a
	jr nz, .move_right
	call MoveWarioLeft
	ret
.move_right
	call MoveWarioRight
	ret

.stop
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	jp SetState_Submerged

UpdateState_WaterStung:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld hl, wWarioStateCounter
	inc [hl]
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .blocked_above
	farcall UpdateEnvStateAtChest
	ld a, [wWaterInteraction]
	and a
	jr z, .out_of_water
	ld a, [wWarioStateCounter]
	cp $78
	jr nc, .recover
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld b, $01
	call MoveWarioUp
	ld a, [wWaterCurrent]
	and a
	ret z
	xor a
	ld [wWaterCurrent], a
	jr .recover

.blocked_above
	ld a, [wWarioStateCounter]
	cp $78
	ret c
	ld a, PAD_UP
	ld [wWaterCurrentBlockedDir], a
.recover
	xor a
	ld [wIsIntangible], a
	ld a, $10
	ld [wInvincibleCounter], a
	jp SetState_Submerged

.out_of_water
	ld a, [wWarioStateCounter]
	cp $78
	ret c
	xor a
	ld [wIsIntangible], a
	ld a, $10
	ld [wInvincibleCounter], a
	jp SurfaceFromUnderwater

SetState_TryingSubmerge:
	ld a, WST_TRYING_SUBMERGE
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioTryingSubmergeFrameset_155b0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioTryingSubmergeFrameset_155b0)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioTryingSubmergeFrameset_155b7)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioTryingSubmergeFrameset_155b7)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_TryingSubmerge:
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jp z, SetState_WaterSurfaceIdling
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Crouching:
	farcall CheckTopBlockInteraction
	ld a, [wWarioState]
	cp WST_CROUCHING
	ret nz ; not crouching anymore

	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	call HandleCrouchingInput
	ld a, [wWarioState]
	cp WST_CROUCHING
	ret nz ; not crouching anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, StartCrouchFall
	ret

UpdateState_CrouchWalking:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 21
	ld [wSFXLoopCounter], a
	play_sfx SFX_CROUCH_WALK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_CROUCH_WALKING
	ret nz ; not crouch walking anymore

	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	call HandleCrouchWalkingInput
	ld a, [wWarioState]
	cp WST_CROUCH_WALKING
	ret nz ; not crouch walking anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, StartCrouchFall
	update_pos_y
	ld a, [wWarioSlopeInteraction]
	and a
	jr nz, .on_slope
	ret
.on_slope
	jp SetState_Sliding

UpdateState_CrouchAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret
.no_sand
	ld a, [wWarioState]
	cp WST_CROUCH_AIRBORNE
	ret nz ; not crouch jumping anymore

	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .stay_crouched
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_CROUCH_AIRBORNE
	ret nz ; not crouch jumping anymore

	ld a, b
	and a
	jr nz, .stay_crouched
	jp StartJump
.stay_crouched
	ld a, -15
	ld [wCollisionBoxTop], a
	call HandleInput_Airborne
	ld a, [wWarioState]
	cp WST_CROUCH_AIRBORNE
	ret nz ; not crouch jumping anymore

	ld a, [wIsTurning]
	and a
	jr z, .not_turning
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
.not_turning
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling

; rising
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_CROUCH_AIRBORNE
	ret nz ; not crouch jumping anymore

	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_CROUCH_AIRBORNE
	ret nz ; not crouch jumping anymore
	jp TriggerDownwardsFloorTransition

.landed
	update_pos_y
	ld a, [wWarioState]
	cp WST_CROUCH_AIRBORNE
	ret nz ; not crouch jumping anymore

	call DoSoftLand
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	ret z
	jp CrouchOrSlide

UpdateState_Stung:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret

.no_sand
	call BlinkWarioPal
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .hit_wall
	ld a, [wDirection]
	and a
	jr nz, .move_right
	ld b, $01
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .got_speed_left
	inc b
.got_speed_left
	call MoveWarioLeft
	jr .vertical
.move_right
	ld b, $01
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .got_speed_right
	inc b
.got_speed_right
	call MoveWarioRight
	jr .vertical
.hit_wall
	ld a, [wDirection]
	and a
	jr nz, .push_left
	ld b, $01
	call MoveWarioRight
	jr .vertical

.push_left
	ld b, $01
	call MoveWarioLeft
.vertical
	ld a, [wJumpVelTable]
	and a
	jr nz, .apply_jump_vel
	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp MAX_JUMP_VEL_INDEX
	jp nc, .recover
	farcall CheckCentreCollision
	ld a, b
	and $0f
	ret nz
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
	ret

.apply_jump_vel
	ld a, [wJumpVelIndex]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	bit 7, [hl]
	jr z, .falling

; rising
	ld a, [hl]
	cpl
	inc a
	ld b, a
	call MoveWarioUp
	ld hl, wJumpVelIndex
	inc [hl]
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr .apply_jump_vel

.falling
	ld b, [hl]
	call MoveWarioDown
	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp MAX_JUMP_VEL_INDEX
	jr c, .check_landing
	ld [hl], MAX_JUMP_VEL_INDEX
.check_landing
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wJumpVelTable]
	inc a
	ld [wJumpVelTable], a
	sub $02
	jr z, .bounce_1
	dec a
	jr z, .bounce_2
	jr .recover
.bounce_1
	ld a, $0a
	ld [wJumpVelIndex], a
	ret

.bounce_2
	ld a, $0e
	ld [wJumpVelIndex], a
	ret

.recover
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, WST_STUNG_RECOVERY
	ld [wWarioState], a
	ret

UpdateState_StungRecovery:
	call BlinkWarioPal
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $14
	ret c

	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a

	ld a, $10
	ld [wInvincibleCounter], a
	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_STUNG_RECOVERY
	ret nz ; not stung recovering anymore

	ld a, b
	and a
	jr nz, .crouch
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jp z, SetState_Idling
.crouch
	ld a, -15
	ld [wCollisionBoxTop], a
	jp CrouchOrSlide

UpdateState_PipeGoingDown:
	ld a, TRUE
	ld [wIsIntangible], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld b, 1
	call MoveWarioDown

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $20
	jr z, .transition
	cp $21
	jr z, .play_exit_sfx
	cp $40
	ret c
	ld a, [wWarioXPos + 1]
	sub $08
	ld [wWarioXPos + 1], a
	xor a
	ld [wIsIntangible], a
	jp SetState_Idling

.transition
	call ClearTransformationValues
	ld hl, wRoomTransitionParam
	res ROOMTRANSITIONF_DELAY_F, [hl]
	jp TriggerRoomTransition
.play_exit_sfx
	play_sfx SFX_PIPE_EXIT
	ret

UpdateState_PipeGoingUp:
	ld a, TRUE
	ld [wIsIntangible], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld b, $01
	call MoveWarioUp

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $20
	jr z, .transition
	cp $21
	jr z, .play_exit_sfx
	cp $40
	ret c
	ld a, [wWarioXPos + 1]
	sub $08
	ld [wWarioXPos + 1], a
	xor a
	ld [wIsIntangible], a
	call UpdateFloor
	jp SetState_Idling

.transition
	call ClearTransformationValues
	ld hl, wRoomTransitionParam
	res ROOMTRANSITIONF_DELAY_F, [hl]
	jp TriggerRoomTransition
.play_exit_sfx
	play_sfx SFX_PIPE_EXIT
	ret

UpdateState_EnemyBumping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret

.no_sand
	ld a, [wWarioState]
	cp WST_ENEMY_BUMPING
	ret nz
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleBumpMovement
	ld a, [wWarioState]
	cp WST_ENEMY_BUMPING
	ret nz
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition

.landed
	ld a, [wDirection]
	xor $1
	ld [wDirection], a
	ld hl, hYPosHi
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jp DoSoftLand

UpdateState_SmashAttacking:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $1b
	ret c
	xor a ; FALSE
	ld [wIsSmashAttacking], a
	jp SetState_Idling

UpdateState_PickingUp:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, DropObjectAndJump
	ld a, [wGrabState]
	and a
	jp z, SetState_Idling
	and GRAB_STATE_MASK
	cp GRAB_PICK_UP_BLOCKED
	jp z, SetState_GrabIdling
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_GrabIdling

UpdateState_GrabIdling:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_GRAB_IDLING
	ret nz ; done not grab idling anymore

	ld a, [wGrabState]
	and a
	jp z, SetState_Idling
	call HandleGrabIdlingInput
	ld a, [wWarioState]
	cp WST_GRAB_IDLING
	ret nz ; done not grab idling anymore

	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_GRAB_IDLING
	ret nz ; done not grab idling anymore

	ld a, b
	and a
	jp z, SetState_GrabAirborne_Fall
	update_pos_y
	ret

UpdateState_GrabWalking:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_GRAB_WALKING
	ret nz ; not grab walking anymore

	ld a, [wGrabState]
	and a
	jp z, SetState_Walking_ResetWalkVel
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 36
	ld [wSFXLoopCounter], a
	play_sfx SFX_WALK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleGrabWalkingInput
	ld a, [wWarioState]
	cp WST_GRAB_WALKING
	ret nz ; not grab walking anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_GrabAirborne_Fall
	update_pos_y
	ret

SetState_ThrowingAirborne:
	ld a, WST_THROWING_AIRBORNE
	ld [wWarioState], a
	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	or GRAB_THROW
	ld [wGrabState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioThrowingAirborneFrameset_15fae)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowingAirborneFrameset_15fae)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioThrowingAirborneFrameset_15fb3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowingAirborneFrameset_15fb3)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_GrabAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_GRAB_AIRBORNE
	ret nz ; not grabbing airborne anymore

	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wGrabState]
	and a
	jp z, StartFall
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret

.no_sand
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_ThrowingAirborne
	call HandleInput_Airborne
	ld a, [wWarioState]
	cp WST_GRAB_AIRBORNE
	ret nz ; not grabbing airborne anymore

	ld a, [wPowerUpLevel]
	cp LEAD_OVERALLS
	jr c, .check_turning
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .check_still_smash_attacking
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr c, .check_turning
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr z, .check_turning
	ld a, TRUE
	ld [wIsSmashAttacking], a

.set_smash_attack
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .smash_attack_right
	jr .smash_attack_left

.check_still_smash_attacking
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .check_turning
	xor a ; FALSE
	ld [wIsSmashAttacking], a
	jr .no_smash_attack
.check_turning
	ld a, [wIsTurning]
	and a
	jr z, .update_animation
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .set_smash_attack
.no_smash_attack
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioGrabFrameset_15fa8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_15fa8)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioGrabFrameset_15fab)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_15fab)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.smash_attack_left
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr nc, .super_smash_left
	ld a, HIGH(WarioGrabAirborneFrameset_15fec)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_15fec)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.super_smash_left
	ld a, HIGH(WarioGrabAirborneFrameset_1605c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_1605c)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.smash_attack_right
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr nc, .super_smash_right
	ld a, HIGH(WarioGrabAirborneFrameset_15fef)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_15fef)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.super_smash_right
	ld a, HIGH(WarioGrabAirborneFrameset_16063)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_16063)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wGrabState]
	bit GRAB_HEAVY_F, a
	jr z, .got_walk_vel
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.falling
	farcall CheckAirborneCollision
	ld a, [wWarioState]
	cp WST_GRAB_AIRBORNE
	ret nz ; not grabbing airborne anymore

	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	ld a, [wFloorTransitionDir]
	and a
	play_sfx z, SFX_LAND
	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wWalkVelIndex], a
	ld a, [wIsSmashAttacking]
	and a
	jr z, .idle
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr c, .ground_pound
	jr .continue
.idle
	jp SetState_GrabIdling

.continue
	ld a, [wGroundShakeCounter]
	and a
	jr nz, .already_shaking
	ld a, $20
	ld [wGroundShakeCounter], a
	ld a, TRUE
	ld [wIsWarioGroundShaking], a
.already_shaking
	ld a, [wFloorTransitionDir]
	and a
	play_sfx z, SFX_GROUND_SHAKE

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .shake_dir_right
	ld a, HIGH(WarioGrabAirborneFrameset_15fd2)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_15fd2)
	ld [wWarioFramesetPtr + 1], a
	jr .shake_got_frameset
.shake_dir_right
	ld a, HIGH(WarioGrabAirborneFrameset_15fdf)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_15fdf)
	ld [wWarioFramesetPtr + 1], a
.shake_got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jr .set_grab_smash_attacking

.ground_pound
	play_sfx SFX_GROUND_POUND
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .pound_dir_right
	ld a, HIGH(WarioGrabAirborneFrameset_16020)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_16020)
	ld [wWarioFramesetPtr + 1], a
	jr .pound_got_frameset
.pound_dir_right
	ld a, HIGH(WarioGrabAirborneFrameset_16037)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabAirborneFrameset_16037)
	ld [wWarioFramesetPtr + 1], a
.pound_got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

.set_grab_smash_attacking
	ld a, $81
	ld [wIsSmashAttacking], a
	ld a, WST_GRAB_SMASH_ATTACKING
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ret

SetState_ThrowCharging:
	play_sfx SFX_THROW_CHARGE
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, WST_THROW_CHARGING
	ld [wWarioState], a
	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_CHARGE_THROW
	ld [wGrabState], a
	ld a, BANK(WarioThrowGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioThrowGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioThrowGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_1606a)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_1606a)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1606a)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioThrowChargingFrameset_1642c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowChargingFrameset_1642c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioThrowFrameset_1642f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFrameset_1642f)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ThrowCharging:
	ld a, [wGrabState]
	and a
	jp z, SetState_Idling
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jp z, StartThrow
	bit B_PAD_A, a
	jp nz, DropObjectAndJump
	bit B_PAD_DOWN, a
	jp nz, CrouchOrSlide

	ld a, [wGrabState]
	bit GRAB_HEAVY_F, a
	jr nz, .heavy
	ld b, THROW_CHARGE_FRAMES_LIGHT
	jr .got_charge_frames
.heavy
	ld b, THROW_CHARGE_FRAMES_HEAVY
.got_charge_frames
	ld a, [wWarioStateCounter]
	inc a
	ld [wWarioStateCounter], a
	cp b
	jr nc, .fully_charged
	ret

.fully_charged
	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, WST_THROW_FULLY_CHARGED
	ld [wWarioState], a
	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_THROW_FULLY_CHARGED
	ld [wGrabState], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioThrowChargingFrameset_16432)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowChargingFrameset_16432)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioThrowFrameset_16435)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFrameset_16435)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

DropObjectAndJump:
	xor a
	ld [wGrabState], a
	jp StartJump_FromInput

UpdateState_ThrowFullyCharged:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 30
	ld [wSFXLoopCounter], a
	play_sfx SFX_FULLY_CHARGED_THROW
.skip_sfx

	ld a, [wGrabState]
	and a
	jp z, SetState_Idling
	and GRAB_STATE_MASK
	cp GRAB_HOLD_FULL_CHARGE
	jr z, .update_animation
	ld a, [wWarioStateCounter]
	and a
	jr nz, .update_animation
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .update_animation
	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_HOLD_FULL_CHARGE
	ld [wGrabState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a
	ld [wWarioStateCounter], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioThrowFullyChargedFrameset_16438)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFullyChargedFrameset_16438)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioThrowFrameset_16441)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFrameset_16441)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr z, .throw
	bit B_PAD_A, a
	jp nz, DropObjectAndJump
	bit B_PAD_DOWN, a
	jp nz, CrouchOrSlide
	ret

.throw
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .throw_dir_right
	ld a, HIGH(WarioThrowFullyChargedFrameset_16403)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFullyChargedFrameset_16403)
	ld [wWarioFramesetPtr + 1], a
	jr .throw_got_frameset
.throw_dir_right
	ld a, HIGH(WarioThrowFrameset_16423)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFrameset_16423)
	ld [wWarioFramesetPtr + 1], a
.throw_got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_THROW | (1 << GRAB_FULL_CHARGE_F)
	ld [wGrabState], a
	jr SetState_Throwing

StartThrow:
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioThrowFrameset_163fe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFrameset_163fe)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioThrowFrameset_1641e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioThrowFrameset_1641e)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_THROW
	ld [wGrabState], a
;	fallthrough

SetState_Throwing:
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, WST_THROWING
	ld [wWarioState], a
	ret

UpdateState_Throwing:
	ld a, [wGrabState]
	and a
	jp z, SetState_Idling
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	xor a
	ld [wGrabState], a
	jp SetState_Idling

UpdateState_ThrowingAirborne:
	ld a, [wGrabState]
	and a
	jp z, StartFall
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	xor a
	ld [wGrabState], a
	jp StartFall

UpdateState_GrabSmashAttacking:
	ld a, [wGrabState]
	and a
	jp z, SetState_Idling
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $1b
	ret c
	xor a ; FALSE
	ld [wIsSmashAttacking], a
	jp SetState_GrabIdling

SetState_Sliding:
	ld a, WST_SLIDING
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wIsCrouching], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wWalkVelIndex], a
	ld [wGrabState], a

	ld a, TRUE
	ld [wIsRolling], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
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
	ld a, [wWarioSlopeInteraction]
	bit LEFT_SLOPE_F, a
	jr nz, .left_slope
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add $0c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $0c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a

	ld b, PARTICLE_SLIDE_DUST_LEFT
	farcall CreateParticle
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, HIGH(WarioSlidingFrameset_16708)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSlidingFrameset_16708)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset

.left_slope
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub $0c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $0c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a

	ld b, PARTICLE_SLIDE_DUST_RIGHT
	farcall CreateParticle
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, HIGH(WarioSlidFrameset_1671d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSlidFrameset_1671d)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Sliding:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 12
	ld [wSFXLoopCounter], a
	play_sfx SFX_ZIP_LINE_SLIDE
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleSlidingInput
	ld a, [wWarioState]
	cp WST_SLIDING
	ret nz ; not sliding anymore

	farcall CheckDownCollisionAtWario
	ld a, b
	and a
	jp z, SetState_RollingAirborne_Fall

	update_pos
	farcall CheckFrontCollision
	ld a, b
	and $0f
	jp nz, DoBumpWithSmallBackOffset
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

SetState_Rolling:
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a

	ld a, WST_ROLLING
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -14
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, $02
	ld [wIsRolling], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioRollFrameset_166e6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioRollFrameset_166e6)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioRollFrameset_166f7)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioRollFrameset_166f7)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Rolling:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 12
	ld [wSFXLoopCounter], a
	play_sfx SFX_ROLL
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .jump
	ld a, [wDirection]
	and a
	jr nz, .move_right
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .cap_walk_vel
.move_right
	call ApplyWalkVelocity_Right
	call MoveWarioRight

.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $18
	jr c, .check_collision
	ld a, $14
	ld [wWalkVelIndex], a
.check_collision
	farcall CheckFrontCollision
	ld a, b
	and $0f
	jp nz, DoBumpWithBigBackOffset
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_RollingAirborne_Fall

	update_pos_y

	ld a, [wWarioSlopeInteraction]
	and a
	ret z
	and $0f
	dec a
	ld b, a
	ld a, [wDirection]
	xor b
	jp nz, DoBumpWithSmallBackOffset
	ret

.jump
	farcall CheckCentreCollision
	update_pos_y
	ld a, [wWarioSlopeInteraction]
	and a
	jp z, SetState_RollingAirborne_Jump
	and $0f
	dec a
	ld b, a
	ld a, [wDirection]
	xor b
	jp nz, DoBumpWithSmallBackOffset
	jp SetState_RollingAirborne_Jump

SetState_RollingAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
;	fallthrough

SetState_RollingAirborne:
	xor a
	ld [wWarioSlopeInteraction], a
	ld [wGrabState], a
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
	ld a, WST_ROLLING_AIRBORNE
	ld [wWarioState], a
	ld a, $02
	ld [wIsRolling], a
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
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioRollFrameset_166e6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioRollFrameset_166e6)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioRollFrameset_166f7)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioRollFrameset_166f7)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_RollingAirborne_Jump:
	xor a
	ld [wJumpVelIndex], a
	jr SetState_RollingAirborne

UpdateState_RollingAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, DiveFromSurface
	ld a, [wIsInSand]
	and a
	jr z, .no_sand
	farcall SetState_SandFalling
	ret

.no_sand
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wDirection]
	and a
	jr nz, .move_right
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .cap_walk_vel
.move_right
	call ApplyWalkVelocity_Right
	call MoveWarioRight

.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $18
	jr c, .got_walk_vel
	ld a, $14
	ld [wWalkVelIndex], a
.got_walk_vel
	farcall CheckFrontCollision
	ld a, b
	and $0f
	jp nz, DoBumpWithBigBackOffset

	ld a, [wJumpVelIndex]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_HighJump
	add hl, de
	bit 7, [hl]
	jr z, .falling

; rising
	ld a, [hl]
	cpl
	inc a
	ld b, a
	call MoveWarioUp
	ld hl, wJumpVelIndex
	inc [hl]
	jr .moved_vertically

.falling
	ld b, [hl]
	call MoveWarioDown
	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp MAX_JUMP_VEL_INDEX
	jr c, .moved_vertically
	ld [hl], MAX_JUMP_VEL_INDEX

.moved_vertically
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .check_landing
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.check_landing
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	jp SetState_Rolling

UpdateState_PickedUp:
	ld a, [wDirection]
	and a
	jr nz, .dir_right

; dir left
	ld a, [wJoypadPressed]
	and PAD_A | PAD_B | PAD_RIGHT
	jr nz, .wiggle_right

.no_wiggle
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld hl, wPickedUpFrameCounter
	dec [hl]
	ret nz
	ld a, MAX_PICKEB_PAD_UPRAME_COUNTER
	ld [hl], a ; reset frame counter
	ld a, NUM_WIGGLES_TO_ESCAPE
	ld [wPickedUpWiggleCounter], a
	ret

.wiggle_right
	ld a, MAX_PICKEB_PAD_UPRAME_COUNTER
	ld [wPickedUpFrameCounter], a ; reset frame counter
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, HIGH(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 1], a
.wiggle_left
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, MAX_PICKEB_PAD_UPRAME_COUNTER
	ld [wPickedUpFrameCounter], a ; reset frame counter
	ld hl, wPickedUpWiggleCounter
	dec [hl]
	ret nz
	xor a
	ld [wAutoMoveState], a
	jp StartFall

.dir_right
	ld a, [wJoypadPressed]
	and PAD_A | PAD_B | PAD_LEFT
	jr z, .no_wiggle
	ld a, MAX_PICKEB_PAD_UPRAME_COUNTER
	ld [wPickedUpFrameCounter], a ; reset frame counter
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, HIGH(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 1], a
	jr .wiggle_left

UpdateState_GroundShakeStunned:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wGroundShakeCounter]
	and a
	jr z, .no_more_ground_shake
	ld a, [wJumpVelTable]
	and a
	ret z
	call ApplyJumpVelocity
	farcall HandleWalk
	call LimitAirWalkVelocity
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

.falling
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ret
.no_more_ground_shake
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr z, .can_stand
	jp CrouchOrSlide
.can_stand
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, StartFall
	jp SetState_Idling

UpdateState_EnteringDoor:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 36
	ld [wSFXLoopCounter], a
	play_sfx SFX_WALK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioStateCounter]
	dec a
	jr z, .enter
	dec a
	jr z, .wait
	dec a
	jr z, .exit
	ld a, [wWarioAnimationEnded]
	and a
	ret z

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFenceFrameset_14d15)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFenceFrameset_14d15)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld hl, wWarioStateCounter
	inc [hl]
	ret

.enter
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld hl, wWarioStateCounter
	inc [hl]
	ld hl, wRoomTransitionParam
	res ROOMTRANSITIONF_DELAY_F, [hl]
	jp TriggerRoomTransition

.wait
	ld hl, wWarioStateCounter
	inc [hl]
	ret

.exit
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_Walking_ResetWalkVel
	jp SetState_Idling

ApplyWaterCurrentMovement:
	call ApplyLastWaterCurrentMovement

	ld a, [wWaterCurrent]
	bit CURRENT_RIGHT_F, a
	jr nz, .right_current
	bit CURRENT_LEFT_F, a
	jr nz, .left_current
	bit CURRENT_UP_F, a
	jp nz, .up_current
	bit CURRENT_DOWN_F, a
	jp nz, .down_current

; no current
	ld a, [wCurWaterCurrent]
	and a
	call nz, .ChangeCurrentDirection
	xor a
	ld [wCurWaterCurrent], a
	ret

.right_current
	ld a, [wCurWaterCurrent]
	and CURRENT_LEFT | CURRENT_UP | CURRENT_DOWN
	call nz, .ChangeCurrentDirection
	ld hl, wWaterCurrent
	ld a, [hl]
	ld [wCurWaterCurrent], a
	res CURRENT_RIGHT_F, [hl]
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_RIGHT, a
	ret nz
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	ret nz
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_RIGHT, a
	ret nz
	bit B_PAD_LEFT, a
	jr z, .push_right
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	ret nc
.push_right
	ld b, 2
	call MoveWarioRight
	ret

.left_current
	ld a, [wCurWaterCurrent]
	and CURRENT_RIGHT | CURRENT_UP | CURRENT_DOWN
	call nz, .ChangeCurrentDirection
	ld hl, wWaterCurrent
	ld a, [hl]
	ld [wCurWaterCurrent], a
	res CURRENT_LEFT_F, [hl]
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_LEFT, a
	ret nz
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	ret nz
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_LEFT, a
	ret nz
	bit B_PAD_RIGHT, a
	jr z, .push_left
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	ret nc
.push_left
	ld b, 2
	call MoveWarioLeft
	ret

.up_current
	ld a, [wCurWaterCurrent]
	and CURRENT_RIGHT | CURRENT_LEFT | CURRENT_DOWN
	call nz, .ChangeCurrentDirection
	ld hl, wWaterCurrent
	ld a, [hl]
	ld [wCurWaterCurrent], a
	res CURRENT_UP_F, [hl]
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_UP, a
	ret nz
	farcall CheckUpCollision
	ld a, b
	and a
	ret nz
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_UP, a
	ret nz
	bit B_PAD_DOWN, a
	jr z, .push_up
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	ret nc
.push_up
	ld b, 2
	call MoveWarioUp
	ret

.down_current
	ld a, [wCurWaterCurrent]
	and CURRENT_RIGHT | CURRENT_LEFT | CURRENT_UP
	call nz, .ChangeCurrentDirection
	ld hl, wWaterCurrent
	ld a, [hl]
	ld [wCurWaterCurrent], a
	res CURRENT_DOWN_F, [hl]
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_DOWN, a
	ret nz
	farcall CheckCentreCollision
	ld a, b
	and a
	ret nz
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_DOWN, a
	ret nz
	bit B_PAD_UP, a
	jr z, .push_down
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	ret nc
.push_down
	ld b, 2
	call MoveWarioDown
	ret

.ChangeCurrentDirection:
	ld a, [wLastWaterCurrent]
	and a
	ret nz
	ld a, [wCurWaterCurrent]
	add 15 << 4
	ld [wLastWaterCurrent], a
	ret

; water currents have a "lingering" effect
; this routine applies the movements and
; decreases the counter for the duration of the effect
ApplyLastWaterCurrentMovement:
	ld a, [wLastWaterCurrent]
	and a
	ret z
	bit CURRENT_RIGHT_F, a
	jr nz, .right_current
	bit CURRENT_LEFT_F, a
	jr nz, .left_current
	bit CURRENT_UP_F, a
	jp nz, .up_current
	bit CURRENT_DOWN_F, a
	jp nz, .down_current
	ret

.right_current
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_RIGHT, a
	jr nz, .reset_last_water_current
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .reset_last_water_current
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_RIGHT, a
	jr nz, .decr_counter
	bit B_PAD_LEFT, a
	jr z, .push_right
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	jr nc, .decr_counter
.push_right
	ld b, 1
	call MoveWarioRight
	jr .decr_counter

.left_current
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_LEFT, a
	jr nz, .reset_last_water_current
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .reset_last_water_current
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_LEFT, a
	jr nz, .decr_counter
	bit B_PAD_RIGHT, a
	jr z, .push_left
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	jr nc, .decr_counter
.push_left
	ld b, 1
	call MoveWarioLeft

.decr_counter
	ld a, [wLastWaterCurrent]
	sub 1 << 4
	ld [wLastWaterCurrent], a
	and $f0
	ret nz
.reset_last_water_current
	xor a
	ld [wLastWaterCurrent], a
	ret

.up_current
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_UP, a
	jr nz, .reset_last_water_current
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .reset_last_water_current
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_UP, a
	jr nz, .decr_counter
	bit B_PAD_DOWN, a
	jr z, .push_up
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	jr nc, .decr_counter
.push_up
	ld b, 1
	call MoveWarioUp
	jr .decr_counter

.down_current
	ld a, [wWaterCurrentBlockedDir]
	bit B_PAD_DOWN, a
	jr nz, .reset_last_water_current
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .reset_last_water_current
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_DOWN, a
	jr nz, .decr_counter
	bit B_PAD_UP, a
	jr z, .push_down
	ld a, [wPowerUpLevel]
	cp PRINCE_FROGS_GLOVES
	jr nc, .decr_counter
.push_down
	ld b, 1
	call MoveWarioDown
	jr .decr_counter

HandleInput_Idling:
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_Attacking
	bit B_PAD_A, a
	jp nz, StartJump_FromInput
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right_1
	bit B_PAD_LEFT, a
	jr nz, .d_left_1
	ret

.d_right_1
	ld a, [wDirection]
	and a
	jr nz, SetState_Walking_ResetWalkVel
	jp SetState_Turning
.d_left_1
	ld a, [wDirection]
	and a
	jr z, SetState_Walking_ResetWalkVel
	jp SetState_Turning

SetState_Walking_ResetWalkVel:
	xor a
	ld [wWalkVelIndex], a
;	fallthrough

SetState_Walking:
	ld a, WST_WALKING
	ld [wWarioState], a
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right_2
	bit B_PAD_LEFT, a
	jr nz, .d_left_2
	jr .ok
.d_right_2
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jr .ok
.d_left_2
	ld a, DIRECTION_LEFT
	ld [wDirection], a

.ok
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
;	fallthrough

SetWarioWalkAnimation:
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
; dir_left
	ld a, HIGH(WarioWalkFrameset_149b4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWalkFrameset_149b4)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_149c5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_149c5)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_Turning:
	ld a, WST_TURNING
	ld [wWarioState], a
	xor a
	ld [wAttackCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_14a82)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_14a82)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_14a82)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_14cbe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14cbe)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_14cc5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14cc5)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_Attacking:
	ld a, MAX_ATTACK_COUNTER
	ld [wAttackCounter], a
	xor a
	ld [wSFXLoopCounter], a
	ld a, WST_ATTACKING
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a

	ld a, BANK(WarioOAM_14d1b)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_14d1b)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_14d1b)
	ld [wWarioOAMPtr + 1], a
	ld a, BANK(WarioAttackGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAttackGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAttackGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, [wPowerUpLevel]
	cp GARLIC
	jr nc, .powered_up
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_151e4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_151e4)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_151fd)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_151fd)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.powered_up
	ld a, [wDirection]
	and a
	jr nz, .powered_up_dir_right
	ld a, HIGH(WarioAttackingFrameset_1521c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioAttackingFrameset_1521c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.powered_up_dir_right
	ld a, HIGH(WarioFrameset_1522d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1522d)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

CrouchOrSlide:
	ld a, [wWarioSlopeInteraction]
	and a
	jp nz, SetState_Sliding
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, WST_CROUCHING
	ld [wWarioState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wWalkVelIndex], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld a, TRUE
	ld [wIsCrouching], a

	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_CrouchWalking

	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	cp DIRECTION_RIGHT
	jr z, .dir_right
	ld a, HIGH(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

HandleInput_Walking:
	ld a, [wJumpingUpwards]
	and a
	jr nz, .skip_jump
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jp nz, StartJump_FromInput
.skip_jump

	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_Attacking
	bit B_PAD_A, a
	jp nz, StartJump_FromInput

	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .d_down
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jr .no_input

.d_right
	ld a, [wDirection]
	and a
	jp z, SetState_Turning
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	call ApplyWalkVelocity_Right
	call MoveWarioRight
.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .done
	ld a, $0c
	ld [wWalkVelIndex], a
.done
	ret

.d_left
	ld a, [wDirection]
	and a
	jp nz, SetState_Turning
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .cap_walk_vel

.no_input
	call IsOnSlipperyGround
	jr z, SetState_Idling
	farcall SetState_Slipping
	ret

.d_down
	call IsOnSlipperyGround
	jp z, CrouchOrSlide
	farcall SetState_CrouchSlipping
	ret

SetState_Idling::
	xor a
	ld [wWalkVelIndex], a

	ld a, WST_IDLING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld [wIsCrouching], a
	ld [wAttackCounter], a
	ld [wGrabState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a

	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_IDLING
	ret nz
	ld a, b
	and a
	jp nz, CrouchOrSlide
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_14000)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_14000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_14000)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_14252)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14252)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_1425f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1425f)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

HandleInput_Attacking:
	ld a, [wDirection]
	and a
	jr nz, .dir_left
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jp nz, SetState_Turning

.check_pressed
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, StartJumpingAirborneAttack
	bit B_PAD_DOWN, a
	jp nz, SetState_CrouchSliding
	ret

.dir_left
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jp nz, SetState_Turning
	jr .check_pressed

HandleAttackingAirborneMovement:
	call ApplyJumpVelocity
	farcall HandleWalk
	ld a, [wWalkVelIndex]
	cp $14
	jr c, .done
	ld a, $10
	ld [wWalkVelIndex], a
.done
	ret

HandleBumpMovement:
	ld a, [wJumpVelIndex]
	cp 28
	jr c, .no_control
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, .no_control
	bit B_PAD_RIGHT, a
	jr nz, .d_right
; d-left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .start_fall
	ld b, 1
	call MoveWarioRight
	jr .start_fall

.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .start_fall
	ld b, 1
	call MoveWarioLeft

.start_fall
	xor a
	ld [wWalkVelIndex], a
	jp StartFall

.no_control
	ld a, [wDirection]
	cp DIRECTION_RIGHT
	jr z, .dir_right
; dir left
	ld b, 1
	call MoveWarioLeft
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr z, .handle_vertical
	ld b, 1
	call MoveWarioRight
	jr .handle_vertical
.dir_right
	ld b, 1
	call MoveWarioRight
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr z, .handle_vertical
	ld b, 1
	call MoveWarioLeft

.handle_vertical
	ld a, [wJumpVelIndex]
	ld e, a
	ld d, $00
	ld hl, JumpVelTable_Normal
	add hl, de
	bit 7, [hl]
	jr z, .rising
; falling
	ld a, [hl]
	cpl
	inc a
	ld b, a
	call MoveWarioUp
	ld hl, wJumpVelIndex
	inc [hl]
	jr .done
.rising
	ld b, [hl]
	call MoveWarioDown
	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp MAX_JUMP_VEL_INDEX
	jr c, .done
	ld [hl], MAX_JUMP_VEL_INDEX
.done
	ret

HandleCrouchingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, CrouchJump
	bit B_PAD_B, a
	jp nz, StandUpAndAttack
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .stay_crouched

	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_CROUCHING
	ret nz ; not crouching anymore

	ld a, b
	and a
	jp z, SetState_Idling

.stay_crouched
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	ret z
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jr SetState_CrouchWalking
.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
;	fallthrough

SetState_CrouchWalking:
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, WST_CROUCH_WALKING
	ld [wWarioState], a

	ld a, TRUE
	ld [wIsCrouching], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wAttackCounter], a
	ld [wGrabState], a
	ld [wSFXLoopCounter], a ; redundant

	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a
	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, [wDirection]
	cp DIRECTION_RIGHT
	jr z, .dir_right
	ld a, HIGH(WarioCrouchFrameset_14a26)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrouchFrameset_14a26)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioCrouchFrameset_14a2f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrouchFrameset_14a2f)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

CrouchJump:
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision

	ld a, [wWarioState]
	cp WST_CROUCHING
	jr z, .crouching
	cp WST_CROUCH_WALKING
	ret nz

.crouching
	ld a, b
	and a
	jp z, StartCrouchJump
	xor a
	ld [wJumpVelTable], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ret

StandUpAndAttack:
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .blocked
	jp SetState_Attacking
.blocked
	ld a, -15
	ld [wCollisionBoxTop], a
	ret

HandleCrouchWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, CrouchJump
	bit B_PAD_B, a
	jr nz, StandUpAndAttack
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr nz, .stay_crouched

	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_CROUCH_WALKING
	ret nz ; not crouch walking anymore

	ld a, b
	and a
	jp z, SetState_Idling

.stay_crouched
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp CrouchOrSlide

.d_right
	ld a, [wDirection]
	and a
	jr nz, .walk_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioCrouchFrameset_14a2f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrouchFrameset_14a2f)
	ld [wWarioFramesetPtr + 1], a
.walk_right
	farcall CheckFrontCollision
	ld a, b
	and $0f
	ret nz
	call ApplyWalkVelocity_Right
	call MoveWarioRight
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .done_right
	ld a, $00
	ld [wWalkVelIndex], a
.done_right
	ret

.d_left
	ld a, [wDirection]
	and a
	jr z, .walk_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioCrouchFrameset_14a26)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrouchFrameset_14a26)
	ld [wWarioFramesetPtr + 1], a
.walk_left
	farcall CheckFrontCollision
	ld a, b
	and $0f
	ret nz
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .done_left
	ld a, $00
	ld [wWalkVelIndex], a
.done_left
	ret

StartCrouchFall:
	xor a
	ld [wWalkVelIndex], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr SetState_CrouchAirborne

StartCrouchJump:
	play_sfx SFX_JUMP
	xor a
	ld [wJumpVelIndex], a
;	fallthrough

SetState_CrouchAirborne:
	ld a, WST_CROUCH_AIRBORNE
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wIsOnSteppableObject]
	and a
	ret z
	ld b, $02
	call MoveWarioUp
	ret

SetState_GrabAirborne_Fall:
	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_IDLE
	ld [wGrabState], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a
	jr SetState_GrabAirborne
;	fallthrough

SetState_GrabAirborne_Jump:
	play_sfx SFX_JUMP
	xor a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	ld a, JUMP_VEL_NORMAL
	jr c, .got_jump_vel_table
	ld hl, wJoypadDown
	bit B_PAD_UP, [hl]
	jr z, .got_jump_vel_table
	ld a, JUMP_VEL_HIGH_JUMP
.got_jump_vel_table
	ld [wJumpVelTable], a
;	fallthrough

SetState_GrabAirborne:
	ld a, WST_GRAB_AIRBORNE
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioGrabFrameset_15fa8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_15fa8)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioGrabFrameset_15fab)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_15fab)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wIsOnSteppableObject]
	and a
	ret z
	call UpdateState_GrabAirborne
	ret

HandleGrabIdlingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_GrabAirborne_Jump
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jp nz, SetState_ThrowCharging
	bit B_PAD_DOWN, a
	jp nz, CrouchOrSlide
	and PAD_RIGHT | PAD_LEFT
	jr nz, .walk
	ret

.walk
	ld a, WST_GRAB_WALKING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .walk_right
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, HIGH(WarioGrabFrameset_149fe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_149fe)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.walk_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, HIGH(WarioGrabFrameset_14a0f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_14a0f)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

HandleGrabWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_ThrowCharging
	bit B_PAD_A, a
	jp nz, SetState_GrabAirborne_Jump
	bit B_PAD_DOWN, a
	jp nz, .d_down
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	call IsOnSlipperyGround
	jr z, .not_slippery
	farcall SetState_GrabSlipping
	ret

.not_slippery
	jp SetState_GrabIdling

.d_right
	ld a, [wDirection]
	and a
	jp z, SetState_GrabIdling
	farcall CheckFrontCollision
	ld a, b
	and $0f
	ret nz
	jr .walk_right

.d_left
	ld a, [wDirection]
	and a
	jp nz, SetState_GrabIdling
	farcall CheckFrontCollision
	ld a, b
	and $0f
	ret nz
	jr .walk_left

.walk_right
	call ApplyWalkVelocity_Right
	call MoveWarioRight
	ld a, [wWarioSlopeInteraction]
	and a
	jr z, .cap_walk_vel
	bit RIGHT_SLOPE_F, a
	jr z, .cap_walk_vel
	jr .cap_walk_vel_slow

.walk_left
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	ld a, [wWarioSlopeInteraction]
	and a
	jr z, .cap_walk_vel
	bit RIGHT_SLOPE_F, a
	jr nz, .cap_walk_vel
	jr .cap_walk_vel_slow
.cap_walk_vel
	ld a, [wGrabState]
	bit GRAB_HEAVY_F, a
	jr nz, .cap_heavy
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .done
	ld a, $0c
	ld [wWalkVelIndex], a
.done
	ret

.cap_heavy
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .done
	ld a, $04
	ld [wWalkVelIndex], a
	jr .done

.d_down
	call IsOnSlipperyGround
	jp z, CrouchOrSlide
	farcall SetState_CrouchSlipping
	ret

.cap_walk_vel_slow
	ld a, [wGrabState]
	bit GRAB_HEAVY_F, a
	jr nz, .cap_heavy_slow
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .done_slow
	ld a, $04
	ld [wWalkVelIndex], a
.done_slow
	ret

.cap_heavy_slow
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .done_slow
	ld a, $00
	ld [wWalkVelIndex], a
	jr .done_slow

SetState_GrabIdling:
	ld a, [wGrabState]
	and a
	jp z, SetState_Idling

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsSmashAttacking], a
	ld [wIsCrouching], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, [wGrabState]
	and GRAB_FLAGS_MASK
	add GRAB_IDLE
	ld [wGrabState], a

	ld a, WST_GRAB_IDLING
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioGrabFrameset_14a20)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_14a20)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioGrabFrameset_14a23)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_14a23)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

HandleInput_Airborne:
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr nz, .skip_set_fall

; not pressing A button any more, so
; set wJumpingUpwards to false and
; if still in a rising jump vel index
; then immediately set it to the falling index
	xor a ; FALSE
	ld [wJumpingUpwards], a
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .skip_set_fall
	ld a, [wDoFullJump]
	and a
	jr nz, .skip_set_fall
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
.skip_set_fall

	ld a, [wJumpVelIndex]
	ld e, a
	ld d, $00
	ld a, [wJumpVelTable]
	dec a
	jr z, .knock_back
	dec a
	jr z, .normal_jump
; high jump
	ld hl, JumpVelTable_HighJump ; JUMP_VEL_HIGH_JUMP
	jr .got_jump_vel_table
.normal_jump
	ld hl, JumpVelTable_Normal ; JUMP_VEL_NORMAL
	jr .got_jump_vel_table
.knock_back
	ld hl, JumpVelTable_KnockBack ; JUMP_VEL_KNOCK_BACK
.got_jump_vel_table
	add hl, de
	bit 7, [hl]
	jr z, .falling

; rising
	ld a, [hl]
	cpl
	inc a
	ld b, a
	call MoveWarioUp
	ld hl, wJumpVelIndex
	inc [hl]
	jr .check_input

.falling
	xor a
	ld [wDoFullJump], a
	ld b, [hl]
	call MoveWarioDown
	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp MAX_JUMP_VEL_INDEX
	jr c, .check_input
	ld [hl], MAX_JUMP_VEL_INDEX

.check_input
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	ret

.d_right
	call WalkRight
	jp LimitAirWalkVelocity

.d_left
	call WalkLeft
	jp LimitAirWalkVelocity

WalkRight:
	xor a
	ld [wIsTurning], a
	ld a, [wDirection]
	and a
	jr nz, .walk
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, TRUE
	ld [wIsTurning], a
.walk
	jp WalkIfPossible_Right

WalkLeft:
	xor a
	ld [wIsTurning], a
	ld a, [wDirection]
	and a
	jr z, .walk
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, TRUE
	ld [wIsTurning], a
.walk
	jp WalkIfPossible_Left

WalkIfPossible_Right:
	farcall CheckFrontCollision
	ld a, b
	and $0f
	ret nz
	call ApplyWalkVelocity_Right
	call MoveWarioRight
	ret

WalkIfPossible_Left:
	farcall CheckFrontCollision
	ld a, b
	and $0f
	ret nz
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	ret

HandleDivingHorizontalMovement:
	ld a, [wPowerUpLevel]
	cp SWIMMING_FLIPPERS
	ret c
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	ret

.d_right
	ld a, [wDirection]
	cp DIRECTION_RIGHT
	jr z, .has_right_dir
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
.has_right_dir
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	ld b, 1
	call MoveWarioRight
	ret

.d_left
	ld a, [wDirection]
	cp DIRECTION_LEFT
	jr z, .has_left_dir
	ld a, DIRECTION_LEFT
	ld [wDirection], a
.has_left_dir
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	ld b, 1
	call MoveWarioLeft
	ret

HandleSubmergedInput:
	ld a, [wWaterInteraction]
	cp NON_SUBMERSIBLE_WATER
	jr z, .update_animation
	ld a, [wPowerUpLevel]
	cp SWIMMING_FLIPPERS
	jr c, .update_animation
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, StartUnderwaterThrusting
	bit B_PAD_A, a
	jp nz, StartUpwardsUnderwaterThrusting
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	jp nz, HandleSwimming

	ld a, [wWarioStateCycles]
	and a
	jr nz, .update_animation
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwimFrameset_15569)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15569)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioSwimFrameset_15573)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15573)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, $01
	ld [wWarioStateCycles], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .blocked_above
	farcall UpdateEnvStateAtChest
	ld a, [wWaterInteraction]
	and a
	jp z, SurfaceFromUnderwater
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_UP | CURRENT_DOWN
	ret nz
	ld b, $01
	call MoveWarioUp
	ret

.blocked_above
	ld a, PAD_UP
	ld [wWaterCurrentBlockedDir], a
	ret

HandleSwimming:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 37
	ld [wSFXLoopCounter], a
	play_sfx SFX_SWIM
.skip_sfx

	ld a, [wWarioStateCycles]
	and a
	jr z, .update_animation
	xor a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwimFrameset_15576)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15576)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioSwimFrameset_1558b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_1558b)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wGlobalCounter]
	and %1
	jr z, .vertical
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .swim_right
	bit B_PAD_LEFT, a
	jp nz, SwimLeft
	ret

.vertical
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jp nz, SwimUp
	bit B_PAD_DOWN, a
	jp nz, SwimDown
	ret

.swim_right
	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, .check_stung
	update_pos_y
.check_stung
	ld a, [wWarioState]
	cp WST_WATER_STUNG
	ret z
	ld a, [wDirection]
	and a
	jr nz, SwimForward
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioSwimFrameset_1558b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_1558b)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SwimForward:
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .blocked
	ld a, [wDirection]
	and a
	jr z, .facing_left
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_RIGHT | CURRENT_LEFT
	ret nz
	ld b, $01
	call MoveWarioRight
	ret

.facing_left
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_RIGHT | CURRENT_LEFT
	ret nz
	ld b, $01
	call MoveWarioLeft
	ret

.blocked
	ld a, [wDirection]
	and a
	jr z, .blocked_left
	ld a, PAD_RIGHT
	ld [wWaterCurrentBlockedDir], a
	ret

.blocked_left
	ld a, PAD_LEFT
	ld [wWaterCurrentBlockedDir], a
	ret

SwimLeft:
	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, .check_stung
	update_pos_y
.check_stung
	ld a, [wWarioState]
	cp WST_WATER_STUNG
	ret z
	ld a, [wDirection]
	and a
	jr z, SwimForward
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioSwimFrameset_15576)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwimFrameset_15576)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SwimDown:
	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, .move_down
	update_pos_y
	ld a, PAD_DOWN
	ld [wWaterCurrentBlockedDir], a
	ret

.move_down
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_UP | CURRENT_DOWN
	ret nz
	ld b, $01
	call MoveWarioDown
	ret

SwimUp:
	farcall CheckUpCollision
	ld a, b
	and a
	ret nz
	farcall UpdateEnvStateAtChest
	ld a, [wWaterInteraction]
	and a
	jp z, SurfaceFromUnderwater
	ld hl, wCurWaterCurrent
	ld a, [hld]
	or [hl] ; wLastWaterCurrent
	and CURRENT_UP | CURRENT_DOWN
	ret nz
	ld b, $01
	call MoveWarioUp
	ret

HandleWaterSurfaceInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, StartJump_FromWaterSurface
	bit B_PAD_B, a
	jr z, .no_thrust

	ld a, [wPowerUpLevel]
	cp SWIMMING_FLIPPERS
	jp c, .no_thrust ; should be jr
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	ret nz
	farcall UpdateEnvStateAtFeet
	ld a, [wWaterInteraction]
	cp NON_SUBMERSIBLE_WATER
	jp z, SetState_TryingSubmerge
	ld b, 3
	call MoveWarioDown
	jp StartUnderwaterThrusting

.no_thrust
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	ret z
	ld a, [wPowerUpLevel]
	cp SWIMMING_FLIPPERS
	jp c, SetState_TryingSubmerge
	farcall UpdateEnvStateAtFeet
	ld a, [wWaterInteraction]
	cp NON_SUBMERSIBLE_WATER
	jp z, SetState_TryingSubmerge
	jp SetState_Submerged

HandleUnderwaterThrustingInput:
	ld hl, wSwimVelIndex
	inc [hl]
	ld a, [hl]
	cp 40
	jr c, .continue
	xor a
	ld [hl], a
	; If B or A still held, restart the cycle without surfacing
	ld a, [wJoypadDown]
	and PAD_A | PAD_B
	jp z, SetState_Submerged
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	ld [wSwimmingDirectionInput], a
.continue
	ld a, [wJoypadDown]
	and PAD_A | PAD_B
	jp z, SetState_Submerged

	ld a, [wSwimmingDirectionInput]
	bit B_PAD_RIGHT, a
	jr nz, .right
	bit B_PAD_LEFT, a
	jr nz, .left
	bit B_PAD_UP, a
	jp nz, .up
	bit B_PAD_DOWN, a
	jp nz, .down
	ret

.right
	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, .right_check_stung
	update_pos_y
.right_check_stung
	ld a, [wWarioState]
	cp WST_WATER_STUNG
	ret z
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jp nz, SetState_SwimKnockBack_SwitchDirection
	ld a, [wSwimVelIndex]
	ld e, a
	ld d, $00
	ld hl, SwimStraightVelTable
	ld a, [wSwimmingDirectionInput]
	and PAD_UP | PAD_DOWN
	jr z, .not_diagonal_1
	ld hl, SwimDiagonalVelTable
.not_diagonal_1
	add hl, de
	ld b, [hl]
	call MoveWarioRight
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_UP, a
	jp nz, .up
	bit B_PAD_DOWN, a
	jp nz, .down
	jr .handle_diagonal_movement

.left
	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, .left_check_stung
	update_pos_y
.left_check_stung
	ld a, [wWarioState]
	cp WST_WATER_STUNG
	ret z
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jp nz, SetState_SwimKnockBack_SwitchDirection
	ld a, [wSwimVelIndex]
	ld e, a
	ld d, $00
	ld hl, SwimStraightVelTable
	ld a, [wSwimmingDirectionInput]
	and PAD_UP | PAD_DOWN
	jr z, .not_diagonal_2
	ld hl, SwimDiagonalVelTable
.not_diagonal_2
	add hl, de
	ld b, [hl]
	call MoveWarioLeft
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_UP, a
	jp nz, .up
	bit B_PAD_DOWN, a
	jp nz, .down
	jr .handle_diagonal_movement ; useless

.handle_diagonal_movement
	ld a, [wJoypadDown]
	and PAD_UP | PAD_DOWN
	ret z
	bit B_PAD_DOWN, a
	jr nz, .diagonal_down

; diagonal up
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .diagonal_up_blocked
	farcall UpdateEnvStateAtChest
	ld a, [wWaterInteraction]
	and a
	jp z, SurfaceFromUnderwater
	ld b, 1
	call MoveWarioUp
	ret

.diagonal_up_blocked
	ld hl, wWaterCurrentBlockedDir
	set B_PAD_UP, [hl]
	ret

.diagonal_down
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .diagonal_down_blocked
	ld b, 1
	call MoveWarioDown
	ret

.diagonal_down_blocked
	update_pos_y
	ld hl, wWaterCurrentBlockedDir
	set B_PAD_DOWN, [hl]
	ret

.down
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .down_blocked
	ld a, [wSwimVelIndex]
	ld e, a
	ld d, $00
	ld hl, SwimStraightVelTable
	ld a, [wSwimmingDirectionInput]
	and PAD_RIGHT | PAD_LEFT
	jr z, .down_got_table
	ld hl, SwimDiagonalVertVelTable
.down_got_table
	add hl, de
	ld b, [hl]
	call MoveWarioDown
	ret

.down_blocked
	update_pos_y
	ld hl, wWaterCurrentBlockedDir
	set B_PAD_DOWN, [hl]
	ret

.up
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .up_blocked
	farcall UpdateEnvStateAtChest
	ld a, [wWaterInteraction]
	and a
	jp z, SurfaceFromUnderwater
	ld a, [wSwimVelIndex]
	ld e, a
	ld d, $00
	ld hl, SwimStraightVelTable
	ld a, [wSwimmingDirectionInput]
	and PAD_RIGHT | PAD_LEFT
	jr z, .up_got_table
	ld hl, SwimDiagonalVertVelTable
.up_got_table
	add hl, de
	ld b, [hl]
	call MoveWarioUp
	ret

.up_blocked
	ld hl, wWaterCurrentBlockedDir
	set B_PAD_UP, [hl]
	jp StartDive

HandleInvincibility:
	ld a, [wInvincibleCounter]
	and a
	ret z
	cp $16
	jr nc, .fast
	cp $10
	jr nc, .slow

; if stung, then skip this
	ld a, [wWarioState]
	cp WST_STUNG
	jr z, .done
	cp WST_STUNG_RECOVERY
	jr z, .done

; set invicible counter
; and regular Wario palette
	ld a, $10
	ld [wInvincibleCounter], a
	ld a, [wWarioPalsPtr + 0]
	cp HIGH(WarioInvisiblePal)
	jr nz, .done
	ld a, [wWarioPalsPtr + 1]
	cp LOW(WarioInvisiblePal)
	jr nz, .done

	ld hl, WarioDefaultPal
	call SetWarioPal
.done
	ret

.slow
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld a, [wInvincibleCounter]
	inc a
	ld [wInvincibleCounter], a
	jr .alternate_invisibility

.fast
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld a, [wInvincibleCounter]
	inc a
	ld [wInvincibleCounter], a
	cp $28
	jr c, .alternate_invisibility
	; not more invincibility
	xor a
	ld [wInvincibleCounter], a
	ld [wInvisibleFrame], a

	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT | PAD_DOWN
	ret nz
	farcall CheckUpCollision
	ret

.alternate_invisibility
	ld a, [wInvisibleFrame]
	xor $1
	ld [wInvisibleFrame], a
	ret

BlinkWarioPal:
	ld a, [wGlobalCounter]
	and %111
	jr z, .set_invisible_pal
	cp 3
	jr z, .set_default_pal
	ret

.set_invisible_pal
	ld hl, WarioInvisiblePal
	call SetWarioPal
	ret

.set_default_pal
	ld hl, WarioDefaultPal
	call SetWarioPal
	ret

HandleGroundShake:
	ld a, [wLevelEndScreen]
	and a
	ret nz

	ld hl, wGroundShakeCounter
	ld a, [hl]
	and a
	jr z, .no_ground_shake

	; there is ground shake, check if there are
	; conditions to stun Wario (on ground or ladder)
	cp $10
	jr c, .continue ; ground shake counter >= $10
	ld a, [wIsGettingOffLadder]
	and a
	jr nz, .continue ; getting off ladder
	ld a, [wIsWarioGroundShaking]
	and a
	jr nz, .continue ; Wario himself is ground shaking
	ld a, [wJumpVelTable]
	and a
	jr nz, .continue ; Wario is jumping/falling
	ld a, [wWaterInteraction]
	and a
	jr nz, .continue ; Wario is interacting with water
	ld a, [wTransformation]
	and a
	jr nz, .continue ; Wario is in a transformation
	ld a, [wRoomTransitionParam]
	and a
	jr nz, .continue ; room transition happening
	ld a, [wIsIntangible]
	and a
	jr nz, .continue ; Wario is intangible
	ld a, [wIsOnSteppableObject]
	and a
	jr nz, .continue ; Wario is on a steppable object
	ld a, [wWarioState]
	cp WST_GROUND_SHAKE_STUNNED
	jr z, .continue ; Wario is already shake stunned
	jr .wario_shake_stun
	ret ; unnecessary

.no_ground_shake
	xor a
	ld [wIsWarioGroundShaking], a
	ret

.continue
	dec [hl]
	ld a, [hl]
	and %10
	jr nz, .offset_scy
	xor a
	ld [wSCYShake], a
	ret
.offset_scy
	ld a, 2
	ld [wSCYShake], a
	ret

.wario_shake_stun
	; if in a ladder, do ladder shake stun
	ld a, [wWarioState]
	cp WST_LADDER_CLIMBING
	jp z, SetState_LadderShakeStunned
	cp WST_LADDER_IDLING
	jp z, SetState_LadderShakeStunned
	cp WST_LADDER_SCRATCHING
	jp z, SetState_LadderShakeStunned
	; else, do ground shake stun
	ld a, WST_GROUND_SHAKE_STUNNED
	ld [wWarioState], a
	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wAttackCounter], a
	ld [wIsRolling], a
	ld [wGrabState], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, [wIsCrouching]
	and a
	jr nz, .crouching
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, 10
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
.crouching
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_15955)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_LadderShakeStunned:
	ld a, WST_LADDER_SHAKE_SLIDING
	ld [wWarioState], a
	play_sfx SFX_SLIDE

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsGettingOffLadder], a
	inc a
	ld [wJumpVelTable], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioLadderShakeStunnedFrameset_15948)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLadderShakeStunnedFrameset_15948)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

HandleSlidingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .a_btn
	ld a, [wDirection]
	and a
	jr nz, .dir_right

; dir left
	ld a, [wJoypadPressed]
	bit B_PAD_RIGHT, a
	jr nz, .stop
	call WalkIfPossible_Left
.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .done
	ld a, $04
	ld [wWalkVelIndex], a
.done
	ret

.dir_right
	ld a, [wJoypadPressed]
	bit B_PAD_LEFT, a
	jr nz, .stop
	call WalkIfPossible_Right
	jr .cap_walk_vel
.stop
	xor a
	ld [wIsRolling], a
	jp SetState_Idling

.a_btn
	xor a
	ld [wIsRolling], a
	jp StartJump_FromInput

MoveWarioUpBySwimVel:
	ld hl, SwimStraightVelTable
	add hl, de
	ld b, [hl]
	call MoveWarioUp
	ret

SwimStraightVelTable:
	db $01, $01, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00

SwimDiagonalVertVelTable:
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00

SwimDiagonalVelTable:
	db $01, $01, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $00, $00, $00
