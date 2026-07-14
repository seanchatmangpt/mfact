-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib

/-! # ProcInt.Petri.GPU

GPU acceleration FFI interface for Petri Net state equations -/

namespace ProcInt


/-- Call the native GPU (Metal or CUDA) checker for state equation solvability.
  `pre` and `post` are flattened incidence matrices of size P * T.
  `markings` is a flattened sequence of marking candidates to check.
  Returns a `ByteArray` of results (1 byte per candidate marking: 1 if solvable, 0 if not). -/
@[extern "check_state_equation_gpu_ffi"]
opaque checkStateEquationGpu (pre : ByteArray) (post : ByteArray) (markings : ByteArray) : ByteArray

/-- Asynchronous wrapper for the GPU checker to run on Lean's thread pool without blocking. -/
def checkStateEquationAsync (pre : ByteArray) (post : ByteArray) (markings : ByteArray) : Task ByteArray :=
  Task.spawn (fun _ => checkStateEquationGpu pre post markings)

/-- Safe access to a byte from ByteArray. -/
def getByte (arr : ByteArray) (idx : Nat) : UInt8 :=
  if idx < arr.size then arr.get! idx else 0

/-- Parse a little-endian 32-bit unsigned integer from a ByteArray at a given offset. -/
def readUInt32 (arr : ByteArray) (offset : Nat) : UInt32 :=
  let b0 : UInt32 := getByte arr offset |>.toUInt32
  let b1 : UInt32 := getByte arr (offset + 1) |>.toUInt32
  let b2 : UInt32 := getByte arr (offset + 2) |>.toUInt32
  let b3 : UInt32 := getByte arr (offset + 3) |>.toUInt32
  b0 + (b1 <<< 8) + (b2 <<< 16) + (b3 <<< 24)

/-- Reference CPU implementation of the check for fallback or verification (DIFFERENTIAL testing family). -/
def checkStateEquationCpu (pre : ByteArray) (post : ByteArray) (markings : ByteArray) : ByteArray := Id.run do
  if pre.size < 8 || post.size < 8 then
    pure ⟨#[]⟩
  else
    let P := readUInt32 pre 0 |>.toNat
    let T := readUInt32 pre 4 |>.toNat
    let cand_size_bytes := (2 * P + T) * 4
    let num_candidates := markings.size / cand_size_bytes
    
    let mut results := ⟨#[]⟩
    for i in [0:num_candidates] do
      let offset := i * cand_size_bytes
      let mut ok := true
      for p in [0:P] do
        let m_val := readUInt32 markings (offset + p * 4) |>.toNat
        let m_prime_val := readUInt32 markings (offset + (P + p) * 4) |>.toNat
        let mut expected := m_val
        for t in [0:T] do
          let pre_val := readUInt32 pre (8 + (p * T + t) * 4) |>.toNat
          let post_val := readUInt32 post (8 + (p * T + t) * 4) |>.toNat
          let u_val := readUInt32 markings (offset + (2 * P + t) * 4) |>.toNat
          if post_val >= pre_val then
            expected := expected + (post_val - pre_val) * u_val
          else
            let diff := (pre_val - post_val) * u_val
            if expected >= diff then
              expected := expected - diff
            else
              expected := 0
              ok := false
        if expected != m_prime_val then
          ok := false
      if ok then
        results := results.push 1
      else
        results := results.push 0
    pure results



end ProcInt
