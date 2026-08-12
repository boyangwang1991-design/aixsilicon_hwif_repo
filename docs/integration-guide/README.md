# 集成指南

> IP、CBB、VIP 与 SoC 如何声明和消费接口。详细规划见 [`plan.md`](plan.md:897) 第 15 节。

## 1. IP Metadata 示例

IP 侧在自身 metadata 中声明实例级接口绑定：

```yaml
interfaces:
  - instance_id: s_ctrl
    contract: aix:interface:axi_lite:1.0.0
    profile: axi_lite_csr_v1
    role: target
    parameters:
      AddrWidth: 32
      DataWidth: 32
    clock: clk_apb
    reset: rst_apb_n
    power_domain: pd_peri

  - instance_id: irq_done
    contract: aix:interface:interrupt:1.0.0
    profile: interrupt_level_v1
    role: source
    width: 1
```

## 2. VIP Binding 示例

```yaml
binding:
  interface: aix:interface:axi_lite:1.0.0
  vip: aix:vip:axi_lite:1.0.0
  role_map:
    initiator: active_master
    target: active_slave
    monitor: passive
  sv_interface: aix_axi_lite_if
  transaction_type: aix_axi_lite_item
```

## 3. CBB Adapter 声明

```yaml
adapter:
  id: CBB-AXI-DW-001
  input_contract: aix:interface:axi:1.x
  output_contract: aix:interface:axi:1.x
  transforms:
    - DataWidth
  limitations:
    - no_atop_width_conversion
```

## 4. FuseSoC 依赖方式

每个接口族作为独立 Core 发布（`aix:interface:<name>:<semver>`），消费者在
`filesets.*.depend` 中声明依赖，例如：

```yaml
depend:
  - aix:interface:common:1.0.0
  - aix:interface:axi:1.0.0
```

正式项目基线应精确锁定 Catalog commit、Interface VLNV、Git SHA 与生成器版本；
开发阶段可使用受控 SemVer 范围。

## 5. 消费规则

- RTL 内部优先使用 View A（packed struct req/rsp typed ports）；
- TB 与验证环境使用 View B（SV interface + modport + clocking block）；
- IP 正式交付边界使用 View C（flattened ports），命名见命名规范；
- 接口 ID 解析、Role 匹配、Profile 协商由 SoCGen 在生成 RTL 前完成；
- 不兼容连接必须显式失败或使用已认证 adapter。

## 6. 相关示例

- `examples/`：最小消费者示例；
- `tests/consumer/`：IP/VIP/SoCGen 消费者测试；
- `bindings/`：VIP / IP-XACT / Legacy 绑定映射。
