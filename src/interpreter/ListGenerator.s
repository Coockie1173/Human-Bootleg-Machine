ResetCommandList:
    ldx #$00
    lda #$FF
    @loop:
        sta COMMANDS,x
        inx
        CPX #$FF
    bne @loop
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
    
    ;find the first free slot - less prone to errors

    jsr FindLastSlot
    bcc @done

    ; Check if we've hit the max number of commands (22 - 3 = 19 rows available)
    ;lda command_list_count
    ;cmp #$FF
    ;bcs @done               ; If at max, don't add more

    ;TAX
    lda current_command
    and #$08
    bne @JMPCOMM
    lda current_command
    sta COMMANDS,x
    lda #$00
    sta VARIABLES,x
    inx
    stx command_list_count
    inx
    CPX #$00
    beq @done
    lda #$FF    
    sta COMMANDS,x
    ;lda current_command
    ;TAX
    ;sta COMMANDS,x
    ;stx command_list_count
    ;clc
    ;adc #$01
    ;TAX
    ;CPX #$FF
    ;beq @done
    ;inx
    ;lda #CMD_EOL
    ;sta COMMANDS,x
    
    lda #$01
    sta update_list
    @done:
    rts

@JMPCOMM:
    lda current_command
    sta COMMANDS,x
    lda CURRENTJUMPIDX
    sta VARIABLES,x
    inx
    lda #CMD_LABEL
    sta COMMANDS,x
    lda CURRENTJUMPIDX
    sta VARIABLES,x
    inc CURRENTJUMPIDX
    inx
    stx command_list_count
    inx

    CPX #$00
    beq @done
    lda #$FF    
    sta COMMANDS,x

    lda #$01
    sta update_list
    rts


FindLastSlot:
    ldx #$00
    @loop:
    lda COMMANDS,X
    cmp #$FF
    beq @slotfound
    inx
    cpx #$FF
    beq @done ;no slot found
    jmp @loop
    @slotfound:
    sec
    rts
    @done:
    clc
    rts