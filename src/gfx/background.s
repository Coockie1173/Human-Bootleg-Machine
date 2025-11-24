; background.s
; Background loading routine

.include "resources/canvas.asm"

load_background:
    lda $2002       ; Reset PPU address latch
    lda #$20        ; Nametable 0 address $2000
    sta $2006       ; High byte
    lda #$00
    sta $2006       ; Low byte
  
    ldx #$00
    ldy #$00

loadBackgroundLoop:
    lda canvas, x
    sta $2007         
    inx
    bne loadBackgroundLoop       ; Loop 256 times (first page)
    
; Second loop:
loadBackgroundLoop2:
    lda canvas+256, y
    sta $2007
    iny
    bne loadBackgroundLoop2

 ; Third loop 
    ldx #$00
loadBackgroundLoop3:
    lda canvas+512, x
    sta $2007
    inx
    bne loadBackgroundLoop3

; Fourth loop 
	ldy #$00
loadBackgroundLoop4:
	lda canvas+768, y
	sta $2007
	iny
	bne loadBackgroundLoop4


loadAttributes:
    lda $2002       ; read PPU status
    lda #$23
    sta $2006       ; high byte
    lda #$c0
    sta $2006       ; low byte
    ldx #$00        ; start at 0

loadAttributesLoop:
    lda attributes, X
    sta $2007
    inx
    cpx #$40        ; Load all 64 bytes
    bne loadAttributesLoop

    rts


attributes:
;attributes
 .res 64, $55