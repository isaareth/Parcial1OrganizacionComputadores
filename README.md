# ⚙️ ALU de 32 bits (ALU32) – *Nand2Tetris*

> **Implementación modular de una ALU de 32 bits a partir de dos ALUs de 16 bits**  
> Compatible con operaciones aritméticas y lógicas, y con generación de banderas de estado.

---

## 📜 **Descripción general**
Este proyecto implementa una **ALU de 32 bits** usando **dos ALU16** como bloques básicos, siguiendo el enfoque modular de *Nand2Tetris*.  
La **ALU32** es capaz de realizar operaciones aritméticas y lógicas, y generar banderas:

- 🟢 **ZR** → Resultado es cero  
- 🔴 **NG** → Resultado negativo (signo en 1)  
- ⚠️ **OVERFLOW** → Desbordamiento en operaciones con signo  

---

## 🎛 **Entradas y salidas**

### 🔹 Entradas
- **`x[32]`** → Operando A (32 bits)  
- **`y[32]`** → Operando B (32 bits)  
- **`zx`** → Fuerza `x` a 0  
- **`nx`** → Niega `x` (NOT bit a bit)  
- **`zy`** → Fuerza `y` a 0  
- **`ny`** → Niega `y`  
- **`f`** → Selección: <span style="background-color:black;color:white;padding:2px 6px;border-radius:4px;">0 = AND</span> | <span style="background-color:black;color:white;padding:2px 6px;border-radius:4px;">1 = ADD</span>  
- **`no`** → Niega resultado final  

### 🔹 Salidas
- **`out[32]`** → Resultado de la operación  
- **`zr`** → `1` si `out` es cero  
- **`ng`** → `1` si el MSB (bit 31) es `1`  
- **`overflow`** → `1` si hay desbordamiento con signo  

---

## 🛠 **Diseño**
La ALU se divide en dos mitades:

- **Parte baja** *(bits 0–15)* → Calcula AND y ADD, genera `CarryOutLow`  
- **Parte alta** *(bits 16–31)* → Usa `CarryInHigh` proveniente de la parte baja para la suma  
- **`out[32]`** → Combinación de ambas mitades  
- **`zr` y `ng`** → Calculados a partir de todo el resultado  
- **`overflow`** → Detectado comparando `carry-in` y `carry-out` del bit 31  

---

## 🖼 **Diagrama**
![Diagrama ALU32](ALU32_anotada.png)

---

## 💭 **Preguntas de Pensamiento Crítico**

### 1️⃣ Modularidad  
**Ventajas y desventajas de usar dos ALU16 vs. una ALU32 monolítica**  

---

#### ✅ Ventajas
Las principales ventajas de usar dos ALU de 16 bits es que mayormente ya hemos trabajado con conexiones y compuertas de 16 bits, lo que facilita la **reutilización de componentes**, reduciendo la complejidad inicial.  

Un diseño modular (en vez de un bloque grande de 32 bits, dos bloques de 16 conectados) **facilita a futuro una implementación de un sistema de hardware mayor** como lo sería una ALU64, donde a simple vista sería seguir añadiéndole ALUs de 16 en cadena, ahorrando tiempo en desarrollo.  

Otro punto importante y ventaja es la **facilidad del trabajo en paralelo**: mientras una persona puede diseñar la parte baja, otra puede diseñar la parte alta. Como tendrán la misma lógica interna, esto **reduce el riesgo de comportamientos distintos** entre partes.

---

#### ⚠ Desventajas
Las principales desventajas de este sistema modular son:  

- Al tener dos ALU16 (una para la parte alta `[16..31]` y otra para la baja `[0..15]`), el número queda "dividido", y el **carry** que genera la parte baja debe viajar a la adición de la parte alta **antes** de terminar el cálculo, generando **mayor tiempo de ejecución**.  

---

Esto sucede porque cuando sumas dos números de 32 bits en binario, realmente estás sumando dos mitades:

- **Parte baja** → bits 0 a 15  
- **Parte alta** → bits 16 a 31  

El problema es que una suma de 16 bits puede “desbordarse” (*overflow local*) y generar un bit extra que no cabe en esa parte baja: ese es el **carry-out**.  

Ese **carry-out** debe sumarse en la parte alta porque representa “un uno extra” que se debe añadir al bit 16.  
Si no lo propagas, cualquier suma que genere un acarreo desde el bit 15 dará un resultado incorrecto en la parte alta.

