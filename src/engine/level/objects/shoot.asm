DEF NUM_SHOOT_GOALS_NEEDED        EQU   3 ; number of goals Shoot needs to win
DEF NUM_WARIO_GOALS_NEEDED        EQU   3 ; number of goals Wario needs to win

DEF SHOOT_JUMP_X_SPEED            EQU   1 ; how fast Shoot moves horizontally while jumping
DEF SHOOT_PRESHOOT_X_SPEED        EQU   1 ; how fast Shoot moves horizontally when it has Wario ball
DEF SHOOT_OUT_OF_BALL_X_SPEED     EQU   2 ; how fast Shoot moves when jumping out of ball form

DEF SHOOT_TAUNT_DURATION          EQU  80 ; duration of taunt animation
DEF SHOOT_JUMP_DELAY_LONG         EQU  25 ; delay between jumps when Wario has 0 goals
DEF SHOOT_JUMP_DELAY_SHORT        EQU   2 ; delay between jumps when Wario has at least 1 goal
DEF SHOOT_IDLE_DURATION           EQU  27 ; duration of staying in standing state
DEF SHOOT_JUMP_UP_DURATION        EQU  22 ; duration of moving up while jumping
DEF SHOOT_TURN_AROUND_DURATION    EQU  42 ; duration of moving up while jumping
DEF SHOOT_REGULAR_BALL_DURATION   EQU 256 ; duration switching direction while following Wario
DEF SHOOT_LAST_GOAL_BALL_DURATION EQU 160 ; duration of ball form when Wario already has 2 goals
DEF SHOOT_DEFEAT_RISE_DURATION    EQU  28 ; duration of rising while playing defeated animation
DEF SHOOT_DEFEAT_SUSPENDED_DURATION EQU  70 ; duration of staying suspended while playing defeated animation

; Shoot phases controlled by Var1, when not in ball form
	const_def
	const SHOOTPHASE_STANDING
	const SHOOTPHASE_JUMPING_UP
	const SHOOTPHASE_JUMPING_DOWN
	const SHOOTPHASE_BETWEEN_JUMPS
	const SHOOTPHASE_TURNING
	const SHOOTPHASE_PREKICK_JUMP
	const SHOOTPHASE_PREKICK_ANIMATION
	const SHOOTPHASE_KICKING
	const SHOOTPHASE_SCORE_GOAL
	const SHOOTPHASE_WON

; wShootBallState constants
	const_def 5
	const SHOOTBALL_WARIO_KICKED ; Wario is moving towards goal after being kicked
	const SHOOTBALL_WARIO_GOAL   ; Wario entered the net zone and Shoot scores a goal

; GK Tortoise phases controlled by Var1
	const_def
	const GKTORTOISEPHASE_0
	const GKTORTOISEPHASE_1
	const GKTORTOISEPHASE_2
	const GKTORTOISEPHASE_3
	const GKTORTOISEPHASE_4
	const GKTORTOISEPHASE_5
	const GKTORTOISEPHASE_6
	const GKTORTOISEPHASE_DUCKING
	const GKTORTOISEPHASE_8
	const GKTORTOISEPHASE_9

ShootFunc:
	ld a, TRUE
	ld [wIsBossBattle], a
	stop_music2

	xor a
	ld [wShootCanTurnAround], a ; FALSE
	ld [wShootBallState], a

	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.StartWait)
	ld [hld], a
	ld a, LOW(.StartWait)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $5
	ld [hl], a
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 7
	ld [hld], a
	ld a, -8
	ld [hld], a
	ld a, -8
	ld [hl], a
	ld de, ShootFrameset_69f7c
	call SetObjectFramesetPtr
	ld a, SHOOT_TAUNT_DURATION
	ld [hli], a

	; position Shoot 32 pixels up
	; and 96 pixels right
	ld a, 32
	ld [wCurObjVar2], a
	call MoveObjectUpByVar2
	ld a, 96
	ld [wCurObjVar2], a
	jp MoveObjectRightByVar2

.StartWait:
	; wait until is on screen to advance to next function
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Taunt)
	ld [hld], a
	ld a, LOW(.Taunt)
	ld [hld], a
	ret

.Taunt:
	; play SFX every 16 frames
	ld a, [wGlobalCounter]
	and %1111
	play_sfx z, SFX_SHOOT_TAUNT

	; wait for this state to finish
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz

	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_SHOOT
	ld [hli], a
	ld a, $01
	ld [wShootBallState], a
	ld a, BOSS_REGULAR
	ld [wBossState], a
	call UpdateLevelMusic
	jp .set_standing

.hit_wario_below
	play_sfx SFX_SHOOT
	ld a, [wCurObjSubState]
	rlca
	jr nc, .jump_away_right
.jump_away_left
	xor a
	ld [hld], a ; OBJ_STATE
	res OBJSUBFLAG_VDIR_F, [hl]
	jr .jump_out_of_ball
.jump_away_right
	xor a
	ld [hld], a ; OBJ_STATE
	set OBJSUBFLAG_VDIR_F, [hl]
.jump_out_of_ball
	ld a, [hld] ; OBJ_SUBSTATE
	rlca
	ld_obj_frameset ShootFrameset_6a022 + $2, ShootFrameset_6a03a + $2
	ld a, SHOOT_OUT_OF_BALL_X_SPEED
	ld [wCurObjVar2], a
	jp .set_jumping_up

.interacted_with_ball_wario
	xor a
	ld [hld], a ; OBJ_STATE
	dec l
	ld [hld], a ; OBJ_VAR_3

	; move up 16 pixels
	ld a, 16
	ld [hl], a ; OBJ_VAR_2
	call MoveObjectUpByVar2

	ld de, ShootFrameset_69ffd
	call SetObjectFramesetPtr
	inc l
	ld a, SHOOTPHASE_PREKICK_JUMP
	ld [hli], a ; OBJ_VAR_1
	ld a, SHOOT_PRESHOOT_X_SPEED
	ld [hl], a ; OBJ_VAR_2

	; place Wario 16 pixels below Shoot
	ld l, OBJ_Y_POS
	ld a, [hli]
	add 16
	ld [wWarioYPos + 1], a
	ld a, [wWarioYPos + 0]
	adc 0
	ld [wWarioYPos + 0], a
	inc l
	ld a, [hli]
	ld [wWarioXPos + 1], a

	play_sfx SFX_FAT_WALK

	ld l, OBJ_SUBSTATE
	set OBJSUBFLAG_HDIR_F, [hl]
	; bug, this expects x position in register a
	; but the play_sfx macro cobbles it
	cp 123
	jr c, .nove_closer_to_net ; jump is always taken
