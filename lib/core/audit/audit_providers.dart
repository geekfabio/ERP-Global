import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../network/api_client.dart';
import '../network/api_envelope.dart';
import 'api_audit_repository.dart';
import 'audit_log_model.dart';
import 'audit_mock_handlers.dart';
import 'audit_repository.dart';
import 'audit_service.dart';

/// Utilizador da sessão para a auditoria (`null` = sem sessão). O `core` não
/// depende de `features/`: a app liga isto ao módulo de auth em `main.dart`.
final auditActorProvider = Provider<AuditActor?>((ref) => null);

final auditRepositoryProvider = Provider<AuditRepository>(
  (ref) => ApiAuditRepository(ref.watch(apiClientProvider)),
);

final auditServiceProvider = Provider<AuditService>(
  (ref) => AuditService(
    repository: ref.watch(auditRepositoryProvider),
    actor: () => ref.read(auditActorProvider),
  ),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final auditMockHandlersProvider = Provider<AuditMockHandlers>(
  (ref) => AuditMockHandlers(),
);

/// Filtros e página da consulta. Qualquer alteração (excepto a página) volta à página 1.
class AuditQueryNotifier extends Notifier<AuditQuery> {
  @override
  AuditQuery build() => const AuditQuery();

  AuditQuery _with({
    required String? q,
    required String? entity,
    required AuditAction? action,
    required DateTime? from,
    required DateTime? to,
  }) => AuditQuery(
    pageSize: state.pageSize,
    q: q,
    entity: entity,
    action: action,
    from: from,
    to: to,
  );

  void setSearch(String text) {
    final q = text.trim();
    final s = state;
    state = _with(
      q: q.isEmpty ? null : q,
      entity: s.entity,
      action: s.action,
      from: s.from,
      to: s.to,
    );
  }

  void setEntity(String? entity) {
    final s = state;
    state = _with(
      q: s.q,
      entity: entity,
      action: s.action,
      from: s.from,
      to: s.to,
    );
  }

  void setAction(AuditAction? action) {
    final s = state;
    state = _with(
      q: s.q,
      entity: s.entity,
      action: action,
      from: s.from,
      to: s.to,
    );
  }

  /// [to] é inclusivo para o utilizador (dia inteiro); o servidor recebe-o exclusivo.
  void setRange(DateTime? from, DateTime? to) {
    final s = state;
    state = _with(
      q: s.q,
      entity: s.entity,
      action: s.action,
      from: from?.toUtc(),
      to: to?.toUtc().add(const Duration(days: 1)),
    );
  }

  void setPage(int page) => state = state.copyWith(page: page);
  void setPageSize(int size) => state = state.copyWith(page: 1, pageSize: size);
  void clear() => state = AuditQuery(pageSize: state.pageSize);
}

final auditQueryProvider = NotifierProvider<AuditQueryNotifier, AuditQuery>(
  AuditQueryNotifier.new,
);

/// Página actual do registo. Um `Failure` chega à UI como `AsyncError`.
final auditListProvider = FutureProvider.autoDispose<PagedList<AuditLogModel>>((
  ref,
) async {
  final query = ref.watch(auditQueryProvider);
  final result = await ref.watch(auditRepositoryProvider).list(query);
  return result.getOrThrow();
}, retry: (_, _) => null);
