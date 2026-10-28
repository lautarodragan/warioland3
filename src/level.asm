SECTION "Level Engine", ROMX

INCLUDE "engine/level/state_table.asm"
INCLUDE "engine/level/init.asm"
INCLUDE "engine/level/update_level.asm"
INCLUDE "engine/level/start_room.asm"
INCLUDE "engine/level/get_bg_ptr.asm"
INCLUDE "engine/level/scroll.asm"
INCLUDE "engine/level/vblank.asm"
INCLUDE "engine/level/camera.asm"
INCLUDE "engine/level/block_queue.asm"
INCLUDE "engine/level/switch.asm"
INCLUDE "engine/level/tick_time.asm"


SECTION "Levels Common Gfx", ROMX

LevelsCommonGfx: INCBIN "gfx/levels/common.2bpp"
LevelsCommonGfxEnd:


SECTION "Bank 3", ROMX

INCLUDE "engine/level/particles.asm"
INCLUDE "engine/level/spawn_edge.asm"
INCLUDE "data/levels/common/palettes.asm"
INCLUDE "data/levels/common/oam.asm"
INCLUDE "data/levels/common/framesets.asm"


SECTION "Block Functions", ROMX

INCLUDE "engine/level/block_functions.asm"


SECTION "Collision", ROMX

INCLUDE "engine/level/collisions.asm"


SECTION "Wario States 2", ROMX

INCLUDE "engine/level/wario_states_2.asm"


SECTION "Wario States 1", ROMX

INCLUDE "engine/level/wario_states_1.asm"


SECTION "Object Interactions", ROMX

INCLUDE "engine/level/object_interactions.asm"


SECTION "Level Engine Extra", ROMX

INCLUDE "engine/level/row_block_queue.asm"


SECTION "Wario States 3", ROMX

INCLUDE "engine/level/wario_states_3.asm"


SECTION "Object Functions 1", ROMX

; sequence of y-offsets used in ApplyOmodonHoverBob
OmodonHoverBobYOffsets:
	db  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, $80

INCLUDE "engine/level/objects/spearhead.asm"
INCLUDE "engine/level/objects/futamogu.asm"
INCLUDE "engine/level/objects/webber.asm"
INCLUDE "engine/level/objects/torch.asm"
INCLUDE "engine/level/objects/unused_flower.asm"
INCLUDE "engine/level/objects/count_richtertoffen.asm"
INCLUDE "engine/level/objects/para_goom.asm"
INCLUDE "engine/level/objects/doughnuteer.asm"
INCLUDE "engine/level/objects/omodonmeka.asm"
INCLUDE "engine/level/objects/kushimushi.asm"
INCLUDE "engine/level/objects/big_leaf.asm"
INCLUDE "engine/level/objects/silky.asm"
INCLUDE "engine/level/objects/bird.asm"
INCLUDE "engine/level/objects/barrel.asm"
INCLUDE "engine/level/objects/small_leaf.asm"
INCLUDE "engine/level/objects/clear_gate.asm"
INCLUDE "engine/level/objects/nobiiru.asm"


SECTION "Object Functions 2", ROMX

PneumoData_44000:
	db  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, $80

BubbleDriftLeftX:
	db  0,  0,  0,  0,  0,  0,  0, -1,  0,  0, -1,  0, -1,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0, -1,  0, -1,  0, -1,  0,  0, -1,  0,  0, $80

BubbleDriftRightX:
	db 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, $80

INCLUDE "engine/level/objects/prince_froggy.asm"
INCLUDE "engine/level/objects/hammer_bot.asm"
INCLUDE "engine/level/objects/teruteru.asm"
INCLUDE "engine/level/objects/mad_scienstein.asm"
INCLUDE "engine/level/objects/seeing_eye_door.asm"
INCLUDE "engine/level/objects/pneumo.asm"
INCLUDE "engine/level/objects/electric_lamp.asm"
INCLUDE "engine/level/objects/zombie.asm"
INCLUDE "engine/level/objects/spear_bot.asm"
INCLUDE "engine/level/objects/beam_bot.asm"
INCLUDE "engine/level/objects/fire_bot.asm"
INCLUDE "engine/level/objects/sun_moon.asm"
INCLUDE "engine/level/objects/kobatto.asm"
INCLUDE "engine/level/objects/hand.asm"
INCLUDE "engine/level/objects/appleby.asm"
INCLUDE "engine/level/objects/bubble.asm"


SECTION "Object Functions 3", ROMX

INCLUDE "engine/level/objects/brrr_bear.asm"
INCLUDE "engine/level/objects/cart.asm"
INCLUDE "engine/level/objects/mizuuo.asm"
INCLUDE "engine/level/objects/robo_mouse.asm"
INCLUDE "engine/level/objects/togeba.asm"
INCLUDE "engine/level/objects/haridama.asm"
INCLUDE "engine/level/objects/owl.asm"
INCLUDE "engine/level/objects/zip_line.asm"
INCLUDE "engine/level/objects/falling_snow.asm"
INCLUDE "engine/level/objects/flame_block.asm"
INCLUDE "engine/level/objects/stove.asm"
INCLUDE "engine/level/objects/snake.asm"
INCLUDE "engine/level/objects/pillar_platform.asm"
INCLUDE "engine/level/objects/water_drop.asm"
INCLUDE "engine/level/objects/tadpole.asm"
INCLUDE "engine/level/objects/hebarii.asm"
INCLUDE "engine/level/objects/water_spark.asm"
INCLUDE "engine/level/objects/octohon.asm"
INCLUDE "engine/level/objects/spark.asm"
INCLUDE "engine/level/objects/rock.asm"
INCLUDE "engine/level/objects/fire.asm"


SECTION "Object Functions 4", ROMX

HiddenFigureSwipeSCYShake:
	db  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0, $80

HiddenFigureLeftSwipeSCX:
	db  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -2, -2, -2,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, $80

HiddenFigureRightSwipeSCX:
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, $80

HiddenFigureGrab1SCYShake:
	db  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0, $80

HiddenFigureLeftHandSwipeX:
	db  0,  0,  0,  0,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  1,  1,  1,  2,  2,  2,  3,  3,  4,  4,  4,  4,  4,  4,  4,  4,  3,  3,  2,  2,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -2, -2, -2, -2, -3, -3, -3, -4, -4, -5, -5, -5, -5,  0, $80

HiddenFigureHandSwipeY:
	db -1, -1, -2, -2, -3, -3, -2, -2, -1, -1,  0, -1,  0, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  1,  2,  2,  2,  2,  2,  3,  3,  3,  3,  3,  3,  3,  3,  2,  2,  2,  2,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -3, -4, -3, -2, -2, -2, -2, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, $80

HiddenFigureRightHandSwipeX:
	db  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0, -1,  0, -1,  0, -1, -1, -1, -1, -2, -2, -2, -3, -3, -4, -4, -4, -4, -4, -4, -4, -4, -3, -3, -2, -2, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  2,  2,  2,  2,  3,  3,  3,  4,  4,  5,  5,  5,  5,  0, $80

HiddenFigureLeftHandGrabX:
	db  0,  0,  0,  0,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -2, -2, -3, -3, -2, -2, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  6,  6,  6,  6,  6,  5,  4,  4,  4,  3,  3,  3,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2, -2, -3, -3, -3, -4, -4, -4, -4, -4,  0, $80

HiddenFigureHandGrab1Y:
	db -1, -1, -2, -2, -3, -3, -2, -2, -1, -1,  0, -1,  0, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  1,  2,  2,  2,  2,  2,  3,  3,  3,  3,  3,  3,  3,  3,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -2, -2, -2, -2, -3, -4, -4, -3, -2, -2, -2, -2, -1,  0,  0,  0,  0,  0,  0, $80

HiddenFigureRightHandGrabX:
	db  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  2,  2,  3,  3,  2,  2,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -6, -6, -6, -6, -6, -5, -4, -4, -4, -3, -3, -3, -2, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  3,  3,  3,  4,  4,  4,  4,  4,  0, $80

HiddenFigureHandFlinchY:
	db  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0, $80

