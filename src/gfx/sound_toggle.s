; MENU OPTION: SOUND TOGGLE
menu_select_sound:
    ; Play selection sound (before toggling!)
    jsr play_sfx_select
    
    ; Toggle sound state (assuming you have a sound_enabled flag) and stop or resume music
    jsr toggle_music
    
    ; Update the display tiles
    jsr update_sound_display
    
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