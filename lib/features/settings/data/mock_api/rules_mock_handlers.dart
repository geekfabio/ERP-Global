import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/security/permission_service.dart';
import '../../domain/settings_repository.dart';
import '../data_mocks/rules_seed.dart';

/// Handlers de `/v1/settings` (regras académicas, financeiras e fiscais).
/// Valida tipo, limites e regras entre campos como o servidor faria.
class RulesMockHandlers implements MockApiModule {
  RulesMockHandlers({this.permissions}) {
    _reset();
  }

  final PermissionService Function()? permissions;

  late Map<String, Map<String, dynamic>> _settings;

  void _reset() {
    _settings = {for (final s in rulesSeed()) s['key']! as String: s};
  }

  MockHandler _guard(String permission, MockHandler handler) => (request) {
    final service = permissions?.call();
    if (service != null && !service.can(permission)) {
      throw const MockApiException.forbidden();
    }
    return handler(request);
  };

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/settings', _guard(settingsReadPermission, _list))
      ..patch('/v1/settings/{module}', _guard(settingsUpdatePermission, _save));
  }

  List<Map<String, dynamic>> _ofModule(String? module) => [
    for (final s in _settings.values)
      if (module == null || s['module'] == module) s,
  ];

  MockResponse _list(MockRequest q) =>
      MockResponse.ok(_ofModule(q.query['module']));

  bool _valid(Map<String, dynamic> s, Object? value) => switch (s['type']) {
    'integer' => value is int && value >= s['min'] && value <= s['max'],
    'boolean' => value is bool,
    'choice' => (s['options'] as List).contains(value),
    _ => value is String && value.trim().isNotEmpty,
  };

  String _message(Map<String, dynamic> s) => switch (s['type']) {
    'integer' => 'Indique um inteiro entre ${s['min']} e ${s['max']}',
    'choice' => 'Opção inválida',
    _ => 'Valor inválido',
  };

  MockResponse _save(MockRequest q) {
    final module = q.params['module'];
    final current = _ofModule(module);
    if (current.isEmpty) throw const MockApiException.notFound();
    final raw = q.jsonBody['values'];
    final values = raw is Map<String, dynamic> ? raw : <String, dynamic>{};
    final merged = {
      for (final s in current) s['key']! as String: s['value'],
      ...values,
    };
    final v = MockValidator(merged);
    for (final entry in values.entries) {
      final s = _settings[entry.key];
      if (s == null || s['module'] != module) {
        v.check(entry.key, false, 'Definição desconhecida');
      } else {
        v.check(entry.key, _valid(s, entry.value), _message(s));
      }
    }
    if (module == 'academic' && v.isValid) {
      v.check(
        'minPassingGrade',
        (merged['minPassingGrade']! as int) <=
            (merged['gradeScaleMax']! as int),
        'A nota mínima não pode exceder a escala',
      );
    }
    v.throwIfInvalid();
    for (final entry in values.entries) {
      _settings[entry.key] = {..._settings[entry.key]!, 'value': entry.value};
    }
    return MockResponse.ok(_ofModule(module));
  }
}
