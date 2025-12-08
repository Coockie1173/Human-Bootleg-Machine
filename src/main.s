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
.include "controller/cursor.s"
.include "controller/menu.s"
.include "controller/selector.s"
.include "player.s"

;TODO: CMD_ADD LOAD LEVEL THING

WaitForNMI:
    LDA NMIFLAG
    BEQ WaitForNMI
    LDA #$00
    STA NMIFLAG
    jmp main

main:
    LDA Gamemode
    BEQ :+
        LDX #$00
        ;jsr CheckAllSolutions
        ;jsr ParseInstruction

        jsr GenerateCommandList
        jsr handle_command_selector
        jsr handle_cursor
        jsr update_player
        jmp WaitForNMI
    :   

    jsr CheckMainmenuArrow
    jsr CheckMenuStart
    jmp WaitForNMI