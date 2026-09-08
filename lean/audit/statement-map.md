# Correspondencia paper → enunciados → pruebas

Fuente: PDF suministrado `w34910.pdf`, NBER WP 34910, febrero de 2026. Huella en `source.json`. Las páginas son las impresas; el visor del PDF suma dos páginas de portada y resumen.

| Enunciado público | Fuente / origen | Premisas y frontera semántica | Estado |
|---|---|---|---|
| `gaussianCalculusSpec` | §3.3, p. 12; §3.4, p. 13 | Construcción integral gaussiana concreta. La identificación probabilística con la posterior no está formalizada. | Prueba exacta |
| `observation1Spec` | Observation 1, p. 13; Assumption 1, p. 8 | $\Delta_I=0$, $X>0$, $a,e\geq0$, `Admissible`. Derivadas anidadas del pago, fórmulas y signos. | Prueba exacta del resultado estático traducido |
| `generalizedObservationSpec` | Extensión propia del repositorio | `Admissible` permite $\Delta_I\geq0$; se retiene $\Delta_X>0$. No se atribuye al paper. | Prueba exacta |
| `firstOrderConditionSpec` | §3.5, p. 14 | Ecuación de estacionariedad de la extensión; $\Delta_I=0$ recupera la del paper. No basta por sí sola para afirmar existencia del máximo. | Prueba exacta |
| `curvatureSpec` | §3.5, p. 14 | Segunda derivada negativa para $X,e>0$. No se evalúa la segunda derivada del costo en cero. | Prueba exacta |
| `stationaryUniquenessSpec` | Argumento de unicidad, §3.5, p. 14 | A lo sumo una raíz interior; **no** cubre la parte de existencia del óptimo. | Prueba exacta, cobertura parcial del argumento del paper |
| `conditionalResponseSignsSpec` | Paso algebraico detrás de Observation 2, p. 14 | Se exigen las dos ecuaciones de la FOC diferenciada. No se demuestra la existencia de una rama diferenciable. | Condicional explícito; no es Observation 2 completa |
| `staticWelfareSpec` | Cálculo estático de este repositorio a partir de eq. (6) | $X>0$ fijo y dos testigos maximizadores factibles. No es Proposición 10 ni 11. | Prueba exacta, condicionada a máximos existentes |
| `baselineBoundarySpec` | Nota al pie 4, p. 14 | $X=0$, $\Delta_I=0$, $\alpha>1$. Prueba de dominancia estricta de cero sobre cualquier esfuerzo positivo. | Prueba exacta |
| `extensionBoundarySpec` | Extensión propia del repositorio | $X=0$, $\Delta_I>0$, precisión real finita no negativa. Retorno marginal positivo y existencia de una mejora factible. | Prueba exacta |

## Material deliberadamente fuera de alcance

- §2: revisión de literatura, no un resultado para demostrar. El problema estático de esta versión está en §3.
- §§3.1–3.3: construcción probabilística de la posterior, independencia de señales, optimalidad de la media posterior y derivación de la utilidad esperada desde un espacio de probabilidad.
- §3.5: existencia global del máximo y diferenciabilidad del argmáximo.
- §§3.6–3.8: estados estacionarios, estabilidad, cuencas y umbrales de colapso.
- §4: bienestar de estado estacionario, resultados de precisión óptima, asintóticos y política de información.
- §5: no se reproducen los teoremas dinámicos de las extensiones. La lectura que identifica $\Delta_I=0$ como supuesto no relajado es una auditoría textual, no una prueba Lean.

## Registro de decisiones

- Se usa la representación integral de $G$, evitando postular sus derivadas o sus signos.
- La extensión está etiquetada como propia y preserva la normalización productiva.
- No se oculta el problema de frontera $X=0$: se trata con dos enunciados separados.
- “Diez pruebas completadas” significa diez tipos declarados demostrados. No significa todo el paper formalizado, ni equivalencia semántica certificada por un tercero.
- El mapa documenta la correspondencia con la fuente; no registra una certificación independiente de esa correspondencia.
