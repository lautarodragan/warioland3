UpdateWarioStates_Group4:
	ld a, [wWarioState]
	sub $b0
	jumptable

	dw UpdateState_IceSkatinStart    ; WST_ICE_SKATIN_START
	dw UpdateState_IceSkatin         ; WST_ICE_SKATIN
	dw UpdateState_IceSkatinAirborne ; WST_ICE_SKATIN_AIRBORNE
	dw UpdateState_IceSkatinCrash    ; WST_ICE_SKATIN_CRASH
	dw InvalidWarioStateReset        ; WST_UNUSED_B4
	dw InvalidWarioStateReset        ; WST_UNUSED_B5
	dw InvalidWarioStateReset        ; WST_UNUSED_B6
	dw InvalidWarioStateReset        ; WST_UNUSED_B7
	dw UpdateState_GrabbingOwl       ; WST_GRABBING_OWL
	dw UpdateState_OwlSlow           ; WST_OWL_SLOW
	dw UpdateState_OwlFast           ; WST_OWL_FAST
	dw UpdateState_ReleasingOwl      ; WST_RELEASING_OWL
	dw UpdateState_FallingFromOwl    ; WST_FALLING_FROM_OWL
	dw InvalidWarioStateReset        ; WST_UNUSED_BD
	dw InvalidWarioStateReset        ; WST_UNUSED_BE
	dw InvalidWarioStateReset        ; WST_UNUSED_BF
	dw UpdateState_HangingRail       ; WST_HANGING_RAIL
	dw InvalidWarioStateReset        ; WST_UNUSED_C1
	dw InvalidWarioStateReset        ; WST_UNUSED_C2
	dw InvalidWarioStateReset        ; WST_UNUSED_C3
	dw UpdateState_SnowmanStart      ; WST_SNOWMAN_START
	dw UpdateState_SnowmanIdle       ; WST_SNOWMAN_IDLE
	dw UpdateState_SnowmanWalking    ; WST_SNOWMAN_WALKING
	dw UpdateState_SnowmanTurning    ; WST_SNOWMAN_TURNING
	dw UpdateState_SnowmanAirborne   ; WST_SNOWMAN_AIRBORNE
	dw UpdateState_SnowmanLanding    ; WST_SNOWMAN_LANDING
	dw UpdateState_SnowmanBumped     ; WST_SNOWMAN_BUMPED
	dw UpdateState_SnowballRolling   ; WST_SNOWBALL_ROLLING
	dw UpdateState_SnowballAirborne  ; WST_SNOWBALL_AIRBORNE
	dw UpdateState_SnowballCrash     ; WST_SNOWBALL_CRASH
	dw InvalidWarioStateReset        ; WST_UNUSED_CE
	dw InvalidWarioStateReset        ; WST_UNUSED_CF
	dw UpdateState_SplitHit          ; WST_SPLIT_HIT
	dw UpdateState_SplitKnockedBack  ; WST_SPLIT_KNOCKED_BACK
	dw UpdateState_Splitting         ; WST_SPLITTING
	dw UpdateState_SplittingAirborne ; WST_SPLITTING_AIRBORNE
	dw UpdateState_FanStart          ; WST_FAN_START
	dw UpdateState_FanLifting        ; WST_FAN_LIFTING
	dw UpdateState_FanTurning        ; WST_FAN_TURNING
	dw UpdateState_FanSpinning       ; WST_FAN_SPINNING
	dw UpdateState_FanRecovering     ; WST_FAN_RECOVERING
	dw InvalidWarioStateReset        ; WST_UNUSED_D9
	dw InvalidWarioStateReset        ; WST_UNUSED_DA
	dw InvalidWarioStateReset        ; WST_UNUSED_DB
	dw UpdateState_BlindIdling       ; WST_BLIND_IDLING
	dw UpdateState_BlindWalking      ; WST_BLIND_WALKING
	dw UpdateState_BlindTurning      ; WST_BLIND_TURNING
	dw UpdateState_BlindAirborne     ; WST_BLIND_AIRBORNE
	dw UpdateState_Swallowed         ; WST_SWALLOWED
	dw UpdateState_Launched          ; WST_LAUNCHED
	dw UpdateState_LaunchCrash       ; WST_LAUCH_CRASH
	dw InvalidWarioStateReset        ; WST_UNUSED_E3
	dw UpdateState_MagicRising       ; WST_MAGIC_RISING
	dw UpdateState_MagicStopping     ; WST_MAGIC_STOPPING
	dw UpdateState_MagicRecovering   ; WST_MAGIC_RECOVERING
	dw InvalidWarioStateReset        ; WST_UNUSED_E7
	dw UpdateState_BallStart         ; WST_BALL_START
	dw UpdateState_BallBouncing      ; WST_BALL_BOUNCING
	dw UpdateState_BallAirborne      ; WST_BALL_AIRBORNE
	dw UpdateState_BallShot          ; WST_BALL_SHOT
	dw UpdateState_BallThrown        ; WST_BALL_THROWN
	dw UpdateState_BallSentUpwards   ; WST_BALL_SENT_UPWARDS
	dw UpdateState_BallTurning       ; WST_BALL_TURNING
	dw InvalidWarioStateReset        ; WST_UNUSED_EF
	dw InvalidWarioStateReset        ; WST_UNUSED_F0
	dw InvalidWarioStateReset        ; WST_UNUSED_F1
	dw InvalidWarioStateReset        ; WST_UNUSED_F2

