# common — 公共类型底座

本接口族提供所有接口共用的类型与工具，是依赖层级的最底层：

```text
aix:interface:common
        ↓
aix:interface:ready_valid / interrupt / memory
        ↓
aix:interface:apb / axi_lite / axi / axi_stream
```

## 内容

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/common_types.interface.yaml`](contract/common_types.interface.yaml:1) |
| SV Package（bool/enum/ID/error code/工具） | [`rtl/aix_common_pkg.sv`](rtl/aix_common_pkg.sv:1) |
| typedef 宏（include） | [`rtl/aix_common_typedef.svh`](rtl/aix_common_typedef.svh:1) |
| assign 宏（include） | [`rtl/aix_common_assign.svh`](rtl/aix_common_assign.svh:1) |
| FuseSoC Core | [`aix_interface_common.core`](aix_interface_common.core:1) |

## 边界

- 只包含**通用**类型与工具，不包含任何协议专用信号；
- 协议级公共类型（如 AXI channel）位于各自接口族；
- `common_types` 不得反向依赖任何其它接口 Core。
