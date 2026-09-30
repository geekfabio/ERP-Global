import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/student_enums.dart';
import '../../data/models/student_model.dart';
import '../providers/student_list_providers.dart';
import '../providers/student_providers.dart';

/// Nome apresentado de cada estado do aluno.
String studentStatusLabel(StudentStatus s) => switch (s) {
  StudentStatus.active => 'Activo',
  StudentStatus.inactive => 'Inactivo',
  StudentStatus.suspended => 'Suspenso',
  StudentStatus.transferred => 'Transferido',
  StudentStatus.graduated => 'Concluído',
  StudentStatus.dropout => 'Desistente',
};

BadgeStatus studentStatusBadge(StudentStatus s) => switch (s) {
  StudentStatus.active => BadgeStatus.success,
  StudentStatus.inactive => BadgeStatus.neutral,
  StudentStatus.suspended => BadgeStatus.warning,
  StudentStatus.transferred || StudentStatus.graduated => BadgeStatus.info,
  StudentStatus.dropout => BadgeStatus.danger,
};

/// Listagem e pesquisa avançada de alunos (paginação e filtros no servidor).
class StudentsListPage extends ConsumerStatefulWidget {
  const StudentsListPage({super.key, this.onExport});

  /// Hook de exportação: recebe os alunos da página visível. Por omissão avisa
  /// que a exportação chega com o módulo de importação/exportação.
  final void Function(List<StudentModel> students)? onExport;

