import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_paginator.dart';
import '../../data/models/student_model.dart';
import '../providers/student_list_providers.dart';
import '../providers/student_providers.dart';
import '../widgets/students_list/student_stats_strip.dart';
import '../widgets/students_list/students_filters.dart';
import '../widgets/students_list/students_header.dart';
import '../widgets/students_list/students_results.dart';

/// Listagem e pesquisa avançada de alunos (paginação e filtros no servidor).
/// A página guarda o estado (pesquisa com debounce, remoção auditada) e
/// compõe os componentes de `widgets/students_list/`. Faz scroll inteira,
/// para a tabela nunca ficar espremida em ecrãs baixos.
class StudentsListPage extends ConsumerStatefulWidget {
  const StudentsListPage({super.key});

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
        ref.invalidate(studentListStatsProvider);
      },
      err: (f) => toast.error(f.message),
    );
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
        // Conteúdo limitado (≤ 100 linhas por página): coluna simples com
        // scroll, para o paginador existir mesmo fora do ecrã.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StudentsHeader(exportRows: list.value?.items),
              const SizedBox(height: AppSpacing.xl),
              StudentsFilters(
                controller: _search,
                onSearch: _onSearchChanged,
                onClear: _clear,
              ),
              const SizedBox(height: AppSpacing.lg),
              const StudentStatsStrip(),
              const SizedBox(height: AppSpacing.lg),
              Card(
                clipBehavior: Clip.antiAlias,
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
                  data: (page) =>
                      StudentsResults(students: page.items, onDelete: _delete),
                ),
              ),
              if (list.value case final p?)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  child: AppPaginator(
                    page: p.meta.page,
                    pageSize: query.pageSize,
                    total: p.meta.total,
                    itemLabel: 'alunos',
                    onPage: notifier.setPage,
                    onPageSize: notifier.setPageSize,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
