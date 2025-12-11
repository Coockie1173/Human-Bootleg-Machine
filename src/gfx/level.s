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

    JSR refresh_inbox_display_slots
    
    ; Initialize the display system
    JSR init_number_displays
    JSR update_number_displays


    ;JSR draw_pending_numbers
    RTS

refresh_inbox_display_slots:
    LDY #$00
    LDX #$00

@loop:
    LDA (INBOXPTR),y
    CMP #$FF
    BEQ @done           ; end of puzzle data

    ; Store in slot table
    STA INBOX_SLOT_1,x

    INX
    CPX #$04
    BEQ @done           ; max 4 items

    INY
    BNE @loop

@done:
    RTS
