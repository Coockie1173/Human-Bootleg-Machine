.include "gfx/input_test.s"
.include "gfx/arrow.s"
.include "gfx/command_selector.s"
.include "gfx/command_list.s"
.include "gfx/player.s"
.include "gfx/game_state.s"

nmi:
  PHP
  PHA
  PHX
  PHY
  jsr ReadJoy

  ; Disable rendering
  lda #%00000000
  sta $2001

  ; Read controller
  jsr read_controller

  ; Check game state and handle accordingly
  lda game_state
  cmp #STATE_MENU
  beq @menu_mode
  
  ; Game mode - run all game logic
  jsr handle_command_selector
  jsr handle_arrow_movement
  jsr handle_selected_command
  jsr update_player
  
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  
  jmp @finish

@menu_mode:
  ; Menu mode - only check for start
  jsr check_start_button

@finish:
  ; Reset scroll
  lda $2002
  lda #$00
  sta $2005
  sta $2005

  ; Re-enable rendering
  lda #%10000000
  sta $2000
  lda #%00011110
  sta $2001

  ; Save controller state
  lda controller_state
  sta previous_controller

  LDA #$01
  STA NMIFLAG
  PLY
  PLX
  PLA
  PLP
  rti