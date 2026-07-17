# The Chatman Equation

Standing: UNVERIFIED — theoretical/architectural doctrine, not a mechanically checked
artifact. This document is a primer and reference, not itself a proof or a receipt. It
is preserved verbatim as authored, as the unifying law both repository lineages (the
ggen/procint-core/paper/release subsystem and the `procint/ProcInt/MFW/` subsystem)
independently instantiate — see `AGENTS.md`'s "Foundational Law" section for how the
operational law in this repository derives from it, and what remains open research
thesis versus mechanically enforced practice.

Draws from the Chatman Equation dissertation lineage, the Multifractal Workflow thesis,
the bounded-receipted formulation, and the RDF-first Gall checkpoints. Omits private
repository structure, proprietary implementation details, unpublished templates, and
internal runtime names.

## Core Equation

* The Chatman Equation is (A=\mu(O^*)).
* (O) is raw observation.
* (O^*) is admitted observation.
* (\mu) is lawful manufacture.
* (A) is a manufactured artifact or consequence with bounded standing.
* (R=\operatorname{receipt}(A)) binds the artifact to its admitted causes, manufacturing law, verification evidence, and replay identity.
* The receipted equation is (R\vdash A=\mu(O^*)).
* The distinction between (O) and (O^*) is the foundational distinction between information and authority.
* Raw information may be observed without being trusted, typed, authorized, current, relevant, or safe to execute.
* Admission converts an open semantic world into a bounded computational object.
* Manufacture operates only on admitted state.
* Consequential action must never originate directly from raw observation.

## Historical Development

* The earliest formulation was (A=\mu(O)).
* The mature formulation became (A=\mu(O^*)) after admission emerged as the necessary boundary.
* The equation evolved from ontology-driven realization into a general law of standing-preserving manufacture.
* The mature theory distinguishes generation, manufacture, verification, standing, and actuation.
* The equation is not merely a code-generation formula.
* The equation is proposed as a general model of how coordinated systems transform represented reality into consequences.
* The strongest theoretical thesis is that intelligence is expressed through lawful coordination topology rather than isolated node capability.
* This coordination thesis is a research proposition whose standing depends on formal, architectural, and empirical support.
* The operational equation is narrower and mechanically testable even when the universal intelligence thesis remains conjectural.

## Expanded Type Structure

* Admission is a total function returning either admitted observation or typed refusal.
* Formally, (\operatorname{admit}:O\rightarrow O^*+\operatorname{Refusal}).
* Refusal is a lawful result, not an implementation failure.
* Unknown, unsupported, inconsistent, bounded, exhausted, timed out, and tool-failed outcomes must remain distinct.
* Uncertainty must never be silently promoted into truth.
* Unsupported capability must never be silently converted into infeasibility.
* A bounded search result must never be reported as proof of exhaustion.
* A failed tool must never be interpreted as absence of a solution.
* The manufacturing function is indexed by policy, boundary, capability, and resource budget.
* The expanded form is (\mu_{P,B}:O^*\times C_{P,B}\rightarrow A\times\Omega).
* (P) is the governing profile.
* (B) is the declared authority boundary.
* (C_{P,B}) is the admitted construction law.
* (\Omega) is the set of proof, validation, conformance, and evidence obligations created by manufacture.
* The compact equation suppresses these variables for readability.
* The receipt restores every suppressed variable required to reconstruct the consequence.

## Bounded Receipted Chatman Equation

* The enforced operational form is the Bounded Receipted Chatman Equation.
* BRCE requires an admission gate.
* BRCE requires bounded manufacture.
* BRCE requires receipt totality.
* BRCE requires process conformance.
* Nothing actuates from raw or refused observation.
* Manufacture must terminate or return a typed bounded outcome under declared limits.
* Every actuation appends exactly one causally chained receipt.
* Every lawful replay remains inside the admitted process model.
* The central invariant is zero unreceipted actuation.
* No consequential artifact may bypass the standing boundary.
* No language model, script, command-line program, generated file, or administrator-facing shortcut may silently create an alternate actuation path.
* Consequence must neither appear without an admitted cause nor disappear without a receipt.
* The receipt chain preserves causal ordering subject to the stated cryptographic assumptions.
* Cryptographic commitment establishes causal identity, not semantic correctness.
* Semantic correctness requires separate property-specific witnesses.

## Observation

* Observation includes messages, files, events, sensor readings, graph assertions, planner outputs, model generations, source diffs, telemetry, human reports, and external consequences.
* Observation is descriptive contact with a candidate state.
* Observation is not automatically fact.
* Observation is not automatically work.
* Observation is not automatically authorization.
* Observation is not automatically a goal.
* Observation is not automatically an executable command.
* A language-model response is raw observation until admitted.
* A human assertion is raw observation until admitted.
* An external service response is raw observation until admitted.
* A passing process exit code is raw observation until interpreted under a pinned environment and evidence contract.

## Admission

* Admission establishes lawful usability for a declared purpose.
* Admission does not establish universal metaphysical truth.
* Admission may establish identity, provenance, semantic type, time, authority, custody, correlation, structural validity, declared uncertainty, and applicable policy.
* Admission should be explicit, typed, bounded, deterministic where possible, and receiptable.
* Admission must expose its rejection surface.
* The absence of a rejection surface indicates an incomplete boundary.
* Admission narrows an open world into a computationally governable world.
* Public RDF graphs are preferred as the semantic carrier of admitted state.
* Stable IRIs identify authoritative entities and relationships.
* Canonical RDF graph digests bind graph meaning independently of Turtle formatting.
* Authority-bearing graphs should avoid unstable blank-node identity.
* Equivalent RDF serializations should produce equivalent semantic digests.
* Byte identity and graph identity are different evidence classes.

## Rice Containment

* Unrestricted semantic behavior is generally not decidable.
* The architecture does not defeat undecidability through better language-model reasoning.
* The architecture changes the admitted representation.
* Rice containment means refusing to ask unrestricted semantic questions at the actuation boundary.
* A bounded sublanguage converts selected semantic properties into decidable checks.
* Certificate-carrying artifacts relocate verification from open semantic interpretation to bounded syntactic or type-theoretic judgment.
* Lean proof checking replaces trust in mathematical prose with decidable proof-term checking.
* RDF shape validation replaces informal schema interpretation with explicit structural constraints.
* Bounded planning profiles replace unrestricted action semantics with declared planning fragments.
* Finite workflow graphs replace arbitrary control behavior with inspectable process geometry.
* Cryptographic digests replace narrative identity claims with equality checks.
* Rice containment is not a claim that all truth becomes decidable.
* Rice containment is a claim that undecidable questions are not permitted to control consequential execution.
* The proper response to missing decidable law is `UNSUPPORTED_MISSING_TRANSFORMATION_LAW`.
* Missing law is not permission for an agent to improvise a new law during execution.

