import '../../../students/data/models/guardian_model.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/data/models/student_summaries_model.dart';

/// Educando visível no portal. [link] é `null` quando quem entra é o próprio
/// aluno (perfil `aluno`).
class PortalPupil {
  const PortalPupil({required this.student, this.link});

  factory PortalPupil.fromJson(Map<String, dynamic> json) => PortalPupil(
    student: StudentModel.fromJson(json['student'] as Map<String, dynamic>),
    link: json['link'] == null
        ? null
        : GuardianLinkModel.fromJson(json['link'] as Map<String, dynamic>),
  );

  final StudentModel student;
  final GuardianLinkModel? link;

  Map<String, dynamic> toJson() => {
    'student': student.toJson(),
    'link': link?.toJson(),
  };
}

/// Resumo do educando para a Home. Cada secção só vem preenchida se o módulo
/// respectivo foi pedido (isto é, está licenciado).
class PortalSummary {
  const PortalSummary({this.grades, this.attendance, this.finance, this.card});

  factory PortalSummary.fromJson(Map<String, dynamic> json) => PortalSummary(
    grades: _part(json['grades'], StudentGradesSummary.fromJson),
    attendance: _part(json['attendance'], StudentAttendanceSummary.fromJson),
    finance: _part(json['finance'], StudentFinanceSummary.fromJson),
    card: _part(json['card'], StudentCardSummary.fromJson),
  );

  static T? _part<T>(Object? raw, T Function(Map<String, dynamic>) fromJson) =>
      raw == null ? null : fromJson(raw as Map<String, dynamic>);

  final StudentGradesSummary? grades;
  final StudentAttendanceSummary? attendance;
  final StudentFinanceSummary? finance;
  final StudentCardSummary? card;
}