HiddenFigureHandSlamY:
	db  1,  1,  2,  3,  4,  5,  6,  7,  8, 10,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -2, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3,  0, $80

HiddenFigureGrab2SCYShake:
	db  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1,  0, $80

HiddenFigureHandGrab2Y:
	db -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0, -1,  0, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  0,  1,  0,  1,  0,  1,  0,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -2, -2, -2, -2, -3, -3, -2, -2, -2, -2, -2, -1,  0,  0,  0,  0,  0,  0, $80

HiddenFigureGrab3SCYShake:
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,  2,  1,  1,  0,  0,  0,  0,  0, $80

	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, $80
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0

HiddenFigureLeftHandGrab3X:
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  5,  5,  4,  3,  2,  2,  2,  2,  2,  2,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -4, -5, -5, -5, -6, -6, -4, -4,  0, $80

HiddenFigureRightHandGrab3X:
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -5, -5, -4, -3, -2, -2, -2, -2, -2, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  4,  5,  5,  5,  6,  6,  4,  4,  0, $80

	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0

HiddenFigureHandGrab3Y:
	db  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -2, -2, -1,  0, $80

INCLUDE "engine/level/objects/stars.asm"
INCLUDE "engine/level/objects/chests.asm"
INCLUDE "engine/level/objects/key.asm"
INCLUDE "engine/level/objects/musical_coin.asm"
INCLUDE "engine/level/objects/muddee_stinger.asm"
INCLUDE "engine/level/objects/wall_crack.asm"
INCLUDE "engine/level/objects/hidden_figure.asm"


SECTION "Object Functions 5", ROMX

INCLUDE "engine/level/objects/anonster.asm"
INCLUDE "engine/level/objects/doll_boy.asm"
INCLUDE "engine/level/objects/yellow_belly.asm"
INCLUDE "engine/level/objects/pesce.asm"


SECTION "Object Functions 6", ROMX

ShootData_54000:
	db -3, -2, -1,  0,  1,  1,  1,  1,  1,  1,  2,  2,  2,  3,  3, $80

ShootData_54010:
	db -4, -3, -3, -2, -2, -1, -1, -1,  0, -1,  0, -1,  0, -1,  0, $80

INCLUDE "engine/level/objects/wormwould.asm"
INCLUDE "engine/level/objects/scowler.asm"
INCLUDE "engine/level/objects/jamano.asm"
INCLUDE "engine/level/objects/muddee.asm"
INCLUDE "engine/level/objects/wolfenboss.asm"
INCLUDE "engine/level/objects/shoot.asm"


SECTION "Update Objects", ROMX

INCLUDE "engine/level/update_objects.asm"


SECTION "Object Functions 7", ROMX

INCLUDE "engine/level/objects/dummy.asm"
INCLUDE "engine/level/objects/coin.asm"


SECTION "Object Loading", ROMX

INCLUDE "engine/level/load_objects.asm"


SECTION "Level Maps", ROMX

INCLUDE "engine/level/load_room_gfx.asm"
INCLUDE "data/levels/level_maps.asm"


SECTION "Rooms 1", ROMX

INCLUDE "data/levels/rooms1.asm"


SECTION "Rooms 2", ROMX

INCLUDE "data/levels/rooms2.asm"


SECTION "Block Function Tables 1", ROMX

INCLUDE "data/levels/function_table_pointers.asm"
INCLUDE "data/levels/function_tables1.asm"


SECTION "Update Animated Tiles", ROMX

INCLUDE "engine/level/update_animated_tiles.asm"


SECTION "Level Data 1", ROMX

OutOfTheWoodsBlockMap:       INCBIN "data/levels/block_map/out_of_the_woods.bin.rle"
ThePeacefulVillage1BlockMap: INCBIN "data/levels/block_map/the_peaceful_village_1.bin.rle"

OutOfTheWoodsObjectMap:       INCBIN "data/levels/object_map/out_of_the_woods.bin.rle"
ThePeacefulVillage1ObjectMap: INCBIN "data/levels/object_map/the_peaceful_village_1.bin.rle"

BlocksetTiles_OutOfTheWoods1: INCBIN "data/levels/blocksets/blockset_tiles_00.bin"
BlocksetAttributes_OutOfTheWoods1: INCBIN "data/levels/blocksets/blockset_attributes_00.bin.rle"
BlocksetTiles_OutOfTheWoods5: INCBIN "data/levels/blocksets/blockset_tiles_01.bin"
BlocksetAttributes_OutOfTheWoods5: INCBIN "data/levels/blocksets/blockset_attributes_01.bin.rle"
BlocksetTiles_OutOfTheWoods2: INCBIN "data/levels/blocksets/blockset_tiles_02.bin"
BlocksetAttributes_OutOfTheWoods2: INCBIN "data/levels/blocksets/blockset_attributes_02.bin.rle"
BlocksetTiles_OutOfTheWoods3: INCBIN "data/levels/blocksets/blockset_tiles_03.bin"
BlocksetAttributes_OutOfTheWoods3: INCBIN "data/levels/blocksets/blockset_attributes_03.bin.rle"
BlocksetTiles_OutOfTheWoods4: INCBIN "data/levels/blocksets/blockset_tiles_04.bin"
BlocksetAttributes_OutOfTheWoods4: INCBIN "data/levels/blocksets/blockset_attributes_04.bin.rle"
BlocksetTiles_Shared1: INCBIN "data/levels/blocksets/blockset_tiles_05.bin"
BlocksetAttributes_Shared1: INCBIN "data/levels/blocksets/blockset_attributes_05.bin.rle"


SECTION "Level Data 2", ROMX

TheVastPlain1BlockMap:   INCBIN "data/levels/block_map/the_vast_plain_1.bin.rle"
TheSteepCanyon1BlockMap: INCBIN "data/levels/block_map/the_steep_canyon_1.bin.rle"

TheVastPlain1ObjectMap:   INCBIN "data/levels/object_map/the_vast_plain_1.bin.rle"
TheSteepCanyon1ObjectMap: INCBIN "data/levels/object_map/the_steep_canyon_1.bin.rle"

BlocksetTiles_ThePeacefulVillage1: INCBIN "data/levels/blocksets/blockset_tiles_06.bin"
BlocksetAttributes_ThePeacefulVillage1: INCBIN "data/levels/blocksets/blockset_attributes_06.bin.rle"
BlocksetTiles_ThePeacefulVillage3: INCBIN "data/levels/blocksets/blockset_tiles_07.bin"
BlocksetAttributes_ThePeacefulVillage3: INCBIN "data/levels/blocksets/blockset_attributes_07.bin.rle"
BlocksetTiles_TheVastPlain3: INCBIN "data/levels/blocksets/blockset_tiles_08.bin"
BlocksetAttributes_TheVastPlain3: INCBIN "data/levels/blocksets/blockset_attributes_08.bin.rle"
BlocksetTiles_ThePeacefulVillage2: INCBIN "data/levels/blocksets/blockset_tiles_09.bin"
BlocksetAttributes_ThePeacefulVillage2: INCBIN "data/levels/blocksets/blockset_attributes_09.bin.rle"
BlocksetTiles_ThePeacefulVillage4: INCBIN "data/levels/blocksets/blockset_tiles_10.bin"
BlocksetAttributes_ThePeacefulVillage4: INCBIN "data/levels/blocksets/blockset_attributes_10.bin.rle"
BlocksetTiles_BankOfTheWildRiver2: INCBIN "data/levels/blocksets/blockset_tiles_11.bin"
BlocksetAttributes_BankOfTheWildRiver2: INCBIN "data/levels/blocksets/blockset_attributes_11.bin.rle"


SECTION "Level Data 3", ROMX

TheTidalCoast1BlockMap: INCBIN "data/levels/block_map/the_tidal_coast_1.bin.rle"
SeaTurtleRocksBlockMap: INCBIN "data/levels/block_map/sea_turtle_rocks.bin.rle"

TheTidalCoast1ObjectMap: INCBIN "data/levels/object_map/the_tidal_coast_1.bin.rle"
SeaTurtleRocksObjectMap: INCBIN "data/levels/object_map/sea_turtle_rocks.bin.rle"

