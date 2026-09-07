# Comprobación Lean del problema estático

**Acemoglu, Kong y Ozdaglar (2026), _AI, Human Cognition and Knowledge Collapse_.** Diez resultados con pruebas comprobadas por Lean, sin `sorry`, sin `admit` y sin axiomas propios. El alcance es una **formalización parcial del paper, centrada en el problema estático**; no se formalizan las secciones dinámicas.

La organización toma como inspiración [EconCSLib](https://gargnikhil.com/EconCSLib/) y [tu tarea ai-03-quispe](https://github.com/gsaco/ai-03-quispe): enunciados transparentes, pruebas separadas, mapa de correspondencia con el paper e informe de validación. Este es un proyecto autónomo sobre mathlib, **no** una contribución a EconCSLib ni una ejecución de su sistema completo de auditoría.

## Qué está comprobado

| Resultado | Prueba pública | Alcance exacto |
|---|---|---|
| Cálculo gaussiano | `gaussianCalculus` | Se construye $G$ mediante una integral; se prueban $G'=g$, $g'=gprime$, $G>0$, $g>0$ y $gprime<0$ para precisión positiva. |
| Observation 1 | `observation1` | Fórmulas y signos de las derivadas cruzadas **del pago real**, bajo $\Delta_I=0$, $X>0$ y los supuestos declarados. |
| Extensión de los signos | `generalizedObservation` | Los signos persisten con $\Delta_I\geq0$, incluido $\Delta_I>0$. |
| FOC | `firstOrderCondition` | La derivada se anula si y solo si se cumple la ecuación de retorno marginal igual a costo marginal. |
| Curvatura | `curvature` | Segunda derivada del pago estrictamente negativa para esfuerzo positivo. |
| Unicidad interior | `stationaryUniqueness` | A lo sumo un esfuerzo positivo satisface la FOC. No demuestra existencia del máximo. |
| Respuestas del esfuerzo | `conditionalResponseSigns` | Signos deducidos de la FOC **ya diferenciada**, condicionales a esas ecuaciones. No demuestra el teorema de la función implícita. |
| Bienestar estático | `staticWelfare` | A $X>0$ fijo, una precisión de IA mayor aumenta estrictamente el valor máximo, dadas elecciones maximizadoras factibles. No es bienestar de estado estacionario. |
| Frontera basal | `baselineBoundary` | Con $X=0$ y $\Delta_I=0$, elegir cero domina estrictamente cualquier esfuerzo positivo. |
| Frontera con $\Delta_I>0$ | `extensionBoundary` | La derivada en cero es positiva y **existe** un esfuerzo positivo que mejora el pago. |

El último resultado distingue el mecanismo robusto de sustitución de la premisa que sostiene el esfuerzo exactamente cero. No afirma que la IA siempre mejore el bienestar de largo plazo.

## Cómo leer la carpeta

1. [Informe de validación](FINAL_VALIDATION_REPORT.md): resultados, límites y evidencia.
2. [PaperInterface.lean](PaperInterface.lean): los diez enunciados a contrastar con el paper.
3. [Assumptions.lean](Assumptions.lean): parámetros y premisas económicas explícitas.
4. [Mapa paper → Lean](audit/statement-map.md) y [diagrama de dependencias](docs/DependencyDAG.md).
5. [ProofInterface.lean](ProofInterface.lean): pruebas del tipo exacto de cada enunciado.

Las implementaciones están en [Gaussian.lean](Gaussian.lean), [Model.lean](Model.lean) y [MainTheorems.lean](MainTheorems.lean). [Audit.lean](Audit.lean) comprueba ejemplos de parámetros admisibles y lista los axiomas de los diez resultados. [La explicación matemática](docs/FORMALIZATION_NOTES.md) aclara la traducción entre notaciones.

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

En esta máquina se reutilizó la caché local de mathlib de EconCSLib mediante enlaces dentro de `.lake/`, que no se versiona. Los archivos públicos no necesitan esas rutas: una instalación nueva descarga las revisiones fijadas en el manifiesto.

**Límite de confianza:** Lean verifica los enunciados escritos. La correspondencia económica con el paper está documentada y revisada por el agente autor, pero no certificada por un revisor humano independiente. El PDF fuente está identificado por SHA-256 en [audit/source.json](audit/source.json).
