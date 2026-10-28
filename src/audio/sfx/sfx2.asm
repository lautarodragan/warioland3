Sfx_IceSkatinCrash_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 80
	note NOTE_DURATION_1, F_4, 17
	audio_wait 3
	note F#4
	audio_wait 3
	note G_4
	audio_wait 3
	note G#4
	audio_wait 3
	note A_4
	audio_wait 3
	audio_end

Sfx_IceSkatinCrash:
	db 1, 0
	dw Sfx_IceSkatinCrash_Ch1

Sfx_Switch_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_34
	volume 94
	note NOTE_DURATION_1, E_3, 24
	audio_wait 1
	note G_3
	audio_wait 3
	note B_3
	audio_wait 3
	audio_end

Sfx_Switch:
	db 1, 0
	dw Sfx_Switch_Ch1

Sfx_PipeEnter_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_35
	volume 120
	note NOTE_DURATION_8, C_4, 24
	audio_wait 16
	note NOTE_DURATION_8
	audio_wait 16
	audio_end

Sfx_PipeEnter:
	db 1, 0
	dw Sfx_PipeEnter_Ch1

Sfx_MusicalCoin_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 66
	audio_wait 18
	note NOTE_DURATION_4, A_1, 17
	audio_wait 4
	note E_2
	audio_wait 4
	note G_2
	audio_wait 4
	note A_2
	audio_wait 4
	note C#3
	audio_wait 4
	note G_3
	audio_wait 4
	note E_3
	audio_wait 4
	note A#1
	audio_wait 4
	note F_2
	audio_wait 4
	note G#2
	audio_wait 4
	note A#2
	audio_wait 4
	note C_3
	audio_wait 4
	note G#3
	audio_wait 4
	note F#3
	audio_wait 4
	note B_1
	audio_wait 4
	note F#2
	audio_wait 4
	note A_2
	audio_wait 4
	note B_2
	audio_wait 4
	note C#3
	audio_wait 4
	note A_3
	audio_wait 4
	note F#3
	audio_wait 4
	note B_4
	audio_wait 4
	audio_end

Sfx_MusicalCoin_Ch2:
	semitone_offset 0
	wave WAVE_61
	volume 108
	note NOTE_DURATION_4, A_1, 22
	audio_wait 4
	note E_2
	audio_wait 4
	note G_2
	audio_wait 4
	note A_2
	audio_wait 4
	note C#3
	audio_wait 4
	note G_3
	audio_wait 4
	note E_3
	audio_wait 4
	note A#1
	audio_wait 4
	note F_2
	audio_wait 4
	note G#2
	audio_wait 4
	note A#2
	audio_wait 4
	note C_3
	audio_wait 4
	note G#3
	audio_wait 4
	note F#3
	audio_wait 4
	note B_1
	audio_wait 4
	note F#2
	audio_wait 4
	note A_2
	audio_wait 4
	note B_2
	audio_wait 4
	note C#3
	audio_wait 4
	note A_3
	audio_wait 4
	note F#3
	audio_wait 4
	note B_4
	audio_wait 4
	audio_end

Sfx_MusicalCoin:
	db 2, 0
	dw Sfx_MusicalCoin_Ch1
	dw Sfx_MusicalCoin_Ch2

Sfx_Key_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_47
	volume 94
	note NOTE_DURATION_3, D_2, 22
	audio_wait 3
	note A_2
	audio_wait 3
	note C_3
	audio_wait 3
	note E_3
	audio_wait 3
	note F_3
	audio_wait 3
	note A_3
	audio_wait 3
	note C_4
	audio_wait 3
	note E_4
	audio_wait 3
	note D#2
	audio_wait 3
	note A#2
	audio_wait 3
	note C#3
	audio_wait 3
	note F_3
	audio_wait 3
	note F#3
	audio_wait 3
	note A#3
	audio_wait 3
	note C#4
	audio_wait 3
	note F_4
	audio_wait 3
	note E_2
	audio_wait 3
	note B_2
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note G_3
	audio_wait 3
	note B_3
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note G_2
	audio_wait 3
	note D_3
	audio_wait 3
	note F_3
	audio_wait 3
	note A_3
	audio_wait 3
	note A#3
	audio_wait 3
	note D_4
	audio_wait 3
	note F_4
	audio_wait 3
	note A_4
	audio_wait 3
	audio_end

Sfx_Key_Ch2:
	semitone_offset 0
	wave WAVE_5D
	volume 66
	audio_wait 18
	note NOTE_DURATION_3, D_2, 17
	audio_wait 3
	note A_2
	audio_wait 3
	note C_3
	audio_wait 3
	note E_3
	audio_wait 3
	note F_3
	audio_wait 3
	note A_3
	audio_wait 3
	note C_4
	audio_wait 3
	note E_4
	audio_wait 3
	note D#2
	audio_wait 3
	note A#2
	audio_wait 3
	note C#3
	audio_wait 3
	note F_3
	audio_wait 3
	note F#3
	audio_wait 3
	note A#3
	audio_wait 3
	note C#4
	audio_wait 3
	note F_4
	audio_wait 3
	note E_2
	audio_wait 3
	note B_2
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note G_3
	audio_wait 3
	note B_3
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note G_2
	audio_wait 3
	note D_3
	audio_wait 3
	note F_3
	audio_wait 3
	note NOTE_DURATION_3, A_3, 19
	audio_wait 3
	note A#3
	audio_wait 3
	note NOTE_DURATION_3, D_4, 20
	audio_wait 3
	note F_4
	audio_wait 3
	note NOTE_DURATION_3, A_4, 25
	audio_wait 3
	audio_end

Sfx_Key:
	db 2, 0
	dw Sfx_Key_Ch1
	dw Sfx_Key_Ch2

Sfx_GroundPound_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6E
	volume 120
	note NOTE_DURATION_10, C_1, 31
	audio_wait 12
	note NOTE_DURATION_10, C_1, 31
	audio_wait 12
	audio_end

Sfx_GroundPound:
	db 1, 0
	dw Sfx_GroundPound_Ch1

Sfx_ShootKickWario_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_45
	volume 120
	note NOTE_DURATION_3, A_3, 31
	audio_wait 3
	note NOTE_DURATION_1, A_3, 9
	audio_wait 1
	note NOTE_DURATION_6, A_3, 31
	audio_wait 6
	note NOTE_DURATION_2, A_3, 9
	audio_wait 2
	note NOTE_DURATION_2, A_3, 4
	audio_wait 2
	audio_end

Sfx_ShootKickWario_Ch2:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 120
	note NOTE_DURATION_2, F_3, 31
	audio_wait 2
	note NOTE_DURATION_1, F_3, 12
	audio_wait 1
	note NOTE_DURATION_1, A_3, 4
	audio_wait 1
	note NOTE_DURATION_3, F_3, 31
	audio_wait 3
	note NOTE_DURATION_3, F_3, 12
	audio_wait 3
	note NOTE_DURATION_2, A_3, 4
	audio_wait 2
	note NOTE_DURATION_2, A_3, 2
	audio_wait 2
	audio_end

Sfx_ShootKickWario:
	db 2, 0
	dw Sfx_ShootKickWario_Ch1
	dw Sfx_ShootKickWario_Ch2

Sfx_ChestOpen_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 94
	note NOTE_DURATION_2, B_1, 29
	audio_wait 3
	note G_1, 9
	audio_wait 3
	note B_1, 24
	audio_wait 3
	note G_1, 7
	audio_wait 3
	audio_end

Sfx_ChestOpen:
	db 1, 0
	dw Sfx_ChestOpen_Ch1

Sfx_Sleep_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 47
	audio_wait 30
	note NOTE_DURATION_30, D_3, 7
	audio_wait 30
	wave WAVE_65
	note NOTE_DURATION_40, D_3, 7
	audio_wait 40
	note NOTE_DURATION_20, D_3, 4
	audio_wait 20
	wave WAVE_66
	note NOTE_DURATION_10, D_3, 2
	audio_wait 10
	audio_end

Sfx_Sleep:
	db 1, 0
	dw Sfx_Sleep_Ch1

Sfx_WaterSurface_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_36
	vibrato_amplitude 50
	volume 66
	pitch_offset 0
	note NOTE_DURATION_5, F_1, 24
	audio_wait 6
	note NOTE_DURATION_5
	audio_wait 6
	note NOTE_DURATION_5
	audio_wait 6
	note NOTE_DURATION_5, D_1
	audio_wait 10
	audio_end

Sfx_WaterSurface:
	db 1, 0
	dw Sfx_WaterSurface_Ch1

Sfx_Climb_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6C
	volume 56
	note NOTE_DURATION_16, F_1, 19
	audio_wait 16
	note NOTE_DURATION_16
	audio_wait 16
	audio_end

Sfx_Climb_Ch2:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 113
	note NOTE_DURATION_3, F_0, 24
	audio_wait 16
	note NOTE_DURATION_3
	audio_wait 16
	audio_end

Sfx_Climb:
	db 2, 0
	dw Sfx_Climb_Ch1
	dw Sfx_Climb_Ch2

Sfx_BallOStringTransform_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	vibrato_amplitude 0
	volume 113
	pitch_offset 0
	note NOTE_DURATION_1, C_5, 17
	audio_wait 3
	note G_4
	audio_wait 3
	note D#4
	audio_wait 3
	note C_4
	audio_wait 3
	note C#4
	audio_wait 3
	note A_4
	audio_wait 3
	note F#4
	audio_wait 3
	note G_4
	audio_wait 3
	note C_4
	audio_wait 3
	note D#4
	audio_wait 3
	note D_4
	audio_wait 1
	audio_end

Sfx_BallOStringTransform:
	db 1, 0
	dw Sfx_BallOStringTransform_Ch1

Sfx_EatFood_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_36
	volume 113
	note NOTE_DURATION_3, G_1, 29
	audio_wait 5
	wave WAVE_3F
	note NOTE_DURATION_3, F_1, 29
	audio_wait 5
	wave WAVE_36
	note NOTE_DURATION_3, G_1, 29
	audio_wait 5
	wave WAVE_3F
	note NOTE_DURATION_3, F_1, 29
	audio_wait 5
	wave WAVE_36
	note NOTE_DURATION_3, G_1, 29
	audio_wait 5
	wave WAVE_3F
	note NOTE_DURATION_3, F_1, 29
	audio_wait 44
	wave WAVE_3E
	volume 103
	pitch_offset -74
	note NOTE_DURATION_14, C#1, 27
	audio_wait 24
	wave WAVE_64
	volume 94
	note NOTE_DURATION_1, B_4, 24
	audio_wait 6
	note F#3
	audio_wait 2
	audio_end

Sfx_EatFood:
	db 1, 0
	dw Sfx_EatFood_Ch1

Sfx_FatWalk_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3F
	volume 113
	note NOTE_DURATION_6, G_1, 29
	audio_wait 6
	wave WAVE_36
	note NOTE_DURATION_4, F_1, 29
	audio_wait 22
	audio_end

Sfx_FatWalk:
	db 1, 0
	dw Sfx_FatWalk_Ch1

Sfx_BallOStringBounce_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	vibrato_amplitude 0
	volume 113
	pitch_offset 0
	note NOTE_DURATION_1, D_4, 17
	audio_wait 3
	note D#4
	audio_wait 3
	note C_4
	audio_wait 3
	note G_4
	audio_wait 3
	note F#4
	audio_wait 3
	note A_4
	audio_wait 3
	note C#4
	audio_wait 3
	note C_4
	audio_wait 3
	note G_4
	audio_wait 2
	note C_5
	audio_wait 2
	audio_end

Sfx_BallOStringBounce:
	db 1, 0
	dw Sfx_BallOStringBounce_Ch1

Sfx_StringUnwrap_Ch1:
	volume 66
	semitone_offset 0
	tempo 74
	wave WAVE_10
	pitch_offset 6
	note NOTE_DURATION_15, C_3, 14
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 1
	note NOTE_DURATION_15, C_3, 4
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 10
	pitch_offset 6
	note NOTE_DURATION_15, C_3, 14
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 1
	note NOTE_DURATION_15, C_3, 4
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 10
	audio_end

Sfx_StringUnwrap:
	db 1, 0
	dw Sfx_StringUnwrap_Ch1

Sfx_GetTreasureOpen_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	audio_wait 10
	note NOTE_DURATION_1, C_2, 24
	audio_wait 3
	note D_3
	audio_wait 3
	note A#3
	audio_wait 12
	note C_2
	audio_wait 3
	note D_3
	audio_wait 3
	note A#3
	audio_wait 54
	wave WAVE_0A
	volume 120
	note NOTE_DURATION_1, G_2, 31
	audio_wait 3
	note D#0
	audio_wait 3
	note A_5
	audio_wait 12
	note G_2
	audio_wait 3
	note D#0
	audio_wait 3
	note A_5
	audio_wait 12
	note G_2
	audio_wait 3
	note D#0
	audio_wait 3
	note A_5
	audio_wait 12
	note G_2
	audio_wait 3
	note D#0
	audio_wait 3
	note A_5
	audio_wait 12
	note G_2
	audio_wait 3
	note D#0
	audio_wait 3
	note A_5
	audio_wait 28
	volume 120
	wave WAVE_0B
	note NOTE_DURATION_2, G_4, 31
	audio_wait 2
	note NOTE_DURATION_16, G_5
	audio_wait 16
	audio_end

Sfx_GetTreasureOpen:
	db 1, 0
	dw Sfx_GetTreasureOpen_Ch1

Sfx_InvisibleTransform_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	vibrato_amplitude 0
	volume 120
	pitch_offset 0
	note NOTE_DURATION_5, C#4, 24
	audio_wait 6
	note D_4
	audio_wait 6
	volume 94
	note NOTE_DURATION_4, C#4, 19
	audio_wait 6
	note D_4
	audio_wait 6
	volume 75
	note NOTE_DURATION_3, C#4, 17
	audio_wait 6
	note D_4
	audio_wait 6
	volume 56
	note NOTE_DURATION_3, C#4, 14
	audio_wait 6
	note D_4
	audio_wait 6
	volume 37
	note NOTE_DURATION_3, C#4, 9
	audio_wait 6
	note D_4
	audio_wait 3
	audio_end

Sfx_InvisibleTransform_Ch2:
	semitone_offset 0
	wave WAVE_14
	volume 120
	vibrato_amplitude 0
	pitch_offset 0
	note NOTE_DURATION_5, G_3, 24
	audio_wait 6
	note G#3
	audio_wait 6
	volume 94
	note NOTE_DURATION_4, G_3, 19
	audio_wait 6
	note G#3
	audio_wait 6
	volume 75
	note NOTE_DURATION_3, G_3, 17
	audio_wait 6
	note G#3
	audio_wait 6
	volume 56
	note NOTE_DURATION_3, G_3, 14
	audio_wait 6
	note G#3
	audio_wait 6
	volume 37
	note NOTE_DURATION_3, G_3, 9
	audio_wait 6
	note G#3
	audio_wait 3
	audio_end

Sfx_InvisibleTransform:
	db 2, 0
	dw Sfx_InvisibleTransform_Ch1
	dw Sfx_InvisibleTransform_Ch2

Sfx_ElectricShock_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	vibrato_amplitude 30
	volume 94
	note NOTE_DURATION_16, C_3, 17
	audio_wait 16
	audio_end

Sfx_ElectricShock:
	db 1, 0
	dw Sfx_ElectricShock_Ch1

Sfx_ElectricLand_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 103
	note NOTE_DURATION_2, B_3, 19
	audio_wait 4
	note C_5
	audio_wait 4
	note A#3
	audio_wait 4
	note A#4
	audio_wait 4
	note A_3
	audio_wait 4
	note F_4
	audio_wait 4
	note C_4
	audio_wait 4
	note F#3
	audio_wait 4
	note C_4
	audio_wait 4
	note E_4
	audio_wait 4
	note D_5
	audio_wait 4
	note E_4
	audio_wait 2
	audio_end

Sfx_ElectricLand:
	db 1, 0
	dw Sfx_ElectricLand_Ch1

Sfx_CrazySpin_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	note NOTE_DURATION_8, C_5, 9
	audio_wait 8
	note D#5
	audio_wait 8
	note D_5, 17
	audio_wait 8
	note D#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note D#5, 24
	audio_wait 8
	note D_5, 19
	audio_wait 8
	note D#5, 12
	audio_wait 8
	note C_5, 9
	audio_wait 8
	note D#5
	audio_wait 8
	note D_5, 17
	audio_wait 8
	note D#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note D#5, 24
	audio_wait 8
	note D_5, 19
	audio_wait 8
	note D#5, 12
	audio_wait 8
	audio_end

Sfx_CrazySpin:
	db 1, 0
	dw Sfx_CrazySpin_Ch1

Sfx_CrazyDizzy_Ch1:
	volume 66
	semitone_offset 0
	tempo 74
	wave WAVE_10
	pitch_offset 6
	note NOTE_DURATION_15, C_3, 14
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 1
	note NOTE_DURATION_15, C_3, 4
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 10
	note E_2
	audio_wait 1
	note NOTE_DURATION_15, C_3, 14
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 1
	note NOTE_DURATION_15, C_3, 4
	audio_wait 8
	pitch_offset 12
	audio_wait 1
	note D#3
	audio_wait 1
	note E_4
	audio_wait 1
	note B_4
	audio_wait 1
	note F_5
	audio_wait 2
	note A#6
	audio_wait 10
	note E_2
	audio_wait 1
	audio_end

Sfx_CrazyDizzy:
	db 1, 0
	dw Sfx_CrazyDizzy_Ch1

Sfx_SplitLand_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 94
	audio_wait 28
	note NOTE_DURATION_1, G_1, 29
	audio_wait 1
	note G#1
	audio_wait 1
	note A_1
	audio_wait 1
	note A#1
	audio_wait 1
	note B_1
	audio_wait 1
	note C_2
	audio_wait 1
	note C#2
	audio_wait 1
	note D_2
	audio_wait 1
	note D#2
	audio_wait 1
	note E_2
	audio_wait 1
	note F_2
	audio_wait 1
	note F#2
	audio_wait 1
	note G_2
	audio_wait 1
	note NOTE_DURATION_1, G#2, 7
	audio_wait 1
	note A_2
	audio_wait 1
	note A#2
	audio_wait 1
	note B_2, 5
	audio_wait 1
	note C_3
	audio_wait 1
	note C#3, 3
	audio_wait 1
	note D_3
	audio_wait 1
	note D#3, 1
	audio_wait 1
	note E_3
	audio_wait 1
	note F_3
	audio_wait 1
	note F#3, 0
	audio_wait 1
	note G_3
	audio_wait 66
	note G_3, 29
	audio_wait 1
	note F#3
	audio_wait 1
	note F_3
	audio_wait 1
	note E_3
	audio_wait 1
	note D#3
	audio_wait 1
	note D_3
	audio_wait 1
	note D#3
	audio_wait 1
	note C_3
	audio_wait 1
	note B_2
	audio_wait 1
	note A#2
	audio_wait 1
	note A_2
	audio_wait 1
	note G#2
	audio_wait 1
	note G_2
	audio_wait 1
	note NOTE_DURATION_1, F#2, 7
	audio_wait 1
	note F_2
	audio_wait 1
	note E_2
	audio_wait 1
	note D#2, 5
	audio_wait 1
	note D_2
	audio_wait 1
	note C#2, 3
	audio_wait 1
	note C_2
	audio_wait 1
	audio_end

Sfx_SplitLand:
	db 1, 0
	dw Sfx_SplitLand_Ch1

Sfx_VampireTransform_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	note NOTE_DURATION_2, D#2, 19
	audio_wait 3
	note F_2
	audio_wait 3
	note G_2
	audio_wait 3
	note A_2
	audio_wait 3
	note B_2
	audio_wait 3
	note C#3
	audio_wait 3
	note D#3
	audio_wait 3
	note F_3
	audio_wait 3
	note G_3
	audio_wait 3
	note A_3
	audio_wait 3
	note B_3
	audio_wait 3
	note A_3
	audio_wait 3
	note G_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D#3
	audio_wait 3
	note C#3
	audio_wait 3
	note B_2
	audio_wait 3
	note A_2
	audio_wait 3
	note F_2
	audio_wait 3
	note D#2
	audio_wait 3
	audio_end

Sfx_VampireTransform_Ch2:
	semitone_offset 0
	wave WAVE_1A
	volume 94
	note NOTE_DURATION_2, A_2, 19
	audio_wait 3
	note B_2
	audio_wait 3
	note C#3
	audio_wait 3
	note D#3
	audio_wait 3
	note F_3
	audio_wait 3
	note G_3
	audio_wait 3
	note A_3
	audio_wait 3
	note B_3
	audio_wait 3
	note C#4
	audio_wait 3
	note D#4
	audio_wait 3
	note F_4
	audio_wait 3
	note D#4
	audio_wait 3
	note C#4
	audio_wait 3
	note B_3
	audio_wait 3
	note A_3
	audio_wait 3
	note G_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D#3
	audio_wait 3
	note C#3
	audio_wait 3
	note B_2
	audio_wait 3
	audio_end

Sfx_VampireTransform_Ch3:
	semitone_offset 0
	wave WAVE_65
	volume 113
	note NOTE_DURATION_8, F#1, 31
	audio_wait 10
	note NOTE_DURATION_8, F#1, 4
	audio_wait 10
	audio_end

Sfx_VampireTransform:
	db 3, 0
	dw Sfx_VampireTransform_Ch1
	dw Sfx_VampireTransform_Ch2
	dw Sfx_VampireTransform_Ch3

