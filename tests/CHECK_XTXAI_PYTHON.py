import importlib
import sys
modules = ('numpy', 'pandas', 'sklearn', 'xgboost', 'shap', 'interpret')
missing = []
for module in modules:
    try:
        obj = importlib.import_module(module)
        print(f'{module}: OK ({getattr(obj, "__version__", "version not exposed")})')
    except Exception as exc:
        missing.append((module, str(exc)))
for module, error in missing:
    print(f'{module}: FAILED {error}')
if missing:
    raise RuntimeError('XTXAI Python dependencies are missing or failing to import')
print('PASS: XTXAI Python package imports')