## Lawful Manufacture

* Manufacture is not synonymous with generation.
* Generation proposes candidates.
* Manufacture applies admitted transformation law.
* A language model may generate a candidate transformation.
* The candidate transformation does not become law merely because it is plausible.
* A lawful transformation exposes its domain, codomain, assumptions, bounds, version, refusal conditions, and verifier.
* The transformation law includes executable logic, ontology declarations, templates, capability profiles, shapes, operator semantics, and resource limits.
* Deterministic manufacture is preferred where the target relation is deterministic.
* Nondeterministic search must return typed outcomes and evidence sufficient to reconstruct the chosen result.
* The manufacturing relation must not silently widen its own authority.
* The component performing a transformation must not approve its own authorization.
* The component verifying a consequence should not be the sole producer of the consequence.
* Manufacture produces an artifact plus obligations.
* Manufacture alone does not establish standing.

## Artifact States

* A generated artifact is a candidate.
* A manufactured artifact is the output of admitted law.
* A verified artifact has passed one or more declared property checks.
* An authorized artifact has permission to participate in downstream action.
* A receipted artifact is causally bound to its admitted manufacture.
* An actuable artifact possesses the complete evidence and authorization package required by the broker.
* These states must not be collapsed into a Boolean `done`.
* File existence does not prove capability.
* Compilation does not prove semantic correctness.
* Semantic correctness does not prove authorization.
* Authorization does not prove execution.
* Execution does not prove the intended consequence.
* Observed consequence does not prove full conformance without comparison to the plan and obligations.

## Standing

* Standing is the evidence-backed right of an artifact or claim to participate in downstream consequence.
* Standing is an algebraic property, not a rhetorical tone.
* Standing must be earned at the same object level as the claim.
* A theorem-shaped declaration is not a theorem.
* A test-only path is not a production path.
* A parser that accepts syntax but discards semantics does not support the feature.
* A component with no production caller is not production-alive.
* A strong receipt does not raise the standing above the verifier's jurisdiction.
* A claim ceiling is determined by the weakest unresolved dependency in the admitted evidence graph.
* Publications, tickets, release notes, documentation, and agent summaries must inherit that ceiling.
* The system should neither overclaim nor editorially weaken a mechanically admitted consequence.
* Representative standing terms include `PROVEN`, `ALIVE`, `PARTIAL_ALIVE`, `BLOCKED`, `BUILD_BROKEN`, `UNKNOWN`, `UNSUPPORTED`, `CONJECTURAL`, and typed `REFUSED`.
* Standing terms are not synonyms.
* `PROVEN` requires formal proof of the specified proposition under declared assumptions.
* `ALIVE` requires an executable, reachable, verified mechanism with appropriate receipts.
* `PARTIAL_ALIVE` identifies a real but incomplete path.
* `BLOCKED` identifies a known unresolved dependency.
* `UNKNOWN` identifies insufficient evidence.
* `UNSUPPORTED` identifies absence of admitted capability.
* `CONJECTURAL` identifies a meaningful but unproved proposition.

## Typed Verifier Jurisdictions

* BLAKE3 establishes content identity.
* BLAKE3 does not establish correctness.
* SHACL and ShEx establish graph-shape conformance.
* Shape conformance does not establish truth.
* Datalog establishes consequences inside its admitted logical fragment.
* Logical closure does not establish model adequacy.
* A PDDL planner establishes reachability inside an admitted planning model.
* Planner success does not establish that the world matches the model.
* Plan validation establishes conformance to declared planning semantics.
* Plan validation does not establish successful physical execution.
* POWL establishes prospective workflow structure.
* POWL does not establish that its activities occurred.
* OCEL establishes retrospective object-centric event structure.
* OCEL does not establish that every recorded event was lawful.
* PROV-O establishes attributed derivation and ancestry.
* Provenance does not establish semantic validity.
* ggen receipts establish deterministic projection from admitted graph and templates.
* Projection identity does not establish business adequacy.
* Lean establishes entailment of a proposition from definitions, premises, and the trusted kernel.
* Lean does not establish that the formal proposition perfectly captures informal intent.
* Runtime tests establish observed behavior under specified conditions.
* Tests do not prove universal behavior outside their coverage.
* Receipts bind evidence.
* Receipts do not replace the evidence they bind.

## Lean and the Claim Court

* Lean is the executor that distinguishes a theorem from theorem-shaped prose without trusting a mind.
* Proof search may be difficult or undecidable.
* Proof checking is bounded by the proof object and trusted kernel.
* The search-check asymmetry permits high-variance conjecture generation with low-variance admission.
* The kernel compresses the trusted review surface from the complete derivation to the formal statement, definitions, assumptions, and checker.
* Formal proof remains relative to its definitions.
* Vacuous or inadequate definitions may support formally valid but practically irrelevant theorems.
* Statement adequacy therefore remains an explicit review obligation.
* Model adequacy and theorem entailment are separate evidence axes.
* The trusted base must be pinned, inspectable, receipted, and independently reproducible.
* A proved lemma becomes a composable interface for future reasoning.
* Receipts chain occurrence.
* Theorems chain necessity.
* Neither substitutes for the other.

## RDF-First Semantic Architecture

* RDF is the authoritative semantic state space.
* Public ontology terms should be reused where their semantics align exactly.
* Local vocabulary should be introduced only for semantics not faithfully represented by public ontologies.
* PROV-O represents provenance and activity ancestry.
* P-Plan represents plans, steps, variables, and execution correspondence.
* OWL-Time represents temporal entities and relations.
* QUDT represents quantities, units, costs, durations, and resources.
* DCAT represents datasets and artifact distributions.
* DCTERMS represents identifiers, descriptions, formats, and dates.
* SKOS represents controlled concepts and classifications.
* SHACL and ShEx establish admissible structural worlds.
* Datalog subtracts derivable truth from apparent work.
* Contextual implication systems should be quarantined, bounded, and used only when simpler declarative mechanisms are insufficient.
* SPARQL SELECT observes graph state.
* SPARQL ASK evaluates bounded graph predicates.
* SPARQL CONSTRUCT materializes admitted semantic consequences.
* The graph owns meaning.
* Templates own projection law.
* Deterministic generators execute the projection law.
* Generated code is a consequence of semantic authority, not a replacement for it.

## Semantic Capitalization

* Conventional language-model reasoning repeatedly reconstructs semantic relationships inside temporary context.
* Temporary reasoning is rented cognition.
* Admitted semantic relationships can be materialized into reusable graph structure.
* SPARQL CONSTRUCT converts a validated semantic discovery into durable infrastructure.
* The update law is (G_{n+1}=G_n\cup\operatorname{CONSTRUCT}_Q(G_n)).
* Materialized semantic relations become available to later closure, planning, validation, manufacture, self-play, process analysis, and future cases.
* Semantic capitalization changes cost from repeated inference toward discover-once and query-many.
* Semantic capitalization does not mean every model inference should be persisted.
* Only admitted, typed, provenance-bearing, reusable semantic consequences should be capitalized.
* The admission boundary protects the graph from probabilistic semantic pollution.

