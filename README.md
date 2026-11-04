# XTXAI
### Explainable Econometrics and Machine Learning for Stata

**Version:** 0.44.1 — Release Candidate  
**Author:** Dr. Zehra Yalnız  
**License:** MIT  
**Software:** Stata 17 or later, with optional Python integration  
**Status:** Pre-SSC Release Candidate — Not Yet Submitted

---

## 1. Overview

XTXAI is a modular explainability framework for econometric and machine learning models implemented in Stata.

The package aims to provide a unified environment for interpreting model predictions, decomposing estimated contributions, and examining heterogeneity in panel data.

XTXAI integrates conventional econometric decomposition methods with machine learning explainability techniques, including Shapley-based approaches.

A central component is **Panel-Structured Shapley Attribution (PSSA)**, an implementation of interventional Shapley attribution using alternative panel reference structures.

The current software is a release candidate. Some components are fully validated for specific model configurations, while others remain experimental.

## 2. Main Features

### 2.1 Econometric Explainability

XTXAI provides model-specific explanation and diagnostic capabilities for several econometric estimators.

These include:

- Ordinary Least Squares (OLS)
- Fixed Effects (FE) and Random Effects (RE)
- Driscoll–Kraay panel regression
- Pooled Mean Group (PMG) estimation
- Selected ARDL and nonlinear ARDL specifications
- Selected Common Correlated Effects estimators
- Selected Mean Group and Augmented Mean Group models
- Selected dynamic panel estimators
- Selected robust regression approaches

**Important:** Support varies across estimators. Some adapters provide full decomposition of a defined prediction index; others provide partial contributions or diagnostic information only.

These capabilities should not be interpreted as universal support for every specification within each estimator family.

### 2.2 Machine Learning Explainability

The machine learning components include:

- XGBoost
- Explainable Boosting Machine (EBM)
- Random Forest
- Existing Tree SHAP functionality
- Model-specific additive explanations
- Panel-reference interventional Shapley explanations

XTXAI uses Python integration for selected machine learning operations.

### 2.3 Panel-Structured Shapley Attribution (PSSA)

PSSA provides Shapley explanations relative to explicitly defined reference structures.

The implemented reference approaches include:

| Reference structure | Linear models | XGBoost | EBM |
|---|---|---|---|
| Pooled reference | Supported | Supported | Supported |
| Unit-specific reference | Supported | Supported | Supported |
| Observed-factor-adjusted reference | Supported | Not implemented | Not implemented |

The observed-factor reference in linear models relies on a measured factor and an in-sample projection.

It does not identify unobserved common factors.

For machine learning, PSSA currently supports up to five numeric predictor variables.

The machine learning implementation uses a finite empirical training reference distribution and exact coalition evaluation for the supported feature count.

**PSSA is not a causal attribution method.**

The mathematical efficiency property of Shapley values does not independently establish superior predictive performance, methodological novelty, or statistical validity.

## 3. PMG Dynamic Explanation

XTXAI includes a generalized dynamic explanation adapter for models estimated using `xtpmg`.

The adapter reads variable-length short-run terms from stored estimation results rather than assuming a fixed ARDL(1,1,1) specification.

Successfully tested structures include:

| Model | Validation |
|---|---|
| ARDL(1,1,1) | Passed |
| ARDL(2,1,1) | Passed |
| ARDL(2,2,1) | Passed |
| ARDL(3,2,1,2) | Passed |
| ARDL(2,2,1,1), unbalanced panel | Passed |

The adapter calculates contributions associated with the estimated short-run dynamics and error-correction term.

It also independently reconstructs the stored error-correction term for supported specifications.

If a discrepancy exceeds the validation tolerance, the procedure stops rather than returning potentially misleading results.

PMG contributions are **additive econometric decompositions, not Shapley values**.

Successful tests of these specifications do not establish compatibility with every possible ARDL configuration.

## 4. CS-ARDL Scope and Limitations

The current CS-ARDL adapter provides guarded partial decomposition for selected models estimated using `xtdcce2`.

The validated partial explanation includes observed dynamic regressor contributions.

The implementation does **not** currently provide complete attribution of:

- Cross-sectional averages
- Lagged cross-sectional averages
- Partialled-out controls
- Heterogeneous intercepts
- Unobserved common factors

The validated partial adapter is restricted to a specific two-regressor CS-ARDL configuration and requires compatible panel identifier–coefficient mappings.

Unsupported mappings are rejected.

Prediction diagnostics involving `xb` and `xb2` should not be interpreted as structural common-factor attribution.

See `CSARDL_SCOPE.md` for details.

## 5. Installation

### Requirements

- Stata 17 or later
- Python 3.11 or another verified compatible Python environment
- Required Python libraries for machine learning components
- Additional Stata packages for estimator-specific adapters

Python dependencies are listed in:

`requirements-ml.txt`

### Local installation

