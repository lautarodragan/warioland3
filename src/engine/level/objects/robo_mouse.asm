RoboMouseFunc:
	ld hl, wCurObjUpdateFunction + 1
	ld a, HIGH(.Init)
	ld [hld], a
	ld a, LOW(.Init)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	set OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_COLLBOX_RIGHT
	ld a, $0b
	ld [hld], a
	ld a, $f4
	ld [hld], a
	ld a, $fc
	ld [hl], a
	ret

.Init:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jr c, .asm_4891f
	res OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, RoboMouseFrameset_69220
	jp SetObjectFramesetPtr
.asm_4891f
	set OBJSUBFLAG_HDIR_F, [hl]
	dec l
	xor a
	ld [hld], a
	ld de, RoboMouseFrameset_691de
	jp SetObjectFramesetPtr

.Update:
	ld a, [wCurObjState]
	jumptable

	dw .Default
	dw .Land
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .VanishTouch
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .StandingFallStart
	dw .Default
	dw .TurnAroundStart
	dw ObjState_FallLeftStart
	dw ObjState_FallRightStart
	dw .TurnAroundStart
	dw .TurnAroundStart
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
	dw .State22
	dw .State23
	dw .State24
	dw .State25
	dw .State26
	dw .State27
	dw .Default
	dw .Default
	dw .Activate
	dw .Default
	dw .Default
	dw .Special1
	dw .Special2
	dw .Default
	dw ObjState_Fall
	dw .Walk
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .State3a
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw .Default
	dw ObjState_StandingFall
	dw .Default
	dw .TurnAround
	dw .Default
	dw .Default
	dw .Default
	dw .Default
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
	dw .State52
	dw .State53
	dw .State54
	dw .State55
	dw .State56
	dw .State57
	dw .Default
	dw .Default
	dw .State5a
	dw .Default
	dw .Default

.Activate:
	ld hl, wCurObjState
	ld a, $5a
	ld [hld], a
	ld a, [hld]
	rlca
	ld_obj_frameset RoboMouseFrameset_69200, RoboMouseFrameset_691fb
	call SetObjectFramesetPtr
	ret

.State5a:
	ret

.State24:
	call .BreakBlocksInFront
	jp ObjState_Bounce3LeftStart
.State54:
	call .BreakBlocksInFront
	jp ObjState_Bounce3Left
.State25:
	call .asm_48d3d
	jp ObjState_Bounce3RightStart
.State55:
	call .asm_48d3d
	jp ObjState_Bounce3Right
.State22:
	call .BreakBlocksInFront
	jp ObjState_Bounce2LeftStart
.State52:
	call .BreakBlocksInFront
	jp ObjState_Bounce2Left
.State23:
	call .asm_48d3d
	jp ObjState_Bounce2RightStart
.State53:
	call .asm_48d3d
	jp ObjState_Bounce2Right
.State26:
	call .BreakBlocksInFront
	jp ObjState_FallLeftStart
.State56:
	call .BreakBlocksInFront
	jp ObjState_FallLeft
.State27:
	call .asm_48d3d
	jp ObjState_FallRightStart
.State57:
	call .asm_48d3d
	jp ObjState_FallRight
.VanishTouch:
	ld hl, wCurObjFlags
	bit OBJFLAG_NO_COLLISION_F, [hl]
	jr z, .asm_48a8e
	res OBJFLAG_NO_COLLISION_F, [hl]
	res OBJFLAG_PRIORITY_F, [hl]
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset RoboMouseFrameset_6920c, RoboMouseFrameset_69205
	call SetObjectFramesetPtr
	ld a, $3c
	ld [hli], a
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hld], a
	play_sfx SFX_VANISH
	ld bc, ObjParams_StarsAbove
	call CreateObjectFromCurObjPos
	ld a, [wWarioScreenXPos]
	add $2a
	ld b, a
	ld a, [wCurObjScreenXPos]
	add $2a
	cp b
	jp c, .State24
	jp .State25
