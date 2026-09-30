import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/student_model.dart';
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
