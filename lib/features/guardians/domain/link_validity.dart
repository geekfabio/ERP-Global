import '../../students/data/models/guardian_model.dart';
import '../../students/data/models/student_enums.dart';

/// Estado da validade de um vínculo aluno↔encarregado.
enum LinkValidity {
  /// Sem fim, ou ainda longe do fim.
  active,

  /// Termina nos próximos [linkExpiringDays] dias.
  expiring,

  /// Já terminou: o encarregado perdeu o acesso/autorização.
  expired,
}

const linkExpiringDays = 30;

/// `validUntil` é uma data (UTC): o vínculo vale até ao fim desse dia.
LinkValidity linkValidity(GuardianLinkModel link, DateTime now) {
  final until = link.validUntil;
  if (until == null) return LinkValidity.active;
  final end = DateTime.utc(
    until.year,
    until.month,
    until.day,
  ).add(const Duration(days: 1));
  final utc = now.toUtc();
  if (!utc.isBefore(end)) return LinkValidity.expired;
  if (end.difference(utc).inDays < linkExpiringDays) {
    return LinkValidity.expiring;
  }
  return LinkValidity.active;
}

/// Nome apresentado do parentesco.
String guardianRelationshipLabel(GuardianRelationship r) => switch (r) {
  GuardianRelationship.father => 'Pai',
  GuardianRelationship.mother => 'Mãe',
  GuardianRelationship.tutor => 'Tutor',
  GuardianRelationship.grandparent => 'Avô/Avó',
  GuardianRelationship.sibling => 'Irmão/Irmã',
  GuardianRelationship.uncleAunt => 'Tio/Tia',
  GuardianRelationship.other => 'Outro',
};
