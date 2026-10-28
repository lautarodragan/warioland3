UpdateWarioStates_Group3:
	ld a, [wWarioState]
	sub $60
	jumptable

	dw UpdateState_OnFire                     ; WST_ON_FIRE
	dw UpdateState_OnFireAirborne             ; WST_ON_FIRE_AIRBORNE
	dw UpdateState_Hot                        ; WST_HOT
	dw UpdateState_HotAirborne                ; WST_HOT_AIRBORNE
	dw UpdateState_Burnt                      ; WST_BURNT
	dw UpdateState_GettingFlatAirborne        ; WST_GETTING_FLAT_AIRBORNE
	dw UpdateState_GettingFlat                ; WST_GETTING_FLAT
	dw UpdateState_FlatIdling                 ; WST_FLAT_IDLING
	dw UpdateState_FlatWalking                ; WST_FLAT_WALKING
	dw UpdateState_FlatJumping                ; WST_FLAT_JUMPING
	dw UpdateState_FlatFalling                ; WST_FLAT_FALLING
	dw UpdateState_FlatStretching             ; WST_FLAT_STRETCHING
	dw UpdateState_FlatSinking                ; WST_FLAT_SINKING
	dw UpdateState_FlatStretchingUnderwater   ; WST_FLAT_STRETCHING_UNDERWATER
	dw UpdateState_FlatSquished               ; WST_FLAT_SQUISHED
	dw UpdateState_FlatSquishedLifting        ; WST_FLAT_SQUISHED_LIFTING
	dw UpdateState_GettingWrappedInString     ; WST_GETTING_WRAPPED_IN_STRING
	dw UpdateState_BallOString                ; WST_BALL_O_STRING
	dw UpdateState_BallOStringAirborne        ; WST_BALL_O_STRING_AIRBORNE
	dw UpdateState_BallOStringKnockBack       ; WST_BALL_O_STRING_KNOCK_BACK
	dw UpdateState_GettingUnwrappedInString   ; WST_GETTING_UNWRAPPED_IN_STRING
	dw UpdateState_BallOStringDizzy           ; WST_BALL_O_STRING_DIZZY
	dw UpdateState_FatBumping                 ; WST_FAT_BUMPING
	dw UpdateState_FatEating                  ; WST_FAT_EATING
	dw UpdateState_FatIdling                  ; WST_FAT_IDLING
	dw UpdateState_FatWalking                 ; WST_FAT_WALKING
	dw UpdateState_FatTurning                 ; WST_FAT_TURNING
	dw UpdateState_FatAirborne                ; WST_FAT_AIRBORNE
	dw UpdateState_FatLanding                 ; WST_FAT_LANDING
	dw UpdateState_FatSinking                 ; WST_FAT_SINKING
	dw UpdateState_FatRecovering              ; WST_FAT_RECOVERING
	dw UpdateState_ElectricStart              ; WST_ELECTRIC_START
	dw UpdateState_Electric                   ; WST_ELECTRIC
	dw UpdateState_ElectricDizzy              ; WST_ELECTRIC_DIZZY
	dw UpdateState_TurningInvisible           ; WST_TURNING_INVISIBLE
	dw UpdateState_PuffyInflating             ; WST_PUFFY_INFLATING
	dw UpdateState_PuffyRising                ; WST_PUFFY_RISING
	dw UpdateState_PuffyTurning               ; WST_PUFFY_TURNING
	dw UpdateState_PuffyDeflating             ; WST_PUFFY_DEFLATING
	dw UpdateState_ZombieIdling               ; WST_ZOMBIE_IDLING
	dw UpdateState_ZombieWalking              ; WST_ZOMBIE_WALKING
	dw UpdateState_ZombieTurning              ; WST_ZOMBIE_TURNING
	dw UpdateState_ZombieAirborne             ; WST_ZOMBIE_AIRBORNE
	dw UpdateState_ZombieLanding              ; WST_ZOMBIE_LANDING
	dw UpdateState_ZombieSlippingThroughFloor ; WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	dw UpdateState_ZombieRecovering           ; WST_ZOMBIE_RECOVERING
	dw UpdateState_ZombieKnockBack            ; WST_ZOMBIE_KNOCK_BACK
	dw UpdateState_ZombieWrithing             ; WST_ZOMBIE_WRITHING
	dw UpdateState_BouncyStart                ; WST_BOUNCY_START
	dw UpdateState_BouncyFloor                ; WST_BOUNCY_FLOOR
	dw UpdateState_BouncyAirborne             ; WST_BOUNCY_AIRBORNE
	dw UpdateState_BouncyCeiling              ; WST_BOUNCY_CEILING
	dw UpdateState_BouncyUpsideDown           ; WST_BOUNCY_UPSIDE_DOWN
	dw UpdateState_BouncyUpsideLanding        ; WST_BOUNCY_UPSIDE_DOWN_LANDING
	dw UpdateState_BouncyLastBounce           ; WST_BOUNCY_LAST_BOUNCE
	dw UpdateState_CrazySpinning              ; WST_CRAZY_SPINNING
	dw UpdateState_CrazyDizzy                 ; WST_CRAZY_DIZZY
	dw UpdateState_Crazy                      ; WST_CRAZY
	dw UpdateState_CrazyTurning               ; WST_CRAZY_TURNING
	dw UpdateState_CrazyAirborne              ; WST_CRAZY_AIRBORNE
	dw UpdateState_VampireIdling              ; WST_VAMPIRE_IDLING
	dw UpdateState_VampireWalking             ; WST_VAMPIRE_WALKING
	dw UpdateState_VampireTurning             ; WST_VAMPIRE_TURNING
	dw UpdateState_VampireAirborne            ; WST_VAMPIRE_AIRBORNE
	dw UpdateState_BatTransforming            ; WST_BAT_TRANSFORMING
	dw UpdateState_BatIdling                  ; WST_BAT_IDLING
	dw UpdateState_VampireTransforming        ; WST_VAMPIRE_TRANSFORMING
	dw UpdateState_BatFlying                  ; WST_BAT_FLYING
	dw UpdateState_BatFalling                 ; WST_BAT_FALLING
	dw UpdateState_InBubble                   ; WST_IN_BUBBLE
	dw InvalidWarioStateReset                 ; WST_UNUSED_A6
	dw InvalidWarioStateReset                 ; WST_UNUSED_A7
	dw InvalidWarioStateReset                 ; WST_UNUSED_A8
	dw InvalidWarioStateReset                 ; WST_UNUSED_A9
	dw InvalidWarioStateReset                 ; WST_UNUSED_AA
	dw InvalidWarioStateReset                 ; WST_UNUSED_AB
	dw InvalidWarioStateReset                 ; WST_UNUSED_AC
	dw InvalidWarioStateReset                 ; WST_UNUSED_AD
	dw InvalidWarioStateReset                 ; WST_UNUSED_AE
	dw InvalidWarioStateReset                 ; WST_UNUSED_AF

UpdateState_OnFire:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 14
	ld [wSFXLoopCounter], a
	play_sfx SFX_FIRE
.skip_sfx

	ld a, [wWarioStateCounter]
	and a
	jr nz, .update_animation
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .update_animation
	ld a, $01
	ld [wWarioStateCounter], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	cp HIGH(HOT_WARIO_TRANSITION_DURATION)
	jr nz, .continue
	ld a, [hl]
	cp LOW(HOT_WARIO_TRANSITION_DURATION)
	jr nz, .continue
	jr SetState_Hot
.continue
	call HandleOnFireInput

	ld a, [wWarioState]
	cp WST_ON_FIRE
	ret nz ; done if not on fire anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_OnFireAirborne_Fall
	update_pos_y
	ret

SetState_Hot_ResetDuration:
	ld a, HIGH(HOT_WARIO_TRANSITION_DURATION)
	ld [wTransformationDuration + 0], a
	ld a, LOW(HOT_WARIO_TRANSITION_DURATION)
	ld [wTransformationDuration + 1], a
;	fallthrough

SetState_Hot:
	ld a, 2
	ld [wTransformationProgress], a
	ld a, WST_HOT
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, TOUCH_VANISH
	ld [wStingTouchState], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr z, .got_direction
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jr .got_direction
.d_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a

.got_direction
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioHotFrameset_16b26)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16b26)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioHotFrameset_16b2f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16b2f)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_OnFireAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation_InWater
	ld a, [wWarioStateCounter]
	and a
	jr nz, .update_animation
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .update_animation
	ld a, $01
	ld [wWarioStateCounter], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleOnFireAirborneMovement
	ld a, [wWarioState]
	cp WST_ON_FIRE_AIRBORNE
	ret nz ; done if not on fire and airborne

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_ON_FIRE_AIRBORNE
	ret nz ; done if not on fire and airborne

	jp SetState_OnFireAirborne_Fall
.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_ON_FIRE_AIRBORNE
	ret nz ; done if not on fire and airborne

	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_ON_FIRE_AIRBORNE
	ret nz ; done if not on fire and airborne

	farcall SetState_OnFire
	ret

UpdateState_Hot:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 16
	ld [wSFXLoopCounter], a
	play_sfx SFX_RUMBLE
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	cp 0
	jr nz, .ok
	ld a, [hl]
	cp 224
	jr z, .pal_1
	cp 164
	jr z, .pal_2
	cp 60
	jr z, .pal_3
	cp 1
	jr nz, .ok
	jr .burnt

.pal_1
	ld hl, WarioHot1Pal
	call SetWarioPal
	jr .ok
