InitTestLevel:
    lda SELECTEDPUZZLE
    asl
    tax

    lda FullPuzzleList,x
    sta VAR1
    lda FullPuzzleList+1,x
    sta VAR0

    lda #$00
    asl
    tay

    lda (VAR0),y
    sta INBOXPTR+1
    iny
    lda (VAR0),y ;setup secondary pointer
    sta INBOXPTR

    ; Reset other pointers
    LDA #$00
    STA SOLPTR
    STA INTERPTR

     ; Load expected solution
    ldx SELECTEDPUZZLE
    jsr LoadExpectedSolution
    
    ; Load inbox display slots with first 4 values
    JSR refresh_inbox_display_slots   ; ← KEEP THIS
    
    ; Initialize the display system (marks everything dirty)
    ; JSR init_number_displays          ; ← DELETE THIS LINE
    
    RTS

refresh_inbox_display_slots:
    ; ← KEEP THIS WHOLE FUNCTION - it's still needed!
    LDY #$00
    LDX #$00
    
    ; Check if inbox is empty (first value is FF)
    LDA (INBOXPTR),y
    CMP #$80
    BEQ @inbox_empty

@loop:
    CPX #$06            ; Check if we've filled all 6 slots
    BEQ @done
    
    LDA (INBOXPTR),y
    
    CMP #$80
    BEQ @found_end      ; If we hit FF, fill remaining slots with FF
    
    ; It's a valid number, store it
    STA INBOX_SLOT_1,x
    
    INX
    INY
    JMP @loop

@found_end:
    ; We hit the end marker (FF)
    ; Fill this slot and all remaining slots with FF
@fill_rest:
    CPX #$06
    BCS @done
    
    LDA #$80
    STA INBOX_SLOT_1,x
    INX
    JMP @fill_rest

@inbox_empty:
    ; Inbox is completely empty - fill all 4 slots with FF
    LDX #$00
@empty_loop:
    LDA #$80
    STA INBOX_SLOT_1,x
    INX
    CPX #$04
    BCC @empty_loop

@done:
    RTS