import '../errors/result.dart';
import '../network/api_envelope.dart';
import 'audit_log_model.dart';

/// Pesquisa de auditoria (filtros e paginação no servidor/handler).
class AuditQuery {
  const AuditQuery({
    this.page = 1,
    this.pageSize = 20,
    this.q,
    this.entity,
    this.action,
    this.actorId,
    this.from,
    this.to,
  });

  final int page;
  final int pageSize;

  /// Texto livre: utilizador, recurso, identificador.
  final String? q;
  final String? entity;
  final AuditAction? action;
  final String? actorId;

  /// Intervalo (UTC, `from` inclusivo, `to` exclusivo).
  final DateTime? from;
  final DateTime? to;

  bool get hasFilters =>
      q != null ||
      entity != null ||
      action != null ||
      actorId != null ||
      from != null ||
      to != null;

  AuditQuery copyWith({int? page, int? pageSize}) => AuditQuery(
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    q: q,
    entity: entity,
    action: action,
    actorId: actorId,
    from: from,
    to: to,
  );
}

/// Registo de auditoria. É só de acrescentar e consultar: nunca se edita nem apaga.
abstract interface class AuditRepository {
  Future<Result<PagedList<AuditLogModel>>> list(AuditQuery query);

  /// O `id` (ULID) e `createdAt` são gerados no cliente (offline first).
  Future<Result<AuditLogModel>> record(AuditLogModel entry);
}
