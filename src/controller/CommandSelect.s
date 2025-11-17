.define INPUT_B BUTTON_B
.define INPUT_RIGHT BUTTON_RIGHT
.define INPUT_LEFT BUTTON_LEFT

HandleInputs: 
    ;when player presses the B button, it adds the CURRCOMMAND to the COMMANDS list
    ;when player presses left or right, the command index changes to next command

    JSR HandleHorizontal
    JSR HandleBPress
RTS

HandleBPress:
    ;only register input when button was pressed and released

    LDA CONADDR        ;load current state
    AND INPUT_B       ;isolate B bit
    BNE :+             ;if currently pressed, skip release code because we want to only detect release
    LDA CONADDRPREV    ;load last frame state
    AND INPUT_B       ;isolate B bit
    BEQ :+             ;if previously NOT pressed, skip release code

    ;release detected
    JSR PushCurrentCommand
    :
RTS

PushCurrentCommand:
    LDA CURRCOMMAND     ;load in current command
    LDY COMMANDCURSOR   ;load in the current free offsett form commands locations in RAM
    STA COMMANDS,Y      ;PUSH the current command to commands location with offset of the cursor
    INY                 ;increment the current index
    STY COMMANDCURSOR   ;set that newest index to the commandcursor
RTS

HandleHorizontal:
    LDA #10 ;amount of commands
    STA VAR0

    LDA CONADDR
    AND INPUT_RIGHT
    BNE :+
    LDA CONADDRPREV
    AND INPUT_RIGHT
    BEQ :+

    ;release detected
    INC CURRCOMMAND

    LDA CURRCOMMAND
    CMP VAR0 ;compare with size
    BNE:+

    ;current command is incremented and exceeds over valid indeces
    ;set it to zero
    LDA #$00
    STA CURRCOMMAND
    :

    LDA CONADDR
    AND INPUT_LEFT
    BNE :+
    LDA CONADDRPREV
    AND INPUT_LEFT
    BEQ :+

    ;release detected
    DEC CURRCOMMAND

    LDA CURRCOMMAND
    CMP #$FF
    BNE:+

    ;current command is decremented and underflows over valid indeces
    ;set it to size -1
    LDA VAR0
    SEC ;set carry to 1
    SBC #1
    STA CURRCOMMAND
    :
RTS