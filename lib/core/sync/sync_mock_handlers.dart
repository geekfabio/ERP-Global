import '../network/mock/mock_api_registry.dart';
import '../network/mock/mock_types.dart';
import '../network/mock/mock_validator.dart';

/// Handlers de `/v1/sync` (docs/07-mock-api.md). Guardam, em memória, a versão
/// do servidor de cada registo por entidade e detectam conflitos como o
/// servidor real: `update`/`delete` só são aceites se `baseUpdatedAt` for o
/// `updatedAt` actual (`409 CONFLICT` caso contrário). `create` de um id que
/// já existe é idempotente (repetição após resposta perdida).
class SyncMockHandlers implements MockApiModule {
  SyncMockHandlers({DateTime Function()? now})
    : _now = now ?? (() => DateTime.now().toUtc());

  final DateTime Function() _now;

  final Map<String, Map<String, Map<String, dynamic>>> _store = {};

  /// Configuração de sincronização da instituição (`/v1/sync/settings`).
  Map<String, dynamic> _settings = _defaultSettings();

  static Map<String, dynamic> _defaultSettings() => {
    'mode': 'localOnly',
    'auto': true,
    'intervalMinutes': 15,
    'lastSyncAt': null,
  };

  /// Estado do servidor para [entity]/[id] (útil em testes e fixtures).
  Map<String, dynamic>? record(String entity, String id) => _store[entity]?[id];

  /// Semeia/altera o servidor como se outro dispositivo tivesse sincronizado.
  void putRecord(String entity, Map<String, dynamic> record) {
    _store.putIfAbsent(entity, () => {})[record['id']! as String] = Map.of(
      record,
    );
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(() {
        _store.clear();
        _settings = _defaultSettings();
      })
      ..get('/v1/sync/settings', (_) => MockResponse.ok(_settings))
      ..put('/v1/sync/settings', _putSettings)
      ..post('/v1/sync/push', _push)
      ..get('/v1/sync/{entity}/{id}', _get);
  }

  MockResponse _putSettings(MockRequest req) {
    final body = req.jsonBody;
    final mode = body['mode'];
    final interval = body['intervalMinutes'];
    MockValidator(body)
      ..required('mode')
      ..check(
        'mode',
        mode == null ||
            ['localOnly', 'cloudBackup', 'cloudSync'].contains(mode),
        'Modo inválido',
      )
      ..check(
        'intervalMinutes',
        interval == null || (interval is int && interval >= 1),
        'Intervalo inválido',
      )
      ..throwIfInvalid();
    return MockResponse.ok(
      _settings = {
        'mode': mode,
        'auto': body['auto'] as bool? ?? true,
        'intervalMinutes': interval ?? 15,
        'lastSyncAt': body['lastSyncAt'],
      },
    );
  }

  MockResponse _get(MockRequest req) {
    final found = _store[req.params['entity']]?[req.params['id']];
    if (found == null || found['deletedAt'] != null) {
      throw const MockApiException.notFound();
    }
    return MockResponse.ok(found);
  }

  MockResponse _push(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('entity')
      ..required('entityId')
      ..required('operation')
      ..throwIfInvalid();
    final entity = body['entity']! as String;
    final id = body['entityId']! as String;
    final op = body['operation']! as String;
    final payload = body['payload'];
    final table = _store.putIfAbsent(entity, () => {});
    final current = table[id];

    switch (op) {
      case 'create':
        if (current != null) return MockResponse.ok({'record': current});
        if (payload is! Map<String, dynamic>) {
          throw const MockApiException.badRequest('Payload em falta');
        }
        return MockResponse.ok({'record': table[id] = _stamp(payload)});
      case 'update':
      case 'delete':
        if (current == null || current['deletedAt'] != null) {
          throw const MockApiException.notFound();
        }
        if (body['baseUpdatedAt'] != current['updatedAt']) {
          throw const MockApiException.conflict(
            'O registo foi alterado noutro dispositivo',
          );
        }
        if (op == 'delete') {
          final now = _now().toIso8601String();
          current
            ..['deletedAt'] = now
            ..['updatedAt'] = now;
          return MockResponse.ok({'record': null});
        }
        if (payload is! Map<String, dynamic>) {
          throw const MockApiException.badRequest('Payload em falta');
        }
        return MockResponse.ok({'record': table[id] = _stamp(payload)});
      default:
        throw const MockApiException.badRequest('Operação inválida');
    }
  }

  /// O servidor é a autoridade sobre `updatedAt` e `syncState`.
  Map<String, dynamic> _stamp(Map<String, dynamic> payload) => {
    ...payload,
    'updatedAt': _now().toIso8601String(),
    'syncState': 'synced',
  };
}
