import 'package:erp_global/app/theme/app_colors.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/app_avatar.dart';
import 'package:erp_global/core/widgets/app_button.dart';
import 'package:erp_global/core/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light(defaultBrandColor),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('AppButton dispara onPressed e respeita loading', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(AppButton(label: 'Guardar', onPressed: () => taps++)),
    );
    await tester.tap(find.text('Guardar'));
    expect(taps, 1);

    await tester.pumpWidget(
      _wrap(
        AppButton(label: 'Guardar', loading: true, onPressed: () => taps++),
      ),
    );
    await tester.tap(find.byType(FilledButton));
    expect(taps, 1);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AppButton renderiza todas as variantes', (tester) async {
    for (final v in AppButtonVariant.values) {
      await tester.pumpWidget(
        _wrap(
          AppButton(
            label: v.name,
            variant: v,
            icon: Icons.add,
            onPressed: () {},
          ),
        ),
      );
      expect(find.text(v.name), findsOneWidget);
    }
  });

  testWidgets('AppButton desactivado sem onPressed', (tester) async {
    await tester.pumpWidget(
      _wrap(const AppButton(label: 'X', onPressed: null)),
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).enabled,
      isFalse,
    );
  });

  testWidgets('AppIconButton tem tooltip', (tester) async {
    await tester.pumpWidget(
      _wrap(
        AppIconButton(icon: Icons.edit, tooltip: 'Editar', onPressed: () {}),
      ),
    );
    expect(find.byTooltip('Editar'), findsOneWidget);
  });

  testWidgets('StatusBadge usa as cores semânticas do tema', (tester) async {
    await tester.pumpWidget(
      _wrap(const StatusBadge(label: 'Pago', status: BadgeStatus.success)),
    );
    final box = tester.widget<DecoratedBox>(
      find.byKey(const Key('status_badge_box')),
    );
    expect((box.decoration as BoxDecoration).color, AppColors.light.success);
  });

  test('AppAvatar.initialsOf', () {
    expect(AppAvatar.initialsOf('ana maria neto'), 'AN');
    expect(AppAvatar.initialsOf('  João '), 'J');
    expect(AppAvatar.initialsOf(''), '?');
  });

  testWidgets('AppAvatar mostra iniciais sem foto', (tester) async {
    await tester.pumpWidget(_wrap(const AppAvatar(name: 'Ana Neto')));
    expect(find.text('AN'), findsOneWidget);
  });
}
