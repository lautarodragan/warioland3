; hl = Wario's position
GetNextLevelRoomID:
	ld a, [hli] ; hi y
	and a
	jr z, .skip_multiplication
	ld b, a
	inc hl
	ld a, [hl] ; hi x
	ld c, 10
.loop_multiplication
	add c
	dec b
	jr nz, .loop_multiplication
	; a = XPosHi + 10 * YPosHi
	ld [wLevelRoomID], a
	ret
.skip_multiplication
	inc hl
	ld a, [hl] ; hi x
	ld [wLevelRoomID], a
	ret

UpdateLevelEdges:
	ld a, [wLevelEdgeUpdateFlags]
	and a
	ret z
	ld b, a
	and LEVEL_EDGE_UPDATE_RIGHT | LEVEL_EDGE_UPDATE_LEFT
	jr nz, .right_or_left
.check_vertical_direction
	bit LEVEL_EDGE_UPDATE_UP_F, b
	jr nz, .up
	bit LEVEL_EDGE_UPDATE_DOWN_F, b
	jr nz, .down
	ret

.right_or_left
	bit LEVEL_EDGE_UPDATE_RIGHT_F, b
	jr nz, .right
	bit LEVEL_EDGE_UPDATE_LEFT_F, b
	jr nz, .left
	jr .check_vertical_direction

.down
	call .SetLowerEdgeRowPos
	call .QueueEdgeRow
	ld hl, wLevelEdgeUpdateFlags
	res LEVEL_EDGE_UPDATE_DOWN_F, [hl]
	farcall SpawnColEdgeObjects
	ret

.up
	call .SetUpperEdgeRowPos
	call .QueueEdgeRow
	ld hl, wLevelEdgeUpdateFlags
	res LEVEL_EDGE_UPDATE_UP_F, [hl]
	farcall SpawnColEdgeObjects
	ret

.right
	call .SetRightEdgeColumnPos
	call QueueEdgeColumn
	ld hl, wLevelEdgeUpdateFlags
	res LEVEL_EDGE_UPDATE_RIGHT_F, [hl]
	farcall SpawnRowEdgeObjects
	ld a, [wLevelEdgeUpdateFlags]
	bit LEVEL_EDGE_UPDATE_UP_F, a
	jr nz, .up
	bit LEVEL_EDGE_UPDATE_DOWN_F, a
	jr nz, .down
	ret

.left
	call .SetLeftEdgeColumnPos
	call QueueEdgeColumn
	ld hl, wLevelEdgeUpdateFlags
	res LEVEL_EDGE_UPDATE_LEFT_F, [hl]
	farcall SpawnRowEdgeObjects
	ld a, [wLevelEdgeUpdateFlags]
	bit LEVEL_EDGE_UPDATE_UP_F, a
	jr nz, .up
	bit LEVEL_EDGE_UPDATE_DOWN_F, a
	jp nz, .down
	ret

.SetLowerEdgeRowPos:
	ld hl, wCameraSCY + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, $a0
	add hl, de
	ld a, h
	cp $03
	jr c, .lower_y_in_range
	ld hl, $2f8
	ld a, h
.lower_y_in_range
	ld [wBlockYPos + 0], a
	ld a, l
	ld [wBlockYPos + 1], a

	ld hl, wCameraSCX + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, -$10
	add hl, de
	bit 7, h
	jr z, .lower_x_not_negative
	ld hl, $0
.lower_x_not_negative
	ld a, h
	ld [wBlockXPos + 0], a
	ld a, l
	ld [wBlockXPos + 1], a
	ret

.SetUpperEdgeRowPos:
	ld hl, wCameraSCY + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, -$10
	add hl, de
	bit 7, h
	jr z, .upper_y_not_negative
	ld hl, $0
.upper_y_not_negative
	ld a, h
	ld [wBlockYPos + 0], a
	ld a, l
	ld [wBlockYPos + 1], a
	ld hl, wCameraSCX + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, -$10
	add hl, de
	bit 7, h
	jr z, .upper_x_not_negative
	ld hl, $0
.upper_x_not_negative
	ld a, h
	ld [wBlockXPos + 0], a
	ld a, l
	ld [wBlockXPos + 1], a
	ret

.SetRightEdgeColumnPos:
	ld hl, wCameraSCY + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, -$10
	add hl, de
	bit 7, h
	jr z, .right_y_not_negative
	ld hl, $0
	jr .right_set_y
.right_y_not_negative
	ld de, $b8
	push hl
	add hl, de
	ld a, h
	cp $03
	jr c, .right_y_in_range
	pop hl
	ld hl, $240
	jr .right_set_y
.right_y_in_range
	pop hl
