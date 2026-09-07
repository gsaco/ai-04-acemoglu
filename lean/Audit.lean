import ProofInterface

/-! Reproducible trust audit and non-vacuity witnesses. -/
noncomputable section
namespace AKO26

def baselineExample : Parameters := ⟨2/5, 0, 3/5, 1, 1, 2⟩
def extensionExample : Parameters := ⟨1/4, 3/20, 3/5, 1, 1, 2⟩

example : Admissible baselineExample := by
  constructor <;> norm_num [baselineExample]

example : Admissible extensionExample := by
  constructor <;> norm_num [extensionExample]

example : ∃ e : ℝ, 0 < e ∧ payoff extensionExample 0 1 0 < payoff extensionExample 0 1 e := by
  have hq : Admissible extensionExample := by constructor <;> norm_num [extensionExample]
  exact (extensionBoundary extensionExample hq (by norm_num [extensionExample]) 1 (by norm_num)).2

#print axioms gaussianCalculus
#print axioms observation1
#print axioms generalizedObservation
#print axioms firstOrderCondition
#print axioms curvature
#print axioms stationaryUniqueness
#print axioms conditionalResponseSigns
#print axioms staticWelfare
#print axioms baselineBoundary
#print axioms extensionBoundary
end AKO26