Sfx_BatTransform_Ch1:
	semitone_offset 1
	tempo 74
	wave WAVE_10
	volume 94
	note NOTE_DURATION_2, D#2, 19
	audio_wait 3
	note F_2
	audio_wait 3
	note G_2
	audio_wait 3
	note A_2
	audio_wait 3
	note B_2
	audio_wait 3
	note C#3
	audio_wait 3
	note D#3
	audio_wait 3
	note F_3
	audio_wait 3
	note G_3
	audio_wait 3
	note A_3
	audio_wait 3
	note B_3
	audio_wait 3
	note A_3
	audio_wait 3
	note G_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D#3
	audio_wait 3
	note C#3
	audio_wait 3
	note B_2
	audio_wait 3
	note A_2
	audio_wait 3
	note F_2
	audio_wait 3
	note D#2
	audio_wait 3
	note C#2
	audio_wait 3
	audio_end

Sfx_BatTransform_Ch2:
	semitone_offset 1
	wave WAVE_1A
	volume 94
	note NOTE_DURATION_2, A_2, 19
	audio_wait 3
	note B_2
	audio_wait 3
	note C#3
	audio_wait 3
	note D#3
	audio_wait 3
	note F_3
	audio_wait 3
	note G_3
	audio_wait 3
	note A_3
	audio_wait 3
	note B_3
	audio_wait 3
	note C#4
	audio_wait 3
	note D#4
	audio_wait 3
	note F_4
	audio_wait 3
	note D#4
	audio_wait 3
	note C#4
	audio_wait 3
	note B_3
	audio_wait 3
	note A_3
	audio_wait 3
	note G_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D#3
	audio_wait 3
	note C#3
	audio_wait 3
	note B_2
	audio_wait 3
	note A_2
	audio_wait 3
	audio_end

Sfx_BatTransform_Ch3:
	semitone_offset 0
	wave WAVE_65
	volume 120
	audio_wait 32
	note NOTE_DURATION_8, G#1, 31
	audio_wait 10
	note NOTE_DURATION_8, G#1, 9
	audio_wait 10
	audio_end

Sfx_BatTransform:
	db 3, 0
	dw Sfx_BatTransform_Ch1
	dw Sfx_BatTransform_Ch2
	dw Sfx_BatTransform_Ch3

Sfx_SnowmanTransform_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3F
	volume 120
	note NOTE_DURATION_6, G_1, 31
	audio_wait 10
	note NOTE_DURATION_6, G_1, 31
	audio_wait 30
	wave WAVE_36
	note NOTE_DURATION_4, F_1, 31
	audio_wait 16
	wave WAVE_10
	volume 90
	pitch_offset_mult 14
	pitch_offset 0
	note NOTE_DURATION_7, C_1, 27
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_7, C_1, 19
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_7, C_1, 19
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 56
	pitch_offset 0
	wave WAVE_6A
	volume 127
	note NOTE_DURATION_1, D_2, 31
	audio_wait 3
	note 14
	audio_wait 3
	note 14
	audio_wait 3
	audio_end

Sfx_SnowmanTransform:
	db 1, 0
	dw Sfx_SnowmanTransform_Ch1

Sfx_LaunchCrash_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	pitch_offset 8
	note NOTE_DURATION_10, F#0, 31
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 12
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 7
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2
	audio_end

Sfx_LaunchCrash_Ch2:
	semitone_offset 0
	volume 94
	wave WAVE_65
	note NOTE_DURATION_5, D_4, 29
	audio_wait 5
	wave WAVE_68
	note NOTE_DURATION_5, D_4, 29
	audio_wait 5
	wave WAVE_65
	note NOTE_DURATION_16, D_4, 29
	audio_wait 16
	note NOTE_DURATION_5, D_4, 27
	audio_wait 5
	note 24
	audio_wait 5
	note 23
	audio_wait 5
	note 21
	audio_wait 5
	note 17
	audio_wait 5
	wave WAVE_66
	note NOTE_DURATION_5, D_4, 17
	audio_wait 5
	audio_end

Sfx_LaunchCrash:
	db 2, 0
	dw Sfx_LaunchCrash_Ch1
	dw Sfx_LaunchCrash_Ch2

Sfx_HammerHit_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_34
	volume 120
	note NOTE_DURATION_2, D#3, 31
	audio_wait 6
	note C_4
	audio_wait 2
	audio_end

Sfx_HammerHit:
	db 1, 0
	dw Sfx_HammerHit_Ch1

Sfx_CrouchWalk_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	audio_wait 1
	note NOTE_DURATION_1, B_4, 24
	audio_wait 6
	note F#3
	audio_wait 14
	audio_end

Sfx_CrouchWalk:
	db 1, 0
	dw Sfx_CrouchWalk_Ch1

Sfx_ColourCoin_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 113
	note NOTE_DURATION_2, C_3, 21
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	note B_3
	audio_wait 3
	note A#3
	audio_wait 3
	note A_3
	audio_wait 3
	note G#3
	audio_wait 3
	note G_3
	audio_wait 3
	note F#3
	audio_wait 3
	note C_3
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	note E_4
	audio_wait 3
	note C_3, 9
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	note E_4
	audio_wait 3
	note C_3, 2
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	note E_4
	audio_wait 3
	audio_end

Sfx_ColourCoin:
	db 1, 0
	dw Sfx_ColourCoin_Ch1

Sfx_Launched_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_11
	volume 120
	note NOTE_DURATION_8, C_5, 9
	audio_wait 8
	note D#5
	audio_wait 8
	note D_5, 17
	audio_wait 8
	note D#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note D#5, 24
	audio_wait 8
	note D_5, 19
	audio_wait 8
	note D#5, 12
	audio_wait 8
	note C_5, 9
	audio_wait 8
	note D#5
	audio_wait 8
	note D_5, 17
	audio_wait 8
	note D#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note D#5, 24
	audio_wait 8
	note D_5, 19
	audio_wait 8
	note D#5, 12
	audio_wait 8
	audio_end

Sfx_Launched_Ch2:
	semitone_offset 0
	wave WAVE_60
	volume 66
	audio_wait 6
	note NOTE_DURATION_8, C_5, 9
	audio_wait 8
	note D#5
	audio_wait 8
	note D_5, 17
	audio_wait 8
	note D#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note D#5, 24
	audio_wait 8
	note D_5, 19
	audio_wait 8
	note D#5, 12
	audio_wait 8
	note C_5, 9
	audio_wait 8
	note D#5
	audio_wait 8
	note D_5, 17
	audio_wait 8
	note D#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note D#5, 24
	audio_wait 8
	note D_5, 19
	audio_wait 8
	note D#5, 12
	audio_wait 8
	audio_end

Sfx_Launched:
	db 2, 0
	dw Sfx_Launched_Ch1
	dw Sfx_Launched_Ch2

Sfx_Earthquake_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 120
	note NOTE_DURATION_9, G_1, 26
	audio_wait 9
	volume 94
	note NOTE_DURATION_8, 18
	audio_wait 9
	volume 66
	note NOTE_DURATION_8
	audio_wait 9
	volume 47
	note NOTE_DURATION_8
	audio_wait 9
	volume 28
	note NOTE_DURATION_8
	audio_wait 8
	audio_end

Sfx_Earthquake:
	db 1, 0
	dw Sfx_Earthquake_Ch1

Sfx_062_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 94
	note NOTE_DURATION_1, F_2, 29
	audio_wait 3
	note NOTE_DURATION_1, 4
	audio_wait 3
	note NOTE_DURATION_1, F_2, 12
	audio_wait 3
	note NOTE_DURATION_1, 1
	audio_wait 3
	audio_end

Sfx_Click:
	db 1, 0
	dw Sfx_062_Ch1

Sfx_Slam_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 120
	note NOTE_DURATION_9, F#1, 26
	audio_wait 10
	volume 94
	note NOTE_DURATION_8, 18
	audio_wait 10
	volume 66
	note NOTE_DURATION_8
	audio_wait 10
	volume 47
	note NOTE_DURATION_8
	audio_wait 10
	volume 28
	note NOTE_DURATION_8
	audio_wait 9
	audio_end

Sfx_Slam:
	db 1, 0
	dw Sfx_Slam_Ch1

Sfx_Zombie_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	vibrato_amplitude 30
	pitch_offset_mult 7
	pitch_offset 24
	note NOTE_DURATION_48, C_1, 24
	audio_wait 1
	pitch_offset 32
	audio_wait 1
	note C_4
	audio_wait 1
	note E_4
	audio_wait 1
	note F#4
	audio_wait 1
	note A_4
	audio_wait 1
	note C#5
	audio_wait 1
	note A_5
	audio_wait 1
	note C#6
	audio_wait 1
	note E_6
	audio_wait 1
	note F#6
	audio_wait 1
	note G#6
	audio_wait 1
	note A_6
	audio_wait 1
	note B_6
	audio_wait 2
	note C#7
	audio_wait 1
	note D#7
	audio_wait 1
	note F_7
	audio_wait 1
	note G_7
	audio_wait 16
	note C#7
	audio_wait 1
	note G#6
	audio_wait 1
	note D_6
	audio_wait 1
	note G#5
	audio_wait 1
	note G#4
	audio_wait 1
	note C#4
	audio_wait 1
	note G#3
	audio_wait 1
	note E_3
	audio_wait 1
	note B_2
	audio_wait 1
	note A_2
	audio_wait 1
	note G#2
	audio_wait 1
	note G_2
	audio_wait 6
	note F_2
	audio_wait 1
	note E_2
	audio_end

Sfx_Zombie:
	db 1, 0
	dw Sfx_Zombie_Ch1

Sfx_GolfBunker_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 113
	vibrato_amplitude 0
	note NOTE_DURATION_6, A_1, 31
	audio_wait 12
	note NOTE_DURATION_2, 18
	audio_wait 2
	audio_end

Sfx_GolfBunker:
	db 1, 0
	dw Sfx_GolfBunker_Ch1

Sfx_BallBounce_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_40
	volume 94
	note NOTE_DURATION_1, F_1, 27
	audio_wait 8
	note NOTE_DURATION_1, F_1, 12
	audio_wait 8
	audio_end

Sfx_BallBounce:
	db 1, 0
	dw Sfx_BallBounce_Ch1

Sfx_EnemyThrow_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_43
	volume 75
	note NOTE_DURATION_24, C_3, 19
	audio_wait 10
	pitch_offset 2
	audio_wait 1
	note G_2
	audio_wait 1
	note G_3
	audio_wait 1
	note C_5
	audio_wait 1
	note E_7
	audio_wait 1
	note G_7
	audio_wait 19
	note E_2
	audio_end

Sfx_EnemyThrow:
	db 1, 0
	dw Sfx_EnemyThrow_Ch1

Sfx_SunShoot_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 113
	note NOTE_DURATION_6, E_1, 19
	audio_wait 6
	wave WAVE_65
	note NOTE_DURATION_12, E_1, 24
	audio_wait 12
	note NOTE_DURATION_12, E_1, 29
	audio_wait 12
	audio_end

Sfx_SunShoot:
	db 1, 0
	dw Sfx_SunShoot_Ch1

Sfx_BubbleSpawn_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3E
	volume 85
	pitch_offset -74
	note NOTE_DURATION_16, C_1, 22
	audio_wait 16
	audio_end

Sfx_BubbleSpawn:
	db 1, 0
	dw Sfx_BubbleSpawn_Ch1

Sfx_Whirr_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 56
	pitch_offset_mult 14
	pitch_offset 0
	note NOTE_DURATION_7, B_2, 14
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	audio_end

Sfx_Whirr:
	db 1, 0
	dw Sfx_Whirr_Ch1

Sfx_ElectricLampDischarge_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_5D
	volume 103
	note NOTE_DURATION_1, B_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note 24
	audio_wait 1
	note 12
	audio_wait 2
	audio_end

Sfx_ElectricLampDischarge:
	db 1, 0
	dw Sfx_ElectricLampDischarge_Ch1

Sfx_ElectricSpark_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	vibrato_amplitude 0
	pitch_offset 8
	note NOTE_DURATION_20, D#0, 31
	audio_wait 2
	pitch_offset 8
	audio_wait 2
	note G#2
	audio_wait 2
	note C_2
	audio_wait 2
	note G#0
	audio_wait 2
	note D#0
	audio_wait 2
	note 27
	audio_wait 2
	note 22
	audio_wait 2
	note 21
	audio_wait 2
	note 20
	audio_wait 2
	note E_2, NOTE_DURATION_20, 19
	audio_wait 2
	pitch_offset 8
	audio_wait 2
	note G#2
	audio_wait 2
	note C_2
	audio_wait 2
	note G#0
	audio_wait 2
	note D#0
	audio_wait 2
	note 27
	audio_wait 2
	note 22
	audio_wait 2
	note 21
	audio_wait 2
	note 20
	audio_wait 2
	note E_2, NOTE_DURATION_20, 12
	audio_wait 2
	pitch_offset 8
	audio_wait 2
	note G#2
	audio_wait 2
	note C_2
	audio_wait 2
	note G#0
	audio_wait 2
	note D#0
	audio_wait 2
	note 27
	audio_wait 2
	note 22
	audio_wait 2
	note 21
	audio_wait 2
	note 20
	audio_wait 2
	note E_2, NOTE_DURATION_20, 7
	audio_wait 2
	pitch_offset 8
	audio_wait 2
	note G#2
	audio_wait 2
	note C_2
	audio_wait 2
	note G#0
	audio_wait 2
	note D#0
	audio_wait 2
	note 27
	audio_wait 2
	note 22
	audio_wait 2
	note 21
	audio_wait 2
	note 20
	audio_wait 2
	note E_2
	audio_end

Sfx_ElectricSpark:
	db 1, 0
	dw Sfx_ElectricSpark_Ch1

Sfx_CartRoll_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	vibrato_amplitude 0
	volume 120
	note NOTE_DURATION_2, B_1, 31
	audio_wait 8
	note 12
	audio_wait 8
	audio_end

Sfx_CartRoll:
	db 1, 0
	dw Sfx_CartRoll_Ch1

Sfx_MoonShoot_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_11
	volume 94
	note NOTE_DURATION_2, C#5, 24
	audio_wait 3
	note C_5
	audio_wait 3
	note B_4
	audio_wait 3
	note A#4
	audio_wait 3
	note B_4
	audio_wait 3
	note C_5
	audio_wait 3
	note NOTE_DURATION_10, C#5
	audio_wait 10
	audio_end

Sfx_MoonShoot:
	db 1, 0
	dw Sfx_MoonShoot_Ch1

Sfx_BirdAlert_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	volume 94
	note NOTE_DURATION_2, G_2, 24
	audio_wait 2
	note A_2
	audio_wait 2
	note G#2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note B_2
	audio_wait 2
	note A#2
	audio_wait 2
	note C_3
	audio_wait 2
	audio_end

Sfx_BirdAlert:
	db 1, 0
	dw Sfx_BirdAlert_Ch1

Sfx_BirdTakeOff_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_36
	volume 120
	note NOTE_DURATION_1, C#2, 31
	audio_wait 3
	note D_2
	audio_wait 3
	note D#2
	audio_wait 3
	note E_2
	audio_wait 3
	note F_2
	audio_wait 3
	note F#2
	audio_wait 3
	audio_end

Sfx_BirdTakeOff:
	db 1, 0
	dw Sfx_BirdTakeOff_Ch1

Sfx_Flap_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 66
	note NOTE_DURATION_2, C_3, 22
	audio_wait 4
	note NOTE_DURATION_3, C_3, 12
	audio_wait 4
	note 22
	audio_wait 4
	note 12
	audio_wait 4
	audio_end

Sfx_Flap:
	db 1, 2
	dw Sfx_Flap_Ch1

Sfx_BubblePop_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_36
	volume 85
	pitch_offset -50
	note NOTE_DURATION_2, C#2, 19
	audio_wait 3
	note NOTE_DURATION_2, C#3, 19
	audio_wait 3
	note NOTE_DURATION_2, C#2, 19
	audio_wait 3
	wave WAVE_68
	volume 66
	pitch_offset 0
	note NOTE_DURATION_5, D_4, 15
	audio_wait 5
	wave WAVE_65
	note NOTE_DURATION_5, D_4, 13
	audio_wait 5
	note 12
	audio_wait 5
	note 11
	audio_wait 5
	note 8
	audio_wait 5
	note 6
	audio_wait 5
	note 5
	audio_wait 5
	note 3
	audio_wait 5
	audio_end

Sfx_BubblePop:
	db 1, 0
	dw Sfx_BubblePop_Ch1

Sfx_Flame_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 113
	note NOTE_DURATION_8, F#1, 31
	audio_wait 10
	note NOTE_DURATION_8, F#1, 4
	audio_wait 10
	audio_end

Sfx_Flame:
	db 1, 0
	dw Sfx_Flame_Ch1

Sfx_ZombieRise_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0D
	vibrato_amplitude 80
	volume 94
	pitch_offset_mult 5
	pitch_offset 0
	note NOTE_DURATION_30, B_2, 24
	audio_wait 8
	pitch_offset 2
	audio_wait 1
	note F#2
	audio_wait 1
	note A#2
	audio_wait 1
	note B_2
	audio_wait 1
	note C#3
	audio_wait 1
	note D#3
	audio_wait 1
	note E_3
	audio_wait 1
	note G_3
	audio_wait 1
	note A#3
	audio_wait 1
	note D#4
	audio_wait 1
	note F_4
	audio_wait 1
	note B_4
	audio_wait 1
	note D_5
	audio_wait 1
	note A_5
	audio_wait 1
	note C#6
	audio_wait 1
	note A#6
	audio_wait 11
	note NOTE_DURATION_2, 12
	audio_wait 2
	note NOTE_DURATION_2, 7
	audio_wait 2
	audio_end

Sfx_ZombieRise:
	db 1, 0
	dw Sfx_ZombieRise_Ch1

Sfx_HeavyStep_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_40
	vibrato_amplitude 46
	volume 120
	pitch_offset 0
	note NOTE_DURATION_6, F_0, 31
	audio_wait 6
	note NOTE_DURATION_6, G_0, 24
	audio_wait 6
	note NOTE_DURATION_6, C_1, 22
	audio_wait 6
	note NOTE_DURATION_6, C_1, 12
	audio_wait 6
	audio_end

Sfx_HeavyStep:
	db 1, 0
	dw Sfx_HeavyStep_Ch1

Sfx_Thunder_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 56
	note NOTE_DURATION_8, C_3, 12
	audio_wait 8
	note NOTE_DURATION_8, C_3, 13
	audio_wait 8
	note NOTE_DURATION_10, C_3, 14
	audio_wait 10
	audio_end

Sfx_Thunder:
	db 1, 0
	dw Sfx_Thunder_Ch1

Sfx_OwlHoot_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_64
	volume 120
	note NOTE_DURATION_2, F#3, 31
	audio_wait 2
	note F_3
	audio_wait 2
	note F#3
	audio_wait 2
	note F_3
	audio_wait 2
	note F#3
	audio_wait 2
	note F_3
	audio_wait 2
	note E_3
	audio_wait 2
	note E_3, 24
	audio_wait 2
	note E_3, 19
	audio_wait 2
	note E_3, 14
	audio_wait 2
	audio_end

Sfx_OwlHoot:
	db 1, 0
	dw Sfx_OwlHoot_Ch1

Sfx_StoveRattle_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 113
	note NOTE_DURATION_6, F#1, 31
	audio_wait 6
	note NOTE_DURATION_2, 18
	audio_wait 2
	audio_end

Sfx_StoveRattle:
	db 1, 0
	dw Sfx_StoveRattle_Ch1

Sfx_NobiiruExtend_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 47
	pitch_offset_mult 7
	note NOTE_DURATION_48, C_2, 12
	audio_wait 4
	pitch_offset 6
	audio_wait 1
	note B_2
	audio_wait 1
	note B_3
	audio_wait 1
	note D_5
	audio_wait 1
	note A#5
	audio_wait 1
	note E_7
	audio_wait 1
	note G_7
	audio_wait 30
	note G_6
	audio_wait 1
	note B_5
	audio_wait 1
	note G_4
	audio_wait 1
	note C_4
	audio_wait 1
	note F_3
	audio_wait 1
	note C#3
	audio_wait 1
	note C_3
	audio_wait 1
	note B_2
	audio_wait 1
	note G#2
	audio_wait 1
	note E_2
	audio_wait 1
	audio_end

Sfx_NobiiruExtend:
	db 1, 0
	dw Sfx_NobiiruExtend_Ch1

Sfx_SeeingEyeDoorLook_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 120
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, F#1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, F#1, 24
	audio_wait 4
	audio_end

Sfx_SeeingEyeDoorLook:
	db 1, 0
	dw Sfx_SeeingEyeDoorLook_Ch1

Sfx_SeeingEyeDoor_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 94
	note NOTE_DURATION_8, B_1, 24
	audio_wait 9
	note NOTE_DURATION_8, 14
	audio_wait 9
	note NOTE_DURATION_8, 9
	audio_wait 9
	audio_end

Sfx_SeeingEyeDoor:
	db 1, 0
	dw Sfx_SeeingEyeDoor_Ch1

Sfx_Beam_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0D
	volume 94
	vibrato_amplitude 0
	pitch_offset 8
	note NOTE_DURATION_10, C_3, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 14
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 9
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 4
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2
	audio_end

Sfx_Beam_Ch2:
	semitone_offset 0
	wave WAVE_5D
	volume 94
	vibrato_amplitude 0
	pitch_offset 8
	note NOTE_DURATION_10, E_2, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 14
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 9
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 4
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2
	audio_end

Sfx_Beam:
	db 2, 0
	dw Sfx_Beam_Ch1
	dw Sfx_Beam_Ch2

Sfx_FanSpin_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 75
	note NOTE_DURATION_3, G_1, 19
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	audio_end

Sfx_FanSpin:
	db 1, 0
	dw Sfx_FanSpin_Ch1

Sfx_EnemyShoot_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_33
	volume 120
	note NOTE_DURATION_4, A_0, 31
	audio_wait 8
	note NOTE_DURATION_4, A_0, 14
	audio_wait 8
	audio_end

