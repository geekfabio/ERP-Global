/// Resultado de um relatório: chaves das colunas e linhas de texto.
class ReportResult {
  const ReportResult({
    required this.reportId,
    required this.columnKeys,
    required this.rows,
  });

  factory ReportResult.fromJson(Map<String, dynamic> json) => ReportResult(
    reportId: json['reportId'] as String,
    columnKeys: (json['columns'] as List).cast<String>(),
    rows: [for (final r in json['rows'] as List) (r as List).cast<String>()],
  );

  final String reportId;
  final List<String> columnKeys;
  final List<List<String>> rows;
}

enum ScheduleFrequency {
  daily('Diária'),
  weekly('Semanal'),
  monthly('Mensal');

  const ScheduleFrequency(this.label);
  final String label;
}

/// Agendamento de um relatório (mock: o servidor só calcula `nextRunAt`).
class ReportSchedule {
  const ReportSchedule({
    required this.id,
    required this.reportId,
    required this.frequency,
    required this.format,
    required this.nextRunAt,
    required this.active,
    this.campusId,
  });

  factory ReportSchedule.fromJson(Map<String, dynamic> json) => ReportSchedule(
    id: json['id'] as String,
    reportId: json['reportId'] as String,
    frequency: ScheduleFrequency.values.byName(json['frequency'] as String),
    format: json['format'] as String,
    nextRunAt: DateTime.parse(json['nextRunAt'] as String),
    active: json['active'] as bool,
    campusId: json['campusId'] as String?,
  );

  final String id;
  final String reportId;
  final ScheduleFrequency frequency;

  /// Extensão do formato de exportação: `csv`, `xlsx` ou `pdf`.
  final String format;
  final DateTime nextRunAt;
  final bool active;
  final String? campusId;
}