.pal_2
	ld hl, WarioHot2Pal
	call SetWarioPal
	jr .ok
.pal_3
	ld hl, WarioHot3Pal
	call SetWarioPal
.ok
	call HandleHotWarioInput

	ld a, [wWarioState]
	cp WST_HOT
	ret nz ; done if not in hot state anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_HotAirborne_FallAligned
	update_pos_y
	ret

.burnt
	play_sfx SFX_BURNT

	ld a, WST_BURNT
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld hl, WarioOnFirePal
	call SetWarioPal
	ld a, BANK(WarioBurntGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBurntGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBurntGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioHotOAM_16b6c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioHotOAM_16b6c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioHotOAM_16b6c)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioHotFrameset_16e47)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16e47)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioHotFrameset_16e72)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16e72)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_HotAirborne_FallAligned:
	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a
;	fallthrough

SetState_HotAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ld a, WST_HOT_AIRBORNE
	ld [wWarioState], a
	ld a, $08
	ld [wWarioStateCounter], a
	ret

UpdateState_HotAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation_InWater
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleHotAirborneMovement
	ld a, [wWarioState]
	cp WST_HOT_AIRBORNE
	ret nz ; done if not hot airborne anymore

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling

; rising
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_HOT_AIRBORNE
	ret nz ; done if not hot airborne anymore
	jp SetState_HotAirborne_Fall

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_HOT_AIRBORNE
	ret nz ; done if not hot airborne anymore

	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_HOT_AIRBORNE
	ret nz ; done if not hot airborne anymore

	jp SetState_Hot

UpdateState_Burnt:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation

SetState_FlatAirborne:
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	call z, ReleaseOwl

	push_wram BANK("Level Objects WRAM")
	ld a, [wObjPtr + 0]
	ld h, a
	ld a, [wObjPtr + 1]
	ld l, a
	ld de, OBJ_X_POS
	add hl, de
	ld b, $0
	ld a, [wObjInteractionType]
	and INTERACTION_MASK
	sub OBJ_INTERACTION_RICHTERTOFFEN
	jr z, .richtertoffen
	ld a, $01
	ld [wWarioStateCounter], a
	ld b, $8
	jr .got_x_offset
.richtertoffen
	ld [wWarioStateCounter], a
.got_x_offset
	ld a, [hli] ; OBJ_X_POS
	sub b
	ld [wWarioXPos + 1], a
	ld a, [hl]
	sbc $00
	ld [wWarioXPos + 0], a
	pop_wram

	ld a, TRANSFORMATION_FLAT_WARIO
	ld [wTransformation], a
	play_sfx SFX_FLATTEN
	call UpdateLevelMusic

	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a

	inc a
	ld [wAutoMoveState], a

	ld [wJumpVelTable], a
	ld a, WST_GETTING_FLAT_AIRBORNE
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -8
	ld [wCollisionBoxTop], a
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a
	ld a, BANK(WarioSlideGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioSlideGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioSlideGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioFlatOAM_16e9d)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioFlatOAM_16e9d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioFlatOAM_16e9d)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(WarioFlatAirborneFrameset_171bd)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatAirborneFrameset_171bd)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GettingFlatAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_FlatSinking
	ld b, $02
	call MoveWarioDown
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition

	ld a, WST_GETTING_FLAT
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wAutoMoveState], a
	inc a ; TRUE
	ld [wIsIntangible], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -8
	ld [wCollisionBoxTop], a
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a

	ld a, HIGH(WarioGettingFlatAirborneFrameset_1715f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGettingFlatAirborneFrameset_1715f)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GettingFlat:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
	xor a
	ld [wIsIntangible], a
	ld a, [wWarioStateCounter]
	and a
	jp nz, SetState_FlatSquished
;	fallthrough

SetState_FlatIdling:
	ld a, WST_FLAT_IDLING
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -8
	ld [wCollisionBoxTop], a
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a

	ld a, HIGH(WarioFlatIdlingFrameset_1718b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatIdlingFrameset_1718b)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FlatIdling:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleFlatIdlingInput
	farcall CheckCentreCollision
	ld a, b
	and a
	ret nz
	jp SetState_FlatFalling

SetState_FlatWalking:
	ld a, WST_FLAT_WALKING
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	ld a, HIGH(WarioFlatWalkingFrameset_17175)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatWalkingFrameset_17175)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

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

UpdateState_FlatWalking:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 10
	ld [wSFXLoopCounter], a
	play_sfx SFX_FLAT_WALK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleFlatWalkingInput
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_FlatFalling

	update_pos_y
	ret

SetState_FlatJumping:
	play_sfx SFX_FLAT_JUMP

	ld a, WST_FLAT_JUMPING
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr nz, .d_up
	ld a, JUMP_VEL_KNOCK_BACK
	jr .got_jump_vel_table
.d_up
	ld a, JUMP_VEL_NORMAL
.got_jump_vel_table
	ld [wJumpVelTable], a

	ld a, HIGH(WarioFlatFrameset_17190)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_17190)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wIsOnSteppableObject]
	and a
	ret z
;	fallthrough

UpdateState_FlatJumping:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	call ApplyJumpVelocity
	call WalkFromInput
	call LimitAirWalkVelocity
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, SetState_FlatFalling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
;	fallthrough

SetState_FlatFalling:
	ld a, WST_FLAT_FALLING
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wWarioSlopeInteraction], a
	inc a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right

	ld a, HIGH(WarioFlatFrameset_171b8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_171b8)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioFlatFrameset_17186)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_17186)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_FlatFalling:
	farcall CheckTopBlockInteraction

	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_FlatSinking

	ld a, [wWarioAnimationEnded]
	and a
	jr nz, .move_x
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	jr z, .move_x

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioFlatFrameset_17190)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_17190)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, $01
	ld [wWarioAnimationEnded], a
.move_x
	ld hl, wWalkVelIndex
	ld e, [hl]
	ld d, $00
	inc [hl]

	push de
	ld a, [wDirection]
	and a
	jp nz, .move_right
	ld hl, WarioFlatData_2b68c
	add hl, de
	ld b, [hl]
	call MoveWarioLeft

.moved_x
	ld a, [wWalkVelIndex]
	cp $28
	jr nc, .glide_done
	farcall CheckFrontCollision
	ld a, b
	and a
	jp z, .move_down
	play_sfx SFX_BUMP

	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a

	ld a, [wDirection]
	and a
	jr nz, .bounce_right
	ld b, $03
	call MoveWarioLeft
	jr .bounced
.bounce_right
	ld b, $03
	call MoveWarioRight
.bounced
	ld a, $00
	jr .set_glide_index
.glide_done
	ld a, [wDirection]
	and a
	jr nz, .glide_done_facing_right

	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jr nz, .restart_glide
	jr .turn_around
.glide_done_facing_right
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .restart_glide

.turn_around
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioAnimationEnded], a

	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	and a
	jr nz, .turn_dir_right
	ld a, HIGH(WarioFlatFrameset_171b8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_171b8)
	ld [wWarioFramesetPtr + 1], a
	jr .turn_got_frameset
.turn_dir_right
	ld a, HIGH(WarioFlatFrameset_17186)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_17186)
	ld [wWarioFramesetPtr + 1], a
.turn_got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

.restart_glide
	xor a
.set_glide_index
	ld [wWalkVelIndex], a
	pop de
	ret

.move_right
	ld hl, WarioFlatData_2b68c
	add hl, de
	ld b, [hl]
	call MoveWarioRight
	jp .moved_x

.move_down
	pop de
	ld hl, WarioFlatData_2b664
	add hl, de
	ld b, [hl]
	call MoveWarioDown
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	play_sfx SFX_FLAT_FALL
	call TriggerFloorTransition
	jp SetState_FlatIdling

UpdateState_FlatStretching:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
	xor a
	ld [wAutoMoveState], a
	jp RecoverFromTransformation

SetState_FlatSinking:
	ld a, WST_FLAT_SINKING
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	inc a ; TRUE
	ld [wIsIntangible], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -8
	ld [wCollisionBoxTop], a
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioFlatSinkingFrameset_1719a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatSinkingFrameset_1719a)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FlatSinking:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckTopBlockInteraction

	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wGlobalCounter]
	and %1111
	call z, .CreateBubbles

	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld b, $01
	call MoveWarioDown
	farcall CheckCentreCollision
	ld a, b
	and a
	ret z
	jr SetState_FlatStretchingUnderwater

.CreateBubbles:
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub $04
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $08
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	ld b, PARTICLE_BUBBLES
	farcall CreateParticle
	ret

SetState_FlatStretchingUnderwater:
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub $04
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $08
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	ld b, PARTICLE_BUBBLES
	farcall CreateParticle

	ld a, WST_FLAT_STRETCHING_UNDERWATER
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -8
	ld [wCollisionBoxTop], a
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioFlatFrameset_171a3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_171a3)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FlatStretchingUnderwater:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation_Underwater

SetState_FlatSquished:
	ld a, WST_FLAT_SQUISHED
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ret

UpdateState_FlatSquished:
	ret

SetState_FlatSquishedLifting:
	ld a, TRUE
	ld [wIsIntangible], a
	ld a, WST_FLAT_SQUISHED_LIFTING
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioFlatSquishedLiftingFrameset_1716c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatSquishedLiftingFrameset_1716c)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FlatSquishedLifting:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld b, $01
	call MoveWarioUp
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $32
	ret c
	xor a
	ld [wIsIntangible], a
	jp SetState_FlatFalling

