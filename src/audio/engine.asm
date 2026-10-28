PUSHO Q.6

_InitAudio::
	ld a, $ff
	ld [wAudioEngineFlags], a

	ld a, [wAudioBankBackup]
	push af
	ld hl, wAudioBankBackup
	ld b, wStartChannel + 1 - wAudioBankBackup
	xor a
.loop_clear
	ld [hli], a
	dec b
	jr nz, .loop_clear
	pop af
	ld [wAudioBankBackup], a

	ld a, 74
	ld [wSFXBaseTempo], a
	ld [wSFXTempo], a
	ld [wMusicBaseTempo], a
	ld [wMusicTempo], a
	ld a, 1.0
	ld [wSFXTempoMult], a
	ld [wMusicTempoMult], a

	ld a, -1
	ld [wCurWaveSample], a

; clear all channel structs
	xor a
	ld b, NUM_CHANNELS
	ld de, CHANNEL_STRUCT_LENGTH
	ld hl, wChannels
.loop_chs
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop_chs

; clear all tracks
	xor a
	ld b, NUM_TRACKS
	ld de, TRACK_STRUCT_LENGTH
	ld hl, wTracks
.loop_tracks
	ld [hl], a
	add hl, de
	dec b
	jr nz, .loop_tracks

	ld a, AUDENA_ON
	ldh [rAUDENA], a

	; disable all channels in right/left speaker
	ld a, $00
	ldh [rAUDTERM], a

	; init channel values
	ld a, AUD1ENV_UP
	ldh [rAUD1ENV], a
	ldh [rAUD2ENV], a ; AUD2ENV_UP
	ldh [rAUD4ENV], a ; AUD4ENV_UP
	ld a, AUD1HIGH_RESTART
	ldh [rAUD1HIGH], a ; AUD2HIGH_RESTART
	ldh [rAUD2HIGH], a ; AUD3HIGH_RESTART
	ldh [rAUD4GO], a   ; AUD4GO_RESTART
	ld a, AUD3ENA_OFF
	ldh [rAUD3ENA], a

	; enable all channels in right/left speaker
	ld a, AUDTERM_1_RIGHT | AUDTERM_2_RIGHT | AUDTERM_3_RIGHT | AUDTERM_4_RIGHT | AUDTERM_1_LEFT | AUDTERM_2_LEFT | AUDTERM_3_LEFT | AUDTERM_4_LEFT
	ldh [rAUDTERM], a

	; init volume to maximum value
	ld a, MAX_VOLUME
	ldh [rAUDVOL], a

	; clear audio engine flags
	ld a, $00
	ld [wAudioEngineFlags], a

	jp SwitchBackFromAudioBank

_UpdateAudio::
	push bc
	push de
	call UpdateMusicFadeOut

	ld hl, wAudioEngineFlags
	set AUDIOENG_HANDLING_SFX_F, [hl]

	ld hl, wSFXTempo
	ld a, [hli]
	add [hl]
	ld [hli], a ; wSFXTempoAccumulator += wSFXTempo
	ld a, 0
	adc [hl]
	ld [hld], a
	ld a, [hli] ; wSFXTempoAccumulator
	sub $4a
	ld b, a
	ld a, [hl]
	sbc 0
	jr nc, .tick_sfx

	; wSFXTempoAccumulator < $4a
	call SetSFXChannels
.loop_chs_1
	call RefreshChannel
	call NextChannel
	jr nz, .loop_chs_1
	jr .music

.tick_sfx
	; wSFXTempoAccumulator -= $4a
	ld [hld], a
	ld [hl], b

	call SetAllTracks
.loop_tracks
	call TickSFXTrack
	call NextTrack
	jr nz, .loop_tracks

	call SetSFXChannels
.loop_chs_2
	call UpdateChannel
	call NextChannel
	jr nz, .loop_chs_2

	ld hl, wSFXTempoAccumulator
	ld a, [hli]
	sub $4a
	ld b, a
	ld a, [hl]
	sbc 0
	jr nc, .tick_sfx

.music
	ld hl, wAudioEngineFlags
	res AUDIOENG_HANDLING_SFX_F, [hl]

	ld hl, wMusicTempo
	ld a, [hli]
	add [hl] ; wMusicTempoAccumulator
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hld], a
	ld a, [hli] ; wMusicTempoAccumulator
	sub $4a
	ld b, a
	ld a, [hl]
	sbc 0
	jr nc, .tick_music

	call SetMusicChannels
.loop_refresh_music_chs
	call RefreshChannel
	call NextChannel
	jr nz, .loop_refresh_music_chs
	jr .process_tracks

.tick_music
	ld [hld], a
	ld [hl], b

	call SetAllTracks
.loop_music_tracks
	call TickMusicTrack
	call NextTrack
	jr nz, .loop_music_tracks

	call SetMusicChannels
.loop_update_music_chs
	call UpdateChannel
	call NextChannel
	jr nz, .loop_update_music_chs

	ld hl, wMusicTempoAccumulator
	ld a, [hli]
	sub $4a
	ld b, a
	ld a, [hl]
	sbc 0
	jr nc, .tick_music

.process_tracks
	call SetAllTracks
.loop_process_tracks
	call ProcessTrack
	call NextTrack
	jr nz, .loop_process_tracks

	ld a, [wEnvelopeFrameCycle]
	and a
	jr nz, .dec_envelope_cycle
	ld a, $0f
.dec_envelope_cycle
	dec a
	ld [wEnvelopeFrameCycle], a

; get active channels
	ld c, NUM_CHANNELS
	ld de, CHANNEL_STRUCT_LENGTH
	ld hl, wChannels
.loop_chs
	ld a, [hl]
	and $ff ^ (CHANFLAGS_UPDATE_SO | CHANFLAGS_UPDATE_VOLUME | CHANFLAGS_UPDATE_FREQUENCY)
	ld [hl], a
	rla
	rr b
	add hl, de
	dec c
	jr nz, .loop_chs
	ld a, b
	ld [wActiveChannels], a
	pop de
	pop bc
	jp ReturnFromAudioJump

SetSFXChannels:
	ld de, wChannels
	ld a, NUM_SFX_CHANNELS
	jr SetAudioChannels

SetMusicChannels:
	ld de, wMusicChannels
	ld a, NUM_MUSIC_CHANNELS
	jr SetAudioChannels

	ld de, wChannel1
	ld a, NUM_CHANNELS
	; fallthrough

SetAudioChannels:
	ld hl, wNumAudioChannels
	ld [hli], a
	ld a, e
	ld [hli], a ; wCurChannelPtr
	ld [hl], d
	ret

; adds CHANNEL_STRUCT_LENGTH to wCurChannelPtr
; to point to the next channel
; decrements wNumAudioChannels
NextChannel:
	ld hl, wNumAudioChannels
	dec [hl]
	ret z
	inc hl ; wCurChannelPtr
	ld a, CHANNEL_STRUCT_LENGTH
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hl], a
	rra
	ret

SetTrack1:
	ld de, wTrack1
	ld a, 1
	ld c, LOW(rAUD1ENV)
	jr SetTrack

SetTrack2:
	ld de, wTrack2
	ld a, 1
	ld c, LOW(rAUD2ENV)
	jr SetTrack

SetTrack3:
	ld de, wTrack3
	ld a, 1
	ld c, LOW(rAUD3LEVEL)
	jr SetTrack

SetTrack4:
	ld de, wTrack4
	ld a, 1
	ld c, LOW(rAUD4ENV)
	jr SetTrack

SetAllTracks:
	ld de, wTrack1
	ld a, NUM_TRACKS
	ld c, LOW(rAUD1ENV)
	; fallthrough

; a = number of tracks
; de = pointer to first track
; c = sound register for this track
SetTrack:
	ld hl, wNumTracks
	ld [hli], a
	ld a, e
	ld [hli], a ; wCurTrackPtr
	ld a, d
	ld [hli], a
	ld [hl], c ; wCurSoundRegister
	ret

NextTrack:
	ld hl, wNumTracks
	dec [hl]
	ret z
	inc hl
	ld a, TRACK_STRUCT_LENGTH
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hli], a
	ld a, [hl]
	add $5
	ld [hl], a
	rra
	ret

; bc = sound ID
_PlaySFX::
	ld a, b
	or c
	jp z, TurnSFXOff
	call GetSound

	ld a, [wStartChannel]
	bit 7, a
	jr nz, .fill_free_channels_first ; jump never taken

	ld b, a
	sub CHAN5_F
	jr nc, .done_1
	cpl
	inc a
	ld [wNumAudioChannels], a

	ld hl, wChannels
	ld a, b
	and a
	jr z, .got_ch_ptr
	ld de, CHANNEL_STRUCT_LENGTH
.loop_chs
	add hl, de
	dec b
	jr nz, .loop_chs
.got_ch_ptr
	ld a, l
	ld [wCurChannelPtr + 0], a
	ld a, h
	ld [wCurChannelPtr + 1], a
	jr .check_channel

.loop_1
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
.check_channel
	bit CHANFLAGS_ACTIVE_F, [hl]
	jr z, .load_to_channel
	ld bc, CHANNEL_PRIORITY
	add hl, bc
	ld a, [wSoundPriority]
	cp [hl]
	jr nc, .load_to_channel
	; lower priority, ignore
	call SkipLoadingChannel
	jr .skip_load_to_channel
.load_to_channel
	call LoadChannelWithSound
.skip_load_to_channel
	jr z, .done_1
	call NextChannel
	jr nz, .loop_1

.done_1
	jp ReturnFromAudioJump

.fill_free_channels_first
	call SetSFXChannels
	ld a, $1
	ld [wSoundEngineParam4], a
	xor a
	ld [wSoundEngineParam3], a
.loop_2
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	bit CHANFLAGS_ACTIVE_F, [hl] ; CHANNEL_FLAGS
	jr nz, .active_ch
	call LoadChannelWithSound
	jr z, .done_2
	ld a, [wSoundEngineParam4]
	ld b, a
	ld a, [wSoundEngineParam3]
	or b
	ld [wSoundEngineParam3], a
.active_ch
	ld a, [wSoundEngineParam4]
	sla a
	ld [wSoundEngineParam4], a
	call NextChannel
	jr nz, .loop_2

	call SetSFXChannels
	ld a, $1
	ld [wSoundEngineParam4], a
.loop_3
	ld a, [wSoundEngineParam4]
	ld b, a
	ld a, [wSoundEngineParam3]
	and b
	jr nz, .next_channel

	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_PRIORITY
	add hl, bc
	ld a, [wSoundPriority]
	cp [hl]
	jr c, .next_channel
	call LoadChannelWithSound
	jr z, .done_2
.next_channel
	ld a, [wSoundEngineParam4]
	sla a
	ld [wSoundEngineParam4], a
	call NextChannel
	jr nz, .loop_3

.done_2
	jp ReturnFromAudioJump

; bc = sound ID
PlayMusic::
	ld a, b
	or c
	jp z, _TurnMusicOff
	ld a, c
	ld [wLoadedMusic + 0], a
	ld a, b
	ld [wLoadedMusic + 1], a
	xor a
	ld [wMusicFadeOutPeriod], a
	xor a
	ld [wMusicChannelsDeactivated], a
	call GetSound

