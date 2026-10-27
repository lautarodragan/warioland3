; processes the block function of wBlockPtrBank:wBlockPtr
ProcessBlock:
	xor a ; FALSE
	ld [wIsInWaterOrSand], a
	ld a, [wBlockPtrBank]
	sramswitch
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	add a ; *2
	ld e, a
	ld d, $00
	ld hl, wBlockFunctionTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; output:
; - a = $00
BlockFunc_Free:
	xor a ; SRAM0
	sramswitch
	xor a
	ld [wBlockFuncBreakFlag], a ; FALSE
	ld [wBlockFuncSpecialCollision], a
	ld [wUnused_c18d], a
	ret

; output:
; - a = $00 or $01
BlockFunc_Solid:
	xor a ; SRAM0
	sramswitch
	xor a
	ld [wBlockFuncBreakFlag], a ; FALSE
	ld [wBlockFuncSpecialCollision], a
	ld a, [wBlockFuncWarioFlag]
	and a
	jr z, .snap_y_pos
	ld a, [wWarioSlopeInteraction]
	and a
	jr z, .snap_y_pos
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr z, .snap_y_pos
	xor a
	ld [wUnused_c18d], a
	ret

.snap_y_pos
	ldh a, [hYPosLo]
	and $f0
	ldh [hYPosLo], a
	ld a, $01
	ld [wUnused_c18d], a
	ret

; output:
; - a = $10
Func_18064:
	xor a ; SRAM0
	sramswitch
	xor a
	ld [wBlockFuncBreakFlag], a ; FALSE
	ld [wBlockFuncSpecialCollision], a
	ld a, $10
	ld [wUnused_c18d], a
	ret

; output:
; - a = $01
; unreferenced
Func_18078:
	xor a ; SRAM0
	sramswitch
	xor a
	ld [wBlockFuncBreakFlag], a ; FALSE
	ld [wBlockFuncSpecialCollision], a
	ld a, $01
	ld [wUnused_c18d], a
	ret

; output:
; - a = $00
Func_1808c:
	xor a ; SRAM0
	sramswitch
	xor a
	ld [wBlockFuncBreakFlag], a ; FALSE
	ld [wBlockFuncSpecialCollision], a
	xor a
	ld [wUnused_c18d], a
	ret

BlockFunc_1809f:
	ld a, [wCollisionPoints]
	bit COLLISION_DOWN_F, a
	jp z, BlockFunc_Free
	ldh a, [hYPosLo]
	add $10
	ldh [hYPosLo], a
	ldh a, [hYPosHi]
	adc $00
	ldh [hYPosHi], a
	jr RightSlopeCollision

BlockFunc_180b5:
	ld a, [wBlockFuncWarioFlag]
	and a
	jr z, .asm_180c3
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	jp z, BlockFunc_Solid
.asm_180c3
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING
	jp z, BlockFunc_Free
	ldh a, [hYPosLo]
	sub $10
	ldh [hYPosLo], a
	ldh a, [hYPosHi]
	sbc $00
	ldh [hYPosHi], a
	jr RightSlopeCollision

BlockFunc_RightSlope:
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints] ; unnecessary
	bit COLLISION_LANDING_F, a
	jr z, RightSlopeCollision

	; if x + y < $10, then it means that
	; that Wario is in a pixel on the upper part
	; of a square divided diagonally by a line

	; ................
	; ...............x
	; ...< $10......xx
	; .............xxx
	; ............xxxx
	; ...........xxxxx
	; ..........xxxxxx
	; .........xxxxxxx
	; ........xxxxxxxx
	; .......xxxxxxxxx
	; ......xxxxxxxxxx
	; .....xxxxxxxxxxx
	; ....xx > $ 10 xx
	; ...xxxxxxxxxxxxx
	; ..xxxxxxxxxxxxxx
	; .xxxxxxxxxxxxxxx
	; xxxxxxxxxxxxxxxx

	ldh a, [hYPosLo]
	and $0f
	ld b, a
	ldh a, [hXPosLo]
	and $0f
	add b
	cp $10
	jp c, BlockFunc_Free
;	fallthrough

RightSlopeCollision:
	ldh a, [hXPosLo]
	and $0f
	ld c, a
	ld a, $10
	sub c
	ld c, a
	; c = x distance in px to right block
	ldh a, [hYPosLo]
	and $f0
	add c
	ldh [hYPosLo], a
	ldh a, [hYPosHi]
	adc 0
	ldh [hYPosHi], a
	; yPos += top + c

	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING
	jr z, .asm_18126
	ld a, [wBlockFuncWarioFlag]
	and a
	jr nz, .set_slope_interaction
	ld a, ON_SLOPE | RIGHT_SLOPE
	ld [wObjSlopeInteraction], a
	jr .asm_18126
.set_slope_interaction
	ld a, ON_SLOPE | RIGHT_SLOPE
	ld [wWarioSlopeInteraction], a
.asm_18126
	jp Func_18064

BlockFunc_18129:
	ld a, [wCollisionPoints]
	bit COLLISION_DOWN_F, a
	jp z, BlockFunc_Free
	ldh a, [hYPosLo]
	add $10
	ldh [hYPosLo], a
	ldh a, [hYPosHi]
	adc 0
	ldh [hYPosHi], a
	jr LeftSlopeCollision

BlockFunc_1813f:
	ld a, [wBlockFuncWarioFlag]
	and a
	jr z, .asm_1814d
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	jp z, BlockFunc_Solid
.asm_1814d
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING
	jp z, BlockFunc_Free
	ldh a, [hYPosLo]
	sub $10
	ldh [hYPosLo], a
	ldh a, [hYPosHi]
	sbc $00
	ldh [hYPosHi], a
	jr LeftSlopeCollision

BlockFunc_LeftSlope:
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING
	jp z, BlockFunc_Free
	bit COLLISION_LANDING_F, a
	jr z, LeftSlopeCollision

	; if x >= y, then it means that
	; that Wario is in a pixel on the upper part
	; of a square divided diagonally by a line

	; ................
	; x...............
	; xx.....x > y....
	; xxx.............
	; xxxx............
	; xxxxx...........
	; xxxxxx..........
	; xxxxxxx.........
	; xxxxxxxx........
	; xxxxxxxxx.......
	; xxxxxxxxxx......
	; xxxxxxxxxxx.....
	; xx x < y xxx....
	; xxxxxxxxxxxxx...
	; xxxxxxxxxxxxxx..
	; xxxxxxxxxxxxxxx.
	; xxxxxxxxxxxxxxxx

	ldh a, [hYPosLo]
	and $0f
	ld b, a
	ldh a, [hXPosLo]
	and $0f
	cp b
	jp nc, BlockFunc_Free
;	fallthrough

LeftSlopeCollision:
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING
	jr z, .asm_181a9

	ldh a, [hXPosLo]
	and $0f
	inc a
	inc a
	ld c, a
	; c = x distance to left block + 2
	ldh a, [hYPosLo]
	and $f0
	add c
	ldh [hYPosLo], a
	ldh a, [hYPosHi]
	adc 0
	ldh [hYPosHi], a
	; yPos += top + c

	ld a, [wBlockFuncWarioFlag]
	and a
	jr nz, .set_slope_interaction
	ld a, ON_SLOPE | LEFT_SLOPE
	ld [wObjSlopeInteraction], a
	jr .asm_181a9
.set_slope_interaction
	ld a, ON_SLOPE | LEFT_SLOPE
	ld [wWarioSlopeInteraction], a
.asm_181a9
	jp Func_18064

BlockFunc_Water:
	ld a, TRUE
	ld [wIsInWaterOrSand], a
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, SUBMERSIBLE_WATER
	ld [wWaterInteraction], a
	jp BlockFunc_Free