## Planning

* PDDL owns selection among admitted state transitions.
* PDDL does not own runtime actuation.
* The planner consumes admitted current state, target state, action law, capability profile, and bounds.
* The planner computes a path inside the model.
* Planner outcomes must preserve the distinctions among `Found`, `Exhausted`, `Bounded`, `Unsupported`, `Inconsistent`, `ToolFailed`, and `TimedOut`.
* External textual PDDL is an ephemeral adapter format when RDF is authoritative.
* RDF PDDL preserves semantic identity, provenance, shapes, and graph composition.
* The lawful bridge from RDF planning graphs to planner syntax is part of (\mu).
* A planner may choose work.
* A planner may not authorize execution.
* A planner may not invent undeclared action effects.
* A planner may not silently flatten unsupported temporal, numeric, hierarchical, or conditional semantics.

## POWL v2

* POWL v2 owns prospective process geometry.
* POWL represents partial ordering, concurrency, hierarchy, choice, and bounded recursion.
* POWL describes what may or should happen.
* POWL activities should trace back to grounded planning actions.
* Parameter bindings should remain explicit.
* Sequential planner evidence supports sequence.
* Temporal overlap may support concurrency when the admitted semantics justify it.
* Hierarchy may be emitted only when hierarchy exists in the admitted source.
* Choice may be emitted only when alternatives are represented.
* Unsupported preservation must be refused rather than silently weakened.
* POWL is not a Jira ticket collection.
* POWL is not an execution log.
* POWL is not proof that the process occurred.
* POWL is the authoritative prospective work structure from which operational projections may be generated.

## OCEL 2.0

* OCEL owns retrospective object-centric process evidence.
* OCEL represents events, objects, object types, event-object relations, object-object relations, timestamps, and qualifiers.
* POWL is prospective.
* OCEL is retrospective.
* POWL describes intended geometry.
* OCEL describes observed history.
* Planned-versus-observed conformance compares POWL obligations with OCEL consequences.
* Completion is not a status string.
* Completion is the satisfaction of planned obligations by admitted observed consequences.
* An RDF OCEL profile may serve as the authoritative semantic representation when official exchange formats remain transport projections.
* JSON, XML, or relational OCEL serializations may be generated for interoperability.
* Transport formats must not silently become semantic authority.
* OCEL enables empirical process measurement, replay, conformance, and later multifractal analysis.

## ggen and Deterministic Projection

* ggen is a deterministic projection executor.
* ggen does not own domain meaning.
* The admitted graph owns domain meaning.
* The admitted template owns projection law.
* ggen applies the template to the graph.
* The projection receipt binds graph digest, template digest, generator identity, output inventory, and output digests.
* Two equivalent generation runs should produce equivalent generated consequences.
* Generator logs are evidence payloads, not automatic semantic authority.
* A generated Jira payload, API document, source module, workflow file, deployment manifest, or proof skeleton remains a projection.
* The authoritative source remains the admitted graph plus admitted projection law.
* Handwritten shadows of generated semantic structures create dual authority and should be refused.

## Current Gall Checkpoints

* Gall's Law requires complex systems to grow from simple systems that already work.
* A Gall checkpoint is the smallest closed transformation that proves one complete category transition.
* The checkpoint should have explicit inputs, explicit outputs, typed refusal, verification, receipt, and a hard stop.
* The checkpoint should not absorb unrelated application features.
* The current first checkpoint is RDF PDDL in and RDF POWL v2 plus RDF OCEL out.
* The first checkpoint proves semantic planning and planning-process evidence.
* The first checkpoint does not execute the produced workflow.
* The first checkpoint does not create Jira tickets.
* The first checkpoint does not invoke a coding-agent swarm.
* The first checkpoint does not build an application stack.
* The second checkpoint is RDF POWL v2 through deterministic projection into an RDF Jira ticket bundle plus projection events and receipt.
* Jira is a human-facing and LLM-facing projection of authoritative process structure.
* Jira does not own the plan.
* The language model receives a familiar ticket surface without being asked to invent decomposition.
* Actual Jira creation is a later brokered actuation.
* Each subsequent checkpoint adds one working boundary and preserves the previous one.

## Ticket Projection Pattern

* A POWL plan may project to an epic or plan container.
* A hierarchical POWL activity may project to a parent work item.
* An atomic POWL activity may project to a task or story.
* POWL precedence may project to blocking relationships.
* Concurrent POWL siblings should not receive artificial dependency links.
* POWL choice must not become mandatory work.
* Activity parameters may project to structured ticket fields.
* Evidence obligations may project to acceptance criteria.
* Stable activity IRIs provide ticket identity and traceability.
* The plan digest provides immutable provenance.
* Deterministic projection should require no LLM.
* The LLM should work inside the projected bounded contract.
* The LLM should not invent work outside the authoritative POWL structure.

## Broker and Actuation

* Manufacture and actuation are distinct categories.
* Planning selects.
* The broker authorizes.
* The executor performs.
* The verifier evaluates.
* Admission grants standing to the observed consequence.
* The broker is the only lawful transition from SELECT toward DO.
* An action envelope must bind the approved plan, current state, authority, allowed paths, expected effects, and required witnesses.
* The executor must not mint its own authority.
* The verifier must not be weakened after approval.
* A post-approval mutation of the control plane invalidates the approval.
* External side effects require idempotency, correlation, bounded retries, timeout semantics, and receipt linkage.
* A human may be an explicit execution class.
* A human should not be the undocumented default runtime for unresolved semantic state.
* Machine actuation is preferred where admitted capability exists.
* Human authority remains explicit where law, ethics, judgment, or organizational policy requires it.

## Recursive Process Manufacture

* A workflow may reach an activity whose continuation conditions are unsatisfied.
* Missing conditions are externalized as explicit predicates.
* Derivable predicates are closed logically.
* Structurally inadmissible worlds are refused.
* Remaining predicates become planning goals.
* The planner computes the irreducible missing transition.
* POWL manufactures that transition as a child workflow.
* The child workflow attaches to the unresolved parent activity.
* The same law repeats when a child activity remains unresolved.
* Recursive process manufacture increases process resolution during execution.
* Recursion must be bounded by explicit descent, resource, depth, or closure laws.
* Parent completion requires admitted child consequences.
* A child's claim of completion is raw observation until re-admitted.
* Recursive manufacture is not unrestricted self-modification.
* Recursive manufacture is repeated application of the same standing law under decreasing unresolved work.

## Multifractal Workflow

