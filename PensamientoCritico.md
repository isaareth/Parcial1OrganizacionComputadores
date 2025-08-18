# Preguntas de Pensamiento Crítico

## 1. Modularidad

**Pregunta:** Ventajas y desventajas de usar dos ALU16 vs. una ALU32 monolítica

### Ventajas

Las principales ventajas de usar dos ALU de 16 bits es que mayormente ya hemos trabajado con conexiones y compuertas de 16 bits, lo que facilita la **reutilización de componentes**, reduciendo la complejidad inicial.

Un diseño modular (en vez de un bloque grande de 32 bits, dos bloques de 16 conectados) **facilita a futuro una implementación de un sistema de hardware mayor** como lo sería una ALU64, donde a simple vista sería seguir añadiéndole ALUs de 16 en cadena, ahorrando tiempo en desarrollo.

Otro punto importante y ventaja es la **facilidad del trabajo en paralelo**: mientras una persona puede diseñar la parte baja, otra puede diseñar la parte alta. Como tendrán la misma lógica interna, esto **reduce el riesgo de comportamientos distintos** entre partes.

### Desventajas

Las principales desventajas de este sistema modular son:

- Al tener dos ALU16 (una para la parte alta `[16..31]` y otra para la baja `[0..15]`), el número queda "dividido", y el **carry** que genera la parte baja debe viajar a la adición de la parte alta **antes** de terminar el cálculo, generando **mayor tiempo de ejecución**.

Esto sucede porque cuando sumas dos números de 32 bits en binario, realmente estás sumando dos mitades:

- **Parte baja** → bits 0 a 15
- **Parte alta** → bits 16 a 31

El problema es que una suma de 16 bits puede "desbordarse" (*overflow local*) y generar un bit extra que no cabe en esa parte baja: ese es el **carry-out**.

Ese **carry-out** debe sumarse en la parte alta porque representa "un uno extra" que se debe añadir al bit 16. Si no lo propagas, cualquier suma que genere un acarreo desde el bit 15 dará un resultado incorrecto en la parte alta.

**Otras desventajas:**

- Se necesita **más lógica de interconexión**, más cableado y multiplexores para pasar las señales de control como el carry
- **Mayor consumo de compuertas**: duplicar la lógica de control en cada módulo puede usar más que un diseño optimizado de 32 bits desde cero
- **Coordinación de banderas**: la bandera `ZR` (cero) y `NG` (negativo) deben calcularse considerando ambas mitades, lo que implica más lógica de unión
- **Posible desincronización de señales**: si no se maneja bien el *timing*, la parte alta podría leer un carry o señal de control erróneo en simulaciones o hardware real

### Resumen de Modularidad

- **Ventajas**: Reutiliza componentes probados (ALU16), facilita depuración y mantenimiento, reduce complejidad inicial, permite trabajo en paralelo, y es fácilmente escalable
- **Desventajas**: Mayor latencia por propagación de carry, más lógica de interconexión, mayor consumo de compuertas, y riesgo de desincronización
- **Justificación**: La modularidad permite escalar y mantener más fácilmente, aunque implica un pequeño coste en velocidad

---

## 2. Signed vs. Unsigned

**Pregunta:** Cambios necesarios para soportar ambos tipos de operaciones

---

## 3. Carry Propagation

**Pregunta:** Cómo implementarías un carry-lookahead y qué implicaciones tendría

---

## 4. Optimización

**Pregunta:** Si tu diseño actual consume demasiadas compuertas lógicas, ¿qué técnicas aplicarías para reducir el uso de hardware sin perder funcionalidad?

---

## 5. Escalabilidad

**Pregunta:** Estrategia para extender el diseño a 64 o 128 bits sin reescribir todo
