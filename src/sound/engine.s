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
    lda sound_enabled
    beq turn_on

turn_off:
    jsr famistudio_music_pause
    lda #$00
    sta sound_enabled
rts

turn_on:
    jsr famistudio_music_pause
    lda #$01
    sta sound_enabled
rts

play_music:
    lda sound_enabled
    beq @end

    jsr famistudio_music_play
@end:
rts

;swapped the songs for better UX
play_song_menu:
    ;lda MUSIC_MENU
    lda MUSIC_GAMEPLAY
    jsr play_music
rts

play_song_gameplay:
    ;lda MUSIC_GAMEPLAY
    lda MUSIC_MENU
    jsr play_music
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

play_sfx_victory:
    lda SFX_VICTORY
    ldx #FAMISTUDIO_SFX_CH2
    jsr famistudio_sfx_play
rts

play_sfx_loose:
    lda SFX_LOOSE
    ldx #FAMISTUDIO_SFX_CH2
    jsr famistudio_sfx_play
rts 