; init noise channels
	call SetMusicChannels
.loop_noise_chs
	call LoadChannelWithSound
	jr z, .next_music_ch
	call NextChannel
	jr nz, .loop_noise_chs
	jr .done

; reset music channels
.loop_music_chs
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	xor a
	ld [hl], a
.next_music_ch
	call NextChannel
	jr nz, .loop_music_chs

.done
	jp ReturnFromAudioJump

; plays music if different from the one currently playing
; if the ID is the same
; bc = sound ID
_PlayNewMusic::
; only start playing music if it's not
; the same as the loaded one
	ld a, [wLoadedMusic + 0]
	cp c
	jr nz, PlayMusic
	ld a, [wLoadedMusic + 1]
	cp b
	jr nz, PlayMusic
	ld a, [wActiveChannels]
	and MUSIC_CHANNELS
	jr z, PlayMusic
	jp ReturnFromAudioJump


; bc = sound ID
_PlayNewMusic_SetNoise::
; only start playing music if it's not
; the same as the loaded one
	ld a, [wLoadedMusic + 0]
	cp c
	jr nz, PlayMusic
	ld a, [wLoadedMusic + 1]
	cp b
	jr nz, PlayMusic

; same as wLoadedMusic
	ld a, [wActiveChannels]
	and MUSIC_CHANNELS
	jr z, ReactivateMusicChannels
	jp ReturnFromAudioJump

; loops through all music channels and
; if either CHANFLAGS_LOADED or CHANFLAGS_INITIALISED are set
; then set it as active
ReactivateMusicChannels::
	xor a
	ld [wMusicChannelsDeactivated], a
	call SetMusicChannels
.loop_chs
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld a, [hl]
	and CHANFLAGS_LOADED | CHANFLAGS_INITIALISED ; CHANNEL_FLAGS
	jr z, .next_ch
	set CHANFLAGS_ACTIVE_F, [hl]
.next_ch
	call NextChannel
	jr nz, .loop_chs
	jp ReturnFromAudioJump

; loads the sound data of wCurSoundID
; bc = sound ID
GetSound:
; check if sound ID is within the valid values
	ld a, b
	ld [wCurSoundID + 1], a
	cp HIGH(NUM_SOUNDS)
	ld a, c
	jr z, .check_low_byte
	jr c, .ok
.invalid_sound
	pop hl
	jp ReturnFromAudioJump
.check_low_byte
	cp LOW(NUM_SOUNDS)
	jr nc, .invalid_sound

.ok
; get pointer to its header data
	ld [wCurSoundID + 0], a
	ld l, c
	ld h, b
	add hl, hl
	add hl, hl
	add hl, hl ; *8
	ld bc, SoundHeaders - $8
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a

	ld a, [hli]
	ld [wSoundBank], a
	inc hl
	ld a, [hli]
	ld [wSoundPriority], a
	ld a, [hli]
	ld [wStartChannel], a
	ld a, [hl]
	ld [wNumChannels], a
	inc de
	inc de
	ld a, e
	ld [wAudioCmdPtr + 0], a
	ld a, d
	ld [wAudioCmdPtr + 1], a
	ret

LoadChannelWithSound:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld a, CHANFLAGS_LOADED | CHANFLAGS_ACTIVE
	ld [hli], a ; CHANNEL_FLAGS
	inc hl
	ld a, [wAudioCmdPtr + 0]
	ld [hli], a ; CHANNEL_CMD_PTR
	ld a, [wAudioCmdPtr + 1]
	ld [hli], a
	ld a, [wSoundBank]
	ld [hli], a ; CHANNEL_SOUND_BANK
	inc hl
	ld a, [wCurSoundID + 0]
	ld [hli], a ; CHANNEL_SOUND_ID
	ld a, [wCurSoundID + 1]
	ld [hli], a
	ld a, [wSoundPriority]
	ld [hli], a ; CHANNEL_PRIORITY
	; fallthrough

; decrements wNumChannels
; and advances wAudioCmdPtr to the next pointer
SkipLoadingChannel:
	ld hl, wNumChannels
	dec [hl]
	ret z
	ld hl, wAudioCmdPtr
	ld a, $2
	add [hl]
	ld [hli], a
	ld a, 0
	adc [hl]
	ld [hl], a
	rra ; reset z
	ret

InitChannel:
	ld a, CHANFLAGS_INITIALISED | CHANFLAGS_ACTIVE
	ld [hli], a ; CHANNEL_FLAGS
	xor a
	ld [hli], a ; CHANNEL_DURATION
	ld a, [hli] ; CHANNEL_CMD_PTR
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hld] ; CHANNEL_SOUND_BANK
	ld [wSoundBank], a
	call ReadAudioCommands_2Bytes
	ld a, b
	ld [hld], a
	ld [hl], c ; CHANNEL_CMD_PTR
	ld bc, CHANNEL_PITCH - CHANNEL_CMD_PTR
	add hl, bc
	xor a
	ld [hli], a ; CHANNEL_PITCH
	ld [hli], a ; CHANNEL_NOTE_VOLUME
	ld [hli], a ; CHANNEL_NOTE_DURATION
	ld [hli], a ; CHANNEL_TIMBRE
	ld [hli], a ; CHANNEL_LENGTH
	ld [hli], a ; CHANNEL_SWEEP
	ld a, $ff
	ld [hli], a ; CHANNEL_FADE_IN_ENVELOPE
	ld [hli], a ; CHANNEL_FADE_OUT_ENVELOPE
	xor a
	ld [hli], a ; CHANNEL_ACTIVE_COMMAND
	ld [hli], a ; CHANNEL_SEMITONE_OFFSET
	ld [hli], a ; CHANNEL_PITCH_OFFSET_MOD
	ld [hli], a
	ld a, $ff
	ld [hli], a ; CHANNEL_VOLUME
	ld a, 1.0
	ld [hli], a ; CHANNEL_VOLUME_MOD
	xor a
	ld [hli], a ; CHANNEL_SINGLE_PAN
	ld [hli], a ; CHANNEL_GLOBAL_PAN
	ld [hli], a ; CHANNEL_PITCH_OFFSET
	ld a, $02
	ld [hli], a ; CHANNEL_PITCH_OFFSET_MULT
	xor a
	ld [hli], a ; CHANNEL_PITCH_PRODUCT
	ld [hli], a
	ld [hli], a ; CHANNEL_FREQUENCY_OFFSET
	ld [hli], a ; CHANNEL_UNUSED_1E
	ld a, $17
	ld [hli], a ; CHANNEL_VIBRATO_SPEED
	xor a
	ld [hli], a ; CHANNEL_VIBRATO_PHASE
	ld [hli], a ; CHANNEL_VIBRATO_AMPLITUDE
	ld [hli], a ; CHANNEL_VIBRATO_AMPLITUDE_MOD
	ld [hli], a ; CHANNEL_VIBRATO_DISABLED
	ld [hli], a ; CHANNEL_VIBRATO_FREQ_OFFSET
	ld [hli], a
	ld [hli], a ; CHANNEL_CALL_DEPTH
	ld [hli], a ; CHANNEL_RELEASE_VOLUME
	ld [hli], a ; CHANNEL_RELEASE_LENGTH
	ld [hli], a ; CHANNEL_LOOP_COUNTER
	ld [hli], a ; CHANNEL_VIBRATO_DELAY
	ld [hli], a ; CHANNEL_VIBRATO_COUNTER
	ld [hli], a ; CHANNEL_FREQUENCY
	ld [hli], a
	ld [hli], a ; CHANNEL_SO_FLAGS
	ld [hli], a ; CHANNEL_EFFECTIVE_VOLUME
	ld a, $ff
	ld [hli], a ; CHANNEL_UNUSED_30
	ret

; only ever used to switch SFX off (SOUND_OFF)
; input:
; - bc = sound ID
_TurnOffSFXID::
	ld a, b
	or c
	jp z, TurnSFXOff

; unused code
	ld a, c
	ld [wCurSoundID + 0], a
	ld a, b
	ld [wCurSoundID + 1], a
	call SetSFXChannels
.loop_sfx_channels
	ld a, [wCurChannelPtr + 0]
	ld c, a
	ld a, [wCurChannelPtr + 1]
	ld b, a
	ld a, [bc] ; CHANNEL_FLAGS
	bit CHANFLAGS_ACTIVE_F, a
	jr z, .next_channel
	ld hl, CHANNEL_SOUND_ID - CHANNEL_FLAGS
	add hl, bc
	ld a, [wCurSoundID + 0]
	cp [hl]
	jr nz, .next_channel
	inc hl
	ld a, [wCurSoundID + 1]
	cp [hl]
	jr nz, .next_channel
	xor a
	ld [bc], a ; CHANNEL_FLAGS
.next_channel
	call NextChannel
	jr nz, .loop_sfx_channels
	jp ReturnFromAudioJump

TurnSFXOff:
	call SetSFXChannels
.loop_chs
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	xor a
	ld [hl], a ; CHANNEL_FLAGS
	call NextChannel
	jr nz, .loop_chs
	jp ReturnFromAudioJump

_TurnMusicOff::
	call DeactivateMusicChannels
	jp ReturnFromAudioJump

DeactivateMusicChannels_FromFadeOut:
	xor a
	ld [wMusicFadeOutPeriod], a
	; fallthrough

DeactivateMusicChannels:
	ld a, $ff
	ld [wMusicChannelsDeactivated], a
	call SetMusicChannels
.loop_chs
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	res CHANFLAGS_ACTIVE_F, [hl] ; CHANNEL_FLAGS
	call NextChannel
	jr nz, .loop_chs
	ret

_GetActiveChannels::
	ld a, [wActiveChannels]
	and SFX_CHANNELS
	ld d, a
	ld a, [wActiveChannels]
	and MUSIC_CHANNELS
	swap a
	ld e, a
	jp ReturnFromAudioJump

_GetPlayingSoundID::
	and a
	jr nz, .check_sfx_channel
	ld a, [wActiveChannels]
	and MUSIC_CHANNELS
	jr z, .no_music
	ld a, [wLoadedMusic + 0]
	ld c, a
	ld a, [wLoadedMusic + 1]
	ld b, a
	jr .got_id
.check_sfx_channel
	cp NUM_SFX_CHANNELS + 1
	jr c, .valid_sfx_channel
.no_music
	ld bc, $0
	jr .got_id
.valid_sfx_channel
	ld bc, .channel_pointers - $2
	sla a
	add c
	ld c, a
	ld a, $00
	adc b
	ld b, a
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	ld bc, $0
	bit CHANFLAGS_ACTIVE_F, [hl]
	jr z, .got_id
	ld bc, CHANNEL_SOUND_ID
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.got_id
	jp ReturnFromAudioJump

.channel_pointers
	table_width 2
	dw wChannel1
	dw wChannel2
	dw wChannel3
	dw wChannel4
	assert_table_length NUM_MUSIC_CHANNELS

