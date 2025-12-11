.include "background.s"
.include "level.s"


check_start_button:
  lda Gamemode
  beq @not_pressed
  ; SELECT was just pressed while at staRT - transition to game
  jsr transition_to_game
  
@not_pressed:
  rts

transition_to_game:
  ; Erase the main menu arrow before transitioning
  jsr erase_MMarrow_sprite
  
  ; Wait for VBlank before changing background
  ;@wait_vblank:
  ;  bit $2002
  ;  bpl @wait_vblank
  
  ; Disable rendering for background change
  lda #%00000000
  sta $2001
  lda #%00000000
  sta $2000
  
  ; Clear sprite memory
  lda #$00
  ldx #$00
  @clear_sprites:
    sta $0200, x
    inx
    bne @clear_sprites
  
  ; Load game background
  jsr load_background
  
  ; Initialize interpreter system
  jsr init_interpreter

  ; Initialize level
  jsr InitTestLevel
  
  ; Initialize all game sprites
  jsr init_arrow
  jsr init_command_selector
  jsr init_command_list
  jsr init_player
  
  ; NEW: Initialize number displays
  jsr init_number_displays
  
  ; Change game state
  lda #STATE_GAME
  sta game_state
  
  rts