# Review: RandomWalk.lean / ontology.ttl — feedback for the next pass

Reviewed against the source paper (arXiv 2606.15929, Polakowski & Struzik, "Wavelet
Localisation and Local Modulation Freezing in MRW Unwrapping") and against
`crates/praxis-lean`'s existing `no_sorry` audit policy in the praxis workspace, since this
ontology targets `ggen:isMathematicallyAdmitted` in the same `praxis.chatman.com/ontology/ggen#`
namespace praxis's real pipeline consumes.

## What's landed so far

Real, useful groundwork: the right vocabulary is named (`LocalizedProbe`, `ModulationField`,
freezing), the ontology wiring to `ggen:computationalConsequence` /
`ggen:projectionTarget` is structurally in place, and the ambition — using the paper's
localization argument to justify a real caching-safety mechanism
(`FINITE_SUPPORT_CACHE_ISOLATION`) — is a legitimate thing to want to prove. This note is about
closing the gap between "the shape is sketched" and "the theorem carries the weight the
ontology says it carries."

## The concrete gap

`local_modulation_freezing`'s conclusion is `∃ (frozen_state : Prop), frozen_state = True`,
which holds unconditionally — witness `frozen_state := True`, `rfl`. It's true before
`is_sufficiently_small` is even inspected (Lean's own unused-variable check on `h_small`
would flag this, and that check is worth wiring into `ggen:isMathematicallyAdmitted` as an
actual gate rather than an asserted `"true"` string — see below). A statement whose negation
isn't coherent can't yet be the thing `ggen:computationalConsequence` points at, because there's
no failure mode for it to rule out.

Two gaps need closing, and they're separable — worth landing as two increments, not one:

### 1. The paper's actual claim isn't encoded yet

The paper's real content (per its abstract) is conditional and quantitative: validity depends
on support geometry, scale-dependent overlap, and residual multiscale mixing from modulation
variability — i.e. it's an *approximation with an error term*, not an unconditional identity.
`ModulationField { state : Type }` has no field structure (no process, no multiplicative
composition, nothing stochastic) and `LocalizedProbe.is_sufficiently_small : Prop` is
unconstrained — nothing ties "small" to an actual scale threshold.

A next pass that would carry real content: give `ModulationField` an actual multiplicative
structure (even a toy one — e.g. `field : Real → Real → Real` with a stated multiplicative
decomposition `field x y = local x * modulation y`), give `LocalizedProbe` a real support
radius, and state the freezing claim as a bound:

```lean
structure ModulationField where
  local_component : Real → Real
  modulation : Real → Real
  drift_bound : Real  -- how much `modulation` can vary across the probe's support

structure LocalizedProbe where
  center : Real
  scale : Real
  scale_pos : scale > 0

/-- Within the probe's support, `modulation` varies by at most `field.drift_bound * scale`. -/
theorem local_modulation_freezing
    (probe : LocalizedProbe) (field : ModulationField)
    (h_lipschitz : ∀ x y, |x - probe.center| ≤ probe.scale → |y - probe.center| ≤ probe.scale →
      |field.modulation x - field.modulation y| ≤ field.drift_bound * probe.scale) :
    ∀ x y, |x - probe.center| ≤ probe.scale → |y - probe.center| ≤ probe.scale →
      |field.modulation x - field.modulation y| ≤ field.drift_bound * probe.scale :=
  h_lipschitz
```

That specific statement is still a placeholder (it's just restating its own hypothesis — one
more pass needed to derive the *additive log-decomposition* the paper actually claims from a
Lipschitz-type premise like this), but it demonstrates the shape a real version needs: a
quantitative hypothesis, a quantitative conclusion, and a proof that actually uses the
hypothesis. The real target is deriving something like "as `scale → 0`, the log-wavelet
coefficient's modulation contribution is `O(drift_bound * scale)`" — that's the actual
"freezing" claim, and it's a limit/bound statement, not an existential over `Prop`.

### 2. The workflow-analogy bridge needs to be its own lemma

"A workflow execution log is mathematically indistinguishable from a random walk through state
space" is the load-bearing move connecting the paper to `FINITE_SUPPORT_CACHE_ISOLATION`, and
right now it lives in prose, not in Lean. To make it real: define what a workflow execution
trace *is* as a mathematical object (a sequence of state transitions with some notion of
variation between states), then show — as an explicit reduction, not an assumed identification —
that it has the multiplicative-modulation structure `ModulationField` requires. Only then does
applying the (properly quantitative) freezing theorem to it produce the caching guarantee as a
derived corollary, rather than an asserted consequence.

### 3. Make `ggen:isMathematicallyAdmitted` a computed gate, not an asserted string

`praxis-lean`'s existing `AuditPolicy` (already real, already used elsewhere in the praxis
workspace: `forbid_axiom` + `allowed_axiom_prefixes`, see `crates/praxis-lean/src/no_sorry.rs`)
is the right mechanism to route this through before `ggen` treats a theorem as admitted. It
would also be worth adding a "hypothesis actually used" lint (Lean's own unused-variable
warning already catches the current version — `lake build` should be surfacing a warning on
`h_small` right now) as a second gate alongside no-sorry/no-unauthorized-axiom, since a
vacuous-but-technically-clean proof is a real gap that the no-sorry check alone won't catch.

## Suggested next increment

Smallest real step: pick one concrete, checkable quantitative claim (even a toy one, like the
Lipschitz-bound sketch above) that is actually false for some parameter choice — that's the
test for whether a statement carries content. Land that, wire `lake build`'s own unused-hypothesis
warning into the admission gate, then come back to the workflow-trace bridge as a second,
separate lemma once the core freezing statement is real.
