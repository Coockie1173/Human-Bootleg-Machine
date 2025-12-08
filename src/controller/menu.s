CheckMainmenuArrow:
    lda controller_state
    and #%00000100
    beq @check_up
    lda previous_controller
    and #%00000100
    bne @check_up

    lda MMarrow_row
    cmp #$13         ; max row 19
    bcs @check_up

    lda MMarrow_row
    inc MMarrow_row
    inc MMarrow_row
    inc MMarrow_update ;set flag to update visuals

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

    dec MMarrow_row
    dec MMarrow_row
    inc MMarrow_update ;set flag to update visuals

@movement_done:
  rts


CheckMenuStart:
  lda MMarrow_row
  cmp #$0D          ; Row 13
  bne @not_pressed  ; If not at row 13, don't allow start
  
  lda MMarrow_column
  cmp #$0A          ; Column 10
  bne @not_pressed  ; If not at column 10, don't allow start
  
  ; Arrow is at START - now check if SELECT button is pressed
  lda controller_state
  and #%00100000    ; SELECT button mask
  beq @not_pressed
  
  ; Check if it wasn't pressed before (edge detection)
  lda previous_controller
  and #%00100000
  bne @not_pressed  ; If it was already pressed, ignore

  inc Gamemode

    ldx SELECTEDPUZZLE
    LDA FullPuzzleList,x ;grab pointer to puzzlelist from the full list
    STA VAR1
    INX
    LDA FullPuzzleList,x
    STA VAR0 ;and store the pointer in VAR0 so we can access it later (below)

    LDY VARF
    LDA (VAR0),y ;setup inbox pointer
    STA INBOXPTR+1
    INY
    LDA (VAR0),y
    STA INBOXPTR ;setup our inbox pointer for our interpreter

  @not_pressed:
rts