import Mathlib.Tactic


/-!
# Tufts Lean seminar: Week 4
-/


lemma complement_distrib (A B : Set α) : (A ∩ B)ᶜ = Aᶜ ∪ Bᶜ := by
  ext x
  constructor
  · rintro h
    by_cases hA : x ∈ A
    · apply Or.inr 
      intro hB
      exact h ⟨hA,hB⟩
    · apply Or.inl 
      intro k
      exact hA k
  · rintro (hA | hB) ⟨ka,kb⟩ 
    · exact hA ka
    · exact hB kb


#print axioms complement_distrib
