import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../core/widgets/person_label.dart';
import '../../../data/models/student_model.dart';
import '../../providers/student_list_providers.dart';
import '../student_display.dart';
import 'student_row_menu.dart';

/// Tabela de alunos (espaço largo). Ordenação no servidor ao tocar no
/// cabeçalho; tocar numa linha abre a ficha.
class StudentsTable extends ConsumerWidget {
  const StudentsTable({
    super.key,
    required this.students,
    required this.onDelete,
  });

  final List<StudentModel> students;
  final ValueChanged<StudentModel> onDelete;

  /// Campo de ordenação de cada coluna (`null` = não ordenável).
  static const _sortable = [
    'processNumber',
    'fullName',
    null,
    'birthDate',
    null,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(studentListQueryProvider);
    final notifier = ref.read(studentListQueryProvider.notifier);
    final sort = query.sort.isEmpty ? null : query.sort.first;
    final field = sort?.replaceFirst('-', '');
    final sortIndex = field == null ? -1 : _sortable.indexOf(field);
    // Algarismos de largura fixa: processos e datas alinham em coluna.
    final mono = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    DataColumn col(String label, int i) => DataColumn(
      label: Text(label),
      onSort: _sortable[i] == null
          ? null
          : (_, _) => notifier.toggleSort(_sortable[i]!),
    );
    return LayoutBuilder(
      // Ocupa a largura do cartão e faz scroll horizontal se não couber.
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: DataTable(
            showCheckboxColumn: false,
            headingRowColor: WidgetStatePropertyAll(
              Theme.of(context).colorScheme.surfaceContainerLow,
            ),
            dataRowMinHeight: 56,
            dataRowMaxHeight: 64,
            sortColumnIndex: sortIndex == -1 ? null : sortIndex,
            sortAscending: sort == null || !sort.startsWith('-'),
            columns: [
              col('Processo', 0),
              col('Nome', 1),
              col('Género', 2),
              col('Nascimento', 3),
              col('Estado', 4),
              const DataColumn(label: Text('Acções')),
            ],
            rows: [
              for (final s in students)
                DataRow(
                  onSelectChanged: (_) => context.go('/students/${s.id}'),
                  cells: [
                    DataCell(Text(s.processNumber, style: mono)),
                    DataCell(
                      PersonLabel(name: s.fullName, photoUrl: s.photoUrl),
                    ),
                    DataCell(StudentGenderLabel(s.gender)),
                    DataCell(
                      Text(PtAoFormatters.date(s.birthDate), style: mono),
                    ),
                    DataCell(StudentStatusBadge(s.status)),
                    DataCell(StudentRowMenu(student: s, onDelete: onDelete)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
