; READ CONTROLLER SUBROUTINE
; Sets controller_state
read_controller:
  lda #$01
  sta $4016
  lda #$00
  sta $4016

  lda #$00
  sta controller_state

  ldx #$08
read_loop:
  lda $4016
  lsr a
  rol controller_state
  dex
  bne read_loop
  rts