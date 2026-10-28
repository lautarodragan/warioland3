INCLUDE "data/object_movements.asm"

UpdateObject_Temple:
	push hl
	inc l
	rla
	ld [wCurObjFlags], a
FOR n, 1, OBJ_STRUCT_LENGTH - 1
	ld a, [hli]
	ld [wCurObj + n], a
ENDR
	ld a, [hl]
	ld [wCurObj + OBJ_STRUCT_LENGTH - 1], a

	call DoObjectAction

	ld a, BANK("Object Functions 4")
	ldh [hCallFuncBank], a
	ld a, [wCurObjUpdateFunction + 0]
	ldh [hCallFuncPointer + 0], a
	ld a, [wCurObjUpdateFunction + 1]
	ldh [hCallFuncPointer + 1], a
	call hCallFunc

	call UpdateObjectAnimation
	call CheckObjectOnScreen

	ld hl, wCurObjScreenYPos
	ld a, [wSCY]
	ld b, a
	ld a, [wCurObjYPos + 0]
	add OAM_Y_OFS
	sub b
	ld [hli], a
	ld a, [wSCX]
	ld b, a
	ld a, [wCurObjXPos]
	add OAM_X_OFS
	sub b
	ld [hli], a

	ld hl, wSCYShake
	ld a, [wHiddenFigureSCYShake]
	add [hl]
	ld [wSCY], a
	ld a, [wHiddenFigureSCX]
	ld [wSCX], a
	pop hl

	ld a, [wCurObjFlags]
	and $ff ^ (OBJFLAG_STEPPED)
	ld [hli], a
	inc l
	inc l
	ld a, [wCurObjYPos + 0]
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	ld [hli], a
	ld a, [wCurObjXPos]
	ld [hli], a
	ld a, [wCurObjXPos + 1]
	ld [hli], a
	ld a, [wCurObjId]
	ld [hli], a
	ld a, [wCurObjInteractionType]
	ld [hli], a
	ld a, [wCurObjCollBoxTop]
	ld [hli], a
	ld a, [wCurObjCollBoxBottom]
	ld [hli], a
	ld a, [wCurObjCollBoxLeft]
	ld [hli], a
	ld a, [wCurObjCollBoxRight]
	ld [hli], a
	ld a, [wCurObjScreenYPos]
	ld [hli], a
	ld a, [wCurObjScreenXPos]
	ld [hli], a
	ld a, [wCurObjFrame]
	ld [hli], a
	ld a, [wCurObjOAMPtr + 0]
	ld [hli], a
	ld a, [wCurObjOAMPtr + 1]
	ld [hli], a
	ld a, [wCurObjFramesetPtr + 0]
	ld [hli], a
	ld a, [wCurObjFramesetPtr + 1]
	ld [hli], a
	ld a, [wCurObjFrameDuration + 0]
	ld [hli], a
	ld a, [wCurObjFrameDuration + 1]
	ld [hli], a
	ld a, [wCurObjStateDuration]
	ld [hli], a
	ld a, [wCurObjVar1]
	ld [hli], a
	ld a, [wCurObjVar2]
	ld [hli], a
	ld a, [wCurObjVar3]
	ld [hli], a
	ld a, [wCurObjSubState]
	ld [hli], a
	ld a, [wCurObjState]
	ld [hli], a
	ld a, [wCurObjAction]
	ld [hli], a
	inc l
	ld a, [wCurObjUpdateFunction + 0]
	ld [hli], a
	ld a, [wCurObjUpdateFunction + 1]
	ld [hl], a
	ret

UpdateObjects_Temple:
	call HandleGrabbedObjectCollisions

	ld hl, wObj1Flags
	ld a, [hl]
	rra
	call c, UpdateObject_Temple
FOR n, 2, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n}Flags)
	ld a, [hl]
	rra
	call c, UpdateObject_Temple ; OBJFLAG_ACTIVE_F set
ENDR
	ret

UpdateObjects:
	ld a, [wPowerUpLevel]
	ld e, a
	ld a, [wTransformation]
	rla
	jr nc, .got_effective_power_up
	; TRANSFORMATIONF_SUPER_SMASH_F is set
	ld e, SUPER_JUMP_SLAM_OVERALLS
.got_effective_power_up
	ld a, e
	ld [wEffectivePowerUp], a

	ld a, [wLevel]
	cp THE_TEMPLE
	jr z, UpdateObjects_Temple
	ld a, [wIsFloorTransition]
	and a
	jr nz, .floor_transition

	call HandleGrabbedObjectCollisions
	ld hl, wObj1Flags
	ld a, [hl]
	rra
	call c, UpdateObject ; OBJFLAG_ACTIVE_F set
FOR n, 2, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n}Flags)
	ld a, [hl]
	rra
	call c, UpdateObject ; OBJFLAG_ACTIVE_F set
ENDR
	ret

.floor_transition
	ld hl, wObj1Flags
	ld a, [hl]
	rra
	call c, UpdateObjectDuringFloorTransition
FOR n, 2, NUM_OBJECTS + 1
	ld l, LOW(wObj{u:n}Flags)
	ld a, [hl]
	rra
	call c, UpdateObjectDuringFloorTransition ; OBJFLAG_ACTIVE_F set
ENDR
	ret

UpdateObject:
	push hl
	inc l
	rla
	ld [wCurObjFlags], a
FOR n, 1, OBJ_STRUCT_LENGTH - 1
	ld a, [hli]
	ld [wCurObj + n], a
ENDR
	ld a, [hl]
	ld [wCurObj + OBJ_STRUCT_LENGTH - 1], a

	call DoObjectAction

; call update function
	ld a, [wCurObjId]
	swap a
	and $0f
	or BANK("Object Functions 1")
	ldh [hCallFuncBank], a
	ld a, [wCurObjUpdateFunction + 0]
	ldh [hCallFuncPointer], a
	ld a, [wCurObjUpdateFunction + 1]
	ldh [hCallFuncPointer + 1], a
	call hCallFunc

	call UpdateObjectAnimation
	call CheckObjectOnScreen

	ld hl, wCurObjScreenYPos
	ld a, [wSCY]
	ld b, a
	ld a, [wCurObjYPos + 0]
	add OAM_Y_OFS
	sub b
	ld [hli], a
	ld a, [wSCX]
	ld b, a
	ld a, [wCurObjXPos]
	add OAM_X_OFS
	sub b
	ld [hli], a
	pop hl

	ld a, [wCurObjFlags]
	and $ff ^ (OBJFLAG_STEPPED)
	ld [hli], a
	inc l
	inc l
	ld a, [wCurObjYPos + 0]
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	ld [hli], a
	ld a, [wCurObjXPos]
	ld [hli], a
	ld a, [wCurObjXPos + 1]
	ld [hli], a
	ld a, [wCurObjId]
	ld [hli], a
	ld a, [wCurObjInteractionType]
	ld [hli], a
	ld a, [wCurObjCollBoxTop]
	ld [hli], a
	ld a, [wCurObjCollBoxBottom]
	ld [hli], a
	ld a, [wCurObjCollBoxLeft]
	ld [hli], a
	ld a, [wCurObjCollBoxRight]
	ld [hli], a
	ld a, [wCurObjScreenYPos]
	ld [hli], a
	ld a, [wCurObjScreenXPos]
	ld [hli], a
	ld a, [wCurObjFrame]
	ld [hli], a
	ld a, [wCurObjOAMPtr + 0]
	ld [hli], a
	ld a, [wCurObjOAMPtr + 1]
	ld [hli], a
	ld a, [wCurObjFramesetPtr + 0]
	ld [hli], a
	ld a, [wCurObjFramesetPtr + 1]
	ld [hli], a
	ld a, [wCurObjFrameDuration + 0]
	ld [hli], a
	ld a, [wCurObjFrameDuration + 1]
	ld [hli], a
	ld a, [wCurObjStateDuration]
	ld [hli], a
	ld a, [wCurObjVar1]
	ld [hli], a
	ld a, [wCurObjVar2]
	ld [hli], a
	ld a, [wCurObjVar3]
	ld [hli], a
	ld a, [wCurObjSubState]
	ld [hli], a
	ld a, [wCurObjState]
	ld [hli], a
	ld a, [wCurObjAction]
	ld [hli], a
	inc l
	ld a, [wCurObjUpdateFunction + 0]
	ld [hli], a
	ld a, [wCurObjUpdateFunction + 1]
	ld [hl], a
	ret

UpdateObjectDuringFloorTransition:
	push hl
	inc l
	rla
	ld [wCurObjFlags], a
FOR n, 1, OBJ_STRUCT_LENGTH - 1
	ld a, [hli]
	ld [wCurObj + n], a
ENDR
	ld a, [hl]
	ld [wCurObj + OBJ_STRUCT_LENGTH - 1], a

	; during a floor transition, only run the update function
	; of objects that are still uninitialised (to set them up)
	ld hl, wCurObjSubState
	bit OBJSUBFLAG_UNINITIALISED_F, [hl]
	jr z, .skip_update_function
	; init object
	ld a, [wCurObjId]
	swap a
	and $0f
	or BANK("Object Functions 1")
	ldh [hCallFuncBank], a
	ld a, [wCurObjUpdateFunction + 0]
	ldh [hCallFuncPointer], a
	ld a, [wCurObjUpdateFunction + 1]
	ldh [hCallFuncPointer + 1], a
	call hCallFunc

