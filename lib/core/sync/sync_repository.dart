import '../errors/result.dart';
import 'sync_models.dart';

/// Resposta do servidor a uma alteração aceite.
class PushResult {
  const PushResult({required this.record});

  /// Registo como o servidor o guardou (`null` numa remoção).
  final Map<String, dynamic>? record;
}

/// Envio de alterações locais e leitura do estado do servidor.
///
/// Erros chegam como `Failure`: `NetworkFailure` (offline), `AuthFailure`,
/// `UnknownFailure(code: 'CONFLICT')` (409), `NOT_FOUND`, `ValidationFailure`…
abstract interface class SyncRepository {
  Future<Result<PushResult>> push(OutboxBatch batch);

  /// Estado actual do servidor; `NOT_FOUND` se não existir (ou foi removido).
  Future<Result<Map<String, dynamic>>> fetch(String entity, String entityId);
}
