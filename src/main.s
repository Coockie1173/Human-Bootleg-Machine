.include "macros.s"
.include "memmap.s"
.include "commands.s"
.include "defines.s"
.include "./boot/boot.s"
.include "nmi.s"
.include "controller/inputs.s"
.include "interpreter/MainInterpreter.s"
.include "interpreter/Puzzles.s"

;TODO: ADD LOAD LEVEL THING

main:
    ;LDX #$00
    ;jsr CheckAllSolutions
    jmp main