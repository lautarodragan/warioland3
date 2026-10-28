HiddenFigureFunc:
	ld a, TRUE
	ld [wIsBossBattle], a

	xor a
	ld hl, wHiddenFigureAttack
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, wHiddenFigureRemainingHits
	ld a, $04
	ld [hli], a
	xor a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $02
	ld [hli], a

	ld hl, wCurObjFlags
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Intro)
	ld [hld], a
	ld a, LOW(.Intro)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld de, HiddenFigureFrameset_6a06c
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ld bc, ObjParams_HiddenFigureFace
	call CreateObjectAtRelativePos
	ld bc, ObjParams_HiddenFigureLeftHand
	call CreateObjectAtRelativePos
	ld bc, ObjParams_HiddenFigureRightHand
	jp CreateObjectAtRelativePos

.Intro:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hli], a
	ld a, $00
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld a, BOSS_HIDDEN_FIGURE
	ld [wBossState], a
	call UpdateLevelMusic
	ret

.Main:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjVar1]
	jumptable
	dw .Idle
	dw .ChooseAttack
	dw .StartLeftSwipe
	dw .LeftSwipe
	dw .StartRightSwipe
	dw .RightSwipe
	dw .StartGrab
	dw .Grab
	dw .HoldCaughtWario
	dw .WaitLeftHandStunned
	dw .WaitRightHandStunned

.HoldCaughtWario:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	xor a
	ld [wAutoMoveState], a
	ret

.Idle:
	ld hl, wCurObjStateDuration
	ld a, [wHiddenFigureSwipeInterrupted]
	and a
	jr nz, .end_idle
	dec [hl]
	ret nz
.end_idle
	inc l
	ld a, $01
	ld [hli], a
	ret

.ChooseAttack:
	ld hl, wCurObjStateDuration
	ld a, $01
	ld [hli], a
	ld a, [wHiddenFigureSwipeCount]
	cp $02
	jr nc, .choose_grab
	ld e, a
	ld a, [wHiddenFigureSwipeInterrupted]
	and a
	jr z, .choose_swipe
.choose_grab
	xor a
	ld [wHiddenFigureSwipeInterrupted], a
	ld [wHiddenFigureSwipeCount], a
	ld b, $06
	jr .set_phase
.choose_swipe
	ld a, [wWarioScreenXPos]
	cp $58
	jr nc, .swipe_right
	ld b, $02
	jr .count_swipe
.swipe_right
	ld b, $04
.count_swipe
	inc e
	ld a, e
	ld [wHiddenFigureSwipeCount], a
.set_phase
	ld [hl], b
	ld hl, wHiddenFigureAttackCounter
	inc [hl]
	ret

.StartGrab:
	ld a, [wHiddenFigureLeftHandSlamming]
	and a
	ret nz
	ld a, [wHiddenFigureRightHandSlamming]
	and a
	ret nz
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $80
	ld [hli], a
	ld a, $07
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
	ld b, $03
	ld a, [wHiddenFigureRemainingHits]
	cp $04
	jr z, .set_grab_attack
	cp $03
	jr nc, .random_grab
	ld a, [wWarioScreenXPos]
	cp $30
	jr c, .random_grab
	cp $80
	jr nc, .random_grab
	ld a, [wHiddenFigureAttackCounter]
	rra
	jr c, .random_grab
	ld a, $60
	ld [wCurObjStateDuration], a
	ld b, $08
	jr .set_grab_attack
.random_grab
	ldh a, [rDIV]
	rra
	jr c, .set_grab_attack
	ld b, $07
.set_grab_attack
	ld a, b
	ld [wHiddenFigureAttack], a
	ret

.Grab:
	ld hl, wHiddenFigureBodyGrabResult
	ld a, [hl]
	and a
	jr z, .shake
	cp $80
	jr z, .caught_wario
	dec [hl]
	ret
.caught_wario
	ld hl, wCurObjStateDuration
	ld a, $a0
	ld [hli], a
	ld a, $08
	ld [hl], a
	ret
.shake
	ld a, [wHiddenFigureAttack]
	cp $07
	jr z, .shake_grab2
	cp $08
	jr z, .shake_grab3
	ld bc, HiddenFigureGrab1SCYShake
	jr .apply_shake
.shake_grab2
	ld bc, HiddenFigureGrab2SCYShake
	jr .apply_shake
.shake_grab3
	ld bc, HiddenFigureGrab3SCYShake
.apply_shake
	call ApplyHiddenFigureSCYShakeTable
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hli], a
	ld a, $00
	ld [hl], a
	ld a, $00
	ld [wHiddenFigureAttack], a
	ld a, [wHiddenFigureRemainingHits]
	dec a
	ret nz
	ld hl, wHiddenFigureGrabsLeft
	dec [hl]
	jr z, .reset_grabs
	ld a, $06
	ld [wCurObjVar1], a
	ld hl, wHiddenFigureAttackCounter
	inc [hl]
	ret
