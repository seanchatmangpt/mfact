import ProcInt.Tests.GPU

def main : IO Unit := do
  IO.println "Running GPU tests..."
  let resCpuGpu := ProcInt.runGpuTest
  IO.println s!"GPU Test result (CPU vs GPU differential): {resCpuGpu}"
  let asyncTask := ProcInt.runGpuAsyncTest
  let resAsync ← IO.wait asyncTask
  IO.println s!"GPU Async Test result: {resAsync}"
  if resCpuGpu && resAsync then
    IO.println "SUCCESS"
  else
    IO.println "FAILURE"
