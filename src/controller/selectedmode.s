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
    TYA
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

    jsr SwapData_right

    lda #$01
    sta update_list

@end:
rts

SelectLeftRight:
    jsr CalculateItemIDX
    stx VAR3
    lda COMMANDS,x
    sta VAR5

    jsr DoesCommandHaveArgs
    bcs ChangeArg
rts

ChangeArg:
    lda controller_state
    and #%00000001 ;right
    beq @check_left
    lda previous_controller
    and #%00000001
    bne @check_left

    ldx VAR3
    lda VARIABLES,x
    clc
    adc #$01
    cmp #$08
    bne :+
        lda #$00
    :

    sta VARIABLES,x
    inc force_update_arg
    rts

@check_left:
    lda controller_state
    and #%00000010 ;left
    beq @end
    lda previous_controller
    and #%00000010
    bne @end

    ldx VAR3
    lda VARIABLES,x
    sec
    sbc #$01
    cmp #$FF
    bne :+
        lda #$07
    :

    sta VARIABLES,x
    inc force_update_arg
@end:
rts

SwapData_right:
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
    TYA
    sta VARIABLES,x
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

RemoveCommand:

    lda controller_state
    and #%01000000 ;B button
    beq :+
    lda previous_controller
    and #%01000000
    bne :+
        jmp @ActuallyRemove
    :
    rts
@ActuallyRemove:

    ;basically just "shift" the selected command out of the list.
    ;so from our selected index all the way to the end of list (+1) we shift our data
    jsr CalculateItemIDX ;grab our index of the command, we'll be (ab)using this to do all the shifting


    lda COMMANDS,x
    cmp #$FF
    beq @end

    ;so to re-iterate: in the loop we do the following.
    ;we swap with the next command, then check if commands-1,x == 0xFF
    ;if it is 0xFF, we've successfully remove the command out of the list, else just keep swapping until it's out of here
    ;this also ensures the list order stays consistent
    @loop:
    jsr SwapData_right
    inx
    lda COMMANDS-1,x
    cmp #$FF
    beq @loopend
    jmp @loop

@loopend:
    dec command_list_count
    inc update_list
@end:
rts