.reset_grabs
	ld a, $02
	ld [hl], a
	ret

.StartLeftSwipe:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $80
	ld [hli], a
	ld a, $03
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
	ld a, $01
	ld [wHiddenFigureAttack], a
	ret

.LeftSwipe:
	ld bc, HiddenFigureSwipeSCYShake
	call ApplyHiddenFigureSCYShakeTable
	ld bc, HiddenFigureLeftSwipeSCX
	call ApplyHiddenFigureSCXTable
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $00
	ld [wHiddenFigureAttack], a
	ld a, [wHiddenFigureLeftHandStunned]
	and a
	jr nz, .left_hand_stunned
	ld a, $1e
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret
.left_hand_stunned
	ld hl, wCurObjStateDuration
	ld a, $04
	ld [hli], a
	ld a, $09
	ld [hl], a
	ld a, $04
	ld [wHiddenFigureAttack], a
	ret

.WaitLeftHandStunned:
	ld a, [wHiddenFigureRemainingHits]
	and a
	jp z, .defeated
	ld a, [wHiddenFigureLeftHandStunned]
	and a
	ret nz
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hli], a
	ld a, $06
	ld [hl], a
	ld a, $00
	ld [wHiddenFigureAttack], a
	ret

.StartRightSwipe:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $80
	ld [hli], a
	ld a, $05
	ld [hli], a
	xor a
	ld [hli], a
	ld [hl], a
	ld a, $02
	ld [wHiddenFigureAttack], a
	ret

.RightSwipe:
	ld bc, HiddenFigureSwipeSCYShake
	call ApplyHiddenFigureSCYShakeTable
	ld bc, HiddenFigureRightSwipeSCX
	call ApplyHiddenFigureSCXTable
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $00
	ld [wHiddenFigureAttack], a
	ld a, [wHiddenFigureRightHandStunned]
	and a
	jr nz, .right_hand_stunned
	ld a, $1e
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret
.right_hand_stunned
	ld hl, wCurObjStateDuration
	ld a, $04
	ld [hli], a
	ld a, $0a
	ld [hl], a
	ld a, $05
	ld [wHiddenFigureAttack], a
	ret

.WaitRightHandStunned:
	ld a, [wHiddenFigureRemainingHits]
	and a
	jp z, .defeated
	ld a, [wHiddenFigureRightHandStunned]
	and a
	ret nz
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $1e
	ld [hli], a
	ld a, $06
	ld [hl], a
	ld a, $00
	ld [wHiddenFigureAttack], a
	ret

.defeated
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Defeated)
	ld [hld], a
	ld a, LOW(.Defeated)
	ld [hld], a
	ld a, $82
	ld [wCurObjStateDuration], a
	ld a, $06
	ld [wHiddenFigureAttack], a
	ret

.Defeated:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	call FlashHiddenFigurePals
	ld a, [wHiddenFigureLeftHandStunned]
	and a
	ret nz
	ld a, [wHiddenFigureRightHandStunned]
	and a
	ret nz
	ld hl, wCurObjStateDuration
	dec [hl]
	jr nz, .hit_sfx_timer
	ld a, $82
	ld [hli], a
	xor a
	ld [hl], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatedSink)
	ld [hld], a
	ld a, LOW(.DefeatedSink)
	ld [hld], a
	ld a, $01
	ld [wHiddenFigureDefeatStarted], a
	play_sfx SFX_HIDDEN_FIGURE_DEFEATED
	ret
.hit_sfx_timer
	ld a, [hl]
	and $3f
	ret nz
	play_sfx SFX_HIDDEN_FIGURE_HIT
	ret

.DefeatedSink:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjVar1
	ld a, [hl]
	and $07
	play_sfx z, SFX_RUMBLE
	inc [hl]
	dec l
	ld a, [hl]
	and a
	ret z
	dec [hl]
	jr z, .end_level
	call FlashHiddenFigurePals
	ld a, [wCurObjStateDuration]
	and $03
	ret nz
	ld hl, wHiddenFigureSCYShake
	dec [hl]
	ret
.end_level
	ld a, LVLEND_EPILOGUE
	ld [wLevelEndScreen], a
	jp SetHiddenFigurePals

HiddenFigureFace_StartLaugh:
	ld a, $3c
	ld [wCurObjStateDuration], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(HiddenFigureFaceFunc.Laugh)
	ld [hld], a
	ld a, LOW(HiddenFigureFaceFunc.Laugh)
	ld [hld], a
	ret

