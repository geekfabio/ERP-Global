import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/student_model.dart';
import 'tabs/attendance_tab.dart';
import 'tabs/card_tab.dart';
import 'tabs/discipline_tab.dart';
import 'tabs/documents_tab.dart';
import 'tabs/enrollment_tab.dart';
import 'tabs/finance_tab.dart';
import 'tabs/grades_tab.dart';
import 'tabs/guardians_tab.dart';
import 'tabs/health_tab.dart';
import 'tabs/identification_tab.dart';
import 'tabs/pathway_tab.dart';
import 'tabs/timeline_tab.dart';

/// Descreve um separador da ficha do aluno. Para acrescentar um separador
/// (issues #35/#36) basta juntar um [StudentFileTab] a [defaultStudentFileTabs]:
/// a página trata do resto (menu, visibilidade por permissão/licença, estados).
class StudentFileTab {
  const StudentFileTab({
    required this.id,
    required this.label,
    required this.icon,
    required this.readPermission,
    required this.builder,
    this.module,
  });

  /// Identificador estável (usado em `?tab=`).
  final String id;
  final String label;
  final IconData icon;

  /// Sem esta permissão o separador não aparece.
  final String readPermission;

  /// Módulo de que o separador depende; se não estiver licenciado, o separador
  /// fica oculto. `null` = pertence ao módulo `students`.
  final String? module;

  /// Conteúdo. Recebe o aluno já carregado; a edição vive dentro do separador
  /// (ver `EditableSection`).
  final Widget Function(BuildContext context, StudentModel student) builder;
}

/// Separadores da ficha (#34, #35, #36), pela ordem do docs/03. Os que vêm de
/// outros módulos (`module`) só aparecem se o módulo estiver licenciado.
final defaultStudentFileTabs = <StudentFileTab>[
  StudentFileTab(
    id: 'identification',
    label: 'Identificação',
    icon: Icons.badge_outlined,
    readPermission: 'students.record.read',
    builder: (_, s) => IdentificationTab(student: s),
  ),
  StudentFileTab(
    id: 'guardians',
    label: 'Encarregados',
    icon: Icons.family_restroom_outlined,
    readPermission: 'students.record.read',
    builder: (_, s) => GuardiansTab(student: s),
  ),
  StudentFileTab(
    id: 'health',
    label: 'Saúde',
    icon: Icons.medical_services_outlined,
    readPermission: 'students.health.read',
    builder: (_, s) => HealthTab(student: s),
  ),
  StudentFileTab(
    id: 'pathway',
    label: 'Percurso',
    icon: Icons.timeline_outlined,
    readPermission: 'students.record.read',
    builder: (_, s) => PathwayTab(student: s),
  ),
  StudentFileTab(
    id: 'enrollment',
    label: 'Matrícula',
    icon: Icons.assignment_ind_outlined,
    readPermission: 'students.record.read',
    builder: (_, s) => EnrollmentTab(student: s),
  ),
  StudentFileTab(
    id: 'grades',
    label: 'Notas',
    icon: Icons.grading_outlined,
    readPermission: 'grades.entry.read',
    module: 'grades',
    builder: (_, s) => GradesTab(student: s),
  ),
  StudentFileTab(
    id: 'attendance',
    label: 'Assiduidade',
    icon: Icons.fact_check_outlined,
    readPermission: 'attendance.record.read',
    module: 'attendance',
    builder: (_, s) => AttendanceTab(student: s),
  ),
  StudentFileTab(
    id: 'finance',
    label: 'Financeiro',
    icon: Icons.payments_outlined,
    readPermission: 'billing.invoice.read',
    module: 'billing',
    builder: (_, s) => FinanceTab(student: s),
  ),
  StudentFileTab(
    id: 'discipline',
    label: 'Disciplina',
    icon: Icons.gavel_outlined,
    readPermission: 'students.record.read',
    builder: (_, s) => DisciplineTab(student: s),
  ),
  StudentFileTab(
    id: 'documents',
    label: 'Documentos',
    icon: Icons.folder_outlined,
    readPermission: 'students.record.read',
    builder: (_, s) => DocumentsTab(student: s),
  ),
  StudentFileTab(
    id: 'card',
    label: 'Cartão',
    icon: Icons.credit_card_outlined,
    readPermission: 'cards.card.read',
    module: 'cards',
    builder: (_, s) => CardTab(student: s),
  ),
  StudentFileTab(
    id: 'timeline',
    label: 'Histórico',
    icon: Icons.history_outlined,
    readPermission: 'students.audit.read',
    builder: (_, s) => TimelineTab(student: s),
  ),
];

/// Separadores registados; os testes (e futuros módulos) podem sobrepor.
final studentFileTabsProvider = Provider<List<StudentFileTab>>(
  (ref) => defaultStudentFileTabs,
);
