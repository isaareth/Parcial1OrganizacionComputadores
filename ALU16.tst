// ALU16.tst
// Test para ALU16 extendida

load ALU16.hdl;

output-list x%B1.16 y%B1.16 zx nx zy ny f no cin out%B1.16 zr ng cout ovfl .;

// Suma simple
set x 1;
set y 1;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 1;
set no 0;
set cin 0;
eval;
output;

// Suma con carry-in
set x 0xFFFF;
set y 1;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 1;
set no 0;
set cin 1;
eval;
output;

// AND
set x 0xAAAA;
set y 0x5555;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 0;
set no 0;
set cin 0;
eval;
output;

// Negación
set x 0x0000;
set y 0x0000;
set zx 1;
set nx 1;
set zy 1;
set ny 1;
set f 1;
set no 1;
set cin 0;
eval;
output;