---

Otras desventajas:

- Se necesita **más lógica de interconexión**, más cableado y multiplexores para pasar las señales de control como el carry  
- **Mayor consumo de compuertas**: duplicar la lógica de control en cada módulo puede usar más que un diseño optimizado de 32 bits desde cero  
- **Coordinación de banderas**: la bandera `ZR` (cero) y `NG` (negativo) deben calcularse considerando ambas mitades, lo que implica más lógica de unión  
- **Posible desincronización de señales**: si no se maneja bien el *timing*, la parte alta podría leer un carry o señal de control erróneo en simulaciones o hardware real  

---

### 📌 Resumen Modularidad
- **Ventajas**: Reutiliza componentes probados (ALU16), facilita depuración y mantenimiento, reduce complejidad inicial, permite trabajo en paralelo, y es fácilmente escalable  
- **Desventajas**: Mayor latencia por propagación de carry, más lógica de interconexión, mayor consumo de compuertas, y riesgo de desincronización  
- **Justificación**: La modularidad permite escalar y mantener más fácilmente, aunque implica un pequeño coste en velocidad  

---
### 2️⃣ Signed vs. Unsigned
- **Signed (con signo)** → Overflow detectado comparando `carry-in` y `carry-out` del MSB  
- **Unsigned (sin signo)** → Overflow detectado solo con `carry-out`  
- Señal de control adicional para seleccionar modo  
- CPUs reales usan **bandera C** (carry) para unsigned y **V** (overflow) para signed  

---

### 3️⃣ Carry propagation
- **Ripple carry** → Lento, propagación secuencial bit a bit  
- **Carry-lookahead** → Calcula en paralelo generación y propagación  
  - ✅ Menor latencia  
  - ⚠ Más compuertas y consumo  

---

### 4️⃣ Optimización
- Compartir sumador para suma y resta  
- Multiplexores compartidos para selección de operaciones  
- Eliminar lógica redundante con álgebra booleana  
- Reutilizar señales ya calculadas  

---

### 5️⃣ Escalabilidad
- Diseño modular y parametrizable  
- Encadenar más ALU16 para 64 o 128 bits  
- Ajustar solo banderas y control  

---
# ⚙️ ALU de 32 bits (ALU32) – *Nand2Tetris*

> **Implementación modular de una ALU de 32 bits a partir de dos ALUs de 16 bits**  
> Compatible con operaciones aritméticas y lógicas, y con generación de banderas de estado.

---

## 📜 **Descripción general**
Este proyecto implementa una **ALU de 32 bits** usando **dos ALU16** como bloques básicos, siguiendo el enfoque modular de *Nand2Tetris*.  
La **ALU32** es capaz de realizar operaciones aritméticas y lógicas, y generar banderas:

- **ZR** → Resultado es cero  
- **NG** → Resultado negativo (signo en 1)  
- **OVERFLOW** → Desbordamiento en operaciones con signo  

---

## 🎛 **Entradas y salidas**

### 🔹 Entradas
- **`x[32]`** → Operando A (32 bits)  
- **`y[32]`** → Operando B (32 bits)  
- **`zx`** → Fuerza `x` a 0  
- **`nx`** → Niega `x` (NOT bit a bit)  
- **`zy`** → Fuerza `y` a 0  
- **`ny`** → Niega `y`  
- **`f`** → Selección: `0` = AND | `1` = ADD  
- **`no`** → Niega resultado final  

### 🔹 Salidas
- **`out[32]`** → Resultado de la operación  
- **`zr`** → `1` si `out` es cero  
- **`ng`** → `1` si el MSB (bit 31) es `1`  
- **`overflow`** → `1` si hay desbordamiento con signo  

---

## 🛠 **Diseño**
La ALU se divide en dos mitades:

- **Parte baja** *(bits 0–15)* → Calcula AND y ADD, genera `CarryOutLow`  
- **Parte alta** *(bits 16–31)* → Usa `CarryInHigh` proveniente de la parte baja para la suma  
- **`out[32]`** → Combinación de ambas mitades  
- **`zr` y `ng`** → Calculados a partir de todo el resultado  
- **`overflow`** → Detectado comparando `carry-in` y `carry-out` del bit 31  

---

## 🖼 **Diagrama**
![Diagrama ALU32](ALU32_anotada.png)

