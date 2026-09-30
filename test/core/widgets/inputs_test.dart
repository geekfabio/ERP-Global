import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/inputs/app_inputs.dart';
import 'package:erp_global/core/widgets/inputs/money_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: Scaffold(body: Form(child: child)),
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('parseMinorUnits', () {
    const cases = {
      '1234,56': 123456,
      '1 234,56': 123456,
      '1.234,56': 123456,
      '1234.5': 123450,
      '1.234': 123400,
      '500': 50000,
      '500 Kz': 50000,
      '0,05': 5,
      ',5': 50,
      '-10,00': -1000,
    };
    cases.forEach((input, expected) {
      test(
        '"$input" → $expected',
        () => expect(parseMinorUnits(input), expected),
      );
    });

    for (final bad in ['', 'abc', '1,234', '1,2,3', '12,345.6']) {
      test('"$bad" é inválido', () => expect(parseMinorUnits(bad), isNull));
    }
  });

  testWidgets('AppMoneyField devolve int e valida', (tester) async {
    int? last;
    await tester.pumpWidget(
      _wrap(AppMoneyField(required: true, onChanged: (v) => last = v)),
    );
    await tester.enterText(find.byType(TextFormField), '2 500,75');
    expect(last, 250075);
    await tester.enterText(find.byType(TextFormField), '1,234');
    await tester.pump();
    expect(find.text('Valor inválido'), findsOneWidget);
    expect(last, isNull);
  });

  testWidgets('AppMoneyField obrigatório mostra erro quando vazio', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const AppMoneyField(required: true)));
    await tester.enterText(find.byType(TextFormField), '1');
    await tester.enterText(find.byType(TextFormField), '');
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);
  });

  test('AppPhoneField.normalize', () {
    expect(AppPhoneField.normalize('+244 923 456 789'), '923456789');
    expect(AppPhoneField.normalize('923456789'), '923456789');
    expect(AppPhoneField.normalize('00244923456789'), '923456789');
    expect(AppPhoneField.normalize('823456789'), isNull);
    expect(AppPhoneField.normalize('92345'), isNull);
  });

  testWidgets('AppPhoneField valida número', (tester) async {
    await tester.pumpWidget(_wrap(const AppPhoneField()));
    await tester.enterText(find.byType(TextFormField), '12345');
    await tester.pump();
    expect(find.text('Número angolano inválido'), findsOneWidget);
  });

  testWidgets('AppPasswordField alterna visibilidade', (tester) async {
    await tester.pumpWidget(_wrap(const AppPasswordField()));
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );
    await tester.tap(find.byTooltip('Mostrar palavra-passe'));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );
  });

  testWidgets('AppTextField tem label acessível e estado desactivado', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(const AppTextField(label: 'Nome', enabled: false)),
    );
    expect(find.text('Nome'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
  });

  testWidgets('AppSearchableSelect filtra e selecciona', (tester) async {
    String? picked;
    await tester.pumpWidget(
      _wrap(
        AppSearchableSelect<String>(
          label: 'Turma',
          options: const {'a': 'Turma A', 'b': 'Turma B', 'c': 'Outra'},
          onSelected: (v) => picked = v,
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Turma');
    await tester.pumpAndSettle();
    expect(find.text('Outra'), findsNothing);
    await tester.tap(find.text('Turma B').last);
    await tester.pumpAndSettle();
    expect(picked, 'b');
  });

  testWidgets('AppDateField mostra data formatada', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppDateField(
          label: 'Nascimento',
          value: DateTime.utc(2010, 3, 7),
          onChanged: (_) {},
        ),
      ),
    );
    expect(find.text('07/03/2010'), findsOneWidget);
  });
}
