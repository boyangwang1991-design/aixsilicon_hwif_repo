#!/usr/bin/env bash
# compile_smoke.sh — SV 冒烟编译（vlogan/VCS 可用时）
#
# 按拓扑顺序汇总 .sv 文件并编译：common -> 各 *_pkg.sv -> interface/consumer。
# 若环境中无 vlogan（或 vcs 的 vlogan），退化为仅做文件存在性检查。
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# 排除目录：reference（第三方参考）、generated（派生视图，与手工 rtl/ 同名重复，单独验证）
EXCLUDE="-path ./reference -prune -o -path ./generated -prune -o -path ./common -prune -o"
# 拓扑顺序 1：common（基础 package/typedef 最先编译）
COMMON=$(find common -name '*.sv' -o -name '*.svh' | sort)
# 拓扑顺序 2：各接口族 package（可能依赖 common）
PKGS=$(find . $EXCLUDE -name '*_pkg.sv' -print | sort)
# 拓扑顺序 3：interface / consumer / 其余
REST=$(find . $EXCLUDE -name '*.sv' -print | grep -v '_pkg.sv$' | sort)

FILES="$COMMON $PKGS $REST"
if [ -z "$FILES" ]; then
  echo "[WARN] no .sv files found"
  exit 0
fi

if command -v vlogan >/dev/null 2>&1; then
  # shellcheck disable=SC2086
  vlogan -sverilog -quiet -timescale=1ns/1ps $FILES
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "[FAIL] vlogan compile smoke failed"
    exit $rc
  fi
  echo "[PASS] vlogan compile smoke: $(echo "$FILES" | wc -l) files (topological order)"
  # 清理 vlogan 产物
  rm -rf AN.DB csrc 2>/dev/null
  exit 0
fi

echo "[SKIP] vlogan not available; falling back to syntax-less file check"
echo "[PASS] found $(echo "$FILES" | wc -l) .sv files"
exit 0
