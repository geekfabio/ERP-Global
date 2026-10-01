import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../../settings/data/models/term_model.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/domain/student_repositories.dart';
import '../../../students/presentation/providers/student_providers.dart';
import '../../data/mock_api/grade_entry_mock_handlers.dart';
import '../../data/mock_api/grades_mock_handlers.dart';
import '../../data/models/grade_sheet_models.dart';
import '../../data/repositories/api_assessment_scheme_repository.dart';
import '../../data/repositories/api_grade_entry_repository.dart';
import '../../domain/assessment_scheme_repository.dart';
import '../../domain/grade_entry_repository.dart';

final assessmentSchemeRepositoryProvider = Provider<AssessmentSchemeRepository>(
  (ref) => ApiAssessmentSchemeRepository(ref.watch(apiClientProvider)),
);

final gradeEntryRepositoryProvider = Provider<GradeEntryRepository>(
  (ref) => ApiGradeEntryRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
/// O estado dos trimestres vem do módulo académico, como no servidor real.
final gradesMockHandlersProvider = Provider<GradesMockHandlers>(
  (ref) => GradesMockHandlers(
    permissions: () => ref.read(permissionServiceProvider),
    access: (classroomId, subjectId) async {
      final mine = await ref.read(myClassroomsProvider.future);
      return mine.any(
        (m) =>
            m.classroom.id == classroomId &&
            m.assignments.any((a) => a.subjectId == subjectId),
      );
    },
    termLookup: (termId) async {
      final repository = ref.read(academicRepositoryProvider);
      final years = (await repository.years()).valueOrNull?.items ?? const [];
      for (final year in years) {
        final terms = (await repository.terms(year.id)).valueOrNull ?? const [];
        for (final t in terms) {
          if (t.id == termId) {
            return GradeTermInfo(
              closed: t.status == TermStatus.closed,
              deadline: t.gradesDeadline,
            );
          }
        }
      }
      return null;
    },
  ),
);

final gradeSheetProvider = FutureProvider.autoDispose
    .family<GradeSheetModel, GradeSheetKey>(
      (ref, key) async =>
          (await ref.watch(gradeEntryRepositoryProvider).sheet(key))
              .getOrThrow(),
      retry: (_, _) => null,
    );

final gradeChangesProvider = FutureProvider.autoDispose
    .family<List<GradeChangeModel>, GradeSheetKey>(
      (ref, key) async =>
          (await ref.watch(gradeEntryRepositoryProvider).changes(key))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Alunos da turma (ordem alfabética), para a grelha.
final classroomRosterProvider = FutureProvider.autoDispose
    .family<List<StudentModel>, String>((ref, classroomId) async {
      final repository = ref.watch(studentRepositoryProvider);
      final students = <StudentModel>[];
      var page = 1;
      while (true) {
        final result = (await repository.list(
          StudentQuery(page: page++, pageSize: 100, classroomId: classroomId),
        )).getOrThrow();
        students.addAll(result.items);
        if (!result.meta.hasNext) return students;
      }
    }, retry: (_, _) => null);

/// Grava notas e audita a alteração (a auditoria nunca anula a gravação).
class GradeEntryActions {
  GradeEntryActions(this._ref);

  final Ref _ref;

  Future<Result<GradeSheetModel>> save(
    GradeSheetKey key,
    GradeSheetModel current,
    List<GradeRowModel> rows, {
    String? justification,
  }) async {
    final result = await _ref
        .read(gradeEntryRepositoryProvider)
        .save(key, rows, justification: justification);
    if (result case Ok(:final value)) {
      await _ref
          .read(auditServiceProvider)
          .record(
            entity: 'grade',
            action: current.locked ? AuditAction.approve : AuditAction.update,
            entityId: '${key.classroomId}/${key.subjectId}/${key.termId}',
            before: {
              'rows': [for (final r in current.rows) r.toJson()],
              'locked': current.locked,
            },
            after: {
              'rows': [for (final r in value.rows) r.toJson()],
              'justification': ?justification,
            },
          );
      _ref
        ..invalidate(gradeSheetProvider(key))
        ..invalidate(gradeChangesProvider(key));
    }
    return result;
  }
}

final gradeEntryActionsProvider = Provider<GradeEntryActions>(
  GradeEntryActions.new,
);
