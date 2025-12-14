TestPuzzle: ;testing purposes
.byte $00,$01,$02,$03,$04,$FF
TestPuzzle2:
.byte $05,$0A,$05,$10,$15,$FF
TestPuzzle3:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF

TestSolution:
.byte $00,$02,$04,$06,$08,$FF 
TestSolution2:
.byte $0A,$14,$0A,$20,$2A,$FF 
TestSolution3:
.byte $00,$00,$98,$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF 

TestPuzzleList:
.dbyt TestPuzzle,TestPuzzle2,TestPuzzle3
TestSolutionList:
.dbyt TestSolution,TestSolution2,TestSolution3

TestPuzzleText:
STRBYTE "TAKE THE DATA FROM|THE INBOX|DOUBLE IT AND SEND IT|TO THE OUTBOX"
DebugTextRemove:
STRBYTE "UW KKR MOEDER"

;we have a max of 255 puzzles
FullPuzzleList:
.dbyt TestPuzzleList, TestPuzzleList
FullSolutionList:
.dbyt TestSolutionList, TestSolutionList
PuzzleTextPtrs:
.dbyt TestPuzzleText, DebugTextRemove

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
    ; Get the address where TestSolution actually is in ROM
    ldx SELECTEDPUZZLE
    cpx #$00
    bne @puzzle1
    
    ; Puzzle 0 - use TestSolution
    ldx #$00
@copy0:
    lda TestSolution,x
    sta EXPECTED_SOLUTION,x
    inx
    cmp #$FF            ; Check AFTER incrementing X
    bne @copy0
    jmp @done
    
@puzzle1:
    cpx #$01
    bne @puzzle2
    
    ; Puzzle 1 - use TestSolution2
    ldx #$00
@copy1:
    lda TestSolution2,x
    sta EXPECTED_SOLUTION,x
    inx
    cmp #$FF
    bne @copy1
    jmp @done
    
@puzzle2:
    ; Puzzle 2 - use TestSolution3
    ldx #$00
@copy2:
    lda TestSolution3,x
    sta EXPECTED_SOLUTION,x
    inx
    cmp #$FF
    bne @copy2
    jmp @done

@done:
    dex                 ; X is one past the FF
    stx solution_length
    rts

; CheckPlayerSolution - Compare SOLUTION with EXPECTED_SOLUTION
; Input: X = SELECTEDPUZZLE index
; Output: Carry CLEAR = correct, Carry SET = wrong
;         Also sets solution_check_flag: 1 = correct, 2 = wrong
CheckPlayerSolution:
    ; Reset check flag
    lda #$00
    sta solution_check_flag
    
    ; LOSS CONDITION 1: Check if inbox still has values (not at $FF)
    ldy #$00
    lda (INBOXPTR),y
    cmp #$FF
    bne @solution_wrong     ; Inbox not empty = LOSS
    
    ; LOSS CONDITION 2: Check if player solution is empty (first byte is $FF)
    lda SOLUTION
    cmp #$FF
    beq @solution_wrong     ; No output = LOSS
    
    ; Now do the actual comparison
    ldy #$00
    
@compare_loop:
    ; Load expected solution byte
    lda EXPECTED_SOLUTION,y
    
    ; Check if we've reached the end of expected solution
    cmp #$FF
    beq @check_player_end
    
    ; Compare with player solution
    cmp SOLUTION,y
    bne @solution_wrong     ; If different, solution is wrong
    
    ; Values match - continue to next byte
    iny
    cpy MAXSOLUTIONSIZE     ; Safety check
    bcc @compare_loop
    
    ; If we exit the loop naturally (hit max size), that's wrong
    jmp @solution_wrong

@check_player_end:
    ; Expected solution ended at position Y
    ; Check if player solution also ends here
    lda SOLUTION,y
    cmp #$FF
    bne @solution_wrong     ; Player has different length - wrong
    
    ; ALL CHECKS PASSED - FORCE CORRECT!
    jmp @solution_correct

@solution_correct:
    ; Store player solution length for debugging
    sty player_solution_length
    
    ; Set flag to CORRECT
    lda #$01
    sta solution_check_flag
    
    ; Return with carry CLEAR (correct)
    clc
    rts

@solution_wrong:
    ; Store player solution length for debugging (where it failed)
    sty player_solution_length
    
    ; Set flag to WRONG
    lda #$02
    sta solution_check_flag
    
    ; Return with carry SET (wrong)
    sec
    rts