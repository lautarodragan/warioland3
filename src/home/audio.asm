InitAudio::
	push_wram BANK("Audio RAM")
	call AudioFunc_InitAudio
	pop_wram
	ret

UpdateAudio::
	push_wram BANK("Audio RAM")
	call AudioFunc_UpdateAudio
	pop_wram
	ret

; input:
; - bc = sound ID
PlaySFX::
	push_wram BANK("Audio RAM")
	call AudioFunc_PlaySFX
	pop_wram
	ret

; unreferenced
UnreferencedPlayMusic:
	push_wram BANK("Audio RAM")
	call AudioFunc_PlayMusic
	pop_wram
	ret

; input:
; - bc = sound ID
PlayNewMusic::
	push_wram BANK("Audio RAM")
	call AudioFunc_PlayNewMusic
	pop_wram
	ret

; turns off all SFX channels playing
; SFX ID given by bc
; if bc = SOUND_OFF, then turn off all SFX
; only ever used to switch SFX off (SOUND_OFF)
; input:
; - bc = sound ID
TurnOffSFXID::
	push_wram BANK("Audio RAM")
	call AudioFunc_TurnOffSFXID
	pop_wram
	ret

TurnMusicOff::
	push_wram BANK("Audio RAM")
	call AudioFunc_TurnMusicOff
	pop_wram
	ret

; unreferenced
UnreferencedReactivateMusic:
	push_wram BANK("Audio RAM")
	call AudioFunc_ReactivateMusicChannels
	pop_wram
	ret

; unreferenced
UnreferencedGetActiveChannels:
	push_wram BANK("Audio RAM")
	call AudioFunc_GetActiveChannels
	pop_wram
	ret

; input:
; - a = AUDIOMOD_* constant
; - c = wSoundEngineParam1
; - b = wSoundEngineParam2
; - e = wSoundEngineParam3
; - d = wSoundEngineParam4
ExecuteAudioMod::
	ldh [hAudioTempA], a
	push_wram BANK("Audio RAM")
	ldh a, [hAudioTempA]
	call AudioFunc_ExecuteAudioMod
	pop_wram
	ret

; unreferenced
; input:
; - a = fade out period (the higher the value, the slower the fade out)
UnreferencedMusicFadeOut:
	ldh [hAudioTempA], a
	push_wram BANK("Audio RAM")
	ldh a, [hAudioTempA]
	call AudioFunc_MusicFadeOut
	pop_wram
	ret

; unreferenced
; output:
; - bc = sound ID
UnreferencedGetPlayingSoundID:
	ldh [hAudioTempA], a
	push_wram BANK("Audio RAM")
	ldh a, [hAudioTempA]
	call AudioFunc_GetPlayingSoundID
	pop_wram
	ret

; input:
; - bc = sound ID
PlayNewMusic_SetNoise::
	push_wram BANK("Audio RAM")
	call AudioFunc_PlayNewMusic_SetNoise
	pop_wram
	ret
