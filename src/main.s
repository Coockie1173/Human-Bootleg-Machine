.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "memmap.s"
.include "commands.s"

main:
    jmp main