  @override
  ConsumerState<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends ConsumerState<StudentsListPage> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(studentListQueryProvider.notifier).setSearch(text);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _search.clear();
    ref.read(studentListQueryProvider.notifier).clearFilters();
  }

  Future<void> _delete(StudentModel s) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Remover aluno',
      message:
          'Remover "${s.fullName}"? Esta acção pode ser revista na auditoria.',
      confirmLabel: 'Remover',
      destructive: true,
    );
    if (!ok || !mounted) return;
    final result = await ref.read(studentRepositoryProvider).delete(s.id);
    if (!mounted) return;
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) {
        // Acção sensível: fica em auditoria (falhar aqui não anula a remoção).
        unawaited(
          ref
              .read(auditServiceProvider)
              .record(
                entity: 'student',
                action: AuditAction.delete,
                entityId: s.id,
                before: s.toJson(),
              ),
        );
        toast.success('Aluno removido');
        ref.invalidate(studentListProvider);
      },
      err: (f) => toast.error(f.message),
    );
  }

  void _export(List<StudentModel> page) {
    final hook = widget.onExport;
    if (hook != null) {
      hook(page);
    } else {
      ref
          .read(toastProvider.notifier)
          .info('A exportação chega com o módulo de importação/exportação.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(studentListProvider);
    final query = ref.watch(studentListQueryProvider);
    final notifier = ref.read(studentListQueryProvider.notifier);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                onExport: list.value == null
                    ? null
                    : () => _export(list.value!.items),
              ),
              const SizedBox(height: AppSpacing.md),
              _Filters(
                controller: _search,
                onSearch: _onSearchChanged,
                onClear: _clear,
                showClear: notifier.hasFilters,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<PagedList<StudentModel>>(
                  value: list,
                  onRetry: () => ref.invalidate(studentListProvider),
                  isEmpty: (d) => d.items.isEmpty,
                  empty: EmptyState(
                    icon: Icons.person_search_outlined,
                    title: 'Nenhum aluno encontrado',
                    message: notifier.hasFilters
                        ? 'Experimente alterar ou limpar os filtros.'
                        : 'Ainda não há alunos registados.',
                    actionLabel: notifier.hasFilters ? 'Limpar filtros' : null,
                    onAction: notifier.hasFilters ? _clear : null,
                  ),
                  data: (page) => _Results(page: page, onDelete: _delete),
                ),
              ),
              list.when(
                data: (p) => _Paginator(
                  meta: p.meta,
                  pageSize: query.pageSize,
                  onPage: notifier.setPage,
                  onPageSize: notifier.setPageSize,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onExport});

  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.lg),
    child: Row(
      children: [
        Expanded(
          child: Text(
            'Alunos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        AppIconButton(
          icon: Icons.download_outlined,
          tooltip: 'Exportar',
          onPressed: onExport,
        ),
        const SizedBox(width: AppSpacing.sm),
        Can(
          permission: 'students.record.create',
          child: Builder(
            builder: (context) => AppButton(
              label: 'Novo aluno',
              icon: Icons.add,
              onPressed: () => context.go('/students/new'),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Filters extends ConsumerWidget {
  const _Filters({
    required this.controller,
    required this.onSearch,
    required this.onClear,
    required this.showClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final VoidCallback onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(studentListQueryProvider);
    final n = ref.read(studentListQueryProvider.notifier);
    // Turmas (A, B, C) só fazem sentido com uma classe escolhida.
    final gradeIndex = query.gradeId == null
        ? null
        : [
            for (var i = 0; i < MockRef.gradeCount; i++) MockRef.gradeId(i),
          ].indexOf(query.gradeId!);
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            key: const Key('students_search'),
            controller: controller,
            onChanged: onSearch,
            decoration: const InputDecoration(
              labelText: 'Pesquisar (nome, processo ou BI)',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        _Drop<String>(
          fieldKey: const Key('filter_year'),
          label: 'Ano lectivo',
          value: MockRef.academicYearId,
          options: const {MockRef.academicYearId: MockRef.academicYearLabel},
          onChanged: (_) {},
        ),
        _Drop<String>(
          fieldKey: const Key('filter_grade'),
          label: 'Classe',
          value: query.gradeId,
          options: {
            for (var i = 0; i < MockRef.gradeCount; i++)
              MockRef.gradeId(i): MockRef.gradeLabel(i),
          },
          onChanged: n.setGrade,
        ),
        _Drop<String>(
          fieldKey: const Key('filter_classroom'),
          label: 'Turma',
          value: query.classroomId,
          enabled: gradeIndex != null && gradeIndex >= 0,
          options: gradeIndex == null || gradeIndex < 0
              ? const {}
              : {
                  for (var l = 0; l < MockRef.classroomLetters.length; l++)
                    MockRef.classroomId(gradeIndex, l):
                        'Turma ${MockRef.classroomLetters[l]}',
                },
          onChanged: n.setClassroom,
        ),
        _Drop<StudentStatus>(
          fieldKey: const Key('filter_status'),
          label: 'Estado',
          value: query.status,
          options: {
            for (final s in StudentStatus.values) s: studentStatusLabel(s),
          },
          onChanged: n.setStatus,
        ),
        _Drop<Gender>(
          fieldKey: const Key('filter_gender'),
          label: 'Género',
          value: query.gender,
          options: const {Gender.male: 'Masculino', Gender.female: 'Feminino'},
          onChanged: n.setGender,
        ),
        if (showClear)
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.filter_alt_off_outlined),
            label: const Text('Limpar filtros'),
          ),
      ],
    );
  }
}

/// Selector com opção "Todos" (`null`).
class _Drop<T> extends StatelessWidget {
  const _Drop({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.enabled = true,
  });

  final Key fieldKey;
  final String label;
  final T? value;
  final Map<T, String> options;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 200,
    child: DropdownButtonFormField<T?>(
      key: fieldKey,
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem<T?>(value: null, child: const Text('Todos')),
        for (final e in options.entries)
          DropdownMenuItem<T?>(value: e.key, child: Text(e.value)),
      ],
      onChanged: enabled ? onChanged : null,
    ),
  );
}

class _Results extends ConsumerWidget {
  const _Results({required this.page, required this.onDelete});

  final PagedList<StudentModel> page;
  final Future<void> Function(StudentModel) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
    // O layout segue o espaço disponível (não o dispositivo).
    builder: (context, constraints) =>
        constraints.maxWidth >= AppBreakpoints.medium
        ? _Table(page: page, onDelete: onDelete)
        : _Cards(page: page, onDelete: onDelete),
  );
}

List<PopupMenuEntry<String>> _actionItems(WidgetRef ref) {
  // Chamado fora do `build` (itemBuilder do menu): lê, não observa.
  final can = ref.read(permissionServiceProvider);
  return [
    const PopupMenuItem(
      value: 'view',
      child: ListTile(
        leading: Icon(Icons.badge_outlined),
        title: Text('Ver ficha'),
      ),
    ),
    if (can.canAny('students.record.delete'))
      const PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete_outline),
          title: Text('Remover'),
        ),
      ),
  ];
}

