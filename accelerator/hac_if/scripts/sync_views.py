#!/usr/bin/env python3
"""Validate HAC contracts; publish unmodified tool-generated views, or check drift."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import yaml
import jsonschema

HAC = Path(__file__).resolve().parents[1]
REPO = HAC.parents[1]


def validate():
    contracts = {}
    for path in sorted(HAC.glob('hac_*/contract/*.interface.yaml')):
        data = yaml.safe_load(path.read_text())
        jsonschema.validate(data, yaml.safe_load((REPO / 'schema/interface_contract.schema.yaml').read_text()))
        roles = {r['id'] for r in data['roles']}
        caps = {c['id'] for c in data.get('capabilities', [])}
        params = {p['id'] for p in data.get('parameters', [])}
        signals = [s for c in data['channels'] for s in c['signals']]
        assert len({s['id'] for s in signals}) == len(signals), path
        for s in signals:
            assert s['from'] in roles and s['to'] in roles and s['from'] != s['to'], (path, s)
            if not s['required']:
                assert s['capability'] in caps and 'default_tieoff' in s, (path, s)
        for p in data.get('parameters', []):
            rule = p.get('constraints', {})
            assert p['default'] >= rule.get('min', p['default']), (path, p)
            assert p['default'] <= rule.get('max', p['default']), (path, p)
            assert p['default'] % rule.get('multiple_of', 1) == 0, (path, p)
        contracts[data['interface']['id']] = (data, caps, params)
    assert len(contracts) == 6
    for path in sorted((HAC / 'contract').glob('*.profile.yaml')):
        data = yaml.safe_load(path.read_text())
        jsonschema.validate(data, yaml.safe_load((REPO / 'schema/interface_profile.schema.yaml').read_text()))
        profile = data['profile']
        contract, caps, params = contracts[profile['interface']]
        assert profile['version'] == contract['interface']['semantic_version'], path
        assert set(profile['capabilities']) <= caps, path
        assert set(profile.get('parameter_constraints', {})) <= params, path
    for path in HAC.glob('hac_*/contract/*.binding.yaml'):
        data = yaml.safe_load(path.read_text())
        jsonschema.validate(data, yaml.safe_load((REPO / 'schema/binding.schema.yaml').read_text()))
        binding = data['binding']
        matches = [d for d, _, _ in contracts.values() if binding['interface'] == f"aixsilicon:interface:{d['interface']['family']}:{d['interface']['semantic_version']}"]
        assert len(matches) == 1, path
        signals = {s['id']: s for c in matches[0]['channels'] for s in c['signals']}
        for item in binding.get('signal_map', []):
            sig = signals[item['contract_signal']]
            if 'role' in item and 'direction' in item:
                assert item['role'] in {r['id'] for r in matches[0]['roles']}, path
                assert item['direction'] == ('output' if sig['from'] == item['role'] else 'input'), path
    return contracts


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--check', action='store_true', help='regenerate into temporary directory and compare every published byte')
    ap.add_argument('--tool', type=Path, default=Path.home() / '.codex/skills/hwif-development-suite/scripts/hwif_tool.py')
    args = ap.parse_args()
    contracts = validate()
    with tempfile.TemporaryDirectory(prefix='hac-views-') as temp:
        out = Path(temp) / 'generated'
        subprocess.run([sys.executable, str(args.tool), 'generate', '--root', str(HAC), '--out', str(out), '--docs', '--ipxact'], check=True)
        pairs = []
        for data, _, _ in contracts.values():
            family, name = data['interface']['family'], data['interface']['name']
            for src in sorted((out / family).glob('*.sv')):
                pairs.append((src, HAC / family / 'rtl' / src.name))
            for src in sorted((out / 'docs' / family).glob('*.md')):
                pairs.append((src, HAC / family / 'doc' / src.name))
            for src in sorted((out / 'ipxact' / family).glob('*.xml')):
                pairs.append((src, HAC / family / 'ipxact' / src.name))
        hashes = {}
        for src, dst in pairs:
            blob = src.read_bytes()
            if args.check:
                if not dst.exists() or dst.read_bytes() != blob:
                    raise SystemExit(f'DRIFT: {dst}')
            else:
                dst.parent.mkdir(parents=True, exist_ok=True)
                dst.write_bytes(blob)
            hashes[str(dst.relative_to(HAC))] = hashlib.sha256(blob).hexdigest()
        manifest = (json.dumps(hashes, sort_keys=True, indent=2) + '\n').encode()
        target = HAC / 'views.sha256.json'
        if args.check:
            assert target.read_bytes() == manifest, 'manifest drift'
        else:
            target.write_bytes(manifest)
    print(f'PASS: six contracts, three profiles, {len(pairs)} generated/published views; mode={"check" if args.check else "sync"}')


if __name__ == '__main__':
    main()
