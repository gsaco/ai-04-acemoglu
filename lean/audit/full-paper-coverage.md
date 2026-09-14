# Lean derivation verification and whole-paper coverage

Source: the repository's February 2026 version of Acemoglu, Kong and Ozdaglar, *AI, Human Cognition and Knowledge Collapse*, [w34910.pdf](../../w34910.pdf). Its SHA-256 is recorded in [source.json](source.json). This audit concerns that supplied version. Main-text page references below use the paper's printed numbering.

## What the existing formalization establishes

The project contains **ten public static proof endpoints**, not ten of the paper's numbered propositions. Observation 1 is formalized for positive public precision. Observation 2 is covered only by a conditional algebraic implication. **None of Propositions 1–16 is currently formalized.** The standalone-value extension is an original repository result, not a theorem attributed to the authors.

**Fresh validation passed on 14 September 2026:** all six project modules were rebuilt from source, and all ten public endpoints passed the axiom audit. There are no proof holes, local axioms or `native_decide` uses. The only axiom dependencies are the standard `propext`, `Classical.choice` and `Quot.sound`. No changes to the existing mathematical proofs were needed.

The executable check is `python3 lean/verify.py` from the repository root. The run's status, timestamp, Lean version, source hashes and axioms are in [validation.json](validation.json); the build and axiom outputs are in [build.log](build.log) and [axioms.log](axioms.log). Broken local dependency links were replaced with checkouts of the already-pinned package revisions; the manifest and Lean version were unchanged.

### Derivation-to-proof mapping

Lean notation: `q.prior` = $\sigma^{-2}$, `q.ell` = $\lambda_I$, `a` = $\tau_A$, and `precision q e a` = $Y$. All are real-valued; a real AI precision is finite. `Admissible q` requires $\Delta_G,\Delta_I\geq0$, $\Delta_X,\lambda_I,\sigma^{-2}>0$, $\Delta_G+\Delta_I+\Delta_X=1$, and $\alpha>1$.

| Derivation step | Formal evidence | Qualification |
|---|---|---|
| $Y=\sigma^{-2}+\lambda_Ie+\tau_A$ | `precision` in `Model.lean` | This is a definition; Gaussian signal aggregation has not been derived from a probability space. |
| $G(z)=2\Phi(\sqrt z)-1$ | `G` in `Gaussian.lean` is the corresponding normal-density integral from $0$ to $\sqrt z$ | The analytic integral is defined concretely. Its identification with posterior success probability is not a separate formal theorem. |
| $G'(z)=g(z)$ and $g'(z)=-(1+1/z)g(z)/2$ | `gaussianCalculus` | Both derivative identities and their signs are proved for $z>0$; they are not postulated. |
| $U_e=[\Delta_I+\Delta_XG(X)]\lambda_Ig(Y)-e^{\alpha-1}$ | `hasDerivAt_payoff_effort`; `firstOrderCondition` | Setting $\Delta_I=0$ gives the baseline FOC. The endpoint identifies stationarity; it does not prove optimizer existence. |
| $U_{eX}>0$, $U_{e\tau_A}<0$ | `observation1`; `generalizedObservation` | Actual nested derivatives of the payoff, holding effort fixed. Requires $X>0$, $e,\tau_A\geq0$ and admissible parameters. Signs survive with $\Delta_I>0$. |
| $U_{ee}<0$ and uniqueness | `curvature`; `stationaryUniqueness` | Curvature at $X,e>0$ and at most one positive stationary effort. No evaluation of singular cost curvature at zero. |
| $e_X>0$, $e_{\tau_A}<0$ | `conditionalResponseSigns` | Assumes the differentiated FOC equations. Existence and differentiability of an optimal branch remain unproved. |
| Baseline at $X=0$ | `baselineBoundary` | With $\Delta_I=0$, zero effort strictly dominates every positive effort. |
| Extension at $X=e=0$ | `extensionBoundary`, using `extension_boundary` and `extension_zero_not_optimal` | With $\Delta_I>0$, the marginal return is positive and there exists a feasible $e>0$ with strictly higher payoff than zero. |
| Higher optimized utility at fixed $X$ | `staticWelfare` | Assumes feasible maximizing choices exist; compares two accuracies with $X>0$ fixed. No steady-state welfare claim. |

