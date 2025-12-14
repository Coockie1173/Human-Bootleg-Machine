.include "gfx/sound_toggle.s"

; MENU ARROW MOVEMENT
CheckMainmenuArrow:
    lda controller_state
    and #%00000100          ; Check DOWN
    beq @check_up
    lda previous_controller
    and #%00000100
    bne @check_up

    lda MMarrow_row
    cmp #MENU_SOUND_ROW     ; max row 19 (SOUND option)
    bcs @check_up

    lda MMarrow_row
    clc
    adc #2                  ; Move down 2 rows (skip blank line)
    sta MMarrow_row
    inc MMarrow_update      ; Set flag to update visuals
    jmp @check_up

@check_up:
    lda controller_state
    and #%00001000          ; Check UP
    beq @movement_done
    lda previous_controller
    and #%00001000
    bne @movement_done

    lda MMarrow_row
    cmp #MENU_START_ROW     ; min row 13 (START option)
    beq @movement_done      ; If at 13, can't go up
    bcc @movement_done      ; If < 13, can't go up

    sec
    sbc #2                  ; Move up 2 rows
    sta MMarrow_row
    inc MMarrow_update      ; Set flag to update visuals

@movement_done:
    rts

; MENU SELECTION HANDLER
CheckMenuStart:
    ; Check if SELECT button is pressed
    lda controller_state
    and #%00100000          ; SELECT button mask
    beq @not_pressed
    
    ; Check if it wasn't pressed before (edge detection)
    lda previous_controller
    and #%00100000
    bne @not_pressed        ; If it was already pressed, ignore

    ; SELECT was just pressed - check which menu option is selected
    lda MMarrow_row
    cmp #MENU_START_ROW
    beq @handle_start
    cmp #MENU_CONTROLS_ROW
    beq @handle_controls
    cmp #MENU_LEVELS_ROW
    beq @handle_levels
    cmp #MENU_SOUND_ROW
    beq @handle_sound
    
    ; If none match, ignore
    jmp @not_pressed

@handle_start:
    jsr menu_select_start
    jmp @not_pressed

@handle_controls:
    jsr menu_select_controls
    jmp @not_pressed

@handle_levels:
    jsr menu_select_levels
    jmp @not_pressed

@handle_sound:
    jsr menu_select_sound
    jmp @not_pressed

@not_pressed:
    rts

; MENU OPTION: START GAME
menu_select_start:
    ; Play selection sound
    jsr play_sfx_select
    
    ; Set up the selected puzzle
    lda SELECTEDPUZZLE
    asl
    tax
    lda FullPuzzleList,x    ; Grab pointer to puzzlelist from the full list
    sta VAR1
    lda FullPuzzleList+1,x
    sta VAR0                ; Store the pointer in VAR0

    ldy VARF
    lda (VAR0),y            ; Setup inbox pointer
    sta INBOXPTR+1
    iny
    lda (VAR0),y
    sta INBOXPTR            ; Setup our inbox pointer for our interpreter

    lda PuzzleTextPtrs,x
    sta PUZZLETEXTPTR+1,x
    lda PuzzleTextPtrs+1,x
    sta PUZZLETEXTPTR,x

    ; Set game mode flag
    inc Gamemode
    
    rts

; MENU OPTION: CONTROLS
menu_select_controls:
    ; Play selection sound
    jsr play_sfx_select
    
    ; TODO: You'll need to implement these functions
    ; For now, just a placeholder that returns to menu
    
    ; Disable rendering
    lda #%00000000
    sta $2001
    lda #%00000000
    sta $2000
    
    ; Load controls screen background
    ; jsr load_background_controls
    
    ; Set a flag to indicate we're in controls mode
    ; lda #STATE_CONTROLS
    ; sta game_state
    
    ; Re-enable rendering
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    rts

; MENU OPTION: LEVELS
menu_select_levels:
    ; Play selection sound
    jsr play_sfx_select
    lda #STATE_CHANGE_LEVEL_SELECT
    sta game_state
    lda #$00
    sta PUZZLELIST_FINISHED
    
    ; TODO: You'll need to implement these functions
    ; For now, just a placeholder that returns to menu
    
    ; Disable rendering
    ;lda #%00000000
    ;sta $2001
    ;lda #%00000000
    ;sta $2000
    
    ; Load level select screen background
    ; jsr load_background_levels
    
    ; Set a flag to indicate we're in level select mode
    ; lda #STATE_LEVEL_SELECT
    ; sta game_state
    
    ; Re-enable rendering
    ;lda #%10000000
    ;sta $2000
    ;lda #%00011110
    ;sta $2001
    
    rts
