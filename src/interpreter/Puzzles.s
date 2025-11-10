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
    LDY #$03
    LDA #$00
    STA VAR3

: 
    PHY
    PHX
    LDA FullPuzzleList,x ;grab pointer to puzzlelist from the full list
    STA VAR1
    INX
    LDA FullPuzzleList,x
    STA VAR0

    LDY VAR3
    LDA (VAR0),y ;setup inbox pointer
    STA INBOXPTR+1
    INY
    LDA (VAR0),y
    STA INBOXPTR

    PLX
    LDA FullSolutionList,x ;grab pointer to solution from the full list
    STA VAR1 
    INX
    LDA FullSolutionList,x
    STA VAR0

    LDY VAR3
    LDA (VAR0),y ;setup solution pointer
    STA CHECKSOLPTR+1
    INY
    LDA (VAR0),y
    STA CHECKSOLPTR

    INY 
    STY VAR3

    LDA #$00
    STA INTERPTR
    STA SOLPTR

:
    JSR ParseInstruction ;parse all instructions
    BCC :-

    PLY
    DEY
    CPY #$00
    BNE :--
RTS