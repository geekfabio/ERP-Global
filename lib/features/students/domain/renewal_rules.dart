import '../data/models/enrollment_model.dart';

/// O que fazer a cada aluno na renovação em massa.
enum RenewalAction { promote, repeat, skip }

String renewalActionLabel(RenewalAction a) => switch (a) {
  RenewalAction.promote => 'Classe seguinte',
  RenewalAction.repeat => 'Repete a classe',
  RenewalAction.skip => 'Não renovar',
};

/// Valor JSON da acção (`promote`, `repeat`, `skip`).
String renewalActionWire(RenewalAction a) => a.name;

/// Resultado final (valor de `FinalResult` das notas, como texto:
/// `approved`, `failed`, `recourse`, `transitsWithDeficiency`, `pending`).
String renewalResultLabel(String? result) => switch (result) {
  'approved' => 'Aprovado',
  'failed' => 'Reprovado',
  'recourse' => 'Recurso',
  'transitsWithDeficiency' => 'Transita com deficiência',
  'pending' => 'Pendente',
  _ => 'Sem resultado',
};

/// Acção por omissão: aprovado (ou transita com deficiência) → classe
/// seguinte; reprovado → repete; recurso/pendente/sem resultado → o
/// utilizador decide (por omissão fica de fora).
RenewalAction defaultRenewalAction(String? result) => switch (result) {
  'approved' || 'transitsWithDeficiency' => RenewalAction.promote,
  'failed' => RenewalAction.repeat,
  _ => RenewalAction.skip,
};

/// Classe de destino. [orderedGradeIds] vem ordenada da menor para a maior;
/// promover a partir da última classe não tem destino (`null`).
String? targetGradeFor(
  RenewalAction action,
  String currentGradeId,
  List<String> orderedGradeIds,
) {
  switch (action) {
    case RenewalAction.skip:
      return null;
    case RenewalAction.repeat:
      return currentGradeId;
    case RenewalAction.promote:
      final i = orderedGradeIds.indexOf(currentGradeId);
      if (i < 0 || i + 1 >= orderedGradeIds.length) return null;
      return orderedGradeIds[i + 1];
  }
}

/// Linha da pré-visualização (matrícula de origem + resultado + decisão).
class RenewalRow {
  const RenewalRow({
    required this.enrollment,
    required this.studentName,
    required this.processNumber,
    required this.alreadyRenewed,
    required this.result,
    required this.action,
    required this.targetGradeId,
  });

  final EnrollmentModel enrollment;
  final String studentName;
  final String processNumber;

  /// Já tem matrícula no ano de destino: não é renovado outra vez.
  final bool alreadyRenewed;

  /// Resultado final da pauta (`null` = pauta sem resultado).
  final String? result;
  final RenewalAction action;

  /// `null` quando [action] é `skip` ou não há classe seguinte.
  final String? targetGradeId;

  bool get willRenew => !alreadyRenewed && targetGradeId != null;

  RenewalRow withAction(RenewalAction next, List<String> orderedGradeIds) =>
      RenewalRow(
        enrollment: enrollment,
        studentName: studentName,
        processNumber: processNumber,
        alreadyRenewed: alreadyRenewed,
        result: result,
        action: next,
        targetGradeId: targetGradeFor(
          next,
          enrollment.gradeId,
          orderedGradeIds,
        ),
      );
}

/// Pré-visualização: linhas e ordem das classes (para recalcular o destino
/// quando o utilizador muda a decisão).
class RenewalPreview {
  const RenewalPreview({required this.rows, required this.gradeOrder});

  final List<RenewalRow> rows;
  final List<String> gradeOrder;
}

/// Contagens da pré-visualização.
class RenewalSummary {
  const RenewalSummary({
    required this.promote,
    required this.repeat,
    required this.skipped,
  });

  factory RenewalSummary.of(Iterable<RenewalRow> rows) {
    var promote = 0, repeat = 0, skipped = 0;
    for (final r in rows) {
      if (!r.willRenew) {
        skipped++;
      } else if (r.action == RenewalAction.promote) {
        promote++;
      } else {
        repeat++;
      }
    }
    return RenewalSummary(promote: promote, repeat: repeat, skipped: skipped);
  }

  final int promote;
  final int repeat;
  final int skipped;

  int get total => promote + repeat;
}

/// Matrícula de origem recusada na aplicação (com motivo).
class RenewalSkip {
  const RenewalSkip({required this.enrollmentId, required this.reason});

  factory RenewalSkip.fromJson(Map<String, dynamic> json) => RenewalSkip(
    enrollmentId: json['enrollmentId'] as String,
    reason: json['reason'] as String,
  );

  final String enrollmentId;
  final String reason;
}

/// Resultado da aplicação.
class RenewalOutcome {
  const RenewalOutcome({required this.created, required this.skipped});

  factory RenewalOutcome.fromJson(Map<String, dynamic> json) => RenewalOutcome(
    created: [
      for (final e in json['created'] as List)
        EnrollmentModel.fromJson(e as Map<String, dynamic>),
    ],
    skipped: [
      for (final s in json['skipped'] as List)
        RenewalSkip.fromJson(s as Map<String, dynamic>),
    ],
  );

  final List<EnrollmentModel> created;
  final List<RenewalSkip> skipped;
}

/// Pedido de renovação de uma matrícula.
class RenewalItem {
  const RenewalItem({
    required this.enrollmentId,
    required this.action,
    required this.gradeId,
  });

  final String enrollmentId;
  final RenewalAction action;
  final String gradeId;

  Map<String, dynamic> toJson() => {
    'enrollmentId': enrollmentId,
    'action': renewalActionWire(action),
    'gradeId': gradeId,
  };
}

/// Ano lectivo candidato a origem/destino.
class RenewalYear {
  const RenewalYear({
    required this.id,
    required this.code,
    required this.status,
  });

  factory RenewalYear.fromJson(Map<String, dynamic> json) => RenewalYear(
    id: json['id'] as String,
    code: json['code'] as String,
    status: json['status'] as String,
  );

  final String id;
  final String code;

  /// `planned`, `active`, `closing` ou `closed`.
  final String status;
}
