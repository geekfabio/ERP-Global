import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/settings/data/mock_api/rules_mock_handlers.dart';
import 'package:erp_global/features/settings/data/models/setting_model.dart';
import 'package:erp_global/features/settings/data/repositories/api_rules_repository.dart';
import 'package:erp_global/features/settings/presentation/pages/rules_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

ApiRulesRepository _repo({PermissionService? permissions}) =>
    ApiRulesRepository(
      ApiClient.create(
        baseUrl: 'https://api.test',
        useMockApi: true,
        registry: MockApiRegistry()
          ..addModule(
            RulesMockHandlers(
              permissions: permissions == null ? null : () => permissions,
            ),
          ),
        mockConfig: const MockApiConfig.instant(),
        logging: false,
      ),
    );

Matcher _code(String code) =>
    isA<Failure>().having((f) => f.code, 'code', code);

void main() {
  group('API de regras', () {
    test('lista as regras tipadas por módulo', () async {
      final rows = (await _repo().settings(
        SettingModule.academic,
      )).getOrThrow();
      expect(rows.map((s) => s.key), contains('minPassingGrade'));
      expect(rows.every((s) => s.module == SettingModule.academic), isTrue);
      final tax = (await _repo().settings(SettingModule.tax)).getOrThrow();
      expect(tax.firstWhere((s) => s.key == 'vatRateBp').value, 1400);
    });

    test('grava e persiste valores', () async {
      final repo = _repo();
      await repo.save(SettingModule.finance, {
        'currency': 'USD',
        'lateFeeBp': 500,
      });
      final rows = (await repo.settings(SettingModule.finance)).getOrThrow();
      expect(rows.firstWhere((s) => s.key == 'currency').value, 'USD');
      expect(rows.firstWhere((s) => s.key == 'lateFeeBp').value, 500);
    });

    test('valida tipo, limites e regras entre campos (422)', () async {
      final repo = _repo();
      expect(
        (await repo.save(SettingModule.academic, {
          'termCount': 9,
        })).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
      expect(
        (await repo.save(SettingModule.finance, {
          'currency': 'XXX',
        })).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
      expect(
        (await repo.save(SettingModule.academic, {
          'minPassingGrade': 25,
        })).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
      expect(
        (await repo.save(SettingModule.tax, {'termCount': 3})).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
    });

    test('403 sem permissões', () async {
      final repo = _repo(permissions: PermissionService.none());
      expect(
        (await repo.settings(SettingModule.tax)).failureOrNull,
        _code('FORBIDDEN'),
      );
    });
  });

  group('página', () {
    List<Override> overrides(List<String> permissions) => [
      sessionPermissionsProvider.overrideWithValue(permissions),
      apiClientProvider.overrideWith(
        (ref) => ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: MockApiRegistry()..addModule(RulesMockHandlers()),
          mockConfig: const MockApiConfig.instant(),
          logging: false,
        ),
      ),
    ];

    Future<void> pump(WidgetTester tester, List<String> permissions) async {
      tester.view.physicalSize = const Size(1200, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: overrides(permissions),
          child: MaterialApp(
            theme: AppTheme.light(),
            scaffoldMessengerKey: rootMessengerKey,
            builder: (context, child) => ToastHost(child: child!),
            home: const Scaffold(body: RulesPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('edita e guarda a nota mínima', (tester) async {
      await pump(tester, ['core.settings.read', 'core.settings.update']);
      await tester.enterText(
        find.byKey(const Key('rule_minPassingGrade')),
        '12',
      );
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('Regras guardadas.'), findsOneWidget);
    });

    testWidgets('sem update fica só de leitura', (tester) async {
      await pump(tester, ['core.settings.read']);
      expect(find.text('Guardar'), findsNothing);
    });
  });
}
