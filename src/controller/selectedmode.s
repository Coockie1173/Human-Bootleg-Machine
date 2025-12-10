;up & down : move command
;left & right : increase/variable

SelectUpDown:

    dec CURSORBLINKTIMER
    bpl :+
        lda #$1F
        sta CURSORBLINKTIMER
    :

    lda controller_state
    and #%10000000 ;A button
    beq :+
    lda previous_controller
    and #%10000000
    bne :+
        lda #$00
        sta CURSORSTATE
        inc arrow_update_flag
        rts
    :

    lda controller_state
    and #%00000100 ;down
    beq @check_up
    lda previous_controller
    and #%00000100
    bne @check_up
    jsr handle_cursor
    lda VAR8
    sta VAR7

    jsr CalculateItemIDX
    CPX VAR7
    beq @end

    lda VARIABLES,x
    PHA
    lda COMMANDS,x
    PHA
    lda COMMANDS-1,x
    TAY
    PLA
    sta COMMANDS-1,x
    TYA
    sta COMMANDS,x
    lda VARIABLES-1,x
    TAY
    PLA
    sta VARIABLES-1,x
    TAY
    sta VARIABLES,x

    lda #$01
    sta update_list
    rts

@check_up:
    lda controller_state
    and #%00001000 ;up
    beq @end
    lda previous_controller
    and #%00001000
    bne @end
    jsr handle_cursor
    lda VAR8
    sta VAR7


    jsr CalculateItemIDX
    CPX VAR7
    beq @end

    lda VARIABLES,x
    PHA
    lda COMMANDS,x
    PHA
    lda COMMANDS+1,x
    TAY
    PLA
    sta COMMANDS+1,x
    TYA
    sta COMMANDS,x
    lda VARIABLES+1,x
    TAY
    PLA
    sta VARIABLES+1,x
    TAY
    sta VARIABLES,x

    lda #$01
    sta update_list

@end:
rts

CalculateItemIDX:
    lda arrow_row
    SEC
    SBC #$03
    clc
    adc scrollIDX
    TAX
    sta VAR8
rts