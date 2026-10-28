ObjectGroup_Empty:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw TorchGfx

	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_BeneathTheWaves1:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw CountRichtertoffenGfx
	dw DoughnuteerGfx
	dw BeamBotGfx

	dw DummyObjectData
	dw CountRichtertoffenData
	dw DoughnuteerData
	dw BeamBotData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/count_richtertoffen.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/beam_bot.pal"

ObjectGroup_Shared1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw FutamoguGfx
	dw TorchGfx

	dw SpearheadData
	dw BlueBirdData
	dw FutamoguData
	dw TorchData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/futamogu1.pal"
INCLUDE "gfx/pals/torch.pal"

ObjectGroup_Shared2:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw CountRichtertoffenGfx
	dw ClearGate2Gfx
	dw OmodonmekaGfx

	dw SilkyData
	dw CountRichtertoffenData
	dw ClearGate2Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/count_richtertoffen.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_Shared12:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw OmodonGfx
	dw OmodonmekaGfx

	dw DummyObjectData
	dw DummyObjectData
	dw OmodonmekaWithOmodon1Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/webber1.pal"
INCLUDE "gfx/pals/omodon.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_CaveOfFlames1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw OmodonGfx
	dw OmodonmekaGfx

	dw DummyObjectData
	dw DummyObjectData
	dw OmodonmekaWithOmodon2Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/webber1.pal"
INCLUDE "gfx/pals/omodon.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_Shared3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw KushimushiGfx
	dw FutamoguGfx
	dw TorchGfx

	dw DummyObjectData
	dw KushimushiVerticalData
	dw DummyObjectData
	dw DummyObjectData
	dw KushimushiHorizontalData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/kushimushi.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_OutOfTheWoods6:
	db $00 ; GFX bank offset

	dw MizuuoGfx
	dw WebberGfx
	dw FutamoguGfx
	dw TorchGfx

	dw MizuuoData
	dw NULL

INCLUDE "gfx/pals/mizuuo.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_OutOfTheWoods4:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw KushimushiGfx
	dw BigLeafGfx
	dw TorchGfx

	dw DummyObjectData
	dw KushimushiVerticalData
	dw BigLeafSpawnerData
	dw DummyObjectData
	dw KushimushiHorizontalData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/kushimushi.pal"
INCLUDE "gfx/pals/big_leaf.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_OutOfTheWoods7:
	db $00 ; GFX bank offset

	dw MizuuoGfx
	dw WebberGfx
	dw BigLeafGfx
	dw TorchGfx

	dw MizuuoData
	dw DummyObjectData
	dw BigLeafSpawnerData
	dw NULL

INCLUDE "gfx/pals/mizuuo.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/big_leaf.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared4:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw BirdGfx
	dw DoughnuteerGfx
	dw TorchGfx

	dw SilkyData
	dw OrangeBirdData
	dw DoughnuteerData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/orange_bird.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared5:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ParaGoomGfx
	dw DoughnuteerGfx
	dw FireBotGfx

	dw SnakeData
	dw ParaGoomData
	dw DoughnuteerData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_Shared11:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ParaGoomGfx
	dw ZombieGfx
	dw FireBotGfx

	dw SnakeData
	dw ParaGoomData
	dw ZombieData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_OutOfTheWoods1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw SmallLeafGfx

	dw SpearheadData
	dw WebberData
	dw FutamoguData
	dw SmallLeafData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/webber2.pal"
INCLUDE "gfx/pals/futamogu1.pal"
INCLUDE "gfx/pals/small_leaf.pal"

ObjectGroup_Shared6:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ApplebyGfx
	dw FutamoguGfx
	dw TorchGfx

	dw SpearheadData
	dw ApplebyData
	dw FutamoguData
	dw TorchData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/futamogu1.pal"
INCLUDE "gfx/pals/torch.pal"

ObjectGroup_Shared7:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw HammerBotGfx
	dw SpearBotGfx
	dw BarrelGfx

	dw RedPrinceFroggyData
	dw HammerBotData
	dw SpearBotData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/prince_froggy1.pal"
