;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0

TileLocationsX:
    .byte TILE0_X, TILE1_X, TILE2_X, TILE3_X
    .byte TILE4_X, TILE5_X, TILE6_X, TILE7_X

TileLocationsY:
    .byte TILE0_Y, TILE1_Y, TILE2_Y, TILE3_Y
    .byte TILE4_Y, TILE5_Y, TILE6_Y, TILE7_Y

SetTileDest:
    lda TileLocationsX,x ;set destination per tile
    sta DEDSTINATIONPLAYERX

    lda TileLocationsY,x ;set destination per tile
    sta DEDSTINATIONPLAYERY
    clc
RTS

InboxCommand:
    LDY #$00
    lda (INBOXPTR),y

    cmp #$FF
    beq ReachedEnd ;FF indicates end of list   
    sta HANDMEM

    lda INBOXPTR
    clc
    adc #$01
    sta INBOXPTR

    lda INBOXPTR + 1 ;handle overflow
    adc #$00
    sta INBOXPTR + 1

    lda INBOX_X
    sta DEDSTINATIONPLAYERX ;set player destination high

    lda INBOX_Y
    sta DEDSTINATIONPLAYERY ;set player destination high
    clc
RTS

ReachedEnd:
    SEC
RTS

OutboxCommand:
    ldx SOLPTR
    CPX MAXSOLUTIONSIZE
    beq :+
        lda HANDMEM
        sta SOLUTION,x
    :

    inx
    stx SOLPTR

    lda OUTBOX_X
    sta DEDSTINATIONPLAYERX ;set player destination high
    
    lda OUTBOX_Y
    sta DEDSTINATIONPLAYERY ;set player destination high
    clc
RTS

CopyFromCommand:
    ldx VAR0
    lda GAMEMMEM,x
    sta HANDMEM

    jmp SetTileDest

CopyToCommand:
    ldx VAR0
    lda HANDMEM
    sta GAMEMMEM,x

    jmp SetTileDest

AddCommand:
    lda HANDMEM
    ldx VAR0
    clc
    adc GAMEMMEM,x
    sta HANDMEM

    jmp SetTileDest

SubCommand:
    lda HANDMEM
    ldx VAR0
    SEC
    SBC GAMEMMEM,x
    sta HANDMEM

    jmp SetTileDest

BumpUpCommand:
    ldx VAR0
    inc GAMEMMEM,x

    jmp SetTileDest

BumpDownCommand:
    ldx VAR0
    DEC GAMEMMEM,x

    jmp SetTileDest

JumpCommand:
    ldx #$00 ;loop through all instructions to find the matching label
    JumpCommLoop:
        lda TestInstructions,x ;load instruction
        cmp #CMD_LABEL ;check if the instr is a label
        beq :++
            cmp #$FF
            bne :+
                SEC ;no attached label found, return prematurely
                RTS
            :
            inx ;not a label, continue
            jmp JumpCommLoop
        :
        lda VAR0 ;load in label ID from the jump
        cmp TestVars,x ;and compare it to the actual label ID
        beq :+
            inx
            bne JumpCommLoop ;not the correct label? go back and try again
    :
    stx INTERPTR ;if we finally find the label in the list, set X and return
    clc
RTS

JumpZeroCommand:
    lda HANDMEM
    bne :+
        jmp JumpCommand
    :
    clc
RTS

JumpNegativeCommand:
    lda HANDMEM
    BMI :+
        jmp JumpCommand
    :
    clc
RTS

LabelCommand:
    clc
RTS