BlocksetTiles_Shared2: INCBIN "data/levels/blocksets/blockset_tiles_12.bin"
BlocksetAttributes_Shared2: INCBIN "data/levels/blocksets/blockset_attributes_12.bin.rle"
BlocksetTiles_TheTidalCoast1: INCBIN "data/levels/blocksets/blockset_tiles_13.bin"
BlocksetAttributes_TheTidalCoast1: INCBIN "data/levels/blocksets/blockset_attributes_13.bin.rle"
BlocksetTiles_TheTidalCoast3: INCBIN "data/levels/blocksets/blockset_tiles_14.bin"
BlocksetAttributes_TheTidalCoast3: INCBIN "data/levels/blocksets/blockset_attributes_14.bin.rle"
BlocksetTiles_SeaTurtleRocks2: INCBIN "data/levels/blocksets/blockset_tiles_15.bin"
BlocksetAttributes_SeaTurtleRocks2: INCBIN "data/levels/blocksets/blockset_attributes_15.bin.rle"
BlocksetTiles_DesertRuins1: INCBIN "data/levels/blocksets/blockset_tiles_16.bin"
BlocksetAttributes_DesertRuins1: INCBIN "data/levels/blocksets/blockset_attributes_16.bin.rle"
BlocksetTiles_DesertRuins2: INCBIN "data/levels/blocksets/blockset_tiles_17.bin"
BlocksetAttributes_DesertRuins2: INCBIN "data/levels/blocksets/blockset_attributes_17.bin.rle"


SECTION "Level Data 4", ROMX

DesertRuinsBlockMap:      INCBIN "data/levels/block_map/desert_ruins.bin.rle"
TheVolcanosBase1BlockMap: INCBIN "data/levels/block_map/the_volcanos_base_1.bin.rle"

DesertRuinsObjectMap:      INCBIN "data/levels/object_map/desert_ruins.bin.rle"
TheVolcanosBase1ObjectMap: INCBIN "data/levels/object_map/the_volcanos_base_1.bin.rle"

BlocksetTiles_Shared3: INCBIN "data/levels/blocksets/blockset_tiles_18.bin"
BlocksetAttributes_Shared3: INCBIN "data/levels/blocksets/blockset_attributes_18.bin.rle"
BlocksetTiles_TheVolcanosBase1: INCBIN "data/levels/blocksets/blockset_tiles_19.bin"
BlocksetAttributes_TheVolcanosBase1: INCBIN "data/levels/blocksets/blockset_attributes_19.bin.rle"
BlocksetTiles_ThePoolOfRain3: INCBIN "data/levels/blocksets/blockset_tiles_20.bin"
BlocksetAttributes_ThePoolOfRain3: INCBIN "data/levels/blocksets/blockset_attributes_20.bin.rle"
BlocksetTiles_ATownInChaos1: INCBIN "data/levels/blocksets/blockset_tiles_21.bin"
BlocksetAttributes_ATownInChaos1: INCBIN "data/levels/blocksets/blockset_attributes_21.bin.rle"
BlocksetTiles_ATownInChaos2: INCBIN "data/levels/blocksets/blockset_tiles_22.bin"
BlocksetAttributes_ATownInChaos2: INCBIN "data/levels/blocksets/blockset_attributes_22.bin.rle"
BlocksetTiles_BeneathTheWaves1: INCBIN "data/levels/blocksets/blockset_tiles_23.bin"
BlocksetAttributes_BeneathTheWaves1: INCBIN "data/levels/blocksets/blockset_attributes_23.bin.rle"


SECTION "Level Data 5", ROMX

ThePoolOfRain1BlockMap: INCBIN "data/levels/block_map/the_pool_of_rain_1.bin.rle"
ATownInChaosBlockMap:   INCBIN "data/levels/block_map/a_town_in_chaos.bin.rle"

ThePoolOfRain1ObjectMap: INCBIN "data/levels/object_map/the_pool_of_rain_1.bin.rle"
ATownInChaosObjectMap:   INCBIN "data/levels/object_map/a_town_in_chaos.bin.rle"

BlocksetTiles_TheGrasslands2: INCBIN "data/levels/blocksets/blockset_tiles_24.bin"
BlocksetAttributes_TheGrasslands2: INCBIN "data/levels/blocksets/blockset_attributes_24.bin.rle"
BlocksetTiles_TheBigBridge3: INCBIN "data/levels/blocksets/blockset_tiles_25.bin"
BlocksetAttributes_TheBigBridge3: INCBIN "data/levels/blocksets/blockset_attributes_25.bin.rle"
BlocksetTiles_TheBigBridge2: INCBIN "data/levels/blocksets/blockset_tiles_26.bin"
BlocksetAttributes_TheBigBridge2: INCBIN "data/levels/blocksets/blockset_attributes_26.bin.rle"
BlocksetTiles_TowerOfRevival3: INCBIN "data/levels/blocksets/blockset_tiles_27.bin"
BlocksetAttributes_TowerOfRevival3: INCBIN "data/levels/blocksets/blockset_attributes_27.bin.rle"
BlocksetTiles_TheSteepCanyon1: INCBIN "data/levels/blocksets/blockset_tiles_28.bin"
BlocksetAttributes_TheSteepCanyon1: INCBIN "data/levels/blocksets/blockset_attributes_28.bin.rle"
BlocksetTiles_AboveTheClouds1: INCBIN "data/levels/blocksets/blockset_tiles_29.bin"
BlocksetAttributes_AboveTheClouds1: INCBIN "data/levels/blocksets/blockset_attributes_29.bin.rle"


SECTION "Level Data 6", ROMX

BeneathTheWavesBlockMap: INCBIN "data/levels/block_map/beneath_the_waves.bin.rle"
TheWestCraterBlockMap:   INCBIN "data/levels/block_map/the_west_crater.bin.rle"

BeneathTheWavesObjectMap: INCBIN "data/levels/object_map/beneath_the_waves.bin.rle"
TheWestCraterObjectMap:   INCBIN "data/levels/object_map/the_west_crater.bin.rle"

BlocksetTiles_TheStagnantSwamp1: INCBIN "data/levels/blocksets/blockset_tiles_30.bin"
BlocksetAttributes_TheStagnantSwamp1: INCBIN "data/levels/blocksets/blockset_attributes_30.bin.rle"
BlocksetTiles_DesertRuins4: INCBIN "data/levels/blocksets/blockset_tiles_31.bin"
BlocksetAttributes_DesertRuins4: INCBIN "data/levels/blocksets/blockset_attributes_31.bin.rle"
BlocksetTiles_TheFrigidSea3: INCBIN "data/levels/blocksets/blockset_tiles_32.bin"
BlocksetAttributes_TheFrigidSea3: INCBIN "data/levels/blocksets/blockset_attributes_32.bin.rle"
BlocksetTiles_CastleOfIllusions1: INCBIN "data/levels/blocksets/blockset_tiles_33.bin"
BlocksetAttributes_CastleOfIllusions1: INCBIN "data/levels/blocksets/blockset_attributes_33.bin.rle"
BlocksetTiles_TheColossalHole1: INCBIN "data/levels/blocksets/blockset_tiles_34.bin"
BlocksetAttributes_TheColossalHole1: INCBIN "data/levels/blocksets/blockset_attributes_34.bin.rle"
BlocksetTiles_TheStagnantSwamp4: INCBIN "data/levels/blocksets/blockset_tiles_35.bin"
BlocksetAttributes_TheStagnantSwamp4: INCBIN "data/levels/blocksets/blockset_attributes_35.bin.rle"


SECTION "Level Data 7", ROMX

TheGrasslandsBlockMap: INCBIN "data/levels/block_map/the_grasslands.bin.rle"
TheBigBridgeBlockMap:  INCBIN "data/levels/block_map/the_big_bridge.bin.rle"

TheGrasslandsObjectMap: INCBIN "data/levels/object_map/the_grasslands.bin.rle"
TheBigBridgeObjectMap:  INCBIN "data/levels/object_map/the_big_bridge.bin.rle"

