InboxOutboxPuzzleInput: ;testing purposes
.byte $0A,$15,$01,$00,$F8,$80
InboxOutboxPuzzleInput2:
.byte $05,$0A,$05,$10,$15,$80
InboxOutboxPuzzleInput3:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80

InboxOutboxPuzzleSolution:
.byte $0A,$15,$01,$00,$FE,$80 ;80 because FF = -1
InboxOutboxPuzzleSolution2:
.byte $05,$0A,$05,$10,$15,$80
InboxOutboxPuzzleSolution3:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80

TestPuzzleList:
.dbyt InboxOutboxPuzzleInput,InboxOutboxPuzzleInput2,InboxOutboxPuzzleInput3
TestSolutionList:
.dbyt InboxOutboxPuzzleSolution,InboxOutboxPuzzleSolution2,InboxOutboxPuzzleSolution3

TestPuzzleText:
STRBYTE "TAKE THE DATA AND|SEND IT TO THE OUTBOX"

;we have a max of 255 puzzles
FullPuzzleList:
.dbyt TestPuzzleList
FullSolutionList:
.dbyt TestSolutionList
PuzzleTextPtrs:
.dbyt TestPuzzleText