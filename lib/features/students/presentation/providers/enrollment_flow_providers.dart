import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_envelope.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/models/enrollment_rules_model.dart';
import '../../data/models/student_enums.dart';
import 'student_providers.dart';

/// Filtro de estado da fila de matrículas (`null` = todas).
class EnrollmentStatusFilter extends Notifier<EnrollmentStatus?> {
  @override
  EnrollmentStatus? build() => null;

  void set(EnrollmentStatus? value) => state = value;
}

final enrollmentStatusFilterProvider =
    NotifierProvider<EnrollmentStatusFilter, EnrollmentStatus?>(
      EnrollmentStatusFilter.new,
    );

final enrollmentQueueProvider =
    FutureProvider.autoDispose<PagedList<EnrollmentModel>>((ref) async {
      final status = ref.watch(enrollmentStatusFilterProvider);
      return (await ref
              .watch(enrollmentRepositoryProvider)
              .list(pageSize: 100, status: status))
          .getOrThrow();
    }, retry: (_, _) => null);

final enrollmentRulesProvider =
    FutureProvider.autoDispose<EnrollmentRulesModel>(
      (ref) async => (await ref.watch(enrollmentRulesRepositoryProvider).get())
          .getOrThrow(),
      retry: (_, _) => null,
    );

/// Vagas por turma de uma classe (`gradeId|academicYearId`).
final classroomVacanciesProvider = FutureProvider.autoDispose
    .family<List<ClassroomVacancy>, ({String gradeId, String yearId})>(
      (ref, k) async =>
          (await ref
                  .watch(enrollmentRepositoryProvider)
                  .vacancies(gradeId: k.gradeId, academicYearId: k.yearId))
              .getOrThrow(),
      retry: (_, _) => null,
    );
