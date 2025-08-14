
// ALU32.tst
// Test para ALU de 32 bits

load ALU32.hdl;

// Indicar al simulador qué señales mostrar en la salida
output-list x[0..15]%B1.16 x[16..31]%B1.16 y[0..15]%B1.16 y[16..31]%B1.16 zx nx zy ny f no out[0..15]%B1.16 out[16..31]%B1.16 zr ng .;

// Prueba suma simple
set x 0x00000001;
set y 0x00000001;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 1;
set no 0;
eval;
output;

// Prueba suma con overflow
set x 0xFFFFFFFF;
set y 0x00000001;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 1;
set no 0;
eval;
output;

// Prueba AND
set x 0xFFFF0000;
set y 0x0000FFFF;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 0;
set no 0;
eval;
output;

// Prueba OR
set x 0xFFFF0000;
set y 0x0000FFFF;
set zx 0;
set nx 0;
set zy 0;
set ny 0;
set f 0;
set no 1;
eval;
output;

// Prueba cero
set x 0x00000000;
set y 0x00000000;
set zx 1;
set nx 0;
set zy 1;
set ny 0;
set f 1;
set no 0;
eval;
output;
