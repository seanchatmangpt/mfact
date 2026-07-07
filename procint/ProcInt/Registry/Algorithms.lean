-- RENDERED by `ggen sync` from lean-math-pack (wasm4pm pi: algorithm facts).
-- Do not edit by hand: rows enter through the ontology, never here.
import Mathlib
import ProcInt.Foundations.Metric

/-! # ProcInt.Registry.Algorithms

The 60 process-intelligence algorithm specifications, rendered one
`AlgorithmSpec` per `pi:ProcessIntelligenceAlgorithm` individual in the
wasm4pm facts ontology, ordered by algorithm id. The count theorem pins
the registry's cardinality in the kernel. -/

namespace ProcInt

/-- Algorithm `a_star` (discovery → petrinet). -/
def alg_a_star : AlgorithmSpec :=
  ⟨"a_star", "AStar", "discovery", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `aco` (discovery → petrinet). -/
def alg_aco : AlgorithmSpec :=
  ⟨"aco", "Aco", "discovery", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `agentic_pipeline` (agentic → model). -/
def alg_agentic_pipeline : AlgorithmSpec :=
  ⟨"agentic_pipeline", "AgenticPipeline", "agentic", "model", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `alignments` (conformance → analytics). -/
def alg_alignments : AlgorithmSpec :=
  ⟨"alignments", "Alignments", "conformance", "analytics", "van der Aalst, W.M.P., Adriansyah, A., & van Dongen, B.F. (2012). Replaying History on Process Models for Conformance Checking. WIREs DMKD, 2(2), 182-192."⟩

/-- Algorithm `alpha_plus_plus` (discovery → petrinet). -/
def alg_alpha_plus_plus : AlgorithmSpec :=
  ⟨"alpha_plus_plus", "AlphaPlusPlus", "discovery", "petrinet", "van der Aalst, W.M.P., Weijters, T., & Maruster, L. (2004). Workflow Mining: Discovering Process Models from Event Logs. IEEE TKDE, 16(9), 1128-1142."⟩

/-- Algorithm `analyze_process_speedup` (discovery_analytics → analytics). -/
def alg_analyze_process_speedup : AlgorithmSpec :=
  ⟨"analyze_process_speedup", "AnalyzeProcessSpeedup", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `analyze_variant_complexity` (discovery_analytics → analytics). -/
def alg_analyze_variant_complexity : AlgorithmSpec :=
  ⟨"analyze_variant_complexity", "AnalyzeVariantComplexity", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `automl_classify` (ml_analytics → ml_result). -/
def alg_automl_classify : AlgorithmSpec :=
  ⟨"automl_classify", "AutomlClassify", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `automl_forecast` (ml_analytics → ml_result). -/
def alg_automl_forecast : AlgorithmSpec :=
  ⟨"automl_forecast", "AutomlForecast", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `batches` (discovery_analytics → analytics). -/
def alg_batches : AlgorithmSpec :=
  ⟨"batches", "Batches", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `bpmn_import` (import_export → tree). -/
def alg_bpmn_import : AlgorithmSpec :=
  ⟨"bpmn_import", "BpmnImport", "import_export", "tree", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `causal_graph` (discovery_analytics → analytics). -/
def alg_causal_graph : AlgorithmSpec :=
  ⟨"causal_graph", "CausalGraph", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `complexity_metrics` (conformance → analytics). -/
def alg_complexity_metrics : AlgorithmSpec :=
  ⟨"complexity_metrics", "ComplexityMetrics", "conformance", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `compute_activity_transition_matrix` (discovery_analytics → analytics). -/
def alg_compute_activity_transition_matrix : AlgorithmSpec :=
  ⟨"compute_activity_transition_matrix", "ComputeActivityTransitionMatrix", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `compute_ewma` (prediction → analytics). -/
def alg_compute_ewma : AlgorithmSpec :=
  ⟨"compute_ewma", "ComputeEwma", "prediction", "analytics", "Bose, R.P.J.C., van der Aalst, W.M.P., Zliobaite, I., & Pechenizkiy, M. (2011). Handling Concept Drift in Process Mining. CAiSE 2011, LNCS 6741. Springer."⟩

/-- Algorithm `compute_trace_similarity_matrix` (discovery_analytics → analytics). -/
def alg_compute_trace_similarity_matrix : AlgorithmSpec :=
  ⟨"compute_trace_similarity_matrix", "ComputeTraceSimilarityMatrix", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `correlation_miner` (discovery_analytics → analytics). -/
def alg_correlation_miner : AlgorithmSpec :=
  ⟨"correlation_miner", "CorrelationMiner", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `declare` (discovery → declare). -/
