# Crypto Component Suite HWIF 实现

四个接口均已提供由 YAML 契约生成的 SystemVerilog package、interface、双向 flat wrapper、FuseSoC Core 和集成文档。契约与 Profile 版本为 **0.2.0**，生命周期仍为 **draft**。

| 接口 | 用途 | 资产入口 | FuseSoC VLNV |
|---|---|---|---|
| CCI | 加密组件命令、数据、完成及管理通道 | [cci](../../bus/cci/README.md) | `aixsilicon:interface:cci:0.2.0` |
| Secret | 受保护密钥服务 | [crypto_secret](../../bus/crypto_secret/README.md) | `aixsilicon:interface:crypto_secret:0.2.0` |
| Staging | 认证释放暂存服务 | [crypto_staging](../../bus/crypto_staging/README.md) | `aixsilicon:interface:crypto_staging:0.2.0` |
| Entropy | 熵服务 | [crypto_entropy](../../bus/crypto_entropy/README.md) | `aixsilicon:interface:crypto_entropy:0.2.0` |

## 集成约定

`DATA_W` 支持 32、64、128、256、512，默认 128。接口提供契约定义的两个角色及只读 `monitor` modport；时钟、复位均对端点可见。flat wrapper 是实际双向连线，参数必须与所接 interface 一致，不提供位宽转换、缓存或 CDC。

package 提供各位宽的显式类型，例如 `aix_cci_pkg::aix_cci_w64_req_t`；无 `w64` 等后缀的别名固定对应默认 128 位。req/rsp 按端点发送方向汇总信号，包含握手字段；各通道的 payload 类型不包含 valid/ready。具体字段顺序、端点方向和协议常量见各接口生成文档。

本次实现的是 HWIF 线网、类型与连接视图。命令调度、密钥授权、认证释放、清除、熵健康检测及 ready/valid 时序约束由客户端和服务端实现。本次连线测试不能代替这些控制器的功能验证，也不授予发布资格。

## 复现验证

从 workflow 根目录使用统一 uv 环境运行；VCS 与 FuseSoC 须已配置：

```bash
uv run python repos/aixsilicon_hwif_repo/examples/crypto_interfaces/run_checks.py
```

只执行 schema、精确字段位宽/方向、Core 引用、生成指纹和测试源一致性检查：

```bash
uv run python repos/aixsilicon_hwif_repo/examples/crypto_interfaces/run_checks.py --static-only
uv run python repos/aixsilicon_hwif_repo/examples/crypto_interfaces/generate_smoke.py --check-only
```

公共仓内的上述检查及 FuseSoC 仿真不依赖私有 Skill。RTL 派生视图请通过 owning HWIF 工具的显式 `generate --crypto-implementation` 模式重新生成；不要直接编辑派生文件。测试源由本目录的 `generate_smoke.py` 独立从契约生成。

## 验证记录（2026-09-24）

- VCS `W-2024.09-SP1_Full64`：四个接口 × 五个 DATA_W，**20/20 配置通过**。
- 每个配置检查全部字段、packed 聚合和通道类型位宽、协议常量及双向连接；覆盖全零、全一、128 组伪随机和逐位移动图样，包括独立管理通道。
- 工具回归 **30 项通过**，包含只读 drift 检查、不支持的接口拒绝、宽度表达式限制及生成确定性。
- 仿真输入内容的 SHA256 保存在 `build/crypto_interfaces/results.json`；日志为同目录 `<family>.log`。静态检查另写 `results_static.json`，不会覆盖仿真证据。

构建证据位于忽略的 `build/` 目录，可用上述命令重新产生。