.skip_update_function
	call UpdateObjectFrame
	call CheckObjectOnScreen

	ld hl, wCurObjScreenYPos
	ld a, [wSCY]
	ld b, a
	ld a, [wCurObjYPos + 0]
	add OAM_Y_OFS
	sub b
	ld [hli], a
	ld a, [wSCX]
	ld b, a
	ld a, [wCurObjXPos]
	add OAM_X_OFS
	sub b
	ld [hli], a
	pop hl
	ld a, [wCurObjFlags]
	and $ff ^ (OBJFLAG_STEPPED)
	ld [hli], a
	inc l
	inc l
	ld a, [wCurObjYPos + 0]
	ld [hli], a
	ld a, [wCurObjYPos + 1]
	ld [hli], a
	ld a, [wCurObjXPos]
	ld [hli], a
	ld a, [wCurObjXPos + 1]
	ld [hli], a
	ld a, [wCurObjId]
	ld [hli], a
	ld a, [wCurObjInteractionType]
	ld [hli], a
	ld a, [wCurObjCollBoxTop]
	ld [hli], a
	ld a, [wCurObjCollBoxBottom]
	ld [hli], a
	ld a, [wCurObjCollBoxLeft]
	ld [hli], a
	ld a, [wCurObjCollBoxRight]
	ld [hli], a
	ld a, [wCurObjScreenYPos]
	ld [hli], a
	ld a, [wCurObjScreenXPos]
	ld [hli], a
	ld a, [wCurObjFrame]
	ld [hli], a
	ld a, [wCurObjOAMPtr + 0]
	ld [hli], a
	ld a, [wCurObjOAMPtr + 1]
	ld [hli], a
	ld a, [wCurObjFramesetPtr + 0]
	ld [hli], a
	ld a, [wCurObjFramesetPtr + 1]
	ld [hli], a
	ld a, [wCurObjFrameDuration + 0]
	ld [hli], a
	ld a, [wCurObjFrameDuration + 1]
	ld [hli], a
	ld a, [wCurObjStateDuration]
	ld [hli], a
	ld a, [wCurObjVar1]
	ld [hli], a
	ld a, [wCurObjVar2]
	ld [hli], a
	ld a, [wCurObjVar3]
	ld [hli], a
	ld a, [wCurObjSubState]
	ld [hli], a
	ld a, [wCurObjState]
	ld [hli], a
	ld a, [wCurObjAction]
	ld [hli], a
	inc l
	ld a, [wCurObjUpdateFunction]
	ld [hli], a
	ld a, [wCurObjUpdateFunction + 1]
	ld [hl], a
	ret

DrawObjects_WithPriority::
FOR n, 1, NUM_OBJECTS + 1
	ld hl, wObj{u:n}Flags
	ld a, [hl]
	and OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN | OBJFLAG_INVISIBLE | OBJFLAG_PRIORITY
	cp OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN | OBJFLAG_PRIORITY
	jr nz, :+
	; if (OBJFLAG_ACTIVE && OBJFLAG_ON_SCREEN && !OBJFLAG_INVISIBLE && OBJFLAG_PRIORITY)
	ld e, LOW(wObj{u:n}ScreenYPos)
	ld l, LOW(wObj{u:n}Id)
	call UpdateObjSprite
:
ENDR
	ret

DrawObjects_NoPriority::
FOR n, 1, NUM_OBJECTS + 1
	ld hl, wObj{u:n}Flags
	ld a, [hl]
	and OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN | OBJFLAG_INVISIBLE | OBJFLAG_PRIORITY
	cp OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN
	jr nz, :+
	; if (OBJFLAG_ACTIVE && OBJFLAG_ON_SCREEN && !OBJFLAG_INVISIBLE && !OBJFLAG_PRIORITY)
	ld e, LOW(wObj{u:n}ScreenYPos)
	ld l, LOW(wObj{u:n}Id)
	call UpdateObjSprite
:
ENDR
	ret

DoObjectAction:
	ld a, [wCurObjAction]
	and a
	ret z
	bit NO_ACTIONS_F, a
	jr z, .jump
	dec a
	cp no_actions_for 0
	jr nz, .store_counter
	xor a
.store_counter
	ld [wCurObjAction], a
	ret

.jump
	jumptable

.table
	table_width 2
	dw .None ; OBJACTION_NONE
	dw .Bump ; OBJACTION_BUMP
	dw .Attack ; OBJACTION_ATTACK
	dw .PickUp ; OBJACTION_PICK_UP
	dw .Wobble ; OBJACTION_WOBBLE
	dw .VanishTouch ; OBJACTION_VANISH_TOUCH
	dw .HitWario ; OBJACTION_HIT_WARIO
	dw .Trigger ; OBJACTION_TRIGGER
	dw VanishObject_NoSFX ; OBJACTION_VANISH_TREASURE
	dw .StepOn ; OBJACTION_STEP_ON
	dw .Pause ; OBJACTION_PAUSE
	dw .Flatten ; OBJACTION_FLATTEN
	dw .PickUpWario ; OBJACTION_PICK_UP_WARIO
	dw .NoEffect ; OBJACTION_NO_EFFECT
	dw .LightTorch ; OBJACTION_LIGHT_TORCH
	dw .SmashAttackWalkable ; OBJACTION_SMASH_ATTACK_WALKABLE
	dw .Teleport ; OBJACTION_TELEPORT
	dw .Swallow ; OBJACTION_SWALLOW
	dw .HitWarioShort ; OBJACTION_HIT_WARIO_SHORT
	dw .Special3 ; OBJACTION_SPECIAL_3
	assert_table_length NUM_OBJ_ACTIONS

.Special3:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_SPECIAL_3
	ld [hl], a ; OBJ_STATE
	ret

.None:
	ret

.Bump:
	ld a, [wCurObjInteractionType]
	and INTERACTION_MASK
	jr z, .Wobble
	ld hl, wCurObjActionSide
	ld a, [hld]
	and INTERACTION_RIGHT
	ld a, no_actions_for 15
	ld [hld], a ; OBJ_ACTION
	jr z, .bump_right
	ld a, OBJSTATE_BUMP_LEFT_START
	ld [hl], a ; OBJ_STATE
	ret
.bump_right
	ld a, OBJSTATE_BUMP_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ret

.Attack:
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_ACTION_SIDE
	ld a, [hld]
	and INTERACTION_RIGHT
	ld a, no_actions_for 15
	ld [hld], a ; OBJ_ACTION
	jr z, .attack_right
	ld a, OBJSTATE_ATTACKED_LEFT_START
	ld [hl], a ; OBJ_STATE
	ret
.attack_right
	ld a, OBJSTATE_ATTACKED_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ret

.PickUp:
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld a, [wDirection]
	and a
	ld l, OBJ_ACTION
	ld a, no_actions_for 15
	ld [hld], a ; OBJ_ACTION
	jr z, .pick_up_right
	ld a, OBJSTATE_PICKED_UP_LEFT_START
	ld [hl], a ; OBJ_STATE
	ret
.pick_up_right
	ld a, OBJSTATE_PICKED_UP_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ret

.Wobble:
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_ACTION_SIDE
	ld a, [hld]
	and INTERACTION_RIGHT
	ld a, no_actions_for 15
	ld [hld], a ; OBJ_ACTION
	jr z, .wobble_right
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [hl], a ; OBJ_STATE
	ret
.wobble_right
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ret

.VanishTouch:
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_ACTION
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_VANISH_TOUCH
	ld [hl], a
	ret

.HitWarioShort:
	ld b, no_actions_for 7
	jr .hit_wario
.HitWario:
	ld b, no_actions_for 15
.hit_wario
	ld hl, wCurObjActionSide
	ld a, [hld]
	ld [hl], b ; OBJ_ACTION
	dec l
	rla
	jr nc, .check_interaction_up
; interaction down
	ld a, OBJSTATE_HIT_WARIO_DOWN_START
	ld [hl], a ; OBJ_STATE
	ret
.check_interaction_up
	rla
	jr nc, .check_interaction_right
	ld a, OBJSTATE_HIT_WARIO_UP_START
	ld [hl], a ; OBJ_STATE
	ret
.check_interaction_right
	rla
	jr nc, .interaction_left
	ld a, OBJSTATE_HIT_WARIO_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ret
.interaction_left
	ld a, OBJSTATE_HIT_WARIO_LEFT_START
	ld [hl], a ; OBJ_STATE
	ret

.Trigger:
	ld hl, wCurObjAction
	xor a
	ld [hld], a
	ld a, OBJSTATE_TRIGGERED
	ld [hl], a ; OBJ_STATE
	ret

.StepOn:
	ld hl, wCurObjAction
	xor a
	ld [hl], a
	ld l, OBJ_FLAGS
	set OBJFLAG_STEPPED_F, [hl]
	ret

.Pause:
	ld a, no_actions_for 15
	ld [wCurObjAction], a
	ret

.Flatten:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_ACTIVATE
	ld [hl], a ; OBJ_STATE
	ret

.PickUpWario:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_ACTIVATE
	ld [hl], a
	ret

.NoEffect:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_NO_EFFECT
	ld [hl], a
	ret

.LightTorch:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_ACTIVATE
	ld [hl], a
	ret

.SmashAttackWalkable:
	ld hl, wCurObjAction
	ld a, no_actions_for 2
	ld [hld], a
	ld a, OBJSTATE_VANISH_TOUCH
	ld [hl], a
	ret

.Teleport:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_ACTIVATE
	ld [hl], a
	ret

.Swallow:
	ld hl, wCurObjAction
	ld a, no_actions_for 15
	ld [hld], a
	ld a, OBJSTATE_ACTIVATE
	ld [hl], a
	ret

_VanishObject::
	play_sfx SFX_VANISH
VanishObject_NoSFX:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(StarsFunc)
	ld [hld], a
	ld a, LOW(StarsFunc)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and OBJSUBFLAGS_MASK
	ld [hld], a
SetObjStarsSprite:
	ld a, (BANK(StarsFunc) - BANK("Object Functions 1")) << 4
	ld [wCurObjId], a

	ld hl, wCurObjOAMPtr
	ld a, LOW(ChestsOAM_18c000)
	ld [hli], a ; OBJ_OAM_PTR
	ld a, HIGH(ChestsOAM_18c000)
	ld [hli], a
	ld a, LOW(StarsFrameset_680c5)
	ld [hli], a ; OBJ_FRAMESET_PTR
	ld a, HIGH(StarsFrameset_680c5)
	ld [hli], a
	xor a
	ld [hli], a ; OBJ_FRAME_DURATION
	ld [hli], a ; OBJ_FRAMESET_OFFSET
	ld a, 33
	ld [hli], a ; OBJ_STATE_DURATION

	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld a, no_actions_for 1
	ld [wCurObjAction], a

	ld l, OBJ_Y_POS
	ld a, [hl]
	sub 8
	ld [hli], a
	ret nc
	dec [hl]
	ret

