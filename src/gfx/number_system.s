; Number system integration
; Links draw_number.s with game state

.include "gfx/number_display.s"

; Initialize all number displays when game starts
init_number_displays:
  ; Clear all tile values to 0
  ldx #$00
  lda #$00
@clear_loop:
  sta GAMEMMEM, x
  inx
  cpx #$08
  bcc @clear_loop
  
  ; Mark all for update
  lda #$FF
  sta tile_values_dirty
  lda #$01
  sta hand_value_dirty
  sta inbox_value_dirty
  
  rts

; Mark all displays as needing update (call after commands execute)
update_number_displays:
  lda #$FF
  sta tile_values_dirty    ; All 8 tiles dirty
  lda #$01
  sta hand_value_dirty
  sta inbox_value_dirty
  rts

; Actually draw numbers (call ONLY in NMI)
draw_pending_numbers:
  ; Check if any updates needed
  lda tile_values_dirty
  bne @do_tiles
  lda hand_value_dirty
  bne @do_hand
  lda inbox_value_dirty
  bne @do_inbox
  rts

@do_tiles:
  jsr draw_all_tile_values_now
  lda #$00
  sta tile_values_dirty

@do_hand:
  lda hand_value_dirty
  beq @do_inbox
  jsr draw_hand_value_now
  lda #$00
  sta hand_value_dirty

@do_inbox:
  lda inbox_value_dirty
  beq @done
  jsr draw_inbox_front_now
  lda #$00
  sta inbox_value_dirty

@done:
  rts

; Draw all 8 tile values (called in NMI only)
draw_all_tile_values_now:
  ldx #$00
  
@loop:
  txa                 ; Save tile index to A
  pha                 ; Push to stack
  
  ; Get value from GAMEMMEM
  lda GAMEMMEM, x
  pha                 ; Save value
  
  ; Get PPU address for this tile
  jsr get_tile_ppu_address
  ; X = high byte, Y = low byte
  
  pla                 ; Restore value
  jsr draw_number     ; Draw it
  
  pla                 ; Restore tile index
  tax
  inx
  cpx #$08
  bcc @loop
  
  rts

; Get PPU address for tile display
; Input: X = tile index (0-7)
; Output: X = PPU high byte, Y = PPU low byte
get_tile_ppu_address:
  cpx #$00
  bne @tile1
  ldx #TILE0LOCHI
  ldy #TILE0LOCLO
  rts
  
@tile1:
  cpx #$01
  bne @tile2
  ldx #TILE1LOCHI
  ldy #TILE1LOCLO
  rts
  
@tile2:
  cpx #$02
  bne @tile3
  ldx #TILE2LOCHI
  ldy #TILE2LOCLO
  rts
  
@tile3:
  cpx #$03
  bne @tile4
  ldx #TILE3LOCHI
  ldy #TILE3LOCLO
  rts
  
@tile4:
  cpx #$04
  bne @tile5
  ldx #TILE4LOCHI
  ldy #TILE4LOCLO
  rts
  
@tile5:
  cpx #$05
  bne @tile6
  ldx #TILE5LOCHI
  ldy #TILE5LOCLO
  rts
  
@tile6:
  cpx #$06
  bne @tile7
  ldx #TILE6LOCHI
  ldy #TILE6LOCLO
  rts
  
@tile7:
  ldx #TILE7LOCHI
  ldy #TILE7LOCLO
  rts

; Draw hand value (called in NMI only)
draw_hand_value_now:
  lda HANDMEM
  ldx #$21           ; Adjust these coordinates to where
  ldy #$90           ; you want the hand value displayed
  jsr draw_number
  rts

; Draw inbox front value (called in NMI only)
draw_inbox_front_now:
  ldy #$00
  lda (INBOXPTR), y
  
  cmp #$FF
  beq @empty
  
  ; Draw the value
  ldx #INBOXLOCHI
  ldy #INBOXLOCLO
  jsr draw_number
  rts
  
@empty:
  ; Inbox is empty - erase display
  ldx #INBOXLOCHI
  ldy #INBOXLOCLO
  jsr erase_number
  rts