import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/charts/chart_card.dart';
import 'package:erp_global/core/widgets/inputs/filter_select.dart';
import 'package:erp_global/core/widgets/layout/content_section.dart';
import 'package:erp_global/core/widgets/layout/filter_panel.dart';
import 'package:erp_global/core/widgets/layout/page_actions.dart';
import 'package:erp_global/core/widgets/person_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(1200, 800),
  ThemeData? theme,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: theme ?? AppTheme.light(),
      home: Scaffold(body: SingleChildScrollView(child: child)),
    ),
  );
}

void main() {
  group('FilterSelect', () {
    testWidgets('oferece "Todos" e devolve o valor escolhido', (tester) async {
      String? picked = 'x';
      await _pump(
        tester,
        FilterSelect<String>(
          fieldKey: const Key('f'),
          label: 'Classe',
          value: null,
          options: const {'a': '1.ª classe', 'b': '2.ª classe'},
          onChanged: (v) => picked = v,
        ),
      );
      await tester.tap(find.byKey(const Key('f')));
      await tester.pumpAndSettle();
      expect(find.text('Todos'), findsWidgets);
      await tester.tap(find.text('2.ª classe').last);
      await tester.pumpAndSettle();
      expect(picked, 'b');
    });

    testWidgets('desactivado explica porquê numa tooltip', (tester) async {
      await _pump(
        tester,
        FilterSelect<String>(
          fieldKey: const Key('f'),
          label: 'Turma',
          value: null,
          options: const {},
          enabled: false,
          disabledHint: 'Escolha primeiro a classe',
          onChanged: (_) {},
        ),
      );
      final field = tester.widget<DropdownButtonFormField<String?>>(
        find.byKey(const Key('f')),
      );
      expect(field.onChanged, isNull);
      expect(find.byTooltip('Escolha primeiro a classe'), findsOneWidget);
    });
  });

  group('FilterPanel', () {
    Widget panel({VoidCallback? onClear, int active = 0}) => FilterPanel(
      search: const TextField(key: Key('search')),
      activeCount: active,
      onClear: onClear,
      filters: (width) => [
        SizedBox(width: width, child: const Text('filtro-1')),
        SizedBox(width: width, child: const Text('filtro-2')),
      ],
    );

    testWidgets('em espaço largo mostra pesquisa e filtros juntos', (
      tester,
    ) async {
      await _pump(tester, panel());
      expect(find.byKey(const Key('search')), findsOneWidget);
      expect(find.text('filtro-1'), findsOneWidget);
      expect(find.byKey(const Key('toggle_filters')), findsNothing);
      // Sem nada para limpar, não há botão.
      expect(find.text('Limpar filtros'), findsNothing);
    });

    testWidgets('em espaço estreito recolhe e mostra quantos estão activos', (
      tester,
    ) async {
      var cleared = 0;
      await _pump(
        tester,
        panel(onClear: () => cleared++, active: 2),
        size: const Size(400, 800),
      );
      expect(find.text('filtro-1'), findsNothing);
      expect(find.text('Filtros (2)'), findsOneWidget);
      await tester.tap(find.byKey(const Key('toggle_filters')));
      await tester.pumpAndSettle();
      expect(find.text('filtro-1'), findsOneWidget);
      expect(find.text('filtro-2'), findsOneWidget);
      await tester.tap(find.text('Limpar filtros'));
      expect(cleared, 1);
    });
  });

  testWidgets('ChartCard: título como cabeçalho, subtítulo e legenda', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      const ChartCard(
        title: 'Receita por mês',
        subtitle: 'em milhares de Kz',
        legend: Wrap(
          children: [
            ChartLegendKey(label: 'Cobrada', color: Colors.blue),
            ChartLegendKey(label: 'Prevista', color: Colors.grey, dashed: true),
          ],
        ),
        child: SizedBox(height: 40, child: Text('gráfico')),
      ),
    );
    expect(
      tester.getSemantics(find.text('Receita por mês')),
      isSemantics(isHeader: true),
    );
    expect(find.text('em milhares de Kz'), findsOneWidget);
    expect(find.text('Cobrada'), findsOneWidget);
    expect(find.text('Prevista'), findsOneWidget);
    expect(find.text('gráfico'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('ContentSection só mostra o título quando existe', (
    tester,
  ) async {
    await _pump(
      tester,
      const Column(
        children: [
          ContentSection(title: 'Financeiro', child: Text('a')),
          ContentSection(child: Text('b')),
        ],
      ),
    );
    expect(find.text('Financeiro'), findsOneWidget);
    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
  });

  testWidgets('PersonLabel mostra iniciais e lê o nome uma vez', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, const PersonLabel(name: 'Ana Maria Neto'));
    expect(find.text('AN'), findsOneWidget);
    expect(find.bySemanticsLabel('Ana Maria Neto'), findsOneWidget);
    semantics.dispose();
  });

  group('acções de página', () {
    testWidgets('principal é cheia e as restantes têm contorno', (
      tester,
    ) async {
      await _pump(
        tester,
        Row(
          children: [
            PageActionButton(
              PageAction(
                label: 'Novo',
                icon: Icons.add,
                primary: true,
                onPressed: () {},
              ),
            ),
            PageActionButton(
              PageAction(
                label: 'Importar',
                icon: Icons.upload,
                onPressed: () {},
              ),
            ),
          ],
        ),
      );
      expect(find.widgetWithText(FilledButton, 'Novo'), findsOneWidget);
      expect(find.widgetWithText(OutlinedButton, 'Importar'), findsOneWidget);
    });

    testWidgets('menu "Mais acções" executa a escolhida e some sem acções', (
      tester,
    ) async {
      var opened = '';
      await _pump(
        tester,
        OverflowActionsMenu(
          actions: [
            PageAction(
              label: 'Operações',
              icon: Icons.dashboard,
              onPressed: () => opened = 'ops',
            ),
          ],
        ),
      );
      await tester.tap(find.byTooltip('Mais acções'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Operações'));
      await tester.pumpAndSettle();
      expect(opened, 'ops');

      await _pump(tester, const OverflowActionsMenu(actions: []));
      expect(find.byTooltip('Mais acções'), findsNothing);
    });
  });
}
