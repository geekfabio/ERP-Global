import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// Testes nesta pasta para respeitar o âmbito autorizado da pista.
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';

import 'app_localizations.dart';

void main() {
  test('pt-AO é a primeira opção e tem todas as chaves do catálogo base', () {
    expect(AppLocalizations.supportedLocales.first, const Locale('pt', 'AO'));
    Map<String, dynamic> read(String name) =>
        jsonDecode(File('lib/app/l10n/$name.arb').readAsStringSync())
            as Map<String, dynamic>;
    final base = read('app_pt');
    final angola = read('app_pt_AO');
    expect(
      angola.keys.where((key) => !key.startsWith('@')).toSet(),
      base.keys.where((key) => !key.startsWith('@')).toSet(),
    );
  });

  testWidgets('delegates carregam pt-AO e widgets Material em português', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pt', 'AO'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final strings = AppLocalizations.of(context);
            return Text('${strings.loginTitle} / ${strings.passwordLabel}');
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sessão / Palavra-passe'), findsOneWidget);
    final context = tester.element(find.byType(Text));
    expect(Localizations.localeOf(context), const Locale('pt', 'AO'));
    expect(MaterialLocalizations.of(context).cancelButtonLabel, 'Cancelar');
  });
}
