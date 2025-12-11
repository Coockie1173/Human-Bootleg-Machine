; level.s - Level initialization

InitTestLevel:
    LDA #<TestPuzzle        ; Low byte of TestPuzzle address
    STA INBOXPTR
    LDA #>TestPuzzle        ; High byte of TestPuzzle address
    STA INBOXPTR+1
    
    ; DEBUG: Check what we're actually pointing at
    LDY #$00
    LDA (INBOXPTR), y    ; Should be $00
    STA $0500            ; Store for inspection
    
    LDY #$01
    LDA (INBOXPTR), y    ; Should be $01
    STA $0501
    
    LDY #$02
    LDA (INBOXPTR), y    ; Should be $02
    STA $0502

    ; Reset other pointers
    LDA #$00
    STA SOLPTR
    STA INTERPTR

    ; Load inbox display slots with first 4 values
    JSR refresh_inbox_display_slots
    
    ; Initialize the display system (marks everything dirty)
    JSR init_number_displays
    
    ; Update to detect what changed (redundant but safe)
    JSR update_number_displays
    
    RTS

refresh_inbox_display_slots:
    LDY #$00
    LDX #$00
    
    ; Check if inbox is empty (first value is FF)
    LDA (INBOXPTR),y
    CMP #$FF
    BEQ @inbox_empty

@loop:
    CPX #$04            ; Check if we've filled all 4 slots
    BEQ @done
    
    LDA (INBOXPTR),y
    
    CMP #$FF
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
    CPX #$04
    BCS @done
    
    LDA #$FF
    STA INBOX_SLOT_1,x
    INX
    JMP @fill_rest

@inbox_empty:
    ; Inbox is completely empty - fill all 4 slots with FF
    LDX #$00
@empty_loop:
    LDA #$FF
    STA INBOX_SLOT_1,x
    INX
    CPX #$04
    BCC @empty_loop

@done:
    RTS