; handles the grabbed object collision
; with other objects
HandleGrabbedObjectCollisions:
	ld hl, wObj1Flags
	ld e, OBJFLAG_ACTIVE | OBJFLAG_GRABBED
	ld a, [hl]
	and e
	cp e
FOR n, 2, NUM_OBJECTS + 1
	jr z, .got_grabbed_obj
	ld l, LOW(wObj{u:n}Flags)
	ld a, [hl]
	and e
	cp e
ENDR
	ret nz

.got_grabbed_obj
	push hl
	ld a, l
	add OBJ_INTERACTION_TYPE - OBJ_FLAGS
	ld l, a
	ld a, [hli] ; OBJ_INTERACTION_TYPE
	ldh [hThrownObjInteractionType], a
	ld a, [hli] ; OBJ_COLLBOX_TOP
	ld b, a
	ld a, [hli] ; OBJ_COLLBOX_BOTTOM
	ld c, a
	ld a, [hli] ; OBJ_COLLBOX_LEFT
	ld d, a
	ld a, [hli] ; OBJ_COLLBOX_RIGHT
	ld e, a
	ld a, [hl] ; OBJ_SCREEN_Y_POS
	add $2a
	add b
	ld b, a
	ld a, [hli] ; OBJ_SCREEN_Y_POS
	add $2a
	add c
	ld c, a
	ld a, [hl] ; OBJ_SCREEN_X_POS
	add $2a
	add d
	ld d, a
	ld a, [hli] ; OBJ_SCREEN_X_POS
	add $2a
	add e
	ld e, a

; b = collision top    + (screen y + $2a)
; c = collision bottom + (screen y + $2a)
; d = collision left   + (screen x + $2a)
; e = collision right  + (screen x + $2a)

	ld a, l
	add OBJ_STATE - (OBJ_SCREEN_X_POS + 1)
	ld l, a
	ld a, [hl] ; OBJ_STATE
	cp OBJSTATE_FULL_THROW_LEFT_START
	jr nc, .full_throw
	cp OBJSTATE_GRABBED_LEFT
	jr nc, .grabbed

.full_throw
	; >= OBJSTATE_FULL_THROW_LEFT_START
	rra
	ld hl, hThrownObjInteractionType
	ld a, [hli]
	jr c, .thrown_right

; thrown left
	rla
	jr c, .is_heavy1
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT_START
	ld [hli], a ; hCollidedObjState_Light
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT_START
	ld [hli], a ; hThrownObjState_Light
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [hli], a ; hCollidedObjState_Heavy
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT_START
	ld [hli], a ; hThrownObjState_Heavy
	jr .check_objs

.is_heavy1
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT_START
	ld [hli], a ; hCollidedObjState_Light
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [hli], a ; hThrownObjState_Light
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT_START
	ld [hli], a ; hCollidedObjState_Heavy
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT_START
	ld [hli], a ; hThrownObjState_Heavy
	jr .check_objs

.thrown_right
	rla
	jr c, .is_heavy2
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT_START
	ld [hli], a ; ; hCollidedObjState_Light
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT_START
	ld [hli], a ; ; hThrownObjState_Light
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [hli], a ; ; hCollidedObjState_Heavy
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT_START
	ld [hli], a ; ; hThrownObjState_Heavy
	jr .check_objs

.is_heavy2
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT_START
	ld [hli], a ; hCollidedObjState_Light
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [hli], a ; hThrownObjState_Light
	ld a, OBJSTATE_HIT_BY_OBJ_RIGHT_START
	ld [hli], a ; hCollidedObjState_Heavy
	ld a, OBJSTATE_HIT_BY_OBJ_LEFT_START
	ld [hli], a ; hThrownObjState_Heavy
	jr .check_objs

.grabbed
	; OBJSTATE_GRABBED_LEFT <= action <= OBJSTATE_GRABBED_CHARGE_RIGHT
	rra
	ld hl, hCollidedObjState_Light
	jr c, .grabbed_right
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [hli], a ; hCollidedObjState_Light
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [hli], a ; hThrownObjState_Light
	jr .check_objs

.grabbed_right
	ld a, OBJSTATE_WOBBLE_LEFT_START
	ld [hli], a ; hCollidedObjState_Light
	ld a, OBJSTATE_WOBBLE_RIGHT_START
	ld [hli], a ; hThrownObjState_Light

.check_objs

FOR n, 1, NUM_OBJECTS + 1
	ld a, [wObj{u:n}Flags]
	and OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN | OBJFLAG_GRABBED | OBJFLAG_NO_COLLISION | OBJFLAG_INVISIBLE
	cp OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN
	jr nz, .next_obj_{u:n}
	ld a, [wObj{u:n}ScreenYPos]
	add $2a
	ld h, a
	ld a, [wObj{u:n}ScreenXPos]
	add $2a
	ld l, a
	ld a, [wObj{u:n}CollBoxBottom]
	add h
	sub b
	jr c, .next_obj_{u:n}
	ld a, [wObj{u:n}CollBoxTop]
	add h
	sub c
	jr nc, .next_obj_{u:n}
	ld a, [wObj{u:n}CollBoxRight]
	add l
	sub d
	jr c, .next_obj_{u:n}
	ld a, [wObj{u:n}CollBoxLeft]
	add l
	sub e
	jr nc, .next_obj_{u:n}
	pop hl

; do collision
	res OBJFLAG_GRABBED_F, [hl]
	ld a, l
	add OBJ_STATE - OBJ_FLAGS
	ld l, a
	ld a, [hl] ; OBJ_STATE
	and $fe
	cp OBJSTATE_GRABBED_CHARGE_LEFT ; or OBJSTATE_GRABBED_CHARGE_RIGHT
	jp z, .CollideWithObject{u:n}
	cp OBJSTATE_GRABBED_LEFT ; or OBJSTATE_GRABBED_RIGHT
	jp z, .CollideWithObject{u:n}
	ld a, [wObj{u:n}InteractionType]
	rla
	jp c, .CollideWithHeavyObject{u:n} ; heavy

	ldh a, [hThrownObjState_Light]
	ld [hl], a ; OBJ_STATE
	ld l, LOW(wObj{u:n}State)
	ld a, [hl]
	and $fe
	cp OBJSTATE_PICKED_UP_LEFT
	jr z, .reset_grab_{u:n}_1
	cp OBJSTATE_GRABBED_LEFT
	jr nz, .skip_reset_grab_{u:n}_1
.reset_grab_{u:n}_1
	xor a
	ld [wGrabState], a
.skip_reset_grab_{u:n}_1
	ldh a, [hCollidedObjState_Light]
	ld [hl], a ; OBJ_STATE
	ld l, LOW(wObj{u:n}Flags)
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_THROWN_OBJECT_HIT
	ret
.next_obj_{u:n}
ENDR
	pop hl
	ret

FOR n, 1, NUM_OBJECTS + 1
; hl = state of thrown object
; hThrownObjState_Light = new state for thrown object
; n = index of collided object
; hCollidedObjState_Light = new state for collided object
.CollideWithObject{u:n}
	xor a
	ld [wGrabState], a
	ldh a, [hThrownObjState_Light]
	ld [hl], a ; OBJ_STATE
	ld l, LOW(wObj{u:n}State)
	ldh a, [hCollidedObjState_Light]
	ld [hl], a
	ld l, LOW(wObj{u:n}Flags)
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_THROWN_OBJECT_HIT
	ret
ENDR

FOR n, 1, NUM_OBJECTS + 1
; hl = state of thrown object
; hThrownObjState_Heavy = new state for thrown object
; n = index of collided object
; hCollidedObjState_Heavy = new state for collided object
.CollideWithHeavyObject{u:n}
	ldh a, [hThrownObjState_Heavy]
	ld [hl], a
	ld l, LOW(wObj{u:n}State)
	ld a, [hl]
	and $fe
	cp OBJSTATE_PICKED_UP_LEFT
	jr z, .reset_grab_{u:n}_2
	cp OBJSTATE_GRABBED_LEFT
	jr nz, .skip_reset_grab_{u:n}_2
.reset_grab_{u:n}_2
	xor a
	ld [wGrabState], a
.skip_reset_grab_{u:n}_2
	ldh a, [hCollidedObjState_Heavy]
	ld [hl], a
	ld l, LOW(wObj{u:n}Flags)
	set OBJFLAG_NO_COLLISION_F, [hl]
	play_sfx SFX_THROWN_OBJECT_HIT
	ret
ENDR

; clears objects and object data pointers
; and also some variables from level start
; such as whether the Flame Block is cleared
InitObjectVars_FromLevelStart:
	xor a
	call ClearObjects
	call ClearObjDataPointers
	ld [wFlameBlockCleared], a
	ld [wDollBoyNoFlashingBarrel], a
	ld [wDollBoyRemainingParts], a
	ld [wNumLitTorches], a
	ld [wShootGoals], a
	ld [wWarioGoals], a
	ret

; clears objects and object data pointers
; and also some variables from room start
InitObjectVars_FromTransition:
	xor a
	call ClearObjects
	call ClearObjDataPointers
	ld [wDollBoyNoFlashingBarrel], a
	ld [wDollBoyRemainingParts], a
	ld [wNumLitTorches], a
	ld [wShootGoals], a
	ld [wWarioGoals], a
	ret

ClearObjects:
	ld hl, wObjects
	ld c, a
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

ClearObjDataPointers:
	ld hl, wObjDataPointers
	ld c, wObjDataPointersEnd - wObjDataPointers
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

_ObjState_PickedUpLeft::
	ld a, no_actions_for 1
	ld [wCurObjAction], a

	ld a, [wGrabState]
	and GRAB_STATE_MASK
	cp GRAB_PICK_UP
	jp z, .PickUp
	cp GRAB_IDLE
	jr z, .GrabIdle
	ld a, OBJSTATE_DROP_START
	ld [wCurObjState], a
	jp HomeJumpRet

