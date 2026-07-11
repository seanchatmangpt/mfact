use mfact_core::{
    compute_genesis_fold, hash_bytes, Artifact, Evidence, Manifest, Refusal,
    validate::validate_manifest_concurrently,
    receipt::{Fact, GgenReceiptEngine},
};
use proptest::prelude::*;
use std::collections::HashSet;

proptest! {
    #[test]
    fn test_hash_collision_resistance(data1 in any::<Vec<u8>>(), data2 in any::<Vec<u8>>()) {
        prop_assume!(data1 != data2);
        let hash1 = hash_bytes(&data1);
        let hash2 = hash_bytes(&data2);
        prop_assert_ne!(hash1, hash2);
    }

    #[test]
    fn test_hash_bytes_format_and_length(data in any::<Vec<u8>>()) {
        let hash = hash_bytes(&data);
        prop_assert_eq!(hash.len(), 64);
        prop_assert!(hash.chars().all(|c| c.is_ascii_hexdigit()));
    }
}

prop_compose! {
    fn arbitrary_artifact()(
        name in "[a-zA-Z0-9_]{1,30}",
        hash_data in any::<Vec<u8>>(),
        proven in any::<bool>()
    ) -> Artifact {
        Artifact {
            name,
            hash: hash_bytes(&hash_data),
            axioms: vec![],
            proven,
        }
    }
}

proptest! {
    #[test]
    fn test_compute_genesis_fold_non_commutative(
        release in "[a-zA-Z0-9_\\.-]{1,20}",
        art1 in arbitrary_artifact(),
        art2 in arbitrary_artifact()
    ) {
        prop_assume!(art1.hash != art2.hash);
        let artifacts1 = vec![art1.clone(), art2.clone()];
        let artifacts2 = vec![art2, art1];

        let fold1 = compute_genesis_fold(&release, &artifacts1).unwrap();
        let fold2 = compute_genesis_fold(&release, &artifacts2).unwrap();

        prop_assert_ne!(fold1, fold2);
    }

    #[test]
    fn test_compute_genesis_fold_mutation_sensitivity(
        release in "[a-zA-Z0-9_\\.-]{1,20}",
        mut artifacts in prop::collection::vec(arbitrary_artifact(), 1..20),
        mutation_idx in 0usize..20
    ) {
        let idx = mutation_idx % artifacts.len();
        let original_fold = compute_genesis_fold(&release, &artifacts).unwrap();

        // Mutate one artifact by appending a deterministic string
        let old_hash = artifacts[idx].hash.clone();
        artifacts[idx].hash = hash_bytes(format!("{}mutated", old_hash).as_bytes());

        let mutated_fold = compute_genesis_fold(&release, &artifacts).unwrap();

        // The genesis fold must completely diverge
        prop_assert_ne!(original_fold, mutated_fold);
    }
}

prop_compose! {
    fn arbitrary_evidence()(
        subject in "[a-zA-Z0-9_]{1,30}",
        kind in "[a-zA-Z0-9_]{1,30}",
        hash_data in any::<Vec<u8>>()
    ) -> Evidence {
        Evidence {
            subject,
            kind,
            hash: hash_bytes(&hash_data),
        }
    }
}

prop_compose! {
    fn arbitrary_manifest()(
        release in "[a-zA-Z0-9_]{1,20}",
        declaration_source in "[a-zA-Z0-9_]{1,20}",
        lean_source_origin in "[a-zA-Z0-9_]{1,20}",
        llm_trusted_base in any::<bool>(),
        scope in "[a-zA-Z0-9_]{1,20}",
        run_identifier in "[a-zA-Z0-9_]{1,20}",
        quadrature in "[a-zA-Z0-9_]{1,20}",
        mut artifacts in prop::collection::vec(arbitrary_artifact(), 1..10),
        mut evidence in prop::collection::vec(arbitrary_evidence(), 1..10),
        mut trusted_base in prop::collection::vec("[a-zA-Z0-9_]{1,20}", 1..10),
        fold_hash_data in any::<Vec<u8>>()
    ) -> Manifest {
        // Ensure no duplicates in artifacts
        let mut seen = HashSet::new();
        artifacts.retain(|a| seen.insert(a.name.clone()));
        if artifacts.is_empty() {
            artifacts.push(Artifact {
                name: "fallback_art".to_string(),
                hash: hash_bytes(b"fallback"),
                axioms: vec![],
                proven: true,
            });
        }

        // Ensure no duplicates in trusted_base
        let mut seen_tb = HashSet::new();
        trusted_base.retain(|tb| seen_tb.insert(tb.clone()));
        if trusted_base.is_empty() {
            trusted_base.push("fallback_tb".to_string());
        }

        Manifest {
            schema: "mfact/1.0".to_string(),
            release,
            declaration_source,
            lean_source_origin,
            trusted_base,
            llm_trusted_base,
            scope,
            run_identifier,
            quadrature,
            artifacts,
            evidence,
            stated_not_proven: vec![],
            fold_hash: hash_bytes(&fold_hash_data),
        }
    }
}

