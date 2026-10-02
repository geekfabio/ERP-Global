import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/security/session_actions.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/cards/app_cards.dart';
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
  List<String>? permissions,
  SessionUser? user,
}) async {
  tester.view.physicalSize = const Size(2000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final registry = MockApiRegistry()..addModule(ReportsMockHandlers());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sessionRolesProvider.overrideWithValue(roles),
        sessionPermissionsProvider.overrideWithValue(permissions),
        sessionUserProvider.overrideWithValue(user),
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
    expect(find.textContaining('Dashboard · Financeiro'), findsOneWidget);
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
    expect(find.textContaining('vs. trimestre anterior'), findsNothing);
    await tester.tap(find.byKey(const ValueKey('compare')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trimestre anterior').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('vs. trimestre anterior'), findsWidgets);
  });

  testWidgets('saúda o utilizador da sessão pelo primeiro nome', (
    tester,
  ) async {
    await _pump(
      tester,
      roles: ['direcao'],
      user: const SessionUser(name: 'Armando Trindade', roleLabel: 'Direcção'),
    );
    expect(find.textContaining(', Armando'), findsOneWidget);
    expect(find.textContaining('2.º Trimestre · 2025/2026'), findsOneWidget);
  });

  testWidgets('acções rápidas respeitam licença e permissões', (tester) async {
    await _pump(
      tester,
      roles: ['direcao'],
      permissions: ['students.record.update'],
    );
    expect(find.text('Nova matrícula'), findsOneWidget);
    // Sem permissão de facturar e sem o módulo de presenças licenciado.
    expect(find.text('Nova factura'), findsNothing);
    expect(find.text('Registar presença'), findsNothing);
  });

  testWidgets('gráficos só aparecem para os indicadores visíveis', (
    tester,
  ) async {
    await _pump(tester, roles: ['financeiro']);
    expect(find.text('Receita por mês'), findsOneWidget);
    expect(find.text('Alunos por classe'), findsNothing);
  });

  testWidgets('dívida a subir é sinalizada como má notícia', (tester) async {
    await _pump(tester, roles: ['financeiro']);
    final debt = find.descendant(
      of: find.byKey(const ValueKey('billing.debt')),
      matching: find.byType(KpiCard),
    );
    expect(tester.widget<KpiCard>(debt).higherIsBetter, isFalse);
  });

  testWidgets('perfil sem dashboard mostra estado vazio', (tester) async {
    await _pump(tester, roles: ['encarregado']);
    expect(find.text('Sem indicadores para o seu perfil'), findsOneWidget);
  });
}
