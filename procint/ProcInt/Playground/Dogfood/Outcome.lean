-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Planning.Pddl
import ProcInt.Playground.Experimental.Experiment

/-!
# Unified Five-Valued Search Outcome Algebra (Operation Dogfood, Wave 1)

Pipeline:
`candidate space → fuel-bounded examination → typed terminal outcome → resume or close`.

Crown law:
a bound hit terminates as `bounded` carrying the exact unexamined frontier, never as
`exhausted`; `exhausted` is derivable only from complete enumeration of the declared
finite space (PRD §6.6; Vision 2030 §3.3: "Bounded results preserve the frontier
required to resume or redesign the search", "Exhaustion is scoped to the exact finite
model").

Preserves:
the frontier on `bounded` (resume-composition law `resume_eq_combined`); failure of every
examined candidate on `exhausted` (`searchGo_exhausted_all_failed`).

Excludes:
the bare-Bool projection (`naiveFeasible`) as an outcome carrier — the countermodel
section exhibits it conflating `bounded` with `exhausted`, which is exactly the
information `PddlPlan.validCheck : Bool` (`ProcInt/Planning/Pddl.lean:50`) cannot carry;
any claim that this type IS the praxis-side Rust `SearchOutcome<P>` — the constructor
mirror makes a correspondence morphism definable, and per the No Ambient Theorem
Authority law that edge stays `MISSING` until the morphism is admitted and discharged.

Standing:
kernel-proven laws over an explicit executable search model; finite-exhaustion wire
targets `FiniteExperiment` only (audit Pass 19 PS3 refuted the earlier claim that
`reachable_is_one_of` belongs to that machinery).

Falsifier:
a `searchGo` run that returns `exhausted` while some candidate in the declared space was
never examined, or returns `bounded` whose frontier omits an unexamined candidate.

Downstream:
`Swarm11Verifier` (checks fold), `AxiomAuditDogfood`.

Claim ceiling: theorem for the laws below; finite-domain for the concrete demo checks.
-/

namespace ProcInt.Playground.Dogfood

/-- The five truthful terminal outcomes of a bounded search (PRD §6.6; press release
"Truthful Outcomes"). Mirrors the praxis-side Rust `SearchOutcome<P>` enum
constructor-for-constructor; `bounded` additionally carries the resumption frontier
required by Vision 2030 §3.3. The mirror is an edge of type `MISSING` until an explicit
correspondence morphism is admitted — it lends no standing to the Rust side. -/
inductive SearchOutcome (P F : Type) where
  /-- A valid witness exists and was examined. -/
  | found (witness : P)
  /-- The exact declared finite space was completely examined; no witness exists in it. -/
  | exhausted
  /-- An admitted budget boundary was reached; `frontier` is the unexamined remainder. -/
  | bounded (frontier : F)
  /-- The required capability does not exist on the admitted surface. -/
  | unsupported
  /-- Authoritative observations disagree. -/
  | inconsistent
  deriving Repr, DecidableEq, BEq

namespace SearchOutcome

/-- Discriminator usable without `DecidableEq` on the payload types. -/
def isFound {P F : Type} : SearchOutcome P F → Bool
  | .found _ => true
  | _ => false

/-- Discriminator usable without `DecidableEq` on the payload types. -/
def isExhausted {P F : Type} : SearchOutcome P F → Bool
  | .exhausted => true
  | _ => false

/-- Discriminator usable without `DecidableEq` on the payload types. -/
def isBounded {P F : Type} : SearchOutcome P F → Bool
  | .bounded _ => true
  | _ => false

end SearchOutcome

/-! ## PDDL8 bounds

Named constants mirroring the praxis-side PDDL8 planner bounds. Mirrors only: no theorem
below transfers standing across that edge. -/

/-- Praxis PDDL8 grounding bound (mirror constant). -/
def MAX_GROUND : Nat := 4096

/-- Praxis PDDL8 plan-depth bound (mirror constant); used as concrete fuel below. -/
def MAX_PLAN_DEPTH : Nat := 64

/-- Praxis PDDL8 conjunct bound (mirror constant). -/
def MAX_CONJUNCTS : Nat := 8

/-! ## The executable search model -/

/-- Fuel-bounded left-to-right search of a declared candidate list. Empty remainder is
genuine exhaustion regardless of remaining fuel; a fuel hit with candidates remaining is
`bounded` carrying exactly the unexamined suffix as the frontier. -/
def searchGo {α : Type} (good : α → Bool) : Nat → List α → SearchOutcome α (List α)
  | _, [] => .exhausted
  | 0, x :: rest => .bounded (x :: rest)
  | fuel + 1, x :: rest => if good x then .found x else searchGo good fuel rest

/-- A found witness satisfies the predicate and lies in the declared space. -/
theorem searchGo_found {α : Type} (good : α → Bool) :
    ∀ (fuel : Nat) (l : List α) (x : α),
      searchGo good fuel l = .found x → good x = true ∧ x ∈ l := by
  intro fuel l
  induction l generalizing fuel with
  | nil => intro x h; simp [searchGo] at h
  | cons y rest ih =>
      intro x h
      cases fuel with
      | zero => simp [searchGo] at h
      | succ k =>
          by_cases hy : good y = true
          · simp [searchGo, hy] at h
            exact ⟨h ▸ hy, h ▸ List.mem_cons_self⟩
          · simp [searchGo, hy] at h
            obtain ⟨hg, hm⟩ := ih k x h
            exact ⟨hg, List.mem_cons_of_mem y hm⟩

/-- Exhaustion scoped to the exact finite model: `exhausted` means every candidate in the
declared space was examined and refused. This is the Vision 2030 §3.3 scoping law. -/
theorem searchGo_exhausted_all_failed {α : Type} (good : α → Bool) :
    ∀ (fuel : Nat) (l : List α),
      searchGo good fuel l = .exhausted → ∀ x ∈ l, good x = false := by
  intro fuel l
  induction l generalizing fuel with
  | nil => intro _ x hx; exact absurd hx (List.not_mem_nil)
  | cons y rest ih =>
      intro h x hx
      cases fuel with
      | zero => simp [searchGo] at h
      | succ k =>
          by_cases hy : good y = true
          · simp [searchGo, hy] at h
          · simp [searchGo, hy] at h
            rcases List.mem_cons.mp hx with rfl | hx'
            · exact Bool.not_eq_true _ ▸ hy
            · exact ih k h x hx'

/-- Exhaustion requires the budget to have covered the whole declared space. -/
theorem searchGo_exhausted_length_le {α : Type} (good : α → Bool) :
    ∀ (fuel : Nat) (l : List α),
      searchGo good fuel l = .exhausted → l.length ≤ fuel := by
  intro fuel l
  induction l generalizing fuel with
  | nil => intro _; exact Nat.zero_le fuel
  | cons y rest ih =>
      intro h
      cases fuel with
      | zero => simp [searchGo] at h
      | succ k =>
          by_cases hy : good y = true
          · simp [searchGo, hy] at h
          · simp [searchGo, hy] at h
            exact Nat.succ_le_succ (ih k h)

/-- The frontier is exactly the unexamined suffix, and it is never empty — `bounded` is
never manufactured after full enumeration. -/
theorem searchGo_bounded_frontier {α : Type} (good : α → Bool) :
    ∀ (fuel : Nat) (l f : List α),
      searchGo good fuel l = .bounded f → f = l.drop fuel ∧ f ≠ [] := by
  intro fuel l
  induction l generalizing fuel with
  | nil => intro f h; simp [searchGo] at h
  | cons y rest ih =>
      intro f h
      cases fuel with
      | zero =>
          simp [searchGo] at h
          exact ⟨h.symm, by simp [← h]⟩
      | succ k =>
          by_cases hy : good y = true
          · simp [searchGo, hy] at h
          · simp [searchGo, hy] at h
            obtain ⟨hdrop, hne⟩ := ih k f h
            exact ⟨by simpa using hdrop, hne⟩

/-- A `bounded` outcome witnesses that the budget was strictly smaller than the space. -/
theorem searchGo_bounded_fuel_lt {α : Type} (good : α → Bool)
    {fuel : Nat} {l f : List α} (h : searchGo good fuel l = .bounded f) :
    fuel < l.length := by
  obtain ⟨hdrop, hne⟩ := searchGo_bounded_frontier good fuel l f h
  by_contra hnot
  exact hne (hdrop.trans (List.drop_eq_nil_of_le (Nat.le_of_not_lt hnot)))

/-- **The bound-hit law (PRD §6.6).** A fuel hit with candidates remaining is `bounded`
carrying those candidates — never `exhausted`. Definitional, exhibited not asserted. -/
theorem bound_hit_bounded {α : Type} (good : α → Bool) (x : α) (rest : List α) :
    searchGo good 0 (x :: rest) = .bounded (x :: rest) := rfl

/-- Full-budget search of the declared space can never return `bounded`: `bounded` and
"the whole space was covered" are mutually exclusive by theorem, not convention. -/
theorem full_fuel_not_bounded {α : Type} (good : α → Bool)
    {fuel : Nat} {l : List α} (hcover : l.length ≤ fuel) (f : List α) :
    searchGo good fuel l ≠ .bounded f := fun h =>
  absurd (searchGo_bounded_fuel_lt good h) (Nat.not_lt.mpr hcover)

/-- Everything-failed plus enough budget yields exhaustion (converse direction). -/
theorem all_failed_exhausted {α : Type} (good : α → Bool) :
    ∀ (fuel : Nat) (l : List α), (∀ x ∈ l, good x = false) → l.length ≤ fuel →
      searchGo good fuel l = .exhausted := by
  intro fuel l
  induction l generalizing fuel with
  | nil => intro _ _; cases fuel <;> rfl
  | cons y rest ih =>
      intro hall hlen
      cases fuel with
      | zero => exact absurd hlen (Nat.not_succ_le_zero _)
      | succ k =>
          have hy : good y = false := hall y List.mem_cons_self
          simp [searchGo, hy]
          exact ih k (fun x hx => hall x (List.mem_cons_of_mem y hx))
            (Nat.le_of_succ_le_succ hlen)

/-- **Exhaustion is final.** More budget never changes an `exhausted` verdict — it is a
property of the space, not of the budget. Contrast with `bounded`, which the demo checks
below flip to `found` by adding fuel: this asymmetry IS the Bounded ≠ Exhausted law. -/
theorem exhausted_stable {α : Type} (good : α → Bool)
    {fuel fuel' : Nat} {l : List α}
    (h : searchGo good fuel l = .exhausted) (hle : fuel ≤ fuel') :
    searchGo good fuel' l = .exhausted :=
  all_failed_exhausted good fuel' l
    (searchGo_exhausted_all_failed good fuel l h)
    (Nat.le_trans (searchGo_exhausted_length_le good fuel l h) hle)

/-- **Resume-composition (Vision 2030 §3.3).** Resuming from a `bounded` frontier with
additional budget equals one search with the combined budget — the theorem that makes
"preserve the frontier" a property rather than a field name. -/
theorem resume_eq_combined {α : Type} (good : α → Bool) :
    ∀ (f₁ : Nat) (l frontier : List α) (f₂ : Nat),
      searchGo good f₁ l = .bounded frontier →
      searchGo good f₂ frontier = searchGo good (f₁ + f₂) l := by
  intro f₁
  induction f₁ with
  | zero =>
      intro l frontier f₂ h
      cases l with
      | nil => simp [searchGo] at h
      | cons y rest =>
          simp [searchGo] at h
          rw [← h, Nat.zero_add]
  | succ k ih =>
      intro l frontier f₂ h
      cases l with
      | nil => simp [searchGo] at h
      | cons y rest =>
          by_cases hy : good y = true
          · simp [searchGo, hy] at h
          · simp [searchGo, hy] at h
            rw [Nat.succ_add]
            show searchGo good f₂ frontier =
              searchGo good ((k + f₂) + 1) (y :: rest)
            simp [searchGo, hy]
            exact ih rest frontier f₂ h

/-! ## The countermodel — what `Bool` cannot carry

`naiveFeasible` is the projection `PddlPlan.validCheck : Bool` forces on every consumer:
one bit, everything non-`found` collapsed together. The demo below exhibits a `bounded`
search (witness exists past the frontier) and an `exhausted` search (witness provably
absent) that this projection cannot distinguish — while resuming the first finds the
witness and no budget ever changes the second. The PRD Truth falsifier ("a bounded
search reported as infeasible") is thereby structurally unavoidable for any bare-Bool
outcome carrier, and structurally impossible for `SearchOutcome`. -/

/-- The bare-Bool projection: exactly the information content of `validCheck`. -/
def naiveFeasible {P F : Type} : SearchOutcome P F → Bool
  | .found _ => true
  | _ => false

/-- Ten-candidate demo space; the witness `7` sits past the fuel-3 frontier. -/
def demoSpaceLarge : List Nat := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

/-- Three-candidate demo space provably containing no witness. -/
def demoSpaceSmall : List Nat := [1, 2, 3]

/-- The demo predicate. -/
def demoGood (n : Nat) : Bool := n == 7

/-- The collapse, exhibited: the Bool projection cannot tell the bounded search (whose
resume finds `7`) from the exhausted one (which no budget can ever change). -/
theorem naive_projection_conflates :
    naiveFeasible (searchGo demoGood 3 demoSpaceLarge) =
      naiveFeasible (searchGo demoGood 5 demoSpaceSmall) := rfl

/-- The conflation is genuinely lossy: the two outcomes are distinct. -/
theorem naive_projection_lossy :
    searchGo demoGood 3 demoSpaceLarge ≠ searchGo demoGood 5 demoSpaceSmall := by decide

/-! ## Wire to the genuine finite-exhaustion machinery

`FiniteExperiment.run` (`Playground/Experimental/Experiment.lean`) traverses its entire
declared `worlds` list with no fuel parameter — the one pre-existing artifact whose
"exhausted" is legitimate. The projection below can therefore never produce `bounded`,
and its `exhausted` coincides exactly with `FINITE_VERIFIED`. Per audit Pass 19 PS3,
this wire deliberately targets `FiniteExperiment` alone. -/

open ProcInt.Playground.Experimental in
/-- Outcome projection of a completed finite experiment: a first counterexample is a
`found` witness; a clean full traversal is genuine `exhausted`. -/
def outcomeOfExperiment {α : Type} (e : FiniteExperiment α) :
    SearchOutcome Counterexample Unit :=
  match e.run.counterexample with
  | some c => .found c
  | none => .exhausted

open ProcInt.Playground.Experimental in
/-- A full-enumeration run can never be `bounded`: there is no budget to hit. -/
theorem outcomeOfExperiment_never_bounded {α : Type} (e : FiniteExperiment α)
    (f : Unit) : outcomeOfExperiment e ≠ .bounded f := by
  unfold outcomeOfExperiment
  cases e.run.counterexample <;> simp

open ProcInt.Playground.Experimental in
/-- `exhausted` from this wire coincides exactly with the machinery's own
`FINITE_VERIFIED` standing — which `run_ne_proven` already caps below `PROVEN`. -/
theorem outcomeOfExperiment_exhausted_iff {α : Type} (e : FiniteExperiment α) :
    outcomeOfExperiment e = .exhausted ↔ e.run.standing = Standing.FINITE_VERIFIED := by
  unfold outcomeOfExperiment FiniteExperiment.run
  cases e.firstCounterexample <;> simp

/-! ## Threading through the planner (by wrapper, never editing the rendered file) -/

open ProcInt in
/-- Five-valued plan search over a declared candidate list, wrapping the rendered
`PddlPlan.validCheck` (`Planning/Pddl.lean:50`) as the goodness predicate. This is the
outcome carrier the bare `Bool` check cannot be: exhaustion is scoped to the declared
candidates, and a budget hit preserves the unexamined candidates as the frontier. -/
def pddlSearchOutcome {Atom : Type} [DecidableEq Atom] (s0 sGoal : Finset Atom)
    (candidates : List (PddlPlan Atom)) (fuel : Nat) :
    SearchOutcome (PddlPlan Atom) (List (PddlPlan Atom)) :=
  searchGo (fun p => PddlPlan.validCheck s0 sGoal p) fuel candidates

open ProcInt in
/-- A found plan is valid and was among the declared candidates. -/
theorem pddlSearchOutcome_found_valid {Atom : Type} [DecidableEq Atom]
    {s0 sGoal : Finset Atom} {candidates : List (PddlPlan Atom)} {fuel : Nat}
    {p : PddlPlan Atom}
    (h : pddlSearchOutcome s0 sGoal candidates fuel = .found p) :
    PddlPlan.valid s0 sGoal p ∧ p ∈ candidates :=
  searchGo_found _ fuel candidates p h

open ProcInt in
/-- `exhausted` now truthfully means: no plan among the declared candidates is valid —
infeasibility scoped to the admitted space, never manufactured from a budget hit. -/
theorem pddlSearchOutcome_exhausted_infeasible {Atom : Type} [DecidableEq Atom]
    {s0 sGoal : Finset Atom} {candidates : List (PddlPlan Atom)} {fuel : Nat}
    (h : pddlSearchOutcome s0 sGoal candidates fuel = .exhausted) :
    ∀ p ∈ candidates, ¬ PddlPlan.valid s0 sGoal p := fun p hp hvalid => by
  have := searchGo_exhausted_all_failed _ fuel candidates h p hp
  rw [PddlPlan.valid] at hvalid
  simp_all

open ProcInt in
/-- The exact relation to the rendered Bool check, on the singleton candidate space:
`validCheck = true ↔ searchOutcome = found`. The wrapper loses nothing the Bool had. -/
theorem pddlSearchOutcome_singleton_iff {Atom : Type} [DecidableEq Atom]
    (s0 sGoal : Finset Atom) (p : PddlPlan Atom) :
    pddlSearchOutcome s0 sGoal [p] 1 = .found p ↔ PddlPlan.valid s0 sGoal p := by
  unfold pddlSearchOutcome PddlPlan.valid
  by_cases h : PddlPlan.validCheck s0 sGoal p = true <;> simp [searchGo, h]

open ProcInt in
/-- Concrete demo action over `Nat` atoms: consumes atom `0`'s presence, adds atom `1`. -/
def demoAction : PddlAction Nat := { pre := {0}, add := {1}, del := ∅ }

open ProcInt in
/-- The one-step demo plan. -/
def demoPlan : PddlPlan Nat := [demoAction]

/-! ## Executable checks (folded into `swarm11-verify` at Wave 5) -/

open ProcInt in
/-- Standing-aware checks, `AuditFlow.checks`-style: every entry is an independently
re-decided Bool over the concrete demos above, none a hardcoded literal. -/
def checks : List (String × Bool) := [
  ("outcome-bound-hit-is-bounded-never-exhausted",
    (searchGo demoGood 3 demoSpaceLarge).isBounded &&
      !(searchGo demoGood 3 demoSpaceLarge).isExhausted),
  ("outcome-frontier-is-exact-unexamined-suffix",
    decide (searchGo demoGood 3 demoSpaceLarge = .bounded [4, 5, 6, 7, 8, 9, 10])),
  ("outcome-exhausted-only-after-full-enumeration",
    (searchGo demoGood 5 demoSpaceSmall).isExhausted),
  ("outcome-exhausted-stable-under-more-fuel",
    (searchGo demoGood 100 demoSpaceSmall).isExhausted),
  ("outcome-bounded-provisional-more-fuel-finds",
    (searchGo demoGood 10 demoSpaceLarge).isFound),
  ("outcome-resume-from-frontier-finds-witness",
    (searchGo demoGood 7 [4, 5, 6, 7, 8, 9, 10]).isFound),
  ("outcome-naive-bool-projection-conflates-bounded-exhausted",
    naiveFeasible (searchGo demoGood 3 demoSpaceLarge) ==
      naiveFeasible (searchGo demoGood 5 demoSpaceSmall)),
  ("outcome-pddl-wrapper-found-at-depth-bound",
    (pddlSearchOutcome {0} ({1} : Finset Nat) [demoPlan] MAX_PLAN_DEPTH).isFound),
  ("outcome-pddl-wrapper-exhausted-refuses-all-candidates",
    (pddlSearchOutcome {0} ({1} : Finset Nat) [([] : PddlPlan Nat)]
      MAX_PLAN_DEPTH).isExhausted)
]

-- Build-time verification: every check passes at elaboration, so a regression here is
-- a build failure, not a verifier-time surprise.
#guard checks.all (·.2)

end ProcInt.Playground.Dogfood
