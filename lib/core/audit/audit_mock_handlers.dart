import '../network/mock/mock_api_registry.dart';
import '../network/mock/mock_query.dart';
import '../network/mock/mock_types.dart';
import '../network/mock/mock_validator.dart';
import '../utils/seed_generator.dart';
import 'audit_log_model.dart';

/// Handlers de `/v1/audit-logs` (docs/07-mock-api.md). O registo é só de
/// acrescentar: não há PATCH nem DELETE. `POST /__mock/reset` repõe o seed.
class AuditMockHandlers implements MockApiModule {
  AuditMockHandlers({this.seed = 21, this.count = 120}) {
    _reset();
  }

  final int seed;
  final int count;

  late List<AuditLogModel> _logs;

  void _reset() => _logs = buildAuditSeed(seed: seed, count: count);

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/audit-logs', _list)
      ..post('/v1/audit-logs', _create);
  }

  static final _spec = MockListSpec<AuditLogModel>(
    sortable: {
      'createdAt': (l) => l.createdAt,
      'entity': (l) => l.entity,
      'actorName': (l) => foldText(l.actorName),
    },
    filterable: {
      'entity': (l) => l.entity,
      'action': (l) => l.action.name,
      'actorId': (l) => l.actorId,
    },
    searchText: (l) => '${l.actorName} ${l.entity} ${l.entityId ?? ''}',
    defaultSort: const ['-createdAt'],
  );

  MockResponse _list(MockRequest req) {
    final errors = <String, String>{};
    DateTime? date(String key) {
      final raw = req.query[key];
      if (raw == null) return null;
      final parsed = DateTime.tryParse(raw);
      if (parsed == null) errors[key] = 'Data inválida (ISO-8601)';
      return parsed?.toUtc();
    }

    final from = date('from');
    final to = date('to');
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    return mockPaginate(
      _logs.where(
        (l) =>
            (from == null || !l.createdAt.isBefore(from)) &&
            (to == null || l.createdAt.isBefore(to)),
      ),
      req,
      toJson: (l) => l.toJson(),
      spec: _spec,
    );
  }

  MockResponse _create(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    MockValidator(body)
      ..required('actorId')
      ..required('entity')
      ..required('action')
      ..throwIfInvalid();
    body['id'] ??= SeedGenerator(
      DateTime.now().microsecondsSinceEpoch,
    ).ulid(DateTime.now().toUtc());
    body['institutionId'] ??= 'mock';
    body['createdAt'] ??= DateTime.now().toUtc().toIso8601String();
    body['actorName'] ??= body['actorId'];
    final AuditLogModel entry;
    try {
      entry = AuditLogModel.fromJson(body);
    } on Object {
      throw const MockApiException.badRequest('Entrada de auditoria inválida');
    }
    _logs.add(entry);
    return MockResponse.created(entry.toJson());
  }
}

/// Seed determinístico: acções plausíveis de vários utilizadores nos últimos dias.
List<AuditLogModel> buildAuditSeed({int seed = 21, int count = 120}) {
  final gen = SeedGenerator(seed);
  final r = gen.random;
  final base = DateTime.utc(2026, 1, 1);
  const actors = [
    ('01ACTOR0000000000000000001', 'Administrador Geral'),
    ('01ACTOR0000000000000000002', 'Secretaria Académica'),
    ('01ACTOR0000000000000000003', 'Tesouraria'),
  ];
  const entities = ['student', 'invoice', 'grade', 'enrollment', 'user'];
  final out = <AuditLogModel>[];
  for (var i = 0; i < count; i++) {
    final at = base.add(Duration(hours: i * 7 + r.range(0, 5)));
    final actor = actors[r.nextInt(actors.length)];
    final action = AuditAction.values[r.nextInt(4)];
    final entity = entities[r.nextInt(entities.length)];
    out.add(
      AuditLogModel(
        id: gen.ulid(at),
        institutionId: 'mock',
        createdAt: at,
        actorId: actor.$1,
        actorName: actor.$2,
        entity: entity,
        entityId: gen.ulid(at),
        action: action,
        before: action == AuditAction.create
            ? null
            : {'status': 'active', 'version': i},
        after: action == AuditAction.delete
            ? null
            : {'status': 'inactive', 'version': i + 1},
      ),
    );
  }
  return out;
}
