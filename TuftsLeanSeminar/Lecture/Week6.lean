import Mathlib

/-!
# Filters and limits in Mathlib
-/

/- Design decision: how to deal with limits and continuity efficiently?

Here is an excerpt from `Mathematics in Lean`:

  Let `f : ℝ → ℝ` be any function. We can consider the limit of `f x`
  as `x` approaches some value `x₀`, but we can also consider the
  limit of `f x` as `x` approaches infinity or negative infinity. We
  can moreover consider the limit of `f x` as `x` approaches `x₀` from
  the right, conventionally written `x₀⁺`, or from the left, written
  `x₀⁻`. There are variations where `x` approaches `x₀` or `x₀⁺` or
  `x₀⁻` but is not allowed to take on the value `x₀` itself. This
  results in at least eight ways that `x` can approach something. We
  can also restrict to rational values of `x` or place other
  constraints on the domain, but let’s stick to those 8 cases.

  We have a similar variety of options on the codomain: we can specify
  that `f x` approaches a value from the left or right, or that it
  approaches positive or negative infinity, and so on. For example, we
  may wish to say that `f x` tends to `+∞` when `x` tends to `x₀` from
  the right without being equal to `x₀`. This results in 64 different
  kinds of limit statements, and we haven’t even begun to deal with
  limits of sequences [...]

So there is a need for a more uniform approach, and mathlib uses
Bourbaki's notion of `filters`.

-/

/- **Definitions** A filter on a type `X` is a collection of sets of
`X` satisfying some conditions that we'll indicate soon. Goals of the
definition:

- account for limits

- account for the notion of something happening eventually: e.g. for
  "large enough `n : ℕ`"" or for "points sufficiently near `x : X`"
  ...
  
  
  

  
-/