---

## 💭 **Preguntas de Pensamiento Crítico**

### 1️⃣ Modularidad  
**Ventajas y desventajas de usar dos ALU16 vs. una ALU32 monolítica**  

---

#### ✅ Ventajas
Las principales ventajas de usar dos ALU de 16 bits es que mayormente ya hemos trabajado con conexiones y compuertas de 16 bits, lo que facilita la **reutilización de componentes**, reduciendo la complejidad inicial.  

Un diseño modular (en vez de un bloque grande de 32 bits, dos bloques de 16 conectados) **facilita a futuro una implementación de un sistema de hardware mayor** como lo sería una ALU64, donde a simple vista sería seguir añadiéndole ALUs de 16 en cadena, ahorrando tiempo en desarrollo.  

Otro punto importante y ventaja es la **facilidad del trabajo en paralelo**: mientras una persona puede diseñar la parte baja, otra puede diseñar la parte alta. Como tendrán la misma lógica interna, esto **reduce el riesgo de comportamientos distintos** entre partes.

---

#### ⚠ Desventajas
Las principales desventajas de este sistema modular son:  

- Al tener dos ALU16 (una para la parte alta `[16..31]` y otra para la baja `[0..15]`), el número queda "dividido", y el **carry** que genera la parte baja debe viajar a la adición de la parte alta **antes** de terminar el cálculo, generando **mayor tiempo de ejecución**.  

---

Esto sucede porque cuando sumas dos números de 32 bits en binario, realmente estás sumando dos mitades:

- **Parte baja** → bits 0 a 15  
- **Parte alta** → bits 16 a 31  

El problema es que una suma de 16 bits puede “desbordarse” (*overflow local*) y generar un bit extra que no cabe en esa parte baja: ese es el **carry-out**.  

Ese **carry-out** debe sumarse en la parte alta porque representa “un uno extra” que se debe añadir al bit 16.  
Si no lo propagas, cualquier suma que genere un acarreo desde el bit 15 dará un resultado incorrecto en la parte alta.

---

Otras desventajas:

- Se necesita **más lógica de interconexión**, más cableado y multiplexores para pasar las señales de control como el carry  
- **Mayor consumo de compuertas**: duplicar la lógica de control en cada módulo puede usar más que un diseño optimizado de 32 bits desde cero  
- **Coordinación de banderas**: la bandera `ZR` (cero) y `NG` (negativo) deben calcularse considerando ambas mitades, lo que implica más lógica de unión  
- **Posible desincronización de señales**: si no se maneja bien el *timing*, la parte alta podría leer un carry o señal de control erróneo en simulaciones o hardware real  

---

### 📌 Resumen Modularidad
- **Ventajas**: Reutiliza componentes probados (ALU16), facilita depuración y mantenimiento, reduce complejidad inicial, permite trabajo en paralelo, y es fácilmente escalable  
- **Desventajas**: Mayor latencia por propagación de carry, más lógica de interconexión, mayor consumo de compuertas, y riesgo de desincronización  
- **Justificación**: La modularidad permite escalar y mantener más fácilmente, aunque implica un pequeño coste en velocidad  

---

### 2️⃣ Signed vs. Unsigned
- **Signed (con signo)** → Overflow detectado comparando `carry-in` y `carry-out` del MSB  
- **Unsigned (sin signo)** → Overflow detectado solo con `carry-out`  
- 🔀 Señal de control adicional para seleccionar el modo  
- 🖥 CPUs reales usan **bandera C** (carry) para unsigned y **V** (overflow) para signed  

---

### 3️⃣ Carry propagation
- **Ripple carry** → Lento, el carry se propaga bit por bit  
- **Carry-lookahead** → Calcula en paralelo generación y propagación del carry  
  - ✅ Ventaja: Menor latencia total  
  - ⚠ Desventaja: Más compuertas, más consumo  

---

### 4️⃣ Optimización
- 🔄 Compartir sumador para suma y resta  
- 🎛 Multiplexores compartidos para selección de operaciones  
- ✂ Eliminar lógica redundante con álgebra booleana  
- 🔌 Reutilizar señales ya calculadas  

---

### 5️⃣ Escalabilidad
- 🧩 Mantener diseño modular y parametrizable  
- ➕ Encadenar más ALU16 para 64 o 128 bits  
- ⚙ Ajustar solo lógica de banderas y control  

---
