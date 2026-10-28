UpdateWarioStates_Group2:
	ld a, [wWarioState]
	sub $30
	jumptable

	dw UpdateState_Slipping              ; WST_SLIPPING
	dw UpdateState_CrouchSlipping        ; WST_CROUCH_SLIPPING
	dw UpdateState_DraggedDown           ; WST_DRAGGED_DOWN
	dw UpdateState_Teleporting           ; WST_TELEPORTING
	dw UpdateState_WaterTeleporting      ; WST_WATER_TELEPORTING
	dw UpdateState_SandFalling           ; WST_SAND_FALLING
	dw UpdateState_SandJumping           ; WST_SAND_JUMPING
	dw UpdateState_SandIdling            ; WST_SAND_IDLING
	dw UpdateState_SandWalking           ; WST_SAND_WALKING
	dw UpdateState_SandTurning           ; WST_SAND_TURNING
	dw UpdateState_LadderClimbing        ; WST_LADDER_CLIMBING
	dw UpdateState_LadderIdling          ; WST_LADDER_IDLING
	dw UpdateState_LadderShakeSlipping   ; WST_LADDER_SHAKE_SLIDING
	dw UpdateState_GettingOffLadder      ; WST_GETTING_OFF_LADDER
	dw UpdateState_LadderSliding         ; WST_LADDER_SLIDING
	dw UpdateState_GrabSlipping          ; WST_GRAB_SLIPPING
	dw UpdateState_GetTreasureStart      ; WST_GET_TREASURE_START
	dw UpdateState_GetTreasureWalk       ; WST_GET_TREASURE_WALK_1
	dw UpdateState_GetTreasureTurnFront  ; WST_GET_TREASURE_TURN_FRONT_1
	dw UpdateState_GetTreasureLaugh      ; WST_GET_TREASURE_LAUGH
	dw UpdateState_GetTreasureTurnBack   ; WST_GET_TREASURE_TURN_BACK
	dw UpdateState_GetTreasureOpen       ; WST_GET_TREASURE_OPEN
	dw UpdateState_GetTreasureTurnWalk   ; WST_GET_TREASURE_TURN_WALK
	dw UpdateState_GetTreasureWalk       ; WST_GET_TREASURE_WALK_2
	dw UpdateState_GetTreasureTurnFront  ; WST_GET_TREASURE_TURN_FRONT_2
	dw UpdateState_GetTreasureLookFront  ; WST_GET_TREASURE_LOOK_FRONT
	dw UpdateState_GetTreasureClear      ; WST_GET_TREASURE_CLEAR
	dw UpdateState_Sleeping              ; WST_SLEEPING
	dw UpdateState_LadderScratching      ; WST_LADDER_SCRATCHING
	dw UpdateState_FenceShakeSliding     ; WST_FENCE_SHAKE_SLIDING
	dw UpdateState_FenceMovingVertical   ; WST_FENCE_MOVING_VERTICAL
	dw UpdateState_FenceIdling           ; WST_FENCE_IDLING
	dw UpdateState_FenceMovingHorizontal ; WST_FENCE_MOVING_HORIZONTAL
	dw UpdateState_FenceSliding          ; WST_FENCE_SLIDING
	dw InvalidWarioStateReset            ; WST_UNUSED_52
	dw InvalidWarioStateReset            ; WST_UNUSED_53
	dw InvalidWarioStateReset            ; WST_UNUSED_54
	dw InvalidWarioStateReset            ; WST_UNUSED_55
	dw InvalidWarioStateReset            ; WST_UNUSED_56
	dw InvalidWarioStateReset            ; WST_UNUSED_57
	dw InvalidWarioStateReset            ; WST_UNUSED_58
	dw InvalidWarioStateReset            ; WST_UNUSED_59
	dw InvalidWarioStateReset            ; WST_UNUSED_5A
	dw InvalidWarioStateReset            ; WST_UNUSED_5B
	dw InvalidWarioStateReset            ; WST_UNUSED_5C
	dw InvalidWarioStateReset            ; WST_UNUSED_5D
	dw InvalidWarioStateReset            ; WST_UNUSED_5E
	dw InvalidWarioStateReset            ; WST_UNUSED_5F

