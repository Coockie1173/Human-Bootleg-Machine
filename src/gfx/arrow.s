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


handle_arrow_movement:
  lda arrow_update_flag
  beq @NoMove
    jsr erase_arrow_sprite
    jsr draw_arrow_sprite
    lda #$00
    sta arrow_update_flag

  @NoMove:

  lda CURSORSTATE
  bne :+
    rts
  :
  lda CURSORBLINKTIMER
  and #%00010000
  bne @DontDisp
    jmp draw_arrow_sprite
  @DontDisp:
    jmp blink_arrow_sprite

; DRAW ARROW SUBROUTINE
draw_arrow_sprite:
  lda $2002
  lda arrow_position_hi
  sta $2006
  lda arrow_position
  sta $2006
  lda #$1F
  sta $2007

  jsr play_sfx_cursor

  rts

blink_arrow_sprite: ;clears out the arrow sprite when it's in blinky mode
  lda $2002
  lda arrow_position_hi
  sta $2006
  lda arrow_position
  sta $2006
  lda #$03
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
