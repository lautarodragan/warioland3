TeruteruFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Init)
	ld [hld], a
	ld a, LOW(.Init)
	ld [hld], a
	ret

.Init:
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr z, .set_update
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
.set_update
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [hl]
	and $f0
	or $08
	ld [hl], a
	jp .Default

.Update:
	ld hl, wCurObjFlags
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr nz, .visible
	set OBJFLAG_INVISIBLE_F, [hl]
	jr .dispatch
.visible
	res OBJFLAG_INVISIBLE_F, [hl]
.dispatch
	ld a, [wCurObjState]
	jumptable

	dw .Default
	dw .Land
	dw .BumpLeftStart
	dw .BumpRightStart
	dw .AttackedLeftStart
	dw .AttackedRightStart
	dw .PickedUpLeftStart
	dw .PickedUpRightStart
	dw .BumpLeftStart
	dw .BumpRightStart
	dw VanishObject2
	dw .Default
	dw .Default
	dw .Default
	dw .State0e
	dw .State0f
	dw .State10
	dw .Default
	dw .State12
	dw .Default
	dw .State14
	dw .State15
	dw .StunLeftStart
	dw .StunRightStart
	dw .State18
	dw .State19
	dw ObjState_HopStart
	dw ObjState_Hop
	dw ObjState_StartRandomWobble
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
	dw .State29
	dw .Default
	dw .Default
	dw .Default
	dw .Special1
	dw .Special2
	dw .Special3
	dw ObjState_Fall
	dw .Walk
	dw ObjState_BumpLeft
	dw ObjState_BumpRight
	dw ObjState_AttackedLeft
	dw ObjState_AttackedRight
	dw ObjState_PickedUpLeft
	dw ObjState_PickedUpRight
	dw ObjState_Bounce2Right
	dw ObjState_Bounce2Left
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .State3f
	dw .State40
	dw ObjState_StandingFall
	dw ObjState_Drop
	dw .Default
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
	dw ObjState_HitByObjLeft
	dw ObjState_HitByObjRight
	dw .State5a
	dw .State5b
	dw .Default

.State0e:
	ld a, OBJSTATE_5B
	ld [wCurObjState], a
	ret

.State5b:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr nz, .blind_over
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_Y_POS
	ld a, [wWarioYPos + 1]
	sub $0c
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc $00
	ld [hli], a
	ld a, [wWarioXPos + 1]
	ld [hli], a
	ld a, [wWarioXPos + 0]
	ld [hli], a
	ret

.blind_over
	ld a, [wDirection]
	and a
	jp z, .BumpLeftStart
	jp .BumpRightStart

.Special1:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, OBJSTATE_SPECIAL_2
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68b8b
	call SetObjectFramesetPtr
	ld a, 40
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TERUTERU
	ld [hli], a
	ret

.Special2:
	ld hl, wCurObjStateDuration
	dec [hl]
	jr z, .start_rise
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr z, .descend
	jr c, .move_right
	call MoveObjectLeft
	jr .descend
.move_right
	call MoveObjectRight
.descend
	jp MoveObjectDown_Fast
.start_rise
	ld a, OBJSTATE_SPECIAL_3
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68bae
	call SetObjectFramesetPtr
	ld a, 80
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hli], a
	ret

.Special3:
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $3c
	jr nz, .rise
	ld de, TeruteruFrameset_68b90
	call SetObjectFramesetPtr
.rise
	dec [hl]
	jp nz, MoveObjectUp
	jp .resume_walk

.Default:
	ld hl, wCurObjCollBoxRight
	ld a, $06
	ld [hld], a
	ld a, $f9
	ld [hld], a
	ld a, $f1
	ld [hld], a
	ld a, $ec
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .face_right
	res OBJSUBFLAG_HDIR_F, [hl]
	jr .Land
.face_right
	set OBJSUBFLAG_HDIR_F, [hl]
.Land:
	ld hl, wCurObjState
	ld a, OBJSTATE_WALK
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset TeruteruFrameset_68b64, TeruteruFrameset_68b6d
	xor a
	ld [hld], a
	call SetObjectFramesetPtr
	inc l
	ld a, $32
	ld [hl], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hli], a
	ld a, $ec
	ld [hli], a
	ld a, $f1
	ld [hl], a
	ret

.Walk:
	ld a, [wTransformation]
	cp TRANSFORMATION_BLIND
	jr z, .hover
	ld c, $2a
	ld a, [wCurObjScreenYPos]
	add c
	ld b, a
	ld a, [wWarioScreenYPos]
	add c
	sub b
	cp $18
	jr c, .hover
	cp $80
	jr nc, .hover
	ld a, [wWarioScreenXPos]
	add c
	ld b, a
	ld a, [wCurObjScreenXPos]
	add c
	sub b
	cp $e8
	jr nc, .start_swoop
	cp $18
	jr nc, .hover
.start_swoop
	ld a, OBJSTATE_SPECIAL_1
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68b84
	call SetObjectFramesetPtr
	ld a, 20
	ld [hli], a
	ret

