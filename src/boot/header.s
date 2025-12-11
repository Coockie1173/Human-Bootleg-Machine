;don't touch this, this is the NES rom header
.segment "HEADER"
  ; .byte "NES", $1A      ; iNES header identifier
  .byte $4E,$45,$53,$1A,$02,$01,$01,$08
  .byte $00,$00,$07,$00,$01,$00,$00,$01
