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
    TXA
    ASL
    TAX
    
    ; Get pointer to solution list
    lda FullSolutionList,x
    sta VAR1
    inx
    lda FullSolutionList,x
    sta VAR0
    
    ; Get first solution pointer (index 0)
    ldy #$00
    lda (VAR0),y
    sta CHECKSOLPTR
    iny
    lda (VAR0),y
    sta CHECKSOLPTR+1
    
    ; Compare player's solution to expected
    ldy #$00
@compare_loop:
    lda (CHECKSOLPTR),y
    cmp SOLUTION,y
    bne @solution_wrong
    
    ; Check if both ended
    cmp #$FF
    beq @solution_correct
    
    iny
    cpy MAXSOLUTIONSIZE
    bcc @compare_loop
    
@solution_correct:
    clc
    rts

@solution_wrong:
    sec
    rts

