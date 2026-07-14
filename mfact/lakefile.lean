import Lake
open Lake DSL

package mfact where
  version := v!"26.7.14"

@[default_target]
lean_lib Mfact where

lean_lib AxiomAudit where

lean_lib MfactLinter where
  precompileModules := true

lean_exe mfact where
  root := `Mfact.Cli
