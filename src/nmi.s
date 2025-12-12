.include "gfx/font.s"
.include "gfx/input_test.s"
.include "gfx/arrow.s"
.include "gfx/arrow_mainMenu.s"
.include "gfx/command_selector.s"
.include "gfx/command_list.s"
.include "gfx/player_sprites.s"
.include "gfx/game_state.s"
.include "gfx/interpreter_bridge.s"
.include "gfx/argument.s"
.include "gfx/number_system.s"   
.include "gfx/hand_sprites.s"   
.include "gfx/drawpuzzletext.s"   


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
  cmp #STATE_LOADING
  beq @loading_mode
  
  ; Game mode - run all game logic
  jsr Show_Argument
  jsr handle_command_selector_gfx
  jsr handle_arrow_movement
  jsr handle_selected_command
  
  ; NEW: Draw any pending numbers BEFORE re-enabling rendering
  jsr draw_pending_numbers
  
  ; Handle interpreter and player movement together
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
  jsr DrawPuzzleText
  jmp @finish

@finish:
  ; Reset scroll BEFORE re-enabling rendering
  bit $2002           ; Reset PPU address latch
  lda #$00
  sta $2005           ; X scroll = 0
  sta $2005           ; Y scroll = 0

  ; Re-enable rendering with safe defaults
  lda #%10000000      ; NMI enabled, use pattern table 0 for background
  sta $2000
  
  lda #%00011110      ; Show sprites and background, no clipping
  sta $2001


  lda #$01
  sta NMIFLAG
  PLY
  PLX
  PLA
  PLP
  rti

game_logic_update:
  ; Update player movement physics FIRST
  ; jsr update_player      ; <-- you left this commented out in your code

  ; Check if player is idle and ready for next command
  lda player_state
  cmp #STATE_IDLE
  bne @draw_player                  ; Player is still walking, just draw

  ; If idle, count the idle timer down here so NMI can progress it
  lda player_idle_timer
  beq @ready_for_command           ; zero -> ready to run next command

  dec player_idle_timer            ; still waiting -> decrement
  bne @draw_player                 ; still non-zero -> skip interpreter this frame

  ; If we fall through here, timer reached 0 this frame -> ready
@ready_for_command:
  jsr execute_next_command
  bcs @interpreter_finished        ; Carry set = finished
  jsr update_number_displays
  jsr super_simple_inbox_draw
  ;jsr draw_inbox_all
  jsr refresh_inbox_display_slots
  jmp @draw_player

@interpreter_finished:
  ; Interpreter finished all commands

@draw_player:
  ; Always draw player sprites in NMI
  jsr update_player_gfx
  jsr draw_hand_sprites
  rts