INCLUDE "gfx/pals/hammer_bot.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheVastPlain1:
	db $00 ; GFX bank offset

	dw MadSciensteinGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw TeruteruGfx

	dw MadSciensteinData
	dw ParaGoomData
	dw FutamoguData
	dw TeruteruData
	dw SeeingEyeDoorData
	dw NULL

INCLUDE "gfx/pals/mad_scienstein.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/futamogu1.pal"
INCLUDE "gfx/pals/teruteru.pal"

ObjectGroup_Shared9:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw PneumoGfx
	dw FutamoguGfx
	dw ClearGate3Gfx

	dw SpearheadData
	dw PneumoData
	dw DummyObjectData
	dw ClearGate3Data
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/pneumo.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/clear_gate.pal"

ObjectGroup_Shared10:
	db $00 ; GFX bank offset

	dw MadSciensteinGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw ElectricLampGfx

	dw MadSciensteinData
	dw ParaGoomData
	dw DummyObjectData
	dw ElectricLampData
	dw SeeingEyeDoorData
	dw NULL

INCLUDE "gfx/pals/mad_scienstein.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/electric_lamp.pal"

ObjectGroup_TheVastPlain2:
	db $00 ; GFX bank offset

	dw Sun1Gfx
	dw Sun2Gfx
	dw ClearGate2Gfx
	dw TorchGfx

	dw SunData
	dw DummyObjectData
	dw ClearGate2Data
	dw NULL

INCLUDE "gfx/pals/sun.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TheVastPlain4:
	db $00 ; GFX bank offset

	dw Moon1Gfx
	dw Moon2Gfx
	dw ClearGate2Gfx
	dw TorchGfx

	dw MoonData
	dw DummyObjectData
	dw ClearGate2Data
	dw NULL

INCLUDE "gfx/pals/moon.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TheTidalCoast1:
	db $00 ; GFX bank offset

	dw UnusedFlowerGfx
	dw HammerBotGfx
	dw SpearBotGfx
	dw TorchGfx

	dw UnusedFlowerData
	dw HammerBotData
	dw SpearBotData
	dw TorchData
	dw NULL

INCLUDE "gfx/pals/unused_flower.pal"
INCLUDE "gfx/pals/hammer_bot.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/torch.pal"

ObjectGroup_DesertRuins1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw HandGfx
	dw TorchGfx

	dw SpearheadData
	dw DummyObjectData
	dw HandData
	dw DummyObjectData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hand1.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_DesertRuins3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw TorchGfx

	dw SpearheadData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared14:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw WebberGfx
	dw BubbleGfx
	dw TorchGfx

	dw HaridamaData
	dw DummyObjectData
	dw BubbleHoleData
	dw DummyObjectData
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/bubble.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared15:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw KobattoGfx
	dw WaterDropGfx

	dw SpearheadData
	dw DummyObjectData
	dw KobattoData
	dw WaterDropData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/kobatto.pal"
INCLUDE "gfx/pals/water_drop.pal"

ObjectGroup_TheWestCrater2:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ClearGate1Gfx
	dw CartGfx
	dw FireBotGfx

	dw SnakeData
	dw ClearGate1Data
	dw CartRightData
	dw CartLeftData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/cart.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheVolcanosBase1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ClearGate1Gfx
	dw CartGfx
	dw FireBotGfx

	dw DummyObjectData
	dw ClearGate1Data
	dw CartVariableRightData
	dw CartVariableLeftData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/cart.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheVolcanosBase4:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ClearGate1Gfx
	dw CartGfx
	dw FireBotGfx

	dw SnakeData
	dw ClearGate1Data
	dw CartVariableRightData
	dw CartVariableLeftData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/cart.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_SeaTurtleRocks3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw CartGfx
	dw TorchGfx

	dw SpearheadData
	dw DummyObjectData
	dw CartRightData
	dw CartLeftData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/cart.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TheVolcanosBase3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw NobiiruGfx

	dw DummyObjectData
	dw ParaGoomData
	dw DummyObjectData
	dw NobiiruLeftData
	dw NobiiruRightData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/nobiiru.pal"

