import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enrollment_model.dart';
import '../../data/models/student_document_model.dart';
import '../../data/models/student_model.dart';
import '../../data/models/student_occurrence_model.dart';
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
