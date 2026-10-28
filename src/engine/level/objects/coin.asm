DEF x = 1

; \1 = movement update state
; \2 = duration
; \3 = y movement table
MACRO move_coin
.Move{u:x}Start:
	ld hl, wCurObjState
	ld a, \1
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, \2
	ld [wCurObjStateDuration], a
.Move{u:x}:
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(\3)
	add LOW(\3)
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .continue_movement_{u:x}
	dec c
	ld a, [bc]
	jr .got_y_vel_{u:x}
.continue_movement_{u:x}
	inc [hl]
.got_y_vel_{u:x}
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative_{u:x}
	add c
	ld [hli], a
	jr nc, :+
	inc [hl]
	jr :+
.negative_{u:x}
	add c
	ld [hli], a
	jr c, :+
	dec [hl]
:

DEF x = x + 1
ENDM

CoinFunc:
	ld a, [wGlobalCounter]
	dec a
	and %111111
	jr nz, .regular_coin
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_COLOUR_COIN
	ld [hli], a

.ColourCoin:
	play_sfx SFX_SPARKLE
	ld a, 8
	jr .got_frame
.regular_coin
	ld a, 0 ; can be xor a

.got_frame
	ld [wCurObjFrame], a
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]

.Update:
	ld hl, wCurObjFrameDuration
	ld a, 2
	ld [hli], a
	ld a, [hl] ; state duration
	and a
	jr z, .animate
	ld a, [wGlobalCounter]
	rra
	ret c
.animate
	ld hl, wCurObjVar1
	ld a, [hl]
	cp 150
	jr c, .not_slow
; slow
	ld b, 4
	jr .got_animation_speed
.not_slow
	inc a
	ld [hl], a
	cp 100
	jr c, .not_medium_slow
; medium slow
	ld b, 3
	jr .got_animation_speed
.not_medium_slow
	cp 50
	jr c, .fast
; medium fast
	ld b, 2
	jr .got_animation_speed
.fast
	ld b, 1
.got_animation_speed
	ld l, OBJ_FRAMESET_PTR
	dec [hl]
	jr nz, .state_table
	ld a, b
	ld [hli], a
	dec [hl] ; OBJ_FRAMESET_PTR + 1
	jr nz, .next_frame
	ld b, 8
	ld [hl], b ; OBJ_FRAMESET_PTR + 1
	ld l, OBJ_FRAME
	ld a, [hl]
	sub 7
	ld [hl], a
	jr .state_table
.next_frame
	ld l, OBJ_FRAME
	inc [hl]

.state_table
	ld a, [wCurObjState]
	jumptable

	dw .Move2Start ; $00
	dw .Move5Start ; $01
	dw .Move2 ; $02
	dw .Move5 ; $03
	dw .Move3Start ; $04
	dw .Move6Start ; $05
	dw .Move3 ; $06
	dw .Move6 ; $07
	dw .Move1Start ; $08
	dw .Move4Start ; $09
	dw .Move1 ; $0a
	dw .Move4 ; $0b
	dw .FallLeftStart ; $0c
	dw .FallRightStart ; $0d
	dw .FallLeft ; $0e
	dw .FallRight ; $0f
	dw .State10 ; $10
	dw .State11 ; $11
	dw .State12 ; $12
	dw .State13 ; $13
	dw .State14 ; $14
	dw .State15 ; $15
	dw .State16 ; $16
	dw .State17 ; $17
	dw .State18 ; $18
	dw .Init ; $19
	dw .StartMovement ; $1a

.Init:
	ld hl, wCurObjAction
	ld a, 15 | (1 << 7)
	ld [hld], a
	ld a, $1a
	ld [hl], a ; OBJ_STATE
	ld l, OBJ_FLAGS
	set OBJFLAG_NO_COLLISION_F, [hl]
	ret

.StartMovement:
	ld c, $2a
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	jr c, .on_left
; on right
	ld a, $07
	ld [wCurObjState], a
	ret
.on_left
	ld a, $06
	ld [wCurObjState], a
	ret

	; move left
	move_coin $0a, 6, Bounce3YVel_Light
	jp .move_left
	move_coin $02, 4, Bounce1YVel_Light
	jr .move_left
	move_coin $06, 5, Bounce2YVel_Light
