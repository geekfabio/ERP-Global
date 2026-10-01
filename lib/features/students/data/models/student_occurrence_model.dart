import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'student_enums.dart';

part 'student_occurrence_model.freezed.dart';
part 'student_occurrence_model.g.dart';

/// Ocorrência de comportamento do aluno: elogio, advertência ou incidente.
@freezed
abstract class StudentOccurrenceModel with _$StudentOccurrenceModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentOccurrenceModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required OccurrenceType type,
    @DateOnlyConverter() required DateTime occurredOn,
    required String title,
    String? description,

    /// Id do utilizador que registou a ocorrência.
    String? reportedBy,
  }) = _StudentOccurrenceModel;

  factory StudentOccurrenceModel.fromJson(Map<String, dynamic> json) =>
      _$StudentOccurrenceModelFromJson(json);
}
