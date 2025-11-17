.include "macros.s"
.include "memmap.s"
.include "commands.s"
.include "defines.s"
.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "controller/CommandSelect.s"
.include "interpreter/MainInterpreter.s"

WaitForNMI:
    LDA NMIFLAG
    BEQ WaitForNMI
    LDA #$00
    STA NMIFLAG
    jmp main

main:
    ;jsr ParseInstruction

    jsr HandleInputs
    
    jmp WaitForNMI