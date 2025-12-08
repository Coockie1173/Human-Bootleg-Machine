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
.include "controller/selectedmode.s"

WaitForNMI:
    LDA NMIFLAG
    BEQ WaitForNMI
    LDA #$00
    STA NMIFLAG
    jmp main

main:
    LDA Gamemode
    BEQ @MainMenu
        LDX #$00
        ;jsr CheckAllSolutions
        ;jsr ParseInstruction

        jsr update_player

        LDA CURSORSTATE
        BNE @SelectMode
            jsr GenerateCommandList
            jsr handle_command_selector
            jsr handle_cursor
        jmp WaitForNMI

    @SelectMode:
        jsr SelectUpDown

        jmp WaitForNMI
    @MainMenu:   

    jsr CheckMainmenuArrow
    jsr CheckMenuStart
    jmp WaitForNMI