SetState_Slipping:
	ld a, WST_SLIPPING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wAttackCounter], a
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_14000)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14000)
	ld [wWarioOAMPtr + 1], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	ld [wWarioStateCycles], a
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

UpdateState_Slipping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wWarioStateCycles]
	cp $04
	jp nc, .animate
	cp $02
	jr nc, .turning
	ld b, a

	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp z, .animate
	rlca
	rlca
	rlca
	and $01
	cp b
	jp nz, .animate
	xor $1
	add 2
	ld [wWarioStateCycles], a

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

	ld a, [wWarioStateCycles]
	and $01
	jr nz, .turn_facing_right
	ld a, HIGH(WarioFrameset_14cbe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14cbe)
	ld [wWarioFramesetPtr + 1], a
	jr .reset_animation
.turn_facing_right
	ld a, HIGH(WarioFrameset_14cc5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14cc5)
	ld [wWarioFramesetPtr + 1], a
	jr .reset_animation

.turning
	ld b, a
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .animate
	ld a, b
	add $02
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

	ld a, [wWarioStateCycles]
	and $01
	jr nz, .walk_facing_right
	ld a, HIGH(WarioWalkFrameset_149b4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWalkFrameset_149b4)
	ld [wWarioFramesetPtr + 1], a
	jr .reset_animation
.walk_facing_right
	ld a, HIGH(WarioFrameset_149c5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_149c5)
	ld [wWarioFramesetPtr + 1], a
	jr .reset_animation

.reset_animation
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
.animate
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .no_jump
	farcall StartJump_FromInput
	ret

.no_jump
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr z, .no_crouch
	jp SetState_CrouchSlipping_KeepCounter

.no_crouch
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_SLIPPING
	ret nz ; done if not slipping any more

	ld a, b
	and a
	jr nz, .on_ground
	farcall StartFall
	ret

.on_ground
	update_pos_y
	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_SLIPPING
	ret nz ; done if not slipping any more

	ld a, b
	and a
	jr nz, .stop_slipping
	call IsOnSlipperyGround
	jr z, .stop_slipping
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	ld a, [hl]
	cp $08
	jr c, .slide_fast
	cp $0f
	jr c, .slide_slow
	cp $15
	jr c, .slide_every_other_frame
	jr z, .stop_slipping
	ret

.slide_fast
	ld b, $02
	jr .move
.slide_every_other_frame
	ld a, [wGlobalCounter]
	and %1
	ret z
.slide_slow
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

.stop_slipping
	ld a, [wWarioStateCycles]
	and $01
	ld [wDirection], a
	farcall SetState_Idling
	ret

SetState_CrouchSlipping:
	xor a
	ld [wWarioStateCounter], a
	ld a, [wDirection]
	ld [wWarioStateCycles], a
;	fallthrough

SetState_CrouchSlipping_KeepCounter:
	ld a, WST_CROUCH_SLIPPING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wAttackCounter], a
	ld [wGrabState], a
	inc a
	ld [wIsCrouching], a
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
	ld a, [wWarioStateCycles]
	cp $01
	jr z, .facing_right
	ld a, HIGH(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.facing_right
	ld a, HIGH(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_CrouchSlipping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .no_jump
	farcall StartCrouchJump
	ret

.no_jump
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_CROUCH_SLIPPING
	ret nz ; done if not crouch slipping any more
	ld a, b
	and a
	jr nz, .on_ground
	farcall StartCrouchFall
	ret

.on_ground
	update_pos_y
	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_CROUCH_SLIPPING
	ret nz ; done if not crouch slipping any more
	ld a, b
	and a
	jr nz, .stop_slipping
	call IsOnSlipperyGround
	jr z, .stop_slipping

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $06
	jr c, .slide_fast
	cp $0a
	jr c, .slide_slow
	cp $0e
	jr c, .slide_every_other_frame
	jr nc, .stop_slipping
	ret

.slide_fast
	ld b, $02
	jr .move
.slide_every_other_frame
	ld a, [wGlobalCounter]
	and %1
	ret z
.slide_slow
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

.stop_slipping
	ld a, [wWarioStateCycles]
	and $01
	ld [wDirection], a
	farcall CrouchOrSlide
	ret

SetState_DraggedDown:
	ld a, WST_DRAGGED_DOWN
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wAttackCounter], a
	ld [wGrabState], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld [wIsCrouching], a
	ld [wIsRolling], a

	inc a
	ld [wAutoMoveState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a

	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_15955)
	ld [wWarioOAMPtr + 1], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

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

UpdateState_DraggedDown:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wAutoMoveState]
	and a
	ret nz
	ld a, [wLevel]
	cp THE_TEMPLE
	jr z, .set_game_over
	farcall StartFall
	ret

