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

;graphics
.define YARR $20
.define COMMANDOPTIONSY $15
.define CURRENTCOMY $20

; Memory locations
controller_state = $00
previous_controller = $01
arrow_position = $02
arrow_visible = $03
arrow_row = $04