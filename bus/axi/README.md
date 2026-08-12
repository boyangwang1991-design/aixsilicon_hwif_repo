# axi — AXI4 总线接口（L3）

AMBA AXI4 端点契约，本仓库的核心参考族（对应 plan 第 9 节标准模板）。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/axi.interface.yaml`](contract/axi.interface.yaml:1) |
| AXI4 基础 Profile | [`contract/axi4_base.profile.yaml`](contract/axi4_base.profile.yaml:1) |
| SV Package（View A，PULP AXI 风格 req/rsp 聚合） | [`rtl/aix_axi_pkg.sv`](rtl/aix_axi_pkg.sv:1) |
| typedef 宏（include） | [`rtl/aix_axi_typedef.svh`](rtl/aix_axi_typedef.svh:1) |
| assign 宏（include） | [`rtl/aix_axi_assign.svh`](rtl/aix_axi_assign.svh:1) |
| SV Interface（View B） | [`rtl/aix_axi_if.sv`](rtl/aix_axi_if.sv:1) |
| Flat Wrapper（View C 示例） | [`rtl/aix_axi_flat_wrapper.sv`](rtl/aix_axi_flat_wrapper.sv:1) |
| FuseSoC Core | [`aix_interface_axi.core`](aix_interface_axi.core:1) |

## 语义要点

- 角色：`initiator` / `target`；
- 五个独立通道：AW / W / B / AR / R；
- 基础信号：ID / ADDR / LEN / SIZE / BURST / LOCK / CACHE / PROT / QOS / REGION / RESP；
- 能力：`atop`（原子操作，AW 通道）、`user_sideband`（*USER）、`exclusive`（独占访问）；
- AXI 定义为点到点接口协议，本仓描述端点契约，不描述 Crossbar 拓扑；
- AXI4 基础 Profile 优先，ATOP/独占/USER 作为 Capability。

## 依赖

```text
aix:interface:common → aix:interface:axi
```
