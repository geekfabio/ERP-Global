import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/export/export_contract.dart';
import '../../../../../core/modules/license_gate.dart';
import '../../../../../core/security/permission_providers.dart';
import '../../../../../core/widgets/layout/page_actions.dart';
import '../../../../../core/widgets/layout/page_header.dart';
import '../../../../../core/widgets/permissions/can.dart';
import '../../../../../core/widgets/table/export_button.dart';
import '../../../data/models/student_model.dart';
import '../../providers/student_export.dart';

/// Permissão para importar alunos (módulo `import_export`).
const studentsImportPermission = 'import_export.import.execute';

/// Cabeçalho da listagem: título e acções (exportar, importar, novo aluno),
/// cada uma só com a licença e a permissão necessárias.
class StudentsHeader extends ConsumerWidget {
  const StudentsHeader({super.key, required this.exportRows});

  /// Alunos da página visível a exportar (`null` enquanto não há dados).
  final List<StudentModel>? exportRows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canImport =
        ref.watch(enabledModulesProvider).contains('import_export') &&
        ref.watch(permissionServiceProvider).canAny(studentsImportPermission);
    final rows = exportRows;
    return PageHeader(
      title: 'Alunos',
      subtitle: 'Gestão completa dos alunos da instituição.',
      actions: [
        if (rows != null)
          ExportButton(
            permission: studentsExportPermission,
            dataset: () => ExportDataset.from<StudentModel>(
              title: 'Alunos',
              entity: 'students',
              permission: studentsExportPermission,
              columns: studentExportColumns,
              rows: rows,
            ),
          ),
        if (canImport)
          PageActionButton(
            PageAction(
              label: 'Importar',
              icon: Icons.upload_outlined,
              onPressed: () => context.go('/import-export'),
            ),
          ),
        Can(
          permission: 'students.record.create',
          child: PageActionButton(
            PageAction(
              label: 'Novo aluno',
              icon: Icons.add,
              primary: true,
              onPressed: () => context.go('/students/new'),
            ),
          ),
        ),
      ],
    );
  }
}
