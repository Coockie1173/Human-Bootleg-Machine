.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "memmap.s"
.include "commands.s"

main:
    LDA #$ff
    STA VAR0
    jmp main