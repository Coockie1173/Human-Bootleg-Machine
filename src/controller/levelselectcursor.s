HandleLVLSelectCursor:
    lda controller_state
    and #%00001000 ;down
    beq @check_up
    lda previous_controller
    and #%00001000
    bne @check_up

    lda SELECTEDPUZZLE
    beq @check_up ;skip if at bottom
    dec SELECTEDPUZZLE
    inc LEVELSELECTCURSOR_UPDATE

    lda LEVELSELECTCURSOR_POSITION
    sta LEVELSELECTCURSOR_POSITION_OLD ;store old position for later
    lda LEVELSELECTCURSOR_POSITION+1
    sta LEVELSELECTCURSOR_POSITION_OLD+1

    lda LEVELSELECTCURSOR_POSITION+1 ;low byte
    sec
    sbc #$60
    sta LEVELSELECTCURSOR_POSITION+1
    lda LEVELSELECTCURSOR_POSITION
    sbc #$00
    sta LEVELSELECTCURSOR_POSITION

    @check_up:
    lda controller_state
    and #%00000100 ;up
    beq @end
    lda previous_controller
    and #%00000100
    bne @end

    lda SELECTEDPUZZLE
    cmp LEVELTOTALCOUNT_SELECTOR
    beq @end

    inc SELECTEDPUZZLE
    inc LEVELSELECTCURSOR_UPDATE

    lda LEVELSELECTCURSOR_POSITION
    sta LEVELSELECTCURSOR_POSITION_OLD ;store old position for later
    lda LEVELSELECTCURSOR_POSITION+1
    sta LEVELSELECTCURSOR_POSITION_OLD+1

    lda LEVELSELECTCURSOR_POSITION+1 ;low byte
    clc
    adc #$60
    sta LEVELSELECTCURSOR_POSITION+1
    lda LEVELSELECTCURSOR_POSITION
    adc #$00
    sta LEVELSELECTCURSOR_POSITION

    @end:

    ; Check if SELECT button is pressed
    lda controller_state
    and #%00100000          ; SELECT button mask
    beq @not_pressed
    
    ; Check if it wasn't pressed before (edge detection)
    lda previous_controller
    and #%00100000
    bne @not_pressed
        jsr menu_select_start
        jsr play_song_gameplay
    @not_pressed:
rts