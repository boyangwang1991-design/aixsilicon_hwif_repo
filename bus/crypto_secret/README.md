# crypto_secret HWIF

版本 0.2.0，生命周期 draft；支持 DATA_W=32/64/128/256/512。

- [接口契约](contract/crypto_secret.interface.yaml) · [Base Profile](contract/crypto_secret_base.profile.yaml)
- [集成与字段文档](doc/aix_crypto_secret_interface.md)
- [SystemVerilog package](rtl/aix_crypto_secret_pkg.sv) · [interface](rtl/aix_crypto_secret_if.sv) · [flat wrapper](rtl/aix_crypto_secret_flat_wrapper.sv)
- [FuseSoC Core](interface_crypto_secret.core)（VLNV：`aixsilicon:interface:crypto_secret:0.2.0`；仿真 target：`compile_smoke`）
- [五位宽自检测试](tests/tb_crypto_secret.sv) · [生成指纹](metadata/implementation.json)
- [共同集成约定、验证结果与复现入口](../../examples/crypto_interfaces/README.md)

RTL 视图提供类型和信号连接；服务控制逻辑须在使用此 HWIF 的 IP 中实现。
