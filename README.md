# XTXAI — Explainable Econometrics and Machine Learning for Stata

**Status: pre-SSC candidate for review, not submitted or approved.**

XTXAI combines multiple econometric linear-index explanations with machine-learning explanation engines and panel-reference interventional Shapley (PSSA). The reference-game computations do not infer causality or prove methodological novelty.

## Installation for local testing

Put `xtxai.ado`, `xtxai.sthlp`, `xtxaiml_engine.py`, and `xtxaiml_pssa_engine.py` in the directory already included in Stata's `adopath` (e.g. user's XTXAI_PROJECT folder). Run `discard`, `which xtxai`, and `help xtxai`. Configure Stata's Python integration and install requirements from `requirements-ml.txt` in that **same Python environment**.

## Verified examples

```stata
webuse grunfeld, clear
xtset company year
regress invest mvalue kstock
xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(unit) prefix(pu) replace
xtxai invest mvalue kstock, model(xgboost) explain(pssa) holdout(1950) id(company) background(pooled) prefix(xp) replace
xtxai invest mvalue kstock, model(ebm) explain(pssa) holdout(1950) id(company) background(unit) prefix(xe) replace
```

User-reported Stata tests on 3 November 2026 show PSSA linear OLS/FE pooled/unit/observed-factor and ML pooled XGBoost, unit XGBoost, and unit EBM additive consistency. Exact additive identity does not independently prove accuracy, valid causal attribution, or generalisation.

## Scope and caveats

- XGBoost's existing Tree SHAP is separate from the empirical PSSA coalition game.
- EBM's term scores are not automatically SHAP.
- ML PSSA supports up to five numeric predictor variables and pooled/unit backgrounds. The ML factor background is **not** implemented.
- Panel factor background in the *linear* mode uses a **measured** factor and in-sample projection, not latent factor recovery.
- xtpmg dynamic now reads variable-length short-run terms from actual `e(coef_i)` and checks the stored ECT against its independently reconstructed long-run expression. Successful Stata examples: ARDL(1,1,1), (2,1,1), (2,2,1), (3,2,1,2), and an unbalanced ARDL(2,2,1,1). This is not evidence that every arbitrary specification works. The PMG terms are additive ECM contributions, not Shapley values.
- xtdcce2 CS-ARDL `explain(partial)` is strictly guarded to a specific two-regressor Grunfeld ARDL(1,1,1) e(lr) contract, requiring numeric panel IDs 1..G; it explains five observed dynamic regressor contributions, **not** the full CS-ARDL fitted value. `predaudit` and `projection` compare estimator-defined `predict, xb` and `predict, xb2`; their difference is not an identified common factor or structural contribution. Cross-sectional averages, partialled controls, and heterogeneous constants are not decomposed.
- Several other estimator routes remain partial or experimental. Consult help and exact command warnings before use.
- Monte Carlo experiments compare reference choices against synthetic oracle values, not an estimated-XTXAI supremacy claim.

## SSC readiness

Do not send the current candidate to Kit Baum yet. Pending: clean installation test **of this combined package**; resolve unverified/prototype command exposure and verify dependencies/licenses; reproduce all claimed core functions from a fresh Stata session; finalize package metadata and any needed SSC ancillary files. This package is a staged candidate to avoid losing the verified integrated code.

## PMG evidence and guard

StataNow 19 tests reported 4 November 2026: generalized PMG ARDL orders (1,1,1), (2,1,1), (2,2,1), (3,2,1,2), and unbalanced (2,2,1,1) passed the guarded additivity checks. The stored ECT reconstructed to approximately 3.4e-13 in one model, and a deliberately corrupted ECT was rejected with Stata error 459. Cross-sectional dependence was significant in the test data, so model assumptions and interpretation must be evaluated independently of software correctness.

## Final release QA

Run `FINAL_RELEASE_QA.do` from the documented Windows project directory after extracting this ZIP. This is a release-candidate regression test; clean-environment tests and licensing are still outstanding. See `RELEASE_STATUS.md` and `SSC_RELEASE_CHECKLIST.md`.

## Release discipline

This directory is a **local GitHub staging candidate only**. Do not publish, tag as stable, upload to SSC, or claim full CS-ARDL attribution until release gates pass. Public release requires verification of packaging and permissions, a clean-environment install, and full contract tests for routes advertised as supported. A final license must be selected by the owner; no license is granted by this staging archive.