.hover
	ld bc, HoverYVel
	call ApplyObjYMovement_Loop
	ld hl, wCurObjVar1
	ld a, [wCurObjSubState]
	rlca
	jr c, .moving_right
	dec [hl]
	ld a, [hl]
	and a
	jp nz, MoveObjectLeft
	ld de, TeruteruFrameset_68b76
	jr .start_turn
.moving_right
	inc [hl]
	ld a, [hl]
	cp $64
	jp nz, MoveObjectRight
	ld de, TeruteruFrameset_68b7d
.start_turn
	call SetObjectFramesetPtr
	ld a, 26
	ld [hli], a
	ld a, OBJSTATE_5A
	ld [wCurObjState], a
	ret

.State5a:
	ld bc, HoverYVel
	call ApplyObjYMovement_Loop
	ld hl, wCurObjStateDuration
	ld a, [hl]
	cp $09
	jr z, .turn_around
	dec [hl]
	jr z, .resume_walk
	ret

.turn_around
	dec [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	rlca
	jr c, .turn_left
	set OBJSUBFLAG_HDIR_F, [hl]
	ret

.turn_left
	res OBJSUBFLAG_HDIR_F, [hl]
	ret

.resume_walk
	ld l, OBJ_STATE
	ld a, OBJSTATE_WALK
	ld [hld], a
	ld a, [hld]
	rlca
	jr c, .walk_right
	ld de, TeruteruFrameset_68b64
	jp SetObjectFramesetPtr
.walk_right
	ld de, TeruteruFrameset_68b6d
	jp SetObjectFramesetPtr

.StunLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_LEFT
	ld [hld], a
	call DecrementRemainingBossHits
	ld a, [hl]
	and $0f
	dec a
	jp z, VanishObject2
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
.StunLeft:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideLeft
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.StunRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_STUN_RIGHT
	ld [hld], a
	call DecrementRemainingBossHits
	ld a, [hl]
	and $0f
	dec a
	jp z, VanishObject2
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
.StunRight:
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jp nz, ObjState_BumpSlideRight
	ld a, OBJSTATE_STUNNED_START
	ld [wCurObjState], a
	ret

.State14:
	ld a, OBJSTATE_FALL_LEFT
	ld [wCurObjState], a
	jr .set_fall
.State15:
	ld a, OBJSTATE_FALL_RIGHT
	ld [wCurObjState], a
.set_fall
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_VAR_2
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hli], a
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ret

.State0f:
	ld a, OBJSTATE_STUNNED
	ld [wCurObjState], a
	ld a, $64
	ld [wCurObjStateDuration], a
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $08
	ld [hl], a
.State3f:
	ld a, [wGroundShakeCounter]
	cp $10
	jr c, .count_down
	ld a, OBJSTATE_RANDOM_WOBBLE_START
	ld [wCurObjState], a
	ret

.count_down
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrDrop
	ld a, OBJSTATE_RECOVER_START
	ld [wCurObjState], a
	ret

.State10:
	ld hl, wCurObjState
	ld a, OBJSTATE_RECOVER
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld de, TeruteruFrameset_68b99
	call SetObjectFramesetPtr
	ld a, 80
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_TOUCH
	ld [hli], a
	ld a, $ec
	ld [hli], a
	ld a, $f1
	ld [hl], a
.State40:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, MoveObjectUp
	ld a, OBJSTATE_DEFAULT
	ld [wCurObjState], a
	ret

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
	ld [hld], a
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld a, 4
	ld [hli], a
	inc l
	ld a, $02
	ld [hli], a
	xor a
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hli], a
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ret

.State29:
	ld hl, wCurObjState
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT
	ld [hld], a
	ld b, $02
	jr .set_knocked_back
.State28:
	ld hl, wCurObjState
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT
	ld [hld], a
	ld b, $02
	jr .set_knocked_back
.AttackedLeftStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_LEFT
	ld [hld], a
	ld b, $02
	jr .set_knocked_back
.AttackedRightStart:
	ld hl, wCurObjState
	ld a, OBJSTATE_ATTACKED_RIGHT
	ld [hld], a
	ld b, $02
.set_knocked_back
	ld a, [hl]
	and $f0
	ld [hld], a
	xor a
	ld [hld], a
	ld a, b
	ld [hld], a
	ld de, TeruteruFrameset_68ba2
	call SetObjectFramesetPtr
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret

.PickedUpLeftStart:
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
	ld a, OBJSTATE_GRABBED_RIGHT
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_TOP
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	or $08
	ld [hl], a
.State49:
	ld a, [wDirection]
	and a
	jp nz, ObjState_GrabbedRight
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	jr .State18

.State18:
	ld a, OBJSTATE_GRABBED_LEFT
	ld [wCurObjState], a
	ld de, TeruteruFrameset_68ba5
	call SetObjectFramesetPtr
	ld l, OBJ_COLLBOX_TOP
	ld a, $f9
	ld [hli], a
	ld a, $ff
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_GRABBED_F, [hl]
.State48:
	ld a, [wDirection]
	and a
	jp z, ObjState_GrabbedLeft
	ld hl, wCurObjSubState
	ld a, [hl]
	xor OBJSUBFLAG_HDIR
	ld [hl], a
	jp .State19

.State12:
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_DROP
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hld], a
	ret
