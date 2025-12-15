    ;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0
    
    TileLocationsX:
        .byte TILE0_X, TILE1_X, TILE2_X, TILE3_X
        .byte TILE4_X, TILE5_X, TILE6_X, TILE7_X

    TileLocationsY:
        .byte TILE0_Y, TILE1_Y, TILE2_Y, TILE3_Y
        .byte TILE4_Y, TILE5_Y, TILE6_Y, TILE7_Y

SetTileDest:
    lda TileLocationsX,x    ; Set destination per tile
    sta DEDSTINATIONPLAYERX
    sta player_target_x

    lda TileLocationsY,x
    sta DEDSTINATIONPLAYERY
    sta player_target_y
    
    ; Store which tile we're going to
    stx pending_tile_index
    
    ; FORCE player into walking state
    lda #STATE_WALKING
    sta player_state
    
    ; Reset animation   
    lda #$00
    sta player_anim_frame
    lda #ANIM_SPEED
    sta player_anim_timer
    lda #PLAYER_SPEED
    sta player_move_timer
    
    ; Set facing direction
    jsr set_facing_direction
    
    clc
    rts

InboxCommand:
    ; DON'T read from inbox yet - just set destination
    LDA #INBOX_X
    STA DEDSTINATIONPLAYERX
    STA player_target_x

    LDA #INBOX_Y
    STA DEDSTINATIONPLAYERY
    STA player_target_y
    
    ; Mark that we need to do inbox operation on arrival
    lda #OP_NONE            ; Inbox handled specially
    sta pending_operation
    

    ; FORCE player into walking state
    LDA #STATE_WALKING
    STA player_state
    
    ; Reset animation
    LDA #$00
    STA player_anim_frame
    LDA #ANIM_SPEED
    STA player_anim_timer
    LDA #PLAYER_SPEED
    STA player_move_timer
    
    ; Set facing direction
    JSR set_facing_direction
    
    CLC
    RTS

OutboxCommand:
    ; DON'T write to outbox yet - just set destination
    LDA #OUTBOX_X
    STA DEDSTINATIONPLAYERX
    STA player_target_x
    
    LDA #OUTBOX_Y
    STA DEDSTINATIONPLAYERY
    STA player_target_y

    ; Mark that we need to do outbox operation on arrival
    lda #OP_NONE            ; Outbox handled specially
    sta pending_operation
    
    ; FORCE player into walking state
    LDA #STATE_WALKING
    STA player_state
    
    ; Reset animation
    LDA #$00
    STA player_anim_frame
    LDA #ANIM_SPEED
    STA player_anim_timer
    LDA #PLAYER_SPEED
    STA player_move_timer
    
    ; Set facing direction
    JSR set_facing_direction
    
    CLC
    RTS

; Execute inbox logic AFTER player arrives
InboxLogic:
    ldy #$00
    lda (INBOXPTR),y

    cmp #$FF
    beq ReachedEnd_Logic    ; FF indicates end of list   
    sta HANDMEM

    jsr play_sfx_pick_up

    ; Move pointer forward
    lda INBOXPTR
    clc
    adc #$01
    sta INBOXPTR

    lda INBOXPTR + 1        ; Handle overflow
    adc #$00
    sta INBOXPTR + 1
    
    ; Refresh the display slots after pickup
    jsr refresh_inbox_display_slots
    
    ; Mark inbox and hand as dirty so NMI will redraw them
    lda #$01
    sta inbox_value_dirty
    sta hand_value_dirty
    
    ; Clear pending operation
    lda #OP_NONE
    sta pending_operation
    
    clc
    rts


ReachedEnd_Logic:
     ; Signal the player to stop
    lda #STATE_STOP
    sta player_state

    ; Prevent move_toward_target from immediately overwriting state
    lda #$FF
    sta player_target_x
    lda #$FF
    sta player_target_y

    sec
    rts

