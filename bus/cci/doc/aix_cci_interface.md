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
| cmd | 36 | ready_valid |
| din | 14 | ready_valid |
| dout | 16 | ready_valid |
| cpl | 21 | ready_valid |
| mgmt_req | 14 | ready_valid |
| mgmt_rsp | 14 | ready_valid |
| cap_req | 4 | ready_valid |
| cap_rsp | 7 | ready_valid |
| replay_req | 14 | ready_valid |
| replay_rsp | 15 | ready_valid |

## 语义

- **transfer**：valid && ready；停顿时 valid 和 payload 稳定；取消通过握手丢弃或双端协同 reset，不单边撤 valid。
- **reset**：旧 epoch 响应排空/隔离前不得复用身份；硬复位不伪造 completion。
- **ordering**：每通道传输顺序固定；不同 request 可乱序响应，必须匹配完整身份与 request_id。
- **units**：长度/offset 为 bytes；无效/保留字段为零；未知枚举报 INVALID_PARAM。
- **baseline**：CCI 0.2 draft: common channels with named operation profiles; SM3/HMAC/AES/Ascon existing codes unchanged. SHA2 profile adds operation codes without changing channel signals or packed aggregate size. ChaCha/Poly optional counter fields require named chacha_poly profile; other profiles tie both fields zero. RSA optional command fields require named rsa profile; all non-RSA profiles tie all seven fields zero. Added fields change packed aggregate size; consumers must regenerate types and use named fields, not old raw bit offsets.
- **operation_codes**：['1=SM3_DIGEST', '2=HMAC_SM3_GENERATE', '3=HMAC_SM3_VERIFY', '16=AES_GCM', '32=ASCON_AEAD128_ENC', '33=ASCON_AEAD128_DEC', '34=ASCON_HASH256', '35=ASCON_XOF128', '36=ASCON_CXOF128', '48=CHACHA20_XOR', '49=POLY1305_GENERATE', '50=POLY1305_VERIFY', '51=CHACHA20_POLY1305_ENC', '52=CHACHA20_POLY1305_DEC', '53=QUIC_HP_CHACHA', '64=SHA224_DIGEST', '65=SHA256_DIGEST', '66=SHA384_DIGEST', '67=SHA512_DIGEST', '68=SHA512_224_DIGEST', '69=SHA512_256_DIGEST', '70=HMAC_SHA224_GENERATE', '71=HMAC_SHA256_GENERATE', '72=HMAC_SHA384_GENERATE', '73=HMAC_SHA512_GENERATE', '74=HMAC_SHA512_224_GENERATE', '75=HMAC_SHA512_256_GENERATE', '76=HMAC_SHA224_VERIFY', '77=HMAC_SHA256_VERIFY', '78=HMAC_SHA384_VERIFY', '79=HMAC_SHA512_VERIFY', '80=HMAC_SHA512_224_VERIFY', '81=HMAC_SHA512_256_VERIFY', '96=RSA_PSS_SIGN', '97=RSA_PSS_VERIFY', '98=RSA_PKCS1V15_SIGN', '99=RSA_PKCS1V15_VERIFY', '100=RSA_OAEP_ENCRYPT', '101=RSA_OAEP_DECRYPT']
- **mode_codes**：['0=NONE (SM3/HMAC/Ascon)', '1=GCM_BASE', '2=GCM_EXT', '3=GCM_SIV']
- **direction_codes**：['0=NONE (SM3/HMAC/Ascon Hash/XOF/CXOF)', '1=ENCRYPT', '2=DECRYPT']
- **action_codes**：['0=ONESHOT', '1=INIT', '2=UPDATE', '3=FINAL']
- **segment_codes**：['1=PAYLOAD', '2=AAD', '3=NONCE_IV', '4=EXPECTED_TAG', '5=DIGEST_TAG', '6=CUSTOMIZATION', '7=SIGNATURE', '8=LABEL', '9=CIPHERTEXT', '10=PREHASH', '11=SECRET_MESSAGE']
- **status_codes**：['0=OK', '1=UNSUPPORTED', '2=INVALID_PARAM', '3=SEGMENT_ERROR', '4=LENGTH_ERROR', '5=KEY_DENIED', '6=AUTH_FAIL', '7=CANCELLED', '8=ENTROPY_ERROR', '9=INTERNAL_ERROR', '10=SERVICE_TIMEOUT', '11=DELIVERY_ERROR', '12=DELIVERY_UNKNOWN', '13=TOO_LATE', '14=BUSY']
- **detail_codes**：['0=NONE', '1=ID_CONFLICT']
- **management_codes**：['1=CANCEL', '2=ZEROIZE', '3=QUIESCE', '4=REVOKE', '5=QUERY']
- **scope_codes**：['0=COMMAND', '1=CONTEXT', '2=INSTANCE', '3=OWNER', '4=KEY_EPOCH']
- **key_binding_layout**：entry i 位于 [104*i +: 104]：role[7:0]、object_ref[71:8]、key_epoch[103:72]；role 1=MAC_KEY、2=CIPHER_KEY；最多4项，本基线带key操作恰好1项；未用项全0。
- **segment_layout**：entry i 位于 [91*i +: 91]：kind[7:0]、subtype[15:8]、present[16]、length_known[17]、length[81:18]、phase_end[82]、reserved[90:83]；最多16项；本profile subtype/reserved=0；有效项present=1/length_known=1；未用项全0。
- **cmd_atomic**：固定 header、key bindings 与全部 segment descriptors 在同一 cmd 握手原子接受；segment_count=0..16。不得用未握手侧带改变命令。
- **inherit**：INIT/ONESHOT inherit=0；UPDATE/FINAL inherit=1 时 mode/direction/policy_epoch/key_count/key_bits/key_bindings/out_len/tag_len/总长字段为0并继承；operation仍须与context匹配。inherit=0时上述锁定字段必须逐项相同。
- **key_length**：cmd_key_bits是公开的密钥长度；AES_GCM仅128/192/256，SM3/SHA2 DIGEST必须0，SM3 HMAC为8的正整数倍且不超过MAX_KEY_BYTES*8，SHA2 HMAC为128..MAX_KEY_BYTES*8且是8的整数倍。KEY_LOAD请求length=key_bits/8，可信服务必须校验对象的完整实际长度相等，禁止读前缀截断后当作另一长度密钥；组件再次核对rsp_total_length、连续fragment和最终字节数，不一致报KEY_DENIED并清除。INIT锁定，继承/显式匹配规则同其他锁定字段。
- **data_rules**：低lane首字节；非末拍keep全1，末拍低位连续且非0；空段无数据拍；last仅终结片段。segment_index引用本命令有效描述符；dout序号为本操作输出顺序，从0开始。
- **input_order**：SM3/SHA2/HMAC PAYLOAD 后可有EXPECTED_TAG(仅verify终结)；GCM NONCE_IV→AAD→PAYLOAD→EXPECTED_TAG(仅decrypt终结)。nonce仅INIT/ONESHOT，tag仅FINAL/ONESHOT；phase_end关闭逻辑阶段。
- **identity**：可信入口分配request_seq；重复活跃task按新seq拒绝，不终结原task。同context最多一个更新；不同context允许乱序完成。
- **completion**：成功cpl在本命令全部输出握手后；失败不等待不存在的成功输出；先隔离/清除。UPDATE auth_valid=0。verify终态auth_valid=1；auth_ok仅成功认证为1。
- **output_security**：AEAD decrypt provisional=1且只到可信staging；SECRET普通dout始终禁止，secret字段必须0；不能以标记代替安全服务通道。
- **key_service**：key请求/交付采用独立IFC-CRYPTO_SECRET-001，不在普通CCI内复用数据；平台可信client保证nonce/usage责任，managed策略使用独立服务。
- **forward_progress**：至少1条独立mgmt请求credit及响应资源；普通dout满不能耗尽错误完成资源；外部永不响应则隔离/锁定，不宣称取消成功。
- **capability_image**：只读32-bit words：word0=0x00020000；word1=DATA_W；word2=operation bitmap(bit0 digest,bit1 hmac-gen,bit2 hmac-verify,bit3 aes-gcm,bit4 ascon-aead-enc,bit5 ascon-aead-dec,bit6 ascon-hash256,bit7 ascon-xof128,bit8 ascon-cxof128)；word3=mode bitmap(bit0 base,bit1 ext)；word4=CONTEXTS；word5=TASK_SLOTS；word6=MAX_MESSAGE_BYTES；word7=MAX_AAD_BYTES；word8=MAX_OUTPUT_BYTES；word9=STAGING_BYTES；word10=SERVICE_WATCHDOG_CYCLES；word11=MAX_KEY_BYTES；word12=key bits mask(bit0 128,bit1 192,bit2 256)；word13=MAX_PREFIX_BYTES,last=1。0..12 last=0；越界INVALID_PARAM/data=0/last=1。能力与manifest必须一致。 ChaCha profile additionally uses word2 bits9 raw,10 poly-generate,11 poly-verify,12 AEAD-ENC,13 AEAD-DEC,14 HP; disabled bits zero. Base/Ascon consumers ignore unknown optional capability bits and never select operations outside their profile.
- **sha2_profile**：CCI_SHA2_0_2: operation 64..81；mode=NONE、direction=NONE；DIGEST 要求 key_count/key_bits/tag_len=0 且 out_len 等于算法摘要字节数；HMAC GENERATE/VERIFY 恰好一个 MAC_KEY binding，key_bits=128..MAX_KEY_BYTES*8 且为8的倍数，tag_len=16..digest_bytes； GENERATE out_len=tag_len，VERIFY out_len=0。输入仅 PAYLOAD，VERIFY 在 FINAL/ONESHOT 最后追加 EXPECTED_TAG；所有 nonce/AAD/counter/customization 字段为0或不存在。INIT 锁定精确 operation、 key epoch、tag/out length；UPDATE/FINAL 按 inherit 规则匹配。
- **sha2_capability_image**：sha2 profile 保持 word0..13 与 base 相同，但 word13 的 last=0；新增 word14 为 SHA2 operation bitmap：bit0..5 依次 SHA224/256/384/512/512_224/512_256 DIGEST， bit6..11 为对应 HMAC GENERATE，bit12..17 为对应 HMAC VERIFY，禁用能力位为0，word14 last=1。 非 sha2 profile 仍在 word13 last=1，且不得访问 word14。
- **ascon_profile**：Ascon操作使用mode=NONE；ENC/DEC方向必须分别ENCRYPT/DECRYPT，Hash/XOF/CXOF方向NONE。AEAD key_bits=128且CIPHER_KEY恰好1项；Hash族key_count/key_bits=0。AEAD NONCE_IV→AAD→PAYLOAD→EXPECTED_TAG(仅DEC终结)，NONCE_IV仅INIT/ONESHOT。CXOF CUSTOMIZATION subtype=0(S)仅INIT/ONESHOT且先于PAYLOAD；省略表示空S。Hash/XOF仅PAYLOAD。未用/保留字段为零。CCI普通dout不承载未认证明文；Ascon解密走独立crypto_staging。
- **chacha_poly_profile**：CCI_CHACHA_POLY_0_2: operation 48..53; mode=NONE; raw direction ENCRYPT/DECRYPT (same XOR), Poly/HP NONE, AEAD directions ENCRYPT/DECRYPT respectively; key_bits=256 and one key binding. raw/AEAD/HP use CIPHER_KEY and independent operation-bound service use; Poly uses MAC_KEY with trusted USAGE_RESERVE before KEY_LOAD. Other profiles forbid these operations.
- **chacha_counter**：Optional cmd_initial_counter:u32 and cmd_counter_present:bool are atomic cmd fields. raw INIT/ONESHOT: present=0 requires value=0 and means counter=1; present=1 selects exact u32. Explicit UPDATE/FINAL must match initial snapshot; inherit=1 requires both zero. All non-raw commands require both zero; AEAD payload starts at 1 and block0 stays secret.
- **chacha_segments**：raw NONCE_IV(12) then PAYLOAD; Poly PAYLOAD then EXPECTED_TAG(16,verify final only); AEAD NONCE_IV(12),AAD,PAYLOAD,EXPECTED_TAG(16,DEC final only); HP ONESHOT only, PAYLOAD sample(16), output PAYLOAD mask(5). raw/AEAD output payload then ENC DIGEST_TAG(16); Poly generate DIGEST_TAG(16), verify no dout. nonce only INIT/ONESHOT; zero fragments have no beats; phase_end prevents reopening AAD.
- **chacha_lengths**：raw out_len=message_total_len when known, otherwise 0 and cumulative payload output; AEAD out_len=message_total_len (payload only, tag excluded), DEC requires known total; Poly generate out_len=16, verify out_len=0; HP out_len=5; AEAD/Poly tag_len=16, others 0. Capacity limits never truncate a tag. Final totals must equal declared totals.
- **chacha_release**：DEC uses independent crypto_staging endpoint bound to message identity and generation; ordinary dout never carries provisional plaintext. INIT reserves full known message total; FINAL verifies before COMMIT, cpl waits endpoint confirmation. Non-final cpl has auth_valid=0. AUTH_FAIL has auth_valid=1/auth_ok=0 and waits abort/cleanup.
- **rsa_profile**：CCI_RSA_0_2: operation 96..101; mode=NONE. PSS/v1.5 use direction=NONE; OAEP uses ENCRYPT/DECRYPT. cmd_rsa_scheme is 1=PSS,2=PKCS1_V1_5_SIG,3=OAEP; hash_id and mgf_id are 1=SHA256,2=SHA384,3=SHA512 and must match; salt_len is 0..hLen and is zero outside PSS; input_form is 1=MESSAGE or 2=PREHASH; modulus_bits is 2048/3072/4096; private_key_format is 1=CRT2 and all other values are forbidden in v0.1.0. All seven fields are cmd-atomic and locked across INIT/UPDATE/FINAL; inherit=1 requires them zero and consumes the locked snapshot. Non-RSA operations require all seven fields zero.
- **rsa_key_bindings**：key binding role codes: 16=RSA_SIGN_PRIVATE,17=RSA_VERIFY_PUBLIC,18=RSA_ENCRYPT_PUBLIC, 19=RSA_DECRYPT_PRIVATE,20=RSA_SECRET_MESSAGE_READ,21=RSA_RESULT_SINK. PSS/v1.5 use exactly one role 16 or 17. OAEP encrypt uses roles 18 and 20; OAEP decrypt uses roles 19 and 21. Each object_ref/key_epoch is independently authorized by IFC-CRYPTO_SECRET-001; cmd_key_bits equals modulus_bits for the RSA key and is not the secret-message length.
- **rsa_segments**：MESSAGE uses PAYLOAD and may stream INIT/UPDATE/FINAL. PREHASH is exactly hLen in FINAL/ONESHOT. VERIFY adds SIGNATURE exactly k bytes. OAEP LABEL is optional and precedes SECRET_MESSAGE or CIPHERTEXT; OAEP encrypt declares SECRET_MESSAGE length but its bytes travel only over crypto_secret; OAEP decrypt carries CIPHERTEXT exactly k bytes. SIGNATURE/LABEL/CIPHERTEXT/PREHASH are complete in FINAL/ONESHOT. Segment descriptors and data beats obey common order/length/keep/last rules.
- **rsa_result_and_failure**：PSS/v1.5 sign and OAEP encrypt produce exactly k ordinary dout bytes. Signature verify produces no dout and completes with auth_valid=1/auth_ok. OAEP decrypt candidate plaintext never appears on dout; role 21 identifies the protected result sink and cpl exposes result_ref only after secret-service COMMIT. All OAEP format failures collapse to AUTH_FAIL; signature mismatches use auth_valid=1/auth_ok=0; neither exposes recovered encoding, expected digest, partial plaintext or failure position.
- **rsa_capability_image**：RSA profile keeps word0..13 baseline meanings, sets word13 last=0 and uses word14: bits0..5=PSS_SIGN/PSS_VERIFY/PKCS1V15_SIGN/PKCS1V15_VERIFY/OAEP_ENCRYPT/OAEP_DECRYPT; word15 modulus bitmap bits0..2=2048/3072/4096; word16 hash bitmap bits0..2=SHA256/384/512; word17 bit0=MESSAGE bit1=PREHASH; word18 bit0=CRT2 and no STANDARD_D bit in v0.1.0; word19 security profile; word20 provider bit0=internal and last=1. Disabled capability bits are zero; out-of-range word reads return INVALID_PARAM/data=0/last=1.
- **replay_profile**：CCI_REPLAY_V1: operation=16 mode=3 direction=ENCRYPT action=ONESHOT inherit=0; key_count=1 role=CIPHER_KEY key_bits=128/256; tag_len=16 out_len=message_total_len+16. cmd_replay_ref is opaque and nonzero, message_total_known=1; immutable lease/snapshot reserved before cmd admission. First-pass NONCE_IV(12 bytes), optional AAD then PAYLOAD exactly message_total_len, din_pass_index=0. One replay request at a time, pass_index=1, offset=0 length=message_total_len; requests carry complete identity, request_id and replay_ref. Response repeats all correlation fields and exact length, status OK before any second-pass din. Second pass only PAYLOAD, same segment_index, pass_index=1; no nonce/AAD re-absorption. Original consumed excludes replay; replay_bytes counts second-pass bytes. All second-pass input completes before any dout. Invalid lease/range, short read or response failure terminate without ciphertext. Cancel/reset drains outstanding replay traffic before cleanup and lease release; no physical addresses. Profiles without replay tie replay payloads/valid and din_pass_index/cmd_replay_ref zero. Capability word13 last=0, word14 bit0=immutable snapshot bit1=one outstanding replay; word14 last=1. Superset generated views include optional service handshakes; disabled profiles never assert their valid.