.GrabIdle:
	ld a, [wIsSmashAttacking]
	add a
	add a ; *4
	ld e, a
	ld a, 30
	sub e
	ld e, a ; = 26 if smash attacking, 30 otherwise
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a ; y
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	add 7
	ld [hli], a ; x
	ld a, [wWarioXPos + 0]
	adc 0
	ld [hl], a

	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a ; FALSE
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr z, .keep_grabbed
	ld a, [wHitFloorBlock]
	and a
	jr nz, .keep_grabbed
	ld hl, wCurObjYPos
	ld a, [hl] ; y
	add 16
	ld [hli], a
	jr nc, .drop_obj
	inc [hl]

.drop_obj
	xor a
	ld [wGrabState], a
	play_sfx SFX_OBJECT_HIT_WALL
	ld a, $02
	ld [wCurObjVar2], a
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_FALL_LEFT_START
	ld [hld], a ; OBJ_STATE
	jp HomeJumpRet

.keep_grabbed
	ld a, OBJSTATE_GRABBED_RIGHT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.PickUp:
	ld hl, wCurObjVar1
	dec [hl]
	jp nz, HomeJumpRet
	inc l
	ld a, [hli] ; OBJ_VAR_2
	ld h, [hl] ; OBJ_VAR_3
	ld l, a
	ld a, [hli]
	and a
	jr nz, .got_entry
	dec l
	dec l
	dec l
	dec l
	ld a, [hli]
.got_entry
	ld [wCurObjVar1], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wCurObjVar2], a
	ld a, h
	ld [wCurObjVar3], a

	ld hl, hPickedUpObjPos
	ld a, c
	cp $80
	ld a, [wWarioYPos + 1]
	jr nc, .negative_y
	add c
	ld [hli], a
	ld a, [wWarioYPos + 0]
	jr nc, .got_hi_y
	inc a
	jr .got_hi_y
.negative_y
	add c
	ld [hli], a
	ld a, [wWarioYPos + 0]
	jr c, .got_hi_y
	dec a
.got_hi_y
	ld [hl], a
	inc l

	ld a, b
	cp $80
	ld a, [wWarioXPos + 1]
	jr nc, .negative_x
	add b
	ld [hli], a
	ld a, [wWarioXPos + 0]
	jr nc, .got_hi_x
	inc a
	jr .got_hi_x
.negative_x
	add b
	ld [hli], a
	ld a, [wWarioXPos + 0]
	jr c, .got_hi_x
	dec a
.got_hi_x
	ld [hl], a

	ld hl, hPickedUpObjPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a

	call ProcessBlock_Side
	and $0f
	jr nz, .blocked
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, hPickedUpObjPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a

	call ProcessBlock_UpSide
	and $0f
	jr nz, .blocked
	ld hl, hPickedUpObjPos
	ld de, wCurObjYPos
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	jp HomeJumpRet

.blocked
	ld a, [wCurObjInteractionType]
	and HEAVY_OBJ
	jp nz, .drop_obj
	or GRAB_PICK_UP_BLOCKED
	ld [wGrabState], a
	ld a, OBJSTATE_GRABBED_RIGHT_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjState_PickedUpRight::
	ld a, no_actions_for 1
	ld [wCurObjAction], a

	ld a, [wGrabState]
	and GRAB_STATE_MASK
	cp GRAB_PICK_UP
	jp z, .PickUp
	cp GRAB_IDLE
	jr z, .GrabIdle
	ld a, OBJSTATE_DROP_START
	ld [wCurObjState], a
	jp HomeJumpRet

.GrabIdle:
	ld a, [wIsSmashAttacking]
	add a
	add a ; *4
	ld e, a
	ld a, 30
	sub e
	ld e, a ; = 26 if smash attacking, 30 otherwise
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a ; y
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	sub 7
	ld [hli], a ; x
	ld a, [wWarioXPos + 0]
	sbc 0
	ld [hl], a

	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a ; FALSE
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr z, .keep_grabbed
	ld a, [wHitFloorBlock]
	and a
	jr nz, .keep_grabbed
	ld hl, wCurObjYPos
	ld a, [hl] ; y
	add 16
	ld [hli], a
	jr nc, .drop_obj
	inc [hl]

.drop_obj
	xor a
	ld [wGrabState], a
	play_sfx SFX_OBJECT_HIT_WALL
	ld a, $02
	ld [wCurObjVar2], a
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [hld], a ; OBJ_STATE
	jp HomeJumpRet

.keep_grabbed
	ld a, OBJSTATE_GRABBED_LEFT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.PickUp:
	ld hl, wCurObjVar1
	dec [hl]
	jp nz, HomeJumpRet
	inc l
	ld a, [hli] ; OBJ_VAR_2
	ld h, [hl] ; OBJ_VAR_3
	ld l, a
	ld a, [hli]
	and a
	jr nz, .got_entry
	dec l
	dec l
	dec l
	dec l
	ld a, [hli]
.got_entry
	ld [wCurObjVar1], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wCurObjVar2], a
	ld a, h
	ld [wCurObjVar3], a

	ld hl, hPickedUpObjPos
	ld a, c
	cp $80
	ld a, [wWarioYPos + 1]
	jr nc, .negative_y
	add c
	ld [hli], a
	ld a, [wWarioYPos + 0]
	jr nc, .got_hi_y
	inc a
	jr .got_hi_y
.negative_y
	add c
	ld [hli], a
	ld a, [wWarioYPos + 0]
	jr c, .got_hi_y
	dec a
.got_hi_y
	ld [hl], a
	inc l

	ld a, b
	cp $80
	ld a, [wWarioXPos + 1]
	jr nc, .negative_x
	add b
	ld [hli], a
	ld a, [wWarioXPos + 0]
	jr nc, .got_hi_x
	inc a
	jr .got_hi_x
.negative_x
	add b
	ld [hli], a
	ld a, [wWarioXPos + 0]
	jr c, .got_hi_x
	dec a
.got_hi_x
	ld [hl], a

	ld hl, hPickedUpObjPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a

	call ProcessBlock_Side
	and $0f
	jr nz, .blocked
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, hPickedUpObjPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a

	call ProcessBlock_UpSide
	and $0f
	jr nz, .blocked
	ld hl, hPickedUpObjPos
	ld de, wCurObjYPos
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	jp HomeJumpRet

.blocked
	ld a, [wCurObjInteractionType]
	and HEAVY_OBJ
	jp nz, .drop_obj
	or GRAB_PICK_UP_BLOCKED
	ld [wGrabState], a
	ld a, OBJSTATE_GRABBED_LEFT_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjState_GrabbedRight::
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wGrabState]
	ld b, a
	and $0f
	cp GRAB_IDLE
	jr z, .GrabIdle
	cp GRAB_CHARGE_THROW
	jr z, .GrabChargeThrow
	cp GRAB_THROW
	jp z, ThrowObject_Right

	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_STATE
	ld a, [wIsCrouching]
	and a
	jr z, .not_crouching
; crouching
	ld a, $01
	ld [wCurObjVar2], a
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [hl], a
	jp HomeJumpRet

.not_crouching
	ld a, OBJSTATE_DROP_START
	ld [hl], a
	jp HomeJumpRet

.GrabChargeThrow:
	ld a, OBJSTATE_GRABBED_CHARGE_RIGHT
	ld [wCurObjState], a
	jp HomeJumpRet

.GrabIdle:
	ld a, [wIsSmashAttacking]
	add a
	add a
	ld e, a
	ld a, 30
	sub e
	ld e, a ; 26 if smash attacking, 30 otherwise
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	add 7
	ld [hli], a
	ld a, [wWarioXPos + 0]
	adc 0
	ld [hl], a
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and $0f
	jr nz, .hit_wall

	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and a
	jp z, HomeJumpRet

.hit_wall
	xor a
	ld [wGrabState], a
	play_sfx SFX_OBJECT_HIT_WALL
	ld a, $02
	ld [wCurObjVar2], a
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_FALL_LEFT_START
	ld [hl], a ; OBJ_STATE
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	jp HomeJumpRet

_ObjState_GrabbedLeft::
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wGrabState]
	ld b, a
	and $0f
	cp GRAB_IDLE
	jr z, .GrabIdle
	cp GRAB_CHARGE_THROW
	jr z, .GrabChargeThrow
	cp GRAB_THROW
	jp z, ThrowObject_Left

	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_STATE
	ld a, [wIsCrouching]
	and a
	jr z, .not_crouching
; crouching
	ld a, $01
	ld [wCurObjVar2], a
	ld a, OBJSTATE_FALL_LEFT_START
	ld [hl], a
	jp HomeJumpRet

.not_crouching
	ld a, OBJSTATE_DROP_START
	ld [hl], a
	jp HomeJumpRet

.GrabChargeThrow:
	ld a, OBJSTATE_GRABBED_CHARGE_LEFT
	ld [wCurObjState], a
	jp HomeJumpRet

.GrabIdle:
	ld a, [wIsSmashAttacking]
	add a
	add a
	ld e, a
	ld a, 30
	sub e
	ld e, a ; 26 if smash attacking, 30 otherwise
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	sub 7
	ld [hli], a
	ld a, [wWarioXPos + 0]
	sbc 0
	ld [hl], a
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and a
	jr nz, .hit_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jp z, HomeJumpRet

.hit_wall
	xor a
	ld [wGrabState], a
	play_sfx SFX_OBJECT_HIT_WALL
	ld a, $02
	ld [wCurObjVar2], a
	ld hl, wCurObjAction
	ld a, no_actions_for 31
	ld [hld], a
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [hl], a ; OBJ_STATE
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	jp HomeJumpRet

_ObjState_GrabbedChargeLeft::
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wGrabState]
	ld b, a
	and $0f
	cp GRAB_CHARGE_THROW
	jr z, .ChargeThrow
	cp GRAB_THROW_FULLY_CHARGED
	jr z, .ChargeThrow
	cp GRAB_HOLD_FULL_CHARGE
	jr z, .HoldFullCharge
	cp GRAB_THROW
	jp z, ThrowObject_Left

.drop
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld a, OBJSTATE_DROP_START
	ld [wCurObjState], a
	jp HomeJumpRet

.ChargeThrow:
	ld a, [wIsSmashAttacking]
	add a
	add a
	ld e, a
	ld a, 30
	sub e
	ld e, a
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	sub 7
	ld [hli], a
	ld a, [wWarioXPos + 0]
	sbc 0
	ld [hl], a
	jp HomeJumpRet