UpdateState_GettingWrappedInString:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	farcall CheckCentreCollision

	ld a, b
	and a
	jp z, SetState_BallOStringAirborne_Fall
;	fallthrough

SetState_BallOString:
	ld a, WST_BALL_O_STRING
	ld [wWarioState], a
	ld a, 1
	ld [wTransformationProgress], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wWalkVelIndex], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -24
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
	ld a, HIGH(WarioBallOStringFrameset_1741f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringFrameset_1741f)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioBallOStringFrameset_173fe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringFrameset_173fe)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_BallOString:
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
	jr nz, BallOStringBounceOffWall
	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_BallOStringAirborne_Fall

	update_pos_y
	ld a, [wWarioSlopeInteraction]
	and a
	ret z
	and $0f
	dec a
	ld b, a
	ld a, [wDirection]
	xor b
	jr nz, BallOStringBounceOffWall
	ret

BallOStringBounceOffWall:
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $05
	jr nc, .knock_back
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBallOStringFrameset_1741f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringFrameset_1741f)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioBallOStringFrameset_173fe)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringFrameset_173fe)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.knock_back
	jp SetState_BallOStringKnockBack

SetState_BallOStringAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a
	ld a, WST_BALL_O_STRING_AIRBORNE
	ld [wWarioState], a
	ret

UpdateState_BallOStringAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckFrontCollision
	ld a, b
	and $0f
	jp nz, BallOStringBounceOffWall
	call ApplyJumpVelocity
	call HandleWalk
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
	jp SetState_BallOString

SetState_BallOStringKnockBack:
	xor a
	ld [wTransformationProgress], a
	play_sfx SFX_BUMP
	ld a, WST_BALL_O_STRING_KNOCK_BACK
	ld [wWarioState], a
	ld a, $0a
	ld [wJumpVelIndex], a
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
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBallOStringKnockBackFrameset_1742a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringKnockBackFrameset_1742a)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallOStringKnockBack:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call MoveWarioForwardBy2
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	ret

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition

.landed
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	call TriggerFloorTransition
	play_sfx SFX_BALL_O_STRING_BOUNCE

	ld a, WST_GETTING_UNWRAPPED_IN_STRING
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
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBallOStringKnockBackFrameset_17409)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringKnockBackFrameset_17409)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_GettingUnwrappedInString:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z

	play_sfx SFX_STRING_UNWRAP
	ld a, WST_BALL_O_STRING_DIZZY
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
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	inc a ; TRUE
	ld [wIsIntangible], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioDizzyGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioDizzyGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioDizzyGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioCrazyOAM_17bbc)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioCrazyOAM_17bbc)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioCrazyOAM_17bbc)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(WarioCrazyFrameset_17ce2)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyFrameset_17ce2)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BallOStringDizzy:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation

SetState_FatBumping:
	ld a, WST_FAT_BUMPING
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
	ld a, HIGH(WarioFatBumpingFrameset_178fc)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatBumpingFrameset_178fc)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioFatBumpingFrameset_17905)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatBumpingFrameset_17905)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_FatBumping:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_FatIdling

UpdateState_FatEating:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_FatSinking
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
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
;	fallthrough

SetState_FatIdling:
	ld a, WST_FAT_IDLING
	ld [wWarioState], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld a, TOUCH_ATTACK
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatIdlingFrameset_1781c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatIdlingFrameset_1781c)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioFatIdlingFrameset_1781f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatIdlingFrameset_1781f)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_FatIdling:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	call HandleFatIdlingInput
	ld a, [wWarioState]
	cp WST_FAT_IDLING
	ret nz ; done if not fat idling anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_FatAirborne_Fall
	ret

HandleFatIdlingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_FatAirborne_Jump
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jr nz, SetState_FatWalking
	ret

SetState_FatWalking:
	xor a
	ld [wWalkVelIndex], a
	ld a, WST_FAT_WALKING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatWalkingFrameset_17822)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatWalkingFrameset_17822)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioFatWalkingFrameset_1782b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatWalkingFrameset_1782b)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_FatWalking:
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
	play_sfx SFX_FAT_WALK
.skip_sfx
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	cp HIGH(FAT_WARIO_DURATION) + 1 ; in case it underflowed
	jp nc, SetState_FatRecovering
	or [hl]
	jp z, SetState_FatRecovering
	call HandleFatWalkingInput
	ld a, [wWarioState]
	cp WST_FAT_WALKING
	ret nz ; done if not fat walking anymore
	farcall CheckCentreCollision

	ld a, b
	and a
	jp z, SetState_FatAirborne_Fall
	update_pos_y
	ret

SetState_FatTurning:
	ld a, WST_FAT_TURNING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatTurningFrameset_178f3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatTurningFrameset_178f3)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioFatTurningFrameset_178ea)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatTurningFrameset_178ea)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

UpdateState_FatTurning:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, SetState_FatAirborne_Jump
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_FatWalking

SetState_FatAirborne_Jump:
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
	ld a, HIGH(WarioFatFrameset_17834)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17834)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFatFrameset_17839)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17839)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	jr SetState_FatAirborne

SetState_FatAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, TRUE
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatFrameset_1783e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_1783e)
	ld [wWarioFramesetPtr + 1], a
	jr SetState_FatAirborne
.dir_right
	ld a, HIGH(WarioFatFrameset_17841)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17841)
	ld [wWarioFramesetPtr + 1], a
;	fallthrough

SetState_FatAirborne:
	xor a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, WST_FAT_AIRBORNE
	ld [wWarioState], a
	ret

UpdateState_FatAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, SetState_FatSinking
	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	or [hl]
	jr nz, .got_duration
	inc [hl]
.got_duration
	ld a, BANK("Wario OAM 1")
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
	ld a, $01
	ld [wWarioStateCounter], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatFrameset_1783e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_1783e)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioFatFrameset_17841)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17841)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

.handle_movement
	call HandleFatAirborneMovement
	ld a, [wWarioState]
	cp WST_FAT_AIRBORNE
	ret nz ; done if not fat airborne anymore

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_FAT_AIRBORNE
	ret nz ; done if not fat airborne anymore
	jp SetState_FatAirborne_Fall

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
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
	jr nz, SetState_FatLanding
	play_sfx SFX_FAT_LAND
;	fallthrough

SetState_FatLanding:
	ld a, WST_FAT_LANDING
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
	jr nz, .dir_right
	ld a, HIGH(WarioFatFrameset_17872)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17872)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFatFrameset_17887)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17887)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FatLanding:
	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	cp $02
	jp nc, SetState_FatRecovering
	or [hl]
	jp z, SetState_FatRecovering
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wGroundShakeCounter]
	and a
	ret nz
	jp SetState_FatIdling

SetState_FatSinking:
	get_pos
	ldh a, [hYPosLo]
	and $f0
	ldh [hYPosLo], a
	ld b, PARTICLE_SPLASH
	farcall CreateParticle
	play_sfx SFX_SPLASH

	ld a, WST_FAT_SINKING
	ld [wWarioState], a
	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a ; TRUE
	ld [wIsIntangible], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatFrameset_17872)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17872)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFatFrameset_17887)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatFrameset_17887)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FatSinking:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wGlobalCounter]
	and %1111
	call z, CreateFatSinkingBubbles
	ld b, $01
	call MoveWarioDown
	farcall CheckCentreCollision
	ld a, b
	and a
	ret z
	call RecoverFromTransformation_Underwater
	ret

CreateFatSinkingBubbles:
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub $04
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $10
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr .create
.facing_right
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add $04
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $10
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
.create
	ld b, PARTICLE_BUBBLES
	farcall CreateParticle
	ret

SetState_FatRecovering:
	ld a, WST_FAT_RECOVERING
	ld [wWarioState], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	xor a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a
	ld [wIsSmashAttacking], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFatRecoveringFrameset_17844)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatRecoveringFrameset_17844)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFatRecoveringFrameset_1785b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFatRecoveringFrameset_1785b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_FatRecovering:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation

UpdateState_ElectricStart:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z

	ld a, $01
	ld [wInvincibleCounter], a
	ld a, WST_ELECTRIC
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, $06
	ld [wJumpVelIndex], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, [wIsCrouching]
	and a
	jr z, .knock_back
	ld a, -27
	ld [wCollisionBoxTop], a
	ldh a, [hYPosHi]
	ldh [hYPosHiBackup], a
	ldh a, [hYPosLo]
	ldh [hYPosLoBackup], a
	ldh a, [hXPosHi]
	ldh [hXPosHiBackup], a
	ldh a, [hXPosLo]
	ldh [hXPosLoBackup], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_ELECTRIC
	ret nz
	ld a, b
	and a
	jr nz, .stay_crouched

	xor a
	ld [wIsCrouching], a

	ldh a, [hYPosHiBackup]
	ldh [hYPosHi], a
	ldh a, [hYPosLoBackup]
	ldh [hYPosLo], a
	ldh a, [hXPosHiBackup]
	ldh [hXPosHi], a
	ldh a, [hXPosLoBackup]
	ldh [hXPosLo], a
.knock_back
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, $01
	ld [wJumpVelTable], a
	jr .set_frameset