BlockFunc_RightCurrent:
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, CURRENT_RIGHT
	ld [wWaterCurrent], a
	jp BlockFunc_Water

BlockFunc_UpCurrent:
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, CURRENT_UP
	ld [wWaterCurrent], a
	jp BlockFunc_Water

BlockFunc_LeftCurrent:
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, CURRENT_LEFT
	ld [wWaterCurrent], a
	jp BlockFunc_Water

BlockFunc_DownCurrent:
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, CURRENT_DOWN
	ld [wWaterCurrent], a
	jp BlockFunc_Water

BlockFunc_Floor:
	ld a, TRUE
	ld [wHitFloorBlock], a
	ld a, [wCollisionPoints]
	bit COLLISION_DOWN_F, a
	jr nz, .asm_18228
	bit COLLISION_DOWN_SIDES_F, a
	jr nz, .asm_18228
	and COLLISION_UP_SIDES | COLLISION_SIDE | COLLISION_UP | COLLISION_ENV
	jp nz, BlockFunc_Free
	ldh a, [hYPosLo]
	and $0f
	cp $05
	jr c, .asm_18228
	jp BlockFunc_Free
.asm_18228
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wWarioState]
	cp WST_ZOMBIE_LANDING
	jp z, BlockFunc_Free
	cp WST_ZOMBIE_SLIPPING_THROUGH_FLOOR
	jp z, BlockFunc_Free
	jp BlockFunc_Solid

BlockFunc_WaterSurface:
	ld a, [wCollisionPoints]
	bit COLLISION_LANDING_F, a
	jr nz, .asm_18257
	ldh a, [hYPosLo]
	and $0e
	jp nz, BlockFunc_Water
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_DOWN_SIDES
	jr nz, .asm_1825a
	jp BlockFunc_Water
.asm_18257
	jp BlockFunc_Floor
.asm_1825a
	ld a, TRUE
	ld [wIsInWaterOrSand], a
	jp BlockFunc_Solid

BlockFunc_18262:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp nz, BlockFunc_Free
	ld a, TRUE
	ld [wHitFloorBlock], a
	ld a, [wCollisionPoints]
	bit COLLISION_DOWN_F, a
	jp nz, BlockFunc_Solid
	bit COLLISION_DOWN_SIDES_F, a
	jp nz, BlockFunc_Solid
	and COLLISION_UP_SIDES | COLLISION_SIDE | COLLISION_UP | COLLISION_ENV
	jp nz, BlockFunc_Free
	ldh a, [hYPosLo]
	and $0f
	cp $05
	jp c, BlockFunc_Solid
	jp BlockFunc_Free

BlockFunc_Switch:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	and COLLISION_UP_SIDES | COLLISION_UP
	jp z, BlockFunc_Solid
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	ld [wSwitchState], a
	xor $8
	ld [hl], a
	call QueueBlockRedraw
	ld a, [wSwitchStateUpdated]
	xor 1
	ld [wSwitchStateUpdated], a
	play_sfx SFX_SWITCH
	ld b, 16
	call DoGroundShake
	jp BlockFunc_Solid

BlockFunc_Ladder:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jr nz, .set_ladder_interaction
	jp BlockFunc_Free
.set_ladder_interaction
	ld a, LADDER_COLLISION
	ld [wLadderInteraction], a
	jp Func_1808c

BlockFunc_SolidLadderTop:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	jr LadderTopCollision

BlockFunc_LadderTop:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Floor
;	fallthrough

LadderTopCollision:
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jr nz, .asm_182f6
	jp BlockFunc_Floor
.asm_182f6
	ld a, LADDER_UNDERNEATH
	ld [wLadderInteraction], a
	jp Func_1808c

BlockFunc_182fe:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, LADDER_COLLISION
	ld [wLadderInteraction], a
	ld a, ROOMTRANSITION_5 | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	jp BlockFunc_Free

Func_1831a:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, LADDER_COLLISION
	ld [wLadderInteraction], a
	ld a, ROOMTRANSITION_5
	ld [wRoomTransitionParam], a
	jp BlockFunc_Free

BlockFunc_NonSolidSpike:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wInvincibleCounter]
	and a
	jp nz, BlockFunc_Free
	ld a, [wSpikeTouchState]
	cp $02
	jp z, BlockFunc_Free
	ld a, [wWarioState]
	cp WST_STUNG
	jp z, BlockFunc_Free
	cp WST_STUNG_RECOVERY
	jp z, BlockFunc_Free

	; switch direction
	ld a, [wDirection]
	and a
	jr nz, .right
; left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jr .asm_1836b
.right
	ld a, DIRECTION_LEFT
	ld [wDirection], a

.asm_1836b
	ld a, [wSpikeTouchState]
	and a
	jr nz, .asm_18383
	farcall SetState_Stung
	jp BlockFunc_Free
.asm_18383
	cp $01
	jr z, .asm_1838a
	jp BlockFunc_Free
.asm_1838a
	farcall EndTransformationAndSting
	jp BlockFunc_Free

BlockFunc_SolidSpike:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wInvincibleCounter]
	and a
	jp nz, BlockFunc_Solid
	ld a, [wSpikeTouchState]
	cp $02
	jp z, BlockFunc_Solid
	ld a, [wWarioState]
	cp WST_STUNG
	jp z, BlockFunc_Solid
	cp WST_STUNG_RECOVERY
	jp z, BlockFunc_Solid

	; switch direction
	ld a, [wDirection]
	and a
	jr nz, .right
; left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jr .asm_183d1
.right
	ld a, DIRECTION_LEFT
	ld [wDirection], a

.asm_183d1
	ld a, [wSpikeTouchState]
	and a
	jr nz, .asm_183e9
	farcall SetState_Stung
	jp BlockFunc_Solid
.asm_183e9
	cp $01
	jr z, .asm_183f0
	jp BlockFunc_Solid
.asm_183f0
	farcall EndTransformationAndSting
	jp BlockFunc_Solid

BlockFunc_WaterSpike:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Water
	ld a, [wInvincibleCounter]
	and a
	jp nz, BlockFunc_Water
	ld a, [wWarioState]
	cp WST_WATER_STUNG
	jp z, BlockFunc_Water
	farcall SetState_WaterStung
	jp BlockFunc_Water

BlockFunc_DownPipe_Left:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid

	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .asm_1843d
	cp WST_GRAB_IDLING
	jp nz, BlockFunc_Solid
.asm_1843d
	ld a, [wCollisionPoints]
	and COLLISION_DOWN
	jp z, BlockFunc_Solid
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jp z, BlockFunc_Solid
	ld a, [wWarioXPos + 1]
	and $f0
	add $18
	ld [wWarioXPos + 1], a
	ld a, [wWarioXPos + 0]
	adc $00
	ld [wWarioXPos + 0], a
	jr EnterPipeDown

BlockFunc_DownPipe_Right:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid

	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .asm_18474
	cp WST_GRAB_IDLING
	jp nz, BlockFunc_Solid
.asm_18474
	ld a, [wCollisionPoints]
	and COLLISION_DOWN
	jp z, BlockFunc_Solid
	ld a, [wJoypadDown]
	bit B_PAD_DOWN, a
	jp z, BlockFunc_Solid
	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a