SetState_IceSkatinStart:
	ld a, WST_ICE_SKATIN_START
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
	ld [wInvisibleFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioIceSkatinPal
	call SetWarioPal
	ld a, BANK(WarioBubbleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBubbleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBubbleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioIceSkatinStartOAM_1fdb6d)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioIceSkatinStartOAM_1fdb6d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioIceSkatinStartOAM_1fdb6d)
	ld [wWarioOAMPtr + 1], a

	ld a, [wObjDirection]
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioIceSkatinStartFrameset_1fdd8b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioIceSkatinStartFrameset_1fdd8b)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioIceSkatinStartFrameset_1fdd82)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioIceSkatinStartFrameset_1fdd82)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_IceSkatinStart:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z

	xor a
	ld [wWalkVelIndex], a
;	fallthrough

SetState_IceSkatin:
	ld a, WST_ICE_SKATIN
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioIceSkatinFrameset_1fdd97)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioIceSkatinFrameset_1fdd97)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioIceSkatinFrameset_1fdd94)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioIceSkatinFrameset_1fdd94)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_IceSkatin:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, IceSkatinCrashIntoWall

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_ZIP_LINE_SLIDE
.skip_sfx
	ld a, BANK("Wario OAM 2")
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
	cp $14
	jr c, .got_walk_vel
	ld a, $10
	ld [wWalkVelIndex], a
.got_walk_vel
	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, .fall
	update_pos_y
	ret

.fall
	ld a, WST_ICE_SKATIN_AIRBORNE
	ld [wWarioState], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ret

IceSkatinCrashIntoWall:
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld b, 3
	call MoveWarioRight
	jp SetState_IceSkatinCrash
.facing_right
	ld b, 3
	call MoveWarioLeft
	jp SetState_IceSkatinCrash

UpdateState_IceSkatinAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_IceSkatinCrash

	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, IceSkatinCrashIntoWall
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call ApplyJumpVelocity
	farcall HandleWalk
	ld a, [wWalkVelIndex]
	cp $14
	jr c, .got_walk_vel
	ld a, $10
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wWarioState]
	cp WST_ICE_SKATIN_AIRBORNE
	ret nz ; done if not ice skatin airborne any more

	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_ICE_SKATIN_AIRBORNE
	ret nz ; done if not ice skatin airborne any more
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_ICE_SKATIN_AIRBORNE
	ret nz ; done if not ice skatin airborne any more

	ld a, $10
	ld [wWalkVelIndex], a
	jp SetState_IceSkatin

SetState_IceSkatinCrash:
	play_sfx SFX_ICE_SKATIN_CRASH

	ld a, WST_ICE_SKATIN_CRASH
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioIceSkatinCrashFrameset_1fdda7)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioIceSkatinCrashFrameset_1fdda7)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioIceSkatinCrashFrameset_1fdd9a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioIceSkatinCrashFrameset_1fdd9a)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_IceSkatinCrash:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	get_pos
	ld b, PARTICLE_ICE
	farcall CreateParticle
	jp RecoverFromTransformation

UpdateState_GrabbingOwl:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	jp nz, HandleWarioOwlInput
UpdateWarioOwlDirection:
	ld a, [wDirection]
	and a
	jr nz, .right
; left
	ld a, PAD_LEFT
	ld [wSwimmingDirectionInput], a
	jr SetState_OwlWario
.right
	ld a, PAD_RIGHT
	ld [wSwimmingDirectionInput], a
;	fallthrough

SetState_OwlWario:
	ld a, WST_OWL_SLOW
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wSwimmingDirectionInput]
	and PAD_UP | PAD_DOWN
	jr nz, .up_or_down
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioOwlFrameset_1fed7c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fed7c)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioOwlFrameset_1fed91)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fed91)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.up_or_down
	ld a, HIGH(WarioOwlFrameset_1fedd0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fedd0)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_OwlSlow:
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_ReleasingOwl
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_ReleasingOwl
	ld a, [wWarioState]
	cp WST_OWL_SLOW
	ret nz
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	jp nz, HandleWarioOwlInput
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $20
	ld [wSFXLoopCounter], a
	play_sfx SFX_FLAP
.skip_sfx
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_RIGHT, a
	jr nz, .go_right
	bit B_PAD_UP, a
	jr nz, .go_up
	bit B_PAD_DOWN, a
	jr nz, .go_down

; go left
	farcall CheckBottomLeftCollision_Break
	ld a, [wWarioState]
	cp WST_OWL_SLOW
	ret nz
	ld a, b
	and a
	jr nz, .turn_right
	ld b, 1
	call MoveWarioLeft
	ret
.turn_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jp UpdateWarioOwlDirection

.go_right
	farcall CheckBottomRightCollision_Break
	ld a, [wWarioState]
	cp WST_OWL_SLOW
	ret nz
	ld a, b
	and a
	jr nz, .turn_left
	ld b, 1
	call MoveWarioRight
	ret
.turn_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jp UpdateWarioOwlDirection

.go_up
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_OWL_SLOW
	ret nz
	call OwlWarioRoomTopCollision
	ld a, b
	and a
	jr nz, .turn_down
	ld b, 1
	call MoveWarioUp
	ret

.go_down
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_OWL_SLOW
	ret nz
	ld a, b
	and a
	jr nz, .turn_up
	ld b, 1
	call MoveWarioDown
	ret

.turn_down
	ld a, PAD_DOWN
	ld [wSwimmingDirectionInput], a
	jp SetState_OwlWario

.turn_up
	ld a, PAD_UP
	ld [wSwimmingDirectionInput], a
	jp SetState_OwlWario

HandleWarioOwlInput:
	ld a, WST_OWL_FAST
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr nz, .d_up
	bit B_PAD_DOWN, a
	jr nz, .d_down
	bit B_PAD_RIGHT, a
	jr nz, .d_right
; d_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, PAD_LEFT
	jr .got_input
.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, PAD_RIGHT
	jr .got_input