.stay_crouched
	ld a, -15
	ld [wCollisionBoxTop], a
	xor a
	ld [wJumpVelTable], a
	ldh a, [hYPosHiBackup]
	ldh [hYPosHi], a
	ldh a, [hYPosLoBackup]
	ldh [hYPosLo], a
	ldh a, [hXPosHiBackup]
	ldh [hXPosHi], a
	ldh a, [hXPosLoBackup]
	ldh [hXPosLo], a

.set_frameset
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioElectricStartFrameset_17b8d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricStartFrameset_17b8d)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioElectricStartFrameset_17b7c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricStartFrameset_17b7c)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Electric:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
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
	jp nc, .dizzy
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
	jr .dizzy
.bounce_1
	ld a, $0a
	ld [wJumpVelIndex], a
	ret
.bounce_2
	ld a, $0e
	ld [wJumpVelIndex], a
	ret

.dizzy
	play_sfx SFX_ELECTRIC_LAND

	ld a, [wDirection]
	and a
	jr nz, .smoke_right
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub $08
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $20
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr .create_smoke

.smoke_right
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add $08
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [hld]
	sub $20
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
.create_smoke
	ld b, PARTICLE_SMOKE_SMALL
	farcall CreateParticle

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a

	ld a, WST_ELECTRIC_DIZZY
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioElectricFrameset_17b9e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricFrameset_17b9e)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioElectricFrameset_17bad)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricFrameset_17bad)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ElectricDizzy:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation

SetState_TurningInvisible:
	play_sfx SFX_INVISIBLE_TRANSFORM

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a

	inc a ; TRUE
	ld [wIsIntangible], a

	ld a, WST_TURNING_INVISIBLE
	ld [wWarioState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a ; TOUCH_NONE
	ld [wTouchState], a
	ld [wStingTouchState], a
	ld [wSpikeTouchState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioDefaultPal
	call SetWarioPal

	ld a, BANK(WarioDizzyGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioDizzyGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioDizzyGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioTurningInvisibleOAM_17cf7)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioTurningInvisibleOAM_17cf7)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioTurningInvisibleOAM_17cf7)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioTurningInvisibleFrameset_17e1b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioTurningInvisibleFrameset_17e1b)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioTurningInvisibleFrameset_17e3a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioTurningInvisibleFrameset_17e3a)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_TurningInvisible:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	xor a
	ld [wIsIntangible], a
	ld a, TRANSFORMATION_INVISIBLE_WARIO
	ld [wTransformation], a
	call UpdateLevelMusic
	farcall SetState_Idling
	ret

SetState_PuffyInflating:
	ld a, TRANSFORMATION_PUFFY_WARIO
	ld [wTransformation], a

	ld a, TOUCH_VULNERABLE
	ld [wStingTouchState], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a

	play_sfx SFX_PUFFY_INFLATE

	ld a, WST_PUFFY_INFLATING
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
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld [wSwimVelIndex], a
	ld [wWaterSurfaceFloatingCounter], a
	ld [wWaterCurrent], a
	ld [wLastWaterCurrent], a
	ld [wCurWaterCurrent], a
	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, BANK(WarioPuffyGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioPuffyGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioPuffyGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioPuffyInflatingOAM_1dc93f)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioPuffyInflatingOAM_1dc93f)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioPuffyInflatingOAM_1dc93f)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioPuffyInflatingFrameset_1dccc0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyInflatingFrameset_1dccc0)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioPuffyInflatingFrameset_1dccc9)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyInflatingFrameset_1dccc9)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_PuffyInflating:
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

SetState_PuffyRising:
	ld a, WST_PUFFY_RISING
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a
	ld [wJumpVelTable], a

	ld hl, WarioDefaultPal
	call SetWarioPal

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioPuffyRisingFrameset_1dcd4e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyRisingFrameset_1dcd4e)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioPuffyRisingFrameset_1dcd57)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyRisingFrameset_1dcd57)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_PuffyRising:
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
	play_sfx SFX_PUFF_RAISE
.skip_sfx

	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandlePuffyRising
	ret

SetState_PuffyTurning:
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a

	ld a, WST_PUFFY_TURNING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioPuffyTurningFrameset_1dcce3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyTurningFrameset_1dcce3)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioPuffyTurningFrameset_1dccd8)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyTurningFrameset_1dccd8)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_PuffyTurning:
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call MoveWarioUpSlowly
	farcall CheckUpCollision

	ld a, [wWarioState]
	cp WST_PUFFY_TURNING
	ret nz ; done if not puffy turning any more

	ld a, b
	and a
	jr z, .not_blocked
	jp SetState_PuffyDeflating

.not_blocked
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_PuffyRising

SetState_PuffyDeflating:
	play_sfx SFX_PUFFY_DEFLATE

	ld a, WST_PUFFY_DEFLATING
	ld [wWarioState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a ; TRUE
	ld [wIsIntangible], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioPuffyDeflatingFrameset_1dccee)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyDeflatingFrameset_1dccee)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioPuffyDeflatingFrameset_1dcd1e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyDeflatingFrameset_1dcd1e)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_PuffyDeflating:
	ld a, [wWarioStateCounter]
	and a
	jr nz, .update_animation

	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, $01
	ld [wWarioStateCounter], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioPuffyDeflatingFrameset_1dcd01)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyDeflatingFrameset_1dcd01)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioPuffyDeflatingFrameset_1dcd31)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioPuffyDeflatingFrameset_1dcd31)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, [wWarioOAMBank]
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp RecoverFromTransformation

SetState_ZombieIdling:
	ld a, WST_ZOMBIE_IDLING
	ld [wWarioState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld a, TOUCH_VANISH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wInvisibleFrame], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioZombiePal
	call SetWarioPal

	ld a, BANK(WarioZombieGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioZombieGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioZombieGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioZombieIdlingOAM_1fc48b)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioZombieIdlingOAM_1fc48b)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioZombieIdlingOAM_1fc48b)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieIdlingFrameset_1fc8b6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieIdlingFrameset_1fc8b6)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieIdlingFrameset_1fc8b9)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieIdlingFrameset_1fc8b9)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieIdling:
	farcall CheckTopBlockInteraction
	ld a, [wWarioState]
	cp WST_ZOMBIE_IDLING
	ret nz ; done if not zombie idling anymore

	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_ZOMBIE_IDLING
	ret nz ; done if not zombie idling anymore

	ld a, b
	and a
	jp z, SetState_ZombieAirborne_Fall
	update_pos_y
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleZombieIdlingInput
	ret

SetState_ZombieWalking:
	xor a
	ld [wSFXLoopCounter], a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a

	ld a, WST_ZOMBIE_WALKING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieWalkingFrameset_1fc870)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieWalkingFrameset_1fc870)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieWalkingFrameset_1fc879)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieWalkingFrameset_1fc879)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieWalking:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, 36
	ld [wSFXLoopCounter], a
	play_sfx SFX_ZOMBIE_WALK
.skip_sfx
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleZombieWalkingInput

	ld a, [wWarioState]
	cp WST_ZOMBIE_WALKING
	ret nz ; done if not zombie walking anymore

	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, SetState_ZombieAirborne_Fall

	update_pos_y
	ret

SetState_ZombieTurning:
	ld a, WST_ZOMBIE_TURNING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieTurningFrameset_1fc89d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieTurningFrameset_1fc89d)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieTurningFrameset_1fc894)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieTurningFrameset_1fc894)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieTurning:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_ZombieWalking

SetState_ZombieAirborne_Fall:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieFrameset_1fc8b0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieFrameset_1fc8b0)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieFrameset_1fc8b3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieFrameset_1fc8b3)
	ld [wWarioFramesetPtr + 1], a

.got_frameset
	ld a, $01
	ld [wWarioStateCounter], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr SetState_ZombieAirborne

SetState_ZombieAirborne_Jump:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieFrameset_1fc8a6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieFrameset_1fc8a6)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieFrameset_1fc8ab)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieFrameset_1fc8ab)
	ld [wWarioFramesetPtr + 1], a

.got_frameset
	xor a
	ld [wWarioStateCounter], a
	ld [wJumpVelIndex], a
;	fallthrough

SetState_ZombieAirborne:
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
	xor a
	ld [wWarioStateCycles], a
	ld a, WST_ZOMBIE_AIRBORNE
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioState]
	cp WST_ZOMBIE_AIRBORNE
	ret nz ; done if not zombie airborne anymore

	call HandleZombieAirborneMovement
	ld a, [wWarioState]
	cp WST_ZOMBIE_AIRBORNE
	ret nz ; done if not zombie airborne anymore

	ld a, [wWarioStateCounter]
	and a
	jr nz, .update_animation
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .update_animation
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a
	ld [wWarioStateCounter], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieFrameset_1fc8b0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieFrameset_1fc8b0)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld a, HIGH(WarioZombieFrameset_1fc8b3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieFrameset_1fc8b3)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioState]
	cp WST_ZOMBIE_AIRBORNE
	ret nz ; done if not zombie airborne anymore

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_ZOMBIE_AIRBORNE
	ret nz ; done if not zombie airborne anymore
	jp SetState_ZombieAirborne_Fall

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition
.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_ZOMBIE_AIRBORNE
	ret nz ; done if not zombie airborne anymore
;	fallthrough

