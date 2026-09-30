import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/feedback/app_dialogs.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget home) => ProviderScope(
  child: MaterialApp(
    theme: AppTheme.light(),
    scaffoldMessengerKey: rootMessengerKey,
    builder: (context, child) => ToastHost(child: child!),
    home: Scaffold(body: home),
  ),
);

void main() {
  testWidgets('confirmação devolve true ao confirmar', (tester) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showConfirmDialog(
              context: context,
              title: 'Sair?',
              message: 'Tem a certeza?',
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Tem a certeza?'), findsOneWidget);
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('diálogo destrutivo fecha com Esc e devolve false', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showConfirmDialog(
              context: context,
              title: 'Apagar',
              message: 'Apagar aluno?',
              confirmLabel: 'Apagar',
              destructive: true,
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Apagar aluno?'), findsNothing);
    expect(result, isFalse);
  });

  testWidgets('destrutivo dá foco inicial a Cancelar (Enter não apaga)', (
    tester,
  ) async {
    bool? result;
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () async => result = await showConfirmDialog(
              context: context,
              title: 'Apagar',
              message: 'Apagar aluno?',
              destructive: true,
            ),
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('showAppDialog e showAppSheet mostram o conteúdo', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Column(
            children: [
              TextButton(
                onPressed: () => showAppDialog<void>(
                  context: context,
                  title: 'Título',
                  content: const Text('corpo'),
                ),
                child: const Text('dialog'),
              ),
              TextButton(
                onPressed: () => showAppSheet<void>(
                  context: context,
                  title: 'Folha',
                  child: const Text('conteúdo'),
                ),
                child: const Text('sheet'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('dialog'));
    await tester.pumpAndSettle();
    expect(find.text('corpo'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    await tester.tap(find.text('sheet'));
    await tester.pumpAndSettle();
    expect(find.text('conteúdo'), findsOneWidget);
  });

  testWidgets('toasts aparecem via provider para cada tipo', (tester) async {
    late WidgetRef ref;
    await tester.pumpWidget(
      _app(
        Consumer(
          builder: (context, r, _) {
            ref = r;
            return const SizedBox();
          },
        ),
      ),
    );
    final notifier = ref.read(toastProvider.notifier);
    notifier.success('Guardado');
    await tester.pump();
    expect(find.text('Guardado'), findsOneWidget);
    notifier.error('Falhou');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Falhou'), findsOneWidget);
    notifier.info('Nota');
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Nota'), findsOneWidget);
  });
}
