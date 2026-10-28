ProcessInteractions:
	ld a, [wIsIntangible]
	and a
	ret nz ; quit if Wario is intangible
	ld a, [wIsFloorTransition]
	and a
	ret nz ; quit if floor is transitioning
	ld a, [wAutoMoveState]
	and a
	ret nz ; quit if auto-moving
	xor a
	ld [wIsOnSteppableObject], a

	ld hl, wObjects
.loop_objects
	ld a, h
	cp HIGH(wObjects) + 1
	ret z
	ld [wObjPtr + 0], a
	ld a, l
	ld [wObjPtr + 1], a
	ld a, [hl] ; OBJ_FLAGS
	and OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN
	cp OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN
	jr z, .is_visible
.next_obj
	ld a, [wObjPtr + 0]
	ld h, a
	ld a, [wObjPtr + 1]
	ld l, a
	ld de, OBJ_STRUCT_LENGTH
	add hl, de
	jr .loop_objects

.is_visible
	push hl
	ld e, OBJ_ACTION_SIDE
	ld d, $00
	add hl, de
	ld a, [hld]
	ld [wUnused_c1b8], a
	ld a, [hl] ; OBJ_ACTION
	pop hl
	and a
	jr nz, .next_obj

	ld e, OBJ_INTERACTION_TYPE
	ld d, $00
	add hl, de
	ld a, [hli] ; OBJ_INTERACTION_TYPE
	ld [wObjInteractionType], a
	ld a, [hli] ; OBJ_COLLBOX_TOP
	ld [wObjCollBoxTop], a
	ld a, [hli] ; OBJ_COLLBOX_BOTTOM
	ld [wObjCollBoxBottom], a
	ld a, [hli] ; OBJ_COLLBOX_LEFT
	ld [wObjCollBoxLeft], a
	ld a, [hli] ; OBJ_COLLBOX_RIGHT
	ld [wObjCollBoxRight], a
	ld a, [hli] ; OBJ_SCREEN_Y_POS
	ld [wObjScreenYPos], a
	ld a, [hl] ; OBJ_SCREEN_X_POS
	ld [wObjScreenXPos], a

	ld e, OBJ_SUBSTATE - OBJ_SCREEN_X_POS
	ld d, $00
	add hl, de
	ld a, [hl] ; OBJ_SUBSTATE
	bit OBJSUBFLAG_HDIR_F, a
	jr nz, .obj_facing_right
	ld a, DIRECTION_LEFT
	jr .got_obj_direction
.obj_facing_right
	ld a, DIRECTION_RIGHT
.got_obj_direction
	ld [wObjDirection], a

	xor a
	ld [wInteractionSide], a
	ld a, $ff
	ld [wObjOverlapFromBelow], a
	ld [wObjOverlapFromAbove], a
	ld [wObjOverlapFromLeft], a
	ld [wObjOverlapFromRight], a

	ld e, $d0
	ld hl, wObjCollBoxTop
	ld a, [wObjScreenYPos]
	add [hl]
	sub e
	ld b, a
	ld hl, wCollisionBoxBottom
	ld a, [wWarioScreenYPos]
	add [hl]
	sub e
	sub b
	jp c, .next_obj
	ld c, a

	ld hl, wCollisionBoxTop
	ld a, [wWarioScreenYPos]
	add [hl]
	sub e
	ld b, a
	ld hl, wObjCollBoxBottom
	ld a, [wObjScreenYPos]
	add [hl]
	sub e
	sub b
	jp c, .next_obj
	ld d, a
	ld a, d
	sub c
	jr c, .from_below
	jr z, .equal_y_overlap

	ld a, c
	ld [wObjOverlapFromAbove], a
	jr .check_x_overlap
.equal_y_overlap
	ld a, c
	ld [wObjOverlapFromAbove], a
.from_below
	ld a, d
	ld [wObjOverlapFromBelow], a
.check_x_overlap

	ld hl, wObjCollBoxLeft
	ld a, [wObjScreenXPos]
	add [hl]
	sub e
	ld b, a
	ld hl, wCollisionBoxRight
	ld a, [wWarioScreenXPos]
	add [hl]
	sub e
	sub b
	jp c, .next_obj
	ld c, a
	ld hl, wCollisionBoxLeft
	ld a, [wWarioScreenXPos]
	add [hl]
	sub e
	ld b, a
	ld hl, wObjCollBoxRight
	ld a, [wObjScreenXPos]
	add [hl]
	sub e
	sub b
	jp c, .next_obj
	ld d, a
	sub c
	jr c, .from_right
	jr z, .equal_x_overlap

	ld a, c
	ld [wObjOverlapFromLeft], a
	jr .got_overlaps
.equal_x_overlap
	ld a, c
	ld [wObjOverlapFromLeft], a
.from_right
	ld a, d
	ld [wObjOverlapFromRight], a
.got_overlaps

	ld hl, wInteractionSide
	ld a, INTERACTION_LEFT | INTERACTION_RIGHT | INTERACTION_UP | INTERACTION_DOWN
	ld [hl], a
	ld a, [wObjOverlapFromRight]
	ld b, a
	ld a, [wObjOverlapFromLeft]
	ld c, a
	cp b
	jr z, .got_x_side
	jr c, .left_overlap_smaller
	res INTERACTION_RIGHT_F, [hl]
	jr .got_x_side
.left_overlap_smaller
	res INTERACTION_LEFT_F, [hl]
	ld b, c
.got_x_side
	ld a, [wObjOverlapFromBelow]
	ld d, a
	ld a, [wObjOverlapFromAbove]
	ld e, a
	cp d
	jr z, .got_y_side
	jr c, .above_overlap_smaller
	res INTERACTION_UP_F, [hl]
	jr .got_y_side
.above_overlap_smaller
	res INTERACTION_DOWN_F, [hl]
	ld d, e
.got_y_side
	ld a, b
	cp d
	jr z, .do_interaction
	jr c, .x_overlap_smaller
	res INTERACTION_LEFT_F, [hl]
	res INTERACTION_RIGHT_F, [hl]
	jr .do_interaction
.x_overlap_smaller
	res INTERACTION_UP_F, [hl]
	res INTERACTION_DOWN_F, [hl]

.do_interaction
	ld a, [wObjInteractionType]
	and INTERACTION_MASK
	jumptable