proptest! {
    #[test]
    fn test_valid_manifest_always_succeeds(manifest in arbitrary_manifest()) {
        prop_assert!(validate_manifest_concurrently(&manifest).is_ok());
    }

    #[test]
    fn test_manifest_schema_mutation_refusal(
        mut manifest in arbitrary_manifest(),
        bad_schema in "[a-lno-zA-Z0-9_]{1,10}" // ensures it doesn't start with 'mfact/'
    ) {
        manifest.schema = bad_schema;
        let res = validate_manifest_concurrently(&manifest);
        prop_assert!(matches!(res, Err(Refusal::InvalidFormat(_))));
    }

    #[test]
    fn test_manifest_empty_schema_refusal(mut manifest in arbitrary_manifest()) {
        manifest.schema = "".to_string();
        let res = validate_manifest_concurrently(&manifest);
        prop_assert!(matches!(res, Err(Refusal::ValidationFailed(_))));
    }

    #[test]
    fn test_manifest_duplicate_artifact_refusal(mut manifest in arbitrary_manifest()) {
        prop_assume!(!manifest.artifacts.is_empty());
        let dup = manifest.artifacts[0].clone();
        manifest.artifacts.push(dup);
        let res = validate_manifest_concurrently(&manifest);
        prop_assert!(matches!(res, Err(Refusal::DuplicateElement(_))));
    }

    #[test]
    fn test_manifest_invalid_hash_refusal(
        mut manifest in arbitrary_manifest(),
        bad_hash in "[a-z]{1,63}" // Invalid length
    ) {
        prop_assume!(!manifest.artifacts.is_empty());
        manifest.artifacts[0].hash = bad_hash;
        let res = validate_manifest_concurrently(&manifest);
        prop_assert!(matches!(res, Err(Refusal::InvalidHash(_))));
    }
}

prop_compose! {
    fn arbitrary_fact()(
        subject in "<[a-zA-Z0-9_:/\\.]{1,30}>",
        predicate in "<[a-zA-Z0-9_:/\\.]{1,30}>",
        object in "\"[a-zA-Z0-9_ ]{1,30}\"",
        has_graph in any::<bool>(),
        graph in "<[a-zA-Z0-9_:/\\.]{1,30}>"
    ) -> Fact {
        Fact {
            subject,
            predicate,
            object,
            graph: if has_graph { Some(graph) } else { None },
        }
    }
}

proptest! {
    #[test]
    fn test_receipt_engine_permutation_invariance(
        seed in "[a-zA-Z0-9_]{1,30}",
        mut facts in prop::collection::vec(arbitrary_fact(), 2..10)
    ) {
        // Ensure no duplicate facts in generated vector to avoid DuplicateElement error
        let mut seen = HashSet::new();
        facts.retain(|f| seen.insert(f.to_nquad()));
        prop_assume!(facts.len() >= 2);

        let engine = GgenReceiptEngine::new(&seed).unwrap();
        
        let receipt1 = engine.compute_receipt(&facts).unwrap();
        
        facts.reverse();
        let receipt2 = engine.compute_receipt(&facts).unwrap();
        
        prop_assert_eq!(receipt1.execution_fold, receipt2.execution_fold);
        prop_assert_eq!(receipt1.fact_count, receipt2.fact_count);
    }

    #[test]
    fn test_receipt_engine_mutation_sensitivity(
        seed in "[a-zA-Z0-9_]{1,30}",
        mut facts in prop::collection::vec(arbitrary_fact(), 1..10)
    ) {
        // Ensure no duplicate facts
        let mut seen = HashSet::new();
        facts.retain(|f| seen.insert(f.to_nquad()));
        prop_assume!(!facts.is_empty());

        let engine = GgenReceiptEngine::new(&seed).unwrap();
        let receipt1 = engine.compute_receipt(&facts).unwrap();
        
        // Mutate one fact
        facts[0].object = "\"mutated_object\"".to_string();
        
        // After mutation, could accidentally create duplicate, assume not
        let mut seen2 = HashSet::new();
        let all_unique = facts.iter().all(|f| seen2.insert(f.to_nquad()));
        prop_assume!(all_unique);

        let receipt2 = engine.compute_receipt(&facts).unwrap();
        prop_assert_ne!(receipt1.execution_fold, receipt2.execution_fold);
    }

    #[test]
    fn test_receipt_engine_duplicate_rejection_fuzzing(
        seed in "[a-zA-Z0-9_]{1,30}",
        mut facts in prop::collection::vec(arbitrary_fact(), 1..10)
    ) {
        prop_assume!(!facts.is_empty());
        let dup = facts[0].clone();
        facts.push(dup);

        let engine = GgenReceiptEngine::new(&seed).unwrap();
        let res = engine.compute_receipt(&facts);
        prop_assert!(matches!(res, Err(Refusal::DuplicateElement(_))));
    }
}
