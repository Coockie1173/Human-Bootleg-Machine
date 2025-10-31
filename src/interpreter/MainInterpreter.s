.include "CommandInterp.s"

CommandJumpTable:
    .dbyt InboxCommand, OutboxCommand, CopyFromCommand, CopyToCommand, AddCommand
    .dbyt SubCommand, BumpUpCommand, BumpDownCommand, JumpCommand, JumpZeroCommand, JumpNegativeCommand

TestInstructions:
.byte $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0A
TestVars:
.byte $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05

;set INTERPTR to 0 to jump to the start of the interpreter
;assumes INTERPTR is the position within the solution, will increment during runtime
ParseInstruction:
    LDX INTERPTR ;load our cursor within the solution
    ;store var first so we don't need to access X again later
    ;LDA VARIABLES,x ;load in the command's var
    LDA TestVars,x
    STA VAR0 ;store it in 0 for access later

    ;LDA COMMANDS,x ;load the command in the list
    LDA TestInstructions,x
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
    SEC
    SBC #$01
    PHA
    RTS