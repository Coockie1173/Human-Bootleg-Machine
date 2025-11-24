; I need current command from command_selector
;.include "command_selector.s"

; Initialize position of the top of the list > placeholder tile
init_command_list:
    ; Calculate PPU address for row 24, col 3
    ; Address = $2000 + (3 * 32) + 24 = $2000 + 96 + 24 = 2000 + 78 = 2078
    lda #$20
    sta placeholder_position_hi
    lda #$78
    sta placeholder_position
    
    jsr draw_placeholder
    rts
; Initialize position of the command tiles = initial position of placeholder tile
; Check controller state > is select pressed?
; No > Draw placeholder tile
draw_placeholder:
    lda $2002
    lda placeholder_position_hi
    sta $2006
    lda placeholder_position
    sta $2006
    lda #TILE_PLACEHOLDER
    sta $2007
    rts

; Yes > Draw command tiles > increment Y position of placeholder tile > new command = current pos placeholder
