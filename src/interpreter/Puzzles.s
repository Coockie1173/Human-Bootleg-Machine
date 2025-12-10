TestPuzzle: ;testing purposes
.byte $00,$01,$02,$03,$04,$FF
TestPuzzle2:
.byte $05,$0A,$05,$10,$15,$FF
TestPuzzle3:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FF

TestSolution:
.byte $01,$02,$03,$04,$05
TestSolution2:
.byte $06,$0B,$06,$11,$16
TestSolution3:
.byte $01,$01,$4D,$3D,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

TestPuzzleList:
.dbyt TestPuzzle,TestPuzzle2,TestPuzzle3
TestSolutionList:
.dbyt TestSolution,TestSolution2,TestSolution3

;we have a max of 255 puzzles
FullPuzzleList:
.dbyt TestPuzzleList
FullSolutionList:
.dbyt TestSolutionList

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