.table
	table_width 2
	dw ObjInteraction_Grabbable                        ; OBJ_INTERACTION_GRABBABLE
	dw ObjInteraction_Touch                        ; OBJ_INTERACTION_01
	dw ObjInteraction_FrontSting         ; OBJ_INTERACTION_FRONT_STING
	dw ObjInteraction_BackSting          ; OBJ_INTERACTION_BACK_STING
	dw ObjInteraction_TopSting           ; OBJ_INTERACTION_TOP_STING
	dw ObjInteraction_FullSting          ; OBJ_INTERACTION_FULL_STING
	dw ObjInteraction_WaterBump                        ; OBJ_INTERACTION_WATER_BUMP
	dw ObjInteraction_WaterKnockBack                        ; OBJ_INTERACTION_WATER_KNOCK_BACK
	dw ObjInteraction_WaterFrontSting                        ; OBJ_INTERACTION_WATER_FRONT_STING
	dw ObjInteraction_FrontBump                        ; OBJ_INTERACTION_FRONT_BUMP
	dw ObjInteraction_BumpOff                        ; OBJ_INTERACTION_BUMP_OFF
	dw ObjInteraction_BumpOffPause                        ; OBJ_INTERACTION_BUMP_OFF_PAUSE
	dw ObjInteraction_Walkable           ; OBJ_INTERACTION_WALKABLE
	dw ObjInteraction_MusicalCoin        ; OBJ_INTERACTION_MUSICAL_COIN
	dw ObjInteraction_Fire               ; OBJ_INTERACTION_FIRE
	dw ObjInteraction_Richtertoffen      ; OBJ_INTERACTION_RICHTERTOFFEN
	dw ObjInteraction_GreyKey            ; OBJ_INTERACTION_GREY_KEY
	dw ObjInteraction_RedKey             ; OBJ_INTERACTION_RED_KEY
	dw ObjInteraction_GreenKey           ; OBJ_INTERACTION_GREEN_KEY
	dw ObjInteraction_BlueKey            ; OBJ_INTERACTION_BLUE_KEY
	dw ObjInteraction_GreyTreasure       ; OBJ_INTERACTION_GREY_TREASURE
	dw ObjInteraction_RedTreasure        ; OBJ_INTERACTION_RED_TREASURE
	dw ObjInteraction_GreenTreasure      ; OBJ_INTERACTION_GREEN_TREASURE
	dw ObjInteraction_BlueTreasure       ; OBJ_INTERACTION_BLUE_TREASURE
	dw ObjInteraction_Omodonmeka         ; OBJ_INTERACTION_OMODONMEKA
	dw ObjInteraction_Silky              ; OBJ_INTERACTION_SILKY
	dw ObjInteraction_Food               ; OBJ_INTERACTION_FOOD
	dw ObjInteraction_RegularCoin        ; OBJ_INTERACTION_REGULAR_COIN
	dw ObjInteraction_Electric           ; OBJ_INTERACTION_ELECTRIC
	dw ObjInteraction_InvisibilityPotion ; OBJ_INTERACTION_INVISIBILITY_POTION
	dw ObjInteraction_Pneumo             ; OBJ_INTERACTION_PNEUMO
	dw ObjInteraction_ZombieHead         ; OBJ_INTERACTION_ZOMBIE_HEAD
	dw ObjInteraction_Bouncy             ; OBJ_INTERACTION_BOUNCY
	dw ObjInteraction_FireBot            ; OBJ_INTERACTION_FIRE_BOT
	dw ObjInteraction_Solid              ; OBJ_INTERACTION_SOLID
	dw ObjInteraction_Omodon             ; OBJ_INTERACTION_OMODON
	dw ObjInteraction_OrangeBird         ; OBJ_INTERACTION_ORANGE_BIRD
	dw ObjInteraction_Vampire            ; OBJ_INTERACTION_VAMPIRE
	dw ObjInteraction_Bubble             ; OBJ_INTERACTION_BUBBLE
	dw ObjInteraction_Ice                ; OBJ_INTERACTION_ICE
	dw ObjInteraction_Owl                ; OBJ_INTERACTION_OWL
	dw ObjInteraction_Rail               ; OBJ_INTERACTION_RAIL
	dw ObjInteraction_Haridama           ; OBJ_INTERACTION_HARIDAMA
	dw ObjInteraction_AnonsterWave       ; OBJ_INTERACTION_ANONSTER_WAVE
	dw ObjInteraction_AnonsterSilk       ; OBJ_INTERACTION_ANONSTER_SILK
	dw ObjInteraction_Snow               ; OBJ_INTERACTION_SNOW
	dw ObjInteraction_UnlitTorch         ; OBJ_INTERACTION_UNLIT_TORCH
	dw ObjInteraction_Stove              ; OBJ_INTERACTION_STOVE
	dw ObjInteraction_RoboMouse          ; OBJ_INTERACTION_ROBO_MOUSE
	dw ObjInteraction_SolidPlatform                        ; OBJ_INTERACTION_SOLID_PLATFORM
	dw ObjInteraction_DollBoyHammer      ; OBJ_INTERACTION_DOLL_BOY_HAMMER
	dw ObjInteraction_RollingRock        ; OBJ_INTERACTION_ROLLING_ROCK
	dw ObjInteraction_Wormwould          ; OBJ_INTERACTION_WORMWOULD
	dw ObjInteraction_Beam               ; OBJ_INTERACTION_BEAM
	dw ObjInteraction_SmashableTop                        ; OBJ_INTERACTION_SMASHABLE_TOP
	dw ObjInteraction_YellowBellyArrow   ; OBJ_INTERACTION_YELLOW_BELLY_ARROW
	dw ObjInteraction_Teruteru           ; OBJ_INTERACTION_TERUTERU
	dw ObjInteraction_WaterDrop          ; OBJ_INTERACTION_WATER_DROP
	dw ObjInteraction_Pesce              ; OBJ_INTERACTION_PESCE
	dw ObjInteraction_GrabbableWalkable                        ; OBJ_INTERACTION_GRABBABLE_WALKABLE
	dw ObjInteraction_Tadpole            ; OBJ_INTERACTION_TADPOLE
	dw ObjInteraction_Hebarii            ; OBJ_INTERACTION_HEBARII
	dw ObjInteraction_PrinceFroggy       ; OBJ_INTERACTION_PRINCE_FROGGY
	dw ObjInteraction_Hand               ; OBJ_INTERACTION_HAND
	dw ObjInteraction_WaterTeleporting   ; OBJ_INTERACTION_WATER_TELEPORTING
	dw ObjInteraction_Scowler            ; OBJ_INTERACTION_SCOWLER
	dw ObjInteraction_Ink                ; OBJ_INTERACTION_INK
	dw GetStungByObjectInWater                        ; OBJ_INTERACTION_WATER_FULL_STING
	dw ObjInteraction_Jamano             ; OBJ_INTERACTION_JAMANO
	dw ObjInteraction_Turtle             ; OBJ_INTERACTION_TURTLE
	dw ObjInteraction_FrontStingBumpOff                        ; OBJ_INTERACTION_FRONT_STING_BUMP_OFF
	dw ObjInteraction_TopStingBumpOff                        ; OBJ_INTERACTION_TOP_STING_BUMP_OFF
	dw ObjInteraction_BottomStingSmashableTop                        ; OBJ_INTERACTION_BOTTOM_STING_SMASHABLE_TOP
	dw ObjInteraction_WaterFrontLaunch                        ; OBJ_INTERACTION_WATER_FRONT_LAUNCH
	dw ObjInteraction_ColourCoin         ; OBJ_INTERACTION_COLOUR_COIN
	dw ObjInteraction_MagicalSpiral      ; OBJ_INTERACTION_MAGICAL_SPIRAL
	dw ObjInteraction_BottomSting        ; OBJ_INTERACTION_BOTTOM_STING
	dw ObjInteraction_Shoot              ; OBJ_INTERACTION_SHOOT
	dw ObjInteraction_GKTortoise                        ; OBJ_INTERACTION_GK_TORTOISE
	dw ObjInteraction_FrontPushBumpOff                        ; OBJ_INTERACTION_FRONT_PUSH_BUMP_OFF
	dw ObjInteraction_FrontDragDown                        ; OBJ_INTERACTION_FRONT_DRAG_DOWN
	dw ObjInteraction_WaterKnockBackTopRight                        ; OBJ_INTERACTION_WATER_KNOCK_BACK_TOP_RIGHT
	dw ObjInteraction_FrontStingSmashableTop                        ; OBJ_INTERACTION_FRONT_STING_SMASHABLE_TOP
	dw ObjInteraction_None               ; OBJ_INTERACTION_UNUSED_1
	dw ObjInteraction_None               ; OBJ_INTERACTION_UNUSED_2
	dw ObjInteraction_None               ; OBJ_INTERACTION_UNUSED_3
	dw ObjInteraction_None               ; OBJ_INTERACTION_UNUSED_4
	dw ObjInteraction_None               ; OBJ_INTERACTION_UNUSED_5
	dw ObjInteraction_None               ; OBJ_INTERACTION_UNUSED_6
	assert_table_length NUM_OBJ_INTERACTIONS

ObjInteraction_None:
	ret

; clears the screen from objects
; when opening a treasure
TreasureClearObjects:
	ld hl, wObjects
	ld de, OBJ_STRUCT_LENGTH
.loop_objects
	ld a, h
	cp HIGH(wCurObj)
	ret z
	ld a, [hl] ; OBJ_FLAGS
	and OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN
	cp OBJFLAG_ACTIVE
	jr z, .vanish_obj
	cp OBJFLAG_ACTIVE | OBJFLAG_ON_SCREEN
	jr z, .vanish_obj
.next_obj
	add hl, de
	jr .loop_objects
.vanish_obj
	ld a, [wObjPtr + 1]
	cp l
	jr z, .next_obj
	push hl
	ld c, OBJ_ACTION
	ld b, $00
	add hl, bc
	ld [hl], OBJACTION_VANISH_TREASURE
	pop hl
	jr .next_obj

TouchObject:
	ld a, [wIsRolling]
	and a
	jp nz, AttackObject
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, StepOnObject
;	fallthrough

BumpIntoObject:
	ld a, [wTouchState]
	and a
	jr z, .bump
	cp TOUCH_BUMP
	jr z, .bump
	cp TOUCH_VULNERABLE
	jp z, BumpOffObject ; this causes an infinite loop!
	cp TOUCH_ATTACK
	jp z, AttackObject
	cp TOUCH_VANISH
	jp z, VanishObjectAndKnockBackIfZombie
	jp ProcessInteractions.next_obj

.bump
	ld a, [wAttackCounter]
	and a
	jp nz, AttackObject

	ld b, OBJACTION_BUMP
	call SetObjAction

	ld a, [wInvincibleCounter]
	cp $01
	ret z ; is invincible
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr z, FlatWarioBumpIntoObject
	and a
	ret nz

	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jr .wario_bump
.obj_on_left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
.wario_bump
	jr SetState_EnemyBumping

FlatWarioBumpIntoObject:
	ld a, [wJumpVelTable]
	and a
	ret z
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jr .fall
.obj_on_left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
.fall
	farcall SetState_FlatFalling
	ret

SetState_EnemyBumping:
	play_sfx SFX_BUMP
	ld a, $0e
	ld [wJumpVelIndex], a
	ld a, $01
	ld [wJumpVelTable], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld [wGrabState], a

	ld a, WST_ENEMY_BUMPING
	ld [wWarioState], a

	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a

	ld a, [wIsCrouching]
	and a
	jr nz, .crouching
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioBumpFrameset_14a71)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_14a71)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.dir_right
	ld a, HIGH(WarioBumpFrameset_14a6c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_14a6c)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

.crouching
	ld a, [wDirection]
	and a
	jr nz, .crouching_dir_right
	ld a, HIGH(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a3b)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.crouching_dir_right
	ld a, HIGH(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14a38)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

; routine called when an object is attacked
; whether by Wario's B attack, Fat Wario bump, rolling, etc.
AttackObject:
	play_sfx SFX_ATTACK_HIT
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left

	ld a, INTERACTION_RIGHT
	ld [wInteractionSide], a
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
	sub $08
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a
	jr .spawn_stars

.obj_on_left
	ld a, INTERACTION_LEFT
	ld [wInteractionSide], a
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
	sub $08
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a

.spawn_stars
	ld b, PARTICLE_STARS
	farcall CreateParticle

	ld b, OBJACTION_ATTACK
	call SetObjAction
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jr z, .fat
	cp TRANSFORMATION_SNOWMAN_WARIO
	jr z, .snowman
	and a
	ret nz

	ld a, [wIsRolling]
	and a
	jr z, .not_rolling
	ld a, [wObjInteractionType]
	bit HEAVY_OBJ_F, a
	ret z
	ld a, [wPowerUpLevel]
	cp GARLIC
	ret nc
	farcall DoJumpingBump_NoSFX
	ret

