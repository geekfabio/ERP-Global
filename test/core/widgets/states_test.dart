import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/widgets/states/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(body: child),
);

Widget _view(AsyncValue<List<int>> v, {VoidCallback? retry}) => _wrap(
  AsyncValueView<List<int>>(
    value: v,
    onRetry: retry,
    isEmpty: (d) => d.isEmpty,
    data: (d) => Text('n=${d.length}'),
  ),
);

void main() {
  testWidgets('skeletons renderizam', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Column(
          children: [
            SkeletonCard(),
            Expanded(child: SkeletonList()),
          ],
        ),
      ),
    );
    expect(find.byType(SkeletonCard), findsOneWidget);
    expect(find.byType(SkeletonList), findsOneWidget);
    expect(find.text('Título do registo'), findsWidgets);
  });

  testWidgets('EmptyState mostra CTA e reage ao toque', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        EmptyState(
          title: 'Sem alunos',
          message: 'Adicione o primeiro',
          actionLabel: 'Novo aluno',
          onAction: () => taps++,
        ),
      ),
    );
    await tester.tap(find.text('Novo aluno'));
    expect(taps, 1);
    expect(find.text('Adicione o primeiro'), findsOneWidget);
  });

  testWidgets('ErrorState mostra mensagem e retry', (tester) async {
    var retries = 0;
    await tester.pumpWidget(
      _wrap(ErrorState(failure: NetworkFailure(), onRetry: () => retries++)),
    );
    expect(find.byIcon(Icons.cloud_off_outlined), findsOneWidget);
    await tester.tap(find.text('Tentar novamente'));
    expect(retries, 1);
  });

  testWidgets('AsyncValueView cobre loading, erro, vazio e dados', (
    tester,
  ) async {
    await tester.pumpWidget(_view(const AsyncLoading()));
    expect(find.byType(SkeletonList), findsOneWidget);

    var retried = false;
    await tester.pumpWidget(
      _view(
        AsyncError(AuthFailure(), StackTrace.empty),
        retry: () => retried = true,
      ),
    );
    await tester.tap(find.text('Tentar novamente'));
    expect(retried, isTrue);

    await tester.pumpWidget(_view(const AsyncData(<int>[])));
    expect(find.text('Sem registos'), findsOneWidget);

    await tester.pumpWidget(_view(const AsyncData([1, 2, 3])));
    expect(find.text('n=3'), findsOneWidget);
  });
}
