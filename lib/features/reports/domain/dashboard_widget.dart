import 'package:flutter/material.dart';

/// Como o valor de um indicador é apresentado.
enum MetricKind { count, money, percent }

/// Indicador que um módulo regista no framework de dashboards. Só aparece se
/// o [moduleCode] estiver licenciado e o perfil estiver em [profiles].
class DashboardWidgetSpec {
  const DashboardWidgetSpec({
    required this.id,
    required this.moduleCode,
    required this.title,
    required this.icon,
    required this.kind,
    required this.profiles,
  });

  final String id;
  final String moduleCode;
  final String title;
  final IconData icon;
  final MetricKind kind;

  /// Códigos de perfil (`direcao`, `financeiro`…) que o vêem.
  final Set<String> profiles;
}

/// Perfis com dashboard e o respectivo nome (docs/03-funcionalidades.md).
const dashboardProfiles = <String, String>{
  'direcao': 'Direcção',
  'secretaria': 'Secretaria',
  'coordenacao': 'Coordenação',
  'financeiro': 'Financeiro',
  'contabilista': 'Contabilidade',
  'refeitorio': 'Refeitório',
  'seguranca': 'Portaria',
  'rh': 'Recursos humanos',
  'professor': 'Professor',
  'diretor_turma': 'Director de turma',
  'bibliotecario': 'Biblioteca',
};

/// Perfil cujo dashboard se mostra: o primeiro papel com dashboard; o
/// `super_admin` vê o da direcção por omissão. `null` = sem dashboard.
String? dashboardProfileFor(List<String> roles) {
  for (final role in roles) {
    if (role == 'super_admin') return 'direcao';
    if (dashboardProfiles.containsKey(role)) return role;
  }
  return null;
}

const _board = 'direcao';

/// Catálogo de widgets, agrupado por módulo (cada módulo regista os seus).
const dashboardWidgetSpecs = <DashboardWidgetSpec>[
  DashboardWidgetSpec(
    id: 'students.enrolled',
    moduleCode: 'students',
    title: 'Alunos matriculados',
    icon: Icons.school_outlined,
    kind: MetricKind.count,
    profiles: {_board, 'secretaria', 'coordenacao'},
  ),
  DashboardWidgetSpec(
    id: 'students.class_occupancy',
    moduleCode: 'students',
    title: 'Ocupação das turmas',
    icon: Icons.groups_outlined,
    kind: MetricKind.percent,
    profiles: {_board, 'secretaria', 'coordenacao'},
  ),
  DashboardWidgetSpec(
    id: 'academic.approval_rate',
    moduleCode: 'academic',
    title: 'Taxa de aprovação',
    icon: Icons.task_alt_outlined,
    kind: MetricKind.percent,
    profiles: {_board, 'coordenacao', 'professor', 'diretor_turma'},
  ),
  DashboardWidgetSpec(
    id: 'attendance.rate',
    moduleCode: 'attendance',
    title: 'Assiduidade',
    icon: Icons.fact_check_outlined,
    kind: MetricKind.percent,
    profiles: {
      _board,
      'secretaria',
      'coordenacao',
      'professor',
      'diretor_turma',
    },
  ),
  DashboardWidgetSpec(
    id: 'billing.revenue',
    moduleCode: 'billing',
    title: 'Receita cobrada',
    icon: Icons.payments_outlined,
    kind: MetricKind.money,
    profiles: {_board, 'financeiro', 'contabilista'},
  ),
  DashboardWidgetSpec(
    id: 'billing.expected',
    moduleCode: 'billing',
    title: 'Receita prevista',
    icon: Icons.request_quote_outlined,
    kind: MetricKind.money,
    profiles: {_board, 'financeiro', 'contabilista'},
  ),
  DashboardWidgetSpec(
    id: 'billing.debt',
    moduleCode: 'billing',
    title: 'Dívida em aberto',
    icon: Icons.money_off_outlined,
    kind: MetricKind.money,
    profiles: {_board, 'financeiro'},
  ),
  DashboardWidgetSpec(
    id: 'billing.default_rate',
    moduleCode: 'billing',
    title: 'Inadimplência',
    icon: Icons.trending_down_outlined,
    kind: MetricKind.percent,
    profiles: {_board, 'financeiro'},
  ),
  DashboardWidgetSpec(
    id: 'cafeteria.meals',
    moduleCode: 'cafeteria',
    title: 'Refeições servidas',
    icon: Icons.restaurant_outlined,
    kind: MetricKind.count,
    profiles: {_board, 'refeitorio'},
  ),
  DashboardWidgetSpec(
    id: 'cafeteria.prepaid_balance',
    moduleCode: 'cafeteria',
    title: 'Saldo pré-pago',
    icon: Icons.account_balance_wallet_outlined,
    kind: MetricKind.money,
    profiles: {'refeitorio', 'financeiro'},
  ),
  DashboardWidgetSpec(
    id: 'access_control.entries',
    moduleCode: 'access_control',
    title: 'Acessos registados',
    icon: Icons.door_sliding_outlined,
    kind: MetricKind.count,
    profiles: {_board, 'seguranca'},
  ),
  DashboardWidgetSpec(
    id: 'hr.active_staff',
    moduleCode: 'hr',
    title: 'Funcionários activos',
    icon: Icons.badge_outlined,
    kind: MetricKind.count,
    profiles: {_board, 'rh'},
  ),
  DashboardWidgetSpec(
    id: 'library.active_loans',
    moduleCode: 'library',
    title: 'Empréstimos activos',
    icon: Icons.local_library_outlined,
    kind: MetricKind.count,
    profiles: {_board, 'bibliotecario'},
  ),
];

/// Widgets que [profile] pode ver com os módulos [enabledModules] licenciados.
List<DashboardWidgetSpec> visibleWidgets(
  String? profile,
  Set<String> enabledModules,
) => [
  for (final w in dashboardWidgetSpecs)
    if (profile != null &&
        w.profiles.contains(profile) &&
        enabledModules.contains(w.moduleCode))
      w,
];

/// Com que período se compara o actual.
enum CompareMode {
  none('Sem comparação'),
  previousTerm('Trimestre anterior'),
  previousYear('Ano lectivo anterior');

  const CompareMode(this.label);
  final String label;
}

/// Variação em %; nos indicadores `percent` é a diferença em pontos
/// percentuais. `null` sem valor anterior (ou 0 nos outros tipos).
double? deltaOf(MetricKind kind, int value, int? previous) {
  if (previous == null) return null;
  if (kind == MetricKind.percent) return (value - previous).toDouble();
  if (previous == 0) return null;
  return (value - previous) * 100 / previous;
}
