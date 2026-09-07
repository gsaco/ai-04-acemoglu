import Mathlib.Analysis.SpecialFunctions.Pow.Deriv
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus
import Mathlib.Tactic

/-! Gaussian success function as a concrete integral. No distributional axioms. -/
noncomputable section
open Real MeasureTheory
namespace AKO26

def normalizer : ℝ := 1 / Real.sqrt (2 * Real.pi)
def kernel (u : ℝ) : ℝ := Real.exp (-(u ^ 2) / 2)
def G (z : ℝ) : ℝ := 2 * normalizer * ∫ u in (0 : ℝ)..Real.sqrt z, kernel u
def g (z : ℝ) : ℝ := normalizer * Real.exp (-z / 2) / Real.sqrt z
def gprime (z : ℝ) : ℝ := -(1 + 1 / z) * g z / 2

lemma normalizer_pos : 0 < normalizer := by
  unfold normalizer
  positivity

lemma kernel_continuous : Continuous kernel := by
  unfold kernel
  fun_prop

lemma G_zero : G 0 = 0 := by simp [G]

lemma G_pos {z : ℝ} (hz : 0 < z) : 0 < G z := by
  unfold G
  apply mul_pos (mul_pos (by norm_num) normalizer_pos)
  apply intervalIntegral.integral_pos (Real.sqrt_pos.2 hz)
  · exact kernel_continuous.continuousOn
  · intro x hx
    exact le_of_lt (Real.exp_pos _)
  · exact ⟨0, ⟨le_rfl, le_of_lt (Real.sqrt_pos.2 hz)⟩, Real.exp_pos _⟩

lemma g_pos {z : ℝ} (hz : 0 < z) : 0 < g z := by
  exact div_pos (mul_pos normalizer_pos (Real.exp_pos _)) (Real.sqrt_pos.2 hz)

lemma gprime_neg {z : ℝ} (hz : 0 < z) : gprime z < 0 := by
  unfold gprime
  have hp : 0 < 1 + 1 / z := by positivity
  exact div_neg_of_neg_of_pos (mul_neg_of_neg_of_pos (neg_neg_of_pos hp) (g_pos hz)) (by norm_num)

lemma hasDerivAt_G {z : ℝ} (hz : 0 < z) : HasDerivAt G (g z) z := by
  have hi := intervalIntegral.integral_hasDerivAt_right
    (kernel_continuous.intervalIntegrable 0 (Real.sqrt z))
    kernel_continuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    kernel_continuous.continuousAt
  have hc := (hi.comp z (Real.hasDerivAt_sqrt (ne_of_gt hz))).const_mul (2 * normalizer)
  convert hc using 1
  simp only [kernel, Real.sq_sqrt (le_of_lt hz), g]
  ring

lemma hasDerivAt_g {z : ℝ} (hz : 0 < z) : HasDerivAt g (gprime z) z := by
  have hn : HasDerivAt (fun t : ℝ => -t / 2) (-1 / 2) z := by
    exact (hasDerivAt_id z).neg.div_const 2
  have hd := ((hn.exp).const_mul normalizer).div
    (Real.hasDerivAt_sqrt (ne_of_gt hz)) (ne_of_gt (Real.sqrt_pos.2 hz))
  convert hd using 1
  unfold gprime g
  have hs : Real.sqrt z ^ 2 = z := Real.sq_sqrt (le_of_lt hz)
  have hnz := ne_of_gt hz
  have hsnz := ne_of_gt (Real.sqrt_pos.2 hz)
  field_simp
  rw [hs]
  ring
end AKO26