EnterPipeDown:
	ld a, ROOMTRANSITION_PIPE | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	play_sfx SFX_PIPE_ENTER
	ld a, WST_PIPE_GOING_DOWN
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsSmashAttacking], a

	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_14a82)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14a82)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14a82)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(Frameset_14cf6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(Frameset_14cf6)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jp BlockFunc_Solid

BlockFunc_UpPipe_Left:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid

	ld a, [wWarioState]
	cp WST_AIRBORNE
	jr z, .asm_1850f
	cp WST_GRAB_AIRBORNE
	jp nz, BlockFunc_Solid
.asm_1850f
	ld a, [wCollisionPoints]
	and COLLISION_UP
	jp z, BlockFunc_Solid
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jp z, BlockFunc_Solid
	ld a, [wWarioXPos + 1]
	and $f0
	add $18
	ld [wWarioXPos + 1], a
	ld a, [wWarioXPos + 0]
	adc $00
	ld [wWarioXPos + 0], a
	jr EnterPipeUp

BlockFunc_UpPipe_Right:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid

	ld a, [wWarioState]
	cp WST_AIRBORNE
	jr z, .asm_18546
	cp WST_GRAB_AIRBORNE
	jp nz, BlockFunc_Solid
.asm_18546
	ld a, [wCollisionPoints]
	and COLLISION_UP
	jp z, BlockFunc_Solid
	ld a, [wJoypadDown]
	bit B_PAD_UP, a
	jp z, BlockFunc_Solid
	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a
;	fallthrough

EnterPipeUp:
	ld a, ROOMTRANSITION_PIPE | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	play_sfx SFX_PIPE_ENTER
	ld a, WST_PIPE_GOING_UP
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a

	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_14a82)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14a82)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14a82)
	ld [wWarioOAMPtr + 1], a
	ld a, HIGH(Frameset_14cf6)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(Frameset_14cf6)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jp BlockFunc_Solid

BlockFunc_Door:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jp z, BlockFunc_Free
	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .enter_door
	cp WST_SLIPPING
	jr z, .enter_door
	cp WST_GRAB_IDLING
	jr z, .enter_door
	cp WST_BAT_IDLING
	jr z, .enter_door
	cp WST_BAT_FLYING
	jr z, .enter_door
	cp WST_BAT_FALLING
	jp nz, BlockFunc_Free
.enter_door
	ld a, ROOMTRANSITION_DOOR | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	jp EnterDoor

BlockFunc_MinigameDoor:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jp z, BlockFunc_Free
	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .enter_door
	cp WST_GRAB_IDLING
	jp nz, BlockFunc_Free
.enter_door
	ld a, ROOMTRANSITION_GOLF | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	jr EnterDoor

; unreferenced
Func_18624:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jp z, BlockFunc_Free
	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .asm_18647
	cp WST_GRAB_IDLING
	jp nz, BlockFunc_Free
.asm_18647
	ld a, ROOMTRANSITION_DOOR | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	jr EnterDoor

; unreferenced
Func_1864e:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jp z, BlockFunc_Free
	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .asm_18671
	cp WST_GRAB_IDLING
	jp nz, BlockFunc_Free
.asm_18671
	ld a, ROOMTRANSITION_GOLF | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
;	fallthrough

EnterDoor:
	ld a, [wWarioXPos + 1]
	and $f0
	add $08
	ld [wWarioXPos + 1], a
	play_sfx SFX_0E6

	ld a, WST_ENTERING_DOOR
	ld [wWarioState], a

	xor a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCounter], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
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
	ld a, BANK(OAM_14a82)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14a82)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14a82)
	ld [wWarioOAMPtr + 1], a
	ld a, [wDirection]
	and a
	jr nz, .asm_186dd
	ld a, HIGH(Frameset_14d0b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(Frameset_14d0b)
	ld [wWarioFramesetPtr + 1], a
	jr .asm_186e7
.asm_186dd
	ld a, HIGH(Frameset_14d10)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(Frameset_14d10)
	ld [wWarioFramesetPtr + 1], a
.asm_186e7
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	jp BlockFunc_Free

BlockFunc_UnderwaterDoor:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Water
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jr z, .asm_1870b
	and a
	jp nz, BlockFunc_Water
.asm_1870b
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, SUBMERSIBLE_WATER
	ld [wWaterInteraction], a
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jr z, .asm_18724
	ld a, ROOMTRANSITION_UNDERWATER_DOOR | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
.asm_18724
	jp BlockFunc_Free

BlockFunc_18727:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Water
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jr z, .asm_18739
	and a
	jp nz, BlockFunc_Water
.asm_18739
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, SUBMERSIBLE_WATER
	ld [wWaterInteraction], a
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jr z, .asm_18752
	ld a, ROOMTRANSITION_UNDERWATER_DOOR | ROOMTRANSITIONF_DOOR
	ld [wRoomTransitionParam], a
.asm_18752
	jp BlockFunc_Free

; unreferenced
Func_18755:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jr z, .asm_18767
	and a
	jp nz, BlockFunc_Free
.asm_18767
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jr z, .asm_1877b
	ld a, ROOMTRANSITION_8 | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
.asm_1877b
	jp BlockFunc_Free

BlockFunc_TreasureDoor:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wJoypadPressed]
	bit B_PAD_UP, a
	jp z, BlockFunc_Free
	ld a, [wTransformation]
	and a
	jp nz, BlockFunc_Free
	ld a, [wWarioState]
	cp WST_IDLING
	jr z, .enter_door
	cp WST_SLIPPING
	jr z, .enter_door
	cp WST_GRAB_IDLING
	jp nz, BlockFunc_Free
.enter_door
	xor a
	ld [wGrabState], a
	ld a, LVLEND_NO_TREASURE
	ld [wLevelEndScreen], a
	jp BlockFunc_Free

BlockFunc_187b0:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, ROOMTRANSITION_4 | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	jp BlockFunc_Free

Func_187c7:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, ROOMTRANSITION_4
	ld [wRoomTransitionParam], a
	jp BlockFunc_Free

BlockFunc_187de:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Water
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, ROOMTRANSITION_4 | ROOMTRANSITIONF_RELOAD_OBJECTS
	ld [wRoomTransitionParam], a
	jp BlockFunc_Water

Func_187f5:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Water
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Water
	ld a, ROOMTRANSITION_4
	ld [wRoomTransitionParam], a
	jp BlockFunc_Water

BlockFunc_WalkthroughPipe:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jp nz, BlockFunc_Free
	call RecoverFromTransformation_WithoutInvincibility
	jp BlockFunc_Free

BlockFunc_LightSource:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_ZOMBIE_WARIO
	jr z, .asm_1883a
	cp TRANSFORMATION_VAMPIRE_WARIO
	jp nz, BlockFunc_Free
	call RecoverFromTransformation_WithoutInvincibility
	jp BlockFunc_Free
.asm_1883a
	farcall SetState_ZombieRecovering
	jp BlockFunc_Free

BlockFunc_Sand:
	ld a, TRUE
	ld [wIsInWaterOrSand], a
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, TRUE
	ld [wIsInSand], a
	jp BlockFunc_Free

BlockFunc_18868:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_VAMPIRE_WARIO
	jp nz, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Solid
	ld a, [wWarioXPos + 1]
	and $08
	jr nz, .asm_1889e
	ld a, [wCollisionBoxRight]
	ld b, a
	ld a, [wWarioXPos + 1]
	and $f0
	sub b
	ld [wWarioXPos + 1], a
	ld a, [wWarioXPos + 0]
	sbc $00
	ld [wWarioXPos + 0], a
	jp BlockFunc_Solid
.asm_1889e
	ld a, [wCollisionBoxLeft]
	ld b, a
	ld a, $10
	sub b
	ld b, a
	ld a, [wWarioXPos + 1]
	and $f0
	add b
	ld [wWarioXPos + 1], a
	ld a, [wWarioXPos + 0]
	adc $00
	ld [wWarioXPos + 0], a
	jp BlockFunc_Solid

BlockFunc_188ba:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	jp BlockFunc_Free

BlockFunc_NonSubmersibleWater:
	ld a, TRUE
	ld [wIsInWaterOrSand], a
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jp z, BlockFunc_Free
	ld a, NON_SUBMERSIBLE_WATER
	ld [wWaterInteraction], a
	jp BlockFunc_Free

