.define VAR0 $00
.define VAR1 $01
.define VAR2 $02
.define VAR3 $03
.define VAR4 $04
.define VAR5 $05
.define VAR6 $06
.define VAR7 $07
.define VAR8 $08
.define VAR9 $09
.define VARA $0A
.define VARB $0B
.define VARC $0C
.define VARD $0D
.define VARE $0E
.define VARF $0F

.define CONADDR $10
.define CONADDRPREV $11
.define INBOXPTR $12 ;size 0x02
.define CHECKSOLPTR $14 ;size 0x02
.define NMIFLAG $16 ;onlly run main once NMI happened
.define Gamemode $17

.define STACK $0100 ;size 0xFF DO NOT TOUCH THIS RANGE

.define VARIABLES $0300 ;size 0xFF
.define GAMEMMEM $0400 ;size 0x08
.define HANDMEM $0409 ;size 0x01
.define DEDSTINATIONPLAYERX $040A ;size 0x02
.define DEDSTINATIONPLAYERY $040C ;size 0x02

.define CURRCOMMAND $0448 ;size 0x01
.define COMMANDCURSOR $0449 ;size 0x01

.define SOLUTION $0450 ;size 0x20
.define INBOXIDX $0471 ;size 0x01
.define INTERPTR $0472 ;size 0x01
.define SOLPTR $0473 ;size 0x01


; Memory locations
controller_state        = CONADDR
previous_controller     = CONADDRPREV
arrow_position          = $0502
arrow_position_hi       = $0503
arrow_row               = $0504
arrow_column            = $0505

game_state = Gamemode  ; Game state variable

; Command selector variables
current_command         = $0506
command_position        = $0507
command_position_hi     = $0508

; Command list variables
placeholder_row         = $0509
placeholder_col         = $050A
placeholder_position    = $050B
placeholder_position_hi = $050C
command_list_count      = $050D
scrollIDX               = $050E
update_list             = $050F
arrow_position_old          = $0511
arrow_position_hi_old       = $0512
arrow_update_flag       = $0513
; Player state variables
player_state            = $0520     ; 0=idle, 1=walking
player_destination      = $0521     ; Current destination index (0-9)
player_x                = $0522     ; Current X pixel position
player_y                = $0523     ; Current Y pixel position
player_target_x         = $0524     ; Target X pixel position
player_target_y         = $0525     ; Target Y pixel position
player_anim_frame       = $0526     ; Animation frame (0-3)
player_anim_timer       = $0527     ; Frames until next animation
player_move_timer       = $0528     ; Frames until next move
player_idle_timer       = $0529     ; Frames to wait at destination
player_facing           = $052A     ; 0=facing right (no flip), 1=facing left (flip)
; Main Menu
MMarrow_position          = $052B
MMarrow_position_hi       = $052C
MMarrow_row               = $052D
MMarrow_column            = $052E
MMarrow_position_old            = $052F
MMarrow_position_old_hi            = $0530
MMarrow_update = $0531

; $05A2 next
.define SELECTEDPUZZLE $05A2
.define CURRENTJUMPIDX $05A3
.define UPDATECOMMFLAG $05A4
.define CURSORSTATE $05A5

.define COMMANDS $0600 ;size 0xFF
