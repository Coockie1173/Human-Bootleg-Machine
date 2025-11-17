JOYPAD1 = $4016
JOYPAD2 = $4017

ReadJoy:
    lda CONADDR ;load (previous) controller input
    sta CONADDRPREV ;store previous input

    ;prime the strobe bit, by doing so you tell the system
    ;you're getting ready to read in the controller status
    ;so whilst this bit is set the buttons will be continuously loaded.
    ;If it's unclear: imagine a bus, a small bus. One with a max capacity of one person. When you set the strobe bit, you tell the passengers at the other side to get in line. Now the bus will go back and forth loading and unloading a passenger until everyone is on the other side.
    lda #$01
    sta JOYPAD1 ;store the strobe bit in the joypad register so it gets loaded
    sta CONADDR ;also clear out the controller buffer in memory
    lsr A ;following the logic, shifting right will discard 01, essentially loading in #$00
    ;why LSR over lda? it's a cycle faster (2 cycles rather than 4)
    ;Now clear the strobe bit in joypad 1 so the reloading stops and the data starts getting sent over to the register.
    ;now since this is a shift register, it loads in bit per bit. You could use the X/Y register to read this in a loop, or you roll in the data into the controller buffer.
    ;In this example we "roll" the data into our controller address.
    sta JOYPAD1 ;now set the strobe bit back to 0 so we can start reading in the controller data.
loop:
    lda JOYPAD1
    lsr A ;shift the read bit into the carry
    rol CONADDR ;our carry bit will be shifted into our controller memory address by shifting the data to the left, and shifting our bit in on the right.
    ;this in turn shifts the leftmost bit into the carry, whilst simultaneously shifting in the carry in on the right.
    bcc loop ;and as long as the carry is clear (so the bit is 0) we jump back to loop
rts ;and once we read in all 8 bits we jump back 