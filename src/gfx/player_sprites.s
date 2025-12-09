
init_player:
  ; Start at inbox position
  lda #INBOX_X
  sta player_x
  lda #INBOX_Y
  sta player_y
  
  ; Set initial state to IDLE
  lda #STATE_IDLE
  sta player_state
  
  ; Start at inbox (destination 0)
  lda #DEST_INBOX
  sta player_destination
  
  ; Initialize animation
  lda #$00
  sta player_anim_frame
  lda #ANIM_SPEED
  sta player_anim_timer
  
  ; Initialize movement
  lda #PLAYER_SPEED
  sta player_move_timer
  lda #IDLE_TIME
  sta player_idle_timer
  
  

  ; Start facing left at inbox
  lda #$01
  sta player_facing
  
  ; Clear destination markers (so interpreter can set them)
  lda #$FF
  sta DEDSTINATIONPLAYERX
  sta DEDSTINATIONPLAYERY
  
  ; Set target to first destination (tile 0) - for testing
  lda #TILE0_X
  sta player_target_x
  lda #TILE0_Y
  sta player_target_y
  
  rts

; Update player
;update_player_gfx:
  ;jsr draw_player_sprites
  ;rts

; Draw player sprites to OAM buffer
draw_player_sprites:
  ; Select tiles based on animation frame
  lda player_anim_frame
  cmp #$00
  beq @use_idle
  cmp #$01
  beq @use_walk1
  cmp #$02
  beq @use_idle
  ; Frame 3 uses walk2
  jmp @use_walk2

@use_idle:
  lda #TILE_PLAYER_IDLE_1
  sta $50
  lda #TILE_PLAYER_IDLE_2
  sta $51
  lda #TILE_PLAYER_IDLE_3
  sta $52
  lda #TILE_PLAYER_IDLE_4
  sta $53
  jmp @setup_attributes

@use_walk1:
  lda #TILE_PLAYER_WALK1_1
  sta $50
  lda #TILE_PLAYER_WALK1_2
  sta $51
  lda #TILE_PLAYER_WALK1_3
  sta $52
  lda #TILE_PLAYER_WALK1_4
  sta $53
  jmp @setup_attributes

@use_walk2:
  lda #TILE_PLAYER_WALK2_1
  sta $50
  lda #TILE_PLAYER_WALK2_2
  sta $51
  lda #TILE_PLAYER_WALK2_3
  sta $52
  lda #TILE_PLAYER_WALK2_4
  sta $53

@setup_attributes:
  ; Set attribute byte (with or without horizontal flip)
  lda player_facing
  beq @no_flip
  
  ; Facing left - set horizontal flip bit
  lda #%01000000
  sta $54
  jmp @draw_sprites
  
@no_flip:
  ; Facing right - no flip
  lda #%00000000
  sta $54

@draw_sprites:
  ; Check if we need to swap tiles for flipping
  lda player_facing
  bne @draw_flipped
  
  ; Not flipped - draw normally
  ; Sprite 0: Top-left
  lda player_y
  sta $0200
  lda $50              ; Top-left tile
  sta $0201
  lda $54              ; Attributes
  sta $0202
  lda player_x
  sta $0203
  
  ; Sprite 1: Top-right
  lda player_y
  sta $0204
  lda $51              ; Top-right tile
  sta $0205
  lda $54
  sta $0206
  lda player_x
  clc
  adc #8
  sta $0207
  
  ; Sprite 2: Bottom-left
  lda player_y
  clc
  adc #8
  sta $0208
  lda $52              ; Bottom-left tile
  sta $0209
  lda $54
  sta $020A
  lda player_x
  sta $020B
  
  ; Sprite 3: Bottom-right
  lda player_y
  clc
  adc #8
  sta $020C
  lda $53              ; Bottom-right tile
  sta $020D
  lda $54
  sta $020E
  lda player_x
  clc
  adc #8
  sta $020F
  rts

@draw_flipped:
  ; Flipped - swap left and right tiles
  ; Sprite 0: Top-RIGHT tile at LEFT position
  lda player_y
  sta $0200
  lda $51              ; Use right tile
  sta $0201
  lda $54              ; Flip attribute
  sta $0202
  lda player_x
  sta $0203
  
  ; Sprite 1: Top-LEFT tile at RIGHT position
  lda player_y
  sta $0204
  lda $50              ; Use left tile
  sta $0205
  lda $54
  sta $0206
  lda player_x
  clc
  adc #8
  sta $0207
  
  ; Sprite 2: Bottom-RIGHT tile at LEFT position
  lda player_y
  clc
  adc #8
  sta $0208
  lda $53              ; Use right tile
  sta $0209
  lda $54
  sta $020A
  lda player_x
  sta $020B
  
  ; Sprite 3: Bottom-LEFT tile at RIGHT position
  lda player_y
  clc
  adc #8
  sta $020C
  lda $52              ; Use left tile
  sta $020D
  lda $54
  sta $020E
  lda player_x
  clc
  adc #8
  sta $020F
  rts