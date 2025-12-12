init_sound:
    lda #1
    ldx #.lobyte(music_data_song_menu)
    ldy #.hibyte(music_data_song_menu)
    jsr famistudio_init
rts

init_sfx:
    lda #1
    ldx #.lobyte(sounds)
    ldy #.hibyte(sounds)
    jsr famistudio_sfx_init
rts

toggle_music:
    LDA sound_enabled
    BEQ turn_on

turn_off:
    JSR famistudio_music_pause
    LDA #$00
    STA sound_enabled
RTS

turn_on:
    JSR famistudio_music_pause
    LDA #$01
    STA sound_enabled
RTS

;swapped the songs for better UX
play_song_menu:
    ;lda MUSIC_MENU
    lda MUSIC_GAMEPLAY
    jsr famistudio_music_play
rts

play_song_gameplay:
    ;lda MUSIC_GAMEPLAY
    lda MUSIC_MENU
    jsr famistudio_music_play
rts

play_sfx_victory:
    ; pause music
    jsr turn_off
    lda SFX_VICTORY
    jsr famistudio_sfx_play
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