# Comprobación Lean del problema estático

**Acemoglu, Kong y Ozdaglar (2026), _AI, Human Cognition and Knowledge Collapse_.** Diez resultados con pruebas comprobadas por Lean, sin `sorry`, sin `admit` y sin axiomas propios. El alcance es una **formalización parcial del paper, centrada en el problema estático**; no se formalizan las secciones dinámicas.

Proyecto Lean sobre mathlib que separa los enunciados económicos, las demostraciones y los registros de validación.

## Qué está comprobado

| Resultado | Prueba pública | Alcance exacto |
|---|---|---|
| Cálculo gaussiano | `gaussianCalculus` | Se construye la función gaussiana mediante una integral y se demuestran sus derivadas y signos para precisión positiva. |
| Observation 1 | `observation1` | Derivadas cruzadas del pago basal, con conocimiento público positivo y los supuestos declarados. |
| Extensión de los signos | `generalizedObservation` | Los signos persisten cuando la información contextual tiene valor propio. |
| FOC | `firstOrderCondition` | La derivada se anula si y solo si se cumple la ecuación de retorno marginal igual a costo marginal. |
| Curvatura | `curvature` | Segunda derivada del pago estrictamente negativa para esfuerzo positivo. |
| Unicidad interior | `stationaryUniqueness` | A lo sumo un esfuerzo positivo satisface la FOC. No demuestra existencia del máximo. |
| Respuestas del esfuerzo | `conditionalResponseSigns` | Signos deducidos de la FOC **ya diferenciada**, condicionales a esas ecuaciones. No demuestra el teorema de la función implícita. |
| Bienestar estático | `staticWelfare` | Con conocimiento público positivo y fijo, una IA más precisa aumenta el valor máximo, dadas elecciones maximizadoras factibles. No es bienestar de estado estacionario. |
| Frontera basal | `baselineBoundary` | Sin conocimiento público ni valor autónomo de la información contextual, cero esfuerzo domina cualquier esfuerzo positivo. |
| Frontera de la extensión | `extensionBoundary` | La derivada en cero es positiva y **existe** un esfuerzo positivo que mejora el pago. |

El último resultado distingue el mecanismo robusto de sustitución de la premisa que sostiene el esfuerzo exactamente cero. No afirma que la IA siempre mejore el bienestar de largo plazo.

## Estructura de la carpeta

| Archivo o carpeta | Función |
|---|---|
| [PaperInterface.lean](PaperInterface.lean) | Los diez enunciados formales, separados de sus pruebas. |
| [ProofInterface.lean](ProofInterface.lean) | Una demostración del tipo exacto de cada enunciado. |
| [Assumptions.lean](Assumptions.lean) | Parámetros y condiciones económicas. |
| [Gaussian.lean](Gaussian.lean) | Integral gaussiana, derivadas y signos. |
| [Model.lean](Model.lean) | Pago, precisión y retorno marginal del esfuerzo. |
| [MainTheorems.lean](MainTheorems.lean) | Demostraciones de los resultados estáticos y de la extensión. |
| [Audit.lean](Audit.lean) | Ejemplos de parámetros admisibles y revisión de axiomas. |
| [verify.py](verify.py) | Compilación y comprobación reproducible. |
| [audit/](audit/statement-map.md) | Correspondencia con el paper, fuente, resultados y registros de validación. |
| [docs/](docs/FORMALIZATION_NOTES.md) | Explicación matemática y [dependencias de las pruebas](docs/DependencyDAG.md). |
| [FINAL_VALIDATION_REPORT.md](FINAL_VALIDATION_REPORT.md) | Resumen de resultados y límites de la formalización. |
| [status.json](status.json) | Estado y alcance en formato legible por programas. |
| Configuración de Lean y Lake | Versiones fijadas en `lean-toolchain`, `lakefile.toml` y `lake-manifest.json`. |

Para revisar los resultados, empezar por el informe de validación y continuar con los enunciados de `PaperInterface.lean`. Las pruebas detalladas están en los archivos de implementación.

## Reproducir

Requiere Lean mediante [elan](https://github.com/leanprover/elan) y Python 3. El archivo `lean-toolchain` fija Lean `v4.30.0-rc2`; el manifiesto fija mathlib y sus dependencias.

En una copia nueva, desde la raíz de este repositorio:

```sh
cd lean
lake exe cache get
python3 verify.py
```

Para repetir la comprobación con dependencias ya disponibles, también funciona desde la raíz:

```sh
python3 lean/verify.py
```

El verificador compila las pruebas con advertencias tratadas como errores, comprueba los diez listados de axiomas y guarda [el resultado](audit/validation.json), [la compilación](audit/build.log) y [los axiomas](audit/axioms.log). Las únicas dependencias axiomáticas admitidas son las estándar de Lean/mathlib: `propext`, `Classical.choice` y `Quot.sound`. No se usa `native_decide`.

Las dependencias y los archivos compilados se guardan en `.lake/`, que no se versiona. Una instalación nueva descarga las revisiones fijadas en el manifiesto.

**Alcance:** Lean comprueba las demostraciones de los enunciados escritos. La correspondencia con el paper se documenta por separado en [el mapa de resultados](audit/statement-map.md). El PDF fuente está identificado por SHA-256 en [audit/source.json](audit/source.json).