ObjectGroup_Shared22:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw ParaGoomGfx
	dw ClearGate2Gfx
	dw BeamBotGfx

	dw SilkyData
	dw ParaGoomData
	dw ClearGate2Data
	dw BeamBotData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/beam_bot.pal"

ObjectGroup_SeaTurtleRocks1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ApplebyGfx
	dw ClearGate2Gfx
	dw ElectricLampGfx

	dw DummyObjectData
	dw ApplebyData
	dw ClearGate2Data
	dw ElectricLampData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/electric_lamp.pal"

ObjectGroup_ThePeacefulVillage4:
	db $00 ; GFX bank offset

	dw RoboMouse1Gfx
	dw RoboMouse2Gfx
	dw SpearBotGfx
	dw TorchGfx

	dw RoboMouseData
	dw DummyObjectData
	dw SpearBotData
	dw NULL

INCLUDE "gfx/pals/robo_mouse.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared17:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw TogebaGfx

	dw DummyObjectData
	dw ParaGoomData
	dw DummyObjectData
	dw TogebaData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/togeba.pal"

ObjectGroup_BeneathTheWaves4:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw WebberGfx
	dw FutamoguGfx
	dw BrrrBearGfx

	dw HaridamaData
	dw DummyObjectData
	dw DummyObjectData
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_TheBigBridge2:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw WebberGfx
	dw BubbleGfx
	dw NobiiruGfx

	dw HaridamaData
	dw WebberData
	dw BubbleHoleData
	dw NobiiruLeftData
	dw NobiiruRightData
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/webber2.pal"
INCLUDE "gfx/pals/bubble.pal"
INCLUDE "gfx/pals/nobiiru.pal"

ObjectGroup_TheColossalHole1:
	db $00 ; GFX bank offset

	dw OwlGfx
	dw WebberGfx
	dw OmodonGfx
	dw OmodonmekaGfx

	dw OwlData
	dw DummyObjectData
	dw OmodonmekaWithOmodon1Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/owl.pal"
INCLUDE "gfx/pals/webber1.pal"
INCLUDE "gfx/pals/omodon.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_TheColossalHole3:
	db $00 ; GFX bank offset

	dw OwlGfx
	dw PneumoGfx
	dw ClearGate2Gfx
	dw OmodonmekaGfx

	dw OwlData
	dw PneumoData
	dw ClearGate2Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/owl.pal"
INCLUDE "gfx/pals/pneumo.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_Shared18:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw ZipLineGfx
	dw BeamBotGfx

	dw ZipLine1Data
	dw ZipLine2Data
	dw ZipLine3Data
	dw ZipLine4Data
	dw ZipLine5Data
	dw ParaGoomData
	dw SpearheadData
	dw BeamBotData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/zip_line.pal"
INCLUDE "gfx/pals/beam_bot.pal"

ObjectGroup_Shared19:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw SpearBotGfx
	dw FireBotGfx

	dw SpearheadData
	dw ParaGoomData
	dw SpearBotData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_OutOfTheWoods3:
	db $04 ; GFX bank offset

	dw Anonster1Gfx
	dw Anonster2Gfx
	dw Anonster3Gfx
	dw Anonster4Gfx

	dw AnonsterData
	dw SilkPlatformsData
	dw NULL

INCLUDE "gfx/pals/anonster.pal"

ObjectGroup_Shared20:
	db $00 ; GFX bank offset

	dw StoveGfx
	dw ParaGoomGfx
	dw FlameBlockGfx
	dw TorchGfx

	dw StoveData
	dw ParaGoomData
	dw FlameBlockData
	dw TorchNoEmbersData
	dw FlameBlockTorchData
	dw NULL

INCLUDE "gfx/pals/stove.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/flame_block.pal"
INCLUDE "gfx/pals/torch.pal"

ObjectGroup_TheColossalHole5:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw KobattoGfx
	dw TorchGfx

	dw SpearheadData
	dw BlueBirdData
	dw KobattoData
	dw DummyObjectData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/kobatto.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_CastleOfIllusions2:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw HammerBotGfx
	dw ZombieGfx
	dw TorchGfx

	dw DummyObjectData
	dw HammerBotData
	dw ZombieData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hammer_bot.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TheVolcanosBase2:
	db $04 ; GFX bank offset

	dw DollBoy1Gfx
	dw DollBoy2Gfx
	dw DollBoy3Gfx
	dw DollBoy4Gfx

	dw DollBoyData
	dw HammerPlatformSpawnerData
	dw DollBoyBarrel1Data
	dw DollBoyBarrel2Data
	dw DollBoyBarrel3Data
	dw NULL

