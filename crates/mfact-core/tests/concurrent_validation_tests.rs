use mfact_core::validate::validate_manifest_concurrently;
use mfact_core::{Artifact, Evidence, Manifest, Refusal};

fn build_large_manifest(size: usize) -> Manifest {
    let mut artifacts = Vec::with_capacity(size);
    let mut evidence = Vec::with_capacity(size);

    for i in 0..size {
        artifacts.push(Artifact {
            name: format!("Artifact{}", i),
            hash: "a".repeat(64),
            axioms: vec![],
            proven: true,
        });

        evidence.push(Evidence {
            subject: format!("Artifact{}", i),
            kind: "test".to_string(),
            hash: "b".repeat(64),
        });
    }

    Manifest {
        schema: "mfact/1.0".to_string(),
        release: "v1".to_string(),
        declaration_source: "src".to_string(),
        lean_source_origin: "origin".to_string(),
        trusted_base: vec!["core".to_string()],
        llm_trusted_base: false,
        scope: "scope".to_string(),
        run_identifier: "run".to_string(),
        quadrature: "quad".to_string(),
        artifacts,
        evidence,
        stated_not_proven: vec![],
        fold_hash: "c".repeat(64),
    }
}

#[test]
fn test_concurrent_validation_success_large_scale() {
    let manifest = build_large_manifest(10_000);
    let result = validate_manifest_concurrently(&manifest);
    assert!(
        result.is_ok(),
        "Large manifest should validate successfully"
    );
}

#[test]
fn test_concurrent_validation_artifact_invalid_hash_fast_fail() {
    let mut manifest = build_large_manifest(10_000);
    // Inject invalid hash deep in the artifacts
    manifest.artifacts[9999].hash = "invalid_length".to_string();

    let result = validate_manifest_concurrently(&manifest);
    assert!(matches!(result, Err(Refusal::InvalidHash(_))));
}

#[test]
fn test_concurrent_validation_artifact_empty_name_fast_fail() {
    let mut manifest = build_large_manifest(10_000);
    // Inject empty name deep in the artifacts
    manifest.artifacts[8888].name = "".to_string();

    let result = validate_manifest_concurrently(&manifest);
    assert!(
        matches!(result, Err(Refusal::ValidationFailed(ref msg)) if msg.contains("Artifact name cannot be empty"))
    );
}

#[test]
fn test_concurrent_validation_duplicate_artifact() {
    let mut manifest = build_large_manifest(10_000);
    // Duplicate an artifact
    let dup = manifest.artifacts[500].clone();
    manifest.artifacts.push(dup);

    let result = validate_manifest_concurrently(&manifest);
    assert!(matches!(result, Err(Refusal::DuplicateElement(_))));
}

#[test]
fn test_concurrent_validation_evidence_invalid_hash_fast_fail() {
    let mut manifest = build_large_manifest(10_000);
    // Inject invalid hash deep in the evidence
    manifest.evidence[9999].hash = "invalid_length".to_string();

    let result = validate_manifest_concurrently(&manifest);
    assert!(matches!(result, Err(Refusal::InvalidHash(_))));
}

#[test]
fn test_concurrent_validation_evidence_empty_subject_fast_fail() {
    let mut manifest = build_large_manifest(10_000);
    // Inject empty subject deep in the evidence
    manifest.evidence[7777].subject = "".to_string();

    let result = validate_manifest_concurrently(&manifest);
    assert!(
        matches!(result, Err(Refusal::ValidationFailed(ref msg)) if msg.contains("Evidence subject cannot be empty"))
    );
}

#[test]
fn test_concurrent_validation_duplicate_trusted_base() {
    let mut manifest = build_large_manifest(100);
    manifest.trusted_base.push("core".to_string());

    let result = validate_manifest_concurrently(&manifest);
    assert!(matches!(result, Err(Refusal::DuplicateElement(_))));
}
