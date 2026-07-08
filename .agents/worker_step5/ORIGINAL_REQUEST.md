## 2026-07-07T18:41:58-07:00
Implement Step 5: Ticket 020 praxis-graphlaw and rslab Paper Prose:

1. Replace the placeholder sections in `paper/main.tex` (lines 609 to 620) with the provided detailed prose for Section 9 (praxis-graphlaw) and Section 10 (rslab).
2. Verify that `just prose-lint` and `just paper-check` pass successfully with no errors or undefined reference warnings.
3. Verify that `just regen-check` passes successfully.
4. Run `just release` and ensure it succeeds completely, outputting `release/FINAL_STATUS.md`.
5. Run `just arxiv-package` and verify that the output tarball `paper/arxiv-submission.tar.gz` contains the four newly wired paper fragments under the relative path `rslab/paper_fragments/...`. You can list the contents of the tarball with `tar -tf paper/arxiv-submission.tar.gz`.
6. Commit the changes using `just commit "Ticket 020: praxis-graphlaw and rslab Paper Prose"`.