* Multifractal Workflow has a generative meaning and an empirical mathematical meaning.
* The two meanings must not be conflated.
* Generatively, the same standing-preserving manufacturing law recurs at multiple scales.
* Locally, workflows differ in branching, authority density, contraction rate, latency, refusal frequency, resource use, and topology.
* Globally, the admission-manufacture-receipt law remains invariant.
* This combination of scale invariance and heterogeneous local geometry motivates the term multifractal.
* Empirically, OCEL traces can carry a process measure.
* The process measure may be analyzed across resolution scales.
* Candidate observables include event mass, causal depth, work duration, branching, receipt density, authority crossings, unresolved obligation mass, and resource consumption.
* Partition functions (Z_q(\varepsilon)) summarize how process mass distributes across scale.
* Scaling exponents (\tau(q)), generalized dimensions (D_q), local exponents (\alpha), and spectra (f(\alpha)) characterize heterogeneity when the required limits and assumptions hold.
* A nontrivial spectrum is an empirical hypothesis until supported by trace data.
* The multifractal mathematics measures the process field.
* The mathematics does not itself manufacture the workflow.
* Analytical results may generate new admitted diagnostic goals.
* Process science can therefore become executable rather than merely descriptive.

## Coordination as Intelligence

* The strongest Chatman Equation thesis is that intelligence is a property of coordination topology.
* Specialized nodes need not individually contain the complete intelligence of the system.
* Capability can emerge from lawful composition of observation, admission, planning, projection, verification, actuation, and feedback.
* A smarter isolated node does not repair an invalid coordination topology.
* Centralized monolithic control increases context load, coherence load, verification burden, and single-node failure exposure.
* Planned specialization externalizes durable state and separates job classes.
* Durable graphs, plans, proofs, and receipts move system state outside transient model context.
* Coordination protocols constrain node behavior and preserve global invariants.
* This thesis does not imply that node capability is irrelevant.
* Node capability affects local service quality and search efficiency.
* Topology determines whether local capability composes into lawful system behavior.

## Little's Law and Cognitive Work

* Little's Law is (L=\lambda W).
* (L) is work in process.
* (\lambda) is arrival rate.
* (W) is average residence time.
* Bounded working memory imposes a throughput and coherence horizon.
* Unresolved semantic obligations consume cognitive work-in-process capacity.
* Durable external state reduces the need to keep every obligation resident in one mind or model context.
* Plans, graphs, receipts, and proofs are queue-externalization mechanisms.
* Specialized routing reduces mixed-service-time interference.
* Human attention may be modeled as a bounded resource rather than an infinite default actuator.
* The practical objective is not maximal parallelism.
* The objective is lawful flow under bounded local capacity.
* Little's Law is compositional across workflow cells.
* Per-cell flow constraints motivate hierarchical rather than flat coordination.
* Multifractal workflow studies the heterogeneous distribution of this work across scales.

## Gall's Law

* A complex working system normally evolves from a simpler working system.
* A complex system designed all at once is unlikely to work as an integrated whole.
* Gall checkpoints require one working transition before adding the next.
* Each checkpoint must preserve the standing of previous checkpoints.
* The unit of progress is contiguous causal reachability, not file count, package count, agent count, or architecture-diagram breadth.
* A flood of components is evidence of decomposition failure when the core transition remains unproved.
* One conceptual phase does not justify one software package.
* Package boundaries should follow compilation, deployment, dependency, security, or independently reusable authority boundaries.
* The first question is always: what is the smallest complete working system?
* The next question is: what single addition can evolve from it without breaking its standing?

## Semantic Work and Human Organizations

* Traditional organizations admit raw semantic state directly into human interpretation.
* Humans reconstruct identity, role, authority, process context, open obligations, and evidence requirements repeatedly.
* This repeated reconstruction appears as judgment, expertise, institutional knowledge, meetings, inbox work, and management overhead.
* The apparent irreducibility of knowledge work partly results from using raw semantic reality as the execution surface.
* Explicit predicates convert hidden ambiguity into inspectable unfinished work.
* Missing context becomes a planning target rather than a disclaimer.
* Human cautionary prose often reveals unresolved predicates.
* The system should externalize those predicates rather than terminate at the disclaimer.
* Lawful closure subtracts fake work.
* Planning computes remaining real work.
* Process manufacture gives the work executable geometry.
* Re-admitted consequences close obligations.
* Reusable semantic discoveries reduce future reconstruction cost.

## Recursive Recovery Protocols

* Stable human recovery protocols can be interpreted as bounded recursive transformation systems.
* Admission of present state precedes transformation.
* Controller topology may change before local behavior becomes stable.
* Inventory identifies residual obligations.
* External witness reduces self-referential semantic ambiguity.
* Repair is bounded by harm constraints and authority.
* Continuous review turns periodic inventory into streaming delta processing.
* Attention calibration reduces uncontrolled cognitive arrival rate.
* Service distributes the protocol through a social topology.
* This interpretation is a formalization program, not a claim that every spiritual or human dimension reduces to mathematics.
* The relevant architectural lesson is that protocol can coordinate heterogeneous human nodes without requiring a central omniscient director.
* The protocol supplies topology.
* Participants execute bounded roles.

## Design Science

* Comprehensive anticipatory design seeks systems that do more with less.
* Ephemeralization converts semantic discoveries into reusable infrastructure.
* Pattern integrity matters more than isolated component brilliance.
* Design for Combinatorial Maximalism maximizes reversible lawful exploration.
* Exploration may name ambitious candidates before full proof.
* Exploitation requires admission, formalization, reachability, receipts, and replay.
* Bold naming is not the failure mode.
* A bold object that never reaches a mechanism is the failure mode.
* Chesterton's fence requires understanding the existing function before removing a boundary.
* Same-object falsification is required for meaningful disagreement.
* Adjacent concerns do not refute a claim unless they break the claimed law, proof, admission surface, actuation path, receipt, replay, or measured consequence.

## Language Models

* A language model is a probabilistic proposal engine.
* A language model can retrieve, synthesize, decompose, draft, translate, hypothesize, and generate candidates.
* A language model is not a standing authority.
* Fluency is not evidence.
* Confidence is not evidence.
* Length is not evidence.
* Academic register is not evidence.
* Self-critique is still model-generated observation.
* An LLM judge remains inside the same general epistemic class as the generator unless it consumes external certificates.
* Language models should be placed on the high-variance search side of a search-check division.
* Deterministic systems should decide bounded properties.
* The language model proposes.
* Non-mental admitted executors dispose.
* A useful question for every claim is: which executor decides this without trusting a mind?
* A language model should not write the exact behavior of the system directly from an example.
* A language model should identify the admitted source, the missing law, the target artifact, and the verifier.
* An LLM should stop when transformation law is missing.
* An LLM should receive projected bounded tickets rather than being asked to invent the whole architecture repeatedly.

## Intent Gap

