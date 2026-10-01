import 'package:freezed_annotation/freezed_annotation.dart';

part 'classroom_models.freezed.dart';
part 'classroom_models.g.dart';

/// Sala física (capacidade em lugares).
@freezed
abstract class RoomModel with _$RoomModel {
  const factory RoomModel({
    required String id,
    required String code,
    required String name,
    required int capacity,
    @Default(true) bool isActive,
  }) = _RoomModel;

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);
}

/// Turno (Manhã, Tarde, Noite) com horas `HH:mm`.
@freezed
abstract class ShiftModel with _$ShiftModel {
  const factory ShiftModel({
    required String id,
    required String name,
    required String startTime,
    required String endTime,
    @Default(true) bool isActive,
  }) = _ShiftModel;

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
}

/// Turma de um ano lectivo: classe × curso, turno e sala, com vagas.
@freezed
abstract class ClassroomModel with _$ClassroomModel {
  const factory ClassroomModel({
    required String id,
    required String academicYearId,
    required String gradeId,
    required String courseId,
    required String shiftId,
    required String roomId,

    /// Designação da turma dentro da classe (ex.: `A`).
    required String name,

    /// Vagas (lotação máxima da turma).
    required int capacity,

    /// Alunos matriculados; gerido pelo servidor (só leitura para a UI).
    @Default(0) int enrolledCount,
  }) = _ClassroomModel;

  factory ClassroomModel.fromJson(Map<String, dynamic> json) =>
      _$ClassroomModelFromJson(json);
}

extension ClassroomModelX on ClassroomModel {
  int get freeSeats => capacity - enrolledCount;
}
