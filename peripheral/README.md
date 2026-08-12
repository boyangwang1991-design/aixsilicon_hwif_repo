# peripheral — 外设与芯片边界接口（L4）

只定义数字侧接口契约；模拟电气指标、Pad 模型与 PLL 行为模型分别进入工艺/AMS 相关资产库。

| 子接口族 | 内容 | 优先级 | 状态 |
|---|---|---|---|
| [`uart`](uart/README.md:1) | tx/rx、cts/rts、极性与同步属性 | P1 | 骨架 |
| [`spi`](spi/README.md:1) | sclk、cs、MOSI/MISO、single/dual/quad data | P1 | 骨架 |
| [`i2c`](i2c/README.md:1) | scl/sda input/output-enable 分离视图 | P1 | 骨架 |
| [`gpio`](gpio/README.md:1) | input/output/output-enable、interrupt sideband | P1 | 骨架 |
| [`jtag_dmi`](jtag_dmi/README.md:1) | TCK/TMS/TDI/TDO/TRSTn、DMI | P1 | 骨架 |

通用原则：

- 双向物理接口优先拆成 `*_i` / `*_o` / `*_oe_o`，避免内部 RTL 直接使用 `inout`；
- 同步属性（同步/异步/三态）在 YAML 中显式声明；
- 具体 Pad 模型、电气指标归 `hw-techlib`。
