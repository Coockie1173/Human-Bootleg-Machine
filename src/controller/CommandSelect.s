HandleHorizontal:
    ;when player presses the B button, it adds the CURRCOMMAND to the COMMANDS list
    
    ;Detect the B button being pressed
    jsr ReadJoy

    LDA CONADDR
    AND BUTTON_A
    BNE :+
    LDA CONADDRPREV
    AND BUTTON_A
    BEQ :+
    :