INCLUDE "gfx/pals/doll_boy.pal"

ObjectGroup_TheVastPlain3:
	db $00 ; GFX bank offset

	dw MadSciensteinGfx
	dw ParaGoomGfx
	dw ZombieGfx
	dw TorchGfx

	dw MadSciensteinData
	dw ParaGoomData
	dw ZombieData
	dw DummyObjectData
	dw SeeingEyeDoorData
	dw NULL

INCLUDE "gfx/pals/mad_scienstein.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TheGrasslands3:
	db $04 ; GFX bank offset

	dw Wormwould1Gfx
	dw Wormwould2Gfx
	dw Wormwould3Gfx
	dw Wormwould4Gfx

	dw WormwouldData
	dw PalmTreeSpawnerData
	dw NULL

INCLUDE "gfx/pals/wormwould.pal"

ObjectGroup_CastleOfIllusions3:
	db $00 ; GFX bank offset

	dw OwlGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw TorchGfx

	dw OwlData
	dw ParaGoomData
	dw NULL

INCLUDE "gfx/pals/owl.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_ThePoolOfRain1:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw PillarPlatformGfx

	dw HaridamaData
	dw ParaGoomData
	dw DummyObjectData
	dw PillarPlatform1Data
	dw PillarPlatform2Data
	dw PillarPlatform3Data
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/futamogu2.pal"
INCLUDE "gfx/pals/pillar_platform.pal"

ObjectGroup_ThePeacefulVillage1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw DoughnuteerGfx
	dw FireBotGfx

	dw DummyObjectData
	dw ParaGoomData
	dw DoughnuteerData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_ThePeacefulVillage5:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw ZombieGfx
	dw FireBotGfx

	dw DummyObjectData
	dw ParaGoomData
	dw ZombieData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_DesertRuins2:
	db $04 ; GFX bank offset

	dw YellowBelly1Gfx
	dw YellowBelly2Gfx
	dw YellowBelly3Gfx
	dw YellowBelly4Gfx

	dw YellowBellyBodyData
	dw YellowBellyPlatformData
	dw NULL

INCLUDE "gfx/pals/yellow_belly.pal"

ObjectGroup_ATownInChaos3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ApplebyGfx
	dw KobattoGfx
	dw WaterDropGfx

	dw SpearheadData
	dw ApplebyData
	dw KobattoData
	dw WaterDropData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/kobatto.pal"
INCLUDE "gfx/pals/water_drop.pal"

ObjectGroup_ThePeacefulVillage2:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw DoughnuteerGfx
	dw TorchGfx

	dw SpearheadData
	dw DummyObjectData
	dw DoughnuteerData
	dw DummyObjectData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared23:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw ParaGoomGfx
	dw ZipLineGfx
	dw BrrrBearGfx

	dw GreyPrinceFroggyData
	dw ParaGoomData
	dw ZipLine4Data
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/zip_line.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_BankOfTheWildRiver3:
	db $04 ; GFX bank offset

	dw Pesce1Gfx
	dw Pesce2Gfx
	dw Pesce3Gfx
	dw Pesce4Gfx

	dw PesceData
	dw DragonflySpawnerData
	dw FlySpawnerData
	dw StrongWaterCurrentData
	dw Dragonfly2Data
	dw NULL

INCLUDE "gfx/pals/pesce.pal"

ObjectGroup_Shared24:
	db $00 ; GFX bank offset

	dw StoveGfx
	dw WebberGfx
	dw DoughnuteerGfx
	dw TorchGfx

	dw StoveData
	dw DummyObjectData
	dw DoughnuteerData
	dw NULL