.not_rolling
	ld a, [wObjInteractionType]
	bit HEAVY_OBJ_F, a
	jr z, .not_heavy
	farcall DoJumpingBump_NoSFX
	ret

.not_heavy
	ld a, [wJumpVelTable]
	and a
	jr nz, .airborne
	farcall SetState_Idling
	ret
.airborne
	farcall StartFall
	ret

.fat
	farcall SetState_FatBumping
	ret

.snowman
	ld a, [wTransformationProgress]
	and a
	ret nz
	farcall SetState_SnowmanBumped
	ret

; routine called when Wario steps on an object
StepOnObject:
; no stun if Wario is invincible
	ld a, [wInvincibleCounter]
	cp $01
	ret z

	ld a, [wIsSmashAttacking]
	dec a
	jr nz, .no_smash_attack
; Wario is smash attacking
	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jp z, VanishObjectAndKnockBackIfZombie
	jp JumpOffVanishingObject

.no_smash_attack
	ld a, [wTransformation]
	and a
	jp nz, .Transformed

; not transformed
	xor a
	ld [wAttackCounter], a

; stepping on object while rolling is attacking
	ld a, [wIsRolling]
	and a
	jp nz, AttackObject

	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .on_left
; on right
	ld a, [wInteractionSide]
	or INTERACTION_RIGHT
	ld [wInteractionSide], a
	jr .got_side
.on_left
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
.got_side
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jr nz, .not_from_above
	ld a, [wWarioScreenYPos]
	ld b, a
	ld a, [wObjScreenYPos]
	cp b
	jr c, .not_from_above

	ld a, [wGrabState]
	and GRAB_STATE_MASK
	cp GRAB_IDLE
	jr z, .grabbing
; clear grab state
	xor a
	ld [wGrabState], a

	ld a, [wIsCrouching]
	and a
	jr nz, .crouching_1
	ld a, [wJoypadDown]
	and a
	jp z, .no_input
	farcall StartJump_FromInput
	jr .set_jump

.crouching_1
	farcall StartCrouchJump
	jr .set_jump

.grabbing
	farcall SetState_GrabAirborne_Jump

.set_jump
	ld a,TRUE
	ld [wDoFullJump], a
	ld a, $0a
	ld [wJumpVelIndex], a

	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr z, .wobble_obj
	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	jr c, .wobble_obj
	xor a ; full jump
	ld [wJumpVelIndex], a
	jr .wobble_obj

.not_from_above
	ld a, [wInvincibleCounter]
	cp $01
	ret z
	ld a, [wIsCrouching]
	and a
	jr nz, .crouching_2

	ld a, [wGrabState]
	and GRAB_STATE_MASK
	cp GRAB_IDLE
	jr z, .grab_idle
	xor a
	ld [wGrabState], a
	ld a, [wJumpVelTable]
	and a
	jr nz, .airborne
	farcall SetState_Idling
	jr .wobble_obj

.airborne
	farcall StartFall
	jr .wobble_obj

.grab_idle
	ld a, [wJumpVelTable]
	and a
	jr z, .wobble_obj
	farcall SetState_GrabAirborne_Fall
	jr .wobble_obj

.crouching_2
	ld a, [wJumpVelTable]
	and a
	jr z, .wobble_obj
	farcall StartCrouchFall
	jr .wobble_obj

.no_input
	call BumpOffObject
.wobble_obj
	play_sfx SFX_STOMP
	ld b, OBJACTION_WOBBLE
	jp SetObjAction

.Transformed:
	ld a, [wTransformation]
	cp TRANSFORMATION_HOT_WARIO
	jr nz, .not_hot_wario
	ld a, [wTransformationProgress]
	cp 2
	jr nc, VanishObjectAndKnockBackIfZombie
.not_hot_wario

	ld a, [wTransformation]
	cp TRANSFORMATION_FAT_WARIO
	jp z, AttackObject
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .transformed_obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_RIGHT
	ld [wInteractionSide], a
	jr .transformed_got_side
.transformed_obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
.transformed_got_side
	play_sfx SFX_STOMP
	ld b, OBJACTION_WOBBLE
	call SetObjAction
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jp z, FlatWarioBumpIntoObject
	cp TRANSFORMATION_BOUNCY_WARIO
	jr z, .bouncy
	ret
.bouncy
	ld a, [wTouchState]
	cp TOUCH_PASS_THROUGH
	ret z
	farcall StartBouncyJump
	ret

VanishObjectAndKnockBackIfZombie:
	ld b, OBJACTION_VANISH_TOUCH
	call SetObjAction
	ld a, [wTransformation]
	cp TRANSFORMATION_ZOMBIE_WARIO
	ret nz
	farcall SetState_ZombieKnockBack
	ret

JumpOffVanishingObject:
	ld a, [wTransformation]
	cp TRANSFORMATION_INVISIBLE_WARIO
	jr z, .invisible
	and a
	jr nz, VanishObjectAndKnockBackIfZombie ; has transformation except invisible
.invisible
	ld a, [wGrabState]
	and GRAB_STATE_MASK
	cp GRAB_IDLE
	jr z, .grab_idle
	xor a
	ld [wGrabState], a
	farcall StartJump_FromInput
	jr .set_jump
.grab_idle
	farcall SetState_GrabAirborne_Jump
.set_jump
	ld a, TRUE
	ld [wDoFullJump], a
	ld a, $0a
	ld [wJumpVelIndex], a
	ld a, [wJoypadDown]
	bit B_PAD_A, a
	jr z, .vanish_obj
	ld a, [wPowerUpLevel]
	cp HIGH_JUMP_BOOTS
	jr c, .vanish_obj
	xor a
	ld [wJumpVelIndex], a
.vanish_obj
	ld b, OBJACTION_VANISH_TOUCH
;	fallthrough

SetObjAction:
	ld a, [wObjPtr + 0]
	ld h, a
	ld a, [wObjPtr + 1]
	ld l, a
	ld e, OBJ_ACTION
	ld d, $00
	add hl, de
	ld [hl], b
	inc l
	ld a, [wInteractionSide]
	ld b, a
	ld a, [hl] ; OBJ_ACTION_SIDE
	and $0f
	or b
	ld [hl], a
	ret

GetStungByObject:
	ld a, [wInvincibleCounter]
	and a
	jp nz, BumpOffObject

; if Wario is rolling, do attack
	ld a, [wPowerUpLevel]
	cp GARLIC
	jr nc, .check_rolling
	ld a, [wObjInteractionType]
	bit HEAVY_OBJ_F, a
	jr nz, .check_sting_touch_state
.check_rolling
	ld a, [wIsRolling]
	and a
	jp nz, AttackObject

.check_sting_touch_state
	ld a, [wStingTouchState]
	and a
	jr z, .sting
	cp TOUCH_VULNERABLE
	jr z, .sting
	cp TOUCH_BUMP
	jp z, BumpIntoObject
	cp TOUCH_ATTACK
	jp z, AttackObject
	cp TOUCH_VANISH
	jp z, VanishObjectAndKnockBackIfZombie
	jp ProcessInteractions.next_obj

.sting
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_RIGHT
	ld [wInteractionSide], a
	jr .got_side
.obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
.got_side
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .face_left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jr .set_action
.face_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a
.set_action
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	ld a, [wInvincibleCounter]
	cp $01
	ret z
	ld a, [wStingTouchState]
	cp TOUCH_VULNERABLE
	jr z, EndTransformationAndSting
	jr SetState_Stung

EndTransformationAndSting:
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	call z, ReleaseOwl
	call ClearTransformationValues
	call UpdateLevelMusic
;	fallthrough

SetState_Stung:
	ld a, $01
	ld [wInvincibleCounter], a

	play_sfx SFX_STING

	ld a, WST_STUNG
	ld [wWarioState], a

	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a
	ld a, $6
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
	ld a, JUMP_VEL_KNOCK_BACK
	ld [wJumpVelTable], a
	jr .load_gfx

.stay_crouched
	ld a, -15
	ld [wCollisionBoxTop], a
	xor a ; JUMP_VEL_NONE
	ld [wJumpVelTable], a

	ldh a, [hYPosHiBackup]
	ldh [hYPosHi], a
	ldh a, [hYPosLoBackup]
	ldh [hYPosLo], a
	ldh a, [hXPosHiBackup]
	ldh [hXPosHi], a
	ldh a, [hXPosLoBackup]
	ldh [hXPosLo], a

.load_gfx
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_15955)
	ld [wWarioOAMPtr + 1], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

GetStungByObjectInWater:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wWaterInteraction]
	and a
	ret z
	ld a, [wStingTouchState]
	and a
	jr z, .sting
	cp TOUCH_BUMP
	jp z, BumpObjectInWater.start
	cp TOUCH_VANISH
	jp z, VanishTouchedObject
	ret

.sting
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
;	fallthrough

SetState_WaterStung:
	play_sfx SFX_STING
	ld a, $01
	ld [wInvincibleCounter], a
	ld a, WST_WATER_STUNG
	ld [wWarioState], a
	xor a
	ld [wSwimVelIndex], a
	ld [wJumpVelTable], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, TRUE
	ld [wIsIntangible], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -15
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(OAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_15955)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

PushObjectInWater:
	ld a, [wStingTouchState]
	and a
	jr z, .push
	cp TOUCH_BUMP
	jr z, .push
	cp TOUCH_VANISH
	jp z, VanishTouchedObject
	ret

