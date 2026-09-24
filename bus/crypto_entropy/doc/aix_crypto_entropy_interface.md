# aix_crypto_entropy 接口实现

本页由契约生成；当前成熟度保持draft，未自动授予评审/发布资格。

源：[接口契约](../contract/crypto_entropy.interface.yaml)；Profile位于同一contract目录。

## 集成

```systemverilog
aix_crypto_entropy_if #(.DATA_W(128)) link (.clk(clk), .reset_n(reset_n));
```

端点使用 `consumer` / `source` modport；`monitor`为只读。时钟/复位在各modport可见。
flat_wrapper将第一角色的平坦输入连接到interface，第二角色经interface返回平坦输出；没有零值占位、缓冲或时钟域转换。
wrapper的DATA_W必须与所接interface一致；应通过Core随带smoke检查所有配置。

## 类型与打包

SystemVerilog package不能按实例参数化，因此为32/64/128/256/512位分别提供w32/w64/w128/w256/w512类型。
例如 `aix_crypto_entropy_pkg::aix_crypto_entropy_w64_req_t`；不带w后缀的类型只对应契约默认DATA_W=128。
req/rsp是按两个角色发送方向聚合的结构，包含各通道的valid/ready；不是单个命令或响应事务。
各通道另有不含valid/ready的payload_t。packed struct按契约信号顺序声明，首字段在MSB；线内data仍按最低byte lane承载首字节。
命令内部key_bindings/segments的entry位布局以契约semantics为准，与上述聚合struct字段顺序是不同层次。
*_codes派生为按组前缀区分的整数常量；服务共享的CCI状态码使用aix_cci_pkg::STATUS_*，消费者须显式依赖CCI Core。

## 边界

这些视图只提供线网、类型和连接，不实现命令调度、密钥授权、认证释放、清除或熵健康检测。
服务端和客户端负责契约ready/valid稳定性与管理语义。独立管理通道保留为独立信号，不能在集成时与普通通道合并。
接口自身不验证非法参数运行时行为；DATA_W只允许Profile列出的五个值。

## 通道

| 通道 | 字段数 | 握手 |
|---|---:|---|
| req | 11 | ready_valid |
| rsp | 15 | ready_valid |

## 语义

- **transfer**：valid && ready；停顿时 valid 和 payload 稳定；取消通过握手丢弃或双端协同 reset，不单边撤 valid。
- **reset**：旧 epoch 响应排空/隔离前不得复用身份；硬复位不伪造 completion。
- **ordering**：每通道传输顺序固定；不同 request 可乱序响应，必须匹配完整身份与 request_id。
- **units**：长度/offset 为 bytes；无效/保留字段为零；未知枚举报 INVALID_PARAM。
- **status**：使用IFC-CCI-001 status_codes；请求length必须非零且不超过manifest上限。
- **health**：仅health_ok=1且status=OK的有效握手字节可消费；最后拍last且低连续keep，总字节=length；失败rsp无数据(keep=0,last=1)，不是成功零长度随机数。
- **failure**：每请求有限watchdog；耗尽则停顿或ENTROPY_ERROR并清除，不复用随机数、不降级防护。
- **scope**：首批FUNCTIONAL不需熵；定义此接口不授予SCA资格，SCA需要独立profile/熵预算及证据。
