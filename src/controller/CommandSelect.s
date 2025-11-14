HandleHorizontal:
    ;when player presses the B button, it adds the CURRCOMMAND to the COMMANDS list
    ;when player presses left or right, the command index changes to next command
    
    ;Read the inputs first
    JSR ReadJoy

    JSR HandleBPress
RTS

HandleBPress:
    ;only register input when button was pressed and released

    LDA CONADDR        ;load current state
    AND BUTTON_B       ;isolate B bit
    BNE :+             ;if currently pressed, skip release code because we want to only detect release
    LDA CONADDRPREV    ;load last frame state
    AND BUTTON_B       ;isolate B bit
    BEQ :+             ;if previously NOT pressed, skip release code

    ;release detected
    JSR PushCurrentCommand
    :
RTS

PushCurrentCommand:
    LDA JUMP
    STA CURRCOMMAND

    LDA CURRCOMMAND     ;load in current command
    LDY COMMANDCURSOR   ;load in the current free offsett form commands locations in RAM
    STA COMMANDS,Y      ;PUSH the current command to commands location with offset of the cursor
    INY                 ;increment the current index
    STY COMMANDCURSOR   ;set that newest index to the commandcursor
RTS