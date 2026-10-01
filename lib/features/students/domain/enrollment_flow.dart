import '../../../core/errors/result.dart';
import '../../../core/events/domain_event.dart';
import '../data/models/enrollment_model.dart';
import '../data/models/enrollment_rules_model.dart';
import '../data/models/student_document_model.dart';
import '../data/models/student_enums.dart';
import 'student_repositories.dart';

/// Transições permitidas (só para a frente; rejeitar/anular antes de concluir).
const enrollmentTransitions = <EnrollmentStatus, Set<EnrollmentStatus>>{
  EnrollmentStatus.application: {
    EnrollmentStatus.underReview,
    EnrollmentStatus.rejected,
    EnrollmentStatus.cancelled,
  },
  EnrollmentStatus.underReview: {
    EnrollmentStatus.approved,
    EnrollmentStatus.rejected,
    EnrollmentStatus.cancelled,
  },
  EnrollmentStatus.approved: {
    EnrollmentStatus.confirmed,
    EnrollmentStatus.rejected,
    EnrollmentStatus.cancelled,
  },
  EnrollmentStatus.confirmed: {
    EnrollmentStatus.completed,
    EnrollmentStatus.cancelled,
  },
};

bool canTransitionEnrollment(EnrollmentStatus from, EnrollmentStatus to) =>
    enrollmentTransitions[from]?.contains(to) ?? false;

/// Passo seguinte do caminho feliz (`null` nos estados finais).
EnrollmentStatus? nextEnrollmentStatus(EnrollmentStatus from) => switch (from) {
  EnrollmentStatus.application => EnrollmentStatus.underReview,
  EnrollmentStatus.underReview => EnrollmentStatus.approved,
  EnrollmentStatus.approved => EnrollmentStatus.confirmed,
  _ => null,
};

/// Estados que ocupam vaga.
bool occupiesSeat(EnrollmentStatus s) =>
    s == EnrollmentStatus.approved || s == EnrollmentStatus.confirmed;

/// Anos completos em [on].
int ageOn(DateTime birthDate, DateTime on) {
  var age = on.year - birthDate.year;
  if (on.month < birthDate.month ||
      (on.month == birthDate.month && on.day < birthDate.day)) {
    age--;
  }
  return age;
}

/// Valor JSON do tipo de matrícula.
String enrollmentTypeWire(EnrollmentType t) => switch (t) {
  EnrollmentType.newEnrollment => 'new_enrollment',
  EnrollmentType.renewal => 'renewal',
  EnrollmentType.transfer => 'transfer',
  EnrollmentType.reentry => 'reentry',
};

/// Documentos obrigatórios para [type] ainda não entregues (ou verificados).
List<StudentDocumentType> missingDocuments({
  required EnrollmentType type,
  required List<StudentDocumentModel> documents,
  required EnrollmentRulesModel rules,
}) {
  final required =
      rules.requiredDocuments[enrollmentTypeWire(type)] ?? const [];
  return [
    for (final t in required)
      if (!documents.any(
        (d) =>
            d.deletedAt == null &&
            d.type == t &&
            (!rules.requireVerifiedDocuments || d.verified),
      ))
        t,
  ];
}

/// Violações das regras ao passar [enrollment] para [to]; vazio = permitido.
/// Chave = campo (`status`, `age`, `documents`, `classroomId`).
/// [seatsFree]: a turma indicada (ou, sem turma, a classe) tem vaga.
Map<String, String> enrollmentViolations({
  required EnrollmentModel enrollment,
  required EnrollmentStatus to,
  required DateTime birthDate,
  required List<StudentDocumentModel> documents,
  required EnrollmentRulesModel rules,
  required bool seatsFree,
  String? classroomId,
}) {
  if (!canTransitionEnrollment(enrollment.status, to)) {
    return {
      'status': 'Transição inválida: ${enrollment.status.name} → ${to.name}',
    };
  }
  final fields = <String, String>{};
  if (to == EnrollmentStatus.approved) {
    final age = ageOn(birthDate, enrollment.enrolledOn);
    if (enrollment.type != EnrollmentType.renewal && age < rules.minAgeYears) {
      fields['age'] =
          'Idade mínima ${rules.minAgeYears} anos (o aluno tem $age)';
    }
    final missing = missingDocuments(
      type: enrollment.type,
      documents: documents,
      rules: rules,
    );
    if (missing.isNotEmpty) {
      fields['documents'] =
          'Documentos em falta: ${missing.map((d) => d.name).join(', ')}';
    }
    if (!seatsFree) fields['classroomId'] = 'Sem vagas na classe';
  }
  if (to == EnrollmentStatus.confirmed) {
    if ((classroomId ?? enrollment.classroomId) == null) {
      fields['classroomId'] = 'Atribua uma turma antes de confirmar';
    } else if (!seatsFree) {
      fields['classroomId'] = 'A turma não tem vagas';
    }
  }
  return fields;
}

/// Orquestra as transições no repository e publica `EnrollmentConfirmed`
/// (billing/cards consomem o evento).
class EnrollmentWorkflow {
  EnrollmentWorkflow(this._repository, this._bus);

  final EnrollmentRepository _repository;
  final DomainEventBus _bus;

  Future<Result<EnrollmentModel>> transition(
    String id,
    EnrollmentStatus to, {
    String? classroomId,
  }) async {
    final result = await _repository.transition(
      id,
      to,
      classroomId: classroomId,
    );
    result.when(
      ok: (e) {
        final room = e.classroomId;
        if (to == EnrollmentStatus.confirmed &&
            e.status == EnrollmentStatus.confirmed &&
            room != null) {
          _bus.publish(
            EnrollmentConfirmed(
              enrollmentId: e.id,
              studentId: e.studentId,
              academicYearId: e.academicYearId,
              gradeId: e.gradeId,
              classroomId: room,
              type: enrollmentTypeWire(e.type),
              feeMinor: e.feeMinor,
              occurredAt: DateTime.now().toUtc(),
            ),
          );
        }
      },
      err: (_) {},
    );
    return result;
  }
}