; move farther from net
	res OBJSUBFLAG_VDIR_F, [hl]
	ret
.nove_closer_to_net
	set OBJSUBFLAG_VDIR_F, [hl]
	ret

.Main:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .HandleNormalState
	cp OBJSTATE_HIT_WARIO_DOWN_START
	jr z, .hit_wario_below
	cp OBJSTATE_ATTACKED_LEFT_START
	jr z, .jump_away_right
	cp OBJSTATE_ATTACKED_RIGHT_START
	jr z, .jump_away_left
	cp OBJSTATE_SPECIAL_3
	jr z, .interacted_with_ball_wario
	and $fe
	cp OBJSTATE_WOBBLE_LEFT_START ; aka OBJSTATE_WOBBLE_RIGHT_START
	jp z, .stepped_on
	cp OBJSTATE_VANISH_TOUCH
	jp z, .stepped_on
	xor a
	ld [hl], a
	ret

.HandleNormalState:
	ld a, [wCurObjVar1]
	jumptable
	dw .Standing         ; SHOOTPHASE_STANDING
	dw .JumpingUp        ; SHOOTPHASE_JUMPING_UP
	dw .JumpingDown      ; SHOOTPHASE_JUMPING_DOWN
	dw .BetweenJumps     ; SHOOTPHASE_BETWEEN_JUMPS
	dw .Turning          ; SHOOTPHASE_TURNING
	dw .PreKickJump      ; SHOOTPHASE_PREKICK_JUMP
	dw .PreKickAnimation ; SHOOTPHASE_PREKICK_ANIMATION
	dw .Kicking          ; SHOOTPHASE_KICKING
	dw .ScoreGoal        ; SHOOTPHASE_SCORE_GOAL
	dw .Won              ; SHOOTPHASE_WON

.set_standing
	ld hl, wCurObjSubState
	ld a, [hl]
	rlca
	jr c, .stand_facing_right
	res OBJSUBFLAG_VDIR_F, [hl]
	ld de, ShootFrameset_6a022
	jr .set_standing_frameset
.stand_facing_right
	set OBJSUBFLAG_VDIR_F, [hl]
	ld de, ShootFrameset_6a03a
.set_standing_frameset
	call SetObjectFramesetPtr
	ld a, SHOOT_IDLE_DURATION
	ld [hli], a ; OBJ_STATE_DURATION
	xor a ; SHOOTPHASE_STANDING
	ld [hli], a ; OBJ_VAR_1
	ld a, SHOOT_JUMP_X_SPEED
	ld [hl], a ; OBJ_VAR_2
	ret

.Standing:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz ; not finished yet
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset ShootFrameset_6a02b, ShootFrameset_6a043
.set_jumping_up
	call SetObjectFramesetPtr
	ld a, SHOOT_JUMP_UP_DURATION
	ld [hli], a ; OBJ_STATE_DURATION
	ld a, SHOOTPHASE_JUMPING_UP
	ld [hli], a ; OBJ_VAR_1
	inc l
	xor a
	ld [hl], a ; OBJ_VAR_3
	play_sfx SFX_SHOOT_JUMP
	ret

.JumpingUp:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .set_jumping_down
	ld bc, RiseYVel
	call ApplyObjYMovement
	jp .MoveLeftOrRight
.set_jumping_down
	inc l
	ld a, SHOOTPHASE_JUMPING_DOWN
	ld [hli], a ; OBJ_VAR_1
	inc l
	xor a
	ld [hl], a ; OBJ_VAR_3
	ret

