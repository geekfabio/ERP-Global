import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../errors/result.dart';
import '../network/api_client.dart';
import 'api_sync_repository.dart';
import 'conflict_resolver.dart';
import 'outbox_store.dart';
import 'sync_binding.dart';
import 'sync_engine.dart';
import 'sync_mock_handlers.dart';
import 'sync_models.dart';
import 'sync_repository.dart';

/// Ligações entidade → armazenamento local. Cada módulo acrescenta a sua em
/// `main.dart` (o `core` não conhece `features/`). Vazio = nada sincroniza.
final syncBindingsProvider = Provider<List<SyncEntityBinding>>(
  (ref) => const [],
);

final conflictPoliciesProvider = Provider<ConflictPolicies>(
  (ref) => const ConflictPolicies(),
);

final outboxStoreProvider = Provider<OutboxStore>(
  (ref) => OutboxStore(ref.watch(appDatabaseProvider)),
);

final syncRepositoryProvider = Provider<SyncRepository>(
  (ref) => ApiSyncRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final syncMockHandlersProvider = Provider<SyncMockHandlers>(
  (ref) => SyncMockHandlers(),
);

final syncEngineProvider = Provider<SyncEngine>(
  (ref) => SyncEngine(
    outbox: ref.watch(outboxStoreProvider),
    repository: ref.watch(syncRepositoryProvider),
    bindings: ref.watch(syncBindingsProvider),
    policies: ref.watch(conflictPoliciesProvider),
  ),
);

/// Entradas da outbox em tempo real.
final outboxEntriesProvider = StreamProvider.autoDispose<List<OutboxEntry>>(
  (ref) => ref.watch(outboxStoreProvider).watchAll(),
);

final outboxCountsProvider = StreamProvider.autoDispose<OutboxCounts>(
  (ref) => ref.watch(outboxStoreProvider).watchCounts(),
);

/// Acções do ecrã de pendentes/erros.
class SyncActions {
  const SyncActions(this._ref);

  final Ref _ref;

  Future<SyncReport> syncNow() => _ref.read(syncEngineProvider).run();

  /// Põe o registo de novo em `pending` e tenta já.
  Future<SyncReport> retry(String entity, String entityId) async {
    await _ref.read(outboxStoreProvider).retry(entity, entityId);
    return syncNow();
  }

  Future<SyncReport> retryAll() async {
    await _ref.read(outboxStoreProvider).retryAll();
    return syncNow();
  }

  Future<Result<void>> discard(String entity, String entityId) =>
      _ref.read(syncEngineProvider).discard(entity, entityId);
}

final syncActionsProvider = Provider<SyncActions>(SyncActions.new);
