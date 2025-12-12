.include "resources/lossScreen.asm"


load_background_loss:
    lda $2002       ; Reset PPU address latch
    lda #$20        ; Nametable 0 address $2000
    sta $2006       ; High byte
    lda #$00
    sta $2006       ; Low byte
  
    ldx #$00
    ldy #$00

loadLLoop:
    lda lossScreen, x
    sta $2007         
    inx
    bne loadLLoop

loadLLoop2:
    lda lossScreen + 256, y
    sta $2007         
    iny
    bne loadLLoop2

    ldx #$00
loadLLoop3:
    lda lossScreen+512, x
    sta $2007         
    inx
    bne loadLLoop3

    ldy #$00
loadLLoop4:
    lda lossScreen+768, y
    sta $2007         
    iny
    bne loadLLoop4

loadAttributesLoss:
    lda $2002       ; read PPU status
    lda #$23
    sta $2006       ; high byte
    lda #$c0
    sta $2006       ; low byte
    ldx #$00        ; start at 0

loadAttLossLoop:
    lda attributesLoss, X
    sta $2007
    inx
    cpx #$40        ; Load all 64 bytes
    bne loadAttLossLoop
    rts

attributesLoss:
;attributes
 .res 64, $AA

