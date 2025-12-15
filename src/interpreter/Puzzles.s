.include "./PuzzleData.s"

;X = current puzzle from full list
CheckAllSolutions:
    TXA
    ASL
    TAX
    LDY #$03 ;we have three "model" solutions to every puzzle - might get replaced in the future
    lda #$00
    sta VARF ;clear the internal list index

: 
    PHY ;don't lose Y
    PHX ;don't lose X
    lda FullPuzzleList,x ;grab pointer to puzzlelist from the full list
    sta VAR1
    inx
    lda FullPuzzleList,x
    sta VAR0 ;and store the pointer in VAR0 so we can access it later (below)

    LDY VARF
    lda (VAR0),y ;setup inbox pointer
    sta INBOXPTR+1
    INY
    lda (VAR0),y
    sta INBOXPTR ;setup our inbox pointer for our interpreter

    PLX
    lda FullSolutionList,x ;grab pointer to solution from the full list
    sta VAR1 
    inx
    lda FullSolutionList,x
    sta VAR0 

    LDY VARF
    lda (VAR0),y ;setup solution pointer
    sta CHECKSOLPTR+1
    INY
    lda (VAR0),y
    sta CHECKSOLPTR ;setup our solution pointer for our solution checker

    INY 
    STY VARF ;increase and store our "global index" - DO NOT FRY!!

    lda #$00
    sta INTERPTR ;and then reset our cursors
    sta SOLPTR

:
    jsr ParseInstruction ;parse all instructions until the inbox is empty or something else fails
    BCC :-

    ;now check if the solution the interpreter produced matches out solution pointer

    PLY ;get our counter back
    DEY ;decrement and check
    CPY #$00
    bne :-- ;if not 0, jump back and check the next solution
RTS


LoadExpectedSolution:
rts

;Y HAS A NUMBER BETWEEN 0 AND 2
LoadASolution:
    ; Get the address where TestSolution actually is in ROM
    PHY
    PHX
    lda SELECTEDPUZZLE
    asl
    tax

    lda FullSolutionList,x
    sta VAR1
    lda FullSolutionList+1,x
    sta VAR0

    tya
    asl
    tay

    lda (VAR0),y
    sta VAR3
    iny
    lda (VAR0),y ;setup secondary pointer
    sta VAR2

    ldy #$00
    @CopyLoop:
        lda (VAR2),y
        sta EXPECTED_SOLUTION,y
        cmp #$80
        beq @doneCopy
        iny
        jmp @CopyLoop
    @doneCopy:

    PLX
    PLY
    rts

; CheckPlayerSolution - Compare SOLUTION with EXPECTED_SOLUTION
; Input: X = SELECTEDPUZZLE index (not actually used since we already loaded expected)
; Output: Carry CLEAR = correct, Carry SET = wrong
;         Also sets solution_check_flag: 1 = correct, 2 = wrong
CheckPlayerSolution:
    ; Reset check flag
    lda #$00
    sta solution_check_flag
    
    ; Compare byte by byte
    ldy #$00
    
@compare_loop:
    ; Load expected solution byte
    lda EXPECTED_SOLUTION,y
    
    ; Check if we've reached the end of expected solution
    cmp #$80
    beq @check_player_end
    
    ; Compare with player solution
    cmp SOLUTION,y
    bne @solution_wrong     ; If different, solution is wrong
    
    ; Move to next byte
    iny
    cpy MAXSOLUTIONSIZE     ; Safety check
    bcc @compare_loop
    
    ; Reached max size without end marker - wrong
    jmp @solution_wrong

@check_player_end:
    ; Expected solution ended at position Y
    ; Check if player solution also ends here
    lda SOLUTION,y
    cmp #$FF
    beq @solution_correct   ; Both end at same point!
    
    ; Player has more values - wrong
    jmp @solution_wrong
    
@solution_correct:
    ; Store player solution length for debugging
    sty player_solution_length
    
    ; Set flag to CORRECT
    lda #$01
    sta solution_check_flag
    
    ; Return with carry CLEAR
    clc
    rts

@solution_wrong:
    ; Store player solution length for debugging (where it failed)
    sty player_solution_length
    
    ; Set flag to WRONG
    lda #$02
    sta solution_check_flag
    
    ; Return with carry SET
    sec
    rts