HiddenFigureFaceFunc:
.Main:
	ld hl, wHiddenFigureBodyGrabResult
	ld a, [hl]
	cp $80
	jr z, HiddenFigureFace_StartLaugh
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .look
	and $fe
	cp OBJSTATE_HIT_BY_OBJ_LEFT_START ; or OBJSTATE_HIT_BY_OBJ_RIGHT_START
	jr z, .hit
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret
.look
	ld a, [wCurObjFramesetOffset]
	cp $04
	ret nz
	ld a, [wCurObjFrameDuration]
	and a
	ret nz
	ld a, [wHiddenFigureLeftHandStunned]
	and a
	jr nz, .look_angry
	ld a, [wHiddenFigureRightHandStunned]
	and a
	jr nz, .look_angry
	ld a, [wHiddenFigureRemainingHits]
	dec a
	jr z, .look_angry
	ld a, [wWarioScreenXPos]
	cp $38
	jr nc, .look_not_left
	ld de, HiddenFigureFrameset_6a07a
	jp SetObjectFramesetPtr
.look_not_left
	cp $78
	jr nc, .look_right
	ld de, HiddenFigureFrameset_6a06c
	jp SetObjectFramesetPtr
.look_right
	ld de, HiddenFigureFrameset_6a07f
	jp SetObjectFramesetPtr
.look_angry
	ld a, [wWarioScreenXPos]
	cp $38
	jr nc, .angry_not_left
	ld de, HiddenFigureFrameset_6a092
	jp SetObjectFramesetPtr
.angry_not_left
	cp $78
	jr nc, .angry_right
	ld de, HiddenFigureFrameset_6a08d
	jp SetObjectFramesetPtr
.angry_right
	ld de, HiddenFigureFrameset_6a097
	jp SetObjectFramesetPtr
.hit
	xor a
	ld [hl], a
	ld de, HiddenFigureFrameset_6a084
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Hit)
	ld [hld], a
	ld a, LOW(.Hit)
	ld [hld], a
	ld a, $01
	ld [wHiddenFigureHandsFlinch], a
	ld hl, wHiddenFigureRemainingHits
	ld a, [hl]
	and a
	ret z
	dec [hl]
	jr nz, .check_last_hit
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Defeated)
	ld [hld], a
	ld a, LOW(.Defeated)
	ld [hld], a
	ld l, OBJ_FLAGS
	set 3, [hl]
	xor a
	ld [wHiddenFigureHandsFlinch], a
	stop_music2
	ld a, $10
	ld [wCurObjStateDuration], a
	ld a, $02
	ld [wAutoMoveState], a
	ret

.check_last_hit
	ld a, [hl]
	dec a
	ret nz
	play_music2 MUSIC_HIDDEN_FIGURE_BATTLE_2
	ret

.Hit:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .end_hit
	ld a, [hl]
	cp $2c
	play_sfx z, SFX_HIDDEN_FIGURE_HIT
	jp FlashHiddenFigurePals
.end_hit
	xor a
	ld [wHiddenFigureHandsFlinch], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Main)
	ld [hld], a
	ld a, LOW(.Main)
	ld [hld], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	call SetHiddenFigurePals
	jp .look_angry

.Defeated:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	play_sfx SFX_HIDDEN_FIGURE_HIT
	ret

.Laugh:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	play_sfx SFX_HIDDEN_FIGURE_LAUGH
	ld de, HiddenFigureFrameset_6a071
	jp SetObjectFramesetPtr

ApplyHiddenFigureSCYShakeTable:
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
	ld hl, wHiddenFigureSCYShake
	ld c, [hl]
	add c
	ld [hl], a
	ret

ApplyHiddenFigureSCXTable:
	ld hl, wCurObjVar2
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
	ld hl, wHiddenFigureSCX
	ld c, [hl]
	add c
	ld [hl], a
	ret

ApplyCurObjYTable:
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
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret
.negative
	add c
	ld [hli], a
	ret c
	dec [hl]
	ret

ApplyCurObjXTable:
	ld hl, wCurObjVar2
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
	ld l, OBJ_X_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret
.negative
	add c
	ld [hli], a
	ret c
	dec [hl]
	ret

FlashHiddenFigurePals:
	ld a, [wGlobalCounter]
	and %1111
	jr z, .normal_pals
	cp $08
	ret nz
	ld hl, HiddenFigureFlashPals
	jr .set_pals
.normal_pals
	ld a, [wHiddenFigureRemainingHits]
	cp $02
	jr c, .last_hit_pals
	ld hl, HiddenFigurePals
	jr .set_pals
.last_hit_pals
	ld hl, HiddenFigureLastHitPals
.set_pals
	ld c, 0
	ld b, 6
	jp SetBGPals

SetHiddenFigurePals:
	ld a, [wHiddenFigureRemainingHits]
	cp $02
	jr c, .last_hit_pals
	ld hl, HiddenFigurePals
	jr .set_pals
.last_hit_pals
	ld hl, HiddenFigureLastHitPals
.set_pals
	ld c, 0
	ld b, 6
	jp SetBGPals

HiddenFigureLastHitPals:
	rgb  1,  4,  9
	rgb 31,  0,  0
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 30, 31
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb 18, 13, 31
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb 28, 20,  6
	rgb 31,  0,  0
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb  0, 11, 21
	rgb 31, 25,  0
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb 15,  0,  0
	rgb 31, 25,  0
	rgb  0,  0,  0

