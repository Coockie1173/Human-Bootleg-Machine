; ============================================================================
; SPRITE-BASED NUMBER DISPLAY SYSTEM - 3 INBOX SLOTS VERSION
; ============================================================================
; Uses sprites 40-63 (24 sprites total)
; - Sprites 0-3: Player
; - Sprites 4-5: Hand (above player)
; - Sprites 40-55: Tiles 0-7 (16 sprites)
; - Sprites 56-61: Inbox slots 0-2 (6 sprites)
; - Sprites 62-63: Outbox (2 sprites)

; Sprite assignments (starting at 40 to avoid conflicts)
SPR_TILE0_LEFT  = 40
SPR_TILE0_RIGHT = 41
SPR_TILE1_LEFT  = 42
SPR_TILE1_RIGHT = 43
SPR_TILE2_LEFT  = 44
SPR_TILE2_RIGHT = 45
SPR_TILE3_LEFT  = 46
SPR_TILE3_RIGHT = 47
SPR_TILE4_LEFT  = 48
SPR_TILE4_RIGHT = 49
SPR_TILE5_LEFT  = 50
SPR_TILE5_RIGHT = 51
SPR_TILE6_LEFT  = 52
SPR_TILE6_RIGHT = 53
SPR_TILE7_LEFT  = 54
SPR_TILE7_RIGHT = 55

; Inbox slots (only 3)
SPR_INBOX0_LEFT  = 56
SPR_INBOX0_RIGHT = 57
SPR_INBOX1_LEFT  = 58
SPR_INBOX1_RIGHT = 59
SPR_INBOX2_LEFT  = 60
SPR_INBOX2_RIGHT = 61

SPR_OUTBOX_LEFT = 62
SPR_OUTBOX_RIGHT = 63

; Sprite Y positions
TILE0_SPR_Y = 56
TILE1_SPR_Y = 56
TILE2_SPR_Y = 80
TILE3_SPR_Y = 80
TILE4_SPR_Y = 104
TILE5_SPR_Y = 104
TILE6_SPR_Y = 128
TILE7_SPR_Y = 128

; Inbox Y positions (3 slots)
INBOX0_SPR_Y = 64
INBOX1_SPR_Y = 96
INBOX2_SPR_Y = 128

OUTBOX_SPR_Y = 64

; Sprite X positions
TILE0_SPR_X = 64
TILE1_SPR_X = 96
TILE2_SPR_X = 64
TILE3_SPR_X = 96
TILE4_SPR_X = 64
TILE5_SPR_X = 96
TILE6_SPR_X = 64
TILE7_SPR_X = 96
INBOX_SPR_X = 16
OUTBOX_SPR_X = 152

; ============================================================================
; CONVERT NUMBER TO TILES
; Input: A = signed number (-99 to 99)
; Output: VAR1 = left tile, VAR2 = right tile
; ============================================================================
number_to_tiles:
    sta VAR0
    
    ; Check if negative
    bpl @positive
    
    ; NEGATIVE - Get absolute value
    eor #$FF
    clc
    adc #$01
    sta VAR0
    
    ; Check if single digit
    cmp #10
    bcc @neg_single
    
    ; NEGATIVE DOUBLE DIGIT
    ldx #0
@neg_div:
    cmp #10
    bcc @neg_div_done
    sec
    sbc #10
    inx
    jmp @neg_div
@neg_div_done:
    ; X = tens (1-9), A = ones (0-9)
    pha
    txa
    clc
    adc #$60                ; $60 + 1 = $61, $60 + 2 = $62
    sta VAR1
    pla
    clc
    adc #$07
    sta VAR2
    rts
    
@neg_single:
    lda #$60
    sta VAR1
    lda VAR0
    clc
    adc #$07
    sta VAR2
    rts

@positive:
    cmp #10
    bcc @pos_single
    
    ; POSITIVE DOUBLE DIGIT
    ldx #0
@pos_div:
    cmp #10
    bcc @pos_div_done
    sec
    sbc #10
    inx
    jmp @pos_div
@pos_div_done:
    pha
    txa
    clc
    adc #$07
    sta VAR1
    pla
    clc
    adc #$07
    sta VAR2
    rts
    
