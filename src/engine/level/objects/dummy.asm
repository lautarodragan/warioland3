DummyObjectFunc:
	xor a
	ld [wCurObjFlags], a
	ret

; Takes the place of the room's objects that would draw from the enemy
; graphics slot the debug menu's owl borrowed (RefusedObjectData, see
; RefuseBorrowedSlotObjects): gone before it's drawn, and left in the object
; map to be spawned again, like an object that went offscreen.
RefusedObjectFunc:
	xor a
	ld [wCurObjFlags], a
	ld hl, wCurObjMapPtrHi
	farcall DespawnObject
	ret
