.macro PHX 
    TXA  
    PHA
.endmacro
.macro PHY
    TYA  
    PHA
.endmacro
.macro PLX 
    PLA
    TAX
.endmacro
.macro PLY 
    PLA
    TAY
.endmacro


.macro STRBYTE str

    .local _i

    .repeat .strlen(str), _i

        .scope          ; <-- isolates all assigned symbols this iteration

            .local _c
            _c = .strat(str, _i)

            ; convert lowercase → uppercase
            .if (_c >= 'a') && (_c <= 'z')
                _c = _c - ('a' - 'A')
            .endif

            ; map each letter
            .if _c = 'A'
                .byte LETTERA
            .elseif _c = 'B'
                .byte LETTERB
            .elseif _c = 'C'
                .byte LETTERC
            .elseif _c = 'D'
                .byte LETTERD
            .elseif _c = 'E'
                .byte LETTERE
            .elseif _c = 'F'
                .byte LETTERF
            .elseif _c = 'G'
                .byte LETTERG
            .elseif _c = 'H'
                .byte LETTERH
            .elseif _c = 'I'
                .byte LETTERI
            .elseif _c = 'J'
                .byte LETTERJ
            .elseif _c = 'K'
                .byte LETTERK
            .elseif _c = 'L'
                .byte LETTERL
            .elseif _c = 'M'
                .byte LETTERM
            .elseif _c = 'N'
                .byte LETTERN
            .elseif _c = 'O'
                .byte LETTERO
            .elseif _c = 'P'
                .byte LETTERP
            .elseif _c = 'Q'
                .byte LETTERQ
            .elseif _c = 'R'
                .byte LETTERR
            .elseif _c = 'S'
                .byte LETTERS
            .elseif _c = 'T'
                .byte LETTERT
            .elseif _c = 'U'
                .byte LETTERU
            .elseif _c = 'V'
                .byte LETTERV
            .elseif _c = 'W'
                .byte LETTERW
            .elseif _c = 'X'
                .byte LETTERX
            .elseif _c = 'Y'
                .byte LETTERY
            .elseif _c = 'Z'
                .byte LETTERZ
            .elseif _c = ' '
                .byte $01
            .elseif _c = '|'
                .byte $00
            .else
                .error "Unsupported character in STRING_TO_BYTES_FF"
            .endif

        .endscope

    .endrepeat

    .byte $FF   ; null terminator
.endmacro