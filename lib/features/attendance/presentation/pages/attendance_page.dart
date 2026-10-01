import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../academic/data/models/classroom_models.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../domain/attendance_rules.dart';
import '../widgets/attendance_alerts_tab.dart';
import '../widgets/attendance_justify_tab.dart';
import '../widgets/attendance_sheet_tab.dart';

/// Turma onde o utilizador pode ver/registar presenças.
typedef AttendanceOption = ({
  ClassroomModel classroom,
  bool canDaily,
  bool canLesson,
});

/// Presenças: registo por aula ou por dia, faltas por justificar e alertas.
/// A coordenação/secretaria vê todas as turmas; o professor só as suas
/// atribuições (o registo do dia só como director de turma).
class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  String? _classroomId;

  @override
  Widget build(BuildContext context) {
    final all = ref
        .watch(permissionServiceProvider)
        .canAny(attendanceRecordAllPermission);
    final optionsAsync = ref.watch(_optionsProvider(all));
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final gradeNames = {for (final g in grades) g.id: g.name};

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Presenças e faltas',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: optionsAsync.when(
                  skipLoadingOnReload: true,
                  loading: () => const SkeletonList(),
                  error: (e, _) => ErrorState(
                    failure: optionsAsync.failure ?? UnknownFailure(cause: e),
                    onRetry: () => ref.invalidate(_optionsProvider(all)),
                  ),
                  data: (options) => options.isEmpty
                      ? const EmptyState(
                          title: 'Sem turmas para registar presenças',
                          message:
                              'As turmas aparecem quando existirem atribuições.',
                        )
                      : _body(options, gradeNames, all),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(
    List<AttendanceOption> options,
    Map<String, String> gradeNames,
    bool all,
  ) {
    final current = options
        .where((o) => o.classroom.id == _classroomId)
        .firstOrNull;
    return DefaultTabController(
      length: all ? 3 : 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 280,
              child: DropdownButtonFormField<String>(
                key: const Key('attendance_classroom'),
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Turma'),
                initialValue: current?.classroom.id,
                items: [
                  for (final o in options)
                    DropdownMenuItem(
                      value: o.classroom.id,
                      child: Text(
                        '${gradeNames[o.classroom.gradeId] ?? ''} · '
                        '${o.classroom.name}',
                      ),
                    ),
                ],
                onChanged: (v) => setState(() => _classroomId = v),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TabBar(
            tabs: [
              const Tab(text: 'Registo'),
              const Tab(text: 'Alertas'),
              if (all) const Tab(text: 'Justificar'),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: current == null
                ? const EmptyState(title: 'Escolha a turma')
                : TabBarView(
                    children: [
                      AttendanceSheetTab(
                        key: ValueKey('sheet/${current.classroom.id}'),
                        option: current,
                      ),
                      AttendanceAlertsTab(
                        key: ValueKey('alerts/${current.classroom.id}'),
                        classroomId: current.classroom.id,
                        canConfigure: all,
                      ),
                      if (all)
                        AttendanceJustifyTab(
                          key: ValueKey('justify/${current.classroom.id}'),
                          classroomId: current.classroom.id,
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// Turmas disponíveis (`all` = coordenação/secretaria).
final _optionsProvider = FutureProvider.autoDispose
    .family<List<AttendanceOption>, bool>((ref, all) async {
      if (all) {
        final classrooms = await ref.watch(classroomListProvider.future);
        return [
          for (final c in classrooms)
            (classroom: c, canDaily: true, canLesson: true),
        ];
      }
      final mine = await ref.watch(myClassroomsProvider.future);
      return [
        for (final m in mine)
          (
            classroom: m.classroom,
            canDaily: m.isHomeroom,
            canLesson: m.assignments.isNotEmpty,
          ),
      ];
    }, retry: (_, _) => null);
