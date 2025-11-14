;all NMI code goes here

nmi:
  PHP
  PHA
  PHX
  PHY
  jsr ReadJoy
  ldx #$00 	; Set SPR-RAM address to 0
  stx $2003
@loop:	lda hello, x 	; Load the hello message into SPR-RAM
  sta $2004
  inx
  cpx #$5c
  bne @loop

  LDA #$01
  STA NMIFLAG
  PLY
  PLX
  PLA
  PLP
  rti

hello:
  .byte $00, $00, $00, $00 	; Why do I need these here?
  .byte $00, $00, $00, $00

  .byte $6c, $03, $00, $4e ;h 
  .byte $6c, $04, $00, $58 ;e
  .byte $6c, $05, $00, $62 ;l
  .byte $6c, $05, $00, $6c ;l
  .byte $6c, $01, $00, $76 ;o
  .byte $6c, $00, $00, $8a
  .byte $6c, $01, $00, $94
  .byte $6c, $02, $00, $9e

