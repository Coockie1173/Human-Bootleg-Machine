;up & down : move command
;left & right : increase/variable

SelectUpDown:
    lda controller_state
    and #%10000000 ;A button
    beq :+
    lda previous_controller
    and #%10000000
    beq :+
        LDA #$00
        STA CURSORSTATE
        rts
    :

    lda controller_state
    and #%00000100 ;down
    beq @check_up
    lda previous_controller
    and #%00000100
    bne @check_up
    jsr handle_cursor
    LDA VAR8
    STA VAR7

    JSR CalculateItemIDX
    CPX VAR7
    BEQ @end

    LDA VARIABLES,x
    PHA
    LDA COMMANDS,x
    PHA
    LDA COMMANDS-1,x
    TAY
    PLA
    STA COMMANDS-1,x
    TYA
    STA COMMANDS,x
    LDA VARIABLES-1,x
    TAY
    PLA
    STA VARIABLES-1,x
    TAY
    STA VARIABLES,x

    LDA #$01
    STA update_list
    rts

@check_up:
    lda controller_state
    and #%00001000 ;up
    beq @end
    lda previous_controller
    and #%00001000
    bne @end
    jsr handle_cursor
    LDA VAR8
    STA VAR7


    JSR CalculateItemIDX
    CPX VAR7
    BEQ @end

    LDA VARIABLES,x
    PHA
    LDA COMMANDS,x
    PHA
    LDA COMMANDS+1,x
    TAY
    PLA
    STA COMMANDS+1,x
    TYA
    STA COMMANDS,x
    LDA VARIABLES+1,x
    TAY
    PLA
    STA VARIABLES+1,x
    TAY
    STA VARIABLES,x

    LDA #$01
    STA update_list

@end:
rts

CalculateItemIDX:
    LDA arrow_row
    SEC
    SBC #$03
    CLC
    ADC scrollIDX
    TAX
    STA VAR8
rts