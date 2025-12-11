; Number system integration

.include "gfx/number_display.s"

; Bitmask table (ROM) - masks for tiles 0..7
tile_mask_table:
    .byte %00000001  ; tile 0
    .byte %00000010  ; tile 1
    .byte %00000100  ; tile 2
    .byte %00001000  ; tile 3
    .byte %00010000  ; tile 4
    .byte %00100000  ; tile 5
    .byte %01000000  ; tile 6
    .byte %10000000  ; tile 7

; init_number_displays - Initialize system on level load
init_number_displays:
    ; Clear all tile RAM values to 0
    ldx #$00
    lda #$00
@clear_loop:
    sta GAMEMMEM, x
    sta last_tile_values, x
    inx
    cpx #$08
    bcc @clear_loop
    
    ; Mark all tiles dirty ONCE for initial draw
    lda #$FF
    sta tile_values_dirty

    ; Mark special values for initial draw
    lda #$01
    sta hand_value_dirty
    sta inbox_value_dirty
    sta outbox_value_dirty
    
    ; Clear last known special values
    lda #$00
    sta last_hand_value
    lda #$FF
    sta last_inbox_value
    sta last_outbox_value

    rts

; set_tile_dirty - Mark a specific tile as dirty
; Input: X = tile index (0-7)
set_tile_dirty:
    lda tile_mask_table, x
    ora tile_values_dirty
    sta tile_values_dirty
    rts

; Mark only changed tiles as dirty
check_tile_changes:
    ldx #$00
@loop:
    ; Compare current value with last known
    lda GAMEMMEM, x
    cmp last_tile_values, x
    beq @next               ; Same value, skip
    
    ; Value changed!
    sta last_tile_values, x ; Update last known value
    
    ; Mark this tile as dirty
    txa
    pha                     ; Save X
    jsr set_tile_dirty      ; X is still the tile index
    pla
    tax                     ; Restore X
    
@next:
    inx
    cpx #$08
    bcc @loop
    
    rts

; check_hand_change - Check if hand value changed
check_hand_change:
    lda HANDMEM
    cmp last_hand_value
    beq @no_change
    
    ; Changed!
    sta last_hand_value
    lda #$01
    sta hand_value_dirty
    
@no_change:
    rts

; check_inbox_change - Check if inbox front value changed
check_inbox_change:
    ldy #$00
    lda (INBOXPTR), y       ; Get current front value
    cmp last_inbox_value
    beq @no_change
    
    ; Changed!
    sta last_inbox_value
    lda #$01
    sta inbox_value_dirty
    
@no_change:
    rts

; check_outbox_change - Check if outbox value changed
check_outbox_change:
    ldx SOLPTR
    cpx #$00
    beq @empty              ; No solution items yet
    
    dex                     ; Get last item index
    lda SOLUTION, x
    cmp last_outbox_value
    beq @no_change
    
    ; Changed!
    sta last_outbox_value
    lda #$01
    sta outbox_value_dirty
    rts
    
@empty:
    lda #$FF
    cmp last_outbox_value
    beq @no_change
    sta last_outbox_value
    lda #$01
    sta outbox_value_dirty
    
@no_change:
    rts

; update_number_displays - Check all values and mark changes
update_number_displays:
    jsr check_tile_changes
    jsr check_hand_change
    jsr check_inbox_change
    jsr check_outbox_change 
    rts

; draw_pending_numbers - Draw only dirty numbers
draw_pending_numbers:
    ; Quick-check if any work needed
    lda tile_values_dirty
    bne @do_tiles
    ;lda hand_value_dirty
    ;bne @do_hand
    lda inbox_value_dirty
    bne @do_inbox
    lda outbox_value_dirty
    bne @do_outbox
    rts                     ; Nothing to do

@do_tiles:
    ; Only draw tiles that have their bit set
    ldx #$00                ; X = tile index 0..7
