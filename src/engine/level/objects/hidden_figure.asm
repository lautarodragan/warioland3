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
	ld de, Frameset_6a06c
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
	dw .Func_4cbe8
	dw .WaitLeftHandStunned
	dw .WaitRightHandStunned

.Func_4cbe8:
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
	jr nz, .asm_4cc00
	dec [hl]
	ret nz
.asm_4cc00
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
	jr nc, .asm_4cc19
	ld e, a
	ld a, [wHiddenFigureSwipeInterrupted]
	and a
	jr z, .asm_4cc24
.asm_4cc19
	xor a
	ld [wHiddenFigureSwipeInterrupted], a
	ld [wHiddenFigureSwipeCount], a
	ld b, $06
	jr .asm_4cc36
.asm_4cc24
	ld a, [wWarioScreenXPos]
	cp $58
	jr nc, .asm_4cc2f
	ld b, $02
	jr .asm_4cc31
.asm_4cc2f
	ld b, $04
.asm_4cc31
	inc e
	ld a, e
	ld [wHiddenFigureSwipeCount], a
.asm_4cc36
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
	jr z, .asm_4cc82
	cp $03
	jr nc, .asm_4cc7b
	ld a, [wWarioScreenXPos]
	cp $30
	jr c, .asm_4cc7b
	cp $80
	jr nc, .asm_4cc7b
	ld a, [wHiddenFigureAttackCounter]
	rra
	jr c, .asm_4cc7b
	ld a, $60
	ld [wCurObjStateDuration], a
	ld b, $08
	jr .asm_4cc82
.asm_4cc7b
	ldh a, [rDIV]
	rra
	jr c, .asm_4cc82
	ld b, $07
.asm_4cc82
	ld a, b
	ld [wHiddenFigureAttack], a
	ret

.Grab:
	ld hl, wHiddenFigureBodyGrabResult
	ld a, [hl]
	and a
	jr z, .asm_4cc9e
	cp $80
	jr z, .asm_4cc94
	dec [hl]
	ret
.asm_4cc94
	ld hl, wCurObjStateDuration
	ld a, $a0
	ld [hli], a
	ld a, $08
	ld [hl], a
	ret
.asm_4cc9e
	ld a, [wHiddenFigureAttack]
	cp $07
	jr z, .asm_4ccae
	cp $08
	jr z, .asm_4ccb3
	ld bc, HiddenFigureGrab1SCYShake
	jr .asm_4ccb6
.asm_4ccae
	ld bc, HiddenFigureGrab2SCYShake
	jr .asm_4ccb6
.asm_4ccb3
	ld bc, HiddenFigureGrab3SCYShake
.asm_4ccb6
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
	jr z, .asm_4ccde
	ld a, $06
	ld [wCurObjVar1], a
	ld hl, wHiddenFigureAttackCounter
	inc [hl]
	ret
.asm_4ccde
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
	jr nz, .asm_4cd19
	ld a, $1e
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret
.asm_4cd19
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
	jr nz, .asm_4cd7c
	ld a, $1e
	ld [hli], a
	ld a, $00
	ld [hl], a
	ret
.asm_4cd7c
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
	jr nz, .asm_4cdf4
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
	play_sfx SFX_0CF
	ret
.asm_4cdf4
	ld a, [hl]
	and $3f
	ret nz
	play_sfx SFX_0CE
	ret

.DefeatedSink:
	ld a, $02
	ld [wCurObjFrameDuration], a
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjVar1
	ld a, [hl]
	and $07
	play_sfx z, SFX_01F
	inc [hl]
	dec l
	ld a, [hl]
	and a
	ret z
	dec [hl]
	jr z, .asm_4ce31
	call FlashHiddenFigurePals
	ld a, [wCurObjStateDuration]
	and $03
	ret nz
	ld hl, wHiddenFigureSCYShake
	dec [hl]
	ret
