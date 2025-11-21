nmi:
  PHP
  PHA
  PHX
  PHY

  ; Disable rendering
  lda #%00000000
  sta $2001

  ; Read controller
  jsr read_controller

  ; Handle A button
  jsr handle_a_button

  ; Handle arrow movement
  jsr handle_arrow_movement

  ; Reset scroll
  lda $2002
  lda #$00
  sta $2005
  lda #$00
  sta $2005

  ; Re-enable rendering
  lda #%10000000
  sta $2000
  lda #%00011110
  sta $2001

  ; Save controller state
  lda controller_state
  sta previous_controller

  PLY
  PLX
  PLA
  PLP
  rti

; READ CONTROLLER SUBROUTINE
; Sets controller_state
read_controller:
  lda #$01
  sta $4016
  lda #$00
  sta $4016

  lda #$00
  sta controller_state

  ldx #$08
read_loop:
  lda $4016
  lsr a
  rol controller_state
  dex
  bne read_loop
  rts

; HANDLE A BUTTON SUBROUTINE
handle_a_button:
  lda controller_state
  and #%10000000
  beq a_done
  lda previous_controller
  and #%10000000
  bne a_done

  lda arrow_visible
  eor #$01
  sta arrow_visible

  lda arrow_visible
  beq erase_arrow_sprite

  jsr draw_arrow_sprite
a_done:
  rts

; HANDLE ARROW MOVEMENT (UP/DOWN)
handle_arrow_movement:
  lda arrow_visible
  beq movement_done

  ; DOWN
  lda controller_state
  and #%00000100
  beq check_up
  lda previous_controller
  and #%00000100
  bne check_up

  ; Check if at max row (22)
  lda arrow_row
  cmp #$16        ; max row 22
  bcs check_up    ; Don't move if at or past max

  ; Erase at CURRENT position
  jsr erase_arrow_sprite
  
  ; Update row
  inc arrow_row
  
  ; Calculate NEW address and draw
  jsr calc_arrow_address
  jsr draw_arrow_sprite

check_up:
  lda controller_state
  and #%00001000
  beq movement_done
  lda previous_controller
  and #%00001000
  bne movement_done

  ; Check if at min row (3)
  lda arrow_row
  cmp #$03        ; min row 3
  bcc movement_done  ; Don't move if below 3
  beq movement_done  ; Don't move if exactly 3

  ; Erase at CURRENT position
  jsr erase_arrow_sprite
  
  ; Update row
  dec arrow_row
  
  ; Calculate NEW address and draw
  jsr calc_arrow_address
  jsr draw_arrow_sprite

movement_done:
  rts

; DRAW ARROW SUBROUTINE
; Uses arrow_position, arrow_position_hi
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
; arrow_row, arrow_column -> arrow_position, arrow_position_hi
calc_arrow_address:
  ; Calculate $2000 + (row * 32) + column
  
  ; Start with base address $2000
  lda #$20
  sta arrow_position_hi
  lda #$00
  sta arrow_position
  
  ; Add (row * 32) by adding 32 for each row
  ldx arrow_row
  beq add_column        ; If row is 0, skip to adding column
  
add_row_loop:
  lda arrow_position
  clc
  adc #32               ; Add 32 to low byte
  sta arrow_position
  lda arrow_position_hi
  adc #$00              ; Add carry to high byte
  sta arrow_position_hi
  dex
  bne add_row_loop
  
add_column:
  ; Add column
  lda arrow_position
  clc
  adc arrow_column
  sta arrow_position
  lda arrow_position_hi
  adc #$00
  sta arrow_position_hi
  
  rts