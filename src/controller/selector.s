handle_command_selector:
    ; Check LEFT button
    lda controller_state
    and #%00000010
    beq @check_right
    lda previous_controller
    and #%00000010
    bne @check_right
    
    ; Previous command (with wrap)
    lda current_command
    beq @wrap_left
    dec current_command
    jmp @draw_left
@wrap_left:
    lda #CMD_JUMPNEGATIVE       ; Last command
    sta current_command
@draw_left:
    jmp @done

@check_right:
    ; Check RIGHT button
    lda controller_state
    and #%00000001
    beq @end
    lda previous_controller
    and #%00000001
    bne @end
        
    ; Next command (with wrap)
    lda current_command
    cmp #CMD_JUMPNEGATIVE        ; Last command
    beq @wrap_right
    inc current_command
    jmp @draw_right
@wrap_right:
    lda #CMD_INBOX        ; First command
    sta current_command
@draw_right:

@done:
    inc UPDATECOMMFLAG
@end:
  rts