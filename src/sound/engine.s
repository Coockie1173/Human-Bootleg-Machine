init_sound:
    lda #1
    ldx #.lobyte(music_data_hmu_play)
    ldy #.hibyte(music_data_hmu_play)
    jsr famistudio_init
rts

play_music:
    lda #0
    jsr famistudio_music_play
rts