.d_up
	ld a, PAD_UP
	jr .got_input
.d_down
	ld a, PAD_DOWN
.got_input
	ld [wSwimmingDirectionInput], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wSwimmingDirectionInput]
	and PAD_UP | PAD_DOWN
	jr nz, .up_or_down
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioOwlFrameset_1feda6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1feda6)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioOwlFrameset_1fedbb)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fedbb)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.up_or_down
	ld a, HIGH(WarioOwlFrameset_1fede5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fede5)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_OwlFast:
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_ReleasingOwl
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_ReleasingOwl
	ld a, [wWarioState]
	cp WST_OWL_FAST
	ret nz
	ld a, [wJoypadDown]
	and PAD_CTRL_PAD
	jp z, SetState_OwlWario
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $10
	ld [wSFXLoopCounter], a
	play_sfx SFX_FLAP
.skip_sfx
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wSwimmingDirectionInput]
	bit B_PAD_RIGHT, a
	jr nz, .going_right
	bit B_PAD_UP, a
	jr nz, .going_up
	bit B_PAD_DOWN, a
	jr nz, .going_down

; going left
	ld a, [wJoypadDown]
	and PAD_LEFT
	jp z, HandleWarioOwlInput
	farcall CheckBottomLeftCollision_Break
	ld a, [wWarioState]
	cp WST_OWL_FAST
	ret nz
	ld a, b
	and a
	ret nz
	ld b, 2
	call MoveWarioLeft
	ret

.going_right
	ld a, [wJoypadDown]
	and PAD_RIGHT
	jp z, HandleWarioOwlInput
	farcall CheckBottomRightCollision_Break
	ld a, [wWarioState]
	cp WST_OWL_FAST
	ret nz
	ld a, b
	and a
	ret nz
	ld b, 2
	call MoveWarioRight
	ret

.going_up
	ld a, [wJoypadDown]
	and PAD_UP
	jp z, HandleWarioOwlInput
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_OWL_FAST
	ret nz
	call OwlWarioRoomTopCollision
	ld a, b
	and a
	ret nz
	ld b, 2
	call MoveWarioUp
	ret

.going_down
	ld a, [wJoypadDown]
	and PAD_DOWN
	jp z, HandleWarioOwlInput
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_OWL_FAST
	ret nz
	ld a, b
	and a
	jr z, .move_down
	ld hl, hYPosHi
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret
.move_down
	ld b, 2
	call MoveWarioDown
	ret

; The room's top edge is a ceiling for Owl Wario: real owls only fly in rooms
; with ceilings of their own, but the debug menu's can be anywhere, and with
; nothing above him he'd fly out of the top of the level. It stops Wario's
; body, not the owl he holds: the owl can go above the screen (the camera
; stops at the room's top), so he still reaches anything at the very top.
; output:
; - b = 1 if he can't go any higher, unchanged otherwise
OwlWarioRoomTopCollision:
	ld a, [wRoomUpperYLimit]
	ld h, a
	ld l, 0
	ld a, [wCameraConfigFlags]
	bit CAM_BORDER_UP_F, a
	jr z, .got_top
	ld l, CAMERA_BORDER_UPPER_H
.got_top
	; his feet can go up to OWL_WARIO_BODY_HEIGHT below the top, and he
	; moves up to 2 pixels at a time
	ld de, OWL_WARIO_BODY_HEIGHT + 2
	add hl, de
	ld a, [wWarioYPos + 1]
	sub l
	ld a, [wWarioYPos + 0]
	sbc h
	ret nc
	ld b, 1
	ret

SetState_ReleasingOwl:
	ld a, WST_RELEASING_OWL
	ld [wWarioState], a
	call ReleaseOwl
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioOwlFrameset_1fedfe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fedfe)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ReleasingOwl:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, WST_FALLING_FROM_OWL
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, $02
	ld [wJumpVelTable], a
	ld a, $18
	ld [wJumpVelIndex], a
	ret

UpdateState_FallingFromOwl:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	call ApplyJumpVelocity
	farcall WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
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
	jp RecoverFromTransformation

UpdateState_HangingRail:
	ld a, [wWarioStateCounter]
	and a
	jr nz, .update_animation
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .update_animation
	ld a, $01
	ld [wWarioStateCounter], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioRailFrameset_1feeb4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioRailFrameset_1feeb4)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, RecoverFromTransformation_WithoutInvincibility
	bit B_PAD_A, a
	jp nz, LeaveRailAndJump
	ld a, [wAutoMoveState]
	and a
	jp z, LeaveRailAndFall
	ret

SetState_TurningIntoSnowman::
	play_sfx SFX_SNOWMAN_TRANSFORM

	ld a, WST_SNOWMAN_START
	ld [wWarioState], a

	ld a, $ff
	ld [wCollisionBoxBottom], a
	ld a, $e5
	ld [wCollisionBoxTop], a
	ld a, $f7
	ld [wCollisionBoxLeft], a
	ld a, $09
	ld [wCollisionBoxRight], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelIndex], a

	ld a, [wJumpVelTable]
	and a
	jr z, .got_jump_vel
	ld a, $18
	ld [wJumpVelIndex], a

.got_jump_vel
	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioSnowmanPal
	call SetWarioPal
	ld a, BANK(WarioSnowmanGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSnowmanGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSnowmanGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioTurningIntoSnowmanOAM_1feec7)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioTurningIntoSnowmanOAM_1feec7)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioTurningIntoSnowmanOAM_1feec7)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioTurningIntoSnowmanFrameset_1ff560)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioTurningIntoSnowmanFrameset_1ff560)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioTurningIntoSnowmanFrameset_1ff5a3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioTurningIntoSnowmanFrameset_1ff5a3)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanStart:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wJumpVelTable]
	and a
	jr z, .update_animation
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

