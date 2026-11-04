* XTXAI SSC CANDIDATE - INTEGRATED SMOKE TEST (no Monte Carlo reruns)
* Uses exact tested commands; does not imply every adapter is SSC-ready.
version 17.0
set more off
local project "C:\Users\DELL\Downloads\XTXAI_PROJECT"
display as text "=== 1/6: core files and Stata/Python interface ==="
findfile xtxai.ado
findfile xtxai.sthlp
confirm file "`project'\xtxaiml_engine.py"
confirm file "`project'\xtxaiml_pssa_engine.py"
confirm file "`project'\tests\CHECK_XTXAI_PYTHON.py"
python query
python script "`project'\tests\CHECK_XTXAI_PYTHON.py"
display as result "PASS 1/6: software files and Python imports"
display as text "=== 2/6: PSSA linear pooled/unit/factor and FE ==="
do "`project'\tests\TEST_PSSA_INTEGRATION_ONLY.do"
display as result "PASS 2/6: PSSA linear"
display as text "=== 3/6: PSSA XGBoost and EBM ==="
do "`project'\tests\TEST_PSSA_ML_ONLY.do"
display as result "PASS 3/6: PSSA machine learning"
display as text "=== 4/6: xtscc pooled/FE smoke checks ==="
webuse grunfeld, clear
xtset company year
xtscc invest mvalue kstock, fe
xtxai, model(xtscc) explain(within) prefix(qfe) replace
assert r(N)==200
assert abs(qfe_xb-qfe_baseline-qfe_c1-qfe_c2)<1e-7 if !missing(qfe_xb)
xtscc invest mvalue kstock, pooled
xtxai, model(xtscc) explain(linear) prefix(qpo) replace
assert r(N)==200
assert abs(qpo_xb-qpo_baseline-qpo_c1-qpo_c2)<1e-7 if !missing(qpo_xb)
display as result "PASS 4/6: xtscc pooled and FE"
display as text "=== 5/6: PMG guarded dynamic decomposition ==="
webuse grunfeld, clear
xtset company year
xtpmg D.invest D.mvalue D.kstock, lr(L.invest mvalue kstock) ec(xtxai_ec_pmg) replace pmg
xtxai, model(pmg) explain(dynamic) replace
assert r(N)==190
assert r(G)==10
assert r(max_ect_gap)<1e-7
assert r(max_additive_gap)<1e-7
assert r(max_unitmean_residual)<1e-5
display as result "PASS 5/6: guarded PMG ARDL(1,1,1)"
display as text "=== 6/6: CS-ARDL observed-component reconstruction ==="
webuse grunfeld, clear
xtset company year
xtdcce2 invest, lr(L.invest mvalue L.mvalue kstock L.kstock) lr_options(ardl) cr(invest mvalue kstock) cr_lags(1)
xtxai, model(csardl) explain(partial) id(company) replace
assert r(N)==180
assert r(G)==10
assert abs(xai_csardl_partial_xb-xai_csardl_c_lagy-xai_csardl_c_mvalue-xai_csardl_c_kstock-xai_csardl_c_lagm-xai_csardl_c_lagk)<1e-8 if e(sample)
display as result "PASS 6/6: CS-ARDL observed dynamic partial index"
display as result "PASS: XTXAI integrated candidate smoke checks (limited validated scope)"
display as text "NOTE: this does not establish complete coverage of every planned estimator or SSC acceptance."
