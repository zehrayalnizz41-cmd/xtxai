# XTXAI integrated final smoke test

Use `FINAL_INTEGRATED_CHECK.do` after extracting the archive to `C:\Users\DELL\Downloads\XTXAI_PROJECT`. It checks Python libraries, the previously successful PSSA linear and XGBoost/EBM test scripts, xtscc FE/pooled, PMG ARDL(1,1,1) and the guarded CS-ARDL observed-regressor decomposition. It does not re-run Monte Carlo experiments and cannot certify all claimed estimators.

No source modifications to xtxai.ado or Python engines in this bundle. This is **candidate QA**, not a final SSC release. A successful test is necessary but not sufficient for SSC readiness. Documentation must not imply that a linear index decomposition is causal/SHAP or that a partial adapter provides full predictions.

Python dependencies are imported using Stata's active Python installation, rather than a different shell interpreter. If failure occurs, inspect the first error and do not ignore it.