SetState_SnowmanIdle:
	xor a
	ld [wWalkVelIndex], a
	ld a, WST_SNOWMAN_IDLE
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowmanIdleFrameset_1ff5f8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanIdleFrameset_1ff5f8)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSnowmanIdleFrameset_1ff5fb)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanIdleFrameset_1ff5fb)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanIdle:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	call HandleSnowmanInput
	ld a, [wWarioState]
	cp WST_SNOWMAN_IDLE
	ret nz
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_SnowmanAirborne_Fall
	ret

SetState_SnowmanWalking:
	xor a
	ld [wWalkVelIndex], a
	ld a, WST_SNOWMAN_WALKING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jr nz, .left
	bit B_PAD_RIGHT, a
	jr nz, .right
	ld a, [wDirection]
	and a
	jr nz, .right
.left
	ld a, HIGH(WarioSnowmanWalkingFrameset_1ff5e6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanWalkingFrameset_1ff5e6)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.right
	ld a, HIGH(WarioSnowmanWalkingFrameset_1ff5ef)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanWalkingFrameset_1ff5ef)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanWalking:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $1c
	ld [wSFXLoopCounter], a
	play_sfx SFX_FAT_WALK
.skip_sfx
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleSnowmanWalkingInput
	ld a, [wWarioState]
	cp WST_SNOWMAN_WALKING
	ret nz
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_SnowmanAirborne_Fall
	ld a, [wWarioSlopeInteraction]
	and a
	ret z
	ld hl, hYPosHi
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	jp TurnIntoSmallSnowball

SetState_SnowmanTurning:
	ld a, WST_SNOWMAN_TURNING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowmanTurningFrameset_1ff605)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanTurningFrameset_1ff605)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSnowmanTurningFrameset_1ff5fe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanTurningFrameset_1ff5fe)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanTurning:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, SetState_SnowmanAirborne_Jump
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_SnowmanWalking

SetState_SnowmanAirborne_Jump:
	play_sfx SFX_JUMP
	xor a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld a, $01
	ld [wJumpVelTable], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff60c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff60c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff617)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff617)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	jr SetState_SnowmanAirborne
SetState_SnowmanAirborne_Fall:
	ld a, $18
	ld [wJumpVelIndex], a
	ld a, $01
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld a, $02
	ld [wJumpVelTable], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff622)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff622)
	ld [wWarioFramesetPtr + 1], a
	jr SetState_SnowmanAirborne
.dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff625)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff625)
	ld [wWarioFramesetPtr + 1], a
;	fallthrough
SetState_SnowmanAirborne:
	ld a, WST_SNOWMAN_AIRBORNE
	ld [wWarioState], a
	xor a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioStateCounter]
	and a
	jr nz, .handle_movement
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .handle_movement
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, 1
	ld [wWarioStateCounter], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff622)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff622)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff625)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff625)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
.handle_movement
	call HandleSnowmanAirborneMovement
	ld a, [wWarioState]
	cp WST_SNOWMAN_AIRBORNE
	ret nz
	ld a, [wJumpVelIndex]
	cp $18
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_SNOWMAN_AIRBORNE
	ret nz
	jp SetState_SnowmanAirborne_Fall
.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	farcall CheckCentreCollision
	ld a, [wWarioSlopeInteraction]
	and a
	jr z, .not_on_slope
	jp TurnIntoSmallSnowball
.not_on_slope
	ld a, [wGroundShakeCounter]
	and a
	jr nz, .set_landing
	ld a, $20
	ld [wGroundShakeCounter], a
	ld a, TRUE
	ld [wIsWarioGroundShaking], a
.set_landing
	ld a, [wFloorTransitionDir]
	and a
	play_sfx z, SFX_FAT_LAND
	ld a, WST_SNOWMAN_LANDING
	ld [wWarioState], a
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .landing_dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff60c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff60c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.landing_dir_right
	ld a, HIGH(WarioSnowmanFrameset_1ff617)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanFrameset_1ff617)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanLanding:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wGroundShakeCounter]
	and a
	ret nz
	jp SetState_SnowmanIdle

SetState_SnowmanBumped:
	ld a, WST_SNOWMAN_BUMPED
	ld [wWarioState], a
	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowmanBumpedFrameset_1ff628)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanBumpedFrameset_1ff628)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSnowmanBumpedFrameset_1ff639)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowmanBumpedFrameset_1ff639)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowmanBumped:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_SnowmanIdle

TurnIntoSmallSnowball:
	ld a, 1
	ld [wTransformationProgress], a
	xor a
	ld [wWarioStateCounter], a
	ld a, BANK(WarioSnowballGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSnowballGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSnowballGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioSnowballOAM_1ff64a)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioSnowballOAM_1ff64a)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioSnowballOAM_1ff64a)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wWarioSlopeInteraction]
	and $0f
	dec a
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSnowballFrameset_1ff956)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballFrameset_1ff956)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSnowballFrameset_1ff92b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballFrameset_1ff92b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
;	fallthrough
SetState_SnowballRolling:
	ld a, WST_SNOWBALL_ROLLING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ret

UpdateState_SnowballRolling:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wTransformationProgress]
	cp 2
	jr z, .medium_snowball
	cp 3
	jr z, .no_size_change

; small snowball
	ld a, [wWarioStateCounter]
	cp $70
	jr c, .no_size_change
	ld a, 2
	ld [wTransformationProgress], a
	xor a
	ld [wFrameDuration], a
	ld a, [wDirection]
	and a
	jr nz, .to_medium_dir_right
	ld a, HIGH(WarioSnowballRollingFrameset_1ff963)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballRollingFrameset_1ff963)
	ld [wWarioFramesetPtr + 1], a
	jr .no_size_change
