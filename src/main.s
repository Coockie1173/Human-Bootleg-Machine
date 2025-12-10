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

WaitForNMI:
    LDA NMIFLAG
    BEQ WaitForNMI
    LDA #$00
    STA NMIFLAG
    jmp main

main:
    LDA Gamemode
    BEQ :+
        ; Handle player MOVEMENT (physics) in main loop
        jsr update_player          ; ← This moves the player pixel by pixel
        
        ; Handle UI/input
        jsr GenerateCommandList
        jsr handle_command_selector
        jsr handle_cursor
        
        ; Update number displays for changes
        jsr update_number_displays
        
        jmp WaitForNMI
    :   
    jsr CheckMainmenuArrow
    jsr CheckMenuStart
    jmp WaitForNMI