.JumpingDown:
	ld bc, QuickFallYVel
	call ApplyObjYMovement
	call .MoveLeftOrRight

	; check centre collision
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
	jr nz, .grounded

	; check 16 pixels down collision
	ld hl, wCurObjYPos
	ld a, [hli]
	add 16
	ldh [hYPosLo], a
	ld a, [hli]
	adc 0
	ldh [hYPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .high_16_px

	; check 32 pixels down collision
	ld hl, wCurObjYPos
	ld a, [hli]
	add 32
	ldh [hYPosLo], a
	ld a, [hli]
	adc 0
	ldh [hYPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .high_32_px

	; check 48 pixels down collision
	ld hl, wCurObjYPos
	ld a, [hli]
	add 48
	ldh [hYPosLo], a
	ld a, [hli]
	adc 0
	ldh [hYPosHi], a
	call ProcessBlock_Landing
	and a
	jr nz, .high_48_px
	ret

.high_48_px
	ld a, [wCurObjSubState]
	rlca
	jr c, .high_48_px_right
	ld de, ShootFrameset_6a02e
	jp SetObjectFramesetPtr
.high_48_px_right
	ld de, ShootFrameset_6a046
	jp SetObjectFramesetPtr

.high_32_px
	ld a, [wCurObjSubState]
	rlca
	jr c, .high_32_px_right
	ld de, ShootFrameset_6a031
	jp SetObjectFramesetPtr
.high_32_px_right
	ld de, ShootFrameset_6a049
	jp SetObjectFramesetPtr

.high_16_px
	ld a, [wCurObjSubState]
	rlca
	jr c, .high_16_px_right
	ld de, ShootFrameset_6a034
	jp SetObjectFramesetPtr
.high_16_px_right
	ld de, ShootFrameset_6a04c
	jp SetObjectFramesetPtr

.grounded
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
.still_more_goals_needed
	ld hl, wCurObjSubState
	ld a, [wWarioXPos + 1]
	cp 192
	jr nc, .maybe_turn_around ; x >= 192
	; x < 192
	ld b, a
	ld a, [wCurObjXPos]
	cp b
	; carry set if Wario is left of Shoot
	bit OBJSUBFLAG_HDIR_F, [hl]
	jr nz, .facing_right
	; turn around if Wario to right
	jr c, .turn_around
	jr .maybe_turn_around
.facing_right
	; turn around if Wario to left
	jr nc, .turn_around
.maybe_turn_around
	; only turn around if wShootCanTurnAround == TRUE
	ld a, [wShootCanTurnAround]
	and a
	jr nz, .turn_around
	; else do a jump
	ld a, [hl] ; OBJ_SUBSTATE
	rlca
	ld_obj_frameset ShootFrameset_6a037, ShootFrameset_6a04f
	call SetObjectFramesetPtr

	; set jumping delay
	ld a, [wWarioGoals]
	and a
	jr nz, .at_least_1_goal
; 0 goals
	ld a, SHOOT_JUMP_DELAY_LONG
	jr .got_jump_delay
.at_least_1_goal
	ld a, SHOOT_JUMP_DELAY_SHORT
.got_jump_delay
	ld [hli], a ; OBJ_STATE_DURATION

	ld a, SHOOTPHASE_BETWEEN_JUMPS
	ld [hli], a ; OBJ_VAR_1
	ret

.turn_around
	ld a, [hl]
	rlca
	ld_obj_frameset ShootFrameset_69f35, ShootFrameset_69f40
	call SetObjectFramesetPtr
	ld a, SHOOT_TURN_AROUND_DURATION
	ld [hli], a ; OBJ_STATE_DURATION
	ld a, SHOOTPHASE_TURNING
	ld [hli], a ; OBJ_VAR_1
	xor a ; FALSE
	ld [wShootCanTurnAround], a
	ret

.BetweenJumps:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	jp .set_standing

.Turning:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp z, .set_standing
	ld a, [hl]
	cp SHOOT_TURN_AROUND_DURATION / 2
	ret nz
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	ret

.PreKickJump:
	; handle movement in x and y axis
	call .DoPreKickingXMovement
	ld bc, ShootData_54000
	call DoPreKickingJumpYMovement

	ld hl, wCurObjYPos
	ld a, [hl]
	ld b, 224
	cp b
	ret c ; y < 224

	; y >= 224
	ld de, ShootFrameset_6a000
	call SetObjectFramesetPtr
	inc l
	ld a, SHOOTPHASE_PREKICK_ANIMATION
	ld [hli], a ; OBJ_VAR_1

	; move down 16 pixels
	ld a, 16
	ld [hl], a ; OBJ_VAR_2
	call MoveObjectDownByVar2

	; snap Shoot and Wario to y = 240
	; and position Wario to (Shoot's x + 8)
	ld l, OBJ_Y_POS
	ld a, 240
	ld [hli], a
	ld [wWarioYPos + 1], a
	ld a, [hli]
	ld [wWarioYPos + 0], a
	ld a, [hli] ; OBJ_X_POS
	add 8
	ld [wWarioXPos + 1], a
	ret

.PreKickAnimation:
	; wait frame to finish
	ld hl, wCurObjFrameDuration
	ld a, [hli]
	and a
	ret nz

	; is it frame 6?
	ld a, [hli] ; OBJ_FRAMESET_OFFSET
	cp 6
	jr z, .frame_6
	; is it frame 10?
	cp 10
	ret nz
	inc l
	ld a, SHOOTPHASE_KICKING
	ld [hl], a ; OBJ_VAR_1
	ld de, ShootFrameset_69f54
	jp SetObjectFramesetPtr
.frame_6
	; move Wario 8 pixels right
	ld a, [wWarioXPos + 1]
	add 8
	ld [wWarioXPos + 1], a
	play_sfx SFX_HANG_GRAB
	ret

.Kicking:
	ld a, [wShootBallState]
	cp SHOOTBALL_WARIO_KICKED
	call z, .MoveWarioBallAfterKick
	ld hl, wCurObjFrameDuration
	ld a, [hli] ; OBJ_FRAME_DURATION
	and a
	ret nz
	ld a, [hli] ; OBJ_FRAMESET_OFFSET
	cp 4
	jr z, .shoot_wario
	cp 8
	ret nz
	inc l
	ld a, SHOOTPHASE_SCORE_GOAL
	ld [hl], a ; OBJ_VAR_1
	ld de, ShootFrameset_6a00b
	jp SetObjectFramesetPtr
.shoot_wario
	ld a, SHOOTBALL_WARIO_KICKED
	ld [wShootBallState], a
	xor a
	ld [wCurObjVar3], a
	ld a, $2 | (1 << 7)
	ld [wAutoMoveState], a
	play_sfx SFX_SHOOT_KICK_WARIO
	ret

.ScoreGoal:
	ld a, [wShootBallState]
	cp SHOOTBALL_WARIO_GOAL
	jp nz, .MoveWarioBallAfterKick
	ld hl, wShootGoals
	ld a, [hl]
	cp NUM_SHOOT_GOALS_NEEDED
	jr z, .no_goal_increment
	inc [hl]
	ld b, [hl]
.no_goal_increment
	ld a, $1 | (1 << 7)
	ld [wAutoMoveState], a
	play_sfx SFX_SHOOT_GOAL
	ld a, TRUE
	ld [wShootCanTurnAround], a
	ld hl, wCurObjSubState
	res OBJSUBFLAG_VDIR_F, [hl]
	ld a, b
	cp NUM_SHOOT_GOALS_NEEDED
	jp nz, .still_more_goals_needed
	; reached target num of goals
	ld a, SHOOTPHASE_WON
	ld [wCurObjVar1], a
	ret

.Won:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.MoveWarioBallAfterKick:
	ld a, [wWarioXPos + 1]
	cp 237
	jr nc, .ball_wario_inside_net
; move Wario right
	ld bc, ShootData_54010
	call ApplyYOffsetOnKickedWarioBall
	ld b, 3
	jp MoveWarioRight
.ball_wario_inside_net
; move Wario down to the ground
	ld a, [wWarioYPos + 1]
	cp 240
	jr nc, .set_wario_ball_goal_state
	ld b, 3
	jp MoveWarioDown
.set_wario_ball_goal_state
; if on ground, set goal state
	ld a, SHOOTBALL_WARIO_GOAL
	ld [wShootBallState], a
	ret

.DoPreKickingXMovement:
	ld a, [wCurObjVar2]
	ld b, a
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .move_with_wario_right
; move with Wario left
	call MoveObjectLeftByVar2
	jp MoveWarioLeft
.move_with_wario_right
	call MoveObjectRightByVar2
	jp MoveWarioRight

.MoveLeftOrRight:
	ld a, [wCurObjSubState]
	rlca
	rlca
	ld a, [wCurObjXPos]
	jr c, .moving_right ; OBJSUBFLAG_VDIR_F
; moving left
	cp 27
	jp nc, MoveObjectLeftByVar2
	play_sfx SFX_BIG_OCTO_1
	ld hl, wCurObjSubState
	set OBJSUBFLAG_VDIR_F, [hl]
	bit OBJSUBFLAG_HDIR_F, [hl]
	ret nz
	jr .set_can_turn_around
.moving_right
	cp 219
	jp c, MoveObjectRightByVar2
	play_sfx SFX_BIG_OCTO_1
	ld hl, wCurObjSubState
	res OBJSUBFLAG_VDIR_F, [hl]
	bit OBJSUBFLAG_HDIR_F, [hl]
	ret z
.set_can_turn_around
	ld a, TRUE
	ld [wShootCanTurnAround], a
	ret

.stepped_on
	ld de, ShootFrameset_69f5d
	call SetObjectFramesetPtr
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.BallForm)
	ld [hld], a
	ld a, LOW(.BallForm)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, OBJ_INTERACTION_TOUCH
	ld [hli], a
	ld a, -18
	ld [hli], a ; OBJ_COLLBOX_TOP
	ld a, 0
	ld [hl], a ; OBJ_COLLBOX_BOTTOM
.BallForm:
	ld hl, wCurObjFlags
	ld a, [wCurObjXPos]
	cp 219
	jr nc, .at_net
	set OBJFLAG_GRABBED_F, [hl]
	jr .dispatch_ball_state
.at_net
	res OBJFLAG_GRABBED_F, [hl]
.dispatch_ball_state
	ld a, [wCurObjState]
	jumptable
	dw .Default
	dw .Land
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .AttackedLeftStart
	dw .AttackedRightStart
	dw .Default
	dw .Default
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .VanishTouch
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .StandingFallStart
	dw .StandingFallStart
	dw .Default
	dw .State14
	dw .State15
	dw .StunLeftStart
	dw .StunRightStart
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_Bounce1LeftStart
	dw ObjState_Bounce1RightStart
	dw ObjState_Bounce2LeftStart
	dw ObjState_Bounce2RightStart
	dw ObjState_Bounce3LeftStart
	dw ObjState_Bounce3RightStart
	dw ObjState_FallLeftStart
	dw ObjState_FallRightStart
	dw .State28
	dw .State28
	dw .Default
	dw .Default
	dw .Default
	dw .Special1
	dw .Default
	dw .Default
	dw ObjState_Fall
	dw .Walk
	dw ObjState_BumpLeft
	dw ObjState_BumpRight
	dw .AttackedLeft
	dw .AttackedLeft
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw ObjState_Bounce2Right
	dw ObjState_Bounce2Left
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_StandingFall
	dw ObjState_Drop
	dw .Default
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .StunLeft
	dw .StunRight
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_Bounce1Left
	dw ObjState_Bounce1Right
	dw ObjState_Bounce2Left
	dw ObjState_Bounce2Right
	dw ObjState_Bounce3Left
	dw ObjState_Bounce3Right
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default

.State28:
	ld a, OBJSTATE_SPECIAL_1
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld de, ShootFrameset_69f5d
	jp SetObjectFramesetPtr

.return_to_regular_form
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_ATTACKED_RIGHT_START
	ld [hld], a
	res 7, [hl]
	ld l, OBJ_INTERACTION_TYPE
	ld a, OBJ_INTERACTION_SHOOT | HEAVY_OBJ
	ld [hli], a
	ld a, -32
	ld [hli], a
	ld a, -8
	ld [hl], a
	ret

.Default:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ret

.Land:
	ld hl, wCurObjState
	ld a, OBJSTATE_WALK
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	dec l
	ld a, [wWarioGoals]
	cp 2
	jr nc, .at_least_2_goals
	xor a ; treated as $100 (SHOOT_REGULAR_BALL_DURATION)
	jr .got_ball_form_duration
.at_least_2_goals
	ld a, SHOOT_LAST_GOAL_BALL_DURATION
.got_ball_form_duration
	ld [hl], a ; OBJ_VAR_1
	ld de, ShootFrameset_69f5d
	call SetObjectFramesetPtr
.Walk:
	ld a, [wCurObjVar3]
	cp $22
	play_sfx z, SFX_HEAVY_STEP
	ld hl, wCurObjVar1
	dec [hl]
	jr z, .return_to_regular_form
	ld a, [hl]
	cp $12
	jr nz, .check_whirr_start
	ld de, ShootFrameset_69f93
	call SetObjectFramesetPtr
	play_sfx SFX_0B7
	jr .bounce
.check_whirr_start
	jr c, .bounce
	cp $64
	jr nz, .check_whirr_window
	ld de, ShootFrameset_69f66
	call SetObjectFramesetPtr
	jr .whirr
.check_whirr_window
	jr nc, .bounce
.whirr
	ld a, [wGlobalCounter]
	and %1111
	play_sfx z, SFX_WHIRR
.bounce
	ld bc, ShootData_60e40
	jp ApplyObjYMovement_Loop

.VanishTouch:
	play_sfx SFX_STOMP
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr nc, .BumpLeftStart
	jr .BumpRightStart
.BumpLeftStart:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_LEFT
	jr .set_wobble
.BumpRightStart:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_RIGHT
.set_wobble
	ld [hld], a ; OBJ_STATE
	ld de, ShootFrameset_69f5d
	call SetObjectFramesetPtr
	ld a, 4
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a ; OBJ_VAR_2
	xor a
	ld [hli], a
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STANDING_FALL
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL_LEFT
	ld [hld], a
	jr .set_fall
.State15:
	ld hl, wCurObjState
	ld a, OBJSTATE_FALL_RIGHT
	ld [hld], a
.set_fall
	ld l, OBJ_VAR_2
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ret

.StunLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_LEFT
	ld [hld], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_RIGHT
	ld [hld], a
	ret

.StunLeft:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.StunRight:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.AttackedLeftStart:
	ld a, OBJSTATE_ATTACKED_LEFT
	ld de, Frameset_69f9f
	ld hl, wCurObjSubState
	set OBJSUBFLAG_VDIR_F, [hl]
.set_attacked
	inc l
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld a, [wCurObjYPos]
	cp 216
	jr c, .above_floor
	ld a, $02
	ld [hld], a
	jp SetObjectFramesetPtr
.above_floor
	ld a, $04
	ld [hld], a
	jp SetObjectFramesetPtr

.AttackedRightStart:
	ld a, OBJSTATE_ATTACKED_RIGHT
	ld de, Frameset_69fa4
	ld hl, wCurObjSubState
	res OBJSUBFLAG_VDIR_F, [hl]
	jr .set_attacked

.AttackedLeft:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wShootCanTurnAround]
	and a
	jr z, .move
	xor a ; FALSE
	ld [wShootCanTurnAround], a
	ld de, ShootFrameset_69f5d
	call SetObjectFramesetPtr
.move
	call .MoveBetweenWalls
	ld a, [wCurObjVar2]
	cp $04
	jr z, .high_arc
	ld bc, ShootData_60e20
	jr .apply_arc
.high_arc
	ld bc, ShootData_60e70
.apply_arc
	call ApplyObjYMovement
	ld hl, wCurObjYPos
	ld a, [hl]
	ld b, 240
	cp b
	ret c ; y < 240
	; y >= 240

	; snap Shoot to y = 240
	ld [hl], b

	ld a, [wShootBallState]
	cp $04
	jr nz, .landed
	ld a, [wWarioGoals]
	cp NUM_WARIO_GOALS_NEEDED
	jp z, .set_defeated
	ld a, $01
	ld [wShootBallState], a
	jp .return_to_regular_form
.landed
	ld l, OBJ_SUBSTATE
	bit OBJSUBFLAG_VDIR_F, [hl]
	jr nz, .landed_moving_right
	inc l
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ret
.landed_moving_right
	ld a, [wCurObjXPos]
	cp 219
	jr nc, .wario_scores
	inc l
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [hl], a ; OBJ_STATE
	ret
.wario_scores
	inc l
	ld a, OBJSTATE_SPECIAL_1
	ld [hl], a ; OBJ_STATE

	ld a, $02
	ld [wShootBallState], a

	play_sfx SFX_SHOOT_GOAL

	ld hl, wWarioGoals
	ld a, [hl]
	cp NUM_WARIO_GOALS_NEEDED
	jr z, .set_goal_frameset
	inc [hl]
	ld a, [hl]
	cp NUM_WARIO_GOALS_NEEDED
	jr nz, .set_goal_frameset
	stop_music2
.set_goal_frameset
	ld de, ShootFrameset_69f9a
	jp SetObjectFramesetPtr

.MoveBetweenWalls:
	ld a, [wCurObjSubState]
	rlca
	rlca
	jr c, .ball_moving_right
	ld a, [wCurObjXPos]
	cp 27
	jp nc, MoveObjectLeftByVar2
	ld hl, wCurObjSubState
	set OBJSUBFLAG_VDIR_F, [hl]
	jr .hit_wall
.ball_moving_right
	ld a, [wCurObjYPos]
	cp 208
	jr nc, .into_net
	ld a, [wCurObjXPos]
	cp 219
	jp c, MoveObjectRightByVar2
	ld hl, wCurObjSubState
	res OBJSUBFLAG_VDIR_F, [hl]
.hit_wall
	ld a, TRUE
	ld [wShootCanTurnAround], a
	play_sfx SFX_OBJECT_HIT_WALL
	ret
.into_net
	ld a, [wCurObjXPos]
	cp 243
	jp c, MoveObjectRightByVar2
	ret

.Special1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld a, [wShootBallState]
	cp $04
	ret nz
	ld de, Frameset_69fa4
	call SetObjectFramesetPtr
	ld l, OBJ_STATE
	ld a, OBJSTATE_ATTACKED_RIGHT
	ld [hld], a
	res OBJSUBFLAG_VDIR_F, [hl] ; OBJ_SUBSTATE
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, [wWarioGoals]
	cp NUM_WARIO_GOALS_NEEDED
	jr nz, .more_goals_needed
	ld a, $01
	jr .set_speed
.more_goals_needed
	ld a, $03
.set_speed
	ld [hl], a ; OBJ_VAR_2
	ret

.set_defeated
	ld de, ShootFrameset_69f8a
	call SetObjectFramesetPtr
	ld a, SHOOT_DEFEAT_RISE_DURATION
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatRise)
	ld [hld], a
	ld a, LOW(.DefeatRise)
	ld [hld], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_GRABBED_LEFT
	ld [hld], a
	ld a, [hl] ; OBJ_SUBSTATE
	and OBJSUBFLAG_UNINITIALISED | OBJSUBFLAG_VDIR | OBJSUBFLAG_HDIR
	ld [hld], a
	xor a
	ld [hl], a ; OBJ_VAR_3
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld hl, wCurObjUnk02
	ld e, $09
	farcall SetObjectMapEntryAndSpawn
	play_sfx SFX_BOSS_DEFEATED
	ret

