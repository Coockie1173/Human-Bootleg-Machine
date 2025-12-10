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

play_song_menu:
    lda MUSIC_MENU
    jsr famistudio_music_play
rts

play_song_gameplay:
    lda MUSIC_GAMEPLAY
    jsr famistudio_music_play
rts

play_song_victory:
    lda MUSIC_VICTORY
    jsr famistudio_music_play
rts

play_sfx_cursor:
    lda SFX_CURSOR
    ldx #FAMISTUDIO_SFX_CH0
    jsr famistudio_sfx_play
rts

play_sfx_select:
    lda SFX_SELECT
    ldx #FAMISTUDIO_SFX_CH1
    jsr famistudio_sfx_play
rts

play_sfx_steps:
    lda SFX_STEPS
    ldx #FAMISTUDIO_SFX_CH2
    jsr famistudio_sfx_play
rts

play_sfx_pick_up:
    lda SFX_PICK_UP
    ldx #FAMISTUDIO_SFX_CH3
    jsr famistudio_sfx_play
rts

play_sfx_put_down:
    lda SFX_PUT_DOWN
    ldx #FAMISTUDIO_SFX_CH0
    jsr famistudio_sfx_play
rts