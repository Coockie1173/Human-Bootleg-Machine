; result_arrow.s - Arrow system for win/loss screens
; Separate from main menu to avoid conflicts
.include "win_Screen.s"

; result_arrow.s - Arrow system for win/loss screens
; Separate from main menu to avoid conflicts

; Initialize result screen arrow (call when entering win/loss screen)
init_result_arrow:
    ; Set initial position based on screen type
    lda game_state
    cmp #STATE_WIN
    beq @init_win
    
    ; Loss screen
    lda #LOSS_RETRY_ROW
    sta result_arrow_row
    jmp @setup_sprite
    
@init_win:
    lda #WIN_NEXT_ROW
    sta result_arrow_row

@setup_sprite:
    ; Calculate Y position (row * 8)
    lda result_arrow_row
    asl
    asl
    asl
    sta $0200       ; Sprite Y position
    
    lda #$6A        ; Arrow tile (same as main menu)
    sta $0201       ; Sprite tile
    
    lda #$00        ; No flip/palette
    sta $0202       ; Sprite attributes
    
    lda #$58        ; X position (adjust to match your layout)
    sta $0203       ; Sprite X position
    
    lda #$01
    sta result_arrow_update
    rts

; RESULT SCREEN ARROW MOVEMENT
CheckResultArrow:
    lda controller_state
    and #%00000100          ; Check DOWN
    beq @check_up
    lda previous_controller
    and #%00000100
    bne @check_up

    ; Determine max row based on screen type
    lda game_state
    cmp #STATE_WIN
    beq @win_check_max
    
    ; Loss screen
    lda result_arrow_row
    cmp #LOSS_MENU_ROW
    bcs @check_up
    lda #LOSS_MENU_ROW
    sta result_arrow_row
    jsr update_result_arrow_sprite
    jsr play_sfx_cursor
    jmp @check_up
    
@win_check_max:
    lda result_arrow_row
    cmp #WIN_MENU_ROW
    bcs @check_up
    lda #WIN_MENU_ROW
    sta result_arrow_row
    jsr update_result_arrow_sprite
    jsr play_sfx_cursor
    jmp @check_up

@check_up:
    lda controller_state
    and #%00001000          ; Check UP
    beq @movement_done
    lda previous_controller
    and #%00001000
    bne @movement_done

    ; Determine min row based on screen type
    lda game_state
    cmp #STATE_WIN
    beq @win_check_min
    
    ; Loss screen
    lda result_arrow_row
    cmp #LOSS_RETRY_ROW
    beq @movement_done
    bcc @movement_done
    lda #LOSS_RETRY_ROW
    sta result_arrow_row
    jsr update_result_arrow_sprite
    jsr play_sfx_cursor
    jmp @movement_done
    
@win_check_min:
    lda result_arrow_row
    cmp #WIN_NEXT_ROW
    beq @movement_done
    bcc @movement_done
    lda #WIN_NEXT_ROW
    sta result_arrow_row
    jsr update_result_arrow_sprite
    jsr play_sfx_cursor

@movement_done:
    rts

; Update arrow sprite position
update_result_arrow_sprite:
    ; Calculate Y position (row * 8)
    lda result_arrow_row
    asl
    asl
    asl
    sta $0200       ; Update sprite Y position
    rts

; RESULT SCREEN SELECTION HANDLER
CheckResultSelect:
    ; Check if SELECT button is pressed
    lda controller_state
    and #%00100000          ; SELECT button mask
    beq @not_pressed
    
    ; Check if it wasn't pressed before (edge detection)
    lda previous_controller
    and #%00100000
    bne @not_pressed

    ; SELECT was just pressed - check which screen and option
    lda game_state
    cmp #STATE_WIN
    beq @handle_win_screen
    
    ; Loss screen
    lda result_arrow_row
    cmp #LOSS_RETRY_ROW
    beq @handle_retry
    cmp #LOSS_MENU_ROW
    beq @handle_menu
    jmp @not_pressed
    
