; \1 ID constant
; \2 OAM ptr
; \3 interaction type
; \4 collision box top
; \5 update function
; \6 object flags
MACRO object_data
assert (BANK(\2) - BANK("Objects OAM 1")) | (BANK(\5) - BANK("Object Functions 1")) == (BANK(\5) - BANK("Object Functions 1"))
assert ({\1} >> 4) & %111 == (BANK(\2) - BANK("Objects OAM 1"))
	db \1
	db \3, \4
	dw \2
	dw \5
	db \6
ENDM

DummyObjectData:           object_data DUMMY_OBJECT,            SpearheadOAM_18007b, OBJ_INTERACTION_00,                           0, DummyObjectFunc,           $0
GreyChestData:             object_data GREY_CHEST,              OAM_18c000, OBJ_INTERACTION_GREY_TREASURE  | HEAVY_OBJ, -24, GreyChestFunc,             $0
RedChestData:              object_data RED_CHEST,               OAM_18c000, OBJ_INTERACTION_RED_TREASURE   | HEAVY_OBJ, -24, RedChestFunc,              $0
GreenChestData:            object_data GREEN_CHEST,             OAM_18c000, OBJ_INTERACTION_GREEN_TREASURE | HEAVY_OBJ, -24, GreenChestFunc,            $0
BlueChestData:             object_data BLUE_CHEST,              OAM_18c000, OBJ_INTERACTION_BLUE_TREASURE  | HEAVY_OBJ, -24, BlueChestFunc,             $0
GreyKeyData:               object_data GREY_KEY_O,              OAM_18c000, OBJ_INTERACTION_GREY_KEY,                   -24, KeyFunc,                   $0
RedKeyData:                object_data RED_KEY_O,               OAM_18c000, OBJ_INTERACTION_RED_KEY,                    -24, KeyFunc,                   $0
GreenKeyData:              object_data GREEN_KEY_O,             OAM_18c000, OBJ_INTERACTION_GREEN_KEY,                  -24, KeyFunc,                   $0
BlueKeyData:               object_data BLUE_KEY_O,              OAM_18c000, OBJ_INTERACTION_BLUE_KEY,                   -24, KeyFunc,                   $0
MusicalCoinData:           object_data MUSICAL_COIN,            OAM_18c000, OBJ_INTERACTION_MUSICAL_COIN,               -25, MusicalCoinFunc,           $0
SpearheadData:             object_data SPEARHEAD,               SpearheadOAM_18007b, OBJ_INTERACTION_01,                         -14, SpearheadFunc,             OBJFLAG_PRIORITY
FutamoguData:              object_data FUTAMOGU,                FutamoguOAM_180564, OBJ_INTERACTION_WALKABLE       | HEAVY_OBJ, -17, FutamoguFunc,              OBJFLAG_PRIORITY
WebberData:                object_data WEBBER,                  WebberOAM_180242, OBJ_INTERACTION_WALKABLE       | HEAVY_OBJ, -16, WebberFunc,                OBJFLAG_PRIORITY
TorchData:                 object_data TORCH,                   TorchOAM_180838, OBJ_INTERACTION_FIRE,                       -16, TorchFunc,                 $0
TorchNoEmbersData:         object_data TORCH_NO_EMBERS,         TorchOAM_180838, OBJ_INTERACTION_FIRE,                       -16, TorchNoEmbersFunc,         $0
FlameBlockTorchData:       object_data FLAME_BLOCK_TORCH,       TorchOAM_180838, OBJ_INTERACTION_UNLIT_TORCH,                -16, FlameBlockTorchFunc,       $0
FlameBlockData:            object_data FLAME_BLOCK,             FlameBlockOAM_1895ec, OBJ_INTERACTION_SOLID,                      -30, FlameBlockFunc,            $0
StoveData:                 object_data STOVE,                   StoveOAM_1896e1, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -32, StoveFunc,                 $0
UnusedFlowerData:          object_data UNUSED_FLOWER,           UnusedFlowerOAM_180916, OBJ_INTERACTION_01,                           0, UnusedFlowerFunc,          $0
CountRichtertoffenData:    object_data COUNT_RICHTERTOFFEN,     CountRichtertoffenOAM_1809ff, OBJ_INTERACTION_RICHTERTOFFEN  | HEAVY_OBJ, -18, CountRichtertoffenFunc,    OBJFLAG_PRIORITY
HebariiData:               object_data HEBARII,                 HebariiOAM_18a703, OBJ_INTERACTION_HEBARII,                    -15, HebariiFunc,               $0
ParaGoomData:              object_data PARA_GOOM,               ParaGoomOAM_180b43, OBJ_INTERACTION_01,                         -12, ParaGoomFunc,              OBJFLAG_PRIORITY
DoughnuteerData:           object_data DOUGHNUTEER,             DoughnuteerOAM_180ea7, OBJ_INTERACTION_0B,                         -14, DoughnuteerFunc,           OBJFLAG_PRIORITY
OmodonmekaData:            object_data OMODONMEKA,              OmodonmekaOAM_18136c, OBJ_INTERACTION_01,                         -25, OmodonmekaFunc,            OBJFLAG_PRIORITY
OmodonmekaWithOmodon1Data: object_data OMODONMEKA_WITH_OMODON1, OmodonmekaOAM_181189, OBJ_INTERACTION_01,                         -25, OmodonmekaWithOmodon1Func, OBJFLAG_PRIORITY
OmodonmekaWithOmodon2Data: object_data OMODONMEKA_WITH_OMODON2, OmodonmekaOAM_181189, OBJ_INTERACTION_01,                         -25, OmodonmekaWithOmodon2Func, OBJFLAG_PRIORITY
KushimushiVerticalData:    object_data KUSHIMUSHI_VERTICAL,     KushimushiOAM_18160c, OBJ_INTERACTION_BOTTOM_STING,               -13, KushimushiVerticalFunc,    $0
KushimushiHorizontalData:  object_data KUSHIMUSHI_HORIZONTAL,   KushimushiOAM_18160c, OBJ_INTERACTION_FRONT_STING,                -12, KushimushiHorizontalFunc,  $0
MizuuoData:                object_data MIZUUO,                  MizuuoOAM_188395, OBJ_INTERACTION_0A,                         -10, MizuuoFunc,                $0
BigLeafSpawnerData:        object_data BIG_LEAF_SPAWNER,        BigLeafOAM_180000, OBJ_INTERACTION_0B,                           0, BigLeafSpawnerFunc,        $0
SmallLeafData:             object_data SMALL_LEAF,              SmallLeafOAM_181be4, OBJ_INTERACTION_WALKABLE,                   -17, SmallLeafFunc,             $0
SilkyData:                 object_data SILKY,                   SilkyOAM_18181e, OBJ_INTERACTION_01,                          -8, SilkyFunc,                 OBJFLAG_PRIORITY
OrangeBirdData:            object_data ORANGE_BIRD,             BirdOAM_1819e3, OBJ_INTERACTION_ORANGE_BIRD,                -13, BirdFunc,                  OBJFLAG_PRIORITY
BlueBirdData:              object_data BLUE_BIRD,               BirdOAM_1819e3, OBJ_INTERACTION_FRONT_STING,                -13, BirdFunc,                  OBJFLAG_PRIORITY
SnakeData:                 object_data SNAKE,                   SnakeOAM_189783, OBJ_INTERACTION_WALKABLE       | HEAVY_OBJ, -31, SnakeFunc,                 $0
ApplebyData:               object_data APPLEBY,                 ApplebyOAM_185a1c, OBJ_INTERACTION_01,                          -6, ApplebyFunc,               $0
Barrel1Data:               object_data BARREL1,                 BarrelOAM_181b0f, OBJ_INTERACTION_31             | HEAVY_OBJ, -15, Barrel1Func,               OBJFLAG_PRIORITY
Barrel2Data:               object_data BARREL2,                 BarrelOAM_181b0f, OBJ_INTERACTION_3B,                         -15, Barrel2Func,               $0
RockData:                  object_data ROCK,                    RockOAM_18ab5c, OBJ_INTERACTION_3B,                         -15, RockFunc,                  $0
RedPrinceFroggyData:       object_data RED_PRINCE_FROGGY,       PrinceFroggyOAM_184000, OBJ_INTERACTION_PRINCE_FROGGY  | HEAVY_OBJ, -16, RedPrinceFroggyFunc,       OBJFLAG_PRIORITY
GreyPrinceFroggyData:      object_data GREY_PRINCE_FROGGY,      PrinceFroggyOAM_184000, OBJ_INTERACTION_PRINCE_FROGGY  | HEAVY_OBJ, -26, GreyPrinceFroggyFunc,      OBJFLAG_PRIORITY
HammerBotData:             object_data HAMMER_BOT,              HammerBotOAM_18422f, OBJ_INTERACTION_01             | HEAVY_OBJ, -18, HammerBotFunc,             OBJFLAG_PRIORITY
TeruteruData:              object_data TERUTERU,                TeruteruOAM_18496f, OBJ_INTERACTION_01,                         -20, TeruteruFunc,              OBJFLAG_PRIORITY
MadSciensteinData:         object_data MAD_SCIENSTEIN,          OAM_184ab2, OBJ_INTERACTION_01             | HEAVY_OBJ, -18, MadSciensteinFunc,         OBJFLAG_PRIORITY
SeeingEyeDoorData:         object_data SEEING_EYE_DOOR,         OAM_184ab2, OBJ_INTERACTION_SOLID          | HEAVY_OBJ, -24, SeeingEyeDoorFunc,         OBJFLAG_PRIORITY
PneumoData:                object_data PNEUMO,                  PneumoOAM_184db9, OBJ_INTERACTION_PNEUMO,                     -16, PneumoFunc,                OBJFLAG_PRIORITY
ElectricLampData:          object_data ELECTRIC_LAMP,           ElectricLampOAM_184eeb, OBJ_INTERACTION_0B,                           0, ElectricLampFunc,          $0
ZombieData:                object_data ZOMBIE,                  ZombieOAM_184ffa, OBJ_INTERACTION_0B             | HEAVY_OBJ,  -6, ZombieFunc,                OBJFLAG_PRIORITY
FireBotData:               object_data FIRE_BOT,                FireBotOAM_184755, OBJ_INTERACTION_0B,                         -14, FireBotFunc,               OBJFLAG_PRIORITY
SpearBotData:              object_data SPEAR_BOT,               SpearBotOAM_18440a, OBJ_INTERACTION_01,                         -14, SpearBotFunc,              OBJFLAG_PRIORITY
BeamBotData:               object_data BEAM_BOT,                BeamBotOAM_1845aa, OBJ_INTERACTION_01,                         -14, BeamBotFunc,               OBJFLAG_PRIORITY
SunData:                   object_data SUN,                     SunMoonOAM_1851df, OBJ_INTERACTION_FIRE,                       -20, SunFunc,                   $0
MoonData:                  object_data MOON,                    SunMoonOAM_1854a2, OBJ_INTERACTION_ELECTRIC,                   -20, MoonFunc,                  $0
KobattoData:               object_data KOBATTO,                 KobattoOAM_185788, OBJ_INTERACTION_VAMPIRE,                    -12, KobattoFunc,               OBJFLAG_PRIORITY
HandData:                  object_data HAND,                    HandOAM_185893, OBJ_INTERACTION_HAND,                       -20, HandFunc,                  OBJFLAG_PRIORITY
BubbleHoleData:            object_data BUBBLE_HOLE,             BubbleOAM_185b98, OBJ_INTERACTION_0B,                           0, BubbleHoleFunc,            $0
BrrrBearData:              object_data BRRR_BEAR,               OAM_188000, OBJ_INTERACTION_ICE            | HEAVY_OBJ, -18, BrrrBearFunc,              OBJFLAG_PRIORITY
CartLeftData:              object_data CART_LEFT,               CartOAM_188279, OBJ_INTERACTION_SOLID,                      -16, CartFunc,                  OBJFLAG_PRIORITY
CartRightData:             object_data CART_RIGHT,              CartOAM_188279, OBJ_INTERACTION_SOLID,                      -16, CartFunc,                  OBJFLAG_PRIORITY
CartVariableLeftData:      object_data CART_VARIABLE_LEFT,      CartOAM_188279, OBJ_INTERACTION_SOLID,                      -16, CartVariableFunc,          OBJFLAG_PRIORITY
CartVariableRightData:     object_data CART_VARIABLE_RIGHT,     CartOAM_188279, OBJ_INTERACTION_SOLID,                      -16, CartVariableFunc,          OBJFLAG_PRIORITY
RoboMouseData:             object_data ROBO_MOUSE,              RoboMouseOAM_188555, OBJ_INTERACTION_ROBO_MOUSE,                 -20, RoboMouseFunc,             OBJFLAG_PRIORITY
TogebaData:                object_data TOGEBA,                  TogebaOAM_188b56, OBJ_INTERACTION_FULL_STING,                  -6, TogebaFunc,                OBJFLAG_PRIORITY
HaridamaData:              object_data HARIDAMA,                HaridamaOAM_188c7a, OBJ_INTERACTION_06,                         -13, HaridamaFunc,              OBJFLAG_PRIORITY
OwlData:                   object_data OWL,                     OwlOAM_188e16, OBJ_INTERACTION_0A,                         -20, OwlFunc,                   OBJFLAG_PRIORITY
ZipLine1Data:              object_data ZIP_LINE1,               ZipLineOAM_18834a, OBJ_INTERACTION_RAIL,                        -7, ZipLineFunc,               OBJFLAG_PRIORITY
ZipLine2Data:              object_data ZIP_LINE2,               ZipLineOAM_18834a, OBJ_INTERACTION_RAIL,                        -7, ZipLineFunc,               OBJFLAG_PRIORITY
ZipLine3Data:              object_data ZIP_LINE3,               ZipLineOAM_18834a, OBJ_INTERACTION_RAIL,                        -7, ZipLineFunc,               OBJFLAG_PRIORITY
ZipLine4Data:              object_data ZIP_LINE4,               ZipLineOAM_18834a, OBJ_INTERACTION_RAIL,                        -7, ZipLineFunc,               OBJFLAG_PRIORITY
ZipLine5Data:              object_data ZIP_LINE5,               ZipLineOAM_18834a, OBJ_INTERACTION_RAIL,                        -7, ZipLineFunc,               OBJFLAG_PRIORITY
AnonsterData:              object_data ANONSTER,                OAM_190000, OBJ_INTERACTION_0B,                         -29, AnonsterFunc,              $0
SilkPlatformsData:         object_data SILK_PLATFORMS,          OAM_190000, OBJ_INTERACTION_0B,                           0, SilkPlatformsFunc,         $0
FallingSnowSpawnerData:    object_data FALLING_SNOW_SPAWNER,    FallingSnowOAM_1893fe, OBJ_INTERACTION_0B,                           0, FallingSnowSpawnerFunc,    $0
DollBoyData:               object_data DOLL_BOY,                DollBoyOAM_19105c, OBJ_INTERACTION_0B             | HEAVY_OBJ, -28, DollBoyFunc,               $0
HammerPlatformSpawnerData: object_data HAMMER_PLATFORM_SPAWNER, DollBoyOAM_19105c, OBJ_INTERACTION_0B,                           0, HammerPlatformSpawnerFunc, $0
DollBoyBarrel1Data:        object_data DOLL_BOY_BARREL1,        DollBoyOAM_19105c, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -31, DollBoyBarrel1Func,        $0
DollBoyBarrel2Data:        object_data DOLL_BOY_BARREL2,        DollBoyOAM_19105c, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -31, DollBoyBarrel2Func,        $0
DollBoyBarrel3Data:        object_data DOLL_BOY_BARREL3,        DollBoyOAM_19105c, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -31, DollBoyBarrel3Func,        $0
WormwouldData:             object_data WORMWOULD,               WormwouldOAM_194000, OBJ_INTERACTION_0B             | HEAVY_OBJ, -26, WormwouldFunc,             $0
PalmTreeSpawnerData:       object_data PALM_TREE_SPAWNER,       WormwouldOAM_194000, OBJ_INTERACTION_0B,                           0, PalmTreeSpawnerFunc,       $0
PillarPlatform1Data:       object_data PILLAR_PLATFORM1,        PillarPlatformOAM_18a5ae, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -16, PillarPlatform1Func,       $0
PillarPlatform2Data:       object_data PILLAR_PLATFORM2,        PillarPlatformOAM_18a5ae, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -16, PillarPlatform2Func,       $0
PillarPlatform3Data:       object_data PILLAR_PLATFORM3,        PillarPlatformOAM_18a5ae, OBJ_INTERACTION_STOVE          | HEAVY_OBJ, -16, PillarPlatform3Func,       $0
WaterDropData:             object_data WATER_DROP,              WaterDropOAM_18a5cc, OBJ_INTERACTION_WATER_DROP,                  -8, WaterDropFunc,             OBJFLAG_PRIORITY
YellowBellyBodyData:       object_data YELLOW_BELLY_BODY,       YellowBellyOAM_19153c, OBJ_INTERACTION_36             | HEAVY_OBJ, -16, YellowBellyBodyFunc,       OBJFLAG_PRIORITY
YellowBellyPlatformData:   object_data YELLOW_BELLY_PLATFORM,   YellowBellyOAM_1926dc, OBJ_INTERACTION_SOLID,                      -17, YellowBellyPlatformFunc,   $0
NobiiruLeftData:           object_data NOBIIRU_LEFT,            NobiiruOAM_181cd3, OBJ_INTERACTION_0B,                         -12, NobiiruFunc,               $0
NobiiruRightData:          object_data NOBIIRU_RIGHT,           NobiiruOAM_181cd3, OBJ_INTERACTION_0B,                         -12, NobiiruFunc,               $0
ClearGate1Data:            object_data CLEAR_GATE1,             ClearGateOAM_181c47, OBJ_INTERACTION_SOLID,                      -31, ClearGate1Func,            $0
ClearGate2Data:            object_data CLEAR_GATE2,             ClearGateOAM_181c47, OBJ_INTERACTION_SOLID,                      -31, ClearGate2Func,            $0
ClearGate3Data:            object_data CLEAR_GATE3,             ClearGateOAM_181c47, OBJ_INTERACTION_SOLID,                      -31, ClearGate3Func,            $0
PesceData:                 object_data PESCE,                   PesceOAM_1927d5, OBJ_INTERACTION_PESCE          | HEAVY_OBJ, -14, PesceFunc,                 OBJFLAG_PRIORITY
DragonflySpawnerData:      object_data DRAGONFLY_SPAWNER,       OAM_190000, OBJ_INTERACTION_0B,                           0, DragonflySpawnerFunc,      $0
FlySpawnerData:            object_data FLY_SPAWNER,             OAM_190000, OBJ_INTERACTION_0B,                           0, FlySpawnerFunc,            $0
StrongWaterCurrentData:    object_data STRONG_WATER_CURRENT,    PesceOAM_1927d5, OBJ_INTERACTION_51             | HEAVY_OBJ, -26, StrongWaterCurrentFunc,    OBJFLAG_PRIORITY
Dragonfly2Data:            object_data DRAGONFLY2,              PesceOAM_1927d5, OBJ_INTERACTION_WALKABLE,                    -9, Dragonfly2Func,            OBJFLAG_PRIORITY
TadpoleSpawnerData:        object_data TADPOLE_SPAWNER,         OAM_188000, OBJ_INTERACTION_0B,                           0, TadpoleSpawnerFunc,        $0
WaterSparkData:            object_data WATER_SPARK,             WaterSparkOAM_18a7fd, OBJ_INTERACTION_YELLOW_BELLY_ARROW,         -13, WaterSparkFunc,            $0
SmallOctohonData:          object_data SMALL_OCTOHON,           OctohonOAM_18a895, OBJ_INTERACTION_06,                           0, SmallOctohonFunc,          OBJFLAG_PRIORITY
BigOctohonData:            object_data BIG_OCTOHON,             OctohonOAM_18a895, OBJ_INTERACTION_06,                          -9, BigOctohonFunc,            $0
SparkHorizontalData:       object_data SPARK_HORIZONTAL,        SparkOAM_18ab04, OBJ_INTERACTION_FULL_STING,                 -11, SparkFunc,                 OBJFLAG_PRIORITY
SparkVerticalData:         object_data SPARK_VERTICAL,          SparkOAM_18ab04, OBJ_INTERACTION_FULL_STING,                 -11, SparkFunc,                 OBJFLAG_PRIORITY
ScowlerData:               object_data SCOWLER,                 ScowlerOAM_194895, OBJ_INTERACTION_SCOWLER        | HEAVY_OBJ, -32, ScowlerFunc,               $0
FloatingRingSpawnerData:   object_data FLOATING_RING_SPAWNER,   ScowlerOAM_194895, OBJ_INTERACTION_0B,                           0, FloatingRingSpawnerFunc,   $0
FireData:                  object_data FIRE,                    FireOAM_18aba0, OBJ_INTERACTION_FIRE,                       -24, FireFunc,                  $0
JamanoData:                object_data JAMANO,                  JamanoOAM_19501c, OBJ_INTERACTION_JAMANO,                     -10, JamanoFunc,                $0
SkullSpawnerData:          object_data SKULL_SPAWNER,           JamanoOAM_19501c, OBJ_INTERACTION_0B,                         -10, SkullSpawnerFunc,          $0
HatPlatformData:           object_data HAT_PLATFORM,            JamanoOAM_19501c, OBJ_INTERACTION_31,                          -4, HatPlatformFunc,           OBJFLAG_PRIORITY
MuddeeData:                object_data MUDDEE,                  MuddeeOAM_195699, OBJ_INTERACTION_0B,                          -8, MuddeeFunc,                $0
Turtle1Data:               object_data TURTLE1,                 MuddeeOAM_195699, OBJ_INTERACTION_TURTLE,                      -2, Turtle1Func,               OBJFLAG_PRIORITY
Turtle2Data:               object_data TURTLE2,                 MuddeeOAM_195699, OBJ_INTERACTION_TURTLE,                      -2, Turtle2Func,               OBJFLAG_PRIORITY
WolfenbossData:            object_data WOLFENBOSS,              WolfenbossOAM_195e06, OBJ_INTERACTION_0B             | HEAVY_OBJ,   0, WolfenbossFunc,            $0
WolfenbossPlatformData:    object_data WOLFENBOSS_PLATFORM,     WolfenbossOAM_195e06, OBJ_INTERACTION_SOLID,                       -1, WolfenbossPlatformFunc,    $0
ShootData:                 object_data SHOOT,                   ShootOAM_196583, OBJ_INTERACTION_0B             | HEAVY_OBJ, -32, ShootFunc,                 $0
GKTortoiseData:            object_data GK_TORTOISE,             ShootOAM_196583, OBJ_INTERACTION_GK_TORTOISE    | HEAVY_OBJ, -20, GKTortoiseFunc,            $0
ShootGoalCounterData:      object_data SHOOT_GOAL_COUNTER,      ShootOAM_196583, OBJ_INTERACTION_0B,                         -32, ShootGoalCounterFunc,      $0
WarioGoalCounterData:      object_data WARIO_GOAL_COUNTER,      ShootOAM_196583, OBJ_INTERACTION_0B,                         -32, WarioGoalCounterFunc,      $0
GKTortoisePlatformData:    object_data GK_TORTOISE_PLATFORM,    ShootOAM_196583, OBJ_INTERACTION_31,                         -10, GKTortoisePlatformFunc,    $0
WallCrackClosedData:       object_data WALL_CRACK_CLOSED,       WallCrackOAM_18c806, OBJ_INTERACTION_0B,                           0, WallCrackClosedFunc,       $0
WallCrackOpenData:         object_data WALL_CRACK_OPEN,         WallCrackOAM_18c806, OBJ_INTERACTION_0B,                           0, WallCrackOpenFunc,         $0
HiddenFigureData:          object_data HIDDEN_FIGURE,           HiddenFigureOAM_18c88a, OBJ_INTERACTION_0B,                           0, HiddenFigureFunc,          $0
RefusedObjectData:         object_data DUMMY_OBJECT,            SpearheadOAM_18007b, OBJ_INTERACTION_00,                           0, RefusedObjectFunc,         $0
