version 17.0
set more off
webuse grunfeld, clear
xtset company year
xtxai invest mvalue kstock, model(xgboost) explain(pssa) holdout(1950) id(company) background(pooled) prefix(xp) replace
assert r(N)==200
assert r(maxgap)<1e-5
xtxai invest mvalue kstock, model(xgboost) explain(pssa) holdout(1950) id(company) background(unit) prefix(xu) replace
assert r(N)==200
assert r(maxgap)<1e-5
assert abs(xu_pred-xu_base-xu_c1-xu_c2)<1e-5 if !missing(xu_pred)
display as result "PASS: ML PSSA XGBoost pooled/unit exact reference-game additivity"
xtxai invest mvalue kstock, model(ebm) explain(pssa) holdout(1950) id(company) background(unit) prefix(xe) replace
assert r(maxgap)<1e-5
display as result "PASS: EBM PSSA unit reference-game additivity"