def alg_declare : AlgorithmSpec :=
  ⟨"declare", "Declare", "discovery", "declare", "Pesic, M., & van der Aalst, W.M.P. (2006). A Declarative Approach for Flexible Business Processes. BPM 2006 Workshops, LNCS 4103. Springer."⟩

/-- Algorithm `detect_drift` (prediction → analytics). -/
def alg_detect_drift : AlgorithmSpec :=
  ⟨"detect_drift", "DetectDrift", "prediction", "analytics", "Bose, R.P.J.C., van der Aalst, W.M.P., Zliobaite, I., & Pechenizkiy, M. (2011). Handling Concept Drift in Process Mining. CAiSE 2011, LNCS 6741. Springer."⟩

/-- Algorithm `dfg` (discovery → dfg). -/
def alg_dfg : AlgorithmSpec :=
  ⟨"dfg", "Dfg", "discovery", "dfg", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `etconformance_precision` (conformance → analytics). -/
def alg_etconformance_precision : AlgorithmSpec :=
  ⟨"etconformance_precision", "EtconformancePrecision", "conformance", "analytics", "Munoz-Gama, J., & Carmona, J. (2010). A Fresh Look at Precision in Process Conformance. BPM 2010, LNCS 6336. Springer."⟩

/-- Algorithm `generalization` (conformance → analytics). -/
def alg_generalization : AlgorithmSpec :=
  ⟨"generalization", "Generalization", "conformance", "analytics", "Buijs, J.C.A.M., van Dongen, B.F., & van der Aalst, W.M.P. (2012). On the Role of Fitness, Precision, Generalization and Simplicity in Process Discovery. CoopIS 2012, LNCS 7565. Springer."⟩

/-- Algorithm `genetic_algorithm` (discovery → petrinet). -/
def alg_genetic_algorithm : AlgorithmSpec :=
  ⟨"genetic_algorithm", "GeneticAlgorithm", "discovery", "petrinet", "van der Aalst, W.M.P., de Medeiros, A.K.A., & Weijters, A.J.M.M. (2005). Genetic process mining. Petri Nets 2005, LNCS 3536. Springer."⟩

/-- Algorithm `handover_network` (discovery_analytics → analytics). -/
def alg_handover_network : AlgorithmSpec :=
  ⟨"handover_network", "HandoverNetwork", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `heuristic_miner` (discovery → petrinet). -/
def alg_heuristic_miner : AlgorithmSpec :=
  ⟨"heuristic_miner", "HeuristicMiner", "discovery", "petrinet", "Weijters, A.J.M.M., & van der Aalst, W.M.P. (2006). Process Mining with the HeuristicsMiner Algorithm. BETA Working Paper WP 166, Eindhoven University of Technology."⟩

/-- Algorithm `hierarchical_dfg` (discovery → dfg). -/
def alg_hierarchical_dfg : AlgorithmSpec :=
  ⟨"hierarchical_dfg", "HierarchicalDfg", "discovery", "dfg", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `hill_climbing` (discovery → petrinet). -/
def alg_hill_climbing : AlgorithmSpec :=
  ⟨"hill_climbing", "HillClimbing", "discovery", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `ilp` (discovery → petrinet). -/
def alg_ilp : AlgorithmSpec :=
  ⟨"ilp", "Ilp", "discovery", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `inductive_miner` (discovery → tree). -/
def alg_inductive_miner : AlgorithmSpec :=
  ⟨"inductive_miner", "InductiveMiner", "discovery", "tree", "Leemans, S.J.J., Fahland, D., & van der Aalst, W.M.P. (2013). Discovering Block-Structured Process Models from Event Logs. Petri Nets 2013, LNCS 7927. Springer."⟩

/-- Algorithm `log_to_trie` (discovery → tree). -/
def alg_log_to_trie : AlgorithmSpec :=
  ⟨"log_to_trie", "LogToTrie", "discovery", "tree", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `ml_anomaly` (ml_analytics → ml_result). -/
def alg_ml_anomaly : AlgorithmSpec :=
  ⟨"ml_anomaly", "MlAnomaly", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `ml_classify` (ml_analytics → ml_result). -/
def alg_ml_classify : AlgorithmSpec :=
  ⟨"ml_classify", "MlClassify", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `ml_cluster` (ml_analytics → ml_result). -/
def alg_ml_cluster : AlgorithmSpec :=
  ⟨"ml_cluster", "MlCluster", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `ml_forecast` (ml_analytics → ml_result). -/
def alg_ml_forecast : AlgorithmSpec :=
  ⟨"ml_forecast", "MlForecast", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `ml_pca` (ml_analytics → ml_result). -/
