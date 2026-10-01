import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/audit/audit_repository.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/models/student_document_model.dart';
import '../../data/models/student_model.dart';
import '../../data/models/student_occurrence_model.dart';
import '../../data/models/student_summaries_model.dart';
import '../../domain/student_repositories.dart';
import 'student_providers.dart';

/// Aluno da ficha. Um `Failure` do repository chega à UI como `AsyncError`.
final studentProvider = FutureProvider.autoDispose.family<StudentModel, String>(
  (ref, id) async =>
      (await ref.watch(studentRepositoryProvider).get(id)).getOrThrow(),
  retry: (_, _) => null,
);

/// Encarregados do aluno, com o vínculo (parentesco e responsabilidades).
final studentGuardiansProvider = FutureProvider.autoDispose
    .family<List<StudentGuardian>, String>(
      (ref, studentId) async =>
          (await ref.watch(guardianRepositoryProvider).forStudent(studentId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Matrículas do aluno, da mais recente para a mais antiga.
final studentEnrollmentsProvider = FutureProvider.autoDispose
    .family<List<EnrollmentModel>, String>((ref, studentId) async {
      final page =
          (await ref
                  .watch(enrollmentRepositoryProvider)
                  .list(studentId: studentId, pageSize: 100))
              .getOrThrow();
      return [...page.items]
        ..sort((a, b) => b.enrolledOn.compareTo(a.enrolledOn));
    }, retry: (_, _) => null);

final studentDocumentsProvider = FutureProvider.autoDispose
    .family<List<StudentDocumentModel>, String>(
      (ref, studentId) async =>
          (await ref
                  .watch(studentDocumentRepositoryProvider)
                  .forStudent(studentId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

final studentOccurrencesProvider = FutureProvider.autoDispose
    .family<List<StudentOccurrenceModel>, String>(
      (ref, studentId) async =>
          (await ref.watch(occurrenceRepositoryProvider).forStudent(studentId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Vistas de outros módulos. Só são lidas por separadores que a ficha mostra
/// quando o módulo está licenciado; um `Failure` chega à UI como `AsyncError`.
final studentGradesProvider = FutureProvider.autoDispose
    .family<StudentGradesSummary, String>(
      (ref, id) async =>
          (await ref.watch(studentSummaryRepositoryProvider).grades(id))
              .getOrThrow(),
      retry: (_, _) => null,
    );

final studentAttendanceProvider = FutureProvider.autoDispose
    .family<StudentAttendanceSummary, String>(
      (ref, id) async =>
          (await ref.watch(studentSummaryRepositoryProvider).attendance(id))
              .getOrThrow(),
      retry: (_, _) => null,
    );

final studentFinanceProvider = FutureProvider.autoDispose
    .family<StudentFinanceSummary, String>(
      (ref, id) async =>
          (await ref.watch(studentSummaryRepositoryProvider).finance(id))
              .getOrThrow(),
      retry: (_, _) => null,
    );

final studentCardProvider = FutureProvider.autoDispose
    .family<StudentCardSummary, String>(
      (ref, id) async =>
          (await ref.watch(studentSummaryRepositoryProvider).card(id))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Linha temporal de auditoria do aluno (mais recentes primeiro).
final studentTimelineProvider = FutureProvider.autoDispose
    .family<List<AuditLogModel>, String>((ref, id) async {
      final page =
          (await ref
                  .watch(auditRepositoryProvider)
                  .list(AuditQuery(entity: 'student', q: id, pageSize: 100)))
              .getOrThrow();
      return [
        for (final l in page.items)
          if (l.entityId == id) l,
      ];
    }, retry: (_, _) => null);