AudioModFunctionTable:
	table_width 2
	dw AudioMod_Tempo            ; AUDIOMOD_TEMPO
	dw AudioMod_Pitch            ; AUDIOMOD_PITCH
	dw AudioMod_Volume           ; AUDIOMOD_VOLUME
	dw AudioMod_Pan              ; AUDIOMOD_PAN
	dw AudioMod_VibratoAmplitude ; AUDIOMOD_VIBRATO_AMPLITUDE
	dw AudioMod_VibratoSpeed     ; AUDIOMOD_VIBRATO_SPEED
	dw AudioMod_Release          ; AUDIOMOD_RELEASE
	assert_table_length NUM_AUDIOMOD_FUNCTIONS

; input:
; - a = AUDIOMOD_* constant
_ExecuteAudioMod::
	call ExecuteAudioMod_Internal
	jp ReturnFromAudioJump

; wSoundEngineParam1 <- c
; wSoundEngineParam2 <- b
; wSoundEngineParam3 <- e
; wSoundEngineParam4 <- d
; input:
; - a = AUDIOMOD_* constant
ExecuteAudioMod_Internal:
	cp NUM_AUDIOMOD_FUNCTIONS
	ret nc

	push af
	ld hl, wSoundEngineParams
	ld a, c
	ld [hli], a ; wSoundEngineParam1
	ld a, b
	ld [hli], a ; wSoundEngineParam2
	ld a, e
	ld [hli], a ; wSoundEngineParam3
	ld a, d
	ld [hli], a ; wSoundEngineParam4
	xor a
	ld [hl], a ; wNumChannels
	pop af

	ld bc, AudioModFunctionTable
	jp JumpToPointerInTable

; applies value in wSoundEngineParam2 to all active channels
; selected for in wSoundEngineParam3 and wSoundEngineParam4
; to the struct field given by bc
; input:
; - bc = channel struct field
; - wSoundEngineParam2 = value to apply
AudioModSetValue_Short:
	call PrepareChannelBitmasks
.loop_chs
	rrc d
	jr nc, .next_ch
	bit CHANFLAGS_ACTIVE_F, [hl] ; CHANNEL_FLAGS
	jr z, .next_ch
	ld a, [wNumChannels]
	or [hl]
	ld [hl], a
	push hl
	add hl, bc
	ld a, [wSoundEngineParam2]
	ld [hl], a
	pop hl
.next_ch
	call AddChannelStructLengthToHL
	jr nz, .loop_chs
	ret

; applies value in wSoundEngineParam1 (as 16-bit) to all active channels
; selected for in wSoundEngineParam3 and wSoundEngineParam4
; to the struct field given by bc
AudioModSetValue_Long:
	call PrepareChannelBitmasks
.loop_chs
	rrc d
	jr nc, .next_ch
	bit CHANFLAGS_ACTIVE_F, [hl] ; CHANNEL_FLAGS
	jr z, .next_ch
	ld a, [wNumChannels]
	or [hl]
	ld [hl], a
	push hl
	add hl, bc
	ld a, [wSoundEngineParam1]
	ld [hli], a
	ld a, [wSoundEngineParam2]
	ld [hld], a
	pop hl
.next_ch
	call AddChannelStructLengthToHL
	jr nz, .loop_chs
	ret

; interprets wSoundEngineParam4 as selector for SFX channels
; and wSoundEngineParam3 as selector of music channels
; outputs channel bitmasks in d, NUM_CHANNELS in e and wChannels in hl
; output:
; - d = (wSoundEngineParam3 low nibble << 4) | wSoundEngineParam4 low nibble
; - e = NUM_CHANNELS
; - hl = wChannels
PrepareChannelBitmasks:
	ld a, [wSoundEngineParam4]
	and $0f
	ld d, a ; low nibble
	ld a, [wSoundEngineParam3]
	swap a
	and $f0
	or d
	ld d, a
	ld e, NUM_CHANNELS
	ld hl, wChannels
	ret

AddChannelStructLengthToHL:
	ld a, CHANNEL_STRUCT_LENGTH
	add l
	ld l, a
	ld a, 0
	adc h
	ld h, a
	dec e
	ret

_SetMusicFadeOut::
	ld [wMusicFadeOutPeriod], a
	ld [wMusicFadeOutTimer], a
	ld a, 1.0
	ld [wMusicFadeOutVolumeMult], a
	jp ReturnFromAudioJump

UpdateMusicFadeOut:
	ld a, [wMusicChannelsDeactivated]
	and a
	ret nz ; music channels are deactivated

	; subtracts 0.063 from wMusicFadeOutVolumeMult every wMusicFadeOutPeriod "ticks"
	ld a, [wMusicFadeOutPeriod]
	and a
	ret z
	ld hl, wMusicFadeOutTimer
	dec [hl]
	ret nz
	ld [hli], a ; wMusicFadeOutTimer
	ld a, [hl] ; wMusicFadeOutVolumeMult
	sub 0.063
	; if < 0.0, then deactivate music
	jp c, DeactivateMusicChannels_FromFadeOut
	ld [hl], a

	; apply this volume multiplier to music channels
	ld b, a
	ld a, AUDIOMOD_VOLUME
	lb de, $00, $ff ; select only music channels
	jp ExecuteAudioMod_Internal

RefreshChannel:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld a, [hl] ; CHANNEL_FLAGS
	cp CHANFLAGS_INITIALISED | CHANFLAGS_ACTIVE
	ret c ; both flags not set
	ld [wCurChannelFlags], a
	jp ApplyChannelUpdates

UpdateChannel:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld a, [hl]
	bit CHANFLAGS_ACTIVE_F, a
	ret z ; not active
	bit CHANFLAGS_INITIALISED_F, a
	jr nz, .skip_init
	push hl
	call InitChannel
	pop hl
	ld a, [hl]
.skip_init
	ld [wCurChannelFlags], a
	inc hl
	ld a, [hl] ; CHANNEL_DURATION
	and a
	jr z, .do_audio_cmds
	dec [hl]
	inc hl
	jr UpdateVibrato

.do_audio_cmds
	inc hl
	ld a, [hli] ; CHANNEL_CMD_PTR
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli] ; CHANNEL_SOUND_BANK
	ld [wSoundBank], a
	; fallthrough

DoAudioCommand:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_ACTIVE_COMMAND
	add hl, bc
	call ReadAudioCommands_2Bytes
	bit 7, c
	jr nz, .new_cmd

; previous cmd
	ld a, c
	ld [wAudioCmdArg], a
	dec de
	ld a, [hl]
	jr .got_cmd

.new_cmd
	ld a, b
	ld [wAudioCmdArg], a
	ld a, c
	cp $be
	jr c, .got_cmd ; if < $be
	ld [hl], a ; CHANNEL_ACTIVE_COMMAND

.got_cmd
	cp $d0
	jp nc, AudioCmd_Note ; if >= $d0
	sub $b1
	jp c, AudioCmd_Wait
	ld bc, AudioCommandTable
	; fallthrough

; bc = pointer table
; a = index to jump to
JumpToPointerInTable:
	sla a ; *2
	add c
	ld c, a
	ld a, 0
	adc b
	ld b, a
	ld a, [bc]
	ld l, a
	inc bc
	ld a, [bc]
	ld h, a
	jp hl

AudioCmd_ClearFlags:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	xor a
	ld [hli], a
	ret

UpdateVibrato:
	ld bc, CHANNEL_VIBRATO_COUNTER - CHANNEL_CMD_PTR
	add hl, bc
	ld a, [hl]
	and a
	jr z, .counter_done
	; still counting down vibrato delay
	dec [hl]
	ld bc, CHANNEL_VIBRATO_PHASE - CHANNEL_VIBRATO_COUNTER
	add hl, bc
	ld a, $40
	jr .write_vibrato_value
.counter_done
	ld bc, CHANNEL_VIBRATO_SPEED - CHANNEL_VIBRATO_COUNTER
	add hl, bc
	ld a, [hli]
	add [hl] ; CHANNEL_VIBRATO_PHASE
.write_vibrato_value
	ld [hl], a ; CHANNEL_VIBRATO_PHASE
	sla a
	jr nc, .got_vibrato_value
	cpl
.got_vibrato_value
	ld [wVibratoValue], a

	ld bc, CHANNEL_VIBRATO_AMPLITUDE - CHANNEL_VIBRATO_PHASE
	add hl, bc
	ld a, [hli]
	add [hl] ; CHANNEL_VIBRATO_AMPLITUDE_MOD
	jr z, .zero_vibrato_pitch
	ld c, a
	ld a, [wVibratoValue]
	ld b, a
	push hl
	push bc
	call MultiplyBByC
	pop bc
	ld b, h
	pop hl
	inc hl
	ld a, [hli] ; CHANNEL_VIBRATO_DISABLED
	cp FALSE
	jr z, .calculate_vibrato
	jr .skip_vibrato

.zero_vibrato_pitch
	ld bc, 0
	inc hl
	ld a, [hli] ; CHANNEL_VIBRATO_DISABLED
	cp FALSE
	jr z, .check_change_in_freq_lo
	jr .skip_vibrato

.calculate_vibrato
	; calculates bc = (b - c/2) * 8
	ld a, b
	srl c
	sub c
	ld c, a ; = b - c / 2
	ld a, 0
	sbc a
	sla c
	rla
	sla c
	rla
	sla c
	rla
	ld b, a ; *8
.check_change_in_freq_lo
	ld a, c
	cp [hl] ; CHANNEL_VIBRATO_FREQ_OFFSET
	jr z, .check_change_in_freq_hi
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_FREQUENCY_F, a
	ld [wCurChannelFlags], a
	ld [hl], c
.check_change_in_freq_hi
	inc hl
	ld a, b
	cp [hl]
	jr z, .vibrato_done
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_FREQUENCY_F, a
	ld [wCurChannelFlags], a
	ld [hl], b
.vibrato_done
	jr .skip_vibrato ; unnecessary jump

.skip_vibrato
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld a, [wCurChannelFlags]
;	fallthrough

; input:
; - a  = channel flags
; - hl = channel
ApplyChannelUpdates:
	bit CHANFLAGS_UPDATE_FREQUENCY_F, a
	jr z, .skip_frequency
	ld bc, CHANNEL_FREQUENCY_OFFSET
	add hl, bc
	ld e, [hl]
	ld a, 0
	sla e
	sbc a
	ld d, a ; (e > $80) ? $ff : $00

	ld bc, CHANNEL_PITCH_PRODUCT - CHANNEL_FREQUENCY_OFFSET
	add hl, bc
	ld a, [hli]
	add e
	ld e, a
	ld a, [hld]
	adc d
	ld d, a

	ld bc, CHANNEL_PITCH_OFFSET_MOD - CHANNEL_PITCH_PRODUCT
	add hl, bc
	ld a, [hli]
	add e
	ld e, a
	ld a, [hld]
	adc d
	ld d, a

	ld bc, CHANNEL_VIBRATO_DISABLED - CHANNEL_PITCH_OFFSET_MOD
	add hl, bc
	ld a, [hli]
	cp FALSE
	jr nz, .no_vibrato
	ld a, [hli] ; CHANNEL_VIBRATO_FREQ_OFFSET
	add e
	ld e, a
	ld a, [hld]
	adc d
	ld d, a

