import '../data/models/access_models.dart';

/// Motivo de uma decisão de acesso.
enum AccessReason {
  granted,
  zoneInactive,
  noRule,
  outsideSchedule,
  studentInactive,
  financialPending,
}

/// Tentativa de acesso a validar (tudo local, sem rede). [at] é a hora de
/// parede local (Angola não tem hora de verão).
class AccessAttempt {
  const AccessAttempt({
    required this.zoneId,
    required this.at,
    this.subject = AccessSubject.student,
    this.studentActive = true,
    this.financialClear = true,
  });

  final String zoneId;
  final DateTime at;
  final AccessSubject subject;
  final bool studentActive;
  final bool financialClear;
}

class AccessDecision {
  const AccessDecision(this.reason, {this.rule});

  final AccessReason reason;

  /// Regra que concedeu o acesso.
  final AccessRuleModel? rule;

  bool get allowed => reason == AccessReason.granted;
}

/// Avalia o acesso só com as regras em memória: a zona tem de estar activa e
/// alguma regra activa da zona tem de cobrir tipo, dia e hora e cumprir as
/// condições de aluno/financeiro.
AccessDecision evaluateAccess({
  required AccessAttempt attempt,
  required ZoneModel? zone,
  required Iterable<AccessRuleModel> rules,
}) {
  if (zone == null || !zone.isActive) {
    return const AccessDecision(AccessReason.zoneInactive);
  }
  final candidates = rules
      .where((r) => r.isActive && r.zoneId == zone.id)
      .where(
        (r) => r.subject == AccessSubject.all || r.subject == attempt.subject,
      )
      .toList();
  if (candidates.isEmpty) return const AccessDecision(AccessReason.noRule);

  final minute = attempt.at.hour * 60 + attempt.at.minute;
  final inWindow = candidates.where(
    (r) =>
        r.days.contains(attempt.at.weekday) &&
        minute >= r.startMinute &&
        minute < r.endMinute,
  );
  if (inWindow.isEmpty) {
    return const AccessDecision(AccessReason.outsideSchedule);
  }

  var studentBlocked = false;
  for (final r in inWindow) {
    if (r.requireActiveStudent && !attempt.studentActive) {
      studentBlocked = true;
    } else if (!(r.requireFinancialClear && !attempt.financialClear)) {
      return AccessDecision(AccessReason.granted, rule: r);
    }
  }
  return AccessDecision(
    studentBlocked
        ? AccessReason.studentInactive
        : AccessReason.financialPending,
  );
}

/// "HH:mm" a partir de minutos desde as 00:00 (1440 → "24:00").
String formatMinute(int minute) =>
    '${(minute ~/ 60).toString().padLeft(2, '0')}:'
    '${(minute % 60).toString().padLeft(2, '0')}';
