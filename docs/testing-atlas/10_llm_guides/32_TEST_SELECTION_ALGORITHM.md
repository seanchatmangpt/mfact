# Test Selection Algorithm for an LLM

Given a requested capability or theorem:

1. **Is the question "does Lean admit this proposition?"**
   Use KERNEL.
2. **Is the question about syntax, inferred types, instance search, goal shape?**
   Use ELAB.
3. **Is the error/refusal surface itself part of the contract?**
   Use DIAG.
4. **Is the universe finite and explicit?**
   Use FINITE.
5. **Are we searching for unexpected falsifiers?**
   Use PROPERTY.
6. **Is there an identity/associativity/idempotence/order law?**
   Use ALGEBRA.
7. **Can a lawful input transformation preserve an observable?**
   Use METAMORPHIC.
8. **Are we proving the fence is necessary?**
   Use COUNTERMODEL.
9. **Are we asking whether the suite notices deliberate semantic damage?**
   Use MUTATION.
10. **Are two controlled implementations supposed to realize one semantics?**
    Use DIFFERENTIAL.
11. **Is the purpose to detect representation/output drift?**
    Use SNAPSHOT.
12. **Did this bug escape previously?**
    Use REGRESSION.
13. **Do two or more theorem layers need to consume one shared witness?**
    Use COMPOSITION.
14. **Does one concrete business/control world need to cross multiple laws?**
    Use FLOW.
15. **Does the canonical TTL-controlled chain need validation?**
    Use E2E.
16. **Is there encode/decode behavior?**
    Use ROUNDTRIP.
17. **Does a controlled projection preserve structure?**
    Use CORRESPONDENCE.
18. **Must a state law survive each admitted transition?**
    Use INVARIANT.
19. **Does causal independence/order matter?**
    Use CONCURRENCY.
20. **Should execution-mode changes preserve semantic output?**
    Use REPRO.
21. **Is the package/build graph itself under test?**
    Use LAKE.
22. **Must illegal code fail to enter the build graph?**
    Use EXPECTED_FAIL.
23. **Is this a repository-wide constitution?**
    Use POLICY.
24. **Must an exact theorem/dependency manifest reconcile?**
    Use INVENTORY.
25. **How fast/large is it empirically?**
    Use PERF.
26. **Where does it break under scale/resource pressure?**
    Use STRESS.
27. **Can a mathematical cost counter be bounded?**
    Use COMPLEXITY.
28. **Does recursive/refinement work terminate?**
    Use TERMINATION.
29. **Does the claim say more than the theorem?**
    Use FAITHFULNESS.
30. **Are all crown edges actually connected?**
    Use STANDING_PATH.

Never choose "unit test" as a sufficient classification. Select the exact atlas type.