.move_left
	call MoveObjectLeftByVar2
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	sub 4
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr nz, .set_fall_right
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $0c
	ld [wCurObjState], a
	ret
.set_fall_right
	ld a, $0d
	ld [wCurObjState], a
	ret

	; move right
	move_coin $0b, 6, Bounce3YVel_Light
	jp .move_right
	move_coin $03, 4, Bounce1YVel_Light
	jr .move_right
	move_coin $07, 5, Bounce2YVel_Light
.move_right
	call MoveObjectRightByVar2
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	add 3
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr nz, .set_fall_left
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $0d
	ld [wCurObjState], a
	ret
.set_fall_left
	ld a, $0c
	ld [wCurObjState], a
	ret

.FallLeftStart:
	ld hl, wCurObjState
	ld a, $0e
	ld [hld], a
	dec l
	xor a
	ld [hld], a
.FallLeft:
	call MoveObjectLeftByVar2
	ld l, OBJ_VAR_3
	ld a, [hl]
	ld b, HIGH(FallingYVel_Light)
	add LOW(FallingYVel_Light)
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .continue_fall_left
	dec c
	ld a, [bc]
	jr .got_y_vel_fall_left
.continue_fall_left
	inc [hl]
.got_y_vel_fall_left
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .fall_left_negative_vel
	add c
	ld [hli], a
	jr nc, .fall_left_check_floor
	inc [hl]
	jr .fall_left_check_floor
.fall_left_negative_vel
	add c
	ld [hli], a
	jr c, .fall_left_check_floor
	dec [hl]
.fall_left_check_floor
	ld l, OBJ_Y_POS
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
	jr nz, .fall_left_landed
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .fall_left_check_wall
	ld [wCurObjFramesetOffset], a
.fall_left_check_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	sub 4
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	ret z
	ld a, $0d
	ld [wCurObjState], a
	ret
.fall_left_landed
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jr z, .fall_left_pick_bounce
	dec [hl]
.fall_left_pick_bounce
	ldh a, [hTemp]
	cp 2
	jr c, .fall_left_slide
	cp 3
	jr c, .fall_left_small_bounce
	cp 4
	jr c, .fall_left_medium_bounce
	ld a, $08
	ld [wCurObjState], a
	ret
.fall_left_slide
	ld a, $10
	ld [wCurObjState], a
	ret
.fall_left_small_bounce
	ld a, $00
	ld [wCurObjState], a
	ret
.fall_left_medium_bounce
	ld a, $04
	ld [wCurObjState], a
	ret

.FallRightStart:
	ld hl, wCurObjState
	ld a, $0f
	ld [hld], a
	dec l
	xor a
	ld [hld], a
.FallRight:
	call MoveObjectRightByVar2
	ld l, OBJ_VAR_3
	ld a, [hl]
	ld b, HIGH(FallingYVel_Light)
	add LOW(FallingYVel_Light)
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .continue_fall_right
	dec c
	ld a, [bc]
	jr .got_y_vel_fall_right
.continue_fall_right
	inc [hl]
.got_y_vel_fall_right
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .fall_right_negative_vel
	add c
	ld [hli], a
	jr nc, .fall_right_check_floor
	inc [hl]
	jr .fall_right_check_floor
.fall_right_negative_vel
	add c
	ld [hli], a
	jr c, .fall_right_check_floor
	dec [hl]
.fall_right_check_floor
	ld l, OBJ_Y_POS
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
	jr nz, .fall_right_landed
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .fall_right_check_wall
	ld [wCurObjFramesetOffset], a
.fall_right_check_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	add 3
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	ret z
	ld a, $0c
	ld [wCurObjState], a
	ret
.fall_right_landed
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_VAR_2
	ld a, [hl]
	and a
	jr z, .fall_right_pick_bounce
	dec [hl]
.fall_right_pick_bounce
	ldh a, [hTemp]
	cp 2
	jr c, .fall_right_slide
	cp 3
	jr c, .fall_right_small_bounce
	cp 4
	jr c, .fall_right_medium_bounce
	ld a, $09
	ld [wCurObjState], a
	ret
