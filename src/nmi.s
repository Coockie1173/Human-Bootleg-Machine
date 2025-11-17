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
  cpx #$5C
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


  arrow:
; only scrolls up and down depending on arrow input (ONLY MODIFY Y VALUE)
; up = decrease Y value until max commands pos; down = increase Y value until min commands pos
; Scrolling > if arrow is at top of screen but there are more commands in list, scroll the commands list down
; > same with bottom of screen
    ;LDA $20
    ;STA YARR
    ;.byte YARR, $1F, $00, $B8

  com_Options:
  ;Position where the commands to choose from are shown, between two arrows, right > next command, left > previous command, select > add command to list

  ;placeholder tile
    ;LDA $15
    ;STA COMMANDOPTIONSY
    .byte COMMANDOPTIONSY, $1A, $00, $C8

  coms: ;commands
  ;depending on where the arrow is, only modify Y value
  ;first command is on top of list, if command is added > increment Y value
  ;top of list = Y > $20
    com_Add:
      .byte $20, $11, $00, $C0
      .byte $20, $12, $00, $C8

    com_Sub:
      .byte $28, $18, $00, $C0
      .byte $28, $19, $00, $C8

    com_Jump:
      JmpCom:
      .byte $38, $21, $00, $C0
      .byte $38, $22, $00, $C8
      .byte $38, $23, $00, $D0
      ;.byte $38, $23, $00, $D8
      ;.byte $38, $23, $00, $E0
      ;.byte $38, $23, $00, $E8
      ;.byte $38, $25, $00, $F0

      JmpEmpty:
      .byte $30, $1A, $00, $C0
      .byte $30, $24, $00, $B8
      ;.byte $30, $23, $00, $D0
      ;.byte $30, $23, $00, $D8
      ;.byte $30, $23, $00, $E0
      ;.byte $30, $23, $00, $E8
      ;.byte $30, $25, $00, $F0





  ; pad remaining space
  .res 256 - (* - testsprites), $00