Sfx_EnemyShoot:
	db 1, 0
	dw Sfx_EnemyShoot_Ch1

Sfx_07f_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 103
	pitch_offset_mult 14
	pitch_offset 0
	note NOTE_DURATION_7, G_1, 27
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_7, G_1, 12
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	audio_end

Sfx_07f:
	db 1, 0
	dw Sfx_07f_Ch1

Sfx_FallingSnowDrop_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6D
	volume 120
	note NOTE_DURATION_3, B_2, 31
	audio_wait 3
	note A#2
	audio_wait 3
	note A_2
	audio_wait 3
	note B_2
	audio_wait 3
	note A#2
	audio_wait 3
	note A_2
	audio_wait 3
	note B_2
	audio_wait 3
	note A#2
	audio_wait 3
	note A_2
	audio_wait 3
	audio_end

Sfx_FallingSnowDrop:
	db 1, 0
	dw Sfx_FallingSnowDrop_Ch1

Sfx_HandAppear_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 56
	note NOTE_DURATION_2, G_3, 12
	audio_wait 3
	note E_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D_3
	audio_wait 3
	note G_3
	audio_wait 3
	note E_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D_3
	audio_wait 3
	note G_3
	audio_wait 3
	note E_3
	audio_wait 3
	note F_3
	audio_wait 3
	note D_3
	audio_wait 3
	wave WAVE_10
	volume 60
	pitch_offset_mult 7
	note NOTE_DURATION_76, C#1, 14
	audio_wait 1
	pitch_offset 32
	audio_wait 1
	note C_4
	audio_wait 1
	note E_4
	audio_wait 1
	note F#4
	audio_wait 1
	note A_4
	audio_wait 1
	note C#5
	audio_wait 1
	note A_5
	audio_wait 1
	note C#6
	audio_wait 1
	note E_6
	audio_wait 1
	note F#6
	audio_wait 1
	note G#6
	audio_wait 1
	note A_6
	audio_wait 1
	note B_6
	audio_wait 2
	note C#7
	audio_wait 1
	note D#7
	audio_wait 1
	note F_7
	audio_wait 1
	note G_7
	audio_wait 44
	note C#7
	audio_wait 1
	note G#6
	audio_wait 1
	note D_6
	audio_wait 1
	note G#5
	audio_wait 1
	note G#4
	audio_wait 1
	note C#4
	audio_wait 1
	note G#3
	audio_wait 1
	note E_3
	audio_wait 1
	note B_2
	audio_wait 1
	note A_2
	audio_wait 1
	note G#2
	audio_wait 1
	note G_2
	audio_wait 6
	note F_2
	audio_wait 1
	note E_2
	audio_end

Sfx_HandAppear:
	db 1, 0
	dw Sfx_HandAppear_Ch1

Sfx_Teleport_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	vibrato_amplitude 0
	volume 94
	note NOTE_DURATION_4, E_2, 24
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 19
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 14
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 9
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 4
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	audio_end

Sfx_Teleport_Ch2:
	semitone_offset 0
	wave WAVE_63
	vibrato_amplitude 100
	volume 108
	pitch_offset 0
	note NOTE_DURATION_24, E_2, 27
	audio_wait 3
	pitch_offset 4
	audio_wait 1
	note F#2
	audio_wait 2
	note C_2
	audio_wait 1
	note G#1
	audio_wait 1
	note G#0
	audio_wait 1
	note D_0
	audio_wait 1
	note 34
	audio_wait 1
	note 31
	audio_wait 1
	note 30
	audio_wait 2
	note 31
	audio_wait 1
	note 34
	audio_wait 1
	note F_0
	audio_wait 1
	note A_0
	audio_wait 1
	note C#1
	audio_wait 1
	note E_1
	audio_wait 1
	note G_1
	audio_wait 1
	note G#1
	audio_wait 3
	note 31
	audio_wait 1
	note 34
	audio_wait 1
	note F_0
	audio_wait 1
	note A_0
	audio_wait 1
	note C#1
	audio_wait 1
	note E_1
	audio_wait 1
	note G_1
	audio_wait 1
	note G#1
	audio_wait 3
	audio_end

Sfx_Teleport:
	db 2, 0
	dw Sfx_Teleport_Ch1
	dw Sfx_Teleport_Ch2

Sfx_SmallSplash_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_12
	volume 94
	pitch_offset_mult 17
	note NOTE_DURATION_13, C_1, 24
	audio_wait 1
	pitch_offset 2
	audio_wait 1
	note E_2
	audio_wait 1
	note D_3
	audio_wait 1
	note G#3
	audio_wait 1
	note E_4
	audio_wait 1
	note D#5
	audio_wait 1
	note G_5
	audio_wait 1
	note E_6
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	note G_7, 15
	audio_wait 1
	note G_7, 7
	audio_wait 1
	note E_2
	audio_end

Sfx_SmallSplash_Ch2:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 37
	note NOTE_DURATION_5, C#3, 31
	audio_wait 5
	wave WAVE_65
	note NOTE_DURATION_5, C#3, 24
	audio_wait 5
	note 22
	audio_wait 5
	note 17
	audio_wait 5
	note 12
	audio_wait 5
	note 7
	audio_wait 5
	note 4
	audio_wait 5
	note 2
	audio_wait 5
	audio_end

Sfx_SmallSplash:
	db 2, 0
	dw Sfx_SmallSplash_Ch1
	dw Sfx_SmallSplash_Ch2

Sfx_TurtleSwim_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_42
	volume 94
	pitch_offset -50
	note NOTE_DURATION_13, G#1, 24
	audio_wait 2
	pitch_offset -88
	audio_wait 2
	note 0
	audio_wait 7
	note A#0
	audio_wait 2
	note C#6
	audio_wait 2
	note G_7
	audio_wait 22
	note E_2
	audio_end

Sfx_TurtleSwim:
	db 1, 0
	dw Sfx_TurtleSwim_Ch1

Sfx_MuddeeSwim_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_60
	volume 108
	note NOTE_DURATION_1, C#2, 28
	audio_wait 3
	note D#2
	audio_wait 3
	note F_2
	audio_wait 2
	audio_end

Sfx_MuddeeSwim:
	db 1, 0
	dw Sfx_MuddeeSwim_Ch1

Sfx_BarrelJump_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 75
	note NOTE_DURATION_1, C#5, 19
	audio_wait 3
	note B_4
	audio_wait 3
	note A_4
	audio_wait 3
	note G_4
	audio_wait 3
	note F_4
	audio_wait 3
	note D#4
	audio_wait 3
	note C#4
	audio_wait 3
	audio_end

Sfx_BarrelJump:
	db 1, 0
	dw Sfx_BarrelJump_Ch1

Sfx_OmodonmekaLift_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 75
	note NOTE_DURATION_2, F_3, 22
	audio_wait 3
	note NOTE_DURATION_2, E_3, 20
	audio_wait 3
	audio_end

Sfx_OmodonmekaLift:
	db 1, 0
	dw Sfx_OmodonmekaLift_Ch1

Sfx_Omodonmeka_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0F
	volume 66
	pitch_offset_mult 24
	pitch_offset 0
	note NOTE_DURATION_22, C#5, 17
	audio_wait 3
	pitch_offset -2
	audio_wait 1
	note B_1
	audio_wait 1
	note G#1
	audio_wait 1
	note F_1
	audio_wait 1
	note A#0
	audio_wait 1
	note F_0
	audio_wait 1
	note C#0
	audio_wait 1
	note 33
	audio_wait 1
	note 26
	audio_wait 1
	note 22
	audio_wait 1
	note 19
	audio_wait 1
	note 17
	audio_wait 1
	note 12
	audio_wait 1
	note 10
	audio_wait 1
	note 9
	audio_wait 1
	note 8
	audio_wait 1
	note 9
	audio_wait 1
	note 14
	audio_wait 1
	note 24
	audio_wait 1
	note E_2
	audio_end

Sfx_Omodonmeka_Ch2:
	semitone_offset 0
	wave WAVE_23
	volume 66
	pitch_offset_mult 24
	pitch_offset 0
	note NOTE_DURATION_22, C_4, 17
	audio_wait 3
	pitch_offset -2
	audio_wait 1
	note B_1
	audio_wait 1
	note G#1
	audio_wait 1
	note F_1
	audio_wait 1
	note A#0
	audio_wait 1
	note F_0
	audio_wait 1
	note C#0
	audio_wait 1
	note 33
	audio_wait 1
	note 26
	audio_wait 1
	note 22
	audio_wait 1
	note 19
	audio_wait 1
	note 17
	audio_wait 1
	note 12
	audio_wait 1
	note 10
	audio_wait 1
	note 9
	audio_wait 1
	note 8
	audio_wait 1
	note 9
	audio_wait 1
	note 14
	audio_wait 1
	note 24
	audio_wait 1
	note E_2
	audio_end

Sfx_Omodonmeka:
	db 2, 0
	dw Sfx_Omodonmeka_Ch1
	dw Sfx_Omodonmeka_Ch2

Sfx_SnakeSpitFire_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 113
	note NOTE_DURATION_12, F_1, 16
	audio_wait 12
	wave WAVE_65
	note NOTE_DURATION_8, F_1, 19
	audio_wait 8
	note NOTE_DURATION_96, F_1, 23
	audio_wait 96
	note NOTE_DURATION_32, F_1, 23
	audio_wait 32
	audio_end

Sfx_SnakeSpitFire:
	db 1, 0
	dw Sfx_SnakeSpitFire_Ch1

Sfx_SnakePrepareFire_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	volume 94
	note NOTE_DURATION_2, G#2, 24
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note A_2
	audio_wait 2
	note G#2
	audio_wait 2
	note G_2
	audio_wait 2
	note F#2
	audio_wait 2
	note G_2
	audio_wait 2
	note G#2
	audio_wait 2
	note A_2
	audio_wait 2
	note A#2
	audio_wait 2
	note B_2
	audio_wait 2
	audio_end

Sfx_SnakePrepareFire_Ch2:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 94
	note NOTE_DURATION_2, D_2, 24
	audio_wait 2
	note E_2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note F_2
	audio_wait 2
	note E_2
	audio_wait 2
	note D#2
	audio_wait 2
	note D_2
	audio_wait 2
	note D#2
	audio_wait 2
	note E_2
	audio_wait 2
	note F_2
	audio_wait 2
	note F#2
	audio_wait 2
	note G_2
	audio_wait 2
	audio_end

Sfx_SnakePrepareFire:
	db 2, 0
	dw Sfx_SnakePrepareFire_Ch1
	dw Sfx_SnakePrepareFire_Ch2

Sfx_SnakeSink_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_36
	volume 120
	note NOTE_DURATION_7, C_1, 31
	audio_wait 8
	note NOTE_DURATION_7, B_0, 27
	audio_wait 8
	note NOTE_DURATION_7, A#0, 24
	audio_wait 8
	note NOTE_DURATION_7, A_0, 22
	audio_wait 8
	note NOTE_DURATION_7, G_0, 19
	audio_wait 8
	note NOTE_DURATION_7, F_0, 19
	audio_wait 8
	note NOTE_DURATION_7, E_0, 19
	audio_wait 8
	audio_end

Sfx_SnakeSink:
	db 1, 0
	dw Sfx_SnakeSink_Ch1

Sfx_RailHum_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 94
	note NOTE_DURATION_2, G_3, 22
	audio_wait 2
	note G#3
	audio_wait 2
	note A_3
	audio_wait 2
	note A#3
	audio_wait 2
	note B_3
	audio_wait 2
	note C_4
	audio_wait 2
	note C#4
	audio_wait 2
	note D_4
	audio_wait 2
	note C#4
	audio_wait 2
	note C_4
	audio_wait 2
	note B_3
	audio_wait 2
	note A#3
	audio_wait 2
	note A_3
	audio_wait 2
	note G#3
	audio_wait 2
	note G_3
	audio_wait 2
	audio_end

Sfx_RailHum:
	db 1, 0
	dw Sfx_RailHum_Ch1

Sfx_08d_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	volume 120
	pitch_offset 8
	note NOTE_DURATION_8, A_0, 31
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_8, A#0, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_8, B_0, 12
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_8, C_1, 7
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 20
	audio_wait 1
	note E_2
	audio_end

Sfx_08d:
	db 1, 0
	dw Sfx_08d_Ch1

Sfx_Sparkle_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_4A
	volume 94
	note NOTE_DURATION_1, B_4, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C#5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, D_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, B_4, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C#5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, D_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, B_4, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, C_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, C#5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, D_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, B_4, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, C_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, C#5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, D_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	audio_end

Sfx_Sparkle:
	db 1, 0
	dw Sfx_Sparkle_Ch1

Sfx_08f_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 85
	pitch_offset 0
	note NOTE_DURATION_5, D_4, 17
	audio_wait 5
	wave WAVE_65
	note NOTE_DURATION_5, D_4, 15
	audio_wait 5
	note 13
	audio_wait 5
	note 11
	audio_wait 5
	note 8
	audio_wait 5
	note 6
	audio_wait 5
	note 5
	audio_wait 5
	note 3
	audio_wait 5
	audio_end

Sfx_08f:
	db 1, 0
	dw Sfx_08f_Ch1

Sfx_WaterDrop_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 75
	note NOTE_DURATION_1, C_2, 24
	audio_wait 1
	note NOTE_DURATION_1, C_2, 7
	audio_wait 1
	note NOTE_DURATION_1, C_3, 19
	audio_wait 1
	note NOTE_DURATION_1, C_3, 7
	audio_wait 1
	note NOTE_DURATION_1, F_3, 14
	audio_wait 1
	note NOTE_DURATION_1, F_3, 4
	audio_wait 1
	note NOTE_DURATION_1, G_2, 9
	audio_wait 1
	note NOTE_DURATION_1, G_2, 4
	audio_wait 1
	note NOTE_DURATION_1, C_3, 7
	audio_wait 1
	note NOTE_DURATION_1, C_3, 2
	audio_wait 1
	note NOTE_DURATION_1, C_3, 7
	audio_wait 1
	note NOTE_DURATION_1, C_3, 2
	audio_wait 1
	note NOTE_DURATION_1, C_3, 7
	audio_wait 1
	note NOTE_DURATION_1, C_3, 2
	audio_wait 1
	audio_end

Sfx_WaterDrop:
	db 1, 0
	dw Sfx_WaterDrop_Ch1

Sfx_DollBoy_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 75
	pitch_offset_mult 24
	pitch_offset 0
	note NOTE_DURATION_11, B_4, 19
	audio_wait 1
	pitch_offset -2
	audio_wait 1
	note G#1
	audio_wait 1
	note A#0
	audio_wait 1
	note F_0
	audio_wait 1
	note 33
	audio_wait 1
	note 26
	audio_wait 1
	note 17
	audio_wait 1
	note 12
	audio_wait 1
	note 9
	audio_wait 1
	note 24
	audio_wait 1
	note E_2
	audio_end

Sfx_DollBoy_Ch2:
	semitone_offset 0
	wave WAVE_60
	volume 75
	pitch_offset_mult 24
	pitch_offset 0
	note NOTE_DURATION_11, A#3, 19
	audio_wait 1
	pitch_offset -2
	audio_wait 1
	note G#1
	audio_wait 1
	note A#0
	audio_wait 1
	note F_0
	audio_wait 1
	note 33
	audio_wait 1
	note 26
	audio_wait 1
	note 17
	audio_wait 1
	note 12
	audio_wait 1
	note 9
	audio_wait 1
	note 24
	audio_wait 1
	note E_2
	audio_end

Sfx_DollBoy:
	db 2, 0
	dw Sfx_DollBoy_Ch1
	dw Sfx_DollBoy_Ch2

Sfx_BossDefeatFall_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3A
	volume 75
	note NOTE_DURATION_20, C_4, 19
	audio_wait 20
	audio_end

Sfx_BossDefeatFall:
	db 1, 0
	dw Sfx_BossDefeatFall_Ch1

Sfx_DollBoyStunned_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_25
	volume 94
	note NOTE_DURATION_2, C_4, 24
	audio_wait 8
	note F_3
	audio_wait 8
	note F#4
	audio_wait 8
	note A_4
	audio_wait 8
	note A_3
	audio_wait 8
	note E_4
	audio_wait 8
	note D_5
	audio_wait 8
	note E_4
	audio_wait 8
	note C_4
	audio_wait 8
	note F#3
	audio_wait 8
	note C_4
	audio_wait 8
	note F_4
	audio_wait 8
	note A#4
	audio_wait 8
	note A#3
	audio_wait 8
	note C_5
	audio_wait 8
	note B_3
	audio_wait 8
	audio_end

Sfx_DollBoyStunned:
	db 1, 0
	dw Sfx_DollBoyStunned_Ch1

Sfx_YellowBellySpawnPump_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_42
	volume 120
	note NOTE_DURATION_7, B_0, 31
	audio_wait 7
	audio_end

Sfx_YellowBellySpawnPump:
	db 1, 0
	dw Sfx_YellowBellySpawnPump_Ch1

Sfx_WormwouldAttack_Ch1:
	semitone_offset 250
	tempo 74
	wave WAVE_63
	volume 120
	pitch_offset_mult 10
	vibrato_amplitude 100
	note NOTE_DURATION_3, G_2, 24
	pitch_offset -2
	audio_wait 1
	note C_2
	audio_wait 1
	note A#1
	audio_wait 1
	note NOTE_DURATION_4, G#2
	pitch_offset -18
	audio_wait 1
	note E_1
	audio_wait 1
	note F#0
	audio_wait 1
	note C#0
	audio_wait 1
	note NOTE_DURATION_4, A_2
	pitch_offset -64
	audio_wait 1
	note 23
	audio_wait 1
	note 18
	audio_wait 1
	note 14
	audio_wait 1
	note NOTE_DURATION_4, A#2
	pitch_offset -106
	audio_wait 1
	note 5
	audio_wait 1
	note 4
	audio_wait 1
	note 3
	audio_wait 1
	note NOTE_DURATION_9, B_2
	pitch_offset -120
	audio_wait 3
	note 6
	audio_wait 3
	note E_2
	audio_wait 3
	audio_end

Sfx_WormwouldAttack:
	db 1, 0
	dw Sfx_WormwouldAttack_Ch1

Sfx_WormwouldHurt_Ch1:
	semitone_offset 6
	tempo 74
	wave WAVE_63
	volume 120
	note NOTE_DURATION_2, C_1, 31, D_1
	audio_wait 2
	note E_1
	audio_wait 2
	note C#1
	audio_wait 2
	note D#1, F_1
	audio_wait 2
	note D_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1, F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note G_1
	audio_wait 2
	note E_1, F#1
	audio_wait 2
	note G#1
	audio_wait 2
	note F_1
	audio_wait 2
	note G_1, A_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1, A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note B_1
	audio_wait 2
	note F#1, G#1
	audio_wait 2
	note A#1
	audio_wait 2
	note F_1
	audio_wait 2
	note G_1, A_1
	audio_wait 2
	note E_1
	audio_wait 2
	note F#1
	audio_wait 2
	note D#1, G#1
	audio_wait 2
	note F_1
	audio_wait 2
	note G_1
	audio_wait 2
	note D_1, E_1
	audio_wait 2
	note F#1
	audio_wait 2
	note C#1
	audio_wait 2
	note D#1, F_1
	audio_wait 2
	note C_1
	audio_wait 2
	note D_1
	audio_wait 2
	note E_1
	audio_end

Sfx_WormwouldHurt:
	db 1, 0
	dw Sfx_WormwouldHurt_Ch1

Sfx_YellowBelly_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 75
	note NOTE_DURATION_4, G_2, 19
	audio_wait 4
	note F_2
	audio_wait 4
	note E_2
	audio_wait 4
	note D_2
	audio_wait 4
	note C_2
	audio_wait 4
	note B_1
	audio_wait 4
	note A_1
	audio_wait 4
	note G_1
	audio_wait 4
	note F_1
	audio_wait 4
	note E_1
	audio_wait 4
	note D_1
	audio_wait 4
	note C_1
	audio_wait 4
	note D_1
	audio_wait 4
	note E_1
	audio_wait 4
	note F_1
	audio_wait 4
	note G_1
	audio_wait 4
	note A_1
	audio_wait 4
	note B_1
	audio_wait 4
	note C_2
	audio_wait 4
	note D_2
	audio_wait 4
	note E_2
	audio_wait 4
	note F_2
	audio_wait 4
	note G_2
	audio_wait 4
	note A_2
	audio_wait 4
	audio_end

Sfx_YellowBelly_Ch2:
	semitone_offset 0
	wave WAVE_3A
	volume 120
	note NOTE_DURATION_96, G_1, 31
	audio_wait 96
	audio_end

Sfx_YellowBelly:
	db 2, 0
	dw Sfx_YellowBelly_Ch1
	dw Sfx_YellowBelly_Ch2

Sfx_BossDefeated_Ch1:
	semitone_offset 3
	tempo 74
	wave WAVE_63
	vibrato_amplitude 50
	volume 120
	note NOTE_DURATION_2, C_2, 31
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note D_1
	audio_wait 2
	note D#1
	audio_wait 2
	note D_1
	audio_wait 2
	note C#1
	audio_wait 2
	note D_1
	audio_wait 2
	note C#1
	audio_wait 2
	note C_1
	audio_wait 2
	note C#1
	audio_wait 2
	note C_1
	audio_wait 2
	note B_0
	audio_wait 2
	audio_end

Sfx_BossDefeated:
	db 1, 0
	dw Sfx_BossDefeated_Ch1

Sfx_WolfenbossSmoke_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_45
	volume 120
	note NOTE_DURATION_6, F#3, 31
	audio_wait 6
	note NOTE_DURATION_2, F#3, 19
	audio_wait 2
	note NOTE_DURATION_2, F#3, 14
	audio_wait 2
	note NOTE_DURATION_2, F#3, 9
	audio_wait 2
	audio_end

