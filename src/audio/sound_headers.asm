MACRO music
	assert (\4) < CHAN5_F, "Invalid channel for music"

	dab \1 ; sound addr
	db \2 ; unknown
	db \3 ; priority
	db \4 ; channel start number
	db \5 ; number of channels used
	db $00 ; padding
ENDM

MACRO sfx
	assert (\4) >= CHAN5_F, "Invalid channel for SFX"

	dab \1 ; sound addr
	db \2 ; unknown
	db \3 ; priority
	db (\4) - CHAN5_F ; channel start number
	db \5 ; number of channels used
	db $00 ; padding
ENDM

MACRO filler_sounds
	REPT \1
		music Music_OutOfTheWoodsDay, $00, 100, CHAN1_F, 4
	ENDR
ENDM

SoundHeaders:
	table_width 8
	music Music_OutOfTheWoodsDay,        $00, 100, CHAN1_F, 4 ; MUSIC_OUT_OF_THE_WOODS_DAY
	music Music_OutOfTheWoodsNight,      $00, 100, CHAN1_F, 3 ; MUSIC_OUT_OF_THE_WOODS_NIGHT
	music Music_ForestOfFear,            $00, 100, CHAN1_F, 2 ; MUSIC_FOREST_OF_FEAR
	music Music_TheWarpedVoid,           $00, 100, CHAN1_F, 3 ; MUSIC_THE_WARPED_VOID
	music Music_DesertRuins,             $00, 100, CHAN1_F, 3 ; MUSIC_DESERT_RUINS
	music Music_TheFrigidSea,            $00, 100, CHAN1_F, 3 ; MUSIC_THE_FRIGID_SEA
	music Music_ThePeacefulVillageDay,   $00, 100, CHAN1_F, 4 ; MUSIC_THE_PEACEFUL_VILLAGE_DAY
	music Music_ThePeacefulVillageNight, $00, 100, CHAN1_F, 3 ; MUSIC_THE_PEACEFUL_VILLAGE_NIGHT
	music Music_AboveTheCloudsDay,       $00, 100, CHAN1_F, 3 ; MUSIC_ABOVE_THE_CLOUDS_DAY
	music Music_AboveTheCloudsNight,     $00, 100, CHAN1_F, 3 ; MUSIC_ABOVE_THE_CLOUDS_NIGHT
	music Music_TheVolcanosBaseDay,      $00, 100, CHAN1_F, 3 ; MUSIC_THE_VOLCANOS_BASE_NIGHT
	music Music_TheVolcanosBaseNight,    $00, 100, CHAN1_F, 3 ; MUSIC_THE_VOLCANOS_BASE_DAY
	music Music_TheWestCrater,           $00, 100, CHAN1_F, 3 ; MUSIC_THE_WEST_CRATER
	music Music_TheVastPlainDay,         $00, 100, CHAN1_F, 4 ; MUSIC_THE_VAST_PLAIN_DAY
	music Music_TheVastPlainNight,       $00, 100, CHAN1_F, 4 ; MUSIC_THE_VAST_PLAIN_NIGHT
	music Music_BankOfTheWildRiver,      $00, 100, CHAN1_F, 4 ; MUSIC_BANK_OF_THE_WILD_RIVER
	music Music_TheTidalCoast,           $00, 100, CHAN1_F, 4 ; MUSIC_THE_TIDAL_COAST
	music Music_CaveOfFlames,            $00, 100, CHAN1_F, 4 ; MUSIC_CAVE_OF_FLAMES
	music Music_ThePoolOfRainDay,        $00, 100, CHAN1_F, 4 ; MUSIC_THE_POOL_OF_RAIN_DAY
	music Music_ThePoolOfRainNight,      $00, 100, CHAN1_F, 4 ; MUSIC_THE_POOL_OF_RAIN_NIGHT
	music Music_Credits,                 $00, 100, CHAN1_F, 4 ; MUSIC_CREDITS
	music Music_HotWario,                $00, 100, CHAN1_F, 3 ; MUSIC_HOT_WARIO
	music Music_FatWario,                $00, 100, CHAN1_F, 3 ; MUSIC_FAT_WARIO
	music Music_BouncyWario,             $00, 100, CHAN1_F, 3 ; MUSIC_BOUNCY_WARIO
	music Music_ZombieWario,             $00, 100, CHAN1_F, 2 ; MUSIC_ZOMBIE_WARIO
	music Music_FlatWario,               $00, 100, CHAN1_F, 3 ; MUSIC_FLAT_WARIO
	music Music_CrazyWario,              $00, 100, CHAN1_F, 3 ; MUSIC_CRAZY_WARIO
	music Music_InvisibleWario,          $00, 100, CHAN1_F, 3 ; MUSIC_INVISIBLE_WARIO
	music Music_SnowmanWario,            $00, 100, CHAN1_F, 3 ; MUSIC_SNOWMAN_WARIO
	music Music_OwlWario,                $00, 100, CHAN1_F, 3 ; MUSIC_OWL_WARIO
	music Music_BallOStringWario,        $00, 100, CHAN1_F, 2 ; MUSIC_BALL_O_STRING_WARIO
	music Music_VampireWario,            $00, 100, CHAN1_F, 3 ; MUSIC_VAMPIRE_WARIO
	music Music_OverworldDay,            $00, 100, CHAN1_F, 4 ; MUSIC_OVERWORLD_DAY
	music Music_OverworldNight,          $00, 100, CHAN1_F, 3 ; MUSIC_OVERWORLD_NIGHT
	music Music_LevelClearNoTreasure,    $00, 100, CHAN1_F, 3 ; MUSIC_LEVEL_CLEAR_NO_TREASURE
	music Music_TreasureFanfare,         $00, 100, CHAN1_F, 4 ; MUSIC_TREASURE_FANFARE
	music Music_PauseMenu,               $00, 100, CHAN1_F, 2 ; MUSIC_PAUSE_MENU
	music Music_Golf,                    $00, 100, CHAN1_F, 3 ; MUSIC_GOLF
	music Music_BossBattle,              $00, 100, CHAN1_F, 4 ; MUSIC_BOSS_BATTLE
	music Music_LevelClearGotTreasure,   $00, 100, CHAN1_F, 4 ; MUSIC_LEVEL_CLEAR_GOT_TREASURE
	music Music_BossDefeat,              $00, 100, CHAN1_F, 2 ; MUSIC_BOSS_DEFEAT
	music Music_GolfGameOver,            $00, 100, CHAN1_F, 3 ; MUSIC_GOLF_GAME_OVER
	music Music_GolfClear,               $00, 100, CHAN1_F, 4 ; MUSIC_GOLF_CLEAR
	music Music_MusicBoxes,              $00, 100, CHAN1_F, 3 ; MUSIC_MUSIC_BOXES
	music Music_BossReveal,              $00, 100, CHAN1_F, 2 ; MUSIC_BOSS_REVEAL
	music Music_ActionHelp,              $00, 100, CHAN1_F, 2 ; MUSIC_ACTION_HELP
	music Music_GolfLobby,               $00, 100, CHAN1_F, 4 ; MUSIC_GOLF_LOBBY
	music Music_GameOver,                $00, 100, CHAN1_F, 3 ; MUSIC_GAME_OVER
	music Music_MusicBoxCave,            $00, 100, CHAN1_F, 3 ; MUSIC_MUSIC_BOX_CAVE
	music Music_TheTemple,               $00, 100, CHAN1_F, 2 ; MUSIC_THE_TEMPLE
	music Music_TitleScreen,             $00, 100, CHAN1_F, 4 ; MUSIC_TITLE_SCREEN
	music Music_Intro,                   $00, 100, CHAN1_F, 3 ; MUSIC_INTRO
	music Music_HiddenFigureBattle1,     $00, 100, CHAN1_F, 4 ; MUSIC_HIDDEN_FIGURE_BATTLE_1
	music Music_Perfect,                 $00, 100, CHAN1_F, 4 ; MUSIC_PERFECT
	music Music_TreasureCollection,      $00, 100, CHAN1_F, 3 ; MUSIC_TREASURE_COLLECTION
	music Music_Epilogue,                $00, 100, CHAN1_F, 3 ; MUSIC_EPILOGUE
	music Music_HiddenFigureReveal,      $00, 100, CHAN1_F, 3 ; MUSIC_HIDDEN_FIGURE_REVEAL
	music Music_HiddenFigureBattle2,     $00, 100, CHAN1_F, 4 ; MUSIC_HIDDEN_FIGURE_BATTLE_2
	assert_table_length NUM_MUSICS

	filler_sounds 198

	sfx Sfx_Jump,                        $00, 220, CHAN5_F, 1 ; SFX_JUMP
	sfx Sfx_GroundShake,                 $00, 237, CHAN8_F, 1 ; SFX_GROUND_SHAKE
	sfx Sfx_Bump,                        $00, 236, CHAN5_F, 1 ; SFX_BUMP
	sfx Sfx_Walk,                        $00, 226, CHAN8_F, 1 ; SFX_WALK
	sfx Sfx_BlockBreak,                  $00, 236, CHAN8_F, 1 ; SFX_BLOCK_BREAK
	sfx Sfx_PlaneDebrisLand,                         $00, 236, CHAN8_F, 1 ; SFX_PLANE_DEBRIS_LAND
	sfx Sfx_Attack,                      $00, 235, CHAN8_F, 1 ; SFX_ATTACK
	sfx Sfx_AttackPoweredUp,             $00, 235, CHAN5_F, 2 ; SFX_ATTACK_POWERED_UP
	sfx Sfx_RegularCoin,                 $00, 235, CHAN5_F, 1 ; SFX_REGULAR_COIN
	sfx Sfx_Roll,                        $00, 230, CHAN5_F, 1 ; SFX_ROLL
	sfx Sfx_ZipLineSlide,                $00, 230, CHAN8_F, 1 ; SFX_ZIP_LINE_SLIDE
	sfx Sfx_Slide,                       $00, 237, CHAN5_F, 1 ; SFX_SLIDE
	sfx Sfx_Splash,                      $00, 235, CHAN5_F, 2 ; SFX_SPLASH
	sfx Sfx_Swim,                         $00, 228, CHAN5_F, 1 ; SFX_SWIM
	sfx Sfx_UnderwaterThrust,                         $00, 210, CHAN5_F, 1 ; SFX_UNDERWATER_THRUST
	sfx Sfx_Land,                        $00, 228, CHAN8_F, 1 ; SFX_LAND
	sfx Sfx_Tiptoe1,                         $00, 200, CHAN5_F, 1 ; SFX_TIPTOE_1
	sfx Sfx_Recovery,                    $00, 255, CHAN5_F, 1 ; SFX_RECOVERY
	sfx Sfx_Sting,                       $00, 237, CHAN7_F, 1 ; SFX_STING
	sfx Sfx_Stomp,                         $00, 239, CHAN5_F, 1 ; SFX_STOMP
	sfx Sfx_Grab,                        $00, 210, CHAN5_F, 1 ; SFX_GRAB
	sfx Sfx_ThrownObjectHit,                         $00, 239, CHAN5_F, 1 ; SFX_THROWN_OBJECT_HIT
	sfx Sfx_AttackHit,                         $00, 238, CHAN5_F, 2 ; SFX_ATTACK_HIT
	sfx Sfx_018,                         $00, 230, CHAN8_F, 1 ; SFX_VANISH
	sfx Sfx_019,                         $00, 236, CHAN5_F, 1 ; SFX_THROW
	sfx Sfx_ObjectHitWall,                         $00, 239, CHAN7_F, 1 ; SFX_OBJECT_HIT_WALL
	sfx Sfx_Flatten,                         $00, 220, CHAN5_F, 2 ; SFX_FLATTEN
	sfx Sfx_FlatWalk,                    $00, 200, CHAN5_F, 1 ; SFX_FLAT_WALK
	sfx Sfx_FlatJump,                         $00, 220, CHAN5_F, 1 ; SFX_FLAT_JUMP
	sfx Sfx_Fire,                         $00, 221, CHAN8_F, 1 ; SFX_FIRE
	sfx Sfx_Rumble,                         $00, 228, CHAN8_F, 1 ; SFX_RUMBLE
	sfx Sfx_FlatFall,                         $00, 221, CHAN8_F, 1 ; SFX_FLAT_FALL
	sfx Sfx_HangGrab,                    $00, 220, CHAN8_F, 1 ; SFX_HANG_GRAB
	sfx Sfx_Burnt,                         $00, 229, CHAN5_F, 1 ; SFX_BURNT
	sfx Sfx_BubbleFloat,                         $00, 220, CHAN5_F, 1 ; SFX_BUBBLE_FLOAT
	sfx Sfx_FatLand,                         $00, 236, CHAN5_F, 1 ; SFX_FAT_LAND
	sfx Sfx_PuffyInflate,                         $00, 240, CHAN5_F, 1 ; SFX_PUFFY_INFLATE
	sfx Sfx_PuffRaise,                   $00, 221, CHAN5_F, 1 ; SFX_PUFF_RAISE
	sfx Sfx_PuffyDeflate,                         $00, 220, CHAN8_F, 1 ; SFX_PUFFY_DEFLATE
	sfx Sfx_ZombieTransform,                         $00, 226, CHAN5_F, 1 ; SFX_ZOMBIE_TRANSFORM
	sfx Sfx_ZombieWalk,                  $00, 226, CHAN8_F, 1 ; SFX_ZOMBIE_WALK
	sfx Sfx_ZombieLand,                         $00, 226, CHAN8_F, 1 ; SFX_ZOMBIE_LAND
	sfx Sfx_BouncyBounce,                         $00, 220, CHAN5_F, 1 ; SFX_BOUNCY_BOUNCE
	sfx Sfx_ThrowCharge,                         $00, 220, CHAN5_F, 1 ; SFX_THROW_CHARGE
	sfx Sfx_FullyChargedThrow,           $00, 220, CHAN5_F, 1 ; SFX_FULLY_CHARGED_THROW
	sfx Sfx_IceSkatinCrash,                         $00, 232, CHAN5_F, 1 ; SFX_ICE_SKATIN_CRASH
	sfx Sfx_Switch,                      $00, 236, CHAN5_F, 1 ; SFX_SWITCH
	sfx Sfx_PipeEnter,                   $00, 220, CHAN5_F, 1 ; SFX_PIPE_ENTER
	sfx Sfx_MusicalCoin,                 $00, 255, CHAN5_F, 2 ; SFX_MUSICAL_COIN
	sfx Sfx_Key,                         $00, 255, CHAN5_F, 2 ; SFX_KEY
	sfx Sfx_GroundPound,                 $00, 237, CHAN5_F, 1 ; SFX_GROUND_POUND
	sfx Sfx_ShootKickWario,                         $00, 237, CHAN5_F, 2 ; SFX_SHOOT_KICK_WARIO
	sfx Sfx_ChestOpen,                         $00, 221, CHAN8_F, 1 ; SFX_CHEST_OPEN
	sfx Sfx_Sleep,                       $00, 228, CHAN8_F, 1 ; SFX_SLEEP
	sfx Sfx_WaterSurface,                $00, 220, CHAN5_F, 1 ; SFX_WATER_SURFACE
	sfx Sfx_Climb,                       $00, 220, CHAN5_F, 2 ; SFX_CLIMB
	sfx Sfx_BallOStringTransform,                         $00, 220, CHAN5_F, 1 ; SFX_BALL_O_STRING_TRANSFORM
	sfx Sfx_EatFood,                         $00, 220, CHAN5_F, 1 ; SFX_EAT_FOOD
	sfx Sfx_FatWalk,                     $00, 230, CHAN5_F, 1 ; SFX_FAT_WALK
	sfx Sfx_BallOStringBounce,                         $00, 220, CHAN5_F, 1 ; SFX_BALL_O_STRING_BOUNCE
	sfx Sfx_StringUnwrap,                         $00, 220, CHAN5_F, 1 ; SFX_STRING_UNWRAP
	sfx Sfx_GetTreasureOpen,                         $00, 220, CHAN5_F, 1 ; SFX_GET_TREASURE_OPEN
	sfx Sfx_InvisibleTransform,                         $00, 220, CHAN5_F, 2 ; SFX_INVISIBLE_TRANSFORM
	sfx Sfx_ElectricShock,                         $00, 236, CHAN8_F, 1 ; SFX_ELECTRIC_SHOCK
	sfx Sfx_ElectricLand,                         $00, 220, CHAN5_F, 1 ; SFX_ELECTRIC_LAND
	sfx Sfx_CrazySpin,                         $00, 220, CHAN5_F, 1 ; SFX_CRAZY_SPIN
	sfx Sfx_CrazyDizzy,                         $00, 220, CHAN5_F, 1 ; SFX_CRAZY_DIZZY
	sfx Sfx_SplitLand,                         $00, 220, CHAN8_F, 1 ; SFX_SPLIT_LAND
	sfx Sfx_VampireTransform,                         $00, 220, CHAN5_F, 3 ; SFX_VAMPIRE_TRANSFORM
	sfx Sfx_BatTransform,                         $00, 220, CHAN5_F, 3 ; SFX_BAT_TRANSFORM
	sfx Sfx_SnowmanTransform,                         $00, 220, CHAN5_F, 1 ; SFX_SNOWMAN_TRANSFORM
	sfx Sfx_LaunchCrash,                         $00, 239, CHAN5_F, 2 ; SFX_LAUNCH_CRASH
	sfx Sfx_HammerHit,                         $00, 220, CHAN5_F, 1 ; SFX_HAMMER_HIT
	sfx Sfx_CrouchWalk,                  $00, 200, CHAN5_F, 1 ; SFX_CROUCH_WALK
	sfx Sfx_ColourCoin,                  $00, 240, CHAN5_F, 1 ; SFX_COLOUR_COIN
	sfx Sfx_Launched,                         $00, 239, CHAN5_F, 2 ; SFX_LAUNCHED
	filler_sounds 20

	sfx Sfx_Earthquake,                         $00, 239, CHAN8_F, 1 ; SFX_EARTHQUAKE
	sfx Sfx_Click,                       $00, 237, CHAN8_F, 1 ; SFX_CLICK
	sfx Sfx_Slam,                         $00, 239, CHAN8_F, 1 ; SFX_SLAM
	sfx Sfx_Zombie,                         $00, 220, CHAN5_F, 1 ; SFX_ZOMBIE
	sfx Sfx_GolfBunker,                         $00, 221, CHAN8_F, 1 ; SFX_GOLF_BUNKER
	sfx Sfx_BallBounce,                         $00, 220, CHAN5_F, 1 ; SFX_BALL_BOUNCE
	sfx Sfx_EnemyThrow,                         $00, 220, CHAN5_F, 1 ; SFX_ENEMY_THROW
	sfx Sfx_SunShoot,                         $00, 220, CHAN8_F, 1 ; SFX_SUN_SHOOT
	sfx Sfx_BubbleSpawn,                         $00, 220, CHAN5_F, 1 ; SFX_BUBBLE_SPAWN
	sfx Sfx_Whirr,                         $00, 220, CHAN5_F, 1 ; SFX_WHIRR
	sfx Sfx_ElectricLampDischarge,                         $00, 220, CHAN5_F, 1 ; SFX_ELECTRIC_LAMP_DISCHARGE
	sfx Sfx_ElectricSpark,                         $00, 220, CHAN5_F, 1 ; SFX_ELECTRIC_SPARK
	sfx Sfx_CartRoll,                         $00, 220, CHAN8_F, 1 ; SFX_CART_ROLL
	sfx Sfx_MoonShoot,                         $00, 220, CHAN8_F, 1 ; SFX_MOON_SHOOT
	sfx Sfx_BirdAlert,                         $00, 220, CHAN5_F, 1 ; SFX_BIRD_ALERT
	sfx Sfx_BirdTakeOff,                         $00, 220, CHAN5_F, 1 ; SFX_BIRD_TAKE_OFF
	sfx Sfx_Flap,                        $00, 220, CHAN8_F, 1 ; SFX_FLAP
	sfx Sfx_BubblePop,                         $00, 220, CHAN8_F, 1 ; SFX_BUBBLE_POP
	sfx Sfx_Flame,                         $00, 227, CHAN8_F, 1 ; SFX_FLAME
	sfx Sfx_ZombieRise,                         $00, 221, CHAN5_F, 1 ; SFX_ZOMBIE_RISE
	sfx Sfx_HeavyStep,                         $00, 220, CHAN5_F, 1 ; SFX_HEAVY_STEP
	sfx Sfx_Thunder,                         $00, 235, CHAN8_F, 1 ; SFX_THUNDER
	sfx Sfx_OwlHoot,                     $00, 220, CHAN7_F, 1 ; SFX_OWL_HOOT
	sfx Sfx_StoveRattle,                         $00, 240, CHAN8_F, 1 ; SFX_STOVE_RATTLE
	sfx Sfx_NobiiruExtend,                         $00, 227, CHAN8_F, 1 ; SFX_NOBIIRU_EXTEND
	sfx Sfx_SeeingEyeDoorLook,                         $00, 227, CHAN8_F, 1 ; SFX_SEEING_EYE_DOOR_LOOK
	sfx Sfx_SeeingEyeDoor,                         $00, 227, CHAN8_F, 1 ; SFX_SEEING_EYE_DOOR
	sfx Sfx_Beam,                         $00, 220, CHAN5_F, 2 ; SFX_BEAM
	sfx Sfx_FanSpin,                         $00, 221, CHAN8_F, 1 ; SFX_FAN_SPIN
	sfx Sfx_EnemyShoot,                         $00, 239, CHAN5_F, 1 ; SFX_ENEMY_SHOOT
	sfx Sfx_07f,                         $00, 220, CHAN5_F, 1 ; SFX_07F
	sfx Sfx_FallingSnowDrop,                         $00, 220, CHAN8_F, 1 ; SFX_FALLING_SNOW_DROP
	sfx Sfx_HandAppear,                         $00, 227, CHAN5_F, 1 ; SFX_HAND_APPEAR
	sfx Sfx_Teleport,                         $00, 220, CHAN5_F, 2 ; SFX_TELEPORT
	sfx Sfx_SmallSplash,                         $00, 220, CHAN5_F, 2 ; SFX_SMALL_SPLASH
	sfx Sfx_TurtleSwim,                         $00, 220, CHAN5_F, 1 ; SFX_TURTLE_SWIM
	sfx Sfx_MuddeeSwim,                         $00, 220, CHAN7_F, 1 ; SFX_MUDDEE_SWIM
	sfx Sfx_BarrelJump,                         $00, 220, CHAN5_F, 1 ; SFX_BARREL_JUMP
	sfx Sfx_OmodonmekaLift,                         $00, 220, CHAN8_F, 1 ; SFX_OMODONMEKA_LIFT
	sfx Sfx_Omodonmeka,                         $00, 220, CHAN5_F, 2 ; SFX_OMODONMEKA
	sfx Sfx_SnakeSpitFire,                         $00, 227, CHAN8_F, 1 ; SFX_SNAKE_SPIT_FIRE
	sfx Sfx_SnakePrepareFire,                         $00, 227, CHAN5_F, 2 ; SFX_SNAKE_PREPARE_FIRE
	sfx Sfx_SnakeSink,                         $00, 220, CHAN5_F, 1 ; SFX_SNAKE_SINK
	sfx Sfx_RailHum,                         $00, 227, CHAN8_F, 1 ; SFX_RAIL_HUM
	sfx Sfx_BigOcto1,                         $00, 220, CHAN5_F, 1 ; SFX_BIG_OCTO_1
	sfx Sfx_Sparkle,                         $00, 239, CHAN5_F, 1 ; SFX_SPARKLE
	sfx Sfx_BigOcto2,                         $00, 220, CHAN8_F, 1 ; SFX_BIG_OCTO_2
	filler_sounds 17

	sfx Sfx_WaterDrop,                         $00, 234, CHAN8_F, 1 ; SFX_WATER_DROP
	sfx Sfx_DollBoy,                         $00, 234, CHAN5_F, 2 ; SFX_DOLL_BOY
	sfx Sfx_BossDefeatFall,                         $00, 239, CHAN5_F, 1 ; SFX_BOSS_DEFEAT_FALL
	sfx Sfx_DollBoyStunned,                         $00, 239, CHAN7_F, 1 ; SFX_DOLL_BOY_STUNNED
	sfx Sfx_YellowBellySpawnPump,                         $00, 220, CHAN5_F, 1 ; SFX_YELLOW_BELLY_SPAWN_PUMP
	sfx Sfx_WormwouldAttack,                         $00, 220, CHAN7_F, 1 ; SFX_WORMWOULD_ATTACK
	sfx Sfx_WormwouldHurt,                         $00, 239, CHAN7_F, 1 ; SFX_WORMWOULD_HURT
	sfx Sfx_YellowBelly,                         $00, 239, CHAN5_F, 2 ; SFX_YELLOW_BELLY
	sfx Sfx_BossDefeated,                         $00, 239, CHAN7_F, 1 ; SFX_BOSS_DEFEATED
	sfx Sfx_WolfenbossSmoke,                         $00, 239, CHAN5_F, 2 ; SFX_WOLFENBOSS_SMOKE
	sfx Sfx_Scowler,                         $00, 239, CHAN5_F, 1 ; SFX_SCOWLER
	sfx Sfx_ScowlerDefeated,                         $00, 239, CHAN5_F, 1 ; SFX_SCOWLER_DEFEATED
	sfx Sfx_Pesce2,                         $00, 220, CHAN5_F, 1 ; SFX_PESCE_2
	sfx Sfx_Pesce1,                         $00, 220, CHAN5_F, 1 ; SFX_PESCE_1
	sfx Sfx_AnonsterWalk,                         $00, 220, CHAN5_F, 1 ; SFX_ANONSTER_WALK
	sfx Sfx_Anonster1,                         $00, 220, CHAN5_F, 2 ; SFX_ANONSTER_1
	sfx Sfx_Anonster2,                         $00, 239, CHAN5_F, 1 ; SFX_ANONSTER_2
	sfx Sfx_0b2,                         $00, 239, CHAN5_F, 2 ; SFX_0B2
	sfx Sfx_ScowlerStunned,                         $00, 239, CHAN5_F, 1 ; SFX_SCOWLER_STUNNED
	sfx Sfx_ScowlerStomped,                         $00, 239, CHAN5_F, 1 ; SFX_SCOWLER_STOMPED
	sfx Sfx_ScowlerInk1,                         $00, 238, CHAN5_F, 2 ; SFX_SCOWLER_INK_1
	sfx Sfx_ScowlerBlackout,                         $00, 238, CHAN5_F, 2 ; SFX_SCOWLER_BLACKOUT
	sfx Sfx_0b7,                         $00, 239, CHAN5_F, 2 ; SFX_0B7
	sfx Sfx_ScowlerInk2,                         $00, 239, CHAN5_F, 2 ; SFX_SCOWLER_INK_2
	sfx Sfx_Pesce3Yb2,                         $00, 220, CHAN5_F, 1 ; SFX_PESCE_3_YB_2
	sfx Sfx_Pump,                         $00, 220, CHAN5_F, 2 ; SFX_PUMP
	sfx Sfx_PesceHit,                         $00, 220, CHAN5_F, 2 ; SFX_PESCE_HIT
	sfx Sfx_JamanoTurn,                         $00, 239, CHAN5_F, 1 ; SFX_JAMANO_TURN
	sfx Sfx_JamanoDefeatPose,                         $00, 239, CHAN5_F, 1 ; SFX_JAMANO_DEFEAT_POSE
	sfx Sfx_PesceFly,                         $00, 239, CHAN7_F, 1 ; SFX_PESCE_FLY
	sfx Sfx_JamanoSkull,                         $00, 239, CHAN7_F, 1 ; SFX_JAMANO_SKULL
	sfx Sfx_MuddeeHurt,                         $00, 239, CHAN7_F, 1 ; SFX_MUDDEE_HURT
	sfx Sfx_MuddeeBubble,                         $00, 238, CHAN5_F, 2 ; SFX_MUDDEE_BUBBLE
	sfx Sfx_MagicSpiralGrow,                         $00, 230, CHAN5_F, 1 ; SFX_MAGIC_SPIRAL_GROW
	sfx Sfx_WolfenbossHover,                         $00, 219, CHAN5_F, 1 ; SFX_WOLFENBOSS_HOVER
	sfx Sfx_0c4,                         $00, 220, CHAN5_F, 1 ; SFX_0C4
	sfx Sfx_Igaguri,                         $00, 220, CHAN5_F, 1 ; SFX_IGAGURI
	sfx Sfx_ShootTaunt,                         $00, 220, CHAN5_F, 1 ; SFX_SHOOT_TAUNT
	sfx Sfx_ShootGoal,                         $00, 239, CHAN5_F, 2 ; SFX_SHOOT_GOAL
	sfx Sfx_ShootJump,                         $00, 220, CHAN5_F, 1 ; SFX_SHOOT_JUMP
	sfx Sfx_Shoot,                         $00, 220, CHAN5_F, 1 ; SFX_SHOOT
	sfx Sfx_BossAppear,                         $00, 240, CHAN5_F, 2 ; SFX_BOSS_APPEAR
	sfx Sfx_HiddenFigureHand1,                         $00, 239, CHAN8_F, 1 ; SFX_HIDDEN_FIGURE_HAND_1
	sfx Sfx_0cc,                         $00, 220, CHAN5_F, 2 ; SFX_HIDDEN_FIGURE_LAUGH
	sfx Sfx_HiddenFigureGrab,                         $00, 220, CHAN5_F, 3 ; SFX_0CD
	sfx Sfx_HiddenFigureHit,                         $00, 240, CHAN5_F, 2 ; SFX_HIDDEN_FIGURE_HIT
	sfx Sfx_HiddenFigureDefeated,                         $00, 220, CHAN5_F, 2 ; SFX_HIDDEN_FIGURE_DEFEATED
	sfx Sfx_HiddenFigureHand2,                         $00, 239, CHAN5_F, 1 ; SFX_HIDDEN_FIGURE_HAND_2
	sfx Sfx_HiddenFigureHand3,                         $00, 239, CHAN5_F, 2 ; SFX_HIDDEN_FIGURE_HAND_3
	filler_sounds 15

	sfx Sfx_PipeExit,                    $00, 255, CHAN5_F, 1 ; SFX_PIPE_EXIT
	sfx Sfx_MenuScroll,                         $00, 220, CHAN5_F, 1 ; SFX_MENU_SCROLL
	sfx Sfx_Selection,                   $00, 220, CHAN5_F, 1 ; SFX_SELECTION
	sfx Sfx_Pause,                         $00, 251, CHAN5_F, 1 ; SFX_PAUSE
	sfx Sfx_Error,                         $00, 230, CHAN5_F, 2 ; SFX_ERROR
	sfx Sfx_EnterDoor,                         $00, 227, CHAN6_F, 1 ; SFX_ENTER_DOOR
	sfx Sfx_MenuCancel,                         $00, 220, CHAN5_F, 1 ; SFX_MENU_CANCEL
	sfx Sfx_GolfMiss,                         $00, 220, CHAN5_F, 1 ; SFX_GOLF_MISS
	sfx Sfx_MenuOpen,                         $00, 220, CHAN5_F, 1 ; SFX_MENU_OPEN
	sfx Sfx_MenuClose,                         $00, 220, CHAN5_F, 1 ; SFX_MENU_CLOSE
	sfx Sfx_PageTurn,                         $00, 220, CHAN5_F, 2 ; SFX_PAGE_TURN
	sfx Sfx_ActionHelpButton,                         $00, 220, CHAN7_F, 1 ; SFX_ACTION_HELP_BUTTON
	sfx Sfx_GolfChargeShot,                         $00, 220, CHAN8_F, 1 ; SFX_GOLF_CHARGE_SHOT
	sfx Sfx_GolfSpecialTerrain2,                         $00, 220, CHAN5_F, 1 ; SFX_GOLF_SPECIAL_TERRAIN_2
	sfx Sfx_GolfHoleIn,                         $00, 237, CHAN5_F, 1 ; SFX_GOLF_HOLE_IN
	sfx Sfx_GolfSpecialTerrain1,                         $00, 220, CHAN5_F, 1 ; SFX_GOLF_SPECIAL_TERRAIN_1
	sfx Sfx_Tiptoe2,                         $00, 237, CHAN5_F, 1 ; SFX_TIPTOE_2
	sfx Sfx_Tiptoe3,                         $00, 220, CHAN5_F, 1 ; SFX_TIPTOE_3
	sfx Sfx_Prologue1,                         $00, 220, CHAN8_F, 1 ; SFX_PROLOGUE_1
	sfx Sfx_Prologue2,                         $00, 220, CHAN5_F, 1 ; SFX_PROLOGUE_2
	sfx Sfx_Snore,                       $00, 220, CHAN8_F, 1 ; SFX_SNORE
	sfx Sfx_Plane1,                      $00, 220, CHAN8_F, 1 ; SFX_PLANE1
	sfx Sfx_Plane2,                      $00, 220, CHAN8_F, 1 ; SFX_PLANE2
	sfx Sfx_Plane3,                      $00, 220, CHAN8_F, 1 ; SFX_PLANE3
	sfx Sfx_PlaneExplosion,              $00, 220, CHAN8_F, 1 ; SFX_PLANE_EXPLOSION
	sfx Sfx_Success,                         $00, 239, CHAN5_F, 3 ; SFX_SUCCESS
	filler_sounds 6

	sfx Sfx_ChopTree,                         $00, 220, CHAN8_F, 1 ; SFX_CHOP_TREE
	sfx Sfx_TreeFall,                         $00, 220, CHAN5_F, 1 ; SFX_TREE_FALL
	sfx Sfx_PathArrow,                         $00, 220, CHAN8_F, 1 ; SFX_PATH_ARROW
	sfx Sfx_LevelStar,                         $00, 220, CHAN5_F, 1 ; SFX_LEVEL_STAR
	sfx Sfx_Gong,                         $00, 220, CHAN5_F, 2 ; SFX_GONG
	sfx Sfx_Emote,                         $00, 237, CHAN7_F, 1 ; SFX_EMOTE
	sfx Sfx_HammerBotWalk,                         $00, 219, CHAN5_F, 1 ; SFX_HAMMER_BOT_WALK
	sfx Sfx_GateOpen,                         $00, 220, CHAN5_F, 1 ; SFX_GATE_OPEN
	sfx Sfx_FixElevator1,                         $00, 220, CHAN5_F, 2 ; SFX_FIX_ELEVATOR_1
	sfx Sfx_FixElevator,                         $00, 220, CHAN8_F, 1 ; SFX_FIX_ELEVATOR
	sfx Sfx_FixElevator2,                         $00, 220, CHAN5_F, 1 ; SFX_FIX_ELEVATOR_2
	sfx Sfx_OpenNorthGate,                         $00, 220, CHAN8_F, 1 ; SFX_OPEN_NORTH_GATE
	sfx Sfx_10d,                         $00, 236, CHAN5_F, 1 ; SFX_TEMPLE_ROCK
	sfx Sfx_10e,                         $00, 220, CHAN5_F, 2 ; SFX_10E
	sfx Sfx_VolcanoEruption1,                         $00, 220, CHAN8_F, 1 ; SFX_VOLCANO_ERUPTION_1
	sfx Sfx_VolcanoEruption2,                         $00, 220, CHAN5_F, 2 ; SFX_VOLCANO_ERUPTION_2
	sfx Sfx_VolcanoEruption3,                         $00, 220, CHAN8_F, 1 ; SFX_VOLCANO_ERUPTION_3
	sfx Sfx_ItemRaise,                         $00, 220, CHAN5_F, 3 ; SFX_ITEM_RAISE
	sfx Sfx_ActionB,                         $00, 220, CHAN5_F, 1 ; SFX_ACTION_B
	sfx Sfx_VolcanoEruption4,                         $00, 220, CHAN8_F, 1 ; SFX_VOLCANO_ERUPTION_4
	sfx Sfx_VolcanoEruption5,                         $00, 220, CHAN8_F, 1 ; SFX_VOLCANO_ERUPTION_5
	sfx Sfx_VolcanoEruption6,                         $00, 220, CHAN8_F, 1 ; SFX_VOLCANO_ERUPTION_6
	sfx Sfx_SummonSnakes,                         $00, 220, CHAN5_F, 2 ; SFX_SUMMON_SNAKES
	sfx Sfx_Flute,                         $00, 220, CHAN5_F, 2 ; SFX_FLUTE
	sfx Sfx_ItemFall,                         $00, 220, CHAN5_F, 1 ; SFX_ITEM_FALL
	sfx Sfx_BeanstalkGrow,                         $00, 220, CHAN5_F, 1 ; SFX_BEANSTALK_GROW
	sfx Sfx_TowerRise,                         $00, 220, CHAN5_F, 2 ; SFX_TOWER_RISE
	sfx Sfx_SeaFreeze,                         $00, 220, CHAN5_F, 1 ; SFX_SEA_FREEZE
	sfx Sfx_Tornado,                         $00, 220, CHAN5_F, 1 ; SFX_TORNADO
	sfx Sfx_YellowMusicBox,                         $00, 220, CHAN5_F, 2 ; SFX_YELLOW_MUSIC_BOX
	sfx Sfx_BlueMusicBox,                         $00, 220, CHAN5_F, 2 ; SFX_BLUE_MUSIC_BOX
	sfx Sfx_GreenMusicBox,                         $00, 220, CHAN5_F, 2 ; SFX_GREEN_MUSIC_BOX
	sfx Sfx_RedMusicBox,                         $00, 220, CHAN5_F, 2 ; SFX_RED_MUSIC_BOX
	sfx Sfx_GoldMusicBox,                         $00, 220, CHAN5_F, 1 ; SFX_GOLD_MUSIC_BOX
	sfx Sfx_BridgeLower,                         $00, 220, CHAN5_F, 1 ; SFX_BRIDGE_LOWER
	sfx Sfx_Lightning,                         $00, 220, CHAN8_F, 1 ; SFX_LIGHTNING
	sfx Sfx_BurnVines1,                         $00, 220, CHAN8_F, 1 ; SFX_BURN_VINES_1
	sfx Sfx_BurnVines2,                         $00, 220, CHAN8_F, 1 ; SFX_BURN_VINES_2
	sfx Sfx_VolcanoEruption,                         $00, 220, CHAN6_F, 2 ; SFX_VOLCANO_ERUPTION
	sfx Sfx_WarpedVoidAppear,                         $00, 220, CHAN5_F, 1 ; SFX_WARPED_VOID_APPEAR
	sfx Sfx_Explosion,                         $00, 239, CHAN8_F, 1 ; SFX_EXPLOSION
	sfx Sfx_Step,                         $00, 220, CHAN8_F, 1 ; SFX_STEP
	sfx Sfx_PayCoins,                         $00, 220, CHAN7_F, 1 ; SFX_PAY_COINS
	sfx Sfx_OpenGoldenSnakeDoor,                         $00, 220, CHAN5_F, 2 ; SFX_OPEN_GOLDEN_SNAKE_DOOR
	sfx Sfx_CrayonScribble,                         $00, 220, CHAN8_F, 1 ; SFX_CRAYON_SCRIBBLE
	sfx Sfx_CastleForm,                         $00, 220, CHAN5_F, 4 ; SFX_CASTLE_FORM
	sfx Sfx_12f,                         $00, 220, CHAN8_F, 1 ; SFX_12F
	sfx Sfx_TextPrint,                         $00, 220, CHAN8_F, 1 ; SFX_TEXT_PRINT
	sfx Sfx_TreeMouthOpen,                         $00, 220, CHAN8_F, 1 ; SFX_TREE_MOUTH_OPEN
	sfx Sfx_Turn,                         $00, 220, CHAN5_F, 1 ; SFX_TURN
	sfx Sfx_MakeWire,                         $00, 220, CHAN7_F, 1 ; SFX_MAKE_WIRE
	sfx Sfx_GameOver,                         $00, 220, CHAN5_F, 1 ; SFX_GAME_OVER
	sfx Sfx_OpenCraterHole,                         $00, 220, CHAN5_F, 1 ; SFX_OPEN_CRATER_HOLE
	sfx Sfx_Tiptoe2BUnused,                         $00, 236, CHAN6_F, 1 ; SFX_TIPTOE_2_B_UNUSED
	sfx Sfx_SceneWarioRun,                         $00, 226, CHAN8_F, 1 ; SFX_SCENE_WARIO_RUN
	sfx Sfx_EpilogueObj,                         $00, 220, CHAN8_F, 1 ; SFX_EPILOGUE_OBJ
