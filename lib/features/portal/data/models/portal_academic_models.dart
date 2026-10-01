/// Aula do horário do educando (leitura).
class PortalScheduleSlot {
  const PortalScheduleSlot({
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.subject,
    this.teacher,
  });

  factory PortalScheduleSlot.fromJson(Map<String, dynamic> json) =>
      PortalScheduleSlot(
        weekday: json['weekday'] as int,
        startTime: json['startTime'] as String,
        endTime: json['endTime'] as String,
        subject: json['subject'] as String,
        teacher: json['teacher'] as String?,
      );

  /// ISO: 1 = segunda ... 6 = sábado.
  final int weekday;

  /// `HH:mm`.
  final String startTime;
  final String endTime;
  final String subject;
  final String? teacher;
}

/// Estado de um pedido tratado pela secretaria.
enum PortalRequestStatus {
  pending('Pendente'),
  approved('Aprovado'),
  rejected('Rejeitado');

  const PortalRequestStatus(this.label);

  final String label;

  static PortalRequestStatus parse(String? name) => values.firstWhere(
    (s) => s.name == name,
    orElse: () => PortalRequestStatus.pending,
  );
}

/// Pedido de justificação de uma falta (a secretaria decide).
class AbsenceJustificationRequest {
  const AbsenceJustificationRequest({
    required this.id,
    required this.studentId,
    required this.date,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  factory AbsenceJustificationRequest.fromJson(Map<String, dynamic> json) =>
      AbsenceJustificationRequest(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        date: DateTime.parse(json['date'] as String),
        reason: json['reason'] as String,
        status: PortalRequestStatus.parse(json['status'] as String?),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final String id;
  final String studentId;

  /// Dia da falta (só data).
  final DateTime date;
  final String reason;
  final PortalRequestStatus status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'date': date.toIso8601String().substring(0, 10),
    'reason': reason,
    'status': status.name,
    'createdAt': createdAt.toUtc().toIso8601String(),
  };
}

/// Tipos de documento que o portal pode pedir à secretaria.
enum PortalDocumentKind {
  enrollmentDeclaration('enrollment_declaration', 'Declaração de matrícula'),
  gradesDeclaration('grades_declaration', 'Declaração de notas'),
  attendanceDeclaration('attendance_declaration', 'Declaração de assiduidade');

  const PortalDocumentKind(this.code, this.label);

  final String code;
  final String label;

  static PortalDocumentKind? parse(String? code) =>
      values.where((k) => k.code == code).firstOrNull;
}

/// Pedido de documento à secretaria.
class PortalDocumentRequest {
  const PortalDocumentRequest({
    required this.id,
    required this.studentId,
    required this.kind,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  factory PortalDocumentRequest.fromJson(Map<String, dynamic> json) =>
      PortalDocumentRequest(
        id: json['id'] as String,
        studentId: json['studentId'] as String,
        kind:
            PortalDocumentKind.parse(json['kind'] as String?) ??
            PortalDocumentKind.enrollmentDeclaration,
        status: PortalRequestStatus.parse(json['status'] as String?),
        createdAt: DateTime.parse(json['createdAt'] as String),
        notes: json['notes'] as String?,
      );

  final String id;
  final String studentId;
  final PortalDocumentKind kind;
  final PortalRequestStatus status;
  final DateTime createdAt;
  final String? notes;

  Map<String, dynamic> toJson() => {
    'id': id,
    'studentId': studentId,
    'kind': kind.code,
    'status': status.name,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'notes': notes,
  };
}
