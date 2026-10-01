import 'dart:convert';

import '../database/app_database.dart';

/// Operação local por enviar (igual à coluna `operation` da outbox).
enum SyncOperation { create, update, delete }

/// Estado de uma entrada da outbox.
enum OutboxStatus { pending, error }

/// Estado de sincronização apresentado ao utilizador (pendente/erro/ok).
enum SyncStatus { ok, pending, error }

/// Uma alteração local por enviar (linha de `sync_outbox`).
class OutboxEntry {
  const OutboxEntry({
    required this.seq,
    required this.entity,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    this.base,
    this.attempts = 0,
    this.status = OutboxStatus.pending,
    this.lastError,
  });

  factory OutboxEntry.fromRow(OutboxRow r) => OutboxEntry(
    seq: r.seq,
    entity: r.entity,
    entityId: r.entityId,
    operation: SyncOperation.values.firstWhere(
      (o) => o.name == r.operation,
      orElse: () => SyncOperation.update,
    ),
    payload: _decode(r.payload) ?? const {},
    base: _decode(r.baseJson),
    createdAt: r.createdAt.toUtc(),
    attempts: r.attempts,
    status: r.status == 'error' ? OutboxStatus.error : OutboxStatus.pending,
    lastError: r.lastError,
  );

  final int seq;
  final String entity;
  final String entityId;
  final SyncOperation operation;
  final Map<String, dynamic> payload;

  /// Registo como estava na última sincronização (pode faltar).
  final Map<String, dynamic>? base;
  final DateTime createdAt;
  final int attempts;
  final OutboxStatus status;
  final String? lastError;

  static Map<String, dynamic>? _decode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final v = jsonDecode(raw);
    return v is Map<String, dynamic> ? v : null;
  }
}

/// Alteração pronta a enviar: as entradas de um mesmo registo fundidas numa só.
class OutboxBatch {
  const OutboxBatch({
    required this.entity,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.seqs,
    this.base,
  });

  final String entity;
  final String entityId;
  final SyncOperation operation;
  final Map<String, dynamic> payload;
  final Map<String, dynamic>? base;

  /// Linhas da outbox que esta alteração substitui.
  final List<int> seqs;

  /// `updatedAt` conhecido do servidor quando a alteração partiu.
  String? get baseUpdatedAt => base?['updatedAt'] as String?;
}

/// Funde as entradas por registo (`entity` + `entityId`), por ordem de `seq`.
///
/// - `create` + `update`* → um `create` com o último payload;
/// - `create` + … + `delete` → o servidor nunca soube do registo: vai para
///   `dropped` (nada a enviar);
/// - registos com alguma entrada em erro ficam bloqueados até o utilizador
///   agir (evita enviar alterações novas à frente de uma anterior falhada).
({List<OutboxBatch> batches, List<OutboxBatch> dropped}) coalesceOutbox(
  List<OutboxEntry> entries,
) {
  final groups = <String, List<OutboxEntry>>{};
  for (final e in [...entries]..sort((a, b) => a.seq.compareTo(b.seq))) {
    groups.putIfAbsent('${e.entity}/${e.entityId}', () => []).add(e);
  }
  final batches = <OutboxBatch>[];
  final dropped = <OutboxBatch>[];
  for (final g in groups.values) {
    if (g.any((e) => e.status == OutboxStatus.error)) continue;
    final first = g.first;
    final last = g.last;
    final created = first.operation == SyncOperation.create;
    final deleted = last.operation == SyncOperation.delete;
    final op = deleted
        ? SyncOperation.delete
        : created
        ? SyncOperation.create
        : SyncOperation.update;
    final batch = OutboxBatch(
      entity: first.entity,
      entityId: first.entityId,
      operation: op,
      payload: g
          .lastWhere((e) => e.payload.isNotEmpty, orElse: () => last)
          .payload,
      base: first.base,
      seqs: [for (final e in g) e.seq],
    );
    (created && deleted ? dropped : batches).add(batch);
  }
  return (batches: batches, dropped: dropped);
}

/// Contagens para o selector de estado na UI.
class OutboxCounts {
  const OutboxCounts({this.pending = 0, this.error = 0});

  final int pending;
  final int error;
  int get total => pending + error;
}
