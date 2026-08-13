# HAC-LMEM — 本地存储接口

> 面向 HAC 本地 Scratchpad SRAM、Weight/Activation Buffer、Line Buffer、多 Bank 共享存储及外置 ECC SRAM Wrapper 的访问接口。可选。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/hac_lmem.interface.yaml`](contract/hac_lmem.interface.yaml:1) |
| SV Package | [`rtl/aix_hac_lmem_pkg.sv`](rtl/aix_hac_lmem_pkg.sv:1) |
| SV Interface | [`rtl/aix_hac_lmem_if.sv`](rtl/aix_hac_lmem_if.sv:1) |
| FuseSoC Core | [`aix_interface_hac_lmem.core`](aix_interface_hac_lmem.core:1) |

## 推荐字段

- `req_valid/req_ready`；
- `write`；
- `bank`；
- `addr`；
- `wdata/wstrb`；
- `rsp_valid/rsp_ready/rdata`；
- `ecc_corrected/ecc_uncorrectable`；
- `tag`（用于非固定延迟存储）；
- `sleep/retention`（仅在 Memory Wrapper 侧出现）。

## 两类 Profile

| Profile | 说明 |
|---|---|
| `LMEM-FIXED` | 固定 1 或 2 周期返回，紧耦合单 Bank SRAM |
| `LMEM-DECOUPLED` | 请求/响应解耦，仲裁、多 Bank、可变延迟存储 |

> HAC Core 原则上不直接绑定 Foundry Macro 端口，由 `LMEM Adapter`（CBB Repo）完成 Macro 适配、ECC 与修复控制。
