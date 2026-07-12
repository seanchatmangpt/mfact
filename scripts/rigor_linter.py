import os
import re
import sys

def scan_file(filepath):
    try:
        with open(filepath, 'r') as f:
            content = f.read()
    except Exception:
        return []

    errors = []

    # 1. Lean Fake Proofs
    if filepath.endswith('.lean'):
        if 'def hello := "world"' in content:
            errors.append("Fake Lean 4 syntax detected ('def hello := \"world\"').")
            
        # Strip Lean comments to avoid false positives in docstrings
        no_comments = re.sub(r'/-.*?-/|--.*?\n', '', content, flags=re.DOTALL)
        if re.search(r'\bsorry\b', no_comments):
            errors.append("Unproved theorem detected ('sorry'). Proofs must be mechanically verified.")

    # 2. Rust Fake Mechanics
    if filepath.endswith('.rs'):
        # Empty Traits (surface level rigor)
        if re.search(r'pub\s+trait\s+\w+\s*\{\s*\}', content):
            errors.append("Empty trait detected. Traits must define mechanical bounds or methods.")
        
        # Zero-Field Marker Structs (e.g. pub struct SubKolmogorovBound;)
        if re.search(r'pub\s+struct\s+\w+\s*;', content):
            errors.append("Zero-field marker struct detected. Types must contain computational state.")

        # PhantomData-only marker structs: same shape as a zero-field marker struct, just
        # spelled with braces instead of a semicolon, so the check above misses it. A struct
        # whose ENTIRE field list is PhantomData carries no runtime data either. This is
        # exactly what RegionAbstraction looked like before it was given real fields --
        # `{ _data: PhantomData<&'a mut T>, _invariant: PhantomData<I> }` has two fields, so
        # it isn't a unit struct, but it's functionally identical to one.
        for struct_match in re.finditer(r'pub\s+struct\s+(\w+)[^{;]*\{([^}]*)\}', content, re.DOTALL):
            field_lines = [l.strip() for l in struct_match.group(2).split(',') if l.strip()]
            if field_lines and all(re.search(r':\s*PhantomData\b', l) for l in field_lines):
                errors.append(
                    f"PhantomData-only struct detected ('{struct_match.group(1)}'). Every "
                    f"field is PhantomData -- no runtime data, same problem as a zero-field "
                    f"marker struct with extra ceremony."
                )

        # Empty trait implementations (e.g. `impl SafeDiscipline for LeanPortfolioManagement {}`).
        # Distinct from the empty-trait-*definition* check above: this catches a trait that DOES
        # have real methods elsewhere, but is implemented here with zero method bodies -- only
        # possible if every method has a default impl the type never overrides, which is the same
        # "type-level scaffolding, zero domain logic" pattern found in crates/safe-toolbox/src/safe.rs.
        for impl_match in re.finditer(r'impl\s+(\w+)\s+for\s+(\w+)\s*\{\s*\}', content):
            errors.append(
                f"Empty trait impl detected ('impl {impl_match.group(1)} for "
                f"{impl_match.group(2)} {{}}'). Zero method bodies means this type relies "
                f"entirely on trait defaults, or the trait itself has no real methods -- "
                f"either way, nothing domain-specific happens here."
            )

        # Unimplemented and Todo macros
        if 'unimplemented!()' in content or 'todo!()' in content:
            errors.append("unimplemented!() or todo!() detected. Code must be fully mechanically realized.")
            
        # Dead alternative functions
        if re.search(r'fn\s+\w+_(v2|alt|correct|fixed|working)\s*\(', content):
            errors.append("Dead alternative function detected (_v2, _alt, etc). Do not leave multiple broken versions.")
            
        # Discarding input and returning Ok (e.g. let _ = data; Ok(()))
        if re.search(r'let\s+_\s*=\s*\w+;\s*(return\s+)?Ok\(\(\)\)?;', content):
            errors.append("Fake execution block detected (discarding input and returning unconditionally).")

        # Broader form of the check above: `let _ = x;` throws a parameter away, and *any*
        # unconditional constructor/return call right after it (not just Ok(())) means the
        # function's signature promises to use `x` but the body never inspects it. This is
        # what the original `apply_turbulence_bound` did -- `let _ = data;` followed by
        # `RegionAbstraction::new()`, which the Ok(())-specific check above never matched.
        if re.search(r'let\s+_\s*=\s*\w+\s*;\s*(//[^\n]*\n\s*)*(return\s+)?\w[\w:<>]*\s*\(', content):
            errors.append(
                "Discarded-input constructor detected (`let _ = x;` followed by an "
                "unconditional constructor/return call) -- the function signature takes a "
                "parameter it never actually inspects."
            )

        # Fake sci-fi vocabulary assertions
        sci_fi_terms = ['Warp Drive', 'Bekenstein bound', 'Heat Death', 'SubKolmogorov', 'Quantum Blocker']
        for term in sci_fi_terms:
            if term.lower() in content.lower():
                errors.append(f"Forbidden sci-fi vocabulary detected: '{term}'.")

        # Claim-without-mechanism: a doc comment above a `pub fn` uses strong
        # enforcement/verification language ("statically", "enforced", "verified", "proven",
        # "guarantee", "rejects", "borrow checker") but the function body has no branching
        # (if/match/while/for) or comparison operator anywhere -- nothing in the body could
        # possibly reject or validate anything, so the doc comment's claim has no mechanism
        # behind it. General form of the SubKolmogorovBound finding: this doesn't require
        # knowing the specific vocabulary in advance the way the sci-fi-terms list does, so
        # it should catch the next invented term too, not just today's known ones.
        claim_words = re.compile(
            r'\b(statically|mechanically enforc|is enforced|cryptographically verif'
            r'|is proven|guarantee[sd]?|rejects?\b|borrow checker)\b',
            re.IGNORECASE,
        )
        for fn_match in re.finditer(
            r'((?:^[ \t]*///.*\n)+)^[ \t]*pub\s+fn\s+(\w+)[^{]*\{', content, re.MULTILINE
        ):
            doc, name = fn_match.group(1), fn_match.group(2)
            if not claim_words.search(doc):
                continue
            depth = 1
            i = fn_match.end()
            while i < len(content) and depth > 0:
                if content[i] == '{':
                    depth += 1
                elif content[i] == '}':
                    depth -= 1
                i += 1
            body = content[fn_match.end() : i]
            if not re.search(r'\b(if|match|while|for)\b|[=!<>]=|[<>]', body):
                errors.append(
                    f"Claim-without-mechanism in `fn {name}`: doc comment uses enforcement/"
                    f"verification language but the body has no branching or comparison "
                    f"anywhere -- nothing is actually checked."
                )

    # 3. Universal LLM Hedge Comments & Mocks
    hedge_comments = ['in a real implementation', 'for now', 'TODO: implement', 'mock', 'dummy']
    for hc in hedge_comments:
        if hc.lower() in content.lower():
            errors.append(f"Hedge comment or mock detected: '{hc}'. Overwrite with a correct implementation.")

    return errors

def main():
    mfact_dir = '/Users/sac/mfact'
    has_errors = False
    
    print(f"Running Rigor Linter across {mfact_dir}...")
    
    for root, dirs, files in os.walk(mfact_dir):
        # Ignore compiled output and third-party dependencies
        if any(ignore in root for ignore in ['target', '.git', 'node_modules', 'dist', '.lake', '.venv']):
            continue
            
        for file in files:
            if file.endswith('.rs') or file.endswith('.lean') or file.endswith('.ts') or file.endswith('.js'):
                filepath = os.path.join(root, file)
                errs = scan_file(filepath)
                if errs:
                    has_errors = True
                    print(f"\n[VIOLATION] {filepath}")
                    for e in errs:
                        print(f"  -> {e}")

    if has_errors:
        print("\n❌ LINTER FAILED: Surface-level rigor detected. Code is rejected.")
        sys.exit(1)
    else:
        print("\n✅ LINTER PASSED: No surface-level rigor detected. Code is mechanically real.")
        sys.exit(0)

if __name__ == '__main__':
    main()
