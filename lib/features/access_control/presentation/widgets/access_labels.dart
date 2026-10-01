import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/access_models.dart';
import '../../domain/access_evaluator.dart';

const weekdayShort = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

String daysLabel(List<int> days) =>
    days.map((d) => weekdayShort[d - 1]).join(', ');

String subjectLabel(AccessSubject s) => switch (s) {
  AccessSubject.all => 'Todos',
  AccessSubject.student => 'Alunos',
  AccessSubject.staff => 'Funcionários',
  AccessSubject.guardian => 'Encarregados',
};

String deviceKindLabel(DeviceKind k) => switch (k) {
  DeviceKind.turnstile => 'Torniquete',
  DeviceKind.reader => 'Leitor',
  DeviceKind.door => 'Porta',
};

String deviceStatusLabel(DeviceStatus s) => switch (s) {
  DeviceStatus.online => 'Online',
  DeviceStatus.offline => 'Offline',
};

BadgeStatus deviceStatusBadge(DeviceStatus s) => switch (s) {
  DeviceStatus.online => BadgeStatus.success,
  DeviceStatus.offline => BadgeStatus.danger,
};

String activeLabel(bool active) => active ? 'Activo' : 'Inactivo';

BadgeStatus activeBadge(bool active) =>
    active ? BadgeStatus.success : BadgeStatus.neutral;

String reasonLabel(AccessReason r) => switch (r) {
  AccessReason.granted => 'Acesso permitido',
  AccessReason.zoneInactive => 'Zona inactiva',
  AccessReason.noRule => 'Sem regra para este tipo de pessoa',
  AccessReason.outsideSchedule => 'Fora do horário permitido',
  AccessReason.studentInactive => 'Aluno não está activo',
  AccessReason.financialPending => 'Situação financeira pendente',
};

String ruleWindowLabel(AccessRuleModel r) =>
    '${daysLabel(r.days)} · ${formatMinute(r.startMinute)}–${formatMinute(r.endMinute)}';

/// Toast de sucesso ([done]) ou do erro do `Failure`; devolve `true` se correu bem.
bool reportResult<T>(WidgetRef ref, Result<T> result, {required String done}) {
  final toast = ref.read(toastProvider.notifier);
  return result.when(
    ok: (_) {
      toast.success(done);
      return true;
    },
    err: (f) {
      toast.error(f.message);
      return false;
    },
  );
}