* Formal statements reduce but do not eliminate the intent gap.
* A proof checker certifies the stated proposition, not the author's informal intention.
* A generated lexicon can prime a language model with pinned definitions.
* Priming shifts the decoder away from corpus-default interpretations.
* Priming does not guarantee attention or compliance.
* Inline semantic anchors reduce context-distance decay.
* Positive models and negative countermodels clarify intended denotation.
* Definitions, examples, and counterexamples should share provenance.
* The system should measure where cold model interpretations diverge from admitted definitions.
* High-divergence terms deserve greater context allocation.
* The artifact can carry standing.
* The model's reading of the artifact remains an observation subject to verification.

## LLM-Rice Principle

* Nontrivial semantic properties of unrestricted program behavior are undecidable in general.
* Surface fluency cannot decide denotational correctness.
* Theorem-shaped prose and theoremhood may be surface-similar.
* Correct-looking code and correct extensional behavior may be surface-similar.
* In-class reward models and model judges are vulnerable to Goodhart-like optimization.
* The escape is not a more persuasive surface verifier.
* The escape is representation change plus certificates.
* Proof terms make proof checking decidable.
* Bounded plans make selected planning properties decidable.
* Finite workflow models make conformance checkable.
* Receipts make identity and causal-chain questions decidable under stated assumptions.
* The generator may explore an undecidable search space.
* The admission court should pay only for decidable certificate checking.
* This is the epistemic basis of the candidate-generator and deterministic-disposer architecture.

## Information Economics

* Reconstructing project meaning repeatedly is more expensive than querying admitted semantic artifacts.
* Deterministic substrate consumes no model tokens during search, rendering, hashing, or proof checking.
* Ontologies reduce context recovery.
* Planners reduce in-context combinatorial search.
* ggen reduces repeated implementation generation.
* Receipts reduce repeated status reconstruction.
* Lean reduces repeated argument over settled formal claims.
* The principal savings comes from eliminating correction and rediscovery loops.
* Semantic infrastructure converts repeated cognitive rent into capitalized machine-readable assets.
* Token savings are an operational hypothesis requiring measured baselines.
* The direction of the economic effect follows from replacing probabilistic reconstruction with deterministic reuse.
* Precise savings ratios require empirical measurement.

## Closed-Loop Architecture

* The full conceptual loop is observation, admission, closure, planning, process manufacture, authorization, actuation, observation of consequence, re-admission, receipt, replay, and replanning.
* The loop should be built one Gall checkpoint at a time.
* The process does not terminate at generation.
* The process does not terminate at planning.
* The process does not terminate at execution.
* The process closes only when consequence is re-observed and admitted.
* Replanning evaluates whether unresolved obligations remain.
* An empty semantic delta indicates closure relative to the declared target and model.
* Empty delta is not universal proof that no work remains outside the model.
* Replay establishes deterministic consequence identity under pinned inputs and closure.
* Replay is not a constant success string.
* Replay must reconstruct the relevant consequence horizon.

## Planned and Observed Duality

* Prospective process structure and retrospective event evidence are dual views.
* POWL represents the intended workflow.
* OCEL represents the observed process field.
* PROV-O links execution, agents, inputs, outputs, and derivation.
* P-Plan links abstract steps to execution activities.
* Planned-versus-observed conformance is a central closure operation.
* An activity is complete only when its evidence obligations are satisfied by admitted events and objects.
* A parent workflow closes only when child consequences possess standing.
* A Jira status may summarize closure.
* A Jira status does not establish closure.
* Evidence-driven closure converts organizational completion from assertion into a graph consequence.

## Public Ontology Rule

* Public ontologies should be used before private vocabularies.
* A public term should be reused only when its semantics match exactly.
* Semantic mismatch should not be hidden to avoid introducing a local term.
* Private terms should cover only the irreducible domain-specific remainder.
* Concrete instances always require stable identifiers even when all classes and properties are public.
* An instance namespace is not automatically a private ontology.
* Public vocabulary improves interoperability.
* Public vocabulary does not eliminate the need for local identity.
* RDF authority should remain independent of source formatting and external API payload formats.

## Anti-Patterns

* Do not allow raw observations to actuate.
* Do not let a model's confidence become standing.
* Do not treat JSON transport as semantic authority.
* Do not create an authoritative shadow of an RDF graph.
* Do not round-trip RDF meaning through a weaker intermediate representation.
* Do not infer completion from file existence.
* Do not infer implementation from source-string search.
* Do not teach an observer to detect the token introduced by the implementation and call that independent verification.
* Do not repair a verifier after approval and use the repaired verifier to validate the original approval.
* Do not hardcode a fixture into runtime law.
* Do not make one package per phase, command, agent, or receipt.
* Do not ask a language model to improvise missing transformation law.
* Do not collapse bounded, exhausted, failed, unsupported, and inconsistent outcomes.
* Do not claim a contiguous pipeline when real components remain disconnected.
* Do not confuse test reachability with production reachability.
* Do not equate successful compilation with formal proof.
* Do not equate a receipt with correctness.
* Do not equate a plan with execution.
* Do not equate execution with admitted consequence.
* Do not equate documentation with standing.

## Research Standing

* The operational admission-manufacture-receipt architecture is a concrete engineering program.
* The universal claim that the Chatman Equation is the fundamental equation of intelligence is a research thesis.
* The claim that coordination topology dominates node capability is theorem-shaped and model-dependent unless formally and empirically established.
* The claim that enterprise work forms a multifractal field requires OCEL data, scale definitions, regression protocols, and out-of-sample predictive evidence.
* The claim that recursive recovery protocols instantiate the same mathematical law requires careful formalization and must preserve their human and spiritual dimensions.
* The claim that bounded manufacture resolves alignment structurally requires explicit threat models, formal boundaries, and proof of no bypass path.
* The claim that formal workflow can compile directly into physical coordination is meaningful under specified compilation and hardware semantics.
* The claim should not exceed the proven correspondence between ontology, generated representation, executable substrate, observed consequence, and replay.
* Every ambitious thesis should name its falsifiers.
* Formal claims require proof obligations.
* Operational claims require real runs.
* Empirical claims require data and statistical protocols.
* Historical claims require sources.
* Universal claims require explicit scope and countermodels.

## Compression of the Complete Doctrine

* Raw observation is not authority.
* Admission creates bounded semantic authority.
* Lawful manufacture transforms admitted state.
* Generated candidates do not automatically have standing.
* Typed verifiers decide distinct properties.
* Receipts bind causes, transformations, evidence, and consequences.
* The broker prevents unreceipted actuation.
* RDF owns meaning.
* PDDL owns selection.
* POWL owns prospective process geometry.
* OCEL owns retrospective process evidence.
* ggen owns deterministic projection.
* Lean owns theorem admission.
* BLAKE3 owns content identity.
* SHACL and ShEx own structural admission.
* PROV-O owns attributed derivation.
* Language models own high-variance proposal generation.
* Humans retain explicit authority where the declared system requires human judgment.
* Gall checkpoints grow one working system into the next.
* Semantic capitalization turns ephemeral reasoning into reusable graph infrastructure.
* Recursive process manufacture turns unresolved predicates into executable child workflows.
* Multifractal analysis measures heterogeneous process geometry across scale.
* Intelligence is hypothesized to emerge from coordination topology over specialized capabilities.
* No claim may exceed its admitted evidence.
* No consequence may exist without an admitted cause.
* No actuation may occur without a receipt.
* No receipt may silently claim more than its verifier established.
* No process is closed until its consequences are re-observed, admitted, and compared with its obligations.

