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
  rts

; HANDLE ARROW MOVEMENT (UP/DOWN)
handle_MMarrow_movement:
  ; DOWN
  lda controller_state
  and #%00000100
  beq @check_up
  lda previous_controller
  and #%00000100
  bne @check_up

  lda MMarrow_row
  cmp #$13         ; max row 19
  bcs @check_up

  jsr erase_MMarrow_sprite
  lda MMarrow_row
  clc
  adc #$02          ; Move down 2 rows
  sta MMarrow_row
  jsr calc_MMarrow_address
  jsr draw_MMarrow_sprite

@check_up:
  lda controller_state
  and #%00001000
  beq @movement_done
  lda previous_controller
  and #%00001000
  bne @movement_done

  lda MMarrow_row
  cmp #$0D            ; min row 13
  bcc @movement_done  ; If at 13, can't go up
  beq @movement_done  ; If < 13, can't go up

  jsr erase_MMarrow_sprite
  dec MMarrow_row
  dec MMarrow_row
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
  rts

; ERASE ARROW SUBROUTINE
erase_MMarrow_sprite:
  lda $2002
  lda MMarrow_position_hi
  sta $2006
  lda MMarrow_position
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