handle_cursor:
    lda controller_state
    and #%00000100
    beq check_up
    lda previous_controller
    and #%00000100
    bne check_up

    lda arrow_row
    cmp #$FF        ; max row 22
    bcs check_up

    inc arrow_row
    jsr calc_arrow_address

    check_up:
    lda controller_state
    and #%00001000
    beq movement_done
    lda previous_controller
    and #%00001000
    bne movement_done

    lda arrow_row
    cmp #$03        ; min row 3
    bcc movement_done
    beq movement_done

    dec arrow_row
    jsr calc_arrow_address

movement_done:
    RTS


; CALCULATE 16-BIT PPU ADDRESS
calc_arrow_address:
    lda arrow_position_hi
    sta arrow_position_hi_old
    lda arrow_position
    sta arrow_position_old
    lda #$01
    sta arrow_update_flag
    lda #$20
    sta arrow_position_hi
    lda #$00
    sta arrow_position
    
    ldx arrow_row
    beq add_column_ptr
    
    :
    lda arrow_position
    clc
    adc #32
    sta arrow_position
    lda arrow_position_hi
    adc #$00
    sta arrow_position_hi
    dex
    bne :-
    
    add_column_ptr:
    lda arrow_position
    clc
    adc arrow_column
    sta arrow_position
    lda arrow_position_hi
    adc #$00
    sta arrow_position_hi
    rts