.asm_4ce31
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
	jr z, .asm_4ce63
	and $fe
	cp $28
	jr z, .asm_4ceba
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret
.asm_4ce63
	ld a, [wCurObjFramesetOffset]
	cp $04
	ret nz
	ld a, [wCurObjFrameDuration]
	and a
	ret nz
	ld a, [wHiddenFigureLeftHandStunned]
	and a
	jr nz, .asm_4ce9d
	ld a, [wHiddenFigureRightHandStunned]
	and a
	jr nz, .asm_4ce9d
	ld a, [wHiddenFigureRemainingHits]
	dec a
	jr z, .asm_4ce9d
	ld a, [wWarioScreenXPos]
	cp $38
	jr nc, .asm_4ce8d
	ld de, Frameset_6a07a
	jp SetObjectFramesetPtr
.asm_4ce8d
	cp $78
	jr nc, .asm_4ce97
	ld de, Frameset_6a06c
	jp SetObjectFramesetPtr
.asm_4ce97
	ld de, Frameset_6a07f
	jp SetObjectFramesetPtr
.asm_4ce9d
	ld a, [wWarioScreenXPos]
	cp $38
	jr nc, .asm_4ceaa
	ld de, Frameset_6a092
	jp SetObjectFramesetPtr
.asm_4ceaa
	cp $78
	jr nc, .asm_4ceb4
	ld de, Frameset_6a08d
	jp SetObjectFramesetPtr
.asm_4ceb4
	ld de, Frameset_6a097
	jp SetObjectFramesetPtr
.asm_4ceba
	xor a
	ld [hl], a
	ld de, Frameset_6a084
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
	jr nz, .asm_4cf03
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

.asm_4cf03
	ld a, [hl]
	dec a
	ret nz
	play_music2 MUSIC_HIDDEN_FIGURE_BATTLE_2
	ret

.Hit:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .asm_4cf29
	ld a, [hl]
	cp $2c
	play_sfx z, SFX_0CE
	jp FlashHiddenFigurePals
.asm_4cf29
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
	jp .asm_4ce9d

.Defeated:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	ret z
	dec [hl]
	ret nz
	play_sfx SFX_0CE
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
	ld de, Frameset_6a071
	jp SetObjectFramesetPtr

ApplyHiddenFigureSCYShakeTable:
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .asm_4cf7f
	dec c
	ld a, [bc]
	jr .asm_4cf80
.asm_4cf7f
	inc [hl]
.asm_4cf80
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
	jr nz, .asm_4cf96
	dec c
	ld a, [bc]
	jr .asm_4cf97
.asm_4cf96
	inc [hl]
.asm_4cf97
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
	jr nz, .asm_4cfad
	dec c
	ld a, [bc]
	jr .asm_4cfae
.asm_4cfad
	inc [hl]
.asm_4cfae
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .asm_4cfba
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret
.asm_4cfba
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
	jr nz, .asm_4cfce
	dec c
	ld a, [bc]
	jr .asm_4cfcf
.asm_4cfce
	inc [hl]
.asm_4cfcf
	ld l, OBJ_X_POS
	cp $80
	ld c, [hl]
	jr nc, .asm_4cfdb
	add c
	ld [hli], a
	ret nc
	inc [hl]
	ret
.asm_4cfdb
	add c
	ld [hli], a
	ret c
	dec [hl]
	ret

FlashHiddenFigurePals:
	ld a, [wGlobalCounter]
	and %1111
	jr z, .asm_4cfef
	cp $08
	ret nz
	ld hl, HiddenFigureFlashPals
	jr .asm_4cffe
.asm_4cfef
	ld a, [wHiddenFigureRemainingHits]
	cp $02
	jr c, .asm_4cffb
	ld hl, HiddenFigurePals
	jr .asm_4cffe
.asm_4cffb
	ld hl, HiddenFigureLastHitPals
.asm_4cffe
	ld c, 0
	ld b, 6
	jp SetBGPals

SetHiddenFigurePals:
	ld a, [wHiddenFigureRemainingHits]
	cp $02
	jr c, .asm_4d011
	ld hl, HiddenFigurePals
	jr .asm_4d014