.right_set_y
	ld a, h
	ld [wBlockYPos + 0], a
	ld a, l
	ld [wBlockYPos + 1], a
	ld hl, wCameraSCX + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, $b0
	add hl, de
	ld a, h
	cp $0a
	jr c, .right_x_in_range
	ld hl, $9f8
	ld a, h
.right_x_in_range
	ld [wBlockXPos + 0], a
	ld a, l
	ld [wBlockXPos + 1], a
	ret

.SetLeftEdgeColumnPos:
	ld hl, wCameraSCY + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, -$10
	add hl, de
	bit 7, h
	jr z, .left_y_not_negative
	ld hl, $0
	jr .left_set_y
.left_y_not_negative
	ld de, $b8
	push hl
	add hl, de
	ld a, h
	cp $03
	jr c, .left_y_in_range
	pop hl
	ld hl, $240
	jr .left_set_y
.left_y_in_range
	pop hl
.left_set_y
	ld a, h
	ld [wBlockYPos + 0], a
	ld a, l
	ld [wBlockYPos + 1], a
	ld hl, wCameraSCX + 1
	ld a, [hld]
	and $f8
	ld e, a
	ld h, [hl]
	ld l, e
	ld de, -$10
	add hl, de
	bit 7, h
	jr z, .left_x_not_negative
	ld hl, $0
.left_x_not_negative
	ld a, h
	ld [wBlockXPos + 0], a
	ld a, l
	ld [wBlockXPos + 1], a
	ret

.QueueEdgeRow:
	call GetBlockBGPtr
	ld a, [wBGMapAddressQueueSize]
	ld b, a
	ld de, wBGMapAddressQueue
	ld a, e
	add b
	ld e, a ; wBGMapAddressQueue + wBGMapAddressQueueSize

	; fill row
REPT 25
	ld a, h
	ld [de], a
	inc e
	ld a, l
	ld [de], a
	and $e0
	ld c, a
	inc e
	inc l
	ld a, l
	and $1f
	add c
	ld l, a
ENDR

	ld a, [wBGMapAddressQueueSize]
	add $2 * 25
	ld [wBGMapAddressQueueSize], a

	ld hl, wBlockPos
	call GetBlockPtr
	ld a, [wBlockPtrBank]
	sramswitch
	ld a, [wBlockYPos + 1]
	and $08
	jr z, .top_half
	push hl
	call .AddRowBottomTiles
	pop hl
	ld a, [wBlockPtrBank]
	sramswitch
	call .AddRowBottomAttributes
	jr .update_queue_size

.top_half
	push hl
	call .AddRowTopTiles
	pop hl
	ld a, [wBlockPtrBank]
	sramswitch
	call .AddRowTopAttributes

.update_queue_size
	ld a, [wBGMapTileQueueSize]
	add 25
	ld [wBGMapTileQueueSize], a
	ret

.AddRowBottomTiles:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM0Queue)
	ld [wBGMapTileVRAM0QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM0Queue)
	add b
	ld [wBGMapTileVRAM0QueuePtr + 1], a ; wBGMapTileVRAM0Queue + wBGMapTileQueueSize
	ld a, [wBlockXPos + 1]
	and $08
	jp nz, .bottom_tiles_odd_column

REPT 12
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *$4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli] ; bottom-left tile
	ld [de], a
	inc e
	ld a, [hl] ; bottom-right tile
	ld [de], a
	pop hl
ENDR

	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hl] ; bottom-left tile
	ld [de], a
	pop hl
	ret

.bottom_tiles_odd_column
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *$4
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hl] ; bottom-right tile
	ld [de], a
	pop hl

REPT 11
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli] ; bottom-left tile
	ld [de], a
	inc e
	ld a, [hl] ; bottom-right tile
	ld [de], a
	pop hl
ENDR

	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hli] ; bottom-left tile
	ld [de], a
	inc e
	ld a, [hl] ; bottom-right tile
	ld [de], a
	pop hl
	ret

.AddRowBottomAttributes:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM1Queue)
	ld [wBGMapTileVRAM1QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM1Queue)
	add b
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [wBlockXPos + 1]
	and $08
	jp nz, .bottom_attrs_odd_column
	push_wram $03

REPT 12
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
ENDR

	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

.bottom_attrs_odd_column
	push_wram $03
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl

REPT 11
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
ENDR

	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

.AddRowTopTiles:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM0Queue)
	ld [wBGMapTileVRAM0QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM0Queue)
	add b
	ld [wBGMapTileVRAM0QueuePtr + 1], a ; wBGMapTileVRAM0Queue + wBGMapTileQueueSize
	ld a, [wBlockXPos + 1]
	and $08
	jp nz, .top_tiles_odd_column

REPT 12
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli] ; top-left
	ld [de], a
	inc e
	ld a, [hl] ; top-right
	ld [de], a
	pop hl
