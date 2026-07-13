# Test Instance Traceability Matrix

Exactly **133 distinct test types** are cataloged.

| ID | Family | Test type | Stable instance name | Canonical MFW instance |
|---|---|---|---|---|
| T001 | `KERNEL` | Kernel admission test | `MFW.TST.KERNEL.ADMISSION.001` | ProcInt theorem module admission |
| T002 | `KERNEL` | Theorem proof test | `MFW.TST.KERNEL.THEOREM_PROOF.002` | Replay equivalence law |
| T003 | `KERNEL` | Lemma specialization test | `MFW.TST.KERNEL.SPECIALIZATION.003` | SOC2 concrete closure specialization |
| T004 | `KERNEL` | Theorem composition test | `MFW.TST.KERNEL.COMPOSITION.004` | residue → tenancy → execution → replay |
| T005 | `KERNEL` | Assumption audit | `MFW.TST.KERNEL.ASSUMPTION_AUDIT.005` | Separated / Finite / well-founded assumptions |
| T006 | `KERNEL` | Axiom dependency test | `MFW.TST.KERNEL.AXIOM_DEP.006` | crown theorem axiom allowlist |
| T007 | `KERNEL` | No-sorry test | `MFW.TST.KERNEL.NO_SORRY.007` | ProcInt namespace audit |
| T008 | `KERNEL` | Non-vacuity test | `MFW.TST.KERNEL.NON_VACUITY.008` | nonidentity ClosureOperator |
| T009 | `ELAB` | Positive elaboration test | `MFW.TST.ELAB.POSITIVE.009` | lawful TWorkflow composition |
| T010 | `ELAB` | Negative elaboration test | `MFW.TST.ELAB.NEGATIVE.010` | illegal color composition |
| T011 | `ELAB` | Type mismatch fixture | `MFW.TST.ELAB.TYPE_MISMATCH.011` | raw→plan composed with receipt→replay |
| T012 | `ELAB` | Instance synthesis test | `MFW.TST.ELAB.INSTANCE_SYNTH.012` | DecidableEq / Fintype / LawfulBEq |
| T013 | `ELAB` | Definitional equality test | `MFW.TST.ELAB.DEFEQ.013` | normalized workflow expression |
| T014 | `ELAB` | Syntactic equality test | `MFW.TST.ELAB.SYNTACTIC_EQ.014` | ggen-emitted term shape |
| T015 | `ELAB` | Alpha-equivalence test | `MFW.TST.ELAB.ALPHA_EQ.015` | generated theorem binder renaming |
| T016 | `ELAB` | Goal-shape test | `MFW.TST.ELAB.GOAL_SHAPE.016` | residue proof subgoal shape |
| T017 | `ELAB` | Hypothesis-shape test | `MFW.TST.ELAB.HYP_SHAPE.017` | closure assumptions in context |
| T018 | `DIAG` | Exact diagnostic test | `MFW.TST.DIAG.EXACT.018` | typed illegal composition diagnostic |
| T019 | `DIAG` | Diagnostic-class test | `MFW.TST.DIAG.CLASS.019` | deprecation or refusal diagnostic |
| T020 | `DIAG` | Panic test | `MFW.TST.DIAG.PANIC.020` | deliberate internal panic fixture |
| T021 | `DIAG` | Typed refusal test | `MFW.TST.DIAG.TYPED_REFUSAL.021` | crossTenantLeak refusal |
| T022 | `DIAG` | Refusal precedence test | `MFW.TST.DIAG.REFUSAL_PRECEDENCE.022` | stale observation vs source-not-allowed |
| T023 | `DIAG` | Diagnostic stability test | `MFW.TST.DIAG.STABILITY.023` | stable crown refusal wording |
| T024 | `FINITE` | Boolean guard test | `MFW.TST.FINITE.BOOL_GUARD.024` | regime classifier case |
| T025 | `FINITE` | Finite decision test | `MFW.TST.FINITE.DECIDE.025` | receipt ancestry property |
| T026 | `FINITE` | Native decision test | `MFW.TST.FINITE.NATIVE_DECIDE.026` | finite world invariant |
| T027 | `FINITE` | Example-table test | `MFW.TST.FINITE.TABLE.027` | singularity routing table |
| T028 | `FINITE` | Exhaustive finite-domain test | `MFW.TST.FINITE.EXHAUSTIVE.028` | all TinyWorkflow worlds at depth n |
| T029 | `PROPERTY` | Property-based test | `MFW.TST.PROPERTY.PROPERTY_BASED.029` | closure idempotence over generated carriers |
| T030 | `PROPERTY` | Random generation test | `MFW.TST.PROPERTY.RANDOM_GEN.030` | receipt DAG / workflow generator |
| T031 | `PROPERTY` | Shrinking test | `MFW.TST.PROPERTY.SHRINK.031` | minimal workflow counterexample |
| T032 | `PROPERTY` | Distribution-sensitive generation | `MFW.TST.PROPERTY.DISTRIBUTION.032` | cross-tenant and sparse-scale regimes |
| T033 | `ALGEBRA` | Identity law test | `MFW.TST.ALGEBRA.IDENTITY.033` | Workflow.bind right identity |
| T034 | `ALGEBRA` | Associativity test | `MFW.TST.ALGEBRA.ASSOCIATIVITY.034` | Workflow.bind associativity |
| T035 | `ALGEBRA` | Idempotence test | `MFW.TST.ALGEBRA.IDEMPOTENCE.035` | closure idempotence |
| T036 | `ALGEBRA` | Monotonicity test | `MFW.TST.ALGEBRA.MONOTONICITY.036` | closure monotonicity |
| T037 | `ALGEBRA` | Extensivity test | `MFW.TST.ALGEBRA.EXTENSIVITY.037` | closure extensivity |
| T038 | `ALGEBRA` | Commutativity test | `MFW.TST.ALGEBRA.COMMUTATIVITY.038` | independent replay steps |
| T039 | `ALGEBRA` | Absorption test | `MFW.TST.ALGEBRA.ABSORPTION.039` | normalization/closure absorption |
| T040 | `ALGEBRA` | Distributivity test | `MFW.TST.ALGEBRA.DISTRIBUTIVITY.040` | workflow/process algebra law |
| T041 | `METAMORPHIC` | Independent event reordering test | `MFW.TST.METAMORPHIC.EVENT_REORDER.041` | swap independent receipt events |
| T042 | `METAMORPHIC` | Graph triple reordering test | `MFW.TST.METAMORPHIC.TRIPLE_REORDER.042` | RDF graph canonicalization |
| T043 | `METAMORPHIC` | Blank-node canonicalization test | `MFW.TST.METAMORPHIC.BNODE_CANON.043` | skos:notation binding handles |
| T044 | `METAMORPHIC` | Duplicate observation elimination test | `MFW.TST.METAMORPHIC.DUP_OBS.044` | observation dedup |
| T045 | `METAMORPHIC` | Workflow normalization test | `MFW.TST.METAMORPHIC.WORKFLOW_NORM.045` | seq/par normal form |
| T046 | `METAMORPHIC` | Scale refinement test | `MFW.TST.METAMORPHIC.SCALE_REFINE.046` | multifractal scale schedule |
| T047 | `METAMORPHIC` | Equivalent partition representation test | `MFW.TST.METAMORPHIC.PARTITION_EQ.047` | joint moment field |
| T048 | `METAMORPHIC` | Receipt replay metamorphic test | `MFW.TST.METAMORPHIC.RECEIPT_REPLAY.048` | receipt DAG trace |
| T049 | `METAMORPHIC` | Tenant permutation test | `MFW.TST.METAMORPHIC.TENANT_PERM.049` | tenancy residue |
| T050 | `COUNTERMODEL` | Counterexample test | `MFW.TST.COUNTERMODEL.COUNTEREXAMPLE.050` | mutant workflow law |
| T051 | `COUNTERMODEL` | Minimal counterexample test | `MFW.TST.COUNTERMODEL.MIN_COUNTEREXAMPLE.051` | least-cost failing architecture world |
| T052 | `COUNTERMODEL` | Countermodel test | `MFW.TST.COUNTERMODEL.COUNTERMODEL.052` | infinite-transition crown countermodel |
| T053 | `COUNTERMODEL` | Hypothesis-removal test | `MFW.TST.COUNTERMODEL.HYP_REMOVAL.053` | tenancy without Separated |
| T054 | `COUNTERMODEL` | Boundary test | `MFW.TST.COUNTERMODEL.BOUNDARY.054` | Finite T boundary |
| T055 | `MUTATION` | Mutation test | `MFW.TST.MUTATION.KILL_MUTANT.055` | bindDropSeqRight / closureWithoutIdempotence / replayReverseParents |
| T056 | `DIFFERENTIAL` | Differential test | `MFW.TST.DIFFERENTIAL.IMPL_COMPARE.056` | recursive vs fold replay; naive vs seminaive closure; interpreter variants |
| T057 | `SNAPSHOT` | Golden output test | `MFW.TST.SNAPSHOT.GOLDEN_OUTPUT.057` | verifier report |
| T058 | `SNAPSHOT` | Diagnostic snapshot | `MFW.TST.SNAPSHOT.DIAG_SNAPSHOT.058` | negative fixture output |
| T059 | `SNAPSHOT` | Pretty-printer snapshot | `MFW.TST.SNAPSHOT.PRETTY.059` | generated declaration rendering |
| T060 | `SNAPSHOT` | Generated artifact snapshot | `MFW.TST.SNAPSHOT.ARTIFACT.060` | generated Lean module |
| T061 | `SNAPSHOT` | Manifest snapshot | `MFW.TST.SNAPSHOT.MANIFEST.061` | mfact artifact inventory |
| T062 | `REGRESSION` | Regression test | `MFW.TST.REGRESSION.ESCAPED_DEFECT.062` | SocketShadow / StandingForgery / ParallelProjection |
| T063 | `COMPOSITION` | Composition test | `MFW.TST.COMPOSITION.CROSS_THEOREM.063` | Closure→Residue→Tenancy→Execution→Replay |
| T064 | `FLOW` | Flow/scenario test | `MFW.TST.FLOW.SCENARIO.064` | SOC2 two-tenant audit / contractor exfiltration |
| T065 | `E2E` | End-to-end test | `MFW.TST.E2E.CONTROLLED_CHAIN.065` | canonical ontology artifact |
| T066 | `ROUNDTRIP` | Round-trip test | `MFW.TST.ROUNDTRIP.EXACT.066` | receipt/workflow serialization |
| T067 | `ROUNDTRIP` | Canonicalized round-trip test | `MFW.TST.ROUNDTRIP.CANONICAL.067` | RDF blank-node-sensitive carrier |
| T068 | `CORRESPONDENCE` | Refinement/correspondence preservation test | `MFW.TST.CORRESPONDENCE.PRESERVE.068` | TTL declaration→generated Lean declaration |
| T069 | `CORRESPONDENCE` | Correspondence composition test | `MFW.TST.CORRESPONDENCE.COMPOSE.069` | TTL→Lean→manifest vs direct claim projection |
| T070 | `INVARIANT` | Invariant preservation test | `MFW.TST.INVARIANT.PRESERVATION.070` | zero unreceipted completion / tenant separation |
| T071 | `CONCURRENCY` | Pairwise commutation test | `MFW.TST.CONCURRENCY.PAIRWISE_COMMUTE.071` | freeze identity vs preserve logs on real state |
| T072 | `CONCURRENCY` | Independent adjacent swap test | `MFW.TST.CONCURRENCY.ADJ_SWAP.072` | oriented swap replay |
| T073 | `CONCURRENCY` | Linear-extension equivalence test | `MFW.TST.CONCURRENCY.LINEXT.073` | receipt causal DAG |
| T074 | `CONCURRENCY` | Diamond property test | `MFW.TST.CONCURRENCY.DIAMOND.074` | concurrent cloud transitions |
| T075 | `CONCURRENCY` | Race/conflict counterexample test | `MFW.TST.CONCURRENCY.RACE.075` | delete vs snapshot |
| T076 | `CONCURRENCY` | Maximal concurrent-set test | `MFW.TST.CONCURRENCY.MAX_SET.076` | automatic POWL concurrency |
| T077 | `REPRO` | Repeatability/determinism test | `MFW.TST.REPRO.REPEAT.077` | ggen/audit repeat |
| T078 | `REPRO` | Clean-vs-incremental reproducibility | `MFW.TST.REPRO.CLEAN_INCREMENTAL.078` | Lake |
| T079 | `REPRO` | Serial-vs-parallel reproducibility | `MFW.TST.REPRO.SERIAL_PARALLEL.079` | Lake job scheduling |
| T080 | `REPRO` | File-enumeration-order reproducibility | `MFW.TST.REPRO.ENUM_ORDER.080` | manifest generation |
| T081 | `REPRO` | Process-restart reproducibility | `MFW.TST.REPRO.RESTART.081` | ggen pipeline |
| T082 | `REPRO` | Repeated-ggen reproducibility | `MFW.TST.REPRO.GGEN_REPEAT.082` | projection idempotence |
| T083 | `LAKE` | Package configuration test | `MFW.TST.LAKE.PACKAGE_CONFIG.083` | pinned toolchain and targets |
| T084 | `LAKE` | Dependency resolution test | `MFW.TST.LAKE.DEPENDENCY.084` | mathlib pin |
| T085 | `LAKE` | Library build test | `MFW.TST.LAKE.LIB_BUILD.085` | ProcInt |
| T086 | `LAKE` | Executable build test | `MFW.TST.LAKE.EXE_BUILD.086` | verifier |
| T087 | `LAKE` | Custom target test | `MFW.TST.LAKE.CUSTOM_TARGET.087` | standing/claims/residue |
| T088 | `LAKE` | Test driver test | `MFW.TST.LAKE.TEST_DRIVER.088` | crown verifier |
| T089 | `LAKE` | Package-as-dependency test | `MFW.TST.LAKE.AS_DEP.089` | consumer of ProcInt |
| T090 | `LAKE` | Clean build test | `MFW.TST.LAKE.CLEAN_BUILD.090` | release boundary |
| T091 | `LAKE` | Incremental build test | `MFW.TST.LAKE.INCREMENTAL.091` | dependency graph |
| T092 | `LAKE` | Build target selection test | `MFW.TST.LAKE.TARGET_SELECT.092` | standing vs claims |
| T093 | `LAKE` | Install/release behavior test | `MFW.TST.LAKE.INSTALL_RELEASE.093` | mfact release |
| T094 | `EXPECTED_FAIL` | Expected-failure build test | `MFW.TST.EXPECTED_FAIL.BUILD.094` | StandingForgery / CrossTenantGraft / MissingDescent |
| T095 | `POLICY` | No-sorry policy test | `MFW.TST.POLICY.NO_SORRY.095` | ProcInt |
| T096 | `POLICY` | No-admit policy test | `MFW.TST.POLICY.NO_ADMIT.096` | ProcInt |
| T097 | `POLICY` | Forbidden-import policy test | `MFW.TST.POLICY.FORBIDDEN_IMPORT.097` | N3/default escape-hatch modules |
| T098 | `POLICY` | No giant Mathlib umbrella import test | `MFW.TST.POLICY.NO_UMBRELLA.098` | core theorem modules |
| T099 | `POLICY` | Semantic-coordinate completeness test | `MFW.TST.POLICY.SEMANTIC_COORDS.099` | Law/Carrier/Admission/Preserves/Refuses/Claim ceiling |
| T100 | `POLICY` | Every RefusalCode tested policy | `MFW.TST.POLICY.REFUSAL_COVERAGE.100` | typed refusal algebra |
| T101 | `POLICY` | Every crown theorem countermodel-card policy | `MFW.TST.POLICY.COUNTERMODEL_CARD.101` | crown theorem rail |
| T102 | `POLICY` | Generated provenance policy | `MFW.TST.POLICY.PROVENANCE.102` | ggen outputs |
| T103 | `POLICY` | Claimed theorem exists policy | `MFW.TST.POLICY.CLAIM_EXISTS.103` | claim matrix |
| T104 | `POLICY` | No orphan modules policy | `MFW.TST.POLICY.NO_ORPHANS.104` | ProcInt umbrella |
| T105 | `INVENTORY` | Expected theorem existence test | `MFW.TST.INVENTORY.EXISTS.105` | crown theorem manifest |
| T106 | `INVENTORY` | Theorem kind test | `MFW.TST.INVENTORY.KIND.106` | expected theorem |
| T107 | `INVENTORY` | Theorem module location test | `MFW.TST.INVENTORY.MODULE.107` | MFW residue theorem |
| T108 | `INVENTORY` | Allowed axiom dependency test | `MFW.TST.INVENTORY.AXIOM_ALLOWLIST.108` | crown theorems |
| T109 | `INVENTORY` | Claim class test | `MFW.TST.INVENTORY.CLAIM_CLASS.109` | FINITE_VERIFIED vs PROVEN |
| T110 | `INVENTORY` | Manifest representation test | `MFW.TST.INVENTORY.MANIFEST.110` | mfact manifest |
| T111 | `INVENTORY` | Exact theorem inventory equality test | `MFW.TST.INVENTORY.EXACT_SET.111` | crown inventory |
| T112 | `PERF` | Compile benchmark | `MFW.TST.PERF.COMPILE.112` | compiled verifier |
| T113 | `PERF` | Elaboration benchmark | `MFW.TST.PERF.ELAB.113` | large theorem module |
| T114 | `PERF` | Lake benchmark | `MFW.TST.PERF.LAKE.114` | standing target |
| T115 | `PERF` | Build benchmark | `MFW.TST.PERF.BUILD.115` | ProcInt |
| T116 | `PERF` | Size benchmark | `MFW.TST.PERF.SIZE.116` | generated modules |
| T117 | `PERF` | Custom metric benchmark | `MFW.TST.PERF.CUSTOM_METRIC.117` | residue candidate count / proof branching |
| T118 | `STRESS` | Stress/scale test | `MFW.TST.STRESS.SCALE.118` | workflow worlds / theorem count |
| T119 | `STRESS` | Stack overflow test | `MFW.TST.STRESS.STACK.119` | workflow bind |
| T120 | `STRESS` | Recursion limit test | `MFW.TST.STRESS.RECURSION.120` | recursive workflow |
| T121 | `STRESS` | Heartbeat exhaustion test | `MFW.TST.STRESS.HEARTBEAT.121` | expensive proof search |
| T122 | `STRESS` | Memory exhaustion test | `MFW.TST.STRESS.MEMORY.122` | residue enumeration |
| T123 | `STRESS` | Typeclass explosion test | `MFW.TST.STRESS.TYPECLASS.123` | semantic coordinate classes |
| T124 | `STRESS` | Elaboration blowup test | `MFW.TST.STRESS.ELAB_BLOWUP.124` | deep TWorkflow |
| T125 | `STRESS` | Exponential residue generation test | `MFW.TST.STRESS.EXP_RESIDUE.125` | minimal residue |
| T126 | `COMPLEXITY` | Complexity-law test | `MFW.TST.COMPLEXITY.FORMAL_BOUND.126` | workflow traversal / residue search |
| T127 | `COMPLEXITY` | Formal-vs-measured complexity distinction test | `MFW.TST.COMPLEXITY.MEASURE_DISTINCTION.127` | complexity theorem vs measured benchmark |
| T128 | `TERMINATION` | Kernel termination checking | `MFW.TST.TERMINATION.KERNEL.128` | recursive definitions |
| T129 | `TERMINATION` | Well-founded termination theorem | `MFW.TST.TERMINATION.WELL_FOUNDED.129` | workflow obligation multiset |
| T130 | `TERMINATION` | Finite experimental descent test | `MFW.TST.TERMINATION.FINITE_DESCENT.130` | obligation refinement corpus |
| T131 | `FAITHFULNESS` | Faithfulness/claim-ceiling test | `MFW.TST.FAITHFULNESS.CLAIM_CEILING.131` | global replay claim vs local Nat commutation |
| T132 | `STANDING_PATH` | Gap/edge coverage test | `MFW.TST.STANDING_PATH.EDGE_COVERAGE.132` | MFW wave graph |
| T133 | `STANDING_PATH` | Standing path coverage test | `MFW.TST.STANDING_PATH.PATH_COVERAGE.133` | TTL→ggen→Lean→Lake→audit crown path |
