# crypto_secret HWIF

版本 0.2.0，生命周期 draft；支持 DATA_W=32/64/128/256/512。

- [接口契约](contract/crypto_secret.interface.yaml) · [Base Profile](contract/crypto_secret_base.profile.yaml)
- [集成与字段文档](doc/aix_crypto_secret_interface.md)
- [SystemVerilog package](rtl/aix_crypto_secret_pkg.sv) · [interface](rtl/aix_crypto_secret_if.sv) · [flat wrapper](rtl/aix_crypto_secret_flat_wrapper.sv)
- [FuseSoC Core](interface_crypto_secret.core)（VLNV：`aixsilicon:interface:crypto_secret:0.2.0`；仿真 target：`compile_smoke`）
- [五位宽自检测试](tests/tb_crypto_secret.sv) · [生成指纹](metadata/implementation.json)
- [共同集成约定、验证结果与复现入口](../../examples/crypto_interfaces/README.md)

RTL 视图提供类型和信号连接；服务控制逻辑须在使用此 HWIF 的 IP 中实现。

## 可信 SHA-2 KDF 子服务

命名 [SHA2 KDF profile](../../profiles/project_extensions/crypto_secret_sha2_kdf.profile.yaml)
在普通 SHA2 HMAC 服务之外显式启用 `sha2_kdf_service`，仅供可信
`crypto_mac_call` 固定 Extract/Expand 模板使用。基础 profile 不启用该能力。
KDF 请求 `use=DERIVE`，`mode=1/2`，provider 必须逐父授权、角色、epoch、范围和 sink
核验；普通 CCI MAC 仍为 `use=MAC, mode=0`。公开 salt 允许空/短，只在授权 Extract
路径中使用，不能伪装为 key 对象。IKM/PRK/T 和结果永不经过普通数据出口。

每次 EXECUTE 先原子预留 DERIVE 操作用量，成功后取消/reset 不退款；与 VERIFY 猜测
失败预算分开。KEY、MESSAGE、USAGE 和 RESULT 的 provider ID 独立；RESULT 的
PREPARE/WRITE/COMMIT/QUERY/ABORT 保持同一事务。COMMIT 回应丢失查询原事务，
UNKNOWN 隔离而不重算；ACTIVE 后取消 TOO_LATE。精确行为由契约 semantics 拥有。
该 profile 仍为 draft，只声明合同，不宣称 provider 或 callee 已取得实现资格。
