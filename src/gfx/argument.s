;these are hardcoded graphical values, we can just drop them here for ease of access
.define DRAWSTARTHI $23
.define DRAWSTARTLO $38

CommsWithArg:
.byte CMD_COPYFROM, CMD_COPYTO, CMD_ADD, CMD_SUB
.byte CMD_BUMPUP, CMD_BUMPDOWN
.byte CMD_EOL ;to signify end of list

Show_Argument:
    lda force_update_arg
    bne @forcerun
    lda update_list ;update everytime the list updates
    beq Show_Argument_end
    @forcerun: ;in case we only want to update the argument

    jsr CalculateItemIDX
    stx VAR3
    lda COMMANDS,x
    sta VAR5
    ldx #$00

    cmp #$FF
    beq Show_Argument_end

    @loop:
    lda CommsWithArg,x
    cmp #$FF
    beq RemoveDrawArg
    cmp VAR5
    beq DrawArg
    inx
    jmp @loop

    DrawArgEnd:
    lda #$00
    sta force_update_arg
    Show_Argument_end:
rts


RemoveDrawArg:
    lda $2002
    lda #DRAWSTARTHI
    sta $2006
    lda #DRAWSTARTLO
    sta $2006

    ldx #$00
    @Loop:
    lda ArgumentText,x
    cmp #$FF
    beq @end
    lda #$00                ; Brown background tile
    sta $2007
    inx
    jmp @Loop
@end:
    lda #$00                ; Brown background tile
    sta $2007
jmp DrawArgEnd

ArgumentText:
.byte LETTERT, LETTERI, LETTERL, LETTERE, $FF

DrawArg:
ldx #$00
lda #DRAWSTARTHI
sta VAR0
lda #DRAWSTARTLO
sta VAR1

@Loop:
    lda ArgumentText,x
    cmp #$FF
    beq @end
    sta VAR2
    jsr DrawLetter
    inc VAR1 ;shift over one tile
    inx
    jmp @Loop

@end:
ldx VAR3
lda VARIABLES,x
clc
adc #$28
sta VAR2
jsr DrawLetter
jmp DrawArgEnd


;clean up
.undefine DRAWSTARTHI
.undefine DRAWSTARTLO