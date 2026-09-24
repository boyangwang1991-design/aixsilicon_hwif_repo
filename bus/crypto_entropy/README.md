# crypto_entropy HWIF

版本 0.2.0，生命周期 draft；支持 DATA_W=32/64/128/256/512。

- [接口契约](contract/crypto_entropy.interface.yaml) · [Base Profile](contract/crypto_entropy_base.profile.yaml)
- [集成与字段文档](doc/aix_crypto_entropy_interface.md)
- [SystemVerilog package](rtl/aix_crypto_entropy_pkg.sv) · [interface](rtl/aix_crypto_entropy_if.sv) · [flat wrapper](rtl/aix_crypto_entropy_flat_wrapper.sv)
- [FuseSoC Core](interface_crypto_entropy.core)（VLNV：`aixsilicon:interface:crypto_entropy:0.2.0`；仿真 target：`compile_smoke`）
- [五位宽自检测试](tests/tb_crypto_entropy.sv) · [生成指纹](metadata/implementation.json)
- [共同集成约定、验证结果与复现入口](../../examples/crypto_interfaces/README.md)

RTL 视图提供类型和信号连接；服务控制逻辑须在使用此 HWIF 的 IP 中实现。