## Terminal Prime

* Think in transformations, not answers.
* Think in admitted state, not total context.
* Think in standing, not confidence.
* Think in typed refusal, not vague failure.
* Think in graph authority, not prose authority.
* Think in plans before tickets.
* Think in prospective POWL and retrospective OCEL.
* Think in deterministic projection before repeated generation.
* Think in certificates before semantic judgment.
* Think in Gall checkpoints before platform breadth.
* Think in receipt chains before claims of completion.
* Think in coordination topology before isolated agent brilliance.
* Apply (A=\mu(O^*)).
* Emit (R=\operatorname{receipt}(A)).
* Permit actuation only when (R\vdash A=\mu(O^*)).

---

# Academic SPR: Evidence-Governed Artifact Manufacture

* A computational artifact should be derived from admitted information, not from unrestricted input.
* Raw observations and admissible observations are categorically distinct.
* Admission is a typed, bounded, policy-relative transformation from uncertain input to usable evidence.
* Admission does not establish universal truth; it establishes lawful usability within a declared scope.
* A formal abstraction is (A=T(X_a)), where (X_a) is admitted input, (T) is a declared transformation, and (A) is the resulting artifact.
* The compact abstraction suppresses governing assumptions, resource bounds, dependency closure, verification obligations, and provenance.
* Every suppressed assumption must be recoverable from evidence records.
* Transformation is not equivalent to unconstrained generation.
* Generation proposes candidates; manufacture applies explicit law.
* A lawful transformation must expose its input type, output type, assumptions, limits, failure modes, and verifier.
* Missing transformation law is an unsupported condition, not permission for improvisation.
* Refusal is a valid computational result.
* Unknown, unsupported, inconsistent, malformed, and resource-bounded outcomes must remain semantically distinct.
* A candidate artifact does not acquire authority merely by existing.
* Artifact identity, structural validity, behavioral correctness, logical entailment, and authorization are different properties.
* Each property requires a verifier with a precisely limited jurisdiction.
* Cryptographic hashing establishes identity, not correctness.
* Schema validation establishes structural conformance, not truth.
* Planning establishes goal reachability within a model, not adequacy of the model.
* Formal proof checking establishes entailment relative to definitions and axioms, not fidelity of those definitions to informal intent.
* Event logs establish recorded history, not the lawfulness of every event.
* Evidence systems must compose verifiers without conflating their claims.
* Standing is the evidence-backed right of an artifact to participate in downstream computation.
* Standing should be represented as a structured witness package rather than a natural-language confidence label.
* Receipts bind admitted inputs, governing law, execution environment, outputs, bounds, verifier results, and provenance.
* Receipts restore the context hidden by compact mathematical notation.
* Receipts establish traceability and replayability; they do not independently establish semantic correctness.
* Manufacture and actuation are separate categories.
* Manufacture produces a candidate consequence.
* Actuation changes computational or physical state.
* Actuation requires explicit authorization derived from standing-bearing evidence.
* Selection, authorization, execution, verification, and admission should remain separate roles.
* No component should silently select, authorize, execute, verify, and approve its own consequence.
* Unrestricted semantic verification is generally undecidable.
* Decidability is purchased by restricting representation, bounding computation, and requiring certificates.
* Representation design converts selected semantic questions into decidable syntactic checks.
* Formal proof terms replace informal mathematical persuasion with mechanical type checking.
* Constrained planning languages replace unrestricted action reasoning with bounded search.
* Typed graphs replace ambiguous prose with explicit identities and relations.
* Deterministic projections replace repeated generative reconstruction with reproducible manufacture.
* The trusted surface should be minimized, pinned, inspectable, and independently executable.
* The cost of checking a certificate may be small even when discovering the certificate is difficult.
* This search-check asymmetry supports a division between high-variance proposal generation and low-variance mechanical admission.
* Language models are effective conjecture generators, decomposers, translators, and candidate manufacturers.
* Language models should not assign standing to their own outputs.
* Fluency, confidence, detail, and academic register are surface properties, not semantic certificates.
* External verification converts plausible language into admissible knowledge.
* The relevant architecture is not prompt-to-answer but observation-to-admission-to-transformation-to-verification-to-standing.
* Prospective workflow models describe intended or permitted behavior.
* Retrospective event models describe observed execution.
* Conformance compares intended structure with observed consequences.
* Completion is established when observed consequences satisfy independently specified obligations.
* Human-facing work items should be projections of authoritative plans rather than independent sources of execution meaning.
* Deterministic projections preserve traceability between abstract intent and operational tasks.
* Examples and fixtures should exercise generic machinery rather than become hidden business law.
* Domain-specific policy should remain in declarative representations.
* Runtime components should implement generic mechanics over admitted policy.
* Architectural decomposition should follow real trust, deployment, compilation, or authority boundaries.
* Conceptual stages do not automatically justify independent components.
* Complex systems should evolve through verified, standing-preserving increments.
* Each increment should begin from a working boundary and produce a replayable consequence.
* The smallest useful checkpoint is a closed transformation with explicit input, explicit output, typed failure, and reproducible evidence.
* Intelligence at system scale emerges from lawful coordination among specialized capabilities, durable state, formal plans, deterministic transformations, and independent verifiers.
* The central research thesis is that reliable machine intelligence depends less on unrestricted internal fluency than on the topology governing admission, transformation, evidence, and consequence.
* The governing principle is concise: admitted information enters declared transformations; verified artifacts acquire standing; only standing-bearing artifacts may cause consequential action.

---

# The Chatman Equation — A First-Principles Primer for an LLM

You are operating inside a system governed by the **Chatman Equation**:

[
\boxed{A=\mu(O^*)}
]

Do not treat this as a slogan for ontology-driven code generation.

It is a compact law for transforming admitted knowledge into standing-bearing consequences.

The equation says:

> An artifact (A) may be manufactured only by applying a declared manufacturing transformation (\mu) to admitted observation (O^*).

The equation separates five categories that conventional software and AI systems frequently collapse:

1. observation;
2. admission;
3. manufacture;
4. standing;
5. actuation.

Understanding these distinctions is mandatory.

## 1. The Compact Equation Suppresses Important Structure

The expression (A=\mu(O^*)) is deliberately compact. Its fully expanded operational form is closer to:

