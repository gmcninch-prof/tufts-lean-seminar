import Mathlib

/-! start code for a Lean project -/

inductive Term
  | const : ℝ → Term
  | var : Term                -- the input variable x
  | add : Term → Term → Term
  | mul : Term → Term → Term

namespace Term

/-- The function of x determined by a term. -/
noncomputable def eval : Term → (x : ℝ) → ℝ
  | const c, _ => c
  | var,     x => x
  | add s t, x => s.eval x + t.eval x
  | mul s t, x => s.eval x * t.eval x

/-- Symbolic derivative. -/
def diff : Term → Term
  | const _ => const 0
  | var     => const 1
  | add s t => add s.diff t.diff
  | mul s t => add (mul s.diff t) (mul s t.diff)

theorem diff_correct (e : Term) (x : ℝ) :
    HasDerivAt e.eval (e.diff.eval x) x := by
  sorry

end Term