Sfx_WolfenbossSmoke_Ch2:
	semitone_offset 0
	wave WAVE_6A
	volume 94
	note NOTE_DURATION_7, G#1, 24
	audio_wait 8
	note NOTE_DURATION_5, G#1, 9
	audio_wait 6
	note NOTE_DURATION_4, G_1, 4
	audio_wait 5
	audio_end

Sfx_WolfenbossSmoke:
	db 2, 0
	dw Sfx_WolfenbossSmoke_Ch1
	dw Sfx_WolfenbossSmoke_Ch2

Sfx_Scowler_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 56
	pitch_offset_mult 14
	pitch_offset 0
	note NOTE_DURATION_7, B_2, 14
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	audio_end

Sfx_Scowler:
	db 1, 0
	dw Sfx_Scowler_Ch1

Sfx_ScowlerDefeated_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	vibrato_amplitude 0
	volume 75
	pitch_offset 0
	note NOTE_DURATION_28, C_3, 19
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, C_2, 17
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, B_2, 15
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, B_1, 13
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, A#2, 11
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, A#1, 9
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, A_2, 7
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2, NOTE_DURATION_28, G_1, 5
	audio_wait 2
	pitch_offset 2
	audio_wait 2
	note A_2
	audio_wait 2
	note C_3
	audio_wait 2
	note D#3
	audio_wait 2
	note F#3
	audio_wait 2
	note D_4
	audio_wait 2
	note F#4
	audio_wait 2
	note D_5
	audio_wait 2
	note G_5
	audio_wait 2
	note E_6
	audio_wait 2
	note G#6
	audio_wait 2
	note C_7
	audio_wait 2
	note G_7
	audio_wait 2
	note E_2
	audio_end

Sfx_ScowlerDefeated:
	db 1, 0
	dw Sfx_ScowlerDefeated_Ch1

Sfx_Pesce2_Ch1:
	semitone_offset 1
	tempo 74
	wave WAVE_32
	volume 113
	note NOTE_DURATION_4, F_1, 29
	audio_wait 5
	note NOTE_DURATION_4
	audio_wait 5
	note NOTE_DURATION_4, A_1
	audio_wait 5
	audio_end

Sfx_Pesce2:
	db 1, 0
	dw Sfx_Pesce2_Ch1

Sfx_Pesce1_Ch1:
	semitone_offset 2
	tempo 74
	wave WAVE_3B
	volume 85
	note NOTE_DURATION_6, C_2, 19
	audio_wait 12
	wave WAVE_42
	note NOTE_DURATION_6, C_2, 19
	audio_wait 12
	audio_end

Sfx_Pesce1:
	db 1, 0
	dw Sfx_Pesce1_Ch1

Sfx_AnonsterWalk_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_44
	volume 120
	note NOTE_DURATION_2, C_2, 31
	audio_wait 4
	note B_1
	audio_wait 4
	note C_2
	audio_wait 4
	note B_1
	audio_wait 4
	audio_end

Sfx_AnonsterWalk:
	db 1, 0
	dw Sfx_AnonsterWalk_Ch1

Sfx_Anonster1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 66
	pitch_offset_mult 7
	vibrato_amplitude 10
	note NOTE_DURATION_40, F_2, 17
	audio_wait 4
	pitch_offset -6
	audio_wait 1
	note A_1
	audio_wait 1
	note A_0
	audio_wait 1
	note 30
	audio_wait 1
	note 22
	audio_wait 1
	note 4
	audio_wait 1
	note 1
	audio_wait 20
	note 13
	audio_wait 1
	note 21
	audio_wait 1
	note C#0
	audio_wait 1
	note G#0
	audio_wait 1
	note D#1
	audio_wait 1
	note G_1
	audio_wait 1
	note G#1
	audio_wait 1
	note A_1
	audio_wait 1
	note C_2
	audio_wait 1
	note E_2
	audio_wait 1
	audio_end

Sfx_Anonster1_Ch2:
	semitone_offset 0
	wave WAVE_40
	volume 120
	pitch_offset 0
	note NOTE_DURATION_12, C_2, 31
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 43
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 39
	pitch_offset -8
	audio_wait 1
	vibrato_amplitude 32
	pitch_offset -40
	audio_wait 1
	note D#0
	audio_wait 1
	vibrato_amplitude 24
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 11
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 7
	pitch_offset -86
	audio_wait 1
	vibrato_amplitude 6
	pitch_offset -88
	audio_wait 1
	note 19
	audio_wait 1
	vibrato_amplitude 4
	audio_wait 1
	note 7
	pitch_offset 0
	note NOTE_DURATION_12, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 21
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 33
	pitch_offset -8
	audio_wait 1
	vibrato_amplitude 41
	pitch_offset -40
	audio_wait 1
	vibrato_amplitude 49
	pitch_offset -50
	audio_wait 1
	vibrato_amplitude 51
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 54
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 53
	pitch_offset -86
	audio_wait 1
	note 20
	audio_wait 1
	vibrato_amplitude 43
	pitch_offset -90
	audio_wait 1
	vibrato_amplitude 37
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_12, 12
	audio_wait 1
	vibrato_amplitude 25
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 22
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	vibrato_amplitude 26
	pitch_offset -50
	audio_wait 1
	vibrato_amplitude 34
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 46
	pitch_offset -84
	audio_wait 1
	note 21
	audio_wait 1
	vibrato_amplitude 77
	pitch_offset -88
	audio_wait 1
	vibrato_amplitude 81
	pitch_offset -90
	audio_wait 2
	note E_2, NOTE_DURATION_12, 7
	audio_wait 1
	vibrato_amplitude 77
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 68
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	vibrato_amplitude 55
	pitch_offset -40
	audio_wait 1
	vibrato_amplitude 28
	pitch_offset -50
	audio_wait 1
	note 27
	audio_wait 1
	vibrato_amplitude 18
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 12
	pitch_offset -86
	audio_wait 1
	note 20
	audio_wait 1
	vibrato_amplitude 15
	pitch_offset -90
	audio_wait 2
	vibrato_amplitude 37
	audio_wait 1
	note E_1
	audio_wait 1
	note G_2
	audio_wait 1
	note C#3
	audio_wait 1
	note D#3
	audio_wait 1
	note C#3
	audio_wait 1
	note G#2
	audio_wait 1
	note C#2
	audio_wait 1
	note F_1
	audio_wait 1
	note G#0
	audio_wait 1
	note C#0
	audio_wait 1
	note 32
	audio_wait 1
	note 31
	audio_wait 3
	note 34
	audio_wait 1
	note A#0
	audio_wait 1
	note C_2
	audio_wait 1
	note D#3
	audio_wait 1
	note B_3
	audio_wait 1
	note E_4
	audio_wait 1
	note F#4
	audio_wait 2
	note F_4
	audio_wait 1
	note B_3
	audio_wait 1
	note E_3
	audio_wait 1
	note G#2
	audio_wait 1
	note C#2
	audio_wait 2
	note F_1
	audio_wait 1
	note B_0
	audio_wait 1
	note F#0
	audio_wait 1
	note D_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 33
	audio_wait 1
	note 32
	audio_wait 1
	note 31
	audio_end

Sfx_Anonster1:
	db 2, 0
	dw Sfx_Anonster1_Ch1
	dw Sfx_Anonster1_Ch2

Sfx_Anonster2_Ch1:
	semitone_offset 5
	tempo 74
	wave WAVE_6F
	volume 120
	note NOTE_DURATION_2, C_2, 31
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note A#1
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	audio_end

Sfx_Anonster2:
	db 1, 0
	dw Sfx_Anonster2_Ch1

Sfx_0b2_Ch1:
	semitone_offset 5
	tempo 74
	wave WAVE_6F
	volume 120
	note NOTE_DURATION_2, F#1, 31
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note C_2
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note A#1
	audio_wait 2
	note B_1
	audio_wait 2
	note E_2
	audio_wait 2
	note D#2
	audio_wait 2
	note D_2
	audio_wait 2
	note C#2
	audio_wait 2
	note C#2
	audio_wait 2
	note D_2
	audio_wait 2
	audio_end

Sfx_0b2_Ch2:
	semitone_offset 2
	wave WAVE_65
	volume 94
	note NOTE_DURATION_3, C_2, 24
	audio_wait 3
	note C#2
	audio_wait 3
	note D_2
	audio_wait 3
	note D#2
	audio_wait 3
	note NOTE_DURATION_3, C#2, 22
	audio_wait 3
	note D_2
	audio_wait 3
	note D#2
	audio_wait 3
	note E_2
	audio_wait 3
	note NOTE_DURATION_3, D_2, 19
	audio_wait 3
	note D#2
	audio_wait 3
	note E_2
	audio_wait 3
	note F_2
	audio_wait 3
	note NOTE_DURATION_3, D#2, 17
	audio_wait 3
	note E_2
	audio_wait 3
	note F_2
	audio_wait 3
	note F#2
	audio_wait 3
	note NOTE_DURATION_3, E_2, 14
	audio_wait 3
	note F_2
	audio_wait 3
	note F#2
	audio_wait 3
	note G_2
	audio_wait 3
	note NOTE_DURATION_3, F_2, 12
	audio_wait 3
	note F#2
	audio_wait 3
	note G_2
	audio_wait 3
	note G#2
	audio_wait 3
	note NOTE_DURATION_3, F#2, 9
	audio_wait 3
	note G_2
	audio_wait 3
	note G#2
	audio_wait 3
	note A_2
	audio_wait 3
	note NOTE_DURATION_3, G_2, 7
	audio_wait 3
	note G#2
	audio_wait 3
	note A_2
	audio_wait 3
	note A#2
	audio_wait 3
	audio_end

Sfx_0b2:
	db 2, 0
	dw Sfx_0b2_Ch1
	dw Sfx_0b2_Ch2

Sfx_ScowlerStunned_Ch1:
	volume 120
	semitone_offset 0
	tempo 74
	wave WAVE_63
	vibrato_amplitude 100
	pitch_offset_mult 10
	pitch_offset 0
	note NOTE_DURATION_28, C_1, 29
	pitch_offset -18
	audio_wait 2
	note A#0
	audio_wait 2
	note E_0
	audio_wait 2
	note C#0
	audio_wait 2
	note 34
	audio_wait 2
	note 30
	audio_wait 2
	note 27
	audio_wait 2
	note 25
	audio_wait 2
	note 22
	audio_wait 2
	note 20
	audio_wait 2
	note 16
	audio_wait 2
	note 13
	audio_wait 2
	note 5
	audio_wait 2
	note 2
	audio_wait 2
	audio_end

Sfx_ScowlerStunned:
	db 1, 0
	dw Sfx_ScowlerStunned_Ch1

Sfx_ScowlerStomped_Ch1:
	semitone_offset 244
	tempo 74
	wave WAVE_63
	volume 120
	vibrato_amplitude 100
	note NOTE_DURATION_4, G_2, 24
	audio_wait 2
	pitch_offset -2
	audio_wait 1
	note C_2
	audio_wait 1
	note A#1, NOTE_DURATION_4, G#2
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note E_1
	audio_wait 1
	note F#0
	audio_wait 1
	note C#0, NOTE_DURATION_4, A_2
	audio_wait 1
	pitch_offset -64
	audio_wait 1
	note 23
	audio_wait 1
	note 18
	audio_wait 1
	note 14, NOTE_DURATION_4, A#2
	audio_wait 1
	pitch_offset -106
	audio_wait 1
	note 5
	audio_wait 1
	note 4
	audio_wait 1
	note 3, NOTE_DURATION_4, B_2
	audio_wait 3
	pitch_offset -120
	audio_wait 1
	note 6, NOTE_DURATION_4, C_3
	audio_wait 1
	pitch_offset -110
	audio_wait 1
	note 17
	audio_wait 1
	note 22
	audio_wait 1
	note 27, NOTE_DURATION_4, C#3
	audio_wait 1
	pitch_offset -64
	audio_wait 1
	note F#0
	audio_wait 1
	note C_1
	audio_wait 1
	note E_1, NOTE_DURATION_4, C_3
	audio_wait 1
	pitch_offset -2
	audio_wait 1
	note G#2
	audio_wait 1
	note C#3
	audio_wait 1
	note F_3, NOTE_DURATION_4, B_2
	audio_wait 1
	pitch_offset 44
	audio_wait 1
	note G_4
	audio_wait 1
	note A#4
	audio_wait 1
	note D_5, NOTE_DURATION_4, A#2
	audio_wait 1
	pitch_offset 78
	audio_wait 1
	note A_5
	audio_wait 1
	note A#5
	audio_wait 1
	note B_5, NOTE_DURATION_4, A_2
	audio_wait 1
	pitch_offset 88
	audio_wait 3
	note A#5, NOTE_DURATION_4, G#2
	audio_wait 1
	pitch_offset 78
	audio_wait 1
	note D#5
	audio_wait 1
	note A#4
	audio_wait 1
	note E_4, NOTE_DURATION_24, G_2
	audio_wait 1
	pitch_offset 24
	audio_wait 1
	note B_2
	audio_wait 1
	note F_2
	audio_wait 1
	note C_2
	audio_wait 1
	note D_1
	audio_wait 1
	note A#0
	audio_wait 1
	note G_0
	audio_wait 1
	note E_0
	audio_wait 1
	note 33
	audio_wait 1
	note 31
	audio_wait 1
	note 29
	audio_wait 1
	note 27
	audio_wait 1
	note 24
	audio_wait 5
	note 25
	audio_wait 1
	note 27
	audio_wait 1
	note 31
	audio_wait 1
	note 34
	audio_wait 1
	note D#0
	audio_wait 1
	note G_0
	audio_wait 1
	note C_1
	audio_wait 1
	note A#1
	audio_wait 1
	note D_2
	audio_wait 1
	note F_2
	audio_wait 1
	note C#3
	audio_wait 1
	note E_3
	audio_wait 1
	note G_3
	audio_wait 1
	note C#4
	audio_wait 2
	note F#4
	audio_wait 1
	note A_4
	audio_wait 1
	note C_5
	audio_wait 1
	note F_5
	audio_wait 1
	note G_5
	audio_wait 1
	note A_5
	audio_wait 4
	note E_2
	audio_wait 1
	note C#6
	audio_wait 1
	note E_2
	audio_end

Sfx_ScowlerStomped:
	db 1, 0
	dw Sfx_ScowlerStomped_Ch1

Sfx_ScowlerInk1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_4B
	vibrato_amplitude 0
	volume 75
	pitch_offset 0
	note NOTE_DURATION_2, G_4, 15
	audio_wait 2
	note D#5
	audio_wait 2
	note F#4
	audio_wait 2
	note D_4
	audio_wait 2
	note F_5
	audio_wait 2
	note C#4
	audio_wait 2
	note G_3
	audio_wait 2
	audio_end

Sfx_ScowlerInk1_Ch2:
	semitone_offset 0
	wave WAVE_1A
	vibrato_amplitude 0
	volume 56
	pitch_offset 0
	audio_wait 8
	note NOTE_DURATION_2, G_4, 15
	audio_wait 2
	note D#5
	audio_wait 2
	note F#4
	audio_wait 2
	note D_4
	audio_wait 2
	note F_5
	audio_wait 2
	note C#4
	audio_wait 2
	note G_3
	audio_wait 2
	audio_end

Sfx_ScowlerInk1:
	db 2, 0
	dw Sfx_ScowlerInk1_Ch1
	dw Sfx_ScowlerInk1_Ch2

Sfx_ScowlerBlackout_Ch1:
	semitone_offset 255
	tempo 74
	wave WAVE_4B
	vibrato_amplitude 0
	volume 75
	pitch_offset 0
	note NOTE_DURATION_2, G_4, 19
	audio_wait 2
	note D#5
	audio_wait 2
	note F#4
	audio_wait 2
	note D_4
	audio_wait 2
	note F_5
	audio_wait 2
	note C#4
	audio_wait 2
	note G_3
	audio_wait 2
	audio_end

Sfx_ScowlerBlackout_Ch2:
	semitone_offset 255
	wave WAVE_1A
	vibrato_amplitude 0
	volume 56
	pitch_offset 0
	audio_wait 8
	note NOTE_DURATION_2, G_4, 15
	audio_wait 2
	note D#5
	audio_wait 2
	note F#4
	audio_wait 2
	note D_4
	audio_wait 2
	note F_5
	audio_wait 2
	note C#4
	audio_wait 2
	note G_3
	audio_wait 2
	audio_end

Sfx_ScowlerBlackout:
	db 2, 0
	dw Sfx_ScowlerBlackout_Ch1
	dw Sfx_ScowlerBlackout_Ch2

Sfx_0b7_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_4B
	vibrato_amplitude 0
	volume 75
	pitch_offset 0
	note NOTE_DURATION_3, G_3, 15
	audio_wait 3
	note C#4
	audio_wait 3
	note F_5
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note D#5
	audio_wait 3
	note G_4
	audio_wait 3
	audio_end

Sfx_0b7_Ch2:
	semitone_offset 0
	wave WAVE_1A
	volume 56
	vibrato_amplitude 0
	pitch_offset 0
	audio_wait 9
	note NOTE_DURATION_3, G_3, 15
	audio_wait 3
	note C#4
	audio_wait 3
	note F_5
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note D#5
	audio_wait 3
	note G_4
	audio_wait 3
	audio_end

Sfx_0b7:
	db 2, 0
	dw Sfx_0b7_Ch1
	dw Sfx_0b7_Ch2

Sfx_ScowlerInk2_Ch1:
	semitone_offset 1
	tempo 74
	wave WAVE_4B
	vibrato_amplitude 0
	volume 75
	pitch_offset 0
	note NOTE_DURATION_3, G_3, 15
	audio_wait 3
	note C#4
	audio_wait 3
	note F_5
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note D#5
	audio_wait 3
	note G_4
	audio_wait 3
	audio_end

Sfx_ScowlerInk2_Ch2:
	semitone_offset 1
	wave WAVE_1A
	volume 56
	vibrato_amplitude 0
	pitch_offset 0
	audio_wait 9
	note NOTE_DURATION_3, G_3, 15
	audio_wait 3
	note C#4
	audio_wait 3
	note F_5
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note D#5
	audio_wait 3
	note G_4
	audio_wait 3
	audio_end

Sfx_ScowlerInk2:
	db 2, 0
	dw Sfx_ScowlerInk2_Ch1
	dw Sfx_ScowlerInk2_Ch2

Sfx_0b9_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_32
	volume 113
	note NOTE_DURATION_4, A_1, 29
	audio_wait 5
	note NOTE_DURATION_4
	audio_wait 5
	note NOTE_DURATION_4
	audio_wait 5
	note NOTE_DURATION_4, B_1
	audio_wait 5
	note NOTE_DURATION_4
	audio_wait 5
	note NOTE_DURATION_4
	audio_wait 5
	note NOTE_DURATION_4, C_2
	audio_wait 5
	audio_end

Sfx_0b9:
	db 1, 0
	dw Sfx_0b9_Ch1

Sfx_Pump_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3C
	volume 120
	note NOTE_DURATION_12, E_3, 24
	audio_wait 12
	audio_end

Sfx_Pump_Ch2:
	semitone_offset 0
	wave WAVE_69
	volume 120
	note NOTE_DURATION_1, D_2, 10
	audio_wait 2
	note G_3, 17
	audio_wait 2
	note D_3, 24
	audio_wait 2
	audio_end

Sfx_Pump:
	db 2, 0
	dw Sfx_Pump_Ch1
	dw Sfx_Pump_Ch2

Sfx_PesceHit_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 113
	note NOTE_DURATION_2, C_4, 17
	audio_wait 2
	note D_4
	audio_wait 2
	note E_4
	audio_wait 2
	note F_4
	audio_wait 2
	note C_5
	audio_wait 2
	note NOTE_DURATION_2, C_4, 11
	audio_wait 2
	note D_4
	audio_wait 2
	note E_4
	audio_wait 2
	note F_4
	audio_wait 2
	note C_5
	audio_wait 2
	audio_end

Sfx_PesceHit_Ch2:
	semitone_offset 0
	wave WAVE_60
	volume 113
	note NOTE_DURATION_2, E_3, 17
	audio_wait 2
	note F_3
	audio_wait 2
	note G_3
	audio_wait 2
	note A_3
	audio_wait 2
	note E_4
	audio_wait 2
	note NOTE_DURATION_2, E_3, 11
	audio_wait 2
	note F_3
	audio_wait 2
	note G_3
	audio_wait 2
	note A_3
	audio_wait 2
	note E_4
	audio_wait 2
	audio_end

Sfx_PesceHit:
	db 2, 0
	dw Sfx_PesceHit_Ch1
	dw Sfx_PesceHit_Ch2

Sfx_JamanoTurn_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	note NOTE_DURATION_8, C#5, 9
	audio_wait 8
	note C_5
	audio_wait 8
	note G_4, 17
	audio_wait 8
	note C#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note G_4, 24
	audio_wait 8
	note C#5, 19
	audio_wait 8
	note C_5, 12
	audio_wait 8
	note C#5, 9
	audio_wait 8
	note C_5
	audio_wait 8
	note G_4, 17
	audio_wait 8
	note C#5
	audio_wait 8
	note C_5, 22
	audio_wait 8
	note G_4, 24
	audio_wait 8
	note C#5, 19
	audio_wait 8
	note C_5, 12
	audio_wait 8
	audio_end

Sfx_JamanoTurn:
	db 1, 0
	dw Sfx_JamanoTurn_Ch1

