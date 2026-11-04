# XTXAI local release-candidate installation (Windows / StataNow 19)

This distribution is a **review candidate**, not an SSC-approved or stable package. Do not upload publicly until licensing and release gates are cleared.

1. Save the ZIP as `C:\Users\DELL\Downloads\XTXAI_RELEASE_CANDIDATE_2026-11-04.zip`.
2. In Stata, extract with the command below; the `XTXAI_PROJECT` directory is already on your `adopath`:

```stata
shell powershell -NoProfile -Command "Expand-Archive -LiteralPath 'C:\Users\DELL\Downloads\XTXAI_RELEASE_CANDIDATE_2026-11-04.zip' -DestinationPath 'C:\Users\DELL\Downloads\XTXAI_PROJECT' -Force"
discard
which xtxai
findfile xtxai.sthlp
python query
do "C:\Users\DELL\Downloads\XTXAI_PROJECT\FINAL_RELEASE_QA.do"
```

The final QA does not run Monte Carlo. It replays the prior six-block integrated smoke check and PMG/ECT/CS-ARDL regression guards. All must pass on **this same package**. Outputs are not known until Stata is run.

Python dependencies are documented in `requirements-ml.txt`. Use the Python executable printed by `python query`. Stata's `xtpmg`, `xtscc` and `xtdcce2` commands are external Stata dependencies and must already be installed. This is not a clean-machine install or full SSC `net install` test.

There is deliberately **no LICENSE file** yet: the project owner must select the license and confirm third-party license compatibility before GitHub/SSC release.