.to_medium_dir_right
	ld a, HIGH(WarioSnowballRollingFrameset_1ff938)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballRollingFrameset_1ff938)
	ld [wWarioFramesetPtr + 1], a
	jr .no_size_change

.medium_snowball
	ld a, [wWarioStateCounter]
	cp $e0
	jr c, .no_size_change
	ld a, 3
	ld [wTransformationProgress], a
	xor a
	ld [wFrameDuration], a
	ld a, [wAnimationFrame]
	add $02
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .to_big_dir_right
	ld a, HIGH(WarioSnowballRollingFrameset_1ff970)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballRollingFrameset_1ff970)
	ld [wWarioFramesetPtr + 1], a
	jr .no_size_change
.to_big_dir_right
	ld a, HIGH(WarioSnowballRollingFrameset_1ff945)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballRollingFrameset_1ff945)
	ld [wWarioFramesetPtr + 1], a

.no_size_change
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .no_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_ROLL
.no_sfx
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wDirection]
	and a
	jr nz, .move_right
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .increment_counter_if_not_big
.move_right
	call ApplyWalkVelocity_Right
	call MoveWarioRight

.increment_counter_if_not_big
	ld a, [wTransformationProgress]
	cp 3
	jr nc, .cap_walk_vel
	ld hl, wWarioStateCounter
	ld a, [hl]
	cp $f8
	jr nc, .cap_walk_vel
	add b
	ld [hl], a
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
	jp nz, SetState_SnowballCrash
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, .fall
	ld hl, hYPosHi
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ret

.fall
	ld a, WST_SNOWBALL_AIRBORNE
	ld [wWarioState], a
	ld a, $18
	ld [wJumpVelIndex], a
	ld a, $03
	ld [wJumpVelTable], a
	ret

UpdateState_SnowballAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	farcall CheckFrontCollision
	ld a, b
	and $0f
	jr nz, SetState_SnowballCrash
	call ApplyJumpVelocity
	farcall HandleWalk
	ld a, [wWalkVelIndex]
	cp $18
	jr c, .got_walk_vel
	ld a, $14
	ld [wWalkVelIndex], a
.got_walk_vel
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	jp SetState_SnowballRolling

SetState_SnowballCrash:
	xor a
	ld [wTransformationProgress], a
	ld a, WST_SNOWBALL_CRASH
	ld [wWarioState], a
	ld a, [wDirection]
	xor $1
	ld [wDirection], a
	and a
	jr nz, .move_right
	ld b, 2
	call MoveWarioLeft
	jr .reset_animation
.move_right
	ld b, 2
	call MoveWarioRight
.reset_animation
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioSnowballCrashFrameset_1ff981)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSnowballCrashFrameset_1ff981)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SnowballCrash:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld hl, wWarioPos
	ld de, hYPosHi
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
	ld b, PARTICLE_SNOW
	farcall CreateParticle
	jp RecoverFromTransformation

SetState_SplitHit:
	ld a, WST_SPLIT_HIT
	ld [wWarioState], a

	ld a, $ff
	ld [wCollisionBoxBottom], a
	ld a, $e5
	ld [wCollisionBoxTop], a
	ld a, $f7
	ld [wCollisionBoxLeft], a
	ld a, $09
	ld [wCollisionBoxRight], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a

	ld a, $01
	ld [wJumpVelTable], a
	ld a, $0e
	ld [wJumpVelIndex], a

	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioSplitPal
	call SetWarioPal
	ld a, BANK(WarioSnowballGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSnowballGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSnowballGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioSplitHitOAM_1ffa12)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioSplitHitOAM_1ffa12)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioSplitHitOAM_1ffa12)
	ld [wWarioOAMPtr + 1], a

	ld a, [wObjDirection]
	ld [wDirection], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSplitHitFrameset_1ffd16)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSplitHitFrameset_1ffd16)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSplitHitFrameset_1ffd10)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSplitHitFrameset_1ffd10)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SplitHit:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z

	ld a, WST_SPLIT_KNOCKED_BACK
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSplitHitFrameset_1ffd19)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSplitHitFrameset_1ffd19)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSplitHitFrameset_1ffd13)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSplitHitFrameset_1ffd13)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_SplitKnockedBack:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .play_sfx
	farcall HandleWalk
	call LimitAirWalkVelocity
	jp TriggerDownwardsFloorTransition

.play_sfx
	play_sfx SFX_SPLIT_LAND

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSplitKnockedBackFrameset_1ffccf)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSplitKnockedBackFrameset_1ffccf)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSplitKnockedBackFrameset_1ffc8e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSplitKnockedBackFrameset_1ffc8e)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
;	fallthrough

SetState_Splitting:
	call TriggerFloorTransition
	ld a, WST_SPLITTING
	ld [wWarioState], a
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ret

UpdateState_Splitting:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	jr nz, TurnAndRecoverFromTransformation

	farcall CheckCentreCollision
	ld a, b
	and a
	ret nz

	ld a, WST_SPLITTING_AIRBORNE
	ld [wWarioState], a

	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

UpdateState_SplittingAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	jr nz, TurnAndRecoverFromTransformation
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	jp nz, SetState_Splitting
	jp TriggerDownwardsFloorTransition

TurnAndRecoverFromTransformation:
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	jp RecoverFromTransformation