; Execute outbox logic AFTER player arrives
OutboxLogic:
    ldx SOLPTR
    cpx MAXSOLUTIONSIZE
    beq :+
        lda HANDMEM
        sta SOLUTION,x
    :

    inx
    stx SOLPTR

    ; CLEAR THE HAND AFTER OUTBOX
    lda #$FF
    sta HANDMEM

    jsr play_sfx_put_down
    
    ; Mark hand as dirty
    lda #$01
    sta hand_value_dirty
    
    ; Clear pending operation
    lda #OP_NONE
    sta pending_operation
    
    clc
    rts

    CopyFromCommand:
        ldx VAR0
    
        ; Mark operation type
        lda #OP_COPYFROM
        sta pending_operation
    
        jmp SetTileDest

    CopyToCommand:
        ldx VAR0
    
        ; Mark operation type
        lda #OP_COPYTO
        sta pending_operation
    
        jmp SetTileDest

    AddCommand:
        ldx VAR0
    
        ; Mark operation type
        lda #OP_ADD
        sta pending_operation
    
        jmp SetTileDest

    SubCommand:
        ldx VAR0
    
        ; Mark operation type
        lda #OP_SUB
        sta pending_operation
    
        jmp SetTileDest


    BumpUpCommand:
        ldx VAR0
    
        ; Mark operation type
        lda #OP_BUMPUP
        sta pending_operation
    
        jmp SetTileDest

    BumpDownCommand:
        ldx VAR0
    
        ; Mark operation type
        lda #OP_BUMPDOWN
        sta pending_operation
    
        jmp SetTileDest

    JumpCommand:
        LDX #$00 ;loop through all instructions to find the matching label
        JumpCommLoop:
            LDA COMMANDS,x ;load instruction
            CMP #CMD_LABEL ;check if the instr is a label
            BEQ :++
                CMP #$FF
                BNE :+
                    SEC ;no attached label found, return prematurely
                    RTS
                :
                INX ;not a label, continue
                JMP JumpCommLoop
            :
            LDA VAR0 ;load in label ID from the jump
            CMP VARIABLES,x ;and compare it to the actual label ID
            BEQ :+
                INX
                BNE JumpCommLoop ;not the correct label? go back and try again
        :
        STX INTERPTR ;if we finally find the label in the list, set X and return
        CLC
    RTS

    JumpZeroCommand:
        LDA HANDMEM
        BNE :+
            JMP JumpCommand
        :
        CLC
    RTS

    JumpNegativeCommand:
        LDA HANDMEM
        BMI :+
            JMP JumpCommand
        :
        CLC
    RTS
    LabelCommand:
    ; Check if this is the last command (end of interpreter)
    ldx INTERPTR
    inx                     ; Check next position
    lda COMMANDS,x
    cmp #$FF               ; Is next command the terminator?
    bne @not_end
    
    ; This label is at the end - LOSS CONDITION
    ; Signal the player to stop
    lda #STATE_STOP
    sta player_state
    
    ; Prevent move_toward_target from overwriting state
    lda #$FF
    sta player_target_x
    sta player_target_y
    
    ; Set carry to indicate failure (like ReachedEnd_Logic)
    sec
    rts
    
@not_end:
    ; Reset idle timer so there's a delay before next command
    lda #IDLE_TIME
    sta player_idle_timer
    clc
    rts
    execute_pending_tile_operation:
    lda pending_operation
    
    cmp #OP_COPYFROM
    beq @do_copyfrom
    cmp #OP_COPYTO
    beq @do_copyto
    cmp #OP_ADD
    beq @do_add
    cmp #OP_SUB
    beq @do_sub
    cmp #OP_BUMPUP
    beq @do_bumpup
    cmp #OP_BUMPDOWN
    beq @jump_bumpdown
    
    ; No operation or already handled
    rts



@do_copyfrom:
    ldx pending_tile_index
    lda GAMEMMEM,x
    sta HANDMEM
    
    jsr play_sfx_pick_up
    
    ; Mark hand as dirty
    lda #$01
    sta hand_value_dirty
    
    ; Clear operation
    lda #OP_NONE
    sta pending_operation
    rts

@do_copyto:
    ldx pending_tile_index
    lda HANDMEM
    sta GAMEMMEM,x
    
    jsr play_sfx_put_down
    
    ; Mark specific tile as dirty using bitmask
    lda #$01
    cpx #$00
    beq @copyto_set_dirty
@copyto_shift:
    asl
    dex
    bne @copyto_shift
@copyto_set_dirty:
    ora tile_values_dirty
    sta tile_values_dirty
    
    ; Clear operation
    lda #OP_NONE
    sta pending_operation
    rts

@do_add:
    lda HANDMEM
    ldx pending_tile_index
    clc
    adc GAMEMMEM,x
    sta HANDMEM
    
    jsr play_sfx_pick_up
    
    ; Mark hand as dirty
    lda #$01
    sta hand_value_dirty
    
    ; Clear operation
    lda #OP_NONE
    sta pending_operation
    rts

@jump_bumpdown:
    jmp @do_bumpdown

@do_sub:
    lda HANDMEM
    ldx pending_tile_index
    sec
    sbc GAMEMMEM,x
    sta HANDMEM
    
    jsr play_sfx_pick_up
    
    ; Mark hand as dirty
    lda #$01
    sta hand_value_dirty
    
    ; Clear operation
    lda #OP_NONE
    sta pending_operation
    rts

@do_bumpup:
    ldx pending_tile_index
    inc GAMEMMEM,x
    
    jsr play_sfx_pick_up
    
    ; Mark specific tile as dirty using bitmask
    lda #$01
    cpx #$00
    beq @bumpup_set_dirty
@bumpup_shift:
    asl
    dex
    bne @bumpup_shift
@bumpup_set_dirty:
    ora tile_values_dirty
    sta tile_values_dirty
    
    ; Clear operation
    lda #OP_NONE
    sta pending_operation
    rts

@do_bumpdown:
    ldx pending_tile_index
    dec GAMEMMEM,x
    
    jsr play_sfx_pick_up
    
    ; Mark specific tile as dirty using bitmask
    lda #$01
    cpx #$00
    beq @bumpdown_set_dirty
@bumpdown_shift:
    asl
    dex
    bne @bumpdown_shift
@bumpdown_set_dirty:
    ora tile_values_dirty
    sta tile_values_dirty
    
    ; Clear operation
    lda #OP_NONE
    sta pending_operation
    rts