def alg_ml_pca : AlgorithmSpec :=
  ⟨"ml_pca", "MlPca", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `ml_regress` (ml_analytics → ml_result). -/
def alg_ml_regress : AlgorithmSpec :=
  ⟨"ml_regress", "MlRegress", "ml_analytics", "ml_result", "de Leoni, M., van der Aalst, W.M.P., & Dees, M. (2016). A General Process Mining Framework. Information Systems, 56, 235-257."⟩

/-- Algorithm `monte_carlo_simulation` (simulation → analytics). -/
def alg_monte_carlo_simulation : AlgorithmSpec :=
  ⟨"monte_carlo_simulation", "MonteCarloSimulation", "simulation", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `ocel_dfg` (object_centric → dfg). -/
def alg_ocel_dfg : AlgorithmSpec :=
  ⟨"ocel_dfg", "OcelDfg", "object_centric", "dfg", "van der Aalst, W.M.P. (2019). Object-Centric Process Mining. ICSOC 2019, LNCS 11895. Springer."⟩

/-- Algorithm `ocel_dfg_per_type` (object_centric → dfg). -/
def alg_ocel_dfg_per_type : AlgorithmSpec :=
  ⟨"ocel_dfg_per_type", "OcelDfgPerType", "object_centric", "dfg", "van der Aalst, W.M.P. (2019). Object-Centric Process Mining. ICSOC 2019, LNCS 11895. Springer."⟩

/-- Algorithm `ocel_encode` (object_centric → ml_result). -/
def alg_ocel_encode : AlgorithmSpec :=
  ⟨"ocel_encode", "OcelEncode", "object_centric", "ml_result", "van der Aalst, W.M.P. (2019). Object-Centric Process Mining. ICSOC 2019, LNCS 11895. Springer."⟩

/-- Algorithm `ocel_oc_declare` (object_centric → declare). -/
def alg_ocel_oc_declare : AlgorithmSpec :=
  ⟨"ocel_oc_declare", "OcelOcDeclare", "object_centric", "declare", "van der Aalst, W.M.P. (2019). Object-Centric Process Mining. ICSOC 2019, LNCS 11895. Springer."⟩

/-- Algorithm `ocel_ocla` (object_centric → analytics). -/
def alg_ocel_ocla : AlgorithmSpec :=
  ⟨"ocel_ocla", "OcelOcla", "object_centric", "analytics", "van der Aalst, W.M.P. (2019). Object-Centric Process Mining. ICSOC 2019, LNCS 11895. Springer."⟩

/-- Algorithm `ocel_petri_net` (object_centric → petrinet). -/
def alg_ocel_petri_net : AlgorithmSpec :=
  ⟨"ocel_petri_net", "OcelPetriNet", "object_centric", "petrinet", "van der Aalst, W.M.P. (2019). Object-Centric Process Mining. ICSOC 2019, LNCS 11895. Springer."⟩

/-- Algorithm `optimized_dfg` (discovery → dfg). -/
def alg_optimized_dfg : AlgorithmSpec :=
  ⟨"optimized_dfg", "OptimizedDfg", "discovery", "dfg", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `performance_spectrum` (discovery_analytics → analytics). -/
def alg_performance_spectrum : AlgorithmSpec :=
  ⟨"performance_spectrum", "PerformanceSpectrum", "discovery_analytics", "analytics", "Denisov, V., Fahland, D., & van der Aalst, W.M.P. (2018). Unbiased description of processes performance from event data. BPM 2018, LNCS 11080. Springer."⟩

/-- Algorithm `playout` (simulation → analytics). -/
def alg_playout : AlgorithmSpec :=
  ⟨"playout", "Playout", "simulation", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `pnml_import` (import_export → petrinet). -/
def alg_pnml_import : AlgorithmSpec :=
  ⟨"pnml_import", "PnmlImport", "import_export", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `powl_to_process_tree` (import_export → tree). -/
def alg_powl_to_process_tree : AlgorithmSpec :=
  ⟨"powl_to_process_tree", "PowlToProcessTree", "import_export", "tree", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `predict_next_activity` (prediction → ml_result). -/
def alg_predict_next_activity : AlgorithmSpec :=
  ⟨"predict_next_activity", "PredictNextActivity", "prediction", "ml_result", "Teinemaa, I., Dumas, M., Rosa, M.L., & Maggi, F.M. (2019). Outcome-Oriented Predictive Process Monitoring. ACM TKDD, 13(2), Article 17."⟩

/-- Algorithm `predict_outcome` (prediction → ml_result). -/
def alg_predict_outcome : AlgorithmSpec :=
  ⟨"predict_outcome", "PredictOutcome", "prediction", "ml_result", "Teinemaa, I., Dumas, M., Rosa, M.L., & Maggi, F.M. (2019). Outcome-Oriented Predictive Process Monitoring. ACM TKDD, 13(2), Article 17."⟩

