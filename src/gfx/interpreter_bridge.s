execute_next_command:
  ; SAFETY CHECK: Only run during actual gameplay
  lda game_state
  cmp #STATE_GAME
  bne @not_in_game         ; Don't execute if not in game mode
  
  ; CRITICAL: Only execute if player is completely idle AND ready
  lda player_state
  cmp #STATE_IDLE
  bne @not_ready           ; If walking, don't execute
  
  cmp #STATE_STOP
  beq @interpreter_stopped  ; If stopped, halt interpreter
  
  cmp #STATE_INBOX_NOT_EMPTY    ; <-- NEW CHECK
  beq @interpreter_stopped      ; If inbox loss state, halt interpreter
  
  ; Check if idle timer is still counting down
  lda player_idle_timer
  bne @not_ready           ; If timer > 0, still waiting
  
  ; Player is ready - execute next command
  jsr ParseInstruction
  bcs @interpreter_done    ; If carry set, we're done
  
  ; Command executed successfully
  clc
  rts

@not_in_game:
@not_ready:
  ; Player is still busy (walking or waiting) or not in game
  clc
  rts

@interpreter_stopped:
  ; Player hit STATE_STOP or STATE_INBOX_NOT_EMPTY - just return
  sec
  rts

@interpreter_done:
  ; Interpreter finished (reached $FF or error) - just return
  sec
  rts

; Call this once at game start to initialize the interpreter
init_interpreter:
  ; Set interpreter pointer to start
  lda #$00
  sta INTERPTR
  sta SOLPTR
  
  ; Set up inbox pointer (point to test puzzle)
  lda SELECTEDPUZZLE
  asl
  tax

  lda FullPuzzleList,x
  sta VAR1
  lda FullPuzzleList+1,x
  sta VAR0

  tya
  asl
  tay

  lda (VAR0),y
  sta INBOXPTR+1
  iny
  lda (VAR0),y ;setup secondary pointer
  sta INBOXPTR
  ;lda #<TestPuzzle          ; Low byte
  ;sta INBOXPTR
  ;lda #>TestPuzzle          ; High byte
  ;sta INBOXPTR+1
  
  ; Clear destination markers
  lda #$FF
  sta DEDSTINATIONPLAYERX
  sta DEDSTINATIONPLAYERY
  
  rts