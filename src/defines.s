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

; Placeholder
PLACEHODLER             = $05

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

; Placeholder tile ID
TILE_PLACEHOLDER        = $1A