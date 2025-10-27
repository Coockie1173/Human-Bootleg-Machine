.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "memmap.s"

main:
    LDA #$01
    STA SCRATCH0
    jmp main