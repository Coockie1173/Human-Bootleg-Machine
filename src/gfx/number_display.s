; Converts numbers [-99 to 99] to tiles
; DRAW NUMBER TILES IN INBOX
    ; Check numbers on the puzzle > match to tiles:
    ; Check if negative
        ; POSITIVE:
            ; Check digits amount
            ; > SINGLE: Draw TILE_NUM_0 as left tile > draw TILE_NUM_X as right tile
            ; > DOUBLE: Draw TILE_NUM_X as left tile > draw TILE_NUM_X as right tile
        ; NEGATIVE:
            ; Check digits amount
            ; > SINGLE: Draw TILE_MINUS as left tile > draw TILE_NUM_X as right tile
            ; > DOUBLE: Draw TILE_NUM_MINUS_X as left tile > draw TILE_NUM_X as right tile 
        ; DRAW TILES:
            ; > Top of list is INBOX pos ($2102)
                ; > Left tile on col: 2
                ; > Right tile on col: 3
                ; > First set of tiles on row: 8
            ; > Next set of tiles should be drawn UNDER previous > INC Y pos

; Converts numbers [-99 to 99] to tiles

draw_number:
    stx number_display_hi   ; Save PPU address
    sty number_display_lo

    sta VAR0                ; Save input number

    ; Check if positive
    bpl positive_number

; NEGATIVE NUMBER
negative_number:
    ; Get absolute value > invert bits > add 1
    eor #$FF
    clc
    adc #$01
    sta VAR0

    ; Check digit amount
    cmp #$0A                ; Compare with 10
    bcc negative_single
    jmp negative_double

; POSITIVE NUMBER
positive_number:
    cmp #$0A                ; Compare with 10
    bcc positive_single
    jmp positive_double

; SINGLE NEGATIVE: [-][x]
negative_single:
    pha                     ; Save digit

    ; Draw left tile (TILE_MINUS)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda #TILE_MINUS
    sta $2007

    ; Draw right tile (TILE_NUM_X)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    clc
    adc #$01                ; Move to next column
    sta $2006

    pla                     ; Restore digit
    clc
    adc #TILE_NUM_0
    sta $2007

    rts

; SINGLE POSITIVE: [0][x]
positive_single:
    pha                     ; Save digit

    ; Draw left tile (TILE_NUM_0)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda #TILE_NUM_0
    sta $2007

    ; Draw right tile (TILE_NUM_X)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    clc
    adc #$01                ; Move to next column
    sta $2006

    pla                     ; Restore digit
    clc
    adc #TILE_NUM_0
    sta $2007

    rts

; DOUBLE NEGATIVE: [-x][x]
negative_double:
    ; Divide by 10
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

    ; Draw left tile (TILE_NUM_MINUS_X)
    txa
    clc
    adc #TILE_NUM_MINUS_1
    pha                     ; Save tile ID

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    pla                     ; Restore tile ID
    sta $2007

    ; Draw right tile (TILE_NUM_X)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    clc
    adc #$01                ; Move to next column
    sta $2006

    pla                     ; Restore ones
    clc
    adc #TILE_NUM_0
    sta $2007

    rts

; DOUBLE POSITIVE: [x][x]
positive_double:
    ; Divide by 10
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

    ; Draw left tile (TILE_NUM_X)
    txa
    clc
    adc #TILE_NUM_0
    pha                     ; Save tile ID

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    pla                     ; Restore tile ID
    sta $2007

    ; Draw right tile (TILE_NUM_X)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    clc
    adc #$01                ; Move to next column
    sta $2006

    pla                     ; Restore ones
    clc
    adc #TILE_NUM_0
    sta $2007

    rts

; Erase a number (2 tiles)
erase_number:
    stx number_display_hi
    sty number_display_lo
    
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006
    
    lda #TILE_NUM_0         ; Use 0 as blank
    sta $2007
    sta $2007
    
    rts