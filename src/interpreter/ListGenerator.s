ResetCommandList:
    LDX #$00
    LDA #$FF
    @loop:
        STA COMMANDS,x
        INX
        CPX #$FF
    BNE @loop
    RTS

GenerateCommandList:
    lda controller_state
    and #%10000000 ;A button
    beq :+
    lda previous_controller
    and #%10000000
    bne :+
        inc CURSORSTATE
        rts
    :

    lda controller_state
    and #%01000000          ; B
    beq @done               ; If not pressed, exit
    
    ; Check if it was already pressed last frame
    lda previous_controller
    and #%01000000
    bne @done               ; If already pressed, don't repeat
    
    ; Check if we've hit the max number of commands (22 - 3 = 19 rows available)
    lda command_list_count
    cmp #$FF
    bcs @done               ; If at max, don't add more

    TAX
    LDA current_command
    AND #$08
    BNE @JMPCOMM
    LDA current_command
    STA COMMANDS,x
    INX
    STX command_list_count
    INX
    CPX #$00
    BEQ @done
    LDA #$FF    
    STA COMMANDS,x
    ;LDA current_command
    ;TAX
    ;STA COMMANDS,x
    ;STX command_list_count
    ;CLC
    ;ADC #$01
    ;TAX
    ;CPX #$FF
    ;BEQ @done
    ;INX
    ;LDA #CMD_EOL
    ;STA COMMANDS,x
    
    LDA #$01
    STA update_list
    @done:
    rts

@JMPCOMM:
    LDA current_command
    STA COMMANDS,x
    LDA CURRENTJUMPIDX
    STA VARIABLES,x
    INX
    LDA #CMD_LABEL
    STA COMMANDS,x
    LDA CURRENTJUMPIDX
    STA VARIABLES,x
    INC CURRENTJUMPIDX
    INX
    STX command_list_count
    INX

    CPX #$00
    BEQ @done
    LDA #$FF    
    STA COMMANDS,x

    LDA #$01
    STA update_list
    rts