/-- Algorithm `predict_remaining_time` (prediction → ml_result). -/
def alg_predict_remaining_time : AlgorithmSpec :=
  ⟨"predict_remaining_time", "PredictRemainingTime", "prediction", "ml_result", "Teinemaa, I., Dumas, M., Rosa, M.L., & Maggi, F.M. (2019). Outcome-Oriented Predictive Process Monitoring. ACM TKDD, 13(2), Article 17."⟩

/-- Algorithm `process_skeleton` (discovery → dfg). -/
def alg_process_skeleton : AlgorithmSpec :=
  ⟨"process_skeleton", "ProcessSkeleton", "discovery", "dfg", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `pso` (discovery → petrinet). -/
def alg_pso : AlgorithmSpec :=
  ⟨"pso", "Pso", "discovery", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `simd_streaming_dfg` (discovery → dfg). -/
def alg_simd_streaming_dfg : AlgorithmSpec :=
  ⟨"simd_streaming_dfg", "SimdStreamingDfg", "discovery", "dfg", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `simulated_annealing` (discovery → petrinet). -/
def alg_simulated_annealing : AlgorithmSpec :=
  ⟨"simulated_annealing", "SimulatedAnnealing", "discovery", "petrinet", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `smart_engine` (discovery → model). -/
def alg_smart_engine : AlgorithmSpec :=
  ⟨"smart_engine", "SmartEngine", "discovery", "model", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `streaming_log` (discovery → dfg). -/
def alg_streaming_log : AlgorithmSpec :=
  ⟨"streaming_log", "StreamingLog", "discovery", "dfg", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `transition_system` (discovery → model). -/
def alg_transition_system : AlgorithmSpec :=
  ⟨"transition_system", "TransitionSystem", "discovery", "model", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `working_together_network` (discovery_analytics → analytics). -/
def alg_working_together_network : AlgorithmSpec :=
  ⟨"working_together_network", "WorkingTogetherNetwork", "discovery_analytics", "analytics", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Algorithm `yawl_export` (import_export → model). -/
def alg_yawl_export : AlgorithmSpec :=
  ⟨"yawl_export", "YawlExport", "import_export", "model", "van der Aalst, W.M.P. (2016). Process Mining: Data Science in Action (2nd ed.). Springer."⟩

/-- Every algorithm specification, ordered by algorithm id. -/
def allAlgorithms : List AlgorithmSpec :=
  [ alg_a_star,
    alg_aco,
    alg_agentic_pipeline,
    alg_alignments,
    alg_alpha_plus_plus,
    alg_analyze_process_speedup,
    alg_analyze_variant_complexity,
    alg_automl_classify,
    alg_automl_forecast,
    alg_batches,
    alg_bpmn_import,
    alg_causal_graph,
    alg_complexity_metrics,
    alg_compute_activity_transition_matrix,
    alg_compute_ewma,
    alg_compute_trace_similarity_matrix,
    alg_correlation_miner,
    alg_declare,
    alg_detect_drift,
    alg_dfg,
    alg_etconformance_precision,
    alg_generalization,
    alg_genetic_algorithm,
    alg_handover_network,
    alg_heuristic_miner,
    alg_hierarchical_dfg,
    alg_hill_climbing,
    alg_ilp,
    alg_inductive_miner,
    alg_log_to_trie,
    alg_ml_anomaly,
    alg_ml_classify,
    alg_ml_cluster,
    alg_ml_forecast,
    alg_ml_pca,
    alg_ml_regress,
    alg_monte_carlo_simulation,
    alg_ocel_dfg,
    alg_ocel_dfg_per_type,
    alg_ocel_encode,
    alg_ocel_oc_declare,
    alg_ocel_ocla,
    alg_ocel_petri_net,
    alg_optimized_dfg,
    alg_performance_spectrum,
    alg_playout,
    alg_pnml_import,
    alg_powl_to_process_tree,
    alg_predict_next_activity,
    alg_predict_outcome,
    alg_predict_remaining_time,
    alg_process_skeleton,
    alg_pso,
    alg_simd_streaming_dfg,
    alg_simulated_annealing,
    alg_smart_engine,
    alg_streaming_log,
    alg_transition_system,
    alg_working_together_network,
    alg_yawl_export ]

/-- The registry holds exactly 60 algorithms — the DfCM cross-product
cardinality pinned in the kernel. -/
theorem allAlgorithms_count : allAlgorithms.length = 60 := by rfl

end ProcInt
