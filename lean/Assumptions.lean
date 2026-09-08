import Gaussian

noncomputable section
namespace AKO26

/-- ΔI is allowed to be positive; baseline theorems additionally impose ΔI = 0. -/
structure Parameters where
  ΔG : ℝ
  ΔI : ℝ
  ΔX : ℝ
  ell : ℝ
  prior : ℝ
  α : ℝ

/-- Economic premises, not axioms. Normalization and monotonicity are retained
although not all are needed for each local calculus lemma. -/
structure Admissible (q : Parameters) : Prop where
  general_nonneg : 0 ≤ q.ΔG
  standalone_nonneg : 0 ≤ q.ΔI
  complement_pos : 0 < q.ΔX
  normalized : q.ΔG + q.ΔI + q.ΔX = 1
  learning_pos : 0 < q.ell
  prior_pos : 0 < q.prior
  cost_convex : 1 < q.α

end AKO26
