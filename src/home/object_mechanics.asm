; given the obj struct in hl
; update its sprite with its current position
UpdateObjSprite::
	ld a, [wROMBank]
	push af
	ld a, [hl] ; unk7
	swap a
	and %111
	or BANK("Objects OAM 1")
	bankswitch
	ld l, e
	ld a, [hli] ; screen y pos
	ld [wCurSpriteYCoord], a
	ld a, [hli] ; screen x pos
	ld [wCurSpriteXCoord], a
	ld a, [hli] ; frame
	ld [wCurSpriteFrame], a
	ld a, [hli] ; OAM ptr
	ld h, [hl]
	ld l, a
	ld a, [wCurSpriteFrame]
	ld d, $00
	add a ; *2
	ld e, a
	add hl, de
	ld a, [hli]
	ld e, a
	ld d, [hl]

	ld hl, wCurSpriteXCoord
	ld a, [hld]
	ld c, a
	ld a, [hld] ; wCurSpriteYCoord
	ld b, a
	ld l, [hl] ; wVirtualOAMByteSize
	ld h, HIGH(wVirtualOAM)
.loop_sprites
	ld a, l
	cp LOW(wVirtualOAMEnd)
	jr nc, .done
	ld a, [de]
	cp $80
	jr z, .done
	ld a, [de]
	add b
	ld [hli], a ; SPRITEOAMSTRUCT_YCOORD
	inc de
	ld a, [de]
	add c
	ld [hli], a ; SPRITEOAMSTRUCT_XCOORD
	inc de
	ld a, [de]
	ld [hli], a ; SPRITEOAMSTRUCT_TILE_ID
	inc de
	ld a, [de]
	ld [hli], a ; SPRITEOAMSTRUCT_ATTRIBUTES
	ld a, l
	ld [wVirtualOAMByteSize], a
	inc de
	jr .loop_sprites
.done
	pop af
	bankswitch
	ret

MoveObjectLeftByVar2::
	ld a, [wCurObjVar2]
	ld b, a
	ld hl, wCurObjXPos
	ld a, [hl]
	sub b
	ld [hli], a
	ret nc
	dec [hl]
	ret

MoveObjectRightByVar2::
	ld a, [wCurObjVar2]
	ld b, a
	ld hl, wCurObjXPos
	ld a, [hl]
	add b
	ld [hli], a
	ret nc
	inc [hl]
	ret

MoveObjectUpByVar2::
	ld a, [wCurObjVar2]
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hl]
	sub b
	ld [hli], a
	ret nc
	dec [hl]
	ret

MoveObjectDownByVar2::
	ld a, [wCurObjVar2]
	ld b, a
	ld hl, wCurObjYPos
	ld a, [hl]
	add b
	ld [hli], a
	ret nc
	inc [hl]
	ret

MoveObjectLeft_Fast::
	ld hl, wCurObjXPos
	ld a, [hl]
	sub 2
	ld [hli], a
	ret nc
	dec [hl]
	ret

MoveObjectRight_Fast::
	ld hl, wCurObjXPos
	ld a, [hl]
	add 2
	ld [hli], a
	ret nc
	inc [hl]
	ret

MoveObjectDown_Fast::
	ld hl, wCurObjYPos
	ld a, [hl]
	add 2
	ld [hli], a
	ret nc
	inc [hl]
	ret

MoveObjectUp_Fast::
	ld hl, wCurObjYPos
	ld a, [hl]
	sub 2
	ld [hli], a
	ret nc
	dec [hl]
	ret

; moves current object right
; by 0.5 pixel per frame
MoveObjectRight_Slow::
	ld a, [wGlobalCounter]
	rra
	ret c
;	fallthrough

; moves current object right
; at 1 pixel per frame
MoveObjectRight::
	ld hl, wCurObjXPos
	inc [hl]
	ret nz
	inc l
	inc [hl]
	ret

; moves current object left
; by 0.5 pixel per frame
MoveObjectLeft_Slow::
	ld a, [wGlobalCounter]
	rra
	ret nc
;	fallthrough

; moves current object left
; at 1 pixel per frame
MoveObjectLeft::
	ld hl, wCurObjXPos
	ld a, [hl]
	sub 1
	ld [hli], a
	ret nc
	dec [hl]
	ret

; moves current object down
; at 0.5 pixel per frame
MoveObjectDown_Slow::
	ld a, [wGlobalCounter]
	rra
	ret c
;	fallthrough

; moves current object down
; at 1 pixel per frame
MoveObjectDown::
	ld hl, wCurObjYPos
	inc [hl]
	ret nz
	inc l
	inc [hl]
	ret

MoveObjectUp_Slow::
	ld a, [wGlobalCounter]
	rra
	ret nc
;	fallthrough

; moves current object up
; at 1 pixel per frame
MoveObjectUp::
	ld hl, wCurObjYPos
	ld a, [hl]
	sub 1
	ld [hli], a
	ret nc
	dec [hl]
	ret

