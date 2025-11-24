.include "gfx/input_test.s"
.include "gfx/arrow.s"
.include "gfx/command_selector.s"
.include "gfx/command_list.s"

nmi:
  PHP
  PHA
  PHX
  PHY

  ; Disable rendering
  lda #%00000000
  sta $2001

  ; Read controller
  jsr read_controller

  ; Handle command selector (LEFT/RIGHT)
  jsr handle_command_selector

  ; Handle arrow movement (UP/DOWN)
  jsr handle_arrow_movement

  ; Reset scroll
  lda $2002
  lda #$00
  sta $2005
  lda #$00
  sta $2005

  ; Re-enable rendering
  lda #%10000000
  sta $2000
  lda #%00011110
  sta $2001

  ; Save controller state
  lda controller_state
  sta previous_controller

  PLY
  PLX
  PLA
  PLP
  rti