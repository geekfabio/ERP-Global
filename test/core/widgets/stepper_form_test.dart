import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/forms/stepper_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness({
  required Future<void> Function(Map<String, Object?>) onSubmit,
  DraftStore? draft,
}) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: StepperForm(
        draftStore: draft,
        onSubmit: onSubmit,
        steps: [
          FormStepDef(
            title: 'Dados',
            builder: (context, form) => TextFormField(
              key: const Key('name'),
              initialValue: form.get<String>('name'),
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Nome obrigatório' : null,
              onChanged: (v) => form.set('name', v),
            ),
          ),
          FormStepDef(
            title: 'Contacto',
            builder: (context, form) => TextFormField(
              key: const Key('phone'),
              initialValue: form.get<String>('phone'),
              decoration: const InputDecoration(labelText: 'Telefone'),
              onChanged: (v) => form.set('phone', v),
            ),
          ),
        ],
      ),
    ),
  ),
);

void main() {
  testWidgets('não avança com passo inválido', (tester) async {
    await tester.pumpWidget(_harness(onSubmit: (_) async {}));
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('Nome obrigatório'), findsOneWidget);
    expect(find.byKey(const Key('phone')).hitTestable(), findsNothing);
  });

  testWidgets('voltar atrás não perde dados e o resumo mostra tudo', (
    tester,
  ) async {
    Map<String, Object?>? submitted;
    await tester.pumpWidget(_harness(onSubmit: (v) async => submitted = v));
    await tester.enterText(find.byKey(const Key('name')), 'Ana');
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('phone')), '923456789');
    await tester.tap(find.text('Anterior'));
    await tester.pumpAndSettle();
    expect(find.text('Ana'), findsOneWidget);
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('923456789'), findsOneWidget);
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('name: Ana'), findsOneWidget);
    expect(find.text('phone: 923456789'), findsOneWidget);
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();
    expect(submitted, {'name': 'Ana', 'phone': '923456789'});
  });

  testWidgets('guarda rascunho e limpa ao concluir', (tester) async {
    final draft = InMemoryDraftStore();
    await tester.pumpWidget(_harness(onSubmit: (_) async {}, draft: draft));
    await tester.enterText(find.byKey(const Key('name')), 'Rui');
    expect((await draft.load())?['name'], 'Rui');

    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Concluir'));
    await tester.pumpAndSettle();
    expect(await draft.load(), isNull);
  });

  testWidgets('rascunho existente é carregado', (tester) async {
    final draft = InMemoryDraftStore();
    await draft.save({'name': 'Zé'});
    await tester.pumpWidget(_harness(onSubmit: (_) async {}, draft: draft));
    await tester.pumpAndSettle();
    expect(find.text('Zé'), findsOneWidget);
  });

  testWidgets('Alt+setas navegam por teclado', (tester) async {
    await tester.pumpWidget(_harness(onSubmit: (_) async {}));
    await tester.enterText(find.byKey(const Key('name')), 'Ana');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('phone')).hitTestable(), findsOneWidget);
    await tester.sendKeyDownEvent(LogicalKeyboardKey.altLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.altLeft);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('name')).hitTestable(), findsOneWidget);
  });
}
