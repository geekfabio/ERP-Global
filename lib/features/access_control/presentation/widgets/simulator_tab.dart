import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/access_models.dart';
import '../../domain/access_evaluator.dart';
import '../providers/access_providers.dart';
import 'access_labels.dart';

/// Testa as regras: valida uma tentativa de acesso 100% localmente, com as
/// zonas e regras já carregadas (sem chamar a rede).
class SimulatorTab extends ConsumerStatefulWidget {
  const SimulatorTab({super.key});

  @override
  ConsumerState<SimulatorTab> createState() => _SimulatorTabState();
}

class _SimulatorTabState extends ConsumerState<SimulatorTab> {
  String? _zoneId;
  AccessSubject _subject = AccessSubject.student;
  late DateTime _date = DateTime.now();
  late TimeOfDay _time = TimeOfDay.now();
  bool _studentActive = true;
  bool _financialClear = true;
  AccessDecision? _decision;

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) {
      setState(() {
        _time = t;
        _decision = null;
      });
    }
  }

  void _validate(List<ZoneModel> zones, List<AccessRuleModel> rules) {
    final zone = zones.where((z) => z.id == _zoneId).firstOrNull;
    final at = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );
    setState(() {
      _decision = evaluateAccess(
        attempt: AccessAttempt(
          zoneId: _zoneId ?? '',
          at: at,
          subject: _subject,
          studentActive: _studentActive,
          financialClear: _financialClear,
        ),
        zone: zone,
        rules: rules,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final zones = ref.watch(zoneListProvider);
    final rules = ref.watch(accessRuleListProvider);
    return AsyncValueView<List<ZoneModel>>(
      value: zones,
      onRetry: () => ref.invalidate(zoneListProvider),
      data: (zoneList) => AsyncValueView<List<AccessRuleModel>>(
        value: rules,
        onRetry: () => ref.invalidate(accessRuleListProvider),
        data: (ruleList) => _form(zoneList, ruleList),
      ),
    );
  }

  Widget _form(List<ZoneModel> zoneList, List<AccessRuleModel> ruleList) {
    final decision = _decision;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSearchableSelect<String>(
                key: const Key('sim_zone'),
                label: 'Zona',
                options: {for (final z in zoneList) z.id: z.name},
                value: _zoneId,
                onSelected: (v) => setState(() {
                  _zoneId = v;
                  _decision = null;
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              AppSearchableSelect<AccessSubject>(
                key: const Key('sim_subject'),
                label: 'Tipo de pessoa',
                options: {
                  for (final s in AccessSubject.values.where(
                    (s) => s != AccessSubject.all,
                  ))
                    s: subjectLabel(s),
                },
                value: _subject,
                onSelected: (v) => setState(() {
                  _subject = v ?? _subject;
                  _decision = null;
                }),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppDateField(
                      key: const Key('sim_date'),
                      label: 'Data',
                      value: _date,
                      onChanged: (d) => setState(() {
                        _date = d;
                        _decision = null;
                      }),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  OutlinedButton(
                    key: const Key('sim_time'),
                    onPressed: _pickTime,
                    child: Text(formatMinute(_time.hour * 60 + _time.minute)),
                  ),
                ],
              ),
              SwitchListTile(
                key: const Key('sim_student_active'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Aluno activo'),
                value: _studentActive,
                onChanged: (v) => setState(() {
                  _studentActive = v;
                  _decision = null;
                }),
              ),
              SwitchListTile(
                key: const Key('sim_financial'),
                contentPadding: EdgeInsets.zero,
                title: const Text('Situação financeira regularizada'),
                value: _financialClear,
                onChanged: (v) => setState(() {
                  _financialClear = v;
                  _decision = null;
                }),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: 'Validar acesso',
                icon: Icons.verified_user_outlined,
                onPressed: _zoneId == null
                    ? null
                    : () => _validate(zoneList, ruleList),
              ),
              if (decision != null) ...[
                const SizedBox(height: AppSpacing.lg),
                Row(
                  key: const Key('sim_result'),
                  children: [
                    StatusBadge(
                      label: decision.allowed ? 'Permitido' : 'Negado',
                      status: decision.allowed
                          ? BadgeStatus.success
                          : BadgeStatus.danger,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        decision.rule == null
                            ? reasonLabel(decision.reason)
                            : '${reasonLabel(decision.reason)} · ${decision.rule!.name}',
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