Sfx_JamanoDefeatPose_Ch1:
	semitone_offset 2
	tempo 74
	wave WAVE_63
	vibrato_amplitude 100
	volume 113
	note NOTE_DURATION_2, C_5, 29
	audio_wait 2
	note C_4
	audio_wait 2
	note C_3
	audio_wait 2
	note C_2
	audio_wait 2
	note B_4
	audio_wait 2
	note B_3
	audio_wait 2
	note B_2
	audio_wait 2
	note B_1
	audio_wait 2
	note A#4
	audio_wait 2
	note A#3
	audio_wait 2
	note A#2
	audio_wait 2
	note A#1
	audio_wait 2
	note A_4
	audio_wait 2
	note A_3
	audio_wait 2
	note A_2
	audio_wait 2
	note A_1
	audio_wait 2
	note G#4
	audio_wait 2
	note G#3
	audio_wait 2
	note G#2
	audio_wait 2
	note G#1
	audio_wait 2
	note NOTE_DURATION_2, C_5, 29
	audio_wait 2
	note C_4
	audio_wait 2
	note C_3
	audio_wait 2
	note C_2
	audio_wait 2
	note B_4
	audio_wait 2
	note B_3
	audio_wait 2
	note B_2
	audio_wait 2
	note B_1
	audio_wait 2
	note A#4
	audio_wait 2
	note A#3
	audio_wait 2
	note A#2
	audio_wait 2
	note A#1
	audio_wait 2
	note A_4
	audio_wait 2
	note A_3
	audio_wait 2
	note A_2
	audio_wait 2
	note A_1
	audio_wait 2
	note G#4
	audio_wait 2
	note G#3
	audio_wait 2
	note G#2
	audio_wait 2
	note G#1
	audio_wait 2
	note NOTE_DURATION_2, C_5, 29
	audio_wait 2
	note C_4
	audio_wait 2
	note C_3
	audio_wait 2
	note C_2
	audio_wait 2
	note B_4
	audio_wait 2
	note B_3
	audio_wait 2
	note B_2
	audio_wait 2
	note B_1
	audio_wait 2
	note A#4
	audio_wait 2
	note A#3
	audio_wait 2
	note A#2
	audio_wait 2
	note A#1
	audio_wait 2
	note A_4
	audio_wait 2
	note A_3
	audio_wait 2
	note A_2
	audio_wait 2
	note A_1
	audio_wait 2
	note G#4
	audio_wait 2
	note G#3
	audio_wait 2
	note G#2
	audio_wait 2
	note G#1
	audio_wait 2
	note G_4, 24
	audio_wait 2
	note G_3
	audio_wait 2
	note G_2
	audio_wait 2
	note G_1
	audio_wait 2
	note G_4, 17
	audio_wait 2
	note G_3
	audio_wait 2
	note G_2
	audio_wait 2
	note G_1
	audio_wait 2
	note G_4, 12
	audio_wait 2
	note G_3
	audio_wait 2
	note G_2
	audio_wait 2
	note G_1
	audio_wait 2
	audio_end

Sfx_JamanoDefeatPose:
	db 1, 0
	dw Sfx_JamanoDefeatPose_Ch1

Sfx_PesceFly_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_63
	volume 94
	pitch_offset 6
	pitch_offset_mult 5
	note NOTE_DURATION_12, E_3, 24
	audio_wait 1
	pitch_offset 14
	audio_wait 1
	note B_3
	audio_wait 1
	note A#4
	audio_wait 1
	note A#6
	audio_wait 1
	note G_7
	audio_wait 6
	note E_2
	audio_wait 1
	note NOTE_DURATION_12, F_3, 31
	audio_wait 1
	pitch_offset 14
	audio_wait 1
	note B_3
	audio_wait 1
	note A#4
	audio_wait 1
	note A#6
	audio_wait 1
	note G_7
	audio_wait 6
	note E_2
	audio_wait 1
	audio_end

Sfx_PesceFly:
	db 1, 0
	dw Sfx_PesceFly_Ch1

Sfx_JamanoSkull_Ch1:
	semitone_offset 12
	tempo 74
	wave WAVE_63
	volume 113
	note NOTE_DURATION_2, C_1, 29
	audio_wait 2
	note C#1
	audio_wait 2
	note D_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note NOTE_DURATION_2, C_1, 17
	audio_wait 2
	note C#1
	audio_wait 2
	note D_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	audio_end

Sfx_JamanoSkull:
	db 1, 0
	dw Sfx_JamanoSkull_Ch1

Sfx_MuddeeHurt_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_63
	vibrato_amplitude 100
	volume 113
	note NOTE_DURATION_2, C_3, 29
	audio_wait 2
	note F#2
	audio_wait 2
	note C#2
	audio_wait 2
	note B_2
	audio_wait 2
	note F_2
	audio_wait 2
	note C_2
	audio_wait 2
	note A#2
	audio_wait 2
	note E_2
	audio_wait 2
	note B_1
	audio_wait 2
	note A_2
	audio_wait 2
	note D#2
	audio_wait 2
	note A#1
	audio_wait 2
	note G#2
	audio_wait 2
	note D_2
	audio_wait 2
	note A_1
	audio_wait 2
	note G_2
	audio_wait 2
	note C#2
	audio_wait 2
	note G#1
	audio_wait 2
	note F#2
	audio_wait 2
	note C_2
	audio_wait 2
	note G_1
	audio_wait 2
	note F_2
	audio_wait 2
	note B_1
	audio_wait 2
	note F#1
	audio_wait 2
	note E_2
	audio_wait 2
	note A#1
	audio_wait 2
	note F_1
	audio_wait 2
	note D#2
	audio_wait 2
	note A_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D_2
	audio_wait 2
	note G#1
	audio_wait 2
	note D#1
	audio_wait 2
	note C#2
	audio_wait 2
	note G_1
	audio_wait 2
	note D_1
	audio_wait 2
	note C_2
	audio_wait 2
	note C#1
	audio_wait 2
	note F#1
	audio_wait 2
	audio_end

Sfx_MuddeeHurt:
	db 1, 0
	dw Sfx_MuddeeHurt_Ch1

Sfx_MuddeeBubble_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_60
	volume 108
	note NOTE_DURATION_1, C#2, 28
	audio_wait 3
	note C#2
	audio_wait 3
	note C#2
	audio_wait 2
	audio_end

Sfx_MuddeeBubble_Ch2:
	semitone_offset 0
	wave WAVE_65
	volume 113
	note NOTE_DURATION_8, F_1, 24
	audio_wait 8
	audio_end

Sfx_MuddeeBubble:
	db 2, 0
	dw Sfx_MuddeeBubble_Ch1
	dw Sfx_MuddeeBubble_Ch2

Sfx_MagicSpiralGrow_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	note NOTE_DURATION_4, C#5, 9
	audio_wait 4
	note C_5
	audio_wait 4
	note B_4, 17
	audio_wait 4
	note A#4
	audio_wait 4
	note C#5, 22
	audio_wait 4
	note C_5, 24
	audio_wait 4
	note B_4, 19
	audio_wait 4
	note A#4, 12
	audio_wait 4
	note C#5, 9
	audio_wait 4
	note C_5
	audio_wait 4
	note B_4, 17
	audio_wait 4
	note A#4
	audio_wait 4
	note C#5, 22
	audio_wait 4
	note C_5, 24
	audio_wait 4
	note B_4, 19
	audio_wait 4
	note A#4, 12
	audio_wait 4
	note C#5, 9
	audio_wait 4
	note C_5
	audio_wait 4
	note B_4, 17
	audio_wait 4
	note A#4
	audio_wait 4
	note C#5, 22
	audio_wait 4
	note C_5, 24
	audio_wait 4
	note B_4, 19
	audio_wait 4
	note A#4, 12
	audio_wait 4
	audio_end

Sfx_MagicSpiralGrow:
	db 1, 0
	dw Sfx_MagicSpiralGrow_Ch1

Sfx_WolfenbossHover_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_44
	volume 75
	note NOTE_DURATION_10, F_2, 19
	audio_wait 20
	audio_end

Sfx_WolfenbossHover:
	db 1, 0
	dw Sfx_WolfenbossHover_Ch1

Sfx_0c4_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3D
	volume 94
	note NOTE_DURATION_10, C_3, 17
	audio_wait 10
	audio_end

Sfx_0c4:
	db 1, 0
	dw Sfx_0c4_Ch1

Sfx_Igaguri_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	note NOTE_DURATION_1, B_5, 24
	audio_wait 6
	note F#4
	audio_wait 14
	audio_end

Sfx_Igaguri:
	db 1, 0
	dw Sfx_Igaguri_Ch1

Sfx_ShootTaunt_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3B
	volume 75
	note NOTE_DURATION_2, C_1, 24
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note F_1
	audio_wait 2
	audio_end

Sfx_ShootTaunt:
	db 1, 0
	dw Sfx_ShootTaunt_Ch1

Sfx_ShootGoal_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0D
	vibrato_speed 127
	vibrato_delay 0
	vibrato_amplitude 50
	vibrato_disabled FALSE
	volume 103
	note NOTE_DURATION_5, E_3, 27
	audio_wait 12
	note NOTE_DURATION_24
	audio_wait 24
	vibrato_amplitude 0
	wave WAVE_64
	volume 120
	pitch_offset_mult 10
	note NOTE_DURATION_24, D_5, 31
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note F_2
	audio_wait 1
	note D_2
	audio_wait 1
	note C_2
	audio_wait 1
	note A#1
	audio_wait 1
	note F_1
	audio_wait 1
	note D#1
	audio_wait 2
	note C_1
	audio_wait 2
	note A#0
	audio_wait 2
	note B_0
	audio_wait 2
	note D_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G#1
	audio_wait 2
	note C#2
	audio_wait 2
	note E_2
	audio_wait 1
	note NOTE_DURATION_5, 19
	audio_wait 5
	audio_end

Sfx_ShootGoal_Ch2:
	semitone_offset 0
	wave WAVE_5D
	vibrato_speed 127
	vibrato_delay 0
	vibrato_amplitude 50
	vibrato_disabled FALSE
	volume 103
	note NOTE_DURATION_5, D_3, 27
	audio_wait 12
	note NOTE_DURATION_24
	audio_wait 24
	vibrato_amplitude 0
	wave WAVE_68
	volume 85
	note NOTE_DURATION_12, B_1, 16
	audio_wait 12
	wave WAVE_65
	note NOTE_DURATION_4, B_1, 18
	audio_wait 4
	note NOTE_DURATION_8, B_1, 20
	audio_wait 8
	note NOTE_DURATION_8, B_1, 22
	audio_wait 8
	note NOTE_DURATION_16, B_1, 24
	audio_wait 16
	note NOTE_DURATION_36, B_1, 27
	audio_wait 36
	note NOTE_DURATION_8, B_1, 22
	audio_wait 8
	wave WAVE_66
	note NOTE_DURATION_24, B_1, 18
	audio_wait 24
	audio_end

Sfx_ShootGoal:
	db 2, 0
	dw Sfx_ShootGoal_Ch1
	dw Sfx_ShootGoal_Ch2

Sfx_ShootJump_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_40
	volume 120
	pitch_offset 0
	note NOTE_DURATION_12, E_1, 24
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 43
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 39
	pitch_offset -8
	audio_wait 1
	vibrato_amplitude 32
	pitch_offset -40
	audio_wait 1
	note D#0
	audio_wait 1
	vibrato_amplitude 24
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 11
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 7
	pitch_offset -86
	audio_wait 1
	vibrato_amplitude 6
	pitch_offset -88
	audio_wait 1
	note 19
	audio_wait 1
	vibrato_amplitude 4
	audio_wait 1
	note 7
	pitch_offset 0
	note NOTE_DURATION_12, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 21
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 33
	pitch_offset -8
	audio_wait 1
	vibrato_amplitude 41
	pitch_offset -40
	audio_wait 1
	vibrato_amplitude 49
	pitch_offset -50
	audio_wait 1
	vibrato_amplitude 51
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 54
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 53
	pitch_offset -86
	audio_wait 1
	note 20
	audio_wait 1
	vibrato_amplitude 43
	pitch_offset -90
	audio_wait 1
	vibrato_amplitude 37
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_12, 12
	audio_wait 1
	vibrato_amplitude 25
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 22
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	vibrato_amplitude 26
	pitch_offset -50
	audio_wait 1
	vibrato_amplitude 34
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 46
	pitch_offset -84
	audio_wait 1
	note 21
	audio_wait 1
	vibrato_amplitude 77
	pitch_offset -88
	audio_wait 1
	vibrato_amplitude 81
	pitch_offset -90
	audio_wait 2
	note E_2, NOTE_DURATION_12, 7
	audio_wait 1
	vibrato_amplitude 77
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 68
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	vibrato_amplitude 55
	pitch_offset -40
	audio_wait 1
	vibrato_amplitude 28
	pitch_offset -50
	audio_wait 1
	note 27
	audio_wait 1
	vibrato_amplitude 18
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 12
	pitch_offset -86
	audio_wait 1
	note 20
	audio_wait 1
	vibrato_amplitude 15
	pitch_offset -90
	audio_wait 2
	vibrato_amplitude 37
	audio_wait 1
	note E_1
	audio_wait 1
	note G_2
	audio_wait 1
	note C#3
	audio_wait 1
	note D#3
	audio_wait 1
	note C#3
	audio_wait 1
	note G#2
	audio_wait 1
	note C#2
	audio_wait 1
	note F_1
	audio_wait 1
	note G#0
	audio_wait 1
	note C#0
	audio_wait 1
	note 32
	audio_wait 1
	note 31
	audio_wait 3
	note 34
	audio_wait 1
	note A#0
	audio_wait 1
	note C_2
	audio_wait 1
	note D#3
	audio_wait 1
	note B_3
	audio_wait 1
	note E_4
	audio_wait 1
	note F#4
	audio_wait 2
	note F_4
	audio_wait 1
	note B_3
	audio_wait 1
	note E_3
	audio_wait 1
	note G#2
	audio_wait 1
	note C#2
	audio_wait 2
	note F_1
	audio_wait 1
	note B_0
	audio_wait 1
	note F#0
	audio_wait 1
	note D_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 33
	audio_wait 1
	note 32
	audio_wait 1
	note 31
	audio_end

Sfx_ShootJump:
	db 1, 0
	dw Sfx_ShootJump_Ch1

Sfx_Shoot_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_34
	volume 120
	note NOTE_DURATION_2, A_1, 31
	audio_wait 6
	note G#2
	audio_wait 2
	audio_end

Sfx_Shoot:
	db 1, 0
	dw Sfx_Shoot_Ch1

Sfx_BossAppear_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_1A
	volume 75
	note NOTE_DURATION_3, G_1, 19
	audio_wait 4
	note D_2
	audio_wait 4
	note C#2
	audio_wait 4
	note C_2
	audio_wait 4
	note F_2
	audio_wait 4
	note B_2
	audio_wait 4
	note F_2, 12
	audio_wait 4
	note B_2
	audio_wait 4
	note F_3, 9
	audio_wait 4
	note B_3
	audio_wait 4
	note F_3
	audio_wait 4
	note B_3
	audio_wait 4
	note F_4, 7
	audio_wait 4
	note B_4
	audio_wait 4
	note F_4
	audio_wait 4
	note B_4
	audio_wait 4
	audio_end

Sfx_BossAppear_Ch2:
	semitone_offset 0
	wave WAVE_10
	volume 75
	note NOTE_DURATION_3, G_0, 19
	audio_wait 4
	note D_1
	audio_wait 4
	note C#1
	audio_wait 4
	note C_1
	audio_wait 4
	note F_1
	audio_wait 4
	note B_1
	audio_wait 4
	note F_1, 12
	audio_wait 4
	note B_1
	audio_wait 4
	note F_2, 9
	audio_wait 4
	note B_2
	audio_wait 4
	note F_2
	audio_wait 4
	note B_2
	audio_wait 4
	note F_3, 7
	audio_wait 4
	note B_3
	audio_wait 4
	note F_3
	audio_wait 4
	note B_3
	audio_wait 4
	audio_end

Sfx_BossAppear:
	db 2, 0
	dw Sfx_BossAppear_Ch1
	dw Sfx_BossAppear_Ch2

Sfx_HiddenFigureHand1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 94
	note NOTE_DURATION_1, G_1, 29
	audio_wait 1
	note G#1
	audio_wait 1
	note A_1
	audio_wait 1
	note A#1
	audio_wait 1
	note B_1
	audio_wait 1
	note C_2
	audio_wait 1
	note C#2
	audio_wait 1
	note D_2
	audio_wait 1
	note D#2
	audio_wait 1
	note E_2
	audio_wait 1
	note F_2
	audio_wait 1
	note F#2
	audio_wait 1
	note G_2
	audio_wait 1
	note NOTE_DURATION_1, G#2, 7
	audio_wait 1
	note A_2
	audio_wait 1
	note A#2
	audio_wait 1
	note B_2, 5
	audio_wait 1
	note C_3
	audio_wait 1
	audio_end

Sfx_HiddenFigureHand1:
	db 1, 0
	dw Sfx_HiddenFigureHand1_Ch1

Sfx_0cc_Ch1:
	semitone_offset 4
	tempo 74
	wave WAVE_5C
	vibrato_amplitude 80
	volume 113
	pitch_offset 0

.sub1
	note NOTE_DURATION_14, C_2, 24
	audio_wait 2
	pitch_offset -18
	audio_wait 2
	note C#1
	audio_wait 2
	note E_0
	audio_wait 2
	note C_0
	audio_wait 2
	note 34
	audio_wait 2
	note 33
	audio_wait 2
	note E_2, NOTE_DURATION_14, C_2, 12
	audio_wait 2
	pitch_offset -18
	audio_wait 2
	note C#1
	audio_wait 2
	note E_0
	audio_wait 2
	note C_0
	audio_wait 2
	note 34
	audio_wait 2
	note 33
	audio_wait 2
	note E_2, NOTE_DURATION_7, F_1, 24
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note C#1
	audio_wait 1
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_7, F_1, 12
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note C#1
	audio_wait 1
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_7, D_1, 24
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note C#1
	audio_wait 1
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_7, D_1, 12
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note C#1
	audio_wait 1
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_7, C#1, 24
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note C#1
	audio_wait 1
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_7, C#1, 12
	audio_wait 1
	pitch_offset -18
	audio_wait 1
	note C#1
	audio_wait 1
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_10, C_1, 24
	audio_wait 2
	pitch_offset -18
	audio_wait 2
	note C#1
	audio_wait 2
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_10, C_1, 12
	audio_wait 2
	pitch_offset -18
	audio_wait 2
	note C#1
	audio_wait 2
	note E_0
	audio_wait 1
	note C_0
	audio_wait 1
	note 34
	audio_wait 1
	note 33
	audio_wait 1
	note E_2, NOTE_DURATION_14, B_0, 24
	audio_wait 2
	pitch_offset -18
	audio_wait 2
	note C#1
	audio_wait 2
	note E_0
	audio_wait 2
	note C_0
	audio_wait 2
	note 34
	audio_wait 2
	note 33
	audio_wait 2
	note E_2, NOTE_DURATION_14, B_0, 12
	audio_wait 2
	pitch_offset -18
	audio_wait 2
	note C#1
	audio_wait 2
	note E_0
	audio_wait 2
	note C_0
	audio_wait 2
	note 34
	audio_wait 2
	note 33
	audio_wait 2
	note E_2
	audio_ret

	audio_end

Sfx_0cc_Ch2:
	semitone_offset 4
	tempo 74
	wave WAVE_0A
	vibrato_amplitude 80
	volume 113
	pitch_offset 0
	audio_wait 6
	audio_call Sfx_0cc_Ch1.sub1
	audio_end

Sfx_0cc:
	db 2, 0
	dw Sfx_0cc_Ch1
	dw Sfx_0cc_Ch2

Sfx_HiddenFigureGrab_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	vibrato_amplitude 50
	volume 94
	vibrato_amplitude 58
	pitch_offset 0
	note NOTE_DURATION_6, C_3, 22
	audio_wait 1
	vibrato_amplitude 62
	audio_wait 1
	note D#2
	audio_wait 1
	note E_2
	audio_wait 3
	note NOTE_DURATION_6, B_2
	audio_wait 6
	note A#2
	audio_wait 6
	note A_2
	audio_wait 6
	note G#2
	audio_wait 9
	vibrato_amplitude 63
	audio_wait 1
	note D_2
	audio_wait 1
	note A#1
	audio_wait 1
	note G_1
	audio_wait 1
	note C_1
	audio_wait 1
	note D#0
	audio_wait 1
	note 34
	audio_wait 1
	note 26
	audio_wait 1
	note 20
	audio_wait 1
	note 12
	audio_wait 1
	note 8
	audio_wait 1
	note 2
	audio_wait 1
	note 0
	audio_end

Sfx_HiddenFigureGrab_Ch2:
	semitone_offset 0
	wave WAVE_1A
	vibrato_amplitude 0
	volume 66
	pitch_offset 0
	audio_wait 6
	vibrato_amplitude 58
	note NOTE_DURATION_6, C_3, 22
	audio_wait 1
	vibrato_amplitude 62
	audio_wait 1
	note D#2
	audio_wait 1
	note E_2
	audio_wait 3
	note NOTE_DURATION_6, B_2
	audio_wait 6
	note A#2
	audio_wait 6
	note A_2
	audio_wait 6
	note G#2
	audio_wait 9
	vibrato_amplitude 63
	audio_wait 1
	note D_2
	audio_wait 1
	note A#1
	audio_wait 1
	note G_1
	audio_wait 1
	note C_1
	audio_wait 1
	note D#0
	audio_wait 1
	note 34
	audio_wait 1
	note 26
	audio_wait 1
	note 20
	audio_wait 1
	note 12
	audio_wait 1
	note 8
	audio_wait 1
	note 2
	audio_wait 1
	note 0
	audio_end

