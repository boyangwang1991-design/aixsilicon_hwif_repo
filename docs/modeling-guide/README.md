# 建模指南

> 如何编写 YAML Interface Contract / Profile / Compatibility。Schema 定义见 [`schema/`](../../schema/README.md:1)（`interface_contract.schema.yaml` 等）。

## 1. 基本原则

1. **每个事实具有稳定 ID**：接口 `IFC-<FAMILY>-<NNN>`，Profile `IFC-PROFILE-<NAME>-<NNN>`；
2. **宽度表达式是受限表达式**：仅允许参数名、整数常量、四则运算与括号，禁止任意脚本；
3. **方向使用 `from/to role`**，不用模块视角的 `input/output`；
4. **必选信号与可选 Capability 分开**：可选信号通过 `capability:` 关联；
5. **Clock/Reset/Power/CDC 属性不能留给端口名猜测**，必须显式声明；
6. **Profile 是能力的冻结组合**：只引用基础接口 ID，不复制信号；
7. **规范正文不复制进 YAML**，只记录受控引用（`protocol_reference`）；
8. **YAML 按接口族拆分**，不形成单一超级 YAML。

## 2. 编写步骤

1. 定义 `interface`（ID/name/family/版本/Owner/生命周期）；
2. 声明 `roles`（统一角色，如 initiator/target、source/sink；记录协议别名）；
3. 声明 `parameters` 及其 `constraints`；
4. 声明 `clock_domains` / `reset_domains`；
5. 声明 `channels`，每个 channel 内列出 `signals`，给出 `from/to/width/required/capability`；
6. 声明 `capabilities` 与 `semantics`；
7. 声明 `views`（packed_struct / sv_interface / flattened / ipxact）；
8. 需要时补充 `compatibility`（api_major、type_fingerprint、rules）。

## 3. Reset 语义必备字段

每个接口必须明确：polarity、assertion 同步/异步、deassertion 同步/异步、所属 clock、
reset 期间输出要求、释放后最小稳定周期、能否打断未完成事务、多 reset 域关系。

## 4. CDC 与 Power 属性（每 channel 至少）

- source / destination clock domain；
- synchronous / asynchronous / mesochronous；
- 允许的 CDC 方法类别；
- source / target power domain；
- isolation 方向与默认 clamp 值；
- retention 相关性；
- 电源关闭时信号合法性。

接口仓只描述 CDC 需求，不指定同步器实例（实现归 CBB/Techlib）。

## 5. 参数 / Capability / Profile 治理

| 概念 | 用途 | 示例 |
|---|---|---|
| Parameter | 数值或枚举配置 | `DataWidth=128` |
| Capability | 是否支持某项协议能力 | `supports_atop=true` |
| Profile | 经评审冻结的参数/能力组合 | `axi4_dma_v1` |

优先级：Profile > Parameter > Capability > 工具兼容宏。禁止仅用大量 `ifdef` 表达能力。

## 6. 校验

```bash
python3 tools/contract_validate/contract_validate.py \
  --schema schema/interface_contract.schema.yaml \
  --contract foundation/ready_valid/contract/ready_valid.interface.yaml
```
