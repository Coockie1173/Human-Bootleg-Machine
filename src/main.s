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
.include "sound/apu.s"
.include "sound/engine.s"

WaitForNMI:
    lda NMIFLAG
    beq WaitForNMI
    lda #$00
    sta NMIFLAG
    jmp main

main:
    lda Gamemode
    beq @MainMenu
        ldx #$00
        ;jsr CheckAllSolutions
        ;jsr ParseInstruction

        jsr update_player

        lda CURSORSTATE
        bne @SelectMode
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