.no_vibrato
	; de = final frequency value
	ld bc, CHANNEL_FREQUENCY - CHANNEL_VIBRATO_FREQ_OFFSET
	add hl, bc
	ld a, e
	ld [hli], a
	ld [hl], d

	ld bc, -(CHANNEL_FREQUENCY + 1)
	add hl, bc
	ld a, [wCurChannelFlags]

.skip_frequency
	bit CHANFLAGS_UPDATE_SO_F, a
	jr z, .skip_so
	ld bc, CHANNEL_SINGLE_PAN
	add hl, bc
	ld a, [hli]
	add [hl] ; CHANNEL_GLOBAL_PAN
	ld e, a
	ld bc, CHANNEL_SO_FLAGS - CHANNEL_GLOBAL_PAN
	add hl, bc
	ld [hl], e
	ld bc, -CHANNEL_SO_FLAGS
	add hl, bc
	ld a, [wCurChannelFlags]

.skip_so
	bit CHANFLAGS_UPDATE_VOLUME_F, a
	jr z, .done
	ld bc, CHANNEL_VOLUME
	add hl, bc
	ld a, [hli]
	ld b, a
	ld c, [hl] ; CHANNEL_VOLUME_MOD
	call MultiplyBByC_Short
	add $0f
	and $f0
	cp $40
	jr c, .no_cap
	ld a, $ff
.no_cap
	rlca
	rlca
	ld e, a ; *4
	ld bc, CHANNEL_EFFECTIVE_VOLUME - CHANNEL_VOLUME_MOD
	add hl, bc
	ld [hl], e
	ld bc, -CHANNEL_EFFECTIVE_VOLUME
	add hl, bc

	ld a, [wCurChannelFlags]
.done
	ld [hl], a
	ret

AudioCommandTable:
	dw AudioCmd_ClearFlags                ; AUDIOCMD_END
	dw AudioCmd_Jump                      ; AUDIOCMD_JUMP
	dw AudioCmd_Call                      ; AUDIOCMD_CALL
	dw AudioCmd_Ret                       ; AUDIOCMD_RET
	dw AudioCmd_Loop                      ; AUDIOCMD_LOOP
	dw InvalidAudioCmd                    ; AUDIOCMD_UNUSED_B6
	dw InvalidAudioCmd                    ; AUDIOCMD_UNUSED_B7
	dw InvalidAudioCmd                    ; AUDIOCMD_UNUSED_B8
	dw AudioCmd_ClearFlags                ; AUDIOCMD_UNUSED_B9
	dw AudioCmd_ClearFlags                ; AUDIOCMD_UNUSED_BA
	dw AudioCmd_ClearFlags                ; AUDIOCMD_UNUSED_BB
	dw AudioCmd_SetTempo                  ; AUDIOCMD_TEMPO
	dw AudioCmd_SetSemitoneOffset         ; AUDIOCMD_SEMITONE_OFFSET
	dw AudioCmd_SetWave                   ; AUDIOCMD_WAVE
	dw AudioCmd_SetChannelVolume          ; AUDIOCMD_VOLUME
	dw AudioCmd_Pan                       ; AUDIOCMD_PAN
	dw AudioCmd_SetPitchOffset            ; AUDIOCMD_PITCH_OFFSET
	dw AudioCmd_SetPitchOffsetMultiplier  ; AUDIOCMD_PITCH_OFFSET_MULT
	dw AudioCmd_SetVibratoSpeed           ; AUDIOCMD_VIBRATO_SPEED
	dw AudioCmd_SetVibratoDelay           ; AUDIOCMD_VIBRATO_DELAY
	dw AudioCmd_SetVibratoAmplitude       ; AUDIOCMD_VIBRATO_AMPLITUDE
	dw AudioCmd_SetChannelVibratoDisabled ; AUDIOCMD_VIBRATO_DISABLED
	dw InvalidAudioCmd                    ; AUDIOCMD_UNUSED_C7
	dw InvalidAudioCmd                    ; AUDIOCMD_UNUSED_C8
	dw AudioCmd_SetChannelFrequencyOffset ; AUDIOCMD_FREQUENCY_OFFSET
	dw AudioCmd_SetChannelUnused1e        ; AUDIOCMD_SET_UNUSED_1E
	dw InvalidAudioCmd                    ; AUDIOCMD_UNUSED_CB
	dw AudioCmd_ClearFlags                ; AUDIOCMD_UNUSED_CC
	dw AudioCmd_Special                         ; cd
	dw AudioCmd_NoteNoDuration                         ; ce
	dw AudioCmd_ReleaseNote                         ; cf

AudioSpecialCommandTable:
	dw AudioCmd_ClearFlags                ; AUDIOCMDSPECIAL_UNUSED_0
	dw AudioCmd_SetChannelTimbre          ; AUDIOCMDSPECIAL_TIMBRE
	dw AudioCmd_SetChannelFadeInEnvelope  ; AUDIOCMDSPECIAL_FADE_IN_ENVELOPE
	dw AudioCmd_SetChannelFadeInEnvelopeLow                         ; 03
	dw AudioCmd_SetChannelFadeOutEnvelopeHigh                         ; 04
	dw AudioCmd_SetChannelFadeOutEnvelope ; 05
	dw AudioCmd_SetChannelReleaseVolume           ; 06
	dw AudioCmd_SetChannelReleaseLength           ; 07
	dw InvalidAudioCmd                    ; 08
	dw InvalidAudioCmd                    ; 09
	dw AudioCmd_SetChannelDuration        ; 0a
	dw AudioCmd_SetChannelSweep           ; 0b

AudioCmd_Special:
	ld a, [wAudioCmdArg]
	inc de
	cp $0c
	jp nc, AudioCmd_ClearFlags
	ld b, a
	call ReadAudioCommands_1Byte
	ld a, c
	ld [wAudioCmdArg], a
	ld a, b
	ld bc, AudioSpecialCommandTable
	jp JumpToPointerInTable

AudioCmd_Wait:
	add $31
	jp z, DoAudioCommand ; $80

	add LOW(AudioCmdDurations)
	ld l, a
	ld a, 0
	adc HIGH(AudioCmdDurations)
	ld h, a
	ld b, [hl]
	dec b

	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	inc hl
	ld a, b
	ld [hli], a ; CHANNEL_DURATION
	ld a, e
	ld [hli], a ; CHANNEL_CMD_PTR
	ld a, d
	ld [hld], a
	jp UpdateVibrato

AudioCmd_Call:
; audio_call
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_CALL_DEPTH
	add hl, bc
	ld a, [hl]
	cp $0a
	jp nc, AudioCmd_ClearFlags
	inc a
	inc a
	ld [hl], a
	ld c, a
	ld b, $00
	add hl, bc
	ld bc, $a
	add hl, bc
	inc de
	inc de
	ld a, e
	ld [hli], a
	ld [hl], d
	dec de
	dec de
;	fallthrough

AudioCmd_Jump:
; audio_jump
	call ReadAudioCommands_2Bytes
	ld e, c
	ld d, b
	jp DoAudioCommand

AudioCmd_Ret:
; audio_ret
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_CALL_DEPTH
	add hl, bc
	ld a, [hl]
	and a
	jp z, DoAudioCommand
	dec a
	dec a
	ld [hl], a
	ld c, a
	ld b, $00
	add hl, bc
	ld bc, $c
	add hl, bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	jp DoAudioCommand

AudioCmd_Loop:
; audiocmd_loop
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_LOOP_COUNTER
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	and a
	jr z, AudioCmd_Jump ; if arg == 0
	inc [hl]
	cp [hl]
	jr nz, AudioCmd_Jump ; if arg != CHANNEL_LOOP_COUNTER + 1
	xor a
	ld [hl], a
	inc de
	inc de
	jp DoAudioCommand

AudioCmd_SetTempo:
; tempo
	ld hl, wAudioEngineFlags
	bit AUDIOENG_HANDLING_SFX_F, [hl]
	ld hl, wMusicBaseTempo
	jr z, .not_set
	ld hl, wSFXBaseTempo
.not_set
	ld a, [wAudioCmdArg]
	inc de
	ld [hl], a
	call CalculateTempo
	jp DoAudioCommand

; multiplies base tempo given in hl by its multiplier,
; then stores the result
; input:
; - hl = either wSFXBaseTempo or wMusicBaseTempo
CalculateTempo:
	ld a, [hli] ; wSFXBaseTempo / wMusicBaseTempo
	ld b, a
	ld a, [hli] ; wSFXTempoMult / wMusicTempoMult
	ld c, a
	push hl
	call MultiplyBByC
	ld a, h
	cp HIGH(256.0)
	jr c, .no_cap
	ld a, HIGH(255.99)
	ld l, LOW(255.99)
.no_cap
	sla l
	rla
	sla l
	rla ; *4
	and a
	jr nz, .got_tempo
	inc a ; at least 1
.got_tempo
	pop hl
	ld [hl], a ; wSFXTempo / wMusicTempo
	ret

; if wSoundEngineParam4 != 0, then set wSFXTempoMult to wSoundEngineParam2
; if wSoundEngineParam3 != 0, then set wMusicTempoMult to wSoundEngineParam2
; in either case, recalculate the new tempo value
AudioMod_Tempo:
	ld a, [wSoundEngineParam4]
	and a
	jr z, .check_music
	ld hl, wSFXTempoMult
	ld a, [wSoundEngineParam2]
	ld [hld], a
	call CalculateTempo
.check_music
	ld a, [wSoundEngineParam3]
	and a
	jr z, .done
	ld hl, wMusicTempoMult
	ld a, [wSoundEngineParam2]
	ld [hld], a
	call CalculateTempo
.done
	ret

AudioCmd_SetSemitoneOffset:
; semitone_offset
	ld bc, CHANNEL_SEMITONE_OFFSET
	jp SetChannelProperty

AudioMod_Pitch:
	ld a, [wNumChannels]
	set CHANFLAGS_UPDATE_FREQUENCY_F, a
	ld [wNumChannels], a
	ld bc, CHANNEL_PITCH_OFFSET_MOD
	jp AudioModSetValue_Long

AudioCmd_SetWave:
; wave
	ld a, [wAudioCmdArg]
	inc de
	cp WAVE_28
	jr z, .percussion

	call GetWave

	ld a, [wCurChannelPtr + 0]
	add CHANNEL_TIMBRE
	ld c, a
	ld a, [wCurChannelPtr + 1]
	adc 0
	ld b, a

	ld a, [hli]
	ld [bc], a ; CHANNEL_TIMBRE
	inc bc
	ld a, [hli]
	ld [bc], a ; CHANNEL_LENGTH
	inc bc
	ld a, [hli]
	ld [bc], a ; CHANNEL_SWEEP
	inc bc
	ld a, [hli]
	ld [bc], a ; CHANNEL_FADE_IN_ENVELOPE
	inc bc
	ld a, [hli]
	ld [bc], a ; CHANNEL_FADE_OUT_ENVELOPE

	ld a, [wCurChannelFlags]
	res CHANFLAGS_UPDATE_PERCUSSION_F, a
	ld [wCurChannelFlags], a
	jp DoAudioCommand