.DefeatRise:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .start_suspend
	ld bc, ShootData_60e90
	jp ApplyObjYMovement
.start_suspend
	xor a
	ld [wCurObjVar3], a
	ld de, ShootFrameset_69f6f
	call SetObjectFramesetPtr
	ld a, SHOOT_DEFEAT_SUSPENDED_DURATION
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatSuspendAndFall)
	ld [hld], a
	ld a, LOW(.DefeatSuspendAndFall)
	ld [hld], a
	ret

.DefeatSuspendAndFall:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .fall
; still supsended in air
	dec [hl]
	ret nz
	play_sfx SFX_BOSS_DEFEAT_FALL
	ret
.fall
	ld bc, ShootData_60ea0
	jp ApplyObjYMovement

GKTortoisePlatformFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.MoveLeft)
	ld [hld], a
	ld a, LOW(.MoveLeft)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 5
	ld [hld], a
	ld a, -6
	ld [hld], a
	ld de, ShootFrameset_69fdc
	call SetObjectFramesetPtr
	ld a, 32
	ld [hli], a
	ld a, 60
	ld [hli], a ; OBJ_VAR_1

	; move 64 pixels right and 16 pixels down
	ld a, 64
	ld [hl], a ; OBJ_VAR_2
	call MoveObjectRightByVar2
	ld a, 16
	ld [wCurObjVar2], a
	jp MoveObjectDownByVar2