.HoldFullCharge:
	ld hl, hPickedUpObjPos
	ld a, [wWarioYPos + 1]
	sub 30
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	add 5
	ld [hli], a
	ld a, [wWarioXPos + 0]
	adc 0
	ld [hli], a
	ld hl, hPickedUpObjPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr z, .no_wall
	xor a
	ld [wGrabState], a
	play_sfx SFX_OBJECT_HIT_WALL
	jr .drop

.no_wall
	ld hl, hPickedUpObjPos
	ld de, wCurObjYPos
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	jp HomeJumpRet

ThrowObject_Left:
	play_sfx SFX_THROW
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hl], a
	rla
	ld l, OBJ_STATE_DURATION
	ld a, 0
	ld [hli], a
	inc l
	bit 6, b
	jr nz, .full_throw
	ld b, $03
	jr nc, .check_up
	ld b, $02
.check_up
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .got_speed
	ld b, $01
.got_speed
	ld a, b
	ld [hli], a ; OBJ_VAR_2
	xor a
	ld [hli], a ; OBJ_VAR_3
	inc l
	ld a, OBJSTATE_THROW_LEFT
	ld [hli], a ; OBJ_STATE
	ld a, no_actions_for 31
	ld [hld], a ; OBJ_ACTION
	jp HomeJumpRet

.full_throw
	ld b, $04
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .got_full_throw_speed
	ld b, $01
.got_full_throw_speed
	ld a, b
	ld [hli], a ; OBJ_VAR_2
	xor a
	ld [hli], a ; OBJ_VAR_3
	inc l
	ld a, OBJSTATE_FULL_THROW_LEFT_START
	ld [hli], a ; OBJ_STATE
	ld a, no_actions_for 31
	ld [hld], a ; OBJ_ACTION
	jp HomeJumpRet

_ObjState_GrabbedChargeRight::
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld a, [wGrabState]
	ld b, a
	and $0f
	cp GRAB_CHARGE_THROW
	jr z, .ChargeThrow
	cp GRAB_THROW_FULLY_CHARGED
	jr z, .ChargeThrow
	cp GRAB_HOLD_FULL_CHARGE
	jr z, .HoldFullCharge
	cp GRAB_THROW
	jp z, ThrowObject_Right

.drop
	ld hl, wCurObjFlags
	res OBJFLAG_GRABBED_F, [hl]
	ld a, OBJSTATE_DROP_START
	ld [wCurObjState], a
	jp HomeJumpRet

.ChargeThrow:
	ld a, [wIsSmashAttacking]
	add a
	add a
	ld e, a
	ld a, 30
	sub e
	ld e, a
	ld hl, wCurObjYPos
	ld a, [wWarioYPos + 1]
	sub e
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	add 7
	ld [hli], a
	ld a, [wWarioXPos + 0]
	adc 0
	ld [hl], a
	jp HomeJumpRet

.HoldFullCharge:
	ld hl, hPickedUpObjPos
	ld a, [wWarioYPos + 1]
	sub 30
	ld [hli], a
	ld a, [wWarioYPos + 0]
	sbc 0
	ld [hli], a
	ld a, [wWarioXPos + 1]
	sub 5
	ld [hli], a
	ld a, [wWarioXPos + 0]
	sbc 0
	ld [hli], a
	ld hl, hPickedUpObjPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr z, .no_wall
	xor a
	ld [wGrabState], a
	play_sfx SFX_OBJECT_HIT_WALL
	jr .drop

.no_wall
	ld hl, hPickedUpObjPos
	ld de, wCurObjYPos
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hli]
	ld [de], a
	jp HomeJumpRet

ThrowObject_Right:
	play_sfx SFX_THROW
	ld hl, wCurObjInteractionType
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_GRABBABLE
	ld [hl], a
	rla
	ld l, OBJ_STATE_DURATION
	ld a, 0
	ld [hli], a
	inc l
	bit 6, b
	jr nz, .full_throw
	ld b, $03
	jr nc, .check_up
	ld b, $02
.check_up
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .got_speed
	ld b, $01
.got_speed
	ld a, b
	ld [hli], a ; OBJ_VAR_2
	xor a
	ld [hli], a ; OBJ_VAR_3
	inc l
	ld a, OBJSTATE_THROW_RIGHT
	ld [hli], a ; OBJ_STATE
	ld a, no_actions_for 31
	ld [hld], a ; OBJ_ACTION
	jp HomeJumpRet

.full_throw
	ld b, $04
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jr z, .got_full_throw_speed
	ld b, $01
.got_full_throw_speed
	ld a, b
	ld [hli], a ; OBJ_VAR_2
	xor a
	ld [hli], a ; OBJ_VAR_3
	inc l
	ld a, OBJSTATE_FULL_THROW_RIGHT_START
	ld [hli], a ; OBJ_STATE
	ld a, no_actions_for 31
	ld [hld], a ; OBJ_ACTION
	jp HomeJumpRet

_ObjState_ThrowLeft::
	ld hl, wCurObjXPos + 1
	ld a, [hld]
	ldh [hXPosHi], a
	ld a, [hld]
	ldh [hXPosLo], a
	ld a, [wCurObjStateDuration]
	and a
	jr z, .check_collision
	ld a, [hld]
	ldh [hYPosHi], a
	ld a, [hl]
	ldh [hYPosLo], a
	xor a ; FALSE
	ld [wHitFloorBlock], a
	inc a
	ld [wBlockFuncSpecialCollision], a ; COLLISION_THROWN_OBJ
	call ProcessBlock_Landing
	and a
	ld a, $03
	ldh [hTemp], a
	jp nz, ObjLandLeft
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .check_collision
	; vanish when touching water or sand
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.check_collision
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_UpSide
	and a
	jr nz, .hit_ceiling
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	and $0f
	jr z, .move
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.hit_ceiling
	ld a, OBJSTATE_FALL_LEFT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.move
	call MoveObjectLeftByVar2
	jp ApplyObjThrowYVel

_ObjState_ThrowRight::
	ld hl, wCurObjXPos + 1
	ld a, [hld]
	ldh [hXPosHi], a
	ld a, [hld]
	ldh [hXPosLo], a
	ld a, [wCurObjStateDuration]
	and a
	jr z, .check_collision
	ld a, [hld]
	ldh [hYPosHi], a
	ld a, [hl]
	ldh [hYPosLo], a
	xor a ; FALSE
	ld [wHitFloorBlock], a
	inc a
	ld [wBlockFuncSpecialCollision], a ; COLLISION_THROWN_OBJ
	call ProcessBlock_Landing
	and a
	ld a, $03
	ldh [hTemp], a
	jp nz, ObjLandRight
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .check_collision
	; vanish when touching water or sand
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.check_collision
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_UpSide
	and a
	jr nz, .hit_ceiling
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	and $0f
	jr z, .move
	ld a, OBJSTATE_FALL_LEFT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.hit_ceiling
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.move
	call MoveObjectRightByVar2
;	fallthrough

ApplyObjThrowYVel:
	ld l, OBJ_VAR_3
	ld a, [hl]
	dec b
	jr z, .throw_up
	ld b, HIGH(ThrowYVel_Light)
	add LOW(ThrowYVel_Light)
.got_table
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add ThrowYVel_Heavy - ThrowYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	and a
	jr z, .done
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	ld a, 1
	ld [wCurObjStateDuration], a
	jr nc, .done
	inc [hl]
	jr .done

.negative
	add c
	ld [hli], a
	ld a, 0
	ld [wCurObjStateDuration], a
	jr c, .done
	dec [hl]
.done
	jp HomeJumpRet

.throw_up
	ld b, HIGH(ThrowUpYVel_Light)
	add LOW(ThrowUpYVel_Light)
	jr .got_table

_ObjState_FullThrowLeft::
	ld hl, wCurObjXPos + 1
	ld a, [hld]
	ldh [hXPosHi], a
	ld a, [hld]
	ldh [hXPosLo], a
	ld a, [wCurObjStateDuration]
	and a
	jr z, .check_collision
	ld a, [hld]
	ldh [hYPosHi], a
	ld a, [hl]
	ldh [hYPosLo], a
	xor a ; FALSE
	ld [wHitFloorBlock], a
	inc a
	ld [wBlockFuncSpecialCollision], a ; COLLISION_THROWN_OBJ
	call ProcessBlock_Landing
	and a
	ld a, $03
	ldh [hTemp], a
	jp nz, ObjLandLeft
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .check_collision
	; vanish when touching water or sand
.vanish
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.check_collision
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_UpSide
	and a
	jr nz, .vanish
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	and $0f
	jr nz, .vanish
	call MoveObjectLeftByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $f0
	jr c, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
.on_screen
	jp ApplyObjFullThrowYVel

_ObjState_FullThrowRight::
	ld hl, wCurObjXPos + 1
	ld a, [hld]
	ldh [hXPosHi], a
	ld a, [hld]
	ldh [hXPosLo], a
	ld a, [wCurObjStateDuration]
	and a
	jr z, .check_collision
	ld a, [hld]
	ldh [hYPosHi], a
	ld a, [hl]
	ldh [hYPosLo], a
	xor a ; FALSE
	ld [wHitFloorBlock], a
	inc a
	ld [wBlockFuncSpecialCollision], a ; COLLISION_THROWN_OBJ
	call ProcessBlock_Landing
	and a
	ld a, $03
	ldh [hTemp], a
	jp nz, ObjLandRight
	ld a, [wIsInWaterOrSand]
	and a
	jr z, .check_collision
	; vanish when touching water or sand
.vanish
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.check_collision
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_UpSide
	and a
	jr nz, .vanish
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	ld a, COLLISION_THROWN_OBJ
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	and $0f
	jr nz, .vanish
	call MoveObjectRightByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $10
	jr nc, ApplyObjFullThrowYVel
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
;	fallthrough

ApplyObjFullThrowYVel:
	ld l, OBJ_VAR_3
	ld a, [hl]
	dec b
	jr z, .throw_up
	ld b, $40
	add $c0
