// Add16Ext.tst
// Test para Add16Ext

load Add16Ext.hdl;

output-list a%B1.16 b%B1.16 cin out%B1.16 cout ovfl .;

// Suma simple
set a 1;
set b 1;
set cin 0;
eval;
output;

// Suma con carry-in
set a 0xFFFF;
set b 1;
set cin 1;
eval;
output;

// Overflow positivo
set a 0x7FFF;
set b 1;
set cin 0;
eval;
output;

// Overflow negativo
set a 0x8000;
set b 0x8000;
set cin 0;
eval;
output;
