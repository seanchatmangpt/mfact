use crate::Refusal;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;

#[derive(Debug, Deserialize, Serialize)]
pub struct Ledger {
    #[serde(rename = "artifact")]
    pub artifacts: Vec<Artifact>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Artifact {
    pub path: String,
    pub producer: String,
    pub pack: Option<String>,
    pub sources: Option<Vec<String>>,
    pub content_hash: String,
}

impl Ledger {
    pub fn new() -> Self {
        Self {
            artifacts: Vec::new(),
        }
    }

    pub fn load(path: &Path) -> Result<Self, Refusal> {
        let content = fs::read_to_string(path)?;
        let ledger: Ledger =
            toml::from_str(&content).map_err(|e| Refusal::Serialization(e.to_string()))?;
        Ok(ledger)
    }

    pub fn save(&self, path: &Path) -> Result<(), Refusal> {
        let content = toml::to_string(self).map_err(|e| Refusal::Serialization(e.to_string()))?;
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent)?;
        }
        fs::write(path, content)?;
        Ok(())
    }

    pub fn add_artifact(&mut self, artifact: Artifact) {
        if let Some(pos) = self.artifacts.iter().position(|a| a.path == artifact.path) {
            self.artifacts[pos] = artifact;
        } else {
            self.artifacts.push(artifact);
        }
    }

    pub fn verify_all(&self, base_dir: &Path) -> Result<Vec<String>, Refusal> {
        let mut verified_facts = Vec::new();

        for artifact in &self.artifacts {
            let file_path = base_dir.join(&artifact.path);

            if !file_path.exists() {
                return Err(Refusal::OrphanGeneratedFile(artifact.path.clone()));
            }

            let file_content = fs::read(&file_path)?;
            let mut hasher = blake3::Hasher::new();
            hasher.update(&file_content);
            let hash = hasher.finalize().to_hex().to_string();
            let computed_hash = format!("blake3:{}", hash);

            if computed_hash != artifact.content_hash {
                return Err(Refusal::ArtifactDriftRefused(artifact.path.clone()));
            }

            // Add a fact about this verified artifact
            verified_facts.push(format!(
                "<file://{}> <http://mfact/verifiedHash> \"{}\" .",
                artifact.path, computed_hash
            ));
        }

        Ok(verified_facts)
    }
}
