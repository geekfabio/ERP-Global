import '../../../core/security/permission_service.dart';

/// Permissão para consultar o catálogo e agendar relatórios.
const reportsCatalogPermission = 'reports.report.read';

/// Permissão para exportar um relatório (validada também no `ExportService`).
const reportsExportPermission = 'reports.report.export';

/// Coluna de um relatório; [permission] restringe-a (sem ela não sai).
class ReportColumnSpec {
  const ReportColumnSpec(this.key, this.label, {this.permission});

  final String key;
  final String label;
  final String? permission;
}

/// Relatório do catálogo. [dataPermission] é a permissão de leitura dos dados
/// de origem (âmbito aplicável); [moduleCode] tem de estar licenciado.
class ReportDefinition {
  const ReportDefinition({
    required this.id,
    required this.moduleCode,
    required this.title,
    required this.description,
    required this.dataPermission,
    required this.columns,
  });

  final String id;
  final String moduleCode;
  final String title;
  final String description;
  final String dataPermission;
  final List<ReportColumnSpec> columns;
}

const reportCatalog = <ReportDefinition>[
  ReportDefinition(
    id: 'students.roster',
    moduleCode: 'students',
    title: 'Lista de alunos por turma',
    description: 'Alunos matriculados, turma e estado da matrícula.',
    dataPermission: 'students.record.read',
    columns: [
      ReportColumnSpec('number', 'N.º'),
      ReportColumnSpec('name', 'Nome'),
      ReportColumnSpec('classroom', 'Turma'),
      ReportColumnSpec('campus', 'Campus'),
      ReportColumnSpec(
        'health',
        'Observações de saúde',
        permission: 'students.health.read',
      ),
    ],
  ),
  ReportDefinition(
    id: 'billing.debtors',
    moduleCode: 'billing',
    title: 'Devedores',
    description: 'Cobranças em atraso por aluno.',
    dataPermission: 'billing.invoice.read',
    columns: [
      ReportColumnSpec('student', 'Aluno'),
      ReportColumnSpec('campus', 'Campus'),
      ReportColumnSpec('invoices', 'Cobranças'),
      ReportColumnSpec('amount', 'Em dívida'),
    ],
  ),
  ReportDefinition(
    id: 'attendance.summary',
    moduleCode: 'attendance',
    title: 'Assiduidade por turma',
    description: 'Taxa de presenças e faltas por turma.',
    dataPermission: 'attendance.record.read',
    columns: [
      ReportColumnSpec('classroom', 'Turma'),
      ReportColumnSpec('campus', 'Campus'),
      ReportColumnSpec('present', 'Presenças (%)'),
      ReportColumnSpec('absences', 'Faltas'),
    ],
  ),
  ReportDefinition(
    id: 'academic.approvals',
    moduleCode: 'academic',
    title: 'Aprovações por classe',
    description: 'Aprovados e reprovados por classe.',
    dataPermission: 'academic.class.read',
    columns: [
      ReportColumnSpec('grade', 'Classe'),
      ReportColumnSpec('campus', 'Campus'),
      ReportColumnSpec('approved', 'Aprovados'),
      ReportColumnSpec('failed', 'Reprovados'),
    ],
  ),
  ReportDefinition(
    id: 'library.loans',
    moduleCode: 'library',
    title: 'Empréstimos da biblioteca',
    description: 'Empréstimos activos e em atraso.',
    dataPermission: 'library.loan.read',
    columns: [
      ReportColumnSpec('title', 'Título'),
      ReportColumnSpec('campus', 'Campus'),
      ReportColumnSpec('borrower', 'Leitor'),
      ReportColumnSpec('status', 'Estado'),
    ],
  ),
];

ReportDefinition? reportById(String id) {
  for (final r in reportCatalog) {
    if (r.id == id) return r;
  }
  return null;
}

/// Relatórios que a sessão pode ver: módulo licenciado ∩ permissão de dados.
List<ReportDefinition> visibleReports(
  PermissionService permissions,
  Set<String> enabledModules,
) => [
  for (final r in reportCatalog)
    if (enabledModules.contains(r.moduleCode) &&
        permissions.canAny(r.dataPermission))
      r,
];

/// A sessão pode correr [report] para [campusId]? Concessões restritas a um
/// campus só valem se o pedido indicar esse campus (âmbito).
bool canRunReport(
  PermissionService permissions,
  ReportDefinition report,
  String? campusId,
) => permissions.can(
  report.dataPermission,
  scope: campusId == null ? null : PermissionScope(campusId: campusId),
);

/// Sem acesso global ao relatório (só concessões por campus) o pedido tem de
/// indicar um campus permitido.
bool requiresCampus(PermissionService permissions, ReportDefinition report) =>
    !permissions.can(report.dataPermission);