.asm_48a8e
	ld l, OBJ_STATE
	ld a, $3a
	ld [hld], a
	ld a, [wCurObjInteractionType]
	and $7f
	cp $0b
	jr z, .asm_48aab
	ld a, [hld]
	rlca
	ld_obj_frameset RoboMouseFrameset_69220, RoboMouseFrameset_691de
	call SetObjectFramesetPtr
.asm_48aab
	ld l, OBJ_FLAGS
	bit OBJFLAG_ON_SCREEN_F, [hl]
	ret z
	ld l, OBJ_Y_POS
	ld a, [hli]
	and $f0
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	ld hl, wCurObjYPos
	ld a, [hli]
	ldh [hYPosLo], a
	ld a, [hli]
	ldh [hYPosHi], a
	ld a, [hli]
	ldh [hXPosLo], a
	ld a, [hl]
	ldh [hXPosHi], a
	ld b, PARTICLE_SPLASH
	farcall CreateParticle
	play_sfx SFX_SMALL_SPLASH
	ret

.State3a:
	call MoveObjectDown_Slow
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
	ret z
	ld a, [wCurObjInteractionType]
	and $7f
	cp $0b
	jr z, .asm_48b0d
	ld a, $31
	jr .asm_48b0f
.asm_48b0d
	ld a, $13
.asm_48b0f
	ld [wCurObjState], a
	ret

.Default:
	ld hl, wCurObjState
	ld a, $30
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ld l, OBJ_FLAGS
	res OBJFLAG_NO_COLLISION_F, [hl]
	ret

.StandingFallStart:
	ld hl, wCurObjState
	ld a, $41
	ld [hld], a
	dec l
	xor a
	ld [hld], a
	ret

.Land:
	ld a, $31
	ld [wCurObjState], a
.Walk:
	ld a, [wCurObjSubState]
	rlca
	jp c, .asm_48bc2
	call MoveObjectLeft
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
	jp z, .asm_48bb7
	cp $10
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ret z
	ld a, [hli]
	sub $08
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	call ProcessBlock_Down
	and a
	jr z, .asm_48ba2
	call .asm_48ce8
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	sub $14
	ldh [hXPosLo], a
	ld a, [hl]
	sbc $00
	ldh [hXPosHi], a
	ld a, COLLISION_ROBO_MOUSE_FREE
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	and $0f
	ret z
	ld hl, wCurObjYPos
	ld a, [hl]
	sub $06
	ld [hli], a
	jr nc, .asm_48b9b
	dec [hl]
.asm_48b9b
	ld a, $24
	ld [wCurObjState], a
	jr .asm_48ba7
.asm_48ba2
	ld a, $22
	ld [wCurObjState], a
.asm_48ba7
	ld a, $02
	ld [wCurObjVar2], a
	ld de, RoboMouseFrameset_69213
	ld a, [wCurObjFramesetPtr]
	cp e
	ret z
	jp SetObjectFramesetPtr

.asm_48bb7
	ld a, $11
	ld [wCurObjState], a
	ld de, RoboMouseFrameset_69220
	jp SetObjectFramesetPtr

.asm_48bc2
	call MoveObjectRight
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
	jp z, .asm_48c42
	cp $10
	ld hl, wCurObjYPos
	ldh a, [hYPosLo]
	ld [hli], a
	ldh a, [hYPosHi]
	ld [hli], a
	ret z
	ld a, [hli]
	add $07
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	call ProcessBlock_Down
	and a
	jr z, .asm_48c2d
	call .asm_48d39
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, [hli]
	add $13
	ldh [hXPosLo], a
	ld a, [hl]
	adc $00
	ldh [hXPosHi], a
	ld a, COLLISION_ROBO_MOUSE_FREE
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	and $0f
	ret z
	ld hl, wCurObjYPos
	ld a, [hl]
	sub $06
	ld [hli], a
	jr nc, .asm_48c26
	dec [hl]
.asm_48c26
	ld a, $25
	ld [wCurObjState], a
	jr .asm_48c32
.asm_48c2d
	ld a, $23
	ld [wCurObjState], a