.asm_4d011
	ld hl, HiddenFigureLastHitPals
.asm_4d014
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
	jr z, .asm_4d0f3
	cp $03
	jr z, .asm_4d100
	cp $07
	jr z, .asm_4d100
	cp $08
	jr z, .asm_4d100
	cp $05
	jr z, .asm_4d11d
	cp $06
	jr z, .asm_4d142
	ld a, [wHiddenFigureHandsFlinch]
	and a
	ret z
	jr .asm_4d14c
.asm_4d0f3
	ld a, $01
	ld [wHiddenFigureHandsFlinch], a
	ld bc, .Swipe
	ld de, Frameset_6a13a
	jr .asm_4d154
.asm_4d100
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_4F
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
	ld de, Frameset_6a0bc
	jr .asm_4d154
.asm_4d11d
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FULL_STING
	ld [hli], a
	ld a, $01
	ld [wHiddenFigureLeftHandSlamming], a
	ld a, [wHiddenFigureRemainingHits]
	dec a
	jr z, .asm_4d135
	ld a, $3c
	jr .asm_4d137
.asm_4d135
	ld a, $1e
.asm_4d137
	ld [wCurObjStateDuration], a
	ld bc, .Slam
	ld de, Frameset_6a0d4
	jr .asm_4d154
.asm_4d142
	set 3, [hl]
	ld bc, .WaitDefeat
	ld de, Frameset_6a0d4
	jr .asm_4d154
.asm_4d14c
	ld bc, .Flinch
	ld de, Frameset_6a0d4
	jr .asm_4d154
.asm_4d154
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
	jr z, .asm_4d17a
	dec [hl]
	ld a, [wHiddenFigureRemainingHits]
	and a
	jr z, .asm_4d197
	ld a, [wHiddenFigureAttack]
	cp $00
	jr z, .asm_4d197
	ret
.asm_4d17a
	ld bc, HiddenFigureHandSlamY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $0a
	jr nz, .asm_4d194
	play_sfx SFX_063
	ld b, $18
	jp DoGroundShake
.asm_4d194
	cp $3f
	ret nz
.asm_4d197
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
	jr z, .asm_4d1f8
	cp $80
	jr z, .asm_4d1be
	dec [hl]
	ret
.asm_4d1be
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
	ld de, Frameset_6a0f2
	call SetObjectFramesetPtr
	stop_music2
	ret
.asm_4d1f8
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_4d225
	cp $2f
	jr nz, .asm_4d20f
	play_sfx SFX_0CD
	ld a, $80
	jr .asm_4d217
.asm_4d20f
	and $fe
	cp $04
	jr nz, .asm_4d223
	ld a, $0a
.asm_4d217
	ld [wHiddenFigureBodyGrabResult], a
	ld [wHiddenFigureLeftHandGrabResult], a
	ld [wHiddenFigureRightHandGrabResult], a
	xor a
	ld [hl], a
	ret
.asm_4d223
	xor a
	ld [hl], a
.asm_4d225
	ld a, [wHiddenFigureAttack]
	cp $08
	jr z, .asm_4d280
	ld bc, HiddenFigureLeftHandGrabX
	call ApplyCurObjXTable
	ld a, [wHiddenFigureAttack]
	cp $07
	jr z, .asm_4d23e
	ld bc, HiddenFigureHandGrab1Y
	jr .asm_4d241
.asm_4d23e
	ld bc, HiddenFigureHandGrab2Y
.asm_4d241
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .asm_4d251
	ld de, Frameset_6a0ef
	jp SetObjectFramesetPtr
.asm_4d251
	cp $62
	jr nz, .asm_4d264
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_4F
	ld [hld], a
	ld de, Frameset_6a0c3
	jp SetObjectFramesetPtr
.asm_4d264
	cp $61
	jr nz, .asm_4d27a
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_50
	ld [hld], a
	play_sfx SFX_FAT_WALK
	ret