BlocksetTiles_Craters1: INCBIN "data/levels/blocksets/blockset_tiles_36.bin"
BlocksetAttributes_Craters1: INCBIN "data/levels/blocksets/blockset_attributes_36.bin.rle"
BlocksetTiles_TheWarpedVoid1: INCBIN "data/levels/blocksets/blockset_tiles_37.bin"
BlocksetAttributes_TheWarpedVoid1: INCBIN "data/levels/blocksets/blockset_attributes_37.bin.rle"
BlocksetTiles_ForestOfFear1: INCBIN "data/levels/blocksets/blockset_tiles_38.bin"
BlocksetAttributes_ForestOfFear1: INCBIN "data/levels/blocksets/blockset_attributes_38.bin.rle"
BlocksetTiles_CaveOfFlames1: INCBIN "data/levels/blocksets/blockset_tiles_39.bin"
BlocksetAttributes_CaveOfFlames1: INCBIN "data/levels/blocksets/blockset_attributes_39.bin.rle"
BlocksetTiles_BeneathTheWaves2: INCBIN "data/levels/blocksets/blockset_tiles_40.bin"
BlocksetAttributes_BeneathTheWaves2: INCBIN "data/levels/blocksets/blockset_attributes_40.bin.rle"
BlocksetTiles_CastleOfIllusions2: INCBIN "data/levels/blocksets/blockset_tiles_41.bin"
BlocksetAttributes_CastleOfIllusions2: INCBIN "data/levels/blocksets/blockset_attributes_41.bin.rle"


SECTION "Level Data 8", ROMX

TowerOfRevivalBlockMap:     INCBIN "data/levels/block_map/tower_of_revival.bin.rle"
BankOfTheWildRiverBlockMap: INCBIN "data/levels/block_map/bank_of_the_wild_river.bin.rle"

TowerOfRevivalObjectMap:     INCBIN "data/levels/object_map/tower_of_revival.bin.rle"
BankOfTheWildRiverObjectMap: INCBIN "data/levels/object_map/bank_of_the_wild_river.bin.rle"

BlocksetTiles_CastleOfIllusions3: INCBIN "data/levels/blocksets/blockset_tiles_42.bin"
BlocksetAttributes_CastleOfIllusions3: INCBIN "data/levels/blocksets/blockset_attributes_42.bin.rle"
BlocksetTiles_ATownInChaos4: INCBIN "data/levels/blocksets/blockset_tiles_43.bin"
BlocksetAttributes_ATownInChaos4: INCBIN "data/levels/blocksets/blockset_attributes_43.bin.rle"
BlocksetTiles_TheTemple: INCBIN "data/levels/blocksets/blockset_tiles_44.bin"
BlocksetAttributes_TheTemple: INCBIN "data/levels/blocksets/blockset_attributes_44.bin.rle"
BlocksetTiles_DesertRuins3: INCBIN "data/levels/blocksets/blockset_tiles_45.bin"
BlocksetAttributes_DesertRuins3: INCBIN "data/levels/blocksets/blockset_attributes_45.bin.rle"
BlocksetTiles_TheVastPlain1: INCBIN "data/levels/blocksets/blockset_tiles_46.bin"
BlocksetAttributes_TheVastPlain1: INCBIN "data/levels/blocksets/blockset_attributes_46.bin.rle"
BlocksetTiles_TheFrigidSea2: INCBIN "data/levels/blocksets/blockset_tiles_47.bin"
BlocksetAttributes_TheFrigidSea2: INCBIN "data/levels/blocksets/blockset_attributes_47.bin.rle"


SECTION "Level Data 9", ROMX

CaveOfFlamesBlockMap:    INCBIN "data/levels/block_map/cave_of_flames.bin.rle"
AboveTheClouds1BlockMap: INCBIN "data/levels/block_map/above_the_clouds_1.bin.rle"

CaveOfFlamesObjectMap:    INCBIN "data/levels/object_map/cave_of_flames.bin.rle"
AboveTheClouds1ObjectMap: INCBIN "data/levels/object_map/above_the_clouds_1.bin.rle"

BlocksetTiles_TheVastPlain2: INCBIN "data/levels/blocksets/blockset_tiles_48.bin"
BlocksetAttributes_TheVastPlain2: INCBIN "data/levels/blocksets/blockset_attributes_48.bin.rle"
BlocksetTiles_TheStagnantSwamp3: INCBIN "data/levels/blocksets/blockset_tiles_49.bin"
BlocksetAttributes_TheStagnantSwamp3: INCBIN "data/levels/blocksets/blockset_attributes_49.bin.rle"
BlocksetTiles_ThePoolOfRain2: INCBIN "data/levels/blocksets/blockset_tiles_50.bin"
BlocksetAttributes_ThePoolOfRain2: INCBIN "data/levels/blocksets/blockset_attributes_50.bin.rle"
BlocksetTiles_TowerOfRevival2: INCBIN "data/levels/blocksets/blockset_tiles_51.bin"
BlocksetAttributes_TowerOfRevival2: INCBIN "data/levels/blocksets/blockset_attributes_51.bin.rle"
BlocksetTiles_ThePoolOfRain1: INCBIN "data/levels/blocksets/blockset_tiles_52.bin"
BlocksetAttributes_ThePoolOfRain1: INCBIN "data/levels/blocksets/blockset_attributes_52.bin.rle"
BlocksetTiles_ATownInChaos3: INCBIN "data/levels/blocksets/blockset_tiles_53.bin"
BlocksetAttributes_ATownInChaos3: INCBIN "data/levels/blocksets/blockset_attributes_53.bin.rle"


SECTION "Level Data 10", ROMX

TheStagnantSwamp1BlockMap: INCBIN "data/levels/block_map/the_stagnant_swamp_1.bin.rle"
TheFrigidSeaBlockMap:      INCBIN "data/levels/block_map/the_frigid_sea.bin.rle"

TheStagnantSwamp1ObjectMap: INCBIN "data/levels/object_map/the_stagnant_swamp_1.bin.rle"
TheFrigidSeaObjectMap:      INCBIN "data/levels/object_map/the_frigid_sea.bin.rle"

BlocksetTiles_TheGrasslands1: INCBIN "data/levels/blocksets/blockset_tiles_54.bin"
BlocksetAttributes_TheGrasslands1: INCBIN "data/levels/blocksets/blockset_attributes_54.bin.rle"
BlocksetTiles_TheBigBridge1: INCBIN "data/levels/blocksets/blockset_tiles_55.bin"
BlocksetAttributes_TheBigBridge1: INCBIN "data/levels/blocksets/blockset_attributes_55.bin.rle"
BlocksetTiles_TowerOfRevival1: INCBIN "data/levels/blocksets/blockset_tiles_56.bin"
BlocksetAttributes_TowerOfRevival1: INCBIN "data/levels/blocksets/blockset_attributes_56.bin.rle"
BlocksetTiles_TowerOfRevival4: INCBIN "data/levels/blocksets/blockset_tiles_57.bin"
BlocksetAttributes_TowerOfRevival4: INCBIN "data/levels/blocksets/blockset_attributes_57.bin.rle"
BlocksetTiles_TowerOfRevival5: INCBIN "data/levels/blocksets/blockset_tiles_58.bin"
BlocksetAttributes_TowerOfRevival5: INCBIN "data/levels/blocksets/blockset_attributes_58.bin.rle"
BlocksetTiles_BankOfTheWildRiver1: INCBIN "data/levels/blocksets/blockset_tiles_59.bin"
BlocksetAttributes_BankOfTheWildRiver1: INCBIN "data/levels/blocksets/blockset_attributes_59.bin.rle"


SECTION "Level Data 11", ROMX

CastleOfIllusionsBlockMap: INCBIN "data/levels/block_map/castle_of_illusions.bin.rle"
TheColossalHole1BlockMap:  INCBIN "data/levels/block_map/the_colossal_hole_1.bin.rle"

CastleOfIllusionsObjectMap: INCBIN "data/levels/object_map/castle_of_illusions.bin.rle"
TheColossalHole1ObjectMap:  INCBIN "data/levels/object_map/the_colossal_hole_1.bin.rle"

