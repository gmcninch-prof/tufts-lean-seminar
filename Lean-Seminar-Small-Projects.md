# Lean Seminar: Small Projects

Nov 17, 2026 

## How these projects work

Each project is fairly small and somewhat self-contained: you can work
on it between sessions, and in seminar we can compare notes (and
continue to work if stuck beforehand). 

- **Start from the starter file.** Everyone should use the same
  definitions and theorem statements, so that different attempts are
  comparable.

- **Tasks are tiered.** Do the first tier if you can; go further if
  you have time. The extensions are open-ended.

- **Being stuck counts.** "Here is where I got stuck, and what the
  goal looked like" is a useful thing to bring. We will start sessions
  there.

- **Sharing is short.** A few people show one interesting thing each:
  a slick proof, a failed approach, a surprising error message, a
  design choice you would make differently.


You should put your attempts in your own folder in the seminar repo.

The projects build on each other a little (Project 2 reuses the `Term`
type from Project 1), but you should be able to try any of them
without having done the earlier ones.

In a couple of places, it might be useful to browse the `Mathlib` API
documentation. I'm including a section at the bottom of this file with
some suggestions for doing so.

## Project 1: Symbolic differentiation

Define a tiny language of expressions, write a program that
differentiates them, and prove the program's correctness using
Mathlib's derivatives.


**Lean themes:** inductive types, structural recursion, proof by
induction, the `HasDerivAt` API.

### Starter code

```lean
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

```

### Tasks

1. Warm up by proving a few concrete facts about particular terms, for example

```lean
example : (Term.add .var .var).eval 1 = 2 := by
  simp [Term.eval]; norm_num
```
Why doesn't `#eval` work here?

Here are some other examples:

```lean
example (r : ℝ) : (Term.add .var (.const r)).eval r = 2 * r := by
  sorry

example (r : ℝ) : (Term.mul .var (.const r)).eval 2 = 2 * r := by
  sorry
```

2. Write `x² + 3x` as a `Term` `t`. Without running Lean, work out the `Term`
   that `diff t` returns by unfolding the definition of `diff`. Then check
   your answer: 
   
   ```lean 
   example : diff t = (your answer) := rfl 
   ```
   
   How does `diff t differ` from the `2x + 3` you’d write by hand?

3. Prove `diff_correct` by induction on `e`.

   Correctness uses Mathlib’s `HasDerivAt`, which says that `f` has
   derivative `f′` at `x`. Under the hood it is the Fréchet
   derivative: a linear map, here multiplication by `f′`.
   
   See [https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Calculus/Deriv/Basic.html](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Analysis/Calculus/Deriv/Basic.html)

   Look for `HasDerivAt.add`, `HasDerivAt.mul`, `hasDerivAt_id`,
   `hasDerivAt_const` in the `MathLib` documentation. Expect some
   fiddling to match the shape Mathlib's lemmas produce.

### Extensions (pick one)

- **Simplification:** write `simplify : Term → Term` removing `0 + t`,
  `1 * t`, `0 * t`, and prove `(simplify t).eval = t.eval`.

- **Generic coefficients:** make it `Term R` with `eval` over any
  commutative ring `R`, so you can `#eval` over `ℚ`. Correctness still
  lives over `ℝ`.

- **Exponential:** add a constructor `exp`.

	You might write a typeclass `HasExp R` and use `mathlib` functions
	to give instances for `HasExp ℝ` and `HasExp ℂ`.

    Where should the requirement that `R` has an exponential live: on
    `eval`, or as an instance argument stored in a constructor for
    `Term` like(`| exp [HasExp R] : Term R → Term R`)? Try one and
    report.

- **Several variables:** replace `var` with `var : ℕ → Term`, evaluate
  against an environment `ℕ → ℝ`, and state correctness for partial
  derivatives.

* **stack calculator:** Compile to a stack machine: define
  instructions (push a constant, push x, add, multiply), compile a
  `Term` to a list of such instructions, and prove that running the
  compiled code on an empty stack gives `eval`. (Hint: you’ll need to
  prove something more general about running code on an arbitrary
  stack.)

