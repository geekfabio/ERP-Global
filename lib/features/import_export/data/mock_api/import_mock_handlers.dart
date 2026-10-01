import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';

/// Handlers de `POST /v1/imports/{entity}` (docs/07-mock-api.md). Valida de novo
/// cada registo (o servidor nunca confia no cliente) e rejeita BI duplicado.
/// Estado em memória; `POST /__mock/reset` repõe-no.
class ImportMockHandlers implements MockApiModule {
  ImportMockHandlers();

  final Map<String, List<Map<String, Object?>>> _stored = {};

  /// Registos gravados nesta sessão, por entidade (para testes).
  List<Map<String, Object?>> stored(String entity) =>
      List.unmodifiable(_stored[entity] ?? const []);

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_stored.clear)
      ..post('/v1/imports/{entity}', _commit);
  }

  MockResponse _commit(MockRequest req) {
    final entity = req.params['entity']!;
    if (entity != 'students') throw const MockApiException.notFound();
    final records = req.jsonBody['records'];
    if (records is! List) {
      throw const MockApiException.validation({'records': 'Campo obrigatório'});
    }
    final store = _stored.putIfAbsent(entity, () => []);
    final bis = {
      for (final s in store)
        if (s['biNumber'] != null) s['biNumber']! as String,
    };
    var imported = 0;
    final rejected = <Map<String, Object?>>[];
    for (var i = 0; i < records.length; i++) {
      final rec = Map<String, Object?>.from(records[i] as Map);
      final errors = <String, String>{};
      if ((rec['fullName'] as String?)?.trim().isNotEmpty != true) {
        errors['fullName'] = 'Campo obrigatório';
      }
      final bi = rec['biNumber'] as String?;
      if (bi != null && !bis.add(bi)) errors['biNumber'] = 'BI já registado';
      if (errors.isEmpty) {
        store.add(rec);
        imported++;
      } else {
        rejected.add({'index': i, 'errors': errors});
      }
    }
    return MockResponse.created({'imported': imported, 'rejected': rejected});
  }
}
