-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.MFW.Runtime

/-!
# Multifractal concurrency mass

This file formalizes the discrete layer that is directly computable from POWL
regions and receipts.  Analytic limits/logarithms are represented by an
explicit pressure-law interface rather than silently imported from another
mathematical domain.
-/

namespace ProcInt.Playground.MFW

/-- Receipted measurements for one recursively nested POWL region. -/
structure RegionProfile where
  regionId : Nat
  scale : Nat
  totalWork : Nat
  criticalSpan : Nat
  reachWeight : Nat
  expectedVisits : Nat
  spanLeWork : criticalSpan ≤ totalWork
deriving Repr

/-- Work outside the critical chain: structural concurrency mass. -/
def RegionProfile.structuralMass (p : RegionProfile) : Nat :=
  p.totalWork - p.criticalSpan

/-- Choice-weighted and recurrence-weighted concurrency mass. -/
def RegionProfile.expectedMass (p : RegionProfile) : Nat :=
  p.reachWeight * p.expectedVisits * p.structuralMass

@[simp] theorem RegionProfile.structuralMass_eq_zero_of_sequential
    (p : RegionProfile) (h : p.criticalSpan = p.totalWork) :
    p.structuralMass = 0 := by
  simp [RegionProfile.structuralMass, h]

@[simp] theorem RegionProfile.expectedMass_eq_zero_of_sequential
    (p : RegionProfile) (h : p.criticalSpan = p.totalWork) :
    p.expectedMass = 0 := by
  simp [RegionProfile.expectedMass, h]

abbrev ScaleCover := List RegionProfile

def totalConcurrencyMass : ScaleCover → Nat
  | [] => 0
  | region :: rest => region.expectedMass + totalConcurrencyMass rest

/-- Unnormalized moment partition `Z_q`; normalization is a downstream projection. -/
def partitionMoment (q : Nat) : ScaleCover → Nat
  | [] => 0
  | region :: rest => region.expectedMass ^ q + partitionMoment q rest

@[simp] theorem totalConcurrencyMass_append (a b : ScaleCover) :
    totalConcurrencyMass (a ++ b) =
      totalConcurrencyMass a + totalConcurrencyMass b := by
  induction a with
  | nil => simp [totalConcurrencyMass]
  | cons region rest ih =>
      simp [totalConcurrencyMass, ih, Nat.add_assoc]

@[simp] theorem partitionMoment_append (q : Nat) (a b : ScaleCover) :
    partitionMoment q (a ++ b) = partitionMoment q a + partitionMoment q b := by
  induction a with
  | nil => simp [partitionMoment]
  | cons region rest ih =>
      simp [partitionMoment, ih, Nat.add_assoc]

/-- A discrete local scaling observation. -/
structure LocalScaling where
  region : RegionProfile
  alpha : Int
deriving Repr

/-- More than one local exponent is the finite witness of heterogeneity. -/
def Heterogeneous (samples : List LocalScaling) : Prop :=
  ∃ a, a ∈ samples ∧ ∃ b, b ∈ samples ∧ a.alpha ≠ b.alpha

/-- A finite multifractal field across recursively nested POWL scales. -/
structure MultifractalField where
  levels : List (List LocalScaling)
  heterogeneous : ∃ level, level ∈ levels ∧ Heterogeneous level

/--
An admitted discrete pressure/Legendre surface.  A continuous theorem can be
connected later only by an explicit correspondence preserving these samples.
-/
structure PressureLaw where
  pressure : Int → Int
  alpha : Int → Int
  spectrum : Int → Int
  legendre : ∀ q, spectrum (alpha q) = q * alpha q - pressure q

end ProcInt.Playground.MFW
