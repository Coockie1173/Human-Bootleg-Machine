init_sound:
    lda #1
    ldx #.lobyte(music_data_testsongs)
    ldy #.hibyte(music_data_testsongs)
    jsr famistudio_init
rts

init_sfx:
    lda #1
    ldx #.lobyte(sounds)
    ldy #.hibyte(sounds)
    jsr famistudio_sfx_init
rts

play_song1:
    lda #0
    jsr famistudio_music_play
rts

play_song2:
    lda #1
    jsr famistudio_music_play
rts

play_sfx1:
    lda #0
    ldx #FAMISTUDIO_SFX_CH0   ; choose a channel to override
    jsr famistudio_sfx_play
rts

play_sfx2:
    lda #1
    ldx #FAMISTUDIO_SFX_CH0  ; choose a channel to override
    jsr famistudio_sfx_play
rts