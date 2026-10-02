import 'package:erp_global/app/theme/app_colors.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/app/theme/theme_providers.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/security/session_actions.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/cards/app_cards.dart';
import 'package:erp_global/core/widgets/layout/app_topbar.dart';
import 'package:erp_global/core/widgets/layout/page_header.dart';
import 'package:erp_global/core/widgets/layout/responsive_grid.dart';
import 'package:erp_global/core/widgets/table/app_paginator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme, double width = 1200}) =>
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 800), disableAnimations: true),
        child: Scaffold(
          body: Center(
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('pageWindow', () {
    test('poucas páginas: todas', () {
      expect(pageWindow(1, 1), [1]);
      expect(pageWindow(2, 5), [1, 2, 3, 4, 5]);
      expect(pageWindow(4, 7), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('perto do início, do fim e no meio (7 posições)', () {
      expect(pageWindow(1, 15), [1, 2, 3, 4, 5, null, 15]);
      expect(pageWindow(4, 15), [1, 2, 3, 4, 5, null, 15]);
      expect(pageWindow(8, 15), [1, null, 7, 8, 9, null, 15]);
      expect(pageWindow(12, 15), [1, null, 11, 12, 13, 14, 15]);
      expect(pageWindow(15, 15), [1, null, 11, 12, 13, 14, 15]);
    });

    test('a página actual e as pontas aparecem sempre', () {
      for (var total = 1; total <= 40; total++) {
        for (var p = 1; p <= total; p++) {
          final w = pageWindow(p, total);
          expect(w, contains(p));
          expect(w.first, 1);
          expect(w.last, total);
          expect(w.length, lessThanOrEqualTo(7));
        }
      }
    });
  });

  group('AppPaginator', () {
    testWidgets('resumo, página actual e navegação', (tester) async {
      int? page;
      await tester.pumpWidget(
        _wrap(
          AppPaginator(
            page: 2,
            pageSize: 20,
            total: 300,
            itemLabel: 'alunos',
            onPage: (p) => page = p,
            onPageSize: (_) {},
          ),
        ),
      );
      expect(find.text('A mostrar 21–40 de 300 alunos'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, '2'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      await tester.tap(find.byTooltip('Página seguinte'));
      expect(page, 3);
      await tester.tap(find.text('15'));
      expect(page, 15);
    });

    testWidgets('última página e lista vazia desactivam a navegação', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(AppPaginator(page: 1, pageSize: 20, total: 0, onPage: (_) {})),
      );
      expect(find.text('0 registos'), findsOneWidget);
      final next = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(next.onPressed, isNull);
    });

    testWidgets('em ecrã estreito mostra "página / total"', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AppPaginator(page: 2, pageSize: 20, total: 60, onPage: (_) {}),
          width: 400,
        ),
      );
      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.text('Itens por página'), findsNothing);
    });
  });

  test('ResponsiveGrid.columnsFor', () {
    expect(ResponsiveGrid.columnsFor(200), 1);
    expect(ResponsiveGrid.columnsFor(600), 2);
    expect(ResponsiveGrid.columnsFor(1400), 4);
    expect(ResponsiveGrid.columnsFor(1400, maxColumns: 3), 3);
  });

  test('ResponsiveGrid.balancedColumns não deixa cartões sozinhos', () {
    expect(ResponsiveGrid.balancedColumns(3, 4), 2); // 2 + 2
    expect(ResponsiveGrid.balancedColumns(4, 5), 3); // 3 + 2
    expect(ResponsiveGrid.balancedColumns(4, 4), 4); // uma linha
    expect(ResponsiveGrid.balancedColumns(4, 1), 4); // não estica um só
    expect(ResponsiveGrid.balancedColumns(1, 4), 1);
  });

  testWidgets('ResponsiveGrid não estica cartões com valores compridos', (
    tester,
  ) async {
    KpiCard card(String label, String Function(int) format) =>
        KpiCard(key: ValueKey(label), label: label, value: 1, format: format);
    await tester.pumpWidget(
      _wrap(
        ResponsiveGrid(
          minItemWidth: 160,
          children: [card('A', (_) => '1'), card('B', (_) => '1')],
        ),
        width: 344,
      ),
    );
    final short = tester.getSize(find.byKey(const ValueKey('A'))).height;
    await tester.pumpWidget(
      _wrap(
        ResponsiveGrid(
          minItemWidth: 160,
          children: [
            card('A', (_) => '1'),
            // Reduzido pelo FittedBox; não pode contar como duas linhas.
            card('B', (_) => '193 315 315,33 Kz'),
          ],
        ),
        width: 344,
      ),
    );
    expect(tester.getSize(find.byKey(const ValueKey('A'))).height, short);
  });

  testWidgets('PageHeader passa as acções para baixo em ecrã estreito', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Widget header(double width) => _wrap(
      const PageHeader(
        title: 'Alunos',
        subtitle: 'Gestão',
        actions: [Text('acção')],
      ),
      width: width,
    );
    await tester.pumpWidget(header(1400));
    final wideTitle = tester.getTopLeft(find.text('Alunos'));
    final wideAction = tester.getTopLeft(find.text('acção'));
    expect(wideAction.dx, greaterThan(wideTitle.dx));

    await tester.pumpWidget(header(500));
    final narrowTitle = tester.getTopLeft(find.text('Alunos'));
    final narrowAction = tester.getTopLeft(find.text('acção'));
    expect(narrowAction.dy, greaterThan(narrowTitle.dy));
    expect(tester.takeException(), isNull);
  });

  group('KpiCard', () {
    testWidgets('variação: subir é mau quando higherIsBetter = false', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const KpiCard(
            label: 'Dívida',
            value: 10,
            deltaPercent: 5,
            higherIsBetter: false,
          ),
        ),
      );
      final delta = tester.widget<Text>(find.text('+5,0%'));
      expect(delta.style?.color, AppColors.light.danger);
    });

    testWidgets('mostra progresso e legenda com acessibilidade', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _wrap(
          const KpiCard(
            label: 'Assiduidade',
            value: 88,
            progress: 0.88,
            caption: 'vs. trimestre anterior',
            trend: [1, 3, 2, 5],
          ),
        ),
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, 0.88);
      expect(find.text('vs. trimestre anterior'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp(r'^Assiduidade: 88')),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('no tema escuro usa os tokens escuros', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const KpiCard(label: 'Receita', value: 1, deltaPercent: 2),
          theme: AppTheme.dark(),
        ),
      );
      final delta = tester.widget<Text>(find.text('+2,0%'));
      expect(delta.style?.color, AppColors.dark.success);
    });
  });

  test('PtAoFormatters.longDate', () {
    expect(
      PtAoFormatters.longDate(DateTime(2026, 10, 2)),
      startsWith('Sexta-feira, 2 de outubro de 2026'),
    );
  });

  group('AppTopbar', () {
    Future<ProviderContainer> pump(
      WidgetTester tester, {
      bool compact = false,
    }) async {
      tester.view.physicalSize = Size(compact ? 400 : 1400, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(
        overrides: [
          sessionUserProvider.overrideWithValue(
            const SessionUser(name: 'Ana Neto', roleLabel: 'Secretaria'),
          ),
          periodChoicesProvider.overrideWith(
            (ref) async => const PeriodChoices.empty(),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: Consumer(
            builder: (context, ref, _) => MaterialApp(
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: ref.watch(themeModeProvider),
              home: Scaffold(appBar: AppTopbar(compact: compact)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('mostra nome e perfil do utilizador', (tester) async {
      await pump(tester);
      expect(find.text('Ana Neto'), findsOneWidget);
      expect(find.text('Secretaria'), findsOneWidget);
      expect(find.text('AN'), findsOneWidget);
    });

    testWidgets('em ecrã compacto o tema está no menu do utilizador', (
      tester,
    ) async {
      final c = await pump(tester, compact: true);
      expect(find.byTooltip('Usar tema escuro'), findsNothing);
      expect(find.text('Ana Neto'), findsNothing);
      await tester.tap(find.byTooltip('Menu do utilizador'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Usar tema escuro'));
      await tester.pumpAndSettle();
      expect(c.read(themeModeProvider), ThemeMode.dark);
    });

    testWidgets('alterna entre tema claro e escuro', (tester) async {
      final c = await pump(tester);
      await tester.tap(find.byTooltip('Usar tema escuro'));
      await tester.pumpAndSettle();
      expect(c.read(themeModeProvider), ThemeMode.dark);
      expect(find.byTooltip('Usar tema claro'), findsOneWidget);
      await tester.tap(find.byTooltip('Usar tema claro'));
      await tester.pumpAndSettle();
      expect(c.read(themeModeProvider), ThemeMode.light);
    });
  });
}
