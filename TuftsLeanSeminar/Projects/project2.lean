import Mathlib

/-! project 2 -/

variable {R : Type} [CommRing R]

/-- Terms with coefficients in R rather than just real numbers
   (the type from Project 1, made generic) -/
    
inductive Term (R : Type)
  | const : R → Term R
  | var : Term R
  | add : Term R → Term R → Term R
  | mul : Term R → Term R → Term R

namespace Term

def eval : Term R → R → R
  | const c, _ => c
  | var,     x => x
  | add s t, x => s.eval x + t.eval x
  | mul s t, x => s.eval x * t.eval x

end Term

-- A polynomial as a list of coefficients, constant term first:
-- `[a₀, a₁, a₂]` means a₀ + a₁x + a₂x². 
    
-- `abbrev` makes `Poly R` a transparent nickname for `List R`: Lean unfolds it
-- freely, so all the `List` functions, lemmas and instances apply to it directly. 

abbrev Pol (R : Type) := List R

/-- Horner evaluation. -/
def Pol.eval : Pol R → R → R
  | [],      _ => 0
  | a :: as, x => a + x * Pol.eval as x

def Pol.add : Pol R → Pol R → Pol R := sorry
def Pol.mul : Pol R → Pol R → Pol R := sorry

def Term.normalize : Term R → Pol R := sorry

theorem Pol.eval_add (p q : Pol R) (x : R) :
    (p.add q).eval x = p.eval x + q.eval x := sorry

theorem Pol.eval_mul (p q : Pol R) (x : R) :
    (p.mul q).eval x = p.eval x * q.eval x := sorry

theorem Term.eval_normalize (t : Term R) (x : R) :
    t.normalize.eval x = t.eval x := sorry