SetState_ZombieLanding:
	play_sfx SFX_ZOMBIE_LAND

	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a

	ld a, WST_ZOMBIE_LANDING
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	farcall CheckStandingOnFloorBlocks
	ld a, [wHitFloorBlock]
	and a
	jr z, .solid_ground

	ld a, $01
	ld [wWarioStateCounter], a

	ld a, [wDirection]
	and a
	jr nz, .floor_block_dir_right
	ld a, HIGH(WarioZombieLandingFrameset_1fc8bc)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieLandingFrameset_1fc8bc)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.floor_block_dir_right
	ld a, HIGH(WarioZombieLandingFrameset_1fc8d5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieLandingFrameset_1fc8d5)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.solid_ground
	ld a, [wDirection]
	and a
	jr nz, .solid_ground_dir_right
	ld a, HIGH(WarioZombieLandingFrameset_1fc948)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieLandingFrameset_1fc948)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.solid_ground_dir_right
	ld a, HIGH(WarioZombieLandingFrameset_1fc953)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieLandingFrameset_1fc953)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieLanding:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, [wWarioStateCounter]
	dec a
	jr z, .slip_through_floor
	jp SetState_ZombieIdling

.slip_through_floor
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ld a, $06
	ld [wWarioStateCycles], a

	ld a, WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieLandingFrameset_1fc928)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieLandingFrameset_1fc928)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieLandingFrameset_1fc92b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieLandingFrameset_1fc92b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieSlippingThroughFloor:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioState]
	cp WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	ret nz ; done if not slipping through floor anymore

	call HandleZombieAirborneMovement
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioState]
	cp WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	ret nz ; done if not slipping through floor anymore

	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	ret nz ; done if not slipping through floor anymore
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	ret nz ; done if not slipping through floor anymore

	call SetState_ZombieLanding

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieSlippingThroughFloorFrameset_1fc8ee)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieSlippingThroughFloorFrameset_1fc8ee)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieSlippingThroughFloorFrameset_1fc90b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieSlippingThroughFloorFrameset_1fc90b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioAnimationEnded], a
	ld a, $02
	ld [wWarioStateCounter], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_ZombieRecovering:
	ld a, WST_ZOMBIE_RECOVERING
	ld [wWarioState], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ret

UpdateState_ZombieRecovering:
	ld a, [wGlobalCounter]
	and %11
	ret nz
	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hli]
	cp $08
	jr c, .set_pal_index
	cp $0b
	jr z, .recover
	dec [hl]
	ld a, [hl]
	jr .got_pal_index
.set_pal_index
	ld [hl], a
.got_pal_index
	add a
	add a
	add a
	add a ; *16
	ld e, a
	ld d, $00
	ld hl, WarioZombiePal
	add hl, de
	call SetWarioPal
	ret

.recover
	jp RecoverFromTransformation

SetState_ZombieKnockBack:
	ld a, [wWarioState]
	cp WST_ZOMBIE_KNOCK_BACK
	ret z
	cp WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	ret z
	cp WST_ZOMBIE_LANDING
	ret z

	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld a, WST_ZOMBIE_KNOCK_BACK
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieKnockBackFrameset_1fc92e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieKnockBackFrameset_1fc92e)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieKnockBackFrameset_1fc93b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieKnockBackFrameset_1fc93b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieKnockBack:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_ZombieIdling

SetState_ZombieWrithing:
	ld a, WST_ZOMBIE_WRITHING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioZombieWrithingFrameset_1fc882)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieWrithingFrameset_1fc882)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioZombieWrithingFrameset_1fc88b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioZombieWrithingFrameset_1fc88b)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_ZombieWrithing:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadDown]
	and a
	jp nz, SetState_ZombieIdling
	ret

SetState_BouncyStart:
	ld a, WST_BOUNCY_START
	ld [wWarioState], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, $02
	ld [wJumpVelTable], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -29
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
	ld [wInvisibleFrame], a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioBouncyPal
	call SetWarioPal

	ld a, BANK(WarioBouncyGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBouncyGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBouncyGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioBouncyStartOAM_1fc95e)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioBouncyStartOAM_1fc95e)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioBouncyStartOAM_1fc95e)
	ld [wWarioOAMPtr + 1], a

	ld a, HIGH(WarioBouncyFrameset_1fcc6c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFrameset_1fcc6c)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	ret z
	ld b, $02
	call MoveWarioRight
	ret

UpdateState_BouncyStart:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	call ApplyJumpVelocity
	call HandleWalk
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a

.got_walk_vel
	ld a, [wWarioState]
	cp WST_BOUNCY_START
	ret nz ; done if not bouncy start anymore

	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_BOUNCY_START
	ret nz ; done if not bouncy start anymore
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_BOUNCY_START
	ret nz ; done if not bouncy start anymore
;	fallthrough

SetState_BouncyFloor:
	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wWarioStateCounter], a
	ld [wWalkVelIndex], a
	ld a, WST_BOUNCY_FLOOR
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBouncyFloorFrameset_1fcc5f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFloorFrameset_1fcc5f)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BouncyFloor:
	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	or [hl]
	jp z, StartBouncyLastBounce
	call BlinkPalIfTransformationEnding
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z

	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr nz, StartBouncyJump_High
	jr StartBouncyJump_Normal

StartBouncyJump:
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr nz, StartBouncyJump_High
	jr StartBouncyJump_Normal

StartBouncyJump_High:
	ld a, JUMP_VEL_BOUNCY_HIGH_JUMP
	ld [wJumpVelTable], a
	jr StartBouncyJump_Common

StartBouncyJump_Normal:
	ld a, JUMP_VEL_BOUNCY_JUMP
	ld [wJumpVelTable], a
;	fallthrough

StartBouncyJump_Common:
	xor a
	ld [wJumpVelIndex], a
;	fallthrough

SetState_BouncyAirborne:
	ld a, WST_BOUNCY_AIRBORNE
	ld [wWarioState], a
	play_sfx SFX_BOUNCY_BOUNCE

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBouncyFrameset_1fcc6c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFrameset_1fcc6c)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BouncyAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioAnimationEnded]
	and a
	jr nz, .update_duration
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJumpVelTable]
	cp JUMP_VEL_BOUNCY_HIGH_JUMP
	jr nz, .update_duration
	ld a, [wWarioAnimationEnded]
	and a
	jr z, .update_duration

	get_pos
	ld b, PARTICLE_BOUNCY_JUMP
	farcall CreateParticle

.update_duration
	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	or [hl]
	jp z, SetState_BouncyUpsideDown
	call BlinkPalIfTransformationEnding
	call ApplyJumpVelocity
	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wWarioState]
	cp WST_BOUNCY_AIRBORNE
	ret nz ; done if not bouncy airborne any more

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling

; rising
	farcall CheckUpCollision
	ld a, b
	and a
	ret z
	ld a, [wWarioState]
	cp WST_BOUNCY_AIRBORNE
	ret nz ; done if not bouncy airborne any more

	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr .hit_ceiling

.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wWarioState]
	cp WST_BOUNCY_AIRBORNE
	ret nz ; done if not bouncy airborne any more
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_BOUNCY_AIRBORNE
	ret nz ; done if not bouncy airborne any more
	jp SetState_BouncyFloor

.hit_ceiling
	xor a
	ld a, WST_BOUNCY_CEILING
	ld [wWarioState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBouncyAirborneFrameset_1fcc75)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyAirborneFrameset_1fcc75)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BouncyCeiling:
	call DecrementTransformationDuration
	ld hl, wTransformationDuration
	ld a, [hli]
	or [hl]
	jr z, SetState_BouncyUpsideDown
	call BlinkPalIfTransformationEnding
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wWarioAnimationEnded]
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jp SetState_BouncyAirborne

SetState_BouncyUpsideDown:
	ld a, WST_BOUNCY_UPSIDE_DOWN
	ld [wWarioState], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a

	xor a
	ld [wWarioStateCycles], a

	ld a, TOUCH_PASS_THROUGH
	ld [wTouchState], a
	ld a, TOUCH_PASS_THROUGH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioBouncyPal
	call SetWarioPal

	ld a, HIGH(WarioBouncyUpsideDownFrameset_1fcc82)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyUpsideDownFrameset_1fcc82)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BouncyUpsideDown:
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
	jr nz, .landed
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_BOUNCY_UPSIDE_DOWN
	ret nz ; done if not bouncy upside down

	ld a, WST_BOUNCY_UPSIDE_DOWN_LANDING
	ld [wWarioState], a
	xor a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioBouncyUpsideDownFrameset_1fcc85)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyUpsideDownFrameset_1fcc85)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BouncyUpsideLanding:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

StartBouncyLastBounce:
	ld a, TOUCH_PASS_THROUGH
	ld [wTouchState], a
	ld a, TOUCH_PASS_THROUGH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	ld hl, WarioBouncyPal
	call SetWarioPal

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBouncyFrameset_1fccbf)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFrameset_1fccbf)
	ld [wWarioFramesetPtr + 1], a
	jr .reset_animation
.dir_right
	ld a, HIGH(WarioBouncyFrameset_1fccb2)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFrameset_1fccb2)
	ld [wWarioFramesetPtr + 1], a
.reset_animation
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	jr SetState_BouncyLastBounce

	ld a, [wDirection]
	and a
	jr nz, .unused_dir_right
	ld a, HIGH(WarioBouncyFrameset_1fcca5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFrameset_1fcca5)
	ld [wWarioFramesetPtr + 1], a
	jr .unused_reset_animation
