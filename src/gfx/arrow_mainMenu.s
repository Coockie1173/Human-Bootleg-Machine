; Arrow movement and drawing routines

; Initialize arrow - call from reset
init_MMarrow:
  lda #$0D
  sta MMarrow_row
  lda #$0A 
  sta MMarrow_column
  
  ; Calculate and draw initial position
  jsr calc_MMarrow_address
  jsr draw_MMarrow_sprite


  lda MMarrow_position_hi
  sta MMarrow_position_old_hi
  lda MMarrow_position
  sta MMarrow_position_old
  rts

; HANDLE ARROW MOVEMENT (UP/DOWN)
handle_MMarrow_movement:
  lda MMarrow_update
  beq @movement_done

  lda MMarrow_position_hi
  sta MMarrow_position_old_hi
  lda MMarrow_position
  sta MMarrow_position_old
   
  jsr erase_MMarrow_sprite
  jsr calc_MMarrow_address
  jsr draw_MMarrow_sprite

@movement_done:
  rts

; DRAW ARROW SUBROUTINE
draw_MMarrow_sprite:
  lda $2002
  lda MMarrow_position_hi
  sta $2006
  lda MMarrow_position
  sta $2006
  lda #$6A
  sta $2007

  jsr play_sfx_cursor

  rts

; ERASE ARROW SUBROUTINE
erase_MMarrow_sprite:
  lda $2002
  lda MMarrow_position_old_hi
  sta $2006
  lda MMarrow_position_old
  sta $2006
  lda #$00
  sta $2007
  rts

; CALCULATE 16-BIT PPU ADDRESS
calc_MMarrow_address:
  lda #$20
  sta MMarrow_position_hi
  lda #$00
  sta MMarrow_position
  
  ldx MMarrow_row
  beq @add_column
  
@add_row_loop:
  lda MMarrow_position
  clc
  adc #32
  sta MMarrow_position
  lda MMarrow_position_hi
  adc #$00
  sta MMarrow_position_hi
  dex
  bne @add_row_loop
  
@add_column:
  lda MMarrow_position
  clc
  adc MMarrow_column
  sta MMarrow_position
  lda MMarrow_position_hi
  adc #$00
  sta MMarrow_position_hi
  rts