.set_game_over
	ld a, LVLEND_GAME_OVER
	ld [wLevelEndScreen], a
	ret

UpdateState_Teleporting:
	ld a, TRUE
	ld [wIsIntangible], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $01
	jr z, PlayTeleportingSFX
	cp $b4
	ret c
	ld [hl], $00
	ld a, WST_STUNG
	ld [wWarioState], a
	ld a, $01
	ld [wInvincibleCounter], a
	ld hl, wRoomTransitionParam
	res ROOMTRANSITIONF_DELAY_F, [hl]
	jp TriggerRoomTransition

PlayTeleportingSFX:
	play_sfx SFX_TELEPORT
	ret

UpdateState_WaterTeleporting:
	ld a, TRUE
	ld [wIsIntangible], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $11
	jr z, PlayTeleportingSFX
	cp $b4
	ret c
	ld [hl], $00
	ld a, WST_WATER_STUNG
	ld [wWarioState], a
	ld a, $01
	ld [wInvincibleCounter], a
	ld hl, wRoomTransitionParam
	res ROOMTRANSITIONF_DELAY_F, [hl]
	jp TriggerRoomTransition

SetState_SandFalling:
	xor a
	ld [wGrabState], a
	ld a, WST_SAND_FALLING
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
;	fallthrough

SetWarioSandAirborneAnimation:
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_15955)
	ld [wWarioOAMPtr + 1], a
;	fallthrough

SetWarioSandAirborneFrameset:
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
	ret

UpdateState_SandFalling:
	call HandleSandFallingInput
	ld a, [wWarioState]
	cp WST_SAND_FALLING
	ret nz ; done if not falling in sand any more

	farcall CheckCentreCollision
	ld a, b
	and a
	ret z
	update_pos_y
	jp SetState_SandIdling

SetState_SandJumping:
	play_sfx SFX_JUMP
	ld a, WST_SAND_JUMPING
	ld [wWarioState], a
	xor a
	ld [wJumpVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	inc a
	ld [wJumpVelTable], a
	jp SetWarioSandAirborneAnimation

UpdateState_SandJumping:
	farcall CheckTopBlockInteraction
	ld a, [wIsInSand]
	and a
	jr nz, .in_sand
; not in sand
	farcall StartJump_FromSand
	ret

.in_sand
	call ApplyJumpVelocity
	farcall WalkFromInput
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .got_walk_vel
	ld a, $00
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wIsTurning]
	and a
	jr z, .not_turning
	call SetWarioSandAirborneFrameset

.not_turning
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jp z, SetState_SandFalling

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jp nc, SetState_SandFalling

; rising
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	jp SetState_SandFalling

SetState_SandIdling:
	ld a, WST_SAND_IDLING
	ld [wWarioState], a

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_14000)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14000)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
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

UpdateState_SandIdling:
	call HandleSandIdlingInput
	ret

SetState_SandWalking:
	xor a
	ld [wWalkVelIndex], a

	ld a, WST_SAND_WALKING
	ld [wWarioState], a

	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jr .got_direction

