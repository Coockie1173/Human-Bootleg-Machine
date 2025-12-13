handle_cursor:
    lda controller_state
    and #%00000100
    beq check_up_cursor
    lda previous_controller
    and #%00000100
    bne check_up_cursor

    inc force_update_arg

    lda arrow_row
    cmp #21        ; max row 22
    bcs check_listlength

    jsr CalculateItemIDX
    inc arrow_row
    ;to make sure we don't exceed our list
    inx
    lda COMMANDS,x
    cmp #$FF
    bne :+
        DEC arrow_row
        jsr CalculateItemIDX ;to ensure var8 stays correct
        jmp check_up_cursor
    :

    jsr calc_arrow_address

    check_up_cursor:
    lda controller_state
    and #%00001000
    beq movement_done
    lda previous_controller
    and #%00001000
    bne movement_done

    inc force_update_arg
    jsr CalculateItemIDX

    lda arrow_row
    cmp #$03        ; min row 3
    beq check_listlength_up
    ;beq movement_done

    dec arrow_row
    jsr calc_arrow_address

movement_done:
    RTS

check_listlength:
    jsr FindLastSlot
    TXA
    SEC
    SBC #20
    SEC
    SBC scrollIDX
    BCC :+
        inc scrollIDX
        inc update_list
    :
    jmp check_up_cursor

check_listlength_up:
    lda scrollIDX
    cmp #$00
    beq :+
        DEC scrollIDX
        lda #$01
        sta update_list
    :
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