.MoveLeft:
	call SetOneWayPlatformAction
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .wait_set_move_up_and_down
	dec [hl]
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	jp MoveObjectLeft
.wait_set_move_up_and_down
	inc l
	dec [hl] ; OBJ_VAR_1
	ret nz
	dec l
	ld a, 176
	ld [hl], a ; OBJ_STATE_DURATION
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.MoveUpAndDown)
	ld [hld], a
	ld a, LOW(.MoveUpAndDown)
	ld [hld], a
	ret

.MoveUpAndDown:
	call SetOneWayPlatformAction
	ld hl, wCurObjVar1
	ld a, [hld]
	and a
	jr z, .moving_up
	inc [hl] ; OBJ_STATE_DURATION
	ld a, [hli]
	cp 176
	jr z, .set_move_up
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectDown
	res OBJFLAG_STEPPED_F, [hl]
	ld b, 1
	call MoveWarioDown
	call HandleDownwardsFloorTransition
	jp MoveObjectDown
.set_move_up
	xor a
	ld [hl], a ; OBJ_VAR_1
	ld [wCurObjState], a
	ret

.moving_up
	dec [hl] ; OBJ_STATE_DURATION
	jr z, .set_move_down
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	jp z, MoveObjectUp
	res OBJFLAG_STEPPED_F, [hl]
	ld b, 1
	call MoveWarioUp
	call HandleUpwardsFloorTransition
	jp MoveObjectUp
