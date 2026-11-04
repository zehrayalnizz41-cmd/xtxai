{smcl}
{* *! xtxai documentation release review 04nov2026}{...}
{vieweralsosee "xtreg" "help xtreg"}{...}
{title:Title}
{p 4 4 2}{cmd:xtxai} — Explainability tools for Stata estimation and machine-learning models (development candidate)

{title:Syntax}
{p 4 4 2}After {cmd:regress} or {cmd:xtreg, fe/re}: {cmd:xtxai, model(pssa) explain(linear) vars(}{it:varlist}{cmd:) id(}{it:panelvar}{cmd:) background(pooled|unit|factor) [factor(}{it:varname}{cmd:) prefix(}{it:name}{cmd:) replace]}
{p 4 4 2}Fitted ML model and reference-game Shapley: {cmd:xtxai} {it:depvar indepvars}{cmd:, model(xgboost|ebm) explain(pssa) holdout(}{it:time}{cmd:) id(}{it:panelvar}{cmd:) background(pooled|unit) [prefix(}{it:name}{cmd:) replace]}
{p 4 4 2}Plain ML: {cmd:xtxai} {it:depvar indepvars}{cmd:, model(xgboost|ebm|randomforest) holdout(}{it:time}{cmd:)}
{p 4 4 2}Previously estimated FE/RE: {cmd:xtxai, model(fe|re)}
{p 4 4 2}Previously estimated xtscc: {cmd:xtxai, model(xtscc) explain(within|linear) replace}
{p 4 4 2}Previously estimated xtmg MG: {cmd:xtxai, model(mg) explain(full) replace}
{p 4 4 2}Previously estimated xtmg AMG: {cmd:xtxai, model(amg) explain(full) replace} (guarded reconstruction; numerical precision qualification)
{p 4 4 2}Previously estimated xtpmg PMG: {cmd:xtxai, model(pmg) explain(dynamic) [prefix(}{it:name}{cmd:) replace]} (variable-length ECM short-run terms; guarded LR/ECT contract)
{p 4 4 2}Previously estimated xtdcce2 CS-ARDL: {cmd:xtxai, model(csardl) explain(partial) id(}{it:panelvar}{cmd:) [prefix(}{it:name}{cmd:) replace]} (five observed dynamic terms only; numerical panel IDs 1..G)

{title:Description}
{p 4 4 2}XTXAI currently combines several estimator-specific linear-index attribution tools with model-dependent ML explanations. All modes are observational and do not establish causal effects. Model-specific capabilities differ. Some legacy adapters are prototypes, not supported final-release claims.
{p 4 4 2}The {cmd:model(pssa)} linear mode computes interventional Shapley attribution for a fixed linear index relative to an explicitly selected reference. {cmd:background(pooled)} uses a sample-wide mean; {cmd:background(unit)} uses panel-specific means; {cmd:background(factor)} uses an observed factor and in-sample projection. This is not identification of a latent common factor. FE linear indices exclude fitted unit effects.
{p 4 4 2}For XGBoost and EBM, {cmd:explain(pssa)} evaluates an empirical interventional reference game using only training observations as background. It supports at most five regressors; references are {cmd:pooled} or {cmd:unit}. It is distinct from XGBoost Tree SHAP and from EBM term decompositions.

{title:Options}
{p 4 4 2}{cmd:model()} selects a model-specific adapter. {cmd:explain()} selects its explanation mode. {cmd:vars()} lists linear PSSA regressors. {cmd:id()} must match the xtset panel identifier for ML PSSA. {cmd:background()} selects the reference game. {cmd:factor()} is available only for linear PSSA with observed-factor references. {cmd:holdout()} defines the ML time threshold. {cmd:prefix()} specifies output variable names; {cmd:replace} permits replacing existing outputs.

{title:Examples}
{p 4 4 2}{cmd:. webuse grunfeld, clear}
{p 4 4 2}{cmd:. xtset company year}
{p 4 4 2}{cmd:. regress invest mvalue kstock}
{p 4 4 2}{cmd:. xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(unit) prefix(pu) replace}
{p 4 4 2}{cmd:. xtxai invest mvalue kstock, model(xgboost) explain(pssa) holdout(1950) id(company) background(pooled) prefix(xp) replace}
{p 4 4 2}{cmd:. xtxai invest mvalue kstock, model(ebm) explain(pssa) holdout(1950) id(company) background(unit) prefix(xe) replace}

{title:PMG dynamic decomposition: verified scope}
{p 4 4 2}The {cmd:model(pmg) explain(dynamic)} adapter reads short-run terms from the actual {cmd:xtpmg} stored coefficient names and matches panel IDs with the stored per-unit coefficient rows. It reconstructs the estimator's ECT from named long-run coefficients and tests agreement; unsupported normalization or ambiguous panel mapping is rejected rather than silently inferred.
{p 4 4 2}Reported StataNow 19 verification covers ARDL(1,1,1), ARDL(2,1,1), ARDL(2,2,1), ARDL(3,2,1,2), and an unbalanced ARDL(2,2,1,1). This is not a guarantee for every lag order, long-run convention, or xtpmg implementation. ECM term products are {it:not} Shapley values.

{title:CS-ARDL limited scope}
{p 4 4 2}The {cmd:xtdcce2} CS-ARDL {cmd:explain(partial)} route is a guarded five-term observed dynamic index for the tested two-regressor configuration. It does not reconstruct the full fitted value or attribute cross-sectional averages, partialled-out components, heterogeneous constants or latent factors. Non-1..G panel identifiers are rejected rather than mapped by assumption.

{title:Stored results}
{p 4 4 2}PSSA modes return {cmd:r(N)} and {cmd:r(maxgap)}. Other models have model-specific returns; run {cmd:return list} after estimation to inspect.

{title:Requirements and limitations}
{p 4 4 2}StataNow 19 was used in supplied user tests; Stata 17 or later for Python bridge and test scripts. ML execution requires a working Stata Python environment with numpy, pandas, xgboost, scikit-learn, shap and interpret. Older Stata-specific estimators such as xtpmg, xtdcce2, xtmg, and xtscc are separately installed where used.
{p 4 4 2}The current documentation is a development candidate. Panel-aware Shapley scientific novelty, out-of-sample robustness, all model families, and complete end-to-end reproducibility are not yet established.

{title:Author}
{p 4 4 2}Dr. Zehra Yalnız. Development-stage package; not yet submitted to SSC.
