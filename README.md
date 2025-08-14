# ALU de 32 bits (ALU32) – Nand2Tetris

## Descripción general
Este proyecto implementa una ALU de 32 bits usando dos ALU de 16 bits como bloques básicos, siguiendo el enfoque modular de Nand2Tetris. La ALU32 es capaz de realizar operaciones aritméticas y lógicas, y genera banderas de estado como ZR (cero), NG (negativo) y OVERFLOW.

---

## Entradas y salidas

### Entradas
- *x[32]*: Operando A (32 bits).
- *y[32]*: Operando B (32 bits).
- *zx*: Fuerza x a 0.
- *nx*: Niega x (NOT bit a bit).
- *zy*: Fuerza y a 0.
- *ny*: Niega y.
- *f*: Selecciona entre operación lógica (0 → AND) o aritmética (1 → ADD).
- *no*: Niega el resultado final.

### Salidas
- *out[32]*: Resultado de la operación.
- *zr*: 1 si el resultado es 0.
- *ng*: 1 si el bit más significativo (MSB) es 1.
- *overflow*: 1 si hubo desbordamiento en operaciones con signo.

---

## Diseño
El diseño divide la ALU en dos mitades:
- *Parte baja (bits 0–15)*: Calcula AND y ADD, genera CarryOutLow.
- *Parte alta (bits 16–31)*: Recibe CarryInHigh desde CarryOutLow para operaciones aritméticas.
- Las salidas de ambas mitades se combinan para formar out[32].
- Las banderas zr y ng se calculan a partir del resultado completo.
- overflow se detecta comparando el carry-in y carry-out del bit 31.

---

## Diagrama
![Diagrama ALU32](ALU32_anotada.png)

---

## Preguntas de Pensamiento Crítico

### 1. Modularidad
*Ventajas*: Reutiliza componentes probados (ALU16), facilita depuración y mantenimiento, reduce complejidad inicial.  
*Desventajas*: Mayor latencia por propagación de carry, más lógica de interconexión.  
*Justificación*: La modularidad permite escalar y mantener más fácilmente, aunque implica un pequeño coste en velocidad.

### 2. Signed vs. unsigned
*Cambios necesarios*:
- Banderas distintas: overflow para signed se detecta comparando carry-in y carry-out del MSB; para unsigned, se usa carry-out puro.
- Señal de control adicional para seleccionar modo.
- Bandera C para unsigned y V para signed, como en CPUs reales.
*Justificación*: El bit más significativo en signed representa signo, lo que cambia la interpretación del resultado y del desbordamiento.

### 3. Carry propagation
*Implementación*: Carry-lookahead calcula en paralelo señales de generación y propagación de carry para todos los bits.  
*Ventajas*: Menor latencia total.  
*Desventajas*: Más compuertas lógicas, más área y consumo.  
*Justificación*: El carry ripple es secuencial y lento; el lookahead es rápido pero más costoso en hardware.

### 4. Optimización
*Técnicas*:
- Compartir sumador para suma y resta.
- Multiplexores compartidos para selección de operaciones.
- Eliminar lógica redundante con álgebra booleana.
- Reutilizar señales ya calculadas.
*Justificación*: Reducir compuertas ahorra área y energía, sin sacrificar funcionalidad.

### 5. Escalabilidad
*Estrategia*:
- Mantener diseño modular parametrizable.
- Encadenar más ALU16 para 64 o 128 bits.
- Ajustar solo lógica de banderas y control.
*Justificación*: Con módulos pequeños, escalar es cuestión de agregar más bloques y conectar el carry, sin reescribir el núcleo.

---