The extension's boundary calculation is

$$U_e(0;0,\tau_A)=\Delta_I\lambda_Ig(\sigma^{-2}+\tau_A)>0.$$

The formal proof goes beyond this sign: it establishes $\exists e>0:\ U(e;0,\tau_A)>U(0;0,\tau_A)$. It does not characterize the new dynamic equilibria or establish monotone long-run welfare.

### Comparison with the supplied handwritten photograph

The photograph in `hand/derivation.jpg` shows the precision definition, Gaussian differentiation, logarithmic derivative, baseline FOC and two cross-partials. These match the analytic identities checked by Lean when the normal density is denoted by lowercase $\phi$ and the CDF by uppercase $\Phi$. Lean checks the formal statements, not optical recognition of the photograph. The photo does not yet display the fixed-variable labels, strict-sign assumptions, standalone-value boundary extension, or final welfare verdict requested by the handwritten checklist.

## Main-text coverage

“Not formalized” describes repository coverage; it is not a claim that a paper result is false.

| Paper result | Location | Current coverage / work needed |
|---|---|---|
| Information and expected payoff construction | §§3.1–3.3, pp. 7–12 | Analytic payoff is encoded. Still need posterior construction, independent signals, posterior-mean optimality for the tolerance payoff, factorization of joint success, and the Kalman update. |
| Observation 1 | §3.4, p. 13 | Proved for the translated static payoff with explicit positive-precision conditions. |
| Static optimizer and Observation 2 | §3.5, p. 14 | FOC, curvature and at-most-one stationary point proved; response signs conditional. Still need a global maximizer, interiority for $X>0$, continuity and actual monotone comparative statics of the best response. |
| Proposition 1 | p. 15 | Not formalized: unique symmetric equilibrium path, Bayesian consistency and recursive characterization. A deterministic recursion alone would not prove Perfect Bayesian equilibrium. |
| Lemma 1 | p. 16 | Not formalized: continuity, strict monotonicity, zero boundary and upper limit of the transition map. |
| Proposition 2 | p. 16 | Not formalized: transition-map comparative statics in aggregation and AI accuracy. |
| Lemma 2 | p. 17 | Not formalized: local stability/instability of zero from the $\alpha-1\gtrless1/4$ comparison. |
| Proposition 3 | p. 18 | Not formalized: exactly zero and one positive steady state, their stability, and convergence from every positive initial precision when $\alpha-1>1/4$. |
| Proposition 4 | p. 19 | Not formalized: steady-state precision and effort comparative statics in that regime. |
| Proposition 5 | p. 20 | Not formalized: collapse threshold, positive fixed points, stability and basins when $0<\alpha-1<1/4$. |
| Proposition 6 | p. 21 | Not formalized: collapse-threshold comparative statics in aggregation and complementarity. |
| Proposition 7 | p. 22 | Not formalized: movement of the unstable basin threshold. |
| Proposition 8 | p. 22 | Not formalized: high-branch comparative statics, including the change in direction of individual precision. |
| Proposition 9 | p. 24 | Not formalized: high-steady-state welfare increases with aggregation. |
| Proposition 10 | p. 26 | Not formalized: high-branch welfare shape and zero limit in the $\alpha-1>1/4$ regime, under Assumption 2. |
| Proposition 11 | p. 26 | Not formalized: welfare optimum below the collapse threshold and collapse welfare in the multiple-state regime, under Assumption 2 and an available high branch. |
| Proposition 12 | p. 27 | Not formalized: logarithmic asymptotics of the accuracy thresholds as aggregation increases. |
| Proposition 13 | p. 28 | Not formalized: Gaussian garbling, a long-run-average welfare objective, and optimality of a two-phase policy among eventually constant policies. |
| Proposition 14 | p. 30 | Not formalized: AI-dependent aggregation, the stated growth restriction, and the high-knowledge limit / finite welfare optimum. |
| Proposition 15 | p. 31 | Not formalized: positive extremal steady states with synthetic information and their comparative statics. |
| Proposition 16 | p. 32 | Not formalized: public effort input $e^\beta$, modified stability regimes, threshold asymptotics and the other claimed extensions of baseline results. |

