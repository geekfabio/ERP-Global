import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../domain/import_engine.dart';
import '../../domain/import_profile.dart';
import '../providers/import_providers.dart';

/// Permissão exigida para gravar (confirmar) uma importação.
const importExecutePermission = 'import_export.import.execute';

/// Importação CSV/Excel: ficheiro → mapeamento → pré-visualização → confirmação.
class ImportPage extends ConsumerWidget {
  const ImportPage({super.key, this.pickFile});

  /// Selector de ficheiro (substituível em testes). Devolve nome e bytes.
  final Future<(String, Uint8List)?> Function()? pickFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importControllerProvider);
    final ctrl = ref.read(importControllerProvider.notifier);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Importação de ${state.profile.label.toLowerCase()}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              if (state.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      state.error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: switch (state.step) {
                  ImportStep.file => _FileStep(
                    profile: state.profile,
                    onPick: () => _pick(ref),
                  ),
                  ImportStep.mapping => _MappingStep(state: state, ctrl: ctrl),
                  ImportStep.preview => _PreviewStep(state: state, ctrl: ctrl),
                  ImportStep.done => _DoneStep(state: state, ctrl: ctrl),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(WidgetRef ref) async {
    final picked = await (pickFile ?? _defaultPick)();
    if (picked == null) return;
    ref.read(importControllerProvider.notifier).loadFile(picked.$1, picked.$2);
  }

  static Future<(String, Uint8List)?> _defaultPick() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['csv', 'xlsx'],
    );
    final file = files.firstOrNull;
    if (file == null) return null;
    return (file.name, await file.xFile.readAsBytes());
  }
}

class _FileStep extends StatelessWidget {
  const _FileStep({required this.profile, required this.onPick});

  final ImportProfile profile;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Escolha um ficheiro .csv ou .xlsx com cabeçalhos na primeira linha. '
        'Nada é gravado antes de confirmar.',
      ),
      const SizedBox(height: AppSpacing.md),
      Text(
        'Colunas: ${[for (final c in profile.columns) c.required ? '${c.label}*' : c.label].join(', ')}',
      ),
      const SizedBox(height: AppSpacing.lg),
      AppButton(
        label: 'Escolher ficheiro',
        icon: Icons.upload_file,
        onPressed: onPick,
      ),
    ],
  );
}

class _MappingStep extends StatelessWidget {
  const _MappingStep({required this.state, required this.ctrl});

  final ImportState state;
  final ImportController ctrl;

  @override
  Widget build(BuildContext context) {
    final headers = state.table!.headers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${state.fileName} · ${state.table!.rows.length} linhas. '
          'Associe cada campo a uma coluna do ficheiro.',
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: ListView(
            children: [
              for (final c in state.profile.columns)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: DropdownButtonFormField<int?>(
                    key: ValueKey('map_${c.key}'),
                    initialValue: state.mapping[c.key],
                    decoration: InputDecoration(
                      labelText: c.required ? '${c.label} *' : c.label,
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('— não importar —'),
                      ),
                      for (var i = 0; i < headers.length; i++)
                        DropdownMenuItem(value: i, child: Text(headers[i])),
                    ],
                    onChanged: (v) => ctrl.setMapping(c.key, v),
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            AppButton(
              label: 'Voltar',
              variant: AppButtonVariant.secondary,
              onPressed: ctrl.back,
            ),
            const SizedBox(width: AppSpacing.md),
            AppButton(
              label: 'Pré-visualizar',
              onPressed: ctrl.canPreview ? ctrl.buildPreview : null,
            ),
          ],
        ),
      ],
    );
  }
}

class _PreviewStep extends ConsumerWidget {
  const _PreviewStep({required this.state, required this.ctrl});

  final ImportState state;
  final ImportController ctrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preview = state.preview!;
    final profile = state.profile;
    final controller = TableController<ImportRowResult>(
      rows: preview.rows,
      rowId: (r) => r.lineNumber,
      columns: [
        AppColumn(
          label: 'Linha',
          text: (r) => '${r.lineNumber}',
          sortValue: (r) => r.lineNumber,
          numeric: true,
        ),
        for (final c in profile.columns)
          AppColumn(label: c.label, text: (r) => _cell(state, r, c.key)),
        AppColumn(
          label: 'Estado',
          text: (r) =>
              r.isValid ? 'Válida' : r.errors.map((e) => e.message).join('; '),
          cell: (r) => r.isValid
              ? const StatusBadge(label: 'Válida', status: BadgeStatus.success)
              : Tooltip(
                  message: r.errors.map((e) => e.message).join('\n'),
                  child: StatusBadge(
                    label: r.errors.first.message,
                    status: BadgeStatus.danger,
                  ),
                ),
        ),
      ],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${preview.valid.length} linhas válidas · '
          '${preview.invalid.length} com erros. '
          'Só as válidas serão gravadas.',
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(child: AppDataTable<ImportRowResult>(controller: controller)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(
              label: 'Voltar',
              variant: AppButtonVariant.secondary,
              onPressed: ctrl.back,
            ),
            if (preview.invalid.isNotEmpty)
              AppButton(
                label: 'Descarregar relatório de erros',
                icon: Icons.download,
                variant: AppButtonVariant.secondary,
                onPressed: () => _saveReport(ref),
              ),
            Can(
              permission: importExecutePermission,
              child: AppButton(
                label: 'Confirmar importação (${preview.valid.length})',
                loading: state.busy,
                onPressed: preview.valid.isEmpty ? null : ctrl.confirm,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _cell(ImportState s, ImportRowResult r, String key) {
    final i = s.mapping[key];
    return i == null || i >= r.raw.length ? '' : r.raw[i];
  }

  Future<void> _saveReport(WidgetRef ref) async {
    final bytes = Uint8List.fromList(utf8.encode('﻿${ctrl.errorReport()}'));
    try {
      final saved = await FilePicker.saveFile(
        fileName: 'relatorio-erros-importacao.csv',
        bytes: bytes,
        mimeType: 'text/csv',
      );
      if (saved != null) {
        ref.read(toastProvider.notifier).success('Relatório guardado.');
      }
    } on Object {
      ref.read(toastProvider.notifier).error('Não foi possível guardar.');
    }
  }
}

class _DoneStep extends StatelessWidget {
  const _DoneStep({required this.state, required this.ctrl});

  final ImportState state;
  final ImportController ctrl;

  @override
  Widget build(BuildContext context) {
    final result = state.result!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${result.imported} registos importados.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if (result.rejected.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text('${result.rejected.length} rejeitados pelo servidor:'),
          for (final r in result.rejected)
            Text('• registo ${r.index + 1}: ${r.errors.values.join('; ')}'),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: 'Nova importação', onPressed: ctrl.reset),
      ],
    );
  }
}
