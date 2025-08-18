// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/2/ALU32.tst

// Test script for ALU32 chip
// This tests a 32-bit ALU implementation using separate low/high 16-bit inputs

load ALU32.hdl;
output-file ALU32.out;
compare-to ALU32.cmp;
output-list xLow%B1.16.1 xHigh%B1.16.1 yLow%B1.16.1 yHigh%B1.16.1 zx%B1.1.1 nx%B1.1.1 zy%B1.1.1 ny%B1.1.1 f%B1.1.1 no%B1.1.1 outLow%B1.16.1 outHigh%B1.16.1 zr%B1.1.1 ng%B1.1.1 overflow%B1.1.1;

// ===== OPERACIONES BÁSICAS =====

// Test 1: Zero operation (zx=1, nx=0, zy=1, ny=0, f=1, no=0)
// Expected: outLow=0, outHigh=0, zr=1, ng=0, overflow=0
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 1,
set nx 0,
set zy 1,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 2: One operation (zx=1, nx=1, zy=1, ny=1, f=1, no=1)
// Expected: outLow=1, outHigh=1, zr=0, ng=0, overflow=0
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 1,
set nx 1,
set zy 1,
set ny 1,
set f 1,
set no 1;
eval;
output;

// Test 3: Minus one operation (zx=1, nx=1, zy=1, ny=0, f=1, no=0)
// Expected: outLow=65535, outHigh=65535, zr=0, ng=1, overflow=0
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 1,
set nx 1,
set zy 1,
set ny 0,
set f 1,
set no 0;
eval;
output;

// ===== OPERACIONES ARITMÉTICAS =====

// Test 4: ADD operation (zx=0, nx=0, zy=0, ny=0, f=1, no=0)
// x + y arithmetic addition
set xLow %B0001001000110100,
set xHigh %B0000000000000001,
set yLow %B1100101000110100,
set yHigh %B0000000000000001,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 5: SUB operation (zx=0, nx=1, zy=0, ny=0, f=1, no=1)
// x - y arithmetic subtraction (x + (-y))
set xLow %B0001001000110100,
set xHigh %B0000000000000001,
set yLow %B1100101000110100,
set yHigh %B0000000000000001,
set zx 0,
set nx 1,
set zy 0,
set ny 0,
set f 1,
set no 1;
eval;
output;

// Test 6: SUB operation reverse (zx=0, nx=0, zy=0, ny=1, f=1, no=1)
// y - x arithmetic subtraction (y + (-x))
set xLow %B0001001000110100,
set xHigh %B0000000000000001,
set yLow %B1100101000110100,
set yHigh %B0000000000000001,
set zx 0,
set nx 0,
set zy 0,
set ny 1,
set f 1,
set no 1;
eval;
output;

// ===== OPERACIONES LÓGICAS =====

// Test 7: AND operation (zx=0, nx=0, zy=0, ny=0, f=0, no=0)
// x & y bitwise AND
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 0,
set no 0;
eval;
output;

// Test 8: OR operation (zx=0, nx=1, zy=0, ny=1, f=0, no=1)
// x | y bitwise OR (using De Morgan's law: x|y = !(!x & !y))
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 0,
set nx 1,
set zy 0,
set ny 1,
set f 0,
set no 1;
eval;
output;

// ===== OPERACIONES DE NEGACIÓN =====

// Test 9: NOT x operation (zx=0, nx=0, zy=1, ny=1, f=0, no=1)
// !x bitwise NOT
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 0,
set nx 0,
set zy 1,
set ny 1,
set f 0,
set no 1;
eval;
output;

// Test 10: NOT y operation (zx=1, nx=1, zy=0, ny=0, f=0, no=1)
// !y bitwise NOT
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 1,
set nx 1,
set zy 0,
set ny 0,
set f 0,
set no 1;
eval;
output;

// Test 11: NEG x operation (zx=0, nx=0, zy=1, ny=1, f=1, no=1)
// -x arithmetic negation (two's complement)
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 0,
set nx 0,
set zy 1,
set ny 1,
set f 1,
set no 1;
eval;
output;

// Test 12: NEG y operation (zx=1, nx=1, zy=0, ny=0, f=1, no=1)
// -y arithmetic negation (two's complement)
set xLow %B0001001000110100,
set xHigh %B1111000000000000,
set yLow %B1100101000110100,
set yHigh %B0000000000000000,
set zx 1,
set nx 1,
set zy 0,
set ny 0,
set f 1,
set no 1;
eval;
output;

// ===== PRUEBAS DE BANDERAS DE ESTADO =====

// Test 13: ZERO flag test - result should be zero
// x + (-x) = 0
set xLow %B0001001000110100,
set xHigh %B0000000000000001,
set yLow %B1110110111001011,
set yHigh %B1111111111111110,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 14: NEGATIVE flag test - result should be negative
// Large negative number
set xLow %B0000000000000000,
set xHigh %B1000000000000000,
set yLow %B0000000000000000,
set yHigh %B0000000000000000,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 0,
set no 0;
eval;
output;

// ===== PRUEBAS DE OVERFLOW =====

// Test 15: OVERFLOW test - add two large positive numbers
// Should cause overflow in 32-bit addition
set xLow %B1111111111111111,
set xHigh %B0111111111111111,
set yLow %B0000000000000001,
set yHigh %B0000000000000000,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 16: OVERFLOW test - add two large negative numbers
// Should cause overflow in 32-bit addition
set xLow %B0000000000000000,
set xHigh %B1000000000000000,
set yLow %B1111111111111111,
set yHigh %B1111111111111111,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 17: OVERFLOW test - subtract large numbers
// Should cause overflow in 32-bit subtraction
set xLow %B0000000000000000,
set xHigh %B1000000000000000,
set yLow %B0000000000000001,
set yHigh %B0000000000000000,
set zx 0,
set nx 1,
set zy 0,
set ny 0,
set f 1,
set no 1;
eval;
output;

// ===== PRUEBAS DE CASOS ESPECIALES =====

// Test 18: Carry propagation test
// Test carry from low to high part
set xLow %B1111111111111111,
set xHigh %B0000000000000000,
set yLow %B0000000000000001,
set yHigh %B0000000000000001,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 19: Edge case - maximum positive values
set xLow %B1111111111111111,
set xHigh %B0111111111111111,
set yLow %B1111111111111111,
set yHigh %B0111111111111111,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;

// Test 20: Edge case - maximum negative values
set xLow %B0000000000000000,
set xHigh %B1000000000000000,
set yLow %B0000000000000000,
set yHigh %B1000000000000000,
set zx 0,
set nx 0,
set zy 0,
set ny 0,
set f 1,
set no 0;
eval;
output;