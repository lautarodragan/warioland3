CheckCarriedWarioRightCollision:
	ld a, TRUE
	ld [wBlockFuncWarioFlag], a
	call CheckBottomRightCollision_Break
	xor a ; FALSE
	ld [wBlockFuncWarioFlag], a
	ret

CheckCarriedWarioLeftCollision:
	ld a, TRUE
	ld [wBlockFuncWarioFlag], a
	call CheckBottomLeftCollision_Break
	xor a ; FALSE
	ld [wBlockFuncWarioFlag], a
	ret

CheckCarriedWarioDownCollision:
	ld a, TRUE
	ld [wBlockFuncWarioFlag], a
	call CheckAirborneCollision
	xor a
	ld [wBlockFuncWarioFlag], a
	ld a, b
	and a
	jp nz, TriggerFloorTransition
	jp TriggerDownwardsFloorTransition

; checks collision in side that Wario is facing
CheckFrontCollision:
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
	ld a, [wDirection]
	and a
	jr z, CheckBottomLeftCollision
	jr CheckBottomRightCollision

CheckBottomRightCollision_Break:
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
;	fallthrough

CheckBottomRightCollision:
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr z, .flat
	ld a, [wCollisionBoxRight]
	sub 1
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [wCollisionBoxBottom]
	cpl
	inc a
	add 7
	ld c, a
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr .got_collision_coords

.flat
	ld a, [wCollisionBoxRight]
	sub 1
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [wCollisionBoxBottom]
	cpl
	inc a
	add 1
	ld c, a
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a

.got_collision_coords
	ldh a, [hYPosLo]
	and $f0
	ld [wFrontCollisionBlockY], a
	call _ProcessBlock_Side
	and $0f
	jp z, CheckFrontBlockAbove
	ld a, [wAttackCounter]
	and a
	jp nz, ProcessFrontBlockAbove_Break
	ld a, b
	ret

CheckBottomLeftCollision_Break:
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
;	fallthrough

CheckBottomLeftCollision:
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr z, .flat
	ld a, [wCollisionBoxLeft]
	cpl
	inc a
	sub 1
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [wCollisionBoxBottom]
	cpl
	inc a
	add 7
	ld c, a
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr .got_collision_coords

.flat
	ld a, [wCollisionBoxLeft]
	cpl
	inc a
	sub 1
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [wCollisionBoxBottom]
	cpl
	inc a
	add 1
	ld c, a
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a

.got_collision_coords
	ldh a, [hYPosLo]
	and $f0
	ld [wFrontCollisionBlockY], a
	call _ProcessBlock_Side
	and $0f
	jr z, CheckFrontBlockAbove
	ld a, [wAttackCounter]
	and a
	jr nz, ProcessFrontBlockAbove_Break
	ld a, b
	ret

ProcessFrontBlockAbove_Break:
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
	call ProcessBlockAbove
	ld a, $01
	ld [wUnused_c18d], a
	ld b, a
	ret

CheckFrontBlockAbove:
	ld a, [wIsCrouching]
	and a
	jp nz, .no_collision
	ld a, [wCollisionBoxTop]
	ld b, a
	ld a, [wWarioYPos + 1]
	add b
	add 2
	and $f0
	ld b, a
	ld a, [wFrontCollisionBlockY]
	cp b
	jp z, .no_collision
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
	call ProcessBlockAbove
	and $0f
	ret z
	ld a, [wJumpVelTable]
	and a
	jp nz, .done
	ld a, [wAttackCounter]
	and a
	jr nz, .done
	ld a, [wWaterInteraction]
	and a
	jr nz, .done
	ld a, [wIsCrouching]
	and a
	jr nz, .done
	ld a, [wIsOnSteppableObject]
	and a
	jr nz, .done
	ld a, [wTransformation]
	and a
	jr nz, .done
	ld a, [wIsInSand]
	and a
	jr nz, .done

	ld a, [wJoypadDown]
	bit B_PAD_RIGHT, a
	jr nz, .add_offset
	bit B_PAD_LEFT, a
	jr nz, .sub_offset
	ld a, [wDirection]
	and a
	jr nz, .add_offset
