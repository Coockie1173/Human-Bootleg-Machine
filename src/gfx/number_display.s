; Converts numbers [-99 to 99] to tiles


draw_number:
    stx number_display_hi   ; Save to PPU
    sty number_display_lo

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

    sta VAR0                ; input number

; Check if positive
    bpl positive_number     ; Branch if positive

; IF NEGATIVE
negative_number:
    ; Get absolute value > invert the bits > add 1
    eor #$FF
    clc
    adc #$01
    sta VAR0

; Check digit amount
    cmp $10
    bcc negative_single

; IF POSITIVE
positive_number:
    ; Immediately check digit amount
    cmp $10
    bcc positive_single

; SINGLE DIGITS:
negative_single:
    pha     ; restore digit

    ; Draw left tile (TILE_MINUS)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda TILE_MINUS
    sta $2007

    ; Draw the right tile (TILE_NUM_X)
    pla      ; restore digit

    clc
    adc #TILE_NUM_0
    sta VAR1

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda VAR1
    sta $2007

positive_single:
    ; left tile = TILE_NUM_0
    ; right tile = TILE_NUM_X

    pha     ; save the digit

    ; Draw left tile (TILE_NUM_0)
    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda TILE_NUM_0
    sta $2007

    ; Draw the right tile (TILE_NUM_X)
    pla       ; restore digit
    
    clc
    adc #TILE_NUM_0
    sta VAR1

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    clc
    adc #$01
    sta $2006

    lda VAR1
    sta $2007

    rts

; DOUBLE DIGITS:
negative_double:
    ; left tile = TILE_NUM_MINUS_X
    ; right tile = TILE_NUM_X

    ; Check left digit by dividing by 10
    ldx #$00                ; X = tens counter
:   cmp #10
    bcc :+                  ; If < 10, done dividing
    sbc #10                 ; Subtract 10 (carry already set from CMP)
    inx                     ; Increment tens
    jmp :-
:

; left digit stored in X, right digit stored in A
    pha         ; save right digit

    ; Draw left tile (TILE_NUM_MINUS_X)
    txa
    clc
    adc #TILE_NUM_MINUS_1
    sta VAR1

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda VAR1
    sta $2007

    ; Draw right tile (TILE_NUM_X)
    pla         ; restore right digit
    
    clc
    adc #TILE_NUM_0
    sta VAR1

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda VAR1
    sta $2007

positive_double:
    ; left tile = TILE_NUM_X
    ; right tile = TILE_NUM_X

    ; Check left digit by dividing by 10
    ldx #$00                ; X = tens counter
:   cmp #10
    bcc :+                  ; If < 10, done dividing
    sbc #10                 ; Subtract 10 (carry already set from CMP)
    inx                     ; Increment tens
    jmp :-
:

; left digit stored in X, right digit stored in A
    pha         ; save right digit

    ; Draw left tile (TILE_NUM_X)
    txa
    clc
    adc #TILE_NUM_0
    sta VAR1

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda VAR1
    sta $2007

    ; Draw right tile (TILE_NUM_X)
    pla         ; restore right digit

    clc
    adc #TILE_NUM_0
    sta VAR1

    lda $2002
    lda number_display_hi
    sta $2006
    lda number_display_lo
    sta $2006

    lda VAR1
    sta $2007



