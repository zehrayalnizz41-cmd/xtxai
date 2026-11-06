
Title

    xtxai -- Explainability tools for Stata estimation and machine-learning
    models (development candidate)

Syntax

    Linear PSSA after regress or xtreg, fe/re: xtxai, model(pssa)
    explain(linear) vars(varlist) id(panelvar) background(pooled|unit|factor)
    [factor(varname) prefix(name) replace]

    Fitted ML model and reference-game Shapley: xtxai depvar indepvars,
    model(xgboost|ebm) explain(pssa) holdout(time) id(panelvar)
    background(pooled|unit) [prefix(name) replace]

    Plain ML: xtxai depvar indepvars, model(xgboost|ebm|randomforest)
    holdout(time)

    xtxai, model(fe|re) -- previously estimated FE/RE. xtxai, model(xtscc)
    explain(within|linear) replace -- xtscc. xtxai, model(mg) explain(full)
    replace -- xtmg MG. xtxai, model(amg) explain(full) replace -- xtmg AMG;
    guarded reconstruction and numerical-precision qualification. xtxai,
    model(pmg) explain(dynamic) [prefix(name) replace] -- xtpmg PMG;
    variable-length ECM terms and guarded LR/ECT contract. xtxai,
    model(csardl) explain(partial) id(panelvar) [prefix(name) replace] --
    xtdcce2 CS-ARDL; five observed dynamic terms only; numerical panel IDs
    1..G.

Description

    XTXAI combines several estimator-specific linear-index attribution tools
    with model-dependent ML explanations. All modes are observational and do
    not establish causal effects.  Model-specific capabilities differ. Some
    legacy adapters are prototypes, not supported final-release claims.

    The model(pssa) linear mode computes interventional Shapley attribution
    for a fixed linear index relative to an explicitly selected reference.
    background(pooled) uses a sample-wide mean; background(unit) uses
    panel-specific means; and background(factor) uses an observed factor and
    in-sample projection.  This is not identification of a latent common
    factor. FE linear indices exclude fitted unit effects.

    For XGBoost and EBM, explain(pssa) evaluates an empirical interventional
    reference game using only training observations as background. It supports
    at most five regressors, with pooled or unit references. This differs from
    XGBoost Tree SHAP and EBM term decompositions.

Options

    model() selects a model adapter; explain() an explanation mode; vars()
    selects linear PSSA regressors; id() matches the xtset panel identifier
    for ML PSSA; background() selects a reference game; factor() is limited to
    linear PSSA with observed-factor references; holdout() sets an ML time
    threshold; prefix() names output variables; and replace allows overwriting
    existing outputs.

Examples

    . webuse grunfeld, clear . xtset company year . regress invest mvalue
    kstock . xtxai, model(pssa) explain(linear) vars(mvalue kstock)
    id(company) background(unit) prefix(pu) replace . xtxai invest mvalue
    kstock, model(xgboost) explain(pssa) holdout(1950) id(company)
    background(pooled) prefix(xp) replace . xtxai invest mvalue kstock,
    model(ebm) explain(pssa) holdout(1950) id(company) background(unit)
    prefix(xe) replace

PMG dynamic decomposition: verified scope

    The model(pmg) explain(dynamic) adapter reads short-run terms from actual
    xtpmg stored coefficient names and matches panel IDs with stored per-unit
    coefficient rows. It reconstructs the estimator's ECT from named long-run
    coefficients and tests agreement.  Unsupported normalization or ambiguous
    panel mapping is rejected rather than silently inferred.

    Reported StataNow 19 verification covers ARDL(1,1,1), ARDL(2,1,1),
    ARDL(2,2,1), ARDL(3,2,1,2), and unbalanced ARDL(2,2,1,1). This does not
    guarantee all lag orders, long-run conventions, or xtpmg implementations.
    ECM term products are not Shapley values.

CS-ARDL limited scope

    The xtdcce2 CS-ARDL explain(partial) route is a guarded five-term observed
    dynamic index for the tested two-regressor setup.  It does not reconstruct
    full fitted values or attribute cross-sectional averages, partialled-out
    components, heterogeneous constants, or latent factors. Non-1..G panel
    identifiers are rejected rather than guessed.

Stored results

    PSSA modes return r(N) and r(maxgap). Other models have model-specific
    returns. Run return list after estimation to inspect.

Requirements and limitations

    Supplied user tests used StataNow 19. Stata 17 or later is required for
    Python-bridge and test scripts. ML execution requires a working Stata
    Python environment with numpy, pandas, xgboost, scikit-learn, shap, and
    interpret. The commands xtpmg, xtdcce2, xtmg, and xtscc must be separately
    installed for their respective adapters.

    This is development-candidate documentation. Panel-aware Shapley
    scientific novelty, out-of-sample robustness, support for all model
    families, and end-to-end reproducibility are not yet established.  Confirm
    feature availability against the specific installed ado version.

Author

    Dr. Zehra Yalnız. XTXAI is listed on SSC. This help file documents a
    development candidate and is not proof that all listed features are
    included in the SSC-distributed ado.