; input:
; - de = frameset pointer
SetObjectFramesetPtr::
	ld hl, wCurObjFramesetPtr
	ld a, e
	ld [hli], a ; OBJ_FRAMESET_PTR
	ld a, d
	ld [hli], a
	xor a
	ld [hli], a ; OBJ_FRAME_DURATION
	ld [hli], a ; OBJ_FRAMESET_OFFSET
	ret

; some bosses hold the number of hits required to be defeated
; in the substate variable of their object struct
; this routine decrements this counter to a minimum of 0
DecrementRemainingBossHits::
	ld l, OBJ_SUBSTATE
	ld a, [hl]
	and $0f
	dec a
	ret z
	dec [hl]
	ret

UpdateObjectFrame::
	ld hl, wCurObjFrameDuration
	ld a, [hld]
	sub 1
	ret nc
	ld a, [wROMBank]
	push af
	ld a, BANK("Object Framesets")
	bankswitch
	dec l
	ld a, [hli] ; OBJ_FRAMESET_PTR
	ld e, a
	ld a, [hli]
	ld d, a
	inc l
	ld a, [hl] ; OBJ_FRAMESET_OFFSET
	add e
	ld c, a
	ld a, d
	adc $00
	ld b, a
	ld a, [bc]
	cp $ff
	jr nz, .asm_312a
	ld a, [de] ; first frame
.asm_312a
	ld [wCurObjFrame], a
	jr HomeJumpRet

UpdateObjectAnimation::
	ld hl, wCurObjFrameDuration
	ld a, [hl]
	sub 1
	ld [hld], a
	ret nc
	ld a, [wROMBank]
	push af
	ld a, BANK("Object Framesets")
	bankswitch
	dec l
	ld a, [hli] ; OBJ_FRAMESET_PTR
	ld e, a
	ld a, [hli]
	ld d, a
	inc l
	ld a, [hl] ; OBJ_FRAMESET_OFFSET
	add e
	ld c, a
	ld a, d
	adc $00
	ld b, a
	ld a, [bc]
	cp $ff
	jr z, .reset
	ld [wCurObjFrame], a
	ld a, [hl]
	add $2
	ld [hld], a
	inc bc
	ld a, [bc]
	ld [hl], a ; OBJ_FRAME_DURATION
	jr HomeJumpRet
.reset
	ld a, $2
	ld [hld], a ; OBJ_FRAMESET_OFFSET
	ld a, [de] ; first frame
	ld [wCurObjFrame], a
	inc de
	ld a, [de] ; first duration
	ld [hl], a ; OBJ_FRAME_DURATION
;	fallthrough

HomeJumpRet::
	pop af
	bankswitch
	ret

VanishAndDespawnObject::
	homejp _VanishAndDespawnObject

VanishObject2::
	homejp _VanishObject2

ObjState_Bounce1LeftStart::
	homejp _ObjState_Bounce1LeftStart

ObjState_Bounce1Left::
	homejp _ObjState_Bounce1Left

ObjState_Bounce1RightStart::
	homejp _ObjState_Bounce1RightStart

ObjState_Bounce1Right::
	homejp _ObjState_Bounce1Right

ObjState_Bounce2LeftStart::
	homejp _ObjState_Bounce2LeftStart

ObjState_Bounce2Left::
	homejp _ObjState_Bounce2Left

ObjState_Bounce2RightStart::
	homejp _ObjState_Bounce2RightStart

ObjState_Bounce2Right::
	homejp _ObjState_Bounce2Right

ObjState_Bounce3LeftStart::
	homejp _ObjState_Bounce3LeftStart

ObjState_Bounce3Left::
	homejp _ObjState_Bounce3Left

ObjState_Bounce3RightStart::
	homejp _ObjState_Bounce3RightStart

ObjState_Bounce3Right::
	homejp _ObjState_Bounce3Right

ObjState_FallLeftStart::
	homejp _ObjState_FallLeftStart

ObjState_FallRightStart::
	homejp _ObjState_FallRightStart

ObjState_HopStart::
	homejp _ObjState_HopStart

ObjState_Hop::
	homejp _ObjState_Hop

ObjState_StartRandomWobble::
	homejp _ObjState_StartRandomWobble

ObjState_Fall::
	homejp _ObjState_Fall

ObjState_StandingFall::
	homejp _ObjState_StandingFall

ObjState_BumpSlideLeft::
	homejp _ObjState_BumpSlideLeft

ObjState_BumpSlideRight::
	homejp _ObjState_BumpSlideRight

ObjState_FallLeft::
	homejp _ObjState_FallLeft

ObjState_FallRight::
	homejp _ObjState_FallRight

ObjCheckFloorOrDrop::
	homejp _ObjCheckFloorOrDrop

ApplyObjHopYVel::
	homejp _ApplyObjHopYVel

ObjCheckFloorOrStandingFall::
	homejp _ObjCheckFloorOrStandingFall

ObjState_AttackedRight::
	homejp _ObjState_AttackedRight

ObjState_AttackedLeft::
	homejp _ObjState_AttackedLeft

ObjState_PickedUpLeft::
	homejp _ObjState_PickedUpLeft

ObjState_PickedUpRight::
	homejp _ObjState_PickedUpRight