.asm_4d27a
	cp $7f
	ret nz
	jp .return_to_idle
.asm_4d280
	ld bc, HiddenFigureLeftHandGrab3X
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandGrab3Y
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .asm_4d299
	ld de, Frameset_6a0ef
	jp SetObjectFramesetPtr
.asm_4d299
	cp $4e
	jr nz, .asm_4d2ac
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_4F
	ld [hld], a
	ld de, Frameset_6a0c3
	jp SetObjectFramesetPtr
.asm_4d2ac
	cp $4d
	jr nz, .asm_4d2c2
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_50
	ld [hld], a
	play_sfx SFX_FAT_WALK
	ret
.asm_4d2c2
	cp $5f
	ret nz
	jp .return_to_idle

.Swipe:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_4d316
	cp $0a
	jr nz, .asm_4d30f
	ld a, $2e
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
	or OBJ_INTERACTION_00
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
	ld de, Frameset_6a0b2
	jp SetObjectFramesetPtr
.asm_4d30f
	ld a, $01
	ld [wHiddenFigureSwipeInterrupted], a
	xor a
	ld [hl], a
.asm_4d316
	ld bc, HiddenFigureLeftHandSwipeX
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandSwipeY
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $10
	jr nz, .asm_4d333
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_48
	ld [hld], a
	ret
.asm_4d333
	cp $3c
	jr nz, .asm_4d349
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_52
	ld [hld], a
	play_sfx SFX_0CB
	ret
.asm_4d349
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
	or OBJ_INTERACTION_0B
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
	ld de, Frameset_6a128
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
	ld de, Frameset_6a0bc
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
	jr z, .asm_4d3f4
	cp $03
	jr z, .asm_4d401
	cp $07
	jr z, .asm_4d401
	cp $08
	jr z, .asm_4d401
	cp $04
	jr z, .asm_4d41e
	cp $06
	jr z, .asm_4d443
	ld a, [wHiddenFigureHandsFlinch]
	and a
	ret z
	jr .asm_4d44d
.asm_4d3f4
	ld a, $01
	ld [wHiddenFigureHandsFlinch], a
	ld bc, .Func_4d571
	ld de, Frameset_6a145
	jr .asm_4d455
.asm_4d401
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_4F
	ld [hli], a
	ld a, $e0
	ld [hli], a
	ld a, $00
	ld [hli], a
	ld a, $ff
	ld [hli], a
	ld a, $0b
	ld [hli], a
	ld bc, .Func_4d4b2
	ld de, Frameset_6a0c8
	jr .asm_4d455
.asm_4d41e
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FULL_STING
	ld [hli], a
	ld a, $01
	ld [wHiddenFigureRightHandSlamming], a
	ld a, [wHiddenFigureRemainingHits]
	dec a
	jr z, .asm_4d436
	ld a, $3c
	jr .asm_4d438
.asm_4d436
	ld a, $1e
.asm_4d438
	ld [wCurObjStateDuration], a
	ld bc, .Func_4d465
	ld de, Frameset_6a0fe
	jr .asm_4d455
.asm_4d443
	set 3, [hl]
	ld bc, .Func_4d628
	ld de, Frameset_6a0fe
	jr .asm_4d455
.asm_4d44d
	ld bc, .Func_4d49f
	ld de, Frameset_6a0fe
	jr .asm_4d455
.asm_4d455
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

.Func_4d465:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .asm_4d47b
	dec [hl]
	ld a, [wHiddenFigureRemainingHits]
	and a
	jr z, .asm_4d498
	ld a, [wHiddenFigureAttack]
	cp $00
	jr z, .asm_4d498
	ret
.asm_4d47b
	ld bc, HiddenFigureHandSlamY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $0a
	jr nz, .asm_4d495
	play_sfx SFX_063
	ld b, $18
	jp DoGroundShake
.asm_4d495
	cp $3f
	ret nz