Place the following files in a directory included in Stata's `adopath`:

```text
xtxai.ado
xtxai.sthlp
xtxaiml_engine.py
xtxaiml_pssa_engine.py
```

Then run:

```stata
discard
which xtxai
help xtxai
python query
```

Ensure the Python environment configured in Stata contains the required dependencies.

Additional installation instructions are provided in `INSTALL.md`.

## 6. Examples

### Example 1. Linear PSSA

```stata
webuse grunfeld, clear
xtset company year
regress invest mvalue kstock

xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(unit) prefix(pu) replace
```

### Example 2. XGBoost with PSSA

```stata
webuse grunfeld, clear
xtset company year

xtxai invest mvalue kstock, model(xgboost) explain(pssa) holdout(1950) id(company) background(pooled) prefix(xp) replace
```

### Example 3. EBM with PSSA

```stata
webuse grunfeld, clear
xtset company year

xtxai invest mvalue kstock, model(ebm) explain(pssa) holdout(1950) id(company) background(unit) prefix(xe) replace
```

### Example 4. PMG Dynamic Decomposition

```stata
webuse grunfeld, clear
xtset company year

xtpmg D.invest L.D.invest D.mvalue L.D.mvalue D.kstock, lr(L.invest mvalue kstock) ec(pmg_ec) replace pmg

xtxai, model(pmg) explain(dynamic) prefix(pmgx) replace
```

The PMG example requires the user-written `xtpmg` estimator.

## 7. Validation

XTXAI has undergone multiple functional and numerical checks using StataNow 19 and Python 3.11.

These include:

- Linear PSSA additive consistency
- XGBoost and EBM PSSA additive consistency
- PMG dynamic decomposition across different lag structures
- Independent reconstruction of PMG error-correction terms
- Detection and rejection of corrupted error-correction terms
- Partial CS-ARDL decomposition checks
- Detection of incompatible panel identifier mappings
- Isolated-folder installation and execution

An isolated-folder test was successfully performed on 4 November 2026.

However, this test used the same computer and previously installed dependencies. Installation on a completely clean machine has not yet been independently verified.

The validation suite does not establish that every experimental model adapter is ready for unrestricted use.

## 8. Methodological Considerations

XTXAI distinguishes between three types of outputs:

**Prediction explanations:** Contributions that reconstruct a specifically defined model prediction relative to a reference structure.

**Econometric decompositions:** Contributions derived from estimated parameters and model equations.

**Diagnostic outputs:** Information about coefficients, prediction contracts, and estimator-specific restrictions.

These outputs are not interchangeable.

In particular:

- Additive decomposition does not imply causality.
- PSSA references define different explanation games.
- Prediction accuracy and explanation validity require separate assessment.
- Cross-sectional dependence and parameter heterogeneity require appropriate econometric treatment.
- Theoretical novelty of PSSA relative to existing conditional, grouped, and interventional Shapley approaches requires independent evaluation.

## 9. Repository Structure

```text
xtxai/
│
├── xtxai.ado
├── xtxai.sthlp
├── xtxaiml_engine.py
├── xtxaiml_pssa_engine.py
├── requirements-ml.txt
│
├── README.md
├── INSTALL.md
├── LICENSE
├── CSARDL_SCOPE.md
├── PMG_GENERAL_README.md
├── PMG_ECT_GUARD_NOTES.md
├── RELEASE_STATUS.md
├── QA_NOTES.md
├── SSC_RELEASE_CHECKLIST.md
│
├── FINAL_INTEGRATED_CHECK.do
├── FINAL_RELEASE_QA.do
├── TEST_PMG_GENERAL.do
├── TEST_PMG_ECT_GUARD.do
│
└── tests/
    └── Validation scripts
```

## 10. Release Status

**Current status: Pre-SSC Release Candidate**

The repository contains the integrated development candidate and available validation materials.

Before public release, the remaining requirements include:

- Final review of third-party license obligations
- Review of experimental commands and supported configurations
- Verification of installation and package metadata for distribution
- Final inspection of repository contents
- Independent clean-environment installation testing

XTXAI has not yet been submitted to or approved by the Statistical Software Components (SSC) archive.

The repository should not currently be cited as an SSC-approved package.

## 11. License

Copyright © 2026 Zehra Yalnız.

XTXAI is distributed under the terms of the MIT License, subject to the ownership and licensing rights of its original source code.

See the `LICENSE` file for the complete terms.

Third-party libraries and external Stata packages retain their respective licenses.

## 12. Citation

**Software author:** Zehra Yalnız

**Software:** XTXAI — Explainable Econometrics and Machine Learning for Stata

**Version:** 0.44.1 (release candidate)

**Year:** 2026

A formal SSC citation and publication reference will be added if and when the relevant submissions are accepted.

---

**XTXAI is an ongoing research software project combining econometric model diagnostics, machine learning explanations, and panel-reference Shapley attribution within Stata.**
