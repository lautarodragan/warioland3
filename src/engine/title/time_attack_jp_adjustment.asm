AdjustJapaneseTimeAttackDescriptionWindow:
	ld a, [wLanguage]
	and a
	ret nz ; return if English

.wait_line_2f
	ldh a, [rLY]
	cp $2f
	jr c, .wait_line_2f
	call WaitNextHBlank
	ldh a, [rSCY]
	add $07
	ldh [rSCY], a
.wait_line_38
	ldh a, [rLY]
	cp $38
	jr c, .wait_line_38
	call WaitNextHBlank
	ldh a, [rSCY]
	add $07
	ldh [rSCY], a
.wait_line_41
	ldh a, [rLY]
	cp $41
	jr c, .wait_line_41
	call WaitNextHBlank
	ldh a, [rSCY]
	add $07
	ldh [rSCY], a
.wait_line_5a
	ldh a, [rLY]
	cp $5a
	jr c, .wait_line_5a
	call WaitNextHBlank
	ldh a, [rSCY]
	add $07
	ldh [rSCY], a
.wait_line_63
	ldh a, [rLY]
	cp $63
	jr c, .wait_line_63
	call WaitNextHBlank
	ldh a, [rSCY]
	add $07
	ldh [rSCY], a
.wait_line_6c
	ldh a, [rLY]
	cp $6c
	jr c, .wait_line_6c
	call WaitNextHBlank
	ldh a, [rSCY]
	add $07
	ldh [rSCY], a
	ret
