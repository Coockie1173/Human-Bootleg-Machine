.include "gfx/input_test.s"
.include "gfx/arrow.s"
.include "gfx/arrow_mainMenu.s"
.include "gfx/command_selector.s"
.include "gfx/command_list.s"
.include "gfx/player.s"
.include "gfx/game_state.s"
.include "gfx/interpreter_bridge.s"

nmi:
  PHP
  PHA
  PHX
  PHY
  ; Save controller state
  lda controller_state
  sta previous_controller
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
  cmp #STATE_LOADING
  beq @loading_mode
  
  ; Game mode - run all game logic
  jsr handle_command_selector_gfx
  jsr handle_arrow_movement
  jsr handle_selected_command
  
  ; NEW: Handle interpreter and player movement together
  jsr game_logic_update
  
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  
  jmp @finish

@menu_mode:
  ; Menu mode - handle main menu arrow and check for start
  jsr handle_MMarrow_movement
  jmp @finish

@loading_mode:
  jsr check_start_button
  jmp @finish

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


  LDA #$01
  STA NMIFLAG
  PLY
  PLX
  PLA
  PLP
  rti

game_logic_update:
  ; Update player first (handles movement)
  jsr update_player_gfx
  
  ; Check if player is idle and ready for next command
  lda player_state
  cmp #STATE_IDLE
  bne @done                  ; Player is still walking, don't execute next command
  
  ; Check if player's idle timer is done (waiting at destination)
  lda player_idle_timer
  bne @done                  ; Still waiting, don't execute next command
  
  ; Player is fully idle - execute next command if available
  jsr execute_next_command
  bcs @interpreter_finished  ; Carry set means interpreter is done
  
  ; Command executed, destination is set, player will start moving next frame
  jmp @done
  
@interpreter_finished:
  ; Interpreter finished all commands
  ; You can add code here to handle completion
  ; For now, just do nothing (could reset, show message, etc.)
  
@done:
  rts