.include "background.s"

check_start_button:
  ; Check if SELECT button is pressed
  lda controller_state
  and #%00100000      ; SELECT button mask
  beq @not_pressed
  
  ; Check if it wasn't pressed before (edge detection)
  lda previous_controller
  and #%00100000
  bne @not_pressed    ; If it was already pressed, ignore
  
  ; SELECT was just pressed - transition to game
  jsr transition_to_game
  
@not_pressed:
  rts

transition_to_game:
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
  
  ; Initialize all game sprites
  jsr init_arrow
  jsr init_command_selector
  jsr init_command_list
  jsr init_player
  
  ; Change game state
  lda #STATE_GAME
  sta game_state
  
  rts