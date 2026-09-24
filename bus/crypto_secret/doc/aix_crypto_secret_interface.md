# aix_crypto_secret 接口实现

本页由契约生成；当前成熟度保持draft，未自动授予评审/发布资格。

源：[接口契约](../contract/crypto_secret.interface.yaml)；Profile位于同一contract目录。

## 集成

```systemverilog
aix_crypto_secret_if #(.DATA_W(128)) link (.clk(clk), .reset_n(reset_n));
```

端点使用 `requester` / `service` modport；`monitor`为只读。时钟/复位在各modport可见。
flat_wrapper将第一角色的平坦输入连接到interface，第二角色经interface返回平坦输出；没有零值占位、缓冲或时钟域转换。
wrapper的DATA_W必须与所接interface一致；应通过Core随带smoke检查所有配置。

## 类型与打包

SystemVerilog package不能按实例参数化，因此为32/64/128/256/512位分别提供w32/w64/w128/w256/w512类型。
例如 `aix_crypto_secret_pkg::aix_crypto_secret_w64_req_t`；不带w后缀的类型只对应契约默认DATA_W=128。
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
| req | 22 | ready_valid |
| rsp | 18 | ready_valid |
| write | 14 | ready_valid |
| read | 14 | ready_valid |
| control_req | 22 | ready_valid |
| control_rsp | 13 | ready_valid |

## 语义

- **transfer**：valid && ready；停顿时 valid 和 payload 稳定；取消通过握手丢弃或双端协同 reset，不单边撤 valid。
- **reset**：旧 epoch 响应排空/隔离前不得复用身份；硬复位不伪造 completion。
- **ordering**：每通道传输顺序固定；不同 request 可乱序响应，必须匹配完整身份与 request_id。
- **units**：长度/offset 为 bytes；无效/保留字段为零；未知枚举报 INVALID_PARAM。
- **version**：service_version=0x0200；所有其他版本拒绝。状态码与IFC-CCI-001 status_codes共用编号。
- **role_codes**：['1=KEY_LOAD', '2=SECRET_MESSAGE_READ', '3=RESULT_PREPARE', '4=RESULT_WRITE', '5=RESULT_COMMIT', '6=RESULT_ABORT', '7=REVOKE', '8=USAGE_RESERVE', '9=QUERY', '10=NONCE_RESERVE']
- **use_codes**：['1=MAC', '2=ENCRYPT', '3=DECRYPT', '4=DERIVE', '5=WRAP', '6=UNWRAP', '7=HP']
- **object_state_codes**：['0=NONE', '1=PREPARED', '2=WRITTEN', '3=ACTIVE', '4=ABORTED', '5=UNKNOWN']
- **control**：COMMIT/ABORT/REVOKE/QUERY仅control_req/control_rsp，其他role仅req/rsp；至少一个独立control credit，不能由普通请求占尽。
- **authorization**：每请求检查owner/use/operation/mode/policy_epoch/key_epoch和parent完整identity；offset+length防溢出并在对象范围内；未知role不降级KEY_LOAD。
- **fragmentation**：read每片由rsp元数据先成功握手，再传fragment_length字节，last终结该片，offset连续；end=1表示最后片；总量等于请求length后才使用。写请求接受后write按offset连续传length字节，last终结写请求；完成后rsp确认。长度0不传数据。
- **lifecycle**：PREPARE返回不可见object_ref；WRITE完成形成WRITTEN；COMMIT由可信端点复核总长/权限后原子ACTIVE。QUERY使用原事务request_id；重试COMMIT/ABORT/QUERY幂等且内容相同，身份或参数不符拒绝。
- **commit_race**：发送COMMIT后未应答不得假定未激活；QUERY或隔离恢复。ACTIVE后取消TOO_LATE；通信故障DELIVERY_UNKNOWN禁止重做算法。
- **revoke**：REVOKE对object_ref/key_epoch建立线性化点；先拒绝新使用并等待相关实例清除/隔离；不撤回已commit结果；旧epoch不可再ACTIVE。
- **nonce_usage**：NONCE_RESERVE由服务按真实key身份跨alias/instance持久预留，响应read交付nonce；USAGE_RESERVE使用usage_amount，成功后不可因cancel/reset回收；request_id幂等，不重扣或重复分配。
- **secret_boundary**：read/write仅物理受保护互联，禁止连普通CCI/dma/pio；取消迟到片进入清除域；length/offset/总长匹配后才使用。
- **key_load_length**：KEY_LOAD必须offset=0且length等于对象完整实际字节数，响应total_length为该对象完整长度；不匹配KEY_DENIED且不交付秘密。不得把范围读取或前缀截断作为KEY_LOAD成功；调用方由公开cmd_key_bits确定精确长度。
- **first_batch**：首批KEY_LOAD、REVOKE、QUERY及按nonce策略所需预留；secret-message/result角色供后续扩展，不自动宣称KDF secure_service：还需独立MAC子调用profile。