@pos_single:
    lda #$07
    sta VAR1
    lda VAR0
    clc
    adc #$07
    sta VAR2
    rts

; ============================================================================
; UPDATE ALL NUMBER SPRITES
; ============================================================================
update_number_sprites:
    ; TILE 0
    lda GAMEMMEM + 0
    jsr number_to_tiles
    lda #TILE0_SPR_Y
    sta $0200 + (SPR_TILE0_LEFT * 4)
    sta $0200 + (SPR_TILE0_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE0_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE0_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE0_LEFT * 4) + 2
    sta $0200 + (SPR_TILE0_RIGHT * 4) + 2
    lda #TILE0_SPR_X
    sta $0200 + (SPR_TILE0_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE0_RIGHT * 4) + 3
    
    ; TILE 1
    lda GAMEMMEM + 1
    jsr number_to_tiles
    lda #TILE1_SPR_Y
    sta $0200 + (SPR_TILE1_LEFT * 4)
    sta $0200 + (SPR_TILE1_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE1_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE1_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE1_LEFT * 4) + 2
    sta $0200 + (SPR_TILE1_RIGHT * 4) + 2
    lda #TILE1_SPR_X
    sta $0200 + (SPR_TILE1_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE1_RIGHT * 4) + 3
    
    ; TILE 2
    lda GAMEMMEM + 2
    jsr number_to_tiles
    lda #TILE2_SPR_Y
    sta $0200 + (SPR_TILE2_LEFT * 4)
    sta $0200 + (SPR_TILE2_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE2_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE2_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE2_LEFT * 4) + 2
    sta $0200 + (SPR_TILE2_RIGHT * 4) + 2
    lda #TILE2_SPR_X
    sta $0200 + (SPR_TILE2_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE2_RIGHT * 4) + 3
    
    ; TILE 3
    lda GAMEMMEM + 3
    jsr number_to_tiles
    lda #TILE3_SPR_Y
    sta $0200 + (SPR_TILE3_LEFT * 4)
    sta $0200 + (SPR_TILE3_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE3_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE3_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE3_LEFT * 4) + 2
    sta $0200 + (SPR_TILE3_RIGHT * 4) + 2
    lda #TILE3_SPR_X
    sta $0200 + (SPR_TILE3_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE3_RIGHT * 4) + 3
    
    ; TILE 4
    lda GAMEMMEM + 4
    jsr number_to_tiles
    lda #TILE4_SPR_Y
    sta $0200 + (SPR_TILE4_LEFT * 4)
    sta $0200 + (SPR_TILE4_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE4_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE4_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE4_LEFT * 4) + 2
    sta $0200 + (SPR_TILE4_RIGHT * 4) + 2
    lda #TILE4_SPR_X
    sta $0200 + (SPR_TILE4_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE4_RIGHT * 4) + 3
    
    ; TILE 5
    lda GAMEMMEM + 5
    jsr number_to_tiles
    lda #TILE5_SPR_Y
    sta $0200 + (SPR_TILE5_LEFT * 4)
    sta $0200 + (SPR_TILE5_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE5_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE5_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE5_LEFT * 4) + 2
    sta $0200 + (SPR_TILE5_RIGHT * 4) + 2
    lda #TILE5_SPR_X
    sta $0200 + (SPR_TILE5_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE5_RIGHT * 4) + 3
    
    ; TILE 6
    lda GAMEMMEM + 6
    jsr number_to_tiles
    lda #TILE6_SPR_Y
    sta $0200 + (SPR_TILE6_LEFT * 4)
    sta $0200 + (SPR_TILE6_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE6_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE6_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE6_LEFT * 4) + 2
    sta $0200 + (SPR_TILE6_RIGHT * 4) + 2
    lda #TILE6_SPR_X
    sta $0200 + (SPR_TILE6_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE6_RIGHT * 4) + 3
    
    ; TILE 7
    lda GAMEMMEM + 7
    jsr number_to_tiles
    lda #TILE7_SPR_Y
    sta $0200 + (SPR_TILE7_LEFT * 4)
    sta $0200 + (SPR_TILE7_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_TILE7_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_TILE7_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_TILE7_LEFT * 4) + 2
    sta $0200 + (SPR_TILE7_RIGHT * 4) + 2
    lda #TILE7_SPR_X
    sta $0200 + (SPR_TILE7_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_TILE7_RIGHT * 4) + 3
    
    ; INBOX SLOT 0
    lda INBOX_SLOT_1 + 0
    cmp #$FF
    beq @hide_inbox0
    jsr number_to_tiles
    lda #INBOX0_SPR_Y
    sta $0200 + (SPR_INBOX0_LEFT * 4)
    sta $0200 + (SPR_INBOX0_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_INBOX0_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_INBOX0_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_INBOX0_LEFT * 4) + 2
    sta $0200 + (SPR_INBOX0_RIGHT * 4) + 2
    lda #INBOX_SPR_X
    sta $0200 + (SPR_INBOX0_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_INBOX0_RIGHT * 4) + 3
    jmp @check_inbox1