.push
	ld a, [wWaterInteraction]
	and a
	ret z
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_RIGHT
	ld [wInteractionSide], a
	jr .got_side
.obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
.got_side
	play_sfx SFX_STOMP
	ld b, OBJACTION_WOBBLE
	call SetObjAction
	ld a, [wTransformation]
	and a
	ret nz
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	ret nz
	farcall StartDive
	ret

BumpObjectInWater:
	jr .start

.Bump:
	ld b, OBJACTION_BUMP
	call SetObjAction
	ret

.start
	ld a, [wStingTouchState]
	and a
	jr z, .bump_obj
	cp TOUCH_BUMP
	jr z, .bump_obj
	cp TOUCH_VANISH
	jp z, VanishTouchedObject
	ret

.bump_obj
	ld a, [wWaterInteraction]
	and a
	ret z
	call .Bump
	ld a, [wInvincibleCounter]
	cp $01
	ret z
	ld a, [wTransformation]
	and a
	ret nz
	farcall StartDive
	ret

VanishTouchedObject:
	ld b, OBJACTION_VANISH_TOUCH
	jp SetObjAction

AttackOrBumpOffObject:
	ld a, [wAttackCounter]
	and a
	jp nz, AttackObject
;	fallthrough

BumpOffObject:
	ld a, [wTouchState]
	and a
	jp nz, BumpIntoObject
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	ld a, [wInvincibleCounter]
	cp $01
	ret z
	farcall DoJumpingBump
	ld a, BANK(WarioWalkGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioWalkGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioWalkGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld a, BANK(WarioWalkOAM_1426c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioWalkOAM_1426c)
	ld [wWarioOAMPtr + 1], a
	xor a
	ld [wGrabState], a
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, INTERACTION_RIGHT
	ld [wInteractionSide], a
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, HIGH(WarioBumpFrameset_14a79)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_14a79)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.obj_on_left
	ld a, INTERACTION_LEFT
	ld [wInteractionSide], a
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, HIGH(WarioBumpFrameset_14a76)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBumpFrameset_14a76)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

StandOnSolidObject:
	ld a, [wWarioState]
	cp WST_ATTACKING_AIRBORNE
	jr nz, .not_attacking_airborne
	; airborne
	xor a
	ld [wAttackCounter], a
.not_attacking_airborne
	ld a, [wWaterInteraction]
	and a
	ret nz
	ld a, [wWarioState]
	cp WST_DIVING
	ret z
	ld a, TRUE
	ld [wIsOnSteppableObject], a
	ld a, [wObjOverlapFromAbove]
	and a
	jr z, .set_stepped_on
	cp $03
	jr c, .got_overlap
	ld a, $02
.got_overlap
	ld b, a
	call MoveWarioUp
.set_stepped_on
	ld b, OBJACTION_STEP_ON
	call SetObjAction
	ld a, [wJumpVelTable]
	and a
	jr z, .done
	ld a, [wAttackCounter]
	and a
	jr nz, .done
	ld a, [wIsRolling]
	and a
	jr nz, .done
	call TriggerFloorTransition_SkipUpdateYPos
	ld a, [wInvincibleCounter]
	cp $01
	jr z, .done
	ld a, [wTransformation]
	and a
	ret nz
	ld a, [wGrabState]
	and a
	jr nz, .set_grab_state
	ld a, [wIsCrouching]
	and a
	jr nz, .crouching
	xor a
	ld [wWaterInteraction], a
	farcall SetState_Idling
	jr .done

.crouching
	xor a
	ld [wWaterInteraction], a
	farcall CrouchOrSlide
	jr .done

.set_grab_state
	farcall SetState_GrabIdling
.done
	jp ProcessInteractions.next_obj

TriggerObjInteraction:
	ld b, OBJACTION_TRIGGER
	call SetObjAction
	ret

SetObjAction_NoEffect:
	ld b, OBJACTION_NO_EFFECT
	call SetObjAction
	ret

PushAgainstSolidObject:
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
.obj_on_right
	ld a, [wDirection]
	and a
	jp z, ProcessInteractions.next_obj
	ld a, INTERACTION_RIGHT
	ld [wInteractionSide], a
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .check_transformation
	ld a, [wObjOverlapFromLeft]
	cp $ff
	jr z, .obj_on_left
	ld b, a
	call MoveWarioLeft
	jr .check_transformation

.obj_on_left
	ld a, [wDirection]
	and a
	jp nz, ProcessInteractions.next_obj
	ld a, INTERACTION_LEFT
	ld [wInteractionSide], a
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .check_transformation
	ld a, [wObjOverlapFromRight]
	cp $ff
	jr z, .obj_on_right
	ld b, a
	call MoveWarioRight
.check_transformation
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL_O_STRING_WARIO
	jr z, .ball_o_string
	cp TRANSFORMATION_HOT_WARIO
	jr z, .hot
	cp TRANSFORMATION_ICE_SKATIN
	jr z, .ice_skatin
	xor a
	ld [wWalkVelIndex], a
	ld a, [wIsRolling]
	and a
	jr nz, .bump
	ld a, [wAttackCounter]
	and a
	jp z, ProcessInteractions.next_obj

.bump
	farcall DoJumpingBump
	ret

.ball_o_string
	ld a, [wTransformationProgress]
	cp 1
	ret nz
	farcall BallOStringBounceOffWall
	ret

.hot
	ld a, [wTransformationProgress]
	cp 1
	ret nz
	farcall OnFireBounceOffWall
	ret

.ice_skatin
	ld a, [wWarioState]
	cp WST_ICE_SKATIN_CRASH
	ret z
	farcall IceSkatinCrashIntoWall
	ret

BumpOffObject_HitWarioShort:
	ld a, [wTouchState]
	and a
	jr z, .no_touch_state
	cp TOUCH_BUMP
	jp z, PushAgainstSolidObject
	cp TOUCH_VULNERABLE
	jp z, PushAgainstSolidObject
	cp TOUCH_ATTACK
	jp z, AttackObject
	cp TOUCH_VANISH
	jp z, VanishObjectAndKnockBackIfZombie
	jp PushAgainstSolidObject

.no_touch_state
	ld a, [wTouchState]
	and a
	ret nz
	call BumpOffObject
	ld b, OBJACTION_HIT_WARIO_SHORT
	jp SetObjAction

ObjInteraction_Grabbable:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StepOnObject
	ld a, [wTouchState]
	and a
	jr z, .check_water
	cp TOUCH_ATTACK
	jp z, AttackObject
	cp TOUCH_VANISH
	jp z, VanishObjectAndKnockBackIfZombie
	cp TOUCH_PASS_THROUGH
	jp z, ProcessInteractions.next_obj
	jp .step_on_obj

.check_water
	ld a, [wWarioState]
	cp WST_DIVING
	jr c, .not_in_water
	cp WST_TRYING_SUBMERGE + 1
	jp c, PushObjectInWater

.not_in_water
	ld a, [wIsRolling]
	ld b, a
	ld a, [wAttackCounter]
	or b
	jp nz, AttackObject

	ld a, [wIsCrouching]
	ld b, a
	ld a, [wGrabState]
	or b
	jp nz, .step_on_obj

	ld a, [wPowerUpLevel]
	cp GRAB_GLOVE
	jp c, .step_on_obj
	ld a, [wWarioState]
	cp WST_LADDER_SCRATCHING
	jp z, .step_on_obj
	cp WST_LADDER_CLIMBING
	jr c, .not_on_ladder
	cp WST_LADDER_SLIDING + 1
	jp c, .step_on_obj

.not_on_ladder
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, INTERACTION_RIGHT
	ld [wInteractionSide], a
	ld a, [wDirection]
	and a
	jr nz, .check_invincible_counter
	jr .step_on_obj
.obj_on_left
	ld a, INTERACTION_LEFT
	ld [wInteractionSide], a
	ld a, [wDirection]
	and a
	jr nz, .step_on_obj
.check_invincible_counter
	ld a, [wInvincibleCounter]
	cp 1
	ret z
	ld hl, wWarioXPos + 1
	ld de, hXPosLo
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	ld [de], a
	dec de
	ld a, [hld]
	sub $08
	ld [de], a
	dec de
	ld a, [hl]
	sbc $00
	ld [de], a

	ld a, [wObjInteractionType]
	bit HEAVY_OBJ_F, a
	jr nz, .heavy_obj
	ld a, GRAB_PICK_UP
	ld [wGrabState], a
	jr .set_obj_pick_up
.heavy_obj
	ld a, [wPowerUpLevel]
	cp SUPER_GRAB_GLOVES
	jr c, .step_on_obj
	ld a, GRAB_PICK_UP | (1 << GRAB_HEAVY_F)
	ld [wGrabState], a

.set_obj_pick_up
	ld b, OBJACTION_PICK_UP
	call SetObjAction

	ld a, [wJumpVelTable]
	and a
	jr z, .set_wario_pick_up
	ld a, [wObjInteractionType]
	bit HEAVY_OBJ_F, a
	jr z, .grab_airborne
	jr .step_on_obj
.grab_airborne
	farcall SetState_GrabAirborne_Fall
	ret

.step_on_obj
	jp StepOnObject

; unreachable
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .unused_obj_on_left
	ld a, INTERACTION_RIGHT
	ld [wInteractionSide], a
	jp BumpIntoObject

.unused_obj_on_left
	ld a, INTERACTION_LEFT
	ld [wInteractionSide], a
	jp BumpIntoObject

