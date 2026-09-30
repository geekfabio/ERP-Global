import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_colors.dart';
import 'app_theme.dart';
import 'app_tokens.dart';
import 'theme_providers.dart';

/// Catálogo simples para pré-visualizar tokens e componentes base.
class ThemeCatalogPage extends ConsumerWidget {
  const ThemeCatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final colors = context.appColors;
    final mode = ref.watch(themeModeProvider);
    final swatches = <String, Color>{
      'success': colors.success,
      'warning': colors.warning,
      'danger': colors.danger,
      'info': colors.info,
      'académico': colors.academic,
      'financeiro': colors.finance,
      'refeitório': colors.canteen,
      'acessos': colors.access,
    };
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de tema')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Escuro')),
              ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
            ],
            selected: {mode},
            onSelectionChanged: (s) =>
                ref.read(themeModeProvider.notifier).set(s.first),
          ),
          const SizedBox(height: AppSpacing.xl),
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
          const SizedBox(height: AppSpacing.xl),
          Text('Tipografia', style: text.titleLarge),
          Text('Display', style: text.displaySmall),
          Text('Headline', style: text.headlineMedium),
          Text('Title', style: text.titleMedium),
          Text('Body', style: text.bodyMedium),
          Text('Label', style: text.labelMedium),
          Text('0123456789 · ABC-2026', style: text.mono),
          const SizedBox(height: AppSpacing.xl),
          Text('Componentes', style: text.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton(onPressed: () {}, child: const Text('Primário')),
              OutlinedButton(onPressed: () {}, child: const Text('Secundário')),
              TextButton(onPressed: () {}, child: const Text('Texto')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const TextField(decoration: InputDecoration(labelText: 'Campo')),
          const SizedBox(height: AppSpacing.lg),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Text('Card'),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text('Marca: #${_hex(ref.watch(brandColorProvider))}'),
        ],
      ),
    );
  }

  static String _hex(Color c) =>
      c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
}