INCLUDE "gfx/pals/stove.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_ATownInChaos2:
	db $00 ; GFX bank offset

	dw StoveGfx
	dw WebberGfx
	dw ZombieGfx
	dw FireBotGfx

	dw StoveData
	dw DummyObjectData
	dw ZombieData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/stove.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheGrasslands5:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw BirdGfx
	dw HebariiGfx
	dw NobiiruGfx

	dw SnakeData
	dw OrangeBirdData
	dw HebariiData
	dw NobiiruLeftData
	dw NobiiruRightData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/orange_bird.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/nobiiru.pal"

ObjectGroup_TheBigBridge1:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw WebberGfx
	dw TadpoleGfx
	dw BarrelGfx

	dw HaridamaData
	dw DummyObjectData
	dw TadpoleSpawnerData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/tadpole.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_BankOfTheWildRiver2:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw WebberGfx
	dw KobattoGfx
	dw WaterDropGfx

	dw GreyPrinceFroggyData
	dw DummyObjectData
	dw KobattoData
	dw WaterDropData
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/kobatto.pal"
INCLUDE "gfx/pals/water_drop.pal"

ObjectGroup_TowerOfRevival3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw PneumoGfx
	dw DoughnuteerGfx
	dw SparkGfx

	dw DummyObjectData
	dw PneumoData
	dw DoughnuteerData
	dw SparkHorizontalData
	dw SparkVerticalData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/pneumo.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/spark.pal"

ObjectGroup_TheStagnantSwamp3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw PneumoGfx
	dw FutamoguGfx
	dw BeamBotGfx

	dw SpearheadData
	dw PneumoData
	dw DummyObjectData
	dw BeamBotData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/pneumo.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/beam_bot.pal"

ObjectGroup_TheColossalHole4:
	db $00 ; GFX bank offset

	dw Sun1Gfx
	dw Sun2Gfx
	dw SpearBotGfx
	dw BrrrBearGfx

	dw SunData
	dw DummyObjectData
	dw SpearBotData
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/sun.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_TheGrasslands2:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw BubbleGfx
	dw BarrelGfx

	dw DummyObjectData
	dw OrangeBirdData
	dw BubbleHoleData
	dw Barrel1Data
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/orange_bird.pal"
INCLUDE "gfx/pals/bubble.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheEastCrater1:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw PneumoGfx
	dw WallCrackGfx
	dw BarrelGfx

	dw GreyPrinceFroggyData
	dw PneumoData
	dw WallCrackClosedData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/pneumo.pal"
INCLUDE "gfx/pals/wall_crack.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheEastCrater4:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ParaGoomGfx
	dw FireGfx
	dw FireBotGfx

	dw SnakeData
	dw ParaGoomData
	dw FireData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/fire.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheEastCrater3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw KobattoGfx
	dw NobiiruGfx

	dw DummyObjectData
	dw DummyObjectData
	dw KobattoData
	dw NobiiruLeftData
	dw NobiiruRightData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/kobatto.pal"
INCLUDE "gfx/pals/nobiiru.pal"

ObjectGroup_TheEastCrater2:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ApplebyGfx
	dw WallCrackGfx
	dw BarrelGfx

	dw SnakeData
	dw ApplebyData
	dw WallCrackOpenData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/wall_crack.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_SeaTurtleRocks2:
	db $04 ; GFX bank offset

	dw Scowler1Gfx
	dw Scowler2Gfx
	dw Scowler3Gfx
	dw Scowler4Gfx

	dw ScowlerData
	dw FloatingRingSpawnerData
	dw NULL

INCLUDE "gfx/pals/scowler.pal"

ObjectGroup_BankOfTheWildRiver1:
	db $00 ; GFX bank offset

	dw WaterSparkGfx
	dw WebberGfx
	dw SpearBotGfx
	dw FireBotGfx

	dw WaterSparkData
	dw DummyObjectData
	dw SpearBotData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/water_spark.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_Shared25:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw WebberGfx
	dw BubbleGfx
	dw OctohonGfx

	dw HaridamaData
	dw DummyObjectData
	dw BubbleHoleData
	dw SmallOctohonData
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/bubble.pal"
INCLUDE "gfx/pals/octohon.pal"