Sections 1–2 and 6 provide motivation, literature and interpretation rather than additional numbered mathematical propositions. Lean proofs do not establish those empirical or interpretive claims.

## Appendix dependencies still missing

These are proof dependencies, not extra completed endpoints. Use appendix identifiers as well as PDF page numbers because Appendix B has its own printed numbering.

| Lemma | PDF page | Required content |
|---|---:|---|
| A-1 | 41 | Sign equivalence between the effort-based steady-state equation and $F(X)-X$. |
| A-2 | 42 | Strict log-concavity of steady-state marginal benefit in log effort. |
| A-3 | 46 | Monotonicity, limits and asymptotic expansions of $G(W(E))$ and its derivative. |
| A-4 | 48 | Strictly decreasing elasticity $R(E)$ and its $1/4$ boundary limit. |
| A-5 | 50 | Exact high-steady-state effort response to AI accuracy in terms of $R(I\bar e_h)$ and individual precision. |
| B-1 | 55 | Monotonicity of the indirect/direct welfare-effect ratio under the prior-precision restriction. |
| B-2 | 57 | High-branch denominator and logarithmic-derivative bounds near collapse. |
| B-3 | 58 | Monotonicity of the product used to establish the welfare ratio's behavior near collapse. |

## What full-paper formalization would require

1. **Finish the static choice problem.** Prove a finite global maximizer exists, is unique and interior at $X>0$, and define the best-response function from that theorem. Prove its continuity and actual comparative statics; replace the conditional response-sign endpoint with a theorem about that function. This also removes supplied-maximizer premises from the static welfare result.
2. **Connect analytic utility to the information economy.** Formalize posterior beliefs, tolerance-payoff optimality, independent-information aggregation and the common-state variance update. Define equilibrium and verify Proposition 1 against it.
3. **Build the dynamic map with a correct zero boundary.** For $u=X+\lambda_G I e$, use $u/(1+\Sigma^2u)$ on the nonnegative domain. It equals $[\Sigma^2+u^{-1}]^{-1}$ for $u>0$ and has the intended value zero at $u=0$. Lean's real inverse satisfies $0^{-1}=0$, so naively translating the nested inverse at zero gives the wrong state transition. Prove the equivalence on the positive domain and use the continuous extension at zero.
4. **Prove fixed-point geometry and convergence.** Establish the appendix lemmas, Lemmas 1–2 and Propositions 2–8. Specify basins, threshold existence and all limiting arguments precisely.
5. **Prove steady-state welfare and policy.** Establish the branch dependence on accuracy, Assumption 2's role, welfare limits, threshold asymptotics and the restricted policy optimization in Propositions 9–13.
6. **Formalize each extension separately.** Define AI-dependent aggregation, synthetic information and public input $e^\beta$, then prove Propositions 14–16 with their own assumptions. The repository's $\Delta_I>0$ exercise does not substitute for these three extensions.

Preserve the source's boundary qualifications: $\alpha-1=1/4$ is outside the strict regimes; Proposition 5 states strict inequalities around $\tau_A^c$; a threshold may be zero; Propositions 10–11 allow a zero welfare-maximizing accuracy; and Proposition 13 covers eventually constant policies rather than arbitrary policies. Any additional assumption needed to make a formal statement true must be recorded as a qualification, not silently added.

## Recommended slide claim

“Lean checks ten static proof endpoints, including the derivation and the standalone-value boundary test, with no proof holes or added axioms. Both cross-partial signs survive; positive standalone value makes zero effort suboptimal at zero public knowledge. This is a partial static formalization: the paper's sixteen dynamic, welfare and extension propositions remain outside the proof coverage.”

The detailed correspondence with the paper is an authoring review; Lean verifies the encoded implications, not that semantic correspondence itself.
