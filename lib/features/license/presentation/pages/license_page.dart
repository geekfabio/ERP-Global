import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/modules/module_catalog.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/license_model.dart';
import '../../domain/license_service.dart';
import '../../domain/license_status.dart';
import '../providers/license_providers.dart';
import '../providers/license_usage_providers.dart';

/// Lê o texto de uma licença escolhida pelo utilizador (`null` = cancelou).
typedef LicenseFilePicker = Future<String?> Function();

Future<String?> _pickLicenseFile() async {
  final files = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['json', 'lic', 'txt'],
  );
  final file = files.firstOrNull;
  return file == null ? null : utf8.decode(await file.xFile.readAsBytes());
}

/// Nome e cor do selo de cada estado da licença.
(String, BadgeStatus) licenseStateBadge(LicenseState state) => switch (state) {
  LicenseState.active => ('Activa', BadgeStatus.success),
  LicenseState.grace => ('Em período de graça', BadgeStatus.warning),
  LicenseState.readOnly => ('Expirada — só leitura', BadgeStatus.danger),
  LicenseState.clockTampered => ('Relógio recuado', BadgeStatus.danger),
  LicenseState.invalid => ('Inválida', BadgeStatus.danger),
  LicenseState.missing => ('Sem licença', BadgeStatus.danger),
};

const _limitLabels = <String, String>{
  'students': 'Alunos',
  'campuses': 'Campus',
  'users': 'Utilizadores',
  'devices': 'Dispositivos',
};

/// Ecrã de licença: estado, plano, módulos, limites e consumo, e activação de
/// uma nova licença (só `super_admin`).
class LicenseOverviewPage extends ConsumerWidget {
  const LicenseOverviewPage({super.key, this.pickFile = _pickLicenseFile});

