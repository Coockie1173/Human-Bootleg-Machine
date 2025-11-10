;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0

TileLocationsHi:
    .byte TILE0LOCHI, TILE1LOCHI, TILE2LOCHI, TILE3LOCHI
    .byte TILE4LOCHI, TILE5LOCHI, TILE6LOCHI, TILE7LOCHI

TileLocationsLo:
    .byte TILE0LOCLO, TILE1LOCLO, TILE2LOCLO, TILE3LOCLO
    .byte TILE4LOCLO, TILE5LOCLO, TILE6LOCLO, TILE7LOCLO

SetTileDest:
    LDA TileLocationsHi,x ;set destination per§ tile
    STA DEDSTINATIONPLAYERX
    LDA TileLocationsLo,x
    STA DEDSTINATIONPLAYERX + 1 ;set player destination low
RTS

InboxCommand:
    LDA INBOXIDX
    STA HANDMEM

    LDA INBOXLOCHI
    STA DEDSTINATIONPLAYERX ;set player destination high
    LDA INBOXLOCLO
    STA DEDSTINATIONPLAYERX + 1 ;set player destination low
RTS

OutboxCommand:
    LDX SOLPTR
    CPX MAXSOLUTIONSIZE
    BEQ :+
        LDA HANDMEM
        STA SOLUTION,x
    :

    LDA OUTBOXLOCHI
    STA DEDSTINATIONPLAYERX ;set player destination high
    LDA OUTBOXLOCLO
    STA DEDSTINATIONPLAYERX + 1 ;set player destination low
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
    STA INTERPTR
RTS

JumpZeroCommand:
    LDA HANDMEM
    BNE :+
        JMP JumpCommand
    :
RTS

JumpNegativeCommand:
    LDA HANDMEM
    BMI :+
        JMP JumpCommand
    :
RTS