;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0

InboxCommand:
    LDA INBOXIDX
    STA HANDMEM
RTS

OutboxCommand:
    LDX SOLPTR
    CPX MAXSOLUTIONSIZE
    BEQ :+
        LDA HANDMEM
        STA SOLUTION,x
    :
RTS

CopyFromCommand:
    LDX VAR0
    LDA GAMEMMEM,x
    STA HANDMEM
RTS

CopyToCommand:
    LDX VAR0
    LDA HANDMEM
    STA GAMEMMEM,x
RTS

AddCommand:
    LDA HANDMEM
    LDX VAR0
    CLC
    ADC GAMEMMEM,x
    STA HANDMEM
RTS

SubCommand:
    LDA HANDMEM
    LDX VAR0
    SEC
    SBC GAMEMMEM,x
    STA HANDMEM
RTS

BumpUpCommand:
    LDX VAR0
    INC GAMEMMEM,x
RTS

BumpDownCommand:
    LDX VAR0
    DEC GAMEMMEM,x
RTS

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