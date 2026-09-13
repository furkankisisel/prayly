import json
from pathlib import Path

root = Path(__file__).resolve().parents[1]
ln = root / 'lib' / 'l10n'

tr_file = ln / 'app_tr.arb'
en_file = ln / 'app_en.arb'
locales = ['app_de.arb','app_es.arb','app_fr.arb','app_ar.arb','app_zh.arb']

with tr_file.open('r', encoding='utf-8') as f:
    tr = json.load(f)
with en_file.open('r', encoding='utf-8') as f:
    en = json.load(f)

added = {}
for loc in locales:
    p = ln / loc
    if not p.exists():
        print(f"Skipping missing file {p}")
        continue
    with p.open('r', encoding='utf-8') as f:
        target = json.load(f)

    changed = False
    for key, val in tr.items():
        if key.startswith('@@'):
            # section comments: copy if missing
            if key not in target:
                target[key] = val
                changed = True
        elif key.startswith('@'):
            # metadata entries (placeholders) handled when main key missing
            if key not in target:
                target[key] = val
                changed = True
        else:
            if key not in target:
                # choose translation from English if present, else Turkish
                translation = en.get(key, val)
                target[key] = translation
                # copy metadata for this key if present in tr and missing in target
                meta_key = '@' + key
                if meta_key in tr and meta_key not in target:
                    target[meta_key] = tr[meta_key]
                changed = True
    if changed:
        # write back file
        with p.open('w', encoding='utf-8') as f:
            json.dump(target, f, ensure_ascii=False, indent=4)
        added[loc] = True
    else:
        added[loc] = False

print('Done. Updated files:')
for k,v in added.items():
    print(f"{k}: {'updated' if v else 'no changes'}")