.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jr .got_direction
.d_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a

.got_direction
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	farcall SetWarioWalkAnimation
	ret

UpdateState_SandWalking:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $24
	ld [wSFXLoopCounter], a
	play_sfx SFX_WALK

.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleSandWalkingInput
	ld a, [wWarioState]
	cp WST_SAND_WALKING
	ret nz ; done if not walking in sand any more

	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_SandFalling
	ret

SetState_SandTurning:
	ld a, WST_SAND_TURNING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
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

UpdateState_SandTurning:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_SandJumping
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_SandWalking
	jp SetState_SandIdling

SetState_LadderClimbing:
	ld a, WST_LADDER_CLIMBING
	ld [wWarioState], a
	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsGettingOffLadder], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, BANK(WarioLadderGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioLadderGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioLadderGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_155cc)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_155cc)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_155cc)
	ld [wWarioOAMPtr + 1], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFrameset_158d6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_158d6)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_LadderClimbing:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 32
	ld [wSFXLoopCounter], a
	play_sfx SFX_CLIMB
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	jr z, .no_dust
	get_pos
	ld b, PARTICLE_DUST
	farcall CreateParticle
.no_dust
	call HandleLadderInput
	ret

SetState_LadderIdling:
	ld a, WST_LADDER_IDLING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld [wIsGettingOffLadder], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, BANK(WarioLadderGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioLadderGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioLadderGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_155cc)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_155cc)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_155cc)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15900)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15900)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

.dir_right
	ld a, HIGH(WarioFrameset_158fd)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_158fd)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_LadderIdling:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wLadderInteraction]
	and a
	jr nz, .continue_ladder
	farcall StartFall
	ret
.continue_ladder
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleLadderIdlingInput
	ret

UpdateState_LadderShakeSlipping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wLadderInteraction]
	and a
	jr nz, .continue_ladder
	farcall StartFall
	ret
.continue_ladder
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld b, $02
	call MoveWarioDown
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .check_landing
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr z, .check_landing
	jr c, .check_landing
	call StartDownwardsFloorTransition
.check_landing
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr z, .still_sliding
	update_pos_y
	farcall SetState_Idling
	ret

.still_sliding
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $40
	ret c
	ld [hl], $00
	jp SetState_LadderIdling

SetState_GettingOffLadder:
	ld a, WST_GETTING_OFF_LADDER
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	inc a ; TRUE
	ld [wIsGettingOffLadder], a
	ld [wIsIntangible], a

	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ret
.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ret

UpdateState_GettingOffLadder:
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 32
	ld [wSFXLoopCounter], a
	play_sfx SFX_CLIMB
.skip_sfx

	ld a, [wDirection]
	and a
	jr nz, .move_right
	ld b, $01
	call MoveWarioLeft
	jr .check_ladder
.move_right
	ld b, $01
	call MoveWarioRight

.check_ladder
	farcall CheckTopBlockInteraction
	ld a, [wLadderInteraction]
	and a
	ret nz
	xor a
	ld [wIsGettingOffLadder], a
	ld [wIsIntangible], a
	farcall StartFall
	ret

SetState_LadderSliding:
	ld a, WST_LADDER_SLIDING
	ld [wWarioState], a
	play_sfx SFX_SLIDE
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsGettingOffLadder], a
	inc a
	ld [wJumpVelTable], a
	ld a, [wPowerUpLevel]
	cp LEAD_OVERALLS
	jr c, .no_smash
	ld a, TRUE
	ld [wIsSmashAttacking], a
.no_smash

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFrameset_15945)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15945)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_LadderSliding:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wLadderInteraction]
	and a
	jr nz, .continue_ladder
	xor a ; FALSE
	ld [wIsSmashAttacking], a
	farcall StartFall
	ret
.continue_ladder
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jp nz, SetState_LadderClimbing

	ld b, $02
	call MoveWarioDown
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .check_landing
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr z, .check_landing
	jr c, .check_landing
	call StartDownwardsFloorTransition