.asm_4d498
	xor a
	ld [wHiddenFigureRightHandSlamming], a
	jp .asm_4d5f5

.Func_4d49f:
	ld bc, HiddenFigureHandFlinchY
	call ApplyCurObjYTable
	ld a, [wCurObjVar3]
	cp $3a
	ret nz
	xor a
	ld [wHiddenFigureHandsFlinch], a
	jp .asm_4d5f5

.Func_4d4b2:
	ld hl, wHiddenFigureRightHandGrabResult
	ld a, [hl]
	and a
	jr z, .asm_4d4d2
	cp $80
	jr z, .asm_4d4bf
	dec [hl]
	ret
.asm_4d4bf
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Func_4d622)
	ld [hld], a
	ld a, LOW(.Func_4d622)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	ld de, Frameset_6a11c
	jp SetObjectFramesetPtr
.asm_4d4d2
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_4d4ef
	and $fe
	cp $04
	jr nz, .asm_4d4ed
	ld a, $0a
	ld [wHiddenFigureBodyGrabResult], a
	ld [wHiddenFigureLeftHandGrabResult], a
	ld [wHiddenFigureRightHandGrabResult], a
	xor a
	ld [hl], a
	ret
.asm_4d4ed
	xor a
	ld [hl], a
.asm_4d4ef
	ld a, [wHiddenFigureAttack]
	cp $08
	jr z, .asm_4d540
	ld bc, HiddenFigureRightHandGrabX
	call ApplyCurObjXTable
	ld a, [wHiddenFigureAttack]
	cp $07
	jr z, .asm_4d508
	ld bc, HiddenFigureHandGrab1Y
	jr .asm_4d50b
.asm_4d508
	ld bc, HiddenFigureHandGrab2Y
.asm_4d50b
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .asm_4d523
	play_sfx SFX_0D1
	ld de, Frameset_6a119
	jp SetObjectFramesetPtr
.asm_4d523
	cp $62
	jr nz, .asm_4d52d
	ld de, Frameset_6a0cf
	jp SetObjectFramesetPtr
.asm_4d52d
	cp $32
	jr nz, .asm_4d53a
	play_sfx SFX_0D0
	ret
.asm_4d53a
	cp $7f
	ret nz
	jp .asm_4d5f5
.asm_4d540
	ld bc, HiddenFigureRightHandGrab3X
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandGrab3Y
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $13
	jr nz, .asm_4d561
	play_sfx SFX_0D0
	ld de, Frameset_6a119
	jp SetObjectFramesetPtr
.asm_4d561
	cp $4e
	jr nz, .asm_4d56b
	ld de, Frameset_6a0cf
	jp SetObjectFramesetPtr
.asm_4d56b
	cp $5f
	ret nz
	jp .asm_4d5f5

.Func_4d571:
	ld hl, wCurObjState
	ld a, [hl]
	and a
	jr z, .asm_4d5bf
	cp $0a
	jr nz, .asm_4d5b8
	ld a, $2e
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
	or OBJ_INTERACTION_00
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
	ld de, Frameset_6a0b7
	jp SetObjectFramesetPtr
.asm_4d5b8
	ld a, $01
	ld [wHiddenFigureSwipeInterrupted], a
	xor a
	ld [hl], a
.asm_4d5bf
	ld bc, HiddenFigureRightHandSwipeX
	call ApplyCurObjXTable
	ld bc, HiddenFigureHandSwipeY
	call ApplyCurObjYTable
	ld a, [wCurObjVar2]
	cp $10
	jr nz, .asm_4d5dc
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_48
	ld [hld], a
	ret
.asm_4d5dc
	cp $3c
	jr nz, .asm_4d5f2
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_52
	ld [hld], a
	play_sfx SFX_0CB
	ret
.asm_4d5f2
	cp $7f
	ret nz
.asm_4d5f5
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Idle)
	ld [hld], a
	ld a, LOW(.Idle)
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_0B
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
	ld de, Frameset_6a131
	jp SetObjectFramesetPtr