ObjectGroup_Shared26:
	db $00 ; GFX bank offset

	dw HaridamaGfx
	dw WebberGfx
	dw BubbleGfx
	dw OctohonGfx

	dw HaridamaData
	dw DummyObjectData
	dw BubbleHoleData
	dw BigOctohonData
	dw NULL

INCLUDE "gfx/pals/haridama.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/bubble.pal"
INCLUDE "gfx/pals/octohon.pal"

ObjectGroup_TheSteepCanyon1:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw WebberGfx
	dw HandGfx
	dw FireBotGfx

	dw GreyPrinceFroggyData
	dw DummyObjectData
	dw HandData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hand2.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheSteepCanyon2:
	db $00 ; GFX bank offset

	dw OwlGfx
	dw WebberGfx
	dw FutamoguGfx
	dw SparkGfx

	dw OwlData
	dw DummyObjectData
	dw DummyObjectData
	dw SparkHorizontalData
	dw SparkVerticalData
	dw NULL

INCLUDE "gfx/pals/owl.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/spark.pal"

ObjectGroup_TheFrigidSea1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw RockGfx
	dw BrrrBearGfx

	dw DummyObjectData
	dw DummyObjectData
	dw RockData
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/rock.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_Shared28:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw FallingSnowGfx

	dw SpearheadData
	dw DummyObjectData
	dw DummyObjectData
	dw FallingSnowSpawnerData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/falling_snow.pal"

ObjectGroup_TheWestCrater1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ApplebyGfx
	dw ClearGate2Gfx
	dw BarrelGfx

	dw DummyObjectData
	dw ApplebyData
	dw ClearGate2Data
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheGrasslands6:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw ApplebyGfx
	dw FutamoguGfx
	dw BarrelGfx

	dw SilkyData
	dw ApplebyData
	dw DummyObjectData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheGrasslands4:
	db $00 ; GFX bank offset

	dw StoveGfx
	dw HammerBotGfx
	dw FutamoguGfx
	dw TorchGfx

	dw StoveData
	dw HammerBotData
	dw NULL

INCLUDE "gfx/pals/stove.pal"
INCLUDE "gfx/pals/hammer_bot.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_Shared29:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw HammerBotGfx
	dw FireGfx
	dw FireBotGfx

	dw SpearheadData
	dw HammerBotData
	dw FireData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/hammer_bot.pal"
INCLUDE "gfx/pals/fire.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheStagnantSwamp4:
	db $04 ; GFX bank offset

	dw Jamano1Gfx
	dw Jamano2Gfx
	dw Jamano3Gfx
	dw Jamano4Gfx

	dw JamanoData
	dw SkullSpawnerData
	dw HatPlatformData
	dw NULL

INCLUDE "gfx/pals/jamano.pal"

ObjectGroup_Shared30:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw OmodonGfx
	dw OmodonmekaGfx

	dw SpearheadData
	dw DummyObjectData
	dw OmodonmekaWithOmodon1Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/webber1.pal"
INCLUDE "gfx/pals/omodon.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_TheColossalHole2:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw WebberGfx
	dw FutamoguGfx
	dw FireBotGfx

	dw SnakeData
	dw DummyObjectData
	dw DummyObjectData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_Shared31:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw HebariiGfx
	dw BarrelGfx

	dw DummyObjectData
	dw DummyObjectData
	dw HebariiData
	dw Barrel1Data
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheStagnantSwamp2:
	db $04 ; GFX bank offset

	dw Muddee1Gfx
	dw Muddee2Gfx
	dw Muddee3Gfx
	dw Muddee4Gfx

	dw MuddeeData
	dw Turtle1Data
	dw Turtle2Data
	dw NULL

INCLUDE "gfx/pals/muddee.pal"

ObjectGroup_ThePoolOfRain3:
	db $04 ; GFX bank offset

	dw Wolfenboss1Gfx
	dw Wolfenboss2Gfx
	dw Wolfenboss3Gfx
	dw Wolfenboss4Gfx

	dw WolfenbossData
	dw WolfenbossPlatformData
	dw NULL

INCLUDE "gfx/pals/wolfenboss.pal"

