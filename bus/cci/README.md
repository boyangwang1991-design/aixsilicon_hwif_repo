# cci HWIF

版本 0.2.0，生命周期 draft；支持 DATA_W=32/64/128/256/512。

- [接口契约](contract/cci.interface.yaml) · [Base Profile](contract/cci_base.profile.yaml)
- [集成与字段文档](doc/aix_cci_interface.md)
- [SystemVerilog package](rtl/aix_cci_pkg.sv) · [interface](rtl/aix_cci_if.sv) · [flat wrapper](rtl/aix_cci_flat_wrapper.sv)
- [FuseSoC Core](interface_cci.core)（VLNV：`aixsilicon:interface:cci:0.2.0`；仿真 target：`compile_smoke`）
- [五位宽自检测试](tests/tb_cci.sv) · [生成指纹](metadata/implementation.json)
- [共同集成约定、验证结果与复现入口](../../examples/crypto_interfaces/README.md)

RTL 视图提供类型和信号连接；服务控制逻辑须在使用此 HWIF 的 IP 中实现。
