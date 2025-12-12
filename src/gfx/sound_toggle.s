; MENU OPTION: SOUND TOGGLE
menu_select_sound:
    ; Play selection sound (before toggling!)
    jsr play_sfx_select
    
    ; Toggle sound state (assuming you have a sound_enabled flag)
    lda sound_enabled
    eor #$01                ; Flip bit 0 (0->1 or 1->0)
    sta sound_enabled
    
    ; Update the display tiles
    jsr update_sound_display
    
    ; If sound was turned off, stop music
    lda sound_enabled
    bne @sound_on
    
    ; Sound is now OFF
    jsr famistudio_music_stop
    rts
    
@sound_on:
    ; Sound is now ON - restart menu music
    jsr play_song_menu
    rts

; UPDATE SOUND DISPLAY ON SCREEN
update_sound_display:
    ; Wait for VBlank
    lda $2002
    
    ; Set PPU address to sound tile location (SOUND_LOCHI:SOUND_1_LOCLO)
    lda #SOUND_LOCHI
    sta $2006
    lda #SOUND_1_LOCLO
    sta $2006
    
    ; Check sound state and write appropriate tiles
    lda sound_enabled
    beq @write_off
    
@write_on:
    lda #SOUND_ON_1
    sta $2007               ; Write first tile
    lda #SOUND_ON_2
    sta $2007               ; Write second tile
    rts
    
@write_off:
    lda #SOUND_OFF_1
    sta $2007               ; Write first tile
    lda #SOUND_OFF_2
    sta $2007               ; Write second tile
    rts