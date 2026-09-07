import Model
import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Analysis.Calculus.Deriv.MeanValue

noncomputable section
open Filter Set
open scoped Topology
namespace AKO26

/-- Actual mixed derivative of U, not just a sign assumed of a symbol. -/
theorem cross_public {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (hX : 0 < X) (he : 0 ≤ e) (ha : 0 ≤ a) :
    deriv (fun x => deriv (payoff q x a) e) X =
      q.ΔX * q.ell * g X * g (precision q e a) := by
  have hy := precision_pos hq he ha
  have hf : (fun x => deriv (payoff q x a) e) = (fun x => marginal q x a e) := by
    funext x
    exact deriv_payoff_effort hq x a e hy
  rw [hf]
  exact (hasDerivAt_marginal_public q a e X hX).deriv

/-- Equality near a suffices: precision remains positive on an open neighborhood. -/
theorem cross_agentic {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (he : 0 ≤ e) (ha : 0 ≤ a) :
    deriv (fun t => deriv (payoff q X t) e) a =
      (q.ΔI + q.ΔX * G X) * q.ell * gprime (precision q e a) := by
  have hy := precision_pos hq he ha
  have hc : Continuous (fun t => precision q e t) := by unfold precision; fun_prop
  have hnear : ∀ᶠ t in 𝓝 a, 0 < precision q e t := hc.continuousAt.eventually (eventually_gt_nhds hy)
  have heq : (fun t => deriv (payoff q X t) e) =ᶠ[𝓝 a] (fun t => marginal q X t e) := by
    filter_upwards [hnear] with t ht
    exact deriv_payoff_effort hq X t e ht
  exact ((hasDerivAt_marginal_agentic q X a e hy).congr_of_eventuallyEq heq).deriv

theorem observation1_generalized {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (hX : 0 < X) (he : 0 ≤ e) (ha : 0 ≤ a) :
    0 < deriv (fun x => deriv (payoff q x a) e) X ∧
    deriv (fun t => deriv (payoff q X t) e) a < 0 := by
  have hy := precision_pos hq he ha
  constructor
  · rw [cross_public hq hX he ha]
    exact mul_pos (mul_pos (mul_pos hq.complement_pos hq.learning_pos) (g_pos hX)) (g_pos hy)
  · rw [cross_agentic hq he ha]
    have hc : 0 < q.ΔI + q.ΔX * G X :=
      add_pos_of_nonneg_of_pos hq.standalone_nonneg (mul_pos hq.complement_pos (G_pos hX))
    exact mul_neg_of_pos_of_neg (mul_pos hc hq.learning_pos) (gprime_neg hy)

lemma hasDerivAt_marginal_effort {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (he : 0 < e) (ha : 0 ≤ a) :
    HasDerivAt (marginal q X a)
      ((q.ΔI + q.ΔX * G X) * q.ell ^ 2 * gprime (precision q e a) -
        (q.α - 1) * e ^ (q.α - 2)) e := by
  have hy := precision_pos hq (le_of_lt he) ha
  have hd : HasDerivAt (fun t => precision q t a) q.ell e := by
    simpa [precision] using (((hasDerivAt_id e).const_mul q.ell).const_add q.prior).add_const a
  have hh := (((hasDerivAt_g hy).comp e hd).const_mul ((q.ΔI + q.ΔX * G X) * q.ell)).sub
    (Real.hasDerivAt_rpow_const (x := e) (p := q.α - 1) (Or.inl (ne_of_gt he)))
  convert hh using 1
  rw [show q.α - 1 - 1 = q.α - 2 by ring]
  ring

theorem effort_curvature {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (hX : 0 < X) (he : 0 < e) (ha : 0 ≤ a) :
    deriv (marginal q X a) e < 0 := by
  rw [(hasDerivAt_marginal_effort hq he ha).deriv]
  have hc : 0 < q.ΔI + q.ΔX * G X :=
    add_pos_of_nonneg_of_pos hq.standalone_nonneg (mul_pos hq.complement_pos (G_pos hX))
  have ht := mul_neg_of_pos_of_neg (mul_pos hc (sq_pos_of_pos hq.learning_pos))
    (gprime_neg (precision_pos hq (le_of_lt he) ha))
  have hp : 0 < (q.α - 1) * e ^ (q.α - 2) :=
    mul_pos (sub_pos.2 hq.cost_convex) (Real.rpow_pos_of_pos he _)
  linarith

/-- FOC equation, conditional on an interior stationary point; not an existence theorem. -/
theorem foc_equivalence {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (he : 0 ≤ e) (ha : 0 ≤ a) :
    deriv (payoff q X a) e = 0 ↔
    (q.ΔI + q.ΔX * G X) * q.ell * g (precision q e a) = e ^ (q.α - 1) := by
  rw [deriv_payoff_effort hq X a e (precision_pos hq he ha)]
  exact sub_eq_zero

/-- If a differentiable stationary branch exists, differentiating its FOC gives
these signs. The existence/differentiability of a branch is not asserted here. -/
theorem implicit_response_signs {uee ueX uea ex ea : ℝ}
    (hcurv : uee < 0) (hx : 0 < ueX) (ha : uea < 0)
    (hfx : uee * ex + ueX = 0) (hfa : uee * ea + uea = 0) :
    0 < ex ∧ ea < 0 := by
  constructor
  · by_contra hh
    have := mul_nonneg_of_nonpos_of_nonpos (le_of_lt hcurv) (le_of_not_gt hh)
    linarith
  · by_contra hh
    have := mul_nonpos_of_nonpos_of_nonneg (le_of_lt hcurv) (le_of_not_gt hh)
    linarith

/-- At fixed effort and positive inherited knowledge, greater AI precision raises payoff. -/
theorem hasDerivAt_payoff_accuracy {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (he : 0 ≤ e) (ha : 0 ≤ a) :
    HasDerivAt (fun t => payoff q X t e)
      ((q.ΔI + q.ΔX * G X) * g (precision q e a)) a := by
  have hd : HasDerivAt (fun t => precision q e t) 1 a := by
    simpa [precision] using (hasDerivAt_id a).const_add (q.prior + q.ell * e)
  have hh := ((((hasDerivAt_G (precision_pos hq he ha)).comp a hd).const_mul
    (q.ΔI + q.ΔX * G X)).const_add (q.ΔG * G X)).sub_const (e ^ q.α / q.α)
  convert hh using 1
  simp

/-- Static welfare comparison uses actual maxima as explicit witnesses;
it does not assume a differentiable argmax or assert a long-run welfare result. -/
theorem static_value_strict {q : Parameters} (hq : Admissible q)
    {X a b e₁ e₂ : ℝ} (hX : 0 < X) (ha : 0 ≤ a) (hab : a < b)
    (he₁ : 0 ≤ e₁)
    (hmax₂ : ∀ e, 0 ≤ e → payoff q X b e ≤ payoff q X b e₂) :
    payoff q X a e₁ < payoff q X b e₂ := by
  have hmono : StrictMonoOn (fun t => payoff q X t e₁) (Set.Ici 0) := by
    apply strictMonoOn_of_deriv_pos (convex_Ici 0)
    · intro t ht
      exact (hasDerivAt_payoff_accuracy hq he₁ ht).continuousAt.continuousWithinAt
    · intro t ht
      have ht0 : 0 ≤ t := by
        have := interior_subset ht
        exact this
      rw [(hasDerivAt_payoff_accuracy hq he₁ ht0).deriv]
      exact mul_pos (add_pos_of_nonneg_of_pos hq.standalone_nonneg
        (mul_pos hq.complement_pos (G_pos hX))) (g_pos (precision_pos hq he₁ ht0))
  exact lt_of_lt_of_le (hmono ha (le_trans ha (le_of_lt hab)) hab) (hmax₂ e₁ he₁)

/-- In the baseline, zero effort uniquely maximizes the payoff when X = 0. -/
theorem baseline_zero_unique {q : Parameters} (hq : Admissible q)
    (hI : q.ΔI = 0) (a : ℝ) :
    payoff q 0 a 0 = 0 ∧ ∀ e, 0 < e → payoff q 0 a e < payoff q 0 a 0 := by
  have hα : 0 < q.α := lt_trans (by norm_num) hq.cost_convex
  have hz : payoff q 0 a 0 = 0 := by simp [payoff, G_zero, hI, ne_of_gt hα]
  refine ⟨hz, ?_⟩
  intro e he
  rw [hz]
  simp only [payoff, G_zero, hI, mul_zero, zero_add, zero_mul, zero_sub]
  exact neg_neg_of_pos (div_pos (Real.rpow_pos_of_pos he _) hα)

/-- Strict marginal incentive at the boundary once ΔI > 0. -/
theorem extension_boundary {q : Parameters} (hq : Admissible q)
    (hI : 0 < q.ΔI) {a : ℝ} (ha : 0 ≤ a) :
    0 < deriv (payoff q 0 a) 0 := by
  rw [deriv_payoff_effort hq 0 a 0 (precision_pos hq le_rfl ha)]
  simp only [marginal, G_zero, mul_zero, add_zero,
    Real.zero_rpow (ne_of_gt (sub_pos.2 hq.cost_convex)), sub_zero]
  exact mul_pos (mul_pos hI hq.learning_pos) (g_pos (precision_pos hq le_rfl ha))

/-- An actual feasible strict improvement, not merely a symbolic positive marginal return. -/
theorem extension_zero_not_optimal {q : Parameters} (hq : Admissible q)
    (hI : 0 < q.ΔI) {a : ℝ} (ha : 0 ≤ a) :
    ∃ e, 0 < e ∧ payoff q 0 a 0 < payoff q 0 a e := by
  have hd := hasDerivAt_payoff_effort hq 0 a 0 (precision_pos hq le_rfl ha)
  have hp : 0 < marginal q 0 a 0 := by
    rw [← hd.deriv]
    exact extension_boundary hq hI ha
  have hevent := hd.tendsto_slope_zero_right.eventually (eventually_gt_nhds hp)
  have hpos : ∀ᶠ e : ℝ in 𝓝[>] 0, 0 < e := self_mem_nhdsWithin
  obtain ⟨e, hh, he⟩ := (hevent.and hpos).exists
  refine ⟨e, he, ?_⟩
  simp only [zero_add, smul_eq_mul] at hh
  have hh' : 0 < payoff q 0 a e - payoff q 0 a 0 :=
    (mul_pos_iff_of_pos_left (inv_pos.2 he)).1 hh
  linarith

/-- The curvature statement refers to the actual second derivative of payoff. -/
theorem payoff_curvature {q : Parameters} (hq : Admissible q)
    {X a e : ℝ} (hX : 0 < X) (he : 0 < e) (ha : 0 ≤ a) :
    deriv (fun t => deriv (payoff q X a) t) e < 0 := by
  have hc : Continuous (fun t => precision q t a) := by unfold precision; fun_prop
  have hn : ∀ᶠ t in 𝓝 e, 0 < precision q t a :=
    hc.continuousAt.eventually (eventually_gt_nhds (precision_pos hq (le_of_lt he) ha))
  have heq : (fun t => deriv (payoff q X a) t) =ᶠ[𝓝 e] marginal q X a := by
    filter_upwards [hn] with t ht
    exact deriv_payoff_effort hq X a t ht
  have hd := (hasDerivAt_marginal_effort hq he ha).congr_of_eventuallyEq heq
  rw [hd.deriv, ← (hasDerivAt_marginal_effort hq he ha).deriv]
  exact effort_curvature hq hX he ha

/-- At most one positive stationary effort. No maximizer existence is postulated. -/
theorem stationary_unique {q : Parameters} (hq : Admissible q)
    {X a e₁ e₂ : ℝ} (hX : 0 < X) (ha : 0 ≤ a)
    (he₁ : 0 < e₁) (he₂ : 0 < e₂)
    (h₁ : deriv (payoff q X a) e₁ = 0)
    (h₂ : deriv (payoff q X a) e₂ = 0) : e₁ = e₂ := by
  have hm : StrictAntiOn (marginal q X a) (Set.Ioi 0) := by
    apply strictAntiOn_of_deriv_neg (convex_Ioi 0)
    · intro t ht
      exact (hasDerivAt_marginal_effort hq ht ha).continuousAt.continuousWithinAt
    · intro t ht
      exact effort_curvature hq hX (interior_subset ht) ha
  apply hm.injOn he₁ he₂
  rw [← deriv_payoff_effort hq X a e₁ (precision_pos hq (le_of_lt he₁) ha),
    ← deriv_payoff_effort hq X a e₂ (precision_pos hq (le_of_lt he₂) ha), h₁, h₂]

end AKO26
