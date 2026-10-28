NobiiruFunc:
	ld hl, wCurObjFlags
	res OBJFLAG_INVISIBLE_F, [hl]
	set OBJFLAG_NO_COLLISION_F, [hl]
	ld l, OBJ_UPDATE_FUNCTION + 1
	ld a, HIGH(.Update)
	ld [hld], a
	ld a, LOW(.Update)
	ld [hld], a
	ld l, OBJ_SUBSTATE
	res OBJSUBFLAG_UNINITIALISED_F, [hl]
	ld a, [wCurObjId]
	cp NOBIIRU_LEFT
	jr nz, .left_variant
; right variant
	res OBJSUBFLAG_HDIR_F, [hl]
	jr .reset
.left_variant
	set OBJSUBFLAG_HDIR_F, [hl]

.reset
	ld l, OBJ_COLLBOX_BOTTOM
	ld a, $fc
	ld [hli], a
	ld a, $fd
	ld [hli], a
	ld a, $02
	ld [hl], a
	ld de, NobiiruFrameset_698ff
	call SetObjectFramesetPtr
	ld a, 60
	ld [hli], a
	xor a
	ld [hl], a
	ret

.Update:
	ld a, [wCurObjVar1]
	jumptable

	dw .Wait
	dw .Extend1
	dw .Extend2
	dw .Extend3
	dw .Extend4
	dw .Extend5
	dw .Bite1
	dw .Bite2
	dw .Retract1
	dw .Retract2
	dw .Retract3
	dw .Retract4
	dw .Retract5
	dw .RetractEnd

.Wait:
	ld a, no_actions_for 1
	ld [wCurObjAction], a
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	play_sfx SFX_NOBIIRU_EXTEND
	ld a, $0c
	ld [wCurObjVar2], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .wait_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698d8
	ld a, $ff
	ld c, $02
	jr .wait_done

.wait_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698b1
	ld a, $fd
	ld c, $00
.wait_done
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_FULL_STING
	ld [hld], a
	ld b, $02

; a = left col
; c = right col
; b = duration
; de = frameset
.SetCollisionAndFrameset:
	ld l, OBJ_COLLBOX_LEFT
	ld [hli], a
	ld [hl], c
.SetFrameset:
	call SetObjectFramesetPtr
	ld a, b
	ld [hli], a
	inc [hl]
	ret

.Extend1:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $04
	ld [wCurObjVar2], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .extend1_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698db
	ld a, $fc
	ld c, $07
	jr .extend1_done

.extend1_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698b4
	ld a, $f8
	ld c, $03
.extend1_done
	ld b, $02
	jr .SetCollisionAndFrameset

.Extend2:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .extend2_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698de
	ld a, $f8
	ld c, $0b
	jr .extend2_done

.extend2_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698b7
	ld a, $f4
	ld c, $07
.extend2_done
	ld b, $02
	jr .SetCollisionAndFrameset

.Extend3:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .extend3_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698e1
	ld a, $f4
	ld c, $0f
	jr .extend3_done

.extend3_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698ba
	ld a, $f0
	ld c, $0b
.extend3_done
	ld b, $02
	jr .SetCollisionAndFrameset

.Extend4:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .extend4_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698e4
	ld a, $f0
	ld c, $13
	jr .extend4_done

.extend4_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698bd
	ld a, $ec
	ld c, $0f
.extend4_done
	ld b, $02
	jp .SetCollisionAndFrameset

.Extend5:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .extend5_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698e7
	ld a, $ec
	ld c, $17
	jr .extend5_done

.extend5_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698c0
	ld a, $e8
	ld c, $13
.extend5_done
	ld b, $14
	jp .SetCollisionAndFrameset

.Bite1:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset NobiiruFrameset_698ea, NobiiruFrameset_698c3
	ld l, OBJ_INTERACTION_TYPE
	ld a, [hl]
	and HEAVY_OBJ
	or OBJ_INTERACTION_BUMP_OFF_PAUSE
	ld [hld], a
	ld b, $08
	jp .SetFrameset

.Bite2:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	ld_obj_frameset NobiiruFrameset_698ed, NobiiruFrameset_698c6
	ld b, $14
	jp .SetFrameset

.Retract1:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .retract1_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698f0
	ld a, $f0
	ld c, $13
	jr .retract1_done

.retract1_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698c9
	ld a, $ec
	ld c, $0f
.retract1_done
	ld b, $02
	jp .SetCollisionAndFrameset

.Retract2:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .retract2_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698f3
	ld a, $f4
	ld c, $0f
	jr .retract2_done

.retract2_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698cc
	ld a, $f0
	ld c, $0b
.retract2_done
	ld b, $02
	jp .SetCollisionAndFrameset

.Retract3:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .retract3_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698f6
	ld a, $f8
	ld c, $0b
	jr .retract3_done

.retract3_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698cf
	ld a, $f4
	ld c, $07
.retract3_done
	ld b, $02
	jp .SetCollisionAndFrameset

.Retract4:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .retract4_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698f9
	ld a, $fc
	ld c, $07
	jr .retract4_done

.retract4_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698d2
	ld a, $f8
	ld c, $03
.retract4_done
	ld b, $02
	jp .SetCollisionAndFrameset

.Retract5:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, [wCurObjSubState]
	rlca
	jr c, .retract5_right
	call MoveObjectRightByVar2
	ld de, NobiiruFrameset_698fc
	ld a, $ff
	ld c, $02
	jr .retract5_done

.retract5_right
	call MoveObjectLeftByVar2
	ld de, NobiiruFrameset_698d5
	ld a, $fd
	ld c, $00
.retract5_done
	ld b, $02
	jp .SetCollisionAndFrameset

.RetractEnd:
	ld hl, wCurObjStateDuration
	dec [hl]
	ret nz
	ld a, $0c
	ld [wCurObjVar2], a
	ld a, [wCurObjSubState]
	rlca
	jr c, .retract_end_right
	call MoveObjectRightByVar2
	jp .reset
.retract_end_right
	call MoveObjectLeftByVar2
	jp .reset
