import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/student_model.dart';
import 'tabs/guardians_tab.dart';
import 'tabs/health_tab.dart';
import 'tabs/identification_tab.dart';

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

/// Separadores 1–3 (#34). #35 e #36 acrescentam os restantes aqui.
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
];

/// Separadores registados; os testes (e futuros módulos) podem sobrepor.
final studentFileTabsProvider = Provider<List<StudentFileTab>>(
  (ref) => defaultStudentFileTabs,
);
