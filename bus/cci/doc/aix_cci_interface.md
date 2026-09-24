# aix_cci 接口实现

本页由契约生成；当前成熟度保持draft，未自动授予评审/发布资格。

源：[接口契约](../contract/cci.interface.yaml)；Profile位于同一contract目录。

## 集成

```systemverilog
aix_cci_if #(.DATA_W(128)) link (.clk(clk), .reset_n(reset_n));
```

端点使用 `client` / `component` modport；`monitor`为只读。时钟/复位在各modport可见。
flat_wrapper将第一角色的平坦输入连接到interface，第二角色经interface返回平坦输出；没有零值占位、缓冲或时钟域转换。
wrapper的DATA_W必须与所接interface一致；应通过Core随带smoke检查所有配置。

## 类型与打包

SystemVerilog package不能按实例参数化，因此为32/64/128/256/512位分别提供w32/w64/w128/w256/w512类型。
例如 `aix_cci_pkg::aix_cci_w64_req_t`；不带w后缀的类型只对应契约默认DATA_W=128。
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
| cmd | 26 | ready_valid |
| din | 13 | ready_valid |
| dout | 16 | ready_valid |
| cpl | 21 | ready_valid |
| mgmt_req | 14 | ready_valid |
| mgmt_rsp | 14 | ready_valid |
| cap_req | 4 | ready_valid |
| cap_rsp | 7 | ready_valid |

## 语义

- **transfer**：valid && ready；停顿时 valid 和 payload 稳定；取消通过握手丢弃或双端协同 reset，不单边撤 valid。
- **reset**：旧 epoch 响应排空/隔离前不得复用身份；硬复位不伪造 completion。
- **ordering**：每通道传输顺序固定；不同 request 可乱序响应，必须匹配完整身份与 request_id。
- **units**：长度/offset 为 bytes；无效/保留字段为零；未知枚举报 INVALID_PARAM。
- **baseline**：仅编码首批 SM3、HMAC-SM3、AES-GCM；其他算法/tuple/replay/secure-call 必须采用新增命名 profile 后接入，禁止私有字段扩展。
- **operation_codes**：['1=SM3_DIGEST', '2=HMAC_SM3_GENERATE', '3=HMAC_SM3_VERIFY', '16=AES_GCM']
- **mode_codes**：['0=NONE (SM3/HMAC)', '1=GCM_BASE', '2=GCM_EXT']
- **direction_codes**：['0=NONE (SM3/HMAC)', '1=ENCRYPT', '2=DECRYPT']
- **action_codes**：['0=ONESHOT', '1=INIT', '2=UPDATE', '3=FINAL']
- **segment_codes**：['1=PAYLOAD', '2=AAD', '3=NONCE_IV', '4=EXPECTED_TAG', '5=DIGEST_TAG']
- **status_codes**：['0=OK', '1=UNSUPPORTED', '2=INVALID_PARAM', '3=SEGMENT_ERROR', '4=LENGTH_ERROR', '5=KEY_DENIED', '6=AUTH_FAIL', '7=CANCELLED', '8=ENTROPY_ERROR', '9=INTERNAL_ERROR', '10=SERVICE_TIMEOUT', '11=DELIVERY_ERROR', '12=DELIVERY_UNKNOWN', '13=TOO_LATE', '14=BUSY']
- **detail_codes**：['0=NONE', '1=ID_CONFLICT']
- **management_codes**：['1=CANCEL', '2=ZEROIZE', '3=QUIESCE', '4=REVOKE', '5=QUERY']
- **scope_codes**：['0=COMMAND', '1=CONTEXT', '2=INSTANCE', '3=OWNER', '4=KEY_EPOCH']
- **key_binding_layout**：entry i 位于 [104*i +: 104]：role[7:0]、object_ref[71:8]、key_epoch[103:72]；role 1=MAC_KEY、2=CIPHER_KEY；最多4项，本基线带key操作恰好1项；未用项全0。
- **segment_layout**：entry i 位于 [91*i +: 91]：kind[7:0]、subtype[15:8]、present[16]、length_known[17]、length[81:18]、phase_end[82]、reserved[90:83]；最多16项；本profile subtype/reserved=0；有效项present=1/length_known=1；未用项全0。
- **cmd_atomic**：固定 header、key bindings 与全部 segment descriptors 在同一 cmd 握手原子接受；segment_count=0..16。不得用未握手侧带改变命令。
- **inherit**：INIT/ONESHOT inherit=0；UPDATE/FINAL inherit=1 时 mode/direction/policy_epoch/key_count/key_bits/key_bindings/out_len/tag_len/总长字段为0并继承；operation仍须与context匹配。inherit=0时上述锁定字段必须逐项相同。
- **key_length**：cmd_key_bits是公开的密钥长度；AES_GCM仅128/192/256，SM3_DIGEST必须0，HMAC为8的正整数倍且不超过MAX_KEY_BYTES*8。KEY_LOAD请求length=key_bits/8，可信服务必须校验对象的完整实际长度相等，禁止读前缀截断后当作另一长度密钥；组件再次核对rsp_total_length、连续fragment和最终字节数，不一致报KEY_DENIED并清除。INIT锁定，继承/显式匹配规则同其他锁定字段。
- **data_rules**：低lane首字节；非末拍keep全1，末拍低位连续且非0；空段无数据拍；last仅终结片段。segment_index引用本命令有效描述符；dout序号为本操作输出顺序，从0开始。
- **input_order**：SM3/HMAC PAYLOAD 后可有EXPECTED_TAG(仅verify终结)；GCM NONCE_IV→AAD→PAYLOAD→EXPECTED_TAG(仅decrypt终结)。nonce仅INIT/ONESHOT，tag仅FINAL/ONESHOT；phase_end关闭逻辑阶段。
- **identity**：可信入口分配request_seq；重复活跃task按新seq拒绝，不终结原task。同context最多一个更新；不同context允许乱序完成。
- **completion**：成功cpl在本命令全部输出握手后；失败不等待不存在的成功输出；先隔离/清除。UPDATE auth_valid=0。verify终态auth_valid=1；auth_ok仅成功认证为1。
- **output_security**：AEAD decrypt provisional=1且只到可信staging；SECRET普通dout始终禁止，secret字段必须0；不能以标记代替安全服务通道。
- **key_service**：key请求/交付采用独立IFC-CRYPTO_SECRET-001，不在普通CCI内复用数据；平台可信client保证nonce/usage责任，managed策略使用独立服务。
- **forward_progress**：至少1条独立mgmt请求credit及响应资源；普通dout满不能耗尽错误完成资源；外部永不响应则隔离/锁定，不宣称取消成功。
- **capability_image**：只读32-bit words：word0=0x00020000；word1=DATA_W；word2=operation bitmap(bit0 digest,bit1 hmac-gen,bit2 hmac-verify,bit3 aes-gcm)；word3=mode bitmap(bit0 base,bit1 ext)；word4=CONTEXTS；word5=TASK_SLOTS；word6=MAX_MESSAGE_BYTES；word7=MAX_AAD_BYTES；word8=MAX_OUTPUT_BYTES；word9=STAGING_BYTES；word10=SERVICE_WATCHDOG_CYCLES；word11=MAX_KEY_BYTES；word12=key bits mask(bit0 128,bit1 192,bit2 256)；word13=MAX_PREFIX_BYTES,last=1。0..12 last=0；越界INVALID_PARAM/data=0/last=1。能力与manifest必须一致。
