-- RENDERED by `ggen sync` from the procint TTL declaration catalog (lean-math-pack).
-- Candidate Lean: admitted only by `lake build`. ggen renders; Lean admits.
-- Do not edit by hand: candidates enter through the ontology, never here.
import Mathlib
import ProcInt.Petri.GPU

/-! # ProcInt.Tests.GPU

GPU FFI verification tests -/

namespace ProcInt


def pushNat32 (arr : ByteArray) (val : Nat) : ByteArray :=
  let uval := val.toUInt32
  let b0 := uval.toUInt8
  let b1 := (uval >>> 8).toUInt8
  let b2 := (uval >>> 16).toUInt8
  let b3 := (uval >>> 24).toUInt8
  arr.push b0 |>.push b1 |>.push b2 |>.push b3

-- Build pre ByteArray: P = 2, T = 2, values = 1, 0, 0, 1
def testPre : ByteArray :=
  let arr := ByteArray.empty
  let arr := pushNat32 arr 2  -- P
  let arr := pushNat32 arr 2  -- T
  let arr := pushNat32 arr 1  -- pre[0,0]
  let arr := pushNat32 arr 0  -- pre[0,1]
  let arr := pushNat32 arr 0  -- pre[1,0]
  pushNat32 arr 1             -- pre[1,1]

-- Build post ByteArray: P = 2, T = 2, values = 0, 1, 1, 0
def testPost : ByteArray :=
  let arr := ByteArray.empty
  let arr := pushNat32 arr 2  -- P
  let arr := pushNat32 arr 2  -- T
  let arr := pushNat32 arr 0  -- post[0,0]
  let arr := pushNat32 arr 1  -- post[0,1]
  let arr := pushNat32 arr 1  -- post[1,0]
  pushNat32 arr 0             -- post[1,1]

-- Build markings ByteArray: contains 2 candidates
-- Each candidate has: M (2 uint32), M' (2 uint32), u (2 uint32) -> 6 uint32 -> 24 bytes
-- Candidate 1: M = [1,0], M' = [0,1], u = [1,0] (valid, expect 1)
-- Candidate 2: M = [1,0], M' = [1,0], u = [1,0] (invalid, expect 0)
def testMarkings : ByteArray :=
  let arr := ByteArray.empty
  -- Candidate 1
  let arr := pushNat32 arr 1  -- M[0]
  let arr := pushNat32 arr 0  -- M[1]
  let arr := pushNat32 arr 0  -- M'[0]
  let arr := pushNat32 arr 1  -- M'[1]
  let arr := pushNat32 arr 1  -- u[0]
  let arr := pushNat32 arr 0  -- u[1]
  -- Candidate 2
  let arr := pushNat32 arr 1  -- M[0]
  let arr := pushNat32 arr 0  -- M[1]
  let arr := pushNat32 arr 1  -- M'[0]
  let arr := pushNat32 arr 0  -- M'[1]
  let arr := pushNat32 arr 1  -- u[0]
  pushNat32 arr 0             -- u[1]

-- Run tests
def runGpuTest : Bool :=
  let resCpu := checkStateEquationCpu testPre testPost testMarkings
  let resGpu := checkStateEquationGpu testPre testPost testMarkings
  let cpuOk := resCpu.size == 2 && resCpu.get! 0 == 1 && resCpu.get! 1 == 0
  let gpuOk := resGpu.size == 2 && resGpu.get! 0 == 1 && resGpu.get! 1 == 0
  cpuOk && gpuOk

#guard runGpuTest == true

def runGpuAsyncTest : Task Bool :=
  let task := checkStateEquationAsync testPre testPost testMarkings
  task.map (fun res => res.size == 2 && res.get! 0 == 1 && res.get! 1 == 0)



end ProcInt
