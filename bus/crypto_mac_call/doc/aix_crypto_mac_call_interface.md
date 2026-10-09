# aix_crypto_mac_call 接口实现

本页由契约生成；当前成熟度保持draft，未自动授予评审/发布资格。

源：[接口契约](../contract/crypto_mac_call.interface.yaml)；Profile位于同一contract目录。

## 集成

```systemverilog
aix_crypto_mac_call_if #(.DATA_W(128)) link (.clk(clk), .reset_n(reset_n));
```

端点使用 `caller` / `callee` modport；`monitor`为只读。时钟/复位在各modport可见。
flat_wrapper将第一角色的平坦输入连接到interface，第二角色经interface返回平坦输出；没有零值占位、缓冲或时钟域转换。
wrapper的DATA_W必须与所接interface一致；应通过Core随带smoke检查所有配置。

## 类型与打包

SystemVerilog package不能按实例参数化，因此为32/64/128/256/512位分别提供w32/w64/w128/w256/w512类型。
例如 `aix_crypto_mac_call_pkg::aix_crypto_mac_call_w64_req_t`；不带w后缀的类型只对应契约默认DATA_W=128。
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
| req | 25 | ready_valid |
| rsp | 23 | ready_valid |
| public_data | 16 | ready_valid |
| control_req | 13 | ready_valid |
| control_rsp | 16 | ready_valid |

## 语义

- **transfer**：valid && ready；停顿中保持valid/payload，取消经drain或双端reset，不单边撤回。
- **namespace**：父owner/instance/epoch/task/request_seq/context/generation完整保留；invocation_id独立64-bit；physical MAC bank/CORE tag独立于父context。
- **admission**：RESERVE先冻结参数并预留child/响应/服务credit，caller取得lease后才能提交父任务；EXECUTE仅身份/调用ID/lease/action非零，不能TOCTOU改参数。
- **actions**：['0=RESERVE', '1=EXECUTE', '2=RELEASE', '3=CANCEL', '4=QUERY']
- **templates**：['0=PROTECTED_HMAC: REF key及一项SECRET消息，支持GEN/VERIFY', '1=HKDF_EXTRACT: PUBLIC_PARAMETER key及一项SECRET IKM，GEN only', '2=HKDF_EXPAND: REF PRK，T_prev(若iteration>1)/PUBLIC info/COUNTER，GEN only']
- **key_sources**：['0=REF: key_ref!=0，key_length精确完整长度，普通MAC最少16 B', '1=PUBLIC_PARAMETER: 仅EXTRACT；key_ref/key_epoch=0，key_length可0或短，禁止普通软件直达']
- **parts_layout**：每part232 bits，低part先；bit[7:0]=kind，[71:8]=object_ref，[103:72]=object_epoch，[167:104]=offset，[231:168]=length。三项上限，未用项0。
- **part_kinds**：['1=PUBLIC: ref/epoch/offset=0，数据来自公开info通道', '2=SECRET: ref!=0，逐range/epoch/use检查，仅provider READ', '3=COUNTER: 仅EXPAND尾项，length=1，其余字段0；byte由iteration内部产生']
- **public_sources**：['1=SALT，精确key_length且仅EXTRACT', '2=INFO，精确PUBLIC part长度且仅EXPAND', '3=EXPECTED_TAG，精确tag_length且仅PROTECTED_HMAC VERIFY']
- **public_data**：低lane先，非末拍keep全1，末拍从低lane连续，last恰为声明长度；长度0不发beat，外国tuple丢弃。
- **authorization**：端点仅连接可信KDF/组件，不接软件descriptor；固定template限制秘密执行图。普通use=MAC；KDF use=DERIVE，逐provider角色、policy/key/object epoch及父授权校验；公开salt不能冒充key对象。
- **result**：GEN仅private sink PREPARE/WRITE/COMMIT；ACTIVE后返回ref/epoch/长度，不返回data。VERIFY先USAGE_RESERVE，不退款、固定声明长度比较、无Tag出口。
- **cancel**：独立control credit；提交确认后TOO_LATE与原成功终态分开，ACK丢失QUERY同一事务，UNKNOWN隔离且禁止重算。
- **cleanup**：终结rsp cleanup_done依赖所有task/cache/staging/egress bank实际清除或协同reset；RESERVE确认不表示算法终结。
- **service_ids**：provider physical request_id由内部独立nonce分配，保留caller完整invocation_id；结果事务PREPARE/WRITE/COMMIT/QUERY共用同一transaction ID。
- **version**：0.1.0 draft；命名SHA2 profile才允许装配；接口生成不构成实现资格。
