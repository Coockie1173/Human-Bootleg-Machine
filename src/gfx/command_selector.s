; Initialize command selector - call from reset
init_command_selector:
  lda #CMD_ADD
  sta current_command
  
    ; Calculate PPU address for row 25, col 1
    ; Address = $2000 + (1 * 32) + 25 = $2000 + 32 + 25 = $2039
  lda #$20
  sta command_position_hi
  lda #$39
  sta command_position
  
  ; Draw initial command
  jsr draw_current_command
  rts

; Handle LEFT/RIGHT for command cycling
handle_command_selector:
  ; Check LEFT button
  lda controller_state
  and #%00000010
  beq @check_right
  lda previous_controller
  and #%00000010
  bne @check_right
  
  ; Erase current
  jsr erase_current_command
  
  ; Previous command (with wrap)
  lda current_command
  beq @wrap_left
  dec current_command
  jmp @draw_left
@wrap_left:
  lda #CMD_JUMP        ; Last command
  sta current_command
@draw_left:
  jsr draw_current_command

@check_right:
  ; Check RIGHT button
  lda controller_state
  and #%00000001
  beq @done
  lda previous_controller
  and #%00000001
  bne @done
  
  ; Erase current
  jsr erase_current_command
  
  ; Next command (with wrap)
  lda current_command
  cmp #CMD_JUMP        ; Last command
  beq @wrap_right
  inc current_command
  jmp @draw_right
@wrap_right:
  lda #CMD_ADD
  sta current_command
@draw_right:
  jsr draw_current_command

@done:
  rts

; Draw current command
draw_current_command:
  lda current_command
  cmp #CMD_ADD
  bne @try_sub
  jsr draw_add
  rts

@try_sub:
  cmp #CMD_SUB
  bne @try_copyto
  jsr draw_sub
  rts

@try_copyto:
  cmp #CMD_COPYTO
  bne @try_copyfrom
  jsr draw_copyto
  rts

@try_copyfrom:
  cmp #CMD_COPYFROM
  bne @try_jump
  jsr draw_copyfrom
  rts

@try_jump:
  jsr draw_jump
  rts

; Erase current command
erase_current_command:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  
  ; Erase 4 tiles (COPYFROM is the longest)
  lda #$03              ; Gray background tile
  sta $2007
  sta $2007
  sta $2007
  sta $2007
  rts

; Draw ADD (2 tiles)
draw_add:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_ADD_1
  sta $2007
  lda #TILE_ADD_2
  sta $2007
  rts

; Draw SUB (2 tiles)
draw_sub:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_SUB_1
  sta $2007
  lda #TILE_SUB_2
  sta $2007
  rts

; Draw COPYTO (3 tiles)
draw_copyto:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_COPYTO_1
  sta $2007
  lda #TILE_COPYTO_2
  sta $2007
  lda #TILE_COPYTO_3
  sta $2007
  rts

; Draw COPYFROM (4 tiles)
draw_copyfrom:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_COPYFROM_1
  sta $2007
  lda #TILE_COPYFROM_2
  sta $2007
  lda #TILE_COPYFROM_3
  sta $2007
  lda #TILE_COPYFROM_4
  sta $2007
  rts

; Draw JUMP (2 tiles)
draw_jump:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_JUMP_1
  sta $2007
  lda #TILE_JUMP_2
  sta $2007
  rts