.check_landing
	farcall CheckAirborneCollision

	ld a, b
	and a
	ret z
	update_pos_y
	ld a, [wIsSmashAttacking]
	and a
	jr z, .idle
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr c, .ground_pound
	farcall DoWarioGroundShake
	ret
.idle
	farcall SetState_Idling
	ret
.ground_pound
	farcall DoGroundPound
	ret

SetState_GrabSlipping:
	ld a, WST_GRAB_SLIPPING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wAttackCounter], a
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

UpdateState_GrabSlipping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wGrabState]
	and a
	jr nz, .grabbing
	farcall SetState_Idling
	ret

.grabbing
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .no_jump
	farcall SetState_GrabAirborne_Jump
	ret

.no_jump
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_GRAB_SLIPPING
	ret nz ; done if not grab slipping any more
	ld a, b
	and a
	jr nz, .on_ground
	farcall SetState_GrabAirborne_Fall
	ret

.on_ground
	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_GRAB_SLIPPING
	ret nz ; done if not grab slipping any more
	ld a, b
	and a
	jr nz, .stop_slipping
	call IsOnSlipperyGround
	jr z, .stop_slipping

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $08
	jr c, .slide_fast
	cp $0f
	jr c, .slide_slow
	cp $15
	jr c, .slide_every_other_frame
	jr z, .stop_slipping
	ret

.slide_fast
	ld b, $02
	jr .move
.slide_every_other_frame
	ld a, [wGlobalCounter]
	and %1
	ret z
.slide_slow
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

.stop_slipping
	farcall SetState_GrabIdling
	ret

UpdateState_GetTreasureStart:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJumpVelTable]
	and a
	jr z, .on_ground
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z
	ld hl, hYPosHi
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
.on_ground
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp 48
	ret c
	ld a, 24
	ld [wWarioStateCounter], a
;	fallthrough

SetNextGetTreasureState:
	ld hl, wWarioState
	inc [hl]
	xor a
	ld [wWarioStateCycles], a
	farcall SetWarioWalkAnimation
	ret

UpdateState_GetTreasureWalk:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wDirection]
	and a
	jr nz, .go_right
; go left
	ld b, 1
	call MoveWarioLeft
	jr .done_moving
.go_right
	ld b, 1
	call MoveWarioRight

.done_moving
	ld hl, wWarioStateCounter
	dec [hl]
	ret nz
	ld hl, wWarioState
	inc [hl] ; WST_GET_TREASURE_TURN_FRONT_1
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioGetTreasureFrameset_1fc46a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureFrameset_1fc46a)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioGetTreasureFrameset_1fc461)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureFrameset_1fc461)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GetTreasureTurnFront:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, [wWarioState]
	cp WST_GET_TREASURE_TURN_FRONT_2
	jp z, SetState_GetTreasureLookFront
	ld a, WST_GET_TREASURE_LAUGH
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioClearGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioClearGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioClearGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(WarioGetTreasureTurnFrontFrameset_1fc2ab)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureTurnFrontFrameset_1fc2ab)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GetTreasureLaugh:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, WST_GET_TREASURE_TURN_BACK
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioGetTreasureFrameset_1fc446)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureFrameset_1fc446)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioGetTreasureFrameset_1fc439)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureFrameset_1fc439)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GetTreasureTurnBack:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, WST_GET_TREASURE_OPEN
	ld [wWarioState], a
	play_sfx SFX_GET_TREASURE_OPEN
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioClearGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioClearGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioClearGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioGetTreasureTurnBackFrameset_1fc2c4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureTurnBackFrameset_1fc2c4)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GetTreasureOpen:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, WST_GET_TREASURE_TURN_WALK
	ld [wWarioState], a
	call LoadCollectedTreasurePal_Level
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioGetTreasureOAM_1fc31b)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	xor $1
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioGetTreasureFrameset_1fc45a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureFrameset_1fc45a)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioGetTreasureFrameset_1fc453)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureFrameset_1fc453)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GetTreasureTurnWalk:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, 32
	ld [wWarioStateCounter], a
	xor a
	ld [wAutoMoveState], a
	jp SetNextGetTreasureState

