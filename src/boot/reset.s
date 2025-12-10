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

  ;; second wait for vblank, PPU is ready after this
  vblankwait2:
  bit $2002
  bpl vblankwait2

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

  ; Initialize arrow
  jsr init_MMarrow
  
  ; Initialize command selector
  ;jsr init_command_selector

  ; Initialize command list
  ;jsr init_command_list

  ; Initialize player
  ;jsr init_player

  ; Initalize APU
  jsr init_apu

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