.Func_4d622:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.Func_4d628:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wHiddenFigureDefeatStarted]
	and a
	ret z
	ld de, Frameset_6a0c8
	call SetObjectFramesetPtr
	ld a, $1e
	ld [hli], a
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Slam)
	ld [hld], a
	ld a, LOW(.Slam)
	ld [hld], a
	ret

.Slam:
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
	cp $2d
	jr z, .asm_4d67c
	ld a, [wGlobalCounter]
	and %1111
	play_sfx z, SFX_06A
.asm_4d67c
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
	jr z, .asm_4d780
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
	jr nz, .asm_4d7a4
	ld a, [hli]
	cp d
	jr nz, .asm_4d7a4
	ld a, [hli]
	cp c
	jr nz, .asm_4d7a4
	ld a, [hli]
	cp b
	jr nz, .asm_4d7a4
	xor a
	ld [wHiddenFigureLeftHandStunned], a
	jp HiddenFigureLeftHandFunc.return_to_idle
.asm_4d780
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
	jr nz, .asm_4d7a4
	ld a, [hli]
	cp d
	jr nz, .asm_4d7a4
	ld a, [hli]
	cp c
	jr nz, .asm_4d7a4
	ld a, [hli]
	cp b
	jr nz, .asm_4d7a4
	xor a
	ld [wHiddenFigureRightHandStunned], a
	jp .asm_4d5f5
.asm_4d7a4
	ld l, OBJ_Y_POS
	ld a, [hli]
	cp e
	jr nz, .asm_4d7ae
	ld a, [hl]
	cp d
	jr z, .asm_4d7b1
.asm_4d7ae
	call MoveObjectUp
.asm_4d7b1
	ld l, OBJ_X_POS + 1
	ld a, [hld]
	cp b
	jr z, .asm_4d7bb
	jr c, .asm_4d7c6
	jr .asm_4d7c1
.asm_4d7bb
	ld a, [hl]
	cp c
	jr z, .asm_4d7c9
	jr c, .asm_4d7c6
.asm_4d7c1
	call MoveObjectLeft
	jr .asm_4d7c9
.asm_4d7c6
	call MoveObjectRight
.asm_4d7c9
	ld a, [wGlobalCounter]
	and %11
	ld hl, wCurObjFlags
	ld a, [hl]
	jr nz, .asm_4d7d8
	set 4, a
	ld [hl], a
	ret
.asm_4d7d8
	res 4, a
	ld [hl], a
	ret

.Default_4d7dc:
	ld hl, wCurObjState
	ld a, $30
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ret

.Land:
	ld hl, wCurObjState
	ld a, $31
	ld [hld], a
	ld a, [wHiddenFigureHandWasGrabbed]
	cp $01
	jr z, .asm_4d7f5
	ld a, $46
.asm_4d7f5
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
	ld a, $2d
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .asm_4d81e
	ld de, Frameset_6a0fe
	jp SetObjectFramesetPtr
.asm_4d81e
	ld de, Frameset_6a0d4
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
	ld a, $38
	jr .asm_4d84c
.Default_4d844:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, $39
.asm_4d84c
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
	ld a, $44
	ld [hld], a
	jr .asm_4d867
.State15:
	ld hl, wCurObjState
	ld a, $45
	ld [hld], a
.asm_4d867
	ld l, OBJ_VAR_2
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ret

.StunLeftStart:
	ld hl, wCurObjState
	ld a, $46
	ld [hld], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, $47
	ld [hld], a
	ret

.StunLeft:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld a, $0f
	ld [wCurObjState], a
	ret

.StunRight:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld a, $0f
	ld [wCurObjState], a
	ret

.PickedUpLeftStart:
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
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
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
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
	ld a, $01
	ld [wHiddenFigureHandWasGrabbed], a
	ld hl, wCurObjState
	ld a, $49
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
	ld a, $48
	ld [hld], a
	ld l, OBJ_FLAGS
	set 2, [hl]
.State48:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	jp .State19
