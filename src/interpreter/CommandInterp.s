    ;ALL OF THESE EXPECT THEIR "argument" TO COME IN VAR0
    
    TileLocationsX:
        .byte TILE0_X, TILE1_X, TILE2_X, TILE3_X
        .byte TILE4_X, TILE5_X, TILE6_X, TILE7_X

    TileLocationsY:
        .byte TILE0_Y, TILE1_Y, TILE2_Y, TILE3_Y
        .byte TILE4_Y, TILE5_Y, TILE6_Y, TILE7_Y

SetTileDest:
    lda TileLocationsX,x ;set destination per tile
    sta DEDSTINATIONPLAYERX

    lda TileLocationsY,x ;set destination per tile
    sta DEDSTINATIONPLAYERY
    clc
RTS

InboxCommand:
    ; DON'T read from inbox yet - just set destination
    LDA #INBOX_X
    STA DEDSTINATIONPLAYERX
    STA player_target_x

    LDA #INBOX_Y
    STA DEDSTINATIONPLAYERY
    STA player_target_y
    
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
    LDY #$00
    lda (INBOXPTR),y

    CMP #$FF
    BEQ ReachedEnd_Logic   ; FF indicates end of list   
    STA HANDMEM

    ; Move pointer forward
    LDA INBOXPTR
    CLC
    ADC #$01
    STA INBOXPTR

    LDA INBOXPTR + 1       ; handle overflow
    ADC #$00
    STA INBOXPTR + 1
    
    ; *** REFRESH THE DISPLAY SLOTS AFTER PICKUP ***
    JSR refresh_inbox_display_slots
    
    ; *** MARK INBOX AS DIRTY SO NMI WILL REDRAW IT ***
    LDA #$01
    STA inbox_value_dirty
    
    CLC
RTS

ReachedEnd_Logic:
    ; Signal the player to stop by changing state
    lda #STATE_STOP
    sta player_state
    
    SEC
RTS

; Execute outbox logic AFTER player arrives
OutboxLogic:
    LDX SOLPTR
    CPX MAXSOLUTIONSIZE
    beq :+
        lda HANDMEM
        sta SOLUTION,x
    :

    inx
    stx SOLPTR

    ; CLEAR THE HAND AFTER OUTBOX
    LDA #$FF
    STA HANDMEM

    jsr play_sfx_put_down
    
    CLC
RTS

    CopyFromCommand:
        LDX VAR0
        LDA GAMEMMEM,x
        STA HANDMEM

        JMP SetTileDest

    CopyToCommand:
        LDX VAR0
        LDA HANDMEM
        STA GAMEMMEM,x

        JMP SetTileDest

    AddCommand:
        LDA HANDMEM
        LDX VAR0
        CLC
        ADC GAMEMMEM,x
        STA HANDMEM

        JMP SetTileDest

    SubCommand:
        LDA HANDMEM
        LDX VAR0
        SEC
        SBC GAMEMMEM,x
        STA HANDMEM

        JMP SetTileDest

    BumpUpCommand:
        LDX VAR0
        INC GAMEMMEM,x

        JMP SetTileDest

    BumpDownCommand:
        LDX VAR0
        DEC GAMEMMEM,x

        JMP SetTileDest

    JumpCommand:
        LDX #$00 ;loop through all instructions to find the matching label
        JumpCommLoop:
            LDA TestInstructions,x ;load instruction
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
            CMP TestVars,x ;and compare it to the actual label ID
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
    ; Reset idle timer so there's a delay before next command
        lda #IDLE_TIME
        sta player_idle_timer
        CLC
    RTS