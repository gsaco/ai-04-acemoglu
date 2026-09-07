# Dependencias de las pruebas

```mermaid
flowchart TD
  A[Normalizador e integral gaussiana] --> B[G prima = g; g prima negativa]
  P[Parámetros y Admissible] --> U[Pago y precisión]
  B --> D[Derivada del pago = marginal]
  U --> D
  B --> C[Derivadas cruzadas reales]
  D --> C
  C --> O[Observation 1: Delta I = 0]
  C --> E[Signos con Delta I mayor o igual a 0]
  D --> F[FOC]
  B --> K[Segunda derivada negativa]
  D --> K
  K --> N[Unicidad de raíz interior]
  H[Ecuaciones explícitas de FOC diferenciada] --> I[Signos condicionales de respuestas]
  B --> M[Pago creciente en precisión de IA]
  W[Testigos de máximos a X fijo] --> V[Comparación de bienestar estático]
  M --> V
  Z[Delta I = 0; X = 0] --> Z0[Cero domina todo esfuerzo positivo]
  Q[Delta I positiva; X = 0] --> Q0[Derivada positiva en cero]
  D --> Q0
  Q0 --> R[Existe una mejora con esfuerzo positivo]
```

Los nodos de ecuaciones diferenciadas y testigos maximizadores son **premisas**, no resultados demostrados por este proyecto. No hay nodos de recursión de precisión, equilibrio dinámico o bienestar de estado estacionario.

Los diez tipos públicos están en `PaperInterface.lean`; los resultados del tipo exacto están en `ProofInterface.lean`. El grafo resume dependencias matemáticas; no es una extracción automática de todas las declaraciones internas de Lean.
