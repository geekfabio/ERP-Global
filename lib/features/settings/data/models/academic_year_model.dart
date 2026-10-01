import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'academic_year_model.freezed.dart';
part 'academic_year_model.g.dart';

/// Estado do ano lectivo: `planned → active → closing → closed` (valores em
/// `snake_case` no JSON).
@JsonEnum(fieldRename: FieldRename.snake)
enum AcademicYearStatus { planned, active, closing, closed }

/// Ano lectivo de um campus (docs/03 · Estrutura académica).
@freezed
abstract class AcademicYearModel with _$AcademicYearModel {
  const factory AcademicYearModel({
    required String id,
    required String institutionId,
    required String campusId,

    /// `2026/2027`.
    required String code,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,
    required AcademicYearStatus status,
  }) = _AcademicYearModel;

  factory AcademicYearModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicYearModelFromJson(json);
}