BlocksetTiles_SeaTurtleRocks3: INCBIN "data/levels/blocksets/blockset_tiles_60.bin"
BlocksetAttributes_SeaTurtleRocks3: INCBIN "data/levels/blocksets/blockset_attributes_60.bin.rle"
BlocksetTiles_SeaTurtleRocks1: INCBIN "data/levels/blocksets/blockset_tiles_61.bin"
BlocksetAttributes_SeaTurtleRocks1: INCBIN "data/levels/blocksets/blockset_attributes_61.bin.rle"
BlocksetTiles_SeaTurtleRocks4: INCBIN "data/levels/blocksets/blockset_tiles_62.bin"
BlocksetAttributes_SeaTurtleRocks4: INCBIN "data/levels/blocksets/blockset_attributes_62.bin.rle"
BlocksetTiles_TheFrigidSea5: INCBIN "data/levels/blocksets/blockset_tiles_65.bin"
BlocksetAttributes_TheFrigidSea5: INCBIN "data/levels/blocksets/blockset_attributes_65.bin.rle"
BlocksetTiles_TheFrigidSea1: INCBIN "data/levels/blocksets/blockset_tiles_63.bin"
BlocksetAttributes_TheFrigidSea1: INCBIN "data/levels/blocksets/blockset_attributes_63.bin.rle"
BlocksetTiles_TheFrigidSea4: INCBIN "data/levels/blocksets/blockset_tiles_64.bin"
BlocksetAttributes_TheFrigidSea4: INCBIN "data/levels/blocksets/blockset_attributes_64.bin.rle"


SECTION "Level Data 12", ROMX

TheWarpedVoidBlockMap: INCBIN "data/levels/block_map/the_warped_void.bin.rle"
TheEastCraterBlockMap: INCBIN "data/levels/block_map/the_east_crater.bin.rle"

TheWarpedVoidObjectMap: INCBIN "data/levels/object_map/the_warped_void.bin.rle"
TheEastCraterObjectMap: INCBIN "data/levels/object_map/the_east_crater.bin.rle"

BlocksetTiles_Shared4: INCBIN "data/levels/blocksets/blockset_tiles_66.bin"
BlocksetAttributes_Shared4: INCBIN "data/levels/blocksets/blockset_attributes_66.bin.rle"
BlocksetTiles_TheTidalCoast2: INCBIN "data/levels/blocksets/blockset_tiles_67.bin"
BlocksetAttributes_TheTidalCoast2: INCBIN "data/levels/blocksets/blockset_attributes_67.bin.rle"
BlocksetTiles_TheStagnantSwamp2: INCBIN "data/levels/blocksets/blockset_tiles_68.bin"
BlocksetAttributes_TheStagnantSwamp2: INCBIN "data/levels/blocksets/blockset_attributes_68.bin.rle"
BlocksetTiles_AboveTheClouds2: INCBIN "data/levels/blocksets/blockset_tiles_69.bin"
BlocksetAttributes_AboveTheClouds2: INCBIN "data/levels/blocksets/blockset_attributes_69.bin.rle"
BlocksetTiles_AboveTheClouds3: INCBIN "data/levels/blocksets/blockset_tiles_70.bin"
BlocksetAttributes_AboveTheClouds3: INCBIN "data/levels/blocksets/blockset_attributes_70.bin.rle"
BlocksetTiles_CaveOfFlames2: INCBIN "data/levels/blocksets/blockset_tiles_71.bin"
BlocksetAttributes_CaveOfFlames2: INCBIN "data/levels/blocksets/blockset_attributes_71.bin.rle"


SECTION "Level Data 13", ROMX

ForestOfFearBlockMap:     INCBIN "data/levels/block_map/forest_of_fear.bin.rle"
HiddenFigureRoomBlockMap: INCBIN "data/levels/block_map/hidden_figure_room.bin.rle"

ForestOfFearObjectMap:     INCBIN "data/levels/object_map/forest_of_fear.bin.rle"
HiddenFigureRoomObjectMap: INCBIN "data/levels/object_map/hidden_figure_room.bin.rle"

BlocksetTiles_CaveOfFlames3: INCBIN "data/levels/blocksets/blockset_tiles_72.bin"
BlocksetAttributes_CaveOfFlames3: INCBIN "data/levels/blocksets/blockset_attributes_72.bin.rle"
BlocksetTiles_BeneathTheWaves3: INCBIN "data/levels/blocksets/blockset_tiles_73.bin"
BlocksetAttributes_BeneathTheWaves3: INCBIN "data/levels/blocksets/blockset_attributes_73.bin.rle"
BlocksetTiles_BeneathTheWaves4: INCBIN "data/levels/blocksets/blockset_tiles_74.bin"
BlocksetAttributes_BeneathTheWaves4: INCBIN "data/levels/blocksets/blockset_attributes_74.bin.rle"
BlocksetTiles_TheColossalHole2: INCBIN "data/levels/blocksets/blockset_tiles_75.bin"
BlocksetAttributes_TheColossalHole2: INCBIN "data/levels/blocksets/blockset_attributes_75.bin.rle"
BlocksetTiles_CastleOfIllusions4: INCBIN "data/levels/blocksets/blockset_tiles_76.bin"
BlocksetAttributes_CastleOfIllusions4: INCBIN "data/levels/blocksets/blockset_attributes_76.bin.rle"
BlocksetTiles_CastleOfIllusions5: INCBIN "data/levels/blocksets/blockset_tiles_77.bin"
BlocksetAttributes_CastleOfIllusions5: INCBIN "data/levels/blocksets/blockset_attributes_77.bin.rle"


SECTION "Level Data 14", ROMX

TheVastPlain2BlockMap:    INCBIN "data/levels/block_map/the_vast_plain_2.bin.rle"
TheVolcanosBase2BlockMap: INCBIN "data/levels/block_map/the_volcanos_base_2.bin.rle"

TheVastPlain2ObjectMap:    INCBIN "data/levels/object_map/the_vast_plain_2.bin.rle"
TheVolcanosBase2ObjectMap: INCBIN "data/levels/object_map/the_volcanos_base_2.bin.rle"

BlocksetTiles_CastleOfIllusions6: INCBIN "data/levels/blocksets/blockset_tiles_78.bin"
BlocksetAttributes_CastleOfIllusions6: INCBIN "data/levels/blocksets/blockset_attributes_78.bin.rle"
BlocksetTiles_AboveTheClouds4: INCBIN "data/levels/blocksets/blockset_tiles_79.bin"
BlocksetAttributes_AboveTheClouds4: INCBIN "data/levels/blocksets/blockset_attributes_79.bin.rle"
BlocksetTiles_ForestOfFear2: INCBIN "data/levels/blocksets/blockset_tiles_80.bin"
BlocksetAttributes_ForestOfFear2: INCBIN "data/levels/blocksets/blockset_attributes_80.bin.rle"
BlocksetTiles_Craters2: INCBIN "data/levels/blocksets/blockset_tiles_81.bin"
BlocksetAttributes_Craters2: INCBIN "data/levels/blocksets/blockset_attributes_81.bin.rle"
BlocksetTiles_TheWarpedVoid2: INCBIN "data/levels/blocksets/blockset_tiles_82.bin"
BlocksetAttributes_TheWarpedVoid2: INCBIN "data/levels/blocksets/blockset_attributes_82.bin.rle"
BlocksetTiles_TheWarpedVoid3: INCBIN "data/levels/blocksets/blockset_tiles_83.bin"
BlocksetAttributes_TheWarpedVoid3: INCBIN "data/levels/blocksets/blockset_attributes_83.bin.rle"


SECTION "Level Data 15", ROMX

ThePoolOfRain2BlockMap:   INCBIN "data/levels/block_map/the_pool_of_rain_2.bin.rle"
TheColossalHole2BlockMap: INCBIN "data/levels/block_map/the_colossal_hole_2.bin.rle"

ThePoolOfRain2ObjectMap:   INCBIN "data/levels/object_map/the_pool_of_rain_2.bin.rle"
TheColossalHole2ObjectMap: INCBIN "data/levels/object_map/the_colossal_hole_2.bin.rle"

