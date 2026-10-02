import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_overview.freezed.dart';
part 'academic_overview.g.dart';

/// Totais da instituição no período. Percentagens em pontos inteiros (0–100);
/// `null` quando o módulo respectivo não está licenciado.
@freezed
abstract class AcademicTotals with _$AcademicTotals {
  const factory AcademicTotals({
    required int enrolled,
    required int active,
    required int occupancy,
    int? approvalRate,
    int? attendanceRate,
  }) = _AcademicTotals;

  factory AcademicTotals.fromJson(Map<String, dynamic> json) =>
      _$AcademicTotalsFromJson(json);
}

/// Linha do desdobramento por classe.
@freezed
abstract class AcademicGradeRow with _$AcademicGradeRow {
  const factory AcademicGradeRow({
    required String gradeId,
    required String label,
    required int enrolled,
    required int active,
    required int capacity,
    required int occupancy,
    int? approvalRate,
    int? attendanceRate,
  }) = _AcademicGradeRow;

  factory AcademicGradeRow.fromJson(Map<String, dynamic> json) =>
      _$AcademicGradeRowFromJson(json);
}

/// Resposta de `GET /v1/reports/academic-overview` (agregada no servidor).
@freezed
abstract class AcademicOverview with _$AcademicOverview {
  const factory AcademicOverview({
    required AcademicTotals totals,
    required List<AcademicGradeRow> rows,
    AcademicTotals? previous,
  }) = _AcademicOverview;

  factory AcademicOverview.fromJson(Map<String, dynamic> json) =>
      _$AcademicOverviewFromJson(json);
}

/// Filtros do dashboard académico (igualdade por valor).
typedef AcademicOverviewQuery = ({
  String yearId,
  String? termId,
  String? campusId,
  String? compareYearId,
  String? compareTermId,
});