HiddenFigureFlashPals:
	vc_patch FPA_292_BG_Flash_Palette1
	IF DEF(_VC)
		rgb  0,  0,  2
        rgb 31,  0,  0
        rgb 19, 22, 23
        rgb  0,  0,  0

        rgb  0,  0,  4
        rgb  0,  0,  9
        rgb 19, 22, 23
        rgb  0,  0,  0

        rgb  0,  0,  4
        rgb  0, 31, 18
        rgb 19, 22, 23
        rgb  0,  0,  0

        rgb  0,  0,  4
        rgb 28, 20,  6
        rgb 19, 22, 23
        rgb  0,  0,  0

        rgb  0,  0,  4
        rgb 10, 21, 26
        rgb 15, 31, 30
        rgb  0,  0,  5

        rgb  0,  0,  4
        rgb 23,  6,  1
        rgb 31, 31, 30
        rgb  5,  0,  0
	ELSE
		rgb  0,  0,  4
		rgb 31,  0,  0
		rgb 19, 22, 23
		rgb  0,  0,  0

		rgb  0,  0,  4
		rgb  0,  0,  9
		rgb 19, 22, 23
		rgb  0,  0,  0

		rgb  0,  0,  4
		rgb  0, 31, 18
		rgb 19, 22, 23
		rgb  0,  0,  0

		rgb  0,  0,  4
		rgb 28, 20,  6
		rgb 19, 22, 23
		rgb  0,  0,  0

		rgb  0,  0,  4
		rgb  0, 31, 31
		rgb 31, 31, 30
		rgb  0,  0,  5
		
		rgb  0,  0,  4
		rgb 31, 12,  3
		rgb 31, 31, 30
		rgb  5,  0,  0
	ENDC
	vc_patch_end

HiddenFigurePals:
	rgb  1,  4,  9
	rgb 31,  0,  0
	rgb  6, 10, 10
	rgb  0,  0,  0

	rgb 31, 31, 31
	rgb  0, 30, 31
	rgb  6, 10, 10
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb  0, 31, 18
	rgb  6, 10, 10
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb 28, 20,  6
	rgb  6, 10, 10
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb  0, 11, 21
	rgb 31, 25,  0
	rgb  0,  0,  0

	rgb  1,  4,  9
	rgb 15,  0,  0
	rgb 31, 25,  0
	rgb  0,  0,  0

HiddenFigureLeftHandFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld l, OBJ_Y_POS
	ld a, [hli]
	ld [wHiddenFigureLeftHandRestPos + 0], a
	ld a, [hli]
	ld [wHiddenFigureLeftHandRestPos + 1], a
	ld a, [hli]
	ld [wHiddenFigureLeftHandRestPos + 2], a
	ld a, [hli]
	ld [wHiddenFigureLeftHandRestPos + 3], a
	ret

.Idle:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wHiddenFigureAttack]
	cp $01
	jr z, .start_swipe
	cp $03
	jr z, .start_grab
	cp $07
	jr z, .start_grab
	cp $08
	jr z, .start_grab
	cp $05
	jr z, .start_slam
	cp $06
	jr z, .start_wait_defeat
	ld a, [wHiddenFigureHandsFlinch]
	and a
	ret z
	jr .start_flinch
.start_swipe
	ld a, $01
	ld [wHiddenFigureHandsFlinch], a
	ld bc, .Swipe
	ld de, HiddenFigureFrameset_6a13a
	jr .set_update_func
.start_grab
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_PUSH_BUMP_OFF
	ld [hli], a
	ld a, $e0
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $f4
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld bc, .Grab
	ld de, HiddenFigureFrameset_6a0bc
	jr .set_update_func
.start_slam
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FULL_STING
	ld [hli], a
	ld a, $01
	ld [wHiddenFigureLeftHandSlamming], a
	ld a, [wHiddenFigureRemainingHits]
	dec a
	jr z, .slam_last_hit
	ld a, $3c
	jr .set_slam_delay
.slam_last_hit
	ld a, $1e
.set_slam_delay
	ld [wCurObjStateDuration], a
	ld bc, .Slam
	ld de, HiddenFigureFrameset_6a0d4
	jr .set_update_func
.start_wait_defeat
	set 3, [hl]
	ld bc, .WaitDefeat
	ld de, HiddenFigureFrameset_6a0d4
	jr .set_update_func
.start_flinch
	ld bc, .Flinch
	ld de, HiddenFigureFrameset_6a0d4
	jr .set_update_func
.set_update_func
	ld hl, wCurObjUpdateFunction + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_2
	xor a
	ld [hli], a
	ld [hli], a
	inc l
	ld [hl], a
	jp SetObjectFramesetPtr

.Slam:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .slam_down
	dec [hl]
	ld a, [wHiddenFigureRemainingHits]
	and a
	jr z, .end_slam
	ld a, [wHiddenFigureAttack]
	cp $00
	jr z, .end_slam
	ret
