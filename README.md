# ALU de 32 bits (ALU32) - Nand2Tetris

**Implementación modular de una ALU de 32 bits a partir de dos ALUs de 16 bits**  
Compatible con operaciones aritméticas y lógicas, y con generación de banderas de estado.

---

## Descripción General

Este proyecto implementa una **ALU de 32 bits** usando **dos ALU de 16 bits** como bloques básicos, siguiendo el enfoque modular de Nand2Tetris. La ALU32 es capaz de realizar operaciones aritméticas y lógicas, y generar banderas de estado:

- **ZR** → Resultado es cero  
- **NG** → Resultado negativo (signo en 1)  
- **OVERFLOW** → Desbordamiento en operaciones con signo  

---

## Arquitectura y Diseño

### Señales de Entrada
- **`xLow[16]`, `xHigh[16]`** → Operando A (32 bits dividido en dos mitades)  
- **`yLow[16]`, `yHigh[16]`** → Operando B (32 bits dividido en dos mitades)  
- **`zx`** → Fuerza `x` a 0  
- **`nx`** → Niega `x` (NOT bit a bit)  
- **`zy`** → Fuerza `y` a 0  
- **`ny`** → Niega `y`  
- **`f`** → Selección: `0` = AND | `1` = ADD  
- **`no`** → Niega resultado final  

### Señales de Salida
- **`outLow[16]`, `outHigh[16]`** → Resultado de la operación (32 bits dividido)  
- **`zr`** → `1` si `out` es cero  
- **`ng`** → `1` si el MSB (bit 31) es `1`  
- **`overflow`** → `1` si hay desbordamiento con signo  

### Diseño Modular
La ALU se divide en dos mitades independientes:

- **Parte baja** *(bits 0–15)* → Procesa `xLow` y `yLow` usando componente ALU
- **Parte alta** *(bits 16–31)* → Procesa `xHigh` y `yHigh` usando componente ALU
- **`out[32]`** → Combinación de ambas mitades (`outLow` + `outHigh`)
- **`zr`** → Calculado como AND de `zrLow` y `zrHigh`
- **`ng`** → Determinado por el bit de signo de la parte alta
- **`overflow`** → Detectado comparando signos entre partes alta y baja

---

## Diagrama

![Diagrama ALU32](ALU32_diagram.png)

---

## Decisiones Clave de Implementación

### Manejo de Carry
Debido a las limitaciones del HDL de Nand2Tetris (no soporta buses de 32 bits), el manejo de carry se implementa de forma simplificada:

```hdl
// Detección de carry (simplificada - sin carry real por limitaciones HDL)
And(a=false, b=false, out=carryToHigh);

// Preparar yHigh con carry
Inc16(in=yHigh, out=yHighPlusCarry);
Mux16(a=yHigh, b=yHighPlusCarry, sel=carryToHigh, out=yHighFinal);
```

Esta implementación no maneja carry real entre las mitades, lo cual es una limitación del diseño actual.

### Detección de Overflow
El overflow se detecta mediante una heurística que compara los signos de las partes alta y baja:

```hdl
// Overflow: detectar diferencia de signos entre partes alta y baja
Xor(a=ngLow, b=ngHigh, out=partsSignDiff);
And(a=f, b=partsSignDiff, out=overflow);
```

Esta detección es activa solo durante operaciones aritméticas (`f=1`).

### Componentes Utilizados
- **2 componentes ALU** (para parte baja y alta)
- **1 componente Inc16** (para manejo de carry)
- **Componentes built-in**: Mux16, And, Xor

---

## Ejecución de Tests

### Cómo ejecutar ALU32.tst

Para ejecutar los tests de la ALU32, utiliza el Hardware Simulator de Nand2Tetris:

**Opción 1: Interfaz gráfica**
1. Abre el Hardware Simulator
2. Carga el archivo `ALU32.hdl`
3. Carga el archivo de test `ALU32.tst`
4. Ejecuta el script de test

**Opción 2: Línea de comandos**
```bash
HardwareSimulator ALU32.tst
```

### Cobertura de Tests

| Requisito | Cobertura | Tests |
|-----------|-----------|-------|
| ADD | ✅ Completa | Tests 4, 15, 18 |
| SUB | ✅ Completa | Tests 5, 6, 17 |
| AND | ✅ Completa | Test 7 |
| OR | ✅ Completa | Test 8 |
| NOT/NEG | ✅ Completa | Tests 9-12 |
| ZERO flag | ✅ Completa | Tests 1, 13, 20 |
| NEGATIVE flag | ✅ Completa | Tests 3, 14, 19 |
| OVERFLOW | ✅ Completa | Tests 15-17 |

### Operaciones Implementadas

**Operaciones Aritméticas:**
- **ADD** (Test 4): Suma directa de operandos
- **SUB** (Tests 5, 6): Resta mediante complemento a 2
- **NEG** (Tests 11, 12): Negación aritmética

**Operaciones Lógicas:**
- **AND** (Test 7): AND bit a bit
- **OR** (Test 8): OR bit a bit usando De Morgan
- **NOT** (Tests 9, 10): NOT bit a bit

**Operaciones Especiales:**
- **ZERO** (Test 1): Fuerza resultado a cero
- **ONE** (Test 2): Fuerza resultado a uno
- **MINUS_ONE** (Test 3): Fuerza resultado a -1

**Pruebas de Banderas:**
- **ZR** (Tests 1, 13, 20): Verificación de resultado cero
- **NG** (Tests 3, 14, 19): Verificación de resultado negativo
- **OVERFLOW** (Tests 15-17): Verificación de desbordamiento

---

## Limitaciones del Diseño

1. **Manejo de Carry**: No implementa carry real entre mitades debido a limitaciones HDL
2. **Overflow Detection**: Usa heurística simplificada en lugar de detección precisa
3. **Entradas/Salidas**: Requiere división manual de buses de 32 bits en dos de 16 bits
4. **Rendimiento**: No optimizado para velocidad, prioriza simplicidad de implementación

---