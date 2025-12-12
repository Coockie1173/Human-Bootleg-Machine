.include "resources/winScreen.asm"


load_background_win:
    lda $2002       ; Reset PPU address latch
    lda #$20        ; Nametable 0 address $2000
    sta $2006       ; High byte
    lda #$00
    sta $2006       ; Low byte
  
    ldx #$00
    ldy #$00

loadWLoop:
    lda winScreen, x
    sta $2007         
    inx
    bne loadWLoop

loadWLoop2:
    lda winScreen + 256, y
    sta $2007         
    iny
    bne loadWLoop2

    ldx #$00
loadWLoop3:
    lda winScreen+512, x
    sta $2007         
    inx
    bne loadWLoop3

    ldy #$00
loadWLoop4:
    lda winScreen+768, y
    sta $2007         
    iny
    bne loadWLoop4

loadAttributesWin:
    lda $2002       ; read PPU status
    lda #$23
    sta $2006       ; high byte
    lda #$c0
    sta $2006       ; low byte
    ldx #$00        ; start at 0

loadAttWinLoop:
    lda attributesWin, X
    sta $2007
    inx
    cpx #$40        ; Load all 64 bytes
    bne loadAttWinLoop
    rts

attributesWin:
;attributes
 .res 64, $55