### For discussion

- Why is `eval` `noncomputable`, and what changes if the coefficients
  live in `ℚ`?
- How do you add a constructor to an existing inductive type? (You
  can't directly. What are the workarounds?)
- The proof is "by induction". What is Lean's induction principle for
  `Term`, and where did it come from?
- Should `t r` mean `t.eval r`? Try `instance : CoeFun Term (fun _ =>
  ℝ → ℝ) := ⟨Term.eval⟩`. What do you gain, and what gets harder to
  read?

## Project 2: Polynomials as coefficient lists

Here we will adapt the `Term` type from project 1.

The idea is to give terms a second meaning: not as functions, but as formal
polynomials. You'll normalize a term to its list of coefficients, prove that
normalizing preserves evaluation, and compare your design with
Mathlib's.

**Lean themes:** recursion on lists, canonical forms, proofs about
your own data structures, Mathlib's `Polynomial` API.

### Starter code

```lean
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
```

### Tasks

1. Define `Pol.add` and `Pol.mul`, and test them with `#eval` over
   `ℤ` or `ℚ`. (Hint for `mul`: multiplying `p` by `a :: as` is "`a` times
   `p`, plus `x` times (`as` times `p`)".)

2. Define `normalize`, and prove `eval_add`, `eval_mul`, then `eval_normalize`.

3. Mathlib bridge: define `Pol.toPolynomial : Pol R → R[X]` and
   prove `Polynomial.eval x p.toPolynomial = p.eval x`.

   

### Extensions (pick one)

- **Canonical forms:** `[1, 2]` and `[1, 2, 0]` are the same
  polynomial. Strip trailing zeros, then decide whether two terms
  define the same polynomial by comparing normal forms. What exactly
  can you prove?

- **Algebra by hand:** prove `Pol.mul` is associative. Then explain
  why Mathlib doesn't do it this way.

- **Polynomials vs. functions:** over `ZMod p`, find a term whose
  normal form is nonzero but whose `eval` is zero everywhere. State
  and prove it in Lean for a specific `p`.

- **Formal derivative:** define `Pol.deriv` and prove it agrees with
  Project 1's `diff`, that is, `(diff t).normalize` and
  `t.normalize.deriv` are equal after normalization. This works over
  any commutative ring.

### For discussion

- Mathlib's `Polynomial R` is a structure wrapping `AddMonoidAlgebra R
  ℕ`, which is `ℕ →₀ R` with convolution. What does that buy over
  lists (canonical forms, associativity for free), and what does it
  cost (computation)?
- Why wrap it in a structure at all, rather than a plain definition?
- The starter code uses `abbrev Pol R := List R`, a transparent
  nickname: Lean unfolds it freely, so List's functions, lemmas and
  instances apply directly. Try changing it to `def`, then to `structure
  Pol R where coeffs : List R`. What breaks at each step, and why
  might Mathlib want that?
- `MvPolynomial σ R` is `AddMonoidAlgebra R (σ →₀ ℕ)`. One
  construction, a different exponent monoid.
- The `ring` tactic works by normalizing both sides and comparing. How
  close is your `normalize` to that idea?

## Project 3: A type-class sandbox

Build a miniature version of a Mathlib structure — a normed real
vector space — with your own class and instances, and see how Lean's
instance search behaves when there are choices to make.

**Lean themes:** defining classes, `extends`, instances, instance
search, diamonds.

### Starter code

```lean
import Mathlib

/-- A norm on a real vector space (not using Mathlib's notion of normed vector space). -/
class MyNorm (V : Type) [AddCommGroup V] [Module ℝ V] where
  nrm : V → ℝ
  nrm_nonneg : ∀ v, 0 ≤ nrm v
  nrm_eq_zero : ∀ v, nrm v = 0 ↔ v = 0
  nrm_smul : ∀ (c : ℝ) v, nrm (c • v) = |c| * nrm v
  nrm_add_le : ∀ v w, nrm (v + w) ≤ nrm v + nrm w

open MyNorm

instance : MyNorm ℝ where
  nrm x := |x|
  nrm_nonneg := sorry
  nrm_eq_zero := sorry
  nrm_smul := sorry
  nrm_add_le := sorry

/-- Products: which norm? max, sum, or Euclidean? You decide. -/
instance {V W : Type} [AddCommGroup V] [Module ℝ V] [MyNorm V]
    [AddCommGroup W] [Module ℝ W] [MyNorm W] : MyNorm (V × W) := sorry

theorem nrm_sub_nrm_le {V : Type} [AddCommGroup V] [Module ℝ V] [MyNorm V]
    (v w : V) : |nrm v - nrm w| ≤ nrm (v - w) := by
  sorry
```

### Tasks

1. Fill in the `ℝ` instance (Mathlib's `abs` lemmas should do most of
   the work).

2. Choose a norm for `V × W` and build the instance. Then prove
   `nrm_sub_nrm_le` for any `MyNorm`.

3. Give an instance for `Fin n → ℝ`. Again, which norm? (`Finset.sup'`
   gives the max norm; a sum of `|v i|` gives the ℓ¹ norm.) Compute
   `nrm ((1, 2) : ℝ × ℝ)` and `nrm (![1, 2] : Fin 2 → ℝ)`. Are they
   equal? Should they be?

### Extensions (pick one)

- **Make a diamond:** add a general instance for `ι → V` whenever `V`
  has a `MyNorm`, alongside your `Fin n → ℝ` instance. Now `Fin n → ℝ`
  has two instances. Which does Lean pick, can you tell, and can you
  prove they agree? If they don't agree, what goes wrong?

- **Compare with Mathlib:** what norm does Mathlib put on `ℝ × ℝ` and
  on `Fin n → ℝ`? Why does `EuclideanSpace ℝ (Fin n)` exist as a
  separate type?
  
- **Languages as classes:** instead of an inductive `Term`, describe
  what an expression language can do:

```lean
class TermAlg (α : Type) where
  const : ℝ → α
  var : α
  add : α → α → α
  mul : α → α → α

class TermAlgExp (α : Type) extends TermAlg α where
  exp : α → α
```

Give an instance for `ℝ → ℝ` (evaluation), and one for pairs `(ℝ → ℝ)
× (ℝ → ℝ)` carrying a function and its derivative. The second is
forward-mode automatic differentiation. Here, adding `exp` really is
inheritance. What did you give up compared with Project 1?

### For discussion

- Should the norm be data in the class, or should the class only say
  "some norm exists"? What would each choice do to `ℝ × ℝ`?
- Mathlib bundles the algebra and the norm together
  (`NormedAddCommGroup`, `NormedSpace`) and is careful that the
  topology coming from the norm is *definitionally* the one already
  there. Why would that matter?
- When should a design use a class, and when should it just pass a
  function as an argument?

## The `Mathlib` API pages

**Reading the Mathlib docs.** Go to the [Mathlib
docs](https://leanprover-community.github.io/mathlib4_docs/) and type
a name you already know (say `abs_mul`) into the search box. That
takes you to the file where it lives, and the useful lemmas are
usually nearby on the same page.

- **The top of the page** has a summary of the file: its main
  definitions and results, and often the notation and naming
  conventions it uses.

- **Each entry** shows the lemma's full statement. Arguments in `{ }`
  are filled in automatically; arguments in `[ ]` are type-class
  assumptions, which say what kind of structure the lemma needs.
  
- **Lemmas are stated generally.** `abs_mul` isn't about `ℝ`; it holds
  in any ordered field-like structure, so its assumptions look
  intimidating. Don't worry about them: `ℝ` satisfies them all, and
  Lean finds the instances.
  
- **"source"** links to the Lean file, which is sometimes easier to
  scan than the docs page.