  final LicenseFilePicker pickFile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(licenseControllerProvider);
    final service = ref.watch(licenseServiceProvider);
    return snapshot.when(
      loading: () => const SkeletonList(),
      error: (e, _) => EmptyState(
        icon: Icons.error_outline,
        title: 'Não foi possível ler a licença',
        actionLabel: 'Tentar novamente',
        onAction: () => ref.invalidate(licenseControllerProvider),
      ),
      data: (s) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Text('Licença', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.md),
              _SummaryCard(license: service.license, status: s.status),
              const SizedBox(height: AppSpacing.md),
              _UsageCard(license: service.license),
              const SizedBox(height: AppSpacing.md),
              _ModulesCard(license: service.license, enabled: s.enabledModules),
              const SizedBox(height: AppSpacing.md),
              _ActivateCard(pickFile: pickFile),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.license, required this.status});

  final LicenseModel? license;
  final LicenseStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, badge) = licenseStateBadge(status.state);
    final l = license;
    final days = status.daysLeft;
    final daysText = days == null
        ? null
        : status.state == LicenseState.grace
        ? 'Restam $days dia(s) de período de graça'
        : 'Faltam $days dia(s) para expirar';
    final lines = <(String, String)>[
      if (l != null) ...[
        ('Instituição', l.institutionName),
        ('Plano', l.plan),
        ('Emitida em', PtAoFormatters.date(l.issuedAt)),
        ('Válida até', PtAoFormatters.date(l.expiresAt)),
        ('Período de graça', '${l.graceDays} dia(s)'),
        ('Identificador', l.licenseId),
      ],
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Estado da licença',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: AppSpacing.md),
                StatusBadge(label: label, status: badge),
              ],
            ),
            if (daysText != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(daysText),
            ],
            if (l == null) ...[
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Active uma licença para usar os módulos contratados.',
              ),
            ],
            if (status.isReadOnly || status.state == LicenseState.grace) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                status.isReadOnly
                    ? 'Os dados estão seguros, mas só é possível consultar. '
                          'Active uma licença renovada para voltar a editar.'
                    : 'Tudo funciona, mas renove a licença antes de terminar a graça.',
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            for (final (k, v) in lines)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160,
                      child: Text(
                        k,
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    Expanded(child: SelectableText(v)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UsageCard extends ConsumerWidget {
  const _UsageCard({required this.license});

  final LicenseModel? license;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usage = ref.watch(licenseUsageProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Limites e consumo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            usage.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Row(
                children: [
                  const Expanded(
                    child: Text('Não foi possível obter o consumo.'),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(licenseUsageProvider),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
              data: (u) => Column(
                children: [
                  for (final key in _limitLabels.keys)
                    _UsageRow(
                      label: _limitLabels[key]!,
                      used: u[key],
                      limit: license?.limits[key],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({
    required this.label,
    required this.used,
    required this.limit,
  });

  final String label;
  final int used;

  /// `null` = ilimitado.
  final int? limit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final lim = limit;
    final ratio = lim == null || lim == 0 ? 0.0 : used / lim;
    final over = lim != null && used > lim;
    final color = over || ratio >= 1
        ? colors.danger
        : ratio >= 0.9
        ? colors.warning
        : Theme.of(context).colorScheme.primary;
    final text = lim == null ? '$used · Ilimitado' : '$used de $lim';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label)),
              Text(text, key: Key('usage_$label')),
            ],
          ),
          if (lim != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Semantics(
              label: '$label: $text',
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0),
                color: color,
                minHeight: 8,
              ),
            ),
          ],
          if (over)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Limite excedido: não é possível criar novos registos.',
                style: TextStyle(color: colors.danger),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModulesCard extends ConsumerWidget {
  const _ModulesCard({required this.license, required this.enabled});

  final LicenseModel? license;
  final Set<String> enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(moduleRegistryProvider).all;
    final licensed = license?.modules.toSet() ?? const <String>{};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Módulos', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            for (final m in modules)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(m.icon),
                title: Text(m.name),
                trailing: switch ((
                  licensed.contains(m.code),
                  enabled.contains(m.code),
                )) {
                  (true, _) => const StatusBadge(
                    label: 'Licenciado',
                    status: BadgeStatus.success,
                  ),
                  (false, true) => const StatusBadge(
                    label: 'Incluído',
                    status: BadgeStatus.info,
                  ),
                  _ => const StatusBadge(
                    label: 'Não licenciado',
                    status: BadgeStatus.neutral,
                  ),
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivateCard extends ConsumerStatefulWidget {
  const _ActivateCard({required this.pickFile});

  final LicenseFilePicker pickFile;

  @override
  ConsumerState<_ActivateCard> createState() => _ActivateCardState();
}

class _ActivateCardState extends ConsumerState<_ActivateCard> {
  final _text = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _import() async {
    final content = await widget.pickFile();
    if (content == null || !mounted) return;
    _text.text = content;
    await _activate();
  }

  Future<void> _activate() async {
    final raw = _text.text.trim();
    if (raw.isEmpty) {
      setState(() => _error = 'Cole a licença ou importe o ficheiro.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(licenseControllerProvider.notifier)
        .activate(raw);
    if (!mounted) return;
    setState(() => _busy = false);
    switch (result) {
      case Activated():
        _text.clear();
        ref.invalidate(licenseUsageProvider);
        ref.read(toastProvider.notifier).success('Licença activada');
      case ActivationRejected(:final reason):
        setState(() => _error = reason);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allowed = ref.watch(canActivateLicenseProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activar nova licença',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            if (!allowed)
              const Text('Só o super administrador pode activar licenças.')
            else ...[
              const Text(
                'A licença é validada offline (assinatura, datas e instituição). '
                'Se for inválida, a actual mantém-se.',
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _text,
                minLines: 3,
                maxLines: 8,
                decoration: InputDecoration(
                  labelText: 'Licença (JSON)',
                  errorText: _error,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  AppButton(
                    label: 'Activar licença',
                    icon: Icons.verified_outlined,
                    loading: _busy,
                    onPressed: _activate,
                  ),
                  AppButton(
                    label: 'Importar ficheiro',
                    icon: Icons.upload_file_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: _busy ? null : _import,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