SetState_FanStart:
	ld a, WST_FAN_START
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
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelIndex], a
	inc a
	ld [wJumpVelTable], a
	call UpdateLevelMusic
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, BANK(WarioFanGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioFanGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioFanGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioFanStartOAM_1dc000)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioFanStartOAM_1dc000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioFanStartOAM_1dc000)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFanStartFrameset_1dc37f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanStartFrameset_1dc37f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFanStartFrameset_1dc3c3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanStartFrameset_1dc3c3)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FanStart:
	farcall CheckTopBlockInteraction
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_FAN_SPIN
.skip_sfx
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough
SetState_FanLifting:
	xor a
	ld [wWalkVelIndex], a
	ld a, WST_FAN_LIFTING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFanLiftingFrameset_1dc374)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanLiftingFrameset_1dc374)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFanLiftingFrameset_1dc3b8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanLiftingFrameset_1dc3b8)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FanLifting:
	farcall CheckTopBlockInteraction
	ld a, [wIsInAirCurrent]
	and a
	jp z, SetState_FanRecovering
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_FAN_SPIN
.skip_sfx
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call RiseInAirCurrent
	ld a, [wWarioState]
	cp WST_FAN_LIFTING
	ret nz
	call HandleFanInput
	ret

SetState_FanTurning:
	ld a, [wDirection]
	xor $1
	ld [wDirection], a
	ld a, WST_FAN_TURNING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFanTurningFrameset_1dc38e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanTurningFrameset_1dc38e)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFanTurningFrameset_1dc389)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanTurningFrameset_1dc389)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FanTurning:
	call RiseInAirCurrent
	ld a, [wWarioState]
	cp WST_FAN_TURNING
	ret nz
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_FAN_SPIN
.skip_sfx
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_FanLifting

SetState_FanSpinning:
	ld a, WST_FAN_SPINNING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFanSpinningFrameset_1dc393)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanSpinningFrameset_1dc393)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FanSpinning:
	farcall CheckTopBlockInteraction
	ld a, [wIsInAirCurrent]
	and a
	jr z, SetState_FanRecovering
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_FAN_SPIN
.skip_sfx
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleFanInput
	ret

SetState_FanRecovering:
	ld a, WST_FAN_RECOVERING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFanRecoveringFrameset_1dc384)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanRecoveringFrameset_1dc384)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFanRecoveringFrameset_1dc3c8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFanRecoveringFrameset_1dc3c8)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FanRecovering:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation_WithoutInvincibility

SetState_BlindIdling:
	ld a, WST_BLIND_IDLING
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld [wInvisibleFrame], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a ; unnecessary
	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioDefaultPal
	call SetWarioPal
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

UpdateState_BlindIdling:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleBlindIdlingInput
	ld a, [wWarioState]
	cp WST_BLIND_IDLING
	ret nz ; done if not blind idling any more

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_BlindAirborne_Fall
	ret

SetState_BlindWalking:
	xor a
	ld [wWalkVelIndex], a
	ld a, WST_BLIND_WALKING
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
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

	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jr nz, .left
	bit B_PAD_RIGHT, a
	jr nz, .right

	ld a, [wDirection]
	and a
	jr nz, .right
.left
	ld a, HIGH(WarioWalkFrameset_149b4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioWalkFrameset_149b4)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.right
	ld a, HIGH(WarioFrameset_149c5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_149c5)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BlindWalking:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_BLIND_WALKING
	ret nz ; done if not blind walking any more

	ld a, b
	and a
	jp nz, RecoverFromTransformation
	call HandleBlindWalkingInput
	ld a, [wWarioState]
	cp WST_BLIND_WALKING
	ret nz ; done if not blind walking any more

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_BlindAirborne_Fall
	update_pos_y
	ret

SetState_BlindTurning:
	ld a, WST_BLIND_TURNING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
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

UpdateState_BlindTurning:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, SetState_BlindAirborne_Jump
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_BlindWalking

SetState_BlindAirborne_Fall:
	xor a
	ld [wJumpingUpwards], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a
	jr SetState_BlindAirborne

SetState_BlindAirborne_Jump:
	play_sfx SFX_JUMP

	xor a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld a, TRUE
	ld [wJumpingUpwards], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
;	fallthrough

SetState_BlindAirborne:
	xor a ; FALSE
	ld [wWarioSlopeInteraction], a

	ld a, WST_BLIND_AIRBORNE
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsCrouching], a
	ld [wAttackCounter], a

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
	call UpdateState_BlindAirborne
	ret

UpdateState_BlindAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	farcall CheckFrontCollision
	ld a, [wWarioState]
	cp WST_BLIND_AIRBORNE
	ret nz ; done if not blind airborne any more

	ld a, b
	and a
	jp nz, RecoverFromTransformation
	call HandleBlindAirborneMovement
	ld a, [wWarioState]
	cp WST_BLIND_AIRBORNE
	ret nz ; done if not blind airborne any more

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_BLIND_AIRBORNE
	ret nz ; done if not blind airborne any more
	jp SetState_BlindAirborne_Fall

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	jp SetState_BlindIdling

SetState_Swallowed:
	ld a, WST_SWALLOWED
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	inc a ; TRUE
	ld [wIsIntangible], a
	ld [wAutoMoveState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wIsTurning], a

	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, BANK(WarioLaunchGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioLaunchGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioLaunchGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioSwallowedOAM_1dc3cd)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioSwallowedOAM_1dc3cd)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioSwallowedOAM_1dc3cd)
	ld [wWarioOAMPtr + 1], a

	ld a, [wObjDirection]
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwallowedFrameset_1dc40f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwallowedFrameset_1dc40f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioSwallowedFrameset_1dc42c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwallowedFrameset_1dc42c)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Swallowed:
	ld a, [wIsTurning]
	and a
	jr z, .spit_out
	xor a
	ld [wIsTurning], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	xor $1
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioSwallowedFrameset_1dc40f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwallowedFrameset_1dc40f)
	ld [wWarioFramesetPtr + 1], a
	jr .spit_out
