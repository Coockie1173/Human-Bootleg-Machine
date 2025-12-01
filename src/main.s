.include "macros.s"
.include "memmap.s"
.include "commands.s"
.include "defines.s"
.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "interpreter/MainInterpreter.s"
.include "interpreter/Puzzles.s"
.include "interpreter/ListGenerator.s"

;TODO: CMD_ADD LOAD LEVEL THING

WaitForNMI:
    LDA NMIFLAG
    BEQ WaitForNMI
    LDA #$00
    STA NMIFLAG
    jmp main

main:
    LDX #$00
    ;jsr CheckAllSolutions
    ;jsr ParseInstruction

    jsr GenerateCommandList
    jmp WaitForNMI
