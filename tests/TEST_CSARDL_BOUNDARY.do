* CS-ARDL release-boundary diagnostic: actual estimator contract and intentional rejection.
* No Monte Carlo; no line continuation.
version 17.0
set more off
webuse grunfeld, clear
xtset company year
xtdcce2 invest, lr(L.invest mvalue L.mvalue kstock L.kstock) lr_options(ardl) cr(invest mvalue kstock) cr_lags(1)
xtxai, model(csardl) explain(partial) id(company) prefix(csa) replace
assert r(N)==180
assert abs(csa_partial_xb-csa_c_lagy-csa_c_mvalue-csa_c_kstock-csa_c_lagm-csa_c_lagk)<1e-8 if e(sample)
display as result "PASS: CS-ARDL observed partial index (not full fitted model)"
* Explicitly demonstrate that non-consecutive IDs are NOT supported.
replace company=company*10+100
xtset company year
* Same stored estimate is intentionally not re-estimated, so the mismatch must be rejected.
capture noisily xtxai, model(csardl) explain(partial) id(company) prefix(csb) replace
local rejected = _rc
if `rejected'==0 {
    display as error "FAIL: changed panel IDs should have been rejected"
    exit 459
}
display as result "PASS: changed panel IDs correctly rejected; code=" `rejected'
