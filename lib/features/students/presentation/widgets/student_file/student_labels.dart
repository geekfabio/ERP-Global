import '../../../../../core/network/mock/mock_reference_data.dart';
import '../../../data/models/student_enums.dart';

/// Nome da classe a partir do id de referência (o id cru se for desconhecido).
String gradeLabelFor(String gradeId) {
  for (var i = 0; i < MockRef.gradeCount; i++) {
    if (MockRef.gradeId(i) == gradeId) return MockRef.gradeLabel(i);
  }
  return gradeId;
}

String academicYearLabelFor(String yearId) =>
    yearId == MockRef.academicYearId ? MockRef.academicYearLabel : yearId;

/// Turmas (`id → "Turma A"`) da classe [gradeId].
Map<String, String> classroomsOf(String gradeId) {
  for (var i = 0; i < MockRef.gradeCount; i++) {
    if (MockRef.gradeId(i) != gradeId) continue;
    return {
      for (var l = 0; l < MockRef.classroomLetters.length; l++)
        MockRef.classroomId(i, l): 'Turma ${MockRef.classroomLetters[l]}',
    };
  }
  return const {};
}

const shiftLabels = {
  MockRef.morningShiftId: 'Manhã',
  MockRef.afternoonShiftId: 'Tarde',
};

String classroomLabelFor(String? gradeId, String? classroomId) =>
    classroomId == null
    ? '—'
    : classroomsOf(gradeId ?? '')[classroomId] ?? classroomId;

String enrollmentTypeLabel(EnrollmentType t) => switch (t) {
  EnrollmentType.newEnrollment => 'Nova matrícula',
  EnrollmentType.renewal => 'Renovação',
  EnrollmentType.transfer => 'Transferência (entrada)',
  EnrollmentType.reentry => 'Reingresso',
};

String enrollmentStatusLabel(EnrollmentStatus s) => switch (s) {
  EnrollmentStatus.application => 'Candidatura',
  EnrollmentStatus.underReview => 'Em análise',
  EnrollmentStatus.approved => 'Aprovada',
  EnrollmentStatus.rejected => 'Rejeitada',
  EnrollmentStatus.confirmed => 'Confirmada',
  EnrollmentStatus.cancelled => 'Anulada',
  EnrollmentStatus.completed => 'Concluída',
};

String documentTypeLabel(StudentDocumentType t) => switch (t) {
  StudentDocumentType.idCard => 'Bilhete de identidade',
  StudentDocumentType.birthCertificate => 'Cédula',
  StudentDocumentType.passport => 'Passaporte',
  StudentDocumentType.previousCertificate => 'Certificado anterior',
  StudentDocumentType.vaccination => 'Cartão de vacinas',
  StudentDocumentType.photo => 'Fotografia',
  StudentDocumentType.contract => 'Contrato',
  StudentDocumentType.other => 'Outro',
};

String occurrenceTypeLabel(OccurrenceType t) => switch (t) {
  OccurrenceType.praise => 'Elogio',
  OccurrenceType.warning => 'Advertência',
  OccurrenceType.incident => 'Incidente',
};