.sub_offset
	ld b, 2
	call MoveWarioLeft
	farcall CrouchOrSlide
	jr .no_collision
.add_offset
	ld b, 2
	call MoveWarioRight
	farcall CrouchOrSlide
	jr .no_collision

.done
	ret

.no_collision
	xor a
	ld [wUnused_c18d], a
	ld b, a
	ret

; resets wWarioSlopeInteraction
CheckDownCollisionAtWario:
	xor a
	ld [wWarioSlopeInteraction], a
	get_pos
	call _ProcessBlock_Down
	ret

CheckCentreCollision:
; collision in centre
	ld a, $01
	ld [wUnused_ced3], a
	call CheckDownCollisionAtWario
	and a
	ret nz
	xor a
	ld [wUnused_ced3], a

; collision on left
	ld a, [wCollisionBoxLeft]
	cpl
	inc a
	sub 3
	ld c, a ; -wCollisionBoxLeft - 3
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call _ProcessBlock_DownSide
	and a
	ret nz

; collision on right
	ld a, [wCollisionBoxRight]
	sub 3
	ld c, a ; wCollisionBoxRight - 3
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call _ProcessBlock_DownSide
	and a
	ret nz

	ld a, [wIsOnSteppableObject]
	and a
	ret z
	ld b, a
	get_pos_y
	ld a, $01
	ret

CheckUpCentreCollision:
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .puffy
	; can destroy blocks above
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
.puffy
	; 2 pixels above collision box
	ld a, [wCollisionBoxTop]
	cpl
	inc a
	add 2
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	call ProcessBlock_Up
	ret

CheckUpCollision:
	ld a, TRUE
	ld [wJumpCollision], a
	call CheckUpCentreCollision
	and a
	ret nz
	xor a
	ld [wJumpCollision], a
	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .puffy_1
	; can destroy blocks above
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
.puffy_1
	; left collision boundary - 3 pixels
	ld a, [wCollisionBoxLeft]
	cpl
	inc a
	sub 3
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	; 2 pixels above collision box
	ld a, [wCollisionBoxTop]
	cpl
	inc a
	add 2
	ld c, a
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	call _ProcessBlock_UpSide
	and a
	ret nz

	ld a, [wTransformation]
	cp TRANSFORMATION_PUFFY_WARIO
	jr z, .puffy_2
	; can destroy blocks above
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
.puffy_2
	; right collision boundary - 3 pixels
	ld a, [wCollisionBoxRight]
	sub 3
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	; 2 pixels above collision box
	ld a, [wCollisionBoxTop]
	cpl
	inc a
	add 2
	ld c, a
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	call _ProcessBlock_UpSide
	ret

CheckAirborneCollision:
	call .process_landing_block
	and a
	ret nz

	ld a, [wIsSmashAttacking]
	and a
	jr z, .no_smash_attack_1
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
.no_smash_attack_1
	ld a, [wCollisionBoxLeft]
	cpl
	inc a
	sub 3
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call ProcessBlock_LandingSide
	and a
	ret nz
	ld a, [wIsOnSteppableObject]
	and a
	jr z, .check_right_side
	ld b, a
	ret

.check_right_side
	ld a, [wIsSmashAttacking]
	and a
	jr z, .no_smash_attack_2
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
.no_smash_attack_2
	ld a, [wCollisionBoxRight]
	sub 3
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call ProcessBlock_LandingSide
	and a
	ret nz
	ld a, [wIsOnSteppableObject]
	and a
	ret z
	ld b, a
	ret

.process_landing_block:
	xor a
	ld [wWarioSlopeInteraction], a
	ld a, [wIsSmashAttacking]
	and a
	jr z, .no_smash_attack_3
	ld a, TRUE
	ld [wBlockFuncBreakFlag], a
.no_smash_attack_3
	get_pos
	call _ProcessBlock_Landing
	ret

CheckStandingOnFloorBlocks:
	xor a ; FALSE
	ld [wHitFloorBlock], a
	ld a, [wCollisionBoxLeft]
	cpl
	inc a
	sub $03
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	sub c
	ld [de], a
	dec de
	ld a, [hld]
	sbc $00
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call UpdateEnvState
	and a
	jr z, .check_right_side
	ld a, [wHitFloorBlock]
	and a
	ret z