.slam_down
	ld bc, HiddenFigureHandSlamY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $0a
	jr nz, .check_slam_end
	play_sfx SFX_SLAM
	ld b, $18
	jp DoGroundShake
.check_slam_end
	cp $3f
	ret nz
.end_slam
	xor a
	ld [wHiddenFigureLeftHandSlamming], a
	jp .return_to_idle

.Flinch:
	ld bc, HiddenFigureHandFlinchY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $3a
	ret nz
	xor a
	ld [wHiddenFigureHandsFlinch], a
	jp .return_to_idle

.Grab:
	ld hl, wHiddenFigureLeftHandGrabResult
	ld a, [hl]
	and a
	jr z, .check_hit
	cp $80
	jr z, .caught_wario
	dec [hl]
	ret
.caught_wario
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.HoldWario)
	ld [hld], a
	ld a, LOW(.HoldWario)
	ld [hld], a
	ld l, OBJ_Y_POS
	ld a, [hli]
	sub $01
	ld [wWarioYPos + 1], a
	ld a, [hli]
	sbc $00
	ld [wWarioYPos + 0], a
	ld a, [hli]
	add $06
	ld [wWarioXPos + 1], a
	ld a, [hli]
	adc $00
	ld [wWarioXPos + 0], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld de, HiddenFigureFrameset_6a0f2
	call SetObjectFramesetPtr
	stop_music2
	ret
.check_hit
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .move
	cp OBJSTATE_SPECIAL_3
	jr nz, .check_attacked
	play_sfx SFX_HIDDEN_FIGURE_GRAB
	ld a, $80
	jr .set_grab_result
.check_attacked
	and $fe
	cp OBJSTATE_ATTACKED_LEFT_START ; or OBJSTATE_ATTACKED_RIGHT_START
	jr nz, .clear_state
	ld a, $0a
.set_grab_result
	ld [wHiddenFigureBodyGrabResult], a
	ld [wHiddenFigureLeftHandGrabResult], a
	ld [wHiddenFigureRightHandGrabResult], a
	xor a
	ld [hl], a
	ret
.clear_state
	xor a
	ld [hl], a
.move
	ld a, [wHiddenFigureAttack]
	cp $08
	jr z, .grab3
	ld bc, HiddenFigureLeftHandGrabX
	call ApplyCurObjXTable
	ld a, [wHiddenFigureAttack]
	cp $07
	jr z, .grab2_y
	ld bc, HiddenFigureHandGrab1Y
	jr .apply_grab_y
.grab2_y
	ld bc, HiddenFigureHandGrab2Y
.apply_grab_y
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .check_push_frame
	ld de, HiddenFigureFrameset_6a0ef
	jp SetObjectFramesetPtr
.check_push_frame
	cp $62
	jr nz, .check_drag_frame
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_PUSH_BUMP_OFF
	ld [hld], a
	ld de, HiddenFigureFrameset_6a0c3
	jp SetObjectFramesetPtr
.check_drag_frame
	cp $61
	jr nz, .check_grab_end
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_DRAG_DOWN
	ld [hld], a
	play_sfx SFX_FAT_WALK
	ret
.check_grab_end
	cp $7f
	ret nz
	jp .return_to_idle
.grab3
	ld bc, HiddenFigureLeftHandGrab3X
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandGrab3Y
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .grab3_check_push
	ld de, HiddenFigureFrameset_6a0ef
	jp SetObjectFramesetPtr
.grab3_check_push
	cp $4e
	jr nz, .grab3_check_drag
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_PUSH_BUMP_OFF
	ld [hld], a
	ld de, HiddenFigureFrameset_6a0c3
	jp SetObjectFramesetPtr
.grab3_check_drag
	cp $4d
	jr nz, .grab3_check_end
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_DRAG_DOWN
	ld [hld], a
	play_sfx SFX_FAT_WALK
	ret
.grab3_check_end
	cp $5f
	ret nz
	jp .return_to_idle

.Swipe:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .swipe_move
	cp OBJSTATE_VANISH_TOUCH
	jr nz, .swipe_interrupted
	ld a, OBJSTATE_SPECIAL_2
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(HiddenFigureRightHandFunc.Stunned)
	ld [hld], a
	ld a, LOW(HiddenFigureRightHandFunc.Stunned)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hli], a
	ld a, $ec
	ld [hli], a
	ld a, $fe
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $07
	ld [hli], a
	xor a
	ld [wCurObjVar3], a
	inc a
	ld [wHiddenFigureLeftHandStunned], a
	ld [wCurObjStateDuration], a
	stop_sfx
	ld de, HiddenFigureFrameset_6a0b2
	jp SetObjectFramesetPtr
.swipe_interrupted
	ld a, $01
	ld [wHiddenFigureSwipeInterrupted], a
	xor a
	ld [hl], a