.unused_dir_right
	ld a, HIGH(WarioBouncyFrameset_1fcc98)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBouncyFrameset_1fcc98)
	ld [wWarioFramesetPtr + 1], a
.unused_reset_animation
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
;	fallthrough

SetState_BouncyLastBounce:
	ld a, WST_BOUNCY_LAST_BOUNCE
	ld [wWarioState], a
	xor a
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BouncyLastBounce:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioAnimationEnded]
	and a
	jr nz, .apply_movement
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

.apply_movement
	call ApplyJumpVelocity
	call HandleWalk
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
	ld a, [wWarioState]
	cp WST_BOUNCY_LAST_BOUNCE
	ret nz ; done if not in last bouncy any more

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
	cp WST_BOUNCY_LAST_BOUNCE
	ret nz ; done if not in last bouncy any more
	jp RecoverFromTransformation

SetState_CrazySpinning:
	play_sfx SFX_CRAZY_SPIN
	ld a, WST_CRAZY_SPINNING
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
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a

	ld a, [wJumpVelTable]
	and a
	jr z, .got_jump_vel
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
.got_jump_vel
	call UpdateLevelMusic

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

	ld a, [wObjDirection]
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioCrazySpinningFrameset_14ccc)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazySpinningFrameset_14ccc)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioCrazySpinningFrameset_14ce1)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazySpinningFrameset_14ce1)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_CrazySpinning:
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
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld hl, wWarioStateCounter
	inc [hl]
	ld a, [hl]
	cp $80
	ret c
	ld [hl], $00

	play_sfx SFX_CRAZY_DIZZY
	ld a, WST_CRAZY_DIZZY
	ld [wWarioState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioDizzyGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioDizzyGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioDizzyGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioCrazyOAM_17bbc)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioCrazyOAM_17bbc)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioCrazyOAM_17bbc)
	ld [wWarioOAMPtr + 1], a

	ld a, HIGH(WarioCrazyFrameset_17ce2)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyFrameset_17ce2)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_CrazyDizzy:
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

SetState_Crazy:
	play_sfx SFX_CRAZY_DIZZY
	ld a, WST_CRAZY
	ld [wWarioState], a

	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_VULNERABLE
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioCrazyGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioCrazyGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioCrazyGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioCrazyOAM_1fccd5)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioCrazyOAM_1fccd5)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioCrazyOAM_1fccd5)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioCrazyFrameset_1fcf9f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyFrameset_1fcf9f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioCrazyFrameset_1fcf6e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyFrameset_1fcf6e)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_Crazy:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	call HandleCrazyInput
	ld a, [wWarioState]
	cp WST_CRAZY
	ret nz ; done if not crazy any more

	farcall CheckCentreCollision
	ld a, b
	and a
	jr z, SetState_CrazyAirborne_Fall
	ret

SetState_CrazyTurning:
	ld a, WST_CRAZY_TURNING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioCrazyTurningFrameset_1fcfd0)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyTurningFrameset_1fcfd0)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioCrazyTurningFrameset_1fcfd7)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyTurningFrameset_1fcfd7)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_CrazyTurning:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr nz, SetState_CrazyAirborne_Jump
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_Crazy

SetState_CrazyAirborne_Jump:
	xor a
	ld [wJumpVelIndex], a
	jr SetState_CrazyAirborne

SetState_CrazyAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
;	fallthrough

SetState_CrazyAirborne:
	ld a, WST_CRAZY_AIRBORNE
	ld [wWarioState], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a

	xor a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioCrazyFrameset_1fcf9f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyFrameset_1fcf9f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioCrazyFrameset_1fcf6e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioCrazyFrameset_1fcf6e)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_CrazyAirborne:
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

	call ApplyJumpVelocity
	call HandleWalk
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .got_walk_vel
	ld a, $0c
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
; rising
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
	call TriggerFloorTransition
	jp SetState_Crazy

SetState_VampireIdling:
	ld a, WST_VAMPIRE_IDLING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioVampireGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioVampireGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioVampireGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, HIGH(WarioVampireOAM_1fd498)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioVampireOAM_1fd498)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(WarioVampireIdlingFrameset_1fd81c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioVampireIdlingFrameset_1fd81c)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_VampireIdling:
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_VAMPIRE_IDLING
	ret nz ; done if not vampire idling any more

	ld a, b
	and a
	jp z, SetState_VampireAirborne_Fall
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleVampireIdlingInput
	ret

SetState_VampireWalking:
	ld a, WST_VAMPIRE_WALKING
	ld [wWarioState], a

	xor a
	ld [wWalkVelIndex], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jr nz, .left
	bit B_PAD_RIGHT, a
	jr nz, .right

	ld a, [wDirection]
	and a
	jr nz, .right
.left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, HIGH(WarioVampireWalkingFrameset_1fd825)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioVampireWalkingFrameset_1fd825)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, HIGH(WarioVampireFrameset_1fd82e)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioVampireFrameset_1fd82e)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_VampireWalking:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWarioState]
	cp WST_VAMPIRE_WALKING
	ret nz ; done if not vampire walking any more

	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleVampireWalkingInput
	ld a, [wWarioState]
	cp WST_VAMPIRE_WALKING
	ret nz ; done if not vampire walking any more

	farcall CheckCentreCollision

	ld a, [wWarioState]
	cp WST_VAMPIRE_WALKING
	ret nz ; done if not vampire walking any more

	ld a, b
	and a
	ret nz
	jp SetState_VampireAirborne_Fall

SetState_VampireTurning:
	ld a, WST_VAMPIRE_TURNING
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioVampireTurningFrameset_1fd841)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioVampireTurningFrameset_1fd841)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioVampireTurningFrameset_1fd83a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioVampireTurningFrameset_1fd83a)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_VampireTurning:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_VampireWalking

SetState_VampireAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	jr SetState_VampireAirborne

SetState_VampireAirborne_Jump:
	play_sfx SFX_FLAT_JUMP
	xor a
	ld [wJumpVelIndex], a
;	fallthrough

SetState_VampireAirborne:
	ld a, WST_VAMPIRE_AIRBORNE
	ld [wWarioState], a
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ret

UpdateState_VampireAirborne:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioState]
	cp WST_VAMPIRE_AIRBORNE
	ret nz ; done if not vampire airborne any more

	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleVampireAirborneMovement
	ld a, [wWarioState]
	cp WST_VAMPIRE_AIRBORNE
	ret nz ; done if not vampire airborne any more

	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	jr nc, .falling
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_VAMPIRE_AIRBORNE
	ret nz ; done if not vampire airborne any more

	ld a, b
	and a
	ret z
	jp SetState_VampireAirborne_Fall
.falling
	farcall CheckAirborneCollision
	ld a, b
	and a
	jr nz, .landed
	jp TriggerDownwardsFloorTransition

.landed
	call TriggerFloorTransition
	ld a, [wWarioState]
	cp WST_VAMPIRE_AIRBORNE
	ret nz ; done if not vampire airborne any more
	jp SetState_VampireIdling

SetState_BatTransforming:
	play_sfx SFX_BAT_TRANSFORM
	ld a, WST_BAT_TRANSFORMING
	ld [wWarioState], a

	ld a, -15
	ld [wCollisionBoxTop], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioBatGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBatGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBatGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, HIGH(WarioOAM_1fd031)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1fd031)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBatTransformingFrameset_1fd40a)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBatTransformingFrameset_1fd40a)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBatFrameset_1fd479)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBatFrameset_1fd479)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BatTransforming:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
;	fallthrough

SetState_BatIdling:
	ld a, WST_BAT_IDLING
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBatIdlingFrameset_1fd45f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBatIdlingFrameset_1fd45f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBatFrameset_1fd46c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBatFrameset_1fd46c)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_BatIdling:
	farcall CheckCentreCollision
	ld a, [wWarioState]
	cp WST_BAT_IDLING
	ret nz ; done if not bat idling any more

	ld a, b
	and a
	jp z, SetState_BatFalling

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

	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jr nz, .transform_back
	bit B_PAD_A, a
	jp nz, SetState_BatFlying
	ret

.transform_back
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_BAT_IDLING
	ret nz ; done if not bat idling any more

	ld a, b
	and a
	jr z, SetState_VampireTransforming
	ld a, -15
	ld [wCollisionBoxTop], a
	play_sfx SFX_ERROR
	ret

SetState_VampireTransforming:
	play_sfx SFX_VAMPIRE_TRANSFORM

	ld a, WST_VAMPIRE_TRANSFORMING
	ld [wWarioState], a

	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld a, TOUCH_VANISH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	xor a
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
	ld hl, WarioVampirePal
	call SetWarioPal
	ld a, BANK(WarioBatGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBatGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBatGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_1fd031)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_1fd031)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1fd031)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(WarioVampireFrameset_1fd439)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioVampireFrameset_1fd439)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_VampireTransforming:
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ld a, [wWarioAnimationEnded]
	and a
	ret z
	jp SetState_VampireIdling

SetState_BatFlying:
	ld a, WST_BAT_FLYING
	ld [wWarioState], a
	xor a
	ld [wSFXLoopCounter], a
	ld [wJumpVelIndex], a
	inc a
	ld [wJumpVelTable], a
	jp SetBatTurningFrameset

UpdateState_BatFlying:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioState]
	cp WST_BAT_FLYING
	ret nz ; done if not bat flying any more

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

	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_BAT_FLYING
	ret nz ; done if not bat flying any more

	ld a, b
	and a
	jr nz, SetState_BatFalling
	call HandleBatFlyingInput
	ld a, [wWarioState]
	cp WST_BAT_FLYING
	ret nz ; done if not bat flying any more

	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wIsTurning]
	and a
	ret z
