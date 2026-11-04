version 17.0
set more off
webuse grunfeld, clear
xtset company year
capture drop pmg_ec_guard
xtpmg D.invest L.D.invest D.mvalue L.D.mvalue D.kstock, lr(L.invest mvalue kstock) ec(pmg_ec_guard) replace pmg
xtxai, model(pmg) explain(dynamic) prefix(guardok) replace
assert r(K_short)==4
assert r(max_ect_gap)<1e-6
assert r(max_additive_gap)<1e-7
display as result "PASS: dynamic PMG and independently reconstructed ECT"
replace pmg_ec_guard=pmg_ec_guard+1 if e(sample)
capture noisily xtxai, model(pmg) explain(dynamic) prefix(guardbad) replace
local code=_rc
if `code'!=459 {
    display as error "FAIL: corrupted ECT should trigger r(459); observed r(`code')"
    exit 459
}
display as result "PASS: corrupted ECT rejected with r(459)"
