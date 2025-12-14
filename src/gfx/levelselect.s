TEXTLEVELSELECT:
    STRBYTE "LEVEL SELECT"

init_levelselect:
    ;clear out the entire screen  and show a puzzle list
    ; Set PPU address to $2000 (top-left of nametable)
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    
    ; Clear nametable (2048 bytes)
    lda #$02
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

    ;now add the text
    ldx #$00
    lda #$20
    sta VAR0
    lda #$42-
    sta VAR1
    @drawtoptext:
        lda TEXTLEVELSELECT, x
        cmp #$FF
        beq @done
        cmp #$01
        beq @NoDraw
        sta VAR2
        jsr DrawLetter
        @NoDraw:
        inc VAR1
        inx
    jmp @drawtoptext
    @done:
rts