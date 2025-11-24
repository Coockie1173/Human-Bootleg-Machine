; Command list management
; Displays a placeholder and allows adding commands with SELECT button

; Initialize position of the top of the list > placeholder tile
init_command_list:
    lda #$03
    sta placeholder_row
    lda #24
    sta placeholder_col
    
    ; Clear the command count
    lda #$00
    sta command_list_count
    
    jsr calc_placeholder_address
    jsr draw_placeholder
    rts

; Check controller state > is SELECT pressed?
handle_selected_command:
    ; Check SELECT button
    lda controller_state
    and #%00100000          ; SELECT is bit 5
    beq @done               ; If not pressed, exit
    
    ; Check if it was already pressed last frame
    lda previous_controller
    and #%00100000
    bne @done               ; If already pressed, don't repeat
    
    ; Check if we've hit the max number of commands (22 - 3 = 19 rows available)
    lda command_list_count
    cmp #19
    bcs @done               ; If at max, don't add more
    
    ; Erase the placeholder from current position
    jsr erase_placeholder
    
    ; Draw the selected command at current position
    jsr draw_selected_command
    
    ; Increment row for next command/placeholder
    inc placeholder_row
    inc command_list_count
    
    ; Calculate new placeholder address
    jsr calc_placeholder_address
    
    ; Draw placeholder at new position
    jsr draw_placeholder
    
@done:
    rts

; Erase placeholder (draw background tile)
erase_placeholder:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #$03                ; Brown background tile
    sta $2007
    rts

; Draw placeholder tile
draw_placeholder:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_PLACEHOLDER
    sta $2007
    rts

; Draw the currently selected command at placeholder position
draw_selected_command:
    lda current_command
    cmp #CMD_ADD
    bne @try_sub
    jsr draw_selected_add
    rts

@try_sub:
    cmp #CMD_SUB
    bne @try_copyto
    jsr draw_selected_sub
    rts

@try_copyto:
    cmp #CMD_COPYTO
    bne @try_copyfrom
    jsr draw_selected_copyto
    rts

@try_copyfrom:
    cmp #CMD_COPYFROM
    bne @try_jump
    jsr draw_selected_copyfrom
    rts

@try_jump:
    jsr draw_selected_jump
    rts

; Draw ADD (2 tiles)
draw_selected_add:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_ADD_1
    sta $2007
    lda #TILE_ADD_2
    sta $2007
    rts

; Draw SUB (2 tiles)
draw_selected_sub:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_SUB_1
    sta $2007
    lda #TILE_SUB_2
    sta $2007
    rts

; Draw COPYTO (3 tiles)
draw_selected_copyto:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_COPYTO_1
    sta $2007
    lda #TILE_COPYTO_2
    sta $2007
    lda #TILE_COPYTO_3
    sta $2007
    rts

; Draw COPYFROM (4 tiles)
draw_selected_copyfrom:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_COPYFROM_1
    sta $2007
    lda #TILE_COPYFROM_2
    sta $2007
    lda #TILE_COPYFROM_3
    sta $2007
    lda #TILE_COPYFROM_4
    sta $2007
    rts

; Draw JUMP (2 tiles)
draw_selected_jump:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_JUMP_1
    sta $2007
    lda #TILE_JUMP_2
    sta $2007
    rts

; Calculate 16-bit PPU address for placeholder
calc_placeholder_address:
    lda #$20
    sta placeholder_position_hi
    lda #$00
    sta placeholder_position

    ldx placeholder_row
    beq add_placeholder_column

add_placeholder_row_loop:
    lda placeholder_position
    clc 
    adc #32
    sta placeholder_position
    lda placeholder_position_hi
    adc #$00
    sta placeholder_position_hi
    dex 
    bne add_placeholder_row_loop

add_placeholder_column:
    lda placeholder_position
    clc
    adc placeholder_col
    sta placeholder_position
    lda placeholder_position_hi
    adc #$00
    sta placeholder_position_hi
    rts