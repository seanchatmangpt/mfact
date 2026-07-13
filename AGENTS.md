# mfact — Agent Core Discipline (Constructive Exploit)

This project maintains **AGI-level Constructive Mathematics Discipline** — every claim, proof, and measurement must be explicitly exhibited as a physical artifact. Flavor text, marketing metrics ("1000x phase change"), and unfalsifiable assertions are treated as critical defects.

## 1. The Doctrine of Construction
In every domain, construction means you can point to the artifact and hand it to someone else to check independently. 

- **Algebra**: Construction is closure under generators. Given a signature of constructors and a base set, the constructed object is the smallest set closed under those constructors. A constructive existence proof of `∃x.P(x)` is an actual pair `(x, proof of P(x))` built by applying introduction rules, not a refutation of `¬∃x.P(x)`. Do not state that a property holds trivially; exhibit the term.
- **Calculus**: Construction is an explicit rate, not an assertion of smallness. An ε–δ argument must be constructive in form: for every ε you exhibit a δ by explicit formula, not by appeal to "eventually". Exhibit the closed-form bound and prove the limit (e.g. `Tendsto ... (nhds 0)`).
- **Geometry**: Construction is an explicit chart, not an assumed identification. Produce the object via a finite sequence of allowed operations. (e.g. `LocalizedProbe` must be a literal ball; a mapping must be an explicit coordinate chart).

## 2. Explore vs. Exploit
Rigor is knowing exactly when you are in the Explore phase versus the Exploit phase, and never conflating the two.
- **Explore**: Names the right vocabulary and conceptual shape before the rigor is filled in.
- **Exploit**: Takes a named ambition and builds the falsifiable measurement that makes it real. 
- *Rule*: Never attach marketing scale ("1000x phase change", "turbulence") to unbenchmarked code. To claim a phase change, you must exhibit the exact metric, measure it across scales, compute the scaling exponents, and computationally verify the threshold.

## 3. The Combinatorial Maximalism Mandate
Never assert a property that can be explicitly constructed. 
- **No vacuous tautologies:** If your theorem concludes `True = True`, delete it.
- **No redundant scaffolding:** Stubs and fake hash-map passes over tiny fixtures are instantly rejected.
- **Strict Boundaries:** Never touch `~/praxis`. You operate securely inside `~/mfact`.

## 4. The No Ambient Theorem Authority Law
No imported theorem lends standing to an mfact/MFW claim until an explicit correspondence
morphism has been admitted and its structure-preservation obligations have been discharged.
Both sides can be real, tested, and impressively named; the system is still false if the edge
between them is imaginary. The corrections ledger this law was distilled from lives in
`ROADMAP_MATH_SPINE.md`.

This is the theorem-authority instance of one general schema:
`NoAmbientCorrespondence = NoAmbientProductionAuthority ∩ NoAmbientTheoremAuthority ∩
NoAmbientEpistemicAuthority`. `Standing(A) ∧ AdmittedCorrespondence(κ : A → B) ∧
Preserves_κ(I) ⇒ TransferableStanding_I(B)` — standing never crosses an edge without an
admitted, structure-preserving correspondence, regardless of which of the three authorities
the edge would transfer. mfact owns the theorem-authority instance (`Definition → Theorem →
AssumptionClosure → FormalStanding → ClaimCeiling`); production authority
(`Mechanism → ProductionReachability → Consequence → Receipt → Replay`) is a different
project's chain and is out of scope here — hence `Praxis ⊥_epistemic mfact`, the formal
reading of the existing rule below: never touch `~/praxis`. Do not import, cite as evidence,
or infer standing from Praxis artifacts inside this repo; the orthogonality is mechanical,
not a courtesy.

- **Theorem cards before prose.** Every claim derived from a classical result records: Object
  (exact MFW type) / Imported theorem (name, source) / Source hypotheses (all of them) /
  Correspondence map / Preserved structure / Conclusion / Standing (`PROVEN`,
  `PROVEN_CONDITIONALLY`, `IMPORTED`, `CONJECTURAL`, `BLOCKED_ON_CORRESPONDENCE`). Prose may not
  render the claim until the card's hypotheses are instantiated for the MFW object.
- **Edge taxonomy.** Every concept-to-concept edge is typed: `DEFINITIONAL`, `PROVEN`,
  `IMPORTED`, `CORRESPONDENCE`, `CONJECTURAL`, `ANALOGY`, `MISSING`. An `ANALOGY` edge never
  supports theorem prose.
- **Operator identity checks.** Before writing "A is B" for two formal objects, check domain,
  codomain, composition law, order, and observable — or exhibit the relating morphism. Two
  operators that both tropicalize are not thereby one operator.
- **Predicate namespace separation.** `Math.Injective`, `Crypto.ComputationallyBinding`,
  `Runtime.Deterministic`, and `Evidence.ReplayEquivalent` are different dialects. Prose never
  silently translates between them (a hash fold is *binding*, never *injective*).
- **Specialize first.** Prove on the concrete admitted object (e.g. `L = P(Atoms)` with finitary
  closure), then generalize by explicit assumption minimization — never the reverse.
- **Trigger words.** "exactly", "is", "iff", "equivalent", "therefore", "for free", and
  "by construction" each create a proof obligation. They are the mathematical `unsafe`.
- **Verify against the live environment.** Claims about library support (e.g. "Mathlib ships X")
  are checked against the pinned checkout in the repo, never quoted from memory or from a
  reviewer transcript.

If you cannot hand over the artifact, the rate function, or the chart to be independently compiled and verified, you have not done the work.
