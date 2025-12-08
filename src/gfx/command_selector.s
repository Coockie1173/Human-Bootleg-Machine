; Initialize command selector - call from reset
init_command_selector:
  lda #CMD_INBOX
  sta current_command
  
    ; Calculate PPU address for row 25, col 1
    ; Address = $2000 + (1 * 32) + 25 = $2000 + 32 + 25 = $2039
  lda #$20
  sta command_position_hi
  lda #$39
  sta command_position
  
  ; Draw initial command
  inc UPDATECOMMFLAG
  jsr DrawcommandTrampoline
  rts

; Handle LEFT/RIGHT for command cycling
handle_command_selector_gfx:
  LDA UPDATECOMMFLAG
  BEQ @done
  LDA #$00
  STA UPDATECOMMFLAG
  jsr erase_current_command
  jsr DrawcommandTrampoline

@done:
  rts

DrawCommandListTop:
  .dbyt draw_inbox - 1, draw_outbox - 1
  .dbyt draw_copyfrom - 1, draw_copyto - 1
  .dbyt draw_add - 1, draw_sub - 1
  .dbyt draw_bumpup - 1, draw_bumpdown - 1
  .dbyt draw_jump - 1
  .dbyt draw_jumpzero - 1
  .dbyt draw_jumpnegative - 1

DrawcommandTrampoline: ;trampoline§
  LDA current_command
  ASL
  TAX
  LDA DrawCommandListTop,x
  PHA
  LDA DrawCommandListTop+1,x
  PHA
  RTS

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
