-- Hand-authored. Not rendered by ggen. Not ledgered in .mfact/artifacts.toml.
-- Edits here are ordinary code review, not artifact drift.
import ProcInt.Playground.Experimental.ConjectureGeometry
import ProcInt.Playground.Experimental.Workflow

/-!
# Exhaustive Small-World Workflow Manufacture

Pipeline:
`finite operation/socket alphabets → bounded workflow universe → executable monad laws`.

Crown law:
finite workflow enumeration may manufacture evidence for substitution laws, but the
finite reports remain `FINITE_VERIFIED`; the corresponding Lean theorems carry `PROVEN`.

Preserves:
constructor vocabulary; depth bound; law identity.

Excludes:
finite verification as proof; runtime adequacy; POWL correspondence.

Standing:
experimental companion rail to `Workflow.bind_right_identity` and `Workflow.bind_assoc`.

Falsifier:
the finite experiment runner promotes a green workflow world search to `PROVEN`.

Downstream:
conjecture geometry, mutation discrimination, finite theorem mining.
-/

namespace ProcInt.Playground.Experimental

/-- Two-symbol operation alphabet for exhaustive workflow experiments. -/
inductive TinyOp where
  | a
  | b
  deriving Repr, DecidableEq, Inhabited, BEq

/-- Two-symbol socket alphabet for exhaustive workflow experiments. -/
inductive TinySocket where
  | x
  | y
  deriving Repr, DecidableEq, Inhabited, BEq

/-- Atomic finite workflow worlds. -/
def atomicWorkflowWorlds : List (Workflow TinyOp TinySocket) := [
  .socket .x,
  .socket .y,
  .atom .a,
  .atom .b
]

private def binaryWorlds
    (ctor :
      Workflow TinyOp TinySocket →
      Workflow TinyOp TinySocket →
      Workflow TinyOp TinySocket)
    (worlds : List (Workflow TinyOp TinySocket)) :
    List (Workflow TinyOp TinySocket) :=
  worlds.flatMap fun left =>
    worlds.map fun right =>
      ctor left right

/--
All workflow syntax trees manufactured up to an explicit recursion depth.

Law: depth zero contains atoms/sockets; successor depth closes the previous universe
under sequence, parallel, and choice, then removes duplicates.
Carrier: finite workflow syntax.
Admission: explicit natural depth.
Preserves: constructor vocabulary and previous worlds.
Refuses: claim of size-optimal or isomorphism-quotiented enumeration.
Actuation: recursive finite list manufacture.
Complexity: combinatorial growth dominated by three binary closures.
Claim ceiling: finite syntax universe.
-/
def workflowWorlds : Nat → List (Workflow TinyOp TinySocket)
  | 0 => atomicWorkflowWorlds
  | depth + 1 =>
      let previous := workflowWorlds depth
      (previous ++
        binaryWorlds Workflow.seq previous ++
        binaryWorlds Workflow.par previous ++
        binaryWorlds Workflow.choice previous).eraseDups

/-- First substitution used by the associativity experiment. -/
def tinyK : TinySocket → Workflow TinyOp TinySocket
  | .x => .seq (.atom .a) (.socket .y)
  | .y => .choice (.atom .b) (.socket .x)

/-- Second substitution used by the associativity experiment. -/
def tinyH : TinySocket → Workflow TinyOp TinySocket
  | .x => .par (.atom .a) (.atom .b)
  | .y => .atom .b

/-- Finite experiment for workflow substitution right identity. -/
def workflowRightIdentityExperiment
    (depth : Nat) : FiniteExperiment (Workflow TinyOp TinySocket) where
  name := s!"workflow-bind-right-identity-depth-{depth}"
  worlds := workflowWorlds depth
  law := fun w => decide (Workflow.bind w Workflow.socket = w)
  render := reprStr

/-- Finite experiment for workflow substitution associativity. -/
def workflowAssociativityExperiment
    (depth : Nat) : FiniteExperiment (Workflow TinyOp TinySocket) where
  name := s!"workflow-bind-associativity-depth-{depth}"
  worlds := workflowWorlds depth
  law := fun w =>
    decide (
      Workflow.bind (Workflow.bind w tinyK) tinyH =
        Workflow.bind w (fun socket => Workflow.bind (tinyK socket) tinyH))
  render := reprStr

/--
Mutant substitution that intentionally drops the right branch of sequence nodes.

Law: this is a deliberately incorrect implementation used as an experimental falsifier.
Carrier: workflow mutation.
Admission: test-only candidate.
Preserves: left branch only.
Refuses: standing as lawful substitution.
Claim ceiling: adversarial mutant.
-/
def bindDropSeqRight
    (w : Workflow TinyOp TinySocket)
    (k : TinySocket → Workflow TinyOp TinySocket) :
    Workflow TinyOp TinySocket :=
  match w with
  | .socket s => k s
  | .atom op => .atom op
  | .seq left _ => bindDropSeqRight left k
  | .par left right => .par (bindDropSeqRight left k) (bindDropSeqRight right k)
  | .choice left right =>
      .choice (bindDropSeqRight left k) (bindDropSeqRight right k)

/-- Candidate laws used to score workflow worlds as test basis vectors. -/
def workflowCandidateLaws :
    List (NamedLaw (Workflow TinyOp TinySocket)) := [
  {
    name := "lawful-right-identity"
    law := fun w => decide (Workflow.bind w Workflow.socket = w)
  },
  {
    name := "mutant-drop-seq-right-identity"
    law := fun w => decide (bindDropSeqRight w Workflow.socket = w)
  },
  {
    name := "has-open-socket"
    law := fun w => !(Workflow.openSockets w).isEmpty
  },
  {
    name := "contains-sequence"
    law := fun w =>
      let rec hasSeq : Workflow TinyOp TinySocket → Bool
        | .socket _ => false
        | .atom _ => false
        | .seq _ _ => true
        | .par left right => hasSeq left || hasSeq right
        | .choice left right => hasSeq left || hasSeq right
      hasSeq w
  }
]

/-- Greedy highest-gain workflow world for the initial finite conjecture family. -/
def initialBestWorkflowBasisWorld (depth : Nat) :
    Option (Workflow TinyOp TinySocket) :=
  chooseMaxWorldGain [] workflowCandidateLaws (workflowWorlds depth)

end ProcInt.Playground.Experimental
