import 'dart:typed_data';

import 'package:erp_global/app/theme/app_colors.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/app/theme/app_tokens.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/widgets/app_avatar.dart';
import 'package:erp_global/core/widgets/app_button.dart';
import 'package:erp_global/core/widgets/cards/app_cards.dart';
import 'package:erp_global/core/widgets/charts/app_charts.dart';
import 'package:erp_global/core/widgets/inputs/app_inputs.dart';
import 'package:erp_global/core/widgets/states/app_states.dart';
import 'package:erp_global/core/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Comparador com tolerância pequena: o anti-aliasing e as sombras diferem
/// ligeiramente entre Windows/macOS/Linux, e os goldens correm no CI (Linux).
class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(super.testFile);

  /// Fracção máxima de píxeis diferentes aceite.
  static const tolerance = 0.02;

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= tolerance) return true;
    final error = await generateFailureOutput(result, golden, basedir);
    throw FlutterError(error);
  }
}

/// Catálogo do design system: tokens, botões, badges, inputs, cartões, estados
/// e gráficos, num único ecrã estável.
class _DesignSystemGallery extends StatelessWidget {
  const _DesignSystemGallery();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = context.appColors;
    final swatches = <String, Color>{
      'success': colors.success,
      'warning': colors.warning,
      'danger': colors.danger,
      'info': colors.info,
      'academic': colors.academic,
      'finance': colors.finance,
      'canteen': colors.canteen,
      'access': colors.access,
    };
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cores', style: text.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final e in swatches.entries)
                  Chip(
                    avatar: CircleAvatar(backgroundColor: e.value),
                    label: Text(e.key),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Tipografia', style: text.titleLarge),
            Text('Display', style: text.displaySmall),
            Text('Headline', style: text.headlineMedium),
            Text('Title', style: text.titleMedium),
            Text('Body', style: text.bodyMedium),
            Text('Label', style: text.labelMedium),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final v in AppButtonVariant.values)
                  AppButton(label: v.name, variant: v, onPressed: () {}),
                AppButton(label: 'icon', icon: Icons.add, onPressed: () {}),
                const AppButton(label: 'disabled', onPressed: null),
                AppIconButton(
                  icon: Icons.edit,
                  tooltip: 'Editar',
                  onPressed: () {},
                ),
                const AppAvatar(name: 'Maria Silva'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final s in BadgeStatus.values)
                  StatusBadge(label: s.name, status: s),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppTextField(label: 'Nome', initialValue: 'Maria'),
            const SizedBox(height: AppSpacing.sm),
            const AppTextField(label: 'Desactivado', enabled: false),
            const SizedBox(height: AppSpacing.sm),
            const AppPasswordField(),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    label: 'Alunos',
                    value: 1250,
                    deltaPercent: 4.5,
                    icon: Icons.school,
                    format: (v) => '$v',
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: KpiCard(
                    label: 'Em atraso',
                    value: 320,
                    deltaPercent: -2.0,
                    format: (v) => '$v',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const EntityCard(title: 'Turma 7.ª A', subtitle: '32 alunos'),
            const SizedBox(height: AppSpacing.md),
            const EmptyState(title: 'Sem registos', message: 'Nada a mostrar.'),
            ErrorState(
              failure: UnknownFailure(code: 'unknown', message: 'Falhou.'),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppBarChart(
              values: [3, 5, 2, 8, 6],
              labels: ['A', 'B', 'C', 'D', 'E'],
              semanticLabel: 'Barras',
              height: 120,
            ),
            AppDonutChart(
              slices: [
                DonutSlice(label: 'Pago', value: 70, color: colors.success),
                DonutSlice(label: 'Em falta', value: 30, color: colors.danger),
              ],
              semanticLabel: 'Pagamentos',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  final previous = goldenFileComparator;
  setUpAll(() {
    goldenFileComparator = _TolerantComparator(
      (previous as LocalFileComparator).basedir.resolve(
        'design_system_golden_test.dart',
      ),
    );
  });
  tearDownAll(() => goldenFileComparator = previous);

  final themes = {'light': AppTheme.light(), 'dark': AppTheme.dark()};
  final sizes = {
    'mobile': const Size(390, 2000),
    'desktop': const Size(1024, 2000),
  };

  for (final theme in themes.entries) {
    for (final size in sizes.entries) {
      testWidgets('catálogo do design system ${theme.key}/${size.key}', (
        tester,
      ) async {
        tester.view.physicalSize = size.value;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme.value,
            home: const _DesignSystemGallery(),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/design_system_${theme.key}_${size.key}.png',
          ),
        );
      });
    }
  }
}