BlocksetTiles_TheSteepCanyon2: INCBIN "data/levels/blocksets/blockset_tiles_84.bin"
BlocksetAttributes_TheSteepCanyon2: INCBIN "data/levels/blocksets/blockset_attributes_84.bin.rle"
BlocksetTiles_TheVolcanosBase2: INCBIN "data/levels/blocksets/blockset_tiles_85.bin"
BlocksetAttributes_TheVolcanosBase2: INCBIN "data/levels/blocksets/blockset_attributes_85.bin.rle"
BlocksetTiles_AboveTheClouds5: INCBIN "data/levels/blocksets/blockset_tiles_86.bin"
BlocksetAttributes_AboveTheClouds5: INCBIN "data/levels/blocksets/blockset_attributes_86.bin.rle"
BlocksetTiles_AboveTheClouds6: INCBIN "data/levels/blocksets/blockset_tiles_87.bin"
BlocksetAttributes_AboveTheClouds6: INCBIN "data/levels/blocksets/blockset_attributes_87.bin.rle"
BlocksetTiles_TheVastPlain4: INCBIN "data/levels/blocksets/blockset_tiles_88.bin"
BlocksetAttributes_TheVastPlain4: INCBIN "data/levels/blocksets/blockset_attributes_88.bin.rle"


SECTION "Level Data 16", ROMX

TheTidalCoast2BlockMap:    INCBIN "data/levels/block_map/the_tidal_coast_2.bin.rle"
TheStagnantSwamp2BlockMap: INCBIN "data/levels/block_map/the_stagnant_swamp_2.bin.rle"

TheTidalCoast2ObjectMap:    INCBIN "data/levels/object_map/the_tidal_coast_2.bin.rle"
TheStagnantSwamp2ObjectMap: INCBIN "data/levels/object_map/the_stagnant_swamp_2.bin.rle"


SECTION "Level Data 17", ROMX

AboveTheClouds2BlockMap: INCBIN "data/levels/block_map/above_the_clouds_2.bin.rle"
TheSteepCanyon2BlockMap: INCBIN "data/levels/block_map/the_steep_canyon_2.bin.rle"

AboveTheClouds2ObjectMap: INCBIN "data/levels/object_map/above_the_clouds_2.bin.rle"
TheSteepCanyon2ObjectMap: INCBIN "data/levels/object_map/the_steep_canyon_2.bin.rle"


SECTION "Level Data 18", ROMX

ThePeacefulVillage2BlockMap: INCBIN "data/levels/block_map/the_peaceful_village_2.bin.rle"

ThePeacefulVillage2ObjectMap: INCBIN "data/levels/object_map/the_peaceful_village_2.bin.rle"


SECTION "Room Special Tiles 1", ROMX

SpecialTiles0:: INCBIN "gfx/levels/special_tiles0.2bpp"
SpecialTiles1:: INCBIN "gfx/levels/special_tiles1.2bpp"
SpecialTiles2:  INCBIN "gfx/levels/special_tiles2.2bpp"
SpecialTiles3:  INCBIN "gfx/levels/special_tiles3.2bpp"
SpecialTiles4:  INCBIN "gfx/levels/special_tiles4.2bpp"
SpecialTiles5:  INCBIN "gfx/levels/special_tiles5.2bpp"
SpecialTiles6:  INCBIN "gfx/levels/special_tiles6.2bpp"
SpecialTiles7:  INCBIN "gfx/levels/special_tiles7.2bpp"


SECTION "Room Special Tiles 2", ROMX

SpecialTiles8: INCBIN "gfx/levels/special_tiles8.2bpp"


SECTION "Block Function Tables 2", ROMX

INCLUDE "data/levels/function_tables2.asm"


SECTION "Room Main Tiles 1", ROMX

LevelMainTiles_OutOfTheWoods1:  INCBIN "gfx/levels/main_tiles0.2bpp"
LevelMainTiles_OutOfTheWoods2:  INCBIN "gfx/levels/main_tiles1.2bpp"
LevelMainTiles_OutOfTheWoods3:  INCBIN "gfx/levels/main_tiles2.2bpp"
LevelMainTiles_Shared1:  INCBIN "gfx/levels/main_tiles3.2bpp"
LevelMainTiles_ThePeacefulVillage1:  INCBIN "gfx/levels/main_tiles4.2bpp"
LevelMainTiles_ThePeacefulVillage3:  INCBIN "gfx/levels/main_tiles5.2bpp"
LevelMainTiles_TheVastPlain:  INCBIN "gfx/levels/main_tiles6.2bpp"
LevelMainTiles_BankOfTheWildRiver:: INCBIN "gfx/levels/main_tiles7.2bpp"


SECTION "Room Main Tiles 2", ROMX

LevelMainTiles_Shared2:   INCBIN "gfx/levels/main_tiles8.2bpp"
LevelMainTiles_TheTidalCoast:   INCBIN "gfx/levels/main_tiles9.2bpp"
LevelMainTiles_Shared3:  INCBIN "gfx/levels/main_tiles10.2bpp"
LevelMainTiles_SeaTurtleRocks:: INCBIN "gfx/levels/main_tiles11.2bpp"
LevelMainTiles_DesertRuins:  INCBIN "gfx/levels/main_tiles12.2bpp"
LevelMainTiles_Shared4:  INCBIN "gfx/levels/main_tiles13.2bpp"
LevelMainTiles_TheVolcanosBase:: INCBIN "gfx/levels/main_tiles14.2bpp"
LevelMainTiles_ThePoolOfRain:  INCBIN "gfx/levels/main_tiles15.2bpp"


SECTION "Room Main Tiles 3", ROMX

LevelMainTiles_ATownInChaos1:  INCBIN "gfx/levels/main_tiles16.2bpp"
LevelMainTiles_ATownInChaos2:  INCBIN "gfx/levels/main_tiles17.2bpp"
LevelMainTiles_BeneathTheWaves1:  INCBIN "gfx/levels/main_tiles18.2bpp"
LevelMainTiles_TheGrasslands:  INCBIN "gfx/levels/main_tiles19.2bpp"
LevelMainTiles_TheBigBridge1:  INCBIN "gfx/levels/main_tiles20.2bpp"
LevelMainTiles_TheBigBridge2:  INCBIN "gfx/levels/main_tiles21.2bpp"
LevelMainTiles_TowerOfRevival:: INCBIN "gfx/levels/main_tiles22.2bpp"
LevelMainTiles_TheSteepCanyon:: INCBIN "gfx/levels/main_tiles23.2bpp"


SECTION "Room Main Tiles 4", ROMX

LevelMainTiles_AboveTheClouds1:: INCBIN "gfx/levels/main_tiles24.2bpp"
LevelMainTiles_TheStagnantSwamp:  INCBIN "gfx/levels/main_tiles25.2bpp"
LevelMainTiles_TheFrigidSea:  INCBIN "gfx/levels/main_tiles26.2bpp"
LevelMainTiles_CastleOfIllusions1:: INCBIN "gfx/levels/main_tiles27.2bpp"
LevelMainTiles_TheColossalHole:: INCBIN "gfx/levels/main_tiles28.2bpp"
LevelMainTiles_Craters:: INCBIN "gfx/levels/main_tiles29.2bpp"
LevelMainTiles_TheWarpedVoid:: INCBIN "gfx/levels/main_tiles30.2bpp"
LevelMainTiles_ForestOfFear:: INCBIN "gfx/levels/main_tiles31.2bpp"


SECTION "Room Main Tiles 5", ROMX

LevelMainTiles_CaveOfFlames:  INCBIN "gfx/levels/main_tiles32.2bpp"
LevelMainTiles_BeneathTheWaves2:  INCBIN "gfx/levels/main_tiles33.2bpp"
LevelMainTiles_CastleOfIllusions2:  INCBIN "gfx/levels/main_tiles34.2bpp"
LevelMainTiles_CastleOfIllusions3:  INCBIN "gfx/levels/main_tiles35.2bpp"
LevelMainTiles_ATownInChaos3:: INCBIN "gfx/levels/main_tiles36.2bpp"
LevelMainTiles_TheTemple:  INCBIN "gfx/levels/main_tiles37.2bpp"
LevelMainTiles_ThePeacefulVillage2:  INCBIN "gfx/levels/main_tiles38.2bpp"
LevelMainTiles_AboveTheClouds2:  INCBIN "gfx/levels/main_tiles39.2bpp"


