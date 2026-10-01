import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/portal/data/mock_api/portal_mock_handlers.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_home_page.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, Set<String> licensed) async {
  await PtAoFormatters.initialize();
  tester.view.physicalSize = const Size(1200, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final auth = AuthMockHandlers();
  final students = StudentsMockHandlers(count: 60);
  final handlers = PortalMockHandlers(
    authenticate: auth.authenticate,
    pupilsFor: students.pupilsForPortalUser,
  );
  final container = ProviderContainer(
    overrides: [
      licenseGateProvider.overrideWithValue(
        LicenseGate(enabledModules: {'core', 'guardian_portal', ...licensed}),
      ),
      apiClientProvider.overrideWith((ref) {
        final registry = ref.watch(mockApiRegistryProvider);
        return ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: registry,
          mockConfig: const MockApiConfig.instant(),
          logging: false,
        );
      }),
      mockApiModulesProvider.overrideWithValue([auth, students, handlers]),
    ],
  );
  addTearDown(container.dispose);
  await tester.runAsync(
    () => ApiAuthRepository(
      container.read(apiClientProvider),
      InMemorySessionStorage(),
    ).login(identifier: 'encarregado@erp-global.local', password: 'Dev@12345'),
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: PortalHomePage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('mostra só os resumos dos módulos licenciados', (tester) async {
    await _pump(tester, {'grades', 'billing'});
    expect(find.text('Média do último trimestre'), findsOneWidget);
    expect(find.text('Em dívida'), findsOneWidget);
    expect(find.text('Faltas injustificadas'), findsNothing);
    expect(find.text('Saldo do refeitório'), findsNothing);
  });

  testWidgets('sem módulos licenciados não mostra resumos', (tester) async {
    await _pump(tester, {});
    expect(find.text('Sem informação disponível'), findsOneWidget);
  });

  testWidgets('selector troca de educando', (tester) async {
    await _pump(tester, {'grades'});
    final chips = find.byType(ChoiceChip);
    expect(chips, findsAtLeastNWidgets(2));
    final second = tester.widget<ChoiceChip>(chips.at(1));
    expect(second.selected, isFalse);
    await tester.tap(chips.at(1));
    await tester.pumpAndSettle();
    expect(tester.widget<ChoiceChip>(chips.at(1)).selected, isTrue);
  });
}
