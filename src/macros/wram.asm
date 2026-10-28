MACRO sprite_oam_struct
\1YCoord::     db
\1XCoord::     db
\1Frame::      db
\1Attributes:: db
; bit 7: priority
; bit 6: y flip
; bit 5: x flip
; bit 4: pal # (non-cgb)
; bit 3: vram bank (cgb only)
; bit 2-0: pal # (cgb only)
ENDM

MACRO menu_obj_struct
	sprite_oam_struct \1
\1FramesetOffset::  db
\1Duration::        db
\1FramesetPtr::     dw
\1End::
ENDM

MACRO menu_obj_ext_struct
	menu_obj_struct \1
\1Var::            db
\1OAMPtr::         dw
\1AnimationEnded:: db
\1OAMBank::        db
ENDM

MACRO scene_obj_struct
	sprite_oam_struct \1
\1Duration::       db
\1FramesetOffset:: db
\1State::          db
\1MovementStep::   db
\1End::
ENDM

; the part of an ow_path_tracer_struct that is copied
; to wCurOWPathTracer while the tracer is updated;
; bytes 0-6 are laid out like a scene_obj_struct
MACRO ow_path_tracer_head_struct
	sprite_oam_struct \1
\1Duration::       db
\1FramesetOffset:: db
\1SpriteState::    db ; animation state of its sprite
\1TracerState::    db ; PathPreview_RunTracers.UpdateTracer step, 5 = done
\1Counter::        db
ENDM

; one of the four tracers of the B-button path preview
MACRO ow_path_tracer_struct
	ow_path_tracer_head_struct \1
\1LineState:: ds 7 ; saved wOWLineFlags..wOWLineXStep
\1Coords::    ds 8 ; saved wOWCoords1 and the 7 bytes after it
	ds 8
ENDM

; a column of tiles copied into wTilemap and wAttrmap,
; one row per call (EOWFunc_FreezeSea, CopyOWTileColumn1-3)
MACRO ow_tile_column_copy_struct
\1Counter::  db ; 0 = inactive, else counts 1-5 (a column every 4 frames)
\1ListPtr::  dw ; next entry of the scene's column list
\1RowsLeft:: db
\1Dest::     dw ; in wTilemap (the attribute goes $300 bytes lower)
\1Source::   dw ; tiles (attributes are $a0 bytes after them)
ENDM

; wSceneObj1Script-15Script
MACRO scene_obj_script_struct
\1Step::    db
\1Counter:: db
ENDM

MACRO ow_anim_struct
\1Duration:: db ; frames per animation frame, 0 = stopped
\1Counter::  db
\1Frame::    db ; 0-3
ENDM

MACRO golf_obj_struct
\1State::          db
\1Duration::       db
\1FramesetOffset:: db
\1CurrentFrame::   db
\1Sprite:: sprite_oam_struct \1
ENDM

MACRO obj_struct
\1Flags::           db
\1MapPtrLo::        db
\1MapPtrHi::        db
\1YPos::            dw
\1XPos::            dw
\1Id::              db
\1InteractionType:: db
\1CollBoxTop::      db
\1CollBoxBottom::   db
\1CollBoxLeft::     db
\1CollBoxRight::    db
\1ScreenYPos::      db
\1ScreenXPos::      db
\1Frame::           db
\1OAMPtr::          dw
\1FramesetPtr::     dw
\1FrameDuration::   db
\1FramesetOffset::  db
\1StateDuration::   db
\1Var1::            db
\1Var2::            db
\1Var3::            db
\1SubState::        db
; bit 7: set if facing right, left otherwise
\1State::           db
\1Action::          db
\1ActionSide::      db
\1UpdateFunction::  dw
ENDM

MACRO pal_config_struct
\1Register::   db
\1Index::      db
\1Number::     db
\1SourceHi::   db
\1SourceLo::   db
\1TotalSteps:: db
ENDM

MACRO hdma_config_struct
\1SourceHi:: db
\1SourceLo:: db
\1DestHi::   db
\1DestLo::   db
\1Mode::     db
ENDM

