use mfact::{Receipt, Refusal};
use std::env;
use std::path::Path;

fn main() -> Result<(), Refusal> {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 {
        println!("Usage: mfact <command>");
        println!("Commands:");
        println!("  init       - Initialize an empty ledger at .mfact/artifacts.toml");
        println!(
            "  add        - Add a file to the ledger: mfact add <file_path> <producer> <pack>"
        );
        println!("  status     - Show the status of tracked artifacts without failing");
        println!("  scan       - Run the Standing Guard scan over the artifacts");
        println!("  certify    - Certify the current release state");
        return Ok(());
    }

    let command = args[1].as_str();

    match command {
        "init" => init()?,
        "add" => {
            if args.len() < 4 {
                println!("Usage: mfact add <file_path> <producer> [pack]");
                return Ok(());
            }
            let pack = if args.len() > 4 {
                Some(args[4].as_str())
            } else {
                None
            };
            add(&args[2], &args[3], pack)?
        }
        "status" => status()?,
        "scan" => scan()?,
        "certify" => certify(&args)?,
        _ => {
            println!("Unknown command: {}", command);
            return Err(Refusal::UnsupportedStandingClaim);
        }
    }

    Ok(())
}

fn init() -> Result<(), Refusal> {
    let base_dir = Path::new(".");
    let artifacts_path = base_dir.join(".mfact/artifacts.toml");
    if artifacts_path.exists() {
        println!("Ledger already exists at {:?}", artifacts_path);
        return Ok(());
    }
    let ledger = mfact::ledger::Ledger::new();
    ledger.save(&artifacts_path)?;
    println!("Initialized empty ledger at .mfact/artifacts.toml");
    Ok(())
}

fn add(file_path_str: &str, producer: &str, pack: Option<&str>) -> Result<(), Refusal> {
    let base_dir = Path::new(".");
    let file_path = base_dir.join(file_path_str);
    if !file_path.exists() {
        return Err(Refusal::Io(format!(
            "File does not exist: {}",
            file_path_str
        )));
    }

    let file_content = std::fs::read(&file_path)?;
    let mut hasher = blake3::Hasher::new();
    hasher.update(&file_content);
    let hash = hasher.finalize().to_hex().to_string();
    let computed_hash = format!("blake3:{}", hash);

    let artifacts_path = base_dir.join(".mfact/artifacts.toml");
    let mut ledger = if artifacts_path.exists() {
        mfact::ledger::Ledger::load(&artifacts_path)?
    } else {
        mfact::ledger::Ledger::new()
    };

    ledger.add_artifact(mfact::ledger::Artifact {
        path: file_path_str.to_string(),
        producer: producer.to_string(),
        pack: pack.map(|s| s.to_string()),
        sources: None,
        content_hash: computed_hash.clone(),
    });

    ledger.save(&artifacts_path)?;
    println!(
        "Added artifact: {} (hash: {})",
        file_path_str, computed_hash
    );
    Ok(())
}

fn status() -> Result<(), Refusal> {
    let base_dir = Path::new(".");
    let artifacts_path = base_dir.join(".mfact/artifacts.toml");
    if !artifacts_path.exists() {
        println!("No ledger found. Run `mfact init` first.");
        return Ok(());
    }

    let ledger = mfact::ledger::Ledger::load(&artifacts_path)?;
    println!("Tracking {} artifacts.", ledger.artifacts.len());

    let mut clean_count = 0;
    let mut drift_count = 0;
    let mut missing_count = 0;

    for artifact in &ledger.artifacts {
        let file_path = base_dir.join(&artifact.path);
        if !file_path.exists() {
            println!("MISSING: {}", artifact.path);
            missing_count += 1;
            continue;
        }
        let file_content = std::fs::read(&file_path)?;
        let mut hasher = blake3::Hasher::new();
        hasher.update(&file_content);
        let hash = hasher.finalize().to_hex().to_string();
        let computed_hash = format!("blake3:{}", hash);

        if computed_hash != artifact.content_hash {
            println!(
                "DRIFT: {} (expected {}, got {})",
                artifact.path, artifact.content_hash, computed_hash
            );
            drift_count += 1;
        } else {
            clean_count += 1;
        }
    }

    println!(
        "\nStatus summary: {} clean, {} drifted, {} missing",
        clean_count, drift_count, missing_count
    );
    Ok(())
}

fn scan() -> Result<(), Refusal> {
    println!("Scanning artifacts...");

    let base_dir = Path::new(".");
    let artifacts_path = base_dir.join(".mfact/artifacts.toml");
    if !artifacts_path.exists() {
        println!("No artifacts ledger found at .mfact/artifacts.toml");
        return Err(Refusal::UnsupportedStandingClaim);
    }

    let ledger = mfact::ledger::Ledger::load(&artifacts_path)?;
    let mut facts = ledger.verify_all(base_dir)?;
    facts.push("<http://mfact/release> <http://mfact/status> \"SCANNED\" .".to_string());

    let receipt = Receipt::compute(facts)?;
    println!("Scan verified {} artifacts.", ledger.artifacts.len());
    println!("Scan receipt hash: {}", receipt.hash);

    Ok(())
}

fn certify(args: &[String]) -> Result<(), Refusal> {
    println!("Certifying release...");

    let mut facts =
        vec!["<http://mfact/release> <http://mfact/status> \"CERTIFIED\" .".to_string()];

    if args.len() >= 4 {
        let manifest_path = &args[2];
        let gates_path = &args[3];
        facts.push(format!(
            "<file://manifest> <http://mfact/path> \"{}\" .",
            manifest_path
        ));
        facts.push(format!(
            "<file://gates> <http://mfact/path> \"{}\" .",
            gates_path
        ));

        let manifest_file = Path::new(manifest_path);
        if let Some(parent) = manifest_file.parent() {
            if parent.exists() {
                let dir_facts = Receipt::hash_directory(parent)?;
                facts.extend(dir_facts);
            }
        }
    }

    let receipt = Receipt::compute(facts)?;
    println!("Release certified with hash: {}", receipt.hash);

    let receipt_json = serde_json::to_string_pretty(&receipt)?;

    // Default to saving in release/receipt.json, or current dir
    let out_path = if args.len() >= 4 {
        let manifest_file = Path::new(&args[2]);
        if let Some(parent) = manifest_file.parent() {
            parent.join("receipt.json")
        } else {
            Path::new("receipt.json").to_path_buf()
        }
    } else {
        Path::new("receipt.json").to_path_buf()
    };

    std::fs::write(&out_path, receipt_json)?;
    println!("Receipt artifact saved to {}", out_path.display());

    Ok(())
}