.fall_right_slide
	ld a, $11
	ld [wCurObjState], a
	ret
.fall_right_small_bounce
	ld a, $01
	ld [wCurObjState], a
	ret
.fall_right_medium_bounce
	ld a, $05
	ld [wCurObjState], a
	ret

.State10:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jr nz, .sliding_left
	ld a, $12
	ld [wCurObjState], a
	ret
.sliding_left
	ld a, [wGlobalCounter]
	and %11111
	jr nz, .slide_left_check_wall
	dec [hl]
.slide_left_check_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	sub 4
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr nz, .slide_left_hit_wall
	call MoveObjectLeftByVar2
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Down
	cp $10
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ret z
	ld hl, wCurObjXPos
	ld a, [hli]
	sub 4
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	ret nz
	ld hl, wCurObjXPos
	ld a, [hli]
	add 3
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	ret nz
	ld a, $0c
	ld [wCurObjState], a
	ret
.slide_left_hit_wall
	ld a, $11
	ld [wCurObjState], a
	ret

.State11:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jr nz, .sliding_right
	ld a, $12
	ld [wCurObjState], a
	ret
.sliding_right
	ld a, [wGlobalCounter]
	and %11111
	jr nz, .slide_right_check_wall
	dec [hl]
.slide_right_check_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	add 3
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr nz, .slide_right_hit_wall
	call MoveObjectRightByVar2
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Down
	cp $10
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ret z
	ld hl, wCurObjXPos
	ld a, [hli]
	add 3
	ldh [hXPosLo], a
	ld a, [hli]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	ret nz
	ld hl, wCurObjXPos
	ld a, [hli]
	sub 4
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	ret nz
	ld a, $0d
	ld [wCurObjState], a
	ret
.slide_right_hit_wall
	ld a, $10
	ld [wCurObjState], a
	ret

.State12:
	ld a, $13
	ld [wCurObjState], a
	ld a, [wCurObjFramesetOffset]
	and a
	jr nz, .rest_in_water
	ld a, 100
	ld [wCurObjStateDuration], a
	ret
.rest_in_water
	ld a, 50
	ld [wCurObjStateDuration], a
	ret

.State13:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .rest_over
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	call ProcessBlock_Down
	and a
	ret nz
	ld a, $14
	ld [wCurObjState], a
	ret
.rest_over
	ld a, $16
	ld [wCurObjState], a
	ret

.State16:
	ld a, $17
	ld [wCurObjState], a
	ld a, [wCurObjFramesetOffset]
	and a
	jr nz, .blink_in_water
	ld a, 100
	ld [wCurObjStateDuration], a
	ret
.blink_in_water
	ld a, 50
	ld [wCurObjStateDuration], a
	ret

.State17:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	and a
	jr z, .State18
	dec a
	ld [hl], a
	and $03
	ld l, OBJ_FLAGS
	ld a, [hl]
	jr nz, .blink_visible
	res OBJFLAG_ON_SCREEN_F, a
	set OBJFLAG_INVISIBLE_F, a
	ld [hl], a
	ret
.blink_visible
	res OBJFLAG_INVISIBLE_F, a
	ld [hl], a
	ret
.State18:
	xor a
	ld [wCurObjFlags], a
	ret

.State14:
	ld hl, wCurObjState
	ld a, $15
	ld [hld], a
	dec l
	xor a
	ld [hld], a
.State15:
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, $40
	add $40
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .continue_drop
	dec c
	ld a, [bc]
	jr .got_drop_vel
.continue_drop
	inc [hl]
.got_drop_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .drop_negative_vel
	add c
	ld [hli], a
	jr nc, .drop_check_floor
	inc [hl]
	jr .drop_check_floor
.drop_negative_vel
	add c
	ld [hli], a
	jr c, .drop_check_floor
	dec [hl]
.drop_check_floor
	ld l, OBJ_Y_POS
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
	jr z, .drop_check_water
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld a, $12
	ld [wCurObjState], a
.drop_check_water
	ld a, [wIsInWaterOrSand]
	and a
	ret z
	ld [wCurObjFramesetOffset], a
	ret
