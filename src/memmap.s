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

.define STACK $0100 ;size 0xFF DO NOT TOUCH THIS RANGE

.define COMMANDS $0200 ;size 0xFF
.define VARIABLES $0300 ;size 0xFF
.define GAMEMMEM $0400 ;size 0x08
.define HANDMEM $0409 ;size 0x01

.define SOLUTION $0450 ;size 0x20
.define MAXSOLUTIONSIZE #$20