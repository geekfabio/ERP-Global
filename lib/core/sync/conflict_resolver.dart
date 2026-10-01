import 'dart:convert';

/// Política de conflito de uma entidade (docs/06-modelo-de-dados.md).
enum ConflictPolicy {
  /// Dados de baixo risco: fusão por campo, o mais recente ganha nos choques.
  fieldMerge,

  /// Financeiro/numeração fiscal: o servidor decide; a alteração local cai.
  serverWins,
}

/// Política por entidade. Financeiro e numeração fiscal são `serverWins`.
class ConflictPolicies {
  const ConflictPolicies({
    this.overrides = const {},
    this.serverWinsEntities = financialEntities,
  });

  static const financialEntities = {
    'invoice',
    'payment',
    'receipt',
    'charge',
    'fee',
    'cash_session',
    'ledger_entry',
    'journal_entry',
    'fiscal_document',
  };

  final Map<String, ConflictPolicy> overrides;
  final Set<String> serverWinsEntities;

  ConflictPolicy of(String entity) =>
      overrides[entity] ??
      (serverWinsEntities.contains(entity)
          ? ConflictPolicy.serverWins
          : ConflictPolicy.fieldMerge);
}

/// Resultado da resolução de um conflito.
class ConflictResolution {
  const ConflictResolution({
    required this.policy,
    required this.merged,
    required this.acceptServer,
    this.clashedFields = const [],
  });

  final ConflictPolicy policy;

  /// Registo final (só relevante quando [acceptServer] é `false`).
  final Map<String, dynamic> merged;

  /// `true` = nada a enviar; o registo local passa a ser a versão do servidor.
  final bool acceptServer;

  /// Campos alterados dos dois lados, resolvidos pelo mais recente.
  final List<String> clashedFields;
}

/// Campos de controlo que nunca entram na fusão (ficam os do servidor).
const _metaFields = {
  'id',
  'institutionId',
  'campusId',
  'createdAt',
  'updatedAt',
  'deletedAt',
  'syncState',
};

bool _same(Object? a, Object? b) =>
    jsonEncode(_canon(a)) == jsonEncode(_canon(b));

Object? _canon(Object? v) => switch (v) {
  Map() => {
    for (final k in (v.keys.map((k) => '$k').toList()..sort())) k: _canon(v[k]),
  },
  List() => [for (final e in v) _canon(e)],
  _ => v,
};

/// Resolve o conflito entre a alteração local ([local]) e o estado actual do
/// servidor ([server]). [base] é o registo da última sincronização (opcional).
///
/// - `serverWins` ou remoção local: aceita o servidor.
/// - `fieldMerge`: por campo, quem alterou face à [base] ganha; se ambos
///   alteraram (ou não há base) ganha o `updatedAt` mais recente (empate →
///   servidor).
ConflictResolution resolveConflict({
  required ConflictPolicy policy,
  required bool localIsDelete,
  required Map<String, dynamic> local,
  required Map<String, dynamic> server,
  Map<String, dynamic>? base,
}) {
  if (policy == ConflictPolicy.serverWins || localIsDelete) {
    return ConflictResolution(
      policy: policy,
      merged: Map.of(server),
      acceptServer: true,
    );
  }
  final localAt = DateTime.tryParse('${local['updatedAt']}');
  final serverAt = DateTime.tryParse('${server['updatedAt']}');
  final localNewer =
      localAt != null && (serverAt == null || localAt.isAfter(serverAt));

  final merged = Map<String, dynamic>.of(server);
  final clashed = <String>[];
  var usedLocal = false;
  for (final key in {...local.keys, ...server.keys}) {
    if (_metaFields.contains(key)) continue;
    final l = local[key];
    final s = server[key];
    if (_same(l, s)) continue;
    final bool takeLocal;
    if (base == null) {
      clashed.add(key);
      takeLocal = localNewer;
    } else {
      final localChanged = !_same(l, base[key]);
      final serverChanged = !_same(s, base[key]);
      if (localChanged && serverChanged) {
        clashed.add(key);
        takeLocal = localNewer;
      } else {
        takeLocal = localChanged;
      }
    }
    if (takeLocal) {
      usedLocal = true;
      if (local.containsKey(key)) {
        merged[key] = l;
      } else {
        merged.remove(key);
      }
    }
  }
  return ConflictResolution(
    policy: policy,
    merged: merged,
    acceptServer: !usedLocal,
    clashedFields: clashed..sort(),
  );
}