SetState_GetTreasureLookFront:
	ld a, WST_GET_TREASURE_LOOK_FRONT
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioClearGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioClearGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioClearGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioGetTreasureOAM_1fc000)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(WarioGetTreasureLookFrontFrameset_1fc30d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGetTreasureLookFrontFrameset_1fc30d)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GetTreasureLookFront:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, WST_GET_TREASURE_CLEAR
	ld [wWarioState], a
	ld hl, wWarioPos
	ld de, hPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld b, PARTICLE_TREASURE_GLOW
	farcall CreateParticle
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ret

UpdateState_GetTreasureClear:
	ld hl, wWarioStateCounter
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr nz, .next
	inc [hl]
	ld a, [hl]
	cp 180
	ret c
.next
	ld a, [wCurParticleAnimEnded]
	and a
	ret z
	ld [hl], 0 ; wWarioStateCounter
	ld hl, wLevelEndScreen
	res 7, [hl]
	ret

SetState_Sleeping:
	ld a, WST_SLEEPING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_14000)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14000)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSleepingFrameset_1421c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSleepingFrameset_1421c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSleepingFrameset_14225)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSleepingFrameset_14225)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Sleeping:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioStateCounter]
	dec a
	jr z, .asleep
	dec a
	jp z, .waking_up
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	play_sfx SFX_SLEEP
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld hl, wWarioStateCounter
	inc [hl]

	ld a, [wDirection]
	and a
	jr nz, .asleep_dir_right
	ld a, HIGH(WarioSleepingFrameset_1422e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSleepingFrameset_1422e)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.asleep_dir_right
	ld a, HIGH(WarioSleepingFrameset_14237)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSleepingFrameset_14237)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

.asleep
	ld a, [wWarioAnimationEnded]
	and a
	play_sfx nz, SFX_SLEEP
	ld a, [wJoypadDown]
	and a
	ret z
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [wDirection]
	and a
	jr nz, .waking_dir_right
	ld a, HIGH(WarioSleepingFrameset_14240)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSleepingFrameset_14240)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.waking_dir_right
	ld a, HIGH(WarioSleepingFrameset_14249)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSleepingFrameset_14249)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.waking_up
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	farcall SetState_Idling
	ret

SetState_LadderScratching:
	ld a, WST_LADDER_SCRATCHING
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
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsGettingOffLadder], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioLadderScratchingFrameset_15903)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLadderScratchingFrameset_15903)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioLadderScratchingFrameset_15924)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLadderScratchingFrameset_15924)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_LadderScratching:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadDown]
	and a
	jr nz, .stop_scratching
	ld a, [wWarioAnimationEnded]
	and a
	ret z
.stop_scratching
	jp SetState_LadderIdling

SetState_FenceShakeSliding:
	ld a, WST_FENCE_SHAKE_SLIDING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld a, $03
	ld [wAutoMoveState], a

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
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFenceFrameset_14d0b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFenceFrameset_14d0b)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFenceFrameset_14d10)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFenceFrameset_14d10)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FenceShakeSliding:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioStateCounter]
	and a
	jr nz, .apply_jump_vel
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .apply_jump_vel
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
.apply_jump_vel
	ld a, [wJumpVelTable]
	and a
	jr z, .done
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z

	update_pos_y

	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

.done
	ret

SetState_FenceMovingVertical:
	ld a, WST_FENCE_MOVING_VERTICAL
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, BANK(WarioLadderGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioLadderGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioLadderGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_155cc)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_155cc)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_155cc)
	ld [wWarioOAMPtr + 1], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFrameset_158d6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_158d6)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FenceMovingVertical:;1aed0 (6:6ed0)
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $20
	ld [wSFXLoopCounter], a
	play_sfx SFX_CLIMB
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	jr z, .no_dust

	get_pos

	ld b, PARTICLE_DUST
	farcall CreateParticle
