/// Liga uma entidade ao motor de sync: como aplicar no armazenamento local o
/// resultado de um envio. Cada módulo regista a sua (o `core` não conhece
/// `features/`), via `syncBindingsProvider`.
abstract interface class SyncEntityBinding {
  /// Nome da entidade na outbox (ex.: `student`).
  String get entity;

  /// O servidor aceitou a alteração: marca o registo local como `synced` com
  /// a versão do servidor ([record] é `null` numa remoção).
  Future<void> markSynced(String entityId, Map<String, dynamic>? record);

  /// O servidor decidiu (conflito): o registo local passa a ser [server].
  Future<void> applyServer(String entityId, Map<String, dynamic> server);

  /// A criação local foi anulada antes de chegar ao servidor: apaga o registo.
  Future<void> purge(String entityId);
}
