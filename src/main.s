.include "macros.s"
.include "memmap.s"
.include "commands.s"
.include "defines.s"
.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "interpreter/MainInterpreter.s"

main:
    ;jsr ParseInstruction

    ;jsr ReadJoy
    
    jmp main