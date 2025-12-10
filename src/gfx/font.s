.define LETTERA $42
.define LETTERB LETTERA + 1
.define LETTERC LETTERB + 1
.define LETTERD LETTERC + 1
.define LETTERE LETTERD + 1
.define LETTERF LETTERE + 1
.define LETTERG LETTERF + 1
.define LETTERH LETTERG + 1
.define LETTERI LETTERH + 1
.define LETTERJ LETTERI + 1
.define LETTERK LETTERJ + 5
.define LETTERL LETTERK + 1
.define LETTERM LETTERL + 1
.define LETTERN LETTERM + 1
.define LETTERO LETTERN + 1
.define LETTERP LETTERO + 1
.define LETTERQ LETTERP + 1
.define LETTERR LETTERQ + 1
.define LETTERS LETTERR + 1
.define LETTERT LETTERS + 1
.define LETTERU LETTERT + 1
.define LETTERV LETTERU + 1
.define LETTERW LETTERV + 1
.define LETTERX LETTERW + 1
.define LETTERY LETTERX + 1
.define LETTERZ LETTERY + 1

;VAR2 has our letter
;VAR0 is position HI
;VAR1 is position LO
DrawLetter:
    lda $2002
    lda VAR0
    sta $2006
    lda VAR1
    sta $2006
    lda VAR2
    sta $2007
rts