.no_dust
	call HandleFenceMovingVerticalInput
	ret

SetState_FenceIdling:
	ld a, WST_FENCE_IDLING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, BANK(WarioLadderGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioLadderGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioLadderGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_155cc)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_155cc)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_155cc)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15900)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15900)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_158fd)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_158fd)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FenceIdling:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleFenceIdlingInput
	ret

SetState_FenceMovingHorizontal:
	ld a, WST_FENCE_MOVING_HORIZONTAL
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, -27
	ld [wCollisionBoxTop], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left

	ld a, [wDirection]
	and a
	jr nz, .d_right
.d_left
	ld a, HIGH(WarioFenceMovingHorizontalFrameset_158f2)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFenceMovingHorizontalFrameset_158f2)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.d_right
	ld a, HIGH(WarioFenceMovingHorizontalFrameset_158e7)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFenceMovingHorizontalFrameset_158e7)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FenceMovingHorizontal:
	farcall UpdateEnvStateAtHead
	ld a, [wIsNearFence]
	and a
	jr nz, .near_fence
	farcall StartFall
	ret

.near_fence
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $20
	ld [wSFXLoopCounter], a
	play_sfx SFX_CLIMB
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleFenceMovingHorizontalInput
	ret

SetState_FenceSliding:
	ld a, WST_FENCE_SLIDING
	ld [wWarioState], a
	play_sfx SFX_SLIDE

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsGettingOffLadder], a
	inc a
	ld [wJumpVelTable], a

	ld a, [wPowerUpLevel]
	cp LEAD_OVERALLS
	jr c, .no_smash
	ld a, TRUE
	ld [wIsSmashAttacking], a
.no_smash
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFrameset_15945)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15945)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FenceSliding:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wIsNearFence]
	and a
	jr nz, .near_fence

	xor a ; FALSE
	ld [wIsSmashAttacking], a
	farcall StartFall
	ret

.near_fence
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .slide_down
	jp SetState_FenceMovingVertical

.slide_down
	ld b, $02
	call MoveWarioDown
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .check_landing
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr z, .check_landing
	jr c, .check_landing
	call StartDownwardsFloorTransition
.check_landing
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z

	update_pos_y

	ld a, [wIsSmashAttacking]
	and a
	jr z, .idle
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr c, .ground_pound
	farcall DoWarioGroundShake
	ret
.idle
	farcall SetState_Idling
	ret
.ground_pound
	farcall DoGroundPound
	ret

HandleFenceMovingVerticalInput:
	ld a, [wJoypadDown]
	and PAD_B | PAD_DOWN
	cp PAD_B | PAD_DOWN
	jp z, SetState_FenceSliding

	ld a, [wJumpingUpwards]
	and a
	jr nz, .check_a_pressed
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr z, .check_a_pressed
.jump
	farcall StartJump_FromInput
	ret

.check_a_pressed
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .jump

	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr nz, .d_up
	bit B_PAD_DOWN, a
	jr nz, .d_down
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_FenceMovingHorizontal
	jp SetState_FenceIdling

.d_up
	farcall UpdateEnvStateAboveHead ; unnecessary farcall
	ld a, [wIsNearFence]
	and a
	ret z
	ld b, $01
	call MoveWarioUp
	ret

.d_down
	ld b, $01
	call MoveWarioDown
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .landed
	farcall UpdateEnvStateAtHead
	ld a, [wIsNearFence]
	and a
	ret nz
	farcall StartFall
	ret

.landed
	update_pos_y
	farcall SetState_Idling
	ret

HandleFenceIdlingInput:
	ld a, [wJumpingUpwards]
	and a
	jr nz, .check_a_pressed
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr z, .check_a_pressed
.jump
	farcall StartJump_FromInput
	ret

.check_a_pressed
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .jump
	ld a, [wJoypadDown]
	and PAD_UP | PAD_DOWN
	jp nz, SetState_FenceMovingVertical
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_FenceMovingHorizontal
	ret

