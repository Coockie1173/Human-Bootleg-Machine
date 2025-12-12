StarDrawTextHi = $23
StarDrawTextLo = $21

DrawPuzzleText:
    lda $2002
    lda #StarDrawTextHi ;set cursor
    sta $2006
    lda #StarDrawTextLo
    sta VAR0 ;setup newline counter
    sta $2006

    ldy #$00
    ;pointer is set up and ready, now we can start reading all the characters
    ;$01 signifies a blank space (this maps perfectly in the graphics)
    ;$00 signifies a new line
    ;loop over all characters until we reach a $FF
    @loop:
    lda (PUZZLETEXTPTR),y
    beq @newline
    cmp #$ff
    beq @end

    sta $2007 ;if all else fails, just draw the character

    iny
    jmp @loop
    @newline:
    lda VAR0
    clc
    adc #$20 ;next line is 10 down
    sta VAR0

    lda $2002
    lda #StarDrawTextHi ;set cursor
    sta $2006
    lda VAR0
    sta $2006
    iny
    jmp @loop

    @end:
rts