.swipe_move
	ld bc, HiddenFigureLeftHandSwipeX
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandSwipeY
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $10
	jr nz, .check_sting_front
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BOTTOM_STING_SMASHABLE_TOP
	ld [hld], a
	ret
.check_sting_front
	cp $3c
	jr nz, .check_swipe_end
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_STING_SMASHABLE_TOP
	ld [hld], a
	play_sfx SFX_HIDDEN_FIGURE_HAND_1
	ret
.check_swipe_end
	cp $7f
	ret nz

.return_to_idle
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hli], a
	ld a, $e8
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $07
	ld [hli], a
	xor a
	ld [wCurObjState], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	res 4, [hl]
	ld de, HiddenFigureFrameset_6a128
	jp SetObjectFramesetPtr

.HoldWario:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.WaitDefeat:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wHiddenFigureDefeatStarted]
	and a
	ret z
	ld de, HiddenFigureFrameset_6a0bc
	call SetObjectFramesetPtr
	ld a, $20
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatRise)
	ld [hld], a
	ld a, LOW(.DefeatRise)
	ld [hld], a
	ret

.DefeatRise:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	rra
	jp nc, MoveObjectUp
	ret

HiddenFigureRightHandFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld l, OBJ_Y_POS
	ld a, [hli]
	ld [wHiddenFigureRightHandRestPos + 0], a
	ld a, [hli]
	ld [wHiddenFigureRightHandRestPos + 1], a
	ld a, [hli]
	ld [wHiddenFigureRightHandRestPos + 2], a
	ld a, [hli]
	ld [wHiddenFigureRightHandRestPos + 3], a
	ret

.Idle:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	ld a, [wHiddenFigureAttack]
	cp $02
	jr z, .start_swipe
	cp $03
	jr z, .start_grab
	cp $07
	jr z, .start_grab
	cp $08
	jr z, .start_grab
	cp $04
	jr z, .start_slam
	cp $06
	jr z, .start_wait_defeat
	ld a, [wHiddenFigureHandsFlinch]
	and a
	ret z
	jr .start_flinch
.start_swipe
	ld a, $01
	ld [wHiddenFigureHandsFlinch], a
	ld bc, .Swipe
	ld de, HiddenFigureFrameset_6a145
	jr .set_update_func
.start_grab
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_PUSH_BUMP_OFF
	ld [hli], a
	ld a, $e0
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld a, $0b
	ld [hli], a
	ld bc, .Grab
	ld de, HiddenFigureFrameset_6a0c8
	jr .set_update_func
.start_slam
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FULL_STING
	ld [hli], a
	ld a, $01
	ld [wHiddenFigureRightHandSlamming], a
	ld a, [wHiddenFigureRemainingHits]
	dec a
	jr z, .slam_last_hit
	ld a, $3c
	jr .set_slam_delay
.slam_last_hit
	ld a, $1e
.set_slam_delay
	ld [wCurObjStateDuration], a
	ld bc, .Slam
	ld de, HiddenFigureFrameset_6a0fe
	jr .set_update_func
.start_wait_defeat
	set 3, [hl]
	ld bc, .WaitDefeat
	ld de, HiddenFigureFrameset_6a0fe
	jr .set_update_func
.start_flinch
	ld bc, .Flinch
	ld de, HiddenFigureFrameset_6a0fe
	jr .set_update_func
.set_update_func
	ld hl, wCurObjUpdateFunction + 1
	ld a, b
	ld [hld], a
	ld [hl], c
	ld l, OBJ_VAR_2
	xor a
	ld [hli], a
	ld [hl], a
	inc l
	ld [hl], a
	jp SetObjectFramesetPtr

.Slam:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .slam_down
	dec [hl]
	ld a, [wHiddenFigureRemainingHits]
	and a
	jr z, .end_slam
	ld a, [wHiddenFigureAttack]
	cp $00
	jr z, .end_slam
	ret
.slam_down
	ld bc, HiddenFigureHandSlamY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $0a
	jr nz, .check_slam_end
	play_sfx SFX_SLAM
	ld b, $18
	jp DoGroundShake
.check_slam_end
	cp $3f
	ret nz
.end_slam
	xor a
	ld [wHiddenFigureRightHandSlamming], a
	jp .return_to_idle

.Flinch:
	ld bc, HiddenFigureHandFlinchY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $3a
	ret nz
	xor a
	ld [wHiddenFigureHandsFlinch], a
	jp .return_to_idle

.Grab:
	ld hl, wHiddenFigureRightHandGrabResult
	ld a, [hl]
	and a
	jr z, .check_hit
	cp $80
	jr z, .caught_wario
	dec [hl]
	ret
.caught_wario
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.HoldWario)
	ld [hld], a
	ld a, LOW(.HoldWario)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld de, HiddenFigureFrameset_6a11c
	jp SetObjectFramesetPtr
