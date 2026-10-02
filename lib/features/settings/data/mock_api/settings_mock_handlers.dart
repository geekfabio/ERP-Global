import 'dart:convert';

import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/security/permission_service.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/settings_repository.dart';
import '../data_mocks/settings_seed.dart';

/// Handlers de `/v1/institutions/current` e `/v1/campuses` (docs/07-mock-api.md).
/// Estado mutável em memória; `POST /__mock/reset` repõe o seed.
///
/// Com [permissions], devolve 403 sem `core.settings.read|update` (o repository
/// não decide: é o "servidor" que valida).
class SettingsMockHandlers implements MockApiModule {
  SettingsMockHandlers({this.permissions}) {
    _reset();
  }

  final PermissionService Function()? permissions;

  late Map<String, dynamic> _institution;
  late Map<String, Map<String, dynamic>> _campuses;
  late SeedGenerator _ids;

  void _reset() {
    _institution = institutionSeed();
    _campuses = {for (final c in campusSeed()) c['id']! as String: c};
    _ids = SeedGenerator(26);
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
      ..get(
        '/v1/institutions/current',
        _guard(settingsReadPermission, (_) => MockResponse.ok(_institution)),
      )
      ..patch(
        '/v1/institutions/current',
        _guard(settingsUpdatePermission, _updateInstitution),
      )
      ..post(
        '/v1/institutions/current/logo',
        _guard(settingsUpdatePermission, _uploadLogo),
      )
      ..get('/v1/campuses', _guard(settingsReadPermission, _listCampuses))
      ..post('/v1/campuses', _guard(settingsUpdatePermission, _saveCampus))
      ..patch(
        '/v1/campuses/{id}',
        _guard(settingsUpdatePermission, _saveCampus),
      )
      ..delete(
        '/v1/campuses/{id}',
        _guard(settingsUpdatePermission, _deleteCampus),
      );
  }

  Map<String, dynamic> _pick(Map<String, dynamic> body, List<String> keys) => {
    for (final key in keys)
      if (body.containsKey(key)) key: body[key],
  };

  void _validate(Map<String, dynamic> data, List<String> required) {
    final v = MockValidator(data);
    for (final key in required) {
      v.required(key);
      v.check(key, data[key] is String, 'Texto inválido');
    }
    if (data.containsKey('email')) v.email('email');
    if (data.containsKey('brandColor')) {
      v.check(
        'brandColor',
        brandColorPattern.hasMatch('${data['brandColor']}'),
        'Use o formato #RRGGBB',
      );
    }
    v.throwIfInvalid();
  }

  static const _institutionFields = [
    'name',
    'nif',
    'address',
    'phone',
    'email',
    'brandColor',
  ];

  MockResponse _updateInstitution(MockRequest q) {
    final next = {..._institution, ..._pick(q.jsonBody, _institutionFields)};
    _validate(next, _institutionFields);
    _institution = next;
    return MockResponse.ok(_institution);
  }

  /// Aceita PNG/JPEG (por assinatura) até [maxLogoBytes]; guarda como data URL.
  MockResponse _uploadLogo(MockRequest q) {
    const invalid = MockApiException.validation({
      'logo': 'Escolha uma imagem PNG ou JPEG até 2 MB',
    });
    final content = q.jsonBody['content'];
    if (content is! String) throw invalid;
    final List<int> bytes;
    try {
      bytes = base64Decode(content);
    } on FormatException {
      throw invalid;
    }
    final png =
        bytes.length > 8 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47;
    final jpeg =
        bytes.length > 8 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF;
    if ((!png && !jpeg) || bytes.length > maxLogoBytes) throw invalid;
    _institution = {
      ..._institution,
      'logoUrl': 'data:image/${png ? 'png' : 'jpeg'};base64,$content',
    };
    return MockResponse.ok(_institution);
  }

  MockResponse _listCampuses(MockRequest q) => mockPaginate(
    _campuses.values,
    q,
    toJson: (c) => c,
    spec: MockListSpec<Map<String, dynamic>>(
      sortable: {'name': (c) => foldText(c['name']! as String)},
      searchText: (c) => '${c['name']} ${c['address']}',
      defaultSort: const ['name'],
    ),
  );

  MockResponse _saveCampus(MockRequest q) {
    final id = q.params['id'];
    if (id != null && !_campuses.containsKey(id)) {
      throw const MockApiException.notFound();
    }
    final next = {
      ...?_campuses[id],
      ..._pick(q.jsonBody, ['name', 'address', 'phone']),
    };
    _validate(next, ['name', 'address', 'phone']);
    final name = foldText((next['name']! as String).trim());
    final duplicate = _campuses.values.any(
      (c) => c['id'] != id && foldText((c['name']! as String).trim()) == name,
    );
    if (duplicate) {
      throw const MockApiException.conflict(
        'Já existe um campus com este nome',
      );
    }
    next['id'] = id ?? _ids.ulid(DateTime.now().toUtc());
    next['institutionId'] = _institution['id'];
    _campuses[next['id']! as String] = next;
    return id == null ? MockResponse.created(next) : MockResponse.ok(next);
  }

  MockResponse _deleteCampus(MockRequest q) {
    if (_campuses.length == 1) {
      throw const MockApiException.conflict(
        'A instituição precisa de pelo menos um campus',
      );
    }
    if (_campuses.remove(q.params['id']) == null) {
      throw const MockApiException.notFound();
    }
    return MockResponse.ok({'deleted': true});
  }
}