;	fallthrough

SetBatTurningFrameset:
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBatFrameset_1fd42c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBatFrameset_1fd42c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioBatFrameset_1fd434)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBatFrameset_1fd434)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_BatFalling:
	ld a, WST_BAT_FALLING
	ld [wWarioState], a
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ret

UpdateState_BatFalling:
	farcall CheckTopBlockInteraction
	ld a, [wRoomTransitionParam]
	and a
	jp nz, TriggerRoomTransition
	ld a, [wWaterInteraction]
	and a
	jp nz, RecoverFromTransformation
	ld a, [wWarioState]
	cp WST_BAT_FALLING
	ret nz ; done if not bat falling any more
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_BatFlying
	call ApplyJumpVelocity
	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a

.got_walk_vel
	ld a, [wIsTurning]
	and a
	call nz, SetBatTurningFrameset
	farcall CheckAirborneCollision
	ld a, [wWarioState]
	cp WST_BAT_FALLING
	ret nz ; done if not bat falling any more

	ld a, b
	and a
	ret z
	update_pos_y
	jp SetState_BatIdling

SetState_InBubble:
	ld a, WST_IN_BUBBLE
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

	ld hl, WarioBubblePal
	call SetWarioPal
	ld a, BANK(WarioBubbleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioBubbleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioBubbleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioInBubbleOAM_1fd87c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioInBubbleOAM_1fd87c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioInBubbleOAM_1fd87c)
	ld [wWarioOAMPtr + 1], a

	ld a, [wObjDirection]
	ld [wDirection], a
	ld [wWarioStateCounter], a
	ld a, HIGH(WarioInBubbleFrameset_1fdb2c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioInBubbleFrameset_1fdb2c)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

UpdateState_InBubble:
	farcall CheckTopBlockInteraction
	ld a, [wWaterInteraction]
	and a
	jr z, .burst

	ld a, [wSFXLoopCounter]
	sub 1
	ld [wSFXLoopCounter], a
	jr nc, .skip_sfx
	ld a, $0e
	ld [wSFXLoopCounter], a
	play_sfx SFX_BUBBLE_FLOAT
.skip_sfx
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	call HandleInBubble
	ret

.burst
	get_pos
	ld b, PARTICLE_BUBBLE_BURST
	farcall CreateParticle
	jp RecoverFromTransformation

RecoverFromTransformation_Underwater:
	call ClearTransformationValues
	ld a, $10
	ld [wInvincibleCounter], a
	call UpdateLevelMusic
	farcall SetState_Submerged

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a
	ld [wWarioStateCycles], a
	ld hl, WarioDefaultPal
	call SetWarioPal
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

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioUnderwaterFrameset_155a6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioUnderwaterFrameset_155a6)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioUnderwaterFrameset_155ab)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioUnderwaterFrameset_155ab)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jp PlayRecoverySFX

RecoverFromTransformation_InWater:
	call ClearTransformationValues
	ld a, $10
	ld [wInvincibleCounter], a
	call UpdateLevelMusic
	get_pos
	ldh a, [hYPosLo]
	and $f0
	ldh [hYPosLo], a
	ld b, PARTICLE_SMOKE_LARGE
	farcall CreateParticle
	play_sfx SFX_SPLASH
	farcall DiveFromSurface_SkipSplash
	ret

DecrementTransformationDuration:
	ld hl, wTransformationDuration + 1
	ld a, [hl]
	sub 1
	ld [hld], a
	ld a, [hl]
	sbc 0
	ld [hl], a
	ret

BlinkPalIfTransformationEnding:
	call IsTransformationEnding
	ret nc
	ld de, $0
	ld a, [wWarioStateCycles]
	xor $1
	ld [wWarioStateCycles], a
	jr z, .normal_pal
	ld hl, WarioBouncyRedPal
	add hl, de
	call SetWarioPal
	ret

.normal_pal
	ld hl, WarioBouncyPal
	add hl, de
	call SetWarioPal
	ret

IsTransformationEnding:
	ld hl, wTransformationDuration
	ld a, [hli]
	cp $02
	jr nc, .no_carry
	and a
	jr z, .hi_zero
	ld a, [hl]
	cp $68
	jr nc, .no_carry
	jr .every_16_frames

.hi_zero
	ld a, [hl]
	cp $78
	jr nc, .every_16_frames
	ld a, [wGlobalCounter]
	and %11
	jr nz, .no_carry
	ld a, $01
	jr .set_carry
.every_16_frames
	ld a, [wGlobalCounter]
	and %1111
	jr nz, .no_carry

.set_carry
	scf
	ret

.no_carry
	scf
	ccf
	ret

HandleOnFireInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jr z, .no_jump
	farcall CheckUpCollision
	ld a, b
	and a
	jr nz, .no_jump
	jp SetState_OnFireAirborne_Jump
.no_jump
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	jr .facing_left
.facing_left
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .bounce_off_left_wall
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jp .cap_walk_vel ; should be jr
.facing_right
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .bounce_off_right_wall
	call ApplyWalkVelocity_Right
	call MoveWarioRight

.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $14
	jr c, .done
	ld a, $10
	ld [wWalkVelIndex], a
.done
	ret

.bounce_off_left_wall
	ld b, $02
	call MoveWarioRight
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, [wWarioStateCounter]
	and a
	jr nz, .bounce_right_loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b49)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b49)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.bounce_right_loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.bounce_off_right_wall
	ld b, $02
	call MoveWarioLeft
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, [wWarioStateCounter]
	and a
	jr nz, .bounce_left_loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b38)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.bounce_left_loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

	farcall CheckCentreCollision
	ld a, b
	and a
	ret z
	farcall CheckFrontCollision
	ld a, b
	and a
	jp nz, SetState_Hot_ResetDuration
	ret

SetState_OnFireAirborne_Fall:
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_HIGH_JUMP
	ld [wJumpVelTable], a
	jr SetState_OnFireAirborne

SetState_OnFireAirborne_Jump:
	play_sfx SFX_JUMP

	xor a
	ld [wJumpVelIndex], a
	ld a, JUMP_VEL_NORMAL
	ld [wJumpVelTable], a
;	fallthrough

SetState_OnFireAirborne:
	xor a
	ld [wWarioStateCycles], a
	ld a, WST_ON_FIRE_AIRBORNE
	ld [wWarioState], a
	ret

HandleOnFireAirborneMovement:
	call ApplyJumpVelocity
	call HandleWalk
	ld a, [wWalkVelIndex]
	cp $14
	jr c, .got_walk_vel
	ld a, $10
	ld [wWalkVelIndex], a
.got_walk_vel
	farcall CheckFrontCollision
	ld a, b
	and a
	ret z
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
;	fallthrough

OnFireBounceOffWall:
	ld a, [wDirection]
	xor $1 ; switch direction
	ld [wDirection], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld b, $03
	call MoveWarioLeft
	ld a, [wWarioStateCounter]
	and a
	jr nz, .loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b38)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b14)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right
	ld b, $03
	call MoveWarioRight
	ld a, [wWarioStateCounter]
	and a
	jr nz, .dir_right_loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b49)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b49)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.dir_right_loop_anim
	ld a, HIGH(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b1d)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

HandleHotAirborneMovement:
	call ApplyJumpVelocity
	ld hl, wWarioStateCounter
	ld a, [hl]
	and a
	jr z, .walk
	dec [hl]
	ret

.walk
	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wIsTurning]
	and a
	ret z
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioHotFrameset_16b26)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16b26)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioHotFrameset_16b2f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16b2f)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

HandleHotWarioInput:
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	ret z
	and PAD_RIGHT
	jr nz, .d_right
	ld a, [wDirection]
	and a
	jr z, .move_left

	ld a, DIRECTION_LEFT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioHotFrameset_16b26)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16b26)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
.move_left
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	ld b, 1
	call MoveWarioLeft
	ret

.d_right
	ld a, [wDirection]
	and a
	jr nz, .move_right

	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, HIGH(WarioHotFrameset_16b2f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioHotFrameset_16b2f)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation

.move_right
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	ld b, 1
	call MoveWarioRight
	ret

HandleFlatIdlingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_FlatJumping
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_FlatWalking
	ret

HandleFlatWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_FlatJumping
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jr nz, .d_left
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	jp SetState_FlatIdling

.d_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	farcall CheckFrontCollision
	ld a, b
	and a
	ret nz
	call ApplyWalkVelocity_Left
	call MoveWarioLeft
	jr .cap_walk_vel

.d_right
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

WalkFromInput:
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .right
	bit B_PAD_LEFT, a
	jr nz, .left
	ret
.right
	farcall WalkRight
	ret
.left
	farcall WalkLeft
	ret

HandleWalk:
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	farcall WalkLeft
	ret
.dir_right
	farcall WalkRight
	ret

MoveWarioForwardBy2:
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld b, $02
	call MoveWarioLeft
	farcall CheckBottomLeftCollision_Break

	ld a, b
	and a
	jr z, .vertical
	ld b, $02
	call MoveWarioRight
	jr .vertical
.facing_right
	ld b, $02
	call MoveWarioRight
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr z, .vertical
	ld b, $02
	call MoveWarioLeft

.vertical
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
	jr .done
.falling
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

HandleFatWalkingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_FatAirborne_Jump
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_FatIdling

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
	jp SetState_FatTurning

.d_left
	ld a, [wDirection]
	cp $00
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
	jp SetState_FatTurning

HandleFatAirborneMovement:
	call ApplyJumpVelocity
	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $08
	jr c, .got_walk_vel
	ld a, $04
	ld [wWalkVelIndex], a
.got_walk_vel
	ld a, [wJumpVelIndex]
	cp FALLING_JUMP_VEL_INDEX
	ret nz
	ld a, TRUE
	ld [wIsSmashAttacking], a
	ret

HandlePuffyRising:
	call MoveWarioUpSlowly
	farcall CheckUpCollision
	ld a, [wWarioState]
	cp WST_PUFFY_RISING
	ret nz ; done if not puffy rising

	ld a, b
	and a
	jr z, .not_blocked
	jp SetState_PuffyDeflating

.not_blocked
	ld a, [wCameraConfigFlags]
	and CAM_SCROLLING_MASK
	cp CAM_TRANSITIONS
	jr c, .handle_input
	call GetFloorForYPos
	ld a, [wFloor]
	sub c
	jr nc, .handle_input
	call StartUpwardsFloorTransition

.handle_input
	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jp nz, SetState_PuffyTurning
	bit B_PAD_LEFT, a
	ret z
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	ret nz
	ld b, $01
	call MoveWarioLeft
	ret

.facing_right
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jp nz, SetState_PuffyTurning
	bit B_PAD_RIGHT, a
	ret z
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	ret nz
	ld b, $01
	call MoveWarioRight
	ret

MoveWarioUpSlowly:
	ld a, [wGlobalCounter]
	and %1
	ret nz
	ld b, $01
	call MoveWarioUp
	ret

HandleZombieIdlingInput:
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jp nz, SetState_ZombieAirborne_Jump
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_ZombieWalking

	farcall CheckCentreCollision
	ld a, b
	and a
	jp z, SetState_ZombieAirborne_Fall

	ld hl, wWarioStateCounter
	ld a, [hl]
	add $01
	ld [hli], a
	ld a, [hl]
	adc $00
	ld [hl], a
	cp $02
	ret c
	jp SetState_ZombieWrithing

	ret ; unnecessary

HandleZombieWalkingInput:
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jp nz, SetState_ZombieAirborne_Jump
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_ZombieIdling

.d_right
	ld a, [wDirection]
	and a
	jr z, .turn_right
	farcall WalkIfPossible_Right
	jr .cap_walk_vel

.turn_right
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jp SetState_ZombieTurning
.d_left
	ld a, [wDirection]
	and a
	jr nz, .turn_left
	farcall WalkIfPossible_Left
.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .done
	ld a, $00
	ld [wWalkVelIndex], a
.done
	ret
.turn_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jp SetState_ZombieTurning

HandleZombieAirborneMovement:
	call ApplyJumpVelocity
	ld hl, wWarioStateCycles
	ld a, [hl]
	and a
	jr z, .walk
	dec [hl]
	ret

.walk
	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $04
	jr c, .done
	ld a, $00
	ld [wWalkVelIndex], a
.done
	ret

HandleCrazyInput:
	ld a, [wJoypadPressed]
	bit B_PAD_A, a
	jp nz, SetState_CrazyAirborne_Jump
	call UpdateCrazyWalk
	ld a, [wWarioState]
	cp WST_CRAZY
	ret nz ; done if not crazy any more

	ld a, [wWarioAnimationEnded]
	and a
	ret z

	ld a, [wDirection]
	and a
	jr nz, .facing_right
	ld a, [wJoypadDown]
	bit B_PAD_LEFT, a
	jr z, .turn
.keep_walking
	xor a
	ld [wWalkVelIndex], a
	ret
.facing_right
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .keep_walking
.turn
	jp SetState_CrazyTurning

UpdateCrazyWalk:
	ld hl, wWalkVelIndex
	inc [hl]
	ld a, [hl]
	cp $06
	jr c, .move_fast
	jp z, CreateDustParticleAtWario
	cp $09
	ret c
	cp $12
	jr c, .move_fast
	jp z, CreateDustParticleAtWario
	cp $15
	ret c
	cp $18
	jr c, .move_fast
	cp $22
	jr c, .move_slow
	jp z, CreateDustParticleAtWario
	cp $25
	ret c
	cp $2c
	jr c, .move_every_other_frame
	ret

.move_every_other_frame
	ld a, [wGlobalCounter]
	and %1
	ret z
.move_slow
	ld a, [wDirection]
	and a
	jr nz, .move_slow_right
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .turn
	ld b, $01
	call MoveWarioLeft
	ret

.move_slow_right
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .turn
	ld b, $01
	call MoveWarioRight
	ret

.move_fast
	ld a, [wDirection]
	and a
	jr nz, .move_fast_right
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .turn
	ld b, $02
	call MoveWarioLeft
	ret

.move_fast_right
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .turn
	ld b, $02
	call MoveWarioRight
	ret
.turn
	jp SetState_CrazyTurning

CreateDustParticleAtWario:
	get_pos
	ld b, PARTICLE_DUST
	farcall CreateParticle
	ret

HandleVampireIdlingInput:
	ld a, [wJoypadPressed]
	bit B_PAD_B, a
	jp nz, SetState_BatTransforming
	bit B_PAD_A, a
	jp nz, SetState_VampireAirborne_Jump
	ld a, [wJoypadDown]
	and PAD_RIGHT | PAD_LEFT
	jp nz, SetState_VampireWalking
	ret

HandleVampireWalkingInput:
	ld a, [wJoypadDown]
	bit B_PAD_B, a
	jp nz, SetState_BatTransforming
	bit B_PAD_A, a
	jp nz, SetState_VampireAirborne_Jump
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left
	jp SetState_VampireIdling

.d_right
	ld a, [wDirection]
	and a
	jp z, SetState_VampireTurning
	farcall WalkIfPossible_Right
	jr .cap_walk_vel
.d_left
	ld a, [wDirection]
	and a
	jp nz, SetState_VampireTurning
	farcall WalkIfPossible_Left
.cap_walk_vel
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .done
	ld a, $0c
	ld [wWalkVelIndex], a
.done
	ret

HandleVampireAirborneMovement:
	call ApplyJumpVelocity
	call WalkFromInput
	ld a, [wWalkVelIndex]
	cp $10
	jr c, .done
	ld a, $0c
	ld [wWalkVelIndex], a
.done
	ret

HandleInBubble:
	ld a, [wGlobalCounter]
	and %1
	jr z, .horizontal
	ld b, $01
	call MoveWarioUp
	farcall CheckUpCollision
	ld a, b
	and a
	ret z

	get_pos
	ld b, PARTICLE_BUBBLE_BURST
	farcall CreateParticle
	jp RecoverFromTransformation

.horizontal
	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .d_right
	bit B_PAD_LEFT, a
	jr nz, .d_left

	ld a, [wWarioStateCounter]
	ld [wDirection], a
	farcall CheckFrontCollision
	ld a, b
	and a
	jr nz, .turn

	ld hl, WarioInBubbleData_2b6b4
	ld a, [wJumpVelIndex]
	ld e, a
	ld d, $00
	add hl, de
	ld b, [hl]
	ld a, [wWarioStateCounter]
	and a
	jr nz, .drift_right
	call MoveWarioLeft
	jr .next_drift_step
.drift_right
	call MoveWarioRight
.next_drift_step
	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp $2f
	ret c

.turn
	ld a, [wWarioStateCounter]
	xor $1
	ld [wWarioStateCounter], a
	ld [wDirection], a
.reset_drift
	xor a
	ld [wJumpVelIndex], a
	ret

.d_right
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .turn
	ld b, $01
	call MoveWarioRight
	jr .reset_drift
.d_left
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .turn
	ld b, $01
	call MoveWarioLeft
	jr .reset_drift

HandleBatFlyingInput:
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jp z, SetState_BatFalling

	ld hl, wJumpVelIndex
	inc [hl]
	ld a, [hl]
	cp MAX_JUMP_VEL_INDEX + 1
	jr c, .rise
	jp SetState_BatFalling

	xor a
	ld [hl], a
.rise
	ld e, a
	ld d, $00
	farcall MoveWarioUpBySwimVel
	ret

WarioFlatData_2b664:
	db $03
	db $02
	db $02
	db $01
	db $01
	db $00
	db $01
	db $00
	db $01
	db $00
	db $01
	db $00
	db $01
	db $00
	db $01
	db $01
	db $01
	db $02
	db $01
	db $01
	db $01
	db $01
	db $01
	db $00
	db $01
	db $00
	db $01
	db $00
	db $01
	db $01
	db $00
	db $01
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00

WarioFlatData_2b68c:
	db $03
	db $02
	db $01
	db $01
	db $00
	db $00
	db $01
	db $00
	db $00
	db $01
	db $01
	db $00
	db $01
	db $01
	db $01
	db $01
	db $01
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $02
	db $03
	db $03
	db $03
	db $03
	db $03
	db $03
	db $03
	db $03
	db $02
	db $02
	db $02
	db $01
	db $00
	db $00

WarioInBubbleData_2b6b4:
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $00
	db $01
	db $00
	db $00
	db $01
	db $00
	db $01
	db $00
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $01
	db $00
	db $01
	db $00
	db $01
	db $00
	db $01
	db $00
	db $00
	db $01
	db $00
	db $00
	db $00
