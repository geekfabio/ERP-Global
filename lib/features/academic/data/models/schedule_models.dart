import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_models.freezed.dart';
part 'schedule_models.g.dart';

/// Aula no horário semanal: turma × disciplina × professor × sala num dia e
/// intervalo `HH:mm` (docs/06-modelo-de-dados.md).
@freezed
abstract class ScheduleSlotModel with _$ScheduleSlotModel {
  const factory ScheduleSlotModel({
    required String id,

    /// Derivado da turma pelo servidor.
    @Default('') String academicYearId,
    required String classroomId,
    required String subjectId,
    required String teacherId,
    required String roomId,

    /// Dia da semana ISO: 1 = segunda ... 6 = sábado.
    required int weekday,
    required String startTime,
    required String endTime,
  }) = _ScheduleSlotModel;

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleSlotModelFromJson(json);
}
