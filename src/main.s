.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "memmap.s"
.include "commands.s"
.include "interpreter/interpreter.s"

main:
    LDA #$ff
    STA VAR0
    jmp main