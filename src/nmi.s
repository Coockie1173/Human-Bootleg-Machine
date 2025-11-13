;all NMI code goes here
;to do > figure out where how to load the background/nametables
nmi:
  PHP
  PHA
  PHX
  PHY
  ldx #$00 	; Set SPR-RAM address to 0
  stx $2003
@loop:	lda testsprites, x 	; Load the sprites into SPR-RAM
  sta $2004
  inx
  cpx #$5c
  bne @loop
  PLY
  PLX
  PLA
  PLP
  rti

testsprites:

  .byte $00, $00, $00, $00 	; Dummy
  .byte $00, $00, $00, $00

  .byte $20, $21, $03, $C0
  .byte $20, $22, $02, $C8
  .byte $10, $1F, $01, $B8
  .byte $20, $23, $13, $D0
  .byte $20, $23, $23, $D8
  .byte $20, $23, $33, $E0
  .byte $20, $23, $03, $E8
  

