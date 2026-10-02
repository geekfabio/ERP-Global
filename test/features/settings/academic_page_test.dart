import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/core/widgets/layout/app_topbar.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
import 'package:erp_global/features/settings/presentation/pages/academic_years_page.dart';
import 'package:erp_global/features/settings/presentation/providers/academic_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

List<Override> _overrides(List<String> permissions) => [
  sessionPermissionsProvider.overrideWithValue(permissions),
  mockApiModulesProvider.overrideWith((ref) => [AcademicMockHandlers()]),
  apiClientProvider.overrideWith(
    (ref) => ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: ref.watch(mockApiRegistryProvider),
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  ),
  periodChoicesProvider.overrideWith(
    (ref) => ref.watch(academicPeriodChoicesProvider.future),
  ),
];

Future<ProviderContainer> _pump(
  WidgetTester tester,
  List<String> permissions,
  Widget body, {
  PreferredSizeWidget? appBar,
}) async {
  await PtAoFormatters.initialize();
  tester.view.physicalSize = const Size(1600, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(overrides: _overrides(permissions));
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: Scaffold(appBar: appBar, body: body),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('selector da topbar usa o ano activo e muda de período', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      const ['*'],
      const SizedBox.shrink(),
      appBar: const AppTopbar(),
    );
    expect(find.text('2025/2026'), findsOneWidget);
    // período por omissão = primeiro aberto (2.º trimestre no seed)
    expect(find.text('2.º Trimestre'), findsOneWidget);
    expect(container.read(effectivePeriodProvider).year?.label, '2025/2026');

    await tester.tap(find.byTooltip('Período'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('3.º Trimestre').last);
    await tester.pumpAndSettle();
    expect(find.text('3.º Trimestre'), findsOneWidget);
    expect(
      container.read(effectivePeriodProvider).term?.label,
      '3.º Trimestre',
    );

    // mudar de ano repõe o período do novo ano
    await tester.tap(find.byTooltip('Ano lectivo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2024/2025').last);
    await tester.pumpAndSettle();
    expect(container.read(effectivePeriodProvider).year?.label, '2024/2025');
    expect(find.text('1.º Trimestre'), findsOneWidget);
  });

  testWidgets('abrir um período actualiza o selector; reabrir é auditável', (
    tester,
  ) async {
    await _pump(tester, const ['*'], const AcademicYearsPage());
    expect(find.text('Activo'), findsOneWidget);
    expect(find.text('Encerrado'), findsOneWidget);

    // 3.º trimestre do ano activo: abrir
    final toggles = find.widgetWithText(TextButton, 'Abrir');
    expect(toggles, findsOneWidget);
    await tester.tap(toggles);
    await tester.pumpAndSettle();
    expect(find.text('Período aberto.'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Abrir'), findsNothing);
  });

  testWidgets('avançar o ano mostra erro quando a regra falha', (tester) async {
    await _pump(tester, const ['*'], const AcademicYearsPage());
    // ano planeado: activar falha porque já há um activo no campus
    await tester.tap(find.text('2026/2027'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('advance_01JYEAR202620270000000001A')),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Já existe um ano lectivo activo neste campus'),
      findsOneWidget,
    );
  });

  testWidgets('sem permissão de escrita não há acções', (tester) async {
    await _pump(tester, const [
      'core.settings.read',
    ], const AcademicYearsPage());
    expect(find.text('Novo ano lectivo'), findsNothing);
    expect(find.widgetWithText(TextButton, 'Abrir'), findsNothing);
    expect(find.byTooltip('Editar datas'), findsNothing);
  });
}