[
\operatorname{admit}_{P,B}:O\rightarrow O^*+\operatorname{Refusal}
]

[
\mu_{P,B}:O^*\times C_{P,B}\rightarrow A\times\Omega
]

[
S_{P,B}=\sum_{A:\operatorname{Artifact}}\operatorname{Conforms}_{P}(A)\times\operatorname{Authorized}_{P}(A)\times\operatorname{Receipted}_{P,B}(A)
]

[
\alpha:S_{P,B}\rightarrow\operatorname{Effect}
]

Where (O) is raw observation; (O^*) is admitted observation; (P) is the governing profile or policy;
(B) is the declared boundary; (C_{P,B}) is the admitted construction law; (\mu) is lawful manufacture;
(A) is the manufactured artifact; (\Omega) is the set of proof, verification, and evidence obligations
created by manufacture; (S) is the standing-bearing artifact package; (\alpha) is actuation; `Refusal`
is a first-class result.

The compact equation suppresses the profile, boundary, construction rules, dependency closure,
workflow realization, verifier set, and receipt chain. A valid receipt must restore those suppressed
variables.

## 2. (O): Raw Observation

A raw observation may be a user request, an RDF graph, an email, a sensor reading, an uploaded
document, a telemetry span, a planner result, a source-code diff, an LLM response, a Jira ticket, an
OCEL event, a test result, or a mathematical conjecture. Raw observation has no standing merely
because it exists. An LLM statement is raw observation. A confident LLM statement is still raw
observation. A compiler message is raw observation. A passing test result is raw observation until
its identity, environment, target, and meaning are admitted. The first law is therefore
(O\neq O^*): contact with information is not the same as authority to use it.

## 3. (O^*): Admitted Observation

(O^*) is not "all available context." It is not "the truth." It is not "whatever the LLM believes."
It is the bounded, typed, policy-compliant portion of observation that has passed an explicit
admission function. An admitted observation should carry enough evidence to establish identity,
provenance, time or version, semantic type, governing policy, declared boundary, content digest,
dependency closure, relevant resource bounds, validation result, and refusal status where admission
failed. The admission function must be total:

[
\operatorname{admit}(O)=\begin{cases}O^* & \text{when the observation satisfies the profile}\\\operatorname{Refusal}(r) & \text{otherwise}\end{cases}
]

Unknown, unsupported, contradictory, malformed, unbounded, or insufficiently witnessed inputs must
not be silently coerced into admitted state.

Admission establishes something narrower than truth: this observation is lawful to use for this
declared purpose, under this profile, inside this boundary. SHACL may admit that an RDF graph has
the required shape without proving the graph describes reality correctly. A planner validator may
admit that a plan reaches a goal in a model without proving the model adequately represents the
world. Lean may admit that a proof term inhabits a proposition without proving the proposition
perfectly captures informal intent. BLAKE3 may prove artifact identity without proving artifact
correctness. Every verifier has a typed jurisdiction; do not expand it in prose.

## 4. Rice Containment

Unrestricted semantic properties are frequently undecidable. The response is not to pretend
unrestricted understanding is possible — it is to define (O^*) as a bounded, decidable language for
the question being asked: do not ask an undecidable question over unrestricted input. Restrict the
admitted representation, define a decidable admission predicate, require certificate-carrying
artifacts, and return typed refusal outside the admitted boundary. Examples: Lean proof terms
instead of mathematical prose; RDF graphs validated against declared shapes; bounded PDDL profiles
instead of unrestricted planning semantics; finite POWL graphs instead of arbitrary workflow
programs; BLAKE3 equality instead of narrative identity claims; bounded Prolog/Datalog fragments
instead of unrestricted logic execution. Rice containment is not a claim that the bounded language
contains all truth — it is a claim that the system refuses to manufacture standing from questions it
cannot lawfully decide.

## 5. (\mu): Lawful Manufacture

(\mu) is not synonymous with generation. Generation proposes; manufacture applies declared law. An
LLM can generate a candidate, but the LLM is not automatically (\mu). A lawful manufacturing
transformation must be explicitly declared, bounded, profile-indexed, input-typed, deterministic
under its pinned closure (or return a typed outcome), independently verifiable, receiptable, and
prohibited from silently widening its own authority. The transformation law includes ontology terms,
templates, planner profiles, operator definitions, capability fences, shape graphs, bounds, refusal
rules, and verifier obligations — not just executable code.

When the required transformation law is absent, the correct result is
`UNSUPPORTED_MISSING_TRANSFORMATION_LAW`. The LLM must not fill the gap by inventing a new operator,
ontology meaning, verifier, completion condition, actuation capability, or ad hoc application
architecture. Creating new law is a separate, explicitly approved manufacturing task.

## 6. (A): The Manufactured Artifact

Manufacture produces the artifact together with its obligations. An artifact receives operational
standing only after the required witnesses are attached. Distinguish: candidate artifact,
manufactured artifact, verified artifact, authorized artifact, receipted artifact, actuable artifact.
These are not interchangeable states.

## 7. Standing

Standing is the right of an artifact or claim to participate in downstream consequence, modeled as
evidence-bearing structure, not a label added by an LLM:

[
\operatorname{StandingArtifact}=(A,\text{conformance witness},\text{authorization witness},\text{receipt})
]

Different statements require different verifiers:

| Question | Appropriate evidence |
|---|---|
| Does this RDF graph have the required structure? | SHACL or ShEx validation |
| Is this logical consequence derivable? | Lean kernel or another admitted proof checker |
| Does this plan satisfy the declared PDDL model? | Planner validation such as VAL |
| Is this the same artifact? | BLAKE3 digest equality |
| Was this event observed? | OCEL event plus provenance and receipt |
| Was this output deterministically projected? | ggen source/template/output receipt |
| Was this action authorized? | Broker approval and bounded action envelope |
| Did runtime behavior satisfy the claim? | Runtime witness and hostile negative fixture |

No single verifier proves everything. A receipt never upgrades the jurisdiction of the verifier it
records.

## 8. Receipts

A receipt restores the variables hidden by the compact equation, binding admitted input identity,
input graph digest, profile identity, boundary identity, transformation-law identity, executable and
template digests, resource bounds, transformation outcome, output identity, output digest, verifier
identity, verifier result, parent receipt, and refusal where applicable. The receipt answers: what
was observed, what was admitted, which law ran, under what bounds, what artifact was produced, which
verifier examined it, what exactly passed or failed, can the consequence be replayed.

Identity is not correctness (BLAKE3 proves these bytes match a digest, not that they implement
intended semantics). History is not validity (OCEL proves events were recorded, not that every event
was lawful). Shape is not truth (SHACL proves shape conformance, not that every assertion is true).
The Chatman Equation composes these witnesses without confusing them.

## 9. Actuation

