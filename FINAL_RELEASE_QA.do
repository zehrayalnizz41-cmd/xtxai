* XTXAI release candidate 04 Nov 2026: integrated QA + regression guards.
* This is a non-Monte-Carlo smoke test, NOT a clean-environment certification.
version 17.0
set more off
local project "C:\Users\DELL\Downloads\XTXAI_PROJECT"
findfile xtxai.ado
findfile xtxai.sthlp
confirm file "`project'\xtxaiml_engine.py"
confirm file "`project'\xtxaiml_pssa_engine.py"
confirm file "`project'\tests\CHECK_XTXAI_PYTHON.py"
python query
python script "`project'\tests\CHECK_XTXAI_PYTHON.py"
display as result "PASS: Stata/Python core files and dependencies"
do "`project'\FINAL_INTEGRATED_CHECK.do"
do "`project'\TEST_PMG_GENERAL.do"
do "`project'\TEST_PMG_ECT_GUARD.do"
do "`project'\tests\TEST_CSARDL_BOUNDARY.do"
display as result "PASS: XTXAI RELEASE CANDIDATE QA - verified limited scope"
display as text "NOTE: existing packages plus current user's machine; not a fresh install or SSC acceptance."
