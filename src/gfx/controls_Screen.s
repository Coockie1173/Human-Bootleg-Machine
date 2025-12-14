.include "resources/controls.asm"


load_background_controls:
    lda $2002       ; Reset PPU address latch
    lda #$20        ; Nametable 0 address $2000
    sta $2006       ; High byte
    lda #$00
    sta $2006       ; Low byte
  
    ldx #$00
    ldy #$00

loadCLoop:
    lda controls, x
    sta $2007         
    inx
    bne loadCLoop

loadCLoop2:
    lda controls + 256, y
    sta $2007         
    iny
    bne loadCLoop2

    ldx #$00
loadCLoop3:
    lda controls+512, x
    sta $2007         
    inx
    bne loadCLoop3

    ldy #$00
loadCLoop4:
    lda controls+768, y
    sta $2007         
    iny
    bne loadCLoop4

loadAttributesControls:
    lda $2002       ; read PPU status
    lda #$23
    sta $2006       ; high byte
    lda #$c0
    sta $2006       ; low byte
    ldx #$00        ; start at 0

loadAttControlsLoop:
    lda attributesControls, X
    sta $2007
    inx
    cpx #$40        ; Load all 64 bytes
    bne loadAttControlsLoop
    rts

attributesControls:
;attributes
 .res 64, $00