Sfx_HiddenFigureGrab_Ch3:
	semitone_offset 0
	wave WAVE_60
	vibrato_amplitude 0
	volume 47
	pitch_offset 0
	audio_wait 12
	vibrato_amplitude 58
	note NOTE_DURATION_6, C_3, 22
	audio_wait 1
	vibrato_amplitude 62
	audio_wait 1
	note D#2
	audio_wait 1
	note E_2
	audio_wait 3
	note NOTE_DURATION_6, B_2
	audio_wait 6
	note A#2
	audio_wait 6
	note A_2
	audio_wait 6
	note G#2
	audio_wait 9
	vibrato_amplitude 63
	audio_wait 1
	note D_2
	audio_wait 1
	note A#1
	audio_wait 1
	note G_1
	audio_wait 1
	note C_1
	audio_wait 1
	note D#0
	audio_wait 1
	note 34
	audio_wait 1
	note 26
	audio_wait 1
	note 20
	audio_wait 1
	note 12
	audio_wait 1
	note 8
	audio_wait 1
	note 2
	audio_wait 1
	note 0
	audio_end

Sfx_HiddenFigureGrab:
	db 3, 0
	dw Sfx_HiddenFigureGrab_Ch1
	dw Sfx_HiddenFigureGrab_Ch2
	dw Sfx_HiddenFigureGrab_Ch3

Sfx_HiddenFigureHit_Ch1:
	semitone_offset 241
	tempo 74
	wave WAVE_63
	volume 120
	note NOTE_DURATION_2, F_1, 31
	audio_wait 2
	note F#1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_2
	audio_wait 2
	note C_3
	audio_wait 2
	note G#2
	audio_wait 2
	note C#3
	audio_wait 2
	note F#2
	audio_wait 2
	note B_2
	audio_wait 2
	note G_2
	audio_wait 2
	note C_3
	audio_wait 2
	note F_2
	audio_wait 2
	note A#2
	audio_wait 2
	note F#2
	audio_wait 2
	note B_2
	audio_wait 2
	note E_2
	audio_wait 2
	note A_2
	audio_wait 2
	note F_2
	audio_wait 2
	note A#2
	audio_wait 2
	note D#2
	audio_wait 2
	note G#2
	audio_wait 2
	note E_2
	audio_wait 2
	note A_2
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	audio_end

Sfx_HiddenFigureHit_Ch2:
	semitone_offset 241
	tempo 74
	wave WAVE_0A
	volume 113
	audio_wait 6
	note NOTE_DURATION_2, F_1, 29
	audio_wait 2
	note F#1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_2
	audio_wait 2
	note C_3
	audio_wait 2
	note G#2
	audio_wait 2
	note C#3
	audio_wait 2
	note F#2
	audio_wait 2
	note B_2
	audio_wait 2
	note G_2
	audio_wait 2
	note C_3
	audio_wait 2
	note F_2
	audio_wait 2
	note A#2
	audio_wait 2
	note F#2
	audio_wait 2
	note B_2
	audio_wait 2
	note E_2
	audio_wait 2
	note A_2
	audio_wait 2
	note F_2
	audio_wait 2
	note A#2
	audio_wait 2
	note D#2
	audio_wait 2
	note G#2
	audio_wait 2
	note E_2
	audio_wait 2
	note A_2
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	audio_end

Sfx_HiddenFigureHit:
	db 2, 0
	dw Sfx_HiddenFigureHit_Ch1
	dw Sfx_HiddenFigureHit_Ch2

Sfx_HiddenFigureDefeated_Ch1:
	semitone_offset 250
	tempo 74
	wave WAVE_63
	vibrato_amplitude 50
	volume 120
	note NOTE_DURATION_2, C_2, 31
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note D_1
	audio_wait 2
	note D#1
	audio_wait 2
	note D_1
	audio_wait 2
	note C#1
	audio_wait 2
	note D_1
	audio_wait 2
	note C#1
	audio_wait 2
	note C_1
	audio_wait 2
	note C#1
	audio_wait 2
	note C_1
	audio_wait 2
	note B_0
	audio_wait 2
	audio_end

Sfx_HiddenFigureDefeated_Ch2:
	semitone_offset 0
	wave WAVE_0A
	vibrato_amplitude 50
	volume 120
	note NOTE_DURATION_2, C_2, 31
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note B_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note A#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note A_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note G#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note G_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note F#1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note F_1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note E_1
	audio_wait 2
	note D#1
	audio_wait 2
	note D_1
	audio_wait 2
	note D#1
	audio_wait 2
	note D_1
	audio_wait 2
	note C#1
	audio_wait 2
	note D_1
	audio_wait 2
	note C#1
	audio_wait 2
	note C_1
	audio_wait 2
	note C#1
	audio_wait 2
	note C_1
	audio_wait 2
	note B_0
	audio_wait 2
	audio_end

Sfx_HiddenFigureDefeated:
	db 2, 0
	dw Sfx_HiddenFigureDefeated_Ch1
	dw Sfx_HiddenFigureDefeated_Ch2

Sfx_HiddenFigureHand2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 113
	note NOTE_DURATION_1, E_2, 29
	audio_wait 1
	note E_2, 25
	audio_wait 1
	note E_2, 23
	audio_wait 1
	note D_2, 29
	audio_wait 1
	note D_2, 25
	audio_wait 1
	note D_2, 23
	audio_wait 1
	note C_2, 29
	audio_wait 1
	note C_2, 25
	audio_wait 1
	note C_2, 23
	audio_wait 1
	note B_1, 29
	audio_wait 1
	note B_1, 25
	audio_wait 1
	note B_1, 23
	audio_wait 1
	note A_1, 29
	audio_wait 1
	note A_1, 24
	audio_wait 1
	note A_1, 23
	audio_wait 1
	note G_1, 29
	audio_wait 1
	note G_1, 25
	audio_wait 1
	note G_1, 23
	audio_wait 1
	note F_1, 29
	audio_wait 1
	note F_1, 25
	audio_wait 1
	note F_1, 23
	audio_wait 1
	note E_1, 29
	audio_wait 1
	note E_1, 25
	audio_wait 1
	note E_1, 23
	audio_wait 1
	note D_1, 29
	audio_wait 1
	note D_1, 25
	audio_wait 1
	note D_1, 23
	audio_wait 1
	note C_1, 29
	audio_wait 1
	note C_1, 25
	audio_wait 1
	note C_1, 23
	audio_wait 1
	note D_1, 29
	audio_wait 1
	note D_1, 25
	audio_wait 1
	note D_1, 23
	audio_wait 1
	note E_1, 29
	audio_wait 1
	note E_1, 25
	audio_wait 1
	note E_1, 23
	audio_wait 1
	note F_1, 29
	audio_wait 1
	note F_1, 25
	audio_wait 1
	note F_1, 23
	audio_wait 1
	note G_1, 29
	audio_wait 1
	note G_1, 25
	audio_wait 1
	note G_1, 23
	audio_wait 1
	note A_1, 29
	audio_wait 1
	note A_1, 25
	audio_wait 1
	note A_1, 23
	audio_wait 1
	note B_1, 29
	audio_wait 1
	note B_1, 25
	audio_wait 1
	note B_1, 23
	audio_wait 1
	note C_2, 29
	audio_wait 1
	note C_2, 25
	audio_wait 1
	note C_2, 23
	audio_wait 1
	note D_2, 29
	audio_wait 1
	note D_2, 25
	audio_wait 1
	note D_2, 23
	audio_wait 1
	note E_2, 29
	audio_wait 1
	note E_2, 25
	audio_wait 1
	note E_2, 23
	audio_wait 1
	audio_end

Sfx_HiddenFigureHand2:
	db 1, 0
	dw Sfx_HiddenFigureHand2_Ch1

Sfx_HiddenFigureHand3_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_36
	vibrato_amplitude 0
	volume 94
	pitch_offset -50
	note NOTE_DURATION_13, C_1, 29
	audio_wait 2
	pitch_offset -88
	audio_wait 2
	note 0
	audio_wait 7
	note A#0
	audio_wait 2
	note C#6
	audio_wait 2
	note G_7
	audio_wait 22
	note E_2
	audio_end

Sfx_HiddenFigureHand3_Ch2:
	semitone_offset 244
	wave WAVE_6A
	vibrato_amplitude 0
	volume 94
	note NOTE_DURATION_1, G_3, 29
	audio_wait 1
	note F#3
	audio_wait 1
	note F_3
	audio_wait 1
	note E_3
	audio_wait 1
	note D#3
	audio_wait 1
	note D_3
	audio_wait 1
	note C#3
	audio_wait 1
	note C_3
	audio_wait 1
	note B_2
	audio_wait 1
	note A#2
	audio_wait 1
	note A_2
	audio_wait 1
	note G#2
	audio_wait 1
	note G_2
	audio_wait 1
	note NOTE_DURATION_1, F#2, 7
	audio_wait 1
	note F_2
	audio_wait 1
	note E_2
	audio_wait 1
	note D#2, 5
	audio_wait 1
	note D_2
	audio_wait 1
	note C#2, 3
	audio_wait 1
	note C_2
	audio_wait 1
	note B_1, 1
	audio_wait 1
	note A#1
	audio_wait 1
	note A_1
	audio_wait 1
	note G#1, 0
	audio_wait 1
	note G_1
	audio_wait 1
	audio_end

Sfx_HiddenFigureHand3:
	db 2, 0
	dw Sfx_HiddenFigureHand3_Ch1
	dw Sfx_HiddenFigureHand3_Ch2

Sfx_PipeExit_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_35
	volume 120
	note NOTE_DURATION_8, C_3, 24
	audio_wait 8
	note NOTE_DURATION_8
	audio_wait 8
	note NOTE_DURATION_8
	audio_wait 8
	note NOTE_DURATION_8
	audio_wait 8
	audio_end

Sfx_PipeExit:
	db 1, 0
	dw Sfx_PipeExit_Ch1

Sfx_MenuScroll_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3C
	volume 75
	note NOTE_DURATION_8, E_2, 19
	audio_wait 8
	audio_end

Sfx_MenuScroll:
	db 1, 0
	dw Sfx_MenuScroll_Ch1

Sfx_Selection_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 75
	note NOTE_DURATION_2, D_4, 19
	audio_wait 3
	note C#4
	audio_wait 3
	note A_3
	audio_wait 3
	note D_4
	audio_wait 3
	note F#4
	audio_wait 3
	note A_4
	audio_wait 3
	note D_5
	audio_wait 3
	note D_5, 9
	audio_wait 3
	audio_end

Sfx_Selection:
	db 1, 0
	dw Sfx_Selection_Ch1

Sfx_Pause_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_63
	volume 120
	note NOTE_DURATION_1, E_4, 31
	audio_wait 6
	note NOTE_DURATION_1, C_4, 31
	audio_wait 6
	note NOTE_DURATION_1, E_4, 31
	audio_wait 6
	note G_4
	audio_wait 2
	audio_end

Sfx_Pause:
	db 1, 0
	dw Sfx_Pause_Ch1

Sfx_Error_Ch1:
	semitone_offset 2
	tempo 74
	wave WAVE_0D
	vibrato_speed 127
	vibrato_delay 0
	vibrato_amplitude 50
	vibrato_disabled FALSE
	volume 120
	note NOTE_DURATION_5, F_1, 31
	audio_wait 12
	note NOTE_DURATION_24
	audio_wait 24
	audio_end

Sfx_Error_Ch2:
	semitone_offset 2
	wave WAVE_5D
	vibrato_speed 127
	vibrato_delay 0
	vibrato_amplitude 50
	vibrato_disabled FALSE
	volume 120
	note NOTE_DURATION_5, D#1, 31
	audio_wait 12
	note NOTE_DURATION_24
	audio_wait 24
	audio_end

Sfx_Error:
	db 2, 0
	dw Sfx_Error_Ch1
	dw Sfx_Error_Ch2

Sfx_EnterDoor_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_1B
	vibrato_amplitude 0
	volume 75
	note NOTE_DURATION_5, C_4, 17
	audio_wait 3
	note C#4
	audio_wait 6
	note D_4
	audio_wait 3
	note D#4
	audio_wait 6
	note E_4
	audio_wait 3
	note F_4
	audio_wait 6
	note F#4
	audio_wait 6
	note G_4
	audio_wait 5
	audio_end

Sfx_EnterDoor:
	db 1, 0
	dw Sfx_EnterDoor_Ch1

Sfx_MenuCancel_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 75
	note NOTE_DURATION_2, D_4, 19
	audio_wait 3
	note A_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D_3
	audio_wait 3
	note A_2
	audio_wait 3
	note C#3
	audio_wait 3
	note D_3
	audio_wait 3
	note D_3, 9
	audio_wait 3
	audio_end

Sfx_MenuCancel:
	db 1, 0
	dw Sfx_MenuCancel_Ch1

Sfx_GolfMiss_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_3C
	volume 120
	note NOTE_DURATION_14, A_3, 25
	audio_wait 14
	wave WAVE_10
	pitch_offset 8
	note NOTE_DURATION_10, G#0, 31
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 12
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 7
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 42
	note E_2
	pitch_offset 4
	note NOTE_DURATION_28, C_1, 31
	audio_wait 4
	pitch_offset 6
	audio_wait 1
	note C_3
	audio_wait 1
	note F#3
	audio_wait 1
	note C#4
	audio_wait 1
	note D#5
	audio_wait 1
	note A#5
	audio_wait 1
	note D_6
	audio_wait 1
	note A_6
	audio_wait 1
	note B_6
	audio_wait 2
	note F_7
	audio_wait 1
	note F#7
	audio_wait 2
	note F_7
	audio_wait 1
	note D#7
	audio_wait 1
	note B_6
	audio_wait 1
	note D#5
	audio_wait 1
	note C_4
	audio_wait 1
	note A#2
	audio_wait 10
	note E_2
	audio_end

Sfx_GolfMiss:
	db 1, 0
	dw Sfx_GolfMiss_Ch1

Sfx_MenuOpen_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 75
	pitch_offset_mult 20
	pitch_offset 2
	note NOTE_DURATION_18, F_1, 19
	audio_wait 5
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 2
	note B_3
	audio_wait 1
	note D_4
	audio_wait 1
	note A#4
	audio_wait 1
	note F#5
	audio_wait 1
	note A_5
	audio_wait 1
	note C#6
	audio_wait 1
	note G_6
	audio_wait 1
	note D_7
	audio_wait 1
	note F#7
	audio_wait 1
	audio_end

Sfx_MenuOpen:
	db 1, 0
	dw Sfx_MenuOpen_Ch1

Sfx_MenuClose_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 75
	pitch_offset_mult 20
	pitch_offset -2
	note NOTE_DURATION_18, C_3, 19
	audio_wait 5
	pitch_offset -4
	audio_wait 1
	note B_1
	audio_wait 1
	note F#1
	audio_wait 2
	note A_0
	audio_wait 1
	note F#0
	audio_wait 1
	note 34
	audio_wait 1
	note 26
	audio_wait 1
	note 23
	audio_wait 1
	note 19
	audio_wait 1
	note 13
	audio_wait 1
	note 6
	audio_wait 1
	note 2
	audio_wait 1
	audio_end

Sfx_MenuClose:
	db 1, 0
	dw Sfx_MenuClose_Ch1

Sfx_0eb_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_11
	vibrato_amplitude 0
	volume 85
	note NOTE_DURATION_3, C_4, 19
	audio_wait 4
	note C#4
	audio_wait 4
	note D_4
	audio_wait 4
	note D#4
	audio_wait 4
	note E_4
	audio_wait 4
	note F_4
	audio_wait 4
	note F#4
	audio_wait 4
	note G_4
	audio_wait 4
	note G#4
	audio_wait 4
	note A_4
	audio_wait 4
	note A#4
	audio_wait 4
	note A_4
	audio_wait 4
	note C_5
	audio_wait 4
	audio_end

Sfx_0eb_Ch2:
	semitone_offset 0
	wave WAVE_52
	volume 56
	vibrato_amplitude 0
	audio_wait 6
	note NOTE_DURATION_3, C_4, 14
	audio_wait 4
	note C#4
	audio_wait 4
	note D_4
	audio_wait 4
	note D#4
	audio_wait 4
	note E_4
	audio_wait 4
	note F_4
	audio_wait 4
	note F#4
	audio_wait 4
	note G_4
	audio_wait 4
	note G#4
	audio_wait 4
	note A_4
	audio_wait 4
	note A#4
	audio_wait 4
	note A_4
	audio_wait 4
	note C_5
	audio_wait 4
	audio_end

Sfx_0eb:
	db 2, 0
	dw Sfx_0eb_Ch1
	dw Sfx_0eb_Ch2

Sfx_ActionHelpButton_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_25
	volume 113
	note NOTE_DURATION_2, E_5, 29
	audio_wait 2
	note C_5
	audio_wait 2
	audio_end

Sfx_ActionHelpButton:
	db 1, 0
	dw Sfx_ActionHelpButton_Ch1

Sfx_GolfChargeShot_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_69
	volume 66
	note NOTE_DURATION_1, D_2, 13
	audio_wait 2
	note G_3, 18
	audio_wait 2
	note D_3, 31
	audio_wait 2
	note D_2, 13
	audio_wait 2
	note G_3, 18
	audio_wait 2
	note D_3, 31
	audio_wait 2
	note D_2, 13
	audio_wait 2
	note G_3, 18
	audio_wait 2
	note D_3, 31
	audio_wait 2
	note D_2, 13
	audio_wait 2
	note G_3, 18
	audio_wait 2
	note D_3, 31
	audio_wait 2
	audio_end

Sfx_GolfChargeShot:
	db 1, 0
	dw Sfx_GolfChargeShot_Ch1

Sfx_GolfSpecialTerrain2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	note NOTE_DURATION_8, G_4, 17
	audio_wait 8
	note E_4
	audio_wait 8
	note G_4, 9
	audio_wait 8
	note C_5
	audio_wait 8
	note G_4, 22
	audio_wait 8
	note E_4, 24
	audio_wait 8
	note G_4, 19
	audio_wait 8
	note C_5, 12
	audio_wait 8
	note G_4, 9
	audio_wait 8
	note E_4
	audio_wait 8
	note G_4, 17
	audio_wait 8
	note C_5
	audio_wait 8
	note G_4, 22
	audio_wait 8
	note E_4, 24
	audio_wait 8
	note G_4, 19
	audio_wait 8
	note C_5, 12
	audio_wait 8
	note G_4, 22
	audio_wait 8
	note E_4, 24
	audio_wait 8
	note G_4, 19
	audio_wait 8
	note C_5, 12
	audio_wait 8
	note G_4, 22
	audio_wait 8
	note E_4, 24
	audio_wait 8
	note G_4, 19
	audio_wait 8
	note C_5, 12
	audio_wait 8
	audio_end

Sfx_GolfSpecialTerrain2:
	db 1, 0
	dw Sfx_GolfSpecialTerrain2_Ch1

Sfx_GolfHoleIn_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	vibrato_amplitude 0
	volume 120
	note NOTE_DURATION_1, G_3, 31
	audio_wait 4
	note NOTE_DURATION_1, G_3, 29
	audio_wait 4
	note NOTE_DURATION_1, G_3, 24
	audio_wait 4
	note NOTE_DURATION_1, G_3, 19
	audio_wait 4
	note NOTE_DURATION_1, G_3, 14
	audio_wait 4
	audio_end

Sfx_GolfHoleIn:
	db 1, 0
	dw Sfx_GolfHoleIn_Ch1

Sfx_GolfSpecialTerrain1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	vibrato_amplitude 0
	pitch_offset 4
	note NOTE_DURATION_28, C_1, 31
	audio_wait 4
	pitch_offset 6
	audio_wait 1
	note C_3
	audio_wait 1
	note F#3
	audio_wait 1
	note C#4
	audio_wait 1
	note D#5
	audio_wait 1
	note A#5
	audio_wait 1
	note D_6
	audio_wait 1
	note A_6
	audio_wait 1
	note B_6
	audio_wait 2
	note F_7
	audio_wait 1
	note F#7
	audio_wait 2
	note F_7
	audio_wait 1
	note D#7
	audio_wait 1
	note B_6
	audio_wait 1
	note D#5
	audio_wait 1
	note C_4
	audio_wait 1
	note A#2
	audio_wait 10
	note E_2
	audio_end

Sfx_GolfSpecialTerrain1:
	db 1, 0
	dw Sfx_GolfSpecialTerrain1_Ch1

Sfx_0f1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	note NOTE_DURATION_1, C_2, 24
	audio_wait 3
	note D_3
	audio_wait 3
	note A#3
	audio_wait 3
	audio_end

Sfx_0f1:
	db 1, 0
	dw Sfx_0f1_Ch1

Sfx_0f2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	note NOTE_DURATION_1, F#3, 24
	audio_wait 6
	note B_4
	audio_wait 14
	audio_end

Sfx_0f2:
	db 1, 0
	dw Sfx_0f2_Ch1

Sfx_Prologue1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	vibrato_amplitude 30
	volume 94
	note NOTE_DURATION_14, C_3, 17
	audio_wait 14
	audio_end

Sfx_Prologue1:
	db 1, 0
	dw Sfx_Prologue1_Ch1

Sfx_Prologue2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_33
	volume 113
	note NOTE_DURATION_4, G#0, 19
	audio_wait 5
	note NOTE_DURATION_4, A#0, 22
	audio_wait 5
	note NOTE_DURATION_4, C_1, 24
	audio_wait 5
	note NOTE_DURATION_4, C#1, 27
	audio_wait 5
	note NOTE_DURATION_4, D#1, 31
	audio_wait 5
	audio_end

Sfx_Prologue2:
	db 1, 0
	dw Sfx_Prologue2_Ch1

Sfx_Snore_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 61
	note NOTE_DURATION_14, G_1, 16
	audio_wait 14
	wave WAVE_65
	note NOTE_DURATION_14, G_1, 19
	audio_wait 14
	note NOTE_DURATION_15, G_1, 23
	audio_wait 15
	note NOTE_DURATION_15, F_1, 19
	audio_wait 15
	note NOTE_DURATION_13, F_1, 16
	audio_wait 13
	note NOTE_DURATION_9, F_1, 14
	audio_wait 9
	wave WAVE_66
	note NOTE_DURATION_9, F_1, 12
	audio_wait 9
	audio_end

