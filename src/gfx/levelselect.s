TEXTLEVELSELECT: STRBYTE "LEVEL SELECT"

TEXTLEVEL1: STRBYTE "INBOX OUTBOX"
TEXTLEVEL2: STRBYTE "ONLY ZEROS"
TEXTLEVEL3: STRBYTE "SMALLEST"
TEXTLEVEL5: STRBYTE "REPEATER"
TEXTLEVEL4: STRBYTE "SMALLEST NUMBER IN STRING"
TEXTLEVEL6: STRBYTE "THE GREAT EQUALIZER"

TEXTLEVELLIST:
.dbyt TEXTLEVEL1, TEXTLEVEL2, TEXTLEVEL5, $FFFF

init_levelselect:
    ;clear out the entire screen  and show a puzzle list
    ; Set PPU address to $2000 (top-left of nametable)
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    
    ; Clear nametable (2048 bytes)
    lda #$00
    sta LEVELTOTALCOUNT_SELECTOR ;reset counter
    ldx #$00
    ldy #$08
    @loop:
        sta $2007
        inx
        bne @loop
        dey
        bne @loop

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

    ldx #$00
    lda #$20
    sta VAR8
    lda #$A3
    sta VAR9
    @DrawAllTextLoop:
        PHX ;include txa
        asl
        tax
        lda TEXTLEVELLIST,x
        cmp #$FF
        beq @end
            inc LEVELTOTALCOUNT_SELECTOR
            sta VAR4
            lda TEXTLEVELLIST+1,x
            sta VAR3

            lda VAR8
            sta VAR0
            lda VAR9
            sta VAR1
            ldy #$00

            @Loop:
                lda (VAR3),y
                cmp #$FF
                beq @done
                cmp #$01
                beq :+
                sta VAR2
                jsr DrawLetter
                :
                inc VAR1
                iny
            jmp @Loop

        @done:
        PLX
        inx
        lda VAR9
        clc
        adc #$60
        sta VAR9
        lda VAR8
        adc #$00
        sta VAR8
    jmp @DrawAllTextLoop
    @end:
    pla

    lda $2002
    lda #$00

    sta SELECTEDPUZZLE
    lda #$20 ;forcibly move cursor to top item in the list
    sta LEVELSELECTCURSOR_POSITION
    sta LEVELSELECTCURSOR_POSITION_OLD
    sta $2006
    lda #$A2
    sta LEVELSELECTCURSOR_POSITION+1
    sta LEVELSELECTCURSOR_POSITION_OLD+1
    sta $2006

    lda #$6a
    sta $2007

    dec LEVELTOTALCOUNT_SELECTOR

    lda #STATE_LEVEL_SELECT
    sta game_state
rts


handle_levelselect_nmi:
    lda LEVELSELECTCURSOR_UPDATE
    beq @End
        lda $2002

        lda LEVELSELECTCURSOR_POSITION_OLD
        sta $2006
        lda LEVELSELECTCURSOR_POSITION_OLD+1
        sta $2006
        lda #$00
        sta $2007

        lda LEVELSELECTCURSOR_POSITION
        sta $2006
        lda LEVELSELECTCURSOR_POSITION+1
        sta $2006
        lda #$6a
        sta $2007

        lda #$00
        sta LEVELSELECTCURSOR_UPDATE

    @End:
rts