.check_right_side
	xor a ; FALSE
	ld [wHitFloorBlock], a
	ld a, [wCollisionBoxRight]
	sub $03
	ld c, a
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	add c
	ld [de], a
	dec de
	ld a, [hld]
	adc $00
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call UpdateEnvState
	and a
	jr z, .set_hit_floor
	ret
.set_hit_floor
	ld a, TRUE
	ld [wHitFloorBlock], a
	ret

UpdateEnvStateAtChest:
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	sub $0c
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr UpdateEnvState

UpdateEnvStateAboveHead:
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	sub $1a
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr UpdateEnvState

UpdateEnvStateAtHead:
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	sub $18
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr UpdateEnvState

; collision on centre
UpdateEnvStateAtFeet:
	get_pos
	jr UpdateEnvState

; collision on top
CheckTopBlockInteraction:
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	sub 4
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
;	fallthrough

UpdateEnvState:
	xor a
	ld [wWaterInteraction], a
	ld [wLadderInteraction], a
	ld [wRoomTransitionParam], a
	ld [wIsInSand], a
	ld [wIsNearFence], a
	ld [wIsInAirCurrent], a
	call ProcessBlock_Env
	ret

_ProcessBlock_Down::
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_DOWN
	ld [wCollisionPoints], a
;	fallthrough

ProcessBlockToB:
	call ProcessBlock
	ld b, a
	ret

_ProcessBlockOnLeft::
	call DecrementBlockPtr
	ld a, [hl]
	inc a
	ret z
	jr ProcessBlockToB

_ProcessBlockOnRight::
	call IncrementBlockPtr
	ld a, [hl]
	and a
	ret z
	jr ProcessBlockToB

DecrementBlockPtr:
	ld hl, wBlockPtr + 1
	dec [hl]
	ret

IncrementBlockPtr:
	ld hl, wBlockPtr + 1
	inc [hl]
	ret

_ProcessBlock_Landing::
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_LANDING
	ld [wCollisionPoints], a
	call ProcessBlock
	ld b, a
	ret

_ProcessBlock_DownSide::
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_DOWN_SIDES
	ld [wCollisionPoints], a
	call ProcessBlock
	ld b, a
	ret

_ProcessBlock_UpSide::
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_UP_SIDES
	ld [wCollisionPoints], a
	call ProcessBlock
	ld b, a
	ret

; unreferenced
UnreferencedProcessBlockOnLeft:
	ld hl, wBlockPtr + 1
	dec [hl]
	ld a, [hld]
	ld h, [hl]
	ld l, a
	call ProcessBlock
	ld b, a
	ret

; unreferenced
UnreferencedProcessBlockOnRight:
	ld hl, wBlockPtr + 1
	inc [hl]
	ld a, [hld]
	ld h, [hl]
	ld l, a
	call ProcessBlock
	ld b, a
	ret

_ProcessBlock_Side::
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_SIDE
	ld [wCollisionPoints], a
	jr ProcessBlockToB

ProcessBlockAbove:
	ld hl, wBlockPtr
	dec [hl]
	ld a, [hl]
	cp $a0 - 1
	jr nz, .same_bank
	ld a, [wBlockPtrBank]
	dec a
	ld [wBlockPtrBank], a
	ld a, $c0 - 1
	ld [hl], a

.same_bank
	ld a, [hli]
	ld l, [hl]
	ld h, a
	jp ProcessBlockToB

ProcessBlock_Up:
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_UP
	ld [wCollisionPoints], a
	call ProcessBlock
	ld b, a
	ret

ProcessBlock_LandingSide:
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_LANDING_SIDES
	ld [wCollisionPoints], a
	call ProcessBlock
	ld b, a
	ret

ProcessBlock_Env:
	ld hl, hPos
	call GetBlockPtr
	ld a, COLLISION_ENV
	ld [wCollisionPoints], a
	call ProcessBlock
	ld b, a
	ret
