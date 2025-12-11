; Command list management
; Displays a placeholder and allows adding commands with SELECT button

; Initialize position of the top of the list > placeholder tile
init_command_list:
    lda #$03
    sta placeholder_row
    lda #24
    sta placeholder_col
    
    ; Clear the command count
    lda #$00
    sta command_list_count
    
    jsr calc_placeholder_address
    jsr draw_placeholder
    rts

; Check controller state > is SELECT pressed?
handle_selected_command:
    lda update_list
    beq @end

    lda #$00
    sta VAR0 ;EOL flag
    
    lda #$03
    sta placeholder_row
    lda #24
    sta placeholder_col
    jsr calc_placeholder_address

    LDY #19 ;setup command counter
    ldx scrollIDX ;setup scroll index in full list
    @loopStart:
    PHX
    
    lda COMMANDS,x
    cmp #CMD_EOL
    bne :+
      PLX 
      jmp @clearflag
    :
    sta VAR1

    jsr draw_selected_command

    @LoopEnd:
    inc placeholder_row
    jsr calc_placeholder_address
    PLX
    inx
    DEY
    bne @loopStart ;keep looping for all rows
    @clearflag:
    lda #$00
    sta update_list
    
    inc placeholder_row
    jsr calc_placeholder_address
    jsr erase_placeholder
    @end:


    lda $2002 ;limit the weird janky movement
    lda #$20
    sta $2006
    lda #$00
    sta $2006
    lda #$05
    sta $2007
RTS


; Erase placeholder (draw background tile)
erase_placeholder:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #$03                ; Brown background tile
    sta $2007
    sta $2007
    sta $2007
    sta $2007
    rts

; Draw placeholder tile
draw_placeholder:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_PLACEHOLDER
    sta $2007
    rts

DrawCommandList:
  .dbyt draw_selected_inbox - 1, draw_selected_outbox - 1
  .dbyt draw_selected_copyfrom - 1, draw_selected_copyto - 1
  .dbyt draw_selected_add - 1, draw_selected_sub - 1
  .dbyt draw_selected_bumpup - 1, draw_selected_bumpdown - 1
  .dbyt draw_selected_jump - 1
  .dbyt draw_selected_jumpzero - 1
  .dbyt draw_selected_jumpnegative - 1
  .dbyt draw_selected_eol - 1

; tramampoline
draw_selected_command:
    lda VAR1
    ASL
    TAX
    lda DrawCommandList,x
    PHA
    lda DrawCommandList+1,x
    PHA

    jsr play_sfx_select

    RTS

; Draw CMD_ADD (2 tiles)
draw_selected_add:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_ADD_1
    sta $2007
    lda #TILE_ADD_2
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    rts

; Draw CMD_SUB (2 tiles)
draw_selected_sub:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_SUB_1
    sta $2007
    lda #TILE_SUB_2
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    rts

; Draw CMD_COPYTO (3 tiles)
draw_selected_copyto:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_COPYTO_1
    sta $2007
    lda #TILE_COPYTO_2
    sta $2007
    lda #TILE_COPYTO_3
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    rts

; Draw CMD_COPYFROM (4 tiles)
draw_selected_copyfrom:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
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
draw_selected_jump:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_JUMP_1
    sta $2007
    lda #TILE_JUMP_2
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    lda #$03                ; Brown background tile
    sta $2007
    rts

; Draw CMD_JUMPZERO (4 tiles)
draw_selected_jumpzero:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
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
draw_selected_jumpnegative:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
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
draw_selected_inbox:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
  sta $2006
  lda #TILE_INBOX_1
  sta $2007
  lda #TILE_INBOX_2
  sta $2007
  lda #TILE_INBOX_3
  sta $2007
  lda #$03                ; Brown background tile
  sta $2007
  rts

; Draw CMD_OUTBOX (3 tiles)
draw_selected_outbox:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
  sta $2006
  lda #TILE_OUTBOX_1
  sta $2007
  lda #TILE_OUTBOX_2
  sta $2007
  lda #TILE_OUTBOX_3
  sta $2007
  lda #$03                ; Brown background tile
  sta $2007
  rts

; Draw CMD_BUMPUP (3 tiles)
draw_selected_bumpup:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
  sta $2006
  lda #TILE_BUMPUP_1
  sta $2007
  lda #TILE_BUMPUP_2
  sta $2007
  lda #TILE_BUMPUP_3
  sta $2007
  lda #$03                ; Brown background tile
  sta $2007
  rts

; Draw CMD_BUMPDOWN (4 tiles)
draw_selected_bumpdown:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
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
draw_selected_eol:
  lda $2002
  lda placeholder_position_hi
  sta $2006
  lda placeholder_position
  sta $2006
  lda #TILE_EOL_1
  sta $2007
  lda #TILE_EOL_2
  sta $2007
  lda #$03                ; Brown background tile
  sta $2007
  sta $2007
  rts

; Calculate 16-bit PPU address for placeholder
calc_placeholder_address:
    lda #$20
    sta placeholder_position_hi
    lda #$00
    sta placeholder_position

    ldx placeholder_row
    beq add_placeholder_column

add_placeholder_row_loop:
    lda placeholder_position
    clc 
    adc #32
    sta placeholder_position
    lda placeholder_position_hi
    adc #$00
    sta placeholder_position_hi
    dex 
    bne add_placeholder_row_loop

add_placeholder_column:
    lda placeholder_position
    clc
    adc placeholder_col
    sta placeholder_position
    lda placeholder_position_hi
    adc #$00
    sta placeholder_position_hi
    rts