.set_move_down
	inc l
	ld a, $01
	ld [hl], a ; OBJ_VAR_1
	ret

GKTortoiseFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, 5
	ld [hld], a
	ld a, -6
	ld [hld], a
	ld de, ShootFrameset_69fed
	call SetObjectFramesetPtr
	inc l
	xor a ; GKTORTOISEPHASE_0
	ld [hli], a ; OBJ_VAR_1

	; move 64 pixels right and 16 pixels down
	ld a, 64
	ld [hl], a
	call MoveObjectRightByVar2
	ld a, 16
	ld [wCurObjVar2], a
	jp MoveObjectDownByVar2

.set_ducking
	ld de, ShootFrameset_6a017
	call SetObjectFramesetPtr
	inc l
	ld a, GKTORTOISEPHASE_DUCKING
	ld [hl], a ; OBJ_VAR_1
	ld a, -10
	ld [wCurObjCollBoxTop], a
	ret

.Main:
	ld a, [wTransformation]
	and a
	jr z, .wario_not_transformed
	ld a, no_actions_for 1
	ld [wCurObjAction], a
.wario_not_transformed
	; GK Tortoise will automatically duck
	; if Shoot kicks Wario towards net
	ld a, [wShootBallState]
	cp SHOOTBALL_WARIO_KICKED
	jr nz, .no_kicked_wario
	; is it already ducking?
	ld a, [wCurObjVar1]
	cp GKTORTOISEPHASE_DUCKING
	jr nz, .set_ducking
.no_kicked_wario
	ld a, [wCurObjVar1]
	jumptable
	dw .Idle ; GKTORTOISEPHASE_0
	dw .Guard ; GKTORTOISEPHASE_1
	dw .Phase2 ; GKTORTOISEPHASE_2
	dw .Phase3 ; GKTORTOISEPHASE_3
	dw .KickWarioBall ; GKTORTOISEPHASE_4
	dw .CatchWarioBall ; GKTORTOISEPHASE_5
	dw .ThrowShootBall ; GKTORTOISEPHASE_6
	dw .Ducking ; GKTORTOISEPHASE_DUCKING
	dw .Defeated ; GKTORTOISEPHASE_8
	dw .CatchShootBall ; GKTORTOISEPHASE_9

.Defeated:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	xor a
	ld [wCurObjFlags], a
	ld hl, wCurObjUnk02
	ld e, $08
	farcall SetObjectMapEntryAndSpawn
	ld a, BOSS_DEFEATED
	ld [wBossState], a
	call UpdateLevelMusic
	xor a
	ld [wIsBossBattle], a
	ret

.Ducking:
	ld hl, wCurObjFramesetOffset
	ld a, [hld]
	cp 10
	jr z, .duck_delay
	cp 6
	ret c ; < 6
	; add delay if Wario still didn't enter net
	ld a, [wShootBallState]
	cp SHOOTBALL_WARIO_GOAL
	ret z
	ld a, 16
	ld [hl], a ; OBJ_FRAME_DURATION
	ret
.duck_delay
	ld a, [hl] ; OBJ_FRAME_DURATION
	and a
	ret nz
	jp .start_throw_out

.Idle:
	ld a, [wShootBallState]
	and a
	jp nz, .set_guard
.Guard:
	ld a, [wShootBallState]
	cp $02
	jr z, .start_kick_out
	ld hl, wCurObjAction
	xor a
	ld [hld], a
	ld a, [hl] ; OBJ_STATE
	and a
	ret z
	cp OBJSTATE_SPECIAL_3
	jr z, .start_catch_wario
	and $fe
	cp OBJSTATE_WOBBLE_LEFT_START ; or OBJSTATE_WOBBLE_RIGHT_START
	jr nz, .knocked_down
	xor a
	ld [hl], a ; OBJ_STATE
	ld de, ShootFrameset_69ff2
	call SetObjectFramesetPtr
	inc l
	ld a, GKTORTOISEPHASE_9
	ld [hl], a ; OBJ_VAR_1
	ld a, $03
	ld [wShootBallState], a
	play_sfx SFX_FAT_WALK
	call .FindShoot

.set_shoot_pos_11x_16y
	call .GetShootPosPtr

	; set Shoot.y = GK.y - 16
	ld de, wCurObjYPos
	ld a, [de]
	sub 16
	ld [hli], a
	inc e
	ld a, [de]
	sbc 0
	ld [hli], a

	; set Shoot.x = GK.x - 11
	inc e
	ld a, [de]
	sub 11
	ld [hli], a
	inc e
	ld a, [de]
	sbc 0
	ld [hli], a
	ret