BlockFunc_Fire:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	and COLLISION_DOWN | COLLISION_LANDING | COLLISION_DOWN_SIDES | COLLISION_LANDING_SIDES
	jp nz, BlockFunc_Free
	ld a, [wInvincibleCounter]
	and a
	jp nz, BlockFunc_Free
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, BlockFunc_Free
	ld a, TRANSFORMATION_HOT_WARIO
	ld [wTransformation], a
	ld a, 1
	ld [wTransformationProgress], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	ld a, HIGH(HOT_WARIO_DURATION)
	ld [wTransformationDuration + 0], a
	ld a, LOW(HOT_WARIO_DURATION)
	ld [wTransformationDuration + 1], a
	call UpdateLevelMusic
	farcall SetState_OnFire_ResetStateCounter
	ret

BlockFunc_Fence:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jr nz, .set_near_fence
	jp BlockFunc_Free
.set_near_fence
	ld a, TRUE
	ld [wIsNearFence], a
	jp Func_1808c

BlockFunc_AirCurrent:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wCollisionPoints]
	bit COLLISION_ENV_F, a
	jr nz, .asm_1895e
	jp BlockFunc_Free
.asm_1895e
	ld a, [wInvincibleCounter]
	and a
	jp nz, BlockFunc_Free
	ld a, TRUE
	ld [wIsInAirCurrent], a
	ld a, [wTransformation]
	and a
	jp nz, BlockFunc_Free
	ld a, TRANSFORMATION_FAN
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_VULNERABLE
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	farcall SetState_FanStart
	jp BlockFunc_Free

BlockFunc_SlipperySolid:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	and COLLISION_DOWN
	jp z, BlockFunc_Solid
	ld a, TRUE
	ld [wIsOnSlipperyGround], a
	jp BlockFunc_Solid

BlockFunc_SlipperyFloor:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Floor
	ld a, [wCollisionPoints]
	and COLLISION_DOWN
	jp z, BlockFunc_Floor
	ld a, TRUE
	ld [wIsOnSlipperyGround], a
	jp BlockFunc_Floor

BlockFunc_CloudPlatform1:
	ld a, [wRoomPalCycleIndex]
	cp $07
	jr z, .solid
	cp $04
	jp nc, BlockFunc_Free
.solid
	jp BlockFunc_Floor

BlockFunc_CloudPlatform2:
	ld a, [wRoomPalCycleIndex]
	cp $03
	jp c, BlockFunc_Free
	jp BlockFunc_Floor

BlockFunc_SmallGap:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jp z, BlockFunc_Free
	jp BlockFunc_Solid

BlockFunc_189f1:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Free
	jp BlockFunc_Floor

BlockFunc_CrackedBlockWithColourCoin_78:
	ld b, $78
	jr CrackedBlockWithColourCoinCollision

BlockFunc_CrackedBlockWithColourCoin_79:
	ld b, $79
	jr CrackedBlockWithColourCoinCollision

BlockFunc_CrackedBlockWithColourCoin_7a:
	ld b, $7a
	jr CrackedBlockWithColourCoinCollision

BlockFunc_CrackedBlockWithColourCoin_7b:
	ld b, $7b
	jr CrackedBlockWithColourCoinCollision

BlockFunc_CrackedBlockWithColourCoin_7c:
	ld b, $7c
	jr CrackedBlockWithColourCoinCollision

; unreferenced
BlockFunc_CrackedBlockWithColourCoin_7d:
	ld b, $7d
	jr CrackedBlockWithColourCoinCollision

BlockFunc_CrackedBlockWithColourCoin_7e:
	ld b, $7e
	jr CrackedBlockWithColourCoinCollision

; unreferenced
BlockFunc_CrackedBlockWithColourCoin_7f:
	ld b, $7f
;	fallthrough

CrackedBlockWithColourCoinCollision:
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_18a36
	bit COLLISION_UP_F, a
	jr nz, .asm_18a45
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_18a45
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_18a5c
	jp BlockFunc_Solid

.asm_18a36
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_18a5c
	ld a, [wIsRolling]
	and a
	jr nz, .asm_18a5c
	jp BlockFunc_Solid

.asm_18a45
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_18a5c
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_18a5c
	jp BlockFunc_Solid

.asm_18a5c
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlockWithColourCoin
	ld a, [wIsRolling]
	and a
	jp nz, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jp z, BlockFunc_Free
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .asm_18a8f
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	jp BlockFunc_Free
.asm_18a8f
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
	jp BlockFunc_Free

BlockFunc_SnowballBlockRight_79:
	ld b, $79
	jr SnowballBlockRightCollision
BlockFunc_SnowballBlockRight_7a:
	ld b, $7a
	jr SnowballBlockRightCollision
BlockFunc_SnowballBlockRight_7b:
	ld b, $7b
	jr SnowballBlockRightCollision
BlockFunc_SnowballBlockRight_78:
	ld b, $78
;	fallthrough

SnowballBlockRightCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18ad6
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 1
	jp c, BlockFunc_Solid ; not in snowball
	ld a, $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18ad6
	or $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_SnowballBlockDown_79:
	ld b, $79
	jr SnowballBlockDownCollision
BlockFunc_SnowballBlockDown_7a:
	ld b, $7a
	jr SnowballBlockDownCollision
BlockFunc_SnowballBlockDown_7b:
	ld b, $7b
	jr SnowballBlockDownCollision
BlockFunc_SnowballBlockDown_78:
	ld b, $78
;	fallthrough
SnowballBlockDownCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18b17
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 1
	jp c, BlockFunc_Solid ; not in snowball
	ld a, $03
	ld [wMultiBlockParam], a
.asm_18b17
	or $03
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

; unreferenced
BlockFunc_SnowballBlockLeft_79:
	ld b, $79
	jr SnowballBlockLeftCollision

BlockFunc_SnowballBlockLeft_7a:
	ld b, $7a
	jr SnowballBlockLeftCollision

; unreferenced
BlockFunc_SnowballBlockLeft_7b:
	ld b, $7b
	jr SnowballBlockLeftCollision

BlockFunc_SnowballBlockLeft_78:
	ld b, $78
;	fallthrough

SnowballBlockLeftCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18b5b
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 1
	jp c, BlockFunc_Solid ; not in snowball
	ld a, $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18b5b
	or $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

; unreferenced
BlockFunc_SnowballBlockUp_79:
	ld b, $79
	jr SnowballBlockUpCollision

BlockFunc_SnowballBlockUp_7a:
	ld b, $7a
	jr SnowballBlockUpCollision

; unreferenced
BlockFunc_SnowballBlockUp_7b:
	ld b, $7b
	jr SnowballBlockUpCollision

BlockFunc_SnowballBlockUp_78:
	ld b, $78
;	fallthrough

SnowballBlockUpCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18b9f
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 1
	jp c, BlockFunc_Solid ; not in snowball
	ld a, $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18b9f
	or $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

; unreferenced
BlockFunc_BigSnowballBlockRight_79:
	ld b, $79
	jr BigSnowballBlockRightCollision

; unreferenced
BlockFunc_BigSnowballBlockRight_7a:
	ld b, $7a
	jr BigSnowballBlockRightCollision

; unreferenced
BlockFunc_BigSnowballBlockRight_7b:
	ld b, $7b
	jr BigSnowballBlockRightCollision

BlockFunc_BigSnowballBlockRight_78:
	ld b, $78
;	fallthrough

BigSnowballBlockRightCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18be3
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 3
	jp nz, BlockFunc_Solid ; not big snowball
	ld a, $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18be3
	or $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

