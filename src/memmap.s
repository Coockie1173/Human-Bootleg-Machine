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
controller_state            = CONADDR
previous_controller         = CONADDRPREV
arrow_position              = $0502
arrow_position_hi           = $0503
arrow_row                   = $0504
arrow_column                = $0505

game_state = Gamemode  ; Game state variable

; Command selector variables
current_command             = $0506
command_position            = $0507
command_position_hi         = $0508

; Command list variables
placeholder_row             = $0509
placeholder_col             = $050A
placeholder_position        = $050B
placeholder_position_hi     = $050C
command_list_count          = $050D
scrollIDX                   = $050E     
update_list                 = $050F
arrow_position_old          = $0511
arrow_position_hi_old       = $0512
arrow_update_flag           = $0513

; Player state variables
player_state                = $0520     ; 0=idle, 1=walking
player_destination          = $0521     ; Current destination index (0-9)
player_x                    = $0522     ; Current X pixel position
player_y                    = $0523     ; Current Y pixel position
player_target_x             = $0524     ; Target X pixel position
player_target_y             = $0525     ; Target Y pixel position
player_anim_frame           = $0526     ; Animation frame (0-3)
player_anim_timer           = $0527     ; Frames until next animation
player_move_timer           = $0528     ; Frames until next move
player_idle_timer           = $0529     ; Frames to wait at destination
player_facing               = $052A     ; 0=facing right (no flip), 1=facing left (flip)

; Main Menu
MMarrow_position            = $052B
MMarrow_position_hi         = $052C
MMarrow_row                 = $052D
MMarrow_column              = $052E
MMarrow_position_old        = $052F
MMarrow_position_old_hi     = $0530
MMarrow_update              = $0531

; Numbers
TILE_NUM_0                  = $07   ; Also blank tile for SINGLE POSITIVE digits > [0][x]
TILE_NUM_1                  = $08
TILE_NUM_2                  = $09
TILE_NUM_3                  = $0A
TILE_NUM_4                  = $0B 
TILE_NUM_5                  = $0C 
TILE_NUM_6                  = $0D 
TILE_NUM_7                  = $0E 
TILE_NUM_8                  = $0F 
TILE_NUM_9                  = $1E

TILE_MINUS                  = $60   ; For SINGLE digits > [-][x]

TILE_NUM_MINUS_1            = $61   ; For DOUBLE digits
TILE_NUM_MINUS_2            = $62   ; [-2][x]
TILE_NUM_MINUS_3            = $63   ; [-3][x]
TILE_NUM_MINUS_4            = $64   ; [-4][x] ...
TILE_NUM_MINUS_5            = $65
TILE_NUM_MINUS_6            = $66
TILE_NUM_MINUS_7            = $67
TILE_NUM_MINUS_8            = $68
TILE_NUM_MINUS_9            = $69

number_display_hi           = $0532
number_display_lo           = $0533

number_update_flag          = $0534     ; Set to 1 when numbers need redrawing
tile_values_dirty           = $0535     ; Bitfield: which tiles need update (bits 0-7)
hand_value_dirty            = $0536     ; Set to 1 when hand needs update
inbox_value_dirty           = $0537     ; Set to 1 when inbox needs update

; $05A2 next
.define SELECTEDPUZZLE $05A2
.define CURRENTJUMPIDX $05A3
.define UPDATECOMMFLAG $05A4

.define COMMANDS $0600 ;size 0xFF