.check_hit
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .move
	and $fe
	cp OBJSTATE_ATTACKED_LEFT_START ; or OBJSTATE_ATTACKED_RIGHT_START
	jr nz, .clear_state
	ld a, $0a
	ld [wHiddenFigureBodyGrabResult], a
	ld [wHiddenFigureLeftHandGrabResult], a
	ld [wHiddenFigureRightHandGrabResult], a
	xor a
	ld [hl], a
	ret
.clear_state
	xor a
	ld [hl], a
.move
	ld a, [wHiddenFigureAttack]
	cp $08
	jr z, .grab3
	ld bc, HiddenFigureRightHandGrabX
	call ApplyCurObjXTable
	ld a, [wHiddenFigureAttack]
	cp $07
	jr z, .grab2_y
	ld bc, HiddenFigureHandGrab1Y
	jr .apply_grab_y
.grab2_y
	ld bc, HiddenFigureHandGrab2Y
.apply_grab_y
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .check_push_frame
	play_sfx SFX_HIDDEN_FIGURE_HAND_3
	ld de, HiddenFigureFrameset_6a119
	jp SetObjectFramesetPtr
.check_push_frame
	cp $62
	jr nz, .check_sfx_frame
	ld de, HiddenFigureFrameset_6a0cf
	jp SetObjectFramesetPtr
.check_sfx_frame
	cp $32
	jr nz, .check_grab_end
	play_sfx SFX_HIDDEN_FIGURE_HAND_2
	ret
.check_grab_end
	cp $7f
	ret nz
	jp .return_to_idle
.grab3
	ld bc, HiddenFigureRightHandGrab3X
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandGrab3Y
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .grab3_check_push
	play_sfx SFX_HIDDEN_FIGURE_HAND_2
	ld de, HiddenFigureFrameset_6a119
	jp SetObjectFramesetPtr
.grab3_check_push
	cp $4e
	jr nz, .grab3_check_end
	ld de, HiddenFigureFrameset_6a0cf
	jp SetObjectFramesetPtr
.grab3_check_end
	cp $5f
	ret nz
	jp .return_to_idle

.Swipe:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .swipe_move
	cp OBJSTATE_VANISH_TOUCH
	jr nz, .swipe_interrupted
	ld a, OBJSTATE_SPECIAL_2
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Stunned)
	ld [hld], a
	ld a, LOW(.Stunned)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hli], a
	ld a, $ec
	ld [hli], a
	ld a, $fe
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $07
	ld [hli], a
	xor a
	ld [wCurObjVar3], a
	inc a
	ld [wHiddenFigureRightHandStunned], a
	ld [wCurObjStateDuration], a
	stop_sfx
	ld de, HiddenFigureFrameset_6a0b7
	jp SetObjectFramesetPtr
.swipe_interrupted
	ld a, $01
	ld [wHiddenFigureSwipeInterrupted], a
	xor a
	ld [hl], a
.swipe_move
	ld bc, HiddenFigureRightHandSwipeX
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandSwipeY
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $10
	jr nz, .check_sting_front
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BOTTOM_STING_SMASHABLE_TOP
	ld [hld], a
	ret
.check_sting_front
	cp $3c
	jr nz, .check_swipe_end
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FRONT_STING_SMASHABLE_TOP
	ld [hld], a
	play_sfx SFX_HIDDEN_FIGURE_HAND_1
	ret
.check_swipe_end
	cp $7f
	ret nz
.return_to_idle
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hli], a
	ld a, $e8
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $f8
	ld [hli], a
	ld a, $07
	ld [hli], a
	xor a
	ld [wCurObjState], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	res 4, [hl]
	ld de, HiddenFigureFrameset_6a131
	jp SetObjectFramesetPtr

.HoldWario:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.WaitDefeat:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wHiddenFigureDefeatStarted]
	and a
	ret z
	ld de, HiddenFigureFrameset_6a0c8
	call SetObjectFramesetPtr
	ld a, $1e
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.DefeatSink)
	ld [hld], a
	ld a, LOW(.DefeatSink)
	ld [hld], a
	ret

.DefeatSink:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	rra
	jp c, MoveObjectDown
	ret

.Stunned:
	ld hl, wSCYShake
	ld a, [wHiddenFigureBaseSCY]
	add [hl]
	ld [wSCY], a
	ld a, [wHiddenFigureBaseSCX]
	ld [wSCX], a
	ld a, [wCurObjState]
	ld e, a
	cp OBJSTATE_SPECIAL_1
	jr z, .dispatch
	ld a, [wGlobalCounter]
	and %1111
	play_sfx z, SFX_WHIRR