.got_table
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add $20
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	and a
	jr z, .done
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	ld a, $01
	ld [wCurObjStateDuration], a
	jr nc, .done
	inc [hl]
	jr .done
.negative
	add c
	ld [hli], a
	ld a, $00
	ld [wCurObjStateDuration], a
	jr c, .done
	dec [hl]
.done
	jp HomeJumpRet

.throw_up
	ld b, $41
	add $40
	jr .got_table

_ObjState_HitByObjRight::
	ld a, [wCurObjVar2]
	ld b, a
	jr ApplyObjKnockbackRight

_ObjState_AttackedLeft::
	ld a, [wCurObjVar2]
	ld b, a
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr c, ApplyObjKnockbackRight
	sla b
	sla b ; *4
;	fallthrough

ApplyObjKnockbackRight:
	ld hl, wCurObjXPos
	ld a, [hl]
	add b
	ld [hli], a
	jr nc, .no_overflow
	inc [hl]
.no_overflow
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(AttackedYVel_Light)
	add LOW(AttackedYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add AttackedYVel_Heavy - AttackedYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	jr nc, .done_y_vel
	inc [hl]
	jr .done_y_vel
.negative
	add c
	ld [hli], a
	jr c, .done_y_vel
	dec [hl]
.done_y_vel
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	jp HomeJumpRet

_ObjState_HitByObjLeft::
	ld a, [wCurObjVar2]
	ld b, a
	jr ApplyObjKnockbackLeft

_ObjState_AttackedRight::
	ld a, [wCurObjVar2]
	ld b, a
	ld a, [wEffectivePowerUp]
	cp GARLIC
	jr c, ApplyObjKnockbackLeft
	sla b
	sla b
;	fallthrough

ApplyObjKnockbackLeft:
	ld hl, wCurObjXPos
	ld a, [hl]
	sub b
	ld [hli], a
	jr nc, .no_borrow
	dec [hl]
.no_borrow
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(AttackedYVel_Light)
	add LOW(AttackedYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add AttackedYVel_Heavy - AttackedYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	jr nc, .done_y_vel
	inc [hl]
	jr .done_y_vel
.negative
	add c
	ld [hli], a
	jr c, .done_y_vel
	dec [hl]
.done_y_vel
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	jp HomeJumpRet

_ObjCheckFloorOrDrop::
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
	jp nz, HomeJumpRet
	ld a, OBJSTATE_DROP_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjCheckFloorOrStandingFall::
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
	jp nz, HomeJumpRet
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjState_Drop::
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(DropYVel_Light)
	add LOW(DropYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add DropYVel_Heavy - DropYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	jr nc, .done_y_vel
	inc [hl]
	jr .done_y_vel
.negative
	add c
	ld [hli], a
	jr c, .done_y_vel
	dec [hl]
.done_y_vel
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wObjSlopeInteraction], a
	call ProcessBlock_Landing
	and a
	jr nz, .land
	ld a, [wIsInWaterOrSand]
	and a
	jp z, HomeJumpRet
	; vanish when touching water or sand
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.land
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_STATE
	ld a, [wObjSlopeInteraction]
	and a
	jr nz, .on_slope
	ld a, OBJSTATE_STUNNED_START
	ld [hl], a
	jp HomeJumpRet

.on_slope
	and $0f
	cp $01
	ld a, $02
	ld [wCurObjVar2], a
	jp z, SetObjBounceFromYVel_Left
	jp SetObjBounceFromYVel_Right

_ApplyObjHopYVel::
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(HopYVel_Light)
	add LOW(HopYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add HopYVel_Heavy - HopYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl] ; OBJ_VAR_3
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	ld c, [hl]
	add c
	ld [hli], a
	jr c, .done
	dec [hl]
.done
	jp HomeJumpRet

_ObjState_StandingFall::
; speed up animation by 3x
	ld hl, wCurObjFrameDuration
	ld a, [hl]
	cp 3
	jr c, .done_anim_speedup
	sub 3
	ld [hl], a

.done_anim_speedup
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(StandingFallYVel_Light)
	add LOW(StandingFallYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add StandingFallYVel_Heavy - StandingFallYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc] ; use last entry
	jr .got_y_vel
.not_last
	inc [hl] ; OBJ_VAR_3
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
; positive
	add c
	ld [hli], a
	jr nc, .done_y_vel
	inc [hl]
	jr .done_y_vel
.negative
	add c
	ld [hli], a
	jr c, .done_y_vel
	dec [hl]

.done_y_vel
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wObjSlopeInteraction], a
	call ProcessBlock_Landing
	and a
	jr nz, .land
	ld a, [wIsInWaterOrSand]
	and a
	jp z, HomeJumpRet
	; vanish when touching water or sand
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.land
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_STATE
	ld a, [wObjSlopeInteraction]
	and a
	jr nz, .on_slope
	ld a, OBJSTATE_TURN_AROUND_START
	ld [hl], a
	jp HomeJumpRet

.on_slope
	and $0f
	cp $01
	ld a, $02
	ld [wCurObjVar2], a
	jp z, SetObjBounceFromYVel_Left
	jp SetObjBounceFromYVel_Right

; handle gravity for falling objects
_ObjState_Fall::
	ld hl, wCurObjVar3
	ld a, [hl]
	ld b, HIGH(FallingYVel_Light)
	add LOW(FallingYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add FallingYVel_Heavy - FallingYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .incr_index
	dec c ; use last entry
	ld a, [bc]
	jr .got_y_vel
.incr_index
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	ld c, [hl]
	add c
	ld [hli], a
	jr nc, .no_carry
	inc [hl]
.no_carry
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a

	xor a
	ld [wObjSlopeInteraction], a
	call ProcessBlock_Landing
	and a
	jr nz, .land
	ld a, [wIsInWaterOrSand]
	and a
	jp z, HomeJumpRet
	; vanish when touching water or sand
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

.land
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld l, OBJ_STATE
	ld a, [wObjSlopeInteraction]
	and a
	jr nz, .on_slope
	ld a, OBJSTATE_LAND
	ld [hl], a
	jp HomeJumpRet

.on_slope
	and $0f
	cp $01
	ld a, $02
	ld [wCurObjVar2], a
	jp z, SetObjBounceFromYVel_Left
	jp SetObjBounceFromYVel_Right

_ObjState_BumpRight::
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jr nz, _ObjState_BumpSlideLeft
	dec l
	dec l
	dec [hl] ; OBJ_STATE_DURATION
	jp nz, HomeJumpRet
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjState_BumpSlideLeft::
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jp nz, .hit_wall
	call MoveObjectLeftByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $f0
	jr c, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]

.on_screen
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wObjSlopeInteraction], a
	call ProcessBlock_Down
	cp $10

	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	jr z, .landed
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjXPos
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	jr nz, .slow_down
	ld hl, wCurObjXPos
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	jr nz, .slow_down
	ld a, OBJSTATE_FALL_LEFT_START
	ld [wCurObjState], a
	jr .slow_down

.hit_wall
	play_sfx SFX_OBJECT_HIT_WALL
	ld a, OBJSTATE_STUN_RIGHT_START
	ld [wCurObjState], a

.slow_down
	ld hl, wCurObjVar2
	ld a, [wCurObjInteractionType]
	rla
	ld a, [wGlobalCounter]
	jr c, .heavy
	and %111
	jp nz, HomeJumpRet
	dec [hl]
	jp HomeJumpRet
.heavy
	and %11
	jp nz, HomeJumpRet
	dec [hl]
	jp HomeJumpRet

.landed
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_STATE
	ld a, [wObjSlopeInteraction]
	rra
	jr nc, .not_right_slope
	ld a, [hl]
	cp OBJSTATE_STUN_LEFT
	jp z, HomeJumpRet
	ld a, OBJSTATE_FALL_LEFT_START
	ld [hl], a
	jp HomeJumpRet
.not_right_slope
	ld a, OBJSTATE_STUN_RIGHT_START
	ld [hl], a
	jp HomeJumpRet

_ObjState_BumpLeft::
	ld hl, wCurObjVar2
	ld a, [hl]
	and a
	jr nz, _ObjState_BumpSlideRight
	dec l
	dec l
	dec [hl] ; OBJ_STATE_DURATION
	jp nz, HomeJumpRet
	ld a, OBJSTATE_TURN_AROUND_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjState_BumpSlideRight::
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jp nz, .hit_wall
	call MoveObjectRightByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $10
	jr nc, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]

.on_screen
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wObjSlopeInteraction], a
	call ProcessBlock_Down
	cp $10

	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	jr z, .landed
	ld hl, wCurObjXPos
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	jr nz, .slow_down
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjXPos
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_DownSide
	and a
	jr nz, .slow_down
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [wCurObjState], a
	jr .slow_down

.hit_wall
	play_sfx SFX_OBJECT_HIT_WALL
	ld a, OBJSTATE_STUN_LEFT_START
	ld [wCurObjState], a

.slow_down
	ld hl, wCurObjVar2
	ld a, [wCurObjInteractionType]
	rla
	ld a, [wGlobalCounter]
	jr c, .heavy
	and %111
	jp nz, HomeJumpRet
	dec [hl]
	jp HomeJumpRet
.heavy
	and %11
	jp nz, HomeJumpRet
	dec [hl]
	jp HomeJumpRet

.landed
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
	ld l, OBJ_STATE
	ld a, [wObjSlopeInteraction]
	rra
	jr c, .right_slope
	ld a, [hl]
	cp OBJSTATE_STUN_RIGHT
	jp z, HomeJumpRet
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [hl], a
	jp HomeJumpRet
.right_slope
	ld a, OBJSTATE_STUN_LEFT_START
	ld [hl], a
	jp HomeJumpRet

_ObjState_FallLeftStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_FALL_LEFT
	ld [hld], a
	dec l
	xor a
	ld [hld], a
;	fallthrough

_ObjState_FallLeft::
	call MoveObjectLeftByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $f0
	jr c, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