.percussion
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_PERCUSSION_F, a
	ld [wCurChannelFlags], a
	jp DoAudioCommand

GetWave:
	ld l, a
	ld h, $00
	add hl, hl ; *2
	ld c, l
	ld b, h
	add hl, hl ; *4
	add hl, bc ; *6
	ld bc, Waves
	add hl, bc
	ret

AudioCmd_SetPitchOffset:
; pitch_offset
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_PITCH_OFFSET
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	rlca
	sub $80
	ld [hli], a
	ld b, a
	ld a, [hli] ; CHANNEL_PITCH_OFFSET_MULT
	ld c, a
;	fallthrough

; b = pitch offset
; c = pitch offset multiplier
CalculatePitchProduct:
	push hl
	sla b
	jr c, .negative
	call MultiplyBByC
	ld c, l
	ld b, h
	jr .got_product
.negative
	ld a, b
	cpl
	ld b, a
	call MultiplyBByC
	dec hl
	ld a, l
	cpl
	ld c, a
	ld a, h
	cpl
	ld b, a

.got_product
	pop hl
	ld a, c
	ld [hli], a ; CHANNEL_PITCH_PRODUCT
	ld [hl], b
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_FREQUENCY_F, a
	ld [wCurChannelFlags], a
	jp DoAudioCommand

AudioCmd_SetPitchOffsetMultiplier:
; pitch_offset_mult
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_PITCH_OFFSET_MULT
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	ld [hld], a
	ld c, a
	ld a, [hli] ; CHANNEL_PITCH_OFFSET
	ld b, a
	inc hl
	jr CalculatePitchProduct

AudioCmd_SetVibratoSpeed:
; vibrato_speed
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_VIBRATO_SPEED
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	ld [hli], a
	sla a
	jr nz, .done
	ccf
	rra
	rra
	ld [hl], a ; CHANNEL_VIBRATO_PHASE
.done
	jp DoAudioCommand

AudioMod_VibratoSpeed:
	ld a, [wSoundEngineParam2]
	sla a
	jr z, .set_with_phase
	ld bc, CHANNEL_VIBRATO_SPEED
	jp AudioModSetValue_Short
.set_with_phase
	rra
	ld [wSoundEngineParam1], a
	rra
	xor $40
	ld [wSoundEngineParam2], a
	ld bc, CHANNEL_VIBRATO_SPEED ; and CHANNEL_VIBRATO_PHASE
	jp AudioModSetValue_Long

AudioCmd_SetVibratoDelay:
; vibrato_delay
	ld bc, CHANNEL_VIBRATO_DELAY
	jr SetChannelProperty

AudioCmd_SetChannelVolume:
; volume
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_VOLUME_F, a
	ld [wCurChannelFlags], a

	ld bc, CHANNEL_VOLUME
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	rlca
	ld [hl], a
	jp DoAudioCommand

AudioMod_Volume:
	ld a, [wNumChannels]
	set CHANFLAGS_UPDATE_VOLUME_F, a
	ld [wNumChannels], a
	ld bc, CHANNEL_VOLUME_MOD
	jp AudioModSetValue_Short

AudioCmd_Pan:
; pan
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_SO_F, a
	ld [wCurChannelFlags], a
	ld bc, CHANNEL_SINGLE_PAN
	jr SetChannelSignedProperty

AudioMod_Pan:
	ld a, [wNumChannels]
	set CHANFLAGS_UPDATE_SO_F, a
	ld [wNumChannels], a
	ld bc, CHANNEL_GLOBAL_PAN
	jp AudioModSetValue_Short

AudioCmd_SetVibratoAmplitude:
; vibrato_amplitude
	ld bc, CHANNEL_VIBRATO_AMPLITUDE
;	fallthrough

SetChannelProperty:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	ld [hl], a
	jp DoAudioCommand

AudioCmd_SetChannelVibratoDisabled:
; vibrato_disabled
	ld a, [wCurChannelFlags]
	or CHANFLAGS_UPDATE_SO | CHANFLAGS_UPDATE_VOLUME | CHANFLAGS_UPDATE_FREQUENCY
	ld [wCurChannelFlags], a
	ld bc, CHANNEL_VIBRATO_DISABLED
	jr SetChannelProperty

AudioMod_VibratoAmplitude:
	ld bc, CHANNEL_VIBRATO_AMPLITUDE_MOD
	jp AudioModSetValue_Short

AudioCmd_SetChannelFrequencyOffset:
; frequency_offset
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_FREQUENCY_F, a
	ld [wCurChannelFlags], a
	ld bc, CHANNEL_FREQUENCY_OFFSET
;	fallthrough

SetChannelSignedProperty:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	rlca
	sub $80
	ld [hl], a
	jp DoAudioCommand

AudioCmd_SetChannelUnused1e:
; set_unused_1e
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_FREQUENCY_F, a
	ld [wCurChannelFlags], a
	ld bc, CHANNEL_UNUSED_1E
	jr SetChannelProperty

AudioCmd_SetChannelReleaseVolume:
; audiocmd_d6
	ld bc, CHANNEL_RELEASE_VOLUME
	jr SetChannelProperty

AudioCmd_SetChannelReleaseLength:
; audiocmd_d7
	ld bc, CHANNEL_RELEASE_LENGTH
	jr SetChannelProperty

AudioMod_Release:
	ld bc, CHANNEL_RELEASE_VOLUME
	jp AudioModSetValue_Long

AudioCmd_SetChannelTimbre:
; timbre
	ld bc, CHANNEL_TIMBRE
	jr SetChannelProperty

AudioCmd_SetChannelDuration:
; set_duration
	ld bc, CHANNEL_LENGTH
	jr SetChannelProperty

AudioCmd_SetChannelSweep:
; set_sweep
	ld bc, CHANNEL_SWEEP
	jr SetChannelProperty

AudioCmd_SetChannelFadeInEnvelope:
; fade_in_envelope
	ld bc, CHANNEL_FADE_IN_ENVELOPE
;	fallthrough

SetChannelPropertyHighNybble:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	swap a
	and $f0
	ld b, a
	ld a, [hl]
	and $0f
	or b
	ld [hl], a
	jp DoAudioCommand

AudioCmd_SetChannelFadeInEnvelopeLow:
	ld bc, CHANNEL_FADE_IN_ENVELOPE
;	fallthrough

SetChannelPropertyLowNybble:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	add hl, bc
	ld a, [wAudioCmdArg]
	inc de
	and $0f
	ld b, a
	ld a, [hl]
	and $f0
	or b
	ld [hl], a
	jp DoAudioCommand

AudioCmd_SetChannelFadeOutEnvelopeHigh:
	ld bc, CHANNEL_FADE_OUT_ENVELOPE
	jr SetChannelPropertyHighNybble

AudioCmd_SetChannelFadeOutEnvelope:
	ld bc, CHANNEL_FADE_OUT_ENVELOPE
	jr SetChannelPropertyLowNybble

InvalidAudioCmd:
	jp AudioCmd_ClearFlags

AudioCmd_NoteNoDuration:
	ld b, $00
	jr PlayNote

AudioCmd_Note:
	sub $cf
	add LOW(AudioCmdDurations)
	ld l, a
	ld a, 0
	adc HIGH(AudioCmdDurations)
	ld h, a
	ld b, [hl]
;	fallthrough

PlayNote:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld a, b
	ld bc, CHANNEL_NOTE_DURATION
	add hl, bc
	ld [hld], a
	ld b, $00
	ld a, [wAudioCmdArg]
	jr .got_arg

.loop_args
	inc de
	call ReadAudioCommands_1Byte
	ld a, c
.got_arg
	bit 7, a
	jr nz, .done_args
	cp C_0
	jr nc, .pitch ; if >= $24
	cp $20
	jr c, .note_volume ; if < $20
	bit 5, b
	jr nz, .done_args
	set 5, b
	inc hl
	add [hl] ; CHANNEL_NOTE_DURATION
	ld [hld], a
	jr .loop_args

.pitch
	bit 7, b
	jr nz, .done_args
	set 7, b
	dec hl
	ld [hli], a ; CHANNEL_PITCH
	jr .loop_args

.note_volume
	bit 6, b
	jr nz, .done_args
	set 6, b
	rlca
	rlca
	rlca
	or %111
	ld [hl], a ; CHANNEL_NOTE_VOLUME
	jr .loop_args

.done_args
	push de
	dec hl
	ld a, [hl] ; CHANNEL_PITCH
	ld bc, CHANNEL_SEMITONE_OFFSET - CHANNEL_PITCH
	add hl, bc
	add [hl] ; add semitone offset
	ld [wSoundEngineParam3], a
	ld [wSoundEngineParam4], a
	ld bc, CHANNEL_VIBRATO_DELAY - CHANNEL_SEMITONE_OFFSET
	add hl, bc
	ld a, [hli]
	ld [hld], a ; CHANNEL_VIBRATO_COUNTER
	ld bc, CHANNEL_TIMBRE - CHANNEL_VIBRATO_DELAY
	add hl, bc

	ld a, [wCurChannelFlags]
	bit CHANFLAGS_UPDATE_PERCUSSION_F, a
	jr z, .set_track
	push hl
	ld e, l
	ld d, h
	ld a, [wSoundEngineParam3]
	add $4
	call GetWave
	ld a, [hli]
	ld [de], a ; CHANNEL_TIMBRE
	inc de
	ld a, [hli]
	ld [de], a ; CHANNEL_LENGTH
	inc de
	ld a, [hli]
	ld [de], a ; CHANNEL_SWEEP
	inc de
	ld a, [hli]
	ld [de], a ; CHANNEL_FADE_IN_ENVELOPE
	inc de
	ld a, [hli]
	ld [de], a ; CHANNEL_FADE_OUT_ENVELOPE
	ld a, [hl]
	ld [wSoundEngineParam4], a
	pop hl
.set_track

; set Track1 if (CHANNEL_TIMBRE < $08)
; set Track2 if ($8  <= CHANNEL_TIMBRE < $10)
; set Track3 if ($10 <= CHANNEL_TIMBRE < $40)
; set Track3 if (CHANNEL_TIMBRE >= $40)

	ld a, [hl] ; CHANNEL_TIMBRE
	cp $10
	jr nc, .track3_or_track4 ; if >= $10
	cp $8
	jr nc, .track2 ; if >= $8
; track1
	call SetTrack1
	jr .got_track
.track2
	call SetTrack2
	jr .got_track
.track3_or_track4
	cp $40
	jr nc, .track4 ; if >= $40
; track3
	call SetTrack3
	jr .got_track
.track4
	call SetTrack4

.got_track
	ld a, [wNumAudioChannels]
	ld hl, wAudioEngineFlags
	bit AUDIOENG_HANDLING_SFX_F, [hl]
	jr z, .got_owner
	set TRACK_OWNER_SFX_F, a
.got_owner
	ld [wTempTrackOwner], a
	ld e, a
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_PRIORITY
	add hl, bc
	ld a, [hl]
	ld [wTempTrackPriority], a
	ld d, a

	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	ld a, [hli] ; TRACK_FLAGS
	and a
	jr z, .UpdateTrack
	bit TRACKFLAGS_HELD_F, a
	jr nz, .track_held
	jr .UpdateTrack

