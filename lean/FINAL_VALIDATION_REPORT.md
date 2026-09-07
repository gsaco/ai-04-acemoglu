# Informe de validación Lean

## Resultado

**Diez enunciados públicos comprobados, sin huecos ni axiomas añadidos. Estado global: formalización parcial del paper, de alcance estático.** La compilación y la auditoría reproducible se registran en [audit/validation.json](audit/validation.json). La validación se refiere a los hashes de archivos guardados allí.

Los enunciados están en `PaperInterface.lean`, las pruebas correspondientes en `ProofInterface.lean` y la evidencia de validación en `audit/`. La dependencia matemática es mathlib, con versión y revisión fijadas.

## Comprobaciones ejecutadas

1. Compilación de todos los módulos mediante `lake build`, con `warningAsError = true`.
2. Pruebas del tipo exacto de los diez `Spec` transparentes de `PaperInterface.lean`.
3. Auditoría de las dependencias axiomáticas de cada resultado mediante `#print axioms`.
4. Rechazo de `sorry`, `admit`, declaraciones `axiom` y `native_decide` en el código local.
5. Ejemplos de parámetros admisibles para el caso basal y la extensión: las hipótesis no son contradictorias. En la extensión se instancia además la existencia de una mejora factible.
6. Identificación SHA-256 del PDF suministrado y de los archivos de código/configuración comprobados.

Solo aparecen los axiomas estándar `propext`, `Classical.choice` y `Quot.sound`. No hay axiomas económicos globales: las condiciones económicas se pasan explícitamente como premisas de los teoremas.

## Contenido matemático

Se formalizan la integral gaussiana, su derivada y curvatura, la FOC, las derivadas cruzadas del pago, su persistencia bajo $\Delta_I>0$, la curvatura del pago, la unicidad de una raíz interior de la FOC, la comparación estática de bienestar con testigos maximizadores y los dos resultados de frontera.

El hallazgo de la extensión está comprobado en una forma directamente relevante para la elección: bajo $X=0$ y $\Delta_I>0$, existe un esfuerzo positivo que paga más que cero. No se trata solamente de asignar un signo a una fórmula.

## Condiciones que no deben desaparecer al presentar el resultado

- Los signos estrictos de Observation 1 requieren $X>0$ y los supuestos productivos/de precisión declarados. El caso $X=0$ tiene tratamiento separado.
- `stationaryUniqueness` es “a lo sumo una raíz positiva”, no existencia y unicidad global del óptimo.
- `conditionalResponseSigns` supone la FOC diferenciada; no demuestra una rama óptima diferenciable ni el teorema de la función implícita completo para este modelo.
- `staticWelfare` mantiene fijo $X$ y supone máximos factibles existentes. No demuestra monotonía del bienestar dinámico.
- La integral representa la función gaussiana utilizada en el paper, pero no se construye el espacio de probabilidad ni el posterior bayesiano.
- La afirmación textual de que §5 no relaja $\Delta_I=0$ se apoya en la lectura del paper; no es un teorema Lean sobre el contenido de un PDF.

No se formalizan estados estacionarios, umbrales, estabilidad, resultados de bienestar de largo plazo ni política de información. Se conserva así el alcance de lectura solicitado para las secciones dinámicas.

## Evidencia y revisión

- [Mapa de correspondencia](audit/statement-map.md).
- [Fuente y referencias fijadas](audit/source.json).
- [Explicación de la traducción](docs/FORMALIZATION_NOTES.md).
- [Dependencias matemáticas](docs/DependencyDAG.md).
- [Registro de compilación](audit/build.log).
- [Axiomas por resultado](audit/axioms.log).
- [Verificador ejecutable](verify.py).

Lean certifica las implicaciones formales. El mapa de correspondencia permite contrastar cada enunciado con el paper; no constituye una certificación independiente de esa correspondencia ni una validación empírica.
