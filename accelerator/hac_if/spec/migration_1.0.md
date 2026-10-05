# HAC-IF 0.1 → 1.0 迁移

本次为破坏性契约修改：SemVer提升至`1.0.0`，所有家族/profile/core对齐，lifecycle仍为draft。`1.0.0`表示接口版本，不表示qualification通过。旧0.1视图保留在`archive/0.1.0/`，不发现为现行FuseSoC core；历史契约从Git取回，禁止混编。

| 旧定义 | 1.0定义 | 消费者动作 |
|---|---|---|
| `IFC-HAC-CTRL/STRM/MEM/LMEM/EVT/MGMT-001` | `IFC-HAC_CTRL/STRM/MEM/LMEM/EVT/MGMT-001` | 按现有schema的ID格式更新引用，不改schema |
| `hac_*_if`、固定宽度`hac_*_pkg` | `aix_hac_*_if`，参数化字段 | 更新模块接口类型，使用实例参数；旧struct不能混用 |
| CTRL cfg提交无完整收敛 | cfg_commit + cfg_rsp，job/slot匹配 | 算法参数仍通过原生binding装载，成功响应消费后才能cmd |
| CTRL完成缺cpl_ready | core输出cpl，shell输出cpl_ready | 保持完成载荷到握手，反压期间保留job身份 |
| 0x0001..0x00FF误判为非错误 | 0为成功，全部非0非成功 | 用契约编码；不要调用旧status helper |
| 可选信号在interface绑死 | from角色唯一驱动 | 按启用能力产生载荷，关闭时由发送者tieoff |
| MEM请求/写数据语义不全 | 五通道、Byte长度、独立读写tag | Adapter/VIP需更新事务模型和迟到响应记录 |
| LMEM重复tag及零宽bank | req_tag/rsp_tag，所有物理宽度≥1 | 明确fixed/decoupled模式，写也返回响应 |
| MGMT drain可选 | drain基础必需，四相req/ack | 消费待发响应，回收未启动配置，排空后复位 |
| profile引用跨家族能力 | 单家族profile + 文档组合规则 | P0/P1/P2按组合选择，不把MGMT等当CTRL参数 |
| 聚合core内嵌子族且子族反向依赖 | 聚合→六子族，子族无反向依赖 | 更新VLNV为1.0.0，避免重复声明与依赖环 |
| flat及SVA骨架 | flat不发布；旧SVA归档 | 后续按owner流程开发完整flat/VIP，不当作本版已完成 |

## 消费者影响

以下文件目前仍引用0.1或旧profile用法，必须由其owner完成实现/验证后迁移；本次没有机械替换成1.0以掩盖不兼容。

- `aixsilicon_catalog_repo/catalog/index.yaml`和`catalog/assets/hwif-hac-if.yaml`：目录仍登记旧draft接口。发布1.0候选时更新版本、六族依赖及evidence路径；旧配置schema已归档。
- `aixsilicon_catalog_repo/catalog/assets/cbb-hac-adapters.yaml`：Shell/Adapter draft依赖需更新，同时实现cfg_rsp、cpl_ready、MEM五通道及drain。
- `aixsilicon_catalog_repo/catalog/assets/vip-hac-if.yaml`：VIP draft依赖需更新，重建任务/tag跟踪与异常checker。
- `aixsilicon_catalog_repo/catalog/assets/ip-hac-aes.yaml`：算法配置binding及新CTRL终态需要复核。
- `aixsilicon_soc_integration/examples/hac-accel-soc.yaml`：旧P2高在途、分时钟示例不属于本版基础profile；需要明确CDC、MGMT及真实实现能力后重写。

以上是源码引用检索的影响清单，不是消费者验证结果。没有发现这些draft对应的已实现HAC消费core可以直接完成升级。迁移先构建独立接口端点，再验证binding、错误恢复与组合，最后更新catalog/lock；不用catalog元数据代替实际协议验证。

## 绑定迁移原则

uDMA继续作为统一DMA服务。HAC job和uDMA native transfer/channel通过有界状态映射；HAC safe terminal在DMA、计算、输出与可见域收敛后产生。uDMA当前时序/面积不影响本方案选型。HTS task_tag/epoch另行映射，取消、reset与CQ发布不能简化为HAC信号重命名。具体字段映射和实现交付归各owner，准入信息见总规格§5。
