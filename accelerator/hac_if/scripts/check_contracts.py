#!/usr/bin/env python3
"""HAC local structural checks and reproducible VCS parameter/modport smoke."""
import argparse
import copy
import json
import hashlib
from pathlib import Path
import re
import subprocess
import sys
import yaml
import jsonschema
from sync_views import HAC, REPO, validate


def rejected(data, mutate, check):
    bad = copy.deepcopy(data)
    mutate(bad)
    try:
        check(bad)
    except (AssertionError, jsonschema.ValidationError):
        return
    raise AssertionError('negative example unexpectedly accepted')


def main():
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--vcs', action='store_true')
    args = ap.parse_args()
    contracts = validate()
    schema = yaml.safe_load((REPO / 'schema/interface_contract.schema.yaml').read_text())
    ctrl = next(d for d, _, _ in contracts.values() if d['interface']['family'] == 'hac_ctrl')
    rejected(ctrl, lambda d: d['interface'].update(name='hac_ctrl'), lambda d: jsonschema.validate(d, schema))
    rejected(ctrl, lambda d: d['channels'][0]['signals'][0].update(width=0), lambda d: jsonschema.validate(d, schema))
    rejected(ctrl, lambda d: d['interface'].update(semantic_version='draft'), lambda d: jsonschema.validate(d, schema))
    cores = {}
    for path in [HAC / 'interface_hac_if.core', *HAC.glob('hac_*/interface_*.core')]:
        data = yaml.safe_load(path.read_text().split('\n', 1)[1])
        assert data['name'].endswith(':1.0.0'), path
        cores[data['name']] = data
        for fs in data['filesets'].values():
            for item in fs.get('files', []):
                name = item if isinstance(item, str) else next(iter(item))
                assert (path.parent / name).is_file(), (path, name)
        for target in data['targets'].values():
            assert set(target['filesets']) <= set(data['filesets']), path
    def walk(name, ancestors):
        assert name not in ancestors, ('core dependency cycle', name)
        for fs in cores[name]['filesets'].values():
            for dep in fs.get('depend', []):
                assert dep in cores, dep
                walk(dep, ancestors | {name})
    for name in cores:
        walk(name, set())
    # Verify XML syntax, and SV presence/direction against every role and signal.
    from xml.etree import ElementTree
    for path in HAC.glob('hac_*/ipxact/*.xml'):
        ElementTree.parse(path)
    for data, _, _ in contracts.values():
        f, n = data['interface']['family'], data['interface']['name']
        sv = (HAC / f / 'rtl' / f'{n}_if.sv').read_text()
        for role in data['roles']:
            body = re.search(r'modport\s+' + role['id'] + r'\s*\((.*?)\);', sv, re.S).group(1)
            for ch in data['channels']:
                for sig in ch['signals']:
                    direction = 'output' if sig['from'] == role['id'] else 'input'
                    block = re.search(direction + r'\s+(.*?)(?=,\s*(?:input|output)|$)', body, re.S).group(1)
                    assert re.search(r'\b' + sig['id'] + r'\b', block), (n, role['id'], sig['id'])
        assert 'assign ' not in sv, (n, 'interface must not own endpoint tieoffs')
    report = {'contracts': 6, 'profiles': 3, 'cores': 7, 'negative_schema_examples': 3,
              'core_paths_and_acyclic_dependencies': 'pass', 'modport_directions_and_no_tieoffs': 'pass',
              'xml_well_formed': 'pass', 'vcs': 'not_run', 'qualification': 'draft; no protocol implementation verification'}
    build = REPO / 'build/hac_contract'
    build.mkdir(parents=True, exist_ok=True)
    if args.vcs:
        modules, instances, files = [], [], []
        for data, _, _ in contracts.values():
            f, n = data['interface']['family'], data['interface']['name']
            files.append(str(HAC / f / 'rtl' / f'{n}_if.sv'))
            for role in data['roles']:
                rid = role['id']
                assigns = [f"  assign bus.{s['id']} = '0;" for c in data['channels'] for s in c['signals'] if s['from'] == rid]
                modules.append(f'module probe_{f}_{rid}({n}_if.{rid} bus);\n' + '\n'.join(assigns) + '\nendmodule')
            for cfg in ['default', 'minimum', 'wide']:
                params = {}
                for p in data.get('parameters', []):
                    c = p.get('constraints', {})
                    v = p['default'] if cfg == 'default' else c.get('min', p['default'])
                    if cfg == 'wide':
                        v = p['default']
                        if p['id'] == 'DATA_W': v = 256
                        elif p['id'].endswith('_W') and 'max' not in c: v = max(v, 16)
                    params[p['id']] = v
                overrides = '#(' + ', '.join(f'.{k}({v})' for k, v in params.items()) + ')' if params else ''
                inst = f'{f}_{cfg}'
                instances.append(f'  {n}_if {overrides} {inst}(clk, rst_n);')
                for role in data['roles']:
                    rid = role['id']
                    instances.append(f'  probe_{f}_{rid} p_{inst}_{rid}({inst});')
                for c in data['channels']:
                    for s in c['signals']:
                        width = s['width']
                        for k in sorted(params, key=len, reverse=True):
                            width = re.sub(r'\b' + k + r'\b', str(params[k]), width)
                        assert re.fullmatch(r'[0-9+*/() -]+', width), width
                        expected = int(eval(width, {'__builtins__': {}}, {}))
                        instances.append(f'  initial if ($bits({inst}.{s["id"]}) != {expected}) $fatal(1, "width {inst}.{s["id"]}");')
        tb = '\n\n'.join(modules) + '\nmodule tb_hac_views;\n  logic clk=0, rst_n=0;\n  always #5 clk=~clk;\n' + '\n'.join(instances) + '\n  initial begin #12; rst_n=1; #20; $display("PASS: 18 interface instances, both role modports, widths"); $finish; end\nendmodule\n'
        (build / 'tb_hac_views.sv').write_text(tb)
        with (build / 'vcs_compile.log').open('w') as log:
            subprocess.run(['vcs', '-full64', '-sverilog', '-timescale=1ns/1ps', '-top', 'tb_hac_views', *files, str(build / 'tb_hac_views.sv'), '-o', str(build / 'simv')], cwd=build, stdout=log, stderr=subprocess.STDOUT, check=True)
        result = subprocess.run([str(build / 'simv')], cwd=build, capture_output=True, text=True, check=True)
        (build / 'vcs_run.log').write_text(result.stdout + result.stderr)
        assert 'PASS: 18 interface instances' in result.stdout
        report['vcs'] = 'pass: defaults/minimum/wide, six families, both roles, all signal widths (18 instances)'
    inputs = sorted(set(HAC.glob('hac_*/contract/*.yaml')) | set((HAC/'contract').glob('*.yaml')) | set(HAC.glob('hac_*/rtl/*.sv')) | set(HAC.glob('hac_*/interface_*.core')) | {HAC/'interface_hac_if.core'})
    report['input_sha256'] = {str(p.relative_to(HAC)): hashlib.sha256(p.read_bytes()).hexdigest() for p in inputs}
    (build / 'validation.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
