import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'term_model.freezed.dart';
part 'term_model.g.dart';

enum TermStatus { open, closed }

/// Período lectivo (trimestre, bimestre ou semestre) de um ano lectivo.
@freezed
abstract class TermModel with _$TermModel {
  const factory TermModel({
    required String id,
    required String academicYearId,
    required String name,
    required int order,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,

    /// Último dia para lançar notas neste período.
    @DateOnlyConverter() required DateTime gradesDeadline,
    required TermStatus status,

    /// Quando foi fechado pela última vez; `null` se nunca foi aberto/fechado
    /// (abrir um período já fechado é uma reabertura e exige `approve`).
    @UtcDateTimeConverter() DateTime? closedAt,
  }) = _TermModel;

  factory TermModel.fromJson(Map<String, dynamic> json) =>
      _$TermModelFromJson(json);
}