.set_wario_pick_up
	play_sfx SFX_GRAB

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld a, WST_PICKING_UP
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, BANK(WarioThrowGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioThrowGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioThrowGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOAM_1606a)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_1606a)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1606a)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .pick_up_dir_right
	ld a, [wWarioSlopeInteraction]
	bit LEFT_SLOPE_F, a
	jr nz, .on_slope
	ld a, [wGrabState]
	and (1 << GRAB_HEAVY_F)
	jr nz, .heavy_dir_left
	ld a, HIGH(WarioGrabFrameset_163ec)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_163ec)
	ld [wWarioFramesetPtr + 1], a
.update_animation
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret
.pick_up_dir_right
	ld a, [wWarioSlopeInteraction]
	bit RIGHT_SLOPE_F, a
	jr nz, .on_slope
	ld a, [wGrabState]
	and (1 << GRAB_HEAVY_F)
	jr nz, .heavy_dir_right
	ld a, HIGH(WarioGrabFrameset_1640c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_1640c)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.on_slope
	farcall SetState_GrabIdling
	ret
.heavy_dir_left
	ld a, HIGH(WarioGrabFrameset_163f5)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_163f5)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation
.heavy_dir_right
	ld a, HIGH(WarioGrabFrameset_16415)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioGrabFrameset_16415)
	ld [wWarioFramesetPtr + 1], a
	jr .update_animation

ObjInteraction_Touch:
	jp TouchObject

ObjInteraction_FrontSting:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jr nz, .vertical
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, GetStungByObject
	jp TouchObject
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, GetStungByObject
	jp TouchObject
.vertical
	jp StepOnObject

ObjInteraction_BackSting:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jr nz, .vertical
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, GetStungByObject
	jp TouchObject
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, GetStungByObject
	jp TouchObject
.vertical
	jp StepOnObject

ObjInteraction_TopSting:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, GetStungByObject
	bit INTERACTION_DOWN_F, a
	jp nz, StepOnObject
	jp TouchObject

ObjInteraction_FullSting:
	jp GetStungByObject

ObjInteraction_WaterBump:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, PushObjectInWater
	jp BumpObjectInWater

ObjInteraction_WaterKnockBack:
	ld a, [wWaterInteraction]
	and a
	ret z
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, GetStungByObjectInWater

	ld a, [wTransformation]
	and a
	ret nz
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jr nz, .dive
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_RIGHT
	ld [wInteractionSide], a
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jr .knock_back
.obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
	ld a, DIRECTION_RIGHT
	ld [wDirection], a

.knock_back
	farcall SetState_SwimKnockBack
	ret

.dive
	farcall StartDive
	ret

ObjInteraction_WaterFrontSting:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, PushObjectInWater
	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, GetStungByObjectInWater
	jp BumpObjectInWater
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, GetStungByObjectInWater
	jp BumpObjectInWater

ObjInteraction_Haridama:
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jp nz, PushObjectInWater
	bit INTERACTION_UP_F, a
	jp nz, GetStungByObjectInWater

	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, GetStungByObjectInWater
	jp BumpObjectInWater
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, GetStungByObjectInWater
	jp BumpObjectInWater

ObjInteraction_FrontBump:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jr nz, .vertical
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, BumpOffObject
	jp TouchObject
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, BumpOffObject
	jp TouchObject
.vertical
	jp StepOnObject

ObjInteraction_BumpOff:
	jp BumpOffObject

AttackOrBumpOffNoActions:
	ld a, [wAttackCounter]
	and a
	jp nz, AttackObject
;	fallthrough

ObjInteraction_BumpOffPause:
	call BumpOffObject
	ld a, [wTouchState]
	and a
	ret nz
	ld b, OBJACTION_PAUSE
	jp SetObjAction

ObjInteraction_Walkable:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnOrSmashObject
	jp AttackOrBumpOffObject

ObjInteraction_MusicalCoin:
	ld hl, wNumMusicalCoins
	ld a, [hl]
	cp NUM_LEVEL_MUSICAL_COINS
	jp nc, ProcessInteractions.next_obj
	inc [hl]
	play_sfx SFX_MUSICAL_COIN
	jp CollectMusicalCoin

ObjInteraction_Fire:
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject

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
;	fallthrough

SetState_OnFire_ResetStateCounter:
	xor a
	ld [wWarioStateCounter], a
;	fallthrough

SetState_OnFire:
	ld a, WST_ON_FIRE
	ld [wWarioState], a

	xor a
	ld [wInvisibleFrame], a
	ld [wSFXLoopCounter], a
	ld [wWarioStateCycles], a
	ld [wGrabState], a
	ld [wAttackCounter], a
	ld [wJumpVelIndex], a
	ld [wJumpVelTable], a
	ld [wIsCrouching], a
	ld [wIsRolling], a
	ld [wIsSmashAttacking], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	ld a, [wWarioStateCounter]
	and a
	ret nz

	ld hl, WarioOnFirePal
	call SetWarioPal

	ld a, BANK(WarioHotGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioHotGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioHotGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOnFireOAM_1673c)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOnFireOAM_1673c)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOnFireOAM_1673c)
	ld [wWarioOAMPtr + 1], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioOnFireFrameset_16b38)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b38)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioOnFireFrameset_16b49)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOnFireFrameset_16b49)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_Richtertoffen:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jr nz, .from_above
	bit INTERACTION_DOWN_F, a
	jr nz, .try_flatten_wario
	jp AttackOrBumpOffObject

.from_above
	ld a, [wIsSmashAttacking]
	dec a
	jp z, JumpOffVanishingObject
	jp StepOnObject

.try_flatten_wario
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a
	ld a, [wLadderInteraction]
	cp LADDER_UNDERNEATH
	jr z, .blocked
	farcall CheckBottomLeftCollision_Break
	ld a, b
	and a
	jr nz, .blocked
	farcall CheckBottomRightCollision_Break
	ld a, b
	and a
	jr nz, .blocked
	ld b, OBJACTION_FLATTEN
	call SetObjAction
	farcall SetState_FlatAirborne
	ret

.blocked
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	jp StepOnObject

; unreferenced?
UnreferencedSetObjAction_HitWario:
	ld b, OBJACTION_HIT_WARIO
	jp SetObjAction

ObjInteraction_GreyKey:
	ld hl, wKeyAndTreasureFlags
	set GREY_KEY_F, [hl]
	jr CollectKey

ObjInteraction_RedKey:
	ld hl, wKeyAndTreasureFlags
	set RED_KEY_F, [hl]
	jr CollectKey

ObjInteraction_GreenKey:
	ld hl, wKeyAndTreasureFlags
	set GREEN_KEY_F, [hl]
	jr CollectKey

ObjInteraction_BlueKey:
	ld hl, wKeyAndTreasureFlags
	set BLUE_KEY_F, [hl]
;	fallthrough

CollectKey:
	play_sfx SFX_KEY
	call TriggerObjInteraction
	ld a, ST_COLLECT_KEY
	ld [wState], a
	xor a
	ld [wTimer], a
	ret

ObjInteraction_GreyTreasure:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	ld a, [wTransformation]
	and a
	jp nz, PushAgainstSolidObject
	ld hl, wKeyAndTreasureFlags
	bit GREY_KEY_F, [hl]
	jp z, PushAgainstSolidObject
	set GREY_TREASURE_F, [hl]
	ld a, LVLEND_GREY_TREASURE
	ld [wLevelEndScreen], a
	jr GetTreasure

ObjInteraction_RedTreasure:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	ld a, [wTransformation]
	and a
	jp nz, PushAgainstSolidObject
	ld hl, wKeyAndTreasureFlags
	bit RED_KEY_F, [hl]
	jp z, PushAgainstSolidObject
	set RED_TREASURE_F, [hl]
	ld a, LVLEND_RED_TREASURE
	ld [wLevelEndScreen], a
	jr GetTreasure

ObjInteraction_GreenTreasure:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	ld a, [wTransformation]
	and a
	jp nz, PushAgainstSolidObject
	ld hl, wKeyAndTreasureFlags
	bit GREEN_KEY_F, [hl]
	jp z, PushAgainstSolidObject
	set GREEN_TREASURE_F, [hl]
	ld a, LVLEND_GREEN_TREASURE
	ld [wLevelEndScreen], a
	jr GetTreasure

ObjInteraction_BlueTreasure:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	ld a, [wTransformation]
	and a
	jp nz, PushAgainstSolidObject
	ld hl, wKeyAndTreasureFlags
	bit BLUE_KEY_F, [hl]
	jp z, PushAgainstSolidObject
	set BLUE_TREASURE_F, [hl]
	ld a, LVLEND_BLUE_TREASURE
	ld [wLevelEndScreen], a
;	fallthrough

GetTreasure:
	stop_music
	call TriggerObjInteraction
	call TreasureClearObjects

	ld hl, wLevelEndScreen
	ld a, [hl]
	cp LVLEND_NO_TREASURE
	ret z
	set 7, [hl]
	ld a, TRUE
	ld [wResetDisabled], a
	xor a
	ld [wWalkVelIndex], a

	ld a, WST_GET_TREASURE_START
	ld [wWarioState], a

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld [wJumpVelIndex], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wIsSmashAttacking], a
	ld [wIsCrouching], a
	ld [wAttackCounter], a

	inc a ; TRUE
	ld [wIsIntangible], a
	ld [wAutoMoveState], a

	ld a, [wJumpVelTable]
	and a
	jr z, .got_jump_vel
	ld a, FALLING_JUMP_VEL_INDEX
	ld [wJumpVelIndex], a
