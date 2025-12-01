; Bridge between interpreter and player movement system
; This handles executing commands and triggering player movement

; Call this when you want to execute the next command
execute_next_command:
  ; Call your teammate's ParseInstruction
  jsr ParseInstruction
  bcs @interpreter_done      ; If carry set, we're done
  
  ; Command executed successfully
  ; The destination is now set in DEDSTINATIONPLAYERX/Y
  ; Your player update will handle the movement
  clc
  rts

@interpreter_done:
  ; Interpreter finished (reached $FF or error)
  sec
  rts

; Call this once at game start to initialize the interpreter
init_interpreter:
  ; Set interpreter pointer to start
  lda #$00
  sta INTERPTR
  sta SOLPTR
  
  ; Set up inbox pointer (point to test puzzle)
  lda #<TestPuzzle          ; Low byte
  sta INBOXPTR
  lda #>TestPuzzle          ; High byte
  sta INBOXPTR+1
  
  ; Clear destination markers
  lda #$FF
  sta DEDSTINATIONPLAYERX
  sta DEDSTINATIONPLAYERY
  
  rts