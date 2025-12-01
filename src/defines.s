;all hardcoded nonsense that isn't memory addresses goes here
.define MAXSOLUTIONSIZE #$20

;USED IN TABLES
; Pos: 8,7 = $20E8
.define TILE0LOCHI $20
.define TILE0LOCLO $E8

; Pos: 12,7 = $20EC
.define TILE1LOCHI $20
.define TILE1LOCLO $EC

; Pos: 8,10 = $2148
.define TILE2LOCHI $21
.define TILE2LOCLO $48

; Pos: 12,10 = $214C
.define TILE3LOCHI $21
.define TILE3LOCLO $4C

; Pos: 8, 13 = $21A8
.define TILE4LOCHI $21
.define TILE4LOCLO $A8

; Pos: 12,13 = $21AC
.define TILE5LOCHI $21
.define TILE5LOCLO $AC

; Pos: 8,16 = $2208
.define TILE6LOCHI $22
.define TILE6LOCLO $08

; Pos: 12,16 = $220C
.define TILE7LOCHI $22
.define TILE7LOCLO $0C
;END TABLE USE

; Inbox on pos 2,8 = $2102
.define INBOXLOCHI $21
.define INBOXLOCLO $02

; Outbox on pos 19, 8 = $2123
.define OUTBOXLOCHI $21
.define OUTBOXLOCLO $13


; GRAPHICS

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
; Player sprite tiles
TILE_PLAYER_IDLE_1      = $3C
TILE_PLAYER_IDLE_2      = $3D
TILE_PLAYER_IDLE_3      = $4C
TILE_PLAYER_IDLE_4      = $4D

TILE_PLAYER_WALK1_1     = $3C
TILE_PLAYER_WALK1_2     = $3D
TILE_PLAYER_WALK1_3     = $3E
TILE_PLAYER_WALK1_4     = $3F

TILE_PLAYER_WALK2_1     = $3C
TILE_PLAYER_WALK2_2     = $3D
TILE_PLAYER_WALK2_3     = $4E
TILE_PLAYER_WALK2_4     = $4F

; Movement constants
PLAYER_SPEED            = 1       ; Frames between moves (lower = faster)
ANIM_SPEED              = 8       ; Frames between animation frames
IDLE_TIME               = 30      ; Frames to wait at each destination (60 = 1 second)

; Player states
STATE_IDLE              = 0
STATE_WALKING           = 1

; Destination constants (10 total locations) [TEST]
DEST_INBOX              = 0
DEST_TILE0              = 1
DEST_TILE1              = 2
DEST_TILE2              = 3
DEST_TILE3              = 4
DEST_TILE4              = 5
DEST_TILE5              = 6
DEST_TILE6              = 7
DEST_TILE7              = 8
DEST_OUTBOX             = 9

; Destination positions (pixel coordinates)
; Format: Column * 8, Row * 8
; Inbox: tile (5, 8) = pixel (40, 64)
INBOX_X                 = 40
INBOX_Y                 = 64

; Tile 0: tile (6, 7) = pixel (48, 56)
TILE0_X                 = 48
TILE0_Y                 = 56

; Tile 1: tile (10, 7) = pixel (80, 56)
TILE1_X                 = 80
TILE1_Y                 = 56

; Tile 2: tile (6, 10) = pixel (48, 80)
TILE2_X                 = 48
TILE2_Y                 = 80

; Tile 3: tile (10, 10) = pixel (80, 80)
TILE3_X                 = 80
TILE3_Y                 = 80

; Tile 4: tile (6, 13) = pixel (48, 104)
TILE4_X                 = 48
TILE4_Y                 = 104

; Tile 5: tile (10, 13) = pixel (80, 104)
TILE5_X                 = 80
TILE5_Y                 = 104

; Tile 6: tile (6, 16) = pixel (48, 128)
TILE6_X                 = 48
TILE6_Y                 = 128

; Tile 7: tile (10, 16) = pixel (80, 128)
TILE7_X                 = 80
TILE7_Y                 = 128

; Outbox: tile (16, 8) = pixel (128, 64)
OUTBOX_X                = 128
OUTBOX_Y                = 64

.define BUTTON_A #%1000000
.define BUTTON_B #%0100000
.define BUTTON_SELECT #%0010000
.define BUTTON_START #%0001000
.define BUTTON_UP #%00001000
.define BUTTON_DOWN #%00000100
.define BUTTON_LEFT #%00000010
.define BUTTON_RIGHT #%00000001