ENDR

	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hl] ; top-left
	ld [de], a
	pop hl
	ret

.top_tiles_odd_column
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hl] ; top-right
	ld [de], a
	pop hl

REPT 12
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli] ; top-left
	ld [de], a
	inc e
	ld a, [hl] ; top-right
	ld [de], a
	pop hl
ENDR

	ret

.AddRowTopAttributes:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM1Queue)
	ld [wBGMapTileVRAM1QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM1Queue)
	add b
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [wBlockXPos + 1]
	and $08
	jp nz, .top_attrs_odd_column
	push_wram $03

REPT 12
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d ; *$4
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
ENDR
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

.top_attrs_odd_column
	push_wram $03
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl

REPT 12
	ld a, [hli]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
ENDR

	pop_wram
	ret

QueueEdgeColumn:
	call GetBlockBGPtr
	ld a, [wBGMapAddressQueueSize]
	ld b, a
	ld de, wBGMapAddressQueue
	ld a, e
	add b
	ld e, a

REPT 23
	ld a, h
	ld [de], a
	inc e
	ld a, l
	ld [de], a
	inc e
	push de
	ld de, TILEMAP_WIDTH
	add hl, de
	pop de
	ld a, h
	and $fb
	ld h, a
ENDR

	ld a, [wBGMapAddressQueueSize]
	add $2 * 23
	ld [wBGMapAddressQueueSize], a

	ld hl, wBlockPos
	call GetBlockPtr
	ld a, [wBlockPtrBank]
	sramswitch
	ld a, [wBlockXPos + 1]
	and $08
	jr z, .left_half
	push hl
	call AddColumnRightTiles
	pop hl
	ld a, [wBlockPtrBank]
	sramswitch
	call AddColumnRightAttributes
	jr .update_queue_size
.left_half
	push hl
	call AddColumnLeftTiles
	pop hl
	ld a, [wBlockPtrBank]
	sramswitch
	call AddColumnLeftAttributes
.update_queue_size
	ld a, [wBGMapTileQueueSize]
	add 23
	ld [wBGMapTileQueueSize], a
	ret

AddColumnRightTiles:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM0Queue)
	ld [wBGMapTileVRAM0QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM0Queue)
	add b
	ld [wBGMapTileVRAM0QueuePtr + 1], a ; wBGMapTileVRAM0Queue + wBGMapTileQueueSize
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row

REPT 11
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	ret

.odd_row:
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, .same_bank
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank

REPT 10
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	ret

AddColumnRightAttributes:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM1Queue)
	ld [wBGMapTileVRAM1QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM1Queue)
	add b
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row
	push_wram $03

REPT 11
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

.odd_row
	push_wram $03
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, .same_bank
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank

	REPT 10
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

AddColumnLeftTiles:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM0Queue)
	ld [wBGMapTileVRAM0QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM0Queue)
	add b
	ld [wBGMapTileVRAM0QueuePtr + 1], a ; wBGMapTileVRAM0Queue + wBGMapTileQueueSize
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row

REPT 11
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	ret

.odd_row
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, .same_bank
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank

REPT 10
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM0QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockTiles
	add hl, de
	ld a, [wBGMapTileVRAM0QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM0QueuePtr + 1]
	ld e, a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	ret

AddColumnLeftAttributes:
	ld a, [wBGMapTileQueueSize]
	ld b, a
	ld a, HIGH(wBGMapTileVRAM1Queue)
	ld [wBGMapTileVRAM1QueuePtr + 0], a
	ld a, LOW(wBGMapTileVRAM1Queue)
	add b
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [wBlockYPos + 1]
	and $08
	jp nz, .odd_row
	push_wram $03

REPT 11
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret

.odd_row
	push_wram $03
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	inc l
	inc l
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	inc a
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, .same_bank
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
.same_bank

REPT 10
	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	add $2
	ld [wBGMapTileVRAM1QueuePtr + 1], a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	inc h
	ld a, h
	cp HIGH(STARTOF(SRAM) + SIZEOF(SRAM))
	jr nz, :+
	ld h, HIGH(sLevelBlockObjectMap)
	ld a, [wSRAMBank]
	inc a
	sramswitch
:
ENDR

	ld a, [hl]
	ld d, $00
	ld e, a
	sla e
	sla e
	rl d
	push hl
	ld hl, wRoomBlockAttributes
	add hl, de
	ld a, [wBGMapTileVRAM1QueuePtr + 0]
	ld d, a
	ld a, [wBGMapTileVRAM1QueuePtr + 1]
	ld e, a
	ld a, [hli]
	ld [de], a
	inc l
	inc e
	ld a, [hl]
	ld [de], a
	pop hl
	pop_wram
	ret
