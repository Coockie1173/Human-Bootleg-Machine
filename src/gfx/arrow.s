; Arrow movement and drawing routines

; Initialize arrow - call from reset
init_arrow:
  lda #$03
  sta arrow_row
  lda #23
  sta arrow_column
  
  ; Calculate and draw initial position
  jsr calc_arrow_address
  jsr draw_arrow_sprite
  rts

; HANDLE ARROW MOVEMENT (UP/DOWN)
handle_arrow_movement:
  ; DOWN
  lda arrow_update_flag
  beq :+
    jsr erase_arrow_sprite
    jsr draw_arrow_sprite
    lda #$00
    sta arrow_update_flag
  :
  rts

; DRAW ARROW SUBROUTINE
draw_arrow_sprite:
  lda $2002
  lda arrow_position_hi
  sta $2006
  lda arrow_position
  sta $2006
  lda #$1F
  sta $2007
  rts

; ERASE ARROW SUBROUTINE
erase_arrow_sprite:
  lda $2002
  lda arrow_position_hi_old
  sta $2006
  lda arrow_position_old
  sta $2006
  lda #$03
  sta $2007
  rts