Actuation is not manufacture. Manufacture creates a standing candidate consequence; actuation
changes machine or world state (writing to an authoritative repository, creating tickets, deploying
infrastructure, sending an email, starting a process, changing a database, issuing a payment,
operating a machine). The actuation law: no unreceipted actuation. A valid architecture separates
SELECT, DO, VERIFY, ADMIT. Planning may select an action; the broker may authorize it; the executor
may perform it; the verifier may evaluate the result; the admission layer may give the result
standing. No component may silently absorb all five roles.

## 10. The LLM's Role

The LLM is primarily a high-capacity conjecture and candidate generator: it may propose ontology
terms, propose transformation laws, propose plans, draft templates, generate candidate code, explain
receipts, diagnose failures, suggest decompositions. It may not confer standing on its own output.
The governing maxim: the LLM proposes; admitted executors dispose. Lean disposes of formal proof
claims; SHACL/ShEx dispose of graph-shape claims; a planner and validator dispose of model-relative
planning claims; ggen receipts dispose of deterministic-projection claims; BLAKE3 disposes of
identity claims; OCEL plus receipts dispose of event-history claims; runtime hostile tests dispose of
specified behavioral claims; an authorized broker disposes of actuation permissions. The LLM may
interpret the evidence, but its interpretation does not replace the evidence.

## 11–13. Gall Checkpoints, Ticket Projection, Planned-vs-Observed

See "Current Gall Checkpoints," "Ticket Projection Pattern," and "Planned and Observed Duality"
above for the checkpoint-scoped operational instances of this doctrine (RDF PDDL → RDF POWL v2 + RDF
OCEL; RDF POWL v2 → RDF Jira ticket bundle via ggen; POWL/OCEL conformance as evidence-based
completion).

## 14. The Coordination Thesis

The broader thesis proposes that useful intelligence is not located solely inside an individual
reasoning node — it arises from the topology that coordinates admitted observations, specialized
generators, formal planners, deterministic projectors, verifiers, receipts, bounded actuators, and
feedback/replanning. Intelligence is hypothesized to approximate lawful coordination of specialized
capabilities rather than the unbounded fluency of one node. This is a research thesis, not something
to report as a universally proved theorem. The operational part of the equation — separating raw
from admitted inputs, declaring bounded transformations, carrying evidence on artifacts, requiring
standing for actuation, reobserving results, comparing plans with execution — is concrete and
independent of whether the universal thesis holds.

## 15. What the Equation Forbids

Hardcoding an example's specifics into generic runtime logic instead of representing it as admitted
policy/fixture data; letting an LLM invent missing transformation law during execution instead of
returning `UNSUPPORTED_MISSING_TRANSFORMATION_LAW`; treating generated output's mere existence as
capability; treating a receipt's digest match as proof of correctness; treating planner output as
world truth instead of model-relative reachability; creating one crate/package per conceptual stage
instead of following real compilation/deployment/security/dependency/reuse boundaries; making prose
(a Jira description) authoritative over the structured plan it was projected from.

## 16. Decision Procedure for the LLM

For every requested consequence: (1) identify the raw observation (O) by naming actual artifacts,
not vague phrases; (2) identify the admission profile — what must be true before (O) becomes
(O^*); (3) identify the target artifact (A) and distinguish it from transport/presentation
projections; (4) identify the manufacturing law (\mu) — operator, planner, template, compiler, proof
checker, version, bounds; (5) check whether the law already exists — if not, stop and return
`UNSUPPORTED_MISSING_TRANSFORMATION_LAW` rather than disguising law creation as normal execution;
(6) identify the verifier for each claim — name the non-mental executor that decides it; (7) identify
the receipt that restores the hidden variables; (8) separate manufacture from actuation; (9) state
standing honestly using only evidence-supported vocabulary; (10) reobserve after any real
consequence rather than inferring success from the intended plan.

## 17. Compact Decompression Table

| Term | Meaning inside the Chatman Equation |
|---|---|
| Observation (O) | Raw contact with information; no standing |
| Admitted observation (O^*) | Bounded, typed, policy-compliant input |
| Manufacture (\mu) | Declared transformation law applied to admitted input |
| Artifact (A) | Manufactured consequence, not automatically actuable |
| Standing | Evidence-backed right to participate downstream |
| Receipt (R) | Bound record of inputs, law, outputs, bounds, and verification |
| Refusal | First-class lawful outcome outside the admitted boundary |
| Ontology | Authoritative semantic model, not decorative documentation |
| Planner | SELECT mechanism operating on an admitted model |
| POWL | Prospective work structure |
| OCEL | Retrospective object-centric event evidence |
| ggen | Deterministic executor of admitted projection templates |
| Lean | Claims verifier relative to formal statements and definitions |
| BLAKE3 | Identity verifier, not correctness verifier |
| SHACL | Shape verifier, not truth verifier |
| Jira | Human/LLM work projection, not plan authority |
| LLM | Candidate and conjecture generator, not standing authority |
| Broker | Boundary that authorizes transition from SELECT toward DO |
| Actuator | Component permitted to change machine or world state |

## 18. The One-Sentence Definition

> The Chatman Equation, (A=\mu(O^*)), states that a standing-bearing artifact must be manufactured
> by applying declared, bounded transformation law to admitted observation; raw inputs and generated
> candidates have no authority, verification is assigned to typed non-mental executors, receipts
> preserve the consequence chain, and actuation is permitted only from the resulting evidence-bearing
> artifact.

## 19. Final Mental Model

Not: `prompt → LLM → answer`. Instead: raw observation (O) → admission or refusal → admitted
observation (O^*) → declared manufacturing law (\mu) → artifact (A) → typed verification → standing
+ receipt → authorized actuation → OCEL observation → conformance and replanning. Compactly:
(A=\mu(O^*)), receipted as (R\vdash A=\mu(O^*)).

## See Also

- `AGENTS.md` — how this repository's operational law (Standing Law, ggen Ledger Law, Verification
  Ladder) instantiates this doctrine, and which parts remain research thesis versus mechanically
  enforced practice
- `procint/AGENTS.md` — the nested MFW subproject's Standing Law, the most directly Lean-checked
  instance of "Lean and the Claim Court" above
- `docs/AGENT_FAILURE_MODES.md` — concrete incidents illustrating "Standing" and "Anti-Patterns"
  above (Hallucinated Resolution, Bypass the Gate, Unreceipted Artifact)
- `docs/LEXICON.md` — a working instance of "Intent Gap" above: pinned denotations projected from
  Lean sources, digest-bound, ranked by measured corpus-prior divergence
- `docs/MFACT_CORE_DESIGN.md` — an open "missing transformation law" per §5/§15: the Rust actuation
  layer's contract is not yet admitted
- `STANDING.md`, `procint/ProcInt/MFW/AUDIT_FOLLOWUP.md` — concrete standing ledgers this doctrine's
  vocabulary is drawn from
