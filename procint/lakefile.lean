import Lake
open System Lake DSL

package procint where
  version := v!"26.7.14"
  testDriver := "Tests"
  moreLeanArgs := #["-s", "65520"]
  moreLinkArgs := if System.Platform.isOSX then
    #["-framework", "Metal", "-framework", "Foundation"]
  else
    #[]


require cslib from git
  "https://github.com/leanprover/cslib.git" @ "1dbda5335e3fc06c414b84ca885a35d4c6d4ab7c"

require mfact from "../mfact"

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "fabf563a7c95a166b8d7b6efca11c8b4dc9d911f"

-- require batteries from "../batteries"

target ggenSync pkg : FilePath := do
  let stampFile := pkg.buildDir / "ggen-sync.stamp"
  IO.FS.createDirAll pkg.buildDir
  let rootDir := pkg.dir / ".."
  let out ← IO.Process.output {
    cmd := "ggen",
    args := #["sync", "run"],
    cwd := rootDir
  }
  if out.exitCode != 0 then
    error s!"'ggen sync run' failed with exit code {out.exitCode}:\n{out.stderr}"
  IO.FS.writeFile stampFile "OK"
  return Job.nil.map fun _ => stampFile

@[default_target]
lean_lib ProcInt where
  -- precompileModules := true
  extraDepTargets := #[`ggenSync]

-- Platform-conditional Metal FFI static library build target compiling ffi/gpu_proving.m
extern_lib libmetal_prov (pkg : NPackage __name__) := do
  let name := "metal_prov"
  let srcDir := pkg.dir / "ffi"
  let srcFile := srcDir / "gpu_proving.m"
  let oFile := pkg.buildDir / "ffi" / "gpu_proving.o"
  let staticLib := pkg.buildDir / "ffi" / s!"lib{name}.a"
  let leanIncDir ← getLeanIncludeDir

  let compileFlags := if System.Platform.isOSX then
    #[ "-c", srcFile.toString,
       "-o", oFile.toString,
       "-I", leanIncDir.toString,
       "-O3", "-fobjc-arc" ]
  else
    #[ "-c", srcFile.toString,
       "-o", oFile.toString,
       "-I", leanIncDir.toString,
       "-O3" ]

  let buildA ← Job.async do
    IO.FS.createDirAll (pkg.buildDir / "ffi")
    proc {
      cmd := "clang"
      args := compileFlags
    }
    proc {
      cmd := "ar"
      args := #["rcs", staticLib.toString, oFile.toString]
    }
    pure staticLib

  return buildA

lean_lib AxiomAudit

lean_lib Quadrature where
  roots := #[`ProcInt.Release.Quadrature]

lean_lib Tests where
  roots := #[`ProcInt.Tests]

lean_lib PostRelease where
  roots := #[`ProcInt.Release.PostRelease]

lean_lib Playground where
  roots := #[`ProcInt.Playground]

lean_exe swarm11Verifier where
  root := `ProcInt.Playground.Swarm11Verifier

lean_lib Advanced where
  precompileModules := false
  roots := #[`ProcInt.Advanced.DSL, `ProcInt.Advanced.Meta, `ProcInt.Advanced.Visual, `ProcInt.Advanced.TestTactic]