Sfx_Snore:
	db 1, 0
	dw Sfx_Snore_Ch1

Sfx_Plane1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 120
	note NOTE_DURATION_2, D_1, 31
	audio_wait 3
	note E_1
	audio_wait 3
	note D_1
	audio_wait 3
	note E_1
	audio_wait 3
	audio_end

Sfx_Plane1:
	db 1, 0
	dw Sfx_Plane1_Ch1

Sfx_Plane2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 105
	note NOTE_DURATION_2, D_1, 27
	audio_wait 3
	note E_1
	audio_wait 3
	note D_1
	audio_wait 3
	note E_1
	audio_wait 3
	audio_end

Sfx_Plane2:
	db 1, 0
	dw Sfx_Plane2_Ch1

Sfx_Plane3_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 94
	note NOTE_DURATION_2, D_1, 24
	audio_wait 3
	note E_1
	audio_wait 3
	note D_1
	audio_wait 3
	note E_1
	audio_wait 3
	audio_end

Sfx_Plane3:
	db 1, 0
	dw Sfx_Plane3_Ch1

Sfx_PlaneExplosion_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 120
	note NOTE_DURATION_4, G_1, 24
	audio_wait 4
	note A_1
	audio_wait 4
	note B_1
	audio_wait 4
	note C_2
	audio_wait 4
	note NOTE_DURATION_7, A_1, 19
	audio_wait 8
	note NOTE_DURATION_5, A_1, 12
	audio_wait 6
	note NOTE_DURATION_5, A_1, 7
	audio_wait 6
	audio_end

Sfx_PlaneExplosion:
	db 1, 0
	dw Sfx_PlaneExplosion_Ch1

Sfx_Success_Ch1:
	semitone_offset 0
	tempo 45
	wave WAVE_4B
	volume 66
	audio_wait 12
	note NOTE_DURATION_1, C_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, G_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, B_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, E_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, A_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, G_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	audio_end

Sfx_Success_Ch2:
	semitone_offset 0
	wave WAVE_55
	volume 113
	note NOTE_DURATION_1, C_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, G_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, B_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, E_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, A_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, G_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	audio_end

Sfx_Success_Ch3:
	semitone_offset 0
	wave WAVE_60
	volume 113
	note NOTE_DURATION_1, C_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, G_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, B_2, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, E_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, A_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, G_3, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	audio_end

Sfx_Success:
	db 3, 0
	dw Sfx_Success_Ch1
	dw Sfx_Success_Ch2
	dw Sfx_Success_Ch3

Sfx_101_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 94
	note NOTE_DURATION_1, G_3, 29
	audio_wait 1
	note F#3
	audio_wait 1
	note F_3
	audio_wait 1
	note E_3
	audio_wait 1
	note D#3
	audio_wait 1
	note D_3
	audio_wait 1
	note C#3
	audio_wait 1
	note C_3
	audio_wait 1
	note B_2
	audio_wait 1
	note A#2
	audio_wait 1
	note A_2
	audio_wait 1
	note G#2
	audio_wait 1
	note G_2
	audio_wait 1
	note NOTE_DURATION_1, F#2, 7
	audio_wait 1
	note F_2
	audio_wait 1
	note E_2
	audio_wait 1
	note D#2, 5
	audio_wait 1
	note D_2
	audio_wait 1
	note C#2, 3
	audio_wait 1
	note C_2
	audio_wait 1
	note B_1, 1
	audio_wait 1
	note A#1
	audio_wait 1
	note A_1
	audio_wait 1
	note G#1, 0
	audio_wait 1
	note G_1
	audio_wait 1
	audio_end

Sfx_101:
	db 1, 0
	dw Sfx_101_Ch1

Sfx_TreeFall_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 85
	pitch_offset_mult 14
	pitch_offset 0
	note NOTE_DURATION_7, C_1, 27
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_7, C_1, 19
	audio_wait 1
	pitch_offset 4
	audio_wait 1
	note A_2
	audio_wait 1
	note D_3
	audio_wait 1
	note E_5
	audio_wait 1
	note C_7
	audio_wait 1
	note G_7
	audio_wait 1
	audio_end

Sfx_TreeFall:
	db 1, 0
	dw Sfx_TreeFall_Ch1

Sfx_PathArrow_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 75
	pitch_offset 0
	note NOTE_DURATION_2, C_3, 19
	audio_wait 4
	note C#3
	audio_wait 4
	note D_3
	audio_wait 2
	audio_end

Sfx_PathArrow:
	db 1, 0
	dw Sfx_PathArrow_Ch1

Sfx_LevelStar_Ch1:
	semitone_offset 0
	wave WAVE_4A
	volume 94
	note NOTE_DURATION_1, C#5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, D_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C#5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, D_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C#5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, D_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C#5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, D_5, 24
	audio_wait 1
	note 12
	audio_wait 2
	note NOTE_DURATION_1, C#5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, D_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, C#5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, D_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, C#5, 17
	audio_wait 1
	note 7
	audio_wait 2
	note NOTE_DURATION_1, D_5, 17
	audio_wait 1
	note 7
	audio_wait 2
	audio_end

Sfx_LevelStar:
	db 1, 0
	dw Sfx_LevelStar_Ch1

Sfx_Gong_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	pitch_offset 8
	note NOTE_DURATION_10, F#0, 31
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 12
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2, NOTE_DURATION_10, 7
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	note G#2
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	note D#0
	audio_wait 1
	note 27
	audio_wait 1
	note 22
	audio_wait 1
	note 21
	audio_wait 1
	note 20
	audio_wait 1
	note E_2
	audio_end

Sfx_Gong_Ch2:
	semitone_offset 0
	wave WAVE_65
	vibrato_amplitude 46
	volume 75
	pitch_offset 0
	note NOTE_DURATION_12, D_2, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 43
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 39
	pitch_offset -8
	audio_wait 1
	vibrato_amplitude 32
	pitch_offset -40
	audio_wait 1
	note D#0
	audio_wait 1
	vibrato_amplitude 24
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 11
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 7
	pitch_offset -86
	audio_wait 1
	vibrato_amplitude 6
	pitch_offset -88
	audio_wait 1
	note 19
	audio_wait 1
	vibrato_amplitude 4
	audio_wait 1
	note 7
	pitch_offset 0
	note NOTE_DURATION_12, 19
	audio_wait 1
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 21
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 33
	pitch_offset -8
	audio_wait 1
	vibrato_amplitude 41
	pitch_offset -40
	audio_wait 1
	vibrato_amplitude 49
	pitch_offset -50
	audio_wait 1
	vibrato_amplitude 51
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 54
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 53
	pitch_offset -86
	audio_wait 1
	note 20
	audio_wait 1
	vibrato_amplitude 43
	pitch_offset -90
	audio_wait 1
	vibrato_amplitude 37
	audio_wait 1
	pitch_offset 0
	note NOTE_DURATION_12, 12
	audio_wait 1
	vibrato_amplitude 25
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 22
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	note G#0
	audio_wait 1
	vibrato_amplitude 26
	pitch_offset -50
	audio_wait 1
	vibrato_amplitude 34
	pitch_offset -74
	audio_wait 1
	vibrato_amplitude 46
	pitch_offset -84
	audio_wait 1
	note 21
	audio_wait 1
	vibrato_amplitude 77
	pitch_offset -88
	audio_wait 1
	vibrato_amplitude 81
	pitch_offset -90
	audio_wait 2
	note E_2, NOTE_DURATION_12, 7
	audio_wait 1
	vibrato_amplitude 77
	pitch_offset 8
	audio_wait 1
	vibrato_amplitude 68
	pitch_offset 8
	audio_wait 1
	note C_2
	audio_wait 1
	vibrato_amplitude 55
	pitch_offset -40
	audio_wait 1
	vibrato_amplitude 28
	pitch_offset -50
	audio_wait 1
	note 27
	audio_wait 1
	vibrato_amplitude 18
	pitch_offset -84
	audio_wait 1
	vibrato_amplitude 12
	pitch_offset -86
	audio_wait 1
	note 20
	audio_wait 1
	vibrato_amplitude 15
	pitch_offset -90
	audio_wait 2
	audio_end

Sfx_Gong:
	db 2, 0
	dw Sfx_Gong_Ch1
	dw Sfx_Gong_Ch2

Sfx_Emote_Ch1:
	semitone_offset 0
	tempo 74
	volume 120
	wave WAVE_0B
	note NOTE_DURATION_2, A#4, 31
	audio_wait 2
	note NOTE_DURATION_16, A#5
	audio_wait 16
	audio_end

Sfx_Emote:
	db 1, 0
	dw Sfx_Emote_Ch1

Sfx_HammerBotWalk_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	note NOTE_DURATION_2, C_4, 17
	audio_wait 2
	note NOTE_DURATION_2, D_4, 17
	audio_wait 2
	note NOTE_DURATION_2, E_4, 17
	audio_wait 2
	audio_end

Sfx_HammerBotWalk:
	db 1, 0
	dw Sfx_HammerBotWalk_Ch1

Sfx_GateOpen_Ch1:
	semitone_offset 0
	wave WAVE_65
	volume 113
	audio_wait 36
	note NOTE_DURATION_4, E_1, 31
	audio_wait 4
	note NOTE_DURATION_4, F_1, 24
	audio_wait 4
	note NOTE_DURATION_4, E_1, 31
	audio_wait 4
	note NOTE_DURATION_4, F_1, 24
	audio_wait 4
	note NOTE_DURATION_4, E_1, 31
	audio_wait 4
	note NOTE_DURATION_4, F_1, 24
	audio_wait 4
	note NOTE_DURATION_4, E_1, 31
	audio_wait 66
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	note NOTE_DURATION_4, F_1, 31
	audio_wait 4
	note NOTE_DURATION_4, E_1, 24
	audio_wait 4
	audio_end

Sfx_GateOpen:
	db 1, 0
	dw Sfx_GateOpen_Ch1

Sfx_FixElevator1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 56
	note NOTE_DURATION_1, C_5, 14
	audio_wait 3
	note G_4
	audio_wait 3
	audio_end

Sfx_FixElevator1_Ch2:
	semitone_offset 0
	wave WAVE_1A
	volume 56
	note NOTE_DURATION_1, F#4, 14
	audio_wait 3
	note C#4
	audio_wait 3
	audio_end

Sfx_FixElevator1:
	db 2, 0
	dw Sfx_FixElevator1_Ch1
	dw Sfx_FixElevator1_Ch2

Sfx_FixElevator_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 47
	pitch_offset_mult 7
	note NOTE_DURATION_28, C_2, 12
	audio_wait 4
	pitch_offset 6
	audio_wait 1
	note B_2
	audio_wait 1
	note B_3
	audio_wait 1
	note D_5
	audio_wait 1
	note A#5
	audio_wait 1
	note E_7
	audio_wait 1
	note G_7
	audio_wait 18
	audio_end

Sfx_FixElevator:
	db 1, 0
	dw Sfx_FixElevator_Ch1

Sfx_FixElevator2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_38
	volume 75
	note NOTE_DURATION_80, C_1, 19
	audio_wait 80
	audio_end

Sfx_FixElevator2:
	db 1, 0
	dw Sfx_FixElevator2_Ch1

Sfx_OpenNorthGate_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 120
	note NOTE_DURATION_3, G_1, 19
	audio_wait 3
	note G#1, 21
	audio_wait 3
	note A_1, 23
	audio_wait 3
	note NOTE_DURATION_2, A#1, 19
	audio_wait 3
	note NOTE_DURATION_4, B_1, 20
	audio_wait 3
	note NOTE_DURATION_5, C_2, 22
	audio_wait 3
	note NOTE_DURATION_2, C#2, 21
	audio_wait 3
	note NOTE_DURATION_4, D_2, 24
	audio_wait 3
	note NOTE_DURATION_2, D#2
	audio_wait 3
	note NOTE_DURATION_4, E_2
	audio_wait 3
	note NOTE_DURATION_2, F_2, 22
	audio_wait 3
	note F#2, 20
	audio_wait 3
	note G_2, 22
	audio_wait 3
	note G#2
	audio_wait 3
	note NOTE_DURATION_3, A_2
	audio_wait 3
	note NOTE_DURATION_2, A#2, 21
	audio_wait 3
	note NOTE_DURATION_4, B_2, 20
	audio_wait 3
	note NOTE_DURATION_2, C_3, 22
	audio_wait 3
	note C#3, 21
	audio_wait 3
	note NOTE_DURATION_3, D_3, 22
	audio_wait 3
	note NOTE_DURATION_2, D#3, 23
	audio_wait 3
	note NOTE_DURATION_5, E_3, 25
	audio_wait 3
	note NOTE_DURATION_2, F_3, 23
	audio_wait 3
	note NOTE_DURATION_5, F#3, 24
	audio_wait 3
	note G_3
	audio_wait 5
	audio_end

Sfx_OpenNorthGate:
	db 1, 0
	dw Sfx_OpenNorthGate_Ch1

Sfx_10d_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_45
	volume 120
	note NOTE_DURATION_6, F#3, 31
	audio_wait 6
	note NOTE_DURATION_2, F#3, 9
	audio_wait 2
	note NOTE_DURATION_2, F#3, 12
	audio_wait 2
	note NOTE_DURATION_2, F#3, 4
	audio_wait 2
	audio_end

Sfx_10d:
	db 1, 0
	dw Sfx_10d_Ch1

Sfx_10e_Ch1:
	semitone_offset 244
	tempo 74
	wave WAVE_4B
	vibrato_amplitude 0
	volume 85
	pitch_offset 0
	note NOTE_DURATION_3, G_2, 15
	audio_wait 3
	note C#3
	audio_wait 3
	note F_4
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D#4
	audio_wait 3
	note G_3
	audio_wait 3
	note G_2
	audio_wait 3
	note C#3
	audio_wait 3
	note F_4
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D#4
	audio_wait 3
	note G_3
	audio_wait 3
	note G_2
	audio_wait 3
	note C#3
	audio_wait 3
	note F_4
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D#4
	audio_wait 3
	note G_3
	audio_wait 3
	audio_end

Sfx_10e_Ch2:
	semitone_offset 244
	wave WAVE_1A
	volume 66
	vibrato_amplitude 0
	pitch_offset 0
	audio_wait 9
	note NOTE_DURATION_3, G_2, 15
	audio_wait 3
	note C#3
	audio_wait 3
	note F_4
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D#4
	audio_wait 3
	note G_3
	audio_wait 3
	note G_2
	audio_wait 3
	note C#3
	audio_wait 3
	note F_4
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D#4
	audio_wait 3
	note G_3
	audio_wait 3
	note G_2
	audio_wait 3
	note C#3
	audio_wait 3
	note F_4
	audio_wait 3
	note D_3
	audio_wait 3
	note F#3
	audio_wait 3
	note D#4
	audio_wait 3
	note G_3
	audio_wait 3
	audio_end

Sfx_10e:
	db 2, 0
	dw Sfx_10e_Ch1
	dw Sfx_10e_Ch2

Sfx_VolcanoEruption1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 94
	pitch_offset 0
	note NOTE_DURATION_3, G_1, 31
	audio_wait 3
	note NOTE_DURATION_7, F#1, 24
	audio_wait 7
	audio_end

Sfx_VolcanoEruption1:
	db 1, 0
	dw Sfx_VolcanoEruption1_Ch1

Sfx_VolcanoEruption2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	vibrato_amplitude 0
	volume 94
	pitch_offset 0
	note NOTE_DURATION_3, G_1, 31
	audio_wait 3
	note NOTE_DURATION_7, F#1, 24
	audio_wait 7
	audio_end

Sfx_VolcanoEruption2_Ch2:
	semitone_offset 0
	wave WAVE_10
	vibrato_amplitude 0
	volume 94
	pitch_offset 0
	note NOTE_DURATION_1, C_2, 24
	audio_wait 2
	note D_2
	audio_wait 2
	note E_2
	audio_wait 2
	note F_2
	audio_wait 2
	note G_2
	audio_wait 2
	audio_end

Sfx_VolcanoEruption2:
	db 2, 0
	dw Sfx_VolcanoEruption2_Ch1
	dw Sfx_VolcanoEruption2_Ch2

Sfx_VolcanoEruption3_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 120
	vibrato_amplitude 0
	note NOTE_DURATION_7, C_2, 28
	audio_wait 6
	note NOTE_DURATION_4, D_2
	audio_wait 4
	audio_end

Sfx_VolcanoEruption3:
	db 1, 0
	dw Sfx_VolcanoEruption3_Ch1

Sfx_ItemRaise_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_11
	vibrato_amplitude 0
	volume 85
	pitch_offset 0
	note NOTE_DURATION_4, C_2, 19
	audio_wait 3
	note F_2
	audio_wait 3
	note NOTE_DURATION_4, C#2, 24
	audio_wait 3
	note F#2
	audio_wait 3
	note NOTE_DURATION_4, D_2, 27
	audio_wait 3
	note G_2
	audio_wait 3
	note NOTE_DURATION_4, D#2, 29
	audio_wait 2
	note G#2
	audio_wait 4
	note NOTE_DURATION_4, E_2, 31
	audio_wait 3
	note A_2
	audio_wait 3
	note F_2
	audio_wait 3
	note A#2
	audio_wait 4
	audio_end

Sfx_ItemRaise_Ch2:
	semitone_offset 0
	wave WAVE_1B
	volume 66
	vibrato_amplitude 0
	pitch_offset 0
	audio_wait 3
	note NOTE_DURATION_4, C_2, 17
	audio_wait 3
	note F_2
	audio_wait 3
	note NOTE_DURATION_4, C#2, 22
	audio_wait 3
	note F#2
	audio_wait 3
	note NOTE_DURATION_4, D_2, 24
	audio_wait 3
	note G_2
	audio_wait 3
	note NOTE_DURATION_4, D#2, 27
	audio_wait 2
	note G#2
	audio_wait 4
	note NOTE_DURATION_4, E_2, 29
	audio_wait 3
	note A_2
	audio_wait 3
	note F_2
	audio_wait 3
	note A#2
	audio_wait 4
	audio_end

Sfx_ItemRaise_Ch3:
	semitone_offset 0
	wave WAVE_60
	volume 94
	vibrato_amplitude 0
	pitch_offset 0
	audio_wait 6
	note NOTE_DURATION_4, C_2, 17
	audio_wait 3
	note F_2
	audio_wait 3
	note NOTE_DURATION_4, C#2, 22
	audio_wait 3
	note F#2
	audio_wait 3
	note NOTE_DURATION_4, D_2, 24
	audio_wait 3
	note G_2
	audio_wait 3
	note NOTE_DURATION_4, D#2, 27
	audio_wait 2
	note G#2
	audio_wait 4
	note NOTE_DURATION_4, E_2, 29
	audio_wait 3
	note A_2
	audio_wait 3
	note F_2
	audio_wait 3
	note A#2
	audio_wait 4
	audio_end

Sfx_ItemRaise:
	db 3, 0
	dw Sfx_ItemRaise_Ch1
	dw Sfx_ItemRaise_Ch2
	dw Sfx_ItemRaise_Ch3

Sfx_113_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 113
	note NOTE_DURATION_2, D_3, 21
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	note D_3, 9
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	note D_3, 2
	audio_wait 3
	note G_3
	audio_wait 3
	note C_4
	audio_wait 3
	audio_end

Sfx_113:
	db 1, 0
	dw Sfx_113_Ch1

Sfx_VolcanoEruption4_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 85
	vibrato_amplitude 0
	note NOTE_DURATION_7, C_2, 24
	audio_wait 6
	note NOTE_DURATION_4, D_2
	audio_wait 4
	audio_end

Sfx_VolcanoEruption4:
	db 1, 0
	dw Sfx_VolcanoEruption4_Ch1

Sfx_VolcanoEruption5_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 66
	vibrato_amplitude 0
	note NOTE_DURATION_7, C_2, 17
	audio_wait 6
	note NOTE_DURATION_4, D_2
	audio_wait 4
	audio_end

Sfx_VolcanoEruption5:
	db 1, 0
	dw Sfx_VolcanoEruption5_Ch1

Sfx_VolcanoEruption6_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 47
	vibrato_amplitude 0
	note NOTE_DURATION_7, C_2, 12
	audio_wait 6
	note NOTE_DURATION_4, D_2
	audio_wait 4
	audio_end

Sfx_VolcanoEruption6:
	db 1, 0
	dw Sfx_VolcanoEruption6_Ch1

Sfx_SummonSnakes_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	volume 113
	vibrato_speed 20
	vibrato_delay 5
	vibrato_amplitude 20
	vibrato_disabled FALSE
	note NOTE_DURATION_48, C_3, 29
	audio_wait 72
	note D#3
	audio_wait 24
	audio_wait 48
	note E_3
	audio_wait 48
	audio_wait 24
	note_sustain
	note D#3
	audio_wait 72
	audio_wait 72
	note NOTE_DURATION_0
	audio_end

Sfx_SummonSnakes_Ch2:
	semitone_offset 1
	wave WAVE_14
	volume 85
	vibrato_speed 20
	vibrato_delay 5
	vibrato_amplitude 20
	vibrato_disabled FALSE
	audio_wait 8
	note NOTE_DURATION_48, C_3, 22
	audio_wait 72
	note D#3
	audio_wait 24
	audio_wait 48
	note E_3
	audio_wait 48
	audio_wait 24
	note_sustain
	note D#3
	audio_wait 72
	audio_wait 72
	note NOTE_DURATION_0
	audio_end

Sfx_SummonSnakes:
	db 2, 0
	dw Sfx_SummonSnakes_Ch1
	dw Sfx_SummonSnakes_Ch2

