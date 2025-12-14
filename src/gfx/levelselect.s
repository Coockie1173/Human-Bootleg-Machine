TEXTLEVELSELECT: STRBYTE "LEVEL SELECT"

TEXTLEVEL1: STRBYTE "ITS CORN"
TEXTLEVEL2: STRBYTE "KIIRGHH"
TEXTLEVEL3: STRBYTE "A BIG LUMB WITH KNOTS"
TEXTLEVEL4: STRBYTE "IT HAS THE JUICE"

init_levelselect:
    ;clear out the entire screen  and show a puzzle list
    ; Set PPU address to $2000 (top-left of nametable)
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    
    ; Clear nametable (2048 bytes)
    lda #$00
    ldx #$00
    ldy #$08
    @loop:
        sta $2007
        inx
        bne @loop
        dey
        bne @loop
    lda #STATE_LEVEL_SELECT
    sta game_state

    ;now add the title
    ldx #$00
    lda #$20
    sta VAR0
    lda #$42
    sta VAR1
    @drawtoptext:
        lda TEXTLEVELSELECT, x
        cmp #$FF
        beq :++
        cmp #$01
        beq :+
        sta VAR2
        jsr DrawLetter
        :
        inc VAR1
        inx
    jmp @drawtoptext
    :

    ;now add the level 1
    ldx #$00
    lda #$20
    sta VAR0
    lda #$A6    ; 3 rows down, 4 tiles right
    sta VAR1
    @drawlevel1:
        lda TEXTLEVEL1, x
        cmp #$FF
        beq :++
        cmp #$01
        beq :+
        sta VAR2
        jsr DrawLetter
        :
        inc VAR1
        inx
    jmp @drawlevel1
    :

    ;now add the level 2
    ldx #$00
    lda #$20
    sta VAR0
    lda #$E6    ; 3 rows down, 4 tiles right
    sta VAR1
    @drawlevel2:
        lda TEXTLEVEL2, x
        cmp #$FF
        beq :++
        cmp #$01
        beq :+
        sta VAR2
        jsr DrawLetter
        :
        inc VAR1
        inx
    jmp @drawlevel2
    :

    ;now add the level 3
    ldx #$00
    lda #$21
    sta VAR0
    lda #$26   ; 3 rows down, 4 tiles right
    sta VAR1
    @drawlevel3:
        lda TEXTLEVEL3, x
        cmp #$FF
        beq :++
        cmp #$01
        beq :+
        sta VAR2
        jsr DrawLetter
        :
        inc VAR1
        inx
    jmp @drawlevel3
    :

    ;now add the level 4
    ldx #$00
    lda #$21
    sta VAR0
    lda #$66   ; 3 rows down, 4 tiles right
    sta VAR1
    @drawlevel4:
        lda TEXTLEVEL4, x
        cmp #$FF
        beq :++
        cmp #$01
        beq :+
        sta VAR2
        jsr DrawLetter
        :
        inc VAR1
        inx
    jmp @drawlevel4
    :
rts