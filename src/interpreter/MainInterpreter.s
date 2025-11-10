.include "CommandInterp.s"

CommandJumpTable:
    .dbyt InboxCommand - 1, OutboxCommand - 1, CopyFromCommand - 1, CopyToCommand - 1, AddCommand - 1
    .dbyt SubCommand - 1, BumpUpCommand - 1, BumpDownCommand - 1, JumpCommand - 1, JumpZeroCommand - 1, JumpNegativeCommand - 1

TestInstructions:
.byte $00,$03,$06,$02,$01,$08,$FF
TestVars:
.byte $00,$01,$01,$01,$00,$00

;set INTERPTR to 0 to jump to the start of the interpreter
;assumes INTERPTR is the position within the solution, will increment during runtime
;if CARRY is set, we have reached the end of our list
ParseInstruction:
    LDX INTERPTR ;load our cursor within the solution
    ;store var first so we don't need to access X again later
    ;LDA VARIABLES,x ;load in the command's var
    LDA TestVars,x
    STA VAR0 ;store it in 0 for access later

    ;LDA COMMANDS,x ;load the command in the list
    LDA TestInstructions,x
    CMP #$FF ;end of list?
    BNE :+
        SEC
        RTS ;tell the program and leave the list
    :

    ASL ;adjust for 16 bits to index the CommandJumpTable
    TAX ;move it to X so we can index with it later

    ;now increment INTERPTR here so we don't need to waste space doing it later
    LDA INTERPTR
    CLC
    ADC #$01
    STA INTERPTR

    LDA CommandJumpTable,x ;now we build a trampoline by pushing the address of the correct command onto the stack
    PHA ;this effectively works as a jump rather than a return now
    LDA CommandJumpTable+1,x ;no need to increase X if we can just increase the raw addr
    PHA
    RTS