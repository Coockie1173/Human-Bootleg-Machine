nmi:
  PHP
  PHA
  PHX
  PHY

  ; Disable rendering FIRST
  lda #%00000000
  sta $2001             ; Turn off rendering

  ; Read controller input
  lda #$01
  sta $4016
  lda #$00
  sta $4016
  
  ldx #$08
@read_controller:
  lda $4016
  lsr a
  rol controller_state
  dex
  bne @read_controller

  ; Check A button (toggle arrow visibility)
  lda controller_state
  and #%10000000        ; A button mask
  beq @no_a_button
  
  lda previous_controller
  and #%10000000
  bne @no_a_button
  
  lda arrow_visible
  eor #$01
  sta arrow_visible
  
  lda arrow_visible
  beq @erase_arrow
  
  ; Draw arrow
  lda $2002
  lda #$20
  sta $2006
  lda arrow_position
  sta $2006
  lda #$1F
  sta $2007
  jmp @no_a_button
  
@erase_arrow:
  lda $2002
  lda #$20
  sta $2006
  lda arrow_position
  sta $2006
  lda #$03
  sta $2007

@no_a_button:

  ; Check DOWN button
  lda arrow_visible
  beq @skip_down
  
  lda controller_state
  and #%00000100
  beq @skip_down
  
  lda previous_controller
  and #%00000100
  bne @skip_down
  
  ; Erase old arrow
  lda $2002
  lda #$20
  sta $2006
  lda arrow_position
  sta $2006
  lda #$03
  sta $2007
  
  ; Move down
 lda arrow_row
cmp #$0B         ; 3 + 8 = 11 max
bcs @skip_down
clc
adc #$01         ; move down 1 row
sta arrow_row

; Update arrow_position
lda arrow_row
asl a
asl a
asl a
asl a
asl a           ; multiply by 32
clc
adc #$17        ; add column 23
sta arrow_position
  
  ; Draw new arrow
  lda $2002
  lda #$20
  sta $2006
  lda arrow_position
  sta $2006
  lda #$1F
  sta $2007

@skip_down:

  ; Check UP button
  lda arrow_visible
  beq @skip_up
  
  lda controller_state
  and #%00001000
  beq @skip_up
  
  lda previous_controller
  and #%00001000
  bne @skip_up
  
  ; Erase old arrow
  lda $2002
  lda #$20
  sta $2006
  lda arrow_position
  sta $2006
  lda #$03
  sta $2007
  
  ; Move up
  lda arrow_row
cmp #$03          ; stop at row 3
beq @skip_up
sec
sbc #$01          ; move up 1 row
sta arrow_row

; Update arrow_position
lda arrow_row
asl a
asl a
asl a
asl a
asl a           ; multiply by 32
clc
adc #$17        ; add column 23
sta arrow_position
  
  ; Draw new arrow
  lda $2002
  lda #$20
  sta $2006
  lda arrow_position
  sta $2006
  lda #$1F
  sta $2007

@skip_up:

  ; Save controller state
  lda controller_state
  sta previous_controller

   ; RESET SCROLL POSITION (add this!)
  lda $2002             ; Reset PPU address latch
  lda #$00
  sta $2005             ; X scroll = 0
  lda #$00
  sta $2005             ; Y scroll = 0

  ; Re-enable rendering at the END
  lda #%10000000        ; Enable NMI
  sta $2000
  lda #%00011110        ; Enable rendering
  sta $2001

  PLY
  PLX
  PLA
  PLP
  rti