import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/portal_academic_models.dart';
import '../../domain/portal_academic_logic.dart';
import '../providers/portal_providers.dart';
import '../widgets/portal_pupil_page.dart';

/// Formulário de justificação de faltas injustificadas + estado dos pedidos.
class PortalJustificationPage extends StatelessWidget {
  const PortalJustificationPage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilPage(
    title: 'Justificar faltas',
    moduleCode: 'attendance',
    builder: (context, pupil) => _Justification(
      key: ValueKey(pupil.student.id),
      studentId: pupil.student.id,
    ),
  );
}

BadgeStatus _badge(PortalRequestStatus s) => switch (s) {
  PortalRequestStatus.pending => BadgeStatus.warning,
  PortalRequestStatus.approved => BadgeStatus.success,
  PortalRequestStatus.rejected => BadgeStatus.danger,
};

class _Justification extends ConsumerStatefulWidget {
  const _Justification({super.key, required this.studentId});

  final String studentId;

  @override
  ConsumerState<_Justification> createState() => _JustificationState();
}

class _JustificationState extends ConsumerState<_Justification> {
  final _reason = TextEditingController();
  DateTime? _date;
  bool _saving = false;
  Map<String, String> _errors = const {};

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final date = _date;
    if (date == null) {
      setState(() => _errors = {'date': 'Escolha a falta a justificar'});
      return;
    }
    setState(() {
      _saving = true;
      _errors = const {};
    });
    final result = await ref
        .read(portalRepositoryProvider)
        .requestJustification(
          widget.studentId,
          date: date,
          reason: _reason.text,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    final failure = result.failureOrNull;
    if (failure != null) {
      if (failure is ValidationFailure) {
        setState(() => _errors = failure.fields);
      }
      ref.read(toastProvider.notifier).error(failure.message);
      return;
    }
    ref.read(toastProvider.notifier).success('Pedido de justificação enviado');
    ref.invalidate(portalJustificationsProvider(widget.studentId));
    setState(() {
      _date = null;
      _reason.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(portalAttendanceProvider(widget.studentId));
    final requests = ref.watch(portalJustificationsProvider(widget.studentId));
    final text = Theme.of(context).textTheme;
    return AsyncValueView(
      value: attendance,
      onRetry: () => ref.invalidate(portalAttendanceProvider(widget.studentId)),
      loading: const SkeletonCard(),
      data: (a) => AsyncValueView<List<AbsenceJustificationRequest>>(
        value: requests,
        onRetry: () =>
            ref.invalidate(portalJustificationsProvider(widget.studentId)),
        loading: const SkeletonCard(),
        data: (list) {
          final open = justifiableAbsences(a, list);
          final selected = open.contains(_date) ? _date : null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (open.isEmpty)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text('Sem faltas por justificar'),
                  ),
                )
              else ...[
                DropdownButtonFormField<DateTime>(
                  key: ValueKey('date-${open.length}'),
                  initialValue: selected,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Falta',
                    errorText: _errors['date'],
                  ),
                  items: [
                    for (final d in open)
                      DropdownMenuItem(
                        value: d,
                        child: Text(PtAoFormatters.date(d)),
                      ),
                  ],
                  onChanged: _saving ? null : (d) => setState(() => _date = d),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _reason,
                  enabled: !_saving,
                  maxLines: 3,
                  maxLength: 500,
                  decoration: InputDecoration(
                    labelText: 'Motivo',
                    errorText: _errors['reason'],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: _saving ? null : _submit,
                    child: const Text('Enviar pedido'),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text('Pedidos enviados', style: text.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Column(
                  children: [
                    for (final j in list)
                      ListTile(
                        title: Text(PtAoFormatters.date(j.date)),
                        subtitle: Text(
                          j.reason,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: StatusBadge(
                          label: j.status.label,
                          status: _badge(j.status),
                        ),
                      ),
                    if (list.isEmpty)
                      const ListTile(title: Text('Ainda sem pedidos')),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
