# XTXAI PMG guard review 0.44.1

Added strict independent ECT verification for a named `xtpmg` long-run equation.
For compatible models, the program reconstructs `L.y - theta_1*x1 - ...` from named `e(b)` long-run coefficients and compares it against the ECT variable created by xtpmg. Tolerance: 1e-6 absolute. If the coefficient layout, long-run variable notation, or normalization is unsupported, the guard **stops** rather than guessing. This is not a universal PMG normalization parser.

Existing safeguards check row names of `e(b_i)` against numeric panel IDs on `e(sample)` with exact one-to-one observational coverage, and check matrix dimensions.

Run `TEST_PMG_ECT_GUARD.do`: positive test plus a negative test that deliberately modifies the stored ECT to confirm the code refuses inconsistent decomposition. Original Grunfeld test does not establish every PMG configuration; retain older validated package until this passes.

This release is a **review candidate**, NOT an SSC package. Python files and other XTXAI adapters preserved from 0.44.0.
