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
.include "gfx/number_system.s"     ; ← CHANGED from number_system.s
.include "gfx/hand_sprites.s"   
.include "gfx/drawpuzzletext.s"   
.include "gfx/levelselect.s"

GameModeList:
.dbyt gamemode_menu_nmi-1, gamemode_loading_nmi-1, gamemode_game_nmi-1
.dbyt gamemode_win_mni-1, gamemode_lose_mni-1, gamemode_controls_mni-1
.dbyt gamemode_levelselect_mni-1, gamemode_loadselect_mni-1

nmi:
  PHP
  PHA
  PHX
  PHY
  jsr ReadJoy

  ; Disable rendering FIRST
  lda #%00000000
  sta $2001

  ; Read controller
  jsr read_controller

   ; Check game state and trampoline to correct code
  lda game_state
  asl
  tax
  lda GameModeList,x
  pha
  lda GameModeList+1,x
  pha
  rts

gamemode_game_nmi:  
  ; Game mode - run all game logic
  jsr Show_Argument
  jsr handle_command_selector_gfx
  jsr handle_arrow_movement
  jsr handle_selected_command
  
  ; Handle interpreter and player movement together
  jsr game_logic_update
  
  ; *** UPDATE SPRITES (replaces draw_pending_numbers and super_simple_inbox_draw) ***
  jsr update_number_sprites       ; ← NEW: Update all number sprites
  
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  
  jmp nmi_finish

gamemode_menu_nmi:
  ; Menu mode - handle main menu arrow and check for start
  jsr handle_MMarrow_movement
  
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  jmp nmi_finish

gamemode_loading_nmi:
  jsr check_start_button
  jsr DrawPuzzleText
  
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  jmp nmi_finish

gamemode_win_mni:
gamemode_lose_mni:
  ; Result screens - only update sprite DMA, input is handled in main loop
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  jmp nmi_finish

nmi_finish:
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
  ; Check if player is idle and ready for next command
  lda player_state
  cmp #STATE_IDLE
  bne @draw_player

  lda player_idle_timer
  beq @ready_for_command
  dec player_idle_timer
  bne @draw_player

@ready_for_command:
  ; Execute next command
  jsr execute_next_command
  bcs @interpreter_finished    ; If carry set, interpreter is done
  
  ; UPDATE state (removed update_number_displays - no longer needed with sprites)
  jsr refresh_inbox_display_slots  ; Just updates RAM
  jmp @draw_player

@interpreter_finished:
  ; Interpreter finished (this gets hit when reaching $FF or inbox empty)
  ; Don't do anything here - let the player state machine handle it
  
@draw_player:
  ; Always update player sprites in NMI
  jsr update_player_gfx
  jsr draw_hand_sprites
  rts


gamemode_controls_mni:
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  jmp nmi_finish

gamemode_loadselect_mni:
  jsr init_levelselect
  
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  jmp nmi_finish

gamemode_levelselect_mni:
  jsr handle_levelselect_nmi
  ; DMA transfer sprites
  lda #$00
  sta $2003
  lda #$02
  sta $4014
  jmp nmi_finish