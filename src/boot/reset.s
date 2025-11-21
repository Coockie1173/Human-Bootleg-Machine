;reset/pre-boot code
;this sets everything required up PPU wise and sets the program up to work

.include "../gfx/background.s"

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

   ; Initialize arrow (always visible now)
  lda #$03
  sta arrow_row
  lda #23
  sta arrow_column


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

  jsr load_background

   ; Calculate and draw initial arrow position
  jsr calc_arrow_address
  jsr draw_arrow_sprite
  
  ; Initialize command selector
  jsr init_command_selector

  enable_rendering:
    lda #%10000000	; Enable NMI
    sta $2000
    lda #%00011110	; Enable rendering: show background, show sprites, show left 8 pixels
    sta $2001

    jmp main ;start main game loop
