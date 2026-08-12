# 命名规范

> 统一命名与语义规范。详细规划见 [`plan.md`](plan.md:668) 第 11 节。

## 1. 角色命名（统一角色，协议别名仅作元数据）

| 场景 | 统一角色 | 协议原生别名 |
|---|---|---|
| Memory-mapped request | `initiator` / `target` | master/slave、manager/subordinate |
| Stream | `source` / `sink` | transmitter/receiver |
| Clock/reset 控制 | `controller` / `endpoint` | source/destination |
| Interrupt | `source` / `receiver` | sender/target |
| Memory | `requester` / `memory` | host/device |

## 2. RTL 命名

| 对象 | 规则 | 示例 |
|---|---|---|
| Package | `aix_<interface>_pkg` | `aix_axi_pkg` |
| Interface | `aix_<interface>_if` | `aix_axi_if` |
| Request 类型 | `<interface>_req_t` | `axi_req_t` |
| Response 类型 | `<interface>_rsp_t` | `axi_rsp_t` |
| Channel 类型 | 协议标准简称 | `aw_t`、`w_t`、`b_t` |
| Clock | `clk_i` | — |
| Active-low reset | `rst_ni` | — |
| 普通输入/输出 | `*_i` / `*_o` | — |
| 双向物理接口 | 拆为 `*_i` / `*_o` / `*_oe_o` | 避免内部 RTL 直接用 `inout` |
| 参数 | PascalCase 或组织统一规范，不能混用 | `AddrWidth`、`DataWidth`、`IdWidth` |

宽度参数必须无歧义。

## 3. Flattened Port 命名

```text
<instance_prefix>_<channel>_<signal>_<direction>
```

例如：

```text
s_axi_aw_valid_i
s_axi_aw_ready_o
s_axi_aw_addr_i
```

内部契约角色统一使用 `initiator/target`；端口前缀可保留 `m_`/`s_` 别名，
但必须在 metadata 中明确 alias，**不把别名当成新的接口类型**。

## 4. 编码约定

- 布尔/使能信号避免使用含义模糊的缩写；
- 错误信号名应能反映语义（如 `err_recoverable` / `err_fatal`）；
- 跨时钟域信号建议在名字或 metadata 中标注域（域信息以 YAML 为准）。
