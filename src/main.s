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
.include "interpreter/StartInterpreter.s"
.include "controller/cursor.s"
.include "controller/menu.s"
.include "controller/selector.s"
.include "player.s"
.include "controller/selectedmode.s"
.include "sound/engine.s"
.include "sound/songs.s"
.include "sound/sfx.s"
.include "sound/famistudio_ca65.s"

WaitForNMI:
    lda NMIFLAG
    beq WaitForNMI
    lda #$00
    sta NMIFLAG
    jmp main

main:
    jsr famistudio_update
    
    ; Check game state
    lda game_state
    cmp #STATE_MENU
    beq @MainMenu
    cmp #STATE_WIN
    beq @WinScreen
    cmp #STATE_LOSS
    beq @LossScreen
    cmp #STATE_LOADING
    beq @LoadingScreen
    
    ; STATE_GAME - normal gameplay
    lda START_INTERPRETER
    beq @CheckInputs
        jsr update_player
        jsr update_number_displays
        jmp WaitForNMI

    @CheckInputs:
        jsr CheckStartInterpreter
        lda CURSORSTATE
        bne @SelectMode
            jsr GenerateCommandList
            jsr handle_command_selector
            jsr handle_cursor
        jmp WaitForNMI

    @SelectMode:
        jsr SelectUpDown
        jsr SelectLeftRight
        jsr RemoveCommand
        jmp WaitForNMI

@MainMenu:   
    jsr CheckMainmenuArrow
    jsr CheckMenuStart
    jmp WaitForNMI

@LoadingScreen:
    ; No special main loop logic needed
    jmp WaitForNMI

@WinScreen:
    ; Check if we need to load the background (first frame only)
    lda result_arrow_update
    cmp #$01
    bne @WinScreenReady
    
    ; First frame - load background and clear sprites
    jsr wait_for_vblank
    lda #%00000000
    sta $2001
    lda #%00000000
    sta $2000
    
    ; Clear all sprites
    jsr clear_all_sprites
    
    jsr load_background_win
    
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    lda #$02  ; Mark as loaded
    sta result_arrow_update
    jmp WaitForNMI
    
@WinScreenReady:
    ; Background loaded, handle input
    jsr CheckResultArrow
    jsr CheckResultSelect
    jmp WaitForNMI

@LossScreen:
    ; Check if we need to load the background (first frame only)
    lda result_arrow_update
    cmp #$01
    bne @LossScreenReady
    
    ; First frame - load background and clear sprites
    jsr wait_for_vblank
    lda #%00000000
    sta $2001
    lda #%00000000
    sta $2000
    
    ; Clear all sprites
    jsr clear_all_sprites
    
    jsr load_background_win  ; TODO: create load_background_loss
    
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    lda #$02  ; Mark as loaded
    sta result_arrow_update
    jmp WaitForNMI
    
@LossScreenReady:
    ; Background loaded, handle input
    jsr CheckResultArrow
    jsr CheckResultSelect
    jmp WaitForNMI

; Wait for VBlank helper
wait_for_vblank:
    bit $2002
    bpl wait_for_vblank
    rts

; Clear all sprites (hide them off-screen)
clear_all_sprites:
    lda #$FF        ; Y position $FF = off screen
    ldx #$00
@clear_loop:
    sta $0200, x    ; Set Y position to $FF
    inx
    inx
    inx
    inx
    bne @clear_loop
    rts