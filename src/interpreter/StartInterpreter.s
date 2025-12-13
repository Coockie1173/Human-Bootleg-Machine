CheckStartInterpreter:
    lda controller_state
    and #%00010000    ; START button mask (sorry rudy)
    beq @not_pressed
    
    ; Check if it wasn't pressed before (edge detection)
    lda previous_controller
    and #%00010000
    bne @not_pressed  ; If it was already pressed, ignore

     ; START was pressed - check if there are ANY commands
    lda command_list_count
    beq @no_commands        ; If count is 0, instant loss!
    
    ; Check if first command is $FF (empty list)
    lda COMMANDS
    cmp #$FF
    beq @no_commands        ; Empty list = instant loss!
    
    ; Commands exist - start interpreter
    lda #$01
    sta START_INTERPRETER
    jsr play_sfx_select
    rts
@no_commands:
    ; No commands - instant loss!
    jsr play_sfx_select
    
    ; Set to loss state immediately
    lda #STATE_LOSS
    sta game_state
    
    ; Initialize result arrow for loss screen
    jsr init_result_arrow
    
    ; Set flag to load background next frame
    lda #$01
    sta result_arrow_update
    rts

@not_pressed:
    rts