.got_jump_vel
	ld hl, WarioDefaultPal
	call SetWarioPal
	ld a, BANK(WarioIdleGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioIdleGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioIdleGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(OAM_14000)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_14000)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_14000)
	ld [wWarioOAMPtr + 1], a

	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .obj_on_left
	ld a, [wObjOverlapFromLeft]
	ld b, a
	call MoveWarioLeft
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	ld a, HIGH(WarioFrameset_1425f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1425f)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.obj_on_left
	ld a, [wObjOverlapFromRight]
	ld b, a
	call MoveWarioRight
	ld a, DIRECTION_LEFT
	ld [wDirection], a
	ld a, HIGH(WarioFrameset_14252)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_14252)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_Omodonmeka:
	ld a, [wJumpVelTable]
	and a
	jp nz, TouchObject

	ld b, OBJACTION_PICK_UP_WARIO
	call SetObjAction

	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jp z, SetState_FlatStretching
	and a
	jp nz, TouchObject

	; pick Wario up
	ld a, $01
	ld [wAutoMoveState], a
	ld a, WST_PICKED_UP
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
	ld [wIsSmashAttacking], a
	ld [wAttackCounter], a
	ld [wIsCrouching], a
	ld [wGrabState], a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	inc a
	ld [wJumpVelTable], a

	ld a, NUM_WIGGLES_TO_ESCAPE
	ld [wPickedUpWiggleCounter], a

	ld a, BANK(WarioAirborneGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioAirborneGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioAirborneGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(OAM_15955)
	ld [wWarioOAMBank], a
	ld a, HIGH(OAM_15955)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(OAM_15955)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f70)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_15f7f)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

SetState_FlatStretching:
	ld a, $01
	ld [wAutoMoveState], a
	ld a, WST_FLAT_STRETCHING
	ld [wWarioState], a
	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -8
	ld [wCollisionBoxTop], a
	ld a, -11
	ld [wCollisionBoxLeft], a
	ld a, 11
	ld [wCollisionBoxRight], a
	ld a, NUM_WIGGLES_TO_ESCAPE
	ld [wPickedUpWiggleCounter], a
	xor a
	ld [wWarioStateCounter], a
	ld [wWarioStateCycles], a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, HIGH(WarioFlatFrameset_17193)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFlatFrameset_17193)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_Silky:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jr nz, .vertical
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, TurnIntoBallOStringWario
	jp TouchObject

.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, TurnIntoBallOStringWario
	jp TouchObject

.vertical
	jp StepOnObject

TurnIntoBallOStringWario:
	ld a, [wIsCrouching]
	and a
	jr z, .transform
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr z, .transform
	ld a, -15
	ld [wCollisionBoxTop], a
	jp TouchObject

.transform
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, BumpIntoObject
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left

	ld a, DIRECTION_LEFT
	ld [wDirection], a
	jr .set_ball_o_string
.obj_on_left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a

.set_ball_o_string
	play_sfx SFX_BALL_O_STRING_TRANSFORM

	ld a, TRANSFORMATION_BALL_O_STRING_WARIO
	ld [wTransformation], a
	xor a
	ld [wTransformationProgress], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld a, TOUCH_ATTACK
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	call UpdateLevelMusic

	ld a, WST_GETTING_WRAPPED_IN_STRING
	ld [wWarioState], a

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

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a
	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a
	ld hl, WarioStringPal
	call SetWarioPal

	ld a, BANK(WarioStringGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioStringGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioStringGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioBallOStringOAM_171c0)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioBallOStringOAM_171c0)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioBallOStringOAM_171c0)
	ld [wWarioOAMPtr + 1], a

	ld a, HIGH(WarioBallOStringFrameset_17414)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioBallOStringFrameset_17414)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_Food:
	ld a, [wIsCrouching]
	and a
	jp nz, SetObjAction_NoEffect
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, SetObjAction_NoEffect
	cp TRANSFORMATION_FAT_WARIO
	jr nz, .set_fat_wario
	jp SetObjAction_NoEffect

.set_fat_wario
	call TriggerObjInteraction
	ld a, TRANSFORMATION_FAT_WARIO
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	ld a, HIGH(FAT_WARIO_DURATION)
	ld [wTransformationDuration + 0], a
	ld a, LOW(FAT_WARIO_DURATION)
	ld [wTransformationDuration + 1], a

	xor a
	ld [wInvisibleFrame], a
	ld [wSFXLoopCounter], a
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
	play_sfx SFX_EAT_FOOD
	call UpdateLevelMusic

	ld a, WST_FAT_EATING
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
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, BANK(WarioFatGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioFatGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioFatGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioOAM_1742d)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOAM_1742d)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOAM_1742d)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioFrameset_1789c)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_1789c)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioFrameset_178c3)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioFrameset_178c3)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_RegularCoin:
	ld hl, wNumCoins + 1
	ld a, [hl]
	add $1
	daa
	ld [hld], a
	ld a, [hl]
	adc $00
	daa
	ld [hl], a
	and $f0
	jr z, .no_cap
	ld a, HIGH(MAX_NUM_COINS)
	ld [hli], a
	ld a, LOW(MAX_NUM_COINS)
	ld [hl], a
.no_cap
	play_sfx SFX_REGULAR_COIN
	jp TriggerObjInteraction

ObjInteraction_Electric:
	ld a, [wWarioScreenXPos]
	ld b, a
	ld a, [wObjScreenXPos]
	cp b
	jr c, .obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_RIGHT
	ld [wInteractionSide], a
	jr .got_side

.obj_on_left
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
.got_side
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	cp TRANSFORMATION_ELECTRIC
	ret z
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .face_left
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	jr .shock
.face_left
	ld a, DIRECTION_LEFT
	ld [wDirection], a

.shock
	play_sfx SFX_ELECTRIC_SHOCK

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
	ld [wInvisibleFrame], a

	ld a, WST_ELECTRIC_START
	ld [wWarioState], a

	ld a, -1
	ld [wCollisionBoxBottom], a
	ld a, -27
	ld [wCollisionBoxTop], a
	ld a, -9
	ld [wCollisionBoxLeft], a
	ld a, 9
	ld [wCollisionBoxRight], a

	ld a, TRANSFORMATION_ELECTRIC
	ld [wTransformation], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld a, TOUCH_VANISH
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld hl, WarioElectricPal
	call SetWarioPal

	ld a, BANK(WarioElectricGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioElectricGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioElectricGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx

	ld a, BANK(WarioElectricOAM_1790e)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioElectricOAM_1790e)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioElectricOAM_1790e)
	ld [wWarioOAMPtr + 1], a

	ld a, [wDirection]
	and a
	jr nz, .dir_right
	ld a, HIGH(WarioElectricFrameset_17b79)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricFrameset_17b79)
	ld [wWarioFramesetPtr + 1], a
	jr .got_frameset
.dir_right
	ld a, HIGH(WarioElectricFrameset_17b76)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioElectricFrameset_17b76)
	ld [wWarioFramesetPtr + 1], a
.got_frameset
	ld a, BANK("Wario OAM 1")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_InvisibilityPotion:
	call TriggerObjInteraction
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	cp TRANSFORMATION_INVISIBLE_WARIO
	ret z
	farcall SetState_TurningInvisible
	ret

ObjInteraction_Pneumo:
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jr nz, ObjInteraction_YellowBellyArrow
	jp TouchObject

ObjInteraction_YellowBellyArrow:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject
	cp TRANSFORMATION_PUFFY_WARIO
	jp z, TouchObject
	ld a, [wTransformation]
	cp TRANSFORMATION_OWL_WARIO
	call z, ReleaseOwl
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	farcall SetState_PuffyInflating
	ret

ObjInteraction_ZombieHead:
	ld a, [wInvincibleCounter]
	and a
	jp nz, SetObjAction_NoEffect
	ld a, [wTransformation]
	cp TRANSFORMATION_ZOMBIE_WARIO
	jp z, VanishObjectAndKnockBackIfZombie
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, SetObjAction_NoEffect

	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	play_sfx SFX_ZOMBIE_TRANSFORM

	ld a, TRANSFORMATION_ZOMBIE_WARIO
	ld [wTransformation], a
	ld a, TOUCH_VANISH
	ld [wTouchState], a
	ld a, TOUCH_VANISH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	farcall SetState_ZombieIdling
	ret

ObjInteraction_Bouncy:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, StepOnObject
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, TurnIntoBouncyWario
	jp TouchObject
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, TurnIntoBouncyWario
	jp TouchObject

TurnIntoBouncyWario:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject
	cp TRANSFORMATION_BOUNCY_WARIO
	jp z, TouchObject
	ld a, TRANSFORMATION_BOUNCY_WARIO
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a

	ld a, HIGH(BOUNCY_WARIO_DURATION)
	ld [wTransformationDuration + 0], a
	ld a, LOW(BOUNCY_WARIO_DURATION)
	ld [wTransformationDuration + 1], a

	farcall SetState_BouncyStart
	ret

ObjInteraction_FireBot:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, StepOnObject
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .burn
	jp TouchObject
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .burn
	jp TouchObject
.burn
	jp ObjInteraction_Fire

ObjInteraction_Solid:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	bit INTERACTION_DOWN_F, a
	jr nz, PushWarioBelowSolidObject
	ld a, [wAttackCounter]
	and a
	jp nz, DoJumpingBump_Far
	jp PushAgainstSolidObject

