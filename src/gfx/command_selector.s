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
  cmp #CMD_EOL        ; Last command
  beq @wrap_right
  inc current_command
  jmp @draw_right
@wrap_right:
  lda #CMD_ADD        ; First command
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
  bne @try_jumpzero
  jsr draw_copyfrom
  rts

@try_jumpzero:
  cmp #CMD_JUMPZERO
  bne @try_jumpnegative
  jsr draw_jumpzero
  rts

@try_jumpnegative:
  cmp #CMD_JUMPNEGATIVE
  bne @try_jump
  jsr draw_jumpnegative
  rts

@try_jump:
  cmp #CMD_JUMP
  bne @try_inbox
  jsr draw_jump
  rts

@try_inbox:
  cmp #CMD_INBOX
  bne @try_outbox
  jsr draw_inbox
  rts

@try_outbox:
  cmp #CMD_OUTBOX
  bne @try_bumpup
  jsr draw_outbox
  rts

@try_bumpup:
  cmp #CMD_BUMPUP
  bne @try_bumpdown
  jsr draw_bumpup
  rts

@try_bumpdown:
  cmp #CMD_BUMPDOWN
  bne @try_eol
  jsr draw_bumpdown
  rts

@try_eol:
  jsr draw_eol
  rts

; Erase current command
erase_current_command:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  
  ; Erase 4 tiles (CMD_COPYFROM is the longest)
  lda #$03              ; Gray background tile
  sta $2007
  sta $2007
  sta $2007
  sta $2007
  rts

; Draw CMD_ADD (2 tiles)
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

; Draw CMD_SUB (2 tiles)
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

; Draw CMD_COPYTO (3 tiles)
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

; Draw CMD_COPYFROM (4 tiles)
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

; Draw CMD_JUMP (2 tiles)
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

; Draw CMD_JUMPZERO (4 tiles)
draw_jumpzero:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_JUMPZERO_1
  sta $2007
  lda #TILE_JUMPZERO_2
  sta $2007
  lda #TILE_JUMPZERO_3
  sta $2007
  lda #TILE_JUMPZERO_4
  sta $2007
  rts

; Draw CMD_JUMPNEGATIVE (4 tiles)
draw_jumpnegative:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_JUMPNEGATIVE_1
  sta $2007
  lda #TILE_JUMPNEGATIVE_2
  sta $2007
  lda #TILE_JUMPNEGATIVE_3
  sta $2007
  lda #TILE_JUMPNEGATIVE_4
  sta $2007
  rts

; Draw CMD_INBOX (3 tiles)
draw_inbox:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_INBOX_1
  sta $2007
  lda #TILE_INBOX_2
  sta $2007
  lda #TILE_INBOX_3
  sta $2007
  rts

; Draw CMD_OUTBOX (3 tiles)
draw_outbox:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_OUTBOX_1
  sta $2007
  lda #TILE_OUTBOX_2
  sta $2007
  lda #TILE_OUTBOX_3
  sta $2007
  rts

; Draw CMD_BUMPUP (3 tiles)
draw_bumpup:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_BUMPUP_1
  sta $2007
  lda #TILE_BUMPUP_2
  sta $2007
  lda #TILE_BUMPUP_3
  sta $2007
  rts

; Draw CMD_BUMPDOWN (4 tiles)
draw_bumpdown:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_BUMPDOWN_1
  sta $2007
  lda #TILE_BUMPDOWN_2
  sta $2007
  lda #TILE_BUMPDOWN_3
  sta $2007
  lda #TILE_BUMPDOWN_4
  sta $2007
  rts

; Draw CMD_EOL (2 tiles)
draw_eol:
  lda $2002
  lda command_position_hi
  sta $2006
  lda command_position
  sta $2006
  lda #TILE_EOL_1
  sta $2007
  lda #TILE_EOL_2
  sta $2007
  rts