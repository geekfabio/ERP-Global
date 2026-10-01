import 'package:freezed_annotation/freezed_annotation.dart';

part 'teacher_models.freezed.dart';
part 'teacher_models.g.dart';

/// Professor (modelo mínimo; o módulo `hr` poderá substituí-lo por Employee).
@freezed
abstract class TeacherModel with _$TeacherModel {
  const factory TeacherModel({
    required String id,

    /// Número de funcionário; atribuído pelo servidor na criação.
    @Default('') String employeeNumber,
    required String fullName,
    required String email,
    @Default('') String phone,

    /// Área de formação (ex.: `Licenciatura em Matemática`).
    @Default('') String specialty,

    /// Disciplinas que lecciona.
    @Default(<String>[]) List<String> subjectIds,

    /// Turmas atribuídas (Professor ↔ Turma).
    @Default(<String>[]) List<String> classroomIds,
    @Default(true) bool isActive,
  }) = _TeacherModel;

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);
}
