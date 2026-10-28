	const_def

	const SOUND_OFF                        ; 000

	const MUSIC_OUT_OF_THE_WOODS_DAY       ; 001
	const MUSIC_OUT_OF_THE_WOODS_NIGHT     ; 002
	const MUSIC_FOREST_OF_FEAR             ; 003
	const MUSIC_THE_WARPED_VOID            ; 004
	const MUSIC_DESERT_RUINS               ; 005
	const MUSIC_THE_FRIGID_SEA             ; 006
	const MUSIC_THE_PEACEFUL_VILLAGE_DAY   ; 007
	const MUSIC_THE_PEACEFUL_VILLAGE_NIGHT ; 008
	const MUSIC_ABOVE_THE_CLOUDS_DAY       ; 009
	const MUSIC_ABOVE_THE_CLOUDS_NIGHT     ; 00a
	const MUSIC_THE_VOLCANOS_BASE_NIGHT    ; 00b
	const MUSIC_THE_VOLCANOS_BASE_DAY      ; 00c
	const MUSIC_THE_WEST_CRATER            ; 00d
	const MUSIC_THE_VAST_PLAIN_DAY         ; 00e
	const MUSIC_THE_VAST_PLAIN_NIGHT       ; 00f
	const MUSIC_BANK_OF_THE_WILD_RIVER     ; 010
	const MUSIC_THE_TIDAL_COAST            ; 011
	const MUSIC_CAVE_OF_FLAMES             ; 012
	const MUSIC_THE_POOL_OF_RAIN_DAY       ; 013
	const MUSIC_THE_POOL_OF_RAIN_NIGHT     ; 014
	const MUSIC_CREDITS                    ; 015
	const MUSIC_HOT_WARIO                  ; 016
	const MUSIC_FAT_WARIO                  ; 017
	const MUSIC_BOUNCY_WARIO               ; 018
	const MUSIC_ZOMBIE_WARIO               ; 019
	const MUSIC_FLAT_WARIO                 ; 01a
	const MUSIC_CRAZY_WARIO                ; 01b
	const MUSIC_INVISIBLE_WARIO            ; 01c
	const MUSIC_SNOWMAN_WARIO              ; 01d
	const MUSIC_OWL_WARIO                  ; 01e
	const MUSIC_BALL_O_STRING_WARIO        ; 01f
	const MUSIC_VAMPIRE_WARIO              ; 020
	const MUSIC_OVERWORLD_DAY              ; 021
	const MUSIC_OVERWORLD_NIGHT            ; 022
	const MUSIC_LEVEL_CLEAR_NO_TREASURE    ; 023
	const MUSIC_TREASURE_FANFARE           ; 024
	const MUSIC_PAUSE_MENU                 ; 025
	const MUSIC_GOLF                       ; 026
	const MUSIC_BOSS_BATTLE                ; 027
	const MUSIC_LEVEL_CLEAR_GOT_TREASURE   ; 028
	const MUSIC_BOSS_DEFEAT                ; 029
	const MUSIC_GOLF_GAME_OVER             ; 02a
	const MUSIC_GOLF_CLEAR                 ; 02b
	const MUSIC_MUSIC_BOXES                ; 02c
	const MUSIC_BOSS_REVEAL                ; 02d
	const MUSIC_ACTION_HELP                ; 02e
	const MUSIC_GOLF_LOBBY                 ; 02f
	const MUSIC_GAME_OVER                  ; 030
	const MUSIC_MUSIC_BOX_CAVE             ; 031
	const MUSIC_THE_TEMPLE                 ; 032
	const MUSIC_TITLE_SCREEN               ; 033
	const MUSIC_INTRO                      ; 034
	const MUSIC_HIDDEN_FIGURE_BATTLE_1     ; 035
	const MUSIC_PERFECT                    ; 036
	const MUSIC_TREASURE_COLLECTION        ; 037
	const MUSIC_EPILOGUE                   ; 038
	const MUSIC_HIDDEN_FIGURE_REVEAL       ; 039
	const MUSIC_HIDDEN_FIGURE_BATTLE_2     ; 03a
