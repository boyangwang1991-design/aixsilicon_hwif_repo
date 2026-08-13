# HAC-MEM — 系统访存接口

> 面向加速器的抽象 Request/Response 接口，表达"读写什么"，不暴露 AXI 的 AR/AW/W/R/B 通道组织。按 Profile 可选（P2/P3）。

## 资产

| 资产 | 路径 |
|---|---|
| YAML Contract | [`contract/hac_mem.interface.yaml`](contract/hac_mem.interface.yaml:1) |
| SV Package | [`rtl/aix_hac_mem_pkg.sv`](rtl/aix_hac_mem_pkg.sv:1) |
| SV Interface | [`rtl/aix_hac_mem_if.sv`](rtl/aix_hac_mem_if.sv:1) |
| FuseSoC Core | [`aix_interface_hac_mem.core`](aix_interface_hac_mem.core:1) |

## 逻辑通道

1. Read Request；
2. Read Response；
3. Write Request/Data；
4. Write Response。

## 基线字段

| 字段 | 含义 |
|---|---|
| `valid/ready` | 事务握手 |
| `addr` | Byte 地址 |
| `len` | 传输总 Byte 数或 Beat 数（规范固定一种编码） |
| `size` | 单 Beat 字节数 |
| `tag` | 请求与响应关联标识 |
| `job_id` | 所属任务，可选 |
| `opcode` | Read/Write/Prefetch/Atomic 扩展 |
| `data` | 数据 Payload |
| `strb` | Byte 写使能 |
| `last` | 请求或响应末 Beat |
| `status` | OK、Decode、Slave、Timeout、Poison 等 |
| `attr` | Cache、Security、Privilege、QoS 等抽象属性 |

## V1.0 强制约束

- 地址按 Byte 编址，`len_bytes` 表示整个请求的有效 Byte 数；
- 相同 `tag` 在完成前不得重用；
- 允许不同 `tag` 的响应乱序，同一 `tag` 内响应保持顺序；
- 写数据不得早于对应 Write Request 被接受，除非扩展明确允许；
- 是否支持非对齐、跨页、大请求拆分由 Capability 声明；
- Core 只接收抽象状态，不直接处理 AXI `BRESP/RRESP`。

## 地址模型

| 模式 | Core 看到的地址 | 场景 |
|---|---|---|
| Physical/IOVA 模式 | 系统地址或已转换 IOVA | 常规 SoC、SMMU 前置 |
| Window Offset 模式 | Buffer 窗口内偏移 | 强隔离、小型 HAC |

> HAC-to-AXI Adapter 职责（4KB 边界、Burst 限制、Tag→ID 映射、重排回压、错误码转换、超时与协议错误检测）由 CBB Repo 实现。