MACRO particle_struct
\1ID::             db ; PARTICLE_* constant
\1Initialised::    db
\1YPos::           dw
\1XPos::           dw
\1Duration::       db
\1FramesetOffset:: db
\1Frame::          db
\1Unused09::       db
\1Unused0a::       db
\1Unused0b::       db
\1Unused0c::       db
\1Unused0d::       db
\1Unused0e::       db
\1Unused0f::       db
ENDM

MACRO channel_struct
; see the CHANNEL_* constants
\1Flags::               db
\1Duration::            db
\1CmdPtr::              dw
\1SoundBank::           db
\1Unused05::            db
\1SoundID::             dw
\1Priority::            db
\1Pitch::               db
\1NoteVolume::          db
\1NoteDuration::        db
\1Timbre::              db
\1Length::              db
\1Sweep::               db
\1FadeInEnvelope::      db
\1FadeOutEnvelope::     db
\1ActiveCommand::       db
\1SemitoneOffset::      db
\1PitchOffsetMod::      dw
\1Volume::              db
\1VolumeMod::           db
\1SinglePan::           db
\1GlobalPan::           db
\1PitchOffset::         db
\1PitchOffsetMult::     db
\1PitchProduct::        dw
\1FrequencyOffset::     db
\1Unused1e::            db
\1VibratoSpeed::        db
\1VibratoValue::        db
\1VibratoAmplitude::    db
\1VibratoAmplitudeMod:: db
\1VibratoDisabled::     db
\1VibratoFreqOffset::   dw
\1CallDepth::           db
\1ReleaseVolume::       db
\1ReleaseLength::       db
\1LoopCounter::         db
\1VibratoDelay::        db
\1VibratoCounter::      db
\1Frequency::           dw
\1SOFlags::             db
; bits 7 and 6 determine sound ouput
; %01 -> only SO1
; %10 -> only SO2
; otherwise, both SO used
\1EffectiveVolume::     db
\1Unused30::            db
\1Unused31::            db
\1CallStack::           ds 10
ENDM

MACRO track_struct
; see the TRACK_* constants
\1Flags::          db
\1Priority::       db
\1Owner::          db
\1Note::           db
\1ChannelPtr::     dw ; pointer to a channel_struct
\1NoteVolume::     db
\1Duration::       db
\1Timbre::         db
; in case of sound1 and sound2, duty cycle
; bits 6-7 (0:12.5% 1:25% 2:50% 3:75%)
; in case of sound3, a WAVEFORM_* constant
\1Length::          db
\1Sweep::           db
\1FadeInEnvelope::  db
\1FadeOutEnvelope:: db
\1Unused0d::        db
\1FrequencyNote::   db
\1Unused0f::        db
\1Volume::          db
\1VolumeEnvelope::  db
\1Frequency::       dw
\1Unused14::        db
\1Unused15::        db
\1Unused16::        db
\1Unused17::        db
ENDM

MACRO temple_rock_struct
\1Action::      db
; 0 = ?
; 1 = Spawn in
; 2 = Update
; 3 = Reset
\1Counter::     db
\1Size::        db ; medium or large if 2, else it's small
\1RespawnTime:: db
ENDM

MACRO temple_music_box_struct
\1Action::      db
; 0 = ?
; 1 = Init
; 2 = Move up left
; 3 = Move in circle
\1Counter::     db
ENDM

MACRO plane_part_struct
\1Action::      db
\1Counter::     db
ENDM

; offsets are the COLOURFADESTRUCT_* constants
MACRO colour_part_fade_struct
\1Base::        db
\1Target::      db
\1Sign::        db ; $1 = incr, $2 = decr
\1Diff::        db
\1Accumulator:: db
\1Current::     db
	ds 2 ; unused
ENDM

MACRO colour_fade_struct
	colour_part_fade_struct \1Red
	colour_part_fade_struct \1Green
	colour_part_fade_struct \1Blue
ENDM

MACRO pal_fade_struct
	FOR n, 1, PAL_COLORS + 1
		colour_fade_struct \1Colour{u:n}
	ENDR
ENDM
