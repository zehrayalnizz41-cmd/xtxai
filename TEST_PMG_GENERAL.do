version 17.0
set more off
webuse grunfeld, clear
xtset company year
capture drop xtxai_ec_pmg
xtpmg D.invest D.mvalue D.kstock, lr(L.invest mvalue kstock) ec(xtxai_ec_pmg) replace pmg
xtxai, model(pmg) explain(dynamic) prefix(g1) replace
assert r(N)==190
assert r(K_short)==2
assert r(max_additive_gap)<1e-7
assert r(max_unitmean_residual)<1e-5

display as text "=== PMG ARDL(2,1,1) ==="
capture drop xtxai_ec_pmg
xtpmg D.invest L.D.invest D.mvalue D.kstock, lr(L.invest mvalue kstock) ec(xtxai_ec_pmg) replace pmg
xtxai, model(pmg) explain(dynamic) prefix(g2) replace
assert r(K_short)==3
assert r(max_additive_gap)<1e-7
assert r(max_unitmean_residual)<1e-5

display as text "=== PMG ARDL(2,2,1) ==="
capture drop xtxai_ec_pmg
xtpmg D.invest L.D.invest D.mvalue L.D.mvalue D.kstock, lr(L.invest mvalue kstock) ec(xtxai_ec_pmg) replace pmg
xtxai, model(pmg) explain(dynamic) prefix(g3) replace
assert r(K_short)==4
assert r(max_additive_gap)<1e-7
assert r(max_unitmean_residual)<1e-5

display as result "PASS: PMG generalized ECM ARDL(1,1,1), (2,1,1), (2,2,1)"