.dir_right
	ld a, HIGH(WarioSwallowedFrameset_1dc42c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioSwallowedFrameset_1dc42c)
	ld [wWarioFramesetPtr + 1], a

.spit_out
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wAutoMoveState]
	and a
	ret nz
	ld a, DIRECTION_LEFT
	ld [wDirection], a
;	fallthrough

SetState_Launched:
	xor a
	ld [wIsIntangible], a

	ld a, TRANSFORMATION_LAUNCHED
	ld [wTransformation], a

	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld a, TOUCH_VANISH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	ld a, WST_LAUNCHED
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

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

	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, BANK(WarioLaunchGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioLaunchGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioLaunchGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioLaunchedOAM_1dc449)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioLaunchedOAM_1dc449)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioLaunchedOAM_1dc449)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioLaunchedFrameset_1dc904)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLaunchedFrameset_1dc904)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioLaunchedFrameset_1dc8fb)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLaunchedFrameset_1dc8fb)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Launched:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $86
	ld [wSFXLoopCounter], a
	play_sfx SFX_LAUNCHED
.skip_sfx
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .crash
	ld a, [wDirection]
	and a
	jr nz, .move_right
	ld b, 2
	call MoveWarioLeft
	ret
.move_right
	ld b, 2
	call MoveWarioRight
	ret

.crash
	play_sfx SFX_LAUNCH_CRASH
	ld a, WST_LAUCH_CRASH
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .crash_dir_right
	ld a, HIGH(WarioLaunchedFrameset_1dc926)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLaunchedFrameset_1dc926)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.crash_dir_right
	ld a, HIGH(WarioLaunchedFrameset_1dc90d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioLaunchedFrameset_1dc90d)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_LaunchCrash:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	farcall RecoverFromTransformation_Underwater
	ret

SetState_MagicRising:
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
	ld b, PARTICLE_MAGIC_1
	farcall CreateParticle

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
	ld b, PARTICLE_MAGIC_2
	farcall CreateParticle

	ld a, WST_MAGIC_RISING
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
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wJumpVelIndex], a

	inc a
	ld [wJumpVelTable], a

	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioMagicPal
	call SetWarioPal
	ld a, BANK(WarioMagicGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioMagicGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioMagicGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioMagicRisingOAM_1dcd60)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioMagicRisingOAM_1dcd60)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioMagicRisingOAM_1dcd60)
	ld [wWarioOAMPtr + 1], a

	ld a, HIGH(WarioMagicRisingFrameset_1dcfb0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioMagicRisingFrameset_1dcfb0)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_MagicRising:
	farcall CheckTopBlockInteraction
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .hit_ceiling

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0c
	ld [wSFXLoopCounter], a
	play_sfx SFX_FAN_SPIN
.skip_sfx

	ld a, $77
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld b, 1
	call MoveWarioUp
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .done
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr nc, .done
	call StartUpwardsFloorTransition
.done
	ret

.hit_ceiling
	get_pos
	ld b, PARTICLE_MAGIC_STOP
	farcall CreateParticle

	ld a, WST_MAGIC_STOPPING
	ld [wWarioState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, $77
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_MagicStopping:
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $20
	ret c
UpdateState_MagicRecovering:
	jp RecoverFromTransformation

SetState_BallStart:
	call UpdateLevelMusic

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -20
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a

	ld hl, WarioBallPal
	call SetWarioPal
	ld a, BANK(WarioBallGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBallGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBallGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioBallStartOAM_1dcff1)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioBallStartOAM_1dcff1)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioBallStartOAM_1dcff1)
	ld [wWarioOAMPtr + 1], a

	ld a, [wJumpVelTable]
	and a
	jr z, LandFromBallStart

	ld a, WST_BALL_START
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, $18
	ld [wJumpVelIndex], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioBallStartFrameset_1dd313)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallStartFrameset_1dd313)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallStart:
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z

	ld hl, hPos
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
;	fallthrough

LandFromBallStart:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jp nz, SetState_BallTurning
	ld a, HIGH(WarioFrameset_1dd316)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1dd316)
	ld [wWarioFramesetPtr + 1], a
	jr SetState_BallBouncing
.dir_right
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jp nz, SetState_BallTurning
	ld a, HIGH(WarioFrameset_1dd323)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1dd323)
	ld [wWarioFramesetPtr + 1], a
	jr SetState_BallBouncing

LandFromBallAirborne:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jp nz, SetState_BallTurning
	ld a, HIGH(WarioFrameset_1dd230)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1dd230)
	ld [wWarioFramesetPtr + 1], a
	jr SetState_BallBouncing
.dir_right
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jp nz, SetState_BallTurning
	ld a, HIGH(WarioFrameset_1dd295)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1dd295)
	ld [wWarioFramesetPtr + 1], a
;	fallthrough

SetState_BallBouncing:
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	ld a, WST_BALL_BOUNCING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallBouncing:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

SetState_BallAirborne:
	play_sfx SFX_BALL_BOUNCE
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a

	ld a, WST_BALL_AIRBORNE
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBallAirborneFrameset_1dd2f3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallAirborneFrameset_1dd2f3)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBallAirborneFrameset_1dd2f6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallAirborneFrameset_1dd2f6)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallAirborne:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleBallAirborneMovement
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	ret c
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z
	update_pos_y
	jp LandFromBallAirborne

