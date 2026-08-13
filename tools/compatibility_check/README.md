# compatibility_check — 兼容性判定器

根据三层兼容性模型输出唯一三类结论：`DIRECT` / `ADAPTER_REQUIRED` / `INCOMPATIBLE`。

## 判定流程（对应 plan §13）

1. Protocol Compatibility：同一接口族（family）；
2. Profile Compatibility：能力匹配、参数（宽度等）匹配；
3. Binding Compatibility：角色交集与参数求值。

## 用法

```bash
# 同族同宽 -> DIRECT
python3 tools/compatibility_check/compatibility_check.py \
  --source bus/axi/contract/axi.interface.yaml \
  --target bus/axi/contract/axi.interface.yaml \
  --source-params '{"DATA_W": 64}' --target-params '{"DATA_W": 64}'

# 位宽不同 -> ADAPTER_REQUIRED
python3 tools/compatibility_check/compatibility_check.py \
  --source bus/axi/contract/axi.interface.yaml \
  --target bus/axi/contract/axi.interface.yaml \
  --source-params '{"DATA_W": 128}' --target-params '{"DATA_W": 32}'

# Profile 能力协商（plan §13.1 第二层）
python3 tools/compatibility_check/compatibility_check.py \
  --source bus/axi/contract/axi.interface.yaml \
  --target bus/axi/contract/axi.interface.yaml \
  --source-profile bus/axi/contract/axi_memory_basic_v1.profile.yaml \
  --target-profile bus/axi/contract/axi_dma_high_bw_v1.profile.yaml

# 跨协议族 -> INCOMPATIBLE
python3 tools/compatibility_check/compatibility_check.py \
  --source bus/axi/contract/axi.interface.yaml \
  --target bus/apb/contract/apb.interface.yaml
```

## 规则

- 不能以「端口名相同」作为 DIRECT 依据（本工具基于契约 family/参数/能力）；
- `ADAPTER_REQUIRED` 只能引用 Catalog 中已认证的 CBB Adapter；
- 不兼容连接必须显式失败，禁止 SoCGen 静默截位/绑常量。

## 状态

- 已实现骨架级判定、Profile 能力协商与单元测试（[`tests/compatibility/`](../../tests/compatibility/README.md)）；
- 待扩展：Adapter Catalog 引用、SoC Lockfile 集成。