.track_held
	ld a, [hli] ; TRACK_PRIORITY
	cp d
	jr c, .UpdateTrack
	jr nz, .skip
	ld a, e
	cp [hl] ; TRACK_OWNER
	jr c, .skip

.UpdateTrack:
	call TurnSoundRegisterOff
	ld a, [wCurChannelPtr + 0]
	ld e, a
	ld a, [wCurChannelPtr + 1]
	ld d, a
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a

	ld a, TRACKFLAGS_FADING | TRACKFLAGS_HELD | TRACKFLAGS_START_ENVELOPE | TRACKFLAGS_ACTIVE
	ld [hli], a ; TRACK_FLAGS
	ld a, [wTempTrackPriority]
	ld [hli], a ; TRACK_PRIORITY
	ld a, [wTempTrackOwner]
	ld [hli], a ; TRACK_OWNER
	ld a, [wSoundEngineParam3]
	ld [hli], a ; TRACK_NOTE
	ld a, e
	ld [hli], a ; TRACK_CHANNEL_PTR
	ld a, d
	ld [hli], a
	ld a, CHANNEL_NOTE_VOLUME
	add e
	ld e, a
	ld a, 0
	adc d
	ld d, a
	ld a, [de] ; CHANNEL_NOTE_VOLUME
	ld [hli], a ; TRACK_NOTE_VOLUME
	inc de
	ld a, [de] ; CHANNEL_NOTE_DURATION
	ld [hli], a ; TRACK_DURATION
	inc de
	ld a, [de] ; CHANNEL_TIMBRE
	ld [hli], a ; TRACK_TIMBRE
	inc de
	ld a, [de] ; CHANNEL_LENGTH
	ld [hli], a ; TRACK_LENGTH
	inc de
	ld a, [de] ; CHANNEL_SWEEP
	ld [hli], a ; TRACK_SWEEP
	inc de
	ld a, [de] ; CHANNEL_FADE_IN_ENVELOPE
	ld [hli], a ; TRACK_FADE_IN_ENVELOPE
	inc de
	ld a, [de] ; CHANNEL_FADE_OUT_ENVELOPE
	ld [hli], a ; TRACK_FADE_OUT_ENVELOPE
	xor a
	ld [hli], a ; TRACK_UNUSED_0D
	ld a, [wSoundEngineParam4]
	ld [hl], a ; TRACK_FREQUENCY_NOTE
.skip
	pop de
	jp DoAudioCommand

AudioCmd_ReleaseNote:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_PITCH
	add hl, bc
	ld a, [wAudioCmdArg]
	bit 7, a
	jr nz, .got_pitch
	cp $24
	jr c, .got_pitch
	inc de
	ld [hl], a ; CHANNEL_PITCH
.got_pitch
	ld a, [hl] ; CHANNEL_PITCH
	ld bc, CHANNEL_SEMITONE_OFFSET - CHANNEL_PITCH
	add hl, bc
	add [hl]
	ld [wSoundEngineParam3], a

	push de
	call SetAllTracks
	ld a, [wNumAudioChannels]
	ld hl, wAudioEngineFlags
	bit AUDIOENG_HANDLING_SFX_F, [hl]
	jr z, .got_owner
	set TRACK_OWNER_SFX_F, a
.got_owner
	ld e, a
	ld a, [wSoundEngineParam3]
	ld d, a

.loop_tracks
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	ld a, [hli] ; TRACK_FLAGS
	bit TRACKFLAGS_HELD_F, a
	jr z, .next_track
	inc hl
	ld a, [hli] ; TRACK_OWNER
	cp e
	jr nz, .next_track
	ld a, [hl] ; TRACK_NOTE
	cp d
	jr nz, .next_track
	ld bc, TRACK_DURATION - TRACK_NOTE
	add hl, bc
	ld a, [hl]
	and a
	jr nz, .next_track
	call ReleaseTrack
	jr .done
.next_track
	call NextTrack
	jr nz, .loop_tracks

.done
	pop de
	jp DoAudioCommand

TickSFXTrack:
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	bit TRACKFLAGS_ACTIVE_F, [hl] ; TRACK_FLAGS
	ret z
	inc hl
	inc hl
	bit TRACK_OWNER_SFX_F, [hl] ; TRACK_OWNER
	ret z
	jr TickTrackDuration

TickMusicTrack:
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	bit TRACKFLAGS_ACTIVE_F, [hl] ; TRACK_FLAGS
	ret z
	inc hl
	inc hl
	bit TRACK_OWNER_SFX_F, [hl] ; TRACK_OWNER
	ret nz
	; fallthrough

TickTrackDuration:
	inc hl
	inc hl
	ld a, [hli] ; TRACK_CHANNEL_PTR
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp CHANFLAGS_INITIALISED | CHANFLAGS_ACTIVE ; channel's CHANNEL_FLAGS
	jr c, StopTrack_FromChannelPtr
	inc hl
	ld a, [hl] ; TRACK_DURATION
	and a
	ret z
	dec [hl]
	ret nz
;	fallthrough

ReleaseTrack:
	ld bc, TRACK_FLAGS - TRACK_DURATION
	add hl, bc
	ld a, [hl] ; TRACK_FLAGS
	bit TRACKFLAGS_START_ENVELOPE_F, a
	jr nz, StopTrack
	or TRACKFLAGS_FADING | TRACKFLAGS_START_ENVELOPE
	and $ff ^ TRACKFLAGS_HELD
	ld [hl], a
	ret

StopTrack_FromChannelPtr:
	ld bc, TRACK_FLAGS - (TRACK_CHANNEL_PTR + 2)
	add hl, bc
	; fallthrough

StopTrack:
	xor a
	ld [hl], a
	jp TurnSoundRegisterOff

ProcessTrack:
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	ld a, [hl] ; TRACK_FLAGS
	bit TRACKFLAGS_ACTIVE_F, a
	ret z

	ld b, a
	push hl
	ld de, TRACK_CHANNEL_PTR
	add hl, de
	ld a, [hli]
	ld [wCurChannelPtr + 0], a
	ld e, a
	ld a, [hli]
	ld [wCurChannelPtr + 1], a
	ld d, a
	ld a, [de]
	cp CHANFLAGS_INITIALISED | CHANFLAGS_ACTIVE
	jr nc, .channel_active
	pop hl
	jr StopTrack

.channel_active
	ld [wCurChannelFlags], a
	bit TRACKFLAGS_START_ENVELOPE_F, b
	jr nz, .start_envelope
	ld de, TRACK_FREQUENCY - (TRACK_CHANNEL_PTR + 2)
	add hl, de
	ld a, [wEnvelopeFrameCycle]
	and a
	jr nz, .inc_counter
	inc [hl]
.inc_counter
	inc [hl]
	pop hl
	bit TRACKFLAGS_HELD_F, b
	jr z, .released
	bit TRACKFLAGS_FADING_F, b
	jr nz, .fade_in_step
	jp .sustain_step
.released
	bit TRACKFLAGS_FADING_F, b
	jp nz, .fade_out_step
	jp .release_countdown

.start_envelope
	pop hl
	res TRACKFLAGS_START_ENVELOPE_F, [hl]
	bit TRACKFLAGS_HELD_F, [hl]
	jr z, .fade_out

	push hl
	call SetTimbre
	pop hl

	ld a, [wCurChannelFlags]
	or CHANFLAGS_UPDATE_SO | CHANFLAGS_UPDATE_VOLUME | CHANFLAGS_UPDATE_FREQUENCY
	ld [wCurChannelFlags], a
	call .SetVolumeFromNoteVolume

; fade in
	ld bc, TRACK_FADE_IN_ENVELOPE
	add hl, bc
	ld a, [hl]
	ld bc, TRACK_VOLUME_ENVELOPE - TRACK_FADE_IN_ENVELOPE
	add hl, bc
	swap a
	cpl
	rrca
	and %111 ; bits 7, 6, and 5 of TRACK_FADE_IN_ENVELOPE
	jr z, .fade_in_done
	or %1000 ; amplify
	ld [hli], a ; TRACK_VOLUME_ENVELOPE
	xor a
	ld [hli], a ; TRACK_FREQUENCY low
	jp .update_registers

.fade_out
	ld bc, TRACK_FADE_OUT_ENVELOPE
	add hl, bc
	ld b, [hl]
	ld de, TRACK_VOLUME_ENVELOPE - TRACK_FADE_OUT_ENVELOPE
	add hl, de
	ld a, [hl]
	and $f0
	jp z, .start_release ; if mute setting
	ld c, a
	ld a, b
	cpl
	rrca
	and %111
	jp z, .start_release
	or c
	ld [hli], a
	xor a
	ld [hli], a
	jp .update_volume

.fade_in_step
	ld a, [wCurChannelFlags]
	bit CHANFLAGS_UPDATE_VOLUME_F, a
	call nz, .SetVolumeFromNoteVolume

	ld bc, TRACK_VOLUME_ENVELOPE
	add hl, bc
	ld a, [hli]
	and %111 ; length
	dec a
	cp [hl] ; TRACK_FREQUENCY
	jr nc, .check_reached_volume ; if (length - 1) >= freq lo
	xor a
	ld [hld], a ; TRACK_FREQUENCY
	ld a, [hl] ; TRACK_VOLUME_ENVELOPE
	add $10
	jr c, .fade_in_done
	call .CheckWaveVolumeChange
	ld [hli], a
.check_reached_volume
	dec hl
	ld a, [hld]
	cp [hl]
	jp c, .keep_volume
	inc hl
.fade_in_done
	ld bc, TRACK_FADE_IN_ENVELOPE - TRACK_VOLUME_ENVELOPE
	add hl, bc
	ld b, [hl]
	ld de, TRACK_VOLUME - TRACK_FADE_IN_ENVELOPE
	add hl, de
	ld c, [hl]
	push bc
	ld bc, TRACK_FLAGS - TRACK_VOLUME
	add hl, bc
	res TRACKFLAGS_FADING_F, [hl]
	call .SetVolumeWithFadeOut
	ld d, a
	ld bc, TRACK_VOLUME_ENVELOPE
	add hl, bc
	pop bc
	ld a, b
	cpl
	rrca
	and %111 ; bits 3, 2, and 1 of TRACK_FADE_IN_ENVELOPE
	jr nz, .set_envelope
	call .CheckEnvelopeValue
	jr z, .start_release
	ld a, d
	ld c, d
.set_envelope
	or c
	ld [hli], a ; TRACK_VOLUME_ENVELOPE
	xor a
	ld [hli], a ; TRACK_FREQUENCY lo
	jp .update_volume

.sustain_step
	ld a, [wCurChannelFlags]
	bit CHANFLAGS_UPDATE_VOLUME_F, a
	call nz, .SetVolumeWithFadeOut
	ld bc, TRACK_VOLUME_ENVELOPE
	add hl, bc
	ld a, [hli]
	and %111
	jr z, .no_sustain_envelope
	dec a
	cp [hl]
	jr nc, .check_sustain_floor
	xor a
	ld [hld], a
	ld a, [hl]
	sub $10
	jr c, .sustain_done
	call .CheckWaveVolumeChange
	ld [hli], a