SetState_BallShot:
	ld a, WST_BALL_SHOT
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	inc a ; TRUE
	ld [wAutoMoveState], a
	ld [wIsIntangible], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioBallFrameset_1dd26c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallFrameset_1dd26c)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallShot:
	ld a, [wAutoMoveState]
	and a
	jr z, .throw
	bit 7, a
	jr z, .update_animation
	and $7f
	ld [wAutoMoveState], a
	dec a
	jr z, .phase_3
	dec a
	jr z, .phase_1
	dec a
	jr z, .phase_2
	ret

.phase_1
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBallShotFrameset_1dd2d1)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallShotFrameset_1dd2d1)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.phase_2
	ld hl, WarioBallShotPal
	call SetWarioPal

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBallShotFrameset_1dd27a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallShotFrameset_1dd27a)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.phase_3
	ld hl, WarioBallPal
	call SetWarioPal

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBallFrameset_1dd26c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallFrameset_1dd26c)
	ld [wWarioFramesetPtr + 1], a

.update_animation
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	; is in phase 1?
	ld a, [wAutoMoveState]
	cp $02
	ret nz
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	; goto phase 2
	ld a, $03 | (1 << 7)
	ld [wAutoMoveState], a
	ret

.throw
	ld a, DIRECTION_LEFT
	ld [wDirection], a

	ld a, WST_BALL_THROWN
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, $6
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBallFrameset_1dd2ee)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallFrameset_1dd2ee)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallThrown:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call ApplyJumpVelocity
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
; rising
	ld b, 3
	call MoveWarioLeft
	ret

.falling
	ld b, 2
	call MoveWarioLeft
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z
	update_pos_y

	xor a
	ld [wIsIntangible], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a

	push_wram BANK(wShootGoals)
	ld a, [wShootGoals]
	cp 3
	jr z, .three_goals
	pop_wram
	farcall EndTransformationAndSting
	ret

.three_goals
	pop_wram

	ld a, WST_BALL_SENT_UPWARDS
	ld [wWarioState], a
	play_sfx SFX_BALL_BOUNCE

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	inc a ; TRUE
	ld [wIsIntangible], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioBallFrameset_1dd2ee)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallFrameset_1dd2ee)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallSentUpwards:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
; rising
	ld b, 3
	call MoveWarioUp
	farcall CheckUpCollision
	ld a, b
	and a
	jp z, HandleUpwardsFloorTransition
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ret

.falling
	call ApplyJumpVelocity
	farcall CheckAirborneCollision
	ld a, b
	and a
	ret z
	update_pos_y
	xor a
	ld [wIsIntangible], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	farcall EndTransformationAndSting
	ret

SetState_BallTurning:
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	ld a, WST_BALL_TURNING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBallTurningFrameset_1dd28e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallTurningFrameset_1dd28e)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBallTurningFrameset_1dd287)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallTurningFrameset_1dd287)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallTurning:
	ld a, BANK("Wario OAM 3")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_BallAirborne

LeaveRailAndJump:
	call ClearTransformationValues
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	farcall StartJump_FromInput
	ret

LeaveRailAndFall:
	call ClearTransformationValues
	call UpdateLevelMusic
	ld hl, WarioDefaultPal
	call SetWarioPal
	farcall SetState_RollingAirborne_Fall
	ret

HandleSnowmanInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_SnowmanAirborne_Jump
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_SnowmanWalking
	ret

HandleSnowmanWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_SnowmanAirborne_Jump
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_SnowmanIdle
.d_right
	ld a, [wDirection]
	and a
	jr z, .turn_right
	farcall WalkIfPossible_Right
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel_right
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel_right
	ret
.turn_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jp SetState_SnowmanTurning
.d_left
	ld a, [wDirection]
	cp DIRECTION_LEFT
	jr nz, .turn_left
	farcall WalkIfPossible_Left
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel_left
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel_left
	ret
.turn_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jp SetState_SnowmanTurning

HandleSnowmanAirborneMovement:
	call ApplyJumpVelocity
	farcall WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wJumpVelIndex]
	cp $18
	ret nz
	ld a, TRUE
	ld [wIsSmashAttacking], a
	ret

RiseInAirCurrent:
	farcall UpdateEnvStateAtChest
	ld a, [wIsInAirCurrent]
	and a
	jp z, SetState_FanSpinning
	ld b, 1
	call MoveWarioUp
	ret

HandleFanInput:
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jp nz, SetState_FanTurning
	bit B_PAD_LEFT, a
	ret z
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	ret nz
	ld b, 1
	call MoveWarioLeft
	ret
.facing_right
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jp nz, SetState_FanTurning
	bit B_PAD_RIGHT, a
	ret z
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	ret nz
	ld b, 1
	call MoveWarioRight
	ret

HandleBlindIdlingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_BlindAirborne_Jump
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_BlindWalking
	ret

HandleBlindWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_BlindAirborne_Jump
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_BlindIdling

.d_right
	ld a, [wDirection]
	and a
	jr z, .turn_right
	farcall WalkIfPossible_Right
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .got_walk_vel_right
	ld a, $0c
	ld [wWalkVelIndex], a
.got_walk_vel_right
	ret

.turn_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jp SetState_BlindTurning

.d_left
	ld a, [wDirection]
	cp DIRECTION_LEFT
	jr nz, .turn_left
	farcall WalkIfPossible_Left
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .got_walk_vel_left
	ld a, $0c
	ld [wWalkVelIndex], a
.got_walk_vel_left
	ret

.turn_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jp SetState_BlindTurning

HandleBlindAirborneMovement:
	call ApplyJumpVelocity
	farcall WalkFromInput
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .done
	ld a, $0c
	ld [wWalkVelIndex], a
.done
	ret

HandleBallAirborneMovement:
	call ApplyJumpVelocity
	farcall HandleWalk
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .done
	ld a, $04
	ld [wWalkVelIndex], a
.done
	ret