SECTION "Wario States 4", ROMX

INCLUDE "engine/level/wario_states_4.asm"


SECTION "Enemy Gfx 1 Slot 1", ROMX

SpearheadGfx::    INCBIN "gfx/enemies/spearhead.2bpp.rle"
UnusedFlowerGfx:  INCBIN "gfx/enemies/unused_flower.2bpp.rle"
MizuuoGfx:        INCBIN "gfx/enemies/mizuuo.2bpp.rle"
SilkyGfx:         INCBIN "gfx/enemies/silky.2bpp.rle"
SnakeGfx:         INCBIN "gfx/enemies/snake.2bpp.rle"
PrinceFroggyGfx:  INCBIN "gfx/enemies/prince_froggy.2bpp.rle"
MadSciensteinGfx: INCBIN "gfx/enemies/mad_scienstein.2bpp.rle"
Sun1Gfx:          INCBIN "gfx/enemies/sun1.2bpp.rle"
Moon1Gfx:         INCBIN "gfx/enemies/moon1.2bpp.rle"
RoboMouse1Gfx:    INCBIN "gfx/enemies/robo_mouse1.2bpp.rle"
HaridamaGfx:      INCBIN "gfx/enemies/haridama.2bpp.rle"
OwlGfx::          INCBIN "gfx/enemies/owl.2bpp.rle"
StoveGfx:         INCBIN "gfx/enemies/stove.2bpp.rle"
WaterSparkGfx:    INCBIN "gfx/enemies/water_spark.2bpp.rle"


SECTION "Enemy Gfx 1 Slot 2", ROMX

WebberGfx:             INCBIN "gfx/enemies/webber.2bpp.rle"
CountRichtertoffenGfx: INCBIN "gfx/enemies/count_richtertoffen.2bpp.rle"
ParaGoomGfx::          INCBIN "gfx/enemies/para_goom.2bpp.rle"
KushimushiGfx:         INCBIN "gfx/enemies/kushimushi.2bpp.rle"
BirdGfx:               INCBIN "gfx/enemies/bird.2bpp.rle"
ApplebyGfx:            INCBIN "gfx/enemies/appleby.2bpp.rle"
HammerBotGfx::         INCBIN "gfx/enemies/hammer_bot.2bpp.rle"
PneumoGfx:             INCBIN "gfx/enemies/pneumo.2bpp.rle"
Sun2Gfx:               INCBIN "gfx/enemies/sun2.2bpp.rle"
Moon2Gfx:              INCBIN "gfx/enemies/moon2.2bpp.rle"
RoboMouse2Gfx:         INCBIN "gfx/enemies/robo_mouse2.2bpp.rle"
ClearGate1Gfx:         INCBIN "gfx/enemies/clear_gate.2bpp.rle"


SECTION "Enemy Gfx 1 Slot 3", ROMX

FutamoguGfx:     INCBIN "gfx/enemies/futamogu.2bpp.rle"
HebariiGfx:      INCBIN "gfx/enemies/hebarii.2bpp.rle"
DoughnuteerGfx:: INCBIN "gfx/enemies/doughnuteer.2bpp.rle"
BigLeafGfx:      INCBIN "gfx/enemies/big_leaf.2bpp.rle"
ZombieGfx:       INCBIN "gfx/enemies/zombie.2bpp.rle"
SpearBotGfx:     INCBIN "gfx/enemies/spear_bot.2bpp.rle"
OmodonGfx:       INCBIN "gfx/enemies/omodon.2bpp.rle"
KobattoGfx:      INCBIN "gfx/enemies/kobatto.2bpp.rle"
HandGfx:         INCBIN "gfx/enemies/hand.2bpp.rle"
BubbleGfx:       INCBIN "gfx/enemies/bubble.2bpp.rle"
CartGfx::        INCBIN "gfx/enemies/cart.2bpp.rle"
ZipLineGfx:      INCBIN "gfx/enemies/zip_line.2bpp.rle"
FlameBlockGfx:   INCBIN "gfx/enemies/flame_block.2bpp.rle"
ClearGate2Gfx:   INCBIN "gfx/enemies/clear_gate.2bpp.rle"
TadpoleGfx:      INCBIN "gfx/enemies/tadpole.2bpp.rle"
RockGfx:         INCBIN "gfx/enemies/rock.2bpp.rle"
FireGfx::        INCBIN "gfx/enemies/fire.2bpp.rle"
WallCrackGfx::   INCBIN "gfx/enemies/wall_crack.2bpp.rle"


SECTION "Enemy Gfx 1 Slot 4", ROMX

TorchGfx:          INCBIN "gfx/enemies/torch.2bpp.rle"
FireBotGfx:        INCBIN "gfx/enemies/fire_bot.2bpp.rle"
BeamBotGfx:        INCBIN "gfx/enemies/beam_bot.2bpp.rle"
BarrelGfx:         INCBIN "gfx/enemies/barrel.2bpp.rle"
SmallLeafGfx:      INCBIN "gfx/enemies/small_leaf.2bpp.rle"
ElectricLampGfx:   INCBIN "gfx/enemies/electric_lamp.2bpp.rle"
TeruteruGfx:       INCBIN "gfx/enemies/teruteru.2bpp.rle"
OmodonmekaGfx:     INCBIN "gfx/enemies/omodonmeka.2bpp.rle"
BrrrBearGfx:       INCBIN "gfx/enemies/brrr_bear.2bpp.rle"
TogebaGfx:         INCBIN "gfx/enemies/togeba.2bpp.rle"
FallingSnowGfx:    INCBIN "gfx/enemies/falling_snow.2bpp.rle"
PillarPlatformGfx: INCBIN "gfx/enemies/pillar_platform.2bpp.rle"
WaterDropGfx:      INCBIN "gfx/enemies/water_drop.2bpp.rle"
NobiiruGfx:        INCBIN "gfx/enemies/nobiiru.2bpp.rle"
ClearGate3Gfx:     INCBIN "gfx/enemies/clear_gate.2bpp.rle"
OctohonGfx::       INCBIN "gfx/enemies/octohon.2bpp.rle"
SparkGfx:          INCBIN "gfx/enemies/spark.2bpp.rle"


SECTION "Enemy Gfx 2 Slot 1", ROMX

Anonster1Gfx:    INCBIN "gfx/enemies/anonster1.2bpp.rle"
DollBoy1Gfx:     INCBIN "gfx/enemies/doll_boy1.2bpp.rle"
Wormwould1Gfx:   INCBIN "gfx/enemies/wormwould1.2bpp.rle"
YellowBelly1Gfx: INCBIN "gfx/enemies/yellow_belly1.2bpp.rle"
Pesce1Gfx:       INCBIN "gfx/enemies/pesce1.2bpp.rle"
Scowler1Gfx:     INCBIN "gfx/enemies/scowler1.2bpp.rle"
Jamano1Gfx:      INCBIN "gfx/enemies/jamano1.2bpp.rle"
Muddee1Gfx:      INCBIN "gfx/enemies/muddee1.2bpp.rle"
Wolfenboss1Gfx:  INCBIN "gfx/enemies/wolfenboss1.2bpp.rle"
Shoot1Gfx:       INCBIN "gfx/enemies/shoot1.2bpp.rle"


SECTION "Enemy Gfx 2 Slot 2", ROMX

