.include "CommandInterp.s"

CommandJumpTable:
    .dbyt InboxCommand - 1, OutboxCommand - 1, CopyFromCommand - 1, CopyToCommand - 1, AddCommand - 1
    .dbyt SubCommand - 1, BumpUpCommand - 1, BumpDownCommand - 1, JumpCommand - 1, JumpZeroCommand - 1, JumpNegativeCommand - 1
    .dbyt LabelCommand - 1

TestInstructions:
.byte CMD_LABEL,CMD_INBOX,CMD_COPYTO,CMD_BUMPUP,CMD_COPYFROM,CMD_OUTBOX,CMD_JUMP,$FF
TestVars:
.byte $01,$00,$03,$03,$03,$00,$01

;set INTERPTR to 0 to jump to the start of the interpreter
;assumes INTERPTR is the position within the solution, will increment during runtime
;if CARRY is set, we have reached the end of our list
ParseInstruction:
    ldx INTERPTR ;load our cursor within the solution
    ;store var first so we don't need to access X again later
    ;lda VARIABLES,x ;load in the command's var
    lda TestVars,x
    sta VAR0 ;store it in 0 for access later

    ;lda COMMANDS,x ;load the command in the list
    lda TestInstructions,x
    cmp #$FF ;end of list?
    bne :+
        SEC
        RTS ;tell the program and leave the list
    :

    inx ;increase pointer
    stx INTERPTR

    ASL ;adjust for 16 bits to index the CommandJumpTable
    TAX ;move it to X so we can index with it later

    lda CommandJumpTable,x ;now we build a trampoline by pushing the address of the correct command onto the stack
    PHA ;this effectively works as a jump rather than a return now
    lda CommandJumpTable+1,x ;no need to increase X if we can just increase the raw addr
    PHA
    RTS