ObjectGroup_TheWarpedVoid2:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw CountRichtertoffenGfx
	dw FutamoguGfx
	dw BarrelGfx

	dw DummyObjectData
	dw CountRichtertoffenData
	dw DummyObjectData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/count_richtertoffen.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_TheWarpedVoid1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ApplebyGfx
	dw OmodonGfx
	dw OmodonmekaGfx

	dw DummyObjectData
	dw ApplebyData
	dw OmodonmekaWithOmodon1Data
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/omodon.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_TheGrasslands1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw HebariiGfx
	dw NobiiruGfx

	dw DummyObjectData
	dw OrangeBirdData
	dw HebariiData
	dw NobiiruLeftData
	dw NobiiruRightData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/orange_bird.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/nobiiru.pal"

ObjectGroup_Shared32:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw FutamoguGfx
	dw TorchGfx

	dw SpearheadData
	dw BlueBirdData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_OutOfTheWoods5:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw BirdGfx
	dw DoughnuteerGfx
	dw TorchGfx

	dw SilkyData
	dw BlueBirdData
	dw DoughnuteerData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TowerOfRevival2:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw WebberGfx
	dw FutamoguGfx
	dw BrrrBearGfx

	dw SilkyData
	dw DummyObjectData
	dw DummyObjectData
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_CastleOfIllusions1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw ZombieGfx
	dw BrrrBearGfx

	dw DummyObjectData
	dw DummyObjectData
	dw ZombieData
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_ATownInChaos5:
	db $04 ; GFX bank offset

	dw Shoot1Gfx
	dw Shoot2Gfx
	dw Shoot3Gfx
	dw Shoot4Gfx

	dw ShootData
	dw GKTortoiseData
	dw ShootGoalCounterData
	dw WarioGoalCounterData
	dw GKTortoisePlatformData
	dw NULL

INCLUDE "gfx/pals/shoot.pal"

ObjectGroup_TowerOfRevival4:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ApplebyGfx
	dw FutamoguGfx
	dw SparkGfx

	dw DummyObjectData
	dw ApplebyData
	dw DummyObjectData
	dw SparkHorizontalData
	dw SparkVerticalData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/appleby.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/spark.pal"

ObjectGroup_CaveOfFlames4:
	db $00 ; GFX bank offset

	dw MadSciensteinGfx
	dw WebberGfx
	dw TadpoleGfx
	dw BrrrBearGfx

	dw MadSciensteinData
	dw DummyObjectData
	dw TadpoleSpawnerData
	dw BrrrBearData
	dw SeeingEyeDoorData
	dw NULL

INCLUDE "gfx/pals/mad_scienstein.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/tadpole.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_ATownInChaos1:
	db $00 ; GFX bank offset

	dw SilkyGfx
	dw WebberGfx
	dw HebariiGfx
	dw FireBotGfx

	dw SilkyData
	dw DummyObjectData
	dw HebariiData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/silky.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheBigBridge5:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw TorchGfx

	dw SpearheadData
	dw WebberData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/webber2.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_TheBigBridge3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw ClearGate2Gfx
	dw BrrrBearGfx

	dw SpearheadData
	dw DummyObjectData
	dw ClearGate2Data
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/clear_gate.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_AboveTheClouds1:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw FutamoguGfx
	dw SparkGfx

	dw DummyObjectData
	dw BlueBirdData
	dw DummyObjectData
	dw SparkHorizontalData
	dw SparkVerticalData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/spark.pal"

ObjectGroup_Shared34:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw BirdGfx
	dw ZombieGfx
	dw ClearGate3Gfx

	dw GreyPrinceFroggyData
	dw BlueBirdData
	dw ZombieData
	dw ClearGate3Data
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/zombie.pal"
INCLUDE "gfx/pals/clear_gate.pal"

ObjectGroup_AboveTheClouds3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw RockGfx
	dw TogebaGfx

	dw DummyObjectData
	dw DummyObjectData
	dw RockData
	dw TogebaData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/rock.pal"
INCLUDE "gfx/pals/togeba.pal"

