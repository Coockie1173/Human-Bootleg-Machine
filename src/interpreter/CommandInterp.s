;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0

TileLocationsX:
    .byte TILE0_X, TILE1_X, TILE2_X, TILE3_X
    .byte TILE4_X, TILE5_X, TILE6_X, TILE7_X

TileLocationsY:
    .byte TILE0_Y, TILE1_Y, TILE2_Y, TILE3_Y
    .byte TILE4_Y, TILE5_Y, TILE6_Y, TILE7_Y

SetTileDest:
    LDA TileLocationsX,x ;set destination per tile
    STA DEDSTINATIONPLAYERX

    LDA TileLocationsY,x ;set destination per tile
    STA DEDSTINATIONPLAYERY
    CLC
RTS

InboxCommand:
    LDY #$00
    LDA (INBOXPTR),y

    CMP #$FF
    BEQ ReachedEnd ;FF indicates end of list   
    STA HANDMEM

    LDA INBOXPTR
    CLC
    ADC #$01
    STA INBOXPTR

    LDA INBOXPTR + 1 ;handle overflow
    ADC #$00
    STA INBOXPTR + 1

    LDA INBOX_X
    STA DEDSTINATIONPLAYERX ;set player destination high

    LDA INBOX_Y
    STA DEDSTINATIONPLAYERY ;set player destination high
    CLC
RTS

ReachedEnd:
    SEC
RTS

OutboxCommand:
    LDX SOLPTR
    CPX MAXSOLUTIONSIZE
    BEQ :+
        LDA HANDMEM
        STA SOLUTION,x
    :

    INX
    STX SOLPTR

    LDA OUTBOX_X
    STA DEDSTINATIONPLAYERX ;set player destination high
    
    LDA OUTBOX_Y
    STA DEDSTINATIONPLAYERY ;set player destination high
    CLC
RTS

CopyFromCommand:
    LDX VAR0
    LDA GAMEMMEM,x
    STA HANDMEM

    JMP SetTileDest

CopyToCommand:
    LDX VAR0
    LDA HANDMEM
    STA GAMEMMEM,x

    JMP SetTileDest

AddCommand:
    LDA HANDMEM
    LDX VAR0
    CLC
    ADC GAMEMMEM,x
    STA HANDMEM

    JMP SetTileDest

SubCommand:
    LDA HANDMEM
    LDX VAR0
    SEC
    SBC GAMEMMEM,x
    STA HANDMEM

    JMP SetTileDest

BumpUpCommand:
    LDX VAR0
    INC GAMEMMEM,x

    JMP SetTileDest

BumpDownCommand:
    LDX VAR0
    DEC GAMEMMEM,x

    JMP SetTileDest

JumpCommand:
    LDX #$00 ;loop through all instructions to find the matching label
    JumpCommLoop:
        LDA TestInstructions,x ;load instruction
        CMP #CMD_LABEL ;check if the instr is a label
        BEQ :++
            CMP #$FF
            BNE :+
                SEC ;no attached label found, return prematurely
                RTS
            :
            INX ;not a label, continue
            JMP JumpCommLoop
        :
        LDA VAR0 ;load in label ID from the jump
        CMP TestVars,x ;and compare it to the actual label ID
        BEQ :+
            INX
            BNE JumpCommLoop ;not the correct label? go back and try again
    :
    STX INTERPTR ;if we finally find the label in the list, set X and return
    CLC
RTS

JumpZeroCommand:
    LDA HANDMEM
    BNE :+
        JMP JumpCommand
    :
    CLC
RTS

JumpNegativeCommand:
    LDA HANDMEM
    BMI :+
        JMP JumpCommand
    :
    CLC
RTS

LabelCommand:
    CLC
RTS