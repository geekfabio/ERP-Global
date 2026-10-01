import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/accounting_models.dart';
import '../providers/accounting_providers.dart';
import 'accounting_form_dialog.dart';

/// Exercícios contabilísticos: criação e fecho.
class FiscalYearsTab extends ConsumerStatefulWidget {
  const FiscalYearsTab({super.key});

  @override
  ConsumerState<FiscalYearsTab> createState() => _FiscalYearsTabState();
}

class _FiscalYearsTabState extends ConsumerState<FiscalYearsTab> {
  void _refresh() => ref.invalidate(fiscalYearListProvider);

  Future<void> _create() async {
    final v = await showAccountingForm(
      context,
      title: 'Novo exercício',
      fields: const [
        FormFieldSpec('name', 'Designação'),
        FormFieldSpec('startDate', 'Início', kind: FieldKind.date),
        FormFieldSpec('endDate', 'Fim', kind: FieldKind.date),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(fiscalYearRepositoryProvider)
        .create(
          FiscalYearModel(
            id: '',
            name: v['name']! as String,
            startDate: v['startDate']! as DateTime,
            endDate: v['endDate']! as DateTime,
          ),
        );
    if (reportResult(ref, result, done: 'Exercício criado')) _refresh();
  }

  Future<void> _close(FiscalYearModel y) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Fechar exercício',
      message: 'Fechar "${y.name}"? Esta acção não pode ser revertida.',
      confirmLabel: 'Fechar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref.read(fiscalYearRepositoryProvider).close(y.id);
    if (reportResult(ref, result, done: 'Exercício fechado')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final years = ref.watch(fiscalYearListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'accounting.fiscalyear.create',
              child: AppButton(
                label: 'Novo exercício',
                icon: Icons.add,
                onPressed: _create,
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<FiscalYearModel>>(
            value: years,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.event_outlined,
              title: 'Sem exercícios',
            ),
            data: (items) => ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final y = items[i];
                final open = y.status == FiscalYearStatus.open;
                return ListTile(
                  key: Key('year_${y.name}'),
                  title: Text(y.name),
                  subtitle: Text(
                    '${PtAoFormatters.date(y.startDate)} – '
                    '${PtAoFormatters.date(y.endDate)}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatusBadge(
                        label: open ? 'Aberto' : 'Fechado',
                        status: open
                            ? BadgeStatus.success
                            : BadgeStatus.neutral,
                      ),
                      if (open && can('accounting.fiscalyear.close'))
                        Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.sm),
                          child: TextButton(
                            onPressed: () => _close(y),
                            child: const Text('Fechar'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
