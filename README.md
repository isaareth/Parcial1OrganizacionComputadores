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

### 1. Modularidad: 
Ventajas y desventajas de usar dos ALU16 vs. una ALU32 monolítica. 

Las principales ventajas de usar dos ALUS de 16 es que mayormente ya hemos trabajado con conexiones y compuertas de 16 bits, lo que facilita la reutilización de componentes, reduciendo la complejidad inicial. Un diseño modular (En vez de un bloque grande de 32 bits, dos bloques de 16 conectados) facilita a futuro una implementacion de un sistema de hardware mayor como lo seria una ALU64, donde a simple vista seria seguir añadiendole ALUs16 en cadena, ahorrando tiempo en desarrollo. Otro punto importante y ventaja es la facilidad del trabajo en paralelo, mientras una persona puede diseñar la parte baja, otro puede diseñar la parte alta, y como tendran la misma logica interna, esto reduce el riesgo de comportamientos distintos entre partes


Las principales desventajas de este sistema modular es que al tener dos ALUS16 una con la parte alta [16..31] y otra con la baja [0..15], al tener el numero "dividido", el carry que genera la parte baja tiene que viajar a la adicion de la parte alta antes de terminar el calculo, por lo que hay un tiempo de ejecución mayor. 

Esto pasa porque cuando sumas dos números de 32 bits en binario, realmente estás sumando dos mitades:

Parte baja → bits 0 a 15.

Parte alta → bits 16 a 31.

El problema es que una suma de 16 bits puede “desbordarse” (overflow local) y generar un bit extra que no cabe en esa parte baja: ese es el carry-out.

Ese carry-out debe sumarse en la parte alta porque representa “un uno extra” que se debe añadir al bit 16.
Si no lo propagas, cualquier suma que genere un acarreo desde el bit 15 dará un resultado incorrecto en la parte alta.

Otra desventaja es que se necesita mas logica de interconexion, mas cableado y multiplexores para pasar las señales de control como el carry 

Mayor consumo de compuertas: Duplicar la lógica de control en cada módulo puede usar más compuertas que un diseño optimizado de 32 bits desde cero.

Coordinación de banderas: Bandera ZR (cero) y NG (negativo) deben calcularse considerando ambas mitades, lo que implica más lógica de unión.

Posible desincronización de señales: Si no se maneja bien el timing, la parte alta podría leer un carry o señal de control erróneo en simulaciones o hardware real.

En resumen: 

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