DEF NUM_MUSICS EQU const_value - 1

	const_def $101
	const SFX_JUMP                         ; 101
	const SFX_GROUND_SHAKE                 ; 102
	const SFX_BUMP                         ; 103
	const SFX_WALK                         ; 104
	const SFX_BLOCK_BREAK                  ; 105
	const SFX_PLANE_DEBRIS_LAND            ; 106
	const SFX_ATTACK                       ; 107
	const SFX_ATTACK_POWERED_UP            ; 108
	const SFX_REGULAR_COIN                 ; 109
	const SFX_ROLL                         ; 10a
	const SFX_ZIP_LINE_SLIDE               ; 10b
	const SFX_SLIDE                        ; 10c
	const SFX_SPLASH                       ; 10d
	const SFX_SWIM                         ; 10e
	const SFX_UNDERWATER_THRUST            ; 10f
	const SFX_LAND                         ; 110
	const SFX_TIPTOE_1                     ; 111
	const SFX_RECOVERY                     ; 112
	const SFX_STING                        ; 113
	const SFX_STOMP                        ; 114
	const SFX_GRAB                         ; 115
	const SFX_THROWN_OBJECT_HIT            ; 116
	const SFX_ATTACK_HIT                   ; 117
	const SFX_VANISH                       ; 118
	const SFX_THROW                        ; 119
	const SFX_OBJECT_HIT_WALL              ; 11a
	const SFX_FLATTEN                      ; 11b
	const SFX_FLAT_WALK                    ; 11c
	const SFX_FLAT_JUMP                    ; 11d
	const SFX_FIRE                         ; 11e
	const SFX_RUMBLE                       ; 11f
	const SFX_FLAT_FALL                    ; 120
	const SFX_HANG_GRAB                    ; 121
	const SFX_BURNT                        ; 122
	const SFX_BUBBLE_FLOAT                 ; 123
	const SFX_FAT_LAND                     ; 124
	const SFX_PUFFY_INFLATE                ; 125
	const SFX_PUFF_RAISE                   ; 126
	const SFX_PUFFY_DEFLATE                ; 127
	const SFX_ZOMBIE_TRANSFORM             ; 128
	const SFX_ZOMBIE_WALK                  ; 129
	const SFX_ZOMBIE_LAND                  ; 12a
	const SFX_BOUNCY_BOUNCE                ; 12b
	const SFX_THROW_CHARGE                 ; 12c
	const SFX_FULLY_CHARGED_THROW          ; 12d
	const SFX_ICE_SKATIN_CRASH             ; 12e
	const SFX_SWITCH                       ; 12f
	const SFX_PIPE_ENTER                   ; 130
	const SFX_MUSICAL_COIN                 ; 131
	const SFX_KEY                          ; 132
	const SFX_GROUND_POUND                 ; 133
	const SFX_SHOOT_KICK_WARIO             ; 134
	const SFX_CHEST_OPEN                   ; 135
	const SFX_SLEEP                        ; 136
	const SFX_WATER_SURFACE                ; 137
	const SFX_CLIMB                        ; 138
	const SFX_BALL_O_STRING_TRANSFORM      ; 139
	const SFX_EAT_FOOD                     ; 13a
	const SFX_FAT_WALK                     ; 13b
	const SFX_BALL_O_STRING_BOUNCE         ; 13c
	const SFX_STRING_UNWRAP                ; 13d
	const SFX_GET_TREASURE_OPEN            ; 13e
	const SFX_INVISIBLE_TRANSFORM          ; 13f
	const SFX_ELECTRIC_SHOCK               ; 140
	const SFX_ELECTRIC_LAND                ; 141
	const SFX_CRAZY_SPIN                   ; 142
	const SFX_CRAZY_DIZZY                  ; 143
	const SFX_SPLIT_LAND                   ; 144
	const SFX_VAMPIRE_TRANSFORM            ; 145
	const SFX_BAT_TRANSFORM                ; 146
	const SFX_SNOWMAN_TRANSFORM            ; 147
	const SFX_LAUNCH_CRASH                 ; 148
	const SFX_HAMMER_HIT                   ; 149
	const SFX_CROUCH_WALK                  ; 14a
	const SFX_COLOUR_COIN                  ; 14b
	const SFX_LAUNCHED                     ; 14c
	const SFX_04D                          ; 14d (unused)
	const SFX_04E                          ; 14e (unused)
	const SFX_04F                          ; 14f (unused)
	const SFX_050                          ; 150 (unused)
	const SFX_051                          ; 151 (unused)
	const SFX_052                          ; 152 (unused)
	const SFX_053                          ; 153 (unused)
	const SFX_054                          ; 154 (unused)
	const SFX_055                          ; 155 (unused)
	const SFX_056                          ; 156 (unused)
	const SFX_057                          ; 157 (unused)
	const SFX_058                          ; 158 (unused)
	const SFX_059                          ; 159 (unused)
	const SFX_05A                          ; 15a (unused)
	const SFX_05B                          ; 15b (unused)
	const SFX_05C                          ; 15c (unused)
	const SFX_05D                          ; 15d (unused)
	const SFX_05E                          ; 15e (unused)
	const SFX_05F                          ; 15f (unused)
	const SFX_060                          ; 160 (unused)
	const SFX_EARTHQUAKE                   ; 161
	const SFX_CLICK                        ; 162
	const SFX_SLAM                         ; 163
	const SFX_ZOMBIE                       ; 164
	const SFX_GOLF_BUNKER                  ; 165
	const SFX_BALL_BOUNCE                  ; 166
	const SFX_ENEMY_THROW                  ; 167
	const SFX_SUN_SHOOT                    ; 168
	const SFX_BUBBLE_SPAWN                 ; 169
	const SFX_WHIRR                        ; 16a
	const SFX_ELECTRIC_LAMP_DISCHARGE      ; 16b
	const SFX_ELECTRIC_SPARK               ; 16c
	const SFX_CART_ROLL                    ; 16d
	const SFX_MOON_SHOOT                   ; 16e
	const SFX_BIRD_ALERT                   ; 16f
	const SFX_BIRD_TAKE_OFF                ; 170
	const SFX_FLAP                         ; 171
	const SFX_BUBBLE_POP                   ; 172
	const SFX_FLAME                        ; 173
	const SFX_ZOMBIE_RISE                  ; 174
	const SFX_HEAVY_STEP                   ; 175
	const SFX_THUNDER                      ; 176
	const SFX_OWL_HOOT                     ; 177
	const SFX_STOVE_RATTLE                 ; 178
	const SFX_NOBIIRU_EXTEND               ; 179
	const SFX_SEEING_EYE_DOOR_LOOK         ; 17a
	const SFX_SEEING_EYE_DOOR              ; 17b
	const SFX_BEAM                         ; 17c
	const SFX_FAN_SPIN                     ; 17d
	const SFX_ENEMY_SHOOT                  ; 17e
	const SFX_07F                          ; 17f
	const SFX_FALLING_SNOW_DROP            ; 180
	const SFX_HAND_APPEAR                  ; 181
	const SFX_TELEPORT                     ; 182
	const SFX_SMALL_SPLASH                 ; 183
	const SFX_TURTLE_SWIM                  ; 184
	const SFX_MUDDEE_SWIM                  ; 185
	const SFX_BARREL_JUMP                  ; 186
	const SFX_OMODONMEKA_LIFT              ; 187
	const SFX_OMODONMEKA                   ; 188
	const SFX_SNAKE_SPIT_FIRE              ; 189
	const SFX_SNAKE_PREPARE_FIRE           ; 18a
	const SFX_SNAKE_SINK                   ; 18b
	const SFX_RAIL_HUM                     ; 18c
	const SFX_BIG_OCTO_1                   ; 18d
	const SFX_SPARKLE                      ; 18e
	const SFX_BIG_OCTO_2                   ; 18f
	const SFX_090                          ; 190 (unused)
	const SFX_091                          ; 191 (unused)
	const SFX_092                          ; 192 (unused)
	const SFX_093                          ; 193 (unused)
	const SFX_094                          ; 194 (unused)
	const SFX_095                          ; 195 (unused)
	const SFX_096                          ; 196 (unused)
	const SFX_097                          ; 197 (unused)
	const SFX_098                          ; 198 (unused)
	const SFX_099                          ; 199 (unused)
	const SFX_09A                          ; 19a (unused)
	const SFX_09B                          ; 19b (unused)
	const SFX_09C                          ; 19c (unused)
	const SFX_09D                          ; 19d (unused)
	const SFX_09E                          ; 19e (unused)
	const SFX_09F                          ; 19f (unused)
	const SFX_0A0                          ; 1a0 (unused)
	const SFX_WATER_DROP                   ; 1a1
	const SFX_DOLL_BOY                     ; 1a2
	const SFX_BOSS_DEFEAT_FALL             ; 1a3
	const SFX_DOLL_BOY_STUNNED             ; 1a4
	const SFX_YELLOW_BELLY_SPAWN_PUMP      ; 1a5
	const SFX_WORMWOULD_ATTACK             ; 1a6
	const SFX_WORMWOULD_HURT               ; 1a7
	const SFX_YELLOW_BELLY                 ; 1a8
	const SFX_BOSS_DEFEATED                ; 1a9
	const SFX_WOLFENBOSS_SMOKE             ; 1aa
	const SFX_SCOWLER                      ; 1ab
	const SFX_SCOWLER_DEFEATED             ; 1ac
	const SFX_PESCE_2                      ; 1ad
	const SFX_PESCE_1                      ; 1ae
	const SFX_ANONSTER_WALK                ; 1af
	const SFX_ANONSTER_1                   ; 1b0
	const SFX_ANONSTER_2                   ; 1b1
	const SFX_0B2                          ; 1b2
	const SFX_SCOWLER_STUNNED              ; 1b3
	const SFX_SCOWLER_STOMPED              ; 1b4
	const SFX_SCOWLER_INK_1                ; 1b5
	const SFX_SCOWLER_BLACKOUT             ; 1b6
	const SFX_0B7                          ; 1b7
	const SFX_SCOWLER_INK_2                ; 1b8
	const SFX_PESCE_3_YB_2                 ; 1b9
	const SFX_PUMP                         ; 1ba
	const SFX_PESCE_HIT                    ; 1bb
	const SFX_JAMANO_TURN                  ; 1bc
	const SFX_JAMANO_DEFEAT_POSE           ; 1bd
	const SFX_PESCE_FLY                    ; 1be
	const SFX_JAMANO_SKULL                 ; 1bf
	const SFX_MUDDEE_HURT                  ; 1c0
	const SFX_MUDDEE_BUBBLE                ; 1c1
	const SFX_MAGIC_SPIRAL_GROW            ; 1c2
	const SFX_WOLFENBOSS_HOVER             ; 1c3
	const SFX_0C4                          ; 1c4
	const SFX_IGAGURI                      ; 1c5
	const SFX_SHOOT_TAUNT                  ; 1c6
	const SFX_SHOOT_GOAL                   ; 1c7
	const SFX_SHOOT_JUMP                   ; 1c8
	const SFX_SHOOT                        ; 1c9
	const SFX_BOSS_APPEAR                  ; 1ca
	const SFX_HIDDEN_FIGURE_HAND_1         ; 1cb
	const SFX_HIDDEN_FIGURE_LAUGH          ; 1cc
	const SFX_HIDDEN_FIGURE_GRAB           ; 1cd
	const SFX_HIDDEN_FIGURE_HIT            ; 1ce
	const SFX_HIDDEN_FIGURE_DEFEATED       ; 1cf
	const SFX_HIDDEN_FIGURE_HAND_2         ; 1d0
	const SFX_HIDDEN_FIGURE_HAND_3         ; 1d1
	const SFX_0D2                          ; 1d2 (unused)
	const SFX_0D3                          ; 1d3 (unused)
	const SFX_0D4                          ; 1d4 (unused)
	const SFX_0D5                          ; 1d5 (unused)
	const SFX_0D6                          ; 1d6 (unused)
	const SFX_0D7                          ; 1d7 (unused)
	const SFX_0D8                          ; 1d8 (unused)
	const SFX_0D9                          ; 1d9 (unused)
	const SFX_0DA                          ; 1da (unused)
	const SFX_0DB                          ; 1db (unused)
	const SFX_0DC                          ; 1dc (unused)
	const SFX_0DD                          ; 1dd (unused)
	const SFX_0DE                          ; 1de (unused)
	const SFX_0DF                          ; 1df (unused)
	const SFX_0E0                          ; 1e0 (unused)
	const SFX_PIPE_EXIT                    ; 1e1
	const SFX_MENU_SCROLL                  ; 1e2
	const SFX_SELECTION                    ; 1e3
	const SFX_PAUSE                        ; 1e4
	const SFX_ERROR                        ; 1e5
	const SFX_ENTER_DOOR                   ; 1e6
	const SFX_MENU_CANCEL                  ; 1e7
	const SFX_GOLF_MISS                    ; 1e8
	const SFX_MENU_OPEN                    ; 1e9
	const SFX_MENU_CLOSE                   ; 1ea
	const SFX_PAGE_TURN                    ; 1eb
	const SFX_ACTION_HELP_BUTTON           ; 1ec
	const SFX_GOLF_CHARGE_SHOT             ; 1ed
	const SFX_GOLF_SPECIAL_TERRAIN_2       ; 1ee
	const SFX_GOLF_HOLE_IN                 ; 1ef
	const SFX_GOLF_SPECIAL_TERRAIN_1       ; 1f0
	const SFX_TIPTOE_2                     ; 1f1
	const SFX_TIPTOE_3                     ; 1f2
	const SFX_PROLOGUE_1                   ; 1f3
	const SFX_PROLOGUE_2                   ; 1f4
	const SFX_SNORE                        ; 1f5
	const SFX_PLANE1                       ; 1f6
	const SFX_PLANE2                       ; 1f7
	const SFX_PLANE3                       ; 1f8
	const SFX_PLANE_EXPLOSION              ; 1f9
	const SFX_SUCCESS                      ; 1fa
	const SFX_0FB                          ; 1fb (unused)
	const SFX_0FC                          ; 1fc (unused)
	const SFX_0FD                          ; 1fd (unused)
	const SFX_0FE                          ; 1fe (unused)
	const SFX_0FF                          ; 1ff (unused)

	const SFX_100                          ; 200 (unused)
	const SFX_CHOP_TREE                    ; 201
	const SFX_TREE_FALL                    ; 202
	const SFX_PATH_ARROW                   ; 203
	const SFX_LEVEL_STAR                   ; 204
	const SFX_GONG                         ; 205
	const SFX_EMOTE                        ; 206
	const SFX_HAMMER_BOT_WALK              ; 207
	const SFX_GATE_OPEN                    ; 208
	const SFX_FIX_ELEVATOR_1               ; 209
	const SFX_FIX_ELEVATOR                 ; 20a
	const SFX_FIX_ELEVATOR_2               ; 20b
	const SFX_OPEN_NORTH_GATE              ; 20c
	const SFX_TEMPLE_ROCK                  ; 20d
	const SFX_10E                          ; 20e
	const SFX_VOLCANO_ERUPTION_1           ; 20f
	const SFX_VOLCANO_ERUPTION_2           ; 210
	const SFX_VOLCANO_ERUPTION_3           ; 211
	const SFX_ITEM_RAISE                   ; 212
	const SFX_ACTION_B                     ; 213
	const SFX_VOLCANO_ERUPTION_4           ; 214
	const SFX_VOLCANO_ERUPTION_5           ; 215
	const SFX_VOLCANO_ERUPTION_6           ; 216
	const SFX_SUMMON_SNAKES                ; 217
	const SFX_FLUTE                        ; 218
	const SFX_ITEM_FALL                    ; 219
	const SFX_BEANSTALK_GROW               ; 21a
	const SFX_TOWER_RISE                   ; 21b
	const SFX_SEA_FREEZE                   ; 21c
	const SFX_TORNADO                      ; 21d
	const SFX_YELLOW_MUSIC_BOX             ; 21e
	const SFX_BLUE_MUSIC_BOX               ; 21f
	const SFX_GREEN_MUSIC_BOX              ; 220
	const SFX_RED_MUSIC_BOX                ; 221
	const SFX_GOLD_MUSIC_BOX               ; 222
	const SFX_BRIDGE_LOWER                 ; 223
	const SFX_LIGHTNING                    ; 224
	const SFX_BURN_VINES_1                 ; 225
	const SFX_BURN_VINES_2                 ; 226
	const SFX_VOLCANO_ERUPTION             ; 227
	const SFX_WARPED_VOID_APPEAR           ; 228
	const SFX_EXPLOSION                    ; 229
	const SFX_STEP                         ; 22a
	const SFX_PAY_COINS                    ; 22b
	const SFX_OPEN_GOLDEN_SNAKE_DOOR       ; 22c
	const SFX_CRAYON_SCRIBBLE              ; 22d
	const SFX_CASTLE_FORM                  ; 22e
	const SFX_12F                          ; 22f
	const SFX_TEXT_PRINT                   ; 230
	const SFX_TREE_MOUTH_OPEN              ; 231
	const SFX_TURN                         ; 232
	const SFX_MAKE_WIRE                    ; 233
	const SFX_GAME_OVER                    ; 234
	const SFX_OPEN_CRATER_HOLE             ; 235
	const SFX_TIPTOE_2_B_UNUSED            ; 236 (unused: SFX_TIPTOE_2 on the second square channel)
	const SFX_SCENE_WARIO_RUN              ; 237
	const SFX_EPILOGUE_OBJ                 ; 238
DEF NUM_SOUNDS EQU const_value