@tile_loop:
    ; Test whether this tile's bit is set
    lda tile_values_dirty
    and tile_mask_table, x
    beq @next_tile          ; Bit not set, skip
    
    ; Draw this tile
    txa
    pha                     ; Save X
    
    ; Get value to draw
    lda GAMEMMEM, x
    pha                     ; Save value
    
    ; Get PPU address
    jsr get_tile_ppu_address  ; Returns X=hi, Y=lo
    
    ; Draw the number
    pla                     ; Restore value to A
    jsr draw_number
    
    ; Clear this tile's dirty bit
    pla                     ; Restore tile index
    tax
    
    lda tile_mask_table, x
    eor #$FF                ; Invert mask
    and tile_values_dirty
    sta tile_values_dirty
    
@next_tile:
    inx
    cpx #$08
    bcc @tile_loop


@do_inbox:
    lda inbox_value_dirty
    beq @do_outbox
    ;jsr draw_inbox_front_now
    jsr draw_inbox_all
    lda #$00
    sta inbox_value_dirty

@do_outbox:
    lda outbox_value_dirty
    beq @done
    jsr draw_outbox_front_now
    lda #$00
    sta outbox_value_dirty

@done:
    rts

; get_tile_ppu_address - Get PPU address for tile display
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

; draw_hand_value_now - Draw hand value
draw_hand_value_now:
    lda HANDMEM
    ldx #$21
    ldy #$90
    jsr draw_number
    rts

; draw_inbox_front_now - Draw inbox front value
;draw_inbox_front_now:
    ;ldy #$00
    ;lda (INBOXPTR), y
    
    ;cmp #$FF
    ;beq @empty
    
    ; Draw the value
    ;ldx #INBOXLOCHI
    ;ldy #INBOXLOCLO
    ;jsr draw_number
    ;rts
    
;@empty:
    ; Inbox is empty - erase display
    ;ldx #INBOXLOCHI
    ;ldy #INBOXLOCLO
    ;jsr erase_number
    ;rts

draw_inbox_all:
    ; Reset PPU latch first
    bit $2002
    
    LDX #$00

@loop:
    LDA INBOX_SLOT_1,x
    CMP #$FF
    BEQ @draw_empty_tile    ; If FF, draw empty tile ($03)
    
    ; Draw the number
    PHX                     ; save slot index
    PHA                     ; save value to draw
    
    ; Get PPU address for this slot
    TXA                     ; Move slot index to A
    JSR get_inbox_slot_ppu_address
    ; returns X=hi, Y=lo
    
    PLA                     ; restore number to draw
    JSR draw_number
    
    PLX                     ; restore slot index
    JMP @next_slot

@draw_empty_tile:
    PHX                     ; save slot index
    
    ; Get PPU address for this slot
    TXA                     ; Move slot index to A
    JSR get_inbox_slot_ppu_address
    ; returns X=hi, Y=lo
    
    ; Draw two $03 tiles (or whatever your empty tile is)
    ; Reset PPU latch
    bit $2002
    stx $2006
    sty $2006
    
    lda #$00                ; Empty tile
    sta $2007
    sta $2007
    
    PLX                     ; restore slot index

@next_slot:
    INX
    CPX #$04
    BCC @loop

@done:
    RTS


; draw_outbox_front_now - Draw outbox last value
draw_outbox_front_now:
    ldx SOLPTR
    cpx #$00
    beq @empty_outbox
    
    ; Draw the last value
    dex
    lda SOLUTION, x
    ldx #OUTBOXLOCHI
    ldy #OUTBOXLOCLO
    jsr draw_number
    rts
    
@empty_outbox:
    ; Outbox is empty - erase display
    ldx #OUTBOXLOCHI
    ldy #OUTBOXLOCLO
    jsr erase_number
    rts

get_inbox_slot_ppu_address:
    CMP #$00
    BNE @slot1
    LDX #INBOXLOCHI
    LDY #INBOXLOCLO
    RTS

@slot1:
    CMP #$01
    BNE @slot2
    LDX #INBOX1_HI
    LDY #INBOX1_LO
    RTS

@slot2:
    CMP #$02
    BNE @slot3
    LDX #INBOX2_HI
    LDY #INBOX2_LO
    RTS

@slot3:
    LDX #INBOX3_HI
    LDY #INBOX3_LO
    RTS
