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
- **role_codes**：['1=KEY_LOAD', '2=SECRET_MESSAGE_READ', '3=RESULT_PREPARE', '4=RESULT_WRITE', '5=RESULT_COMMIT', '6=RESULT_ABORT', '7=REVOKE', '8=USAGE_RESERVE', '9=QUERY', '10=NONCE_RESERVE', '11=DECRYPT_RESERVE', '12=DECRYPT_SETTLE']
- **use_codes**：['1=MAC', '2=ENCRYPT', '3=DECRYPT', '4=DERIVE', '5=WRAP', '6=UNWRAP', '7=HP', '8=SIGN', '9=VERIFY']
- **object_state_codes**：['0=NONE', '1=PREPARED', '2=WRITTEN', '3=ACTIVE', '4=ABORTED', '5=UNKNOWN']
- **control**：COMMIT/ABORT/REVOKE/QUERY/DECRYPT_SETTLE仅control_req/control_rsp，其他role仅req/rsp；至少一个独立control credit，不能由普通请求占尽。
- **authorization**：每请求检查owner/use/operation/mode/policy_epoch/key_epoch和parent完整identity；offset+length防溢出并在对象范围内；未知role不降级KEY_LOAD。
- **fragmentation**：read每片由rsp元数据先成功握手，再传fragment_length字节，last终结该片，offset连续；end=1表示最后片；总量等于请求length后才使用。写请求接受后write按offset连续传length字节，last终结写请求；完成后rsp确认。长度0不传数据。
- **lifecycle**：PREPARE返回不可见object_ref；WRITE完成形成WRITTEN；COMMIT由可信端点复核总长/权限后原子ACTIVE。QUERY使用原事务request_id；重试COMMIT/ABORT/QUERY幂等且内容相同，身份或参数不符拒绝。
- **commit_race**：发送COMMIT后未应答不得假定未激活；QUERY或隔离恢复。ACTIVE后取消TOO_LATE；通信故障DELIVERY_UNKNOWN禁止重做算法。
- **revoke**：REVOKE对object_ref/key_epoch建立线性化点；先拒绝新使用并等待相关实例清除/隔离；不撤回已commit结果；旧epoch不可再ACTIVE。
- **nonce_usage**：NONCE_RESERVE由服务按真实key身份跨alias/instance持久预留，响应read交付nonce；USAGE_RESERVE使用usage_amount，成功后不可因cancel/reset回收；request_id幂等，不重扣或重复分配。
- **secret_boundary**：read/write仅物理受保护互联，禁止连普通CCI/dma/pio；取消迟到片进入清除域；length/offset/总长匹配后才使用。
- **key_load_length**：KEY_LOAD必须offset=0且length等于对象完整实际字节数，响应total_length为该对象完整长度；不匹配KEY_DENIED且不交付秘密。不得把范围读取或前缀截断作为KEY_LOAD成功；调用方由公开cmd_key_bits确定精确长度。
- **first_batch**：首批KEY_LOAD、REVOKE、QUERY及按nonce策略所需预留；secret-message/result角色供后续扩展，不自动宣称KDF secure_service：还需独立MAC子调用profile。
- **sha2_hmac_service_profile**：CRYPTO_SECRET_SHA2_HMAC_0_2：仅用于 CCI SHA-2 operation 70..81。KEY_LOAD 必须 use=MAC、offset=0、length=公开 key_bits/8，并校验 owner、完整 parent identity、operation、policy_epoch 与 key_epoch；GENERATE/VERIFY 不得共享错误用途授权。 HMAC_VERIFY 在接受计算前使用 USAGE_RESERVE，req_length=tag_len bytes、usage_amount=1， 服务按 key epoch 原子检查 tag_len policy 与失败预算；成功认证不回收已用预留，失败计入预算。 SECURE_SERVICE 子调用使用 SECRET_MESSAGE_READ 读取 parent 授权的 message range，并以 RESULT_PREPARE→RESULT_WRITE→RESULT_COMMIT 产生不可见到 ACTIVE 的结果对象；取消使用 RESULT_ABORT，COMMIT ACK 丢失使用 QUERY。所有角色绑定同一完整 parent identity； KEY、MESSAGE、USAGE、RESULT 使用各自独立 request_id，RESULT 的 PREPARE/WRITE/COMMIT/QUERY/ABORT 保持同一事务 ID， 普通 CCI/dma/pio 禁止承载 secret bytes。未启用本 capability 的 profile 必须拒绝上述组合。
- **sha2_kdf_service_profile**：CRYPTO_SECRET_SHA2_KDF_0_2 仅用于可信 IFC-PROFILE-CRYPTO-MAC-CALL-SHA2-0-1 caller/callee 的固定 HKDF_EXTRACT/HKDF_EXPAND 子调用，不属于普通 CCI 软件模式。 use=4(DERIVE)，mode=1(EXTRACT)/2(EXPAND)，operation=70..75 对应六个标准 HMAC GENERATE selector；禁止 VERIFY、其它 mode 或未启用算法。没有本 capability 的端点 必须拒绝这些组合。provider 从受信调用绑定取得父授权，逐角色校验完整 parent owner/instance/epoch/task/request_seq/context/generation、policy epoch、对象/密钥 epoch、 operation、mode、range 和 sink；不得将拥有任意 object_ref 视为 DERIVE 权限。
- **sha2_kdf_extract**：EXTRACT 的 key 是 caller 声明长度的公开 salt，允许空或短 salt，不执行 KEY_LOAD， 也不伪造 salt 对象句柄。SECRET_MESSAGE_READ 只能读取该父调用 DERIVE 授权的 IKM range，req_key_epoch 对应 IKM object_epoch，offset+length 不溢出且在对象内。 在接受公开 salt 并启动计算前，必须取得 IKM 的成功 metadata 授权和 RESULT_PREPARE 的私有 sink 授权。空 IKM 也要 req/rsp 校验，不传秘密 data beat。
- **sha2_kdf_expand**：EXPAND 的 KEY_LOAD 读取 DERIVE 授权的完整 PRK，offset=0，length 精确匹配实际 key_length，不能用对象前缀代替 key；PRK 至少所选 digest 字节数。 非首轮 SECRET_MESSAGE_READ 只读取父授权的 T_prev，长度等于所选完整 digest 字节数， object_epoch 精确匹配；首轮没有 T_prev。公开 info 来自可信 caller，iteration byte 由 callee 内部从冻结的 1..255 iteration 产生，不能读公开 data 代替。
- **sha2_kdf_usage**：每次 EXECUTE 在 key/IKM 计算前使用 USAGE_RESERVE 原子扣一次 DERIVE 操作用量。 EXTRACT 的 req_object_ref/key_epoch 为 IKM 对象/epoch，EXPAND 为 PRK 对象/key_epoch； req_length 等于完整输出 digest 字节数，usage_amount=1，成功后取消/reset 不退款。 服务按真实授权对象管理别名/实例共享用量；同一 request_id 的相同内容幂等不重扣。 这是 DERIVE 操作用量，不能套用 HMAC_VERIFY tag 猜测失败预算。
- **sha2_kdf_result**：生成结果只经过 RESULT_PREPARE/RESULT_WRITE/RESULT_COMMIT，产生不可见到 ACTIVE 的 完整 digest 对象；PREPARE 的 result_sink_ref 非零且属于本次父 DERIVE 授权，length 为完整 digest 字节数，offset=0。PREPARE/WRITE/COMMIT/QUERY/ABORT 使用同一 provider request_id。KEY、每项 MESSAGE、USAGE 和 RESULT 各自用独立非零 ID， 不同 invocation 不复用；全部请求保持完整 parent identity，不把 caller invocation_id 截断或混同 provider request_id。ACK 丢失查询原事务，UNKNOWN 隔离并禁止重算； ACTIVE 后取消 TOO_LATE，失败不能把候选结果写到普通 CCI/dma/pio。
- **rsa_service_profile**：CRYPTO_SECRET_RSA_0_2：仅用于 CCI RSA operation 96..101。KEY_LOAD 对私钥 使用 use=SIGN 或 DECRYPT、mode=1(CRT2)，对公钥使用 use=VERIFY 或 ENCRYPT、mode=0(PUBLIC)。 服务必须逐项校验 owner、use、operation、policy_epoch、key_epoch、parent identity 与完整对象长度； 未启用 rsa_service 的 profile 拒绝这些组合。v0.1.0 禁止 STANDARD_D 与 multi-prime。
- **rsa_object_format**：所有整数为无符号定长 big-endian。PUBLIC blob=n[k] || e[32]，e 左侧补零且实际值满足 CCI profile 范围。CRT2 blob=n[k] || e[32] || p[k/2] || q[k/2] || dP[k/2] || dQ[k/2] || qInv[k/2]。 KEY_LOAD 必须 offset=0 且 length 精确等于 k+32(PUBLIC) 或 7*k/2+32(CRT2)；rsp_total_length 与最终 byte count 必须相同。服务授权不替代 RSA consumer 对 p*q、qInv、e*dP/e*dQ 等数学关系的复核。
- **rsa_oaep_secret_flow**：OAEP_ENCRYPT 使用 SECRET_MESSAGE_READ，use=ENCRYPT，object_ref 为 CCI role RSA_SECRET_MESSAGE_READ 的对象，length 等于命令声明明文长度。OAEP_DECRYPT 使用 RESULT_PREPARE→RESULT_WRITE→RESULT_COMMIT，use=DECRYPT，req_result_sink_ref 绑定 CCI role RSA_RESULT_SINK； 失败、取消或 reset 在 COMMIT 前使用 RESULT_ABORT，COMMIT ACK 丢失使用 QUERY。所有请求绑定同一 parent identity/request_id；candidate plaintext 永不进入普通 CCI/dma/pio。
- **decrypt_budget**：Ascon受信服务按实际key身份跨owner/alias/instance管理F(已结算失败)与R(未结算解密预留)。DECRYPT_RESERVE仅req/rsp，object_ref为key，length=0，原子检查F+R<2^32后R+=1并返回独立票据object_ref；额度耗尽KEY_DENIED并要求平台rekey。DECRYPT_SETTLE仅control_req/control_rsp，object_ref为票据、usage_amount=0表示已认证成功、1表示失败或取消，其他值INVALID_PARAM；原子R-=1且F+=usage_amount，饱和并持久化。相同request_id重试幂等。未结算票据在reset/失联后保守记失败，不能无条件退款；成功只退失败预算预留，不退字节用量。若平台不能证明票据最终结算则隔离并拒绝旧key新解密。