@handle_win_screen:
    lda result_arrow_row
    cmp #WIN_NEXT_ROW
    beq @handle_next
    cmp #WIN_MENU_ROW
    beq @handle_menu
    jmp @not_pressed

@handle_next:
    jsr result_select_next
    jmp @not_pressed

@handle_retry:
    jsr result_select_retry
    jmp @not_pressed

@handle_menu:
    jsr result_select_menu
    jmp @not_pressed

@not_pressed:
    rts

; RESULT OPTION: NEXT LEVEL
result_select_next:
    jsr play_sfx_select
    
    ; Hide result arrow sprite
    jsr hide_result_arrow
    
    ; Increment to next puzzle
    inc SELECTEDPUZZLE
    
    ; TODO: Add check for max puzzles
    ; lda SELECTEDPUZZLE
    ; cmp #MAX_PUZZLE_COUNT
    ; bcs @all_complete
    
    ; Reset and load next level
    jsr reset_level_state
    
    ; Wait for vblank
    jsr wait_for_vblank
    lda #%00000000
    sta $2001
    lda #%00000000
    sta $2000
    
    jsr load_background    ; Load game screen
    
    lda #STATE_GAME
    sta game_state
    
    ; Re-enable rendering
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    rts

; RESULT OPTION: RETRY LEVEL
result_select_retry:
    jsr play_sfx_select
    
    ; Hide result arrow sprite
    jsr hide_result_arrow
    
    ; Reset and reload current level
    jsr reset_level_state
    
    ; Wait for vblank
    jsr wait_for_vblank
    lda #%00000000
    sta $2001
    lda #%00000000
    sta $2000
    
    jsr load_background    ; Load game screen
    
    lda #STATE_GAME
    sta game_state
    
    ; Re-enable rendering
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    rts

; RESULT OPTION: MAIN MENU
result_select_menu:
    jsr play_sfx_select
    
    ; Hide result arrow sprite
    jsr hide_result_arrow
    
    ; Wait for vblank
    jsr wait_for_vblank
    lda #%00000000
    sta $2001
    lda #%00000000
    sta $2000
    
    ; Return to main menu
    lda #STATE_MENU
    sta game_state
    
    ; Reset menu arrow
    lda #MENU_START_ROW
    sta MMarrow_row
    
    jsr load_background_menu
    jsr init_MMarrow
    
    ; Re-enable rendering
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    rts

; Hide the result arrow sprite
hide_result_arrow:
    lda #$FF        ; Y = $FF means off-screen
    sta $0200       ; Hide the arrow sprite
    rts

; Reset level state for retry or next level
reset_level_state:
    ; Reset interpreter
    lda #$00
    sta INTERPTR
    sta SOLPTR
    sta command_list_count
    sta CURSORSTATE
    sta START_INTERPRETER
    
    ; Reset player
    lda #STATE_IDLE
    sta player_state
    lda #$00
    sta player_idle_timer
    
    ; Clear hand
    lda #$FF
    sta HANDMEM
    
    ; Clear game memory tiles
    ldx #$00
    lda #$00
@clear_tiles:
    sta GAMEMMEM,x
    inx
    cpx #$08
    bcc @clear_tiles
    
    ; Clear solution
    ldx #$00
    lda #$FF
@clear_solution:
    sta SOLUTION,x
    inx
    cpx MAXSOLUTIONSIZE
    bcc @clear_solution
    
    ; Reload puzzle inbox pointer
    lda SELECTEDPUZZLE
    asl
    tax
    lda FullPuzzleList,x
    sta VAR1
    lda FullPuzzleList+1,x
    sta VAR0
    
    ldy #$00
    lda (VAR0),y
    sta INBOXPTR+1
    iny
    lda (VAR0),y
    sta INBOXPTR
    
    ; Refresh inbox display
    jsr refresh_inbox_display_slots
    jsr init_number_displays
    
    ; Re-initialize all game sprites
    jsr init_arrow
    jsr init_command_selector
    jsr init_command_list
    jsr init_player
    
    rts