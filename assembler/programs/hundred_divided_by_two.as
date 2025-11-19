LDI r1 0
LDI r2 0
LDI r3 0
STR r0 r0 0


LDI r1 100
LDI r2 0
LDI r3 0
.loop
CMP r1 r2
BRH zero .skip
ADI r2 2
INC r3
JMP .loop

.skip
LDI r15 0
STR r15 r3 0
HLT