.include "gfx/input_test.s"
.include "gfx/arrow.s"
.include "gfx/command_selector.s"
.include "gfx/command_list.s"
.include "gfx/player.s"

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

  ; Handle command list (SELECT)
  jsr handle_selected_command

  ; Player movement
  jsr update_player

  ; Reset scroll
  lda $2002
  lda #$00
  sta $2005
  lda #$00
  sta $2005

  ; DMA transfer sprites to PPU
  lda #$00
  sta $2003           ; Set OAM address to 0
  lda #$02
  sta $4014           ; Start DMA transfer from $0200

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