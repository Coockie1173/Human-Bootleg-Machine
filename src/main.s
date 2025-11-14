.include "macros.s"
.include "memmap.s"
.include "commands.s"
.include "defines.s"
.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "controller/CommandSelect.s"
.include "interpreter/MainInterpreter.s"

main:
    ;jsr ParseInstruction

    jsr HandleHorizontal
    
    jmp main