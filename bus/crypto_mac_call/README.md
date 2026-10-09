# 可信HMAC子调用接口规格

接口 `IFC-CRYPTO_MAC_CALL-001` / `aix_crypto_mac_call`，version 0.1.0，owner
security-crypto，draft。消费者crypto_sha2与可信KDF端点；依据SHA2.010、
COM服务生命周期CCS-03，非普通CCI软件入口。

caller/callee单时钟clk、低有效reset_n异步断言同步释放；RESET中valid=0。
REQ/RSP、PUBLIC_DATA、CONTROL_REQ/CONTROL_RSP分别ready/valid，停顿保持
valid与全payload，取消只能协调排空或两端reset。全部通道携带父完整身份
与独立64-bit invocation_id；MAC物理bank不从父context_id推导。

REQ action=0 RESERVE/1 EXECUTE。RESERVE冻结全部参数并预留独立child bank、
completion与服务资源；RSP返回lease_token。caller必须先取得预留再提交父任务，
不能占满普通Hash资源后等待child。EXECUTE只携带相同身份/调用ID/lease，
其它参数必须零；算法用冻结快照。控制2 RELEASE未执行预留、3 CANCEL、
4 QUERY有独立credit。RESERVE不读取秘密、不扣usage、不启动CORE。

固定template：0 PROTECTED_HMAC、1 HKDF_EXTRACT、2 HKDF_EXPAND。
PROTECTED_HMAC为一个SECRET消息part，key为MAC_KEY REF，支持GEN/VERIFY；
HKDF_EXTRACT为一个SECRET IKM part，key为PUBLIC_PARAMETER salt（可零或短）；
HKDF_EXPAND为PRK REF及[前轮SECRET T（iteration>1）、PUBLIC info、内部COUNTER]，
iteration范围1..255。不得接受其它part排列或软件可构造秘密执行图。
message_parts每项232 bits，低part先：kind8、object_ref64、object_epoch32、
offset64、length64。固定字段由契约语义声明；无效/未使用字段零。

PUBLIC_DATA只承载公开salt/info/expected Tag；parent/child/lease/source/offset
必须精确匹配，低lane先、keep连续，last按声明长度。IKM/PRK/T由callee自己的
crypto_secret provider client取得，不能借此通道、普通din/dout、DMA/PIO导出。
普通MAC key最小16 B保持；PUBLIC_PARAMETER只在已授权EXTRACT路径使用，
不伪装长期secret handle。权限由可信caller缩减父授权、provider逐role/epoch/
use校验；公开salt的计算也须先完成父秘密消息或sink的授权确认。

GEN写受保护sink PREPARE/WRITE/COMMIT，RSP只返回ACTIVE object_ref/epoch/长度。
VERIFY先真实usage预留、固定声明长度比较，不导出Tag。QUERY使用原事务，
UNKNOWN锁定恢复域、禁止重做算法；CANCEL与原成功终态、TOO_LATE分开。
终结RSP只有在实际bank清除后cleanup_done，失败不返回秘密data。
provider物理request_id独立唯一，与caller invocation_id不混用；
RESULT_PREPARE/WRITE/COMMIT/QUERY保持该结果事务同ID。父/子ID均不移位截断。

能力只有命名profile `IFC-PROFILE-CRYPTO-MAC-CALL-SHA2-0-1`，具备全部五通道
才允许SECURE_SERVICE装配。当前仅接口契约；不宣称callee RTL或系统资格已完成。
