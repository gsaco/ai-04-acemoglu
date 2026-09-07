import Model

/-! Read this file against the paper before reading proofs.
Specifications are transparent propositions, and do not import implementation proofs.
This is a selected STATIC formalization, not a full-paper formalization.
-/
noncomputable section
namespace AKO26

/-- Gaussian calculus underlying §3.4. G is the explicit normal-density integral
in Gaussian.lean, not a success function constrained by assumed derivatives. -/
def gaussianCalculusSpec : Prop :=
  ∀ z : ℝ, 0 < z →
    HasDerivAt G (g z) z ∧ HasDerivAt g (gprime z) z ∧
    0 < G z ∧ 0 < g z ∧ gprime z < 0

/-- Observation 1, p. 13: actual mixed payoff derivatives with baseline ΔI = 0.
X = 0 is deliberately excluded from the strict-sign claim. -/
def observation1Spec : Prop :=
  ∀ (q : Parameters), Admissible q → q.ΔI = 0 →
    ∀ X a e : ℝ, 0 < X → 0 ≤ a → 0 ≤ e →
    deriv (fun x => deriv (payoff q x a) e) X =
      q.ΔX * q.ell * g X * g (precision q e a) ∧
    deriv (fun t => deriv (payoff q X t) e) a =
      q.ΔX * G X * q.ell * gprime (precision q e a) ∧
    0 < deriv (fun x => deriv (payoff q x a) e) X ∧
    deriv (fun t => deriv (payoff q X t) e) a < 0

/-- Own extension: the strict signs persist with ΔI ≥ 0, including ΔI > 0. -/
def generalizedObservationSpec : Prop :=
  ∀ (q : Parameters), Admissible q →
    ∀ X a e : ℝ, 0 < X → 0 ≤ a → 0 ≤ e →
    0 < deriv (fun x => deriv (payoff q x a) e) X ∧
    deriv (fun t => deriv (payoff q X t) e) a < 0

/-- §3.5, p. 14: FOC in the generalized objective; ΔI = 0 recovers the paper. -/
def firstOrderConditionSpec : Prop :=
  ∀ (q : Parameters), Admissible q →
    ∀ X a e : ℝ, 0 ≤ a → 0 ≤ e →
    (deriv (payoff q X a) e = 0 ↔
      (q.ΔI + q.ΔX * G X) * q.ell * g (precision q e a) = e ^ (q.α - 1))

/-- Strict negative second derivative at positive effort; not a global existence claim. -/
def curvatureSpec : Prop :=
  ∀ (q : Parameters), Admissible q →
    ∀ X a e : ℝ, 0 < X → 0 ≤ a → 0 < e →
    deriv (fun t => deriv (payoff q X a) t) e < 0

/-- At most one interior stationary effort. Existence of a maximizer is outside this endpoint. -/
def stationaryUniquenessSpec : Prop :=
  ∀ (q : Parameters), Admissible q →
    ∀ X a e₁ e₂ : ℝ, 0 < X → 0 ≤ a → 0 < e₁ → 0 < e₂ →
    deriv (payoff q X a) e₁ = 0 → deriv (payoff q X a) e₂ = 0 → e₁ = e₂

/-- Conditional algebra behind Observation 2. uee, ueX, uea denote payoff
second derivatives; ex, ea denote candidate branch derivatives.
The differentiated FOC equations are explicit premises. No IFT is asserted. -/
def conditionalResponseSignsSpec : Prop :=
  ∀ uee ueX uea ex ea : ℝ, uee < 0 → 0 < ueX → uea < 0 →
    uee * ex + ueX = 0 → uee * ea + uea = 0 → 0 < ex ∧ ea < 0

/-- Static optimized value strictly rises at fixed X, conditional on feasible
maximizer witnesses at both accuracies. This is NOT steady-state welfare. -/
def staticWelfareSpec : Prop :=
  ∀ (q : Parameters), Admissible q →
    ∀ X a b e₁ e₂ : ℝ, 0 < X → 0 ≤ a → a < b → 0 ≤ e₁ → 0 ≤ e₂ →
    (∀ e, 0 ≤ e → payoff q X a e ≤ payoff q X a e₁) →
    (∀ e, 0 ≤ e → payoff q X b e ≤ payoff q X b e₂) →
    payoff q X a e₁ < payoff q X b e₂

/-- Footnote 4, p. 14: at zero inherited knowledge and ΔI = 0, zero effort is
strictly better than every positive effort. No dynamics is encoded. -/
def baselineBoundarySpec : Prop :=
  ∀ (q : Parameters), Admissible q → q.ΔI = 0 → ∀ a : ℝ,
    payoff q 0 a 0 = 0 ∧ ∀ e : ℝ, 0 < e → payoff q 0 a e < payoff q 0 a 0

/-- Own extension: ΔI > 0 makes zero effort suboptimal at X = 0 and finite
nonnegative AI precision. This does not characterize any dynamic equilibrium. -/
def extensionBoundarySpec : Prop :=
  ∀ (q : Parameters), Admissible q → 0 < q.ΔI → ∀ a : ℝ, 0 ≤ a →
    0 < deriv (payoff q 0 a) 0 ∧
    ∃ e : ℝ, 0 < e ∧ payoff q 0 a 0 < payoff q 0 a e

end AKO26
