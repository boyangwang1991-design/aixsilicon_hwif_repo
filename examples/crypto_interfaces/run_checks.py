#!/usr/bin/env python3
"""Check crypto HWIF artifacts and run FuseSoC/VCS connection smoke.

Only PyYAML, jsonschema, FuseSoC/Edalize and VCS are runtime dependencies.
No private generator/skill code is required to compile the delivered assets.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import subprocess
import sys
import yaml
from jsonschema import Draft202012Validator

ROOT=Path(__file__).resolve().parents[2]
FAMILIES=('cci','crypto_secret','crypto_staging','crypto_entropy')

def sha(path):return hashlib.sha256(path.read_bytes()).hexdigest()

def static_checks(family):
    folder=ROOT/'bus'/family;source=folder/'contract'/f'{family}.interface.yaml'
    c=yaml.safe_load(source.read_text());name=c['interface']['name']
    Draft202012Validator(yaml.safe_load((ROOT/'schema/interface_contract.schema.yaml').read_text())).validate(c)
    for p in folder.glob('contract/*.profile.yaml'):
        data=yaml.safe_load(p.read_text());Draft202012Validator(yaml.safe_load((ROOT/'schema/interface_profile.schema.yaml').read_text())).validate(data)
        assert data['profile']['interface']==c['interface']['id']
        assert data['profile']['version']==c['interface']['semantic_version']
    provenance=json.loads((folder/'metadata/implementation.json').read_text())
    for field in ['inputs','outputs']:
        for rel,digest in provenance[field].items():assert sha(folder/rel)==digest,(family,'drift',rel)
    core=yaml.safe_load((folder/f'interface_{family}.core').read_text())
    assert core['name']==f"aixsilicon:interface:{family}:{c['interface']['semantic_version']}"
    for fs in core['filesets'].values():
        for f in fs['files']:assert (folder/f).is_file(),f
    for t in core['targets'].values():assert set(t['filesets'])<=set(core['filesets'])
    assert core['targets']['compile_smoke']['toplevel']==f'tb_{family}'
    sv=(folder/f'rtl/{name}_if.sv').read_text()
    fields=[s for ch in c['channels'] for s in ch['signals']]
    declared=dict(re.findall(r'logic \[\((.*?)\)-1:0\] (\w+);',sv))
    # Regex above is width->name, reconstruct without losing repeated widths.
    declared={n:w for w,n in re.findall(r'logic \[\((.*?)\)-1:0\] (\w+);',sv)}
    assert declared=={s['id']:str(s['width']) for s in fields},(family,'field/width mismatch')
    for role in [r['id'] for r in c['roles']]:
        block=re.search(r'modport '+role+r' \((.*?)\);',sv,re.S).group(1)
        actual=dict((name,direction) for direction,name in re.findall(r'(input|output) (\w+)',block))
        expected={s['id']:'output' if s['from']==role else 'input' for s in fields}
        expected.update({d['id']:'input' for d in c['clock_domains']+c['reset_domains']})
        assert actual==expected,(family,'modport',role)
    return {'family':family,'signals':len(fields),'widths':[32,64,128,256,512],'contract_sha256':sha(source),'static_pass':True}

def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--static-only',action='store_true');parser.add_argument('--family',choices=FAMILIES,action='append');args=parser.parse_args()
    build=ROOT/'build/crypto_interfaces';build.mkdir(parents=True,exist_ok=True)
    config=build/'fusesoc.conf';config.write_text('[main]\n')
    smoke=subprocess.run([sys.executable,str(Path(__file__).with_name('generate_smoke.py')),'--check-only'],check=False)
    if smoke.returncode:return smoke.returncode
    records=[]
    for family in args.family or FAMILIES:
        record=static_checks(family)
        if not args.static_only:
            folder=ROOT/'bus'/family
            cmd=[sys.executable,'-m','fusesoc.main','--config',str(config),'--cores-root',str(folder),'run',
                 '--target=compile_smoke','--build-root='+str(build/family),'aixsilicon:interface:'+family+':0.2.0']
            inputs={str(p.relative_to(ROOT)):sha(p) for p in folder.rglob('*') if p.is_file() and p.suffix in ['.sv','.yaml','.core']}
            log=build/(family+'.log')
            with log.open('w') as output:
                try:result=subprocess.run(cmd,cwd=ROOT,stdout=output,stderr=subprocess.STDOUT,timeout=240);code=result.returncode
                except subprocess.TimeoutExpired:code=124
            text=log.read_text()
            passed=code==0 and f'HWIF_SMOKE_PASS {family}' in text and text.count('PASS '+family+' DATA_W=')==5
            stable=all(sha(ROOT/p)==v for p,v in inputs.items())
            record.update(command=cmd,exit_code=code,simulation_pass=passed,inputs_stable=stable,inputs=inputs,log=log.relative_to(ROOT).as_posix(),log_sha256=sha(log))
            print(f'{family}: exit={code}, simulation_pass={passed}, stable={stable}',flush=True)
            if not passed:print(text[-5000:],flush=True)
        records.append(record)
        (build/'results.json').write_text(json.dumps(records,indent=2)+'\n')
    return int(any(not r.get('simulation_pass',True) or not r.get('inputs_stable',True) for r in records))
if __name__=='__main__':raise SystemExit(main())
