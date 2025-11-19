LDI r1 13
LDI r2 18
LDI r3 1
LDI r4 1
LDI r5 32
LDI r15 pixel_x

.loop
ADD r1 r3 r1
ADD r2 r4 r2

SUB r5 r1 r0
BRH carry .inv_x
.pass
SUB r5 r2 r0
BRH carry .inv_y
JMP .skip

.inv_x
NEG r3 r3
ADD r1 r3 r1
ADD r1 r3 r1
JMP .pass

.inv_y
NEG r4 r4
ADD r2 r4 r2
ADD r2 r4 r2
JMP .skip

.skip
CAL .display
JMP .loop

.display
STR r15 r0 6
STR r15 r1
STR r15 r2 1
STR r15 r0 2
STR r15 r0 5
