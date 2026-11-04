# CS-ARDL scope audit — 2026-11-04

## Verified guarded mode

`xtdcce2 invest, lr(L.invest mvalue L.mvalue kstock L.kstock) lr_options(ardl) cr(invest mvalue kstock) cr_lags(1)` followed by `xtxai, model(csardl) explain(partial) id(company) replace` has user-reported Stata validation for Grunfeld (10 numeric IDs 1..10, N=180). The five output terms are L.invest, mvalue, kstock, L.mvalue and L.kstock multiplied by matched unit coefficients. The identity among the five terms is an **observed partial-index** identity, not a full fitted-value identity.

## Out of scope / not established

- General ARDL(p,q) order recognition for CS-ARDL.
- Arbitrary/nonconsecutive panel IDs; the present CS-ARDL adapter intentionally fails closed.
- Explicit attribution to cross-sectional averages or their lags.
- Reconstruction of partialled heterogeneous intercepts or latent factors.
- Full fitted value or causal interpretation from the partial term sum.

`explain(predaudit)` and `explain(projection)` use actual `xtdcce2` predict modes (`xb`, `xb2`) for diagnostics, **not** independent decomposition of missing terms. The projection identity `xb2 = xb + (xb2-xb)` is algebraically automatic and does not identify common factors.

## Distribution decision

Keep the existing guarded diagnostic functions as experimental and clearly separated from full explanation claims. Do not publish `csardl` as generally supported until independently validated across models and panel labels.
