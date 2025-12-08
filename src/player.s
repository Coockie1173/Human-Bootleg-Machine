update_player:
  lda player_state
  cmp #STATE_IDLE
  beq @handle_idle
  cmp #STATE_WALKING
  beq @handle_walking
  rts

@handle_idle:
  jsr update_idle_state
  jmp @draw
  
@handle_walking:
  jsr update_walking_state
  
@draw:
rts

; Handle idle state 
update_idle_state:
  ; Check if interpreter has set a new destination
  lda DEDSTINATIONPLAYERX
  cmp #$FF                   ; Check if destination is set (use $FF as "no destination")
  beq @normal_idle           ; If no destination set, continue normal idle behavior
  
; New destination from interpreter! Set it as target
  sta player_target_x
  lda DEDSTINATIONPLAYERY
  sta player_target_y
  
  ; Clear the destination so we don't re-read it
  lda #$FF
  sta DEDSTINATIONPLAYERX
  sta DEDSTINATIONPLAYERY
  
  ; Determine facing direction
  jsr set_facing_direction
  
  ; Switch to walking state
  lda #STATE_WALKING
  sta player_state
  
  ; Reset animation
  lda #$00
  sta player_anim_frame
  lda #ANIM_SPEED
  sta player_anim_timer
  
  ; Reset movement timer
  lda #PLAYER_SPEED
  sta player_move_timer
  
  rts

@normal_idle:
  ; Original idle behavior (your test loop)
  ; Set facing based on current destination
  lda player_destination
  cmp #DEST_INBOX
  bne @face_right_idle
  
  ; At inbox - face left
  lda #$01
  sta player_facing
  jmp @check_timer

  
@face_right_idle:
  ; At any other location - face right
  lda #$00
  sta player_facing
  
@check_timer:
  ; Decrement idle timer
  lda player_idle_timer
  beq @start_moving
  dec player_idle_timer
  rts

@start_moving:
  ; Move to next destination
  inc player_destination
  lda player_destination
  cmp #10                    ; Check if past outbox (destination 9)
  bcc @valid_destination
  
  ; Wrap back to inbox
  lda #DEST_INBOX
  sta player_destination

@valid_destination:
  ; Set new target position
  jsr set_target_position
  
  ; Determine facing direction
  jsr set_facing_direction
  
  ; Switch to walking state
  lda #STATE_WALKING
  sta player_state
  
  ; Reset animation
  lda #$00
  sta player_anim_frame
  lda #ANIM_SPEED
  sta player_anim_timer
  
  ; Reset movement timer
  lda #PLAYER_SPEED
  sta player_move_timer
  
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


; Move one pixel toward target position
move_toward_target:
  ; Check if arrived at target X
  lda player_x
  cmp player_target_x
  bne @move_horizontal
  
  ; Check if arrived at target Y
  lda player_y
  cmp player_target_y
  bne @move_vertical
  
  ; Fully arrived - switch to idle
  lda #STATE_IDLE
  sta player_state
  lda #IDLE_TIME
  sta player_idle_timer
  lda #$00
  sta player_anim_frame
  
  ; Set facing based on destination
  lda player_destination
  cmp #DEST_INBOX
  bne @face_right_arrival
  
  ; At inbox - face left
  lda #$01
  sta player_facing
  rts
  
@face_right_arrival:
  ; At any other location - face right
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


; Set target position based on destination
set_target_position:
  ldx player_destination
  
  cpx #DEST_INBOX
  bne @check_tile0
  lda #INBOX_X
  sta player_target_x
  lda #INBOX_Y
  sta player_target_y
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