.knocked_down
	xor a
	ld [hl], a
	ld de, ShootFrameset_69fcf
	call SetObjectFramesetPtr
	inc l
	ld a, $02
	ld [hl], a
	ld a, -10
	ld [wCurObjCollBoxTop], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret
.start_kick_out
	ld a, $03
	ld [wShootBallState], a
	ld de, ShootFrameset_69fba
	call SetObjectFramesetPtr
	inc l
	ld a, $04
	ld [hl], a
	ret

.start_catch_wario
	xor a
	ld [hl], a ; OBJ_STATE
	ld de, ShootFrameset_69ff2
	call SetObjectFramesetPtr
	inc l
	ld a, GKTORTOISEPHASE_5
	ld [hl], a ; OBJ_VAR_1
	play_sfx SFX_FAT_WALK
.set_wario_pos_11x_16y
	; set Wario.y = GK.y - 16
	ld l, OBJ_Y_POS
	ld a, [hli]
	sub 16
	ld [wWarioYPos + 1], a
	ld a, [hli]
	sbc 0
	ld [wWarioYPos + 0], a

	; set Wario.x = GK.x - 11
	ld a, [hli]
	sub 11
	ld [wWarioXPos + 1], a
	ld a, [hli]
	sbc 0
	ld [wWarioXPos + 0], a
	ret

.start_throw_out
	ld a, $07
	ld [wShootBallState], a
	ld de, ShootFrameset_69fba
	call SetObjectFramesetPtr
	inc l
	ld a, $06
	ld [hl], a
	ld a, -20
	ld [wCurObjCollBoxTop], a
	play_sfx SFX_FAT_WALK
	ret

.Phase2:
	ld a, [wShootBallState]
	cp $02
	jr z, .wait_get_up
	ld hl, wCurObjState
	ld a, [hl]
	and $fe
	jp nz, .knocked_down
.wait_get_up
	ld hl, wCurObjFramesetOffset
	ld a, [hld]
	cp $0c
	ret nz
	ld a, [hld]
	and a
	ret nz
.set_guard
	ld de, ShootFrameset_69fa9
	call SetObjectFramesetPtr
	inc l
	ld a, GKTORTOISEPHASE_1
	ld [hl], a ; OBJ_VAR_1
	xor a
	ld [wCurObjState], a
	ld a, -20
	ld [wCurObjCollBoxTop], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret

.Phase3:
	ld hl, wCurObjFlags
	res 3, [hl]
	ld l, OBJ_STATE
	ld a, [hl]
	and $fe
	jp nz, .knocked_down
	ld l, OBJ_FRAMESET_OFFSET
	ld a, [hld]
	cp $06
	ret nz
	ld a, [hld]
	and a
	ret nz
	jr .set_guard

.CatchWarioBall:
	ld hl, wCurObjFrameDuration
	ld a, [hli]
	and a
	ret nz
	; end of frame
	ld a, [hl]
	cp 2
	jr z, .set_wario_pos_22y
	cp 4
	jp z, .set_wario_pos_11x_16y
	cp 6
	jr z, .throw_wario
	cp 10
	ret nz
	jr .set_guard

.set_wario_pos_22y
	; set Wario.y = GK.y - 16
	ld l, OBJ_Y_POS
	ld a, [hli]
	sub 22
	ld [wWarioYPos + 1], a
	ld a, [hli]
	sbc 0
	ld [wWarioYPos + 0], a

	; set Wario.x = GK.x
	ld a, [hli]
	ld [wWarioXPos + 1], a
	ld a, [hli]
	ld [wWarioXPos + 0], a
	ret

.throw_wario
	xor a
	ld [wAutoMoveState], a
	ld a, no_actions_for 15
	ld [wCurObjAction], a
	play_sfx SFX_ENEMY_THROW
	ret

.KickWarioBall:
	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_FRAME_DURATION
	ld a, [hli]
	and a
	ret nz
	ld a, [hl]
	cp $06
	jr z, .place_shoot_in_front
	cp $08
	jr z, .place_shoot_above
	cp $0e
	jr z, .place_shoot_held
	cp $10
	jr z, .kick_shoot_ball
	cp $14
	ret nz
	ld a, [wWarioGoals]
	cp NUM_WARIO_GOALS_NEEDED
	jp nz, .set_guard
	ld de, ShootFrameset_6a00e
	call SetObjectFramesetPtr
	ld a, 180
	ld [hli], a ; OBJ_STATE_DURATION
	ld a, GKTORTOISEPHASE_8
	ld [hl], a ; OBJ_VAR_1
	ld a, -10
	ld [wCurObjCollBoxTop], a
	ret

.kick_shoot_ball
	ld a, $04
	ld [wShootBallState], a
	play_sfx SFX_ENEMY_THROW
	ret

.place_shoot_in_front
	play_sfx SFX_FAT_WALK
	call .GetShootPosPtr
	ld de, wCurObjYPos
	ld a, [de]
	ld [hli], a
	inc e
	ld a, [de]
	ld [hli], a
	inc e
	ld a, [de]
	add $0c
	ld [hli], a
	inc e
	ld a, [de]
	adc $00
	ld [hli], a
	ret
.place_shoot_above
	call .GetShootPosPtr
	ld de, wCurObjYPos
	ld a, [de]
	sub $16
	ld [hli], a
	inc e
	ld a, [de]
	sbc $00
	ld [hli], a
	inc e
	ld a, [de]
	ld [hli], a
	inc e
	ld a, [de]
	ld [hli], a
	ret
.place_shoot_held
	call .GetShootPosPtr
	ld de, wCurObjYPos
	ld a, [de]
	sub $10
	ld [hli], a
	inc e
	ld a, [de]
	sbc $00
	ld [hli], a
	inc e
	ld a, [de]
	sub $0b
	ld [hli], a
	inc e
	ld a, [de]
	sbc $00
	ld [hli], a
	ret

.CatchShootBall:
	ld hl, wCurObjFrameDuration
	ld a, [hli]
	and a
	ret nz
	; end of a frame
	ld a, [hl] ; OBJ_FRAMESET_OFFSET
	cp 2
	jr z, .set_shoot_pos_22y
	cp 4
	jp z, .set_shoot_pos_11x_16y
	cp 6
	jr z, .throw_shoot
	cp 10
	ret nz
	jp .set_guard

