.include "resources/mainMenu.asm"


load_background_menu:
    lda $2002       ; Reset PPU address latch
    lda #$20        ; Nametable 0 address $2000
    sta $2006       ; High byte
    lda #$00
    sta $2006       ; Low byte
  
    ldx #$00
    ldy #$00

loadBGLoop:
    lda mainMenu, x
    sta $2007         
    inx
    bne loadBGLoop

loadBGLoop2:
    lda mainMenu + 256, y
    sta $2007         
    iny
    bne loadBGLoop2

    ldx #$00
loadBGLoop3:
    lda mainMenu+512, x
    sta $2007         
    inx
    bne loadBGLoop3

    ldy #$00
loadBGLoop4:
    lda mainMenu+768, y
    sta $2007         
    iny
    bne loadBGLoop4

loadAttributesMenu:
    lda $2002       ; read PPU status
    lda #$23
    sta $2006       ; high byte
    lda #$c0
    sta $2006       ; low byte
    ldx #$00        ; start at 0

loadAttMenuLoop:
    lda attributesMenu, X
    sta $2007
    inx
    cpx #$40        ; Load all 64 bytes
    bne loadAttMenuLoop
    rts

attributesMenu:
;attributes
 .res 64, $55

