;all NMI code goes here
;to do > figure out where how to load the background/nametables
nmi:
  PHP
  PHA
  PHX
  PHY


  ldx #$00 	; Set SPR-RAM address to 0
  stx $2003
@loop:	lda arrow, x 	; Load the sprites into SPR-RAM
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

  ; sprites
  ;for example:
  .byte $00, $00, $00, $00 	; Dummy
  .byte $00, $00, $00, $00

  .byte $20, $21, $11, $C0
  .byte $20, $22, $11, $C8
  .byte $10, $1F, $11, $B8
  .byte $20, $23, $11, $D0
  .byte $20, $23, $11, $D8
  .byte $20, $23, $11, $E0
  .byte $20, $23, $11, $E8
  
  ; pad remaining space
  .res 256 - (* - testsprites), $00

arrow: 
; only scrolls up and down depending on arrow input (ONLY MODIFY Y VALUE)
; up = decrease Y value until max commands pos; down = increase Y value until min commands pos
; Scrolling > if arrow is at top of screen but there are more commands in list, scroll the commands list down
; > same with bottom of screen
  .byte $00, $00, $00, $00 	; Dummy
  .byte $00, $00, $00, $00

  .byte $18, $1F, $00, $B8

  .res 256 - (* - arrow), $00

com_Add:
  .byte $00, $00, $00, $00 	; Dummy
  .byte $00, $00, $00, $00

  ;.byte 

  .res 256 - (* - com_Add), $00
