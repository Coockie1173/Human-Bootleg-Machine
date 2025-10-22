;this just brings all the required boot asm files together into one nice file
.include "header.s"
.include "../gfx/graphics.s"

.include "vectors.s"

;required even if unused
.segment "STARTUP"

; Main code segment for the program
.segment "CODE"
.include "palette.s"
.include "reset.s"