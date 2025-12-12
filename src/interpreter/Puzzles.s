TestPuzzle: ;testing purposes
.byte $00,$01,$02,$03,$04,$FF
TestPuzzle2:
.byte $05,$0A,$05,$10,$15,$FF
TestPuzzle3:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF

TestSolution:
.byte $00,$02,$04,$06,$08
TestSolution2:
.byte $0A,$14,$0A,$20,$2A
TestSolution3:
.byte $00,$00,$98,$78,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

TestPuzzleList:
.dbyt TestPuzzle,TestPuzzle2,TestPuzzle3
TestSolutionList:
.dbyt TestSolution,TestSolution2,TestSolution3

TestPuzzleText:
STRBYTE "TAKE THE DATA FROM|THE INBOX|DOUBLE IT AND SEND IT|TO THE OUTBOX"

;we have a max of 255 puzzles
FullPuzzleList:
.dbyt TestPuzzleList
FullSolutionList:
.dbyt TestSolutionList
PuzzleTextPtrs:
.dbyt TestPuzzleText

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

; Check if player's solution matches expected solution
; Call with X = puzzle index
; Returns: Carry clear = correct, Carry set = wrong
CheckPlayerSolution:
    ; Get pointer to expected solution
    txa
    asl
    tax
    lda FullSolutionList,x
    sta CHECKSOLPTR
    lda FullSolutionList+1,x
    sta CHECKSOLPTR+1
    
    ; Compare player's solution to expected
    ldy #$00
@compare_loop:
    cpy MAXSOLUTIONSIZE
    beq @solution_correct    ; Reached end, all match
    
    ; Load expected value
    lda (CHECKSOLPTR),y
    cmp #$FF                 ; Check if we've reached end of expected solution
    beq @check_player_end
    
    ; Compare with player's solution
    cmp SOLUTION,y
    bne @solution_wrong      ; Mismatch!
    
    iny
    jmp @compare_loop

@check_player_end:
    ; Expected solution ended - check if player also ended
    lda SOLUTION,y
    cmp #$FF
    beq @solution_correct
    ; Player has extra values - wrong!
    
@solution_wrong:
    sec                      ; Carry set = wrong
    rts

@solution_correct:
    clc                      ; Carry clear = correct
    rts