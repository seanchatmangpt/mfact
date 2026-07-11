pub mod ledger;
use serde::{Deserialize, Serialize};

/// Every error in the system is a typed Refusal. No panics, no unwraps.
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub enum Refusal {
    HandCodedGeneratedOutput,
    GeneratedOutputDrift,
    MissingGgenSource(String),
    MissingGgenTemplate(String),
    OrphanGeneratedFile(String),
    UnregisteredPaperFragment(String),
    UnsupportedStandingClaim,
    StatedPromotedToProven,
    ManualReleaseCount,
    ManualReleaseHash,
    ReceiptRecursionRefused,
    SourceChangeAssertionUnsupported,
    CountermodelPromotionRefused,
    ArtifactDriftRefused(String),
    Io(String), // We map std::io::Error to a typed refusal with the error message
    Serialization(String),
}

impl core::fmt::Display for Refusal {
    fn fmt(&self, f: &mut core::fmt::Formatter<'_>) -> core::fmt::Result {
        match self {
            Self::HandCodedGeneratedOutput => write!(f, "HAND_CODED_GENERATED_OUTPUT"),
            Self::GeneratedOutputDrift => write!(f, "GENERATED_OUTPUT_DRIFT"),
            Self::MissingGgenSource(path) => write!(f, "MISSING_GGEN_SOURCE: {}", path),
            Self::MissingGgenTemplate(path) => write!(f, "MISSING_GGEN_TEMPLATE: {}", path),
            Self::OrphanGeneratedFile(path) => write!(f, "ORPHAN_GENERATED_FILE: {}", path),
            Self::UnregisteredPaperFragment(path) => {
                write!(f, "UNREGISTERED_PAPER_FRAGMENT: {}", path)
            }
            Self::UnsupportedStandingClaim => write!(f, "UNSUPPORTED_STANDING_CLAIM"),
            Self::StatedPromotedToProven => write!(f, "STATED_PROMOTED_TO_PROVEN"),
            Self::ManualReleaseCount => write!(f, "MANUAL_RELEASE_COUNT"),
            Self::ManualReleaseHash => write!(f, "MANUAL_RELEASE_HASH"),
            Self::ReceiptRecursionRefused => write!(f, "RECEIPT_RECURSION_REFUSED"),
            Self::SourceChangeAssertionUnsupported => {
                write!(f, "SOURCE_CHANGE_ASSERTION_UNSUPPORTED")
            }
            Self::CountermodelPromotionRefused => write!(f, "COUNTERMODEL_PROMOTION_REFUSED"),
            Self::ArtifactDriftRefused(path) => write!(f, "ARTIFACT_DRIFT_REFUSED: {}", path),
            Self::Io(msg) => write!(f, "IO_ERROR: {}", msg),
            Self::Serialization(msg) => write!(f, "SERIALIZATION_ERROR: {}", msg),
        }
    }
}

impl std::error::Error for Refusal {}

impl From<std::io::Error> for Refusal {
    fn from(err: std::io::Error) -> Self {
        Self::Io(err.to_string())
    }
}

impl From<serde_json::Error> for Refusal {
    fn from(err: serde_json::Error) -> Self {
        Self::Serialization(err.to_string())
    }
}

/// A computed receipt, hashed using BLAKE3. Receipts are computed, never asserted.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Receipt {
    /// The BLAKE3 hash of the canonical N-Quads order of the facts.
    pub hash: String,
    /// The canonical facts represented in this receipt.
    pub facts: Vec<String>,
}

impl Receipt {
    /// Compute a receipt from a list of facts. The facts are sorted to ensure
    /// canonical N-Quads order, and then hashed using BLAKE3.
    pub fn compute(mut facts: Vec<String>) -> Result<Self, Refusal> {
        // Sort facts to guarantee canonical order
        facts.sort();

        let mut hasher = blake3::Hasher::new();
        for fact in &facts {
            hasher.update(fact.as_bytes());
            // Add a newline separator between facts to prevent concatenation collisions
            hasher.update(b"\n");
        }

        let hash = hasher.finalize().to_hex().to_string();

        Ok(Self { hash, facts })
    }

    /// Recursively hashes a directory and produces a list of facts
    /// containing the BLAKE3 hash for each file.
    pub fn hash_directory(path: &std::path::Path) -> Result<Vec<String>, Refusal> {
        let mut facts = Vec::new();
        Self::collect_directory_facts(path, path, &mut facts)?;
        Ok(facts)
    }

