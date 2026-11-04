version 17.0
set more off
webuse grunfeld, clear
xtset company year
bysort year: egen double shock=mean(mvalue)
regress invest mvalue kstock
xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(pooled) prefix(pp) replace
assert r(N)==200
assert r(maxgap)<1e-8
xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(unit) prefix(pu) replace
assert r(maxgap)<1e-8
xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(factor) factor(shock) prefix(pf) replace
assert r(maxgap)<1e-8
xtreg invest mvalue kstock, fe
xtxai, model(pssa) explain(linear) vars(mvalue kstock) id(company) background(unit) prefix(pfe) replace
assert r(maxgap)<1e-8
display as result "PASS: PSSA linear reference-game pooled/unit/observed-factor and FE index"
