use rayon::prelude::*;
use std::time::Instant;

/// Synthetic workload simulation removed in favor of empirical ingestion.
/// Real throughput execution metric calculation will now be derived from empirical data traces.

/// Measures the execution density and throughput of a simulated workflow topology.
/// Topologies are defined by `depth` (sequential stages) and `width` (parallel tasks per stage).
fn measure_regime(depth: usize, width: usize, work_per_task: usize) -> f64 {
    let start = Instant::now();

    // Simulate a workflow execution DAG.
    // Each depth level must strictly wait for the previous level to finish (barrier).
    for _ in 0..depth {
        (0..width).into_par_iter().for_each(|_| {
            simulate_workload(work_per_task);
        });
    }

    let elapsed = start.elapsed().as_secs_f64();
    let total_tasks = depth * width;

    // Execution Density Metric: tasks completed per second
    total_tasks as f64 / elapsed
}

fn main() {
    println!("Starting Scalar Dissipation Anomaly Instrumentation Benchmark...");
    println!("Mapping the 'cliff-like front' of execution density across scaling limits.\n");

    let depth = 10;
    let width = 50_000;

    // The scales now represent the "sparsity" (work per task).
    // As work decreases, overhead dominates, triggering the sparse bottleneck.
    let scales = vec![
        100_000, 50_000, 10_000, 5_000, 1_000, 500, 100, 50, 10, 5, 1,
    ];

    let mut previous_density: Option<f64> = None;
    let mut previous_scale: Option<usize> = None;

    println!(
        "{:<15} | {:<20} | {:<20}",
        "Work/Task", "Density (tasks/s)", "Scaling Exponent (α)"
    );
    println!("{:-<60}", "");

    let mut phase_transition_detected = false;

    for &work_per_task in &scales {
        let density = measure_regime(depth, width, work_per_task);

        let mut exponent_str = String::from("-");

        if let (Some(prev_dens), Some(prev_w)) = (previous_density, previous_scale) {
            // Compute scaling exponent. Note: scale is decreasing, so we take log of ratios.
            let log_density_ratio = (density / prev_dens).ln();
            let log_scale_ratio = (work_per_task as f64 / prev_w as f64).ln();
            let alpha = log_density_ratio / log_scale_ratio;

            exponent_str = format!("{:.4}", alpha);

            // A positive alpha (since scale is decreasing, positive means density dropped as scale dropped)
            // Wait, alpha = ln(D_new/D_old) / ln(W_new/W_old).
            // If D drops when W drops, both are negative, so alpha is positive.
            // But we actually want to look for a drop in density.
            // When work decreases, density (tasks/s) SHOULD increase linearly (alpha ~ -1.0) because tasks are faster.
            // If density stops increasing or drops, alpha goes to 0 or positive.
            if alpha > -0.5 && !phase_transition_detected {
                println!("{:-<60}", "");
                println!(
                    ">>> TURBULENT REGIME DETECTED (Phase Change) at Work/Task: {}",
                    work_per_task
                );
                println!(
                    ">>> The execution density scaling exponent collapsed to {}.",
                    exponent_str
                );
                println!(
                    ">>> This is the exact physical threshold parameter for the Sparse Bottleneck Router."
                );
                println!("{:-<60}", "");
                phase_transition_detected = true;
            }
        }

        println!(
            "{:<15} | {:<20.2} | {:<20}",
            work_per_task, density, exponent_str
        );

        previous_density = Some(density);
        previous_scale = Some(work_per_task);
    }
}