Sfx_Flute_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_46
	volume 85
	vibrato_speed 20
	vibrato_delay 5
	vibrato_amplitude 20
	vibrato_disabled FALSE
	note NOTE_DURATION_8, C_3, 22
	audio_wait 8
	note D#3
	audio_wait 8
	note E_3
	audio_wait 8
	note NOTE_DURATION_72, D#3
	audio_wait 72
	audio_end

Sfx_Flute_Ch2:
	semitone_offset 1
	wave WAVE_14
	volume 56
	vibrato_speed 20
	vibrato_delay 5
	vibrato_amplitude 20
	vibrato_disabled FALSE
	audio_wait 18
	note NOTE_DURATION_8, C_3, 14
	audio_wait 8
	note D#3
	audio_wait 8
	note E_3
	audio_wait 8
	note NOTE_DURATION_72, D#3
	audio_wait 72
	audio_end

Sfx_Flute:
	db 2, 0
	dw Sfx_Flute_Ch1
	dw Sfx_Flute_Ch2

Sfx_ItemFall_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 94
	pitch_offset 0
	pitch_offset_mult 10
	note NOTE_DURATION_24, E_4, 21
	audio_wait 7
	pitch_offset -2
	audio_wait 8
	note D_2
	audio_wait 9
	note NOTE_DURATION_24, E_4, 14
	pitch_offset -6
	audio_wait 10
	note C_2
	audio_wait 8
	note B_1
	audio_wait 2
	note A#1
	audio_wait 3
	note A_1
	audio_wait 1
	note NOTE_DURATION_30, E_4, 9
	pitch_offset -16
	audio_wait 11
	note G_1
	audio_wait 7
	note F#1
	audio_wait 6
	note F_1
	audio_wait 6
	note NOTE_DURATION_18, E_4, 7
	pitch_offset -24
	audio_wait 8
	note D#1
	audio_wait 3
	note D_1
	audio_wait 4
	note C#1
	audio_wait 3
	note NOTE_DURATION_11, E_4, 4
	pitch_offset -32
	audio_wait 4
	note B_0
	audio_wait 7
	audio_end

Sfx_ItemFall:
	db 1, 0
	dw Sfx_ItemFall_Ch1

Sfx_BeanstalkGrow_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_33
	volume 113
	note NOTE_DURATION_7, G#0, 19
	audio_wait 8
	note NOTE_DURATION_7, A#0, 22
	audio_wait 8
	note NOTE_DURATION_7, C_1, 24
	audio_wait 8
	note NOTE_DURATION_7, C#1, 27
	audio_wait 8
	note NOTE_DURATION_7, D#1, 31
	audio_wait 8
	audio_end

Sfx_BeanstalkGrow:
	db 1, 0
	dw Sfx_BeanstalkGrow_Ch1

Sfx_TowerRise_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 75
	note NOTE_DURATION_3, G_1, 19
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note G_1
	audio_wait 3
	note A_1
	audio_wait 3
	note B_1
	audio_wait 3
	audio_end

Sfx_TowerRise_Ch2:
	semitone_offset 0
	tempo 74
	wave WAVE_33
	volume 113
	audio_wait 44
	note NOTE_DURATION_7, G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 44
	audio_end

Sfx_TowerRise:
	db 2, 0
	dw Sfx_TowerRise_Ch1
	dw Sfx_TowerRise_Ch2

Sfx_SeaFreeze_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	vibrato_amplitude 0
	volume 120
	note NOTE_DURATION_1, F_3, 17
	audio_wait 10
	note F#3
	audio_wait 6
	note G_3
	audio_wait 6
	note G#3
	audio_wait 3
	note A_3
	audio_wait 3
	note A#3
	audio_wait 3
	note B_3
	audio_wait 3
	note C_4
	audio_wait 3
	note C#4
	audio_wait 3
	note D_4
	audio_wait 3
	note D#4
	audio_wait 3
	note E_4
	audio_wait 3
	note F_4
	audio_wait 3
	note F#4
	audio_wait 3
	note G_4
	audio_wait 3
	note G#4
	audio_wait 3
	note A_4
	audio_wait 3
	note A#4
	audio_wait 3
	note B_4
	audio_wait 3
	note C_5
	audio_wait 2
	audio_end

Sfx_SeaFreeze:
	db 1, 0
	dw Sfx_SeaFreeze_Ch1

Sfx_Tornado_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_33
	volume 94
	note NOTE_DURATION_3, G_1, 17
	audio_wait 3
	note G#1
	audio_wait 3
	note A_1
	audio_wait 3
	note A#1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note C#2
	audio_wait 3
	note C_2
	audio_wait 3
	note B_1
	audio_wait 3
	note A#1
	audio_wait 3
	note A_1
	audio_wait 3
	note G#1
	audio_wait 3
	note G_1
	audio_wait 3
	note F#1
	audio_wait 3
	note F_1
	audio_wait 3
	note E_1
	audio_wait 3
	note D#1
	audio_wait 3
	note D_1
	audio_wait 3
	note C#1
	audio_wait 3
	note C_1
	audio_wait 3
	note B_0
	audio_wait 3
	note A#0
	audio_wait 3
	note G_1
	audio_wait 3
	note G#1
	audio_wait 3
	note A_1
	audio_wait 3
	note A#1
	audio_wait 3
	note B_1
	audio_wait 3
	note C_2
	audio_wait 3
	note C#2
	audio_wait 3
	note C_2
	audio_wait 3
	note B_1
	audio_wait 3
	note A#1
	audio_wait 3
	note A_1
	audio_wait 3
	note G#1
	audio_wait 3
	note G_1
	audio_wait 3
	note F#1
	audio_wait 3
	note F_1
	audio_wait 3
	note E_1
	audio_wait 3
	note D#1
	audio_wait 3
	note D_1
	audio_wait 3
	note C#1
	audio_wait 3
	note C_1
	audio_wait 3
	note B_0
	audio_wait 3
	note A#0
	audio_wait 3
	audio_end

Sfx_Tornado:
	db 1, 0
	dw Sfx_Tornado_Ch1

Sfx_YellowMusicBox_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_19
	volume 75
	note NOTE_DURATION_36, C#5, 19
	audio_wait 48
	note NOTE_DURATION_24
	audio_wait 24
	note NOTE_DURATION_24, D_5
	audio_wait 24
	note NOTE_DURATION_72, E_5
	audio_wait 72
	note NOTE_DURATION_24, B_4
	audio_wait 24
	note NOTE_DURATION_72, C#5
	audio_wait 72
	audio_end

Sfx_YellowMusicBox_Ch2:
	semitone_offset 0
	wave WAVE_0F
	volume 75
	note NOTE_DURATION_60, A_4, 19
	audio_wait 72
	note NOTE_DURATION_24
	audio_wait 24
	note NOTE_DURATION_24, G#4
	audio_wait 24
	note F#4
	audio_wait 24
	note NOTE_DURATION_48, G#4
	audio_wait 48
	note NOTE_DURATION_72, A_4
	audio_wait 72
	audio_end

Sfx_YellowMusicBox:
	db 2, 0
	dw Sfx_YellowMusicBox_Ch1
	dw Sfx_YellowMusicBox_Ch2

Sfx_BlueMusicBox_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_19
	volume 75
	note NOTE_DURATION_48, F#4, 19
	audio_wait 48
	note NOTE_DURATION_24, G#4
	audio_wait 24
	note A_4
	audio_wait 24
	note NOTE_DURATION_48, E_4
	audio_wait 48
	note NOTE_DURATION_24, G#4
	audio_wait 24
	note A_4
	audio_wait 24
	note NOTE_DURATION_72, B_4
	audio_wait 72
	audio_end

Sfx_BlueMusicBox_Ch2:
	semitone_offset 0
	wave WAVE_0F
	volume 75
	note NOTE_DURATION_48, D_4, 19
	audio_wait 48
	note NOTE_DURATION_24, E_4
	audio_wait 24
	note F#4
	audio_wait 24
	note NOTE_DURATION_48, C#4
	audio_wait 48
	note NOTE_DURATION_24, E_4
	audio_wait 24
	note F#4
	audio_wait 24
	note NOTE_DURATION_72, G#4
	audio_wait 72
	audio_end

Sfx_BlueMusicBox:
	db 2, 0
	dw Sfx_BlueMusicBox_Ch1
	dw Sfx_BlueMusicBox_Ch2

Sfx_GreenMusicBox_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_19
	volume 75
	note NOTE_DURATION_48, A_4, 19
	audio_wait 48
	note NOTE_DURATION_24, C#5
	audio_wait 24
	note A_5
	audio_wait 24
	note NOTE_DURATION_72, G#5
	audio_wait 72
	note NOTE_DURATION_24, E_5
	audio_wait 24
	note NOTE_DURATION_72, A_5
	audio_wait 72
	audio_end

Sfx_GreenMusicBox_Ch2:
	semitone_offset 0
	wave WAVE_0F
	volume 75
	note NOTE_DURATION_48, F#4, 19
	audio_wait 48
	note NOTE_DURATION_24, A_4
	audio_wait 24
	note C#5
	audio_wait 24
	note NOTE_DURATION_72, B_4
	audio_wait 72
	note NOTE_DURATION_24
	audio_wait 24
	note NOTE_DURATION_72, C#5
	audio_wait 72
	audio_end

Sfx_GreenMusicBox:
	db 2, 0
	dw Sfx_GreenMusicBox_Ch1
	dw Sfx_GreenMusicBox_Ch2

Sfx_RedMusicBox_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_19
	volume 75
	note NOTE_DURATION_24, F#5, 19
	audio_wait 24
	note D_5
	audio_wait 24
	note A_4
	audio_wait 24
	note F#4
	audio_wait 24
	note NOTE_DURATION_48
	audio_wait 48
	note NOTE_DURATION_48, G#4
	audio_wait 48
	note NOTE_DURATION_72, A_4
	audio_wait 72
	audio_end

Sfx_RedMusicBox_Ch2:
	semitone_offset 0
	wave WAVE_0F
	volume 75
	note NOTE_DURATION_24, D_5, 19
	audio_wait 24
	note A_4
	audio_wait 24
	note F#4
	audio_wait 24
	note D_4
	audio_wait 24
	note NOTE_DURATION_48, B_3
	audio_wait 48
	note NOTE_DURATION_24, E_4
	audio_wait 24
	note D_4
	audio_wait 24
	note NOTE_DURATION_72, C#4
	audio_wait 72
	audio_end

Sfx_RedMusicBox:
	db 2, 0
	dw Sfx_RedMusicBox_Ch1
	dw Sfx_RedMusicBox_Ch2

Sfx_GoldMusicBox_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0F
	volume 75
	note NOTE_DURATION_24, A_3, 19
	audio_wait 24
	note C#4
	audio_wait 24
	note E_4
	audio_wait 24
	note A_4
	audio_wait 24
	note NOTE_DURATION_24, G#3
	audio_wait 24
	note B_3
	audio_wait 24
	note E_4
	audio_wait 24
	note G#4
	audio_wait 24
	note NOTE_DURATION_72, A_4
	audio_wait 72
	audio_end

Sfx_GoldMusicBox:
	db 1, 0
	dw Sfx_GoldMusicBox_Ch1

Sfx_BridgeLower_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_39
	volume 94
	vibrato_amplitude 0
	pitch_offset 0
	note NOTE_DURATION_48, G_1, 31
	audio_wait 48
	wave WAVE_6A
	note NOTE_DURATION_5, E_1, 31
	audio_wait 6
	note NOTE_DURATION_6, C_2, 24
	audio_wait 6
	note NOTE_DURATION_4, 14
	audio_wait 4
	note NOTE_DURATION_2, 9
	audio_wait 2
	note 4
	audio_wait 2
	note 2
	audio_wait 2
	audio_end

Sfx_BridgeLower:
	db 1, 0
	dw Sfx_BridgeLower_Ch1

Sfx_Lightning_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6B
	volume 120
	note NOTE_DURATION_7, A_1, 31
	audio_wait 8
	note NOTE_DURATION_5, G_1, 27
	audio_wait 6
	note NOTE_DURATION_5, F_1, 24
	audio_wait 6
	note NOTE_DURATION_5, E_1, 19
	audio_wait 6
	note NOTE_DURATION_5, D_1, 17
	audio_wait 6
	note NOTE_DURATION_5, D_1, 9
	audio_wait 6
	note NOTE_DURATION_5, D_1, 7
	audio_wait 6
	note NOTE_DURATION_5, D_1, 7
	audio_wait 6
	note NOTE_DURATION_5, D_1, 7
	audio_wait 6
	audio_end

Sfx_Lightning:
	db 1, 0
	dw Sfx_Lightning_Ch1

Sfx_BurnVines1_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 94
	note NOTE_DURATION_14, F_1, 24
	audio_wait 14
	audio_end

Sfx_BurnVines1:
	db 1, 0
	dw Sfx_BurnVines1_Ch1

Sfx_BurnVines2_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_68
	volume 75
	note NOTE_DURATION_14, F_1, 19
	audio_wait 14
	audio_end

Sfx_BurnVines2:
	db 1, 0
	dw Sfx_BurnVines2_Ch1

Sfx_VolcanoEruption_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_1A
	vibrato_amplitude 50
	vibrato_speed 50
	volume 56
	note NOTE_DURATION_72, F_3, 14
	audio_wait 72
	note F#3, 9
	audio_wait 72
	note G_3, 4
	audio_wait 72
	note G#3, 2
	audio_wait 72
	audio_end

Sfx_VolcanoEruption_Ch2:
	semitone_offset 0
	wave WAVE_60
	vibrato_amplitude 50
	vibrato_speed 50
	volume 75
	note NOTE_DURATION_72, C#3, 19
	audio_wait 72
	note D_3
	audio_wait 72
	note D#3, 14
	audio_wait 72
	note E_3
	audio_wait 72
	audio_end

Sfx_VolcanoEruption:
	db 2, 0
	dw Sfx_VolcanoEruption_Ch1
	dw Sfx_VolcanoEruption_Ch2

Sfx_WarpedVoidAppear_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	vibrato_amplitude 0
	volume 94
	note NOTE_DURATION_4, E_2, 24
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 19
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 14
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 9
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	note E_2, 4
	audio_wait 5
	note A_2
	audio_wait 5
	note D_3
	audio_wait 5
	note G_3
	audio_wait 5
	note D#3
	audio_wait 5
	note B_3
	audio_wait 5
	audio_end

Sfx_WarpedVoidAppear:
	db 1, 0
	dw Sfx_WarpedVoidAppear_Ch1

Sfx_Explosion_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 120
	note NOTE_DURATION_7, A_1, 19
	audio_wait 8
	note NOTE_DURATION_5, A_1, 12
	audio_wait 6
	note NOTE_DURATION_5, A_1, 7
	audio_wait 6
	audio_end

Sfx_Explosion:
	db 1, 0
	dw Sfx_Explosion_Ch1

Sfx_Step_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 113
	note NOTE_DURATION_1, D_2, 29
	audio_wait 4
	note A_1
	audio_wait 14
	note NOTE_DURATION_1, D_2, 17
	audio_wait 4
	note A_1
	audio_wait 14
	audio_end

Sfx_Step:
	db 1, 0
	dw Sfx_Step_Ch1

Sfx_PayCoins_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_60
	volume 94
	note NOTE_DURATION_3, C_4, 24
	audio_wait 4
	audio_end

Sfx_PayCoins:
	db 1, 0
	dw Sfx_PayCoins_Ch1

Sfx_OpenGoldenSnakeDoor_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_10
	volume 120
	note NOTE_DURATION_1, C_3, 31
	audio_wait 3
	note G_3
	audio_wait 3
	audio_end

Sfx_OpenGoldenSnakeDoor_Ch2:
	semitone_offset 0
	wave WAVE_1A
	volume 120
	note NOTE_DURATION_1, F#2, 31
	audio_wait 3
	note C#3
	audio_wait 3
	audio_end

Sfx_OpenGoldenSnakeDoor:
	db 2, 0
	dw Sfx_OpenGoldenSnakeDoor_Ch1
	dw Sfx_OpenGoldenSnakeDoor_Ch2

Sfx_CrayonScribble_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 66
	note NOTE_DURATION_8, C_3, 17
	audio_wait 10
	note G_2
	audio_wait 10
	note C_3
	audio_wait 10
	note G_2
	audio_wait 10
	note C_3
	audio_wait 10
	note G_2
	audio_wait 10
	note C_3
	audio_wait 10
	audio_end

Sfx_CrayonScribble:
	db 1, 2
	dw Sfx_CrayonScribble_Ch1

Sfx_CastleForm_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_33
	volume 113
	audio_wait 96
	audio_wait 96
	audio_wait 30
	note NOTE_DURATION_7, G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	note G#0, 19
	audio_wait 8
	note A#0, 22
	audio_wait 8
	note C_1, 24
	audio_wait 8
	note C#1, 27
	audio_wait 8
	note D#1, 31
	audio_wait 8
	audio_end

Sfx_CastleForm_Ch2:
	semitone_offset 0
	wave WAVE_1A
	vibrato_amplitude 50
	vibrato_speed 50
	volume 75
	note NOTE_DURATION_60, F_3, 19
	audio_wait 60
	note NOTE_DURATION_40, F#3
	audio_wait 40
	note G_3, 14
	audio_wait 40
	note G#3, 9
	audio_wait 40
	note NOTE_DURATION_20, A_3
	audio_wait 20
	note NOTE_DURATION_96, A#3
	audio_wait 96
	audio_end

Sfx_CastleForm_Ch3:
	semitone_offset 0
	wave WAVE_60
	vibrato_amplitude 50
	vibrato_speed 50
	volume 94
	note NOTE_DURATION_60, C#3, 24
	audio_wait 60
	note NOTE_DURATION_40, D_3
	audio_wait 40
	note D#3, 19
	audio_wait 40
	note E_3
	audio_wait 40
	note NOTE_DURATION_20, F_3
	audio_wait 20
	note NOTE_DURATION_96, F#3, 14
	audio_wait 96
	audio_end

Sfx_CastleForm_Ch4:
	semitone_offset 0
	wave WAVE_6A
	vibrato_amplitude 30
	volume 94
	audio_wait 96
	note NOTE_DURATION_96, C_3, 17
	audio_wait 96
	note NOTE_DURATION_30, C#3
	audio_wait 30
	audio_end

Sfx_CastleForm:
	db 4, 0
	dw Sfx_CastleForm_Ch1
	dw Sfx_CastleForm_Ch2
	dw Sfx_CastleForm_Ch3
	dw Sfx_CastleForm_Ch4

Sfx_12f_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 85
	audio_wait 10
	note NOTE_DURATION_2, G_3, 22
	audio_wait 3
	note NOTE_DURATION_2, G_3, 12
	audio_wait 3
	note NOTE_DURATION_2, G_3, 22
	audio_wait 3
	note NOTE_DURATION_2, G_3, 12
	audio_wait 3
	audio_end

Sfx_12f:
	db 1, 2
	dw Sfx_12f_Ch1

Sfx_TextPrint_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_6A
	volume 56
	note NOTE_DURATION_1, D_3, 9
	audio_wait 1
	note NOTE_DURATION_1, D_3, 14
	audio_wait 5
	audio_end

Sfx_TextPrint:
	db 1, 0
	dw Sfx_TextPrint_Ch1

Sfx_TreeMouthOpen_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 113
	note NOTE_DURATION_4, E_1, 31
	audio_wait 4
	note NOTE_DURATION_4, F_1, 24
	audio_wait 4
	audio_end

Sfx_TreeMouthOpen:
	db 1, 0
	dw Sfx_TreeMouthOpen_Ch1

Sfx_132_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_0A
	volume 120
	note NOTE_DURATION_1, G#2, 31
	audio_wait 3
	note E_0
	audio_wait 3
	note A#5
	audio_wait 10
	audio_end

Sfx_132:
	db 1, 0
	dw Sfx_132_Ch1

Sfx_MakeWire_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_64
	volume 120
	note NOTE_DURATION_1, B_4, 31
	audio_wait 6
	note F#3
	audio_wait 6
	audio_end

Sfx_MakeWire:
	db 1, 0
	dw Sfx_MakeWire_Ch1

Sfx_GameOver_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_39
	volume 75
	note NOTE_DURATION_80, D_2, 19
	audio_wait 80
	audio_end

Sfx_GameOver:
	db 1, 0
	dw Sfx_GameOver_Ch1

Sfx_OpenCraterHole_Ch1:
	semitone_offset 250
	tempo 74
	wave WAVE_6D
	volume 75
	note NOTE_DURATION_3, B_2, 19
	audio_wait 3
	note A#2
	audio_wait 3
	note A_2
	audio_wait 3
	note B_2
	audio_wait 3
	note A#2
	audio_wait 3
	note A_2
	audio_wait 3
	note B_2
	audio_wait 3
	note A#2
	audio_wait 3
	note A_2
	audio_wait 3
	audio_end

Sfx_OpenCraterHole:
	db 1, 0
	dw Sfx_OpenCraterHole_Ch1

Sfx_136_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_1A
	volume 94
	note NOTE_DURATION_1, C_2, 24
	audio_wait 3
	note D_3
	audio_wait 3
	note A#3
	audio_wait 3
	audio_end

Sfx_136:
	db 1, 0
	dw Sfx_136_Ch1

Sfx_SceneWarioRun_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 94
	note NOTE_DURATION_1, D_2, 24
	audio_wait 4
	note A_1
	audio_wait 4
	audio_end

Sfx_SceneWarioRun:
	db 1, 0
	dw Sfx_SceneWarioRun_Ch1

Sfx_EpilogueObj_Ch1:
	semitone_offset 0
	tempo 74
	wave WAVE_65
	volume 94
	note NOTE_DURATION_1, F_2, 24
	audio_wait 5
	note C_2
	audio_wait 10
	note NOTE_DURATION_1, F_2, 14
	audio_wait 5
	note C_2
	audio_wait 10
	audio_end

Sfx_EpilogueObj:
	db 1, 0
	dw Sfx_EpilogueObj_Ch1
