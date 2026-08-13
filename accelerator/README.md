# accelerator — 加速器核接口（HAC-IF）

> 分类层级：L6 Accelerator 接口族（`HAC-CTRL / HAC-STREAM / HAC-MEM / HAC-LMEM / HAC-EVENT / HAC-MGMT`）。

本分类定义硬件加速核（Hardware Accelerator Core, HAC）的通用核侧接口，用于隔离算法计算核心与 SoC 总线、存储系统、软件控制、时钟复位和安全机制之间的差异。

## 接口族清单

| 接口族 | 定位 | 必须性 |
|---|---|---|
| [`hac_ctrl`](hac_if/hac_ctrl/README.md:1) | 任务启动、接收、完成和取消 | P0 及以上必选 |
| [`hac_stream`](hac_if/hac_stream/README.md:1) | 流式输入输出 | 按 Profile 可选 |
| [`hac_mem`](hac_if/hac_mem/README.md:1) | 面向系统地址空间的访存请求/响应 | 按 Profile 可选 |
| [`hac_lmem`](hac_if/hac_lmem/README.md:1) | 本地 SRAM/Scratchpad 访问 | 可选 |
| [`hac_event`](hac_if/hac_event/README.md:1) | 完成、错误、性能及中断事件 | P0 及以上必选 |
| [`hac_mgmt`](hac_if/hac_mgmt/README.md:1) | 复位、功耗、隔离、调试和生命周期 | 推荐 |

## 核心原则

- **核与壳分离**：`HAC Core` 只实现算法与计算流水线，`HAC Shell` 负责任务接收、寄存器、数据搬运、系统协议、错误及电源管理；
- **总线解耦**：HAC Core 不感知 AXI / CHI / NoC 协议细节，由 `Adapter` 负责系统协议适配；
- **语义统一、物理可配置**：规范定义事务与握手语义，不强制相同数据宽度、流水级数或队列深度；
- **强制能力少、扩展能力显式声明**：所有可选能力必须由 `capability` 描述，禁止集成者猜测。

## 依赖

HAC-IF 接口 Core 依赖公共类型底座：

```text
aix:interface:common:1.0.0
aix:interface:ready_valid:1.0.0
aix:interface:event:1.0.0
aix:interface:reset:1.0.0
```

## 相关文档

- 协议规格：[`hac_if/spec/hac_if_spec.md`](hac_if/spec/hac_if_spec.md:1)
- 配置 SSOT Schema：[`hac_if/schema/hac_if.schema.json`](hac_if/schema/hac_if.schema.json:1)
- 立项输入（digest）：[`digest/hwif.md`](../../../../digest/hwif.md:1)
