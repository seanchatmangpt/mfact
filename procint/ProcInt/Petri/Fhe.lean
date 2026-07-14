-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.Net
import ProcInt.Petri.Firing
open Classical

/-! # ProcInt.Petri.Fhe

Fully Homomorphic Encryption (FHE) evaluation of Petri Net transitions and plaintext equivalence proof. -/

namespace ProcInt

/-- An abstract model of a Fully Homomorphic Encryption (FHE) scheme.
    This provides decryption homomorphisms for additions, multiplications, and comparisons. -/
structure FheScheme (Ciphertext SecretKey : Type) where
  decrypt : SecretKey → Ciphertext → ℤ
  add : Ciphertext → Ciphertext → Ciphertext
  sub : Ciphertext → Ciphertext → Ciphertext
  mul : Ciphertext → Ciphertext → Ciphertext
  mul_const : Ciphertext → ℤ → Ciphertext
  add_const : Ciphertext → ℤ → Ciphertext
  geq_const : Ciphertext → ℤ → Ciphertext
  encrypt_one : Ciphertext

  -- Decryption Homomorphisms
  decrypt_add : ∀ sk c1 c2, decrypt sk (add c1 c2) = decrypt sk c1 + decrypt sk c2
  decrypt_sub : ∀ sk c1 c2, decrypt sk (sub c1 c2) = decrypt sk c1 - decrypt sk c2
  decrypt_mul : ∀ sk c1 c2, decrypt sk (mul c1 c2) = decrypt sk c1 * decrypt sk c2
  decrypt_mul_const : ∀ sk c k, decrypt sk (mul_const c k) = decrypt sk c * k
  decrypt_add_const : ∀ sk c k, decrypt sk (add_const c k) = decrypt sk c + k
  decrypt_geq_const : ∀ sk c k, decrypt sk (geq_const c k) = if decrypt sk c ≥ k then 1 else 0
  decrypt_one : ∀ sk, decrypt sk encrypt_one = 1

/-- An encrypted FHE marking maps each place to a ciphertext. -/
def FheMarking (P Ciphertext : Type) := P → Ciphertext

/-- Decryption of an FHE marking yields an integer-valued marking. -/
def FheMarking.decrypt {Ciphertext SecretKey : Type} (scheme : FheScheme Ciphertext SecretKey)
    (sk : SecretKey) {P : Type} (M : FheMarking P Ciphertext) : P → ℤ :=
  fun p => scheme.decrypt sk (M p)

/-- An FHE marking matches a plaintext marking if their decryptions agree. -/
def FheMarking.Matches {Ciphertext SecretKey : Type} (scheme : FheScheme Ciphertext SecretKey)
    (sk : SecretKey) {P : Type} (M : FheMarking P Ciphertext) (m : Marking P) : Prop :=
  ∀ p, scheme.decrypt sk (M p) = (m p : ℤ)

/-- Homomorphic transition enablement: returns an encrypted 0/1 boolean (as a ciphertext)
    signifying whether the transition is enabled. -/
noncomputable def homomorphicEnabled {P T Ciphertext SecretKey : Type} [DecidableEq P]
    (scheme : FheScheme Ciphertext SecretKey) (N : PetriNet P T) (M : FheMarking P Ciphertext) (t : T) : Ciphertext :=
  let support := (N.pre t).support.toList
  support.foldr (fun p acc => scheme.mul (scheme.geq_const (M p) (N.pre t p)) acc) scheme.encrypt_one

/-- Auxiliary lemma: decryption of the product of encrypted geq statements. -/
theorem decrypt_foldr_geq {P Ciphertext SecretKey : Type} [DecidableEq P]
    (scheme : FheScheme Ciphertext SecretKey) (sk : SecretKey) (N : PetriNet P T) (M : FheMarking P Ciphertext) (t : T) (l : List P) :
    scheme.decrypt sk (l.foldr (fun p acc => scheme.mul (scheme.geq_const (M p) (N.pre t p)) acc) scheme.encrypt_one) =
      (l.map (fun p => if scheme.decrypt sk (M p) ≥ (N.pre t p : ℤ) then (1 : ℤ) else 0)).prod := by
  induction l with
  | nil =>
    simp [scheme.decrypt_one]
  | cons p ps ih =>
    simp [scheme.decrypt_mul, scheme.decrypt_geq_const, ih]

/-- Homomorphic transition firing: computes the next marking without decrypting,
    using a homomorphic multiplexer. -/
noncomputable def homomorphicFire {P T Ciphertext SecretKey : Type} [DecidableEq P]
    (scheme : FheScheme Ciphertext SecretKey) (N : PetriNet P T) (M : FheMarking P Ciphertext) (t : T) : FheMarking P Ciphertext :=
  let enabled := homomorphicEnabled scheme N M t
  fun p =>
    let diff : ℤ := (N.post t p : ℤ) - (N.pre t p : ℤ)
    scheme.add (M p) (scheme.mul_const enabled diff)

/-- Plaintext equivalence theorem: homomorphic firing is equivalent to plaintext Petri net transition firing. -/
theorem fhe_firing_equivalence {P T Ciphertext SecretKey : Type} [DecidableEq P]
    (scheme : FheScheme Ciphertext SecretKey) (sk : SecretKey) (N : PetriNet P T)
    (M : FheMarking P Ciphertext) (t : T) (m : Marking P)
    (h_match : FheMarking.Matches scheme sk M m)
    (h_nonneg : ∀ p, scheme.decrypt sk (M p) ≥ 0)
    (h_enabled_dec : scheme.decrypt sk (homomorphicEnabled scheme N M t) = if N.Enabled m t then 1 else 0) :
    FheMarking.Matches scheme sk (homomorphicFire scheme N M t)
      (if N.Enabled m t then N.fire m t else m) := by
  intro p
  dsimp [homomorphicFire]
  rw [scheme.decrypt_add, scheme.decrypt_mul_const]
  rw [h_enabled_dec]
  split_ifs with h_enabled
  · simp only [Int.ofNat_eq_natCast]
    have h_m_eq : scheme.decrypt sk (M p) = m p := h_match p
    rw [h_m_eq]
    dsimp [PetriNet.fire]
    simp only [Finsupp.add_apply, Finsupp.sub_apply, Finsupp.tsub_apply]
    have h_le : N.pre t p ≤ m p := h_enabled p
    omega
  · simp only [Int.ofNat_eq_natCast]
    have h_m_eq : scheme.decrypt sk (M p) = m p := h_match p
    rw [h_m_eq]
    simp


end ProcInt
