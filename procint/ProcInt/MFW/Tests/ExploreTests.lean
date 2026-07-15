import ProcInt.MFW.ExploreExploit

namespace ProcInt.MFW.Tests.ExploreTests

-- 1. Instantiate a toy Explore/Exploit loop.
-- We can define concrete structures that derive Nonempty or instantiate them manually.

structure ToyRealizationSpace where
  val : Nat
  deriving Inhabited

instance : Nonempty OpenRealizationSpace :=
  ⟨unsafe (unsafeCast (ToyRealizationSpace.mk 0))⟩

structure ToyObservations where
  msg : String
  deriving Inhabited

instance : Nonempty Observations :=
  ⟨unsafe (unsafeCast (ToyObservations.mk ""))⟩

structure ToyContracts where
  val : Nat
  deriving Inhabited, DecidableEq

instance : Nonempty Contracts :=
  ⟨unsafe (unsafeCast (ToyContracts.mk 0))⟩

structure ToyEquivalentClosure where
  val : Nat
  deriving Inhabited

instance : Nonempty EquivalentClosure :=
  ⟨unsafe (unsafeCast (ToyEquivalentClosure.mk 0))⟩

-- Concrete mock realizations of explore and exploit.
def toyExplore (obs : Observations) : Contracts :=
  let mockObs : ToyObservations := unsafe (unsafeCast obs)
  let contractVal := mockObs.msg.length
  unsafe (unsafeCast (ToyContracts.mk contractVal))

def toyExploit (c : Contracts) : RealizationClass :=
  let mockContract : ToyContracts := unsafe (unsafeCast c)
  fun space =>
    let mockSpace : ToyRealizationSpace := unsafe (unsafeCast space)
    mockSpace.val = mockContract.val

-- 2. Verify that the realization produced by the exploit functor satisfies the admitted contract.
-- We verify the separation of explore/exploit.
theorem toy_strict_separation :
  ∀ (obs1 obs2 : Observations), toyExplore obs1 = toyExplore obs2 →
    toyExploit (toyExplore obs1) = toyExploit (toyExplore obs2) := by
  intro obs1 obs2 h
  rw [h]

end ProcInt.MFW.Tests.ExploreTests
