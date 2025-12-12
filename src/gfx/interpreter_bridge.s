; Bridge between interpreter and player movement system
; This handles executing commands and triggering player movement

; Call this when you want to execute the next command
execute_next_command:
  ; CRITICAL: Only execute if player is completely idle AND ready
  lda player_state
  cmp #STATE_IDLE
  bne @not_ready           ; If walking, don't execute
  
  cmp #STATE_STOP
  beq @interpreter_stopped  ; If stopped, halt interpreter
  
  ; Check if idle timer is still counting down
  lda player_idle_timer
  bne @not_ready           ; If timer > 0, still waiting
  
  ; Player is ready - execute next command
  jsr ParseInstruction
  bcs @interpreter_done    ; If carry set, we're done
  
  ; Command executed successfully
  ; The destination is now set in DEDSTINATIONPLAYERX/Y
  ; Your player update will handle the movement
  clc
  rts

@not_ready:
  ; Player is still busy (walking or waiting)
  clc
  rts

@interpreter_stopped:
  ; Player hit STATE_STOP (e.g., empty inbox)
  sec
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