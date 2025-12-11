CheckStartInterpreter:
    lda controller_state
    and #%00100000    ; SELECT button mask
    beq @not_pressed
    
    ; Check if it wasn't pressed before (edge detection)
    lda previous_controller
    and #%00100000
    bne @not_pressed  ; If it was already pressed, ignore

    inc START_INTERPRETER

    @not_pressed:
rts