    fn collect_directory_facts(
        base: &std::path::Path,
        current: &std::path::Path,
        facts: &mut Vec<String>,
    ) -> Result<(), Refusal> {
        if !current.exists() {
            return Err(Refusal::Io(format!(
                "Directory not found: {}",
                current.display()
            )));
        }

        let mut entries = Vec::new();
        for entry in std::fs::read_dir(current)? {
            entries.push(entry.map_err(|e| Refusal::Io(e.to_string()))?);
        }
        entries.sort_by_key(|e| e.file_name());

        for entry in entries {
            let entry_path = entry.path();
            if entry_path.is_dir() {
                Self::collect_directory_facts(base, &entry_path, facts)?;
            } else {
                let file_content = std::fs::read(&entry_path)?;
                let mut hasher = blake3::Hasher::new();
                hasher.update(&file_content);
                let hash = hasher.finalize().to_hex().to_string();

                let rel_path = entry_path
                    .strip_prefix(base)
                    .map_err(|e| Refusal::Io(e.to_string()))?;
                let rel_path_str = rel_path.to_string_lossy();

                facts.push(format!(
                    "<file://{}> <http://mfact/contentHash> \"blake3:{}\" .",
                    rel_path_str, hash
                ));
            }
        }
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_receipt_computation() -> Result<(), Refusal> {
        let facts = vec![
            "_:b1 <http://example.org/predicate> \"Value\" .".to_string(),
            "<http://example.org/subject> <http://example.org/predicate> _:b1 .".to_string(),
        ];

        let receipt = Receipt::compute(facts)?;

        // Output must be deterministic
        assert_eq!(
            receipt.facts[0],
            "<http://example.org/subject> <http://example.org/predicate> _:b1 ."
        );
        assert_eq!(
            receipt.facts[1],
            "_:b1 <http://example.org/predicate> \"Value\" ."
        );

        // Deterministic hash check for these specific facts
        let expected_hash = Receipt::compute(vec![
            "<http://example.org/subject> <http://example.org/predicate> _:b1 .".to_string(),
            "_:b1 <http://example.org/predicate> \"Value\" .".to_string(),
        ])?
        .hash;

        assert_eq!(receipt.hash, expected_hash);

        Ok(())
    }

    #[test]
    fn test_refusal_display() {
        assert_eq!(
            Refusal::HandCodedGeneratedOutput.to_string(),
            "HAND_CODED_GENERATED_OUTPUT"
        );
        assert_eq!(
            Refusal::GeneratedOutputDrift.to_string(),
            "GENERATED_OUTPUT_DRIFT"
        );
        assert_eq!(
            Refusal::MissingGgenSource("test.ttl".to_string()).to_string(),
            "MISSING_GGEN_SOURCE: test.ttl"
        );
        assert_eq!(
            Refusal::MissingGgenTemplate("test.ttl".to_string()).to_string(),
            "MISSING_GGEN_TEMPLATE: test.ttl"
        );
        assert_eq!(
            Refusal::OrphanGeneratedFile("test.ttl".to_string()).to_string(),
            "ORPHAN_GENERATED_FILE: test.ttl"
        );
        assert_eq!(
            Refusal::UnregisteredPaperFragment("test.ttl".to_string()).to_string(),
            "UNREGISTERED_PAPER_FRAGMENT: test.ttl"
        );
        assert_eq!(
            Refusal::UnsupportedStandingClaim.to_string(),
            "UNSUPPORTED_STANDING_CLAIM"
        );
        assert_eq!(
            Refusal::StatedPromotedToProven.to_string(),
            "STATED_PROMOTED_TO_PROVEN"
        );
        assert_eq!(
            Refusal::ManualReleaseCount.to_string(),
            "MANUAL_RELEASE_COUNT"
        );
        assert_eq!(
            Refusal::ManualReleaseHash.to_string(),
            "MANUAL_RELEASE_HASH"
        );
        assert_eq!(
            Refusal::ReceiptRecursionRefused.to_string(),
            "RECEIPT_RECURSION_REFUSED"
        );
        assert_eq!(
            Refusal::SourceChangeAssertionUnsupported.to_string(),
            "SOURCE_CHANGE_ASSERTION_UNSUPPORTED"
        );
        assert_eq!(
            Refusal::CountermodelPromotionRefused.to_string(),
            "COUNTERMODEL_PROMOTION_REFUSED"
        );
        assert_eq!(
            Refusal::ArtifactDriftRefused("test.ttl".to_string()).to_string(),
            "ARTIFACT_DRIFT_REFUSED: test.ttl"
        );
        assert_eq!(
            Refusal::Io("test error".to_string()).to_string(),
            "IO_ERROR: test error"
        );
        assert_eq!(
            Refusal::Serialization("test err".to_string()).to_string(),
            "SERIALIZATION_ERROR: test err"
        );
    }
}
