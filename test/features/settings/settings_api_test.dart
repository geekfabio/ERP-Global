import 'dart:convert';
import 'dart:typed_data';

import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/settings/data/mock_api/settings_mock_handlers.dart';
import 'package:erp_global/features/settings/data/repositories/api_settings_repository.dart';
import 'package:flutter_test/flutter_test.dart';

ApiSettingsRepository _repo({PermissionService? permissions}) {
  final registry = MockApiRegistry()
    ..addModule(
      SettingsMockHandlers(
        permissions: permissions == null ? null : () => permissions,
      ),
    );
  return ApiSettingsRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

Matcher _code(String code) =>
    isA<Failure>().having((f) => f.code, 'code', code);

final _png = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0, 0, 0, 0, //
]);

void main() {
  group('instituição', () {
    test('lê e actualiza os dados e a cor da marca', () async {
      final repo = _repo();
      final current = (await repo.institution()).getOrThrow();
      expect(current.name, 'Colégio Global');

      final updated = (await repo.updateInstitution({
        'name': 'Escola Nova',
        'brandColor': '#00AA55',
      })).getOrThrow();
      expect(updated.name, 'Escola Nova');
      expect(updated.brandColor, '#00AA55');
      expect((await repo.institution()).getOrThrow().name, 'Escola Nova');
    });

    test('valida campos (422 por campo)', () async {
      final repo = _repo();
      final r = await repo.updateInstitution({
        'brandColor': 'azul',
        'email': 'x',
        'name': '',
      });
      final failure = r.failureOrNull! as ValidationFailure;
      expect(failure.fields.keys, containsAll(['brandColor', 'email', 'name']));
    });

    test('logótipo: aceita PNG e rejeita outros formatos', () async {
      final repo = _repo();
      final ok = (await repo.uploadLogo(_png)).getOrThrow();
      expect(ok.logoUrl, startsWith('data:image/png;base64,'));
      expect(base64Decode(ok.logoUrl!.split(',').last), orderedEquals(_png));

      final bad = await repo.uploadLogo(
        Uint8List.fromList(utf8.encode('texto longo qualquer')),
      );
      expect(bad.failureOrNull, isA<ValidationFailure>());
    });

    test('403 sem permissão de leitura/escrita', () async {
      final reader = _repo(
        permissions: PermissionService.fromCodes(['core.settings.read']),
      );
      expect((await reader.institution()).isOk, isTrue);
      expect(
        (await reader.updateInstitution({'name': 'X'})).failureOrNull,
        isA<PermissionFailure>(),
      );
      final none = _repo(permissions: const PermissionService.none());
      expect((await none.campuses()).failureOrNull, isA<PermissionFailure>());
    });
  });

  group('campus', () {
    Map<String, String> campus(String name) => {
      'name': name,
      'address': 'Benguela',
      'phone': '+244 912 000 000',
    };

    test('CRUD completo com paginação por envelope', () async {
      final repo = _repo();
      final created = (await repo.saveCampus(campus('Benguela'))).getOrThrow();
      expect(created.id, isNotEmpty);

      var page = (await repo.campuses()).getOrThrow();
      expect(page.items.map((c) => c.name), ['Benguela', 'Sede']);
      expect(page.meta.total, 2);

      final edited = (await repo.saveCampus(
        campus('Lobito'),
        id: created.id,
      )).getOrThrow();
      expect(edited.name, 'Lobito');

      (await repo.deleteCampus(created.id)).getOrThrow();
      page = (await repo.campuses()).getOrThrow();
      expect(page.items.single.name, 'Sede');
    });

    test('409 em nome duplicado e 404 em id inexistente', () async {
      final repo = _repo();
      expect(
        (await repo.saveCampus(campus('sede'))).failureOrNull,
        _code('CONFLICT'),
      );
      expect(
        (await repo.saveCampus(campus('X'), id: 'nao-existe')).failureOrNull,
        _code('NOT_FOUND'),
      );
    });

    test('não elimina o último campus', () async {
      final repo = _repo();
      final only = (await repo.campuses()).getOrThrow().items.single;
      expect(
        (await repo.deleteCampus(only.id)).failureOrNull,
        _code('CONFLICT'),
      );
    });
  });
}
