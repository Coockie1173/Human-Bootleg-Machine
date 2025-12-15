;reset/pre-boot code
;this sets everything required up PPU wise and sets the program up to work

.include "../gfx/main_menu.s"


reset:
  sei		; disable IRQs
  cld		; disable decimal mode
  ldx #$40
  stx $4017	; disable APU frame IRQ
  ldx #$ff 	; Set up stack
  txs		;  .
  inx		; now X = 0
  stx $2000	; disable NMI
  stx $2001 	; disable rendering
  stx $4010 	; disable DMC IRQs

  ;; first wait for vblank to make sure PPU is ready
  vblankwait1:
    bit $2002
    bpl vblankwait1

  clear_memory:
    lda #$00
    sta $0000, x
    sta $0100, x
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx
    bne clear_memory

    ldx #$00        ; reset X
clear_cartram:
    lda #$00
    sta $6000, x
    sta $6100, x
    sta $6200, x
    sta $6300, x
    sta $6400, x
    sta $6500, x
    sta $6600, x
    sta $6700, x
    sta $6800, x
    sta $6900, x
    sta $6A00, x
    sta $6B00, x
    sta $6C00, x
    sta $6D00, x
    sta $6E00, x
    sta $6F00, x
    sta $7000, x
    sta $7100, x
    sta $7200, x
    sta $7300, x
    sta $7400, x
    sta $7500, x
    sta $7600, x
    sta $7700, x
    sta $7800, x
    sta $7900, x
    sta $7A00, x
    sta $7B00, x
    sta $7C00, x
    sta $7D00, x
    sta $7E00, x
    sta $7F00, x
    inx
    bne clear_cartram

  ;; second wait for vblank, PPU is ready after this
  vblankwait2:
  bit $2002
  bpl vblankwait2

  lda #$01                ; Sound starts ON by default
  sta sound_enabled

  load_palettes:
    lda $2002
    lda #$3f
    sta $2006
    lda #$00
    sta $2006
    ldx #$00
  @loop:
    lda palettes, x
    sta $2007
    inx
    cpx #$20
    bne @loop

  ; Initialize background
  jsr load_background_menu
  
  ; Draw initial sound display
  jsr update_sound_display 

  ; Initialize arrow
  jsr init_MMarrow
  
  ; Initialize command selector
  ;jsr init_command_selector

  ; Initialize command list
  ;jsr init_command_list

  ; Initialize player
  ;jsr init_player

  ; Initalize APU
  jsr init_sound
  jsr init_sfx

  jsr play_song_menu

 ; Set initial game state to MENU
  lda #STATE_MENU
  sta game_state

  

  jsr ResetCommandList ;make sure command list is filled with NOTHING

  enable_rendering:
    lda #%10000000
    sta $2000
    lda #%00011110
    sta $2001
    
    jmp WaitForNMI