.on_screen
	ld l, OBJ_VAR_3
	ld a, [hl]
	ld b, HIGH(FallingYVel_Light)
	add LOW(FallingYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add FallingYVel_Heavy - FallingYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	ld c, [hl]
	add c
	ld [hli], a
	jr nc, .no_cap
	inc [hl]
.no_cap
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wObjSlopeInteraction], a
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr nz, ObjLandLeft
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .vanish ; vanish when touching water or sand

	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jp z, HomeJumpRet
	ld a, OBJSTATE_FALL_RIGHT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.vanish
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

ObjLandLeft:
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld a, [wObjSlopeInteraction]
	and $0f
	cp RIGHT_SLOPE
	jr z, .got_x_vel
	ld l, OBJ_VAR_2
	cp $02
	jr nz, .not_left_slope
	dec a
	ld [hl], a
	jr .got_x_vel
.not_left_slope
	ld a, [hl]
	and a
	jr z, .got_x_vel
	dec [hl]
.got_x_vel
	ld l, OBJ_STATE
;	fallthrough

; hl = OBJ_STATE
SetObjBounceFromYVel_Left:
	ldh a, [hTemp] ; y vel
	cp 2
	jr c, .stun
	cp 3
	jr c, .bounce_1
	cp 4
	jr c, .bounce_2
	ld a, OBJSTATE_BOUNCE_3_LEFT_START
	ld [hl], a
	jp HomeJumpRet
.stun
	ld a, OBJSTATE_STUN_LEFT_START
	ld [hl], a
	jp HomeJumpRet
.bounce_1
	ld a, OBJSTATE_BOUNCE_1_LEFT_START
	ld [hl], a
	jp HomeJumpRet
.bounce_2
	ld a, OBJSTATE_BOUNCE_2_LEFT_START
	ld [hl], a
	jp HomeJumpRet

_ObjState_FallRightStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_FALL_RIGHT
	ld [hld], a
	dec l
	xor a
	ld [hld], a
;	fallthrough

_ObjState_FallRight::
	call MoveObjectRightByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $10
	jr nc, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
.on_screen
	ld l, OBJ_VAR_3
	ld a, [hl]
	ld b, HIGH(FallingYVel_Light)
	add LOW(FallingYVel_Light)
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add FallingYVel_Heavy - FallingYVel_Light
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	ldh [hTemp], a
	ld l, OBJ_Y_POS
	ld c, [hl]
	add c
	ld [hli], a
	jr nc, .no_cap
	inc [hl]
.no_cap
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	xor a
	ld [wObjSlopeInteraction], a
	ld [wHitFloorBlock], a
	call ProcessBlock_Landing
	and a
	jr nz, ObjLandRight
	ld a, [wIsInWaterOrSand]
	and a
	jr nz, .vanish ; vanish when touching water or sand

	ld hl, wCurObjYPos
	ld a, [hli]
	sub 4
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jp z, HomeJumpRet
	ld a, OBJSTATE_FALL_LEFT_START
	ld [wCurObjState], a
	jp HomeJumpRet

.vanish
	ld a, OBJSTATE_VANISH_TOUCH
	ld [wCurObjState], a
	jp HomeJumpRet

ObjLandRight:
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hl], a
	ld a, [wObjSlopeInteraction]
	and $0f
	cp LEFT_SLOPE
	jr z, .got_x_vel
	ld l, OBJ_VAR_2
	cp $01
	jr nz, .not_right_slope
	ld [hl], a
	jr .got_x_vel
.not_right_slope
	ld a, [hl]
	and a
	jr z, .got_x_vel
	dec [hl]
.got_x_vel
	ld l, OBJ_STATE
;	fallthrough

; hl = OBJ_STATE
SetObjBounceFromYVel_Right:
	ldh a, [hTemp] ; y vel
	cp 2
	jr c, .stun
	cp 3
	jr c, .bounce_1
	cp 4
	jr c, .bounce_2
	ld a, OBJSTATE_BOUNCE_3_RIGHT_START
	ld [hl], a
	jp HomeJumpRet
.stun
	ld a, OBJSTATE_STUN_RIGHT_START
	ld [hl], a
	jp HomeJumpRet
.bounce_1
	ld a, OBJSTATE_BOUNCE_1_RIGHT_START
	ld [hl], a
	jp HomeJumpRet
.bounce_2
	ld a, OBJSTATE_BOUNCE_2_RIGHT_START
	ld [hl], a
	jp HomeJumpRet

_VanishAndDespawnObject::
	play_sfx SFX_VANISH

	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(StarsFunc_Despawn)
	ld [hld], a
	ld a, LOW(StarsFunc_Despawn)
	ld [hld], a
	call SetObjStarsSprite
	jp HomeJumpRet

_VanishObject2::
	call _VanishObject
	jp HomeJumpRet

_ObjState_Bounce3LeftStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_3_LEFT
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, [wCurObjInteractionType]
	rla
	ld a, $06
	jr nc, .not_heavy
	ld a, $02
.not_heavy
	ld [wCurObjStateDuration], a
;	fallthrough

_ObjState_Bounce3Left::
	ld bc, Bounce3YVel_Light
	jr ObjBounceLeft

_ObjState_Bounce1LeftStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_1_LEFT
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, [wCurObjInteractionType]
	rla
	ld a, $04
	jr nc, .not_heavy
	ld a, $01
.not_heavy
	ld [wCurObjStateDuration], a
;	fallthrough

_ObjState_Bounce1Left::
	ld bc, Bounce1YVel_Light
	jr ObjBounceLeft

_ObjState_Bounce2LeftStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_2_LEFT
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, [wCurObjInteractionType]
	rla
	ld a, $05
	jr nc, .not_heavy
	ld a, $02
.not_heavy
	ld [wCurObjStateDuration], a
;	fallthrough

_ObjState_Bounce2Left::
	ld bc, Bounce2YVel_Light
;	fallthrough

ObjBounceLeft:
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add $10
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	and a
	jr z, .move_x
	ld l, OBJ_Y_POS
	ld c, [hl]
	add c
	ld [hli], a
	jr c, .move_x
	dec [hl]
.move_x
	call MoveObjectLeftByVar2

	ld a, [wCurObjScreenXPos]
	add $28
	cp $f0
	jr c, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
.on_screen
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and $0f
	jr nz, .hit_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxLeft]
	cpl
	inc a
	ld b, a
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr nz, .hit_wall
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, HomeJumpRet
	ld a, OBJSTATE_BOUNCE_FALL_LEFT_START
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	jp HomeJumpRet

.hit_wall
	ld a, OBJSTATE_BOUNCE_FALL_RIGHT_START
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	jp HomeJumpRet

_ObjState_Bounce3RightStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_3_RIGHT
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld a, [wCurObjInteractionType]
	rla
	ld a, $06
	jr nc, .not_heavy
	ld a, $02
.not_heavy
	ld [wCurObjStateDuration], a
;	fallthrough

_ObjState_Bounce3Right::
	ld bc, Bounce3YVel_Light
	jr ObjBounceRight

_ObjState_Bounce1RightStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_1_RIGHT
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, [wCurObjInteractionType]
	rla
	ld a, $04
	jr nc, .not_heavy
	ld a, $01
.not_heavy
	ld [wCurObjStateDuration], a
;	fallthrough

_ObjState_Bounce1Right::
	ld bc, Bounce1YVel_Light
	jr ObjBounceRight

_ObjState_Bounce2RightStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_BOUNCE_2_RIGHT
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, [wCurObjInteractionType]
	rla
	ld a, $05
	jr nc, .not_heavy
	ld a, $02
.not_heavy
	ld [wCurObjStateDuration], a
;	fallthrough

_ObjState_Bounce2Right::
	ld bc, Bounce2YVel_Light
;	fallthrough

ObjBounceRight:
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [wCurObjInteractionType]
	rla
	jr nc, .not_heavy
	ld a, c
	add $10
	ld c, a
.not_heavy
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
	and a
	jr z, .move_x
	ld l, OBJ_Y_POS
	ld c, [hl]
	add c
	ld [hli], a
	jr c, .move_x
	dec [hl]
.move_x
	call MoveObjectRightByVar2
	ld a, [wCurObjScreenXPos]
	add $28
	cp $10
	jr nc, .on_screen
	ld l, OBJ_FLAGS
	res OBJFLAG_GRABBED_F, [hl]
.on_screen
	ld a, [wCurObjCollBoxTop]
	cpl
	inc a
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub b
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hli]
	ldh [hXPosHi], a
	call ProcessBlock_UpSide
	and $0f
	jr nz, .hit_wall
	ld hl, wCurObjYPos
	ld a, [hli]
	sub 8
	ldh [hYPosLo], a
	ld a, [hli]
	sbc 0
	ldh [hYPosHi], a
	ld a, [wCurObjCollBoxRight]
	add [hl]
	ldh [hXPosLo], a
	inc l
	ld a, [hl]
	adc 0
	ldh [hXPosHi], a
	call ProcessBlock_Side
	and $0f
	jr nz, .hit_wall
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, HomeJumpRet
	ld a, OBJSTATE_BOUNCE_FALL_RIGHT_START
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	jp HomeJumpRet

.hit_wall
	ld a, OBJSTATE_BOUNCE_FALL_LEFT_START
	ld [wCurObjState], a
	ld hl, wCurObjFlags
	res OBJFLAG_NO_COLLISION_F, [hl]
	jp HomeJumpRet

_ObjState_HopStart::
	ld hl, wCurObjState
	ld a, OBJSTATE_HOP
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, $07
	ld [wCurObjStateDuration], a
	jp HomeJumpRet

_ObjState_Hop::
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, _ApplyObjHopYVel
	ld a, OBJSTATE_STANDING_FALL_START
	ld [wCurObjState], a
	jp HomeJumpRet

_ObjState_StartRandomWobble::
	ldh a, [rDIV]
	rra
	jr c, .wobble_left
	ld a, OBJSTATE_WOBBLE_RIGHT
	jr .set_state
.wobble_left
	ld a, OBJSTATE_WOBBLE_LEFT
.set_state
	ld hl, wCurObjState
	ld [hld], a
	dec l
	xor a
	ld [hld], a ; OBJ_VAR_3
	ld a, $01
	ld [hld], a ; OBJ_VAR_2
	dec l
	ld a, $04
	ld [hli], a ; OBJ_STATE_DURATION
	jp HomeJumpRet