PushWarioBelowSolidObject:
	ld a, [wWarioState]
	cp WST_FLAT_SQUISHED
	jr nz, .push_down
	farcall SetState_FlatSquishedLifting
	ret

.push_down
	ld a, [wObjOverlapFromBelow]
	cp $10
	jr c, .got_push_dist
	ld a, $0c
.got_push_dist
	ld b, a
	call MoveWarioDown
	farcall CheckTopBlockInteraction
	ld a, [wWaterInteraction]
	and a
	jr z, .not_in_water
	farcall DiveFromSurface_SkipSplash
	ret

.not_in_water
	farcall CheckCentreCollision
	ld a, b
	and a
	jr nz, .landed
	ld a, [wInvincibleCounter]
	cp $01
	ret z
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr z, .flat_fall
	and a
	ret nz
	ld a, [wIsCrouching]
	and a
	jr nz, .crouching
	xor a
	ld [wGrabState], a
	farcall StartFall
	ret

.landed
	ld hl, hYPosHi
	ld de, wWarioPos
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	ld a, [wInvincibleCounter]
	cp $01
	ret z
	ld a, [wTransformation]
	cp TRANSFORMATION_FLAT_WARIO
	jr z, .flat_landed
	and a
	ret nz
	xor a
	ld [wGrabState], a
	farcall SetState_Idling
	ret

.flat_fall
	farcall SetState_FlatFalling
	ret

.crouching
	farcall StartCrouchFall
	ret

.flat_landed
	ld a, [wWarioState]
	cp WST_FLAT_SQUISHED
	ret z
	farcall SetState_FlatIdling
	ret

ObjInteraction_Omodon:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	bit INTERACTION_DOWN_F, a
	jr nz, .from_below
	ld a, [wAttackCounter]
	and a
	jr nz, DoJumpingBump_Far
	jp PushAgainstSolidObject
.from_below
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	ld b, OBJACTION_FLATTEN
	call SetObjAction
	farcall SetState_FlatAirborne
	ret

DoJumpingBump_Far:
	farcall DoJumpingBump
	ret

ObjInteraction_OrangeBird:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jr nz, .vertical
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .front
	jp TouchObject
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .front
	jp TouchObject
.vertical
	jp StepOnObject

.front
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject
	cp TRANSFORMATION_CRAZY_WARIO
	jp z, TouchObject

	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, TRANSFORMATION_CRAZY_WARIO
	ld [wTransformation], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld a, TOUCH_ATTACK
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	farcall SetState_CrazySpinning
	ret

ObjInteraction_Vampire:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz

	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, TRANSFORMATION_VAMPIRE_WARIO
	ld [wTransformation], a
	farcall CheckTopBlockInteraction
	ld a, [wTransformation]
	cp TRANSFORMATION_VAMPIRE_WARIO
	ret nz
	farcall SetState_VampireTransforming
	ret

ObjInteraction_Bubble:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz

	ld b, OBJACTION_TRIGGER
	call SetObjAction

	ld a, TRANSFORMATION_BUBBLE
	ld [wTransformation], a
	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_BUMP
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	farcall SetState_InBubble
	ret

ObjInteraction_Ice:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	ld a, [wIsCrouching]
	and a
	jr z, .transform
	ld a, -27
	ld [wCollisionBoxTop], a
	farcall CheckUpCollision
	ld a, b
	and a
	jr z, .transform
	ld a, -15
	ld [wCollisionBoxTop], a
	ret

.transform
	ld b, OBJACTION_TRIGGER
	call SetObjAction

	play_sfx SFX_ZOMBIE_TRANSFORM
	ld a, TRANSFORMATION_ICE_SKATIN
	ld [wTransformation], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld a, TOUCH_ATTACK
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	farcall SetState_IceSkatinStart
	ret

ObjInteraction_Owl:
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jr nz, .from_below
	jp BumpOffObject

.from_below
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	cp TRANSFORMATION_OWL_WARIO
	ret z

	call TriggerObjInteraction

	play_sfx SFX_HANG_GRAB
	ld a, TRANSFORMATION_OWL_WARIO
	ld [wTransformation], a

	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_VULNERABLE
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a
	ld a, WST_GRABBING_OWL
	ld [wWarioState], a
	ld a, $ff
	ld [wCollisionBoxBottom], a
	ld a, $e5
	ld [wCollisionBoxTop], a
	ld a, $f7
	ld [wCollisionBoxLeft], a
	ld a, $09
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

	ld a, BANK(WarioHangGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioHangGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioHangGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioOwlOAM_1fddb4)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioOwlOAM_1fddb4)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioOwlOAM_1fddb4)
	ld [wWarioOAMPtr + 1], a
	ld a, [wObjDirection]
	ld [wDirection], a
	ld a, HIGH(WarioOwlFrameset_1fed53)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioOwlFrameset_1fed53)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_Rail:
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	ret nz
	cp TRANSFORMATION_RAIL
	ret z

	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	play_sfx SFX_HANG_GRAB
	ld a, TRANSFORMATION_RAIL
	ld [wTransformation], a

	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_VULNERABLE
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a

	ld a, WST_HANGING_RAIL
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
	ld [wJumpVelTable], a
	ld [wJumpVelIndex], a

	inc a
	ld [wAutoMoveState], a

	call UpdateLevelMusic

	xor a
	ld [wFrameDuration], a
	ld [wAnimationFrame], a

	ld a, BANK(WarioHangGfx)
	ld [wDMASourceBank], a
	ld a, HIGH(WarioHangGfx)
	ld [wDMASourcePtr + 0], a
	ld a, LOW(WarioHangGfx)
	ld [wDMASourcePtr + 1], a
	call LoadWarioGfx
	ld a, BANK(WarioRailOAM_1fee05)
	ld [wWarioOAMBank], a
	ld a, HIGH(WarioRailOAM_1fee05)
	ld [wWarioOAMPtr + 0], a
	ld a, LOW(WarioRailOAM_1fee05)
	ld [wWarioOAMPtr + 1], a

	ld a, [wObjDirection]
	ld [wDirection], a
	ld a, HIGH(WarioRailFrameset_1feec4)
	ld [wWarioFramesetPtr + 0], a
	ld a, LOW(WarioRailFrameset_1feec4)
	ld [wWarioFramesetPtr + 1], a
	ld a, BANK("Wario OAM 2")
	ldh [hCallFuncBank], a
	hcall UpdateWarioAnimation
	ret

ObjInteraction_AnonsterSilk:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StepOnObject
;	fallthrough

ObjInteraction_AnonsterWave:
	jp TurnIntoBallOStringWario

ObjInteraction_Snow:
	ld a, [wInvincibleCounter]
	and a
	jp nz, SetObjAction_NoEffect
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, SetObjAction_NoEffect
	call TriggerObjInteraction

	ld a, TRANSFORMATION_SNOWMAN_WARIO
	ld [wTransformation], a

	xor a
	ld [wTransformationProgress], a
	ld a, TOUCH_ATTACK
	ld [wTouchState], a
	ld a, TOUCH_ATTACK
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	farcall SetState_TurningIntoSnowman
	ret

ObjInteraction_UnlitTorch:
	ld a, [wTransformation]
	cp TRANSFORMATION_HOT_WARIO
	ret nz
	ld b, OBJACTION_LIGHT_TORCH
	jp SetObjAction

ObjInteraction_Stove:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jr nz, StandOnOrSmashObject
	bit INTERACTION_DOWN_F, a
	jp nz, PushWarioBelowSolidObject

	ld a, [wAttackCounter]
	and a
	jr nz, AttackSolidObject
	jp PushAgainstSolidObject

StandOnOrSmashObject:
	ld a, [wIsSmashAttacking]
	dec a
	jp nz, StandOnSolidObject
; smash attack object
	call JumpOffVanishingObject
	ld b, OBJACTION_SMASH_ATTACK_WALKABLE
	jp SetObjAction

AttackSolidObject:
	ld b, OBJACTION_ATTACK
	call SetObjAction
	jp PushAgainstSolidObject

ObjInteraction_RoboMouse:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jr nz, .from_above

	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .front
	jp ObjInteraction_BumpOffPause
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .front
	jp ObjInteraction_BumpOffPause

.from_above
	ld a, [wIsSmashAttacking]
	and a
	jp nz, JumpOffVanishingObject
	jp ObjInteraction_BumpOffPause
.front
	jp ObjInteraction_Jamano

ObjInteraction_SolidPlatform:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	bit INTERACTION_DOWN_F, a
	jp nz, StepOnObject
	ld a, [wAttackCounter]
	and a
	jp nz, DoJumpingBump_Far
	jp PushAgainstSolidObject

ObjInteraction_DollBoyHammer:
	jp TurnIntoBouncyWario

ObjInteraction_RollingRock:
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	ld a, [wIsRolling]
	and a
	ret nz
	ld a, [wObjDirection]
	ld [wDirection], a
	farcall SetState_RollingAirborne_Fall
	ret

ObjInteraction_Wormwould:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, StepOnObject
	ld a, [wAttackCounter]
	and a
	jp nz, AttackObject
;	fallthrough

BumpOffObject_NoAction:
	call BumpOffObject
	ld b, OBJACTION_NONE
	jp SetObjAction

ObjInteraction_Beam:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject

	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, TRANSFORMATION_SPLIT
	ld [wTransformation], a

	ld a, TOUCH_PASS_THROUGH
	ld [wTouchState], a
	ld a, TOUCH_PASS_THROUGH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	farcall SetState_SplitHit
	ret

