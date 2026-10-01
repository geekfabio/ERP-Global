import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/student_model.dart';
import '../pdf/student_pdf_templates.dart';
import '../providers/student_file_providers.dart';
import '../providers/student_pdf_providers.dart';
import '../widgets/student_file/student_file_tab.dart';
import 'students_list_page.dart';

/// Ficha do aluno: cabeçalho (foto, nome, estado, n.º de processo) e separadores
/// registados em [studentFileTabsProvider]. Cada separador só aparece com a
/// permissão de leitura respectiva e, se depender de outro módulo, licenciado.
class StudentFilePage extends ConsumerWidget {
  const StudentFilePage({super.key, required this.studentId, this.initialTab});

  final String studentId;

  /// `id` do separador a abrir (`?tab=guardians`).
  final String? initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider(studentId));
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: AsyncValueView<StudentModel>(
            value: student,
            onRetry: () => ref.invalidate(studentProvider(studentId)),
            data: (s) => _FileBody(student: s, initialTab: initialTab),
          ),
        ),
      ),
    );
  }
}

class _FileBody extends ConsumerWidget {
  const _FileBody({required this.student, this.initialTab});

  final StudentModel student;
  final String? initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final can = ref.watch(permissionServiceProvider);
    final modules = ref.watch(enabledModulesProvider);
    final tabs = [
      for (final t in ref.watch(studentFileTabsProvider))
        if (can.canAny(t.readPermission) &&
            (t.module == null || modules.contains(t.module)))
          t,
    ];
    final initial = tabs.indexWhere((t) => t.id == initialTab);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(student: student),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: tabs.isEmpty
              ? const EmptyState(
                  icon: Icons.lock_outline,
                  title: 'Sem acesso',
                  message: 'Não tem permissão para ver separadores da ficha.',
                )
              // A chave refaz o controlador se os separadores visíveis mudarem.
              : DefaultTabController(
                  key: ValueKey(tabs.map((t) => t.id).join(',')),
                  length: tabs.length,
                  initialIndex: initial < 0 ? 0 : initial,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        tabs: [
                          for (final t in tabs)
                            Tab(
                              key: Key('student_tab_${t.id}'),
                              icon: Icon(t.icon),
                              text: t.label,
                            ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            for (final t in tabs)
                              SingleChildScrollView(
                                key: Key('student_tab_body_${t.id}'),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.lg,
                                ),
                                child: t.builder(context, student),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    final canPrint = ref
        .watch(permissionServiceProvider)
        .canAny(studentsPdfPermission);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg),
      child: Row(
        children: [
          AppIconButton(
            icon: Icons.arrow_back,
            tooltip: 'Voltar aos alunos',
            onPressed: () => context.go('/students'),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppAvatar(
            name: student.fullName,
            imageUrl: student.photoUrl,
            radius: 32,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(student.fullName, style: text.headlineSmall),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.md,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('Processo n.º ${student.processNumber}'),
                    StatusBadge(
                      label: studentStatusLabel(student.status),
                      status: studentStatusBadge(student.status),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (canPrint)
            PopupMenuButton<StudentPdfKind>(
              key: const Key('student_pdf_menu'),
              tooltip: 'Documentos em PDF',
              icon: const Icon(Icons.picture_as_pdf_outlined),
              onSelected: (kind) =>
                  ref.read(studentPdfServiceProvider).export(student, kind),
              itemBuilder: (_) => [
                for (final kind in StudentPdfKind.values)
                  PopupMenuItem(
                    key: Key('student_pdf_${kind.name}'),
                    value: kind,
                    child: Text(kind.label),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
