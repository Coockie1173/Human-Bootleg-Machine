;all hardcoded nonsense that isn't memory addresses goes here
.define MAXSOLUTIONSIZE #$20

;USED IN TABLES
.define TILE0LOCHI $00
.define TILE0LOCLO $00

.define TILE1LOCHI $00
.define TILE1LOCLO $00

.define TILE2LOCHI $00
.define TILE2LOCLO $00

.define TILE3LOCHI $00
.define TILE3LOCLO $00

.define TILE4LOCHI $00
.define TILE4LOCLO $00

.define TILE5LOCHI $00
.define TILE5LOCLO $00

.define TILE6LOCHI $00
.define TILE6LOCLO $00

.define TILE7LOCHI $00
.define TILE7LOCLO $00
;END TABLE USE

.define INBOXLOCHI #$00
.define INBOXLOCLO #$00

.define OUTBOXLOCHI #$00
.define OUTBOXLOCLO #$00


; GRAPHICS

; Graphics
; Memory locations
controller_state        = $00
previous_controller     = $01
arrow_position          = $02
arrow_position_hi       = $03
arrow_row               = $04
arrow_column            = $05

; Command selector variables
current_command         = $06
command_position        = $07
command_position_hi     = $08

; Command list variables
placeholder_row = $09
placeholder_col = $0A
placeholder_position = $0B
placeholder_position_hi = $0C
command_list_count = $0D

; Command constants
CMD_ADD                 = $00
CMD_SUB                 = $01
CMD_COPYTO              = $02
CMD_COPYFROM            = $03
CMD_JUMP                = $04
CMD_INBOX               = $05
CMD_OUTBOX              = $06
CMD_JUMPZERO            = $07
CMD_JUMPNEGATIVE        = $08
CMD_BUMPUP              = $09
CMD_BUMPDOWN            = $0A
CMD_EOL                 = $0B

; Placeholder
PLACEHODLER             = $0C

; Command tile IDs 
TILE_ADD_1              = $11
TILE_ADD_2              = $12
TILE_SUB_1              = $18
TILE_SUB_2              = $19
TILE_COPYTO_1           = $13
TILE_COPYTO_2           = $14
TILE_COPYTO_3           = $15
TILE_COPYFROM_1         = $13
TILE_COPYFROM_2         = $14
TILE_COPYFROM_3         = $16
TILE_COPYFROM_4         = $17
TILE_JUMP_1             = $21
TILE_JUMP_2             = $22
TILE_JUMPZERO_1         = $21
TILE_JUMPZERO_2         = $22
TILE_JUMPZERO_3         = $38
TILE_JUMPZERO_4         = $39
TILE_JUMPNEGATIVE_1     = $21
TILE_JUMPNEGATIVE_2     = $22
TILE_JUMPNEGATIVE_3     = $38
TILE_JUMPNEGATIVE_4     = $20
TILE_INBOX_1            = $1B
TILE_INBOX_2            = $1C
TILE_INBOX_3            = $1D
TILE_OUTBOX_1           = $30
TILE_OUTBOX_2           = $31
TILE_OUTBOX_3           = $32
TILE_BUMPUP_1           = $33
TILE_BUMPUP_2           = $34
TILE_BUMPUP_3           = $35
TILE_BUMPDOWN_1         = $33
TILE_BUMPDOWN_2         = $34
TILE_BUMPDOWN_3         = $36
TILE_BUMPDOWN_4         = $37
TILE_EOL_1              = $3A
TILE_EOL_2              = $3B

; Placeholder tile ID
TILE_PLACEHOLDER        = $1A

; PLAYER
TILE_PLAYER_IDLE_1      = $3C
TILE_PLAYER_IDLE_2      = $3D
TILE_PLAYER_IDLE_3      = $4C
TILE_PLAYER_IDLE_4      = $4D

TILE_PLAYER_WALK1_1     = $3C
TILE_PLAYER_WALK1_2     = $3D
TILE_PLAYER_WALK1_3     = $3E
TILE_PLAYER_WALK1_4     = $3f

TILE_PLAYER_WALK2_1     = $3C
TILE_PLAYER_WALK2_2     = $3D
TILE_PLAYER_WALK2_3     = $4E
TILE_PLAYER_WALK2_4     = $4F