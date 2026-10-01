import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/reports/data/mock_api/reports_mock_handlers.dart';
import 'package:erp_global/features/reports/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _terms = [
  PeriodTerm(id: 't1', label: '1.º Trimestre'),
  PeriodTerm(id: 't2', label: '2.º Trimestre', isOpen: true),
];

Future<void> _pump(
  WidgetTester tester, {
  required List<String> roles,
  Set<String> modules = const {'students', 'billing', 'cafeteria'},
}) async {
  tester.view.physicalSize = const Size(2000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final registry = MockApiRegistry()..addModule(ReportsMockHandlers());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionRolesProvider.overrideWithValue(roles),
        licenseGateProvider.overrideWithValue(
          LicenseGate(enabledModules: modules),
        ),
        periodChoicesProvider.overrideWith(
          (ref) async => const PeriodChoices([
            PeriodYear(
              id: 'y26',
              label: '2025/2026',
              isActive: true,
              terms: _terms,
            ),
          ]),
        ),
        apiClientProvider.overrideWith(
          (ref) => ApiClient.create(
            baseUrl: 'https://api.test',
            useMockApi: true,
            registry: registry,
            mockConfig: const MockApiConfig.instant(),
            logging: false,
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(body: DashboardPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('financeiro vê indicadores financeiros e não os de alunos', (
    tester,
  ) async {
    await _pump(tester, roles: ['financeiro']);
    expect(find.text('Dashboard · Financeiro'), findsOneWidget);
    expect(find.text('Dívida em aberto'), findsOneWidget);
    expect(find.text('Alunos matriculados'), findsNothing);
  });

  testWidgets('direcção vê só módulos licenciados', (tester) async {
    await _pump(tester, roles: ['direcao'], modules: {'students'});
    expect(find.text('Alunos matriculados'), findsOneWidget);
    expect(find.text('Receita cobrada'), findsNothing);
    expect(find.text('Refeições servidas'), findsNothing);
  });

  testWidgets('comparação mostra o valor do período anterior', (tester) async {
    await _pump(tester, roles: ['direcao']);
    expect(find.textContaining('vs.'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('compare')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trimestre anterior').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('vs. trimestre anterior'), findsWidgets);
  });

  testWidgets('perfil sem dashboard mostra estado vazio', (tester) async {
    await _pump(tester, roles: ['encarregado']);
    expect(find.text('Sem indicadores para o seu perfil'), findsOneWidget);
  });
}
