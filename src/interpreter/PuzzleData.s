InboxOutboxPuzzleInput: ;testing purposes
.byte $0A,$15,$01,$00,$5A,$80
InboxOutboxPuzzleInput2:
.byte $05,$0A,$05,$10,$15,$80
InboxOutboxPuzzleInput3:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80

InboxOutboxPuzzleSolution:
.byte $0A,$15,$01,$00,$5A,$80 ;80 because FF = -1
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

OnlyZeroPuzzleInput:
.byte $0A,$00,$01,$00,$AA,$00,$80
OnlyZeroPuzzleInput2:
.byte $00,$00,$4C,$3C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80
OnlyZeroPuzzleInput3:
.byte $00,$01,$02,$03,$04,$05,$06,$80

OnlyZeroPuzzleOutput:
.byte $00,$00,$00,$80
OnlyZeroPuzzleOutput2:
.byte $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80
OnlyZeroPuzzleOutput3:
.byte $00,$80

OnlyZeroText:
STRBYTE "ONLY SEND ZEROS TO|THE OUTBOX"

OnlyZeroPuzzleList:
.dbyt InboxOutboxPuzzleInput,InboxOutboxPuzzleInput2,InboxOutboxPuzzleInput3
OnlyZeroPuzzleSolutionList:
.dbyt InboxOutboxPuzzleSolution,InboxOutboxPuzzleSolution2,InboxOutboxPuzzleSolution3

BiggerPuzzleInput:
.byte $0A, $02, $0C, $0C, $05, $02, $08, $04, $80
BiggerPuzzleInput2:
.byte $01, $02, $03, $04, $80

BiggerPuzzleOutput:
.byte $0A, $0C, $05, $08, $80
BiggerPuzzleOutput2:
.byte $02, $04, $80

BiggestOnlyText:
STRBYTE "FOR EVERY TWO ITEMS|SEND THE BIGGEST|TO THE OUTBOX"

BiggestOnlyList:
.dbyt BiggerPuzzleInput,BiggerPuzzleInput,BiggerPuzzleInput2
BiggestOnlySolutionList:
.dbyt BiggerPuzzleOutput,BiggerPuzzleOutput,BiggerPuzzleOutput2

RepeatInput:
.byte $05, $03, $02, $00, $80
RepeatInput2:
.byte $01, $02, $03, $80

RepeatOutput:
.byte $05,$05,$05,$05,$05,$03,$03,$03,$02,$02,$80
RepeatOutput2:
.byte $01, $02, $02, $03, $03, $03, $80

RepeatOnlyText:
STRBYTE "TAKE THE ITEM FROM|THE INBOX AND SEND IT|TO THE OUTBOX FOR THE|AMOUNT OF TIMES SHOWN"


RepeatList:
.dbyt RepeatInput,RepeatInput,RepeatInput2
RepeatSolutionList:
.dbyt RepeatOutput,RepeatOutput,RepeatOutput2

SmallestSeriesInput:
.byte $05,$03,$08,$00,$0A,$30,$02,$00,$80
SmallestSeriesInput2:
.byte $05,$06,$08,$00,$0A,$01,$02,$00,$80

SmallestSeriesOutput:
.byte $03,$02,$80
SmallestSeriesOutput2:
.byte $05,$01,$80

SmallestOnlyText:
STRBYTE "FOR THESE ZERO|TERMINATED STRINGS|SEND THE SMALLEST OF|EACH STRING TO OUTBOX"

SmallestList:
.dbyt SmallestSeriesInput,SmallestSeriesInput,SmallestSeriesInput2
SmallestSolutionList:
.dbyt SmallestSeriesOutput,SmallestSeriesOutput,SmallestSeriesOutput2

EqualizerInput:
.byte $05, $04, $0A, $0A, $03, $02, $02, $03, $05,$05,$80
EqualizerInput2:
.byte $05, $05, $0A, $0A, $03, $02, $02, $03, $05,$05,$80

EqualizerOutput:
.byte $0A, $05, $80
EqualizerOutput2:
.byte $05, $0A, $05, $80

EqualizerText:
STRBYTE "FOR EVERY TWO ITEMS|IF THEY ARE EQUAL|SEND ONE OF THE TWO|TO THE OUTBOX"

EqualizerList:
.dbyt EqualizerInput,EqualizerInput,EqualizerInput2
EqualizerSolutionList:
.dbyt EqualizerOutput,EqualizerOutput,EqualizerOutput2


;we have a max of 255 puzzles
FullPuzzleList:
.dbyt TestPuzzleList, OnlyZeroPuzzleList, RepeatList
FullSolutionList:
.dbyt TestSolutionList, OnlyZeroPuzzleSolutionList, RepeatSolutionList
PuzzleTextPtrs:
.dbyt TestPuzzleText, OnlyZeroText, RepeatOnlyText