; unreferenced
BlockFunc_BigSnowballBlockDown_79:
	ld b, $79
	jr BigSnowballBlockDownCollision

; unreferenced
BlockFunc_BigSnowballBlockDown_7a:
	ld b, $7a
	jr BigSnowballBlockDownCollision

; unreferenced
BlockFunc_BigSnowballBlockDown_7b:
	ld b, $7b
	jr BigSnowballBlockDownCollision

BlockFunc_BigSnowballBlockDown_78:
	ld b, $78
;	fallthrough

BigSnowballBlockDownCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18c24
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 3
	jp nz, BlockFunc_Solid ; not big snowball
	ld a, $03
	ld [wMultiBlockParam], a
.asm_18c24
	or $03
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

; unreferenced
BlockFunc_BigSnowballBlockLeft_79:
	ld b, $79
	jr BigSnowballBlockLeftCollision

BlockFunc_BigSnowballBlockLeft_7a:
	ld b, $7a
	jr BigSnowballBlockLeftCollision

; unreferenced
BlockFunc_BigSnowballBlockLeft_7b:
	ld b, $7b
	jr BigSnowballBlockLeftCollision

BlockFunc_BigSnowballBlockLeft_78:
	ld b, $78
;	fallthrough

BigSnowballBlockLeftCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18c68
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 3
	jp nz, BlockFunc_Solid ; not big snowball
	ld a, $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18c68
	or $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

; unreferenced
BlockFunc_BigSnowballBlockUp_79:
	ld b, $79
	jr BigSnowballBlockUpCollision

BlockFunc_BigSnowballBlockUp_7a:
	ld b, $7a
	jr BigSnowballBlockUpCollision

; unreferenced
BlockFunc_BigSnowballBlockUp_7b:
	ld b, $7b
	jr BigSnowballBlockUpCollision

BlockFunc_BigSnowballBlockUp_78:
	ld b, $78
;	fallthrough

BigSnowballBlockUpCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18cac
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_SNOWMAN_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wTransformationProgress]
	cp 3
	jp nz, BlockFunc_Solid ; not big snowball
	ld a, $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18cac
	or $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_CrackedBlock_78:
	ld b, $78
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_79:
	ld b, $79
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_7a:
	ld b, $7a
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_7b:
	ld b, $7b
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_7c:
	ld b, $7c
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_7d:
	ld b, $7d
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_7e:
	ld b, $7e
	jr CrackedBlockCollision

BlockFunc_CrackedBlock_7f:
	ld b, $7f
;	fallthrough

CrackedBlockCollision:
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_BREAK
	jp z, Func_19423
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_18cfc
	bit COLLISION_UP_F, a
	jr nz, .asm_18d0b
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_18d0b
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_18d22
	jp BlockFunc_Solid
.asm_18cfc
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_18d22
	ld a, [wIsRolling]
	and a
	jr nz, .asm_18d22
	jp BlockFunc_Solid
.asm_18d0b
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_18d22
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_18d22
	jp BlockFunc_Solid
.asm_18d22
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	ld a, [wIsRolling]
	and a
	jp nz, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jp z, BlockFunc_Free
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .asm_18d55
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	jp BlockFunc_Free
.asm_18d55
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
	jp BlockFunc_Free

BlockFunc_NonCrackedBlock_78:
	ld b, $78
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_79:
	ld b, $79
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_7a:
	ld b, $7a
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_7b:
	ld b, $7b
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_7c:
	ld b, $7c
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_7d:
	ld b, $7d
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_7e:
	ld b, $7e
	jr NonCrackedBlockCollision

BlockFunc_NonCrackedBlock_7f:
	ld b, $7f
;	fallthrough

NonCrackedBlockCollision:
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_BREAK
	jp z, Func_19423
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jr z, .fat_wario
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_18dcb
	bit COLLISION_UP_F, a
	jr nz, .asm_18dda
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_18dda
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_18dc1
	jp BlockFunc_Solid

.fat_wario
	ld a, [wCollisionPoints]
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, BreakBlock_SolidUnlessRolling
	jp BlockFunc_Solid

.asm_18dc1
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jr nc, BreakBlock_SolidUnlessRolling
	jp BlockFunc_Solid

.asm_18dcb
	ld a, [wAttackCounter]
	and a
	jr nz, BreakBlock_SolidUnlessRolling
	ld a, [wIsRolling]
	and a
	jr nz, BreakBlock_SolidUnlessRolling
	jp BlockFunc_Solid

.asm_18dda
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, BreakBlock_SolidUnlessRolling
	ld a, [wSwimVelIndex]
	and a
	jr nz, BreakBlock_SolidUnlessRolling
	jp BlockFunc_Solid

BreakBlock_SolidUnlessRolling:
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	ld a, [wIsRolling]
	and a
	jp nz, BlockFunc_Free
	jp BlockFunc_Solid

BlockFunc_LargeCrackedBlockRight_79:
	ld b, $79
	jr LargeCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeCrackedBlockRight_7a:
	ld b, $7a
	jr LargeCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeCrackedBlockRight_7b:
	ld b, $7b
	jr LargeCrackedBlockRightCollision

BlockFunc_LargeCrackedBlockRight_7c:
	ld b, $7c
	jr LargeCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeCrackedBlockRight_7d:
	ld b, $7d
	jr LargeCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeCrackedBlockRight_7e:
	ld b, $7e
	jr LargeCrackedBlockRightCollision

BlockFunc_LargeCrackedBlockRight_7f:
	ld b, $7f
	jr LargeCrackedBlockRightCollision

BlockFunc_LargeCrackedBlockRight_78:
	ld b, $78
;	fallthrough

LargeCrackedBlockRightCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18e92
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_18e9a
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_18e64
	bit COLLISION_UP_F, a
	jr nz, .asm_18e73
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_18e73
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_18e8a
	jp BlockFunc_Solid
.asm_18e64
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_18e8a
	ld a, [wIsRolling]
	and a
	jr nz, .asm_18e8a
	jp BlockFunc_Solid
.asm_18e73
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_18e8a
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_18e8a
	jp BlockFunc_Solid
.asm_18e8a
	ld a, $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak_Wario
.asm_18e92
	or $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18e9a
	ld a, $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_LargeCrackedBlockDown_79:
	ld b, $79
	jr LargeCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeCrackedBlockDown_7a:
	ld b, $7a
	jr LargeCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeCrackedBlockDown_7b:
	ld b, $7b
	jr LargeCrackedBlockDownCollision

BlockFunc_LargeCrackedBlockDown_7c:
	ld b, $7c
	jr LargeCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeCrackedBlockDown_7d:
	ld b, $7d
	jr LargeCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeCrackedBlockDown_7e:
	ld b, $7e
	jr LargeCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeCrackedBlockDown_7f:
	ld b, $7f
	jr LargeCrackedBlockDownCollision

BlockFunc_LargeCrackedBlockDown_78:
	ld b, $78
;	fallthrough

LargeCrackedBlockDownCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18f26
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_18f2d
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_18ef8
	bit COLLISION_UP_F, a
	jr nz, .asm_18f07
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_18f07
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_18f1e
	jp BlockFunc_Solid
.asm_18ef8
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_18f1e
	ld a, [wIsRolling]
	and a
	jr nz, .asm_18f1e
	jp BlockFunc_Solid
.asm_18f07
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_18f1e
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_18f1e
	jp BlockFunc_Solid
.asm_18f1e
	ld a, $03
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak_Wario
.asm_18f26
	or $03
	ld [wMultiBlockParam], a
	jr StartMultiBlockBreak
.asm_18f2d
	ld a, $03
	ld [wMultiBlockParam], a
;	fallthrough

