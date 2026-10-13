-- Hand-authored lane L74 (L34 candidate 5): Merkle inclusion completeness.
-- Pattern follows ProcInt/Petri/PN64Conservation.lean: hand-authored, core-Lean
-- (no Mathlib import), admitted only by `lake build`. ggen renders; Lean admits.
--
-- Model of packs/strata-hash-pack/templates/hash_merkle.rs.tera (commit 274039f55):
-- SHA-256 is an opaque function; the Merkle structure (tagged leaf hash, tagged
-- node pairs, Bitcoin-style trailing-odd-node duplication, sibling list,
-- bottom-up fold verification) mirrors the Rust fold exactly.

/-! # ProcInt.Petri.MerkleCompleteness

Merkle inclusion *completeness* for the Strata Merkle construction
(`strata-hash-pack`, `hash_merkle.rs.tera`, LEAF_TAG 0x00 / NODE_TAG 0x01,
Bitcoin-style odd-node duplication).

The hash function is opaque: completeness (every leaf has a verifying proof)
is a property of the *fold structure alone* - it holds for any hash. The
converse direction (soundness: a verifying proof forces the claimed leaf) is
NOT proved here; it requires collision-freedom of the hash, which an opaque
constant cannot provide and which SHA-256 provides only in reality, not
formally. (E.g. a constant hash makes `verify` accept a forged leaf; the fold
structure cannot prevent it.)

Results:

1. **Path soundness.** Folding the canonical proof for leaf `i` of a level
   `L` (starting from `L[i]`) reproduces `rootIter L` exactly, for every
   level width including the odd-duplication case.

2. **Main theorem (completeness).** For every nonempty leaf list and every
   in-range index, `verify (merkleRoot leaves) leaves[i] i (proof leaves i)`
   holds. Converse: unproved, needs collision-freedom (comment above).
-/

set_option linter.unusedSimpArgs false

namespace ProcInt.StrataMerkle

/-! ## The hash model -/

/-- SHA-256 over an arbitrary-width tagged buffer (opaque; the structure
theorems below use no property of it). -/
opaque sha : {n : Nat} → BitVec n → BitVec 256

/-- Domain-separated leaf hash: `sha(0x00 || leaf)` (Rust `leaf_hash`). -/
def leafHash (x : BitVec 256) : BitVec 256 := sha ((0x00 : BitVec 8) ++ x)

/-- One compression step: `sha(0x01 || left || right)` (Rust `node_hash`). -/
def nodeHash (l r : BitVec 256) : BitVec 256 := sha ((0x01 : BitVec 8) ++ (l ++ r))

/-! ## Levels, collapse, pair accessors -/

/-- Fold one Merkle level, duplicating a trailing odd node (Bitcoin rule,
Rust `collapse`). -/
def collapse : List (BitVec 256) → List (BitVec 256)
  | [] => []
  | [a] => [nodeHash a a]
  | a :: b :: rest => nodeHash a b :: collapse rest

@[simp] theorem collapse_nil : collapse [] = [] := rfl

theorem collapse_cons_cons (a b : BitVec 256) (rest : List (BitVec 256)) :
    collapse (a :: b :: rest) = nodeHash a b :: collapse rest := rfl

/-- `level[2k]` - the left element of the k-th pair (Rust `level[i]`). -/
def leftOf : List (BitVec 256) → Nat → BitVec 256
  | [], _ => 0
  | a :: _, 0 => a
  | [a], _ => a
  | _ :: _ :: rest, k + 1 => leftOf rest k

/-- `level[2k+1]`, or `level[2k]` when the level width is odd and `2k` is the
trailing node (Rust `if i + 1 < level.len() { level[i + 1] } else { level[i] }`). -/
def rightOf : List (BitVec 256) → Nat → BitVec 256
  | [], _ => 0
  | [a], _ => a
  | _ :: b :: _, 0 => b
  | _ :: _ :: rest, k + 1 => rightOf rest k