ObjectGroup_AboveTheClouds5:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw BirdGfx
	dw FutamoguGfx
	dw BarrelGfx

	dw DummyObjectData
	dw BlueBirdData
	dw DummyObjectData
	dw Barrel1Data
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/blue_bird.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_AboveTheClouds4:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw BeamBotGfx

	dw DummyObjectData
	dw DummyObjectData
	dw DummyObjectData
	dw BeamBotData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/beam_bot.pal"

ObjectGroup_TheColossalHole6:
	db $00 ; GFX bank offset

	dw Moon1Gfx
	dw Moon2Gfx
	dw SpearBotGfx
	dw FireBotGfx

	dw MoonData
	dw DummyObjectData
	dw SpearBotData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/moon.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_BeneathTheWaves5:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw HebariiGfx
	dw BrrrBearGfx

	dw DummyObjectData
	dw ParaGoomData
	dw HebariiData
	dw BrrrBearData
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/brrr_bear.pal"

ObjectGroup_CaveOfFlames3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw DoughnuteerGfx
	dw TogebaGfx

	dw SpearheadData
	dw ParaGoomData
	dw DoughnuteerData
	dw TogebaData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/doughnuteer.pal"
INCLUDE "gfx/pals/togeba.pal"

ObjectGroup_CaveOfFlames2:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw SpearBotGfx
	dw OmodonmekaGfx

	dw DummyObjectData
	dw DummyObjectData
	dw SpearBotData
	dw OmodonmekaData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/spear_bot.pal"
INCLUDE "gfx/pals/omodonmeka.pal"

ObjectGroup_TheWestCrater3:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw HammerBotGfx
	dw FutamoguGfx
	dw FireBotGfx

	dw SpearheadData
	dw HammerBotData
	dw DummyObjectData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/hammer_bot.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheEastCrater5:
	db $00 ; GFX bank offset

	dw SnakeGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw FireBotGfx

	dw SnakeData
	dw ParaGoomData
	dw DummyObjectData
	dw FireBotData
	dw NULL

INCLUDE "gfx/pals/snake.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/fire_bot.pal"

ObjectGroup_TheEastCrater6:
	db $00 ; GFX bank offset

	dw PrinceFroggyGfx
	dw PneumoGfx
	dw WallCrackGfx
	dw BarrelGfx

	dw GreyPrinceFroggyData
	dw PneumoData
	dw WallCrackOpenData
	dw Barrel2Data
	dw NULL

INCLUDE "gfx/pals/prince_froggy2.pal"
INCLUDE "gfx/pals/pneumo.pal"
INCLUDE "gfx/pals/wall_crack.pal"
INCLUDE "gfx/pals/barrel.pal"

ObjectGroup_BankOfTheWildRiver4:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw RockGfx
	dw TorchGfx

	dw DummyObjectData
	dw DummyObjectData
	dw RockData
	dw TorchData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/rock.pal"
INCLUDE "gfx/pals/torch.pal"

ObjectGroup_CastleOfIllusions4:
	db $00 ; GFX bank offset

	dw StoveGfx
	dw WebberGfx
	dw HebariiGfx
	dw TorchGfx

	dw StoveData
	dw DummyObjectData
	dw HebariiData
	dw NULL

INCLUDE "gfx/pals/stove.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_CastleOfIllusions6:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw HebariiGfx
	dw TorchGfx

	dw SpearheadData
	dw DummyObjectData
	dw HebariiData
	dw NULL

INCLUDE "gfx/pals/spearhead.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/hebarii.pal"
INCLUDE "gfx/pals/dummy.pal"

ObjectGroup_BeneathTheWaves2:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw WebberGfx
	dw FutamoguGfx
	dw TeruteruGfx

	dw DummyObjectData
	dw DummyObjectData
	dw DummyObjectData
	dw TeruteruData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/teruteru.pal"

ObjectGroup_ATownInChaos4:
	db $00 ; GFX bank offset

	dw SpearheadGfx
	dw ParaGoomGfx
	dw FutamoguGfx
	dw TorchGfx

	dw DummyObjectData
	dw ParaGoomData
	dw NULL

INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/para_goom.pal"
INCLUDE "gfx/pals/dummy.pal"
INCLUDE "gfx/pals/dummy.pal"