.dispatch
	ld a, e
	jumptable
	dw .Default_4d7dc
	dw .Land
	dw .Default_4d83a
	dw .Default_4d844
	dw .Default_4d83a
	dw .Default_4d844
	dw .PickedUpLeftStart
	dw .PickedUpRightStart
	dw .Default_4d83a
	dw .Default_4d844
	dw .VanishTouch
	dw .Default_4d83a
	dw .Default_4d844
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .State14
	dw .State15
	dw .StunLeftStart
	dw .StunRightStart
	dw .State18
	dw .State19
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw ObjState_Bounce1LeftStart
	dw ObjState_Bounce1RightStart
	dw ObjState_Bounce2LeftStart
	dw ObjState_Bounce2RightStart
	dw ObjState_Bounce3LeftStart
	dw ObjState_Bounce3RightStart
	dw ObjState_FallLeftStart
	dw ObjState_FallRightStart
	dw .Default_4d844
	dw .Default_4d83a
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Special1
	dw .Special2
	dw .Default_4d7dc
	dw ObjState_Fall
	dw .Walk
	dw ObjState_BumpLeft
	dw ObjState_BumpRight
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw ObjState_Bounce2Right
	dw ObjState_Bounce2Left
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw ObjState_StandingFall
	dw ObjState_Drop
	dw .Default_4d7dc
	dw ObjState_FallLeft
	dw ObjState_FallRight
	dw .StunLeft
	dw .StunRight
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
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc
	dw .Default_4d7dc

.Special2:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jp z, ObjState_Fall
	dec [hl]
	play_sfx SFX_VANISH
	ret

.Special1:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wCurObjId]
	cp HIDDEN_FIGURE_RIGHT_HAND
	jr z, .right_hand_check
	ld hl, wHiddenFigureLeftHandRestPos
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld hl, wCurObjYPos
	ld a, [hli]
	cp e
	jr nz, .return_to_rest
	ld a, [hli]
	cp d
	jr nz, .return_to_rest
	ld a, [hli]
	cp c
	jr nz, .return_to_rest
	ld a, [hli]
	cp b
	jr nz, .return_to_rest
	xor a
	ld [wHiddenFigureLeftHandStunned], a
	jp HiddenFigureLeftHandFunc.return_to_idle
.right_hand_check
	ld hl, wHiddenFigureRightHandRestPos
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld hl, wCurObjYPos
	ld a, [hli]
	cp e
	jr nz, .return_to_rest
	ld a, [hli]
	cp d
	jr nz, .return_to_rest
	ld a, [hli]
	cp c
	jr nz, .return_to_rest
	ld a, [hli]
	cp b
	jr nz, .return_to_rest
	xor a
	ld [wHiddenFigureRightHandStunned], a
	jp .return_to_idle
.return_to_rest
	ld l, OBJ_Y_POS
	ld a, [hli]
	cp e
	jr nz, .move_up
	ld a, [hl]
	cp d
	jr z, .move_horizontal
.move_up
	call MoveObjectUp
.move_horizontal
	ld l, OBJ_X_POS + 1
	ld a, [hld]
	cp b
	jr z, .compare_x_lo
	jr c, .move_right
	jr .move_left
.compare_x_lo
	ld a, [hl]
	cp c
	jr z, .blink
	jr c, .move_right
.move_left
	call MoveObjectLeft
	jr .blink
.move_right
	call MoveObjectRight
.blink
	ld a, [wGlobalCounter]
	and %11
	ld hl, wCurObjFlags
	ld a, [hl]
	jr nz, .show
	set 4, a
	ld [hl], a
	ret
.show
	res 4, a
	ld [hl], a
	ret

.Default_4d7dc:
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
	ld a, [wHiddenFigureHandWasGrabbed]
	cp $01
	jr z, .set_walk_duration
	ld a, $46
.set_walk_duration
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
.Walk:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld l, OBJ_FLAGS
	res OBJFLAG_PRIORITY_F, [hl]
	xor a
	ld [wHiddenFigureHandWasGrabbed], a
	ld l, OBJ_STATE
	ld a, OBJSTATE_SPECIAL_1
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .recover_facing_right
	ld de, HiddenFigureFrameset_6a0fe
	jp SetObjectFramesetPtr
.recover_facing_right
	ld de, HiddenFigureFrameset_6a0d4
	jp SetObjectFramesetPtr

.VanishTouch:
	play_sfx SFX_VANISH
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .Default_4d844
.Default_4d83a:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_LEFT
	jr .set_wobble
.Default_4d844:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_WOBBLE_RIGHT
.set_wobble
	ld [hld], a
	ld l, OBJ_STATE_DURATION
	ld a, $04
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
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

.PickedUpLeftStart:
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
	ld hl, wCurObjState
	ld a, OBJSTATE_PICKED_UP_LEFT
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
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
	ld hl, wCurObjState
	ld a, OBJSTATE_PICKED_UP_RIGHT
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
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
	ld hl, wCurObjState
	ld a, OBJSTATE_GRABBED_RIGHT
	ld [hld], a
	ld l, OBJ_FLAGS
	set 2, [hl]
.State49:
	ld a, [wDirection]
	and a
	jp nz, ObjState_GrabbedRight
	jr .State18
.State18:
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
	ld hl, wCurObjState
	ld a, OBJSTATE_GRABBED_LEFT
	ld [hld], a
	ld l, OBJ_FLAGS
	set 2, [hl]
.State48:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	jp .State19