class _RowMenu extends ConsumerWidget {
  const _RowMenu({required this.student, required this.onDelete});

  final StudentModel student;
  final Future<void> Function(StudentModel) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopupMenuButton<String>(
    tooltip: 'Acções',
    itemBuilder: (_) => _actionItems(ref),
    onSelected: (v) {
      if (v == 'view') context.go('/students/${student.id}');
      if (v == 'delete') onDelete(student);
    },
  );
}

class _Table extends ConsumerWidget {
  const _Table({required this.page, required this.onDelete});

  final PagedList<StudentModel> page;
  final Future<void> Function(StudentModel) onDelete;

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
    final sortIndex = field == null ? null : _sortable.indexOf(field);
    DataColumn col(String label, int i) => DataColumn(
      label: Text(label),
      onSort: _sortable[i] == null
          ? null
          : (_, _) => notifier.toggleSort(_sortable[i]!),
    );
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          sortColumnIndex: sortIndex == -1 ? null : sortIndex,
          sortAscending: sort == null || !sort.startsWith('-'),
          columns: [
            col('Processo', 0),
            col('Nome', 1),
            col('Género', 2),
            col('Nascimento', 3),
            col('Estado', 4),
            const DataColumn(label: Text('')),
          ],
          rows: [
            for (final s in page.items)
              DataRow(
                onSelectChanged: (_) => context.go('/students/${s.id}'),
                cells: [
                  DataCell(Text(s.processNumber)),
                  DataCell(Text(s.fullName)),
                  DataCell(Text(s.gender == Gender.male ? 'M' : 'F')),
                  DataCell(Text(PtAoFormatters.date(s.birthDate))),
                  DataCell(
                    StatusBadge(
                      label: studentStatusLabel(s.status),
                      status: studentStatusBadge(s.status),
                    ),
                  ),
                  DataCell(_RowMenu(student: s, onDelete: onDelete)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({required this.page, required this.onDelete});

  final PagedList<StudentModel> page;
  final Future<void> Function(StudentModel) onDelete;

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: page.items.length,
    itemBuilder: (context, i) {
      final s = page.items[i];
      return Card(
        child: ListTile(
          onTap: () => context.go('/students/${s.id}'),
          title: Text(s.fullName),
          subtitle: Text(
            '${s.processNumber} · ${PtAoFormatters.date(s.birthDate)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusBadge(
                label: studentStatusLabel(s.status),
                status: studentStatusBadge(s.status),
              ),
              _RowMenu(student: s, onDelete: onDelete),
            ],
          ),
        ),
      );
    },
  );
}

class _Paginator extends StatelessWidget {
  const _Paginator({
    required this.meta,
    required this.pageSize,
    required this.onPage,
    required this.onPageSize,
  });

  final PageMeta meta;
  final int pageSize;
  final ValueChanged<int> onPage;
  final ValueChanged<int> onPageSize;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      children: [
        Text('${meta.total} alunos'),
        DropdownButton<int>(
          value: const [10, 20, 50, 100].contains(pageSize) ? pageSize : null,
          items: [
            for (final s in const [10, 20, 50, 100])
              DropdownMenuItem(value: s, child: Text('$s / página')),
          ],
          onChanged: (v) => v == null ? null : onPageSize(v),
        ),
        IconButton(
          tooltip: 'Página anterior',
          icon: const Icon(Icons.chevron_left),
          onPressed: meta.page > 1 ? () => onPage(meta.page - 1) : null,
        ),
        Text('${meta.page} / ${meta.totalPages == 0 ? 1 : meta.totalPages}'),
        IconButton(
          tooltip: 'Página seguinte',
          icon: const Icon(Icons.chevron_right),
          onPressed: meta.hasNext ? () => onPage(meta.page + 1) : null,
        ),
      ],
    ),
  );
}
