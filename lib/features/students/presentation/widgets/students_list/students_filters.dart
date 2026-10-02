import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/mock/mock_reference_data.dart';
import '../../../../../core/widgets/inputs/filter_select.dart';
import '../../../../../core/widgets/layout/filter_panel.dart';
import '../../../data/models/student_enums.dart';
import '../../providers/student_list_providers.dart';
import '../student_display.dart';
import '../student_file/student_labels.dart';

/// Pesquisa (nome, processo, BI) e filtros combináveis da listagem. O texto
/// da pesquisa é da página (debounce); os filtros vão directos à query.
class StudentsFilters extends ConsumerWidget {
  const StudentsFilters({
    super.key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(studentListQueryProvider);
    final n = ref.read(studentListQueryProvider.notifier);
    final gradeId = query.gradeId;
    // Turmas (A, B, C) só fazem sentido com uma classe escolhida.
    final classrooms = gradeId == null
        ? const <String, String>{}
        : classroomsOf(gradeId);
    return FilterPanel(
      activeCount: [
        query.gradeId,
        query.classroomId,
        query.status,
        query.gender,
      ].whereType<Object>().length,
      onClear: n.hasFilters ? onClear : null,
      search: TextField(
        key: const Key('students_search'),
        controller: controller,
        onChanged: onSearch,
        decoration: const InputDecoration(
          labelText: 'Pesquisar por nome, processo ou BI',
          prefixIcon: Icon(Icons.search),
        ),
      ),
      filters: (width) => [
        FilterSelect<String>(
          fieldKey: const Key('filter_year'),
          width: width,
          label: 'Ano lectivo',
          icon: Icons.calendar_month_outlined,
          value: MockRef.academicYearId,
          options: const {MockRef.academicYearId: MockRef.academicYearLabel},
          onChanged: (_) {},
        ),
        FilterSelect<String>(
          fieldKey: const Key('filter_grade'),
          width: width,
          label: 'Classe',
          icon: Icons.school_outlined,
          value: query.gradeId,
          options: {
            for (var i = 0; i < MockRef.gradeCount; i++)
              MockRef.gradeId(i): MockRef.gradeLabel(i),
          },
          onChanged: n.setGrade,
        ),
        FilterSelect<String>(
          fieldKey: const Key('filter_classroom'),
          width: width,
          label: 'Turma',
          icon: Icons.groups_outlined,
          value: query.classroomId,
          enabled: classrooms.isNotEmpty,
          disabledHint: 'Escolha primeiro a classe',
          options: classrooms,
          onChanged: n.setClassroom,
        ),
        FilterSelect<StudentStatus>(
          fieldKey: const Key('filter_status'),
          width: width,
          label: 'Estado',
          icon: Icons.flag_outlined,
          value: query.status,
          options: {
            for (final s in StudentStatus.values) s: studentStatusLabel(s),
          },
          onChanged: n.setStatus,
        ),
        FilterSelect<Gender>(
          fieldKey: const Key('filter_gender'),
          width: width,
          label: 'Género',
          icon: Icons.wc_outlined,
          value: query.gender,
          options: {for (final g in Gender.values) g: genderLabel(g)},
          onChanged: n.setGender,
        ),
      ],
    );
  }
}
