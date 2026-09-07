import Assumptions

noncomputable section
namespace AKO26

def precision (q : Parameters) (e a : ℝ) : ℝ := q.prior + q.ell * e + a

def payoff (q : Parameters) (X a e : ℝ) : ℝ :=
  q.ΔG * G X + (q.ΔI + q.ΔX * G X) * G (precision q e a) - e ^ q.α / q.α

def marginal (q : Parameters) (X a e : ℝ) : ℝ :=
  (q.ΔI + q.ΔX * G X) * q.ell * g (precision q e a) - e ^ (q.α - 1)

lemma precision_pos {q : Parameters} (hq : Admissible q) {e a : ℝ}
    (he : 0 ≤ e) (ha : 0 ≤ a) : 0 < precision q e a := by
  unfold precision
  have := mul_nonneg (le_of_lt hq.learning_pos) he
  linarith [hq.prior_pos]

/-- The displayed marginal return is genuinely the derivative of the payoff,
including e = 0 when α > 1. -/
theorem hasDerivAt_payoff_effort {q : Parameters} (hq : Admissible q)
    (X a e : ℝ) (hy : 0 < precision q e a) :
    HasDerivAt (payoff q X a) (marginal q X a e) e := by
  have hyder : HasDerivAt (fun t => precision q t a) q.ell e := by
    simpa [precision] using (((hasDerivAt_id e).const_mul q.ell).const_add q.prior).add_const a
  have hbenefit := ((hasDerivAt_G hy).comp e hyder).const_mul (q.ΔI + q.ΔX * G X)
  have hcost := (Real.hasDerivAt_rpow_const (x := e) (p := q.α)
    (Or.inr (le_of_lt hq.cost_convex))).div_const q.α
  have hd := (hbenefit.const_add (q.ΔG * G X)).sub hcost
  convert hd using 1
  unfold marginal
  have hα : q.α ≠ 0 := ne_of_gt (lt_trans (by norm_num) hq.cost_convex)
  field_simp

lemma deriv_payoff_effort {q : Parameters} (hq : Admissible q)
    (X a e : ℝ) (hy : 0 < precision q e a) :
    deriv (payoff q X a) e = marginal q X a e :=
  (hasDerivAt_payoff_effort hq X a e hy).deriv

lemma hasDerivAt_marginal_public (q : Parameters) (a e X : ℝ) (hX : 0 < X) :
    HasDerivAt (fun x => marginal q x a e)
      (q.ΔX * q.ell * g X * g (precision q e a)) X := by
  have hd := (((((hasDerivAt_G hX).const_mul q.ΔX).const_add q.ΔI).mul_const q.ell).mul_const
    (g (precision q e a))).sub_const (e ^ (q.α - 1))
  convert hd using 1
  ring

lemma hasDerivAt_marginal_agentic (q : Parameters) (X a e : ℝ)
    (hy : 0 < precision q e a) :
    HasDerivAt (fun t => marginal q X t e)
      ((q.ΔI + q.ΔX * G X) * q.ell * gprime (precision q e a)) a := by
  have hyder : HasDerivAt (fun t => precision q e t) 1 a := by
    simpa [precision] using (hasDerivAt_id a).const_add (q.prior + q.ell * e)
  have hd := (((hasDerivAt_g hy).comp a hyder).const_mul
    ((q.ΔI + q.ΔX * G X) * q.ell)).sub_const (e ^ (q.α - 1))
  convert hd using 1
  simp

end AKO26