.asm_48c32
	ld a, $02
	ld [wCurObjVar2], a
	ld de, RoboMouseFrameset_691e5
	ld a, [wCurObjFramesetPtr]
	cp e
	ret z
	jp SetObjectFramesetPtr

.asm_48c42
	ld a, $11
	ld [wCurObjState], a
	ld de, RoboMouseFrameset_691de
	jp SetObjectFramesetPtr
.TurnAroundStart:
	ld a, $43
	ld [wCurObjState], a
	ld a, $01
	ld hl, wCurObjFlags
	bit OBJFLAG_ON_SCREEN_F, [hl]
	jr z, .asm_48c5d
	ld a, $0a
.asm_48c5d
	ld [wCurObjStateDuration], a
.TurnAround:
	ld hl, wCurObjStateDuration
	dec [hl]
	jp nz, ObjCheckFloorOrStandingFall
	ld l, OBJ_X_POS
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld l, OBJ_SUBSTATE
	ld a, [wWarioXPos + 0]
	cp d
	jr c, .asm_48c8a
	jr nz, .asm_48c7c
	ld a, [wWarioXPos + 1]
	cp e
	jr c, .asm_48c8a
.asm_48c7c
	ld a, [hli]
	rlca
	jr c, .asm_48ca5
	ld a, $2d
	ld [hld], a
	set OBJSUBFLAG_HDIR_F, [hl]
	ld de, RoboMouseFrameset_69227
	jr .asm_48c96
.asm_48c8a
	ld a, [hli]
	rlca
	jr nc, .asm_48ca5
	ld a, $2e
	ld [hld], a
	res OBJSUBFLAG_HDIR_F, [hl]
	ld de, RoboMouseFrameset_691f2
.asm_48c96
	call SetObjectFramesetPtr
	ld a, $31
	ld [hli], a
.asm_48c9c
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_ROBO_MOUSE
	ld [hld], a
	ret

.asm_48ca5
	ld a, $31
	ld [hld], a
	ld a, [wCurObjInteractionType]
	and $7f
	cp $0b
	jr nz, .asm_48c9c
	ld a, [hld]
	rlca
	ld_obj_frameset RoboMouseFrameset_69220, RoboMouseFrameset_691de
	call SetObjectFramesetPtr
	ld l, OBJ_FLAGS
	set OBJFLAG_PRIORITY_F, [hl]
	jr .asm_48c9c
.Special1:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, RoboMouseFrameset_691de
	call SetObjectFramesetPtr
	ld a, $31
	ld [wCurObjState], a
	ret

.Special2:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld de, RoboMouseFrameset_69220
	call SetObjectFramesetPtr
	ld a, $31
	ld [wCurObjState], a
	ret

.asm_48ce8
	ld b, $0c
	jr .asm_48cee
.BreakBlocksInFront:
	ld b, $0e
.asm_48cee
	ld hl, wCurObjXPos
	ld a, [hli]
	sub b
	ldh [hXPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hXPosHi], a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, COLLISION_ROBO_MOUSE_BREAK
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $14
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, COLLISION_ROBO_MOUSE_BREAK
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $24
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, COLLISION_ROBO_MOUSE_BREAK
	ld [wBlockFuncSpecialCollision], a
	jp ProcessBlock_Side

.asm_48d39
	ld b, $0b
	jr .asm_48d3f
.asm_48d3d
	ld b, $0d
.asm_48d3f
	ld hl, wCurObjXPos
	ld a, [hli]
	add b
	ldh [hXPosLo], a
	ld a, [hli]
	adc $00
	ldh [hXPosHi], a
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $04
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, COLLISION_ROBO_MOUSE_BREAK
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $14
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, COLLISION_ROBO_MOUSE_BREAK
	ld [wBlockFuncSpecialCollision], a
	call ProcessBlock_Side
	ld hl, wCurObjYPos
	ld a, [hli]
	sub $24
	ldh [hYPosLo], a
	ld a, [hli]
	sbc $00
	ldh [hYPosHi], a
	ld a, COLLISION_ROBO_MOUSE_BREAK
	ld [wBlockFuncSpecialCollision], a
	jp ProcessBlock_Side
