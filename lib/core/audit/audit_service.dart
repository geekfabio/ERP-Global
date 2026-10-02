import '../errors/failure.dart';
import '../errors/result.dart';
import '../utils/seed_generator.dart';
import 'audit_log_model.dart';
import 'audit_repository.dart';

/// Utilizador autenticado que pratica a acção auditada.
class AuditActor {
  const AuditActor({
    required this.id,
    required this.name,
    required this.institutionId,
  });

  final String id;
  final String name;
  final String institutionId;
}

/// Regista acções sensíveis no audit log (docs/01-perfis-e-permissoes.md):
/// `await ref.read(auditServiceProvider).record(entity: 'student', ...)`.
class AuditService {
  AuditService({
    required this._repository,
    required this._actor,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AuditRepository _repository;
  final AuditActor? Function() _actor;
  final DateTime Function() _now;

  /// Regista [action] sobre [entity] (com [before]/[after]). Nunca lança: uma
  /// falha de auditoria devolve `Err` e não deve anular a acção de negócio.
  Future<Result<AuditLogModel>> record({
    required String entity,
    required AuditAction action,
    String? entityId,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  }) async {
    final actor = _actor();
    if (actor == null) {
      return Err(AuthFailure(message: 'Sem sessão para registar a auditoria.'));
    }
    final at = _now().toUtc();
    final entry = AuditLogModel(
      id: SeedGenerator(at.microsecondsSinceEpoch).ulid(at),
      institutionId: actor.institutionId,
      createdAt: at,
      actorId: actor.id,
      actorName: actor.name,
      entity: entity,
      entityId: entityId,
      action: action,
      before: before,
      after: after,
    );
    return _repository.record(entry);
  }
}