StartMultiBlockBreak:
	ld a, [wSRAMBank]
	ld [wMultiBlockOriginBank], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld [wMultiBlockOriginPtr + 0], a
	ld d, a
	ld a, [hl]
	ld [wMultiBlockOriginPtr + 1], a
	ld e, a
	ld a, [de]
	ld [wUnused_cedf], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	jp BlockFunc_Free

BlockFunc_LargeCrackedBlockLeft_79:
	ld b, $79
	jr LargeCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeCrackedBlockLeft_7a:
	ld b, $7a
	jr LargeCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeCrackedBlockLeft_7b:
	ld b, $7b
	jr LargeCrackedBlockLeftCollision

BlockFunc_LargeCrackedBlockLeft_7c:
	ld b, $7c
	jr LargeCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeCrackedBlockLeft_7d:
	ld b, $7d
	jr LargeCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeCrackedBlockLeft_7e:
	ld b, $7e
	jr LargeCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeCrackedBlockLeft_7f:
	ld b, $7f
	jr LargeCrackedBlockLeftCollision

BlockFunc_LargeCrackedBlockLeft_78:
	ld b, $78
;	fallthrough

; same as LargeCrackedBlockUpCollision but outputs $02 in wMultiBlockParam
LargeCrackedBlockLeftCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_18fe3
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_18feb
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_18fb5
	bit COLLISION_UP_F, a
	jr nz, .asm_18fc4
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_18fc4
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_18fdb
	jp BlockFunc_Solid
.asm_18fb5
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_18fdb
	ld a, [wIsRolling]
	and a
	jr nz, .asm_18fdb
	jp BlockFunc_Solid
.asm_18fc4
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_18fdb
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_18fdb
	jp BlockFunc_Solid
.asm_18fdb
	ld a, $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak_Wario
.asm_18fe3
	or $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_18feb
	ld a, $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_LargeCrackedBlockUp_79:
	ld b, $79
	jr LargeCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeCrackedBlockUp_7a:
	ld b, $7a
	jr LargeCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeCrackedBlockUp_7b:
	ld b, $7b
	jr LargeCrackedBlockUpCollision

BlockFunc_LargeCrackedBlockUp_7c:
	ld b, $7c
	jr LargeCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeCrackedBlockUp_7d:
	ld b, $7d
	jr LargeCrackedBlockUpCollision

BlockFunc_LargeCrackedBlockUp_7e:
	ld b, $7e
	jr LargeCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeCrackedBlockUp_7f:
	ld b, $7f
	jr LargeCrackedBlockUpCollision

BlockFunc_LargeCrackedBlockUp_78:
	ld b, $78
;	fallthrough

; same as LargeCrackedBlockLeftCollision but outputs $04 in wMultiBlockParam
LargeCrackedBlockUpCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_19076
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_1907e
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_19049
	bit COLLISION_UP_F, a
	jr nz, .asm_19058
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_19058
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_1906f
	jp BlockFunc_Solid
.asm_19049
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_1906f
	ld a, [wIsRolling]
	and a
	jr nz, .asm_1906f
	jp BlockFunc_Solid
.asm_19058
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_1906f
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_1906f
	jp BlockFunc_Solid
.asm_1906f
	ld a, $04
	ld [wMultiBlockParam], a
	jr StartMultiBlockBreak_Wario
.asm_19076
	or $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_1907e
	ld a, $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

StartMultiBlockBreak_Wario:
	ld a, [wSRAMBank]
	ld [wMultiBlockOriginBank], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld [wMultiBlockOriginPtr + 0], a
	ld d, a
	ld a, [hl]
	ld [wMultiBlockOriginPtr + 1], a
	ld e, a
	ld a, [de]
	ld [wUnused_cedf], a
	ld a, TRUE
	ld [wIsFloorTransition], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	ld a, [wIsRolling]
	and a
	jp nz, BlockFunc_Free
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jp z, BlockFunc_Free
	ld a, [wIsSmashAttacking]
	and a
	jr nz, .asm_190d5
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	jp BlockFunc_Free
.asm_190d5
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
	jp BlockFunc_Free

; unreferenced
BlockFunc_LargeNonCrackedBlockRight_79:
	ld b, $79
	jr LargeNonCrackedBlockRightCollision

BlockFunc_LargeNonCrackedBlockRight_7a:
	ld b, $7a
	jr LargeNonCrackedBlockRightCollision

BlockFunc_LargeNonCrackedBlockRight_7b:
	ld b, $7b
	jr LargeNonCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockRight_7c:
	ld b, $7c
	jr LargeNonCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockRight_7d:
	ld b, $7d
	jr LargeNonCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockRight_7e:
	ld b, $7e
	jr LargeNonCrackedBlockRightCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockRight_7f:
	ld b, $7f
	jr LargeNonCrackedBlockRightCollision

BlockFunc_LargeNonCrackedBlockRight_78:
	ld b, $78
;	fallthrough

LargeNonCrackedBlockRightCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Solid
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_19185
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_1918d
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jr z, .asm_19145
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_1914f
	bit COLLISION_UP_F, a
	jr nz, .asm_1915e
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_1915e
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_19175
	jp BlockFunc_Solid
.asm_19145
	ld a, [wCollisionPoints]
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_1917d
	jp BlockFunc_Solid
.asm_1914f
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_1917d
	ld a, [wIsRolling]
	and a
	jr nz, .asm_19175
	jp BlockFunc_Solid
.asm_1915e
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_1917d
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_1917d
	jp BlockFunc_Solid
.asm_19175
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
.asm_1917d
	ld a, $01
	ld [wMultiBlockParam], a
	jp Func_193dc
.asm_19185
	or $01
	ld [wMultiBlockParam], a
	jp Func_19246
.asm_1918d
	ld a, $01
	ld [wMultiBlockParam], a
	jp Func_19246

; unreferenced
BlockFunc_LargeNonCrackedBlockDown_79:
	ld b, $79
	jr LargeNonCrackedBlockDownCollision

BlockFunc_LargeNonCrackedBlockDown_7a:
	ld b, $7a
	jr LargeNonCrackedBlockDownCollision

BlockFunc_LargeNonCrackedBlockDown_7b:
	ld b, $7b
	jr LargeNonCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockDown_7c:
	ld b, $7c
	jr LargeNonCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockDown_7d:
	ld b, $7d
	jr LargeNonCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockDown_7e:
	ld b, $7e
	jr LargeNonCrackedBlockDownCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockDown_7f:
	ld b, $7f
	jr LargeNonCrackedBlockDownCollision

BlockFunc_LargeNonCrackedBlockDown_78:
	ld b, $78
;	fallthrough

LargeNonCrackedBlockDownCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Solid
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_1923a
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_19241
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jr z, .asm_191fa
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_19204
	bit COLLISION_UP_F, a
	jr nz, .asm_19213
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_19213
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_1922a
	jp BlockFunc_Solid
.asm_191fa
	ld a, [wCollisionPoints]
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_19232
	jp BlockFunc_Solid
.asm_19204
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_19232
	ld a, [wIsRolling]
	and a
	jr nz, .asm_19232
	jp BlockFunc_Solid
.asm_19213
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_19232
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_19232
	jp BlockFunc_Solid
.asm_1922a
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
.asm_19232
	ld a, $03
	ld [wMultiBlockParam], a
	jp Func_193dc
.asm_1923a
	or $03
	ld [wMultiBlockParam], a
	jr Func_19246
.asm_19241
	ld a, $03
	ld [wMultiBlockParam], a
;	fallthrough

Func_19246:
	ld a, [wSRAMBank]
	ld [wMultiBlockOriginBank], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld [wMultiBlockOriginPtr + 0], a
	ld d, a
	ld a, [hl]
	ld [wMultiBlockOriginPtr + 1], a
	ld e, a
	ld a, [de]
	ld [wUnused_cedf], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	jp BlockFunc_Free

