# XTXAI — 04 Nov 2026 single-source release candidate

Main source: `xtxai.ado` 0.44.1 PMG ECT guard (unchanged from most recently verified candidate). No claimed SSC approval.

## Verified by user on StataNow 19 (prior runs)
- Linear PSSA pooled/unit/observed-factor, FE index; XGBoost pooled/unit and EBM unit PSSA additive checks.
- Pooled/FE `xtscc`; PMG ARDL(1,1,1); partial `xtdcce2` CS-ARDL integrated smoke check.
- PMG ARDL(2,1,1), (2,2,1), (3,2,1,2); unbalanced ARDL(2,2,1,1).
- PMG ECT reconstruction and deliberate corruption rejection (`r(459)`).
- CS-ARDL five-term partial index and deliberate wrong panel-ID rejection (`r(459)`).

## Gates remaining
- Run `FINAL_RELEASE_QA.do` against **this exact ZIP**.
- Check source/help/test agreement and all claims intended for public release.
- Test in a clean Stata environment (dependencies, Python path, source location; no legacy override).
- Choose the project license and audit third-party component terms.
- Create final SSC metadata/package definition as appropriate to the approved distribution plan.
- Only then publish the single GitHub repository and submit to Kit Baum.

**No blanket claim of full CS-ARDL decomposition or universal ARDL(p,q1,...,qk) PMG support.**
