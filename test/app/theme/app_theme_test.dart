import 'dart:math' as math;

import 'package:erp_global/app/app.dart';
import 'package:erp_global/app/theme/app_colors.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/app/theme/theme_catalog_page.dart';
import 'package:erp_global/app/theme/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_providers.dart';

double _lum(Color c) {
  double ch(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

double contrast(Color a, Color b) {
  final l1 = _lum(a);
  final l2 = _lum(b);
  return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
}

void main() {
  group('contraste AA (>= 4.5)', () {
    for (final entry in {
      'claro': (AppColors.light, Brightness.light),
      'escuro': (AppColors.dark, Brightness.dark),
    }.entries) {
      final c = entry.value.$1;
      test('cores semânticas ${entry.key}', () {
        expect(contrast(c.success, c.onSuccess), greaterThanOrEqualTo(4.5));
        expect(contrast(c.warning, c.onWarning), greaterThanOrEqualTo(4.5));
        expect(contrast(c.danger, c.onDanger), greaterThanOrEqualTo(4.5));
        expect(contrast(c.info, c.onInfo), greaterThanOrEqualTo(4.5));
      });

      test('cores de módulo ${entry.key} sobre a superfície', () {
        final surface = ColorScheme.fromSeed(
          seedColor: defaultBrandColor,
          brightness: entry.value.$2,
        ).surface;
        for (final m in [c.academic, c.finance, c.canteen, c.access]) {
          expect(contrast(m, surface), greaterThanOrEqualTo(4.5));
        }
      });
    }

    test('esquema M3 primary/onPrimary', () {
      for (final t in [AppTheme.light(), AppTheme.dark()]) {
        expect(
          contrast(t.colorScheme.primary, t.colorScheme.onPrimary),
          greaterThanOrEqualTo(4.5),
        );
      }
    });
  });

  test('tema inclui extensão AppColors e respeita a marca', () {
    const brand = Color(0xFF00695C);
    final t = AppTheme.light(brand);
    expect(t.extension<AppColors>(), isNotNull);
    expect(t.colorScheme.primary, isNot(AppTheme.light().colorScheme.primary));
  });

  testWidgets('trocar tema claro/escuro em runtime', (tester) async {
    final container = ProviderContainer(
      overrides: [
        sessionStorageProvider.overrideWithValue(InMemorySessionStorage()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ErpGlobalApp(),
      ),
    );
    await tester.pumpAndSettle();

    Brightness current() =>
        Theme.of(tester.element(find.byType(Scaffold).first)).brightness;

    container.read(themeModeProvider.notifier).set(ThemeMode.light);
    await tester.pumpAndSettle();
    expect(current(), Brightness.light);

    container.read(themeModeProvider.notifier).set(ThemeMode.dark);
    await tester.pumpAndSettle();
    expect(current(), Brightness.dark);
  });

  testWidgets('catálogo renderiza', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const ThemeCatalogPage(),
        ),
      ),
    );
    expect(find.text('Catálogo de tema'), findsOneWidget);
  });
}