; seems to be a function to load/unload objects
; that are inside and outside the screen
CheckObjectOnScreen:
	ld hl, wCurObjYPos
	ld a, [hli] ; y lo
	ld c, a
	ld a, [hli] ; y hi
	ld b, a
	ld a, [hli] ; x lo
	ld e, a
	ld d, [hl]  ; x hi

; bc = y pos
; de = x pos

	ld hl, wCameraSCY
	ld a, [hli]
	ld l, [hl]
	ld h, a
	push bc
	push de
	push hl
	ld a, c
	add 24
	ld c, a
	jr nc, .no_overflow1
	inc b
	jr z, .skip_y1
.no_overflow1
	ld a, b
	cp h
	jr c, .check_grabbed
	jr nz, .skip_y1
	; b == h
	ld a, c
	cp l
	jr c, .check_grabbed
	jr z, .skip_y2
	; c > l

.skip_y1
	ld a, l
	add SCREEN_HEIGHT_PX
	ld l, a
	jr nc, .no_overflow2
	inc h
.no_overflow2
	ld a, c
	sub 56
	ld c, a
	jr nc, .no_underflow1
	dec b
	ld a, b
	inc a
	jr z, .skip_y2
.no_underflow1
	ld a, b
	cp h
	jr c, .skip_y2
	jr nz, .check_grabbed
	ld a, c
	cp l
	jr nc, .check_grabbed

.skip_y2
	ld hl, wCameraSCX
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, e
	add 24
	ld e, a
	jr nc, .no_overflow3
	inc d
	jr z, .on_screen
.no_overflow3
	ld a, d
	cp h
	jr c, .outside_screen
	jr nz, .check_right_edge
	ld a, e
	cp l
	jr c, .outside_screen
	jr z, .on_screen
.check_right_edge
	ld a, l
	add SCREEN_WIDTH_PX
	ld l, a
	jr nc, .no_overflow4
	inc h
.no_overflow4
	ld a, e
	sub $30
	ld e, a
	jr nc, .no_underflow2
	dec d
	ld a, d
	inc a
	jr z, .on_screen
.no_underflow2
	ld a, d
	cp h
	jr c, .on_screen
	jr nz, .outside_screen
	ld a, e
	cp l
	jr nc, .outside_screen
.on_screen
	ld hl, wCurObjFlags
	set OBJFLAG_ON_SCREEN_F, [hl]
	jr .check_despawn

.check_grabbed
	ld a, [wCurObjState]
	and $fe
	cp OBJSTATE_GRABBED_LEFT
	jr z, .check_despawn
.outside_screen
	ld hl, wCurObjFlags
	res OBJFLAG_ON_SCREEN_F, [hl]
.check_despawn
	pop hl
	pop de
	pop bc

	ld a, d
	rla
	jr c, .despawn
	ld a, b
	rla
	jr c, .despawn
	ld a, c
	add 92
	ld c, a
	jr nc, .no_overflow5
	inc b
	jr z, .check_despawn_x
.no_overflow5
	ld a, b
	cp h
	jr c, .despawn
	jr nz, .check_despawn_bottom
	ld a, c
	cp l
	jr c, .despawn
	jr z, .check_despawn_x
.check_despawn_bottom
	ld a, l
	add $90
	ld l, a
	jr nc, .no_overflow6
	inc h
.no_overflow6
	ld a, c
	sub $cb
	ld c, a
	jr nc, .no_underflow3
	dec b
	ld a, b
	inc a
	jr z, .check_despawn_x
.no_underflow3
	ld a, b
	cp h
	jr c, .check_despawn_x
	jr nz, .despawn
	ld a, c
	cp l
	jr nc, .despawn

.check_despawn_x
	ld hl, wCameraSCX
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, e
	add $6f
	ld e, a
	jr nc, .no_overflow7
	inc d
	jr z, .done
.no_overflow7
	ld a, d
	cp h
	jr c, .despawn
	jr nz, .check_despawn_right
	ld a, e
	cp l
	jr c, .despawn
	jr z, .done
.check_despawn_right
	ld a, l
	add SCREEN_WIDTH_PX
	ld l, a
	jr nc, .no_overflow8
	inc h
.no_overflow8
	ld a, e
	sub $de
	ld e, a
	jr nc, .no_underflow4
	dec d
	ld a, d
	inc a
	jr z, .done
.no_underflow4
	ld a, d
	cp h
	jr c, .done
	jr nz, .despawn
	ld a, e
	cp l
	jr c, .done
.despawn
	ld a, [wCurObjSubState]
	and $f | OBJSUBFLAG_NO_DESPAWN
	cp $0 | OBJSUBFLAG_NO_DESPAWN
	ret nc
	; OBJSUBFLAG_NO_DESPAWN is not set
	ld hl, wCurObjMapPtrHi
	and a
	jr z, .clear_obj
	farcall DespawnObject
	ret
.clear_obj
	xor a
	ld [wCurObjFlags], a
.done
	ret

_ApplyObjSetMovement::
	ld hl, wCurObjVar1
	dec [hl]
	ret nz
	inc l
	ld a, [hli] ; var2
	ld h, [hl]  ; var3
	ld l, a
	ld a, [hli]
	and a
	jr nz, .no_loop
; loop
	ld h, d
	ld l, e
	ld a, [hli]
.no_loop
	ld [wCurObjVar1], a ; duration
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, l
	ld [wCurObjVar2], a
	ld a, h
	ld [wCurObjVar3], a

	ld hl, wCurObjYPos
	ld a, c
	cp $80
	jr nc, .negative_y
	ld a, [hl]
	add c
	ld [hli], a
	jr nc, .x_pos
	inc [hl]
	jr .x_pos
.negative_y
	ld a, [hl]
	add c
	ld [hli], a
	jr c, .x_pos
	dec [hl]

.x_pos
	inc l
	ld a, b
	cp $80
	jr nc, .negative_x
	ld a, [hl]
	add b
	ld [hli], a
	ret nc
	inc [hl]
	ret
.negative_x
	ld a, [hl]
	add b
	ld [hli], a
	ret c
	dec [hl]
	ret

_ApplyObjYMovement::
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_y_vel
.not_last
	inc [hl]
.got_y_vel
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

_ApplyObjYMovement_Platform::
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .next
	dec c
	ld a, [bc]
	jr .got_y_offset
.next
	inc [hl]
.got_y_offset
	ld b, a
	ld l, OBJ_Y_POS
	cp $80
	ld c, [hl]
	jr nc, .negative
	add c
	ld [hli], a
	jr nc, .check_stepped
	inc [hl]
	jr .check_stepped
.negative
	add c
	ld [hli], a
	jr c, .check_stepped
	dec [hl]
.check_stepped
	ld l, OBJ_FLAGS
	bit OBJFLAG_STEPPED_F, [hl]
	ret z
	res OBJFLAG_STEPPED_F, [hl]
	call MoveWarioDown
	farcall CheckCarriedWarioDownCollision
	ret

_ApplyObjXMovement::
	ld hl, wCurObjVar2
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .not_last
	dec c
	ld a, [bc]
	jr .got_x_vel
.not_last
	inc [hl]
.got_x_vel
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

_ApplyObjYMovement_Loop::
	ld e, c
	ld hl, wCurObjVar3
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .got_y_vel
	xor a
	ld [hl], a
	ld c, e
	ld a, [bc]
.got_y_vel
	inc [hl]
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

_ApplyObjXMovement_Loop::
	ld e, c
	ld hl, wCurObjVar2
	ld a, [hl]
	add c
	ld c, a
	ld a, [bc]
	cp $80
	jr nz, .got_x_vel
	; restart movement
	xor a
	ld [hl], a
	ld c, e
	ld a, [bc]
.got_x_vel
	inc [hl]
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

_CountCurObjTransientChildren::
	ld hl, wCurObjMapPtrLo
	ld a, [hli]
	ld c, a
	ld b, [hl]
	ld e, $00
	ld d, OBJFLAG_ACTIVE | OBJFLAG_TRANSIENT
	ld h, HIGH(wObj1)
	ld l, OBJ_FLAGS
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj2
	ld a, [hli]
	cp c
	jr nz, .check_obj2
	ld a, [hl]
	cp b
	jr nz, .check_obj2
	inc e
.check_obj2
	ld l, $20
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj3
	ld a, [hli]
	cp c
	jr nz, .check_obj3
	ld a, [hl]
	cp b
	jr nz, .check_obj3
	inc e
.check_obj3
	ld l, $40
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj4
	ld a, [hli]
	cp c
	jr nz, .check_obj4
	ld a, [hl]
	cp b
	jr nz, .check_obj4
	inc e
.check_obj4
	ld l, $60
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj5
	ld a, [hli]
	cp c
	jr nz, .check_obj5
	ld a, [hl]
	cp b
	jr nz, .check_obj5
	inc e
.check_obj5
	ld l, $80
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj6
	ld a, [hli]
	cp c
	jr nz, .check_obj6
	ld a, [hl]
	cp b
	jr nz, .check_obj6
	inc e
.check_obj6
	ld l, $a0
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj7
	ld a, [hli]
	cp c
	jr nz, .check_obj7
	ld a, [hl]
	cp b
	jr nz, .check_obj7
	inc e
.check_obj7
	ld l, $c0
	ld a, [hli]
	and d
	cp d
	jr nz, .check_obj8
	ld a, [hli]
	cp c
	jr nz, .check_obj8
	ld a, [hl]
	cp b
	jr nz, .check_obj8
	inc e
.check_obj8
	ld l, $e0
	ld a, [hli]
	and d
	cp d
	jr nz, .done
	ld a, [hli]
	cp c
	jr nz, .done
	ld a, [hl]
	cp b
	jr nz, .done
	inc e
.done
	ret

_CountActiveTransientObjects::
	ld e, 0
	ld d, OBJFLAG_ACTIVE | OBJFLAG_TRANSIENT
FOR n, 1, NUM_OBJECTS + 1
	ld a, [wObj{u:n}Flags]
	and d
	cp d
	jr nz, :+
	inc e
:
ENDR
	ret
