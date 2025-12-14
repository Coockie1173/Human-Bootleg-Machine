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

GameModeMainList:
.dbyt gamemode_menu-1
.dbyt gamemode_loading-1
.dbyt gamemode_game-1
.dbyt gamemode_win-1
.dbyt gamemode_loss-1
.dbyt gamemode_controls-1
.dbyt gamemode_levelselect-1
.dbyt gamemode_loadselect-1


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
    asl
    tax
    lda GameModeMainList,x
    pha
    lda GameModeMainList+1,x
    pha
    rts
    
    ; STATE_GAME - normal gameplay
gamemode_game:
    lda START_INTERPRETER
    beq @CheckInputs
        jsr update_player
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

gamemode_menu:   
    jsr CheckMainmenuArrow
    jsr CheckMenuStart
    jmp WaitForNMI

gamemode_loading:
    ; No special main loop logic needed
    jmp WaitForNMI

gamemode_win:
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
    jsr famistudio_music_pause
    jsr play_sfx_victory
    jmp WaitForNMI
    
@WinScreenReady:
    ; Background loaded, handle input
    jsr CheckResultArrow
    jsr CheckResultSelect
    jmp WaitForNMI

gamemode_loss:
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
    
    jsr load_background_loss  ; 
    
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    lda #$02  ; Mark as loaded
    sta result_arrow_update
    jsr famistudio_music_pause
    jsr play_sfx_loose
    jmp WaitForNMI
    
@LossScreenReady:
    ; Background loaded, handle input
    jsr CheckResultArrow
    jsr CheckResultSelect
    jmp WaitForNMI

gamemode_controls:
    jsr check_controls_back
    jmp WaitForNMI

gamemode_levelselect:
    jmp WaitForNMI

gamemode_loadselect:
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
    