ObjState_GrabbedRight::
	homejp _ObjState_GrabbedRight

ObjState_GrabbedLeft::
	homejp _ObjState_GrabbedLeft

ObjState_Drop::
	homejp _ObjState_Drop

ObjState_GrabbedChargeLeft::
	homejp _ObjState_GrabbedChargeLeft

ObjState_GrabbedChargeRight::
	homejp _ObjState_GrabbedChargeRight

ObjState_ThrowLeft::
	homejp _ObjState_ThrowLeft

ObjState_ThrowRight::
	homejp _ObjState_ThrowRight

ObjState_FullThrowLeft::
	homejp _ObjState_FullThrowLeft

ObjState_FullThrowRight::
	homejp _ObjState_FullThrowRight

ObjState_BumpLeft::
	homejp _ObjState_BumpLeft

ObjState_BumpRight::
	homejp _ObjState_BumpRight

ObjState_HitByObjLeft::
	homejp _ObjState_HitByObjLeft

ObjState_HitByObjRight::
	homejp _ObjState_HitByObjRight

; bc = object creation data
CreateObjectAtRelativePos::
	homecall _CreateObjectAtRelativePos
	ret

; bc = object creation data
CreateObjectFromCurObjPos::
	homecall _CreateObjectFromCurObjPos
	ret

CountCurObjTransientChildren::
	homecall _CountCurObjTransientChildren
	ret

; returns in e how many objects there are
; that are currently active and transient
CountActiveTransientObjects::
	homecall _CountActiveTransientObjects
	ret

; de = start of data
ApplyObjSetMovement::
	homecall _ApplyObjSetMovement
	ret

ApplyObjYMovement_Loop::
	homecall _ApplyObjYMovement_Loop
	ret

ApplyObjXMovement_Loop::
	homecall _ApplyObjXMovement_Loop
	ret

ApplyObjYMovement::
	homecall _ApplyObjYMovement
	ret

ApplyObjXMovement::
	homecall _ApplyObjXMovement
	ret

VanishObject::
	homecall _VanishObject
	ret

ApplyObjYMovement_Platform::
	homecall _ApplyObjYMovement_Platform
	ret

ProcessBlock_Side::
	homecall _ProcessBlock_Side
	ld a, b
	ret

ProcessBlock_Landing::
	homecall _ProcessBlock_Landing
	ld a, b
	ret

ProcessBlock_Down::
	homecall _ProcessBlock_Down
	ld a, b
	ret

ProcessBlockOnLeft::
	homecall _ProcessBlockOnLeft
	ld a, b
	ret

ProcessBlockOnRight::
	homecall _ProcessBlockOnRight
	ld a, b
	ret

ProcessBlock_UpSide::
	homecall _ProcessBlock_UpSide
	ld a, b
	ret

ProcessBlock_DownSide::
	homecall _ProcessBlock_DownSide
	ld a, b
	ret

; c = OB pal index
; b = num of pals
; hl = pals
SetOBPals::
	ld a, c
	add a
	add a
	add a ; *8
	or OBPI_AUTOINC
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
.loop_copy_pals
	wait_not_hblank
	wait_hblank
REPT 1 palettes
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_copy_pals
	ret

; c = BG pal index
; b = num of pals
; hl = pals
SetBGPals::
	ld a, c
	add a
	add a
	add a ; *8
	or BGPI_AUTOINC
	ldh [rBGPI], a
	ld c, LOW(rBGPD)
.loop_copy_pals
	wait_not_hblank
	wait_hblank
REPT PAL_SIZE
	ld a, [hli]
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_copy_pals
	ret

; blacks out b OB palettes starting
; from OB palette index c
BlackOutOBPals::
	ld a, c
	add a
	add a
	add a ; *8
	or OBPI_AUTOINC
	ldh [rOBPI], a
	ld c, LOW(rOBPD)
.loop_clear_pals
	wait_not_hblank
	wait_hblank
	xor a ; black
REPT PAL_SIZE
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_clear_pals
	ret

; blacks out b BG palettes starting
; from BG palette index c
BlackOutBGPals::
	ld a, c
	add a
	add a
	add a ; *8
	or BGPI_AUTOINC
	ldh [rBGPI], a
	ld c, LOW(rBGPD)
.loop_clear_pals
	wait_not_hblank
	wait_hblank
	xor a ; black
REPT PAL_SIZE
	ld [$ff00+c], a
ENDR
	dec b
	jr nz, .loop_clear_pals
	ret

; if Wario is underneath a one-way platform,
; then don't process any actions for it
SetOneWayPlatformAction::
	ld a, [wCurObjFlags]
	and OBJFLAG_STEPPED
	ret nz
	ld a, [wCurObjCollBoxTop]
	ld b, a
	ld a, [wCurObjScreenYPos]
	add $2a + 3
	add b
	ld b, a ; wCurObjCollBoxTop + wCurObjScreenYPos + $2a + 3
	ld a, [wWarioScreenYPos]
	add $2a
	cp b
	ret c ; return if Wario is over collision box
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ret