; unreferenced
BlockFunc_LargeNonCrackedBlockLeft_79:
	ld b, $79
	jr LargeNonCrackedBlockLeftCollision

BlockFunc_LargeNonCrackedBlockLeft_7a:
	ld b, $7a
	jr LargeNonCrackedBlockLeftCollision

BlockFunc_LargeNonCrackedBlockLeft_7b:
	ld b, $7b
	jr LargeNonCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockLeft_7c:
	ld b, $7c
	jr LargeNonCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockLeft_7d:
	ld b, $7d
	jr LargeNonCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockLeft_7e:
	ld b, $7e
	jr LargeNonCrackedBlockLeftCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockLeft_7f:
	ld b, $7f
	jr LargeNonCrackedBlockLeftCollision

BlockFunc_LargeNonCrackedBlockLeft_78:
	ld b, $78
;	fallthrough

LargeNonCrackedBlockLeftCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Solid
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_19318
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_19320
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jr z, .asm_192d8
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_192e2
	bit COLLISION_UP_F, a
	jr nz, .asm_192f1
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_192f1
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_19308
	jp BlockFunc_Solid
.asm_192d8
	ld a, [wCollisionPoints]
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_19310
	jp BlockFunc_Solid
.asm_192e2
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_19310
	ld a, [wIsRolling]
	and a
	jr nz, .asm_19310
	jp BlockFunc_Solid
.asm_192f1
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_19310
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_19310
	jp BlockFunc_Solid
.asm_19308
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
.asm_19310
	ld a, $02
	ld [wMultiBlockParam], a
	jp Func_193dc
.asm_19318
	or $02
	ld [wMultiBlockParam], a
	jp Func_19246
.asm_19320
	ld a, $02
	ld [wMultiBlockParam], a
	jp Func_19246

; unreferenced
BlockFunc_LargeNonCrackedBlockUp_79:
	ld b, $79
	jr LargeNonCrackedBlockUpCollision

BlockFunc_LargeNonCrackedBlockUp_7a:
	ld b, $7a
	jr LargeNonCrackedBlockUpCollision

BlockFunc_LargeNonCrackedBlockUp_7b:
	ld b, $7b
	jr LargeNonCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockUp_7c:
	ld b, $7c
	jr LargeNonCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockUp_7d:
	ld b, $7d
	jr LargeNonCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockUp_7e:
	ld b, $7e
	jr LargeNonCrackedBlockUpCollision

; unreferenced
BlockFunc_LargeNonCrackedBlockUp_7f:
	ld b, $7f
	jr LargeNonCrackedBlockUpCollision

BlockFunc_LargeNonCrackedBlockUp_78:
	ld b, $78
;	fallthrough

LargeNonCrackedBlockUpCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Solid
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_193cc
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_ROBO_MOUSE_FREE
	jp z, BlockFunc_Free
	cp COLLISION_ROBO_MOUSE_BREAK
	jr z, .asm_193d4
	ld a, [wBlockFuncBreakFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jr z, .asm_1938d
	ld a, [wPowerUpLevel]
	cp GARLIC
	jp c, BlockFunc_Solid
	ld a, [wCollisionPoints]
	bit COLLISION_SIDE_F, a
	jr nz, .asm_19397
	bit COLLISION_UP_F, a
	jr nz, .asm_193a6
	bit COLLISION_UP_SIDES_F, a
	jr nz, .asm_193a6
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_193bd
	jp BlockFunc_Solid
.asm_1938d
	ld a, [wCollisionPoints]
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .asm_193c5
	jp BlockFunc_Solid
.asm_19397
	ld a, [wAttackCounter]
	and a
	jr nz, .asm_193c5
	ld a, [wIsRolling]
	and a
	jr nz, .asm_193c5
	jp BlockFunc_Solid
.asm_193a6
	ld a, [wPowerUpLevel]
	cp HEAD_SMASH_HELMET
	jp c, BlockFunc_Solid
	ld a, [wJumpVelTable]
	and a
	jr nz, .asm_193c5
	ld a, [wSwimVelIndex]
	and a
	jr nz, .asm_193c5
	jp BlockFunc_Solid
.asm_193bd
	ld a, [wPowerUpLevel]
	cp SUPER_JUMP_SLAM_OVERALLS
	jp c, BlockFunc_Solid
.asm_193c5
	ld a, $04
	ld [wMultiBlockParam], a
	jr Func_193dc
.asm_193cc
	or $04
	ld [wMultiBlockParam], a
	jp Func_19246
.asm_193d4
	ld a, $04
	ld [wMultiBlockParam], a
	jp Func_19246

Func_193dc:
	ld a, [wSRAMBank]
	ld [wMultiBlockOriginBank], a
	ld hl, wBlockPtr
	ld a, [hli]
	ld [wMultiBlockOriginPtr + 0], a
	ld d, a
	ld a, [hl]
	ld [wMultiBlockOriginPtr + 1], a
	ld e, a
	ld a, [de]
	ld [wUnused_cedf], a
	ld a, TRUE
	ld [wIsFloorTransition], a
	jp BreakBlock_SolidUnlessRolling

BlockFunc_EnemyBlock_78:
	ld b, $78
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_79:
	ld b, $79
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_7a:
	ld b, $7a
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_7b:
	ld b, $7b
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_7c:
	ld b, $7c
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_7d:
	ld b, $7d
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_7e:
	ld b, $7e
	jr EnemyBlockCollision

BlockFunc_EnemyBlock_7f:
	ld b, $7f
;	fallthrough

EnemyBlockCollision:
	ld a, [wBlockFuncSpecialCollision]
	cp COLLISION_THROWN_OBJ
	jr z, Func_19423
	jp BlockFunc_Solid

Func_19423:
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw_IfObjOnScreen
	pop hl
	ld a, [wCurObjFlags]
	bit OBJFLAG_ON_SCREEN_F, a
	jr z, .not_on_screen
	call BreakBlock
	jp BlockFunc_Free
.not_on_screen
	play_sfx SFX_BLOCK_BREAK
	jp BlockFunc_Free

BlockFunc_BonfireBlock_78:
	ld b, $78
	jr BonfireBlockCollision

BlockFunc_BonfireBlock_79:
	ld b, $79
	jr BonfireBlockCollision

BlockFunc_BonfireBlock_7a:
	ld b, $7a
	jr BonfireBlockCollision

BlockFunc_BonfireBlock_7b:
	ld b, $7b
	jr BonfireBlockCollision

BlockFunc_BonfireBlock_7c:
	ld b, $7c
	jr BonfireBlockCollision

BlockFunc_BonfireBlock_7d:
	ld b, $7d
	jr BonfireBlockCollision

BlockFunc_BonfireBlock_7e:
	ld b, $7e
	jr BonfireBlockCollision

; unreferenced
BlockFunc_BonfireBlock_7f:
	ld b, $7f
;	fallthrough

BonfireBlockCollision:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_HOT_WARIO
	jr nz, .dont_break
	ld a, [wTransformationProgress]
	cp 2
	jr nc, Func_19481 ; engulfed in flames
.dont_break
	jp BlockFunc_Solid

Func_19481:
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	jp BlockFunc_Free

BlockFunc_DoughnutBlock_78:
	ld b, $78
	jr DoughnutBlockCollision

BlockFunc_DoughnutBlock_79:
	ld b, $79
	jr DoughnutBlockCollision

BlockFunc_DoughnutBlock_7a:
	ld b, $7a
	jr DoughnutBlockCollision

BlockFunc_DoughnutBlock_7b:
	ld b, $7b
	jr DoughnutBlockCollision

; unreferenced
BlockFunc_DoughnutBlock_7c:
	ld b, $7c
	jr DoughnutBlockCollision

; unreferenced
BlockFunc_DoughnutBlock_7d:
	ld b, $7d
	jr DoughnutBlockCollision

; unreferenced
BlockFunc_DoughnutBlock_7e:
	ld b, $7e
	jr DoughnutBlockCollision

; unreferenced
BlockFunc_DoughnutBlock_7f:
	ld b, $7f
;	fallthrough

DoughnutBlockCollision:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jp nz, BlockFunc_Solid
	ld a, [wCollisionPoints]
	and COLLISION_LANDING | COLLISION_LANDING_SIDES
	jr nz, .break
	jp BlockFunc_Solid
.break
	ld hl, wBlockPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	ld a, [hl]
	and $80
	or b
	ld [hl], a
	push hl
	call QueueBlockRedraw
	pop hl
	call BreakBlock
	jp BlockFunc_Solid

; unreferenced
BlockFunc_SmallYarnBlock_78:
	ld b, $78
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_79:
	ld b, $79
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_7a:
	ld b, $7a
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_7b:
	ld b, $7b
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_7c:
	ld b, $7c
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_7d:
	ld b, $7d
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_7e:
	ld b, $7e
	jr SmallYarnBlockCollision

; unreferenced
BlockFunc_SmallYarnBlock_7f:
	ld b, $7f
;	fallthrough

SmallYarnBlockCollision:
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jp z, Func_19481
	jp BlockFunc_Solid

; unreferenced
BlockFunc_YarnBlockRight_79:
	ld b, $79
	jr YarnBlockRightCollision

BlockFunc_YarnBlockRight_7a:
	ld b, $7a
	jr YarnBlockRightCollision

; unreferenced
BlockFunc_YarnBlockRight_7b:
	ld b, $7b
	jr YarnBlockRightCollision

BlockFunc_YarnBlockRight_78:
	ld b, $78
;	fallthrough

YarnBlockRightCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_1954a
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr z, .asm_19542
	jp BlockFunc_Solid
.asm_19542
	ld a, $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_1954a
	or $01
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_YarnBlockDown_79:
	ld b, $79
	jr YarnBlockDownCollision

BlockFunc_YarnBlockDown_7a:
	ld b, $7a
	jr YarnBlockDownCollision

; unreferenced
BlockFunc_YarnBlockDown_7b:
	ld b, $7b
	jr YarnBlockDownCollision

BlockFunc_YarnBlockDown_78:
	ld b, $78
;	fallthrough

YarnBlockDownCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_19585
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr z, .asm_19580
	jp BlockFunc_Solid
.asm_19580
	ld a, $03
	ld [wMultiBlockParam], a
.asm_19585
	or $03
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_YarnBlockLeft_79:
	ld b, $79
	jr YarnBlockLeftCollision

; unreferenced
BlockFunc_YarnBlockLeft_7a:
	ld b, $7a
	jr YarnBlockLeftCollision

; unreferenced
BlockFunc_YarnBlockLeft_7b:
	ld b, $7b
	jr YarnBlockLeftCollision

BlockFunc_YarnBlockLeft_78:
	ld b, $78
;	fallthrough

YarnBlockLeftCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_195c3
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr z, .asm_195bb
	jp BlockFunc_Solid
.asm_195bb
	ld a, $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_195c3
	or $02
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BlockFunc_YarnBlock_79:
	ld b, $79
	jr YarnBlockCollision

; unreferenced
BlockFunc_YarnBlock_7a:
	ld b, $7a
	jr YarnBlockCollision

; unreferenced
BlockFunc_YarnBlock_7b:
	ld b, $7b
	jr YarnBlockCollision

BlockFunc_YarnBlock_78:
	ld b, $78
;	fallthrough

YarnBlockCollision:
	ld a, [wMultiBlockParam]
	and $07
	jp nz, BlockFunc_Free
	ld a, [wMultiBlockParam]
	and $f8
	jr nz, .asm_19601
	ld a, [wBlockFuncWarioFlag]
	and a
	jp z, BlockFunc_Solid
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr z, .asm_195f9
	jp BlockFunc_Solid
.asm_195f9
	ld a, $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak
.asm_19601
	or $04
	ld [wMultiBlockParam], a
	jp StartMultiBlockBreak

BreakBlock:
	; temporarily store hPos
	ldh a, [hYPosHi]
	ldh [hYPosHiBackup], a
	ldh a, [hYPosLo]
	ldh [hYPosLoBackup], a
	ldh a, [hXPosHi]
	ldh [hXPosHiBackup], a
	ldh a, [hXPosLo]
	ldh [hXPosLoBackup], a

	ld b, PARTICLE_DEBRIS
	farcall CreateParticleInBlock
	ldh a, [rDIV]
	and %11
	jr nz, .done
	ld a, [wCoinCooldown]
	and a
	jr nz, .done
	; everything okay, spawn coin
	push_wram BANK("Level Objects WRAM")
	ld a, COIN_COOLDOWN
	ld [wCoinCooldown], a

	; backup CurObj
	ld hl, wCurObjMapPtrLo
	ld de, hCurObjBackup
	ld b, OBJ_ID - OBJ_MAP_PTR_LO
	call CopyHLToDE

	ld hl, wCurObjMapPtrLo
	xor a
	ld [hli], a ; flags
	ld [hli], a ; unk01
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ldh a, [hXPosLo]
	ld [hli], a
	ldh a, [hXPosHi]
	ld [hli], a
	ld bc, ObjParams_Coin
	farcall _CreateObjectFromCurObjPos

	; restore CurObj
	ld hl, hCurObjBackup
	ld de, wCurObjMapPtrLo
	ld b, OBJ_ID - OBJ_MAP_PTR_LO
	call CopyHLToDE
	pop_wram

.done
	; restore hPos
	ldh a, [hYPosHiBackup]
	ldh [hYPosHi], a
	ldh a, [hYPosLoBackup]
	ldh [hYPosLo], a
	ldh a, [hXPosHiBackup]
	ldh [hXPosHi], a
	ldh a, [hXPosLoBackup]
	ldh [hXPosLo], a
	ret

BreakBlockWithColourCoin:
	; temporarily store hPos
	ldh a, [hYPosHi]
	ldh [hYPosHiBackup], a
	ldh a, [hYPosLo]
	ldh [hYPosLoBackup], a
	ldh a, [hXPosHi]
	ldh [hXPosHiBackup], a
	ldh a, [hXPosLo]
	ldh [hXPosLoBackup], a

	ld b, PARTICLE_DEBRIS
	farcall CreateParticleInBlock
	push_wram BANK("Level Objects WRAM")

	; backup CurObj
	ld hl, wCurObjMapPtrLo
	ld de, hCurObjBackup
	ld b, OBJ_ID - OBJ_MAP_PTR_LO
	call CopyHLToDE

	ld hl, wCurObjMapPtrLo
	xor a
	ld [hli], a
	ld [hli], a
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ldh a, [hXPosLo]
	ld [hli], a
	ldh a, [hXPosHi]
	ld [hli], a
	ld bc, ObjParams_ColourCoin
	farcall _CreateObjectFromCurObjPos

	; restore CurObj
	ld hl, hCurObjBackup
	ld de, wCurObjMapPtrLo
	ld b, OBJ_ID - OBJ_MAP_PTR_LO
	call CopyHLToDE
	pop_wram

	; restore hPos
	ldh a, [hYPosHiBackup]
	ldh [hYPosHi], a
	ldh a, [hYPosLoBackup]
	ldh [hYPosLo], a
	ldh a, [hXPosHiBackup]
	ldh [hXPosHi], a
	ldh a, [hXPosLoBackup]
	ldh [hXPosLo], a
	ret
