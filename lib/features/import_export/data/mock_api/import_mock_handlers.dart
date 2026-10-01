import 'dart:async';

import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';

/// Estado de um trimestre conhecido pelo servidor: `true` = fechado,
/// `null` = trimestre inexistente. A referência é o id ou o nome do período.
typedef ImportTermLookup = FutureOr<bool?> Function(String termRef);

/// Handlers de `POST /v1/imports/{entity}` (docs/07-mock-api.md). Valida de novo
/// cada registo (o servidor nunca confia no cliente), rejeita duplicados
/// (reimportar o mesmo ficheiro não duplica registos) e, nas notas, recusa
/// trimestres fechados. Estado em memória; `POST /__mock/reset` repõe-no.
class ImportMockHandlers implements MockApiModule {
  ImportMockHandlers({this.termLookup});

  /// Estado dos trimestres (módulo académico); sem ele aceita qualquer um.
  final ImportTermLookup? termLookup;

  /// Campos obrigatórios por entidade suportada.
  static const _required = {
    'students': ['fullName'],
    'guardians': ['fullName', 'phone'],
    'teachers': ['fullName', 'email'],
    'classrooms': ['name', 'grade', 'capacity'],
    'grades': ['studentRef', 'classroom', 'subject', 'term', 'component'],
    'payments': ['studentRef', 'amountMinor', 'method', 'paidAt'],
  };

  /// Campo(s) que identificam um registo; um segundo igual é rejeitado.
  static const _unique = {
    'students': ['biNumber'],
    'guardians': ['biNumber'],
    'teachers': ['email'],
    'classrooms': ['name', 'grade'],
    'payments': ['reference'],
  };

  static const _duplicate = {
    'biNumber': 'BI já registado',
    'email': 'E-mail já registado',
    'name': 'Turma já registada',
    'reference': 'Referência já registada',
  };

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

  static String? _key(String entity, Map<String, Object?> rec) {
    final fields = _unique[entity];
    if (fields == null) return null;
    final parts = [for (final f in fields) '${rec[f] ?? ''}'.toLowerCase()];
    return parts.every((p) => p.isEmpty) ? null : parts.join('|');
  }

  Future<MockResponse> _commit(MockRequest req) async {
    final entity = req.params['entity']!;
    if (!_required.containsKey(entity)) throw const MockApiException.notFound();
    final records = req.jsonBody['records'];
    if (records is! List) {
      throw const MockApiException.validation({'records': 'Campo obrigatório'});
    }
    final store = _stored.putIfAbsent(entity, () => []);
    final keys = {for (final s in store) ?_key(entity, s)};
    var imported = 0;
    final rejected = <Map<String, Object?>>[];
    for (var i = 0; i < records.length; i++) {
      final rec = Map<String, Object?>.from(records[i] as Map);
      final errors = <String, String>{};
      for (final f in _required[entity]!) {
        final v = rec[f];
        if (v == null || (v is String && v.trim().isEmpty)) {
          errors[f] = 'Campo obrigatório';
        }
      }
      if (entity == 'grades' && errors.isEmpty) {
        await _checkGrade(rec, errors);
      }
      if (entity == 'payments' && errors.isEmpty) {
        final amount = rec['amountMinor'];
        if (amount is! int || amount <= 0) {
          errors['amountMinor'] = 'O valor deve ser maior que zero';
        }
      }
      final key = _key(entity, rec);
      if (errors.isEmpty && key != null && !keys.add(key)) {
        errors[_unique[entity]!.first] = _duplicate[_unique[entity]!.first]!;
      }
      if (errors.isEmpty) {
        if (entity == 'grades') {
          // Nota repetida para o mesmo aluno/componente: substitui (idempotente).
          final slot = _slot(rec);
          store.removeWhere((s) => _slot(s) == slot);
        }
        store.add(rec);
        imported++;
      } else {
        rejected.add({'index': i, 'errors': errors});
      }
    }
    return MockResponse.created({'imported': imported, 'rejected': rejected});
  }

  static String _slot(Map<String, Object?> r) => [
    for (final f in ['studentRef', 'classroom', 'subject', 'term', 'component'])
      '${r[f]}'.toLowerCase(),
  ].join('|');

  Future<void> _checkGrade(
    Map<String, Object?> rec,
    Map<String, String> errors,
  ) async {
    final score = rec['score'];
    if (score is! num || score < 0 || score > 100) {
      errors['score'] = 'Nota inválida';
    }
    final closed = await termLookup?.call('${rec['term']}');
    if (termLookup != null) {
      if (closed == null) {
        errors['term'] = 'Trimestre não encontrado';
      } else if (closed) {
        errors['term'] = 'Trimestre fechado: não aceita notas';
      }
    }
  }
}
