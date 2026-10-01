import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/attendance_models.dart';

/// Identifica uma folha: turma + dia, e a aula quando o registo é por aula.
class AttendanceSheetKey {
  const AttendanceSheetKey({
    required this.classroomId,
    required this.date,
    this.lessonSlotId,
  });

  final String classroomId;
  final String date;
  final String? lessonSlotId;

  Map<String, dynamic> toJson() => {
    'classroomId': classroomId,
    'date': date,
    'lessonSlotId': ?lessonSlotId,
  };

  @override
  bool operator ==(Object other) =>
      other is AttendanceSheetKey &&
      other.classroomId == classroomId &&
      other.date == date &&
      other.lessonSlotId == lessonSlotId;

  @override
  int get hashCode => Object.hash(classroomId, date, lessonSlotId);
}

/// Presenças. Escrita com `attendance.record.write` (só turmas atribuídas ao
/// professor; o registo do dia exige ser director de turma) ou
/// `attendance.record.all`. Erros: 403 (turma não atribuída), 422 por aluno.
abstract interface class AttendanceRepository {
  Future<Result<AttendanceSheetModel>> sheet(AttendanceSheetKey key);

  /// Grava [rows] (um por aluno) e devolve a folha actualizada.
  Future<Result<AttendanceSheetModel>> save(
    AttendanceSheetKey key,
    List<AttendanceRecordModel> rows,
  );

  Future<Result<PagedList<AttendanceRecordModel>>> records({
    int page = 1,
    int pageSize = 100,
    String? classroomId,
    String? studentId,
    AttendanceStatus? status,
  });

  /// Justifica uma falta (`attendance.record.all`); 409 se não for falta.
  Future<Result<AttendanceRecordModel>> justify(String id, String reason);

  Future<Result<AttendanceSettingsModel>> settings();

  Future<Result<AttendanceSettingsModel>> updateSettings(
    AttendanceSettingsModel settings,
  );

  /// Alunos que atingiram o limite de faltas injustificadas.
  Future<Result<List<AttendanceAlertModel>>> alerts({String? classroomId});
}
