.include "background.s"

check_start_button:
  ; First check if arrow is at START position (row 13, column 10)
  lda MMarrow_row
  cmp #$0D          ; Row 13
  bne @not_pressed  ; If not at row 13, don't allow start
  
  lda MMarrow_column
  cmp #$0A          ; Column 10
  bne @not_pressed  ; If not at column 10, don't allow start
  
  ; Arrow is at START - now check if SELECT button is pressed
  lda controller_state
  and #%00100000    ; SELECT button mask
  beq @not_pressed
  
  ; Check if it wasn't pressed before (edge detection)
  lda previous_controller
  and #%00100000
  bne @not_pressed  ; If it was already pressed, ignore
  
  ; SELECT was just pressed while at START - transition to game
  jsr transition_to_game
  
@not_pressed:
  rts

transition_to_game:
  ; Erase the main menu arrow before transitioning
  jsr erase_MMarrow_sprite
  
  ; Wait for VBlank before changing background
  @wait_vblank:
    bit $2002
    bpl @wait_vblank
  
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