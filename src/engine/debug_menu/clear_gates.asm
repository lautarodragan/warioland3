; Debug menu helper for GOLF, kept in ClearGateFunc's section.

; wIsMinigameCleared only matters to the clear gates, and only when one is
; set up: ClearGateFunc raises a gate 32 pixels if it's set. So after GOLF
; flips it, the gates already set up are moved to match, the same 32 pixels
; up (cleared) or down (not cleared). Gates still waiting for their first
; update, and those spawned later, read wIsMinigameCleared themselves.
; Nothing else needs refreshing, so the room isn't reloaded.
; Needs WRAM bank "Level Objects WRAM".
_DebugMoveClearGates::
	ld a, [wIsMinigameCleared]
	and a
	ld bc, -32
	jr nz, .got_offset
	ld bc, 32
.got_offset
FOR n, 1, NUM_OBJECTS + 1
	ld hl, wObj{u:n}
	call .MoveIfClearGate
ENDR
	ret

; hl = object, bc = Y offset
	ASSERT HIGH(wObj1) == HIGH(wObj{u:NUM_OBJECTS} + OBJ_STRUCT_LENGTH - 1)
.MoveIfClearGate:
	ld a, [hl]
	rra
	ret nc ; OBJFLAG_ACTIVE not set
	ld a, l
	add OBJ_UPDATE_FUNCTION
	ld l, a
	ld a, [hli]
	cp LOW(ClearGateFunc.Update)
	ret nz
	ld a, [hl]
	cp HIGH(ClearGateFunc.Update)
	ret nz ; not a gate, or one not set up yet
	ld a, l
	sub OBJ_UPDATE_FUNCTION + 1 - OBJ_Y_POS
	ld l, a
	ld a, [hl]
	add c
	ld [hli], a
	ld a, [hl]
	adc b
	ld [hl], a
	ld a, l
	add OBJ_SCREEN_Y_POS - (OBJ_Y_POS + 1)
	ld l, a
	ld a, [hl]
	add c
	ld [hl], a
	ret
