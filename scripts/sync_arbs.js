const fs = require('fs');
const path = require('path');
const root = path.resolve(__dirname, '..');
const ln = path.join(root, 'lib', 'l10n');
const trFile = path.join(ln, 'app_tr.arb');
const enFile = path.join(ln, 'app_en.arb');
const locales = ['app_de.arb', 'app_es.arb', 'app_fr.arb', 'app_ar.arb', 'app_zh.arb'];

function loadJson(p) {
    return JSON.parse(fs.readFileSync(p, 'utf8'));
}

const tr = loadJson(trFile);
const en = loadJson(enFile);

const report = {};
for (const loc of locales) {
    const p = path.join(ln, loc);
    if (!fs.existsSync(p)) {
        console.log(`Skipping missing file ${p}`);
        continue;
    }
    const target = loadJson(p);
    let changed = false;
    for (const [key, val] of Object.entries(tr)) {
        if (key.startsWith('@@')) {
            if (!(key in target)) {
                target[key] = val; changed = true;
            }
            continue;
        }
        if (key.startsWith('@')) {
            if (!(key in target)) {
                target[key] = val; changed = true;
            }
            continue;
        }
        if (!(key in target)) {
            const translation = (key in en) ? en[key] : val;
            target[key] = translation;
            const metaKey = '@' + key;
            if ((metaKey in tr) && !(metaKey in target)) target[metaKey] = tr[metaKey];
            changed = true;
        }
    }
    if (changed) {
        fs.writeFileSync(p, JSON.stringify(target, null, 4), 'utf8');
    }
    report[loc] = changed;
}
console.log('Done. Updated files:');
for (const k of Object.keys(report)) {
    console.log(`${k}: ${report[k] ? 'updated' : 'no changes'}`);
}
