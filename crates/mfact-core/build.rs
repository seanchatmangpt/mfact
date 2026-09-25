use std::process::Command;
use std::path::PathBuf;

fn main() {
    println!("cargo:rerun-if-changed=../../research-papers/bio_signals/.lake/build/ir/Thermo.c");
    println!("cargo:rerun-if-changed=../../research-papers/aeneas_rust_verification/.lake/build/ir/Thermo.c");
    println!("cargo:rerun-if-changed=../../research-papers/ortac_plus/.lake/build/ir/Thermo.c");

    let lean_prefix_output = match Command::new("lean").arg("--print-prefix").output() {
        Ok(out) => out,
        Err(_) => {
            println!("cargo:warning=Failed to execute lean --print-prefix, skipping Lean FFI linking.");
            return;
        }
    };
    
    let lean_prefix_str = match String::from_utf8(lean_prefix_output.stdout) {
        Ok(s) => s,
        Err(_) => {
            println!("cargo:warning=Lean output is not valid UTF-8.");
            return;
        }
    };
    
    let lean_prefix = lean_prefix_str.trim();
    if lean_prefix.is_empty() {
        println!("cargo:warning=Lean prefix is empty.");
        return;
    }
    
    let lean_include = PathBuf::from(lean_prefix).join("include");
    let lean_lib = PathBuf::from(lean_prefix).join("lib").join("lean");

    println!("cargo:rustc-link-search=native={}", lean_lib.display());
    println!("cargo:rustc-link-lib=dylib=leanshared");
    println!("cargo:rustc-link-arg=-Wl,-rpath,{}", lean_lib.display());

    cc::Build::new()
        .file("../../research-papers/bio_signals/.lake/build/ir/Thermo.c")
        .file("../../research-papers/aeneas_rust_verification/.lake/build/ir/Thermo.c")
        .file("../../research-papers/ortac_plus/.lake/build/ir/Thermo.c")
        .file("../../procint/.lake/build/ir/ProcInt/Planning/Pddl.c")
        .file("../../procint/.lake/build/ir/ProcInt/Models/Powl.c")
        .file("src/lean_ffi_wrapper.c")
        .include(lean_include)
        .compile("thermo_lean");
}