.check_sustain_floor
	dec hl
	dec hl
	ld a, [hli]
	or $0f
	cp [hl]
	jr c, .keep_volume
.sustain_done
	call .CheckEnvelopeValue
	jr z, .start_release
	dec hl
.copy_envelope
	ld a, [hli]
	ld [hl], a
	jr .update_volume

.no_sustain_envelope
	dec hl
	ld a, [hld]
	xor [hl]
	jr nz, .copy_envelope
	jr .update_registers

.fade_out_step
	ld bc, TRACK_VOLUME_ENVELOPE
	add hl, bc
	ld a, [hli]
	and $07
	dec a
	cp [hl] ; TRACK_FREQUENCY
	jr nc, .keep_volume
	xor a
	ld [hld], a ; TRACK_FREQUENCY
	ld a, [hl] ; TRACK_VOLUME_ENVELOPE
	sub $10
	jr c, .start_release
	call .CheckWaveVolumeChange
	ld [hl], a
	jr .keep_volume

	; unreachable
	dec hl

.start_release
	push hl
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_EFFECTIVE_VOLUME
	add hl, bc
	ld b, [hl]
	ld de, CHANNEL_RELEASE_VOLUME - CHANNEL_EFFECTIVE_VOLUME
	add hl, de
	ld a, [hli]
	ld c, a
	ld d, [hl] ; CHANNEL_RELEASE_LENGTH
	pop hl

	; b = CHANNEL_EFFECTIVE_VOLUME
	; c = CHANNEL_RELEASE_VOLUME
	; d = CHANNEL_RELEASE_LENGTH

	ld a, b
	and a
	jr z, .stop_track
	ld a, c
	and a
	jr z, .stop_track
	ld a, d
	and a
	jr z, .stop_track
	call MultiplyBByC_Short
	add $0f
	and $f0
	ld [hli], a ; TRACK_VOLUME_ENVELOPE
	ld [hl], d ; TRACK_FREQUENCY
	ld bc, TRACK_FLAGS - TRACK_FREQUENCY
	add hl, bc
	ld a, [hl] ; TRACK_FLAGS
	and $ff ^ (TRACKFLAGS_FADING | TRACKFLAGS_HELD | TRACKFLAGS_START_ENVELOPE)
	ld [hl], a
	jr .update_volume

.release_countdown
	ld bc, TRACK_FREQUENCY
	add hl, bc
	dec [hl]
	jr nz, .update_registers
.stop_track
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	xor a
	ld [hl], a
	jp TurnSoundRegisterOff

.keep_volume
	ld a, [wCurSoundRegister]
	cp LOW(rAUD3LEVEL)
	jr z, .update_registers
	ld a, [wCurChannelFlags]
	res CHANFLAGS_UPDATE_VOLUME_F, a
	ld [wCurChannelFlags], a
	jr .update_registers

.update_volume
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_VOLUME_F, a
	ld [wCurChannelFlags], a

.update_registers
	ld a, [wCurChannelFlags]
	bit CHANFLAGS_UPDATE_FREQUENCY_F, a
	jr z, .skip_frequency
	call SetFrequency
	ld a, [wCurChannelFlags]
.skip_frequency

	bit CHANFLAGS_UPDATE_SO_F, a
	jr z, .skip_so
	call SetSoundOutput
	ld a, [wCurChannelFlags]
.skip_so

	bit CHANFLAGS_UPDATE_VOLUME_F, a
	ret z ; skip envelope
	jp SetVolumeEnvelope

.CheckEnvelopeValue:
	ld bc, TRACK_FADE_OUT_ENVELOPE - TRACK_VOLUME_ENVELOPE
	add hl, bc
	ld a, [hl]
	ld bc, TRACK_VOLUME_ENVELOPE - TRACK_FADE_OUT_ENVELOPE
	add hl, bc
	and $f0
	ret

.SetVolumeFromNoteVolume:
	push hl
	ld bc, TRACK_NOTE_VOLUME
	add hl, bc
	ld c, [hl]
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld de, CHANNEL_EFFECTIVE_VOLUME
	add hl, de
	ld b, [hl]
	call MultiplyBByC_Short
	add $0f
	and $f0
	pop hl
	ld de, TRACK_VOLUME
	add hl, de
	ld [hl], a
	ld de, TRACK_FLAGS - TRACK_VOLUME
	add hl, de
	ret

.SetVolumeWithFadeOut:
	push hl
	ld bc, TRACK_FADE_OUT_ENVELOPE
	add hl, bc
	ld b, [hl]
	ld de, TRACK_NOTE_VOLUME - TRACK_FADE_OUT_ENVELOPE
	add hl, de
	ld c, [hl]
	call MultiplyBByC_Short
	add $0f
	ld c, a
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld de, CHANNEL_EFFECTIVE_VOLUME
	add hl, de
	ld b, [hl]
	call MultiplyBByC_Short
	add $0f
	and $f0
	pop hl
	ld de, TRACK_VOLUME
	add hl, de
	ld [hl], a
	ld de, TRACK_FLAGS - TRACK_VOLUME
	add hl, de
	ret

.CheckWaveVolumeChange:
	ld b, a
	ld a, [wCurSoundRegister]
	cp LOW(rAUD3LEVEL)
	ld a, b
	ret nz ; not sound3
	xor [hl]
	and $c0
	jr z, .same_wave_volume
	ld a, [wCurChannelFlags]
	set CHANFLAGS_UPDATE_VOLUME_F, a
	ld [wCurChannelFlags], a
.same_wave_volume
	ld a, b
	ret

SetTimbre:
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	ld bc, TRACK_TIMBRE
	add hl, bc
	ld a, [wCurSoundRegister]
	ld c, a
	cp LOW(rAUD3LEVEL)
	jr c, .rect_sound
	jr z, .sound3

; noise
	; if bit 0 is set, sets polynomial counter step to 7
	; otherwise sets it to 15
	ld a, [hli]
	rlca
	rlca
	rlca
	and %1000
	ld b, a
	inc c
	ld a, [$ff00+c] ; rAUD4POLY
	and $ff ^ AUD4POLY_7STEP
	or b
	ld [$ff00+c], a
	ld a, [hl] ; duration
	and a
	jr z, .no_noise_duration
	cpl
	inc a ; -a
	ldh [rAUD4LEN], a
	ld a, AUD4GO_LENGTH_ON
.no_noise_duration
	or AUD4GO_RESTART
	ldh [rAUD4GO], a
	ret

.rect_sound
	ld a, [hli] ; duty cycle
	rrca
	rrca
	and AUD1LEN_DUTY
	ld b, a
	ld a, [hli] ; duration
	and a
	jr z, .no_rect_duration
	cpl
	inc a ; -a
	and AUD1LEN_TIMER
	or b
	ld b, a
	ld a, AUD1HIGH_LENGTH_ON
.no_rect_duration
	inc c
	inc c
	ld [$ff00+c], a ; freq hi
	dec c
	dec c
	dec c
	ld a, b
	ld [$ff00+c], a ; length / duty cycle
	dec c
	ld a, [hl]
	ld [$ff00+c], a ; sweep
	ret

.sound3
	ld a, [hli]
	sub WAVEFORM_SINE
	ld b, a
	ld a, [hl] ; TRACK_LENGTH
	and a
	jr z, .no_sound3_duration
	cpl
	inc a ; -a
	ldh [rAUD3LEN], a
	ld a, %01000000 ; counter
.no_sound3_duration
	ldh [rAUD3HIGH], a

	ld a, [wCurWaveSample]
	cp b
	ret z ; no need to load
	ld a, b
	ld [wCurWaveSample], a
	ld l, b
	ld h, $00
	add hl, hl ; *2
	add hl, hl ; *4
	add hl, hl ; *8
	add hl, hl ; *16
	ld bc, WaveSamples
	add hl, bc

	ld c, LOW(_AUD3WAVERAM)
	ld b, AUD3WAVE_SIZE
.loop_wave_sample
	ld a, [hli]
	ld [$ff00+c], a
	inc c
	dec b
	jr nz, .loop_wave_sample
	ret

SetFrequency:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_FREQUENCY
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]

	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	ld de, TRACK_FREQUENCY_NOTE
	add hl, de
	ld a, [hl]
	add b
	ld b, a

	ld a, [wCurSoundRegister]
	cp LOW(rAUD3LEVEL)
	jr c, .rect_sound
	jr nz, .noise

; sound3
	; channel 3 plays an octave higher
	ld a, b
	add (C_1 - C_0)
	ld b, a
.rect_sound
	push hl
	ld a, b
	call GetNoteFrequency
	ld b, a
	call MultiplyBByC
	ld bc, $ff
	add hl, bc
	ld l, h
	ld h, $00
	add hl, de

	ld a, [wCurSoundRegister]
	ld c, a
	inc c
	ld a, l
	ld [$ff00+c], a ; freq lo
	inc c
	ld a, [$ff00+c] ; freq hi
	and AUD1HIGH_LENGTH_ON ; AUD2HIGH_LENGTH_ON/AUD3HIGH_LENGTH_ON/AUD1HIGH_LENGTH_ON/AUD4GO_LENGTH_ON
	jr z, .length_counter
	or h
	ld [$ff00+c], a
	jr .skip_length
.length_counter
	or h
	ld [$ff00+c], a ; freq hi
	ld b, a
	ld a, [wCurSoundRegister]
	ld c, a
	dec c
	ld a, [$ff00+c] ; length
	and %11000000 ; clear length data
	ld [$ff00+c], a
	ld a, b
.skip_length
	pop hl
	ld bc, TRACK_FREQUENCY + 1 - TRACK_FREQUENCY_NOTE
	add hl, bc
	or AUD1HIGH_RESTART ; AUD2HIGH_RESTART/AUD3HIGH_RESTART/AUD4GO_RESTART
	ld [hl], a
	ret

.noise
	ld c, a ; rAUD4ENV
	inc c
	ld a, b
	sub $0d
	cpl
	ld b, a
	and %11
	ld d, a
	ld a, b
	cp $c0
	jr c, .write_poly
	and AUD4POLY_SHIFT >> 2
	rlca
	rlca
	or d
	or 4 & AUD4POLY_DIV
	ld d, a
.write_poly
	ld a, [$ff00+c] ; rAUD4POLY
	and AUD4POLY_7STEP
	or d
	ld [$ff00+c], a
	inc c
	ld a, [$ff00+c] ; rAUD4GO
	or AUD4GO_RESTART
	ld [$ff00+c], a
	ret

SetSoundOutput:
	ld a, [wCurChannelPtr + 0]
	ld l, a
	ld a, [wCurChannelPtr + 1]
	ld h, a
	ld bc, CHANNEL_SO_FLAGS
	add hl, bc
	ld a, [wCurSoundRegister]
	cp LOW(rAUD2ENV)
	jr c, .sound1
	jr z, .sound2
	cp LOW(rAUD4ENV)
	jr c, .sound3

; sound4
	lb de, $ff ^ (AUDTERM_4_RIGHT | AUDTERM_4_LEFT), AUDTERM_4_RIGHT | AUDTERM_4_LEFT
	jr .got_masks
