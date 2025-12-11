; Update player logic (call from main loop)
update_player:
  lda player_state
  cmp #STATE_IDLE
  beq @handle_idle
  cmp #STATE_WALKING
  beq @handle_walking
  cmp #STATE_STOP
  beq @handle_stop 
  rts

@handle_idle:
  jsr update_idle_state
  rts
  
@handle_walking:
  jsr update_walking_state
  rts

@handle_stop:
  ; Do nothing - player is stopped
  rts

; Update player graphics (call from NMI only)
update_player_gfx:
  jsr draw_player_sprites
  rts

update_idle_state:
  ; Check if interpreter has set a new destination
  lda DEDSTINATIONPLAYERX
  cmp #$FF
  beq @no_command
  
  cmp #$00
  beq @no_command
  
  ; NEW DESTINATION RECEIVED!
  ; Save it as target and clear the destination
  sta player_target_x
  lda DEDSTINATIONPLAYERY
  sta player_target_y
  
  lda #$FF
  sta DEDSTINATIONPLAYERX
  sta DEDSTINATIONPLAYERY
  
  ; Check if we're ALREADY at this position
  lda player_target_x
  cmp player_x
  bne @move_to_destination
  lda player_target_y
  cmp player_y
  bne @move_to_destination
  
  ; Already at destination - just do idle animation/wait
  lda #IDLE_TIME
  sta player_idle_timer
  lda #$00
  sta player_anim_frame
  
  ; Stay in IDLE state, but timer will count down
  rts
  
@move_to_destination:
  ; Need to actually move
  jsr set_facing_direction
  
  lda #STATE_WALKING
  sta player_state
  
  lda #$00
  sta player_anim_frame
  lda #ANIM_SPEED
  sta player_anim_timer
  lda #PLAYER_SPEED
  sta player_move_timer
  
  rts

@no_command:
  ; No command - decrement idle timer if not zero
  lda player_idle_timer
  beq @done
  dec player_idle_timer
@done:
  rts
  

; Handle walking state
update_walking_state:
  ; Update animation
  jsr update_animation
  
  ; Update movement
  dec player_move_timer
  bne @done
  
  ; Reset move timer
  lda #PLAYER_SPEED
  sta player_move_timer
  
  ; Move one pixel toward target
  jsr move_toward_target

@done:
  rts


; Update animation frames
update_animation:
  dec player_anim_timer
  bne @done
  
  ; Reset animation timer
  lda #ANIM_SPEED
  sta player_anim_timer
  
  ; Advance to next frame (0 -> 1 -> 2 -> 3 -> 0)
  inc player_anim_frame
  lda player_anim_frame
  cmp #4
  bcc @done
  
  ; Wrap back to frame 0
  lda #$00
  sta player_anim_frame

@done:
  rts


move_toward_target:
  ; Check if arrived at target X
  lda player_x
  cmp player_target_x
  bne @move_horizontal
  
  ; Check if arrived at target Y
  lda player_y
  cmp player_target_y
  bne @move_vertical
  
  ; *** FULLY ARRIVED ***
  lda #STATE_IDLE
  sta player_state
  lda #IDLE_TIME
  sta player_idle_timer
  lda #$00
  sta player_anim_frame
  
  ; Check what command just finished
  ldx INTERPTR
  dex                      ; Go back to the command we just finished
  lda TestInstructions,x   ; Check which command it was
  
  cmp #CMD_INBOX
  beq @execute_inbox
  cmp #CMD_OUTBOX
  beq @execute_outbox
  cmp #CMD_COPYTO
  beq @execute_tile_modify
  cmp #CMD_ADD
  beq @execute_tile_modify
  cmp #CMD_SUB
  beq @execute_tile_modify
  cmp #CMD_BUMPUP
  beq @execute_tile_modify
  cmp #CMD_BUMPDOWN
  beq @execute_tile_modify
  ; COPYFROM doesn't modify tiles
  jmp @set_facing
  
@execute_inbox:
  jsr InboxLogic
  jmp @set_facing
  
@execute_outbox:
  jsr OutboxLogic
  jmp @set_facing

@execute_tile_modify:
  ; These commands already executed, but we need to update displays
  jsr update_number_displays  ; Mark changed tiles as dirty
  jmp @set_facing
  
@set_facing:
  ; Set facing based on current position
  ; Check if at inbox position
  lda player_x
  cmp #INBOX_X
  bne @face_right_arrival
  lda player_y
  cmp #INBOX_Y
  bne @face_right_arrival
  
  ; At inbox - face left
  lda #$01
  sta player_facing
  rts
  
@face_right_arrival:
  ; At any other location (tiles, outbox) - face right
  lda #$00
  sta player_facing
  rts

@move_horizontal:
  ; Move horizontally toward target
  lda player_x
  cmp player_target_x
  beq @move_vertical
  bcc @move_right
  
  ; Move left
  dec player_x
  rts
  
@move_right:
  ; Move right
  inc player_x
  rts

@move_vertical:
  ; Move vertically toward target
  lda player_y
  cmp player_target_y
  beq @done
  bcc @move_down
  
  ; Move up
  dec player_y
  rts
  
@move_down:
  ; Move down
  inc player_y

@done:
  rts

  
@check_tile0:
  cpx #DEST_TILE0
  bne @check_tile1
  lda #TILE0_X
  sta player_target_x
  lda #TILE0_Y
  sta player_target_y
  rts
  
@check_tile1:
  cpx #DEST_TILE1
  bne @check_tile2
  lda #TILE1_X
  sta player_target_x
  lda #TILE1_Y
  sta player_target_y
  rts
  
@check_tile2:
  cpx #DEST_TILE2
  bne @check_tile3
  lda #TILE2_X
  sta player_target_x
  lda #TILE2_Y
  sta player_target_y
  rts
  
@check_tile3:
  cpx #DEST_TILE3
  bne @check_tile4
  lda #TILE3_X
  sta player_target_x
  lda #TILE3_Y
  sta player_target_y
  rts
  
@check_tile4:
  cpx #DEST_TILE4
  bne @check_tile5
  lda #TILE4_X
  sta player_target_x
  lda #TILE4_Y
  sta player_target_y
  rts
  
@check_tile5:
  cpx #DEST_TILE5
  bne @check_tile6
  lda #TILE5_X
  sta player_target_x
  lda #TILE5_Y
  sta player_target_y
  rts
  
@check_tile6:
  cpx #DEST_TILE6
  bne @check_tile7
  lda #TILE6_X
  sta player_target_x
  lda #TILE6_Y
  sta player_target_y
  rts
  
@check_tile7:
  cpx #DEST_TILE7
  bne @check_outbox
  lda #TILE7_X
  sta player_target_x
  lda #TILE7_Y
  sta player_target_y
  rts
  
@check_outbox:
  lda #OUTBOX_X
  sta player_target_x
  lda #OUTBOX_Y
  sta player_target_y
  rts


; Set facing direction based on target
set_facing_direction:
  ; Compare target X with current X
  lda player_target_x
  cmp player_x
  beq @keep_facing        ; Same X, keep current facing
  bcs @face_right         ; Target > current, moving right
  
  ; Target < current, moving left - need to flip
  lda #$01
  sta player_facing
  rts
  
@face_right:
  ; Moving right - no flip needed
  lda #$00
  sta player_facing
  
@keep_facing:
  rts