HandleFenceMovingHorizontalInput:
	ld a, [wJumpingUpwards]
	and a
	jr nz, .check_a_pressed
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr z, .check_a_pressed
.jump
	farcall StartJump_FromInput
	ret

.check_a_pressed
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, .jump
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	and PAD_UP | PAD_DOWN
	jp nz, SetState_FenceMovingVertical
	jp SetState_FenceIdling

.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	ld b, $01
	call MoveWarioRight
	ret

.d_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	ld b, $01
	call MoveWarioLeft
	ret

HandleSandFallingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_SandJumping
	call SinkInSand

	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	farcall WalkFromInput

	ld a, [wWalkVelIndex]
	cp $04
	jr c, .got_walk_vel
	ld a, $00
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wIsTurning]
	and a
	jr z, .done
	call SetWarioSandAirborneFrameset
.done
	ret

SinkInSand:
	farcall CheckCentreCollision
	ld a, b
	and a
	ret nz

	ld b, $01
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jr z, .got_speed
	inc b
.got_speed
	call MoveWarioDown
	ret

HandleSandIdlingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_SandJumping
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_SandWalking
	ret

HandleSandWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_SandJumping
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_SandIdling

.d_right
	; this is buggy, wDirection is already
	; switched by input handling in the Sand Idling state
	; as a result, Sand Turning state will never be reached
	ld a, [wDirection]
	and a
	jp z, SetState_SandTurning
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
	cp $04
	jr c, .done
	ld a, $00
	ld [wWalkVelIndex], a
.done
	ret

.d_left
	; this is buggy, wDirection is already
	; switched by input handling in the Sand Idling state
	; as a result, Sand Turning state will never be reached
	ld a, [wDirection]
	and a
	jp nz, SetState_SandTurning
	ld a, DIRECTION_LEFT
	ld [wDirection], a

	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .cap_walk_vel

HandleLadderInput:
	ld a, [wJoypadDown]
	and PAD_B | PAD_DOWN
	cp PAD_B | PAD_DOWN
	jp z, SetState_LadderSliding

	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr nz, .d_up
	bit B_PAD_DOWN, a
	jr nz, .d_down
	jp SetState_LadderIdling

.d_up
	farcall CheckUpCollision
	ld a, [wJumpCollision]
	and a
	ret nz
	ld b, 1
	call MoveWarioUp
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .check_ladder_up
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr nc, .check_ladder_up
	jp StartUpwardsFloorTransition

.check_ladder_up
	ld a, [wLadderInteraction]
	and a
	ret nz
	farcall UpdateEnvStateAtFeet
	ld a, [wLadderInteraction]
	and a
	ret nz
.idle
	farcall SetState_Idling
	ret

.d_down
	ld b, $01
	call MoveWarioDown
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .check_ladder_down
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr z, .check_ladder_down
	jr c, .check_ladder_down
	jp StartDownwardsFloorTransition

.check_ladder_down
	farcall UpdateEnvStateAtFeet
	ld a, [wLadderInteraction]
	and a
	jr z, .no_more_ladder_interaction
	farcall CheckCentreCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a
	ret

.no_more_ladder_interaction
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .idle
	farcall StartFall
	ret

HandleLadderIdlingInput:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jr z, .check_climb
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr nz, .get_off

.check_climb
	ld a, [wJoypadDown]
	and PAD_UP | PAD_DOWN
	jp nz, SetState_LadderClimbing
	ld hl, wWarioStateCounter
	ld a, [hl]
	add 1
	ld [hli], a
	ld a, [hl]
	adc 0
	ld [hl], a
	cp $02
	ret c
	jp SetState_LadderScratching

.get_off
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .get_off_right
	ld a, -16
	ld [wCollisionBoxLeft], a
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .blocked
.can_get_off
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	jp SetState_GettingOffLadder

.get_off_right
	ld a, 16
	ld [wCollisionBoxRight], a
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr z, .can_get_off
.blocked
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ret
