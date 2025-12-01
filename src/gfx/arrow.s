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
  lda controller_state
  and #%00000100
  beq check_up
  lda previous_controller
  and #%00000100
  bne check_up

  lda arrow_row
  cmp #$16        ; max row 22
  bcs check_up

  jsr erase_arrow_sprite
  inc arrow_row
  jsr calc_arrow_address
  jsr draw_arrow_sprite

check_up:
  lda controller_state
  and #%00001000
  beq movement_done
  lda previous_controller
  and #%00001000
  bne movement_done

  lda arrow_row
  cmp #$03        ; min row 3
  bcc movement_done
  beq movement_done

  jsr erase_arrow_sprite
  dec arrow_row
  jsr calc_arrow_address
  jsr draw_arrow_sprite

movement_done:
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
  lda arrow_position_hi
  sta $2006
  lda arrow_position
  sta $2006
  lda #$03
  sta $2007
  rts

; CALCULATE 16-BIT PPU ADDRESS
calc_arrow_address:
  lda #$20
  sta arrow_position_hi
  lda #$00
  sta arrow_position
  
  ldx arrow_row
  beq add_column
  
add_row_loop:
  lda arrow_position
  clc
  adc #32
  sta arrow_position
  lda arrow_position_hi
  adc #$00
  sta arrow_position_hi
  dex
  bne add_row_loop
  
add_column:
  lda arrow_position
  clc
  adc arrow_column
  sta arrow_position
  lda arrow_position_hi
  adc #$00
  sta arrow_position_hi
  rts