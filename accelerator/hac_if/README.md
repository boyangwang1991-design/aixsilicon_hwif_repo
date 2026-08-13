# HAC-IF — Hardware Accelerator Core Interface

> Hardware Accelerator Core Interface Specification & Ecosystem Plan（V0.1，2026-08-13）。
> 定义一套面向硬件加速核的通用核侧接口 `HAC-IF`，隔离算法计算核心与 SoC 总线、存储、软件控制、时钟复位与安全机制的差异。

## 设计目标

- **总线解耦**：HAC Core 不感知 AXI、CHI 或具体 NoC 协议；
- **统一集成**：不同来源的计算核经 Wrapper 后使用一致的 Shell；
- **按需裁剪**：小核无需承担复杂加速器的全部接口成本；
- **高吞吐**：支持多 Outstanding、乱序响应、Burst 与流式背压；
- **可验证**：每类接口有明确握手、不变量、超时与错误语义；
- **可生成**：从 YAML / SystemRDL SSOT 生成 RTL、断言、文档与软件头文件。

## 六大接口族

| 接口族 | 定位 | 目录 |
|---|---|---|
| `HAC-CTRL` | 任务启动、接收、完成和取消 | [`hac_ctrl`](hac_ctrl/README.md:1) |
| `HAC-STREAM` | 流式输入输出 | [`hac_stream`](hac_stream/README.md:1) |
| `HAC-MEM` | 面向系统地址空间的访存请求/响应 | [`hac_mem`](hac_mem/README.md:1) |
| `HAC-LMEM` | 本地 SRAM/Scratchpad 访问 | [`hac_lmem`](hac_lmem/README.md:1) |
| `HAC-EVENT` | 完成、错误、性能及中断事件 | [`hac_event`](hac_event/README.md:1) |
| `HAC-MGMT` | 复位、功耗、隔离、调试和生命周期 | [`hac_mgmt`](hac_mgmt/README.md:1) |

## Profile

| Profile | 必选接口 | 典型场景 | 推荐系统侧接口 |
|---|---|---|---|
| `HAC-P0 Control` | CTRL、EVENT | 随机数、校验、小型密码运算 | AXI4-Lite + IRQ |
| `HAC-P1 Stream` | CTRL、STREAM、EVENT | 视频、音频、包处理、滤波 | AXI4-Lite + AXI4-Stream |
| `HAC-P2 Memory` | CTRL、MEM、EVENT | GEMM、FFT、压缩、批处理 | AXI4-Lite + AXI4 Master |
| `HAC-P3 Hybrid` | CTRL、MEM、STREAM、EVENT | AI/DSP 复杂加速器 | AXI4-Lite + AXI4 + AXIS |
| `HAC-P4 Managed` | P3 + MGMT 增强能力 | 多租户、安全、复杂 SoC | NoC/AXI/一致性扩展 |

## 资产

| 资产 | 路径 |
|---|---|
| 协议规格 | [`spec/hac_if_spec.md`](spec/hac_if_spec.md:1) |
| 配置 SSOT Schema | [`schema/hac_if.schema.json`](schema/hac_if.schema.json:1) |
| 公共类型包 | [`rtl/aix_hac_if_pkg.sv`](rtl/aix_hac_if_pkg.sv:1) |
| SVA 基线 | [`sva/aix_hac_if_assertions.sv`](sva/aix_hac_if_assertions.sv:1) |
| FuseSoC 聚合 Core | [`aix_interface_hac_if.core`](aix_interface_hac_if.core:1) |

## 验证归属

- SVA/Protocol Checker、UVM Agent、Scoreboard、Coverage 归 `vip-repo`（`protocol/hac_if`）；
- Adapter（AP/AXI/AXIS/SRAM）、Shell 组合实现归 `cbb-repo`（`adapters/hac_*` / `components/hac_*`）；
- 具体 HAC（算法核、专用 Wrapper、Descriptor、IP 寄存器）归 `ip-repo`。

## 依赖

```text
aix:interface:common:1.0.0
aix:interface:ready_valid:1.0.0
aix:interface:event:1.0.0
aix:interface:reset:1.0.0
```

> 依赖方向单向：`IP Repo → CBB Repo → HWIF Repo`，验证依赖 `DV COMMON / VIP`。
