# Traducción matemática y alcance

## Notación y construcción concreta

`q : Parameters` contiene `ΔG`, `ΔI`, `ΔX`, `ell`, `prior`, `α`. Aquí `ell` corresponde a $\lambda_I$ y `prior` a $\sigma^{-2}$; `a` corresponde a $\tau_A$. No se introduce el tamaño de isla $I$, porque no aparece directamente en la elección estática con $X$ fijo.

Los supuestos de `Admissible q` son

$$\Delta_G\geq0,\quad\Delta_I\geq0,\quad\Delta_X>0,\quad
\Delta_G+\Delta_I+\Delta_X=1,\quad\lambda_I>0,\quad\sigma^{-2}>0,\quad\alpha>1.$$

Son campos de una proposición que se exige en cada resultado, no postulados globales. La versión basal agrega $\Delta_I=0$. La extensión exige $\Delta_I>0$ en el resultado de frontera. La normalización y $\Delta_G\geq0$ conservan la interpretación productiva, aunque algunos lemas de cálculo necesitan menos premisas.

Se define

$$c=\frac1{\sqrt{2\pi}},\qquad
G(z)=2c\int_0^{\sqrt z}e^{-u^2/2}\,du,\qquad
g(z)=\frac{ce^{-z/2}}{\sqrt z},\qquad
gprime(z)=-\frac{1+1/z}{2}g(z).$$

Para $z>0$, esta es la forma integral de $2\Phi(\sqrt z)-1$. Lean construye la integral y demuestra sus derivadas con el teorema fundamental del cálculo, la derivada de la raíz y la regla de la cadena. No se asumen las identidades de derivación. Se prueba también la positividad de $G$ mediante la positividad de la integral.

**Frontera de traducción:** este proyecto no construye un espacio de probabilidad ni demuestra que una probabilidad posterior de éxito condicional es igual a esa integral. Tampoco formaliza la independencia de señales ni la optimalidad de la media posterior. Esas conexiones son la interpretación de §§3.1–3.3 del paper. La equivalencia de la representación integral con la notación $\Phi$ se explica aquí, pero no hay un teorema separado sobre una CDF en Lean. `G` y `g` quedan definidos sobre todos los reales porque las derivadas se expresan con funciones reales; los resultados de signo restringen sus argumentos a precisiones positivas.

## Pago y derivadas reales

El pago formalizado es la extensión

$$U(e;X,a)=\Delta_GG(X)+[\Delta_I+\Delta_XG(X)]G(Y)-e^\alpha/\alpha,
\qquad Y=\sigma^{-2}+\lambda_I e+a.$$

Restablecer el término $\Delta_IG(Y)$ permite usar el mismo modelo para el paper y para la prueba de robustez. El pago basal se obtiene imponiendo $\Delta_I=0$; el término constante $f(0,0)$ se omite, como en las notas del repositorio.

`marginal` es la expresión

$$U_e=[\Delta_I+\Delta_XG(X)]\lambda_Ig(Y)-e^{\alpha-1}.$$

El teorema `hasDerivAt_payoff_effort` demuestra que es efectivamente la derivada del pago. `cross_public` y `cross_agentic` prueban después las igualdades para **derivadas anidadas de `payoff`**, no para símbolos a los que se les asignan signos. Para la precisión de IA se usa una igualdad local en un entorno donde $Y$ permanece positivo; no se extiende indebidamente la restricción $a\geq0$ a todos los reales al diferenciar.

La segunda derivada del pago es negativa con $X>0$ y $e>0$. Eso permite probar que la derivada marginal es estrictamente decreciente y que hay a lo sumo una raíz positiva de la FOC. La existencia de esa raíz y un teorema global de existencia del máximo no están formalizados. Por tanto, la unicidad no se presenta como una prueba completa de existencia y unicidad del óptimo del paper.

## Observation 2: resultado condicional

La inferencia

$$U_{ee}e_X+U_{eX}=0,\qquad U_{ee}e_a+U_{ea}=0
\quad\Longrightarrow\quad e_X>0,\ e_a<0$$

se demuestra por álgebra de orden bajo $U_{ee}<0$, $U_{eX}>0$ y $U_{ea}<0$. Las dos ecuaciones de la FOC diferenciada son hipótesis explícitas de `conditionalResponseSignsSpec`.

Esto verifica el paso de signos que se utiliza en la exposición, pero **no** construye la función óptima $e^*(X,a)$, no demuestra que sea diferenciable y no invoca una prueba formal del teorema de la función implícita para este modelo. El nombre y el informe mantienen visible esa limitación.

## Bienestar estático sin confundirlo con el dinámico

Para un esfuerzo factible fijo, Lean demuestra que $a\mapsto U(e;X,a)$ es estrictamente creciente en $[0,\infty)$ si $X>0$. Si $e_1,e_2$ son máximos factibles a precisiones $a<b$, entonces

$$U(e_1;X,a)<U(e_1;X,b)\leq U(e_2;X,b).$$

La comparación usa máximos como testigos explícitos, por lo que no requiere diferenciar el argmáximo ni suponer una fórmula del teorema de la envolvente. La prueba de implementación es incluso más fuerte: basta que $e_1$ sea factible y $e_2$ maximice al nuevo nivel. El enunciado público conserva ambos máximos para que la interpretación sea clara.

No aparece $\bar X(a)$ ni se resuelven estados estacionarios. No se demuestra en Lean la no monotonía del bienestar de largo plazo, una precisión óptima interior o una política de regulación. Esos resultados permanecen en el material de lectura del repositorio, con sus condiciones.

## El resultado de frontera y el aporte propio

Bajo $X=0$ y $\Delta_I=0$, el pago es $-e^\alpha/\alpha$. Lean demuestra que $e=0$ paga cero y que todo $e>0$ paga estrictamente menos. No hacen falta estados estacionarios para este resultado estático.

Si $\Delta_I>0$ y $a\geq0$ es real finito,

$$U_e(0;0,a)=\Delta_I\lambda_Ig(\sigma^{-2}+a)>0.$$

Lean demuestra además que existe $e>0$ con $U(e;0,a)>U(0;0,a)$. Usa la definición de derivada como límite de pendientes por la derecha: una pendiente límite positiva implica una mejora factible para algún incremento positivo. Así, no se confunde una derivada positiva con una afirmación no demostrada sobre la elección restringida a $e\geq0$.

Este resultado no demuestra que exista un óptimo positivo para todos los parámetros, ni caracteriza la dinámica de la extensión. Sí basta para excluir que cero sea un máximo estático cuando $X=0$ y $\Delta_I>0$.

## Revisión semántica

La comparación con §5 indica que los autores modifican la agregación, la información sintética y la tecnología de esfuerzo público, pero no dan valor productivo autónomo a la información contextual. Ese es un resultado de **lectura del documento**, no un teorema que Lean pueda certificar a partir de los axiomas matemáticos. La revisión de correspondencia en `audit/statement-map.md` es del mismo agente que escribió las pruebas; no se presenta como una auditoría humana o multiagente independiente.