/-- Structural fact for the two-step `collapse` recursion (measure induction
on a length bound): a level either collapses strictly shorter or is degenerate. -/
theorem collapse_shorter : forall (n : Nat) (L : List (BitVec 256)), L.length ≤ n →
    (collapse L).length < L.length ∨ L.length ≤ 1 := by
  intro n
  induction n with
  | zero =>
    intro L h
    have hz : L = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.mp h)
    simp [hz]
  | succ n ih =>
    intro L h
    cases L with
    | nil => simp
    | cons a t =>
      cases t with
      | nil => simp [collapse]
      | cons b rest =>
        have hrn : rest.length ≤ n := by simp only [List.length_cons] at h; omega
        rcases ih rest hrn with h1 | h1
        · left
          have hr : (collapse (a :: b :: rest)).length = (collapse rest).length + 1 := by
            rw [collapse_cons_cons]; simp
          simp only [hr, List.length_cons]
          omega
        · left
          cases rest with
          | nil => rw [collapse_cons_cons]; simp
          | cons c t3 =>
            have ht : t3 = [] := by
              simp only [List.length_cons] at h1
              exact List.eq_nil_of_length_eq_zero (by omega : t3.length = 0)
            subst ht
            rw [collapse_cons_cons]
            simp [collapse]

/-- A two-or-more-wide level collapses strictly shorter. -/
theorem collapse_len_lt (L : List (BitVec 256)) (h : 2 ≤ L.length) :
    (collapse L).length < L.length := by
  rcases collapse_shorter L.length L (Nat.le_refl _) with h1 | h1
  · exact h1
  · omega

/-- The level width bounds the collapsed width from below (doubling form,
proved by the same measure induction). -/
theorem div2_len_le : forall (n : Nat) (L : List (BitVec 256)), L.length ≤ n →
    L.length ≤ 2 * (collapse L).length := by
  intro n
  induction n with
  | zero =>
    intro L h
    have hz : L = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.mp h)
    simp [hz]
  | succ n ih =>
    intro L h
    cases L with
    | nil => simp
    | cons a t =>
      cases t with
      | nil => simp [collapse]
      | cons b rest =>
        have hrn : rest.length ≤ n := by simp only [List.length_cons] at h; omega
        have h1 := ih rest hrn
        have hr : (collapse (a :: b :: rest)).length = (collapse rest).length + 1 := by
          rw [collapse_cons_cons]; simp
        rw [hr]
        simp only [List.length_cons]
        omega

/-- Halving maps an in-range index into the collapsed level's range. -/
theorem div2_lt_len {L : List (BitVec 256)} {i : Nat} (hi : i < L.length)
    (_h2 : 2 ≤ L.length) : i / 2 < (collapse L).length := by
  have h1 := Nat.div_add_mod i 2
  have h3 := div2_len_le L.length L (Nat.le_refl _)
  omega