ObjInteraction_SmashableTop:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jr z, .bump_off
	ld a, [wIsSmashAttacking]
	and a
	jp nz, JumpOffVanishingObject
.bump_off
	jp BumpOffObject

ObjInteraction_Teruteru:
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jp z, TouchObject
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject

	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, TRANSFORMATION_BLIND
	ld [wTransformation], a

	ld a, TOUCH_BUMP
	ld [wTouchState], a
	ld a, TOUCH_VULNERABLE
	ld [wStingTouchState], a
	ld a, $01
	ld [wSpikeTouchState], a

	farcall SetState_BlindIdling

	ld a, BGPI_AUTOINC | palette 0
	ldh [rBGPI], a
	ld b, 4
	ld c, LOW(rBGPD)
.loop_zero_bg_pals
	wait_not_hblank
	wait_hblank
	xor a
REPT 2 palettes
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_zero_bg_pals

	ld a, OBPI_AUTOINC | palette 3
	ldh [rOBPI], a
	ld b, 2
	ld c, LOW(rOBPD)
.loop_zero_ob_pals
	wait_not_hblank
	wait_hblank
	xor a
REPT 2 palettes
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_zero_ob_pals
	ret

ObjInteraction_WaterDrop:
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	ld a, [wTransformation]
	and a
	jp z, ProcessInteractions.next_obj
	jp RecoverFromTransformation

ObjInteraction_Pesce:
	ld a, [wObjDirection]
	cp DIRECTION_RIGHT
	jr z, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .swallow
	jp GetStungByObjectInWater
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .swallow
	jp GetStungByObjectInWater
.swallow
	ld b, OBJACTION_SWALLOW
	call SetObjAction
	farcall SetState_Swallowed
	ret

ObjInteraction_GrabbableWalkable:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnOrSmashObject
	jp ObjInteraction_Grabbable

ObjInteraction_Tadpole:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, StepOnObject
	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, ObjInteraction_RollingRock
	jp ObjInteraction_BumpOffPause
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, ObjInteraction_RollingRock
	jp ObjInteraction_BumpOffPause

	ret ; stray ret

ObjInteraction_Hebarii:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, ObjInteraction_BumpOffPause
	ld a, [wAttackCounter]
	and a
	jp nz, AttackObject
	jp ObjInteraction_BumpOffPause

ObjInteraction_PrinceFroggy:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	bit INTERACTION_DOWN_F, a
	jp nz, PushWarioBelowSolidObject
	jp BumpOffObject_HitWarioShort

ObjInteraction_Hand:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	and a
	ret nz

	play_sfx SFX_FAT_WALK
	farcall SetState_DraggedDown
;	fallthrough

SetObjAction_Special3:
	ld b, OBJACTION_SPECIAL_3
	call SetObjAction
	ret

ObjInteraction_WaterTeleporting:
	ld a, ROOMTRANSITION_TELEPORT | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	call SetState_WaterStung
	stop_sfx
	ld a, WST_WATER_TELEPORTING
	ld [wWarioState], a
	ld b, OBJACTION_TELEPORT
	jp SetObjAction

ObjInteraction_Scowler:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, PushObjectInWater
	bit INTERACTION_DOWN_F, a
	jr nz, ObjInteraction_WaterTeleporting
	jp BumpObjectInWater

ObjInteraction_Ink:
	ld b, OBJACTION_HIT_WARIO
	jp SetObjAction

ObjInteraction_Jamano:
	ld a, ROOMTRANSITION_TELEPORT | ROOMTRANSITIONF_DOOR | ROOMTRANSITIONF_RELOAD_OBJECTS | ROOMTRANSITIONF_DELAY
	ld [wRoomTransitionParam], a
	call EndTransformationAndSting
	stop_sfx
	ld a, WST_TELEPORTING
	ld [wWarioState], a
	ld b, OBJACTION_TELEPORT
	jp SetObjAction

ObjInteraction_Turtle:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, StandOnSolidObject
	ld a, [wTransformation]
	and a
	ret nz
	ld a, [wWaterInteraction]
	and a
	jp z, BumpOffObject_NoAction
	farcall StartDive
	ret

ObjInteraction_FrontStingBumpOff:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, ObjInteraction_BumpOffPause
	bit INTERACTION_DOWN_F, a
	jp nz, ObjInteraction_BumpOffPause
	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, GetStungByObject
	jp ObjInteraction_BumpOffPause
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, GetStungByObject
	jp ObjInteraction_BumpOffPause

ObjInteraction_TopStingBumpOff:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, GetStungByObject
	jp ObjInteraction_BumpOffPause

ObjInteraction_BottomStingSmashableTop:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jr nz, .from_above
	bit INTERACTION_DOWN_F, a
	jp nz, GetStungByObject
	jp ObjInteraction_BumpOffPause
.from_above
	ld a, [wIsSmashAttacking]
	and a
	jp nz, JumpOffVanishingObject
	jp ObjInteraction_BumpOffPause

ObjInteraction_WaterFrontLaunch:
	ld a, [wInteractionSide]
	and INTERACTION_UP | INTERACTION_DOWN
	jp nz, PushObjectInWater
	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, LaunchWario
	jp BumpObjectInWater
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, LaunchWario
	jp BumpObjectInWater

LaunchWario:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject
	ld a, [wObjDirection]
	ld [wDirection], a
	farcall SetState_Launched
	ld b, OBJACTION_HIT_WARIO
	jp SetObjAction

ObjInteraction_ColourCoin:
	play_sfx SFX_COLOUR_COIN
;	fallthrough

; adds 10 to coin count
CollectMusicalCoin:
	ld hl, wNumCoins + 1
	ld a, [hl]
	add $10
	daa
	ld [hld], a
	ld a, [hl]
	adc $00
	daa
	ld [hl], a
	and $f0
	jr z, .no_cap
	ld a, HIGH(MAX_NUM_COINS)
	ld [hli], a
	ld a, LOW(MAX_NUM_COINS)
	ld [hl], a
.no_cap
	call TriggerObjInteraction
	jp ProcessInteractions.next_obj

ObjInteraction_MagicalSpiral:
	ld a, [wInvincibleCounter]
	and a
	ret nz
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction

	ld a, TRANSFORMATION_MAGIC
	ld [wTransformation], a

	ld a, TOUCH_PASS_THROUGH
	ld [wTouchState], a
	ld a, TOUCH_PASS_THROUGH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a
	farcall SetState_MagicRising
	ret

ObjInteraction_BottomSting:
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jp nz, GetStungByObject
	bit INTERACTION_UP_F, a
	jp nz, StepOnObject
	jp TouchObject

ObjInteraction_Shoot:
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL
	jr z, ShootBallWario
	ld a, [wInteractionSide]
	bit INTERACTION_DOWN_F, a
	jr nz, .interaction_down
	bit INTERACTION_UP_F, a
	jp nz, StepOnObject
	jp AttackOrBumpOffNoActions

.interaction_down
	ld a, [wInvincibleCounter]
	and a
	ret nz ; skip if invincible
	ld a, [wTransformation]
	bit TRANSFORMATIONF_PERSISTENT_F, a
	jp nz, TouchObject

	; turn Wario into ball form
	ld b, OBJACTION_HIT_WARIO
	call SetObjAction
	ld a, TRANSFORMATION_BALL
	ld [wTransformation], a

	ld a, TOUCH_PASS_THROUGH
	ld [wTouchState], a
	ld a, TOUCH_PASS_THROUGH
	ld [wStingTouchState], a
	ld a, $02
	ld [wSpikeTouchState], a

	farcall SetState_BallStart
	ret

ShootBallWario:
	farcall SetState_BallShot
	jp SetObjAction_Special3

ObjInteraction_GKTortoise:
	ld a, [wTransformation]
	cp TRANSFORMATION_BALL
	jr z, ShootBallWario
	jp BumpOffObject

ObjInteraction_FrontPushBumpOff:
	ld a, [wObjDirection]
	ld b, a
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .front
	jr .bump_off
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .front
	jr .bump_off
.front
	ld a, [wObjDirection]
	xor $1
	ld [wDirection], a
	jp PushAgainstSolidObject
.bump_off
	jp BumpOffObject_NoAction

ObjInteraction_FrontDragDown:
	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jr nz, .drag_down
	jp ObjInteraction_BumpOffPause
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jr nz, .drag_down
	jp ObjInteraction_BumpOffPause
.drag_down
	play_sfx SFX_FAT_WALK
	farcall SetState_DraggedDown
	jp SetObjAction_Special3

ObjInteraction_WaterKnockBackTopRight:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jr nz, .from_above
	jp ObjInteraction_WaterKnockBack
.from_above
	ld a, [wInteractionSide]
	or INTERACTION_LEFT
	ld [wInteractionSide], a
	ld a, DIRECTION_RIGHT
	ld [wDirection], a
	farcall SetState_SwimKnockBack
	ret

ObjInteraction_FrontStingSmashableTop:
	ld a, [wInteractionSide]
	bit INTERACTION_UP_F, a
	jp nz, ObjInteraction_BottomStingSmashableTop.from_above
	bit INTERACTION_DOWN_F, a
	jp nz, ObjInteraction_BumpOffPause
	ld a, [wObjDirection]
	and a
	jr nz, .obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_RIGHT_F, a
	jp nz, GetStungByObject
	jp ObjInteraction_BumpOffPause
.obj_facing_right
	ld a, [wInteractionSide]
	bit INTERACTION_LEFT_F, a
	jp nz, GetStungByObject
	jp ObjInteraction_BumpOffPause