@hide_inbox0:
    lda #$FF
    sta $0200 + (SPR_INBOX0_LEFT * 4)
    sta $0200 + (SPR_INBOX0_RIGHT * 4)
    
@check_inbox1:
    ; INBOX SLOT 1
    lda INBOX_SLOT_1 + 1
    cmp #$FF
    beq @hide_inbox1
    jsr number_to_tiles
    lda #INBOX1_SPR_Y
    sta $0200 + (SPR_INBOX1_LEFT * 4)
    sta $0200 + (SPR_INBOX1_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_INBOX1_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_INBOX1_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_INBOX1_LEFT * 4) + 2
    sta $0200 + (SPR_INBOX1_RIGHT * 4) + 2
    lda #INBOX_SPR_X
    sta $0200 + (SPR_INBOX1_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_INBOX1_RIGHT * 4) + 3
    jmp @check_inbox2
@hide_inbox1:
    lda #$FF
    sta $0200 + (SPR_INBOX1_LEFT * 4)
    sta $0200 + (SPR_INBOX1_RIGHT * 4)
    
@check_inbox2:
    ; INBOX SLOT 2
    lda INBOX_SLOT_1 + 2
    cmp #$FF
    beq @hide_inbox2
    jsr number_to_tiles
    lda #INBOX2_SPR_Y
    sta $0200 + (SPR_INBOX2_LEFT * 4)
    sta $0200 + (SPR_INBOX2_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_INBOX2_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_INBOX2_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_INBOX2_LEFT * 4) + 2
    sta $0200 + (SPR_INBOX2_RIGHT * 4) + 2
    lda #INBOX_SPR_X
    sta $0200 + (SPR_INBOX2_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_INBOX2_RIGHT * 4) + 3
    jmp @check_outbox
@hide_inbox2:
    lda #$FF
    sta $0200 + (SPR_INBOX2_LEFT * 4)
    sta $0200 + (SPR_INBOX2_RIGHT * 4)
    
@check_outbox:
    ; OUTBOX
    ldx SOLPTR
    cpx #$00
    beq @hide_outbox
    dex
    lda SOLUTION, x
    cmp #$FF
    beq @hide_outbox
    jsr number_to_tiles
    lda #OUTBOX_SPR_Y
    sta $0200 + (SPR_OUTBOX_LEFT * 4)
    sta $0200 + (SPR_OUTBOX_RIGHT * 4)
    lda VAR1
    sta $0200 + (SPR_OUTBOX_LEFT * 4) + 1
    lda VAR2
    sta $0200 + (SPR_OUTBOX_RIGHT * 4) + 1
    lda #%00000010
    sta $0200 + (SPR_OUTBOX_LEFT * 4) + 2
    sta $0200 + (SPR_OUTBOX_RIGHT * 4) + 2
    lda #OUTBOX_SPR_X
    sta $0200 + (SPR_OUTBOX_LEFT * 4) + 3
    clc
    adc #8
    sta $0200 + (SPR_OUTBOX_RIGHT * 4) + 3
    rts
@hide_outbox:
    lda #$FF
    sta $0200 + (SPR_OUTBOX_LEFT * 4)
    sta $0200 + (SPR_OUTBOX_RIGHT * 4)
    rts