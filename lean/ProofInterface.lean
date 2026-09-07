import PaperInterface
import MainTheorems

/-! Exact-type proof endpoints for the independently readable specifications. -/
noncomputable section
namespace AKO26

theorem gaussianCalculus : gaussianCalculusSpec := by
  intro z hz
  exact ⟨hasDerivAt_G hz, hasDerivAt_g hz, G_pos hz, g_pos hz, gprime_neg hz⟩

theorem observation1 : observation1Spec := by
  intro q hq hI X a e hX ha he
  refine ⟨cross_public hq hX he ha, ?_, observation1_generalized hq hX he ha⟩
  rw [cross_agentic hq he ha, hI, zero_add]

theorem generalizedObservation : generalizedObservationSpec := by
  intro q hq X a e hX ha he
  exact observation1_generalized hq hX he ha

theorem firstOrderCondition : firstOrderConditionSpec := by
  intro q hq X a e ha he
  exact foc_equivalence hq he ha

theorem curvature : curvatureSpec := by
  intro q hq X a e hX ha he
  exact payoff_curvature hq hX he ha

theorem stationaryUniqueness : stationaryUniquenessSpec := by
  intro q hq X a e₁ e₂ hX ha he₁ he₂ h₁ h₂
  exact stationary_unique hq hX ha he₁ he₂ h₁ h₂

theorem conditionalResponseSigns : conditionalResponseSignsSpec := by
  intro uee ueX uea ex ea hc hx ha hfx hfa
  exact implicit_response_signs hc hx ha hfx hfa

theorem staticWelfare : staticWelfareSpec := by
  intro q hq X a b e₁ e₂ hX ha hab he₁ _ _ hmax₂
  exact static_value_strict hq hX ha hab he₁ hmax₂

theorem baselineBoundary : baselineBoundarySpec := by
  intro q hq hI a
  exact baseline_zero_unique hq hI a

theorem extensionBoundary : extensionBoundarySpec := by
  intro q hq hI a ha
  exact ⟨extension_boundary hq hI ha, extension_zero_not_optimal hq hI ha⟩

end AKO26
