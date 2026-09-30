import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/table/app_data_table.dart';
import 'package:erp_global/core/widgets/table/table_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Student {
  const _Student(this.id, this.name, this.grade);
  final int id;
  final String name;
  final int grade;
}

List<_Student> _students(int n) => [
  for (var i = 0; i < n; i++)
    _Student(i, 'Aluno ${i.toString().padLeft(5, '0')}', i % 21),
];

TableController<_Student> _controller(int n, {int pageSize = 20}) =>
    TableController<_Student>(
      rows: _students(n),
      pageSize: pageSize,
      rowId: (s) => s.id,
      columns: [
        AppColumn(label: 'Nome', text: (s) => s.name, sortValue: (s) => s.name),
        AppColumn(
          label: 'Nota',
          text: (s) => '${s.grade}',
          sortValue: (s) => s.grade,
          numeric: true,
        ),
      ],
    );

Widget _wrap(Widget child, {Size size = const Size(1000, 900)}) => MaterialApp(
  theme: AppTheme.light(),
  home: MediaQuery(
    data: MediaQueryData(size: size),
    child: Scaffold(body: child),
  ),
);

void main() {
  group('TableController', () {
    test('pesquisa filtra e volta à página 0', () {
      final c = _controller(100, pageSize: 10)..setPage(3);
      c.setQuery('00042');
      expect(c.total, 1);
      expect(c.page, 0);
      expect(c.view.single.id, 42);
    });

    test('ordena asc/desc e alterna ao repetir a coluna', () {
      final c = _controller(30)..sortBy(1, ascending: false);
      expect(c.view.first.grade, 20);
      c.sortBy(1);
      expect(c.ascending, isTrue);
      expect(c.view.first.grade, 0);
    });

    test('paginação limita ao intervalo', () {
      final c = _controller(45, pageSize: 20);
      expect(c.pageCount, 3);
      c.setPage(99);
      expect(c.page, 2);
      expect(c.pageRows, hasLength(5));
    });

    test('selecção sobrevive à mudança de página e "página toda"', () {
      final c = _controller(45, pageSize: 20)..setPageSelected(true);
      expect(c.selectedIds, hasLength(20));
      c.setPage(1);
      c.toggleSelected(c.pageRows.first);
      expect(c.selectedRows, hasLength(21));
      c.clearSelection();
      expect(c.selectedIds, isEmpty);
    });

    test('mantém sempre uma coluna visível', () {
      final c = _controller(5)..setColumnVisible(0, false);
      c.setColumnVisible(1, false);
      expect(c.visibleColumns, [1]);
    });

    test('10 000 linhas: pesquisa + ordenação rápidas', () {
      final sw = Stopwatch()..start();
      final c = _controller(10000)
        ..sortBy(1, ascending: false)
        ..setQuery('Aluno 0');
      expect(c.total, 10000);
      c.setQuery('09999');
      expect(c.total, 1);
      expect(sw.elapsedMilliseconds, lessThan(2000));
    });
  });

  testWidgets('tabela com 10 000 linhas renderiza só a página', (tester) async {
    final c = _controller(10000);
    await tester.pumpWidget(_wrap(AppDataTable<_Student>(controller: c)));
    expect(find.textContaining('Aluno 0'), findsNWidgets(20));
    expect(find.text('10000 registos'), findsOneWidget);
  });

  testWidgets('ordenar ao tocar no cabeçalho e paginar', (tester) async {
    final c = _controller(50);
    await tester.pumpWidget(_wrap(AppDataTable<_Student>(controller: c)));
    await tester.tap(find.text('Nota'));
    await tester.pump();
    expect(c.sortColumn, 1);
    await tester.tap(find.byTooltip('Página seguinte'));
    await tester.pump();
    expect(c.page, 1);
  });

  testWidgets('selecção, acções por linha e exportação', (tester) async {
    final c = _controller(30);
    _Student? acted;
    List<_Student>? exported;
    await tester.pumpWidget(
      _wrap(
        AppDataTable<_Student>(
          controller: c,
          onExport: (rows) => exported = rows,
          rowActions: [
            RowAction(
              label: 'Abrir',
              icon: Icons.open_in_new,
              onTap: (r) => acted = r,
            ),
          ],
        ),
      ),
    );
    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();
    expect(c.selectedIds, hasLength(1));
    await tester.tap(find.byTooltip('Exportar'));
    expect(exported, hasLength(1));

    await tester.tap(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrir'));
    expect(acted?.id, 0);
  });

  testWidgets('exporta todas as filtradas sem selecção', (tester) async {
    final c = _controller(30);
    List<_Student>? exported;
    await tester.pumpWidget(
      _wrap(
        AppDataTable<_Student>(
          controller: c,
          onExport: (rows) => exported = rows,
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Aluno 0001');
    await tester.pump();
    await tester.tap(find.byTooltip('Exportar'));
    expect(exported, hasLength(c.total));
    expect(c.total, lessThan(30));
  });

  testWidgets('em compact mostra cartões em vez de tabela', (tester) async {
    final c = _controller(30);
    await tester.pumpWidget(
      _wrap(AppDataTable<_Student>(controller: c), size: const Size(400, 900)),
    );
    expect(find.byType(DataTable), findsNothing);
    expect(find.byType(Card), findsWidgets);
    expect(find.text('Nota: 0'), findsOneWidget);
  });

  testWidgets('estado vazio', (tester) async {
    final c = _controller(5)..setQuery('zzz');
    await tester.pumpWidget(_wrap(AppDataTable<_Student>(controller: c)));
    expect(find.text('Sem resultados'), findsOneWidget);
  });
}