/-- The k-th collapsed node is the tagged hash of the k-th pair. This is where
the Bitcoin duplication rule enters: for a trailing odd node, `rightOf`
duplicates `leftOf`, and collapse's singleton case hashes the node with
itself - the two sides agree definitionally. -/
theorem col_eq_aux : forall (n : Nat) (L : List (BitVec 256)) (k : Nat),
    L.length ≤ n → k < (collapse L).length →
    (collapse L)[k]! = nodeHash (leftOf L k) (rightOf L k) := by
  intro n
  induction n with
  | zero =>
    intro L k hn hk
    cases L with
    | nil =>
      have h0 : (collapse ([] : List (BitVec 256))).length = 0 := rfl
      omega
    | cons a t => simp only [List.length_cons] at hn; omega
  | succ n ih =>
    intro L k hn hk
    cases L with
    | nil =>
      have h0 : (collapse ([] : List (BitVec 256))).length = 0 := rfl
      omega
    | cons a t =>
      cases t with
      | nil =>
        cases k with
        | zero => rfl
        | succ k' =>
          have h1 : (collapse [a]).length = 1 := rfl
          omega
      | cons b t2 =>
        cases k with
        | zero => rfl
        | succ k' =>
          have hL : (collapse (a :: b :: t2)).length = (collapse t2).length + 1 := by
            rw [collapse_cons_cons]; simp
          have hn' : t2.length ≤ n := by simp only [List.length_cons] at hn; omega
          have hk' : k' < (collapse t2).length := by omega
          simp only [collapse_cons_cons, List.getElem!_cons_succ]
          rw [ih t2 k' hn' hk']
          rfl

theorem col_eq (L : List (BitVec 256)) (k : Nat) (hk : k < (collapse L).length) :
    (collapse L)[k]! = nodeHash (leftOf L k) (rightOf L k) :=
  col_eq_aux L.length L k (Nat.le_refl _) hk

/-- `leftOf L k` is the element at index `2k` when in range. -/
theorem leftOf_eq_aux : forall (n : Nat) (L : List (BitVec 256)) (k : Nat),
    L.length ≤ n → 2 * k < L.length → leftOf L k = L[2 * k]! := by
  intro n
  induction n with
  | zero =>
    intro L k hn h
    cases L with
    | nil => simp at h
    | cons a t => simp only [List.length_cons] at hn; omega
  | succ n ih =>
    intro L k hn h
    cases L with
    | nil => simp at h
    | cons a t =>
      cases k with
      | zero => simp [leftOf, List.getElem!_cons_zero]
      | succ k' =>
        cases t with
        | nil => simp only [List.length_cons, List.length_nil] at h; omega
        | cons b t2 =>
          have h' : 2 * k' < t2.length := by
            simp only [List.length_cons] at h; omega
          have hl : leftOf (a :: b :: t2) (k' + 1) = leftOf t2 k' := rfl
          have he : (a :: b :: t2)[2 * (k' + 1)]! = t2[2 * k']! := by
            rw [show 2 * (k' + 1) = (2 * k' + 1) + 1 from by omega,
              List.getElem!_cons_succ, List.getElem!_cons_succ]
          simp only [hl, he]
          exact ih t2 k' (by simp only [List.length_cons] at hn; omega) h'

theorem leftOf_eq (L : List (BitVec 256)) (k : Nat) (h : 2 * k < L.length) :
    leftOf L k = L[2 * k]! :=
  leftOf_eq_aux L.length L k (Nat.le_refl _) h

/-- `rightOf L k` is the element at index `2k+1` when that index is in range
(i.e. when `2k` is not the trailing node of an odd-width level). -/
theorem rightOf_eq_aux : forall (n : Nat) (L : List (BitVec 256)) (k : Nat),
    L.length ≤ n → 2 * k + 1 < L.length → rightOf L k = L[2 * k + 1]! := by
  intro n
  induction n with
  | zero =>
    intro L k hn h
    cases L with
    | nil => simp at h
    | cons a t => simp only [List.length_cons] at hn; omega
  | succ n ih =>
    intro L k hn h
    cases L with
    | nil => simp at h
    | cons a t =>
      cases k with
      | zero =>
        cases t with
        | nil => simp only [List.length_cons, List.length_nil] at h; omega
        | cons b t2 =>
          have hr : rightOf (a :: b :: t2) 0 = b := rfl
          simp [hr, List.getElem!_cons_zero, List.getElem!_cons_succ]
      | succ k' =>
        cases t with
        | nil => simp only [List.length_cons, List.length_nil] at h; omega
        | cons b t2 =>
          have h' : 2 * k' + 1 < t2.length := by
            simp only [List.length_cons] at h; omega
          have hr : rightOf (a :: b :: t2) (k' + 1) = rightOf t2 k' := rfl
          have he : (a :: b :: t2)[2 * (k' + 1) + 1]! = t2[2 * k' + 1]! := by
            rw [show 2 * (k' + 1) + 1 = (2 * k' + 1) + 1 + 1 from by omega,
              List.getElem!_cons_succ, List.getElem!_cons_succ]
          simp only [hr, he]
          exact ih t2 k' (by simp only [List.length_cons] at hn; omega) h'

theorem rightOf_eq (L : List (BitVec 256)) (k : Nat) (h : 2 * k + 1 < L.length) :
    rightOf L k = L[2 * k + 1]! :=
  rightOf_eq_aux L.length L k (Nat.le_refl _) h

/-! ## Sibling selection, proof construction, verification fold -/

/-- One verification fold step (Rust `merkle_verify` loop body). -/
def mergeNode (node : BitVec 256) (idx : Nat) (sib : BitVec 256) : BitVec 256 :=
  if idx % 2 == 0 then nodeHash node sib else nodeHash sib node

/-- The proof sibling for index `i` at level `L` (Rust `merkle_proof` body). -/
def sibling (L : List (BitVec 256)) (i : Nat) : BitVec 256 :=
  if i % 2 == 0 then rightOf L (i / 2) else leftOf L (i / 2)

/-- Proof siblings bottom-up (Rust `merkle_proof` loop). -/
def proofAux (i : Nat) : List (BitVec 256) → List (BitVec 256)
  | [] => []
  | [_] => []
  | L@(_ :: _ :: _) => sibling L i :: proofAux (i / 2) (collapse L)
termination_by L => L.length
decreasing_by
  rename_i x y t e
  subst e
  exact collapse_len_lt _ (by simp)

/-- Bottom-up verification fold (Rust `merkle_verify`). -/
def foldAux (node : BitVec 256) (idx : Nat) : List (BitVec 256) → BitVec 256
  | [] => node
  | sib :: rest => foldAux (mergeNode node idx sib) (idx / 2) rest

/-- Root of a level (total; `rootIter []` is an unreachable dummy). -/
def rootIter : List (BitVec 256) → BitVec 256
  | [] => 0
  | [x] => x
  | L@(_ :: _ :: _) => rootIter (collapse L)
termination_by L => L.length
decreasing_by
  rename_i x y t e
  subst e
  exact collapse_len_lt _ (by simp)

/-! ## The merge lemma -/

@[simp] theorem mergeNode_even (node : BitVec 256) (idx : Nat) (sib : BitVec 256)
    (h : (idx % 2 == 0) = true) : mergeNode node idx sib = nodeHash node sib := by
  simp [mergeNode, h]

@[simp] theorem mergeNode_odd (node : BitVec 256) (idx : Nat) (sib : BitVec 256)
    (h : (idx % 2 == 0) = false) : mergeNode node idx sib = nodeHash sib node := by
  simp [mergeNode, h]

theorem sibling_even (L : List (BitVec 256)) (i : Nat) (h : (i % 2 == 0) = true) :
    sibling L i = rightOf L (i / 2) := by simp [sibling, h]

theorem sibling_odd (L : List (BitVec 256)) (i : Nat) (h : (i % 2 == 0) = false) :
    sibling L i = leftOf L (i / 2) := by simp [sibling, h]


/-- One fold step over the canonical sibling lands exactly on the parent
level's node. Both parities are covered uniformly by `col_eq`, which bakes in
the duplication rule for trailing odd nodes. -/
theorem merge_eq (L : List (BitVec 256)) (i : Nat) (hi : i < L.length) :
    mergeNode L[i]! i (sibling L i) = (collapse L)[i / 2]! := by
  have hdiv : i / 2 < (collapse L).length := by
    cases L with
    | nil => simp at hi
    | cons a t =>
      cases t with
      | nil =>
        have hi0 : i = 0 := by
          simp only [List.length_cons, List.length_nil] at hi
          omega
        subst hi0
        simp [collapse]
      | cons b rest =>
        exact div2_lt_len hi (by simp)
  by_cases hp : i % 2 = 0
  · have h2k : 2 * (i / 2) = i := by omega
    have hlt : 2 * (i / 2) < L.length := by omega
    have hp1 : (i % 2 == 0) = true := by simp [hp]
    have hleft : leftOf L (i / 2) = L[i]! := by
      rw [leftOf_eq L (i / 2) hlt, h2k]
    rw [mergeNode_even (h := hp1), sibling_even (h := hp1), ← hleft,
      col_eq L (i / 2) hdiv]
  · have hk : 2 * (i / 2) + 1 = i := by omega
    have hlt : 2 * (i / 2) + 1 < L.length := by omega
    have hp1 : (i % 2 == 0) = false := by simp [hp]
    rw [mergeNode_odd (h := hp1), sibling_odd (h := hp1), col_eq L (i / 2) hdiv,
      rightOf_eq L (i / 2) hlt, hk]

/-! ## Path soundness (the completeness core) -/

/-- **Path soundness.** Folding the canonical proof from `L[i]!` reproduces
the root of `L`, for every level width (odd levels included via the
duplication rule inside `col_eq`). -/
theorem path_sound : forall (n : Nat) (L : List (BitVec 256)) (i : Nat),
    L.length ≤ n → i < L.length →
    rootIter L = foldAux L[i]! i (proofAux i L) := by
  intro n
  induction n with
  | zero =>
    intro L i hn hi
    have hz : L = [] := List.eq_nil_of_length_eq_zero (Nat.le_zero.mp hn)
    simp [hz] at hi
  | succ n ih =>
    intro L i hn hi
    cases L with
    | nil => simp at hi
    | cons a t =>
      cases t with
      | nil =>
        have hi0 : i = 0 := by
          simp only [List.length_cons, List.length_nil] at hi
          omega
        subst hi0
        simp [rootIter, proofAux, foldAux, List.getElem!_cons_zero]
      | cons b rest =>
        have hlen2 : 2 ≤ (a :: b :: rest).length := by simp
        have hcoll : i / 2 < (collapse (a :: b :: rest)).length := div2_lt_len hi hlen2
        simp only [rootIter, proofAux, foldAux]
        rw [merge_eq (a :: b :: rest) i hi]
        have hb : (collapse (a :: b :: rest)).length ≤ n := by
          have hc := collapse_len_lt (a :: b :: rest) hlen2
          omega
        exact ih (collapse (a :: b :: rest)) (i / 2) hb hcoll

/-! ## The Rust-facing surface: root, proof, verify -/

/-- Merkle root over ordered leaves; `none` for the empty tree (Rust
`merkle_root` - an empty tree has no root: REFUSED, not zero). -/
def merkleRoot (leaves : List (BitVec 256)) : Option (BitVec 256) :=
  match leaves with
  | [] => none
  | _ => some (rootIter (leaves.map leafHash))

/-- Inclusion proof for leaf `i`, bottom-up siblings (Rust `merkle_proof`). -/
def proof (leaves : List (BitVec 256)) (i : Nat) : List (BitVec 256) :=
  proofAux i (leaves.map leafHash)

/-- Verify an inclusion proof of `leaf` at `idx` against `root`
(Rust `merkle_verify`). -/
def verify (root leaf : BitVec 256) (idx : Nat) (p : List (BitVec 256)) : Bool :=
  foldAux (leafHash leaf) idx p == root

/-- **Main theorem (inclusion completeness).** For every nonempty leaf list
and every in-range index, the canonical proof verifies against the canonical
root. One direction only - the converse (a verifying proof forces the leaf)
needs collision-freedom of the hash and is out of scope for an opaque model. -/
theorem merkle_inclusion_complete (leaves : List (BitVec 256)) (hne : leaves ≠ [])
    (i : Nat) (hi : i < leaves.length) :
    ∃ r, merkleRoot leaves = some r ∧ verify r leaves[i] i (proof leaves i) = true := by
  have hlen : (leaves.map leafHash).length = leaves.length := List.length_map ..
  refine ⟨rootIter (leaves.map leafHash), ?_, ?_⟩
  · cases leaves with
    | nil => exact absurd rfl hne
    | cons _ _ => rfl
  · have hs := path_sound (leaves.map leafHash).length (leaves.map leafHash) i
      (Nat.le_refl _) (by rw [hlen]; exact hi)
    have hmap : (leaves.map leafHash)[i] = leafHash leaves[i] :=
      List.getElem_map (f := leafHash) (l := leaves) (i := i)
        (h := by rw [hlen]; exact hi)
    have hmapb : (leaves.map leafHash)[i]! = leafHash leaves[i] := by
      rw [List.getElem!_eq_getElem?_getD, List.getElem?_eq_getElem
        (h := by rw [hlen]; exact hi), hmap]
      rfl
    rw [hs, hmapb]
    simp [verify, proof]

end ProcInt.StrataMerkle
