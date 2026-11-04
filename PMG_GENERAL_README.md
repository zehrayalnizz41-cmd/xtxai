# PMG generalized ECM review — not an SSC release

This integration replaces the hardcoded four-column `xtpmg` PMG ARDL(1,1,1) adapter with a loop driven by the observed `e(coef_i)` and `e(b_i)` fields. It handles arbitrary observed short-run time-series expressions, where the estimator exposes the coefficient columns in corresponding order. It maps rows using numeric panel IDs and checks that within-panel mean residuals are approximately zero.

**Important:** This proves neither general PMG long-run contract nor arbitrary `xtpmg` versions. The current implementation relies on the stored ECM variable from `ec()` and does not independently reconstruct or validate its normalization; first inspect the estimation output when changing LR syntax. Dynamic contributions are additive linear-index components, *not SHAP*. There is no true latent common-factor attribution.

Run `do "C:\Users\DELL\Downloads\XTXAI_PROJECT\TEST_PMG_GENERAL.do"`. The final two PMG specifications are new and need testing on the user's installed `xtpmg`. If the estimator itself does not converge on Grunfeld, treat that as a data/model issue, not automatically as an adapter failure. The prior packaged `FINAL_INTEGRATED_CHECK.do` uses the old `max_ect_gap` return; **do not use it unchanged** for v0.44.0; that return has not been generalized. Retest prior integrated scope before release.