.sound1
	lb de, $ff ^ (AUDTERM_1_RIGHT | AUDTERM_1_LEFT), AUDTERM_1_RIGHT | AUDTERM_1_LEFT
	jr .got_masks
.sound2
	lb de, $ff ^ (AUDTERM_2_RIGHT | AUDTERM_2_LEFT), AUDTERM_2_RIGHT | AUDTERM_2_LEFT
	jr .got_masks
.sound3
	lb de, $ff ^ (AUDTERM_3_RIGHT | AUDTERM_3_LEFT), AUDTERM_3_RIGHT | AUDTERM_3_LEFT

.got_masks
	bit 7, [hl]
	jr nz, .bit7_set
	bit 6, [hl]
	jr z, .no_panning
	; only bit 6 set
	ld a, SO_RIGHT
	jr .apply_so_mask
.bit7_set
	bit 6, [hl]
	jr nz, .no_panning
	; only bit 7 set
	ld a, SO_LEFT
	jr .apply_so_mask ; useless jump
.apply_so_mask
	and e
	ld e, a
.no_panning
	ld c, LOW(rAUDTERM)
	ld a, [$ff00+c]
	and d
	or e
	ld [$ff00+c], a
	ret

SetVolumeEnvelope:
	ld a, [wCurTrackPtr + 0]
	ld l, a
	ld a, [wCurTrackPtr + 1]
	ld h, a
	ld bc, TRACK_VOLUME_ENVELOPE
	add hl, bc
	ld a, [hli]
	ld b, a
	ld a, [wCurSoundRegister]
	ld c, a
	cp LOW(rAUD3LEVEL)
	jr c, .rect
	jr z, .sound3

; noise
	ld a, b
	ld [$ff00+c], a
	ldh a, [rAUD4GO]
	or AUD4GO_RESTART
	ldh [rAUD4GO], a
	ret

.rect
	ld a, b
	ld [$ff00+c], a
	inc c
	inc c
	inc hl
	ld a, [hl]
	ld [$ff00+c], a ; freq hi
	ret

.sound3
; if flags 7 and 6 are:
; - %00 -> %00 (muted)
; - %01 -> %11 (shifted 2 bits)
; - %10 -> %10 (shifted 1 bit)
; - %11 -> %01 (unmodified)
	ld a, b
	sub $40
	xor %11000000
	rrca
	ld [$ff00+c], a

	ldh a, [rAUD3ENA]
	rla
	ret c ; sound is on
	ld a, AUD3ENA_ON
	ldh [rAUD3ENA], a
	inc hl
	ld a, [hl]
	ldh [rAUD3HIGH], a ; freq hi
	ret

TurnSoundRegisterOff:
	ld a, [wCurSoundRegister]
	ld c, a
	cp LOW(rAUD3LEVEL)
	jr z, .sound3
	ld a, %00001000 ; envelope up
	ld [$ff00+c], a
	inc c
	inc c
	ld a, %10000000 ; initialise
	ld [$ff00+c], a
	ret

.sound3
	ld a, AUD3ENA_OFF
	ldh [rAUD3ENA], a
	ret

; input:
; - a = note
; output:
; - de = frequency
; - a  = ?
GetNoteFrequency:
	sub C_0
	jr nc, .no_underflow
	xor a ; C_0
.no_underflow
	cp (B_9 + 1) - C_0
	jr c, .no_cap
	; cap to B_9
	ld a, B_9 - C_0
.no_cap
	ld d, $00
	ld e, a
	add e ; *2
	add e ; *3
	rl d
	ld e, a
	ld hl, NoteFrequencies
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hl]
	ret

; returns hl = b * c
MultiplyBByC:
	ld h, b
	ld l, $00
	ld b, l
REPT 7
	add hl, hl
	jr nc, :+
	add hl, bc
:
ENDR
	add hl, hl
	ret nc
	add hl, bc
	ret

; performs Q4 precision multiplication
; returns a = high nybble b * high nybble c
MultiplyBByC_Short:
	ld a, c
	and $f0 ; high nybble
	swap a
	ld c, a
	ld a, b
	and $f0 ; high nybble
REPT 3
	add a
	jr nc, :+
	add c
:
ENDR
	add a
	ret nc
	add c
	ret

AudioCmdDurations:
	db  0 ; 80 | cf
	db  1 ; 81 | d0
	db  2 ; 82 | d1
	db  3 ; 83 | d2
	db  4 ; 84 | d3
	db  5 ; 85 | d4
	db  6 ; 86 | d5
	db  7 ; 87 | d6
	db  8 ; 88 | d7
	db  9 ; 89 | d8
	db 10 ; 8a | d9
	db 11 ; 8b | da
	db 12 ; 8c | db
	db 13 ; 8d | dc
	db 14 ; 8e | dd
	db 15 ; 8f | de
	db 16 ; 90 | df
	db 17 ; 91 | e0
	db 18 ; 92 | e1
	db 19 ; 93 | e2
	db 20 ; 94 | e3
	db 21 ; 95 | e4
	db 22 ; 96 | e5
	db 23 ; 97 | e6
	db 24 ; 98 | e7
	db 28 ; 99 | e8
	db 30 ; 9a | e9
	db 32 ; 9b | ea
	db 36 ; 9c | eb
	db 40 ; 9d | ec
	db 42 ; 9e | ed
	db 44 ; 9f | ee
	db 48 ; a0 | ef
	db 52 ; a1 | f0
	db 54 ; a2 | f1
	db 56 ; a3 | f2
	db 60 ; a4 | f3
	db 64 ; a5 | f4
	db 66 ; a6 | f5
	db 68 ; a7 | f6
	db 72 ; a8 | f7
	db 76 ; a9 | f8
	db 78 ; aa | f9
	db 80 ; ab | fa
	db 84 ; ac | fb
	db 88 ; ad | fc
	db 90 ; ae | fd
	db 92 ; af | fe
	db 96 ; b0 | ff

NoteFrequencies:
	dwb  $2c, $70 ; C_0
	dwb  $9d, $6a ; C#0
	dwb $107, $64 ; D_0
	dwb $16b, $5f ; D#0
	dwb $1c9, $59 ; E_0
	dwb $223, $54 ; F_0
	dwb $277, $50 ; F#0
	dwb $2c7, $4b ; G_0
	dwb $312, $47 ; G#0
	dwb $358, $43 ; A_0
	dwb $39b, $3f ; A#0
	dwb $3da, $3c ; B_0
	dwb $416, $38 ; C_1
	dwb $44e, $35 ; C#1
	dwb $483, $32 ; D_1
	dwb $4b5, $30 ; D#1
	dwb $4e4, $2d ; E_1
	dwb $511, $2a ; F_1
	dwb $53b, $28 ; F#1
	dwb $563, $26 ; G_1
	dwb $589, $24 ; G#1
	dwb $5ac, $22 ; A_1
	dwb $5cd, $20 ; A#1
	dwb $5ed, $1e ; B_1
	dwb $60b, $1c ; C_2
	dwb $627, $1b ; C#2
	dwb $642, $19 ; D_2
	dwb $65b, $18 ; D#2
	dwb $672, $16 ; E_2
	dwb $689, $15 ; F_2
	dwb $69e, $14 ; F#2
	dwb $6b2, $13 ; G_2
	dwb $6c4, $12 ; G#2
	dwb $6d6, $11 ; A_2
	dwb $6e7, $10 ; A#2
	dwb $6f6, $0f ; B_2
	dwb $705, $0e ; C_3
	dwb $714, $0d ; C#3
	dwb $721, $0d ; D_3
	dwb $72d, $0c ; D#3
	dwb $739, $0b ; E_3
	dwb $744, $0b ; F_3
	dwb $74f, $0a ; F#3
	dwb $759, $09 ; G_3
	dwb $762, $09 ; G#3
	dwb $76b, $08 ; A_3
	dwb $773, $08 ; A#3
	dwb $77b, $08 ; B_3
	dwb $783, $07 ; C_4
	dwb $78a, $07 ; C#4
	dwb $790, $06 ; D_4
	dwb $797, $06 ; D#4
	dwb $79d, $06 ; E_4
	dwb $7a2, $05 ; F_4
	dwb $7a7, $05 ; F#4
	dwb $7ac, $05 ; G_4
	dwb $7b1, $04 ; G#4
	dwb $7b5, $04 ; A_4
	dwb $7ba, $04 ; A#4
	dwb $7be, $04 ; B_4
	dwb $7c1, $04 ; C_5
	dwb $7c5, $03 ; C#5
	dwb $7c8, $03 ; D_5
	dwb $7cb, $03 ; D#5
	dwb $7ce, $03 ; E_5
	dwb $7d1, $03 ; F_5
	dwb $7d4, $03 ; F#5
	dwb $7d6, $02 ; G_5
	dwb $7d9, $02 ; G#5
	dwb $7db, $02 ; A_5
	dwb $7dd, $02 ; A#5
	dwb $7df, $02 ; B_5
	dwb $7e1, $02 ; C_6
	dwb $7e2, $02 ; C#6
	dwb $7e4, $02 ; D_6
	dwb $7e6, $01 ; D#6
	dwb $7e8, $01 ; E_6
	dwb $7e9, $01 ; F_6
	dwb $7ea, $01 ; F#6
	dwb $7eb, $01 ; G_6
	dwb $7ec, $01 ; G#6
	dwb $7ed, $01 ; A_6
	dwb $7ee, $01 ; A#6
	dwb $7ef, $01 ; B_6
	dwb $7f0, $01 ; C_7
	dwb $7f1, $01 ; C#7
	dwb $7f2, $01 ; D_7
	dwb $7f3, $01 ; D#7
	dwb $7f4, $01 ; E_7
	dwb $7f4, $01 ; F_7
	dwb $7f5, $01 ; F#7
	dwb $7f6, $01 ; G_7
	dwb $7f6, $01 ; G#7
	dwb $7f7, $01 ; A_7
	dwb $7f7, $01 ; A#7
	dwb $7f8, $01 ; B_7
	dwb $7f8, $01 ; C_8
	dwb $7f9, $01 ; C#8
	dwb $7f9, $01 ; D_8
	dwb $7f9, $01 ; D#8
	dwb $7fa, $01 ; E_8
	dwb $7fa, $01 ; F_8
	dwb $7fa, $01 ; F#8
	dwb $7fb, $01 ; G_8
	dwb $7fb, $01 ; G#8
	dwb $7fb, $01 ; A_8
	dwb $7fc, $01 ; A#8
	dwb $7fc, $01 ; B_8
	dwb $7fc, $01 ; C_9
	dwb $7fc, $01 ; C#9
	dwb $7fd, $01 ; D_9
	dwb $7fd, $01 ; D#9
	dwb $7fd, $01 ; E_9
	dwb $7fd, $01 ; F_9
	dwb $7fd, $01 ; F#9
	dwb $7fd, $01 ; G_9
	dwb $7fe, $01 ; G#9
	dwb $7fe, $01 ; A_9
	dwb $7fe, $01 ; A#9
	dwb $7fe, $01 ; B_9

POPO
