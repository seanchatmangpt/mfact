-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Multifractal.LevelSet

/-!
# ProcInt.Playground.Multifractal.Spectrum

A spectrum is an invariant evaluated on parameterized level sets.

This file deliberately separates the observable from the evaluator: Hausdorff
dimension, entropy, or another invariant can consume the same recursive level-set rail.
-/

namespace ProcInt.Playground.Multifractal

/-- Evaluate `I` on the exact `a`-level set of `φ`. -/
def spectrumAt {X A B : Type*} (I : Set X → B) (φ : X → A) (a : A) : B :=
  I (levelSet φ a)

/-- The full spectrum function `a ↦ I({x | φ x = a})`. -/
def spectrum {X A B : Type*} (I : Set X → B) (φ : X → A) : A → B :=
  fun a => spectrumAt I φ a

/-- Evaluate `I` on a predicate-defined level set. -/
def predicateSpectrumAt {X A B : Type*}
    (I : Set X → B) (P : A → X → Prop) (a : A) : B :=
  I (predicateLevelSet P a)

/-- Full predicate-defined spectrum. -/
def predicateSpectrum {X A B : Type*}
    (I : Set X → B) (P : A → X → Prop) : A → B :=
  fun a => predicateSpectrumAt I P a

end ProcInt.Playground.Multifractal
