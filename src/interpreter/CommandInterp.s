;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0

TileLocationsHiX:
    .byte TILE0LOCHIX, TILE1LOCHIX, TILE2LOCHIX, TILE3LOCHIX
    .byte TILE4LOCHIX, TILE5LOCHIX, TILE6LOCHIX, TILE7LOCHIX

TileLocationsLoX:
    .byte TILE0LOCLOX, TILE1LOCLOX, TILE2LOCLOX, TILE3LOCLOX
    .byte TILE4LOCLOX, TILE5LOCLOX, TILE6LOCLOX, TILE7LOCLOX

TileLocationsHiY:
    .byte TILE0LOCHIY, TILE1LOCHIY, TILE2LOCHIY, TILE3LOCHIY
    .byte TILE4LOCHIY, TILE5LOCHIY, TILE6LOCHIY, TILE7LOCHIY

TileLocationsLoY:
    .byte TILE0LOCLOY, TILE1LOCLOY, TILE2LOCLOY, TILE3LOCLOY
    .byte TILE4LOCLOY, TILE5LOCLOY, TILE6LOCLOY, TILE7LOCLOY

SetTileDest:
    LDA TileLocationsHiX,x ;set destination per tile
    STA DEDSTINATIONPLAYERX
    LDA TileLocationsLoX,x
    STA DEDSTINATIONPLAYERX + 1 ;set player destination low

    LDA TileLocationsHiY,x ;set destination per tile
    STA DEDSTINATIONPLAYERY
    LDA TileLocationsLoY,x
    STA DEDSTINATIONPLAYERY + 1 ;set player destination low
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

    LDA INBOXLOCHIX
    STA DEDSTINATIONPLAYERX ;set player destination high
    LDA INBOXLOCLOX
    STA DEDSTINATIONPLAYERX + 1 ;set player destination low

    LDA INBOXLOCHIY
    STA DEDSTINATIONPLAYERY ;set player destination high
    LDA INBOXLOCLOY
    STA DEDSTINATIONPLAYERY + 1 ;set player destination low
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

    LDA OUTBOXLOCHIX
    STA DEDSTINATIONPLAYERX ;set player destination high
    LDA OUTBOXLOCLOX
    STA DEDSTINATIONPLAYERX + 1 ;set player destination low    
    
    LDA OUTBOXLOCHIY
    STA DEDSTINATIONPLAYERY ;set player destination high
    LDA OUTBOXLOCLOY
    STA DEDSTINATIONPLAYERY + 1 ;set player destination low
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
    LDA VAR0
    LDX #$00
    JumpCommLoop:
        PHA
        LDA TestInstructions,x
        CMP #LABEL
        BEQ :+
            INX
            JMP JumpCommLoop
        :
        PLA
        CMP TestVars,x
        BEQ :+
            INX
            BNE JumpCommLoop
    :
    STX INTERPTR
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