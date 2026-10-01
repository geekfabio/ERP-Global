import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_models.freezed.dart';
part 'attendance_models.g.dart';

/// Estado de presença de um aluno. A falta justificada é uma falta
/// (`absent`) com justificação.
enum AttendanceStatus {
  @JsonValue('present')
  present,
  @JsonValue('late')
  late,
  @JsonValue('absent')
  absent,
}

/// Registo de presença (docs/06-modelo-de-dados.md): por dia (`lessonSlotId`
/// nulo, director de turma) ou por aula (`lessonSlotId` = aula do horário).
@freezed
abstract class AttendanceRecordModel with _$AttendanceRecordModel {
  const factory AttendanceRecordModel({
    /// Atribuído pelo servidor.
    @Default('') String id,
    required String classroomId,
    required String studentId,

    /// Dia (`AAAA-MM-DD`).
    required String date,

    /// Aula do horário; nulo = registo do dia.
    String? lessonSlotId,
    required AttendanceStatus status,

    /// Motivo da justificação (só faltas).
    String? justification,
  }) = _AttendanceRecordModel;

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);
}

/// Folha de presenças de uma turma num dia (ou numa aula).
@freezed
abstract class AttendanceSheetModel with _$AttendanceSheetModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AttendanceSheetModel({
    required String classroomId,
    required String date,
    String? lessonSlotId,
    @Default(<AttendanceRecordModel>[]) List<AttendanceRecordModel> rows,
  }) = _AttendanceSheetModel;

  factory AttendanceSheetModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSheetModelFromJson(json);
}

/// Definições do módulo: limite de faltas injustificadas que dispara o alerta.
@freezed
abstract class AttendanceSettingsModel with _$AttendanceSettingsModel {
  const factory AttendanceSettingsModel({@Default(10) int absenceLimit}) =
      _AttendanceSettingsModel;

  factory AttendanceSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSettingsModelFromJson(json);
}

/// Aluno que atingiu o limite de faltas injustificadas.
@freezed
abstract class AttendanceAlertModel with _$AttendanceAlertModel {
  const factory AttendanceAlertModel({
    required String studentId,
    required String classroomId,
    required int unjustified,
    required int limit,
  }) = _AttendanceAlertModel;

  factory AttendanceAlertModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceAlertModelFromJson(json);
}
