; ========================================================
;  ZERO-PAGE ($0000–00FF)
; ========================================================
.segment "ZEROPAGE"

VAR0:  .res 1
VAR1:  .res 1
VAR2:  .res 1
VAR3:  .res 1
VAR4:  .res 1
VAR5:  .res 1
VAR6:  .res 1

CONADDR:        .res 1
CONADDRPREV:    .res 1
INBOXPTR:       .res 2
CHECKSOLPTR:    .res 2
PUZZLETEXTPTR:    .res 2
NMIFLAG:        .res 1
Gamemode:       .res 1


; ========================================================
; MAIN RAM ($0300+) — Everything else goes here
; ========================================================
.segment "BSS"

VARIABLES:              .res $FF
COMMANDS:               .res $FF

GAMEMMEM:               .res $08
HANDMEM:                .res $01
DEDSTINATIONPLAYERX:    .res 2
DEDSTINATIONPLAYERY:    .res 2

CURRCOMMAND:            .res 1
COMMANDCURSOR:          .res 1

SOLUTION:               .res $20
INBOXIDX:               .res 1
INTERPTR:               .res 1
SOLPTR:                 .res 1

; --------------------------------------------------------
; Solution checking
; --------------------------------------------------------
EXPECTED_SOLUTION:      .res $20    ; Store expected solution here (same size as SOLUTION)
solution_check_flag:    .res 1      ; 0 = not checked, 1 = correct, 2 = wrong
solution_length:        .res 1      ; Length of expected solution (for debugging)
player_solution_length: .res 1      ; Length of player solution (for debugging)

; --------------------------------------------------------
; UI + Command List
; --------------------------------------------------------
arrow_position:         .res 1
arrow_position_hi:      .res 1
arrow_row:              .res 1
arrow_column:           .res 1

current_command:        .res 1
command_position:       .res 1
command_position_hi:    .res 1

placeholder_row:        .res 1
placeholder_col:        .res 1
placeholder_position:   .res 1
placeholder_position_hi:.res 1
command_list_count:     .res 1
scrollIDX:              .res 1
update_list:            .res 1

arrow_position_old:     .res 1
arrow_position_hi_old:  .res 1
arrow_update_flag:      .res 1


; --------------------------------------------------------
; Player state
; --------------------------------------------------------
player_state:       .res 1
player_destination: .res 1
player_x:           .res 1
player_y:           .res 1
player_target_x:    .res 1
player_target_y:    .res 1
player_anim_frame:  .res 1
player_anim_timer:  .res 1
player_move_timer:  .res 1
player_idle_timer:  .res 1
player_facing:      .res 1

pending_operation:  .res 1  ; Which operation to perform when arriving
pending_tile_index: .res 1  ; Which tile to operate on
pending_value:      .res 1  ; Value to use (reserved for future use)


; --------------------------------------------------------
; Main menu
; --------------------------------------------------------
MMarrow_position:        .res 1
MMarrow_position_hi:     .res 1
MMarrow_row:             .res 1
MMarrow_column:          .res 1
MMarrow_position_old:    .res 1
MMarrow_position_old_hi: .res 1
MMarrow_update:          .res 1
sound_enabled:           .res 1  ; 0 = sound off, 1 = sound on

;result_screen_state:     .res 1    ; Which result screen we're on (WIN or LOSS)
result_arrow_row:        .res 1       ; Arrow position on result screen
result_arrow_update:     .res 1    ; Flag to redraw arrow

; --------------------------------------------------------
; Puzzle selection
; --------------------------------------------------------
SELECTEDPUZZLE:       .res 1
CURRENTJUMPIDX:       .res 1
UPDATECOMMFLAG:       .res 1
CURSORSTATE:          .res 1
CURSORBLINKTIMER:     .res 1
force_update_arg:     .res 1

VAR7:  .res 1
VAR8:  .res 1
VAR9:  .res 1
VARA:  .res 1
VARB:  .res 1
VARC:  .res 1
VARD:  .res 1
VARE:  .res 1
VARF:  .res 1


number_display_hi           : .res 1
number_display_lo           : .res 1
number_display_hi2          : .res 1
number_display_lo2          : .res 1

number_update_flag          : .res 1
tile_values_dirty           : .res 1    ; <-- IMPORTANT: bitmask byte
hand_value_dirty            : .res 1
inbox_value_dirty           : .res 1

; Last known values for change detection
last_tile_values        : .res 8     ; 8 bytes (one per tile)
last_hand_value         : .res 1     ; 1 byte
last_inbox_value        : .res 1     ; 1 byte
last_outbox_value       : .res 1     ; 1 byte  
outbox_value_dirty      : .res 1     ; 1 byte

; INBOX slots
INBOX_SLOT_1            : .res 1
INBOX_SLOT_2            : .res 1
INBOX_SLOT_3            : .res 1
INBOX_SLOT_4            : .res 1
INBOX_SLOT_5            : .res 1
INBOX_SLOT_6            : .res 1



START_INTERPRETER       : .res 1
FORCE_FULL_LIST_REDRAW  : .res 1 ;forcibly clears out the entire right side

; --------------------------------------------------------
; Command Buffer
; --------------------------------------------------------

; ========================================================
; Aliases
; ========================================================

controller_state    = CONADDR
previous_controller = CONADDRPREV
game_state          = Gamemode
