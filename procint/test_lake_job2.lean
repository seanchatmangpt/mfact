import Lake
open Lake

-- Query what monad class instances exist for JobM
#check (inferInstance : Monad JobM)
#check (inferInstance : MonadLift IO JobM)
#check (inferInstance : MonadError JobM)
#check (inferInstance : MonadExcept _ JobM)
