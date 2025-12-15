; Constants for hand sprite positions (relative to player)
HAND_OFFSET_Y = 8     ; 8  (8 pixels above player)
HAND_OFFSET_X_LEFT = 0  ; Left tile aligned with player
HAND_OFFSET_X_RIGHT = 8 ; Right tile 8 pixels to the right

; Draw hand value sprites (call from NMI after drawing player)
draw_hand_sprites:
    ; Check if hand is empty - YOUR SYSTEM USES $FF FOR EMPTY, NOT $00!
    lda HANDMEM
    cmp #$FF
    beq @hide_hand
    
    ; Hand has a value - calculate tile IDs
    sta VAR0                ; Save hand value
    
    ; Check if negative
    bpl @positive_hand
    
    ; NEGATIVE NUMBER
    ; Get absolute value
    eor #$FF
    clc
    adc #$01
    sta VAR0
    
    ; Check if single or double digit
    cmp #$0A
    bcc @negative_single_sprite
    jmp @negative_double_sprite

@hide_hand:
    ; Hide both hand sprites by moving them off-screen
    lda #$FF
    sta $0210               ; Y position sprite 4
    sta $0214               ; Y position sprite 5
    rts


@positive_hand:
    ; Check if single or double digit
    cmp #$0A
    bcc @positive_single_sprite
    jmp @positive_double_sprite

; NEGATIVE SINGLE: [-][x]
@negative_single_sprite:
    ; Left sprite: minus sign
    lda player_y
    sec
    sbc #HAND_OFFSET_Y      ; Subtract to move UP
    sta $0210               
    
    lda #TILE_MINUS
    sta $0211               ; Tile index
    
    lda #%00000011          ; Attributes - palette 3 so it stands out
    sta $0212
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_LEFT
    sta $0213               ; X position
    
    ; Right sprite: digit
    lda player_y
    sec
    sbc #HAND_OFFSET_Y      ; Subtract to move UP
    sta $0214
    
    lda VAR0
    clc
    adc #TILE_NUM_0
    sta $0215
    
    lda #%00000011
    sta $0216
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_RIGHT
    sta $0217
    jmp @done


; POSITIVE SINGLE: [0][x]
@positive_single_sprite:
    ; Left sprite: zero
    lda player_y
    sec
    sbc #HAND_OFFSET_Y
    sta $0210
    
    lda #TILE_NUM_0
    sta $0211
    
    lda #%00000011          ; Palette 3
    sta $0212
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_LEFT
    sta $0213
    
    ; Right sprite: digit
    lda player_y
    sec
    sbc #HAND_OFFSET_Y
    sta $0214
    
    lda VAR0
    clc
    adc #TILE_NUM_0
    sta $0215
    
    lda #%00000011
    sta $0216
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_RIGHT
    sta $0217
    jmp @done



; NEGATIVE DOUBLE: [-x][x]
@negative_double_sprite:
    ; Divide by 10 to get tens and ones
    lda VAR0                ; Reload value
    ldx #$00
:   cmp #$0A
    bcc :+
    sec
    sbc #$0A
    inx
    jmp :-
:
    ; X = tens, A = ones
    pha                     ; Save ones
    
    ; Left sprite: minus + tens digit
    lda player_y
    sec
    sbc #HAND_OFFSET_Y
    sta $0210
    
    txa
    clc
    adc #TILE_NUM_MINUS_1   ; Combined minus+digit tiles
    sta $0211
    
    lda #%00000011
    sta $0212
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_LEFT
    sta $0213
    
    ; Right sprite: ones digit
    lda player_y
    sec
    sbc #HAND_OFFSET_Y
    sta $0214
    
    pla                     ; Restore ones
    clc
    adc #TILE_NUM_0
    sta $0215
    
    lda #%00000011
    sta $0216
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_RIGHT
    sta $0217
    jmp @done

; POSITIVE DOUBLE: [x][x]
@positive_double_sprite:
    ; Divide by 10 to get tens and ones
    lda VAR0                ; Reload value
    ldx #$00
:   cmp #$0A
    bcc :+
    sec
    sbc #$0A
    inx
    jmp :-
:
    ; X = tens, A = ones
    pha                     ; Save ones
    
    ; Left sprite: tens digit
    lda player_y
    sec
    sbc #HAND_OFFSET_Y
    sta $0210
    
    txa
    clc
    adc #TILE_NUM_0
    sta $0211
    
    lda #%00000011
    sta $0212
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_LEFT
    sta $0213
    
    ; Right sprite: ones digit
    lda player_y
    sec
    sbc #HAND_OFFSET_Y
    sta $0214
    
    pla                     ; Restore ones
    clc
    adc #TILE_NUM_0
    sta $0215
    
    lda #%00000011
    sta $0216
    
    lda player_x
    clc
    adc #HAND_OFFSET_X_RIGHT
    sta $0217
    ; Fall through to @done

@done:
    rts