.set_shoot_pos_22y
	call .GetShootPosPtr

	; set Shoot.y = GK.y - 22
	ld de, wCurObjYPos
	ld a, [de]
	sub 22
	ld [hli], a
	inc e
	ld a, [de]
	sbc 0
	ld [hli], a

	; set Shoot.x = GK.x
	inc e
	ld a, [de]
	ld [hli], a
	inc e
	ld a, [de]
	ld [hli], a
	ret

.throw_shoot
	ld a, $04
	ld [wShootBallState], a
	play_sfx SFX_ENEMY_THROW
	ret

.GetShootPosPtr:
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop_find_shoot_obj_1
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp SHOOT
	jr nz, .next_obj_1
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_FLAGS
	rra
	jr c, .got_obj_1
.next_obj_1
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop_find_shoot_obj_1
.got_obj_1
	inc l
	inc l
	ret

.FindShoot:
	ld a, LOW(wObj1)
	ld b, LOW(wObj1)
	ld h, HIGH(wObj1)
.loop_find_shoot_obj_2
	ld l, OBJ_ID
	add l
	ld l, a
	ld a, [hl] ; OBJ_ID
	cp SHOOT
	jr nz, .next_obj_2
	ld a, l
	sub OBJ_ID - OBJ_FLAGS
	ld l, a
	ld a, [hl] ; OBJ_FLAGS
	rra
	jr c, .got_obj_2
.next_obj_2
	ld a, b
	cp LOW(wObj8)
	ret z
	add OBJ_STRUCT_LENGTH
	ld b, a
	jr .loop_find_shoot_obj_2
.got_obj_2
	ld a, l
	add OBJ_ACTION - OBJ_FLAGS
	ld l, a
	ld a, no_actions_for 8
	ld [hl], a
	ret

.ThrowShootBall:
	ld hl, wCurObjFrameDuration
	ld a, [hli]
	and a
	ret nz
	ld a, [hl]
	cp $06
	jr z, .place_wario_in_front
	cp $08
	jr z, .place_wario_above
	cp $0e
	jr z, .place_wario_held
	cp $10
	jr z, .release_wario_ball
	cp $14
	ret nz
	jp .set_guard
.release_wario_ball
	ld a, $01
	ld [wShootBallState], a
	xor a
	ld [wAutoMoveState], a
	play_sfx SFX_ENEMY_THROW
	ret
.place_wario_in_front
	ld hl, wCurObjYPos
	ld a, [hli]
	ld [wWarioYPos + 1], a
	ld a, [hli]
	ld [wWarioYPos + 0], a
	ld a, [hli]
	add $0c
	ld [wWarioXPos + 1], a
	ld a, [hli]
	adc $00
	ld [wWarioXPos + 0], a
	ret
.place_wario_above
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $16
	ld [wWarioYPos + 1], a
	ld a, [hli]
	sbc $00
	ld [wWarioYPos + 0], a
	ld a, [hli]
	ld [wWarioXPos + 1], a
	ld a, [hli]
	ld [wWarioXPos + 0], a
	ret
.place_wario_held
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $10
	ld [wWarioYPos + 1], a
	ld a, [hli]
	sbc $00
	ld [wWarioYPos + 0], a
	ld a, [hli]
	sub $0b
	ld [wWarioXPos + 1], a
	ld a, [hli]
	sbc $00
	ld [wWarioXPos + 0], a
	ret

; input:
; - bc = movement data
DoPreKickingJumpYMovement:
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]

	; if already past end of list, get last valid offset
	cp $80
	jr nz, .valid_index
	dec c
	ld a, [bc]
	jr .got_offset
.valid_index
	inc [hl] ; OBJ_VAR_3
.got_offset
	ld b, a
	ld l, OBJ_Y_POS
	cp -128
	ld c, [hl] ; OBJ_Y_POS
	jr nc, .moving_up

; moving down
	add c
	ld [hli], a
	jr nc, .move_wario_down
	inc [hl]
.move_wario_down
	call MoveWarioDown
	jp HandleDownwardsFloorTransition

.moving_up
	add c
	ld [hli], a
	jr c, .move_wario_up
	dec [hl]
.move_wario_up
	xor a
	sub b
	ld b, a ; b = -b
	call MoveWarioUp
	jp HandleUpwardsFloorTransition

ApplyYOffsetOnKickedWarioBall:
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .next_offset
	dec c
	ld a, [bc]
	jr .got_offset
.next_offset
	inc [hl]
.got_offset
	ld b, a
	call MoveWarioDown
	jp HandleDownwardsFloorTransition

; unreferenced
UnreferencedMoveWarioUpByNegB:
	xor a
	sub b
	ld b, a
	call MoveWarioUp
	jp HandleUpwardsFloorTransition

ShootGoalCounterFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.UpdateScore)
	ld [hld], a
	ld a, LOW(.UpdateScore)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, $3c
	ld [wCurObjFrame], a

	; move up $58 pixels
	ld a, $58
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.UpdateScore:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $7f
	ld [wCurObjFrameDuration], a
	ld a, [wShootGoals]
	cp 1
	jr z, .one_goal
	cp 2
	jr z, .two_goals
	cp 3
	jr z, .three_goals
	ret
.one_goal
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ret
.two_goals
	ld a, $3d
	ld [wCurObjFrame], a
	ret
.three_goals
	ld a, $3e
	ld [wCurObjFrame], a
	xor a
	ld [wBossState], a
	ret

WarioGoalCounterFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.UpdateScore)
	ld [hld], a
	ld a, LOW(.UpdateScore)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJSUBFLAG_NO_DESPAWN_F, [hl]
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, $3c
	ld [wCurObjFrame], a

	; move up $58 pixels
	ld a, $58
	ld [wCurObjVar2], a
	jp MoveObjectUpByVar2

.UpdateScore:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, $7f
	ld [wCurObjFrameDuration], a
	ld a, [wWarioGoals]
	cp 1
	jr z, .one_goal
	cp 2
	jr z, .two_goals
	cp 3
	jr z, .three_goals
	ret
.one_goal
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ret
.two_goals
	ld a, $3d
	ld [wCurObjFrame], a
	ret
.three_goals
	ld a, $3e
	ld [wCurObjFrame], a
	ret