Anonster2Gfx:    INCBIN "gfx/enemies/anonster2.2bpp.rle"
DollBoy2Gfx:     INCBIN "gfx/enemies/doll_boy2.2bpp.rle"
Wormwould2Gfx:   INCBIN "gfx/enemies/wormwould2.2bpp.rle"
YellowBelly2Gfx: INCBIN "gfx/enemies/yellow_belly2.2bpp.rle"
Pesce2Gfx:       INCBIN "gfx/enemies/pesce2.2bpp.rle"
Scowler2Gfx:     INCBIN "gfx/enemies/scowler2.2bpp.rle"
Jamano2Gfx:      INCBIN "gfx/enemies/jamano2.2bpp.rle"
Muddee2Gfx:      INCBIN "gfx/enemies/muddee2.2bpp.rle"
Wolfenboss2Gfx:  INCBIN "gfx/enemies/wolfenboss2.2bpp.rle"
Shoot2Gfx:       INCBIN "gfx/enemies/shoot2.2bpp.rle"


SECTION "Enemy Gfx 2 Slot 3", ROMX

Anonster3Gfx:    INCBIN "gfx/enemies/anonster3.2bpp.rle"
DollBoy3Gfx:     INCBIN "gfx/enemies/doll_boy3.2bpp.rle"
Wormwould3Gfx:   INCBIN "gfx/enemies/wormwould3.2bpp.rle"
YellowBelly3Gfx: INCBIN "gfx/enemies/yellow_belly3.2bpp.rle"
Pesce3Gfx:       INCBIN "gfx/enemies/pesce3.2bpp.rle"
Scowler3Gfx:     INCBIN "gfx/enemies/scowler3.2bpp.rle"
Jamano3Gfx:      INCBIN "gfx/enemies/jamano3.2bpp.rle"
Muddee3Gfx:      INCBIN "gfx/enemies/muddee3.2bpp.rle"
Wolfenboss3Gfx:  INCBIN "gfx/enemies/wolfenboss3.2bpp.rle"
Shoot3Gfx:       INCBIN "gfx/enemies/shoot3.2bpp.rle"


SECTION "Enemy Gfx 2 Slot 4", ROMX

Anonster4Gfx:    INCBIN "gfx/enemies/anonster4.2bpp.rle"
DollBoy4Gfx:     INCBIN "gfx/enemies/doll_boy4.2bpp.rle"
Wormwould4Gfx:   INCBIN "gfx/enemies/wormwould4.2bpp.rle"
YellowBelly4Gfx: INCBIN "gfx/enemies/yellow_belly4.2bpp.rle"
Pesce4Gfx:       INCBIN "gfx/enemies/pesce4.2bpp.rle"
Scowler4Gfx:     INCBIN "gfx/enemies/scowler4.2bpp.rle"
Jamano4Gfx:      INCBIN "gfx/enemies/jamano4.2bpp.rle"
Muddee4Gfx:      INCBIN "gfx/enemies/muddee4.2bpp.rle"
Wolfenboss4Gfx:  INCBIN "gfx/enemies/wolfenboss4.2bpp.rle"
Shoot4Gfx:       INCBIN "gfx/enemies/shoot4.2bpp.rle"


SECTION "Wario OAM 1", ROMX

INCLUDE "gfx/oam/wario1.asm"


SECTION "Wario OAM 2", ROMX

INCLUDE "gfx/oam/wario2.asm"


SECTION "Wario OAM 3", ROMX

INCLUDE "gfx/oam/wario3.asm"


SECTION "Object Framesets", ROMX

INCLUDE "gfx/oam/object_framesets.asm"


SECTION "Objects OAM 1", ROMX

INCLUDE "gfx/oam/objects1.asm"


SECTION "Objects OAM 2", ROMX

INCLUDE "gfx/oam/objects2.asm"


SECTION "Objects OAM 3", ROMX

INCLUDE "gfx/oam/objects3.asm"


SECTION "Objects OAM 4", ROMX

INCLUDE "gfx/oam/objects4.asm"


SECTION "Objects OAM 5", ROMX

INCLUDE "gfx/oam/objects5.asm"


SECTION "Objects OAM 6", ROMX

INCLUDE "gfx/oam/objects6.asm"


SECTION "Level Palettes", ROMX

INCLUDE "data/levels/palettes.asm"


SECTION "Animated Tile Gfx", ROMX

AnimatedTilesGfx:
AnimatedTiles1Gfx:  INCBIN "gfx/levels/animated/animated_tiles1.2bpp"  ; ANIMATED_TILES_GFX_SHARED_1
AnimatedTiles2Gfx:  INCBIN "gfx/levels/animated/animated_tiles2.2bpp"  ; ANIMATED_TILES_GFX_OUT_OF_THE_WOODS
AnimatedTiles3Gfx:  INCBIN "gfx/levels/animated/animated_tiles3.2bpp"  ; ANIMATED_TILES_GFX_WATER
AnimatedTiles4Gfx:  INCBIN "gfx/levels/animated/animated_tiles4.2bpp"  ; ANIMATED_TILES_GFX_SHARED_2
AnimatedTiles5Gfx:  INCBIN "gfx/levels/animated/animated_tiles5.2bpp"  ; ANIMATED_TILES_GFX_DESERT_RUINS
AnimatedTiles6Gfx:  INCBIN "gfx/levels/animated/animated_tiles6.2bpp"  ; ANIMATED_TILES_GFX_SHARED_3
AnimatedTiles7Gfx:  INCBIN "gfx/levels/animated/animated_tiles7.2bpp"  ; ANIMATED_TILES_GFX_SHARED_4
AnimatedTiles8Gfx:  INCBIN "gfx/levels/animated/animated_tiles8.2bpp"  ; ANIMATED_TILES_GFX_BENEATH_THE_WAVES
AnimatedTiles9Gfx:  INCBIN "gfx/levels/animated/animated_tiles9.2bpp"  ; ANIMATED_TILES_GFX_THE_FRIGID_SEA
AnimatedTiles10Gfx: INCBIN "gfx/levels/animated/animated_tiles10.2bpp" ; ANIMATED_TILES_GFX_SHARED_5
AnimatedTiles11Gfx: INCBIN "gfx/levels/animated/animated_tiles11.2bpp" ; ANIMATED_TILES_GFX_SHARED_6
AnimatedTiles12Gfx: INCBIN "gfx/levels/animated/animated_tiles12.2bpp" ; ANIMATED_TILES_GFX_SHARED_7
AnimatedTiles13Gfx: INCBIN "gfx/levels/animated/animated_tiles13.2bpp" ; ANIMATED_TILES_GFX_BANK_OF_THE_WILD_RIVER
AnimatedTiles14Gfx: INCBIN "gfx/levels/animated/animated_tiles14.2bpp" ; ANIMATED_TILES_GFX_THE_STAGNANT_SWAMP
AnimatedTiles15Gfx: INCBIN "gfx/levels/animated/animated_tiles15.2bpp" ; ANIMATED_TILES_GFX_THE_WARPED_VOID
AnimatedTiles16Gfx: INCBIN "gfx/levels/animated/animated_tiles16.2bpp" ; ANIMATED_TILES_GFX_MENU
AnimatedTiles17Gfx: INCBIN "gfx/levels/animated/animated_tiles17.2bpp" ; ANIMATED_TILES_GFX_SEA_TURTLE_ROCKS
AnimatedTiles18Gfx: INCBIN "gfx/levels/animated/animated_tiles18.2bpp" ; ANIMATED_TILES_GFX_SHARED_8
AnimatedTiles19Gfx: INCBIN "gfx/levels/animated/animated_tiles19.2bpp" ; ANIMATED_TILES_GFX_SHARED_9
AnimatedTiles20Gfx: INCBIN "gfx/levels/animated/animated_tiles20.2bpp" ; ANIMATED_TILES_GFX_A_TOWN_IN_CHAOS
AnimatedTiles21Gfx: INCBIN "gfx/levels/animated/animated_tiles21.2bpp" ; ANIMATED_TILES_GFX_UNUSED_20
AnimatedTiles22Gfx: INCBIN "gfx/levels/animated/animated_tiles22.2bpp" ; ANIMATED_TILES_GFX_UNUSED_21
AnimatedTiles23Gfx: INCBIN "gfx/levels/animated/animated_tiles23.2bpp" ; ANIMATED_TILES_GFX_UNUSED_22
AnimatedTiles24Gfx: INCBIN "gfx/levels/animated/animated_tiles24.2bpp" ; ANIMATED_TILES_GFX_UNUSED_23
